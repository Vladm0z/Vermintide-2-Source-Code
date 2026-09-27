-- chunkname: @scripts/ui/views/telemetry_survey_view.lua

local var_0_0 = local_require("scripts/ui/views/telemetry_survey_view_definitions")

TelemetrySurveyView = class(TelemetrySurveyView)

local num = 20

TelemetrySurveyView.init = function (self, arg_1_1)
	-- function 1
	self.ui_renderer = arg_1_1.ui_renderer
	self.ui_top_renderer = arg_1_1.ui_top_renderer
	self.ingame_ui = arg_1_1.ingame_ui
	self.input_manager = arg_1_1.input_manager
	self.world_manager = arg_1_1.world_manager
	self.time_manager = arg_1_1.time_manager
	self.peer_id = arg_1_1.peer_id
	self.is_server = arg_1_1.is_server
	self.active = false
	self.opened = false
	self.timed_out = false
	self.transition_to = nil
	self.survey_answered = false
	self.survey_confirmed = false
	self.session_rating = 0
	self.survey_context = nil
	self.end_time = nil

	self:create_ui_elements()

	local world = self.world_manager:world("level_world")

	self.wwise_world = Managers.world:wwise_world(world)

	local input_manager = self.input_manager

	input_manager:create_input_service("telemetry_survey", "IngameMenuKeymaps", "IngameMenuFilters")
	input_manager:map_device_to_service("telemetry_survey", "keyboard")
	input_manager:map_device_to_service("telemetry_survey", "mouse")
	input_manager:map_device_to_service("telemetry_survey", "gamepad")
end

TelemetrySurveyView.input_service = function (self)
	-- function 2
	return self.input_manager:get_service("telemetry_survey")
end

TelemetrySurveyView.set_transition = function (self, arg_3_1)
	-- function 3
	self.transition_to = arg_3_1
end

TelemetrySurveyView.set_survey_context = function (self, arg_4_1)
	-- function 4
	self.survey_context = arg_4_1
end

TelemetrySurveyView.get_survey_context = function (self)
	-- function 5
	return self.survey_context
end

TelemetrySurveyView.is_survey_answered = function (self)
	-- function 6
	local survey_answered = self.survey_answered

	survey_answered = not survey_answered and self.survey_confirmed

	return survey_answered
end

TelemetrySurveyView.is_survey_timed_out = function (self)
	-- function 7
	return self.timed_out
end

TelemetrySurveyView.create_ui_elements = function (self)
	-- function 8
	self.ui_scenegraph = UISceneGraph.init_scenegraph(var_0_0.scenegraph_definition)
	self.background_1 = UIWidget.init(var_0_0.widget_definitions.background_1)
	self.background_2 = UIWidget.init(var_0_0.widget_definitions.background_2)
	self.headers = UIWidget.init(var_0_0.widget_definitions.headers)

	local tbl = {}

	for i = 1, 5 do
		tbl[i] = UIWidget.init(var_0_0.survey_rating_definitions(i))
	end

	self.survey_ratings = tbl
	self.continue_button = UIWidget.init(var_0_0.widget_definitions.continue_button)
end

TelemetrySurveyView.destroy = function (self)
	-- function 9
	if not self.active then
		self:set_active(false)
	end
end

TelemetrySurveyView.play_sound = function (self, arg_10_1)
	-- function 10
	WwiseWorld.trigger_event(self.wwise_world, arg_10_1)
end

TelemetrySurveyView.on_enter = function (self)
	-- function 11
	self.timed_out = false
	self.survey_confirmed = false

	self:set_active(not self.active)
end

TelemetrySurveyView.on_exit = function (self)
	-- function 12
	self:set_active(not self.active)
	self:play_sound("Play_hud_button_close")

	self.opened = false

	if not self.survey_answered and not self.survey_confirmed then
		self:record_telemetry_survey()
	end

	self.session_rating = 0
end

TelemetrySurveyView.transition = function (self)
	-- function 13
	if self.transition_to ~= nil then
		self.ingame_ui:handle_transition(self.transition_to)
	end
end

TelemetrySurveyView.record_telemetry_survey = function (self)
	-- function 14
	assert(self.session_rating ~= 0, "Session rating was never set!")

	local player_from_peer_id = Managers.player:player_from_peer_id(self.peer_id)

	Managers.telemetry.event:session_rating(player_from_peer_id, self.session_rating)
end

TelemetrySurveyView.update = function (self, arg_15_1)
	-- function 15
	if not self.active then
		return
	end

	local get_service = self.input_manager:get_service("ingame_menu")
	local time = self.time_manager:time("game")
	local num = self.end_time - time

	self:update_rating_buttons()
	self:update_time_text(num)
	self:update_button_disabled()
	self:handle_interaction(arg_15_1)
	self:draw(arg_15_1)

	if time >= self.end_time then
		self.timed_out = true

		self:transition()
	end
end

TelemetrySurveyView.update_time_text = function (arg_16_0, arg_16_1)
	-- function 16
	arg_16_0.headers.content.time_left = tostring(math.round(arg_16_1, 0))
end

TelemetrySurveyView.update_rating_buttons = function (self)
	-- function 17
	local survey_ratings = self.survey_ratings

	for i = #survey_ratings, 1, -1 do
		local var_17_1 = survey_ratings[i]

		if not (var_17_1.content.button_hotspot.is_clicked == 0) then
			self.session_rating = i
			self.survey_answered = true
		elseif i <= self.session_rating then
			var_17_1.content.button_hotspot.is_selected = true
		else
			var_17_1.content.button_hotspot.is_selected = false
		end
	end
end

TelemetrySurveyView.update_button_disabled = function (self)
	-- function 18
	self.continue_button.content.disabled = not self.survey_answered

	local disabled = self.continue_button.content.disabled
	local text = self.continue_button.style.text
	local disabled_color

	if not disabled then
		disabled_color = text.disabled_color

		if not disabled_color then
			-- Nothing
		end
	end

	disabled_color = text.base_color

	::label_18_0::

	text.text_color = disabled_color
end

TelemetrySurveyView.set_active = function (self, arg_19_1)
	-- function 19
	self.active = arg_19_1

	local input_manager = self.input_manager

	if not arg_19_1 then
		ShowCursorStack.show("TelemetrySurveyView")
		input_manager:block_device_except_service("telemetry_survey", "keyboard")
		input_manager:block_device_except_service("telemetry_survey", "mouse")
		input_manager:block_device_except_service("telemetry_survey", "gamepad")

		self.end_time = self.time_manager:time("game") + num
	else
		ShowCursorStack.hide("TelemetrySurveyView")
		input_manager:device_unblock_all_services("keyboard")
		input_manager:device_unblock_all_services("mouse")
		input_manager:device_unblock_all_services("gamepad")
	end
end

TelemetrySurveyView.handle_interaction = function (self, arg_20_1)
	-- function 20
	if not self.opened then
		if not self.continue_button.content.disabled then
			local on_release = self.continue_button.content.button_hotspot.on_release
			local on_hover_enter = self.continue_button.content.button_hotspot.on_hover_enter
			local get_service = self.input_manager:get_service("telemetry_survey")

			if not self.continue_button.content.button_hotspot.on_hover_enter then
				self:play_sound("Play_hud_hover")
			end

			if get_service:get("confirm") or not on_release then
				self.survey_confirmed = true

				self:transition()
			end
		end
	else
		self.opened = true
	end
end

TelemetrySurveyView.draw = function (self, arg_21_1)
	-- function 21
	local ui_top_renderer = self.ui_top_renderer
	local ui_scenegraph = self.ui_scenegraph
	local get_service = self.input_manager:get_service("telemetry_survey")
	local survey_ratings = self.survey_ratings

	UIRenderer.begin_pass(ui_top_renderer, ui_scenegraph, get_service, arg_21_1)
	UIRenderer.draw_widget(ui_top_renderer, self.background_1)
	UIRenderer.draw_widget(ui_top_renderer, self.background_2)
	UIRenderer.draw_widget(ui_top_renderer, self.headers)
	UIRenderer.draw_widget(ui_top_renderer, self.continue_button)

	for i = 1, #survey_ratings do
		UIRenderer.draw_widget(ui_top_renderer, survey_ratings[i])
	end

	UIRenderer.end_pass(ui_top_renderer)
end
