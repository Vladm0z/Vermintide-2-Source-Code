-- chunkname: @scripts/entity_system/systems/round_started/round_started_system.lua

RoundStartedSystem = class(RoundStartedSystem, ExtensionSystemBase)

local var_0_0 = {
	"RoundStartedExtension"
}
local var_0_1 = {
	"rpc_round_started"
}

RoundStartedExtension = class(RoundStartedExtension)

function RoundStartedExtension.init(arg_1_0)
	return
end

function RoundStartedExtension.destroy(arg_2_0)
	return
end

function RoundStartedSystem.init(arg_3_0, arg_3_1, arg_3_2)
	arg_3_1.entity_manager:register_system(arg_3_0, arg_3_2, var_0_0)

	arg_3_0._is_server = arg_3_1.is_server
	arg_3_0._world = arg_3_1.world
	arg_3_0._network_event_delegate = arg_3_1.network_event_delegate

	arg_3_0._network_event_delegate:register(arg_3_0, unpack(var_0_1))

	arg_3_0._start_area = "start_area"
	arg_3_0._round_started = false
	arg_3_0._player_spawned = false
	arg_3_0._units = {}
	arg_3_0._player_moved_positions = {}
end

function RoundStartedSystem.destroy(arg_4_0)
	arg_4_0._network_event_delegate:unregister(arg_4_0)
end

function RoundStartedSystem.set_start_area(arg_5_0, arg_5_1)
	local var_5_0 = LevelHelper:current_level(arg_5_0._world)
	local var_5_1 = LevelHelper:current_level_settings(arg_5_0._world).level_name

	arg_5_0._start_area = arg_5_1
end

function RoundStartedSystem.on_add_extension(arg_6_0, arg_6_1, arg_6_2, arg_6_3, arg_6_4)
	ScriptUnit.add_extension(nil, arg_6_2, "RoundStartedExtension", arg_6_0.NAME, arg_6_4)

	local var_6_0 = ScriptUnit.extension(arg_6_2, arg_6_0.NAME)

	arg_6_0._units[arg_6_2] = var_6_0

	return var_6_0
end

function RoundStartedSystem.on_remove_extension(arg_7_0, arg_7_1, arg_7_2)
	ScriptUnit.remove_extension(arg_7_1, arg_7_0.NAME)

	arg_7_0._units[arg_7_1] = nil
end

function RoundStartedSystem.hot_join_sync(arg_8_0, arg_8_1, arg_8_2)
	return
end

function RoundStartedSystem.update(arg_9_0, arg_9_1, arg_9_2)
	if arg_9_0._round_started then
		return
	end

	arg_9_0:_update_player_moved()

	if not arg_9_0._is_server then
		return
	end

	if arg_9_0:_players_left_start_area() or arg_9_0._force_start_round then
		Managers.state.game_mode:round_started()

		local var_9_0 = LevelHelper:current_level_settings().score_type

		if var_9_0 then
			local var_9_1 = {
				start_time = arg_9_2
			}

			Managers.state.entity:system("leaderboard_system"):round_started(var_9_0, var_9_1)
		end

		arg_9_0:_on_round_started()
	end
end

function RoundStartedSystem._players_left_start_area(arg_10_0)
	local var_10_0 = Managers.state.spawn:checkpoint_data()
	local var_10_1 = var_10_0 and var_10_0.safe_zone_volume_name or arg_10_0._start_area
	local var_10_2 = LevelHelper:current_level(arg_10_0._world)

	if not Level.has_volume(var_10_2, var_10_1) then
		if script_data.debug_level then
			Application.warning("Level is missing start area.")
		end

		return arg_10_0._player_spawned
	end

	for iter_10_0, iter_10_1 in pairs(arg_10_0._units) do
		local var_10_3 = POSITION_LOOKUP[iter_10_0]

		if not Level.is_point_inside_volume(var_10_2, var_10_1, var_10_3) then
			return true
		end
	end

	return false
end

function RoundStartedSystem.player_spawned(arg_11_0)
	arg_11_0._player_spawned = true
end

function RoundStartedSystem.player_has_moved(arg_12_0)
	return arg_12_0._player_moved
end

function RoundStartedSystem.round_has_started(arg_13_0)
	return arg_13_0._round_started
end

function RoundStartedSystem._update_player_moved(arg_14_0)
	if arg_14_0._player_moved then
		return true
	end

	local var_14_0 = arg_14_0._player_moved_positions
	local var_14_1 = 2
	local var_14_2 = Managers.player:human_players()

	for iter_14_0, iter_14_1 in pairs(var_14_2) do
		local var_14_3 = iter_14_1.player_unit
		local var_14_4 = POSITION_LOOKUP[var_14_3]

		if var_14_4 then
			var_14_0[var_14_3] = var_14_0[var_14_3] or Vector3Box(var_14_4)

			if Vector3.distance_squared(var_14_4, var_14_0[var_14_3]:unbox()) > var_14_1^2 then
				arg_14_0._player_moved = true

				return true
			end
		end
	end
end

function RoundStartedSystem._on_round_started(arg_15_0)
	arg_15_0._round_started = true
	arg_15_0._player_moved = true

	Managers.state.achievement:trigger_event("on_round_started")

	if arg_15_0._is_server then
		Managers.state.network.network_transmit:send_rpc_clients("rpc_round_started")
	end
end

function RoundStartedSystem.rpc_round_started(arg_16_0)
	arg_16_0:_on_round_started()
end

function RoundStartedSystem.force_start_round(arg_17_0)
	arg_17_0._force_start_round = true
end
