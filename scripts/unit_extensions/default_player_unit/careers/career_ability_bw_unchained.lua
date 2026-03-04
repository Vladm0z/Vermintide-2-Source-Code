-- chunkname: @scripts/unit_extensions/default_player_unit/careers/career_ability_bw_unchained.lua

CareerAbilityBWUnchained = class(CareerAbilityBWUnchained)

CareerAbilityBWUnchained.init = function (arg_1_0, arg_1_1, arg_1_2, arg_1_3)
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
	arg_1_0._priming_fx_name = "fx/chr_unchained_aoe_decal"
end

CareerAbilityBWUnchained.extensions_ready = function (arg_2_0, arg_2_1, arg_2_2)
	arg_2_0._first_person_extension = ScriptUnit.has_extension(arg_2_2, "first_person_system")
	arg_2_0._status_extension = ScriptUnit.extension(arg_2_2, "status_system")
	arg_2_0._career_extension = ScriptUnit.extension(arg_2_2, "career_system")
	arg_2_0._buff_extension = ScriptUnit.extension(arg_2_2, "buff_system")
	arg_2_0._input_extension = ScriptUnit.has_extension(arg_2_2, "input_system")

	if arg_2_0._first_person_extension then
		arg_2_0._first_person_unit = arg_2_0._first_person_extension:get_first_person_unit()
	end
end

CareerAbilityBWUnchained.destroy = function (arg_3_0)
	return
end

CareerAbilityBWUnchained.update = function (arg_4_0, arg_4_1, arg_4_2, arg_4_3, arg_4_4, arg_4_5)
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

CareerAbilityBWUnchained.stop = function (arg_5_0, arg_5_1)
	if arg_5_1 ~= "pushed" and arg_5_1 ~= "stunned" and arg_5_0._is_priming then
		arg_5_0:_stop_priming()
	end
end

CareerAbilityBWUnchained._ability_available = function (arg_6_0)
	local var_6_0 = arg_6_0._career_extension
	local var_6_1 = arg_6_0._status_extension

	return var_6_0:can_use_activated_ability() and not var_6_1:is_disabled()
end

CareerAbilityBWUnchained._start_priming = function (arg_7_0)
	if arg_7_0._local_player then
		local var_7_0 = arg_7_0._world
		local var_7_1 = arg_7_0._priming_fx_name

		if ScriptUnit.extension(arg_7_0._owner_unit, "talent_system"):has_talent("sienna_unchained_activated_ability_power_on_enemies_hit", "bright_wizard", true) then
			var_7_1 = "fx/chr_unchained_aoe_decal_large"
		end

		arg_7_0._priming_fx_id = World.create_particles(var_7_0, var_7_1, Vector3.zero())
	end

	arg_7_0._is_priming = true
end

CareerAbilityBWUnchained._update_priming = function (arg_8_0, arg_8_1)
	local var_8_0 = arg_8_0._priming_fx_id

	if var_8_0 then
		local var_8_1 = arg_8_0._world
		local var_8_2 = arg_8_0._owner_unit
		local var_8_3 = POSITION_LOOKUP[var_8_2]

		World.move_particles(var_8_1, var_8_0, var_8_3)
	end
end

CareerAbilityBWUnchained._stop_priming = function (arg_9_0)
	local var_9_0 = arg_9_0._world
	local var_9_1 = arg_9_0._priming_fx_id

	if var_9_1 then
		World.destroy_particles(var_9_0, var_9_1)

		arg_9_0._priming_fx_id = nil
	end

	arg_9_0._is_priming = false
end

CareerAbilityBWUnchained._run_ability = function (arg_10_0, arg_10_1)
	arg_10_0:_stop_priming()

	local var_10_0 = arg_10_0._owner_unit
	local var_10_1 = arg_10_0._is_server
	local var_10_2 = arg_10_0._local_player
	local var_10_3 = arg_10_0._bot_player
	local var_10_4 = POSITION_LOOKUP[var_10_0]
	local var_10_5 = arg_10_0._network_manager
	local var_10_6 = var_10_5.network_transmit
	local var_10_7 = arg_10_0._career_extension
	local var_10_8 = arg_10_0._buff_extension
	local var_10_9 = ScriptUnit.extension(var_10_0, "talent_system")
	local var_10_10 = "sienna_unchained_activated_ability"

	var_10_8:add_buff(var_10_10, {
		attacker_unit = var_10_0
	})

	if var_10_1 and var_10_3 or var_10_2 then
		ScriptUnit.extension(var_10_0, "overcharge_system"):reset()
		var_10_7:set_state("sienna_activate_unchained")
	end

	local var_10_11 = Unit.local_rotation(var_10_0, 0)
	local var_10_12 = "explosion_bw_unchained_ability"
	local var_10_13 = 1

	if var_10_9:has_talent("sienna_unchained_activated_ability_fire_aura") then
		var_10_12 = "explosion_bw_unchained_ability_increased_radius"
	end

	local var_10_14 = var_10_7:get_career_power_level()

	if var_10_9:has_talent("sienna_unchained_activated_ability_temp_health") then
		local var_10_15 = 10
		local var_10_16 = FrameTable.alloc_table()
		local var_10_17 = Managers.state.entity:system("proximity_system").player_units_broadphase

		Broadphase.query(var_10_17, POSITION_LOOKUP[var_10_0], var_10_15, var_10_16)

		local var_10_18 = Managers.state.side
		local var_10_19 = TalentUtils.get_talent_attribute("sienna_unchained_activated_ability_temp_health", "heal_amount")
		local var_10_20 = NetworkLookup.heal_types.career_skill

		for iter_10_0, iter_10_1 in pairs(var_10_16) do
			if not var_10_18:is_enemy(arg_10_0._owner_unit, iter_10_1) then
				local var_10_21 = var_10_5:unit_game_object_id(iter_10_1)

				if var_10_21 then
					var_10_6:send_rpc_server("rpc_request_heal", var_10_21, var_10_19, var_10_20)
				end
			end
		end
	end

	local var_10_22 = ExplosionUtils.get_template(var_10_12)
	local var_10_23 = var_10_5:unit_game_object_id(var_10_0)
	local var_10_24 = "career_ability"
	local var_10_25 = NetworkLookup.explosion_templates[var_10_12]
	local var_10_26 = NetworkLookup.damage_sources[var_10_24]
	local var_10_27 = false

	if var_10_1 then
		var_10_6:send_rpc_clients("rpc_create_explosion", var_10_23, false, var_10_4, var_10_11, var_10_25, var_10_13, var_10_26, var_10_14, false, var_10_23)
	else
		var_10_6:send_rpc_server("rpc_create_explosion", var_10_23, false, var_10_4, var_10_11, var_10_25, var_10_13, var_10_26, var_10_14, false, var_10_23)
	end

	DamageUtils.create_explosion(arg_10_0._world, var_10_0, var_10_4, var_10_11, var_10_22, var_10_13, var_10_24, var_10_1, var_10_27, var_10_0, var_10_14, false, var_10_0)
	var_10_7:start_activated_ability_cooldown()

	if var_10_9:has_talent("sienna_unchained_activated_ability_fire_aura") then
		local var_10_28 = {
			"sienna_unchained_activated_ability_pulse"
		}
		local var_10_29 = var_10_5:unit_game_object_id(var_10_0)

		if var_10_1 then
			local var_10_30 = arg_10_0._buff_extension

			for iter_10_2 = 1, #var_10_28 do
				local var_10_31 = var_10_28[iter_10_2]
				local var_10_32 = NetworkLookup.buff_templates[var_10_31]

				var_10_30:add_buff(var_10_31, {
					attacker_unit = var_10_0
				})
				var_10_6:send_rpc_clients("rpc_add_buff", var_10_29, var_10_32, var_10_29, 0, false)
			end
		else
			for iter_10_3 = 1, #var_10_28 do
				local var_10_33 = var_10_28[iter_10_3]
				local var_10_34 = NetworkLookup.buff_templates[var_10_33]

				var_10_6:send_rpc_server("rpc_add_buff", var_10_29, var_10_34, var_10_29, 0, true)
			end
		end
	end

	if var_10_9:has_talent("sienna_unchained_activated_ability_power_on_enemies_hit") then
		local var_10_35 = NetworkLookup.buff_attack_types.ability
		local var_10_36 = var_10_5:unit_game_object_id(var_10_0)
		local var_10_37 = NetworkLookup.buff_weapon_types["n/a"]
		local var_10_38 = NetworkLookup.hit_zones.torso
		local var_10_39 = 10
		local var_10_40 = FrameTable.alloc_table()
		local var_10_41 = Managers.state.entity:system("proximity_system").enemy_broadphase

		Broadphase.query(var_10_41, var_10_4, var_10_39, var_10_40)

		local var_10_42 = 1
		local var_10_43 = Managers.state.side

		for iter_10_4, iter_10_5 in pairs(var_10_40) do
			if Unit.alive(iter_10_5) then
				local var_10_44 = var_10_5:unit_game_object_id(iter_10_5)

				if var_10_43:is_enemy(var_10_0, iter_10_5) then
					if var_10_1 then
						var_10_6:send_rpc_server("rpc_buff_on_attack", var_10_36, var_10_44, var_10_35, false, var_10_38, var_10_42, var_10_37, var_10_26)
					else
						var_10_6:send_rpc_server("rpc_buff_on_attack", var_10_36, var_10_44, var_10_35, false, var_10_38, var_10_42, var_10_37, var_10_26)
					end
				end
			end
		end
	end

	local var_10_45, var_10_46 = ScriptUnit.has_extension(var_10_0, "inventory_system"):get_all_weapon_unit()
	local var_10_47 = var_10_45 and ScriptUnit.has_extension(var_10_45, "weapon_system")
	local var_10_48 = var_10_46 and ScriptUnit.has_extension(var_10_46, "weapon_system")
	local var_10_49 = var_10_47 and var_10_47:has_current_action()

	var_10_49 = var_10_49 or var_10_48 and var_10_48:has_current_action()

	if not var_10_49 then
		CharacterStateHelper.play_animation_event(var_10_0, "unchained_ability_explosion")
	end

	if var_10_1 and var_10_3 or var_10_2 then
		local var_10_50 = arg_10_0._first_person_extension

		if not var_10_49 then
			var_10_50:animation_event("unchained_ability_explosion")
		end

		var_10_50:play_hud_sound_event("Play_career_ability_unchained_fire")
		var_10_50:play_remote_unit_sound_event("Play_career_ability_unchained_fire", var_10_0, 0)
	end

	arg_10_0:_play_vo()
end

CareerAbilityBWUnchained._play_vo = function (arg_11_0)
	local var_11_0 = arg_11_0._owner_unit
	local var_11_1 = ScriptUnit.extension_input(var_11_0, "dialogue_system")
	local var_11_2 = FrameTable.alloc_table()

	var_11_1:trigger_networked_dialogue_event("activate_ability", var_11_2)
end
