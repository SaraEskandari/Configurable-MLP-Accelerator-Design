LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.NUMERIC_STD.ALL; 
USE WORK.MATH_PKG.ALL; 

ENTITY FULLY_CONNECTED_LAYER IS
    GENERIC (
        NUM_INPUT      : INTEGER := 4;
        NUM_NEURON     : INTEGER := 4;
        IN_DATA_WIDTH  : INTEGER := 8;
        WEIGHT_WIDTH   : INTEGER := 16;
        BIAS_WIDTH     : INTEGER := 16;
        OUT_DATA_WIDTH : INTEGER := 8;
        INDEX_BIT      : INTEGER := 4
    );
    PORT (
        X                  : IN  STD_LOGIC_VECTOR;
        WEIGHTS            : IN  STD_LOGIC_VECTOR;
        BIASES             : IN  STD_LOGIC_VECTOR;
        RELU_START         : IN  STD_LOGIC;
        Y_OUT              : OUT STD_LOGIC_VECTOR;
        CLASSIFICATION_OUT : OUT STD_LOGIC_VECTOR
    );
END FULLY_CONNECTED_LAYER;

ARCHITECTURE STRUCTURAL OF FULLY_CONNECTED_LAYER IS

    COMPONENT MATRIX_MULTIPLIER IS
        GENERIC (
            ROW_A    : INTEGER;
            COLUMN_B : INTEGER;
            COMMON   : INTEGER;
            SIZE_A   : INTEGER;
            SIZE_B   : INTEGER
        );
        PORT (
            A              : IN  STD_LOGIC_VECTOR;
            B              : IN  STD_LOGIC_VECTOR;
            OUT_MULTIPLIER : OUT STD_LOGIC_VECTOR
        );
    END COMPONENT;

    COMPONENT RELU_ACTIVATION IS
        GENERIC (BIT_WIDTH : INTEGER);
        PORT (
            X   : IN  STD_LOGIC_VECTOR;
            F_X : OUT STD_LOGIC_VECTOR
        );
    END COMPONENT;

    COMPONENT SOFTMAX IS
        GENERIC (
            NUM_ELEMENTS : INTEGER;
            DATA_WIDTH   : INTEGER; 
            INDEX_BIT    : INTEGER  
        );
        PORT (
            DATA_IN : IN  STD_LOGIC_VECTOR;
            MAX_VAL : OUT STD_LOGIC_VECTOR;
            MAX_IDX : OUT STD_LOGIC_VECTOR
        );
    END COMPONENT;

    COMPONENT ARITHMETIC_RIGHT_SHIFTER IS
        GENERIC (
            DATA_WIDTH   : INTEGER;
            SHIFT_AMOUNT : INTEGER
        );
        PORT (
            D_IN  : IN  STD_LOGIC_VECTOR;
            D_OUT : OUT STD_LOGIC_VECTOR
        );
    END COMPONENT;

    COMPONENT ADDITION IS
        GENERIC (N : INTEGER := 8);
        PORT (
            X   : IN  STD_LOGIC_VECTOR(N - 1 DOWNTO 0);
            Y   : IN  STD_LOGIC_VECTOR(N - 1 DOWNTO 0);
            ADD : OUT STD_LOGIC_VECTOR(N - 1 DOWNTO 0)
        );
    END COMPONENT;

    CONSTANT FRAC_BITS : INTEGER := 6;
    CONSTANT ACC_WIDTH : INTEGER := SUM_WIDTH((IN_DATA_WIDTH + WEIGHT_WIDTH), NUM_INPUT) + 1;
    
    SIGNAL FLAT_SUMMATION : STD_LOGIC_VECTOR(NUM_NEURON * ACC_WIDTH - 1 DOWNTO 0);
    SIGNAL ARGMAX_MAX_VAL : STD_LOGIC_VECTOR(ACC_WIDTH - 1 DOWNTO 0);
    SIGNAL IDX_INTERNAL   : STD_LOGIC_VECTOR(INDEX_BIT - 1 DOWNTO 0);

BEGIN

    NEURON_GEN: FOR I IN 0 TO NUM_NEURON - 1 GENERATE
        SIGNAL NEURON_W         : STD_LOGIC_VECTOR((NUM_INPUT * WEIGHT_WIDTH) - 1 DOWNTO 0);
        SIGNAL WX_EACH_NEURON   : STD_LOGIC_VECTOR((ACC_WIDTH - 1) - 1 DOWNTO 0);
        SIGNAL BIAS_EACH_NEURON : STD_LOGIC_VECTOR(BIAS_WIDTH - 1 DOWNTO 0);
        
        SIGNAL RELU_OUT     : STD_LOGIC_VECTOR(ACC_WIDTH - 1 DOWNTO 0);
        SIGNAL SHIFTED_RELU : STD_LOGIC_VECTOR(ACC_WIDTH - 1 DOWNTO 0);
        SIGNAL ADDER_IN_X   : STD_LOGIC_VECTOR(ACC_WIDTH - 1 DOWNTO 0);
        SIGNAL ADDER_IN_Y   : STD_LOGIC_VECTOR(ACC_WIDTH - 1 DOWNTO 0);
        SIGNAL ADDER_OUT    : STD_LOGIC_VECTOR(ACC_WIDTH - 1 DOWNTO 0);
        SIGNAL SHIFTER_IN   : STD_LOGIC_VECTOR(ACC_WIDTH - 1 DOWNTO 0);
    BEGIN
        --  neuron weight slicing
        NEURON_W <= WEIGHTS(((NUM_NEURON - I) * (NUM_INPUT * WEIGHT_WIDTH)) - 1 DOWNTO ((NUM_NEURON - 1 - I) * (NUM_INPUT * WEIGHT_WIDTH)));

        MATRIX_MULT: MATRIX_MULTIPLIER
        GENERIC MAP (
            ROW_A    => 1,
            COLUMN_B => 1,
            COMMON   => NUM_INPUT,
            SIZE_A   => WEIGHT_WIDTH,
            SIZE_B   => IN_DATA_WIDTH
        )
        PORT MAP (
            A              => NEURON_W,
            B              => X,
            OUT_MULTIPLIER => WX_EACH_NEURON
        );
        
        -- Slice bias for the current neuron
        BIAS_EACH_NEURON <= BIASES(((NUM_NEURON - I) * BIAS_WIDTH) - 1 DOWNTO ((NUM_NEURON - 1 - I) * BIAS_WIDTH));        
        
        ADDER_IN_X <= STD_LOGIC_VECTOR(RESIZE(SIGNED(WX_EACH_NEURON), ACC_WIDTH));
        ADDER_IN_Y <= STD_LOGIC_VECTOR(RESIZE(SIGNED(BIAS_EACH_NEURON), ACC_WIDTH));

        U_BIAS_ADDER: ADDITION
            GENERIC MAP (N => ACC_WIDTH)
            PORT MAP (
                X   => ADDER_IN_X,
                Y   => ADDER_IN_Y,
                ADD => ADDER_OUT
            );

        FLAT_SUMMATION(((NUM_NEURON - I) * ACC_WIDTH) - 1 DOWNTO ((NUM_NEURON - 1 - I) * ACC_WIDTH)) <= ADDER_OUT;
 
        U_RELU: RELU_ACTIVATION
            GENERIC MAP (BIT_WIDTH => ACC_WIDTH)
            PORT MAP (
              X   => ADDER_OUT,
              F_X => RELU_OUT
             );
             
        SHIFTER_IN <= RELU_OUT WHEN RELU_START = '1' ELSE ADDER_OUT;
        U_SHIFTER: ARITHMETIC_RIGHT_SHIFTER
            GENERIC MAP (
                DATA_WIDTH   => ACC_WIDTH,   
                SHIFT_AMOUNT => FRAC_BITS  
            )
            PORT MAP (
                D_IN  => SHIFTER_IN,
                D_OUT => SHIFTED_RELU  
            );

        Y_OUT(((NUM_NEURON - I) * OUT_DATA_WIDTH) - 1 DOWNTO ((NUM_NEURON - 1 - I) * OUT_DATA_WIDTH)) <= SHIFTED_RELU(OUT_DATA_WIDTH - 1 DOWNTO 0);      
    END GENERATE NEURON_GEN;

    U_SOFTMAX: SOFTMAX
    GENERIC MAP (
        NUM_ELEMENTS => NUM_NEURON, 
        DATA_WIDTH   => ACC_WIDTH,
        INDEX_BIT    => INDEX_BIT
    )
    PORT MAP(
        DATA_IN => FLAT_SUMMATION,
        MAX_VAL => ARGMAX_MAX_VAL,
        MAX_IDX => IDX_INTERNAL
    );
           
    CLASSIFICATION_OUT <= IDX_INTERNAL WHEN RELU_START = '0' ELSE (INDEX_BIT - 1 DOWNTO 0 => '0');
    
END ARCHITECTURE STRUCTURAL;
