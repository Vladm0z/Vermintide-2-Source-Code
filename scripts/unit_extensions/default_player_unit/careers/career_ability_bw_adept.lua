-- chunkname: @scripts/unit_extensions/default_player_unit/careers/career_ability_bw_adept.lua

CareerAbilityBWAdept = class(CareerAbilityBWAdept)

local var_0_0 = 0.01
local var_0_1 = {}

local function var_0_2(arg_1_0, arg_1_1, arg_1_2)
	if Vector3.length(Vector3.flat(arg_1_1 - arg_1_2)) < var_0_0 then
		return Vector3.zero(), 0, arg_1_1
	end

	local var_1_0 = PlayerUnitMovementSettings.gravity_acceleration
	local var_1_1 = math.degrees_to_radians(45)
	local var_1_2 = 8
	local var_1_3 = Vector3.zero()
	local var_1_4 = 0.1
	local var_1_5, var_1_6 = WeaponHelper.speed_to_hit_moving_target(arg_1_1, arg_1_2, var_1_1, var_1_3, var_1_0, var_1_4)
	local var_1_7, var_1_8, var_1_9 = WeaponHelper.test_angled_trajectory(arg_1_0, arg_1_1, arg_1_2, -var_1_0, var_1_5, var_1_1, var_0_1, var_1_2, nil, true)

	fassert(var_1_7, "no landing location for leap")

	return Vector3.normalize(var_1_8), var_1_5, var_1_6
end

function CareerAbilityBWAdept.init(arg_2_0, arg_2_1, arg_2_2, arg_2_3)
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
	arg_2_0._effect_name = "fx/wpnfx_staff_geiser_charge"
	arg_2_0._effect_id = nil
	arg_2_0._double_ability_buff_id = nil
end

function CareerAbilityBWAdept.extensions_ready(arg_3_0, arg_3_1, arg_3_2)
	arg_3_0._first_person_extension = ScriptUnit.has_extension(arg_3_2, "first_person_system")
	arg_3_0._status_extension = ScriptUnit.extension(arg_3_2, "status_system")
	arg_3_0._career_extension = ScriptUnit.extension(arg_3_2, "career_system")
	arg_3_0._buff_extension = ScriptUnit.extension(arg_3_2, "buff_system")
	arg_3_0._locomotion_extension = ScriptUnit.extension(arg_3_2, "locomotion_system")
	arg_3_0._input_extension = ScriptUnit.has_extension(arg_3_2, "input_system")
	arg_3_0._talent_extension = ScriptUnit.has_extension(arg_3_2, "talent_system")

	if arg_3_0._first_person_extension then
		arg_3_0.first_person_unit = arg_3_0._first_person_extension:get_first_person_unit()
	end
end

function CareerAbilityBWAdept.destroy(arg_4_0)
	return
end

local var_0_3 = "career_ability_bw_adept"

function CareerAbilityBWAdept.update(arg_5_0, arg_5_1, arg_5_2, arg_5_3, arg_5_4, arg_5_5)
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
		local var_5_1 = arg_5_0:_update_priming(arg_5_3, arg_5_5)

		if var_5_0:get("action_two") or var_5_0:get("jump") or var_5_0:get("jump_only") then
			arg_5_0:_stop_priming()

			return
		end

		if var_5_0:get("weapon_reload") then
			arg_5_0:_stop_priming()

			return
		end

		if var_5_1 then
			if arg_5_0._last_valid_landing_position then
				arg_5_0._last_valid_landing_position:store(var_5_1)
			else
				arg_5_0._last_valid_landing_position = Vector3Box(var_5_1)
			end
		end

		if not arg_5_0._last_valid_landing_position then
			arg_5_0:_stop_priming()

			return
		end

		if arg_5_0._last_valid_landing_position and not var_5_0:get("action_career_hold") then
			arg_5_0:_run_ability()
		end
	end
end

function CareerAbilityBWAdept.stop(arg_6_0, arg_6_1)
	if arg_6_1 ~= "pushed" and arg_6_1 ~= "stunned" and arg_6_0._is_priming then
		arg_6_0:_stop_priming()
	end
end

function CareerAbilityBWAdept._ability_available(arg_7_0)
	local var_7_0 = arg_7_0._career_extension
	local var_7_1 = arg_7_0._status_extension
	local var_7_2 = arg_7_0._locomotion_extension
	local var_7_3 = var_7_0:can_use_activated_ability()
	local var_7_4 = var_7_1:is_disabled()
	local var_7_5 = var_7_1:is_overcharge_exploding()
	local var_7_6 = var_7_2:is_on_ground()

	return var_7_3 and not var_7_4 and not var_7_5 and var_7_6
end

function CareerAbilityBWAdept._start_priming(arg_8_0)
	if arg_8_0._local_player then
		local var_8_0 = arg_8_0._world
		local var_8_1 = arg_8_0._effect_name

		arg_8_0._effect_id = World.create_particles(var_8_0, var_8_1, Vector3.zero())
	end

	arg_8_0._last_valid_landing_position = nil
	arg_8_0._is_priming = true
end

function CareerAbilityBWAdept._update_priming(arg_9_0, arg_9_1, arg_9_2)
	local var_9_0 = arg_9_0._effect_id
	local var_9_1 = arg_9_0._world
	local var_9_2 = World.get_data(var_9_1, "physics_world")
	local var_9_3 = arg_9_0._first_person_extension
	local var_9_4 = var_9_3:current_position()
	local var_9_5 = var_9_3:current_rotation()
	local var_9_6 = "filter_adept_teleport"
	local var_9_7 = math.degrees_to_radians(45)
	local var_9_8 = math.degrees_to_radians(12.5)
	local var_9_9 = Quaternion.yaw(var_9_5)
	local var_9_10 = math.clamp(Quaternion.pitch(var_9_5), -var_9_7, var_9_8)
	local var_9_11 = Quaternion(Vector3.up(), var_9_9)
	local var_9_12 = Quaternion(Vector3.right(), var_9_10)
	local var_9_13 = Quaternion.multiply(var_9_11, var_9_12)
	local var_9_14 = Quaternion.forward(var_9_13)
	local var_9_15 = ScriptUnit.has_extension(arg_9_0._owner_unit, "talent_system")
	local var_9_16 = 11

	if var_9_15:has_talent("sienna_adept_activated_ability_distance") then
		var_9_16 = 17
	end

	local var_9_17 = var_9_14 * var_9_16
	local var_9_18 = Vector3(0, 0, -11)
	local var_9_19, var_9_20 = WeaponHelper:ground_target(var_9_2, arg_9_0._owner_unit, var_9_4, var_9_17, var_9_18, var_9_6)

	if not var_9_19 then
		var_9_20 = nil
	end

	if var_9_0 and var_9_20 then
		World.move_particles(var_9_1, var_9_0, var_9_20)
	end

	return var_9_20
end

function CareerAbilityBWAdept._stop_priming(arg_10_0)
	if arg_10_0._effect_id then
		World.destroy_particles(arg_10_0._world, arg_10_0._effect_id)

		arg_10_0._effect_id = nil
	end

	arg_10_0._is_priming = false
	arg_10_0._last_valid_landing_position = nil
end

function CareerAbilityBWAdept._run_ability(arg_11_0)
	local var_11_0 = arg_11_0._last_valid_landing_position:unbox()

	arg_11_0:_stop_priming()

	if not arg_11_0._locomotion_extension:is_on_ground() then
		return
	end

	local var_11_1 = arg_11_0._world
	local var_11_2 = arg_11_0._owner_unit
	local var_11_3 = arg_11_0._is_server
	local var_11_4 = arg_11_0._local_player
	local var_11_5 = arg_11_0._bot_player
	local var_11_6 = arg_11_0._network_manager.network_transmit
	local var_11_7 = arg_11_0._career_extension
	local var_11_8 = arg_11_0._status_extension
	local var_11_9 = arg_11_0._talent_extension
	local var_11_10 = arg_11_0._locomotion_extension
	local var_11_11 = World.get_data(var_11_1, "physics_world")
	local var_11_12, var_11_13, var_11_14 = var_0_2(var_11_11, POSITION_LOOKUP[var_11_2], var_11_0)

	if (var_11_4 or var_11_3 and var_11_5) and not var_11_9:has_talent("sienna_adept_activated_ability_explosion") then
		local var_11_15 = Managers.state.entity:system("ai_system"):nav_world()
		local var_11_16 = POSITION_LOOKUP[var_11_2]
		local var_11_17 = 2
		local var_11_18 = 30
		local var_11_19 = LocomotionUtils.pos_on_mesh(var_11_15, var_11_16, var_11_17, var_11_18) or GwNavQueries.inside_position_from_outside_position(var_11_15, var_11_16, var_11_17, var_11_18, 2, 0.5)

		if var_11_19 then
			local var_11_20 = "sienna_adept_ability_trail"
			local var_11_21 = NetworkLookup.damage_wave_templates[var_11_20]
			local var_11_22 = arg_11_0._network_manager
			local var_11_23 = var_11_22:unit_game_object_id(var_11_2)

			var_11_22.network_transmit:send_rpc_server("rpc_create_damage_wave", var_11_23, var_11_19, var_11_14, var_11_21)
		end
	end

	if var_11_4 then
		arg_11_0._first_person_extension:animation_event("battle_wizard_active_ability_blink")
		var_11_7:set_state("sienna_activate_adept")
	end

	var_11_10:set_external_velocity_enabled(false)
	var_11_8:reset_move_speed_multiplier()
	var_11_8:set_noclip(true, arg_11_0)

	if Managers.state.network:game() then
		var_11_8:set_is_dodging(true)

		local var_11_24 = Managers.state.network:unit_game_object_id(var_11_2)

		var_11_6:send_rpc_server("rpc_status_change_bool", NetworkLookup.statuses.dodging, true, var_11_24, 0)
	end

	var_11_8.do_leap = {
		move_function = "teleleap",
		direction = Vector3Box(var_11_12),
		speed = var_11_13,
		initial_vertical_speed = PlayerUnitMovementSettings.teleleap.jump_speed,
		projected_hit_pos = Vector3Box(var_11_14),
		sfx_event_jump = var_11_4 and "Play_career_ability_bardin_slayer_jump",
		sfx_event_land = var_11_4 and "Play_career_ability_bardin_slayer_impact",
		leap_events = {
			{
				distance_percentage = 0.1,
				event_function = function(arg_12_0)
					local var_12_0 = arg_12_0.unit

					ScriptUnit.extension(var_12_0, "status_system"):set_invisible(true, nil, arg_11_0)
				end
			},
			{
				distance_percentage = 0.2,
				event_function = function(arg_13_0)
					local var_13_0 = arg_13_0.unit
					local var_13_1 = ScriptUnit.extension(var_13_0, "career_system")
					local var_13_2 = POSITION_LOOKUP[var_13_0] or Unit.world_position(var_13_0, 0)
					local var_13_3 = Unit.local_rotation(var_13_0, 0)
					local var_13_4 = "sienna_adept_activated_ability_step_stagger"
					local var_13_5 = 1
					local var_13_6 = var_13_1:get_career_power_level()

					Managers.state.entity:system("area_damage_system"):create_explosion(var_13_0, var_13_2, var_13_3, var_13_4, var_13_5, "career_ability", var_13_6, false)
				end
			},
			start = function(arg_14_0)
				local var_14_0 = arg_14_0.unit
				local var_14_1 = ScriptUnit.extension(var_14_0, "career_system")
				local var_14_2 = POSITION_LOOKUP[var_14_0] or Unit.world_position(var_14_0, 0)
				local var_14_3 = Unit.local_rotation(var_14_0, 0)
				local var_14_4 = "sienna_adept_activated_ability_start_stagger"
				local var_14_5 = 1
				local var_14_6 = var_14_1:get_career_power_level()

				Managers.state.entity:system("area_damage_system"):create_explosion(var_14_0, var_14_2, var_14_3, var_14_4, var_14_5, "career_ability", var_14_6, false)
			end,
			finished = function(arg_15_0, arg_15_1, arg_15_2)
				local var_15_0 = arg_15_0.unit
				local var_15_1 = ScriptUnit.extension(var_15_0, "status_system")
				local var_15_2 = ScriptUnit.extension(var_15_0, "talent_system")
				local var_15_3 = ScriptUnit.extension(var_15_0, "career_system")

				if not arg_15_1 then
					local var_15_4 = Unit.local_rotation(var_15_0, 0)
					local var_15_5 = "sienna_adept_activated_ability_end_stagger"

					if var_15_2:has_talent("sienna_adept_activated_ability_explosion") then
						var_15_5 = "sienna_adept_activated_ability_end_stagger_improved"
					end

					local var_15_6 = 1
					local var_15_7 = var_15_3:get_career_power_level()

					Managers.state.entity:system("area_damage_system"):create_explosion(var_15_0, arg_15_2, var_15_4, var_15_5, var_15_6, "career_ability", var_15_7, false)
				end

				var_15_1:set_invisible(false, nil, arg_11_0)
				var_15_1:set_noclip(false, arg_11_0)

				if Managers.state.network:game() then
					var_15_1:set_is_dodging(false)

					local var_15_8 = Managers.state.network:unit_game_object_id(var_15_0)

					var_11_6:send_rpc_server("rpc_status_change_bool", NetworkLookup.statuses.dodging, false, var_15_8, 0)
				end
			end
		}
	}

	if var_11_4 or var_11_3 and var_11_5 then
		local var_11_25 = arg_11_0._buff_extension
		local var_11_26 = var_11_25:get_buff_type("sienna_adept_ability_trail_double")
		local var_11_27 = var_11_9:has_talent("sienna_adept_ability_trail_double")

		if var_11_26 or not var_11_27 then
			if var_11_26 then
				var_11_26.aborted = true

				var_11_25:remove_buff(var_11_26.id)
			end

			var_11_7:start_activated_ability_cooldown()
			var_11_7:set_abilities_always_usable(false, "sienna_adept_ability_trail_double")
		else
			var_11_25:add_buff("sienna_adept_ability_trail_double")
			var_11_7:set_abilities_always_usable(true, "sienna_adept_ability_trail_double")
			var_11_7:start_activated_ability_cooldown()
		end
	else
		var_11_7:start_activated_ability_cooldown()
	end

	arg_11_0:_play_vo()
end

function CareerAbilityBWAdept._play_vo(arg_16_0)
	local var_16_0 = arg_16_0._owner_unit
	local var_16_1 = ScriptUnit.extension_input(var_16_0, "dialogue_system")
	local var_16_2 = FrameTable.alloc_table()

	var_16_1:trigger_networked_dialogue_event("activate_ability", var_16_2)
end
