-- chunkname: @scripts/ui/views/cutscene_ui.lua

local var_0_0 = local_require("scripts/ui/views/cutscene_ui_definitions")
local var_0_1 = UISettings.cutscene_ui
local var_0_2 = math.easeCubic
local var_0_3 = pdArray

CutsceneUI = class(CutsceneUI)

function CutsceneUI.init(arg_1_0, arg_1_1, arg_1_2)
	arg_1_0._parent = arg_1_1
	arg_1_0.ui_renderer = arg_1_2.ui_renderer
	arg_1_0.ingame_ui = arg_1_2.ingame_ui
	arg_1_0.cutscene_system = Managers.state.entity:system("cutscene_system")

	local var_1_0 = arg_1_2.input_manager

	arg_1_0.input_manager = var_1_0

	var_1_0:create_input_service("cutscene", "CutsceneKeymaps", "CutsceneFilters")
	var_1_0:map_device_to_service("cutscene", "keyboard")
	var_1_0:map_device_to_service("cutscene", "mouse")
	var_1_0:map_device_to_service("cutscene", "gamepad")

	arg_1_0.ui_animations = {}
	arg_1_0.fx_fade_widgets = {}
	arg_1_0.fx_fade_widgets_pool = {}
	arg_1_0.fx_text_popup_widgets = {}
	arg_1_0.fx_text_popup_widgets_pool = {}
	arg_1_0.letterbox_enabled = false

	arg_1_0:_create_ui_elements()
end

function CutsceneUI._create_ui_elements(arg_2_0)
	arg_2_0.ui_scenegraph = UISceneGraph.init_scenegraph(var_0_0.scenegraph)
	arg_2_0.letterbox_widget = UIWidget.init(var_0_0.widgets.letterbox)
	arg_2_0.checkboxes = {
		checkbox_1 = UIWidget.init(var_0_0.widgets.checkbox_1),
		checkbox_2 = UIWidget.init(var_0_0.widgets.checkbox_2),
		checkbox_3 = UIWidget.init(var_0_0.widgets.checkbox_3),
		checkbox_4 = UIWidget.init(var_0_0.widgets.checkbox_4)
	}
end

function CutsceneUI.destroy(arg_3_0)
	arg_3_0.ui_renderer = nil
	arg_3_0.ingame_ui = nil
	arg_3_0.cutscene_system = nil
	arg_3_0.input_manager = nil
	arg_3_0.ui_scenegraph = nil
	arg_3_0.letterbox_widget = nil
	arg_3_0.fx_fade_widgets = nil
	arg_3_0.fx_fade_widgets_pool = nil
	arg_3_0.fx_text_popup_widgets = nil
	arg_3_0.fx_text_popup_widgets_pool = nil
end

function CutsceneUI.update(arg_4_0, arg_4_1)
	arg_4_0:check_for_fade()

	for iter_4_0, iter_4_1 in pairs(arg_4_0.ui_animations) do
		UIAnimation.update(iter_4_1, arg_4_1)

		if UIAnimation.completed(iter_4_1) then
			arg_4_0.ui_animations[iter_4_0] = nil
		end
	end

	local var_4_0 = arg_4_0.cutscene_system
	local var_4_1 = var_4_0.ui_event_queue

	if not var_0_3.empty(var_4_1) then
		arg_4_0:handle_event_queue(var_4_1)
		var_0_3.set_empty(var_4_1)
	end

	if var_4_0.active_camera and (arg_4_0.input_manager:get_service("cutscene"):get("skip_cutscene") or LEVEL_EDITOR_TEST) then
		var_4_0:skip_pressed()
	end

	if arg_4_0:do_draw() then
		arg_4_0:prepare_draw()
		arg_4_0:draw(arg_4_1)
	end
end

function CutsceneUI.do_draw(arg_5_0)
	return arg_5_0.letterbox_enabled or #arg_5_0.fx_fade_widgets > 0 or #arg_5_0.fx_text_popup_widgets > 0
end

function CutsceneUI.prepare_draw(arg_6_0)
	local var_6_0 = arg_6_0.fx_fade_widgets
	local var_6_1 = arg_6_0.fx_fade_widgets_pool

	for iter_6_0 = #var_6_0, 1, -1 do
		local var_6_2 = var_6_0[iter_6_0]

		if not next(var_6_0[iter_6_0].animations) then
			var_6_1[#var_6_1 + 1] = table.remove(var_6_0, iter_6_0)
		end
	end

	local var_6_3 = arg_6_0.fx_text_popup_widgets
	local var_6_4 = arg_6_0.fx_text_popup_widgets_pool

	for iter_6_1 = #var_6_3, 1, -1 do
		local var_6_5 = var_6_3[iter_6_1]

		if not next(var_6_3[iter_6_1].animations) then
			var_6_4[#var_6_4 + 1] = table.remove(var_6_3, iter_6_1)
		end
	end
end

function CutsceneUI.draw(arg_7_0, arg_7_1)
	local var_7_0 = arg_7_0.ui_renderer
	local var_7_1 = arg_7_0.ui_scenegraph
	local var_7_2 = arg_7_0.input_manager:get_service("cutscene")
	local var_7_3 = UISceneGraph.get_size_scaled(var_7_1, "screen")

	var_7_1.letterbox_top_bar.size[1] = var_7_3[1]
	var_7_1.letterbox_bottom_bar.size[1] = var_7_3[1]

	UIRenderer.begin_pass(var_7_0, var_7_1, var_7_2, arg_7_1)

	if arg_7_0.letterbox_enabled then
		UIRenderer.draw_widget(var_7_0, arg_7_0.letterbox_widget)

		if var_0_1.skippable then
			UIRenderer.draw_all_widgets(var_7_0, arg_7_0.checkboxes)
		end
	end

	local var_7_4 = arg_7_0.fx_fade_widgets

	for iter_7_0 = 1, #var_7_4 do
		local var_7_5 = var_7_4[iter_7_0]

		UIRenderer.draw_widget(var_7_0, var_7_5)
	end

	local var_7_6 = arg_7_0.fx_text_popup_widgets

	for iter_7_1 = 1, #var_7_6 do
		local var_7_7 = var_7_6[iter_7_1]

		UIRenderer.draw_widget(var_7_0, var_7_7)
	end

	UIRenderer.end_pass(var_7_0)
end

function CutsceneUI.handle_event_queue(arg_8_0, arg_8_1)
	local var_8_0, var_8_1 = var_0_3.data(arg_8_1)
	local var_8_2 = 1

	while var_8_2 <= var_8_1 do
		local var_8_3 = var_8_0[var_8_2]
		local var_8_4 = arg_8_0[var_8_3]

		fassert(var_8_4, "[CutsceneUI] Function not found for event %q", var_8_3)

		local var_8_5 = var_8_0[var_8_2 + 1]

		if type(var_8_5) == "table" then
			var_8_4(arg_8_0, unpack(var_8_5))
		else
			var_8_4(arg_8_0, var_8_5)
		end

		var_8_2 = var_8_2 + 2
	end
end

function CutsceneUI.set_letterbox_enabled(arg_9_0, arg_9_1)
	arg_9_0.letterbox_enabled = arg_9_1
end

function CutsceneUI.set_player_input_enabled(arg_10_0, arg_10_1)
	local var_10_0 = arg_10_0.input_manager

	if arg_10_1 then
		var_10_0:release_input({
			"keyboard",
			"gamepad",
			"mouse"
		}, 1, "cutscene", "CutsceneUI")
	else
		arg_10_0.ingame_ui:handle_transition("close_active")
		var_10_0:capture_input({
			"keyboard",
			"gamepad",
			"mouse"
		}, 1, "cutscene", "CutsceneUI")
	end
end

function CutsceneUI.input_service(arg_11_0)
	return arg_11_0.input_manager:get_service("cutscene")
end

function CutsceneUI.fx_fade(arg_12_0, arg_12_1, arg_12_2, arg_12_3, arg_12_4)
	local var_12_0 = var_0_1.fx_fade

	arg_12_1 = arg_12_1 or var_12_0.fade_in_time
	arg_12_2 = arg_12_2 or var_12_0.hold_time
	arg_12_3 = arg_12_3 or var_12_0.fade_out_time
	arg_12_4 = arg_12_4 or var_12_0.color

	local var_12_1 = table.remove(arg_12_0.fx_fade_widgets_pool) or UIWidget.init(var_0_0.widgets.fx_fade)
	local var_12_2 = var_12_1.content
	local var_12_3 = "fx_fade_alpha"
	local var_12_4 = 0
	local var_12_5 = 1
	local var_12_6 = arg_12_1 + arg_12_2 + arg_12_3

	arg_12_1 = arg_12_1 / var_12_6
	arg_12_3 = arg_12_3 / var_12_6
	arg_12_2 = 1 - arg_12_3

	local function var_12_7(arg_13_0)
		if arg_13_0 < arg_12_1 then
			return var_0_2(arg_13_0 / arg_12_1)
		elseif arg_13_0 < arg_12_2 then
			return 1
		elseif arg_12_3 > 0 then
			return var_0_2((1 - arg_13_0) / arg_12_3)
		else
			return 0
		end
	end

	UIWidget.animate(var_12_1, UIAnimation.init(UIAnimation.function_by_time, var_12_2, var_12_3, var_12_4, var_12_5, var_12_6, var_12_7))

	arg_12_0.fx_fade_widgets[#arg_12_0.fx_fade_widgets + 1] = var_12_1
end

function CutsceneUI.fx_text_popup(arg_14_0, arg_14_1, arg_14_2, arg_14_3, arg_14_4)
	local var_14_0 = var_0_1.fx_text_popup

	arg_14_1 = arg_14_1 or var_14_0.fade_in_time
	arg_14_2 = arg_14_2 or var_14_0.hold_time
	arg_14_3 = arg_14_3 or var_14_0.fade_out_time
	arg_14_4 = arg_14_4 or "no text set"

	local var_14_1 = table.remove(arg_14_0.fx_text_popup_widgets_pool) or UIWidget.init(var_0_0.widgets.fx_text_popup)
	local var_14_2 = var_14_1.content
	local var_14_3 = "fx_text_popup_alpha"
	local var_14_4 = 0
	local var_14_5 = 1
	local var_14_6 = arg_14_1 + arg_14_2 + arg_14_3

	arg_14_1 = arg_14_1 / var_14_6
	arg_14_3 = arg_14_3 / var_14_6
	arg_14_2 = 1 - arg_14_3

	local function var_14_7(arg_15_0)
		if arg_15_0 < arg_14_1 then
			return var_0_2(arg_15_0 / arg_14_1)
		elseif arg_15_0 < arg_14_2 then
			return 1
		elseif arg_14_3 > 0 then
			return var_0_2((1 - arg_15_0) / arg_14_3)
		else
			return 0
		end
	end

	UIWidget.animate(var_14_1, UIAnimation.init(UIAnimation.function_by_time, var_14_2, var_14_3, var_14_4, var_14_5, var_14_6, var_14_7))

	var_14_1.content.text = arg_14_4
	arg_14_0.fx_text_popup_widgets[#arg_14_0.fx_text_popup_widgets + 1] = var_14_1
end

function CutsceneUI.check_for_fade(arg_16_0)
	local var_16_0 = arg_16_0.cutscene_system

	if var_16_0 then
		if var_16_0.fade_in_game_logo then
			local var_16_1 = var_16_0.fade_in_game_logo_time

			var_16_0.fade_in_game_logo = nil
			var_16_0.fade_in_game_logo_time = nil

			arg_16_0:fade_in_logo(var_16_1)
		elseif var_16_0.fade_out_game_logo_time then
			local var_16_2 = var_16_0.fade_out_game_logo_time

			var_16_0.fade_out_game_logo = nil
			var_16_0.fade_out_game_logo_time = nil

			arg_16_0:fade_out_logo(var_16_2)
		end
	end
end
