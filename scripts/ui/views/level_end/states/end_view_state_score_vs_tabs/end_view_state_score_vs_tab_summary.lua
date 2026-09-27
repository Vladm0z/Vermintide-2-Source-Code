-- chunkname: @scripts/ui/views/level_end/states/end_view_state_score_vs_tabs/end_view_state_score_vs_tab_summary.lua

require("scripts/settings/dlcs/carousel/end_screen_award_settings")

local flag = false

EndViewStateScoreVSTabSummary = class(EndViewStateScoreVSTabSummary)
EndViewStateScoreVSTabSummary.NAME = "EndViewStateScoreVSTabSummary"

EndViewStateScoreVSTabSummary.on_enter = function (self, arg_1_1)
	-- function 1
	print("[EndViewStateVS] Enter Substate EndViewStateScoreVSTabSummary")

	self._params = arg_1_1

	local context = arg_1_1.context

	self._context = context
	self.ui_renderer = context.ui_renderer
	self.ui_top_renderer = context.ui_top_renderer
	self.input_manager = context.input_manager
	self.render_settings = {
		alpha_multiplier = 0,
		snap_pixel_positions = true
	}
	self._animations = {}
	self._ui_animations = {}

	self:create_ui_elements(arg_1_1)
	self:_calculate_awards()
	self:_start_transition_animation("on_enter", "on_enter")
	self._params.parent:show_team()
end

EndViewStateScoreVSTabSummary._calculate_awards = function (self)
	-- function 2
	self._awards = {}

	local players_session_score = self._context.players_session_score

	for i = 1, #EndScreenAwardSettings do
		local var_2_1 = EndScreenAwardSettings[i]
		local evaluate = var_2_1.evaluate(players_session_score)

		if not evaluate then
			local _awards = self._awards
			local var_2_4 = self._awards[evaluate]

			var_2_4 = var_2_4 or {}
			_awards[evaluate] = var_2_4
			self._awards[evaluate][#self._awards[evaluate] + 1] = var_2_1.name
		end
	end

	local num = 0

	for k, v in pairs(self._awards) do
		local count = #v

		if num < count then
			num = count
		end
	end

	local tbl = {}

	for k_2, v_2 in pairs(self._awards) do
		if #v_2 == num then
			tbl[#tbl + 1] = k_2
		end
	end

	local var_2_8

	if not (#tbl > 1) then
		-- Nothing
	end

	local peer_id = Network.peer_id()
	local num_2 = 1
	local var_2_11 = self._context.party_composition[PlayerUtils.unique_player_id(peer_id, num_2)]
	local flag

	flag = var_2_11 ~= 1 or not 2 or 1

	local flag_2 = not self._context.game_won and var_2_11 and flag
	local party_composition = self._context.party_composition

	for i_2, v_3 in ipairs(tbl) do
		if party_composition[PlayerUtils.unique_player_id(v_3, num_2)] == flag_2 then
			var_2_8 = v_3

			break
		end
	end

	if false then
		var_2_8 = tbl[1]
	end

	if not var_2_8 then
		table.insert(self._awards[var_2_8], 1, "mvp")
	end

	table.dump(self._awards, "AWARDS", 2)
end

EndViewStateScoreVSTabSummary.on_exit = function (self, arg_3_1)
	-- function 3
	print("[EndViewStateVS] Exit Substate EndViewStateScoreVSTabSummary")

	self._ui_scenegraph = nil
	self._widgets = nil
	self._widgets_by_name = nil
	self._ui_animator = nil

	self._params.parent:hide_team()
end

EndViewStateScoreVSTabSummary.create_ui_elements = function (self, arg_4_1)
	-- function 4
	local _get_definitions = self:_get_definitions()
	local widget_definitions = _get_definitions.widget_definitions
	local summary_entry_widgets = _get_definitions.summary_entry_widgets
	local scenegraph_definition = _get_definitions.scenegraph_definition
	local animation_definitions = _get_definitions.animation_definitions

	flag = false
	self._scenegraph_definition = scenegraph_definition
	self._ui_scenegraph = UISceneGraph.init_scenegraph(scenegraph_definition)
	self._widgets, self._widgets_by_name = UIUtils.create_widgets(widget_definitions, {}, {})

	UIRenderer.clear_scenegraph_queue(self.ui_renderer)

	self._ui_animator = UIAnimator:new(self._ui_scenegraph, animation_definitions)
end

EndViewStateScoreVSTabSummary._get_definitions = function (arg_5_0)
	-- function 5
	return local_require("scripts/ui/views/level_end/states/end_view_state_score_vs_tabs/end_view_state_score_vs_tab_summary_definitions")
end

EndViewStateScoreVSTabSummary.update = function (self, arg_6_1, arg_6_2)
	-- function 6
	if not flag then
		self:on_enter(self._params)
	end

	local get_service = self.input_manager:get_service("end_of_level")

	self:draw(get_service, arg_6_1)
	self._ui_animator:update(arg_6_1)
	self:_update_animations(arg_6_1)
end

EndViewStateScoreVSTabSummary.post_update = function (arg_7_0, arg_7_1, arg_7_2)
	-- function 7
	return
end

EndViewStateScoreVSTabSummary._update_animations = function (self, arg_8_1)
	-- function 8
	for k, v in pairs(self._ui_animations) do
		UIAnimation.update(v, arg_8_1)

		if not UIAnimation.completed(v) then
			self._ui_animations[k] = nil
		end
	end

	local _animations = self._animations
	local _ui_animator = self._ui_animator

	for k_2, v_2 in pairs(_animations) do
		if not _ui_animator:is_animation_completed(v_2) then
			_ui_animator:stop_animation(v_2)

			_animations[k_2] = nil
		end
	end
end

EndViewStateScoreVSTabSummary.draw = function (self, arg_9_1, arg_9_2)
	-- function 9
	local ui_renderer = self.ui_renderer
	local _ui_scenegraph = self._ui_scenegraph
	local render_settings = self.render_settings

	UIRenderer.begin_pass(ui_renderer, _ui_scenegraph, arg_9_1, arg_9_2, nil, render_settings)

	for i, v in ipairs(self._widgets) do
		UIRenderer.draw_widget(ui_renderer, v)
	end

	UIRenderer.end_pass(ui_renderer)
end

EndViewStateScoreVSTabSummary._start_transition_animation = function (self, arg_10_1, arg_10_2)
	-- function 10
	local tbl = {
		render_settings = self.render_settings
	}
	local tbl_2 = {}
	local start_animation = self._ui_animator:start_animation(arg_10_2, tbl_2, self._scenegraph_definition, tbl)

	self._animations[arg_10_1] = start_animation
end
