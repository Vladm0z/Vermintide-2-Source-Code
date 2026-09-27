-- chunkname: @scripts/unit_extensions/default_player_unit/player_input_tutorial_extension.lua

require("scripts/unit_extensions/generic/generic_state_machine")

local IS_WINDOWS = IS_WINDOWS

PlayerInputTutorialExtension = class(PlayerInputTutorialExtension)

PlayerInputTutorialExtension.get_window_is_in_focus = function ()
	-- function 1
	local flag = false

	if not IS_WINDOWS then
		if not Window.has_focus() then
			flag = true
		end
	else
		flag = true
	end

	return flag
end

PlayerInputTutorialExtension.init = function (self, arg_2_1, arg_2_2, arg_2_3)
	-- function 2
	self.unit = arg_2_2
	self.player = arg_2_3.player
	self.input_service = self.player.input_source
	self.enabled = true
	self.has_released_input = false
	self.input_buffer_timer = nil
	self.buffer_key = nil
	self.input_buffer = nil
	self.name = "PlayerInputTutorialExtension"
	self.new_input_buffer_timer = 0
	self.new_input_buffer = nil
	self.new_buffer_key = nil
	self.last_added_buffer_time = 0
	self.new_buffer_key_doubleclick_window = nil
	self.input_buffer_reset = false
	self.added_stun_buffer = false
	self.wield_cooldown = false
	self.wield_cooldown_timer = 0
	self.wield_cooldown_timer_clock = 0
	self.wield_scroll_value = nil
	self.double_tap_timers = {}
	self.allowed_table = {}
	self.disallowed_table = {}
	self.input_key_scale = {}
	self._t = 0
	self.minimum_dodge_input = 0.3
	self.double_tap_dodge = Application.user_setting("double_tap_dodge")
	self.toggle_crouch = Application.user_setting("toggle_crouch")
	self.toggle_alternate_attack = Application.user_setting("toggle_alternate_attack")
	self.priority_input = {
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

PlayerInputTutorialExtension.destroy = function (arg_3_0)
	-- function 3
	return
end

PlayerInputTutorialExtension.reset = function (arg_4_0)
	-- function 4
	return
end

PlayerInputTutorialExtension.update = function (self, arg_5_1, arg_5_2, arg_5_3, arg_5_4, arg_5_5)
	-- function 5
	self._t = arg_5_5

	if not self.input_buffer_reset then
		self.last_added_buffer_time = arg_5_5
		self.input_buffer_reset = false
	end

	if not self.new_input_buffer then
		local last_added_buffer_time = self.last_added_buffer_time
		local new_buffer_key_doubleclick_window = self.new_buffer_key_doubleclick_window

		new_buffer_key_doubleclick_window = new_buffer_key_doubleclick_window or 0.2

		if arg_5_5 > last_added_buffer_time + new_buffer_key_doubleclick_window then
			self.input_buffer_timer = self.new_input_buffer_timer
			self.input_buffer = self.new_input_buffer
			self.buffer_key = self.new_buffer_key
			self.last_added_buffer_time = arg_5_5
		end

		self.new_input_buffer_timer = 0
		self.new_input_buffer = nil
		self.new_buffer_key = nil
	end

	if not self.input_buffer then
		self.input_buffer_timer = self.input_buffer_timer - arg_5_3

		if self.input_buffer_timer <= 0 then
			self.input_buffer_timer = 0
			self.input_buffer = nil
			self.buffer_key = nil
		end
	end

	if not self.wield_cooldown then
		if arg_5_5 > self.wield_cooldown_timer then
			self.wield_cooldown = false
			self.wield_cooldown_timer_clock = 0
		else
			self.wield_cooldown_timer_clock = self.wield_cooldown_timer_clock + arg_5_3
		end
	end
end

PlayerInputTutorialExtension.start_double_tap = function (arg_6_0, arg_6_1, arg_6_2)
	-- function 6
	arg_6_0.double_tap_timers[arg_6_1] = arg_6_2
end

PlayerInputTutorialExtension.clear_double_tap = function (arg_7_0, arg_7_1)
	-- function 7
	arg_7_0.double_tap_timers[arg_7_1] = nil
end

PlayerInputTutorialExtension.was_double_tap = function (self, arg_8_1, arg_8_2, arg_8_3)
	-- function 8
	local var_8_0 = self.double_tap_timers[arg_8_1]

	return not var_8_0 and arg_8_2 < var_8_0 + arg_8_3
end

PlayerInputTutorialExtension.is_input_blocked = function (arg_9_0)
	-- function 9
	return false
end

PlayerInputTutorialExtension.get = function (self, arg_10_1, arg_10_2)
	-- function 10
	local get = self.input_service:get(arg_10_1, arg_10_2)

	if not (not self.enabled and PlayerInputTutorialExtension.get_window_is_in_focus()) then
		if not PlayerInputTutorialExtension.get_window_is_in_focus() and not self.allowed_table[arg_10_1] then
			return get
		else
			if type(get) == "userdata" then
				return Vector3.zero()
			end

			return nil
		end
	elseif not self.disallowed_table[arg_10_1] then
		if type(get) == "userdata" then
			return Vector3.zero()
		end

		return nil
	end

	return get
end

PlayerInputTutorialExtension.set_enabled = function (self, arg_11_1)
	-- function 11
	self.enabled = arg_11_1
end

PlayerInputTutorialExtension.set_input_key_scale = function (self, arg_12_1, arg_12_2, arg_12_3)
	-- function 12
	fassert(arg_12_3 == nil or arg_12_3 > 0, "PlayerInputTutorialExtension:set_input_key_scale: Must enter a lerp_time larger than zero if lerp is to be used!")

	local num = 1
	local _t = self._t
	local num_2

	if not arg_12_3 then
		num_2 = _t + arg_12_3

		if not num_2 then
			-- Nothing
		end
	end

	num_2 = nil

	::label_12_0::

	local var_12_3 = self.input_key_scale[arg_12_1]

	if not var_12_3 then
		if not (var_12_3.lerp_end_t == nil or not (_t >= var_12_3.lerp_end_t)) then
			num = var_12_3.end_scale
		else
			local num_3 = (_t - var_12_3.lerp_start_t) / (var_12_3.lerp_end_t - var_12_3.lerp_start_t)

			num = math.lerp(var_12_3.start_scale, var_12_3.end_scale, num_3)
		end
	else
		var_12_3 = {}
		self.input_key_scale[arg_12_1] = var_12_3
	end

	var_12_3.lerp_start_t = _t
	var_12_3.lerp_end_t = num_2
	var_12_3.start_scale = num
	var_12_3.end_scale = arg_12_2
end

PlayerInputTutorialExtension.set_allowed_inputs = function (self, arg_13_1)
	-- function 13
	self.allowed_table = arg_13_1 or {}
end

PlayerInputTutorialExtension.set_disallowed_inputs = function (self, arg_14_1)
	-- function 14
	self.disallowed_table = arg_14_1 or {}
end

PlayerInputTutorialExtension.allowed_input_table = function (self)
	-- function 15
	return self.allowed_table
end

PlayerInputTutorialExtension.disallowed_input_table = function (self)
	-- function 16
	return self.disallowed_table
end

PlayerInputTutorialExtension.get_last_scroll_value = function (self)
	-- function 17
	return self.wield_scroll_value
end

PlayerInputTutorialExtension.set_last_scroll_value = function (self, arg_18_1)
	-- function 18
	self.wield_scroll_value = arg_18_1
end

PlayerInputTutorialExtension.force_release_input = function (self, arg_19_1)
	-- function 19
	self.has_released_input = true

	return true
end

PlayerInputTutorialExtension.released_input = function (self, arg_20_1)
	-- function 20
	if not self.has_released_input then
		return true
	end

	if not self.input_service:get(arg_20_1) then
		self.has_released_input = true
	end

	return self.has_released_input
end

PlayerInputTutorialExtension.released_softbutton_input = function (self, arg_21_1, arg_21_2)
	-- function 21
	if not self.has_released_input then
		return true
	end

	local get = self.input_service:get(arg_21_1)

	if not (not get and not (get < arg_21_2)) then
		self.has_released_input = true
	end

	return self.has_released_input
end

PlayerInputTutorialExtension.reset_release_input = function (self)
	-- function 22
	self.has_released_input = false

	return true
end

PlayerInputTutorialExtension.reset_release_input_with_delay = function (self, arg_23_1)
	-- function 23
	self.has_released_input = false

	return true
end

PlayerInputTutorialExtension.get_wield_cooldown = function (self, arg_24_1)
	-- function 24
	if not arg_24_1 then
		if arg_24_1 < self.wield_cooldown_timer_clock then
			return true
		else
			self.wield_cooldown = false

			return false
		end
	elseif not self.wield_cooldown then
		return true
	end

	return false
end

PlayerInputTutorialExtension.add_wield_cooldown = function (self, arg_25_1)
	-- function 25
	self.wield_cooldown = true
	self.wield_cooldown_timer = arg_25_1
end

PlayerInputTutorialExtension.get_buffer = function (self, arg_26_1)
	-- function 26
	if not (not self.input_buffer_timer and self.buffer_key ~= arg_26_1) then
		return self.input_buffer
	end

	return nil
end

PlayerInputTutorialExtension.add_buffer = function (self, arg_27_1, arg_27_2)
	-- function 27
	if not ((arg_27_1 == "action_one_hold" or not self.priority_input[self.buffer_key]) and self.priority_input[arg_27_1]) then
		return
	elseif arg_27_1 == "action_two_hold" then
		return
	end

	local get = self.input_service:get(arg_27_1)

	if not get then
		if not self.priority_input[arg_27_1] then
			self.input_buffer_timer = 1
			self.input_buffer = get
			self.buffer_key = arg_27_1
		else
			self.new_input_buffer_timer = 0.6
			self.new_input_buffer = get
			self.new_buffer_key = arg_27_1
			self.new_buffer_key_doubleclick_window = arg_27_2
		end
	end
end

PlayerInputTutorialExtension.add_stun_buffer = function (self, arg_28_1)
	-- function 28
	self.added_stun_buffer = true
	self.input_buffer_timer = 10
	self.input_buffer = 1
	self.buffer_key = arg_28_1
end

PlayerInputTutorialExtension.reset_input_buffer = function (self)
	-- function 29
	if not (self.buffer_key ~= "action_one" or self.input_service:get("action_one_hold")) then
		self.buffer_key = "action_one_release"
		self.input_buffer_timer = 0.5

		return
	end

	if not self.added_stun_buffer then
		self.added_stun_buffer = false

		if not self.priority_input[self.buffer_key] then
			self.input_buffer_timer = 0
			self.input_buffer = nil
			self.buffer_key = nil
		end

		return
	else
		self.input_buffer_timer = 0
		self.input_buffer = nil
		self.buffer_key = nil
	end
end

PlayerInputTutorialExtension.clear_input_buffer = function (self)
	-- function 30
	self.input_buffer_reset = true
	self.input_buffer_timer = 0
	self.input_buffer = nil
	self.buffer_key = nil
	self.new_input_buffer_timer = 0
	self.new_input_buffer = nil
	self.new_buffer_key = nil
end
