-- chunkname: @scripts/ui/ui_resolution.lua

local var_0_0 = math.round

local function var_0_1(arg_1_0, arg_1_1, arg_1_2)
	if arg_1_2 then
		return Vector3(var_0_0(arg_1_0[1] * arg_1_1), var_0_0(arg_1_0[2] * arg_1_1), arg_1_0[3] or 0)
	else
		return Vector3(arg_1_0[1] * arg_1_1, arg_1_0[2] * arg_1_1, arg_1_0[3] or 0)
	end
end

function UIScaleVectorToResolution(arg_2_0, arg_2_1)
	return var_0_1(arg_2_0, RESOLUTION_LOOKUP.scale, arg_2_1)
end

function UIInverseScaleVectorToResolution(arg_3_0, arg_3_1)
	return var_0_1(arg_3_0, RESOLUTION_LOOKUP.inv_scale, arg_3_1)
end

function UIScaleVectorToResolutionRealCoordinates(arg_4_0)
	local var_4_0 = RESOLUTION_LOOKUP.scale

	return Vector3(arg_4_0[1] * var_4_0, arg_4_0[2] or 0, arg_4_0[3] * var_4_0)
end
