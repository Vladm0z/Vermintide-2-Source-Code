-- chunkname: @scripts/unit_extensions/weapons/actions/action_bow.lua

ActionBow = class(ActionBow, ActionBase)

ActionBow.init = function (self, arg_1_1, arg_1_2, arg_1_3, arg_1_4, arg_1_5, arg_1_6, arg_1_7, arg_1_8)
	-- function 1
	ActionBow.super.init(self, arg_1_1, arg_1_2, arg_1_3, arg_1_4, arg_1_5, arg_1_6, arg_1_7, arg_1_8)

	if not ScriptUnit.has_extension(arg_1_7, "ammo_system") then
		self.ammo_extension = ScriptUnit.extension(arg_1_7, "ammo_system")
	end

	self.spread_extension = ScriptUnit.extension(arg_1_7, "spread_system")
end

ActionBow.client_owner_start_action = function (self, arg_2_1, arg_2_2, arg_2_3, arg_2_4)
	-- function 2
	ActionBow.super.client_owner_start_action(self, arg_2_1, arg_2_2, arg_2_3, arg_2_4)

	local owner_unit = self.owner_unit
	local is_critical_strike = ActionUtils.is_critical_strike(owner_unit, arg_2_1, arg_2_2)
	local extension = ScriptUnit.extension(owner_unit, "buff_system")

	self.owner_buff_extension = extension
	self.current_action = arg_2_1
	self.power_level = arg_2_4

	ScriptUnit.extension(owner_unit, "input_system"):reset_input_buffer()

	self.state = "waiting_to_shoot"

	local fire_time = arg_2_1.fire_time

	fire_time = fire_time or 0
	self.time_to_shoot = arg_2_2 + fire_time

	local num

	if not arg_2_1.unzoom_time then
		num = arg_2_2 + arg_2_1.unzoom_time

		if not num then
			-- Nothing
		end
	end

	num = nil

	::label_2_0::

	self.time_to_unzoom = num
	self.extra_buff_shot = false

	local has_extension = ScriptUnit.has_extension(owner_unit, "hud_system")

	self:_handle_critical_strike(is_critical_strike, extension, has_extension, nil, "on_critical_shot", nil)

	self._is_critical_strike = is_critical_strike
end

ActionBow.reload = function (self, arg_3_1)
	-- function 3
	if not self.ammo_extension:can_reload() then
		local play_reload_animation = arg_3_1.play_reload_animation

		self.ammo_extension:start_reload(play_reload_animation, arg_3_1.override_reload_time)

		self.time_to_reload = nil
	end
end

ActionBow.client_owner_post_update = function (self, arg_4_1, arg_4_2, arg_4_3, arg_4_4)
	-- function 4
	local current_action = self.current_action

	if not (not self.time_to_unzoom and not (arg_4_2 >= self.time_to_unzoom)) then
		local owner_unit = self.owner_unit

		ScriptUnit.extension(owner_unit, "status_system"):set_zooming(false)
	end

	if not (self.state ~= "waiting_to_shoot" or not (arg_4_2 >= self.time_to_shoot)) then
		self.state = "shooting"
	end

	if self.state == "shooting" then
		local flag = not self.extra_buff_shot

		if not Managers.player:owner(self.owner_unit).bot_player then
			Managers.state.controller_features:add_effect("rumble", {
				rumble_effect = "bow_fire"
			})
		end

		local flag_2 = not not current_action.career_skill or self:_update_extra_shots(self.owner_buff_extension, 1)

		self:fire(current_action, flag)

		if not (not self.ammo_extension and self.extra_buff_shot) then
			local ammo_usage = self.current_action.ammo_usage

			self.ammo_extension:use_ammo(ammo_usage)

			if not current_action.reload_event_delay_time then
				self.time_to_reload = arg_4_2 + current_action.reload_event_delay_time
			else
				self:reload(current_action)
			end
		end

		if not flag_2 then
			self.state = "waiting_to_shoot"
			self.time_to_shoot = arg_4_2 + 0.1
			self.extra_buff_shot = true
		else
			self.state = "shot"
		end

		local extension = ScriptUnit.extension(self.owner_unit, "first_person_system")

		if not self.current_action.reset_aim_on_attack then
			extension:reset_aim_assist_multiplier()
		end

		local fire_sound_event = self.current_action.fire_sound_event

		if not fire_sound_event then
			extension:play_hud_sound_event(fire_sound_event)
		end
	end

	if not (not self.time_to_reload and not (arg_4_2 > self.time_to_reload)) then
		self:reload(current_action)

		self.time_to_reload = nil
	end
end

ActionBow.finish = function (self, arg_5_1, arg_5_2)
	-- function 5
	local current_action = self.current_action
	local owner_unit = self.owner_unit

	if self.state == "waiting_to_shoot" then
		self:fire(current_action)

		self.state = "shot"

		if not (not self.ammo_extension and self.extra_buff_shot) then
			local ammo_usage = current_action.ammo_usage

			self.ammo_extension:use_ammo(ammo_usage)
		end

		self:reload(current_action)
	end

	if not self.time_to_reload then
		self:reload(current_action)
	end

	if not (not arg_5_2 and arg_5_2.new_action ~= "action_two" or arg_5_2.new_sub_action == "default") then
		ScriptUnit.extension(owner_unit, "status_system"):set_zooming(false)
	end

	local has_extension = ScriptUnit.has_extension(owner_unit, "hud_system")

	if not has_extension then
		has_extension.show_critical_indication = false
	end
end

ActionBow.fire = function (self, arg_6_1, arg_6_2)
	-- function 6
	local owner_unit = self.owner_unit
	local extension = ScriptUnit.extension(owner_unit, "first_person_system")
	local speed = arg_6_1.speed
	local get_projectile_start_position_rotation, var_6_4 = extension:get_projectile_start_position_rotation()
	local spread_extension = self.spread_extension

	if not spread_extension then
		var_6_4 = spread_extension:get_randomised_spread(var_6_4)

		if not arg_6_2 then
			spread_extension:set_shooting()
		end
	end

	local pitch_from_rotation = ActionUtils.pitch_from_rotation(var_6_4)
	local normalize = Vector3.normalize(Vector3.flat(Quaternion.forward(var_6_4)))
	local lookup_data = arg_6_1.lookup_data

	ActionUtils.spawn_player_projectile(owner_unit, get_projectile_start_position_rotation, var_6_4, 0, pitch_from_rotation, normalize, speed, self.item_name, lookup_data.item_template_name, lookup_data.action_name, lookup_data.sub_action_name, self._is_critical_strike, self.power_level)

	if not arg_6_1.alert_sound_range_fire then
		Managers.state.entity:system("ai_system"):alert_enemies_within_range(owner_unit, POSITION_LOOKUP[owner_unit], arg_6_1.alert_sound_range_fire)
	end
end
