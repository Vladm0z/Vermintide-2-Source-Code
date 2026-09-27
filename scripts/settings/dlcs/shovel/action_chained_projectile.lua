-- chunkname: @scripts/settings/dlcs/shovel/action_chained_projectile.lua

ActionChainedProjectile = class(ActionChainedProjectile, ActionBase)

ActionChainedProjectile.init = function (self, arg_1_1, arg_1_2, arg_1_3, arg_1_4, arg_1_5, arg_1_6, arg_1_7, arg_1_8)
	-- function 1
	ActionChainedProjectile.super.init(self, arg_1_1, arg_1_2, arg_1_3, arg_1_4, arg_1_5, arg_1_6, arg_1_7, arg_1_8)

	self.ammo_extension = ScriptUnit.has_extension(arg_1_7, "ammo_system")
	self.inventory_extension = ScriptUnit.extension(arg_1_4, "inventory_system")
	self.overcharge_extension = ScriptUnit.extension(arg_1_4, "overcharge_system")
	self.first_person_extension = ScriptUnit.has_extension(arg_1_4, "first_person_system")
	self.owner_buff_extension = ScriptUnit.extension(arg_1_4, "buff_system")
	self.weapon_extension = ScriptUnit.extension(arg_1_7, "weapon_system")
	self.status_extension = ScriptUnit.extension(arg_1_4, "status_system")
	self.hud_extension = ScriptUnit.has_extension(arg_1_4, "hud_system")
	self.owner_unit = arg_1_4

	if not self.first_person_extension then
		self.first_person_unit = self.first_person_extension:get_first_person_unit()
	end

	self._rumble_effect_id = false
	self.unit_id = Managers.state.network.unit_storage:go_id(arg_1_4)
	self._audio_system = Managers.state.entity:system("audio_system")
	self._active_projectiles = Script.new_array(4)
	self._active_projectiles_n = 0
	self.fx_spline_ids = {
		World.find_particles_variable(arg_1_1, "fx/wpnfx_staff_death/curse_spirit", "spline_1"),
		World.find_particles_variable(arg_1_1, "fx/wpnfx_staff_death/curse_spirit", "spline_2"),
		World.find_particles_variable(arg_1_1, "fx/wpnfx_staff_death/curse_spirit", "spline_3")
	}
end

local num = 1
local num_2 = 2
local num_3 = 3
local num_4 = 4

ActionChainedProjectile.client_owner_start_action = function (self, arg_2_1, arg_2_2, arg_2_3, arg_2_4)
	-- function 2
	ActionChainedProjectile.super.client_owner_start_action(self, arg_2_1, arg_2_2, arg_2_3, arg_2_4)

	self._fire_t = arg_2_2 + arg_2_1.fire_time
	self.state = "waiting_to_shoot"
	self._power_level = arg_2_4
	self._fire_sound_event = arg_2_1.fire_sound_event
	self._chain_sound_event = arg_2_1.chain_sound_event
end

ActionChainedProjectile.client_owner_post_update = function (self, arg_3_1, arg_3_2, arg_3_3, arg_3_4)
	-- function 3
	if not (self.state ~= "waiting_to_shoot" or not (arg_3_2 >= self._fire_t)) then
		self.state = "shooting"
	end

	if self.state == "shooting" then
		self.state = "shot"

		self:_shoot(arg_3_2)
	end
end

ActionChainedProjectile.finish = function (arg_4_0, arg_4_1)
	-- function 4
	ActionChainedProjectile.super.finish(arg_4_0, arg_4_1)
end

ActionChainedProjectile._shoot = function (self, arg_5_1)
	-- function 5
	local num = 100
	local num_2 = 0.15
	local physics_world = self.physics_world
	local owner_unit = self.owner_unit
	local side = Managers.state.side
	local side_by_unit = side.side_by_unit
	local var_5_6 = side_by_unit[owner_unit]
	local get_projectile_start_position_rotation, var_5_8 = self.first_person_extension:get_projectile_start_position_rotation()
	local forward = Quaternion.forward(var_5_8)
	local immediate_raycast, var_5_11, var_5_12, var_5_13, var_5_14 = PhysicsWorld.immediate_raycast(physics_world, get_projectile_start_position_rotation, forward, num, "closest", "collision_filter", "filter_player_ray_projectile_static_only")
	local flag = var_5_12 or num
	local num_3 = get_projectile_start_position_rotation + forward * flag / 2
	local num_4 = flag / 2

	PhysicsWorld.prepare_actors_for_overlap(physics_world, num_3, num_4 * num_4)

	local linear_sphere_sweep = PhysicsWorld.linear_sphere_sweep(physics_world, get_projectile_start_position_rotation + forward * (num_2 / 2), get_projectile_start_position_rotation + forward * flag, num_2, 100, "types", "both", "collision_filter", "filter_player_ray_projectile", "report_initial_overlap")
	local count

	if not linear_sphere_sweep then
		count = #linear_sphere_sweep

		if not count then
			-- Nothing
		end
	end

	count = 0

	::label_5_0::

	local var_5_20

	for i = 1, count do
		local actor = linear_sphere_sweep[i].actor

		if not actor then
			local unit = Actor.unit(actor)

			if not ScriptUnit.has_extension(unit, "health_system") then
				local var_5_23 = side_by_unit[unit]

				if not var_5_6 and not var_5_23 and not side:is_enemy_by_side(var_5_6, var_5_23) then
					local node = Actor.node(actor)
					local unit_breed = AiUtils.unit_breed(unit)
					local flag_2 = not unit_breed and unit_breed.hit_zones_lookup[node]

					if not (not flag_2 and flag_2.name == "afro") then
						var_5_20 = unit

						break
					end
				end
			end
		end
	end

	local var_5_27
	local num_5 = get_projectile_start_position_rotation + forward * flag
	local var_5_29

	if not var_5_20 then
		var_5_29 = var_5_20

		local game_object_or_level_id, var_5_31 = Managers.state.network:game_object_or_level_id(var_5_29)

		if not var_5_31 then
			local node_2

			if not Unit.has_node(var_5_20, "j_spine") then
				node_2 = Unit.node(var_5_20, "j_spine")

				if not node_2 then
					-- Nothing
				end
			end

			node_2 = 0

			::label_5_1::

			num_5 = Unit.world_position(var_5_20, node_2)
		end
	elseif not immediate_raycast then
		local unit_2 = Actor.unit(var_5_14)
		local game_object_or_level_id_2, var_5_35 = Managers.state.network:game_object_or_level_id(unit_2)

		if not var_5_35 then
			var_5_29 = unit_2
		end
	end

	if not var_5_29 then
		local chain_hit_settings = self.current_action.chain_hit_settings

		if not Unit.get_data(var_5_29, "breed") then
			self._is_critical_strike = ActionUtils.is_critical_strike(self.owner_unit, self.current_action, arg_5_1)

			self:_handle_critical_strike(self._is_critical_strike, self.buff_extension, self.hud_extension, nil, "on_critical_shot", nil)

			local num_6 = 1
			local flag_3 = true
			local charge_value = DamageProfileTemplates[chain_hit_settings.damage_profile].charge_value

			charge_value = charge_value or "projectile"

			local get_item_buff_type = DamageUtils.get_item_buff_type(self.item_name)

			DamageUtils.buff_on_attack(self.owner_unit, var_5_29, charge_value, self._is_critical_strike, "full", num_6, flag_3, get_item_buff_type, nil, self.item_name)
		else
			self._is_critical_strike = false
		end

		local _power_level = self._power_level
		local get_ranged_boost, var_5_43 = ActionUtils.get_ranged_boost(owner_unit)
		local _is_critical_strike = self._is_critical_strike
		local _active_projectiles = self._active_projectiles
		local num_7 = self._active_projectiles_n + 1

		self._active_projectiles_n = num_7
		_active_projectiles[num_7] = {
			chain_count = 0,
			settings = chain_hit_settings,
			is_critical_strike = _is_critical_strike,
			power_level = _power_level,
			boost_curve_multiplier = var_5_43,
			next_chain_t = arg_5_1 + (chain_hit_settings.chain_delay - chain_hit_settings.target_selection_delay),
			target_selection_t = math.huge,
			next_target_unit = var_5_29,
			hit_units = {
				[var_5_29] = true
			},
			last_chain_pos = Vector3Box(num_5)
		}
	elseif not var_5_13 then
		local var_5_47 = var_5_13
		local reflect = Vector3.reflect(forward, var_5_47)
		local var_5_49 = NetworkLookup.effects["fx/wpnfx_staff_death/curse_spirit_impact"]

		if not self.is_server then
			Managers.state.network:rpc_play_particle_effect(nil, var_5_49, NetworkConstants.invalid_game_object_id, 0, num_5, Quaternion.look(reflect), false)
		else
			Managers.state.network.network_transmit:send_rpc_server("rpc_play_particle_effect", var_5_49, NetworkConstants.invalid_game_object_id, 0, num_5, Quaternion.look(reflect), false)
		end
	end

	local start_offset = self.current_action.start_offset
	local rotate = Quaternion.rotate(var_5_8, Vector3(math.lerp(start_offset.min[1], start_offset.max[1], math.random()), math.lerp(start_offset.min[2], start_offset.max[2], math.random()), math.lerp(start_offset.min[3], start_offset.max[3], math.random())))
	local curve_offset = self.current_action.curve_offset
	local rotate_2 = Quaternion.rotate(var_5_8, Vector3(math.lerp(curve_offset.min[1], curve_offset.max[1], math.random()), math.lerp(curve_offset.min[2], curve_offset.max[2], math.random()), math.lerp(curve_offset.min[3], curve_offset.max[3], math.random())))
	local node_3 = Unit.node(self.first_person_unit, "j_aim_target")
	local num_8 = Unit.world_position(self.first_person_unit, node_3) + rotate
	local num_9 = num_8 + (num_5 - num_8) / 3 + rotate_2

	self:_play_fx("fx/wpnfx_staff_death/curse_spirit_first", num_8, num_9, num_5, false)

	local current_action = self.current_action
	local overcharge_type = current_action.overcharge_type

	if not (not overcharge_type and self.extra_buff_shot) then
		local var_5_59 = PlayerUnitStatusSettings.overcharge_values[overcharge_type]
		local extension = ScriptUnit.extension(owner_unit, "buff_system")

		if not self._is_critical_strike and not extension:has_buff_perk("no_overcharge_crit") then
			var_5_59 = 0
		end

		if not current_action.scale_overcharge then
			self.overcharge_extension:add_charge(var_5_59, self.charge_level)
		else
			self.overcharge_extension:add_charge(var_5_59)
		end
	end

	self:_proc_spell_used(self.owner_buff_extension)
end

ActionChainedProjectile._apply_damage = function (self, arg_6_1, arg_6_2, arg_6_3, arg_6_4, arg_6_5, arg_6_6, arg_6_7)
	-- function 6
	local network = Managers.state.network
	local unit_game_object_id = network:unit_game_object_id(self.owner_unit)

	self:_handle_critical_strike(arg_6_3, self.owner_buff_extension, self.hud_extension, self.first_person_extension, "on_critical_shot", nil)

	local var_6_2 = NetworkLookup.damage_profiles[arg_6_6]
	local game_object_or_level_id, var_6_4 = network:game_object_or_level_id(arg_6_1)
	local var_6_5 = NetworkLookup.damage_sources[self.item_name]
	local torso = NetworkLookup.hit_zones.torso
	local num = Unit.world_position(arg_6_1, 0) + Vector3.up()
	local direction_length, var_6_9 = Vector3.direction_length(num - arg_6_7)

	if not var_6_4 then
		local str = "full"
		local num_2 = 1
		local item_name = self.item_name
		local var_6_13 = DamageProfileTemplates[arg_6_6]

		DamageUtils.damage_level_unit(arg_6_1, self.owner_unit, str, arg_6_4, self.melee_boost_curve_multiplier, arg_6_3, var_6_13, num_2, direction_length, item_name)
	else
		self.weapon_system:send_rpc_attack_hit(var_6_5, unit_game_object_id, game_object_or_level_id, torso, num, direction_length, var_6_2, "power_level", arg_6_4, "hit_target_index", arg_6_2, "blocking", false, "shield_break_procced", false, "boost_curve_multiplier", arg_6_5, "is_critical_strike", arg_6_3, "can_damage", true, "can_stagger", true, "first_hit", arg_6_2 == 1)
	end

	local var_6_14 = NetworkLookup.effects["fx/wpnfx_staff_death/curse_spirit_impact"]
	local look = Quaternion.look(direction_length)

	if not self.is_server then
		Managers.state.network:rpc_play_particle_effect(nil, var_6_14, NetworkConstants.invalid_game_object_id, 0, num, look, false)
	else
		Managers.state.network.network_transmit:send_rpc_server("rpc_play_particle_effect", var_6_14, NetworkConstants.invalid_game_object_id, 0, num, look, false)
	end

	Managers.state.entity:system("audio_system"):play_audio_unit_event("Play_career_necro_passive_shadow_blood", arg_6_1)
end

ActionChainedProjectile.destroy = function (arg_7_0)
	-- function 7
	return
end

ActionChainedProjectile.passive_update = function (self, arg_8_1, arg_8_2)
	-- function 8
	if self._active_projectiles_n <= 0 then
		return
	end

	local owner_unit = self.owner_unit
	local broadphase = Managers.state.entity:system("ai_system").broadphase
	local var_8_2 = Managers.state.side.side_by_unit[owner_unit]
	local flag = not var_8_2 and var_8_2.enemy_broadphase_categories
	local _active_projectiles = self._active_projectiles

	for i = self._active_projectiles_n, 1, -1 do
		local var_8_5 = _active_projectiles[i]

		if not (var_8_5.next_target_unit or not (arg_8_2 >= var_8_5.target_selection_t)) then
			if not self:_select_next_target(var_8_5, broadphase, flag) then
				table.swap_delete(_active_projectiles, i)

				self._active_projectiles_n = self._active_projectiles_n - 1
			end
		elseif arg_8_2 >= var_8_5.next_chain_t then
			if not self:_apply_chain_damage(var_8_5, broadphase, flag) then
				var_8_5.next_target_unit = nil
				var_8_5.next_chain_t = arg_8_2 + var_8_5.settings.chain_delay
				var_8_5.target_selection_t = arg_8_2 + var_8_5.settings.target_selection_delay
			else
				table.swap_delete(_active_projectiles, i)

				self._active_projectiles_n = self._active_projectiles_n - 1
			end
		end
	end
end

local tbl = {}

ActionChainedProjectile._select_next_target = function (self, arg_9_1, arg_9_2, arg_9_3)
	-- function 9
	local settings = arg_9_1.settings
	local hit_units = arg_9_1.hit_units
	local unbox = arg_9_1.last_chain_pos:unbox()

	table.clear(tbl)

	local var_9_3 = tbl
	local query = Broadphase.query(arg_9_2, unbox, settings.chain_distance, var_9_3, arg_9_3)

	for i = 1, query do
		local var_9_5 = var_9_3[i]

		if hit_units[var_9_5] or not HEALTH_ALIVE[var_9_5] then
			hit_units[var_9_5] = true

			local node

			if not Unit.has_node(var_9_5, "j_spine") then
				node = Unit.node(var_9_5, "j_spine")

				if not node then
					-- Nothing
				end
			end

			node = 0

			::label_9_0::

			local world_position = Unit.world_position(var_9_5, node)
			local var_9_8 = Vector3(math.lerp(-0.5, 0.5, math.random()), math.lerp(-0.5, 0.5, math.random()), math.lerp(-0.5, 0.5, math.random()))
			local num = unbox + (world_position - unbox) / 2 + var_9_8

			self:_play_fx("fx/wpnfx_staff_death/curse_spirit", unbox, num, world_position, true)

			arg_9_1.next_target_unit = var_9_5

			return true
		end
	end

	return false
end

ActionChainedProjectile._play_fx = function (self, arg_10_1, arg_10_2, arg_10_3, arg_10_4, arg_10_5)
	-- function 10
	local var_10_0 = NetworkLookup.effects[arg_10_1]
	local tbl = {
		arg_10_2,
		arg_10_3,
		arg_10_4
	}

	if not arg_10_5 then
		if not self._chain_sound_event then
			self._audio_system:play_audio_position_event(self._chain_sound_event, arg_10_2)
		end
	elseif not self._fire_sound_event and not self.first_person_extension then
		self.first_person_extension:play_hud_sound_event(self._fire_sound_event)
	end

	if not self.is_server then
		Managers.state.network:rpc_play_particle_effect_spline(nil, var_10_0, self.fx_spline_ids, tbl)
	else
		Managers.state.network.network_transmit:send_rpc_server("rpc_play_particle_effect_spline", var_10_0, self.fx_spline_ids, tbl)
	end
end

ActionChainedProjectile._apply_chain_damage = function (self, arg_11_1, arg_11_2, arg_11_3)
	-- function 11
	local settings = arg_11_1.settings
	local num = arg_11_1.chain_count + 1
	local next_target_unit = arg_11_1.next_target_unit

	if not HEALTH_ALIVE[next_target_unit] then
		local unbox = arg_11_1.last_chain_pos:unbox()

		self:_apply_damage(next_target_unit, num + 1, arg_11_1.is_critical_strike, arg_11_1.power_level, arg_11_1.boost_curve_multiplier, settings.damage_profile, unbox)
	end

	if not (not ALIVE[next_target_unit] and not (num <= settings.max_chain_count)) then
		local var_11_4

		if not Unit.has_node(next_target_unit, "j_spine") then
			local node = Unit.node(next_target_unit, "j_spine")

			var_11_4 = Unit.world_position(next_target_unit, node)
		else
			var_11_4 = Unit.world_position(next_target_unit, 0) + Vector3.up() * 0.8
		end

		arg_11_1.chain_count = num

		arg_11_1.last_chain_pos:store(var_11_4)

		return true
	else
		return false
	end
end
