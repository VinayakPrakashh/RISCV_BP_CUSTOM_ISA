`timescale 1ns / 1ps

module riscv_top_tb2;

    // Inputs
    reg clk;
    reg rst;

    // Internal wires
    wire [31:0] PCTargetE;
    wire PCSrcE;
    wire Jalr;
    wire [31:0] InstrD;
    wire [31:0] PCD;
    wire [31:0] PCPlus4D;
    wire [31:0] InstrE;
    wire [31:0] PCE;
    wire [31:0] PCPlus4E;
    wire [31:0] ImmExtE;
    wire [31:0] RD1_E;
    wire [31:0] RD2_E;
    wire [4:0] RdE;
    wire RegWriteE;
    wire MemWriteE;
    wire JumpE;
    wire BranchE;
    wire ALUSrcE;
    wire [2:0] ALUControlE;
    wire [1:0] ResultSrcE;
    wire RegWriteM;
    wire MemWriteM;
    wire [1:0] ResultSrcM;
    wire [31:0] WriteDataM;
    wire [31:0] ALUResultM;
    wire [31:0] PCPlus4M;
    wire [31:0] InstrM;
    wire [4:0] RdM;
    wire [1:0] ResultSrcW;
    wire [31:0] ReadDataW;
    wire [31:0] ALUResultW;
    wire [31:0] PCPlus4W;
    wire RegWriteW;
    wire [4:0] RdW;
    wire [31:0] Result;
    wire [4:0] rs1_addr_E;
    wire [4:0] rs2_addr_E;
    wire [1:0] ForwardAE;
    wire [1:0] ForwardBE;
    wire StallF, StallD, FlushE, FlushD;
    wire [31:0] alu_out, rs1, rs2;
    wire [31:0] data_ram1;
    wire Eval_branch;
    

    // Internal wires from fetch_cycle
    wire [31:0] PC_F, PCF, PCPlus4F, InstrF, Target_finalF;
    wire Predict_branchF;
    wire [31:0] InstrF_reg, PCF_reg, PCPlus4F_reg;
    wire Predict_branchF_reg,Predict_branchE,PCSrcE,Prediction_Correct;
    wire predicted;
    wire [1:0] state;
    // Instantiate the Unit Under Test (UUT)
    riscv_top uut (
        .clk(clk),
        .rst(rst)
    );

    // Assign internal wires from fetch_cycle
    assign state = uut.fc.bp.state;
    assign predicted = uut.fc.bp.predicted;
    assign Prediction_Correct = uut.Prediction_Correct;
    assign Predict_branchE = uut.Predict_branchE;
    assign PCSrcE = uut.PCSrcE;
    assign Eval_branch = uut.Eval_branch;
    assign PC_F = uut.fc.PC_F;
    assign PCF = uut.fc.PCF;
    assign PCPlus4F = uut.fc.PCPlus4F;
    assign InstrF = uut.fc.InstrF;
    assign Target_finalF = uut.fc.Target_finalF;
    assign Predict_branchF = uut.fc.Predict_branchF;
    assign InstrF_reg = uut.fc.InstrF_reg;
    assign PCF_reg = uut.fc.PCF_reg;
    assign PCPlus4F_reg = uut.fc.PCPlus4F_reg;
    assign Predict_branchF_reg = uut.fc.Predict_branchF_reg;

    assign data_ram1 = uut.mc.dm.data_ram[25];
    assign rs1 = uut.ec.alu_main.a;
    assign rs2 = uut.ec.alu_main.b;
    assign alu_out = uut.ec.alu_main.Result;
    assign PCTargetE = uut.PCTargetE;
    assign PCSrcE = uut.PCSrcE;
    assign Jalr = uut.Jalr;
    assign InstrD = uut.InstrD;
    assign PCD = uut.PCD;
    assign PCPlus4D = uut.PCPlus4D;
    assign InstrE = uut.InstrE;
    assign PCE = uut.PCE;
    assign PCPlus4E = uut.PCPlus4E;
    assign ImmExtE = uut.ImmExtE;
    assign RD1_E = uut.RD1_E;
    assign RD2_E = uut.RD2_E;
    assign RdE = uut.RdE;
    assign RegWriteE = uut.RegWriteE;
    assign MemWriteE = uut.MemWriteE;
    assign JumpE = uut.JumpE;
    assign BranchE = uut.BranchE;
    assign ALUSrcE = uut.ALUSrcE;
    assign ALUControlE = uut.ALUControlE;
    assign ResultSrcE = uut.ResultSrcE;
    assign RegWriteM = uut.RegWriteM;
    assign MemWriteM = uut.MemWriteM;
    assign ResultSrcM = uut.ResultSrcM;
    assign WriteDataM = uut.WriteDataM;
    assign ALUResultM = uut.ALUResultM;
    assign PCPlus4M = uut.PCPlus4M;
    assign InstrM = uut.InstrM;
    assign RdM = uut.RdM;
    assign ResultSrcW = uut.ResultSrcW;
    assign ReadDataW = uut.ReadDataW;
    assign ALUResultW = uut.ALUResultW;
    assign PCPlus4W = uut.PCPlus4W;
    assign RegWriteW = uut.RegWriteW;
    assign RdW = uut.RdW;
    assign Result = uut.ResultW;
    assign rs1_addr_E = uut.rs1_addr_E;
    assign rs2_addr_E = uut.rs2_addr_E;
    assign ForwardAE = uut.ForwardAE;
    assign ForwardBE = uut.ForwardBE;
    assign StallF = uut.StallF;
    assign StallD = uut.StallD;
    assign FlushE = uut.FlushE;
    assign FlushD = uut.FlushD;

    initial begin
        // Initialize Inputs
        clk = 0;
        rst = 1;

        // Wait for global reset to finish
        #10;
        rst = 0;
    end

    always #5 clk = ~clk; // Clock generator

    initial begin
        $monitor("Time: %0t | clk: %b | rst: %b | PCTargetE: %h | PCSrcE: %b | Jalr: %b | InstrD: %h | PCD: %h | PCPlus4D: %h | InstrE: %h | PCE: %h | PCPlus4E: %h | ImmExtE: %h | RD1_E: %h | RD2_E: %h | RdE: %b | RegWriteE: %b | MemWriteE: %b | JumpE: %b | BranchE: %b | ALUSrcE: %b | ALUControlE: %b | ResultSrcE: %b | RegWriteM: %b | MemWriteM: %b | ResultSrcM: %b | WriteDataM: %h | ALUResultM: %h | PCPlus4M: %h | InstrM: %h | RdM: %b | Rd: %b | ResultSrcW: %b | ReadDataW: %h | ALUResultW: %h | PCPlus4W: %h | RegWriteW: %b | RdW: %b | Result: %h | RegWrite: %b | PC_F: %h | PCF: %h | PCPlus4F: %h | InstrF: %h | Target_finalF: %h | Predict_branchF: %b | InstrF_reg: %h | PCF_reg: %h | PCPlus4F_reg: %h | Predict_branchF_reg: %b", 
                 $time, clk, rst, PCTargetE, PCSrcE, Jalr, InstrD, PCD, PCPlus4D, InstrE, PCE, PCPlus4E, ImmExtE, RD1_E, RD2_E, RdE, RegWriteE, MemWriteE, JumpE, BranchE, ALUSrcE, ALUControlE, ResultSrcE, RegWriteM, MemWriteM, ResultSrcM, WriteDataM, ALUResultM, PCPlus4M, InstrM, RdM, RdW, ResultSrcW, ReadDataW, ALUResultW, PCPlus4W, RegWriteW, RdW, Result, RegWriteW, PC_F, PCF, PCPlus4F, InstrF, Target_finalF, Predict_branchF, InstrF_reg, PCF_reg, PCPlus4F_reg, Predict_branchF_reg);
    end

    initial begin
  #5
        $finish;
    end
endmodule