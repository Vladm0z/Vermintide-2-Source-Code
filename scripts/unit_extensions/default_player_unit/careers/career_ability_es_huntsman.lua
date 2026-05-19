-- chunkname: @scripts/unit_extensions/default_player_unit/careers/career_ability_es_huntsman.lua

CareerAbilityESHuntsman = class(CareerAbilityESHuntsman)

function CareerAbilityESHuntsman.init(arg_1_0, arg_1_1, arg_1_2, arg_1_3)
	arg_1_0.owner_unit = arg_1_2
	arg_1_0.world = arg_1_1.world
	arg_1_0.wwise_world = Managers.world:wwise_world(arg_1_0.world)

	local var_1_0 = arg_1_3.player

	arg_1_0.player = var_1_0
	arg_1_0.is_server = var_1_0.is_server
	arg_1_0.local_player = var_1_0.local_player
	arg_1_0.bot_player = var_1_0.bot_player
	arg_1_0.network_manager = Managers.state.network
	arg_1_0.input_manager = Managers.input
end

function CareerAbilityESHuntsman.extensions_ready(arg_2_0, arg_2_1, arg_2_2)
	arg_2_0._status_extension = ScriptUnit.extension(arg_2_2, "status_system")
	arg_2_0._career_extension = ScriptUnit.extension(arg_2_2, "career_system")
	arg_2_0._buff_extension = ScriptUnit.extension(arg_2_2, "buff_system")
	arg_2_0._inventory_extension = ScriptUnit.extension(arg_2_2, "inventory_system")
	arg_2_0._input_extension = ScriptUnit.has_extension(arg_2_2, "input_system")
	arg_2_0._first_person_extension = ScriptUnit.has_extension(arg_2_2, "first_person_system")
end

function CareerAbilityESHuntsman.destroy(arg_3_0)
	return
end

function CareerAbilityESHuntsman.update(arg_4_0, arg_4_1, arg_4_2, arg_4_3, arg_4_4, arg_4_5)
	if not arg_4_0:_ability_available() then
		return
	end

	local var_4_0 = arg_4_0._input_extension

	if not var_4_0 then
		return
	end

	if var_4_0:get("action_career") then
		arg_4_0:_run_ability()
	end
end

function CareerAbilityESHuntsman.stop(arg_5_0, arg_5_1)
	if arg_5_0._is_priming then
		arg_5_0:_stop_priming()
	end
end

function CareerAbilityESHuntsman._ability_available(arg_6_0)
	local var_6_0 = arg_6_0._career_extension
	local var_6_1 = arg_6_0._status_extension
	local var_6_2 = var_6_0:can_use_activated_ability()
	local var_6_3 = var_6_1:is_disabled()
	local var_6_4 = "slot_ranged"
	local var_6_5 = arg_6_0._inventory_extension:get_slot_data(var_6_4) ~= nil

	return var_6_2 and not var_6_3 and var_6_5
end

function CareerAbilityESHuntsman.force_trigger_ability(arg_7_0)
	local var_7_0 = true

	arg_7_0:_run_ability(var_7_0)
end

function CareerAbilityESHuntsman._run_ability(arg_8_0, arg_8_1)
	local var_8_0 = arg_8_0.owner_unit
	local var_8_1 = arg_8_0.is_server
	local var_8_2 = arg_8_0.local_player
	local var_8_3 = arg_8_0.bot_player
	local var_8_4 = arg_8_0.network_manager
	local var_8_5 = var_8_4.network_transmit
	local var_8_6 = arg_8_0._inventory_extension
	local var_8_7 = arg_8_0._buff_extension
	local var_8_8 = arg_8_0._career_extension
	local var_8_9 = ScriptUnit.extension(var_8_0, "talent_system")
	local var_8_10 = {
		"markus_huntsman_activated_ability",
		"markus_huntsman_activated_ability_headshot_multiplier"
	}
	local var_8_11 = {}

	if var_8_9:has_talent("markus_huntsman_activated_ability_improved_stealth") then
		var_8_11 = {
			"markus_huntsman_activated_ability_increased_zoom",
			"markus_huntsman_activated_ability_increased_reload_speed",
			"markus_huntsman_activated_ability_decrease_move_speed",
			"markus_huntsman_activated_ability_decrease_crouch_move_speed",
			"markus_huntsman_activated_ability_decrease_walk_move_speed",
			"markus_huntsman_activated_ability_decrease_dodge_speed",
			"markus_huntsman_activated_ability_decrease_dodge_distance"
		}
	elseif var_8_9:has_talent("markus_huntsman_activated_ability_duration") then
		var_8_11 = {
			"markus_huntsman_activated_ability_increased_zoom_duration",
			"markus_huntsman_activated_ability_increased_reload_speed_duration",
			"markus_huntsman_activated_ability_decrease_move_speed_duration",
			"markus_huntsman_activated_ability_decrease_crouch_move_speed_duration",
			"markus_huntsman_activated_ability_decrease_walk_move_speed_duration",
			"markus_huntsman_activated_ability_decrease_dodge_speed_duration",
			"markus_huntsman_activated_ability_decrease_dodge_distance_duration",
			"markus_huntsman_end_activated_on_hit_duration"
		}
		var_8_10 = {
			"markus_huntsman_activated_ability_duration",
			"markus_huntsman_activated_ability_headshot_multiplier_duration"
		}
	else
		var_8_11 = {
			"markus_huntsman_activated_ability_increased_zoom",
			"markus_huntsman_activated_ability_increased_reload_speed",
			"markus_huntsman_activated_ability_decrease_move_speed",
			"markus_huntsman_activated_ability_decrease_crouch_move_speed",
			"markus_huntsman_activated_ability_decrease_walk_move_speed",
			"markus_huntsman_activated_ability_decrease_dodge_speed",
			"markus_huntsman_activated_ability_decrease_dodge_distance",
			"markus_huntsman_end_activated_on_hit"
		}
		var_8_10 = {
			"markus_huntsman_activated_ability",
			"markus_huntsman_activated_ability_headshot_multiplier"
		}
	end

	local var_8_12 = var_8_4:unit_game_object_id(var_8_0)

	for iter_8_0, iter_8_1 in ipairs(var_8_10) do
		local var_8_13 = NetworkLookup.buff_templates[iter_8_1]

		if var_8_1 then
			var_8_7:add_buff(iter_8_1, {
				attacker_unit = var_8_0
			})
			var_8_5:send_rpc_clients("rpc_add_buff", var_8_12, var_8_13, var_8_12, 0, false)
		else
			var_8_5:send_rpc_server("rpc_add_buff", var_8_12, var_8_13, var_8_12, 0, true)
		end
	end

	for iter_8_2, iter_8_3 in ipairs(var_8_11) do
		var_8_7:add_buff(iter_8_3, {
			attacker_unit = var_8_0
		})
	end

	if var_8_9:has_talent("markus_huntsman_activated_ability_cooldown_2") then
		local var_8_14 = var_8_7:get_non_stacking_buff("markus_huntsman_passive")
		local var_8_15 = var_8_14.template.max_sub_buff_stacks

		if not var_8_14.buff_list then
			var_8_14.buff_list = {}
		end

		for iter_8_4 = 1, var_8_15 do
			if var_8_15 > #var_8_14.buff_list then
				table.insert(var_8_14.buff_list, var_8_7:add_buff("markus_huntsman_auto_headshot"))
			end
		end
	end

	local var_8_16 = "slot_ranged"
	local var_8_17 = var_8_6:get_slot_data(var_8_16)
	local var_8_18 = var_8_17.right_unit_1p
	local var_8_19 = var_8_17.left_unit_1p
	local var_8_20 = ScriptUnit.has_extension(var_8_18, "ammo_system")
	local var_8_21 = ScriptUnit.has_extension(var_8_19, "ammo_system")
	local var_8_22 = var_8_20 or var_8_21

	if var_8_22 then
		local var_8_23 = var_8_22:clip_size()
		local var_8_24 = var_8_22:ammo_count()
		local var_8_25 = var_8_22:remaining_ammo()
		local var_8_26 = var_8_24 == 0
		local var_8_27 = var_8_24 == var_8_23
		local var_8_28 = 0

		if var_8_26 then
			var_8_28 = var_8_23
		elseif var_8_27 then
			if var_8_25 == 0 then
				var_8_28 = var_8_23
			elseif var_8_25 < var_8_23 then
				var_8_28 = var_8_23 - var_8_25
			end
		elseif var_8_25 == 0 then
			var_8_28 = var_8_23 - var_8_24 + var_8_23
		elseif var_8_25 < var_8_23 then
			var_8_28 = var_8_23 - var_8_24 + (var_8_23 - var_8_25)
		else
			var_8_28 = var_8_23 - var_8_24
		end

		var_8_22:add_ammo_to_reserve(var_8_28)

		if var_8_22:can_reload() then
			if var_8_26 then
				var_8_22:start_reload(true)
			else
				var_8_22:instant_reload(false, "reload")
			end
		end
	end

	local var_8_29 = arg_8_0._first_person_extension

	if var_8_2 then
		var_8_29:play_hud_sound_event("Play_career_ability_markus_huntsman_enter", nil, true)
		var_8_29:play_hud_sound_event("Play_career_ability_markus_huntsman_loop")
		var_8_29:animation_event("shade_stealth_ability")
		var_8_8:set_state("markus_activate_huntsman")
		Managers.state.camera:set_mood("skill_huntsman_surge", "skill_huntsman_surge", false)
		Managers.state.camera:set_mood("skill_huntsman_stealth", "skill_huntsman_stealth", true)
	end

	if not arg_8_1 then
		var_8_8:start_activated_ability_cooldown()
	end

	arg_8_0:_play_vo()
end

function CareerAbilityESHuntsman._play_vo(arg_9_0)
	local var_9_0 = arg_9_0.owner_unit
	local var_9_1 = ScriptUnit.extension_input(var_9_0, "dialogue_system")
	local var_9_2 = FrameTable.alloc_table()

	var_9_1:trigger_networked_dialogue_event("activate_ability", var_9_2)
end
