module Newton(
x_zero,
b_value,
clk,
enable,
asyn_reset
);

input clk;
input enable;
input asyn_reset;
input [1:0] x_zero;
input [1:0] b_value;

wire [1:0] product_one;
wire [1:0] add_one_op_two;
wire [1:0] sum_one;
wire [1:0] quotient_one;
wire [1:0] div_one_op_two;
wire [1:0] add_two_op_one, sum_two;
wire enable_mul_one;
wire empty_fifo_add, full_fifo_add;
wire empty_fifo_div, full_fifo_div;
wire empty_fifo_add_two, full_fifo_add_two;

reg [10:0] counter;
reg enable_add_one_fifo, enable_add_one;
reg enable_div_one_fifo, enable_div_one;
reg enable_add_two_fifo, enable_add_two;


assign enable_mul_one= enable;

//---------------------First iteration
Multiplier_v2 mul_one(
x_zero,
x_zero,
clk,
asyn_reset,
enable,
product_one
);

syn_fifo FIFO_add(
clk      , // Clock input
asyn_reset , // Active high reset
enable_mul_one, // Write chip select
enable_add_one_fifo, // Read chipe select
b_value  , // Data input
enable_add_one_fifo, // Read enable
enable_mul_one, // Write Enable
add_one_op_two, // Data Outpur
empty_fifo_add    , // FIFO empty
full_fifo_add       // FIFO full
);    
defparam FIFO_add.DATA_WIDTH=2;

always @ (posedge clk or posedge asyn_reset) begin
	if (asyn_reset) begin
		counter <= 0;
	end
	else begin
		counter <= counter + 1 ;
	end	
end

always @ (posedge clk or posedge asyn_reset) begin
	if (asyn_reset) begin
		enable_add_one_fifo<= 0;
	end
	else begin
		if (counter > 2 ) begin
			enable_add_one_fifo <= 1;
		end
		else begin
			enable_add_one_fifo <= 0;
		end
		if (counter > 3) begin
			enable_add_one <= 1;
		end
		else begin
			enable_add_one <= 0;
		end
		if (counter > 5) begin
			enable_div_one_fifo <= 1;
		end
		else begin
			enable_div_one_fifo <= 0;
		end
		if (counter > 6) begin
			enable_div_one <= 1; 
		end
		else begin
			enable_div_one <= 0;
		end
		if (counter > 12) begin
			enable_add_two_fifo <= 1;
		end
		else begin
			enable_add_two_fifo <= 0;
		end
		if (counter > 13) begin
			enable_add_two <= 1;
		end
		else begin
			enable_add_two <= 0;
		end
	end
end

Online_adder_hd add_one(
product_one,
~add_one_op_two,
clk,
sum_one,
asyn_reset,
enable_add_one
);

syn_fifo FIFO_div_one(
clk      , // Clock input
asyn_reset , // Active high reset
enable_mul_one, // Write chip select
enable_div_one_fifo, // Read chipe select
x_zero, // Data input
enable_div_one_fifo, // Read enable
enable_mul_one, // Write Enable
div_one_op_two, // Data Outpur
empty_fifo_div, // FIFO empty
full_fifo_div      // FIFO full
);
defparam FIFO_div_one.DATA_WIDTH=2;

Divider_v2 div_one(
~sum_one,
div_one_op_two,
clk,
asyn_reset,
enable_div_one,
quotient_one
);

syn_fifo FIFO_add_two(
clk      , // Clock input
asyn_reset , // Active high reset
enable_mul_one, // Write chip select
enable_add_two_fifo, // Read chipe select
x_zero, // Data input
enable_add_two_fifo, // Read enable
enable_mul_one, // Write Enable
add_two_op_one, // Data Outpur
empty_fifo_add_two    , // FIFO empty
full_fifo_add_two       // FIFO full
);
defparam FIFO_add_two.DATA_WIDTH = 2;

Online_adder_hd add_two(
add_two_op_one,
div_one_op_two,
clk,
sum_two,
asyn_reset,
enable_add_two
);

//------Second iter----------------

wire[1:0] x_one;
wire [1:0] product_two;
wire enable_mul_two_fifo;

wire [1:0] add_three_op_two;
wire [1:0] sum_three;
wire [1:0] div_two_op_two, quotient_two;
wire [1:0] add_four_op_one;
wire [1:0] sum_four;
wire empty_fifo_add_three, full_fifo_add_three;
wire empty_fifo_div_two, full_fifo_div_two;
wire empty_fifo_add_four, full_fifo_add_four;

reg enable_add_three_fifo;
reg enable_mul_two;
reg enable_add_three;
reg enable_div_two_fifo, enable_div_two;
reg enable_add_four_fifo, enable_add_four;

assign x_one = sum_two;

Multiplier_v2 mul_two(
x_one,
x_one,
clk,
asyn_reset,
enable_mul_two,
product_two
);

always @ (posedge clk or posedge asyn_reset) begin
	if (asyn_reset) begin
		enable_mul_two <= 0;
	end
	else begin
		if (counter > 16) begin
			enable_mul_two <= 1;
		end
		else begin
			enable_mul_two <= 0;
		end
		if (counter > 22) begin
			enable_add_three_fifo <= 1;
		end
		else begin
			enable_add_three_fifo <= 0;
		end
		if (counter > 20) begin
			enable_add_three <= 1;
		end
		else begin
			enable_add_three <= 0;
		end

		if (counter > 25) begin
			enable_div_two_fifo <= 1;
		end
		else begin
			enable_div_two_fifo <= 0;
		end
		if (counter > 27) begin
			enable_div_two <= 1;
		end
		else begin
			enable_div_two <= 0;
		end
		if (counter > 29) begin
			enable_add_four_fifo <= 1;
		end
		else begin
			enable_add_four_fifo <= 0;
		end
		if (counter > 30) begin
			enable_add_four <= 1;
		end
		else begin
			enable_add_four <= 0;
		end
	end
end



syn_fifo FIFO_add_three(
clk      , // Clock input
asyn_reset , // Active high reset
enable_mul_one, // Write chip select
enable_add_three_fifo, // Read chipe select
b_value, // Data input
enable_add_three_fifo, // Read enable
enable_mul_one, // Write Enable
add_three_op_two, // Data Outpur
empty_fifo_add_three    , // FIFO empty
full_fifo_add_three       // FIFO full
);
defparam FIFO_add_three.DATA_WIDTH = 2;

Online_adder_hd add_three(
product_two,
~add_three_op_two,
clk,
sum_three,
asyn_reset,
enable_add_three
);

syn_fifo FIFO_div_two(
clk      , // Clock input
asyn_reset , // Active high reset
enable_mul_two, // Write chip select
enable_div_two_fifo, // Read chipe select
x_one, // Data input
enable_div_two_fifo, // Read enable
enable_mul_two, // Write Enable
div_two_op_two, // Data Outpur
empty_fifo_div_two, // FIFO empty
full_fifo_div_two       // FIFO full
);
defparam FIFO_div_two.DATA_WIDTH = 2;

Divider_v2 div_two(
~sum_three,
div_two_op_two,
clk,
asyn_reset,
enable_div_two,
quotient_two
);


syn_fifo FIFO_add_four(
clk      , // Clock input
asyn_reset , // Active high reset
enable_mul_two, // Write chip select
enable_add_four_fifo, // Read chipe select
x_one, // Data input
enable_add_four_fifo, // Read enable
enable_mul_two, // Write Enable
add_four_op_one, // Data Outpur
empty_fifo_add_four    , // FIFO empty
full_fifo_add_four       // FIFO full
);
defparam FIFO_add_four.DATA_WIDTH = 2;

Online_adder_hd add_four(
add_four_op_one,
~quotient_two,
clk,
sum_four,
asyn_reset,
enable_add_four
);

// Iter three ---------------------------


wire[1:0] x_three;
wire [1:0] product_three;
wire enable_mul_three_fifo;

wire [1:0] add_five_op_two;
wire [1:0] sum_five;
wire [1:0] div_three_op_two, quotient_three;
wire [1:0] add_six_op_one;
wire [1:0] sum_six;
wire empty_fifo_add_five, full_fifo_add_five;
wire empty_fifo_div_three, full_fifo_div_three;
wire empty_fifo_add_six, full_fifo_add_six;

reg enable_add_five_fifo;
reg enable_mul_three;
reg enable_add_five;
reg enable_div_three_fifo, enable_div_three;
reg enable_add_six_fifo, enable_add_six;

assign x_three= sum_four;

Multiplier_v2 mul_three(
x_three,
x_three,
clk,
asyn_reset,
enable_mul_three,
product_three
);

syn_fifo FIFO_add_five(
clk      , // Clock input
asyn_reset , // Active high reset
enable_mul_one, // Write chip select
enable_add_five_fifo, // Read chipe select
b_value, // Data input
enable_add_five_fifo, // Read enable
enable_mul_one, // Write Enable
add_five_op_two, // Data Outpur
empty_fifo_add_five, // FIFO empty
full_fifo_add_five// FIFO full
);
defparam FIFO_add_five.DATA_WIDTH = 2;


Online_adder_hd add_five(
product_three,
~add_five_op_two,
clk,
sum_five,
asyn_reset,
enable_add_five
);


syn_fifo FIFO_div_three(
clk      , // Clock input
asyn_reset , // Active high reset
enable_mul_three, // Write chip select
enable_div_three_fifo, // Read chipe select
x_three, // Data input
enable_div_three_fifo, // Read enable
enable_mul_three, // Write Enable
div_three_op_two, // Data Outpur
empty_fifo_div_three, // FIFO empty
full_fifo_div_three// FIFO full
);
defparam FIFO_div_three.DATA_WIDTH = 2;

reg [1:0] sum_five_tmp;
always @ (*) begin
	if (sum_five == 2'b11) begin
		sum_five_tmp = 2'b00;
	end
	else begin
		sum_five_tmp = sum_five;
	end
end

Divider_v2 div_three(
sum_five_tmp,
div_three_op_two,
clk,
asyn_reset,
enable_div_three,
quotient_three
);

syn_fifo FIFO_add_six(
clk      , // Clock input
asyn_reset , // Active high reset
enable_mul_three, // Write chip select
enable_add_six_fifo, // Read chipe select
x_three, // Data input
enable_add_six_fifo, // Read enable
enable_mul_three, // Write Enable
add_six_op_one, // Data Outpur
empty_fifo_add_six, // FIFO empty
full_fifo_add_six// FIFO full
);
defparam FIFO_add_six.DATA_WIDTH = 2;


Online_adder_hd add_six(
add_six_op_one,
~quotient_three,
clk,
sum_six,
asyn_reset,
enable_add_six
);


always @ (posedge clk or posedge asyn_reset) begin
	if (asyn_reset) begin
		enable_mul_three <= 0;
		enable_add_five_fifo <= 0;
		enable_add_five <= 0;
	end
	else begin
		if (counter > 34) begin
			enable_mul_three <= 1;
		end
		else begin
			enable_mul_three <= 0;
		end
		if (counter > 42) begin
			enable_add_five_fifo <= 1;
		end
		else begin
			enable_add_five_fifo <= 0;
		end
		if (counter > 42) begin
			enable_add_five <= 1;
		end
		else begin
			enable_add_five <= 0;
		end
		if (counter > 48) begin
			enable_div_three_fifo <= 1;
		end
		else begin
			enable_div_three_fifo <=0;
		end
		if (counter> 49) begin
			enable_div_three <= 1;
		end
		else begin
			enable_div_three <= 0;
		end
		if (counter > 50) begin
			enable_add_six_fifo <= 1;
		end
		else begin
			enable_add_six_fifo <= 0;
		end
		if (counter > 50) begin
			enable_add_six <= 1;
		end
		else begin 
			enable_add_six <= 0;
		end
	end
end

// iter four


wire[1:0] x_four;
wire [1:0] product_four;
wire enable_mul_four_fifo;

wire [1:0] add_seven_op_two;
wire [1:0] sum_seven;
wire [1:0] div_four_op_two, quotient_four;
wire [1:0] add_eight_op_one;
wire [1:0] sum_eight;
wire empty_fifo_add_seven, full_fifo_add_seven;
wire empty_fifo_div_four, full_fifo_div_four;
wire empty_fifo_add_eight, full_fifo_add_eight;

reg enable_add_seven_fifo;
reg enable_mul_four;
reg enable_add_seven;
reg enable_div_four_fifo, enable_div_four;
reg enable_add_eight_fifo, enable_add_eight;

assign x_four= sum_six;

Multiplier_v2 mul_four(
x_four,
x_four,
clk,
asyn_reset,
enable_mul_four,
product_four
);

syn_fifo FIFO_add_seven(
clk      , // Clock input
asyn_reset , // Active high reset
enable_mul_one, // Write chip select
enable_add_seven_fifo, // Read chipe select
b_value, // Data input
enable_add_seven_fifo, // Read enable
enable_mul_one, // Write Enable
add_seven_op_two, // Data Outpur
empty_fifo_add_seven, // FIFO empty
full_fifo_add_seven// FIFO full
);
defparam FIFO_add_seven.DATA_WIDTH = 2;


Online_adder_hd add_seven(
product_four,
~add_seven_op_two,
clk,
sum_seven,
asyn_reset,
enable_add_seven
);


syn_fifo FIFO_div_four(
clk      , // Clock input
asyn_reset , // Active high reset
enable_mul_four, // Write chip select
enable_div_four_fifo, // Read chipe select
x_four, // Data input
enable_div_four_fifo, // Read enable
enable_mul_four, // Write Enable
div_four_op_two, // Data Outpur
empty_fifo_div_four, // FIFO empty
full_fifo_div_four// FIFO full
);
defparam FIFO_div_four.DATA_WIDTH = 2;

reg [1:0] div_four_op_one;

always @ (*) begin
	if (~sum_seven == 2'b11) begin
		div_four_op_one = 2'b00;
	end
	else begin
		div_four_op_one = ~sum_seven;
	end
end


Divider_v2 div_four(
div_four_op_one,
div_four_op_two,
clk,
asyn_reset,
enable_div_four,
quotient_four
);


always @ (posedge clk or posedge asyn_reset) begin
	if (asyn_reset) begin
		enable_mul_four <= 0;
		enable_add_seven_fifo <= 0;
		enable_add_seven <= 0;
	end
	else begin
		if (counter > 55) begin
			enable_mul_four <= 1;
		end
		else begin
			enable_mul_four <= 0;
		end
		if (counter > 63) begin
			enable_add_seven_fifo <= 1;
		end
		else begin
			enable_add_seven_fifo <= 0;
		end
		if (counter > 61) begin
			enable_add_seven <= 1;
		end
		else begin
			enable_add_seven <= 0;
		end
		if (counter > 70) begin
			enable_div_four_fifo <= 1;
		end
		else begin
			enable_div_four_fifo <= 0;
		end
		if (counter > 71) begin
			enable_div_four <=1;
		end
		else begin
			enable_div_four <= 0;
		end
		if (counter >70) begin
			enable_add_eight_fifo <= 1;
		end
		else begin
			enable_add_eight_fifo <= 0;
		end
		if (counter > 71) begin
			enable_add_eight <= 1;
		end
		else begin
			enable_add_eight <= 0;
		end
	end	
end

syn_fifo FIFO_add_eight(
clk      , // Clock input
asyn_reset , // Active high reset
enable_mul_four, // Write chip select
enable_add_eight_fifo, // Read chipe select
x_four, // Data input
enable_add_eight_fifo, // Read enable
enable_mul_four, // Write Enable
add_eight_op_one, // Data Outpur
empty_fifo_add_eight, // FIFO empty
full_fifo_add_eight// FIFO full
);
defparam FIFO_add_eight.DATA_WIDTH = 2;


Online_adder_hd add_eight(
add_eight_op_one,
~quotient_four,
clk,
sum_eight,
asyn_reset,
enable_add_eight
);

endmodule
