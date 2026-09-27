-- chunkname: @scripts/unit_extensions/weapons/actions/action_beam.lua

ActionBeam = class(ActionBeam, ActionBase)

ActionBeam.init = function (self, arg_1_1, arg_1_2, arg_1_3, arg_1_4, arg_1_5, arg_1_6, arg_1_7, arg_1_8)
	-- function 1
	ActionBeam.super.init(self, arg_1_1, arg_1_2, arg_1_3, arg_1_4, arg_1_5, arg_1_6, arg_1_7, arg_1_8)

	if not ScriptUnit.has_extension(arg_1_7, "ammo_system") then
		self.ammo_extension = ScriptUnit.extension(arg_1_7, "ammo_system")
	end

	self.inventory_extension = ScriptUnit.extension(arg_1_4, "inventory_system")
	self.overcharge_extension = ScriptUnit.extension(arg_1_4, "overcharge_system")
	self._rumble_effect_id = false
	self.unit_id = Managers.state.network.unit_storage:go_id(arg_1_4)
end

ActionBeam.client_owner_start_action = function (self, arg_2_1, arg_2_2, arg_2_3, arg_2_4)
	-- function 2
	ActionBeam.super.client_owner_start_action(self, arg_2_1, arg_2_2, arg_2_3, arg_2_4)

	self.current_action = arg_2_1

	local owner_unit = self.owner_unit
	local extension = ScriptUnit.extension(owner_unit, "buff_system")

	self.status_extension, self.owner_buff_extension = ScriptUnit.extension(owner_unit, "status_system"), extension
	self.state = "waiting_to_shoot"
	self.time_to_shoot = arg_2_2 + arg_2_1.fire_time
	self.current_target = nil
	self.damage_timer = 0
	self.overcharge_timer = 0
	self.ramping_interval = 1
	self.consecutive_hits = 0
	self.power_level = arg_2_4
	self.do_zoom = arg_2_1.do_zoom
	self.damage_interval = arg_2_1.damage_interval
	self.charge_damage_profiles = arg_2_1.charge_damage_profiles
	self.damage_profile = arg_2_1.damage_profile

	local charge_level

	if not arg_2_3 then
		charge_level = arg_2_3.charge_level

		if not charge_level then
			-- Nothing
		end
	end

	charge_level = 0

	::label_2_0::

	self.charge_level = charge_level
	self.power_level = arg_2_4 + arg_2_4 * self.charge_level
	self.damage_interval = self.damage_interval - self.damage_interval / 2 * self.charge_level

	if not self.charge_damage_profiles then
		for i = 1, #self.charge_damage_profiles do
			local var_2_3 = self.charge_damage_profiles[i]

			if self.charge_level > var_2_3.threshold then
				self.damage_profile = var_2_3.damage_profile
			end
		end
	end

	self._is_critical_strike = false
	self._num_hits = 0

	local particle_effect_trail = arg_2_1.particle_effect_trail
	local particle_effect_trail_3p = arg_2_1.particle_effect_trail_3p
	local particle_effect_target = arg_2_1.particle_effect_target
	local var_2_7 = NetworkLookup.effects[particle_effect_trail_3p]
	local var_2_8 = NetworkLookup.effects[particle_effect_target]
	local world = self.world

	if not self.owner_player.bot_player then
		self.beam_effect_id = World.create_particles(world, particle_effect_trail, Vector3.zero())
		self.beam_effect_length_id = World.find_particles_variable(world, particle_effect_trail, "trail_length")
	end

	self.beam_end_effect_id = World.create_particles(world, particle_effect_target, Vector3.zero())

	local unit_id = self.unit_id

	if self.is_server or not LEVEL_EDITOR_TEST then
		if not self.owner_player.bot_player then
			self.network_transmit:queue_local_rpc("rpc_start_beam", unit_id, var_2_7, var_2_8, arg_2_1.range)
		else
			self.network_transmit:send_rpc_clients("rpc_start_beam", unit_id, var_2_7, var_2_8, arg_2_1.range)
		end
	else
		self.network_transmit:send_rpc_server("rpc_start_beam", unit_id, var_2_7, var_2_8, arg_2_1.range)
	end

	local overcharge_type = arg_2_1.overcharge_type

	if not overcharge_type then
		local var_2_12 = PlayerUnitStatusSettings.overcharge_values[overcharge_type]

		self.overcharge_extension:add_charge(var_2_12)
	end

	self.overcharge_target_hit = false

	self:_start_charge_sound()
end

ActionBeam._start_charge_sound = function (self)
	-- function 3
	local current_action = self.current_action
	local owner_unit = self.owner_unit
	local owner_player = self.owner_player
	local flag = not owner_player and owner_player.bot_player
	local flag_2 = not owner_player and not owner_player.remote
	local wwise_world = self.wwise_world

	if not (not flag_2 and flag) then
		local start_charge_sound, var_3_7 = ActionUtils.start_charge_sound(wwise_world, self.weapon_unit, owner_unit, current_action)

		self.charging_sound_id = start_charge_sound
		self.wwise_source_id = var_3_7
	end

	ActionUtils.play_husk_sound_event(wwise_world, current_action.charge_sound_husk_name, owner_unit, flag)
end

ActionBeam._stop_charge_sound = function (self)
	-- function 4
	local current_action = self.current_action
	local owner_unit = self.owner_unit
	local owner_player = self.owner_player
	local flag = not owner_player and owner_player.bot_player
	local flag_2 = not owner_player and not owner_player.remote
	local wwise_world = self.wwise_world

	if not (not flag_2 and flag) then
		ActionUtils.stop_charge_sound(wwise_world, self.charging_sound_id, self.wwise_source_id, current_action)

		self.charging_sound_id = nil
		self.wwise_source_id = nil
	end

	ActionUtils.play_husk_sound_event(wwise_world, current_action.charge_sound_husk_stop_event, owner_unit, flag)
end

local num = 1
local num_2 = 4

ActionBeam.client_owner_post_update = function (self, arg_5_1, arg_5_2, arg_5_3, arg_5_4)
	-- function 5
	local owner_unit = self.owner_unit
	local current_action = self.current_action
	local is_server = self.is_server
	local extension = ScriptUnit.extension(self.owner_unit, "input_system")
	local owner_buff_extension = self.owner_buff_extension
	local status_extension = self.status_extension

	if not self.do_zoom then
		if not status_extension:is_zooming() then
			status_extension:set_zooming(true)
		end

		if not owner_buff_extension:has_buff_type("increased_zoom") and not status_extension:is_zooming() and not extension:get("action_three") then
			status_extension:switch_variable_zoom(current_action.buffed_zoom_thresholds)
		elseif not current_action.zoom_thresholds and not status_extension:is_zooming() and not extension:get("action_three") then
			status_extension:switch_variable_zoom(current_action.zoom_thresholds)
		end
	end

	if not (self.state ~= "waiting_to_shoot" or not (arg_5_2 >= self.time_to_shoot)) then
		self.state = "shooting"
	end

	self.overcharge_timer = self.overcharge_timer + arg_5_1

	if self.overcharge_timer >= current_action.overcharge_interval then
		local charging = PlayerUnitStatusSettings.overcharge_values.charging

		self.overcharge_extension:add_charge(charging)

		self._is_critical_strike = ActionUtils.is_critical_strike(owner_unit, current_action, arg_5_2)
		self.overcharge_timer = 0
		self.overcharge_target_hit = false
	end

	if self.state == "shooting" then
		if not (Managers.player:owner(self.owner_unit).bot_player or self._rumble_effect_id) then
			self._rumble_effect_id = Managers.state.controller_features:add_effect("persistent_rumble", {
				rumble_effect = "reload_start"
			})
		end

		local extension_2 = ScriptUnit.extension(owner_unit, "first_person_system")
		local get_projectile_start_position_rotation, var_5_9 = extension_2:get_projectile_start_position_rotation()
		local forward = Quaternion.forward(var_5_9)
		local get_data = World.get_data(self.world, "physics_world")
		local range = current_action.range

		range = range or 30

		local immediate_raycast_actors = PhysicsWorld.immediate_raycast_actors(get_data, get_projectile_start_position_rotation, forward, range, "static_collision_filter", "filter_player_ray_projectile_static_only", "dynamic_collision_filter", "filter_player_ray_projectile_ai_only", "dynamic_collision_filter", "filter_player_ray_projectile_hitbox_only")
		local num_3 = get_projectile_start_position_rotation + forward * range
		local var_5_15
		local var_5_16

		if not immediate_raycast_actors then
			local get_difficulty_settings = Managers.state.difficulty:get_difficulty_settings()
			local owner_player = self.owner_player
			local allow_friendly_fire_ranged = DamageUtils.allow_friendly_fire_ranged(get_difficulty_settings, owner_player)

			for k, v in pairs(immediate_raycast_actors) do
				local var_5_20 = v[num]
				local var_5_21 = v[num_2]
				local unit = Actor.unit(var_5_21)
				local redirect_shield_hit, var_5_24 = ActionUtils.redirect_shield_hit(unit, var_5_21)

				if redirect_shield_hit ~= owner_unit then
					local get_data_2 = Unit.get_data(redirect_shield_hit, "breed")
					local var_5_26

					if not get_data_2 then
						local is_enemy = DamageUtils.is_enemy(owner_unit, redirect_shield_hit)
						local node = Actor.node(var_5_24)
						local name = get_data_2.hit_zones_lookup[node].name

						var_5_26 = not allow_friendly_fire_ranged and get_data_2.is_player and not is_enemy and name ~= "afro"
					else
						var_5_26 = true
					end

					if not var_5_26 then
						var_5_16 = var_5_20 - forward * 0.15
						var_5_15 = redirect_shield_hit

						break
					end
				end
			end

			if not var_5_16 then
				num_3 = var_5_16
			end

			if not var_5_15 then
				local has_extension = ScriptUnit.has_extension(var_5_15, "health_system")

				if not has_extension then
					if var_5_15 ~= self.current_target then
						self.ramping_interval = 0.4
						self.damage_timer = 0
						self._num_hits = 0
					end

					if self.damage_timer >= self.damage_interval * self.ramping_interval then
						Managers.state.entity:system("ai_system"):alert_enemies_within_range(owner_unit, POSITION_LOOKUP[owner_unit], 5)

						self.damage_timer = 0
						self.ramping_interval = math.clamp(self.ramping_interval * 1.4, 0.45, 1.5)
					end

					if self.damage_timer == 0 then
						local _is_critical_strike = self._is_critical_strike
						local has_extension_2 = ScriptUnit.has_extension(owner_unit, "hud_system")

						self:_handle_critical_strike(_is_critical_strike, owner_buff_extension, has_extension_2, extension_2, "on_critical_shot", nil)

						if not has_extension then
							local damage_profile = self.damage_profile
							local num_4 = self.power_level * self.ramping_interval

							if var_5_15 ~= self.current_target then
								self.consecutive_hits = 0
								num_4 = num_4 * 0.5
							else
								self.consecutive_hits = self.consecutive_hits + 1
							end

							if not (self.charge_damage_profiles or not (self.consecutive_hits < 3)) then
								damage_profile = current_action.initial_damage_profile or current_action.damage_profile or "default"
							end

							extension_2:play_hud_sound_event("staff_beam_hit_enemy", nil, false)

							local flag = self._num_hits > 1

							DamageUtils.process_projectile_hit(arg_5_3, self.item_name, owner_unit, is_server, immediate_raycast_actors, current_action, forward, flag, nil, nil, self._is_critical_strike, num_4, damage_profile)

							self._num_hits = self._num_hits + 1

							if not Managers.player:owner(self.owner_unit).bot_player then
								Managers.state.controller_features:add_effect("rumble", {
									rumble_effect = "hit_character_light"
								})
							end

							if not HEALTH_ALIVE[var_5_15] then
								local var_5_36 = PlayerUnitStatusSettings.overcharge_values[current_action.overcharge_type]

								if not _is_critical_strike and not owner_buff_extension:has_buff_perk("no_overcharge_crit") then
									var_5_36 = 0
								end

								self.overcharge_extension:add_charge(var_5_36 * self.ramping_interval)
							end
						end
					end

					self.damage_timer = self.damage_timer + arg_5_1
					self.current_target = var_5_15
				end
			end
		end

		if not self.beam_effect_id then
			local weapon_unit = self.weapon_unit
			local weapon_muzzle = current_action.weapon_muzzle

			weapon_muzzle = weapon_muzzle or Unit.node(weapon_unit, "fx_muzzle")

			local world_position = Unit.world_position(weapon_unit, weapon_muzzle)
			local distance = Vector3.distance(world_position, num_3)
			local normalize = Vector3.normalize(world_position - num_3)
			local look = Quaternion.look(normalize)

			World.move_particles(arg_5_3, self.beam_effect_id, num_3, look)
			World.set_particles_variable(arg_5_3, self.beam_effect_id, self.beam_effect_length_id, Vector3(0.3, distance, 0))
			World.move_particles(arg_5_3, self.beam_end_effect_id, num_3, look)
		end
	end
end

ActionBeam._stop_fx = function (self)
	-- function 6
	local world = self.world

	if not self.beam_end_effect_id then
		World.destroy_particles(world, self.beam_end_effect_id)

		self.beam_end_effect_id = nil
	end

	if not self.beam_effect_id then
		World.destroy_particles(world, self.beam_effect_id)

		self.beam_effect_id = nil
	end

	if not self._rumble_effect_id then
		Managers.state.controller_features:stop_effect(self._rumble_effect_id)

		self._rumble_effect_id = nil
	end

	self:_stop_charge_sound()
end

ActionBeam._stop_client_vfx = function (self)
	-- function 7
	if not Managers.state.network:game() then
		local unit_id = self.unit_id

		if self.is_server or not LEVEL_EDITOR_TEST then
			if not self.owner_player.bot_player then
				self.network_transmit:queue_local_rpc("rpc_end_beam", unit_id)
			else
				self.network_transmit:send_rpc_clients("rpc_end_beam", unit_id)
			end
		else
			self.network_transmit:send_rpc_server("rpc_end_beam", unit_id)
		end
	end
end

ActionBeam.finish = function (self, arg_8_1)
	-- function 8
	if not self.do_zoom then
		self.status_extension:set_zooming(false)
	end

	self:_stop_client_vfx()
	self:_stop_fx()
	self:_proc_spell_used(self.owner_buff_extension)

	return {
		beam_consecutive_hits = math.max(self.consecutive_hits - 1, 0)
	}
end

ActionBeam.destroy = function (self)
	-- function 9
	self:_stop_client_vfx()
	self:_stop_fx()
end
