-- chunkname: @scripts/managers/game_mode/spawning_components/weave_spawning.lua

require("scripts/managers/game_mode/spawning_components/adventure_spawning")

WeaveSpawning = class(WeaveSpawning, AdventureSpawning)

WeaveSpawning._get_spawn_position_close_to_server = function (self)
	-- function 1
	local occupied_slots = self._side.party.occupied_slots
	local player = Managers.player

	for i = 1, #occupied_slots do
		local var_1_2 = occupied_slots[i]
		local peer_id = var_1_2.peer_id
		local local_player_id = var_1_2.local_player_id
		local flag = not peer_id and not local_player_id and player:player(peer_id, local_player_id)

		if not flag and not flag.is_server and not flag.player_unit then
			return (ScriptUnit.extension(flag.player_unit, "whereabouts_system"):last_position_onground_on_navmesh())
		end
	end
end

WeaveSpawning._find_spawn_point = function (self, arg_2_1)
	-- function 2
	local game_mode_data = arg_2_1.game_mode_data
	local _get_spawn_position_close_to_server = self:_get_spawn_position_close_to_server()

	_get_spawn_position_close_to_server = _get_spawn_position_close_to_server or game_mode_data.position:unbox()

	local unbox = game_mode_data.rotation:unbox()

	return _get_spawn_position_close_to_server, unbox
end
