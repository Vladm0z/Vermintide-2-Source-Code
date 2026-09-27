-- chunkname: @scripts/ui/views/subtitle_gui.lua

local tbl = {
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
	tbl.screen.scale = "hud_fit"
end

local tbl_2 = {
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

SubtitleGui.init = function (self, arg_1_1, arg_1_2)
	-- function 1
	self._parent = arg_1_1
	self._dialogue_system = arg_1_2.dialogue_system
	self._ui_renderer = arg_1_2.ui_renderer
	self._input_manager = arg_1_2.input_manager
	self.playing_dialogues = {}
	self.subtitles_to_display = {}
	self.subtitle_list = {}
	self._subtitle_text = ""

	self:_create_ui_elements()

	local user_setting = Application.user_setting("use_subtitles")

	if user_setting ~= nil then
		UISettings.use_subtitles = user_setting
	end

	if LAUNCH_MODE == "attract_benchmark" then
		UISettings.use_subtitles = false
	end

	local event = Managers.state.event

	if not event then
		event:register(self, "ui_event_start_subtitle", "start_subtitle")
		event:register(self, "ui_event_stop_subtitle", "stop_subtitle")
	end
end

SubtitleGui._create_ui_elements = function (self)
	-- function 2
	self._ui_scenegraph = UISceneGraph.init_scenegraph(tbl)
	self._subtitle_widget = UIWidget.init(tbl_2)
end

SubtitleGui.destroy = function (self)
	-- function 3
	local event = Managers.state.event

	if not event then
		event:unregister("ui_event_start_subtitle", self)
		event:unregister("ui_event_stop_subtitle", self)
	end

	self.playing_dialogues = nil

	GarbageLeakDetector.register_object(self, "subtitle_gui")
end

SubtitleGui._add_subtitle = function (arg_4_0, arg_4_1, arg_4_2, arg_4_3)
	-- function 4
	local tbl = {
		unit = arg_4_1,
		speaker = arg_4_2,
		text = arg_4_3
	}

	arg_4_0.subtitle_list[#arg_4_0.subtitle_list + 1] = tbl
end

SubtitleGui._remove_subtitle = function (self, arg_5_1)
	-- function 5
	local subtitle_list = self.subtitle_list
	local count = #subtitle_list

	for i = 1, count do
		if arg_5_1 == subtitle_list[i].unit then
			table.remove(subtitle_list, i)

			break
		end
	end
end

SubtitleGui._has_subtitle_for_unit = function (self, arg_6_1)
	-- function 6
	local subtitle_list = self.subtitle_list
	local count = #subtitle_list

	for i = 1, count do
		if arg_6_1 == subtitle_list[i].unit then
			return true
		end
	end
end

local tbl_3 = {
	root_scenegraph_id = "subtitle_background",
	label = "Subtitles",
	registry_key = "subtitle",
	drag_scenegraph_id = "subtitle_background"
}

SubtitleGui.update = function (self, arg_7_1)
	-- function 7
	if not UISettings.use_subtitles then
		return
	end

	HudCustomizer.run(self._ui_renderer, self._ui_scenegraph, tbl_3)

	local flag = false
	local _dialogue_system = self._dialogue_system
	local playing_dialogues = self.playing_dialogues

	for k, v in pairs(playing_dialogues) do
		if not HEALTH_ALIVE[k] then
			playing_dialogues[k] = nil

			self:_remove_subtitle(k)

			flag = true
		end
	end

	for k_2, v_2 in pairs(_dialogue_system:dialogue_units()) do
		local currently_playing_dialogue = v_2.currently_playing_dialogue
		local flag_2 = playing_dialogues[k_2] ~= currently_playing_dialogue

		if not currently_playing_dialogue then
			if not flag_2 then
				flag = true

				local currently_playing_subtitle = currently_playing_dialogue.currently_playing_subtitle

				if not Managers.localizer:exists(currently_playing_subtitle) then
					local var_7_6 = Localize(currently_playing_subtitle)

					if var_7_6 ~= "" then
						if not self:_has_subtitle_for_unit(k_2) then
							self:_remove_subtitle(k_2)
						end

						local speaker_name = currently_playing_dialogue.speaker_name
						local var_7_8 = Localize("subtitle_name_" .. speaker_name)
						local var_7_9 = DialogueSettings.speaker_color_lookup[speaker_name]

						var_7_9 = var_7_9 or DialogueSettings.speaker_color_lookup.default

						if not var_7_9 then
							var_7_8 = string.format("{#color(%d,%d,%d)}%s{#reset()}", var_7_9[2], var_7_9[3], var_7_9[4], var_7_8)
						end

						self:_add_subtitle(k_2, var_7_8, var_7_6)
					end
				end
			end

			playing_dialogues[k_2] = currently_playing_dialogue
		else
			if not flag_2 then
				self:_remove_subtitle(k_2)

				flag = true
			end

			if not playing_dialogues[k_2] then
				playing_dialogues[k_2] = nil
			end
		end
	end

	if flag or not self._force_text_remake then
		self._force_text_remake = nil

		local str = ""
		local subtitle_list = self.subtitle_list
		local count = #subtitle_list

		for i4 = 1, count do
			local var_7_13 = subtitle_list[i4]
			local speaker = var_7_13.speaker
			local text = var_7_13.text

			if speaker == "" then
				str = str .. text .. "\n"
			else
				str = str .. speaker .. ": " .. text .. "\n"
			end
		end

		for k_3, v_3 in pairs(self.subtitles_to_display) do
			local var_7_16 = Localize(k_3)

			if var_7_16 == "" then
				str = str .. Localize(v_3) .. "\n"
			else
				str = str .. var_7_16 .. ": " .. Localize(v_3) .. "\n"
			end
		end

		self._subtitle_text = str
	end

	local get_service = self._input_manager:get_service("ingame_menu")
	local _ui_renderer = self._ui_renderer
	local _ui_scenegraph = self._ui_scenegraph

	UIRenderer.begin_pass(_ui_renderer, _ui_scenegraph, get_service, arg_7_1)

	if self._subtitle_text ~= "" then
		local _subtitle_widget = self._subtitle_widget

		_subtitle_widget.content.text_field = self._subtitle_text
		_subtitle_widget.style.text.font_size = UISettings.subtitles_font_size
		_subtitle_widget.style.text.rect_color[1] = UISettings.subtitles_background_alpha

		UIRenderer.draw_widget(_ui_renderer, _subtitle_widget)
	end

	UIRenderer.end_pass(_ui_renderer)
end

SubtitleGui.start_subtitle = function (self, arg_8_1, arg_8_2)
	-- function 8
	self.subtitles_to_display[arg_8_1] = arg_8_2
	self._force_text_remake = true
end

SubtitleGui.stop_subtitle = function (self, arg_9_1)
	-- function 9
	self.subtitles_to_display[arg_9_1] = nil
	self._force_text_remake = true
end

SubtitleGui.is_displaying_subtitle = function (self)
	-- function 10
	local subtitles_to_display = self.subtitles_to_display

	subtitles_to_display = not subtitles_to_display and self._subtitle_text ~= ""

	return subtitles_to_display
end
