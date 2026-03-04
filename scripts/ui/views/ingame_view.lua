-- chunkname: @scripts/ui/views/ingame_view.lua

require("scripts/ui/views/ingame_view_definitions")
require("scripts/ui/views/ingame_view_layout_logic")
require("scripts/ui/views/menu_input_description_ui")

local var_0_0 = local_require("scripts/ui/views/ingame_view_menu_layout")
local var_0_1 = {
	{
		input_action = "confirm",
		priority = 2,
		description_text = "input_description_open"
	},
	{
		input_action = "back",
		priority = 3,
		description_text = "input_description_close"
	}
}

IngameView = class(IngameView)

function IngameView.init(arg_1_0, arg_1_1)
	arg_1_0.ui_renderer = arg_1_1.ui_renderer
	arg_1_0.ui_top_renderer = arg_1_1.ui_top_renderer
	arg_1_0.input_manager = arg_1_1.input_manager
	arg_1_0.menu_active = false
	arg_1_0.ingame_ui = arg_1_1.ingame_ui
	arg_1_0.render_settings = {
		snap_pixel_positions = true
	}
	arg_1_0.ingame_ui_context = arg_1_1
	arg_1_0.network_lobby = arg_1_1.network_lobby

	local var_1_0 = arg_1_1.is_in_inn

	arg_1_0.is_server = arg_1_1.is_server
	arg_1_0.menu_definition = IngameViewDefinitions

	arg_1_0:create_ui_elements()

	arg_1_0.ui_animations = {}
	arg_1_0.controller_grid_index = {
		x = 1,
		y = 1
	}
	arg_1_0.controller_cooldown = 0

	local var_1_1 = arg_1_0.input_manager:get_service("ingame_menu")
	local var_1_2 = 3
	local var_1_3 = Managers.world:world("level_world")

	arg_1_0.wwise_world = Managers.world:wwise_world(var_1_3)
	arg_1_0._friends_component_ui = FriendsUIComponent:new(arg_1_1)

	local var_1_4 = arg_1_0.menu_definition.scenegraph_definition.root.position[3]

	arg_1_0.menu_input_description = MenuInputDescriptionUI:new(arg_1_1, arg_1_0.ui_top_renderer, var_1_1, var_1_2, var_1_4, var_0_1)

	arg_1_0.menu_input_description:set_input_description(nil)
end

local var_0_2 = 0.3

function IngameView.on_enter(arg_2_0, arg_2_1)
	arg_2_0.layout_logic = IngameViewLayoutLogic:new(arg_2_0.ingame_ui_context, arg_2_1, var_0_0.menu_layouts, var_0_0.full_access_layout)
	arg_2_0.controller_cooldown = 0.2

	arg_2_0.input_manager:block_device_except_service("ingame_menu", "keyboard", 1)
	arg_2_0.input_manager:block_device_except_service("ingame_menu", "mouse", 1)
	arg_2_0.input_manager:block_device_except_service("ingame_menu", "gamepad", 1)

	if script_data.debug_enabled then
		arg_2_0.input_manager:device_unblock_service("keyboard", 1, "Debug")
	end

	ShowCursorStack.show("IngameView")
	arg_2_0:play_sound("Play_hud_button_open")

	local var_2_0 = arg_2_0.ui_renderer.world
	local var_2_1 = World.get_data(var_2_0, "shading_environment")

	if var_2_1 then
		ShadingEnvironment.set_scalar(var_2_1, "fullscreen_blur_enabled", 1)
		ShadingEnvironment.set_scalar(var_2_1, "fullscreen_blur_amount", 0.75)
		ShadingEnvironment.apply(var_2_1)
	end

	Managers.state.event:trigger("ingame_menu_opened", "interacting")
end

function IngameView.on_exit(arg_3_0)
	if arg_3_0._friends_component_ui:is_active() then
		arg_3_0._friends_component_ui:deactivate_friends_ui()
	end

	ShowCursorStack.hide("IngameView")
	arg_3_0.input_manager:device_unblock_all_services("keyboard", 1)
	arg_3_0.input_manager:device_unblock_all_services("mouse", 1)
	arg_3_0.input_manager:device_unblock_all_services("gamepad", 1)
	arg_3_0:play_sound("Play_hud_button_close")

	local var_3_0 = arg_3_0.ui_renderer.world
	local var_3_1 = World.get_data(var_3_0, "shading_environment")

	if var_3_1 then
		ShadingEnvironment.set_scalar(var_3_1, "fullscreen_blur_enabled", 0)
		ShadingEnvironment.set_scalar(var_3_1, "fullscreen_blur_amount", 0)
		ShadingEnvironment.apply(var_3_1)
	end

	Managers.state.event:trigger("ingame_menu_closed")
	arg_3_0.layout_logic:destroy()

	arg_3_0.layout_logic = nil
end

function IngameView.input_service(arg_4_0)
	return arg_4_0.input_manager:get_service("ingame_menu")
end

function IngameView.create_ui_elements(arg_5_0)
	local var_5_0 = arg_5_0.menu_definition.widgets

	arg_5_0.stored_buttons = {
		UIWidget.init(var_5_0.button_1),
		UIWidget.init(var_5_0.button_2),
		UIWidget.init(var_5_0.button_3),
		UIWidget.init(var_5_0.button_4),
		UIWidget.init(var_5_0.button_5),
		UIWidget.init(var_5_0.button_6),
		UIWidget.init(var_5_0.button_7),
		UIWidget.init(var_5_0.button_8),
		UIWidget.init(var_5_0.button_9)
	}

	for iter_5_0, iter_5_1 in ipairs(arg_5_0.stored_buttons) do
		iter_5_1.style.title_text.localize = true
		iter_5_1.style.title_text_disabled.localize = true
		iter_5_1.style.title_text_shadow.localize = true
	end

	arg_5_0.static_widgets = {
		UIWidget.init(var_5_0.background),
		UIWidget.init(var_5_0.top_panel),
		UIWidget.init(var_5_0.left_chain_end)
	}
	arg_5_0.left_chain_widget = UIWidget.init(var_5_0.left_chain)
	arg_5_0.right_chain_widget = UIWidget.init(var_5_0.right_chain)
	arg_5_0.console_cursor_widget = UIWidget.init(var_5_0.console_cursor)
	arg_5_0.ui_scenegraph = UISceneGraph.init_scenegraph(arg_5_0.menu_definition.scenegraph_definition)
end

function IngameView._update_presentation(arg_6_0)
	local var_6_0 = #arg_6_0.layout_logic:layout_data()

	if var_6_0 ~= arg_6_0._num_entries then
		local var_6_1 = arg_6_0.controller_selection_index

		if var_6_1 and var_6_0 < var_6_1 then
			arg_6_0:controller_select_button_index(var_6_0, true)
		end

		arg_6_0:set_background_height(var_6_0)

		arg_6_0._num_entries = var_6_0
	end
end

function IngameView.destroy(arg_7_0)
	arg_7_0.menu_input_description:destroy()

	arg_7_0.menu_input_description = nil
end

function IngameView.set_background_height(arg_8_0, arg_8_1)
	local var_8_0 = arg_8_0.menu_definition.MENU_BUTTON_SPACING
	local var_8_1 = arg_8_1 * (arg_8_0.menu_definition.MENU_BUTTON_SIZE[2] + var_8_0)
	local var_8_2 = arg_8_0.ui_scenegraph

	var_8_2.window.size[2] = var_8_1
	var_8_2[arg_8_0.left_chain_widget.scenegraph_id].size[2] = var_8_1 + 40
	var_8_2[arg_8_0.right_chain_widget.scenegraph_id].size[2] = var_8_1 + 100
end

function IngameView.update(arg_9_0, arg_9_1)
	local var_9_0 = arg_9_0.layout_logic

	var_9_0:update(arg_9_1)
	arg_9_0:_update_presentation()

	if arg_9_0._reinit_menu_input_description_next_update then
		arg_9_0._reinit_menu_input_description_next_update = nil

		arg_9_0.menu_input_description:set_input_description(var_0_1)
	end

	local var_9_1 = arg_9_0.ui_top_renderer
	local var_9_2 = arg_9_0.input_manager
	local var_9_3 = var_9_2:get_service("ingame_menu")
	local var_9_4 = var_9_2:is_device_active("gamepad")

	if Managers.account:is_online() then
		arg_9_0._friends_component_ui:update(arg_9_1, var_9_3)
	end

	local var_9_5 = arg_9_0.ui_animations

	for iter_9_0, iter_9_1 in pairs(var_9_5) do
		UIAnimation.update(iter_9_1, arg_9_1)
	end

	local var_9_6 = arg_9_0.ui_scenegraph

	UIRenderer.begin_pass(var_9_1, var_9_6, var_9_3, arg_9_1, nil, arg_9_0.render_settings)
	UIRenderer.draw_widget(var_9_1, arg_9_0.left_chain_widget)
	UIRenderer.draw_widget(var_9_1, arg_9_0.right_chain_widget)

	for iter_9_2, iter_9_3 in ipairs(arg_9_0.static_widgets) do
		UIRenderer.draw_widget(var_9_1, iter_9_3)
	end

	if var_9_4 then
		UIRenderer.draw_widget(var_9_1, arg_9_0.console_cursor_widget)
	end

	local var_9_7 = var_9_0:layout_data()
	local var_9_8 = arg_9_0.ingame_ui

	if var_9_7 then
		local var_9_9 = arg_9_0.stored_buttons

		for iter_9_4, iter_9_5 in ipairs(var_9_7) do
			local var_9_10 = var_9_9[iter_9_4]
			local var_9_11 = var_9_10.content

			var_9_11.button_hotspot.disable_button = iter_9_5.disabled
			var_9_11.title_text = iter_9_5.display_name

			UIWidgetUtils.animate_default_button(var_9_10, arg_9_1)
			UIRenderer.draw_widget(var_9_1, var_9_10)

			if var_9_10.content.button_hotspot.on_hover_enter then
				arg_9_0:play_sound("Play_hud_hover")
			end

			if not var_9_8:pending_transition() then
				local var_9_12 = var_9_10.content.button_hotspot.on_release
				local var_9_13 = arg_9_0.controller_cooldown < 0 and arg_9_0.controller_selection_index == iter_9_4 and var_9_3:get("confirm", true)

				if var_9_12 or var_9_13 then
					var_9_10.content.button_hotspot.on_release = nil

					arg_9_0:play_sound("Play_hud_select")
					var_9_0:execute_layout_option(iter_9_4)

					arg_9_0._reinit_menu_input_description_next_update = true
					arg_9_0.controller_cooldown = GamepadSettings.menu_cooldown
				end
			end
		end
	end

	UIRenderer.end_pass(var_9_1)

	arg_9_0.gamepad_active_last_frame = var_9_4

	local var_9_14 = arg_9_0._friends_component_ui:join_lobby_data()

	if var_9_14 and Managers.matchmaking:allowed_to_initiate_join_lobby() then
		Managers.matchmaking:request_join_lobby(var_9_14)
		var_9_8:handle_transition("exit_menu")
	end

	if (var_9_3:get("toggle_menu", true) or var_9_3:get("back", true)) and not var_9_8:pending_transition() then
		var_9_8:handle_transition("exit_menu")
	end
end

function IngameView.setup_controller_selection(arg_10_0)
	local var_10_0 = 1

	arg_10_0:controller_select_button_index(var_10_0, true)
end

function IngameView.controller_select_button_index(arg_11_0, arg_11_1, arg_11_2)
	local var_11_0 = false
	local var_11_1 = arg_11_0.layout_logic
	local var_11_2 = arg_11_0.stored_buttons
	local var_11_3 = var_11_1:layout_data()
	local var_11_4 = var_11_2[arg_11_1]

	if not var_11_3[arg_11_1] or var_11_4.content.button_hotspot.disable_button then
		return var_11_0
	end

	local var_11_5 = arg_11_0.gamepad_button_selection_widget.scenegraph_id
	local var_11_6 = arg_11_0.menu_definition.scenegraph_definition[var_11_5].position
	local var_11_7 = arg_11_0.ui_scenegraph[var_11_5].local_position

	for iter_11_0, iter_11_1 in ipairs(var_11_3) do
		local var_11_8 = var_11_2[iter_11_0]
		local var_11_9 = iter_11_0 == arg_11_1

		var_11_8.content.button_hotspot.is_selected = var_11_9

		if var_11_9 then
			local var_11_10 = var_11_8.scenegraph_id
			local var_11_11 = arg_11_0.ui_scenegraph[var_11_10].local_position

			var_11_7[2] = var_11_6[2] - iter_11_0 * 84
		end
	end

	if not arg_11_2 and arg_11_1 ~= arg_11_0.controller_selection_index then
		arg_11_0:play_sound("Play_hud_hover")
	end

	arg_11_0.controller_selection_index = arg_11_1

	return true
end

function IngameView.clear_controller_selection(arg_12_0)
	local var_12_0 = arg_12_0.layout_logic
	local var_12_1 = arg_12_0.stored_buttons
	local var_12_2 = var_12_0:layout_data()

	for iter_12_0, iter_12_1 in ipairs(var_12_2) do
		var_12_1[iter_12_0].content.button_hotspot.is_selected = false
	end
end

function IngameView.update_controller_input(arg_13_0, arg_13_1, arg_13_2)
	local var_13_0 = #arg_13_0.layout_logic:layout_data()

	if arg_13_0.controller_cooldown > 0 then
		arg_13_0.controller_cooldown = arg_13_0.controller_cooldown - arg_13_2

		local var_13_1 = arg_13_0.speed_multiplier or 1
		local var_13_2 = GamepadSettings.menu_speed_multiplier_frame_decrease
		local var_13_3 = GamepadSettings.menu_min_speed_multiplier

		arg_13_0.speed_multiplier = math.max(var_13_1 - var_13_2, var_13_3)

		return
	else
		local var_13_4 = arg_13_0.speed_multiplier or 1

		repeat
			local var_13_5 = arg_13_1:get("move_up")
			local var_13_6 = arg_13_1:get("move_up_hold")
			local var_13_7 = arg_13_0.controller_selection_index or 0

			if var_13_5 or var_13_6 then
				local var_13_8 = math.max(var_13_7 - 1, 1)
				local var_13_9 = arg_13_0:controller_select_button_index(var_13_8)

				while not var_13_9 do
					var_13_8 = math.max(var_13_8 - 1, 1)
					var_13_9 = arg_13_0:controller_select_button_index(var_13_8)
				end

				arg_13_0.controller_cooldown = GamepadSettings.menu_cooldown * var_13_4

				return
			end

			local var_13_10 = arg_13_1:get("move_down")
			local var_13_11 = arg_13_1:get("move_down_hold")

			if var_13_10 or var_13_11 then
				local var_13_12 = math.min(var_13_7 + 1, var_13_0)
				local var_13_13 = arg_13_0:controller_select_button_index(var_13_12)

				while not var_13_13 do
					var_13_12 = math.min(var_13_12 + 1, var_13_0)
					var_13_13 = arg_13_0:controller_select_button_index(var_13_12)
				end

				arg_13_0.controller_cooldown = GamepadSettings.menu_cooldown * var_13_4

				return
			end
		until true
	end

	arg_13_0.speed_multiplier = 1
end

function IngameView.get_transition(arg_14_0)
	if arg_14_0.leave_game then
		return "leave_game"
	end
end

function IngameView.play_sound(arg_15_0, arg_15_1)
	WwiseWorld.trigger_event(arg_15_0.wwise_world, arg_15_1)
end
