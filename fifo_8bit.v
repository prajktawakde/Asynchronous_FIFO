`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 24.05.2023 22:00:04
// Design Name: 
// Module Name: ntapfilter
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



module fifo_8bit( clk_w, clk_r, rst, buf_in, buf_out, wr_en, rd_en, buf_empty, buf_full, fifo_counter);

  input rst, clk_w, clk_r, wr_en, rd_en;  
  input [7:0] buf_in;                  
  output reg [7:0] buf_out;                  
  output reg buf_empty, buf_full;      
  output reg [3:0] fifo_counter;            

 
  reg[3 -1:0] rd_ptr, wr_ptr;          
  reg[7:0] buf_mem[7:0];  

  always @(fifo_counter)
  begin
     buf_empty = (fifo_counter==0);
     buf_full = (fifo_counter== 8);

  end

  always @(posedge clk_w or posedge rst) //manage the fifo_counter
begin
     if( rst )
         fifo_counter <= 0;

     else if( (!buf_full && wr_en) && ( !buf_empty && rd_en ) )
         fifo_counter <= fifo_counter;

     else if( !buf_full && wr_en )
         fifo_counter <= fifo_counter + 1;
    else
        fifo_counter <= fifo_counter;
end
 
  always @(posedge clk_r or posedge rst) //manage the fifo_counter
begin
       if( !buf_empty && rd_en )
           fifo_counter <= fifo_counter - 1;
       else
          fifo_counter <= fifo_counter;
    end

  always @( posedge clk_r or posedge rst) //fetching data from FIFO
    begin
       if( rst )
          buf_out <= 0;
       else
       begin
          if( rd_en && !buf_empty )
             buf_out <= buf_mem[rd_ptr];

          else
             buf_out <= buf_out;

       end
    end

  always @(posedge clk_w) //writing data in FIFO
    begin

       if( wr_en && !buf_full )
          buf_mem[ wr_ptr ] <= buf_in;

       else
          buf_mem[ wr_ptr ] <= buf_mem[ wr_ptr ];
    end

  always@(posedge clk_w or posedge rst) //manage pointers
    begin
       if( rst )
       begin
          wr_ptr <= 0;
       end
       else
       begin
          if( !buf_full && wr_en )    
            wr_ptr <= wr_ptr + 1;
          else  
            wr_ptr <= wr_ptr;
end
    end
 
  always@(posedge clk_r or posedge rst) //manage pointers
begin
     if( rst )
       begin
          rd_ptr <= 0;
       end
     else
       begin
          if( !buf_empty && rd_en )  
            rd_ptr <= rd_ptr + 1;
          else
            rd_ptr <= rd_ptr;
       end

    end
endmodule

