-- chunkname: @core/wwise/lua/wwise_bank_reference.lua

WwiseBankReference = WwiseBankReference or {}

local function var_0_0(arg_1_0)
	if not arg_1_0.references then
		arg_1_0.references = {}
	end
end

WwiseBankReference.add = function (arg_2_0, arg_2_1)
	var_0_0(arg_2_0)

	arg_2_0.references[arg_2_1] = (arg_2_0.references[arg_2_1] or 0) + 1
end

WwiseBankReference.remove = function (arg_3_0, arg_3_1)
	var_0_0(arg_3_0)

	if (arg_3_0.references[arg_3_1] or 0) - 1 <= 0 then
		arg_3_0.references[arg_3_1] = nil
	end
end

WwiseBankReference.count = function (arg_4_0, arg_4_1)
	var_0_0(arg_4_0)

	return arg_4_0.references[arg_4_1] or 0
end

return WwiseBankReference
