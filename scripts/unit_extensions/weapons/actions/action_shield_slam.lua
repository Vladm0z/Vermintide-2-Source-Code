-- chunkname: @scripts/unit_extensions/weapons/actions/action_shield_slam.lua

ActionShieldSlam = class(ActionShieldSlam, ActionBase)

local POSITION_LOOKUP = POSITION_LOOKUP

ActionShieldSlam.init = function (self, arg_1_1, arg_1_2, arg_1_3, arg_1_4, arg_1_5, arg_1_6, arg_1_7, arg_1_8)
	-- function 1
	ActionShieldSlam.super.init(self, arg_1_1, arg_1_2, arg_1_3, arg_1_4, arg_1_5, arg_1_6, arg_1_7, arg_1_8)

	if not ScriptUnit.has_extension(arg_1_7, "ammo_system") then
		self.ammo_extension = ScriptUnit.extension(arg_1_7, "ammo_system")
	end

	self.overcharge_extension = ScriptUnit.extension(arg_1_4, "overcharge_system")
	self.status_extension = ScriptUnit.extension(arg_1_4, "status_system")
	self.hit_units = {}
	self.inner_hit_units = {}
	self.target_hit_zones_names = {}
	self.target_hit_unit_positions = {}
end

ActionShieldSlam.client_owner_start_action = function (self, arg_2_1, arg_2_2, arg_2_3, arg_2_4, arg_2_5)
	-- function 2
	ActionShieldSlam.super.client_owner_start_action(self, arg_2_1, arg_2_2, arg_2_3, arg_2_4, arg_2_5)

	self.current_action = arg_2_1
	self.target_breed_unit = nil

	local owner_unit = self.owner_unit
	local first_person_unit = self.first_person_unit
	local extension = ScriptUnit.extension(owner_unit, "buff_system")
	local extension_2 = ScriptUnit.extension(owner_unit, "career_system")

	self.owner_career_extension = extension_2
	self.owner_buff_extension = extension

	local has_melee_boost, var_2_5 = extension_2:has_melee_boost()
	local is_critical_strike = ActionUtils.is_critical_strike(owner_unit, arg_2_1, arg_2_2)

	self.melee_boost_curve_multiplier = var_2_5
	self.power_level = arg_2_4

	if not Managers.player:owner(owner_unit).bot_player then
		Managers.state.controller_features:add_effect("rumble", {
			rumble_effect = "light_swing"
		})
	end

	local flag = not arg_2_5 and arg_2_5.action_hand
	local var_2_8

	if not flag then
		var_2_8 = arg_2_1["damage_profile_" .. flag]

		if not var_2_8 then
			-- Nothing
		end
	end

	var_2_8 = arg_2_1.damage_profile
	var_2_8 = var_2_8 or "default"

	::label_2_0::

	self.damage_profile_id = NetworkLookup.damage_profiles[var_2_8]
	self.damage_profile = DamageProfileTemplates[var_2_8]

	local var_2_9

	if not flag then
		var_2_9 = arg_2_1["damage_profile_aoe_" .. flag]

		if not var_2_9 then
			-- Nothing
		end
	end

	var_2_9 = arg_2_1.damage_profile_aoe
	var_2_9 = var_2_9 or "default"

	::label_2_1::

	self.damage_profile_aoe_id = NetworkLookup.damage_profiles[var_2_9]
	self.damage_profile_aoe = DamageProfileTemplates[var_2_9]

	local var_2_10

	if not flag then
		var_2_10 = arg_2_1["damage_profile_target" .. flag]

		if not var_2_10 then
			-- Nothing
		end
	end

	var_2_10 = arg_2_1.damage_profile_target
	var_2_10 = var_2_10 or "default"

	::label_2_2::

	self.damage_profile_target_id = NetworkLookup.damage_profiles[var_2_10]
	self.damage_profile_target = DamageProfileTemplates[var_2_10]

	local ammo_extension = self.ammo_extension

	if not ammo_extension and not ammo_extension:is_reloading() then
		ammo_extension:abort_reload()
	end

	local has_extension = ScriptUnit.has_extension(owner_unit, "hud_system")
	local extension_3 = ScriptUnit.extension(owner_unit, "first_person_system")

	self:_handle_critical_strike(is_critical_strike, extension, has_extension, extension_3, "on_critical_sweep", "Play_player_combat_crit_swing_2D")

	self._is_critical_strike = is_critical_strike

	Unit.flow_event(first_person_unit, "sfx_swing_started")
	extension_3:disable_rig_movement()

	local get_data = World.get_data(self.world, "physics_world")
	local current_position = extension_3:current_position()
	local current_rotation = extension_3:current_rotation()
	local forward = Quaternion.forward(current_rotation)
	local get_difficulty_settings = Managers.state.difficulty:get_difficulty_settings()
	local owner = Managers.player:owner(owner_unit)
	local allow_friendly_fire_melee = DamageUtils.allow_friendly_fire_melee(get_difficulty_settings, owner)
	local flag_2

	flag_2 = not allow_friendly_fire_melee and "filter_melee_sweep" and "filter_melee_sweep_no_player"

	local immediate_raycast = PhysicsWorld.immediate_raycast(get_data, current_position, forward, arg_2_1.dedicated_target_range, "all", "collision_filter", flag_2)

	if not immediate_raycast then
		local side = Managers.state.side
		local count = #immediate_raycast

		for i = 1, count do
			local var_2_25 = immediate_raycast[i][4]
			local unit = Actor.unit(var_2_25)

			if allow_friendly_fire_melee or not side:is_ally(owner_unit, unit) then
				-- Nothing
			else
				local get_data_2 = Unit.get_data(unit, "breed")

				if not get_data_2 then
					local node = Actor.node(var_2_25)

					if get_data_2.hit_zones_lookup[node].name == "afro" or not HEALTH_ALIVE[unit] then
						self.target_breed_unit = unit

						break
					end
				end
			end
		end
	end

	if self.target_breed_unit or not ScriptUnit.has_extension(owner_unit, "smart_targeting_system") then
		local unit_2 = ScriptUnit.extension(owner_unit, "smart_targeting_system"):get_targeting_data().unit

		if not HEALTH_ALIVE[unit_2] then
			local has_node = Unit.has_node(unit_2, "j_spine")

			has_node = not has_node and Unit.world_position(unit_2, Unit.node(unit_2, "j_spine"))

			local var_2_31 = POSITION_LOOKUP[unit_2]

			var_2_31 = var_2_31 or Unit.world_position(unit_2, 0)

			local flag_3 = has_node or var_2_31
			local length = Vector3.length(current_position - flag_3)

			if not (not HEALTH_ALIVE[unit_2] and not (length < arg_2_1.dedicated_target_range)) then
				self.target_breed_unit = unit_2
			end
		end
	end

	self.state = "waiting_to_hit"

	local get_action_time_scale = ActionUtils.get_action_time_scale(owner_unit, arg_2_1)
	local hit_time = arg_2_1.hit_time

	hit_time = hit_time or 0
	self.time_to_hit = arg_2_2 + hit_time / get_action_time_scale

	table.clear(self.hit_units)
	table.clear(self.inner_hit_units)
	table.clear(self.target_hit_zones_names)
	table.clear(self.target_hit_unit_positions)

	local overcharge_type = self.current_action.overcharge_type

	if not overcharge_type then
		local var_2_37 = PlayerUnitStatusSettings.overcharge_values[overcharge_type]

		self.overcharge_extension:add_charge(var_2_37)
	end

	self._num_targets_hit = 0
end

ActionShieldSlam.client_owner_post_update = function (self, arg_3_1, arg_3_2, arg_3_3, arg_3_4)
	-- function 3
	local current_action = self.current_action
	local owner_unit = self.owner_unit

	if not (self.state ~= "waiting_to_hit" or not (arg_3_2 >= self.time_to_hit)) then
		self.state = "hitting"
	end

	if self.state == "hitting" then
		self:_hit(arg_3_3, arg_3_4, owner_unit, current_action)

		if not Managers.player:owner(self.owner_unit).bot_player then
			Managers.state.controller_features:add_effect("rumble", {
				rumble_effect = "hit_character_light"
			})
		end
	end
end

ActionShieldSlam._hit = function (self, arg_4_1, arg_4_2, arg_4_3, arg_4_4)
	-- function 4
	local network = Managers.state.network
	local get_data = World.get_data(arg_4_1, "physics_world")
	local unit_game_object_id = network:unit_game_object_id(arg_4_3)
	local first_person_unit = self.first_person_unit
	local forward = Quaternion.forward(Unit.local_rotation(first_person_unit, 0))
	local current_position = ScriptUnit.extension(arg_4_3, "first_person_system"):current_position()
	local forward_offset = arg_4_4.forward_offset

	forward_offset = forward_offset or 1

	local num = current_position + forward * forward_offset
	local push_radius = arg_4_4.push_radius
	local str = "filter_melee_sweep"
	local immediate_overlap, var_4_11 = PhysicsWorld.immediate_overlap(get_data, "shape", "sphere", "position", num, "size", push_radius, "types", "dynamics", "collision_filter", str)
	local num_2 = current_position + forward * (forward_offset + push_radius * 0.65)
	local num_3 = current_position + forward
	local inner_push_radius = arg_4_4.inner_push_radius

	inner_push_radius = inner_push_radius or push_radius * 0.4

	local num_4 = inner_push_radius * inner_push_radius
	local inner_hit_units = self.inner_hit_units
	local hit_units = self.hit_units
	local get_data_2 = Unit.get_data

	if not script_data.debug_weapons then
		self._drawer:sphere(num, push_radius, Color(255, 0, 0))
		self._drawer:sphere(num_3, inner_push_radius, Color(0, 255, 0))
		self._drawer:sphere(num_2, inner_push_radius, Color(0, 255, 0))
	end

	local target_breed_unit = self.target_breed_unit

	if not HEALTH_ALIVE[target_breed_unit] then
		target_breed_unit = nil
	end

	local side = Managers.state.side

	for i = 1, var_4_11 do
		repeat
			local var_4_21 = immediate_overlap[i]
			local unit = Actor.unit(var_4_21)

			if not hit_units[unit] then
				break
			end

			hit_units[unit] = true

			if not side:is_ally(arg_4_3, unit) then
				break
			end

			local var_4_23 = get_data_2(unit, "breed")
			local flag = unit == arg_4_3

			if not var_4_23 then
				if unit == target_breed_unit then
					break
				end

				local node = Actor.node(var_4_21)
				local flag_2 = not var_4_23 and var_4_23.hit_zones_lookup[node]
				local name

				if not flag_2 then
					name = flag_2.name

					if not name then
						-- Nothing
					end
				end

				name = "torso"

				::label_4_0::

				local has_node = Unit.has_node(unit, "j_spine")

				has_node = not has_node and Unit.world_position(unit, Unit.node(unit, "j_spine"))

				local var_4_29 = POSITION_LOOKUP[unit]

				var_4_29 = var_4_29 or Unit.world_position(unit, 0)

				local flag_3 = has_node or var_4_29

				self.target_hit_zones_names[unit] = name
				self.target_hit_unit_positions[unit] = flag_3

				local normalize = Vector3.normalize(flag_3 - current_position)
				local unit_game_object_id_2 = network:unit_game_object_id(unit)
				local var_4_33 = NetworkLookup.hit_zones[name]

				if not self:_is_infront_player(current_position, forward, flag_3) then
					if num_4 >= math.min(Vector3.distance_squared(flag_3, num_2), Vector3.distance_squared(flag_3, num_3)) then
						inner_hit_units[unit] = true

						break
					end

					local attack_is_shield_blocked = AiUtils.attack_is_shield_blocked(unit, arg_4_3)
					local item_name = self.item_name
					local var_4_36 = NetworkLookup.damage_sources[item_name]
					local weapon_system = self.weapon_system
					local power_level = self.power_level
					local is_server = self.is_server
					local damage_profile_aoe = self.damage_profile_aoe
					local num_5 = 1
					local _is_critical_strike = self._is_critical_strike

					self._overridable_settings = arg_4_4

					ActionSweep._play_character_impact(self, is_server, arg_4_3, unit, var_4_23, flag_3, name, arg_4_4, damage_profile_aoe, num_5, power_level, normalize, attack_is_shield_blocked, self.melee_boost_curve_multiplier, _is_critical_strike)

					self._num_targets_hit = self._num_targets_hit + 1

					weapon_system:send_rpc_attack_hit(var_4_36, unit_game_object_id, unit_game_object_id_2, var_4_33, flag_3, normalize, self.damage_profile_aoe_id, "power_level", power_level, "hit_target_index", num_5, "blocking", attack_is_shield_blocked, "shield_break_procced", false, "boost_curve_multiplier", self.melee_boost_curve_multiplier, "is_critical_strike", self._is_critical_strike, "can_damage", true, "can_stagger", true, "first_hit", self._num_targets_hit == 1)
				end

				break
			end

			if flag or not ScriptUnit.has_extension(unit, "health_system") then
				local game_object_or_level_id, var_4_44 = Managers.state.network:game_object_or_level_id(unit)

				if not var_4_44 then
					if not get_data_2(unit, "no_damage_from_players") then
						local world_position = Unit.world_position(unit, 0)

						if num_4 >= math.min(Vector3.distance_squared(world_position, num_2), Vector3.distance_squared(world_position, num_3)) then
							inner_hit_units[unit] = true

							break
						end

						local str_2 = "full"
						local num_6 = 1
						local damage_profile_aoe_2 = self.damage_profile_aoe
						local item_name_2 = self.item_name
						local power_level_2 = self.power_level
						local _is_critical_strike_2 = self._is_critical_strike
						local normalize_2 = Vector3.normalize(world_position - current_position)

						DamageUtils.damage_level_unit(unit, arg_4_3, str_2, power_level_2, self.melee_boost_curve_multiplier, _is_critical_strike_2, damage_profile_aoe_2, num_6, normalize_2, item_name_2)
					end

					break
				end

				local var_4_53 = POSITION_LOOKUP[unit]

				var_4_53 = var_4_53 or Unit.world_position(unit, 0)

				if num_4 >= math.min(Vector3.distance_squared(var_4_53, num_2), Vector3.distance_squared(var_4_53, num_3)) then
					inner_hit_units[unit] = true
				end

				local item_name_3 = self.item_name
				local var_4_55 = NetworkLookup.damage_sources[item_name_3]
				local weapon_system_2 = self.weapon_system
				local power_level_3 = self.power_level
				local full = NetworkLookup.hit_zones.full
				local normalize_3 = Vector3.normalize(var_4_53 - current_position)

				weapon_system_2:send_rpc_attack_hit(var_4_55, unit_game_object_id, game_object_or_level_id, full, var_4_53, normalize_3, self.damage_profile_aoe_id, "power_level", power_level_3, "hit_target_index", nil, "boost_curve_multiplier", self.melee_boost_curve_multiplier, "is_critical_strike", self._is_critical_strike, "can_damage", true, "can_stagger", true)
			end
		until true
	end

	if not (not Unit.alive(target_breed_unit) and self.hit_target_breed_unit) then
		inner_hit_units[target_breed_unit] = true
	end

	local num_7 = 1

	for k, v in pairs(inner_hit_units) do
		local var_4_61 = get_data_2(k, "breed")
		local var_4_62 = self.target_hit_zones_names[k]

		var_4_62 = var_4_62 or "torso"

		local has_node_2 = Unit.has_node(k, "j_spine")

		has_node_2 = not has_node_2 and Unit.world_position(k, Unit.node(k, "j_spine"))

		local var_4_64 = POSITION_LOOKUP[k]

		var_4_64 = var_4_64 or Unit.world_position(k, 0)

		local flag_4 = has_node_2 or var_4_64
		local normalize_4 = Vector3.normalize(flag_4 - current_position)
		local game_object_or_level_id_2, var_4_68 = network:game_object_or_level_id(k)
		local var_4_69 = NetworkLookup.hit_zones[var_4_62]

		if not var_4_61 and not self:_is_infront_player(current_position, forward, flag_4, arg_4_4.push_dot) then
			local is_server_2 = self.is_server
			local flag_5 = k == target_breed_unit
			local damage_profile_target

			if not flag_5 then
				damage_profile_target = self.damage_profile_target

				if not damage_profile_target then
					-- Nothing
				end
			end

			damage_profile_target = self.damage_profile

			do
				local damage_profile_target_id
			end

			::label_4_1::

			if not flag_5 then
				damage_profile_target_id = self.damage_profile_target_id

				if not damage_profile_target_id then
					-- Nothing
				end
			end

			damage_profile_target_id = self.damage_profile_id

			::label_4_2::

			local num_8 = 1
			local power_level_4 = self.power_level
			local _is_critical_strike_3 = self._is_critical_strike
			local attack_is_shield_blocked_2 = AiUtils.attack_is_shield_blocked(k, arg_4_3)
			local find_actor = Unit.find_actor(k, "c_spine")

			find_actor = not find_actor and Unit.actor(k, "c_spine")

			local flag_6 = not find_actor and Actor.center_of_mass(find_actor)

			if not flag_6 then
				self._overridable_settings = arg_4_4

				ActionSweep._play_character_impact(self, is_server_2, arg_4_3, k, var_4_61, flag_6, var_4_62, arg_4_4, damage_profile_target, num_8, power_level_4, normalize_4, attack_is_shield_blocked_2, self.melee_boost_curve_multiplier, _is_critical_strike_3)
			end

			local flag_7 = true
			local charge_value = damage_profile_target.charge_value

			charge_value = charge_value or "heavy_attack"

			local get_item_buff_type = DamageUtils.get_item_buff_type(self.item_name)

			DamageUtils.buff_on_attack(arg_4_3, k, charge_value, _is_critical_strike_3, var_4_62, num_7, flag_7, get_item_buff_type, nil, self.item_name)

			local var_4_83 = NetworkLookup.damage_sources[self.item_name]
			local weapon_system_3 = self.weapon_system

			self._num_targets_hit = self._num_targets_hit + 1

			weapon_system_3:send_rpc_attack_hit(var_4_83, unit_game_object_id, game_object_or_level_id_2, var_4_69, flag_4, normalize_4, damage_profile_target_id, "power_level", power_level_4, "hit_target_index", num_8, "blocking", attack_is_shield_blocked_2, "shield_break_procced", false, "boost_curve_multiplier", self.melee_boost_curve_multiplier, "is_critical_strike", _is_critical_strike_3, "can_damage", true, "can_stagger", true, "first_hit", self._num_targets_hit == 1)

			if not self.is_critical_strike and not self.critical_strike_particle_id then
				World.destroy_particles(self.world, self.critical_strike_particle_id)

				self.critical_strike_particle_id = nil
			end

			if not Managers.player:owner(self.owner_unit).bot_player then
				Managers.state.controller_features:add_effect("rumble", {
					rumble_effect = "handgun_fire"
				})
			end

			self.hit_target_breed_unit = true
			num_7 = num_7 + 1
		elseif not ScriptUnit.has_extension(k, "health_system") then
			if not var_4_68 then
				if not get_data_2(k, "no_damage_from_players") then
					local str_3 = "full"
					local num_9 = 1
					local damage_profile = self.damage_profile
					local item_name_4 = self.item_name
					local power_level_5 = self.power_level
					local _is_critical_strike_4 = self._is_critical_strike
					local world_position_2 = Unit.world_position(k, 0)
					local normalize_5 = Vector3.normalize(world_position_2 - current_position)

					DamageUtils.damage_level_unit(k, arg_4_3, str_3, power_level_5, self.melee_boost_curve_multiplier, _is_critical_strike_4, damage_profile, num_9, normalize_5, item_name_4)
				end
			else
				local item_name_5 = self.item_name
				local var_4_94 = NetworkLookup.damage_sources[item_name_5]
				local weapon_system_4 = self.weapon_system
				local power_level_6 = self.power_level
				local full_2 = NetworkLookup.hit_zones.full
				local world_position_3 = Unit.world_position(k, 0)
				local normalize_6 = Vector3.normalize(world_position_3 - current_position)

				weapon_system_4:send_rpc_attack_hit(var_4_94, unit_game_object_id, game_object_or_level_id_2, full_2, world_position_3, normalize_6, self.damage_profile_id, "power_level", power_level_6, "hit_target_index", nil, "boost_curve_multiplier", self.melee_boost_curve_multiplier, "is_critical_strike", self._is_critical_strike, "can_damage", true, "can_stagger", true)
			end
		end
	end

	self.state = "hit"
end

ActionShieldSlam.finish = function (self, arg_5_1)
	-- function 5
	local has_extension = ScriptUnit.has_extension(self.owner_unit, "hud_system")

	if not has_extension then
		has_extension.show_critical_indication = false
	end

	self.hit_target_breed_unit = false

	local owner_unit = self.owner_unit
	local current_action = self.current_action

	if not (arg_5_1 ~= "action_complete" or self.state == "hit") then
		self:_hit(self.world, true, owner_unit, current_action)
	end

	local ammo_extension = self.ammo_extension

	if arg_5_1 ~= "new_interupting_action" then
		local reload_when_out_of_ammo_condition_func = current_action.reload_when_out_of_ammo_condition_func
		local flag

		flag = reload_when_out_of_ammo_condition_func or not true or reload_when_out_of_ammo_condition_func(owner_unit, arg_5_1)

		if not ammo_extension and not current_action.reload_when_out_of_ammo and not flag and ammo_extension:ammo_count() ~= 0 or not ammo_extension:can_reload() then
			local flag_2 = true

			ammo_extension:start_reload(flag_2)
		end
	end
end

ActionShieldSlam._is_infront_player = function (arg_6_0, arg_6_1, arg_6_2, arg_6_3, arg_6_4)
	-- function 6
	local normalize = Vector3.normalize(arg_6_3 - arg_6_1)

	if Vector3.dot(normalize, arg_6_2) > (arg_6_4 or 0.35) then
		return true
	end
end

ActionShieldSlam.destroy = function (self)
	-- function 7
	if not self.critical_strike_particle_id then
		World.destroy_particles(self.world, self.critical_strike_particle_id)

		self.critical_strike_particle_id = nil
	end
end
