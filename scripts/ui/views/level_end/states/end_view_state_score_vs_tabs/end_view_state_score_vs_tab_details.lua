-- chunkname: @scripts/ui/views/level_end/states/end_view_state_score_vs_tabs/end_view_state_score_vs_tab_details.lua

EndViewStateScoreVSTabDetails = class(EndViewStateScoreVSTabDetails)
EndViewStateScoreVSTabDetails.NAME = "EndViewStateScoreVSTabDetails"

local tbl = {
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

EndViewStateScoreVSTabDetails.on_enter = function (self, arg_1_1)
	-- function 1
	print("[EndViewStateVS] Enter Substate EndViewStateScoreVSTabDetails")

	self._params = arg_1_1
	self._parent = arg_1_1.parent

	local context = arg_1_1.context

	self._context = context
	self._ui_renderer = context.ui_renderer
	self._ui_top_renderer = context.ui_top_renderer
	self._input_manager = context.input_manager
	self._render_settings = {
		alpha_multiplier = 0,
		snap_pixel_positions = true
	}
	self._animations = {}
	self._ui_animations = {}

	self:create_ui_elements(arg_1_1)
	self:_start_transition_animation("on_enter", "on_enter")
	self._parent:hide_team()
	self._parent:activate_back_to_keep_button()
end

EndViewStateScoreVSTabDetails.on_exit = function (self, arg_2_1)
	-- function 2
	print("[EndViewStateVS] Exit Substate EndViewStateScoreVSTabDetails")

	self._ui_scenegraph = nil
	self._widgets = nil
	self._widgets_by_name = nil
	self._ui_animator = nil
end

EndViewStateScoreVSTabDetails.create_ui_elements = function (self, arg_3_1)
	-- function 3
	local _get_definitions = self:_get_definitions()
	local widget_definitions = _get_definitions.widget_definitions
	local scenegraph_definition = _get_definitions.scenegraph_definition
	local animation_definitions = _get_definitions.animation_definitions

	self._scenegraph_definition = scenegraph_definition
	self._ui_scenegraph = UISceneGraph.init_scenegraph(scenegraph_definition)
	self._widgets, self._widgets_by_name = UIUtils.create_widgets(widget_definitions, {}, {})

	self:_populate_stats(_get_definitions)
	self:_create_winner_icon(_get_definitions)
	UIRenderer.clear_scenegraph_queue(self._ui_renderer)

	self._ui_animator = UIAnimator:new(self._ui_scenegraph, animation_definitions)
end

EndViewStateScoreVSTabDetails._create_winner_icon = function (self, arg_4_1)
	-- function 4
	local create_winner_icon_func = arg_4_1.create_winner_icon_func
	local peer_id = Network.peer_id()
	local num = 1
	local var_4_3 = self._context.party_composition[PlayerUtils.unique_player_id(peer_id, num)]
	local flag

	flag = var_4_3 ~= 1 or not 2 or 1

	local team_scores = self._context.rewards.team_scores
	local var_4_6 = team_scores[var_4_3]
	local var_4_7 = team_scores[flag]

	if var_4_7 < var_4_6 then
		local var_4_8 = create_winner_icon_func("local_team")
		local var_4_9 = UIWidget.init(var_4_8)

		self._widgets[#self._widgets + 1] = var_4_9
		self._widgets_by_name.local_winner_icon = var_4_9
	elseif var_4_6 < var_4_7 then
		local var_4_10 = create_winner_icon_func("opponent_team")
		local var_4_11 = UIWidget.init(var_4_10)

		self._widgets[#self._widgets + 1] = var_4_11
		self._widgets_by_name.opponent_winner_icon = var_4_11
	end
end

local tbl_2 = {}
local tbl_3 = {}
local tbl_4 = {}

EndViewStateScoreVSTabDetails._trim_bots = function (arg_5_0, arg_5_1)
	-- function 5
	table.clear(tbl_2)
	table.clear(tbl_3)
	table.clear(tbl_4)

	local party_settings = GameModeSettings.versus.party_settings

	for k, v in pairs(party_settings) do
		tbl_4[v.party_id] = v.num_slots
	end

	for k_2, v_2 in pairs(arg_5_1) do
		if string.split_deprecated(k_2, ":")[2] == "1" then
			tbl_2[k_2] = v_2

			local var_5_1 = tbl_3
			local var_5_2 = tbl_3[v_2]

			var_5_2 = var_5_2 or 0
			var_5_1[v_2] = var_5_2 + 1
		end
	end

	return tbl_2, tbl_3, tbl_4
end

EndViewStateScoreVSTabDetails._populate_stats = function (self, arg_6_1)
	-- function 6
	local peer_id = Network.peer_id()
	local _context = self._context
	local _trim_bots, var_6_3, var_6_4 = self:_trim_bots(_context.party_composition)
	local var_6_5 = _trim_bots[peer_id .. ":1"]
	local var_6_6 = GameModeSettings.versus.party_names_lookup_by_id[var_6_5]
	local flag

	flag = var_6_5 ~= 1 or not 2 or 1

	local var_6_8 = GameModeSettings.versus.party_names_lookup_by_id[flag]
	local players_session_score = _context.players_session_score
	local create_stats_func = arg_6_1.create_stats_func
	local create_title_func = arg_6_1.create_title_func
	local create_team_grid_fields_func = arg_6_1.create_team_grid_fields_func
	local create_team_title_func = arg_6_1.create_team_title_func
	local create_flag_func = arg_6_1.create_flag_func
	local values = table.values(players_session_score)
	local tbl_2 = {}

	for k, v in pairs(values) do
		local scores = v.scores
		local var_6_18 = _trim_bots[v.peer_id .. ":" .. v.local_player_id]

		for k_2, v_2 in pairs(scores) do
			local var_6_19 = tbl_2[k_2]

			var_6_19 = var_6_19 or v_2
			tbl_2[k_2] = var_6_19
			tbl_2[k_2] = not (v_2 > tbl_2[k_2]) or not v_2 or tbl_2[k_2]
		end
	end

	local function fn(self, arg_7_1)
		-- function 7
		return self.name < arg_7_1.name
	end

	table.sort(values, fn)

	local tbl_3 = {
		0,
		0,
		0
	}
	local tbl_4 = {}
	local tbl_5 = {}
	local tbl_6 = {}

	for k_3, v_3 in pairs(tbl) do
		for i, v_4 in ipairs(v_3) do
			local scenegraph_id = v_4.scenegraph_id
			local side = v_4.side
			local num = 0

			table.clear(tbl_6)

			local texts = v_4.texts

			if not texts then
				table.clear(tbl_4)

				for i_2, v_5 in ipairs(texts) do
					tbl_4[#tbl_4 + 1] = Localize(v_5)
				end

				tbl_3[2] = -40 * num

				local flag_2 = false
				local flag_3 = true
				local var_6_31 = create_stats_func(scenegraph_id, tbl_4, 18, tbl_3, flag_2, flag_3)
				local var_6_32 = UIWidget.init(var_6_31)

				self._widgets[#self._widgets + 1] = var_6_32
				self._widgets_by_name[k_3 .. "_" .. side] = var_6_32
			else
				for k_4, v_6 in pairs(values) do
					local str = v_6.peer_id .. ":" .. v_6.local_player_id
					local var_6_34 = _trim_bots[str]
					local var_6_35 = GameModeSettings.versus.party_names_lookup_by_id[var_6_34]

					if not (not var_6_35 and var_6_35 == "undecided") then
						local flag_4

						flag_4 = var_6_34 ~= var_6_5 or not "local_team" or "opponent_team"

						if flag_4 == k_3 then
							local scores_2 = v_6.scores

							table.clear(tbl_4)
							table.clear(tbl_5)

							for i12 = 1, #v_4 do
								local var_6_38 = v_4[i12]
								local num_2 = #tbl_4 + 1
								local var_6_40 = scores_2[var_6_38]

								var_6_40 = var_6_40 or Localize("menu_settings_none")
								tbl_4[num_2] = var_6_40

								local var_6_41 = tbl_6[i12]

								var_6_41 = var_6_41 or 0

								local var_6_42 = scores_2[var_6_38]

								var_6_42 = var_6_42 or 0
								tbl_6[i12] = var_6_41 + var_6_42
								tbl_5[#tbl_5 + 1] = tbl_2[var_6_38]
							end

							tbl_3[2] = -40 * (num - 1)

							local flag_5 = false
							local var_6_44 = create_stats_func(scenegraph_id, tbl_4, 20, tbl_3, v_6.peer_id == peer_id, flag_5, tbl_5)
							local var_6_45 = UIWidget.init(var_6_44)

							self._widgets[#self._widgets + 1] = var_6_45
							self._widgets_by_name[str .. "_" .. k_3 .. "_" .. side] = var_6_45

							if side == "heroes" then
								tbl_3[1] = -200

								local var_6_46 = create_title_func(scenegraph_id, v_6.name, nil, tbl_3, v_6.peer_id == peer_id, var_6_35)
								local var_6_47 = UIWidget.init(var_6_46)

								self._widgets[#self._widgets + 1] = var_6_47
								self._widgets_by_name["title_" .. str .. "_" .. k_3 .. "_" .. side] = var_6_47
								tbl_3[1] = 0
							end

							num = num + 1
						end
					end
				end

				local var_6_48 = create_team_grid_fields_func(k_3, num, self._ui_scenegraph)

				UIUtils.create_widgets(var_6_48, self._widgets, self._widgets_by_name)

				tbl_3[2] = 95

				local var_6_49 = create_stats_func(scenegraph_id, tbl_6, 45, tbl_3, nil, nil, nil, k_3)
				local var_6_50 = UIWidget.init(var_6_49)

				self._widgets[#self._widgets + 1] = var_6_50
				self._widgets_by_name["total_fields_" .. "_" .. k_3 .. "_" .. side] = var_6_50

				local var_6_51 = create_team_title_func(k_3, var_6_6, var_6_8)
				local var_6_52 = UIWidget.init(var_6_51)

				self._widgets[#self._widgets + 1] = var_6_52
				self._widgets_by_name["team_title_" .. k_3] = var_6_52

				local var_6_53 = create_flag_func(k_3, var_6_6, var_6_8)
				local var_6_54 = UIWidget.init(var_6_53)

				self._widgets[#self._widgets + 1] = var_6_54
				self._widgets_by_name[k_3 .. "_flag"] = var_6_54
			end
		end
	end
end

EndViewStateScoreVSTabDetails._get_definitions = function (arg_8_0)
	-- function 8
	return local_require("scripts/ui/views/level_end/states/end_view_state_score_vs_tabs/end_view_state_score_vs_tab_details_definitions")
end

EndViewStateScoreVSTabDetails.update = function (self, arg_9_1, arg_9_2)
	-- function 9
	self:_draw(arg_9_1, arg_9_2)
	self:_update_animations(arg_9_1)
end

EndViewStateScoreVSTabDetails.post_update = function (arg_10_0, arg_10_1, arg_10_2)
	-- function 10
	return
end

EndViewStateScoreVSTabDetails._update_animations = function (self, arg_11_1)
	-- function 11
	for k, v in pairs(self._ui_animations) do
		UIAnimation.update(v, arg_11_1)

		if not UIAnimation.completed(v) then
			self._ui_animations[k] = nil
		end
	end

	local _animations = self._animations
	local _ui_animator = self._ui_animator

	_ui_animator:update(arg_11_1)

	for k_2, v_2 in pairs(_animations) do
		if not _ui_animator:is_animation_completed(v_2) then
			_ui_animator:stop_animation(v_2)

			_animations[k_2] = nil
		end
	end
end

EndViewStateScoreVSTabDetails._draw = function (self, arg_12_1, arg_12_2)
	-- function 12
	local _ui_renderer = self._ui_renderer
	local _ui_scenegraph = self._ui_scenegraph
	local _render_settings = self._render_settings
	local get_service = self._input_manager:get_service("end_of_level")

	UIRenderer.begin_pass(_ui_renderer, _ui_scenegraph, get_service, arg_12_1, nil, _render_settings)

	for i, v in ipairs(self._widgets) do
		UIRenderer.draw_widget(_ui_renderer, v)
	end

	UIRenderer.end_pass(_ui_renderer)
end

EndViewStateScoreVSTabDetails._start_transition_animation = function (self, arg_13_1, arg_13_2)
	-- function 13
	local tbl = {
		render_settings = self._render_settings
	}
	local tbl_2 = {}
	local start_animation = self._ui_animator:start_animation(arg_13_2, tbl_2, self._scenegraph_definition, tbl)

	self._animations[arg_13_1] = start_animation
end
