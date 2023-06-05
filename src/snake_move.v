module LED_Serial_lighted(
	input clk,
	input rst_n,
//-----------------------------------------按---------键----------------------------------
	 input light_l,
    input light_r,
    input light_u,
    input light_d,
//------------------------------------------显---------示-------------------------------
	output reg [6:0]snake_x_show,
	output reg [4:0]snake_y_show
);

//---------------------------------------------长度常量-------------------------------
	parameter x_range = 7*8-1;
	parameter y_range = 5*8-1;
	
	reg [3:0] light_press;
//----------------------------------------------方向判断-------------------------------------	 
    reg[1:0] snake_dir;//蛇头方向寄存器
    parameter right = 2'b00;
    parameter left = 2'b01;
    parameter up = 2'b10;
    parameter down = 2'b11;
	 initial snake_dir = right;
//------------------------------------------------通过红外灯控制------------------------------
	always @ (posedge clk) begin
		light_press[3] <= light_u;
		light_press[2] <= light_d;
		light_press[1] <= light_l;
		light_press[0] <= light_r;
	end
//---------------------------------------------按键判断---------------------------------	
	 
     always@(posedge clk or negedge rst_n) begin
        if(!rst_n)  snake_dir <= right;
        else if(light_press[0] && snake_dir != left)  snake_dir <= right;
        else if(light_press[1] && snake_dir != right) snake_dir <= left;
        else if(light_press[3] && snake_dir != down)  snake_dir <= up;
        else if(light_press[2] && snake_dir != up)    snake_dir <= down;
		end
	  
//------------------------蛇身长为7(不算头)---以及初始化[11:1]和[10:0]部分更新蛇的运动,[12]部分为盒子坐标部分-----
    reg [6:0]snake_x[7:0];   
    reg [4:0]snake_y[7:0];
	 wire [6:0]snake_box_x;
	 wire [4:0]snake_box_y;

//---------------------------------------------蛇身运动部分---------------------------------------
initial begin
		    snake_x[1] = 7'd0;
			 snake_y[1] = 5'd0;
			 snake_x[2] = 7'd0;
			 snake_y[2] = 5'd0;
			 snake_x[3] = 7'd0;
			 snake_y[3] = 5'd0;
			 snake_x[4] = 7'd0;
			 snake_y[4] = 5'd0;
			 snake_x[5] = 7'd0;
			 snake_y[5] = 5'd0;
			 snake_x[6] = 7'd0;
			 snake_y[6] = 5'd0;
			 snake_x[7] = 7'd0;
			 snake_y[7] = 5'd0;
 end
//----------------------------蛇头初始化--------------------------------------------------
	 initial begin
		snake_x[0] = 7'd0001000;
		snake_y[0] = 5'd00100;
	 end
//----------------------------蛇头计数器--------------update计数器-------------------------------	
	 reg [31:0]count = 32'd0;
	 reg [31:0]count_gameover = 32'd0;
	 
	 reg [1:0] game_over = 2'd0;
	 reg [1:0] update = 2'd0;

//-----------------------------------------------------------------------------------------	 
always@(posedge clk or negedge rst_n) begin
			if(!rst_n) begin
				count <= 32'd0;
		   end
			else begin
//------------------------1s计数1次--1HZ-----------------------------------------
				if(count == 32'd50_000_000) begin 
					count <= 32'd0;					
					if(update == 2'd1)begin
						update <= 2'd0;
					end
					else begin
						update <= update + 2'd1;
					end			
				end
				else begin
					count <= count + 32'd1;
				end
			end
end  
//-----------------------------------------用于结束显示的字母-------------------------------
	reg [3:0] gameover_show_flag=4'd0;
//-------------------------结束显示计数器-----gameover_show_flag计数器------------							
always@(posedge clk or negedge rst_n) begin
			if(!rst_n) begin
				count_gameover <= 32'd0;
		   end
			else begin
//------------------------0.001s计数1次--1000HZ-----------------------------------------
				if(count_gameover == 32'd50_000) begin 
					count_gameover <= 32'd0;
					if(gameover_show_flag == 4'd8)begin
						gameover_show_flag <= 4'd0;
					end
					else begin
						gameover_show_flag <= gameover_show_flag + 4'd1;
					end
//-----------------------------------------------------------------						
				end
				else begin
					count_gameover <= count_gameover + 32'd1;
				end
			end
	end  
//---------------------------蛇头---------------------------------------------------	
always@(posedge update or negedge rst_n) begin  						/*if(count == 32'd50_000_000)*/
        if(!rst_n)  begin
			 snake_x[0]  <= 7'b0001000;
			 snake_y[0]  <= 5'b00100;
			 game_over <= 2'd0;     //又可以重开了，好耶！！！
        end
        else begin
				case(snake_dir)
					right : begin  
									snake_x[0] <= {snake_x[0][0],snake_x[0][6:1]};
									snake_y[0] <= snake_y[0];		
							  end
					left : begin  
										snake_x[0] <= {snake_x[0][5:0],snake_x[0][6]};
										snake_y[0] <= snake_y[0];
							  end
					up : begin  
										snake_x[0] <= snake_x[0];
										snake_y[0] <= {snake_y[0][3:0],snake_y[0][4]};
							  end
					down : begin  
										snake_x[0] <= snake_x[0];
										snake_y[0] <= {snake_y[0][0],snake_y[0][4:1]};
							  end
					endcase
				if((snake_x[0] == 7'b0000001&&snake_dir == right)||(snake_x[0] == 7'b1000000 && snake_dir == left)||(snake_y[0] == 5'b10000 && snake_dir == up)||(snake_y[0] == 5'b00001 && snake_dir == down)) begin
						game_over <= 2'd1;
				end
				if(snake_x[0] == snake_x[1] && snake_y[0] == snake_y[1])    game_over <= 2'd1;
				else  if(snake_x[0] == snake_x[2] && snake_y[0] == snake_y[2])    game_over <= 2'd1;
				else  if(snake_x[0] == snake_x[3] && snake_y[0] == snake_y[3])    game_over <= 2'd1;
				else  if(snake_x[0] == snake_x[4] && snake_y[0] == snake_y[4])    game_over <= 2'd1;
				else  if(snake_x[0] == snake_x[5] && snake_y[0] == snake_y[5])    game_over <= 2'd1;
				else  if(snake_x[0] == snake_x[6] && snake_y[0] == snake_y[6])    game_over <= 2'd1;
				else  if(snake_x[0] == snake_x[7] && snake_y[0] == snake_y[7])    game_over <= 2'd1;
		  end
end	
//---------------------------蛇身---------------------------------------------------
wire [x_range:0] x_buff;
wire [y_range:0] y_buff;
always@(posedge update or negedge rst_n) begin
        if(!rst_n) begin
                snake_x[1] <= 7'd0;
                snake_y[1] <= 5'd0;
                snake_x[2] <= 7'd0;
                snake_y[2] <= 5'd0;
                snake_x[3] <= 7'd0;
                snake_y[3] <= 5'd0;
                snake_x[4] <= 7'd0;
                snake_y[4] <= 5'd0;
                snake_x[5] <= 7'd0;
                snake_y[5] <= 5'd0;
                snake_x[6] <= 7'd0;
                snake_y[6] <= 5'd0;
                snake_x[7] <= 7'd0;
                snake_y[7] <= 5'd0;
       end
       else begin
				case(snake_state_count)
						4'd0: begin
										snake_x[1] <= 7'd0;
										snake_y[1] <= 5'd0;
								end
						4'd1: begin	
										snake_x[1] <= snake_x[0];
										snake_y[1] <= snake_y[0];
								end
						4'd2: begin	
										snake_x[1] <= snake_x[0];
										snake_y[1] <= snake_y[0];
										snake_x[2] <= snake_x[1];
										snake_y[2] <= snake_y[1];
								end
						4'd3: begin	
										snake_x[1] <= snake_x[0];
										snake_y[1] <= snake_y[0];
										snake_x[2] <= snake_x[1];
										snake_y[2] <= snake_y[1];
										snake_x[3] <= snake_x[2];
										snake_y[3] <= snake_y[2];
								end						
						4'd4: begin	
										snake_x[1] <= snake_x[0];
										snake_y[1] <= snake_y[0];
										snake_x[2] <= snake_x[1];
										snake_y[2] <= snake_y[1];
										snake_x[3] <= snake_x[2];
										snake_y[3] <= snake_y[2];
										snake_x[4] <= snake_x[3];
										snake_y[4] <= snake_y[3];
								end						
						4'd5: begin	
										snake_x[1] <= snake_x[0];
										snake_y[1] <= snake_y[0];
										snake_x[2] <= snake_x[1];
										snake_y[2] <= snake_y[1];
										snake_x[3] <= snake_x[2];
										snake_y[3] <= snake_y[2];
										snake_x[4] <= snake_x[3];
										snake_y[4] <= snake_y[3];
										snake_x[5] <= snake_x[4];
										snake_y[5] <= snake_y[4];
								end						
						4'd6: begin	
										snake_x[1] <= snake_x[0];
										snake_y[1] <= snake_y[0];
										snake_x[2] <= snake_x[1];
										snake_y[2] <= snake_y[1];
										snake_x[3] <= snake_x[2];
										snake_y[3] <= snake_y[2];
										snake_x[4] <= snake_x[3];
										snake_y[4] <= snake_y[3];
										snake_x[5] <= snake_x[4];
										snake_y[5] <= snake_y[4];
										snake_x[6] <= snake_x[5];
										snake_y[6] <= snake_y[5];
								end						
						4'd7: begin	
										snake_x[1] <= snake_x[0];
										snake_y[1] <= snake_y[0];
										snake_x[2] <= snake_x[1];
										snake_y[2] <= snake_y[1];
										snake_x[3] <= snake_x[2];
										snake_y[3] <= snake_y[2];
										snake_x[4] <= snake_x[3];
										snake_y[4] <= snake_y[3];
										snake_x[5] <= snake_x[4];
										snake_y[5] <= snake_y[4];
										snake_x[6] <= snake_x[5];
										snake_y[6] <= snake_y[5];
										snake_x[7] <= snake_x[6];
										snake_y[7] <= snake_y[6];
								end
						default: begin
										snake_x[1] <= snake_x[0];
										snake_y[1] <= snake_y[0];
										snake_x[2] <= snake_x[1];
										snake_y[2] <= snake_y[1];
										snake_x[3] <= snake_x[2];
										snake_y[3] <= snake_y[2];
										snake_x[4] <= snake_x[3];
										snake_y[4] <= snake_y[3];
										snake_x[5] <= snake_x[4];
										snake_y[5] <= snake_y[4];
										snake_x[6] <= snake_x[5];
										snake_y[6] <= snake_y[5];
										snake_x[7] <= snake_x[6];
										snake_y[7] <= snake_y[6];
									end
				endcase
		 end
end
//---------------------------------------------------buff传输的暂存--------------------------------------------
assign x_buff = {snake_x[0],snake_x[1],snake_x[2],snake_x[3],snake_x[4],snake_x[5],snake_x[6],snake_x[7]};
assign y_buff = {snake_y[0],snake_y[1],snake_y[2],snake_y[3],snake_y[4],snake_y[5],snake_y[6],snake_y[7]};
//--------------------------------------------------------盒子生成-----------------------------------------------
    random_box u1_random_box(
         .clk(update),
         .rst_n(rst_n),
         .drive(drive_box_appear),								//生成驱动信号
         .box_x(snake_box_x),										//坐标信号
         .box_y(snake_box_y)
        );	
//-----------------------------------------count计数用于刷新蛇身长度-----------------------------------------
reg [3:0] snake_state_count = 4'd0;
//--------------------------------------------长度检测并驱动产生盒子-----------------------------------------
reg drive_box_appear = 1'd1; 
always@(posedge update or negedge rst_n) begin
        if(!rst_n) begin 
				drive_box_appear <= 1'd0; 
				snake_state_count = 4'd0;
		  end
		  else begin
				if(drive_box_appear)  drive_box_appear <= 1'd0;
				if(snake_x[0] == snake_box_x && snake_y[0] == snake_box_y) begin
					drive_box_appear <= 1'd1;
					if(snake_state_count < 4'd8) snake_state_count  <= snake_state_count + 4'd1;
					else snake_state_count <= snake_state_count;
				end
		  end
end
//-------------------------------------------------采集贪吃蛇LED信号并显示-------------------------------------
reg [7*9-1:0] x_buff1;  //7*9-1
reg [5*9-1:0] y_buff1;  //5*9-1
reg [1:0] goto_or_not = 2'd1;
reg [31:0] cnt = 32'd0;

always @ (posedge clk or negedge rst_n) begin
	if(!rst_n)begin
		cnt <= 32'd0;
		x_buff1 <= 63'd0;
		y_buff1 <= 45'd0;
	end
	else if(game_over == 2'd0) begin
		if(cnt == 32'd50_000) begin  //0.001s刷新一次  1000HZ
			cnt <= 32'd0;
			if(update && goto_or_not) begin
				x_buff1 <= {x_buff,snake_box_x};
				y_buff1 <= {y_buff,snake_box_y};
				goto_or_not <= 2'd0;
			end
			else begin
					x_buff1 <= {x_buff1[7*9-8:0],x_buff1[7*9-1:7*9-7]};
					y_buff1 <= {y_buff1[5*9-6:0],y_buff1[5*9-1:5*9-5]};
					snake_x_show <= x_buff1[7*9-1:7*9-7];
					snake_y_show <= y_buff1[5*9-1:5*9-5];
			end
			if(update == 2'd0) goto_or_not <= 2'd1;
		end
		else cnt <= cnt + 32'd1;
	end
////---------------------------------死亡,没什么好怕的---克尔苏加德----------------------------------------
	else if (game_over == 2'd1) begin
		case(gameover_show_flag)  //显示“G”
				4'd1: begin snake_x_show<=7'b1000000;snake_y_show<=5'b00000;end
				4'd2: begin snake_x_show<=7'b0100000;snake_y_show<=5'b01110;end
				4'd3: begin snake_x_show<=7'b0010000;snake_y_show<=5'b10001;end
				4'd4: begin snake_x_show<=7'b0001000;snake_y_show<=5'b00001;end
				4'd5: begin snake_x_show<=7'b0000100;snake_y_show<=5'b11101;end
				4'd6: begin snake_x_show<=7'b0000010;snake_y_show<=5'b11001;end
				4'd7: begin snake_x_show<=7'b0000001;snake_y_show<=5'b10110;end
		endcase
	end
end	


endmodule





