module random_5bit(
    input clk,
    input rst_n,
    output reg[4:0] rand_num
    );
	 
//reg [3:0] rand_buff = 4'd0;
//----------------------初始化-------------------------------------------------------------
initial begin
	rand_num = 5'b01000;
end
//------------------------产生随机数-----------------------------------------------------------
always@(posedge clk or negedge rst_n)
   if(!rst_n)  begin
			rand_num <= 5'b01000;
//			rand_buff <= 4'd0;
	end
   else begin       //0.1s的延迟
//				rand_buff <= rand_num % 9 + 2;       
//				rand_num <= rand_num << rand_buff;
            rand_num[0] <= rand_num[1];
            rand_num[1] <= rand_num[2];
            rand_num[2] <= rand_num[4];
            rand_num[3] <= rand_num[0];
            rand_num[4] <= rand_num[3];
   end
endmodule
