// hanoivm_fsm.v - Ternary FSM-based opcode interpreter (HanoiVM core)
module hanoivm_fsm (
    input clk,
    input rst,
    input [7:0] opcode_in,
    input [161:0] operand_in, // 81 trits encoded as 2 bits/trit
    input valid,
    output reg ready,
    output reg [161:0] result_out, // 81-trit result
    output reg done,
    output reg error // Error flag (e.g., stack overflow, invalid opcode)
);

    // Ternary stack: 81 trits per entry, encoded as 2 bits/trit (162 bits)
    reg [161:0] stack [0:15];
    reg [3:0] sp; // Stack pointer (4-bit for 16 entries)

    // State machine encoding
    typedef enum logic [2:0] {
        IDLE = 3'd0,
        FETCH = 3'd1,
        EXECUTE = 3'd2,
        WRITEBACK = 3'd3,
        DONE = 3'd4
    } state_t;

    state_t state;
    reg [7:0] opcode_reg;
    reg [161:0] operand_reg;
    reg [161:0] temp_result;

    // Balanced ternary trit type (2 bits: 00=0, 01=1, 10=-1)
    localparam TRIT_ZERO = 2'b00, TRIT_ONE = 2'b01, TRIT_NEGONE = 2'b10;
    localparam TRIT_WIDTH = 2;
    localparam TRIT_COUNT = 81;

    // Ternary addition (balanced ternary)
    function automatic [TRIT_WIDTH-1:0] ternary_add(input [TRIT_WIDTH-1:0] a, b, input carry_in, output carry_out);
        reg [2:0] a_val, b_val, sum;
        a_val = (a == TRIT_NEGONE) ? -1 : (a == TRIT_ONE) ? 1 : 0;
        b_val = (b == TRIT_NEGONE) ? -1 : (b == TRIT_ONE) ? 1 : 0;
        sum = a_val + b_val + carry_in;
        carry_out = 0;
        if (sum < -1) begin
            carry_out = -1;
            sum = sum + 3;
        end else if (sum > 1) begin
            carry_out = 1;
            sum = sum - 3;
        end
        return (sum == -1) ? TRIT_NEGONE : (sum == 1) ? TRIT_ONE : TRIT_ZERO;
    endfunction

    // Ternary NOT
    function automatic [TRIT_WIDTH-1:0] ternary_not(input [TRIT_WIDTH-1:0] a);
        return (a == TRIT_NEGONE) ? TRIT_ONE : (a == TRIT_ONE) ? TRIT_NEGONE : TRIT_ZERO;
    endfunction

    // Ternary AND (min)
    function automatic [TRIT_WIDTH-1:0] ternary_and(input [TRIT_WIDTH-1:0] a, b);
        reg [2:0] a_val, b_val;
        a_val = (a == TRIT_NEGONE) ? -1 : (a == TRIT_ONE) ? 1 : 0;
        b_val = (b == TRIT_NEGONE) ? -1 : (b == TRIT_ONE) ? 1 : 0;
        return (a_val < b_val) ? a : b;
    endfunction

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            state <= IDLE;
            sp <= 0;
            ready <= 1;
            done <= 0;
            error <= 0;
            for (int i = 0; i < 16; i++) stack[i] <= 0;
        end else begin
            case (state)
                IDLE: begin
                    if (valid) begin
                        opcode_reg <= opcode_in;
                        operand_reg <= operand_in;
                        state <= FETCH;
                        ready <= 0;
                        error <= 0;
                    end
                end

                FETCH: begin
                    // Simulate memory latency (optional: add cycles for DRAM)
                    state <= EXECUTE;
                end

                EXECUTE: begin
                    temp_result <= 0;
                    case (opcode_reg)
                        8'h00: begin // NOP
                            temp_result <= 0;
                        end
                        8'h01: begin // PUSH
                            if (sp < 16) begin
                                stack[sp] <= operand_reg;
                                sp <= sp + 1;
                                temp_result <= operand_reg;
                            end else begin
                                error <= 1; // Stack overflow
                            end
                        end
                        8'h02: begin // POP
                            if (sp > 0) begin
                                sp <= sp - 1;
                                temp_result <= stack[sp - 1];
                            end else begin
                                error <= 1; // Stack underflow
                            end
                        end
                        8'h03: begin // ADD
                            if (sp >= 2) begin
                                reg [TRIT_WIDTH-1:0] carry = 0;
                                for (int i = 0; i < TRIT_COUNT; i++) begin
                                    temp_result[i*TRIT_WIDTH +: TRIT_WIDTH] <= ternary_add(
                                        stack[sp-1][i*TRIT_WIDTH +: TRIT_WIDTH],
                                        stack[sp-2][i*TRIT_WIDTH +: TRIT_WIDTH],
                                        carry, carry
                                    );
                                end
                                sp <= sp - 1;
                                stack[sp-2] <= temp_result;
                            end else begin
                                error <= 1; // Insufficient operands
                            end
                        end
                        8'h04: begin // NOT
                            if (sp >= 1) begin
                                for (int i = 0; i < TRIT_COUNT; i++) begin
                                    temp_result[i*TRIT_WIDTH +: TRIT_WIDTH] <= ternary_not(
                                        stack[sp-1][i*TRIT_WIDTH +: TRIT_WIDTH]
                                    );
                                end
                                stack[sp-1] <= temp_result;
                            end else begin
                                error <= 1; // Insufficient operands
                            end
                        end
                        8'h05: begin // AND
                            if (sp >= 2) begin
                                for (int i = 0; i < TRIT_COUNT; i++) begin
                                    temp_result[i*TRIT_WIDTH +: TRIT_WIDTH] <= ternary_and(
                                        stack[sp-1][i*TRIT_WIDTH +: TRIT_WIDTH],
                                        stack[sp-2][i*TRIT_WIDTH +: TRIT_WIDTH]
                                    );
                                end
                                sp <= sp - 1;
                                stack[sp-2] <= temp_result;
                            end else begin
                                error <= 1; // Insufficient operands
                            end
                        end
                        default: begin
                            error <= 1; // Unknown opcode
                            temp_result <= 0;
                        end
                    endcase
                    state <= WRITEBACK;
                end

                WRITEBACK: begin
                    result_out <= temp_result;
                    done <= 1;
                    state <= DONE;
                end

                DONE: begin
                    done <= 0;
                    ready <= 1;
                    state <= IDLE;
                end
            endcase
        end
    end

endmodule
