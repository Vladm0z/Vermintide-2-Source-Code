-- chunkname: @scripts/unit_extensions/default_player_unit/player_input_extension.lua

require("scripts/unit_extensions/generic/generic_state_machine")

PlayerInputExtension = class(PlayerInputExtension)

PlayerInputExtension.init = function (arg_1_0, arg_1_1, arg_1_2, arg_1_3)
	arg_1_0.unit = arg_1_2
	arg_1_0.player = arg_1_3.player
	arg_1_0.input_service = arg_1_0.player.input_source
	arg_1_0.enabled = true
	arg_1_0.has_released_input = {}
	arg_1_0.input_buffer_timer = nil
	arg_1_0.buffer_key = nil
	arg_1_0.input_buffer = nil
	arg_1_0.new_input_buffer_timer = 0
	arg_1_0.new_input_buffer = nil
	arg_1_0.new_buffer_key = nil
	arg_1_0.last_added_buffer_time = 0
	arg_1_0.new_buffer_key_doubleclick_window = nil
	arg_1_0.input_buffer_reset = false
	arg_1_0.added_stun_buffer = false
	arg_1_0.wield_cooldown = false
	arg_1_0.wield_cooldown_timer = 0
	arg_1_0.wield_cooldown_timer_clock = 0
	arg_1_0.wield_scroll_value = nil
	arg_1_0.double_tap_timers = {}
	arg_1_0.input_key_scale = {}
	arg_1_0._t = 0
	arg_1_0.minimum_dodge_input = 0.3
	arg_1_0._game_options_dirty = true
	arg_1_0.priority_input = {
		wield_2 = 1,
		wield_next = 1,
		wield_5 = 1,
		wield_prev = 1,
		wield_scroll = 1,
		wield_3 = 1,
		wield_1 = 2,
		wield_4 = 1,
		wield_switch = 3
	}

	Managers.state.event:register(arg_1_0, "on_game_options_changed", "_set_game_options_dirty")
	arg_1_0:_update_game_options()
end

PlayerInputExtension.destroy = function (arg_2_0)
	Managers.state.event:unregister("on_game_options_changed", arg_2_0)
end

PlayerInputExtension.reset = function (arg_3_0)
	return
end

PlayerInputExtension._set_game_options_dirty = function (arg_4_0)
	arg_4_0._game_options_dirty = true
end

PlayerInputExtension._update_game_options = function (arg_5_0)
	if not arg_5_0._game_options_dirty then
		return
	end

	arg_5_0.double_tap_dodge = Application.user_setting("double_tap_dodge")
	arg_5_0.toggle_crouch = Application.user_setting("toggle_crouch")
	arg_5_0.toggle_alternate_attack = Application.user_setting("toggle_alternate_attack")
	arg_5_0.input_buffer_user_setting = Application.user_setting("input_buffer")
	arg_5_0.priority_input_buffer_user_setting = Application.user_setting("priority_input_buffer")
	arg_5_0._game_options_dirty = false
end

PlayerInputExtension.update = function (arg_6_0, arg_6_1, arg_6_2, arg_6_3, arg_6_4, arg_6_5)
	arg_6_0._t = arg_6_5

	arg_6_0:_update_game_options()

	if arg_6_0.input_buffer_reset then
		arg_6_0.last_added_buffer_time = arg_6_5
		arg_6_0.input_buffer_reset = false
	end

	if arg_6_0.new_input_buffer then
		if arg_6_5 > arg_6_0.last_added_buffer_time + arg_6_0.new_buffer_key_doubleclick_window then
			arg_6_0.input_buffer_timer = arg_6_0.new_input_buffer_timer
			arg_6_0.input_buffer = arg_6_0.new_input_buffer
			arg_6_0.buffer_key = arg_6_0.new_buffer_key
			arg_6_0.last_added_buffer_time = arg_6_5
		end

		arg_6_0.new_input_buffer_timer = 0
		arg_6_0.new_input_buffer = nil
		arg_6_0.new_buffer_key = nil
	end

	if arg_6_0.input_buffer and arg_6_0.input_buffer_timer then
		arg_6_0.input_buffer_timer = arg_6_0.input_buffer_timer - arg_6_3

		if arg_6_0.input_buffer_timer <= 0 then
			arg_6_0.input_buffer_timer = 0
			arg_6_0.input_buffer = nil
			arg_6_0.buffer_key = nil
		end
	end

	if arg_6_0.wield_cooldown then
		if arg_6_5 > arg_6_0.wield_cooldown_timer then
			arg_6_0.wield_cooldown = false
			arg_6_0.wield_cooldown_timer_clock = 0
		else
			arg_6_0.wield_cooldown_timer_clock = arg_6_0.wield_cooldown_timer_clock + arg_6_3
		end
	end

	if arg_6_0._release_input_delay then
		arg_6_0._release_input_delay = arg_6_0._release_input_delay - arg_6_3

		if arg_6_0._release_input_delay <= 0 then
			arg_6_0._release_input_delay = nil

			arg_6_0:reset_release_input()
		end
	end
end

PlayerInputExtension.start_double_tap = function (arg_7_0, arg_7_1, arg_7_2)
	arg_7_0.double_tap_timers[arg_7_1] = arg_7_2
end

PlayerInputExtension.clear_double_tap = function (arg_8_0, arg_8_1)
	arg_8_0.double_tap_timers[arg_8_1] = nil
end

PlayerInputExtension.was_double_tap = function (arg_9_0, arg_9_1, arg_9_2, arg_9_3)
	local var_9_0 = arg_9_0.double_tap_timers[arg_9_1]

	return var_9_0 and arg_9_2 < var_9_0 + arg_9_3
end

local var_0_0 = IS_WINDOWS

PlayerInputExtension.is_input_blocked = function (arg_10_0)
	return (arg_10_0.input_service:is_blocked() or var_0_0 and not Window.has_focus() or HAS_STEAM and Managers.steam:is_overlay_active()) and not DamageUtils.is_in_inn and not Managers.state.entity:system("cutscene_system"):is_active()
end

PlayerInputExtension.get = function (arg_11_0, arg_11_1, arg_11_2)
	local var_11_0 = arg_11_0.input_service:get(arg_11_1, arg_11_2)

	if not arg_11_0.enabled or arg_11_0:is_input_blocked() then
		if type(var_11_0) == "userdata" then
			return Vector3.zero()
		end

		return nil
	end

	local var_11_1 = arg_11_0.input_key_scale[arg_11_1]

	if var_11_0 and var_11_1 then
		local var_11_2 = arg_11_0._t
		local var_11_3

		if var_11_1.lerp_end_t == nil or var_11_2 >= var_11_1.lerp_end_t then
			var_11_3 = var_11_1.end_scale
		else
			local var_11_4 = (var_11_2 - var_11_1.lerp_start_t) / (var_11_1.lerp_end_t - var_11_1.lerp_start_t)

			var_11_3 = math.lerp(var_11_1.start_scale, var_11_1.end_scale, var_11_4)
		end

		return var_11_0 * var_11_3
	end

	return var_11_0
end

PlayerInputExtension.set_enabled = function (arg_12_0, arg_12_1)
	arg_12_0.enabled = arg_12_1
end

PlayerInputExtension.set_input_key_scale = function (arg_13_0, arg_13_1, arg_13_2, arg_13_3)
	fassert(arg_13_3 == nil or arg_13_3 > 0, "PlayerInputExtension:set_input_key_scale: Must enter a lerp_time larger than zero if lerp is to be used!")

	local var_13_0 = 1
	local var_13_1 = arg_13_0._t
	local var_13_2 = arg_13_3 and var_13_1 + arg_13_3 or nil
	local var_13_3 = arg_13_0.input_key_scale[arg_13_1]

	if var_13_3 then
		if var_13_3.lerp_end_t == nil or var_13_1 >= var_13_3.lerp_end_t then
			var_13_0 = var_13_3.end_scale
		else
			local var_13_4 = (var_13_1 - var_13_3.lerp_start_t) / (var_13_3.lerp_end_t - var_13_3.lerp_start_t)

			var_13_0 = math.lerp(var_13_3.start_scale, var_13_3.end_scale, var_13_4)
		end
	else
		var_13_3 = {}
		arg_13_0.input_key_scale[arg_13_1] = var_13_3
	end

	var_13_3.lerp_start_t = var_13_1
	var_13_3.lerp_end_t = var_13_2
	var_13_3.start_scale = var_13_0
	var_13_3.end_scale = arg_13_2
end

PlayerInputExtension.get_last_scroll_value = function (arg_14_0)
	return arg_14_0.wield_scroll_value
end

PlayerInputExtension.set_last_scroll_value = function (arg_15_0, arg_15_1)
	arg_15_0.wield_scroll_value = arg_15_1
end

PlayerInputExtension.released_input = function (arg_16_0, arg_16_1)
	if arg_16_0.has_released_input[arg_16_1] then
		return true
	end

	if not arg_16_0.input_service:get(arg_16_1) then
		arg_16_0.has_released_input[arg_16_1] = true
	end

	return arg_16_0.has_released_input[arg_16_1]
end

PlayerInputExtension.released_softbutton_input = function (arg_17_0, arg_17_1, arg_17_2)
	if arg_17_0.has_released_input[arg_17_1] then
		return true
	end

	local var_17_0 = arg_17_0.input_service:get(arg_17_1)

	if not var_17_0 or var_17_0 < arg_17_2 then
		arg_17_0.has_released_input[arg_17_1] = true
	end

	return arg_17_0.has_released_input[arg_17_1]
end

PlayerInputExtension.reset_release_input = function (arg_18_0)
	for iter_18_0, iter_18_1 in pairs(arg_18_0.has_released_input) do
		arg_18_0.has_released_input[iter_18_0] = false
	end

	return true
end

PlayerInputExtension.force_release_input = function (arg_19_0, arg_19_1)
	arg_19_0.has_released_input[arg_19_1] = true

	return true
end

PlayerInputExtension.reset_release_input_with_delay = function (arg_20_0, arg_20_1)
	arg_20_0._release_input_delay = arg_20_0._release_input_delay and arg_20_0._release_input_delay + arg_20_1 or arg_20_1
end

PlayerInputExtension.get_wield_cooldown = function (arg_21_0, arg_21_1)
	if arg_21_1 then
		if arg_21_1 < arg_21_0.wield_cooldown_timer_clock then
			return true
		else
			arg_21_0.wield_cooldown = false

			return false
		end
	elseif arg_21_0.wield_cooldown then
		return true
	end

	return false
end

PlayerInputExtension.add_wield_cooldown = function (arg_22_0, arg_22_1)
	arg_22_0.wield_cooldown = true
	arg_22_0.wield_cooldown_timer = arg_22_1
end

PlayerInputExtension.get_buffer = function (arg_23_0, arg_23_1)
	if arg_23_0.input_buffer_timer and arg_23_0.buffer_key == arg_23_1 then
		return arg_23_0.input_buffer
	end

	return nil
end

local var_0_1 = {
	action_one_release = true,
	action_one = true,
	action_one_hold = true
}

PlayerInputExtension.reset_input_buffer = function (arg_24_0)
	if arg_24_0.priority_input[arg_24_0.buffer_key] then
		return
	end

	if arg_24_0.buffer_key == "action_one" and not arg_24_0.input_service:get("action_one_hold") then
		arg_24_0.buffer_key = "action_one_release"
		arg_24_0.input_buffer_timer = arg_24_0.input_buffer_user_setting

		return
	end

	if arg_24_0.added_stun_buffer then
		arg_24_0.added_stun_buffer = false

		return
	else
		arg_24_0.input_buffer_timer = 0
		arg_24_0.input_buffer = nil
		arg_24_0.buffer_key = nil
	end
end

PlayerInputExtension.clear_input_buffer = function (arg_25_0, arg_25_1)
	if not arg_25_1 and arg_25_0.priority_input[arg_25_0.buffer_key] then
		return
	end

	arg_25_0.input_buffer_reset = true
	arg_25_0.input_buffer_timer = 0
	arg_25_0.input_buffer = nil
	arg_25_0.buffer_key = nil
	arg_25_0.new_input_buffer_timer = 0
	arg_25_0.new_input_buffer = nil
	arg_25_0.new_buffer_key = nil
end

PlayerInputExtension.add_buffer = function (arg_26_0, arg_26_1, arg_26_2)
	if arg_26_1 == "action_one_hold" or arg_26_1 ~= "action_two_hold" and arg_26_0.priority_input[arg_26_0.buffer_key] and not arg_26_0.priority_input[arg_26_1] then
		return
	elseif arg_26_1 == "action_two_hold" then
		return
	end

	local var_26_0 = arg_26_0.input_service:get(arg_26_1)

	if var_26_0 then
		local var_26_1 = arg_26_0.priority_input
		local var_26_2 = var_26_1[arg_26_1]

		if var_26_2 then
			if var_26_2 >= (var_26_1[arg_26_0.buffer_key] or -1) then
				arg_26_0.input_buffer_timer = arg_26_0.priority_input_buffer_user_setting
				arg_26_0.input_buffer = var_26_0
				arg_26_0.buffer_key = arg_26_1
			end
		else
			arg_26_0.new_input_buffer_timer = arg_26_0.input_buffer_user_setting
			arg_26_0.new_input_buffer = var_26_0

			if arg_26_0.buffer_key and arg_26_0.buffer_key ~= arg_26_1 and (not var_0_1[arg_26_0.buffer_key] or not var_0_1[arg_26_1]) then
				arg_26_0.new_buffer_key_doubleclick_window = 0
			else
				arg_26_0.new_buffer_key_doubleclick_window = arg_26_2 or 0.1
			end

			arg_26_0.new_buffer_key = arg_26_1
		end
	end
end

PlayerInputExtension.add_stun_buffer = function (arg_27_0, arg_27_1)
	arg_27_0.added_stun_buffer = true
	arg_27_0.input_buffer_timer = arg_27_0.input_buffer_user_setting
	arg_27_0.input_buffer = arg_27_0.input_buffer_user_setting
	arg_27_0.buffer_key = arg_27_1
end
