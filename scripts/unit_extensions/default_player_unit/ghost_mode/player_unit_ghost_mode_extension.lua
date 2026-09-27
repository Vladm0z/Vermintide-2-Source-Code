-- chunkname: @scripts/unit_extensions/default_player_unit/ghost_mode/player_unit_ghost_mode_extension.lua

require("scripts/entity_system/systems/ghost_mode/ghost_mode_utils")

PlayerUnitGhostModeExtension = class(PlayerUnitGhostModeExtension)

PlayerUnitGhostModeExtension.init = function (self, arg_1_1, arg_1_2, arg_1_3)
	-- function 1
	self._unit = arg_1_2
	self._world = arg_1_1.world
	self._network_transmit = arg_1_1.network_transmit
	self._is_server = self._network_transmit.is_server
	self._unit_storage = arg_1_1.unit_storage
	self._teleport_target_unit = nil
	self._teleport_target_index_fallback = 1
	self._player = arg_1_3.player

	local side_id = arg_1_3.side_id

	self._side = Managers.state.side:get_side(side_id)

	fassert(self._side, "no side assigned.")

	self._allowed_to_leave = false
	self._ghost_mode_active = false
	self._allowed_to_enter = false
	self._reason_not_allowed_to_leave = nil
	self._reason_allowed_to_enter = nil

	self:_set_teleport_target_type("disabled")

	self._has_teleported = false
	self._has_left_once = false
	self._external_no_spawn_reasons = {}
	self._enter_ghost_mode_allowance_check_time = 0
	self._leave_ghost_mode_allowance_check_time = 0
	self._is_husk = false
	self._latest_range_update = math.huge
	self._range = math.huge
	self._minimum_spawn_distance = GameModeSettings.versus.dark_pact_minimum_spawn_distance
	self._prev_round_started = Managers.state.game_mode:is_round_started()
end

PlayerUnitGhostModeExtension.extensions_ready = function (self)
	-- function 2
	self._locomotion_extension = ScriptUnit.extension(self._unit, "locomotion_system")
	self._inventory_extension = ScriptUnit.extension(self._unit, "inventory_system")
	self._career_extension = ScriptUnit.extension(self._unit, "career_system")
	self._breed = Unit.get_data(self._unit, "breed")
end

PlayerUnitGhostModeExtension.game_object_initialized = function (self, arg_3_1, arg_3_2)
	-- function 3
	local flag = true

	if not flag then
		local flag_2 = false

		self:_enter_ghost_mode(flag_2)
	end
end

PlayerUnitGhostModeExtension.destroy = function (arg_4_0)
	-- function 4
	return
end

PlayerUnitGhostModeExtension.update = function (self, arg_5_1, arg_5_2, arg_5_3, arg_5_4, arg_5_5)
	-- function 5
	if not self:is_in_ghost_mode() then
		self:_update_allowed_to_leave(arg_5_5)
	else
		self:_update_allowed_to_enter(arg_5_5)
	end
end

PlayerUnitGhostModeExtension._update_allowed_to_leave = function (self, arg_6_1, arg_6_2)
	-- function 6
	local _unit = self._unit

	self._range = math.ceil(self:get_distance_from_players(_unit))

	if not (not self._range and self._range == self._latest_range_update) then
		Managers.state.event:trigger("update_range_to_spawn", self._range)

		self._latest_range_update = self._range
	end

	if not (arg_6_2 or not (arg_6_1 < self._leave_ghost_mode_allowance_check_time)) then
		return
	end

	self._leave_ghost_mode_allowance_check_time = arg_6_1 + 0.2

	local _world = self._world
	local always_allow_leave_ghost_mode = script_data.always_allow_leave_ghost_mode

	always_allow_leave_ghost_mode = always_allow_leave_ghost_mode or Development.parameter("disable_ghost_mode")

	local ENEMY_PLAYER_AND_BOT_UNITS = self._side.ENEMY_PLAYER_AND_BOT_UNITS
	local tbl = {}

	for i = 1, #ENEMY_PLAYER_AND_BOT_UNITS do
		local var_6_5 = ENEMY_PLAYER_AND_BOT_UNITS[i]

		if not ScriptUnit.extension(var_6_5, "status_system"):is_knocked_down() then
			tbl[#tbl + 1] = POSITION_LOOKUP[var_6_5]
		end
	end

	local get_data = World.get_data(_world, "physics_world")
	local in_line_of_sight_of_enemies = GhostModeUtils.in_line_of_sight_of_enemies(_unit, tbl, get_data)
	local profile_index = self._player:profile_index()
	local var_6_9 = SPProfiles[profile_index]
	local enemy_role = var_6_9.enemy_role

	enemy_role = not enemy_role and var_6_9.enemy_role == "boss"

	local in_range_of_enemies = GhostModeUtils.in_range_of_enemies(POSITION_LOOKUP[_unit], self._side, enemy_role)
	local pact_sworn_round_started = GhostModeUtils.pact_sworn_round_started(_unit)
	local enemy_players_using_transport = GhostModeUtils.enemy_players_using_transport(_unit)
	local in_safe_zone = GhostModeUtils.in_safe_zone(_unit)
	local _external_no_spawn_reason = self:_external_no_spawn_reason()
	local str = "player"

	if not (always_allow_leave_ghost_mode or enemy_players_using_transport or pact_sworn_round_started) then
		str = "disabled"
	end

	if str ~= self._teleport_target_type then
		self:_set_teleport_target_type(str)
	end

	local allowed_to_leave, var_6_18 = self:allowed_to_leave()
	local _player = self._player
	local get_player_status = Managers.party:get_player_status(_player.peer_id, _player:local_player_id())
	local spawn_timer

	if not get_player_status then
		spawn_timer = get_player_status.game_mode_data.spawn_timer

		if not spawn_timer then
			-- Nothing
		end
	end

	spawn_timer = 0

	::label_6_0::

	local str_2 = "allowed"

	if not enemy_players_using_transport then
		str_2 = "transport"
	elseif not in_range_of_enemies then
		str_2 = "range"
	elseif not in_line_of_sight_of_enemies then
		str_2 = "los"
	elseif spawn_timer - arg_6_1 > 0 then
		str_2 = "w8_to_spawn"
	elseif not pact_sworn_round_started then
		str_2 = "start_zone"
	elseif not in_safe_zone then
		str_2 = "in_safe_zone"
	elseif not _external_no_spawn_reason then
		str_2 = "external_no_spawn_reason"
	end

	if str_2 ~= var_6_18 then
		local flag = str_2 == "allowed"

		self:_set_allowed_to_leave(flag, str_2)

		if not self:is_in_ghost_mode() then
			self:_update_allowed_to_leave_ui()
		end
	end
end

PlayerUnitGhostModeExtension._update_allowed_to_enter = function (self, arg_7_1, arg_7_2)
	-- function 7
	if not (arg_7_2 or not (arg_7_1 < self._enter_ghost_mode_allowance_check_time)) then
		return
	end

	self._enter_ghost_mode_allowance_check_time = arg_7_1 + 0.2

	self:_update_allowed_to_leave(arg_7_1, true, true)

	local _unit = self._unit
	local enemy_players_using_transport = GhostModeUtils.enemy_players_using_transport(_unit)
	local far_enough_to_enter_ghost_mode = GhostModeUtils.far_enough_to_enter_ghost_mode(_unit)
	local extension = ScriptUnit.extension(_unit, "status_system")
	local flag = not not not HEALTH_ALIVE[_unit] or not extension:is_dead()
	local flag_2 = false
	local get_item_data_and_weapon_extensions, var_7_7, var_7_8 = CharacterStateHelper.get_item_data_and_weapon_extensions(self._inventory_extension)
	local get_current_action_data = CharacterStateHelper.get_current_action_data(var_7_8, var_7_7)

	if not get_current_action_data and not get_current_action_data.disallow_ghost_mode then
		flag_2 = true
	end

	local flag_3 = not flag and far_enough_to_enter_ghost_mode and not enemy_players_using_transport and not not flag_2 or self:allowed_to_leave()
	local allowed_to_enter, var_7_12 = self:allowed_to_enter()
	local flag_4

	flag_4 = (flag or not "dead" or not far_enough_to_enter_ghost_mode) and ("distance" or not enemy_players_using_transport and "transport" and not flag_2 or "blocking_action")

	if not (flag_3 ~= allowed_to_enter or flag_3 or flag_4 == var_7_12) then
		self:_set_allowed_to_enter(flag_3, flag_4)
	end
end

PlayerUnitGhostModeExtension._set_allowed_to_leave = function (self, arg_8_1, arg_8_2)
	-- function 8
	self._allowed_to_leave = arg_8_1
	self._reason_not_allowed_to_leave = arg_8_2
end

PlayerUnitGhostModeExtension._update_allowed_to_leave_ui = function (self, arg_9_1)
	-- function 9
	local _allowed_to_leave = self._allowed_to_leave
	local _reason_not_allowed_to_leave = self._reason_not_allowed_to_leave
	local is_round_started = Managers.state.game_mode:is_round_started()

	if not is_round_started then
		local _get_target_teleport_unit = self:_get_target_teleport_unit()

		Managers.state.event:trigger("add_gameplay_info_event", "ghost_catchup", true, nil, _get_target_teleport_unit)
	end

	if not _allowed_to_leave then
		Managers.state.event:trigger("add_gameplay_info_event", "ghost_spawn", true)

		if not arg_9_1 then
			self:_play_sound("versus_ghost_mode_spawn_indicator")
		end
	else
		if not is_round_started then
			Managers.state.event:trigger("add_gameplay_info_event", "hide_teleport", true, _reason_not_allowed_to_leave)
		end

		Managers.state.event:trigger("add_gameplay_info_event", "ghost_cantspawn", true, _reason_not_allowed_to_leave)
	end
end

PlayerUnitGhostModeExtension.get_distance_from_players = function (self, arg_10_1)
	-- function 10
	local ENEMY_PLAYER_AND_BOT_POSITIONS = self._side.ENEMY_PLAYER_AND_BOT_POSITIONS
	local var_10_1 = POSITION_LOOKUP[arg_10_1]
	local huge = math.huge
	local profile_index = self._player:profile_index()
	local var_10_4 = SPProfiles[profile_index]
	local enemy_role = var_10_4.enemy_role

	enemy_role = not enemy_role and var_10_4.enemy_role == "boss"

	local boss_minimum_spawn_distance

	if not enemy_role then
		boss_minimum_spawn_distance = GameModeSettings.versus.boss_minimum_spawn_distance

		if not boss_minimum_spawn_distance then
			-- Nothing
		end
	end

	boss_minimum_spawn_distance = GameModeSettings.versus.dark_pact_minimum_spawn_distance

	do
		local flag
	end

	::label_10_0::

	flag = not enemy_role and "boss_spawn_range_distance" and "special_spawn_range_distance"

	local mechanism_try_call, var_10_9, var_10_10 = Managers.mechanism:mechanism_try_call("get_custom_game_setting", flag)

	if not mechanism_try_call and not var_10_10 then
		boss_minimum_spawn_distance = var_10_9
	end

	for i = 1, #ENEMY_PLAYER_AND_BOT_POSITIONS do
		local var_10_11 = ENEMY_PLAYER_AND_BOT_POSITIONS[i]
		local distance = Vector3.distance(var_10_11, var_10_1)

		if not (not (distance < boss_minimum_spawn_distance) or not (distance < huge)) then
			huge = boss_minimum_spawn_distance - distance
		end
	end

	if not (huge < 0 or not (boss_minimum_spawn_distance < huge)) then
		return 0
	else
		return huge
	end
end

PlayerUnitGhostModeExtension.allowed_to_leave = function (self)
	-- function 11
	if not Development.parameter("disable_ghost_mode") then
		return true
	else
		return self._allowed_to_leave, self._reason_not_allowed_to_leave
	end
end

PlayerUnitGhostModeExtension._get_target_teleport_unit = function (self)
	-- function 12
	if not ALIVE[self._teleport_target_unit] then
		return self._teleport_target_unit
	end

	self:_progress_teleport_target()

	return self._teleport_target_unit
end

PlayerUnitGhostModeExtension._progress_teleport_target = function (self, arg_13_1)
	-- function 13
	local ENEMY_PLAYER_AND_BOT_UNITS = self._side.ENEMY_PLAYER_AND_BOT_UNITS
	local count = #ENEMY_PLAYER_AND_BOT_UNITS
	local var_13_2

	if not arg_13_1 then
		for i = 1, count do
			if ENEMY_PLAYER_AND_BOT_UNITS[i] == arg_13_1 then
				var_13_2 = i

				break
			end
		end
	end

	var_13_2 = var_13_2 or math.min(self._teleport_target_index_fallback, count)

	local index_wrapper = math.index_wrapper(var_13_2 + 1, count)

	self._teleport_target_unit = ENEMY_PLAYER_AND_BOT_UNITS[index_wrapper]
	self._teleport_target_index_fallback = index_wrapper
end

PlayerUnitGhostModeExtension._set_allowed_to_enter = function (self, arg_14_1, arg_14_2)
	-- function 14
	if not arg_14_1 then
		local _get_target_teleport_unit = self:_get_target_teleport_unit()

		Managers.state.event:trigger("add_gameplay_info_event", "ghost_catchup", true, nil, _get_target_teleport_unit)
		Managers.state.event:trigger("add_gameplay_info_event", "hide_text", true, nil, _get_target_teleport_unit)
	else
		Managers.state.event:trigger("add_gameplay_info_event", "ghost_catchup", false, nil)
		Managers.state.event:trigger("add_gameplay_info_event", "hide_teleport", true, nil)
	end

	self._allowed_to_enter = arg_14_1
	self._reason_allowed_to_enter = arg_14_2
end

PlayerUnitGhostModeExtension.allowed_to_enter = function (self)
	-- function 15
	return self._allowed_to_enter, self._reason_allowed_to_enter
end

PlayerUnitGhostModeExtension.is_in_ghost_mode = function (self)
	-- function 16
	return self._ghost_mode_active, self._has_left_once
end

PlayerUnitGhostModeExtension.is_husk = function (self)
	-- function 17
	return self._is_husk
end

PlayerUnitGhostModeExtension.teleport_player = function (self, arg_18_1)
	-- function 18
	if self._teleport_target_type == "player" then
		self:_teleport_to_next_enemy(arg_18_1)
	elseif self._teleport_target_type == "safe_spot" then
		self:_teleport_to_safe_spot()
	end
end

PlayerUnitGhostModeExtension._furthest_player_enemy_unit = function (self)
	-- function 19
	local var_19_0 = POSITION_LOOKUP[self._unit]
	local ENEMY_PLAYER_AND_BOT_UNITS = self._side.ENEMY_PLAYER_AND_BOT_UNITS
	local num = 0
	local var_19_3

	for i = 1, #ENEMY_PLAYER_AND_BOT_UNITS do
		local var_19_4 = POSITION_LOOKUP[ENEMY_PLAYER_AND_BOT_UNITS[i]]
		local distance_squared = Vector3.distance_squared(var_19_4, var_19_0)

		if num < distance_squared then
			num = distance_squared
			var_19_3 = ENEMY_PLAYER_AND_BOT_UNITS[i]
		end
	end

	return var_19_3
end

PlayerUnitGhostModeExtension._teleport_to_next_enemy = function (self, arg_20_1)
	-- function 20
	if #self._side.ENEMY_PLAYER_AND_BOT_UNITS == 0 then
		return
	end

	self:_set_allowed_to_leave(false, "los", true)

	local _furthest_player_enemy_unit

	if not arg_20_1 then
		_furthest_player_enemy_unit = self:_furthest_player_enemy_unit()

		if not _furthest_player_enemy_unit then
			-- Nothing
		end
	end

	_furthest_player_enemy_unit = self:_get_target_teleport_unit()

	::label_20_0::

	local num = POSITION_LOOKUP[_furthest_player_enemy_unit] + Vector3(0, 0, 0.2)

	self._locomotion_extension:teleport_to(num)

	self._has_teleported = true

	self:_progress_teleport_target(_furthest_player_enemy_unit)
	self:_update_allowed_to_leave_ui(true)
end

PlayerUnitGhostModeExtension._teleport_to_safe_spot = function (self)
	-- function 21
	self._locomotion_extension:teleport_to(self._safe_spot:unbox() + Vector3(0, 0, 0.2))
end

PlayerUnitGhostModeExtension._enter_ghost_mode = function (self, arg_22_1)
	-- function 22
	self._ghost_mode_active = true

	if not DEDICATED_SERVER then
		local get_third_person_mesh_unit = CosmeticsUtils.get_third_person_mesh_unit(self._unit)

		Unit.flow_event(get_third_person_mesh_unit, "lua_entered_ghost_mode")
	end

	local equipment = self._inventory_extension:equipment()
	local right_hand_wielded_unit = equipment.right_hand_wielded_unit

	right_hand_wielded_unit = right_hand_wielded_unit or equipment.left_hand_wielded_unit

	if DEDICATED_SERVER or not right_hand_wielded_unit then
		Unit.flow_event(right_hand_wielded_unit, "lua_entered_ghost_mode")
	end

	Managers.state.camera:set_mood("ghost_mode", self, true)

	if not arg_22_1 then
		local flag = true

		self:teleport_player(flag)
	end

	local extension = ScriptUnit.extension(self._unit, "status_system")

	extension:set_ghost_mode(true)
	extension:set_invisible(true, nil, "ghost_mode")
	GhostModeSystem.set_sweep_actors(self._unit, self._breed, false)
	self._locomotion_extension:set_mover_filter_property("dark_pact_noclip", true)

	local go_id = self._unit_storage:go_id(self._unit)

	if not self._is_server then
		self._network_transmit:send_rpc_clients("rpc_entered_ghost_mode", go_id)
	else
		self._network_transmit:send_rpc_server("rpc_entered_ghost_mode", go_id)
	end

	Managers.state.event:trigger("enter_ghostmode", true, self._unit)
	Managers.state.event:trigger("set_new_enemy_role")
	self:_play_sound("versus_enter_ghost_mode")
	Managers.state.entity:system("dialogue_context_system"):set_context_value(self._unit, "is_in_ghost_mode", true)
end

PlayerUnitGhostModeExtension._leave_ghost_mode = function (self)
	-- function 23
	self._ghost_mode_active = false
	self._has_teleported = false
	self._has_left_once = true

	local _unit = self._unit
	local equipment = self._inventory_extension:equipment()
	local right_hand_wielded_unit = equipment.right_hand_wielded_unit

	right_hand_wielded_unit = right_hand_wielded_unit or equipment.left_hand_wielded_unit

	local extension = ScriptUnit.extension(self._unit, "status_system")

	extension:set_ghost_mode(false)
	extension:set_invisible(false, nil, "ghost_mode")
	GhostModeSystem.set_sweep_actors(self._unit, self._breed, true)
	Managers.telemetry_events:left_ghost_mode(self._breed.name, POSITION_LOOKUP[self._unit])

	if not DEDICATED_SERVER then
		if not right_hand_wielded_unit then
			Unit.flow_event(right_hand_wielded_unit, "lua_left_ghost_mode")
		end

		local get_third_person_mesh_unit = CosmeticsUtils.get_third_person_mesh_unit(self._unit)

		Unit.flow_event(get_third_person_mesh_unit, "lua_left_ghost_mode")
	end

	Managers.state.camera:set_mood("ghost_mode", self, false)
	self._locomotion_extension:set_mover_filter_property("dark_pact_noclip", false)
	Managers.state.event:trigger("enter_ghostmode", false, _unit)
	Managers.state.event:trigger("add_gameplay_info_event", "hide_text", true, {
		"los",
		"start_zone",
		"transport"
	})

	if not self._display_equipment then
		self._display_equipment = true
	end

	self:_play_sound("menu_versus_pactsworn_spawn")

	if not self._is_server then
		ScriptUnit.extension_input(_unit, "dialogue_system"):trigger_dialogue_event("spawning")

		if self._has_played_boss_sound or not self._breed.boss then
			Managers.state.entity:system("dialogue_system"):queue_mission_giver_event("vs_mg_new_spawn_monster")

			self._has_played_boss_sound = true
		end
	end

	local go_id = self._unit_storage:go_id(self._unit)

	if not self._is_server then
		self._network_transmit:send_rpc_clients("rpc_left_ghost_mode", go_id)
	else
		self._network_transmit:send_rpc_server("rpc_left_ghost_mode", go_id)
	end

	Managers.state.entity:system("dialogue_context_system"):set_context_value(_unit, "is_in_ghost_mode", false)

	local profile_index = self._career_extension:profile_index()
	local career_index = self._career_extension:career_index()
	local get_abilities = CareerUtils.get_abilities(profile_index, career_index)

	for i = 1, #get_abilities do
		if not get_abilities[i].unpause_on_leave_ghost_mode then
			self._career_extension:set_activated_ability_cooldown_unpaused(i)
		end
	end
end

PlayerUnitGhostModeExtension.try_enter_ghost_mode = function (self)
	-- function 24
	fassert(not self:is_in_ghost_mode(), "In ghost mode already.")

	local time = Managers.time:time("game")

	self:_update_allowed_to_enter(time, true)

	if not self:allowed_to_enter() then
		local flag = true

		self:_enter_ghost_mode(flag)
	end
end

PlayerUnitGhostModeExtension.try_leave_ghost_mode = function (self, arg_25_1)
	-- function 25
	fassert(self:is_in_ghost_mode(), "In ghost mode already.")

	local time = Managers.time:time("game")

	self:_update_allowed_to_leave(time, true)

	if arg_25_1 or not self:allowed_to_leave() then
		self:_leave_ghost_mode()
	end
end

PlayerUnitGhostModeExtension.set_safe_spot = function (self, arg_26_1)
	-- function 26
	self._safe_spot = arg_26_1
end

PlayerUnitGhostModeExtension._set_teleport_target_type = function (self, arg_27_1)
	-- function 27
	if not (not self:allowed_to_enter() and arg_27_1 == "player") then
		print(self:allowed_to_enter(), arg_27_1)
		Crashify.print_exception("GhostModeSystem", "Allowed to enter ghost mode while not allowed to teleport.")
	end

	self._teleport_target_type = arg_27_1
end

PlayerUnitGhostModeExtension._play_sound = function (arg_28_0, arg_28_1)
	-- function 28
	local world = Managers.world:world("level_world")
	local wwise_world = Managers.world:wwise_world(world)

	WwiseWorld.trigger_event(wwise_world, arg_28_1)
end

PlayerUnitGhostModeExtension.set_external_no_spawn_reason = function (self, arg_29_1, arg_29_2)
	-- function 29
	self._external_no_spawn_reasons[arg_29_1] = arg_29_2 or nil

	local time = Managers.time:time("game")
	local flag = true

	self:_update_allowed_to_leave(time, flag)
end

PlayerUnitGhostModeExtension._external_no_spawn_reason = function (self)
	-- function 30
	return next(self._external_no_spawn_reasons)
end
