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

local tbl = {
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

local function fn(arg_1_0, arg_1_1)
	-- function 1
	local num = 999
	local var_1_1

	for k, v in pairs(arg_1_1) do
		local damerau_levenshtein_distance = string.damerau_levenshtein_distance(k, arg_1_0, 5)

		if damerau_levenshtein_distance < num then
			num = damerau_levenshtein_distance
			var_1_1 = k
		end
	end

	if not var_1_1 then
		return var_1_1
	end
end

local function fn_2(arg_2_0)
	-- function 2
	local num = 0

	for k, v in pairs(arg_2_0) do
		for k_2, v_2 in pairs(v) do
			local var_2_1 = tbl[k_2]

			if not var_2_1 then
				local var_2_2 = fn(k_2, tbl)

				if not var_2_2 then
					fassert(false, "Bad objective keyword found in objective_templates_vs.lua: '%s', did you mean '%s' ?", k_2, var_2_2)
				else
					fassert(false, "Bad objective keyword found objective_templates_vs.lua: '%s', was it misspelled?", k_2)
				end
			end

			if type(var_2_1) == "table" then
				local var_2_3 = fn(v_2, var_2_1)

				fassert(var_2_1[v_2], "Bad objective: Objective keyword '%s' is set to '%s' which does not exist or is misspelled. Did you mean '%s' ?", k_2, v_2, var_2_3)
			end
		end

		GameModeSettings.versus.objective_names[k] = true

		if not v.sub_objectives then
			num = num + fn_2(v.sub_objectives)
		end

		local score_for_completion = v.score_for_completion

		score_for_completion = score_for_completion or 0
		num = num + score_for_completion

		local score_per_section = v.score_per_section

		if not score_per_section then
			num = num + score_per_section * v.num_sections
		end

		local score_per_socket = v.score_per_socket

		if not score_per_socket then
			num = num + score_per_socket * v.num_sockets
		end

		local score_for_each_player_inside = v.score_for_each_player_inside

		if not score_for_each_player_inside then
			num = num + score_for_each_player_inside * 4
		end
	end

	return num
end

GameModeSettings.versus.objective_names = {}

for k, v in pairs(VersusObjectiveSettings) do
	local objective_lists = v.objective_lists

	v.max_score = 0

	for k_2 = 1, #objective_lists do
		local var_0_4 = ObjectiveLists[objective_lists[k_2]]
		local num = 0

		for l = 1, #var_0_4 do
			local var_0_6 = var_0_4[l]

			num = num + fn_2(var_0_6)
		end

		var_0_4.max_score = num
		v.max_score = v.max_score + num
	end
end
