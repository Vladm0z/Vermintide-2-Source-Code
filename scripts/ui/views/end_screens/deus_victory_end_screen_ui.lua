-- chunkname: @scripts/ui/views/end_screens/deus_victory_end_screen_ui.lua

require("scripts/helpers/deus_power_up_utils")
require("scripts/ui/dlc_morris/views/end_screen/deus_journey_presentation_ui")
require("scripts/ui/views/end_screens/base_end_screen_ui")

local var_0_0 = local_require("scripts/ui/views/end_screens/deus_victory_end_screen_ui_definitions")
local var_0_1 = {
	DONE = "DONE",
	WAITING_TO_START = "WAITING_TO_START",
	PRESENTING_JOURNEY = "PRESENTING_JOURNEY"
}

DeusVictoryEndScreenUI = class(DeusVictoryEndScreenUI, BaseEndScreenUI)

function DeusVictoryEndScreenUI.init(arg_1_0, arg_1_1, arg_1_2, arg_1_3)
	DeusVictoryEndScreenUI.super.init(arg_1_0, arg_1_1, arg_1_2, var_0_0)
	fassert(arg_1_3.journey_name, "No journey_name set in screen_context")

	arg_1_0._journey_name = arg_1_3.journey_name

	fassert(arg_1_3.profile_index, "No profile_index set in screen_context")

	arg_1_0._profile_index = arg_1_3.profile_index

	fassert(arg_1_3.previous_completed_difficulty_index, "No previous_completed_difficulty_index set in screen_context")

	arg_1_0._previous_completed_difficulty_index = arg_1_3.previous_completed_difficulty_index
	arg_1_0._journey_presentation_ui = DeusJourneyPresentationUI:new(arg_1_1)

	arg_1_0:_play_sound("play_gui_splash_victory")

	arg_1_0._state = var_0_1.WAITING_TO_START
end

function DeusVictoryEndScreenUI._destroy(arg_2_0)
	if arg_2_0._journey_presentation_ui then
		arg_2_0._journey_presentation_ui:destroy()

		arg_2_0._journey_presentation_ui = nil
	end
end

function DeusVictoryEndScreenUI._start(arg_3_0)
	local var_3_0 = var_0_0.scenegraph_definition
	local var_3_1 = {
		draw_flags = arg_3_0._draw_flags,
		wwise_world = arg_3_0._wwise_world
	}

	arg_3_0._victory_anim_id = arg_3_0._ui_animator:start_animation("victory", arg_3_0._widgets_by_name, var_3_0, var_3_1)

	if arg_3_0._journey_presentation_ui then
		arg_3_0._journey_presentation_ui:start(arg_3_0._journey_name, arg_3_0._previous_completed_difficulty_index)

		arg_3_0._state = var_0_1.PRESENTING_JOURNEY
	end
end

function DeusVictoryEndScreenUI._update(arg_4_0, arg_4_1)
	if arg_4_0._completed then
		return
	end

	if arg_4_0._victory_anim_id and arg_4_0._ui_animator:is_animation_completed(arg_4_0._victory_anim_id) then
		arg_4_0._victory_anim_id = nil
	end

	if arg_4_0._state == var_0_1.PRESENTING_JOURNEY then
		local var_4_0 = arg_4_0._journey_presentation_ui

		if var_4_0 and var_4_0.active then
			var_4_0:update(arg_4_1)
		end

		if not var_4_0 or var_4_0:presentation_completed() then
			arg_4_0._state = var_0_1.DONE
		end
	elseif arg_4_0._state == var_0_1.DONE and arg_4_0._victory_anim_id == nil then
		arg_4_0:_on_completed()
	end
end
