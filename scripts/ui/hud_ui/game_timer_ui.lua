-- chunkname: @scripts/ui/hud_ui/game_timer_ui.lua

GameTimerUI = class(GameTimerUI)

GameTimerUI.init = function (arg_1_0, arg_1_1, arg_1_2)
	arg_1_0._gui = arg_1_2.ui_renderer.gui
	arg_1_0._visible = true
	arg_1_0._enabled = Application.make_hash(Application.user_setting("enable_ingame_timer")) == "473df4ed7fa71691" and not Development.parameter("disable_ingame_timer")

	Managers.state.event:register(arg_1_0, "start_game_time", "event_start_game_time")
end

GameTimerUI.destroy = function (arg_2_0)
	Managers.state.event:unregister("start_game_time", arg_2_0)
end

GameTimerUI.event_start_game_time = function (arg_3_0, arg_3_1)
	arg_3_0._start_time = arg_3_1
end

GameTimerUI.set_visible = function (arg_4_0, arg_4_1)
	arg_4_0._visible = arg_4_1
end

GameTimerUI.update = function (arg_5_0)
	if not arg_5_0._enabled or not arg_5_0._visible then
		return
	end

	local var_5_0 = arg_5_0._start_time

	if var_5_0 then
		local var_5_1 = arg_5_0._gui
		local var_5_2 = Managers.state.network:network_time() - var_5_0
		local var_5_3 = string.format("%.2d:%.2d:%06.3f", var_5_2 / 3600, var_5_2 / 60 % 60, var_5_2 % 60)
		local var_5_4, var_5_5 = Gui.resolution()
		local var_5_6 = math.min(var_5_4 / 1920, var_5_5 / 1080, 1)
		local var_5_7 = "materials/fonts/arial"
		local var_5_8 = 28 * var_5_6
		local var_5_9, var_5_10, var_5_11 = Gui.slug_text_extents(var_5_1, var_5_3, var_5_7, var_5_8)

		Gui.slug_text(var_5_1, var_5_3, var_5_7, var_5_8, Vector3(var_5_4 - var_5_6 * 14 * 13, var_5_5 - var_5_6 * 14, 1000), Color(255, 255, 255), "shadow", Color(0, 0, 0))
	end
end
