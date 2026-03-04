-- chunkname: @scripts/ui/views/hero_view/windows/hero_window_ingame_view.lua

local var_0_0 = local_require("scripts/ui/views/hero_view/windows/definitions/hero_window_ingame_view_definitions")
local var_0_1 = local_require("scripts/ui/views/ingame_view_menu_layout_console")
local var_0_2 = var_0_0.widgets
local var_0_3 = var_0_0.title_button_definitions
local var_0_4 = var_0_0.scenegraph_definition
local var_0_5 = var_0_0.animation_definitions
local var_0_6 = var_0_0.generic_input_actions
local var_0_7 = "move_down_hold_continuous"
local var_0_8 = "move_up_hold_continuous"
local var_0_9 = false
local var_0_10 = {
	options_menu = function (arg_1_0)
		Managers.input:block_device_except_service("options_menu", "gamepad")
		arg_1_0:_activate_view("options_view")
	end,
	console_friends_menu = function (arg_2_0)
		Managers.input:block_device_except_service("console_friends_menu", "gamepad")
		arg_2_0:_activate_view("console_friends_view")
	end
}

HeroWindowIngameView = class(HeroWindowIngameView)
HeroWindowIngameView.NAME = "HeroWindowIngameView"

HeroWindowIngameView.on_enter = function (arg_3_0, arg_3_1, arg_3_2)
	print("[HeroViewWindow] Enter Substate HeroWindowIngameView")

	arg_3_0._params = arg_3_1
	arg_3_0.parent = arg_3_1.parent

	local var_3_0 = arg_3_1.ingame_ui_context

	arg_3_0.ingame_ui_context = var_3_0
	arg_3_0.ui_renderer = var_3_0.ui_renderer
	arg_3_0.ui_top_renderer = var_3_0.ui_top_renderer
	arg_3_0.input_manager = var_3_0.input_manager
	arg_3_0.statistics_db = var_3_0.statistics_db
	arg_3_0.render_settings = {
		snap_pixel_positions = true
	}
	arg_3_0.layout_logic = IngameViewLayoutLogic:new(var_3_0, arg_3_1, var_0_1.menu_layouts, var_0_1.full_access_layout)

	arg_3_0.layout_logic:update()

	local var_3_1 = Managers.player

	arg_3_0._stats_id = var_3_1:local_player():stats_id()
	arg_3_0.player_manager = var_3_1
	arg_3_0.peer_id = var_3_0.peer_id
	arg_3_0.hero_name = arg_3_1.hero_name
	arg_3_0.career_index = arg_3_1.career_index
	arg_3_0.profile_index = arg_3_1.profile_index

	local var_3_2 = arg_3_0.hero_name
	local var_3_3 = arg_3_0.career_index
	local var_3_4 = FindProfileIndex(var_3_2)
	local var_3_5 = SPProfiles[var_3_4].careers[var_3_3].name

	arg_3_0._animations = {}
	arg_3_0._ui_animations = {}

	arg_3_0:create_ui_elements(arg_3_1, arg_3_2)

	local var_3_6 = true

	arg_3_0:_on_button_selected(1, var_3_6)
	arg_3_0:_start_transition_animation("on_enter")
	arg_3_0:_init_menu_views()
end

HeroWindowIngameView._start_transition_animation = function (arg_4_0, arg_4_1)
	local var_4_0 = {
		wwise_world = arg_4_0.wwise_world,
		render_settings = arg_4_0.render_settings
	}
	local var_4_1 = {}
	local var_4_2 = arg_4_0.ui_animator:start_animation(arg_4_1, var_4_1, var_0_4, var_4_0)

	arg_4_0._animations[arg_4_1] = var_4_2
end

HeroWindowIngameView._init_menu_views = function (arg_5_0)
	local var_5_0 = arg_5_0.ingame_ui_context

	arg_5_0._views = {
		options_view = var_5_0.ingame_ui.views.options_view,
		console_friends_view = var_5_0.ingame_ui.views.console_friends_view
	}

	for iter_5_0, iter_5_1 in pairs(arg_5_0._views) do
		iter_5_1.old_exit = iter_5_1.exit

		iter_5_1.exit = function ()
			arg_5_0:exit_current_view()
		end
	end
end

HeroWindowIngameView._reset_menu_views = function (arg_7_0)
	for iter_7_0, iter_7_1 in pairs(arg_7_0._views) do
		iter_7_1.exit = iter_7_1.old_exit
		iter_7_1.old_exit = nil
	end

	arg_7_0._views = nil
end

HeroWindowIngameView._activate_view = function (arg_8_0, arg_8_1)
	arg_8_0._active_view = arg_8_1

	local var_8_0 = arg_8_0._views

	assert(var_8_0[arg_8_1])

	if arg_8_1 and var_8_0[arg_8_1] and var_8_0[arg_8_1].on_enter then
		var_8_0[arg_8_1]:on_enter()
	end
end

HeroWindowIngameView.exit_current_view = function (arg_9_0)
	local var_9_0 = arg_9_0._active_view
	local var_9_1 = arg_9_0._views

	assert(var_9_0)

	if var_9_1[var_9_0] and var_9_1[var_9_0].exit_reset_params then
		var_9_1[var_9_0]:exit_reset_params()
	end

	if var_9_1[var_9_0] and var_9_1[var_9_0].on_exit then
		var_9_1[var_9_0]:on_exit()
	end

	arg_9_0._active_view = nil

	local var_9_2 = Managers.input:get_service("hero_view").name
	local var_9_3 = Managers.input

	var_9_3:block_device_except_service(var_9_2, "keyboard")
	var_9_3:block_device_except_service(var_9_2, "mouse")
	var_9_3:block_device_except_service(var_9_2, "gamepad")
	var_9_3:disable_gamepad_cursor()
end

HeroWindowIngameView.create_ui_elements = function (arg_10_0, arg_10_1, arg_10_2)
	arg_10_0.ui_scenegraph = UISceneGraph.init_scenegraph(var_0_4)

	local var_10_0 = {}
	local var_10_1 = {}

	for iter_10_0, iter_10_1 in pairs(var_0_2) do
		local var_10_2 = UIWidget.init(iter_10_1)

		var_10_0[#var_10_0 + 1] = var_10_2
		var_10_1[iter_10_0] = var_10_2
	end

	arg_10_0._widgets = var_10_0
	arg_10_0._widgets_by_name = var_10_1

	local var_10_3 = {}

	for iter_10_2, iter_10_3 in pairs(var_0_3) do
		local var_10_4 = UIWidget.init(iter_10_3)

		var_10_3[#var_10_3 + 1] = var_10_4
	end

	arg_10_0._title_button_widgets = var_10_3

	UIRenderer.clear_scenegraph_queue(arg_10_0.ui_top_renderer)

	arg_10_0.ui_animator = UIAnimator:new(arg_10_0.ui_scenegraph, var_0_5)

	if arg_10_2 then
		local var_10_5 = arg_10_0.ui_scenegraph.window.local_position

		var_10_5[1] = var_10_5[1] + arg_10_2[1]
		var_10_5[2] = var_10_5[2] + arg_10_2[2]
		var_10_5[3] = var_10_5[3] + arg_10_2[3]
	end

	local var_10_6 = Managers.input:get_service("hero_view")
	local var_10_7 = UILayer.default + 300

	arg_10_0._menu_input_description = MenuInputDescriptionUI:new(nil, arg_10_0.ui_top_renderer, var_10_6, 3, var_10_7, var_0_6.default, true)

	arg_10_0._menu_input_description:set_input_description(nil)
end

HeroWindowIngameView.on_exit = function (arg_11_0, arg_11_1)
	print("[HeroViewWindow] Exit Substate HeroWindowIngameView")

	arg_11_0.ui_animator = nil

	arg_11_0._menu_input_description:destroy()

	arg_11_0._menu_input_description = nil

	local var_11_0 = arg_11_0.layout_logic

	if var_11_0 then
		var_11_0:destroy()

		arg_11_0.layout_logic = nil
	end

	arg_11_0:_reset_menu_views()
end

HeroWindowIngameView.update = function (arg_12_0, arg_12_1, arg_12_2)
	if var_0_9 then
		var_0_9 = false

		arg_12_0:create_ui_elements()
	end

	local var_12_0 = arg_12_0.layout_logic

	if var_12_0 then
		var_12_0:update(arg_12_1)
		arg_12_0:_update_presentation()
	end

	local var_12_1 = arg_12_0._active_view

	if var_12_1 then
		arg_12_0._views[var_12_1]:update(arg_12_1, arg_12_2)
	else
		arg_12_0:_handle_input(arg_12_1, arg_12_2)
	end

	arg_12_0:_update_animations(arg_12_1)
	arg_12_0:draw(arg_12_1)
end

HeroWindowIngameView.post_update = function (arg_13_0, arg_13_1, arg_13_2)
	return
end

HeroWindowIngameView._update_animations = function (arg_14_0, arg_14_1)
	local var_14_0 = arg_14_0._ui_animations
	local var_14_1 = arg_14_0._animations
	local var_14_2 = arg_14_0.ui_animator

	for iter_14_0, iter_14_1 in pairs(arg_14_0._ui_animations) do
		UIAnimation.update(iter_14_1, arg_14_1)

		if UIAnimation.completed(iter_14_1) then
			arg_14_0._ui_animations[iter_14_0] = nil
		end
	end

	var_14_2:update(arg_14_1)

	for iter_14_2, iter_14_3 in pairs(var_14_1) do
		if var_14_2:is_animation_completed(iter_14_3) then
			var_14_2:stop_animation(iter_14_3)

			var_14_1[iter_14_2] = nil
		end
	end
end

HeroWindowIngameView._is_button_pressed = function (arg_15_0, arg_15_1)
	local var_15_0 = arg_15_1.content
	local var_15_1 = var_15_0.button_hotspot or var_15_0.button_text

	if var_15_1.on_release then
		var_15_1.on_release = false

		return true
	end
end

HeroWindowIngameView._is_stepper_button_pressed = function (arg_16_0, arg_16_1)
	local var_16_0 = arg_16_1.content
	local var_16_1 = var_16_0.button_hotspot_left
	local var_16_2 = var_16_0.button_hotspot_right

	if var_16_1.on_release then
		var_16_1.on_release = false

		return true, -1
	elseif var_16_2.on_release then
		var_16_2.on_release = false

		return true, 1
	end
end

HeroWindowIngameView._is_button_hover_enter = function (arg_17_0, arg_17_1)
	local var_17_0 = arg_17_1.content.button_hotspot

	return var_17_0.on_hover_enter and not var_17_0.is_selected
end

HeroWindowIngameView._is_button_hover_exit = function (arg_18_0, arg_18_1)
	local var_18_0 = arg_18_1.content.button_hotspot

	return var_18_0.on_hover_exit and not var_18_0.is_selected
end

HeroWindowIngameView._is_button_selected = function (arg_19_0, arg_19_1)
	return arg_19_1.content.button_hotspot.is_selected
end

HeroWindowIngameView._handle_input = function (arg_20_0, arg_20_1, arg_20_2)
	local var_20_0 = arg_20_0.parent
	local var_20_1 = arg_20_0._widgets_by_name
	local var_20_2 = var_20_0:window_input_service()
	local var_20_3 = arg_20_0.layout_logic

	if var_20_3 then
		local var_20_4 = var_20_3:layout_data()
		local var_20_5 = #var_20_4
		local var_20_6 = arg_20_0._selected_button_index or 1
		local var_20_7 = false
		local var_20_8 = arg_20_0._title_button_widgets

		for iter_20_0, iter_20_1 in ipairs(var_20_4) do
			local var_20_9 = var_20_8[iter_20_0]
			local var_20_10 = iter_20_1.disabled

			if iter_20_0 ~= var_20_6 and arg_20_0:_is_button_hover_enter(var_20_9) and not var_20_10 then
				arg_20_0:_on_button_selected(iter_20_0)

				var_20_7 = true
			end

			if arg_20_0:_is_button_pressed(var_20_9) and not var_20_10 then
				var_20_7 = true

				arg_20_0:_on_button_pressed(iter_20_0, iter_20_1)
			end
		end

		if var_20_2:get("confirm_press", true) and var_20_4[var_20_6] then
			local var_20_11 = var_20_4[var_20_6]

			if not var_20_11.disabled then
				arg_20_0:_on_button_pressed(var_20_6, var_20_11)

				var_20_7 = true
			end
		end

		if not var_20_7 then
			local var_20_12 = var_20_6

			if var_20_2:get(var_0_8) then
				var_20_12 = arg_20_0:_get_previous_available_index(var_20_6)
			elseif var_20_2:get(var_0_7) then
				var_20_12 = arg_20_0:_get_next_available_index(var_20_6)
			end

			if var_20_12 ~= var_20_6 then
				arg_20_0:_on_button_selected(var_20_12)
			end
		end
	end
end

HeroWindowIngameView._get_next_available_index = function (arg_21_0, arg_21_1)
	local var_21_0 = arg_21_0.layout_logic

	if var_21_0 then
		local var_21_1 = var_21_0:layout_data()
		local var_21_2 = #var_21_1
		local var_21_3 = arg_21_1 % var_21_2 + 1

		while var_21_3 ~= arg_21_1 do
			if not var_21_1[var_21_3].disabled then
				return var_21_3
			end

			var_21_3 = var_21_3 % var_21_2 + 1
		end
	end

	return arg_21_1
end

HeroWindowIngameView._get_previous_available_index = function (arg_22_0, arg_22_1)
	local var_22_0 = arg_22_0.layout_logic

	if var_22_0 then
		local var_22_1 = var_22_0:layout_data()
		local var_22_2 = #var_22_1
		local var_22_3 = arg_22_1 > 1 and arg_22_1 - 1 or var_22_2

		while var_22_3 ~= arg_22_1 do
			if not var_22_1[var_22_3].disabled then
				return var_22_3
			end

			var_22_3 = var_22_3 > 1 and var_22_3 - 1 or var_22_2
		end
	end

	return arg_22_1
end

HeroWindowIngameView._on_button_pressed = function (arg_23_0, arg_23_1, arg_23_2)
	arg_23_0:_play_sound("play_gui_start_menu_button_click")

	local var_23_0 = arg_23_2.transition

	if var_0_10[var_23_0] then
		var_0_10[var_23_0](arg_23_0)
	else
		arg_23_0.layout_logic:execute_layout_option(arg_23_1)
	end
end

HeroWindowIngameView._on_button_selected = function (arg_24_0, arg_24_1, arg_24_2)
	local var_24_0 = arg_24_0._title_button_widgets

	for iter_24_0, iter_24_1 in ipairs(var_24_0) do
		iter_24_1.content.button_hotspot.is_selected = iter_24_0 == arg_24_1
	end

	if not arg_24_2 then
		arg_24_0:_play_sound("play_gui_start_menu_button_hover")
	end

	arg_24_0._selected_button_index = arg_24_1
end

HeroWindowIngameView.draw = function (arg_25_0, arg_25_1)
	local var_25_0 = arg_25_0.ui_renderer
	local var_25_1 = arg_25_0.ui_top_renderer
	local var_25_2 = arg_25_0.ui_scenegraph
	local var_25_3 = arg_25_0.parent:window_input_service()
	local var_25_4 = Managers.input:is_device_active("gamepad")
	local var_25_5 = arg_25_0.layout_logic

	UIRenderer.begin_pass(var_25_1, var_25_2, var_25_3, arg_25_1, nil, arg_25_0.render_settings)

	for iter_25_0, iter_25_1 in ipairs(arg_25_0._widgets) do
		UIRenderer.draw_widget(var_25_1, iter_25_1)
	end

	if var_25_5 then
		local var_25_6 = var_25_5:layout_data()
		local var_25_7 = arg_25_0._title_button_widgets

		for iter_25_2, iter_25_3 in ipairs(var_25_6) do
			local var_25_8 = var_25_7[iter_25_2]
			local var_25_9 = var_25_8.content

			var_25_9.button_hotspot.disable_button = iter_25_3.disabled
			var_25_9.text_field = iter_25_3.display_name_func and iter_25_3.display_name_func() or iter_25_3.display_name

			UIRenderer.draw_widget(var_25_1, var_25_8)
		end
	end

	UIRenderer.end_pass(var_25_1)

	if var_25_4 and arg_25_0._menu_input_description and not arg_25_0._active_view then
		arg_25_0._menu_input_description:draw(var_25_1, arg_25_1)
	end
end

HeroWindowIngameView._play_sound = function (arg_26_0, arg_26_1)
	arg_26_0.parent:play_sound(arg_26_1)
end

HeroWindowIngameView._update_presentation = function (arg_27_0)
	local var_27_0 = #arg_27_0.layout_logic:layout_data()

	if var_27_0 ~= arg_27_0._num_entries then
		local var_27_1 = arg_27_0._title_button_widgets
		local var_27_2 = 60
		local var_27_3 = 0

		for iter_27_0 = 1, var_27_0 do
			var_27_1[iter_27_0].offset[2] = -(var_27_2 * iter_27_0 - 1)
			var_27_3 = var_27_3 + var_27_2
		end

		local var_27_4 = arg_27_0._widgets_by_name.background.scenegraph_id

		arg_27_0.ui_scenegraph[var_27_4].size[2] = var_27_3 + 90
	end
end
