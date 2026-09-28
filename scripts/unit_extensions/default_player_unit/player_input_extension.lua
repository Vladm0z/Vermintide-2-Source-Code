-- chunkname: @scripts/unit_extensions/default_player_unit/player_input_extension.lua

require("scripts/unit_extensions/generic/generic_state_machine")

PlayerInputExtension = class(PlayerInputExtension)

PlayerInputExtension.init = function (self, extension_init_context, unit, extension_init_data)
	-- function 1
	self.unit = unit
	self.player = extension_init_data.player
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

PlayerInputExtension.destroy = function (self)
	-- function 2
	Managers.state.event:unregister("on_game_options_changed", self)
end

PlayerInputExtension.reset = function (self)
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

PlayerInputExtension.update = function (self, unit, input, dt, context, t)
	-- function 6
	self._t = t

	self:_update_game_options()

	if self.input_buffer_reset then
		self.last_added_buffer_time = t
		self.input_buffer_reset = false
	end

	if self.new_input_buffer then
		if t > self.last_added_buffer_time + self.new_buffer_key_doubleclick_window then
			self.input_buffer_timer = self.new_input_buffer_timer
			self.input_buffer = self.new_input_buffer
			self.buffer_key = self.new_buffer_key
			self.last_added_buffer_time = t
		end

		self.new_input_buffer_timer = 0
		self.new_input_buffer = nil
		self.new_buffer_key = nil
	end

	if self.input_buffer and self.input_buffer_timer then
		self.input_buffer_timer = self.input_buffer_timer - dt

		if self.input_buffer_timer <= 0 then
			self.input_buffer_timer = 0
			self.input_buffer = nil
			self.buffer_key = nil
		end
	end

	if self.wield_cooldown then
		if t > self.wield_cooldown_timer then
			self.wield_cooldown = false
			self.wield_cooldown_timer_clock = 0
		else
			self.wield_cooldown_timer_clock = self.wield_cooldown_timer_clock + dt
		end
	end

	if self._release_input_delay then
		self._release_input_delay = self._release_input_delay - dt

		if self._release_input_delay <= 0 then
			self._release_input_delay = nil

			self:reset_release_input()
		end
	end
end

PlayerInputExtension.start_double_tap = function (self, input_key, t)
	-- function 7
	self.double_tap_timers[input_key] = t
end

PlayerInputExtension.clear_double_tap = function (self, input_key)
	-- function 8
	self.double_tap_timers[input_key] = nil
end

PlayerInputExtension.was_double_tap = function (self, input_key, t, max_duration)
	-- function 9
	local last_double_tap = self.double_tap_timers[input_key]

	return not not last_double_tap and t < last_double_tap + max_duration
end

local is_windows_platform = IS_WINDOWS

PlayerInputExtension.is_input_blocked = function (self)
	-- function 10
	local HAS_STEAM

	if not self.input_service:is_blocked() and (not is_windows_platform or Window.has_focus()) then
		HAS_STEAM = HAS_STEAM

		if HAS_STEAM then
			-- Nothing
		end

		HAS_STEAM = Managers.steam:is_overlay_active()

		if HAS_STEAM then
			-- Nothing
		end
	end

	HAS_STEAM = not DamageUtils.is_in_inn and not not not Managers.state.entity:system("cutscene_system"):is_active()

	::label_10_0::

	return HAS_STEAM
end

PlayerInputExtension.get = function (self, input_key, consume)
	-- function 11
	local value = self.input_service:get(input_key, consume)

	if not self.enabled or self:is_input_blocked() then
		local value_type = type(value)

		if value_type == "userdata" then
			return Vector3.zero()
		end

		return nil
	end

	local input_key_scale_data = self.input_key_scale[input_key]

	if value and input_key_scale_data then
		local t = self._t
		local scale

		if input_key_scale_data.lerp_end_t == nil or t >= input_key_scale_data.lerp_end_t then
			scale = input_key_scale_data.end_scale
		else
			local p = (t - input_key_scale_data.lerp_start_t) / (input_key_scale_data.lerp_end_t - input_key_scale_data.lerp_start_t)

			scale = math.lerp(input_key_scale_data.start_scale, input_key_scale_data.end_scale, p)
		end

		return value * scale
	end

	return value
end

PlayerInputExtension.set_enabled = function (self, enabled)
	-- function 12
	self.enabled = enabled
end

PlayerInputExtension.set_input_key_scale = function (self, input_key, scale, lerp_time)
	-- function 13
	fassert(lerp_time == nil or lerp_time > 0, "PlayerInputExtension:set_input_key_scale: Must enter a lerp_time larger than zero if lerp is to be used!")

	local start_scale = 1
	local t = self._t
	local num

	if lerp_time then
		num = t + lerp_time

		if not num then
			-- Nothing
		end
	end

	num = nil

	local lerp_end_t = num

	::label_13_0::

	local input_key_scale_data = self.input_key_scale[input_key]

	if input_key_scale_data then
		if input_key_scale_data.lerp_end_t == nil or t >= input_key_scale_data.lerp_end_t then
			start_scale = input_key_scale_data.end_scale
		else
			local p = (t - input_key_scale_data.lerp_start_t) / (input_key_scale_data.lerp_end_t - input_key_scale_data.lerp_start_t)

			start_scale = math.lerp(input_key_scale_data.start_scale, input_key_scale_data.end_scale, p)
		end
	else
		input_key_scale_data = {}
		self.input_key_scale[input_key] = input_key_scale_data
	end

	input_key_scale_data.lerp_start_t = t
	input_key_scale_data.lerp_end_t = lerp_end_t
	input_key_scale_data.start_scale = start_scale
	input_key_scale_data.end_scale = scale
end

PlayerInputExtension.get_last_scroll_value = function (self)
	-- function 14
	return self.wield_scroll_value
end

PlayerInputExtension.set_last_scroll_value = function (self, scroll_value)
	-- function 15
	self.wield_scroll_value = scroll_value
end

PlayerInputExtension.released_input = function (self, input)
	-- function 16
	if self.has_released_input[input] then
		return true
	end

	local get_input_release = self.input_service:get(input)

	if not get_input_release then
		self.has_released_input[input] = true
	end

	return self.has_released_input[input]
end

PlayerInputExtension.released_softbutton_input = function (self, input, softbutton_threshold)
	-- function 17
	if self.has_released_input[input] then
		return true
	end

	local input_value = self.input_service:get(input)

	if not input_value or input_value < softbutton_threshold then
		self.has_released_input[input] = true
	end

	return self.has_released_input[input]
end

PlayerInputExtension.reset_release_input = function (self)
	-- function 18
	for input, key in pairs(self.has_released_input) do
		self.has_released_input[input] = false
	end

	return true
end

PlayerInputExtension.force_release_input = function (self, input)
	-- function 19
	self.has_released_input[input] = true

	return true
end

PlayerInputExtension.reset_release_input_with_delay = function (self, delay)
	-- function 20
	local num

	if self._release_input_delay then
		num = self._release_input_delay + delay

		if not num then
			-- Nothing
		end
	end

	num = delay

	::label_20_0::

	self._release_input_delay = num
end

PlayerInputExtension.get_wield_cooldown = function (self, override_cooldown_time)
	-- function 21
	if override_cooldown_time then
		if override_cooldown_time < self.wield_cooldown_timer_clock then
			return true
		else
			self.wield_cooldown = false

			return false
		end
	elseif self.wield_cooldown then
		return true
	end

	return false
end

PlayerInputExtension.add_wield_cooldown = function (self, cooldown_time)
	-- function 22
	self.wield_cooldown = true
	self.wield_cooldown_timer = cooldown_time
end

PlayerInputExtension.get_buffer = function (self, input_key)
	-- function 23
	if self.input_buffer_timer and self.buffer_key == input_key then
		return self.input_buffer
	end

	return nil
end

local action_one_variants = {
	action_one_release = true,
	action_one = true,
	action_one_hold = true
}

PlayerInputExtension.reset_input_buffer = function (self)
	-- function 24
	if self.priority_input[self.buffer_key] then
		return
	end

	if self.buffer_key == "action_one" and not self.input_service:get("action_one_hold") then
		self.buffer_key = "action_one_release"
		self.input_buffer_timer = self.input_buffer_user_setting

		return
	end

	if self.added_stun_buffer then
		self.added_stun_buffer = false

		return
	else
		self.input_buffer_timer = 0
		self.input_buffer = nil
		self.buffer_key = nil
	end
end

PlayerInputExtension.clear_input_buffer = function (self, clear_from_wield)
	-- function 25
	if not clear_from_wield and self.priority_input[self.buffer_key] then
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

PlayerInputExtension.add_buffer = function (self, input_key, doubleclick_window)
	-- function 26
	if input_key == "action_one_hold" or input_key ~= "action_two_hold" and self.priority_input[self.buffer_key] and not self.priority_input[input_key] then
		return
	elseif input_key == "action_two_hold" then
		return
	end

	local value = self.input_service:get(input_key)

	if value then
		local priority_lookup = self.priority_input
		local priority = priority_lookup[input_key]

		if priority then
			local var_26_0 = priority_lookup[self.buffer_key]

			if not var_26_0 then
				-- Nothing
			end

			var_26_0 = -1

			local last_priority = var_26_0

			::label_26_0::

			if last_priority <= priority then
				self.input_buffer_timer = self.priority_input_buffer_user_setting
				self.input_buffer = value
				self.buffer_key = input_key
			end
		else
			self.new_input_buffer_timer = self.input_buffer_user_setting
			self.new_input_buffer = value

			if self.buffer_key and self.buffer_key ~= input_key and (not action_one_variants[self.buffer_key] or not action_one_variants[input_key]) then
				self.new_buffer_key_doubleclick_window = 0
			else
				self.new_buffer_key_doubleclick_window = not not doubleclick_window or not not 0.1
			end

			self.new_buffer_key = input_key
		end
	end
end

PlayerInputExtension.add_stun_buffer = function (self, input_key)
	-- function 27
	self.added_stun_buffer = true
	self.input_buffer_timer = self.input_buffer_user_setting
	self.input_buffer = self.input_buffer_user_setting
	self.buffer_key = input_key
end
