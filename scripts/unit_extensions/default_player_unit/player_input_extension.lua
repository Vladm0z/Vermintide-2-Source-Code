-- chunkname: @scripts/unit_extensions/default_player_unit/player_input_extension.lua

require("scripts/unit_extensions/generic/generic_state_machine")

PlayerInputExtension = class(PlayerInputExtension)

PlayerInputExtension.init = function (self, arg_1_1, arg_1_2, arg_1_3)
	-- function 1
	self.unit = arg_1_2
	self.player = arg_1_3.player
	self.input_service = self.player.input_source
	self.enabled = true
	self.has_released_input = {}
	self.input_buffer_timer = nil
	self.buffer_key = nil
	self.input_buffer = nil
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
	self.input_key_scale = {}
	self._t = 0
	self.minimum_dodge_input = 0.3
	self._game_options_dirty = true
	self.priority_input = {
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

	Managers.state.event:register(self, "on_game_options_changed", "_set_game_options_dirty")
	self:_update_game_options()
end

PlayerInputExtension.destroy = function (arg_2_0)
	-- function 2
	Managers.state.event:unregister("on_game_options_changed", arg_2_0)
end

PlayerInputExtension.reset = function (arg_3_0)
	-- function 3
	return
end

PlayerInputExtension._set_game_options_dirty = function (self)
	-- function 4
	self._game_options_dirty = true
end

PlayerInputExtension._update_game_options = function (self)
	-- function 5
	if not self._game_options_dirty then
		return
	end

	self.double_tap_dodge = Application.user_setting("double_tap_dodge")
	self.toggle_crouch = Application.user_setting("toggle_crouch")
	self.toggle_alternate_attack = Application.user_setting("toggle_alternate_attack")
	self.input_buffer_user_setting = Application.user_setting("input_buffer")
	self.priority_input_buffer_user_setting = Application.user_setting("priority_input_buffer")
	self._game_options_dirty = false
end

PlayerInputExtension.update = function (self, arg_6_1, arg_6_2, arg_6_3, arg_6_4, arg_6_5)
	-- function 6
	self._t = arg_6_5

	self:_update_game_options()

	if not self.input_buffer_reset then
		self.last_added_buffer_time = arg_6_5
		self.input_buffer_reset = false
	end

	if not self.new_input_buffer then
		if arg_6_5 > self.last_added_buffer_time + self.new_buffer_key_doubleclick_window then
			self.input_buffer_timer = self.new_input_buffer_timer
			self.input_buffer = self.new_input_buffer
			self.buffer_key = self.new_buffer_key
			self.last_added_buffer_time = arg_6_5
		end

		self.new_input_buffer_timer = 0
		self.new_input_buffer = nil
		self.new_buffer_key = nil
	end

	if not self.input_buffer and not self.input_buffer_timer then
		self.input_buffer_timer = self.input_buffer_timer - arg_6_3

		if self.input_buffer_timer <= 0 then
			self.input_buffer_timer = 0
			self.input_buffer = nil
			self.buffer_key = nil
		end
	end

	if not self.wield_cooldown then
		if arg_6_5 > self.wield_cooldown_timer then
			self.wield_cooldown = false
			self.wield_cooldown_timer_clock = 0
		else
			self.wield_cooldown_timer_clock = self.wield_cooldown_timer_clock + arg_6_3
		end
	end

	if not self._release_input_delay then
		self._release_input_delay = self._release_input_delay - arg_6_3

		if self._release_input_delay <= 0 then
			self._release_input_delay = nil

			self:reset_release_input()
		end
	end
end

PlayerInputExtension.start_double_tap = function (arg_7_0, arg_7_1, arg_7_2)
	-- function 7
	arg_7_0.double_tap_timers[arg_7_1] = arg_7_2
end

PlayerInputExtension.clear_double_tap = function (arg_8_0, arg_8_1)
	-- function 8
	arg_8_0.double_tap_timers[arg_8_1] = nil
end

PlayerInputExtension.was_double_tap = function (self, arg_9_1, arg_9_2, arg_9_3)
	-- function 9
	local var_9_0 = self.double_tap_timers[arg_9_1]

	return not var_9_0 and arg_9_2 < var_9_0 + arg_9_3
end

local IS_WINDOWS = IS_WINDOWS

PlayerInputExtension.is_input_blocked = function (self)
	-- function 10
	local HAS_STEAM

	if (self.input_service:is_blocked() or not IS_WINDOWS) and not Window.has_focus() then
		HAS_STEAM = HAS_STEAM

		if not HAS_STEAM then
			-- Nothing
		end

		HAS_STEAM = Managers.steam:is_overlay_active()

		if not HAS_STEAM then
			-- Nothing
		end
	end

	HAS_STEAM = not not DamageUtils.is_in_inn or not Managers.state.entity:system("cutscene_system"):is_active()

	::label_10_0::

	return HAS_STEAM
end

PlayerInputExtension.get = function (self, arg_11_1, arg_11_2)
	-- function 11
	local get = self.input_service:get(arg_11_1, arg_11_2)

	if not self.enabled and not self:is_input_blocked() then
		if type(get) == "userdata" then
			return Vector3.zero()
		end

		return nil
	end

	local var_11_1 = self.input_key_scale[arg_11_1]

	if not get and not var_11_1 then
		local _t = self._t
		local var_11_3

		if not (var_11_1.lerp_end_t == nil or not (_t >= var_11_1.lerp_end_t)) then
			var_11_3 = var_11_1.end_scale
		else
			local num = (_t - var_11_1.lerp_start_t) / (var_11_1.lerp_end_t - var_11_1.lerp_start_t)

			var_11_3 = math.lerp(var_11_1.start_scale, var_11_1.end_scale, num)
		end

		return get * var_11_3
	end

	return get
end

PlayerInputExtension.set_enabled = function (self, arg_12_1)
	-- function 12
	self.enabled = arg_12_1
end

PlayerInputExtension.set_input_key_scale = function (self, arg_13_1, arg_13_2, arg_13_3)
	-- function 13
	fassert(arg_13_3 == nil or arg_13_3 > 0, "PlayerInputExtension:set_input_key_scale: Must enter a lerp_time larger than zero if lerp is to be used!")

	local num = 1
	local _t = self._t
	local num_2

	if not arg_13_3 then
		num_2 = _t + arg_13_3

		if not num_2 then
			-- Nothing
		end
	end

	num_2 = nil

	::label_13_0::

	local var_13_3 = self.input_key_scale[arg_13_1]

	if not var_13_3 then
		if not (var_13_3.lerp_end_t == nil or not (_t >= var_13_3.lerp_end_t)) then
			num = var_13_3.end_scale
		else
			local num_3 = (_t - var_13_3.lerp_start_t) / (var_13_3.lerp_end_t - var_13_3.lerp_start_t)

			num = math.lerp(var_13_3.start_scale, var_13_3.end_scale, num_3)
		end
	else
		var_13_3 = {}
		self.input_key_scale[arg_13_1] = var_13_3
	end

	var_13_3.lerp_start_t = _t
	var_13_3.lerp_end_t = num_2
	var_13_3.start_scale = num
	var_13_3.end_scale = arg_13_2
end

PlayerInputExtension.get_last_scroll_value = function (self)
	-- function 14
	return self.wield_scroll_value
end

PlayerInputExtension.set_last_scroll_value = function (self, arg_15_1)
	-- function 15
	self.wield_scroll_value = arg_15_1
end

PlayerInputExtension.released_input = function (self, arg_16_1)
	-- function 16
	if not self.has_released_input[arg_16_1] then
		return true
	end

	if not self.input_service:get(arg_16_1) then
		self.has_released_input[arg_16_1] = true
	end

	return self.has_released_input[arg_16_1]
end

PlayerInputExtension.released_softbutton_input = function (self, arg_17_1, arg_17_2)
	-- function 17
	if not self.has_released_input[arg_17_1] then
		return true
	end

	local get = self.input_service:get(arg_17_1)

	if not (not get and not (get < arg_17_2)) then
		self.has_released_input[arg_17_1] = true
	end

	return self.has_released_input[arg_17_1]
end

PlayerInputExtension.reset_release_input = function (self)
	-- function 18
	for k, v in pairs(self.has_released_input) do
		self.has_released_input[k] = false
	end

	return true
end

PlayerInputExtension.force_release_input = function (arg_19_0, arg_19_1)
	-- function 19
	arg_19_0.has_released_input[arg_19_1] = true

	return true
end

PlayerInputExtension.reset_release_input_with_delay = function (self, arg_20_1)
	-- function 20
	local num

	if not self._release_input_delay then
		num = self._release_input_delay + arg_20_1

		if not num then
			-- Nothing
		end
	end

	num = arg_20_1

	::label_20_0::

	self._release_input_delay = num
end

PlayerInputExtension.get_wield_cooldown = function (self, arg_21_1)
	-- function 21
	if not arg_21_1 then
		if arg_21_1 < self.wield_cooldown_timer_clock then
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

PlayerInputExtension.add_wield_cooldown = function (self, arg_22_1)
	-- function 22
	self.wield_cooldown = true
	self.wield_cooldown_timer = arg_22_1
end

PlayerInputExtension.get_buffer = function (self, arg_23_1)
	-- function 23
	if not (not self.input_buffer_timer and self.buffer_key ~= arg_23_1) then
		return self.input_buffer
	end

	return nil
end

local tbl = {
	action_one_release = true,
	action_one = true,
	action_one_hold = true
}

PlayerInputExtension.reset_input_buffer = function (self)
	-- function 24
	if not self.priority_input[self.buffer_key] then
		return
	end

	if not (self.buffer_key ~= "action_one" or self.input_service:get("action_one_hold")) then
		self.buffer_key = "action_one_release"
		self.input_buffer_timer = self.input_buffer_user_setting

		return
	end

	if not self.added_stun_buffer then
		self.added_stun_buffer = false

		return
	else
		self.input_buffer_timer = 0
		self.input_buffer = nil
		self.buffer_key = nil
	end
end

PlayerInputExtension.clear_input_buffer = function (self, arg_25_1)
	-- function 25
	if arg_25_1 or not self.priority_input[self.buffer_key] then
		return
	end

	self.input_buffer_reset = true
	self.input_buffer_timer = 0
	self.input_buffer = nil
	self.buffer_key = nil
	self.new_input_buffer_timer = 0
	self.new_input_buffer = nil
	self.new_buffer_key = nil
end

PlayerInputExtension.add_buffer = function (self, arg_26_1, arg_26_2)
	-- function 26
	if not ((arg_26_1 == "action_one_hold" or arg_26_1 == "action_two_hold" or not self.priority_input[self.buffer_key]) and self.priority_input[arg_26_1]) then
		return
	elseif arg_26_1 == "action_two_hold" then
		return
	end

	local get = self.input_service:get(arg_26_1)

	if not get then
		local priority_input = self.priority_input
		local var_26_2 = priority_input[arg_26_1]

		if not var_26_2 then
			local var_26_3 = priority_input[self.buffer_key]

			var_26_3 = var_26_3 or -1

			if var_26_3 <= var_26_2 then
				self.input_buffer_timer = self.priority_input_buffer_user_setting
				self.input_buffer = get
				self.buffer_key = arg_26_1
			end
		else
			self.new_input_buffer_timer = self.input_buffer_user_setting
			self.new_input_buffer = get

			if not (not self.buffer_key and self.buffer_key == arg_26_1 or not tbl[self.buffer_key] or tbl[arg_26_1]) then
				self.new_buffer_key_doubleclick_window = 0
			else
				self.new_buffer_key_doubleclick_window = arg_26_2 or 0.1
			end

			self.new_buffer_key = arg_26_1
		end
	end
end

PlayerInputExtension.add_stun_buffer = function (self, arg_27_1)
	-- function 27
	self.added_stun_buffer = true
	self.input_buffer_timer = self.input_buffer_user_setting
	self.input_buffer = self.input_buffer_user_setting
	self.buffer_key = arg_27_1
end
