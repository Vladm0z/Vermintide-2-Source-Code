-- chunkname: @scripts/unit_extensions/default_player_unit/careers/career_ability_es_knight.lua

CareerAbilityESKnight = class(CareerAbilityESKnight)

CareerAbilityESKnight.init = function (arg_1_0, arg_1_1, arg_1_2, arg_1_3)
	arg_1_0._owner_unit = arg_1_2
	arg_1_0._world = arg_1_1.world
	arg_1_0._wwise_world = Managers.world:wwise_world(arg_1_0._world)

	local var_1_0 = arg_1_3.player

	arg_1_0._player = var_1_0
	arg_1_0._is_server = var_1_0.is_server
	arg_1_0._local_player = var_1_0.local_player
	arg_1_0._bot_player = var_1_0.bot_player
	arg_1_0._network_manager = Managers.state.network
	arg_1_0._input_manager = Managers.input
	arg_1_0._decal_unit = nil
	arg_1_0._decal_unit_name = "units/decals/decal_arrow"
	arg_1_0._fov_lerp_time = 0
	arg_1_0._lunge_events = {
		start = function (arg_2_0)
			local var_2_0 = arg_2_0.first_person_extension
			local var_2_1 = arg_2_0.unit

			var_2_0:play_hud_sound_event("Play_career_ability_kruber_charge_enter")
			var_2_0:play_hud_sound_event("Play_career_ability_kruber_charge_forward")
			var_2_0:play_remote_unit_sound_event("Play_career_ability_kruber_charge_enter", var_2_1, 0)
			var_2_0:play_remote_unit_sound_event("Play_career_ability_kruber_charge_forward", var_2_1, 0)
		end,
		impact = function (arg_3_0)
			local var_3_0 = arg_3_0.first_person_extension
			local var_3_1 = arg_3_0._first_person_unit
			local var_3_2 = arg_3_0.unit
			local var_3_3 = arg_3_0.wwise_world
			local var_3_4 = arg_3_0._num_impacts

			Unit.flow_event(var_3_1, "lua_es_knight_activated_impact")
			WwiseWorld.set_global_parameter(var_3_3, "knight_charge_num_impacts", var_3_4)
			var_3_0:play_hud_sound_event("Play_career_ability_kruber_charge_hit_player")
			var_3_0:play_remote_unit_sound_event("Play_career_ability_kruber_charge_hit_player", var_3_2, 0)
		end,
		finished = function (arg_4_0)
			local var_4_0 = arg_4_0.first_person_extension
			local var_4_1 = arg_4_0.unit

			var_4_0:play_hud_sound_event("Stop_career_ability_kruber_charge_forward")
			var_4_0:play_remote_unit_sound_event("Stop_career_ability_kruber_charge_forward", var_4_1, 0)
		end
	}
end

CareerAbilityESKnight.extensions_ready = function (arg_5_0, arg_5_1, arg_5_2)
	arg_5_0._first_person_extension = ScriptUnit.has_extension(arg_5_2, "first_person_system")
	arg_5_0._status_extension = ScriptUnit.extension(arg_5_2, "status_system")
	arg_5_0._career_extension = ScriptUnit.extension(arg_5_2, "career_system")
	arg_5_0._buff_extension = ScriptUnit.extension(arg_5_2, "buff_system")
	arg_5_0._input_extension = ScriptUnit.has_extension(arg_5_2, "input_system")

	if arg_5_0._first_person_extension then
		arg_5_0._first_person_unit = arg_5_0._first_person_extension:get_first_person_unit()
	end
end

CareerAbilityESKnight.destroy = function (arg_6_0)
	return
end

CareerAbilityESKnight.update = function (arg_7_0, arg_7_1, arg_7_2, arg_7_3, arg_7_4, arg_7_5)
	if not arg_7_0:_ability_available() then
		return
	end

	local var_7_0 = arg_7_0._input_extension

	if not var_7_0 then
		return
	end

	if not arg_7_0._is_priming then
		if var_7_0:get("action_career") then
			arg_7_0:_start_priming()
		end
	elseif arg_7_0._is_priming then
		arg_7_0:_update_priming(arg_7_3)

		if var_7_0:get("action_two") then
			arg_7_0:_stop_priming()

			return
		end

		if var_7_0:get("weapon_reload") then
			arg_7_0:_stop_priming()

			return
		end

		if var_7_0:get("toggle_menu") then
			arg_7_0:_stop_priming()

			return
		end

		if not var_7_0:get("action_career_hold") then
			arg_7_0:_run_ability()
		end
	end
end

CareerAbilityESKnight.stop = function (arg_8_0, arg_8_1)
	if arg_8_1 ~= "pushed" and arg_8_1 ~= "stunned" and arg_8_0._is_priming then
		arg_8_0:_stop_priming()
	end
end

CareerAbilityESKnight._ability_available = function (arg_9_0)
	local var_9_0 = arg_9_0._career_extension
	local var_9_1 = arg_9_0._status_extension

	return var_9_0:can_use_activated_ability() and not var_9_1:is_disabled()
end

CareerAbilityESKnight._start_priming = function (arg_10_0)
	if arg_10_0._local_player then
		local var_10_0 = arg_10_0._decal_unit_name

		arg_10_0._decal_unit = Managers.state.unit_spawner:spawn_local_unit(var_10_0)

		local var_10_1 = "lua_es_knight_activated_start_priming"

		Unit.flow_event(arg_10_0._owner_unit, var_10_1)
		Unit.flow_event(arg_10_0._first_person_unit, var_10_1)
	end

	local var_10_2 = arg_10_0._buff_extension
	local var_10_3 = "planted_decrease_movement"
	local var_10_4 = {
		external_optional_multiplier = 0.3
	}

	arg_10_0._buff_id = var_10_2:add_buff(var_10_3, var_10_4)
	arg_10_0._is_priming = true
end

CareerAbilityESKnight._update_priming = function (arg_11_0, arg_11_1)
	if arg_11_0._decal_unit then
		local var_11_0 = arg_11_0._first_person_extension
		local var_11_1 = Unit.local_position(arg_11_0._owner_unit, 0)
		local var_11_2 = var_11_0:current_rotation()
		local var_11_3 = Vector3.flat(Vector3.normalize(Quaternion.forward(var_11_2)))
		local var_11_4 = Quaternion.look(var_11_3, Vector3.up())

		Unit.set_local_position(arg_11_0._decal_unit, 0, var_11_1)
		Unit.set_local_rotation(arg_11_0._decal_unit, 0, var_11_4)
	end

	if arg_11_0._local_player then
		local var_11_5 = 2.5
		local var_11_6 = arg_11_0._fov_lerp_time / var_11_5
		local var_11_7 = math.lerp(1, 0.95, var_11_6)

		arg_11_0._fov_lerp_time = math.min(arg_11_0._fov_lerp_time + arg_11_1, var_11_5)

		Managers.state.camera:set_additional_fov_multiplier(var_11_7)
	end
end

CareerAbilityESKnight._stop_priming = function (arg_12_0)
	if arg_12_0._decal_unit then
		Managers.state.unit_spawner:mark_for_deletion(arg_12_0._decal_unit)
	end

	if arg_12_0._buff_id then
		arg_12_0._buff_extension:remove_buff(arg_12_0._buff_id)

		arg_12_0._buff_id = nil
	end

	if arg_12_0._local_player then
		local var_12_0 = "lua_es_knight_activated_stop_priming"

		Unit.flow_event(arg_12_0._owner_unit, var_12_0)
		Unit.flow_event(arg_12_0._first_person_unit, var_12_0)

		arg_12_0._fov_lerp_time = 0

		Managers.state.camera:set_additional_fov_multiplier(1)
	end

	arg_12_0._is_priming = false
end

CareerAbilityESKnight._run_ability = function (arg_13_0)
	arg_13_0:_stop_priming()

	local var_13_0 = arg_13_0._owner_unit
	local var_13_1 = arg_13_0._is_server
	local var_13_2 = arg_13_0._status_extension
	local var_13_3 = arg_13_0._career_extension
	local var_13_4 = arg_13_0._buff_extension
	local var_13_5 = ScriptUnit.extension(var_13_0, "talent_system")
	local var_13_6 = arg_13_0._network_manager
	local var_13_7 = var_13_6.network_transmit
	local var_13_8 = var_13_6:unit_game_object_id(var_13_0)
	local var_13_9 = "markus_knight_activated_ability"

	var_13_4:add_buff(var_13_9, {
		attacker_unit = var_13_0
	})

	if var_13_5:has_talent("markus_knight_ability_invulnerability", "empire_soldier", true) then
		local var_13_10 = "markus_knight_ability_invulnerability_buff"

		var_13_4:add_buff(var_13_10, {
			attacker_unit = var_13_0
		})

		local var_13_11 = NetworkLookup.buff_templates[var_13_10]

		if var_13_1 then
			var_13_7:send_rpc_clients("rpc_add_buff", var_13_8, var_13_11, var_13_8, 0, false)
		else
			var_13_7:send_rpc_server("rpc_add_buff", var_13_8, var_13_11, var_13_8, 0, false)
		end
	end

	var_13_2:set_noclip(true, "skill_knight")

	local var_13_12 = 0.03
	local var_13_13 = 0.15

	var_13_2.do_lunge = {
		animation_end_event = "foot_knight_ability_charge_hit",
		allow_rotation = false,
		falloff_to_speed = 5,
		ledge_falloff_immunity = 0.5,
		dodge = true,
		first_person_animation_event = "foot_knight_ability_charge_start",
		first_person_animation_end_event = "foot_knight_ability_charge_hit",
		first_person_hit_animation_event = "charge_react",
		damage_start_time = 0.3,
		duration = 1.5,
		initial_speed = 20,
		animation_event = "foot_knight_ability_charge_start",
		lunge_events = arg_13_0._lunge_events,
		speed_function = function (arg_14_0, arg_14_1)
			local var_14_0 = 0.25
			local var_14_1 = arg_14_0 - var_13_12 - var_13_13
			local var_14_2 = arg_14_1 - var_13_12 - var_13_13 - var_14_0
			local var_14_3 = 0
			local var_14_4 = -3
			local var_14_5 = 20
			local var_14_6 = 15
			local var_14_7 = 2

			if var_14_1 <= 0 and var_13_12 > 0 then
				local var_14_8 = -var_14_1 / (var_13_12 + var_13_13)

				return math.lerp(0, -1, var_14_8)
			elseif var_14_1 < var_13_13 then
				local var_14_9 = var_14_1 / var_13_13
				local var_14_10 = math.cos((var_14_9 + 1) * math.pi * 0.5)

				return math.min(math.lerp(var_14_4, var_14_3, var_14_10), var_14_6)
			elseif var_14_1 < var_14_2 then
				local var_14_11 = var_14_1 / var_14_2
				local var_14_12 = math.min(var_14_1 / (var_14_2 / 3), 1)
				local var_14_13 = math.cos(var_14_11 * math.pi * 0.5)
				local var_14_14
				local var_14_15 = 0.25

				if var_14_1 > 8 * var_14_15 then
					var_14_14 = 0
				elseif var_14_1 > 7 * var_14_15 then
					var_14_14 = (var_14_1 - 1.4) / var_14_15
				elseif var_14_1 > 6 * var_14_15 then
					var_14_14 = (var_14_1 - 6 * var_14_15) / var_14_15
				elseif var_14_1 > 5 * var_14_15 then
					var_14_14 = (var_14_1 - 5 * var_14_15) / var_14_15
				elseif var_14_1 > 4 * var_14_15 then
					var_14_14 = (var_14_1 - 4 * var_14_15) / var_14_15
				elseif var_14_1 > 3 * var_14_15 then
					var_14_14 = (var_14_1 - 3 * var_14_15) / var_14_15
				elseif var_14_1 > 2 * var_14_15 then
					var_14_14 = (var_14_1 - 2 * var_14_15) / var_14_15
				elseif var_14_15 < var_14_1 then
					var_14_14 = (var_14_1 - var_14_15) / var_14_15
				else
					var_14_14 = var_14_1 / var_14_15
				end

				return (1 - var_14_14 * 0.4) * (var_14_12 * var_14_12) * math.lerp(var_14_5, var_14_6, var_14_13)
			else
				local var_14_16 = (var_14_1 - var_14_2) / var_14_0
				local var_14_17 = 1 + math.cos((var_14_16 + 1) * math.pi * 0.5)

				return math.lerp(var_14_7, var_14_5, var_14_17)
			end
		end,
		damage = {
			offset_forward = 2.4,
			height = 1.8,
			depth_padding = 0.6,
			hit_zone_hit_name = "full",
			ignore_shield = false,
			collision_filter = "filter_explosion_overlap_no_player",
			interrupt_on_max_hit_mass = true,
			power_level_multiplier = 1,
			interrupt_on_first_hit = false,
			damage_profile = "markus_knight_charge",
			width = 2,
			allow_backstab = false,
			stagger_angles = {
				max = 80,
				min = 25
			},
			on_interrupt_blast = {
				allow_backstab = false,
				radius = 3,
				power_level_multiplier = 1,
				hit_zone_hit_name = "full",
				damage_profile = "markus_knight_charge_blast",
				ignore_shield = false,
				collision_filter = "filter_explosion_overlap_no_player"
			}
		}
	}

	if var_13_5:has_talent("markus_knight_wide_charge", "empire_soldier", true) then
		var_13_2.do_lunge.damage.width = 5
		var_13_2.do_lunge.damage.interrupt_on_max_hit_mass = false
	end

	var_13_3:start_activated_ability_cooldown()
	arg_13_0:_play_vo()
end

CareerAbilityESKnight._play_vo = function (arg_15_0)
	local var_15_0 = arg_15_0._owner_unit
	local var_15_1 = ScriptUnit.extension_input(var_15_0, "dialogue_system")
	local var_15_2 = FrameTable.alloc_table()

	var_15_1:trigger_networked_dialogue_event("activate_ability", var_15_2)
end
