-- chunkname: @scripts/unit_extensions/weapons/actions/action_handgun.lua

ActionHandgun = class(ActionHandgun, ActionBase)

ActionHandgun.init = function (self, arg_1_1, arg_1_2, arg_1_3, arg_1_4, arg_1_5, arg_1_6, arg_1_7, arg_1_8)
	-- function 1
	ActionHandgun.super.init(self, arg_1_1, arg_1_2, arg_1_3, arg_1_4, arg_1_5, arg_1_6, arg_1_7, arg_1_8)

	self.trail_end_position_variable = World.find_particles_variable(arg_1_1, "fx/wpnfx_pistol_bullet_trail", "size")
	self.career_extension = ScriptUnit.extension(self.owner_unit, "career_system")
end

ActionHandgun.client_owner_start_action = function (self, arg_2_1, arg_2_2, arg_2_3, arg_2_4)
	-- function 2
	ActionHandgun.super.client_owner_start_action(self, arg_2_1, arg_2_2, arg_2_3, arg_2_4)

	local weapon_unit = self.weapon_unit
	local owner_unit = self.owner_unit
	local is_critical_strike = ActionUtils.is_critical_strike(owner_unit, arg_2_1, arg_2_2)
	local extension = ScriptUnit.extension(owner_unit, "buff_system")

	self.current_action = arg_2_1
	self.power_level = arg_2_4

	if not arg_2_1.use_beam_consecutive_hits and not arg_2_3 and not arg_2_3.beam_consecutive_hits then
		self.charge_multiplier = 0.3 + 0.7 * math.clamp(arg_2_3.beam_consecutive_hits / 3, 0, 1)
		self.power_level = self.power_level * self.charge_multiplier
	end

	self.owner_buff_extension = extension

	if not Managers.player:owner(self.owner_unit).bot_player then
		Managers.state.controller_features:add_effect("rumble", {
			rumble_effect = "light_swing"
		})
	end

	if not ScriptUnit.has_extension(weapon_unit, "ammo_system") then
		self.ammo_extension = ScriptUnit.extension(weapon_unit, "ammo_system")
	end

	if not ScriptUnit.has_extension(weapon_unit, "spread_system") then
		self.spread_extension = ScriptUnit.extension(weapon_unit, "spread_system")
	end

	local spread_template_override = arg_2_1.spread_template_override

	if not spread_template_override then
		self.spread_extension:override_spread_template(spread_template_override)
	end

	self.overcharge_extension = ScriptUnit.extension(owner_unit, "overcharge_system")
	self.state = "waiting_to_shoot"
	self.time_to_shoot = arg_2_2 + arg_2_1.fire_time
	self.extra_buff_shot = false
	self.ammo_usage = arg_2_1.ammo_usage
	self.overcharge_type = arg_2_1.overcharge_type
	self.uses_ability_cooldown = arg_2_1.use_ability_cooldown
	self.used_ammo = false

	local active_reload_time = arg_2_1.active_reload_time

	active_reload_time = not active_reload_time and arg_2_2 + arg_2_1.active_reload_time
	self.active_reload_time = active_reload_time

	local has_extension = ScriptUnit.has_extension(owner_unit, "hud_system")

	self:_handle_critical_strike(is_critical_strike, extension, has_extension, nil, "on_critical_shot", nil)

	self._is_critical_strike = is_critical_strike
end

ActionHandgun.client_owner_post_update = function (self, arg_3_1, arg_3_2, arg_3_3, arg_3_4)
	-- function 3
	local weapon_unit = self.weapon_unit
	local owner_unit = self.owner_unit
	local current_action = self.current_action

	if not (self.state ~= "waiting_to_shoot" or not (arg_3_2 >= self.time_to_shoot)) then
		self.state = "shooting"

		if not self.ammo_extension and self.extra_buff_shot or not self.ammo_usage then
			local ammo_usage = self.ammo_usage

			self.ammo_extension:use_ammo(ammo_usage)
		end

		local overcharge_type = self.overcharge_type

		if not overcharge_type then
			local var_3_5 = PlayerUnitStatusSettings.overcharge_values[overcharge_type]
			local charge_multiplier = self.charge_multiplier

			charge_multiplier = charge_multiplier or 1

			local num = var_3_5 * charge_multiplier
			local extension = ScriptUnit.extension(owner_unit, "buff_system")

			if not self._is_critical_strike and not extension:has_buff_perk("no_overcharge_crit") then
				num = 0
			end

			self.overcharge_extension:add_charge(num)
		end

		if not self.uses_ability_cooldown then
			self.career_extension:reduce_activated_ability_cooldown(-self.ammo_usage)
		end
	end

	if self.state == "shooting" then
		local flag = not self.extra_buff_shot

		if not self:_update_extra_shots(self.owner_buff_extension, 1) then
			self.state = "waiting_to_shoot"
			self.time_to_shoot = arg_3_2 + 0.1
			self.extra_buff_shot = true
		else
			self.state = "shot"
		end

		if not Managers.player:owner(self.owner_unit).bot_player then
			Managers.state.controller_features:add_effect("rumble", {
				rumble_effect = "handgun_fire"
			})
		end

		local extension_2 = ScriptUnit.extension(owner_unit, "first_person_system")
		local get_projectile_start_position_rotation, var_3_12 = extension_2:get_projectile_start_position_rotation()

		if not current_action.fire_at_gaze_setting and not ScriptUnit.has_extension(owner_unit, "eyetracking_system") then
			local extension_3 = ScriptUnit.extension(owner_unit, "eyetracking_system")

			if not extension_3:get_is_feature_enabled("tobii_fire_at_gaze") then
				var_3_12 = extension_3:gaze_rotation()
			end
		end

		local spread_extension = self.spread_extension

		if not spread_extension then
			var_3_12 = spread_extension:get_randomised_spread(var_3_12)

			if not flag then
				spread_extension:set_shooting()
			end
		end

		local get_data = World.get_data(arg_3_3, "physics_world")
		local aim_assist_auto_hit_chance = current_action.aim_assist_auto_hit_chance

		aim_assist_auto_hit_chance = aim_assist_auto_hit_chance or 0

		local var_3_17

		if (not (aim_assist_auto_hit_chance >= math.random()) or not Managers.input:is_device_active("gamepad")) and not ScriptUnit.has_extension(owner_unit, "smart_targeting_system") then
			local target_position = ScriptUnit.extension(owner_unit, "smart_targeting_system"):get_targeting_data().target_position

			if not target_position then
				var_3_17 = Vector3.normalize(target_position - get_projectile_start_position_rotation)
			end
		end

		var_3_17 = var_3_17 or Quaternion.forward(var_3_12)

		local var_3_19

		if not current_action.projectile_info then
			local pitch_from_rotation = ActionUtils.pitch_from_rotation(var_3_12)
			local speed = current_action.speed
			local normalize = Vector3.normalize(Vector3.flat(Quaternion.forward(var_3_12)))
			local lookup_data = current_action.lookup_data

			ActionUtils.spawn_player_projectile(owner_unit, get_projectile_start_position_rotation, var_3_12, 0, pitch_from_rotation, normalize, speed, self.item_name, lookup_data.item_template_name, lookup_data.action_name, lookup_data.sub_action_name, self._is_critical_strike, self.power_level)
		else
			if not current_action.ray_against_large_hitbox then
				var_3_19 = PhysicsWorld.immediate_raycast_actors(get_data, get_projectile_start_position_rotation, var_3_17, "static_collision_filter", "filter_player_ray_projectile_static_only", "dynamic_collision_filter", "filter_player_ray_projectile_ai_only", "dynamic_collision_filter", "filter_player_ray_projectile_hitbox_only", "dynamic_collision_filter", "filter_enemy_trigger")
			else
				var_3_19 = PhysicsWorld.immediate_raycast_actors(get_data, get_projectile_start_position_rotation, var_3_17, "static_collision_filter", "filter_player_ray_projectile_static_only", "dynamic_collision_filter", "filter_player_ray_projectile_ai_only", "dynamic_collision_filter", "filter_player_ray_projectile_hitbox_only")
			end

			local is_server = self.is_server

			if not var_3_19 then
				DamageUtils.process_projectile_hit(arg_3_3, self.item_name, owner_unit, is_server, var_3_19, current_action, var_3_17, true, nil, nil, self._is_critical_strike, self.power_level)
			end
		end

		if not self.current_action.reset_aim_on_attack then
			extension_2:reset_aim_assist_multiplier()
		end

		local fire_sound_event = self.current_action.fire_sound_event

		if not fire_sound_event then
			extension_2:play_hud_sound_event(fire_sound_event)
		end

		if not current_action.alert_sound_range_fire then
			Managers.state.entity:system("ai_system"):alert_enemies_within_range(owner_unit, POSITION_LOOKUP[owner_unit], current_action.alert_sound_range_fire)
		end

		local var_3_26

		if not var_3_19 then
			var_3_26 = var_3_19[#var_3_19][1]

			if not var_3_26 then
				-- Nothing
			end
		end

		var_3_26 = get_projectile_start_position_rotation + var_3_17 * 100

		::label_3_0::

		Unit.set_flow_variable(weapon_unit, "hit_position", var_3_26)
		Unit.set_flow_variable(weapon_unit, "trail_life", Vector3.length(var_3_26 - get_projectile_start_position_rotation) * 0.1)
		Unit.flow_event(weapon_unit, "lua_bullet_trail")
		Unit.flow_event(weapon_unit, "lua_bullet_trail_set")
	end

	if self.state ~= "shot" or not self.active_reload_time then
		local extension_4 = ScriptUnit.extension(owner_unit, "input_system")

		if arg_3_2 > self.active_reload_time then
			local ammo_extension = self.ammo_extension

			if extension_4:get("weapon_reload") or not extension_4:get_buffer("weapon_reload") or not ammo_extension:can_reload() then
				ScriptUnit.extension(owner_unit, "status_system"):set_zooming(false)
				ScriptUnit.extension(weapon_unit, "weapon_system"):stop_action("reload")
			end
		elseif not extension_4:get("weapon_reload") then
			extension_4:add_buffer("weapon_reload", 0)
		end
	end
end

ActionHandgun.finish = function (self, arg_4_1)
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
			ammo_extension:start_reload(true)
		end
	end

	if not current_action.keep_block then
		if not LEVEL_EDITOR_TEST then
			local go_id = Managers.state.unit_storage:go_id(owner_unit)

			if not self.is_server then
				Managers.state.network.network_transmit:send_rpc_clients("rpc_set_blocking", go_id, false)
			else
				Managers.state.network.network_transmit:send_rpc_server("rpc_set_blocking", go_id, false)
			end
		end

		ScriptUnit.extension(owner_unit, "status_system"):set_blocking(false)
	end

	self.charge_multiplier = nil

	local has_extension = ScriptUnit.has_extension(owner_unit, "hud_system")

	if not has_extension then
		has_extension.show_critical_indication = false
	end

	if not self.spread_extension then
		self.spread_extension:reset_spread_template()
	end
end
