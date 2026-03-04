-- chunkname: @scripts/ui/views/deus_menu/deus_debug_changelog_view.lua

require("scripts/settings/dlcs/morris/morris_changelog")

DeusDebugChangelogView = class(DeusDebugChangelogView)

function DeusDebugChangelogView.init(arg_1_0, arg_1_1)
	local var_1_0 = "deus_debug_changelog_view"
	local var_1_1 = arg_1_1.input_manager

	arg_1_0._input_manager = var_1_1
	arg_1_0._input_service_name = var_1_0
	arg_1_0.ingame_ui = arg_1_1.ingame_ui

	var_1_1:create_input_service(var_1_0, "IngameMenuKeymaps", "IngameMenuFilters")
	var_1_1:map_device_to_service(var_1_0, "keyboard")
	var_1_1:map_device_to_service(var_1_0, "mouse")
	var_1_1:map_device_to_service(var_1_0, "gamepad")
end

function DeusDebugChangelogView.destroy(arg_2_0)
	return
end

function DeusDebugChangelogView.on_enter(arg_3_0, arg_3_1)
	local var_3_0 = arg_3_0._input_manager
	local var_3_1 = arg_3_0._input_service_name

	var_3_0:block_device_except_service(var_3_1, "keyboard")
	var_3_0:block_device_except_service(var_3_1, "mouse")
	var_3_0:block_device_except_service(var_3_1, "gamepad")
	ShowCursorStack.show("DeusDebugChangelogView")
	Imgui.open_imgui()
	Imgui.enable_imgui_input_system(Imgui.KEYBOARD)
	Imgui.enable_imgui_input_system(Imgui.MOUSE)
	Window.set_mouse_focus(false)

	arg_3_0._changelog = MorrisChangelog
end

function DeusDebugChangelogView.post_update_on_enter(arg_4_0)
	return
end

function DeusDebugChangelogView.on_exit(arg_5_0)
	local var_5_0 = arg_5_0._input_manager

	var_5_0:device_unblock_all_services("keyboard")
	var_5_0:device_unblock_all_services("mouse")
	var_5_0:device_unblock_all_services("gamepad")
	ShowCursorStack.hide("DeusDebugChangelogView")
	Window.set_mouse_focus(true)
	Imgui.disable_imgui_input_system(Imgui.KEYBOARD)
	Imgui.disable_imgui_input_system(Imgui.MOUSE)
	Imgui.close_imgui()
end

function DeusDebugChangelogView.post_update_on_exit(arg_6_0)
	return
end

function DeusDebugChangelogView.update(arg_7_0, arg_7_1, arg_7_2)
	Imgui.begin_window("Morris Changelog", "always_auto_resize", "no_resize", "no_title_bar", "no_move")

	local var_7_0 = arg_7_0._changelog

	for iter_7_0, iter_7_1 in ipairs(var_7_0) do
		local var_7_1 = #var_7_0 - iter_7_0
		local var_7_2 = "Update " .. var_7_1

		if iter_7_0 == 1 then
			Imgui.text(var_7_2)
			Imgui.text(iter_7_1)
		elseif Imgui.tree_node(var_7_2) then
			Imgui.text(iter_7_1)
			Imgui.tree_pop()
		end
	end

	if Imgui.button("Close", 400, 50) then
		arg_7_0:_close()
	end

	Imgui.end_window()
	arg_7_0:handle_input(arg_7_1)
end

function DeusDebugChangelogView.handle_input(arg_8_0, arg_8_1)
	local var_8_0 = arg_8_0._input_manager:get_service(arg_8_0._input_service_name)

	if var_8_0:get("toggle_menu", true) or var_8_0:get("back", true) then
		arg_8_0:_close()
	end
end

function DeusDebugChangelogView.disable_toggle_menu(arg_9_0)
	return true
end

function DeusDebugChangelogView.input_service(arg_10_0)
	return arg_10_0._input_manager:get_service(arg_10_0._input_service_name)
end

function DeusDebugChangelogView._close(arg_11_0)
	arg_11_0.ingame_ui:handle_transition("exit_menu")
end
