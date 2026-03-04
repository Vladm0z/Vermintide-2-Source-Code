-- chunkname: @scripts/managers/game_mode/spawning_components/weave_spawning.lua

require("scripts/managers/game_mode/spawning_components/adventure_spawning")

WeaveSpawning = class(WeaveSpawning, AdventureSpawning)

function WeaveSpawning._get_spawn_position_close_to_server(arg_1_0)
	local var_1_0 = arg_1_0._side.party.occupied_slots
	local var_1_1 = Managers.player

	for iter_1_0 = 1, #var_1_0 do
		local var_1_2 = var_1_0[iter_1_0]
		local var_1_3 = var_1_2.peer_id
		local var_1_4 = var_1_2.local_player_id
		local var_1_5 = var_1_3 and var_1_4 and var_1_1:player(var_1_3, var_1_4)

		if var_1_5 and var_1_5.is_server and var_1_5.player_unit then
			return (ScriptUnit.extension(var_1_5.player_unit, "whereabouts_system"):last_position_onground_on_navmesh())
		end
	end
end

function WeaveSpawning._find_spawn_point(arg_2_0, arg_2_1)
	local var_2_0 = arg_2_1.game_mode_data
	local var_2_1 = arg_2_0:_get_spawn_position_close_to_server() or var_2_0.position:unbox()
	local var_2_2 = var_2_0.rotation:unbox()

	return var_2_1, var_2_2
end
