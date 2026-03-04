-- chunkname: @scripts/ui/views/end_screens/draw_end_screen_ui.lua

require("scripts/ui/views/end_screens/base_end_screen_ui")
require("scripts/ui/act_presentation/act_presentation_ui")

local var_0_0 = local_require("scripts/ui/views/end_screens/draw_end_screen_ui_definitions")

DrawEndScreenUI = class(DrawEndScreenUI, BaseEndScreenUI)

DrawEndScreenUI.init = function (arg_1_0, arg_1_1, arg_1_2, arg_1_3, arg_1_4)
	DrawEndScreenUI.super.init(arg_1_0, arg_1_1, arg_1_2, var_0_0, arg_1_4)
	fassert(arg_1_3.show_act_presentation ~= nil, "show_act_presentation not set.")

	if arg_1_3.show_act_presentation then
		fassert(arg_1_3.level_key, "No level_key set in screen_context")

		arg_1_0._level_key = arg_1_3.level_key

		fassert(arg_1_3.previous_completed_difficulty_index, "No previous_completed_difficulty_index set in screen_context")

		arg_1_0._previous_completed_difficulty_index = arg_1_3.previous_completed_difficulty_index
		arg_1_0._act_presentation_ui = ActPresentationUI:new(arg_1_1)
	end

	arg_1_0:_play_sound("play_gui_splash_draw")
end

DrawEndScreenUI._destroy = function (arg_2_0)
	if arg_2_0._act_presentation_ui then
		arg_2_0._act_presentation_ui:destroy()

		arg_2_0._act_presentation_ui = nil
	end
end

DrawEndScreenUI._start = function (arg_3_0)
	local var_3_0 = var_0_0.scenegraph_definition
	local var_3_1 = {
		draw_flags = arg_3_0._draw_flags,
		wwise_world = arg_3_0._wwise_world
	}

	arg_3_0._draw_anim_id = arg_3_0._ui_animator:start_animation("draw", arg_3_0._widgets_by_name, var_3_0, var_3_1)

	if arg_3_0._act_presentation_ui then
		arg_3_0._act_presentation_ui:start(arg_3_0._level_key, arg_3_0._previous_completed_difficulty_index)
	end
end

DrawEndScreenUI._update = function (arg_4_0, arg_4_1)
	if arg_4_0._completed then
		return
	end

	if arg_4_0._draw_anim_id and arg_4_0._ui_animator:is_animation_completed(arg_4_0._draw_anim_id) then
		arg_4_0._draw_anim_id = nil
	end

	local var_4_0 = arg_4_0._act_presentation_ui

	if var_4_0 and var_4_0.active then
		var_4_0:update(arg_4_1)
	end

	local var_4_1 = not var_4_0 or var_4_0:presentation_completed()

	if arg_4_0._draw_anim_id == nil and var_4_1 then
		if Managers.state.game_mode:setting("display_end_of_match_score_view") then
			local var_4_2, var_4_3, var_4_4 = Managers.state.game_mode:get_end_of_round_screen_settings()

			Managers.ui:activate_end_screen_ui(var_4_2, var_4_3, var_4_4)
		else
			arg_4_0:_on_completed()
		end
	end
end
