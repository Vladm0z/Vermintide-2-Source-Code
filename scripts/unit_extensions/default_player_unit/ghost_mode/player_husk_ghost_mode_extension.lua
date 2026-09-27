-- chunkname: @scripts/unit_extensions/default_player_unit/ghost_mode/player_husk_ghost_mode_extension.lua

PlayerHuskGhostModeExtension = class(PlayerHuskGhostModeExtension)

PlayerHuskGhostModeExtension.init = function (self, arg_1_1, arg_1_2, arg_1_3)
	-- function 1
	self._unit = arg_1_2
	self._world = arg_1_1.world
	self._network_transmit = arg_1_1.network_transmit
	self._is_server = self._network_transmit.is_server
	self._has_left_once = false
	self._ghost_mode_active = false
	self._is_husk = true
end

PlayerHuskGhostModeExtension.extensions_ready = function (self)
	-- function 2
	self._inventory_extension = ScriptUnit.extension(self._unit, "inventory_system")
	self._breed = Unit.get_data(self._unit, "breed")
end

PlayerHuskGhostModeExtension.destroy = function (self)
	-- function 3
	self:_clear_world_marker()
end

PlayerHuskGhostModeExtension.is_in_ghost_mode = function (self)
	-- function 4
	return self._ghost_mode_active
end

PlayerHuskGhostModeExtension.is_husk = function (self)
	-- function 5
	return self._is_husk
end

PlayerHuskGhostModeExtension._in_same_side_as_local_player = function (self)
	-- function 6
	if not DEDICATED_SERVER then
		return false
	end

	local local_player = Managers.player:local_player()
	local network_id = local_player:network_id()
	local local_player_id = local_player:local_player_id()
	local get_party_from_player_id = Managers.party:get_party_from_player_id(network_id, local_player_id)

	fassert(get_party_from_player_id, "local player not in a party")

	local var_6_4 = Managers.state.side.side_by_party[get_party_from_player_id]

	return Managers.state.side.side_by_unit[self._unit] == var_6_4
end

PlayerHuskGhostModeExtension._is_spectator = function (self)
	-- function 7
	if not DEDICATED_SERVER then
		return false
	end

	if self._is_spectator_cached ~= nil then
		return self._is_spectator_cached
	end

	local local_player = Managers.player:local_player()
	local network_id = local_player:network_id()
	local local_player_id = local_player:local_player_id()
	local get_party_from_player_id = Managers.party:get_party_from_player_id(network_id, local_player_id)

	fassert(get_party_from_player_id, "player not in a party")

	self._is_spectator_cached = get_party_from_player_id.name == "spectators"

	return self._is_spectator_cached
end

PlayerHuskGhostModeExtension.husk_enter_ghost_mode = function (self)
	-- function 8
	local _unit = self._unit

	self._ghost_mode_active = true

	local equipment = ScriptUnit.extension(self._unit, "inventory_system"):equipment()
	local right_hand_wielded_unit_3p = equipment.right_hand_wielded_unit_3p

	right_hand_wielded_unit_3p = right_hand_wielded_unit_3p or equipment.left_hand_wielded_unit_3p

	if not DEDICATED_SERVER then
		if not right_hand_wielded_unit_3p then
			Unit.flow_event(right_hand_wielded_unit_3p, "lua_entered_ghost_mode")
		end

		local get_third_person_mesh_unit = CosmeticsUtils.get_third_person_mesh_unit(_unit)

		if not self._has_left_once then
			World.create_particles(self._world, "fx/chr_gutter_foff", POSITION_LOOKUP[_unit])
		end

		Unit.flow_event(get_third_person_mesh_unit, "lua_entered_ghost_mode")
		Unit.flow_event(_unit, "lua_entered_ghost_mode")
	end

	ScriptUnit.extension(self._unit, "status_system"):set_ghost_mode(true)

	if not self:_in_same_side_as_local_player() then
		self:_add_world_marker()
	elseif not self:_is_spectator() then
		self._inventory_extension:show_third_person_inventory(false)
	end

	GhostModeSystem.set_sweep_actors(self._unit, self._breed, false)
	Managers.state.event:trigger("set_new_enemy_role")
	Managers.state.entity:system("dialogue_context_system"):set_context_value(self._unit, "is_in_ghost_mode", true)
end

PlayerHuskGhostModeExtension._add_world_marker = function (self)
	-- function 9
	self:_clear_world_marker()

	local var_9_0 = callback(self, "cb_world_marker_spawned", self._unit)

	Managers.state.event:trigger("add_world_marker_unit", "versus_pactsworn_ghostmode", self._unit, var_9_0)
end

PlayerHuskGhostModeExtension._clear_world_marker = function (self)
	-- function 10
	if not self._marker_id then
		Managers.state.event:trigger("remove_world_marker", self._marker_id)

		self._marker_id = nil
	end
end

PlayerHuskGhostModeExtension.cb_world_marker_spawned = function (self, arg_11_1, arg_11_2, arg_11_3)
	-- function 11
	local owner = Managers.player:owner(arg_11_1)
	local flag = not owner and owner:profile_index()
	local var_11_2 = SPProfiles[flag]
	local flag_2 = not owner and owner:name()

	flag_2 = not flag_2 and flag_2 ~= "" and flag_2 and "n/a"
	arg_11_3.content.player_name = flag_2

	local network_id = owner:network_id()
	local local_player_id = owner:local_player_id()
	local game_mode_data = Managers.party:get_player_status(network_id, local_player_id).game_mode_data
	local flag_3 = not game_mode_data and game_mode_data.spawn_timer

	if not flag_3 then
		arg_11_3.content.respawn_timer = flag_3
	end

	local content = arg_11_3.content
	local ui_portrait

	if not var_11_2 then
		ui_portrait = var_11_2.ui_portrait

		if not ui_portrait then
			-- Nothing
		end
	end

	ui_portrait = "unit_frame_portrait_default"

	::label_11_0::

	content.icon = ui_portrait
	self._marker_id = arg_11_2
end

PlayerHuskGhostModeExtension.husk_leave_ghost_mode = function (self)
	-- function 12
	self._ghost_mode_active = false
	self._has_left_once = true

	local _unit = self._unit
	local equipment = ScriptUnit.extension(_unit, "inventory_system"):equipment()
	local right_hand_wielded_unit_3p = equipment.right_hand_wielded_unit_3p

	right_hand_wielded_unit_3p = right_hand_wielded_unit_3p or equipment.left_hand_wielded_unit_3p

	local extension = ScriptUnit.extension(self._unit, "status_system")

	extension:set_ghost_mode(false)

	if not self:_in_same_side_as_local_player() then
		self:_clear_world_marker()
	elseif not (self:_is_spectator() or extension:get_unarmed()) then
		self._inventory_extension:show_third_person_inventory(true)
	end

	GhostModeSystem.set_sweep_actors(_unit, self._breed, true)

	if not DEDICATED_SERVER then
		if not right_hand_wielded_unit_3p then
			Unit.flow_event(right_hand_wielded_unit_3p, "lua_left_ghost_mode")
		end

		local get_third_person_mesh_unit = CosmeticsUtils.get_third_person_mesh_unit(_unit)

		Unit.flow_event(get_third_person_mesh_unit, "lua_left_ghost_mode")
		Unit.flow_event(_unit, "lua_left_ghost_mode")
	end

	if not self._is_server then
		ScriptUnit.extension_input(_unit, "dialogue_system"):trigger_dialogue_event("spawning")

		if self._has_played_boss_sound or not self._breed.boss then
			Managers.state.entity:system("dialogue_system"):queue_mission_giver_event("vs_mg_new_spawn_monster")

			self._has_played_boss_sound = true
		end
	end

	Managers.state.entity:system("dialogue_context_system"):set_context_value(_unit, "is_in_ghost_mode", false)
end

PlayerHuskGhostModeExtension.set_safe_spot = function (self, arg_13_1)
	-- function 13
	self._safe_spot = arg_13_1
end
