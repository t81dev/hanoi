`timescale 1ns/1ps

module tb_mining_pipeline;

    reg clk;
    reg rst;

    reg [7:0] opcode;
    reg [80:0] operand;
    reg start_mine;
    reg valid_opcode;

    wire match_found;

    mining_pipeline dut (
        .clk(clk),
        .rst(rst),
        .opcode(opcode),
        .operand(operand),
        .start_mine(start_mine),
        .valid_opcode(valid_opcode),
        .match_found(match_found)
    );

    // Debug trace taps
    wire [80:0] stack_trace_0 = dut.u_fsm.stack[0];
    wire [80:0] stack_trace_1 = dut.u_fsm.stack[1];
    wire [80:0] fsm_result    = dut.u_fsm.result_out;
    wire [511:0] sha_input    = dut.u_preproc.sha_input;
    wire [511:0] sha_output   = dut.u_sha3.hash_out;

    // Clock generation
    initial clk = 0;
    always #5 clk = ~clk;

    function [80:0] random_t81();
        begin
            random_t81 = {$random, $random, $random} & 81'h1FFFFFFFFFFFFFFFFFFFFFFFF;
        end
    endfunction

    task apply_vector(input [7:0] op, input [80:0] opnd);
        begin
            @(posedge clk);
            opcode <= op;
            operand <= opnd;
            valid_opcode <= 1;
            @(posedge clk);
            valid_opcode <= 0;
            @(posedge clk);
        end
    endtask

    initial begin
        $display("=== T81 Mining Pipeline Simulation ===");
        $dumpfile("tb_mining_pipeline.vcd");
        $dumpvars(0, tb_mining_pipeline);
        $dumpvars(1, dut);
        $dumpvars(1, stack_trace_0, stack_trace_1, fsm_result, sha_input, sha_output);

        rst = 1; opcode = 8'h00; operand = 81'd0; start_mine = 0; valid_opcode = 0;
        #20;
        rst = 0;
        #10;

        $display("[TEST] NOP");
        apply_vector(8'h00, 81'd0);

        $display("[TEST] PUSH 0x1");
        apply_vector(8'h01, 81'h000000000000000000001);

        $display("[TEST] PUSH 0x2 and 0x3");
        apply_vector(8'h01, 81'h000000000000000000002);
        apply_vector(8'h01, 81'h000000000000000000003);

        $display("[TEST] ADD");
        apply_vector(8'h03, 81'd0);

        $display("[TEST] POP");
        apply_vector(8'h02, 81'd0);

        repeat (3) begin
            $display("[TEST] RANDOM PUSH");
            apply_vector(8'h01, random_t81());
        end

        $display("[INFO] Waiting for SHA3 match...");
        wait (match_found == 1);
        $display("[SUCCESS] Match found at time %0t!", $time);

        #50;
        $finish;
    end

endmodule
