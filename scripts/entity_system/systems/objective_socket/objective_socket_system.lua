-- chunkname: @scripts/entity_system/systems/objective_socket/objective_socket_system.lua

require("scripts/unit_extensions/objective_socket/objective_socket_unit_extension")

ObjectiveSocketSystem = class(ObjectiveSocketSystem, ExtensionSystemBase)

local var_0_0 = {
	"rpc_objective_entered_socket_zone"
}
local var_0_1 = {
	"ObjectiveSocketUnitExtension"
}

ObjectiveSocketSystem.init = function (arg_1_0, arg_1_1, arg_1_2)
	ObjectiveSocketSystem.super.init(arg_1_0, arg_1_1, arg_1_2, var_0_1)

	local var_1_0 = arg_1_1.network_event_delegate

	var_1_0:register(arg_1_0, unpack(var_0_0))

	arg_1_0.network_event_delegate = var_1_0
	arg_1_0.network_manager = Managers.state.network
	arg_1_0.socket_extensions = {}

	arg_1_0.objective_entered_zone_server = function (arg_2_0, arg_2_1)
		local var_2_0, var_2_1 = arg_2_0:pick_socket(arg_2_1)

		if not var_2_0 then
			return
		end

		arg_2_0:objective_entered_zone_client(var_2_1, arg_2_1)

		if arg_1_0.is_server then
			local var_2_2, var_2_3 = arg_1_0.network_manager:game_object_or_level_id(arg_2_0.unit)
			local var_2_4 = ScriptUnit.has_extension(arg_2_1, "limited_item_track_system")
			local var_2_5 = var_2_4 and true or false

			arg_1_0.network_manager.network_transmit:send_rpc_clients("rpc_objective_entered_socket_zone", var_2_2, var_2_1, var_2_3, var_2_5)

			if var_2_4 then
				local var_2_6 = var_2_4.spawner_unit
				local var_2_7 = ScriptUnit.has_extension(var_2_6, "limited_item_track_system")

				if var_2_7 then
					var_2_7:socket_item(arg_2_1)
				end
			end

			Managers.state.unit_spawner:mark_for_deletion(arg_2_1)
			Managers.state.achievement:trigger_event("objective_entered_socket_zone", false, var_2_5)
		end
	end

	arg_1_0.objective_entered_zone_client = function (arg_3_0, arg_3_1, arg_3_2)
		local var_3_0 = arg_3_0:socket_from_id(arg_3_1)

		fassert(var_3_0.open == true, "Socket was already occupied.")

		var_3_0.open = false

		local var_3_1

		arg_3_0.num_open_sockets, var_3_1 = arg_3_0.num_open_sockets - 1, arg_3_0.num_closed_sockets + 1
		arg_3_0.num_closed_sockets = var_3_1

		local var_3_2 = ScriptUnit.has_extension(arg_3_2, "projectile_locomotion_system")

		if var_3_2 then
			local var_3_3 = var_3_2.owner_peer_id
			local var_3_4 = Managers.player:player_from_peer_id(var_3_3)
			local var_3_5 = var_3_4 and var_3_4.player_unit

			if var_3_5 then
				arg_3_0.owner_of_unit_that_occupied_socket[var_3_0.socket_name] = var_3_5
			end
		end

		local var_3_6 = "lua_" .. var_3_0.socket_name .. "_occupied"

		Unit.flow_event(arg_3_0.unit, var_3_6)

		if var_3_1 == arg_3_0.num_sockets then
			Unit.flow_event(arg_3_0.unit, "lua_all_sockets_occupied")
		end
	end
end

ObjectiveSocketSystem.destroy = function (arg_4_0)
	arg_4_0.network_event_delegate:unregister(arg_4_0)

	arg_4_0.network_event_delegate = nil
	arg_4_0.network_manager = nil
	arg_4_0.socket_extensions = nil
end

ObjectiveSocketSystem.on_add_extension = function (arg_5_0, arg_5_1, arg_5_2, arg_5_3, arg_5_4)
	local var_5_0 = ObjectiveSocketSystem.super.on_add_extension(arg_5_0, arg_5_1, arg_5_2, arg_5_3, arg_5_4, arg_5_0.is_server)

	if arg_5_0.is_server then
		var_5_0.objective_entered_zone_server = arg_5_0.objective_entered_zone_server
	end

	var_5_0.objective_entered_zone_client = arg_5_0.objective_entered_zone_client
	var_5_0.owner_of_unit_that_occupied_socket = {}

	fassert(arg_5_0.socket_extensions[arg_5_2] == nil, "This unit already has a socket extension.")

	arg_5_0.socket_extensions[arg_5_2] = var_5_0

	return var_5_0
end

ObjectiveSocketSystem.on_remove_extension = function (arg_6_0, arg_6_1, arg_6_2)
	ObjectiveSocketSystem.super.on_remove_extension(arg_6_0, arg_6_1, arg_6_2)

	arg_6_0.socket_extensions[arg_6_1] = nil
end

ObjectiveSocketSystem.hot_join_sync = function (arg_7_0, arg_7_1)
	for iter_7_0, iter_7_1 in pairs(arg_7_0.socket_extensions) do
		local var_7_0 = iter_7_1.sockets
		local var_7_1 = iter_7_1.num_sockets
		local var_7_2, var_7_3 = arg_7_0.network_manager:game_object_or_level_id(iter_7_0)

		for iter_7_2 = 1, var_7_1 do
			if not var_7_0[iter_7_2].open then
				local var_7_4 = PEER_ID_TO_CHANNEL[arg_7_1]

				RPC.rpc_objective_entered_socket_zone(var_7_4, var_7_2, iter_7_2, var_7_3, false)
			end
		end
	end
end

ObjectiveSocketSystem.rpc_objective_entered_socket_zone = function (arg_8_0, arg_8_1, arg_8_2, arg_8_3, arg_8_4, arg_8_5)
	fassert(not arg_8_0.is_server, "Should only be called on the client")

	local var_8_0 = arg_8_0.network_manager:game_object_or_level_unit(arg_8_2, arg_8_4)

	if arg_8_5 then
		Managers.state.achievement:trigger_event("objective_entered_socket_zone", false, arg_8_5)
	end

	ScriptUnit.extension(var_8_0, "objective_socket_system"):objective_entered_zone_client(arg_8_3)
end

ObjectiveSocketSystem.get_owner_of_unit_that_occupied_socket = function (arg_9_0, arg_9_1, arg_9_2)
	return arg_9_0.socket_extensions[arg_9_1].owner_of_unit_that_occupied_socket[arg_9_2]
end
