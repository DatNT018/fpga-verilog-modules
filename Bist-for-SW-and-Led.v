`timescale 1ns / 1ps
 
module bist(
  input clk,
  input [3:0] sw,
  output [3:0] led);
    
  integer count = 0;
  reg sclk = 0;
 
  always@(posedge clk) begin  ///// 10^8 -> 1/10^8 *  = 1
    if(count < 10) ///N/2
      count <= count + 1;
    else
    begin
      count <= 0;
      sclk <= ~sclk;
    end
  end
  
  reg flag   = 1'b0;
  
  always@(posedge clk)
  begin
    if(sw == 4'b0000)
      flag <= 1'b0;
    else
      flag <= 1'b1;
  end
  
  
  integer i  = 0;
  reg [3:0] temp = 0;
  
  always@(posedge sclk)
  begin
    if(flag == 1'b0) begin
      if(i < 4) 
        begin
          temp <= { 1'b1, temp[3:1]}; ///shift 1 in R dir
          i <= i + 1;
        end
        else if(i < 8)
        begin
          i <= i + 1;
          temp <= {temp[2:0], 1'b0}; /////shift 1 in L dir
        end
        else
        begin
          i <= 0;
          temp <= 4'b0000;
        end          
    end
    else
    begin
      temp <= sw;
    end
  end
  
  assign led = temp;
    
endmodule