-- chunkname: @scripts/ui/views/end_screens/defeat_end_screen_ui.lua

require("scripts/ui/views/end_screens/base_end_screen_ui")

local var_0_0 = local_require("scripts/ui/views/end_screens/defeat_end_screen_ui_definitions")

DefeatEndScreenUI = class(DefeatEndScreenUI, BaseEndScreenUI)

DefeatEndScreenUI.init = function (arg_1_0, arg_1_1, arg_1_2, arg_1_3, arg_1_4)
	DefeatEndScreenUI.super.init(arg_1_0, arg_1_1, arg_1_2, var_0_0, arg_1_4)
	arg_1_0:_play_sound("play_gui_splash_defeat")
end

DefeatEndScreenUI._start = function (arg_2_0)
	local var_2_0 = var_0_0.scenegraph_definition
	local var_2_1 = {
		draw_flags = arg_2_0._draw_flags,
		wwise_world = arg_2_0._wwise_world
	}

	arg_2_0._defeat_anim_id = arg_2_0._ui_animator:start_animation("defeat", arg_2_0._widgets_by_name, var_2_0, var_2_1)
end

DefeatEndScreenUI._update = function (arg_3_0, arg_3_1)
	if arg_3_0._completed then
		return
	end

	if arg_3_0._defeat_anim_id and arg_3_0._ui_animator:is_animation_completed(arg_3_0._defeat_anim_id) then
		arg_3_0._defeat_anim_id = nil
	end

	if arg_3_0._defeat_anim_id == nil then
		if Managers.state.game_mode:setting("display_end_of_match_score_view") then
			local var_3_0, var_3_1, var_3_2 = Managers.state.game_mode:get_end_of_round_screen_settings()

			Managers.ui:activate_end_screen_ui(var_3_0, var_3_1, var_3_2)
		else
			arg_3_0:_on_completed()
		end
	end
end
