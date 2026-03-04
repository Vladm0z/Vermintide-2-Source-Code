-- chunkname: @scripts/unit_extensions/default_player_unit/careers/career_ability_dr_ironbreaker.lua

CareerAbilityDRIronbreaker = class(CareerAbilityDRIronbreaker)

CareerAbilityDRIronbreaker.init = function (arg_1_0, arg_1_1, arg_1_2, arg_1_3)
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
	arg_1_0._priming_fx_id = nil
	arg_1_0._priming_fx_name = "fx/chr_ironbreaker_aoe_decal"
end

CareerAbilityDRIronbreaker.extensions_ready = function (arg_2_0, arg_2_1, arg_2_2)
	arg_2_0._first_person_extension = ScriptUnit.has_extension(arg_2_2, "first_person_system")
	arg_2_0._status_extension = ScriptUnit.extension(arg_2_2, "status_system")
	arg_2_0._career_extension = ScriptUnit.extension(arg_2_2, "career_system")
	arg_2_0._buff_extension = ScriptUnit.extension(arg_2_2, "buff_system")
	arg_2_0._input_extension = ScriptUnit.has_extension(arg_2_2, "input_system")

	if arg_2_0._first_person_extension then
		arg_2_0._first_person_unit = arg_2_0._first_person_extension:get_first_person_unit()
	end
end

CareerAbilityDRIronbreaker.destroy = function (arg_3_0)
	return
end

CareerAbilityDRIronbreaker.update = function (arg_4_0, arg_4_1, arg_4_2, arg_4_3, arg_4_4, arg_4_5)
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

CareerAbilityDRIronbreaker.stop = function (arg_5_0, arg_5_1)
	if arg_5_1 ~= "pushed" and arg_5_1 ~= "stunned" and arg_5_0._is_priming then
		arg_5_0:_stop_priming()
	end
end

CareerAbilityDRIronbreaker._ability_available = function (arg_6_0)
	local var_6_0 = arg_6_0._career_extension
	local var_6_1 = arg_6_0._status_extension

	return var_6_0:can_use_activated_ability() and not var_6_1:is_disabled()
end

CareerAbilityDRIronbreaker._start_priming = function (arg_7_0)
	if arg_7_0._local_player then
		local var_7_0 = arg_7_0._world
		local var_7_1 = arg_7_0._priming_fx_name

		arg_7_0._priming_fx_id = World.create_particles(var_7_0, var_7_1, Vector3.zero())
	end

	arg_7_0._is_priming = true
end

CareerAbilityDRIronbreaker._update_priming = function (arg_8_0, arg_8_1)
	local var_8_0 = arg_8_0._priming_fx_id

	if var_8_0 then
		local var_8_1 = arg_8_0._world
		local var_8_2 = arg_8_0._owner_unit
		local var_8_3 = POSITION_LOOKUP[var_8_2]

		World.move_particles(var_8_1, var_8_0, var_8_3)
	end
end

CareerAbilityDRIronbreaker._stop_priming = function (arg_9_0)
	local var_9_0 = arg_9_0._priming_fx_id

	if var_9_0 then
		local var_9_1 = arg_9_0._world

		World.destroy_particles(var_9_1, var_9_0)

		arg_9_0._priming_fx_id = nil
	end

	arg_9_0._is_priming = false
end

CareerAbilityDRIronbreaker._run_ability = function (arg_10_0)
	arg_10_0:_stop_priming()

	local var_10_0 = arg_10_0._owner_unit
	local var_10_1 = arg_10_0._is_server
	local var_10_2 = arg_10_0._local_player
	local var_10_3 = arg_10_0._bot_player
	local var_10_4 = arg_10_0._network_manager
	local var_10_5 = var_10_4.network_transmit
	local var_10_6 = var_10_4:unit_game_object_id(var_10_0)
	local var_10_7 = arg_10_0._career_extension
	local var_10_8 = ScriptUnit.extension(var_10_0, "talent_system")

	CharacterStateHelper.play_animation_event(var_10_0, "iron_breaker_active_ability")

	local var_10_9 = {
		"bardin_ironbreaker_activated_ability",
		"bardin_ironbreaker_activated_ability_block_cost",
		"bardin_ironbreaker_activated_ability_attack_intensity_decay_increase"
	}

	if var_10_8:has_talent("bardin_ironbreaker_activated_ability_taunt_range_and_duration") then
		table.clear(var_10_9)

		var_10_9 = {
			"bardin_ironbreaker_activated_ability_taunt_range_and_duration",
			"bardin_ironbreaker_activated_ability_taunt_range_and_duration_block_cost",
			"bardin_ironbreaker_activated_ability_taunt_range_and_duration_attack_intensity_decay_increase"
		}
	end

	local var_10_10 = FrameTable.alloc_table()

	var_10_10[1] = var_10_0

	local var_10_11 = 10
	local var_10_12 = 10

	if var_10_8:has_talent("bardin_ironbreaker_activated_ability_taunt_range_and_duration") then
		var_10_12 = 15
		var_10_11 = 15
	end

	if var_10_8:has_talent("bardin_ironbreaker_activated_ability_power_buff_allies") then
		local var_10_13 = Managers.state.side.side_by_unit[var_10_0].PLAYER_AND_BOT_UNITS
		local var_10_14 = #var_10_13

		for iter_10_0 = 1, var_10_14 do
			local var_10_15 = var_10_13[iter_10_0]
			local var_10_16 = POSITION_LOOKUP[var_10_15]
			local var_10_17 = POSITION_LOOKUP[var_10_0]

			if Vector3.distance_squared(var_10_17, var_10_16) < var_10_11 * var_10_11 then
				local var_10_18 = "bardin_ironbreaker_activated_ability_power_buff"
				local var_10_19 = var_10_4:unit_game_object_id(var_10_15)
				local var_10_20 = ScriptUnit.extension(var_10_15, "buff_system")
				local var_10_21 = NetworkLookup.buff_templates[var_10_18]

				if var_10_1 then
					var_10_20:add_buff(var_10_18)
					var_10_5:send_rpc_clients("rpc_add_buff", var_10_19, var_10_21, var_10_6, 0, false)
				else
					var_10_5:send_rpc_server("rpc_add_buff", var_10_19, var_10_21, var_10_6, 0, true)
				end
			end
		end
	end

	local var_10_22 = true
	local var_10_23 = var_10_8:has_talent("bardin_ironbreaker_activated_ability_taunt_bosses")

	if var_10_1 then
		ScriptUnit.extension(var_10_0, "target_override_system"):taunt(var_10_11, var_10_12, var_10_22, var_10_23)
	else
		var_10_5:send_rpc_server("rpc_taunt", var_10_6, var_10_11, var_10_12, var_10_22, var_10_23)
	end

	local var_10_24 = #var_10_10

	for iter_10_1 = 1, var_10_24 do
		local var_10_25 = var_10_10[iter_10_1]
		local var_10_26 = var_10_4:unit_game_object_id(var_10_25)
		local var_10_27 = ScriptUnit.extension(var_10_25, "buff_system")

		for iter_10_2, iter_10_3 in ipairs(var_10_9) do
			local var_10_28 = NetworkLookup.buff_templates[iter_10_3]

			if var_10_1 then
				var_10_27:add_buff(iter_10_3, {
					attacker_unit = var_10_0
				})
				var_10_5:send_rpc_clients("rpc_add_buff", var_10_26, var_10_28, var_10_6, 0, false)
			else
				var_10_5:send_rpc_server("rpc_add_buff", var_10_26, var_10_28, var_10_6, 0, true)
			end
		end
	end

	if var_10_1 and var_10_3 or var_10_2 then
		local var_10_29 = arg_10_0._first_person_extension

		var_10_29:animation_event("ability_shout")
		var_10_29:play_hud_sound_event("Play_career_ability_bardin_ironbreaker_enter")
		var_10_29:play_remote_unit_sound_event("Play_career_ability_bardin_ironbreaker_enter", var_10_0, 0)
	end

	arg_10_0:_play_vfx()
	arg_10_0:_play_vo()
	var_10_7:start_activated_ability_cooldown()
end

CareerAbilityDRIronbreaker._play_vo = function (arg_11_0)
	local var_11_0 = arg_11_0._owner_unit
	local var_11_1 = ScriptUnit.extension_input(var_11_0, "dialogue_system")
	local var_11_2 = FrameTable.alloc_table()

	var_11_1:trigger_networked_dialogue_event("activate_ability", var_11_2)
end

CareerAbilityDRIronbreaker._play_vfx = function (arg_12_0)
	local var_12_0 = arg_12_0._owner_unit
	local var_12_1 = arg_12_0._network_manager
	local var_12_2 = var_12_1.network_transmit
	local var_12_3 = var_12_1:unit_game_object_id(var_12_0)
	local var_12_4 = "fx/chr_iron_breaker_ability_taunt"
	local var_12_5 = NetworkLookup.effects[var_12_4]
	local var_12_6 = var_12_3
	local var_12_7 = 0
	local var_12_8 = Vector3(0, 0, 0)
	local var_12_9 = Quaternion.identity()
	local var_12_10 = false

	Managers.state.event:trigger("event_play_particle_effect", var_12_4, var_12_0, var_12_7, var_12_8, var_12_9, var_12_10)

	if Managers.player.is_server then
		var_12_2:send_rpc_clients("rpc_play_particle_effect", var_12_5, var_12_6, var_12_7, var_12_8, var_12_9, var_12_10)
	else
		var_12_2:send_rpc_server("rpc_play_particle_effect", var_12_5, var_12_6, var_12_7, var_12_8, var_12_9, var_12_10)
	end
end
