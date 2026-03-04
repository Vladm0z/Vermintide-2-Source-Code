-- chunkname: @scripts/ui/views/cutscene_overlay_ui.lua

local var_0_0 = local_require("scripts/ui/views/cutscene_overlay_ui_definitions")

CutsceneOverlayUI = class(CutsceneOverlayUI)

CutsceneOverlayUI.init = function (arg_1_0, arg_1_1, arg_1_2)
	arg_1_0._parent = arg_1_1
	arg_1_0._ui_renderer = arg_1_2.ui_renderer

	local var_1_0 = Managers.world

	if var_1_0 and var_1_0:has_world("level_world") then
		local var_1_1 = var_1_0:world("level_world")

		arg_1_0._wwise_world = var_1_0:wwise_world(var_1_1)
	end

	local var_1_2 = Managers.state.event

	if var_1_2 then
		arg_1_0._registered_event = true

		var_1_2:register(arg_1_0, "event_start_cutscene_overlay", "event_start_function")
	end

	arg_1_0._render_settings = {
		alpha_multiplier = 1
	}
end

CutsceneOverlayUI.force_unregister_event_listener = function (arg_2_0)
	local var_2_0 = Managers.state.event

	if var_2_0 and arg_2_0._registered_event then
		var_2_0:unregister("event_start_cutscene_overlay", arg_2_0)
	end

	arg_2_0._registered_event = nil
end

CutsceneOverlayUI._create_ui_elements = function (arg_3_0)
	arg_3_0._ui_scenegraph = UISceneGraph.init_scenegraph(var_0_0.scenegraph_definition)

	local var_3_0 = {}
	local var_3_1 = {}

	for iter_3_0, iter_3_1 in pairs(arg_3_0._templates) do
		var_3_1[iter_3_0] = {
			text_widget = UIWidget.init(var_0_0.widget_definitions.text),
			image_widget = UIWidget.init(var_0_0.widget_definitions.image)
		}
		var_3_0[iter_3_0] = {}
	end

	arg_3_0._active_template_lists = var_3_0
	arg_3_0._widgets_by_template = var_3_1
end

CutsceneOverlayUI.destroy = function (arg_4_0)
	local var_4_0 = Managers.state.event

	if var_4_0 and arg_4_0._registered_event then
		var_4_0:unregister("event_start_cutscene_overlay", arg_4_0)
	end
end

CutsceneOverlayUI.event_start_function = function (arg_5_0, arg_5_1)
	arg_5_0:start(arg_5_1)
end

CutsceneOverlayUI.start = function (arg_6_0, arg_6_1)
	local var_6_0 = arg_6_1.templates

	arg_6_0._templates = table.clone(var_6_0)
	arg_6_0._start_time = Managers.time:time("ui")
	arg_6_0._complete = false

	arg_6_0:_create_ui_elements()
end

CutsceneOverlayUI._present_template_entry = function (arg_7_0, arg_7_1, arg_7_2)
	local var_7_0 = arg_7_2.text
	local var_7_1 = arg_7_2.image
	local var_7_2 = 255
	local var_7_3 = arg_7_2.duration
	local var_7_4 = arg_7_2.start_time
	local var_7_5 = arg_7_2.end_time
	local var_7_6 = arg_7_2.fade_in_duration
	local var_7_7 = arg_7_2.fade_out_duration
	local var_7_8 = arg_7_0._widgets_by_template[arg_7_1]
	local var_7_9

	if var_7_0 then
		var_7_9 = var_7_8.text_widget

		local var_7_10 = var_7_9.content

		var_7_10.text = arg_7_2.localize and Localize(var_7_0) or var_7_0

		local var_7_11 = arg_7_2.font_size
		local var_7_12 = arg_7_2.font_type
		local var_7_13 = arg_7_2.word_wrap
		local var_7_14 = arg_7_2.font_upper_case
		local var_7_15 = arg_7_2.vertical_alignment or "center"

		if not arg_7_2.horizontal_alignment then
			local var_7_16 = "center"
		end

		local var_7_17 = arg_7_2.color or Colors.get_color_table_with_alpha("white", 255)
		local var_7_18 = arg_7_2.offset
		local var_7_19 = arg_7_2.use_shadow
		local var_7_20 = arg_7_2.inject_alpha
		local var_7_21 = var_7_9.style
		local var_7_22 = var_7_21.text
		local var_7_23 = var_7_21.text_shadow
		local var_7_24 = var_7_22.text_color

		var_7_2 = var_7_17[1]
		var_7_24[2] = var_7_17[2]
		var_7_24[3] = var_7_17[3]
		var_7_24[4] = var_7_17[4]
		var_7_22.inject_alpha = var_7_20
		var_7_22.font_size = var_7_11
		var_7_23.font_size = var_7_11
		var_7_22.font_type = var_7_12
		var_7_23.font_type = var_7_12
		var_7_22.word_wrap = var_7_13
		var_7_23.word_wrap = var_7_13
		var_7_22.upper_case = var_7_14
		var_7_23.upper_case = var_7_14
		var_7_22.vertical_alignment = var_7_15
		var_7_23.vertical_alignment = var_7_15

		if var_7_19 ~= nil then
			var_7_10.use_shadow = var_7_19
		end

		local var_7_25 = var_7_22.offset
		local var_7_26 = var_7_23.offset

		var_7_25[1] = var_7_18[1]
		var_7_25[2] = var_7_18[2]
		var_7_25[3] = var_7_18[3]
		var_7_26[1] = var_7_18[1] + 2
		var_7_26[2] = var_7_18[2] - 2
		var_7_26[3] = var_7_18[3] - 1
	elseif var_7_1 then
		var_7_9 = var_7_8.image_widget
		var_7_9.content.texture_id = var_7_1

		local var_7_27 = var_7_9.style.texture_id
		local var_7_28 = var_7_27.offset
		local var_7_29 = arg_7_2.offset

		var_7_28[1] = var_7_29[1]
		var_7_28[2] = var_7_29[2]
		var_7_28[3] = var_7_29[3]

		local var_7_30 = arg_7_2.image_size
		local var_7_31 = var_7_27.texture_size

		var_7_31[1] = var_7_30[1]
		var_7_31[2] = var_7_30[2]
	end

	return {
		initialized = false,
		text = var_7_0,
		image = var_7_1,
		duration = var_7_3,
		widget = var_7_9,
		max_alpha = var_7_2,
		start_time = var_7_4,
		end_time = var_7_5,
		fade_in_duration = var_7_6 and var_7_6 > 0 and var_7_6,
		fade_out_duration = var_7_7 and var_7_7 > 0 and var_7_7
	}
end

CutsceneOverlayUI._convert_string_timestamp_to_float = function (arg_8_0, arg_8_1)
	local var_8_0, var_8_1, var_8_2 = string.match(arg_8_1, "(%d+)%:(%d+)%:(%d+)")
	local var_8_3 = var_8_0 * 60 + var_8_1 + var_8_2 * 0.01
end

CutsceneOverlayUI._has_list_entries = function (arg_9_0, arg_9_1)
	return #arg_9_0._templates[arg_9_1] > 0
end

CutsceneOverlayUI._get_entry_by_time = function (arg_10_0, arg_10_1, arg_10_2)
	local var_10_0 = arg_10_0._templates[arg_10_1]
	local var_10_1 = var_10_0[1]

	if not var_10_1 then
		return
	end

	local var_10_2 = var_10_1.start_time

	if arg_10_2 >= var_10_1.end_time then
		table.remove(var_10_0, 1)

		return arg_10_0:_get_entry_by_time(arg_10_1, arg_10_2)
	end

	if var_10_2 <= arg_10_2 then
		return table.remove(var_10_0, 1)
	end
end

CutsceneOverlayUI.update = function (arg_11_0, arg_11_1)
	if not arg_11_0._start_time or arg_11_0._complete then
		return
	end

	local var_11_0 = Managers.time:time("ui") - arg_11_0._start_time
	local var_11_1 = true

	for iter_11_0, iter_11_1 in pairs(arg_11_0._active_template_lists) do
		local var_11_2 = false
		local var_11_3 = iter_11_1.active_entry_data

		if var_11_3 then
			local var_11_4 = var_11_3.start_time
			local var_11_5 = var_11_3.end_time
			local var_11_6 = var_11_3.duration

			if var_11_0 > var_11_4 + var_11_6 then
				iter_11_1.active_entry_data = nil
			else
				local var_11_7 = var_11_3.widget
				local var_11_8 = var_11_3.fade_out_duration
				local var_11_9 = var_11_3.fade_in_duration
				local var_11_10 = var_11_3.max_alpha
				local var_11_11 = 1

				if var_11_9 and var_11_0 <= var_11_4 + var_11_9 then
					var_11_11 = math.min((var_11_0 - var_11_4) / var_11_9, 1)
				elseif var_11_8 and var_11_0 >= var_11_4 + var_11_6 - var_11_8 then
					var_11_11 = 1 - math.min((var_11_0 - (var_11_5 - var_11_8)) / var_11_8, 1)
				end

				arg_11_0:_fade(var_11_7, var_11_10, var_11_11)
				arg_11_0:_draw(var_11_7, arg_11_1)
			end
		elseif not arg_11_0:_has_list_entries(iter_11_0) then
			arg_11_0._active_template_lists[iter_11_0] = nil
			var_11_2 = true
		else
			local var_11_12 = arg_11_0:_get_entry_by_time(iter_11_0, var_11_0)
			local var_11_13 = var_11_12 and arg_11_0:_present_template_entry(iter_11_0, var_11_12)

			iter_11_1.active_entry_data = var_11_13

			if var_11_13 and not var_11_13.initialized then
				var_11_13.initialized = true

				local var_11_14 = var_11_13.sound_event

				if var_11_14 and arg_11_0._wwise_world then
					WwiseWorld.trigger_event(arg_11_0._wwise_world, var_11_14)
				end
			end
		end

		if not var_11_2 then
			var_11_1 = false
		end
	end

	arg_11_0._complete = var_11_1
end

CutsceneOverlayUI._fade = function (arg_12_0, arg_12_1, arg_12_2, arg_12_3)
	local var_12_0 = arg_12_3 * arg_12_2
	local var_12_1 = arg_12_1.style

	if var_12_1.text then
		local var_12_2 = var_12_1.text.text_color
		local var_12_3 = var_12_1.text_shadow.text_color

		var_12_2[1] = var_12_0
		var_12_3[1] = var_12_0
	else
		var_12_1.texture_id.color[1] = var_12_0
	end
end

CutsceneOverlayUI._draw = function (arg_13_0, arg_13_1, arg_13_2)
	local var_13_0 = arg_13_0._ui_renderer
	local var_13_1 = arg_13_0._ui_scenegraph
	local var_13_2 = FAKE_INPUT_SERVICE
	local var_13_3 = arg_13_0.render_settings

	UIRenderer.begin_pass(var_13_0, var_13_1, var_13_2, arg_13_2, var_13_3)
	UIRenderer.draw_widget(var_13_0, arg_13_1)
	UIRenderer.end_pass(var_13_0)
end
