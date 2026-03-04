-- chunkname: @scripts/settings/dlcs/bless/passive_ability_warrior_priest.lua

PassiveAbilityWarriorPriest = class(PassiveAbilityWarriorPriest)

local var_0_0 = 6
local var_0_1 = Unit.animation_set_variable
local var_0_2 = GameSession.set_game_object_field
local var_0_3 = GameSession.game_object_field

PassiveAbilityWarriorPriest.init = function (arg_1_0, arg_1_1, arg_1_2, arg_1_3, arg_1_4)
	arg_1_0._owner_unit = arg_1_2
	arg_1_0._player = arg_1_3.player
	arg_1_0._ability_init_data = arg_1_4
	arg_1_0._is_active = false
	arg_1_0._not_in_combat = true
	arg_1_0._current_resource = 0
	arg_1_0._max_resource = 100
	arg_1_0._time_to_ooc = 5
	arg_1_0._activation_time = 0
	arg_1_0.uses_resource = true
	arg_1_0._is_local_human = arg_1_0._player.local_player
	arg_1_0._is_local_player = arg_1_0._is_local_human or arg_1_0._player.bot_player
	arg_1_0._game = Managers.state.network:game()
end

PassiveAbilityWarriorPriest.extensions_ready = function (arg_2_0, arg_2_1, arg_2_2)
	arg_2_0._buff_system = Managers.state.entity:system("buff_system")
	arg_2_0._talent_extension = ScriptUnit.has_extension(arg_2_2, "talent_system")
	arg_2_0._first_person_extension = ScriptUnit.has_extension(arg_2_2, "first_person_system")
	arg_2_0._inventory_extension = ScriptUnit.has_extension(arg_2_2, "inventory_system")

	if arg_2_0._first_person_extension then
		arg_2_0._fp_unit = arg_2_0._first_person_extension:get_first_person_unit()
		arg_2_0._anim_var_3p_id = Unit.animation_find_variable(arg_2_2, "talent_anim_type")

		arg_2_0:on_talents_changed(arg_2_2, arg_2_0._talent_extension)
	end

	arg_2_0:_register_events()
end

PassiveAbilityWarriorPriest.destroy = function (arg_3_0)
	arg_3_0:_unregister_events()
end

PassiveAbilityWarriorPriest._register_events = function (arg_4_0)
	Managers.state.event:register(arg_4_0, "on_player_killed_enemy", "on_player_killed_enemy")
	Managers.state.event:register(arg_4_0, "on_hit", "on_hit")
	Managers.state.event:register(arg_4_0, "on_weapon_wield", "on_weapon_wield")
	Managers.state.event:register(arg_4_0, "level_start_local_player_spawned", "on_level_start_local_player_spawned")
	Managers.state.event:register(arg_4_0, "on_talents_changed", "on_talents_changed")
end

PassiveAbilityWarriorPriest._unregister_events = function (arg_5_0)
	if Managers.state.event then
		Managers.state.event:unregister("on_player_killed_enemy", arg_5_0)
		Managers.state.event:unregister("on_hit", arg_5_0)
		Managers.state.event:unregister("on_weapon_wield", arg_5_0)
		Managers.state.event:unregister("level_start_local_player_spawned", arg_5_0)
		Managers.state.event:unregister("on_talents_changed", arg_5_0)
	end
end

PassiveAbilityWarriorPriest.update = function (arg_6_0, arg_6_1, arg_6_2)
	local var_6_0 = arg_6_0._game_object_id
	local var_6_1 = arg_6_0._game

	if var_6_1 and var_6_0 then
		if arg_6_0._is_local_player then
			local var_6_2 = arg_6_0._is_active

			if arg_6_0._prev_is_active ~= var_6_2 then
				arg_6_0._prev_is_active = var_6_2

				var_0_2(var_6_1, var_6_0, "fury_active", var_6_2)
			end
		else
			local var_6_3 = arg_6_0._is_active
			local var_6_4 = var_0_3(var_6_1, var_6_0, "fury_active")

			if var_6_3 ~= var_6_4 then
				arg_6_0._is_active = var_6_4

				arg_6_0:_set_fury_glow_enabled(var_6_4)
			end
		end
	end

	if arg_6_0._is_local_player then
		if (arg_6_0._is_active or arg_6_0._not_in_combat) and arg_6_0:degenerate_resource(arg_6_1) <= 0 then
			arg_6_0:deactivate_buff()
		end

		arg_6_0:combat_timer_update(arg_6_2)
	end
end

PassiveAbilityWarriorPriest.on_player_killed_enemy = function (arg_7_0, arg_7_1, arg_7_2, arg_7_3)
	if ScriptUnit.has_extension(arg_7_0._owner_unit, "status_system"):is_knocked_down() then
		return
	end

	if not arg_7_0._is_local_player then
		return
	end

	local var_7_0 = arg_7_0._owner_unit
	local var_7_1 = POSITION_LOOKUP[var_7_0]
	local var_7_2 = POSITION_LOOKUP[arg_7_3]
	local var_7_3 = Vector3.distance_squared(var_7_1, var_7_2)
	local var_7_4 = 6

	if var_7_3 > var_7_4 * var_7_4 then
		return
	end

	local var_7_5 = arg_7_0._ability_init_data.resource_per_breed
	local var_7_6 = var_7_5.on_normal

	if arg_7_2 and arg_7_2.elite then
		var_7_6 = var_7_5.on_elite
	elseif arg_7_2 and arg_7_2.special then
		var_7_6 = var_7_5.on_special
	elseif arg_7_2 and arg_7_2.boss then
		var_7_6 = var_7_5.on_boss
	end

	if arg_7_0._is_local_human then
		Managers.state.event:trigger("glow_feedback")
	end

	arg_7_0:modify_resource(var_7_6)
end

PassiveAbilityWarriorPriest.on_hit = function (arg_8_0, arg_8_1, arg_8_2, arg_8_3, arg_8_4, arg_8_5, arg_8_6, arg_8_7, arg_8_8)
	if arg_8_0._is_local_player and arg_8_8 == arg_8_0._owner_unit then
		arg_8_0:set_in_combat()
	end
end

PassiveAbilityWarriorPriest.buff_on_damage_taken = function (arg_9_0, arg_9_1, arg_9_2, arg_9_3)
	arg_9_0:modify_resource(arg_9_2)
end

PassiveAbilityWarriorPriest.modify_resource = function (arg_10_0, arg_10_1, arg_10_2)
	local var_10_0 = arg_10_0._current_resource ~= arg_10_0._max_resource

	if arg_10_1 > 0 then
		arg_10_0:set_in_combat()

		local var_10_1 = not arg_10_2 and Managers.state.difficulty:get_difficulty()

		if var_10_1 then
			arg_10_0._difficulty_rank = DifficultySettings[var_10_1].rank - 1
			arg_10_1 = arg_10_1 * ({
				1.5,
				1.2,
				1,
				1,
				1,
				1,
				0.7,
				1.5
			})[arg_10_0._difficulty_rank]
		end
	end

	arg_10_0._current_resource = math.clamp(arg_10_0._current_resource + arg_10_1, 0, arg_10_0._max_resource)

	if arg_10_0._current_resource >= arg_10_0._max_resource and var_10_0 then
		arg_10_0:activate_buff()
	end

	return arg_10_0._current_resource
end

PassiveAbilityWarriorPriest.modify_resource_percent = function (arg_11_0, arg_11_1)
	local var_11_0 = arg_11_0._max_resource * arg_11_1

	return arg_11_0:modify_resource(var_11_0, true)
end

PassiveAbilityWarriorPriest.get_resource_fraction = function (arg_12_0)
	return arg_12_0._current_resource / arg_12_0._max_resource
end

PassiveAbilityWarriorPriest.is_active = function (arg_13_0)
	return arg_13_0._is_active
end

PassiveAbilityWarriorPriest.degenerate_resource = function (arg_14_0, arg_14_1)
	return arg_14_0:modify_resource(-var_0_0 * arg_14_1)
end

PassiveAbilityWarriorPriest.set_in_combat = function (arg_15_0)
	arg_15_0._not_in_combat = false
	arg_15_0._combat_timer = Managers.time:time("game") + arg_15_0._time_to_ooc
end

PassiveAbilityWarriorPriest.combat_timer_update = function (arg_16_0, arg_16_1)
	if not arg_16_0._combat_timer then
		arg_16_0._combat_timer = arg_16_1 + arg_16_0._time_to_ooc
	end

	if arg_16_1 > arg_16_0._combat_timer then
		arg_16_0._not_in_combat = true
	end
end

PassiveAbilityWarriorPriest.activate_buff = function (arg_17_0)
	if not arg_17_0._is_active then
		arg_17_0._is_active = true
		arg_17_0._activation_time = Managers.time:time("game")

		local var_17_0 = arg_17_0._buff_system
		local var_17_1 = arg_17_0._owner_unit

		arg_17_0._buff_id = var_17_0:add_buff_synced(var_17_1, "victor_priest_passive_aftershock", BuffSyncType.LocalAndServer)

		Unit.flow_event(var_17_1, "lua_enable_eye_glow")
		arg_17_0:_set_fury_glow_enabled(true)

		if arg_17_0._ability_on_4_1 then
			ActionCareerWHPriestUtility.cast_spell(var_17_1, var_17_1)
		end

		if arg_17_0._is_local_human then
			arg_17_0:_play_vo()
			Managers.state.event:trigger("active_passive_feedback", true)
			Managers.state.achievement:trigger_event("righteous_fury_start", arg_17_0._owner_unit, arg_17_0._is_local_human)
		end
	end
end

PassiveAbilityWarriorPriest.deactivate_buff = function (arg_18_0)
	if arg_18_0._is_active then
		arg_18_0._is_active = false

		local var_18_0 = arg_18_0._buff_system
		local var_18_1 = arg_18_0._buff_id
		local var_18_2 = arg_18_0._owner_unit

		var_18_0:remove_buff_synced(var_18_2, var_18_1)
		Unit.flow_event(var_18_2, "lua_disable_eye_glow")
		arg_18_0:_set_fury_glow_enabled(false)

		if arg_18_0._is_local_human then
			Managers.state.event:trigger("active_passive_feedback", false)
			Managers.state.achievement:trigger_event("righteous_fury_end", arg_18_0._owner_unit, arg_18_0._is_local_human)
		end
	end
end

PassiveAbilityWarriorPriest._play_vo = function (arg_19_0)
	local var_19_0 = arg_19_0._owner_unit
	local var_19_1 = ScriptUnit.extension_input(var_19_0, "dialogue_system")
	local var_19_2 = FrameTable.alloc_table()

	var_19_1:trigger_networked_dialogue_event("activate_fury", var_19_2)
end

PassiveAbilityWarriorPriest._set_fury_glow_enabled = function (arg_20_0, arg_20_1)
	local var_20_0 = arg_20_1 and "lua_enable_eye_glow" or "lua_disable_eye_glow"
	local var_20_1 = arg_20_0._inventory_extension

	if arg_20_0._is_local_human then
		local var_20_2, var_20_3 = var_20_1:get_all_weapon_unit()

		if var_20_2 then
			Unit.flow_event(var_20_2, var_20_0)
		end

		if var_20_3 then
			Unit.flow_event(var_20_3, var_20_0)
		end
	end

	local var_20_4 = var_20_1:equipment()

	if var_20_4 then
		local var_20_5 = var_20_4.left_hand_wielded_unit_3p
		local var_20_6 = var_20_4.right_hand_wielded_unit_3p

		if var_20_5 then
			Unit.flow_event(var_20_5, var_20_0)
		end

		if var_20_6 then
			Unit.flow_event(var_20_6, var_20_0)
		end
	end

	Unit.flow_event(arg_20_0._owner_unit, var_20_0)
end

PassiveAbilityWarriorPriest.on_weapon_wield = function (arg_21_0, arg_21_1)
	arg_21_0:_set_fury_glow_enabled(arg_21_0._is_active)
end

PassiveAbilityWarriorPriest.on_level_start_local_player_spawned = function (arg_22_0, arg_22_1)
	if arg_22_0._is_local_player and not arg_22_0._game_object_id then
		arg_22_0:create_game_object()
	end
end

PassiveAbilityWarriorPriest.on_talents_changed = function (arg_23_0, arg_23_1, arg_23_2)
	if arg_23_1 ~= arg_23_0._owner_unit then
		return
	end

	local var_23_0 = 0

	if arg_23_2 then
		if arg_23_2:has_talent("victor_priest_6_1") then
			var_23_0 = 0
		elseif arg_23_2:has_talent("victor_priest_6_2") then
			var_23_0 = 1
		elseif arg_23_2:has_talent("victor_priest_6_3") then
			var_23_0 = 2
		end
	end

	arg_23_0._ability_on_4_1 = arg_23_2:has_talent("victor_priest_4_1_new")

	local var_23_1 = arg_23_0._fp_unit

	if ALIVE[var_23_1] then
		arg_23_0._first_person_extension:animation_set_variable("talent_anim_type", var_23_0)
	end

	local var_23_2 = arg_23_1

	if ALIVE[var_23_2] and arg_23_0._anim_var_3p_id then
		var_0_1(var_23_2, arg_23_0._anim_var_3p_id, var_23_0)
	end
end

PassiveAbilityWarriorPriest.create_game_object = function (arg_24_0)
	local var_24_0 = Managers.state.network
	local var_24_1 = arg_24_0._owner_unit
	local var_24_2 = var_24_0:unit_game_object_id(var_24_1)
	local var_24_3 = {
		go_type = NetworkLookup.go_types.priest_career_data,
		unit_game_object_id = var_24_2,
		fury_active = arg_24_0._is_active
	}
	local var_24_4 = callback(arg_24_0, "cb_game_session_disconnect")

	arg_24_0._game_object_id = var_24_0:create_game_object("priest_career_data", var_24_3, var_24_4)
end

PassiveAbilityWarriorPriest.set_career_game_object_id = function (arg_25_0, arg_25_1)
	arg_25_0._game_object_id = arg_25_1
end

PassiveAbilityWarriorPriest.cb_game_session_disconnect = function (arg_26_0)
	arg_26_0._game_object_id = nil
end
