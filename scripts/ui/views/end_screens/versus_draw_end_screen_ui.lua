-- chunkname: @scripts/ui/views/end_screens/versus_draw_end_screen_ui.lua

require("scripts/ui/views/end_screens/base_end_screen_ui")

local var_0_0 = local_require("scripts/ui/views/end_screens/versus_draw_end_screen_ui_definitions")

VersusDrawEndScreenUI = class(VersusDrawEndScreenUI, BaseEndScreenUI)

VersusDrawEndScreenUI.init = function (arg_1_0, arg_1_1, arg_1_2, arg_1_3)
	-- function 1
	VersusDrawEndScreenUI.super.init(arg_1_0, arg_1_1, arg_1_2, var_0_0)
end

VersusDrawEndScreenUI._start = function (self)
	-- function 2
	local scenegraph_definition = var_0_0.scenegraph_definition
	local tbl = {
		draw_flags = self._draw_flags,
		wwise_world = self._wwise_world
	}

	self._draw_anim_id = self._ui_animator:start_animation("draw", self._widgets_by_name, scenegraph_definition, tbl)
end

VersusDrawEndScreenUI._update = function (self, arg_3_1)
	-- function 3
	if not self._completed then
		return
	end

	if not self._draw_anim_id and not self._ui_animator:is_animation_completed(self._draw_anim_id) then
		self._draw_anim_id = nil
	end

	if self._draw_anim_id == nil then
		if not Managers.state.game_mode:setting("display_end_of_match_score_view") then
			local get_end_of_round_screen_settings, var_3_1, var_3_2 = Managers.state.game_mode:get_end_of_round_screen_settings()

			Managers.ui:activate_end_screen_ui(get_end_of_round_screen_settings, var_3_1, var_3_2)
		else
			self:_on_completed()
		end
	end
end
