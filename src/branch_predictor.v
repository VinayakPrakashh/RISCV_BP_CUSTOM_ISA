module branch_predictor (
    input clk,
    input reset,
    input Eval_branch,
    input PCSrcE,
    input [31:0] Act_Target,
    input [31:0] instr,
    input [31:0] PC,
    output  predict_branch,
    output  [31:0] Target_final,
    input StateUpdateEnable

);

    reg [1:0] state; // 2-bit saturating counter

    // State encoding
    localparam STRONG_NOT_TAKEN = 2'b00;
    localparam WEAK_NOT_TAKEN   = 2'b01;
    localparam WEAK_TAKEN       = 2'b10;
    localparam STRONG_TAKEN     = 2'b11;

wire [31:0] imm,Target;
reg predicted;
    // Handle final prediction logic (correct if mismatch occurs)
assign predict_branch = Eval_branch | (predicted & (7'b1100011 == instr[6:0] || 7'b1101111 == instr[6:0]));

assign imm = (7'b1100011 == instr[6:0]) ? {{20{instr[31]}}, instr[7], instr[30:25], instr[11:8], 1'b0}: //b-type
             (7'b1101111 == instr[6:0]) ? {{12{instr[31]}}, instr[19:12], instr[20], instr[30:21], 1'b0}: //j-type
             32'bx;

assign Target = PC + imm; //target_address

mux2 targetmux(Target,Act_Target,Eval_branch,Target_final);

 always @(posedge clk or posedge reset) begin
        if (reset) begin
            state <= STRONG_TAKEN;
        end else if(StateUpdateEnable) begin
            case (state)
                STRONG_NOT_TAKEN: state <= PCSrcE ? WEAK_NOT_TAKEN : STRONG_NOT_TAKEN;
                WEAK_NOT_TAKEN:   state <= PCSrcE ? WEAK_TAKEN : STRONG_NOT_TAKEN;
                WEAK_TAKEN:       state <= PCSrcE ? STRONG_TAKEN : WEAK_NOT_TAKEN;
                STRONG_TAKEN:     state <= PCSrcE ? STRONG_TAKEN : WEAK_TAKEN;
                default:          state <= state; // Default case to handle unexpected states
            endcase
        end
    end

    always @(*) begin
        case (state)
            STRONG_NOT_TAKEN, WEAK_NOT_TAKEN: predicted = 0;
            WEAK_TAKEN, STRONG_TAKEN:         predicted = 1;
        endcase
    end

endmodule