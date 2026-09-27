-- chunkname: @scripts/settings/mutators/mutator_blessing_of_grimnir.lua

require("scripts/settings/dlcs/morris/deus_blessing_settings")

local str = "blessing_of_grimnir_boss_buff"
local str_2 = "blessing_of_grimnir_player_buff"
local tbl = {
	monster_killed = "Play_blessing_challenge_of_grimnir_activate"
}

local function fn(arg_1_0)
	-- function 1
	local PLAYER_UNITS = Managers.state.side:get_side_from_name("heroes").PLAYER_UNITS
	local count = #PLAYER_UNITS
	local HEALTH_ALIVE = HEALTH_ALIVE
	local system = Managers.state.entity:system("buff_system")
	local flag = false

	for i = 1, count do
		local var_1_5 = PLAYER_UNITS[i]

		if not HEALTH_ALIVE[var_1_5] then
			system:add_buff(var_1_5, arg_1_0, var_1_5, flag)
		end
	end
end

return {
	display_name = DeusBlessingSettings.blessing_of_grimnir.display_name,
	description = DeusBlessingSettings.blessing_of_grimnir.description,
	icon = DeusBlessingSettings.blessing_of_grimnir.icon,
	server_start_function = function (arg_2_0, arg_2_1, arg_2_2)
		-- function 2
		local conflict = Managers.state.conflict

		if not conflict.enemy_recycler then
			return
		end

		local main_path_events = conflict.enemy_recycler.main_path_events

		for i, v in ipairs(main_path_events) do
			if v[4].event_kind == "event_boss" then
				return
			end
		end

		local spawners = conflict.level_analysis.terror_spawners.event_boss.spawners

		if #spawners <= 0 then
			return
		end

		local var_2_3 = spawners[1]
		local local_position = Unit.local_position(var_2_3[1], 0)
		local var_2_5 = Vector3Box(local_position)
		local tbl = {
			event_kind = "event_boss"
		}
		local event_boss = CurrentBossSettings.boss_events.event_lookup.event_boss
		local get_level_seed = Managers.mechanism:get_level_seed("mutator")
		local next_random, var_2_10 = Math.next_random(get_level_seed, 1, #event_boss)
		local var_2_11 = event_boss[var_2_10]

		conflict.enemy_recycler:add_main_path_terror_event(var_2_5, var_2_11, 45, tbl)
	end,
	server_update_function = function (arg_3_0, arg_3_1, arg_3_2, arg_3_3)
		-- function 3
		if not arg_3_1.unit_to_mark and not Managers.state.network:game_object_or_level_id(arg_3_1.unit_to_mark) then
			local unit_to_mark = arg_3_1.unit_to_mark

			arg_3_1.marked_unit = unit_to_mark
			arg_3_1.unit_to_mark = nil

			local system = Managers.state.entity:system("buff_system")

			system:add_buff(unit_to_mark, "objective_unit", unit_to_mark)
			system:add_buff(unit_to_mark, str, unit_to_mark)

			local var_3_2 = BLACKBOARDS[unit_to_mark]
			local optional_spawn_data = var_3_2.optional_spawn_data

			optional_spawn_data = optional_spawn_data or {}
			var_3_2.optional_spawn_data = optional_spawn_data
			var_3_2.optional_spawn_data.prevent_killed_enemy_dialogue = true

			local get_random_player = Managers.state.entity:system("dialogue_system"):get_random_player()

			if not get_random_player then
				local extension_input = ScriptUnit.extension_input(get_random_player, "dialogue_system")
				local alloc_table = FrameTable.alloc_table()

				extension_input:trigger_dialogue_event("blessing_grimnir_monster_spotted", alloc_table)
			end
		end
	end,
	server_ai_spawned_function = function (arg_4_0, arg_4_1, arg_4_2)
		-- function 4
		if not arg_4_1.boss_spawned then
			return
		end

		if not Unit.get_data(arg_4_2, "breed").boss then
			arg_4_1.boss_spawned = true
			arg_4_1.unit_to_mark = arg_4_2
		end
	end,
	server_ai_killed_function = function (arg_5_0, arg_5_1, arg_5_2, arg_5_3)
		-- function 5
		if arg_5_2 == arg_5_1.marked_unit then
			fn(str_2)

			arg_5_1.marked_unit = nil

			local get_random_player = Managers.state.entity:system("dialogue_system"):get_random_player()

			if not get_random_player then
				local extension_input = ScriptUnit.extension_input(get_random_player, "dialogue_system")
				local alloc_table = FrameTable.alloc_table()

				extension_input:trigger_dialogue_event("blessing_grimnir_monster_killed", alloc_table)
			end

			Managers.state.entity:system("audio_system"):play_2d_audio_event(tbl.monster_killed)

			local peer_id = Network.peer_id()
			local player_from_peer_id = Managers.player:player_from_peer_id(peer_id)
			local flag = not player_from_peer_id and player_from_peer_id.local_player

			if not flag then
				Managers.state.event:trigger("add_coop_feedback", player_from_peer_id:stats_id(), flag, "collected_grimnir_reward", player_from_peer_id, player_from_peer_id)
			end
		end
	end
}
