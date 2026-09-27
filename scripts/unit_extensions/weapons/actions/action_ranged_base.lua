-- chunkname: @scripts/unit_extensions/weapons/actions/action_ranged_base.lua

ActionRangedBase = class(ActionRangedBase, ActionBase)

local var_0_0 = rawget(_G, "Tobii")

var_0_0 = not var_0_0 and Application.user_setting("tobii_eyetracking")

local num = 3
local has_extension = ScriptUnit.has_extension
local set_flow_variable = Unit.set_flow_variable
local flow_event = Unit.flow_event

ActionRangedBase.init = function (self, arg_1_1, arg_1_2, arg_1_3, arg_1_4, arg_1_5, arg_1_6, arg_1_7, arg_1_8)
	-- function 1
	ActionRangedBase.super.init(self, arg_1_1, arg_1_2, arg_1_3, arg_1_4, arg_1_5, arg_1_6, arg_1_7, arg_1_8)

	self.buff_extension = has_extension(arg_1_4, "buff_system")
	self.overcharge_extension = has_extension(arg_1_4, "overcharge_system")
	self.hud_extension = has_extension(arg_1_4, "hud_system")
	self.first_person_extension = has_extension(arg_1_4, "first_person_system")

	local var_1_0 = var_0_0

	var_1_0 = not var_1_0 and has_extension(arg_1_4, "eyetracking_system")
	self.eyetracking_extension = var_1_0
	self.targeting_extension = has_extension(arg_1_4, "smart_targeting_system")
	self.input_extension = has_extension(arg_1_4, "input_system")
	self.status_extension = has_extension(arg_1_4, "status_system")
	self.ammo_extension = has_extension(arg_1_7, "ammo_system")
	self.spread_extension = has_extension(arg_1_7, "spread_system")
	self._start_gaze_rotation = QuaternionBox()
	self._fire_position = Vector3Box()
	self._fire_rotation = QuaternionBox()
	self.shield_users_blocking = {}
end

ActionRangedBase.client_owner_start_action = function (self, arg_2_1, arg_2_2, arg_2_3, arg_2_4, arg_2_5)
	-- function 2
	ActionRangedBase.super.client_owner_start_action(self, arg_2_1, arg_2_2, arg_2_3, arg_2_4)

	local owner_unit = self.owner_unit
	local buff_extension = self.buff_extension
	local hud_extension = self.hud_extension

	self._state = "waiting_to_shoot"

	local fire_time = arg_2_1.fire_time

	fire_time = fire_time or 0
	self._time_to_shoot = arg_2_2 + fire_time

	local active_reload_time = arg_2_1.active_reload_time

	active_reload_time = not active_reload_time and arg_2_2 + arg_2_1.active_reload_time
	self._active_reload_time = active_reload_time
	self._power_level = arg_2_4

	if not arg_2_1.power_level then
		self._power_level = arg_2_1.power_level
	end

	self._num_shots_total, self._num_projectiles_per_shot = self:gen_num_shots()

	local extra_shot_delay = arg_2_1.extra_shot_delay

	extra_shot_delay = extra_shot_delay or 0.2
	self._extra_shot_delay = extra_shot_delay

	local burst_shot_delay = arg_2_1.burst_shot_delay

	burst_shot_delay = burst_shot_delay or 0.1
	self._burst_shot_delay = burst_shot_delay
	self._num_shots_fired = 0
	self._num_projectiles_spawned = 0
	self._check_buffs = true
	self._spread_done = false
	self._extra_buff_shot = false
	self._infinite_ammo = buff_extension:has_buff_perk("infinite_ammo")

	local continuous_buff_check = arg_2_1.continuous_buff_check

	continuous_buff_check = continuous_buff_check or false
	self._continuous_buff_check = continuous_buff_check

	local apply_shot_cost_once = arg_2_1.apply_shot_cost_once

	apply_shot_cost_once = apply_shot_cost_once or false
	self._apply_shot_cost_once = apply_shot_cost_once
	self._shot_cost_applied = false

	local roll_crit_once = arg_2_1.roll_crit_once

	roll_crit_once = roll_crit_once or false
	self._roll_crit_once = roll_crit_once
	self._crit_applied = false

	if not self.is_bot then
		local controller_effects = arg_2_1.controller_effects

		controller_effects = not controller_effects and arg_2_1.controller_effects.start

		if not controller_effects then
			Managers.state.controller_features:add_effect(controller_effects.effect_type, controller_effects.params)
		end
	end

	local spread_template_override = arg_2_1.spread_template_override

	if not spread_template_override then
		self.spread_extension:override_spread_template(spread_template_override)
	end

	local unhide_ammo_on_infinite_ammo = arg_2_1.unhide_ammo_on_infinite_ammo

	unhide_ammo_on_infinite_ammo = not unhide_ammo_on_infinite_ammo and self._infinite_ammo
	self._unhide_ammo_at_action_end = unhide_ammo_on_infinite_ammo
end

ActionRangedBase.client_owner_post_update = function (self, arg_3_1, arg_3_2, arg_3_3, arg_3_4, arg_3_5)
	-- function 3
	if self._state == "waiting_to_shoot" then
		self:_waiting_to_shoot(arg_3_1, arg_3_2)
	end

	if self._state == "start_shooting" then
		self:_start_shooting(arg_3_2)
	end

	if self._state == "shooting" then
		self:_shooting(arg_3_2, false)
	end

	if self._state == "finished_shooting" then
		self:_finished_shooting(arg_3_2)
	end
end

ActionRangedBase.finish = function (self, arg_4_1)
	-- function 4
	ActionRangedBase.super.finish(self, arg_4_1)

	if self._state == "start_shooting" then
		self:_start_shooting()
	end

	if self._state == "shooting" then
		local time = Managers.time:time("game")

		self:_shooting(time, true)
	end

	if not self.spread_extension then
		self.spread_extension:reset_spread_template()
	end

	local hud_extension = self.hud_extension

	if not hud_extension then
		hud_extension.show_critical_indication = false
	end

	if arg_4_1 ~= "new_interupting_action" then
		self.status_extension:set_zooming(false)
		self:reload()
	end

	if not self._unhide_ammo_at_action_end then
		Unit.flow_event(self.first_person_unit, "anim_cb_unhide_ammo")
	end
end

ActionRangedBase._waiting_to_shoot = function (self, arg_5_1, arg_5_2)
	-- function 5
	if arg_5_2 >= self._time_to_shoot then
		self._state = "start_shooting"
	end
end

ActionRangedBase._start_shooting = function (self, arg_6_1)
	-- function 6
	local owner_unit = self.owner_unit
	local current_action = self.current_action
	local first_person_extension = self.first_person_extension
	local var_6_3
	local var_6_4

	if not self.get_projectile_start_position_rotation then
		var_6_3, var_6_4 = self:get_projectile_start_position_rotation()
	else
		var_6_3, var_6_4 = first_person_extension:get_projectile_start_position_rotation()
	end

	local eyetracking_extension = self.eyetracking_extension

	if not current_action.fire_at_gaze_setting and not eyetracking_extension and not eyetracking_extension:get_is_feature_enabled("tobii_fire_at_gaze") then
		var_6_4 = self._start_gaze_rotation:unbox()
	end

	if not (not self._crit_applied and self._roll_crit_once) then
		local is_critical_strike = ActionUtils.is_critical_strike(owner_unit, current_action, arg_6_1)

		self:_handle_critical_strike(is_critical_strike, self.buff_extension, self.hud_extension, nil, "on_critical_shot", nil)

		self._is_critical_strike = is_critical_strike
		self._crit_applied = true
	end

	table.clear(self.shield_users_blocking)
	self._fire_position:store(var_6_3)
	self._fire_rotation:store(var_6_4)

	if not self.is_bot then
		local controller_effects = current_action.controller_effects

		controller_effects = not controller_effects and current_action.controller_effects.fire

		if not controller_effects then
			Managers.state.controller_features:add_effect(controller_effects.effect_type, controller_effects.params)
		end
	end

	if not (not self._shot_cost_applied and self._apply_shot_cost_once) then
		self:apply_shot_cost(arg_6_1)

		self._shot_cost_applied = true
	end

	self._num_projectiles_spawned = 0

	if not current_action.alert_sound_range_fire then
		Managers.state.entity:system("ai_system"):alert_enemies_within_range(owner_unit, POSITION_LOOKUP[owner_unit], current_action.alert_sound_range_fire)
	end

	local fire_sound_event = self.current_action.fire_sound_event

	if not fire_sound_event then
		first_person_extension:play_hud_sound_event(fire_sound_event)
	end

	if not self.is_bot then
		Unit.flow_event(self.weapon_unit, "lua_start_shooting")
	end

	self._state = "shooting"
end

ActionRangedBase._shooting = function (self, arg_7_1, arg_7_2)
	-- function 7
	local _num_projectiles_per_shot = self._num_projectiles_per_shot
	local _num_projectiles_spawned = self._num_projectiles_spawned
	local num_2 = _num_projectiles_per_shot - _num_projectiles_spawned

	if not arg_7_2 then
		num_2 = math.min(num_2, num)
	end

	self:_update_extra_shots(self.buff_extension)

	self._num_projectiles_spawned = self:shoot(num_2, _num_projectiles_spawned, _num_projectiles_per_shot)

	if _num_projectiles_per_shot - self._num_projectiles_spawned <= 0 then
		self._num_shots_fired = self._num_shots_fired + 1

		if self._num_shots_fired < self._num_shots_total then
			self._state = "waiting_to_shoot"
			self._time_to_shoot = arg_7_1 + self._burst_shot_delay
		elseif not self:_update_extra_shots(self.buff_extension, 1) then
			self._state = "waiting_to_shoot"
			self._time_to_shoot = arg_7_1 + self._extra_shot_delay
			self._extra_buff_shot = true
		else
			self._state = "finished_shooting"
		end
	end
end

ActionRangedBase._finished_shooting = function (self, arg_8_1)
	-- function 8
	if not self._active_reload_time then
		local flag = not self._extra_buff_shot

		if not (not self.spread_extension and not flag and self._spread_done) then
			self.spread_extension:set_shooting()

			self._spread_done = true
		end

		local input_extension = self.input_extension

		if arg_8_1 > self._active_reload_time then
			local ammo_extension = self.ammo_extension

			if input_extension:get("weapon_reload") or not input_extension:get_buffer("weapon_reload") or not ammo_extension:can_reload() then
				self.status_extension:set_zooming(false)
				ScriptUnit.extension(self.weapon_unit, "weapon_system"):stop_action("reload")
			end
		elseif not input_extension:get("weapon_reload") then
			input_extension:add_buffer("weapon_reload", 0)
		end
	end

	Unit.flow_event(self.weapon_unit, "lua_finish_shooting")
end

ActionRangedBase.shoot = function (self, arg_9_1, arg_9_2, arg_9_3)
	-- function 9
	local spread_extension = self.spread_extension
	local current_action = self.current_action
	local unbox = self._fire_position:unbox()
	local unbox_2 = self._fire_rotation:unbox()
	local num_layers_spread = current_action.num_layers_spread

	num_layers_spread = num_layers_spread or 1

	local bullseye = current_action.bullseye

	bullseye = bullseye or false

	local spread_pitch = current_action.spread_pitch

	spread_pitch = spread_pitch or 0.8

	for i = 1, arg_9_1 do
		arg_9_2 = arg_9_2 + 1

		local var_9_7 = unbox_2

		if not spread_extension then
			var_9_7 = spread_extension:get_target_style_spread(arg_9_2, arg_9_3, unbox_2, num_layers_spread, bullseye, spread_pitch)
		end

		self:spawn_projectile(unbox, var_9_7)
	end

	return arg_9_2
end

ActionRangedBase.reload = function (self, arg_10_1)
	-- function 10
	local ammo_extension = self.ammo_extension

	if not ammo_extension then
		return
	end

	local current_action = self.current_action

	if not current_action.reload_when_out_of_ammo and ammo_extension:ammo_count() ~= 0 or not ammo_extension:can_reload() then
		local owner_unit = self.owner_unit
		local reload_when_out_of_ammo_condition_func = current_action.reload_when_out_of_ammo_condition_func

		if not reload_when_out_of_ammo_condition_func and not reload_when_out_of_ammo_condition_func(owner_unit, arg_10_1) then
			ammo_extension:start_reload(current_action.play_reload_animation)
		end
	end
end

ActionRangedBase.spawn_projectile = function (self, arg_11_1, arg_11_2)
	-- function 11
	local current_action = self.current_action

	if not current_action.projectile_info then
		self:fire_projectile(arg_11_1, arg_11_2)
	elseif not current_action.lightweight_projectile_info then
		self:fire_lightweight_projectile(arg_11_1, arg_11_2)
	else
		local forward = Quaternion.forward(arg_11_2)
		local var_11_2 = self
		local fire_hitscan = self.fire_hitscan
		local var_11_4 = arg_11_1
		local var_11_5 = forward
		local range = current_action.range

		range = range or 30

		local var_11_7 = fire_hitscan(var_11_2, var_11_4, var_11_5, range)

		if not var_11_7 then
			local world = self.world
			local item_name = self.item_name
			local owner_unit = self.owner_unit
			local is_server = self.is_server
			local _check_buffs = self._check_buffs
			local _continuous_buff_check = self._continuous_buff_check
			local process_projectile_hit = DamageUtils.process_projectile_hit(world, item_name, owner_unit, is_server, var_11_7, current_action, forward, _check_buffs, nil, self.shield_users_blocking, self._is_critical_strike, self._power_level)

			if not (not process_projectile_hit.buffs_checked and not _check_buffs and _continuous_buff_check) then
				self._check_buffs = false
			end

			if not process_projectile_hit.blocked_by_unit then
				self.shield_users_blocking[process_projectile_hit.blocked_by_unit] = true
			end
		end
	end
end

ActionRangedBase.fire_projectile = function (self, arg_12_1, arg_12_2)
	-- function 12
	local owner_unit = self.owner_unit
	local current_action = self.current_action
	local pitch_from_rotation = ActionUtils.pitch_from_rotation(arg_12_2)
	local speed = current_action.speed
	local normalize = Vector3.normalize(Vector3.flat(Quaternion.forward(arg_12_2)))
	local lookup_data = current_action.lookup_data

	ActionUtils.spawn_player_projectile(owner_unit, arg_12_1, arg_12_2, 0, pitch_from_rotation, normalize, speed, self.item_name, lookup_data.item_template_name, lookup_data.action_name, lookup_data.sub_action_name, self._is_critical_strike, self._power_level)
end

ActionRangedBase.fire_lightweight_projectile = function (self, arg_13_1, arg_13_2)
	-- function 13
	local owner_unit = self.owner_unit
	local lightweight_projectile_info = self.current_action.lightweight_projectile_info
	local peer_id = Network.peer_id()
	local template_name = lightweight_projectile_info.template_name
	local var_13_4 = LightWeightProjectiles[template_name]
	local collision_filter = lightweight_projectile_info.collision_filter
	local forward = Quaternion.forward(arg_13_2)
	local normalize = Vector3.normalize(forward)
	local num = math.random() * var_13_4.spread
	local look = Quaternion.look(normalize, Vector3.up())
	local var_13_10 = Quaternion(Vector3.right(), num)
	local var_13_11 = Quaternion(Vector3.forward(), math.random() * math.tau)
	local multiply = Quaternion.multiply(Quaternion.multiply(look, var_13_11), var_13_10)
	local forward_2 = Quaternion.forward(multiply)
	local tbl = {
		power_level = self._power_level,
		damage_profile = var_13_4.damage_profile,
		hit_effect = var_13_4.hit_effect,
		player_push_velocity = Vector3Box(normalize * var_13_4.impact_push_speed),
		projectile_linker = var_13_4.projectile_linker,
		first_person_hit_flow_events = var_13_4.first_person_hit_flow_events
	}

	Managers.state.entity:system("projectile_system"):create_light_weight_projectile(self.item_name, owner_unit, arg_13_1, forward_2, var_13_4.projectile_speed, nil, nil, var_13_4.projectile_max_range, collision_filter, tbl, var_13_4.light_weight_projectile_effect, peer_id)
end

ActionRangedBase.fire_hitscan = function (self, arg_14_1, arg_14_2, arg_14_3)
	-- function 14
	local var_14_0

	if not self.current_action.ray_against_large_hitbox then
		var_14_0 = PhysicsWorld.immediate_raycast_actors(self.physics_world, arg_14_1, arg_14_2, arg_14_3, "static_collision_filter", "filter_player_ray_projectile_static_only", "dynamic_collision_filter", "filter_player_ray_projectile_ai_only", "dynamic_collision_filter", "filter_player_ray_projectile_hitbox_only", "dynamic_collision_filter", "filter_enemy_trigger")
	else
		var_14_0 = PhysicsWorld.immediate_raycast_actors(self.physics_world, arg_14_1, arg_14_2, arg_14_3, "static_collision_filter", "filter_player_ray_projectile_static_only", "dynamic_collision_filter", "filter_player_ray_projectile_ai_only", "dynamic_collision_filter", "filter_player_ray_projectile_hitbox_only")
	end

	return var_14_0
end

ActionRangedBase.proc_extra_shot = function (self, arg_15_1)
	-- function 15
	if not self._extra_buff_shot then
		local apply_buffs_to_value, var_15_1 = self.buff_extension:apply_buffs_to_value(0, "extra_shot")

		if not var_15_1 then
			return true
		end
	end

	return false
end

ActionRangedBase.gen_num_shots = function (self)
	-- function 16
	local current_action = self.current_action
	local ammo_extension = self.ammo_extension
	local ammo_usage = current_action.ammo_usage

	ammo_usage = ammo_usage or 1

	local num_shots = current_action.num_shots

	num_shots = num_shots or 1

	local floor

	if not ammo_extension then
		floor = math.floor(ammo_extension:current_ammo() / ammo_usage)

		if not floor then
			-- Nothing
		end
	end

	floor = num_shots

	::label_16_0::

	local num_projectiles_per_shot = current_action.num_projectiles_per_shot

	num_projectiles_per_shot = num_projectiles_per_shot or 1

	if not ammo_extension and not current_action.fire_all_ammo then
		num_projectiles_per_shot = num_projectiles_per_shot * floor
		num_shots = 1
	else
		num_shots = math.min(num_shots, floor)
	end

	return num_shots, num_projectiles_per_shot
end

ActionRangedBase.apply_shot_cost = function (self, arg_17_1)
	-- function 17
	self:_use_ammo()
	self:_add_overcharge()
end

ActionRangedBase._use_ammo = function (self)
	-- function 18
	local ammo_extension = self.ammo_extension

	if not (not ammo_extension and self._extra_buff_shot) then
		ammo_extension:use_ammo(self.current_action.ammo_usage)
	end
end

ActionRangedBase._add_overcharge = function (self)
	-- function 19
	local overcharge_type = self.current_action.overcharge_type

	if not overcharge_type then
		local var_19_1 = PlayerUnitStatusSettings.overcharge_values[overcharge_type]

		if not self._is_critical_strike then
			local buff_extension = self.buff_extension

			buff_extension = not buff_extension and self.buff_extension:has_buff_perk("no_overcharge_crit")

			if not buff_extension then
				var_19_1 = 0
			end
		end

		self.overcharge_extension:add_charge(var_19_1)
	end
end
