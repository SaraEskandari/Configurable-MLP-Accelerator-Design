LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.NUMERIC_STD.ALL;
USE IEEE.MATH_REAL.ALL;
USE WORK.TESTPACK.ALL;
USE WORK.MATH_PKG.ALL;

ENTITY MATRIX_MULTIPLIER_TB IS END MATRIX_MULTIPLIER_TB;

ARCHITECTURE BEHAVIOR OF MATRIX_MULTIPLIER_TB IS
    
    CONSTANT ROW_A    : INTEGER := 2;
    CONSTANT COLUMN_B : INTEGER := 2;
    CONSTANT COMMON   : INTEGER := 2;
    CONSTANT SIZE_A   : INTEGER := 8;
    CONSTANT SIZE_B   : INTEGER := 8;
    CONSTANT SIZE_EACH_SUM : INTEGER := SUM_WIDTH(SIZE_A + SIZE_B, COMMON);

    SIGNAL TEMP_A         : STD_LOGIC_VECTOR (SIZE_A-1 DOWNTO 0); 
    SIGNAL TEMP_B         : STD_LOGIC_VECTOR (SIZE_B-1 DOWNTO 0); 
    SIGNAL A              : STD_LOGIC_VECTOR((ROW_A * COMMON * SIZE_A) - 1 DOWNTO 0) := (OTHERS => '0');
    SIGNAL B              : STD_LOGIC_VECTOR((COMMON * COLUMN_B * SIZE_B) - 1 DOWNTO 0) := (OTHERS => '0');
    SIGNAL OUT_MULTIPLIER : STD_LOGIC_VECTOR((ROW_A * COLUMN_B * SIZE_EACH_SUM) - 1 DOWNTO 0);

BEGIN
    UUT2: CONFIGURATION WORK.CONFIG_MATRIX_MULTIPLIER
        GENERIC MAP (
            ROW_A    => ROW_A,
            COLUMN_B => COLUMN_B,
            COMMON   => COMMON,
            SIZE_A   => SIZE_A,
            SIZE_B   => SIZE_B
        )
        PORT MAP (
            A              => A, 
            B              => B, 
            OUT_MULTIPLIER => OUT_MULTIPLIER
        );


    SET_X_Y_AND_CHECK: PROCESS 
        VARIABLE SEED1, SEED2 : POSITIVE := 1;
        VARIABLE EXPECTED_OUT : SIGNED(SIZE_EACH_SUM - 1 DOWNTO 0);
    BEGIN
        FOR TEST IN 0 TO 10 LOOP
            
            FOR I IN 0 TO ROW_A-1 LOOP
                FOR K IN 0 TO COMMON-1 LOOP
                    WAIT FOR 20 NS;
                    RANDOM(SEED1, SEED2, TEMP_A);
                    A(((((I * COMMON) + K) + 1) * SIZE_A) - 1 DOWNTO (((I * COMMON) + K) * SIZE_A)) <= TEMP_A;
                END LOOP;
            END LOOP;

            FOR K IN 0 TO COMMON-1 LOOP
                FOR J IN 0 TO COLUMN_B-1 LOOP
                    WAIT FOR 20 NS;
                    RANDOM(SEED1, SEED2, TEMP_B);
                    B(((((K * COLUMN_B) + J) + 1) * SIZE_B) - 1 DOWNTO (((K * COLUMN_B) + J) * SIZE_B)) <= TEMP_B;
                    WAIT FOR 10 NS;
                END LOOP;
            END LOOP;

            WAIT FOR 20 NS;

            FOR I IN 0 TO ROW_A-1 LOOP
                FOR J IN 0 TO COLUMN_B-1 LOOP                   
                    EXPECTED_OUT := (OTHERS => '0');
                    FOR K IN 0 TO COMMON-1 LOOP
                        -- Resize the product before accumulation to match the final sum width
                        EXPECTED_OUT := EXPECTED_OUT + RESIZE(
                            SIGNED(A(((((I * COMMON) + K) + 1) * SIZE_A) - 1 DOWNTO (((I * COMMON) + K) * SIZE_A))) * 
                            SIGNED(B(((((K * COLUMN_B) + J) + 1) * SIZE_B) - 1 DOWNTO (((K * COLUMN_B) + J) * SIZE_B))),
                            SIZE_EACH_SUM
                        );
                    END LOOP;

                    ASSERT (SIGNED(OUT_MULTIPLIER(((((I * COLUMN_B) + J) + 1) * SIZE_EACH_SUM) - 1 DOWNTO (((I * COLUMN_B) + J) * SIZE_EACH_SUM))) = EXPECTED_OUT)
                        REPORT "MISMATCH AT OUTPUT (" & INTEGER'IMAGE(I) & "," & INTEGER'IMAGE(J) & ")! " &
                        ", EXPECTED VALUE: " & INTEGER'IMAGE(TO_INTEGER(EXPECTED_OUT)) &
                        ", ACTUAL VALUE: " & INTEGER'IMAGE(TO_INTEGER(SIGNED(OUT_MULTIPLIER(((((I * COLUMN_B) + J) + 1) * SIZE_EACH_SUM) - 1 DOWNTO (((I * COLUMN_B) + J) * SIZE_EACH_SUM)))))
                    SEVERITY ERROR;   
                END LOOP;
            END LOOP;
            
            WAIT FOR 10 NS;
        END LOOP;
        
        REPORT "SIMULATION COMPLETED SUCCESSFULLY." SEVERITY NOTE;
        WAIT;   
        
    END PROCESS SET_X_Y_AND_CHECK;

END ARCHITECTURE BEHAVIOR;
