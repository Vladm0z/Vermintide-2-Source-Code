-- chunkname: @scripts/entity_system/systems/behaviour/utility/utility.lua

require("scripts/entity_system/systems/behaviour/utility/utility_considerations")

local Utility = Utility

Utility = Utility or {}
Utility = Utility

local Utility_2 = Utility

Utility_2.GetUtilityValueFromSpline = function (self, arg_1_1)
	-- function 1
	for i = 3, #self, 2 do
		if arg_1_1 <= self[i] then
			local var_1_0 = self[i]
			local var_1_1 = self[i + 1]
			local var_1_2 = self[i - 2]

			return (var_1_1 - self[i - 1]) / (var_1_0 - var_1_2) * (arg_1_1 - var_1_0) + var_1_1
		end
	end

	return self[#self]
end

Utility_2.get_action_utility = function (self, arg_2_1, arg_2_2, arg_2_3)
	-- function 2
	local num = 1
	local var_2_1 = arg_2_2.utility_actions[arg_2_1]
	local GetUtilityValueFromSpline = Utility_2.GetUtilityValueFromSpline
	local considerations = self.considerations

	for k, v in pairs(considerations) do
		local blackboard_input = v.blackboard_input
		local var_2_5 = var_2_1[blackboard_input]

		var_2_5 = var_2_5 or arg_2_2[blackboard_input]

		local num_2 = 0

		if not v.is_condition then
			local invert = v.invert

			num_2 = not var_2_5 and not invert and 0 and 1 or not invert and 1 and 0
		else
			local min_value = v.min_value

			min_value = min_value or 0

			local clamp = math.clamp((var_2_5 - min_value) / (v.max_value - min_value), 0, 1)

			num_2 = GetUtilityValueFromSpline(v.spline, clamp)
		end

		if num_2 <= 0 then
			return 0
		end

		num = num * num_2
	end

	return num * self.action_weight
end
