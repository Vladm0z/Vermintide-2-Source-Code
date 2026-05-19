-- chunkname: @scripts/unit_extensions/default_player_unit/careers/career_ability_we_maiden_guard.lua

CareerAbilityWEMaidenGuard = class(CareerAbilityWEMaidenGuard)

function CareerAbilityWEMaidenGuard.init(arg_1_0, arg_1_1, arg_1_2, arg_1_3)
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
	arg_1_0._decal_unit_name = "units/decals/decal_arrow_kerillian"
end

function CareerAbilityWEMaidenGuard.extensions_ready(arg_2_0, arg_2_1, arg_2_2)
	arg_2_0._first_person_extension = ScriptUnit.has_extension(arg_2_2, "first_person_system")
	arg_2_0._status_extension = ScriptUnit.extension(arg_2_2, "status_system")
	arg_2_0._career_extension = ScriptUnit.extension(arg_2_2, "career_system")
	arg_2_0._buff_extension = ScriptUnit.extension(arg_2_2, "buff_system")
	arg_2_0._input_extension = ScriptUnit.has_extension(arg_2_2, "input_system")

	if arg_2_0._first_person_extension then
		arg_2_0._first_person_unit = arg_2_0._first_person_extension:get_first_person_unit()
	end
end

function CareerAbilityWEMaidenGuard.destroy(arg_3_0)
	return
end

function CareerAbilityWEMaidenGuard.update(arg_4_0, arg_4_1, arg_4_2, arg_4_3, arg_4_4, arg_4_5)
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
		arg_4_0:_update_priming()

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

function CareerAbilityWEMaidenGuard.stop(arg_5_0, arg_5_1)
	if arg_5_1 ~= "pushed" and arg_5_1 ~= "stunned" and arg_5_0._is_priming then
		arg_5_0:_stop_priming()
	end
end

function CareerAbilityWEMaidenGuard._ability_available(arg_6_0)
	local var_6_0 = arg_6_0._career_extension
	local var_6_1 = arg_6_0._status_extension

	return var_6_0:can_use_activated_ability() and not var_6_1:is_disabled()
end

function CareerAbilityWEMaidenGuard._start_priming(arg_7_0)
	if arg_7_0._local_player then
		local var_7_0 = arg_7_0._decal_unit_name

		arg_7_0._decal_unit = Managers.state.unit_spawner:spawn_local_unit(var_7_0)
	end

	arg_7_0._is_priming = true
end

function CareerAbilityWEMaidenGuard._update_priming(arg_8_0)
	if arg_8_0._decal_unit then
		local var_8_0 = arg_8_0._first_person_extension
		local var_8_1 = Unit.local_position(arg_8_0._owner_unit, 0)
		local var_8_2 = var_8_0:current_rotation()
		local var_8_3 = Vector3.flat(Vector3.normalize(Quaternion.forward(var_8_2)))
		local var_8_4 = Quaternion.look(var_8_3, Vector3.up())

		Unit.set_local_position(arg_8_0._decal_unit, 0, var_8_1)
		Unit.set_local_rotation(arg_8_0._decal_unit, 0, var_8_4)
	end
end

function CareerAbilityWEMaidenGuard._stop_priming(arg_9_0)
	if arg_9_0._decal_unit then
		Managers.state.unit_spawner:mark_for_deletion(arg_9_0._decal_unit)
	end

	arg_9_0._is_priming = false
end

function CareerAbilityWEMaidenGuard._run_ability(arg_10_0)
	arg_10_0:_stop_priming()

	local var_10_0 = arg_10_0._owner_unit
	local var_10_1 = arg_10_0._is_server
	local var_10_2 = arg_10_0._local_player
	local var_10_3 = arg_10_0._bot_player
	local var_10_4 = arg_10_0._network_manager
	local var_10_5 = var_10_4.network_transmit
	local var_10_6 = arg_10_0._status_extension
	local var_10_7 = arg_10_0._career_extension
	local var_10_8 = arg_10_0._buff_extension
	local var_10_9 = ScriptUnit.extension(var_10_0, "talent_system")

	var_10_8:add_buff("kerillian_maidenguard_activated_ability")

	if var_10_9:has_talent("kerillian_maidenguard_activated_ability_invis_duration") then
		var_10_8:add_buff("kerillian_maidenguard_activated_ability_invis_duration")
	end

	if var_10_1 and var_10_3 or var_10_2 then
		local var_10_10 = arg_10_0._first_person_extension

		var_10_10:animation_event("shade_stealth_ability")
		var_10_10:play_remote_unit_sound_event("Play_career_ability_maiden_guard_charge", var_10_0, 0)
		var_10_7:set_state("kerillian_activate_maiden_guard")

		if var_10_2 then
			var_10_10:play_hud_sound_event("Play_career_ability_maiden_guard_charge")
		end
	end

	if var_10_4:game() then
		var_10_6:set_is_dodging(true)

		local var_10_11 = var_10_4:unit_game_object_id(var_10_0)

		var_10_5:send_rpc_server("rpc_status_change_bool", NetworkLookup.statuses.dodging, true, var_10_11, 0)
	end

	local var_10_12 = "maidenguard_dash_ability"
	local var_10_13 = var_10_9:has_talent("kerillian_maidenguard_activated_ability_damage")

	if var_10_13 then
		var_10_12 = "maidenguard_dash_ability_bleed"
	end

	var_10_6.do_lunge = {
		animation_end_event = "maiden_guard_active_ability_charge_hit",
		allow_rotation = false,
		first_person_animation_end_event = "dodge_bwd",
		first_person_hit_animation_event = "charge_react",
		falloff_to_speed = 5,
		dodge = true,
		first_person_animation_event = "shade_stealth_ability",
		first_person_animation_end_event_hit = "dodge_bwd",
		duration = 0.65,
		initial_speed = 25,
		animation_event = "maiden_guard_active_ability_charge_start",
		damage = {
			depth_padding = 0.4,
			height = 1.8,
			collision_filter = "filter_explosion_overlap_no_player",
			hit_zone_hit_name = "full",
			ignore_shield = true,
			interrupt_on_max_hit_mass = false,
			interrupt_on_first_hit = false,
			width = 1.5,
			allow_backstab = true,
			damage_profile = var_10_12,
			power_level_multiplier = var_10_13 and 1 or 0,
			stagger_angles = {
				max = 90,
				min = 90
			}
		}
	}

	var_10_7:start_activated_ability_cooldown()
	arg_10_0:_play_vo()
end

function CareerAbilityWEMaidenGuard._play_vo(arg_11_0)
	local var_11_0 = arg_11_0._owner_unit
	local var_11_1 = ScriptUnit.extension_input(var_11_0, "dialogue_system")
	local var_11_2 = FrameTable.alloc_table()

	var_11_1:trigger_networked_dialogue_event("activate_ability", var_11_2)
end
