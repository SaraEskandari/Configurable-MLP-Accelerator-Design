`timescale 1ns / 1ps

module mlp_tb;
    reg [127:0] x_in;
    wire [3:0] stage_classification;

    integer i, p;
    integer data_file, label_file;
    integer pixel_val, true_label;
    integer errors, scan_res;
    reg [8*100:1] data_filename;
    reg [8*100:1] label_filename;

// --- 4. UNIT UNDER TEST
// -- 4.1. Netlist instantiation
// -- 4.1.1. Bit-blasted port mapping
MLP_TOP uut (
    .\X_IN[0] (x_in[0]),
    .\X_IN[1] (x_in[1]),
    .\X_IN[2] (x_in[2]),
    .\X_IN[3] (x_in[3]),
    .\X_IN[4] (x_in[4]),
    .\X_IN[5] (x_in[5]),
    .\X_IN[6] (x_in[6]),
    .\X_IN[7] (x_in[7]),
    .\X_IN[8] (x_in[8]),
    .\X_IN[9] (x_in[9]),
    .\X_IN[10] (x_in[10]),
    .\X_IN[11] (x_in[11]),
    .\X_IN[12] (x_in[12]),
    .\X_IN[13] (x_in[13]),
    .\X_IN[14] (x_in[14]),
    .\X_IN[15] (x_in[15]),
    .\X_IN[16] (x_in[16]),
    .\X_IN[17] (x_in[17]),
    .\X_IN[18] (x_in[18]),
    .\X_IN[19] (x_in[19]),
    .\X_IN[20] (x_in[20]),
    .\X_IN[21] (x_in[21]),
    .\X_IN[22] (x_in[22]),
    .\X_IN[23] (x_in[23]),
    .\X_IN[24] (x_in[24]),
    .\X_IN[25] (x_in[25]),
    .\X_IN[26] (x_in[26]),
    .\X_IN[27] (x_in[27]),
    .\X_IN[28] (x_in[28]),
    .\X_IN[29] (x_in[29]),
    .\X_IN[30] (x_in[30]),
    .\X_IN[31] (x_in[31]),
    .\X_IN[32] (x_in[32]),
    .\X_IN[33] (x_in[33]),
    .\X_IN[34] (x_in[34]),
    .\X_IN[35] (x_in[35]),
    .\X_IN[36] (x_in[36]),
    .\X_IN[37] (x_in[37]),
    .\X_IN[38] (x_in[38]),
    .\X_IN[39] (x_in[39]),
    .\X_IN[40] (x_in[40]),
    .\X_IN[41] (x_in[41]),
    .\X_IN[42] (x_in[42]),
    .\X_IN[43] (x_in[43]),
    .\X_IN[44] (x_in[44]),
    .\X_IN[45] (x_in[45]),
    .\X_IN[46] (x_in[46]),
    .\X_IN[47] (x_in[47]),
    .\X_IN[48] (x_in[48]),
    .\X_IN[49] (x_in[49]),
    .\X_IN[50] (x_in[50]),
    .\X_IN[51] (x_in[51]),
    .\X_IN[52] (x_in[52]),
    .\X_IN[53] (x_in[53]),
    .\X_IN[54] (x_in[54]),
    .\X_IN[55] (x_in[55]),
    .\X_IN[56] (x_in[56]),
    .\X_IN[57] (x_in[57]),
    .\X_IN[58] (x_in[58]),
    .\X_IN[59] (x_in[59]),
    .\X_IN[60] (x_in[60]),
    .\X_IN[61] (x_in[61]),
    .\X_IN[62] (x_in[62]),
    .\X_IN[63] (x_in[63]),
    .\X_IN[64] (x_in[64]),
    .\X_IN[65] (x_in[65]),
    .\X_IN[66] (x_in[66]),
    .\X_IN[67] (x_in[67]),
    .\X_IN[68] (x_in[68]),
    .\X_IN[69] (x_in[69]),
    .\X_IN[70] (x_in[70]),
    .\X_IN[71] (x_in[71]),
    .\X_IN[72] (x_in[72]),
    .\X_IN[73] (x_in[73]),
    .\X_IN[74] (x_in[74]),
    .\X_IN[75] (x_in[75]),
    .\X_IN[76] (x_in[76]),
    .\X_IN[77] (x_in[77]),
    .\X_IN[78] (x_in[78]),
    .\X_IN[79] (x_in[79]),
    .\X_IN[80] (x_in[80]),
    .\X_IN[81] (x_in[81]),
    .\X_IN[82] (x_in[82]),
    .\X_IN[83] (x_in[83]),
    .\X_IN[84] (x_in[84]),
    .\X_IN[85] (x_in[85]),
    .\X_IN[86] (x_in[86]),
    .\X_IN[87] (x_in[87]),
    .\X_IN[88] (x_in[88]),
    .\X_IN[89] (x_in[89]),
    .\X_IN[90] (x_in[90]),
    .\X_IN[91] (x_in[91]),
    .\X_IN[92] (x_in[92]),
    .\X_IN[93] (x_in[93]),
    .\X_IN[94] (x_in[94]),
    .\X_IN[95] (x_in[95]),
    .\X_IN[96] (x_in[96]),
    .\X_IN[97] (x_in[97]),
    .\X_IN[98] (x_in[98]),
    .\X_IN[99] (x_in[99]),
    .\X_IN[100] (x_in[100]),
    .\X_IN[101] (x_in[101]),
    .\X_IN[102] (x_in[102]),
    .\X_IN[103] (x_in[103]),
    .\X_IN[104] (x_in[104]),
    .\X_IN[105] (x_in[105]),
    .\X_IN[106] (x_in[106]),
    .\X_IN[107] (x_in[107]),
    .\X_IN[108] (x_in[108]),
    .\X_IN[109] (x_in[109]),
    .\X_IN[110] (x_in[110]),
    .\X_IN[111] (x_in[111]),
    .\X_IN[112] (x_in[112]),
    .\X_IN[113] (x_in[113]),
    .\X_IN[114] (x_in[114]),
    .\X_IN[115] (x_in[115]),
    .\X_IN[116] (x_in[116]),
    .\X_IN[117] (x_in[117]),
    .\X_IN[118] (x_in[118]),
    .\X_IN[119] (x_in[119]),
    .\X_IN[120] (x_in[120]),
    .\X_IN[121] (x_in[121]),
    .\X_IN[122] (x_in[122]),
    .\X_IN[123] (x_in[123]),
    .\X_IN[124] (x_in[124]),
    .\X_IN[125] (x_in[125]),
    .\X_IN[126] (x_in[126]),
    .\X_IN[127] (x_in[127]),
    
    .\STAGE_CLASSIFICATION[0] (stage_classification[0]),
    .\STAGE_CLASSIFICATION[1] (stage_classification[1]),
    .\STAGE_CLASSIFICATION[2] (stage_classification[2]),
    .\STAGE_CLASSIFICATION[3] (stage_classification[3])
);



    initial begin
        x_in = 0;
        errors = 0;

        for (i = 0; i < 10; i = i + 1) begin
            #1;
            
            $sformat(data_filename, "D:/CA#2_VHDL_Spring1405/phase2/sample_%0d_data.txt", i);
            $sformat(label_filename, "D:/CA#2_VHDL_Spring1405/phase2/sample_%0d_label.txt", i);
            
            data_file = $fopen(data_filename, "r");
            label_file = $fopen(label_filename, "r");

            x_in = 128'b0;
            
            for (p = 0; p < 16; p = p + 1) begin
                if (!$feof(data_file)) begin
                    scan_res = $fscanf(data_file, "%d\n", pixel_val);
                    x_in[((16 - p) * 8 - 1) -: 8] = pixel_val;
                    #1;
                end
            end

            if (!$feof(label_file)) begin
                scan_res = $fscanf(label_file, "%d\n", true_label);
                #1;
            end

            #5000;

            $display("Sample=%0d Pred=%0d True=%0d", i, stage_classification, true_label);

            if (stage_classification !== true_label) begin
                errors = errors + 1;
            end

            $fclose(data_file);
            $fclose(label_file);
            
            #100;
        end

        $display("SIMULATION COMPLETE. TOTAL ERRORS: %0d", errors);
        $finish;
    end

endmodule
