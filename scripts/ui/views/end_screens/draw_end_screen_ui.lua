-- chunkname: @scripts/ui/views/end_screens/draw_end_screen_ui.lua

require("scripts/ui/views/end_screens/base_end_screen_ui")
require("scripts/ui/act_presentation/act_presentation_ui")

local var_0_0 = local_require("scripts/ui/views/end_screens/draw_end_screen_ui_definitions")

DrawEndScreenUI = class(DrawEndScreenUI, BaseEndScreenUI)

DrawEndScreenUI.init = function (self, arg_1_1, arg_1_2, arg_1_3, arg_1_4)
	-- function 1
	DrawEndScreenUI.super.init(self, arg_1_1, arg_1_2, var_0_0, arg_1_4)
	fassert(arg_1_3.show_act_presentation ~= nil, "show_act_presentation not set.")

	if not arg_1_3.show_act_presentation then
		fassert(arg_1_3.level_key, "No level_key set in screen_context")

		self._level_key = arg_1_3.level_key

		fassert(arg_1_3.previous_completed_difficulty_index, "No previous_completed_difficulty_index set in screen_context")

		self._previous_completed_difficulty_index = arg_1_3.previous_completed_difficulty_index
		self._act_presentation_ui = ActPresentationUI:new(arg_1_1)
	end

	self:_play_sound("play_gui_splash_draw")
end

DrawEndScreenUI._destroy = function (self)
	-- function 2
	if not self._act_presentation_ui then
		self._act_presentation_ui:destroy()

		self._act_presentation_ui = nil
	end
end

DrawEndScreenUI._start = function (self)
	-- function 3
	local scenegraph_definition = var_0_0.scenegraph_definition
	local tbl = {
		draw_flags = self._draw_flags,
		wwise_world = self._wwise_world
	}

	self._draw_anim_id = self._ui_animator:start_animation("draw", self._widgets_by_name, scenegraph_definition, tbl)

	if not self._act_presentation_ui then
		self._act_presentation_ui:start(self._level_key, self._previous_completed_difficulty_index)
	end
end

DrawEndScreenUI._update = function (self, arg_4_1)
	-- function 4
	if not self._completed then
		return
	end

	if not self._draw_anim_id and not self._ui_animator:is_animation_completed(self._draw_anim_id) then
		self._draw_anim_id = nil
	end

	local _act_presentation_ui = self._act_presentation_ui

	if not _act_presentation_ui and not _act_presentation_ui.active then
		_act_presentation_ui:update(arg_4_1)
	end

	local flag = not _act_presentation_ui and _act_presentation_ui:presentation_completed()

	if self._draw_anim_id ~= nil or not flag then
		if not Managers.state.game_mode:setting("display_end_of_match_score_view") then
			local get_end_of_round_screen_settings, var_4_3, var_4_4 = Managers.state.game_mode:get_end_of_round_screen_settings()

			Managers.ui:activate_end_screen_ui(get_end_of_round_screen_settings, var_4_3, var_4_4)
		else
			self:_on_completed()
		end
	end
end
