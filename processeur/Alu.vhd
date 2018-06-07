----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    10:52:34 05/14/2018 
-- Design Name: 
-- Module Name:    Alu - Behavioral 
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
use IEEE.STD_LOGIC_UNSIGNED.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity Alu is
    Port ( 	A : in STD_LOGIC_VECTOR (15 downto 0);
				B : in STD_LOGIC_VECTOR (15 downto 0);
				S : out STD_LOGIC_VECTOR (15 downto 0);
				OP: in STD_LOGIC_VECTOR (7 downto 0);
				FZ : out STD_LOGIC;
				FC : out STD_LOGIC);
	
end Alu;

architecture Behavioral of Alu is
	SIGNAL Radd : STD_LOGIC_VECTOR(16 DOWNTO 0);
	SIGNAL Rmul : STD_LOGIC_VECTOR(31 DOWNTO 0);
	SIGNAL R : STD_LOGIC_VECTOR(15 DOWNTO 0);
	
begin
	Rmul <= A * B when OP = x"02";
	Radd <= ('0' & A) + ('0' & B) when OP = x"01";
	
	R <= Radd(15 downto 0) when OP = x"01" 
		else A - B when OP = x"03" 
		else Rmul(15 downto 0) when OP = x"02"
		else (others => 'Z');
		
	FZ <= '1' when R = x"0000" else '0';
	FC <= Radd (16);
	S <= R;
end Behavioral;

