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
		CLOCK : out  STD_LOGIC;
		RST : in STD_LOGIC;
		ENABLE : in STD_LOGIC;
		data_a : out STD_LOGIC_VECTOR (15 downto 0);
		data_we : out STD_LOGIC;
		data_do : out STD_LOGIC_VECTOR (15 downto 0);
		data_di : in STD_LOGIC_VECTOR (15 downto 0);
		STACK : out STD_LOGIC	
	);
end Processeur;

architecture Behavior of Processeur is
	
	-- Correspondances des instructions
	-- 0x01 -> ADD
	-- 0x02 -> MUL
	-- 0x03 -> SUB
	
	-- 0x06 -> AFC
	-- 0x07 -> LOAD
	-- 0x08 -> STORE
	
	-- 0x10 -> PUSH
	-- 0x11 -> POP
	
	
	-- Composants
	COMPONENT Decodeur is
		PORT ( 
			CLK : in  STD_LOGIC;
			ENABLE : in STD_LOGIC;
			VALUE_IN : in STD_LOGIC_VECTOR(31 downto 0) := (others => '0');
			OP : out STD_LOGIC_VECTOR(7 downto 0);
			A : out STD_LOGIC_VECTOR(15 downto 0);
			B : out STD_LOGIC_VECTOR(15 downto 0);
			C : out STD_LOGIC_VECTOR(15 downto 0)
		);
	END COMPONENT;
	
	COMPONENT Instructions is
		PORT (
			INSTRUCTION_POINTER : out STD_LOGIC_VECTOR(7 downto 0);
			CLK : in STD_LOGIC;
			ENABLE : in STD_LOGIC
		);
	END COMPONENT;
	
	COMPONENT MemoireInstructions is
		PORT ( 	
			IP : in STD_LOGIC_VECTOR;
			INSTRUCTION : out STD_LOGIC_VECTOR(31 downto 0)
		);
	END COMPONENT;
	
	COMPONENT BancRegistres
    PORT(
         CLK : IN  std_logic;
         RST : IN  std_logic;
         ADDR_A : IN  std_logic_vector(15 downto 0) := (others => '0');
         ADDR_B : IN  std_logic_vector(15 downto 0) := (others => '0');
         ADDR_W : IN  std_logic_vector(15 downto 0) := (others => '0');
         W : IN  std_logic := '0';
         DATA : IN  std_logic_vector(15 downto 0) := (others => '0');
         QA : OUT  std_logic_vector(15 downto 0) := (others => '0');
         QB : OUT  std_logic_vector(15 downto 0) := (others => '0')
        );
    END COMPONENT;
	 
	 COMPONENT Alu
    PORT(
         A : IN  std_logic_vector(15 downto 0);
         B : IN  std_logic_vector(15 downto 0);
         S : OUT  std_logic_vector(15 downto 0);
         OP : IN  std_logic_vector(7 downto 0);
         FZ : OUT  std_logic;
         FC : OUT  std_logic
        );
    END COMPONENT;

	 COMPONENT Pipeline
    PORT ( 	CLK : in  STD_LOGIC;
	 			ENABLE : in STD_LOGIC := '1';
				NOP : in STD_LOGIC := '0';
				OP_In: in STD_LOGIC_VECTOR (7 downto 0);
				A_In: in STD_LOGIC_VECTOR (15 downto 0);
				B_In: in STD_LOGIC_VECTOR (15 downto 0);
				C_In: in STD_LOGIC_VECTOR (15 downto 0) := (others => '0');
				FZ_In: in STD_LOGIC := '0';
				FC_In: in STD_LOGIC := '0';
				OP_Out: out STD_LOGIC_VECTOR (7 downto 0);
				A_Out: out STD_LOGIC_VECTOR (15 downto 0);
				B_Out: out STD_LOGIC_VECTOR (15 downto 0);
				C_Out: out STD_LOGIC_VECTOR (15 downto 0) := (others => '0');
				FZ_Out: out STD_LOGIC;
				FC_Out: out STD_LOGIC
			);
	 END COMPONENT; 
	
		-- IP
	 signal instruction_pointer_out : STD_LOGIC_VECTOR(7 downto 0);
	 
		-- Mémoire Instructions
	 signal instruction_value : STD_LOGIC_VECTOR(31 downto 0);
	 
		-- Decodeur
	 signal decodeur_li_op : STD_LOGIC_VECTOR(7 downto 0);
	 signal decodeur_li_a : STD_LOGIC_VECTOR(15 downto 0);
	 signal decodeur_li_b : STD_LOGIC_VECTOR(15 downto 0);
	 signal decodeur_li_c : STD_LOGIC_VECTOR(15 downto 0);
	 
		-- Bancs de registres
	 signal banc_registres_di_a : STD_LOGIC_VECTOR(15 downto 0);
	 signal banc_registres_di_b : STD_LOGIC_VECTOR(15 downto 0);
	 signal banc_registres_di_op : STD_LOGIC_VECTOR(7 downto 0);
	 
	 signal banc_registres_addr_w : STD_LOGIC_VECTOR(15 downto 0);
	 signal banc_registres_w : STD_LOGIC;
	 signal sortie_mux_banc_registres_data : STD_LOGIC_VECTOR(15 downto 0);
	 
	 signal banc_registres_qa : STD_LOGIC_VECTOR(15 downto 0);
	 signal banc_registres_qb : STD_LOGIC_VECTOR(15 downto 0);
	 
	 signal sortie_multiplexeur_banc_registres : STD_LOGIC_VECTOR(15 downto 0);
		
		-- Alu
	 signal alu_ex_a : STD_LOGIC_VECTOR(15 downto 0);
	 signal alu_ex_b : STD_LOGIC_VECTOR(15 downto 0);
	 signal alu_ex_c : STD_LOGIC_VECTOR(15 downto 0);
	 signal alu_sortie : STD_LOGIC_VECTOR(15 downto 0);
	 signal alu_ex_op : STD_LOGIC_VECTOR(7 downto 0);
	
	 signal sortie_multiplexeur_alu : STD_LOGIC_VECTOR(15 downto 0);
	
		-- Mémoire
	 signal memoire_mem_a : STD_LOGIC_VECTOR(15 downto 0);
	 signal memoire_mem_b : STD_LOGIC_VECTOR(15 downto 0);
	 signal memoire_mem_op : STD_LOGIC_VECTOR(7 downto 0);
	 
	 signal mem_re_mux_b : STD_LOGIC_VECTOR(15 downto 0);
	 
		-- Signaux Alea
	 signal non_aleas : STD_LOGIC;	
	 
		-- LC
	 signal lc_mem_op : STD_LOGIC_VECTOR(7 downto 0);
	 
	 -- CLK 
	 signal clk : STD_LOGIC := '0';
	 constant CLK_period : time := 10 us;	 
begin
	CLK_process :process
   begin
		clk <= '0';
		wait for CLK_period/2;
		clk <= '1';
		wait for CLK_period/2;
   end process;	
	
	CLOCK <= clk;
	
	-- Pipeline
	comp_pipeline_li_di: Pipeline port map
	(
		CLK => clk,
		ENABLE => non_aleas,
		OP_In => decodeur_li_op,
		A_In => decodeur_li_a,
		B_In => decodeur_li_b,
		OP_Out => banc_registres_di_op,
		A_Out => banc_registres_di_a,
		B_Out => banc_registres_di_b
	);
	
	comp_pipeline_di_ex : Pipeline port map
	(
		CLK => clk,
		NOP => not(non_aleas),
		OP_In => banc_registres_di_op,
		A_In => banc_registres_di_a,
		B_In => sortie_multiplexeur_banc_registres,
		C_In => banc_registres_qb,
		OP_Out => alu_ex_op,
		A_Out => alu_ex_a,
		B_Out => alu_ex_b,
		C_Out => alu_ex_c
	);
	
	comp_pipeline_ex_mem : Pipeline port map
	(
		CLK => clk,
		NOP => not(non_aleas),
		OP_In => alu_ex_op,
		A_In => alu_ex_a,
		B_In => sortie_multiplexeur_alu,
		OP_Out => memoire_mem_op,
		A_Out => memoire_mem_a,
		B_Out => memoire_mem_b
	);
	
	comp_pipeline_mem_re : Pipeline port map
	(
		CLK => clk,
		OP_In => memoire_mem_op,
		A_In => memoire_mem_a,
		B_In => memoire_mem_b,
		OP_Out => lc_mem_op,
		A_Out => banc_registres_addr_w,
		B_Out => mem_re_mux_b
	);
	
	-- Instructions
	comp_instructions : Instructions port map
	(
		INSTRUCTION_POINTER => instruction_pointer_out,
		CLK => clk,
		ENABLE => non_aleas
	);

		-- Decodeur
	comp_decodeur : Decodeur port map
	(
		CLK => clk,
		ENABLE => not(non_aleas),
		VALUE_IN => instruction_value,
		OP => decodeur_li_op,
		A => decodeur_li_a,
		B => decodeur_li_b,
		C => decodeur_li_c
	);
	
	-- Memoire instructions
	comp_memoire_instructions : MemoireInstructions port map
	( 	
		IP => instruction_pointer_out,
		INSTRUCTION => instruction_value
	);
	
	-- Banc de Registres
	comp_banc_registres : BancRegistres port map
	(
		CLK => clk,
      RST => RST,
      ADDR_A => banc_registres_di_b,
      ADDR_B => banc_registres_di_a,
      ADDR_W => banc_registres_addr_w,
      W => banc_registres_w,
      DATA => sortie_mux_banc_registres_data,
      QA => banc_registres_qa,
      QB => banc_registres_qb
	);
	
	-- Multiplexeur banc registres
	sortie_multiplexeur_banc_registres <= banc_registres_qa when banc_registres_di_op = x"01" or banc_registres_di_op = x"02" or banc_registres_di_op = x"03" or banc_registres_di_op = x"08" 
													  else banc_registres_di_b;
	
	-- Ecriture banc registres
	banc_registres_w <= '1' when lc_mem_op = x"01" or lc_mem_op = x"02" or lc_mem_op = x"03" or lc_mem_op = x"06" or lc_mem_op = x"07"
							  else '0';
							  
	-- ALU
	com_alu : Alu port map
	(
		A => alu_ex_b,
		B => alu_ex_c,
		S => alu_sortie,
		OP => alu_ex_op
	);
	
	-- Multiplexeur ALU
	sortie_multiplexeur_alu <= alu_sortie when banc_registres_di_op = x"01" or banc_registres_di_op = x"02" or banc_registres_di_op = x"03"
										else alu_ex_b;
										
	-- Memoire
	STACK <= '1' when memoire_mem_op = x"10" or memoire_mem_op = x"11" else '0';
	data_a <= memoire_mem_a when memoire_mem_op = x"08" or memoire_mem_op = x"10" else memoire_mem_b;
	data_we <= '1' when memoire_mem_op = x"10" or memoire_mem_op = x"08" else '0';
	
	sortie_mux_banc_registres_data <= data_di when lc_mem_op = x"07" or lc_mem_op = x"11" else mem_re_mux_b;
	
	data_do <= memoire_mem_b;
	
	non_aleas <= 
	'0' when 
			not(decodeur_li_op = x"06") and 
			not(decodeur_li_op = x"07") and 
			not(decodeur_li_op = x"00") and
			not(decodeur_li_op = "UUUUUUUU") and
			((	
				not(banc_registres_di_op = x"08") and
				not(banc_registres_di_op = x"00") and
				not(banc_registres_di_op = "UUUUUUUU") and
				decodeur_li_b = banc_registres_di_a
			) 
			or
			(
				not(alu_ex_op = x"08") and
				not(alu_ex_op = x"00") and
				not(alu_ex_op = "UUUUUUUU") and
				decodeur_li_b = alu_ex_a
			))
		else '1';
	
end Behavior;

