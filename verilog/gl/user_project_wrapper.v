module user_project_wrapper (user_clock2,
    wb_clk_i,
    wb_rst_i,
    wbs_ack_o,
    wbs_cyc_i,
    wbs_stb_i,
    wbs_we_i,
    vssa2,
    vdda2,
    vssa1,
    vdda1,
    vssd2,
    vccd2,
    vssd1,
    vccd1,
    analog_io,
    io_in,
    io_oeb,
    io_out,
    la_data_in,
    la_data_out,
    la_oenb,
    user_irq,
    wbs_adr_i,
    wbs_dat_i,
    wbs_dat_o,
    wbs_sel_i);
 input user_clock2;
 input wb_clk_i;
 input wb_rst_i;
 output wbs_ack_o;
 input wbs_cyc_i;
 input wbs_stb_i;
 input wbs_we_i;
 input vssa2;
 input vdda2;
 input vssa1;
 input vdda1;
 input vssd2;
 input vccd2;
 input vssd1;
 input vccd1;
 inout [28:0] analog_io;
 input [37:0] io_in;
 output [37:0] io_oeb;
 output [37:0] io_out;
 input [127:0] la_data_in;
 output [127:0] la_data_out;
 input [127:0] la_oenb;
 output [2:0] user_irq;
 input [31:0] wbs_adr_i;
 input [31:0] wbs_dat_i;
 output [31:0] wbs_dat_o;
 input [3:0] wbs_sel_i;

 wire adc_done_w;
 wire \dac_out_w[0] ;
 wire \dac_out_w[1] ;
 wire \dac_out_w[2] ;
 wire \dac_out_w[3] ;
 wire \dac_out_w[4] ;
 wire \dummy_adc_w[0] ;
 wire \dummy_adc_w[10] ;
 wire \dummy_adc_w[11] ;
 wire \dummy_adc_w[12] ;
 wire \dummy_adc_w[13] ;
 wire \dummy_adc_w[14] ;
 wire \dummy_adc_w[15] ;
 wire \dummy_adc_w[1] ;
 wire \dummy_adc_w[2] ;
 wire \dummy_adc_w[3] ;
 wire \dummy_adc_w[4] ;
 wire \dummy_adc_w[5] ;
 wire \dummy_adc_w[6] ;
 wire \dummy_adc_w[7] ;
 wire \dummy_adc_w[8] ;
 wire \dummy_adc_w[9] ;
 wire temp0_done_w;
 wire \temp1_dac_w[0] ;
 wire \temp1_dac_w[1] ;
 wire \temp1_dac_w[2] ;
 wire \temp1_dac_w[3] ;
 wire \temp1_dac_w[4] ;
 wire \temp1_dac_w[5] ;
 wire temp1_done_w;
 wire \temp1_tick_w[0] ;
 wire \temp1_tick_w[10] ;
 wire \temp1_tick_w[11] ;
 wire \temp1_tick_w[1] ;
 wire \temp1_tick_w[2] ;
 wire \temp1_tick_w[3] ;
 wire \temp1_tick_w[4] ;
 wire \temp1_tick_w[5] ;
 wire \temp1_tick_w[6] ;
 wire \temp1_tick_w[7] ;
 wire \temp1_tick_w[8] ;
 wire \temp1_tick_w[9] ;
 wire \temp2_dac_w[0] ;
 wire \temp2_dac_w[1] ;
 wire \temp2_dac_w[2] ;
 wire \temp2_dac_w[3] ;
 wire \temp2_dac_w[4] ;
 wire \temp2_dac_w[5] ;
 wire temp2_done_w;
 wire \temp2_tick_w[0] ;
 wire \temp2_tick_w[10] ;
 wire \temp2_tick_w[11] ;
 wire \temp2_tick_w[1] ;
 wire \temp2_tick_w[2] ;
 wire \temp2_tick_w[3] ;
 wire \temp2_tick_w[4] ;
 wire \temp2_tick_w[5] ;
 wire \temp2_tick_w[6] ;
 wire \temp2_tick_w[7] ;
 wire \temp2_tick_w[8] ;
 wire \temp2_tick_w[9] ;
 wire \temp3_dac_w[0] ;
 wire \temp3_dac_w[1] ;
 wire \temp3_dac_w[2] ;
 wire \temp3_dac_w[3] ;
 wire \temp3_dac_w[4] ;
 wire \temp3_dac_w[5] ;
 wire temp3_done_w;
 wire \temp3_tick_w[0] ;
 wire \temp3_tick_w[10] ;
 wire \temp3_tick_w[11] ;
 wire \temp3_tick_w[1] ;
 wire \temp3_tick_w[2] ;
 wire \temp3_tick_w[3] ;
 wire \temp3_tick_w[4] ;
 wire \temp3_tick_w[5] ;
 wire \temp3_tick_w[6] ;
 wire \temp3_tick_w[7] ;
 wire \temp3_tick_w[8] ;
 wire \temp3_tick_w[9] ;
 wire \tie_lo[74] ;
 wire \tie_lo[75] ;
 wire \tie_lo[76] ;
 wire \tie_lo[78] ;
 wire \tie_lo[79] ;
 wire \tie_lo[80] ;
 wire \tie_lo[81] ;
 wire \tie_lo[82] ;
 wire \tie_lo[83] ;
 wire \tie_lo[84] ;
 wire \tie_lo[85] ;
 wire \tie_lo[86] ;
 wire \tie_lo[87] ;
 wire \tie_lo[88] ;
 wire \tie_lo[89] ;
 wire \tie_lo[90] ;
 wire \tie_lo[91] ;
 wire \tie_lo[92] ;
 wire \tie_lo[93] ;
 wire \tie_lo[94] ;
 wire \tie_lo[95] ;

 adc_top adc0 (.VDD(vccd2),
    .VSS(vssd2),
    .clk_vcm(io_in[6]),
    .conversion_finished_out(adc_done_w),
    .inn_analog(analog_io[24]),
    .inp_analog(analog_io[23]),
    .rst_n(io_in[5]),
    .start_conversion_in(io_in[29]),
    .config_1_in({la_data_out[47],
    la_data_out[46],
    la_data_out[45],
    la_data_out[44],
    la_data_out[43],
    la_data_out[42],
    la_data_out[41],
    la_data_out[40],
    la_data_out[39],
    la_data_out[38],
    la_data_out[37],
    la_data_out[36],
    la_data_out[35],
    la_data_out[34],
    la_data_out[33],
    la_data_out[32]}),
    .config_2_in({la_data_out[63],
    la_data_out[62],
    la_data_out[61],
    la_data_out[60],
    la_data_out[59],
    la_data_out[58],
    la_data_out[57],
    la_data_out[56],
    la_data_out[55],
    la_data_out[54],
    la_data_out[53],
    la_data_out[52],
    la_data_out[51],
    la_data_out[50],
    la_data_out[49],
    la_data_out[48]}),
    .dummypin({\dummy_adc_w[15] ,
    \dummy_adc_w[14] ,
    \dummy_adc_w[13] ,
    \dummy_adc_w[12] ,
    \dummy_adc_w[11] ,
    \dummy_adc_w[10] ,
    \dummy_adc_w[9] ,
    \dummy_adc_w[8] ,
    \dummy_adc_w[7] ,
    \dummy_adc_w[6] ,
    \dummy_adc_w[5] ,
    \dummy_adc_w[4] ,
    \dummy_adc_w[3] ,
    \dummy_adc_w[2] ,
    \dummy_adc_w[1] ,
    \dummy_adc_w[0] }),
    .result_out({la_data_out[125],
    la_data_out[124],
    la_data_out[123],
    la_data_out[122],
    la_data_out[121],
    la_data_out[120],
    la_data_out[119],
    la_data_out[118],
    la_data_out[117],
    la_data_out[116],
    la_data_out[115],
    la_data_out[114],
    la_data_out[113],
    la_data_out[112],
    la_data_out[111],
    la_data_out[110]}));
 config_reg_mux cfg_reg0 (.loopback_i(la_data_in[127]),
    .loopback_o(la_data_out[127]),
    .reg_wr_i(io_in[26]),
    .rst_n_i(io_in[5]),
    .vccd1(vccd1),
    .vssd1(vssd1),
    .mux0_i({\tie_lo[74] ,
    adc_done_w,
    temp3_done_w,
    temp2_done_w,
    temp1_done_w,
    temp0_done_w}),
    .mux1_i({la_data_out[69],
    la_data_out[68],
    la_data_out[67],
    la_data_out[66],
    la_data_out[65],
    la_data_out[64]}),
    .mux2_i({la_data_out[81],
    la_data_out[80],
    la_data_out[79],
    la_data_out[78],
    la_data_out[77],
    la_data_out[76]}),
    .mux3_i({la_data_out[87],
    la_data_out[86],
    la_data_out[85],
    la_data_out[84],
    la_data_out[83],
    la_data_out[82]}),
    .mux4_i({la_data_out[109],
    \dac_out_w[4] ,
    \dac_out_w[3] ,
    \dac_out_w[2] ,
    \dac_out_w[1] ,
    \dac_out_w[0] }),
    .mux5_i({la_data_out[115],
    la_data_out[114],
    la_data_out[113],
    la_data_out[112],
    la_data_out[111],
    la_data_out[110]}),
    .mux6_i({la_data_out[121],
    la_data_out[120],
    la_data_out[119],
    la_data_out[118],
    la_data_out[117],
    la_data_out[116]}),
    .mux7_i({\tie_lo[75] ,
    \tie_lo[76] ,
    la_data_out[125],
    la_data_out[124],
    la_data_out[123],
    la_data_out[122]}),
    .mux_adr_i({io_in[25],
    io_in[24],
    io_in[23]}),
    .mux_o({io_out[37],
    io_out[36],
    io_out[35],
    io_out[34],
    io_out[33],
    io_out[32]}),
    .reg0_o({la_data_out[15],
    la_data_out[14],
    la_data_out[13],
    la_data_out[12],
    la_data_out[11],
    la_data_out[10],
    la_data_out[9],
    la_data_out[8],
    la_data_out[7],
    la_data_out[6],
    la_data_out[5],
    la_data_out[4],
    la_data_out[3],
    la_data_out[2],
    la_data_out[1],
    la_data_out[0]}),
    .reg1_o({la_data_out[31],
    la_data_out[30],
    la_data_out[29],
    la_data_out[28],
    la_data_out[27],
    la_data_out[26],
    la_data_out[25],
    la_data_out[24],
    la_data_out[23],
    la_data_out[22],
    la_data_out[21],
    la_data_out[20],
    la_data_out[19],
    la_data_out[18],
    la_data_out[17],
    la_data_out[16]}),
    .reg2_o({la_data_out[47],
    la_data_out[46],
    la_data_out[45],
    la_data_out[44],
    la_data_out[43],
    la_data_out[42],
    la_data_out[41],
    la_data_out[40],
    la_data_out[39],
    la_data_out[38],
    la_data_out[37],
    la_data_out[36],
    la_data_out[35],
    la_data_out[34],
    la_data_out[33],
    la_data_out[32]}),
    .reg3_o({la_data_out[63],
    la_data_out[62],
    la_data_out[61],
    la_data_out[60],
    la_data_out[59],
    la_data_out[58],
    la_data_out[57],
    la_data_out[56],
    la_data_out[55],
    la_data_out[54],
    la_data_out[53],
    la_data_out[52],
    la_data_out[51],
    la_data_out[50],
    la_data_out[49],
    la_data_out[48]}),
    .reg_adr_i({io_in[28],
    io_in[27]}),
    .reg_dat_i({io_in[22],
    io_in[21],
    io_in[20],
    io_in[19],
    io_in[18],
    io_in[17],
    io_in[16],
    io_in[15],
    io_in[14],
    io_in[13],
    io_in[12],
    io_in[11],
    io_in[10],
    io_in[9],
    io_in[8],
    io_in[7]}),
    .temp0_dac_i({la_data_out[75],
    la_data_out[74],
    la_data_out[73],
    la_data_out[72],
    la_data_out[71],
    la_data_out[70]}),
    .temp0_ticks_i({la_data_out[99],
    la_data_out[98],
    la_data_out[97],
    la_data_out[96],
    la_data_out[95],
    la_data_out[94],
    la_data_out[93],
    la_data_out[92],
    la_data_out[91],
    la_data_out[90],
    la_data_out[89],
    la_data_out[88]}),
    .temp1_dac_i({\temp1_dac_w[5] ,
    \temp1_dac_w[4] ,
    \temp1_dac_w[3] ,
    \temp1_dac_w[2] ,
    \temp1_dac_w[1] ,
    \temp1_dac_w[0] }),
    .temp1_ticks_i({\temp1_tick_w[11] ,
    \temp1_tick_w[10] ,
    \temp1_tick_w[9] ,
    \temp1_tick_w[8] ,
    \temp1_tick_w[7] ,
    \temp1_tick_w[6] ,
    \temp1_tick_w[5] ,
    \temp1_tick_w[4] ,
    \temp1_tick_w[3] ,
    \temp1_tick_w[2] ,
    \temp1_tick_w[1] ,
    \temp1_tick_w[0] }),
    .temp2_dac_i({\temp2_dac_w[5] ,
    \temp2_dac_w[4] ,
    \temp2_dac_w[3] ,
    \temp2_dac_w[2] ,
    \temp2_dac_w[1] ,
    \temp2_dac_w[0] }),
    .temp2_ticks_i({\temp2_tick_w[11] ,
    \temp2_tick_w[10] ,
    \temp2_tick_w[9] ,
    \temp2_tick_w[8] ,
    \temp2_tick_w[7] ,
    \temp2_tick_w[6] ,
    \temp2_tick_w[5] ,
    \temp2_tick_w[4] ,
    \temp2_tick_w[3] ,
    \temp2_tick_w[2] ,
    \temp2_tick_w[1] ,
    \temp2_tick_w[0] }),
    .temp3_dac_i({\temp3_dac_w[5] ,
    \temp3_dac_w[4] ,
    \temp3_dac_w[3] ,
    \temp3_dac_w[2] ,
    \temp3_dac_w[1] ,
    \temp3_dac_w[0] }),
    .temp3_ticks_i({\temp3_tick_w[11] ,
    \temp3_tick_w[10] ,
    \temp3_tick_w[9] ,
    \temp3_tick_w[8] ,
    \temp3_tick_w[7] ,
    \temp3_tick_w[6] ,
    \temp3_tick_w[5] ,
    \temp3_tick_w[4] ,
    \temp3_tick_w[3] ,
    \temp3_tick_w[2] ,
    \temp3_tick_w[1] ,
    \temp3_tick_w[0] }),
    .temp_dac_o({la_data_out[69],
    la_data_out[68],
    la_data_out[67],
    la_data_out[66],
    la_data_out[65],
    la_data_out[64]}),
    .temp_sel_i({la_data_out[8],
    la_data_out[7]}),
    .temp_ticks_o({la_data_out[87],
    la_data_out[86],
    la_data_out[85],
    la_data_out[84],
    la_data_out[83],
    la_data_out[82],
    la_data_out[81],
    la_data_out[80],
    la_data_out[79],
    la_data_out[78],
    la_data_out[77],
    la_data_out[76]}));
 const_gen const_gen0 (.vccd1(vccd1),
    .vssd1(vssd1),
    .tie_hi({io_oeb[31],
    io_oeb[30],
    io_oeb[29],
    io_oeb[28],
    io_oeb[27],
    io_oeb[26],
    io_oeb[25],
    io_oeb[24],
    io_oeb[23],
    io_oeb[22],
    io_oeb[21],
    io_oeb[20],
    io_oeb[19],
    io_oeb[18],
    io_oeb[17],
    io_oeb[16],
    io_oeb[15],
    io_oeb[14],
    io_oeb[13],
    io_oeb[12],
    io_oeb[11],
    io_oeb[10],
    io_oeb[9],
    io_oeb[8],
    io_oeb[7],
    io_oeb[6],
    io_oeb[5],
    io_oeb[4],
    io_oeb[3],
    io_oeb[2],
    io_oeb[1],
    io_oeb[0]}),
    .tie_lo({\tie_lo[95] ,
    \tie_lo[94] ,
    \tie_lo[93] ,
    \tie_lo[92] ,
    \tie_lo[91] ,
    \tie_lo[90] ,
    \tie_lo[89] ,
    \tie_lo[88] ,
    \tie_lo[87] ,
    \tie_lo[86] ,
    \tie_lo[85] ,
    \tie_lo[84] ,
    \tie_lo[83] ,
    \tie_lo[82] ,
    \tie_lo[81] ,
    \tie_lo[80] ,
    \tie_lo[79] ,
    \tie_lo[78] ,
    la_data_out[109],
    \tie_lo[76] ,
    \tie_lo[75] ,
    \tie_lo[74] ,
    wbs_ack_o,
    wbs_dat_o[31],
    wbs_dat_o[30],
    wbs_dat_o[29],
    wbs_dat_o[28],
    wbs_dat_o[27],
    wbs_dat_o[26],
    wbs_dat_o[25],
    wbs_dat_o[24],
    wbs_dat_o[23],
    wbs_dat_o[22],
    wbs_dat_o[21],
    wbs_dat_o[20],
    wbs_dat_o[19],
    wbs_dat_o[18],
    wbs_dat_o[17],
    wbs_dat_o[16],
    wbs_dat_o[15],
    wbs_dat_o[14],
    wbs_dat_o[13],
    wbs_dat_o[12],
    wbs_dat_o[11],
    wbs_dat_o[10],
    wbs_dat_o[9],
    wbs_dat_o[8],
    wbs_dat_o[7],
    wbs_dat_o[6],
    wbs_dat_o[5],
    wbs_dat_o[4],
    wbs_dat_o[3],
    wbs_dat_o[2],
    wbs_dat_o[1],
    wbs_dat_o[0],
    user_irq[2],
    user_irq[1],
    user_irq[0],
    io_oeb[37],
    io_oeb[36],
    io_oeb[35],
    io_oeb[34],
    io_oeb[33],
    io_oeb[32],
    io_out[31],
    io_out[30],
    io_out[29],
    io_out[28],
    io_out[27],
    io_out[26],
    io_out[25],
    io_out[24],
    io_out[23],
    io_out[22],
    io_out[21],
    io_out[20],
    io_out[19],
    io_out[18],
    io_out[17],
    io_out[16],
    io_out[15],
    io_out[14],
    io_out[13],
    io_out[12],
    io_out[11],
    io_out[10],
    io_out[9],
    io_out[8],
    io_out[7],
    io_out[6],
    io_out[5],
    io_out[4],
    io_out[3],
    io_out[2],
    io_out[1],
    io_out[0]}));
 audiodac dac0 (.clk_i(io_in[6]),
    .ds_n_o(\dac_out_w[1] ),
    .ds_o(\dac_out_w[0] ),
    .fifo_ack_o(\dac_out_w[2] ),
    .fifo_empty_o(\dac_out_w[4] ),
    .fifo_full_o(\dac_out_w[3] ),
    .fifo_rdy_i(io_in[29]),
    .mode_i(la_data_out[0]),
    .rst_n_i(io_in[5]),
    .tst_fifo_loop_i(la_data_out[16]),
    .tst_sinegen_en_i(la_data_out[17]),
    .vccd1(vccd1),
    .vssd1(vssd1),
    .fifo_i({io_in[22],
    io_in[21],
    io_in[20],
    io_in[19],
    io_in[18],
    io_in[17],
    io_in[16],
    io_in[15],
    io_in[14],
    io_in[13],
    io_in[12],
    io_in[11],
    io_in[10],
    io_in[9],
    io_in[8],
    io_in[7]}),
    .osr_i({la_data_out[6],
    la_data_out[5]}),
    .tst_sinegen_step_i({la_data_out[23],
    la_data_out[22],
    la_data_out[21],
    la_data_out[20],
    la_data_out[19],
    la_data_out[18]}),
    .volume_i({la_data_out[4],
    la_data_out[3],
    la_data_out[2],
    la_data_out[1]}));
 tempsense temp0 (.clk(io_in[6]),
    .conversion_finished_out(temp0_done_w),
    .rst_n(io_in[5]),
    .start_conv_in(io_in[29]),
    .vccd1(vccd1),
    .vssd1(vssd1),
    .tick_result_out({la_data_out[99],
    la_data_out[98],
    la_data_out[97],
    la_data_out[96],
    la_data_out[95],
    la_data_out[94],
    la_data_out[93],
    la_data_out[92],
    la_data_out[91],
    la_data_out[90],
    la_data_out[89],
    la_data_out[88]}),
    .vdac_result_out({la_data_out[75],
    la_data_out[74],
    la_data_out[73],
    la_data_out[72],
    la_data_out[71],
    la_data_out[70]}));
 tempsense temp1 (.clk(io_in[6]),
    .conversion_finished_out(temp1_done_w),
    .rst_n(io_in[5]),
    .start_conv_in(io_in[29]),
    .vccd1(vccd1),
    .vssd1(vssd1),
    .tick_result_out({\temp1_tick_w[11] ,
    \temp1_tick_w[10] ,
    \temp1_tick_w[9] ,
    \temp1_tick_w[8] ,
    \temp1_tick_w[7] ,
    \temp1_tick_w[6] ,
    \temp1_tick_w[5] ,
    \temp1_tick_w[4] ,
    \temp1_tick_w[3] ,
    \temp1_tick_w[2] ,
    \temp1_tick_w[1] ,
    \temp1_tick_w[0] }),
    .vdac_result_out({\temp1_dac_w[5] ,
    \temp1_dac_w[4] ,
    \temp1_dac_w[3] ,
    \temp1_dac_w[2] ,
    \temp1_dac_w[1] ,
    \temp1_dac_w[0] }));
 tempsense temp2 (.clk(io_in[6]),
    .conversion_finished_out(temp2_done_w),
    .rst_n(io_in[5]),
    .start_conv_in(io_in[29]),
    .vccd1(vccd1),
    .vssd1(vssd1),
    .tick_result_out({\temp2_tick_w[11] ,
    \temp2_tick_w[10] ,
    \temp2_tick_w[9] ,
    \temp2_tick_w[8] ,
    \temp2_tick_w[7] ,
    \temp2_tick_w[6] ,
    \temp2_tick_w[5] ,
    \temp2_tick_w[4] ,
    \temp2_tick_w[3] ,
    \temp2_tick_w[2] ,
    \temp2_tick_w[1] ,
    \temp2_tick_w[0] }),
    .vdac_result_out({\temp2_dac_w[5] ,
    \temp2_dac_w[4] ,
    \temp2_dac_w[3] ,
    \temp2_dac_w[2] ,
    \temp2_dac_w[1] ,
    \temp2_dac_w[0] }));
 tempsense temp3 (.clk(io_in[6]),
    .conversion_finished_out(temp3_done_w),
    .rst_n(io_in[5]),
    .start_conv_in(io_in[29]),
    .vccd1(vccd1),
    .vssd1(vssd1),
    .tick_result_out({\temp3_tick_w[11] ,
    \temp3_tick_w[10] ,
    \temp3_tick_w[9] ,
    \temp3_tick_w[8] ,
    \temp3_tick_w[7] ,
    \temp3_tick_w[6] ,
    \temp3_tick_w[5] ,
    \temp3_tick_w[4] ,
    \temp3_tick_w[3] ,
    \temp3_tick_w[2] ,
    \temp3_tick_w[1] ,
    \temp3_tick_w[0] }),
    .vdac_result_out({\temp3_dac_w[5] ,
    \temp3_dac_w[4] ,
    \temp3_dac_w[3] ,
    \temp3_dac_w[2] ,
    \temp3_dac_w[1] ,
    \temp3_dac_w[0] }));
 assign la_data_out[126] = adc_done_w;
 assign la_data_out[104] = \dac_out_w[0] ;
 assign la_data_out[105] = \dac_out_w[1] ;
 assign la_data_out[106] = \dac_out_w[2] ;
 assign la_data_out[107] = \dac_out_w[3] ;
 assign la_data_out[108] = \dac_out_w[4] ;
 assign la_data_out[100] = temp0_done_w;
 assign la_data_out[101] = temp1_done_w;
 assign la_data_out[102] = temp2_done_w;
 assign la_data_out[103] = temp3_done_w;
endmodule
