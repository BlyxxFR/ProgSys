----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    13:31:35 06/04/2018 
-- Design Name: 
-- Module Name:    MemoireInstructions - Behavioral 
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

entity MemoireInstructions is
	Port ( 	
				IP : in STD_LOGIC_VECTOR;
				INSTRUCTION : out STD_LOGIC_VECTOR(31 downto 0)
			);
end MemoireInstructions;

architecture Behavioral of MemoireInstructions is
	type MEM_INSTRUCTIONS is array(31 downto 0) of STD_LOGIC_VECTOR(31 downto 0);
	signal TAB_INSTRUCTIONS : MEM_INSTRUCTIONS := (0 => x"06013903",
																  --1 => x"08000101",
																  1 => x"07000001",
																  4 => x"08000101",
																  others => x"00000000");
begin

	INSTRUCTION <= TAB_INSTRUCTIONS(CONV_INTEGER(IP));
	
end Behavioral;

