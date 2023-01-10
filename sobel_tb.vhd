----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 
-- Design Name: 
-- Module Name: sobel_tb - Behavioral
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


library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.std_logic_unsigned.all;
use std.textio.all;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity sobel_tb is
--  Port ( );
end sobel_tb;

architecture Behavioral of sobel_tb is
constant clk_period : time := 10 ns;
signal reset : std_logic:='0';
signal clk : std_logic:='0';
signal pixel_data: std_logic_vector(15 downto 0);
signal wr_pixel: std_logic:='0';
signal wr_out : std_logic;
signal pixel_out : std_logic_vector(15 downto 0);
signal wr_addr : integer;

component edge_det is
  Port (
  clk : in std_logic;
  wr_pixel : in std_logic;
  pixel_data: in std_logic_vector(15 downto 0);
  wr_addr : in integer;
    pixel_out :  out std_logic_vector(15 downto 0);
  wr_out: out std_logic:='0'
   );
end component;

begin


edge_det1 : edge_det

port map (
   clk => clk,
   wr_pixel => wr_pixel,
   pixel_data => pixel_data,
   wr_addr => wr_addr,
   
   pixel_out =>pixel_out,
   wr_out => wr_out
 
);


clk <= not clk after clk_period;
reset <= '1', '0' after 20*clk_period ;
p_read : process(reset,clk)
--------------------------------------------------------------------------------------------------
constant NUM_COL                : integer := 1;   -- number of column of file
type t_integer_array       is array(integer range <> )  of integer;
file test_vector                : text open read_mode is "grey_im.txt";
variable row                    : line;
variable v_data_read            : t_integer_array(1 to NUM_COL);
variable v_data_row_counter     : integer := 0;

variable x_counter     : integer := 0;
variable y_counter     : integer := 0;
begin
  
  if(reset='1') then
    v_data_row_counter     := 0;
    v_data_read            := (others=> -1);
    wr_pixel<='0';
    wr_addr<=0;
    x_counter:=0;
    y_counter:=0;
  ------------------------------------
  elsif(rising_edge(clk)) then
    
    if(v_data_row_counter<256*256) then  -- external enable signal
    
    -- read from input file in "row" variable
      if(not endfile(test_vector)) then
        v_data_row_counter := v_data_row_counter + 1;
        readline(test_vector,row);
      end if;
    
    -- read integer number from "row" variable in integer array
      for kk in 1 to NUM_COL loop
        read(row,v_data_read(kk));
      end loop;
      wr_addr<=(y_counter+1)*258+x_counter+1;
      pixel_data<=std_logic_vector(to_unsigned(v_data_read(1), pixel_data'length));
      wr_pixel<='1';
      
      if(x_counter>=255) then
            y_counter:=y_counter+1;
            x_counter:=0;
        
      else
        
            x_counter:=x_counter+1;
      end if;  
      
    else
      wr_pixel<='0';  
    end if;
    
  end if;
end process p_read;



p_write  : process(reset,clk)
file test_vector      : text open write_mode is "edge_out.txt";
variable row          : line;
begin
  
  if(reset='1') then
  ------------------------------------
  elsif(rising_edge(clk)) then
    
    if(wr_out = '1') then
    
  
      
      write(row,to_integer(unsigned(pixel_out)), left, 16);

      
      writeline(test_vector,row);
    
    end if;
  end if;
end process p_write;




end Behavioral;
