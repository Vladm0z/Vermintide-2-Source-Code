-- chunkname: @scripts/ui/views/deus_menu/deus_debug_changelog_view.lua

require("scripts/settings/dlcs/morris/morris_changelog")

DeusDebugChangelogView = class(DeusDebugChangelogView)

DeusDebugChangelogView.init = function (self, arg_1_1)
	-- function 1
	local str = "deus_debug_changelog_view"
	local input_manager = arg_1_1.input_manager

	self._input_manager = input_manager
	self._input_service_name = str
	self.ingame_ui = arg_1_1.ingame_ui

	input_manager:create_input_service(str, "IngameMenuKeymaps", "IngameMenuFilters")
	input_manager:map_device_to_service(str, "keyboard")
	input_manager:map_device_to_service(str, "mouse")
	input_manager:map_device_to_service(str, "gamepad")
end

DeusDebugChangelogView.destroy = function (arg_2_0)
	-- function 2
	return
end

DeusDebugChangelogView.on_enter = function (self, arg_3_1)
	-- function 3
	local _input_manager = self._input_manager
	local _input_service_name = self._input_service_name

	_input_manager:block_device_except_service(_input_service_name, "keyboard")
	_input_manager:block_device_except_service(_input_service_name, "mouse")
	_input_manager:block_device_except_service(_input_service_name, "gamepad")
	ShowCursorStack.show("DeusDebugChangelogView")
	Imgui.open_imgui()
	Imgui.enable_imgui_input_system(Imgui.KEYBOARD)
	Imgui.enable_imgui_input_system(Imgui.MOUSE)
	Window.set_mouse_focus(false)

	self._changelog = MorrisChangelog
end

DeusDebugChangelogView.post_update_on_enter = function (arg_4_0)
	-- function 4
	return
end

DeusDebugChangelogView.on_exit = function (self)
	-- function 5
	local _input_manager = self._input_manager

	_input_manager:device_unblock_all_services("keyboard")
	_input_manager:device_unblock_all_services("mouse")
	_input_manager:device_unblock_all_services("gamepad")
	ShowCursorStack.hide("DeusDebugChangelogView")
	Window.set_mouse_focus(true)
	Imgui.disable_imgui_input_system(Imgui.KEYBOARD)
	Imgui.disable_imgui_input_system(Imgui.MOUSE)
	Imgui.close_imgui()
end

DeusDebugChangelogView.post_update_on_exit = function (arg_6_0)
	-- function 6
	return
end

DeusDebugChangelogView.update = function (self, arg_7_1, arg_7_2)
	-- function 7
	Imgui.begin_window("Morris Changelog", "always_auto_resize", "no_resize", "no_title_bar", "no_move")

	local _changelog = self._changelog

	for i, v in ipairs(_changelog) do
		local num = #_changelog - i
		local str = "Update " .. num

		if i == 1 then
			Imgui.text(str)
			Imgui.text(v)
		elseif not Imgui.tree_node(str) then
			Imgui.text(v)
			Imgui.tree_pop()
		end
	end

	if not Imgui.button("Close", 400, 50) then
		self:_close()
	end

	Imgui.end_window()
	self:handle_input(arg_7_1)
end

DeusDebugChangelogView.handle_input = function (self, arg_8_1)
	-- function 8
	local get_service = self._input_manager:get_service(self._input_service_name)

	if get_service:get("toggle_menu", true) or not get_service:get("back", true) then
		self:_close()
	end
end

DeusDebugChangelogView.disable_toggle_menu = function (arg_9_0)
	-- function 9
	return true
end

DeusDebugChangelogView.input_service = function (self)
	-- function 10
	return self._input_manager:get_service(self._input_service_name)
end

DeusDebugChangelogView._close = function (self)
	-- function 11
	self.ingame_ui:handle_transition("exit_menu")
end
