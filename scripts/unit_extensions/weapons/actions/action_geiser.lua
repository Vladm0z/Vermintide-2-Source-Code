-- chunkname: @scripts/unit_extensions/weapons/actions/action_geiser.lua

ActionGeiser = class(ActionGeiser, ActionBase)

ActionGeiser.init = function (self, arg_1_1, arg_1_2, arg_1_3, arg_1_4, arg_1_5, arg_1_6, arg_1_7, arg_1_8)
	-- function 1
	ActionGeiser.super.init(self, arg_1_1, arg_1_2, arg_1_3, arg_1_4, arg_1_5, arg_1_6, arg_1_7, arg_1_8)

	self.overcharge_extension = ScriptUnit.extension(arg_1_4, "overcharge_system")
	self._damage_buffer = {}
	self._damage_buffer_index = 1
	self._check_buffs = false
end

ActionGeiser.client_owner_start_action = function (self, arg_2_1, arg_2_2, arg_2_3, arg_2_4)
	-- function 2
	ActionGeiser.super.client_owner_start_action(self, arg_2_1, arg_2_2, arg_2_3, arg_2_4)

	self.current_action = arg_2_1

	local owner_unit = self.owner_unit
	local is_critical_strike = ActionUtils.is_critical_strike(owner_unit, arg_2_1)
	local extension = ScriptUnit.extension(owner_unit, "buff_system")
	local charge_value = arg_2_3.charge_value

	self.charge_value = charge_value
	self.power_level = ActionUtils.scale_geiser_power_level(arg_2_4, charge_value)

	if not (not extension:has_buff_perk("full_charge_boost") and not (self.charge_value >= 1)) then
		self.power_level = extension:apply_buffs_to_value(self.power_level, "full_charge_boost")
	end

	self.owner_buff_extension = extension
	self.state = "waiting_to_shoot"

	local fire_time = arg_2_1.fire_time

	fire_time = fire_time or 0
	self.time_to_shoot = arg_2_2 + fire_time
	self.radius = arg_2_3.radius
	self.height = arg_2_3.height
	self.position = arg_2_3.position

	table.clear(self._damage_buffer)

	self._damage_buffer_index = 1
	self._check_buffs = true
	self._is_critical_strike = is_critical_strike

	if not (not self.charge_value and not (self.charge_value >= 1)) then
		extension:trigger_procs("on_full_charge_action", arg_2_1, arg_2_2, arg_2_3)
	end
end

ActionGeiser.client_owner_post_update = function (self, arg_3_1, arg_3_2, arg_3_3, arg_3_4)
	-- function 3
	local current_action = self.current_action

	if not (self.state ~= "waiting_to_shoot" or not (arg_3_2 >= self.time_to_shoot)) then
		self.state = "shooting"
	end

	if self.state == "shooting" then
		self:fire()

		self.state = "doing_damage"
	end

	if self.state ~= "doing_damage" or not self:_update_damage(current_action) then
		self:_proc_spell_used(self.owner_buff_extension)

		self.state = "shot"
	end
end

ActionGeiser.finish = function (self, arg_4_1)
	-- function 4
	if not (self.state == "waiting_to_shoot" or self.state == "shot") then
		self:_proc_spell_used(self.owner_buff_extension)
	end

	self.position = nil

	local has_extension = ScriptUnit.has_extension(self.owner_unit, "hud_system")

	if not has_extension then
		has_extension.show_critical_indication = false
	end
end

ActionGeiser.fire = function (self, arg_5_1)
	-- function 5
	local current_action = self.current_action
	local owner_unit = self.owner_unit
	local owner_player = self.owner_player
	local radius = self.radius
	local num = self.height * 0.5
	local unbox = self.position:unbox()
	local get_data = World.get_data(self.world, "physics_world")
	local network = Managers.state.network
	local num_2 = unbox + Vector3(0, 0, num)
	local var_5_9 = unbox
	local num_3 = num + radius
	local flag

	flag = not (num_3 - radius > 0) or not "capsule" or "sphere"

	local immediate_overlap, var_5_13 = PhysicsWorld.immediate_overlap(get_data, "shape", flag, "position", num_2, "size", Vector3(radius, num_3, radius), "rotation", Quaternion.look(Vector3.up(), Vector3.up()), "collision_filter", "filter_character_trigger")
	local charge_value = self.charge_value
	local particle_effect = current_action.particle_effect
	local overcharge_type = current_action.overcharge_type
	local get_difficulty_settings = Managers.state.difficulty:get_difficulty_settings()
	local flag_2 = not DamageUtils.allow_friendly_fire_ranged(get_difficulty_settings, owner_player)
	local small_charge_value = current_action.small_charge_value

	small_charge_value = small_charge_value or 0.33

	local medium_charge_value = current_action.medium_charge_value

	medium_charge_value = medium_charge_value or 0.66

	local large_charge_value = current_action.large_charge_value

	large_charge_value = large_charge_value or 1

	local flag_3 = not global_is_inside_inn and current_action.can_proc_in_inn
	local str = "_large"

	if charge_value < small_charge_value then
		str = "_small"
	elseif charge_value < medium_charge_value then
		str = "_medium"
	elseif not (large_charge_value <= charge_value) or not flag_3 then
		str = "_large"

		local unit_game_object_id = network:unit_game_object_id(owner_unit)
		local var_5_25 = NetworkLookup.damage_sources[self.item_name]
		local aoe_name = current_action.aoe_name
		local var_5_27 = NetworkLookup.explosion_templates[aoe_name]

		overcharge_type = current_action.overcharge_type_heavy

		self.network_transmit:send_rpc_server("rpc_client_create_aoe", unit_game_object_id, var_5_9, var_5_25, var_5_27, radius)
	end

	if not particle_effect then
		local str_2 = particle_effect .. str
		local particle_radius_variable = current_action.particle_radius_variable
		local var_5_30 = NetworkLookup.effects[str_2]
		local var_5_31 = NetworkLookup.effects[particle_radius_variable]
		local var_5_32 = Vector3(radius, 1, 1)

		self.network_transmit:send_rpc_server("rpc_play_simple_particle_with_vector_variable", var_5_30, unbox, var_5_31, var_5_32)
	end

	if not overcharge_type then
		local var_5_33 = PlayerUnitStatusSettings.overcharge_values[overcharge_type]
		local extension = ScriptUnit.extension(owner_unit, "buff_system")

		if not self._is_critical_strike and not extension:has_buff_perk("no_overcharge_crit") then
			var_5_33 = 0
		end

		self.overcharge_extension:add_charge(var_5_33, charge_value, overcharge_type)
	end

	local fire_sound_event = self.current_action.fire_sound_event

	if not fire_sound_event then
		local fire_sound_on_husk = self.current_action.fire_sound_on_husk

		ScriptUnit.extension(owner_unit, "first_person_system"):play_hud_sound_event(fire_sound_event, nil, fire_sound_on_husk)
	end

	local _damage_buffer = self._damage_buffer
	local tbl = {}
	local damage_profile = current_action.damage_profile

	damage_profile = damage_profile or "default"

	local var_5_40 = DamageProfileTemplates[damage_profile]
	local side = Managers.state.side
	local var_5_42 = side.side_by_unit[owner_unit]
	local flag_4 = not owner_player and owner_player.player_unit

	if var_5_13 > 0 then
		local num_4 = 0

		for i = 1, var_5_13 do
			local var_5_45 = immediate_overlap[i]
			local unit = Actor.unit(var_5_45)
			local var_5_47 = POSITION_LOOKUP[unit]

			var_5_47 = var_5_47 or Unit.local_position(unit, 0)

			local get_data_2 = Unit.get_data(unit, "breed")

			if not tbl[unit] then
				local is_enemy = side:is_enemy(owner_unit, unit)
				local flag_5 = not (var_5_42 == side.side_by_unit[unit]) and not flag_2
				local flag_6 = is_enemy or flag_5

				if not is_enemy then
					local flag_7 = not get_data_2 and get_data_2.is_player
					local flag_8 = not get_data_2 and not flag_7
					local flag_9 = not not is_enemy or side:is_ally(owner_unit, unit)

					if not flag_4 and not flag_8 and not flag_9 then
						flag_6 = false
					end
				end

				if not flag_6 then
					local num_5 = var_5_47 - var_5_9
					local length = Vector3.length(num_5)
					local var_5_57

					if not var_5_40.target_radius and not var_5_40.targets then
						local num_6 = length / radius

						if not AiUtils.attack_is_shield_blocked(unit, owner_unit) then
							num_6 = math.lerp(num_6, 1, 0.5)
						end

						for k, v in pairs(var_5_40.target_radius) do
							if num_6 <= v then
								var_5_57 = k

								break
							end
						end
					end

					tbl[unit] = true

					if not HEALTH_ALIVE[unit] then
						num_4 = num_4 + 1
					end

					local tbl_2 = {
						hit_zone_name = "torso",
						hit_unit = unit,
						damage_profile_name = damage_profile,
						target_index = var_5_57,
						allow_critical_proc = var_5_57 == 1,
						hit_index = num_4
					}

					_damage_buffer[#_damage_buffer + 1] = tbl_2
				end
			end
		end
	end

	if not current_action.alert_enemies then
		Managers.state.entity:system("ai_system"):alert_enemies_within_range(owner_unit, var_5_9, current_action.alert_sound_range_fire)
	end

	local has_extension = ScriptUnit.has_extension(owner_unit, "hud_system")

	self:_handle_critical_strike(self._is_critical_strike, self.owner_buff_extension, has_extension, nil, "on_critical_shot", nil)
end

local num = 1

ActionGeiser._update_damage = function (self, arg_6_1)
	-- function 6
	local _damage_buffer = self._damage_buffer
	local _damage_buffer_index = self._damage_buffer_index
	local num_2 = _damage_buffer_index + num - 1
	local network = Managers.state.network
	local owner_unit = self.owner_unit
	local item_name = self.item_name
	local var_6_6 = NetworkLookup.damage_sources[item_name]
	local unit_game_object_id = network:unit_game_object_id(owner_unit)
	local unbox = self.position:unbox()

	for i = _damage_buffer_index, num_2 do
		repeat
			local var_6_9 = _damage_buffer[i]

			if not var_6_9 then
				return true
			end

			local hit_unit = var_6_9.hit_unit
			local damage_profile_name = var_6_9.damage_profile_name
			local target_index = var_6_9.target_index
			local hit_zone_name = var_6_9.hit_zone_name
			local allow_critical_proc = var_6_9.allow_critical_proc
			local hit_index = var_6_9.hit_index

			if not Unit.alive(hit_unit) then
				break
			end

			local get_ranged_boost, var_6_17 = ActionUtils.get_ranged_boost(owner_unit)
			local _is_critical_strike = self._is_critical_strike

			_is_critical_strike = _is_critical_strike or get_ranged_boost

			local flag = true
			local get_item_buff_type = DamageUtils.get_item_buff_type(self.item_name)

			DamageUtils.buff_on_attack(owner_unit, hit_unit, "aoe", not _is_critical_strike and allow_critical_proc, hit_zone_name, hit_index, flag, get_item_buff_type, nil, self.item_name)

			local unit_game_object_id_2 = network:unit_game_object_id(hit_unit)

			if not unit_game_object_id_2 then
				break
			end

			local var_6_22 = NetworkLookup.hit_zones[hit_zone_name]
			local var_6_23 = NetworkLookup.damage_profiles[damage_profile_name]
			local var_6_24 = POSITION_LOOKUP[hit_unit]

			var_6_24 = var_6_24 or Unit.local_position(hit_unit, 0)

			local normalize = Vector3.normalize(var_6_24 - unbox)
			local power_level = self.power_level
			local flag_2 = false
			local flag_3 = false

			Managers.state.entity:system("weapon_system"):send_rpc_attack_hit(var_6_6, unit_game_object_id, unit_game_object_id_2, var_6_22, var_6_24, normalize, var_6_23, "power_level", power_level, "hit_target_index", target_index, "blocking", flag_2, "shield_break_procced", flag_3, "boost_curve_multiplier", var_6_17, "is_critical_strike", _is_critical_strike)
		until true
	end

	self._damage_buffer_index = num_2 + 1
end
