-- chunkname: @scripts/ui/dlc_morris/views/start_game_view/windows/start_game_window_deus_chaos_god_information.lua

local var_0_0 = local_require("scripts/ui/dlc_morris/views/start_game_view/windows/definitions/start_game_window_deus_chaos_god_information_definitions")
local var_0_1 = var_0_0.widgets

StartGameWindowDeusChaosGodInformation = class(StartGameWindowDeusChaosGodInformation)

StartGameWindowDeusChaosGodInformation.on_enter = function (arg_1_0, arg_1_1, arg_1_2)
	arg_1_0._parent = arg_1_1.parent

	local var_1_0 = arg_1_1.ingame_ui_context

	arg_1_0._ingame_ui_context = var_1_0
	arg_1_0._ui_top_renderer = var_1_0.ui_top_renderer
	arg_1_0._input_manager = var_1_0.input_manager
	arg_1_0._animations = {}
	arg_1_0._render_settings = {
		snap_pixel_positions = true
	}

	arg_1_0:_create_ui_elements(var_0_0, arg_1_1, arg_1_2)

	arg_1_0._should_draw = false

	arg_1_0:_start_animation("on_enter", arg_1_0._widgets_by_name.god_info_widget)
end

StartGameWindowDeusChaosGodInformation.on_exit = function (arg_2_0, arg_2_1)
	table.clear(arg_2_0)
end

StartGameWindowDeusChaosGodInformation._create_ui_elements = function (arg_3_0, arg_3_1, arg_3_2, arg_3_3)
	arg_3_0._scenegraph_definition = arg_3_1.scenegraph_definition
	arg_3_0._ui_scenegraph = UISceneGraph.init_scenegraph(arg_3_1.scenegraph_definition)
	arg_3_0._ui_animator = UIAnimator:new(arg_3_0._ui_scenegraph, arg_3_1.animation_definitions)
	arg_3_0._refresh_time = 0

	local var_3_0 = {}
	local var_3_1 = {}

	for iter_3_0, iter_3_1 in pairs(var_0_1) do
		local var_3_2 = UIWidget.init(iter_3_1)

		var_3_0[#var_3_0 + 1] = var_3_2
		var_3_1[iter_3_0] = var_3_2
	end

	arg_3_0._widgets = var_3_0
	arg_3_0._widgets_by_name = var_3_1

	UIRenderer.clear_scenegraph_queue(arg_3_0._ui_top_renderer)
	arg_3_0:_setup_belakor_information()
end

StartGameWindowDeusChaosGodInformation._start_animation = function (arg_4_0, arg_4_1, arg_4_2, arg_4_3)
	arg_4_3 = arg_4_3 or {}
	arg_4_3.render_settings = arg_4_0._render_settings
	arg_4_0._animations[arg_4_1] = arg_4_0._ui_animator:start_animation(arg_4_1, arg_4_2, arg_4_0._scenegraph_definition, arg_4_3)
end

StartGameWindowDeusChaosGodInformation.update = function (arg_5_0, arg_5_1, arg_5_2)
	arg_5_0:_update_animations(arg_5_1, arg_5_2)
	arg_5_0:_update_time_left()
	arg_5_0:_update_journey()

	if arg_5_0._should_draw then
		arg_5_0:_draw(arg_5_1, arg_5_2)
	end
end

StartGameWindowDeusChaosGodInformation._update_journey = function (arg_6_0)
	local var_6_0 = arg_6_0._parent:get_selected_level_id() or arg_6_0._journey_name

	if var_6_0 ~= arg_6_0._journey_name then
		arg_6_0._journey_name = var_6_0

		arg_6_0:_update_theme()
		arg_6_0:_update_belakor_status()
	end
end

StartGameWindowDeusChaosGodInformation.post_update = function (arg_7_0, arg_7_1, arg_7_2)
	return
end

StartGameWindowDeusChaosGodInformation._update_animations = function (arg_8_0, arg_8_1, arg_8_2)
	local var_8_0 = arg_8_0._ui_animator

	var_8_0:update(arg_8_1)

	local var_8_1 = arg_8_0._animations

	for iter_8_0, iter_8_1 in pairs(var_8_1) do
		if var_8_0:is_animation_completed(iter_8_1) then
			var_8_1[iter_8_0] = nil
		end
	end
end

StartGameWindowDeusChaosGodInformation._draw = function (arg_9_0, arg_9_1, arg_9_2)
	local var_9_0 = arg_9_0._ui_top_renderer
	local var_9_1 = arg_9_0._parent:window_input_service()

	UIRenderer.begin_pass(var_9_0, arg_9_0._ui_scenegraph, var_9_1, arg_9_1, nil, arg_9_0._render_settings)

	for iter_9_0 = 1, #arg_9_0._widgets do
		local var_9_2 = arg_9_0._widgets[iter_9_0]

		UIRenderer.draw_widget(var_9_0, var_9_2)
	end

	UIRenderer.end_pass(var_9_0)
end

StartGameWindowDeusChaosGodInformation._refresh_journey_data = function (arg_10_0)
	local var_10_0 = Managers.backend:get_interface("deus"):get_journey_cycle()

	arg_10_0._journey_cycle = var_10_0
	arg_10_0._refresh_time = var_10_0.remaining_time + var_10_0.time_of_update

	arg_10_0:_update_theme()
end

StartGameWindowDeusChaosGodInformation._update_time_left = function (arg_11_0)
	local var_11_0 = Managers.time:time("main")
	local var_11_1 = arg_11_0._refresh_time - var_11_0
	local var_11_2 = arg_11_0._widgets_by_name.god_info_widget.content

	if var_11_1 > 120 then
		local var_11_3 = var_11_1 / 86400
		local var_11_4 = var_11_1 / 3600 % 24
		local var_11_5 = var_11_1 / 60 % 60
		local var_11_6 = Localize("deus_start_game_mod_timer")

		var_11_2.subtitle = string.format(var_11_6, var_11_3, var_11_4, var_11_5)
	else
		local var_11_7 = Localize("deus_start_game_mod_timer_seconds")

		if var_11_1 < 0 then
			var_11_1 = 0

			arg_11_0:_refresh_journey_data()
		end

		var_11_2.subtitle = string.format(var_11_7, var_11_1)
	end

	arg_11_0:_update_belakor_time_left()
end

StartGameWindowDeusChaosGodInformation._update_theme = function (arg_12_0, arg_12_1)
	local var_12_0 = arg_12_0._journey_name
	local var_12_1 = arg_12_0._journey_cycle.journey_data[var_12_0]
	local var_12_2 = var_12_1 and var_12_1.dominant_god
	local var_12_3 = var_12_2 and DeusThemeSettings[var_12_2]

	if not var_12_3 then
		arg_12_0._should_draw = false

		return
	end

	arg_12_0._should_draw = true

	local var_12_4 = arg_12_0._parent:get_current_window_layout_settings()

	if var_12_4 and var_12_4.should_draw_god_info then
		arg_12_0._should_draw = var_12_4.should_draw_god_info(arg_12_0._ingame_ui_context)
	end

	arg_12_0:_start_animation("set_theme", arg_12_0._widgets_by_name.god_info_widget, {
		theme_settings = var_12_3
	})
end

StartGameWindowDeusChaosGodInformation._setup_belakor_information = function (arg_13_0)
	arg_13_0._belakor_refresh_time = 0
	arg_13_0._is_refreshing_belakor = false
	arg_13_0._widgets_by_name.belakor_info_widget.content.visible = false

	arg_13_0:_refresh_belakor_curse_data()
end

StartGameWindowDeusChaosGodInformation._refresh_belakor_curse_data = function (arg_14_0)
	local var_14_0 = Managers.backend:get_interface("deus"):get_belakor_cycle()

	if not var_14_0 then
		return false
	end

	arg_14_0._belakor_data = var_14_0
	arg_14_0._belakor_refresh_time = var_14_0.remaining_time + var_14_0.time_of_update

	Managers.state.event:trigger("_update_additional_curse_frame", arg_14_0._belakor_data.journey_name)
end

StartGameWindowDeusChaosGodInformation._update_belakor_time_left = function (arg_15_0)
	local var_15_0 = Managers.time:time("main")
	local var_15_1 = Managers.backend:get_interface("deus")
	local var_15_2 = var_15_1:deus_journey_with_belakor(arg_15_0._journey_name)
	local var_15_3 = math.max(arg_15_0._belakor_refresh_time - var_15_0, 0)

	if var_15_2 then
		local var_15_4 = arg_15_0._widgets_by_name.belakor_info_widget.content

		if var_15_3 > 120 then
			local var_15_5 = var_15_3 / 3600 % 24
			local var_15_6 = var_15_3 / 60 % 60
			local var_15_7 = Localize("datetime_hours_short")
			local var_15_8 = Localize("datetime_minutes_short")

			var_15_4.subtitle = string.format(var_15_7, var_15_5) .. " " .. string.format(var_15_8, var_15_6)
		else
			local var_15_9 = Localize("deus_start_game_mod_timer_seconds")

			var_15_4.subtitle = string.format(var_15_9, var_15_3)
		end
	end

	if var_15_3 <= 0 then
		if arg_15_0._is_refreshing_belakor then
			if var_15_1:has_loaded_belakor_data() then
				arg_15_0._is_refreshing_belakor = false

				arg_15_0:_refresh_belakor_curse_data()
				arg_15_0:_update_belakor_status()
			end
		else
			arg_15_0._is_refreshing_belakor = true

			var_15_1:refresh_belakor_cycle()
		end
	end
end

StartGameWindowDeusChaosGodInformation._update_belakor_status = function (arg_16_0)
	local var_16_0 = Managers.backend:get_interface("deus"):deus_journey_with_belakor(arg_16_0._journey_name)
	local var_16_1 = arg_16_0._widgets_by_name.belakor_info_widget

	if var_16_0 then
		arg_16_0:_start_animation("set_theme_belakor", var_16_1, {
			theme_settings = DeusThemeSettings.belakor
		})
	end

	var_16_1.content.visible = var_16_0
end
