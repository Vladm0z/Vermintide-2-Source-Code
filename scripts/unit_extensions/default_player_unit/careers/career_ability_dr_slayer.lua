-- chunkname: @scripts/unit_extensions/default_player_unit/careers/career_ability_dr_slayer.lua

CareerAbilityDRSlayer = class(CareerAbilityDRSlayer)

local var_0_0 = 2
local var_0_1 = {}

local function var_0_2(arg_1_0, arg_1_1, arg_1_2)
	local var_1_0 = -PlayerUnitMovementSettings.gravity_acceleration
	local var_1_1 = math.degrees_to_radians(45)
	local var_1_2 = 8
	local var_1_3 = Vector3.zero()
	local var_1_4 = 0.1
	local var_1_5, var_1_6 = WeaponHelper.speed_to_hit_moving_target(arg_1_1, arg_1_2, var_1_1, var_1_3, var_1_0, var_1_4)
	local var_1_7, var_1_8, var_1_9 = WeaponHelper.test_angled_trajectory(arg_1_0, arg_1_1, arg_1_2, -var_1_0, var_1_5, var_1_1, var_0_1, var_1_2, nil, true)

	fassert(var_1_7, "no landing location for leap")

	return Vector3.normalize(var_1_8), var_1_5, var_1_6
end

CareerAbilityDRSlayer.init = function (arg_2_0, arg_2_1, arg_2_2, arg_2_3)
	arg_2_0._owner_unit = arg_2_2
	arg_2_0._world = arg_2_1.world
	arg_2_0._wwise_world = Managers.world:wwise_world(arg_2_0._world)

	local var_2_0 = arg_2_3.player

	arg_2_0._player = var_2_0
	arg_2_0._is_server = var_2_0.is_server
	arg_2_0._local_player = var_2_0.local_player
	arg_2_0._bot_player = var_2_0.bot_player
	arg_2_0._network_manager = Managers.state.network
	arg_2_0._input_manager = Managers.input
	arg_2_0._effect_name = "fx/chr_slayer_jump"
	arg_2_0._effect_id = nil
	arg_2_0._is_priming = false
	arg_2_0._last_valid_landing_position = nil
end

CareerAbilityDRSlayer.extensions_ready = function (arg_3_0, arg_3_1, arg_3_2)
	arg_3_0._first_person_extension = ScriptUnit.has_extension(arg_3_2, "first_person_system")
	arg_3_0._status_extension = ScriptUnit.extension(arg_3_2, "status_system")
	arg_3_0._career_extension = ScriptUnit.extension(arg_3_2, "career_system")
	arg_3_0._buff_extension = ScriptUnit.extension(arg_3_2, "buff_system")
	arg_3_0._locomotion_extension = ScriptUnit.extension(arg_3_2, "locomotion_system")
	arg_3_0._input_extension = ScriptUnit.has_extension(arg_3_2, "input_system")
	arg_3_0._talent_extension = ScriptUnit.has_extension(arg_3_2, "talent_system")

	if arg_3_0._first_person_extension then
		arg_3_0._first_person_unit = arg_3_0._first_person_extension:get_first_person_unit()
	end
end

CareerAbilityDRSlayer.destroy = function (arg_4_0)
	return
end

CareerAbilityDRSlayer.update = function (arg_5_0, arg_5_1, arg_5_2, arg_5_3, arg_5_4, arg_5_5)
	local var_5_0 = arg_5_0._input_extension

	if not var_5_0 then
		return
	end

	if not arg_5_0._is_priming then
		if not arg_5_0:_ability_available() then
			return
		end

		if var_5_0:get("action_career") then
			arg_5_0:_start_priming()
		end
	elseif arg_5_0._is_priming then
		local var_5_1, var_5_2, var_5_3 = arg_5_0:_update_priming()

		if var_5_0:get("action_two") or var_5_0:get("jump") or var_5_0:get("jump_only") then
			arg_5_0:_stop_priming()

			return
		end

		if var_5_0:get("weapon_reload") then
			arg_5_0:_stop_priming()

			return
		end

		if var_5_1 and var_5_2 then
			if arg_5_0._last_valid_landing_position then
				arg_5_0._last_valid_landing_position:store(var_5_2)
			else
				arg_5_0._last_valid_landing_position = Vector3Box(var_5_2)
			end
		end

		if not arg_5_0._last_valid_landing_position then
			arg_5_0:_stop_priming()

			return
		end

		if not var_5_0:get("action_career_hold") then
			if var_5_1 and arg_5_0._last_valid_landing_position then
				if var_5_3 <= var_0_0 then
					arg_5_0:_do_stomp(arg_5_5)
				else
					arg_5_0:_do_leap()
				end
			else
				arg_5_0:_stop_priming()
			end
		end
	end
end

CareerAbilityDRSlayer.stop = function (arg_6_0, arg_6_1)
	if arg_6_1 ~= "pushed" and arg_6_1 ~= "stunned" and arg_6_0._is_priming then
		arg_6_0:_stop_priming()
	end
end

CareerAbilityDRSlayer._ability_available = function (arg_7_0)
	local var_7_0 = arg_7_0._career_extension
	local var_7_1 = arg_7_0._status_extension
	local var_7_2 = arg_7_0._locomotion_extension

	return var_7_0:can_use_activated_ability() and not var_7_1:is_disabled() and var_7_2:is_on_ground()
end

CareerAbilityDRSlayer._start_priming = function (arg_8_0)
	if arg_8_0._local_player then
		local var_8_0 = arg_8_0._world
		local var_8_1 = arg_8_0._effect_name

		arg_8_0._effect_id = World.create_particles(var_8_0, var_8_1, Vector3.zero())
	end

	arg_8_0._last_valid_landing_position = nil
	arg_8_0._is_priming = true
end

CareerAbilityDRSlayer._update_priming = function (arg_9_0)
	local var_9_0 = arg_9_0._effect_id
	local var_9_1 = arg_9_0._world
	local var_9_2 = World.get_data(var_9_1, "physics_world")
	local var_9_3 = arg_9_0._first_person_extension
	local var_9_4 = arg_9_0._talent_extension
	local var_9_5 = var_9_3:current_position()
	local var_9_6 = var_9_3:current_rotation()
	local var_9_7 = "filter_slayer_leap"
	local var_9_8 = math.degrees_to_radians(45)
	local var_9_9 = math.degrees_to_radians(12.5)
	local var_9_10 = Quaternion.yaw(var_9_6)
	local var_9_11 = math.clamp(Quaternion.pitch(var_9_6), -var_9_8, var_9_9)
	local var_9_12 = Quaternion(Vector3.up(), var_9_10)
	local var_9_13 = Quaternion(Vector3.right(), var_9_11)
	local var_9_14 = Quaternion.multiply(var_9_12, var_9_13)
	local var_9_15 = Quaternion.forward(var_9_14)
	local var_9_16 = 11

	if var_9_4:has_talent("bardin_slayer_activated_ability_leap_range") then
		var_9_16 = 17
	end

	local var_9_17 = var_9_15 * var_9_16
	local var_9_18 = Vector3(0, 0, -11)
	local var_9_19, var_9_20 = WeaponHelper:ground_target(var_9_2, arg_9_0._owner_unit, var_9_5, var_9_17, var_9_18, var_9_7)
	local var_9_21

	if var_9_19 then
		var_9_21 = Vector3.length(var_9_20 - var_9_5)

		if var_9_0 and var_9_20 then
			World.move_particles(var_9_1, var_9_0, var_9_20)
		end
	else
		var_9_20 = nil
	end

	return var_9_19, var_9_20, var_9_21
end

CareerAbilityDRSlayer._stop_priming = function (arg_10_0)
	if arg_10_0._effect_id then
		World.destroy_particles(arg_10_0._world, arg_10_0._effect_id)

		arg_10_0._effect_id = nil
	end

	arg_10_0._is_priming = false
	arg_10_0._last_valid_landing_position = nil
end

CareerAbilityDRSlayer._do_common_stuff = function (arg_11_0)
	local var_11_0 = arg_11_0._owner_unit
	local var_11_1 = arg_11_0._is_server
	local var_11_2 = arg_11_0._local_player
	local var_11_3 = arg_11_0._bot_player
	local var_11_4 = arg_11_0._network_manager
	local var_11_5 = var_11_4.network_transmit
	local var_11_6 = arg_11_0._career_extension
	local var_11_7 = arg_11_0._talent_extension
	local var_11_8 = {
		"bardin_slayer_activated_ability"
	}

	if var_11_7:has_talent("bardin_slayer_activated_ability_movement") then
		var_11_8[#var_11_8 + 1] = "bardin_slayer_activated_ability_movement"
	end

	local var_11_9 = var_11_4:unit_game_object_id(var_11_0)

	if var_11_1 then
		local var_11_10 = arg_11_0._buff_extension

		for iter_11_0 = 1, #var_11_8 do
			local var_11_11 = var_11_8[iter_11_0]
			local var_11_12 = NetworkLookup.buff_templates[var_11_11]

			var_11_10:add_buff(var_11_11, {
				attacker_unit = var_11_0
			})
			var_11_5:send_rpc_clients("rpc_add_buff", var_11_9, var_11_12, var_11_9, 0, false)
		end
	else
		for iter_11_1 = 1, #var_11_8 do
			local var_11_13 = var_11_8[iter_11_1]
			local var_11_14 = NetworkLookup.buff_templates[var_11_13]

			var_11_5:send_rpc_server("rpc_add_buff", var_11_9, var_11_14, var_11_9, 0, true)
		end
	end

	if var_11_1 and var_11_3 or var_11_2 then
		local var_11_15 = arg_11_0._first_person_extension

		var_11_15:play_hud_sound_event("Play_career_ability_bardin_slayer_enter")
		var_11_15:play_remote_unit_sound_event("Play_career_ability_bardin_slayer_enter", var_11_0, 0)
		var_11_15:play_hud_sound_event("Play_career_ability_bardin_slayer_loop")

		if var_11_2 then
			var_11_6:set_state("bardin_activate_slayer")
			Managers.state.camera:set_mood("skill_slayer", "skill_slayer", true)
		end
	end

	var_11_6:start_activated_ability_cooldown()
	arg_11_0:_play_vo()
end

CareerAbilityDRSlayer._do_stomp = function (arg_12_0, arg_12_1)
	arg_12_0:_stop_priming()

	if not arg_12_0._locomotion_extension:is_on_ground() then
		return
	end

	arg_12_0:_do_common_stuff()

	local var_12_0 = arg_12_0._owner_unit
	local var_12_1 = arg_12_0._local_player
	local var_12_2 = arg_12_0._career_extension
	local var_12_3 = arg_12_0._talent_extension:has_talent("bardin_slayer_activated_ability_impact_damage")
	local var_12_4 = POSITION_LOOKUP[var_12_0]
	local var_12_5 = Quaternion.identity()
	local var_12_6 = var_12_3 and "bardin_slayer_activated_ability_landing_stagger_impact" or "bardin_slayer_activated_ability_landing_stagger"
	local var_12_7 = 1
	local var_12_8 = var_12_2:get_career_power_level() * (var_12_3 and 2 or 1)

	Managers.state.entity:system("area_damage_system"):create_explosion(var_12_0, var_12_4, var_12_5, var_12_6, var_12_7, "career_ability", var_12_8, false)

	if var_12_1 then
		local var_12_9 = arg_12_0._first_person_extension

		var_12_9:play_unit_sound_event("Play_career_ability_bardin_slayer_impact", var_12_0, 0, true)
		var_12_9:play_camera_effect_sequence("leap_stomp", arg_12_1)
	end
end

CareerAbilityDRSlayer._do_leap = function (arg_13_0)
	local var_13_0 = arg_13_0._last_valid_landing_position:unbox()

	arg_13_0:_stop_priming()

	if not arg_13_0._locomotion_extension:is_on_ground() then
		return
	end

	arg_13_0:_do_common_stuff()

	local var_13_1 = arg_13_0._world
	local var_13_2 = arg_13_0._owner_unit
	local var_13_3 = arg_13_0._local_player
	local var_13_4 = arg_13_0._network_manager
	local var_13_5 = var_13_4.network_transmit
	local var_13_6 = arg_13_0._status_extension
	local var_13_7 = arg_13_0._career_extension
	local var_13_8 = arg_13_0._talent_extension

	arg_13_0._locomotion_extension:set_external_velocity_enabled(false)
	var_13_6:reset_move_speed_multiplier()
	var_13_6:set_noclip(true, "skill_slayer")

	if Managers.state.network:game() then
		var_13_6:set_is_dodging(true)

		local var_13_9 = var_13_4:unit_game_object_id(var_13_2)

		var_13_5:send_rpc_server("rpc_status_change_bool", NetworkLookup.statuses.dodging, true, var_13_9, 0)
	end

	local var_13_10 = World.get_data(var_13_1, "physics_world")
	local var_13_11, var_13_12, var_13_13 = var_0_2(var_13_10, POSITION_LOOKUP[var_13_2], var_13_0)
	local var_13_14 = Vector3.distance(POSITION_LOOKUP[var_13_2], var_13_0)
	local var_13_15 = math.clamp(var_13_14 / 10, 0, 1)
	local var_13_16 = var_13_8:has_talent("bardin_slayer_activated_ability_impact_damage")

	var_13_6.do_leap = {
		camera_effect_sequence_start = "jump",
		anim_start_event_3p = "jump_fwd",
		camera_effect_sequence_land = "landed_leap",
		anim_start_event_1p = "slayer_jump_ability",
		move_function = "leap",
		direction = Vector3Box(var_13_11),
		speed = var_13_12,
		initial_vertical_speed = PlayerUnitMovementSettings.leap.jump_speed * var_13_15,
		projected_hit_pos = Vector3Box(var_13_13),
		sfx_event_jump = var_13_3 and "Play_career_ability_bardin_slayer_jump",
		sfx_event_land = var_13_3 and "Play_career_ability_bardin_slayer_impact",
		leap_events = {
			start = function (arg_14_0)
				local var_14_0 = arg_14_0.unit
				local var_14_1 = ScriptUnit.has_extension(var_14_0, "buff_system")

				arg_13_0._uninterruptible_buff_id = var_14_1:add_buff("bardin_slayer_passive_uninterruptible_leap")
			end,
			finished = function (arg_15_0, arg_15_1, arg_15_2)
				local var_15_0 = arg_15_0.unit
				local var_15_1 = arg_15_0.player

				if not arg_15_1 then
					local var_15_2 = Quaternion.identity()
					local var_15_3 = var_13_16 and "bardin_slayer_activated_ability_landing_stagger_impact" or "bardin_slayer_activated_ability_landing_stagger"
					local var_15_4 = 1
					local var_15_5 = var_13_7:get_career_power_level() * (var_13_16 and 2 or 1)

					Managers.state.entity:system("area_damage_system"):create_explosion(var_15_0, arg_15_2, var_15_2, var_15_3, var_15_4, "career_ability", var_15_5, false)
				end

				ScriptUnit.extension(var_15_0, "status_system"):set_noclip(false, "skill_slayer")

				local var_15_6 = Managers.state.network:game()

				if var_15_1 and not var_15_1.remote and var_15_6 then
					ScriptUnit.extension(var_15_0, "status_system"):set_is_dodging(false)

					local var_15_7 = var_13_4:unit_game_object_id(var_15_0)

					var_13_5:send_rpc_server("rpc_status_change_bool", NetworkLookup.statuses.dodging, false, var_15_7, 0)
				end

				local var_15_8 = ScriptUnit.has_extension(var_15_0, "buff_system")

				if arg_13_0._uninterruptible_buff_id then
					var_15_8:remove_buff(arg_13_0._uninterruptible_buff_id)

					arg_13_0._uninterruptible_buff_id = nil
				end
			end
		}
	}
end

CareerAbilityDRSlayer._play_vo = function (arg_16_0)
	local var_16_0 = arg_16_0._owner_unit
	local var_16_1 = ScriptUnit.extension_input(var_16_0, "dialogue_system")
	local var_16_2 = FrameTable.alloc_table()

	var_16_1:trigger_networked_dialogue_event("activate_ability", var_16_2)
end
