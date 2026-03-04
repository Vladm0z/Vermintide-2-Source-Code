-- chunkname: @scripts/managers/room/room_manager_server.lua

require("scripts/managers/room/room_handler")

RoomManagerServer = class(RoomManagerServer)

RoomManagerServer.init = function (arg_1_0, arg_1_1)
	arg_1_0._peer_rooms = {}
	arg_1_0._room_order = {}
	arg_1_0._room_handler = RoomHandler:new(arg_1_1)
end

RoomManagerServer.setup_level_anchor_points = function (arg_2_0, arg_2_1)
	arg_2_0._room_handler:setup_level_anchor_points(arg_2_1)
end

RoomManagerServer.create_room = function (arg_3_0, arg_3_1, arg_3_2)
	local var_3_0 = Managers.state.spawn._profile_synchronizer:profile_by_peer(arg_3_1, arg_3_2)
	local var_3_1 = SPProfiles[var_3_0].room_profile
	local var_3_2 = arg_3_0._room_handler:create_room(var_3_1)

	arg_3_0._peer_rooms[arg_3_1] = {
		room_id = var_3_2,
		profile_index = var_3_0
	}
	arg_3_0._room_order[var_3_2] = arg_3_1

	Managers.state.network.network_transmit:send_rpc_clients("rpc_inn_room_created", arg_3_1, var_3_2, var_3_0)
end

RoomManagerServer.get_spawn_point_by_peer = function (arg_4_0, arg_4_1)
	return arg_4_0._peer_rooms[arg_4_1].room_id
end

RoomManagerServer.has_room = function (arg_5_0, arg_5_1)
	return arg_5_0._peer_rooms[arg_5_1] and true or false
end

RoomManagerServer.destroy_room = function (arg_6_0, arg_6_1, arg_6_2)
	local var_6_0 = arg_6_0._peer_rooms[arg_6_1].room_id

	if arg_6_2 and arg_6_2 == true or arg_6_2 == nil then
		arg_6_0:move_players_from_room(var_6_0)
	end

	arg_6_0._room_handler:destroy_room(var_6_0)

	arg_6_0._room_order[var_6_0] = nil
	arg_6_0._peer_rooms[arg_6_1] = nil

	Managers.state.network.network_transmit:send_rpc_clients("rpc_inn_room_destroyed", arg_6_1)
end

RoomManagerServer.move_players_from_room = function (arg_7_0, arg_7_1)
	local var_7_0 = arg_7_0._room_handler:room_from_id(arg_7_1).level
	local var_7_1 = Managers.state.network
	local var_7_2 = Managers.state.spawn.spawn_points
	local var_7_3 = Managers.player:human_players()

	for iter_7_0, iter_7_1 in pairs(var_7_3) do
		repeat
			local var_7_4 = iter_7_1.player_unit

			if not Unit.alive(var_7_4) then
				break
			end

			if not var_7_1:unit_game_object_id(var_7_4) then
				break
			end

			local var_7_5 = POSITION_LOOKUP[var_7_4]

			if Level.is_point_inside_volume(var_7_0, "room_volume", var_7_5) then
				local var_7_6 = iter_7_1.peer_id
				local var_7_7 = var_7_2[arg_7_0:get_spawn_point_by_peer(var_7_6)]
				local var_7_8 = var_7_7.pos:unbox()
				local var_7_9 = var_7_7.rot:unbox()

				if iter_7_1.local_player then
					ScriptUnit.extension(var_7_4, "locomotion_system"):teleport_to(var_7_8, var_7_9)

					break
				end

				local var_7_10 = var_7_1:unit_game_object_id(var_7_4)
				local var_7_11 = PEER_ID_TO_CHANNEL[var_7_6]

				RPC.rpc_teleport_unit_to(var_7_11, var_7_10, var_7_8, var_7_9)
			end
		until true
	end
end

RoomManagerServer.hot_join_sync = function (arg_8_0, arg_8_1)
	local var_8_0 = PEER_ID_TO_CHANNEL[arg_8_1]

	for iter_8_0, iter_8_1 in pairs(arg_8_0._peer_rooms) do
		local var_8_1 = iter_8_1.room_id
		local var_8_2 = iter_8_1.profile_index

		RPC.rpc_inn_room_created(var_8_0, iter_8_0, var_8_1, var_8_2)
	end
end

RoomManagerServer.destroy = function (arg_9_0)
	arg_9_0._room_handler:destroy()

	arg_9_0._room_handler = nil
end
