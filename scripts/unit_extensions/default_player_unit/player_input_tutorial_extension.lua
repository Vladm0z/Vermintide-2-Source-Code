-- chunkname: @scripts/unit_extensions/default_player_unit/player_input_tutorial_extension.lua

require("scripts/unit_extensions/generic/generic_state_machine")

local var_0_0 = IS_WINDOWS

PlayerInputTutorialExtension = class(PlayerInputTutorialExtension)

function PlayerInputTutorialExtension.get_window_is_in_focus()
	local var_1_0 = false

	if var_0_0 then
		if Window.has_focus() then
			var_1_0 = true
		end
	else
		var_1_0 = true
	end

	return var_1_0
end

function PlayerInputTutorialExtension.init(arg_2_0, arg_2_1, arg_2_2, arg_2_3)
	arg_2_0.unit = arg_2_2
	arg_2_0.player = arg_2_3.player
	arg_2_0.input_service = arg_2_0.player.input_source
	arg_2_0.enabled = true
	arg_2_0.has_released_input = false
	arg_2_0.input_buffer_timer = nil
	arg_2_0.buffer_key = nil
	arg_2_0.input_buffer = nil
	arg_2_0.name = "PlayerInputTutorialExtension"
	arg_2_0.new_input_buffer_timer = 0
	arg_2_0.new_input_buffer = nil
	arg_2_0.new_buffer_key = nil
	arg_2_0.last_added_buffer_time = 0
	arg_2_0.new_buffer_key_doubleclick_window = nil
	arg_2_0.input_buffer_reset = false
	arg_2_0.added_stun_buffer = false
	arg_2_0.wield_cooldown = false
	arg_2_0.wield_cooldown_timer = 0
	arg_2_0.wield_cooldown_timer_clock = 0
	arg_2_0.wield_scroll_value = nil
	arg_2_0.double_tap_timers = {}
	arg_2_0.allowed_table = {}
	arg_2_0.disallowed_table = {}
	arg_2_0.input_key_scale = {}
	arg_2_0._t = 0
	arg_2_0.minimum_dodge_input = 0.3
	arg_2_0.double_tap_dodge = Application.user_setting("double_tap_dodge")
	arg_2_0.toggle_crouch = Application.user_setting("toggle_crouch")
	arg_2_0.toggle_alternate_attack = Application.user_setting("toggle_alternate_attack")
	arg_2_0.priority_input = {
		wield_2 = true,
		wield_next = true,
		wield_5 = true,
		wield_prev = true,
		wield_scroll = true,
		wield_3 = true,
		wield_1 = true,
		wield_4 = true,
		wield_switch = true
	}
end

function PlayerInputTutorialExtension.destroy(arg_3_0)
	return
end

function PlayerInputTutorialExtension.reset(arg_4_0)
	return
end

function PlayerInputTutorialExtension.update(arg_5_0, arg_5_1, arg_5_2, arg_5_3, arg_5_4, arg_5_5)
	arg_5_0._t = arg_5_5

	if arg_5_0.input_buffer_reset then
		arg_5_0.last_added_buffer_time = arg_5_5
		arg_5_0.input_buffer_reset = false
	end

	if arg_5_0.new_input_buffer then
		if arg_5_5 > arg_5_0.last_added_buffer_time + (arg_5_0.new_buffer_key_doubleclick_window or 0.2) then
			arg_5_0.input_buffer_timer = arg_5_0.new_input_buffer_timer
			arg_5_0.input_buffer = arg_5_0.new_input_buffer
			arg_5_0.buffer_key = arg_5_0.new_buffer_key
			arg_5_0.last_added_buffer_time = arg_5_5
		end

		arg_5_0.new_input_buffer_timer = 0
		arg_5_0.new_input_buffer = nil
		arg_5_0.new_buffer_key = nil
	end

	if arg_5_0.input_buffer then
		arg_5_0.input_buffer_timer = arg_5_0.input_buffer_timer - arg_5_3

		if arg_5_0.input_buffer_timer <= 0 then
			arg_5_0.input_buffer_timer = 0
			arg_5_0.input_buffer = nil
			arg_5_0.buffer_key = nil
		end
	end

	if arg_5_0.wield_cooldown then
		if arg_5_5 > arg_5_0.wield_cooldown_timer then
			arg_5_0.wield_cooldown = false
			arg_5_0.wield_cooldown_timer_clock = 0
		else
			arg_5_0.wield_cooldown_timer_clock = arg_5_0.wield_cooldown_timer_clock + arg_5_3
		end
	end
end

function PlayerInputTutorialExtension.start_double_tap(arg_6_0, arg_6_1, arg_6_2)
	arg_6_0.double_tap_timers[arg_6_1] = arg_6_2
end

function PlayerInputTutorialExtension.clear_double_tap(arg_7_0, arg_7_1)
	arg_7_0.double_tap_timers[arg_7_1] = nil
end

function PlayerInputTutorialExtension.was_double_tap(arg_8_0, arg_8_1, arg_8_2, arg_8_3)
	local var_8_0 = arg_8_0.double_tap_timers[arg_8_1]

	return var_8_0 and arg_8_2 < var_8_0 + arg_8_3
end

function PlayerInputTutorialExtension.is_input_blocked(arg_9_0)
	return false
end

function PlayerInputTutorialExtension.get(arg_10_0, arg_10_1, arg_10_2)
	local var_10_0 = arg_10_0.input_service:get(arg_10_1, arg_10_2)

	if not arg_10_0.enabled or not PlayerInputTutorialExtension.get_window_is_in_focus() then
		if PlayerInputTutorialExtension.get_window_is_in_focus() and arg_10_0.allowed_table[arg_10_1] then
			return var_10_0
		else
			if type(var_10_0) == "userdata" then
				return Vector3.zero()
			end

			return nil
		end
	elseif arg_10_0.disallowed_table[arg_10_1] then
		if type(var_10_0) == "userdata" then
			return Vector3.zero()
		end

		return nil
	end

	return var_10_0
end

function PlayerInputTutorialExtension.set_enabled(arg_11_0, arg_11_1)
	arg_11_0.enabled = arg_11_1
end

function PlayerInputTutorialExtension.set_input_key_scale(arg_12_0, arg_12_1, arg_12_2, arg_12_3)
	fassert(arg_12_3 == nil or arg_12_3 > 0, "PlayerInputTutorialExtension:set_input_key_scale: Must enter a lerp_time larger than zero if lerp is to be used!")

	local var_12_0 = 1
	local var_12_1 = arg_12_0._t
	local var_12_2 = arg_12_3 and var_12_1 + arg_12_3 or nil
	local var_12_3 = arg_12_0.input_key_scale[arg_12_1]

	if var_12_3 then
		if var_12_3.lerp_end_t == nil or var_12_1 >= var_12_3.lerp_end_t then
			var_12_0 = var_12_3.end_scale
		else
			local var_12_4 = (var_12_1 - var_12_3.lerp_start_t) / (var_12_3.lerp_end_t - var_12_3.lerp_start_t)

			var_12_0 = math.lerp(var_12_3.start_scale, var_12_3.end_scale, var_12_4)
		end
	else
		var_12_3 = {}
		arg_12_0.input_key_scale[arg_12_1] = var_12_3
	end

	var_12_3.lerp_start_t = var_12_1
	var_12_3.lerp_end_t = var_12_2
	var_12_3.start_scale = var_12_0
	var_12_3.end_scale = arg_12_2
end

function PlayerInputTutorialExtension.set_allowed_inputs(arg_13_0, arg_13_1)
	arg_13_0.allowed_table = arg_13_1 or {}
end

function PlayerInputTutorialExtension.set_disallowed_inputs(arg_14_0, arg_14_1)
	arg_14_0.disallowed_table = arg_14_1 or {}
end

function PlayerInputTutorialExtension.allowed_input_table(arg_15_0)
	return arg_15_0.allowed_table
end

function PlayerInputTutorialExtension.disallowed_input_table(arg_16_0)
	return arg_16_0.disallowed_table
end

function PlayerInputTutorialExtension.get_last_scroll_value(arg_17_0)
	return arg_17_0.wield_scroll_value
end

function PlayerInputTutorialExtension.set_last_scroll_value(arg_18_0, arg_18_1)
	arg_18_0.wield_scroll_value = arg_18_1
end

function PlayerInputTutorialExtension.force_release_input(arg_19_0, arg_19_1)
	arg_19_0.has_released_input = true

	return true
end

function PlayerInputTutorialExtension.released_input(arg_20_0, arg_20_1)
	if arg_20_0.has_released_input then
		return true
	end

	if not arg_20_0.input_service:get(arg_20_1) then
		arg_20_0.has_released_input = true
	end

	return arg_20_0.has_released_input
end

function PlayerInputTutorialExtension.released_softbutton_input(arg_21_0, arg_21_1, arg_21_2)
	if arg_21_0.has_released_input then
		return true
	end

	local var_21_0 = arg_21_0.input_service:get(arg_21_1)

	if not var_21_0 or var_21_0 < arg_21_2 then
		arg_21_0.has_released_input = true
	end

	return arg_21_0.has_released_input
end

function PlayerInputTutorialExtension.reset_release_input(arg_22_0)
	arg_22_0.has_released_input = false

	return true
end

function PlayerInputTutorialExtension.reset_release_input_with_delay(arg_23_0, arg_23_1)
	arg_23_0.has_released_input = false

	return true
end

function PlayerInputTutorialExtension.get_wield_cooldown(arg_24_0, arg_24_1)
	if arg_24_1 then
		if arg_24_1 < arg_24_0.wield_cooldown_timer_clock then
			return true
		else
			arg_24_0.wield_cooldown = false

			return false
		end
	elseif arg_24_0.wield_cooldown then
		return true
	end

	return false
end

function PlayerInputTutorialExtension.add_wield_cooldown(arg_25_0, arg_25_1)
	arg_25_0.wield_cooldown = true
	arg_25_0.wield_cooldown_timer = arg_25_1
end

function PlayerInputTutorialExtension.get_buffer(arg_26_0, arg_26_1)
	if arg_26_0.input_buffer_timer and arg_26_0.buffer_key == arg_26_1 then
		return arg_26_0.input_buffer
	end

	return nil
end

function PlayerInputTutorialExtension.add_buffer(arg_27_0, arg_27_1, arg_27_2)
	if arg_27_1 == "action_one_hold" or arg_27_0.priority_input[arg_27_0.buffer_key] and not arg_27_0.priority_input[arg_27_1] then
		return
	elseif arg_27_1 == "action_two_hold" then
		return
	end

	local var_27_0 = arg_27_0.input_service:get(arg_27_1)

	if var_27_0 then
		if arg_27_0.priority_input[arg_27_1] then
			arg_27_0.input_buffer_timer = 1
			arg_27_0.input_buffer = var_27_0
			arg_27_0.buffer_key = arg_27_1
		else
			arg_27_0.new_input_buffer_timer = 0.6
			arg_27_0.new_input_buffer = var_27_0
			arg_27_0.new_buffer_key = arg_27_1
			arg_27_0.new_buffer_key_doubleclick_window = arg_27_2
		end
	end
end

function PlayerInputTutorialExtension.add_stun_buffer(arg_28_0, arg_28_1)
	arg_28_0.added_stun_buffer = true
	arg_28_0.input_buffer_timer = 10
	arg_28_0.input_buffer = 1
	arg_28_0.buffer_key = arg_28_1
end

function PlayerInputTutorialExtension.reset_input_buffer(arg_29_0)
	if arg_29_0.buffer_key == "action_one" and not arg_29_0.input_service:get("action_one_hold") then
		arg_29_0.buffer_key = "action_one_release"
		arg_29_0.input_buffer_timer = 0.5

		return
	end

	if arg_29_0.added_stun_buffer then
		arg_29_0.added_stun_buffer = false

		if arg_29_0.priority_input[arg_29_0.buffer_key] then
			arg_29_0.input_buffer_timer = 0
			arg_29_0.input_buffer = nil
			arg_29_0.buffer_key = nil
		end

		return
	else
		arg_29_0.input_buffer_timer = 0
		arg_29_0.input_buffer = nil
		arg_29_0.buffer_key = nil
	end
end

function PlayerInputTutorialExtension.clear_input_buffer(arg_30_0)
	arg_30_0.input_buffer_reset = true
	arg_30_0.input_buffer_timer = 0
	arg_30_0.input_buffer = nil
	arg_30_0.buffer_key = nil
	arg_30_0.new_input_buffer_timer = 0
	arg_30_0.new_input_buffer = nil
	arg_30_0.new_buffer_key = nil
end
