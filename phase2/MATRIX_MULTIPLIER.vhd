
LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.NUMERIC_STD.ALL;
USE IEEE.MATH_REAL.ALL;
USE WORK.MATH_PKG.ALL;

ENTITY MATRIX_MULTIPLIER IS
    GENERIC (
        ROW_A    : INTEGER := 2;
        COLUMN_B : INTEGER := 2;
        COMMON   : INTEGER := 2;
        SIZE_A   : INTEGER := 8;
        SIZE_B   : INTEGER := 8
    );
    PORT (
        A              : IN  STD_LOGIC_VECTOR;
        B              : IN  STD_LOGIC_VECTOR;
        OUT_MULTIPLIER : OUT STD_LOGIC_VECTOR
    );
END ENTITY MATRIX_MULTIPLIER;



ARCHITECTURE STRUCTURAL OF MATRIX_MULTIPLIER IS

    COMPONENT SIGNED_MULTIPLIER_WRAPPER IS
        GENERIC (
            M : INTEGER := 8;
            N : INTEGER := 8
        );
        PORT (
            X_SIGNED : IN  STD_LOGIC_VECTOR;
            Y_SIGNED : IN  STD_LOGIC_VECTOR;
            Z_SIGNED : OUT STD_LOGIC_VECTOR
        );
    END COMPONENT;

    COMPONENT ADDER_TREE IS
        GENERIC (
            NUM_INPUTS : INTEGER;
            DATA_WIDTH : INTEGER;
            SUM_WIDTH  : INTEGER
        );
        PORT (
            DATA_IN  : IN  STD_LOGIC_VECTOR;
            DATA_OUT : OUT STD_LOGIC_VECTOR
        );
    END COMPONENT;

    SIGNAL MULT : STD_LOGIC_VECTOR((ROW_A * COLUMN_B * COMMON * (SIZE_A + SIZE_B)) - 1 DOWNTO 0);
    CONSTANT SIZE_EACH_SUM : INTEGER := SUM_WIDTH((SIZE_A + SIZE_B), COMMON);

BEGIN

    ROW: FOR I IN 0 TO ROW_A-1 GENERATE
        COL: FOR J IN 0 TO COLUMN_B-1 GENERATE
            
            NUM_PRODUCT: FOR K IN 0 TO COMMON-1 GENERATE
                U_MULTI: SIGNED_MULTIPLIER_WRAPPER 
                GENERIC MAP (
                    M => SIZE_A,
                    N => SIZE_B
                )
                PORT MAP (
                    X_SIGNED => A((((ROW_A - I) * COMMON - K) * SIZE_A) - 1 DOWNTO (((ROW_A - I) * COMMON - 1 - K) * SIZE_A)),
                    Y_SIGNED => B((((COMMON - K) * COLUMN_B - J) * SIZE_B) - 1 DOWNTO (((COMMON - K) * COLUMN_B - 1 - J) * SIZE_B)),
                    Z_SIGNED => MULT(((((ROW_A - I) * COLUMN_B * COMMON) - (J * COMMON) - K) * (SIZE_A + SIZE_B)) - 1 DOWNTO ((((ROW_A - I) * COLUMN_B * COMMON) - (J * COMMON) - 1 - K) * (SIZE_A + SIZE_B)))
                ); 
            END GENERATE NUM_PRODUCT;  

            U_TREE: ADDER_TREE
            GENERIC MAP (
                NUM_INPUTS => COMMON,
                DATA_WIDTH => SIZE_A + SIZE_B,
                SUM_WIDTH  => SIZE_EACH_SUM
            )
            PORT MAP (
                DATA_IN  => MULT(((((ROW_A - I) * COLUMN_B * COMMON) - (J * COMMON)) * (SIZE_A + SIZE_B)) - 1 DOWNTO ((((ROW_A - I) * COLUMN_B * COMMON) - (J * COMMON) - COMMON) * (SIZE_A + SIZE_B))),
                DATA_OUT => OUT_MULTIPLIER(((((ROW_A - I) * COLUMN_B) - J) * SIZE_EACH_SUM) - 1 DOWNTO ((((ROW_A - I) * COLUMN_B) - 1 - J) * SIZE_EACH_SUM))
            );
            
        END GENERATE COL;
    END GENERATE ROW;

END ARCHITECTURE STRUCTURAL;
