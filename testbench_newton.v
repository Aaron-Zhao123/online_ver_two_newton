`timescale 1ns/1ps
module testbench_newton();

reg clk;
reg asyn_reset;
reg enable;
reg [1:0] x_zero, b_value;

integer data_value_file_x_zero,data_value_file_b;
integer scan_file_x,scan_file_b;
integer control=0;
integer cnt=0;

initial begin
	clk=1;
	while(1) begin
		#10 clk=~clk;
		cnt = cnt + 1;
	end
end
initial begin
  data_value_file_x_zero=$fopen("/home/aaron/verilog/Online_ver_two/Newton/src_newton/src_newton/x_zero_value.txt","r");
  
  data_value_file_b=$fopen("/home/aaron/verilog/Online_ver_two/Newton/src_newton/src_newton/b_value.txt","r");
  asyn_reset <= 1;
  enable <= 1;
end
initial begin 
	scan_file_x=$fscanf(data_value_file_x_zero,"%b",x_zero);
	scan_file_b=$fscanf(data_value_file_b,"%b",b_value);
end

Newton newton(
	x_zero,
	b_value,
	clk,
	enable,
	asyn_reset
);

always@(negedge clk) begin
	asyn_reset <= 0;
	scan_file_b=$fscanf(data_value_file_b,"%b",b_value);
	scan_file_x=$fscanf(data_value_file_x_zero,"%b",x_zero);
end


endmodule
