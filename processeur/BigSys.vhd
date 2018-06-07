----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    13:32:18 06/06/2018 
-- Design Name: 
-- Module Name:    BigSys - Behavioral 
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

entity BigSys is
end BigSys;

architecture Behavioral of BigSys is
	COMPONENT Processeur is
		PORT ( 
			CLOCK : out  STD_LOGIC;
			RST : in STD_LOGIC;
			ENABLE : in STD_LOGIC;
			data_a : out STD_LOGIC_VECTOR (15 downto 0);
			data_we : out STD_LOGIC;
			data_do : out STD_LOGIC_VECTOR (15 downto 0);
			data_di : in STD_LOGIC_VECTOR (15 downto 0);
			STACK : out STD_LOGIC	
		);
	END COMPONENT;
	
	COMPONENT Memoire is
		PORT ( 
			CLOCK : in STD_LOGIC;
			RST : in STD_LOGIC;
			data_a : in STD_LOGIC_VECTOR (15 downto 0);
			data_we : in STD_LOGIC;
			data_do : in STD_LOGIC_VECTOR (15 downto 0);
			data_di : out STD_LOGIC_VECTOR (15 downto 0);
			STACK : in STD_LOGIC
		);
	END COMPONENT;
	
	-- Signaux
	 signal enable : STD_LOGIC := '1';
	 signal reset : STD_LOGIC := '0';
	 
	 signal bigsys_data_a : STD_LOGIC_VECTOR (15 downto 0);
	 signal bigsys_data_we : STD_LOGIC;
	 signal bigsys_data_do : STD_LOGIC_VECTOR (15 downto 0);
	 signal bigsys_data_di : STD_LOGIC_VECTOR (15 downto 0);
	 
	 signal stack : STD_LOGIC;
	 
	 signal clk : STD_LOGIC;
begin

	comp_processeur : Processeur port map
	( 
		CLOCK => clk,
		RST => reset,
		ENABLE => enable,
		data_a => bigsys_data_a,
		data_we => bigsys_data_we,
		data_do => bigsys_data_do,
		data_di => bigsys_data_di,
		STACK =>	stack
	);
	
	comp_memoire : Memoire port map
	( 
		CLOCK => clk,
		RST => reset,
		data_a => bigsys_data_a,
		data_we => bigsys_data_we,
		data_do => bigsys_data_do,
		data_di => bigsys_data_di,
		STACK =>	stack
	);

end Behavioral;

