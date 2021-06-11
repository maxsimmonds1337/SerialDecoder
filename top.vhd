----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    20:08:00 06/01/2021 
-- Design Name: 
-- Module Name:    top - Behavioral 
-- Project Name: 
-- Target Devices: 
-- Tool versions: 
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
use IEEE.std_logic_1164.all;            -- basic IEEE library
use IEEE.std_logic_unsigned.all;		-- required for std logic vecotrs
use IEEE.numeric_std.all;               -- IEEE library for the unsigned type and various arithmetic operators


-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity top is
    Port ( 
			  pixel_clk	:	in	STD_LOGIC;
			  RX : in  STD_LOGIC;
           TX : out  STD_LOGIC);
end top;

architecture Behavioral of top is

constant c_CNT_50HZ	:	natural :=	500000; -- main clock is 25mhz so 25m/50 * 0.5 (50% duty cycle)

signal r_TOGGLE_50HZ :	std_logic	:=	'0';
signal r_CNT_50HZ	:	natural range 0 to c_CNT_50HZ;

begin

Serial: process(pixel_clk) is

 begin

	 if(rising_edge(pixel_clk)) then 
	 
		if r_CNT_50HZ = c_CNT_50HZ-1 then
			r_TOGGLE_50HZ <= not r_TOGGLE_50HZ;
			r_CNT_50HZ <= 0;
		else
			r_CNT_50HZ <= r_CNT_50HZ + 1;
		end if;
	 end if;
end process Serial;

TX <= r_TOGGLE_50HZ; -- give the toggle value to the output

end Behavioral;

