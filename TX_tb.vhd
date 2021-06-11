library IEEE;
use IEEE.std_logic_1164.all;            -- basic IEEE library
use IEEE.std_logic_unsigned.all;		-- required for std logic vecotrs
use IEEE.numeric_std.all;               -- IEEE library for the unsigned type and various arithmetic operators

entity TX_tb is

	-- no io in a tb

end TX_tb;

architecture behave of TX_tb is

	component TX is
	PORT(
			i_clk		:	in	STD_LOGIC;
			i_TX_DV		:	in	std_logic;
			i_data_byte	:	in	STD_LOGIC_VECTOR (7 downto 0);	
			o_TX		:	out	STD_LOGIC
	);
	end component TX;


-- signals go here

constant C_PERIOD		:	Time							:=	39.72194638 ns;				-- 25.175MHz
signal o_TX_tb			:	std_logic						:=	'0';
signal clk_tb			:	std_logic						:=	'0';
signal i_data_byte_tb	:	std_logic_vector(7 downto 0)	:=	(others => '0');
signal i_TX_DV_tb		:	std_logic						:=	'0';

begin
	CLK: 	clk_tb 	<= not clk_tb after C_PERIOD/2;					-- single line process to generate the clock
	
	EN:		i_TX_DV_tb <= not i_TX_DV_tb after (10000*C_PERIOD/2); -- generate the enable signal

	TX_p: TX
	PORT MAP (
	--inputs
		i_clk => clk_tb,
		i_TX_DV => i_TX_DV_tb,
		i_data_byte => "01000001", -- letter a in ascii	
		o_TX => o_TX_tb
	);

end behave;

