module and_gate_tb;
    reg a, b;
    wire c;
and_gate dut(a,b,c);
 initial begin
    #0 a=0;b=0;
    #10 a=0;b=1;
    #10 a=1;b=0;
    #10 a=1;b=1;
    #10;
 end
endmodule