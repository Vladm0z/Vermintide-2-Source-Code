-- chunkname: @scripts/ui/hud_ui/weave_timer_ui.lua

local var_0_0 = local_require("scripts/ui/hud_ui/weave_timer_ui_definitions")
local var_0_1 = var_0_0.widgets
local var_0_2 = var_0_0.scenegraph_definition

WeaveTimerUI = class(WeaveTimerUI)
PROGRESS_CUTOFF = 0.9
BIG_SOUND_REMAINGING_TIME = 10

local var_0_3 = false

function WeaveTimerUI.init(arg_1_0, arg_1_1, arg_1_2)
	arg_1_0._parent = arg_1_1
	arg_1_0._ui_renderer = arg_1_2.ui_renderer
	arg_1_0._ingame_ui_context = arg_1_2
	arg_1_0._wwise_world = arg_1_2.wwise_world
	arg_1_0._render_settings = {}
	arg_1_0._old_diff = 0
	arg_1_0._old_time = 0

	arg_1_0:_create_ui_elements()
end

function WeaveTimerUI.destroy(arg_2_0)
	return
end

function WeaveTimerUI._create_ui_elements(arg_3_0)
	arg_3_0._ui_scenegraph = UISceneGraph.init_scenegraph(var_0_2)
	arg_3_0._render_settings = arg_3_0._render_settings or {}
	arg_3_0._widgets = {}

	for iter_3_0, iter_3_1 in pairs(var_0_1) do
		local var_3_0 = UIWidget.init(iter_3_1)

		arg_3_0._widgets[iter_3_0] = var_3_0
	end

	UIRenderer.clear_scenegraph_queue(arg_3_0._ui_renderer)
end

function WeaveTimerUI.update(arg_4_0, arg_4_1, arg_4_2)
	arg_4_0:_update_timer(arg_4_1, arg_4_2)
	arg_4_0:_draw(arg_4_1, arg_4_2)
end

function WeaveTimerUI._play_sound(arg_5_0, arg_5_1)
	WwiseWorld.trigger_event(arg_5_0._wwise_world, arg_5_1)
end

function WeaveTimerUI._update_timer(arg_6_0, arg_6_1, arg_6_2)
	local var_6_0 = Managers.weave

	if var_6_0:get_active_weave() then
		local var_6_1 = var_6_0:get_time_left()
		local var_6_2 = math.max(var_6_1, 0)
		local var_6_3 = math.floor(var_6_2 / 60)
		local var_6_4 = math.floor(var_6_3 / 60)
		local var_6_5 = string.format("%d:%02d", var_6_3 - var_6_4 * 60, var_6_2 % 60)
		local var_6_6 = arg_6_0._widgets.timer.content
		local var_6_7 = var_6_6.progress
		local var_6_8 = 1 - var_6_1 / WeaveSettings.max_time
		local var_6_9 = Managers.time:time("game")

		if var_6_7 < PROGRESS_CUTOFF and var_6_8 >= PROGRESS_CUTOFF then
			arg_6_0:_play_sound("menu_wind_countdown_warning")
		elseif var_6_8 > PROGRESS_CUTOFF and var_6_8 < 1 then
			local var_6_10 = math.cos(arg_6_0._old_time * math.pi * 2)
			local var_6_11 = math.cos(var_6_9 * math.pi * 2) - var_6_10

			if arg_6_0._old_diff > 0 and var_6_11 <= 0 then
				if var_6_1 < BIG_SOUND_REMAINGING_TIME + 1 then
					arg_6_0:_play_sound("menu_wind_countdown_count_big")
				else
					arg_6_0:_play_sound("menu_wind_countdown_count_small")
				end
			end

			arg_6_0._old_diff = var_6_11
		end

		var_6_6.progress = var_6_8
		var_6_6.progress_cutoff = PROGRESS_CUTOFF
		var_6_6.timer_text_id = var_6_5
		arg_6_0._old_time = var_6_9
	end
end

function WeaveTimerUI._update_bar(arg_7_0, arg_7_1, arg_7_2)
	local var_7_0 = Managers.weave

	if var_7_0:get_active_weave() then
		local var_7_1 = var_7_0:get_time_left()
		local var_7_2 = math.max(var_7_1, 0)
		local var_7_3 = math.floor(var_7_2 / 60)
		local var_7_4 = math.floor(var_7_3 / 60)
		local var_7_5

		var_7_5.timer_text_id, var_7_5.progress, var_7_5 = string.format("%02d:%02d:%02d", var_7_4, var_7_3 - var_7_4 * 60, var_7_2 % 60), 1 - var_7_1 / WeaveSettings.max_time, arg_7_0._widgets.timer_bar.content
	end
end

function WeaveTimerUI._draw(arg_8_0, arg_8_1, arg_8_2)
	local var_8_0 = arg_8_0._ui_renderer
	local var_8_1 = arg_8_0._ui_scenegraph
	local var_8_2 = arg_8_0._render_settings
	local var_8_3 = Managers.input:get_service("ingame_menu")

	UIRenderer.begin_pass(var_8_0, var_8_1, var_8_3, arg_8_1, nil, var_8_2)

	for iter_8_0, iter_8_1 in pairs(arg_8_0._widgets) do
		UIRenderer.draw_widget(var_8_0, iter_8_1)
	end

	UIRenderer.end_pass(var_8_0)
end
