-- chunkname: @scripts/unit_extensions/weapons/projectiles/player_projectile_husk_extension.lua

PlayerProjectileHuskExtension = class(PlayerProjectileHuskExtension)

PlayerProjectileHuskExtension.init = function (arg_1_0, arg_1_1, arg_1_2, arg_1_3)
	local var_1_0 = arg_1_3.owner_unit
	local var_1_1 = arg_1_3.item_name

	arg_1_0._world = arg_1_1.world
	arg_1_0._wwise_world = Managers.world:wwise_world(arg_1_0._world)
	arg_1_0._projectile_unit = arg_1_2
	arg_1_0._owner_unit = var_1_0
	arg_1_0._owner_player = Managers.player:owner(var_1_0)
	arg_1_0.item_name = var_1_1

	local var_1_2 = ScriptUnit.has_extension(var_1_0, "inventory_system")

	if var_1_2 then
		local var_1_3 = var_1_2:equipment()

		if var_1_3 then
			local var_1_4 = var_1_3.wielded

			if var_1_4 then
				local var_1_5

				arg_1_0._skin_projectile_units_template = var_1_4.projectile_units_template

				local var_1_6 = var_1_2:get_slot_data(var_1_3.wielded_slot)

				if var_1_6 then
					local var_1_7 = var_1_6.skin
					local var_1_8 = WeaponSkins.skins[var_1_7]

					if var_1_8 then
						var_1_5 = var_1_8.material_settings_name
						arg_1_0._skin_projectile_units_template = var_1_8.projectile_units_template
					end
				end

				local var_1_9 = BackendUtils.get_item_units(var_1_4)

				if var_1_9 and var_1_9.is_ammo_weapon then
					local var_1_10 = BackendUtils.get_item_template(var_1_4)
					local var_1_11 = var_1_5 or var_1_9.material_settings_name or var_1_10.material_settings_name

					if var_1_11 then
						GearUtils.apply_material_settings(arg_1_2, var_1_11)

						arg_1_0._material_settings_name = var_1_11
					end
				end
			end
		end
	end

	if not arg_1_0._skin_projectile_units_template then
		local var_1_12 = Unit.get_data(arg_1_2, "unit_name")

		arg_1_0._skin_projectile_units_template = ProjectileUnitsFromUnitName[var_1_12]
	end

	local var_1_13 = ItemMasterList[var_1_1]
	local var_1_14 = BackendUtils.get_item_template(var_1_13)
	local var_1_15 = arg_1_3.item_template_name
	local var_1_16 = arg_1_3.action_name
	local var_1_17 = arg_1_3.sub_action_name
	local var_1_18 = ScriptUnit.has_extension(arg_1_0._owner_unit, "buff_system")

	arg_1_0.action_lookup_data = {
		item_template_name = var_1_15,
		action_name = var_1_16,
		sub_action_name = var_1_17
	}

	local var_1_19 = var_1_14.actions[var_1_16][var_1_17]

	arg_1_0._current_action = var_1_19

	local var_1_20 = var_1_19.projectile_info
	local var_1_21 = var_1_19.impact_data
	local var_1_22 = var_1_19.timed_data

	arg_1_0.charge_data = var_1_19.charge_data

	if var_1_21.grenade and var_1_18 and var_1_18:has_buff_perk("frag_fire_grenades") then
		var_1_21 = table.shallow_copy(var_1_21)
		var_1_21.aoe = ExplosionUtils.get_template("frag_fire_grenade")
	end

	arg_1_0.power_level = arg_1_3.power_level
	arg_1_0.projectile_info = var_1_20
	arg_1_0._impact_data = var_1_21
	arg_1_0._timed_data = var_1_22
	arg_1_0._time_initialized = arg_1_3.time_initialized
	arg_1_0.scale = arg_1_3.scale
	arg_1_0.charge_level = (arg_1_3.charge_level or 0) / 100
	arg_1_0._num_targets_hit = 0
	arg_1_0._hit_units = {}
	arg_1_0.projectile_linker_system = Managers.state.entity:system("projectile_linker_system")
	arg_1_0._is_server = Managers.player.is_server
	arg_1_0._active = true
	arg_1_0._was_active = true
	arg_1_0._did_damage = false
	arg_1_0._num_bounces = 0
	arg_1_0._num_additional_penetrations = var_1_18:apply_buffs_to_value(0, "ranged_additional_penetrations")
	arg_1_0._is_critical_strike = not not arg_1_3.is_critical_strike

	arg_1_0:initialize_projectile(var_1_20, var_1_21)
end

PlayerProjectileHuskExtension.destroy = function (arg_2_0)
	if arg_2_0._projectile_unit and arg_2_0._active and not arg_2_0.is_server then
		arg_2_0:stop()
	end
end

PlayerProjectileHuskExtension.extensions_ready = function (arg_3_0, arg_3_1, arg_3_2)
	arg_3_0.locomotion_extension = ScriptUnit.extension(arg_3_2, "projectile_locomotion_system")
end

PlayerProjectileHuskExtension.initialize_projectile = function (arg_4_0, arg_4_1, arg_4_2)
	local var_4_0 = arg_4_0._projectile_unit

	if arg_4_2 then
		arg_4_0._is_impact = true
		arg_4_0._stop_impacts = false
		arg_4_0._amount_of_mass_hit = 0

		local var_4_1 = arg_4_2.damage_profile or "default"
		local var_4_2 = DamageProfileTemplates[var_4_1]
		local var_4_3 = arg_4_0._owner_unit
		local var_4_4 = Managers.state.difficulty:get_difficulty()
		local var_4_5 = ActionUtils.scale_power_levels(arg_4_0.power_level, "cleave", var_4_3, var_4_4)
		local var_4_6, var_4_7 = ActionUtils.get_max_targets(var_4_2, var_4_5)

		arg_4_0._max_mass = var_4_7 < var_4_6 and var_4_6 or var_4_7
	end

	local var_4_8 = arg_4_0._timed_data

	if var_4_8 then
		arg_4_0._is_timed = true

		if var_4_8.activate_life_time_on_impact then
			arg_4_0._life_time = math.huge
		else
			arg_4_0:_activate_life_time(arg_4_0._time_initialized)
		end

		if var_4_8.charge_time then
			arg_4_0._charge_t = arg_4_0._time_initialized + var_4_8.charge_time * (1 - arg_4_0.charge_level)
		end
	end

	if arg_4_1.times_bigger then
		local var_4_9 = arg_4_0.scale

		Unit.set_flow_variable(var_4_0, "scale", var_4_9)

		local var_4_10 = arg_4_1.times_bigger
		local var_4_11 = math.lerp(1, var_4_10, var_4_9)

		Unit.set_local_scale(var_4_0, 0, Vector3(var_4_11, var_4_11, var_4_11))
	end

	Unit.flow_event(var_4_0, "lua_projectile_init")
	arg_4_0:_handle_critical_strike(var_4_0, arg_4_0._is_critical_strike)
	Unit.flow_event(var_4_0, "lua_trail")
end

PlayerProjectileHuskExtension._handle_critical_strike = function (arg_5_0, arg_5_1, arg_5_2)
	if arg_5_0._is_critical_strike then
		Unit.flow_event(arg_5_1, "vfx_critical_strike")
	end
end

PlayerProjectileHuskExtension.update = function (arg_6_0, arg_6_1, arg_6_2, arg_6_3, arg_6_4, arg_6_5)
	if not arg_6_0._active then
		if arg_6_0._was_active then
			arg_6_0._was_active = false
		end

		return
	end

	if arg_6_0._is_timed then
		arg_6_0:handle_timed_events(arg_6_5)
	end
end

PlayerProjectileHuskExtension.stop = function (arg_7_0, arg_7_1, arg_7_2)
	local var_7_0 = arg_7_0.projectile_info.custom_stop_func

	if var_7_0 and var_7_0(arg_7_0, arg_7_1, arg_7_2) then
		arg_7_0._stop_impacts = true

		return
	end

	local var_7_1 = arg_7_0._timed_data

	if not (var_7_1 and var_7_1.activate_life_time_on_impact) then
		Unit.flow_event(arg_7_0._projectile_unit, "lua_projectile_end")

		arg_7_0._active = false
	end

	arg_7_0.locomotion_extension:stop()

	arg_7_0._stop_impacts = true
end

PlayerProjectileHuskExtension._stop_by_life_time = function (arg_8_0)
	Unit.flow_event(arg_8_0._projectile_unit, "lua_projectile_end")

	arg_8_0._active = false

	arg_8_0.locomotion_extension:stop()

	arg_8_0._stop_impacts = true
end

PlayerProjectileHuskExtension.handle_timed_events = function (arg_9_0, arg_9_1)
	if arg_9_1 >= arg_9_0._life_time then
		local var_9_0 = arg_9_0._projectile_unit
		local var_9_1 = arg_9_0._timed_data
		local var_9_2 = var_9_1.aoe

		if var_9_2 then
			local var_9_3 = POSITION_LOOKUP[var_9_0]

			arg_9_0:do_aoe(var_9_2, var_9_3)

			if var_9_1.grenade then
				local var_9_4 = arg_9_0._owner_unit
				local var_9_5 = ScriptUnit.has_extension(var_9_4, "buff_system")
				local var_9_6 = Unit.local_rotation(var_9_0, 0)

				if var_9_5 then
					var_9_5:trigger_procs("on_grenade_exploded", var_9_1, var_9_3, arg_9_0._is_critical_strike, arg_9_0.item_name, var_9_6, arg_9_0.scale, arg_9_0.power_level)
				end
			end
		end

		local var_9_7 = arg_9_0._timed_data.life_time_activate_sound_stop_event

		if var_9_7 then
			WwiseWorld.trigger_event(arg_9_0._wwise_world, var_9_7)
		end

		arg_9_0:_stop_by_life_time()
	end

	if arg_9_0._charge_t and arg_9_1 >= arg_9_0._charge_t then
		arg_9_0._charge_t = nil
		arg_9_0.is_charged = true

		local var_9_8 = arg_9_0._timed_data.charged_flow_event

		Unit.flow_event(arg_9_0._projectile_unit, var_9_8)
	end
end

PlayerProjectileHuskExtension.impact_level = function (arg_10_0, arg_10_1, arg_10_2, arg_10_3, arg_10_4, arg_10_5, arg_10_6)
	local var_10_0 = arg_10_0._impact_data

	arg_10_0:hit_level_unit(var_10_0, arg_10_1, arg_10_2, arg_10_3, arg_10_4, arg_10_5, arg_10_0._hit_units, arg_10_6)
	arg_10_0:_on_impact()
end

PlayerProjectileHuskExtension._on_impact = function (arg_11_0)
	local var_11_0 = arg_11_0._timed_data

	if var_11_0 and var_11_0.activate_life_time_on_impact then
		local var_11_1 = Managers.time:time("game")

		arg_11_0:_activate_life_time(var_11_1)
	end
end

PlayerProjectileHuskExtension._activate_life_time = function (arg_12_0, arg_12_1)
	local var_12_0 = arg_12_0._timed_data
	local var_12_1 = var_12_0.life_time_activate_sound_start_event

	if var_12_1 then
		WwiseWorld.trigger_event(arg_12_0._wwise_world, var_12_1)
	end

	arg_12_0._life_time = arg_12_1 + var_12_0.life_time
end

PlayerProjectileHuskExtension.impact_dynamic = function (arg_13_0, arg_13_1, arg_13_2, arg_13_3, arg_13_4, arg_13_5)
	local var_13_0 = arg_13_0._impact_data
	local var_13_1 = Unit.get_data(arg_13_1, "breed")
	local var_13_2 = false
	local var_13_3 = 0
	local var_13_4 = 0

	if var_13_1 then
		local var_13_5 = var_13_1.is_player

		if DamageUtils.is_enemy(arg_13_0._owner_unit, arg_13_1) then
			arg_13_0:hit_enemy(var_13_0, arg_13_1, arg_13_2, arg_13_3, arg_13_4, arg_13_5, var_13_1, arg_13_0._hit_units, var_13_4)
		elseif var_13_5 then
			arg_13_0:hit_player(var_13_0, arg_13_1, arg_13_2, arg_13_3, arg_13_4, arg_13_5, arg_13_0._hit_units, var_13_4)
		end
	else
		local var_13_6, var_13_7 = Managers.state.network:game_object_or_level_id(arg_13_1)

		if var_13_7 then
			local var_13_8

			arg_13_0:hit_level_unit(var_13_0, arg_13_1, arg_13_2, arg_13_3, arg_13_4, arg_13_5, arg_13_0._hit_units, var_13_8, var_13_2, var_13_4)
		elseif not var_13_7 then
			arg_13_0:hit_non_level_unit(var_13_0, arg_13_1, arg_13_2, arg_13_3, arg_13_4, arg_13_5, arg_13_0._hit_units, var_13_4)
		end
	end

	arg_13_0:_on_impact()
end

PlayerProjectileHuskExtension.hit_afro = function (arg_14_0, arg_14_1, arg_14_2)
	local var_14_0 = Actor.node(arg_14_2)
	local var_14_1 = arg_14_1.hit_zones_lookup[var_14_0].name

	return var_14_1 == "afro", var_14_1
end

PlayerProjectileHuskExtension.hit_enemy = function (arg_15_0, arg_15_1, arg_15_2, arg_15_3, arg_15_4, arg_15_5, arg_15_6, arg_15_7, arg_15_8, arg_15_9)
	if arg_15_6 == nil then
		return
	end

	local var_15_0, var_15_1 = arg_15_0:hit_afro(arg_15_7, arg_15_6)

	if var_15_0 then
		return
	end

	local var_15_2 = arg_15_1.damage_profile or "default"
	local var_15_3 = DamageProfileTemplates[var_15_2]
	local var_15_4 = true
	local var_15_5 = arg_15_1.aoe
	local var_15_6 = false

	if var_15_3 then
		var_15_4, var_15_6 = arg_15_0:hit_enemy_damage(var_15_3, arg_15_2, arg_15_3, arg_15_4, arg_15_5, arg_15_6, arg_15_7, arg_15_9, arg_15_8)
	end

	local var_15_7 = arg_15_1.grenade

	if var_15_5 and (var_15_7 or arg_15_0._amount_of_mass_hit >= arg_15_0._max_mass) then
		arg_15_0:do_aoe(var_15_5, arg_15_3)

		if var_15_7 then
			local var_15_8 = arg_15_0._owner_unit
			local var_15_9 = ScriptUnit.has_extension(var_15_8, "buff_system")

			if var_15_9 then
				var_15_9:trigger_procs("on_grenade_exploded", arg_15_1, arg_15_3, arg_15_0._is_critical_strike, arg_15_0.item_name, Unit.local_rotation(arg_15_0._projectile_unit, 0), arg_15_0.scale, arg_15_0.power_level)
			end
		end

		arg_15_0:stop(arg_15_2, var_15_1)
	end

	if arg_15_0._amount_of_mass_hit >= arg_15_0._max_mass then
		if arg_15_0._num_additional_penetrations > 0 then
			var_15_6 = true
		else
			if var_15_4 then
				arg_15_0:_handle_linking(arg_15_1, arg_15_2, arg_15_3, arg_15_4, arg_15_5, arg_15_6, arg_15_0._did_damage, true)
			end

			arg_15_0:stop(arg_15_2, var_15_1)
		end
	end

	if var_15_6 then
		arg_15_0._num_additional_penetrations = arg_15_0._num_additional_penetrations - 1
	end
end

PlayerProjectileHuskExtension.hit_enemy_damage = function (arg_16_0, arg_16_1, arg_16_2, arg_16_3, arg_16_4, arg_16_5, arg_16_6, arg_16_7, arg_16_8, arg_16_9)
	local var_16_0 = arg_16_0._owner_player
	local var_16_1 = arg_16_0._owner_unit
	local var_16_2 = arg_16_0._current_action
	local var_16_3 = Actor.node(arg_16_6)
	local var_16_4 = arg_16_7.hit_zones_lookup[var_16_3]
	local var_16_5 = var_16_2.projectile_info.forced_hitzone or var_16_4.name
	local var_16_6 = HEALTH_ALIVE[arg_16_2]

	if var_16_6 then
		arg_16_0._num_targets_hit = arg_16_0._num_targets_hit + 1
		arg_16_9[arg_16_2] = true
	end

	local var_16_7 = arg_16_1.default_target
	local var_16_8 = arg_16_0._is_critical_strike
	local var_16_9 = DamageUtils.get_attack_template(var_16_7.attack_template)
	local var_16_10 = false
	local var_16_11 = false
	local var_16_12 = var_16_7.trueflight_blocking

	if not var_16_2.ignore_shield_hit then
		var_16_10 = AiUtils.attack_is_shield_blocked(arg_16_2, var_16_1, var_16_12, arg_16_4)
	end

	if var_16_6 then
		local var_16_13 = var_16_2.hit_mass_count
		local var_16_14 = Managers.state.difficulty:get_difficulty_rank()
		local var_16_15 = var_16_10 and (arg_16_7.hit_mass_counts_block and (arg_16_7.hit_mass_counts_block[var_16_14] or arg_16_7.hit_mass_counts_block[2]) or arg_16_7.hit_mass_count_block) or arg_16_7.hit_mass_counts and (arg_16_7.hit_mass_counts[var_16_14] or arg_16_7.hit_mass_counts[2]) or arg_16_7.hit_mass_count or 1

		if arg_16_0.ignore_mass_and_armour then
			var_16_15 = 1
		elseif var_16_13 and var_16_13[arg_16_7.name] then
			var_16_15 = var_16_15 * (var_16_13[arg_16_7.name] or 1)
		end

		arg_16_0._amount_of_mass_hit = arg_16_0._amount_of_mass_hit + var_16_15
	end

	local var_16_16 = math.ceil(arg_16_0._amount_of_mass_hit)
	local var_16_17 = var_16_2.hit_effect
	local var_16_18 = not var_16_0.local_player
	local var_16_19 = var_16_9.sound_type
	local var_16_20 = arg_16_7.name
	local var_16_21 = Quaternion.look(arg_16_5)
	local var_16_22 = arg_16_0.power_level
	local var_16_23 = arg_16_0.item_name
	local var_16_24, var_16_25 = DamageUtils.calculate_damage(DamageOutput, arg_16_2, var_16_1, var_16_5, var_16_22, BoostCurves[var_16_7.boost_curve_type], arg_16_8, var_16_8, arg_16_1, var_16_16, nil, var_16_23)
	local var_16_26 = var_16_24 <= 0

	if var_16_6 and var_16_26 then
		arg_16_0._did_damage = var_16_24

		if arg_16_0._num_additional_penetrations > 0 then
			var_16_11 = true
		else
			arg_16_0._amount_of_mass_hit = arg_16_0._max_mass

			arg_16_0:stop(arg_16_2, var_16_5)
		end
	elseif var_16_6 and not var_16_2.ignore_armor and (arg_16_7.armor_category == 2 or arg_16_7.armor_category == 3 or var_16_10) then
		arg_16_0._did_damage = var_16_24

		if arg_16_0._num_additional_penetrations > 0 then
			var_16_11 = true
		else
			arg_16_0._amount_of_mass_hit = arg_16_0._max_mass

			arg_16_0:stop(arg_16_2, var_16_5)
		end
	else
		arg_16_0._did_damage = var_16_24

		if var_16_5 == "head" or var_16_5 == "neck" then
			arg_16_0._did_damage = var_16_24 - 1
		end

		EffectHelper.player_critical_hit(arg_16_0._world, var_16_8, var_16_1, arg_16_2, arg_16_3)
	end

	if var_16_25 then
		var_16_17 = "invulnerable"
	end

	if var_16_17 then
		EffectHelper.play_skinned_surface_material_effects(var_16_17, arg_16_0._world, arg_16_2, arg_16_3, var_16_21, arg_16_5, var_16_18, var_16_20, var_16_19, var_16_26, var_16_5, var_16_10, arg_16_7)
	end

	return var_16_5 ~= "ward", var_16_11
end

PlayerProjectileHuskExtension.hit_player = function (arg_17_0, arg_17_1, arg_17_2, arg_17_3, arg_17_4, arg_17_5, arg_17_6, arg_17_7, arg_17_8)
	if arg_17_6 == nil then
		return
	end

	local var_17_0 = Managers.state.difficulty:get_difficulty_settings()
	local var_17_1 = false
	local var_17_2 = false
	local var_17_3 = arg_17_0._owner_player
	local var_17_4 = arg_17_1.damage_profile or "default"
	local var_17_5 = DamageProfileTemplates[var_17_4]

	if var_17_5 and DamageUtils.allow_friendly_fire_ranged(var_17_0, var_17_3) and arg_17_7[arg_17_2] == nil then
		arg_17_0:hit_player_damage(var_17_5, arg_17_2, arg_17_3, arg_17_4, arg_17_5, arg_17_6, arg_17_8, arg_17_7)

		var_17_1 = true
	end

	if var_17_1 then
		local var_17_6 = arg_17_1.aoe

		if var_17_6 and arg_17_0._amount_of_mass_hit >= arg_17_0._max_mass then
			if arg_17_0._num_additional_penetrations > 0 then
				var_17_2 = true
			else
				arg_17_0:do_aoe(var_17_6, arg_17_3)

				if arg_17_1.grenade then
					local var_17_7 = arg_17_0._owner_unit
					local var_17_8 = ScriptUnit.has_extension(var_17_7, "buff_system")

					if var_17_8 then
						var_17_8:trigger_procs("on_grenade_exploded", arg_17_1, arg_17_3, arg_17_0._is_critical_strike, arg_17_0.item_name, Unit.local_rotation(arg_17_0._projectile_unit, 0), arg_17_0.scale, arg_17_0.power_level)
					end
				end

				arg_17_0:stop()
			end
		end

		if arg_17_0._amount_of_mass_hit >= arg_17_0._max_mass then
			if arg_17_0._num_additional_penetrations > 0 then
				var_17_2 = true
			else
				arg_17_0:stop()
			end
		end
	end

	if var_17_2 then
		arg_17_0._num_additional_penetrations = arg_17_0._num_additional_penetrations - 1
	end
end

PlayerProjectileHuskExtension.hit_player_damage = function (arg_18_0, arg_18_1, arg_18_2, arg_18_3, arg_18_4, arg_18_5, arg_18_6, arg_18_7, arg_18_8)
	local var_18_0 = arg_18_0._owner_unit

	arg_18_8[arg_18_2] = true
	arg_18_0._num_targets_hit = arg_18_0._num_targets_hit + 1
	arg_18_0._amount_of_mass_hit = arg_18_0._amount_of_mass_hit + 1

	local var_18_1 = math.ceil(arg_18_0._amount_of_mass_hit)
	local var_18_2 = arg_18_1.default_target
	local var_18_3 = arg_18_0._current_action.hit_effect
	local var_18_4 = not arg_18_0._owner_player.local_player
	local var_18_5 = Quaternion.look(arg_18_4, Vector3.up())
	local var_18_6 = arg_18_0.power_level
	local var_18_7 = "torso"
	local var_18_8 = arg_18_0._is_critical_strike
	local var_18_9 = arg_18_0.item_name
	local var_18_10, var_18_11 = DamageUtils.calculate_damage(DamageOutput, arg_18_2, var_18_0, var_18_7, var_18_6, BoostCurves[var_18_2.boost_curve_type], arg_18_7, var_18_8, arg_18_1, var_18_1, nil, var_18_9)

	if var_18_10 <= 0 then
		arg_18_0._did_damage = false
		arg_18_0._stop_impacts = true
	else
		arg_18_0._did_damage = var_18_10
	end

	if var_18_11 then
		var_18_3 = "invulnerable"
	end

	if var_18_3 then
		EffectHelper.play_skinned_surface_material_effects(var_18_3, arg_18_0._world, arg_18_2, arg_18_3, var_18_5, arg_18_5, var_18_4)
	end
end

PlayerProjectileHuskExtension.hit_level_unit = function (arg_19_0, arg_19_1, arg_19_2, arg_19_3, arg_19_4, arg_19_5, arg_19_6, arg_19_7, arg_19_8, arg_19_9)
	local var_19_0 = ScriptUnit.has_extension(arg_19_2, "health_system")
	local var_19_1 = arg_19_1.damage_profile_prop or arg_19_1.damage_profile or "default"
	local var_19_2 = DamageProfileTemplates[var_19_1]
	local var_19_3 = Unit.get_data(arg_19_2, "allow_ranged_damage") ~= false

	if var_19_2 and (GameSettingsDevelopment.allow_ranged_attacks_to_damage_props or var_19_3) then
		if var_19_0 and arg_19_7[arg_19_2] == nil then
			arg_19_0:hit_damagable_prop(var_19_2, arg_19_2, arg_19_3, arg_19_4, arg_19_5, arg_19_6, arg_19_7, arg_19_8, arg_19_9)
		elseif arg_19_2 and Unit.alive(arg_19_2) and arg_19_6 then
			local var_19_4 = Unit.set_flow_variable

			var_19_4(arg_19_2, "hit_actor", arg_19_6)
			var_19_4(arg_19_2, "hit_direction", arg_19_4)
			var_19_4(arg_19_2, "hit_position", arg_19_3)
			Unit.flow_event(arg_19_2, "lua_simple_damage")
		end
	end

	local var_19_5 = arg_19_0._current_action.hit_effect

	if var_19_5 then
		local var_19_6 = arg_19_0._world
		local var_19_7 = Quaternion.look(arg_19_4)
		local var_19_8 = not arg_19_0._owner_player.local_player

		EffectHelper.play_surface_material_effects(var_19_5, var_19_6, arg_19_2, arg_19_3, var_19_7, arg_19_5, nil, var_19_8, nil, arg_19_6)
	end

	local var_19_9 = arg_19_1.bounce_on_level_units
	local var_19_10 = ScriptUnit.has_extension(arg_19_0._owner_unit, "buff_system")
	local var_19_11 = 0

	if not arg_19_1.grenade and var_19_10 and not var_19_9 then
		var_19_9 = var_19_10:has_buff_perk("add_projectile_bounces")
		var_19_11 = var_19_10:apply_buffs_to_value(var_19_11, "projectile_bounces")
	end

	local var_19_12 = false

	if var_19_9 then
		local var_19_13 = arg_19_0._num_bounces
		local var_19_14 = (arg_19_1.max_bounces or 1) + var_19_11
		local var_19_15 = arg_19_0.locomotion_extension

		if var_19_15.bounce and var_19_13 < var_19_14 then
			var_19_15:bounce(arg_19_3, arg_19_4, arg_19_5)

			arg_19_0._num_bounces = arg_19_0._num_bounces + 1
		else
			var_19_12 = true
		end
	end

	local var_19_16 = arg_19_1.aoe
	local var_19_17 = arg_19_1.aoe_on_bounce

	if var_19_16 and (not var_19_9 or var_19_12 or var_19_17) then
		arg_19_0:do_aoe(var_19_16, arg_19_3)

		if arg_19_1.grenade and var_19_10 then
			var_19_10:trigger_procs("on_grenade_exploded", arg_19_1, arg_19_3, arg_19_0._is_critical_strike, arg_19_0.item_name, Unit.local_rotation(arg_19_0._projectile_unit, 0), arg_19_0.scale, arg_19_0.power_level)
		end
	end

	if var_19_9 and not var_19_12 then
		return
	elseif arg_19_6 then
		arg_19_0:_handle_linking(arg_19_1, arg_19_2, arg_19_3, arg_19_4, arg_19_5, arg_19_6)
	end

	arg_19_0:stop()
end

PlayerProjectileHuskExtension.hit_damagable_prop = function (arg_20_0, arg_20_1, arg_20_2, arg_20_3, arg_20_4, arg_20_5, arg_20_6, arg_20_7, arg_20_8, arg_20_9)
	arg_20_7[arg_20_2] = true
end

PlayerProjectileHuskExtension.hit_non_level_unit = function (arg_21_0, arg_21_1, arg_21_2, arg_21_3, arg_21_4, arg_21_5, arg_21_6, arg_21_7, arg_21_8)
	local var_21_0 = arg_21_1.damage_profile_prop or arg_21_1.damage_profile or "default"
	local var_21_1 = DamageProfileTemplates[var_21_0]
	local var_21_2 = false

	if var_21_1 then
		if ScriptUnit.has_extension(arg_21_2, "health_system") and arg_21_7[arg_21_2] == nil then
			arg_21_0:hit_non_level_damagable_unit(var_21_1, arg_21_2, arg_21_3, arg_21_4, arg_21_5, arg_21_6, arg_21_7, arg_21_8)

			var_21_2 = true
		elseif arg_21_2 and Unit.alive(arg_21_2) and arg_21_6 then
			local var_21_3 = Unit.set_flow_variable

			var_21_3(arg_21_2, "hit_actor", arg_21_6)
			var_21_3(arg_21_2, "hit_direction", arg_21_4)
			var_21_3(arg_21_2, "hit_position", arg_21_3)
			Unit.flow_event(arg_21_2, "lua_simple_damage")
		end
	end

	local var_21_4 = arg_21_1.aoe

	if var_21_4 then
		arg_21_0:do_aoe(var_21_4, arg_21_3)

		if arg_21_1.grenade then
			local var_21_5 = arg_21_0._owner_unit
			local var_21_6 = ScriptUnit.has_extension(var_21_5, "buff_system")

			if var_21_6 then
				var_21_6:trigger_procs("on_grenade_exploded", arg_21_1, arg_21_3, arg_21_0._is_critical_strike, arg_21_0.item_name, Unit.local_rotation(arg_21_0._projectile_unit, 0), arg_21_0.scale, arg_21_0.power_level)
			end
		end

		var_21_2 = true
	end

	if var_21_2 then
		if arg_21_0._num_additional_penetrations > 0 then
			arg_21_0._num_additional_penetrations = arg_21_0._num_additional_penetrations - 1
		else
			arg_21_0:stop()
		end
	end
end

PlayerProjectileHuskExtension.hit_non_level_damagable_unit = function (arg_22_0, arg_22_1, arg_22_2, arg_22_3, arg_22_4, arg_22_5, arg_22_6, arg_22_7, arg_22_8)
	arg_22_7[arg_22_2] = true

	local var_22_0 = arg_22_0._current_action.hit_effect

	if var_22_0 then
		local var_22_1 = arg_22_0._world
		local var_22_2 = Quaternion.look(arg_22_4)
		local var_22_3 = not arg_22_0._owner_player.local_player

		EffectHelper.play_surface_material_effects(var_22_0, var_22_1, arg_22_2, arg_22_3, var_22_2, arg_22_5, nil, var_22_3, nil, arg_22_6)
	end
end

PlayerProjectileHuskExtension._get_projectile_units_names = function (arg_23_0, arg_23_1)
	local var_23_0 = arg_23_1.projectile_units_template

	var_23_0 = arg_23_1.use_weapon_skin and arg_23_0._skin_projectile_units_template or var_23_0

	return ProjectileUnits[var_23_0]
end

PlayerProjectileHuskExtension._handle_linking = function (arg_24_0, arg_24_1, arg_24_2, arg_24_3, arg_24_4, arg_24_5, arg_24_6, arg_24_7, arg_24_8)
	if not arg_24_1.link and not arg_24_1.link_pickup then
		return
	end

	local var_24_0 = true
	local var_24_1 = Unit.get_data(arg_24_2, "allow_link")

	if var_24_1 ~= nil then
		var_24_0 = var_24_1
	end

	if not var_24_0 then
		return
	end

	local var_24_2 = arg_24_0.projectile_info
	local var_24_3 = arg_24_0:_get_projectile_units_names(var_24_2)
	local var_24_4 = var_24_3 and var_24_3.dummy_linker_unit_name

	if var_24_4 then
		local var_24_5 = arg_24_1.depth or 0.15
		local var_24_6 = arg_24_1.depth_offset or 0.15

		if var_24_3.dummy_linker_broken_units then
			local var_24_7 = Math.random()

			if arg_24_7 then
				var_24_7 = var_24_7 * math.clamp(arg_24_7 / 2, 0.75, 1.25)
			else
				var_24_7 = var_24_7 * 2
			end

			if var_24_7 <= 0.5 then
				local var_24_8 = #var_24_3.dummy_linker_broken_units
				local var_24_9 = Math.random(1, var_24_8)

				var_24_4 = var_24_3.dummy_linker_broken_units[var_24_9]

				if var_24_9 == 1 then
					var_24_5 = 0.05
					var_24_6 = 0.1
				else
					var_24_6 = 0.15
				end
			end
		elseif arg_24_7 then
			var_24_5 = var_24_5 * math.clamp(arg_24_7, 1, 3)
		end

		local var_24_10 = var_24_5 + var_24_6

		arg_24_0:_link_projectile(arg_24_2, arg_24_6, var_24_4, arg_24_3, arg_24_4, var_24_10, arg_24_1.flow_event_on_init, arg_24_1.flow_event_on_walls)
	end
end

PlayerProjectileHuskExtension._link_projectile = function (arg_25_0, arg_25_1, arg_25_2, arg_25_3, arg_25_4, arg_25_5, arg_25_6, arg_25_7, arg_25_8)
	if Managers.state.side:versus_is_dark_pact(arg_25_1) then
		local var_25_0 = Managers.player:unit_owner(arg_25_1)

		if var_25_0 and var_25_0.local_player and not var_25_0.bot_player then
			return
		end
	end

	local var_25_1 = Managers.state.unit_spawner
	local var_25_2 = arg_25_0.projectile_linker_system
	local var_25_3 = Math.random() * 2.14 - 0.5
	local var_25_4 = Vector3.normalize(arg_25_5)
	local var_25_5 = arg_25_4 + var_25_4 * arg_25_6
	local var_25_6 = Quaternion.multiply(Quaternion.look(var_25_4), Quaternion(Vector3.forward(), var_25_3))
	local var_25_7

	if ScriptUnit.has_extension(arg_25_1, "projectile_linker_system") then
		local var_25_8 = Actor.node(arg_25_2)

		var_25_7 = var_25_1:spawn_local_unit(arg_25_3, var_25_5, var_25_6)

		local var_25_9 = Unit.world_rotation(arg_25_1, var_25_8)
		local var_25_10 = var_25_5 - Unit.world_position(arg_25_1, var_25_8)
		local var_25_11 = Vector3(Vector3.dot(Quaternion.right(var_25_9), var_25_10), Vector3.dot(Quaternion.forward(var_25_9), var_25_10), Vector3.dot(Quaternion.up(var_25_9), var_25_10))

		if arg_25_7 then
			Unit.flow_event(var_25_7, arg_25_7)
		end

		ScriptUnit.extension(arg_25_1, "projectile_linker_system"):link_projectile(var_25_7, var_25_11, var_25_6, var_25_8)
		var_25_2:add_linked_projectile_reference(arg_25_1, var_25_7)
	else
		var_25_7 = var_25_1:spawn_local_unit(arg_25_3, var_25_5, var_25_6)

		var_25_2:add_linked_projectile_reference(arg_25_1, var_25_7)

		if arg_25_7 then
			Unit.flow_event(var_25_7, arg_25_7)
		end

		if arg_25_8 then
			Unit.flow_event(var_25_7, arg_25_8)
		end
	end

	if arg_25_0._material_settings_name then
		GearUtils.apply_material_settings(var_25_7, arg_25_0._material_settings_name)
	end
end

PlayerProjectileHuskExtension.do_aoe = function (arg_26_0, arg_26_1, arg_26_2)
	local var_26_0 = arg_26_0._world
	local var_26_1 = arg_26_0._projectile_unit
	local var_26_2 = arg_26_0._owner_unit
	local var_26_3 = arg_26_0.item_name
	local var_26_4 = arg_26_0._is_server
	local var_26_5 = arg_26_0._owner_unit

	if arg_26_1.explosion then
		local var_26_6 = Unit.local_rotation(var_26_1, 0)
		local var_26_7 = arg_26_0.scale
		local var_26_8 = arg_26_0.power_level
		local var_26_9 = true

		DamageUtils.create_explosion(var_26_0, var_26_2, arg_26_2, var_26_6, arg_26_1, var_26_7, var_26_3, var_26_4, var_26_9, var_26_1, var_26_8, arg_26_0._is_critical_strike, var_26_5)
	end

	if var_26_4 then
		if arg_26_1.aoe then
			DamageUtils.create_aoe(var_26_0, var_26_2, arg_26_2, var_26_3, arg_26_1)
		end

		if arg_26_1.taunt then
			DamageUtils.create_taunt(var_26_0, var_26_2, var_26_1, arg_26_2, arg_26_1)
		end
	end
end

PlayerProjectileHuskExtension.trigger_external_event = function (arg_27_0, arg_27_1, arg_27_2)
	local var_27_0 = arg_27_0.projectile_info.external_events
	local var_27_1 = var_27_0 and var_27_0[arg_27_1]

	if var_27_1 then
		var_27_1(arg_27_0)
	end
end
