-- chunkname: @scripts/settings/mutators/mutator_blessing_of_grimnir.lua

require("scripts/settings/dlcs/morris/deus_blessing_settings")

local var_0_0 = "blessing_of_grimnir_boss_buff"
local var_0_1 = "blessing_of_grimnir_player_buff"
local var_0_2 = {
	monster_killed = "Play_blessing_challenge_of_grimnir_activate"
}

local function var_0_3(arg_1_0)
	local var_1_0 = Managers.state.side:get_side_from_name("heroes").PLAYER_UNITS
	local var_1_1 = #var_1_0
	local var_1_2 = HEALTH_ALIVE
	local var_1_3 = Managers.state.entity:system("buff_system")
	local var_1_4 = false

	for iter_1_0 = 1, var_1_1 do
		local var_1_5 = var_1_0[iter_1_0]

		if var_1_2[var_1_5] then
			var_1_3:add_buff(var_1_5, arg_1_0, var_1_5, var_1_4)
		end
	end
end

return {
	display_name = DeusBlessingSettings.blessing_of_grimnir.display_name,
	description = DeusBlessingSettings.blessing_of_grimnir.description,
	icon = DeusBlessingSettings.blessing_of_grimnir.icon,
	server_start_function = function(arg_2_0, arg_2_1, arg_2_2)
		local var_2_0 = Managers.state.conflict

		if not var_2_0.enemy_recycler then
			return
		end

		local var_2_1 = var_2_0.enemy_recycler.main_path_events

		for iter_2_0, iter_2_1 in ipairs(var_2_1) do
			if iter_2_1[4].event_kind == "event_boss" then
				return
			end
		end

		local var_2_2 = var_2_0.level_analysis.terror_spawners.event_boss.spawners

		if #var_2_2 <= 0 then
			return
		end

		local var_2_3 = var_2_2[1]
		local var_2_4 = Unit.local_position(var_2_3[1], 0)
		local var_2_5 = Vector3Box(var_2_4)
		local var_2_6 = {
			event_kind = "event_boss"
		}
		local var_2_7 = CurrentBossSettings.boss_events.event_lookup.event_boss
		local var_2_8 = Managers.mechanism:get_level_seed("mutator")
		local var_2_9, var_2_10 = Math.next_random(var_2_8, 1, #var_2_7)
		local var_2_11 = var_2_7[var_2_10]

		var_2_0.enemy_recycler:add_main_path_terror_event(var_2_5, var_2_11, 45, var_2_6)
	end,
	server_update_function = function(arg_3_0, arg_3_1, arg_3_2, arg_3_3)
		if arg_3_1.unit_to_mark and Managers.state.network:game_object_or_level_id(arg_3_1.unit_to_mark) then
			local var_3_0 = arg_3_1.unit_to_mark

			arg_3_1.marked_unit = var_3_0
			arg_3_1.unit_to_mark = nil

			local var_3_1 = Managers.state.entity:system("buff_system")

			var_3_1:add_buff(var_3_0, "objective_unit", var_3_0)
			var_3_1:add_buff(var_3_0, var_0_0, var_3_0)

			local var_3_2 = BLACKBOARDS[var_3_0]

			var_3_2.optional_spawn_data = var_3_2.optional_spawn_data or {}
			var_3_2.optional_spawn_data.prevent_killed_enemy_dialogue = true

			local var_3_3 = Managers.state.entity:system("dialogue_system"):get_random_player()

			if var_3_3 then
				local var_3_4 = ScriptUnit.extension_input(var_3_3, "dialogue_system")
				local var_3_5 = FrameTable.alloc_table()

				var_3_4:trigger_dialogue_event("blessing_grimnir_monster_spotted", var_3_5)
			end
		end
	end,
	server_ai_spawned_function = function(arg_4_0, arg_4_1, arg_4_2)
		if arg_4_1.boss_spawned then
			return
		end

		if Unit.get_data(arg_4_2, "breed").boss then
			arg_4_1.boss_spawned = true
			arg_4_1.unit_to_mark = arg_4_2
		end
	end,
	server_ai_killed_function = function(arg_5_0, arg_5_1, arg_5_2, arg_5_3)
		if arg_5_2 == arg_5_1.marked_unit then
			var_0_3(var_0_1)

			arg_5_1.marked_unit = nil

			local var_5_0 = Managers.state.entity:system("dialogue_system"):get_random_player()

			if var_5_0 then
				local var_5_1 = ScriptUnit.extension_input(var_5_0, "dialogue_system")
				local var_5_2 = FrameTable.alloc_table()

				var_5_1:trigger_dialogue_event("blessing_grimnir_monster_killed", var_5_2)
			end

			Managers.state.entity:system("audio_system"):play_2d_audio_event(var_0_2.monster_killed)

			local var_5_3 = Network.peer_id()
			local var_5_4 = Managers.player:player_from_peer_id(var_5_3)
			local var_5_5 = var_5_4 and var_5_4.local_player

			if var_5_5 then
				Managers.state.event:trigger("add_coop_feedback", var_5_4:stats_id(), var_5_5, "collected_grimnir_reward", var_5_4, var_5_4)
			end
		end
	end
}
