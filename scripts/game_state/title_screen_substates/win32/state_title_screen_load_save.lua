-- chunkname: @scripts/game_state/title_screen_substates/win32/state_title_screen_load_save.lua

require("scripts/game_state/state_loading")

StateTitleScreenLoadSave = class(StateTitleScreenLoadSave)
StateTitleScreenLoadSave.NAME = "StateTitleScreenLoadSave"

function StateTitleScreenLoadSave.on_enter(arg_1_0, arg_1_1)
	print("[Gamestate] Enter Substate StateTitleScreenLoadSave")

	arg_1_0._params = arg_1_1
	arg_1_0._world = arg_1_0._params.world
	arg_1_0._viewport = arg_1_0._params.viewport
	arg_1_0._title_start_ui = arg_1_1.ui

	arg_1_0:_handle_tutorial_auto_start()
	arg_1_0:_setup_init_network_view()

	local var_1_0 = arg_1_0.parent.parent.loading_context
	local var_1_1 = var_1_0.loading_view

	if var_1_1 then
		var_1_1:destroy()

		var_1_0.loading_view = nil
	end
end

function StateTitleScreenLoadSave._handle_tutorial_auto_start(arg_2_0)
	local var_2_0 = arg_2_0.parent.parent.loading_context
	local var_2_1 = var_2_0.force_run_tutorial

	var_2_0.force_run_tutorial = nil

	if IS_WINDOWS and rawget(_G, "Steam") and Steam.app_id() == 1085780 then
		return
	end

	local var_2_2 = Managers.backend:get_user_data("has_completed_tutorial") or SaveData.has_completed_tutorial or false
	local var_2_3, var_2_4 = Managers.mechanism:should_run_tutorial()

	if not var_2_1 and (var_2_2 or script_data.disable_tutorial_at_start or not var_2_3) then
		return
	end

	Managers.level_transition_handler:set_next_level("prologue", 0)

	arg_2_0.parent.parent.loading_context.switch_to_tutorial_backend = var_2_3
	arg_2_0.parent.parent.loading_context.wanted_tutorial_state = var_2_4
	arg_2_0.parent.parent.loading_context.first_time = true

	Managers.backend:set_user_data("has_completed_tutorial", true)
	Managers.backend:commit()
end

function StateTitleScreenLoadSave._setup_init_network_view(arg_3_0)
	if Development.parameter("goto_endoflevel") and false then
		local var_3_0 = false

		Managers.package:load("resource_packages/levels/dicegame", "StateTitleScreenLoadSave", nil, var_3_0)

		arg_3_0.parent.parent.loading_context.play_end_of_level_game = true
	end

	arg_3_0.wanted_state = StateLoading
end

function StateTitleScreenLoadSave.update(arg_4_0, arg_4_1, arg_4_2)
	if arg_4_0._title_start_ui then
		arg_4_0._title_start_ui:update(arg_4_1, arg_4_2)
	end

	return arg_4_0:_next_state()
end

function StateTitleScreenLoadSave._next_state(arg_5_0)
	if Managers.backend:profiles_loaded() and not Managers.backend:is_waiting_for_user_input() and arg_5_0.wanted_state then
		Managers.transition:fade_in(GameSettings.transition_fade_out_speed, callback(arg_5_0, "cb_fade_in_done", arg_5_0.wanted_state))

		arg_5_0.wanted_state = nil
	end
end

function StateTitleScreenLoadSave.cb_fade_in_done(arg_6_0, arg_6_1)
	arg_6_0.parent.state = arg_6_1
end

function StateTitleScreenLoadSave.on_exit(arg_7_0, arg_7_1)
	return
end
