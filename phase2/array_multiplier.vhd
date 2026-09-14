LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;

ENTITY ARRAY_MULTIPLIER IS
    GENERIC (
        M : INTEGER := 8;
        N : INTEGER := 8
    );
    PORT (
        X : IN  STD_LOGIC_VECTOR;
        Y : IN  STD_LOGIC_VECTOR;
        Z : OUT STD_LOGIC_VECTOR
    );
END ENTITY ARRAY_MULTIPLIER;

ARCHITECTURE ITERATIVE OF ARRAY_MULTIPLIER IS

    COMPONENT BIT_MULTIPLIER
        PORT (
            XI, YI, PI, CI : IN  STD_LOGIC;
            XO, YO, PO, CO : OUT STD_LOGIC
        );
    END COMPONENT;

    TYPE GRID_SIGNAL IS ARRAY (M+1 DOWNTO 0, N+1 DOWNTO 0) OF STD_LOGIC;
    SIGNAL XV, YV, CV, PV : GRID_SIGNAL;
    
    ALIAS X_IN  : STD_LOGIC_VECTOR(M-1 DOWNTO 0) IS X;
    ALIAS Y_IN  : STD_LOGIC_VECTOR(N-1 DOWNTO 0) IS Y;
    ALIAS Z_OUT : STD_LOGIC_VECTOR((M+N)-1 DOWNTO 0) IS Z;

BEGIN 

    ROWS: FOR I IN 0 TO M-1 GENERATE
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

    X_SIDES: FOR I IN 0 TO M-1 GENERATE
        XV(I, 0)     <= X_IN(I);
        CV(I, 0)     <= '0';
        PV(I+1, N)   <= CV(I, N);
        Z_OUT(I)     <= PV(I+1, 0);
    END GENERATE X_SIDES;

    Y_SIDES: FOR J IN 0 TO N-1 GENERATE
        YV(0, J)     <= Y_IN(J);
        PV(0, J+1)   <= '0';
        Z_OUT(J + M) <= PV(M, J+1);
    END GENERATE Y_SIDES;

END ARCHITECTURE ITERATIVE;
