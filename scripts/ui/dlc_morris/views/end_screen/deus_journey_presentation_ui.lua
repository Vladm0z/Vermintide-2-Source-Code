-- chunkname: @scripts/ui/dlc_morris/views/end_screen/deus_journey_presentation_ui.lua

require("scripts/ui/act_presentation/act_presentation_ui")

local var_0_0 = local_require("scripts/ui/act_presentation/act_presentation_ui_definitions")

DeusJourneyPresentationUI = class(DeusJourneyPresentationUI, ActPresentationUI)

DeusJourneyPresentationUI.create_ui_elements = function (arg_1_0)
	arg_1_0._widgets, arg_1_0._widgets_by_name = UIUtils.create_widgets(var_0_0.deus_widgets)
	arg_1_0._ui_scenegraph = UISceneGraph.init_scenegraph(var_0_0.scenegraph_definition)
	arg_1_0._ui_animator = UIAnimator:new(arg_1_0._ui_scenegraph, var_0_0.deus_animations)
	arg_1_0._animations = {}
end

DeusJourneyPresentationUI.start = function (arg_2_0, arg_2_1, arg_2_2)
	arg_2_0._presentation_aborted = nil
	arg_2_0._journey_name = arg_2_1

	local var_2_0 = DeusJourneySettings[arg_2_1]
	local var_2_1 = arg_2_0._widgets_by_name

	arg_2_0:_set_presentation_info(var_2_0, arg_2_1)

	var_2_1.act_title.content.text = ""

	local var_2_2 = arg_2_0.statistics_db
	local var_2_3 = arg_2_0.stats_id
	local var_2_4 = LevelUnlockUtils.completed_journey_difficulty_index(var_2_2, var_2_3, arg_2_1) or 0
	local var_2_5 = arg_2_2 < var_2_4

	var_2_1.level.content.locked = var_2_5

	local var_2_6 = {
		wwise_world = arg_2_0.wwise_world,
		journey_name = arg_2_1,
		widget = arg_2_0._widgets_by_name.level,
		first_time = var_2_5,
		previous_difficulty_index = arg_2_2,
		difficulty_index = var_2_4,
		render_settings = arg_2_0.render_settings
	}

	arg_2_0.animation_params = var_2_6

	local var_2_7 = var_2_5 and "enter_first_time" or "enter"

	arg_2_0:start_presentation_animation(var_2_7, var_2_6)

	arg_2_0.active = true
end

DeusJourneyPresentationUI._set_presentation_info = function (arg_3_0, arg_3_1, arg_3_2)
	local var_3_0 = arg_3_1.display_name
	local var_3_1 = arg_3_1.level_image
	local var_3_2 = arg_3_0._widgets_by_name

	var_3_2.level.content.level_icon = var_3_1

	local var_3_3 = Managers.backend:get_interface("deus"):get_journey_cycle().journey_data[arg_3_2].dominant_god
	local var_3_4 = DeusThemeSettings[var_3_3]

	var_3_2.level.content.theme_icon = var_3_4.text_icon
	var_3_2.level_title.content.text = Localize(var_3_0)
	var_3_2.level.style.purple_glow.color[1] = 0
end
