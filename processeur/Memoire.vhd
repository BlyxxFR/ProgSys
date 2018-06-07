----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    015:48:30 05/215/2018 
-- Design Name: 
-- Module Name:    Memoire - Behavioral 
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
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.std_logic_arith.ALL;
use IEEE.std_logic_unsigned.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity Memoire is
	Port ( 	
				CLOCK : in STD_LOGIC;
				RST : in STD_LOGIC;
				data_a : in STD_LOGIC_VECTOR (15 downto 0);
				data_we : in STD_LOGIC;
				data_do : in STD_LOGIC_VECTOR (15 downto 0);
				data_di : out STD_LOGIC_VECTOR (15 downto 0) ;
				STACK : in STD_LOGIC
		  );
end Memoire;

architecture Behavioral of Memoire is
	type MEM_STRUCT is array(1023 downto 0) of STD_LOGIC_VECTOR(15 downto 0);
	signal MEM_TAB : MEM_STRUCT := (1 => "0000000000001000" , others => "0000000000000000");
	
	type STACK_STRUCT is array(1023 downto 0) of STD_LOGIC_VECTOR(15 downto 0);
	signal STACK_TAB : STACK_STRUCT := (others => "0000000000000000");
	signal STACK_POINTER : STD_LOGIC_VECTOR(15 downto 0) := "0000000000000000";
begin	
	
	process
	begin
		-- conv_integer -> convertir STD_LOGIC_VECTOR en Integer
		-- Ecriture (synchrone)
		wait until CLOCK'event and CLOCK = '1';
		if RST = '1' then
			MEM_TAB <= (others => "0000000000000000");
			STACK_TAB <= (others => "0000000000000000");
		else
			if data_we = '1' then
				if STACK = '1' then
					STACK_TAB(CONV_INTEGER(STACK_POINTER)) <= data_do;
					STACK_POINTER <= STACK_POINTER + CONV_STD_LOGIC_VECTOR(1,8);
				else
					MEM_TAB(CONV_INTEGER(data_a(9 downto 0))) <= data_do;
				end if;
				data_di <= data_do;
			else
				-- Lecture
				if STACK = '1' then
					STACK_POINTER <= STACK_POINTER - CONV_STD_LOGIC_VECTOR(1,8);
					data_di <= STACK_TAB(CONV_INTEGER(data_a(9 downto 0)));
				else
					data_di <= MEM_TAB(CONV_INTEGER(data_a(9 downto 0)));
				end if;	
			end if;
		end if;			
	end process;

			
end Behavioral;

