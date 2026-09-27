-- chunkname: @scripts/entity_system/systems/ghost_mode/ghost_mode_system.lua

require("scripts/unit_extensions/default_player_unit/ghost_mode/player_unit_ghost_mode_extension")
require("scripts/unit_extensions/default_player_unit/ghost_mode/player_husk_ghost_mode_extension")

GhostModeSystem = class(GhostModeSystem, ExtensionSystemBase)

local tbl = {
	"rpc_entered_ghost_mode",
	"rpc_left_ghost_mode",
	"rpc_set_safe_spot"
}
local tbl_2 = {
	"PlayerUnitGhostModeExtension",
	"PlayerHuskGhostModeExtension"
}

GhostModeSystem.init = function (self, arg_1_1, arg_1_2)
	-- function 1
	GhostModeSystem.super.init(self, arg_1_1, arg_1_2, tbl_2)

	self._network_transmit = arg_1_1.network_transmit
	self._is_server = arg_1_1.is_server
	self._unit_extensions = {}

	local network_event_delegate = arg_1_1.network_event_delegate

	self._network_event_delegate = network_event_delegate
	self._next_can_spawn_check = 0
	self._enter_ghost_mode_allowance_check_time = 0
	self._path_index = 0
	self._safe_spot = nil

	network_event_delegate:register(self, unpack(tbl))

	self._active = false
end

GhostModeSystem.destroy = function (self)
	-- function 2
	self._network_event_delegate:unregister(self)

	self._network_event_delegate = nil
end

GhostModeSystem.on_add_extension = function (self, arg_3_1, arg_3_2, arg_3_3, arg_3_4)
	-- function 3
	local on_add_extension = GhostModeSystem.super.on_add_extension(self, arg_3_1, arg_3_2, arg_3_3, arg_3_4)

	self._unit_extensions[arg_3_2] = on_add_extension

	on_add_extension:set_safe_spot(self._safe_spot)

	return on_add_extension
end

GhostModeSystem.on_remove_extension = function (arg_4_0, arg_4_1, arg_4_2)
	-- function 4
	GhostModeSystem.super.on_remove_extension(arg_4_0, arg_4_1, arg_4_2)

	arg_4_0._unit_extensions[arg_4_1] = nil
end

GhostModeSystem.set_active = function (self, arg_5_1)
	-- function 5
	self._active = arg_5_1
end

GhostModeSystem.update = function (self, arg_6_1, arg_6_2)
	-- function 6
	if not self._is_server and not self._active then
		self:_update_safe_spot()
	end

	GhostModeSystem.super.update(self, arg_6_1, arg_6_2)
end

local str = "is_local_call"

GhostModeSystem._update_safe_spot = function (self)
	-- function 7
	local conflict = Managers.state.conflict
	local current_path_index = conflict.main_path_info.current_path_index

	if current_path_index > self._path_index then
		self._path_index = current_path_index

		local num = current_path_index + 1
		local main_paths = conflict.main_path_info.main_paths

		if not main_paths then
			return
		end

		local var_7_4 = main_paths[num]

		if not var_7_4 then
			return
		end

		local unbox = var_7_4.nodes[1]:unbox()

		self:rpc_set_safe_spot(str, unbox)
		self._network_transmit:send_rpc_clients("rpc_set_safe_spot", unbox)
	end
end

GhostModeSystem.rpc_entered_ghost_mode = function (self, arg_8_1, arg_8_2)
	-- function 8
	local unit = self.unit_storage:unit(arg_8_2)

	if not ALIVE[unit] then
		return
	end

	if CHANNEL_TO_PEER_ID[arg_8_1] ~= Network.peer_id() then
		ScriptUnit.extension(unit, "ghost_mode_system"):husk_enter_ghost_mode()
	end

	if not self._is_server then
		local var_8_1 = CHANNEL_TO_PEER_ID[arg_8_1]

		self._network_transmit:send_rpc_clients_except("rpc_entered_ghost_mode", var_8_1, arg_8_2)
	end
end

GhostModeSystem.rpc_left_ghost_mode = function (self, arg_9_1, arg_9_2)
	-- function 9
	local unit = self.unit_storage:unit(arg_9_2)

	if not ALIVE[unit] then
		return
	end

	if CHANNEL_TO_PEER_ID[arg_9_1] ~= Network.peer_id() then
		ScriptUnit.extension(unit, "ghost_mode_system"):husk_leave_ghost_mode()
	end

	if not self._is_server then
		local var_9_1 = CHANNEL_TO_PEER_ID[arg_9_1]

		self._network_transmit:send_rpc_clients_except("rpc_left_ghost_mode", var_9_1, arg_9_2)
	end
end

GhostModeSystem.rpc_set_safe_spot = function (self, arg_10_1, arg_10_2)
	-- function 10
	self._safe_spot = Vector3Box(arg_10_2)

	local local_player = Managers.player:local_player()
	local flag = not local_player and local_player.player_unit

	if not flag then
		return
	end

	local var_10_2 = self._unit_extensions[flag]

	if not var_10_2 then
		return
	end

	var_10_2:set_safe_spot(self._safe_spot)
end

GhostModeSystem.set_sweep_actors = function (arg_11_0, arg_11_1, arg_11_2)
	-- function 11
	if not arg_11_2 then
		Unit.enable_proximity_unit(arg_11_0)
	else
		Unit.disable_proximity_unit(arg_11_0)
	end

	local hit_zones = arg_11_1.hit_zones

	for k, v in pairs(hit_zones) do
		local actors = v.actors

		if k ~= "afro" then
			for k_2 = 1, #actors do
				local var_11_2 = actors[k_2]
				local actor = Unit.actor(arg_11_0, var_11_2)

				Actor.set_scene_query_enabled(actor, arg_11_2)
			end
		end
	end
end

GhostModeSystem.test_actors = function (arg_12_0, arg_12_1)
	-- function 12
	local hit_zones = arg_12_1.hit_zones

	for k, v in pairs(hit_zones) do
		local actors = v.actors

		if k ~= "afro" then
			for k_2 = 1, #actors do
				local var_12_2 = actors[k_2]
				local actor = Unit.actor(arg_12_0, var_12_2)

				if not Actor.is_scene_query_enabled(actor) then
					Debug.text("Actor %s is ON", var_12_2)
				end
			end
		end
	end
end

GhostModeSystem.hot_join_sync = function (self, arg_13_1)
	-- function 13
	if not self._active then
		return
	end

	if not self._safe_spot then
		self._network_transmit:send_rpc("rpc_set_safe_spot", arg_13_1, self._safe_spot:unbox())
	end

	local _unit_extensions = self._unit_extensions

	for k, v in pairs(_unit_extensions) do
		local go_id = self.unit_storage:go_id(k)

		if not go_id then
			if not v:is_in_ghost_mode() then
				self._network_transmit:send_rpc("rpc_entered_ghost_mode", arg_13_1, go_id)
			else
				self._network_transmit:send_rpc("rpc_left_ghost_mode", arg_13_1, go_id)
			end
		end
	end
end
