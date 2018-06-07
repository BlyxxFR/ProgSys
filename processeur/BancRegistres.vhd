----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    015:48:30 05/215/2018 
-- Design Name: 
-- Module Name:    BancRegistres - Behavioral 
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

entity BancRegistres is
	Port ( 	
				CLK : in STD_LOGIC;
				RST : in STD_LOGIC;
				ADDR_A : in STD_LOGIC_VECTOR (15 downto 0);
				ADDR_B : in STD_LOGIC_VECTOR (15 downto 0);
				ADDR_W : in STD_LOGIC_VECTOR (15 downto 0);
				W : in STD_LOGIC;
				DATA : in STD_LOGIC_VECTOR (15 downto 0);
				QA : out STD_LOGIC_VECTOR (15 downto 0);
				QB : out STD_LOGIC_VECTOR (15 downto 0)
		  );
end BancRegistres;

architecture Behavioral of BancRegistres is
	type MEM_REG is array(15 downto 0) of STD_LOGIC_VECTOR(15 downto 0);
	signal BANC_REGISTRES : MEM_REG := (others => x"0000");
begin	
	
	process
	begin
		-- conv_integer -> convertir STD_LOGIC_VECTOR en Integer
		-- Ecriture (synchrone)
		wait until CLK'event and CLK = '1';
		if RST = '1' then
			BANC_REGISTRES <= (others => x"0000");
		else
			if W = '1' then
				BANC_REGISTRES(CONV_INTEGER(ADDR_W(3 downto 0))) <= DATA;
			end if;
		end if;			
	end process;
	
	-- Lecture (asynchrone)
	QA <= DATA when W = '1' and ADDR_A = ADDR_W else 
			BANC_REGISTRES(CONV_INTEGER(ADDR_A(3 downto 0)));
	QB <= DATA when W = '1' and ADDR_B = ADDR_W else 
			BANC_REGISTRES(CONV_INTEGER(ADDR_B(3 downto 0)));
			
end Behavioral;

