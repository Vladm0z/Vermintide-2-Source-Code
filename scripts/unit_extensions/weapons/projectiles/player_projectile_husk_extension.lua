-- chunkname: @scripts/unit_extensions/weapons/projectiles/player_projectile_husk_extension.lua

PlayerProjectileHuskExtension = class(PlayerProjectileHuskExtension)

PlayerProjectileHuskExtension.init = function (self, arg_1_1, arg_1_2, arg_1_3)
	-- function 1
	local owner_unit = arg_1_3.owner_unit
	local item_name = arg_1_3.item_name

	self._world = arg_1_1.world
	self._wwise_world = Managers.world:wwise_world(self._world)
	self._projectile_unit = arg_1_2
	self._owner_unit = owner_unit
	self._owner_player = Managers.player:owner(owner_unit)
	self.item_name = item_name

	local has_extension = ScriptUnit.has_extension(owner_unit, "inventory_system")

	if not has_extension then
		local equipment = has_extension:equipment()

		if not equipment then
			local wielded = equipment.wielded

			if not wielded then
				local var_1_5

				self._skin_projectile_units_template = wielded.projectile_units_template

				local get_slot_data = has_extension:get_slot_data(equipment.wielded_slot)

				if not get_slot_data then
					local skin = get_slot_data.skin
					local var_1_8 = WeaponSkins.skins[skin]

					if not var_1_8 then
						var_1_5 = var_1_8.material_settings_name
						self._skin_projectile_units_template = var_1_8.projectile_units_template
					end
				end

				local get_item_units = BackendUtils.get_item_units(wielded)

				if not (not get_item_units and get_item_units.is_ammo_weapon) then
					local get_item_template = BackendUtils.get_item_template(wielded)

					if not var_1_5 then
						-- Nothing
					end

					::label_1_0::

					local material_settings_name = get_item_units.material_settings_name

					material_settings_name = material_settings_name or get_item_template.material_settings_name

					::label_1_1::

					if not material_settings_name then
						GearUtils.apply_material_settings(arg_1_2, material_settings_name)

						self._material_settings_name = material_settings_name
					end
				end
			end
		end
	end

	if not self._skin_projectile_units_template then
		local get_data = Unit.get_data(arg_1_2, "unit_name")

		self._skin_projectile_units_template = ProjectileUnitsFromUnitName[get_data]
	end

	local var_1_13 = ItemMasterList[item_name]
	local get_item_template_2 = BackendUtils.get_item_template(var_1_13)
	local item_template_name = arg_1_3.item_template_name
	local action_name = arg_1_3.action_name
	local sub_action_name = arg_1_3.sub_action_name
	local has_extension_2 = ScriptUnit.has_extension(self._owner_unit, "buff_system")

	self.action_lookup_data = {
		item_template_name = item_template_name,
		action_name = action_name,
		sub_action_name = sub_action_name
	}

	local var_1_19 = get_item_template_2.actions[action_name][sub_action_name]

	self._current_action = var_1_19

	local projectile_info = var_1_19.projectile_info
	local impact_data = var_1_19.impact_data
	local timed_data = var_1_19.timed_data

	self.charge_data = var_1_19.charge_data

	if not impact_data.grenade and not has_extension_2 and not has_extension_2:has_buff_perk("frag_fire_grenades") then
		impact_data = table.shallow_copy(impact_data)
		impact_data.aoe = ExplosionUtils.get_template("frag_fire_grenade")
	end

	self.power_level = arg_1_3.power_level
	self.projectile_info = projectile_info
	self._impact_data = impact_data
	self._timed_data = timed_data
	self._time_initialized = arg_1_3.time_initialized
	self.scale = arg_1_3.scale

	local charge_level = arg_1_3.charge_level

	charge_level = charge_level or 0
	self.charge_level = charge_level / 100
	self._num_targets_hit = 0
	self._hit_units = {}
	self.projectile_linker_system = Managers.state.entity:system("projectile_linker_system")
	self._is_server = Managers.player.is_server
	self._active = true
	self._was_active = true
	self._did_damage = false
	self._num_bounces = 0
	self._num_additional_penetrations = has_extension_2:apply_buffs_to_value(0, "ranged_additional_penetrations")
	self._is_critical_strike = not not arg_1_3.is_critical_strike

	self:initialize_projectile(projectile_info, impact_data)
end

PlayerProjectileHuskExtension.destroy = function (self)
	-- function 2
	if not (not self._projectile_unit and not self._active and self.is_server) then
		self:stop()
	end
end

PlayerProjectileHuskExtension.extensions_ready = function (self, arg_3_1, arg_3_2)
	-- function 3
	self.locomotion_extension = ScriptUnit.extension(arg_3_2, "projectile_locomotion_system")
end

PlayerProjectileHuskExtension.initialize_projectile = function (self, arg_4_1, arg_4_2)
	-- function 4
	local _projectile_unit = self._projectile_unit

	if not arg_4_2 then
		self._is_impact = true
		self._stop_impacts = false
		self._amount_of_mass_hit = 0

		local damage_profile = arg_4_2.damage_profile

		damage_profile = damage_profile or "default"

		local var_4_2 = DamageProfileTemplates[damage_profile]
		local _owner_unit = self._owner_unit
		local get_difficulty = Managers.state.difficulty:get_difficulty()
		local scale_power_levels = ActionUtils.scale_power_levels(self.power_level, "cleave", _owner_unit, get_difficulty)
		local get_max_targets, var_4_7 = ActionUtils.get_max_targets(var_4_2, scale_power_levels)

		self._max_mass = not (var_4_7 < get_max_targets) or not get_max_targets or var_4_7
	end

	local _timed_data = self._timed_data

	if not _timed_data then
		self._is_timed = true

		if not _timed_data.activate_life_time_on_impact then
			self._life_time = math.huge
		else
			self:_activate_life_time(self._time_initialized)
		end

		if not _timed_data.charge_time then
			self._charge_t = self._time_initialized + _timed_data.charge_time * (1 - self.charge_level)
		end
	end

	if not arg_4_1.times_bigger then
		local scale = self.scale

		Unit.set_flow_variable(_projectile_unit, "scale", scale)

		local times_bigger = arg_4_1.times_bigger
		local lerp = math.lerp(1, times_bigger, scale)

		Unit.set_local_scale(_projectile_unit, 0, Vector3(lerp, lerp, lerp))
	end

	Unit.flow_event(_projectile_unit, "lua_projectile_init")
	self:_handle_critical_strike(_projectile_unit, self._is_critical_strike)
	Unit.flow_event(_projectile_unit, "lua_trail")
end

PlayerProjectileHuskExtension._handle_critical_strike = function (self, arg_5_1, arg_5_2)
	-- function 5
	if not self._is_critical_strike then
		Unit.flow_event(arg_5_1, "vfx_critical_strike")
	end
end

PlayerProjectileHuskExtension.update = function (self, arg_6_1, arg_6_2, arg_6_3, arg_6_4, arg_6_5)
	-- function 6
	if not self._active then
		if not self._was_active then
			self._was_active = false
		end

		return
	end

	if not self._is_timed then
		self:handle_timed_events(arg_6_5)
	end
end

PlayerProjectileHuskExtension.stop = function (self, arg_7_1, arg_7_2)
	-- function 7
	local custom_stop_func = self.projectile_info.custom_stop_func

	if not custom_stop_func and not custom_stop_func(self, arg_7_1, arg_7_2) then
		self._stop_impacts = true

		return
	end

	local _timed_data = self._timed_data

	if not (not _timed_data and _timed_data.activate_life_time_on_impact) then
		Unit.flow_event(self._projectile_unit, "lua_projectile_end")

		self._active = false
	end

	self.locomotion_extension:stop()

	self._stop_impacts = true
end

PlayerProjectileHuskExtension._stop_by_life_time = function (self)
	-- function 8
	Unit.flow_event(self._projectile_unit, "lua_projectile_end")

	self._active = false

	self.locomotion_extension:stop()

	self._stop_impacts = true
end

PlayerProjectileHuskExtension.handle_timed_events = function (self, arg_9_1)
	-- function 9
	if arg_9_1 >= self._life_time then
		local _projectile_unit = self._projectile_unit
		local _timed_data = self._timed_data
		local aoe = _timed_data.aoe

		if not aoe then
			local var_9_3 = POSITION_LOOKUP[_projectile_unit]

			self:do_aoe(aoe, var_9_3)

			if not _timed_data.grenade then
				local _owner_unit = self._owner_unit
				local has_extension = ScriptUnit.has_extension(_owner_unit, "buff_system")
				local local_rotation = Unit.local_rotation(_projectile_unit, 0)

				if not has_extension then
					has_extension:trigger_procs("on_grenade_exploded", _timed_data, var_9_3, self._is_critical_strike, self.item_name, local_rotation, self.scale, self.power_level)
				end
			end
		end

		local life_time_activate_sound_stop_event = self._timed_data.life_time_activate_sound_stop_event

		if not life_time_activate_sound_stop_event then
			WwiseWorld.trigger_event(self._wwise_world, life_time_activate_sound_stop_event)
		end

		self:_stop_by_life_time()
	end

	if not (not self._charge_t and not (arg_9_1 >= self._charge_t)) then
		self._charge_t = nil
		self.is_charged = true

		local charged_flow_event = self._timed_data.charged_flow_event

		Unit.flow_event(self._projectile_unit, charged_flow_event)
	end
end

PlayerProjectileHuskExtension.impact_level = function (self, arg_10_1, arg_10_2, arg_10_3, arg_10_4, arg_10_5, arg_10_6)
	-- function 10
	local _impact_data = self._impact_data

	self:hit_level_unit(_impact_data, arg_10_1, arg_10_2, arg_10_3, arg_10_4, arg_10_5, self._hit_units, arg_10_6)
	self:_on_impact()
end

PlayerProjectileHuskExtension._on_impact = function (self)
	-- function 11
	local _timed_data = self._timed_data

	if not _timed_data and not _timed_data.activate_life_time_on_impact then
		local time = Managers.time:time("game")

		self:_activate_life_time(time)
	end
end

PlayerProjectileHuskExtension._activate_life_time = function (self, arg_12_1)
	-- function 12
	local _timed_data = self._timed_data
	local life_time_activate_sound_start_event = _timed_data.life_time_activate_sound_start_event

	if not life_time_activate_sound_start_event then
		WwiseWorld.trigger_event(self._wwise_world, life_time_activate_sound_start_event)
	end

	self._life_time = arg_12_1 + _timed_data.life_time
end

PlayerProjectileHuskExtension.impact_dynamic = function (self, arg_13_1, arg_13_2, arg_13_3, arg_13_4, arg_13_5)
	-- function 13
	local _impact_data = self._impact_data
	local get_data = Unit.get_data(arg_13_1, "breed")
	local flag = false
	local num = 0
	local num_2 = 0

	if not get_data then
		local is_player = get_data.is_player

		if not DamageUtils.is_enemy(self._owner_unit, arg_13_1) then
			self:hit_enemy(_impact_data, arg_13_1, arg_13_2, arg_13_3, arg_13_4, arg_13_5, get_data, self._hit_units, num_2)
		elseif not is_player then
			self:hit_player(_impact_data, arg_13_1, arg_13_2, arg_13_3, arg_13_4, arg_13_5, self._hit_units, num_2)
		end
	else
		local game_object_or_level_id, var_13_7 = Managers.state.network:game_object_or_level_id(arg_13_1)

		if not var_13_7 then
			local var_13_8

			self:hit_level_unit(_impact_data, arg_13_1, arg_13_2, arg_13_3, arg_13_4, arg_13_5, self._hit_units, var_13_8, flag, num_2)
		elseif not var_13_7 then
			self:hit_non_level_unit(_impact_data, arg_13_1, arg_13_2, arg_13_3, arg_13_4, arg_13_5, self._hit_units, num_2)
		end
	end

	self:_on_impact()
end

PlayerProjectileHuskExtension.hit_afro = function (arg_14_0, arg_14_1, arg_14_2)
	-- function 14
	local node = Actor.node(arg_14_2)
	local name = arg_14_1.hit_zones_lookup[node].name

	return name == "afro", name
end

PlayerProjectileHuskExtension.hit_enemy = function (self, arg_15_1, arg_15_2, arg_15_3, arg_15_4, arg_15_5, arg_15_6, arg_15_7, arg_15_8, arg_15_9)
	-- function 15
	if arg_15_6 == nil then
		return
	end

	local hit_afro, var_15_1 = self:hit_afro(arg_15_7, arg_15_6)

	if not hit_afro then
		return
	end

	local damage_profile = arg_15_1.damage_profile

	damage_profile = damage_profile or "default"

	local var_15_3 = DamageProfileTemplates[damage_profile]
	local flag = true
	local aoe = arg_15_1.aoe
	local flag_2 = false

	if not var_15_3 then
		flag, flag_2 = self:hit_enemy_damage(var_15_3, arg_15_2, arg_15_3, arg_15_4, arg_15_5, arg_15_6, arg_15_7, arg_15_9, arg_15_8)
	end

	local grenade = arg_15_1.grenade

	if not (not aoe and grenade or not (self._amount_of_mass_hit >= self._max_mass)) then
		self:do_aoe(aoe, arg_15_3)

		if not grenade then
			local _owner_unit = self._owner_unit
			local has_extension = ScriptUnit.has_extension(_owner_unit, "buff_system")

			if not has_extension then
				has_extension:trigger_procs("on_grenade_exploded", arg_15_1, arg_15_3, self._is_critical_strike, self.item_name, Unit.local_rotation(self._projectile_unit, 0), self.scale, self.power_level)
			end
		end

		self:stop(arg_15_2, var_15_1)
	end

	if self._amount_of_mass_hit >= self._max_mass then
		if self._num_additional_penetrations > 0 then
			flag_2 = true
		else
			if not flag then
				self:_handle_linking(arg_15_1, arg_15_2, arg_15_3, arg_15_4, arg_15_5, arg_15_6, self._did_damage, true)
			end

			self:stop(arg_15_2, var_15_1)
		end
	end

	if not flag_2 then
		self._num_additional_penetrations = self._num_additional_penetrations - 1
	end
end

PlayerProjectileHuskExtension.hit_enemy_damage = function (self, arg_16_1, arg_16_2, arg_16_3, arg_16_4, arg_16_5, arg_16_6, arg_16_7, arg_16_8, arg_16_9)
	-- function 16
	local _owner_player = self._owner_player
	local _owner_unit = self._owner_unit
	local _current_action = self._current_action
	local node = Actor.node(arg_16_6)
	local var_16_4 = arg_16_7.hit_zones_lookup[node]
	local forced_hitzone = _current_action.projectile_info.forced_hitzone

	forced_hitzone = forced_hitzone or var_16_4.name

	local var_16_6 = HEALTH_ALIVE[arg_16_2]

	if not var_16_6 then
		self._num_targets_hit = self._num_targets_hit + 1
		arg_16_9[arg_16_2] = true
	end

	local default_target = arg_16_1.default_target
	local _is_critical_strike = self._is_critical_strike
	local get_attack_template = DamageUtils.get_attack_template(default_target.attack_template)
	local flag = false
	local flag_2 = false
	local trueflight_blocking = default_target.trueflight_blocking

	if not _current_action.ignore_shield_hit then
		flag = AiUtils.attack_is_shield_blocked(arg_16_2, _owner_unit, trueflight_blocking, arg_16_4)
	end

	if not var_16_6 then
		local hit_mass_count = _current_action.hit_mass_count
		local get_difficulty_rank = Managers.state.difficulty:get_difficulty_rank()
		local var_16_15

		if not flag then
			if not arg_16_7.hit_mass_counts_block then
				var_16_15 = arg_16_7.hit_mass_counts_block[get_difficulty_rank]

				if not var_16_15 then
					-- Nothing
				end

				var_16_15 = arg_16_7.hit_mass_counts_block[2]

				if not var_16_15 then
					-- Nothing
				end
			end

			var_16_15 = arg_16_7.hit_mass_count_block

			if not var_16_15 then
				-- Nothing
			end
		end

		if not arg_16_7.hit_mass_counts then
			var_16_15 = arg_16_7.hit_mass_counts[get_difficulty_rank]

			if not var_16_15 then
				-- Nothing
			end

			var_16_15 = arg_16_7.hit_mass_counts[2]

			if not var_16_15 then
				-- Nothing
			end
		end

		var_16_15 = arg_16_7.hit_mass_count
		var_16_15 = var_16_15 or 1

		::label_16_0::

		if not self.ignore_mass_and_armour then
			var_16_15 = 1
		elseif not hit_mass_count and not hit_mass_count[arg_16_7.name] then
			var_16_15 = var_16_15 * (hit_mass_count[arg_16_7.name] or 1)
		end

		self._amount_of_mass_hit = self._amount_of_mass_hit + var_16_15
	end

	local ceil = math.ceil(self._amount_of_mass_hit)
	local hit_effect = _current_action.hit_effect
	local flag_3 = not _owner_player.local_player
	local sound_type = get_attack_template.sound_type
	local name = arg_16_7.name
	local look = Quaternion.look(arg_16_5)
	local power_level = self.power_level
	local item_name = self.item_name
	local calculate_damage, var_16_25 = DamageUtils.calculate_damage(DamageOutput, arg_16_2, _owner_unit, forced_hitzone, power_level, BoostCurves[default_target.boost_curve_type], arg_16_8, _is_critical_strike, arg_16_1, ceil, nil, item_name)
	local flag_4 = calculate_damage <= 0

	if not var_16_6 and not flag_4 then
		self._did_damage = calculate_damage

		if self._num_additional_penetrations > 0 then
			flag_2 = true
		else
			self._amount_of_mass_hit = self._max_mass

			self:stop(arg_16_2, forced_hitzone)
		end
	elseif not var_16_6 and _current_action.ignore_armor or arg_16_7.armor_category == 2 or arg_16_7.armor_category == 3 or not flag then
		self._did_damage = calculate_damage

		if self._num_additional_penetrations > 0 then
			flag_2 = true
		else
			self._amount_of_mass_hit = self._max_mass

			self:stop(arg_16_2, forced_hitzone)
		end
	else
		self._did_damage = calculate_damage

		if not (forced_hitzone == "head" or forced_hitzone ~= "neck") then
			self._did_damage = calculate_damage - 1
		end

		EffectHelper.player_critical_hit(self._world, _is_critical_strike, _owner_unit, arg_16_2, arg_16_3)
	end

	if not var_16_25 then
		hit_effect = "invulnerable"
	end

	if not hit_effect then
		EffectHelper.play_skinned_surface_material_effects(hit_effect, self._world, arg_16_2, arg_16_3, look, arg_16_5, flag_3, name, sound_type, flag_4, forced_hitzone, flag, arg_16_7)
	end

	return forced_hitzone ~= "ward", flag_2
end

PlayerProjectileHuskExtension.hit_player = function (self, arg_17_1, arg_17_2, arg_17_3, arg_17_4, arg_17_5, arg_17_6, arg_17_7, arg_17_8)
	-- function 17
	if arg_17_6 == nil then
		return
	end

	local get_difficulty_settings = Managers.state.difficulty:get_difficulty_settings()
	local flag = false
	local flag_2 = false
	local _owner_player = self._owner_player
	local damage_profile = arg_17_1.damage_profile

	damage_profile = damage_profile or "default"

	local var_17_5 = DamageProfileTemplates[damage_profile]

	if not (not var_17_5 and not DamageUtils.allow_friendly_fire_ranged(get_difficulty_settings, _owner_player) and arg_17_7[arg_17_2] ~= nil) then
		self:hit_player_damage(var_17_5, arg_17_2, arg_17_3, arg_17_4, arg_17_5, arg_17_6, arg_17_8, arg_17_7)

		flag = true
	end

	if not flag then
		local aoe = arg_17_1.aoe

		if not (not aoe and not (self._amount_of_mass_hit >= self._max_mass)) then
			if self._num_additional_penetrations > 0 then
				flag_2 = true
			else
				self:do_aoe(aoe, arg_17_3)

				if not arg_17_1.grenade then
					local _owner_unit = self._owner_unit
					local has_extension = ScriptUnit.has_extension(_owner_unit, "buff_system")

					if not has_extension then
						has_extension:trigger_procs("on_grenade_exploded", arg_17_1, arg_17_3, self._is_critical_strike, self.item_name, Unit.local_rotation(self._projectile_unit, 0), self.scale, self.power_level)
					end
				end

				self:stop()
			end
		end

		if self._amount_of_mass_hit >= self._max_mass then
			if self._num_additional_penetrations > 0 then
				flag_2 = true
			else
				self:stop()
			end
		end
	end

	if not flag_2 then
		self._num_additional_penetrations = self._num_additional_penetrations - 1
	end
end

PlayerProjectileHuskExtension.hit_player_damage = function (self, arg_18_1, arg_18_2, arg_18_3, arg_18_4, arg_18_5, arg_18_6, arg_18_7, arg_18_8)
	-- function 18
	local _owner_unit = self._owner_unit

	arg_18_8[arg_18_2] = true
	self._num_targets_hit = self._num_targets_hit + 1
	self._amount_of_mass_hit = self._amount_of_mass_hit + 1

	local ceil = math.ceil(self._amount_of_mass_hit)
	local default_target = arg_18_1.default_target
	local hit_effect = self._current_action.hit_effect
	local flag = not self._owner_player.local_player
	local look = Quaternion.look(arg_18_4, Vector3.up())
	local power_level = self.power_level
	local str = "torso"
	local _is_critical_strike = self._is_critical_strike
	local item_name = self.item_name
	local calculate_damage, var_18_11 = DamageUtils.calculate_damage(DamageOutput, arg_18_2, _owner_unit, str, power_level, BoostCurves[default_target.boost_curve_type], arg_18_7, _is_critical_strike, arg_18_1, ceil, nil, item_name)

	if not (calculate_damage <= 0) then
		self._did_damage = false
		self._stop_impacts = true
	else
		self._did_damage = calculate_damage
	end

	if not var_18_11 then
		hit_effect = "invulnerable"
	end

	if not hit_effect then
		EffectHelper.play_skinned_surface_material_effects(hit_effect, self._world, arg_18_2, arg_18_3, look, arg_18_5, flag)
	end
end

PlayerProjectileHuskExtension.hit_level_unit = function (self, arg_19_1, arg_19_2, arg_19_3, arg_19_4, arg_19_5, arg_19_6, arg_19_7, arg_19_8, arg_19_9)
	-- function 19
	local has_extension = ScriptUnit.has_extension(arg_19_2, "health_system")
	local damage_profile_prop = arg_19_1.damage_profile_prop

	if not damage_profile_prop then
		damage_profile_prop = arg_19_1.damage_profile
		damage_profile_prop = damage_profile_prop or "default"
	end

	local var_19_2 = DamageProfileTemplates[damage_profile_prop]
	local flag = Unit.get_data(arg_19_2, "allow_ranged_damage") ~= false

	if not var_19_2 and GameSettingsDevelopment.allow_ranged_attacks_to_damage_props and not flag then
		if not (not has_extension and arg_19_7[arg_19_2] ~= nil) then
			self:hit_damagable_prop(var_19_2, arg_19_2, arg_19_3, arg_19_4, arg_19_5, arg_19_6, arg_19_7, arg_19_8, arg_19_9)
		elseif not arg_19_2 and not Unit.alive(arg_19_2) and not arg_19_6 then
			local set_flow_variable = Unit.set_flow_variable

			set_flow_variable(arg_19_2, "hit_actor", arg_19_6)
			set_flow_variable(arg_19_2, "hit_direction", arg_19_4)
			set_flow_variable(arg_19_2, "hit_position", arg_19_3)
			Unit.flow_event(arg_19_2, "lua_simple_damage")
		end
	end

	local hit_effect = self._current_action.hit_effect

	if not hit_effect then
		local _world = self._world
		local look = Quaternion.look(arg_19_4)
		local flag_2 = not self._owner_player.local_player

		EffectHelper.play_surface_material_effects(hit_effect, _world, arg_19_2, arg_19_3, look, arg_19_5, nil, flag_2, nil, arg_19_6)
	end

	local bounce_on_level_units = arg_19_1.bounce_on_level_units
	local has_extension_2 = ScriptUnit.has_extension(self._owner_unit, "buff_system")
	local num = 0

	if not ((arg_19_1.grenade or not has_extension_2) and bounce_on_level_units) then
		bounce_on_level_units = has_extension_2:has_buff_perk("add_projectile_bounces")
		num = has_extension_2:apply_buffs_to_value(num, "projectile_bounces")
	end

	local flag_3 = false

	if not bounce_on_level_units then
		local _num_bounces = self._num_bounces
		local max_bounces = arg_19_1.max_bounces

		max_bounces = max_bounces or 1

		local num_2 = max_bounces + num
		local locomotion_extension = self.locomotion_extension

		if not (not locomotion_extension.bounce and not (_num_bounces < num_2)) then
			locomotion_extension:bounce(arg_19_3, arg_19_4, arg_19_5)

			self._num_bounces = self._num_bounces + 1
		else
			flag_3 = true
		end
	end

	local aoe = arg_19_1.aoe
	local aoe_on_bounce = arg_19_1.aoe_on_bounce

	if not aoe and not bounce_on_level_units and flag_3 or not aoe_on_bounce then
		self:do_aoe(aoe, arg_19_3)

		if not arg_19_1.grenade and not has_extension_2 then
			has_extension_2:trigger_procs("on_grenade_exploded", arg_19_1, arg_19_3, self._is_critical_strike, self.item_name, Unit.local_rotation(self._projectile_unit, 0), self.scale, self.power_level)
		end
	end

	if not (not bounce_on_level_units and flag_3) then
		return
	elseif not arg_19_6 then
		self:_handle_linking(arg_19_1, arg_19_2, arg_19_3, arg_19_4, arg_19_5, arg_19_6)
	end

	self:stop()
end

PlayerProjectileHuskExtension.hit_damagable_prop = function (arg_20_0, arg_20_1, arg_20_2, arg_20_3, arg_20_4, arg_20_5, arg_20_6, arg_20_7, arg_20_8, arg_20_9)
	-- function 20
	arg_20_7[arg_20_2] = true
end

PlayerProjectileHuskExtension.hit_non_level_unit = function (self, arg_21_1, arg_21_2, arg_21_3, arg_21_4, arg_21_5, arg_21_6, arg_21_7, arg_21_8)
	-- function 21
	local damage_profile_prop = arg_21_1.damage_profile_prop

	if not damage_profile_prop then
		damage_profile_prop = arg_21_1.damage_profile
		damage_profile_prop = damage_profile_prop or "default"
	end

	local var_21_1 = DamageProfileTemplates[damage_profile_prop]
	local flag = false

	if not var_21_1 then
		if not (not ScriptUnit.has_extension(arg_21_2, "health_system") and arg_21_7[arg_21_2] ~= nil) then
			self:hit_non_level_damagable_unit(var_21_1, arg_21_2, arg_21_3, arg_21_4, arg_21_5, arg_21_6, arg_21_7, arg_21_8)

			flag = true
		elseif not arg_21_2 and not Unit.alive(arg_21_2) and not arg_21_6 then
			local set_flow_variable = Unit.set_flow_variable

			set_flow_variable(arg_21_2, "hit_actor", arg_21_6)
			set_flow_variable(arg_21_2, "hit_direction", arg_21_4)
			set_flow_variable(arg_21_2, "hit_position", arg_21_3)
			Unit.flow_event(arg_21_2, "lua_simple_damage")
		end
	end

	local aoe = arg_21_1.aoe

	if not aoe then
		self:do_aoe(aoe, arg_21_3)

		if not arg_21_1.grenade then
			local _owner_unit = self._owner_unit
			local has_extension = ScriptUnit.has_extension(_owner_unit, "buff_system")

			if not has_extension then
				has_extension:trigger_procs("on_grenade_exploded", arg_21_1, arg_21_3, self._is_critical_strike, self.item_name, Unit.local_rotation(self._projectile_unit, 0), self.scale, self.power_level)
			end
		end

		flag = true
	end

	if not flag then
		if self._num_additional_penetrations > 0 then
			self._num_additional_penetrations = self._num_additional_penetrations - 1
		else
			self:stop()
		end
	end
end

PlayerProjectileHuskExtension.hit_non_level_damagable_unit = function (self, arg_22_1, arg_22_2, arg_22_3, arg_22_4, arg_22_5, arg_22_6, arg_22_7, arg_22_8)
	-- function 22
	arg_22_7[arg_22_2] = true

	local hit_effect = self._current_action.hit_effect

	if not hit_effect then
		local _world = self._world
		local look = Quaternion.look(arg_22_4)
		local flag = not self._owner_player.local_player

		EffectHelper.play_surface_material_effects(hit_effect, _world, arg_22_2, arg_22_3, look, arg_22_5, nil, flag, nil, arg_22_6)
	end
end

PlayerProjectileHuskExtension._get_projectile_units_names = function (self, arg_23_1)
	-- function 23
	local projectile_units_template = arg_23_1.projectile_units_template

	projectile_units_template = not arg_23_1.use_weapon_skin and self._skin_projectile_units_template and projectile_units_template

	return ProjectileUnits[projectile_units_template]
end

PlayerProjectileHuskExtension._handle_linking = function (self, arg_24_1, arg_24_2, arg_24_3, arg_24_4, arg_24_5, arg_24_6, arg_24_7, arg_24_8)
	-- function 24
	if not (arg_24_1.link or arg_24_1.link_pickup) then
		return
	end

	local flag = true
	local get_data = Unit.get_data(arg_24_2, "allow_link")

	if get_data ~= nil then
		flag = get_data
	end

	if not flag then
		return
	end

	local projectile_info = self.projectile_info
	local _get_projectile_units_names = self:_get_projectile_units_names(projectile_info)
	local flag_2 = not _get_projectile_units_names and _get_projectile_units_names.dummy_linker_unit_name

	if not flag_2 then
		local depth = arg_24_1.depth

		depth = depth or 0.15

		local depth_offset = arg_24_1.depth_offset

		depth_offset = depth_offset or 0.15

		if not _get_projectile_units_names.dummy_linker_broken_units then
			local random = Math.random()

			if not arg_24_7 then
				random = random * math.clamp(arg_24_7 / 2, 0.75, 1.25)
			else
				random = random * 2
			end

			if random <= 0.5 then
				local count = #_get_projectile_units_names.dummy_linker_broken_units
				local random_2 = Math.random(1, count)

				flag_2 = _get_projectile_units_names.dummy_linker_broken_units[random_2]

				if random_2 == 1 then
					depth = 0.05
					depth_offset = 0.1
				else
					depth_offset = 0.15
				end
			end
		elseif not arg_24_7 then
			depth = depth * math.clamp(arg_24_7, 1, 3)
		end

		local num = depth + depth_offset

		self:_link_projectile(arg_24_2, arg_24_6, flag_2, arg_24_3, arg_24_4, num, arg_24_1.flow_event_on_init, arg_24_1.flow_event_on_walls)
	end
end

PlayerProjectileHuskExtension._link_projectile = function (self, arg_25_1, arg_25_2, arg_25_3, arg_25_4, arg_25_5, arg_25_6, arg_25_7, arg_25_8)
	-- function 25
	if not Managers.state.side:versus_is_dark_pact(arg_25_1) then
		local unit_owner = Managers.player:unit_owner(arg_25_1)

		if not (not unit_owner and not unit_owner.local_player and unit_owner.bot_player) then
			return
		end
	end

	local unit_spawner = Managers.state.unit_spawner
	local projectile_linker_system = self.projectile_linker_system
	local num = Math.random() * 2.14 - 0.5
	local normalize = Vector3.normalize(arg_25_5)
	local num_2 = arg_25_4 + normalize * arg_25_6
	local multiply = Quaternion.multiply(Quaternion.look(normalize), Quaternion(Vector3.forward(), num))
	local var_25_7

	if not ScriptUnit.has_extension(arg_25_1, "projectile_linker_system") then
		local node = Actor.node(arg_25_2)

		var_25_7 = unit_spawner:spawn_local_unit(arg_25_3, num_2, multiply)

		local world_rotation = Unit.world_rotation(arg_25_1, node)
		local num_3 = num_2 - Unit.world_position(arg_25_1, node)
		local var_25_11 = Vector3(Vector3.dot(Quaternion.right(world_rotation), num_3), Vector3.dot(Quaternion.forward(world_rotation), num_3), Vector3.dot(Quaternion.up(world_rotation), num_3))

		if not arg_25_7 then
			Unit.flow_event(var_25_7, arg_25_7)
		end

		ScriptUnit.extension(arg_25_1, "projectile_linker_system"):link_projectile(var_25_7, var_25_11, multiply, node)
		projectile_linker_system:add_linked_projectile_reference(arg_25_1, var_25_7)
	else
		var_25_7 = unit_spawner:spawn_local_unit(arg_25_3, num_2, multiply)

		projectile_linker_system:add_linked_projectile_reference(arg_25_1, var_25_7)

		if not arg_25_7 then
			Unit.flow_event(var_25_7, arg_25_7)
		end

		if not arg_25_8 then
			Unit.flow_event(var_25_7, arg_25_8)
		end
	end

	if not self._material_settings_name then
		GearUtils.apply_material_settings(var_25_7, self._material_settings_name)
	end
end

PlayerProjectileHuskExtension.do_aoe = function (self, arg_26_1, arg_26_2)
	-- function 26
	local _world = self._world
	local _projectile_unit = self._projectile_unit
	local _owner_unit = self._owner_unit
	local item_name = self.item_name
	local _is_server = self._is_server
	local _owner_unit_2 = self._owner_unit

	if not arg_26_1.explosion then
		local local_rotation = Unit.local_rotation(_projectile_unit, 0)
		local scale = self.scale
		local power_level = self.power_level
		local flag = true

		DamageUtils.create_explosion(_world, _owner_unit, arg_26_2, local_rotation, arg_26_1, scale, item_name, _is_server, flag, _projectile_unit, power_level, self._is_critical_strike, _owner_unit_2)
	end

	if not _is_server then
		if not arg_26_1.aoe then
			DamageUtils.create_aoe(_world, _owner_unit, arg_26_2, item_name, arg_26_1)
		end

		if not arg_26_1.taunt then
			DamageUtils.create_taunt(_world, _owner_unit, _projectile_unit, arg_26_2, arg_26_1)
		end
	end
end

PlayerProjectileHuskExtension.trigger_external_event = function (self, arg_27_1, arg_27_2)
	-- function 27
	local external_events = self.projectile_info.external_events
	local flag = not external_events and external_events[arg_27_1]

	if not flag then
		flag(self)
	end
end
