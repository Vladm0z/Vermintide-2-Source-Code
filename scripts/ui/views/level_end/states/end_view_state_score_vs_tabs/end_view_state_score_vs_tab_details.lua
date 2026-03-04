-- chunkname: @scripts/ui/views/level_end/states/end_view_state_score_vs_tabs/end_view_state_score_vs_tab_details.lua

EndViewStateScoreVSTabDetails = class(EndViewStateScoreVSTabDetails)
EndViewStateScoreVSTabDetails.NAME = "EndViewStateScoreVSTabDetails"

local var_0_0 = {
	headers = {
		{
			side = "heroes",
			scenegraph_id = "local_heroes_header_grid",
			texts = {
				"vs_scoreboard_eliminations",
				"vs_scoreboard_damage_done",
				"vs_scoreboard_revives"
			}
		},
		{
			side = "dark_pact",
			scenegraph_id = "local_pact_header_grid",
			texts = {
				"vs_scoreboard_eliminations",
				"vs_scoreboard_damage_done",
				"vs_scoreboard_disables"
			}
		}
	},
	local_team = {
		{
			"kills_specials",
			"vs_damage_dealt_to_pactsworn",
			"revives",
			scenegraph_id = "local_heroes_score_grid",
			side = "heroes"
		},
		{
			"kills_heroes",
			"damage_dealt_heroes",
			"disables",
			scenegraph_id = "local_pact_score_grid",
			side = "dark_pact"
		}
	},
	opponent_team = {
		{
			"kills_specials",
			"vs_damage_dealt_to_pactsworn",
			"revives",
			scenegraph_id = "opponent_heroes_score_grid",
			side = "heroes"
		},
		{
			"kills_heroes",
			"damage_dealt_heroes",
			"disables",
			scenegraph_id = "opponent_pact_score_grid",
			side = "dark_pact"
		}
	}
}

EndViewStateScoreVSTabDetails.on_enter = function (arg_1_0, arg_1_1)
	print("[EndViewStateVS] Enter Substate EndViewStateScoreVSTabDetails")

	arg_1_0._params = arg_1_1
	arg_1_0._parent = arg_1_1.parent

	local var_1_0 = arg_1_1.context

	arg_1_0._context = var_1_0
	arg_1_0._ui_renderer = var_1_0.ui_renderer
	arg_1_0._ui_top_renderer = var_1_0.ui_top_renderer
	arg_1_0._input_manager = var_1_0.input_manager
	arg_1_0._render_settings = {
		alpha_multiplier = 0,
		snap_pixel_positions = true
	}
	arg_1_0._animations = {}
	arg_1_0._ui_animations = {}

	arg_1_0:create_ui_elements(arg_1_1)
	arg_1_0:_start_transition_animation("on_enter", "on_enter")
	arg_1_0._parent:hide_team()
	arg_1_0._parent:activate_back_to_keep_button()
end

EndViewStateScoreVSTabDetails.on_exit = function (arg_2_0, arg_2_1)
	print("[EndViewStateVS] Exit Substate EndViewStateScoreVSTabDetails")

	arg_2_0._ui_scenegraph = nil
	arg_2_0._widgets = nil
	arg_2_0._widgets_by_name = nil
	arg_2_0._ui_animator = nil
end

EndViewStateScoreVSTabDetails.create_ui_elements = function (arg_3_0, arg_3_1)
	local var_3_0 = arg_3_0:_get_definitions()
	local var_3_1 = var_3_0.widget_definitions
	local var_3_2 = var_3_0.scenegraph_definition
	local var_3_3 = var_3_0.animation_definitions

	arg_3_0._scenegraph_definition = var_3_2
	arg_3_0._ui_scenegraph = UISceneGraph.init_scenegraph(var_3_2)
	arg_3_0._widgets, arg_3_0._widgets_by_name = UIUtils.create_widgets(var_3_1, {}, {})

	arg_3_0:_populate_stats(var_3_0)
	arg_3_0:_create_winner_icon(var_3_0)
	UIRenderer.clear_scenegraph_queue(arg_3_0._ui_renderer)

	arg_3_0._ui_animator = UIAnimator:new(arg_3_0._ui_scenegraph, var_3_3)
end

EndViewStateScoreVSTabDetails._create_winner_icon = function (arg_4_0, arg_4_1)
	local var_4_0 = arg_4_1.create_winner_icon_func
	local var_4_1 = Network.peer_id()
	local var_4_2 = 1
	local var_4_3 = arg_4_0._context.party_composition[PlayerUtils.unique_player_id(var_4_1, var_4_2)]
	local var_4_4 = var_4_3 == 1 and 2 or 1
	local var_4_5 = arg_4_0._context.rewards.team_scores
	local var_4_6 = var_4_5[var_4_3]
	local var_4_7 = var_4_5[var_4_4]

	if var_4_7 < var_4_6 then
		local var_4_8 = var_4_0("local_team")
		local var_4_9 = UIWidget.init(var_4_8)

		arg_4_0._widgets[#arg_4_0._widgets + 1] = var_4_9
		arg_4_0._widgets_by_name.local_winner_icon = var_4_9
	elseif var_4_6 < var_4_7 then
		local var_4_10 = var_4_0("opponent_team")
		local var_4_11 = UIWidget.init(var_4_10)

		arg_4_0._widgets[#arg_4_0._widgets + 1] = var_4_11
		arg_4_0._widgets_by_name.opponent_winner_icon = var_4_11
	end
end

local var_0_1 = {}
local var_0_2 = {}
local var_0_3 = {}

EndViewStateScoreVSTabDetails._trim_bots = function (arg_5_0, arg_5_1)
	table.clear(var_0_1)
	table.clear(var_0_2)
	table.clear(var_0_3)

	local var_5_0 = GameModeSettings.versus.party_settings

	for iter_5_0, iter_5_1 in pairs(var_5_0) do
		var_0_3[iter_5_1.party_id] = iter_5_1.num_slots
	end

	for iter_5_2, iter_5_3 in pairs(arg_5_1) do
		if string.split_deprecated(iter_5_2, ":")[2] == "1" then
			var_0_1[iter_5_2] = iter_5_3
			var_0_2[iter_5_3] = (var_0_2[iter_5_3] or 0) + 1
		end
	end

	return var_0_1, var_0_2, var_0_3
end

EndViewStateScoreVSTabDetails._populate_stats = function (arg_6_0, arg_6_1)
	local var_6_0 = Network.peer_id()
	local var_6_1 = arg_6_0._context
	local var_6_2, var_6_3, var_6_4 = arg_6_0:_trim_bots(var_6_1.party_composition)
	local var_6_5 = var_6_2[var_6_0 .. ":1"]
	local var_6_6 = GameModeSettings.versus.party_names_lookup_by_id[var_6_5]
	local var_6_7 = var_6_5 == 1 and 2 or 1
	local var_6_8 = GameModeSettings.versus.party_names_lookup_by_id[var_6_7]
	local var_6_9 = var_6_1.players_session_score
	local var_6_10 = arg_6_1.create_stats_func
	local var_6_11 = arg_6_1.create_title_func
	local var_6_12 = arg_6_1.create_team_grid_fields_func
	local var_6_13 = arg_6_1.create_team_title_func
	local var_6_14 = arg_6_1.create_flag_func
	local var_6_15 = table.values(var_6_9)
	local var_6_16 = {}

	for iter_6_0, iter_6_1 in pairs(var_6_15) do
		local var_6_17 = iter_6_1.scores
		local var_6_18 = var_6_2[iter_6_1.peer_id .. ":" .. iter_6_1.local_player_id]

		for iter_6_2, iter_6_3 in pairs(var_6_17) do
			var_6_16[iter_6_2] = var_6_16[iter_6_2] or iter_6_3
			var_6_16[iter_6_2] = iter_6_3 > var_6_16[iter_6_2] and iter_6_3 or var_6_16[iter_6_2]
		end
	end

	local function var_6_19(arg_7_0, arg_7_1)
		return arg_7_0.name < arg_7_1.name
	end

	table.sort(var_6_15, var_6_19)

	local var_6_20 = {
		0,
		0,
		0
	}
	local var_6_21 = {}
	local var_6_22 = {}
	local var_6_23 = {}

	for iter_6_4, iter_6_5 in pairs(var_0_0) do
		for iter_6_6, iter_6_7 in ipairs(iter_6_5) do
			local var_6_24 = iter_6_7.scenegraph_id
			local var_6_25 = iter_6_7.side
			local var_6_26 = 0

			table.clear(var_6_23)

			local var_6_27 = iter_6_7.texts

			if var_6_27 then
				table.clear(var_6_21)

				for iter_6_8, iter_6_9 in ipairs(var_6_27) do
					var_6_21[#var_6_21 + 1] = Localize(iter_6_9)
				end

				var_6_20[2] = -40 * var_6_26

				local var_6_28 = false
				local var_6_29 = true
				local var_6_30 = var_6_10(var_6_24, var_6_21, 18, var_6_20, var_6_28, var_6_29)
				local var_6_31 = UIWidget.init(var_6_30)

				arg_6_0._widgets[#arg_6_0._widgets + 1] = var_6_31
				arg_6_0._widgets_by_name[iter_6_4 .. "_" .. var_6_25] = var_6_31
			else
				for iter_6_10, iter_6_11 in pairs(var_6_15) do
					local var_6_32 = iter_6_11.peer_id .. ":" .. iter_6_11.local_player_id
					local var_6_33 = var_6_2[var_6_32]
					local var_6_34 = GameModeSettings.versus.party_names_lookup_by_id[var_6_33]

					if var_6_34 and var_6_34 ~= "undecided" and (var_6_33 == var_6_5 and "local_team" or "opponent_team") == iter_6_4 then
						local var_6_35 = iter_6_11.scores

						table.clear(var_6_21)
						table.clear(var_6_22)

						for iter_6_12 = 1, #iter_6_7 do
							local var_6_36 = iter_6_7[iter_6_12]

							var_6_21[#var_6_21 + 1] = var_6_35[var_6_36] or Localize("menu_settings_none")
							var_6_23[iter_6_12] = (var_6_23[iter_6_12] or 0) + (var_6_35[var_6_36] or 0)
							var_6_22[#var_6_22 + 1] = var_6_16[var_6_36]
						end

						var_6_20[2] = -40 * (var_6_26 - 1)

						local var_6_37 = false
						local var_6_38 = var_6_10(var_6_24, var_6_21, 20, var_6_20, iter_6_11.peer_id == var_6_0, var_6_37, var_6_22)
						local var_6_39 = UIWidget.init(var_6_38)

						arg_6_0._widgets[#arg_6_0._widgets + 1] = var_6_39
						arg_6_0._widgets_by_name[var_6_32 .. "_" .. iter_6_4 .. "_" .. var_6_25] = var_6_39

						if var_6_25 == "heroes" then
							var_6_20[1] = -200

							local var_6_40 = var_6_11(var_6_24, iter_6_11.name, nil, var_6_20, iter_6_11.peer_id == var_6_0, var_6_34)
							local var_6_41 = UIWidget.init(var_6_40)

							arg_6_0._widgets[#arg_6_0._widgets + 1] = var_6_41
							arg_6_0._widgets_by_name["title_" .. var_6_32 .. "_" .. iter_6_4 .. "_" .. var_6_25] = var_6_41
							var_6_20[1] = 0
						end

						var_6_26 = var_6_26 + 1
					end
				end

				local var_6_42 = var_6_12(iter_6_4, var_6_26, arg_6_0._ui_scenegraph)

				UIUtils.create_widgets(var_6_42, arg_6_0._widgets, arg_6_0._widgets_by_name)

				var_6_20[2] = 95

				local var_6_43 = var_6_10(var_6_24, var_6_23, 45, var_6_20, nil, nil, nil, iter_6_4)
				local var_6_44 = UIWidget.init(var_6_43)

				arg_6_0._widgets[#arg_6_0._widgets + 1] = var_6_44
				arg_6_0._widgets_by_name["total_fields_" .. "_" .. iter_6_4 .. "_" .. var_6_25] = var_6_44

				local var_6_45 = var_6_13(iter_6_4, var_6_6, var_6_8)
				local var_6_46 = UIWidget.init(var_6_45)

				arg_6_0._widgets[#arg_6_0._widgets + 1] = var_6_46
				arg_6_0._widgets_by_name["team_title_" .. iter_6_4] = var_6_46

				local var_6_47 = var_6_14(iter_6_4, var_6_6, var_6_8)
				local var_6_48 = UIWidget.init(var_6_47)

				arg_6_0._widgets[#arg_6_0._widgets + 1] = var_6_48
				arg_6_0._widgets_by_name[iter_6_4 .. "_flag"] = var_6_48
			end
		end
	end
end

EndViewStateScoreVSTabDetails._get_definitions = function (arg_8_0)
	return local_require("scripts/ui/views/level_end/states/end_view_state_score_vs_tabs/end_view_state_score_vs_tab_details_definitions")
end

EndViewStateScoreVSTabDetails.update = function (arg_9_0, arg_9_1, arg_9_2)
	arg_9_0:_draw(arg_9_1, arg_9_2)
	arg_9_0:_update_animations(arg_9_1)
end

EndViewStateScoreVSTabDetails.post_update = function (arg_10_0, arg_10_1, arg_10_2)
	return
end

EndViewStateScoreVSTabDetails._update_animations = function (arg_11_0, arg_11_1)
	for iter_11_0, iter_11_1 in pairs(arg_11_0._ui_animations) do
		UIAnimation.update(iter_11_1, arg_11_1)

		if UIAnimation.completed(iter_11_1) then
			arg_11_0._ui_animations[iter_11_0] = nil
		end
	end

	local var_11_0 = arg_11_0._animations
	local var_11_1 = arg_11_0._ui_animator

	var_11_1:update(arg_11_1)

	for iter_11_2, iter_11_3 in pairs(var_11_0) do
		if var_11_1:is_animation_completed(iter_11_3) then
			var_11_1:stop_animation(iter_11_3)

			var_11_0[iter_11_2] = nil
		end
	end
end

EndViewStateScoreVSTabDetails._draw = function (arg_12_0, arg_12_1, arg_12_2)
	local var_12_0 = arg_12_0._ui_renderer
	local var_12_1 = arg_12_0._ui_scenegraph
	local var_12_2 = arg_12_0._render_settings
	local var_12_3 = arg_12_0._input_manager:get_service("end_of_level")

	UIRenderer.begin_pass(var_12_0, var_12_1, var_12_3, arg_12_1, nil, var_12_2)

	for iter_12_0, iter_12_1 in ipairs(arg_12_0._widgets) do
		UIRenderer.draw_widget(var_12_0, iter_12_1)
	end

	UIRenderer.end_pass(var_12_0)
end

EndViewStateScoreVSTabDetails._start_transition_animation = function (arg_13_0, arg_13_1, arg_13_2)
	local var_13_0 = {
		render_settings = arg_13_0._render_settings
	}
	local var_13_1 = {}
	local var_13_2 = arg_13_0._ui_animator:start_animation(arg_13_2, var_13_1, arg_13_0._scenegraph_definition, var_13_0)

	arg_13_0._animations[arg_13_1] = var_13_2
end
