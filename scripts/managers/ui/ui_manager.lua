-- chunkname: @scripts/managers/ui/ui_manager.lua

require("scripts/managers/ui/popup_settings")

UIManager = class(UIManager)

function UIManager.init(arg_1_0)
	arg_1_0._ui_enabled = true
end

function UIManager.destroy(arg_2_0)
	if arg_2_0._ingame_ui then
		print("[UIManager] Warning: destroy_ingame_ui was not called before destroy")
	end
end

function UIManager.create_ingame_ui(arg_3_0, arg_3_1, arg_3_2)
	arg_3_0._ingame_ui_context = arg_3_1
	arg_3_0._loading_subtitle_gui = arg_3_2

	if arg_3_0._ingame_ui then
		print("[UIManager] Warning: destroy_ingame_ui was not called before create_ingame_ui")
		arg_3_0._ingame_ui:destroy()
	end

	arg_3_0._ingame_ui = IngameUI:new(arg_3_1)
	arg_3_0._ui_enabled = true
end

function UIManager.create_ui_renderer(arg_4_0, arg_4_1, arg_4_2, arg_4_3, arg_4_4)
	return arg_4_0._ingame_ui:create_ui_renderer(arg_4_1, arg_4_2, arg_4_3, arg_4_4)
end

function UIManager.destroy_ingame_ui(arg_5_0)
	local var_5_0 = arg_5_0._ingame_ui

	if var_5_0 then
		var_5_0:destroy()

		arg_5_0._ingame_ui = nil
	end
end

function UIManager.reload_ingame_ui(arg_6_0, arg_6_1)
	local var_6_0 = arg_6_0._ingame_ui

	if not var_6_0 then
		print("[UIManager] Warning: reloading the UI when it wasn't loaded.")

		return
	end

	local var_6_1 = var_6_0.last_transition_name
	local var_6_2 = var_6_0.last_transition_params

	if arg_6_1 then
		for iter_6_0 in pairs(package.loaded) do
			if string.find(iter_6_0, "^scripts/ui") then
				package.loaded[iter_6_0] = nil

				require(iter_6_0)
			end
		end
	end

	arg_6_0:destroy_ingame_ui()
	arg_6_0:create_ingame_ui(arg_6_0._ingame_ui_context)

	if var_6_1 then
		arg_6_0._ingame_ui:handle_transition(var_6_1, var_6_2)
	end
end

function UIManager.temporary_get_ingame_ui_called_from_state_ingame_running(arg_7_0)
	return arg_7_0._ingame_ui
end

function UIManager.set_ingame_ui_enabled(arg_8_0, arg_8_1)
	if arg_8_0._ui_enabled ~= arg_8_1 then
		arg_8_0._ui_enabled = arg_8_1

		if not arg_8_1 then
			local var_8_0 = arg_8_0._ingame_ui

			if var_8_0 then
				var_8_0:suspend_active_view()
			end
		end
	end
end

function UIManager.update(arg_9_0)
	if not arg_9_0._ui_enabled then
		return
	end

	if not arg_9_0._ui_update_initialized then
		arg_9_0._ui_update_initialized = true

		return
	end

	local var_9_0 = arg_9_0._ingame_ui

	if not var_9_0 then
		return
	end

	local var_9_1, var_9_2 = Managers.time:time_and_delta("ui")
	local var_9_3 = (script_data.disable_ui or DebugScreen.active) and Managers.state.network:game_session_host() ~= nil
	local var_9_4 = arg_9_0._level_end_view_wrapper
	local var_9_5 = var_9_4 and var_9_4:level_end_view()

	var_9_0:update(var_9_2, var_9_1, var_9_3, var_9_5)

	local var_9_6 = arg_9_0._loading_subtitle_gui

	if var_9_6 then
		var_9_0:update_loading_subtitle_gui(var_9_6, var_9_2)

		if var_9_6:is_complete() then
			arg_9_0._loading_subtitle_gui = nil
		end
	end

	if var_9_0:end_screen_active() and var_9_0:end_screen_completed() then
		Managers.state.event:trigger("end_screen_ui_complete")
	end
end

function UIManager.end_screen_active(arg_10_0)
	return arg_10_0._ingame_ui:end_screen_active()
end

function UIManager.end_screen_completed(arg_11_0)
	return arg_11_0._ingame_ui:end_screen_completed()
end

function UIManager.activate_end_screen_ui(arg_12_0, arg_12_1, arg_12_2, arg_12_3)
	arg_12_0._ingame_ui:activate_end_screen_ui(arg_12_1, arg_12_2, arg_12_3)
end

function UIManager.post_update(arg_13_0, arg_13_1, arg_13_2, arg_13_3)
	local var_13_0 = arg_13_0._ingame_ui

	if var_13_0 then
		var_13_0:post_update(arg_13_1, arg_13_2, arg_13_3)
	end
end

function UIManager.post_render(arg_14_0)
	local var_14_0 = arg_14_0._ingame_ui

	if var_14_0 then
		var_14_0:post_render()
	end
end

function UIManager.get_transition(arg_15_0)
	local var_15_0 = arg_15_0._ingame_ui

	if var_15_0 then
		return var_15_0:get_transition()
	end
end

function UIManager.restart_game(arg_16_0)
	arg_16_0._ingame_ui.restart_game = true
end

function UIManager.is_in_view_state(arg_17_0, arg_17_1)
	local var_17_0 = arg_17_0._ingame_ui

	if var_17_0 then
		return var_17_0:is_in_view_state(arg_17_1)
	end
end

function UIManager.get_hud_component(arg_18_0, arg_18_1)
	return arg_18_0._ingame_ui:get_hud_component(arg_18_1)
end

function UIManager.open_popup(arg_19_0, arg_19_1, ...)
	return arg_19_0._ingame_ui:open_popup(arg_19_1, ...)
end

function UIManager.close_popup(arg_20_0, arg_20_1)
	return arg_20_0._ingame_ui:close_popup(arg_20_1)
end

function UIManager.get_active_popup(arg_21_0, arg_21_1)
	local var_21_0 = arg_21_0._ingame_ui

	if var_21_0 then
		return var_21_0:get_active_popup(arg_21_1)
	end
end

function UIManager.handle_new_ui_disclaimer(arg_22_0, arg_22_1, arg_22_2)
	if Managers.input:is_device_active("gamepad") or IS_CONSOLE then
		return
	end

	local var_22_0 = Application.user_setting("use_gamepad_menu_layout")
	local var_22_1 = Application.user_setting("use_pc_menu_layout")

	if var_22_0 == false and var_22_1 == false and (arg_22_1[arg_22_2] or arg_22_1[arg_22_2] == nil) then
		arg_22_0._ingame_ui.weave_onboarding:try_show_tutorial(WeaveUITutorials.new_ui_disclaimer)
		Application.set_user_setting("use_gamepad_menu_layout", nil)
		Application.save_user_settings()
	end
end

function UIManager.handle_transition(arg_23_0, arg_23_1, arg_23_2)
	fassert(arg_23_2, "params are a required argument")

	local var_23_0 = arg_23_0._ingame_ui

	if var_23_0 then
		if arg_23_2.use_fade then
			return var_23_0:transition_with_fade(arg_23_1, arg_23_2, arg_23_2.fade_in_speed, arg_23_2.fade_out_speed)
		else
			return var_23_0:handle_transition(arg_23_1, arg_23_2)
		end
	end
end

function UIManager.ingame_ui(arg_24_0)
	return arg_24_0._ingame_ui
end
