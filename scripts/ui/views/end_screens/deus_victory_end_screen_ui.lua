-- chunkname: @scripts/ui/views/end_screens/deus_victory_end_screen_ui.lua

require("scripts/helpers/deus_power_up_utils")
require("scripts/ui/dlc_morris/views/end_screen/deus_journey_presentation_ui")
require("scripts/ui/views/end_screens/base_end_screen_ui")

local var_0_0 = local_require("scripts/ui/views/end_screens/deus_victory_end_screen_ui_definitions")
local tbl = {
	DONE = "DONE",
	WAITING_TO_START = "WAITING_TO_START",
	PRESENTING_JOURNEY = "PRESENTING_JOURNEY"
}

DeusVictoryEndScreenUI = class(DeusVictoryEndScreenUI, BaseEndScreenUI)

DeusVictoryEndScreenUI.init = function (self, arg_1_1, arg_1_2, arg_1_3)
	-- function 1
	DeusVictoryEndScreenUI.super.init(self, arg_1_1, arg_1_2, var_0_0)
	fassert(arg_1_3.journey_name, "No journey_name set in screen_context")

	self._journey_name = arg_1_3.journey_name

	fassert(arg_1_3.profile_index, "No profile_index set in screen_context")

	self._profile_index = arg_1_3.profile_index

	fassert(arg_1_3.previous_completed_difficulty_index, "No previous_completed_difficulty_index set in screen_context")

	self._previous_completed_difficulty_index = arg_1_3.previous_completed_difficulty_index
	self._journey_presentation_ui = DeusJourneyPresentationUI:new(arg_1_1)

	self:_play_sound("play_gui_splash_victory")

	self._state = tbl.WAITING_TO_START
end

DeusVictoryEndScreenUI._destroy = function (self)
	-- function 2
	if not self._journey_presentation_ui then
		self._journey_presentation_ui:destroy()

		self._journey_presentation_ui = nil
	end
end

DeusVictoryEndScreenUI._start = function (self)
	-- function 3
	local scenegraph_definition = var_0_0.scenegraph_definition
	local tbl_2 = {
		draw_flags = self._draw_flags,
		wwise_world = self._wwise_world
	}

	self._victory_anim_id = self._ui_animator:start_animation("victory", self._widgets_by_name, scenegraph_definition, tbl_2)

	if not self._journey_presentation_ui then
		self._journey_presentation_ui:start(self._journey_name, self._previous_completed_difficulty_index)

		self._state = tbl.PRESENTING_JOURNEY
	end
end

DeusVictoryEndScreenUI._update = function (self, arg_4_1)
	-- function 4
	if not self._completed then
		return
	end

	if not self._victory_anim_id and not self._ui_animator:is_animation_completed(self._victory_anim_id) then
		self._victory_anim_id = nil
	end

	if self._state == tbl.PRESENTING_JOURNEY then
		local _journey_presentation_ui = self._journey_presentation_ui

		if not _journey_presentation_ui and not _journey_presentation_ui.active then
			_journey_presentation_ui:update(arg_4_1)
		end

		if not (not _journey_presentation_ui and _journey_presentation_ui:presentation_completed()) then
			self._state = tbl.DONE
		end
	elseif not (self._state ~= tbl.DONE or self._victory_anim_id ~= nil) then
		self:_on_completed()
	end
end
