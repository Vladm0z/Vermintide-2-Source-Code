-- chunkname: @scripts/ui/act_presentation/act_presentation_ui.lua

local var_0_0 = local_require("scripts/ui/act_presentation/act_presentation_ui_definitions")
local var_0_1 = var_0_0.scenegraph_definition
local var_0_2 = var_0_0.widgets
local var_0_3 = var_0_0.animations

ActPresentationUI = class(ActPresentationUI)

local var_0_4 = false

ActPresentationUI.init = function (arg_1_0, arg_1_1)
	arg_1_0.ui_renderer = arg_1_1.ui_renderer
	arg_1_0.ui_top_renderer = arg_1_1.ui_top_renderer
	arg_1_0.ingame_ui = arg_1_1.ingame_ui
	arg_1_0.statistics_db = arg_1_1.statistics_db
	arg_1_0.stats_id = arg_1_1.stats_id
	arg_1_0.input_manager = arg_1_1.input_manager
	arg_1_0.render_settings = {
		alpha_multiplier = 1,
		snap_pixel_positions = true
	}
	arg_1_0.platform = PLATFORM
	arg_1_0.world = arg_1_1.world_manager:world("level_world")
	arg_1_0.wwise_world = Managers.world:wwise_world(arg_1_0.world)

	arg_1_0:create_ui_elements()

	local var_1_0 = arg_1_0.input_manager

	var_1_0:create_input_service("act_presentation", "IngameMenuKeymaps", "IngameMenuFilters")
	var_1_0:map_device_to_service("act_presentation", "keyboard")
	var_1_0:map_device_to_service("act_presentation", "mouse")
	var_1_0:map_device_to_service("act_presentation", "gamepad")
end

ActPresentationUI.create_ui_elements = function (arg_2_0)
	local var_2_0 = {}
	local var_2_1 = {}

	for iter_2_0, iter_2_1 in pairs(var_0_2) do
		if iter_2_1 then
			local var_2_2 = UIWidget.init(iter_2_1)

			var_2_0[#var_2_0 + 1] = var_2_2
			var_2_1[iter_2_0] = var_2_2
		end
	end

	arg_2_0._widgets = var_2_0
	arg_2_0._widgets_by_name = var_2_1
	arg_2_0._ui_scenegraph = UISceneGraph.init_scenegraph(var_0_1)
	arg_2_0._ui_animator = UIAnimator:new(arg_2_0._ui_scenegraph, var_0_3)
	arg_2_0._animations = {}
	var_0_4 = false
end

ActPresentationUI.start = function (arg_3_0, arg_3_1, arg_3_2)
	local var_3_0 = LevelUnlockUtils.get_act_key_by_level(arg_3_1)

	if not var_3_0 then
		arg_3_0.active = true
		arg_3_0._presentation_aborted = true

		return false
	end

	arg_3_0._presentation_aborted = nil

	arg_3_0:_set_presentation_info(var_3_0, arg_3_1)

	local var_3_1, var_3_2 = arg_3_0:_setup_level(var_3_0, arg_3_1, arg_3_2)
	local var_3_3 = {
		wwise_world = arg_3_0.wwise_world,
		level_key = arg_3_1,
		widget = arg_3_0._widgets_by_name.level,
		first_time = var_3_1,
		previous_difficulty_index = arg_3_2,
		difficulty_index = var_3_2,
		render_settings = arg_3_0.render_settings
	}

	arg_3_0.animation_params = var_3_3

	local var_3_4 = var_3_1 and "enter_first_time" or "enter"

	arg_3_0:start_presentation_animation(var_3_4, var_3_3)

	arg_3_0.active = true
end

ActPresentationUI._set_presentation_info = function (arg_4_0, arg_4_1, arg_4_2)
	local var_4_0 = LevelSettings[arg_4_2]
	local var_4_1 = var_4_0.display_name
	local var_4_2 = var_4_0.level_image
	local var_4_3 = Managers.state.difficulty:get_difficulty_settings().display_name
	local var_4_4 = ActSettings[arg_4_1].display_name
	local var_4_5 = arg_4_0._widgets_by_name

	var_4_5.level.content.icon = var_4_2
	var_4_5.act_title.content.text = var_4_4 and Localize(var_4_4) or ""
	var_4_5.level_title.content.text = Localize(var_4_1)
end

ActPresentationUI._setup_level = function (arg_5_0, arg_5_1, arg_5_2, arg_5_3)
	local var_5_0 = arg_5_0._widgets_by_name
	local var_5_1 = arg_5_0.statistics_db
	local var_5_2 = arg_5_0.stats_id
	local var_5_3 = (var_5_1:get_persistent_stat(var_5_2, "completed_levels", arg_5_2) or 0) ~= 0
	local var_5_4 = var_5_3 and LevelUnlockUtils.completed_level_difficulty_index(var_5_1, var_5_2, arg_5_2) or 0
	local var_5_5 = arg_5_3 < var_5_4
	local var_5_6 = var_5_0.level
	local var_5_7 = var_5_6.content
	local var_5_8 = var_5_6.style

	var_5_7.locked = var_5_5 or not var_5_3

	return var_5_5, var_5_4
end

ActPresentationUI.destroy = function (arg_6_0)
	arg_6_0._ui_animator = nil
end

ActPresentationUI._update_animations = function (arg_7_0, arg_7_1)
	local var_7_0 = arg_7_0._animations
	local var_7_1 = arg_7_0._ui_animator

	var_7_1:update(arg_7_1)

	for iter_7_0, iter_7_1 in pairs(var_7_0) do
		if var_7_1:is_animation_completed(iter_7_1) then
			var_7_1:stop_animation(iter_7_1)

			var_7_0[iter_7_0] = nil

			local var_7_2 = arg_7_0.animation_params

			if var_7_2 then
				var_7_2.presentation_completed = true
				arg_7_0.active = false
			end
		end
	end
end

ActPresentationUI.presentation_completed = function (arg_8_0)
	local var_8_0 = arg_8_0.animation_params

	return var_8_0 and var_8_0.presentation_completed or arg_8_0._presentation_aborted
end

ActPresentationUI.update = function (arg_9_0, arg_9_1, arg_9_2)
	if var_0_4 then
		arg_9_0:create_ui_elements()
	end

	arg_9_0:_update_animations(arg_9_1)
	arg_9_0:draw(arg_9_1)
end

ActPresentationUI.draw = function (arg_10_0, arg_10_1)
	local var_10_0 = arg_10_0.ui_top_renderer
	local var_10_1 = arg_10_0.render_settings
	local var_10_2 = arg_10_0._ui_scenegraph
	local var_10_3 = arg_10_0.input_manager:get_service("act_presentation")
	local var_10_4 = var_10_1.alpha_multiplier

	UIRenderer.begin_pass(var_10_0, var_10_2, var_10_3, arg_10_1, nil, var_10_1)

	local var_10_5 = var_10_1.snap_pixel_positions

	for iter_10_0, iter_10_1 in ipairs(arg_10_0._widgets) do
		if iter_10_1.snap_pixel_positions ~= nil then
			var_10_1.snap_pixel_positions = iter_10_1.snap_pixel_positions
		end

		UIRenderer.draw_widget(var_10_0, iter_10_1)

		var_10_1.snap_pixel_positions = var_10_5
	end

	UIRenderer.end_pass(var_10_0)
end

ActPresentationUI.start_presentation_animation = function (arg_11_0, arg_11_1, arg_11_2)
	local var_11_0 = arg_11_2 or {
		wwise_world = arg_11_0.wwise_world
	}
	local var_11_1 = arg_11_0._ui_animator:start_animation(arg_11_1, arg_11_0._widgets_by_name, var_0_1, var_11_0)
	local var_11_2 = arg_11_1

	arg_11_0._animations[var_11_2] = var_11_1

	return var_11_2
end
