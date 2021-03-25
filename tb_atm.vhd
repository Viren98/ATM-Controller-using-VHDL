library ieee;
use ieee.std_logic_1164.all;

entity tb_atm is
end tb_atm;

architecture tb of tb_atm is

    component atm
        port (clk,card,pin,withdraw,deposit,sav,cheq : in std_logic;
              amt20,amt40,amt60,amt80,amt100         : in std_logic;
              n10,n20,n50,n100             			  : in std_logic;
              number10,number20,number50,number100   : in std_logic_vector (3 downto 0);
              total_notes      							  : out std_logic_vector (3 downto 0);
              no_of_10,no_of_20,no_of_50,no_of_100   : out std_logic_vector (3 downto 0);
              ack,deposit_complete 						  : out std_logic;
              dollar10         							  : out std_logic;
              dollar20							           : out std_logic;
              dollar30         							  : out std_logic;
              dollar40        							  : out std_logic;
              dollar50        							  : out std_logic;
              dollar60       								  : out std_logic;
              dollar70     							     : out std_logic;
              dollar80         							  : out std_logic;
              dollar90    								     : out std_logic;
              dollar100     							     : out std_logic);
    end component;

			   signal clk,card,pin,withdraw,deposit,sav,cheq : std_logic;
            signal amt20,amt40,amt60,amt80,amt100         : std_logic;
            signal n10,n20,n50,n100             		    : std_logic;
            signal number10,number20,number50,number100   : std_logic_vector (3 downto 0);
            signal total_notes      						    : std_logic_vector (3 downto 0);
            signal no_of_10,no_of_20,no_of_50,no_of_100   : std_logic_vector (3 downto 0);
            signal ack,deposit_complete 					    : std_logic;
            signal dollar10         						    : std_logic;
            signal dollar20							          : std_logic;
            signal dollar30         							 : std_logic;
            signal dollar40        							    : std_logic;
            signal dollar50        							    : std_logic;
            signal dollar60       					  	     	 : std_logic;
            signal dollar70     							       : std_logic;
				signal dollar80         							 : std_logic;
				signal dollar90    								    : std_logic;
				signal dollar100     							    : std_logic;

    constant TbPeriod : time := 20 ns; 
    signal TbClock : std_logic := '0';
    signal TbSimEnded : std_logic := '0';

begin

    dut : atm
    port map (clk              => clk,
              card             => card,
              pin              => pin,
              withdraw         => withdraw,
              deposit          => deposit,
              sav              => sav,
              cheq             => cheq,
              amt20            => amt20,
              amt40            => amt40,
              amt60            => amt60,
              amt80            => amt80,
              amt100           => amt100,
              n10              => n10,
              n20              => n20,
              n50              => n50,
              n100             => n100,
              number10         => number10,
              number20         => number20,
              number50         => number50,
              number100        => number100,
              total_notes      => total_notes,
              no_of_10         => no_of_10,
              no_of_20         => no_of_20,
              no_of_50         => no_of_50,
              no_of_100        => no_of_100,
              ack              => ack,
              deposit_complete => deposit_complete,
              dollar10         => dollar10,
              dollar20         => dollar20,
              dollar30         => dollar30,
              dollar40         => dollar40,
              dollar50         => dollar50,
              dollar60         => dollar60,
              dollar70         => dollar70,
              dollar80         => dollar80,
              dollar90         => dollar90,
              dollar100        => dollar100);

    -- Clock generation
    TbClock <= not TbClock after TbPeriod/2 when TbSimEnded /= '1' else '0';

    clk <= TbClock;

    stimuli : process
    begin
        card <= '0';
        pin <= '0';
        withdraw <= '0';
        deposit <= '0';
        sav <= '0';
        cheq <= '0';
        amt20 <= '0';
        amt40 <= '0';
        amt60 <= '0';
        amt80 <= '0';
        amt100 <= '0';
        n10 <= '0';
        n20 <= '0';
        n50 <= '0';
        n100 <= '0';
        number10 <= (others => '0');
        number20 <= (others => '0');
        number50 <= (others => '0');
        number100 <= (others => '0');
		  
        wait for TbPeriod;
		  
		  
		  
		  card <= '1';
        pin <= '1';
        withdraw <= '1';
        deposit <= '0';
        sav <= '1';
        cheq <= '0';
        amt20 <= '0';
        amt40 <= '0';
        amt60 <= '1';
        amt80 <= '0';
        amt100 <= '0';
        n10 <= '1';
        n20 <= '1';
        n50 <= '0';
        n100 <= '0';
        number10 <= (others => '0');
        number20 <= (others => '0');
        number50 <= (others => '0');
        number100 <= (others => '0');
			
        wait for TbPeriod;
			
			
			
		  card <= '1';
        pin <= '1';
        withdraw <= '0';
        deposit <= '1';
        sav <= '1';
        cheq <= '0';
        amt20 <= '0';
        amt40 <= '0';
        amt60 <= '0';
        amt80 <= '0';
        amt100 <= '0';
        n10 <= '0';
        n20 <= '0';
        n50 <= '0';
        n100 <= '0';
        number10 <= (others => '0');
        number20 <= (others => '0');
        number50 <= "0001";
        number100 <= (others => '0');
		  
        wait for TbPeriod;
		  
		  
		  
		  card <= '0';
        pin <= '1';
        withdraw <= '0';
        deposit <= '1';
        sav <= '1';
        cheq <= '0';
        amt20 <= '0';
        amt40 <= '0';
        amt60 <= '0';
        amt80 <= '0';
        amt100 <= '0';
        n10 <= '0';
        n20 <= '0';
        n50 <= '0';
        n100 <= '0';
        number10 <= (others => '0');
        number20 <= "0110";
        number50 <= (others => '0');
        number100 <= (others => '0');
		  
        wait for TbPeriod;
		  
		  
		  card <= '1';
        pin <= '0';
        withdraw <= '1';
        deposit <= '0';
        sav <= '1';
        cheq <= '0';
        amt20 <= '0';
        amt40 <= '1';
        amt60 <= '0';
        amt80 <= '0';
        amt100 <= '0';
        n10 <= '1';
        n20 <= '0';
        n50 <= '0';
        n100 <= '0';
        number10 <= (others => '0');
        number20 <= (others => '0');
        number50 <= (others => '0');
        number100 <= (others => '0');
		  
        wait for TbPeriod;

        -- Stop the clock and hence terminate the simulation
        TbSimEnded <= '1';
        wait;
    end process;

end tb;