`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 05/07/2026 01:48:38 PM
// Design Name: 
// Module Name: seg_decoder
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


module seg_decoder(
        nibble,
        seg
    );
    
    input [3:0] nibble;
    output reg [6:0] seg;
    
    /*
    segment register to segment section (LSB to MSB order)
    
    seg[0] = top            LSB
    seg[1] = top_right
    seg[2] = botom_right
    seg[3] = bottom
    seg[4] = bottom_left
    seg[5] = top_left
    seg[6] = middle         MSB
    
    digital low means that the section is turned on
    
    
    */
    
    always @(*) begin
        case (nibble)
            4'h0: seg = 7'b1000000;
            4'h1: seg = 7'b1111001;
            4'h2: seg = 7'b0100100;
            4'h3: seg = 7'b0110000;
            4'h4: seg = 7'b0011001;
            4'h5: seg = 7'b0010010;
            4'h6: seg = 7'b0000010;
            4'h7: seg = 7'b1111000;
            4'h8: seg = 7'b0000000;
            4'h9: seg = 7'b0010000;
            4'hA: seg = 7'b0001000;
            4'hb: seg = 7'b0000011;
            4'hC: seg = 7'b1000110;
            4'hd: seg = 7'b0100001;
            4'hE: seg = 7'b0000110;
            4'hF: seg = 7'b0001110;
            
            default: seg = 7'b1111111;
        endcase
    end
endmodule
