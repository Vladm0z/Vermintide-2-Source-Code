-- chunkname: @scripts/unit_extensions/default_player_unit/buffs/buff_function_templates.lua

local var_0_0 = require("scripts/unit_extensions/default_player_unit/buffs/settings/buff_perk_names")

BuffFunctionTemplates = BuffFunctionTemplates or {}

local var_0_1 = Unit.is_frozen
local var_0_2 = {}

local function var_0_3(arg_1_0, arg_1_1)
	fassert(#arg_1_0 > 0, "movement_setting_exists needs at least a movement_setting_to_modify")

	local var_1_0 = PlayerUnitMovementSettings.get_movement_settings_table(arg_1_1)

	for iter_1_0, iter_1_1 in ipairs(arg_1_0) do
		var_1_0 = var_1_0[iter_1_1]

		if not var_1_0 then
			break
		end
	end

	if var_1_0 then
		return var_1_0
	else
		ferror("Variable does not exist in PlayerUnitMovementSettings")
	end
end

local function var_0_4(arg_2_0, arg_2_1, arg_2_2)
	local var_2_0 = #arg_2_0

	fassert(var_2_0 > 0, "movement_setting_exists needs at least a movement_setting_to_modify")

	local var_2_1 = PlayerUnitMovementSettings.get_movement_settings_table(arg_2_1)
	local var_2_2 = 1

	while var_2_2 <= var_2_0 do
		if var_2_0 < var_2_2 + 1 then
			var_2_1[arg_2_0[var_2_2]] = arg_2_2
		else
			var_2_1 = var_2_1[arg_2_0[var_2_2]]
		end

		var_2_2 = var_2_2 + 1
	end
end

local var_0_5 = {}
local var_0_6 = {}

local function var_0_7(arg_3_0)
	local var_3_0 = Managers.player:owner(arg_3_0)

	return var_3_0 and not var_3_0.remote
end

local function var_0_8(arg_4_0)
	local var_4_0 = Managers.player:owner(arg_4_0)

	return var_4_0 and var_4_0.bot_player
end

local function var_0_9()
	return Managers.state.network.is_server
end

local function var_0_10(arg_6_0)
	local var_6_0 = Managers.player:owner(arg_6_0)

	return var_6_0 and (var_6_0.remote or var_6_0.bot_player) or false
end

local function var_0_11(arg_7_0, arg_7_1, arg_7_2, arg_7_3, arg_7_4)
	local var_7_0 = Managers.state.unit_storage:go_id(arg_7_0)
	local var_7_1 = Managers.state.network:game()
	local var_7_2 = GameSession.game_object_field(var_7_1, var_7_0, "aim_direction")
	local var_7_3 = POSITION_LOOKUP[arg_7_0]
	local var_7_4 = POSITION_LOOKUP[arg_7_1]
	local var_7_5 = Vector3.flat(var_7_4 - var_7_3)
	local var_7_6, var_7_7 = Vector3.direction_length(var_7_5)

	if var_7_7 < math.epsilon then
		return true, 1
	end

	return Vector3.dot(var_7_2, var_7_6) > math.cos(math.pi * 0.6666666666666666)
end

BuffFunctionTemplates.functions = {
	heal_owner = function (arg_8_0, arg_8_1, arg_8_2)
		local var_8_0 = arg_8_1.template.heal_amount
		local var_8_1 = arg_8_1.template.heal_type

		if var_0_9() then
			DamageUtils.heal_network(arg_8_0, arg_8_0, var_8_0, var_8_1)
		else
			local var_8_2 = Managers.state.network
			local var_8_3 = var_8_2:unit_game_object_id(arg_8_0)
			local var_8_4 = NetworkLookup.heal_types[var_8_1]

			var_8_2.network_transmit:send_rpc_server("rpc_request_heal", var_8_3, var_8_0, var_8_4)
		end
	end,
	apply_action_lerp_movement_buff = function (arg_9_0, arg_9_1, arg_9_2)
		local var_9_0 = arg_9_2.bonus
		local var_9_1 = arg_9_2.multiplier

		if var_9_0 then
			arg_9_1.current_lerped_value = 0
		end

		if var_9_1 then
			arg_9_1.current_lerped_multiplier = 1
		end
	end,
	update_action_lerp_movement_buff = function (arg_10_0, arg_10_1, arg_10_2)
		local var_10_0 = arg_10_2.bonus
		local var_10_1 = arg_10_2.multiplier
		local var_10_2 = arg_10_2.time_into_buff
		local var_10_3
		local var_10_4
		local var_10_5
		local var_10_6
		local var_10_7 = math.min(1, var_10_2 / arg_10_1.template.lerp_time)

		if var_10_0 then
			local var_10_8 = math.lerp(0, var_10_0, var_10_7)

			var_10_3 = arg_10_1.current_lerped_value
			arg_10_1.current_lerped_value = var_10_8
			var_10_4 = var_10_8
		end

		if var_10_1 then
			local var_10_9 = math.lerp(1, var_10_1, var_10_7)

			var_10_5 = arg_10_1.current_lerped_multiplier
			arg_10_1.current_lerped_multiplier = var_10_9
			var_10_6 = var_10_9
		end

		if var_10_4 or var_10_6 then
			if arg_10_1.has_added_movement_previous_turn then
				buff_extension_function_params.value = var_10_3
				buff_extension_function_params.multiplier = var_10_5

				BuffFunctionTemplates.functions.remove_movement_buff(arg_10_0, arg_10_1, buff_extension_function_params)
			end

			arg_10_1.has_added_movement_previous_turn = true
			buff_extension_function_params.value = var_10_4
			buff_extension_function_params.multiplier = var_10_6

			BuffFunctionTemplates.functions.apply_movement_buff(arg_10_0, arg_10_1, buff_extension_function_params)
		end
	end,
	remove_action_lerp_movement_buff = function (arg_11_0, arg_11_1, arg_11_2)
		local var_11_0 = ScriptUnit.extension(arg_11_0, "buff_system")

		table.clear(var_0_5)

		var_0_5.external_optional_duration = nil
		var_0_5.external_optional_bonus = arg_11_1.current_lerped_value
		var_0_5.external_optional_multiplier = arg_11_1.current_lerped_multiplier

		var_11_0:add_buff(arg_11_1.template.remove_buff_name, var_0_5)
	end,
	apply_action_lerp_remove_movement_buff = function (arg_12_0, arg_12_1, arg_12_2)
		local var_12_0 = arg_12_2.bonus
		local var_12_1 = arg_12_2.multiplier

		if var_12_0 then
			arg_12_1.current_lerped_value = var_12_0
		end

		if var_12_1 then
			arg_12_1.current_lerped_multiplier = var_12_1
		end

		arg_12_1.last_frame_percentage = 1
	end,
	update_action_lerp_remove_movement_buff = function (arg_13_0, arg_13_1, arg_13_2)
		local var_13_0 = arg_13_2.bonus
		local var_13_1 = arg_13_2.multiplier
		local var_13_2 = arg_13_2.time_into_buff
		local var_13_3
		local var_13_4
		local var_13_5
		local var_13_6

		if arg_13_1.last_frame_percentage == 0 then
			return
		end

		local var_13_7 = 1 - math.min(1, var_13_2 / arg_13_1.template.lerp_time)

		arg_13_1.last_frame_percentage = var_13_7

		if var_13_0 then
			local var_13_8 = math.lerp(0, var_13_0, var_13_7)

			var_13_4 = arg_13_1.current_lerped_value
			arg_13_1.current_lerped_value = var_13_8
			var_13_3 = var_13_8
		end

		if var_13_1 then
			local var_13_9 = math.lerp(1, var_13_1, var_13_7)

			var_13_5 = arg_13_1.current_lerped_multiplier
			arg_13_1.current_lerped_multiplier = var_13_9
			var_13_6 = var_13_9
		end

		if var_13_3 or var_13_6 then
			buff_extension_function_params.value = var_13_4
			buff_extension_function_params.multiplier = var_13_5

			BuffFunctionTemplates.functions.remove_movement_buff(arg_13_0, arg_13_1, buff_extension_function_params)

			if var_13_7 > 0 then
				buff_extension_function_params.value = var_13_3
				buff_extension_function_params.multiplier = var_13_6

				BuffFunctionTemplates.functions.apply_movement_buff(arg_13_0, arg_13_1, buff_extension_function_params)
			end
		end
	end,
	apply_movement_buff = function (arg_14_0, arg_14_1, arg_14_2)
		local var_14_0 = arg_14_2.bonus
		local var_14_1 = arg_14_2.multiplier

		if arg_14_1.template.wind_mutator then
			var_14_1 = var_14_1[Managers.weave:get_wind_strength()]
		end

		local var_14_2 = arg_14_1.template.path_to_movement_setting_to_modify
		local var_14_3 = var_0_3(var_14_2, arg_14_0)

		if var_14_0 then
			var_14_3 = var_14_3 + var_14_0
		end

		if var_14_1 then
			var_14_3 = var_14_3 * var_14_1
		end

		var_0_4(var_14_2, arg_14_0, var_14_3)
	end,
	remove_movement_buff = function (arg_15_0, arg_15_1, arg_15_2)
		local var_15_0 = arg_15_2.bonus
		local var_15_1 = arg_15_2.multiplier

		if arg_15_1.template.wind_mutator then
			var_15_1 = var_15_1[Managers.weave:get_wind_strength()]
		end

		local var_15_2 = arg_15_1.template.path_to_movement_setting_to_modify
		local var_15_3 = var_0_3(var_15_2, arg_15_0)

		if var_15_1 then
			var_15_3 = var_15_3 / var_15_1
		end

		if var_15_0 then
			var_15_3 = var_15_3 - var_15_0
		end

		var_0_4(var_15_2, arg_15_0, var_15_3)
	end,
	apply_ai_movement_buff = function (arg_16_0, arg_16_1, arg_16_2)
		local var_16_0 = BLACKBOARDS[arg_16_0]
		local var_16_1 = arg_16_2.multiplier

		if arg_16_1.template.wind_mutator then
			var_16_1 = var_16_1[Managers.weave:get_wind_strength()]
		end

		arg_16_1.id = var_16_0.navigation_extension:add_movement_modifier(var_16_1)
	end,
	remove_ai_movement_buff = function (arg_17_0, arg_17_1, arg_17_2)
		BLACKBOARDS[arg_17_0].navigation_extension:remove_movement_modifier(arg_17_1.id)
	end,
	apply_rotation_limit_buff = function (arg_18_0, arg_18_1, arg_18_2)
		local var_18_0 = ScriptUnit.extension(arg_18_0, "buff_system")
		local var_18_1 = arg_18_1.bonus
		local var_18_2 = var_18_0:get_stacking_buff(arg_18_1.template.name)

		for iter_18_0 = 1, #var_18_2 do
			local var_18_3 = var_18_2[iter_18_0]

			var_18_1 = math.min(var_18_1, var_18_3.bonus)
		end

		local var_18_4 = arg_18_1.template.path_to_movement_setting_to_modify

		var_0_4(var_18_4, arg_18_0, var_18_1)
	end,
	remove_rotation_limit_buff = function (arg_19_0, arg_19_1, arg_19_2)
		local var_19_0 = ScriptUnit.extension(arg_19_0, "buff_system")
		local var_19_1 = math.huge
		local var_19_2 = var_19_0:get_stacking_buff(arg_19_1.template.name)

		for iter_19_0 = 1, #var_19_2 do
			local var_19_3 = var_19_2[iter_19_0]

			if var_19_3 ~= arg_19_1 then
				var_19_1 = math.min(var_19_1, var_19_3.bonus)
			end
		end

		if var_19_1 == math.huge then
			var_19_1 = -1
		end

		local var_19_4 = arg_19_1.template.path_to_movement_setting_to_modify

		var_0_4(var_19_4, arg_19_0, var_19_1)
	end,
	apply_screenspace_effect = function (arg_20_0, arg_20_1, arg_20_2, arg_20_3)
		local var_20_0 = arg_20_1.template.screenspace_effect_name
		local var_20_1 = ScriptUnit.has_extension(arg_20_0, "first_person_system")

		if var_20_1 then
			var_20_1:create_screen_particles(var_20_0)
		end
	end,
	knock_down_bleed_start = function (arg_21_0, arg_21_1, arg_21_2)
		arg_21_1.next_damage_time = arg_21_2.t + arg_21_1.template.time_between_damage
	end,
	knock_down_bleed_update = function (arg_22_0, arg_22_1, arg_22_2)
		if arg_22_1.next_damage_time < arg_22_2.t then
			local var_22_0 = arg_22_1.template

			arg_22_1.next_damage_time = arg_22_1.next_damage_time + var_22_0.time_between_damage

			local var_22_1 = var_22_0.damage
			local var_22_2 = var_22_0.damage_type

			DamageUtils.add_damage_network(arg_22_0, arg_22_0, var_22_1, "full", var_22_2, nil, Vector3(1, 0, 0), "knockdown_bleed", nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, 1)
		end
	end,
	temporary_health_degen_start = function (arg_23_0, arg_23_1, arg_23_2)
		arg_23_1.next_damage_time = arg_23_2.t + arg_23_1.template.time_between_damage
	end,
	temporary_health_degen_update = function (arg_24_0, arg_24_1, arg_24_2)
		if arg_24_1.next_damage_time < arg_24_2.t then
			local var_24_0 = arg_24_1.template

			arg_24_1.next_damage_time = arg_24_1.next_damage_time + var_24_0.time_between_damage

			local var_24_1 = var_24_0.damage
			local var_24_2 = var_24_0.damage_type

			DamageUtils.add_damage_network(arg_24_0, arg_24_0, var_24_1, "full", var_24_2, nil, Vector3(1, 0, 0), "temporary_health_degen", nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, 1)
		end
	end,
	health_degen_start = function (arg_25_0, arg_25_1, arg_25_2)
		arg_25_1.next_damage_time = arg_25_2.t + arg_25_1.template.time_between_damage
	end,
	health_degen_update = function (arg_26_0, arg_26_1, arg_26_2)
		if arg_26_1.next_damage_time < arg_26_2.t then
			local var_26_0 = arg_26_1.template

			arg_26_1.next_damage_time = arg_26_1.next_damage_time + var_26_0.time_between_damage

			local var_26_1 = var_26_0.damage
			local var_26_2 = var_26_0.damage_type

			DamageUtils.add_damage_network(arg_26_0, arg_26_0, var_26_1, "full", var_26_2, nil, Vector3(1, 0, 0), "health_degen", nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, 1)
		end
	end,
	convert_permanent_to_temporary_health = function (arg_27_0, arg_27_1, arg_27_2)
		if Managers.state.network.is_server then
			local var_27_0 = ScriptUnit.has_extension(arg_27_0, "health_system")

			if var_27_0 then
				var_27_0:convert_permanent_to_temporary_health()
			end
		end
	end,
	life_drain_update_no_kill = function (arg_28_0, arg_28_1, arg_28_2)
		if arg_28_1.next_damage_time < arg_28_2.t then
			local var_28_0 = arg_28_1.template

			arg_28_1.next_damage_time = arg_28_1.next_damage_time + var_28_0.time_between_damage

			local var_28_1
			local var_28_2 = ScriptUnit.extension(arg_28_0, "health_system")
			local var_28_3 = ScriptUnit.extension(arg_28_0, "status_system")
			local var_28_4 = var_28_2:current_health()

			if not var_28_3:is_in_end_zone() and var_28_4 > 1 then
				if var_28_4 - var_28_0.damage > 1 then
					var_28_1 = var_28_0.damage
				else
					var_28_1 = var_28_4 - 1
				end

				local var_28_5 = var_28_0.damage_type

				DamageUtils.add_damage_network(arg_28_0, arg_28_0, var_28_1, "full", var_28_5, nil, Vector3(1, 0, 0), "life_drain", nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, 1)
			end
		end
	end,
	health_regen_all_start = function (arg_29_0, arg_29_1, arg_29_2)
		if Managers.state.network.is_server then
			arg_29_1.next_heal_time = arg_29_2.t + arg_29_1.template.time_between_heal
		end
	end,
	health_regen_all_update = function (arg_30_0, arg_30_1, arg_30_2)
		if Managers.state.network.is_server and arg_30_1.next_heal_time < arg_30_2.t then
			local var_30_0 = arg_30_1.template

			arg_30_1.next_heal_time = arg_30_1.next_heal_time + var_30_0.time_between_heal

			local var_30_1 = var_30_0.heal
			local var_30_2 = var_30_0.heal_type or "health_regen"
			local var_30_3 = Managers.state.side.side_by_unit[arg_30_0]

			if not var_30_3 then
				return
			end

			local var_30_4 = var_30_3.PLAYER_AND_BOT_UNITS

			for iter_30_0 = 1, #var_30_4 do
				DamageUtils.heal_network(var_30_4[iter_30_0], arg_30_0, var_30_1, var_30_2)
			end
		end
	end,
	health_regen_start = function (arg_31_0, arg_31_1, arg_31_2)
		if Managers.state.network.is_server then
			local var_31_0 = arg_31_1.template.time_between_heal

			if type(arg_31_1.template.time_between_heal) == "table" then
				local var_31_1 = Managers.state.difficulty:get_difficulty_rank()

				var_31_0 = arg_31_1.template.time_between_heal[var_31_1]
			end

			arg_31_1.next_heal_time = arg_31_2.t + var_31_0
		end
	end,
	health_regen_update = function (arg_32_0, arg_32_1, arg_32_2)
		if Managers.state.network.is_server and arg_32_1.next_heal_time < arg_32_2.t then
			local var_32_0 = arg_32_1.template
			local var_32_1 = var_32_0.time_between_heal

			if type(var_32_0.time_between_heal) == "table" then
				local var_32_2 = Managers.state.difficulty:get_difficulty_rank()

				var_32_1 = var_32_0.time_between_heal[var_32_2]
			end

			arg_32_1.next_heal_time = arg_32_1.next_heal_time + var_32_1

			local var_32_3 = ScriptUnit.has_extension(arg_32_0, "health_system")
			local var_32_4 = var_32_0.heal or var_32_0.heal_percent * var_32_3:get_max_health()
			local var_32_5 = var_32_0.heal_type or "health_regen"

			DamageUtils.heal_network(arg_32_0, arg_32_0, var_32_4, var_32_5)
		end
	end,
	mutator_life_health_regeneration_start = function (arg_33_0, arg_33_1, arg_33_2)
		if Managers.state.network.is_server then
			arg_33_1.next_buff_time = arg_33_2.t + 5
			arg_33_1.health_regeneration_stack_ids = {}
		end
	end,
	mutator_life_health_regeneration_update = function (arg_34_0, arg_34_1, arg_34_2)
		if Managers.state.network.is_server and arg_34_1.next_buff_time < arg_34_2.t then
			local var_34_0 = arg_34_1.template

			arg_34_1.next_buff_time = arg_34_1.next_buff_time + 5

			local var_34_1 = ScriptUnit.has_extension(arg_34_0, "buff_system")

			if var_34_1 then
				local var_34_2 = #arg_34_1.health_regeneration_stack_ids

				if var_34_2 < 3 then
					local var_34_3 = var_34_1:add_buff("mutator_life_health_regeneration_stacks")

					arg_34_1.health_regeneration_stack_ids[var_34_2 + 1] = var_34_3
				end
			end
		end
	end,
	remove_metal_mutator_gromril_armour = function (arg_35_0, arg_35_1, arg_35_2)
		local var_35_0 = {
			attacker_unit = arg_35_0
		}

		ScriptUnit.extension(arg_35_0, "buff_system"):add_buff("metal_mutator_damage_boost", var_35_0)
	end,
	start_blade_dance = function (arg_36_0, arg_36_1, arg_36_2, arg_36_3)
		arg_36_2.next_tick_t = arg_36_2.t + 0.5

		local var_36_0 = Managers.player:local_player()
		local var_36_1 = var_36_0 and var_36_0.player_unit
		local var_36_2 = Managers.world:wwise_world(arg_36_3)
		local var_36_3

		if arg_36_0 == var_36_1 then
			local var_36_4 = ScriptUnit.extension(arg_36_0, "first_person_system").first_person_unit

			var_36_3 = World.create_particles(arg_36_3, "fx/magic_wind_metal_blade_dance_01_1p", POSITION_LOOKUP[var_36_4])

			World.link_particles(arg_36_3, var_36_3, var_36_4, Unit.node(var_36_4, "root_point"), Matrix4x4.identity(), "stop")
			WwiseWorld.trigger_event(var_36_2, "Play_wind_metal_gameplay_mutator_wind_loop")
		else
			WwiseUtils.trigger_unit_event(arg_36_3, "Play_wind_metal_gameplay_mutator_wind_loop", arg_36_0, 0)

			var_36_3 = World.create_particles(arg_36_3, "fx/magic_wind_metal_blade_dance_01", POSITION_LOOKUP[arg_36_0])

			World.link_particles(arg_36_3, var_36_3, arg_36_0, Unit.node(arg_36_0, "root_point"), Matrix4x4.identity(), "stop")
		end

		arg_36_1.linked_effect = var_36_3
	end,
	update_blade_dance = function (arg_37_0, arg_37_1, arg_37_2)
		if arg_37_2.t >= arg_37_2.next_tick_t then
			arg_37_2.next_tick_t = arg_37_2.t + 0.5

			local var_37_0 = Managers.state.entity:system("area_damage_system")
			local var_37_1 = POSITION_LOOKUP[arg_37_0] + Vector3(0, 0, 1)
			local var_37_2 = Unit.local_rotation(arg_37_0, 0)

			var_37_0:create_explosion(arg_37_0, var_37_1, var_37_2, "metal_mutator_blade_dance", 1, "undefined", 0, false)
		end
	end,
	remove_blade_dance = function (arg_38_0, arg_38_1, arg_38_2, arg_38_3)
		local var_38_0 = Managers.state.network:unit_game_object_id(arg_38_0)
		local var_38_1 = Managers.player:local_player()
		local var_38_2 = var_38_1 and var_38_1.player_unit
		local var_38_3 = Managers.world:wwise_world(arg_38_3)

		if arg_38_0 == var_38_2 then
			WwiseWorld.trigger_event(var_38_3, "Stop_wind_metal_gameplay_mutator_wind_loop")
		else
			WwiseUtils.trigger_unit_event(arg_38_3, "Stop_wind_metal_gameplay_mutator_wind_loop", arg_38_0, 0)
		end

		if arg_38_1.linked_effect then
			World.destroy_particles(arg_38_3, arg_38_1.linked_effect)

			arg_38_1.linked_effect = nil
		end
	end,
	apply_beasts_totem_buff = function (arg_39_0, arg_39_1, arg_39_2, arg_39_3)
		if not arg_39_1.fx_id then
			local var_39_0 = World.create_particles(arg_39_3, "fx/chr_beastmen_standard_bearer_buff_01", POSITION_LOOKUP[arg_39_0])

			arg_39_1.fx_id = var_39_0

			World.link_particles(arg_39_3, var_39_0, arg_39_0, Unit.node(arg_39_0, "root_point"), Matrix4x4.identity(), "stop")
		end
	end,
	remove_beasts_totem_buff = function (arg_40_0, arg_40_1, arg_40_2, arg_40_3)
		if arg_40_1.fx_id then
			World.stop_spawning_particles(arg_40_3, arg_40_1.fx_id)
		end
	end,
	apply_fire_mutator_bomb = function (arg_41_0, arg_41_1, arg_41_2, arg_41_3)
		local var_41_0 = Managers.player:local_player()

		if arg_41_0 == (var_41_0 and var_41_0.player_unit) then
			local var_41_1 = ScriptUnit.has_extension(arg_41_0, "first_person_system")

			if var_41_1 then
				arg_41_1.screenspace_particle_id = var_41_1:create_screen_particles("fx/screenspace_magic_wind_fire_01")
			end
		else
			local var_41_2 = World.create_particles(arg_41_3, "fx/magic_wind_fire_timer_01", POSITION_LOOKUP[arg_41_0])

			arg_41_1.linked_effect = var_41_2

			World.link_particles(arg_41_3, var_41_2, arg_41_0, Unit.node(arg_41_0, "root_point"), Matrix4x4.identity(), "stop")
		end
	end,
	update_fire_mutator_bomb = function (arg_42_0, arg_42_1, arg_42_2, arg_42_3)
		return
	end,
	remove_fire_mutator_bomb = function (arg_43_0, arg_43_1, arg_43_2, arg_43_3)
		if arg_43_1.linked_effect then
			World.destroy_particles(arg_43_3, arg_43_1.linked_effect)

			arg_43_1.linked_effect = nil
		end

		local var_43_0 = ScriptUnit.has_extension(arg_43_0, "first_person_system")

		if var_43_0 then
			var_43_0:destroy_screen_particles(arg_43_1.screenspace_particle_id)
		end
	end,
	apply_mutator_life_poison_buff = function (arg_44_0, arg_44_1, arg_44_2, arg_44_3)
		local var_44_0 = WindSettings.life
		local var_44_1 = Managers.weave:get_wind_strength()
		local var_44_2 = var_44_0.thorns_damage[var_44_1]
	end,
	start_dot_damage = function (arg_45_0, arg_45_1, arg_45_2)
		if arg_45_1.template.damage_type == "burninating" then
			local var_45_0 = arg_45_2.attacker_unit
			local var_45_1 = var_45_0 and ScriptUnit.has_extension(var_45_0, "buff_system")
			local var_45_2 = ScriptUnit.has_extension(arg_45_0, "buff_system")

			if var_45_2 and var_45_1 and var_45_1:has_buff_type("sienna_unchained_burn_increases_damage_taken") then
				local var_45_3 = var_45_1:get_non_stacking_buff("sienna_unchained_burn_increases_damage_taken")

				table.clear(var_0_5)

				var_0_5.external_optional_multiplier = var_45_3.multiplier
				var_0_5.external_optional_duration = arg_45_1.duration

				var_45_2:add_buff("increase_damage_recieved_while_burning", var_0_5)
			end
		end
	end,
	reapply_dot_damage = function (arg_46_0, arg_46_1, arg_46_2)
		if arg_46_1.template.damage_type == "burninating" then
			local var_46_0 = arg_46_2.attacker_unit
			local var_46_1 = var_46_0 and ScriptUnit.has_extension(var_46_0, "buff_system")
			local var_46_2 = ScriptUnit.has_extension(arg_46_0, "buff_system")

			if var_46_2 and var_46_1 and var_46_1:has_buff_type("sienna_unchained_burn_increases_damage_taken") then
				local var_46_3 = var_46_1:get_non_stacking_buff("sienna_unchained_burn_increases_damage_taken")

				table.clear(var_0_5)

				var_0_5.external_optional_multiplier = var_46_3.multiplier
				var_0_5.external_optional_duration = arg_46_1.duration

				var_46_2:add_buff("increase_damage_recieved_while_burning", var_0_5)
			end
		end
	end,
	apply_dot_damage = function (arg_47_0, arg_47_1, arg_47_2)
		local var_47_0 = arg_47_2.t
		local var_47_1 = var_47_0

		if HEALTH_ALIVE[arg_47_0] then
			local var_47_2 = arg_47_1.template
			local var_47_3 = arg_47_1.template.time_between_dot_damages
			local var_47_4 = arg_47_1.template.perks

			if var_47_4 and table.find(var_47_4, var_0_0.burning_balefire) then
				local var_47_5 = arg_47_1.source_attacker_unit or arg_47_1.attacker_unit
				local var_47_6 = ScriptUnit.has_extension(var_47_5, "buff_system")

				if var_47_6 and not Managers.state.side:is_ally(arg_47_0, var_47_5) then
					var_47_3 = var_47_3 * var_47_6:apply_buffs_to_value(1, "increased_balefire_dot_duration")
				end
			end

			var_47_1 = var_47_1 + (0.75 * var_47_3 + math.random() * 0.5 * var_47_3)

			if Managers.state.network.is_server then
				local var_47_7 = arg_47_2.attacker_unit
				local var_47_8 = arg_47_2.source_attacker_unit
				local var_47_9 = ALIVE[var_47_7] and var_47_7 or ALIVE[var_47_8] and var_47_8

				if var_47_9 then
					if arg_47_1.template.custom_dot_tick_func then
						BuffFunctionTemplates.functions[arg_47_1.template.custom_dot_tick_func](arg_47_0, arg_47_1, arg_47_2)
					else
						local var_47_10 = arg_47_0
						local var_47_11 = arg_47_1.template.hit_zone or "full"
						local var_47_12 = Vector3.down()
						local var_47_13
						local var_47_14 = "dot_debuff"
						local var_47_15 = arg_47_1.power_level or DefaultPowerLevel
						local var_47_16 = var_47_2.damage_profile or "default"
						local var_47_17 = DamageProfileTemplates[var_47_16]
						local var_47_18
						local var_47_19 = 0
						local var_47_20 = false
						local var_47_21 = true
						local var_47_22 = var_47_17.dot_stagger
						local var_47_23 = false
						local var_47_24 = false
						local var_47_25
						local var_47_26
						local var_47_27

						DamageUtils.server_apply_hit(var_47_0, var_47_9, var_47_10, var_47_11, nil, var_47_12, var_47_13, var_47_14, var_47_15, var_47_17, var_47_18, var_47_19, var_47_20, var_47_21, var_47_22, var_47_23, var_47_24, var_47_25, var_47_26, var_47_27, var_47_8)
					end
				end
			end
		end

		if arg_47_1.template.sound_event and var_0_7(arg_47_0) then
			local var_47_28 = ScriptUnit.has_extension(arg_47_0, "first_person_system")

			if var_47_28 then
				var_47_28:play_hud_sound_event(arg_47_1.template.sound_event)
			end
		end

		local var_47_29 = arg_47_1.template.perks

		if var_47_29 then
			for iter_47_0 = 1, #var_47_29 do
				local var_47_30 = var_47_29[iter_47_0]
				local var_47_31 = var_47_30 and var_0_2[var_47_30]

				if var_47_31 then
					local var_47_32 = arg_47_2.source_attacker_unit or AiUtils.get_actual_attacker_unit(arg_47_2.attacker_unit)

					if var_0_7(var_47_32) then
						local var_47_33 = ScriptUnit.has_extension(var_47_32, "first_person_system")

						if var_47_33 then
							var_47_33:play_hud_sound_event(var_47_31)
						end
					end
				end
			end
		end

		return var_47_1
	end,
	apply_moving_through_vomit = function (arg_48_0, arg_48_1, arg_48_2, arg_48_3)
		local var_48_0 = Managers.state.difficulty:get_difficulty()

		arg_48_1.damage = arg_48_1.template.difficulty_damage[var_48_0]
		arg_48_1.armor_type = Unit.get_data(arg_48_0, "breed").armor_category or 1

		local var_48_1 = ScriptUnit.has_extension(arg_48_0, "first_person_system")

		if var_48_1 then
			arg_48_1.vomit_particle_id = var_48_1:create_screen_particles("fx/screenspace_vomit_hit_onfeet")
		end

		local var_48_2 = arg_48_2.attacker_unit

		if Unit.alive(var_48_2) then
			local var_48_3 = ScriptUnit.has_extension(var_48_2, "area_damage_system")

			if var_48_3 then
				local var_48_4 = var_48_3:get_source_attacker_unit()
				local var_48_5 = ALIVE[var_48_4] and Unit.get_data(var_48_4, "breed")

				arg_48_1.damage_source = var_48_5 and var_48_5.name or "dot_debuff"
			end
		end
	end,
	update_moving_through_vomit = function (arg_49_0, arg_49_1, arg_49_2, arg_49_3)
		local var_49_0 = arg_49_2.t
		local var_49_1 = arg_49_1.template

		if Managers.state.network.is_server and HEALTH_ALIVE[arg_49_0] then
			local var_49_2 = ALIVE[arg_49_2.attacker_unit] and arg_49_2.attacker_unit or arg_49_0
			local var_49_3 = arg_49_1.armor_type
			local var_49_4 = var_49_1.damage_type
			local var_49_5 = arg_49_1.damage[var_49_3]
			local var_49_6 = arg_49_1.damage_source
			local var_49_7 = var_49_2 and ScriptUnit.has_extension(var_49_2, "area_damage_system")

			if var_49_7 then
				var_49_5 = var_49_5 * (var_49_7.buff_damage_multiplier or 1)
			end

			DamageUtils.add_damage_network(arg_49_0, var_49_2, var_49_5, "torso", var_49_4, nil, Vector3(1, 0, 0), var_49_6, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, 1)
		end

		local var_49_8 = Managers.player:owner(arg_49_0)

		if var_49_8 and not var_49_8.remote then
			local var_49_9 = var_49_1.fatigue_type

			ScriptUnit.extension(arg_49_0, "status_system"):add_fatigue_points(var_49_9)
		end

		local var_49_10 = ScriptUnit.extension(arg_49_0, "buff_system")
		local var_49_11 = var_49_1.slowdown_buff_name

		if var_49_11 then
			var_49_10:add_buff(var_49_11, arg_49_2)
		end

		local var_49_12 = ScriptUnit.has_extension(arg_49_0, "first_person_system")

		if var_49_12 then
			var_49_12:play_hud_sound_event("Play_player_damage_puke")
		end

		return var_49_0 + var_49_1.time_between_dot_damages
	end,
	remove_moving_through_vomit = function (arg_50_0, arg_50_1, arg_50_2, arg_50_3)
		local var_50_0 = ScriptUnit.has_extension(arg_50_0, "first_person_system")

		if var_50_0 then
			var_50_0:stop_spawning_screen_particles(arg_50_1.vomit_particle_id)
		end
	end,
	apply_catacombs_corpse_pit = function (arg_51_0, arg_51_1, arg_51_2, arg_51_3)
		arg_51_1.next_tick = arg_51_2.t + 0
	end,
	update_catacombs_corpse_pit = function (arg_52_0, arg_52_1, arg_52_2, arg_52_3)
		local var_52_0 = arg_52_2.t
		local var_52_1 = arg_52_1.next_tick
		local var_52_2 = arg_52_1.template

		if var_52_1 < var_52_0 then
			local var_52_3 = Managers.player:owner(arg_52_0)

			if var_52_3 and not var_52_3.remote then
				local var_52_4 = var_52_2.fatigue_type

				ScriptUnit.extension(arg_52_0, "status_system"):add_fatigue_points(var_52_4)
			end

			local var_52_5 = ScriptUnit.extension(arg_52_0, "buff_system")
			local var_52_6 = var_52_2.slowdown_buff_name

			if var_52_6 then
				var_52_5:add_buff(var_52_6, arg_52_2)
			end

			local var_52_7 = ScriptUnit.has_extension(arg_52_0, "first_person_system")

			if var_52_7 then
				var_52_7:play_hud_sound_event("Play_player_damage_puke")
			end

			arg_52_1.next_tick = var_52_0 + var_52_2.time_between_ticks
		end
	end,
	remove_catacombs_corpse_pit = function (arg_53_0, arg_53_1, arg_53_2, arg_53_3)
		return
	end,
	apply_moving_through_plague = function (arg_54_0, arg_54_1, arg_54_2, arg_54_3)
		local var_54_0 = Managers.state.difficulty:get_difficulty()

		arg_54_1.damage = arg_54_1.template.difficulty_damage[var_54_0]
		arg_54_1.armor_type = Unit.get_data(arg_54_0, "breed").armor_category or 1

		local var_54_1 = ScriptUnit.has_extension(arg_54_0, "first_person_system")

		if var_54_1 then
			arg_54_1.plague_particle_id = var_54_1:create_screen_particles("fx/screenspace_cemetery_plague_01")
		end

		local var_54_2 = arg_54_2.attacker_unit

		if Unit.alive(var_54_2) then
			local var_54_3 = ScriptUnit.has_extension(var_54_2, "area_damage_system")

			if var_54_3 then
				local var_54_4 = var_54_3:get_source_attacker_unit()
				local var_54_5 = ALIVE[var_54_4] and Unit.get_data(var_54_4, "breed")

				arg_54_1.damage_source = var_54_5 and var_54_5.name or "dot_debuff"
			end
		end
	end,
	update_moving_through_plague = function (arg_55_0, arg_55_1, arg_55_2, arg_55_3)
		local var_55_0 = arg_55_2.t
		local var_55_1 = arg_55_1.template

		if Managers.state.network.is_server and HEALTH_ALIVE[arg_55_0] then
			local var_55_2 = ALIVE[arg_55_2.attacker_unit] and arg_55_2.attacker_unit or arg_55_0
			local var_55_3 = arg_55_1.armor_type
			local var_55_4 = var_55_1.damage_type
			local var_55_5 = arg_55_1.damage[var_55_3]
			local var_55_6 = arg_55_1.damage_source

			DamageUtils.add_damage_network(arg_55_0, var_55_2, var_55_5, "torso", var_55_4, nil, Vector3(1, 0, 0), var_55_6, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, 1)
		end

		local var_55_7 = Managers.player:owner(arg_55_0)

		if var_55_7 and not var_55_7.remote then
			local var_55_8 = var_55_1.fatigue_type

			ScriptUnit.extension(arg_55_0, "status_system"):add_fatigue_points(var_55_8)
		end

		local var_55_9 = ScriptUnit.extension(arg_55_0, "buff_system")
		local var_55_10 = var_55_1.slowdown_buff_name

		if var_55_10 then
			var_55_9:add_buff(var_55_10, arg_55_2)
		end

		local var_55_11 = ScriptUnit.has_extension(arg_55_0, "first_person_system")

		if var_55_11 then
			var_55_11:play_hud_sound_event("Play_player_damage_puke")
		end

		return var_55_0 + var_55_1.time_between_dot_damages
	end,
	remove_moving_through_plague = function (arg_56_0, arg_56_1, arg_56_2, arg_56_3)
		local var_56_0 = ScriptUnit.has_extension(arg_56_0, "first_person_system")

		if var_56_0 then
			var_56_0:stop_spawning_screen_particles(arg_56_1.plague_particle_id)
		end
	end,
	apply_mutator_life_thorns_poison = function (arg_57_0, arg_57_1, arg_57_2, arg_57_3)
		local var_57_0 = Managers.state.difficulty:get_difficulty()

		arg_57_1.damage = arg_57_1.template.difficulty_damage[var_57_0]

		local var_57_1 = arg_57_2.attacker_unit

		if Unit.alive(var_57_1) then
			local var_57_2 = ScriptUnit.has_extension(var_57_1, "area_damage_system")

			if var_57_2 then
				local var_57_3 = var_57_2._source_unit
				local var_57_4 = ALIVE[var_57_3] and Unit.get_data(var_57_3, "breed")

				arg_57_1.damage_source = var_57_4 and var_57_4.name or "dot_debuff"
			end
		end
	end,
	update_mutator_life_thorns_poison = function (arg_58_0, arg_58_1, arg_58_2, arg_58_3)
		local var_58_0 = arg_58_2.t
		local var_58_1 = arg_58_1.template

		if Managers.state.network.is_server and HEALTH_ALIVE[arg_58_0] then
			local var_58_2 = ALIVE[arg_58_2.attacker_unit] and arg_58_2.attacker_unit or arg_58_0
			local var_58_3 = var_58_1.damage_type
			local var_58_4 = arg_58_1.damage
			local var_58_5 = arg_58_1.damage_source

			DamageUtils.add_damage_network(arg_58_0, var_58_2, var_58_4, "torso", var_58_3, nil, Vector3(1, 0, 0), var_58_5, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, 1)
		end

		local var_58_6 = Managers.player:owner(arg_58_0)

		if var_58_6 and not var_58_6.remote then
			local var_58_7 = var_58_1.fatigue_type

			ScriptUnit.extension(arg_58_0, "status_system"):add_fatigue_points(var_58_7)
		end

		local var_58_8 = ScriptUnit.extension(arg_58_0, "buff_system")
		local var_58_9 = var_58_1.slowdown_buff_name

		if var_58_9 then
			var_58_8:add_buff(var_58_9, arg_58_2)
		end

		return var_58_0 + var_58_1.time_between_dot_damages
	end,
	remove_mutator_life_thorns_poison = function (arg_59_0, arg_59_1, arg_59_2, arg_59_3)
		return
	end,
	apply_ai_movement_debuff = function (arg_60_0, arg_60_1, arg_60_2, arg_60_3)
		local var_60_0 = ScriptUnit.extension(arg_60_0, "ai_navigation_system")
		local var_60_1 = arg_60_1.template.multiplier

		arg_60_1.movement_modifier_id = var_60_0:add_movement_modifier(var_60_1)
	end,
	remove_ai_movement_debuff = function (arg_61_0, arg_61_1, arg_61_2, arg_61_3)
		ScriptUnit.extension(arg_61_0, "ai_navigation_system"):remove_movement_modifier(arg_61_1.movement_modifier_id)
	end,
	apply_chaos_zombie_explosion_in_face = function (arg_62_0, arg_62_1, arg_62_2, arg_62_3)
		return
	end,
	update_chaos_zombie_explosion_in_face = function (arg_63_0, arg_63_1, arg_63_2, arg_63_3)
		return
	end,
	remove_chaos_zombie_explosion_in_face = function (arg_64_0, arg_64_1, arg_64_2, arg_64_3)
		local var_64_0 = ScriptUnit.has_extension(arg_64_0, "first_person_system")

		if var_64_0 then
			var_64_0:stop_spawning_screen_particles(arg_64_1.nurgle_particle_id_01)
			var_64_0:stop_spawning_screen_particles(arg_64_1.nurgle_particle_id_02)
		end
	end,
	apply_plague_wave_in_face = function (arg_65_0, arg_65_1, arg_65_2, arg_65_3)
		local var_65_0 = Managers.state.difficulty:get_difficulty()
		local var_65_1 = arg_65_1.template

		arg_65_1.damage = var_65_1.difficulty_damage[var_65_0]
		arg_65_1.armor_type = Unit.get_data(arg_65_0, "breed").armor_category or 1

		local var_65_2 = Managers.player:owner(arg_65_0)

		if var_65_2.remote or var_65_2.bot_player or false then
			CosmeticsUtils.flow_event_mesh_3p(arg_65_0, "impact_vomit")
		end

		local var_65_3 = ScriptUnit.has_extension(arg_65_0, "first_person_system")

		if var_65_3 then
			arg_65_1.plague_wave_opaque_particle_id = var_65_3:create_screen_particles("fx/screenspace_plague_wave_01")
			arg_65_1.plague_wave_particle_id = var_65_3:create_screen_particles("fx/screenspace_plauge_wave_02")

			var_65_3:play_hud_sound_event("Play_player_hit_puke")
		end

		local var_65_4
		local var_65_5 = arg_65_2.attacker_unit

		if Unit.alive(var_65_5) then
			local var_65_6 = Unit.get_data(var_65_5, "breed")

			arg_65_1.damage_source = var_65_6 and var_65_6.name or "dot_debuff"

			local var_65_7 = POSITION_LOOKUP[arg_65_0] - POSITION_LOOKUP[var_65_5]

			var_65_4 = Vector3.normalize(var_65_7)
		else
			var_65_4 = Vector3.backward()
		end

		local var_65_8 = ScriptUnit.extension(arg_65_0, "locomotion_system")
		local var_65_9 = var_65_4 * var_65_1.push_speed

		var_65_8:add_external_velocity(var_65_9)

		arg_65_1.vomit_next_t = arg_65_2.t
	end,
	remove_plague_wave_in_face = function (arg_66_0, arg_66_1, arg_66_2, arg_66_3)
		local var_66_0 = ScriptUnit.has_extension(arg_66_0, "first_person_system")

		if var_66_0 then
			var_66_0:stop_spawning_screen_particles(arg_66_1.plague_wave_particle_id)
			var_66_0:stop_spawning_screen_particles(arg_66_1.plague_wave_opaque_particle_id)
		end
	end,
	apply_vermintide_in_face = function (arg_67_0, arg_67_1, arg_67_2, arg_67_3)
		local var_67_0 = Managers.state.difficulty:get_difficulty()
		local var_67_1 = arg_67_1.template

		arg_67_1.damage = var_67_1.difficulty_damage[var_67_0]
		arg_67_1.armor_type = Unit.get_data(arg_67_0, "breed").armor_category or 1

		local var_67_2
		local var_67_3 = arg_67_2.attacker_unit

		if Unit.alive(var_67_3) then
			local var_67_4 = Unit.get_data(var_67_3, "breed")

			arg_67_1.damage_source = var_67_4 and var_67_4.name or "dot_debuff"

			local var_67_5 = POSITION_LOOKUP[arg_67_0] - POSITION_LOOKUP[var_67_3]

			var_67_2 = Vector3.normalize(var_67_5)
		else
			var_67_2 = Vector3.backward()
		end

		local var_67_6 = ScriptUnit.extension(arg_67_0, "locomotion_system")
		local var_67_7 = var_67_2 * var_67_1.push_speed

		var_67_6:add_external_velocity(var_67_7)
	end,
	update_vermintide_in_face = function (arg_68_0, arg_68_1, arg_68_2, arg_68_3)
		local var_68_0 = arg_68_2.t
		local var_68_1 = arg_68_1.template

		if Managers.state.network.is_server and HEALTH_ALIVE[arg_68_0] then
			local var_68_2 = arg_68_2.attacker_unit

			var_68_2 = Unit.alive(var_68_2) and var_68_2 or arg_68_0

			local var_68_3 = arg_68_1.armor_type
			local var_68_4 = var_68_1.damage_type
			local var_68_5 = arg_68_1.damage[var_68_3]
			local var_68_6 = arg_68_1.damage_source

			DamageUtils.add_damage_network(arg_68_0, var_68_2, var_68_5, "torso", var_68_4, nil, Vector3(1, 0, 0), var_68_6, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, 1)
		end

		local var_68_7 = Managers.player:owner(arg_68_0)

		if var_68_7 and not var_68_7.remote then
			local var_68_8 = var_68_1.fatigue_type

			ScriptUnit.extension(arg_68_0, "status_system"):add_fatigue_points(var_68_8)
		end

		local var_68_9 = ScriptUnit.extension(arg_68_0, "buff_system")
		local var_68_10 = var_68_1.slowdown_buff_name

		if var_68_10 then
			var_68_9:add_buff(var_68_10, arg_68_2)
		end

		return var_68_0 + var_68_1.time_between_dot_damages
	end,
	remove_vermintide_in_face = function (arg_69_0, arg_69_1, arg_69_2, arg_69_3)
		return
	end,
	apply_vomit_in_face = function (arg_70_0, arg_70_1, arg_70_2, arg_70_3)
		local var_70_0 = Managers.state.difficulty:get_difficulty()
		local var_70_1 = arg_70_1.template

		arg_70_1.damage = var_70_1.difficulty_damage[var_70_0]
		arg_70_1.armor_type = Unit.get_data(arg_70_0, "breed").armor_category or 1

		local var_70_2 = Managers.player:owner(arg_70_0)

		if var_70_2.remote or var_70_2.bot_player or false then
			CosmeticsUtils.flow_event_mesh_3p(arg_70_0, "impact_vomit")
		end

		local var_70_3 = ScriptUnit.has_extension(arg_70_0, "first_person_system")

		if var_70_3 then
			arg_70_1.vomit_opaque_particle_id = var_70_3:create_screen_particles("fx/screenspace_vomit_hit_opaque")
			arg_70_1.vomit_particle_id = var_70_3:create_screen_particles("fx/screenspace_vomit_hit_inface")

			var_70_3:play_hud_sound_event("Play_player_hit_puke")
		end

		if Managers.state.network.is_server then
			local var_70_4 = ScriptUnit.has_extension(arg_70_0, "career_system")

			if var_70_4 then
				local var_70_5 = var_70_4:profile_index()
				local var_70_6 = SPProfiles[var_70_5].display_name

				Managers.state.entity:system("surrounding_aware_system"):add_system_event(arg_70_0, "hit_by_vomit", DialogueSettings.default_view_distance, "target_name", var_70_6)
			end
		end

		local var_70_7
		local var_70_8 = arg_70_2.attacker_unit

		if Unit.alive(var_70_8) then
			local var_70_9 = Unit.get_data(var_70_8, "breed")

			arg_70_1.damage_source = var_70_9 and var_70_9.name or "dot_debuff"

			local var_70_10 = POSITION_LOOKUP[arg_70_0] - POSITION_LOOKUP[var_70_8]

			var_70_7 = Vector3.normalize(var_70_10)

			local var_70_11 = ScriptUnit.has_extension(var_70_8, "buff_system")

			if var_70_11 then
				arg_70_1.buff_damage_multiplier = var_70_11:apply_buffs_to_value(1, "damage_dealt")
			end
		else
			var_70_7 = Vector3.backward()
		end

		local var_70_12 = ScriptUnit.extension(arg_70_0, "locomotion_system")
		local var_70_13 = var_70_7 * var_70_1.push_speed

		var_70_12:add_external_velocity(var_70_13)
	end,
	update_vomit_in_face = function (arg_71_0, arg_71_1, arg_71_2, arg_71_3)
		local var_71_0 = arg_71_2.t
		local var_71_1 = arg_71_1.template

		if Managers.state.network.is_server and HEALTH_ALIVE[arg_71_0] then
			local var_71_2 = arg_71_2.attacker_unit
			local var_71_3 = Unit.alive(var_71_2) and var_71_2 or arg_71_0
			local var_71_4 = arg_71_1.armor_type
			local var_71_5 = var_71_1.damage_type
			local var_71_6 = arg_71_1.damage[var_71_4]
			local var_71_7 = arg_71_1.damage_source

			if arg_71_1.buff_damage_multiplier then
				var_71_6 = var_71_6 * arg_71_1.buff_damage_multiplier
			end

			DamageUtils.add_damage_network(arg_71_0, var_71_3, var_71_6, "torso", var_71_5, nil, Vector3(1, 0, 0), var_71_7, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, 1)
		end

		local var_71_8 = Managers.player:owner(arg_71_0)

		if var_71_8 and not var_71_8.remote then
			local var_71_9 = var_71_1.fatigue_type

			ScriptUnit.extension(arg_71_0, "status_system"):add_fatigue_points(var_71_9)
		end

		local var_71_10 = ScriptUnit.extension(arg_71_0, "buff_system")
		local var_71_11 = var_71_1.slowdown_buff_name

		if var_71_11 then
			var_71_10:add_buff(var_71_11, arg_71_2)
		end

		local var_71_12 = ScriptUnit.has_extension(arg_71_0, "first_person_system")

		if var_71_12 then
			var_71_12:play_hud_sound_event("Play_player_damage_puke")
		end

		return var_71_0 + var_71_1.time_between_dot_damages
	end,
	remove_vomit_in_face = function (arg_72_0, arg_72_1, arg_72_2, arg_72_3)
		local var_72_0 = ScriptUnit.has_extension(arg_72_0, "first_person_system")

		if var_72_0 then
			var_72_0:stop_spawning_screen_particles(arg_72_1.vomit_particle_id)
			var_72_0:stop_spawning_screen_particles(arg_72_1.vomit_opaque_particle_id)
		end
	end,
	apply_vortex = function (arg_73_0, arg_73_1, arg_73_2, arg_73_3)
		local var_73_0 = Managers.state.difficulty:get_difficulty()

		arg_73_1.damage = arg_73_1.template.difficulty_damage[var_73_0]
		arg_73_1.armor_type = Unit.get_data(arg_73_0, "breed").armor_category or 1

		local var_73_1 = ScriptUnit.has_extension(arg_73_0, "first_person_system")

		if var_73_1 then
			arg_73_1.vortex_particle_id = var_73_1:create_screen_particles("fx/screenspace_poison_globe_impact")
		end

		local var_73_2 = arg_73_2.attacker_unit

		if Unit.alive(var_73_2) then
			local var_73_3 = DamageUtils.is_enemy(var_73_2, arg_73_0)
			local var_73_4 = ALIVE[var_73_2] and Unit.get_data(var_73_2, "breed")
			local var_73_5 = var_73_4 and var_73_4.name

			arg_73_1.damage_source = var_73_3 and var_73_5 or "dot_debuff"
		end
	end,
	update_vortex = function (arg_74_0, arg_74_1, arg_74_2, arg_74_3)
		local var_74_0 = arg_74_2.t
		local var_74_1 = arg_74_1.template

		if Managers.state.network.is_server and HEALTH_ALIVE[arg_74_0] then
			local var_74_2 = arg_74_2.attacker_unit
			local var_74_3 = Unit.alive(var_74_2) and var_74_2 or arg_74_0
			local var_74_4 = arg_74_1.armor_type
			local var_74_5 = var_74_1.damage_type
			local var_74_6 = arg_74_1.damage[var_74_4]
			local var_74_7 = arg_74_1.damage_source

			DamageUtils.add_damage_network(arg_74_0, var_74_3, var_74_6, "torso", var_74_5, nil, Vector3(1, 0, 0), var_74_7, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, 1)
		end

		local var_74_8 = Managers.player:owner(arg_74_0)

		if var_74_8 and not var_74_8.remote then
			local var_74_9 = var_74_1.fatigue_type

			ScriptUnit.extension(arg_74_0, "status_system"):add_fatigue_points(var_74_9)
		end

		local var_74_10 = ScriptUnit.extension(arg_74_0, "buff_system")
		local var_74_11 = var_74_1.slowdown_buff_name

		if var_74_11 then
			var_74_10:add_buff(var_74_11, arg_74_2)
		end

		local var_74_12 = ScriptUnit.has_extension(arg_74_0, "first_person_system")

		if var_74_12 then
			var_74_12:play_hud_sound_event("Play_player_damage_puke")
		end

		return var_74_0 + var_74_1.time_between_dot_damages
	end,
	remove_vortex = function (arg_75_0, arg_75_1, arg_75_2, arg_75_3)
		local var_75_0 = ScriptUnit.has_extension(arg_75_0, "first_person_system")

		if var_75_0 then
			var_75_0:stop_spawning_screen_particles(arg_75_1.vortex_particle_id)
		end
	end,
	apply_moving_through_warpfire = function (arg_76_0, arg_76_1, arg_76_2, arg_76_3)
		local var_76_0 = Managers.state.difficulty:get_difficulty()

		arg_76_1.damage = arg_76_1.template.difficulty_damage[var_76_0]
		arg_76_1.armor_type = Unit.get_data(arg_76_0, "breed").armor_category or 1

		local var_76_1 = ScriptUnit.has_extension(arg_76_0, "first_person_system")

		if var_76_1 then
			arg_76_1.warpfire_particle_id = var_76_1:create_screen_particles("fx/screenspace_warpfire_hit_onfeet")
		end

		local var_76_2 = arg_76_2.attacker_unit

		if Unit.alive(var_76_2) then
			local var_76_3 = ScriptUnit.extension(var_76_2, "area_damage_system"):get_source_attacker_unit()
			local var_76_4 = ALIVE[var_76_3] and Unit.get_data(var_76_3, "breed")

			arg_76_1.damage_source = var_76_4 and var_76_4.name or "dot_debuff"

			if ALIVE[var_76_3] then
				local var_76_5 = ScriptUnit.has_extension(var_76_3, "buff_system")

				if var_76_5 then
					if type(arg_76_1.damage) == "table" then
						local var_76_6 = table.clone(arg_76_1.damage)

						for iter_76_0, iter_76_1 in pairs(var_76_6) do
							var_76_6[iter_76_0] = var_76_5:apply_buffs_to_value(iter_76_1, "damage_dealt")
						end

						arg_76_1.damage = var_76_6
					else
						arg_76_1.damage = var_76_5:apply_buffs_to_value(arg_76_1.damage, "damage_dealt")
					end
				end
			end
		end

		arg_76_1.warpfire_next_t = arg_76_2.t + 0.1
	end,
	update_moving_through_warpfire = function (arg_77_0, arg_77_1, arg_77_2, arg_77_3)
		local var_77_0 = arg_77_2.t
		local var_77_1 = arg_77_1.template

		if Managers.state.network.is_server and HEALTH_ALIVE[arg_77_0] then
			local var_77_2 = arg_77_2.attacker_unit
			local var_77_3 = Unit.alive(var_77_2) and var_77_2 or arg_77_0
			local var_77_4 = arg_77_1.armor_type
			local var_77_5 = var_77_1.damage_type
			local var_77_6 = arg_77_1.damage[var_77_4]
			local var_77_7 = arg_77_1.damage_source

			DamageUtils.add_damage_network(arg_77_0, var_77_3, var_77_6, "torso", var_77_5, nil, Vector3(1, 0, 0), var_77_7, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, 1)
		end

		local var_77_8 = ScriptUnit.has_extension(arg_77_0, "first_person_system")

		if var_77_8 then
			var_77_8:play_hud_sound_event("Play_player_damage_puke")
		end

		local var_77_9 = ScriptUnit.extension(arg_77_0, "buff_system")
		local var_77_10 = var_77_1.slowdown_buff_name

		if var_77_10 then
			var_77_9:add_buff(var_77_10, arg_77_2)
		end

		return var_77_0 + var_77_1.time_between_dot_damages
	end,
	update_heal_ticks = function (arg_78_0, arg_78_1, arg_78_2, arg_78_3)
		local var_78_0 = arg_78_2.t
		local var_78_1 = arg_78_1.template
		local var_78_2 = arg_78_1.next_heal_tick or 0

		if ScriptUnit.extension(arg_78_0, "health_system"):current_permanent_health_percent() >= 1 then
			return
		end

		if var_78_2 < var_78_0 then
			if Managers.state.network.is_server then
				local var_78_3 = var_78_1.heal_amount

				if HEALTH_ALIVE[arg_78_0] then
					DamageUtils.heal_network(arg_78_0, arg_78_0, var_78_3, "career_passive")
				end
			end

			arg_78_1.next_heal_tick = var_78_0 + var_78_1.time_between_heals
		end
	end,
	markus_huntsman_update_heal_ticks = function (arg_79_0, arg_79_1, arg_79_2, arg_79_3)
		local var_79_0 = arg_79_2.t
		local var_79_1 = arg_79_1.template
		local var_79_2 = arg_79_1.next_heal_tick or 0

		if ScriptUnit.extension(arg_79_0, "health_system"):current_health_percent() == 1 then
			return
		end

		if var_79_2 < var_79_0 then
			if Managers.state.network.is_server then
				local var_79_3 = var_79_1.heal_amount

				if HEALTH_ALIVE[arg_79_0] then
					DamageUtils.heal_network(arg_79_0, arg_79_0, var_79_3, "buff")
				end
			end

			arg_79_1.next_heal_tick = var_79_0 + var_79_1.time_between_heals
		end
	end,
	delayed_buff_removal = function (arg_80_0, arg_80_1, arg_80_2, arg_80_3)
		if not ALIVE[arg_80_0] then
			return
		end

		local var_80_0 = arg_80_1.template
		local var_80_1 = arg_80_2.t

		if arg_80_1.marked_for_deletion then
			if not arg_80_1.delete_time then
				arg_80_1.delete_time = var_80_1 + var_80_0.deletion_delay
			end

			if var_80_1 > arg_80_1.delete_time then
				local var_80_2 = ScriptUnit.extension(arg_80_0, "buff_system")
				local var_80_3 = var_80_0.reference_buff
				local var_80_4 = var_80_2:get_non_stacking_buff(var_80_3)

				if var_80_4 and var_80_4.buff_list then
					local var_80_5 = table.remove(var_80_4.buff_list)

					if var_80_5 then
						var_80_2:remove_buff(var_80_5)
					end
				end

				arg_80_1.delete_time = nil
				arg_80_1.marked_for_deletion = nil
			end
		end
	end,
	delayed_buff_add = function (arg_81_0, arg_81_1, arg_81_2, arg_81_3)
		if not ALIVE[arg_81_0] then
			return
		end

		local var_81_0 = arg_81_1.template
		local var_81_1 = arg_81_2.t

		if arg_81_1.marked_for_add then
			if not arg_81_1.add_time then
				arg_81_1.add_time = var_81_1 + var_81_0.add_delay
			end

			if var_81_1 > arg_81_1.add_time then
				local var_81_2 = ScriptUnit.extension(arg_81_0, "buff_system")
				local var_81_3 = var_81_0.reference_buff
				local var_81_4 = var_81_2:get_non_stacking_buff(var_81_3)
				local var_81_5 = var_81_0.buff_to_add

				if var_81_2 then
					if not var_81_4.buff_list then
						var_81_4.buff_list = {}
					end

					if var_81_2:num_buff_type(var_81_5) < var_81_4.template.max_sub_buff_stacks then
						var_81_4.buff_list[#var_81_4.buff_list + 1] = var_81_2:add_buff(var_81_5)
					end
				end

				arg_81_1.add_time = nil
				arg_81_1.marked_for_add = nil
			end
		end
	end,
	delayed_single_buff_add = function (arg_82_0, arg_82_1, arg_82_2, arg_82_3)
		if not ALIVE[arg_82_0] then
			return
		end

		local var_82_0 = arg_82_1.template
		local var_82_1 = arg_82_2.t

		if arg_82_1.marked_for_add then
			if not arg_82_1.add_time then
				arg_82_1.add_time = var_82_1 + var_82_0.add_delay
			end

			if var_82_1 > arg_82_1.add_time then
				local var_82_2 = arg_82_1.template.buff_to_add
				local var_82_3 = ScriptUnit.extension(arg_82_0, "buff_system")
				local var_82_4 = Managers.state.network
				local var_82_5 = var_82_4.network_transmit
				local var_82_6 = var_82_4:unit_game_object_id(arg_82_0)
				local var_82_7 = NetworkLookup.buff_templates[var_82_2]

				if var_0_9() then
					var_82_3:add_buff(var_82_2, {
						attacker_unit = arg_82_0
					})
					var_82_5:send_rpc_clients("rpc_add_buff", var_82_6, var_82_7, var_82_6, 0, false)
				else
					var_82_5:send_rpc_server("rpc_add_buff", var_82_6, var_82_7, var_82_6, 0, true)
				end

				arg_82_1.add_time = nil
				arg_82_1.marked_for_add = nil
			end
		end
	end,
	add_buff_stacks_on_movement = function (arg_83_0, arg_83_1, arg_83_2, arg_83_3)
		if not ALIVE[arg_83_0] then
			return
		end

		local var_83_0 = POSITION_LOOKUP[arg_83_0]

		if not arg_83_1.position then
			arg_83_1.position = Vector3Box(var_83_0)
		else
			local var_83_1 = arg_83_1.template
			local var_83_2 = arg_83_1.position:unbox() - var_83_0
			local var_83_3 = Vector3.length(var_83_2)

			if not arg_83_1.distance_moved then
				arg_83_1.distance_moved = 0
			end

			arg_83_1.distance_moved = arg_83_1.distance_moved + var_83_3

			local var_83_4 = ScriptUnit.has_extension(arg_83_0, "talent_system")
			local var_83_5 = false
			local var_83_6 = math.huge

			if var_83_5 then
				var_83_6 = var_83_1.distance_per_stack * 0.7
			else
				var_83_6 = var_83_1.distance_per_stack
			end

			if var_83_6 < arg_83_1.distance_moved then
				local var_83_7 = var_83_1.buff_to_add
				local var_83_8 = ScriptUnit.has_extension(arg_83_0, "buff_system")

				if var_83_8 then
					if not arg_83_1.buff_list then
						arg_83_1.buff_list = {}
					end

					if var_83_8:num_buff_type(var_83_7) < var_83_1.max_sub_buff_stacks then
						arg_83_1.buff_list[#arg_83_1.buff_list + 1] = var_83_8:add_buff(var_83_7)
					end
				end

				arg_83_1.distance_moved = 0
			end

			arg_83_1.position:store(var_83_0)
		end
	end,
	set_stacks_on_stacks = function (arg_84_0, arg_84_1, arg_84_2, arg_84_3)
		local var_84_0 = arg_84_0

		if ALIVE[var_84_0] then
			local var_84_1 = arg_84_1.template
			local var_84_2 = var_84_1.buff_to_check
			local var_84_3 = ScriptUnit.extension(var_84_0, "buff_system")
			local var_84_4 = var_84_3:num_buff_type(var_84_2)

			if not arg_84_1.buff_list then
				arg_84_1.buff_list = {}
			end

			if var_84_4 == #arg_84_1.buff_list then
				return
			end

			local var_84_5 = var_84_1.buff_to_add
			local var_84_6 = var_84_1.parent_stacks_per_stack
			local var_84_7 = #arg_84_1.buff_list
			local var_84_8 = var_84_4 / var_84_6 - var_84_7

			if var_84_8 < 0 then
				local var_84_9 = math.abs(var_84_8)

				for iter_84_0 = 1, var_84_9 do
					local var_84_10 = table.remove(arg_84_1.buff_list)

					var_84_3:remove_buff(var_84_10)
				end
			else
				for iter_84_1 = 1, var_84_8 do
					table.insert(arg_84_1.buff_list, var_84_3:add_buff(var_84_5))
				end
			end
		end
	end,
	update_kerillian_waywatcher_regen = function (arg_85_0, arg_85_1, arg_85_2, arg_85_3)
		local var_85_0 = arg_85_2.t
		local var_85_1 = arg_85_1.template
		local var_85_2 = arg_85_1.next_heal_tick or 0
		local var_85_3 = 0.5

		if var_85_2 < var_85_0 and Unit.alive(arg_85_0) then
			local var_85_4 = ScriptUnit.extension(arg_85_0, "talent_system")
			local var_85_5 = var_85_4:has_talent("kerillian_waywatcher_passive_cooldown_restore", "wood_elf", true)

			if var_85_5 then
				local var_85_6 = 0.05

				ScriptUnit.extension(arg_85_0, "career_system"):reduce_activated_ability_cooldown_percent(var_85_6)
			end

			if Managers.state.network.is_server and not var_85_5 then
				local var_85_7 = ScriptUnit.extension(arg_85_0, "health_system")
				local var_85_8 = ScriptUnit.extension(arg_85_0, "status_system")
				local var_85_9 = var_85_1.heal_amount

				if var_85_4:has_talent("kerillian_waywatcher_improved_regen", "wood_elf", true) then
					var_85_9 = var_85_9 * 1.5
				end

				if HEALTH_ALIVE[arg_85_0] and not var_85_8:is_knocked_down() and not var_85_8:is_assisted_respawning() then
					if var_85_4:has_talent("kerillian_waywatcher_group_regen", "wood_elf", true) then
						local var_85_10 = Managers.state.side.side_by_unit[arg_85_0]

						if not var_85_10 then
							return
						end

						local var_85_11 = var_85_10.PLAYER_AND_BOT_UNITS

						for iter_85_0 = 1, #var_85_11 do
							local var_85_12 = var_85_11[iter_85_0]

							if HEALTH_ALIVE[var_85_12] then
								local var_85_13 = ScriptUnit.extension(var_85_12, "health_system")
								local var_85_14 = ScriptUnit.extension(var_85_12, "status_system")

								if var_85_3 >= var_85_13:current_permanent_health_percent() and not var_85_14:is_knocked_down() and not var_85_14:is_assisted_respawning() then
									DamageUtils.heal_network(var_85_12, arg_85_0, var_85_9, "career_passive")
								end
							end
						end
					elseif var_85_3 >= var_85_7:current_permanent_health_percent() then
						DamageUtils.heal_network(arg_85_0, arg_85_0, var_85_9, "career_passive")
					end
				end
			end

			arg_85_1.next_heal_tick = var_85_0 + var_85_1.time_between_heals
		end
	end,
	remove_moving_through_warpfire = function (arg_86_0, arg_86_1, arg_86_2, arg_86_3)
		local var_86_0 = ScriptUnit.has_extension(arg_86_0, "first_person_system")

		if var_86_0 then
			var_86_0:stop_spawning_screen_particles(arg_86_1.warpfire_particle_id)
		end
	end,
	apply_warpfirethrower_in_face = function (arg_87_0, arg_87_1, arg_87_2, arg_87_3)
		local var_87_0 = Managers.state.difficulty:get_difficulty()
		local var_87_1 = arg_87_1.template

		arg_87_1.damage = var_87_1.difficulty_damage[var_87_0]

		local var_87_2 = Unit.get_data(arg_87_0, "breed")

		arg_87_1.armor_type = var_87_2.armor_category or 1

		local var_87_3 = ScriptUnit.has_extension(arg_87_0, "first_person_system")

		if var_87_3 then
			arg_87_1.warpfire_particle_id = var_87_3:create_screen_particles("fx/screenspace_warpfire_flamethrower_01")
			arg_87_1.warpfire_particle_id_2 = var_87_3:create_screen_particles("fx/screenspace_warpfire_hit_inface")

			var_87_3:play_hud_sound_event("Play_player_hit_warpfire_thrower")
		end

		local var_87_4
		local var_87_5 = arg_87_2.attacker_unit
		local var_87_6 = 0

		if ALIVE[var_87_5] then
			local var_87_7 = Unit.get_data(var_87_5, "breed")

			arg_87_1.damage_source = var_87_7 and var_87_7.name or "dot_debuff"

			local var_87_8 = POSITION_LOOKUP[arg_87_0] - POSITION_LOOKUP[var_87_5]

			var_87_4 = Vector3.normalize(var_87_8)
			var_87_6 = Vector3.length(var_87_8)
		else
			var_87_4 = Vector3.backward()
		end

		if var_87_2.is_hero and var_87_3 then
			local var_87_9 = ScriptUnit.has_extension(arg_87_0, "buff_system")
			local var_87_10 = ScriptUnit.has_extension(arg_87_0, "status_system")

			if not (var_87_9 and var_87_9:has_buff_perk("no_ranged_knockback")) and not var_87_10:is_disabled() then
				local var_87_11 = ScriptUnit.extension(arg_87_0, "locomotion_system")
				local var_87_12 = var_87_1.push_speed
				local var_87_13 = var_87_4 * math.max(0, var_87_12 - var_87_6)

				var_87_11:add_external_velocity(var_87_13)
			end
		end
	end,
	update_warpfirethrower_in_face = function (arg_88_0, arg_88_1, arg_88_2, arg_88_3)
		local var_88_0 = arg_88_2.t
		local var_88_1 = arg_88_1.template

		if Managers.state.network.is_server then
			local var_88_2 = ALIVE[arg_88_2.attacker_unit]

			if not var_88_2 or not arg_88_2.attacker_unit then
				local var_88_3 = arg_88_0
			end

			local var_88_4 = arg_88_2.attacker_unit
			local var_88_5 = ScriptUnit.has_extension(arg_88_0, "buff_system"):has_buff_perk("power_block")
			local var_88_6 = false

			if var_88_5 then
				var_88_6 = var_0_11(arg_88_0, var_88_4, arg_88_1, arg_88_2, arg_88_3)
			end

			if (not var_88_6 or not DamageUtils.check_ranged_block(var_88_4, arg_88_0, "blocked_berzerker")) and HEALTH_ALIVE[arg_88_0] then
				local var_88_7 = arg_88_1.armor_type
				local var_88_8 = var_88_1.damage_type
				local var_88_9 = arg_88_1.damage[var_88_7]
				local var_88_10 = arg_88_1.damage_source

				DamageUtils.add_damage_network(arg_88_0, var_88_4, var_88_9, "torso", var_88_8, nil, Vector3(1, 0, 0), var_88_10, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, 1)
			end

			local var_88_11 = not DamageUtils.is_enemy(var_88_4, arg_88_0)
			local var_88_12 = HEALTH_ALIVE[arg_88_0]

			if var_88_2 and var_88_11 and var_88_12 then
				QuestSettings.check_num_enemies_killed_by_warpfire(arg_88_0, var_88_4)
			end
		end

		return var_88_0 + var_88_1.time_between_dot_damages
	end,
	remove_warpfirethrower_in_face = function (arg_89_0, arg_89_1, arg_89_2, arg_89_3)
		local var_89_0 = ScriptUnit.has_extension(arg_89_0, "first_person_system")

		if var_89_0 then
			var_89_0:stop_spawning_screen_particles(arg_89_1.warpfire_particle_id)
			var_89_0:stop_spawning_screen_particles(arg_89_1.warpfire_particle_id_2)
			var_89_0:play_hud_sound_event("Stop_player_hit_warpfire_thrower")
		end
	end,
	apply_warpfire_in_face = function (arg_90_0, arg_90_1, arg_90_2, arg_90_3)
		local var_90_0 = Managers.state.difficulty:get_difficulty()
		local var_90_1 = arg_90_1.template

		arg_90_1.damage = var_90_1.difficulty_damage[var_90_0]
		arg_90_1.armor_type = Unit.get_data(arg_90_0, "breed").armor_category or 1

		local var_90_2 = Managers.player:owner(arg_90_0)

		if var_90_2.remote or var_90_2.bot_player or false then
			CosmeticsUtils.flow_event_mesh_3p(arg_90_0, "impact_warpfire")
		end

		local var_90_3 = ScriptUnit.has_extension(arg_90_0, "first_person_system")

		if var_90_3 then
			arg_90_1.warpfire_particle_id = var_90_3:create_screen_particles("fx/screenspace_warpfire_hit_inface")

			var_90_3:play_hud_sound_event("Play_player_hit_warpfire_thrower")
		end

		local var_90_4
		local var_90_5 = arg_90_2.attacker_unit

		if ALIVE[var_90_5] then
			local var_90_6 = Unit.get_data(var_90_5, "breed")

			arg_90_1.damage_source = var_90_6 and var_90_6.name or "dot_debuff"

			local var_90_7 = POSITION_LOOKUP[arg_90_0] - POSITION_LOOKUP[var_90_5]

			var_90_4 = Vector3.normalize(var_90_7)
		else
			var_90_4 = Vector3.backward()
		end

		if var_90_3 then
			local var_90_8 = ScriptUnit.has_extension(arg_90_0, "buff_system")

			if not (var_90_8 and var_90_8:has_buff_perk("no_ranged_knockback")) then
				local var_90_9 = ScriptUnit.extension(arg_90_0, "locomotion_system")
				local var_90_10 = var_90_4 * var_90_1.push_speed

				var_90_9:add_external_velocity(var_90_10)
			end
		end
	end,
	update_warpfire_in_face = function (arg_91_0, arg_91_1, arg_91_2, arg_91_3)
		local var_91_0 = arg_91_2.t
		local var_91_1 = arg_91_1.template

		if Managers.state.network.is_server then
			local var_91_2 = ALIVE[arg_91_2.attacker_unit] and arg_91_2.attacker_unit or arg_91_0

			if HEALTH_ALIVE[arg_91_0] then
				local var_91_3 = arg_91_1.armor_type
				local var_91_4 = var_91_1.damage_type
				local var_91_5 = arg_91_1.damage[var_91_3]
				local var_91_6 = arg_91_1.damage_source

				DamageUtils.add_damage_network(arg_91_0, var_91_2, var_91_5, "torso", var_91_4, nil, Vector3(1, 0, 0), var_91_6, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, 1)
			end
		end

		local var_91_7 = ScriptUnit.has_extension(arg_91_0, "first_person_system")

		if var_91_7 then
			var_91_7:play_hud_sound_event("Play_player_damage_puke")
		end

		return var_91_0 + var_91_1.time_between_dot_damages
	end,
	remove_warpfire_in_face = function (arg_92_0, arg_92_1, arg_92_2, arg_92_3)
		local var_92_0 = ScriptUnit.has_extension(arg_92_0, "first_person_system")

		if var_92_0 then
			var_92_0:stop_spawning_screen_particles(arg_92_1.warpfire_particle_id)
			var_92_0:play_hud_sound_event("Stop_player_hit_warpfire_thrower")
		end
	end,
	start_aoe_buff = function (arg_93_0, arg_93_1, arg_93_2)
		local var_93_0 = arg_93_1.template

		if var_93_0.target == "enemies" and Managers.state.network.is_server then
			table.clear(var_0_6)

			local var_93_1 = Managers.state.entity:system("ai_system").broadphase
			local var_93_2 = POSITION_LOOKUP[arg_93_0]
			local var_93_3 = var_93_0.range
			local var_93_4 = Broadphase.query(var_93_1, var_93_2, var_93_3, var_0_6)
			local var_93_5 = var_93_0.buff

			for iter_93_0 = 1, var_93_4 do
				local var_93_6 = var_0_6[iter_93_0]
				local var_93_7 = ScriptUnit.has_extension(var_93_6, "buff_system")

				if var_93_7 then
					table.clear(var_0_5)

					var_0_5.attacker_unit = arg_93_0

					var_93_7:add_buff(var_93_5, var_0_5)
				end
			end
		end

		arg_93_1.reapply_t = arg_93_2.t + var_93_0.reapply_rate
	end,
	reapply_aoe_buff = function (arg_94_0, arg_94_1, arg_94_2)
		if arg_94_1.reapply_t <= arg_94_2.t then
			local var_94_0 = arg_94_1.template

			if var_94_0.target == "enemies" and Managers.state.network.is_server then
				table.clear(var_0_6)

				local var_94_1 = Managers.state.entity:system("ai_system").broadphase
				local var_94_2 = POSITION_LOOKUP[arg_94_0]
				local var_94_3 = var_94_0.range
				local var_94_4 = Broadphase.query(var_94_1, var_94_2, var_94_3, var_0_6)
				local var_94_5 = var_94_0.buff

				for iter_94_0 = 1, var_94_4 do
					local var_94_6 = var_0_6[iter_94_0]
					local var_94_7 = ScriptUnit.has_extension(var_94_6, "buff_system")

					if var_94_7 then
						table.clear(var_0_5)

						var_0_5.attacker_unit = var_94_6

						var_94_7:add_buff(var_94_5, var_0_5)
					end
				end
			end

			arg_94_1.reapply_t = arg_94_2.t + var_94_0.reapply_rate
		end
	end,
	remove_aoe_buff = function (arg_95_0, arg_95_1, arg_95_2)
		return
	end,
	add_buff_local = function (arg_96_0, arg_96_1, arg_96_2)
		local var_96_0 = arg_96_1.template
		local var_96_1 = ScriptUnit.has_extension(arg_96_0, "buff_system")
		local var_96_2 = var_96_0.buffs_to_add

		if var_96_2 then
			for iter_96_0 = 1, #var_96_2 do
				local var_96_3 = var_96_2[1]

				var_96_1:add_buff(var_96_3)
			end
		else
			local var_96_4 = var_96_0.buff_to_add

			var_96_1:add_buff(var_96_4)
		end
	end,
	remove_buff_local = function (arg_97_0, arg_97_1, arg_97_2)
		local var_97_0 = arg_97_1.template.buff_to_remove
		local var_97_1 = ScriptUnit.extension(arg_97_0, "buff_system")
		local var_97_2 = var_97_1:get_buff_type(var_97_0)

		if var_97_2 then
			var_97_1:remove_buff(var_97_2.id)
		end
	end,
	add_buff_synced = function (arg_98_0, arg_98_1, arg_98_2)
		local var_98_0 = arg_98_1.template

		if var_98_0.ignore_if_client and not Managers.state.network.is_server then
			return
		end

		if var_98_0.ignore_if_not_local then
			local var_98_1 = Managers.player:owner(arg_98_0)

			if not var_98_1 or var_98_1:network_id() ~= Network.peer_id() then
				return
			end
		end

		local var_98_2 = var_98_0.sync_type
		local var_98_3

		if var_98_2 == BuffSyncType.Client or var_98_2 == BuffSyncType.ClientAndServer then
			local var_98_4 = Managers.player:owner(arg_98_0)

			if not var_98_4 then
				print(string.format("Tried adding peer_id requiring buff on a unit which no peer owns. Defaulting to own peer_id. (%s)", var_98_0.name))
			end

			var_98_3 = var_98_4 and var_98_4.peer_id or Network.peer_id()
		end

		local var_98_5 = Managers.state.entity:system("buff_system")
		local var_98_6 = var_98_0.synced_buffs_to_add

		if var_98_6 then
			for iter_98_0 = 1, #var_98_6 do
				local var_98_7 = var_98_6[iter_98_0]

				var_98_5:add_buff_synced(arg_98_0, var_98_7, var_98_2, nil, var_98_3)
			end
		else
			local var_98_8 = var_98_0.synced_buff_to_add

			var_98_5:add_buff_synced(arg_98_0, var_98_8, var_98_2, nil, var_98_3)
		end
	end,
	remove_buff_synced = function (arg_99_0, arg_99_1, arg_99_2)
		if arg_99_1.template.ignore_if_client and not Managers.state.network.is_server then
			return
		end

		local var_99_0 = arg_99_1.template.synced_buff_to_remove
		local var_99_1 = ScriptUnit.extension(arg_99_0, "buff_system"):get_buff_type(var_99_0)

		if var_99_1 then
			Managers.state.entity:system("buff_system"):remove_buff_synced(arg_99_0, var_99_1.id)
		end
	end,
	add_buff_server_controlled = function (arg_100_0, arg_100_1, arg_100_2)
		if not Managers.state.network:game() then
			return
		end

		if Unit.alive(arg_100_0) then
			local var_100_0 = arg_100_1.template.buff_to_add

			if ScriptUnit.has_extension(arg_100_0, "buff_system"):num_buff_type(var_100_0) < BuffUtils.get_buff_template(var_100_0).buffs[1].max_stacks then
				local var_100_1 = Managers.state.entity:system("buff_system"):add_buff(arg_100_0, var_100_0, arg_100_0, true)

				if not arg_100_1.server_buff_ids then
					arg_100_1.server_buff_ids = {
						var_100_1
					}
				else
					arg_100_1.server_buff_ids[#arg_100_1.server_buff_ids + 1] = var_100_1
				end
			end
		end
	end,
	remove_buff_server_controlled = function (arg_101_0, arg_101_1, arg_101_2)
		if not Managers.state.network:game() then
			return
		end

		if Unit.alive(arg_101_0) then
			local var_101_0 = arg_101_1.template.buff_to_add
			local var_101_1 = arg_101_1.server_buff_ids

			if var_101_1 then
				local var_101_2 = Managers.state.entity:system("buff_system")

				for iter_101_0 = 1, #var_101_1 do
					local var_101_3 = var_101_1[iter_101_0]

					var_101_2:remove_server_controlled_buff(arg_101_0, var_101_3)
				end

				arg_101_1.server_buff_ids = nil
			end
		end
	end,
	add_buffs = function (arg_102_0, arg_102_1, arg_102_2)
		if Unit.alive(arg_102_0) then
			local var_102_0 = arg_102_1.template.add_buffs_data

			if var_102_0 then
				local var_102_1 = var_102_0.buffs_to_add

				if var_102_1 then
					local var_102_2 = Managers.state.entity:system("buff_system")
					local var_102_3 = var_102_0.sync_buffs and BuffSyncType.LocalAndServer or BuffSyncType.Local

					for iter_102_0 = 1, #var_102_1 do
						var_102_2:add_buff_synced(arg_102_0, var_102_1[iter_102_0], var_102_3)
					end
				end
			end
		end
	end,
	remove_buffs = function (arg_103_0, arg_103_1, arg_103_2)
		if Unit.alive(arg_103_0) then
			local var_103_0 = arg_103_1.template.remove_buffs_data

			if var_103_0 then
				local var_103_1 = var_103_0.buffs_to_remove

				if var_103_1 then
					local var_103_2 = ScriptUnit.has_extension(arg_103_0, "buff_system")

					if var_103_2 then
						for iter_103_0 = 1, #var_103_1 do
							local var_103_3 = var_103_2:get_non_stacking_buff(var_103_1[iter_103_0])

							if var_103_3 then
								var_103_2:remove_buff(var_103_3.id)
							end
						end
					end
				end
			end
		end
	end,
	remove_buff_stack = function (arg_104_0, arg_104_1, arg_104_2)
		if Unit.alive(arg_104_0) then
			local var_104_0 = ScriptUnit.has_extension(arg_104_0, "buff_system")

			if var_104_0 then
				local var_104_1 = arg_104_1.template
				local var_104_2 = var_104_1.remove_buff_stack_data

				for iter_104_0 = 1, #var_104_2 do
					local var_104_3 = var_104_2[iter_104_0]
					local var_104_4 = var_104_3.buff_to_remove
					local var_104_5 = var_104_3.num_stacks or 1

					if var_104_3.server_controlled then
						fassert(var_104_4 == var_104_1.buff_to_add, "Trying to remove different type of server controlled buff, only same types are allowed right now.")

						local var_104_6 = Managers.state.entity:system("buff_system")
						local var_104_7 = arg_104_1.server_buff_ids

						var_104_5 = var_104_7 and math.min(#var_104_7, var_104_5) or 0

						for iter_104_1 = 1, var_104_5 do
							local var_104_8 = table.remove(var_104_7)

							var_104_6:remove_server_controlled_buff(arg_104_0, var_104_8)
						end
					else
						for iter_104_2 = 1, var_104_5 do
							local var_104_9 = var_104_0:get_buff_type(var_104_4)

							if not var_104_9 then
								break
							end

							var_104_0:remove_buff(var_104_9.id)
						end
					end

					if var_104_3.reset_update_timer then
						arg_104_1._next_update_t = Managers.time:time("game") + (var_104_1.update_frequency or 0)
					end
				end
			end
		end
	end,
	add_health_on_application = function (arg_105_0, arg_105_1, arg_105_2)
		if Unit.alive(arg_105_0) and Managers.state.network.is_server then
			local var_105_0 = arg_105_1.template.heal_amount

			DamageUtils.heal_network(arg_105_0, arg_105_0, var_105_0, "career_passive")
		end
	end,
	kerillian_maidenguard_add_power_buff_on_unharmed = function (arg_106_0, arg_106_1, arg_106_2)
		if not var_0_9() then
			return
		end

		if not Managers.state.network:game() then
			return
		end

		if Unit.alive(arg_106_0) then
			local var_106_0 = arg_106_1.template.buff_to_add

			Managers.state.entity:system("buff_system"):add_buff(arg_106_0, var_106_0, arg_106_0, false)
		end
	end,
	update_multiplier_based_on_enemy_proximity = function (arg_107_0, arg_107_1, arg_107_2)
		local var_107_0 = Managers.state.entity:system("ai_system").broadphase
		local var_107_1 = arg_107_1.template
		local var_107_2 = arg_107_1.range
		local var_107_3 = var_107_1.min_multiplier
		local var_107_4 = var_107_1.max_multiplier
		local var_107_5 = var_107_1.chunk_size
		local var_107_6 = var_107_1.stat_buff
		local var_107_7 = arg_107_1.previous_multiplier or 0
		local var_107_8 = POSITION_LOOKUP[arg_107_0]

		table.clear(var_0_6)

		local var_107_9 = Broadphase.query(var_107_0, var_107_8, var_107_2, var_0_6)
		local var_107_10 = 0

		for iter_107_0 = 1, var_107_9 do
			local var_107_11 = var_0_6[iter_107_0]

			if HEALTH_ALIVE[var_107_11] then
				var_107_10 = var_107_10 + 1
			end
		end

		local var_107_12 = math.floor(var_107_10 / var_107_5) * var_107_3

		if var_107_4 < var_107_12 then
			var_107_12 = var_107_4
		end

		arg_107_1.multiplier = var_107_12

		if var_107_7 ~= var_107_12 and var_107_6 then
			local var_107_13 = ScriptUnit.extension(arg_107_0, "buff_system")
			local var_107_14 = var_107_12 - var_107_7

			var_107_13:update_stat_buff(var_107_6, var_107_14, var_107_1.name)
		end

		arg_107_1.previous_multiplier = var_107_12
	end,
	update_bonus_based_on_enemy_proximity = function (arg_108_0, arg_108_1, arg_108_2)
		local var_108_0 = Managers.state.entity:system("ai_system").broadphase
		local var_108_1 = arg_108_1.template
		local var_108_2 = arg_108_1.range
		local var_108_3 = var_108_1.min_bonus
		local var_108_4 = var_108_1.max_bonus
		local var_108_5 = var_108_1.chunk_size
		local var_108_6 = var_108_1.stat_buff
		local var_108_7 = arg_108_1.previous_bonus or 0
		local var_108_8 = POSITION_LOOKUP[arg_108_0]

		table.clear(var_0_6)

		local var_108_9 = Broadphase.query(var_108_0, var_108_8, var_108_2, var_0_6)
		local var_108_10 = 0

		for iter_108_0 = 1, var_108_9 do
			local var_108_11 = var_0_6[iter_108_0]

			if HEALTH_ALIVE[var_108_11] then
				var_108_10 = var_108_10 + 1
			end
		end

		local var_108_12 = math.floor(var_108_10 / var_108_5) * var_108_3

		if var_108_4 < var_108_12 then
			var_108_12 = var_108_4
		end

		arg_108_1.bonus = var_108_12

		if var_108_7 ~= var_108_12 and var_108_6 then
			local var_108_13 = ScriptUnit.extension(arg_108_0, "buff_system")
			local var_108_14 = var_108_12 - var_108_7

			var_108_13:update_stat_buff(var_108_6, var_108_14, var_108_1.name)
		end

		arg_108_1.previous_bonus = var_108_12
	end,
	activate_buff_stacks_based_on_enemy_proximity = function (arg_109_0, arg_109_1, arg_109_2)
		if not Managers.state.network.is_server then
			return
		end

		local var_109_0 = Managers.state.side.side_by_unit[arg_109_0]

		if not var_109_0 then
			return
		end

		local var_109_1 = Managers.state.entity:system("ai_system").broadphase
		local var_109_2 = ScriptUnit.extension(arg_109_0, "buff_system")
		local var_109_3 = Managers.state.entity:system("buff_system")
		local var_109_4 = arg_109_1.template
		local var_109_5 = arg_109_1.range
		local var_109_6 = var_109_4.chunk_size
		local var_109_7 = var_109_4.buff_to_add
		local var_109_8 = 5
		local var_109_9 = POSITION_LOOKUP[arg_109_0]
		local var_109_10 = var_109_0.enemy_broadphase_categories
		local var_109_11 = Broadphase.query(var_109_1, var_109_9, var_109_5, var_0_6, var_109_10)
		local var_109_12 = 0

		for iter_109_0 = 1, var_109_11 do
			local var_109_13 = var_0_6[iter_109_0]

			if HEALTH_ALIVE[var_109_13] then
				var_109_12 = var_109_12 + 1

				if math.floor(var_109_12 / var_109_6) == var_109_8 then
					break
				end
			end
		end

		if not arg_109_1.stack_ids then
			arg_109_1.stack_ids = {}
		end

		local var_109_14 = math.floor(var_109_12 / var_109_6)
		local var_109_15 = var_109_2:num_buff_type(var_109_7)

		if var_109_15 < var_109_14 then
			local var_109_16 = var_109_14 - var_109_15

			for iter_109_1 = 1, var_109_16 do
				local var_109_17 = var_109_3:add_buff(arg_109_0, var_109_7, arg_109_0, true)
				local var_109_18 = arg_109_1.stack_ids

				var_109_18[#var_109_18 + 1] = var_109_17
			end
		elseif var_109_14 < var_109_15 then
			local var_109_19 = var_109_15 - var_109_14

			for iter_109_2 = 1, var_109_19 do
				local var_109_20 = arg_109_1.stack_ids
				local var_109_21 = table.remove(var_109_20, 1)

				var_109_3:remove_server_controlled_buff(arg_109_0, var_109_21)
			end
		end
	end,
	activate_buff_stacks_based_on_ally_proximity = function (arg_110_0, arg_110_1, arg_110_2)
		if not Managers.state.network.is_server then
			return
		end

		if not ALIVE[arg_110_0] then
			return
		end

		local var_110_0 = ScriptUnit.extension(arg_110_0, "buff_system")
		local var_110_1 = Managers.state.entity:system("buff_system")
		local var_110_2 = arg_110_1.template
		local var_110_3 = arg_110_1.range
		local var_110_4 = var_110_3 * var_110_3
		local var_110_5 = var_110_2.chunk_size
		local var_110_6 = var_110_2.buff_to_add
		local var_110_7 = var_110_2.max_stacks
		local var_110_8 = Managers.state.side.side_by_unit[arg_110_0]
		local var_110_9 = var_110_8 and var_110_8.PLAYER_AND_BOT_UNITS
		local var_110_10 = POSITION_LOOKUP[arg_110_0]
		local var_110_11 = 0
		local var_110_12 = var_110_9 and #var_110_9 or 0

		for iter_110_0 = 1, var_110_12 do
			local var_110_13 = var_110_9[iter_110_0]

			if var_110_13 ~= arg_110_0 then
				local var_110_14 = POSITION_LOOKUP[var_110_13]

				if var_110_4 > Vector3.distance_squared(var_110_10, var_110_14) then
					var_110_11 = var_110_11 + 1
				end

				if math.floor(var_110_11 / var_110_5) == var_110_7 then
					break
				end
			end
		end

		if not arg_110_1.stack_ids then
			arg_110_1.stack_ids = {}
		end

		local var_110_15 = math.floor(var_110_11 / var_110_5)
		local var_110_16 = var_110_0:num_buff_type(var_110_6)

		if var_110_16 < var_110_15 then
			local var_110_17 = var_110_15 - var_110_16

			for iter_110_1 = 1, var_110_17 do
				local var_110_18 = var_110_1:add_buff(arg_110_0, var_110_6, arg_110_0, true)
				local var_110_19 = arg_110_1.stack_ids

				var_110_19[#var_110_19 + 1] = var_110_18
			end
		elseif var_110_15 < var_110_16 then
			local var_110_20 = var_110_16 - var_110_15

			for iter_110_2 = 1, var_110_20 do
				local var_110_21 = arg_110_1.stack_ids
				local var_110_22 = table.remove(var_110_21, 1)

				var_110_1:remove_server_controlled_buff(arg_110_0, var_110_22)
			end
		end
	end,
	update_multiplier_based_on_enemy_proximity = function (arg_111_0, arg_111_1, arg_111_2)
		local var_111_0 = Managers.state.entity:system("ai_system").broadphase
		local var_111_1 = arg_111_1.template
		local var_111_2 = arg_111_1.range
		local var_111_3 = var_111_1.min_multiplier
		local var_111_4 = var_111_1.max_multiplier
		local var_111_5 = var_111_1.chunk_size
		local var_111_6 = var_111_1.stat_buff
		local var_111_7 = arg_111_1.previous_multiplier or 0
		local var_111_8 = POSITION_LOOKUP[arg_111_0]

		table.clear(var_0_6)

		local var_111_9 = Broadphase.query(var_111_0, var_111_8, var_111_2, var_0_6)
		local var_111_10 = 0

		for iter_111_0 = 1, var_111_9 do
			local var_111_11 = var_0_6[iter_111_0]

			if HEALTH_ALIVE[var_111_11] then
				var_111_10 = var_111_10 + 1
			end
		end

		local var_111_12 = math.floor(var_111_10 / var_111_5) * var_111_3

		if var_111_4 < var_111_12 then
			var_111_12 = var_111_4
		end

		arg_111_1.multiplier = var_111_12

		if var_111_7 ~= var_111_12 and var_111_6 then
			local var_111_13 = ScriptUnit.extension(arg_111_0, "buff_system")
			local var_111_14 = var_111_12 - var_111_7

			var_111_13:update_stat_buff(var_111_6, var_111_14, var_111_1.name)
		end

		arg_111_1.previous_multiplier = var_111_12
	end,
	activate_buff_stacks_based_on_overcharge_chunks = function (arg_112_0, arg_112_1, arg_112_2)
		if var_0_7(arg_112_0) then
			local var_112_0 = ScriptUnit.extension(arg_112_0, "overcharge_system")
			local var_112_1 = ScriptUnit.extension(arg_112_0, "buff_system")
			local var_112_2, var_112_3, var_112_4 = var_112_0:current_overcharge_status()
			local var_112_5 = arg_112_1.template
			local var_112_6 = var_112_5.chunk_size
			local var_112_7 = var_112_5.buff_to_add
			local var_112_8 = var_112_5.max_stacks

			if not arg_112_1.stack_ids then
				arg_112_1.stack_ids = {}
			end

			local var_112_9 = math.min(math.floor(var_112_2 / var_112_6), var_112_8)
			local var_112_10 = var_112_1:num_buff_type(var_112_7)

			if var_112_10 < var_112_9 then
				local var_112_11 = var_112_9 - var_112_10

				for iter_112_0 = 1, var_112_11 do
					local var_112_12 = var_112_1:add_buff(var_112_7)
					local var_112_13 = arg_112_1.stack_ids

					var_112_13[#var_112_13 + 1] = var_112_12
				end
			elseif var_112_9 < var_112_10 then
				local var_112_14 = var_112_10 - var_112_9

				for iter_112_1 = 1, var_112_14 do
					local var_112_15 = arg_112_1.stack_ids
					local var_112_16 = table.remove(var_112_15, 1)

					var_112_1:remove_buff(var_112_16)
				end
			end
		end
	end,
	activate_server_buff_stacks_based_on_overcharge_chunks = function (arg_113_0, arg_113_1, arg_113_2)
		if not Managers.state.network.is_server then
			return
		end

		local var_113_0 = ScriptUnit.extension(arg_113_0, "overcharge_system")
		local var_113_1 = Managers.state.entity:system("buff_system")
		local var_113_2, var_113_3, var_113_4 = var_113_0:current_overcharge_status()
		local var_113_5 = arg_113_1.template
		local var_113_6 = var_113_5.chunk_size
		local var_113_7 = var_113_5.buff_to_add
		local var_113_8 = var_113_5.max_sub_buff_stacks or 5

		if not arg_113_1.stack_server_ids then
			arg_113_1.stack_server_ids = {}
		end

		local var_113_9 = arg_113_1.stack_server_ids
		local var_113_10 = math.min(math.floor(var_113_2 / var_113_6), var_113_8)
		local var_113_11 = #arg_113_1.stack_server_ids

		if var_113_11 < var_113_10 then
			local var_113_12 = var_113_10 - var_113_11

			for iter_113_0 = 1, var_113_12 do
				local var_113_13 = var_113_1:add_buff(arg_113_0, var_113_7, arg_113_0, true)

				var_113_9[#var_113_9 + 1] = var_113_13
			end
		elseif var_113_10 < var_113_11 then
			local var_113_14 = var_113_11 - var_113_10

			for iter_113_1 = 1, var_113_14 do
				local var_113_15 = table.remove(var_113_9, 1)

				var_113_1:remove_server_controlled_buff(arg_113_0, var_113_15)
			end
		end
	end,
	activate_buff_stacks_based_on_health_chunks = function (arg_114_0, arg_114_1, arg_114_2)
		if not Managers.state.network.is_server then
			return
		end

		local var_114_0 = ScriptUnit.extension(arg_114_0, "health_system")
		local var_114_1 = ScriptUnit.extension(arg_114_0, "buff_system")
		local var_114_2 = Managers.state.entity:system("buff_system")
		local var_114_3 = arg_114_1.template
		local var_114_4 = var_114_3.buff_to_add
		local var_114_5 = var_114_3.chunk_size
		local var_114_6 = var_114_0:get_damage_taken("uncursed_max_health")
		local var_114_7 = var_114_0:get_uncursed_max_health()
		local var_114_8 = math.min(math.floor(var_114_7 / var_114_5) - 1, var_114_3.max_stacks)
		local var_114_9 = math.floor(var_114_6 / var_114_5)
		local var_114_10 = math.min(var_114_8, var_114_9)
		local var_114_11 = var_114_1:num_buff_type(var_114_4)

		if not arg_114_1.stack_ids then
			arg_114_1.stack_ids = {}
		end

		if var_114_11 < var_114_10 then
			local var_114_12 = var_114_10 - var_114_11

			for iter_114_0 = 1, var_114_12 do
				local var_114_13 = var_114_2:add_buff(arg_114_0, var_114_4, arg_114_0, true)
				local var_114_14 = arg_114_1.stack_ids

				var_114_14[#var_114_14 + 1] = var_114_13
			end
		elseif var_114_10 < var_114_11 then
			local var_114_15 = var_114_11 - var_114_10

			for iter_114_1 = 1, var_114_15 do
				local var_114_16 = arg_114_1.stack_ids
				local var_114_17 = table.remove(var_114_16, 1)

				var_114_2:remove_server_controlled_buff(arg_114_0, var_114_17)
			end
		end
	end,
	victor_zealot_activate_buff_stacks_based_on_health_percent = function (arg_115_0, arg_115_1, arg_115_2)
		if Unit.alive(arg_115_0) then
			local var_115_0 = ScriptUnit.extension(arg_115_0, "health_system")
			local var_115_1 = ScriptUnit.extension(arg_115_0, "buff_system")
			local var_115_2 = Managers.state.entity:system("buff_system")
			local var_115_3 = arg_115_1.template
			local var_115_4 = var_115_3.threshold_1
			local var_115_5 = var_115_3.threshold_2
			local var_115_6 = var_115_0:get_buffed_max_health()
			local var_115_7 = var_115_0:current_permanent_health() / var_115_6

			if not arg_115_1.stack_ids then
				arg_115_1.stack_ids = {}
			end

			if #arg_115_1.stack_ids > 0 and var_115_5 < var_115_7 then
				if #arg_115_1.stack_ids > 1 or var_115_4 < var_115_7 then
					local var_115_8 = table.remove(arg_115_1.stack_ids, 1)

					var_115_2:remove_server_controlled_buff(arg_115_0, var_115_8)
				end
			elseif var_115_7 < var_115_4 then
				local var_115_9 = var_115_3.buff_to_add
				local var_115_10 = var_115_1:num_buff_type(var_115_9)
				local var_115_11 = false

				if var_115_7 < var_115_5 then
					var_115_11 = true
				end

				if var_115_10 < 1 or var_115_11 and var_115_10 == 1 then
					local var_115_12 = var_115_2:add_buff(arg_115_0, var_115_9, arg_115_0, true)

					arg_115_1.stack_ids[#arg_115_1.stack_ids + 1] = var_115_12
				end
			end
		end
	end,
	activate_buff_stacks_based_on_clip_size = function (arg_116_0, arg_116_1, arg_116_2)
		if not Managers.state.network.is_server then
			return
		end

		if Unit.alive(arg_116_0) then
			local var_116_0 = ScriptUnit.extension(arg_116_0, "buff_system")
			local var_116_1 = arg_116_1.template.buff_to_add
			local var_116_2 = ScriptUnit.has_extension(arg_116_0, "inventory_system"):get_slot_data("slot_ranged")
			local var_116_3 = Managers.state.entity:system("buff_system")
			local var_116_4 = 1

			if var_116_2 then
				local var_116_5 = BackendUtils.get_item_template(var_116_2.item_data)
				local var_116_6 = var_116_5 and var_116_5.ammo_data
				local var_116_7 = var_116_6 and var_116_6.ammo_per_clip

				if var_116_7 and var_116_4 < var_116_7 then
					var_116_4 = var_116_7
				end

				local var_116_8 = var_116_4
				local var_116_9 = var_116_0:num_buff_type(var_116_1)

				if not arg_116_1.stack_ids then
					arg_116_1.stack_ids = {}
				end

				if var_116_9 < var_116_8 then
					local var_116_10 = var_116_8 - var_116_9

					for iter_116_0 = 1, var_116_10 do
						local var_116_11 = var_116_3:add_buff(arg_116_0, var_116_1, arg_116_0, true)
						local var_116_12 = arg_116_1.stack_ids

						var_116_12[#var_116_12 + 1] = var_116_11
					end
				elseif var_116_8 < var_116_9 then
					local var_116_13 = var_116_9 - var_116_8

					for iter_116_1 = 1, var_116_13 do
						local var_116_14 = arg_116_1.stack_ids
						local var_116_15 = table.remove(var_116_14, 1)

						var_116_3:remove_server_controlled_buff(arg_116_0, var_116_15)
					end
				end
			end
		end
	end,
	remove_buff_stacks_based_on_clip_size = function (arg_117_0, arg_117_1, arg_117_2)
		if not Managers.state.network.is_server then
			return
		end

		if Unit.alive(arg_117_0) then
			local var_117_0 = arg_117_1.template
			local var_117_1 = ScriptUnit.has_extension(arg_117_0, "buff_system")
			local var_117_2 = Managers.state.entity:system("buff_system")
			local var_117_3 = var_117_0.buff_to_add
			local var_117_4 = arg_117_1.stack_ids

			if var_117_1:has_buff_type(var_117_3) and var_117_4 then
				for iter_117_0 = 1, #var_117_4 do
					local var_117_5 = var_117_4[iter_117_0]

					var_117_2:remove_server_controlled_buff(arg_117_0, var_117_5)
				end

				arg_117_1.stack_ids = nil
			end
		end
	end,
	pause_activated_ability = function (arg_118_0, arg_118_1, arg_118_2)
		if Unit.alive(arg_118_0) then
			local var_118_0 = ScriptUnit.has_extension(arg_118_0, "career_system")

			if var_118_0 then
				var_118_0:start_activated_ability_cooldown()
				var_118_0:set_activated_ability_cooldown_paused()
			end
		end
	end,
	unpause_activated_ability = function (arg_119_0, arg_119_1, arg_119_2)
		if Unit.alive(arg_119_0) then
			local var_119_0 = ScriptUnit.has_extension(arg_119_0, "career_system")

			if var_119_0 then
				var_119_0:set_activated_ability_cooldown_unpaused()
			end
		end
	end,
	activate_buff_on_distance = function (arg_120_0, arg_120_1, arg_120_2)
		if not Managers.state.network.is_server then
			return
		end

		local var_120_0 = arg_120_1.template
		local var_120_1 = arg_120_1.range
		local var_120_2 = var_120_0.disregard_self
		local var_120_3 = var_120_1 * var_120_1
		local var_120_4 = POSITION_LOOKUP[arg_120_0]
		local var_120_5 = var_120_0.buff_to_add
		local var_120_6 = Managers.state.entity:system("buff_system")
		local var_120_7 = Managers.state.side.side_by_unit[arg_120_0]

		if not var_120_7 then
			return
		end

		local var_120_8 = var_120_7.PLAYER_AND_BOT_UNITS
		local var_120_9 = #var_120_8

		for iter_120_0 = 1, var_120_9 do
			local var_120_10 = var_120_8[iter_120_0]

			if Unit.alive(var_120_10) and (not var_120_2 or var_120_10 ~= arg_120_0) then
				local var_120_11 = POSITION_LOOKUP[var_120_10]
				local var_120_12 = Vector3.distance_squared(var_120_4, var_120_11)
				local var_120_13 = ScriptUnit.extension(var_120_10, "buff_system")

				if var_120_3 < var_120_12 then
					local var_120_14 = var_120_13:get_non_stacking_buff(var_120_5)

					if var_120_14 then
						local var_120_15 = var_120_14.server_id

						if var_120_15 then
							var_120_6:remove_server_controlled_buff(var_120_10, var_120_15)
						end
					end
				end

				if var_120_12 < var_120_3 and not var_120_13:has_buff_type(var_120_5) then
					local var_120_16 = var_120_6:add_buff(var_120_10, var_120_5, arg_120_0, true)
					local var_120_17 = var_120_13:get_non_stacking_buff(var_120_5)

					if var_120_17 then
						var_120_17.server_id = var_120_16
					end
				end
			end
		end
	end,
	side_buff_aura = function (arg_121_0, arg_121_1, arg_121_2)
		local var_121_0 = arg_121_1.template

		if var_121_0.server_only and not Managers.state.network.is_server then
			return
		end

		local var_121_1 = Managers.state.side.side_by_unit[arg_121_0]

		if not var_121_1 then
			return
		end

		local var_121_2 = arg_121_1.buffed_units or {}

		arg_121_1.buffed_units = var_121_2

		local var_121_3 = FrameTable.alloc_table()

		if var_121_0.owner_as_source then
			var_121_3.source_attacker_unit = arg_121_0
		end

		local var_121_4 = arg_121_1.range
		local var_121_5 = var_121_4 * var_121_4
		local var_121_6 = POSITION_LOOKUP[arg_121_0]
		local var_121_7 = Managers.state.entity:system("buff_system")
		local var_121_8 = var_121_0.buff_sync_type or BuffSyncType.All
		local var_121_9 = FrameTable.alloc_table()

		if var_121_0.player_buff_name then
			local var_121_10 = var_121_1.PLAYER_AND_BOT_UNITS

			for iter_121_0 = 1, #var_121_10 do
				local var_121_11 = var_121_10[iter_121_0]
				local var_121_12 = var_121_5 > Vector3.distance_squared(var_121_6, POSITION_LOOKUP[var_121_11])
				local var_121_13 = var_121_2[var_121_11]

				if var_121_12 then
					if not var_121_13 then
						var_121_2[var_121_11] = var_121_7:add_buff_synced(var_121_11, var_121_0.player_buff_name, var_121_8, var_121_3)
					end

					var_121_9[var_121_11] = true
				elseif var_121_13 then
					var_121_7:remove_buff_synced(var_121_11, var_121_13)

					var_121_2[var_121_11] = nil
				end
			end
		end

		if var_121_0.ai_buff_name then
			local var_121_14 = var_121_1.ally_broadphase_categories
			local var_121_15 = FrameTable.alloc_table()
			local var_121_16 = AiUtils.broadphase_query(var_121_6, var_121_4, var_121_15, var_121_14)

			for iter_121_1 = 1, var_121_16 do
				local var_121_17 = var_121_15[iter_121_1]

				if not var_121_2[var_121_17] then
					var_121_2[var_121_17] = var_121_7:add_buff_synced(var_121_17, var_121_0.ai_buff_name, var_121_8, var_121_3)
				end

				var_121_9[var_121_17] = true
			end
		end

		for iter_121_2, iter_121_3 in pairs(var_121_2) do
			if not var_121_9[iter_121_2] then
				var_121_7:remove_buff_synced(iter_121_2, iter_121_3)

				var_121_2[iter_121_2] = nil
			end
		end
	end,
	remove_side_buff_aura = function (arg_122_0, arg_122_1, arg_122_2)
		if not arg_122_1.buffed_units then
			return
		end

		local var_122_0 = Managers.state.entity:system("buff_system")

		for iter_122_0, iter_122_1 in pairs(arg_122_1.buffed_units) do
			var_122_0:remove_buff_synced(iter_122_0, iter_122_1)
		end
	end,
	remove_party_buff_stacks = function (arg_123_0, arg_123_1, arg_123_2)
		if not Managers.state.network.is_server or not arg_123_1.stack_ids then
			return
		end

		local var_123_0 = Managers.state.entity:system("buff_system")
		local var_123_1 = Managers.state.side:get_side_from_name("heroes")

		if not var_123_1 then
			return
		end

		local var_123_2 = var_123_1.PLAYER_AND_BOT_UNITS
		local var_123_3 = #var_123_2

		for iter_123_0 = 1, var_123_3 do
			local var_123_4 = var_123_2[iter_123_0]

			if ALIVE[var_123_4] then
				local var_123_5 = ScriptUnit.extension(var_123_4, "buff_system")
				local var_123_6 = arg_123_1.stack_ids[var_123_4]

				if var_123_6 then
					for iter_123_1 = 1, #var_123_6 do
						local var_123_7 = table.remove(var_123_6)

						var_123_0:remove_server_controlled_buff(var_123_4, var_123_7)
					end
				end
			end
		end
	end,
	activate_party_buff_stacks_on_ally_proximity = function (arg_124_0, arg_124_1, arg_124_2)
		if not Managers.state.network.is_server then
			return
		end

		local var_124_0 = Managers.state.entity:system("buff_system")
		local var_124_1 = arg_124_1.template
		local var_124_2 = arg_124_1.range
		local var_124_3 = var_124_2 * var_124_2
		local var_124_4 = var_124_1.chunk_size
		local var_124_5 = var_124_1.buff_to_add
		local var_124_6 = var_124_1.max_stacks
		local var_124_7 = Managers.state.side.side_by_unit[arg_124_0]

		if not var_124_7 then
			return
		end

		local var_124_8 = var_124_7.PLAYER_AND_BOT_UNITS
		local var_124_9 = POSITION_LOOKUP[arg_124_0]
		local var_124_10 = 0
		local var_124_11 = #var_124_8

		for iter_124_0 = 1, var_124_11 do
			local var_124_12 = var_124_8[iter_124_0]

			if var_124_12 ~= arg_124_0 then
				local var_124_13 = POSITION_LOOKUP[var_124_12]

				if var_124_3 > Vector3.distance_squared(var_124_9, var_124_13) then
					var_124_10 = var_124_10 + 1
				end

				if math.floor(var_124_10 / var_124_4) == var_124_6 then
					break
				end
			end
		end

		if not arg_124_1.stack_ids then
			arg_124_1.stack_ids = {}
		end

		for iter_124_1 = 1, var_124_11 do
			local var_124_14 = var_124_8[iter_124_1]

			if ALIVE[var_124_14] then
				if not arg_124_1.stack_ids[var_124_14] then
					arg_124_1.stack_ids[var_124_14] = {}
				end

				local var_124_15 = POSITION_LOOKUP[var_124_14]
				local var_124_16 = Vector3.distance_squared(var_124_9, var_124_15)
				local var_124_17 = ScriptUnit.extension(var_124_14, "buff_system")

				if var_124_3 < var_124_16 then
					local var_124_18 = arg_124_1.stack_ids[var_124_14]

					for iter_124_2 = 1, #var_124_18 do
						local var_124_19 = arg_124_1.stack_ids[var_124_14]
						local var_124_20 = table.remove(var_124_19)

						var_124_0:remove_server_controlled_buff(var_124_14, var_124_20)
					end
				else
					local var_124_21 = math.floor(var_124_10 / var_124_4)
					local var_124_22 = var_124_17:num_buff_type(var_124_5)

					if var_124_22 < var_124_21 then
						local var_124_23 = var_124_21 - var_124_22
						local var_124_24 = arg_124_1.stack_ids[var_124_14]

						for iter_124_3 = 1, var_124_23 do
							local var_124_25 = var_124_0:add_buff(var_124_14, var_124_5, var_124_14, true)

							var_124_24[#var_124_24 + 1] = var_124_25
						end
					elseif var_124_21 < var_124_22 then
						local var_124_26 = var_124_22 - var_124_21
						local var_124_27 = arg_124_1.stack_ids[var_124_14]

						for iter_124_4 = 1, var_124_26 do
							local var_124_28 = table.remove(var_124_27)

							var_124_0:remove_server_controlled_buff(var_124_14, var_124_28)
						end
					end
				end
			end
		end
	end,
	activate_buff_on_closest_distance = function (arg_125_0, arg_125_1, arg_125_2)
		if not Managers.state.network.is_server then
			return
		end

		local var_125_0 = arg_125_1.template
		local var_125_1 = arg_125_1.range
		local var_125_2 = var_125_1 * var_125_1
		local var_125_3 = POSITION_LOOKUP[arg_125_0]
		local var_125_4 = var_125_0.buff_to_add
		local var_125_5 = Managers.state.entity:system("buff_system")
		local var_125_6 = Managers.state.side.side_by_unit[arg_125_0]

		if not var_125_6 then
			return
		end

		local var_125_7 = var_125_6.PLAYER_AND_BOT_UNITS
		local var_125_8 = #var_125_7
		local var_125_9 = math.huge
		local var_125_10 = arg_125_1.current_unit

		for iter_125_0 = 1, var_125_8 do
			local var_125_11 = var_125_7[iter_125_0]

			if ALIVE[var_125_11] and var_125_11 ~= var_125_10 and var_125_11 ~= arg_125_0 then
				local var_125_12 = POSITION_LOOKUP[var_125_11]
				local var_125_13 = Vector3.distance_squared(var_125_3, var_125_12)

				if var_125_13 < var_125_2 and var_125_13 < var_125_9 then
					if var_125_10 and ALIVE[var_125_10] then
						local var_125_14 = POSITION_LOOKUP[var_125_10]

						if not var_125_3 or not var_125_14 then
							return
						end

						if var_125_13 < Vector3.distance_squared(var_125_3, var_125_14) then
							local var_125_15 = ScriptUnit.extension(var_125_10, "buff_system"):get_non_stacking_buff(var_125_4)

							if var_125_15 then
								local var_125_16 = var_125_15.server_id

								if var_125_16 then
									var_125_5:remove_server_controlled_buff(var_125_10, var_125_16)
								end
							end

							var_125_9 = var_125_13
							arg_125_1.current_unit = var_125_11
						end
					else
						var_125_9 = var_125_13
						arg_125_1.current_unit = var_125_11
					end
				end
			end
		end

		local var_125_17 = arg_125_1.current_unit

		if var_125_17 then
			local var_125_18 = ScriptUnit.has_extension(var_125_17, "buff_system")

			if not var_125_18 then
				return
			end

			local var_125_19 = POSITION_LOOKUP[var_125_17]
			local var_125_20 = Vector3.distance_squared(var_125_3, var_125_19)

			if var_125_2 < var_125_20 then
				local var_125_21 = var_125_18:get_non_stacking_buff(var_125_4)

				if var_125_21 then
					local var_125_22 = var_125_21.server_id

					if var_125_22 then
						var_125_21.current_unit = nil

						var_125_5:remove_server_controlled_buff(var_125_17, var_125_22)
					end
				end
			end

			if var_125_20 < var_125_2 and not var_125_18:has_buff_type(var_125_4) then
				local var_125_23 = var_125_5:add_buff(var_125_17, var_125_4, arg_125_0, true)
				local var_125_24 = var_125_18:get_non_stacking_buff(var_125_4)

				if var_125_24 then
					var_125_24.server_id = var_125_23
				end
			end
		else
			arg_125_1.current_unit = nil
		end
	end,
	markus_hero_time_reset = function (arg_126_0, arg_126_1, arg_126_2)
		local var_126_0 = arg_126_0

		if Unit.alive(var_126_0) then
			ScriptUnit.has_extension(var_126_0, "career_system"):reduce_activated_ability_cooldown_percent(1)
		end
	end,
	add_buff_stacks = function (arg_127_0, arg_127_1, arg_127_2)
		local var_127_0 = arg_127_0

		if Unit.alive(var_127_0) then
			local var_127_1 = arg_127_1.template
			local var_127_2 = var_127_1.amount_to_add
			local var_127_3 = ScriptUnit.has_extension(var_127_0, "buff_system")
			local var_127_4 = var_127_1.buff_to_add
			local var_127_5 = var_127_1.buff_list

			for iter_127_0 = 1, var_127_2 do
				if var_127_2 > #var_127_5 then
					var_127_1.buff_list[#var_127_1.buff_list + 1] = var_127_3:add_buff(var_127_4)
				end
			end
		end
	end,
	remove_aura_buff = function (arg_128_0, arg_128_1, arg_128_2)
		if not Managers.state.network.is_server then
			return
		end

		local var_128_0 = arg_128_1.template.buff_to_add
		local var_128_1 = Managers.state.entity:system("buff_system")
		local var_128_2 = Managers.state.side:get_side_from_name("heroes")

		if var_128_2 then
			local var_128_3 = var_128_2.PLAYER_AND_BOT_UNITS
			local var_128_4 = #var_128_3

			for iter_128_0 = 1, var_128_4 do
				local var_128_5 = var_128_3[iter_128_0]

				if ALIVE[var_128_5] then
					local var_128_6 = ScriptUnit.extension(var_128_5, "buff_system"):get_non_stacking_buff(var_128_0)

					if var_128_6 then
						local var_128_7 = var_128_6.server_id

						if var_128_7 then
							var_128_1:remove_server_controlled_buff(var_128_5, var_128_7)
						end
					end
				end
			end
		end
	end,
	activate_buff_on_nearby_ai_enemies = function (arg_129_0, arg_129_1, arg_129_2)
		if not Managers.state.network.is_server then
			return
		end

		local var_129_0 = Managers.time:time("game")

		if not arg_129_1.next_update_t then
			arg_129_1.next_update_t = var_129_0
			arg_129_1.tracked_buffs = {}
		end

		if var_129_0 < arg_129_1.next_update_t then
			return
		end

		local var_129_1 = arg_129_1.template

		arg_129_1.next_update_t = arg_129_1.next_update_t + var_129_1.tick_rate

		local var_129_2 = Managers.state.side.side_by_unit
		local var_129_3 = var_129_2[arg_129_0]
		local var_129_4 = Managers.state.entity:system("buff_system")
		local var_129_5 = arg_129_1.template.buff_to_add
		local var_129_6 = arg_129_1.tracked_buffs
		local var_129_7 = POSITION_LOOKUP[arg_129_0]
		local var_129_8 = arg_129_1.template.radius
		local var_129_9 = FrameTable.alloc_table()
		local var_129_10 = AiUtils.broadphase_query(var_129_7, var_129_8, var_129_9)

		for iter_129_0 = 1, var_129_10 do
			local var_129_11 = var_129_9[iter_129_0]

			var_129_9[var_129_11] = true

			if not var_129_6[var_129_11] and var_129_2[var_129_11] ~= var_129_3 then
				var_129_6[var_129_11] = var_129_4:add_buff(var_129_11, var_129_5, arg_129_0, true)
			end
		end

		for iter_129_1, iter_129_2 in pairs(var_129_6) do
			if not var_129_9[iter_129_1] then
				var_129_4:remove_server_controlled_buff(iter_129_1, iter_129_2)

				var_129_6[iter_129_1] = nil
			end
		end
	end,
	remove_tracked_buffs = function (arg_130_0, arg_130_1, arg_130_2)
		if not Managers.state.network.is_server then
			return
		end

		local var_130_0 = arg_130_1.tracked_buffs

		if var_130_0 then
			local var_130_1 = arg_130_1.template.buff_to_add
			local var_130_2 = Managers.state.entity:system("buff_system")

			for iter_130_0, iter_130_1 in pairs(var_130_0) do
				if ALIVE[iter_130_0] then
					var_130_2:remove_server_controlled_buff(iter_130_0, iter_130_1)
				end
			end

			table.clear(var_130_0)
		end
	end,
	update_ascending_descending_buff_stacks_on_time = function (arg_131_0, arg_131_1, arg_131_2)
		if not Unit.alive(arg_131_0) then
			return
		end

		local var_131_0 = arg_131_2.t
		local var_131_1 = arg_131_1.template

		if not arg_131_1.buff_ids then
			arg_131_1.ascending = true
			arg_131_1.buff_ids = {}
		end

		local var_131_2 = Managers.state.entity:system("buff_system")
		local var_131_3 = var_131_1.buff_to_add
		local var_131_4 = var_131_1.max_sub_buff_stacks

		if arg_131_1.ascending then
			arg_131_1.buff_ids[#arg_131_1.buff_ids + 1] = var_131_2:add_buff(arg_131_0, var_131_3, arg_131_0, true)

			if var_131_4 <= #arg_131_1.buff_ids then
				arg_131_1.ascending = false
			end
		else
			local var_131_5 = table.remove(arg_131_1.buff_ids, 1)

			var_131_2:remove_server_controlled_buff(arg_131_0, var_131_5)

			if #arg_131_1.buff_ids <= 1 then
				arg_131_1.ascending = true
			end
		end
	end,
	activate_buff_on_closest = function (arg_132_0, arg_132_1, arg_132_2)
		if not Managers.state.network.is_server then
			return
		end

		local var_132_0 = arg_132_1.template
		local var_132_1 = arg_132_1.range
		local var_132_2 = var_132_1 * var_132_1
		local var_132_3 = POSITION_LOOKUP[arg_132_0]
		local var_132_4 = var_132_0.buff_to_add
		local var_132_5 = Managers.state.entity:system("buff_system")
		local var_132_6 = Managers.state.side.side_by_unit[arg_132_0]

		if not var_132_6 then
			return
		end

		local var_132_7 = var_132_6.PLAYER_AND_BOT_UNITS
		local var_132_8 = #var_132_7
		local var_132_9

		for iter_132_0 = 1, var_132_8 do
			local var_132_10 = var_132_7[iter_132_0]

			if Unit.alive(var_132_10) then
				local var_132_11 = POSITION_LOOKUP[var_132_10]
				local var_132_12 = Vector3.distance_squared(var_132_3, var_132_11)
				local var_132_13 = ScriptUnit.extension(var_132_10, "buff_system")

				if var_132_12 > closest_player_distance then
					local var_132_14 = var_132_13:get_non_stacking_buff(var_132_4)

					if var_132_14 then
						local var_132_15 = var_132_14.server_id

						if var_132_15 then
							var_132_5:remove_server_controlled_buff(var_132_10, var_132_15)
						end
					end
				end

				if var_132_12 < var_132_2 and not var_132_13:has_buff_type(var_132_4) then
					local var_132_16 = var_132_5:add_buff(var_132_10, var_132_4, arg_132_0, true)
					local var_132_17 = var_132_13:get_non_stacking_buff(var_132_4)

					if var_132_17 then
						var_132_17.server_id = var_132_16
					end
				end
			end
		end
	end,
	markus_knight_proximity_buff_update = function (arg_133_0, arg_133_1, arg_133_2)
		if not Managers.state.network.is_server then
			return
		end

		local var_133_0 = arg_133_1.template
		local var_133_1 = arg_133_1.range
		local var_133_2 = var_133_1 * var_133_1
		local var_133_3 = POSITION_LOOKUP[arg_133_0]
		local var_133_4 = Managers.state.side.side_by_unit[arg_133_0]

		if not var_133_4 then
			return
		end

		local var_133_5 = var_133_4.PLAYER_AND_BOT_UNITS
		local var_133_6 = #var_133_5
		local var_133_7 = ScriptUnit.extension(arg_133_0, "talent_system")
		local var_133_8 = "markus_knight_passive_defence_aura"
		local var_133_9 = Managers.state.entity:system("buff_system")
		local var_133_10 = var_133_7:has_talent("markus_knight_guard")
		local var_133_11 = var_133_7:has_talent("markus_knight_passive_block_cost_aura")

		for iter_133_0 = 1, var_133_6 do
			local var_133_12 = var_133_5[iter_133_0]

			if Unit.alive(var_133_12) then
				local var_133_13 = POSITION_LOOKUP[var_133_12]
				local var_133_14 = Vector3.distance_squared(var_133_3, var_133_13)
				local var_133_15 = ScriptUnit.extension(var_133_12, "buff_system")

				if var_133_2 < var_133_14 or var_133_10 or var_133_11 then
					local var_133_16 = var_133_15:get_non_stacking_buff(var_133_8)

					if var_133_16 then
						local var_133_17 = var_133_16.server_id

						if var_133_17 then
							var_133_9:remove_server_controlled_buff(var_133_12, var_133_17)
						end
					end
				end

				if var_133_14 < var_133_2 and not var_133_10 and not var_133_11 and not var_133_15:has_buff_type(var_133_8) then
					local var_133_18 = var_133_9:add_buff(var_133_12, var_133_8, arg_133_0, true)
					local var_133_19 = var_133_15:get_non_stacking_buff(var_133_8)

					if var_133_19 then
						var_133_19.server_id = var_133_18
					end
				end
			end
		end
	end,
	markus_knight_movespeed_on_incapacitated_ally = function (arg_134_0, arg_134_1, arg_134_2)
		if not Managers.state.network.is_server then
			return
		end

		if not ALIVE[arg_134_0] then
			return
		end

		local var_134_0 = Managers.state.side.side_by_unit[arg_134_0]
		local var_134_1 = var_134_0 and var_134_0.PLAYER_AND_BOT_UNITS
		local var_134_2 = var_134_1 and #var_134_1 or 0
		local var_134_3 = ScriptUnit.extension(arg_134_0, "buff_system")
		local var_134_4 = Managers.state.entity:system("buff_system")
		local var_134_5 = arg_134_1.template.buff_to_add
		local var_134_6

		for iter_134_0 = 1, var_134_2 do
			local var_134_7 = var_134_1[iter_134_0]

			if ScriptUnit.extension(var_134_7, "status_system"):is_disabled() then
				var_134_6 = true
			end
		end

		if var_134_3:has_buff_type(var_134_5) then
			if not var_134_6 then
				local var_134_8 = arg_134_1.buff_id

				if var_134_8 then
					var_134_4:remove_server_controlled_buff(arg_134_0, var_134_8)

					arg_134_1.buff_id = nil
				end
			end
		elseif var_134_6 then
			arg_134_1.buff_id = var_134_4:add_buff(arg_134_0, var_134_5, arg_134_0, true)
		end
	end,
	kerillian_maidenguard_proximity_buff_update = function (arg_135_0, arg_135_1, arg_135_2)
		if not Managers.state.network.is_server then
			return
		end

		local var_135_0 = arg_135_1.template
		local var_135_1 = arg_135_1.range
		local var_135_2 = var_135_1 * var_135_1
		local var_135_3 = POSITION_LOOKUP[arg_135_0]
		local var_135_4 = Managers.state.side.side_by_unit[arg_135_0]

		if not var_135_4 then
			return
		end

		local var_135_5 = var_135_4.PLAYER_AND_BOT_UNITS
		local var_135_6 = #var_135_5
		local var_135_7 = "kerillian_maidenguard_passive_stamina_regen_buff"
		local var_135_8 = Managers.state.entity:system("buff_system")

		for iter_135_0 = 1, var_135_6 do
			local var_135_9 = var_135_5[iter_135_0]

			if Unit.alive(var_135_9) then
				local var_135_10 = POSITION_LOOKUP[var_135_9]
				local var_135_11 = Vector3.distance_squared(var_135_3, var_135_10)
				local var_135_12 = ScriptUnit.extension(var_135_9, "buff_system")

				if var_135_2 < var_135_11 then
					local var_135_13 = var_135_12:get_non_stacking_buff(var_135_7)

					if var_135_13 then
						local var_135_14 = var_135_13.server_id

						if var_135_14 then
							var_135_8:remove_server_controlled_buff(var_135_9, var_135_14)
						end
					end
				end

				if var_135_11 < var_135_2 and not var_135_12:has_buff_type(var_135_7) then
					local var_135_15 = var_135_8:add_buff(var_135_9, var_135_7, arg_135_0, true)
					local var_135_16 = var_135_12:get_non_stacking_buff(var_135_7)

					if var_135_16 then
						var_135_16.server_id = var_135_15
					end
				end
			end
		end
	end,
	victor_bountyhunter_blessed_combat_update = function (arg_136_0, arg_136_1, arg_136_2)
		local var_136_0 = arg_136_1.template
		local var_136_1 = ScriptUnit.extension(arg_136_0, "buff_system")
		local var_136_2 = var_136_0.ranged_buff_to_add
		local var_136_3 = var_136_0.ranged_buff
		local var_136_4 = var_136_1:has_buff_type(var_136_3)
		local var_136_5 = var_136_1:get_non_stacking_buff(var_136_2)

		if var_136_4 then
			if not var_136_5 then
				var_136_1:add_buff(var_136_2)
			end
		elseif var_136_5 then
			var_136_1:remove_buff(var_136_5.id)
		end

		local var_136_6 = var_136_0.melee_buff_to_add
		local var_136_7 = var_136_0.melee_buff
		local var_136_8 = var_136_1:has_buff_type(var_136_7)
		local var_136_9 = var_136_1:get_non_stacking_buff(var_136_6)

		if var_136_8 then
			if not var_136_9 then
				var_136_1:add_buff(var_136_6)
			end
		elseif var_136_9 then
			var_136_1:remove_buff(var_136_9.id)
		end
	end,
	victor_bountyhunter_contract_killing_update = function (arg_137_0, arg_137_1, arg_137_2)
		local var_137_0 = arg_137_1.template
		local var_137_1 = arg_137_2.t
		local var_137_2 = var_137_0.update_frequency
		local var_137_3 = ScriptUnit.extension(arg_137_0, "buff_system")

		if not var_137_3 then
			return
		end

		if not arg_137_1.timer then
			arg_137_1.timer = var_137_1 + var_137_2
		end

		if var_137_1 > arg_137_1.timer then
			arg_137_1.timer = var_137_1 + var_137_2

			local var_137_4 = {}

			if CurrentConflictSettings.factions then
				if table.contains(CurrentConflictSettings.factions, "chaos") then
					local var_137_5 = var_137_0.buffs_to_add_chaos

					for iter_137_0 = 1, #var_137_5 do
						var_137_4[#var_137_4 + 1] = var_137_5[iter_137_0]
					end
				end

				if table.contains(CurrentConflictSettings.factions, "skaven") then
					local var_137_6 = var_137_0.buffs_to_add_skaven

					for iter_137_1 = 1, #var_137_6 do
						var_137_4[#var_137_4 + 1] = var_137_6[iter_137_1]
					end
				end

				if table.contains(CurrentConflictSettings.factions, "beastmen") then
					local var_137_7 = var_137_0.buffs_to_add_beastmen

					for iter_137_2 = 1, #var_137_7 do
						var_137_4[#var_137_4 + 1] = var_137_7[iter_137_2]
					end
				end

				if var_137_3:num_buff_type(var_137_0.reward_to_add) > 5 then
					local var_137_8 = var_137_0.buffs_to_add_special

					for iter_137_3 = 1, #var_137_8 do
						var_137_4[#var_137_4 + 1] = var_137_8[iter_137_3]
					end
				end
			end

			local var_137_9 = var_137_4[math.random(1, #var_137_4)]

			if arg_137_1.current_buff_id then
				var_137_3:remove_buff(var_137_0.current_buff_id)
			end

			if var_137_9 then
				arg_137_1.current_buff_id = var_137_3:add_buff(var_137_9)
				arg_137_1.can_reward = true
				arg_137_1.current_buff = var_137_9
			end
		end

		if not var_137_3:has_buff_type(arg_137_1.current_buff) and arg_137_1.can_reward then
			local var_137_10 = var_137_0.reward_to_add

			arg_137_1.can_reward = false

			var_137_3:add_buff(var_137_10)
		end
	end,
	maidenguard_attack_speed_on_block_update = function (arg_138_0, arg_138_1, arg_138_2)
		local var_138_0 = arg_138_1.template
		local var_138_1 = ScriptUnit.extension(arg_138_0, "buff_system")
		local var_138_2 = var_138_0.stat_increase_buffs
		local var_138_3 = var_138_0.buff_to_add

		for iter_138_0 = 1, #var_138_2 do
			local var_138_4 = var_138_2[iter_138_0]
			local var_138_5 = var_138_1:has_buff_type(var_138_3)
			local var_138_6 = var_138_1:get_non_stacking_buff(var_138_4)

			if var_138_5 then
				if not var_138_6 then
					var_138_1:add_buff(var_138_4)
				end
			elseif var_138_6 then
				var_138_1:remove_buff(var_138_6.id)
			end
		end
	end,
	activate_buff_on_other_buff = function (arg_139_0, arg_139_1, arg_139_2)
		local var_139_0 = arg_139_1.template
		local var_139_1 = var_139_0.buff_to_add
		local var_139_2 = ScriptUnit.extension(arg_139_0, "buff_system")
		local var_139_3 = var_139_0.activation_buff
		local var_139_4 = var_139_0.activate_on_missing
		local var_139_5 = var_139_0.only_local
		local var_139_6 = var_139_2:get_non_stacking_buff(var_139_3)
		local var_139_7 = (var_139_6 and not var_139_4 or not var_139_6 and var_139_4) and (not var_139_5 or var_139_5 and var_0_7(arg_139_0))
		local var_139_8 = var_139_2:get_non_stacking_buff(var_139_1)

		if var_139_7 then
			if not var_139_8 then
				var_139_2:add_buff(var_139_1)
			end
		elseif var_139_8 then
			var_139_2:remove_buff(var_139_8.id)
		end
	end,
	activate_bonus_on_last_standing = function (arg_140_0, arg_140_1, arg_140_2)
		local var_140_0 = arg_140_1.template
		local var_140_1 = var_140_0.activation_bonus
		local var_140_2 = var_140_0.stat_buff
		local var_140_3 = Managers.state.side.side_by_unit[arg_140_0]

		if not var_140_3 then
			return
		end

		local var_140_4 = var_140_3.PLAYER_AND_BOT_UNITS
		local var_140_5 = #var_140_4
		local var_140_6
		local var_140_7 = {}

		for iter_140_0 = 1, var_140_5 do
			local var_140_8 = var_140_4[iter_140_0]

			var_140_7[#var_140_7 + 1] = var_140_8
		end

		local var_140_9 = {}

		for iter_140_1 = 1, #var_140_7 do
			local var_140_10 = var_140_7[iter_140_1]
			local var_140_11 = ScriptUnit.extension(var_140_10, "status_system"):is_disabled()

			if var_140_11 and var_140_10 == var_140_6 then
				return
			elseif var_140_11 and var_140_10 ~= var_140_6 then
				var_140_9[#var_140_9 + 1] = var_140_10
			end
		end

		local var_140_12 = arg_140_1.previous_bonus or 0
		local var_140_13 = 0

		if #var_140_9 == var_140_5 - 1 then
			var_140_13 = var_140_1
		end

		arg_140_1.bonus = var_140_13

		if var_140_12 ~= var_140_13 and var_140_2 then
			local var_140_14 = ScriptUnit.extension(arg_140_0, "buff_system")
			local var_140_15 = var_140_13 - var_140_12

			var_140_14:update_stat_buff(var_140_2, var_140_15, var_140_0.name)
		end

		arg_140_1.previous_bonus = var_140_13
	end,
	activate_multiplier_on_last_standing = function (arg_141_0, arg_141_1, arg_141_2)
		local var_141_0 = arg_141_1.template
		local var_141_1 = var_141_0.activation_multiplier
		local var_141_2 = var_141_0.stat_buff
		local var_141_3 = Managers.state.side.side_by_unit[arg_141_0]

		if not var_141_3 then
			return
		end

		local var_141_4 = var_141_3.PLAYER_AND_BOT_UNITS
		local var_141_5 = #var_141_4
		local var_141_6
		local var_141_7 = {}

		for iter_141_0 = 1, var_141_5 do
			local var_141_8 = var_141_4[iter_141_0]

			var_141_7[#var_141_7 + 1] = var_141_8
		end

		local var_141_9 = {}

		for iter_141_1 = 1, #var_141_7 do
			local var_141_10 = var_141_7[iter_141_1]

			if var_141_10 then
				local var_141_11 = ScriptUnit.extension(var_141_10, "status_system"):is_disabled()

				if var_141_11 and var_141_10 == var_141_6 then
					return
				elseif var_141_11 and var_141_10 ~= var_141_6 then
					var_141_9[#var_141_9 + 1] = var_141_10
				end
			end
		end

		local var_141_12 = arg_141_1.previous_multiplier or 0
		local var_141_13 = 0

		if #var_141_9 == var_141_5 - 1 then
			var_141_13 = var_141_1
		end

		arg_141_1.multiplier = var_141_13

		if var_141_12 ~= var_141_13 and var_141_2 then
			local var_141_14 = ScriptUnit.extension(arg_141_0, "buff_system")
			local var_141_15 = var_141_13 - var_141_12

			var_141_14:update_stat_buff(var_141_2, var_141_15, var_141_0.name)
		end

		arg_141_1.previous_multiplier = var_141_13
	end,
	activate_buff_on_last_standing = function (arg_142_0, arg_142_1, arg_142_2)
		local var_142_0 = arg_142_1.template
		local var_142_1 = Managers.state.side.side_by_unit[arg_142_0]

		if not var_142_1 then
			return
		end

		local var_142_2 = var_142_1.PLAYER_AND_BOT_UNITS
		local var_142_3 = #var_142_2
		local var_142_4 = var_142_0.buff_to_add
		local var_142_5 = arg_142_0
		local var_142_6 = {}
		local var_142_7 = var_0_7(var_142_5)

		for iter_142_0 = 1, var_142_3 do
			local var_142_8 = var_142_2[iter_142_0]

			var_142_6[#var_142_6 + 1] = var_142_8
		end

		local var_142_9 = {}

		for iter_142_1 = 1, #var_142_6 do
			local var_142_10 = var_142_6[iter_142_1]

			if var_142_10 then
				local var_142_11 = ScriptUnit.has_extension(var_142_10, "status_system")
				local var_142_12 = not var_142_11 or var_142_11:is_disabled()

				if var_142_12 and var_142_10 == var_142_5 then
					return
				elseif var_142_12 and var_142_10 ~= var_142_5 then
					var_142_9[#var_142_9 + 1] = var_142_10
				end
			end
		end

		local var_142_13

		if #var_142_9 == var_142_3 - 1 then
			var_142_13 = true
		end

		local var_142_14 = ScriptUnit.has_extension(var_142_5, "buff_system")

		if var_142_14 then
			local var_142_15 = Managers.state.entity:system("buff_system")
			local var_142_16 = var_142_14:get_non_stacking_buff(var_142_4)

			if not var_142_13 and var_142_16 then
				if var_142_7 then
					var_142_14:remove_buff(var_142_16.id)
				else
					local var_142_17 = var_142_16.server_id

					var_142_15:remove_server_controlled_buff(var_142_5, var_142_17)
				end
			elseif var_142_13 and not var_142_16 then
				if var_142_7 then
					var_142_14:add_buff(var_142_4)
				else
					local var_142_18 = var_142_15:add_buff(var_142_5, var_142_4, var_142_5, true)
					local var_142_19 = var_142_14:get_non_stacking_buff(var_142_4)

					if var_142_19 then
						var_142_19.server_id = var_142_18
					end
				end
			end
		end
	end,
	activate_buff_on_health_percent = function (arg_143_0, arg_143_1, arg_143_2)
		local var_143_0 = arg_143_1.template
		local var_143_1 = var_143_0.buff_to_add
		local var_143_2 = arg_143_0
		local var_143_3 = {}
		local var_143_4 = ScriptUnit.extension(var_143_2, "buff_system")
		local var_143_5 = var_0_7(var_143_2)
		local var_143_6 = var_143_0.activation_health
		local var_143_7 = var_143_0.activate_below
		local var_143_8 = ScriptUnit.extension(arg_143_0, "health_system"):current_health_percent()
		local var_143_9

		if var_143_8 < var_143_6 and var_143_7 or var_143_6 < var_143_8 and not var_143_7 then
			var_143_9 = true
		end

		local var_143_10 = Managers.state.entity:system("buff_system")
		local var_143_11 = var_143_4:get_non_stacking_buff(var_143_1)

		if not var_143_9 and var_143_11 then
			if var_143_5 then
				var_143_4:remove_buff(var_143_11.id)
			else
				local var_143_12 = var_143_11.server_id

				var_143_10:remove_server_controlled_buff(var_143_2, var_143_12)
			end
		elseif var_143_9 and not var_143_11 then
			if var_143_5 then
				var_143_4:add_buff(var_143_1)
			else
				local var_143_13 = var_143_10:add_buff(var_143_2, var_143_1, var_143_2, true)
				local var_143_14 = var_143_4:get_non_stacking_buff(var_143_1)

				if var_143_14 then
					var_143_14.server_id = var_143_13
				end
			end
		end
	end,
	activate_buff_on_disabled = function (arg_144_0, arg_144_1, arg_144_2)
		local var_144_0 = arg_144_1.template.buff_to_add
		local var_144_1 = arg_144_0
		local var_144_2 = ScriptUnit.extension(var_144_1, "buff_system")
		local var_144_3 = var_0_7(var_144_1)
		local var_144_4 = ScriptUnit.extension(arg_144_0, "status_system")
		local var_144_5 = var_144_4:is_disabled() or var_144_4:is_in_vortex()
		local var_144_6

		if var_144_5 then
			var_144_6 = true
		end

		local var_144_7 = Managers.state.entity:system("buff_system")
		local var_144_8 = var_144_2:get_non_stacking_buff(var_144_0)

		if not var_144_6 and var_144_8 then
			if var_144_3 then
				var_144_2:remove_buff(var_144_8.id)
			else
				local var_144_9 = var_144_8.server_id

				var_144_7:remove_server_controlled_buff(var_144_1, var_144_9)
			end
		elseif var_144_6 and not var_144_8 then
			if var_144_3 then
				var_144_2:add_buff(var_144_0)
			else
				local var_144_10 = var_144_7:add_buff(var_144_1, var_144_0, var_144_1, true)
				local var_144_11 = var_144_2:get_non_stacking_buff(var_144_0)

				if var_144_11 then
					var_144_11.server_id = var_144_10
				end
			end
		end
	end,
	activate_buff_on_no_ammo = function (arg_145_0, arg_145_1, arg_145_2)
		local var_145_0 = arg_145_1.template.buff_to_add
		local var_145_1 = arg_145_0
		local var_145_2 = ScriptUnit.extension(var_145_1, "buff_system")
		local var_145_3 = var_0_7(var_145_1)
		local var_145_4 = "slot_ranged"
		local var_145_5 = arg_145_1.bonus
		local var_145_6 = ScriptUnit.extension(var_145_1, "inventory_system"):get_slot_data(var_145_4)

		if var_145_6 then
			local var_145_7 = var_145_6.right_unit_1p
			local var_145_8 = var_145_6.left_unit_1p
			local var_145_9 = ScriptUnit.has_extension(var_145_7, "ammo_system")
			local var_145_10 = ScriptUnit.has_extension(var_145_8, "ammo_system")
			local var_145_11 = var_145_9 or var_145_10
			local var_145_12

			if var_145_11 then
				var_145_12 = var_145_11:total_ammo_fraction() == 0
			end

			local var_145_13 = Managers.state.entity:system("buff_system")
			local var_145_14 = var_145_2:get_non_stacking_buff(var_145_0)

			if not var_145_12 and var_145_14 then
				if var_145_3 then
					var_145_2:remove_buff(var_145_14.id)
				else
					local var_145_15 = var_145_14.server_id

					var_145_13:remove_server_controlled_buff(var_145_1, var_145_15)
				end
			elseif var_145_12 and not var_145_14 then
				if var_145_3 then
					var_145_2:add_buff(var_145_0)
				else
					local var_145_16 = var_145_13:add_buff(var_145_1, var_145_0, var_145_1, true)
					local var_145_17 = var_145_2:get_non_stacking_buff(var_145_0)

					if var_145_17 then
						var_145_17.server_id = var_145_16
					end
				end
			end
		end

		return false, 0
	end,
	activate_buff_on_grimoire_picked_up = function (arg_146_0, arg_146_1, arg_146_2)
		local var_146_0 = arg_146_1.template.buff_to_add
		local var_146_1 = arg_146_0
		local var_146_2 = ScriptUnit.extension(var_146_1, "buff_system")
		local var_146_3 = var_0_7(var_146_1)
		local var_146_4 = ScriptUnit.extension(arg_146_0, "status_system")

		if not var_146_4:is_disabled() then
			local var_146_5 = var_146_4:is_in_vortex()
		end

		local var_146_6

		if var_146_2:has_buff_perk("skaven_grimoire") then
			var_146_6 = true
		end

		local var_146_7 = Managers.state.entity:system("buff_system")
		local var_146_8 = var_146_2:get_non_stacking_buff(var_146_0)

		if not var_146_6 and var_146_8 then
			if var_146_3 then
				var_146_2:remove_buff(var_146_8.id)
			else
				local var_146_9 = var_146_8.server_id

				var_146_7:remove_server_controlled_buff(var_146_1, var_146_9)
			end
		elseif var_146_6 and not var_146_8 then
			if var_146_3 then
				var_146_2:add_buff(var_146_0)
			else
				local var_146_10 = var_146_7:add_buff(var_146_1, var_146_0, var_146_1, true)
				local var_146_11 = var_146_2:get_non_stacking_buff(var_146_0)

				if var_146_11 then
					var_146_11.server_id = var_146_10
				end
			end
		end
	end,
	activate_multiplier_on_disabled = function (arg_147_0, arg_147_1, arg_147_2)
		local var_147_0 = arg_147_1.template
		local var_147_1 = var_147_0.activation_multiplier
		local var_147_2 = var_147_0.stat_buff
		local var_147_3 = ScriptUnit.extension(arg_147_0, "status_system")
		local var_147_4 = var_147_3:is_disabled() or var_147_3:is_in_vortex()
		local var_147_5 = arg_147_1.previous_multiplier or 0
		local var_147_6 = 0

		if var_147_4 then
			var_147_6 = var_147_1
		end

		arg_147_1.multiplier = var_147_6

		if var_147_5 ~= var_147_6 and var_147_2 then
			local var_147_7 = ScriptUnit.extension(arg_147_0, "buff_system")
			local var_147_8 = var_147_6 - var_147_5

			var_147_7:update_stat_buff(var_147_2, var_147_8, var_147_0.name)
		end

		arg_147_1.previous_multiplier = var_147_6
	end,
	activate_multiplier_on_wounded = function (arg_148_0, arg_148_1, arg_148_2)
		local var_148_0 = arg_148_1.template
		local var_148_1 = var_148_0.activation_multiplier
		local var_148_2 = var_148_0.stat_buff
		local var_148_3 = ScriptUnit.extension(arg_148_0, "status_system"):is_wounded()
		local var_148_4 = arg_148_1.previous_multiplier or 0
		local var_148_5 = 0

		if var_148_3 then
			var_148_5 = var_148_1
		end

		arg_148_1.multiplier = var_148_5

		if var_148_4 ~= var_148_5 and var_148_2 then
			local var_148_6 = ScriptUnit.extension(arg_148_0, "buff_system")
			local var_148_7 = var_148_5 - var_148_4

			var_148_6:update_stat_buff(var_148_2, var_148_7, var_148_0.name)
		end

		arg_148_1.previous_multiplier = var_148_5
	end,
	activate_bonus_on_wounded = function (arg_149_0, arg_149_1, arg_149_2)
		local var_149_0 = arg_149_1.template
		local var_149_1 = var_149_0.activation_bonus or 0
		local var_149_2 = var_149_0.stat_buff
		local var_149_3 = ScriptUnit.extension(arg_149_0, "status_system"):is_wounded()
		local var_149_4 = arg_149_1.previous_bonus or 0
		local var_149_5 = 0

		if var_149_3 then
			var_149_5 = var_149_1
		end

		arg_149_1.bonus = var_149_5

		if var_149_4 ~= var_149_5 and var_149_2 then
			local var_149_6 = ScriptUnit.extension(arg_149_0, "buff_system")
			local var_149_7 = var_149_5 - var_149_4

			var_149_6:update_stat_buff(var_149_2, var_149_7, var_149_0.name)
		end

		arg_149_1.previous_bonus = var_149_5
	end,
	bardin_slayer_passive_update = function (arg_150_0, arg_150_1, arg_150_2)
		local var_150_0 = Managers.state.entity:system("ai_system").broadphase
		local var_150_1 = arg_150_1.template
		local var_150_2 = arg_150_1.range
		local var_150_3 = var_150_1.base_multiplier
		local var_150_4 = var_150_1.stat_buff
		local var_150_5 = arg_150_1.previous_bonus or 0
		local var_150_6 = POSITION_LOOKUP[arg_150_0]
		local var_150_7 = ScriptUnit.extension(arg_150_0, "talent_system")

		table.clear(var_0_6)

		local var_150_8 = Broadphase.query(var_150_0, var_150_6, var_150_2, var_0_6)
		local var_150_9 = 0

		for iter_150_0 = 1, var_150_8 do
			local var_150_10 = var_0_6[iter_150_0]

			if HEALTH_ALIVE[var_150_10] then
				var_150_9 = var_150_9 + 1
			end
		end

		local var_150_11 = 0

		if var_150_7:has_talent("bardin_slayer_increased_passive_bonus", "dwarf_ranger", true) then
			var_150_3 = var_150_3 * 1.5
		end

		if var_150_7:has_talent("bardin_slayer_increased_activation_number", "dwarf_ranger", true) then
			if var_150_9 <= 2 then
				var_150_11 = var_150_3
			end
		elseif var_150_9 == 1 then
			var_150_11 = var_150_3
		end

		arg_150_1.bonus = var_150_11

		if var_150_5 ~= var_150_11 and var_150_4 then
			local var_150_12 = ScriptUnit.extension(arg_150_0, "buff_system")
			local var_150_13 = var_150_11 - var_150_5

			var_150_12:update_stat_buff(var_150_4, var_150_13, var_150_1.name)
		end

		arg_150_1.previous_bonus = var_150_11
	end,
	bardin_slayer_activate_buff_on_loadout = function (arg_151_0, arg_151_1, arg_151_2)
		if not Managers.state.network.is_server then
			return
		end

		if Unit.alive(arg_151_0) then
			local var_151_0 = ScriptUnit.has_extension(arg_151_0, "inventory_system")
			local var_151_1 = var_151_0:get_slot_data("slot_melee")
			local var_151_2 = var_151_0:get_slot_data("slot_ranged")

			if var_151_1 and var_151_2 then
				local var_151_3 = arg_151_1.template
				local var_151_4 = var_151_3.buff_type
				local var_151_5 = var_151_0:get_item_template(var_151_1)
				local var_151_6 = var_151_5 and var_151_5.buff_type
				local var_151_7 = var_151_0:get_item_template(var_151_2)
				local var_151_8 = var_151_7 and var_151_7.buff_type
				local var_151_9 = ScriptUnit.has_extension(arg_151_0, "buff_system")
				local var_151_10 = Managers.state.entity:system("buff_system")
				local var_151_11 = var_151_3.buff_to_add
				local var_151_12 = var_151_9:has_buff_type(var_151_11)

				var_151_8 = var_151_8 == "RANGED" and "MELEE_1H" or var_151_8

				local var_151_13 = var_151_6 == var_151_4 and var_151_8 == var_151_4

				if not var_151_12 then
					if var_151_13 then
						arg_151_1.added_buff_id = var_151_10:add_buff(arg_151_0, var_151_11, arg_151_0, true)
					end
				elseif arg_151_1.added_buff_id and not var_151_13 then
					var_151_10:remove_server_controlled_buff(arg_151_0, arg_151_1.added_buff_id)

					arg_151_1.added_buff_id = nil
				else
					return
				end
			end
		end
	end,
	bardin_slayer_remove_activate_buff_on_loadout = function (arg_152_0, arg_152_1, arg_152_2)
		if not Managers.state.network.is_server then
			return
		end

		if Unit.alive(arg_152_0) then
			local var_152_0 = arg_152_1.template
			local var_152_1 = ScriptUnit.has_extension(arg_152_0, "buff_system")
			local var_152_2 = Managers.state.entity:system("buff_system")
			local var_152_3 = var_152_0.buff_to_add

			if var_152_1:has_buff_type(var_152_3) and arg_152_1.added_buff_id then
				var_152_2:remove_server_controlled_buff(arg_152_0, arg_152_1.added_buff_id)

				arg_152_1.added_buff_id = nil
			end
		end
	end,
	bardin_slayer_active_buff_on_charge_action = function (arg_153_0, arg_153_1, arg_153_2)
		if Unit.alive(arg_153_0) then
			local var_153_0, var_153_1 = ScriptUnit.has_extension(arg_153_0, "inventory_system"):get_all_weapon_unit()
			local var_153_2 = var_153_0 and ScriptUnit.has_extension(var_153_0, "weapon_system")
			local var_153_3 = var_153_1 and ScriptUnit.has_extension(var_153_1, "weapon_system")
			local var_153_4

			if var_153_2 and var_153_2:has_current_action() then
				local var_153_5 = var_153_2:get_current_action_settings()

				var_153_4 = ActionUtils.is_melee_start_sub_action(var_153_5)
			end

			if not var_153_4 and var_153_3 and var_153_3:has_current_action() then
				local var_153_6 = var_153_3:get_current_action_settings()

				var_153_4 = ActionUtils.is_melee_start_sub_action(var_153_6)
			end

			if var_153_4 then
				local var_153_7 = ScriptUnit.has_extension(arg_153_0, "buff_system")
				local var_153_8 = arg_153_1.template.buff_to_add

				if not var_153_7:has_buff_type(var_153_8) then
					local var_153_9 = Managers.state.network
					local var_153_10 = var_153_9.network_transmit
					local var_153_11 = var_153_9:unit_game_object_id(arg_153_0)
					local var_153_12 = NetworkLookup.buff_templates[var_153_8]

					if var_0_9() then
						var_153_7:add_buff(var_153_8, {
							attacker_unit = arg_153_0
						})
						var_153_10:send_rpc_clients("rpc_add_buff", var_153_11, var_153_12, var_153_11, 0, false)
					else
						var_153_10:send_rpc_server("rpc_add_buff", var_153_11, var_153_12, var_153_11, 0, true)
					end
				end
			end
		end
	end,
	activate_on_single_enemy = function (arg_154_0, arg_154_1, arg_154_2)
		local var_154_0 = Managers.state.entity:system("ai_system").broadphase
		local var_154_1 = arg_154_1.template
		local var_154_2 = arg_154_1.range
		local var_154_3 = var_154_1.multiplier
		local var_154_4 = var_154_1.stat_buff
		local var_154_5 = arg_154_1.previous_multiplier or 0
		local var_154_6 = POSITION_LOOKUP[arg_154_0]

		table.clear(var_0_6)

		local var_154_7 = Broadphase.query(var_154_0, var_154_6, var_154_2, var_0_6)
		local var_154_8 = 0

		for iter_154_0 = 1, var_154_7 do
			local var_154_9 = var_0_6[iter_154_0]

			if HEALTH_ALIVE[var_154_9] then
				var_154_8 = var_154_8 + 1
			end
		end

		local var_154_10 = 0

		if var_154_8 == 1 then
			var_154_10 = var_154_3
		end

		arg_154_1.multiplier = var_154_10

		if var_154_5 ~= var_154_10 and var_154_4 then
			local var_154_11 = ScriptUnit.extension(arg_154_0, "buff_system")
			local var_154_12 = var_154_10 - var_154_5

			var_154_11:update_stat_buff(var_154_4, var_154_12, var_154_1.name)
		end

		arg_154_1.previous_multiplier = var_154_10
	end,
	activate_bonus_on_health_percent = function (arg_155_0, arg_155_1, arg_155_2)
		local var_155_0 = arg_155_1.template
		local var_155_1 = var_155_0.activation_bonus
		local var_155_2 = var_155_0.activation_health
		local var_155_3 = var_155_0.activate_below
		local var_155_4 = var_155_0.stat_buff
		local var_155_5 = ScriptUnit.extension(arg_155_0, "health_system"):current_health_percent()
		local var_155_6 = arg_155_1.previous_bonus or 0
		local var_155_7 = 0

		if var_155_5 < var_155_2 and var_155_3 or var_155_2 < var_155_5 and not var_155_3 then
			var_155_7 = var_155_1
		end

		arg_155_1.previous_bonus = var_155_7

		if var_155_6 ~= var_155_7 and var_155_4 then
			local var_155_8 = ScriptUnit.extension(arg_155_0, "buff_system")
			local var_155_9 = var_155_7 - var_155_6

			var_155_8:update_stat_buff(var_155_4, var_155_9, var_155_0.name)
		end

		arg_155_1.previous_bonus = var_155_7
	end,
	activate_multiplier_on_health_percent = function (arg_156_0, arg_156_1, arg_156_2)
		local var_156_0 = arg_156_1.template
		local var_156_1 = var_156_0.activation_multiplier
		local var_156_2 = var_156_0.activation_health
		local var_156_3 = var_156_0.activate_below
		local var_156_4 = var_156_0.stat_buff
		local var_156_5 = ScriptUnit.extension(arg_156_0, "health_system"):current_health_percent()
		local var_156_6 = arg_156_1.previous_multiplier or 0
		local var_156_7 = 0

		if var_156_5 < var_156_2 and var_156_3 or var_156_2 < var_156_5 and not var_156_3 then
			var_156_7 = var_156_1
		end

		arg_156_1.previous_multiplier = var_156_7

		if var_156_6 ~= var_156_7 and var_156_4 then
			local var_156_8 = ScriptUnit.extension(arg_156_0, "buff_system")
			local var_156_9 = var_156_7 - var_156_6

			var_156_8:update_stat_buff(var_156_4, var_156_9, var_156_0.name)
		end

		arg_156_1.previous_multiplier = var_156_7
	end,
	activate_bonus_on_ammo_percent = function (arg_157_0, arg_157_1, arg_157_2)
		local var_157_0 = arg_157_1.template
		local var_157_1 = var_157_0.activation_bonus
		local var_157_2 = var_157_0.activation_ammo
		local var_157_3 = var_157_0.activate_below
		local var_157_4 = var_157_0.stat_buff
		local var_157_5 = ScriptUnit.has_extension(arg_157_0, "inventory_system")
		local var_157_6 = 0
		local var_157_7 = var_157_5:get_slot_data("slot_ranged")

		if var_157_7 then
			local var_157_8 = var_157_7.left_unit_1p
			local var_157_9 = var_157_7.right_unit_1p
			local var_157_10 = (ScriptUnit.has_extension(var_157_8, "ammo_system") and ScriptUnit.extension(var_157_8, "ammo_system") or ScriptUnit.has_extension(var_157_9, "ammo_system") and ScriptUnit.extension(var_157_9, "ammo_system")):total_ammo_fraction()

			if not arg_157_1.previous_bonus then
				local var_157_11 = 0
			end

			if var_157_10 < var_157_2 and var_157_3 or var_157_2 < var_157_10 and not var_157_3 then
				var_157_6 = var_157_1
			end
		end

		arg_157_1.previous_bonus = var_157_6

		if previous_bonus ~= var_157_6 and var_157_4 then
			local var_157_12 = ScriptUnit.extension(arg_157_0, "buff_system")
			local var_157_13 = var_157_6 - previous_bonus

			var_157_12:update_stat_buff(var_157_4, var_157_13, var_157_0.name)
		end

		arg_157_1.previous_bonus = var_157_6
	end,
	activate_multiplier_on_ammo_percent = function (arg_158_0, arg_158_1, arg_158_2)
		local var_158_0 = arg_158_1.template
		local var_158_1 = var_158_0.activation_multiplier
		local var_158_2 = var_158_0.activation_ammo
		local var_158_3 = var_158_0.activate_below
		local var_158_4 = var_158_0.stat_buff
		local var_158_5 = ScriptUnit.has_extension(arg_158_0, "inventory_system")
		local var_158_6 = 0
		local var_158_7 = var_158_5:get_slot_data("slot_ranged")

		if var_158_7 then
			local var_158_8 = var_158_7.left_unit_1p
			local var_158_9 = var_158_7.right_unit_1p
			local var_158_10 = (ScriptUnit.has_extension(var_158_8, "ammo_system") and ScriptUnit.extension(var_158_8, "ammo_system") or ScriptUnit.has_extension(var_158_9, "ammo_system") and ScriptUnit.extension(var_158_9, "ammo_system")):total_ammo_fraction()

			if not arg_158_1.previous_multiplier then
				local var_158_11 = 0
			end

			if var_158_10 < var_158_2 and var_158_3 or var_158_2 < var_158_10 and not var_158_3 then
				var_158_6 = var_158_1
			end
		end

		arg_158_1.previous_multiplier = var_158_6

		if previous_multiplier ~= var_158_6 and var_158_4 then
			local var_158_12 = ScriptUnit.extension(arg_158_0, "buff_system")
			local var_158_13 = var_158_6 - previous_multiplier

			var_158_12:update_stat_buff(var_158_4, var_158_13, var_158_0.name)
		end

		arg_158_1.previous_multiplier = var_158_6
	end,
	activate_multiplier_on_grimoire_picked_up = function (arg_159_0, arg_159_1, arg_159_2)
		local var_159_0 = ScriptUnit.extension(arg_159_0, "buff_system")
		local var_159_1 = arg_159_1.template
		local var_159_2 = var_159_1.activation_multiplier
		local var_159_3 = var_159_1.stat_buff
		local var_159_4 = arg_159_1.previous_multiplier or 0
		local var_159_5 = 0

		if var_159_0:has_buff_perk("skaven_grimoire") then
			var_159_5 = var_159_2
		end

		arg_159_1.previous_multiplier = var_159_5

		if var_159_4 ~= var_159_5 and var_159_3 then
			local var_159_6 = var_159_5 - var_159_4

			var_159_0:update_stat_buff(var_159_3, var_159_6, var_159_1.name)
		end

		arg_159_1.previous_multiplier = var_159_5
	end,
	activate_bonus_on_grimoire_picked_up = function (arg_160_0, arg_160_1, arg_160_2)
		local var_160_0 = ScriptUnit.extension(arg_160_0, "buff_system")
		local var_160_1 = arg_160_1.template
		local var_160_2 = var_160_1.activation_bonus
		local var_160_3 = var_160_1.stat_buff
		local var_160_4 = arg_160_1.previous_bonus or 0
		local var_160_5 = 0

		if var_160_0:has_buff_perk("skaven_grimoire") then
			var_160_5 = var_160_2
		end

		arg_160_1.previous_bonus = var_160_5

		if var_160_4 ~= var_160_5 and var_160_3 then
			local var_160_6 = var_160_5 - var_160_4

			var_160_0:update_stat_buff(var_160_3, var_160_6, var_160_1.name)
		end

		arg_160_1.previous_bonus = var_160_5
	end,
	update_multiplier_based_on_missing_health = function (arg_161_0, arg_161_1, arg_161_2)
		local var_161_0 = ScriptUnit.extension(arg_161_0, "health_system"):get_damage_taken()
		local var_161_1 = arg_161_1.template
		local var_161_2 = var_161_1.base_multiplier
		local var_161_3 = var_161_1.stat_buff
		local var_161_4 = arg_161_1.previous_multiplier or 0
		local var_161_5 = var_161_0 * var_161_2

		arg_161_1.multiplier = var_161_5

		if var_161_3 and var_161_4 ~= var_161_5 then
			local var_161_6 = ScriptUnit.extension(arg_161_0, "buff_system")
			local var_161_7 = var_161_5 - var_161_4

			var_161_6:update_stat_buff(var_161_3, var_161_7, var_161_1.name)
		end

		arg_161_1.previous_multiplier = var_161_5
	end,
	sienna_unchained_activated_ability_pulse_remove = function (arg_162_0, arg_162_1, arg_162_2)
		local var_162_0 = Managers.world:world("level_world")

		if arg_162_1.targeting_effect_id then
			World.destroy_particles(var_162_0, arg_162_1.targeting_effect_id)

			arg_162_1.targeting_effect_id = nil
		end

		if arg_162_1.screenspace_effect_id then
			World.destroy_particles(var_162_0, arg_162_1.screenspace_effect_id)

			arg_162_1.screenspace_effect_id = nil
		end
	end,
	sienna_unchained_activated_ability_pulse_update = function (arg_163_0, arg_163_1, arg_163_2)
		local var_163_0 = arg_163_1.template
		local var_163_1 = arg_163_2.t
		local var_163_2 = POSITION_LOOKUP[arg_163_0]
		local var_163_3 = var_163_0.pulse_frequency

		if not ScriptUnit.extension(arg_163_0, "buff_system") then
			return
		end

		if not arg_163_1.targeting_effect_id then
			local var_163_4 = Managers.world:world("level_world")
			local var_163_5 = "fx/unchained_aura_talent_1p"
			local var_163_6 = "fx/unchained_aura_talent_3p"

			arg_163_1.targeting_effect_id = World.create_particles(var_163_4, var_163_6, Vector3.zero())
			arg_163_1.targeting_variable_id = World.find_particles_variable(var_163_4, var_163_6, "charge_radius")

			World.set_particles_variable(var_163_4, arg_163_1.targeting_effect_id, arg_163_1.targeting_variable_id, Vector3(12, 12, 0.2))

			local var_163_7 = var_163_5
			local var_163_8 = ScriptUnit.has_extension(arg_163_0, "first_person_system")

			if var_163_8 then
				arg_163_1.screenspace_effect_id = var_163_8:create_screen_particles(var_163_7)
			end
		end

		if arg_163_1.targeting_effect_id then
			local var_163_9 = Managers.world:world("level_world")

			World.move_particles(var_163_9, arg_163_1.targeting_effect_id, var_163_2)
		end

		if not arg_163_1.timer or var_163_1 > arg_163_1.timer then
			if not Managers.state.network.is_server then
				return
			end

			local var_163_10 = Managers.state.entity:system("ai_system").broadphase
			local var_163_11 = ScriptUnit.extension(arg_163_0, "buff_system")
			local var_163_12 = Managers.state.entity:system("buff_system")
			local var_163_13 = 6

			table.clear(var_0_6)

			local var_163_14 = Broadphase.query(var_163_10, var_163_2, var_163_13, var_0_6)
			local var_163_15 = 0

			for iter_163_0 = 1, var_163_14 do
				local var_163_16 = var_0_6[iter_163_0]

				if HEALTH_ALIVE[var_163_16] then
					local var_163_17 = 2

					Managers.state.entity:system("buff_system"):add_buff(var_163_16, "burning_dot_unchained_pulse", arg_163_0, false, 200, arg_163_0)
					DamageUtils.add_damage_network(var_163_16, var_163_16, var_163_17, "torso", "burn_shotgun", nil, Vector3(0, 0, 0), nil, nil, arg_163_0, nil, nil, nil, nil, nil, nil, nil, nil, 1)
				end
			end

			arg_163_1.timer = var_163_1 + var_163_3
		end
	end,
	sienna_unchained_health_to_cooldown_update = function (arg_164_0, arg_164_1, arg_164_2)
		local var_164_0 = arg_164_2.t
		local var_164_1 = 0.25

		if not arg_164_1.timer or var_164_0 >= arg_164_1.timer then
			arg_164_1.timer = var_164_0 + var_164_1

			local var_164_2 = ScriptUnit.has_extension(arg_164_0, "career_system")

			if var_164_2 and var_164_2:current_ability_cooldown_percentage() > 0 then
				var_164_2:reduce_activated_ability_cooldown_percent(0.1)

				local var_164_3 = ScriptUnit.has_extension(arg_164_0, "health_system"):get_max_health() / 20

				DamageUtils.add_damage_network(arg_164_0, arg_164_0, var_164_3, "torso", "life_tap", nil, Vector3(0, 0, 0), "life_tap", nil, arg_164_0, nil, nil, nil, nil, nil, nil, nil, nil, 1)
			end
		end
	end,
	victor_bountyhunter_activated_ability_railgun_delayed = function (arg_165_0, arg_165_1, arg_165_2)
		if ALIVE[arg_165_0] then
			ScriptUnit.extension(arg_165_0, "career_system"):reduce_activated_ability_cooldown_percent(arg_165_1.multiplier)
		end
	end,
	enter_sienna_unchained_activated_ability = function (arg_166_0, arg_166_1, arg_166_2)
		local var_166_0 = Managers.state.unit_storage:go_id(arg_166_0)
		local var_166_1 = Managers.state.network
		local var_166_2 = var_166_1:game()

		if not var_166_0 or not var_166_2 then
			return
		end

		local var_166_3 = GameSession.game_object_field(var_166_2, var_166_0, "aim_direction")
		local var_166_4 = Managers.state.entity:system("ai_system"):nav_world()
		local var_166_5 = POSITION_LOOKUP[arg_166_0]
		local var_166_6 = 2
		local var_166_7 = 30
		local var_166_8 = LocomotionUtils.pos_on_mesh(var_166_4, var_166_5, var_166_6, var_166_7) or GwNavQueries.inside_position_from_outside_position(var_166_4, var_166_5, var_166_6, var_166_7, 2, 0.5)

		if var_166_8 then
			local var_166_9 = "sienna_unchained_ability_patch"
			local var_166_10 = NetworkLookup.liquid_area_damage_templates[var_166_9]
			local var_166_11 = var_166_1:unit_game_object_id(arg_166_0)

			var_166_1.network_transmit:send_rpc_server("rpc_create_liquid_damage_area", var_166_11, var_166_8, var_166_3, var_166_10)
		end

		if var_0_7(arg_166_0) then
			ScriptUnit.extension(arg_166_0, "first_person_system"):play_hud_sound_event("Play_career_ability_sienna_unchained", nil, true)
		end
	end,
	sienna_adept_double_trail_talent_start_ability_cooldown_add = function (arg_167_0, arg_167_1, arg_167_2)
		if ALIVE[arg_167_0] and not arg_167_1.aborted and var_0_7(arg_167_0) then
			local var_167_0 = ScriptUnit.extension(arg_167_0, "buff_system")
			local var_167_1 = arg_167_1.template.buff_to_add

			var_167_0:add_buff(var_167_1)
		end
	end,
	sienna_adept_double_trail_talent_start_ability_cooldown = function (arg_168_0, arg_168_1, arg_168_2)
		if ALIVE[arg_168_0] and not arg_168_1._already_removed and var_0_7(arg_168_0) then
			local var_168_0 = ScriptUnit.extension(arg_168_0, "career_system")

			var_168_0:set_abilities_always_usable(false, "sienna_adept_ability_trail_double")
			var_168_0:stop_ability("cooldown_triggered")
			var_168_0:start_activated_ability_cooldown()
		end

		arg_168_1._already_removed = true
	end,
	end_sienna_unchained_activated_ability = function (arg_169_0, arg_169_1, arg_169_2)
		if var_0_7(arg_169_0) then
			ScriptUnit.extension(arg_169_0, "career_system"):set_state("default")
		end
	end,
	apply_shade_activated_ability = function (arg_170_0, arg_170_1, arg_170_2, arg_170_3)
		local var_170_0 = Managers.state.network.network_transmit
		local var_170_1 = Managers.state.unit_storage:go_id(arg_170_0)
		local var_170_2 = NetworkLookup.flow_events.vfx_career_ability_start

		if Managers.state.network.is_server then
			if var_0_8(arg_170_0) then
				Unit.flow_event(arg_170_0, "vfx_career_ability_start")
			end

			var_170_0:send_rpc_clients("rpc_flow_event", var_170_1, var_170_2)
		else
			var_170_0:send_rpc_server("rpc_flow_event", var_170_1, var_170_2)
		end

		local var_170_3 = ScriptUnit.extension(arg_170_0, "status_system")

		var_170_3:set_noclip(true, arg_170_1)
		var_170_3:set_invisible(true, nil, arg_170_1)

		if not var_0_8(arg_170_0) then
			Managers.state.camera:set_mood("skill_shade", arg_170_1, true)
		end
	end,
	on_apply_shade_dash_stealth = function (arg_171_0, arg_171_1, arg_171_2, arg_171_3)
		if var_0_7(arg_171_0) then
			local var_171_0 = ScriptUnit.extension(arg_171_0, "status_system")

			var_171_0:set_invisible(true, nil, arg_171_1)
			var_171_0:set_noclip(true, arg_171_1)
		end
	end,
	on_remove_shade_dash_stealth = function (arg_172_0, arg_172_1, arg_172_2, arg_172_3)
		if var_0_7(arg_172_0) then
			local var_172_0 = ScriptUnit.has_extension(arg_172_0, "status_system")

			var_172_0:set_invisible(false, nil, arg_172_1)
			var_172_0:set_noclip(false, arg_172_1)
		end
	end,
	kerillian_shade_noclip_on = function (arg_173_0, arg_173_1, arg_173_2)
		if ALIVE[arg_173_0] then
			local var_173_0 = ScriptUnit.has_extension(arg_173_0, "status_system")

			if var_173_0 then
				var_173_0:set_noclip(true, "shade_phasing")
			end
		end
	end,
	kerillian_shade_noclip_off = function (arg_174_0, arg_174_1, arg_174_2)
		if ALIVE[arg_174_0] then
			local var_174_0 = ScriptUnit.has_extension(arg_174_0, "status_system")

			if var_174_0 then
				var_174_0:set_noclip(false, "shade_phasing")
			end
		end
	end,
	kerillian_shade_missed_combo_window = function (arg_175_0, arg_175_1, arg_175_2)
		if ALIVE[arg_175_0] and not arg_175_1.killed_target then
			local var_175_0 = ScriptUnit.extension(arg_175_0, "buff_system")
			local var_175_1 = var_175_0:get_buff_type("kerillian_shade_ult_invis")

			if var_175_1 then
				var_175_0:remove_buff(var_175_1.id)
			end
		end
	end,
	on_shade_activated_ability_remove = function (arg_176_0, arg_176_1, arg_176_2, arg_176_3)
		if not ALIVE[arg_176_0] then
			return
		end

		if not var_0_7(arg_176_0) then
			return
		end

		local var_176_0 = arg_176_1.template
		local var_176_1 = ScriptUnit.extension(arg_176_0, "status_system")

		var_176_1:set_invisible(false, nil, arg_176_1)
		var_176_1:set_noclip(false, arg_176_1)

		local var_176_2 = ScriptUnit.has_extension(arg_176_0, "talent_system")
		local var_176_3 = ScriptUnit.has_extension(arg_176_0, "buff_system")

		if not var_176_2 or not var_176_3 then
			return
		end

		local var_176_4 = ScriptUnit.extension(arg_176_0, "first_person_system")

		var_176_4:play_hud_sound_event("Stop_career_ability_kerillian_shade_loop")
		var_176_4:play_hud_sound_event("Play_career_ability_kerillian_shade_exit", nil, true)
		var_176_4:play_remote_hud_sound_event("Stop_career_ability_kerillian_shade_loop_husk")

		if not var_0_8(arg_176_0) then
			Managers.state.camera:set_mood("skill_shade", arg_176_1, false)
		end

		ScriptUnit.extension(arg_176_0, "career_system"):set_state("default")
		var_176_1:set_is_dodging(false)

		if var_176_0.can_restealth_combo and var_176_2:has_talent("kerillian_shade_activated_stealth_combo") then
			var_176_3:add_buff("kerillian_shade_ult_invis_combo_blocker")
			var_176_3:add_buff("kerillian_shade_ult_invis")
		end

		if var_176_0.can_restealth_on_remove and var_176_2:has_talent("kerillian_shade_activated_ability_restealth") then
			var_176_3:add_buff("kerillian_shade_activated_ability_restealth")

			local var_176_5 = var_176_3:get_stacking_buff("kerillian_shade_activated_ability_restealth")[1]
			local var_176_6 = ScriptUnit.extension(arg_176_0, "inventory_system"):get_weapon_unit()
			local var_176_7 = ScriptUnit.extension(var_176_6, "weapon_system")

			if var_176_7:has_current_action() then
				var_176_5.triggering_action_start_t = var_176_7:get_current_action().action_start_t
			end
		end

		if var_176_2:has_talent("kerillian_shade_activated_ability_phasing") then
			var_176_3:add_buff("kerillian_shade_phasing_buff")
			var_176_3:add_buff("kerillian_shade_movespeed_buff")
			var_176_3:add_buff("kerillian_shade_power_buff")
		end
	end,
	on_crit_passive_removed = function (arg_177_0, arg_177_1, arg_177_2)
		local var_177_0 = ScriptUnit.extension(arg_177_0, "buff_system")
		local var_177_1 = arg_177_1.template.reference_buff
		local var_177_2 = var_177_0:get_non_stacking_buff(var_177_1)

		if var_177_2 and var_177_2.buff_list then
			local var_177_3 = #var_177_2.buff_list

			for iter_177_0 = 1, var_177_3 do
				local var_177_4 = table.remove(var_177_2.buff_list)

				if var_177_4 then
					var_177_0:remove_buff(var_177_4)
				end
			end

			var_177_2.buff_list = {}
		end
	end,
	remove_invulnd_flash = function (arg_178_0, arg_178_1, arg_178_2)
		if ALIVE[arg_178_0] then
			ScriptUnit.has_extension(arg_178_0, "career_system"):set_activated_ability_cooldown_unpaused()
		end
	end,
	add_invulnd_flash = function (arg_179_0, arg_179_1, arg_179_2)
		if ALIVE[arg_179_0] and Managers.player.is_server then
			StatusUtils.set_knocked_down_network(arg_179_0, false)
		end
	end,
	apply_huntsman_activated_ability = function (arg_180_0, arg_180_1, arg_180_2)
		if var_0_10(arg_180_0) then
			Unit.flow_event(arg_180_0, "vfx_career_ability_start")
		end

		if var_0_7(arg_180_0) then
			ScriptUnit.has_extension(arg_180_0, "status_system"):set_invisible(true, nil, "huntsman_ability")
			ScriptUnit.extension(arg_180_0, "first_person_system"):play_remote_hud_sound_event("Play_career_ability_markus_huntsman_loop_husk")
		end
	end,
	end_huntsman_activated_ability = function (arg_181_0, arg_181_1, arg_181_2)
		if var_0_7(arg_181_0) then
			ScriptUnit.extension(arg_181_0, "career_system"):set_state("default")
			ScriptUnit.extension(arg_181_0, "status_system"):set_invisible(false, nil, "huntsman_ability")

			local var_181_0 = ScriptUnit.extension(arg_181_0, "first_person_system")

			var_181_0:play_hud_sound_event("Stop_career_ability_markus_huntsman_loop")
			var_181_0:play_hud_sound_event("Play_career_ability_markus_huntsman_exit", nil, true)
			var_181_0:play_remote_hud_sound_event("Stop_career_ability_markus_huntsman_loop_husk")

			if not var_0_8(arg_181_0) then
				Managers.state.camera:set_mood("skill_huntsman_surge", "skill_huntsman_surge", false)
				Managers.state.camera:set_mood("skill_huntsman_stealth", "skill_huntsman_stealth", false)
			end
		end
	end,
	end_slayer_activated_ability = function (arg_182_0, arg_182_1, arg_182_2)
		if var_0_7(arg_182_0) then
			local var_182_0 = ScriptUnit.extension(arg_182_0, "career_system")
			local var_182_1 = ScriptUnit.extension(arg_182_0, "status_system")
			local var_182_2 = ScriptUnit.extension(arg_182_0, "first_person_system")

			var_182_1:set_noclip(false, "skill_slayer")
			var_182_2:play_hud_sound_event("Play_career_ability_bardin_slayer_exit", nil, true)
			var_182_2:play_hud_sound_event("Stop_career_ability_bardin_slayer_loop")
			var_182_0:set_state("default")

			if not var_0_8(arg_182_0) then
				Managers.state.camera:set_mood("skill_slayer", "skill_slayer", false)
			end
		end
	end,
	add_victor_zealot_invulnerability_cooldown = function (arg_183_0, arg_183_1, arg_183_2)
		local var_183_0 = arg_183_0
		local var_183_1 = ScriptUnit.extension(var_183_0, "buff_system")

		if Unit.alive(var_183_0) then
			var_183_1:add_buff("victor_zealot_invulnerability_cooldown")
		end
	end,
	end_zealot_activated_ability = function (arg_184_0, arg_184_1, arg_184_2)
		if var_0_7(arg_184_0) then
			local var_184_0 = ScriptUnit.extension(arg_184_0, "career_system")
			local var_184_1 = ScriptUnit.extension(arg_184_0, "status_system")
			local var_184_2 = ScriptUnit.extension(arg_184_0, "first_person_system")

			var_184_1:set_noclip(false, "skill_zealot")
			var_184_2:play_remote_unit_sound_event("Play_career_ability_victor_zealot_exit", arg_184_0, 0)
			var_184_0:set_state("default")

			if not var_0_8(arg_184_0) then
				var_184_2:play_hud_sound_event("Play_career_ability_victor_zealot_exit")
				var_184_2:play_hud_sound_event("Stop_career_ability_victor_zealot_loop")
				Managers.state.camera:set_mood("skill_zealot", "skill_zealot", false)
			end
		end
	end,
	bardin_ironbreaker_stacking_buff_gromril = function (arg_185_0, arg_185_1, arg_185_2)
		local var_185_0 = arg_185_1.template
		local var_185_1 = ScriptUnit.extension(arg_185_0, "buff_system")
		local var_185_2 = var_185_0.activation_buff

		if var_185_1:get_non_stacking_buff(var_185_2) then
			arg_185_1.buff_ids = arg_185_1.buff_ids or {}

			local var_185_3 = #arg_185_1.buff_ids

			if var_185_3 < var_185_0.max_sub_buff_stacks then
				local var_185_4 = var_185_0.buff_to_add
				local var_185_5 = var_185_1:add_buff(var_185_4)

				arg_185_1.buff_ids[var_185_3 + 1] = var_185_5
			end
		end
	end,
	update_bardin_ironbreaker_activated_ability = function (arg_186_0, arg_186_1, arg_186_2)
		local var_186_0 = 3

		if var_0_7(arg_186_0) then
			if not arg_186_2.next_vo_time then
				arg_186_2.next_vo_time = arg_186_2.t + var_186_0
			elseif arg_186_2.t >= arg_186_2.next_vo_time then
				arg_186_2.next_vo_time = arg_186_2.t + var_186_0

				local var_186_1 = ScriptUnit.extension_input(arg_186_0, "dialogue_system")
				local var_186_2 = FrameTable.alloc_table()

				var_186_1:trigger_networked_dialogue_event("activate_ability_taunt", var_186_2)
			end
		end
	end,
	end_bardin_ironbreaker_activated_ability = function (arg_187_0, arg_187_1, arg_187_2)
		if var_0_7(arg_187_0) then
			arg_187_2.next_vo_time = nil

			local var_187_0 = ScriptUnit.extension(arg_187_0, "first_person_system")

			var_187_0:play_hud_sound_event("Play_career_ability_bardin_ironbreaker_exit")
			var_187_0:play_remote_unit_sound_event("Play_career_ability_bardin_ironbreaker_exit", arg_187_0, 0)
		end
	end,
	play_sound_synced = function (arg_188_0, arg_188_1, arg_188_2)
		if not ALIVE[arg_188_0] then
			return false
		end

		if var_0_7(arg_188_0) then
			local var_188_0 = ScriptUnit.extension(arg_188_0, "first_person_system")
			local var_188_1 = arg_188_1.template.sound_to_play

			var_188_0:play_hud_sound_event(var_188_1, nil, true)
		end
	end,
	ranger_activated_ability_buff = function (arg_189_0, arg_189_1, arg_189_2)
		if var_0_7(arg_189_0) then
			ScriptUnit.extension(arg_189_0, "status_system"):set_invisible(true, nil, arg_189_1)
		end
	end,
	ranger_activated_ability_buff_remove = function (arg_190_0, arg_190_1, arg_190_2)
		if var_0_7(arg_190_0) then
			ScriptUnit.extension(arg_190_0, "status_system"):set_invisible(false, nil, arg_190_1)
		end
	end,
	bardin_ranger_smoke_buff = function (arg_191_0, arg_191_1, arg_191_2)
		local var_191_0 = arg_191_1.template
		local var_191_1 = POSITION_LOOKUP[arg_191_1.area_buff_unit]

		if not var_191_1 then
			return
		end

		local var_191_2 = Managers.state.side.side_by_unit[arg_191_0]

		if not var_191_2 then
			return
		end

		local var_191_3 = Managers.state.entity:system("buff_system")
		local var_191_4 = var_191_0.area_radius
		local var_191_5 = var_191_4 * var_191_4
		local var_191_6 = var_191_0.smoke_buff
		local var_191_7 = var_191_2.PLAYER_AND_BOT_UNITS

		for iter_191_0 = 1, #var_191_7 do
			local var_191_8 = var_191_7[iter_191_0]

			if ALIVE[var_191_8] then
				local var_191_9 = POSITION_LOOKUP[var_191_8]

				if var_191_5 > Vector3.distance_squared(var_191_9, var_191_1) and not ScriptUnit.extension(var_191_8, "buff_system"):has_buff_type(var_191_6) then
					local var_191_10 = Managers.player:owner(var_191_8).peer_id

					var_191_3:add_buff_synced(var_191_8, var_191_6, var_191_0.buff_sync_type, nil, var_191_10)
				end
			end
		end
	end,
	bardin_ranger_heal_smoke = function (arg_192_0, arg_192_1, arg_192_2)
		if not Managers.state.network.is_server then
			return
		end

		local var_192_0 = arg_192_2.t
		local var_192_1 = arg_192_1.template

		if var_192_0 > (arg_192_1.next_heal_tick or 0) and HEALTH_ALIVE[arg_192_0] then
			if ScriptUnit.has_extension(arg_192_0, "talent_system") then
				local var_192_2 = ScriptUnit.has_extension(arg_192_0, "status_system")

				if not var_192_2 then
					return
				end

				local var_192_3 = var_192_1.heal_amount

				if not var_192_2:is_knocked_down() and not var_192_2:is_assisted_respawning() then
					DamageUtils.heal_network(arg_192_0, arg_192_0, var_192_3, "heal_from_proc")
				end
			end

			arg_192_1.next_heal_tick = var_192_0 + var_192_1.time_between_heals
		end
	end,
	update_server_buff_on_health_percent = function (arg_193_0, arg_193_1, arg_193_2)
		if not Managers.state.network.is_server then
			return
		end

		if ALIVE[arg_193_0] then
			local var_193_0 = ScriptUnit.has_extension(arg_193_0, "health_system")

			if var_193_0 then
				local var_193_1 = var_193_0:get_max_health()
				local var_193_2 = arg_193_1.template.threshold
				local var_193_3 = var_193_0:current_health()
				local var_193_4 = arg_193_1.template.buff_to_add

				if var_193_3 >= var_193_1 * arg_193_1.template.health_threshold and not arg_193_1.has_buff then
					arg_193_1.has_buff = Managers.state.entity:system("buff_system"):add_buff(arg_193_0, var_193_4, arg_193_0, true)
				elseif var_193_3 < var_193_1 * arg_193_1.template.health_threshold and arg_193_1.has_buff then
					Managers.state.entity:system("buff_system"):remove_server_controlled_buff(arg_193_0, arg_193_1.has_buff)

					arg_193_1.has_buff = nil
				end
			end
		end
	end,
	remove_server_buff_on_health_percent = function (arg_194_0, arg_194_1, arg_194_2)
		if not Managers.state.network.is_server then
			return
		end

		if ALIVE[arg_194_0] and arg_194_1.has_buff then
			Managers.state.entity:system("buff_system"):remove_server_controlled_buff(arg_194_0, arg_194_1.has_buff)

			arg_194_1.has_buff = nil
		end
	end,
	start_maidenguard_activated_ability = function (arg_195_0, arg_195_1, arg_195_2)
		ScriptUnit.extension(arg_195_0, "status_system"):set_noclip(true, arg_195_1)

		if var_0_7(arg_195_0) and not var_0_8(arg_195_0) then
			local var_195_0 = 0.8
			local var_195_1 = 0.2

			Managers.state.camera:set_additional_fov_multiplier_with_lerp_time(var_195_0, var_195_1)
		end
	end,
	end_maidenguard_activated_ability = function (arg_196_0, arg_196_1, arg_196_2)
		local var_196_0 = ScriptUnit.extension(arg_196_0, "status_system")

		var_196_0:set_noclip(false, arg_196_1)

		if var_0_7(arg_196_0) then
			if not var_0_8(arg_196_0) then
				local var_196_1 = 1
				local var_196_2 = 0.5

				Managers.state.camera:set_additional_fov_multiplier_with_lerp_time(var_196_1, var_196_2)
			end

			ScriptUnit.extension(arg_196_0, "career_system"):set_state("default")

			if Managers.state.network:game() then
				var_196_0:set_is_dodging(false)

				local var_196_3 = Managers.state.network
				local var_196_4 = var_196_3:unit_game_object_id(arg_196_0)

				var_196_3.network_transmit:send_rpc_server("rpc_status_change_bool", NetworkLookup.statuses.dodging, false, var_196_4, 0)
			end
		end
	end,
	start_maidenguard_ability_stealth = function (arg_197_0, arg_197_1, arg_197_2)
		local var_197_0 = ScriptUnit.extension(arg_197_0, "status_system")

		var_197_0:set_invisible(true, nil, arg_197_1)
		var_197_0:set_noclip(true, arg_197_1)

		if var_0_7(arg_197_0) and not var_0_8(arg_197_0) then
			Managers.state.camera:set_mood("skill_maiden_guard", arg_197_1, true)
		end
	end,
	end_maidenguard_ability_stealth = function (arg_198_0, arg_198_1, arg_198_2)
		local var_198_0 = ScriptUnit.extension(arg_198_0, "status_system")

		var_198_0:set_invisible(false, nil, arg_198_1)
		var_198_0:set_noclip(false, arg_198_1)

		if var_0_7(arg_198_0) and not var_0_8(arg_198_0) then
			Managers.state.camera:set_mood("skill_maiden_guard", arg_198_1, false)
		end
	end,
	end_knight_activated_ability = function (arg_199_0, arg_199_1, arg_199_2)
		if var_0_7(arg_199_0) then
			ScriptUnit.extension(arg_199_0, "status_system"):set_noclip(false, "skill_knight")
		end
	end,
	start_activated_ability_cooldown = function (arg_200_0, arg_200_1, arg_200_2)
		if var_0_7(arg_200_0) and arg_200_1.attacker_unit == arg_200_0 then
			ScriptUnit.extension(arg_200_0, "career_system"):start_activated_ability_cooldown()
		end
	end,
	update_bonus_based_on_missing_health_chunks = function (arg_201_0, arg_201_1, arg_201_2)
		local var_201_0 = ScriptUnit.extension(arg_201_0, "health_system"):get_damage_taken()
		local var_201_1 = arg_201_1.template
		local var_201_2 = var_201_1.min_bonus
		local var_201_3 = var_201_1.max_bonus
		local var_201_4 = var_201_1.chunk_size
		local var_201_5 = var_201_1.stat_buff
		local var_201_6 = arg_201_1.previous_bonus or 0
		local var_201_7 = math.floor(var_201_0 / var_201_4) * var_201_2

		if var_201_3 < var_201_7 then
			var_201_7 = var_201_3
		end

		arg_201_1.bonus = var_201_7

		if var_201_5 and var_201_6 ~= var_201_7 then
			local var_201_8 = ScriptUnit.extension(arg_201_0, "buff_system")
			local var_201_9 = var_201_7 - var_201_6

			var_201_8:update_stat_buff(var_201_5, var_201_9, var_201_1.name)
		end

		arg_201_1.previous_bonus = var_201_7
	end,
	update_multiplier_based_on_missing_health_chunks = function (arg_202_0, arg_202_1, arg_202_2)
		local var_202_0 = ScriptUnit.extension(arg_202_0, "health_system"):get_damage_taken()
		local var_202_1 = arg_202_1.template
		local var_202_2 = var_202_1.min_multiplier
		local var_202_3 = var_202_1.max_multiplier
		local var_202_4 = var_202_1.chunk_size
		local var_202_5 = var_202_1.stat_buff
		local var_202_6 = arg_202_1.previous_multiplier or 0
		local var_202_7 = math.floor(var_202_0 / var_202_4) * var_202_2

		if var_202_3 < var_202_7 then
			var_202_7 = var_202_3
		end

		arg_202_1.multiplier = var_202_7

		if var_202_5 and var_202_6 ~= var_202_7 then
			local var_202_8 = ScriptUnit.extension(arg_202_0, "buff_system")
			local var_202_9 = var_202_7 - var_202_6

			var_202_8:update_stat_buff(var_202_5, var_202_9, var_202_1.name)
		end

		arg_202_1.previous_multiplier = var_202_7
	end,
	update_bonus_based_on_overcharge_chunks = function (arg_203_0, arg_203_1, arg_203_2)
		if var_0_7(arg_203_0) then
			local var_203_0, var_203_1, var_203_2 = ScriptUnit.extension(arg_203_0, "overcharge_system"):current_overcharge_status()
			local var_203_3 = arg_203_1.template
			local var_203_4 = var_203_3.min_bonus
			local var_203_5 = var_203_3.max_bonus
			local var_203_6 = var_203_3.chunk_size
			local var_203_7 = var_203_3.stat_buff
			local var_203_8 = arg_203_1.previous_bonus or 0
			local var_203_9 = math.floor(var_203_0 / var_203_6) * var_203_4

			if var_203_5 < var_203_9 then
				var_203_9 = var_203_5
			end

			arg_203_1.bonus = var_203_9

			if var_203_7 and var_203_8 ~= var_203_9 then
				local var_203_10 = ScriptUnit.extension(arg_203_0, "buff_system")
				local var_203_11 = var_203_9 - var_203_8

				var_203_10:update_stat_buff(var_203_7, var_203_11, var_203_3.name)
			end

			arg_203_1.previous_bonus = var_203_9
		end
	end,
	apply_grenade_slow = function (arg_204_0, arg_204_1, arg_204_2)
		if Managers.state.network.is_server then
			arg_204_1.movement_modifier_id = ScriptUnit.extension(arg_204_0, "ai_navigation_system"):add_movement_modifier(0.2)
		end
	end,
	remove_grenade_slow = function (arg_205_0, arg_205_1, arg_205_2)
		if Managers.state.network.is_server then
			ScriptUnit.extension(arg_205_0, "ai_navigation_system"):remove_movement_modifier(arg_205_1.movement_modifier_id)
		end
	end,
	activate_bonus_based_on_low_health = function (arg_206_0, arg_206_1, arg_206_2)
		local var_206_0 = ScriptUnit.extension(arg_206_0, "health_system")
		local var_206_1 = arg_206_1.template
		local var_206_2 = var_206_0:get_damage_taken()
		local var_206_3 = var_206_0:get_max_health()
		local var_206_4 = var_206_1.activation_health
		local var_206_5 = 0

		if var_206_3 - var_206_2 < var_206_4 * var_206_3 then
			var_206_5 = var_206_1.multiplier
		end

		local var_206_6 = var_206_1.stat_buff
		local var_206_7 = arg_206_1.previous_multiplier or 0

		if var_206_6 and var_206_7 ~= var_206_5 then
			local var_206_8 = ScriptUnit.extension(arg_206_0, "buff_system")
			local var_206_9 = var_206_5 - var_206_7

			var_206_8:update_stat_buff(var_206_6, var_206_9, var_206_1.name)
		end

		arg_206_1.previous_multiplier = var_206_5
	end,
	reduce_cooldown_percent = function (arg_207_0, arg_207_1, arg_207_2)
		local var_207_0 = ScriptUnit.has_extension(arg_207_0, "career_system")

		if var_207_0 then
			local var_207_1 = arg_207_1.template.cooldown_amount

			var_207_0:reduce_activated_ability_cooldown_percent(var_207_1)
		end
	end,
	apply_volume_dot_damage = function (arg_208_0, arg_208_1, arg_208_2)
		arg_208_1.next_damage_time = arg_208_2.t + arg_208_2.bonus.time_between_damage
	end,
	update_volume_dot_damage = function (arg_209_0, arg_209_1, arg_209_2)
		if arg_209_1.next_damage_time < arg_209_2.t and HEALTH_ALIVE[arg_209_0] then
			arg_209_1.next_damage_time = arg_209_1.next_damage_time + arg_209_2.bonus.time_between_damage

			local var_209_0 = DamageUtils.calculate_damage(arg_209_2.bonus.damage, arg_209_0, arg_209_2.attacker_unit, "full", 1)

			DamageUtils.add_damage_network(arg_209_0, arg_209_2.attacker_unit, var_209_0, "full", arg_209_1.template.damage_type, nil, Vector3(1, 0, 0), nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, 1)
		end
	end,
	apply_volume_movement_buff = function (arg_210_0, arg_210_1, arg_210_2)
		local var_210_0 = PlayerUnitMovementSettings.get_movement_settings_table(arg_210_0)

		var_210_0.move_speed = var_210_0.move_speed * arg_210_2.multiplier
	end,
	remove_volume_movement_buff = function (arg_211_0, arg_211_1, arg_211_2)
		local var_211_0 = PlayerUnitMovementSettings.get_movement_settings_table(arg_211_0)

		var_211_0.move_speed = var_211_0.move_speed / arg_211_2.multiplier
	end,
	apply_speed_scaled_dot_buff = function (arg_212_0, arg_212_1, arg_212_2)
		if var_0_7(arg_212_0) then
			arg_212_1.next_damage_t = 0
		end
	end,
	update_speed_scaled_dot_buff = function (arg_213_0, arg_213_1, arg_213_2)
		if var_0_7(arg_213_0) then
			local var_213_0 = ScriptUnit.extension(arg_213_0, "locomotion_system")
			local var_213_1 = Vector3.flat(var_213_0:current_velocity())

			if Vector3.length(var_213_1) > 0.5 and arg_213_1.next_damage_t < arg_213_2.t and HEALTH_ALIVE[arg_213_0] then
				local var_213_2 = arg_213_1.template
				local var_213_3 = var_213_2.damage_type
				local var_213_4 = var_213_2.damage

				DamageUtils.add_damage_network(arg_213_0, arg_213_0, var_213_4, "torso", var_213_3, nil, Vector3(1, 0, 0), "buff", nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, 1)

				arg_213_1.next_damage_t = arg_213_2.t + var_213_2.damage_frequency
			end
		end
	end,
	remove_speed_scaled_dot_buff = function (arg_214_0, arg_214_1, arg_214_2)
		if var_0_7(arg_214_0) then
			-- Nothing
		end
	end,
	apply_twitch_invisibility_buff = function (arg_215_0, arg_215_1, arg_215_2)
		if var_0_7(arg_215_0) then
			local var_215_0 = ScriptUnit.extension(arg_215_0, "status_system")

			var_215_0:set_invisible(true, nil, "twitch_invis")
			var_215_0:set_noclip(true, "twitch_invis")

			if not var_0_8(arg_215_0) then
				ScriptUnit.extension(arg_215_0, "first_person_system"):play_hud_sound_event("Play_career_ability_kerillian_shade_enter_small")
				Managers.state.camera:set_mood("twitch_invis", arg_215_1, true)
			end
		end
	end,
	update_twitch_invisibility_buff = function (arg_216_0, arg_216_1, arg_216_2)
		return
	end,
	remove_twitch_invisibility_buff = function (arg_217_0, arg_217_1, arg_217_2)
		if var_0_7(arg_217_0) then
			local var_217_0 = ScriptUnit.extension(arg_217_0, "status_system")
			local var_217_1 = var_217_0:set_invisible(false, nil, "twitch_invis")

			var_217_0:set_noclip(false, "twitch_invis")

			if not var_0_8(arg_217_0) then
				Managers.state.camera:set_mood("twitch_invis", arg_217_1, false)
			end
		end
	end,
	apply_twitch_infinite_bombs = function (arg_218_0, arg_218_1, arg_218_2)
		return
	end,
	update_twitch_infinite_bombs = function (arg_219_0, arg_219_1, arg_219_2)
		if var_0_7(arg_219_0) then
			local var_219_0 = Managers.state.network.network_transmit
			local var_219_1 = ScriptUnit.extension(arg_219_0, "inventory_system")
			local var_219_2 = ScriptUnit.extension(arg_219_0, "career_system")
			local var_219_3 = AllPickups.frag_grenade_t1
			local var_219_4 = var_219_3.slot_name
			local var_219_5 = var_219_3.item_name
			local var_219_6 = var_219_1:get_slot_data(var_219_4)
			local var_219_7 = var_219_6 and var_219_6.item_data
			local var_219_8 = ItemMasterList[var_219_5]
			local var_219_9 = not var_219_6 or var_219_7.name ~= var_219_5

			if var_219_9 then
				local var_219_10 = {}

				if var_219_6 then
					var_219_1:destroy_slot(var_219_4)
					var_219_1:add_equipment(var_219_4, var_219_8, nil, var_219_10)
				else
					var_219_1:add_equipment(var_219_4, var_219_8, nil, var_219_10)
				end
			end

			local var_219_11

			repeat
				-- Nothing
			until not var_219_1:store_additional_item(var_219_4, var_219_8)

			if var_219_9 then
				local var_219_12 = Managers.state.unit_storage:go_id(arg_219_0)
				local var_219_13 = NetworkLookup.equipment_slots[var_219_4]
				local var_219_14 = NetworkLookup.item_names[var_219_5]
				local var_219_15 = NetworkLookup.weapon_skins["n/a"]

				if var_0_9() then
					var_219_0:send_rpc_clients("rpc_add_equipment", var_219_12, var_219_13, var_219_14, var_219_15)
				else
					var_219_0:send_rpc_server("rpc_add_equipment", var_219_12, var_219_13, var_219_14, var_219_15)
				end

				if var_219_1:get_wielded_slot_name() == var_219_4 then
					CharacterStateHelper.stop_weapon_actions(var_219_1, "picked_up_object")
					CharacterStateHelper.stop_career_abilities(var_219_2, "picked_up_object")
					var_219_1:wield(var_219_4)
				end
			end
		end
	end,
	remove_twitch_infinite_bombs = function (arg_220_0, arg_220_1, arg_220_2)
		return
	end,
	apply_twitch_invincibility = function (arg_221_0, arg_221_1, arg_221_2)
		if var_0_9() and Unit.alive(arg_221_0) then
			ScriptUnit.extension(arg_221_0, "health_system").is_invincible = true
		end
	end,
	remove_twitch_invincibility = function (arg_222_0, arg_222_1, arg_222_2)
		if var_0_9() and Unit.alive(arg_222_0) then
			ScriptUnit.extension(arg_222_0, "health_system").is_invincible = false
		end
	end,
	apply_twitch_pulsating_waves = function (arg_223_0, arg_223_1, arg_223_2)
		arg_223_1.next_pulse_t = arg_223_2.t
	end,
	update_twitch_pulsating_waves = function (arg_224_0, arg_224_1, arg_224_2, arg_224_3)
		if var_0_9() and Unit.alive(arg_224_0) then
			local var_224_0 = arg_224_2.t

			if var_224_0 > arg_224_1.next_pulse_t then
				local var_224_1 = "grenade_frag_01"
				local var_224_2 = ExplosionUtils.get_template("twitch_pulse_explosion")
				local var_224_3 = POSITION_LOOKUP[arg_224_0]

				DamageUtils.create_explosion(arg_224_3, arg_224_0, var_224_3, Quaternion.identity(), var_224_2, 1, var_224_1, true, false, arg_224_0, false)

				local var_224_4 = Managers.state.unit_storage:go_id(arg_224_0)
				local var_224_5 = NetworkLookup.explosion_templates[var_224_2.name]
				local var_224_6 = NetworkLookup.damage_sources[var_224_1]

				Managers.state.network.network_transmit:send_rpc_clients("rpc_create_explosion", var_224_4, false, var_224_3, Quaternion.identity(), var_224_5, 1, var_224_6, 0, false)

				arg_224_1.next_pulse_t = var_224_0 + 2
			end
		end
	end,
	add_modify_ability_max_cooldown = function (arg_225_0, arg_225_1, arg_225_2)
		if Unit.alive(arg_225_0) then
			ScriptUnit.extension(arg_225_0, "career_system"):modify_max_cooldown(1, 0, arg_225_1.template.multiplier)
		end
	end,
	remove_modify_ability_max_cooldown = function (arg_226_0, arg_226_1, arg_226_2)
		if Unit.alive(arg_226_0) then
			ScriptUnit.extension(arg_226_0, "career_system"):modify_max_cooldown(1, 0, -arg_226_1.template.multiplier)
		end
	end,
	refresh_ranged_slot_buffs = function (arg_227_0, arg_227_1, arg_227_2)
		local var_227_0 = ScriptUnit.has_extension(arg_227_0, "inventory_system")

		if var_227_0 then
			local var_227_1 = var_227_0:get_slot_data("slot_ranged")

			if var_227_1 then
				local var_227_2 = var_227_1.left_unit_1p
				local var_227_3 = var_227_1.right_unit_1p
				local var_227_4 = ScriptUnit.has_extension(var_227_2, "ammo_system")

				if var_227_4 then
					var_227_4:refresh_buffs()
				end

				local var_227_5 = ScriptUnit.has_extension(var_227_3, "ammo_system")

				if var_227_5 then
					var_227_5:refresh_buffs()
				end
			end
		end
	end,
	sienna_scholar_vent_zone_update = function (arg_228_0, arg_228_1, arg_228_2)
		local var_228_0 = arg_228_1.template
		local var_228_1 = var_228_0.buff_to_add
		local var_228_2 = ScriptUnit.extension(arg_228_0, "buff_system")
		local var_228_3 = var_228_2:get_stacking_buff(var_228_1)
		local var_228_4 = var_228_3 and #var_228_3 or 0
		local var_228_5 = Managers.state.side.side_by_unit[arg_228_0].enemy_broadphase_categories
		local var_228_6 = POSITION_LOOKUP[arg_228_0]
		local var_228_7 = var_228_0.radius
		local var_228_8 = FrameTable.alloc_table()
		local var_228_9 = AiUtils.broadphase_query(var_228_6, var_228_7, var_228_8, var_228_5)

		if var_228_4 < var_228_9 then
			for iter_228_0 = var_228_4 + 1, var_228_9 do
				var_228_2:add_buff(var_228_1)
			end
		elseif var_228_9 < var_228_4 then
			for iter_228_1 = 1, var_228_4 - var_228_9 do
				local var_228_10 = var_228_3[var_228_4 - iter_228_1 + 1]

				var_228_2:remove_buff(var_228_10.id)
			end
		end
	end,
	update_kill_timer = function (arg_229_0, arg_229_1, arg_229_2)
		if not Managers.state.network.is_server then
			return
		end

		local var_229_0 = arg_229_1.template.fuse_time

		if var_229_0 <= math.min(arg_229_2.time_into_buff, var_229_0) then
			local var_229_1 = "kinetic"
			local var_229_2 = Vector3(0, 0, -1)

			AiUtils.kill_unit(arg_229_0, nil, nil, var_229_1, var_229_2)
		end
	end,
	sorcerer_tether_buff_invulnerability_update = function (arg_230_0, arg_230_1, arg_230_2, arg_230_3)
		if not Managers.state.network.is_server then
			return
		end

		local var_230_0 = arg_230_1.attacker_unit

		if not HEALTH_ALIVE[var_230_0] then
			ScriptUnit.extension(arg_230_0, "buff_system"):remove_buff(arg_230_1.id)
		end
	end,
	sorcerer_tether_buff_apply_visuals = function (arg_231_0, arg_231_1, arg_231_2, arg_231_3)
		local var_231_0 = Unit.get_data(arg_231_0, "sorcerer_tether_buff_invulnerability_count") or 0

		if var_231_0 == 0 then
			local var_231_1 = Unit.has_node(arg_231_0, "j_hips") and Unit.node(arg_231_0, "j_hips") or 0
			local var_231_2 = World.spawn_unit(arg_231_3, "fx/units/sphere_troll_chief")

			World.link_unit(arg_231_3, var_231_2, 0, arg_231_0, var_231_1)
			Unit.set_data(arg_231_0, "sorcerer_tether_buff_invulnerability_visual", var_231_2)
		end

		Unit.set_data(arg_231_0, "sorcerer_tether_buff_invulnerability_count", var_231_0 + 1)
	end,
	sorcerer_tether_buff_remove_visuals = function (arg_232_0, arg_232_1, arg_232_2, arg_232_3)
		local var_232_0 = Unit.get_data(arg_232_0, "sorcerer_tether_buff_invulnerability_count")

		if var_232_0 == 1 then
			local var_232_1 = Unit.get_data(arg_232_0, "sorcerer_tether_buff_invulnerability_visual")

			World.destroy_unit(arg_232_3, var_232_1)
		end

		Unit.set_data(arg_232_0, "sorcerer_tether_buff_invulnerability_count", var_232_0 - 1)
	end
}

BuffFunctionTemplates.functions.update_charging_action_lerp_movement_buff = function (arg_233_0, arg_233_1, arg_233_2)
	local var_233_0 = arg_233_2.multiplier
	local var_233_1 = arg_233_2.time_into_buff
	local var_233_2
	local var_233_3
	local var_233_4
	local var_233_5 = ScriptUnit.extension(arg_233_0, "buff_system")

	var_233_0 = var_233_0 and 1 - var_233_5:apply_buffs_to_value(1 - var_233_0, "increased_move_speed_while_aiming")

	local var_233_6 = math.min(1, var_233_1 / arg_233_1.template.lerp_time)

	if var_233_0 then
		local var_233_7 = math.lerp(1, var_233_0, var_233_6)
		local var_233_8 = var_233_7 - arg_233_1.current_lerped_multiplier

		if math.abs(var_233_8) > 0.001 then
			var_233_3 = arg_233_1.current_lerped_multiplier
			arg_233_1.current_lerped_multiplier = var_233_7
			var_233_4 = var_233_7
		end
	end

	if var_233_4 then
		if arg_233_1.has_added_movement_previous_turn then
			buff_extension_function_params.value = var_233_2
			buff_extension_function_params.multiplier = var_233_3

			BuffFunctionTemplates.functions.remove_movement_buff(arg_233_0, arg_233_1, buff_extension_function_params)
		end

		arg_233_1.has_added_movement_previous_turn = true
		buff_extension_function_params.multiplier = var_233_4

		BuffFunctionTemplates.functions.apply_movement_buff(arg_233_0, arg_233_1, buff_extension_function_params)
	end
end

BuffFunctionTemplates.functions.ai_update_max_health = function (arg_234_0, arg_234_1, arg_234_2)
	if var_0_9() then
		local var_234_0 = ScriptUnit.extension(arg_234_0, "buff_system")
		local var_234_1 = ScriptUnit.has_extension(arg_234_0, "health_system")

		if var_234_0 and var_234_1 then
			local var_234_2 = var_234_1.unmodified_max_health
			local var_234_3 = math.max(var_234_0:apply_buffs_to_value(var_234_2, "max_health"), 0.25)

			var_234_1:set_max_health(var_234_3)
		end
	end
end, DLCUtils.merge("buff_function_templates", BuffFunctionTemplates.functions)
