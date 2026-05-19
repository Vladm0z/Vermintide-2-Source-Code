-- chunkname: @scripts/utils/varargs.lua

unpack_index = {}
unpack_index[0] = function()
	return
end
unpack_index[1] = function(arg_2_0, arg_2_1)
	return arg_2_0[arg_2_1]
end
unpack_index[2] = function(arg_3_0, arg_3_1)
	return arg_3_0[arg_3_1], arg_3_0[arg_3_1 + 1]
end
unpack_index[3] = function(arg_4_0, arg_4_1)
	return arg_4_0[arg_4_1], arg_4_0[arg_4_1 + 1], arg_4_0[arg_4_1 + 2]
end
unpack_index[4] = function(arg_5_0, arg_5_1)
	return arg_5_0[arg_5_1], arg_5_0[arg_5_1 + 1], arg_5_0[arg_5_1 + 2], arg_5_0[arg_5_1 + 3]
end
unpack_index[5] = function(arg_6_0, arg_6_1)
	return arg_6_0[arg_6_1], arg_6_0[arg_6_1 + 1], arg_6_0[arg_6_1 + 2], arg_6_0[arg_6_1 + 3], arg_6_0[arg_6_1 + 4]
end
unpack_index[6] = function(arg_7_0, arg_7_1)
	return arg_7_0[arg_7_1], arg_7_0[arg_7_1 + 1], arg_7_0[arg_7_1 + 2], arg_7_0[arg_7_1 + 3], arg_7_0[arg_7_1 + 4], arg_7_0[arg_7_1 + 5]
end
unpack_index[7] = function(arg_8_0, arg_8_1)
	return arg_8_0[arg_8_1], arg_8_0[arg_8_1 + 1], arg_8_0[arg_8_1 + 2], arg_8_0[arg_8_1 + 3], arg_8_0[arg_8_1 + 4], arg_8_0[arg_8_1 + 5], arg_8_0[arg_8_1 + 6]
end
unpack_index[8] = function(arg_9_0, arg_9_1)
	return arg_9_0[arg_9_1], arg_9_0[arg_9_1 + 1], arg_9_0[arg_9_1 + 2], arg_9_0[arg_9_1 + 3], arg_9_0[arg_9_1 + 4], arg_9_0[arg_9_1 + 5], arg_9_0[arg_9_1 + 6], arg_9_0[arg_9_1 + 7]
end
unpack_index[9] = function(arg_10_0, arg_10_1)
	return arg_10_0[arg_10_1], arg_10_0[arg_10_1 + 1], arg_10_0[arg_10_1 + 2], arg_10_0[arg_10_1 + 3], arg_10_0[arg_10_1 + 4], arg_10_0[arg_10_1 + 5], arg_10_0[arg_10_1 + 6], arg_10_0[arg_10_1 + 7], arg_10_0[arg_10_1 + 8]
end
unpack_index[10] = function(arg_11_0, arg_11_1)
	return arg_11_0[arg_11_1], arg_11_0[arg_11_1 + 1], arg_11_0[arg_11_1 + 2], arg_11_0[arg_11_1 + 3], arg_11_0[arg_11_1 + 4], arg_11_0[arg_11_1 + 5], arg_11_0[arg_11_1 + 6], arg_11_0[arg_11_1 + 7], arg_11_0[arg_11_1 + 8], arg_11_0[arg_11_1 + 9]
end
unpack_index[11] = function(arg_12_0, arg_12_1)
	return arg_12_0[arg_12_1], arg_12_0[arg_12_1 + 1], arg_12_0[arg_12_1 + 2], arg_12_0[arg_12_1 + 3], arg_12_0[arg_12_1 + 4], arg_12_0[arg_12_1 + 5], arg_12_0[arg_12_1 + 6], arg_12_0[arg_12_1 + 7], arg_12_0[arg_12_1 + 8], arg_12_0[arg_12_1 + 9], arg_12_0[arg_12_1 + 10]
end
unpack_index[12] = function(arg_13_0, arg_13_1)
	return arg_13_0[arg_13_1], arg_13_0[arg_13_1 + 1], arg_13_0[arg_13_1 + 2], arg_13_0[arg_13_1 + 3], arg_13_0[arg_13_1 + 4], arg_13_0[arg_13_1 + 5], arg_13_0[arg_13_1 + 6], arg_13_0[arg_13_1 + 7], arg_13_0[arg_13_1 + 8], arg_13_0[arg_13_1 + 9], arg_13_0[arg_13_1 + 10], arg_13_0[arg_13_1 + 11]
end
unpack_index[13] = function(arg_14_0, arg_14_1)
	return arg_14_0[arg_14_1], arg_14_0[arg_14_1 + 1], arg_14_0[arg_14_1 + 2], arg_14_0[arg_14_1 + 3], arg_14_0[arg_14_1 + 4], arg_14_0[arg_14_1 + 5], arg_14_0[arg_14_1 + 6], arg_14_0[arg_14_1 + 7], arg_14_0[arg_14_1 + 8], arg_14_0[arg_14_1 + 9], arg_14_0[arg_14_1 + 10], arg_14_0[arg_14_1 + 11], arg_14_0[arg_14_1 + 12]
end
unpack_index[14] = function(arg_15_0, arg_15_1)
	return arg_15_0[arg_15_1], arg_15_0[arg_15_1 + 1], arg_15_0[arg_15_1 + 2], arg_15_0[arg_15_1 + 3], arg_15_0[arg_15_1 + 4], arg_15_0[arg_15_1 + 5], arg_15_0[arg_15_1 + 6], arg_15_0[arg_15_1 + 7], arg_15_0[arg_15_1 + 8], arg_15_0[arg_15_1 + 9], arg_15_0[arg_15_1 + 10], arg_15_0[arg_15_1 + 11], arg_15_0[arg_15_1 + 12], arg_15_0[arg_15_1 + 13]
end
unpack_index[15] = function(arg_16_0, arg_16_1)
	return arg_16_0[arg_16_1], arg_16_0[arg_16_1 + 1], arg_16_0[arg_16_1 + 2], arg_16_0[arg_16_1 + 3], arg_16_0[arg_16_1 + 4], arg_16_0[arg_16_1 + 5], arg_16_0[arg_16_1 + 6], arg_16_0[arg_16_1 + 7], arg_16_0[arg_16_1 + 8], arg_16_0[arg_16_1 + 9], arg_16_0[arg_16_1 + 10], arg_16_0[arg_16_1 + 11], arg_16_0[arg_16_1 + 12], arg_16_0[arg_16_1 + 13], arg_16_0[arg_16_1 + 14]
end
unpack_index[16] = function(arg_17_0, arg_17_1)
	return arg_17_0[arg_17_1], arg_17_0[arg_17_1 + 1], arg_17_0[arg_17_1 + 2], arg_17_0[arg_17_1 + 3], arg_17_0[arg_17_1 + 4], arg_17_0[arg_17_1 + 5], arg_17_0[arg_17_1 + 6], arg_17_0[arg_17_1 + 7], arg_17_0[arg_17_1 + 8], arg_17_0[arg_17_1 + 9], arg_17_0[arg_17_1 + 10], arg_17_0[arg_17_1 + 11], arg_17_0[arg_17_1 + 12], arg_17_0[arg_17_1 + 13], arg_17_0[arg_17_1 + 14], arg_17_0[arg_17_1 + 15]
end
unpack_index[17] = function(arg_18_0, arg_18_1)
	return arg_18_0[arg_18_1], arg_18_0[arg_18_1 + 1], arg_18_0[arg_18_1 + 2], arg_18_0[arg_18_1 + 3], arg_18_0[arg_18_1 + 4], arg_18_0[arg_18_1 + 5], arg_18_0[arg_18_1 + 6], arg_18_0[arg_18_1 + 7], arg_18_0[arg_18_1 + 8], arg_18_0[arg_18_1 + 9], arg_18_0[arg_18_1 + 10], arg_18_0[arg_18_1 + 11], arg_18_0[arg_18_1 + 12], arg_18_0[arg_18_1 + 13], arg_18_0[arg_18_1 + 14], arg_18_0[arg_18_1 + 15], arg_18_0[arg_18_1 + 16]
end
unpack_index[18] = function(arg_19_0, arg_19_1)
	return arg_19_0[arg_19_1], arg_19_0[arg_19_1 + 1], arg_19_0[arg_19_1 + 2], arg_19_0[arg_19_1 + 3], arg_19_0[arg_19_1 + 4], arg_19_0[arg_19_1 + 5], arg_19_0[arg_19_1 + 6], arg_19_0[arg_19_1 + 7], arg_19_0[arg_19_1 + 8], arg_19_0[arg_19_1 + 9], arg_19_0[arg_19_1 + 10], arg_19_0[arg_19_1 + 11], arg_19_0[arg_19_1 + 12], arg_19_0[arg_19_1 + 13], arg_19_0[arg_19_1 + 14], arg_19_0[arg_19_1 + 15], arg_19_0[arg_19_1 + 16], arg_19_0[arg_19_1 + 17]
end
unpack_index[19] = function(arg_20_0, arg_20_1)
	return arg_20_0[arg_20_1], arg_20_0[arg_20_1 + 1], arg_20_0[arg_20_1 + 2], arg_20_0[arg_20_1 + 3], arg_20_0[arg_20_1 + 4], arg_20_0[arg_20_1 + 5], arg_20_0[arg_20_1 + 6], arg_20_0[arg_20_1 + 7], arg_20_0[arg_20_1 + 8], arg_20_0[arg_20_1 + 9], arg_20_0[arg_20_1 + 10], arg_20_0[arg_20_1 + 11], arg_20_0[arg_20_1 + 12], arg_20_0[arg_20_1 + 13], arg_20_0[arg_20_1 + 14], arg_20_0[arg_20_1 + 15], arg_20_0[arg_20_1 + 16], arg_20_0[arg_20_1 + 17], arg_20_0[arg_20_1 + 18]
end
unpack_index[20] = function(arg_21_0, arg_21_1)
	return arg_21_0[arg_21_1], arg_21_0[arg_21_1 + 1], arg_21_0[arg_21_1 + 2], arg_21_0[arg_21_1 + 3], arg_21_0[arg_21_1 + 4], arg_21_0[arg_21_1 + 5], arg_21_0[arg_21_1 + 6], arg_21_0[arg_21_1 + 7], arg_21_0[arg_21_1 + 8], arg_21_0[arg_21_1 + 9], arg_21_0[arg_21_1 + 10], arg_21_0[arg_21_1 + 11], arg_21_0[arg_21_1 + 12], arg_21_0[arg_21_1 + 13], arg_21_0[arg_21_1 + 14], arg_21_0[arg_21_1 + 15], arg_21_0[arg_21_1 + 16], arg_21_0[arg_21_1 + 17], arg_21_0[arg_21_1 + 18], arg_21_0[arg_21_1 + 19]
end
pack_index = {}
pack_index[0] = function()
	return
end
pack_index[1] = function(arg_23_0, arg_23_1, arg_23_2)
	arg_23_0[arg_23_1] = arg_23_2
end
pack_index[2] = function(arg_24_0, arg_24_1, arg_24_2, arg_24_3)
	arg_24_0[arg_24_1] = arg_24_2
	arg_24_0[arg_24_1 + 1] = arg_24_3
end
pack_index[3] = function(arg_25_0, arg_25_1, arg_25_2, arg_25_3, arg_25_4)
	arg_25_0[arg_25_1] = arg_25_2
	arg_25_0[arg_25_1 + 1] = arg_25_3
	arg_25_0[arg_25_1 + 2] = arg_25_4
end
pack_index[4] = function(arg_26_0, arg_26_1, arg_26_2, arg_26_3, arg_26_4, arg_26_5)
	arg_26_0[arg_26_1] = arg_26_2
	arg_26_0[arg_26_1 + 1] = arg_26_3
	arg_26_0[arg_26_1 + 2] = arg_26_4
	arg_26_0[arg_26_1 + 3] = arg_26_5
end
pack_index[5] = function(arg_27_0, arg_27_1, arg_27_2, arg_27_3, arg_27_4, arg_27_5, arg_27_6)
	arg_27_0[arg_27_1] = arg_27_2
	arg_27_0[arg_27_1 + 1] = arg_27_3
	arg_27_0[arg_27_1 + 2] = arg_27_4
	arg_27_0[arg_27_1 + 3] = arg_27_5
	arg_27_0[arg_27_1 + 4] = arg_27_6
end
pack_index[6] = function(arg_28_0, arg_28_1, arg_28_2, arg_28_3, arg_28_4, arg_28_5, arg_28_6, arg_28_7)
	arg_28_0[arg_28_1] = arg_28_2
	arg_28_0[arg_28_1 + 1] = arg_28_3
	arg_28_0[arg_28_1 + 2] = arg_28_4
	arg_28_0[arg_28_1 + 3] = arg_28_5
	arg_28_0[arg_28_1 + 4] = arg_28_6
	arg_28_0[arg_28_1 + 5] = arg_28_7
end
pack_index[7] = function(arg_29_0, arg_29_1, arg_29_2, arg_29_3, arg_29_4, arg_29_5, arg_29_6, arg_29_7, arg_29_8)
	arg_29_0[arg_29_1] = arg_29_2
	arg_29_0[arg_29_1 + 1] = arg_29_3
	arg_29_0[arg_29_1 + 2] = arg_29_4
	arg_29_0[arg_29_1 + 3] = arg_29_5
	arg_29_0[arg_29_1 + 4] = arg_29_6
	arg_29_0[arg_29_1 + 5] = arg_29_7
	arg_29_0[arg_29_1 + 6] = arg_29_8
end
pack_index[8] = function(arg_30_0, arg_30_1, arg_30_2, arg_30_3, arg_30_4, arg_30_5, arg_30_6, arg_30_7, arg_30_8, arg_30_9)
	arg_30_0[arg_30_1] = arg_30_2
	arg_30_0[arg_30_1 + 1] = arg_30_3
	arg_30_0[arg_30_1 + 2] = arg_30_4
	arg_30_0[arg_30_1 + 3] = arg_30_5
	arg_30_0[arg_30_1 + 4] = arg_30_6
	arg_30_0[arg_30_1 + 5] = arg_30_7
	arg_30_0[arg_30_1 + 6] = arg_30_8
	arg_30_0[arg_30_1 + 7] = arg_30_9
end
pack_index[9] = function(arg_31_0, arg_31_1, arg_31_2, arg_31_3, arg_31_4, arg_31_5, arg_31_6, arg_31_7, arg_31_8, arg_31_9, arg_31_10)
	arg_31_0[arg_31_1] = arg_31_2
	arg_31_0[arg_31_1 + 1] = arg_31_3
	arg_31_0[arg_31_1 + 2] = arg_31_4
	arg_31_0[arg_31_1 + 3] = arg_31_5
	arg_31_0[arg_31_1 + 4] = arg_31_6
	arg_31_0[arg_31_1 + 5] = arg_31_7
	arg_31_0[arg_31_1 + 6] = arg_31_8
	arg_31_0[arg_31_1 + 7] = arg_31_9
	arg_31_0[arg_31_1 + 8] = arg_31_10
end
pack_index[10] = function(arg_32_0, arg_32_1, arg_32_2, arg_32_3, arg_32_4, arg_32_5, arg_32_6, arg_32_7, arg_32_8, arg_32_9, arg_32_10, arg_32_11)
	arg_32_0[arg_32_1] = arg_32_2
	arg_32_0[arg_32_1 + 1] = arg_32_3
	arg_32_0[arg_32_1 + 2] = arg_32_4
	arg_32_0[arg_32_1 + 3] = arg_32_5
	arg_32_0[arg_32_1 + 4] = arg_32_6
	arg_32_0[arg_32_1 + 5] = arg_32_7
	arg_32_0[arg_32_1 + 6] = arg_32_8
	arg_32_0[arg_32_1 + 7] = arg_32_9
	arg_32_0[arg_32_1 + 8] = arg_32_10
	arg_32_0[arg_32_1 + 9] = arg_32_11
end
pack_index[11] = function(arg_33_0, arg_33_1, arg_33_2, arg_33_3, arg_33_4, arg_33_5, arg_33_6, arg_33_7, arg_33_8, arg_33_9, arg_33_10, arg_33_11, arg_33_12)
	arg_33_0[arg_33_1] = arg_33_2
	arg_33_0[arg_33_1 + 1] = arg_33_3
	arg_33_0[arg_33_1 + 2] = arg_33_4
	arg_33_0[arg_33_1 + 3] = arg_33_5
	arg_33_0[arg_33_1 + 4] = arg_33_6
	arg_33_0[arg_33_1 + 5] = arg_33_7
	arg_33_0[arg_33_1 + 6] = arg_33_8
	arg_33_0[arg_33_1 + 7] = arg_33_9
	arg_33_0[arg_33_1 + 8] = arg_33_10
	arg_33_0[arg_33_1 + 9] = arg_33_11
	arg_33_0[arg_33_1 + 10] = arg_33_12
end
pack_index[12] = function(arg_34_0, arg_34_1, arg_34_2, arg_34_3, arg_34_4, arg_34_5, arg_34_6, arg_34_7, arg_34_8, arg_34_9, arg_34_10, arg_34_11, arg_34_12, arg_34_13)
	arg_34_0[arg_34_1] = arg_34_2
	arg_34_0[arg_34_1 + 1] = arg_34_3
	arg_34_0[arg_34_1 + 2] = arg_34_4
	arg_34_0[arg_34_1 + 3] = arg_34_5
	arg_34_0[arg_34_1 + 4] = arg_34_6
	arg_34_0[arg_34_1 + 5] = arg_34_7
	arg_34_0[arg_34_1 + 6] = arg_34_8
	arg_34_0[arg_34_1 + 7] = arg_34_9
	arg_34_0[arg_34_1 + 8] = arg_34_10
	arg_34_0[arg_34_1 + 9] = arg_34_11
	arg_34_0[arg_34_1 + 10] = arg_34_12
	arg_34_0[arg_34_1 + 11] = arg_34_13
end
pack_index[13] = function(arg_35_0, arg_35_1, arg_35_2, arg_35_3, arg_35_4, arg_35_5, arg_35_6, arg_35_7, arg_35_8, arg_35_9, arg_35_10, arg_35_11, arg_35_12, arg_35_13, arg_35_14)
	arg_35_0[arg_35_1] = arg_35_2
	arg_35_0[arg_35_1 + 1] = arg_35_3
	arg_35_0[arg_35_1 + 2] = arg_35_4
	arg_35_0[arg_35_1 + 3] = arg_35_5
	arg_35_0[arg_35_1 + 4] = arg_35_6
	arg_35_0[arg_35_1 + 5] = arg_35_7
	arg_35_0[arg_35_1 + 6] = arg_35_8
	arg_35_0[arg_35_1 + 7] = arg_35_9
	arg_35_0[arg_35_1 + 8] = arg_35_10
	arg_35_0[arg_35_1 + 9] = arg_35_11
	arg_35_0[arg_35_1 + 10] = arg_35_12
	arg_35_0[arg_35_1 + 11] = arg_35_13
	arg_35_0[arg_35_1 + 12] = arg_35_14
end
pack_index[14] = function(arg_36_0, arg_36_1, arg_36_2, arg_36_3, arg_36_4, arg_36_5, arg_36_6, arg_36_7, arg_36_8, arg_36_9, arg_36_10, arg_36_11, arg_36_12, arg_36_13, arg_36_14, arg_36_15)
	arg_36_0[arg_36_1] = arg_36_2
	arg_36_0[arg_36_1 + 1] = arg_36_3
	arg_36_0[arg_36_1 + 2] = arg_36_4
	arg_36_0[arg_36_1 + 3] = arg_36_5
	arg_36_0[arg_36_1 + 4] = arg_36_6
	arg_36_0[arg_36_1 + 5] = arg_36_7
	arg_36_0[arg_36_1 + 6] = arg_36_8
	arg_36_0[arg_36_1 + 7] = arg_36_9
	arg_36_0[arg_36_1 + 8] = arg_36_10
	arg_36_0[arg_36_1 + 9] = arg_36_11
	arg_36_0[arg_36_1 + 10] = arg_36_12
	arg_36_0[arg_36_1 + 11] = arg_36_13
	arg_36_0[arg_36_1 + 12] = arg_36_14
	arg_36_0[arg_36_1 + 13] = arg_36_15
end
pack_index[15] = function(arg_37_0, arg_37_1, arg_37_2, arg_37_3, arg_37_4, arg_37_5, arg_37_6, arg_37_7, arg_37_8, arg_37_9, arg_37_10, arg_37_11, arg_37_12, arg_37_13, arg_37_14, arg_37_15, arg_37_16)
	arg_37_0[arg_37_1] = arg_37_2
	arg_37_0[arg_37_1 + 1] = arg_37_3
	arg_37_0[arg_37_1 + 2] = arg_37_4
	arg_37_0[arg_37_1 + 3] = arg_37_5
	arg_37_0[arg_37_1 + 4] = arg_37_6
	arg_37_0[arg_37_1 + 5] = arg_37_7
	arg_37_0[arg_37_1 + 6] = arg_37_8
	arg_37_0[arg_37_1 + 7] = arg_37_9
	arg_37_0[arg_37_1 + 8] = arg_37_10
	arg_37_0[arg_37_1 + 9] = arg_37_11
	arg_37_0[arg_37_1 + 10] = arg_37_12
	arg_37_0[arg_37_1 + 11] = arg_37_13
	arg_37_0[arg_37_1 + 12] = arg_37_14
	arg_37_0[arg_37_1 + 13] = arg_37_15
	arg_37_0[arg_37_1 + 14] = arg_37_16
end
pack_index[16] = function(arg_38_0, arg_38_1, arg_38_2, arg_38_3, arg_38_4, arg_38_5, arg_38_6, arg_38_7, arg_38_8, arg_38_9, arg_38_10, arg_38_11, arg_38_12, arg_38_13, arg_38_14, arg_38_15, arg_38_16, arg_38_17)
	arg_38_0[arg_38_1] = arg_38_2
	arg_38_0[arg_38_1 + 1] = arg_38_3
	arg_38_0[arg_38_1 + 2] = arg_38_4
	arg_38_0[arg_38_1 + 3] = arg_38_5
	arg_38_0[arg_38_1 + 4] = arg_38_6
	arg_38_0[arg_38_1 + 5] = arg_38_7
	arg_38_0[arg_38_1 + 6] = arg_38_8
	arg_38_0[arg_38_1 + 7] = arg_38_9
	arg_38_0[arg_38_1 + 8] = arg_38_10
	arg_38_0[arg_38_1 + 9] = arg_38_11
	arg_38_0[arg_38_1 + 10] = arg_38_12
	arg_38_0[arg_38_1 + 11] = arg_38_13
	arg_38_0[arg_38_1 + 12] = arg_38_14
	arg_38_0[arg_38_1 + 13] = arg_38_15
	arg_38_0[arg_38_1 + 14] = arg_38_16
	arg_38_0[arg_38_1 + 15] = arg_38_17
end
pack_index[17] = function(arg_39_0, arg_39_1, arg_39_2, arg_39_3, arg_39_4, arg_39_5, arg_39_6, arg_39_7, arg_39_8, arg_39_9, arg_39_10, arg_39_11, arg_39_12, arg_39_13, arg_39_14, arg_39_15, arg_39_16, arg_39_17, arg_39_18)
	arg_39_0[arg_39_1] = arg_39_2
	arg_39_0[arg_39_1 + 1] = arg_39_3
	arg_39_0[arg_39_1 + 2] = arg_39_4
	arg_39_0[arg_39_1 + 3] = arg_39_5
	arg_39_0[arg_39_1 + 4] = arg_39_6
	arg_39_0[arg_39_1 + 5] = arg_39_7
	arg_39_0[arg_39_1 + 6] = arg_39_8
	arg_39_0[arg_39_1 + 7] = arg_39_9
	arg_39_0[arg_39_1 + 8] = arg_39_10
	arg_39_0[arg_39_1 + 9] = arg_39_11
	arg_39_0[arg_39_1 + 10] = arg_39_12
	arg_39_0[arg_39_1 + 11] = arg_39_13
	arg_39_0[arg_39_1 + 12] = arg_39_14
	arg_39_0[arg_39_1 + 13] = arg_39_15
	arg_39_0[arg_39_1 + 14] = arg_39_16
	arg_39_0[arg_39_1 + 15] = arg_39_17
	arg_39_0[arg_39_1 + 16] = arg_39_18
end
pack_index[18] = function(arg_40_0, arg_40_1, arg_40_2, arg_40_3, arg_40_4, arg_40_5, arg_40_6, arg_40_7, arg_40_8, arg_40_9, arg_40_10, arg_40_11, arg_40_12, arg_40_13, arg_40_14, arg_40_15, arg_40_16, arg_40_17, arg_40_18, arg_40_19)
	arg_40_0[arg_40_1] = arg_40_2
	arg_40_0[arg_40_1 + 1] = arg_40_3
	arg_40_0[arg_40_1 + 2] = arg_40_4
	arg_40_0[arg_40_1 + 3] = arg_40_5
	arg_40_0[arg_40_1 + 4] = arg_40_6
	arg_40_0[arg_40_1 + 5] = arg_40_7
	arg_40_0[arg_40_1 + 6] = arg_40_8
	arg_40_0[arg_40_1 + 7] = arg_40_9
	arg_40_0[arg_40_1 + 8] = arg_40_10
	arg_40_0[arg_40_1 + 9] = arg_40_11
	arg_40_0[arg_40_1 + 10] = arg_40_12
	arg_40_0[arg_40_1 + 11] = arg_40_13
	arg_40_0[arg_40_1 + 12] = arg_40_14
	arg_40_0[arg_40_1 + 13] = arg_40_15
	arg_40_0[arg_40_1 + 14] = arg_40_16
	arg_40_0[arg_40_1 + 15] = arg_40_17
	arg_40_0[arg_40_1 + 16] = arg_40_18
	arg_40_0[arg_40_1 + 17] = arg_40_19
end
pack_index[19] = function(arg_41_0, arg_41_1, arg_41_2, arg_41_3, arg_41_4, arg_41_5, arg_41_6, arg_41_7, arg_41_8, arg_41_9, arg_41_10, arg_41_11, arg_41_12, arg_41_13, arg_41_14, arg_41_15, arg_41_16, arg_41_17, arg_41_18, arg_41_19, arg_41_20)
	arg_41_0[arg_41_1] = arg_41_2
	arg_41_0[arg_41_1 + 1] = arg_41_3
	arg_41_0[arg_41_1 + 2] = arg_41_4
	arg_41_0[arg_41_1 + 3] = arg_41_5
	arg_41_0[arg_41_1 + 4] = arg_41_6
	arg_41_0[arg_41_1 + 5] = arg_41_7
	arg_41_0[arg_41_1 + 6] = arg_41_8
	arg_41_0[arg_41_1 + 7] = arg_41_9
	arg_41_0[arg_41_1 + 8] = arg_41_10
	arg_41_0[arg_41_1 + 9] = arg_41_11
	arg_41_0[arg_41_1 + 10] = arg_41_12
	arg_41_0[arg_41_1 + 11] = arg_41_13
	arg_41_0[arg_41_1 + 12] = arg_41_14
	arg_41_0[arg_41_1 + 13] = arg_41_15
	arg_41_0[arg_41_1 + 14] = arg_41_16
	arg_41_0[arg_41_1 + 15] = arg_41_17
	arg_41_0[arg_41_1 + 16] = arg_41_18
	arg_41_0[arg_41_1 + 17] = arg_41_19
	arg_41_0[arg_41_1 + 18] = arg_41_20
end
pack_index[20] = function(arg_42_0, arg_42_1, arg_42_2, arg_42_3, arg_42_4, arg_42_5, arg_42_6, arg_42_7, arg_42_8, arg_42_9, arg_42_10, arg_42_11, arg_42_12, arg_42_13, arg_42_14, arg_42_15, arg_42_16, arg_42_17, arg_42_18, arg_42_19, arg_42_20, arg_42_21)
	arg_42_0[arg_42_1] = arg_42_2
	arg_42_0[arg_42_1 + 1] = arg_42_3
	arg_42_0[arg_42_1 + 2] = arg_42_4
	arg_42_0[arg_42_1 + 3] = arg_42_5
	arg_42_0[arg_42_1 + 4] = arg_42_6
	arg_42_0[arg_42_1 + 5] = arg_42_7
	arg_42_0[arg_42_1 + 6] = arg_42_8
	arg_42_0[arg_42_1 + 7] = arg_42_9
	arg_42_0[arg_42_1 + 8] = arg_42_10
	arg_42_0[arg_42_1 + 9] = arg_42_11
	arg_42_0[arg_42_1 + 10] = arg_42_12
	arg_42_0[arg_42_1 + 11] = arg_42_13
	arg_42_0[arg_42_1 + 12] = arg_42_14
	arg_42_0[arg_42_1 + 13] = arg_42_15
	arg_42_0[arg_42_1 + 14] = arg_42_16
	arg_42_0[arg_42_1 + 15] = arg_42_17
	arg_42_0[arg_42_1 + 16] = arg_42_18
	arg_42_0[arg_42_1 + 17] = arg_42_19
	arg_42_0[arg_42_1 + 18] = arg_42_20
	arg_42_0[arg_42_1 + 19] = arg_42_21
end
