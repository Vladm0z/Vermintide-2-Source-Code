-- chunkname: @scripts/ui/dlc_morris/views/end_screen/deus_journey_presentation_ui.lua

require("scripts/ui/act_presentation/act_presentation_ui")

local var_0_0 = local_require("scripts/ui/act_presentation/act_presentation_ui_definitions")

DeusJourneyPresentationUI = class(DeusJourneyPresentationUI, ActPresentationUI)

DeusJourneyPresentationUI.create_ui_elements = function (self)
	-- function 1
	self._widgets, self._widgets_by_name = UIUtils.create_widgets(var_0_0.deus_widgets)
	self._ui_scenegraph = UISceneGraph.init_scenegraph(var_0_0.scenegraph_definition)
	self._ui_animator = UIAnimator:new(self._ui_scenegraph, var_0_0.deus_animations)
	self._animations = {}
end

DeusJourneyPresentationUI.start = function (self, arg_2_1, arg_2_2)
	-- function 2
	self._presentation_aborted = nil
	self._journey_name = arg_2_1

	local var_2_0 = DeusJourneySettings[arg_2_1]
	local _widgets_by_name = self._widgets_by_name

	self:_set_presentation_info(var_2_0, arg_2_1)

	_widgets_by_name.act_title.content.text = ""

	local statistics_db = self.statistics_db
	local stats_id = self.stats_id
	local completed_journey_difficulty_index = LevelUnlockUtils.completed_journey_difficulty_index(statistics_db, stats_id, arg_2_1)

	completed_journey_difficulty_index = completed_journey_difficulty_index or 0

	local flag = arg_2_2 < completed_journey_difficulty_index

	_widgets_by_name.level.content.locked = flag

	local tbl = {
		wwise_world = self.wwise_world,
		journey_name = arg_2_1,
		widget = self._widgets_by_name.level,
		first_time = flag,
		previous_difficulty_index = arg_2_2,
		difficulty_index = completed_journey_difficulty_index,
		render_settings = self.render_settings
	}

	self.animation_params = tbl

	local flag_2

	flag_2 = not flag and "enter_first_time" and "enter"

	self:start_presentation_animation(flag_2, tbl)

	self.active = true
end

DeusJourneyPresentationUI._set_presentation_info = function (self, arg_3_1, arg_3_2)
	-- function 3
	local display_name = arg_3_1.display_name
	local level_image = arg_3_1.level_image
	local _widgets_by_name = self._widgets_by_name

	_widgets_by_name.level.content.level_icon = level_image

	local dominant_god = Managers.backend:get_interface("deus"):get_journey_cycle().journey_data[arg_3_2].dominant_god
	local var_3_4 = DeusThemeSettings[dominant_god]

	_widgets_by_name.level.content.theme_icon = var_3_4.text_icon
	_widgets_by_name.level_title.content.text = Localize(display_name)
	_widgets_by_name.level.style.purple_glow.color[1] = 0
end
