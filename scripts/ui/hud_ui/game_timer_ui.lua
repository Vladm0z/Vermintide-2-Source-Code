-- chunkname: @scripts/ui/hud_ui/game_timer_ui.lua

GameTimerUI = class(GameTimerUI)

GameTimerUI.init = function (self, arg_1_1, arg_1_2)
	-- function 1
	self._gui = arg_1_2.ui_renderer.gui
	self._visible = true
	self._enabled = Application.make_hash(Application.user_setting("enable_ingame_timer")) ~= "473df4ed7fa71691" or not Development.parameter("disable_ingame_timer")

	Managers.state.event:register(self, "start_game_time", "event_start_game_time")
end

GameTimerUI.destroy = function (arg_2_0)
	-- function 2
	Managers.state.event:unregister("start_game_time", arg_2_0)
end

GameTimerUI.event_start_game_time = function (self, arg_3_1)
	-- function 3
	self._start_time = arg_3_1
end

GameTimerUI.set_visible = function (self, arg_4_1)
	-- function 4
	self._visible = arg_4_1
end

GameTimerUI.update = function (self)
	-- function 5
	if not (not self._enabled and self._visible) then
		return
	end

	local _start_time = self._start_time

	if not _start_time then
		local _gui = self._gui
		local num = Managers.state.network:network_time() - _start_time
		local format = string.format("%.2d:%.2d:%06.3f", num / 3600, num / 60 % 60, num % 60)
		local resolution, var_5_5 = Gui.resolution()
		local min = math.min(resolution / 1920, var_5_5 / 1080, 1)
		local str = "materials/fonts/arial"
		local num_2 = 28 * min
		local slug_text_extents, var_5_10, var_5_11 = Gui.slug_text_extents(_gui, format, str, num_2)

		Gui.slug_text(_gui, format, str, num_2, Vector3(resolution - min * 14 * 13, var_5_5 - min * 14, 1000), Color(255, 255, 255), "shadow", Color(0, 0, 0))
	end
end
