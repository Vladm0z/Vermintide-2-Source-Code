-- chunkname: @scripts/ui/views/ingame_voting_ui.lua

local var_0_0 = local_require("scripts/ui/views/ingame_voting_ui_definitions")

IngameVotingUI = class(IngameVotingUI)

function IngameVotingUI.init(arg_1_0, arg_1_1, arg_1_2)
	arg_1_0._parent = arg_1_1
	arg_1_0.ui_renderer = arg_1_2.ui_renderer
	arg_1_0.ui_top_renderer = arg_1_2.ui_top_renderer
	arg_1_0.ingame_ui = arg_1_2.ingame_ui
	arg_1_0.input_manager = arg_1_2.input_manager
	arg_1_0.voting_manager = arg_1_2.voting_manager
	arg_1_0.platform = PLATFORM
	arg_1_0.world_manager = arg_1_2.world_manager

	local var_1_0 = arg_1_0.world_manager:world("level_world")

	arg_1_0.wwise_world = Managers.world:wwise_world(var_1_0)
	arg_1_0.peer_id = Network.peer_id()

	arg_1_0:create_ui_elements()
end

local var_0_1 = false

function IngameVotingUI.create_ui_elements(arg_2_0)
	arg_2_0.ui_scenegraph = UISceneGraph.init_scenegraph(var_0_0.scenegraph_definition)
	arg_2_0.scenegraph_definition = var_0_0.scenegraph_definition

	local var_2_0 = var_0_0.widget_definitions

	arg_2_0.background = UIWidget.init(var_2_0.background)
	arg_2_0.option_yes = UIWidget.init(var_2_0.option_yes)
	arg_2_0.option_no = UIWidget.init(var_2_0.option_no)
	var_0_1 = false
end

function IngameVotingUI.destroy(arg_3_0)
	arg_3_0.voting_manager:allow_vote_input(false)

	arg_3_0.voting_manager = nil
end

function IngameVotingUI.get_text_width(arg_4_0, arg_4_1, arg_4_2)
	local var_4_0 = UIFontByResolution(arg_4_2)
	local var_4_1 = arg_4_2.font_size
	local var_4_2, var_4_3 = UIRenderer.text_size(arg_4_0.ui_top_renderer, arg_4_1, var_4_0[1], var_4_1)

	return var_4_2
end

function IngameVotingUI.setup_option_input(arg_5_0, arg_5_1, arg_5_2, arg_5_3)
	local var_5_0 = 0
	local var_5_1 = arg_5_2.text
	local var_5_2 = arg_5_2.input
	local var_5_3 = arg_5_0.input_manager
	local var_5_4 = var_5_3:get_service("ingame_menu")
	local var_5_5 = var_5_3:is_device_active("gamepad")
	local var_5_6, var_5_7 = UISettings.get_gamepad_input_texture_data(var_5_4, var_5_2, var_5_5)

	if not var_5_5 then
		var_5_6 = nil
	end

	arg_5_1.content.input_text = var_5_6 and "" or sprintf("[%s]", var_5_7)
	arg_5_1.content.input_icon = var_5_6 and var_5_6.texture or nil

	local var_5_8 = Localize(var_5_1)

	arg_5_1.content.option_text = var_5_8

	local var_5_9 = arg_5_1.style.option_text
	local var_5_10 = arg_5_1.style.option_text_shadow
	local var_5_11 = var_5_0 + arg_5_0:get_text_width(var_5_8, var_5_9)

	if var_5_6 then
		local var_5_12 = arg_5_1.style.input_icon.scenegraph_id
		local var_5_13 = arg_5_0.ui_scenegraph[var_5_12]
		local var_5_14 = var_5_13.size
		local var_5_15 = var_5_13.local_position

		var_5_14[1] = var_5_6.size[1]
		var_5_14[2] = var_5_6.size[2]
		var_5_15[1] = -var_5_11 / 2
		var_5_9.offset[1] = var_5_14[1] / 2
		var_5_10.offset[1] = var_5_14[1] / 2 + 2
		var_5_11 = var_5_11 + var_5_14[1]
	else
		local var_5_16 = arg_5_1.style.input_text
		local var_5_17 = arg_5_1.style.input_text_shadow
		local var_5_18 = arg_5_0:get_text_width(arg_5_1.content.input_text, var_5_16)

		var_5_16.offset[1] = -var_5_11 / 2
		var_5_17.offset[1] = -var_5_11 / 2 + 2
		var_5_9.offset[1] = var_5_18 / 2
		var_5_10.offset[1] = var_5_18 / 2 + 2
		var_5_11 = var_5_11 + var_5_18
	end

	local var_5_19 = arg_5_1.content.left_side
	local var_5_20 = arg_5_1.scenegraph_id
	local var_5_21 = math.max(var_5_11 / 2 + 10, 50)

	arg_5_0.ui_scenegraph[var_5_20].local_position[1] = var_5_19 and -var_5_21 or var_5_21
end

function IngameVotingUI.align_option_inputs(arg_6_0)
	return
end

function IngameVotingUI.start_vote(arg_7_0, arg_7_1)
	arg_7_0:clear_input_progress()

	local var_7_0 = arg_7_1.template
	local var_7_1 = var_7_0.text

	if var_7_0.modify_title_text then
		var_7_1 = var_7_0.modify_title_text(Localize(var_7_1), arg_7_1.data)
	end

	arg_7_0.background.content.info_text = var_7_1
	arg_7_0.voters = {}
	arg_7_0.vote_results = {
		[1] = 0,
		[2] = 0
	}
	arg_7_0.vote_started = true
	arg_7_0.has_voted = false

	local var_7_2 = arg_7_0.input_manager:is_device_active("gamepad")

	if var_7_2 then
		arg_7_0:on_gamepad_activated(arg_7_1)
	else
		local var_7_3 = var_7_0.vote_options

		arg_7_0:setup_option_input(arg_7_0.option_yes, var_7_3[1], var_7_2)
		arg_7_0:setup_option_input(arg_7_0.option_no, var_7_3[2], var_7_2)
	end

	arg_7_0.option_yes.content.has_voted = false
	arg_7_0.option_no.content.has_voted = false
	arg_7_0.background.content.has_voted = false
	arg_7_0.option_yes.content.result_text = tostring(0)
	arg_7_0.option_no.content.result_text = tostring(0)
	arg_7_0.gamepad_active = arg_7_0.input_manager:is_device_active("gamepad")
	arg_7_0.is_minimized = RESOLUTION_LOOKUP.minimized
	arg_7_0.vote_successful = nil

	arg_7_0:play_sound("play_gui_ban_popup")
	arg_7_0:update_can_vote(not arg_7_0.menu_active)
end

function IngameVotingUI.update_vote(arg_8_0, arg_8_1)
	local var_8_0 = arg_8_0.result_boxes
	local var_8_1 = arg_8_0.voters

	for iter_8_0, iter_8_1 in pairs(arg_8_1) do
		if not var_8_1[iter_8_0] then
			var_8_1[iter_8_0] = iter_8_0
			arg_8_0.vote_results[iter_8_1] = arg_8_0.vote_results[iter_8_1] + 1

			local var_8_2 = iter_8_0 == arg_8_0.peer_id

			if var_8_2 then
				arg_8_0.has_voted = true
				arg_8_0.option_yes.content.has_voted = true
				arg_8_0.option_no.content.has_voted = true
				arg_8_0.background.content.has_voted = true

				arg_8_0.voting_manager:allow_vote_input(false)
			end

			local var_8_3

			if iter_8_1 == 1 then
				var_8_3 = arg_8_0.option_yes

				arg_8_0:play_sound("play_gui_ban_vote_yes")
			elseif iter_8_1 == 2 then
				var_8_3 = arg_8_0.option_no

				arg_8_0:play_sound("play_gui_ban_vote_no")
			else
				error("You done wrong.")
			end

			var_8_3.content.result_text = tostring(arg_8_0.vote_results[iter_8_1])
			var_8_3.content.option_text = sprintf("[%s]", tostring(arg_8_0.vote_results[iter_8_1]))

			if arg_8_0.has_voted and var_8_2 then
				arg_8_0:animate_option_get_vote(var_8_3)
			end
		end
	end

	local var_8_4 = arg_8_0.voting_manager:vote_time_left()
	local var_8_5 = var_8_4 and string.format(" %02d:%02d", math.floor(var_8_4 / 60), var_8_4 % 60) or "00:00"

	arg_8_0.background.content.time_text = var_8_5
end

function IngameVotingUI.start_finish(arg_9_0, arg_9_1, arg_9_2)
	arg_9_0:clear_input_progress()

	arg_9_0.on_finish = true
	arg_9_0.finish_time = arg_9_2 + 2
	arg_9_0.finish_anim_t = 0

	local var_9_0

	if arg_9_1.vote_result == 1 then
		var_9_0 = arg_9_0.option_yes
		arg_9_0.vote_successful = true
	elseif arg_9_1.vote_result == 2 or arg_9_1.vote_result == 0 then
		var_9_0 = arg_9_0.option_no
	else
		error("Sillybillywilly")
	end

	arg_9_0.finish_option = var_9_0

	arg_9_0:animate_option_get_vote(arg_9_0.finish_option)

	arg_9_0.option_yes.content.has_voted = true
	arg_9_0.option_no.content.has_voted = true
	arg_9_0.background.content.has_voted = true

	arg_9_0.voting_manager:allow_vote_input(false)
	arg_9_0:update_can_vote(false)

	arg_9_0.menu_active = nil
end

function IngameVotingUI.stop_finish(arg_10_0)
	arg_10_0.option_no.style.result_text.text_color[1] = 255
	arg_10_0.option_yes.style.result_text.text_color[1] = 255
	arg_10_0.finish_option = nil
	arg_10_0.on_finish = nil

	if arg_10_0.vote_successful then
		arg_10_0:play_sound("play_gui_ban_player_banned")

		arg_10_0.vote_successful = nil
	end
end

function IngameVotingUI.update_finish(arg_11_0, arg_11_1, arg_11_2)
	if arg_11_2 >= arg_11_0.finish_time then
		arg_11_0:stop_finish()
	else
		arg_11_0.finish_anim_t = arg_11_0.finish_anim_t + arg_11_1 * 8

		if math.sirp(0, 1, arg_11_0.finish_anim_t) > 0.5 then
			arg_11_0.finish_option.style.result_text.text_color[1] = 255
		else
			arg_11_0.finish_option.style.result_text.text_color[1] = 180
		end
	end
end

function IngameVotingUI.update(arg_12_0, arg_12_1, arg_12_2)
	local var_12_0 = arg_12_0._parent:parent().menu_active

	if var_0_1 then
		arg_12_0:create_ui_elements()

		arg_12_0.vote_started = false
	end

	local var_12_1 = false
	local var_12_2 = arg_12_0.voting_manager
	local var_12_3 = false

	if var_12_2:vote_in_progress() and var_12_2:is_ingame_vote() then
		if var_12_2:active_vote_data().kick_peer_id == arg_12_0.peer_id then
			return
		end

		if var_12_0 ~= arg_12_0.menu_active then
			arg_12_0.menu_active = var_12_0

			arg_12_0:update_can_vote(not var_12_0)
		end

		if not arg_12_0.vote_started then
			if arg_12_0.on_finish then
				arg_12_0:stop_finish()
			end

			arg_12_0:start_vote(var_12_2.active_voting)
		end

		var_12_3 = arg_12_0:update_input_progress(var_12_2.active_voting)

		arg_12_0:update_vote(var_12_2.active_voting.votes)

		if not arg_12_0.has_voted then
			local var_12_4 = false

			if arg_12_0.is_minimized and not RESOLUTION_LOOKUP.minimized then
				var_12_4 = true
			end

			local var_12_5 = arg_12_0.input_manager:is_device_active("gamepad")

			if arg_12_0.gamepad_active ~= var_12_5 then
				arg_12_0.gamepad_active = var_12_5
				var_12_4 = true
			end

			if var_12_4 then
				local var_12_6 = var_12_2.active_voting
				local var_12_7 = var_12_6 and var_12_6.template

				if var_12_7 then
					local var_12_8 = var_12_7.vote_options

					arg_12_0:setup_option_input(arg_12_0.option_yes, var_12_8[1])
					arg_12_0:setup_option_input(arg_12_0.option_no, var_12_8[2])

					arg_12_0.gamepad_active = var_12_5
				end
			end
		end

		var_12_1 = true
	elseif arg_12_0.vote_started then
		local var_12_9 = var_12_2:previous_vote_info()

		arg_12_0:start_finish(var_12_9, arg_12_2)

		arg_12_0.vote_started = nil
	end

	if arg_12_0.on_finish then
		arg_12_0:update_finish(arg_12_1, arg_12_2)

		var_12_1 = true
	end

	if var_12_1 and not arg_12_0.menu_active then
		if arg_12_0.input_manager:is_device_active("gamepad") then
			if not arg_12_0.gamepad_active_last_frame then
				arg_12_0.gamepad_active_last_frame = true

				arg_12_0:on_gamepad_activated(var_12_2.active_voting)
			end
		elseif arg_12_0.gamepad_active_last_frame then
			arg_12_0.gamepad_active_last_frame = false

			arg_12_0:on_gamepad_deactivated(var_12_2.active_voting)
		end

		arg_12_0:draw(arg_12_1, var_12_3)
	end
end

function IngameVotingUI.on_gamepad_activated(arg_13_0, arg_13_1)
	if not arg_13_0.has_voted then
		-- block empty
	end

	local var_13_0 = PLATFORM

	if IS_WINDOWS then
		var_13_0 = "xb1"
	end

	local var_13_1 = ButtonTextureByName("d_vertical", var_13_0).texture

	arg_13_0.background.content.gamepad_input_icon = var_13_1
	arg_13_0.background.content.gamepad_active = true

	if arg_13_1 then
		local var_13_2 = arg_13_1.template.vote_options

		arg_13_0:setup_option_input(arg_13_0.option_yes, var_13_2[1], true)
		arg_13_0:setup_option_input(arg_13_0.option_no, var_13_2[2], true)
	end
end

function IngameVotingUI.on_gamepad_deactivated(arg_14_0, arg_14_1)
	if not arg_14_0.has_voted then
		-- block empty
	end

	arg_14_0.background.content.gamepad_active = false

	if arg_14_1 then
		local var_14_0 = arg_14_1.template.vote_options

		arg_14_0:setup_option_input(arg_14_0.option_yes, var_14_0[1])
		arg_14_0:setup_option_input(arg_14_0.option_no, var_14_0[2])
	end
end

function IngameVotingUI.draw(arg_15_0, arg_15_1, arg_15_2)
	local var_15_0 = arg_15_0.ui_top_renderer
	local var_15_1 = arg_15_0.ui_scenegraph
	local var_15_2 = arg_15_0.input_manager:get_service("ingame_menu")

	arg_15_0:update_pulse_animations(arg_15_1, arg_15_2)
	UIRenderer.begin_pass(var_15_0, var_15_1, var_15_2, arg_15_1)
	UIRenderer.draw_widget(var_15_0, arg_15_0.background)
	UIRenderer.draw_widget(var_15_0, arg_15_0.option_yes)
	UIRenderer.draw_widget(var_15_0, arg_15_0.option_no)
	UIRenderer.end_pass(var_15_0)
end

function IngameVotingUI.update_pulse_animations(arg_16_0, arg_16_1, arg_16_2)
	if arg_16_0.has_voted then
		return
	end

	local var_16_0 = arg_16_0.menu_active
	local var_16_1 = var_16_0 and 8 or 5
	local var_16_2 = not var_16_0 and arg_16_2 and 0 or 0.5 + math.sin(Managers.time:time("ui") * var_16_1) * 0.5

	if not var_16_0 then
		local var_16_3 = 50 + var_16_2 * 50
	else
		local var_16_4 = 100 + var_16_2 * 155

		arg_16_0.background.style.input_glow.color[1] = var_16_4
	end
end

function IngameVotingUI.update_can_vote(arg_17_0, arg_17_1)
	arg_17_0.background.content.can_vote = arg_17_1
	arg_17_0.option_yes.content.can_vote = arg_17_1
	arg_17_0.option_no.content.can_vote = arg_17_1

	arg_17_0.voting_manager:allow_vote_input(arg_17_1)
end

local var_0_2 = math.easeCubic

function IngameVotingUI.animate_option_get_vote(arg_18_0, arg_18_1)
	local var_18_0 = 0.1
	local var_18_1 = 0.1
	local var_18_2 = var_18_0 + var_18_1
	local var_18_3 = var_18_0 / var_18_2
	local var_18_4 = var_18_1 / var_18_2

	local function var_18_5(arg_19_0)
		if arg_19_0 < var_18_3 then
			return var_0_2(arg_19_0 / var_18_3)
		elseif var_18_4 > 0 then
			return var_0_2((1 - arg_19_0) / var_18_4)
		else
			return 0
		end
	end

	local var_18_6 = 36
	local var_18_7 = 40
	local var_18_8 = arg_18_1.style.result_text
	local var_18_9 = arg_18_1.style.result_text_shadow
	local var_18_10 = "font_size"
	local var_18_11 = UIAnimation.init(UIAnimation.function_by_time, var_18_8, var_18_10, var_18_6, var_18_7, var_18_2, var_18_5)

	UIWidget.animate(arg_18_1, var_18_11)

	local var_18_12 = UIAnimation.init(UIAnimation.function_by_time, var_18_9, var_18_10, var_18_6, var_18_7, var_18_2, var_18_5)

	UIWidget.animate(arg_18_1, var_18_12)
end

function IngameVotingUI.update_input_progress(arg_20_0, arg_20_1)
	local var_20_0 = false
	local var_20_1 = arg_20_1.current_hold_input
	local var_20_2
	local var_20_3
	local var_20_4

	if var_20_1 == "ingame_vote_yes" then
		var_20_3 = arg_20_0.option_yes
		var_20_4 = arg_20_0.option_no
		var_20_2 = "left"
	elseif var_20_1 == "ingame_vote_no" then
		var_20_3 = arg_20_0.option_no
		var_20_4 = arg_20_0.option_yes
		var_20_2 = "right"
	end

	local var_20_5 = arg_20_1.input_hold_progress or 0
	local var_20_6 = math.smoothstep(var_20_5, 0, 1)

	if var_20_3 then
		local var_20_7 = var_20_3.style.bar
		local var_20_8 = var_20_7.default_width
		local var_20_9 = var_20_7.offset
		local var_20_10 = var_20_7.default_offset
		local var_20_11 = var_20_7.size

		if var_20_2 == "left" then
			var_20_11[1] = var_20_6 * var_20_8
			var_20_9[1] = var_20_10[1] + (var_20_8 - var_20_11[1])
		else
			var_20_11[1] = var_20_6 * var_20_8
		end

		var_20_0 = true
	end

	if var_20_4 then
		local var_20_12 = var_20_4.style.bar
		local var_20_13 = var_20_12.default_width
		local var_20_14 = var_20_12.offset
		local var_20_15 = var_20_12.default_offset
		local var_20_16 = var_20_12.size

		if var_20_2 == "left" then
			var_20_16[1] = 0
		else
			var_20_16[1] = 0
			var_20_14[1] = var_20_15[1]
		end

		var_20_0 = true
	end

	if not var_20_1 then
		arg_20_0.option_no.style.bar.size[1] = 0
		arg_20_0.option_yes.style.bar.size[1] = 0
		arg_20_0.option_yes.style.bar.offset[1] = arg_20_0.option_yes.style.bar.default_offset[1]
	end

	return var_20_0
end

function IngameVotingUI.clear_input_progress(arg_21_0)
	if arg_21_0.option_yes then
		local var_21_0 = arg_21_0.option_yes.style.bar
		local var_21_1 = arg_21_0.option_yes.style.bar_bg
		local var_21_2 = var_21_0.default_width
		local var_21_3 = var_21_0.offset
		local var_21_4 = var_21_0.default_offset

		var_21_0.size[1] = 0
		var_21_3[1] = var_21_4[1]
	end

	if arg_21_0.option_no then
		local var_21_5 = arg_21_0.option_no.style.bar
		local var_21_6 = arg_21_0.option_no.style.bar_bg
		local var_21_7 = var_21_5.default_width

		var_21_5.size[1] = 0
	end
end

function IngameVotingUI.play_sound(arg_22_0, arg_22_1)
	WwiseWorld.trigger_event(arg_22_0.wwise_world, arg_22_1)
end
