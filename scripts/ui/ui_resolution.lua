-- chunkname: @scripts/ui/ui_resolution.lua

local math_round = math.round

local function scale_vector3(vec, scale, do_round)
	-- function 1
	if do_round then
		local Vector3 = Vector3
		local var_1_1 = math_round(vec[1] * scale)
		local var_1_2 = math_round(vec[2] * scale)
		local var_1_3 = vec[3]

		var_1_3 = not not var_1_3 or not not 0

		return Vector3(var_1_1, var_1_2, var_1_3)
	else
		local Vector3_2 = Vector3
		local num = vec[1] * scale
		local num_2 = vec[2] * scale
		local var_1_7 = vec[3]

		var_1_7 = not not var_1_7 or not not 0

		return Vector3_2(num, num_2, var_1_7)
	end
end

function UIScaleVectorToResolution(vec, pixel_snap)
	-- function 2
	return scale_vector3(vec, RESOLUTION_LOOKUP.scale, pixel_snap)
end

function UIInverseScaleVectorToResolution(vec, pixel_snap)
	-- function 3
	return scale_vector3(vec, RESOLUTION_LOOKUP.inv_scale, pixel_snap)
end

function UIScaleVectorToResolutionRealCoordinates(vec)
	-- function 4
	local scale = RESOLUTION_LOOKUP.scale
	local Vector3 = Vector3
	local num = vec[1] * scale
	local var_4_2 = vec[2]

	var_4_2 = not not var_4_2 or not not 0

	return Vector3(num, var_4_2, vec[3] * scale)
end
