----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    13:06:03 06/04/2018 
-- Design Name: 
-- Module Name:    Decodeur - Behavioral 
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

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity Decodeur is
    Port ( 
			CLK : in  STD_LOGIC;
			ENABLE : in STD_LOGIC;
			VALUE_IN : in STD_LOGIC_VECTOR(31 downto 0);
			OP : out STD_LOGIC_VECTOR(7 downto 0);
			A : out STD_LOGIC_VECTOR(15 downto 0);
			B : out STD_LOGIC_VECTOR(15 downto 0);
			C : out STD_LOGIC_VECTOR(15 downto 0)
	);
end Decodeur;

architecture Behavioral of Decodeur is

begin
	process
	begin
		wait until CLK'event and CLK = '1';
			OP <= VALUE_IN(31 downto 24);
				
			case VALUE_IN(31 downto 24) is 
				when x"08" => A <= VALUE_IN(23 downto 8); 				-- STORE
				when x"11" => A <= VALUE_IN(23 downto 8); 				-- POP
				when others => A <= x"00" & VALUE_IN(23 downto 16);
			end case;	
			
			case VALUE_IN(31 downto 24) is
				when x"06" => B <= VALUE_IN(15 downto 0) ; 				-- AFC
				when x"07" => B <= VALUE_IN(15 downto 0) ; 				-- LOAD
				when x"08" => B <= x"00" & VALUE_IN(7 downto 0) ; 		-- STORE
				when x"10" => B <= VALUE_IN(15 downto 0) ; 				-- PUSH
				when x"11" => B <= x"00" & VALUE_IN(7 downto 0) ; 		-- POP
				when others => B <= x"00" & VALUE_IN(15 downto 8);
			end case;
			
			C <= x"00" & VALUE_IN(23 downto 16);

	end process;


end Behavioral;

