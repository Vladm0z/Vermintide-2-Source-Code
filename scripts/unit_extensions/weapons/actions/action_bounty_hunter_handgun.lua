-- chunkname: @scripts/unit_extensions/weapons/actions/action_bounty_hunter_handgun.lua

ActionBountyHunterHandgun = class(ActionBountyHunterHandgun, ActionBase)

ActionBountyHunterHandgun.init = function (arg_1_0, arg_1_1, arg_1_2, arg_1_3, arg_1_4, arg_1_5, arg_1_6, arg_1_7, arg_1_8)
	-- function 1
	ActionBountyHunterHandgun.super.init(arg_1_0, arg_1_1, arg_1_2, arg_1_3, arg_1_4, arg_1_5, arg_1_6, arg_1_7, arg_1_8)
end

ActionBountyHunterHandgun.client_owner_start_action = function (self, arg_2_1, arg_2_2, arg_2_3, arg_2_4, arg_2_5)
	-- function 2
	ActionBountyHunterHandgun.super.client_owner_start_action(self, arg_2_1, arg_2_2, arg_2_3, arg_2_4, arg_2_5)

	local weapon_unit = self.weapon_unit
	local owner_unit = self.owner_unit
	local is_critical_strike = ActionUtils.is_critical_strike(owner_unit, arg_2_1, arg_2_2)
	local extension = ScriptUnit.extension(owner_unit, "buff_system")

	self.current_action = arg_2_1
	self.power_level = arg_2_4
	self.owner_buff_extension = extension

	local _railgun_shoot

	if not arg_2_5 then
		if arg_2_5.upper_barrel == "railgun" then
			_railgun_shoot = self._railgun_shoot

			if not _railgun_shoot then
				-- Nothing
			end
		end

		_railgun_shoot = self._shotgun_shoot

		if not _railgun_shoot then
			-- Nothing
		end
	end

	_railgun_shoot = self._railgun_shoot

	::label_2_0::

	self.upper_shoot_function = _railgun_shoot

	local _railgun_shoot_2

	if not arg_2_5 then
		if arg_2_5.lower_barrel == "railgun" then
			_railgun_shoot_2 = self._railgun_shoot

			if not _railgun_shoot_2 then
				-- Nothing
			end
		end

		_railgun_shoot_2 = self._shotgun_shoot

		if not _railgun_shoot_2 then
			-- Nothing
		end
	end

	_railgun_shoot_2 = self._shotgun_shoot

	::label_2_1::

	self.lower_shoot_function = _railgun_shoot_2

	Unit.set_flow_variable(weapon_unit, "upper_is_railgun", arg_2_5.upper_barrel == "railgun")
	Unit.set_flow_variable(weapon_unit, "lower_is_railgun", arg_2_5.lower_barrel == "railgun")

	if not Managers.player:owner(self.owner_unit).bot_player then
		Managers.state.controller_features:add_effect("rumble", {
			rumble_effect = "light_swing"
		})
	end

	if not ScriptUnit.has_extension(weapon_unit, "spread_system") then
		self.spread_extension = ScriptUnit.extension(weapon_unit, "spread_system")
	end

	local damage_profile = arg_2_1.damage_profile

	damage_profile = damage_profile or "default"
	self.damage_profile_id = NetworkLookup.damage_profiles[damage_profile]
	self.damage_profile = DamageProfileTemplates[damage_profile]

	local damage_profile_aoe = arg_2_1.damage_profile_aoe

	damage_profile_aoe = damage_profile_aoe or "default"
	self.damage_profile_aoe_id = NetworkLookup.damage_profiles[damage_profile_aoe]
	self.damage_profile_aoe = DamageProfileTemplates[damage_profile_aoe]
	self.upper_shot_done = nil
	self.lower_shot_done = nil
	self.aoe_done = nil
	self.time_to_shoot_upper = arg_2_2 + arg_2_1.fire_time_upper
	self.time_to_shoot_lower = arg_2_2 + arg_2_1.fire_time_lower
	self.time_to_aoe = arg_2_2 + arg_2_1.aoe_time
	self.hit_units = {}
	self.shield_users_blocking = {}

	local has_extension = ScriptUnit.has_extension(owner_unit, "hud_system")

	self:_handle_critical_strike(is_critical_strike, extension, has_extension, nil, "on_critical_shot", nil)

	self.is_critical_strike = is_critical_strike

	if not arg_2_1.block then
		ScriptUnit.extension(owner_unit, "status_system"):set_blocking(true)
	end
end

ActionBountyHunterHandgun.client_owner_post_update = function (self, arg_3_1, arg_3_2, arg_3_3, arg_3_4, arg_3_5)
	-- function 3
	if not (self.upper_shot_done or not (arg_3_2 >= self.time_to_shoot_upper)) then
		self.upper_shoot_function(self)

		self.upper_shot_done = true
	end

	if not (self.lower_shot_done or not (arg_3_2 >= self.time_to_shoot_lower)) then
		self.lower_shoot_function(self)

		self.lower_shot_done = true
	end

	if not (self.aoe_done or not (arg_3_2 >= self.time_to_aoe)) then
		self:_do_aoe()

		self.aoe_done = true
	end
end

ActionBountyHunterHandgun._railgun_shoot = function (self)
	-- function 4
	local owner_unit = self.owner_unit
	local current_action = self.current_action
	local flag = true

	if not Managers.player:owner(self.owner_unit).bot_player then
		Managers.state.controller_features:add_effect("rumble", {
			rumble_effect = "handgun_fire"
		})
	end

	local extension = ScriptUnit.extension(owner_unit, "first_person_system")
	local get_projectile_start_position_rotation, var_4_5 = extension:get_projectile_start_position_rotation()
	local spread_extension = self.spread_extension
	local railgun_spread_template = current_action.railgun_spread_template

	if not spread_extension then
		if not railgun_spread_template then
			spread_extension:override_spread_template(railgun_spread_template)
		end

		var_4_5 = spread_extension:get_randomised_spread(var_4_5)

		if not flag then
			spread_extension:set_shooting()
		end
	end

	local pitch_from_rotation = ActionUtils.pitch_from_rotation(var_4_5)
	local speed = current_action.speed
	local normalize = Vector3.normalize(Vector3.flat(Quaternion.forward(var_4_5)))
	local lookup_data = current_action.lookup_data

	ActionUtils.spawn_player_projectile(owner_unit, get_projectile_start_position_rotation, var_4_5, 0, pitch_from_rotation, normalize, speed, self.item_name, lookup_data.item_template_name, lookup_data.action_name, lookup_data.sub_action_name, self.is_critical_strike, self.power_level)
	extension:reset_aim_assist_multiplier()
end

ActionBountyHunterHandgun._shotgun_shoot = function (self)
	-- function 5
	local world = self.world
	local owner_unit = self.owner_unit
	local current_action = self.current_action
	local spread_extension = self.spread_extension
	local is_server = self.is_server
	local shotgun_spread_template = current_action.shotgun_spread_template

	if not shotgun_spread_template then
		self.spread_extension:override_spread_template(shotgun_spread_template)
	end

	local get_projectile_start_position_rotation, var_5_7 = ScriptUnit.extension(owner_unit, "first_person_system"):get_projectile_start_position_rotation()
	local shot_count = current_action.shot_count

	shot_count = shot_count or 1

	local extension = ScriptUnit.extension(owner_unit, "buff_system")
	local num = 0

	if not extension:has_buff_type("victor_bounty_blast_streak_buff") then
		shot_count = shot_count + extension:num_buff_type("victor_bounty_blast_streak_buff")
	end

	if not Managers.player:owner(owner_unit).bot_player then
		Managers.state.controller_features:add_effect("rumble", {
			rumble_effect = "handgun_fire"
		})
	end

	local get_data = World.get_data(world, "physics_world")
	local flag = true
	local weapon_unit = self.weapon_unit

	for i = 1, shot_count do
		local var_5_14 = var_5_7

		if not spread_extension then
			var_5_14 = spread_extension:get_target_style_spread(i, shot_count, var_5_7)
		end

		local forward = Quaternion.forward(var_5_14)
		local immediate_raycast_actors = PhysicsWorld.immediate_raycast_actors(get_data, get_projectile_start_position_rotation, forward, current_action.range, "static_collision_filter", "filter_player_ray_projectile_static_only", "dynamic_collision_filter", "filter_player_ray_projectile_ai_only", "dynamic_collision_filter", "filter_player_ray_projectile_hitbox_only")

		if not immediate_raycast_actors then
			local process_projectile_hit = DamageUtils.process_projectile_hit(world, self.item_name, owner_unit, is_server, immediate_raycast_actors, current_action, forward, flag, nil, self.shield_users_blocking, self.is_critical_strike, self.power_level)

			if not process_projectile_hit.buffs_checked then
				flag = not flag and false
			end

			if not process_projectile_hit.blocked_by_unit then
				self.shield_users_blocking[process_projectile_hit.blocked_by_unit] = true
			end
		end

		local var_5_18

		if not immediate_raycast_actors then
			var_5_18 = immediate_raycast_actors[#immediate_raycast_actors][1]

			if not var_5_18 then
				-- Nothing
			end
		end

		var_5_18 = get_projectile_start_position_rotation + forward * current_action.range

		::label_5_0::

		Unit.set_flow_variable(weapon_unit, "hit_position", var_5_18)
		Unit.set_flow_variable(weapon_unit, "trail_life", Vector3.length(var_5_18 - get_projectile_start_position_rotation) * 0.1)
		Unit.flow_event(weapon_unit, "lua_bullet_trail")
		Unit.flow_event(weapon_unit, "lua_bullet_trail_set")
	end

	local flag_2 = not self.extra_buff_shot

	if not spread_extension and not flag_2 then
		spread_extension:set_shooting()
	end

	if not current_action.alert_sound_range_fire then
		Managers.state.entity:system("ai_system"):alert_enemies_within_range(owner_unit, POSITION_LOOKUP[owner_unit], current_action.alert_sound_range_fire)
	end
end

ActionBountyHunterHandgun._do_aoe = function (self)
	-- function 6
	local world = self.world
	local owner_unit = self.owner_unit
	local current_action = self.current_action
	local network = Managers.state.network
	local get_data = World.get_data(world, "physics_world")
	local unit_game_object_id = network:unit_game_object_id(owner_unit)
	local forward = Quaternion.forward(Unit.local_rotation(owner_unit, 0))
	local num = POSITION_LOOKUP[owner_unit] + forward * 0.5
	local aoe_radius = current_action.aoe_radius
	local str = "filter_melee_sweep"
	local immediate_overlap, var_6_11 = PhysicsWorld.immediate_overlap(get_data, "shape", "sphere", "position", num, "size", aoe_radius, "types", "dynamics", "collision_filter", str)
	local hit_units = self.hit_units

	for i = 1, var_6_11 do
		repeat
			local var_6_13 = immediate_overlap[i]
			local unit = Actor.unit(var_6_13)
			local unit_breed = AiUtils.unit_breed(unit)

			if not (not unit_breed and hit_units[unit] or unit_breed.is_player) then
				hit_units[unit] = true

				local node = Actor.node(var_6_13)
				local world_position = Unit.world_position(unit, node)
				local normalize = Vector3.normalize(world_position - num)
				local name = unit_breed.hit_zones_lookup[node].name
				local var_6_20 = NetworkLookup.hit_zones[name]
				local unit_game_object_id_2 = network:unit_game_object_id(unit)
				local power_level = self.power_level
				local damage_profile_aoe_id = self.damage_profile_aoe_id
				local attack_is_shield_blocked = AiUtils.attack_is_shield_blocked(unit, owner_unit)
				local item_name = self.item_name
				local var_6_26 = NetworkLookup.damage_sources[item_name]
				local weapon_system = self.weapon_system
				local num_2 = 1
				local is_critical_strike = self.is_critical_strike
				local flag = false
				local flag_2 = true
				local var_6_32

				weapon_system:send_rpc_attack_hit(var_6_26, unit_game_object_id, unit_game_object_id_2, var_6_20, world_position, normalize, damage_profile_aoe_id, "power_level", power_level, "hit_target_index", var_6_32, "blocking", attack_is_shield_blocked, "shield_break_procced", false, "boost_curve_multiplier", num_2, "is_critical_strike", is_critical_strike, "can_damage", flag, "can_stagger", flag_2)
			end
		until true
	end
end

ActionBountyHunterHandgun.finish = function (self, arg_7_1)
	-- function 7
	local current_action = self.current_action
	local owner_unit = self.owner_unit

	if arg_7_1 ~= "new_interupting_action" then
		ScriptUnit.extension(owner_unit, "status_system"):set_zooming(false)
	end

	if not current_action.block then
		ScriptUnit.extension(owner_unit, "status_system"):set_blocking(false)
	end

	local has_extension = ScriptUnit.has_extension(owner_unit, "hud_system")

	if not has_extension then
		has_extension.show_critical_indication = false
	end
end
