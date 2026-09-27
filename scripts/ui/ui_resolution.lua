-- chunkname: @scripts/ui/ui_resolution.lua

local round = math.round

local function fn(self, arg_1_1, arg_1_2)
	-- function 1
	if not arg_1_2 then
		local Vector3 = Vector3
		local var_1_1 = round(self[1] * arg_1_1)
		local var_1_2 = round(self[2] * arg_1_1)
		local var_1_3 = self[3]

		var_1_3 = var_1_3 or 0

		return Vector3(var_1_1, var_1_2, var_1_3)
	else
		local Vector3_2 = Vector3
		local num = self[1] * arg_1_1
		local num_2 = self[2] * arg_1_1
		local var_1_7 = self[3]

		var_1_7 = var_1_7 or 0

		return Vector3_2(num, num_2, var_1_7)
	end
end

function UIScaleVectorToResolution(arg_2_0, arg_2_1)
	-- function 2
	return fn(arg_2_0, RESOLUTION_LOOKUP.scale, arg_2_1)
end

function UIInverseScaleVectorToResolution(arg_3_0, arg_3_1)
	-- function 3
	return fn(arg_3_0, RESOLUTION_LOOKUP.inv_scale, arg_3_1)
end

function UIScaleVectorToResolutionRealCoordinates(self)
	-- function 4
	local scale = RESOLUTION_LOOKUP.scale
	local Vector3 = Vector3
	local num = self[1] * scale
	local var_4_3 = self[2]

	var_4_3 = var_4_3 or 0

	return Vector3(num, var_4_3, self[3] * scale)
end
