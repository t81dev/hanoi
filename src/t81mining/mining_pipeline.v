// mining_pipeline.v — Multi-Core Aware T81 SHA3 Mining Pipeline

module mining_pipeline #(
    parameter NUM_CORES = 2
)(
    input wire clk,
    input wire rst,
    input wire [7:0] opcode [NUM_CORES-1:0],
    input wire [80:0] operand [NUM_CORES-1:0],
    input wire valid [NUM_CORES-1:0],
    output wire match_found [NUM_CORES-1:0]
);

    genvar i;
    generate
        for (i = 0; i < NUM_CORES; i = i + 1) begin : mining_cores
            wire [80:0] result;
            wire fsm_done;
            wire [511:0] sha_input;
            wire preproc_done;
            wire preproc_ready;
            wire [511:0] hash_out;
            wire sha_done;

            hanoivm_fsm fsm_i (
                .clk(clk),
                .rst(rst),
                .opcode_in(opcode[i]),
                .operand_in(operand[i]),
                .valid(valid[i]),
                .ready(),
                .result_out(result),
                .done(fsm_done)
            );

            t81_preprocessor preproc_i (
                .clk(clk),
                .rst(rst),
                .t81_operand(result),
                .valid(fsm_done),
                .ready(preproc_ready),
                .sha_input(sha_input),
                .done(preproc_done)
            );

            sha3_core sha_i (
                .clk(clk),
                .rst(rst),
                .data_in(sha_input),
                .start(preproc_done),
                .hash_out(hash_out),
                .done(sha_done)
            );

            mining_controller ctrl_i (
                .clk(clk),
                .rst(rst),
                .start(sha_done),
                .hash_in(hash_out),
                .match_found(match_found[i])
            );
        end
    endgenerate

endmodule
