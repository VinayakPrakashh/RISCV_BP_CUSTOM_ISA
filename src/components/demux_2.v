module demux2 #(
    parameter width = 32
) (
    input [width-1:0] in,
    input sel,
    output  [width-1:0] out0,
    output  [width-1:0] out1
);
assign out0 = (sel==1'b0) ? in : {width{1'b0}};
assign out1 = (sel==1'b1) ? in : {width{1'b0}};
endmodule