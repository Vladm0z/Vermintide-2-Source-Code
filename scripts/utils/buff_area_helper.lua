-- chunkname: @scripts/utils/buff_area_helper.lua

local BuffAreaHelper = BuffAreaHelper

BuffAreaHelper = BuffAreaHelper or {}

BuffAreaHelper.setup_range_check = function (arg_1_0, arg_1_1, arg_1_2, arg_1_3)
	-- function 1
	arg_1_1.range_check = {
		update_time = 0,
		units_in_range = {},
		temp_new_units_in_range = {}
	}
end

BuffAreaHelper.update_range_check = function (arg_2_0, arg_2_1, arg_2_2, arg_2_3)
	-- function 2
	local template = arg_2_1.template
	local range_check = template.range_check

	if not (not range_check.server_only and Managers.state.network.is_server) then
		return
	end

	local range_check_2 = arg_2_1.range_check

	if range_check_2.update_time < arg_2_2.t then
		range_check_2.update_time = arg_2_2.t + range_check.update_rate

		local radius

		if not template.custom_radius then
			radius = arg_2_1.radius

			if not radius then
				-- Nothing
			end
		end

		radius = range_check.radius

		::label_2_0::

		local units_in_range = range_check_2.units_in_range
		local unit_entered_range_func = range_check.unit_entered_range_func
		local unit_left_range_func = range_check.unit_left_range_func
		local temp_new_units_in_range = range_check_2.temp_new_units_in_range
		local count = #temp_new_units_in_range
		local var_2_9 = POSITION_LOOKUP[arg_2_0]

		var_2_9 = var_2_9 or Unit.world_position(arg_2_0, 0)

		local num = 0
		local var_2_11 = Managers.state.side.side_by_unit[arg_2_0]

		var_2_11 = var_2_11 or Managers.state.side:get_side_from_name("heroes")

		if not range_check.only_players then
			num = AiUtils.broadphase_query(var_2_9, radius, temp_new_units_in_range, var_2_11.enemy_broadphase_categories)
		end

		if not range_check.only_ai then
			local PLAYER_AND_BOT_POSITIONS = var_2_11.PLAYER_AND_BOT_POSITIONS

			for i = 1, #PLAYER_AND_BOT_POSITIONS do
				local var_2_13 = PLAYER_AND_BOT_POSITIONS[i]

				if math.pow(radius, 2) >= Vector3.distance_squared(var_2_9, var_2_13) then
					num = num + 1
					temp_new_units_in_range[num] = var_2_11.PLAYER_AND_BOT_UNITS[i]
				end
			end
		end

		for j = num + 1, count do
			temp_new_units_in_range[j] = nil
		end

		if not template.randomize_result then
			table.shuffle(temp_new_units_in_range)
		end

		local flag = not unit_entered_range_func and BuffFunctionTemplates.functions[unit_entered_range_func]

		for i_2, v in ipairs(temp_new_units_in_range) do
			if not units_in_range[v] then
				local flag_2 = true

				if not flag then
					flag_2 = flag(v, arg_2_0, arg_2_1, arg_2_2, arg_2_3) or true
				end

				units_in_range[v] = flag_2
			end
		end

		local flag_3 = not unit_left_range_func and BuffFunctionTemplates.functions[unit_left_range_func]

		for k, v_2 in pairs(units_in_range) do
			if not table.contains(temp_new_units_in_range, k) then
				if not flag_3 then
					local var_2_17 = units_in_range[k]

					flag_3(k, var_2_17, arg_2_0, arg_2_1, arg_2_2, arg_2_3)
				end

				units_in_range[k] = nil
			end
		end

		return true
	end

	return false
end

BuffAreaHelper.destroy_range_check = function (arg_3_0, arg_3_1, arg_3_2, arg_3_3)
	-- function 3
	local range_check = arg_3_1.template.range_check
	local range_check_2 = arg_3_1.range_check
	local unit_left_range_func = range_check.unit_left_range_func

	if not unit_left_range_func then
		return
	end

	local var_3_3 = BuffFunctionTemplates.functions[unit_left_range_func]

	for k, v in pairs(range_check_2.units_in_range) do
		var_3_3(k, v, arg_3_0, arg_3_1, arg_3_2, arg_3_3)
	end
end

return BuffAreaHelper
