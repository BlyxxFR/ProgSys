----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    11:38:30 05/30/2018 
-- Design Name: 
-- Module Name:    Processeur - Behavioral 
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

entity Processeur is
	PORT (
		CLK : in STD_LOGIC
	);
end Processeur;

architecture Structural of Processeur is
	
	-- Composants
	COMPONENT Instructions is
		PORT (
			INSTRUCTION_POINTER : out STD_LOGIC_VECTOR(7 downto 0);
			CLK : in STD_LOGIC;
			ENABLE : in STD_LOGIC;
		);
	END COMPONENT;

	COMPONENT BancRegistres
    PORT(
         CLK : IN  std_logic;
         RST : IN  std_logic;
         ADDR_A : IN  std_logic_vector(3 downto 0);
         ADDR_B : IN  std_logic_vector(3 downto 0);
         ADDR_W : IN  std_logic_vector(3 downto 0);
         W : IN  std_logic;
         DATA : IN  std_logic_vector(7 downto 0);
         QA : OUT  std_logic_vector(7 downto 0);
         QB : OUT  std_logic_vector(7 downto 0)
        );
    END COMPONENT;
	 
	 COMPONENT Alu
    PORT(
         A : IN  std_logic_vector(15 downto 0);
         B : IN  std_logic_vector(15 downto 0);
         S : OUT  std_logic_vector(15 downto 0);
         OP : IN  std_logic_vector(1 downto 0);
         FZ : OUT  std_logic;
         FC : OUT  std_logic
        );
    END COMPONENT;
	 
	 COMPONENT Memoire
	 PORT ( 	
				CLK : in STD_LOGIC;
				RST : in STD_LOGIC;
				ADDR : in STD_LOGIC_VECTOR (7 downto 0);
				W : in STD_LOGIC;
				VALUE_IN : in STD_LOGIC_VECTOR (7 downto 0);
				VALUE_OUT : out STD_LOGIC_VECTOR (7 downto 0) ;
				STACK : in STD_LOGIC
		  );
	 END COMPONENT; 

	 COMPONENT Pipeline
    PORT ( 	CLK : in  STD_LOGIC;
				OP_In: in STD_LOGIC_VECTOR (3 downto 0);
				Reg1_In: in STD_LOGIC_VECTOR (15 downto 0);
				Reg2_In: in STD_LOGIC_VECTOR (15 downto 0);
				FZ_In: in STD_LOGIC;
				FC_In: in STD_LOGIC;
				OP_Out: out STD_LOGIC_VECTOR (3 downto 0);
				Reg1_Out: out STD_LOGIC_VECTOR (15 downto 0);
				Reg2_Out: out STD_LOGIC_VECTOR (15 downto 0);
				FZ_Out: out STD_LOGIC;
				FC_Out: out STD_LOGIC);
	 end COMPONENT; 
			
	 -- Signaux
	 signal enable : STD_LOGIC := '1';
	 
	 signal instruction_pointer_out : STD_LOGIC_VECTOR(7 downto 0);
	 
	 signal banc_registre_qa : STD_LOGIC_VECTOR(7 downto 0);
	 signal banc_registre_qb : STD_LOGIC_VECTOR(7 downto 0);
	 
begin
	-- Instructions
	comp_pipeline_instructions : Pipeline port map
	(
		CLK => CLK;
		OP_In: in STD_LOGIC_VECTOR (3 downto 0);
		Reg1_In: in STD_LOGIC_VECTOR (15 downto 0);
		Reg2_In: in STD_LOGIC_VECTOR (15 downto 0);
		OP_Out => Pipeline.OP_Out;
		Reg1_Out => Pipeline.Reg1_Out;
		Reg2_Out => Pipeline.Reg2_Out;
	);
	
	comp_instructions port map
	(
		INSTRUCTION_POINTER : instruction_pointer_out;
		CLK => CLK;
		ENABLE => enable;
	);
	
	-- Banc de Registres
	comp_pipeline_banc_registres : Pipeline port map
	(
		CLK => CLK;
		OP_In: in STD_LOGIC_VECTOR (3 downto 0);
		Reg1_In: in STD_LOGIC_VECTOR (15 downto 0);
		Reg2_In: in STD_LOGIC_VECTOR (15 downto 0);
		OP_Out => Pipeline.OP_Out;
		Reg1_Out => Pipeline.Reg1_Out;
		Reg2_Out => Pipeline.Reg2_Out;
	);
	
	comp_banc_registres : BancRegistres port map
	(
			CLK => CLK;
         RST => RST;
         ADDR_A : IN  std_logic_vector(3 downto 0);
         ADDR_B : IN  std_logic_vector(3 downto 0);
         ADDR_W : IN  std_logic_vector(3 downto 0);
         W : IN  std_logic;
         DATA : IN  std_logic_vector(7 downto 0);
         QA => banc_registre_qa;
         QB => banc_registre_qb
        );
	);
	
	-- Alu
	comp_pipeline_alu : Pipeline port map
	(
		CLK => CLK;
		OP_In: in STD_LOGIC_VECTOR (3 downto 0);
		Reg1_In: in STD_LOGIC_VECTOR (15 downto 0);
		Reg2_In: in STD_LOGIC_VECTOR (15 downto 0);
		FZ_In: in STD_LOGIC;
		FC_In: in STD_LOGIC;
		OP_Out => Pipeline.OP_Out;
		Reg1_Out => Pipeline.Reg1_Out;
		Reg2_Out => Pipeline.Reg2_Out;
		FZ_Out => Pipeline.FZ_Out;
		FC_Out => Pipeline.FC_Out
	);

end Structural;

