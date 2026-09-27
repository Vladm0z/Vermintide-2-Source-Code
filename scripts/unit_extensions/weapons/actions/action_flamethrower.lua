-- chunkname: @scripts/unit_extensions/weapons/actions/action_flamethrower.lua

ActionFlamethrower = class(ActionFlamethrower, ActionBase)

local num = -1.5
local num_2 = math.abs(num) + 10
local num_3 = 2
local num_4 = 50
local tbl = {
	"j_leftshoulder",
	"j_rightshoulder",
	"j_spine1"
}
local count = #tbl

ActionFlamethrower.init = function (self, arg_1_1, arg_1_2, arg_1_3, arg_1_4, arg_1_5, arg_1_6, arg_1_7, arg_1_8)
	-- function 1
	ActionFlamethrower.super.init(self, arg_1_1, arg_1_2, arg_1_3, arg_1_4, arg_1_5, arg_1_6, arg_1_7, arg_1_8)

	if not ScriptUnit.has_extension(arg_1_7, "ammo_system") then
		self.ammo_extension = ScriptUnit.extension(arg_1_7, "ammo_system")
	end

	self.overcharge_extension = ScriptUnit.extension(arg_1_4, "overcharge_system")
	self.buff_extension = ScriptUnit.extension(arg_1_4, "buff_system")
	self.targets = {}
	self.old_targets = {}
	self.stop_sound_event = "Stop_player_combat_weapon_drakegun_flamethrower_shoot"
	self.unit_id = Managers.state.network.unit_storage:go_id(arg_1_4)
end

ActionFlamethrower.client_owner_start_action = function (self, arg_2_1, arg_2_2, arg_2_3, arg_2_4)
	-- function 2
	ActionFlamethrower.super.client_owner_start_action(self, arg_2_1, arg_2_2, arg_2_3, arg_2_4)

	self.current_action = arg_2_1
	self.power_level = arg_2_4
	self.state = "waiting_to_shoot"
	self.time_to_shoot = arg_2_2 + arg_2_1.fire_time
	self.overcharge_timer = 0
	self.damage_timer = 1

	local stop_fire_event = arg_2_1.stop_fire_event

	stop_fire_event = stop_fire_event or self.stop_sound_event
	self.stop_sound_event = stop_fire_event

	local fx_node = arg_2_1.fx_node

	fx_node = fx_node or "fx_muzzle"
	self.muzzle_node_name = fx_node
	self._fx_stopped = false

	local dot_check = arg_2_1.dot_check

	dot_check = dot_check or 0.95
	self.dot_check = dot_check

	local num_3

	if not arg_2_1.spray_range then
		num_3 = math.abs(num) + arg_2_1.spray_range

		if not num_3 then
			-- Nothing
		end
	end

	num_3 = num_2

	::label_2_0::

	self.spray_range = num_3

	local charge_level

	if not arg_2_3 then
		charge_level = arg_2_3.charge_level

		if not charge_level then
			-- Nothing
		end
	end

	charge_level = 1

	::label_2_1::

	self.charge_level = charge_level

	local num_4

	if not arg_2_1.fire_stop_time then
		num_4 = arg_2_2 + arg_2_1.fire_stop_time

		if not num_4 then
			-- Nothing
		end
	end

	do
		local charge_level_2 = self.charge_level
		local charge_fuel_time_multiplier = arg_2_1.charge_fuel_time_multiplier

		charge_fuel_time_multiplier = charge_fuel_time_multiplier or 3
		num_4 = arg_2_2 + charge_level_2 * charge_fuel_time_multiplier
	end

	::label_2_2::

	self.max_flame_time = num_4

	if not (not self.buff_extension:has_buff_perk("full_charge_boost") and not (self.charge_level >= 1)) then
		self.power_level = self.buff_extension:apply_buffs_to_value(self.power_level, "full_charge_boost")
	end

	if not (not arg_2_3 and not arg_2_3.charge_level and not self.charge_level and not (self.charge_level >= 1)) then
		self.buff_extension:trigger_procs("on_full_charge_action", arg_2_1, arg_2_2, arg_2_3)
	end

	table.clear(self.old_targets)
	table.clear(self.targets)
end

local num_5 = 4

ActionFlamethrower.client_owner_post_update = function (self, arg_3_1, arg_3_2, arg_3_3, arg_3_4)
	-- function 3
	local owner_unit = self.owner_unit
	local first_person_unit = self.first_person_unit
	local current_action = self.current_action
	local owner_player = self.owner_player
	local bot_player = owner_player.bot_player
	local network_transmit = self.network_transmit
	local is_server = self.is_server

	if not (self.state ~= "waiting_to_shoot" or not (arg_3_2 >= self.time_to_shoot)) then
		self.state = "shooting"

		local flag = not current_action.first_person_muzzle and first_person_unit and self.weapon_unit
		local muzzle_node_name = self.muzzle_node_name
		local unit_id = self.unit_id
		local node = Unit.node(flag, muzzle_node_name)
		local world_position = Unit.world_position(flag, node)
		local world_rotation = Unit.world_rotation(flag, node)
		local particle_effect_flames = current_action.particle_effect_flames
		local particle_effect_flames_3p = current_action.particle_effect_flames_3p
		local var_3_15 = NetworkLookup.effects[particle_effect_flames_3p]

		if not bot_player then
			self._flamethrower_effect = World.create_particles(arg_3_3, particle_effect_flames, world_position, world_rotation)

			World.link_particles(arg_3_3, self._flamethrower_effect, flag, node, Matrix4x4.identity(), "destroy")
		end

		if not current_action.first_person_muzzle then
			if is_server or not LEVEL_EDITOR_TEST then
				if not bot_player then
					network_transmit:send_rpc_all("rpc_start_flamethrower", unit_id, var_3_15)
				else
					network_transmit:send_rpc_clients("rpc_start_flamethrower", unit_id, var_3_15)
				end
			else
				network_transmit:send_rpc_server("rpc_start_flamethrower", unit_id, var_3_15)
			end
		end

		if not current_action.fire_sound_event then
			if not self._source_id then
				local flag_2 = not self.owner_player.local_player
				local set_switch = WwiseWorld.set_switch
				local wwise_world = self.wwise_world
				local str = "husk"
				local flag_3

				flag_3 = not flag_2 and "true" and "false"

				set_switch(wwise_world, str, flag_3, self._source_id)
				WwiseWorld.trigger_event(self.wwise_world, self.stop_sound_event, self._source_id)
			else
				self._source_id = WwiseWorld.make_auto_source(self.wwise_world, self.weapon_unit)
			end

			local flag_4 = not self.owner_player.local_player
			local set_switch_2 = WwiseWorld.set_switch
			local wwise_world_2 = self.wwise_world
			local str_2 = "husk"
			local flag_5

			flag_5 = not flag_4 and "true" and "false"

			set_switch_2(wwise_world_2, str_2, flag_5, self._source_id)
			WwiseWorld.trigger_event(self.wwise_world, current_action.fire_sound_event, self._source_id)
		end
	end

	self.overcharge_timer = self.overcharge_timer + arg_3_1

	if not (self.state ~= "shooting" or not (self.overcharge_timer >= current_action.overcharge_interval)) then
		local var_3_26 = PlayerUnitStatusSettings.overcharge_values[current_action.overcharge_type]

		if not self.buff_extension then
			local has_buff_perk = self.buff_extension:has_buff_perk("no_overcharge_crit")

			if not ActionUtils.is_critical_strike(owner_unit, current_action, arg_3_2) and not has_buff_perk then
				var_3_26 = 0
			end
		end

		self.overcharge_extension:add_charge(var_3_26)

		self.overcharge_timer = 0
	end

	if not (self.state ~= "shooting" or not (arg_3_2 < self.max_flame_time)) then
		local current_position = ScriptUnit.extension(owner_unit, "first_person_system"):current_position()

		if not (Managers.player:owner(owner_unit).bot_player or self._rumble_effect_id) then
			self._rumble_effect_id = Managers.state.controller_features:add_effect("persistent_rumble", {
				rumble_effect = "reload_start"
			})
		end

		local damage_interval = current_action.damage_interval
		local num = 0

		if not damage_interval then
			if self.damage_timer >= current_action.damage_interval then
				self.damage_timer = 0
			end

			if self.damage_timer == 0 then
				self:_check_critical_strike(arg_3_2)
				self:_select_targets(arg_3_3, true)

				local targets = self.targets
				local flag_6 = true

				for i = 1, #targets do
					local flag_7 = false
					local var_3_34 = targets[i]

					if not Unit.alive(var_3_34) then
						local get_data = Unit.get_data(var_3_34, "breed")
						local str_3 = "j_spine"

						if not get_data then
							num = num + 1

							local round = math.round(Math.random_range(1, count))

							for j = 1, count do
								local index_wrapper = math.index_wrapper(round + j - 1, count)
								local var_3_39 = tbl[index_wrapper]

								if not Unit.has_node(var_3_34, var_3_39) then
									str_3 = var_3_39

									break
								end
							end
						end

						local world_position_2 = Unit.world_position(var_3_34, Unit.node(var_3_34, str_3))
						local normalize = Vector3.normalize(world_position_2 - current_position)
						local raycast_to_target = self:raycast_to_target(arg_3_3, current_position, normalize, var_3_34)

						if not raycast_to_target then
							local power_level = self.power_level
							local old_targets = self.old_targets

							old_targets = not old_targets and self.old_targets[var_3_34]

							local var_3_45

							if not old_targets then
								power_level = power_level * (math.clamp(old_targets, 0, 4) * 0.5)

								if old_targets < 5 then
									var_3_45 = current_action.initial_damage_profile or current_action.damage_profile or "default"
								end
							else
								var_3_45 = current_action.initial_damage_profile or current_action.damage_profile or "default"
							end

							if not DamageUtils.process_projectile_hit(arg_3_3, self.item_name, owner_unit, is_server, raycast_to_target, current_action, normalize, flag_6, var_3_34, nil, self._is_critical_strike, power_level, var_3_45, num).buffs_checked then
								flag_6 = not flag_6 and false
							end

							flag_7 = true
						end
					end

					targets[var_3_34] = flag_7
				end

				local spray_range = current_action.spray_range

				spray_range = spray_range or num_2

				local get_data_2 = World.get_data(arg_3_3, "physics_world")
				local world_rotation_2 = Unit.world_rotation(first_person_unit, 0)
				local normalize_2 = Vector3.normalize(Quaternion.forward(world_rotation_2))
				local immediate_raycast_actors = PhysicsWorld.immediate_raycast_actors(get_data_2, current_position, normalize_2, spray_range, "static_collision_filter", "filter_player_ray_projectile_static_only", "dynamic_collision_filter", "filter_player_ray_projectile_hitbox_only")
				local var_3_51

				if not immediate_raycast_actors then
					local get_difficulty_settings = Managers.state.difficulty:get_difficulty_settings()
					local allow_friendly_fire_ranged = DamageUtils.allow_friendly_fire_ranged(get_difficulty_settings, owner_player)
					local PLAYER_AND_BOT_UNITS = Managers.state.side.side_by_unit[self.owner_unit].PLAYER_AND_BOT_UNITS

					for k, v in pairs(immediate_raycast_actors) do
						local var_3_55 = v[num_5]
						local unit = Actor.unit(var_3_55)
						local flag_8 = not var_3_51 and Unit.get_data(var_3_51, "breed")

						if not (unit == self.owner_unit or targets[unit] or flag_8) then
							if not table.contains(PLAYER_AND_BOT_UNITS, unit) then
								if not allow_friendly_fire_ranged then
									var_3_51 = unit

									break
								end
							else
								var_3_51 = unit

								break
							end
						end
					end

					if not var_3_51 and not immediate_raycast_actors then
						DamageUtils.process_projectile_hit(arg_3_3, self.item_name, self.owner_unit, is_server, immediate_raycast_actors, current_action, normalize_2, flag_6, var_3_51, nil, self._is_critical_strike, self.power_level)
					end
				end

				self:_clear_targets()
			end

			self.damage_timer = self.damage_timer + arg_3_1
		end
	elseif not (not (arg_3_2 >= self.max_flame_time) or self.state ~= "shooting") then
		self.state = "shot"

		self:_stop_fx()
		self:_proc_spell_used(self.buff_extension)
	end
end

ActionFlamethrower._stop_fx = function (self)
	-- function 4
	if not self._fx_stopped then
		return
	end

	if not self._flamethrower_effect then
		World.stop_spawning_particles(self.world, self._flamethrower_effect)

		self._flamethrower_effect = nil
	end

	local unit_id = self.unit_id

	if self.is_server or not LEVEL_EDITOR_TEST then
		if not self.owner_player.bot_player then
			self.network_transmit:send_rpc_all("rpc_end_flamethrower", unit_id)
		else
			self.network_transmit:send_rpc_clients("rpc_end_flamethrower", unit_id)
		end
	else
		self.network_transmit:send_rpc_server("rpc_end_flamethrower", unit_id)
	end

	local _source_id = self._source_id

	if not _source_id then
		local flag = not self.owner_player.local_player
		local set_switch = WwiseWorld.set_switch
		local wwise_world = self.wwise_world
		local str = "husk"
		local flag_2

		flag_2 = not flag and "true" and "false"

		set_switch(wwise_world, str, flag_2, _source_id)
		WwiseWorld.trigger_event(self.wwise_world, self.stop_sound_event, _source_id)

		self._source_id = nil
	end

	local has_extension = ScriptUnit.has_extension(self.owner_unit, "hud_system")

	if not has_extension then
		has_extension.show_critical_indication = false
	end

	if not self._rumble_effect_id then
		Managers.state.controller_features:stop_effect(self._rumble_effect_id)

		self._rumble_effect_id = nil
	end
end

ActionFlamethrower.finish = function (self, arg_5_1)
	-- function 5
	self:_clear_targets()

	if self.state ~= "shot" then
		self:_proc_spell_used(self.buff_extension)
	end

	self:_stop_fx()
end

ActionFlamethrower.destroy = function (self)
	-- function 6
	if not self._flamethrower_effect then
		World.destroy_particles(self.world, self._flamethrower_effect)

		self._flamethrower_effect = nil
	end
end

ActionFlamethrower._clear_targets = function (self)
	-- function 7
	local targets = self.targets
	local old_targets = self.old_targets
	local tbl = {}

	for i = 1, #targets do
		local var_7_3

		if not old_targets then
			var_7_3 = old_targets[targets[i]]

			if not var_7_3 then
				-- Nothing
			end
		end

		var_7_3 = 0

		::label_7_0::

		tbl[targets[i]] = var_7_3 + 1
	end

	table.clear(self.old_targets)
	table.clear(self.targets)

	self.old_targets = tbl
end

ActionFlamethrower._select_targets = function (self, arg_8_1, arg_8_2)
	-- function 8
	local owner_unit = self.owner_unit
	local extension = ScriptUnit.extension(owner_unit, "first_person_system")
	local var_8_2 = Vector3(0, 0, -0.4)
	local num_3 = extension:current_position() + var_8_2
	local first_person_unit = self.first_person_unit
	local world_rotation = Unit.world_rotation(first_person_unit, 0)
	local normalize = Vector3.normalize(Quaternion.forward(world_rotation))
	local flag = not Managers.state.difficulty:get_difficulty_settings().friendly_fire_ranged
	local num_5 = num_3 + normalize * num
	local num_6 = 6
	local side = BLACKBOARDS[owner_unit].side
	local tbl = {}
	local broadphase_query = AiUtils.broadphase_query(num_3 + normalize * num_6, num_6, tbl)
	local get_data = World.get_data(arg_8_1, "physics_world")

	PhysicsWorld.prepare_actors_for_overlap(get_data, num_5, num_2 * num_2)

	if broadphase_query > 0 then
		local targets = self.targets
		local temp_count, var_8_16, var_8_17 = Script.temp_count()
		local num_7 = 0

		for i = 1, broadphase_query do
			local var_8_19 = tbl[i]
			local num_8 = POSITION_LOOKUP[var_8_19] + Vector3.up()

			if targets[var_8_19] == nil then
				local var_8_21 = side.enemy_units_lookup[var_8_19]

				if (var_8_21 or not flag or not self:_is_infront_player(num_3, normalize, num_8)) and not self:_check_within_cone(num_5, normalize, var_8_19, var_8_21) then
					targets[#targets + 1] = var_8_19
					targets[var_8_19] = false

					if not var_8_21 and not HEALTH_ALIVE[var_8_19] then
						num_7 = num_7 + 1
					end
				end

				if num_7 >= num_4 then
					break
				end
			end
		end

		Script.set_temp_count(temp_count, var_8_16, var_8_17)
	end
end

ActionFlamethrower._check_within_cone = function (self, arg_9_1, arg_9_2, arg_9_3, arg_9_4)
	-- function 9
	local world_position = Unit.world_position(arg_9_3, Unit.node(arg_9_3, "j_neck"))
	local normalize = Vector3.normalize(world_position - arg_9_1)
	local dot = Vector3.dot(arg_9_2, normalize)
	local dot_check

	if not arg_9_4 then
		dot_check = self.dot_check

		if not dot_check then
			-- Nothing
		end
	end

	dot_check = 0.99

	::label_9_0::

	if dot_check <= dot then
		return true
	end

	return false
end

ActionFlamethrower._is_infront_player = function (arg_10_0, arg_10_1, arg_10_2, arg_10_3)
	-- function 10
	local normalize = Vector3.normalize(arg_10_3 - arg_10_1)

	if Vector3.dot(normalize, arg_10_2) > 0 then
		return true
	end
end

ActionFlamethrower.raycast_to_target = function (arg_11_0, arg_11_1, arg_11_2, arg_11_3, arg_11_4)
	-- function 11
	local get_data = World.get_data(arg_11_1, "physics_world")
	local str = "filter_player_ray_projectile"

	return (PhysicsWorld.immediate_raycast(get_data, arg_11_2, arg_11_3, num_2, "all", "collision_filter", str))
end

ActionFlamethrower._check_critical_strike = function (self, arg_12_1)
	-- function 12
	local owner_unit = self.owner_unit
	local current_action = self.current_action
	local is_critical_strike = ActionUtils.is_critical_strike(owner_unit, current_action, arg_12_1)
	local has_extension = ScriptUnit.has_extension(owner_unit, "hud_system")

	self:_handle_critical_strike(is_critical_strike, self.buff_extension, has_extension, nil, "on_critical_shot", nil)

	self._is_critical_strike = is_critical_strike
end
