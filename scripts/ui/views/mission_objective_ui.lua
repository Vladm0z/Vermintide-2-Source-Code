-- chunkname: @scripts/ui/views/mission_objective_ui.lua

local var_0_0 = local_require("scripts/ui/views/mission_objective_ui_definitions")
local var_0_1 = var_0_0.animation_definitions
local var_0_2 = var_0_0.scenegraph_definition

MissionObjectiveUI = class(MissionObjectiveUI)

MissionObjectiveUI.init = function (arg_1_0, arg_1_1, arg_1_2)
	arg_1_0._parent = arg_1_1
	arg_1_0.ui_renderer = arg_1_2.ui_renderer
	arg_1_0.ingame_ui = arg_1_2.ingame_ui
	arg_1_0.input_manager = arg_1_2.input_manager

	local var_1_0 = arg_1_2.world_manager:world("level_world")

	arg_1_0.wwise_world = Managers.world:wwise_world(var_1_0)
	arg_1_0.saved_mission_objectives = {}
	arg_1_0.completed_mission_objectives = {}
	arg_1_0.current_mission_objective = nil
	arg_1_0.index_count = 0
	arg_1_0._animations = {}
	arg_1_0.render_settings = {
		snap_pixel_positions = true
	}

	arg_1_0:create_ui_elements()

	local var_1_1 = Managers.state.event

	if var_1_1 then
		var_1_1:register(arg_1_0, "ui_event_add_mission_objective", "add_mission_objective")
		var_1_1:register(arg_1_0, "ui_event_complete_mission", "complete_mission")
		var_1_1:register(arg_1_0, "ui_event_update_mission", "update_mission")
		var_1_1:register(arg_1_0, "ui_event_block_mission_ui", "block_mission_ui")

		local var_1_2 = Managers.state.entity:system("mission_system")

		if var_1_2 then
			var_1_2:trigger_active_mission_ui_events()
		end
	end
end

local var_0_3 = true

MissionObjectiveUI.create_ui_elements = function (arg_2_0)
	arg_2_0.ui_scenegraph = UISceneGraph.init_scenegraph(var_0_0.scenegraph_definition)
	arg_2_0._mission_widget = UIWidget.init(var_0_0.widget_definitions.mission_widget)
	arg_2_0.current_mission_objective = nil

	UIRenderer.clear_scenegraph_queue(arg_2_0.ui_renderer)

	arg_2_0.ui_animator = UIAnimator:new(arg_2_0.ui_scenegraph, var_0_1)
	var_0_3 = false
end

MissionObjectiveUI.destroy = function (arg_3_0)
	local var_3_0 = Managers.state.event

	if var_3_0 then
		var_3_0:unregister("ui_event_add_mission_objective", arg_3_0)
		var_3_0:unregister("ui_event_complete_mission", arg_3_0)
		var_3_0:unregister("ui_event_update_mission", arg_3_0)
		var_3_0:unregister("ui_event_block_mission_ui", arg_3_0)
	end

	arg_3_0.ui_animator = nil
end

MissionObjectiveUI.block_mission_ui = function (arg_4_0, arg_4_1)
	arg_4_0._ui_blocked = arg_4_1
end

local var_0_4 = {
	root_scenegraph_id = "pivot",
	label = "Objectives",
	registry_key = "mission_objective",
	drag_scenegraph_id = "background"
}

MissionObjectiveUI.update = function (arg_5_0, arg_5_1)
	if var_0_3 then
		arg_5_0:create_ui_elements()
	end

	HudCustomizer.run(arg_5_0.ui_renderer, arg_5_0.ui_scenegraph, var_0_4)

	if arg_5_0._ui_blocked then
		return
	end

	arg_5_0:update_animations(arg_5_1)
	arg_5_0:next_mission_objective(arg_5_1)

	if arg_5_0.current_mission_objective or arg_5_0._animations.mission_animation then
		arg_5_0:draw(arg_5_1)
	end
end

MissionObjectiveUI.add_mission_objective = function (arg_6_0, arg_6_1, arg_6_2, arg_6_3)
	local var_6_0 = arg_6_0.saved_mission_objectives

	for iter_6_0, iter_6_1 in pairs(var_6_0) do
		if iter_6_1.mission_name == arg_6_1 then
			return
		end
	end

	arg_6_0.saved_mission_objectives[#arg_6_0.saved_mission_objectives + 1] = {
		mission_name = arg_6_1,
		text = arg_6_2,
		duration_text = arg_6_3
	}
end

MissionObjectiveUI._clear_animations = function (arg_7_0)
	for iter_7_0, iter_7_1 in pairs(arg_7_0._animations) do
		arg_7_0.ui_animator:stop_animation(iter_7_1)
	end

	table.clear(arg_7_0._animations)
end

MissionObjectiveUI.complete_mission = function (arg_8_0, arg_8_1, arg_8_2)
	if arg_8_2 then
		arg_8_0:_clear_animations()
		arg_8_0:_remove_mission_objective(arg_8_1)
	else
		arg_8_0:_remove_mission_objective(arg_8_1)
		arg_8_0:_clear_animations()
		arg_8_0:_start_animation("mission_animation", "mission_end")
	end
end

MissionObjectiveUI._remove_mission_objective = function (arg_9_0, arg_9_1)
	local var_9_0

	for iter_9_0, iter_9_1 in ipairs(arg_9_0.saved_mission_objectives) do
		if iter_9_1.mission_name == arg_9_1 then
			var_9_0 = iter_9_0

			break
		end
	end

	if var_9_0 then
		local var_9_1 = arg_9_0.saved_mission_objectives[var_9_0]

		if var_9_1 then
			table.remove(arg_9_0.saved_mission_objectives, var_9_0)

			arg_9_0.completed_mission_objectives[var_9_1.mission_name] = var_9_1.text
			arg_9_0.current_mission_objective = nil
		end
	end
end

MissionObjectiveUI.update_mission = function (arg_10_0, arg_10_1, arg_10_2, arg_10_3)
	local var_10_0

	for iter_10_0, iter_10_1 in ipairs(arg_10_0.saved_mission_objectives) do
		if iter_10_1.mission_name == arg_10_1 then
			var_10_0 = iter_10_0

			break
		end
	end

	if var_10_0 then
		local var_10_1 = arg_10_0.saved_mission_objectives[var_10_0]

		arg_10_0.saved_mission_objectives[var_10_0].text = arg_10_2

		if var_10_1.mission_name == arg_10_0.current_mission_objective then
			local var_10_2 = arg_10_0._mission_widget

			arg_10_0:_set_mission_text(arg_10_2, arg_10_3)
		end
	end
end

MissionObjectiveUI.next_mission_objective = function (arg_11_0, arg_11_1)
	if not arg_11_0.current_mission_objective and #arg_11_0.saved_mission_objectives > 0 and not arg_11_0._animations.mission_animation then
		local var_11_0 = arg_11_0.saved_mission_objectives[1]

		arg_11_0.current_mission_objective = var_11_0.mission_name

		local var_11_1 = true

		arg_11_0:_set_mission_text(var_11_0.text, var_11_0.duration_text, var_11_1)
		arg_11_0:_start_animation("mission_animation", "mission_start")
	end
end

MissionObjectiveUI.update_animations = function (arg_12_0, arg_12_1)
	local var_12_0 = arg_12_0._animations
	local var_12_1 = arg_12_0.ui_animator

	var_12_1:update(arg_12_1)

	for iter_12_0, iter_12_1 in pairs(var_12_0) do
		if var_12_1:is_animation_completed(iter_12_1) then
			var_12_1:stop_animation(iter_12_1)

			var_12_0[iter_12_0] = nil
		end
	end
end

MissionObjectiveUI._set_mission_text = function (arg_13_0, arg_13_1, arg_13_2, arg_13_3)
	local var_13_0 = arg_13_0._mission_widget.content
	local var_13_1 = arg_13_0._mission_widget.style

	var_13_0.area_text_content = arg_13_1
	var_13_0.duration_text_content = arg_13_2 and arg_13_2 .. " " or nil

	local var_13_2 = arg_13_0.ui_renderer
	local var_13_3 = 287.5
	local var_13_4 = 40

	var_13_0.text_height = 45

	if arg_13_3 then
		local var_13_5 = arg_13_0.ui_scenegraph

		if arg_13_2 then
			local var_13_6, var_13_7 = UIFontByResolution(var_13_1.area_text_style)
			local var_13_8 = var_13_6[1]
			local var_13_9 = var_13_7
			local var_13_10 = string.upper(var_13_0.area_text_content)
			local var_13_11 = UIRenderer.text_size(var_13_2, var_13_10, var_13_8, var_13_9)
			local var_13_12 = arg_13_2
			local var_13_13 = UIRenderer.text_size(var_13_2, var_13_12, var_13_8, var_13_9)
			local var_13_14 = var_13_5.area_text_background.size[1]
			local var_13_15 = var_13_5.duration_text_background.size[1]

			var_13_5.area_text_background.position[1] = var_13_13 * 0.5
			var_13_5.duration_text_background.position[1] = -var_13_11 * 0.5
		else
			var_13_5.area_text_background.local_position[1] = 0
			var_13_5.duration_text_background.local_position[1] = 0
		end
	end
end

MissionObjectiveUI._get_text_size = function (arg_14_0, arg_14_1, arg_14_2, arg_14_3, arg_14_4, arg_14_5)
	arg_14_5.font_size = arg_14_5.default_font_size

	local var_14_0 = math.huge

	if arg_14_4 < var_14_0 then
		repeat
			local var_14_1, var_14_2 = UIFontByResolution(arg_14_5)
			local var_14_3 = var_14_1[1]
			local var_14_4 = var_14_1[2]
			local var_14_5 = var_14_1[3]
			local var_14_6, var_14_7, var_14_8 = UIGetFontHeight(arg_14_1.gui, var_14_5, var_14_4)
			local var_14_9 = #UIRenderer.word_wrap(arg_14_1, arg_14_2, var_14_3, var_14_4, arg_14_3)

			var_14_0 = (var_14_8 + math.abs(var_14_7)) * RESOLUTION_LOOKUP.inv_scale * var_14_9
			arg_14_5.font_size = math.max(arg_14_5.font_size - 1, arg_14_5.min_font_size)
			arg_14_5.new_font_size = arg_14_5.font_size

			if arg_14_5.font_size == arg_14_5.min_font_size then
				return var_14_0
			end
		until var_14_0 <= arg_14_4
	end

	return var_14_0
end

MissionObjectiveUI.draw = function (arg_15_0, arg_15_1)
	local var_15_0 = arg_15_0.ui_renderer
	local var_15_1 = arg_15_0.ui_scenegraph
	local var_15_2 = arg_15_0.input_manager:get_service("ingame_menu")
	local var_15_3 = arg_15_0.render_settings

	UIRenderer.begin_pass(var_15_0, var_15_1, var_15_2, arg_15_1, nil, var_15_3)
	UIRenderer.draw_widget(var_15_0, arg_15_0._mission_widget)
	UIRenderer.end_pass(var_15_0)
end

MissionObjectiveUI._start_animation = function (arg_16_0, arg_16_1, arg_16_2)
	local var_16_0 = {
		wwise_world = arg_16_0.wwise_world,
		render_settings = arg_16_0.render_settings,
		ui_renderer = arg_16_0.ui_renderer
	}
	local var_16_1 = arg_16_0.ui_animator:start_animation(arg_16_2, arg_16_0._mission_widget, var_0_2, var_16_0)

	arg_16_0._animations[arg_16_1] = var_16_1
end
