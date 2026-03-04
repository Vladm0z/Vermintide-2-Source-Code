-- chunkname: @scripts/unit_extensions/default_player_unit/careers/career_ability_rat_ogre_vs.lua

CareerAbilityRatOgreJump = class(CareerAbilityRatOgreJump)

local var_0_0 = math.degrees_to_radians(75)
local var_0_1 = 8
local var_0_2 = 0.1
local var_0_3 = {}

local function var_0_4(arg_1_0, arg_1_1, arg_1_2)
	local var_1_0 = -PlayerUnitMovementSettings.gravity_acceleration
	local var_1_1 = Vector3.zero()
	local var_1_2, var_1_3 = WeaponHelper.speed_to_hit_moving_target(arg_1_1, arg_1_2, var_0_0, var_1_1, var_1_0, var_0_2)
	local var_1_4, var_1_5, var_1_6 = WeaponHelper.test_angled_trajectory(arg_1_0, arg_1_1, arg_1_2, -var_1_0, var_1_2, var_0_0, var_0_3, var_0_1, nil, true)

	fassert(var_1_4, "no landing location for leap")

	return Vector3.normalize(var_1_5), var_1_2, var_1_3
end

CareerAbilityRatOgreJump.init = function (arg_2_0, arg_2_1, arg_2_2, arg_2_3)
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
	arg_2_0._indicator_fx_unit_name = "fx/units/aoe_globadier"
	arg_2_0._indicator_unit = nil
	arg_2_0._is_priming = false
	arg_2_0._last_valid_landing_position = nil
	arg_2_0.stored_valid_pos = false
	arg_2_0._buff_data = {}
end

CareerAbilityRatOgreJump.extensions_ready = function (arg_3_0, arg_3_1, arg_3_2)
	arg_3_0._first_person_extension = ScriptUnit.has_extension(arg_3_2, "first_person_system")
	arg_3_0._status_extension = ScriptUnit.extension(arg_3_2, "status_system")
	arg_3_0._career_extension = ScriptUnit.extension(arg_3_2, "career_system")
	arg_3_0._ability_id = arg_3_0._career_extension:ability_id("ogre_jump")
	arg_3_0._ability_data = arg_3_0._career_extension:get_activated_ability_data(arg_3_0._ability_id)
	arg_3_0._passive_ability_extension = arg_3_0._career_extension:get_passive_ability()
	arg_3_0._ability_input = arg_3_0._ability_data.input_action
	arg_3_0._jump_data = arg_3_0._ability_data.jump_ability_data
	arg_3_0._prime_time = arg_3_0._ability_data.prime_time
	arg_3_0._buff_extension = ScriptUnit.extension(arg_3_2, "buff_system")
	arg_3_0._locomotion_extension = ScriptUnit.extension(arg_3_2, "locomotion_system")
	arg_3_0._input_extension = ScriptUnit.has_extension(arg_3_2, "input_system")
	arg_3_0._inventory_extension = ScriptUnit.extension(arg_3_2, "inventory_system")
	arg_3_0._ghost_mode_extension = ScriptUnit.extension(arg_3_2, "ghost_mode_system")
	arg_3_0._breed = Unit.get_data(arg_3_2, "breed")

	if arg_3_0._first_person_extension then
		arg_3_0._first_person_unit = arg_3_0._first_person_extension:get_first_person_unit()
	end
end

CareerAbilityRatOgreJump.was_triggered = function (arg_4_0)
	local var_4_0 = arg_4_0._input_extension

	if not var_4_0 then
		return false
	end

	if not arg_4_0._is_priming then
		if not arg_4_0:_ability_available() then
			return false
		end

		if var_4_0:get(arg_4_0._ability_input) and not arg_4_0._ghost_mode_extension:is_in_ghost_mode() then
			arg_4_0:_start()

			return true
		end
	end

	return false
end

CareerAbilityRatOgreJump._ability_available = function (arg_5_0)
	local var_5_0 = ScriptUnit.has_extension(arg_5_0._owner_unit, "ghost_mode_system"):is_in_ghost_mode()
	local var_5_1 = arg_5_0._career_extension
	local var_5_2 = arg_5_0._status_extension
	local var_5_3 = arg_5_0._locomotion_extension
	local var_5_4 = var_5_1:can_use_activated_ability()
	local var_5_5 = var_5_2:is_disabled()
	local var_5_6 = var_5_3:is_on_ground()

	return not var_5_0 and var_5_4 and not var_5_5 and var_5_6
end

CareerAbilityRatOgreJump.destroy = function (arg_6_0)
	if arg_6_0._local_player then
		arg_6_0._first_person_extension:play_hud_sound_event("Stop_vs_rat_ogre_jump_charge_vce_1p")
		arg_6_0._first_person_extension:play_remote_unit_sound_event("Stop_vs_rat_ogre_jump_charge_vce_3p", arg_6_0._owner_unit, 0)
	end
end

CareerAbilityRatOgreJump._start = function (arg_7_0)
	local var_7_0, var_7_1, var_7_2 = CharacterStateHelper.get_item_data_and_weapon_extensions(arg_7_0._inventory_extension)

	if var_7_1 then
		var_7_1:stop_action("interrupted")
	end

	arg_7_0._jump_data = arg_7_0._career_extension:get_activated_ability_data(arg_7_0._ability_id).jump_ability_data

	arg_7_0:_start_calculate_leap_position()

	arg_7_0._priming_charged = Managers.time:time("game") + arg_7_0._prime_time

	if arg_7_0._jump_data.priming_buffs then
		arg_7_0:_add_ability_buffs(arg_7_0._jump_data.priming_buffs)
	end

	if arg_7_0._local_player then
		arg_7_0._first_person_extension:play_hud_sound_event("Play_vs_rat_ogre_jump_charge_vce_1p")
		arg_7_0._first_person_extension:play_remote_unit_sound_event("Play_vs_rat_ogre_jump_charge_vce_3p", arg_7_0._owner_unit, 0)
	end

	arg_7_0._first_person_extension:play_animation_event("attack_jump")
	CharacterStateHelper.play_animation_event(arg_7_0._owner_unit, "attack_jump")
end

CareerAbilityRatOgreJump._add_ability_buffs = function (arg_8_0, arg_8_1)
	for iter_8_0 = 1, #arg_8_1 do
		local var_8_0 = arg_8_1[iter_8_0]
		local var_8_1 = var_8_0 and var_8_0.buff_template

		assert(var_8_1, "need a buff_template to add a buff")

		local var_8_2 = {
			external_optional_multiplier = var_8_0 and var_8_0.external_optional_multiplier
		}
		local var_8_3, var_8_4, var_8_5 = arg_8_0._buff_extension:add_buff(var_8_1, var_8_2)

		arg_8_0._buff_data[#arg_8_0._buff_data + 1] = {
			var_8_3,
			var_8_4,
			var_8_5
		}
	end
end

CareerAbilityRatOgreJump._remove_ability_buffs = function (arg_9_0)
	if not arg_9_0._buff_data then
		return
	end

	for iter_9_0 = #arg_9_0._buff_data, 1, -1 do
		local var_9_0 = arg_9_0._buff_data[iter_9_0][1]

		arg_9_0._buff_extension:remove_buff(var_9_0, true)
		table.swap_delete(arg_9_0._buff_data, iter_9_0)
	end
end

CareerAbilityRatOgreJump._update_priming = function (arg_10_0, arg_10_1, arg_10_2, arg_10_3, arg_10_4, arg_10_5)
	if arg_10_5 > arg_10_0._priming_charged and not arg_10_0._done_priming then
		arg_10_0._done_priming = true

		if Managers.player:owner(arg_10_1).local_player then
			arg_10_0._first_person_extension:play_hud_sound_event("Play_vs_rat_ogre_jump_charge_complete")
		end
	else
		local var_10_0 = math.min(arg_10_0._prime_time - (arg_10_0._priming_charged - arg_10_5), arg_10_0._prime_time) / arg_10_0._prime_time

		arg_10_0:_set_priming_progress(var_10_0)
	end
end

CareerAbilityRatOgreJump.update = function (arg_11_0, arg_11_1, arg_11_2, arg_11_3, arg_11_4, arg_11_5)
	local var_11_0 = arg_11_0._input_extension

	if not var_11_0 then
		return
	end

	local var_11_1 = arg_11_0:was_triggered()

	if CharacterStateHelper.is_staggered(arg_11_0._status_extension) and arg_11_0._is_priming then
		arg_11_0._career_extension:stop_ability("staggered")

		return
	end

	if arg_11_0._is_priming then
		if var_11_0:get("dark_pact_action_one") or var_11_0:get("jump") or var_11_0:get("jump_only") or var_11_0:get("dark_pact_reload") or var_11_0:get("dark_pact_action_two_release") and not arg_11_0._done_priming or not var_11_0:get("dark_pact_action_two_hold") and not arg_11_0._done_priming or arg_11_0._status_extension:is_climbing() then
			arg_11_0._career_extension:stop_ability("aborted")
			arg_11_0._career_extension:start_activated_ability_cooldown(arg_11_0._ability_id, 1)
			arg_11_0._network_manager:anim_event(arg_11_1, "interrupt")
			CharacterStateHelper.play_animation_event_first_person(arg_11_0._first_person_extension, "interrupt")

			return
		end

		arg_11_0:_update_priming(arg_11_1, arg_11_2, arg_11_3, arg_11_4, arg_11_5)

		local var_11_2, var_11_3, var_11_4 = arg_11_0:_calculate_leap_position()

		if var_11_2 and var_11_3 then
			local var_11_5 = POSITION_LOOKUP[arg_11_1]
			local var_11_6 = arg_11_0._jump_data.min_jump_dist
			local var_11_7 = not arg_11_0._last_valid_landing_position

			if not arg_11_0.stored_valid_pos and var_11_6 <= var_11_4 then
				arg_11_0.stored_valid_pos = true
			end

			local var_11_8 = arg_11_0._last_valid_landing_position and not arg_11_0.stored_valid_pos
			local var_11_9 = arg_11_0._last_valid_landing_position and var_11_6 <= var_11_4

			if var_11_7 then
				arg_11_0._last_valid_landing_position = Vector3Box(var_11_3)

				arg_11_0:_handel_hit_indicator(var_11_3)
			elseif var_11_9 then
				arg_11_0._last_valid_landing_position:store(var_11_3)
				arg_11_0:_handel_hit_indicator(var_11_3)
			elseif not arg_11_0.stored_valid_pos and var_11_8 then
				arg_11_0._last_valid_landing_position:store(var_11_3)
				arg_11_0:_handel_hit_indicator(var_11_3)
			end
		end

		if not arg_11_0._last_valid_landing_position then
			arg_11_0._career_extension:stop_ability("aborted")

			return
		end

		if var_11_0:get("dark_pact_action_two_release") and arg_11_0._done_priming then
			if var_11_2 and arg_11_0._last_valid_landing_position then
				arg_11_0:_set_priming_progress(0)
				arg_11_0:_do_leap()
			else
				arg_11_0:_stop_priming()
			end
		end
	end
end

CareerAbilityRatOgreJump.stop = function (arg_12_0, arg_12_1)
	if arg_12_0._is_priming then
		arg_12_0:_stop_priming()
	end

	if arg_12_1 == "aborted" then
		arg_12_0._network_manager:anim_event(arg_12_0._owner_unit, "cancel_priming")
	end

	if arg_12_1 == "staggered" then
		arg_12_0._career_extension:start_activated_ability_cooldown(arg_12_0._ability_id, 1)
	end

	arg_12_0:stop_passive_ability()

	local var_12_0, var_12_1, var_12_2 = CharacterStateHelper.get_item_data_and_weapon_extensions(arg_12_0._inventory_extension)

	if var_12_1 then
		var_12_1:stop_action("interrupted")
	end
end

CareerAbilityRatOgreJump._start_calculate_leap_position = function (arg_13_0)
	arg_13_0._last_valid_landing_position = nil
	arg_13_0._done_priming = false
	arg_13_0._is_priming = true
	arg_13_0._ability_data.is_priming = true
end

CareerAbilityRatOgreJump._destroy_indicator_unit = function (arg_14_0)
	if Unit.alive(arg_14_0._indicator_unit) then
		World.destroy_unit(arg_14_0._world, arg_14_0._indicator_unit)

		arg_14_0._indicator_unit = nil
	end
end

CareerAbilityRatOgreJump._handel_hit_indicator = function (arg_15_0, arg_15_1)
	local var_15_0 = arg_15_0._indicator_fx_unit_name

	if arg_15_1 then
		if arg_15_0._indicator_unit then
			Unit.set_local_position(arg_15_0._indicator_unit, 0, arg_15_1)
		else
			arg_15_0._indicator_unit = World.spawn_unit(arg_15_0._world, var_15_0, arg_15_1)

			local var_15_1 = arg_15_0._jump_data.hit_indicator_raidus

			Unit.set_local_scale(arg_15_0._indicator_unit, 0, Vector3(var_15_1, var_15_1, var_15_1))
		end
	else
		arg_15_0:_destroy_indicator_unit()
	end
end

CareerAbilityRatOgreJump._calculate_leap_position = function (arg_16_0)
	local var_16_0 = arg_16_0._world
	local var_16_1 = World.get_data(var_16_0, "physics_world")
	local var_16_2 = arg_16_0._first_person_extension
	local var_16_3 = var_16_2:current_position()
	local var_16_4 = var_16_2:current_rotation()
	local var_16_5 = math.degrees_to_radians(arg_16_0._jump_data.min_pitch)
	local var_16_6 = math.degrees_to_radians(arg_16_0._jump_data.max_pitch)
	local var_16_7 = Quaternion.yaw(var_16_4)
	local var_16_8 = math.clamp(Quaternion.pitch(var_16_4), -var_16_5, var_16_6)
	local var_16_9 = Quaternion(Vector3.up(), var_16_7)
	local var_16_10 = Quaternion(Vector3.right(), var_16_8)
	local var_16_11 = Quaternion.multiply(var_16_9, var_16_10)
	local var_16_12 = Quaternion.forward(var_16_11)
	local var_16_13 = arg_16_0._jump_data.movement_settings.jump_speed
	local var_16_14 = (Vector3.up() * 0.3 + var_16_12) * var_16_13
	local var_16_15 = Vector3(0, 0, -11)
	local var_16_16 = "filter_player_enemy_leap_state_noclip_mover"
	local var_16_17, var_16_18 = arg_16_0:get_landing_position(var_16_1, arg_16_0._owner_unit, var_16_3, var_16_14, var_16_15, var_16_16)
	local var_16_19

	if var_16_17 then
		var_16_19 = Vector3.length(var_16_18 - var_16_3)
	end

	return var_16_17, var_16_18, var_16_19
end

CareerAbilityRatOgreJump._stop_priming = function (arg_17_0)
	arg_17_0:_destroy_indicator_unit()
	arg_17_0:_set_priming_progress(0)

	if arg_17_0._local_player then
		arg_17_0._first_person_extension:play_hud_sound_event("Stop_vs_rat_ogre_jump_charge_vce_1p")
		arg_17_0._first_person_extension:play_remote_unit_sound_event("Stop_vs_rat_ogre_jump_charge_vce_3p", arg_17_0._owner_unit, 0)
	end

	arg_17_0._is_priming = false
	arg_17_0._ability_data.is_priming = false
	arg_17_0._last_valid_landing_position = nil

	arg_17_0:_remove_ability_buffs()

	arg_17_0.stored_valid_pos = false
end

CareerAbilityRatOgreJump._do_common_stuff = function (arg_18_0)
	local var_18_0 = arg_18_0._owner_unit
	local var_18_1 = arg_18_0._is_server
	local var_18_2 = arg_18_0._local_player
	local var_18_3 = arg_18_0._bot_player
	local var_18_4 = arg_18_0._career_extension

	if var_18_1 and var_18_3 or var_18_2 then
		local var_18_5 = arg_18_0._first_person_extension

		var_18_5:play_hud_sound_event("Play_vs_rat_ogre_jump_1p")
		var_18_5:play_remote_unit_sound_event("Play_vs_rat_ogre_jump_3p", var_18_0, 0)
	end

	var_18_4:start_activated_ability_cooldown(arg_18_0._ability_id)
end

CareerAbilityRatOgreJump._do_leap = function (arg_19_0)
	local var_19_0 = arg_19_0._last_valid_landing_position:unbox()

	arg_19_0:_stop_priming()

	if not arg_19_0._locomotion_extension:is_on_ground() then
		return
	end

	arg_19_0:_do_common_stuff()

	local var_19_1 = arg_19_0._world
	local var_19_2 = arg_19_0._owner_unit
	local var_19_3 = arg_19_0._status_extension

	arg_19_0._locomotion_extension:set_external_velocity_enabled(false)
	var_19_3:reset_move_speed_multiplier()

	local var_19_4 = World.get_data(var_19_1, "physics_world")
	local var_19_5 = POSITION_LOOKUP[var_19_2]
	local var_19_6, var_19_7, var_19_8 = var_0_4(var_19_4, var_19_5, var_19_0)
	local var_19_9 = Vector3.distance(var_19_5, var_19_0)
	local var_19_10 = arg_19_0._jump_data.lerp_data
	local var_19_11 = arg_19_0._jump_data.movement_settings
	local var_19_12 = var_19_10 and var_19_10.zero_distance
	local var_19_13 = var_19_10 and var_19_10.start_accel_distance
	local var_19_14 = var_19_10 and var_19_10.end_accel_distance
	local var_19_15 = var_19_10 and var_19_10.glide_distance
	local var_19_16 = var_19_10 and var_19_10.slow_distance
	local var_19_17 = var_19_10 and var_19_10.full_distance
	local var_19_18 = var_19_11 and var_19_11.jump_speed

	var_19_3.do_leap = {
		camera_effect_sequence_start = "jump",
		move_function = "leap",
		camera_effect_sequence_land = "landed_leap",
		direction = Vector3Box(var_19_6),
		speed = var_19_18,
		projected_hit_pos = Vector3Box(var_19_8),
		lerp_data = {
			zero_distance = var_19_12 or 0,
			start_accel_distance = var_19_13 or 0.1,
			end_accel_distance = var_19_14 or 0.2,
			glide_distance = var_19_15 or 0.5,
			slow_distance = var_19_16 or 0.7,
			full_distance = var_19_17 or 1
		},
		movement_settings = var_19_11,
		leap_events = {
			start = function (arg_20_0, arg_20_1)
				arg_20_0._start_leap_buff_id = Managers.state.entity:system("buff_system"):add_buff_synced(arg_20_1, "vs_rat_ogre_start_leap_stagger_immune", BuffSyncType.ClientAndServer, nil, Network.peer_id())

				if not arg_20_0._screenspace_effect_id then
					local var_20_0 = arg_20_0._leap_data.total_distance
					local var_20_1 = 50
					local var_20_2 = math.inv_lerp_clamped(0, var_20_1, var_20_0)
					local var_20_3 = "fx/speedlines_01_1p"

					arg_20_0._screenspace_effect_id = arg_20_0._first_person_extension:create_screen_particles(var_20_3)

					ScriptWorld.set_material_variable_for_particles(var_19_1, arg_20_0._screenspace_effect_id, "distort_burst", "distortion_strength", var_20_2)
					ScriptWorld.set_material_variable_for_particles(var_19_1, arg_20_0._screenspace_effect_id, "distort_loop", "distortion_strength", var_20_2)
				end
			end,
			finished = function (arg_21_0, arg_21_1, arg_21_2, arg_21_3)
				local var_21_0 = Managers.state.entity:system("buff_system")

				var_21_0:remove_buff_synced(arg_21_1, arg_21_0._start_leap_buff_id)
				var_21_0:add_buff_synced(arg_21_1, "vs_rat_ogre_finish_leap_stagger_immune", BuffSyncType.ClientAndServer, nil, Network.peer_id())

				if arg_21_0._screenspace_effect_id then
					World.destroy_particles(arg_21_0._world, arg_21_0._screenspace_effect_id)

					arg_21_0._screenspace_effect_id = nil
				end

				if not arg_21_2 then
					if arg_21_0._leap_data.anim_finish_event_1p then
						CharacterStateHelper.play_animation_event_first_person(arg_21_0._first_person_extension, arg_21_0._leap_data.anim_finish_event_1p)
					end

					if arg_21_0._leap_data.anim_finish_event_3p then
						CharacterStateHelper.play_animation_event(arg_21_1, arg_21_0._leap_data.anim_finish_event_3p)
					end

					local var_21_1 = Quaternion.identity()
					local var_21_2 = "vs_rat_ogre_leap_landing"
					local var_21_3 = 1
					local var_21_4 = 50

					Managers.state.entity:system("area_damage_system"):create_explosion(arg_21_1, arg_21_3, var_21_1, var_21_2, var_21_3, "vs_rat_ogre_hands", var_21_4, false)
				end

				local var_21_5, var_21_6, var_21_7 = CharacterStateHelper.get_item_data_and_weapon_extensions(arg_21_0._inventory_extension)

				var_21_6:stop_action("interrupted")
				arg_19_0._career_extension:stop_ability()
			end
		}
	}

	arg_19_0._passive_ability_extension:start_leap(var_19_5, var_19_0, var_19_9)
end

CareerAbilityRatOgreJump.stop_passive_ability = function (arg_22_0)
	arg_22_0._passive_ability_extension:stop_leap()
end

CareerAbilityRatOgreJump._play_vo = function (arg_23_0)
	local var_23_0 = arg_23_0._owner_unit
	local var_23_1 = ScriptUnit.extension_input(var_23_0, "dialogue_system")
	local var_23_2 = FrameTable.alloc_table()

	var_23_1:trigger_networked_dialogue_event("activate_ability", var_23_2)
end

local var_0_5 = 30
local var_0_6 = 3
local var_0_7 = 0.0001
local var_0_8 = 10

CareerAbilityRatOgreJump.get_landing_position = function (arg_24_0, arg_24_1, arg_24_2, arg_24_3, arg_24_4, arg_24_5, arg_24_6)
	local var_24_0 = var_0_6 / var_0_5
	local var_24_1 = arg_24_3
	local var_24_2 = Unit.mover(arg_24_2)
	local var_24_3 = Mover.radius(var_24_2)
	local var_24_4 = Vector3(0, 0, 0.1)

	for iter_24_0 = 1, var_0_5 do
		local var_24_5 = var_24_1 + arg_24_4 * var_24_0
		local var_24_6 = var_24_5 - var_24_1
		local var_24_7 = Vector3.normalize(var_24_6)
		local var_24_8 = Vector3.length(var_24_6)
		local var_24_9 = PhysicsWorld.linear_sphere_sweep(arg_24_1, var_24_1, var_24_5, var_24_3, var_0_8, "collision_filter", arg_24_6)

		if var_24_9 then
			local var_24_10 = var_24_9[1]
			local var_24_11 = var_24_10.position
			local var_24_12 = var_24_10.normal
			local var_24_13 = true
			local var_24_14 = Vector3.dot(var_24_12, Vector3.up()) < 0.95

			if not var_24_14 then
				local var_24_15, var_24_16 = Unit.mover_fits_at(arg_24_2, "standing", var_24_11 + var_24_4, 1)

				if var_24_15 then
					var_24_11 = var_24_16
				else
					var_24_13 = false
				end
			end

			if var_24_14 or not var_24_13 then
				local var_24_17 = Vector3.length(Vector3.flat(arg_24_4))

				for iter_24_1 = 1, var_0_5 do
					local var_24_18 = iter_24_1 == 1 and 0.5 or 1
					local var_24_19 = var_24_17 <= var_0_7 and 0 or var_24_18 / var_24_17
					local var_24_20

					if var_24_19 > 0 then
						var_24_20 = var_24_11 - arg_24_4 * var_24_19 - arg_24_5 * (var_24_19 * var_24_19 * 0.5)
					else
						var_24_20 = arg_24_3
					end

					local var_24_21, var_24_22, var_24_23, var_24_24, var_24_25 = PhysicsWorld.immediate_raycast(arg_24_1, var_24_20, Vector3.down(), 10, "closest", "collision_filter", arg_24_6)

					if var_24_21 then
						local var_24_26, var_24_27 = Unit.mover_fits_at(arg_24_2, "standing", var_24_22 + var_24_4, 1)

						if var_24_26 then
							local var_24_28 = var_24_27

							return true, var_24_28
						else
							var_24_11 = var_24_20
						end
					end
				end
			end

			return true, var_24_11
		end

		arg_24_4 = arg_24_4 + arg_24_5 * var_24_0
		var_24_1 = var_24_5
	end

	return false, var_24_1
end

CareerAbilityRatOgreJump._set_priming_progress = function (arg_25_0, arg_25_1)
	arg_25_0._career_extension:get_activated_ability_data(arg_25_0._ability_id).priming_progress = arg_25_1
end
