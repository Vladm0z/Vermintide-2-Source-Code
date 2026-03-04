-- chunkname: @scripts/ui/help_screen/help_screen_ui.lua

local var_0_0 = dofile("scripts/ui/help_screen/help_screen_definitions")

require("scripts/ui/help_screen/help_screen_settings")

HelpScreenUI = class(HelpScreenUI)

function HelpScreenUI.init(arg_1_0, arg_1_1)
	arg_1_0._world = arg_1_1.world
	arg_1_0._ui_renderer = arg_1_1.ui_renderer
	arg_1_0._ui_top_renderer = arg_1_1.ui_top_renderer
	arg_1_0._ingame_ui = arg_1_1.ingame_ui
	arg_1_0._world_manager = arg_1_1.world_manager

	local var_1_0 = arg_1_0._world_manager:world("level_world")

	arg_1_0._wwise_world = Managers.world:wwise_world(var_1_0)

	local var_1_1 = arg_1_1.input_manager

	arg_1_0._input_manager = var_1_1

	var_1_1:create_input_service("help_screen_view", "IngameMenuKeymaps", "IngameMenuFilters")
	var_1_1:map_device_to_service("help_screen_view", "keyboard")
	var_1_1:map_device_to_service("help_screen_view", "mouse")
	var_1_1:map_device_to_service("help_screen_view", "gamepad")

	arg_1_0._input_service = arg_1_0._input_manager:get_service("help_screen_view")
	arg_1_0._ingame_ui_context = arg_1_1
	arg_1_0._render_settings = {
		snap_pixel_positions = true
	}
	arg_1_0._current_view = nil
	arg_1_0._current_index = 1
end

function HelpScreenUI._create_ui_elements(arg_2_0)
	arg_2_0._ui_scenegraph = UISceneGraph.init_scenegraph(var_0_0.scenegraph_definition)

	arg_2_0:_set_page(arg_2_0._current_index)

	DO_RELOAD = false
end

DO_RELOAD = true

function HelpScreenUI.update(arg_3_0, arg_3_1)
	if not arg_3_0._current_view then
		return
	end

	if DO_RELOAD then
		arg_3_0:_create_ui_elements()
	end

	arg_3_0:_update_input(arg_3_1)
	arg_3_0:_draw(arg_3_1)
end

function HelpScreenUI.show_help(arg_4_0, arg_4_1, arg_4_2, arg_4_3)
	if arg_4_3 then
		-- block empty
	end

	if HelpScreens[arg_4_1] then
		arg_4_0._current_view = arg_4_1
		arg_4_0._current_index = 1

		arg_4_0:_create_ui_elements()

		if arg_4_2 then
			Managers.input:device_block_service("gamepad", 1, arg_4_2)
			Managers.input:device_block_service("keyboard", 1, arg_4_2)
			Managers.input:device_block_service("mouse", 1, arg_4_2)

			arg_4_0._disabled_input_service_name = arg_4_2
		end

		Managers.input:device_unblock_service("gamepad", 1, "help_screen_view")
		Managers.input:device_unblock_service("keyboard", 1, "help_screen_view")
		Managers.input:device_unblock_service("mouse", 1, "help_screen_view")
		arg_4_0:_set_page(arg_4_0._current_index)
	else
		Application.warning(string.format("HelpScreenUI] Help screen not available (%s)", arg_4_1))
	end
end

function HelpScreenUI.hide_help(arg_5_0)
	arg_5_0:_close_help()
end

function HelpScreenUI._set_page(arg_6_0, arg_6_1)
	local var_6_0 = HelpScreens[arg_6_0._current_view][arg_6_1]

	arg_6_0._help_screen_widget = UIWidget.init(var_0_0.help_screen_widget_func(#HelpScreens[arg_6_0._current_view], arg_6_1))

	for iter_6_0, iter_6_1 in pairs(var_6_0) do
		arg_6_0._help_screen_widget.content[iter_6_0] = iter_6_1
	end
end

function HelpScreenUI._draw(arg_7_0, arg_7_1)
	local var_7_0 = arg_7_0._ui_renderer
	local var_7_1 = arg_7_0._ui_top_renderer
	local var_7_2 = arg_7_0._ui_scenegraph
	local var_7_3 = arg_7_0._input_service
	local var_7_4 = arg_7_0._render_settings

	UIRenderer.begin_pass(var_7_1, var_7_2, var_7_3, arg_7_1, nil, var_7_4)
	UIRenderer.draw_widget(var_7_1, arg_7_0._help_screen_widget)
	UIRenderer.end_pass(var_7_1)
end

function HelpScreenUI._update_input(arg_8_0, arg_8_1)
	if arg_8_0._input_service:get("move_left", true) then
		arg_8_0._current_index = math.max(arg_8_0._current_index - 1, 1)

		arg_8_0:_set_page(arg_8_0._current_index)
	elseif arg_8_0._input_service:get("move_right", true) then
		arg_8_0._current_index = arg_8_0._current_index + 1

		if arg_8_0._current_index > #HelpScreens[arg_8_0._current_view] then
			arg_8_0:_close_help()
		else
			arg_8_0:_set_page(arg_8_0._current_index)
		end
	elseif arg_8_0._input_service:get("back", true) or arg_8_0._input_service:get("show_gamercard", true) then
		arg_8_0:_close_help()
	end
end

function HelpScreenUI._close_help(arg_9_0)
	if arg_9_0._disabled_input_service_name then
		Managers.input:device_unblock_service("gamepad", 1, arg_9_0._disabled_input_service_name)
		Managers.input:device_unblock_service("keyboard", 1, arg_9_0._disabled_input_service_name)
		Managers.input:device_unblock_service("mouse", 1, arg_9_0._disabled_input_service_name)
	end

	arg_9_0._current_view = nil
	arg_9_0._current_index = 1
	arg_9_0._disabled_input_service_name = nil
end

function HelpScreenUI.destroy(arg_10_0)
	return
end
