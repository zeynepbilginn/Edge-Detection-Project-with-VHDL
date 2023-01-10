----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 11/09/2022 10:01:39 AM
-- Design Name: 
-- Module Name: edge_det - Behavioral
-- Project Name: 
-- Target Devices: 
-- Tool Versions: 
-- Description: 
-- 
-- Dependencies: 
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
-- 
----------------------------------------------------------------------------------


library IEEE;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.std_logic_unsigned.all;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity edge_det is
  Port (
  clk : in std_logic;
  wr_pixel : in std_logic;
  pixel_data: in std_logic_vector(15 downto 0);
  wr_addr : in integer;
  
  pixel_out :  out std_logic_vector(15 downto 0);
  wr_out: out std_logic:='0'
   );
end edge_det;

architecture Behavioral of edge_det is

type RAM_ARRAY is array (0 to 66563 ) of std_logic_vector (15 downto 0); --258*258 
signal RAM: RAM_ARRAY := (  others => (others=>'0') ) ;

type RAM_ARRAY_out is array (0 to 65536 ) of std_logic_vector (19 downto 0); --256*256
signal RAM_out: RAM_ARRAY_out := (  others => (others=>'0') ) ;

signal wr_pixet_out,data_read_out: std_logic_vector(19 downto 0);
signal wren_pixel_out : std_logic:='0';
signal data_read: std_logic_vector(15 downto 0);
signal rd_addr,wr_addr_out,bit_sirasi,rd_addr_out : integer:=0;
signal state,max_val : integer:=0;
signal x_counter : integer:=0;
signal y_counter : integer:=0;

signal grad_x : integer:=0;
signal grad_y : integer:=0;
--Gx = [1 0 -1; 2 0 -2; 1 0 -1];
signal Gx1_1 : integer :=1;
signal Gx1_2 : integer :=0;
signal Gx1_3 : integer :=-1;

signal Gx2_1 : integer :=2;
signal Gx2_2 : integer :=0;
signal Gx2_3 : integer :=-2;

signal Gx3_1 : integer :=1;
signal Gx3_2 : integer :=0;
signal Gx3_3 : integer :=-1;

--Gy = [1 2 1; 0 0 0; -1 -2 -1];
signal Gy1_1 : integer :=1;
signal Gy1_2 : integer :=2;
signal Gy1_3 : integer :=1;
        
signal Gy2_1 : integer :=0;
signal Gy2_2 : integer :=0;
signal Gy2_3 : integer :=0;
        
signal Gy3_1 : integer :=-1;
signal Gy3_2 : integer :=-2;
signal Gy3_3 : integer :=-1;

begin

	

process(clk)
begin
 if(rising_edge(clk)) then
    if(wr_pixel='1') then 
        RAM(wr_addr) <= pixel_data;
    end if;
    
    
   
 end if;
end process;
 
data_read<=RAM(rd_addr);  -- bunu yukarda yapsaydık datayı 1 clock  geciktirirdi

process(clk)
begin
 if(rising_edge(clk)) then
    case state is 
        when 0=>
            wr_out<='0';
            if(wr_pixel='1') then 
                state<=state+1;        
            end if;
        when 1=>
            max_val<=0;
            x_counter<=0;
            y_counter<=0;
            if(wr_pixel='0') then 
                state<=state+1;        
            end if;   
        when 2=>   --1 
            wren_pixel_out<='0';
            grad_x<=0;
            grad_y<=0;
            rd_addr<=(y_counter)*258+x_counter;
            state<=state+1; 
        when 3=>
            grad_x<=grad_x+Gx1_1*to_integer(unsigned(data_read));
            grad_y<=grad_y+Gy1_1*to_integer(unsigned(data_read));
            rd_addr<=rd_addr+1;
            state<=state+1;  
        when 4=>
            grad_x<=grad_x+Gx1_2*to_integer(unsigned(data_read));
            grad_y<=grad_y+Gy1_2*to_integer(unsigned(data_read));
            rd_addr<=rd_addr+1;
            state<=state+1;     

        when 5=>   --2 
            grad_x<=grad_x+Gx1_3*to_integer(unsigned(data_read));
            grad_y<=grad_y+Gy1_3*to_integer(unsigned(data_read));
            rd_addr<=(y_counter+1)*258+x_counter;
            state<=state+1;             

        when 6=>
            grad_x<=grad_x+Gx2_1*to_integer(unsigned(data_read));
            grad_y<=grad_y+Gy2_1*to_integer(unsigned(data_read));
            rd_addr<=rd_addr+1;
            state<=state+1;  
        when 7=>
            grad_x<=grad_x+Gx2_2*to_integer(unsigned(data_read));
            grad_y<=grad_y+Gy2_2*to_integer(unsigned(data_read));
            rd_addr<=rd_addr+1;
            state<=state+1;  

        when 8=>   --3
            grad_x<=grad_x+Gx2_3*to_integer(unsigned(data_read));
            grad_y<=grad_y+Gy2_3*to_integer(unsigned(data_read));
            rd_addr<=(y_counter+2)*258+x_counter;
            state<=state+1;    


        when 9=>
            grad_x<=grad_x+Gx3_1*to_integer(unsigned(data_read));
            grad_y<=grad_y+Gy3_1*to_integer(unsigned(data_read));
            rd_addr<=rd_addr+1;
            state<=state+1;  
        when 10=>
            grad_x<=grad_x+Gx3_2*to_integer(unsigned(data_read));
            grad_y<=grad_y+Gy3_2*to_integer(unsigned(data_read));
            rd_addr<=rd_addr+1;
            state<=state+1;    
        when 11 =>
            grad_x<=grad_x+Gx3_3*to_integer(unsigned(data_read)); 
            grad_y<=grad_y+Gy3_3*to_integer(unsigned(data_read)); 
             state<=state+1;  
        when 12 =>   --mutlak değer
            state<=state+1; 
            if(grad_x<0) then
                grad_x<=0-grad_x;
            end if;
            if(grad_y<0)then
                grad_y<=0-grad_y;
            end if;    
        when 13=>
            wren_pixel_out<='1';
            wr_addr_out<=(y_counter)*256+x_counter;
            wr_pixet_out<=std_logic_vector(to_unsigned(grad_x+grad_y, wr_pixet_out'length));
            if(grad_x+grad_y>max_val) then
                max_val<=grad_x+grad_y;
            end if;
            
            if(x_counter>=255) then
                x_counter<=0;
                y_counter<=y_counter+1;
            else
                x_counter<=x_counter+1;
            end if;
            
			
			
            if(x_counter>=255 and y_counter>=255) then --loop
                 state<=state+1; 
             else
                state<=2;
            end if;
        when 14=>
            wren_pixel_out<='0';
            if(max_val<65536) then
                bit_sirasi<=0;
            elsif(max_val<131072) then
                bit_sirasi<=1;
            elsif(max_val<262144) then
                bit_sirasi<=2;                
            else
                bit_sirasi<=3;     
            end if;
                           
            state<=state+1;
        when 15 =>
            rd_addr_out<=0;
            state<=state+1;
            wr_out<='0';
        when 16 =>
            rd_addr_out<=rd_addr_out+1;
            if(bit_sirasi=0) then
                pixel_out<=data_read_out(15 downto 0);
            elsif(bit_sirasi=1) then
                pixel_out<=data_read_out(16 downto 1);
            elsif(bit_sirasi=2) then
                pixel_out<=data_read_out(17 downto 2);
            else
                pixel_out<=data_read_out(18 downto 3);     
            end if;                       
            wr_out<='1';
            if(rd_addr_out>=65535) then
                state<=0; 
            end if;
        when others =>
             state<=0;   
        end case;                                               
 end if;
end process;


process(clk)
begin
 if(rising_edge(clk)) then
    if(wren_pixel_out='1') then 
        RAM_out(wr_addr_out) <= wr_pixet_out;
    end if;
    
    
    
 end if;
end process;
data_read_out<=RAM_out(rd_addr_out);





end Behavioral;
