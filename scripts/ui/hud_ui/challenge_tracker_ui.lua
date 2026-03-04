-- chunkname: @scripts/ui/hud_ui/challenge_tracker_ui.lua

local var_0_0 = local_require("scripts/ui/hud_ui/challenge_tracker_ui_definitions")

ChallengeTrackerUI = class(ChallengeTrackerUI)

local var_0_1 = 500
local var_0_2 = var_0_0.RETAINED_MODE_ENABLED

function ChallengeTrackerUI.init(arg_1_0, arg_1_1, arg_1_2)
	arg_1_0._ui_renderer = arg_1_2.ui_renderer
	arg_1_0._wwise_world = arg_1_2.wwise_world

	arg_1_0:_create_ui_elements()
end

function ChallengeTrackerUI.destroy(arg_2_0)
	if var_0_2 then
		local var_2_0 = arg_2_0._data and arg_2_0._data.widgets

		if var_2_0 then
			UIUtils.destroy_widgets(arg_2_0._ui_renderer, var_2_0)
		end
	end
end

function ChallengeTrackerUI._play_sound(arg_3_0, arg_3_1)
	return WwiseWorld.trigger_event(arg_3_0._wwise_world, arg_3_1)
end

function ChallengeTrackerUI._create_ui_elements(arg_4_0)
	arg_4_0:destroy()

	arg_4_0._ui_scenegraph = UISceneGraph.init_scenegraph(var_0_0.scenegraph_definition)
	arg_4_0._render_settings = {
		alpha_multiplier = 1
	}
	arg_4_0._ui_animator = UIAnimator:new(arg_4_0._ui_scenegraph, var_0_0.animation_definitions)
	arg_4_0._data = {
		offset = {
			0,
			0,
			0
		},
		widgets = {},
		widget_by_challenge = {},
		challenges = {}
	}
	arg_4_0._animation_queue = MakeTableWeakKeys({})
	arg_4_0._restack_targets = {}

	UIRenderer.clear_scenegraph_queue(arg_4_0._ui_renderer)

	arg_4_0._dirty = true
end

local function var_0_3(arg_5_0, arg_5_1)
	return arg_5_0:get_category() < arg_5_1:get_category()
end

function ChallengeTrackerUI._refresh_challenge_data(arg_6_0, arg_6_1)
	table.clear(arg_6_1.challenges)

	local var_6_0, var_6_1 = Managers.venture.challenge:get_challenges_filtered(arg_6_1.challenges)

	table.sort(var_6_0, var_0_3)

	local var_6_2 = arg_6_1.widgets
	local var_6_3 = #var_6_2
	local var_6_4 = var_0_2 and arg_6_0._ui_renderer.gui_retained or arg_6_0._ui_renderer.gui

	for iter_6_0 = 1, var_6_1 do
		local var_6_5 = var_6_0[iter_6_0]
		local var_6_6 = var_6_5:get_status()

		if not arg_6_1.widget_by_challenge[var_6_5] and var_6_6 == InGameChallengeStatus.InProgress then
			var_6_3 = var_6_3 + 1

			local var_6_7 = var_0_0.create_objective(var_6_5, var_6_4, arg_6_1.offset, var_6_3)

			arg_6_1.widgets[var_6_3] = var_6_7
			arg_6_1.widget_by_challenge[var_6_5] = var_6_7

			arg_6_0:_play_animation_queued("on_enter", var_6_7)
		end
	end

	for iter_6_1 = 1, var_6_3 do
		local var_6_8 = var_6_2[iter_6_1]
		local var_6_9 = var_6_8.content
		local var_6_10 = var_6_9.challenge
		local var_6_11 = var_6_10:get_status()

		if var_6_11 == InGameChallengeStatus.InProgress then
			var_6_9.progress, var_6_9.max_progress = var_6_10:get_progress()

			if var_6_9.last_progress ~= var_6_9.progress then
				arg_6_0:_play_animation_queued("on_progress", var_6_8)

				var_6_9.last_progress = var_6_9.progress
			end
		elseif not var_6_9.is_done and not var_6_9.canceled then
			if var_6_11 == InGameChallengeStatus.Finished then
				if var_6_10:get_result() == InGameChallengeResult.Completed then
					var_6_9.is_done = true
					var_6_9.progress, var_6_9.max_progress = var_6_10:get_progress()

					arg_6_0:_play_animation_queued("on_progress", var_6_8)
					arg_6_0:_play_animation_queued("on_done", var_6_8)
				else
					var_6_9.canceled = true

					arg_6_0:_play_animation_queued("on_cancel", var_6_8)
				end
			elseif var_6_11 == InGameChallengeStatus.Paused then
				var_6_9.canceled = true

				arg_6_0:_play_animation_queued("on_cancel", var_6_8)
			end
		end
	end
end

function ChallengeTrackerUI._cb_on_done(arg_7_0, arg_7_1, arg_7_2)
	local var_7_0 = arg_7_0._data
	local var_7_1 = table.index_of(var_7_0.widgets, arg_7_1)
	local var_7_2 = #var_7_0.widgets

	var_7_0.widgets[var_7_1] = nil
	var_7_0.widget_by_challenge[arg_7_2] = nil
	arg_7_0._animation_queue[arg_7_1] = nil
	arg_7_0._restack_targets[arg_7_1] = nil

	if var_0_2 then
		UIWidget.destroy(arg_7_0._ui_renderer, arg_7_1)
	end

	local var_7_3 = var_7_0.offset
	local var_7_4 = arg_7_0._restack_targets

	for iter_7_0 = var_7_1 + 1, var_7_2 do
		var_7_4[var_7_0.widgets[iter_7_0]] = var_0_0.get_widget_position(var_7_3, iter_7_0 - 1)[2]
		var_7_0.widgets[iter_7_0 - 1] = var_7_0.widgets[iter_7_0]
		var_7_0.widgets[iter_7_0] = nil
	end
end

function ChallengeTrackerUI._play_animation(arg_8_0, arg_8_1, arg_8_2, arg_8_3)
	local var_8_0 = arg_8_0._ui_animator

	var_8_0:stop_animation(arg_8_2.content.animation_id or false)

	arg_8_2.content.animation_id = var_8_0:start_animation(arg_8_1, arg_8_2, var_0_0.scenegraph_definition, {
		view = arg_8_0,
		ui_renderer = arg_8_0._ui_renderer
	}, arg_8_3)
end

function ChallengeTrackerUI._play_animation_queued(arg_9_0, arg_9_1, arg_9_2, arg_9_3)
	local var_9_0 = arg_9_0._ui_animator
	local var_9_1 = arg_9_2.content.animation_id

	if var_9_0:is_animation_completed(var_9_1) then
		arg_9_0:_play_animation(arg_9_1, arg_9_2, arg_9_3)
	else
		local var_9_2 = arg_9_0._animation_queue[arg_9_2] or {}

		var_9_2[#var_9_2 + 1] = {
			name = arg_9_1,
			initial_delay = arg_9_3
		}
		arg_9_0._animation_queue[arg_9_2] = var_9_2
	end
end

function ChallengeTrackerUI._update_animation_queue(arg_10_0)
	local var_10_0 = arg_10_0._ui_animator

	for iter_10_0, iter_10_1 in pairs(arg_10_0._animation_queue) do
		local var_10_1 = iter_10_1[1]

		if var_10_1 then
			local var_10_2 = iter_10_0.content.animation_id

			if var_10_0:is_animation_completed(var_10_2) then
				arg_10_0:_play_animation(var_10_1.name, iter_10_0, var_10_1.initial_delay)
				table.remove(iter_10_1, 1)
			end
		else
			arg_10_0._animation_queue[iter_10_0] = nil
		end
	end
end

function ChallengeTrackerUI._update_restacking(arg_11_0, arg_11_1)
	local var_11_0 = arg_11_0._restack_targets
	local var_11_1 = var_0_1 * arg_11_1

	for iter_11_0, iter_11_1 in pairs(var_11_0) do
		local var_11_2 = iter_11_0.offset[2]
		local var_11_3 = iter_11_1 - var_11_2

		if var_11_1 >= math.abs(var_11_3) then
			iter_11_0.offset[2] = iter_11_1
			var_11_0[iter_11_0] = nil
		else
			local var_11_4 = math.min(math.abs(var_11_3), var_11_1)

			iter_11_0.offset[2] = var_11_2 + math.clamp(var_11_3, -var_11_4, var_11_4)
		end

		arg_11_0:_set_widget_dirty(iter_11_0)
	end
end

function ChallengeTrackerUI._set_widget_dirty(arg_12_0, arg_12_1)
	arg_12_1.element.dirty = true
	arg_12_0._dirty = true
end

function ChallengeTrackerUI._update_animations(arg_13_0, arg_13_1, arg_13_2)
	local var_13_0 = arg_13_0._ui_animator

	var_13_0:update(arg_13_1)

	local var_13_1 = arg_13_0._data.widgets
	local var_13_2 = #var_13_1

	for iter_13_0 = 1, var_13_2 do
		local var_13_3 = var_13_1[iter_13_0]
		local var_13_4 = var_13_3.content.animation_id

		if not var_13_0:is_animation_completed(var_13_4) then
			arg_13_0:_set_widget_dirty(var_13_3)
		end
	end
end

function ChallengeTrackerUI._handle_resolution_modified(arg_14_0)
	if RESOLUTION_LOOKUP.modified then
		UIUtils.mark_dirty(arg_14_0._data.widgets)

		arg_14_0._dirty = true
	end
end

local var_0_4 = {
	lock_y = false,
	registry_key = "questingknight",
	drag_scenegraph_id = "quest",
	root_scenegraph_id = "quest",
	label = "Duties",
	lock_x = false
}

function ChallengeTrackerUI.update(arg_15_0, arg_15_1, arg_15_2)
	HudCustomizer.run(arg_15_0._ui_renderer, arg_15_0._ui_scenegraph, var_0_4)
	arg_15_0:_handle_resolution_modified()
	arg_15_0:_update_restacking(arg_15_1)
	arg_15_0:_update_animation_queue()
	arg_15_0:_refresh_challenge_data(arg_15_0._data)
	arg_15_0:_update_animations(arg_15_1, arg_15_2)
	arg_15_0:_draw(arg_15_1)
end

function ChallengeTrackerUI._draw(arg_16_0, arg_16_1)
	if not arg_16_0._dirty and var_0_2 or not arg_16_0._is_visible then
		return
	end

	local var_16_0 = arg_16_0._ui_renderer
	local var_16_1 = arg_16_0._ui_scenegraph
	local var_16_2 = arg_16_0._render_settings
	local var_16_3
	local var_16_4 = UIRenderer

	var_16_4.begin_pass(var_16_0, var_16_1, var_16_3, arg_16_1, nil, var_16_2)

	for iter_16_0, iter_16_1 in pairs(arg_16_0._data.widgets) do
		var_16_2.alpha_multiplier = iter_16_1.content.alpha_multiplier or 1

		var_16_4.draw_widget(var_16_0, iter_16_1)
	end

	var_16_4.end_pass(var_16_0)

	arg_16_0._dirty = false
end

function ChallengeTrackerUI.set_visible(arg_17_0, arg_17_1)
	arg_17_0._is_visible = arg_17_1

	local var_17_0 = arg_17_0._ui_renderer

	for iter_17_0, iter_17_1 in pairs(arg_17_0._data.widgets) do
		UIRenderer.set_element_visible(var_17_0, iter_17_1.element, arg_17_1)
	end

	arg_17_0._dirty = true
end
