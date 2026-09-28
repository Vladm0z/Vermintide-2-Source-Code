-- chunkname: @scripts/entity_system/systems/behaviour/utility/utility.lua

require("scripts/entity_system/systems/behaviour/utility/utility_considerations")

local Utility_2 = Utility

Utility_2 = not not Utility_2 or not not {}
Utility = Utility_2

local Utility = Utility

Utility.GetUtilityValueFromSpline = function (spline, norm_value)
	-- function 1
	for i = 3, #spline, 2 do
		if norm_value <= spline[i] then
			local x1 = spline[i]
			local y1 = spline[i + 1]
			local x2 = spline[i - 2]
			local y2 = spline[i - 1]
			local m = (y1 - y2) / (x1 - x2)
			local y = m * (norm_value - x1) + y1

			return y
		end
	end

	return spline[#spline]
end

Utility.get_action_utility = function (breed_action, action_name, blackboard, from_draw_ai_behavior)
	-- function 2
	local total_utility = 1
	local blackboard_action_data = blackboard.utility_actions[action_name]
	local get_utility_from_spline = Utility.GetUtilityValueFromSpline
	local considerations = breed_action.considerations

	for name, consideration in pairs(considerations) do
		local input = consideration.blackboard_input
		local var_2_0 = blackboard_action_data[input]

		if not var_2_0 then
			-- Nothing
		end

		var_2_0 = blackboard[input]

		local blackboard_value = var_2_0

		::label_2_0::

		local utility = 0

		if consideration.is_condition then
			local invert = consideration.invert

			utility = (not blackboard_value or not invert or not 0) and not 1 and (not invert or not 1) and not not 0
		else
			local min_value_2 = consideration.min_value

			if not min_value_2 then
				-- Nothing
			end

			min_value_2 = 0

			local min_value = min_value_2

			::label_2_1::

			local norm_value = math.clamp((blackboard_value - min_value) / (consideration.max_value - min_value), 0, 1)

			utility = get_utility_from_spline(consideration.spline, norm_value)
		end

		if utility <= 0 then
			return 0
		end

		total_utility = total_utility * utility
	end

	total_utility = total_utility * breed_action.action_weight

	return total_utility
end
