-- chunkname: @scripts/unit_extensions/level/boss_door_extension.lua

BossDoorExtension = class(BossDoorExtension)

local var_0_0 = 30
local var_0_1 = 3
local var_0_2 = {
	chaos_troll = "lua_closed_troll",
	chaos_spawn = "lua_closed_stormfiend",
	beastmen_minotaur = "lua_closed_stormfiend",
	skaven_rat_ogre = "lua_closed_stormfiend",
	skaven_stormfiend = "lua_closed_stormfiend"
}

BossDoorExtension.init = function (arg_1_0, arg_1_1, arg_1_2, arg_1_3)
	local var_1_0 = arg_1_1.world

	arg_1_0.unit = arg_1_2
	arg_1_0.world = var_1_0
	arg_1_0.is_server = Managers.player.is_server
	arg_1_0.current_state = "open"
	arg_1_0.state_to_nav_obstacle_map = {}
	arg_1_0.ignore_umbra = not World.umbra_available(var_1_0)
	arg_1_0.breeds_failed_leaving_smart_object = {}
	arg_1_0.num_attackers = 0
	arg_1_0.animation_stop_time = 0
end

BossDoorExtension.extensions_ready = function (arg_2_0)
	return
end

BossDoorExtension.update_nav_obstacles = function (arg_3_0)
	local var_3_0 = arg_3_0.current_state
	local var_3_1 = arg_3_0.state_to_nav_obstacle_map

	for iter_3_0, iter_3_1 in pairs(var_3_1) do
		local var_3_2 = iter_3_0 == var_3_0

		GwNavBoxObstacle.set_does_trigger_tagvolume(iter_3_1, var_3_2)
	end
end

BossDoorExtension.set_door_state = function (arg_4_0, arg_4_1, arg_4_2)
	if arg_4_0.current_state == arg_4_1 then
		return
	end

	local var_4_0 = arg_4_0.unit
	local var_4_1 = arg_4_1 == "closed" and "lua_close" or "lua_open"

	Unit.flow_event(var_4_0, var_4_1)

	local var_4_2 = var_0_2[arg_4_2]

	if var_4_2 then
		Unit.flow_event(var_4_0, var_4_2)
	end

	local var_4_3

	var_4_3 = arg_4_1 == "closed"
	arg_4_0.current_state = arg_4_1
	arg_4_0.breed_name = arg_4_2
end

BossDoorExtension.get_current_state = function (arg_5_0)
	return arg_5_0.current_state
end

BossDoorExtension.update = function (arg_6_0, arg_6_1, arg_6_2, arg_6_3, arg_6_4, arg_6_5)
	local var_6_0 = arg_6_0.animation_stop_time

	if var_6_0 and var_6_0 <= arg_6_5 then
		arg_6_0:update_nav_obstacles()

		arg_6_0.animation_stop_time = nil
	end
end

BossDoorExtension.hot_join_sync = function (arg_7_0, arg_7_1)
	local var_7_0 = LevelHelper:current_level(arg_7_0.world)
	local var_7_1 = Level.unit_index(var_7_0, arg_7_0.unit)
	local var_7_2 = arg_7_0.current_state
	local var_7_3 = NetworkLookup.door_states[var_7_2]
	local var_7_4 = arg_7_0.breed_name or "n/a"
	local var_7_5 = NetworkLookup.breeds[var_7_4]
	local var_7_6 = PEER_ID_TO_CHANNEL[arg_7_1]

	RPC.rpc_sync_boss_door_state(var_7_6, var_7_1, var_7_3, var_7_5)
end

BossDoorExtension.destroy = function (arg_8_0)
	arg_8_0:destroy_box_obstacles()

	arg_8_0.unit = nil
	arg_8_0.world = nil
end

BossDoorExtension.destroy_box_obstacles = function (arg_9_0)
	if arg_9_0.state_to_nav_obstacle_map then
		for iter_9_0, iter_9_1 in pairs(arg_9_0.state_to_nav_obstacle_map) do
			GwNavBoxObstacle.destroy(iter_9_1)
		end

		arg_9_0.state_to_nav_obstacle_map = nil
	end
end

BossDoorExtension.animation_played = function (arg_10_0, arg_10_1, arg_10_2)
	local var_10_0 = arg_10_1 / var_0_0 / arg_10_2

	arg_10_0.animation_stop_time = Managers.time:time("game") + var_10_0
end

BossDoorExtension.is_open = function (arg_11_0)
	return arg_11_0.current_state == "open"
end
