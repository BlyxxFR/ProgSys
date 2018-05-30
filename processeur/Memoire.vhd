----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    09:48:30 05/29/2018 
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
				CLK : in STD_LOGIC;
				RST : in STD_LOGIC;
				ADDR : in STD_LOGIC_VECTOR (7 downto 0);
				W : in STD_LOGIC;
				VALUE_IN : in STD_LOGIC_VECTOR (7 downto 0);
				VALUE_OUT : out STD_LOGIC_VECTOR (7 downto 0) ;
				STACK : in STD_LOGIC
		  );
end Memoire;

architecture Behavioral of Memoire is
	type MEM_STRUCT is array(1023 downto 0) of STD_LOGIC_VECTOR(7 downto 0);
	signal MEM_TAB : MEM_STRUCT := (others => x"00");
	
	type STACK_STRUCT is array(1023 downto 0) of STD_LOGIC_VECTOR(7 downto 0);
	signal STACK_TAB : STACK_STRUCT := (others => x"00");
	signal STACK_POINTER : STD_LOGIC_VECTOR(9 downto 0) := x"00000";
begin	
	
	process
	begin
		-- conv_integer -> convertir STD_LOGIC_VECTOR en Integer
		-- Ecriture (synchrone)
		wait until CLK'event and CLK = '1';
		if RST = '1' then
			MEM_TAB <= (others => x"00");
		else
			if W = '1' then
				if STACK = '1' then
					STACK_TAB(CONV_INTEGER(STACK_POINTER)) <= VALUE_IN;
					STACK_POINTER <= STACK_POINTER + CONV_STD_LOGIC_VECTOR(1,8);
				else
					MEM_TAB(CONV_INTEGER(ADDR)) <= VALUE_IN;
				end if;	
			end if;
		end if;			
	end process;
	
	-- Lecture (asynchrone)
	STACK_POINTER <= STACK_POINTER - CONV_STD_LOGIC_VECTOR(1,8) when W = '0' and STACK = '1';
	VALUE_OUT <= MEM_TAB(CONV_INTEGER(ADDR)) when W = '0' and STACK = '0' 
					else VALUE_IN when W = '1' and STACK = '0';
			
end Behavioral;

