-- chunkname: @scripts/entity_system/systems/ghost_mode/ghost_mode_system.lua

require("scripts/unit_extensions/default_player_unit/ghost_mode/player_unit_ghost_mode_extension")
require("scripts/unit_extensions/default_player_unit/ghost_mode/player_husk_ghost_mode_extension")

GhostModeSystem = class(GhostModeSystem, ExtensionSystemBase)

local var_0_0 = {
	"rpc_entered_ghost_mode",
	"rpc_left_ghost_mode",
	"rpc_set_safe_spot"
}
local var_0_1 = {
	"PlayerUnitGhostModeExtension",
	"PlayerHuskGhostModeExtension"
}

GhostModeSystem.init = function (arg_1_0, arg_1_1, arg_1_2)
	GhostModeSystem.super.init(arg_1_0, arg_1_1, arg_1_2, var_0_1)

	arg_1_0._network_transmit = arg_1_1.network_transmit
	arg_1_0._is_server = arg_1_1.is_server
	arg_1_0._unit_extensions = {}

	local var_1_0 = arg_1_1.network_event_delegate

	arg_1_0._network_event_delegate = var_1_0
	arg_1_0._next_can_spawn_check = 0
	arg_1_0._enter_ghost_mode_allowance_check_time = 0
	arg_1_0._path_index = 0
	arg_1_0._safe_spot = nil

	var_1_0:register(arg_1_0, unpack(var_0_0))

	arg_1_0._active = false
end

GhostModeSystem.destroy = function (arg_2_0)
	arg_2_0._network_event_delegate:unregister(arg_2_0)

	arg_2_0._network_event_delegate = nil
end

GhostModeSystem.on_add_extension = function (arg_3_0, arg_3_1, arg_3_2, arg_3_3, arg_3_4)
	local var_3_0 = GhostModeSystem.super.on_add_extension(arg_3_0, arg_3_1, arg_3_2, arg_3_3, arg_3_4)

	arg_3_0._unit_extensions[arg_3_2] = var_3_0

	var_3_0:set_safe_spot(arg_3_0._safe_spot)

	return var_3_0
end

GhostModeSystem.on_remove_extension = function (arg_4_0, arg_4_1, arg_4_2)
	GhostModeSystem.super.on_remove_extension(arg_4_0, arg_4_1, arg_4_2)

	arg_4_0._unit_extensions[arg_4_1] = nil
end

GhostModeSystem.set_active = function (arg_5_0, arg_5_1)
	arg_5_0._active = arg_5_1
end

GhostModeSystem.update = function (arg_6_0, arg_6_1, arg_6_2)
	if arg_6_0._is_server and arg_6_0._active then
		arg_6_0:_update_safe_spot()
	end

	GhostModeSystem.super.update(arg_6_0, arg_6_1, arg_6_2)
end

local var_0_2 = "is_local_call"

GhostModeSystem._update_safe_spot = function (arg_7_0)
	local var_7_0 = Managers.state.conflict
	local var_7_1 = var_7_0.main_path_info.current_path_index

	if var_7_1 > arg_7_0._path_index then
		arg_7_0._path_index = var_7_1

		local var_7_2 = var_7_1 + 1
		local var_7_3 = var_7_0.main_path_info.main_paths

		if not var_7_3 then
			return
		end

		local var_7_4 = var_7_3[var_7_2]

		if not var_7_4 then
			return
		end

		local var_7_5 = var_7_4.nodes[1]:unbox()

		arg_7_0:rpc_set_safe_spot(var_0_2, var_7_5)
		arg_7_0._network_transmit:send_rpc_clients("rpc_set_safe_spot", var_7_5)
	end
end

GhostModeSystem.rpc_entered_ghost_mode = function (arg_8_0, arg_8_1, arg_8_2)
	local var_8_0 = arg_8_0.unit_storage:unit(arg_8_2)

	if not ALIVE[var_8_0] then
		return
	end

	if CHANNEL_TO_PEER_ID[arg_8_1] ~= Network.peer_id() then
		ScriptUnit.extension(var_8_0, "ghost_mode_system"):husk_enter_ghost_mode()
	end

	if arg_8_0._is_server then
		local var_8_1 = CHANNEL_TO_PEER_ID[arg_8_1]

		arg_8_0._network_transmit:send_rpc_clients_except("rpc_entered_ghost_mode", var_8_1, arg_8_2)
	end
end

GhostModeSystem.rpc_left_ghost_mode = function (arg_9_0, arg_9_1, arg_9_2)
	local var_9_0 = arg_9_0.unit_storage:unit(arg_9_2)

	if not ALIVE[var_9_0] then
		return
	end

	if CHANNEL_TO_PEER_ID[arg_9_1] ~= Network.peer_id() then
		ScriptUnit.extension(var_9_0, "ghost_mode_system"):husk_leave_ghost_mode()
	end

	if arg_9_0._is_server then
		local var_9_1 = CHANNEL_TO_PEER_ID[arg_9_1]

		arg_9_0._network_transmit:send_rpc_clients_except("rpc_left_ghost_mode", var_9_1, arg_9_2)
	end
end

GhostModeSystem.rpc_set_safe_spot = function (arg_10_0, arg_10_1, arg_10_2)
	arg_10_0._safe_spot = Vector3Box(arg_10_2)

	local var_10_0 = Managers.player:local_player()
	local var_10_1 = var_10_0 and var_10_0.player_unit

	if not var_10_1 then
		return
	end

	local var_10_2 = arg_10_0._unit_extensions[var_10_1]

	if not var_10_2 then
		return
	end

	var_10_2:set_safe_spot(arg_10_0._safe_spot)
end

GhostModeSystem.set_sweep_actors = function (arg_11_0, arg_11_1, arg_11_2)
	if arg_11_2 then
		Unit.enable_proximity_unit(arg_11_0)
	else
		Unit.disable_proximity_unit(arg_11_0)
	end

	local var_11_0 = arg_11_1.hit_zones

	for iter_11_0, iter_11_1 in pairs(var_11_0) do
		local var_11_1 = iter_11_1.actors

		if iter_11_0 ~= "afro" then
			for iter_11_2 = 1, #var_11_1 do
				local var_11_2 = var_11_1[iter_11_2]
				local var_11_3 = Unit.actor(arg_11_0, var_11_2)

				Actor.set_scene_query_enabled(var_11_3, arg_11_2)
			end
		end
	end
end

GhostModeSystem.test_actors = function (arg_12_0, arg_12_1)
	local var_12_0 = arg_12_1.hit_zones

	for iter_12_0, iter_12_1 in pairs(var_12_0) do
		local var_12_1 = iter_12_1.actors

		if iter_12_0 ~= "afro" then
			for iter_12_2 = 1, #var_12_1 do
				local var_12_2 = var_12_1[iter_12_2]
				local var_12_3 = Unit.actor(arg_12_0, var_12_2)

				if Actor.is_scene_query_enabled(var_12_3) then
					Debug.text("Actor %s is ON", var_12_2)
				end
			end
		end
	end
end

GhostModeSystem.hot_join_sync = function (arg_13_0, arg_13_1)
	if not arg_13_0._active then
		return
	end

	if arg_13_0._safe_spot then
		arg_13_0._network_transmit:send_rpc("rpc_set_safe_spot", arg_13_1, arg_13_0._safe_spot:unbox())
	end

	local var_13_0 = arg_13_0._unit_extensions

	for iter_13_0, iter_13_1 in pairs(var_13_0) do
		local var_13_1 = arg_13_0.unit_storage:go_id(iter_13_0)

		if var_13_1 then
			if iter_13_1:is_in_ghost_mode() then
				arg_13_0._network_transmit:send_rpc("rpc_entered_ghost_mode", arg_13_1, var_13_1)
			else
				arg_13_0._network_transmit:send_rpc("rpc_left_ghost_mode", arg_13_1, var_13_1)
			end
		end
	end
end
