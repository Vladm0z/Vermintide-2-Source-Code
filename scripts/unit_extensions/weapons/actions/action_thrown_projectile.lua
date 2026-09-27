-- chunkname: @scripts/unit_extensions/weapons/actions/action_thrown_projectile.lua

ActionThrownProjectile = class(ActionThrownProjectile, ActionBase)

ActionThrownProjectile.init = function (self, arg_1_1, arg_1_2, arg_1_3, arg_1_4, arg_1_5, arg_1_6, arg_1_7, arg_1_8)
	-- function 1
	ActionThrownProjectile.super.init(self, arg_1_1, arg_1_2, arg_1_3, arg_1_4, arg_1_5, arg_1_6, arg_1_7, arg_1_8)

	if not ScriptUnit.has_extension(arg_1_7, "ammo_system") then
		self._ammo_extension = ScriptUnit.extension(arg_1_7, "ammo_system")
	end

	self._spread_extension = ScriptUnit.extension(arg_1_7, "spread_system")
end

ActionThrownProjectile.client_owner_start_action = function (self, arg_2_1, arg_2_2, arg_2_3, arg_2_4)
	-- function 2
	ActionThrownProjectile.super.client_owner_start_action(self, arg_2_1, arg_2_2, arg_2_3, arg_2_4)

	local owner_unit = self.owner_unit
	local is_critical_strike = ActionUtils.is_critical_strike(owner_unit, arg_2_1, arg_2_2)

	self._status_extension = ScriptUnit.extension(owner_unit, "status_system")
	self._first_person_extension = ScriptUnit.extension(owner_unit, "first_person_system")

	local has_extension = ScriptUnit.has_extension(owner_unit, "hud_system")
	local extension = ScriptUnit.extension(owner_unit, "buff_system")

	self._hud_extension = has_extension
	self._owner_buff_extension = extension
	self._current_action = arg_2_1
	self._power_level = arg_2_4

	ScriptUnit.extension(owner_unit, "input_system"):reset_input_buffer()

	self.state = "waiting_to_shoot"

	local get_action_time_scale = ActionUtils.get_action_time_scale(owner_unit, arg_2_1)
	local fire_time = arg_2_1.fire_time

	fire_time = fire_time or 0
	self._time_to_shoot = arg_2_2 + fire_time * (1 / get_action_time_scale)

	local num

	if not arg_2_1.unzoom_time then
		num = arg_2_2 + arg_2_1.unzoom_time

		if not num then
			-- Nothing
		end
	end

	num = nil

	::label_2_0::

	self._time_to_unzoom = num
	self._extra_buff_shot = false

	self:_handle_critical_strike(is_critical_strike, extension, has_extension, nil, "on_critical_shot", nil)

	self._is_critical_strike = is_critical_strike
end

ActionThrownProjectile._use_ammo = function (self)
	-- function 3
	local _ammo_extension = self._ammo_extension

	if not (not _ammo_extension and self._extra_buff_shot) then
		local ammo_usage = self._current_action.ammo_usage

		_ammo_extension:use_ammo(ammo_usage)
	end
end

ActionThrownProjectile._reload = function (self)
	-- function 4
	local _ammo_extension = self._ammo_extension

	if not _ammo_extension:can_reload() then
		local _current_action = self._current_action
		local play_reload_animation = _current_action.play_reload_animation
		local override_reload_time = _current_action.override_reload_time

		_ammo_extension:start_reload(play_reload_animation, override_reload_time)
	end
end

ActionThrownProjectile.client_owner_post_update = function (self, arg_5_1, arg_5_2, arg_5_3, arg_5_4)
	-- function 5
	local _current_action = self._current_action

	if not (not self._time_to_unzoom and not (arg_5_2 >= self._time_to_unzoom)) then
		self._status_extension:set_zooming(false)
	end

	if not (self.state ~= "waiting_to_shoot" or not (arg_5_2 >= self._time_to_shoot)) then
		self.state = "shooting"
	end

	if self.state == "shooting" then
		local _update_extra_shots = self:_update_extra_shots(self._owner_buff_extension, 1)
		local flag = not self._extra_buff_shot

		if not Managers.player:owner(self.owner_unit).bot_player then
			Managers.state.controller_features:add_effect("rumble", {
				rumble_effect = "bow_fire"
			})
		end

		self:_fire(flag)

		if not (not self._ammo_extension and self._extra_buff_shot) then
			self:_use_ammo()

			if not _current_action.reload_event_delay_time then
				self.time_to_reload = arg_5_2 + _current_action.reload_event_delay_time
			else
				self:_reload()
			end
		end

		if not _update_extra_shots then
			self.state = "waiting_to_shoot"
			self._time_to_shoot = arg_5_2 + 0.1
			self._extra_buff_shot = true
		else
			self.state = "shot"
		end

		local _first_person_extension = self._first_person_extension

		if not self._current_action.reset_aim_on_attack then
			_first_person_extension:reset_aim_assist_multiplier()
		end

		local fire_sound_event = self._current_action.fire_sound_event

		if not fire_sound_event then
			_first_person_extension:play_hud_sound_event(fire_sound_event)
		end
	end

	if not (not self.time_to_reload and not (arg_5_2 > self.time_to_reload)) then
		self:_reload()

		self.time_to_reload = nil
	end
end

ActionThrownProjectile.finish = function (self, arg_6_1, arg_6_2)
	-- function 6
	if self.state == "waiting_to_shoot" then
		self:_fire()
		self:_use_ammo()
		self:_reload()

		self.state = "shot"
	end

	if not (not arg_6_2 and arg_6_2.new_action ~= "action_two" or arg_6_2.new_sub_action == "default") then
		self._status_extension:set_zooming(false)
	end

	local _hud_extension = self._hud_extension

	if not _hud_extension then
		_hud_extension.show_critical_indication = false
	end
end

ActionThrownProjectile._fire = function (self, arg_7_1)
	-- function 7
	local _current_action = self._current_action
	local owner_unit = self.owner_unit
	local _first_person_extension = self._first_person_extension
	local speed = _current_action.speed
	local get_projectile_start_position_rotation, var_7_5 = _first_person_extension:get_projectile_start_position_rotation()
	local _spread_extension = self._spread_extension

	if not _spread_extension then
		var_7_5 = _spread_extension:get_randomised_spread(var_7_5)

		if not arg_7_1 then
			_spread_extension:set_shooting()
		end
	end

	local pitch_from_rotation = ActionUtils.pitch_from_rotation(var_7_5)
	local normalize = Vector3.normalize(Vector3.flat(Quaternion.forward(var_7_5)))
	local lookup_data = _current_action.lookup_data

	ActionUtils.spawn_player_projectile(owner_unit, get_projectile_start_position_rotation, var_7_5, 0, pitch_from_rotation, normalize, speed, self.item_name, lookup_data.item_template_name, lookup_data.action_name, lookup_data.sub_action_name, self._is_critical_strike, self._power_level)

	if not _current_action.alert_sound_range_fire then
		Managers.state.entity:system("ai_system"):alert_enemies_within_range(owner_unit, POSITION_LOOKUP[owner_unit], _current_action.alert_sound_range_fire)
	end
end
