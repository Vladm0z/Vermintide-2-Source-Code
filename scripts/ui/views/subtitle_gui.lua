-- chunkname: @scripts/ui/views/subtitle_gui.lua

local var_0_0 = {
	screen = {
		scale = "fit",
		position = {
			0,
			0,
			UILayer.hud
		},
		size = {
			1920,
			1080
		}
	},
	subtitle_background_parent = {
		vertical_alignment = "bottom",
		parent = "screen",
		horizontal_alignment = "center",
		position = {
			0,
			120,
			1
		},
		size = {
			850,
			140
		}
	},
	subtitle_background = {
		vertical_alignment = "bottom",
		parent = "subtitle_background_parent",
		horizontal_alignment = "left",
		position = {
			0,
			0,
			0
		},
		size = {
			850,
			140
		}
	}
}

if not IS_WINDOWS then
	var_0_0.screen.scale = "hud_fit"
end

local var_0_1 = {
	scenegraph_id = "subtitle_background",
	element = UIElements.StaticText,
	content = {
		text_field = ""
	},
	style = {
		text = {
			vertical_alignment = "bottom",
			horizontal_alignment = "left",
			word_wrap = true,
			font_type = "hell_shark",
			draw_text_rect = true,
			text_color = Colors.get_table("white"),
			font_size = UISettings.subtitles_font_size,
			rect_color = Colors.get_color_table_with_alpha("black", UISettings.subtitles_background_alpha)
		}
	}
}

SubtitleGui = class(SubtitleGui)

SubtitleGui.init = function (arg_1_0, arg_1_1, arg_1_2)
	arg_1_0._parent = arg_1_1
	arg_1_0._dialogue_system = arg_1_2.dialogue_system
	arg_1_0._ui_renderer = arg_1_2.ui_renderer
	arg_1_0._input_manager = arg_1_2.input_manager
	arg_1_0.playing_dialogues = {}
	arg_1_0.subtitles_to_display = {}
	arg_1_0.subtitle_list = {}
	arg_1_0._subtitle_text = ""

	arg_1_0:_create_ui_elements()

	local var_1_0 = Application.user_setting("use_subtitles")

	if var_1_0 ~= nil then
		UISettings.use_subtitles = var_1_0
	end

	if LAUNCH_MODE == "attract_benchmark" then
		UISettings.use_subtitles = false
	end

	local var_1_1 = Managers.state.event

	if var_1_1 then
		var_1_1:register(arg_1_0, "ui_event_start_subtitle", "start_subtitle")
		var_1_1:register(arg_1_0, "ui_event_stop_subtitle", "stop_subtitle")
	end
end

SubtitleGui._create_ui_elements = function (arg_2_0)
	arg_2_0._ui_scenegraph = UISceneGraph.init_scenegraph(var_0_0)
	arg_2_0._subtitle_widget = UIWidget.init(var_0_1)
end

SubtitleGui.destroy = function (arg_3_0)
	local var_3_0 = Managers.state.event

	if var_3_0 then
		var_3_0:unregister("ui_event_start_subtitle", arg_3_0)
		var_3_0:unregister("ui_event_stop_subtitle", arg_3_0)
	end

	arg_3_0.playing_dialogues = nil

	GarbageLeakDetector.register_object(arg_3_0, "subtitle_gui")
end

SubtitleGui._add_subtitle = function (arg_4_0, arg_4_1, arg_4_2, arg_4_3)
	local var_4_0 = {
		unit = arg_4_1,
		speaker = arg_4_2,
		text = arg_4_3
	}

	arg_4_0.subtitle_list[#arg_4_0.subtitle_list + 1] = var_4_0
end

SubtitleGui._remove_subtitle = function (arg_5_0, arg_5_1)
	local var_5_0 = arg_5_0.subtitle_list
	local var_5_1 = #var_5_0

	for iter_5_0 = 1, var_5_1 do
		if arg_5_1 == var_5_0[iter_5_0].unit then
			table.remove(var_5_0, iter_5_0)

			break
		end
	end
end

SubtitleGui._has_subtitle_for_unit = function (arg_6_0, arg_6_1)
	local var_6_0 = arg_6_0.subtitle_list
	local var_6_1 = #var_6_0

	for iter_6_0 = 1, var_6_1 do
		if arg_6_1 == var_6_0[iter_6_0].unit then
			return true
		end
	end
end

local var_0_2 = {
	root_scenegraph_id = "subtitle_background",
	label = "Subtitles",
	registry_key = "subtitle",
	drag_scenegraph_id = "subtitle_background"
}

SubtitleGui.update = function (arg_7_0, arg_7_1)
	if not UISettings.use_subtitles then
		return
	end

	HudCustomizer.run(arg_7_0._ui_renderer, arg_7_0._ui_scenegraph, var_0_2)

	local var_7_0 = false
	local var_7_1 = arg_7_0._dialogue_system
	local var_7_2 = arg_7_0.playing_dialogues

	for iter_7_0, iter_7_1 in pairs(var_7_2) do
		if not HEALTH_ALIVE[iter_7_0] then
			var_7_2[iter_7_0] = nil

			arg_7_0:_remove_subtitle(iter_7_0)

			var_7_0 = true
		end
	end

	for iter_7_2, iter_7_3 in pairs(var_7_1:dialogue_units()) do
		local var_7_3 = iter_7_3.currently_playing_dialogue
		local var_7_4 = var_7_2[iter_7_2] ~= var_7_3

		if var_7_3 then
			if var_7_4 then
				var_7_0 = true

				local var_7_5 = var_7_3.currently_playing_subtitle

				if Managers.localizer:exists(var_7_5) then
					local var_7_6 = Localize(var_7_5)

					if var_7_6 ~= "" then
						if arg_7_0:_has_subtitle_for_unit(iter_7_2) then
							arg_7_0:_remove_subtitle(iter_7_2)
						end

						local var_7_7 = var_7_3.speaker_name
						local var_7_8 = Localize("subtitle_name_" .. var_7_7)
						local var_7_9 = DialogueSettings.speaker_color_lookup[var_7_7] or DialogueSettings.speaker_color_lookup.default

						if var_7_9 then
							var_7_8 = string.format("{#color(%d,%d,%d)}%s{#reset()}", var_7_9[2], var_7_9[3], var_7_9[4], var_7_8)
						end

						arg_7_0:_add_subtitle(iter_7_2, var_7_8, var_7_6)
					end
				end
			end

			var_7_2[iter_7_2] = var_7_3
		else
			if var_7_4 then
				arg_7_0:_remove_subtitle(iter_7_2)

				var_7_0 = true
			end

			if var_7_2[iter_7_2] then
				var_7_2[iter_7_2] = nil
			end
		end
	end

	if var_7_0 or arg_7_0._force_text_remake then
		arg_7_0._force_text_remake = nil

		local var_7_10 = ""
		local var_7_11 = arg_7_0.subtitle_list
		local var_7_12 = #var_7_11

		for iter_7_4 = 1, var_7_12 do
			local var_7_13 = var_7_11[iter_7_4]
			local var_7_14 = var_7_13.speaker
			local var_7_15 = var_7_13.text

			if var_7_14 == "" then
				var_7_10 = var_7_10 .. var_7_15 .. "\n"
			else
				var_7_10 = var_7_10 .. var_7_14 .. ": " .. var_7_15 .. "\n"
			end
		end

		for iter_7_5, iter_7_6 in pairs(arg_7_0.subtitles_to_display) do
			local var_7_16 = Localize(iter_7_5)

			if var_7_16 == "" then
				var_7_10 = var_7_10 .. Localize(iter_7_6) .. "\n"
			else
				var_7_10 = var_7_10 .. var_7_16 .. ": " .. Localize(iter_7_6) .. "\n"
			end
		end

		arg_7_0._subtitle_text = var_7_10
	end

	local var_7_17 = arg_7_0._input_manager:get_service("ingame_menu")
	local var_7_18 = arg_7_0._ui_renderer
	local var_7_19 = arg_7_0._ui_scenegraph

	UIRenderer.begin_pass(var_7_18, var_7_19, var_7_17, arg_7_1)

	if arg_7_0._subtitle_text ~= "" then
		local var_7_20 = arg_7_0._subtitle_widget

		var_7_20.content.text_field = arg_7_0._subtitle_text
		var_7_20.style.text.font_size = UISettings.subtitles_font_size
		var_7_20.style.text.rect_color[1] = UISettings.subtitles_background_alpha

		UIRenderer.draw_widget(var_7_18, var_7_20)
	end

	UIRenderer.end_pass(var_7_18)
end

SubtitleGui.start_subtitle = function (arg_8_0, arg_8_1, arg_8_2)
	arg_8_0.subtitles_to_display[arg_8_1] = arg_8_2
	arg_8_0._force_text_remake = true
end

SubtitleGui.stop_subtitle = function (arg_9_0, arg_9_1)
	arg_9_0.subtitles_to_display[arg_9_1] = nil
	arg_9_0._force_text_remake = true
end

SubtitleGui.is_displaying_subtitle = function (arg_10_0)
	return arg_10_0.subtitles_to_display and arg_10_0._subtitle_text ~= ""
end
