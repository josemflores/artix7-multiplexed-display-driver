`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 05/07/2026 01:48:38 PM
// Design Name: 
// Module Name: seg_top
// Project Name: 
// Target Devices:
// Tool Versions:
// Description:
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created                                  
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module seg_top(
        clk,
        sw,
        seg,
        an,
    );
    
    input clk;
    input [15:0] sw;
    wire [3:0] digit_enable;
    
    output reg [6:0] seg;
    output reg [3:0] an;
    
    wire [3:0] nibble_1;
    wire [3:0] nibble_2;
    wire [3:0] nibble_3;
    wire [3:0] nibble_4;
    wire [6:0] seg_1;
    wire [6:0] seg_2;
    wire [6:0] seg_3;
    wire [6:0] seg_4;
    
    reg [15:0] latched_sw;
    reg [16:0] counter;

        //only include this assignment if you plan on using this module standalone.
        //Otherwise, delete this and include the assignment as part of your ports
    assign digit_enable = 4'b1111;
        
    assign nibble_1 = latched_sw[3:0];
    assign nibble_2 = latched_sw[7:4];
    assign nibble_3 = latched_sw[11:8];
    assign nibble_4 = latched_sw[15:12];
    
    seg_decoder dec_1(
        .nibble(nibble_1),
        .seg(seg_1)
        );
        
    seg_decoder dec_2(
        .nibble(nibble_2),
        .seg(seg_2)
        );
    
    seg_decoder dec_3(
        .nibble(nibble_3),
        .seg(seg_3)
        );
        
    seg_decoder dec_4(
        .nibble(nibble_4),
        .seg(seg_4)
        );
        
    always @(*) begin
        if (counter[16:15] == 2'b00) begin
            an = 4'b1110 | ~{3'b000, digit_enable[0]};
            seg = seg_1;
        end
        else if (counter[16:15] == 2'b01) begin
            an = 4'b1101 | ~{2'b00, digit_enable[1], 1'b0};
            seg = seg_2;
        end
        else if (counter[16:15] == 2'b10) begin
            an = 4'b1011 | ~{1'b0, digit_enable[2], 2'b0};
            seg = seg_3;
        end
        else begin
            an = 4'b0111 | ~{digit_enable[3], 3'b000};
            seg = seg_4;
        end
    end
    
    always @(posedge clk) begin
    	counter <= counter + 1;
    	latched_sw <= sw;
    end
    
endmodule
