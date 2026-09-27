-- chunkname: @scripts/unit_extensions/default_player_unit/buffs/buff_function_templates.lua

local scripts_unit_extensions_default_player_unit_buffs_settings_buff_perk_names = require("scripts/unit_extensions/default_player_unit/buffs/settings/buff_perk_names")
local BuffFunctionTemplates = BuffFunctionTemplates

BuffFunctionTemplates = BuffFunctionTemplates or {}
BuffFunctionTemplates = BuffFunctionTemplates

local is_frozen = Unit.is_frozen
local tbl = {}

local function fn(arg_1_0, arg_1_1)
	-- function 1
	fassert(#arg_1_0 > 0, "movement_setting_exists needs at least a movement_setting_to_modify")

	local get_movement_settings_table = PlayerUnitMovementSettings.get_movement_settings_table(arg_1_1)

	for i, v in ipairs(arg_1_0) do
		get_movement_settings_table = get_movement_settings_table[v]

		if not get_movement_settings_table then
			break
		end
	end

	if not get_movement_settings_table then
		return get_movement_settings_table
	else
		ferror("Variable does not exist in PlayerUnitMovementSettings")
	end
end

local function fn_2(self, arg_2_1, arg_2_2)
	-- function 2
	local count = #self

	fassert(count > 0, "movement_setting_exists needs at least a movement_setting_to_modify")

	local get_movement_settings_table = PlayerUnitMovementSettings.get_movement_settings_table(arg_2_1)
	local num = 1

	while num <= count do
		if count < num + 1 then
			get_movement_settings_table[self[num]] = arg_2_2
		else
			get_movement_settings_table = get_movement_settings_table[self[num]]
		end

		num = num + 1
	end
end

local tbl_2 = {}
local tbl_3 = {}

local function fn_3(arg_3_0)
	-- function 3
	local owner = Managers.player:owner(arg_3_0)

	return not owner and not owner.remote
end

local function fn_4(arg_4_0)
	-- function 4
	local owner = Managers.player:owner(arg_4_0)

	return not owner and owner.bot_player
end

local function fn_5()
	-- function 5
	return Managers.state.network.is_server
end

local function fn_6(arg_6_0)
	-- function 6
	local owner = Managers.player:owner(arg_6_0)
	local remote

	if not owner then
		remote = owner.remote

		if not remote then
			-- Nothing
		end

		remote = owner.bot_player

		if not remote then
			-- Nothing
		end
	end

	remote = false

	::label_6_0::

	return remote
end

local function fn_7(arg_7_0, arg_7_1, arg_7_2, arg_7_3, arg_7_4)
	-- function 7
	local go_id = Managers.state.unit_storage:go_id(arg_7_0)
	local game = Managers.state.network:game()
	local game_object_field = GameSession.game_object_field(game, go_id, "aim_direction")
	local var_7_3 = POSITION_LOOKUP[arg_7_0]
	local var_7_4 = POSITION_LOOKUP[arg_7_1]
	local flat = Vector3.flat(var_7_4 - var_7_3)
	local direction_length, var_7_7 = Vector3.direction_length(flat)

	if var_7_7 < math.epsilon then
		return true, 1
	end

	return Vector3.dot(game_object_field, direction_length) > math.cos(math.pi * 0.6666666666666666)
end

BuffFunctionTemplates.functions = {
	heal_owner = function (arg_8_0, arg_8_1, arg_8_2)
		-- function 8
		local heal_amount = arg_8_1.template.heal_amount
		local heal_type = arg_8_1.template.heal_type

		if not fn_5() then
			DamageUtils.heal_network(arg_8_0, arg_8_0, heal_amount, heal_type)
		else
			local network = Managers.state.network
			local unit_game_object_id = network:unit_game_object_id(arg_8_0)
			local var_8_4 = NetworkLookup.heal_types[heal_type]

			network.network_transmit:send_rpc_server("rpc_request_heal", unit_game_object_id, heal_amount, var_8_4)
		end
	end,
	apply_action_lerp_movement_buff = function (arg_9_0, arg_9_1, arg_9_2)
		-- function 9
		local bonus = arg_9_2.bonus
		local multiplier = arg_9_2.multiplier

		if not bonus then
			arg_9_1.current_lerped_value = 0
		end

		if not multiplier then
			arg_9_1.current_lerped_multiplier = 1
		end
	end,
	update_action_lerp_movement_buff = function (arg_10_0, arg_10_1, arg_10_2)
		-- function 10
		local bonus = arg_10_2.bonus
		local multiplier = arg_10_2.multiplier
		local time_into_buff = arg_10_2.time_into_buff
		local var_10_3
		local var_10_4
		local var_10_5
		local var_10_6
		local min = math.min(1, time_into_buff / arg_10_1.template.lerp_time)

		if not bonus then
			local lerp = math.lerp(0, bonus, min)

			var_10_3 = arg_10_1.current_lerped_value
			arg_10_1.current_lerped_value = lerp
			var_10_4 = lerp
		end

		if not multiplier then
			local lerp_2 = math.lerp(1, multiplier, min)

			var_10_5 = arg_10_1.current_lerped_multiplier
			arg_10_1.current_lerped_multiplier = lerp_2
			var_10_6 = lerp_2
		end

		if var_10_4 or not var_10_6 then
			if not arg_10_1.has_added_movement_previous_turn then
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
		-- function 11
		local extension = ScriptUnit.extension(arg_11_0, "buff_system")

		table.clear(tbl_2)

		tbl_2.external_optional_duration = nil
		tbl_2.external_optional_bonus = arg_11_1.current_lerped_value
		tbl_2.external_optional_multiplier = arg_11_1.current_lerped_multiplier

		extension:add_buff(arg_11_1.template.remove_buff_name, tbl_2)
	end,
	apply_action_lerp_remove_movement_buff = function (arg_12_0, arg_12_1, arg_12_2)
		-- function 12
		local bonus = arg_12_2.bonus
		local multiplier = arg_12_2.multiplier

		if not bonus then
			arg_12_1.current_lerped_value = bonus
		end

		if not multiplier then
			arg_12_1.current_lerped_multiplier = multiplier
		end

		arg_12_1.last_frame_percentage = 1
	end,
	update_action_lerp_remove_movement_buff = function (arg_13_0, arg_13_1, arg_13_2)
		-- function 13
		local bonus = arg_13_2.bonus
		local multiplier = arg_13_2.multiplier
		local time_into_buff = arg_13_2.time_into_buff
		local var_13_3
		local var_13_4
		local var_13_5
		local var_13_6

		if arg_13_1.last_frame_percentage == 0 then
			return
		end

		local num = 1 - math.min(1, time_into_buff / arg_13_1.template.lerp_time)

		arg_13_1.last_frame_percentage = num

		if not bonus then
			local lerp = math.lerp(0, bonus, num)

			var_13_4 = arg_13_1.current_lerped_value
			arg_13_1.current_lerped_value = lerp
			var_13_3 = lerp
		end

		if not multiplier then
			local lerp_2 = math.lerp(1, multiplier, num)

			var_13_5 = arg_13_1.current_lerped_multiplier
			arg_13_1.current_lerped_multiplier = lerp_2
			var_13_6 = lerp_2
		end

		if var_13_3 or not var_13_6 then
			buff_extension_function_params.value = var_13_4
			buff_extension_function_params.multiplier = var_13_5

			BuffFunctionTemplates.functions.remove_movement_buff(arg_13_0, arg_13_1, buff_extension_function_params)

			if num > 0 then
				buff_extension_function_params.value = var_13_3
				buff_extension_function_params.multiplier = var_13_6

				BuffFunctionTemplates.functions.apply_movement_buff(arg_13_0, arg_13_1, buff_extension_function_params)
			end
		end
	end,
	apply_movement_buff = function (arg_14_0, arg_14_1, arg_14_2)
		-- function 14
		local bonus = arg_14_2.bonus
		local multiplier = arg_14_2.multiplier

		if not arg_14_1.template.wind_mutator then
			multiplier = multiplier[Managers.weave:get_wind_strength()]
		end

		local path_to_movement_setting_to_modify = arg_14_1.template.path_to_movement_setting_to_modify
		local var_14_3 = fn(path_to_movement_setting_to_modify, arg_14_0)

		if not bonus then
			var_14_3 = var_14_3 + bonus
		end

		if not multiplier then
			var_14_3 = var_14_3 * multiplier
		end

		fn_2(path_to_movement_setting_to_modify, arg_14_0, var_14_3)
	end,
	remove_movement_buff = function (arg_15_0, arg_15_1, arg_15_2)
		-- function 15
		local bonus = arg_15_2.bonus
		local multiplier = arg_15_2.multiplier

		if not arg_15_1.template.wind_mutator then
			multiplier = multiplier[Managers.weave:get_wind_strength()]
		end

		local path_to_movement_setting_to_modify = arg_15_1.template.path_to_movement_setting_to_modify
		local var_15_3 = fn(path_to_movement_setting_to_modify, arg_15_0)

		if not multiplier then
			var_15_3 = var_15_3 / multiplier
		end

		if not bonus then
			var_15_3 = var_15_3 - bonus
		end

		fn_2(path_to_movement_setting_to_modify, arg_15_0, var_15_3)
	end,
	apply_ai_movement_buff = function (arg_16_0, arg_16_1, arg_16_2)
		-- function 16
		local var_16_0 = BLACKBOARDS[arg_16_0]
		local multiplier = arg_16_2.multiplier

		if not arg_16_1.template.wind_mutator then
			multiplier = multiplier[Managers.weave:get_wind_strength()]
		end

		arg_16_1.id = var_16_0.navigation_extension:add_movement_modifier(multiplier)
	end,
	remove_ai_movement_buff = function (arg_17_0, arg_17_1, arg_17_2)
		-- function 17
		BLACKBOARDS[arg_17_0].navigation_extension:remove_movement_modifier(arg_17_1.id)
	end,
	apply_rotation_limit_buff = function (arg_18_0, arg_18_1, arg_18_2)
		-- function 18
		local extension = ScriptUnit.extension(arg_18_0, "buff_system")
		local bonus = arg_18_1.bonus
		local get_stacking_buff = extension:get_stacking_buff(arg_18_1.template.name)

		for i = 1, #get_stacking_buff do
			local var_18_3 = get_stacking_buff[i]

			bonus = math.min(bonus, var_18_3.bonus)
		end

		local path_to_movement_setting_to_modify = arg_18_1.template.path_to_movement_setting_to_modify

		fn_2(path_to_movement_setting_to_modify, arg_18_0, bonus)
	end,
	remove_rotation_limit_buff = function (arg_19_0, arg_19_1, arg_19_2)
		-- function 19
		local extension = ScriptUnit.extension(arg_19_0, "buff_system")
		local huge = math.huge
		local get_stacking_buff = extension:get_stacking_buff(arg_19_1.template.name)

		for i = 1, #get_stacking_buff do
			local var_19_3 = get_stacking_buff[i]

			if var_19_3 ~= arg_19_1 then
				huge = math.min(huge, var_19_3.bonus)
			end
		end

		if huge == math.huge then
			huge = -1
		end

		local path_to_movement_setting_to_modify = arg_19_1.template.path_to_movement_setting_to_modify

		fn_2(path_to_movement_setting_to_modify, arg_19_0, huge)
	end,
	apply_screenspace_effect = function (arg_20_0, arg_20_1, arg_20_2, arg_20_3)
		-- function 20
		local screenspace_effect_name = arg_20_1.template.screenspace_effect_name
		local has_extension = ScriptUnit.has_extension(arg_20_0, "first_person_system")

		if not has_extension then
			has_extension:create_screen_particles(screenspace_effect_name)
		end
	end,
	knock_down_bleed_start = function (arg_21_0, arg_21_1, arg_21_2)
		-- function 21
		arg_21_1.next_damage_time = arg_21_2.t + arg_21_1.template.time_between_damage
	end,
	knock_down_bleed_update = function (arg_22_0, arg_22_1, arg_22_2)
		-- function 22
		if arg_22_1.next_damage_time < arg_22_2.t then
			local template = arg_22_1.template

			arg_22_1.next_damage_time = arg_22_1.next_damage_time + template.time_between_damage

			local damage = template.damage
			local damage_type = template.damage_type

			DamageUtils.add_damage_network(arg_22_0, arg_22_0, damage, "full", damage_type, nil, Vector3(1, 0, 0), "knockdown_bleed", nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, 1)
		end
	end,
	temporary_health_degen_start = function (arg_23_0, arg_23_1, arg_23_2)
		-- function 23
		arg_23_1.next_damage_time = arg_23_2.t + arg_23_1.template.time_between_damage
	end,
	temporary_health_degen_update = function (arg_24_0, arg_24_1, arg_24_2)
		-- function 24
		if arg_24_1.next_damage_time < arg_24_2.t then
			local template = arg_24_1.template

			arg_24_1.next_damage_time = arg_24_1.next_damage_time + template.time_between_damage

			local damage = template.damage
			local damage_type = template.damage_type

			DamageUtils.add_damage_network(arg_24_0, arg_24_0, damage, "full", damage_type, nil, Vector3(1, 0, 0), "temporary_health_degen", nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, 1)
		end
	end,
	health_degen_start = function (arg_25_0, arg_25_1, arg_25_2)
		-- function 25
		arg_25_1.next_damage_time = arg_25_2.t + arg_25_1.template.time_between_damage
	end,
	health_degen_update = function (arg_26_0, arg_26_1, arg_26_2)
		-- function 26
		if arg_26_1.next_damage_time < arg_26_2.t then
			local template = arg_26_1.template

			arg_26_1.next_damage_time = arg_26_1.next_damage_time + template.time_between_damage

			local damage = template.damage
			local damage_type = template.damage_type

			DamageUtils.add_damage_network(arg_26_0, arg_26_0, damage, "full", damage_type, nil, Vector3(1, 0, 0), "health_degen", nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, 1)
		end
	end,
	convert_permanent_to_temporary_health = function (arg_27_0, arg_27_1, arg_27_2)
		-- function 27
		if not Managers.state.network.is_server then
			local has_extension = ScriptUnit.has_extension(arg_27_0, "health_system")

			if not has_extension then
				has_extension:convert_permanent_to_temporary_health()
			end
		end
	end,
	life_drain_update_no_kill = function (arg_28_0, arg_28_1, arg_28_2)
		-- function 28
		if arg_28_1.next_damage_time < arg_28_2.t then
			local template = arg_28_1.template

			arg_28_1.next_damage_time = arg_28_1.next_damage_time + template.time_between_damage

			local var_28_1
			local extension = ScriptUnit.extension(arg_28_0, "health_system")
			local extension_2 = ScriptUnit.extension(arg_28_0, "status_system")
			local current_health = extension:current_health()

			if not (extension_2:is_in_end_zone() or not (current_health > 1)) then
				if current_health - template.damage > 1 then
					var_28_1 = template.damage
				else
					var_28_1 = current_health - 1
				end

				local damage_type = template.damage_type

				DamageUtils.add_damage_network(arg_28_0, arg_28_0, var_28_1, "full", damage_type, nil, Vector3(1, 0, 0), "life_drain", nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, 1)
			end
		end
	end,
	health_regen_all_start = function (arg_29_0, arg_29_1, arg_29_2)
		-- function 29
		if not Managers.state.network.is_server then
			arg_29_1.next_heal_time = arg_29_2.t + arg_29_1.template.time_between_heal
		end
	end,
	health_regen_all_update = function (arg_30_0, arg_30_1, arg_30_2)
		-- function 30
		if not (not Managers.state.network.is_server and not (arg_30_1.next_heal_time < arg_30_2.t)) then
			local template = arg_30_1.template

			arg_30_1.next_heal_time = arg_30_1.next_heal_time + template.time_between_heal

			local heal = template.heal
			local heal_type = template.heal_type

			heal_type = heal_type or "health_regen"

			local var_30_3 = Managers.state.side.side_by_unit[arg_30_0]

			if not var_30_3 then
				return
			end

			local PLAYER_AND_BOT_UNITS = var_30_3.PLAYER_AND_BOT_UNITS

			for i = 1, #PLAYER_AND_BOT_UNITS do
				DamageUtils.heal_network(PLAYER_AND_BOT_UNITS[i], arg_30_0, heal, heal_type)
			end
		end
	end,
	health_regen_start = function (arg_31_0, arg_31_1, arg_31_2)
		-- function 31
		if not Managers.state.network.is_server then
			local time_between_heal = arg_31_1.template.time_between_heal

			if type(arg_31_1.template.time_between_heal) == "table" then
				local get_difficulty_rank = Managers.state.difficulty:get_difficulty_rank()

				time_between_heal = arg_31_1.template.time_between_heal[get_difficulty_rank]
			end

			arg_31_1.next_heal_time = arg_31_2.t + time_between_heal
		end
	end,
	health_regen_update = function (arg_32_0, arg_32_1, arg_32_2)
		-- function 32
		if not (not Managers.state.network.is_server and not (arg_32_1.next_heal_time < arg_32_2.t)) then
			local template = arg_32_1.template
			local time_between_heal = template.time_between_heal

			if type(template.time_between_heal) == "table" then
				local get_difficulty_rank = Managers.state.difficulty:get_difficulty_rank()

				time_between_heal = template.time_between_heal[get_difficulty_rank]
			end

			arg_32_1.next_heal_time = arg_32_1.next_heal_time + time_between_heal

			local has_extension = ScriptUnit.has_extension(arg_32_0, "health_system")
			local heal = template.heal

			heal = heal or template.heal_percent * has_extension:get_max_health()

			local heal_type = template.heal_type

			heal_type = heal_type or "health_regen"

			DamageUtils.heal_network(arg_32_0, arg_32_0, heal, heal_type)
		end
	end,
	mutator_life_health_regeneration_start = function (arg_33_0, arg_33_1, arg_33_2)
		-- function 33
		if not Managers.state.network.is_server then
			arg_33_1.next_buff_time = arg_33_2.t + 5
			arg_33_1.health_regeneration_stack_ids = {}
		end
	end,
	mutator_life_health_regeneration_update = function (arg_34_0, arg_34_1, arg_34_2)
		-- function 34
		if not (not Managers.state.network.is_server and not (arg_34_1.next_buff_time < arg_34_2.t)) then
			local template = arg_34_1.template

			arg_34_1.next_buff_time = arg_34_1.next_buff_time + 5

			local has_extension = ScriptUnit.has_extension(arg_34_0, "buff_system")

			if not has_extension then
				local count = #arg_34_1.health_regeneration_stack_ids

				if count < 3 then
					local add_buff = has_extension:add_buff("mutator_life_health_regeneration_stacks")

					arg_34_1.health_regeneration_stack_ids[count + 1] = add_buff
				end
			end
		end
	end,
	remove_metal_mutator_gromril_armour = function (arg_35_0, arg_35_1, arg_35_2)
		-- function 35
		local tbl = {
			attacker_unit = arg_35_0
		}

		ScriptUnit.extension(arg_35_0, "buff_system"):add_buff("metal_mutator_damage_boost", tbl)
	end,
	start_blade_dance = function (arg_36_0, arg_36_1, arg_36_2, arg_36_3)
		-- function 36
		arg_36_2.next_tick_t = arg_36_2.t + 0.5

		local local_player = Managers.player:local_player()
		local flag = not local_player and local_player.player_unit
		local wwise_world = Managers.world:wwise_world(arg_36_3)
		local var_36_3

		if arg_36_0 == flag then
			local first_person_unit = ScriptUnit.extension(arg_36_0, "first_person_system").first_person_unit

			var_36_3 = World.create_particles(arg_36_3, "fx/magic_wind_metal_blade_dance_01_1p", POSITION_LOOKUP[first_person_unit])

			World.link_particles(arg_36_3, var_36_3, first_person_unit, Unit.node(first_person_unit, "root_point"), Matrix4x4.identity(), "stop")
			WwiseWorld.trigger_event(wwise_world, "Play_wind_metal_gameplay_mutator_wind_loop")
		else
			WwiseUtils.trigger_unit_event(arg_36_3, "Play_wind_metal_gameplay_mutator_wind_loop", arg_36_0, 0)

			var_36_3 = World.create_particles(arg_36_3, "fx/magic_wind_metal_blade_dance_01", POSITION_LOOKUP[arg_36_0])

			World.link_particles(arg_36_3, var_36_3, arg_36_0, Unit.node(arg_36_0, "root_point"), Matrix4x4.identity(), "stop")
		end

		arg_36_1.linked_effect = var_36_3
	end,
	update_blade_dance = function (arg_37_0, arg_37_1, arg_37_2)
		-- function 37
		if arg_37_2.t >= arg_37_2.next_tick_t then
			arg_37_2.next_tick_t = arg_37_2.t + 0.5

			local system = Managers.state.entity:system("area_damage_system")
			local num = POSITION_LOOKUP[arg_37_0] + Vector3(0, 0, 1)
			local local_rotation = Unit.local_rotation(arg_37_0, 0)

			system:create_explosion(arg_37_0, num, local_rotation, "metal_mutator_blade_dance", 1, "undefined", 0, false)
		end
	end,
	remove_blade_dance = function (arg_38_0, arg_38_1, arg_38_2, arg_38_3)
		-- function 38
		local unit_game_object_id = Managers.state.network:unit_game_object_id(arg_38_0)
		local local_player = Managers.player:local_player()
		local flag = not local_player and local_player.player_unit
		local wwise_world = Managers.world:wwise_world(arg_38_3)

		if arg_38_0 == flag then
			WwiseWorld.trigger_event(wwise_world, "Stop_wind_metal_gameplay_mutator_wind_loop")
		else
			WwiseUtils.trigger_unit_event(arg_38_3, "Stop_wind_metal_gameplay_mutator_wind_loop", arg_38_0, 0)
		end

		if not arg_38_1.linked_effect then
			World.destroy_particles(arg_38_3, arg_38_1.linked_effect)

			arg_38_1.linked_effect = nil
		end
	end,
	apply_beasts_totem_buff = function (arg_39_0, arg_39_1, arg_39_2, arg_39_3)
		-- function 39
		if not arg_39_1.fx_id then
			local create_particles = World.create_particles(arg_39_3, "fx/chr_beastmen_standard_bearer_buff_01", POSITION_LOOKUP[arg_39_0])

			arg_39_1.fx_id = create_particles

			World.link_particles(arg_39_3, create_particles, arg_39_0, Unit.node(arg_39_0, "root_point"), Matrix4x4.identity(), "stop")
		end
	end,
	remove_beasts_totem_buff = function (arg_40_0, arg_40_1, arg_40_2, arg_40_3)
		-- function 40
		if not arg_40_1.fx_id then
			World.stop_spawning_particles(arg_40_3, arg_40_1.fx_id)
		end
	end,
	apply_fire_mutator_bomb = function (arg_41_0, arg_41_1, arg_41_2, arg_41_3)
		-- function 41
		local local_player = Managers.player:local_player()

		if arg_41_0 == (not local_player and local_player.player_unit) then
			local has_extension = ScriptUnit.has_extension(arg_41_0, "first_person_system")

			if not has_extension then
				arg_41_1.screenspace_particle_id = has_extension:create_screen_particles("fx/screenspace_magic_wind_fire_01")
			end
		else
			local create_particles = World.create_particles(arg_41_3, "fx/magic_wind_fire_timer_01", POSITION_LOOKUP[arg_41_0])

			arg_41_1.linked_effect = create_particles

			World.link_particles(arg_41_3, create_particles, arg_41_0, Unit.node(arg_41_0, "root_point"), Matrix4x4.identity(), "stop")
		end
	end,
	update_fire_mutator_bomb = function (arg_42_0, arg_42_1, arg_42_2, arg_42_3)
		-- function 42
		return
	end,
	remove_fire_mutator_bomb = function (arg_43_0, arg_43_1, arg_43_2, arg_43_3)
		-- function 43
		if not arg_43_1.linked_effect then
			World.destroy_particles(arg_43_3, arg_43_1.linked_effect)

			arg_43_1.linked_effect = nil
		end

		local has_extension = ScriptUnit.has_extension(arg_43_0, "first_person_system")

		if not has_extension then
			has_extension:destroy_screen_particles(arg_43_1.screenspace_particle_id)
		end
	end,
	apply_mutator_life_poison_buff = function (arg_44_0, arg_44_1, arg_44_2, arg_44_3)
		-- function 44
		local life = WindSettings.life
		local get_wind_strength = Managers.weave:get_wind_strength()
		local var_44_2 = life.thorns_damage[get_wind_strength]
	end,
	start_dot_damage = function (arg_45_0, arg_45_1, arg_45_2)
		-- function 45
		if arg_45_1.template.damage_type == "burninating" then
			local attacker_unit = arg_45_2.attacker_unit
			local flag = not attacker_unit and ScriptUnit.has_extension(attacker_unit, "buff_system")
			local has_extension = ScriptUnit.has_extension(arg_45_0, "buff_system")

			if not has_extension and not flag and not flag:has_buff_type("sienna_unchained_burn_increases_damage_taken") then
				local get_non_stacking_buff = flag:get_non_stacking_buff("sienna_unchained_burn_increases_damage_taken")

				table.clear(tbl_2)

				tbl_2.external_optional_multiplier = get_non_stacking_buff.multiplier
				tbl_2.external_optional_duration = arg_45_1.duration

				has_extension:add_buff("increase_damage_recieved_while_burning", tbl_2)
			end
		end
	end,
	reapply_dot_damage = function (arg_46_0, arg_46_1, arg_46_2)
		-- function 46
		if arg_46_1.template.damage_type == "burninating" then
			local attacker_unit = arg_46_2.attacker_unit
			local flag = not attacker_unit and ScriptUnit.has_extension(attacker_unit, "buff_system")
			local has_extension = ScriptUnit.has_extension(arg_46_0, "buff_system")

			if not has_extension and not flag and not flag:has_buff_type("sienna_unchained_burn_increases_damage_taken") then
				local get_non_stacking_buff = flag:get_non_stacking_buff("sienna_unchained_burn_increases_damage_taken")

				table.clear(tbl_2)

				tbl_2.external_optional_multiplier = get_non_stacking_buff.multiplier
				tbl_2.external_optional_duration = arg_46_1.duration

				has_extension:add_buff("increase_damage_recieved_while_burning", tbl_2)
			end
		end
	end,
	apply_dot_damage = function (arg_47_0, arg_47_1, arg_47_2)
		-- function 47
		local t = arg_47_2.t
		local var_47_1 = t

		if not HEALTH_ALIVE[arg_47_0] then
			local template = arg_47_1.template
			local time_between_dot_damages = arg_47_1.template.time_between_dot_damages
			local perks = arg_47_1.template.perks

			if not perks and not table.find(perks, scripts_unit_extensions_default_player_unit_buffs_settings_buff_perk_names.burning_balefire) then
				local source_attacker_unit = arg_47_1.source_attacker_unit

				source_attacker_unit = source_attacker_unit or arg_47_1.attacker_unit

				local has_extension = ScriptUnit.has_extension(source_attacker_unit, "buff_system")

				if not (not has_extension and Managers.state.side:is_ally(arg_47_0, source_attacker_unit)) then
					time_between_dot_damages = time_between_dot_damages * has_extension:apply_buffs_to_value(1, "increased_balefire_dot_duration")
				end
			end

			var_47_1 = var_47_1 + (0.75 * time_between_dot_damages + math.random() * 0.5 * time_between_dot_damages)

			if not Managers.state.network.is_server then
				local attacker_unit = arg_47_2.attacker_unit
				local source_attacker_unit_2 = arg_47_2.source_attacker_unit

				if not (not ALIVE[attacker_unit] and attacker_unit) then
					-- Nothing
				end

				::label_47_0::

				local var_47_9 = ALIVE[source_attacker_unit_2]

				var_47_9 = not var_47_9 and source_attacker_unit_2

				::label_47_1::

				if not var_47_9 then
					if not arg_47_1.template.custom_dot_tick_func then
						BuffFunctionTemplates.functions[arg_47_1.template.custom_dot_tick_func](arg_47_0, arg_47_1, arg_47_2)
					else
						local var_47_10 = arg_47_0
						local hit_zone = arg_47_1.template.hit_zone

						hit_zone = hit_zone or "full"

						local down = Vector3.down()
						local var_47_13
						local str = "dot_debuff"
						local power_level = arg_47_1.power_level

						power_level = power_level or DefaultPowerLevel

						local damage_profile = template.damage_profile

						damage_profile = damage_profile or "default"

						local var_47_17 = DamageProfileTemplates[damage_profile]
						local var_47_18
						local num = 0
						local flag = false
						local flag_2 = true
						local dot_stagger = var_47_17.dot_stagger
						local flag_3 = false
						local flag_4 = false
						local var_47_25
						local var_47_26
						local var_47_27

						DamageUtils.server_apply_hit(t, var_47_9, var_47_10, hit_zone, nil, down, var_47_13, str, power_level, var_47_17, var_47_18, num, flag, flag_2, dot_stagger, flag_3, flag_4, var_47_25, var_47_26, var_47_27, source_attacker_unit_2)
					end
				end
			end
		end

		if not arg_47_1.template.sound_event and not fn_3(arg_47_0) then
			local has_extension_2 = ScriptUnit.has_extension(arg_47_0, "first_person_system")

			if not has_extension_2 then
				has_extension_2:play_hud_sound_event(arg_47_1.template.sound_event)
			end
		end

		local perks_2 = arg_47_1.template.perks

		if not perks_2 then
			for i = 1, #perks_2 do
				local var_47_30 = perks_2[i]
				local flag_5 = not var_47_30 and tbl[var_47_30]

				if not flag_5 then
					local source_attacker_unit_3 = arg_47_2.source_attacker_unit

					source_attacker_unit_3 = source_attacker_unit_3 or AiUtils.get_actual_attacker_unit(arg_47_2.attacker_unit)

					if not fn_3(source_attacker_unit_3) then
						local has_extension_3 = ScriptUnit.has_extension(source_attacker_unit_3, "first_person_system")

						if not has_extension_3 then
							has_extension_3:play_hud_sound_event(flag_5)
						end
					end
				end
			end
		end

		return var_47_1
	end,
	apply_moving_through_vomit = function (arg_48_0, arg_48_1, arg_48_2, arg_48_3)
		-- function 48
		local get_difficulty = Managers.state.difficulty:get_difficulty()

		arg_48_1.damage = arg_48_1.template.difficulty_damage[get_difficulty]

		local armor_category = Unit.get_data(arg_48_0, "breed").armor_category

		armor_category = armor_category or 1
		arg_48_1.armor_type = armor_category

		local has_extension = ScriptUnit.has_extension(arg_48_0, "first_person_system")

		if not has_extension then
			arg_48_1.vomit_particle_id = has_extension:create_screen_particles("fx/screenspace_vomit_hit_onfeet")
		end

		local attacker_unit = arg_48_2.attacker_unit

		if not Unit.alive(attacker_unit) then
			local has_extension_2 = ScriptUnit.has_extension(attacker_unit, "area_damage_system")

			if not has_extension_2 then
				local get_source_attacker_unit = has_extension_2:get_source_attacker_unit()
				local var_48_6 = ALIVE[get_source_attacker_unit]

				var_48_6 = not var_48_6 and Unit.get_data(get_source_attacker_unit, "breed")

				local name

				if not var_48_6 then
					name = var_48_6.name

					if not name then
						-- Nothing
					end
				end

				name = "dot_debuff"

				::label_48_0::

				arg_48_1.damage_source = name
			end
		end
	end,
	update_moving_through_vomit = function (arg_49_0, arg_49_1, arg_49_2, arg_49_3)
		-- function 49
		local t = arg_49_2.t
		local template = arg_49_1.template

		if not Managers.state.network.is_server and not HEALTH_ALIVE[arg_49_0] then
			local attacker_unit

			if not ALIVE[arg_49_2.attacker_unit] then
				attacker_unit = arg_49_2.attacker_unit

				if not attacker_unit then
					-- Nothing
				end
			end

			attacker_unit = arg_49_0

			::label_49_0::

			local armor_type = arg_49_1.armor_type
			local damage_type = template.damage_type
			local var_49_5 = arg_49_1.damage[armor_type]
			local damage_source = arg_49_1.damage_source
			local flag = not attacker_unit and ScriptUnit.has_extension(attacker_unit, "area_damage_system")

			if not flag then
				local buff_damage_multiplier = flag.buff_damage_multiplier

				buff_damage_multiplier = buff_damage_multiplier or 1
				var_49_5 = var_49_5 * buff_damage_multiplier
			end

			DamageUtils.add_damage_network(arg_49_0, attacker_unit, var_49_5, "torso", damage_type, nil, Vector3(1, 0, 0), damage_source, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, 1)
		end

		local owner = Managers.player:owner(arg_49_0)

		if not (not owner and owner.remote) then
			local fatigue_type = template.fatigue_type

			ScriptUnit.extension(arg_49_0, "status_system"):add_fatigue_points(fatigue_type)
		end

		local extension = ScriptUnit.extension(arg_49_0, "buff_system")
		local slowdown_buff_name = template.slowdown_buff_name

		if not slowdown_buff_name then
			extension:add_buff(slowdown_buff_name, arg_49_2)
		end

		local has_extension = ScriptUnit.has_extension(arg_49_0, "first_person_system")

		if not has_extension then
			has_extension:play_hud_sound_event("Play_player_damage_puke")
		end

		return t + template.time_between_dot_damages
	end,
	remove_moving_through_vomit = function (arg_50_0, arg_50_1, arg_50_2, arg_50_3)
		-- function 50
		local has_extension = ScriptUnit.has_extension(arg_50_0, "first_person_system")

		if not has_extension then
			has_extension:stop_spawning_screen_particles(arg_50_1.vomit_particle_id)
		end
	end,
	apply_catacombs_corpse_pit = function (arg_51_0, arg_51_1, arg_51_2, arg_51_3)
		-- function 51
		arg_51_1.next_tick = arg_51_2.t + 0
	end,
	update_catacombs_corpse_pit = function (arg_52_0, arg_52_1, arg_52_2, arg_52_3)
		-- function 52
		local t = arg_52_2.t
		local next_tick = arg_52_1.next_tick
		local template = arg_52_1.template

		if next_tick < t then
			local owner = Managers.player:owner(arg_52_0)

			if not (not owner and owner.remote) then
				local fatigue_type = template.fatigue_type

				ScriptUnit.extension(arg_52_0, "status_system"):add_fatigue_points(fatigue_type)
			end

			local extension = ScriptUnit.extension(arg_52_0, "buff_system")
			local slowdown_buff_name = template.slowdown_buff_name

			if not slowdown_buff_name then
				extension:add_buff(slowdown_buff_name, arg_52_2)
			end

			local has_extension = ScriptUnit.has_extension(arg_52_0, "first_person_system")

			if not has_extension then
				has_extension:play_hud_sound_event("Play_player_damage_puke")
			end

			arg_52_1.next_tick = t + template.time_between_ticks
		end
	end,
	remove_catacombs_corpse_pit = function (arg_53_0, arg_53_1, arg_53_2, arg_53_3)
		-- function 53
		return
	end,
	apply_moving_through_plague = function (arg_54_0, arg_54_1, arg_54_2, arg_54_3)
		-- function 54
		local get_difficulty = Managers.state.difficulty:get_difficulty()

		arg_54_1.damage = arg_54_1.template.difficulty_damage[get_difficulty]

		local armor_category = Unit.get_data(arg_54_0, "breed").armor_category

		armor_category = armor_category or 1
		arg_54_1.armor_type = armor_category

		local has_extension = ScriptUnit.has_extension(arg_54_0, "first_person_system")

		if not has_extension then
			arg_54_1.plague_particle_id = has_extension:create_screen_particles("fx/screenspace_cemetery_plague_01")
		end

		local attacker_unit = arg_54_2.attacker_unit

		if not Unit.alive(attacker_unit) then
			local has_extension_2 = ScriptUnit.has_extension(attacker_unit, "area_damage_system")

			if not has_extension_2 then
				local get_source_attacker_unit = has_extension_2:get_source_attacker_unit()
				local var_54_6 = ALIVE[get_source_attacker_unit]

				var_54_6 = not var_54_6 and Unit.get_data(get_source_attacker_unit, "breed")

				local name

				if not var_54_6 then
					name = var_54_6.name

					if not name then
						-- Nothing
					end
				end

				name = "dot_debuff"

				::label_54_0::

				arg_54_1.damage_source = name
			end
		end
	end,
	update_moving_through_plague = function (arg_55_0, arg_55_1, arg_55_2, arg_55_3)
		-- function 55
		local t = arg_55_2.t
		local template = arg_55_1.template

		if not Managers.state.network.is_server and not HEALTH_ALIVE[arg_55_0] then
			local attacker_unit

			if not ALIVE[arg_55_2.attacker_unit] then
				attacker_unit = arg_55_2.attacker_unit

				if not attacker_unit then
					-- Nothing
				end
			end

			attacker_unit = arg_55_0

			::label_55_0::

			local armor_type = arg_55_1.armor_type
			local damage_type = template.damage_type
			local var_55_5 = arg_55_1.damage[armor_type]
			local damage_source = arg_55_1.damage_source

			DamageUtils.add_damage_network(arg_55_0, attacker_unit, var_55_5, "torso", damage_type, nil, Vector3(1, 0, 0), damage_source, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, 1)
		end

		local owner = Managers.player:owner(arg_55_0)

		if not (not owner and owner.remote) then
			local fatigue_type = template.fatigue_type

			ScriptUnit.extension(arg_55_0, "status_system"):add_fatigue_points(fatigue_type)
		end

		local extension = ScriptUnit.extension(arg_55_0, "buff_system")
		local slowdown_buff_name = template.slowdown_buff_name

		if not slowdown_buff_name then
			extension:add_buff(slowdown_buff_name, arg_55_2)
		end

		local has_extension = ScriptUnit.has_extension(arg_55_0, "first_person_system")

		if not has_extension then
			has_extension:play_hud_sound_event("Play_player_damage_puke")
		end

		return t + template.time_between_dot_damages
	end,
	remove_moving_through_plague = function (arg_56_0, arg_56_1, arg_56_2, arg_56_3)
		-- function 56
		local has_extension = ScriptUnit.has_extension(arg_56_0, "first_person_system")

		if not has_extension then
			has_extension:stop_spawning_screen_particles(arg_56_1.plague_particle_id)
		end
	end,
	apply_mutator_life_thorns_poison = function (arg_57_0, arg_57_1, arg_57_2, arg_57_3)
		-- function 57
		local get_difficulty = Managers.state.difficulty:get_difficulty()

		arg_57_1.damage = arg_57_1.template.difficulty_damage[get_difficulty]

		local attacker_unit = arg_57_2.attacker_unit

		if not Unit.alive(attacker_unit) then
			local has_extension = ScriptUnit.has_extension(attacker_unit, "area_damage_system")

			if not has_extension then
				local _source_unit = has_extension._source_unit
				local var_57_4 = ALIVE[_source_unit]

				var_57_4 = not var_57_4 and Unit.get_data(_source_unit, "breed")

				local name

				if not var_57_4 then
					name = var_57_4.name

					if not name then
						-- Nothing
					end
				end

				name = "dot_debuff"

				::label_57_0::

				arg_57_1.damage_source = name
			end
		end
	end,
	update_mutator_life_thorns_poison = function (arg_58_0, arg_58_1, arg_58_2, arg_58_3)
		-- function 58
		local t = arg_58_2.t
		local template = arg_58_1.template

		if not Managers.state.network.is_server and not HEALTH_ALIVE[arg_58_0] then
			local attacker_unit

			if not ALIVE[arg_58_2.attacker_unit] then
				attacker_unit = arg_58_2.attacker_unit

				if not attacker_unit then
					-- Nothing
				end
			end

			attacker_unit = arg_58_0

			::label_58_0::

			local damage_type = template.damage_type
			local damage = arg_58_1.damage
			local damage_source = arg_58_1.damage_source

			DamageUtils.add_damage_network(arg_58_0, attacker_unit, damage, "torso", damage_type, nil, Vector3(1, 0, 0), damage_source, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, 1)
		end

		local owner = Managers.player:owner(arg_58_0)

		if not (not owner and owner.remote) then
			local fatigue_type = template.fatigue_type

			ScriptUnit.extension(arg_58_0, "status_system"):add_fatigue_points(fatigue_type)
		end

		local extension = ScriptUnit.extension(arg_58_0, "buff_system")
		local slowdown_buff_name = template.slowdown_buff_name

		if not slowdown_buff_name then
			extension:add_buff(slowdown_buff_name, arg_58_2)
		end

		return t + template.time_between_dot_damages
	end,
	remove_mutator_life_thorns_poison = function (arg_59_0, arg_59_1, arg_59_2, arg_59_3)
		-- function 59
		return
	end,
	apply_ai_movement_debuff = function (arg_60_0, arg_60_1, arg_60_2, arg_60_3)
		-- function 60
		local extension = ScriptUnit.extension(arg_60_0, "ai_navigation_system")
		local multiplier = arg_60_1.template.multiplier

		arg_60_1.movement_modifier_id = extension:add_movement_modifier(multiplier)
	end,
	remove_ai_movement_debuff = function (arg_61_0, arg_61_1, arg_61_2, arg_61_3)
		-- function 61
		ScriptUnit.extension(arg_61_0, "ai_navigation_system"):remove_movement_modifier(arg_61_1.movement_modifier_id)
	end,
	apply_chaos_zombie_explosion_in_face = function (arg_62_0, arg_62_1, arg_62_2, arg_62_3)
		-- function 62
		return
	end,
	update_chaos_zombie_explosion_in_face = function (arg_63_0, arg_63_1, arg_63_2, arg_63_3)
		-- function 63
		return
	end,
	remove_chaos_zombie_explosion_in_face = function (arg_64_0, arg_64_1, arg_64_2, arg_64_3)
		-- function 64
		local has_extension = ScriptUnit.has_extension(arg_64_0, "first_person_system")

		if not has_extension then
			has_extension:stop_spawning_screen_particles(arg_64_1.nurgle_particle_id_01)
			has_extension:stop_spawning_screen_particles(arg_64_1.nurgle_particle_id_02)
		end
	end,
	apply_plague_wave_in_face = function (arg_65_0, arg_65_1, arg_65_2, arg_65_3)
		-- function 65
		local get_difficulty = Managers.state.difficulty:get_difficulty()
		local template = arg_65_1.template

		arg_65_1.damage = template.difficulty_damage[get_difficulty]

		local armor_category = Unit.get_data(arg_65_0, "breed").armor_category

		armor_category = armor_category or 1
		arg_65_1.armor_type = armor_category

		local owner = Managers.player:owner(arg_65_0)
		local remote = owner.remote

		if not remote then
			remote = owner.bot_player
			remote = remote or false
		end

		if not remote then
			CosmeticsUtils.flow_event_mesh_3p(arg_65_0, "impact_vomit")
		end

		local has_extension = ScriptUnit.has_extension(arg_65_0, "first_person_system")

		if not has_extension then
			arg_65_1.plague_wave_opaque_particle_id = has_extension:create_screen_particles("fx/screenspace_plague_wave_01")
			arg_65_1.plague_wave_particle_id = has_extension:create_screen_particles("fx/screenspace_plauge_wave_02")

			has_extension:play_hud_sound_event("Play_player_hit_puke")
		end

		local var_65_6
		local attacker_unit = arg_65_2.attacker_unit

		if not Unit.alive(attacker_unit) then
			local get_data = Unit.get_data(attacker_unit, "breed")
			local name

			if not get_data then
				name = get_data.name

				if not name then
					-- Nothing
				end
			end

			name = "dot_debuff"

			::label_65_0::

			arg_65_1.damage_source = name

			local num = POSITION_LOOKUP[arg_65_0] - POSITION_LOOKUP[attacker_unit]

			var_65_6 = Vector3.normalize(num)
		else
			var_65_6 = Vector3.backward()
		end

		local extension = ScriptUnit.extension(arg_65_0, "locomotion_system")
		local num_2 = var_65_6 * template.push_speed

		extension:add_external_velocity(num_2)

		arg_65_1.vomit_next_t = arg_65_2.t
	end,
	remove_plague_wave_in_face = function (arg_66_0, arg_66_1, arg_66_2, arg_66_3)
		-- function 66
		local has_extension = ScriptUnit.has_extension(arg_66_0, "first_person_system")

		if not has_extension then
			has_extension:stop_spawning_screen_particles(arg_66_1.plague_wave_particle_id)
			has_extension:stop_spawning_screen_particles(arg_66_1.plague_wave_opaque_particle_id)
		end
	end,
	apply_vermintide_in_face = function (arg_67_0, arg_67_1, arg_67_2, arg_67_3)
		-- function 67
		local get_difficulty = Managers.state.difficulty:get_difficulty()
		local template = arg_67_1.template

		arg_67_1.damage = template.difficulty_damage[get_difficulty]

		local armor_category = Unit.get_data(arg_67_0, "breed").armor_category

		armor_category = armor_category or 1
		arg_67_1.armor_type = armor_category

		local var_67_3
		local attacker_unit = arg_67_2.attacker_unit

		if not Unit.alive(attacker_unit) then
			local get_data = Unit.get_data(attacker_unit, "breed")
			local name

			if not get_data then
				name = get_data.name

				if not name then
					-- Nothing
				end
			end

			name = "dot_debuff"

			::label_67_0::

			arg_67_1.damage_source = name

			local num = POSITION_LOOKUP[arg_67_0] - POSITION_LOOKUP[attacker_unit]

			var_67_3 = Vector3.normalize(num)
		else
			var_67_3 = Vector3.backward()
		end

		local extension = ScriptUnit.extension(arg_67_0, "locomotion_system")
		local num_2 = var_67_3 * template.push_speed

		extension:add_external_velocity(num_2)
	end,
	update_vermintide_in_face = function (arg_68_0, arg_68_1, arg_68_2, arg_68_3)
		-- function 68
		local t = arg_68_2.t
		local template = arg_68_1.template

		if not Managers.state.network.is_server and not HEALTH_ALIVE[arg_68_0] then
			local attacker_unit = arg_68_2.attacker_unit

			attacker_unit = not Unit.alive(attacker_unit) and attacker_unit and arg_68_0

			local armor_type = arg_68_1.armor_type
			local damage_type = template.damage_type
			local var_68_5 = arg_68_1.damage[armor_type]
			local damage_source = arg_68_1.damage_source

			DamageUtils.add_damage_network(arg_68_0, attacker_unit, var_68_5, "torso", damage_type, nil, Vector3(1, 0, 0), damage_source, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, 1)
		end

		local owner = Managers.player:owner(arg_68_0)

		if not (not owner and owner.remote) then
			local fatigue_type = template.fatigue_type

			ScriptUnit.extension(arg_68_0, "status_system"):add_fatigue_points(fatigue_type)
		end

		local extension = ScriptUnit.extension(arg_68_0, "buff_system")
		local slowdown_buff_name = template.slowdown_buff_name

		if not slowdown_buff_name then
			extension:add_buff(slowdown_buff_name, arg_68_2)
		end

		return t + template.time_between_dot_damages
	end,
	remove_vermintide_in_face = function (arg_69_0, arg_69_1, arg_69_2, arg_69_3)
		-- function 69
		return
	end,
	apply_vomit_in_face = function (arg_70_0, arg_70_1, arg_70_2, arg_70_3)
		-- function 70
		local get_difficulty = Managers.state.difficulty:get_difficulty()
		local template = arg_70_1.template

		arg_70_1.damage = template.difficulty_damage[get_difficulty]

		local armor_category = Unit.get_data(arg_70_0, "breed").armor_category

		armor_category = armor_category or 1
		arg_70_1.armor_type = armor_category

		local owner = Managers.player:owner(arg_70_0)
		local remote = owner.remote

		if not remote then
			remote = owner.bot_player
			remote = remote or false
		end

		if not remote then
			CosmeticsUtils.flow_event_mesh_3p(arg_70_0, "impact_vomit")
		end

		local has_extension = ScriptUnit.has_extension(arg_70_0, "first_person_system")

		if not has_extension then
			arg_70_1.vomit_opaque_particle_id = has_extension:create_screen_particles("fx/screenspace_vomit_hit_opaque")
			arg_70_1.vomit_particle_id = has_extension:create_screen_particles("fx/screenspace_vomit_hit_inface")

			has_extension:play_hud_sound_event("Play_player_hit_puke")
		end

		if not Managers.state.network.is_server then
			local has_extension_2 = ScriptUnit.has_extension(arg_70_0, "career_system")

			if not has_extension_2 then
				local profile_index = has_extension_2:profile_index()
				local display_name = SPProfiles[profile_index].display_name

				Managers.state.entity:system("surrounding_aware_system"):add_system_event(arg_70_0, "hit_by_vomit", DialogueSettings.default_view_distance, "target_name", display_name)
			end
		end

		local var_70_9
		local attacker_unit = arg_70_2.attacker_unit

		if not Unit.alive(attacker_unit) then
			local get_data = Unit.get_data(attacker_unit, "breed")
			local name

			if not get_data then
				name = get_data.name

				if not name then
					-- Nothing
				end
			end

			name = "dot_debuff"

			::label_70_0::

			arg_70_1.damage_source = name

			local num = POSITION_LOOKUP[arg_70_0] - POSITION_LOOKUP[attacker_unit]

			var_70_9 = Vector3.normalize(num)

			local has_extension_3 = ScriptUnit.has_extension(attacker_unit, "buff_system")

			if not has_extension_3 then
				arg_70_1.buff_damage_multiplier = has_extension_3:apply_buffs_to_value(1, "damage_dealt")
			end
		else
			var_70_9 = Vector3.backward()
		end

		local extension = ScriptUnit.extension(arg_70_0, "locomotion_system")
		local num_2 = var_70_9 * template.push_speed

		extension:add_external_velocity(num_2)
	end,
	update_vomit_in_face = function (arg_71_0, arg_71_1, arg_71_2, arg_71_3)
		-- function 71
		local t = arg_71_2.t
		local template = arg_71_1.template

		if not Managers.state.network.is_server and not HEALTH_ALIVE[arg_71_0] then
			local attacker_unit = arg_71_2.attacker_unit
			local flag = not Unit.alive(attacker_unit) and attacker_unit and arg_71_0
			local armor_type = arg_71_1.armor_type
			local damage_type = template.damage_type
			local var_71_6 = arg_71_1.damage[armor_type]
			local damage_source = arg_71_1.damage_source

			if not arg_71_1.buff_damage_multiplier then
				var_71_6 = var_71_6 * arg_71_1.buff_damage_multiplier
			end

			DamageUtils.add_damage_network(arg_71_0, flag, var_71_6, "torso", damage_type, nil, Vector3(1, 0, 0), damage_source, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, 1)
		end

		local owner = Managers.player:owner(arg_71_0)

		if not (not owner and owner.remote) then
			local fatigue_type = template.fatigue_type

			ScriptUnit.extension(arg_71_0, "status_system"):add_fatigue_points(fatigue_type)
		end

		local extension = ScriptUnit.extension(arg_71_0, "buff_system")
		local slowdown_buff_name = template.slowdown_buff_name

		if not slowdown_buff_name then
			extension:add_buff(slowdown_buff_name, arg_71_2)
		end

		local has_extension = ScriptUnit.has_extension(arg_71_0, "first_person_system")

		if not has_extension then
			has_extension:play_hud_sound_event("Play_player_damage_puke")
		end

		return t + template.time_between_dot_damages
	end,
	remove_vomit_in_face = function (arg_72_0, arg_72_1, arg_72_2, arg_72_3)
		-- function 72
		local has_extension = ScriptUnit.has_extension(arg_72_0, "first_person_system")

		if not has_extension then
			has_extension:stop_spawning_screen_particles(arg_72_1.vomit_particle_id)
			has_extension:stop_spawning_screen_particles(arg_72_1.vomit_opaque_particle_id)
		end
	end,
	apply_vortex = function (arg_73_0, arg_73_1, arg_73_2, arg_73_3)
		-- function 73
		local get_difficulty = Managers.state.difficulty:get_difficulty()

		arg_73_1.damage = arg_73_1.template.difficulty_damage[get_difficulty]

		local armor_category = Unit.get_data(arg_73_0, "breed").armor_category

		armor_category = armor_category or 1
		arg_73_1.armor_type = armor_category

		local has_extension = ScriptUnit.has_extension(arg_73_0, "first_person_system")

		if not has_extension then
			arg_73_1.vortex_particle_id = has_extension:create_screen_particles("fx/screenspace_poison_globe_impact")
		end

		local attacker_unit = arg_73_2.attacker_unit

		if not Unit.alive(attacker_unit) then
			local is_enemy = DamageUtils.is_enemy(attacker_unit, arg_73_0)
			local var_73_5 = ALIVE[attacker_unit]

			var_73_5 = not var_73_5 and Unit.get_data(attacker_unit, "breed")

			local flag = not var_73_5 and var_73_5.name

			arg_73_1.damage_source = not is_enemy and flag and "dot_debuff"
		end
	end,
	update_vortex = function (arg_74_0, arg_74_1, arg_74_2, arg_74_3)
		-- function 74
		local t = arg_74_2.t
		local template = arg_74_1.template

		if not Managers.state.network.is_server and not HEALTH_ALIVE[arg_74_0] then
			local attacker_unit = arg_74_2.attacker_unit
			local flag = not Unit.alive(attacker_unit) and attacker_unit and arg_74_0
			local armor_type = arg_74_1.armor_type
			local damage_type = template.damage_type
			local var_74_6 = arg_74_1.damage[armor_type]
			local damage_source = arg_74_1.damage_source

			DamageUtils.add_damage_network(arg_74_0, flag, var_74_6, "torso", damage_type, nil, Vector3(1, 0, 0), damage_source, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, 1)
		end

		local owner = Managers.player:owner(arg_74_0)

		if not (not owner and owner.remote) then
			local fatigue_type = template.fatigue_type

			ScriptUnit.extension(arg_74_0, "status_system"):add_fatigue_points(fatigue_type)
		end

		local extension = ScriptUnit.extension(arg_74_0, "buff_system")
		local slowdown_buff_name = template.slowdown_buff_name

		if not slowdown_buff_name then
			extension:add_buff(slowdown_buff_name, arg_74_2)
		end

		local has_extension = ScriptUnit.has_extension(arg_74_0, "first_person_system")

		if not has_extension then
			has_extension:play_hud_sound_event("Play_player_damage_puke")
		end

		return t + template.time_between_dot_damages
	end,
	remove_vortex = function (arg_75_0, arg_75_1, arg_75_2, arg_75_3)
		-- function 75
		local has_extension = ScriptUnit.has_extension(arg_75_0, "first_person_system")

		if not has_extension then
			has_extension:stop_spawning_screen_particles(arg_75_1.vortex_particle_id)
		end
	end,
	apply_moving_through_warpfire = function (arg_76_0, arg_76_1, arg_76_2, arg_76_3)
		-- function 76
		local get_difficulty = Managers.state.difficulty:get_difficulty()

		arg_76_1.damage = arg_76_1.template.difficulty_damage[get_difficulty]

		local armor_category = Unit.get_data(arg_76_0, "breed").armor_category

		armor_category = armor_category or 1
		arg_76_1.armor_type = armor_category

		local has_extension = ScriptUnit.has_extension(arg_76_0, "first_person_system")

		if not has_extension then
			arg_76_1.warpfire_particle_id = has_extension:create_screen_particles("fx/screenspace_warpfire_hit_onfeet")
		end

		local attacker_unit = arg_76_2.attacker_unit

		if not Unit.alive(attacker_unit) then
			local get_source_attacker_unit = ScriptUnit.extension(attacker_unit, "area_damage_system"):get_source_attacker_unit()
			local var_76_5 = ALIVE[get_source_attacker_unit]

			var_76_5 = not var_76_5 and Unit.get_data(get_source_attacker_unit, "breed")

			local name

			if not var_76_5 then
				name = var_76_5.name

				if not name then
					-- Nothing
				end
			end

			name = "dot_debuff"

			::label_76_0::

			arg_76_1.damage_source = name

			if not ALIVE[get_source_attacker_unit] then
				local has_extension_2 = ScriptUnit.has_extension(get_source_attacker_unit, "buff_system")

				if not has_extension_2 then
					if type(arg_76_1.damage) == "table" then
						local clone = table.clone(arg_76_1.damage)

						for k, v in pairs(clone) do
							clone[k] = has_extension_2:apply_buffs_to_value(v, "damage_dealt")
						end

						arg_76_1.damage = clone
					else
						arg_76_1.damage = has_extension_2:apply_buffs_to_value(arg_76_1.damage, "damage_dealt")
					end
				end
			end
		end

		arg_76_1.warpfire_next_t = arg_76_2.t + 0.1
	end,
	update_moving_through_warpfire = function (arg_77_0, arg_77_1, arg_77_2, arg_77_3)
		-- function 77
		local t = arg_77_2.t
		local template = arg_77_1.template

		if not Managers.state.network.is_server and not HEALTH_ALIVE[arg_77_0] then
			local attacker_unit = arg_77_2.attacker_unit
			local flag = not Unit.alive(attacker_unit) and attacker_unit and arg_77_0
			local armor_type = arg_77_1.armor_type
			local damage_type = template.damage_type
			local var_77_6 = arg_77_1.damage[armor_type]
			local damage_source = arg_77_1.damage_source

			DamageUtils.add_damage_network(arg_77_0, flag, var_77_6, "torso", damage_type, nil, Vector3(1, 0, 0), damage_source, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, 1)
		end

		local has_extension = ScriptUnit.has_extension(arg_77_0, "first_person_system")

		if not has_extension then
			has_extension:play_hud_sound_event("Play_player_damage_puke")
		end

		local extension = ScriptUnit.extension(arg_77_0, "buff_system")
		local slowdown_buff_name = template.slowdown_buff_name

		if not slowdown_buff_name then
			extension:add_buff(slowdown_buff_name, arg_77_2)
		end

		return t + template.time_between_dot_damages
	end,
	update_heal_ticks = function (arg_78_0, arg_78_1, arg_78_2, arg_78_3)
		-- function 78
		local t = arg_78_2.t
		local template = arg_78_1.template
		local next_heal_tick = arg_78_1.next_heal_tick

		next_heal_tick = next_heal_tick or 0

		if ScriptUnit.extension(arg_78_0, "health_system"):current_permanent_health_percent() >= 1 then
			return
		end

		if next_heal_tick < t then
			if not Managers.state.network.is_server then
				local heal_amount = template.heal_amount

				if not HEALTH_ALIVE[arg_78_0] then
					DamageUtils.heal_network(arg_78_0, arg_78_0, heal_amount, "career_passive")
				end
			end

			arg_78_1.next_heal_tick = t + template.time_between_heals
		end
	end,
	markus_huntsman_update_heal_ticks = function (arg_79_0, arg_79_1, arg_79_2, arg_79_3)
		-- function 79
		local t = arg_79_2.t
		local template = arg_79_1.template
		local next_heal_tick = arg_79_1.next_heal_tick

		next_heal_tick = next_heal_tick or 0

		if ScriptUnit.extension(arg_79_0, "health_system"):current_health_percent() == 1 then
			return
		end

		if next_heal_tick < t then
			if not Managers.state.network.is_server then
				local heal_amount = template.heal_amount

				if not HEALTH_ALIVE[arg_79_0] then
					DamageUtils.heal_network(arg_79_0, arg_79_0, heal_amount, "buff")
				end
			end

			arg_79_1.next_heal_tick = t + template.time_between_heals
		end
	end,
	delayed_buff_removal = function (arg_80_0, arg_80_1, arg_80_2, arg_80_3)
		-- function 80
		if not ALIVE[arg_80_0] then
			return
		end

		local template = arg_80_1.template
		local t = arg_80_2.t

		if not arg_80_1.marked_for_deletion then
			if not arg_80_1.delete_time then
				arg_80_1.delete_time = t + template.deletion_delay
			end

			if t > arg_80_1.delete_time then
				local extension = ScriptUnit.extension(arg_80_0, "buff_system")
				local reference_buff = template.reference_buff
				local get_non_stacking_buff = extension:get_non_stacking_buff(reference_buff)

				if not get_non_stacking_buff and not get_non_stacking_buff.buff_list then
					local remove = table.remove(get_non_stacking_buff.buff_list)

					if not remove then
						extension:remove_buff(remove)
					end
				end

				arg_80_1.delete_time = nil
				arg_80_1.marked_for_deletion = nil
			end
		end
	end,
	delayed_buff_add = function (arg_81_0, arg_81_1, arg_81_2, arg_81_3)
		-- function 81
		if not ALIVE[arg_81_0] then
			return
		end

		local template = arg_81_1.template
		local t = arg_81_2.t

		if not arg_81_1.marked_for_add then
			if not arg_81_1.add_time then
				arg_81_1.add_time = t + template.add_delay
			end

			if t > arg_81_1.add_time then
				local extension = ScriptUnit.extension(arg_81_0, "buff_system")
				local reference_buff = template.reference_buff
				local get_non_stacking_buff = extension:get_non_stacking_buff(reference_buff)
				local buff_to_add = template.buff_to_add

				if not extension then
					if not get_non_stacking_buff.buff_list then
						get_non_stacking_buff.buff_list = {}
					end

					if extension:num_buff_type(buff_to_add) < get_non_stacking_buff.template.max_sub_buff_stacks then
						get_non_stacking_buff.buff_list[#get_non_stacking_buff.buff_list + 1] = extension:add_buff(buff_to_add)
					end
				end

				arg_81_1.add_time = nil
				arg_81_1.marked_for_add = nil
			end
		end
	end,
	delayed_single_buff_add = function (arg_82_0, arg_82_1, arg_82_2, arg_82_3)
		-- function 82
		if not ALIVE[arg_82_0] then
			return
		end

		local template = arg_82_1.template
		local t = arg_82_2.t

		if not arg_82_1.marked_for_add then
			if not arg_82_1.add_time then
				arg_82_1.add_time = t + template.add_delay
			end

			if t > arg_82_1.add_time then
				local buff_to_add = arg_82_1.template.buff_to_add
				local extension = ScriptUnit.extension(arg_82_0, "buff_system")
				local network = Managers.state.network
				local network_transmit = network.network_transmit
				local unit_game_object_id = network:unit_game_object_id(arg_82_0)
				local var_82_7 = NetworkLookup.buff_templates[buff_to_add]

				if not fn_5() then
					extension:add_buff(buff_to_add, {
						attacker_unit = arg_82_0
					})
					network_transmit:send_rpc_clients("rpc_add_buff", unit_game_object_id, var_82_7, unit_game_object_id, 0, false)
				else
					network_transmit:send_rpc_server("rpc_add_buff", unit_game_object_id, var_82_7, unit_game_object_id, 0, true)
				end

				arg_82_1.add_time = nil
				arg_82_1.marked_for_add = nil
			end
		end
	end,
	add_buff_stacks_on_movement = function (arg_83_0, arg_83_1, arg_83_2, arg_83_3)
		-- function 83
		if not ALIVE[arg_83_0] then
			return
		end

		local var_83_0 = POSITION_LOOKUP[arg_83_0]

		if not arg_83_1.position then
			arg_83_1.position = Vector3Box(var_83_0)
		else
			local template = arg_83_1.template
			local num = arg_83_1.position:unbox() - var_83_0
			local length = Vector3.length(num)

			if not arg_83_1.distance_moved then
				arg_83_1.distance_moved = 0
			end

			arg_83_1.distance_moved = arg_83_1.distance_moved + length

			local has_extension = ScriptUnit.has_extension(arg_83_0, "talent_system")
			local flag = false
			local huge = math.huge

			if not flag then
				huge = template.distance_per_stack * 0.7
			else
				huge = template.distance_per_stack
			end

			if huge < arg_83_1.distance_moved then
				local buff_to_add = template.buff_to_add
				local has_extension_2 = ScriptUnit.has_extension(arg_83_0, "buff_system")

				if not has_extension_2 then
					if not arg_83_1.buff_list then
						arg_83_1.buff_list = {}
					end

					if has_extension_2:num_buff_type(buff_to_add) < template.max_sub_buff_stacks then
						arg_83_1.buff_list[#arg_83_1.buff_list + 1] = has_extension_2:add_buff(buff_to_add)
					end
				end

				arg_83_1.distance_moved = 0
			end

			arg_83_1.position:store(var_83_0)
		end
	end,
	set_stacks_on_stacks = function (arg_84_0, arg_84_1, arg_84_2, arg_84_3)
		-- function 84
		local var_84_0 = arg_84_0

		if not ALIVE[var_84_0] then
			local template = arg_84_1.template
			local buff_to_check = template.buff_to_check
			local extension = ScriptUnit.extension(var_84_0, "buff_system")
			local num_buff_type = extension:num_buff_type(buff_to_check)

			if not arg_84_1.buff_list then
				arg_84_1.buff_list = {}
			end

			if num_buff_type == #arg_84_1.buff_list then
				return
			end

			local buff_to_add = template.buff_to_add
			local parent_stacks_per_stack = template.parent_stacks_per_stack
			local count = #arg_84_1.buff_list
			local num = num_buff_type / parent_stacks_per_stack - count

			if num < 0 then
				local abs = math.abs(num)

				for i = 1, abs do
					local remove = table.remove(arg_84_1.buff_list)

					extension:remove_buff(remove)
				end
			else
				for j = 1, num do
					table.insert(arg_84_1.buff_list, extension:add_buff(buff_to_add))
				end
			end
		end
	end,
	update_kerillian_waywatcher_regen = function (arg_85_0, arg_85_1, arg_85_2, arg_85_3)
		-- function 85
		local t = arg_85_2.t
		local template = arg_85_1.template
		local next_heal_tick = arg_85_1.next_heal_tick

		next_heal_tick = next_heal_tick or 0

		local num = 0.5

		if not (next_heal_tick < t) or not Unit.alive(arg_85_0) then
			local extension = ScriptUnit.extension(arg_85_0, "talent_system")
			local has_talent = extension:has_talent("kerillian_waywatcher_passive_cooldown_restore", "wood_elf", true)

			if not has_talent then
				local num_2 = 0.05

				ScriptUnit.extension(arg_85_0, "career_system"):reduce_activated_ability_cooldown_percent(num_2)
			end

			if not (not Managers.state.network.is_server and has_talent) then
				local extension_2 = ScriptUnit.extension(arg_85_0, "health_system")
				local extension_3 = ScriptUnit.extension(arg_85_0, "status_system")
				local heal_amount = template.heal_amount

				if not extension:has_talent("kerillian_waywatcher_improved_regen", "wood_elf", true) then
					heal_amount = heal_amount * 1.5
				end

				if not (not HEALTH_ALIVE[arg_85_0] and extension_3:is_knocked_down() or extension_3:is_assisted_respawning()) then
					if not extension:has_talent("kerillian_waywatcher_group_regen", "wood_elf", true) then
						local var_85_10 = Managers.state.side.side_by_unit[arg_85_0]

						if not var_85_10 then
							return
						end

						local PLAYER_AND_BOT_UNITS = var_85_10.PLAYER_AND_BOT_UNITS

						for i = 1, #PLAYER_AND_BOT_UNITS do
							local var_85_12 = PLAYER_AND_BOT_UNITS[i]

							if not HEALTH_ALIVE[var_85_12] then
								local extension_4 = ScriptUnit.extension(var_85_12, "health_system")
								local extension_5 = ScriptUnit.extension(var_85_12, "status_system")

								if not (not (num >= extension_4:current_permanent_health_percent()) or extension_5:is_knocked_down() or extension_5:is_assisted_respawning()) then
									DamageUtils.heal_network(var_85_12, arg_85_0, heal_amount, "career_passive")
								end
							end
						end
					elseif num >= extension_2:current_permanent_health_percent() then
						DamageUtils.heal_network(arg_85_0, arg_85_0, heal_amount, "career_passive")
					end
				end
			end

			arg_85_1.next_heal_tick = t + template.time_between_heals
		end
	end,
	remove_moving_through_warpfire = function (arg_86_0, arg_86_1, arg_86_2, arg_86_3)
		-- function 86
		local has_extension = ScriptUnit.has_extension(arg_86_0, "first_person_system")

		if not has_extension then
			has_extension:stop_spawning_screen_particles(arg_86_1.warpfire_particle_id)
		end
	end,
	apply_warpfirethrower_in_face = function (arg_87_0, arg_87_1, arg_87_2, arg_87_3)
		-- function 87
		local get_difficulty = Managers.state.difficulty:get_difficulty()
		local template = arg_87_1.template

		arg_87_1.damage = template.difficulty_damage[get_difficulty]

		local get_data = Unit.get_data(arg_87_0, "breed")
		local armor_category = get_data.armor_category

		armor_category = armor_category or 1
		arg_87_1.armor_type = armor_category

		local has_extension = ScriptUnit.has_extension(arg_87_0, "first_person_system")

		if not has_extension then
			arg_87_1.warpfire_particle_id = has_extension:create_screen_particles("fx/screenspace_warpfire_flamethrower_01")
			arg_87_1.warpfire_particle_id_2 = has_extension:create_screen_particles("fx/screenspace_warpfire_hit_inface")

			has_extension:play_hud_sound_event("Play_player_hit_warpfire_thrower")
		end

		local var_87_5
		local attacker_unit = arg_87_2.attacker_unit
		local num = 0

		if not ALIVE[attacker_unit] then
			local get_data_2 = Unit.get_data(attacker_unit, "breed")
			local name

			if not get_data_2 then
				name = get_data_2.name

				if not name then
					-- Nothing
				end
			end

			name = "dot_debuff"

			::label_87_0::

			arg_87_1.damage_source = name

			local num_2 = POSITION_LOOKUP[arg_87_0] - POSITION_LOOKUP[attacker_unit]

			var_87_5 = Vector3.normalize(num_2)
			num = Vector3.length(num_2)
		else
			var_87_5 = Vector3.backward()
		end

		if not get_data.is_hero and not has_extension then
			local has_extension_2 = ScriptUnit.has_extension(arg_87_0, "buff_system")
			local has_extension_3 = ScriptUnit.has_extension(arg_87_0, "status_system")

			if not (not not (not has_extension_2 and has_extension_2:has_buff_perk("no_ranged_knockback")) or not has_extension_3:is_disabled()) then
				local extension = ScriptUnit.extension(arg_87_0, "locomotion_system")
				local push_speed = template.push_speed
				local num_3 = var_87_5 * math.max(0, push_speed - num)

				extension:add_external_velocity(num_3)
			end
		end
	end,
	update_warpfirethrower_in_face = function (arg_88_0, arg_88_1, arg_88_2, arg_88_3)
		-- function 88
		local t = arg_88_2.t
		local template = arg_88_1.template

		if not Managers.state.network.is_server then
			local var_88_2 = ALIVE[arg_88_2.attacker_unit]

			if not (not var_88_2 and arg_88_2.attacker_unit) then
				local var_88_3 = arg_88_0
			end

			local attacker_unit = arg_88_2.attacker_unit
			local has_buff_perk = ScriptUnit.has_extension(arg_88_0, "buff_system"):has_buff_perk("power_block")
			local flag = false

			if not has_buff_perk then
				flag = fn_7(arg_88_0, attacker_unit, arg_88_1, arg_88_2, arg_88_3)
			end

			if not flag and DamageUtils.check_ranged_block(attacker_unit, arg_88_0, "blocked_berzerker") or not HEALTH_ALIVE[arg_88_0] then
				local armor_type = arg_88_1.armor_type
				local damage_type = template.damage_type
				local var_88_9 = arg_88_1.damage[armor_type]
				local damage_source = arg_88_1.damage_source

				DamageUtils.add_damage_network(arg_88_0, attacker_unit, var_88_9, "torso", damage_type, nil, Vector3(1, 0, 0), damage_source, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, 1)
			end

			local flag_2 = not DamageUtils.is_enemy(attacker_unit, arg_88_0)
			local var_88_12 = HEALTH_ALIVE[arg_88_0]

			if not var_88_2 and not flag_2 and not var_88_12 then
				QuestSettings.check_num_enemies_killed_by_warpfire(arg_88_0, attacker_unit)
			end
		end

		return t + template.time_between_dot_damages
	end,
	remove_warpfirethrower_in_face = function (arg_89_0, arg_89_1, arg_89_2, arg_89_3)
		-- function 89
		local has_extension = ScriptUnit.has_extension(arg_89_0, "first_person_system")

		if not has_extension then
			has_extension:stop_spawning_screen_particles(arg_89_1.warpfire_particle_id)
			has_extension:stop_spawning_screen_particles(arg_89_1.warpfire_particle_id_2)
			has_extension:play_hud_sound_event("Stop_player_hit_warpfire_thrower")
		end
	end,
	apply_warpfire_in_face = function (arg_90_0, arg_90_1, arg_90_2, arg_90_3)
		-- function 90
		local get_difficulty = Managers.state.difficulty:get_difficulty()
		local template = arg_90_1.template

		arg_90_1.damage = template.difficulty_damage[get_difficulty]

		local armor_category = Unit.get_data(arg_90_0, "breed").armor_category

		armor_category = armor_category or 1
		arg_90_1.armor_type = armor_category

		local owner = Managers.player:owner(arg_90_0)
		local remote = owner.remote

		if not remote then
			remote = owner.bot_player
			remote = remote or false
		end

		if not remote then
			CosmeticsUtils.flow_event_mesh_3p(arg_90_0, "impact_warpfire")
		end

		local has_extension = ScriptUnit.has_extension(arg_90_0, "first_person_system")

		if not has_extension then
			arg_90_1.warpfire_particle_id = has_extension:create_screen_particles("fx/screenspace_warpfire_hit_inface")

			has_extension:play_hud_sound_event("Play_player_hit_warpfire_thrower")
		end

		local var_90_6
		local attacker_unit = arg_90_2.attacker_unit

		if not ALIVE[attacker_unit] then
			local get_data = Unit.get_data(attacker_unit, "breed")
			local name

			if not get_data then
				name = get_data.name

				if not name then
					-- Nothing
				end
			end

			name = "dot_debuff"

			::label_90_0::

			arg_90_1.damage_source = name

			local num = POSITION_LOOKUP[arg_90_0] - POSITION_LOOKUP[attacker_unit]

			var_90_6 = Vector3.normalize(num)
		else
			var_90_6 = Vector3.backward()
		end

		if not has_extension then
			local has_extension_2 = ScriptUnit.has_extension(arg_90_0, "buff_system")

			if not (not has_extension_2 and has_extension_2:has_buff_perk("no_ranged_knockback")) then
				local extension = ScriptUnit.extension(arg_90_0, "locomotion_system")
				local num_2 = var_90_6 * template.push_speed

				extension:add_external_velocity(num_2)
			end
		end
	end,
	update_warpfire_in_face = function (arg_91_0, arg_91_1, arg_91_2, arg_91_3)
		-- function 91
		local t = arg_91_2.t
		local template = arg_91_1.template

		if not Managers.state.network.is_server then
			local attacker_unit

			if not ALIVE[arg_91_2.attacker_unit] then
				attacker_unit = arg_91_2.attacker_unit

				if not attacker_unit then
					-- Nothing
				end
			end

			attacker_unit = arg_91_0

			::label_91_0::

			if not HEALTH_ALIVE[arg_91_0] then
				local armor_type = arg_91_1.armor_type
				local damage_type = template.damage_type
				local var_91_5 = arg_91_1.damage[armor_type]
				local damage_source = arg_91_1.damage_source

				DamageUtils.add_damage_network(arg_91_0, attacker_unit, var_91_5, "torso", damage_type, nil, Vector3(1, 0, 0), damage_source, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, 1)
			end
		end

		local has_extension = ScriptUnit.has_extension(arg_91_0, "first_person_system")

		if not has_extension then
			has_extension:play_hud_sound_event("Play_player_damage_puke")
		end

		return t + template.time_between_dot_damages
	end,
	remove_warpfire_in_face = function (arg_92_0, arg_92_1, arg_92_2, arg_92_3)
		-- function 92
		local has_extension = ScriptUnit.has_extension(arg_92_0, "first_person_system")

		if not has_extension then
			has_extension:stop_spawning_screen_particles(arg_92_1.warpfire_particle_id)
			has_extension:play_hud_sound_event("Stop_player_hit_warpfire_thrower")
		end
	end,
	start_aoe_buff = function (arg_93_0, arg_93_1, arg_93_2)
		-- function 93
		local template = arg_93_1.template

		if template.target ~= "enemies" or not Managers.state.network.is_server then
			table.clear(tbl_3)

			local broadphase = Managers.state.entity:system("ai_system").broadphase
			local var_93_2 = POSITION_LOOKUP[arg_93_0]
			local range = template.range
			local query = Broadphase.query(broadphase, var_93_2, range, tbl_3)
			local buff = template.buff

			for i = 1, query do
				local var_93_6 = tbl_3[i]
				local has_extension = ScriptUnit.has_extension(var_93_6, "buff_system")

				if not has_extension then
					table.clear(tbl_2)

					tbl_2.attacker_unit = arg_93_0

					has_extension:add_buff(buff, tbl_2)
				end
			end
		end

		arg_93_1.reapply_t = arg_93_2.t + template.reapply_rate
	end,
	reapply_aoe_buff = function (arg_94_0, arg_94_1, arg_94_2)
		-- function 94
		if arg_94_1.reapply_t <= arg_94_2.t then
			local template = arg_94_1.template

			if template.target ~= "enemies" or not Managers.state.network.is_server then
				table.clear(tbl_3)

				local broadphase = Managers.state.entity:system("ai_system").broadphase
				local var_94_2 = POSITION_LOOKUP[arg_94_0]
				local range = template.range
				local query = Broadphase.query(broadphase, var_94_2, range, tbl_3)
				local buff = template.buff

				for i = 1, query do
					local var_94_6 = tbl_3[i]
					local has_extension = ScriptUnit.has_extension(var_94_6, "buff_system")

					if not has_extension then
						table.clear(tbl_2)

						tbl_2.attacker_unit = var_94_6

						has_extension:add_buff(buff, tbl_2)
					end
				end
			end

			arg_94_1.reapply_t = arg_94_2.t + template.reapply_rate
		end
	end,
	remove_aoe_buff = function (arg_95_0, arg_95_1, arg_95_2)
		-- function 95
		return
	end,
	add_buff_local = function (arg_96_0, arg_96_1, arg_96_2)
		-- function 96
		local template = arg_96_1.template
		local has_extension = ScriptUnit.has_extension(arg_96_0, "buff_system")
		local buffs_to_add = template.buffs_to_add

		if not buffs_to_add then
			for i = 1, #buffs_to_add do
				local var_96_3 = buffs_to_add[1]

				has_extension:add_buff(var_96_3)
			end
		else
			local buff_to_add = template.buff_to_add

			has_extension:add_buff(buff_to_add)
		end
	end,
	remove_buff_local = function (arg_97_0, arg_97_1, arg_97_2)
		-- function 97
		local buff_to_remove = arg_97_1.template.buff_to_remove
		local extension = ScriptUnit.extension(arg_97_0, "buff_system")
		local get_buff_type = extension:get_buff_type(buff_to_remove)

		if not get_buff_type then
			extension:remove_buff(get_buff_type.id)
		end
	end,
	add_buff_synced = function (arg_98_0, arg_98_1, arg_98_2)
		-- function 98
		local template = arg_98_1.template

		if not (not template.ignore_if_client and Managers.state.network.is_server) then
			return
		end

		if not template.ignore_if_not_local then
			local owner = Managers.player:owner(arg_98_0)

			if not (not owner and owner:network_id() == Network.peer_id()) then
				return
			end
		end

		local sync_type = template.sync_type
		local var_98_3

		if not (sync_type == BuffSyncType.Client or sync_type ~= BuffSyncType.ClientAndServer) then
			local owner_2 = Managers.player:owner(arg_98_0)

			if not owner_2 then
				print(string.format("Tried adding peer_id requiring buff on a unit which no peer owns. Defaulting to own peer_id. (%s)", template.name))
			end

			var_98_3 = not owner_2 and owner_2.peer_id and Network.peer_id()
		end

		local system = Managers.state.entity:system("buff_system")
		local synced_buffs_to_add = template.synced_buffs_to_add

		if not synced_buffs_to_add then
			for i = 1, #synced_buffs_to_add do
				local var_98_7 = synced_buffs_to_add[i]

				system:add_buff_synced(arg_98_0, var_98_7, sync_type, nil, var_98_3)
			end
		else
			local synced_buff_to_add = template.synced_buff_to_add

			system:add_buff_synced(arg_98_0, synced_buff_to_add, sync_type, nil, var_98_3)
		end
	end,
	remove_buff_synced = function (arg_99_0, arg_99_1, arg_99_2)
		-- function 99
		if not (not arg_99_1.template.ignore_if_client and Managers.state.network.is_server) then
			return
		end

		local synced_buff_to_remove = arg_99_1.template.synced_buff_to_remove
		local get_buff_type = ScriptUnit.extension(arg_99_0, "buff_system"):get_buff_type(synced_buff_to_remove)

		if not get_buff_type then
			Managers.state.entity:system("buff_system"):remove_buff_synced(arg_99_0, get_buff_type.id)
		end
	end,
	add_buff_server_controlled = function (arg_100_0, arg_100_1, arg_100_2)
		-- function 100
		if not Managers.state.network:game() then
			return
		end

		if not Unit.alive(arg_100_0) then
			local buff_to_add = arg_100_1.template.buff_to_add

			if ScriptUnit.has_extension(arg_100_0, "buff_system"):num_buff_type(buff_to_add) < BuffUtils.get_buff_template(buff_to_add).buffs[1].max_stacks then
				local add_buff = Managers.state.entity:system("buff_system"):add_buff(arg_100_0, buff_to_add, arg_100_0, true)

				if not arg_100_1.server_buff_ids then
					arg_100_1.server_buff_ids = {
						add_buff
					}
				else
					arg_100_1.server_buff_ids[#arg_100_1.server_buff_ids + 1] = add_buff
				end
			end
		end
	end,
	remove_buff_server_controlled = function (arg_101_0, arg_101_1, arg_101_2)
		-- function 101
		if not Managers.state.network:game() then
			return
		end

		if not Unit.alive(arg_101_0) then
			local buff_to_add = arg_101_1.template.buff_to_add
			local server_buff_ids = arg_101_1.server_buff_ids

			if not server_buff_ids then
				local system = Managers.state.entity:system("buff_system")

				for i = 1, #server_buff_ids do
					local var_101_3 = server_buff_ids[i]

					system:remove_server_controlled_buff(arg_101_0, var_101_3)
				end

				arg_101_1.server_buff_ids = nil
			end
		end
	end,
	add_buffs = function (arg_102_0, arg_102_1, arg_102_2)
		-- function 102
		if not Unit.alive(arg_102_0) then
			local add_buffs_data = arg_102_1.template.add_buffs_data

			if not add_buffs_data then
				local buffs_to_add = add_buffs_data.buffs_to_add

				if not buffs_to_add then
					local system = Managers.state.entity:system("buff_system")
					local LocalAndServer

					if not add_buffs_data.sync_buffs then
						LocalAndServer = BuffSyncType.LocalAndServer

						if not LocalAndServer then
							-- Nothing
						end
					end

					LocalAndServer = BuffSyncType.Local

					::label_102_0::

					for i = 1, #buffs_to_add do
						system:add_buff_synced(arg_102_0, buffs_to_add[i], LocalAndServer)
					end
				end
			end
		end
	end,
	remove_buffs = function (arg_103_0, arg_103_1, arg_103_2)
		-- function 103
		if not Unit.alive(arg_103_0) then
			local remove_buffs_data = arg_103_1.template.remove_buffs_data

			if not remove_buffs_data then
				local buffs_to_remove = remove_buffs_data.buffs_to_remove

				if not buffs_to_remove then
					local has_extension = ScriptUnit.has_extension(arg_103_0, "buff_system")

					if not has_extension then
						for i = 1, #buffs_to_remove do
							local get_non_stacking_buff = has_extension:get_non_stacking_buff(buffs_to_remove[i])

							if not get_non_stacking_buff then
								has_extension:remove_buff(get_non_stacking_buff.id)
							end
						end
					end
				end
			end
		end
	end,
	remove_buff_stack = function (arg_104_0, arg_104_1, arg_104_2)
		-- function 104
		if not Unit.alive(arg_104_0) then
			local has_extension = ScriptUnit.has_extension(arg_104_0, "buff_system")

			if not has_extension then
				local template = arg_104_1.template
				local remove_buff_stack_data = template.remove_buff_stack_data

				for i = 1, #remove_buff_stack_data do
					local var_104_3 = remove_buff_stack_data[i]
					local buff_to_remove = var_104_3.buff_to_remove
					local num_stacks = var_104_3.num_stacks

					num_stacks = num_stacks or 1

					if not var_104_3.server_controlled then
						fassert(buff_to_remove == template.buff_to_add, "Trying to remove different type of server controlled buff, only same types are allowed right now.")

						local system = Managers.state.entity:system("buff_system")
						local server_buff_ids = arg_104_1.server_buff_ids

						num_stacks = not server_buff_ids and math.min(#server_buff_ids, num_stacks) and 0

						for j = 1, num_stacks do
							local remove = table.remove(server_buff_ids)

							system:remove_server_controlled_buff(arg_104_0, remove)
						end
					else
						for k = 1, num_stacks do
							local get_buff_type = has_extension:get_buff_type(buff_to_remove)

							if not get_buff_type then
								break
							end

							has_extension:remove_buff(get_buff_type.id)
						end
					end

					if not var_104_3.reset_update_timer then
						local time = Managers.time:time("game")
						local update_frequency = template.update_frequency

						update_frequency = update_frequency or 0
						arg_104_1._next_update_t = time + update_frequency
					end
				end
			end
		end
	end,
	add_health_on_application = function (arg_105_0, arg_105_1, arg_105_2)
		-- function 105
		if not Unit.alive(arg_105_0) and not Managers.state.network.is_server then
			local heal_amount = arg_105_1.template.heal_amount

			DamageUtils.heal_network(arg_105_0, arg_105_0, heal_amount, "career_passive")
		end
	end,
	kerillian_maidenguard_add_power_buff_on_unharmed = function (arg_106_0, arg_106_1, arg_106_2)
		-- function 106
		if not fn_5() then
			return
		end

		if not Managers.state.network:game() then
			return
		end

		if not Unit.alive(arg_106_0) then
			local buff_to_add = arg_106_1.template.buff_to_add

			Managers.state.entity:system("buff_system"):add_buff(arg_106_0, buff_to_add, arg_106_0, false)
		end
	end,
	update_multiplier_based_on_enemy_proximity = function (arg_107_0, arg_107_1, arg_107_2)
		-- function 107
		local broadphase = Managers.state.entity:system("ai_system").broadphase
		local template = arg_107_1.template
		local range = arg_107_1.range
		local min_multiplier = template.min_multiplier
		local max_multiplier = template.max_multiplier
		local chunk_size = template.chunk_size
		local stat_buff = template.stat_buff
		local previous_multiplier = arg_107_1.previous_multiplier

		previous_multiplier = previous_multiplier or 0

		local var_107_8 = POSITION_LOOKUP[arg_107_0]

		table.clear(tbl_3)

		local query = Broadphase.query(broadphase, var_107_8, range, tbl_3)
		local num = 0

		for i = 1, query do
			local var_107_11 = tbl_3[i]

			if not HEALTH_ALIVE[var_107_11] then
				num = num + 1
			end
		end

		local num_2 = math.floor(num / chunk_size) * min_multiplier

		if max_multiplier < num_2 then
			num_2 = max_multiplier
		end

		arg_107_1.multiplier = num_2

		if previous_multiplier == num_2 or not stat_buff then
			local extension = ScriptUnit.extension(arg_107_0, "buff_system")
			local num_3 = num_2 - previous_multiplier

			extension:update_stat_buff(stat_buff, num_3, template.name)
		end

		arg_107_1.previous_multiplier = num_2
	end,
	update_bonus_based_on_enemy_proximity = function (arg_108_0, arg_108_1, arg_108_2)
		-- function 108
		local broadphase = Managers.state.entity:system("ai_system").broadphase
		local template = arg_108_1.template
		local range = arg_108_1.range
		local min_bonus = template.min_bonus
		local max_bonus = template.max_bonus
		local chunk_size = template.chunk_size
		local stat_buff = template.stat_buff
		local previous_bonus = arg_108_1.previous_bonus

		previous_bonus = previous_bonus or 0

		local var_108_8 = POSITION_LOOKUP[arg_108_0]

		table.clear(tbl_3)

		local query = Broadphase.query(broadphase, var_108_8, range, tbl_3)
		local num = 0

		for i = 1, query do
			local var_108_11 = tbl_3[i]

			if not HEALTH_ALIVE[var_108_11] then
				num = num + 1
			end
		end

		local num_2 = math.floor(num / chunk_size) * min_bonus

		if max_bonus < num_2 then
			num_2 = max_bonus
		end

		arg_108_1.bonus = num_2

		if previous_bonus == num_2 or not stat_buff then
			local extension = ScriptUnit.extension(arg_108_0, "buff_system")
			local num_3 = num_2 - previous_bonus

			extension:update_stat_buff(stat_buff, num_3, template.name)
		end

		arg_108_1.previous_bonus = num_2
	end,
	activate_buff_stacks_based_on_enemy_proximity = function (arg_109_0, arg_109_1, arg_109_2)
		-- function 109
		if not Managers.state.network.is_server then
			return
		end

		local var_109_0 = Managers.state.side.side_by_unit[arg_109_0]

		if not var_109_0 then
			return
		end

		local broadphase = Managers.state.entity:system("ai_system").broadphase
		local extension = ScriptUnit.extension(arg_109_0, "buff_system")
		local system = Managers.state.entity:system("buff_system")
		local template = arg_109_1.template
		local range = arg_109_1.range
		local chunk_size = template.chunk_size
		local buff_to_add = template.buff_to_add
		local num = 5
		local var_109_9 = POSITION_LOOKUP[arg_109_0]
		local enemy_broadphase_categories = var_109_0.enemy_broadphase_categories
		local query = Broadphase.query(broadphase, var_109_9, range, tbl_3, enemy_broadphase_categories)
		local num_2 = 0

		for i = 1, query do
			local var_109_13 = tbl_3[i]

			if not HEALTH_ALIVE[var_109_13] then
				num_2 = num_2 + 1

				if math.floor(num_2 / chunk_size) == num then
					break
				end
			end
		end

		if not arg_109_1.stack_ids then
			arg_109_1.stack_ids = {}
		end

		local floor = math.floor(num_2 / chunk_size)
		local num_buff_type = extension:num_buff_type(buff_to_add)

		if num_buff_type < floor then
			local num_3 = floor - num_buff_type

			for j = 1, num_3 do
				local add_buff = system:add_buff(arg_109_0, buff_to_add, arg_109_0, true)
				local stack_ids = arg_109_1.stack_ids

				stack_ids[#stack_ids + 1] = add_buff
			end
		elseif floor < num_buff_type then
			local num_4 = num_buff_type - floor

			for k = 1, num_4 do
				local stack_ids_2 = arg_109_1.stack_ids
				local remove = table.remove(stack_ids_2, 1)

				system:remove_server_controlled_buff(arg_109_0, remove)
			end
		end
	end,
	activate_buff_stacks_based_on_ally_proximity = function (arg_110_0, arg_110_1, arg_110_2)
		-- function 110
		if not Managers.state.network.is_server then
			return
		end

		if not ALIVE[arg_110_0] then
			return
		end

		local extension = ScriptUnit.extension(arg_110_0, "buff_system")
		local system = Managers.state.entity:system("buff_system")
		local template = arg_110_1.template
		local range = arg_110_1.range
		local num = range * range
		local chunk_size = template.chunk_size
		local buff_to_add = template.buff_to_add
		local max_stacks = template.max_stacks
		local var_110_8 = Managers.state.side.side_by_unit[arg_110_0]
		local flag = not var_110_8 and var_110_8.PLAYER_AND_BOT_UNITS
		local var_110_10 = POSITION_LOOKUP[arg_110_0]
		local num_2 = 0
		local count

		if not flag then
			count = #flag

			if not count then
				-- Nothing
			end
		end

		count = 0

		::label_110_0::

		for i = 1, count do
			local var_110_13 = flag[i]

			if var_110_13 ~= arg_110_0 then
				local var_110_14 = POSITION_LOOKUP[var_110_13]

				if num > Vector3.distance_squared(var_110_10, var_110_14) then
					num_2 = num_2 + 1
				end

				if math.floor(num_2 / chunk_size) == max_stacks then
					break
				end
			end
		end

		if not arg_110_1.stack_ids then
			arg_110_1.stack_ids = {}
		end

		local floor = math.floor(num_2 / chunk_size)
		local num_buff_type = extension:num_buff_type(buff_to_add)

		if num_buff_type < floor then
			local num_3 = floor - num_buff_type

			for j = 1, num_3 do
				local add_buff = system:add_buff(arg_110_0, buff_to_add, arg_110_0, true)
				local stack_ids = arg_110_1.stack_ids

				stack_ids[#stack_ids + 1] = add_buff
			end
		elseif floor < num_buff_type then
			local num_4 = num_buff_type - floor

			for k = 1, num_4 do
				local stack_ids_2 = arg_110_1.stack_ids
				local remove = table.remove(stack_ids_2, 1)

				system:remove_server_controlled_buff(arg_110_0, remove)
			end
		end
	end,
	update_multiplier_based_on_enemy_proximity = function (arg_111_0, arg_111_1, arg_111_2)
		-- function 111
		local broadphase = Managers.state.entity:system("ai_system").broadphase
		local template = arg_111_1.template
		local range = arg_111_1.range
		local min_multiplier = template.min_multiplier
		local max_multiplier = template.max_multiplier
		local chunk_size = template.chunk_size
		local stat_buff = template.stat_buff
		local previous_multiplier = arg_111_1.previous_multiplier

		previous_multiplier = previous_multiplier or 0

		local var_111_8 = POSITION_LOOKUP[arg_111_0]

		table.clear(tbl_3)

		local query = Broadphase.query(broadphase, var_111_8, range, tbl_3)
		local num = 0

		for i = 1, query do
			local var_111_11 = tbl_3[i]

			if not HEALTH_ALIVE[var_111_11] then
				num = num + 1
			end
		end

		local num_2 = math.floor(num / chunk_size) * min_multiplier

		if max_multiplier < num_2 then
			num_2 = max_multiplier
		end

		arg_111_1.multiplier = num_2

		if previous_multiplier == num_2 or not stat_buff then
			local extension = ScriptUnit.extension(arg_111_0, "buff_system")
			local num_3 = num_2 - previous_multiplier

			extension:update_stat_buff(stat_buff, num_3, template.name)
		end

		arg_111_1.previous_multiplier = num_2
	end,
	activate_buff_stacks_based_on_overcharge_chunks = function (arg_112_0, arg_112_1, arg_112_2)
		-- function 112
		if not fn_3(arg_112_0) then
			local extension = ScriptUnit.extension(arg_112_0, "overcharge_system")
			local extension_2 = ScriptUnit.extension(arg_112_0, "buff_system")
			local current_overcharge_status, var_112_3, var_112_4 = extension:current_overcharge_status()
			local template = arg_112_1.template
			local chunk_size = template.chunk_size
			local buff_to_add = template.buff_to_add
			local max_stacks = template.max_stacks

			if not arg_112_1.stack_ids then
				arg_112_1.stack_ids = {}
			end

			local min = math.min(math.floor(current_overcharge_status / chunk_size), max_stacks)
			local num_buff_type = extension_2:num_buff_type(buff_to_add)

			if num_buff_type < min then
				local num = min - num_buff_type

				for i = 1, num do
					local add_buff = extension_2:add_buff(buff_to_add)
					local stack_ids = arg_112_1.stack_ids

					stack_ids[#stack_ids + 1] = add_buff
				end
			elseif min < num_buff_type then
				local num_2 = num_buff_type - min

				for j = 1, num_2 do
					local stack_ids_2 = arg_112_1.stack_ids
					local remove = table.remove(stack_ids_2, 1)

					extension_2:remove_buff(remove)
				end
			end
		end
	end,
	activate_server_buff_stacks_based_on_overcharge_chunks = function (arg_113_0, arg_113_1, arg_113_2)
		-- function 113
		if not Managers.state.network.is_server then
			return
		end

		local extension = ScriptUnit.extension(arg_113_0, "overcharge_system")
		local system = Managers.state.entity:system("buff_system")
		local current_overcharge_status, var_113_3, var_113_4 = extension:current_overcharge_status()
		local template = arg_113_1.template
		local chunk_size = template.chunk_size
		local buff_to_add = template.buff_to_add
		local max_sub_buff_stacks = template.max_sub_buff_stacks

		max_sub_buff_stacks = max_sub_buff_stacks or 5

		if not arg_113_1.stack_server_ids then
			arg_113_1.stack_server_ids = {}
		end

		local stack_server_ids = arg_113_1.stack_server_ids
		local min = math.min(math.floor(current_overcharge_status / chunk_size), max_sub_buff_stacks)
		local count = #arg_113_1.stack_server_ids

		if count < min then
			local num = min - count

			for i = 1, num do
				local add_buff = system:add_buff(arg_113_0, buff_to_add, arg_113_0, true)

				stack_server_ids[#stack_server_ids + 1] = add_buff
			end
		elseif min < count then
			local num_2 = count - min

			for j = 1, num_2 do
				local remove = table.remove(stack_server_ids, 1)

				system:remove_server_controlled_buff(arg_113_0, remove)
			end
		end
	end,
	activate_buff_stacks_based_on_health_chunks = function (arg_114_0, arg_114_1, arg_114_2)
		-- function 114
		if not Managers.state.network.is_server then
			return
		end

		local extension = ScriptUnit.extension(arg_114_0, "health_system")
		local extension_2 = ScriptUnit.extension(arg_114_0, "buff_system")
		local system = Managers.state.entity:system("buff_system")
		local template = arg_114_1.template
		local buff_to_add = template.buff_to_add
		local chunk_size = template.chunk_size
		local get_damage_taken = extension:get_damage_taken("uncursed_max_health")
		local get_uncursed_max_health = extension:get_uncursed_max_health()
		local min = math.min(math.floor(get_uncursed_max_health / chunk_size) - 1, template.max_stacks)
		local floor = math.floor(get_damage_taken / chunk_size)
		local min_2 = math.min(min, floor)
		local num_buff_type = extension_2:num_buff_type(buff_to_add)

		if not arg_114_1.stack_ids then
			arg_114_1.stack_ids = {}
		end

		if num_buff_type < min_2 then
			local num = min_2 - num_buff_type

			for i = 1, num do
				local add_buff = system:add_buff(arg_114_0, buff_to_add, arg_114_0, true)
				local stack_ids = arg_114_1.stack_ids

				stack_ids[#stack_ids + 1] = add_buff
			end
		elseif min_2 < num_buff_type then
			local num_2 = num_buff_type - min_2

			for j = 1, num_2 do
				local stack_ids_2 = arg_114_1.stack_ids
				local remove = table.remove(stack_ids_2, 1)

				system:remove_server_controlled_buff(arg_114_0, remove)
			end
		end
	end,
	victor_zealot_activate_buff_stacks_based_on_health_percent = function (arg_115_0, arg_115_1, arg_115_2)
		-- function 115
		if not Unit.alive(arg_115_0) then
			local extension = ScriptUnit.extension(arg_115_0, "health_system")
			local extension_2 = ScriptUnit.extension(arg_115_0, "buff_system")
			local system = Managers.state.entity:system("buff_system")
			local template = arg_115_1.template
			local threshold_1 = template.threshold_1
			local threshold_2 = template.threshold_2
			local get_buffed_max_health = extension:get_buffed_max_health()
			local num = extension:current_permanent_health() / get_buffed_max_health

			if not arg_115_1.stack_ids then
				arg_115_1.stack_ids = {}
			end

			if not (not (#arg_115_1.stack_ids > 0) or not (threshold_2 < num)) then
				if not (#arg_115_1.stack_ids > 1 or not (threshold_1 < num)) then
					local remove = table.remove(arg_115_1.stack_ids, 1)

					system:remove_server_controlled_buff(arg_115_0, remove)
				end
			elseif num < threshold_1 then
				local buff_to_add = template.buff_to_add
				local num_buff_type = extension_2:num_buff_type(buff_to_add)
				local flag = false

				if num < threshold_2 then
					flag = true
				end

				if not ((num_buff_type < 1 or not flag) and num_buff_type ~= 1) then
					local add_buff = system:add_buff(arg_115_0, buff_to_add, arg_115_0, true)

					arg_115_1.stack_ids[#arg_115_1.stack_ids + 1] = add_buff
				end
			end
		end
	end,
	activate_buff_stacks_based_on_clip_size = function (arg_116_0, arg_116_1, arg_116_2)
		-- function 116
		if not Managers.state.network.is_server then
			return
		end

		if not Unit.alive(arg_116_0) then
			local extension = ScriptUnit.extension(arg_116_0, "buff_system")
			local buff_to_add = arg_116_1.template.buff_to_add
			local get_slot_data = ScriptUnit.has_extension(arg_116_0, "inventory_system"):get_slot_data("slot_ranged")
			local system = Managers.state.entity:system("buff_system")
			local num = 1

			if not get_slot_data then
				local get_item_template = BackendUtils.get_item_template(get_slot_data.item_data)
				local flag = not get_item_template and get_item_template.ammo_data
				local flag_2 = not flag and flag.ammo_per_clip

				if not (not flag_2 and not (num < flag_2)) then
					num = flag_2
				end

				local var_116_8 = num
				local num_buff_type = extension:num_buff_type(buff_to_add)

				if not arg_116_1.stack_ids then
					arg_116_1.stack_ids = {}
				end

				if num_buff_type < var_116_8 then
					local num_2 = var_116_8 - num_buff_type

					for i = 1, num_2 do
						local add_buff = system:add_buff(arg_116_0, buff_to_add, arg_116_0, true)
						local stack_ids = arg_116_1.stack_ids

						stack_ids[#stack_ids + 1] = add_buff
					end
				elseif var_116_8 < num_buff_type then
					local num_3 = num_buff_type - var_116_8

					for j = 1, num_3 do
						local stack_ids_2 = arg_116_1.stack_ids
						local remove = table.remove(stack_ids_2, 1)

						system:remove_server_controlled_buff(arg_116_0, remove)
					end
				end
			end
		end
	end,
	remove_buff_stacks_based_on_clip_size = function (arg_117_0, arg_117_1, arg_117_2)
		-- function 117
		if not Managers.state.network.is_server then
			return
		end

		if not Unit.alive(arg_117_0) then
			local template = arg_117_1.template
			local has_extension = ScriptUnit.has_extension(arg_117_0, "buff_system")
			local system = Managers.state.entity:system("buff_system")
			local buff_to_add = template.buff_to_add
			local stack_ids = arg_117_1.stack_ids

			if not has_extension:has_buff_type(buff_to_add) and not stack_ids then
				for i = 1, #stack_ids do
					local var_117_5 = stack_ids[i]

					system:remove_server_controlled_buff(arg_117_0, var_117_5)
				end

				arg_117_1.stack_ids = nil
			end
		end
	end,
	pause_activated_ability = function (arg_118_0, arg_118_1, arg_118_2)
		-- function 118
		if not Unit.alive(arg_118_0) then
			local has_extension = ScriptUnit.has_extension(arg_118_0, "career_system")

			if not has_extension then
				has_extension:start_activated_ability_cooldown()
				has_extension:set_activated_ability_cooldown_paused()
			end
		end
	end,
	unpause_activated_ability = function (arg_119_0, arg_119_1, arg_119_2)
		-- function 119
		if not Unit.alive(arg_119_0) then
			local has_extension = ScriptUnit.has_extension(arg_119_0, "career_system")

			if not has_extension then
				has_extension:set_activated_ability_cooldown_unpaused()
			end
		end
	end,
	activate_buff_on_distance = function (arg_120_0, arg_120_1, arg_120_2)
		-- function 120
		if not Managers.state.network.is_server then
			return
		end

		local template = arg_120_1.template
		local range = arg_120_1.range
		local disregard_self = template.disregard_self
		local num = range * range
		local var_120_4 = POSITION_LOOKUP[arg_120_0]
		local buff_to_add = template.buff_to_add
		local system = Managers.state.entity:system("buff_system")
		local var_120_7 = Managers.state.side.side_by_unit[arg_120_0]

		if not var_120_7 then
			return
		end

		local PLAYER_AND_BOT_UNITS = var_120_7.PLAYER_AND_BOT_UNITS
		local count = #PLAYER_AND_BOT_UNITS

		for i = 1, count do
			local var_120_10 = PLAYER_AND_BOT_UNITS[i]

			if not (not Unit.alive(var_120_10) and not disregard_self and var_120_10 == arg_120_0) then
				local var_120_11 = POSITION_LOOKUP[var_120_10]
				local distance_squared = Vector3.distance_squared(var_120_4, var_120_11)
				local extension = ScriptUnit.extension(var_120_10, "buff_system")

				if num < distance_squared then
					local get_non_stacking_buff = extension:get_non_stacking_buff(buff_to_add)

					if not get_non_stacking_buff then
						local server_id = get_non_stacking_buff.server_id

						if not server_id then
							system:remove_server_controlled_buff(var_120_10, server_id)
						end
					end
				end

				if not (not (distance_squared < num) or extension:has_buff_type(buff_to_add)) then
					local add_buff = system:add_buff(var_120_10, buff_to_add, arg_120_0, true)
					local get_non_stacking_buff_2 = extension:get_non_stacking_buff(buff_to_add)

					if not get_non_stacking_buff_2 then
						get_non_stacking_buff_2.server_id = add_buff
					end
				end
			end
		end
	end,
	side_buff_aura = function (arg_121_0, arg_121_1, arg_121_2)
		-- function 121
		local template = arg_121_1.template

		if not (not template.server_only and Managers.state.network.is_server) then
			return
		end

		local var_121_1 = Managers.state.side.side_by_unit[arg_121_0]

		if not var_121_1 then
			return
		end

		local buffed_units = arg_121_1.buffed_units

		buffed_units = buffed_units or {}
		arg_121_1.buffed_units = buffed_units

		local alloc_table = FrameTable.alloc_table()

		if not template.owner_as_source then
			alloc_table.source_attacker_unit = arg_121_0
		end

		local range = arg_121_1.range
		local num = range * range
		local var_121_6 = POSITION_LOOKUP[arg_121_0]
		local system = Managers.state.entity:system("buff_system")
		local buff_sync_type = template.buff_sync_type

		buff_sync_type = buff_sync_type or BuffSyncType.All

		local alloc_table_2 = FrameTable.alloc_table()

		if not template.player_buff_name then
			local PLAYER_AND_BOT_UNITS = var_121_1.PLAYER_AND_BOT_UNITS

			for i = 1, #PLAYER_AND_BOT_UNITS do
				local var_121_11 = PLAYER_AND_BOT_UNITS[i]
				local flag = num > Vector3.distance_squared(var_121_6, POSITION_LOOKUP[var_121_11])
				local var_121_13 = buffed_units[var_121_11]

				if not flag then
					if not var_121_13 then
						buffed_units[var_121_11] = system:add_buff_synced(var_121_11, template.player_buff_name, buff_sync_type, alloc_table)
					end

					alloc_table_2[var_121_11] = true
				elseif not var_121_13 then
					system:remove_buff_synced(var_121_11, var_121_13)

					buffed_units[var_121_11] = nil
				end
			end
		end

		if not template.ai_buff_name then
			local ally_broadphase_categories = var_121_1.ally_broadphase_categories
			local alloc_table_3 = FrameTable.alloc_table()
			local broadphase_query = AiUtils.broadphase_query(var_121_6, range, alloc_table_3, ally_broadphase_categories)

			for j = 1, broadphase_query do
				local var_121_17 = alloc_table_3[j]

				if not buffed_units[var_121_17] then
					buffed_units[var_121_17] = system:add_buff_synced(var_121_17, template.ai_buff_name, buff_sync_type, alloc_table)
				end

				alloc_table_2[var_121_17] = true
			end
		end

		for k, v in pairs(buffed_units) do
			if not alloc_table_2[k] then
				system:remove_buff_synced(k, v)

				buffed_units[k] = nil
			end
		end
	end,
	remove_side_buff_aura = function (arg_122_0, arg_122_1, arg_122_2)
		-- function 122
		if not arg_122_1.buffed_units then
			return
		end

		local system = Managers.state.entity:system("buff_system")

		for k, v in pairs(arg_122_1.buffed_units) do
			system:remove_buff_synced(k, v)
		end
	end,
	remove_party_buff_stacks = function (arg_123_0, arg_123_1, arg_123_2)
		-- function 123
		if not (not Managers.state.network.is_server and arg_123_1.stack_ids) then
			return
		end

		local system = Managers.state.entity:system("buff_system")
		local get_side_from_name = Managers.state.side:get_side_from_name("heroes")

		if not get_side_from_name then
			return
		end

		local PLAYER_AND_BOT_UNITS = get_side_from_name.PLAYER_AND_BOT_UNITS
		local count = #PLAYER_AND_BOT_UNITS

		for i = 1, count do
			local var_123_4 = PLAYER_AND_BOT_UNITS[i]

			if not ALIVE[var_123_4] then
				local extension = ScriptUnit.extension(var_123_4, "buff_system")
				local var_123_6 = arg_123_1.stack_ids[var_123_4]

				if not var_123_6 then
					for j = 1, #var_123_6 do
						local remove = table.remove(var_123_6)

						system:remove_server_controlled_buff(var_123_4, remove)
					end
				end
			end
		end
	end,
	activate_party_buff_stacks_on_ally_proximity = function (arg_124_0, arg_124_1, arg_124_2)
		-- function 124
		if not Managers.state.network.is_server then
			return
		end

		local system = Managers.state.entity:system("buff_system")
		local template = arg_124_1.template
		local range = arg_124_1.range
		local num = range * range
		local chunk_size = template.chunk_size
		local buff_to_add = template.buff_to_add
		local max_stacks = template.max_stacks
		local var_124_7 = Managers.state.side.side_by_unit[arg_124_0]

		if not var_124_7 then
			return
		end

		local PLAYER_AND_BOT_UNITS = var_124_7.PLAYER_AND_BOT_UNITS
		local var_124_9 = POSITION_LOOKUP[arg_124_0]
		local num_2 = 0
		local count = #PLAYER_AND_BOT_UNITS

		for i = 1, count do
			local var_124_12 = PLAYER_AND_BOT_UNITS[i]

			if var_124_12 ~= arg_124_0 then
				local var_124_13 = POSITION_LOOKUP[var_124_12]

				if num > Vector3.distance_squared(var_124_9, var_124_13) then
					num_2 = num_2 + 1
				end

				if math.floor(num_2 / chunk_size) == max_stacks then
					break
				end
			end
		end

		if not arg_124_1.stack_ids then
			arg_124_1.stack_ids = {}
		end

		for j = 1, count do
			local var_124_14 = PLAYER_AND_BOT_UNITS[j]

			if not ALIVE[var_124_14] then
				if not arg_124_1.stack_ids[var_124_14] then
					arg_124_1.stack_ids[var_124_14] = {}
				end

				local var_124_15 = POSITION_LOOKUP[var_124_14]
				local distance_squared = Vector3.distance_squared(var_124_9, var_124_15)
				local extension = ScriptUnit.extension(var_124_14, "buff_system")

				if num < distance_squared then
					local var_124_18 = arg_124_1.stack_ids[var_124_14]

					for k = 1, #var_124_18 do
						local var_124_19 = arg_124_1.stack_ids[var_124_14]
						local remove = table.remove(var_124_19)

						system:remove_server_controlled_buff(var_124_14, remove)
					end
				else
					local floor = math.floor(num_2 / chunk_size)
					local num_buff_type = extension:num_buff_type(buff_to_add)

					if num_buff_type < floor then
						local num_3 = floor - num_buff_type
						local var_124_24 = arg_124_1.stack_ids[var_124_14]

						for l = 1, num_3 do
							local add_buff = system:add_buff(var_124_14, buff_to_add, var_124_14, true)

							var_124_24[#var_124_24 + 1] = add_buff
						end
					elseif floor < num_buff_type then
						local num_4 = num_buff_type - floor
						local var_124_27 = arg_124_1.stack_ids[var_124_14]

						for i4 = 1, num_4 do
							local remove_2 = table.remove(var_124_27)

							system:remove_server_controlled_buff(var_124_14, remove_2)
						end
					end
				end
			end
		end
	end,
	activate_buff_on_closest_distance = function (arg_125_0, arg_125_1, arg_125_2)
		-- function 125
		if not Managers.state.network.is_server then
			return
		end

		local template = arg_125_1.template
		local range = arg_125_1.range
		local num = range * range
		local var_125_3 = POSITION_LOOKUP[arg_125_0]
		local buff_to_add = template.buff_to_add
		local system = Managers.state.entity:system("buff_system")
		local var_125_6 = Managers.state.side.side_by_unit[arg_125_0]

		if not var_125_6 then
			return
		end

		local PLAYER_AND_BOT_UNITS = var_125_6.PLAYER_AND_BOT_UNITS
		local count = #PLAYER_AND_BOT_UNITS
		local huge = math.huge
		local current_unit = arg_125_1.current_unit

		for i = 1, count do
			local var_125_11 = PLAYER_AND_BOT_UNITS[i]

			if not (not ALIVE[var_125_11] and var_125_11 == current_unit or var_125_11 == arg_125_0) then
				local var_125_12 = POSITION_LOOKUP[var_125_11]
				local distance_squared = Vector3.distance_squared(var_125_3, var_125_12)

				if not (not (distance_squared < num) or not (distance_squared < huge)) then
					if not current_unit and not ALIVE[current_unit] then
						local var_125_14 = POSITION_LOOKUP[current_unit]

						if not (not var_125_3 and var_125_14) then
							return
						end

						if distance_squared < Vector3.distance_squared(var_125_3, var_125_14) then
							local get_non_stacking_buff = ScriptUnit.extension(current_unit, "buff_system"):get_non_stacking_buff(buff_to_add)

							if not get_non_stacking_buff then
								local server_id = get_non_stacking_buff.server_id

								if not server_id then
									system:remove_server_controlled_buff(current_unit, server_id)
								end
							end

							huge = distance_squared
							arg_125_1.current_unit = var_125_11
						end
					else
						huge = distance_squared
						arg_125_1.current_unit = var_125_11
					end
				end
			end
		end

		local current_unit_2 = arg_125_1.current_unit

		if not current_unit_2 then
			local has_extension = ScriptUnit.has_extension(current_unit_2, "buff_system")

			if not has_extension then
				return
			end

			local var_125_19 = POSITION_LOOKUP[current_unit_2]
			local distance_squared_2 = Vector3.distance_squared(var_125_3, var_125_19)

			if num < distance_squared_2 then
				local get_non_stacking_buff_2 = has_extension:get_non_stacking_buff(buff_to_add)

				if not get_non_stacking_buff_2 then
					local server_id_2 = get_non_stacking_buff_2.server_id

					if not server_id_2 then
						get_non_stacking_buff_2.current_unit = nil

						system:remove_server_controlled_buff(current_unit_2, server_id_2)
					end
				end
			end

			if not (not (distance_squared_2 < num) or has_extension:has_buff_type(buff_to_add)) then
				local add_buff = system:add_buff(current_unit_2, buff_to_add, arg_125_0, true)
				local get_non_stacking_buff_3 = has_extension:get_non_stacking_buff(buff_to_add)

				if not get_non_stacking_buff_3 then
					get_non_stacking_buff_3.server_id = add_buff
				end
			end
		else
			arg_125_1.current_unit = nil
		end
	end,
	markus_hero_time_reset = function (arg_126_0, arg_126_1, arg_126_2)
		-- function 126
		local var_126_0 = arg_126_0

		if not Unit.alive(var_126_0) then
			ScriptUnit.has_extension(var_126_0, "career_system"):reduce_activated_ability_cooldown_percent(1)
		end
	end,
	add_buff_stacks = function (arg_127_0, arg_127_1, arg_127_2)
		-- function 127
		local var_127_0 = arg_127_0

		if not Unit.alive(var_127_0) then
			local template = arg_127_1.template
			local amount_to_add = template.amount_to_add
			local has_extension = ScriptUnit.has_extension(var_127_0, "buff_system")
			local buff_to_add = template.buff_to_add
			local buff_list = template.buff_list

			for i = 1, amount_to_add do
				if amount_to_add > #buff_list then
					template.buff_list[#template.buff_list + 1] = has_extension:add_buff(buff_to_add)
				end
			end
		end
	end,
	remove_aura_buff = function (arg_128_0, arg_128_1, arg_128_2)
		-- function 128
		if not Managers.state.network.is_server then
			return
		end

		local buff_to_add = arg_128_1.template.buff_to_add
		local system = Managers.state.entity:system("buff_system")
		local get_side_from_name = Managers.state.side:get_side_from_name("heroes")

		if not get_side_from_name then
			local PLAYER_AND_BOT_UNITS = get_side_from_name.PLAYER_AND_BOT_UNITS
			local count = #PLAYER_AND_BOT_UNITS

			for i = 1, count do
				local var_128_5 = PLAYER_AND_BOT_UNITS[i]

				if not ALIVE[var_128_5] then
					local get_non_stacking_buff = ScriptUnit.extension(var_128_5, "buff_system"):get_non_stacking_buff(buff_to_add)

					if not get_non_stacking_buff then
						local server_id = get_non_stacking_buff.server_id

						if not server_id then
							system:remove_server_controlled_buff(var_128_5, server_id)
						end
					end
				end
			end
		end
	end,
	activate_buff_on_nearby_ai_enemies = function (arg_129_0, arg_129_1, arg_129_2)
		-- function 129
		if not Managers.state.network.is_server then
			return
		end

		local time = Managers.time:time("game")

		if not arg_129_1.next_update_t then
			arg_129_1.next_update_t = time
			arg_129_1.tracked_buffs = {}
		end

		if time < arg_129_1.next_update_t then
			return
		end

		local template = arg_129_1.template

		arg_129_1.next_update_t = arg_129_1.next_update_t + template.tick_rate

		local side_by_unit = Managers.state.side.side_by_unit
		local var_129_3 = side_by_unit[arg_129_0]
		local system = Managers.state.entity:system("buff_system")
		local buff_to_add = arg_129_1.template.buff_to_add
		local tracked_buffs = arg_129_1.tracked_buffs
		local var_129_7 = POSITION_LOOKUP[arg_129_0]
		local radius = arg_129_1.template.radius
		local alloc_table = FrameTable.alloc_table()
		local broadphase_query = AiUtils.broadphase_query(var_129_7, radius, alloc_table)

		for i = 1, broadphase_query do
			local var_129_11 = alloc_table[i]

			alloc_table[var_129_11] = true

			if not (tracked_buffs[var_129_11] or side_by_unit[var_129_11] == var_129_3) then
				tracked_buffs[var_129_11] = system:add_buff(var_129_11, buff_to_add, arg_129_0, true)
			end
		end

		for k, v in pairs(tracked_buffs) do
			if not alloc_table[k] then
				system:remove_server_controlled_buff(k, v)

				tracked_buffs[k] = nil
			end
		end
	end,
	remove_tracked_buffs = function (arg_130_0, arg_130_1, arg_130_2)
		-- function 130
		if not Managers.state.network.is_server then
			return
		end

		local tracked_buffs = arg_130_1.tracked_buffs

		if not tracked_buffs then
			local buff_to_add = arg_130_1.template.buff_to_add
			local system = Managers.state.entity:system("buff_system")

			for k, v in pairs(tracked_buffs) do
				if not ALIVE[k] then
					system:remove_server_controlled_buff(k, v)
				end
			end

			table.clear(tracked_buffs)
		end
	end,
	update_ascending_descending_buff_stacks_on_time = function (arg_131_0, arg_131_1, arg_131_2)
		-- function 131
		if not Unit.alive(arg_131_0) then
			return
		end

		local t = arg_131_2.t
		local template = arg_131_1.template

		if not arg_131_1.buff_ids then
			arg_131_1.ascending = true
			arg_131_1.buff_ids = {}
		end

		local system = Managers.state.entity:system("buff_system")
		local buff_to_add = template.buff_to_add
		local max_sub_buff_stacks = template.max_sub_buff_stacks

		if not arg_131_1.ascending then
			arg_131_1.buff_ids[#arg_131_1.buff_ids + 1] = system:add_buff(arg_131_0, buff_to_add, arg_131_0, true)

			if max_sub_buff_stacks <= #arg_131_1.buff_ids then
				arg_131_1.ascending = false
			end
		else
			local remove = table.remove(arg_131_1.buff_ids, 1)

			system:remove_server_controlled_buff(arg_131_0, remove)

			if #arg_131_1.buff_ids <= 1 then
				arg_131_1.ascending = true
			end
		end
	end,
	activate_buff_on_closest = function (arg_132_0, arg_132_1, arg_132_2)
		-- function 132
		if not Managers.state.network.is_server then
			return
		end

		local template = arg_132_1.template
		local range = arg_132_1.range
		local num = range * range
		local var_132_3 = POSITION_LOOKUP[arg_132_0]
		local buff_to_add = template.buff_to_add
		local system = Managers.state.entity:system("buff_system")
		local var_132_6 = Managers.state.side.side_by_unit[arg_132_0]

		if not var_132_6 then
			return
		end

		local PLAYER_AND_BOT_UNITS = var_132_6.PLAYER_AND_BOT_UNITS
		local count = #PLAYER_AND_BOT_UNITS
		local var_132_9

		for i = 1, count do
			local var_132_10 = PLAYER_AND_BOT_UNITS[i]

			if not Unit.alive(var_132_10) then
				local var_132_11 = POSITION_LOOKUP[var_132_10]
				local distance_squared = Vector3.distance_squared(var_132_3, var_132_11)
				local extension = ScriptUnit.extension(var_132_10, "buff_system")

				if distance_squared > closest_player_distance then
					local get_non_stacking_buff = extension:get_non_stacking_buff(buff_to_add)

					if not get_non_stacking_buff then
						local server_id = get_non_stacking_buff.server_id

						if not server_id then
							system:remove_server_controlled_buff(var_132_10, server_id)
						end
					end
				end

				if not (not (distance_squared < num) or extension:has_buff_type(buff_to_add)) then
					local add_buff = system:add_buff(var_132_10, buff_to_add, arg_132_0, true)
					local get_non_stacking_buff_2 = extension:get_non_stacking_buff(buff_to_add)

					if not get_non_stacking_buff_2 then
						get_non_stacking_buff_2.server_id = add_buff
					end
				end
			end
		end
	end,
	markus_knight_proximity_buff_update = function (arg_133_0, arg_133_1, arg_133_2)
		-- function 133
		if not Managers.state.network.is_server then
			return
		end

		local template = arg_133_1.template
		local range = arg_133_1.range
		local num = range * range
		local var_133_3 = POSITION_LOOKUP[arg_133_0]
		local var_133_4 = Managers.state.side.side_by_unit[arg_133_0]

		if not var_133_4 then
			return
		end

		local PLAYER_AND_BOT_UNITS = var_133_4.PLAYER_AND_BOT_UNITS
		local count = #PLAYER_AND_BOT_UNITS
		local extension = ScriptUnit.extension(arg_133_0, "talent_system")
		local str = "markus_knight_passive_defence_aura"
		local system = Managers.state.entity:system("buff_system")
		local has_talent = extension:has_talent("markus_knight_guard")
		local has_talent_2 = extension:has_talent("markus_knight_passive_block_cost_aura")

		for i = 1, count do
			local var_133_12 = PLAYER_AND_BOT_UNITS[i]

			if not Unit.alive(var_133_12) then
				local var_133_13 = POSITION_LOOKUP[var_133_12]
				local distance_squared = Vector3.distance_squared(var_133_3, var_133_13)
				local extension_2 = ScriptUnit.extension(var_133_12, "buff_system")

				if num < distance_squared or has_talent or not has_talent_2 then
					local get_non_stacking_buff = extension_2:get_non_stacking_buff(str)

					if not get_non_stacking_buff then
						local server_id = get_non_stacking_buff.server_id

						if not server_id then
							system:remove_server_controlled_buff(var_133_12, server_id)
						end
					end
				end

				if not (not (distance_squared < num) or has_talent or has_talent_2 or extension_2:has_buff_type(str)) then
					local add_buff = system:add_buff(var_133_12, str, arg_133_0, true)
					local get_non_stacking_buff_2 = extension_2:get_non_stacking_buff(str)

					if not get_non_stacking_buff_2 then
						get_non_stacking_buff_2.server_id = add_buff
					end
				end
			end
		end
	end,
	markus_knight_movespeed_on_incapacitated_ally = function (arg_134_0, arg_134_1, arg_134_2)
		-- function 134
		if not Managers.state.network.is_server then
			return
		end

		if not ALIVE[arg_134_0] then
			return
		end

		local var_134_0 = Managers.state.side.side_by_unit[arg_134_0]
		local flag = not var_134_0 and var_134_0.PLAYER_AND_BOT_UNITS
		local count

		if not flag then
			count = #flag

			if not count then
				-- Nothing
			end
		end

		count = 0

		::label_134_0::

		local extension = ScriptUnit.extension(arg_134_0, "buff_system")
		local system = Managers.state.entity:system("buff_system")
		local buff_to_add = arg_134_1.template.buff_to_add
		local var_134_6

		for i = 1, count do
			local var_134_7 = flag[i]

			if not ScriptUnit.extension(var_134_7, "status_system"):is_disabled() then
				var_134_6 = true
			end
		end

		if not extension:has_buff_type(buff_to_add) then
			if not var_134_6 then
				local buff_id = arg_134_1.buff_id

				if not buff_id then
					system:remove_server_controlled_buff(arg_134_0, buff_id)

					arg_134_1.buff_id = nil
				end
			end
		elseif not var_134_6 then
			arg_134_1.buff_id = system:add_buff(arg_134_0, buff_to_add, arg_134_0, true)
		end
	end,
	kerillian_maidenguard_proximity_buff_update = function (arg_135_0, arg_135_1, arg_135_2)
		-- function 135
		if not Managers.state.network.is_server then
			return
		end

		local template = arg_135_1.template
		local range = arg_135_1.range
		local num = range * range
		local var_135_3 = POSITION_LOOKUP[arg_135_0]
		local var_135_4 = Managers.state.side.side_by_unit[arg_135_0]

		if not var_135_4 then
			return
		end

		local PLAYER_AND_BOT_UNITS = var_135_4.PLAYER_AND_BOT_UNITS
		local count = #PLAYER_AND_BOT_UNITS
		local str = "kerillian_maidenguard_passive_stamina_regen_buff"
		local system = Managers.state.entity:system("buff_system")

		for i = 1, count do
			local var_135_9 = PLAYER_AND_BOT_UNITS[i]

			if not Unit.alive(var_135_9) then
				local var_135_10 = POSITION_LOOKUP[var_135_9]
				local distance_squared = Vector3.distance_squared(var_135_3, var_135_10)
				local extension = ScriptUnit.extension(var_135_9, "buff_system")

				if num < distance_squared then
					local get_non_stacking_buff = extension:get_non_stacking_buff(str)

					if not get_non_stacking_buff then
						local server_id = get_non_stacking_buff.server_id

						if not server_id then
							system:remove_server_controlled_buff(var_135_9, server_id)
						end
					end
				end

				if not (not (distance_squared < num) or extension:has_buff_type(str)) then
					local add_buff = system:add_buff(var_135_9, str, arg_135_0, true)
					local get_non_stacking_buff_2 = extension:get_non_stacking_buff(str)

					if not get_non_stacking_buff_2 then
						get_non_stacking_buff_2.server_id = add_buff
					end
				end
			end
		end
	end,
	victor_bountyhunter_blessed_combat_update = function (arg_136_0, arg_136_1, arg_136_2)
		-- function 136
		local template = arg_136_1.template
		local extension = ScriptUnit.extension(arg_136_0, "buff_system")
		local ranged_buff_to_add = template.ranged_buff_to_add
		local ranged_buff = template.ranged_buff
		local has_buff_type = extension:has_buff_type(ranged_buff)
		local get_non_stacking_buff = extension:get_non_stacking_buff(ranged_buff_to_add)

		if not has_buff_type then
			if not get_non_stacking_buff then
				extension:add_buff(ranged_buff_to_add)
			end
		elseif not get_non_stacking_buff then
			extension:remove_buff(get_non_stacking_buff.id)
		end

		local melee_buff_to_add = template.melee_buff_to_add
		local melee_buff = template.melee_buff
		local has_buff_type_2 = extension:has_buff_type(melee_buff)
		local get_non_stacking_buff_2 = extension:get_non_stacking_buff(melee_buff_to_add)

		if not has_buff_type_2 then
			if not get_non_stacking_buff_2 then
				extension:add_buff(melee_buff_to_add)
			end
		elseif not get_non_stacking_buff_2 then
			extension:remove_buff(get_non_stacking_buff_2.id)
		end
	end,
	victor_bountyhunter_contract_killing_update = function (arg_137_0, arg_137_1, arg_137_2)
		-- function 137
		local template = arg_137_1.template
		local t = arg_137_2.t
		local update_frequency = template.update_frequency
		local extension = ScriptUnit.extension(arg_137_0, "buff_system")

		if not extension then
			return
		end

		if not arg_137_1.timer then
			arg_137_1.timer = t + update_frequency
		end

		if t > arg_137_1.timer then
			arg_137_1.timer = t + update_frequency

			local tbl = {}

			if not CurrentConflictSettings.factions then
				if not table.contains(CurrentConflictSettings.factions, "chaos") then
					local buffs_to_add_chaos = template.buffs_to_add_chaos

					for i = 1, #buffs_to_add_chaos do
						tbl[#tbl + 1] = buffs_to_add_chaos[i]
					end
				end

				if not table.contains(CurrentConflictSettings.factions, "skaven") then
					local buffs_to_add_skaven = template.buffs_to_add_skaven

					for j = 1, #buffs_to_add_skaven do
						tbl[#tbl + 1] = buffs_to_add_skaven[j]
					end
				end

				if not table.contains(CurrentConflictSettings.factions, "beastmen") then
					local buffs_to_add_beastmen = template.buffs_to_add_beastmen

					for k = 1, #buffs_to_add_beastmen do
						tbl[#tbl + 1] = buffs_to_add_beastmen[k]
					end
				end

				if extension:num_buff_type(template.reward_to_add) > 5 then
					local buffs_to_add_special = template.buffs_to_add_special

					for l = 1, #buffs_to_add_special do
						tbl[#tbl + 1] = buffs_to_add_special[l]
					end
				end
			end

			local var_137_9 = tbl[math.random(1, #tbl)]

			if not arg_137_1.current_buff_id then
				extension:remove_buff(template.current_buff_id)
			end

			if not var_137_9 then
				arg_137_1.current_buff_id = extension:add_buff(var_137_9)
				arg_137_1.can_reward = true
				arg_137_1.current_buff = var_137_9
			end
		end

		if not not extension:has_buff_type(arg_137_1.current_buff) and not arg_137_1.can_reward then
			local reward_to_add = template.reward_to_add

			arg_137_1.can_reward = false

			extension:add_buff(reward_to_add)
		end
	end,
	maidenguard_attack_speed_on_block_update = function (arg_138_0, arg_138_1, arg_138_2)
		-- function 138
		local template = arg_138_1.template
		local extension = ScriptUnit.extension(arg_138_0, "buff_system")
		local stat_increase_buffs = template.stat_increase_buffs
		local buff_to_add = template.buff_to_add

		for i = 1, #stat_increase_buffs do
			local var_138_4 = stat_increase_buffs[i]
			local has_buff_type = extension:has_buff_type(buff_to_add)
			local get_non_stacking_buff = extension:get_non_stacking_buff(var_138_4)

			if not has_buff_type then
				if not get_non_stacking_buff then
					extension:add_buff(var_138_4)
				end
			elseif not get_non_stacking_buff then
				extension:remove_buff(get_non_stacking_buff.id)
			end
		end
	end,
	activate_buff_on_other_buff = function (arg_139_0, arg_139_1, arg_139_2)
		-- function 139
		local template = arg_139_1.template
		local buff_to_add = template.buff_to_add
		local extension = ScriptUnit.extension(arg_139_0, "buff_system")
		local activation_buff = template.activation_buff
		local activate_on_missing = template.activate_on_missing
		local only_local = template.only_local
		local get_non_stacking_buff = extension:get_non_stacking_buff(activation_buff)
		local flag = (not get_non_stacking_buff and activate_on_missing and not not get_non_stacking_buff or not activate_on_missing) and not only_local and not only_local and fn_3(arg_139_0)
		local get_non_stacking_buff_2 = extension:get_non_stacking_buff(buff_to_add)

		if not flag then
			if not get_non_stacking_buff_2 then
				extension:add_buff(buff_to_add)
			end
		elseif not get_non_stacking_buff_2 then
			extension:remove_buff(get_non_stacking_buff_2.id)
		end
	end,
	activate_bonus_on_last_standing = function (arg_140_0, arg_140_1, arg_140_2)
		-- function 140
		local template = arg_140_1.template
		local activation_bonus = template.activation_bonus
		local stat_buff = template.stat_buff
		local var_140_3 = Managers.state.side.side_by_unit[arg_140_0]

		if not var_140_3 then
			return
		end

		local PLAYER_AND_BOT_UNITS = var_140_3.PLAYER_AND_BOT_UNITS
		local count = #PLAYER_AND_BOT_UNITS
		local var_140_6
		local tbl = {}

		for i = 1, count do
			local var_140_8 = PLAYER_AND_BOT_UNITS[i]

			tbl[#tbl + 1] = var_140_8
		end

		local tbl_2 = {}

		for j = 1, #tbl do
			local var_140_10 = tbl[j]
			local is_disabled = ScriptUnit.extension(var_140_10, "status_system"):is_disabled()

			if not (not is_disabled and var_140_10 ~= var_140_6) then
				return
			elseif not (not is_disabled and var_140_10 == var_140_6) then
				tbl_2[#tbl_2 + 1] = var_140_10
			end
		end

		local previous_bonus = arg_140_1.previous_bonus

		previous_bonus = previous_bonus or 0

		local num = 0

		if #tbl_2 == count - 1 then
			num = activation_bonus
		end

		arg_140_1.bonus = num

		if previous_bonus == num or not stat_buff then
			local extension = ScriptUnit.extension(arg_140_0, "buff_system")
			local num_2 = num - previous_bonus

			extension:update_stat_buff(stat_buff, num_2, template.name)
		end

		arg_140_1.previous_bonus = num
	end,
	activate_multiplier_on_last_standing = function (arg_141_0, arg_141_1, arg_141_2)
		-- function 141
		local template = arg_141_1.template
		local activation_multiplier = template.activation_multiplier
		local stat_buff = template.stat_buff
		local var_141_3 = Managers.state.side.side_by_unit[arg_141_0]

		if not var_141_3 then
			return
		end

		local PLAYER_AND_BOT_UNITS = var_141_3.PLAYER_AND_BOT_UNITS
		local count = #PLAYER_AND_BOT_UNITS
		local var_141_6
		local tbl = {}

		for i = 1, count do
			local var_141_8 = PLAYER_AND_BOT_UNITS[i]

			tbl[#tbl + 1] = var_141_8
		end

		local tbl_2 = {}

		for j = 1, #tbl do
			local var_141_10 = tbl[j]

			if not var_141_10 then
				local is_disabled = ScriptUnit.extension(var_141_10, "status_system"):is_disabled()

				if not (not is_disabled and var_141_10 ~= var_141_6) then
					return
				elseif not (not is_disabled and var_141_10 == var_141_6) then
					tbl_2[#tbl_2 + 1] = var_141_10
				end
			end
		end

		local previous_multiplier = arg_141_1.previous_multiplier

		previous_multiplier = previous_multiplier or 0

		local num = 0

		if #tbl_2 == count - 1 then
			num = activation_multiplier
		end

		arg_141_1.multiplier = num

		if previous_multiplier == num or not stat_buff then
			local extension = ScriptUnit.extension(arg_141_0, "buff_system")
			local num_2 = num - previous_multiplier

			extension:update_stat_buff(stat_buff, num_2, template.name)
		end

		arg_141_1.previous_multiplier = num
	end,
	activate_buff_on_last_standing = function (arg_142_0, arg_142_1, arg_142_2)
		-- function 142
		local template = arg_142_1.template
		local var_142_1 = Managers.state.side.side_by_unit[arg_142_0]

		if not var_142_1 then
			return
		end

		local PLAYER_AND_BOT_UNITS = var_142_1.PLAYER_AND_BOT_UNITS
		local count = #PLAYER_AND_BOT_UNITS
		local buff_to_add = template.buff_to_add
		local var_142_5 = arg_142_0
		local tbl = {}
		local var_142_7 = fn_3(var_142_5)

		for i = 1, count do
			local var_142_8 = PLAYER_AND_BOT_UNITS[i]

			tbl[#tbl + 1] = var_142_8
		end

		local tbl_2 = {}

		for j = 1, #tbl do
			local var_142_10 = tbl[j]

			if not var_142_10 then
				local has_extension = ScriptUnit.has_extension(var_142_10, "status_system")
				local flag = not has_extension and has_extension:is_disabled()

				if not (not flag and var_142_10 ~= var_142_5) then
					return
				elseif not (not flag and var_142_10 == var_142_5) then
					tbl_2[#tbl_2 + 1] = var_142_10
				end
			end
		end

		local var_142_13

		if #tbl_2 == count - 1 then
			var_142_13 = true
		end

		local has_extension_2 = ScriptUnit.has_extension(var_142_5, "buff_system")

		if not has_extension_2 then
			local system = Managers.state.entity:system("buff_system")
			local get_non_stacking_buff = has_extension_2:get_non_stacking_buff(buff_to_add)

			if var_142_13 or not get_non_stacking_buff then
				if not var_142_7 then
					has_extension_2:remove_buff(get_non_stacking_buff.id)
				else
					local server_id = get_non_stacking_buff.server_id

					system:remove_server_controlled_buff(var_142_5, server_id)
				end
			elseif not (not var_142_13 and get_non_stacking_buff) then
				if not var_142_7 then
					has_extension_2:add_buff(buff_to_add)
				else
					local add_buff = system:add_buff(var_142_5, buff_to_add, var_142_5, true)
					local get_non_stacking_buff_2 = has_extension_2:get_non_stacking_buff(buff_to_add)

					if not get_non_stacking_buff_2 then
						get_non_stacking_buff_2.server_id = add_buff
					end
				end
			end
		end
	end,
	activate_buff_on_health_percent = function (arg_143_0, arg_143_1, arg_143_2)
		-- function 143
		local template = arg_143_1.template
		local buff_to_add = template.buff_to_add
		local var_143_2 = arg_143_0
		local tbl = {}
		local extension = ScriptUnit.extension(var_143_2, "buff_system")
		local var_143_5 = fn_3(var_143_2)
		local activation_health = template.activation_health
		local activate_below = template.activate_below
		local current_health_percent = ScriptUnit.extension(arg_143_0, "health_system"):current_health_percent()
		local var_143_9

		if not ((not (current_health_percent < activation_health) or not activate_below or not (activation_health < current_health_percent)) and activate_below) then
			var_143_9 = true
		end

		local system = Managers.state.entity:system("buff_system")
		local get_non_stacking_buff = extension:get_non_stacking_buff(buff_to_add)

		if var_143_9 or not get_non_stacking_buff then
			if not var_143_5 then
				extension:remove_buff(get_non_stacking_buff.id)
			else
				local server_id = get_non_stacking_buff.server_id

				system:remove_server_controlled_buff(var_143_2, server_id)
			end
		elseif not (not var_143_9 and get_non_stacking_buff) then
			if not var_143_5 then
				extension:add_buff(buff_to_add)
			else
				local add_buff = system:add_buff(var_143_2, buff_to_add, var_143_2, true)
				local get_non_stacking_buff_2 = extension:get_non_stacking_buff(buff_to_add)

				if not get_non_stacking_buff_2 then
					get_non_stacking_buff_2.server_id = add_buff
				end
			end
		end
	end,
	activate_buff_on_disabled = function (arg_144_0, arg_144_1, arg_144_2)
		-- function 144
		local buff_to_add = arg_144_1.template.buff_to_add
		local var_144_1 = arg_144_0
		local extension = ScriptUnit.extension(var_144_1, "buff_system")
		local var_144_3 = fn_3(var_144_1)
		local extension_2 = ScriptUnit.extension(arg_144_0, "status_system")
		local is_disabled = extension_2:is_disabled()

		is_disabled = is_disabled or extension_2:is_in_vortex()

		local var_144_6

		if not is_disabled then
			var_144_6 = true
		end

		local system = Managers.state.entity:system("buff_system")
		local get_non_stacking_buff = extension:get_non_stacking_buff(buff_to_add)

		if var_144_6 or not get_non_stacking_buff then
			if not var_144_3 then
				extension:remove_buff(get_non_stacking_buff.id)
			else
				local server_id = get_non_stacking_buff.server_id

				system:remove_server_controlled_buff(var_144_1, server_id)
			end
		elseif not (not var_144_6 and get_non_stacking_buff) then
			if not var_144_3 then
				extension:add_buff(buff_to_add)
			else
				local add_buff = system:add_buff(var_144_1, buff_to_add, var_144_1, true)
				local get_non_stacking_buff_2 = extension:get_non_stacking_buff(buff_to_add)

				if not get_non_stacking_buff_2 then
					get_non_stacking_buff_2.server_id = add_buff
				end
			end
		end
	end,
	activate_buff_on_no_ammo = function (arg_145_0, arg_145_1, arg_145_2)
		-- function 145
		local buff_to_add = arg_145_1.template.buff_to_add
		local var_145_1 = arg_145_0
		local extension = ScriptUnit.extension(var_145_1, "buff_system")
		local var_145_3 = fn_3(var_145_1)
		local str = "slot_ranged"
		local bonus = arg_145_1.bonus
		local get_slot_data = ScriptUnit.extension(var_145_1, "inventory_system"):get_slot_data(str)

		if not get_slot_data then
			local right_unit_1p = get_slot_data.right_unit_1p
			local left_unit_1p = get_slot_data.left_unit_1p
			local has_extension = ScriptUnit.has_extension(right_unit_1p, "ammo_system")
			local has_extension_2 = ScriptUnit.has_extension(left_unit_1p, "ammo_system")
			local flag = has_extension or has_extension_2
			local var_145_12

			if not flag then
				var_145_12 = flag:total_ammo_fraction() == 0
			end

			local system = Managers.state.entity:system("buff_system")
			local get_non_stacking_buff = extension:get_non_stacking_buff(buff_to_add)

			if var_145_12 or not get_non_stacking_buff then
				if not var_145_3 then
					extension:remove_buff(get_non_stacking_buff.id)
				else
					local server_id = get_non_stacking_buff.server_id

					system:remove_server_controlled_buff(var_145_1, server_id)
				end
			elseif not (not var_145_12 and get_non_stacking_buff) then
				if not var_145_3 then
					extension:add_buff(buff_to_add)
				else
					local add_buff = system:add_buff(var_145_1, buff_to_add, var_145_1, true)
					local get_non_stacking_buff_2 = extension:get_non_stacking_buff(buff_to_add)

					if not get_non_stacking_buff_2 then
						get_non_stacking_buff_2.server_id = add_buff
					end
				end
			end
		end

		return false, 0
	end,
	activate_buff_on_grimoire_picked_up = function (arg_146_0, arg_146_1, arg_146_2)
		-- function 146
		local buff_to_add = arg_146_1.template.buff_to_add
		local var_146_1 = arg_146_0
		local extension = ScriptUnit.extension(var_146_1, "buff_system")
		local var_146_3 = fn_3(var_146_1)
		local extension_2 = ScriptUnit.extension(arg_146_0, "status_system")

		if not extension_2:is_disabled() then
			local is_in_vortex = extension_2:is_in_vortex()
		end

		local var_146_6

		if not extension:has_buff_perk("skaven_grimoire") then
			var_146_6 = true
		end

		local system = Managers.state.entity:system("buff_system")
		local get_non_stacking_buff = extension:get_non_stacking_buff(buff_to_add)

		if var_146_6 or not get_non_stacking_buff then
			if not var_146_3 then
				extension:remove_buff(get_non_stacking_buff.id)
			else
				local server_id = get_non_stacking_buff.server_id

				system:remove_server_controlled_buff(var_146_1, server_id)
			end
		elseif not (not var_146_6 and get_non_stacking_buff) then
			if not var_146_3 then
				extension:add_buff(buff_to_add)
			else
				local add_buff = system:add_buff(var_146_1, buff_to_add, var_146_1, true)
				local get_non_stacking_buff_2 = extension:get_non_stacking_buff(buff_to_add)

				if not get_non_stacking_buff_2 then
					get_non_stacking_buff_2.server_id = add_buff
				end
			end
		end
	end,
	activate_multiplier_on_disabled = function (arg_147_0, arg_147_1, arg_147_2)
		-- function 147
		local template = arg_147_1.template
		local activation_multiplier = template.activation_multiplier
		local stat_buff = template.stat_buff
		local extension = ScriptUnit.extension(arg_147_0, "status_system")
		local is_disabled = extension:is_disabled()

		is_disabled = is_disabled or extension:is_in_vortex()

		local previous_multiplier = arg_147_1.previous_multiplier

		previous_multiplier = previous_multiplier or 0

		local num = 0

		if not is_disabled then
			num = activation_multiplier
		end

		arg_147_1.multiplier = num

		if previous_multiplier == num or not stat_buff then
			local extension_2 = ScriptUnit.extension(arg_147_0, "buff_system")
			local num_2 = num - previous_multiplier

			extension_2:update_stat_buff(stat_buff, num_2, template.name)
		end

		arg_147_1.previous_multiplier = num
	end,
	activate_multiplier_on_wounded = function (arg_148_0, arg_148_1, arg_148_2)
		-- function 148
		local template = arg_148_1.template
		local activation_multiplier = template.activation_multiplier
		local stat_buff = template.stat_buff
		local is_wounded = ScriptUnit.extension(arg_148_0, "status_system"):is_wounded()
		local previous_multiplier = arg_148_1.previous_multiplier

		previous_multiplier = previous_multiplier or 0

		local num = 0

		if not is_wounded then
			num = activation_multiplier
		end

		arg_148_1.multiplier = num

		if previous_multiplier == num or not stat_buff then
			local extension = ScriptUnit.extension(arg_148_0, "buff_system")
			local num_2 = num - previous_multiplier

			extension:update_stat_buff(stat_buff, num_2, template.name)
		end

		arg_148_1.previous_multiplier = num
	end,
	activate_bonus_on_wounded = function (arg_149_0, arg_149_1, arg_149_2)
		-- function 149
		local template = arg_149_1.template
		local activation_bonus = template.activation_bonus

		activation_bonus = activation_bonus or 0

		local stat_buff = template.stat_buff
		local is_wounded = ScriptUnit.extension(arg_149_0, "status_system"):is_wounded()
		local previous_bonus = arg_149_1.previous_bonus

		previous_bonus = previous_bonus or 0

		local num = 0

		if not is_wounded then
			num = activation_bonus
		end

		arg_149_1.bonus = num

		if previous_bonus == num or not stat_buff then
			local extension = ScriptUnit.extension(arg_149_0, "buff_system")
			local num_2 = num - previous_bonus

			extension:update_stat_buff(stat_buff, num_2, template.name)
		end

		arg_149_1.previous_bonus = num
	end,
	bardin_slayer_passive_update = function (arg_150_0, arg_150_1, arg_150_2)
		-- function 150
		local broadphase = Managers.state.entity:system("ai_system").broadphase
		local template = arg_150_1.template
		local range = arg_150_1.range
		local base_multiplier = template.base_multiplier
		local stat_buff = template.stat_buff
		local previous_bonus = arg_150_1.previous_bonus

		previous_bonus = previous_bonus or 0

		local var_150_6 = POSITION_LOOKUP[arg_150_0]
		local extension = ScriptUnit.extension(arg_150_0, "talent_system")

		table.clear(tbl_3)

		local query = Broadphase.query(broadphase, var_150_6, range, tbl_3)
		local num = 0

		for i = 1, query do
			local var_150_10 = tbl_3[i]

			if not HEALTH_ALIVE[var_150_10] then
				num = num + 1
			end
		end

		local num_2 = 0

		if not extension:has_talent("bardin_slayer_increased_passive_bonus", "dwarf_ranger", true) then
			base_multiplier = base_multiplier * 1.5
		end

		if not extension:has_talent("bardin_slayer_increased_activation_number", "dwarf_ranger", true) then
			if num <= 2 then
				num_2 = base_multiplier
			end
		elseif num == 1 then
			num_2 = base_multiplier
		end

		arg_150_1.bonus = num_2

		if previous_bonus == num_2 or not stat_buff then
			local extension_2 = ScriptUnit.extension(arg_150_0, "buff_system")
			local num_3 = num_2 - previous_bonus

			extension_2:update_stat_buff(stat_buff, num_3, template.name)
		end

		arg_150_1.previous_bonus = num_2
	end,
	bardin_slayer_activate_buff_on_loadout = function (arg_151_0, arg_151_1, arg_151_2)
		-- function 151
		if not Managers.state.network.is_server then
			return
		end

		if not Unit.alive(arg_151_0) then
			local has_extension = ScriptUnit.has_extension(arg_151_0, "inventory_system")
			local get_slot_data = has_extension:get_slot_data("slot_melee")
			local get_slot_data_2 = has_extension:get_slot_data("slot_ranged")

			if not get_slot_data and not get_slot_data_2 then
				local template = arg_151_1.template
				local buff_type = template.buff_type
				local get_item_template = has_extension:get_item_template(get_slot_data)
				local flag = not get_item_template and get_item_template.buff_type
				local get_item_template_2 = has_extension:get_item_template(get_slot_data_2)
				local flag_2 = not get_item_template_2 and get_item_template_2.buff_type
				local has_extension_2 = ScriptUnit.has_extension(arg_151_0, "buff_system")
				local system = Managers.state.entity:system("buff_system")
				local buff_to_add = template.buff_to_add
				local has_buff_type = has_extension_2:has_buff_type(buff_to_add)

				flag_2 = flag_2 ~= "RANGED" or not "MELEE_1H" or flag_2

				local flag_3 = flag ~= buff_type or flag_2 == buff_type

				if not has_buff_type then
					if not flag_3 then
						arg_151_1.added_buff_id = system:add_buff(arg_151_0, buff_to_add, arg_151_0, true)
					end
				elseif not (not arg_151_1.added_buff_id and flag_3) then
					system:remove_server_controlled_buff(arg_151_0, arg_151_1.added_buff_id)

					arg_151_1.added_buff_id = nil
				else
					return
				end
			end
		end
	end,
	bardin_slayer_remove_activate_buff_on_loadout = function (arg_152_0, arg_152_1, arg_152_2)
		-- function 152
		if not Managers.state.network.is_server then
			return
		end

		if not Unit.alive(arg_152_0) then
			local template = arg_152_1.template
			local has_extension = ScriptUnit.has_extension(arg_152_0, "buff_system")
			local system = Managers.state.entity:system("buff_system")
			local buff_to_add = template.buff_to_add

			if not has_extension:has_buff_type(buff_to_add) and not arg_152_1.added_buff_id then
				system:remove_server_controlled_buff(arg_152_0, arg_152_1.added_buff_id)

				arg_152_1.added_buff_id = nil
			end
		end
	end,
	bardin_slayer_active_buff_on_charge_action = function (arg_153_0, arg_153_1, arg_153_2)
		-- function 153
		if not Unit.alive(arg_153_0) then
			local get_all_weapon_unit, var_153_1 = ScriptUnit.has_extension(arg_153_0, "inventory_system"):get_all_weapon_unit()
			local flag = not get_all_weapon_unit and ScriptUnit.has_extension(get_all_weapon_unit, "weapon_system")
			local flag_2 = not var_153_1 and ScriptUnit.has_extension(var_153_1, "weapon_system")
			local var_153_4

			if not flag and not flag:has_current_action() then
				local get_current_action_settings = flag:get_current_action_settings()

				var_153_4 = ActionUtils.is_melee_start_sub_action(get_current_action_settings)
			end

			if (var_153_4 or not flag_2) and not flag_2:has_current_action() then
				local get_current_action_settings_2 = flag_2:get_current_action_settings()

				var_153_4 = ActionUtils.is_melee_start_sub_action(get_current_action_settings_2)
			end

			if not var_153_4 then
				local has_extension = ScriptUnit.has_extension(arg_153_0, "buff_system")
				local buff_to_add = arg_153_1.template.buff_to_add

				if not has_extension:has_buff_type(buff_to_add) then
					local network = Managers.state.network
					local network_transmit = network.network_transmit
					local unit_game_object_id = network:unit_game_object_id(arg_153_0)
					local var_153_12 = NetworkLookup.buff_templates[buff_to_add]

					if not fn_5() then
						has_extension:add_buff(buff_to_add, {
							attacker_unit = arg_153_0
						})
						network_transmit:send_rpc_clients("rpc_add_buff", unit_game_object_id, var_153_12, unit_game_object_id, 0, false)
					else
						network_transmit:send_rpc_server("rpc_add_buff", unit_game_object_id, var_153_12, unit_game_object_id, 0, true)
					end
				end
			end
		end
	end,
	activate_on_single_enemy = function (arg_154_0, arg_154_1, arg_154_2)
		-- function 154
		local broadphase = Managers.state.entity:system("ai_system").broadphase
		local template = arg_154_1.template
		local range = arg_154_1.range
		local multiplier = template.multiplier
		local stat_buff = template.stat_buff
		local previous_multiplier = arg_154_1.previous_multiplier

		previous_multiplier = previous_multiplier or 0

		local var_154_6 = POSITION_LOOKUP[arg_154_0]

		table.clear(tbl_3)

		local query = Broadphase.query(broadphase, var_154_6, range, tbl_3)
		local num = 0

		for i = 1, query do
			local var_154_9 = tbl_3[i]

			if not HEALTH_ALIVE[var_154_9] then
				num = num + 1
			end
		end

		local num_2 = 0

		if num == 1 then
			num_2 = multiplier
		end

		arg_154_1.multiplier = num_2

		if previous_multiplier == num_2 or not stat_buff then
			local extension = ScriptUnit.extension(arg_154_0, "buff_system")
			local num_3 = num_2 - previous_multiplier

			extension:update_stat_buff(stat_buff, num_3, template.name)
		end

		arg_154_1.previous_multiplier = num_2
	end,
	activate_bonus_on_health_percent = function (arg_155_0, arg_155_1, arg_155_2)
		-- function 155
		local template = arg_155_1.template
		local activation_bonus = template.activation_bonus
		local activation_health = template.activation_health
		local activate_below = template.activate_below
		local stat_buff = template.stat_buff
		local current_health_percent = ScriptUnit.extension(arg_155_0, "health_system"):current_health_percent()
		local previous_bonus = arg_155_1.previous_bonus

		previous_bonus = previous_bonus or 0

		local num = 0

		if not ((not (current_health_percent < activation_health) or not activate_below or not (activation_health < current_health_percent)) and activate_below) then
			num = activation_bonus
		end

		arg_155_1.previous_bonus = num

		if previous_bonus == num or not stat_buff then
			local extension = ScriptUnit.extension(arg_155_0, "buff_system")
			local num_2 = num - previous_bonus

			extension:update_stat_buff(stat_buff, num_2, template.name)
		end

		arg_155_1.previous_bonus = num
	end,
	activate_multiplier_on_health_percent = function (arg_156_0, arg_156_1, arg_156_2)
		-- function 156
		local template = arg_156_1.template
		local activation_multiplier = template.activation_multiplier
		local activation_health = template.activation_health
		local activate_below = template.activate_below
		local stat_buff = template.stat_buff
		local current_health_percent = ScriptUnit.extension(arg_156_0, "health_system"):current_health_percent()
		local previous_multiplier = arg_156_1.previous_multiplier

		previous_multiplier = previous_multiplier or 0

		local num = 0

		if not ((not (current_health_percent < activation_health) or not activate_below or not (activation_health < current_health_percent)) and activate_below) then
			num = activation_multiplier
		end

		arg_156_1.previous_multiplier = num

		if previous_multiplier == num or not stat_buff then
			local extension = ScriptUnit.extension(arg_156_0, "buff_system")
			local num_2 = num - previous_multiplier

			extension:update_stat_buff(stat_buff, num_2, template.name)
		end

		arg_156_1.previous_multiplier = num
	end,
	activate_bonus_on_ammo_percent = function (arg_157_0, arg_157_1, arg_157_2)
		-- function 157
		local template = arg_157_1.template
		local activation_bonus = template.activation_bonus
		local activation_ammo = template.activation_ammo
		local activate_below = template.activate_below
		local stat_buff = template.stat_buff
		local has_extension = ScriptUnit.has_extension(arg_157_0, "inventory_system")
		local num = 0
		local get_slot_data = has_extension:get_slot_data("slot_ranged")

		if not get_slot_data then
			local left_unit_1p = get_slot_data.left_unit_1p
			local right_unit_1p = get_slot_data.right_unit_1p
			local extension

			if not ScriptUnit.has_extension(left_unit_1p, "ammo_system") then
				extension = ScriptUnit.extension(left_unit_1p, "ammo_system")

				if not extension then
					-- Nothing
				end
			end

			extension = ScriptUnit.has_extension(right_unit_1p, "ammo_system")
			extension = not extension and ScriptUnit.extension(right_unit_1p, "ammo_system")

			::label_157_0::

			local total_ammo_fraction = extension:total_ammo_fraction()

			if not arg_157_1.previous_bonus then
				local num_2 = 0
			end

			if not ((not (total_ammo_fraction < activation_ammo) or not activate_below or not (activation_ammo < total_ammo_fraction)) and activate_below) then
				num = activation_bonus
			end
		end

		arg_157_1.previous_bonus = num

		if previous_bonus == num or not stat_buff then
			local extension_2 = ScriptUnit.extension(arg_157_0, "buff_system")
			local num_3 = num - previous_bonus

			extension_2:update_stat_buff(stat_buff, num_3, template.name)
		end

		arg_157_1.previous_bonus = num
	end,
	activate_multiplier_on_ammo_percent = function (arg_158_0, arg_158_1, arg_158_2)
		-- function 158
		local template = arg_158_1.template
		local activation_multiplier = template.activation_multiplier
		local activation_ammo = template.activation_ammo
		local activate_below = template.activate_below
		local stat_buff = template.stat_buff
		local has_extension = ScriptUnit.has_extension(arg_158_0, "inventory_system")
		local num = 0
		local get_slot_data = has_extension:get_slot_data("slot_ranged")

		if not get_slot_data then
			local left_unit_1p = get_slot_data.left_unit_1p
			local right_unit_1p = get_slot_data.right_unit_1p
			local extension

			if not ScriptUnit.has_extension(left_unit_1p, "ammo_system") then
				extension = ScriptUnit.extension(left_unit_1p, "ammo_system")

				if not extension then
					-- Nothing
				end
			end

			extension = ScriptUnit.has_extension(right_unit_1p, "ammo_system")
			extension = not extension and ScriptUnit.extension(right_unit_1p, "ammo_system")

			::label_158_0::

			local total_ammo_fraction = extension:total_ammo_fraction()

			if not arg_158_1.previous_multiplier then
				local num_2 = 0
			end

			if not ((not (total_ammo_fraction < activation_ammo) or not activate_below or not (activation_ammo < total_ammo_fraction)) and activate_below) then
				num = activation_multiplier
			end
		end

		arg_158_1.previous_multiplier = num

		if previous_multiplier == num or not stat_buff then
			local extension_2 = ScriptUnit.extension(arg_158_0, "buff_system")
			local num_3 = num - previous_multiplier

			extension_2:update_stat_buff(stat_buff, num_3, template.name)
		end

		arg_158_1.previous_multiplier = num
	end,
	activate_multiplier_on_grimoire_picked_up = function (arg_159_0, arg_159_1, arg_159_2)
		-- function 159
		local extension = ScriptUnit.extension(arg_159_0, "buff_system")
		local template = arg_159_1.template
		local activation_multiplier = template.activation_multiplier
		local stat_buff = template.stat_buff
		local previous_multiplier = arg_159_1.previous_multiplier

		previous_multiplier = previous_multiplier or 0

		local num = 0

		if not extension:has_buff_perk("skaven_grimoire") then
			num = activation_multiplier
		end

		arg_159_1.previous_multiplier = num

		if previous_multiplier == num or not stat_buff then
			local num_2 = num - previous_multiplier

			extension:update_stat_buff(stat_buff, num_2, template.name)
		end

		arg_159_1.previous_multiplier = num
	end,
	activate_bonus_on_grimoire_picked_up = function (arg_160_0, arg_160_1, arg_160_2)
		-- function 160
		local extension = ScriptUnit.extension(arg_160_0, "buff_system")
		local template = arg_160_1.template
		local activation_bonus = template.activation_bonus
		local stat_buff = template.stat_buff
		local previous_bonus = arg_160_1.previous_bonus

		previous_bonus = previous_bonus or 0

		local num = 0

		if not extension:has_buff_perk("skaven_grimoire") then
			num = activation_bonus
		end

		arg_160_1.previous_bonus = num

		if previous_bonus == num or not stat_buff then
			local num_2 = num - previous_bonus

			extension:update_stat_buff(stat_buff, num_2, template.name)
		end

		arg_160_1.previous_bonus = num
	end,
	update_multiplier_based_on_missing_health = function (arg_161_0, arg_161_1, arg_161_2)
		-- function 161
		local get_damage_taken = ScriptUnit.extension(arg_161_0, "health_system"):get_damage_taken()
		local template = arg_161_1.template
		local base_multiplier = template.base_multiplier
		local stat_buff = template.stat_buff
		local previous_multiplier = arg_161_1.previous_multiplier

		previous_multiplier = previous_multiplier or 0

		local num = get_damage_taken * base_multiplier

		arg_161_1.multiplier = num

		if not (not stat_buff and previous_multiplier == num) then
			local extension = ScriptUnit.extension(arg_161_0, "buff_system")
			local num_2 = num - previous_multiplier

			extension:update_stat_buff(stat_buff, num_2, template.name)
		end

		arg_161_1.previous_multiplier = num
	end,
	sienna_unchained_activated_ability_pulse_remove = function (arg_162_0, arg_162_1, arg_162_2)
		-- function 162
		local world = Managers.world:world("level_world")

		if not arg_162_1.targeting_effect_id then
			World.destroy_particles(world, arg_162_1.targeting_effect_id)

			arg_162_1.targeting_effect_id = nil
		end

		if not arg_162_1.screenspace_effect_id then
			World.destroy_particles(world, arg_162_1.screenspace_effect_id)

			arg_162_1.screenspace_effect_id = nil
		end
	end,
	sienna_unchained_activated_ability_pulse_update = function (arg_163_0, arg_163_1, arg_163_2)
		-- function 163
		local template = arg_163_1.template
		local t = arg_163_2.t
		local var_163_2 = POSITION_LOOKUP[arg_163_0]
		local pulse_frequency = template.pulse_frequency

		if not ScriptUnit.extension(arg_163_0, "buff_system") then
			return
		end

		if not arg_163_1.targeting_effect_id then
			local world = Managers.world:world("level_world")
			local str = "fx/unchained_aura_talent_1p"
			local str_2 = "fx/unchained_aura_talent_3p"

			arg_163_1.targeting_effect_id = World.create_particles(world, str_2, Vector3.zero())
			arg_163_1.targeting_variable_id = World.find_particles_variable(world, str_2, "charge_radius")

			World.set_particles_variable(world, arg_163_1.targeting_effect_id, arg_163_1.targeting_variable_id, Vector3(12, 12, 0.2))

			local var_163_7 = str
			local has_extension = ScriptUnit.has_extension(arg_163_0, "first_person_system")

			if not has_extension then
				arg_163_1.screenspace_effect_id = has_extension:create_screen_particles(var_163_7)
			end
		end

		if not arg_163_1.targeting_effect_id then
			local world_2 = Managers.world:world("level_world")

			World.move_particles(world_2, arg_163_1.targeting_effect_id, var_163_2)
		end

		if not (not arg_163_1.timer and not (t > arg_163_1.timer)) then
			if not Managers.state.network.is_server then
				return
			end

			local broadphase = Managers.state.entity:system("ai_system").broadphase
			local extension = ScriptUnit.extension(arg_163_0, "buff_system")
			local system = Managers.state.entity:system("buff_system")
			local num = 6

			table.clear(tbl_3)

			local query = Broadphase.query(broadphase, var_163_2, num, tbl_3)
			local num_2 = 0

			for i = 1, query do
				local var_163_16 = tbl_3[i]

				if not HEALTH_ALIVE[var_163_16] then
					local num_3 = 2

					Managers.state.entity:system("buff_system"):add_buff(var_163_16, "burning_dot_unchained_pulse", arg_163_0, false, 200, arg_163_0)
					DamageUtils.add_damage_network(var_163_16, var_163_16, num_3, "torso", "burn_shotgun", nil, Vector3(0, 0, 0), nil, nil, arg_163_0, nil, nil, nil, nil, nil, nil, nil, nil, 1)
				end
			end

			arg_163_1.timer = t + pulse_frequency
		end
	end,
	sienna_unchained_health_to_cooldown_update = function (arg_164_0, arg_164_1, arg_164_2)
		-- function 164
		local t = arg_164_2.t
		local num = 0.25

		if not (not arg_164_1.timer and not (t >= arg_164_1.timer)) then
			arg_164_1.timer = t + num

			local has_extension = ScriptUnit.has_extension(arg_164_0, "career_system")

			if not (not has_extension and not (has_extension:current_ability_cooldown_percentage() > 0)) then
				has_extension:reduce_activated_ability_cooldown_percent(0.1)

				local num_2 = ScriptUnit.has_extension(arg_164_0, "health_system"):get_max_health() / 20

				DamageUtils.add_damage_network(arg_164_0, arg_164_0, num_2, "torso", "life_tap", nil, Vector3(0, 0, 0), "life_tap", nil, arg_164_0, nil, nil, nil, nil, nil, nil, nil, nil, 1)
			end
		end
	end,
	victor_bountyhunter_activated_ability_railgun_delayed = function (arg_165_0, arg_165_1, arg_165_2)
		-- function 165
		if not ALIVE[arg_165_0] then
			ScriptUnit.extension(arg_165_0, "career_system"):reduce_activated_ability_cooldown_percent(arg_165_1.multiplier)
		end
	end,
	enter_sienna_unchained_activated_ability = function (arg_166_0, arg_166_1, arg_166_2)
		-- function 166
		local go_id = Managers.state.unit_storage:go_id(arg_166_0)
		local network = Managers.state.network
		local game = network:game()

		if not (not go_id and game) then
			return
		end

		local game_object_field = GameSession.game_object_field(game, go_id, "aim_direction")
		local nav_world = Managers.state.entity:system("ai_system"):nav_world()
		local var_166_5 = POSITION_LOOKUP[arg_166_0]
		local num = 2
		local num_2 = 30
		local pos_on_mesh = LocomotionUtils.pos_on_mesh(nav_world, var_166_5, num, num_2)

		pos_on_mesh = pos_on_mesh or GwNavQueries.inside_position_from_outside_position(nav_world, var_166_5, num, num_2, 2, 0.5)

		if not pos_on_mesh then
			local str = "sienna_unchained_ability_patch"
			local var_166_10 = NetworkLookup.liquid_area_damage_templates[str]
			local unit_game_object_id = network:unit_game_object_id(arg_166_0)

			network.network_transmit:send_rpc_server("rpc_create_liquid_damage_area", unit_game_object_id, pos_on_mesh, game_object_field, var_166_10)
		end

		if not fn_3(arg_166_0) then
			ScriptUnit.extension(arg_166_0, "first_person_system"):play_hud_sound_event("Play_career_ability_sienna_unchained", nil, true)
		end
	end,
	sienna_adept_double_trail_talent_start_ability_cooldown_add = function (arg_167_0, arg_167_1, arg_167_2)
		-- function 167
		if not ALIVE[arg_167_0] and arg_167_1.aborted or not fn_3(arg_167_0) then
			local extension = ScriptUnit.extension(arg_167_0, "buff_system")
			local buff_to_add = arg_167_1.template.buff_to_add

			extension:add_buff(buff_to_add)
		end
	end,
	sienna_adept_double_trail_talent_start_ability_cooldown = function (arg_168_0, arg_168_1, arg_168_2)
		-- function 168
		if not ALIVE[arg_168_0] and arg_168_1._already_removed or not fn_3(arg_168_0) then
			local extension = ScriptUnit.extension(arg_168_0, "career_system")

			extension:set_abilities_always_usable(false, "sienna_adept_ability_trail_double")
			extension:stop_ability("cooldown_triggered")
			extension:start_activated_ability_cooldown()
		end

		arg_168_1._already_removed = true
	end,
	end_sienna_unchained_activated_ability = function (arg_169_0, arg_169_1, arg_169_2)
		-- function 169
		if not fn_3(arg_169_0) then
			ScriptUnit.extension(arg_169_0, "career_system"):set_state("default")
		end
	end,
	apply_shade_activated_ability = function (arg_170_0, arg_170_1, arg_170_2, arg_170_3)
		-- function 170
		local network_transmit = Managers.state.network.network_transmit
		local go_id = Managers.state.unit_storage:go_id(arg_170_0)
		local vfx_career_ability_start = NetworkLookup.flow_events.vfx_career_ability_start

		if not Managers.state.network.is_server then
			if not fn_4(arg_170_0) then
				Unit.flow_event(arg_170_0, "vfx_career_ability_start")
			end

			network_transmit:send_rpc_clients("rpc_flow_event", go_id, vfx_career_ability_start)
		else
			network_transmit:send_rpc_server("rpc_flow_event", go_id, vfx_career_ability_start)
		end

		local extension = ScriptUnit.extension(arg_170_0, "status_system")

		extension:set_noclip(true, arg_170_1)
		extension:set_invisible(true, nil, arg_170_1)

		if not fn_4(arg_170_0) then
			Managers.state.camera:set_mood("skill_shade", arg_170_1, true)
		end
	end,
	on_apply_shade_dash_stealth = function (arg_171_0, arg_171_1, arg_171_2, arg_171_3)
		-- function 171
		if not fn_3(arg_171_0) then
			local extension = ScriptUnit.extension(arg_171_0, "status_system")

			extension:set_invisible(true, nil, arg_171_1)
			extension:set_noclip(true, arg_171_1)
		end
	end,
	on_remove_shade_dash_stealth = function (arg_172_0, arg_172_1, arg_172_2, arg_172_3)
		-- function 172
		if not fn_3(arg_172_0) then
			local has_extension = ScriptUnit.has_extension(arg_172_0, "status_system")

			has_extension:set_invisible(false, nil, arg_172_1)
			has_extension:set_noclip(false, arg_172_1)
		end
	end,
	kerillian_shade_noclip_on = function (arg_173_0, arg_173_1, arg_173_2)
		-- function 173
		if not ALIVE[arg_173_0] then
			local has_extension = ScriptUnit.has_extension(arg_173_0, "status_system")

			if not has_extension then
				has_extension:set_noclip(true, "shade_phasing")
			end
		end
	end,
	kerillian_shade_noclip_off = function (arg_174_0, arg_174_1, arg_174_2)
		-- function 174
		if not ALIVE[arg_174_0] then
			local has_extension = ScriptUnit.has_extension(arg_174_0, "status_system")

			if not has_extension then
				has_extension:set_noclip(false, "shade_phasing")
			end
		end
	end,
	kerillian_shade_missed_combo_window = function (arg_175_0, arg_175_1, arg_175_2)
		-- function 175
		if not (not ALIVE[arg_175_0] and arg_175_1.killed_target) then
			local extension = ScriptUnit.extension(arg_175_0, "buff_system")
			local get_buff_type = extension:get_buff_type("kerillian_shade_ult_invis")

			if not get_buff_type then
				extension:remove_buff(get_buff_type.id)
			end
		end
	end,
	on_shade_activated_ability_remove = function (arg_176_0, arg_176_1, arg_176_2, arg_176_3)
		-- function 176
		if not ALIVE[arg_176_0] then
			return
		end

		if not fn_3(arg_176_0) then
			return
		end

		local template = arg_176_1.template
		local extension = ScriptUnit.extension(arg_176_0, "status_system")

		extension:set_invisible(false, nil, arg_176_1)
		extension:set_noclip(false, arg_176_1)

		local has_extension = ScriptUnit.has_extension(arg_176_0, "talent_system")
		local has_extension_2 = ScriptUnit.has_extension(arg_176_0, "buff_system")

		if not (not has_extension and has_extension_2) then
			return
		end

		local extension_2 = ScriptUnit.extension(arg_176_0, "first_person_system")

		extension_2:play_hud_sound_event("Stop_career_ability_kerillian_shade_loop")
		extension_2:play_hud_sound_event("Play_career_ability_kerillian_shade_exit", nil, true)
		extension_2:play_remote_hud_sound_event("Stop_career_ability_kerillian_shade_loop_husk")

		if not fn_4(arg_176_0) then
			Managers.state.camera:set_mood("skill_shade", arg_176_1, false)
		end

		ScriptUnit.extension(arg_176_0, "career_system"):set_state("default")
		extension:set_is_dodging(false)

		if not template.can_restealth_combo and not has_extension:has_talent("kerillian_shade_activated_stealth_combo") then
			has_extension_2:add_buff("kerillian_shade_ult_invis_combo_blocker")
			has_extension_2:add_buff("kerillian_shade_ult_invis")
		end

		if not template.can_restealth_on_remove and not has_extension:has_talent("kerillian_shade_activated_ability_restealth") then
			has_extension_2:add_buff("kerillian_shade_activated_ability_restealth")

			local var_176_5 = has_extension_2:get_stacking_buff("kerillian_shade_activated_ability_restealth")[1]
			local get_weapon_unit = ScriptUnit.extension(arg_176_0, "inventory_system"):get_weapon_unit()
			local extension_3 = ScriptUnit.extension(get_weapon_unit, "weapon_system")

			if not extension_3:has_current_action() then
				var_176_5.triggering_action_start_t = extension_3:get_current_action().action_start_t
			end
		end

		if not has_extension:has_talent("kerillian_shade_activated_ability_phasing") then
			has_extension_2:add_buff("kerillian_shade_phasing_buff")
			has_extension_2:add_buff("kerillian_shade_movespeed_buff")
			has_extension_2:add_buff("kerillian_shade_power_buff")
		end
	end,
	on_crit_passive_removed = function (arg_177_0, arg_177_1, arg_177_2)
		-- function 177
		local extension = ScriptUnit.extension(arg_177_0, "buff_system")
		local reference_buff = arg_177_1.template.reference_buff
		local get_non_stacking_buff = extension:get_non_stacking_buff(reference_buff)

		if not get_non_stacking_buff and not get_non_stacking_buff.buff_list then
			local count = #get_non_stacking_buff.buff_list

			for i = 1, count do
				local remove = table.remove(get_non_stacking_buff.buff_list)

				if not remove then
					extension:remove_buff(remove)
				end
			end

			get_non_stacking_buff.buff_list = {}
		end
	end,
	remove_invulnd_flash = function (arg_178_0, arg_178_1, arg_178_2)
		-- function 178
		if not ALIVE[arg_178_0] then
			ScriptUnit.has_extension(arg_178_0, "career_system"):set_activated_ability_cooldown_unpaused()
		end
	end,
	add_invulnd_flash = function (arg_179_0, arg_179_1, arg_179_2)
		-- function 179
		if not ALIVE[arg_179_0] and not Managers.player.is_server then
			StatusUtils.set_knocked_down_network(arg_179_0, false)
		end
	end,
	apply_huntsman_activated_ability = function (arg_180_0, arg_180_1, arg_180_2)
		-- function 180
		if not fn_6(arg_180_0) then
			Unit.flow_event(arg_180_0, "vfx_career_ability_start")
		end

		if not fn_3(arg_180_0) then
			ScriptUnit.has_extension(arg_180_0, "status_system"):set_invisible(true, nil, "huntsman_ability")
			ScriptUnit.extension(arg_180_0, "first_person_system"):play_remote_hud_sound_event("Play_career_ability_markus_huntsman_loop_husk")
		end
	end,
	end_huntsman_activated_ability = function (arg_181_0, arg_181_1, arg_181_2)
		-- function 181
		if not fn_3(arg_181_0) then
			ScriptUnit.extension(arg_181_0, "career_system"):set_state("default")
			ScriptUnit.extension(arg_181_0, "status_system"):set_invisible(false, nil, "huntsman_ability")

			local extension = ScriptUnit.extension(arg_181_0, "first_person_system")

			extension:play_hud_sound_event("Stop_career_ability_markus_huntsman_loop")
			extension:play_hud_sound_event("Play_career_ability_markus_huntsman_exit", nil, true)
			extension:play_remote_hud_sound_event("Stop_career_ability_markus_huntsman_loop_husk")

			if not fn_4(arg_181_0) then
				Managers.state.camera:set_mood("skill_huntsman_surge", "skill_huntsman_surge", false)
				Managers.state.camera:set_mood("skill_huntsman_stealth", "skill_huntsman_stealth", false)
			end
		end
	end,
	end_slayer_activated_ability = function (arg_182_0, arg_182_1, arg_182_2)
		-- function 182
		if not fn_3(arg_182_0) then
			local extension = ScriptUnit.extension(arg_182_0, "career_system")
			local extension_2 = ScriptUnit.extension(arg_182_0, "status_system")
			local extension_3 = ScriptUnit.extension(arg_182_0, "first_person_system")

			extension_2:set_noclip(false, "skill_slayer")
			extension_3:play_hud_sound_event("Play_career_ability_bardin_slayer_exit", nil, true)
			extension_3:play_hud_sound_event("Stop_career_ability_bardin_slayer_loop")
			extension:set_state("default")

			if not fn_4(arg_182_0) then
				Managers.state.camera:set_mood("skill_slayer", "skill_slayer", false)
			end
		end
	end,
	add_victor_zealot_invulnerability_cooldown = function (arg_183_0, arg_183_1, arg_183_2)
		-- function 183
		local var_183_0 = arg_183_0
		local extension = ScriptUnit.extension(var_183_0, "buff_system")

		if not Unit.alive(var_183_0) then
			extension:add_buff("victor_zealot_invulnerability_cooldown")
		end
	end,
	end_zealot_activated_ability = function (arg_184_0, arg_184_1, arg_184_2)
		-- function 184
		if not fn_3(arg_184_0) then
			local extension = ScriptUnit.extension(arg_184_0, "career_system")
			local extension_2 = ScriptUnit.extension(arg_184_0, "status_system")
			local extension_3 = ScriptUnit.extension(arg_184_0, "first_person_system")

			extension_2:set_noclip(false, "skill_zealot")
			extension_3:play_remote_unit_sound_event("Play_career_ability_victor_zealot_exit", arg_184_0, 0)
			extension:set_state("default")

			if not fn_4(arg_184_0) then
				extension_3:play_hud_sound_event("Play_career_ability_victor_zealot_exit")
				extension_3:play_hud_sound_event("Stop_career_ability_victor_zealot_loop")
				Managers.state.camera:set_mood("skill_zealot", "skill_zealot", false)
			end
		end
	end,
	bardin_ironbreaker_stacking_buff_gromril = function (arg_185_0, arg_185_1, arg_185_2)
		-- function 185
		local template = arg_185_1.template
		local extension = ScriptUnit.extension(arg_185_0, "buff_system")
		local activation_buff = template.activation_buff

		if not extension:get_non_stacking_buff(activation_buff) then
			local buff_ids = arg_185_1.buff_ids

			buff_ids = buff_ids or {}
			arg_185_1.buff_ids = buff_ids

			local count = #arg_185_1.buff_ids

			if count < template.max_sub_buff_stacks then
				local buff_to_add = template.buff_to_add
				local add_buff = extension:add_buff(buff_to_add)

				arg_185_1.buff_ids[count + 1] = add_buff
			end
		end
	end,
	update_bardin_ironbreaker_activated_ability = function (arg_186_0, arg_186_1, arg_186_2)
		-- function 186
		local num = 3

		if not fn_3(arg_186_0) then
			if not arg_186_2.next_vo_time then
				arg_186_2.next_vo_time = arg_186_2.t + num
			elseif arg_186_2.t >= arg_186_2.next_vo_time then
				arg_186_2.next_vo_time = arg_186_2.t + num

				local extension_input = ScriptUnit.extension_input(arg_186_0, "dialogue_system")
				local alloc_table = FrameTable.alloc_table()

				extension_input:trigger_networked_dialogue_event("activate_ability_taunt", alloc_table)
			end
		end
	end,
	end_bardin_ironbreaker_activated_ability = function (arg_187_0, arg_187_1, arg_187_2)
		-- function 187
		if not fn_3(arg_187_0) then
			arg_187_2.next_vo_time = nil

			local extension = ScriptUnit.extension(arg_187_0, "first_person_system")

			extension:play_hud_sound_event("Play_career_ability_bardin_ironbreaker_exit")
			extension:play_remote_unit_sound_event("Play_career_ability_bardin_ironbreaker_exit", arg_187_0, 0)
		end
	end,
	play_sound_synced = function (arg_188_0, arg_188_1, arg_188_2)
		-- function 188
		if not ALIVE[arg_188_0] then
			return false
		end

		if not fn_3(arg_188_0) then
			local extension = ScriptUnit.extension(arg_188_0, "first_person_system")
			local sound_to_play = arg_188_1.template.sound_to_play

			extension:play_hud_sound_event(sound_to_play, nil, true)
		end
	end,
	ranger_activated_ability_buff = function (arg_189_0, arg_189_1, arg_189_2)
		-- function 189
		if not fn_3(arg_189_0) then
			ScriptUnit.extension(arg_189_0, "status_system"):set_invisible(true, nil, arg_189_1)
		end
	end,
	ranger_activated_ability_buff_remove = function (arg_190_0, arg_190_1, arg_190_2)
		-- function 190
		if not fn_3(arg_190_0) then
			ScriptUnit.extension(arg_190_0, "status_system"):set_invisible(false, nil, arg_190_1)
		end
	end,
	bardin_ranger_smoke_buff = function (arg_191_0, arg_191_1, arg_191_2)
		-- function 191
		local template = arg_191_1.template
		local var_191_1 = POSITION_LOOKUP[arg_191_1.area_buff_unit]

		if not var_191_1 then
			return
		end

		local var_191_2 = Managers.state.side.side_by_unit[arg_191_0]

		if not var_191_2 then
			return
		end

		local system = Managers.state.entity:system("buff_system")
		local area_radius = template.area_radius
		local num = area_radius * area_radius
		local smoke_buff = template.smoke_buff
		local PLAYER_AND_BOT_UNITS = var_191_2.PLAYER_AND_BOT_UNITS

		for i = 1, #PLAYER_AND_BOT_UNITS do
			local var_191_8 = PLAYER_AND_BOT_UNITS[i]

			if not ALIVE[var_191_8] then
				local var_191_9 = POSITION_LOOKUP[var_191_8]

				if not (not (num > Vector3.distance_squared(var_191_9, var_191_1)) or ScriptUnit.extension(var_191_8, "buff_system"):has_buff_type(smoke_buff)) then
					local peer_id = Managers.player:owner(var_191_8).peer_id

					system:add_buff_synced(var_191_8, smoke_buff, template.buff_sync_type, nil, peer_id)
				end
			end
		end
	end,
	bardin_ranger_heal_smoke = function (arg_192_0, arg_192_1, arg_192_2)
		-- function 192
		if not Managers.state.network.is_server then
			return
		end

		local t = arg_192_2.t
		local template = arg_192_1.template
		local next_heal_tick = arg_192_1.next_heal_tick

		next_heal_tick = next_heal_tick or 0

		if not (next_heal_tick < t) or not HEALTH_ALIVE[arg_192_0] then
			if not ScriptUnit.has_extension(arg_192_0, "talent_system") then
				local has_extension = ScriptUnit.has_extension(arg_192_0, "status_system")

				if not has_extension then
					return
				end

				local heal_amount = template.heal_amount

				if not (has_extension:is_knocked_down() or has_extension:is_assisted_respawning()) then
					DamageUtils.heal_network(arg_192_0, arg_192_0, heal_amount, "heal_from_proc")
				end
			end

			arg_192_1.next_heal_tick = t + template.time_between_heals
		end
	end,
	update_server_buff_on_health_percent = function (arg_193_0, arg_193_1, arg_193_2)
		-- function 193
		if not Managers.state.network.is_server then
			return
		end

		if not ALIVE[arg_193_0] then
			local has_extension = ScriptUnit.has_extension(arg_193_0, "health_system")

			if not has_extension then
				local get_max_health = has_extension:get_max_health()
				local threshold = arg_193_1.template.threshold
				local current_health = has_extension:current_health()
				local buff_to_add = arg_193_1.template.buff_to_add

				if not (not (current_health >= get_max_health * arg_193_1.template.health_threshold) or arg_193_1.has_buff) then
					arg_193_1.has_buff = Managers.state.entity:system("buff_system"):add_buff(arg_193_0, buff_to_add, arg_193_0, true)
				elseif not (current_health < get_max_health * arg_193_1.template.health_threshold) or not arg_193_1.has_buff then
					Managers.state.entity:system("buff_system"):remove_server_controlled_buff(arg_193_0, arg_193_1.has_buff)

					arg_193_1.has_buff = nil
				end
			end
		end
	end,
	remove_server_buff_on_health_percent = function (arg_194_0, arg_194_1, arg_194_2)
		-- function 194
		if not Managers.state.network.is_server then
			return
		end

		if not ALIVE[arg_194_0] and not arg_194_1.has_buff then
			Managers.state.entity:system("buff_system"):remove_server_controlled_buff(arg_194_0, arg_194_1.has_buff)

			arg_194_1.has_buff = nil
		end
	end,
	start_maidenguard_activated_ability = function (arg_195_0, arg_195_1, arg_195_2)
		-- function 195
		ScriptUnit.extension(arg_195_0, "status_system"):set_noclip(true, arg_195_1)

		if not (not fn_3(arg_195_0) and fn_4(arg_195_0)) then
			local num = 0.8
			local num_2 = 0.2

			Managers.state.camera:set_additional_fov_multiplier_with_lerp_time(num, num_2)
		end
	end,
	end_maidenguard_activated_ability = function (arg_196_0, arg_196_1, arg_196_2)
		-- function 196
		local extension = ScriptUnit.extension(arg_196_0, "status_system")

		extension:set_noclip(false, arg_196_1)

		if not fn_3(arg_196_0) then
			if not fn_4(arg_196_0) then
				local num = 1
				local num_2 = 0.5

				Managers.state.camera:set_additional_fov_multiplier_with_lerp_time(num, num_2)
			end

			ScriptUnit.extension(arg_196_0, "career_system"):set_state("default")

			if not Managers.state.network:game() then
				extension:set_is_dodging(false)

				local network = Managers.state.network
				local unit_game_object_id = network:unit_game_object_id(arg_196_0)

				network.network_transmit:send_rpc_server("rpc_status_change_bool", NetworkLookup.statuses.dodging, false, unit_game_object_id, 0)
			end
		end
	end,
	start_maidenguard_ability_stealth = function (arg_197_0, arg_197_1, arg_197_2)
		-- function 197
		local extension = ScriptUnit.extension(arg_197_0, "status_system")

		extension:set_invisible(true, nil, arg_197_1)
		extension:set_noclip(true, arg_197_1)

		if not (not fn_3(arg_197_0) and fn_4(arg_197_0)) then
			Managers.state.camera:set_mood("skill_maiden_guard", arg_197_1, true)
		end
	end,
	end_maidenguard_ability_stealth = function (arg_198_0, arg_198_1, arg_198_2)
		-- function 198
		local extension = ScriptUnit.extension(arg_198_0, "status_system")

		extension:set_invisible(false, nil, arg_198_1)
		extension:set_noclip(false, arg_198_1)

		if not (not fn_3(arg_198_0) and fn_4(arg_198_0)) then
			Managers.state.camera:set_mood("skill_maiden_guard", arg_198_1, false)
		end
	end,
	end_knight_activated_ability = function (arg_199_0, arg_199_1, arg_199_2)
		-- function 199
		if not fn_3(arg_199_0) then
			ScriptUnit.extension(arg_199_0, "status_system"):set_noclip(false, "skill_knight")
		end
	end,
	start_activated_ability_cooldown = function (arg_200_0, arg_200_1, arg_200_2)
		-- function 200
		if not (not fn_3(arg_200_0) and arg_200_1.attacker_unit ~= arg_200_0) then
			ScriptUnit.extension(arg_200_0, "career_system"):start_activated_ability_cooldown()
		end
	end,
	update_bonus_based_on_missing_health_chunks = function (arg_201_0, arg_201_1, arg_201_2)
		-- function 201
		local get_damage_taken = ScriptUnit.extension(arg_201_0, "health_system"):get_damage_taken()
		local template = arg_201_1.template
		local min_bonus = template.min_bonus
		local max_bonus = template.max_bonus
		local chunk_size = template.chunk_size
		local stat_buff = template.stat_buff
		local previous_bonus = arg_201_1.previous_bonus

		previous_bonus = previous_bonus or 0

		local num = math.floor(get_damage_taken / chunk_size) * min_bonus

		if max_bonus < num then
			num = max_bonus
		end

		arg_201_1.bonus = num

		if not (not stat_buff and previous_bonus == num) then
			local extension = ScriptUnit.extension(arg_201_0, "buff_system")
			local num_2 = num - previous_bonus

			extension:update_stat_buff(stat_buff, num_2, template.name)
		end

		arg_201_1.previous_bonus = num
	end,
	update_multiplier_based_on_missing_health_chunks = function (arg_202_0, arg_202_1, arg_202_2)
		-- function 202
		local get_damage_taken = ScriptUnit.extension(arg_202_0, "health_system"):get_damage_taken()
		local template = arg_202_1.template
		local min_multiplier = template.min_multiplier
		local max_multiplier = template.max_multiplier
		local chunk_size = template.chunk_size
		local stat_buff = template.stat_buff
		local previous_multiplier = arg_202_1.previous_multiplier

		previous_multiplier = previous_multiplier or 0

		local num = math.floor(get_damage_taken / chunk_size) * min_multiplier

		if max_multiplier < num then
			num = max_multiplier
		end

		arg_202_1.multiplier = num

		if not (not stat_buff and previous_multiplier == num) then
			local extension = ScriptUnit.extension(arg_202_0, "buff_system")
			local num_2 = num - previous_multiplier

			extension:update_stat_buff(stat_buff, num_2, template.name)
		end

		arg_202_1.previous_multiplier = num
	end,
	update_bonus_based_on_overcharge_chunks = function (arg_203_0, arg_203_1, arg_203_2)
		-- function 203
		if not fn_3(arg_203_0) then
			local current_overcharge_status, var_203_1, var_203_2 = ScriptUnit.extension(arg_203_0, "overcharge_system"):current_overcharge_status()
			local template = arg_203_1.template
			local min_bonus = template.min_bonus
			local max_bonus = template.max_bonus
			local chunk_size = template.chunk_size
			local stat_buff = template.stat_buff
			local previous_bonus = arg_203_1.previous_bonus

			previous_bonus = previous_bonus or 0

			local num = math.floor(current_overcharge_status / chunk_size) * min_bonus

			if max_bonus < num then
				num = max_bonus
			end

			arg_203_1.bonus = num

			if not (not stat_buff and previous_bonus == num) then
				local extension = ScriptUnit.extension(arg_203_0, "buff_system")
				local num_2 = num - previous_bonus

				extension:update_stat_buff(stat_buff, num_2, template.name)
			end

			arg_203_1.previous_bonus = num
		end
	end,
	apply_grenade_slow = function (arg_204_0, arg_204_1, arg_204_2)
		-- function 204
		if not Managers.state.network.is_server then
			arg_204_1.movement_modifier_id = ScriptUnit.extension(arg_204_0, "ai_navigation_system"):add_movement_modifier(0.2)
		end
	end,
	remove_grenade_slow = function (arg_205_0, arg_205_1, arg_205_2)
		-- function 205
		if not Managers.state.network.is_server then
			ScriptUnit.extension(arg_205_0, "ai_navigation_system"):remove_movement_modifier(arg_205_1.movement_modifier_id)
		end
	end,
	activate_bonus_based_on_low_health = function (arg_206_0, arg_206_1, arg_206_2)
		-- function 206
		local extension = ScriptUnit.extension(arg_206_0, "health_system")
		local template = arg_206_1.template
		local get_damage_taken = extension:get_damage_taken()
		local get_max_health = extension:get_max_health()
		local activation_health = template.activation_health
		local num = 0

		if get_max_health - get_damage_taken < activation_health * get_max_health then
			num = template.multiplier
		end

		local stat_buff = template.stat_buff
		local previous_multiplier = arg_206_1.previous_multiplier

		previous_multiplier = previous_multiplier or 0

		if not (not stat_buff and previous_multiplier == num) then
			local extension_2 = ScriptUnit.extension(arg_206_0, "buff_system")
			local num_2 = num - previous_multiplier

			extension_2:update_stat_buff(stat_buff, num_2, template.name)
		end

		arg_206_1.previous_multiplier = num
	end,
	reduce_cooldown_percent = function (arg_207_0, arg_207_1, arg_207_2)
		-- function 207
		local has_extension = ScriptUnit.has_extension(arg_207_0, "career_system")

		if not has_extension then
			local cooldown_amount = arg_207_1.template.cooldown_amount

			has_extension:reduce_activated_ability_cooldown_percent(cooldown_amount)
		end
	end,
	apply_volume_dot_damage = function (arg_208_0, arg_208_1, arg_208_2)
		-- function 208
		arg_208_1.next_damage_time = arg_208_2.t + arg_208_2.bonus.time_between_damage
	end,
	update_volume_dot_damage = function (arg_209_0, arg_209_1, arg_209_2)
		-- function 209
		if not (arg_209_1.next_damage_time < arg_209_2.t) or not HEALTH_ALIVE[arg_209_0] then
			arg_209_1.next_damage_time = arg_209_1.next_damage_time + arg_209_2.bonus.time_between_damage

			local calculate_damage = DamageUtils.calculate_damage(arg_209_2.bonus.damage, arg_209_0, arg_209_2.attacker_unit, "full", 1)

			DamageUtils.add_damage_network(arg_209_0, arg_209_2.attacker_unit, calculate_damage, "full", arg_209_1.template.damage_type, nil, Vector3(1, 0, 0), nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, 1)
		end
	end,
	apply_volume_movement_buff = function (arg_210_0, arg_210_1, arg_210_2)
		-- function 210
		local get_movement_settings_table = PlayerUnitMovementSettings.get_movement_settings_table(arg_210_0)

		get_movement_settings_table.move_speed = get_movement_settings_table.move_speed * arg_210_2.multiplier
	end,
	remove_volume_movement_buff = function (arg_211_0, arg_211_1, arg_211_2)
		-- function 211
		local get_movement_settings_table = PlayerUnitMovementSettings.get_movement_settings_table(arg_211_0)

		get_movement_settings_table.move_speed = get_movement_settings_table.move_speed / arg_211_2.multiplier
	end,
	apply_speed_scaled_dot_buff = function (arg_212_0, arg_212_1, arg_212_2)
		-- function 212
		if not fn_3(arg_212_0) then
			arg_212_1.next_damage_t = 0
		end
	end,
	update_speed_scaled_dot_buff = function (arg_213_0, arg_213_1, arg_213_2)
		-- function 213
		if not fn_3(arg_213_0) then
			local extension = ScriptUnit.extension(arg_213_0, "locomotion_system")
			local flat = Vector3.flat(extension:current_velocity())

			if not (Vector3.length(flat) > 0.5) or not (arg_213_1.next_damage_t < arg_213_2.t) or not HEALTH_ALIVE[arg_213_0] then
				local template = arg_213_1.template
				local damage_type = template.damage_type
				local damage = template.damage

				DamageUtils.add_damage_network(arg_213_0, arg_213_0, damage, "torso", damage_type, nil, Vector3(1, 0, 0), "buff", nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, 1)

				arg_213_1.next_damage_t = arg_213_2.t + template.damage_frequency
			end
		end
	end,
	remove_speed_scaled_dot_buff = function (arg_214_0, arg_214_1, arg_214_2)
		-- function 214
		if not fn_3(arg_214_0) then
			-- Nothing
		end
	end,
	apply_twitch_invisibility_buff = function (arg_215_0, arg_215_1, arg_215_2)
		-- function 215
		if not fn_3(arg_215_0) then
			local extension = ScriptUnit.extension(arg_215_0, "status_system")

			extension:set_invisible(true, nil, "twitch_invis")
			extension:set_noclip(true, "twitch_invis")

			if not fn_4(arg_215_0) then
				ScriptUnit.extension(arg_215_0, "first_person_system"):play_hud_sound_event("Play_career_ability_kerillian_shade_enter_small")
				Managers.state.camera:set_mood("twitch_invis", arg_215_1, true)
			end
		end
	end,
	update_twitch_invisibility_buff = function (arg_216_0, arg_216_1, arg_216_2)
		-- function 216
		return
	end,
	remove_twitch_invisibility_buff = function (arg_217_0, arg_217_1, arg_217_2)
		-- function 217
		if not fn_3(arg_217_0) then
			local extension = ScriptUnit.extension(arg_217_0, "status_system")
			local set_invisible = extension:set_invisible(false, nil, "twitch_invis")

			extension:set_noclip(false, "twitch_invis")

			if not fn_4(arg_217_0) then
				Managers.state.camera:set_mood("twitch_invis", arg_217_1, false)
			end
		end
	end,
	apply_twitch_infinite_bombs = function (arg_218_0, arg_218_1, arg_218_2)
		-- function 218
		return
	end,
	update_twitch_infinite_bombs = function (arg_219_0, arg_219_1, arg_219_2)
		-- function 219
		if not fn_3(arg_219_0) then
			local network_transmit = Managers.state.network.network_transmit
			local extension = ScriptUnit.extension(arg_219_0, "inventory_system")
			local extension_2 = ScriptUnit.extension(arg_219_0, "career_system")
			local frag_grenade_t1 = AllPickups.frag_grenade_t1
			local slot_name = frag_grenade_t1.slot_name
			local item_name = frag_grenade_t1.item_name
			local get_slot_data = extension:get_slot_data(slot_name)
			local flag = not get_slot_data and get_slot_data.item_data
			local var_219_8 = ItemMasterList[item_name]
			local flag_2 = not get_slot_data and flag.name ~= item_name

			if not flag_2 then
				local tbl = {}

				if not get_slot_data then
					extension:destroy_slot(slot_name)
					extension:add_equipment(slot_name, var_219_8, nil, tbl)
				else
					extension:add_equipment(slot_name, var_219_8, nil, tbl)
				end
			end

			local var_219_11

			repeat
				-- Nothing
			until not extension:store_additional_item(slot_name, var_219_8)

			if not flag_2 then
				local go_id = Managers.state.unit_storage:go_id(arg_219_0)
				local var_219_13 = NetworkLookup.equipment_slots[slot_name]
				local var_219_14 = NetworkLookup.item_names[item_name]
				local var_219_15 = NetworkLookup.weapon_skins["n/a"]

				if not fn_5() then
					network_transmit:send_rpc_clients("rpc_add_equipment", go_id, var_219_13, var_219_14, var_219_15)
				else
					network_transmit:send_rpc_server("rpc_add_equipment", go_id, var_219_13, var_219_14, var_219_15)
				end

				if extension:get_wielded_slot_name() == slot_name then
					CharacterStateHelper.stop_weapon_actions(extension, "picked_up_object")
					CharacterStateHelper.stop_career_abilities(extension_2, "picked_up_object")
					extension:wield(slot_name)
				end
			end
		end
	end,
	remove_twitch_infinite_bombs = function (arg_220_0, arg_220_1, arg_220_2)
		-- function 220
		return
	end,
	apply_twitch_invincibility = function (arg_221_0, arg_221_1, arg_221_2)
		-- function 221
		if not fn_5() and not Unit.alive(arg_221_0) then
			ScriptUnit.extension(arg_221_0, "health_system").is_invincible = true
		end
	end,
	remove_twitch_invincibility = function (arg_222_0, arg_222_1, arg_222_2)
		-- function 222
		if not fn_5() and not Unit.alive(arg_222_0) then
			ScriptUnit.extension(arg_222_0, "health_system").is_invincible = false
		end
	end,
	apply_twitch_pulsating_waves = function (arg_223_0, arg_223_1, arg_223_2)
		-- function 223
		arg_223_1.next_pulse_t = arg_223_2.t
	end,
	update_twitch_pulsating_waves = function (arg_224_0, arg_224_1, arg_224_2, arg_224_3)
		-- function 224
		if not fn_5() and not Unit.alive(arg_224_0) then
			local t = arg_224_2.t

			if t > arg_224_1.next_pulse_t then
				local str = "grenade_frag_01"
				local get_template = ExplosionUtils.get_template("twitch_pulse_explosion")
				local var_224_3 = POSITION_LOOKUP[arg_224_0]

				DamageUtils.create_explosion(arg_224_3, arg_224_0, var_224_3, Quaternion.identity(), get_template, 1, str, true, false, arg_224_0, false)

				local go_id = Managers.state.unit_storage:go_id(arg_224_0)
				local var_224_5 = NetworkLookup.explosion_templates[get_template.name]
				local var_224_6 = NetworkLookup.damage_sources[str]

				Managers.state.network.network_transmit:send_rpc_clients("rpc_create_explosion", go_id, false, var_224_3, Quaternion.identity(), var_224_5, 1, var_224_6, 0, false)

				arg_224_1.next_pulse_t = t + 2
			end
		end
	end,
	add_modify_ability_max_cooldown = function (arg_225_0, arg_225_1, arg_225_2)
		-- function 225
		if not Unit.alive(arg_225_0) then
			ScriptUnit.extension(arg_225_0, "career_system"):modify_max_cooldown(1, 0, arg_225_1.template.multiplier)
		end
	end,
	remove_modify_ability_max_cooldown = function (arg_226_0, arg_226_1, arg_226_2)
		-- function 226
		if not Unit.alive(arg_226_0) then
			ScriptUnit.extension(arg_226_0, "career_system"):modify_max_cooldown(1, 0, -arg_226_1.template.multiplier)
		end
	end,
	refresh_ranged_slot_buffs = function (arg_227_0, arg_227_1, arg_227_2)
		-- function 227
		local has_extension = ScriptUnit.has_extension(arg_227_0, "inventory_system")

		if not has_extension then
			local get_slot_data = has_extension:get_slot_data("slot_ranged")

			if not get_slot_data then
				local left_unit_1p = get_slot_data.left_unit_1p
				local right_unit_1p = get_slot_data.right_unit_1p
				local has_extension_2 = ScriptUnit.has_extension(left_unit_1p, "ammo_system")

				if not has_extension_2 then
					has_extension_2:refresh_buffs()
				end

				local has_extension_3 = ScriptUnit.has_extension(right_unit_1p, "ammo_system")

				if not has_extension_3 then
					has_extension_3:refresh_buffs()
				end
			end
		end
	end,
	sienna_scholar_vent_zone_update = function (arg_228_0, arg_228_1, arg_228_2)
		-- function 228
		local template = arg_228_1.template
		local buff_to_add = template.buff_to_add
		local extension = ScriptUnit.extension(arg_228_0, "buff_system")
		local get_stacking_buff = extension:get_stacking_buff(buff_to_add)
		local count

		if not get_stacking_buff then
			count = #get_stacking_buff

			if not count then
				-- Nothing
			end
		end

		count = 0

		::label_228_0::

		local enemy_broadphase_categories = Managers.state.side.side_by_unit[arg_228_0].enemy_broadphase_categories
		local var_228_6 = POSITION_LOOKUP[arg_228_0]
		local radius = template.radius
		local alloc_table = FrameTable.alloc_table()
		local broadphase_query = AiUtils.broadphase_query(var_228_6, radius, alloc_table, enemy_broadphase_categories)

		if count < broadphase_query then
			for i = count + 1, broadphase_query do
				extension:add_buff(buff_to_add)
			end
		elseif broadphase_query < count then
			for j = 1, count - broadphase_query do
				local var_228_10 = get_stacking_buff[count - j + 1]

				extension:remove_buff(var_228_10.id)
			end
		end
	end,
	update_kill_timer = function (arg_229_0, arg_229_1, arg_229_2)
		-- function 229
		if not Managers.state.network.is_server then
			return
		end

		local fuse_time = arg_229_1.template.fuse_time

		if fuse_time <= math.min(arg_229_2.time_into_buff, fuse_time) then
			local str = "kinetic"
			local var_229_2 = Vector3(0, 0, -1)

			AiUtils.kill_unit(arg_229_0, nil, nil, str, var_229_2)
		end
	end,
	sorcerer_tether_buff_invulnerability_update = function (arg_230_0, arg_230_1, arg_230_2, arg_230_3)
		-- function 230
		if not Managers.state.network.is_server then
			return
		end

		local attacker_unit = arg_230_1.attacker_unit

		if not HEALTH_ALIVE[attacker_unit] then
			ScriptUnit.extension(arg_230_0, "buff_system"):remove_buff(arg_230_1.id)
		end
	end,
	sorcerer_tether_buff_apply_visuals = function (arg_231_0, arg_231_1, arg_231_2, arg_231_3)
		-- function 231
		local get_data = Unit.get_data(arg_231_0, "sorcerer_tether_buff_invulnerability_count")

		get_data = get_data or 0

		if get_data == 0 then
			local node

			if not Unit.has_node(arg_231_0, "j_hips") then
				node = Unit.node(arg_231_0, "j_hips")

				if not node then
					-- Nothing
				end
			end

			node = 0

			::label_231_0::

			local spawn_unit = World.spawn_unit(arg_231_3, "fx/units/sphere_troll_chief")

			World.link_unit(arg_231_3, spawn_unit, 0, arg_231_0, node)
			Unit.set_data(arg_231_0, "sorcerer_tether_buff_invulnerability_visual", spawn_unit)
		end

		Unit.set_data(arg_231_0, "sorcerer_tether_buff_invulnerability_count", get_data + 1)
	end,
	sorcerer_tether_buff_remove_visuals = function (arg_232_0, arg_232_1, arg_232_2, arg_232_3)
		-- function 232
		local get_data = Unit.get_data(arg_232_0, "sorcerer_tether_buff_invulnerability_count")

		if get_data == 1 then
			local get_data_2 = Unit.get_data(arg_232_0, "sorcerer_tether_buff_invulnerability_visual")

			World.destroy_unit(arg_232_3, get_data_2)
		end

		Unit.set_data(arg_232_0, "sorcerer_tether_buff_invulnerability_count", get_data - 1)
	end
}

BuffFunctionTemplates.functions.update_charging_action_lerp_movement_buff = function (arg_233_0, arg_233_1, arg_233_2)
	-- function 233
	local multiplier = arg_233_2.multiplier
	local time_into_buff = arg_233_2.time_into_buff
	local var_233_2
	local var_233_3
	local var_233_4
	local extension = ScriptUnit.extension(arg_233_0, "buff_system")

	multiplier = not multiplier and 1 - extension:apply_buffs_to_value(1 - multiplier, "increased_move_speed_while_aiming")

	local min = math.min(1, time_into_buff / arg_233_1.template.lerp_time)

	if not multiplier then
		local lerp = math.lerp(1, multiplier, min)
		local num = lerp - arg_233_1.current_lerped_multiplier

		if math.abs(num) > 0.001 then
			var_233_3 = arg_233_1.current_lerped_multiplier
			arg_233_1.current_lerped_multiplier = lerp
			var_233_4 = lerp
		end
	end

	if not var_233_4 then
		if not arg_233_1.has_added_movement_previous_turn then
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
	-- function 234
	if not fn_5() then
		local extension = ScriptUnit.extension(arg_234_0, "buff_system")
		local has_extension = ScriptUnit.has_extension(arg_234_0, "health_system")

		if not extension and not has_extension then
			local unmodified_max_health = has_extension.unmodified_max_health
			local max = math.max(extension:apply_buffs_to_value(unmodified_max_health, "max_health"), 0.25)

			has_extension:set_max_health(max)
		end
	end
end, DLCUtils.merge("buff_function_templates", BuffFunctionTemplates.functions)
