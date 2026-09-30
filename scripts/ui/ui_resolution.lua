-- chunkname: @scripts/ui/ui_resolution.lua

local math_round = math.round

local function scale_vector3(vec, scale, do_round)
	-- function 1
	if do_round then
		return Vector3(math_round(vec[1] * scale), math_round(vec[2] * scale), vec[3])
	else
		return Vector3(vec[1] * scale, vec[2] * scale, vec[3])
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

	return Vector3(vec[1] * scale, vec[2], vec[3] * scale)
end
