----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    11:48:37 05/14/2018 
-- Design Name: 
-- Module Name:    Pipeline - Behavioral 
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

entity Pipeline is
    Port ( 	CLK : in  STD_LOGIC;
				ENABLE : in STD_LOGIC;
				NOP : in STD_LOGIC;
				OP_In: in STD_LOGIC_VECTOR (7 downto 0);
				A_In: in STD_LOGIC_VECTOR (15 downto 0);
				B_In: in STD_LOGIC_VECTOR (15 downto 0);
				C_In: in STD_LOGIC_VECTOR (15 downto 0);
				FZ_In: in STD_LOGIC;
				FC_In: in STD_LOGIC;
				OP_Out: out STD_LOGIC_VECTOR (7 downto 0);
				A_Out: out STD_LOGIC_VECTOR (15 downto 0);
				B_Out: out STD_LOGIC_VECTOR (15 downto 0);
				C_Out: out STD_LOGIC_VECTOR (15 downto 0);
				FZ_Out: out STD_LOGIC;
				FC_Out: out STD_LOGIC);
end Pipeline;

architecture Behavioral of Pipeline is
begin
	process
		begin
			wait until CLK'event and CLK = '1'; 
			if NOP = '1' then
				OP_Out <= x"00";
				A_Out <= A_In;
				B_Out <= B_In;
				FZ_Out <= FZ_In;
				FC_Out <= FC_In;
			elsif ENABLE = '1' then				
				OP_Out <= OP_In;
				A_Out <= A_In;
				B_Out <= B_In;
				FZ_Out <= FZ_In;
				FC_Out <= FC_In;
			end if;
	end process;

end Behavioral;

