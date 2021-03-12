----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 11/02/2020 02:38:29 PM
-- Design Name: 
-- Module Name: divider - Behavioral
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

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity divider is
    Port ( clk_i : in STD_LOGIC;
           clk_o : out STD_LOGIC);
end divider;

architecture Behavioral of divider is
    signal divider : std_logic := '0';
    signal divider_cnt : integer := 0;
    begin
    process(clk_i) begin
    if(rising_edge(clk_i)) then
        divider_cnt <= divider_cnt + 1;
        if(divider_cnt = 8) then 
            divider <= not divider;
            divider_cnt <= 0;
        end if;
    end if;
end process;
    clk_o <= divider;
end Behavioral;
