------------------------------------------------------------------------
---- File Downloaded from http://www.nandland.com
------------------------------------------------------------------------
---- This file contains the UART Transmitter.  This transmitter is able
---- to transmit 8 bits of serial data, one start bit, one stop bit,
---- and no parity bit.  When transmit is complete o_TX_Done will be
---- driven high for one clock cycle.
----
---- Set Generic g_CLKS_PER_BIT as follows:
---- g_CLKS_PER_BIT = (Frequency of i_Clk)/(Frequency of UART)
---- Example: 10 MHz Clock, 115200 baud UART
---- (10000000)/(115200) = 87
----
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
 
entity UART_TX is
  generic (
    g_CLKS_PER_BIT : integer := 115     -- Needs to be set correctly
    );
  port (
    i_clk       : in  std_logic;
    i_TX_DV     : in  std_logic;
    i_data_byte   : in  std_logic_vector(7 downto 0);
    --o_TX_Active : out std_logic;
    o_TX : out std_logic
    --o_TX_Done   : out std_logic
    );
end UART_TX;
 
 
architecture RTL of UART_TX is
 
  type t_SM_Main is (s_Idle, s_TX_Start_Bit, s_TX_Data_Bits,
                     s_TX_Stop_Bit, s_Cleanup);
  signal r_SM_Main : t_SM_Main := s_Idle;
 
  signal r_Clk_Count : integer range 0 to g_CLKS_PER_BIT-1 := 0;
  signal r_Bit_Index : integer range 0 to 7 := 0;  -- 8 Bits Total
  signal r_TX_Data   : std_logic_vector(7 downto 0) := (others => '0');
  signal r_TX_Done   : std_logic := '0';
--signal i_data_byte	: std_logic_vector(7 downto 0)	:= "10000010";
   
begin
 
   
  p_UART_TX : process (i_Clk)
  begin
    if rising_edge(i_Clk) then
         
      case r_SM_Main is
 
        when s_Idle =>
          --o_TX_Active <= '0';
          o_TX <= '1';         -- Drive Line High for Idle
          r_TX_Done   <= '0';
          r_Clk_Count <= 0;
          r_Bit_Index <= 0;
 
          if i_TX_DV = '1' then
            r_TX_Data <= i_data_byte;
            r_SM_Main <= s_TX_Start_Bit;
          else
            r_SM_Main <= s_Idle;
          end if;
 
           
        -- Send out Start Bit. Start bit = 0
        when s_TX_Start_Bit =>
          --o_TX_Active <= '1';
          o_TX <= '0';
 
          -- Wait g_CLKS_PER_BIT-1 clock cycles for start bit to finish
          if r_Clk_Count < g_CLKS_PER_BIT-1 then
            r_Clk_Count <= r_Clk_Count + 1;
            r_SM_Main   <= s_TX_Start_Bit;
          else
            r_Clk_Count <= 0;
            r_SM_Main   <= s_TX_Data_Bits;
          end if;
 
           
        -- Wait g_CLKS_PER_BIT-1 clock cycles for data bits to finish          
        when s_TX_Data_Bits =>
          o_TX <= r_TX_Data(r_Bit_Index);
           
          if r_Clk_Count < g_CLKS_PER_BIT-1 then
            r_Clk_Count <= r_Clk_Count + 1;
            r_SM_Main   <= s_TX_Data_Bits;
          else
            r_Clk_Count <= 0;
             
            -- Check if we have sent out all bits
            if r_Bit_Index < 7 then
              r_Bit_Index <= r_Bit_Index + 1;
              r_SM_Main   <= s_TX_Data_Bits;
            else
              r_Bit_Index <= 0;
              r_SM_Main   <= s_TX_Stop_Bit;
            end if;
          end if;
 
 
        -- Send out Stop bit.  Stop bit = 1
        when s_TX_Stop_Bit =>
          o_TX <= '1';
 
          -- Wait g_CLKS_PER_BIT-1 clock cycles for Stop bit to finish
          if r_Clk_Count < g_CLKS_PER_BIT-1 then
            r_Clk_Count <= r_Clk_Count + 1;
            r_SM_Main   <= s_TX_Stop_Bit;
          else
            r_TX_Done   <= '1';
            r_Clk_Count <= 0;
            r_SM_Main   <= s_Cleanup;
          end if;
 
                   
        -- Stay here 1 clock
        when s_Cleanup =>
          --o_TX_Active <= '0';
          r_TX_Done   <= '1';
          r_SM_Main   <= s_Idle;
           
             
        when others =>
          r_SM_Main <= s_Idle;
 
      end case;
    end if;
  end process p_UART_TX;
 
  --o_TX_Done <= r_TX_Done;
   
end RTL;
--
--library IEEE;
--use IEEE.std_logic_1164.all;            -- basic IEEE library
--use IEEE.std_logic_unsigned.all;		-- required for std logic vecotrs
--use IEEE.numeric_std.all;               -- IEEE library for the unsigned type and various arithmetic operators
--
---- io
--entity TX is
--	PORT(
--			i_clk		:	in	STD_LOGIC;
--			i_TX_DV		:	in	STD_LOGIC;
--			i_data_byte	:	in	STD_LOGIC_VECTOR (7 downto 0);	
--			o_TX		:	out	STD_LOGIC
--	);
--end TX;
--
--
---- function
--architecture RTL of TX is
--
----signals defined here
--
--constant c_CLKS_PER_BIT : integer := 218; -- this is the number of clock cycles for 115000 buad rate
--
--type t_SM_Main is (s_Idle, s_Start, s_TX_Data, s_Stop, s_CleanUp); -- define the states used
--
--signal r_SM_Main	: 	t_SM_Main						:=	s_Idle; -- define a register for hold the state
--signal r_TX_data	:	std_logic_vector(7 downto 0)	:=	(others => '0'); -- default set to 0 
--signal r_clk_count	:	integer							:=	0;
--signal r_data_index	:	integer							:=	0;	-- this is used to keep track of data sent
--
--begin
--
--p_UART_TX: process(i_clk)
--begin
--	if rising_edge(i_clk) then
--		case r_SM_Main is
--
--			-- wait whilst in idle
--			when s_Idle =>
--				o_TX <= '1'; -- set the line idle whilst in idle
--				if i_TX_DV = '0' then
--					r_TX_data <= i_data_byte;	-- latch the data
--					r_SM_Main <= s_Start;		-- change to start state
--				end if;
--			
--			-- send start bit
--			when s_Start =>
--				if r_clk_count < c_CLKS_PER_BIT-1 then
--					o_TX <= '0'; -- set the line low,for a start (should be 1.5 clock cycles)
--					r_clk_count <= r_clk_count + 1; -- increase the counter
--					r_SM_Main <= s_Start;
--				else
--					r_clk_count <= 0; -- reset the clock count
--					r_SM_Main <= s_TX_Data;	-- change state
--				end if;
--
--			-- send data 
--			when s_TX_Data =>
--
--				-- send the data, and wait for one baud clock
--				if r_clk_count < c_CLKS_PER_BIT-1 then
--					o_TX <= r_TX_data(r_data_index); -- send the data, serially, using the latched data
--					r_clk_count <= r_clk_count + 1;
--				-- this means we're ready to either change state (go to stop) or send the next bit
--				else
--					r_clk_count <= 0; -- reset the clock count
--					-- check if we're done sending data
--					if r_data_index > 6 then 
--						r_data_index <= 0;		-- reset the index
--						r_SM_Main <= s_Stop;	-- change state to stop
--					else
--						r_data_index <= r_data_index + 1; -- inc the index
--						r_SM_Main <= s_TX_Data;		-- stay in the same state
--					end if;
--				end if;
--
--			-- send the stop signal
--			when s_Stop =>
--				if r_clk_count < c_CLKS_PER_BIT-1 then
--					o_TX <= '1';		-- set the line high for one cycle
--					r_clk_count <= r_clk_count + 1; -- inc the count
--					r_SM_Main <= s_Stop;
--				else
--					--r_clk_count <= 0;
--					r_SM_Main <= s_Idle; -- back to idle state, waiting for i_TX_DV to be set
--				end if;
--			when s_CleanUp =>
--				r_SM_Main <= s_CleanUp;
--			end case;
--	end if;
--				
--end process p_UART_TX;
--
--end architecture;
--
