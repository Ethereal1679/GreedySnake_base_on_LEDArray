module random_box(
    input clk,
    input rst_n,
    input drive,
    output wire[6:0]box_x,
    output wire[4:0]box_y
    );
	 
//------------------------------随机数生成模块----------------------------------------------------------------------
    
    wire [6:0]rand_num_x;
	 wire [4:0]rand_num_y;
	 
    random_7bit U1_random_7bit(
            .clk(clk),
            .rst_n(rst_n),
            .rand_num(rand_num_x));
				
				
	 random_5bit U2_random_5bit(
				.clk(clk),
				.rst_n(rst_n),
				.rand_num(rand_num_y));
				
//-----------------------------随机盒子创建---------------------------------------------------------
    wire [6:0]rand_x;
    wire [4:0]rand_y;
//--------------------------随机小方块激励模块----------------------------------------------
    box_create U1_box_create(
                    .clk(clk),
                    .rst_n(rst_n),
                    .rand_num_x(rand_num_x),
						  .rand_num_y(rand_num_y),
                    .rand_drive(drive),
                    .rand_x(rand_x),
                    .rand_y(rand_y)
                    );
						  
						  
	assign box_x = rand_x;
	assign box_y = rand_y;

endmodule
