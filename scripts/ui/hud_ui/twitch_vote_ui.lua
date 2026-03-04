-- chunkname: @scripts/ui/hud_ui/twitch_vote_ui.lua

local var_0_0 = local_require("scripts/ui/hud_ui/twitch_vote_ui_definitions")
local var_0_1 = var_0_0.scenegraph_definition
local var_0_2 = var_0_0.settings
local var_0_3 = var_0_0.vote_texts
local var_0_4 = false
local var_0_5 = 3
local var_0_6 = 5

TwitchVoteUI = class(TwitchVoteUI)

TwitchVoteUI.init = function (arg_1_0, arg_1_1, arg_1_2)
	arg_1_0._parent = arg_1_1
	arg_1_0._ui_renderer = arg_1_2.ui_renderer
	arg_1_0._ingame_ui = arg_1_2.ingame_ui
	arg_1_0._input_manager = arg_1_2.input_manager
	arg_1_0._world_manager = arg_1_2.world_manager
	arg_1_0.active = false
	arg_1_0._active_vote = nil
	arg_1_0._vote_activated = false
	arg_1_0._votes = {}
	arg_1_0._ui_animations = {}
	arg_1_0._animation_callbacks = {}
	arg_1_0._render_settings = {
		alpha_multiplier = 1
	}
	arg_1_0._last_played_countdown_sfx = var_0_6 + 1

	local var_1_0 = arg_1_0._world_manager:world("level_world")

	arg_1_0.wwise_world = Managers.world:wwise_world(var_1_0)

	arg_1_0:_create_elements()
	Managers.state.event:register(arg_1_0, "add_vote_ui", "event_add_vote_ui")
	Managers.state.event:register(arg_1_0, "finish_vote_ui", "event_finish_vote_ui")
	Managers.state.event:register(arg_1_0, "reset_vote_ui", "event_reset_vote_ui")
end

TwitchVoteUI.event_add_vote_ui = function (arg_2_0, arg_2_1)
	local var_2_0 = Managers.twitch:get_vote_data(arg_2_1)

	if not var_2_0 then
		return
	end

	if var_2_0.vote_type == "standard_vote" then
		arg_2_0:start_standard_vote(var_2_0.vote_templates[1], var_2_0.vote_templates[2], var_2_0.option_strings, arg_2_1)
	elseif var_2_0.vote_type == "multiple_choice" then
		arg_2_0:start_multiple_choice_vote(var_2_0.vote_templates[1], var_2_0.option_strings, arg_2_1)
	end
end

TwitchVoteUI.event_finish_vote_ui = function (arg_3_0, arg_3_1, arg_3_2)
	local var_3_0 = Managers.twitch:get_vote_data(arg_3_1)

	if not var_3_0 then
		return
	end

	local var_3_1 = var_3_0.vote_templates[arg_3_2]
	local var_3_2 = var_3_0.vote_type
	local var_3_3 = arg_3_0._active_vote
	local var_3_4 = TwitchVoteTemplates[var_3_1]

	arg_3_0._vote_result = {
		vote_key = arg_3_1,
		winning_index = arg_3_2,
		winning_template_name = var_3_1,
		vote_template = var_3_4
	}

	if var_3_2 == "standard_vote" then
		arg_3_0:show_ui("standard_vote_result")
	elseif var_3_2 == "multiple_choice" then
		arg_3_0:show_ui("multiple_choice_result")
	end

	Application.error("[TwitchVoteUI] event_finish_vote_ui")
end

TwitchVoteUI.event_reset_vote_ui = function (arg_4_0, arg_4_1)
	if arg_4_1 then
		if arg_4_0._active_vote and arg_4_0._active_vote.vote_key == arg_4_1 then
			arg_4_0._active_vote = nil
			arg_4_0._vote_widget = nil
		end

		for iter_4_0, iter_4_1 in ipairs(arg_4_0._votes) do
			if iter_4_1.vote_key == arg_4_1 then
				table.remove(arg_4_0._votes, iter_4_0)

				break
			end
		end

		print("RESET: Removed Active vote with key")
	else
		arg_4_0._votes = {}
		arg_4_0.active = false
		arg_4_0._active_vote = nil
		arg_4_0._vote_widget = nil

		print("RESET: Removed Active vote")
	end
end

TwitchVoteUI.start_standard_vote = function (arg_5_0, arg_5_1, arg_5_2, arg_5_3, arg_5_4)
	local var_5_0 = TwitchVoteTemplates[arg_5_1]

	fassert(var_5_0, "[TwitchVoteUI] Could not find any vote template for %s", arg_5_1)

	local var_5_1 = TwitchVoteTemplates[arg_5_2]

	fassert(var_5_1, "[TwitchVoteUI] Could not find any vote template for %s", arg_5_2)

	local var_5_2 = Managers.twitch:get_vote_data(arg_5_4)

	arg_5_0._active_vote, arg_5_0.active = {
		vote_type = "standard_vote",
		vote_template_a = table.clone(var_5_0),
		vote_template_b = table.clone(var_5_1),
		inputs = arg_5_3 or {
			"#a",
			"#b"
		},
		vote_key = arg_5_4,
		timer = var_5_2.timer
	}, true

	arg_5_0:show_ui("standard_vote")
end

TwitchVoteUI.start_multiple_choice_vote = function (arg_6_0, arg_6_1, arg_6_2, arg_6_3)
	local var_6_0 = TwitchVoteTemplates[arg_6_1]

	fassert(var_6_0, "[TwitchVoteUI] Could not find any vote template for %s", arg_6_1)
	print("added multiple choice vote")

	local var_6_1 = Managers.twitch:get_vote_data(arg_6_3)

	arg_6_0._active_vote, arg_6_0.active = {
		vote_type = "multiple_choice",
		vote_template = table.clone(var_6_0),
		inputs = arg_6_2 or {
			"#a",
			"#b",
			"#c",
			"#d",
			"#e"
		},
		vote_key = arg_6_3,
		timer = var_6_1.timer
	}, true

	arg_6_0:show_ui("multiple_choice_vote")
end

TwitchVoteUI.set_visible = function (arg_7_0, arg_7_1)
	arg_7_0._visible = arg_7_1
end

TwitchVoteUI._create_elements = function (arg_8_0)
	local var_8_0 = var_0_0.scenegraph_definition

	arg_8_0._ui_scenegraph = UISceneGraph.init_scenegraph(var_8_0)
	arg_8_0._widgets = {}
	arg_8_0._vote_count = {
		0,
		0,
		0,
		0,
		0
	}
	arg_8_0._vote_icon_count = 0
	arg_8_0._vote_widget = nil

	UIRenderer.clear_scenegraph_queue(arg_8_0._ui_renderer)
end

local var_0_7 = {
	root_scenegraph_id = "pivot",
	label = "Twitch",
	registry_key = "twitch",
	drag_scenegraph_id = "pivot_dragger"
}

TwitchVoteUI.update = function (arg_9_0, arg_9_1, arg_9_2)
	HudCustomizer.run(arg_9_0._ui_renderer, arg_9_0._ui_scenegraph, var_0_7)

	if not arg_9_0.active then
		return
	end

	if var_0_4 and arg_9_0._active_vote then
		for iter_9_0 = 1, 5 do
			Debug.text("                               Vote Percentages: " .. arg_9_0._active_vote.vote_percentages[iter_9_0])
		end
	end

	arg_9_0:_update_transition(arg_9_1)
	arg_9_0:_draw(arg_9_1, arg_9_2)
	arg_9_0:_update_active_vote(arg_9_1, arg_9_2)

	local var_9_0 = arg_9_0._ui

	if var_9_0 == "multiple_choice_vote" then
		arg_9_0:_update_multiple_votes_ui(arg_9_1)
	elseif var_9_0 == "standard_vote" then
		arg_9_0:_update_standard_vote(arg_9_1)
	elseif var_9_0 == "multiple_choice_result" or var_9_0 == "standard_vote_result" then
		arg_9_0:_update_result(arg_9_1)
	end
end

TwitchVoteUI._update_transition = function (arg_10_0, arg_10_1)
	if arg_10_0._fade_out then
		local var_10_0 = 1
		local var_10_1 = arg_10_0._render_settings
		local var_10_2 = math.clamp(var_10_1.alpha_multiplier - arg_10_1 * var_10_0, 0, 1)

		var_10_1.alpha_multiplier = var_10_2

		if var_10_2 == 0 then
			arg_10_0._ui = nil
			arg_10_0._fade_out = nil

			if arg_10_0._next_ui then
				arg_10_0:_show_next_ui()
			else
				arg_10_0.active = false
			end
		end

		return
	end

	if arg_10_0._fade_in then
		local var_10_3 = 5
		local var_10_4 = arg_10_0._render_settings
		local var_10_5 = math.clamp(var_10_4.alpha_multiplier + arg_10_1 * var_10_3, 0, 1)

		var_10_4.alpha_multiplier = var_10_5

		if var_10_5 == 1 then
			arg_10_0._fade_in = nil
		end

		return
	end
end

TwitchVoteUI.show_ui = function (arg_11_0, arg_11_1)
	arg_11_0._next_ui = arg_11_1

	if arg_11_0._ui then
		arg_11_0._fade_out = true
	else
		arg_11_0:_show_next_ui()
	end
end

TwitchVoteUI.hide_ui = function (arg_12_0)
	arg_12_0._fade_out = true
end

TwitchVoteUI._show_next_ui = function (arg_13_0)
	local var_13_0 = arg_13_0._next_ui

	if var_13_0 == "multiple_choice_vote" then
		arg_13_0:_show_multiple_choice_vote()
	elseif var_13_0 == "multiple_choice_result" then
		arg_13_0:_show_multiple_choice_result()
	elseif var_13_0 == "standard_vote" then
		arg_13_0:_show_standard_vote()
	elseif var_13_0 == "standard_vote_result" then
		arg_13_0:_show_standard_vote_result()
	end

	arg_13_0._ui = var_13_0
	arg_13_0._fade_in = true
	arg_13_0._next_ui = nil
end

TwitchVoteUI._create_vote_icon = function (arg_14_0, arg_14_1)
	if arg_14_0._ui_animations.animate_in or table.size(arg_14_0._widgets) >= 50 or not arg_14_0._vote_widget then
		return
	end

	local var_14_0 = var_0_0.scenegraph_definition
	local var_14_1 = "vote_icon_" .. arg_14_0._vote_icon_count
	local var_14_2 = arg_14_0._vote_widget.content
	local var_14_3 = arg_14_0._vote_widget.style
	local var_14_4 = var_14_2.icon_texture_func(var_14_2, var_14_3, arg_14_1)
	local var_14_5 = var_14_2.icon_offset_func(var_14_2, var_14_3, arg_14_1)

	var_14_0[var_14_1] = {
		parent = "vote_icon",
		position = {
			var_14_5,
			0,
			0
		}
	}
	arg_14_0._widgets[var_14_1] = UIWidget.init(UIWidgets.create_simple_texture(var_14_4, var_14_1))

	local var_14_6 = arg_14_0._widgets[var_14_1]

	arg_14_0._ui_animations[var_14_1 .. "_offset_y"] = UIAnimation.init(UIAnimation.function_by_time_with_offset, var_14_6.style.texture_id.offset, 2, 0, Math.random(100, 200), 3, math.random(0, 10), math.easeOutCubic)
	arg_14_0._ui_animations[var_14_1 .. "_offset_x"] = UIAnimation.init(UIAnimation.function_by_time_with_offset, var_14_6.style.texture_id.offset, 1, 0, 1, 3, math.random(0, 10), altered_sin)
	arg_14_0._ui_animations[var_14_1 .. "_color"] = UIAnimation.init(UIAnimation.function_by_time_with_offset, var_14_6.style.texture_id.color, 1, 255, 0, 3.2, math.random(0, 10), math.ease_exp)
	arg_14_0._animation_callbacks[var_14_1 .. "_color"] = callback(arg_14_0, "cb_destroy_vote_icon", var_14_1)
	arg_14_0._vote_icon_count = arg_14_0._vote_icon_count + 1
	arg_14_0._ui_scenegraph = UISceneGraph.init_scenegraph(var_14_0)
end

TwitchVoteUI.cb_destroy_vote_icon = function (arg_15_0, arg_15_1)
	arg_15_0._widgets[arg_15_1] = nil
end

TwitchVoteUI._update_active_vote = function (arg_16_0, arg_16_1, arg_16_2)
	if not arg_16_0._active_vote or arg_16_0._active_vote.completed then
		return
	end

	local var_16_0 = arg_16_0._active_vote.vote_key
	local var_16_1 = Managers.twitch:get_vote_data(var_16_0)

	if not var_16_1 then
		Application.error("[TwitchVoteUI] There is no vote data for key (" .. var_16_0 .. ")")

		arg_16_0._active_vote = nil
		arg_16_0._vote_widget = nil

		table.remove(arg_16_0._votes, 1)

		return
	end

	local var_16_2 = var_16_1.options

	arg_16_0._vote_count = arg_16_0._vote_count or {
		0,
		0,
		0,
		0,
		0
	}

	local var_16_3 = var_16_2[1] - arg_16_0._vote_count[1]
	local var_16_4 = var_16_2[2] - arg_16_0._vote_count[2]
	local var_16_5 = var_16_2[3] - arg_16_0._vote_count[3]
	local var_16_6 = var_16_2[4] - arg_16_0._vote_count[4]
	local var_16_7 = var_16_2[5] - arg_16_0._vote_count[5]

	if var_16_3 > 0 then
		for iter_16_0 = 1, var_16_3 do
			arg_16_0:_create_vote_icon(1)
		end
	end

	if var_16_4 > 0 then
		for iter_16_1 = 1, var_16_4 do
			arg_16_0:_create_vote_icon(2)
		end
	end

	if var_16_5 > 0 then
		for iter_16_2 = 1, var_16_5 do
			arg_16_0:_create_vote_icon(3)
		end
	end

	if var_16_6 > 0 then
		for iter_16_3 = 1, var_16_6 do
			arg_16_0:_create_vote_icon(4)
		end
	end

	if var_16_7 > 0 then
		for iter_16_4 = 1, var_16_7 do
			arg_16_0:_create_vote_icon(5)
		end
	end

	local var_16_8 = 0

	for iter_16_5 = 1, 5 do
		arg_16_0._vote_count[iter_16_5] = var_16_2[iter_16_5]
		var_16_8 = var_16_8 + var_16_2[iter_16_5]
	end

	local var_16_9 = {}

	for iter_16_6 = 1, 5 do
		var_16_9[iter_16_6] = var_16_8 > 0 and var_16_2[iter_16_6] / var_16_8 or 0
	end

	arg_16_0._active_vote.vote_percentages = arg_16_0._active_vote.vote_percentages or {
		0,
		0,
		0,
		0,
		0
	}

	for iter_16_7 = 1, 5 do
		arg_16_0._active_vote.vote_percentages[iter_16_7] = math.lerp(arg_16_0._active_vote.vote_percentages[iter_16_7] or 0, var_16_9[iter_16_7], arg_16_1 * 2)
	end

	if var_0_4 then
		Debug.text("                                " .. arg_16_0._vote_count[1])
		Debug.text("                                " .. arg_16_0._vote_count[2])
		Debug.text("                                " .. arg_16_0._vote_count[3])
		Debug.text("                                " .. arg_16_0._vote_count[4])
		Debug.text("                                " .. arg_16_0._vote_count[5])
	end

	arg_16_0._active_vote.timer = var_16_1.timer
	arg_16_0._active_vote.options = var_16_2
	arg_16_0._vote_activated = var_16_1.activated
end

TwitchVoteUI._draw = function (arg_17_0, arg_17_1, arg_17_2)
	local var_17_0 = arg_17_0._ui_renderer
	local var_17_1 = arg_17_0._ui_scenegraph
	local var_17_2 = arg_17_0._input_manager:get_service("ingame_menu")
	local var_17_3 = arg_17_0._render_settings

	UIRenderer.begin_pass(var_17_0, var_17_1, var_17_2, arg_17_1, nil, var_17_3)

	if arg_17_0._ui then
		for iter_17_0, iter_17_1 in pairs(arg_17_0._widgets) do
			UIRenderer.draw_widget(var_17_0, iter_17_1)
		end
	end

	UIRenderer.end_pass(var_17_0)
end

TwitchVoteUI.destroy = function (arg_18_0)
	Managers.state.event:unregister("add_vote_ui", arg_18_0)
	Managers.state.event:unregister("finish_vote_ui", arg_18_0)
	Managers.state.event:unregister("reset_vote_ui", arg_18_0)
end

TwitchVoteUI._show_multiple_choice_vote = function (arg_19_0)
	local var_19_0 = arg_19_0._active_vote

	if not var_19_0 then
		return
	end

	arg_19_0._widgets = {}

	local var_19_1 = var_0_0.widgets.multiple_choice

	for iter_19_0, iter_19_1 in pairs(var_19_1) do
		arg_19_0._widgets[iter_19_0] = UIWidget.init(iter_19_1)
	end

	local var_19_2 = arg_19_0:_sorted_player_list()
	local var_19_3 = var_19_0.inputs

	for iter_19_2, iter_19_3 in pairs(var_19_2) do
		repeat
			local var_19_4 = iter_19_3:profile_index()
			local var_19_5 = SPProfiles[var_19_4]

			if var_19_5 and iter_19_2 <= PlayerManager.MAX_PLAYERS then
				local var_19_6 = "hero_" .. iter_19_2
				local var_19_7 = arg_19_0._widgets[var_19_6]

				if var_19_7 then
					local var_19_8 = iter_19_3:career_index()
					local var_19_9 = var_19_5.careers[var_19_8]
					local var_19_10 = var_19_9.portrait_image .. "_twitch"
					local var_19_11 = var_19_9.portrait_image .. "_masked"
					local var_19_12 = var_19_7.content

					var_19_12.portrait = var_19_10
					var_19_12.masked_portrait = var_19_11
					var_19_12.profile_index = var_19_4

					local var_19_13 = "hero_vote_" .. iter_19_2

					arg_19_0._widgets[var_19_13].content.text = var_19_3[var_19_4]
				end
			end
		until true
	end

	local var_19_14 = arg_19_0._widgets.vote_icon
	local var_19_15 = var_19_0.vote_template
	local var_19_16 = var_19_15.texture_id

	var_19_14.content.texture_id = var_19_16

	local var_19_17 = arg_19_0._widgets.vote_text
	local var_19_18 = var_19_15.text

	var_19_17.content.text = var_19_18

	arg_19_0:_play_multiple_vote_start()
end

TwitchVoteUI._update_multiple_votes_ui = function (arg_20_0, arg_20_1)
	local var_20_0 = arg_20_0._active_vote

	if not var_20_0 then
		return
	end

	local var_20_1 = 0
	local var_20_2 = 0

	for iter_20_0 = 1, 4 do
		local var_20_3 = "hero_" .. iter_20_0
		local var_20_4 = arg_20_0._widgets[var_20_3]
		local var_20_5 = var_20_4.content.profile_index
		local var_20_6 = var_20_0.vote_percentages[var_20_5] or 0
		local var_20_7 = var_20_4.style
		local var_20_8 = var_20_7.mask.base_size[2] * var_20_6

		var_20_7.mask.texture_size[2] = var_20_8

		if var_20_1 < var_20_6 then
			var_20_2 = iter_20_0
			var_20_1 = var_20_6
		end
	end

	for iter_20_1 = 1, 4 do
		local var_20_9 = "hero_glow_" .. iter_20_1
		local var_20_10 = arg_20_0._widgets[var_20_9]
		local var_20_11 = iter_20_1 == var_20_2

		var_20_10.content.visible = var_20_11
	end

	local var_20_12 = var_20_0.timer
	local var_20_13 = math.abs(math.ceil(var_20_12))

	arg_20_0._widgets.timer.content.text = var_20_13

	arg_20_0:_play_timer_sfx(var_20_13)
end

TwitchVoteUI._show_multiple_choice_result = function (arg_21_0)
	arg_21_0._fade_out = false

	local var_21_0 = arg_21_0._vote_result

	assert(var_21_0)
	WwiseWorld.trigger_event(arg_21_0.wwise_world, "Play_twitch_vote_end")

	arg_21_0._widgets = {}

	local var_21_1 = var_0_0.widgets.multiple_choice_result

	for iter_21_0, iter_21_1 in pairs(var_21_1) do
		arg_21_0._widgets[iter_21_0] = UIWidget.init(iter_21_1)
	end

	local var_21_2 = arg_21_0._widgets.winner_text
	local var_21_3 = arg_21_0._widgets.winner_portrait
	local var_21_4 = var_21_0.winning_index

	print("winning_index", var_21_4)
	assert(var_21_4 > 0 and var_21_4 <= 5)

	local var_21_5 = Managers.player:human_and_bot_players()

	for iter_21_2, iter_21_3 in pairs(var_21_5) do
		local var_21_6 = iter_21_3:profile_index()

		if var_21_6 == var_21_4 then
			local var_21_7 = iter_21_3:name()

			var_21_2.content.text = var_21_7

			local var_21_8 = SPProfiles[var_21_6]
			local var_21_9 = iter_21_3:career_index()
			local var_21_10 = var_21_8.careers[var_21_9].portrait_image

			var_21_3.content.portrait = var_21_10
			var_21_3.content.visible = true
		end
	end

	local var_21_11 = var_21_0.vote_template

	if var_21_11 then
		local var_21_12 = arg_21_0._widgets.result_icon
		local var_21_13 = var_21_11.texture_id

		var_21_12.content.texture_id = var_21_13

		local var_21_14 = arg_21_0._widgets.result_text
		local var_21_15 = var_21_11.text

		var_21_14.content.text = var_21_15
	end

	arg_21_0._result_timer = var_0_5
end

TwitchVoteUI._update_result = function (arg_22_0, arg_22_1)
	arg_22_0._result_timer = arg_22_0._result_timer - arg_22_1

	if arg_22_0._result_timer > 0 then
		return
	end

	arg_22_0:hide_ui()
end

TwitchVoteUI._show_standard_vote = function (arg_23_0)
	local var_23_0 = arg_23_0._active_vote

	if not var_23_0 then
		return
	end

	arg_23_0._widgets = {}

	local var_23_1 = var_0_0.widgets.standard_vote

	for iter_23_0, iter_23_1 in pairs(var_23_1) do
		arg_23_0._widgets[iter_23_0] = UIWidget.init(iter_23_1)
	end

	local var_23_2 = var_23_0.vote_template_a
	local var_23_3 = var_23_0.vote_template_b
	local var_23_4 = arg_23_0._widgets.vote_icon_a
	local var_23_5 = var_23_2.texture_id
	local var_23_6 = true

	var_23_4.content.texture_id = var_23_5

	local var_23_7 = arg_23_0._widgets.vote_icon_b
	local var_23_8 = var_23_3.texture_id
	local var_23_9 = true

	var_23_7.content.texture_id = var_23_8
	arg_23_0._widgets.vote_icon_rect_a.content.visible = var_23_6
	arg_23_0._widgets.vote_icon_rect_b.content.visible = var_23_9
	arg_23_0._widgets.vote_text_a.content.text = var_23_2.text
	arg_23_0._widgets.vote_text_b.content.text = var_23_3.text

	arg_23_0:_play_standard_vote_start()
end

TwitchVoteUI._update_standard_vote = function (arg_24_0)
	local var_24_0 = arg_24_0._active_vote

	if not var_24_0 then
		return
	end

	local var_24_1 = var_24_0.timer
	local var_24_2 = math.abs(math.ceil(var_24_1))
	local var_24_3 = arg_24_0._widgets.timer

	if not var_24_3 then
		table.dump(arg_24_0._widgets, "### TWITCH VOTE UI CRASH INFO ###", 3)

		return
	end

	var_24_3.content.text = var_24_2

	arg_24_0:_play_timer_sfx(var_24_2)

	local var_24_4 = var_24_0.vote_percentages
	local var_24_5 = var_24_4[1]
	local var_24_6 = var_24_4[2]
	local var_24_7 = var_0_1.result_a_bar.size

	arg_24_0._ui_scenegraph.result_a_bar.size[1] = math.ceil(var_24_7[1] * var_24_5)

	local var_24_8 = var_0_1.result_b_bar.size

	arg_24_0._ui_scenegraph.result_b_bar.size[1] = math.ceil(var_24_8[1] * var_24_6)
	arg_24_0._widgets.result_bar_a_eyes.content.visible = var_24_6 <= var_24_5
	arg_24_0._widgets.result_bar_b_eyes.content.visible = var_24_5 <= var_24_6
end

TwitchVoteUI._show_standard_vote_result = function (arg_25_0)
	arg_25_0._fade_out = false

	local var_25_0 = arg_25_0._vote_result

	assert(var_25_0)

	arg_25_0._widgets = {}

	local var_25_1 = var_0_0.widgets.standard_vote_result

	for iter_25_0, iter_25_1 in pairs(var_25_1) do
		arg_25_0._widgets[iter_25_0] = UIWidget.init(iter_25_1)
	end

	arg_25_0._result_timer = var_0_5

	local var_25_2 = var_25_0.winning_template_name

	assert(var_25_2)

	local var_25_3 = TwitchVoteTemplates[var_25_2]
	local var_25_4 = var_25_3.texture_id

	arg_25_0._widgets.result_icon.content.texture_id = var_25_4

	local var_25_5 = var_25_3.cost

	arg_25_0:_play_winning_sfx(var_25_5)

	local var_25_6 = arg_25_0._widgets.result_icon
	local var_25_7 = var_25_3.texture_id

	var_25_6.content.texture_id = var_25_7

	local var_25_8 = true

	arg_25_0._widgets.result_icon_rect.content.visible = var_25_8

	local var_25_9 = arg_25_0._widgets.result_text
	local var_25_10 = var_25_3.text

	var_25_9.content.text = var_25_10

	local var_25_11 = arg_25_0._widgets.result_description_text

	if var_25_3.description then
		local var_25_12 = var_25_3.description

		var_25_11.content.text = var_25_12
	else
		var_25_11.content.visible = false
	end
end

TwitchVoteUI._sorted_player_list = function (arg_26_0)
	local var_26_0 = Managers.player:human_and_bot_players()
	local var_26_1 = {}

	for iter_26_0, iter_26_1 in pairs(var_26_0) do
		if iter_26_1:profile_index() then
			table.insert(var_26_1, iter_26_1)
		end
	end

	local function var_26_2(arg_27_0, arg_27_1)
		return arg_27_0:profile_index() < arg_27_1:profile_index()
	end

	table.sort(var_26_1, var_26_2)

	return var_26_1
end

TwitchVoteUI._play_winning_sfx = function (arg_28_0, arg_28_1)
	if arg_28_1 == nil then
		return
	end

	if arg_28_1 <= 0 then
		WwiseWorld.trigger_event(arg_28_0.wwise_world, "Play_twitch_vote_end")
	else
		WwiseWorld.trigger_event(arg_28_0.wwise_world, "Play_twitch_vote_evil_won")
	end
end

TwitchVoteUI._play_timer_sfx = function (arg_29_0, arg_29_1)
	if arg_29_1 <= var_0_6 and arg_29_1 ~= arg_29_0._last_played_countdown_sfx then
		WwiseWorld.trigger_event(arg_29_0.wwise_world, "Play_twitch_count")

		arg_29_0._last_played_countdown_sfx = arg_29_1
	end
end

TwitchVoteUI._play_multiple_vote_start = function (arg_30_0)
	WwiseWorld.trigger_event(arg_30_0.wwise_world, "Play_twitch_vote_multiple_start")
end

TwitchVoteUI._play_standard_vote_start = function (arg_31_0)
	WwiseWorld.trigger_event(arg_31_0.wwise_world, "Play_twitch_vote_standard_buff_start")
end
