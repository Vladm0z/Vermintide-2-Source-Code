-- chunkname: @scripts/unit_extensions/weapons/projectiles/player_projectile_unit_extension.lua

PlayerProjectileUnitExtension = class(PlayerProjectileUnitExtension)

local world_rotation = Unit.world_rotation
local world_position = Unit.world_position
local forward = Quaternion.forward
local lerp = Vector3.lerp
local lerp_2 = Quaternion.lerp
local set_local_position = Unit.set_local_position
local set_local_rotation = Unit.set_local_rotation
local num = 0.3

PlayerProjectileUnitExtension.init = function (self, arg_1_1, arg_1_2, arg_1_3)
	-- function 1
	local item_name = arg_1_3.item_name
	local owner_unit = arg_1_3.owner_unit

	self._world = arg_1_1.world
	self._wwise_world = Managers.world:wwise_world(self._world)
	self._projectile_unit = arg_1_2
	self._owner_unit = owner_unit
	self._owner_player = Managers.player:owner(owner_unit)

	local has_extension = ScriptUnit.has_extension(owner_unit, "buff_system")

	self.item_name = item_name
	self._material_settings_name = nil

	local has_extension_2 = ScriptUnit.has_extension(self._owner_unit, "inventory_system")

	if not has_extension_2 then
		local equipment = has_extension_2:equipment()

		if not equipment then
			local wielded = equipment.wielded

			if not wielded then
				local get_item_units = BackendUtils.get_item_units(wielded)

				if not (not get_item_units and get_item_units.is_ammo_weapon) then
					local get_item_template = BackendUtils.get_item_template(wielded)
					local material_settings_name = get_item_units.material_settings_name

					material_settings_name = material_settings_name or get_item_template.material_settings_name

					if not material_settings_name then
						self._material_settings_name = material_settings_name
					end
				end
			end
		end
	end

	if not self._material_settings_name then
		GearUtils.apply_material_settings(arg_1_2, self._material_settings_name)
	end

	local var_1_9 = ItemMasterList[item_name]
	local get_item_template_2 = BackendUtils.get_item_template(var_1_9)
	local item_template_name = arg_1_3.item_template_name
	local action_name = arg_1_3.action_name
	local sub_action_name = arg_1_3.sub_action_name

	self.action_lookup_data = {
		item_template_name = item_template_name,
		action_name = action_name,
		sub_action_name = sub_action_name
	}

	local var_1_14 = get_item_template_2.actions[action_name][sub_action_name]

	self._current_action = var_1_14

	local projectile_info = var_1_14.projectile_info
	local impact_data = var_1_14.impact_data
	local timed_data = var_1_14.timed_data

	self.power_level = arg_1_3.power_level
	self.projectile_info = projectile_info
	self.charge_data = var_1_14.charge_data
	self.chain_hit_settings = var_1_14.chain_hit_settings

	if not impact_data.grenade and not has_extension and not has_extension:has_buff_perk("frag_fire_grenades") then
		impact_data = table.shallow_copy(impact_data)
		impact_data.aoe = ExplosionUtils.get_template("frag_fire_grenade")
	end

	if not impact_data then
		self._impact_data = impact_data

		local damage_profile = impact_data.damage_profile

		damage_profile = damage_profile or "default"
		self._impact_damage_profile_id = NetworkLookup.damage_profiles[damage_profile]
	end

	if not timed_data then
		self._timed_data = timed_data

		local damage_profile_2 = timed_data.damage_profile

		damage_profile_2 = damage_profile_2 or "default"
		self._timed_damage_profile_id = NetworkLookup.damage_profiles[damage_profile_2]
	end

	self._time_initialized = arg_1_3.time_initialized
	self.scale = arg_1_3.scale

	local charge_level = arg_1_3.charge_level

	charge_level = charge_level or 0
	self.charge_level = charge_level / 100
	self._num_targets_hit = 0
	self._hit_units = {}
	self._hit_afro_units = {}

	local entity = Managers.state.entity

	self._weapon_system = entity:system("weapon_system")
	self._projectile_linker_system = entity:system("projectile_linker_system")
	self._is_server = Managers.player.is_server
	self._marked_for_deletion = false
	self._did_damage = false
	self._num_bounces = 0
	self._num_additional_penetrations = has_extension:apply_buffs_to_value(0, "ranged_additional_penetrations")
	self._active = true
	self._is_critical_strike = not not arg_1_3.is_critical_strike
	self._stop_impacts = not not arg_1_3.stopped

	self:initialize_projectile(projectile_info, impact_data)
end

PlayerProjectileUnitExtension.extensions_ready = function (self, arg_2_1, arg_2_2)
	-- function 2
	self.locomotion_extension = ScriptUnit.extension(arg_2_2, "projectile_locomotion_system")
	self._impact_extension = ScriptUnit.extension(arg_2_2, "projectile_impact_system")
end

PlayerProjectileUnitExtension.initialize_projectile = function (self, arg_3_1, arg_3_2)
	-- function 3
	local _projectile_unit = self._projectile_unit

	if not arg_3_2 then
		self._is_impact = true
		self._stop_impacts = false
		self._amount_of_mass_hit = 0

		local damage_profile = arg_3_2.damage_profile

		damage_profile = damage_profile or "default"

		local var_3_2 = DamageProfileTemplates[damage_profile]
		local _owner_unit = self._owner_unit
		local get_difficulty = Managers.state.difficulty:get_difficulty()
		local scale_power_levels = ActionUtils.scale_power_levels(self.power_level, "cleave", _owner_unit, get_difficulty)
		local get_max_targets, var_3_7 = ActionUtils.get_max_targets(var_3_2, scale_power_levels)

		self._max_mass = not (var_3_7 < get_max_targets) or not get_max_targets or var_3_7
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

	if not arg_3_1.times_bigger then
		local scale = self.scale

		Unit.set_flow_variable(_projectile_unit, "scale", scale)

		local times_bigger = arg_3_1.times_bigger
		local lerp = math.lerp(1, times_bigger, scale)

		Unit.set_local_scale(_projectile_unit, 0, Vector3(lerp, lerp, lerp))
	end

	if not arg_3_1.hide_projectile then
		Unit.set_unit_visibility(_projectile_unit, false)
	end

	if not arg_3_1.anim_blend_settings then
		local get_first_person_unit = ScriptUnit.extension(self._owner_unit, "first_person_system"):get_first_person_unit()
		local link_node = arg_3_1.anim_blend_settings.link_node

		self._owner_unit_1p = get_first_person_unit

		local node

		if not Unit.has_node(get_first_person_unit, link_node) then
			node = Unit.node(get_first_person_unit, link_node)

			if not node then
				-- Nothing
			end
		end

		node = 0

		::label_3_0::

		self._anim_node_id = node
		self._anim_blend_enabled = true
	end

	Unit.flow_event(_projectile_unit, "lua_projectile_init")
	self:_handle_critical_strike(_projectile_unit, self._is_critical_strike)
	Unit.flow_event(_projectile_unit, "lua_trail")
end

PlayerProjectileUnitExtension._handle_critical_strike = function (self, arg_4_1, arg_4_2)
	-- function 4
	if not self._is_critical_strike then
		Unit.flow_event(arg_4_1, "vfx_critical_strike")
	end
end

PlayerProjectileUnitExtension.mark_for_deletion = function (self)
	-- function 5
	if not self._marked_for_deletion then
		self._marked_for_deletion = true
		self._deletion_time = Managers.time:time("game") + num
	end
end

PlayerProjectileUnitExtension.stop = function (self, arg_6_1, arg_6_2, arg_6_3)
	-- function 6
	if not self._stop_impacts then
		return
	end

	local _projectile_unit = self._projectile_unit

	if not self._anim_blend_enabled then
		self._anim_blend_enabled = false

		local current_position = self.locomotion_extension:current_position()
		local current_rotation = self.locomotion_extension:current_rotation()

		set_local_position(_projectile_unit, 0, current_position)
		set_local_rotation(_projectile_unit, 0, current_rotation)
	end

	if not self.projectile_info.rotation_on_hit then
		local rotation_on_hit = self.projectile_info.rotation_on_hit(_projectile_unit)

		set_local_rotation(_projectile_unit, 0, rotation_on_hit)
	end

	local _timed_data = self._timed_data

	if not (not _timed_data and _timed_data.activate_life_time_on_impact) then
		self:mark_for_deletion()
		Unit.flow_event(_projectile_unit, "lua_projectile_end")

		self._active = false
	end

	self.locomotion_extension:stop(arg_6_1, arg_6_2, arg_6_3)

	self._stop_impacts = true
end

PlayerProjectileUnitExtension._stop_by_life_time = function (self)
	-- function 7
	self:mark_for_deletion()
	Unit.flow_event(self._projectile_unit, "lua_projectile_end")
	self.locomotion_extension:stop()

	self._stop_impacts = true
	self._active = false
end

PlayerProjectileUnitExtension.update = function (self, arg_8_1, arg_8_2, arg_8_3, arg_8_4, arg_8_5)
	-- function 8
	if not self._marked_for_deletion then
		if not (not (arg_8_5 >= self._deletion_time) or self.delete_done) then
			self.delete_done = true

			Managers.state.unit_spawner:mark_for_deletion(self._projectile_unit)
		end

		return
	end

	if not self._delayed_external_events then
		self:_update_delayed_external_event(arg_8_5)
	end

	if not self._anim_blend_enabled then
		local _owner_unit_1p = self._owner_unit_1p
		local anim_blend_settings = self.projectile_info.anim_blend_settings
		local blend_time = anim_blend_settings.blend_time
		local blend_func = anim_blend_settings.blend_func
		local time_lived = self.locomotion_extension.time_lived
		local min = math.min(blend_func(time_lived / blend_time), 1)

		if not (not ALIVE[_owner_unit_1p] and not (min >= 1)) then
			self._anim_blend_enabled = false
		else
			local current_position = self.locomotion_extension:current_position()
			local current_rotation = self.locomotion_extension:current_rotation()

			if not current_position and not current_rotation then
				local _anim_node_id = self._anim_node_id
				local forward_offset = anim_blend_settings.forward_offset
				local var_8_10 = world_rotation(_owner_unit_1p, 0)
				local var_8_11 = world_position(_owner_unit_1p, _anim_node_id)
				local num = forward(var_8_10) * forward_offset
				local var_8_13 = lerp(var_8_11 + num, current_position, min)

				set_local_position(arg_8_1, 0, var_8_13)

				if not anim_blend_settings.use_anim_rotation then
					local var_8_14 = world_rotation(_owner_unit_1p, _anim_node_id)
					local var_8_15 = lerp_2(var_8_14, current_rotation, min)

					set_local_rotation(arg_8_1, 0, var_8_15)
				end
			end
		end
	end

	if not self._is_timed then
		self:handle_timed_events(arg_8_5)
	end

	if not (not self._is_impact and self._stop_impacts) then
		local recent_impacts, var_8_17 = self._impact_extension:recent_impacts()

		if var_8_17 > 0 then
			self:handle_impacts(recent_impacts, var_8_17, arg_8_5)
		end
	end
end

PlayerProjectileUnitExtension.handle_timed_events = function (self, arg_9_1)
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

				if not has_extension then
					local local_rotation = Unit.local_rotation(_projectile_unit, 0)

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

PlayerProjectileUnitExtension.destroy = function (self)
	-- function 10
	if not self._projectile_unit and not self._active then
		self:stop()
	end
end

PlayerProjectileUnitExtension.validate_position = function (arg_11_0, arg_11_1, arg_11_2, arg_11_3)
	-- function 11
	for i = 1, 3 do
		local var_11_0 = arg_11_1[i]

		if not (var_11_0 < arg_11_2 or not (arg_11_3 < var_11_0)) then
			print("[PlayerProjectileUnitExtension] position is not valid, outside of NetworkConstants.position")

			return false
		end
	end

	return true
end

PlayerProjectileUnitExtension._alert_enemy = function (self, arg_12_1, arg_12_2)
	-- function 12
	local _is_server = self._is_server
	local network = Managers.state.network

	if not _is_server then
		AiUtils.alert_unit_of_enemy(arg_12_1, arg_12_2)
	elseif not Unit.alive(arg_12_2) then
		local unit_game_object_id = network:unit_game_object_id(arg_12_1)
		local unit_game_object_id_2 = network:unit_game_object_id(arg_12_2)

		network.network_transmit:send_rpc_server("rpc_alert_enemy", unit_game_object_id, unit_game_object_id_2)
	end
end

local tbl = {}

PlayerProjectileUnitExtension.handle_impacts = function (self, arg_13_1, arg_13_2, arg_13_3)
	-- function 13
	table.clear(tbl)

	local _projectile_unit = self._projectile_unit
	local _owner_unit = self._owner_unit
	local _is_server = self._is_server
	local UNIT = ProjectileImpactDataIndex.UNIT
	local POSITION = ProjectileImpactDataIndex.POSITION
	local DIRECTION = ProjectileImpactDataIndex.DIRECTION
	local NORMAL = ProjectileImpactDataIndex.NORMAL
	local ACTOR_INDEX = ProjectileImpactDataIndex.ACTOR_INDEX
	local _hit_units = self._hit_units
	local _hit_afro_units = self._hit_afro_units
	local _impact_data = self._impact_data
	local network = Managers.state.network
	local network_transmit = network.network_transmit
	local unit_game_object_id = network:unit_game_object_id(_projectile_unit)
	local min = NetworkConstants.position.min
	local max = NetworkConstants.position.max

	for i = 1, arg_13_2 / ProjectileImpactDataIndex.STRIDE do
		local num = (i - 1) * ProjectileImpactDataIndex.STRIDE
		local unbox = arg_13_1[num + POSITION]:unbox()
		local var_13_18 = arg_13_1[num + UNIT]
		local var_13_19 = arg_13_1[num + ACTOR_INDEX]
		local actor = Unit.actor(var_13_18, var_13_19)
		local unit_breed = AiUtils.unit_breed(var_13_18)

		if not unit_breed then
			local node = Actor.node(actor)
			local var_13_23 = unit_breed.hit_zones_lookup[node]

			if not (not var_13_23 and var_13_23.name == "afro") then
				local var_13_24 = tbl[var_13_18]

				if not (not var_13_24 and not var_13_24 and not (var_13_23.prio < var_13_24.prio)) then
					tbl[var_13_18] = var_13_23
				end
			elseif not ((_hit_afro_units[var_13_18] or not var_13_23) and var_13_23.name ~= "afro") then
				self:_alert_enemy(var_13_18, _owner_unit)

				_hit_afro_units[var_13_18] = true
			end
		end
	end

	for j = 1, arg_13_2 / ProjectileImpactDataIndex.STRIDE do
		repeat
			if not self._stop_impacts then
				return
			end

			local num_2 = (j - 1) * ProjectileImpactDataIndex.STRIDE
			local var_13_26 = arg_13_1[num_2 + UNIT]
			local unbox_2 = arg_13_1[num_2 + POSITION]:unbox()
			local unbox_3 = arg_13_1[num_2 + DIRECTION]:unbox()
			local unbox_4 = arg_13_1[num_2 + NORMAL]:unbox()
			local var_13_30 = arg_13_1[num_2 + ACTOR_INDEX]
			local actor_2 = Unit.actor(var_13_26, var_13_30)
			local validate_position = self:validate_position(unbox_2, min, max)

			if not validate_position then
				self:stop()
			end

			local redirect_shield_hit, var_13_34 = ActionUtils.redirect_shield_hit(var_13_26, actor_2)

			if not ((redirect_shield_hit == _owner_unit or not validate_position) and _hit_units[redirect_shield_hit]) then
				local has_extension = ScriptUnit.has_extension(_owner_unit, "hud_system")

				if not has_extension then
					has_extension.show_critical_indication = false
				end

				local _timed_data = self._timed_data

				if not _timed_data and not _timed_data.activate_life_time_on_impact then
					self:_activate_life_time(arg_13_3)
				end

				local unit_breed_2 = AiUtils.unit_breed(redirect_shield_hit)

				if not unit_breed_2 then
					local var_13_38 = tbl[redirect_shield_hit]

					if not var_13_38 then
						local node_2 = Actor.node(var_13_34)
						local var_13_40 = unit_breed_2.hit_zones_lookup[node_2]

						if not (not var_13_40 and var_13_40.name ~= var_13_38.name) then
							_hit_units[redirect_shield_hit] = true
						else
							break
						end
					else
						break
					end
				else
					_hit_units[redirect_shield_hit] = true
				end

				local game_object_or_level_id, var_13_42 = network:game_object_or_level_id(redirect_shield_hit)

				if not _is_server then
					if not var_13_42 then
						network_transmit:send_rpc_clients("rpc_player_projectile_impact_level", unit_game_object_id, game_object_or_level_id, unbox_2, unbox_3, unbox_4, var_13_30)
					elseif not game_object_or_level_id then
						network_transmit:send_rpc_clients("rpc_player_projectile_impact_dynamic", unit_game_object_id, game_object_or_level_id, unbox_2, unbox_3, unbox_4, var_13_30)
					end
				elseif not var_13_42 then
					network_transmit:send_rpc_server("rpc_player_projectile_impact_level", unit_game_object_id, game_object_or_level_id, unbox_2, unbox_3, unbox_4, var_13_30)
				elseif not game_object_or_level_id then
					network_transmit:send_rpc_server("rpc_player_projectile_impact_dynamic", unit_game_object_id, game_object_or_level_id, unbox_2, unbox_3, unbox_4, var_13_30)
				end

				local is_enemy = Managers.state.side:is_enemy(_owner_unit, redirect_shield_hit)
				local get_ranged_boost, var_13_45 = ActionUtils.get_ranged_boost(_owner_unit)

				if not unit_breed_2 then
					if not is_enemy then
						self:hit_enemy(_impact_data, redirect_shield_hit, unbox_2, unbox_3, unbox_4, var_13_34, unit_breed_2, get_ranged_boost, var_13_45)

						break
					end

					if not unit_breed_2.is_player then
						self:hit_player(_impact_data, redirect_shield_hit, unbox_2, unbox_3, unbox_4, var_13_34, get_ranged_boost, var_13_45)
					end

					break
				end

				if not var_13_42 then
					self:hit_level_unit(_impact_data, redirect_shield_hit, unbox_2, unbox_3, unbox_4, var_13_34, game_object_or_level_id, get_ranged_boost, var_13_45)

					break
				end

				if not var_13_42 then
					self:hit_non_level_unit(_impact_data, redirect_shield_hit, unbox_2, unbox_3, unbox_4, var_13_34, get_ranged_boost, var_13_45)
				end
			end
		until true
	end
end

PlayerProjectileUnitExtension._activate_life_time = function (self, arg_14_1)
	-- function 14
	local _timed_data = self._timed_data
	local life_time_activate_sound_start_event = _timed_data.life_time_activate_sound_start_event

	if not life_time_activate_sound_start_event then
		WwiseWorld.trigger_event(self._wwise_world, life_time_activate_sound_start_event)
	end

	self._life_time = arg_14_1 + _timed_data.life_time
end

PlayerProjectileUnitExtension.hit_enemy = function (self, arg_15_1, arg_15_2, arg_15_3, arg_15_4, arg_15_5, arg_15_6, arg_15_7, arg_15_8, arg_15_9)
	-- function 15
	local flag = false
	local damage_profile = arg_15_1.damage_profile

	damage_profile = damage_profile or "default"

	local var_15_2 = DamageProfileTemplates[damage_profile]
	local flag_2 = true
	local flag_3 = false
	local aoe = arg_15_1.aoe

	arg_15_7 = AiUtils.unit_breed(arg_15_2)

	if not arg_15_7 then
		return
	end

	local var_15_6

	if not var_15_2 then
		local node = Actor.node(arg_15_6)

		var_15_6 = arg_15_7.hit_zones_lookup[node].name

		local flag_4 = true
		local charge_value = var_15_2.charge_value

		charge_value = charge_value or "projectile"

		local _is_critical_strike = self._is_critical_strike
		local _owner_unit = self._owner_unit
		local num = self._num_targets_hit + 1
		local flag_5 = true

		if (var_15_6 == "head" or not HEALTH_ALIVE[arg_15_2]) and not arg_15_7 and not arg_15_7.hit_zones and not arg_15_7.hit_zones.head then
			local has_extension = ScriptUnit.has_extension(_owner_unit, "buff_system")

			if not (not (not has_extension and has_extension:has_buff_perk("auto_headshot")) and var_15_6 == "afro") then
				var_15_6 = "head"
				flag_5 = false

				has_extension:trigger_procs("on_auto_headshot")
			end
		end

		local get_item_buff_type = DamageUtils.get_item_buff_type(self.item_name)

		DamageUtils.buff_on_attack(_owner_unit, arg_15_2, charge_value, _is_critical_strike, var_15_6, num, flag_4, get_item_buff_type, flag_5, self.item_name)

		flag, flag_3 = self:hit_enemy_damage(var_15_2, arg_15_2, arg_15_3, arg_15_4, arg_15_5, arg_15_6, arg_15_7, arg_15_8, arg_15_9)
		flag_2 = var_15_6 ~= "ward"

		if not (not flag_2 and not arg_15_7 and flag) then
			local pickup_settings = arg_15_1.pickup_settings

			if not pickup_settings then
				flag_2 = not not pickup_settings.link_hit_zones[var_15_6]
			end
		end
	end

	if (self._num_additional_penetrations ~= 1 or not aoe) and not aoe.explosion then
		local has_extension_2 = ScriptUnit.has_extension(self._owner_unit, "talent_system")

		if not has_extension_2 and not has_extension_2:has_talent("bardin_engineer_ranged_pierce") then
			self._num_additional_penetrations = self._num_additional_penetrations - 1
		end
	end

	local grenade = arg_15_1.grenade

	if self._num_additional_penetrations == 0 then
		local flag_6 = false

		if not (not aoe and grenade or not (self._amount_of_mass_hit >= self._max_mass)) then
			self:do_aoe(aoe, arg_15_3)

			if not grenade then
				local _owner_unit_2 = self._owner_unit
				local has_extension_3 = ScriptUnit.has_extension(_owner_unit_2, "buff_system")

				if not has_extension_3 then
					has_extension_3:trigger_procs("on_grenade_exploded", arg_15_1, arg_15_3, self._is_critical_strike, self.item_name, Unit.local_rotation(self._projectile_unit, 0), self.scale, self.power_level)
				end
			end

			flag_6 = true
		end

		if not self.chain_hit_settings then
			local time = Managers.time:time("game")
			local world_position

			if not Unit.has_node(arg_15_2, "j_spine") then
				world_position = Unit.world_position(arg_15_2, Unit.node(arg_15_2, "j_spine"))

				if not world_position then
					-- Nothing
				end
			end

			world_position = POSITION_LOOKUP[arg_15_2] + Vector3(0, 0, 1.5)

			::label_15_0::

			self._weapon_system:try_fire_chained_projectile(self.chain_hit_settings, self.item_name, self._is_critical_strike, self.power_level, arg_15_9, time, self._owner_unit, world_position, nil, arg_15_2, 1)

			flag_6 = true
		end

		if not flag_6 then
			self:stop(arg_15_2, var_15_6, arg_15_5)
		end
	end

	if self._amount_of_mass_hit >= self._max_mass then
		if self._num_additional_penetrations > 0 then
			flag_3 = true
		else
			local flag_7 = true

			self:_handle_linking(arg_15_1, arg_15_2, arg_15_3, arg_15_4, arg_15_5, arg_15_6, self._did_damage, flag_2, flag, flag_7)
			self:stop(arg_15_2, var_15_6, arg_15_5)
		end
	end

	if arg_15_7.is_player or not arg_15_7.play_ranged_hit_reacts then
		local flag_8 = not self._owner_player.local_player

		DamageUtils.add_hit_reaction(arg_15_2, arg_15_7, flag_8, arg_15_4, false)
	end

	if not self.locomotion_extension.notify_hit_enemy then
		self.locomotion_extension:notify_hit_enemy(arg_15_2)
	end

	if not flag_3 then
		self._num_additional_penetrations = self._num_additional_penetrations - 1
	end
end

PlayerProjectileUnitExtension.hit_enemy_damage = function (self, arg_16_1, arg_16_2, arg_16_3, arg_16_4, arg_16_5, arg_16_6, arg_16_7, arg_16_8, arg_16_9)
	-- function 16
	local network = Managers.state.network
	local _owner_player = self._owner_player
	local _owner_unit = self._owner_unit
	local _current_action = self._current_action
	local _is_server = self._is_server
	local node = Actor.node(arg_16_6)
	local var_16_6 = arg_16_7.hit_zones_lookup[node]
	local forced_hitzone = _current_action.projectile_info.forced_hitzone

	forced_hitzone = forced_hitzone or var_16_6.name

	local var_16_8 = arg_16_4
	local flag = false
	local var_16_10

	if not _is_server then
		var_16_10 = HEALTH_ALIVE[arg_16_2]

		if not var_16_10 then
			-- Nothing
		end
	end

	var_16_10 = AiUtils.client_predicted_unit_alive(arg_16_2)

	::label_16_0::

	if not var_16_10 then
		self._num_targets_hit = self._num_targets_hit + 1
	end

	if (forced_hitzone == "head" or not HEALTH_ALIVE[arg_16_2]) and not arg_16_7 and not arg_16_7.hit_zones and not arg_16_7.hit_zones.head then
		local has_extension = ScriptUnit.has_extension(_owner_unit, "buff_system")

		if not (not (not has_extension and has_extension:has_buff_perk("auto_headshot")) and forced_hitzone == "afro") then
			forced_hitzone = "head"

			has_extension:trigger_procs("on_auto_headshot")
		end
	end

	local var_16_12 = NetworkLookup.hit_zones[forced_hitzone]
	local power_level = self.power_level
	local _is_critical_strike = self._is_critical_strike
	local default_target = arg_16_1.default_target
	local get_attack_template = DamageUtils.get_attack_template(default_target.attack_template)
	local unit_game_object_id = network:unit_game_object_id(_owner_unit)
	local unit_game_object_id_2 = network:unit_game_object_id(arg_16_2)
	local flag_2 = false
	local trueflight_blocking = default_target.trueflight_blocking

	if not _current_action.ignore_shield_hit then
		flag_2 = AiUtils.attack_is_shield_blocked(arg_16_2, _owner_unit, trueflight_blocking, arg_16_4)

		if not flag_2 and not arg_16_7 and not arg_16_7.blocking_hit_effect then
			EffectHelper.player_ranged_block_hit_particles(self._world, arg_16_7.blocking_hit_effect, arg_16_3, arg_16_4, arg_16_2)
		end
	end

	arg_16_7 = AiUtils.unit_breed(arg_16_2)

	local get_breed_damage_multiplier_type = DamageUtils.get_breed_damage_multiplier_type(arg_16_7, forced_hitzone)

	if get_breed_damage_multiplier_type == "headshot" or get_breed_damage_multiplier_type ~= "weakspot" or not flag_2 or _current_action.no_headshot_sound or not HEALTH_ALIVE[arg_16_2] then
		ScriptUnit.extension(_owner_unit, "first_person_system"):play_hud_sound_event("Play_hud_headshot", nil, false)
	end

	if not var_16_10 then
		local hit_mass_count = _current_action.hit_mass_count
		local get_difficulty_rank = Managers.state.difficulty:get_difficulty_rank()
		local var_16_24

		if not flag_2 then
			if not arg_16_7.hit_mass_counts_block then
				var_16_24 = arg_16_7.hit_mass_counts_block[get_difficulty_rank]

				if not var_16_24 then
					-- Nothing
				end

				var_16_24 = arg_16_7.hit_mass_counts_block[2]

				if not var_16_24 then
					-- Nothing
				end
			end

			var_16_24 = arg_16_7.hit_mass_count_block

			if not var_16_24 then
				-- Nothing
			end
		end

		if not arg_16_7.hit_mass_counts then
			var_16_24 = arg_16_7.hit_mass_counts[get_difficulty_rank]

			if not var_16_24 then
				-- Nothing
			end

			var_16_24 = arg_16_7.hit_mass_counts[2]

			if not var_16_24 then
				-- Nothing
			end
		end

		var_16_24 = arg_16_7.hit_mass_count
		var_16_24 = var_16_24 or 1

		::label_16_1::

		if not hit_mass_count and not hit_mass_count[arg_16_7.name] then
			var_16_24 = var_16_24 * (hit_mass_count[arg_16_7.name] or 1)
		end

		self._amount_of_mass_hit = self._amount_of_mass_hit + var_16_24
	end

	local ceil = math.ceil(self._amount_of_mass_hit)
	local hit_effect = _current_action.hit_effect
	local flag_3 = not _owner_player.local_player
	local sound_type = get_attack_template.sound_type
	local name = arg_16_7.name
	local look = Quaternion.look(var_16_8, Vector3.up())
	local item_name = self.item_name
	local var_16_32 = NetworkLookup.damage_sources[item_name]
	local _impact_damage_profile_id = self._impact_damage_profile_id
	local _weapon_system = self._weapon_system
	local calculate_damage, var_16_36 = DamageUtils.calculate_damage(DamageOutput, arg_16_2, _owner_unit, forced_hitzone, power_level, BoostCurves[default_target.boost_curve_type], arg_16_9, _is_critical_strike, arg_16_1, ceil, nil, item_name)

	if not _is_server then
		local alive = Unit.alive(arg_16_2)

		alive = not alive and ScriptUnit.has_extension(arg_16_2, "health_system")

		if not alive then
			local networkify_damage = DamageUtils.networkify_damage(calculate_damage)

			alive:apply_client_predicted_damage(networkify_damage)
		end
	end

	_weapon_system:send_rpc_attack_hit(var_16_32, unit_game_object_id, unit_game_object_id_2, var_16_12, arg_16_3, var_16_8, _impact_damage_profile_id, "power_level", power_level, "hit_target_index", ceil, "blocking", flag_2, "shield_break_procced", false, "boost_curve_multiplier", arg_16_9, "is_critical_strike", _is_critical_strike, "first_hit", self._num_targets_hit == 1)

	local flag_4 = calculate_damage <= 0

	if not var_16_10 and not flag_4 then
		self._did_damage = calculate_damage

		if self._num_additional_penetrations > 0 then
			flag = true
		else
			self._amount_of_mass_hit = self._max_mass

			self:stop(arg_16_2, forced_hitzone, arg_16_5)
		end
	elseif not var_16_10 and _current_action.ignore_armor or arg_16_7.armor_category == 2 or arg_16_7.armor_category == 3 or not flag_2 then
		self._did_damage = calculate_damage

		if self._num_additional_penetrations > 0 then
			flag = true
		else
			self._amount_of_mass_hit = self._max_mass

			self:stop(arg_16_2, forced_hitzone, arg_16_5)
		end
	else
		self._did_damage = calculate_damage

		if not (forced_hitzone == "head" or forced_hitzone ~= "neck") then
			self._did_damage = calculate_damage - 1
		end

		EffectHelper.player_critical_hit(self._world, _is_critical_strike, _owner_unit, arg_16_2, arg_16_3)
	end

	if not var_16_36 then
		hit_effect = "invulnerable"

		DamageUtils.handle_hit_indication(_owner_unit, arg_16_2, 0, forced_hitzone, false, true)
	end

	if not hit_effect then
		EffectHelper.play_skinned_surface_material_effects(hit_effect, self._world, arg_16_2, arg_16_3, look, arg_16_5, flag_3, name, sound_type, flag_4, forced_hitzone, flag_2, arg_16_7)
	end

	if not (forced_hitzone ~= "head" or flag_2) then
		local extension = ScriptUnit.extension(_owner_unit, "buff_system")
		local extension_2 = ScriptUnit.extension(_owner_unit, "first_person_system")
		local apply_buffs_to_value, var_16_43 = extension:apply_buffs_to_value(0, "coop_stamina")

		if var_16_43 or not script_data.debug_legendary_traits or not HEALTH_ALIVE[arg_16_2] then
			local headshot_coop_stamina_fatigue_type = arg_16_7.headshot_coop_stamina_fatigue_type

			headshot_coop_stamina_fatigue_type = headshot_coop_stamina_fatigue_type or "headshot_clan_rat"

			local var_16_45 = NetworkLookup.fatigue_types[headshot_coop_stamina_fatigue_type]

			if not _is_server then
				network.network_transmit:send_rpc_clients("rpc_replenish_fatigue_other_players", var_16_45)
			else
				network.network_transmit:send_rpc_server("rpc_replenish_fatigue_other_players", var_16_45)
			end

			StatusUtils.replenish_stamina_local_players(_owner_unit, headshot_coop_stamina_fatigue_type)
			extension_2:play_hud_sound_event("hud_player_buff_headshot", nil, false)
		end
	end

	return flag_2, flag
end

PlayerProjectileUnitExtension.hit_player = function (self, arg_17_1, arg_17_2, arg_17_3, arg_17_4, arg_17_5, arg_17_6, arg_17_7, arg_17_8)
	-- function 17
	local get_difficulty_settings = Managers.state.difficulty:get_difficulty_settings()
	local flag = false
	local flag_2 = false
	local flag_3 = false
	local flag_4 = false
	local _owner_player = self._owner_player
	local damage_profile = arg_17_1.damage_profile

	damage_profile = damage_profile or "default"

	local var_17_7 = DamageProfileTemplates[damage_profile]

	if not var_17_7 and not DamageUtils.allow_friendly_fire_ranged(get_difficulty_settings, _owner_player) then
		flag_2 = self:hit_player_damage(var_17_7, arg_17_2, arg_17_3, arg_17_4, arg_17_5, arg_17_6, arg_17_7, arg_17_8)
		flag = true
	end

	if not flag then
		local aoe = arg_17_1.aoe

		if not aoe and self._amount_of_mass_hit >= self._max_mass and not self._stop_impacts then
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

		if not (arg_17_1.no_stop_on_friendly_fire or not (self._amount_of_mass_hit >= self._max_mass)) then
			if self._num_additional_penetrations > 0 then
				flag_4 = true
			else
				local flag_5 = true

				self:_handle_linking(arg_17_1, arg_17_2, arg_17_3, arg_17_4, arg_17_5, arg_17_6, self._did_damage, flag_2, flag_3, flag_5)
				self:stop()
			end
		end
	end

	if not flag_4 then
		self._num_additional_penetrations = self._num_additional_penetrations - 1
	end
end

PlayerProjectileUnitExtension.hit_player_damage = function (self, arg_18_1, arg_18_2, arg_18_3, arg_18_4, arg_18_5, arg_18_6, arg_18_7, arg_18_8)
	-- function 18
	local _owner_unit = self._owner_unit
	local network = Managers.state.network
	local unit_game_object_id = network:unit_game_object_id(_owner_unit)
	local unit_game_object_id_2 = network:unit_game_object_id(arg_18_2)
	local num = self._num_targets_hit + 1

	self._num_targets_hit = num
	self._amount_of_mass_hit = self._amount_of_mass_hit + 1

	local ceil = math.ceil(self._amount_of_mass_hit)
	local default_target = arg_18_1.default_target
	local hit_effect = self._current_action.hit_effect
	local flag = not self._owner_player.local_player
	local look = Quaternion.look(arg_18_4, Vector3.up())
	local item_name = self.item_name
	local _impact_damage_profile_id = self._impact_damage_profile_id
	local power_level = self.power_level
	local unit_breed = AiUtils.unit_breed(arg_18_2)
	local node = Actor.node(arg_18_6)
	local name = unit_breed.hit_zones_lookup[node].name
	local _is_critical_strike = self._is_critical_strike
	local var_18_17 = NetworkLookup.damage_sources[item_name]
	local var_18_18 = NetworkLookup.hit_zones[name]

	self._weapon_system:send_rpc_attack_hit(var_18_17, unit_game_object_id, unit_game_object_id_2, var_18_18, arg_18_3, arg_18_4, _impact_damage_profile_id, "power_level", power_level, "hit_target_index", ceil, "blocking", false, "shield_break_procced", false, "boost_curve_multiplier", arg_18_8, "is_critical_strike", _is_critical_strike, "first_hit", num == 1)

	local calculate_damage, var_18_20 = DamageUtils.calculate_damage(DamageOutput, arg_18_2, _owner_unit, name, power_level, BoostCurves[default_target.boost_curve_type], arg_18_8, _is_critical_strike, arg_18_1, ceil, nil, item_name)

	if not (calculate_damage <= 0) then
		self._did_damage = false

		self:stop()
	else
		self._did_damage = calculate_damage
	end

	if not var_18_20 then
		hit_effect = "invulnerable"

		DamageUtils.handle_hit_indication(_owner_unit, arg_18_2, 0, name, false, true)
	end

	if not hit_effect then
		EffectHelper.play_skinned_surface_material_effects(hit_effect, self._world, arg_18_2, arg_18_3, look, arg_18_5, flag)
	end

	return false
end

PlayerProjectileUnitExtension.hit_level_unit = function (self, arg_19_1, arg_19_2, arg_19_3, arg_19_4, arg_19_5, arg_19_6, arg_19_7, arg_19_8, arg_19_9)
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
		if not has_extension then
			self:hit_damagable_prop(var_19_2, arg_19_2, arg_19_3, arg_19_4, arg_19_5, arg_19_6, arg_19_7, arg_19_8, arg_19_9)
		elseif not arg_19_2 and not Unit.alive(arg_19_2) and not arg_19_6 then
			local set_flow_variable = Unit.set_flow_variable

			set_flow_variable(arg_19_2, "hit_actor", arg_19_6)
			set_flow_variable(arg_19_2, "hit_direction", arg_19_4)
			set_flow_variable(arg_19_2, "hit_position", arg_19_3)
			Unit.flow_event(arg_19_2, "lua_level_unit_hit_by_local_player_projectile")
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

		max_bounces = max_bounces or 0

		local locomotion_extension = self.locomotion_extension
		local num_2 = max_bounces + num

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
	elseif (self._num_additional_penetrations == 0 or not has_extension) and not arg_19_1.grenade then
		self:_handle_linking(arg_19_1, arg_19_2, arg_19_3, arg_19_4, arg_19_5, arg_19_6, false, true, false, false)
	end

	if not (not has_extension and not (self._num_additional_penetrations > 0) or arg_19_1.grenade) then
		self._num_additional_penetrations = self._num_additional_penetrations - 1
	else
		self:stop(arg_19_2, nil, arg_19_5)
	end
end

PlayerProjectileUnitExtension.hit_damagable_prop = function (self, arg_20_1, arg_20_2, arg_20_3, arg_20_4, arg_20_5, arg_20_6, arg_20_7, arg_20_8, arg_20_9)
	-- function 20
	self._amount_of_mass_hit = self._amount_of_mass_hit + 1

	local ceil = math.ceil(self._amount_of_mass_hit)
	local _owner_unit = self._owner_unit
	local str = "full"
	local power_level = self.power_level
	local _is_critical_strike = self._is_critical_strike
	local item_name = self.item_name

	DamageUtils.damage_level_unit(arg_20_2, _owner_unit, str, power_level, arg_20_9, _is_critical_strike, arg_20_1, ceil, arg_20_4, item_name)
end

PlayerProjectileUnitExtension.hit_non_level_unit = function (self, arg_21_1, arg_21_2, arg_21_3, arg_21_4, arg_21_5, arg_21_6, arg_21_7, arg_21_8)
	-- function 21
	local damage_profile_prop = arg_21_1.damage_profile_prop

	if not damage_profile_prop then
		damage_profile_prop = arg_21_1.damage_profile
		damage_profile_prop = damage_profile_prop or "default"
	end

	local var_21_1 = DamageProfileTemplates[damage_profile_prop]
	local flag = false

	if not var_21_1 then
		if not ScriptUnit.has_extension(arg_21_2, "health_system") then
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

	if self._num_additional_penetrations == 0 then
		self:_handle_linking(arg_21_1, arg_21_2, arg_21_3, arg_21_4, arg_21_5, arg_21_6, false, true, false, false)
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
			self:stop(arg_21_2, nil, arg_21_5)
		end
	end
end

PlayerProjectileUnitExtension.hit_non_level_damagable_unit = function (self, arg_22_1, arg_22_2, arg_22_3, arg_22_4, arg_22_5, arg_22_6, arg_22_7, arg_22_8)
	-- function 22
	local network = Managers.state.network
	local str = "full"
	local _owner_unit = self._owner_unit
	local unit_game_object_id = network:unit_game_object_id(_owner_unit)
	local unit_game_object_id_2 = network:unit_game_object_id(arg_22_2)
	local var_22_5 = NetworkLookup.hit_zones[str]
	local item_name = self.item_name
	local var_22_7 = NetworkLookup.damage_sources[item_name]
	local _impact_damage_profile_id = self._impact_damage_profile_id
	local power_level = self.power_level
	local _is_critical_strike = self._is_critical_strike

	if not (Unit.get_data(arg_22_2, "allow_ranged_damage") ~= false) then
		return
	end

	self._weapon_system:send_rpc_attack_hit(var_22_7, unit_game_object_id, unit_game_object_id_2, var_22_5, arg_22_3, arg_22_4, _impact_damage_profile_id, "power_level", power_level, "hit_target_index", nil, "blocking", false, "shield_break_procced", false, "boost_curve_multiplier", arg_22_8, "is_critical_strike", _is_critical_strike)

	local hit_effect = self._current_action.hit_effect

	if not hit_effect then
		local _world = self._world
		local look = Quaternion.look(arg_22_4)
		local flag = not self._owner_player.local_player

		EffectHelper.play_surface_material_effects(hit_effect, _world, arg_22_2, arg_22_3, look, arg_22_5, nil, flag, nil, arg_22_6)
	end
end

PlayerProjectileUnitExtension._get_projectile_units_names = function (self, arg_23_1)
	-- function 23
	local projectile_units_template = arg_23_1.projectile_units_template

	if not arg_23_1.use_weapon_skin then
		local has_extension = ScriptUnit.has_extension(self._owner_unit, "inventory_system")

		if not has_extension then
			local str = "slot_ranged"
			local get_slot_data = has_extension:get_slot_data(str)

			projectile_units_template = not get_slot_data and get_slot_data.projectile_units_template and projectile_units_template
		end
	end

	return ProjectileUnits[projectile_units_template]
end

PlayerProjectileUnitExtension._get_weapon_unit = function (self)
	-- function 24
	local has_extension = ScriptUnit.has_extension(self._owner_unit, "inventory_system")

	if not has_extension then
		local str = "slot_ranged"
		local get_slot_data = has_extension:get_slot_data(str)
		local right_unit_1p = get_slot_data.right_unit_1p
		local left_unit_1p = get_slot_data.left_unit_1p

		return right_unit_1p or left_unit_1p
	end
end

PlayerProjectileUnitExtension._handle_linking = function (self, arg_25_1, arg_25_2, arg_25_3, arg_25_4, arg_25_5, arg_25_6, arg_25_7, arg_25_8, arg_25_9, arg_25_10)
	-- function 25
	if not (arg_25_1.link or arg_25_1.link_pickup) then
		return
	end

	local projectile_info = self.projectile_info
	local _get_projectile_units_names = self:_get_projectile_units_names(projectile_info)
	local dummy_linker_unit_name = _get_projectile_units_names.dummy_linker_unit_name
	local depth = arg_25_1.depth

	depth = depth or 0.15

	local depth_offset = arg_25_1.depth_offset

	depth_offset = depth_offset or 0.15

	if not _get_projectile_units_names.dummy_linker_broken_units then
		local random = Math.random()

		if not (not arg_25_7 and arg_25_9) then
			random = random * math.clamp(arg_25_7 / 2, 0.75, 1.25)
		else
			random = random * 2
		end

		if random <= 0.5 then
			local count = #_get_projectile_units_names.dummy_linker_broken_units
			local random_2 = Math.random(1, count)

			dummy_linker_unit_name = _get_projectile_units_names.dummy_linker_broken_units[random_2]

			if random_2 == 1 then
				depth = 0.05
				depth_offset = 0.1
			else
				depth_offset = 0.15
			end
		end
	elseif not (not arg_25_7 and arg_25_9) then
		local depth_damage_modifier_min = arg_25_1.depth_damage_modifier_min

		depth_damage_modifier_min = depth_damage_modifier_min or 1

		local depth_damage_modifier_max = arg_25_1.depth_damage_modifier_max

		depth_damage_modifier_max = depth_damage_modifier_max or 3
		depth = depth * math.clamp(arg_25_7, depth_damage_modifier_min, depth_damage_modifier_max)
	end

	if not arg_25_9 then
		depth = -0.1
	end

	local num = depth + depth_offset

	if not arg_25_8 then
		local get_data = Unit.get_data(arg_25_2, "allow_link")

		if get_data ~= nil then
			arg_25_8 = get_data
		end
	end

	if not arg_25_8 and not arg_25_1.link then
		self:_link_projectile(arg_25_2, arg_25_6, dummy_linker_unit_name, arg_25_3, arg_25_4, num, arg_25_9, arg_25_1.flow_event_on_init, arg_25_1.flow_event_on_walls)
	elseif not arg_25_1.link_pickup then
		local game_object_or_level_id, var_25_13 = Managers.state.network:game_object_or_level_id(arg_25_2)

		if not (game_object_or_level_id or var_25_13 ~= nil) then
			return
		end

		local pickup_settings = arg_25_1.pickup_settings
		local var_25_15

		if not pickup_settings.use_weapon_skin then
			local has_extension = ScriptUnit.has_extension(self._owner_unit, "inventory_system")

			if not has_extension then
				local str = "slot_ranged"

				var_25_15 = has_extension:get_slot_data(str)
			end
		end

		if not arg_25_8 then
			local link_pickup_template_name = var_25_15.link_pickup_template_name

			link_pickup_template_name = link_pickup_template_name or pickup_settings.link_pickup_name

			self:_spawn_linked_pickup_projectile(link_pickup_template_name, arg_25_2, arg_25_6, arg_25_3, arg_25_4, arg_25_5, game_object_or_level_id, var_25_13, num, arg_25_9)
		else
			local pickup_template_name = var_25_15.pickup_template_name

			pickup_template_name = pickup_template_name or pickup_settings.pickup_name

			self:_spawn_pickup_projectile(pickup_template_name, arg_25_3, arg_25_4, arg_25_5, arg_25_10)
		end
	end
end

PlayerProjectileUnitExtension._redirect_shield_linking = function (arg_26_0, arg_26_1, arg_26_2, arg_26_3, arg_26_4)
	-- function 26
	local unit_breed = AiUtils.unit_breed(arg_26_1)
	local var_26_1 = HEALTH_ALIVE[arg_26_1]

	var_26_1 = not var_26_1 and not unit_breed and not not unit_breed.no_effects_on_shield_block or not unit_breed.is_player

	if not var_26_1 then
		return arg_26_1, arg_26_2, arg_26_3
	end

	arg_26_1 = ScriptUnit.extension(arg_26_1, "ai_inventory_system").inventory_item_shield_unit

	local node = Unit.node(arg_26_1, "c_mesh")
	local num = world_position(arg_26_1, node) + arg_26_4
	local num_2 = arg_26_3 - num
	local length = Vector3.length(num_2)

	arg_26_3 = num + num_2 * math.min(length, 0.25)
	arg_26_2 = node

	return arg_26_1, arg_26_2, arg_26_3
end

PlayerProjectileUnitExtension._link_projectile = function (self, arg_27_1, arg_27_2, arg_27_3, arg_27_4, arg_27_5, arg_27_6, arg_27_7, arg_27_8, arg_27_9)
	-- function 27
	local unit_spawner = Managers.state.unit_spawner
	local _projectile_linker_system = self._projectile_linker_system
	local num = Math.random() * 2.14 - 0.5
	local normalize = Vector3.normalize(arg_27_5)
	local num_2 = normalize * arg_27_6
	local num_3 = arg_27_4 + num_2
	local multiply = Quaternion.multiply(Quaternion.look(normalize), Quaternion(Vector3.forward(), num))
	local node = Actor.node(arg_27_2)

	if not arg_27_7 then
		arg_27_1, node, num_3 = self:_redirect_shield_linking(arg_27_1, node, num_3, num_2)
	end

	local var_27_8

	if not ScriptUnit.has_extension(arg_27_1, "projectile_linker_system") then
		var_27_8 = unit_spawner:spawn_local_unit(arg_27_3, num_3, multiply)

		local var_27_9 = world_rotation(arg_27_1, node)
		local num_4 = num_3 - world_position(arg_27_1, node)
		local var_27_11 = Vector3(Vector3.dot(Quaternion.right(var_27_9), num_4), Vector3.dot(forward(var_27_9), num_4), Vector3.dot(Quaternion.up(var_27_9), num_4))
		local has_data = Unit.has_data(arg_27_1, "breed")

		if not arg_27_8 and not has_data then
			Unit.flow_event(var_27_8, arg_27_8)
		end

		ScriptUnit.extension(arg_27_1, "projectile_linker_system"):link_projectile(var_27_8, var_27_11, multiply, node)
		_projectile_linker_system:add_linked_projectile_reference(arg_27_1, var_27_8)
	else
		var_27_8 = unit_spawner:spawn_local_unit(arg_27_3, num_3, multiply)

		_projectile_linker_system:add_linked_projectile_reference(arg_27_1, var_27_8)

		if not arg_27_8 then
			Unit.flow_event(var_27_8, arg_27_8)
		end

		if not arg_27_9 then
			Unit.flow_event(var_27_8, arg_27_9)
		end
	end

	if not self._material_settings_name then
		GearUtils.apply_material_settings(var_27_8, self._material_settings_name)
	end
end

PlayerProjectileUnitExtension._spawn_linked_pickup_projectile = function (self, arg_28_1, arg_28_2, arg_28_3, arg_28_4, arg_28_5, arg_28_6, arg_28_7, arg_28_8, arg_28_9, arg_28_10)
	-- function 28
	local normalize = Vector3.normalize(arg_28_5)
	local num = normalize * arg_28_9
	local num_2 = arg_28_4 + num
	local node = Actor.node(arg_28_3)

	if not arg_28_10 then
		arg_28_2, node, num_2 = self:_redirect_shield_linking(arg_28_2, node, num_2, num)
	end

	local num_3 = 1
	local _get_weapon_unit = self:_get_weapon_unit()

	if not _get_weapon_unit then
		local has_extension = ScriptUnit.has_extension(_get_weapon_unit, "ammo_system")

		num_3 = not has_extension and has_extension:max_ammo()
	end

	local random_range = Math.random_range(math.pi / 6, math.pi / 3)
	local random_range_2 = Math.random_range(-math.pi / 10, math.pi / 10)
	local normalize_2 = Vector3.normalize((normalize - arg_28_6) * 0.5)
	local look = Quaternion.look(normalize_2, Vector3.up())
	local multiply = Quaternion.multiply(look, Quaternion(Vector3.forward(), random_range_2))
	local multiply_2 = Quaternion.multiply(multiply, Quaternion(Vector3.left(), random_range))
	local var_28_13 = NetworkLookup.pickup_names[arg_28_1]
	local str = "dropped"
	local var_28_15 = NetworkLookup.pickup_spawn_types[str]
	local material_settings_templates = NetworkLookup.material_settings_templates
	local _material_settings_name = self._material_settings_name

	_material_settings_name = _material_settings_name or "n/a"

	local var_28_18 = material_settings_templates[_material_settings_name]

	Managers.state.network.network_transmit:send_rpc_server("rpc_spawn_linked_pickup", var_28_13, num_2, multiply_2, var_28_15, arg_28_7, node, arg_28_8, num_3, var_28_18)
end

PlayerProjectileUnitExtension._spawn_pickup_projectile = function (self, arg_29_1, arg_29_2, arg_29_3, arg_29_4, arg_29_5)
	-- function 29
	local num = 1
	local _get_weapon_unit = self:_get_weapon_unit()

	if not _get_weapon_unit then
		local has_extension = ScriptUnit.has_extension(_get_weapon_unit, "ammo_system")

		num = not has_extension and has_extension:max_ammo()
	end

	local random = math.random(-math.half_pi, math.half_pi)
	local flag = not arg_29_5 and arg_29_3 and Vector3.reflect(arg_29_3, arg_29_4)
	local num_2 = arg_29_2 + flag * 0.2
	local axis_angle = Quaternion.axis_angle(flag, random)
	local var_29_7 = NetworkLookup.pickup_names[arg_29_1]
	local str = "dropped"
	local var_29_9 = NetworkLookup.pickup_spawn_types[str]
	local var_29_10 = AllPickups[arg_29_1]
	local unit_name = var_29_10.unit_name
	local unit_template_name = var_29_10.unit_template_name
	local var_29_13 = NetworkLookup.husks[unit_name]
	local var_29_14 = NetworkLookup.go_types[unit_template_name]
	local num_3 = flag * self.locomotion_extension.speed * 0.001
	local world_pose = Unit.world_pose(self._projectile_unit, 0)
	local bounce_angular_velocity = self.projectile_info.bounce_angular_velocity
	local var_29_18 = Vector3(bounce_angular_velocity[1], bounce_angular_velocity[2], bounce_angular_velocity[3])
	local transform_without_translation = Matrix4x4.transform_without_translation(world_pose, var_29_18)
	local position_network_scale = AiAnimUtils.position_network_scale(num_2, true)
	local rotation_network_scale = AiAnimUtils.rotation_network_scale(axis_angle, true)
	local velocity_network_scale = AiAnimUtils.velocity_network_scale(num_3, true)
	local velocity_network_scale_2 = AiAnimUtils.velocity_network_scale(transform_without_translation, true)
	local material_settings_templates = NetworkLookup.material_settings_templates
	local _material_settings_name = self._material_settings_name

	_material_settings_name = _material_settings_name or "n/a"

	local var_29_26 = material_settings_templates[_material_settings_name]

	Managers.state.network.network_transmit:send_rpc_server("rpc_spawn_pickup_projectile", var_29_13, var_29_14, position_network_scale, rotation_network_scale, velocity_network_scale, velocity_network_scale_2, var_29_7, var_29_9, num, false, false, var_29_26)
end

PlayerProjectileUnitExtension.do_aoe = function (self, arg_30_1, arg_30_2, arg_30_3)
	-- function 30
	local _world = self._world
	local _projectile_unit = self._projectile_unit
	local _owner_unit = self._owner_unit
	local item_name = self.item_name
	local _is_server = self._is_server
	local var_30_5 = _owner_unit

	if not arg_30_1.explosion then
		local local_rotation = Unit.local_rotation(self._projectile_unit, 0)
		local scale = self.scale
		local power_level = self.power_level
		local flag = false

		if not arg_30_3 then
			Managers.state.entity:system("area_damage_system"):create_explosion(_owner_unit, arg_30_2, local_rotation, arg_30_1.name, scale, item_name, power_level, self._is_critical_strike, var_30_5)
		else
			DamageUtils.create_explosion(_world, _owner_unit, arg_30_2, local_rotation, arg_30_1, scale, item_name, _is_server, flag, _projectile_unit, power_level, self._is_critical_strike, var_30_5)
		end
	end

	if not arg_30_1.spawn_unit then
		local go_id = Managers.state.unit_storage:go_id(_owner_unit)
		local tbl = {
			darkness_system = {
				glow_time = arg_30_1.spawn_unit.glow_time,
				owner_unit_id = go_id,
				initial_position = arg_30_2
			}
		}
		local unit_path = arg_30_1.spawn_unit.unit_path
		local unit_name = arg_30_1.spawn_unit.unit_name

		Managers.state.unit_spawner:spawn_network_unit(unit_path, unit_name, tbl, arg_30_2)
	end

	if not _is_server then
		if not arg_30_1.aoe then
			DamageUtils.create_aoe(_world, _owner_unit, arg_30_2, item_name, arg_30_1)
		end

		if not arg_30_1.taunt then
			DamageUtils.create_taunt(_world, _owner_unit, _projectile_unit, arg_30_2, arg_30_1)
		end
	end
end

PlayerProjectileUnitExtension.spawn_liquid_area = function (self, arg_31_1, arg_31_2, arg_31_3, arg_31_4)
	-- function 31
	local var_31_0 = arg_31_2
	local var_31_1 = arg_31_3
	local floor = math.floor(self.scale * 30)
	local tbl = {
		area_damage_system = {
			flow_dir = var_31_1,
			damage_table = arg_31_4.liquid_area.damage,
			liquid_template = arg_31_4.liquid_area.liquid_template,
			source_unit = arg_31_1,
			max_liquid = floor
		}
	}
	local str = "units/hub_elements/empty"
	local spawn_network_unit = Managers.state.unit_spawner:spawn_network_unit(str, "liquid_aoe_unit", tbl, var_31_0)

	ScriptUnit.extension(spawn_network_unit, "area_damage_system"):ready()
end

PlayerProjectileUnitExtension.are_impacts_stopped = function (self)
	-- function 32
	return self._stop_impacts
end

PlayerProjectileUnitExtension.trigger_external_event = function (self, arg_33_1, arg_33_2)
	-- function 33
	local external_events = self.projectile_info.external_events
	local flag = not external_events and external_events[arg_33_1]

	if not flag then
		flag(self)

		if not arg_33_2 then
			local _is_server = self._is_server
			local network = Managers.state.network
			local unit_game_object_id = network:unit_game_object_id(self._projectile_unit)
			local var_33_5 = NetworkLookup.projectile_external_event[arg_33_1]

			if not _is_server then
				network.network_transmit:send_rpc_clients("rpc_projectile_event", unit_game_object_id, var_33_5)
			else
				network.network_transmit:send_rpc_server("rpc_projectile_event", unit_game_object_id, var_33_5)
			end
		end
	end
end

PlayerProjectileUnitExtension.queue_delayed_external_event = function (self, arg_34_1, arg_34_2, arg_34_3)
	-- function 34
	if not self._delayed_external_events then
		self._delayed_external_events = {}
	end

	local count = #self._delayed_external_events

	self._delayed_external_events[count + 1] = {
		arg_34_2,
		arg_34_1,
		arg_34_3
	}
end

PlayerProjectileUnitExtension._update_delayed_external_event = function (self, arg_35_1)
	-- function 35
	local _delayed_external_events = self._delayed_external_events
	local count = #_delayed_external_events

	for i = count, 1, -1 do
		local var_35_2 = _delayed_external_events[i]

		if arg_35_1 >= var_35_2[1] then
			self:trigger_external_event(var_35_2[2], var_35_2[3])

			_delayed_external_events[i] = _delayed_external_events[count]
			_delayed_external_events[count] = nil
			count = count - 1
		end
	end

	if count == 0 then
		self._delayed_external_events = nil
	end
end
