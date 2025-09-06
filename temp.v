module execute_cycle (
    input clk,rst,
    input [31:0] InstrE,RD1_E,RD2_E,PCE,ImmExtE,PCPlus4E,
    input [4:0] RdE,
    input  RegWriteE,MemWriteE,JumpE,Jalr,BranchE,ALUSrcE,
    input [2:0] ALUControlE,
    input [1:0] ResultSrcE,
    input mul_switch,start_mul,
    output [31:0] PCTargetE,WriteDataM,ALUResultM,PCPlus4M,InstrM,
    output [4:0] RdM,
    output RegWriteM,MemWriteM,
    output [1:0] ResultSrcM,
    output PCSrcE,
    input [1:0] ForwardAE,ForwardBE,
    input [31:0] ResultW,
    input luauE,
    output [31:0] AuLu_ResultM,
    input Predict_branchE,
    output Eval_branch,
    output Prediction_Correct,
    output StateUpdateEnable,
    output done_mul
);
wire [31:0] SrcBE,SrcBE_F;
wire Takebranch,Zero,Target_sel;
wire [31:0] ALUResultE;
wire [31:0] SrcAE,auipcadderout,AuLu_ResultE,PCTargetE_w;
wire [31:0] SrcAE_alu,SrcBE_alu,SrcAE_mul,SrcBE_mul;
wire [31:0] mul_res,ALUResultE_pre;
wire mul_switch,done_mul;

reg [31:0] ALUResultE_r,WriteDataE_r,PCPlus4E_r,InstrE_r,AuLu_ResultE_r;
reg [4:0] RdE_r;
reg RegWriteE_r,MemWriteE_r;
reg [1:0] ResultSrcE_r;

mux2 srcmux(SrcBE,ImmExtE,ALUSrcE,SrcBE_F);
alu alu_main(SrcAE_alu,SrcBE_alu,ALUControlE,ALUResultE_pre,Zero,InstrE[30],InstrE[12]);
branching_unit bu(ALUResultE[31],Zero,InstrE[14:12],Takebranch);
adder pctarget(PCE,ImmExtE,PCTargetE_w);
//auipc and lui
adder auipcadder(PCE,ImmExtE,auipcadderout);
mux2 auipcluimux(auipcadderout,ImmExtE,luauE,AuLu_ResultE);
//hazard forwarding
mux4 forwarda(RD1_E,ResultW,ALUResultM,32'b0,ForwardAE,SrcAE);
mux4 forwardb(RD2_E,ResultW,ALUResultM,32'b0,ForwardBE,SrcBE);

// //jalr
// mux2 jalrmux(PCTargetE_w,ALUResultE,Jalr,PCTargetE);
//predictor
predict_handler ph(Predict_branchE,PCSrcE,BranchE,JumpE,Eval_branch,Target_sel,Prediction_Correct);

mux2 target_selmux(PCTargetE_w,PCPlus4E,Target_sel,PCTargetE);

demux2 mul_mux1(SrcAE,mul_switch,SrcAE_alu,SrcAE_mul);
demux2 mul_mux2(SrcBE_F,mul_switch,SrcBE_alu,SrcBE_mul);
multiplier_top mul(clk,start_mul,SrcAE_mul,SrcBE_mul,mul_res,done);
mux2 mul_alu_mux(ALUResultE_pre,mul_res,mul_switch,ALUResultE);
assign StateUpdateEnable = BranchE | JumpE;
assign PCSrcE = ((Takebranch & BranchE) | JumpE);

always @(posedge clk or posedge rst) begin
    if(rst==1'b1) begin
        ALUResultE_r <= 0;
        WriteDataE_r <= 0;
        PCPlus4E_r <= 0;
        RdE_r <= 0;
        RegWriteE_r <= 0;
        MemWriteE_r <= 0;
        ResultSrcE_r <= 0;
        InstrE_r <= 0;
        AuLu_ResultE_r <= 0;
    end
    else begin
        ALUResultE_r <= ALUResultE;
        WriteDataE_r <= SrcBE;
        PCPlus4E_r <= PCPlus4E;
        RdE_r <= RdE;
        RegWriteE_r <= RegWriteE;
        MemWriteE_r <= MemWriteE;
        ResultSrcE_r <= ResultSrcE;
        InstrE_r <= InstrE;
        AuLu_ResultE_r <= AuLu_ResultE;
    end
end
assign ALUResultM = ALUResultE_r;
assign PCPlus4M = PCPlus4E_r;
assign WriteDataM = WriteDataE_r;
assign RdM = RdE_r;
assign RegWriteM = RegWriteE_r;
assign MemWriteM = MemWriteE_r;
assign ResultSrcM = ResultSrcE_r;
assign InstrM = InstrE_r;
assign AuLu_ResultM = AuLu_ResultE_r;

endmodule
