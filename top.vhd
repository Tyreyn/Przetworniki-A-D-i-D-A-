----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 11/02/2020 02:02:16 PM
-- Design Name: 
-- Module Name: top - Behavioral
-- Project Name: 
-- Target Devices: 
-- Tool Versions: 
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
use ieee.numeric_std.all;
-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

 

entity top is
    Generic(
    data_width : integer := 24
    );
    Port ( CLK100MHZ : in STD_LOGIC;
           LED : out STD_LOGIC_VECTOR (15 downto 0);
           AD_MCLK : out STD_LOGIC;
           AD_LRCK : out STD_LOGIC;
           AD_SCLK : out STD_LOGIC;
           AD_SDOUT : in STD_LOGIC;
           DA_MCLK : out STD_LOGIC;
           DA_LRCK : out STD_LOGIC;
           DA_SCLK : out STD_LOGIC;
           DA_SDIN : out STD_LOGIC)
           ;
end top;

architecture Behavioral of top is
    signal clk_lrck : std_logic := '0';
    signal clk_mclk : std_logic := '0';
    signal clk_sclk : std_logic := '0';    
    signal l_data_ad_in : std_logic_vector(data_width-1 downto 0) := (OTHERS => '0');
    signal r_data_ad_in : std_logic_vector(data_width-1 downto 0) := (OTHERS => '0');
    signal l_data_da_out : std_logic_vector(data_width-1 downto 0) := (OTHERS => '0');
    signal r_data_da_out : std_logic_vector(data_width-1 downto 0):= (OTHERS => '0');
    signal LED_TMP : unsigned(15 downto 0) := (0 => '1', OTHERS => '0');
    signal STRB : std_logic := '0';
    signal divider_cnt : integer := 0;
    COMPONENT divider is
        Port(
            clk_i : in std_logic;
            clk_o : out std_logic
            );
    end component;
begin
    DIVLRCK : divider PORT MAP(CLK100MHZ,clk_mclk);
        
    process(clk_mclk)
    variable driver : integer :=0;
    variable cnt : std_logic := '0';
    variable sclk_cnt:integer:=0;
    variable lrck_cnt:integer:=0;
    begin
        if(clk_mclk'EVENT AND clk_mclk ='1') then
            if(sclk_cnt<4/2-1) then
                sclk_cnt := sclk_cnt +1;
            else
                sclk_cnt := 0;
                clk_sclk <= not clk_sclk;
                if(lrck_cnt<64-1)then
                    STRB <= '0';
                    lrck_cnt := lrck_cnt + 1;
                    if(clk_sclk = '0' AND lrck_cnt > 1 AND lrck_cnt < data_width *2 +2) THEN
                        if(clk_lrck = '0') THEN
                            l_data_ad_in <= l_data_ad_in(data_width -2 downto 0) & AD_SDOUT;
                        else
                            r_data_ad_in <= r_data_ad_in(data_width-2 downto 0) & AD_SDOUT;
                        end if;
                         
                    end if;
                    if(clk_sclk ='1' and lrck_cnt < data_width *2 +3 ) THEN
                        if(clk_lrck = '0') THEN 
                            DA_SDIN <= l_data_da_out(data_width-1);
                            l_data_da_out <= l_data_da_out(data_width-2 downto 0) & '0';
                        else             
                            DA_SDIN <= r_data_da_out(data_width-1);
                            r_data_da_out <= r_data_da_out(data_width-2 downto 0) & '0';
                        end if;
                    end if;
                else
                    LED <= std_logic_vector(abs(signed(l_data_ad_in(data_width-1 downto 8))));
                    STRB <= '1';
                    lrck_cnt := 0;
                    clk_lrck <= not clk_lrck;
                    l_data_da_out <= l_data_ad_in;
                    r_data_da_out <= r_data_ad_in;
                end if;
            end if;
        end if;
    end process;    
    AD_LRCK <= clk_lrck;
    DA_LRCK <= clk_lrck;
    AD_MCLK <= clk_mclk;
    DA_MCLK <= clk_mclk;
    AD_SCLK <= clk_sclk;
    DA_SCLK <= clk_sclk;
end Behavioral;
