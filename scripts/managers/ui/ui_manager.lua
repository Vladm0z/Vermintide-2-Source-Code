-- chunkname: @scripts/managers/ui/ui_manager.lua

require("scripts/managers/ui/popup_settings")

UIManager = class(UIManager)

UIManager.init = function (self)
	-- function 1
	self._ui_enabled = true
end

UIManager.destroy = function (self)
	-- function 2
	if not self._ingame_ui then
		print("[UIManager] Warning: destroy_ingame_ui was not called before destroy")
	end
end

UIManager.create_ingame_ui = function (self, arg_3_1, arg_3_2)
	-- function 3
	self._ingame_ui_context = arg_3_1
	self._loading_subtitle_gui = arg_3_2

	if not self._ingame_ui then
		print("[UIManager] Warning: destroy_ingame_ui was not called before create_ingame_ui")
		self._ingame_ui:destroy()
	end

	self._ingame_ui = IngameUI:new(arg_3_1)
	self._ui_enabled = true
end

UIManager.create_ui_renderer = function (self, arg_4_1, arg_4_2, arg_4_3, arg_4_4)
	-- function 4
	return self._ingame_ui:create_ui_renderer(arg_4_1, arg_4_2, arg_4_3, arg_4_4)
end

UIManager.destroy_ingame_ui = function (self)
	-- function 5
	local _ingame_ui = self._ingame_ui

	if not _ingame_ui then
		_ingame_ui:destroy()

		self._ingame_ui = nil
	end
end

UIManager.reload_ingame_ui = function (self, arg_6_1)
	-- function 6
	local _ingame_ui = self._ingame_ui

	if not _ingame_ui then
		print("[UIManager] Warning: reloading the UI when it wasn't loaded.")

		return
	end

	local last_transition_name = _ingame_ui.last_transition_name
	local last_transition_params = _ingame_ui.last_transition_params

	if not arg_6_1 then
		for k in pairs(package.loaded) do
			if not string.find(k, "^scripts/ui") then
				package.loaded[k] = nil

				require(k)
			end
		end
	end

	self:destroy_ingame_ui()
	self:create_ingame_ui(self._ingame_ui_context)

	if not last_transition_name then
		self._ingame_ui:handle_transition(last_transition_name, last_transition_params)
	end
end

UIManager.temporary_get_ingame_ui_called_from_state_ingame_running = function (self)
	-- function 7
	return self._ingame_ui
end

UIManager.set_ingame_ui_enabled = function (self, arg_8_1)
	-- function 8
	if self._ui_enabled ~= arg_8_1 then
		self._ui_enabled = arg_8_1

		if not arg_8_1 then
			local _ingame_ui = self._ingame_ui

			if not _ingame_ui then
				_ingame_ui:suspend_active_view()
			end
		end
	end
end

UIManager.update = function (self)
	-- function 9
	if not self._ui_enabled then
		return
	end

	if not self._ui_update_initialized then
		self._ui_update_initialized = true

		return
	end

	local _ingame_ui = self._ingame_ui

	if not _ingame_ui then
		return
	end

	local time_and_delta, var_9_2 = Managers.time:time_and_delta("ui")
	local active

	if not script_data.disable_ui then
		active = DebugScreen.active

		if not active then
			-- Nothing
		end
	end

	active = Managers.state.network:game_session_host() ~= nil

	::label_9_0::

	local _level_end_view_wrapper = self._level_end_view_wrapper
	local flag = not _level_end_view_wrapper and _level_end_view_wrapper:level_end_view()

	_ingame_ui:update(var_9_2, time_and_delta, active, flag)

	local _loading_subtitle_gui = self._loading_subtitle_gui

	if not _loading_subtitle_gui then
		_ingame_ui:update_loading_subtitle_gui(_loading_subtitle_gui, var_9_2)

		if not _loading_subtitle_gui:is_complete() then
			self._loading_subtitle_gui = nil
		end
	end

	if not _ingame_ui:end_screen_active() and not _ingame_ui:end_screen_completed() then
		Managers.state.event:trigger("end_screen_ui_complete")
	end
end

UIManager.end_screen_active = function (self)
	-- function 10
	return self._ingame_ui:end_screen_active()
end

UIManager.end_screen_completed = function (self)
	-- function 11
	return self._ingame_ui:end_screen_completed()
end

UIManager.activate_end_screen_ui = function (self, arg_12_1, arg_12_2, arg_12_3)
	-- function 12
	self._ingame_ui:activate_end_screen_ui(arg_12_1, arg_12_2, arg_12_3)
end

UIManager.post_update = function (self, arg_13_1, arg_13_2, arg_13_3)
	-- function 13
	local _ingame_ui = self._ingame_ui

	if not _ingame_ui then
		_ingame_ui:post_update(arg_13_1, arg_13_2, arg_13_3)
	end
end

UIManager.post_render = function (self)
	-- function 14
	local _ingame_ui = self._ingame_ui

	if not _ingame_ui then
		_ingame_ui:post_render()
	end
end

UIManager.get_transition = function (self)
	-- function 15
	local _ingame_ui = self._ingame_ui

	if not _ingame_ui then
		return _ingame_ui:get_transition()
	end
end

UIManager.restart_game = function (arg_16_0)
	-- function 16
	arg_16_0._ingame_ui.restart_game = true
end

UIManager.is_in_view_state = function (self, arg_17_1)
	-- function 17
	local _ingame_ui = self._ingame_ui

	if not _ingame_ui then
		return _ingame_ui:is_in_view_state(arg_17_1)
	end
end

UIManager.get_hud_component = function (self, arg_18_1)
	-- function 18
	return self._ingame_ui:get_hud_component(arg_18_1)
end

UIManager.open_popup = function (self, arg_19_1, ...)
	-- function 19
	return self._ingame_ui:open_popup(arg_19_1, ...)
end

UIManager.close_popup = function (self, arg_20_1)
	-- function 20
	return self._ingame_ui:close_popup(arg_20_1)
end

UIManager.get_active_popup = function (self, arg_21_1)
	-- function 21
	local _ingame_ui = self._ingame_ui

	if not _ingame_ui then
		return _ingame_ui:get_active_popup(arg_21_1)
	end
end

UIManager.handle_new_ui_disclaimer = function (self, arg_22_1, arg_22_2)
	-- function 22
	if Managers.input:is_device_active("gamepad") or not IS_CONSOLE then
		return
	end

	local user_setting = Application.user_setting("use_gamepad_menu_layout")
	local user_setting_2 = Application.user_setting("use_pc_menu_layout")

	if not (user_setting ~= false or user_setting_2 ~= false or arg_22_1[arg_22_2] or arg_22_1[arg_22_2] ~= nil) then
		self._ingame_ui.weave_onboarding:try_show_tutorial(WeaveUITutorials.new_ui_disclaimer)
		Application.set_user_setting("use_gamepad_menu_layout", nil)
		Application.save_user_settings()
	end
end

UIManager.handle_transition = function (self, arg_23_1, arg_23_2)
	-- function 23
	fassert(arg_23_2, "params are a required argument")

	local _ingame_ui = self._ingame_ui

	if not _ingame_ui then
		if not arg_23_2.use_fade then
			return _ingame_ui:transition_with_fade(arg_23_1, arg_23_2, arg_23_2.fade_in_speed, arg_23_2.fade_out_speed)
		else
			return _ingame_ui:handle_transition(arg_23_1, arg_23_2)
		end
	end
end

UIManager.ingame_ui = function (self)
	-- function 24
	return self._ingame_ui
end

UIManager._fetch_disabled_ui_layouts = function (self)
	-- function 25
	local _disabled_ui_layouts = self._disabled_ui_layouts

	if not _disabled_ui_layouts then
		local backend = Managers.backend

		fassert(backend:get_backend_mirror(), "Backend not created yet")

		local get_title_settings = backend:get_title_settings()

		_disabled_ui_layouts = not get_title_settings and get_title_settings.disabled_ui_layouts and {}
		self._disabled_ui_layouts = _disabled_ui_layouts
	end

	return _disabled_ui_layouts
end

local function fn(arg_26_0)
	-- function 26
	return arg_26_0 == "hide"
end

local function fn_2(arg_27_0)
	-- function 27
	return arg_27_0 == "disable" or arg_27_0 == true or fn(arg_27_0)
end

UIManager.is_ui_layout_disabled = function (self, arg_28_1)
	-- function 28
	local var_28_0 = self:_fetch_disabled_ui_layouts()[arg_28_1]

	return fn_2(var_28_0)
end

UIManager.is_ui_layout_hidden = function (self, arg_29_1)
	-- function 29
	local var_29_0 = self:_fetch_disabled_ui_layouts()[arg_29_1]

	return fn(var_29_0)
end
