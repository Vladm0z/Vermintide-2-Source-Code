-- chunkname: @scripts/game_state/title_screen_substates/win32/state_title_screen_load_save.lua

require("scripts/game_state/state_loading")

StateTitleScreenLoadSave = class(StateTitleScreenLoadSave)
StateTitleScreenLoadSave.NAME = "StateTitleScreenLoadSave"

StateTitleScreenLoadSave.on_enter = function (self, arg_1_1)
	-- function 1
	print("[Gamestate] Enter Substate StateTitleScreenLoadSave")

	self._params = arg_1_1
	self._world = self._params.world
	self._viewport = self._params.viewport
	self._title_start_ui = arg_1_1.ui

	self:_handle_tutorial_auto_start()
	self:_setup_init_network_view()

	local loading_context = self.parent.parent.loading_context
	local loading_view = loading_context.loading_view

	if not loading_view then
		loading_view:destroy()

		loading_context.loading_view = nil
	end
end

StateTitleScreenLoadSave._handle_tutorial_auto_start = function (self)
	-- function 2
	local loading_context = self.parent.parent.loading_context
	local force_run_tutorial = loading_context.force_run_tutorial

	loading_context.force_run_tutorial = nil

	if not (not IS_WINDOWS and not rawget(_G, "Steam") and Steam.app_id() ~= 1085780) then
		return
	end

	local get_user_data = Managers.backend:get_user_data("has_completed_tutorial")

	if not get_user_data then
		get_user_data = SaveData.has_completed_tutorial
		get_user_data = get_user_data or false
	end

	local should_run_tutorial, var_2_4 = Managers.mechanism:should_run_tutorial()

	if not (force_run_tutorial or get_user_data or script_data.disable_tutorial_at_start or should_run_tutorial) then
		return
	end

	Managers.level_transition_handler:set_next_level("prologue", 0)

	self.parent.parent.loading_context.switch_to_tutorial_backend = should_run_tutorial
	self.parent.parent.loading_context.wanted_tutorial_state = var_2_4
	self.parent.parent.loading_context.first_time = true

	Managers.backend:set_user_data("has_completed_tutorial", true)
	Managers.backend:commit()
end

StateTitleScreenLoadSave._setup_init_network_view = function (self)
	-- function 3
	if not (not Development.parameter("goto_endoflevel") and true) then
		local flag = false

		Managers.package:load("resource_packages/levels/dicegame", "StateTitleScreenLoadSave", nil, flag)

		self.parent.parent.loading_context.play_end_of_level_game = true
	end

	self.wanted_state = StateLoading
end

StateTitleScreenLoadSave.update = function (self, arg_4_1, arg_4_2)
	-- function 4
	if not self._title_start_ui then
		self._title_start_ui:update(arg_4_1, arg_4_2)
	end

	return self:_next_state()
end

StateTitleScreenLoadSave._next_state = function (self)
	-- function 5
	if not Managers.backend:profiles_loaded() and Managers.backend:is_waiting_for_user_input() or not self.wanted_state then
		Managers.transition:fade_in(GameSettings.transition_fade_out_speed, callback(self, "cb_fade_in_done", self.wanted_state))

		self.wanted_state = nil
	end
end

StateTitleScreenLoadSave.cb_fade_in_done = function (arg_6_0, arg_6_1)
	-- function 6
	arg_6_0.parent.state = arg_6_1
end

StateTitleScreenLoadSave.on_exit = function (arg_7_0, arg_7_1)
	-- function 7
	return
end
