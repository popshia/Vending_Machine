module simulate();

reg clk, reset;
reg [5:0] coin, refund;
reg [2:0] drink_choose;

VendingMachine a( clk, reset, coin, drink_choose );

initial clk = 1'b0;
always #5 clk = ~clk;

initial
begin
	$dumpfile("vending.vcd");
	$dumpvars;
	#10 coin = 6'd10 ; // coin 10,  total 10 dollars  tea
	#10 coin = 6'd5 ;  // coin 5,   total 15 dollars  tea | coke
	#10 coin = 6'd10 ;  // coin 1,   total 16 dollars  tea | coke
	#10 coin = 6'd10 ; // coin 10,  total 26 dollars  tea | coke | coffee | milk

	#10 drink_choose = 3'd3 ; // 3=coffee  coffee out
	#10 drink_choose = 3'd0 ;
end
initial #80 $finish;
endmodule