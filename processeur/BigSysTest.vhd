-- TestBench Template 

  LIBRARY ieee;
  USE ieee.std_logic_1164.ALL;
  USE ieee.numeric_std.ALL;

  ENTITY BigSysTest IS
  END BigSysTest;

  ARCHITECTURE behavior OF BigSysTest IS 

  -- Component Declaration
	COMPONENT BigSys
   END COMPONENT;

BEGIN

  -- Component Instantiation
          uut: BigSys;
			
  --  Test Bench Statements
     tb : PROCESS
     BEGIN
        wait; -- will wait forever
     END PROCESS tb;
  --  End Test Bench 

  END;
