LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;

ENTITY ARRAY_MULTIPLIER IS
    GENERIC (N : INTEGER := 8);
    PORT (X, Y : IN  STD_LOGIC_VECTOR(N-1 DOWNTO 0);
          Z : OUT STD_LOGIC_VECTOR((2*N)-1 DOWNTO 0)
    );
END ENTITY ARRAY_MULTIPLIER;

ARCHITECTURE ITERATIVE OF ARRAY_MULTIPLIER IS
   COMPONENT BIT_MULTIPLIER
        PORT (XI, YI, PI, CI : IN  STD_LOGIC;
             XO, YO, PO, CO : OUT STD_LOGIC);
    END COMPONENT;

    TYPE GRID_SIGNAL IS ARRAY (N+1 DOWNTO 0, N+1 DOWNTO 0) OF STD_LOGIC;
    SIGNAL XV, YV, CV, PV : GRID_SIGNAL;

BEGIN 

    ROWS: FOR I IN 0 TO N-1 GENERATE
        COLS: FOR J IN 0 TO N-1 GENERATE
            UI: BIT_MULTIPLIER PORT MAP (
                XI => XV(I, J),
                YI => YV(I, J),
                PI => PV(I, J+1),
                CI => CV(I, J),
                XO => XV(I, J+1),
                YO => YV(I+1, J),
                PO => PV(I+1, J),
                CO => CV(I, J+1)
            );
        END GENERATE COLS;
    END GENERATE ROWS;

    SIDES: FOR I IN X'RANGE GENERATE
        XV(I, 0)       <= X(I);
        CV(I, 0)       <= '0';
        PV(0, I+1)     <= '0';
        PV(I+1, N)   <= CV(I, N);
        YV(0, I)       <= Y(I);
        Z(I)           <= PV(I+1, 0);
        Z(I + N)   <= PV(N, I+1);
    END GENERATE SIDES;

END ARCHITECTURE ITERATIVE;
