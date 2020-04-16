module VendingMachine( clk, reset, coin, drink_choose );

input clk, reset;
input  [5:0] coin;
input  [2:0] drink_choose ;
reg [5:0] refund;

//宣告有限狀態機的內部狀態
reg		[1:0]	tea, coke, coffe, milk; //10, 15, 20, 25
reg     [1:0]   NEXT_STATE;
reg     [1:0]   CUR_STATE;
reg		[5:0]	totalCoin;

//狀態編碼
parameter     S0 = 2'b00; // 初始狀態 
parameter     S1 = 2'b01; // 選擇狀態  
parameter     S2 = 2'b10; // 給予狀態  
parameter     S3 = 2'b11; // 結帳狀態  

initial begin
	totalCoin = 0;
	refund = 0;
	CUR_STATE = S0;
end

always @ ( posedge clk )
begin
    if( reset == 1'b1 ) 
		begin
			totalCoin = 0;
			refund = 0;
			CUR_STATE = S0;
		end
	else
        CUR_STATE = NEXT_STATE;
end

always @ ( posedge clk )
begin
	case( CUR_STATE )
		S0:
			begin
				$display("\nSO") ;
				$display("input coin: ", coin, ", total coin: ", totalCoin+coin);
				if( totalCoin < 10 )
					NEXT_STATE = S0;
				else
					NEXT_STATE = S1;

			if( coin > 0 )	
				totalCoin = coin + totalCoin ;
			end
		S1:
			begin
				$display("\nS1") ;
				$display("input coin: ", coin, ", total coin: ", totalCoin+coin);
				$display("Available drinks:") ;
				if( totalCoin+coin >= 10 ) $display("tea") ;
				if( totalCoin+coin >= 15 ) $display("coke");
				if( totalCoin+coin >= 20 ) $display("coffee");
				if( totalCoin+coin >= 25 ) $display("milk");

				if( drink_choose == 3'd0 ) 
					begin
						totalCoin = totalCoin + coin;
						NEXT_STATE = S0 ;
					end
				else
					totalCoin = totalCoin + coin;
					NEXT_STATE = S2;
			end

		S2:
			begin
				$display("\nS2") ;
				if( drink_choose == 3'd1 && totalCoin >= 10 )
					begin
						refund = totalCoin - 6'd10;
						$display("tea out");
					end
				else if( drink_choose == 3'd2 && totalCoin >= 15 )
					begin
						refund = totalCoin - 6'd15;
						$display("coke out");
					end
				else if( drink_choose == 3'd3 && totalCoin >= 20 )
					begin
						refund = totalCoin - 6'd20;
						$display("coffee out");
					end
				else if( drink_choose == 3'd4 && totalCoin >= 25 )
					begin
						refund = totalCoin - 6'd25;
						$display("milk out");
					end

				NEXT_STATE = S3;
			end

		S3:
			begin
				$display("\nS3") ;
				// refund = totalCoin ;
				$display( "refund:", refund, "\n");
				NEXT_STATE = S0;
			end

	endcase
end
endmodule