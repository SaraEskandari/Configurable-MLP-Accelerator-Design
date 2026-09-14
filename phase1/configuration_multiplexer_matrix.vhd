LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
   
CONFIGURATION CONFIG_MATRIX_MULTIPLIER OF MATRIX_MULTIPLIER IS
FOR STRUCTURAL
    FOR ROW
        FOR COL
            FOR NUM_PRODUCT
                FOR U_MULTI: SIGNED_MULTIPLIER_WRAPPER
                    USE ENTITY WORK.SIGNED_MULTIPLIER_WRAPPER(STRUCTURAL)
                    GENERIC MAP (N => 8);
                    FOR STRUCTURAL 
                        FOR U_MULT: ARRAY_MULTIPLIER
                          USE ENTITY WORK.ARRAY_MULTIPLIER(ITERATIVE)
                          GENERIC MAP (N => 8);
                          FOR ITERATIVE
                                FOR ROWS
                                   FOR COLS
                                       FOR ALL: BIT_MULTIPLIER
                                       USE ENTITY WORK.BIT_MULTIPLIER(LOGICAL);
                                       END FOR;
                                    END FOR;
                                END FOR;
                            END FOR;
                        END FOR;
                    END FOR;
                END FOR;
            END FOR;
                       
            FOR U_TREE: ADDER_TREE
                USE ENTITY WORK.ADDER_TREE(RTL)
                    GENERIC MAP (
                     NUM_INPUTS => 2,
                     DATA_WIDTH => 16,
                     SUM_WIDTH  => 9
                     );
                FOR RTL
                    FOR LEVEL_GEN
                        FOR ADDER_GEN
                           FOR U_ADDER: ADDITION
                           USE ENTITY WORK.ADDITION(BEHAVIORAL)
                           GENERIC MAP (N => 32);

                           END FOR;
                        END FOR;
                    END FOR;
                END FOR;
            END FOR;
        END FOR;
    END FOR;
END FOR;
END CONFIGURATION CONFIG_MATRIX_MULTIPLIER;

