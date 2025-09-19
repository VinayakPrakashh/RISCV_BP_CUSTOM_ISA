module hazard_unit (
    input clk,rst,RegWriteM,RegWriteW,
    input [4:0]RdM,RdW,
    input [4:0] rs1_addr_E,rs2_addr_E,
    output [1:0] ForwardAE,ForwardBE,
    input [1:0] ResultSrcE,
    input [4:0] Rs1D,Rs2D,RdE,
    output StallF,StallD,FlushE,
    input Eval_branch,
    output FlushD,
    input start_mul,
    input done_mul
);

wire lwstall;

assign ForwardAE = (rst==1'b1)? 2'b00 : 
                   ((RegWriteM ==1'b1) && (RdM != 5'b00000) && (RdM == rs1_addr_E)) ? 2'b10 : 
                   ((RegWriteW ==1'b1) && (RdW != 5'b00000) && (RdW == rs1_addr_E)) ? 2'b01 : 2'b00;
assign ForwardBE = (rst==1'b1)? 2'b00 : 
                   ((RegWriteM ==1'b1) && (RdM != 5'b00000) && (RdM == rs2_addr_E)) ? 2'b10 : 
                   ((RegWriteW ==1'b1) && (RdW != 5'b00000) && (RdW == rs2_addr_E)) ? 2'b01 : 2'b00;

assign lwstall = (ResultSrcE ==2'b01) & ((Rs1D == RdE) | (Rs2D == RdE));

assign StallF = lwstall | mul_stall;
assign StallD = lwstall | mul_stall;
assign FlushE = lwstall | Eval_branch;
assign FlushD = Eval_branch;

reg mul_active;

always @(posedge clk or posedge rst) begin
    if (rst)
        mul_active <= 0;
    else if (start_mul)
        mul_active <= 1;     // multiplier started
    else if (done_mul)
        mul_active <= 0;     // multiplier finished
end

assign mul_stall = mul_active & ~done;

endmodule