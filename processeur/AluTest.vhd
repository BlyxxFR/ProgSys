--------------------------------------------------------------------------------
-- Company: 
-- Engineer:
--
-- Create Date:   11:46:53 05/14/2018
-- Design Name:   
-- Module Name:   /home/barrech/Documents/ProjSys/ProgSys/processeur/Processeur/AluTest.vhd
-- Project Name:  Processeur
-- Target Device:  
-- Tool versions:  
-- Description:   
-- 
-- VHDL Test Bench Created by ISE for module: Alu
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
 
ENTITY AluTest IS
END AluTest;
 
ARCHITECTURE behavior OF AluTest IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT Alu
    PORT(
         A : IN  std_logic_vector(15 downto 0);
         B : IN  std_logic_vector(15 downto 0);
         S : OUT  std_logic_vector(15 downto 0);
         OP : IN  std_logic_vector(3 downto 0);
         FZ : OUT  std_logic;
         FC : OUT  std_logic
        );
    END COMPONENT;
    

   --Inputs
   signal A : std_logic_vector(15 downto 0) := (others => '0');
   signal B : std_logic_vector(15 downto 0) := (others => '0');
   signal OP : std_logic_vector(3 downto 0) := (others => '0');

 	--Outputs
   signal S : std_logic_vector(15 downto 0);
   signal FZ : std_logic;
   signal FC : std_logic;
   -- No clocks detected in port list. Replace <clock> below with 
   -- appropriate port name 
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: Alu PORT MAP (
          A => A,
          B => B,
          S => S,
          OP => OP,
          FZ => FZ,
          FC => FC
        ); 

   -- Stimulus process
   stim_proc: process
   begin		
      -- insert stimulus here 
		A <= "1000000000000001" after 10 us, "1111111111111111" after 20 us, "0000000000000100" after 30 us,
			  "0000000000011111" after 40 us, "1111110000000001" after 50 us;
		
		B <= "0000000000000001" after 10 us, "1111111111111111" after 20 us, "0000000000000100" after 30 us,
			  "0000000000011111" after 40 us, "1111110000000001" after 50 us;
			  
		OP <= "0811" after 10 us, "0801" after 20 us, "0810" after 30 us, "0801" after 40 us, "0800" after 50 us;	  

      wait;
   end process;

END;
