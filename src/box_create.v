module box_create(
    input clk,
    input rst_n,
    input[6:0] rand_num_x,
	 input[4:0] rand_num_y,
//-----------------------------------驱动信号，用来单稳态触发盒子生成---------------------------
    input rand_drive,
    output reg[6:0]rand_x,
    output reg[4:0]rand_y
    );
//-----------------------------------------------------------------------------------------
always@(posedge clk or negedge rst_n)
   if(!rst_n)  begin
			rand_x <= 7'b0100000;
			rand_y <= 5'b01000;
	end
   else begin 			//0.1s的延迟
            if(rand_drive) begin 
					rand_x <= rand_num_x; 
					rand_y <= rand_num_y; 
				end
	end
endmodule




