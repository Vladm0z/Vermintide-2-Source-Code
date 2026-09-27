-- chunkname: @scripts/entity_system/systems/objective_socket/objective_socket_system.lua

require("scripts/unit_extensions/objective_socket/objective_socket_unit_extension")

ObjectiveSocketSystem = class(ObjectiveSocketSystem, ExtensionSystemBase)

local tbl = {
	"rpc_objective_entered_socket_zone"
}
local tbl_2 = {
	"ObjectiveSocketUnitExtension"
}

ObjectiveSocketSystem.init = function (self, arg_1_1, arg_1_2)
	-- function 1
	ObjectiveSocketSystem.super.init(self, arg_1_1, arg_1_2, tbl_2)

	local network_event_delegate = arg_1_1.network_event_delegate

	network_event_delegate:register(self, unpack(tbl))

	self.network_event_delegate = network_event_delegate
	self.network_manager = Managers.state.network
	self.socket_extensions = {}

	self.objective_entered_zone_server = function (self, arg_2_1)
		-- function 2
		local pick_socket, var_2_1 = self:pick_socket(arg_2_1)

		if not pick_socket then
			return
		end

		self:objective_entered_zone_client(var_2_1, arg_2_1)

		if not self.is_server then
			local game_object_or_level_id, var_2_3 = self.network_manager:game_object_or_level_id(self.unit)
			local has_extension = ScriptUnit.has_extension(arg_2_1, "limited_item_track_system")
			local flag

			flag = not has_extension and true and false

			self.network_manager.network_transmit:send_rpc_clients("rpc_objective_entered_socket_zone", game_object_or_level_id, var_2_1, var_2_3, flag)

			if not has_extension then
				local spawner_unit = has_extension.spawner_unit
				local has_extension_2 = ScriptUnit.has_extension(spawner_unit, "limited_item_track_system")

				if not has_extension_2 then
					has_extension_2:socket_item(arg_2_1)
				end
			end

			Managers.state.unit_spawner:mark_for_deletion(arg_2_1)
			Managers.state.achievement:trigger_event("objective_entered_socket_zone", false, flag)
		end
	end

	self.objective_entered_zone_client = function (self, arg_3_1, arg_3_2)
		-- function 3
		local socket_from_id = self:socket_from_id(arg_3_1)

		fassert(socket_from_id.open == true, "Socket was already occupied.")

		socket_from_id.open = false

		local num

		self.num_open_sockets, num = self.num_open_sockets - 1, self.num_closed_sockets + 1
		self.num_closed_sockets = num

		local has_extension = ScriptUnit.has_extension(arg_3_2, "projectile_locomotion_system")

		if not has_extension then
			local owner_peer_id = has_extension.owner_peer_id
			local player_from_peer_id = Managers.player:player_from_peer_id(owner_peer_id)
			local flag = not player_from_peer_id and player_from_peer_id.player_unit

			if not flag then
				self.owner_of_unit_that_occupied_socket[socket_from_id.socket_name] = flag
			end
		end

		local str = "lua_" .. socket_from_id.socket_name .. "_occupied"

		Unit.flow_event(self.unit, str)

		if num == self.num_sockets then
			Unit.flow_event(self.unit, "lua_all_sockets_occupied")
		end
	end
end

ObjectiveSocketSystem.destroy = function (self)
	-- function 4
	self.network_event_delegate:unregister(self)

	self.network_event_delegate = nil
	self.network_manager = nil
	self.socket_extensions = nil
end

ObjectiveSocketSystem.on_add_extension = function (self, arg_5_1, arg_5_2, arg_5_3, arg_5_4)
	-- function 5
	local on_add_extension = ObjectiveSocketSystem.super.on_add_extension(self, arg_5_1, arg_5_2, arg_5_3, arg_5_4, self.is_server)

	if not self.is_server then
		on_add_extension.objective_entered_zone_server = self.objective_entered_zone_server
	end

	on_add_extension.objective_entered_zone_client = self.objective_entered_zone_client
	on_add_extension.owner_of_unit_that_occupied_socket = {}

	fassert(self.socket_extensions[arg_5_2] == nil, "This unit already has a socket extension.")

	self.socket_extensions[arg_5_2] = on_add_extension

	return on_add_extension
end

ObjectiveSocketSystem.on_remove_extension = function (arg_6_0, arg_6_1, arg_6_2)
	-- function 6
	ObjectiveSocketSystem.super.on_remove_extension(arg_6_0, arg_6_1, arg_6_2)

	arg_6_0.socket_extensions[arg_6_1] = nil
end

ObjectiveSocketSystem.hot_join_sync = function (self, arg_7_1)
	-- function 7
	for k, v in pairs(self.socket_extensions) do
		local sockets = v.sockets
		local num_sockets = v.num_sockets
		local game_object_or_level_id, var_7_3 = self.network_manager:game_object_or_level_id(k)

		for k_2 = 1, num_sockets do
			if not sockets[k_2].open then
				local var_7_4 = PEER_ID_TO_CHANNEL[arg_7_1]

				RPC.rpc_objective_entered_socket_zone(var_7_4, game_object_or_level_id, k_2, var_7_3, false)
			end
		end
	end
end

ObjectiveSocketSystem.rpc_objective_entered_socket_zone = function (self, arg_8_1, arg_8_2, arg_8_3, arg_8_4, arg_8_5)
	-- function 8
	fassert(not self.is_server, "Should only be called on the client")

	local game_object_or_level_unit = self.network_manager:game_object_or_level_unit(arg_8_2, arg_8_4)

	if not arg_8_5 then
		Managers.state.achievement:trigger_event("objective_entered_socket_zone", false, arg_8_5)
	end

	ScriptUnit.extension(game_object_or_level_unit, "objective_socket_system"):objective_entered_zone_client(arg_8_3)
end

ObjectiveSocketSystem.get_owner_of_unit_that_occupied_socket = function (self, arg_9_1, arg_9_2)
	-- function 9
	return self.socket_extensions[arg_9_1].owner_of_unit_that_occupied_socket[arg_9_2]
end
