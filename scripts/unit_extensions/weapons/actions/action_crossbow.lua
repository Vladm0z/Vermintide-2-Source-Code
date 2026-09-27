-- chunkname: @scripts/unit_extensions/weapons/actions/action_crossbow.lua

ActionCrossbow = class(ActionCrossbow, ActionBase)

ActionCrossbow.init = function (self, arg_1_1, arg_1_2, arg_1_3, arg_1_4, arg_1_5, arg_1_6, arg_1_7, arg_1_8)
	-- function 1
	ActionCrossbow.super.init(self, arg_1_1, arg_1_2, arg_1_3, arg_1_4, arg_1_5, arg_1_6, arg_1_7, arg_1_8)

	if not ScriptUnit.has_extension(arg_1_7, "ammo_system") then
		self.ammo_extension = ScriptUnit.extension(arg_1_7, "ammo_system")
	end

	self.spread_extension = ScriptUnit.extension(arg_1_7, "spread_system")
end

ActionCrossbow.client_owner_start_action = function (self, arg_2_1, arg_2_2, arg_2_3, arg_2_4)
	-- function 2
	ActionCrossbow.super.client_owner_start_action(self, arg_2_1, arg_2_2, arg_2_3, arg_2_4)

	local owner_unit = self.owner_unit
	local is_critical_strike = ActionUtils.is_critical_strike(owner_unit, arg_2_1, arg_2_2)
	local extension = ScriptUnit.extension(owner_unit, "buff_system")

	self.power_level = arg_2_4
	self.owner_buff_extension = extension
	self.current_action = arg_2_1
	self.num_projectiles = arg_2_1.num_projectiles

	local multi_projectile_spread = arg_2_1.multi_projectile_spread

	multi_projectile_spread = multi_projectile_spread or 0.075
	self.multi_projectile_spread = multi_projectile_spread

	if not self.ammo_extension and not self.num_projectiles then
		self.num_projectiles = math.min(self.num_projectiles, self.ammo_extension:current_ammo())
	end

	self.num_projectiles_shot = 1
	self.state = "waiting_to_shoot"

	local fire_time = arg_2_1.fire_time

	fire_time = fire_time or 0
	self.time_to_shoot = arg_2_2 + fire_time
	self.extra_buff_shot = false

	local active_reload_time = arg_2_1.active_reload_time

	active_reload_time = not active_reload_time and arg_2_2 + arg_2_1.active_reload_time
	self.active_reload_time = active_reload_time

	local has_extension = ScriptUnit.has_extension(owner_unit, "hud_system")

	self:_handle_critical_strike(is_critical_strike, extension, has_extension, nil, "on_critical_shot", nil)

	self._is_critical_strike = is_critical_strike

	local unhide_ammo_on_infinite_ammo = arg_2_1.unhide_ammo_on_infinite_ammo

	unhide_ammo_on_infinite_ammo = not unhide_ammo_on_infinite_ammo and extension:has_buff_perk("infinite_ammo")
	self._unhide_ammo_at_action_end = unhide_ammo_on_infinite_ammo
end

ActionCrossbow.client_owner_post_update = function (self, arg_3_1, arg_3_2, arg_3_3, arg_3_4)
	-- function 3
	if not (self.state ~= "waiting_to_shoot" or not (arg_3_2 >= self.time_to_shoot)) then
		self.state = "shooting"
	end

	if self.state == "shooting" then
		local owner_unit = self.owner_unit
		local flag = not self.extra_buff_shot

		if not Managers.player:owner(self.owner_unit).bot_player then
			Managers.state.controller_features:add_effect("rumble", {
				rumble_effect = "crossbow_fire"
			})
		end

		local extension = ScriptUnit.extension(owner_unit, "first_person_system")
		local get_projectile_start_position_rotation, var_3_4 = extension:get_projectile_start_position_rotation()
		local spread_extension = self.spread_extension
		local current_action = self.current_action

		if not self.num_projectiles then
			for i = 1, self.num_projectiles do
				local var_3_7 = var_3_4
				local speed = current_action.speed

				if not spread_extension then
					if not (not current_action.burst and current_action.no_burst_spread) then
						if not spread_extension then
							var_3_7 = spread_extension:get_randomised_spread(var_3_4)
						end
					elseif not (not (self.num_projectiles_shot > 1) or current_action.burst) then
						local num = math.pi * (self.num_projectiles_shot % 2 + 0.5)
						local flag_2

						flag_2 = self.num_projectiles_shot ~= 1 or not 0 or math.round((self.num_projectiles_shot - 1) / 2, 0)

						local num_2 = self.multi_projectile_spread * flag_2

						var_3_7 = spread_extension:combine_spread_rotations(num, num_2, var_3_7)
					end

					if not flag then
						spread_extension:set_shooting()
					end
				end

				local pitch_from_rotation = ActionUtils.pitch_from_rotation(var_3_7)
				local normalize = Vector3.normalize(Vector3.flat(Quaternion.forward(var_3_7)))
				local lookup_data = current_action.lookup_data

				ActionUtils.spawn_player_projectile(owner_unit, get_projectile_start_position_rotation, var_3_7, 0, pitch_from_rotation, normalize, speed, self.item_name, lookup_data.item_template_name, lookup_data.action_name, lookup_data.sub_action_name, self._is_critical_strike, self.power_level)

				local fire_sound_event = current_action.fire_sound_event

				if not fire_sound_event then
					extension:play_hud_sound_event(fire_sound_event)
				end

				local unit_fire_sound_event = current_action.unit_fire_sound_event

				if not unit_fire_sound_event then
					local unit_fire_sound_source_node = current_action.unit_fire_sound_source_node
					local weapon_unit = self.weapon_unit
					local num_3 = 0

					if not Unit.has_node(weapon_unit, unit_fire_sound_source_node) then
						num_3 = Unit.node(weapon_unit, unit_fire_sound_source_node)
					end

					extension:play_unit_sound_event(unit_fire_sound_event, weapon_unit, num_3, false)
				end

				if not (not self.ammo_extension and self.extra_buff_shot) then
					local ammo_usage = current_action.ammo_usage

					self.ammo_extension:use_ammo(ammo_usage)
				end

				self.num_projectiles_shot = self.num_projectiles_shot + 1

				if not current_action.burst then
					break
				end
			end
		else
			if not spread_extension then
				var_3_4 = spread_extension:get_randomised_spread(var_3_4)

				if not flag then
					spread_extension:set_shooting()
				end
			end

			local pitch_from_rotation_2 = ActionUtils.pitch_from_rotation(var_3_4)
			local speed_2 = current_action.speed
			local normalize_2 = Vector3.normalize(Vector3.flat(Quaternion.forward(var_3_4)))
			local lookup_data_2 = current_action.lookup_data

			ActionUtils.spawn_player_projectile(owner_unit, get_projectile_start_position_rotation, var_3_4, 0, pitch_from_rotation_2, normalize_2, speed_2, self.item_name, lookup_data_2.item_template_name, lookup_data_2.action_name, lookup_data_2.sub_action_name, self._is_critical_strike, self.power_level)

			local fire_sound_event_2 = self.current_action.fire_sound_event

			if not fire_sound_event_2 then
				extension:play_hud_sound_event(fire_sound_event_2)
			end

			if not (not self.ammo_extension and self.extra_buff_shot) then
				local ammo_usage_2 = current_action.ammo_usage

				self.ammo_extension:use_ammo(ammo_usage_2)
			end
		end

		if not current_action.apply_burst_recoil then
			if self.num_projectiles_shot == 2 then
				extension:apply_recoil()
				extension:play_camera_recoil(current_action.first_recoil_settings, arg_3_2)
			else
				extension:apply_recoil()
				extension:play_camera_recoil(current_action.recoil_settings, arg_3_2)
			end
		end

		local _update_extra_shots = self:_update_extra_shots(self.owner_buff_extension)

		if not (not current_action.burst and not (self.num_projectiles >= self.num_projectiles_shot)) then
			self.state = "waiting_to_shoot"
			self.time_to_shoot = arg_3_2 + 0.075
			self.extra_buff_shot = false
		elseif not _update_extra_shots then
			self.state = "waiting_to_shoot"
			self.extra_buff_shot = true

			if not current_action.burst then
				self.time_to_shoot = arg_3_2 + 0.075
				self.num_projectiles = 1

				self:_update_extra_shots(self.owner_buff_extension, 1)
			else
				self.time_to_shoot = arg_3_2 + 0.1
				self.num_projectiles = _update_extra_shots

				self:_update_extra_shots(self.owner_buff_extension, _update_extra_shots)
			end
		else
			self.state = "shot"
		end

		extension:reset_aim_assist_multiplier()
	end

	if self.state ~= "shot" or not self.active_reload_time then
		local owner_unit_2 = self.owner_unit
		local extension_2 = ScriptUnit.extension(owner_unit_2, "input_system")

		if arg_3_2 > self.active_reload_time then
			local ammo_extension = self.ammo_extension

			if extension_2:get("weapon_reload") or not extension_2:get_buffer("weapon_reload") or not ammo_extension:can_reload() then
				ScriptUnit.extension(self.owner_unit, "status_system"):set_zooming(false)
				ScriptUnit.extension(self.weapon_unit, "weapon_system"):stop_action("reload")
			end
		elseif not extension_2:get("weapon_reload") then
			extension_2:add_buffer("weapon_reload", 0)
		end
	end
end

ActionCrossbow.finish = function (self, arg_4_1)
	-- function 4
	local ammo_extension = self.ammo_extension
	local current_action = self.current_action
	local owner_unit = self.owner_unit

	if arg_4_1 ~= "new_interupting_action" then
		ScriptUnit.extension(owner_unit, "status_system"):set_zooming(false)

		local reload_when_out_of_ammo_condition_func = current_action.reload_when_out_of_ammo_condition_func
		local flag

		flag = reload_when_out_of_ammo_condition_func or not true or reload_when_out_of_ammo_condition_func(owner_unit, arg_4_1)

		if not ammo_extension and not current_action.reload_when_out_of_ammo and not flag and ammo_extension:ammo_count() ~= 0 or not ammo_extension:can_reload() then
			local flag_2 = true

			ammo_extension:start_reload(flag_2)
		end
	end

	local has_extension = ScriptUnit.has_extension(owner_unit, "hud_system")

	if not has_extension then
		has_extension.show_critical_indication = false
	end

	if not self._unhide_ammo_at_action_end then
		Unit.flow_event(self.first_person_unit, "anim_cb_unhide_ammo")
	end
end
