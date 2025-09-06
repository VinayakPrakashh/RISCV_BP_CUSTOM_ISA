module predict_handler (
    input Predicted,
    input Actual,
    input branch,
    input jump,
    output Eval_branch,
    output Target_sel,
    output Prediction_Correct
);

assign Eval_branch = ((Predicted != Actual) && (jump | branch) ) ? 1'b1: 1'b0;
assign Target_sel = (~Predicted & Actual) ? 0 : 1;
assign Prediction_Correct = ((Predicted == Actual) && (jump | branch)  ) ? 1'b1 : 1'b0;
endmodule
//predicted = 0 and actual = 1 => target_sel = 0
//predicted = 1 and actual = 0 => target_sel = 1