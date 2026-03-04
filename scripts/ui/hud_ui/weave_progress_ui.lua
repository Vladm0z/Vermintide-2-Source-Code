-- chunkname: @scripts/ui/hud_ui/weave_progress_ui.lua

local var_0_0 = local_require("scripts/ui/hud_ui/weave_progress_ui_definitions")
local var_0_1 = var_0_0.widgets
local var_0_2 = var_0_0.scenegraph_definition

WeaveProgressUI = class(WeaveProgressUI)

function WeaveProgressUI.init(arg_1_0, arg_1_1, arg_1_2)
	arg_1_0._parent = arg_1_1
	arg_1_0._ui_renderer = arg_1_2.ui_renderer
	arg_1_0._ingame_ui_context = arg_1_2
	arg_1_0._render_settings = {}
	arg_1_0._progress = 0
	arg_1_0._animations = {}
	arg_1_0._animation_callbacks = {}

	arg_1_0:_create_ui_elements()
end

function WeaveProgressUI.destroy(arg_2_0)
	return
end

function WeaveProgressUI._create_ui_elements(arg_3_0)
	arg_3_0._ui_scenegraph = UISceneGraph.init_scenegraph(var_0_2)
	arg_3_0._render_settings = arg_3_0._render_settings or {}
	arg_3_0._bonus_objective_widgets = {}
	arg_3_0._bonus_objective_stack_widgets = {}
	arg_3_0._bonus_objective_lookup = {}
	arg_3_0._widgets = {}

	for iter_3_0, iter_3_1 in pairs(var_0_1) do
		arg_3_0._widgets[iter_3_0] = UIWidget.init(iter_3_1)
	end

	arg_3_0._bonus_header_widget = UIWidget.init(var_0_0.create_bonus_objective_header_func())

	UIRenderer.clear_scenegraph_queue(arg_3_0._ui_renderer)

	arg_3_0._progress = 0
end

function WeaveProgressUI._sync_weave_objectives(arg_4_0)
	local var_4_0 = Managers.weave:get_active_objective_template()

	if not var_4_0 then
		return
	end

	local var_4_1 = var_4_0.bar_cutoff

	if not var_4_1 or var_4_1 == 100 then
		local var_4_2 = math.max(Managers.weave:get_active_objective() - 1, 1)
		local var_4_3 = Managers.weave:get_active_weave_template().objectives

		for iter_4_0 = var_4_2, 1, -1 do
			var_4_1 = var_4_3[iter_4_0].bar_cutoff

			if var_4_1 and var_4_1 < 100 then
				break
			end
		end
	end

	var_4_1 = var_4_1 or 100

	local var_4_4 = arg_4_0._widgets.progress_ui
	local var_4_5 = var_4_4.content

	var_4_5.bar_cutoff = var_4_1

	local var_4_6 = UIAtlasHelper.get_atlas_settings_by_texture_name("weaves_essence_bar_fill")
	local var_4_7 = var_4_4.style.bubble_icon
	local var_4_8 = var_4_7.base_offset_x

	var_4_7.offset[1] = var_4_8 + var_4_6.size[1] * (var_4_1 * 0.01)

	local var_4_9 = ""
	local var_4_10 = var_4_0.bonus_time_on_complete

	if var_4_10 then
		local var_4_11 = math.max(var_4_10, 0)

		var_4_9 = string.format("+ %d:%02d", math.floor(var_4_11 / 60), var_4_11 % 60)
	end

	var_4_5.bonus_time = var_4_9
	arg_4_0._initiated = true
end

function WeaveProgressUI.update(arg_5_0, arg_5_1, arg_5_2)
	if not arg_5_0._initiated then
		arg_5_0:_sync_weave_objectives()
	end

	arg_5_0:_update_bonus_objectives(arg_5_1, arg_5_2)
	arg_5_0:_update_animations(arg_5_1, arg_5_2)
	arg_5_0:_update_bar(arg_5_1, arg_5_2)
	arg_5_0:_draw(arg_5_1, arg_5_2)
end

local function var_0_3(arg_6_0, arg_6_1)
	return arg_6_0.sort_index < arg_6_1.sort_index
end

local var_0_4 = {}
local var_0_5 = {}
local var_0_6 = {}

function WeaveProgressUI._update_bonus_objectives(arg_7_0, arg_7_1, arg_7_2)
	table.clear(var_0_4)
	table.clear(var_0_5)
	table.clear(var_0_6)

	local var_7_0 = arg_7_0._bonus_objective_lookup
	local var_7_1 = arg_7_0._bonus_objective_widgets
	local var_7_2 = arg_7_0._bonus_objective_stack_widgets
	local var_7_3 = Managers.weave:get_active_weave_template()

	if not var_7_3 then
		return
	end

	local var_7_4 = Managers.state and Managers.state.entity
	local var_7_5 = var_7_4 and var_7_4:system("objective_system")
	local var_7_6 = Managers.weave:get_active_objective()
	local var_7_7 = var_7_3.objectives_ordered[var_7_6]

	if var_7_5 then
		local var_7_8 = var_7_5:active_objectives()

		for iter_7_0, iter_7_1 in ipairs(var_7_8) do
			local var_7_9 = var_7_5:extension_by_objective_name(iter_7_1)

			var_0_4[iter_7_1] = true

			if not var_7_0[iter_7_1] and var_7_9:display_name() then
				local var_7_10 = table.find(var_7_7, iter_7_1)

				var_0_5[#var_0_5 + 1] = {
					sort_index = var_7_10,
					objective = var_7_9
				}
			end
		end

		table.sort(var_0_5, var_0_3)

		for iter_7_2, iter_7_3 in ipairs(var_0_5) do
			local var_7_11 = iter_7_3.objective:objective_name()
			local var_7_12 = iter_7_3.objective:display_name()
			local var_7_13 = iter_7_3.objective:is_stacking_objective()

			if var_7_13 then
				if not var_0_6[var_7_13] then
					local var_7_14 = var_0_0.create_bonus_objective_func(var_7_12, table.size(var_7_1) + table.size(var_7_2), var_7_13, var_7_11)
					local var_7_15 = var_7_2[var_7_13] or {}

					var_7_15[#var_7_15 + 1] = UIWidget.init(var_7_14)
					var_7_2[var_7_13] = var_7_15
					var_7_0[var_7_11] = var_7_15[#var_7_15]
					var_0_6[var_7_13] = true
				else
					local var_7_16 = var_7_2[var_7_13][#var_7_2[var_7_13]]

					var_7_16.content.stack[#var_7_16.content.stack + 1] = var_7_11
					var_7_0[var_7_11] = var_7_16
				end
			else
				local var_7_17 = var_0_0.create_bonus_objective_func(var_7_12, table.size(var_7_1) + table.size(var_7_2))

				var_7_1[var_7_11] = UIWidget.init(var_7_17)
				var_7_0[var_7_11] = var_7_1[var_7_11]
			end
		end

		for iter_7_4, iter_7_5 in pairs(var_7_0) do
			if not var_0_4[iter_7_4] and not iter_7_5.content:is_done_func(iter_7_4) and arg_7_0:_handle_stacks(iter_7_5, iter_7_4) then
				iter_7_5.content.is_done = true

				local var_7_18 = iter_7_5.content.objective_name_id
				local var_7_19 = iter_7_5.style.objective_name
				local var_7_20, var_7_21 = UIFontByResolution(var_7_19)
				local var_7_22 = UIRenderer.text_size(arg_7_0._ui_renderer, var_7_18, var_7_20[1], var_7_21)
				local var_7_23 = table.clone(iter_7_5.style.checkmark.texture_size)

				arg_7_0._animations["checkmark_x_" .. iter_7_4] = UIAnimation.init(UIAnimation.function_by_time, iter_7_5.style.checkmark.texture_size, 1, var_7_23[1] * 3, var_7_23[1], 0.4, math.easeOutCubic)
				arg_7_0._animations["checkmark_y_" .. iter_7_4] = UIAnimation.init(UIAnimation.function_by_time, iter_7_5.style.checkmark.texture_size, 2, var_7_23[2] * 3, var_7_23[2], 0.4, math.easeOutCubic)
				arg_7_0._animations["checkmark_shadow_x_" .. iter_7_4] = UIAnimation.init(UIAnimation.function_by_time, iter_7_5.style.checkmark_shadow.texture_size, 1, var_7_23[1] * 3, var_7_23[1], 0.4, math.easeOutCubic)
				arg_7_0._animations["checkmark_shadow_y_" .. iter_7_4] = UIAnimation.init(UIAnimation.function_by_time, iter_7_5.style.checkmark_shadow.texture_size, 2, var_7_23[2] * 3, var_7_23[2], 0.4, math.easeOutCubic)
				arg_7_0._animations["checkmark_color_r_" .. iter_7_4] = UIAnimation.init(UIAnimation.function_by_time, iter_7_5.style.checkmark.color, 2, 255, 192, 0.4, math.easeOutCubic)
				arg_7_0._animations["checkmark_color_g_" .. iter_7_4] = UIAnimation.init(UIAnimation.function_by_time, iter_7_5.style.checkmark.color, 3, 255, 192, 0.4, math.easeOutCubic)
				arg_7_0._animations["checkmark_color_b_" .. iter_7_4] = UIAnimation.init(UIAnimation.function_by_time, iter_7_5.style.checkmark.color, 4, 255, 192, 0.4, math.easeOutCubic)
				arg_7_0._animation_callbacks["checkmark_x_" .. iter_7_4] = function()
					arg_7_0._animations["stroke_" .. iter_7_4] = UIAnimation.init(UIAnimation.function_by_time, iter_7_5.style.stroke.texture_size, 1, 0, var_7_22, 0.25, math.easeInCubic)
					arg_7_0._animations["essence_icon_r_" .. iter_7_4] = UIAnimation.init(UIAnimation.function_by_time, iter_7_5.style.essence_icon.color, 2, 255, 60, 0.4, math.easeOutCubic)
					arg_7_0._animations["essence_icon_g_" .. iter_7_4] = UIAnimation.init(UIAnimation.function_by_time, iter_7_5.style.essence_icon.color, 3, 255, 60, 0.4, math.easeOutCubic)
					arg_7_0._animations["essence_icon_b_" .. iter_7_4] = UIAnimation.init(UIAnimation.function_by_time, iter_7_5.style.essence_icon.color, 4, 255, 60, 0.4, math.easeOutCubic)
					arg_7_0._animation_callbacks["stroke_" .. iter_7_4] = function()
						arg_7_0._animations["objective_color_r_" .. iter_7_4] = UIAnimation.init(UIAnimation.function_by_time, var_7_19.text_color, 2, 255, 192, 0.5, math.easeInCubic)
						arg_7_0._animations["objective_color_g_" .. iter_7_4] = UIAnimation.init(UIAnimation.function_by_time, var_7_19.text_color, 3, 255, 192, 0.5, math.easeInCubic)
						arg_7_0._animations["objective_color_b_" .. iter_7_4] = UIAnimation.init(UIAnimation.function_by_time, var_7_19.text_color, 4, 255, 192, 0.5, math.easeInCubic)
					end
				end
			end
		end
	end
end

function WeaveProgressUI._handle_stacks(arg_10_0, arg_10_1, arg_10_2)
	local var_10_0 = arg_10_1.content

	if not var_10_0.stack then
		return true
	end

	local var_10_1 = var_10_0.stack
	local var_10_2 = var_10_0.done_stack

	var_10_2[#var_10_2 + 1] = arg_10_2

	return table.size(var_10_2) == table.size(var_10_1)
end

function WeaveProgressUI._update_animations(arg_11_0, arg_11_1)
	local var_11_0 = arg_11_0._animations
	local var_11_1 = arg_11_0._animation_callbacks

	for iter_11_0, iter_11_1 in pairs(var_11_0) do
		UIAnimation.update(iter_11_1, arg_11_1)

		if UIAnimation.completed(iter_11_1) then
			var_11_0[iter_11_0] = nil

			local var_11_2 = var_11_1[iter_11_0]

			if var_11_2 then
				var_11_2()

				var_11_1[iter_11_0] = nil
			end
		end
	end
end

local var_0_7

var_0_7 = DEBUG and 0 or nil

function WeaveProgressUI._update_bar(arg_12_0, arg_12_1, arg_12_2)
	local var_12_0 = Managers.weave

	if var_12_0:get_active_weave() then
		local var_12_1 = var_12_0:current_bar_score()
		local var_12_2 = arg_12_0._old_progress

		arg_12_0._progress = var_12_1 / 100

		if not var_12_2 or var_12_2 < arg_12_0._progress then
			local var_12_3 = arg_12_0._widgets.progress_ui
			local var_12_4 = var_12_3.content
			local var_12_5 = var_12_3.style

			arg_12_0._animations.update_bar_glow = UIAnimation.init(UIAnimation.function_by_time, var_12_5.bar_glow.color, 1, 255, 0, 0.5, math.easeInCubic)

			function arg_12_0._animation_callbacks.update_bar_glow()
				arg_12_0._animations.update_bar = UIAnimation.init(UIAnimation.function_by_time, var_12_4, "bar_progress", var_12_4.bar_progress, arg_12_0._progress, 0.5, math.easeOutCubic)
			end

			arg_12_0._animations.update_effect = UIAnimation.init(UIAnimation.function_by_time, var_12_5.background_filled.color, 1, 255, 0, 2, math.easeOutCubic)
		end

		local var_12_6 = arg_12_0._widgets.progress_ui.content

		var_12_6.progress = arg_12_0._progress
		arg_12_0._old_progress = arg_12_0._progress

		if var_12_1 >= var_12_6.bar_cutoff then
			var_12_6.bonus_time = ""
		end
	end
end

function WeaveProgressUI._draw(arg_14_0, arg_14_1, arg_14_2)
	local var_14_0 = arg_14_0._ui_renderer
	local var_14_1 = arg_14_0._ui_scenegraph
	local var_14_2 = arg_14_0._render_settings
	local var_14_3 = Managers.input:get_service("ingame_menu")

	UIRenderer.begin_pass(var_14_0, var_14_1, var_14_3, arg_14_1, nil, var_14_2)

	for iter_14_0, iter_14_1 in pairs(arg_14_0._widgets) do
		UIRenderer.draw_widget(var_14_0, iter_14_1)
	end

	local var_14_4 = arg_14_0._bonus_objective_widgets

	if table.size(var_14_4) > 0 then
		UIRenderer.draw_widget(var_14_0, arg_14_0._bonus_header_widget)

		for iter_14_2, iter_14_3 in pairs(var_14_4) do
			UIRenderer.draw_widget(var_14_0, iter_14_3)
		end
	end

	local var_14_5 = arg_14_0._bonus_objective_stack_widgets

	if table.size(var_14_5) > 0 then
		for iter_14_4, iter_14_5 in pairs(var_14_5) do
			for iter_14_6, iter_14_7 in pairs(iter_14_5) do
				UIRenderer.draw_widget(var_14_0, iter_14_7)
			end
		end
	end

	if table.size(var_14_4) > 0 or table.size(var_14_5) > 0 then
		UIRenderer.draw_widget(var_14_0, arg_14_0._bonus_header_widget)
	end

	UIRenderer.end_pass(var_14_0)
end
