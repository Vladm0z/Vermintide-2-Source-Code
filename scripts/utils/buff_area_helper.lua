-- chunkname: @scripts/utils/buff_area_helper.lua

local var_0_0 = BuffAreaHelper or {}

function var_0_0.setup_range_check(arg_1_0, arg_1_1, arg_1_2, arg_1_3)
	arg_1_1.range_check = {
		update_time = 0,
		units_in_range = {},
		temp_new_units_in_range = {}
	}
end

function var_0_0.update_range_check(arg_2_0, arg_2_1, arg_2_2, arg_2_3)
	local var_2_0 = arg_2_1.template
	local var_2_1 = var_2_0.range_check

	if var_2_1.server_only and not Managers.state.network.is_server then
		return
	end

	local var_2_2 = arg_2_1.range_check

	if var_2_2.update_time < arg_2_2.t then
		var_2_2.update_time = arg_2_2.t + var_2_1.update_rate

		local var_2_3 = var_2_0.custom_radius and arg_2_1.radius or var_2_1.radius
		local var_2_4 = var_2_2.units_in_range
		local var_2_5 = var_2_1.unit_entered_range_func
		local var_2_6 = var_2_1.unit_left_range_func
		local var_2_7 = var_2_2.temp_new_units_in_range
		local var_2_8 = #var_2_7
		local var_2_9 = POSITION_LOOKUP[arg_2_0] or Unit.world_position(arg_2_0, 0)
		local var_2_10 = 0
		local var_2_11 = Managers.state.side.side_by_unit[arg_2_0] or Managers.state.side:get_side_from_name("heroes")

		if not var_2_1.only_players then
			var_2_10 = AiUtils.broadphase_query(var_2_9, var_2_3, var_2_7, var_2_11.enemy_broadphase_categories)
		end

		if not var_2_1.only_ai then
			local var_2_12 = var_2_11.PLAYER_AND_BOT_POSITIONS

			for iter_2_0 = 1, #var_2_12 do
				local var_2_13 = var_2_12[iter_2_0]

				if math.pow(var_2_3, 2) >= Vector3.distance_squared(var_2_9, var_2_13) then
					var_2_10 = var_2_10 + 1
					var_2_7[var_2_10] = var_2_11.PLAYER_AND_BOT_UNITS[iter_2_0]
				end
			end
		end

		for iter_2_1 = var_2_10 + 1, var_2_8 do
			var_2_7[iter_2_1] = nil
		end

		if var_2_0.randomize_result then
			table.shuffle(var_2_7)
		end

		local var_2_14 = var_2_5 and BuffFunctionTemplates.functions[var_2_5]

		for iter_2_2, iter_2_3 in ipairs(var_2_7) do
			if not var_2_4[iter_2_3] then
				local var_2_15 = true

				if var_2_14 then
					var_2_15 = var_2_14(iter_2_3, arg_2_0, arg_2_1, arg_2_2, arg_2_3) or true
				end

				var_2_4[iter_2_3] = var_2_15
			end
		end

		local var_2_16 = var_2_6 and BuffFunctionTemplates.functions[var_2_6]

		for iter_2_4, iter_2_5 in pairs(var_2_4) do
			if not table.contains(var_2_7, iter_2_4) then
				if var_2_16 then
					local var_2_17 = var_2_4[iter_2_4]

					var_2_16(iter_2_4, var_2_17, arg_2_0, arg_2_1, arg_2_2, arg_2_3)
				end

				var_2_4[iter_2_4] = nil
			end
		end

		return true
	end

	return false
end

function var_0_0.destroy_range_check(arg_3_0, arg_3_1, arg_3_2, arg_3_3)
	local var_3_0 = arg_3_1.template.range_check
	local var_3_1 = arg_3_1.range_check
	local var_3_2 = var_3_0.unit_left_range_func

	if not var_3_2 then
		return
	end

	local var_3_3 = BuffFunctionTemplates.functions[var_3_2]

	for iter_3_0, iter_3_1 in pairs(var_3_1.units_in_range) do
		var_3_3(iter_3_0, iter_3_1, arg_3_0, arg_3_1, arg_3_2, arg_3_3)
	end
end

return var_0_0
