-- chunkname: @scripts/unit_extensions/default_player_unit/ghost_mode/player_husk_ghost_mode_extension.lua

PlayerHuskGhostModeExtension = class(PlayerHuskGhostModeExtension)

PlayerHuskGhostModeExtension.init = function (arg_1_0, arg_1_1, arg_1_2, arg_1_3)
	arg_1_0._unit = arg_1_2
	arg_1_0._world = arg_1_1.world
	arg_1_0._network_transmit = arg_1_1.network_transmit
	arg_1_0._is_server = arg_1_0._network_transmit.is_server
	arg_1_0._has_left_once = false
	arg_1_0._ghost_mode_active = false
	arg_1_0._is_husk = true
end

PlayerHuskGhostModeExtension.extensions_ready = function (arg_2_0)
	arg_2_0._inventory_extension = ScriptUnit.extension(arg_2_0._unit, "inventory_system")
	arg_2_0._breed = Unit.get_data(arg_2_0._unit, "breed")
end

PlayerHuskGhostModeExtension.destroy = function (arg_3_0)
	arg_3_0:_clear_world_marker()
end

PlayerHuskGhostModeExtension.is_in_ghost_mode = function (arg_4_0)
	return arg_4_0._ghost_mode_active
end

PlayerHuskGhostModeExtension.is_husk = function (arg_5_0)
	return arg_5_0._is_husk
end

PlayerHuskGhostModeExtension._in_same_side_as_local_player = function (arg_6_0)
	if DEDICATED_SERVER then
		return false
	end

	local var_6_0 = Managers.player:local_player()
	local var_6_1 = var_6_0:network_id()
	local var_6_2 = var_6_0:local_player_id()
	local var_6_3 = Managers.party:get_party_from_player_id(var_6_1, var_6_2)

	fassert(var_6_3, "local player not in a party")

	local var_6_4 = Managers.state.side.side_by_party[var_6_3]

	return Managers.state.side.side_by_unit[arg_6_0._unit] == var_6_4
end

PlayerHuskGhostModeExtension._is_spectator = function (arg_7_0)
	if DEDICATED_SERVER then
		return false
	end

	if arg_7_0._is_spectator_cached ~= nil then
		return arg_7_0._is_spectator_cached
	end

	local var_7_0 = Managers.player:local_player()
	local var_7_1 = var_7_0:network_id()
	local var_7_2 = var_7_0:local_player_id()
	local var_7_3 = Managers.party:get_party_from_player_id(var_7_1, var_7_2)

	fassert(var_7_3, "player not in a party")

	arg_7_0._is_spectator_cached = var_7_3.name == "spectators"

	return arg_7_0._is_spectator_cached
end

PlayerHuskGhostModeExtension.husk_enter_ghost_mode = function (arg_8_0)
	local var_8_0 = arg_8_0._unit

	arg_8_0._ghost_mode_active = true

	local var_8_1 = ScriptUnit.extension(arg_8_0._unit, "inventory_system"):equipment()
	local var_8_2 = var_8_1.right_hand_wielded_unit_3p or var_8_1.left_hand_wielded_unit_3p

	if not DEDICATED_SERVER then
		if var_8_2 then
			Unit.flow_event(var_8_2, "lua_entered_ghost_mode")
		end

		local var_8_3 = CosmeticsUtils.get_third_person_mesh_unit(var_8_0)

		if arg_8_0._has_left_once then
			World.create_particles(arg_8_0._world, "fx/chr_gutter_foff", POSITION_LOOKUP[var_8_0])
		end

		Unit.flow_event(var_8_3, "lua_entered_ghost_mode")
		Unit.flow_event(var_8_0, "lua_entered_ghost_mode")
	end

	ScriptUnit.extension(arg_8_0._unit, "status_system"):set_ghost_mode(true)

	if arg_8_0:_in_same_side_as_local_player() then
		arg_8_0:_add_world_marker()
	elseif not arg_8_0:_is_spectator() then
		arg_8_0._inventory_extension:show_third_person_inventory(false)
	end

	GhostModeSystem.set_sweep_actors(arg_8_0._unit, arg_8_0._breed, false)
	Managers.state.event:trigger("set_new_enemy_role")
	Managers.state.entity:system("dialogue_context_system"):set_context_value(arg_8_0._unit, "is_in_ghost_mode", true)
end

PlayerHuskGhostModeExtension._add_world_marker = function (arg_9_0)
	arg_9_0:_clear_world_marker()

	local var_9_0 = callback(arg_9_0, "cb_world_marker_spawned", arg_9_0._unit)

	Managers.state.event:trigger("add_world_marker_unit", "versus_pactsworn_ghostmode", arg_9_0._unit, var_9_0)
end

PlayerHuskGhostModeExtension._clear_world_marker = function (arg_10_0)
	if arg_10_0._marker_id then
		Managers.state.event:trigger("remove_world_marker", arg_10_0._marker_id)

		arg_10_0._marker_id = nil
	end
end

PlayerHuskGhostModeExtension.cb_world_marker_spawned = function (arg_11_0, arg_11_1, arg_11_2, arg_11_3)
	local var_11_0 = Managers.player:owner(arg_11_1)
	local var_11_1 = var_11_0 and var_11_0:profile_index()
	local var_11_2 = SPProfiles[var_11_1]
	local var_11_3 = var_11_0 and var_11_0:name()

	var_11_3 = var_11_3 and var_11_3 ~= "" and var_11_3 or "n/a"
	arg_11_3.content.player_name = var_11_3

	local var_11_4 = var_11_0:network_id()
	local var_11_5 = var_11_0:local_player_id()
	local var_11_6 = Managers.party:get_player_status(var_11_4, var_11_5).game_mode_data
	local var_11_7 = var_11_6 and var_11_6.spawn_timer

	if var_11_7 then
		arg_11_3.content.respawn_timer = var_11_7
	end

	arg_11_3.content.icon = var_11_2 and var_11_2.ui_portrait or "unit_frame_portrait_default"
	arg_11_0._marker_id = arg_11_2
end

PlayerHuskGhostModeExtension.husk_leave_ghost_mode = function (arg_12_0)
	arg_12_0._ghost_mode_active = false
	arg_12_0._has_left_once = true

	local var_12_0 = arg_12_0._unit
	local var_12_1 = ScriptUnit.extension(var_12_0, "inventory_system"):equipment()
	local var_12_2 = var_12_1.right_hand_wielded_unit_3p or var_12_1.left_hand_wielded_unit_3p
	local var_12_3 = ScriptUnit.extension(arg_12_0._unit, "status_system")

	var_12_3:set_ghost_mode(false)

	if arg_12_0:_in_same_side_as_local_player() then
		arg_12_0:_clear_world_marker()
	elseif not arg_12_0:_is_spectator() and not var_12_3:get_unarmed() then
		arg_12_0._inventory_extension:show_third_person_inventory(true)
	end

	GhostModeSystem.set_sweep_actors(var_12_0, arg_12_0._breed, true)

	if not DEDICATED_SERVER then
		if var_12_2 then
			Unit.flow_event(var_12_2, "lua_left_ghost_mode")
		end

		local var_12_4 = CosmeticsUtils.get_third_person_mesh_unit(var_12_0)

		Unit.flow_event(var_12_4, "lua_left_ghost_mode")
		Unit.flow_event(var_12_0, "lua_left_ghost_mode")
	end

	if arg_12_0._is_server then
		ScriptUnit.extension_input(var_12_0, "dialogue_system"):trigger_dialogue_event("spawning")

		if not arg_12_0._has_played_boss_sound and arg_12_0._breed.boss then
			Managers.state.entity:system("dialogue_system"):queue_mission_giver_event("vs_mg_new_spawn_monster")

			arg_12_0._has_played_boss_sound = true
		end
	end

	Managers.state.entity:system("dialogue_context_system"):set_context_value(var_12_0, "is_in_ghost_mode", false)
end

PlayerHuskGhostModeExtension.set_safe_spot = function (arg_13_0, arg_13_1)
	arg_13_0._safe_spot = arg_13_1
end
