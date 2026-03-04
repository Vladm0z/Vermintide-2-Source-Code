-- chunkname: @scripts/ui/views/end_screens/base_end_screen_ui.lua

require("scripts/ui/hud_ui/rewards_popup_ui")

BaseEndScreenUI = class(BaseEndScreenUI)

BaseEndScreenUI.init = function (arg_1_0, arg_1_1, arg_1_2, arg_1_3, arg_1_4)
	arg_1_0._ui_renderer = arg_1_1.ui_top_renderer
	arg_1_0._ingame_ui_context = arg_1_1
	arg_1_0._params = arg_1_4

	local var_1_0 = arg_1_1.world_manager
	local var_1_1 = var_1_0:world("level_world")

	arg_1_0._wwise_world = var_1_0:wwise_world(var_1_1)
	arg_1_0._input_service = arg_1_2
	arg_1_0._render_settings = {
		alpha_multiplier = 1,
		snap_pixel_positions = true
	}
	arg_1_0._draw_flags = {
		alpha_multiplier = 0
	}
	arg_1_0._started = false
	arg_1_0._completed = false
	arg_1_0._rewards_popup = RewardsPopupUI:new(nil, arg_1_1)

	arg_1_0:_setup_rewards(arg_1_4)
	arg_1_0:_create_ui_elements(arg_1_3)
end

BaseEndScreenUI._setup_rewards = function (arg_2_0, arg_2_1)
	local var_2_0 = arg_2_1 and arg_2_1.rewards

	if var_2_0 then
		arg_2_0._rewards_popup:present_rewards(var_2_0)
	end
end

BaseEndScreenUI.destroy = function (arg_3_0)
	arg_3_0._rewards_popup:destroy()
	arg_3_0:_destroy()
end

BaseEndScreenUI.on_fade_in = function (arg_4_0)
	arg_4_0:_on_fade_in()
end

BaseEndScreenUI._on_fade_in = function (arg_5_0)
	return
end

BaseEndScreenUI._start = function (arg_6_0)
	return
end

BaseEndScreenUI._update = function (arg_7_0, arg_7_1)
	return
end

BaseEndScreenUI._destroy = function (arg_8_0)
	return
end

BaseEndScreenUI._draw_widgets = function (arg_9_0, arg_9_1)
	return
end

BaseEndScreenUI._on_completed = function (arg_10_0)
	arg_10_0._completed = true
end

BaseEndScreenUI.completed = function (arg_11_0)
	return arg_11_0._completed and arg_11_0._rewards_popup:all_presentations_done()
end

BaseEndScreenUI._play_sound = function (arg_12_0, arg_12_1)
	WwiseWorld.trigger_event(arg_12_0._wwise_world, arg_12_1)
end

BaseEndScreenUI._create_ui_elements = function (arg_13_0, arg_13_1)
	arg_13_0._ui_scenegraph = UISceneGraph.init_scenegraph(arg_13_1.scenegraph_definition)
	arg_13_0._widgets, arg_13_0._widgets_by_name = UIUtils.create_widgets(arg_13_1.widget_definitions)
	arg_13_0._ui_animator = UIAnimator:new(arg_13_0._ui_scenegraph, arg_13_1.animation_definitions)
end

BaseEndScreenUI.start = function (arg_14_0)
	arg_14_0._started = true

	arg_14_0:_start()
end

BaseEndScreenUI.started = function (arg_15_0)
	return arg_15_0._started
end

BaseEndScreenUI.update = function (arg_16_0, arg_16_1, arg_16_2)
	if not arg_16_0._started then
		return
	end

	arg_16_0._ui_animator:update(arg_16_1, arg_16_2)
	arg_16_0._rewards_popup:update(arg_16_1, arg_16_2)
	arg_16_0:_update(arg_16_1)
end

BaseEndScreenUI.draw = function (arg_17_0, arg_17_1)
	if not arg_17_0._started then
		return
	end

	local var_17_0 = arg_17_0._ui_renderer
	local var_17_1 = arg_17_0._ui_scenegraph
	local var_17_2 = arg_17_0._input_service
	local var_17_3 = arg_17_0._render_settings

	var_17_3.alpha_multiplier = arg_17_0._draw_flags.alpha_multiplier or 0

	UIRenderer.begin_pass(var_17_0, var_17_1, var_17_2, arg_17_1, nil, var_17_3)
	UIRenderer.draw_all_widgets(var_17_0, arg_17_0._widgets)
	arg_17_0:_draw_widgets(var_17_0, var_17_3)
	UIRenderer.end_pass(var_17_0)
end
