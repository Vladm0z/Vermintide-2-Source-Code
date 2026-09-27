-- chunkname: @scripts/ui/cutscene_overlay_templates/cutscene_utils.lua

local tbl = {}

function _convert_string_timestamp_to_seconds(arg_1_0)
	-- function 1
	local match, var_1_1, var_1_2 = string.match(arg_1_0, "(%d+)%:(%d+)%:(%d+)")

	return match * 60 + var_1_1 + var_1_2 * 0.01
end

tbl.convert_string_timestamps_to_seconds = function (arg_2_0)
	-- function 2
	for k, v in pairs(arg_2_0) do
		for i, v_2 in ipairs(v) do
			local start_timestamp = v_2.start_timestamp
			local end_timestamp = v_2.end_timestamp
			local var_2_2 = _convert_string_timestamp_to_seconds(start_timestamp)
			local var_2_3 = _convert_string_timestamp_to_seconds(end_timestamp)

			v_2.duration = var_2_3 - var_2_2
			v_2.start_time = var_2_2
			v_2.end_time = var_2_3
		end
	end
end

return tbl
