-- chunkname: @scripts/utils/input_helper.lua

InputUtils = InputUtils or {}

function InputUtils.keymaps_key_approved(arg_1_0)
	local var_1_0 = PLATFORM

	if IS_WINDOWS then
		return (arg_1_0 == var_1_0 or arg_1_0 == "xb1" or arg_1_0 == "ps_pad") and true or nil
	elseif IS_XB1 then
		return (arg_1_0 == var_1_0 or arg_1_0 == "win32") and true or nil
	else
		return arg_1_0 == var_1_0 and true or nil
	end
end

function InputUtils.get_platform_keymaps(arg_2_0, arg_2_1)
	return arg_2_0[arg_2_1 or PLATFORM]
end

function InputUtils.get_platform_filters(arg_3_0, arg_3_1)
	return arg_3_0[arg_3_1 or PLATFORM]
end
