-- chunkname: @scripts/ui/round_end_emblem_popup/round_end_emblem_popup_ui.lua

local var_0_0 = local_require("scripts/ui/round_end_emblem_popup/round_end_emblem_popup_ui_definitions")
local var_0_1 = var_0_0.scenegraph_definition
local var_0_2 = var_0_0.create_emblem_widget
local var_0_3 = var_0_0.animations

RoundEndEmblemPopupUI = class(RoundEndEmblemPopupUI)

local var_0_4 = false

RoundEndEmblemPopupUI.init = function (arg_1_0, arg_1_1, arg_1_2, arg_1_3, arg_1_4)
	arg_1_0._ui_renderer = arg_1_1.ui_renderer
	arg_1_0._ui_top_renderer = arg_1_1.ui_top_renderer
	arg_1_0._input_manager = arg_1_1.input_manager
	arg_1_0._world = arg_1_1.world
	arg_1_0._wwise_world = arg_1_1.wwise_world or Managers.world:wwise_world(arg_1_0._world)
	arg_1_0._render_settings = {
		alpha_multiplier = 0,
		blur_progress = 0,
		snap_pixel_positions = true
	}
	arg_1_0._viewport_world = arg_1_2

	arg_1_0:_create_ui_elements()
	arg_1_0:_set_title_text(arg_1_3 or "")
	arg_1_0:_set_sub_title_text(arg_1_4 or "")
end

RoundEndEmblemPopupUI._set_title_text = function (arg_2_0, arg_2_1)
	arg_2_0._title_title_widget.content.text = arg_2_1
end

RoundEndEmblemPopupUI._set_sub_title_text = function (arg_3_0, arg_3_1)
	arg_3_0._sub_title_text_widget.content.text = arg_3_1
end

RoundEndEmblemPopupUI._create_ui_elements = function (arg_4_0)
	local var_4_0 = "silver"

	arg_4_0._ui_scenegraph = UISceneGraph.init_scenegraph(var_0_1)

	local var_4_1 = var_0_0.widget_definitions

	arg_4_0._title_title_widget = UIWidget.init(var_4_1.title_title)
	arg_4_0._sub_title_text_widget = UIWidget.init(var_4_1.sub_title_text)
	arg_4_0._emblem_widget = UIWidget.init(var_0_2(var_4_0))

	UIRenderer.clear_scenegraph_queue(arg_4_0._ui_renderer)

	arg_4_0._ui_animator = UIAnimator:new(arg_4_0._ui_scenegraph, var_0_3)
	arg_4_0._animations = {}

	local var_4_2 = "present_entry"

	arg_4_0._animation_key = arg_4_0:start_presentation_animation(var_4_2)
end

RoundEndEmblemPopupUI.set_input_manager = function (arg_5_0, arg_5_1)
	arg_5_0._input_manager = arg_5_1
end

RoundEndEmblemPopupUI.destroy = function (arg_6_0)
	arg_6_0._ui_animator = nil

	if arg_6_0._viewport_world and arg_6_0._fullscreen_effect_enabled then
		arg_6_0:set_fullscreen_effect_enable_state(false, 0, arg_6_0._viewport_world)
	end
end

RoundEndEmblemPopupUI.update = function (arg_7_0, arg_7_1)
	if var_0_4 then
		var_0_4 = false

		arg_7_0:_create_ui_elements()
	end

	arg_7_0._animations_running = arg_7_0:_update_animations(arg_7_1)

	arg_7_0:_draw(arg_7_1)
end

RoundEndEmblemPopupUI._update_animations = function (arg_8_0, arg_8_1)
	local var_8_0 = arg_8_0._animations
	local var_8_1 = arg_8_0._ui_animator

	var_8_1:update(arg_8_1)

	if arg_8_0._animation_key and var_8_0[arg_8_0._animation_key] and arg_8_0._viewport_world then
		local var_8_2 = arg_8_0._render_settings.blur_progress or 0

		arg_8_0:set_fullscreen_effect_enable_state(true, var_8_2, arg_8_0._viewport_world)
	end

	local var_8_3 = false

	for iter_8_0, iter_8_1 in pairs(var_8_0) do
		if var_8_1:is_animation_completed(iter_8_1) then
			var_8_1:stop_animation(iter_8_1)

			var_8_0[iter_8_0] = nil

			if arg_8_0._viewport_world and arg_8_0._fullscreen_effect_enabled then
				arg_8_0:set_fullscreen_effect_enable_state(false, 0, arg_8_0._viewport_world)
			end
		end

		var_8_3 = true
	end

	return var_8_3
end

RoundEndEmblemPopupUI._draw = function (arg_9_0, arg_9_1)
	local var_9_0 = arg_9_0._ui_renderer
	local var_9_1 = arg_9_0._ui_top_renderer
	local var_9_2 = arg_9_0._ui_scenegraph
	local var_9_3 = arg_9_0._input_manager:get_service("end_of_level")
	local var_9_4 = arg_9_0._render_settings
	local var_9_5 = var_9_4.alpha_multiplier

	UIRenderer.begin_pass(var_9_1, var_9_2, var_9_3, arg_9_1, nil, var_9_4)

	var_9_4.alpha_multiplier = arg_9_0._emblem_widget.alpha_multiplier or var_9_5

	UIRenderer.draw_widget(var_9_1, arg_9_0._emblem_widget)

	var_9_4.alpha_multiplier = arg_9_0._title_title_widget.alpha_multiplier or var_9_5

	UIRenderer.draw_widget(var_9_1, arg_9_0._title_title_widget)

	var_9_4.alpha_multiplier = arg_9_0._sub_title_text_widget.alpha_multiplier or var_9_5

	UIRenderer.draw_widget(var_9_1, arg_9_0._sub_title_text_widget)
	UIRenderer.end_pass(var_9_1)

	var_9_4.alpha_multiplier = var_9_5
	var_9_4.alpha_multiplier = var_9_5
end

RoundEndEmblemPopupUI.is_presentation_complete = function (arg_10_0)
	return not arg_10_0._animations_running
end

RoundEndEmblemPopupUI.start_presentation_animation = function (arg_11_0, arg_11_1, arg_11_2)
	local var_11_0 = {
		wwise_world = arg_11_0._wwise_world,
		render_settings = arg_11_0._render_settings
	}
	local var_11_1 = arg_11_2 or {
		title_title = arg_11_0._title_title_widget,
		sub_title_text = arg_11_0._sub_title_text_widget,
		emblem = arg_11_0._emblem_widget
	}
	local var_11_2 = arg_11_0._ui_animator:start_animation(arg_11_1, var_11_1, var_0_1, var_11_0)
	local var_11_3 = arg_11_1 .. var_11_2

	arg_11_0._animations[var_11_3] = var_11_2
	arg_11_0._animation_params = var_11_0

	return var_11_3
end

RoundEndEmblemPopupUI.set_fullscreen_effect_enable_state = function (arg_12_0, arg_12_1, arg_12_2, arg_12_3)
	local var_12_0 = World.get_data(arg_12_3, "shading_environment")

	arg_12_2 = arg_12_2 or arg_12_1 and 1 or 0

	if var_12_0 then
		ShadingEnvironment.set_scalar(var_12_0, "fullscreen_blur_enabled", arg_12_1 and 1 or 0)
		ShadingEnvironment.set_scalar(var_12_0, "fullscreen_blur_amount", arg_12_1 and arg_12_2 * 0.75 or 0)
		ShadingEnvironment.apply(var_12_0)
	end

	arg_12_0._fullscreen_effect_enabled = arg_12_1
end
