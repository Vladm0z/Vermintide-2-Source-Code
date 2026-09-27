-- chunkname: @scripts/unit_extensions/deus/deus_arena_interactable_extension.lua

DeusArenaInteractableExtension = class(DeusArenaInteractableExtension)

local tbl = {
	INTERACTED = 2,
	WAITING = 1
}
local tbl_2 = {
	"rpc_deus_set_arena_interactable_state"
}

DeusArenaInteractableExtension.init = function (self, arg_1_1, arg_1_2, arg_1_3)
	-- function 1
	self._unit = arg_1_2
	self._is_server = arg_1_1.is_server
	self._world = arg_1_1.world
	self._state = tbl.WAITING
	self._override_interactable_action = Unit.get_data(arg_1_2, "override_interactable_action")
	self._level_unit_id = Level.unit_index(LevelHelper:current_level(self._world), arg_1_2)

	self:register_rpcs(arg_1_1.network_transmit.network_event_delegate)
end

DeusArenaInteractableExtension.register_rpcs = function (self, arg_2_1)
	-- function 2
	self._network_event_delegate = arg_2_1

	arg_2_1:register(self, unpack(tbl_2))
end

DeusArenaInteractableExtension.unregister_rpcs = function (self)
	-- function 3
	if not self._network_event_delegate then
		self._network_event_delegate:unregister(self)
	end

	self._network_event_delegate = nil
end

DeusArenaInteractableExtension.destroy = function (self)
	-- function 4
	self:unregister_rpcs()
end

DeusArenaInteractableExtension.hot_join_sync = function (self, arg_5_1)
	-- function 5
	local _get_state = self:_get_state()

	Managers.state.network.network_transmit:send_rpc("rpc_deus_set_arena_interactable_state", arg_5_1, self._level_unit_id, _get_state)
end

DeusArenaInteractableExtension.update = function (self, arg_6_1, arg_6_2, arg_6_3, arg_6_4, arg_6_5)
	-- function 6
	local _prev_state = self._prev_state
	local _get_state = self:_get_state()

	if _prev_state ~= _get_state then
		self:_on_state_changed(_prev_state, _get_state)

		self._prev_state = _get_state
	end

	local _timer = self._timer

	if not (not _timer and not (_timer < arg_6_5)) then
		_timer = nil

		if not Unit.get_data(self._unit, "arena_interactable_data", "end_game") then
			Managers.state.game_mode:complete_level()
		end

		if not Unit.get_data(self._unit, "arena_interactable_data", "activate_end_zone") then
			local get_data = Unit.get_data(self._unit, "arena_interactable_data", "end_zone_name")

			assert(get_data, "[DeusArenaInteractableExtension] - [end_zone_name] is not set while [activate_end_zone]")
			Managers.state.entity:system("end_zone_system"):activate_end_zone_by_name(get_data)
		end
	end

	self._timer = _timer
end

DeusArenaInteractableExtension._on_state_changed = function (self, arg_7_1, arg_7_2)
	-- function 7
	local _unit = self._unit

	if arg_7_2 == tbl.WAITING then
		Unit.flow_event(_unit, "state_WAITING")
	elseif arg_7_2 == tbl.INTERACTED then
		Unit.flow_event(_unit, "state_INTERACTED")

		local get_data = Unit.get_data(_unit, "arena_interactable_data", "interact_level_event_name")

		if get_data ~= "default" then
			LevelHelper:flow_event(self._world, get_data)
		end
	end
end

DeusArenaInteractableExtension.rpc_deus_set_arena_interactable_state = function (self, arg_8_1, arg_8_2, arg_8_3)
	-- function 8
	if self._level_unit_id == arg_8_2 then
		self._state = arg_8_3
	end
end

DeusArenaInteractableExtension.can_interact = function (self)
	-- function 9
	return self:_get_state() == tbl.WAITING
end

DeusArenaInteractableExtension.get_interact_hud_description = function (arg_10_0)
	-- function 10
	if Managers.mechanism:game_mechanism():get_deus_run_controller():get_current_node().base_level == DEUS_LEVEL_SETTINGS.arena_citadel.base_level_name then
		return "deus_altar_hud_desc"
	else
		return "interaction_action_take"
	end
end

DeusArenaInteractableExtension.on_server_interact = function (self, arg_11_1, arg_11_2, arg_11_3, arg_11_4, arg_11_5, arg_11_6, arg_11_7)
	-- function 11
	if self:_get_state() == tbl.WAITING then
		if not HEALTH_ALIVE[arg_11_2] then
			local extension_input = ScriptUnit.extension_input(arg_11_2, "dialogue_system")
			local alloc_table = FrameTable.alloc_table()
			local get_data = Unit.get_data(self._unit, "arena_interactable_data", "interactor_vo_line")

			extension_input:trigger_dialogue_event(get_data, alloc_table)
		end

		self._timer = arg_11_6 + Unit.get_data(self._unit, "arena_interactable_data", "delay")

		LevelHelper:flow_event(self._world, "on_arena_end_triggered")
		self:_set_state(tbl.INTERACTED)
	end
end

DeusArenaInteractableExtension.on_client_interact = function (self, arg_12_1, arg_12_2, arg_12_3, arg_12_4, arg_12_5, arg_12_6, arg_12_7)
	-- function 12
	if not self._is_server then
		self._state = tbl.INTERACTED
	end
end

DeusArenaInteractableExtension._get_state = function (self)
	-- function 13
	return self._state
end

DeusArenaInteractableExtension._set_state = function (self, arg_14_1)
	-- function 14
	Managers.state.network.network_transmit:send_rpc_clients("rpc_deus_set_arena_interactable_state", self._level_unit_id, arg_14_1)

	self._state = arg_14_1
end

DeusArenaInteractableExtension.override_interactable_action = function (self)
	-- function 15
	return self._override_interactable_action
end
