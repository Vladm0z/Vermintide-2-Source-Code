-- chunkname: @scripts/unit_extensions/default_player_unit/careers/career_ability_wh_zealot.lua

CareerAbilityWHZealot = class(CareerAbilityWHZealot)

CareerAbilityWHZealot.init = function (arg_1_0, arg_1_1, arg_1_2, arg_1_3)
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
	arg_1_0._decal_unit_name = "units/decals/decal_arrow_saltzpyre"
	arg_1_0._fov_lerp_time = 0
end

CareerAbilityWHZealot.extensions_ready = function (arg_2_0, arg_2_1, arg_2_2)
	arg_2_0._first_person_extension = ScriptUnit.has_extension(arg_2_2, "first_person_system")
	arg_2_0._status_extension = ScriptUnit.extension(arg_2_2, "status_system")
	arg_2_0._career_extension = ScriptUnit.extension(arg_2_2, "career_system")
	arg_2_0._buff_extension = ScriptUnit.extension(arg_2_2, "buff_system")
	arg_2_0._input_extension = ScriptUnit.has_extension(arg_2_2, "input_system")

	if arg_2_0._first_person_extension then
		arg_2_0._first_person_unit = arg_2_0._first_person_extension:get_first_person_unit()
	end
end

CareerAbilityWHZealot.destroy = function (arg_3_0)
	return
end

CareerAbilityWHZealot.update = function (arg_4_0, arg_4_1, arg_4_2, arg_4_3, arg_4_4, arg_4_5)
	if not arg_4_0:_ability_available() then
		return
	end

	local var_4_0 = arg_4_0._input_extension

	if not var_4_0 then
		return
	end

	if not arg_4_0._is_priming then
		if var_4_0:get("action_career") then
			arg_4_0:_start_priming()
		end
	elseif arg_4_0._is_priming then
		arg_4_0:_update_priming(arg_4_3)

		if var_4_0:get("action_two") then
			arg_4_0:_stop_priming()

			return
		end

		if var_4_0:get("weapon_reload") then
			arg_4_0:_stop_priming()

			return
		end

		if not var_4_0:get("action_career_hold") then
			arg_4_0:_run_ability()
		end
	end
end

CareerAbilityWHZealot.stop = function (arg_5_0, arg_5_1)
	if arg_5_1 ~= "pushed" and arg_5_1 ~= "stunned" and arg_5_0._is_priming then
		arg_5_0:_stop_priming()
	end
end

CareerAbilityWHZealot._ability_available = function (arg_6_0)
	local var_6_0 = arg_6_0._career_extension
	local var_6_1 = arg_6_0._status_extension

	return var_6_0:can_use_activated_ability() and not var_6_1:is_disabled()
end

CareerAbilityWHZealot._start_priming = function (arg_7_0)
	if arg_7_0._local_player then
		local var_7_0 = arg_7_0._decal_unit_name

		arg_7_0._decal_unit = Managers.state.unit_spawner:spawn_local_unit(var_7_0)
	end

	local var_7_1 = arg_7_0._buff_extension
	local var_7_2 = "planted_decrease_movement"
	local var_7_3 = {
		external_optional_multiplier = 0.3
	}

	arg_7_0._buff_id = var_7_1:add_buff(var_7_2, var_7_3)
	arg_7_0._is_priming = true
end

CareerAbilityWHZealot._update_priming = function (arg_8_0, arg_8_1)
	if arg_8_0._local_player then
		local var_8_0 = arg_8_0._first_person_extension
		local var_8_1 = Unit.local_position(arg_8_0._owner_unit, 0)
		local var_8_2 = var_8_0:current_rotation()
		local var_8_3 = Vector3.flat(Vector3.normalize(Quaternion.forward(var_8_2)))
		local var_8_4 = Quaternion.look(var_8_3, Vector3.up())

		Unit.set_local_position(arg_8_0._decal_unit, 0, var_8_1)
		Unit.set_local_rotation(arg_8_0._decal_unit, 0, var_8_4)

		local var_8_5 = 1.9
		local var_8_6 = arg_8_0._fov_lerp_time / var_8_5
		local var_8_7 = math.lerp(1, 1.07, var_8_6)

		arg_8_0._fov_lerp_time = math.min(arg_8_0._fov_lerp_time + arg_8_1, var_8_5)

		Managers.state.camera:set_additional_fov_multiplier(var_8_7)
	end
end

CareerAbilityWHZealot._stop_priming = function (arg_9_0)
	if arg_9_0._decal_unit then
		Managers.state.unit_spawner:mark_for_deletion(arg_9_0._decal_unit)
	end

	if arg_9_0._buff_id then
		arg_9_0._buff_extension:remove_buff(arg_9_0._buff_id)

		arg_9_0._buff_id = nil
	end

	if arg_9_0._local_player then
		arg_9_0._fov_lerp_time = 0

		Managers.state.camera:set_additional_fov_multiplier(1)
	end

	arg_9_0._is_priming = false
end

CareerAbilityWHZealot._run_ability = function (arg_10_0)
	arg_10_0:_stop_priming()

	local var_10_0 = arg_10_0._owner_unit
	local var_10_1 = arg_10_0._is_server
	local var_10_2 = arg_10_0._local_player
	local var_10_3 = arg_10_0._network_manager
	local var_10_4 = var_10_3.network_transmit
	local var_10_5 = arg_10_0._status_extension
	local var_10_6 = arg_10_0._career_extension
	local var_10_7 = arg_10_0._buff_extension
	local var_10_8 = {
		"victor_zealot_activated_ability"
	}
	local var_10_9 = ScriptUnit.extension(var_10_0, "talent_system")

	if var_10_9:has_talent("victor_zealot_activated_ability_power_on_hit", "witch_hunter", true) then
		var_10_8[#var_10_8 + 1] = "victor_zealot_activated_ability_power_on_hit"
	end

	if var_10_9:has_talent("victor_zealot_activated_ability_ignore_death", "witch_hunter", true) then
		var_10_8[#var_10_8 + 1] = "victor_zealot_activated_ability_ignore_death"
	end

	if var_10_9:has_talent("victor_zealot_activated_ability_cooldown_stack_on_hit", "witch_hunter", true) then
		var_10_7:add_buff("victor_zealot_activated_ability_cooldown_stack_on_hit", {
			attacker_unit = var_10_0
		})
	end

	for iter_10_0 = 1, #var_10_8 do
		local var_10_10 = var_10_8[iter_10_0]
		local var_10_11 = var_10_3:unit_game_object_id(var_10_0)
		local var_10_12 = NetworkLookup.buff_templates[var_10_10]

		if var_10_1 then
			var_10_7:add_buff(var_10_10, {
				attacker_unit = var_10_0
			})
			var_10_4:send_rpc_clients("rpc_add_buff", var_10_11, var_10_12, var_10_11, 0, false)
		else
			var_10_4:send_rpc_server("rpc_add_buff", var_10_11, var_10_12, var_10_11, 0, true)
		end
	end

	if var_10_2 or var_10_1 and arg_10_0._bot_player then
		local var_10_13 = arg_10_0._first_person_extension

		var_10_13:play_hud_sound_event("Play_career_ability_victor_zealot_enter")
		var_10_13:play_remote_unit_sound_event("Play_career_ability_victor_zealot_enter", var_10_0, 0)
		var_10_13:play_hud_sound_event("Play_career_ability_victor_zealot_loop")

		if var_10_2 then
			var_10_13:animation_event("shade_stealth_ability")
			var_10_13:play_hud_sound_event("Play_career_ability_zealot_charge")
			var_10_13:play_remote_unit_sound_event("Play_career_ability_zealot_charge", var_10_0, 0)
			var_10_6:set_state("victor_activate_zealot")
			Managers.state.camera:set_mood("skill_zealot", "skill_zealot", true)
		end
	end

	var_10_5:set_noclip(true, "skill_zealot")

	var_10_5.do_lunge = {
		animation_end_event = "zealot_active_ability_charge_hit",
		allow_rotation = false,
		first_person_animation_end_event = "dodge_bwd",
		first_person_hit_animation_event = "charge_react",
		falloff_to_speed = 8,
		dodge = true,
		first_person_animation_event = "shade_stealth_ability",
		first_person_animation_end_event_hit = "dodge_bwd",
		duration = 0.75,
		initial_speed = 25,
		animation_event = "zealot_active_ability_charge_start",
		damage = {
			depth_padding = 0.4,
			height = 1.8,
			collision_filter = "filter_explosion_overlap_no_player",
			hit_zone_hit_name = "full",
			ignore_shield = true,
			interrupt_on_max_hit_mass = true,
			power_level_multiplier = 0.8,
			interrupt_on_first_hit = false,
			damage_profile = "heavy_slashing_linesman",
			width = 1.5,
			allow_backstab = true,
			stagger_angles = {
				max = 90,
				min = 45
			},
			on_interrupt_blast = {
				allow_backstab = false,
				radius = 3,
				power_level_multiplier = 1,
				hit_zone_hit_name = "full",
				damage_profile = "heavy_slashing_linesman",
				ignore_shield = false,
				collision_filter = "filter_explosion_overlap_no_player"
			}
		}
	}

	var_10_6:start_activated_ability_cooldown()
	arg_10_0:_play_vo()
end

CareerAbilityWHZealot._play_vo = function (arg_11_0)
	local var_11_0 = arg_11_0._owner_unit
	local var_11_1 = ScriptUnit.extension_input(var_11_0, "dialogue_system")
	local var_11_2 = FrameTable.alloc_table()

	var_11_1:trigger_networked_dialogue_event("activate_ability", var_11_2)
end
