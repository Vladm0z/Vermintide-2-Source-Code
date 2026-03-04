-- chunkname: @scripts/ui/views/level_end/states/end_view_state_score_vs_tabs/end_view_state_score_vs_tab_summary.lua

require("scripts/settings/dlcs/carousel/end_screen_award_settings")

local var_0_0 = false

EndViewStateScoreVSTabSummary = class(EndViewStateScoreVSTabSummary)
EndViewStateScoreVSTabSummary.NAME = "EndViewStateScoreVSTabSummary"

EndViewStateScoreVSTabSummary.on_enter = function (arg_1_0, arg_1_1)
	print("[EndViewStateVS] Enter Substate EndViewStateScoreVSTabSummary")

	arg_1_0._params = arg_1_1

	local var_1_0 = arg_1_1.context

	arg_1_0._context = var_1_0
	arg_1_0.ui_renderer = var_1_0.ui_renderer
	arg_1_0.ui_top_renderer = var_1_0.ui_top_renderer
	arg_1_0.input_manager = var_1_0.input_manager
	arg_1_0.render_settings = {
		alpha_multiplier = 0,
		snap_pixel_positions = true
	}
	arg_1_0._animations = {}
	arg_1_0._ui_animations = {}

	arg_1_0:create_ui_elements(arg_1_1)
	arg_1_0:_calculate_awards()
	arg_1_0:_start_transition_animation("on_enter", "on_enter")
	arg_1_0._params.parent:show_team()
end

EndViewStateScoreVSTabSummary._calculate_awards = function (arg_2_0)
	arg_2_0._awards = {}

	local var_2_0 = arg_2_0._context.players_session_score

	for iter_2_0 = 1, #EndScreenAwardSettings do
		local var_2_1 = EndScreenAwardSettings[iter_2_0]
		local var_2_2 = var_2_1.evaluate(var_2_0)

		if var_2_2 then
			arg_2_0._awards[var_2_2] = arg_2_0._awards[var_2_2] or {}
			arg_2_0._awards[var_2_2][#arg_2_0._awards[var_2_2] + 1] = var_2_1.name
		end
	end

	local var_2_3 = 0

	for iter_2_1, iter_2_2 in pairs(arg_2_0._awards) do
		local var_2_4 = #iter_2_2

		if var_2_3 < var_2_4 then
			var_2_3 = var_2_4
		end
	end

	local var_2_5 = {}

	for iter_2_3, iter_2_4 in pairs(arg_2_0._awards) do
		if #iter_2_4 == var_2_3 then
			var_2_5[#var_2_5 + 1] = iter_2_3
		end
	end

	local var_2_6

	if not (#var_2_5 > 1) then
		-- Nothing
	end

	local var_2_7 = Network.peer_id()
	local var_2_8 = 1
	local var_2_9 = arg_2_0._context.party_composition[PlayerUtils.unique_player_id(var_2_7, var_2_8)]
	local var_2_10 = var_2_9 == 1 and 2 or 1
	local var_2_11 = arg_2_0._context.game_won and var_2_9 or var_2_10
	local var_2_12 = arg_2_0._context.party_composition

	for iter_2_5, iter_2_6 in ipairs(var_2_5) do
		if var_2_12[PlayerUtils.unique_player_id(iter_2_6, var_2_8)] == var_2_11 then
			var_2_6 = iter_2_6

			break
		end
	end

	if false then
		var_2_6 = var_2_5[1]
	end

	if var_2_6 then
		table.insert(arg_2_0._awards[var_2_6], 1, "mvp")
	end

	table.dump(arg_2_0._awards, "AWARDS", 2)
end

EndViewStateScoreVSTabSummary.on_exit = function (arg_3_0, arg_3_1)
	print("[EndViewStateVS] Exit Substate EndViewStateScoreVSTabSummary")

	arg_3_0._ui_scenegraph = nil
	arg_3_0._widgets = nil
	arg_3_0._widgets_by_name = nil
	arg_3_0._ui_animator = nil

	arg_3_0._params.parent:hide_team()
end

EndViewStateScoreVSTabSummary.create_ui_elements = function (arg_4_0, arg_4_1)
	local var_4_0 = arg_4_0:_get_definitions()
	local var_4_1 = var_4_0.widget_definitions
	local var_4_2 = var_4_0.summary_entry_widgets
	local var_4_3 = var_4_0.scenegraph_definition
	local var_4_4 = var_4_0.animation_definitions

	var_0_0 = false
	arg_4_0._scenegraph_definition = var_4_3
	arg_4_0._ui_scenegraph = UISceneGraph.init_scenegraph(var_4_3)
	arg_4_0._widgets, arg_4_0._widgets_by_name = UIUtils.create_widgets(var_4_1, {}, {})

	UIRenderer.clear_scenegraph_queue(arg_4_0.ui_renderer)

	arg_4_0._ui_animator = UIAnimator:new(arg_4_0._ui_scenegraph, var_4_4)
end

EndViewStateScoreVSTabSummary._get_definitions = function (arg_5_0)
	return local_require("scripts/ui/views/level_end/states/end_view_state_score_vs_tabs/end_view_state_score_vs_tab_summary_definitions")
end

EndViewStateScoreVSTabSummary.update = function (arg_6_0, arg_6_1, arg_6_2)
	if var_0_0 then
		arg_6_0:on_enter(arg_6_0._params)
	end

	local var_6_0 = arg_6_0.input_manager:get_service("end_of_level")

	arg_6_0:draw(var_6_0, arg_6_1)
	arg_6_0._ui_animator:update(arg_6_1)
	arg_6_0:_update_animations(arg_6_1)
end

EndViewStateScoreVSTabSummary.post_update = function (arg_7_0, arg_7_1, arg_7_2)
	return
end

EndViewStateScoreVSTabSummary._update_animations = function (arg_8_0, arg_8_1)
	for iter_8_0, iter_8_1 in pairs(arg_8_0._ui_animations) do
		UIAnimation.update(iter_8_1, arg_8_1)

		if UIAnimation.completed(iter_8_1) then
			arg_8_0._ui_animations[iter_8_0] = nil
		end
	end

	local var_8_0 = arg_8_0._animations
	local var_8_1 = arg_8_0._ui_animator

	for iter_8_2, iter_8_3 in pairs(var_8_0) do
		if var_8_1:is_animation_completed(iter_8_3) then
			var_8_1:stop_animation(iter_8_3)

			var_8_0[iter_8_2] = nil
		end
	end
end

EndViewStateScoreVSTabSummary.draw = function (arg_9_0, arg_9_1, arg_9_2)
	local var_9_0 = arg_9_0.ui_renderer
	local var_9_1 = arg_9_0._ui_scenegraph
	local var_9_2 = arg_9_0.render_settings

	UIRenderer.begin_pass(var_9_0, var_9_1, arg_9_1, arg_9_2, nil, var_9_2)

	for iter_9_0, iter_9_1 in ipairs(arg_9_0._widgets) do
		UIRenderer.draw_widget(var_9_0, iter_9_1)
	end

	UIRenderer.end_pass(var_9_0)
end

EndViewStateScoreVSTabSummary._start_transition_animation = function (arg_10_0, arg_10_1, arg_10_2)
	local var_10_0 = {
		render_settings = arg_10_0.render_settings
	}
	local var_10_1 = {}
	local var_10_2 = arg_10_0._ui_animator:start_animation(arg_10_2, var_10_1, arg_10_0._scenegraph_definition, var_10_0)

	arg_10_0._animations[arg_10_1] = var_10_2
end
