-- chunkname: @scripts/ui/cutscene_overlay_templates/cutscene_utils.lua

local var_0_0 = {}

function _convert_string_timestamp_to_seconds(arg_1_0)
	local var_1_0, var_1_1, var_1_2 = string.match(arg_1_0, "(%d+)%:(%d+)%:(%d+)")

	return var_1_0 * 60 + var_1_1 + var_1_2 * 0.01
end

function var_0_0.convert_string_timestamps_to_seconds(arg_2_0)
	for iter_2_0, iter_2_1 in pairs(arg_2_0) do
		for iter_2_2, iter_2_3 in ipairs(iter_2_1) do
			local var_2_0 = iter_2_3.start_timestamp
			local var_2_1 = iter_2_3.end_timestamp
			local var_2_2 = _convert_string_timestamp_to_seconds(var_2_0)
			local var_2_3 = _convert_string_timestamp_to_seconds(var_2_1)

			iter_2_3.duration = var_2_3 - var_2_2
			iter_2_3.start_time = var_2_2
			iter_2_3.end_time = var_2_3
		end
	end
end

return var_0_0
