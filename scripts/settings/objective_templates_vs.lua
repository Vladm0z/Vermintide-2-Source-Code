-- chunkname: @scripts/settings/objective_templates_vs.lua

require("scripts/settings/objective_lists")

VersusObjectiveSettings = {
	bell_pvp = {
		num_sets = 2,
		round_timer = 1800,
		objective_lists = {
			"bell_pvp_set_1",
			"bell_pvp_set_2"
		}
	},
	military_pvp = {
		num_sets = 3,
		round_timer = 1800,
		objective_lists = {
			"military_pvp_set_1",
			"military_pvp_set_2",
			"military_pvp_set_3"
		}
	},
	farmlands_pvp = {
		num_sets = 2,
		round_timer = 1800,
		objective_lists = {
			"farmlands_pvp_set_1",
			"farmlands_pvp_set_2"
		}
	},
	fort_pvp = {
		num_sets = 3,
		round_timer = 1800,
		objective_lists = {
			"fort_pvp_set_1",
			"fort_pvp_set_2",
			"fort_pvp_set_3"
		}
	},
	forest_ambush_pvp = {
		num_sets = 3,
		round_timer = 1800,
		objective_lists = {
			"forest_ambush_pvp_set_1",
			"forest_ambush_pvp_set_2",
			"forest_ambush_pvp_set_3"
		}
	},
	dwarf_exterior_pvp = {
		num_sets = 3,
		round_timer = 1800,
		objective_lists = {
			"dwarf_exterior_pvp_set_1",
			"dwarf_exterior_pvp_set_2",
			"dwarf_exterior_pvp_set_3"
		}
	}
}

local var_0_0 = {
	always_show_objective_marker = true,
	mission_name = true,
	play_safehouse_vo = true,
	play_waystone_vo = true,
	play_arrive_vo = true,
	score_for_each_player_inside = true,
	objective_tag = true,
	play_complete_vo = true,
	close_to_win_on_sub_objective = true,
	play_dialogue_event_on_complete = true,
	score_for_completion = true,
	capture_time = true,
	dialogue_event = true,
	close_to_win_on_completion = true,
	almost_done = true,
	description = true,
	on_leaf_complete_sound_event = true,
	num_sections = true,
	num_sockets = true,
	objective_type = true,
	vo_context_on_activate = true,
	volume_name = true,
	on_last_leaf_complete_sound_event = true,
	sub_objectives = true,
	score_per_socket = true,
	time_for_completion = true,
	close_to_win_on_section = true,
	vo_context_on_complete = true,
	score_per_section = true,
	volume_type = {
		all_alive = true,
		any_alive = true
	}
}

local function var_0_1(arg_1_0, arg_1_1)
	local var_1_0 = 999
	local var_1_1

	for iter_1_0, iter_1_1 in pairs(arg_1_1) do
		local var_1_2 = string.damerau_levenshtein_distance(iter_1_0, arg_1_0, 5)

		if var_1_2 < var_1_0 then
			var_1_0 = var_1_2
			var_1_1 = iter_1_0
		end
	end

	if var_1_1 then
		return var_1_1
	end
end

local function var_0_2(arg_2_0)
	local var_2_0 = 0

	for iter_2_0, iter_2_1 in pairs(arg_2_0) do
		for iter_2_2, iter_2_3 in pairs(iter_2_1) do
			local var_2_1 = var_0_0[iter_2_2]

			if not var_2_1 then
				local var_2_2 = var_0_1(iter_2_2, var_0_0)

				if var_2_2 then
					fassert(false, "Bad objective keyword found in objective_templates_vs.lua: '%s', did you mean '%s' ?", iter_2_2, var_2_2)
				else
					fassert(false, "Bad objective keyword found objective_templates_vs.lua: '%s', was it misspelled?", iter_2_2)
				end
			end

			if type(var_2_1) == "table" then
				local var_2_3 = var_0_1(iter_2_3, var_2_1)

				fassert(var_2_1[iter_2_3], "Bad objective: Objective keyword '%s' is set to '%s' which does not exist or is misspelled. Did you mean '%s' ?", iter_2_2, iter_2_3, var_2_3)
			end
		end

		GameModeSettings.versus.objective_names[iter_2_0] = true

		if iter_2_1.sub_objectives then
			var_2_0 = var_2_0 + var_0_2(iter_2_1.sub_objectives)
		end

		var_2_0 = var_2_0 + (iter_2_1.score_for_completion or 0)

		local var_2_4 = iter_2_1.score_per_section

		if var_2_4 then
			var_2_0 = var_2_0 + var_2_4 * iter_2_1.num_sections
		end

		local var_2_5 = iter_2_1.score_per_socket

		if var_2_5 then
			var_2_0 = var_2_0 + var_2_5 * iter_2_1.num_sockets
		end

		local var_2_6 = iter_2_1.score_for_each_player_inside

		if var_2_6 then
			var_2_0 = var_2_0 + var_2_6 * 4
		end
	end

	return var_2_0
end

GameModeSettings.versus.objective_names = {}

for iter_0_0, iter_0_1 in pairs(VersusObjectiveSettings) do
	local var_0_3 = iter_0_1.objective_lists

	iter_0_1.max_score = 0

	for iter_0_2 = 1, #var_0_3 do
		local var_0_4 = ObjectiveLists[var_0_3[iter_0_2]]
		local var_0_5 = 0

		for iter_0_3 = 1, #var_0_4 do
			local var_0_6 = var_0_4[iter_0_3]

			var_0_5 = var_0_5 + var_0_2(var_0_6)
		end

		var_0_4.max_score = var_0_5
		iter_0_1.max_score = iter_0_1.max_score + var_0_5
	end
end
