LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.NUMERIC_STD.ALL;

entity atm is  --main entity of atm controller

    port (clk: in std_logic;
        card, pin, withdraw, deposit, sav, cheq: in std_logic; --connditional input signals for changing states
		  amt20, amt40, amt60, amt80, amt100: in std_logic; --amount inputs for withdraw 
		  n10, n20, n50, n100: in std_logic; --currency selection for withdrawal
		  number10, number20, number50, number100: in std_logic_vector(3 downto 0); --inputs of notes for deposit
		  total_notes: out std_logic_vector(3 downto 0); --output of total number of notes for deposit and withdraw
		  no_of_10, no_of_20, no_of_50, no_of_100: out std_logic_vector(3 downto 0); --number of notes for withdraw
		  ack, deposit_complete: out std_logic; --acknowledgement signals for deposit and withdraw
		  dollar10, dollar20, dollar30, dollar40, dollar50, dollar60, dollar70, dollar80, dollar90, dollar100: out std_logic); --main outputs
end atm;

architecture arc of atm is

--state declaration
type state_type is (idle, ver_card, ver_pin, wit, dep, wit_sa, dep_sa, wit_ca, dep_ca, wit_amt, dep_amt, wit_done, dep_done, abort);
--state changing signals
signal ps,ns : state_type := idle ;
--process that changes states for every clock
begin 
process ( clk )
begin
	 if(clk'event and clk='1') then
			ps <= ns ;
	end if ;
end process ;
--process for states
process(pin, card, withdraw, sav) 
	begin
	
	case (ps) is 
	--idle state 
	when idle =>
		if(card = '1') then
		ns <= ver_card;
		else 
		ns <= abort;end if;
	--verify card state
	when ver_card =>
		if(pin = '1' ) then
		ns <= ver_pin;
		else 
		ns <= abort;end if;
	--verify pin state
	when ver_pin => --condition for selecting withdraw or deposit
		if(withdraw = '1' and (number10 = "0000" and number20 = "0000" and number50 = "0000" and number100 = "0000")) then
		ns <= wit;
		elsif(deposit = '1') then 
		ns <= dep;
		else
		ns <= abort;end if;
	--condition for selecting account
	when wit =>
		if(sav = '1') then
		ns <= wit_sa;
		else
		ns <= wit_ca;end if;
		--withdrwal states
	when wit_sa =>
		ns <= wit_amt;

	when wit_ca =>
		ns <= wit_amt;

	when wit_amt =>
		ns <= wit_done;

	when wit_done =>
		ns <= abort;


	--deposit states
	when dep =>
		if(sav = '1') then
		ns <= dep_sa;
		else
		ns <= dep_ca;end if;

	when dep_sa =>
		ns <= dep_amt;

	when dep_ca =>
		ns <= dep_amt;
		
	when dep_amt =>
		ns <= dep_done;
		
	when dep_done =>
		ns <= abort;


	--abort is last state 
	when abort =>
		ns <= abort;
		

end case;
end process;
--acknowlegde will be 1 when deposit or withdraw is complete
ack <= '1' when ( ps = wit_done or ps = dep_done ) else '0';
deposit_complete <= '1' when (ps = dep_done) else '0';
											
--logic for how many no. of note 10 is required for every withdrawal
no_of_10 <= "0001" when ( ps = wit_done and ( (amt60 = '1'and (n10 = '1' and n20 = '0' and n50 = '1' and n100 = '0'))
															or (amt80 = '1'and (n10 = '1' and n20 = '1' and n50 = '1' and n100 = '0'))
															or (amt100 = '1'and (n10 = '1' and n20 = '1' and n50 = '1' and n100 = '0'))))

			else "0010" when ( ps = wit_done and ((amt20 = '1' and (n10 = '1' and n20 = '0' and n50 = '0' and n100 = '0'))
															or (amt40 = '1' and (n10 = '1' and n20 = '1' and n50 = '0' and n100 = '0'))
															or (amt60 = '1'and (n10 = '1' and n20 = '1' and n50 = '0' and n100 = '0'))))
															
			else "0011" when ( ps = wit_done and ( (amt80 = '1'and (n10 = '1' and n20 = '0' and n50 = '1' and n100 = '0'))))
															
			else "0100" when ( ps = wit_done and ( (amt40 = '1' and (n10 = '1' and n20 = '0' and n50 = '0' and n100 = '0'))
															or (amt80 = '1'and (n10 = '1' and n20 = '1' and n50 = '0' and n100 = '0'))
															or (amt100 = '1'and (n10 = '1' and n20 = '1' and n50 = '0' and n100 = '0'))))
															
			else "0101" when ( ps = wit_done and ( (amt100 = '1'and (n10 = '1' and n20 = '0' and n50 = '1' and n100 = '0'))))
															
			else "0110" when ( ps = wit_done and ( (amt60 = '1'and (n10 = '1' and n20 = '0' and n50 = '0' and n100 = '0'))))
			
			else "1000" when ( ps = wit_done and ( (amt80 = '1'and (n10 = '1' and n20 = '0' and n50 = '0' and n100 = '0'))))

			else "1010" when ( ps = wit_done and ( (amt100 = '1'and (n10 = '1' and n20 = '0' and n50 = '0' and n100 = '0'))))

			else "0000"; 
--no of 20 notes for withdrawal
no_of_20 <= "0001" when ( ps = wit_done and ( (amt20 = '1' and (n10 = '0' and n20 = '1' and n50 = '0' and n100 = '0')) 
															or (amt40 = '1' and (n10 = '1' and n20 = '1' and n50 = '0' and n100 = '0'))
															or (amt80 = '1'and (n10 = '1' and n20 = '1' and n50 = '1' and n100 = '0'))))

			else "0010" when ( ps = wit_done and ( (amt40 = '1' and (n10 = '0' and n20 = '1' and n50 = '0' and n100 = '0'))
															or (amt60 = '1'and (n10 = '1' and n20 = '1' and n50 = '0' and n100 = '0'))
															or (amt80 = '1'and (n10 = '1' and n20 = '1' and n50 = '0' and n100 = '0'))
															or (amt100 = '1'and (n10 = '1' and n20 = '1' and n50 = '1' and n100 = '0'))))
															
			else "0011" when ( ps = wit_done and ( (amt60 = '1'and (n10 = '0' and n20 = '1' and n50 = '0' and n100 = '0'))
															or (amt100 = '1'and (n10 = '1' and n20 = '1' and n50 = '0' and n100 = '0'))))
															
			else "0100" when ( ps = wit_done and ( (amt80 = '1'and (n10 = '0' and n20 = '1' and n50 = '0' and n100 = '0'))))
															
			else "0101" when ( ps = wit_done and ( (amt100 = '1'and (n10 = '0' and n20 = '1' and n50 = '0' and n100 = '0'))))
			
			else "0000"; 
--no of 50s for withdrawal
no_of_50 <= "0001" when ( ps = wit_done and ( (amt60 = '1'and (n10 = '1' and n20 = '0' and n50 = '1' and n100 = '0'))
															or (amt80 = '1'and ((n10 = '1' and n20 = '1' and n50 = '1' and n100 = '0') or (n10 = '1' and n20 = '0' and n50 = '1' and n100 = '0')))
															or (amt100 = '1'and ((n10 = '1' and n20 = '0' and n50 = '1' and n100 = '0') or (n10 = '1' and n20 = '1' and n50 = '1' and n100 = '0')))))

			else "0010" when ( ps = wit_done and ( (amt100 = '1'and (n10 = '0' and n20 = '0' and n50 = '1' and n100 = '0'))))
			
			else "0000"; 
--no of 100 
no_of_100 <= "0001" when ( ps = wit_done and ( (amt100 = '1'and (n10 = '0' and n20 = '0' and n50 = '0' and n100 = '0'))))

			else "0000"; 
--total number of notes in withdraw and deposit
total_notes <= "0001" when ( ps = wit_done and ( (amt20 = '1'and (n10 = '0' and n20 = '1' and n50 = '0' and n100 = '0'))
															or (amt100 = '1'and (n10 = '0' and n20 = '0' and n50 = '0' and n100 = '1'))))
									or
									( ps = dep_done and ((number10 = "0001" and number20 = "0000" and number50 = "0000" and number100 = "0000")
															or (number10 = "0000" and number20 = "0001" and number50 = "0000" and number100 = "0000")
															or (number10 = "0000" and number20 = "0000" and number50 = "0001" and number100 = "0000")
															or (number10 = "0000" and number20 = "0000" and number50 = "0000" and number100 = "0001")))

			else "0010" when ( ps = wit_done and ((amt20 = '1' and (n10 = '1' and n20 = '0' and n50 = '0' and n100 = '0'))
															or (amt40 = '1' and (n10 = '0' and n20 = '1' and n50 = '0' and n100 = '0'))
															or (amt60 = '1'and (n10 = '1' and n20 = '0' and n50 = '1' and n100 = '0'))
															or (amt100 = '1'and (n10 = '0' and n20 = '0' and n50 = '1' and n100 = '0'))))
									or
									( ps = dep_done and ((number10 = "0010" and number20 = "0000" and number50 = "0000" and number100 = "0000")
															or (number10 = "0001" and number20 = "0001" and number50 = "0000" and number100 = "0000")
															or (number10 = "0000" and number20 = "0010" and number50 = "0000" and number100 = "0000")
															or (number10 = "0001" and number20 = "0000" and number50 = "0001" and number100 = "0000")
															or (number10 = "0000" and number20 = "0001" and number50 = "0001" and number100 = "0000")
															or (number10 = "0000" and number20 = "0000" and number50 = "0010" and number100 = "0000")))
									
			else "0011" when ( ps = wit_done and ( (amt40 = '1'and (n10 = '1' and n20 = '1' and n50 = '0' and n100 = '0'))
															or (amt60 = '1'and (n10 = '0' and n20 = '1' and n50 = '0' and n100 = '0'))
															or (amt80 = '1'and (n10 = '1' and n20 = '1' and n50 = '1' and n100 = '0'))))
									or
									( ps = dep_done and ((number10 = "0011" and number20 = "0000" and number50 = "0000" and number100 = "0000")
															or (number10 = "0010" and number20 = "0001" and number50 = "0000" and number100 = "0000")
															or (number10 = "0001" and number20 = "0010" and number50 = "0000" and number100 = "0000")
															or (number10 = "0000" and number20 = "0011" and number50 = "0000" and number100 = "0000")
															or (number10 = "0010" and number20 = "0000" and number50 = "0001" and number100 = "0000")
															or (number10 = "0001" and number20 = "0001" and number50 = "0001" and number100 = "0000")
															or (number10 = "0000" and number20 = "0010" and number50 = "0001" and number100 = "0000")))
															
			else "0100" when ( ps = wit_done and ( (amt40 = '1' and (n10 = '1' and n20 = '0' and n50 = '0' and n100 = '0'))
															or (amt60 = '1'and (n10 = '1' and n20 = '1' and n50 = '0' and n100 = '0'))
															or (amt80 = '1'and ((n10 = '0' and n20 = '1' and n50 = '0' and n100 = '0') or (n10 = '1' and n20 = '0' and n50 = '1' and n100 = '0')))
															or (amt100 = '1'and (n10 = '1' and n20 = '1' and n50 = '1' and n100 = '0'))))
									or
									( ps = dep_done and ((number10 = "0100" and number20 = "0000" and number50 = "0000" and number100 = "0000")
															or (number10 = "0011" and number20 = "0001" and number50 = "0000" and number100 = "0000")
															or (number10 = "0010" and number20 = "0010" and number50 = "0000" and number100 = "0000")
															or (number10 = "0001" and number20 = "0011" and number50 = "0000" and number100 = "0000")
															or (number10 = "0000" and number20 = "0100" and number50 = "0000" and number100 = "0000")
															or (number10 = "0011" and number20 = "0000" and number50 = "0001" and number100 = "0000")
															or (number10 = "0010" and number20 = "0001" and number50 = "0001" and number100 = "0000")
															or (number10 = "0001" and number20 = "0010" and number50 = "0001" and number100 = "0000")))
									
			else "0101" when ( ps = wit_done and ( (amt100 = '1'and (n10 = '0' and n20 = '1' and n50 = '0' and n100 = '0'))))
									or
									( ps = dep_done and ((number10 = "0101" and number20 = "0000" and number50 = "0000" and number100 = "0000")
															or (number10 = "0100" and number20 = "0001" and number50 = "0000" and number100 = "0000")
															or (number10 = "0011" and number20 = "0010" and number50 = "0000" and number100 = "0000")
															or (number10 = "0010" and number20 = "0011" and number50 = "0000" and number100 = "0000")
															or (number10 = "0001" and number20 = "0100" and number50 = "0000" and number100 = "0000")
															or (number10 = "0100" and number20 = "0000" and number50 = "0001" and number100 = "0000")
															or (number10 = "0000" and number20 = "0101" and number50 = "0000" and number100 = "0000")
															or (number10 = "0011" and number20 = "0001" and number50 = "0001" and number100 = "0000")))
									
			else "0110" when ( ps = wit_done and ( (amt60 = '1' and (n10 = '1' and n20 = '0' and n50 = '0' and n100 = '0'))
															or (amt80 = '1'and (n10 = '1' and n20 = '1' and n50 = '0' and n100 = '0'))
															or (amt100 = '1'and (n10 = '1' and n20 = '0' and n50 = '1' and n100 = '0'))))
									or
									( ps = dep_done and ((number10 = "0110" and number20 = "0000" and number50 = "0000" and number100 = "0000")
															or (number10 = "0101" and number20 = "0001" and number50 = "0000" and number100 = "0000")
															or (number10 = "0100" and number20 = "0010" and number50 = "0000" and number100 = "0000")
															or (number10 = "0011" and number20 = "0011" and number50 = "0000" and number100 = "0000")
															or (number10 = "0010" and number20 = "0100" and number50 = "0000" and number100 = "0000")
															or (number10 = "0101" and number20 = "0000" and number50 = "0001" and number100 = "0000")))
									
			else "0111" when ( ps = wit_done and ( (amt100 = '1'and (n10 = '1' and n20 = '1' and n50 = '0' and n100 = '0'))))
									or
									( ps = dep_done and ((number10 = "0111" and number20 = "0000" and number50 = "0000" and number100 = "0000")
															or (number10 = "0110" and number20 = "0001" and number50 = "0000" and number100 = "0000")
															or (number10 = "0101" and number20 = "0010" and number50 = "0000" and number100 = "0000")
															or (number10 = "0100" and number20 = "0011" and number50 = "0000" and number100 = "0000")))
									
			else "1000" when ( ps = wit_done and ( (amt80 = '1'and (n10 = '1' and n20 = '0' and n50 = '0' and n100 = '0'))))
									or
									( ps = dep_done and ((number10 = "1000" and number20 = "0000" and number50 = "0000" and number100 = "0000")
															or (number10 = "0111" and number20 = "0001" and number50 = "0000" and number100 = "0000")
															or (number10 = "0110" and number20 = "0010" and number50 = "0000" and number100 = "0000")))
									
			else "1001" when ( ps = dep_done and ((number10 = "1001" and number20 = "0000" and number50 = "0000" and number100 = "0000")
															or (number10 = "1000" and number20 = "0001" and number50 = "0000" and number100 = "0000")))
									
			else "1010" when ( ps = wit_done and ( (amt100 = '1'and (n10 = '1' and n20 = '0' and n50 = '0' and n100 = '0'))))
									or
									( ps = dep_done and (number10 = "1010" and number20 = "0000" and number50 = "0000" and number100 = "0000"))

			else "0000"; 

--total money withdrawed or deposited in one transaction
dollar10 <= '1' when ( ps = dep_done and (number10 = "0001" and number20 = "0000" and number50 = "0000" and number100 = "0000")) 
											else '0'; 

dollar20 <= '1' when ( ps = dep_done and ((number10 = "0010" and number20 = "0000" and number50 = "0000" and number100 = "0000") 
											 or (number10 = "0000" and number20 = "0001" and number50 = "0000" and number100 = "0000")))
					or ( ps = wit_done and amt20 = '1')
											else '0';
											
dollar30 <= '1' when ( ps = dep_done and ((number10 = "0011" and number20 = "0000" and number50 = "0000" and number100 = "0000") 
											 or (number10 = "0001" and number20 = "0001" and number50 = "0000" and number100 = "0000"))) else '0';
											
dollar40 <= '1' when ( ps = dep_done and ((number10 = "0100" and number20 = "0000" and number50 = "0000" and number100 = "0000")
											 or (number10 = "0010" and number20 = "0001" and number50 = "0000" and number100 = "0000") 
											 or (number10 = "0000" and number20 = "0010" and number50 = "0000" and number100 = "0000"))) 
					or( ps = wit_done and amt40 = '1')
											else '0';
											
dollar50 <= '1' when ( ps = dep_done and ((number10 = "0101" and number20 = "0000" and number50 = "0000" and number100 = "0000") 
											 or (number10 = "0011" and number20 = "0001" and number50 = "0000" and number100 = "0000") 
											 or (number10 = "0001" and number20 = "0010" and number50 = "0000" and number100 = "0000") 
											 or (number10 = "0000" and number20 = "0000" and number50 = "0001" and number100 = "0000"))) 
											else '0';
											
dollar60 <= '1' when ( ps = dep_done and ((number10 = "0110" and number20 = "0000" and number50 = "0000" and number100 = "0000") 
											 or (number10 = "0100" and number20 = "0001" and number50 = "0000" and number100 = "0000") 
											 or (number10 = "0010" and number20 = "0010" and number50 = "0000" and number100 = "0000") 
											 or (number10 = "0000" and number20 = "0011" and number50 = "0000" and number100 = "0000") 
											 or (number10 = "0001" and number20 = "0000" and number50 = "0001" and number100 = "0000"))) 
					or( ps = wit_done and amt60 = '1')
											else '0';
											
dollar70 <= '1' when ( ps = dep_done and ((number10 = "0111" and number20 = "0000" and number50 = "0000" and number100 = "0000") 
											 or (number10 = "0101" and number20 = "0001" and number50 = "0000" and number100 = "0000") 
											 or (number10 = "0011" and number20 = "0010" and number50 = "0000" and number100 = "0000") 
											 or (number10 = "0001" and number20 = "0011" and number50 = "0000" and number100 = "0000") 
											 or (number10 = "0000" and number20 = "0001" and number50 = "0001" and number100 = "0000") 
											 or (number10 = "0010" and number20 = "0000" and number50 = "0001" and number100 = "0000"))) 
											else '0';
											
dollar80 <= '1' when ( ps = dep_done and ((number10 = "1000" and number20 = "0000" and number50 = "0000" and number100 = "0000") 
											 or (number10 = "0110" and number20 = "0001" and number50 = "0000" and number100 = "0000") 
											 or (number10 = "1000" and number20 = "0010" and number50 = "0000" and number100 = "0000") 
											 or (number10 = "0010" and number20 = "0011" and number50 = "0000" and number100 = "0000") 
											 or (number10 = "0000" and number20 = "0100" and number50 = "0000" and number100 = "0000") 
											 or (number10 = "0001" and number20 = "0001" and number50 = "0001" and number100 = "0000") 
											 or (number10 = "0011" and number20 = "0000" and number50 = "0001" and number100 = "0000"))) 
					or( ps = wit_done and amt80 = '1')
											else '0';
											
dollar90 <= '1' when ( ps = dep_done and ((number10 = "1001" and number20 = "0000" and number50 = "0000" and number100 = "0000") 
											 or (number10 = "0111" and number20 = "0001" and number50 = "0000" and number100 = "0000") 
											 or (number10 = "0101" and number20 = "0010" and number50 = "0000" and number100 = "0000") 
											 or (number10 = "0011" and number20 = "0011" and number50 = "0000" and number100 = "0000") 
											 or (number10 = "0001" and number20 = "0100" and number50 = "0000" and number100 = "0000") 
											 or (number10 = "0000" and number20 = "0010" and number50 = "0001" and number100 = "0000") 
											 or (number10 = "0010" and number20 = "0001" and number50 = "0001" and number100 = "0000") 
											 or (number10 = "0100" and number20 = "0000" and number50 = "0001" and number100 = "0000"))) 
											else '0';
											
dollar100 <= '1' when ( ps = dep_done and ((number10 = "1010" and number20 = "0000" and number50 = "0000" and number100 = "0000") 
											 or (number10 = "1000" and number20 = "0001" and number50 = "0000" and number100 = "0000") 
											 or (number10 = "0110" and number20 = "0010" and number50 = "0000" and number100 = "0000") 
											 or (number10 = "0100" and number20 = "0011" and number50 = "0000" and number100 = "0000") 
											 or (number10 = "0010" and number20 = "0100" and number50 = "0000" and number100 = "0000") 
											 or (number10 = "0000" and number20 = "0101" and number50 = "0000" and number100 = "0000") 
											 or (number10 = "0001" and number20 = "0010" and number50 = "0001" and number100 = "0000") 
											 or (number10 = "0011" and number20 = "0001" and number50 = "0001" and number100 = "0000") 
											 or (number10 = "0101" and number20 = "0000" and number50 = "0001" and number100 = "0000") 
											 or (number10 = "0000" and number20 = "0000" and number50 = "0010" and number100 = "0000") 
											 or (number10 = "0000" and number20 = "0000" and number50 = "0000" and number100 = "0001"))) 
					or( ps = wit_done and amt100 = '1')
											else '0';

end arc; 