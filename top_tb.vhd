 --library declaration
library IEEE;

use IEEE.std_logic_1164.all;            -- basic IEEE library
use IEEE.numeric_std.all;               -- IEEE library for the unsigned type and various arithmetic operators


-- Top level entity - defines the IO
entity TOP_tb is
	--test bench has no IO
end TOP_tb;

architecture BEHAVIORAL of top_tb is

	constant C_PERIOD	:	Time		:=	39.72194638 ns;				-- 25.175MHz
	signal clk_tb		: 	STD_LOGIC	:=	'0'; 						-- clock signal, default 0
	signal TX_tb		:	STD_LOGIC	:=	'0';
	signal RX_tb		:	STD_LOGIC	:=	'0';


	component top is
		port(
				pixel_clk	:	in	STD_LOGIC;
			  	RX : in  STD_LOGIC;
           		TX : out  STD_LOGIC
		);
	end component top;
 
	begin
		
		CLK: 	clk_tb 	<= not clk_tb after C_PERIOD/2;					-- single line process to generate the clock

		TOP_p: top
			PORT MAP (
			--inputs
				pixel_clk => clk_tb,
				TX => TX_tb,
				RX => RX_tb
			);

end BEHAVIORAL;