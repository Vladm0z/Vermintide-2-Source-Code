-- chunkname: @scripts/unit_extensions/default_player_unit/careers/career_ability_we_shade_dash.lua

CareerAbilityWEShadeDash = class(CareerAbilityWEShadeDash)

function CareerAbilityWEShadeDash.init(arg_1_0, arg_1_1, arg_1_2, arg_1_3)
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
	arg_1_0._lunge_events = {
		start = function(arg_2_0)
			local var_2_0 = arg_1_0._owner_unit
			local var_2_1 = arg_1_0._local_player
			local var_2_2 = arg_1_0._bot_player
			local var_2_3 = arg_1_0._is_server
			local var_2_4 = arg_1_0._network_manager
			local var_2_5 = var_2_4.network_transmit
			local var_2_6 = arg_1_0._career_extension
			local var_2_7 = arg_1_0._status_extension
			local var_2_8 = arg_1_0._buff_extension
			local var_2_9 = "kerillian_shade_activated_ability"

			if ScriptUnit.extension(arg_1_0._owner_unit, "talent_system"):has_talent("kerillian_shade_activated_ability_quick_cooldown", "wood_elf", true) then
				var_2_9 = "kerillian_shade_activated_ability_quick_cooldown"
			end

			local var_2_10 = NetworkLookup.buff_templates[var_2_9]
			local var_2_11 = var_2_4:unit_game_object_id(var_2_0)

			if var_2_3 then
				var_2_8:add_buff(var_2_9, {
					attacker_unit = var_2_0
				})
				var_2_5:send_rpc_clients("rpc_add_buff", var_2_11, var_2_10, var_2_11, 0, false)
			else
				var_2_5:send_rpc_server("rpc_add_buff", var_2_11, var_2_10, var_2_11, 0, true)
			end

			if var_2_1 or var_2_3 and var_2_2 then
				local var_2_12 = var_2_7:set_invisible(true, nil, "skill_shade")

				var_2_7:set_noclip(true, "skill_shade")

				local var_2_13 = {
					"Play_career_ability_kerillian_shade_enter",
					"Play_career_ability_kerillian_shade_loop_husk"
				}
				local var_2_14 = var_2_4:unit_game_object_id(var_2_0)
				local var_2_15 = 0

				for iter_2_0, iter_2_1 in ipairs(var_2_13) do
					local var_2_16 = NetworkLookup.sound_events[iter_2_1]

					if var_2_3 then
						var_2_5:send_rpc_clients("rpc_play_husk_unit_sound_event", var_2_14, var_2_15, var_2_16)
					else
						var_2_5:send_rpc_server("rpc_play_husk_unit_sound_event", var_2_14, var_2_15, var_2_16)
					end
				end

				if not var_2_2 then
					local var_2_17 = arg_1_0._first_person_extension

					if var_2_12 then
						var_2_17:play_hud_sound_event("Play_career_ability_kerillian_shade_loop")
					end

					var_2_17:play_hud_sound_event("Play_career_ability_kerillian_shade_enter")
					var_2_17:animation_event("shade_stealth_ability")
					var_2_6:set_state("kerillian_activate_shade")
				end
			end
		end,
		impact = function(arg_3_0)
			return
		end,
		finished = function(arg_4_0)
			return
		end
	}
	arg_1_0._decal_unit = nil
	arg_1_0._decal_unit_name = "units/decals/decal_arrow_kerillian"
end

function CareerAbilityWEShadeDash.extensions_ready(arg_5_0, arg_5_1, arg_5_2)
	arg_5_0._first_person_extension = ScriptUnit.has_extension(arg_5_2, "first_person_system")
	arg_5_0._status_extension = ScriptUnit.extension(arg_5_2, "status_system")
	arg_5_0._career_extension = ScriptUnit.extension(arg_5_2, "career_system")
	arg_5_0._buff_extension = ScriptUnit.extension(arg_5_2, "buff_system")
	arg_5_0._input_extension = ScriptUnit.has_extension(arg_5_2, "input_system")

	if arg_5_0._first_person_extension then
		arg_5_0._first_person_unit = arg_5_0._first_person_extension:get_first_person_unit()
	end
end

function CareerAbilityWEShadeDash.destroy(arg_6_0)
	return
end

function CareerAbilityWEShadeDash.update(arg_7_0, arg_7_1, arg_7_2, arg_7_3, arg_7_4, arg_7_5)
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
		arg_7_0:_update_priming()

		if var_7_0:get("action_two") then
			arg_7_0:_stop_priming()

			return
		end

		if var_7_0:get("weapon_reload") then
			arg_7_0:_stop_priming()

			return
		end

		if not var_7_0:get("action_career_hold") then
			arg_7_0:_run_ability()
		end
	end
end

function CareerAbilityWEShadeDash.stop(arg_8_0, arg_8_1)
	if arg_8_1 ~= "pushed" and arg_8_1 ~= "stunned" and arg_8_0._is_priming then
		arg_8_0:_stop_priming()
	end
end

function CareerAbilityWEShadeDash._ability_available(arg_9_0)
	local var_9_0 = arg_9_0._career_extension
	local var_9_1 = arg_9_0._status_extension
	local var_9_2 = ScriptUnit.extension(arg_9_0._owner_unit, "talent_system")
	local var_9_3 = false

	return var_9_3 and var_9_0:can_use_activated_ability() and not var_9_1:is_disabled()
end

function CareerAbilityWEShadeDash._start_priming(arg_10_0)
	if arg_10_0._local_player then
		local var_10_0 = arg_10_0._decal_unit_name

		arg_10_0._decal_unit = Managers.state.unit_spawner:spawn_local_unit(var_10_0)
	end

	arg_10_0._is_priming = true
end

function CareerAbilityWEShadeDash._update_priming(arg_11_0)
	if arg_11_0._decal_unit then
		local var_11_0 = arg_11_0._first_person_extension
		local var_11_1 = Unit.local_position(arg_11_0._owner_unit, 0)
		local var_11_2 = var_11_0:current_rotation()
		local var_11_3 = Vector3.flat(Vector3.normalize(Quaternion.forward(var_11_2)))
		local var_11_4 = Quaternion.look(var_11_3, Vector3.up())

		Unit.set_local_position(arg_11_0._decal_unit, 0, var_11_1)
		Unit.set_local_rotation(arg_11_0._decal_unit, 0, var_11_4)
	end
end

function CareerAbilityWEShadeDash._stop_priming(arg_12_0)
	if arg_12_0._decal_unit then
		Managers.state.unit_spawner:mark_for_deletion(arg_12_0._decal_unit)
	end

	arg_12_0._is_priming = false
end

function CareerAbilityWEShadeDash._run_ability(arg_13_0)
	arg_13_0:_stop_priming()

	local var_13_0 = arg_13_0._owner_unit
	local var_13_1 = arg_13_0._is_server
	local var_13_2 = arg_13_0._local_player
	local var_13_3 = arg_13_0._bot_player
	local var_13_4 = arg_13_0._network_manager
	local var_13_5 = var_13_4.network_transmit
	local var_13_6 = arg_13_0._status_extension
	local var_13_7 = arg_13_0._career_extension

	if var_13_1 and var_13_3 or var_13_2 then
		local var_13_8 = arg_13_0._first_person_extension

		var_13_8:animation_event("shade_stealth_ability")
		var_13_8:play_hud_sound_event("Play_career_ability_shade_shadowstep_charge")
		var_13_8:play_remote_unit_sound_event("Play_career_ability_shade_shadowstep_charge", var_13_0, 0)
		var_13_7:set_state("kerillian_activate_maiden_guard")
	end

	var_13_6:set_noclip(true, "skill_shade")

	if var_13_4:game() then
		var_13_6:set_is_dodging(true)

		local var_13_9 = var_13_4:unit_game_object_id(var_13_0)

		var_13_5:send_rpc_server("rpc_status_change_bool", NetworkLookup.statuses.dodging, true, var_13_9, 0)
	end

	var_13_6.do_lunge = {
		animation_end_event = "maiden_guard_active_ability_charge_hit",
		allow_rotation = false,
		falloff_to_speed = 5,
		first_person_animation_end_event = "dodge_bwd",
		first_person_hit_animation_event = "charge_react",
		dodge = true,
		first_person_animation_event = "shade_stealth_ability",
		first_person_animation_end_event_hit = "dodge_bwd",
		duration = 0.65,
		initial_speed = 25,
		animation_event = "maiden_guard_active_ability_charge_start",
		lunge_events = arg_13_0._lunge_events
	}

	var_13_7:start_activated_ability_cooldown()
	arg_13_0:_play_vo()
end

function CareerAbilityWEShadeDash._play_vo(arg_14_0)
	local var_14_0 = arg_14_0._owner_unit
	local var_14_1 = ScriptUnit.extension_input(var_14_0, "dialogue_system")
	local var_14_2 = FrameTable.alloc_table()

	var_14_1:trigger_networked_dialogue_event("activate_ability", var_14_2)
end
