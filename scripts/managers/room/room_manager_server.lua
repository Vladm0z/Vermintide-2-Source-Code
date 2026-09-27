-- chunkname: @scripts/managers/room/room_manager_server.lua

require("scripts/managers/room/room_handler")

RoomManagerServer = class(RoomManagerServer)

RoomManagerServer.init = function (self, arg_1_1)
	-- function 1
	self._peer_rooms = {}
	self._room_order = {}
	self._room_handler = RoomHandler:new(arg_1_1)
end

RoomManagerServer.setup_level_anchor_points = function (self, arg_2_1)
	-- function 2
	self._room_handler:setup_level_anchor_points(arg_2_1)
end

RoomManagerServer.create_room = function (self, arg_3_1, arg_3_2)
	-- function 3
	local profile_by_peer = Managers.state.spawn._profile_synchronizer:profile_by_peer(arg_3_1, arg_3_2)
	local room_profile = SPProfiles[profile_by_peer].room_profile
	local create_room = self._room_handler:create_room(room_profile)

	self._peer_rooms[arg_3_1] = {
		room_id = create_room,
		profile_index = profile_by_peer
	}
	self._room_order[create_room] = arg_3_1

	Managers.state.network.network_transmit:send_rpc_clients("rpc_inn_room_created", arg_3_1, create_room, profile_by_peer)
end

RoomManagerServer.get_spawn_point_by_peer = function (self, arg_4_1)
	-- function 4
	return self._peer_rooms[arg_4_1].room_id
end

RoomManagerServer.has_room = function (self, arg_5_1)
	-- function 5
	local flag

	flag = not self._peer_rooms[arg_5_1] and true and false

	return flag
end

RoomManagerServer.destroy_room = function (self, arg_6_1, arg_6_2)
	-- function 6
	local room_id = self._peer_rooms[arg_6_1].room_id

	if not (not arg_6_2 and arg_6_2 == true or arg_6_2 ~= nil) then
		self:move_players_from_room(room_id)
	end

	self._room_handler:destroy_room(room_id)

	self._room_order[room_id] = nil
	self._peer_rooms[arg_6_1] = nil

	Managers.state.network.network_transmit:send_rpc_clients("rpc_inn_room_destroyed", arg_6_1)
end

RoomManagerServer.move_players_from_room = function (self, arg_7_1)
	-- function 7
	local level = self._room_handler:room_from_id(arg_7_1).level
	local network = Managers.state.network
	local spawn_points = Managers.state.spawn.spawn_points
	local human_players = Managers.player:human_players()

	for k, v in pairs(human_players) do
		repeat
			local player_unit = v.player_unit

			if not Unit.alive(player_unit) then
				break
			end

			if not network:unit_game_object_id(player_unit) then
				break
			end

			local var_7_5 = POSITION_LOOKUP[player_unit]

			if not Level.is_point_inside_volume(level, "room_volume", var_7_5) then
				local peer_id = v.peer_id
				local var_7_7 = spawn_points[self:get_spawn_point_by_peer(peer_id)]
				local unbox = var_7_7.pos:unbox()
				local unbox_2 = var_7_7.rot:unbox()

				if not v.local_player then
					ScriptUnit.extension(player_unit, "locomotion_system"):teleport_to(unbox, unbox_2)

					break
				end

				local unit_game_object_id = network:unit_game_object_id(player_unit)
				local var_7_11 = PEER_ID_TO_CHANNEL[peer_id]

				RPC.rpc_teleport_unit_to(var_7_11, unit_game_object_id, unbox, unbox_2)
			end
		until true
	end
end

RoomManagerServer.hot_join_sync = function (self, arg_8_1)
	-- function 8
	local var_8_0 = PEER_ID_TO_CHANNEL[arg_8_1]

	for k, v in pairs(self._peer_rooms) do
		local room_id = v.room_id
		local profile_index = v.profile_index

		RPC.rpc_inn_room_created(var_8_0, k, room_id, profile_index)
	end
end

RoomManagerServer.destroy = function (self)
	-- function 9
	self._room_handler:destroy()

	self._room_handler = nil
end
