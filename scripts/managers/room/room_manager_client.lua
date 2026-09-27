-- chunkname: @scripts/managers/room/room_manager_client.lua

require("scripts/managers/room/room_handler")

RoomManagerClient = class(RoomManagerClient)

local tbl = {
	"rpc_inn_room_created",
	"rpc_inn_room_destroyed"
}

RoomManagerClient.init = function (self, arg_1_1, arg_1_2)
	-- function 1
	self._peer_rooms = {}
	self._room_order = {}
	self._room_handler = RoomHandler:new(arg_1_1)

	arg_1_2:register(self, unpack(tbl))

	self._network_event_delegate = arg_1_2
end

RoomManagerClient.setup_level_anchor_points = function (self, arg_2_1)
	-- function 2
	self._room_handler:setup_level_anchor_points(arg_2_1)
end

RoomManagerClient.create_room = function (self, arg_3_1, arg_3_2, arg_3_3)
	-- function 3
	local var_3_0 = SPProfiles[arg_3_3]

	if not self._peer_rooms[arg_3_1] then
		return
	end

	local room_profile = var_3_0.room_profile

	self._room_handler:create_room(room_profile, arg_3_2)

	self._peer_rooms[arg_3_1] = {
		room_id = arg_3_2
	}
	self._room_order[arg_3_2] = arg_3_1
end

RoomManagerClient.destroy_room = function (self, arg_4_1)
	-- function 4
	local var_4_0 = self._peer_rooms[arg_4_1]

	self._room_handler:destroy_room(var_4_0.room_id)

	self._room_order[var_4_0.room_id] = nil
	self._peer_rooms[arg_4_1] = nil
end

RoomManagerClient.destroy = function (self)
	-- function 5
	self._room_handler:destroy()

	self._room_handler = nil

	self._network_event_delegate:unregister(self)

	self._network_event_delegate = nil
end

RoomManagerClient.rpc_inn_room_created = function (self, arg_6_1, arg_6_2, arg_6_3, arg_6_4)
	-- function 6
	self:create_room(arg_6_2, arg_6_3, arg_6_4)
end

RoomManagerClient.rpc_inn_room_destroyed = function (self, arg_7_1, arg_7_2)
	-- function 7
	self:destroy_room(arg_7_2)
end

RoomManagerClient.get_spawn_point_by_peer = function (self, arg_8_1)
	-- function 8
	return self._peer_rooms[arg_8_1].room_id
end
