-- chunkname: @scripts/unit_extensions/weapons/actions/action_shotgun.lua

ActionShotgun = class(ActionShotgun, ActionBase)

local set_flow_variable = Unit.set_flow_variable
local flow_event = Unit.flow_event
local num = 3

ActionShotgun.init = function (self, arg_1_1, arg_1_2, arg_1_3, arg_1_4, arg_1_5, arg_1_6, arg_1_7, arg_1_8)
	-- function 1
	ActionShotgun.super.init(self, arg_1_1, arg_1_2, arg_1_3, arg_1_4, arg_1_5, arg_1_6, arg_1_7, arg_1_8)

	if not ScriptUnit.has_extension(arg_1_7, "ammo_system") then
		self.ammo_extension = ScriptUnit.extension(arg_1_7, "ammo_system")
	end

	self.spread_extension = ScriptUnit.extension(arg_1_7, "spread_system")
	self.overcharge_extension = ScriptUnit.extension(arg_1_4, "overcharge_system")
	self.start_gaze_rotation = QuaternionBox()
	self._fire_position = Vector3Box()
	self._fire_rotation = QuaternionBox()
end

ActionShotgun.client_owner_start_action = function (self, arg_2_1, arg_2_2, arg_2_3, arg_2_4)
	-- function 2
	ActionShotgun.super.client_owner_start_action(self, arg_2_1, arg_2_2, arg_2_3, arg_2_4)

	self.current_action = arg_2_1
	self.state = "waiting_to_shoot"
	self.time_to_shoot = arg_2_2 + arg_2_1.fire_time

	local active_reload_time = arg_2_1.active_reload_time

	active_reload_time = not active_reload_time and arg_2_2 + arg_2_1.active_reload_time
	self.active_reload_time = active_reload_time

	local owner_unit = self.owner_unit
	local is_critical_strike = ActionUtils.is_critical_strike(owner_unit, arg_2_1, arg_2_2)
	local extension = ScriptUnit.extension(owner_unit, "buff_system")

	self.infinite_ammo = extension:has_buff_perk("infinite_ammo")
	self.power_level = arg_2_4
	self.owner_buff_extension = extension

	local has_extension = ScriptUnit.has_extension(owner_unit, "hud_system")

	self:_handle_critical_strike(is_critical_strike, extension, has_extension, nil, "on_critical_shot", nil)

	self._is_critical_strike = is_critical_strike

	local spread_template_override = arg_2_1.spread_template_override

	if not spread_template_override then
		self.spread_extension:override_spread_template(spread_template_override)
	end

	self._shots_fired = 0
	self._check_buffs = true
	self._spread_done = false
	self.extra_buff_shot = false
	self.shield_users_blocking = {}

	local var_2_6 = rawget(_G, "Tobii")

	var_2_6 = not var_2_6 and Application.user_setting("tobii_eyetracking")

	if not var_2_6 and not arg_2_1.fire_at_gaze_setting and not Application.user_setting("tobii_fire_at_gaze") then
		local has_extension_2 = ScriptUnit.has_extension(owner_unit, "eyetracking_system")

		if not has_extension_2 then
			self.start_gaze_rotation:store(has_extension_2:gaze_rotation())
		end
	end
end

ActionShotgun._use_ammo = function (self)
	-- function 3
	local current_action = self.current_action
	local ammo_extension = self.ammo_extension
	local ammo_usage = current_action.ammo_usage
	local shot_count = current_action.shot_count

	shot_count = shot_count or 1

	if not current_action.special_ammo_thing then
		ammo_usage = ammo_extension:current_ammo()
		shot_count = ammo_usage
	end

	if not ammo_extension then
		ammo_extension:use_ammo(ammo_usage)
	end

	self._num_shots_total = shot_count
end

ActionShotgun._add_overcharge = function (self)
	-- function 4
	local overcharge_type = self.current_action.overcharge_type

	if not overcharge_type then
		local var_4_1 = PlayerUnitStatusSettings.overcharge_values[overcharge_type]
		local owner_unit = self.owner_unit
		local extension = ScriptUnit.extension(owner_unit, "buff_system")

		if not self._is_critical_strike and not extension:has_buff_perk("no_overcharge_crit") then
			var_4_1 = 0
		end

		self.overcharge_extension:add_charge(var_4_1)
	end
end

ActionShotgun._start_shooting = function (self)
	-- function 5
	local owner_unit = self.owner_unit
	local current_action = self.current_action
	local extension = ScriptUnit.extension(owner_unit, "first_person_system")
	local get_projectile_start_position_rotation, var_5_4 = extension:get_projectile_start_position_rotation()

	if not current_action.fire_at_gaze_setting and not ScriptUnit.has_extension(owner_unit, "eyetracking_system") and not ScriptUnit.extension(owner_unit, "eyetracking_system"):get_is_feature_enabled("tobii_fire_at_gaze") then
		var_5_4 = self.start_gaze_rotation:unbox()
	end

	self._fire_position:store(get_projectile_start_position_rotation)
	self._fire_rotation:store(var_5_4)

	if not Managers.player:owner(self.owner_unit).bot_player then
		Managers.state.controller_features:add_effect("rumble", {
			rumble_effect = "handgun_fire"
		})
	end

	if not self.extra_buff_shot then
		self:_use_ammo()
		self:_add_overcharge()
	end

	if not current_action.alert_sound_range_fire then
		Managers.state.entity:system("ai_system"):alert_enemies_within_range(owner_unit, POSITION_LOOKUP[owner_unit], current_action.alert_sound_range_fire)
	end

	local fire_sound_event = self.current_action.fire_sound_event

	if not fire_sound_event then
		extension:play_hud_sound_event(fire_sound_event)
	end

	self.state = "shooting"
end

ActionShotgun._shooting = function (self, arg_6_1, arg_6_2)
	-- function 6
	local _num_shots_total = self._num_shots_total
	local num_2 = _num_shots_total - self._shots_fired

	if not arg_6_2 then
		num_2 = math.min(num_2, num)
	end

	local _update_extra_shots = self:_update_extra_shots(self.owner_buff_extension)

	self:_shoot(_num_shots_total, num_2)

	if self._num_shots_total - self._shots_fired <= 0 then
		if not _update_extra_shots then
			self._num_shots_total = _num_shots_total + _update_extra_shots

			self:_update_extra_shots(self.owner_buff_extension, _update_extra_shots)

			self.state = "waiting_to_shoot"
			self.time_to_shoot = arg_6_1 + 0.15
			self.extra_buff_shot = true
		else
			self.state = "shot"
		end
	end
end

ActionShotgun._shoot = function (self, arg_7_1, arg_7_2)
	-- function 7
	local current_action = self.current_action
	local unbox = self._fire_position:unbox()
	local unbox_2 = self._fire_rotation:unbox()
	local world = self.world
	local physics_world = self.physics_world
	local _check_buffs = self._check_buffs
	local num_layers_spread = current_action.num_layers_spread

	num_layers_spread = num_layers_spread or 1

	local bullseye = current_action.bullseye

	bullseye = bullseye or false

	local spread_pitch = current_action.spread_pitch

	spread_pitch = spread_pitch or 0.8

	local weapon_unit = self.weapon_unit
	local item_name = self.item_name
	local owner_unit = self.owner_unit
	local is_server = self.is_server

	for i = 1, arg_7_2 do
		self._shots_fired = self._shots_fired + 1

		local _get_spread_rotation = self:_get_spread_rotation(arg_7_1, unbox_2, num_layers_spread, bullseye, spread_pitch)
		local forward = Quaternion.forward(_get_spread_rotation)
		local immediate_raycast_actors = PhysicsWorld.immediate_raycast_actors(physics_world, unbox, forward, current_action.range, "static_collision_filter", "filter_player_ray_projectile_static_only", "dynamic_collision_filter", "filter_player_ray_projectile_ai_only", "dynamic_collision_filter", "filter_player_ray_projectile_hitbox_only")

		if not immediate_raycast_actors then
			local process_projectile_hit = DamageUtils.process_projectile_hit(world, item_name, owner_unit, is_server, immediate_raycast_actors, current_action, forward, _check_buffs, nil, self.shield_users_blocking, self._is_critical_strike, self.power_level)

			if not process_projectile_hit.buffs_checked then
				_check_buffs = not _check_buffs and false
			end

			if not process_projectile_hit.blocked_by_unit then
				self.shield_users_blocking[process_projectile_hit.blocked_by_unit] = true
			end
		end

		local var_7_17

		if not immediate_raycast_actors then
			var_7_17 = immediate_raycast_actors[#immediate_raycast_actors][1]

			if not var_7_17 then
				-- Nothing
			end
		end

		var_7_17 = unbox + forward * current_action.range

		::label_7_0::

		set_flow_variable(weapon_unit, "hit_position", var_7_17)
		set_flow_variable(weapon_unit, "trail_life", Vector3.length(var_7_17 - unbox) * 0.1)
		flow_event(weapon_unit, "lua_bullet_trail")
		flow_event(weapon_unit, "lua_bullet_trail_set")
	end

	self._check_buffs = _check_buffs
end

ActionShotgun.client_owner_post_update = function (self, arg_8_1, arg_8_2, arg_8_3, arg_8_4)
	-- function 8
	local owner_unit = self.owner_unit

	if not (self.state ~= "waiting_to_shoot" or not (arg_8_2 >= self.time_to_shoot)) then
		self.state = "start_shooting"
	end

	if self.state == "start_shooting" then
		self:_start_shooting()
	end

	if self.state == "shooting" then
		self:_shooting(arg_8_2, false)
	end

	if self.state ~= "shot" or not self.active_reload_time then
		local flag = not self.extra_buff_shot

		if not (not self.spread_extension and not flag and self._spread_done) then
			self.spread_extension:set_shooting()

			self._spread_done = true
		end

		local extension = ScriptUnit.extension(owner_unit, "input_system")

		if arg_8_2 > self.active_reload_time then
			local ammo_extension = self.ammo_extension

			if extension:get("weapon_reload") or not extension:get_buffer("weapon_reload") or not ammo_extension:can_reload() then
				ScriptUnit.extension(self.weapon_unit, "weapon_system"):stop_action("reload")
			end
		elseif not extension:get("weapon_reload") then
			extension:add_buffer("weapon_reload", 0)
		end
	end
end

ActionShotgun.reload = function (self, arg_9_1)
	-- function 9
	local ammo_extension = self.ammo_extension

	if not ammo_extension then
		return
	end

	local reload_when_out_of_ammo_condition_func = arg_9_1.reload_when_out_of_ammo_condition_func
	local flag

	flag = reload_when_out_of_ammo_condition_func or not true or reload_when_out_of_ammo_condition_func(self.owner_unit)

	if not (not ammo_extension:can_reload() and not arg_9_1.reload_when_out_of_ammo and not flag and ammo_extension:ammo_count() ~= 0) then
		local play_reload_animation = arg_9_1.play_reload_animation

		ammo_extension:start_reload(play_reload_animation, arg_9_1.override_reload_time)
	end
end

ActionShotgun.finish = function (self, arg_10_1)
	-- function 10
	if self.state == "start_shooting" then
		self:_start_shooting()
	end

	if self.state == "shooting" then
		local time = Managers.time:time("game")

		self:_shooting(time, true)
	end

	if not (self.state ~= "shot" or arg_10_1 ~= "charged") then
		self:reload(self.current_action)
	end

	if not self.spread_extension then
		self.spread_extension:reset_spread_template()
	end

	local has_extension = ScriptUnit.has_extension(self.owner_unit, "hud_system")

	if not has_extension then
		has_extension.show_critical_indication = false
	end
end

ActionShotgun._get_spread_rotation = function (self, arg_11_1, arg_11_2, arg_11_3, arg_11_4, arg_11_5)
	-- function 11
	local spread_extension = self.spread_extension

	if not spread_extension then
		return spread_extension:get_target_style_spread(self._shots_fired, arg_11_1, arg_11_2, arg_11_3, arg_11_4, arg_11_5)
	else
		return arg_11_2
	end
end
