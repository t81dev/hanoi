// tb_mining_pipeline.v — Full Opcode Coverage for T81 SHA3 Mining Pipeline

`timescale 1ns/1ps

module tb_mining_pipeline;

    reg clk;
    reg rst;

    reg [7:0] opcode;
    reg [80:0] operand;
    reg start_mine;
    reg valid_opcode;

    wire match_found;

    // DUT Instance
    mining_pipeline dut (
        .clk(clk),
        .rst(rst),
        .opcode(opcode),
        .operand(operand),
        .start_mine(start_mine),
        .valid_opcode(valid_opcode),
        .match_found(match_found)
    );

    // Clock generation
    initial clk = 0;
    always #5 clk = ~clk;

    // Task: Send an opcode+operand
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

    // Random T81 generator
    function [80:0] random_t81();
        begin
            random_t81 = {$random, $random, $random} & 81'h1FFFFFFFFFFFFFFFFFFFFFFFF;
        end
    endfunction

    initial begin
        $display("=== T81 Mining Pipeline Full Opcode Test ===
