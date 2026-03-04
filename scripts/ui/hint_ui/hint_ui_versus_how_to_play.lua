-- chunkname: @scripts/ui/hint_ui/hint_ui_versus_how_to_play.lua

require("scripts/ui/hint_ui/hint_ui")

HintUIVersusHowToPlay = class(HintUIVersusHowToPlay, HintUI)

function HintUIVersusHowToPlay.init(arg_1_0, arg_1_1, arg_1_2, arg_1_3)
	HintUIVersusHowToPlay.super.init(arg_1_0, arg_1_1, arg_1_2, arg_1_3)

	arg_1_0._shown = false
	arg_1_0._duration = arg_1_0._hint_data.duration
	arg_1_0._gamepad_active = Managers.input:is_device_active("gamepad")
end

function HintUIVersusHowToPlay.create_ui_elements(arg_2_0)
	local var_2_0 = arg_2_0._hint_settings.data

	var_2_0.definitions.widget_definitions.hint_widgets = UIWidgets.create_versus_gameplay_hint_widget("hint_anchor", var_2_0)

	HintUIVersusHowToPlay.super.create_ui_elements(arg_2_0)
end

function HintUIVersusHowToPlay.update(arg_3_0, arg_3_1, arg_3_2)
	if arg_3_0._shown then
		return
	end

	if arg_3_0._duration and not arg_3_0._shown and not arg_3_0._start_t then
		arg_3_0._start_t = arg_3_2

		arg_3_0:start_animation("enter", arg_3_0._widgets_by_name.hint_widgets)
	end

	if arg_3_0._duration and arg_3_2 <= arg_3_0._start_t + arg_3_0._duration then
		local var_3_0 = arg_3_0._widgets_by_name.hint_widgets
		local var_3_1 = var_3_0.content

		if var_3_1.duration_bar then
			local var_3_2 = var_3_1.duration_bar.uvs
			local var_3_3 = arg_3_0._duration
			local var_3_4 = 1 - (arg_3_0._start_t + arg_3_0._duration - arg_3_2) / var_3_3

			var_3_2[2][1] = var_3_4
			var_3_0.style.duration_bar.texture_size[1] = 400 * var_3_4
		end
	end

	if arg_3_0._hint_data.input_data then
		arg_3_0:_update_input(arg_3_1, arg_3_2, arg_3_0._hint_data.input_data)
	end

	HintUIVersusHowToPlay.super.update(arg_3_0, arg_3_1, arg_3_2)

	if arg_3_0._start_t then
		if arg_3_2 > arg_3_0._start_t + arg_3_0._duration and not arg_3_0._is_exiting then
			local var_3_5 = {
				wwise_world = arg_3_0._wwise_world,
				render_settings = arg_3_0._render_settings,
				self = arg_3_0
			}

			arg_3_0:start_animation("exit", arg_3_0._widgets_by_name.hint_widgets, var_3_5)

			arg_3_0._is_exiting = true
		end

		if arg_3_0:should_show() and not arg_3_0._has_widget_been_closed then
			arg_3_0:show()
		end
	end
end

function HintUIVersusHowToPlay.show(arg_4_0)
	HintUIVersusHowToPlay.super.show(arg_4_0)
	arg_4_0:_set_hint_widget_size()
end

function HintUIVersusHowToPlay._set_hint_widget_size(arg_5_0)
	local var_5_0 = arg_5_0._widgets_by_name.hint_widgets
	local var_5_1 = var_5_0.content
	local var_5_2 = var_5_0.style
	local var_5_3 = var_5_2.title_text
	local var_5_4 = var_5_2.body_text
	local var_5_5 = UIUtils.get_text_height(arg_5_0._ui_top_renderer, var_5_3.size, var_5_3, var_5_1.title_text)
	local var_5_6, var_5_7 = UIUtils.get_text_height(arg_5_0._ui_top_renderer, var_5_4.size, var_5_4, var_5_1.body_text)
	local var_5_8 = var_5_5 + var_5_6 + var_5_7 * 2 + 10

	if arg_5_0._duration then
		var_5_8 = var_5_8 + 8
	end

	if arg_5_0._hint_data.foot_text then
		local var_5_9 = var_5_2.foot_text
		local var_5_10, var_5_11 = UIUtils.get_text_height(arg_5_0._ui_top_renderer, var_5_9.size, var_5_9, var_5_1.foot_text)

		var_5_8 = var_5_8 + var_5_10 + var_5_11 * 2
	end

	if arg_5_0._hint_data.icon then
		var_5_8 = var_5_8 + var_5_2.foot_icon.texture_size[2] / 2 - 5
	end

	var_5_1.size[2] = var_5_8
	var_5_0.offset[2] = -(var_5_8 / 2)
end

function HintUIVersusHowToPlay._update_input(arg_6_0, arg_6_1, arg_6_2, arg_6_3)
	if not arg_6_3.input_action then
		return
	end

	local var_6_0 = Managers.input:is_device_active("gamepad")

	if arg_6_0._gamepad_active ~= var_6_0 then
		arg_6_0._gamepad_active = var_6_0

		local var_6_1 = arg_6_3.input_action

		var_6_1 = var_6_1 and (var_6_0 and arg_6_3.gamepad_action or var_6_1)

		local var_6_2 = "$KEY;" .. arg_6_3.input_service_name .. "__" .. var_6_1 .. ":"
		local var_6_3 = string.format(Localize(arg_6_0._hint_data.foot_text), var_6_2)

		arg_6_0._widgets_by_name.hint_widgets.content.foot_text = var_6_3
	end
end

function HintUIVersusHowToPlay.hide(arg_7_0)
	arg_7_0._shown = true
	arg_7_0._has_widget_been_closed = true
	arg_7_0._exit_anim_id = nil

	HintUIVersusHowToPlay.super.hide(arg_7_0)
end
