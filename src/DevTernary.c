/* DevTernary.c - VirtualBox PDM Device for Ternary Coprocessor */
#include <VBox/vmm/pdmdev.h>
#include <VBox/log.h>
#include <iprt/assert.h>
#include <iprt/string.h>
#include <iprt/mem.h>

/* MMIO Region Size and Register Offsets */
#define TERNARY_MMIO_SIZE 0x100
#define TERNARY_REG_INPUT 0x00    // Input trit array (16 trits)
#define TERNARY_REG_OUTPUT 0x04   // Output trit array (16 trits)
#define TERNARY_REG_COMMAND 0x08  // Command register
#define TERNARY_REG_STATUS 0x0C   // Status (e.g., error flags)

/* Ternary Commands */
#define CMD_TERNARY_ADD 0x1   // Ternary addition
#define CMD_TERNARY_NOT 0x2   // Ternary NOT (negation)
#define CMD_TERNARY_AND 0x3   // Ternary AND
#define CMD_TERNARY_PUSH 0x4  // Push to ternary stack
#define CMD_TERNARY_POP 0x5   // Pop from ternary stack

/* Ternary Data Type */
typedef int8_t TRIT; // -1, 0, +1 for balanced ternary
#define TRIT_MIN -1
#define TRIT_MAX 1
#define TRIT_COUNT 16 // Number of trits per register

/* Device State */
typedef struct DEVTERNARY {
    TRIT input[TRIT_COUNT];   // Input trit array
    TRIT output[TRIT_COUNT];  // Output trit array
    TRIT stack[TRIT_COUNT];   // Simple ternary stack
    uint32_t stack_ptr;       // Stack pointer (0 to TRIT_COUNT-1)
    uint32_t command;         // Current command
    uint32_t status;          // Status flags (e.g., error)
} DEVTERNARY, *PDEVTERNARY;

/* Ternary Operations */
static TRIT ternary_add(TRIT a, TRIT b, TRIT *carry) {
    int sum = a + b;
    *carry = 0;
    if (sum < TRIT_MIN) { *carry = -1; return sum + 3; }
    if (sum > TRIT_MAX) { *carry = 1; return sum - 3; }
    return sum;
}

static TRIT ternary_not(TRIT a) {
    return -a; // Balanced ternary NOT: -1 -> 1, 0 -> 0, 1 -> -1
}

static TRIT ternary_and(TRIT a, TRIT b) {
    // Ternary AND: min(a, b) in balanced ternary
    return (a < b) ? a : b;
}

/* MMIO Write Handler */
static DECLCALLBACK(void) ternary_mmio_write(PPDMDEVINS pDevIns, void *pvUser,
                                            RTGCPHYS addr, uint32_t value, unsigned size) {
    PDEVTERNARY pThis = (PDEVTERNARY)pvUser;
    if (size != sizeof(uint32_t)) {
        pThis->status |= 0x1; // Set error flag
        LogRel(("TernaryCoproc: Invalid write size %u\n", size));
        return;
    }

    switch (addr) {
        case TERNARY_REG_INPUT:
            // Decode uint32_t to 16 trits (2 bits per trit: 00=0, 01=1, 10=-1)
            for (int i = 0; i < TRIT_COUNT; i++) {
                uint8_t bits = (value >> (i * 2)) & 0x3;
                pThis->input[i] = (bits == 2) ? -1 : (bits == 1) ? 1 : 0;
            }
            LogRel(("TernaryCoproc: INPUT set to trit array\n"));
            break;

        case TERNARY_REG_COMMAND:
            pThis->command = value;
            pThis->status = 0; // Clear error flag
            switch (value) {
                case CMD_TERNARY_ADD: {
                    TRIT carry = 0;
                    for (int i = 0; i < TRIT_COUNT; i++) {
                        pThis->output[i] = ternary_add(pThis->input[i], pThis->input[i], &carry);
                    }
                    LogRel(("TernaryCoproc: ADD executed, carry=%d\n", carry));
                    break;
                }
                case CMD_TERNARY_NOT:
                    for (int i = 0; i < TRIT_COUNT; i++) {
                        pThis->output[i] = ternary_not(pThis->input[i]);
                    }
                    LogRel(("TernaryCoproc: NOT executed\n"));
                    break;
                case CMD_TERNARY_AND: {
                    for (int i = 0; i < TRIT_COUNT; i++) {
                        pThis->output[i] = ternary_and(pThis->input[i], pThis->input[i]);
                    }
                    LogRel(("TernaryCoproc: AND executed\n"));
                    break;
                }
                case CMD_TERNARY_PUSH:
                    if (pThis->stack_ptr < TRIT_COUNT) {
                        for (int i = 0; i < TRIT_COUNT; i++) {
                            pThis->stack[i] = pThis->input[i];
                        }
                        pThis->stack_ptr++;
                        LogRel(("TernaryCoproc: PUSH to stack, sp=%u\n", pThis->stack_ptr));
                    } else {
                        pThis->status |= 0x2; // Stack overflow
                        LogRel(("TernaryCoproc: Stack overflow\n"));
                    }
                    break;
                case CMD_TERNARY_POP:
                    if (pThis->stack_ptr > 0) {
                        pThis->stack_ptr--;
                        for (int i = 0; i < TRIT_COUNT; i++) {
                            pThis->output[i] = pThis->stack[i];
                        }
                        LogRel(("TernaryCoproc: POP from stack, sp=%u\n", pThis->stack_ptr));
                    } else {
                        pThis->status |= 0x3; // Stack underflow
                        LogRel(("TernaryCoproc: Stack underflow\n"));
                    }
                    break;
                default:
                    pThis->status |= 0x1; // Unknown command
                    LogRel(("TernaryCoproc: Unknown command 0x%x\n", value));
                    break;
            }
            break;

        default:
            pThis->status |= 0x1; // Invalid address
            LogRel(("TernaryCoproc: Unknown MMIO write at 0x%x\n", addr));
            break;
    }
}

/* MMIO Read Handler */
static DECLCALLBACK(uint32_t) ternary_mmio_read(PPDMDEVINS pDevIns, void *pvUser,
                                               RTGCPHYS addr, unsigned size) {
    PDEVTERNARY pThis = (PDEVTERNARY)pvUser;
    if (size != sizeof(uint32_t)) {
        pThis->status |= 0x1; // Set error flag
        LogRel(("TernaryCoproc: Invalid read size %u\n", size));
        return 0;
    }

    switch (addr) {
        case TERNARY_REG_OUTPUT:
            // Encode 16 trits to uint32_t (2 bits per trit)
            uint32_t value = 0;
            for (int i = 0; i < TRIT_COUNT; i++) {
                TRIT t = pThis->output[i];
                value |= (t == -1 ? 2 : t) << (i * 2);
            }
            LogRel(("TernaryCoproc: OUTPUT read 0x%x\n", value));
            return value;

        case TERNARY_REG_STATUS:
            LogRel(("TernaryCoproc: STATUS read 0x%x\n", pThis->status));
            return pThis->status;

        default:
            pThis->status |= 0x1; // Invalid address
            LogRel(("TernaryCoproc: Unknown MMIO read at 0x%x\n", addr));
            return 0;
    }
}

/* Device Constructor */
static DECLCALLBACK(int) devTernaryConstruct(PPDMDEVINS pDevIns, int iInstance, PCFGMNODE pCfg) {
    RT_NOREF(iInstance, pCfg);
    PDMDEVINSR3 pDevInsR3 = PDMDEVINS_2_R3PTR(pDevIns);
    PDEVTERNARY pThis = PDMINS_2_DATA(pDevInsR3, PDEVTERNARY);
    
    // Register MMIO region
    int rc = PDMDevHlpMmioMap(pDevIns, 0, TERNARY_MMIO_SIZE, ternary_mmio_read, 
                              ternary_mmio_write, pThis, "TernaryCoproc");
    if (RT_FAILURE(rc)) {
        LogRel(("TernaryCoproc: Failed to map MMIO, rc=%Rrc\n", rc));
        return rc;
    }

    // Initialize device state
    memset(pThis, 0, sizeof(DEVTERNARY));
    pThis->stack_ptr = 0;
    pThis->status = 0;
    LogRel(("TernaryCoproc: Device initialized\n"));
    return VINF_SUCCESS;
}

/* Device Destructor */
static DECLCALLBACK(void) devTernaryDestruct(PPDMDEVINS pDevIns) {
    LogRel(("TernaryCoproc: Device destroyed\n"));
}

/* Device Registration */
const PDMDEVREG g_DeviceTernary = {
    .u32Version = PDM_DEVREG_VERSION,
    .szName = "TernaryCoproc",
    .fFlags = PDM_DEVREG_FLAGS_DEFAULT,
    .szDescription = "Virtual ternary co-processor (for HanoiVM)",
    .pfnConstruct = devTernaryConstruct,
    .pfnDestruct = devTernaryDestruct,
    .pfnRelocate = NULL,
    .pfnMemSetup = NULL,
    .pfnPowerOn = NULL,
    .pfnReset = NULL,
    .pfnSuspend = NULL,
    .pfnResume = NULL,
    .pfnAttach = NULL,
    .pfnDetach = NULL,
    .iInstance = 0,
    .cbInstance = sizeof(DEVTERNARY),
    .u32VersionEnd = PDM_DEVREG_VERSION
};
