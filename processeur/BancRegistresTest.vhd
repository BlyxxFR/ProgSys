--------------------------------------------------------------------------------
-- Company: 
-- Engineer:
--
-- Create Date:   10:26:37 05/29/2018
-- Design Name:   
-- Module Name:   /home/barrech/Documents/ProjSys/ProgSys/processeur/BancRegistresTest.vhd
-- Project Name:  Processeur
-- Target Device:  
-- Tool versions:  
-- Description:   
-- 
-- VHDL Test Bench Created by ISE for module: BancRegistres
-- 
-- Dependencies:
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
--
-- Notes: 
-- This testbench has been automatically generated using types std_logic and
-- std_logic_vector for the ports of the unit under test.  Xilinx recommends
-- that these types always be used for the top-level I/O of a design in order
-- to guarantee that the testbench will bind correctly to the post-implementation 
-- simulation model.
--------------------------------------------------------------------------------
LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
 
-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--USE ieee.numeric_std.ALL;
 
ENTITY BancRegistresTest IS
END BancRegistresTest;
 
ARCHITECTURE behavior OF BancRegistresTest IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
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
    

   --Inputs
   signal CLK : std_logic := '0';
   signal RST : std_logic := '0';
   signal ADDR_A : std_logic_vector(3 downto 0) := (others => '0');
   signal ADDR_B : std_logic_vector(3 downto 0) := (others => '0');
   signal ADDR_W : std_logic_vector(3 downto 0) := (others => '0');
   signal W : std_logic := '0';
   signal DATA : std_logic_vector(7 downto 0) := (others => '0');

 	--Outputs
   signal QA : std_logic_vector(7 downto 0);
   signal QB : std_logic_vector(7 downto 0);

   -- Clock period definitions
   constant CLK_period : time := 10 us;
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: BancRegistres PORT MAP (
          CLK => CLK,
          RST => RST,
          ADDR_A => ADDR_A,
          ADDR_B => ADDR_B,
          ADDR_W => ADDR_W,
          W => W,
          DATA => DATA,
          QA => QA,
          QB => QB
        );

   -- Clock process definitions
   CLK_process :process
   begin
		CLK <= '0';
		wait for CLK_period/2;
		CLK <= '1';
		wait for CLK_period/2;
   end process;
 

   -- Stimulus process
   stim_proc: process
   begin		
      -- insert stimulus here
		ADDR_A <= x"1" after 10 us, x"2" after 20 us;
		ADDR_B <= x"0" after 10 us, x"0" after 20 us;
		ADDR_W <= x"1" after 10 us, x"0" after 20 us;
		W <= '1' after 10 us,'0' after 20 us;
		DATA <= x"0A" after 10 us, x"0B" after 20 us;
		RST <= '1' after 50 us;
		
		wait;
   end process;
	
	

END;
