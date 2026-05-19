-- chunkname: @scripts/ui/views/telemetry_survey_view.lua

local var_0_0 = local_require("scripts/ui/views/telemetry_survey_view_definitions")

TelemetrySurveyView = class(TelemetrySurveyView)

local var_0_1 = 20

function TelemetrySurveyView.init(arg_1_0, arg_1_1)
	arg_1_0.ui_renderer = arg_1_1.ui_renderer
	arg_1_0.ui_top_renderer = arg_1_1.ui_top_renderer
	arg_1_0.ingame_ui = arg_1_1.ingame_ui
	arg_1_0.input_manager = arg_1_1.input_manager
	arg_1_0.world_manager = arg_1_1.world_manager
	arg_1_0.time_manager = arg_1_1.time_manager
	arg_1_0.peer_id = arg_1_1.peer_id
	arg_1_0.is_server = arg_1_1.is_server
	arg_1_0.active = false
	arg_1_0.opened = false
	arg_1_0.timed_out = false
	arg_1_0.transition_to = nil
	arg_1_0.survey_answered = false
	arg_1_0.survey_confirmed = false
	arg_1_0.session_rating = 0
	arg_1_0.survey_context = nil
	arg_1_0.end_time = nil

	arg_1_0:create_ui_elements()

	local var_1_0 = arg_1_0.world_manager:world("level_world")

	arg_1_0.wwise_world = Managers.world:wwise_world(var_1_0)

	local var_1_1 = arg_1_0.input_manager

	var_1_1:create_input_service("telemetry_survey", "IngameMenuKeymaps", "IngameMenuFilters")
	var_1_1:map_device_to_service("telemetry_survey", "keyboard")
	var_1_1:map_device_to_service("telemetry_survey", "mouse")
	var_1_1:map_device_to_service("telemetry_survey", "gamepad")
end

function TelemetrySurveyView.input_service(arg_2_0)
	return arg_2_0.input_manager:get_service("telemetry_survey")
end

function TelemetrySurveyView.set_transition(arg_3_0, arg_3_1)
	arg_3_0.transition_to = arg_3_1
end

function TelemetrySurveyView.set_survey_context(arg_4_0, arg_4_1)
	arg_4_0.survey_context = arg_4_1
end

function TelemetrySurveyView.get_survey_context(arg_5_0)
	return arg_5_0.survey_context
end

function TelemetrySurveyView.is_survey_answered(arg_6_0)
	return arg_6_0.survey_answered and arg_6_0.survey_confirmed
end

function TelemetrySurveyView.is_survey_timed_out(arg_7_0)
	return arg_7_0.timed_out
end

function TelemetrySurveyView.create_ui_elements(arg_8_0)
	arg_8_0.ui_scenegraph = UISceneGraph.init_scenegraph(var_0_0.scenegraph_definition)
	arg_8_0.background_1 = UIWidget.init(var_0_0.widget_definitions.background_1)
	arg_8_0.background_2 = UIWidget.init(var_0_0.widget_definitions.background_2)
	arg_8_0.headers = UIWidget.init(var_0_0.widget_definitions.headers)

	local var_8_0 = {}

	for iter_8_0 = 1, 5 do
		var_8_0[iter_8_0] = UIWidget.init(var_0_0.survey_rating_definitions(iter_8_0))
	end

	arg_8_0.survey_ratings = var_8_0
	arg_8_0.continue_button = UIWidget.init(var_0_0.widget_definitions.continue_button)
end

function TelemetrySurveyView.destroy(arg_9_0)
	if arg_9_0.active then
		arg_9_0:set_active(false)
	end
end

function TelemetrySurveyView.play_sound(arg_10_0, arg_10_1)
	WwiseWorld.trigger_event(arg_10_0.wwise_world, arg_10_1)
end

function TelemetrySurveyView.on_enter(arg_11_0)
	arg_11_0.timed_out = false
	arg_11_0.survey_confirmed = false

	arg_11_0:set_active(not arg_11_0.active)
end

function TelemetrySurveyView.on_exit(arg_12_0)
	arg_12_0:set_active(not arg_12_0.active)
	arg_12_0:play_sound("Play_hud_button_close")

	arg_12_0.opened = false

	if arg_12_0.survey_answered and arg_12_0.survey_confirmed then
		arg_12_0:record_telemetry_survey()
	end

	arg_12_0.session_rating = 0
end

function TelemetrySurveyView.transition(arg_13_0)
	if arg_13_0.transition_to ~= nil then
		arg_13_0.ingame_ui:handle_transition(arg_13_0.transition_to)
	end
end

function TelemetrySurveyView.record_telemetry_survey(arg_14_0)
	assert(arg_14_0.session_rating ~= 0, "Session rating was never set!")

	local var_14_0 = Managers.player:player_from_peer_id(arg_14_0.peer_id)

	Managers.telemetry.event:session_rating(var_14_0, arg_14_0.session_rating)
end

function TelemetrySurveyView.update(arg_15_0, arg_15_1)
	if not arg_15_0.active then
		return
	end

	local var_15_0 = arg_15_0.input_manager:get_service("ingame_menu")
	local var_15_1 = arg_15_0.time_manager:time("game")
	local var_15_2 = arg_15_0.end_time - var_15_1

	arg_15_0:update_rating_buttons()
	arg_15_0:update_time_text(var_15_2)
	arg_15_0:update_button_disabled()
	arg_15_0:handle_interaction(arg_15_1)
	arg_15_0:draw(arg_15_1)

	if var_15_1 >= arg_15_0.end_time then
		arg_15_0.timed_out = true

		arg_15_0:transition()
	end
end

function TelemetrySurveyView.update_time_text(arg_16_0, arg_16_1)
	arg_16_0.headers.content.time_left = tostring(math.round(arg_16_1, 0))
end

function TelemetrySurveyView.update_rating_buttons(arg_17_0)
	local var_17_0 = arg_17_0.survey_ratings

	for iter_17_0 = #var_17_0, 1, -1 do
		local var_17_1 = var_17_0[iter_17_0]

		if var_17_1.content.button_hotspot.is_clicked == 0 then
			arg_17_0.session_rating = iter_17_0
			arg_17_0.survey_answered = true
		elseif iter_17_0 <= arg_17_0.session_rating then
			var_17_1.content.button_hotspot.is_selected = true
		else
			var_17_1.content.button_hotspot.is_selected = false
		end
	end
end

function TelemetrySurveyView.update_button_disabled(arg_18_0)
	arg_18_0.continue_button.content.disabled = not arg_18_0.survey_answered

	local var_18_0 = arg_18_0.continue_button.content.disabled
	local var_18_1 = arg_18_0.continue_button.style.text

	var_18_1.text_color = var_18_0 and var_18_1.disabled_color or var_18_1.base_color
end

function TelemetrySurveyView.set_active(arg_19_0, arg_19_1)
	arg_19_0.active = arg_19_1

	local var_19_0 = arg_19_0.input_manager

	if arg_19_1 then
		ShowCursorStack.show("TelemetrySurveyView")
		var_19_0:block_device_except_service("telemetry_survey", "keyboard")
		var_19_0:block_device_except_service("telemetry_survey", "mouse")
		var_19_0:block_device_except_service("telemetry_survey", "gamepad")

		arg_19_0.end_time = arg_19_0.time_manager:time("game") + var_0_1
	else
		ShowCursorStack.hide("TelemetrySurveyView")
		var_19_0:device_unblock_all_services("keyboard")
		var_19_0:device_unblock_all_services("mouse")
		var_19_0:device_unblock_all_services("gamepad")
	end
end

function TelemetrySurveyView.handle_interaction(arg_20_0, arg_20_1)
	if arg_20_0.opened then
		if not arg_20_0.continue_button.content.disabled then
			local var_20_0 = arg_20_0.continue_button.content.button_hotspot.on_release
			local var_20_1 = arg_20_0.continue_button.content.button_hotspot.on_hover_enter
			local var_20_2 = arg_20_0.input_manager:get_service("telemetry_survey")

			if arg_20_0.continue_button.content.button_hotspot.on_hover_enter then
				arg_20_0:play_sound("Play_hud_hover")
			end

			if var_20_2:get("confirm") or var_20_0 then
				arg_20_0.survey_confirmed = true

				arg_20_0:transition()
			end
		end
	else
		arg_20_0.opened = true
	end
end

function TelemetrySurveyView.draw(arg_21_0, arg_21_1)
	local var_21_0 = arg_21_0.ui_top_renderer
	local var_21_1 = arg_21_0.ui_scenegraph
	local var_21_2 = arg_21_0.input_manager:get_service("telemetry_survey")
	local var_21_3 = arg_21_0.survey_ratings

	UIRenderer.begin_pass(var_21_0, var_21_1, var_21_2, arg_21_1)
	UIRenderer.draw_widget(var_21_0, arg_21_0.background_1)
	UIRenderer.draw_widget(var_21_0, arg_21_0.background_2)
	UIRenderer.draw_widget(var_21_0, arg_21_0.headers)
	UIRenderer.draw_widget(var_21_0, arg_21_0.continue_button)

	for iter_21_0 = 1, #var_21_3 do
		UIRenderer.draw_widget(var_21_0, var_21_3[iter_21_0])
	end

	UIRenderer.end_pass(var_21_0)
end
