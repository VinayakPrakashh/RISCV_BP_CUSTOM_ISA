module fetch_cycle (
    input clk,rst,PCSrcE,
    input [31:0] PCTargetE,
    output [31:0] InstrD,PCD,PCPlus4D,
    input StallF,StallD,FlushD,
    output Predict_branchD,
    input Eval_branch,
    input StateUpdateEnable
);
wire [31:0] PC_F,PCF,PCPlus4F,InstrF,Target_finalF;
wire Predict_branchF;
reg [31:0] InstrF_reg,PCF_reg,PCPlus4F_reg;
reg Predict_branchF_reg;

mux2 pcmux(PCPlus4F,Target_finalF,Predict_branchF,PC_F);
reset_ff PC(clk,rst,PC_F,PCF,StallD);
instr_mem im(PCF,InstrF);
adder pcadder(PCF,32'h4,PCPlus4F);
//predictor
branch_predictor bp(clk,rst,Eval_branch,PCSrcE,PCTargetE,InstrF,PCF,Predict_branchF,Target_finalF,StateUpdateEnable);

always @(posedge clk or posedge rst) begin
    if(rst==1'b1 | FlushD)begin
        InstrF_reg<=32'h0;
        PCF_reg<=32'h0;
        PCPlus4F_reg<=32'h0;
        Predict_branchF_reg<=1'b0;
    end
    else if(!StallF) begin
        InstrF_reg<=InstrF;
        PCF_reg<=PCF;
        PCPlus4F_reg<=PCPlus4F;
        Predict_branchF_reg<=Predict_branchF;
    end
end

assign InstrD=(rst==1'b1)?32'h0:InstrF_reg;
assign PCD=(rst==1'b1)?32'h0:PCF_reg;
assign PCPlus4D=(rst==1'b1)?32'h0:PCPlus4F_reg;
assign Predict_branchD = (rst==1'b1)?1'b0:Predict_branchF_reg;


endmodule