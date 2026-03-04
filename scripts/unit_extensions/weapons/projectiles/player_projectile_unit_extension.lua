-- chunkname: @scripts/unit_extensions/weapons/projectiles/player_projectile_unit_extension.lua

PlayerProjectileUnitExtension = class(PlayerProjectileUnitExtension)

local var_0_0 = Unit.world_rotation
local var_0_1 = Unit.world_position
local var_0_2 = Quaternion.forward
local var_0_3 = Vector3.lerp
local var_0_4 = Quaternion.lerp
local var_0_5 = Unit.set_local_position
local var_0_6 = Unit.set_local_rotation
local var_0_7 = 0.3

PlayerProjectileUnitExtension.init = function (arg_1_0, arg_1_1, arg_1_2, arg_1_3)
	local var_1_0 = arg_1_3.item_name
	local var_1_1 = arg_1_3.owner_unit

	arg_1_0._world = arg_1_1.world
	arg_1_0._wwise_world = Managers.world:wwise_world(arg_1_0._world)
	arg_1_0._projectile_unit = arg_1_2
	arg_1_0._owner_unit = var_1_1
	arg_1_0._owner_player = Managers.player:owner(var_1_1)

	local var_1_2 = ScriptUnit.has_extension(var_1_1, "buff_system")

	arg_1_0.item_name = var_1_0
	arg_1_0._material_settings_name = nil

	local var_1_3 = ScriptUnit.has_extension(arg_1_0._owner_unit, "inventory_system")

	if var_1_3 then
		local var_1_4 = var_1_3:equipment()

		if var_1_4 then
			local var_1_5 = var_1_4.wielded

			if var_1_5 then
				local var_1_6 = BackendUtils.get_item_units(var_1_5)

				if var_1_6 and var_1_6.is_ammo_weapon then
					local var_1_7 = BackendUtils.get_item_template(var_1_5)
					local var_1_8 = var_1_6.material_settings_name or var_1_7.material_settings_name

					if var_1_8 then
						arg_1_0._material_settings_name = var_1_8
					end
				end
			end
		end
	end

	if arg_1_0._material_settings_name then
		GearUtils.apply_material_settings(arg_1_2, arg_1_0._material_settings_name)
	end

	local var_1_9 = ItemMasterList[var_1_0]
	local var_1_10 = BackendUtils.get_item_template(var_1_9)
	local var_1_11 = arg_1_3.item_template_name
	local var_1_12 = arg_1_3.action_name
	local var_1_13 = arg_1_3.sub_action_name

	arg_1_0.action_lookup_data = {
		item_template_name = var_1_11,
		action_name = var_1_12,
		sub_action_name = var_1_13
	}

	local var_1_14 = var_1_10.actions[var_1_12][var_1_13]

	arg_1_0._current_action = var_1_14

	local var_1_15 = var_1_14.projectile_info
	local var_1_16 = var_1_14.impact_data
	local var_1_17 = var_1_14.timed_data

	arg_1_0.power_level = arg_1_3.power_level
	arg_1_0.projectile_info = var_1_15
	arg_1_0.charge_data = var_1_14.charge_data
	arg_1_0.chain_hit_settings = var_1_14.chain_hit_settings

	if var_1_16.grenade and var_1_2 and var_1_2:has_buff_perk("frag_fire_grenades") then
		var_1_16 = table.shallow_copy(var_1_16)
		var_1_16.aoe = ExplosionUtils.get_template("frag_fire_grenade")
	end

	if var_1_16 then
		arg_1_0._impact_data = var_1_16

		local var_1_18 = var_1_16.damage_profile or "default"

		arg_1_0._impact_damage_profile_id = NetworkLookup.damage_profiles[var_1_18]
	end

	if var_1_17 then
		arg_1_0._timed_data = var_1_17

		local var_1_19 = var_1_17.damage_profile or "default"

		arg_1_0._timed_damage_profile_id = NetworkLookup.damage_profiles[var_1_19]
	end

	arg_1_0._time_initialized = arg_1_3.time_initialized
	arg_1_0.scale = arg_1_3.scale
	arg_1_0.charge_level = (arg_1_3.charge_level or 0) / 100
	arg_1_0._num_targets_hit = 0
	arg_1_0._hit_units = {}
	arg_1_0._hit_afro_units = {}

	local var_1_20 = Managers.state.entity

	arg_1_0._weapon_system = var_1_20:system("weapon_system")
	arg_1_0._projectile_linker_system = var_1_20:system("projectile_linker_system")
	arg_1_0._is_server = Managers.player.is_server
	arg_1_0._marked_for_deletion = false
	arg_1_0._did_damage = false
	arg_1_0._num_bounces = 0
	arg_1_0._num_additional_penetrations = var_1_2:apply_buffs_to_value(0, "ranged_additional_penetrations")
	arg_1_0._active = true
	arg_1_0._is_critical_strike = not not arg_1_3.is_critical_strike
	arg_1_0._stop_impacts = not not arg_1_3.stopped

	arg_1_0:initialize_projectile(var_1_15, var_1_16)
end

PlayerProjectileUnitExtension.extensions_ready = function (arg_2_0, arg_2_1, arg_2_2)
	arg_2_0.locomotion_extension = ScriptUnit.extension(arg_2_2, "projectile_locomotion_system")
	arg_2_0._impact_extension = ScriptUnit.extension(arg_2_2, "projectile_impact_system")
end

PlayerProjectileUnitExtension.initialize_projectile = function (arg_3_0, arg_3_1, arg_3_2)
	local var_3_0 = arg_3_0._projectile_unit

	if arg_3_2 then
		arg_3_0._is_impact = true
		arg_3_0._stop_impacts = false
		arg_3_0._amount_of_mass_hit = 0

		local var_3_1 = arg_3_2.damage_profile or "default"
		local var_3_2 = DamageProfileTemplates[var_3_1]
		local var_3_3 = arg_3_0._owner_unit
		local var_3_4 = Managers.state.difficulty:get_difficulty()
		local var_3_5 = ActionUtils.scale_power_levels(arg_3_0.power_level, "cleave", var_3_3, var_3_4)
		local var_3_6, var_3_7 = ActionUtils.get_max_targets(var_3_2, var_3_5)

		arg_3_0._max_mass = var_3_7 < var_3_6 and var_3_6 or var_3_7
	end

	local var_3_8 = arg_3_0._timed_data

	if var_3_8 then
		arg_3_0._is_timed = true

		if var_3_8.activate_life_time_on_impact then
			arg_3_0._life_time = math.huge
		else
			arg_3_0:_activate_life_time(arg_3_0._time_initialized)
		end

		if var_3_8.charge_time then
			arg_3_0._charge_t = arg_3_0._time_initialized + var_3_8.charge_time * (1 - arg_3_0.charge_level)
		end
	end

	if arg_3_1.times_bigger then
		local var_3_9 = arg_3_0.scale

		Unit.set_flow_variable(var_3_0, "scale", var_3_9)

		local var_3_10 = arg_3_1.times_bigger
		local var_3_11 = math.lerp(1, var_3_10, var_3_9)

		Unit.set_local_scale(var_3_0, 0, Vector3(var_3_11, var_3_11, var_3_11))
	end

	if arg_3_1.hide_projectile then
		Unit.set_unit_visibility(var_3_0, false)
	end

	if arg_3_1.anim_blend_settings then
		local var_3_12 = ScriptUnit.extension(arg_3_0._owner_unit, "first_person_system"):get_first_person_unit()
		local var_3_13 = arg_3_1.anim_blend_settings.link_node

		arg_3_0._owner_unit_1p = var_3_12
		arg_3_0._anim_node_id = Unit.has_node(var_3_12, var_3_13) and Unit.node(var_3_12, var_3_13) or 0
		arg_3_0._anim_blend_enabled = true
	end

	Unit.flow_event(var_3_0, "lua_projectile_init")
	arg_3_0:_handle_critical_strike(var_3_0, arg_3_0._is_critical_strike)
	Unit.flow_event(var_3_0, "lua_trail")
end

PlayerProjectileUnitExtension._handle_critical_strike = function (arg_4_0, arg_4_1, arg_4_2)
	if arg_4_0._is_critical_strike then
		Unit.flow_event(arg_4_1, "vfx_critical_strike")
	end
end

PlayerProjectileUnitExtension.mark_for_deletion = function (arg_5_0)
	if not arg_5_0._marked_for_deletion then
		arg_5_0._marked_for_deletion = true
		arg_5_0._deletion_time = Managers.time:time("game") + var_0_7
	end
end

PlayerProjectileUnitExtension.stop = function (arg_6_0, arg_6_1, arg_6_2, arg_6_3)
	if arg_6_0._stop_impacts then
		return
	end

	local var_6_0 = arg_6_0._projectile_unit

	if arg_6_0._anim_blend_enabled then
		arg_6_0._anim_blend_enabled = false

		local var_6_1 = arg_6_0.locomotion_extension:current_position()
		local var_6_2 = arg_6_0.locomotion_extension:current_rotation()

		var_0_5(var_6_0, 0, var_6_1)
		var_0_6(var_6_0, 0, var_6_2)
	end

	if arg_6_0.projectile_info.rotation_on_hit then
		local var_6_3 = arg_6_0.projectile_info.rotation_on_hit(var_6_0)

		var_0_6(var_6_0, 0, var_6_3)
	end

	local var_6_4 = arg_6_0._timed_data

	if not (var_6_4 and var_6_4.activate_life_time_on_impact) then
		arg_6_0:mark_for_deletion()
		Unit.flow_event(var_6_0, "lua_projectile_end")

		arg_6_0._active = false
	end

	arg_6_0.locomotion_extension:stop(arg_6_1, arg_6_2, arg_6_3)

	arg_6_0._stop_impacts = true
end

PlayerProjectileUnitExtension._stop_by_life_time = function (arg_7_0)
	arg_7_0:mark_for_deletion()
	Unit.flow_event(arg_7_0._projectile_unit, "lua_projectile_end")
	arg_7_0.locomotion_extension:stop()

	arg_7_0._stop_impacts = true
	arg_7_0._active = false
end

PlayerProjectileUnitExtension.update = function (arg_8_0, arg_8_1, arg_8_2, arg_8_3, arg_8_4, arg_8_5)
	if arg_8_0._marked_for_deletion then
		if arg_8_5 >= arg_8_0._deletion_time and not arg_8_0.delete_done then
			arg_8_0.delete_done = true

			Managers.state.unit_spawner:mark_for_deletion(arg_8_0._projectile_unit)
		end

		return
	end

	if arg_8_0._delayed_external_events then
		arg_8_0:_update_delayed_external_event(arg_8_5)
	end

	if arg_8_0._anim_blend_enabled then
		local var_8_0 = arg_8_0._owner_unit_1p
		local var_8_1 = arg_8_0.projectile_info.anim_blend_settings
		local var_8_2 = var_8_1.blend_time
		local var_8_3 = var_8_1.blend_func
		local var_8_4 = arg_8_0.locomotion_extension.time_lived
		local var_8_5 = math.min(var_8_3(var_8_4 / var_8_2), 1)

		if not ALIVE[var_8_0] or var_8_5 >= 1 then
			arg_8_0._anim_blend_enabled = false
		else
			local var_8_6 = arg_8_0.locomotion_extension:current_position()
			local var_8_7 = arg_8_0.locomotion_extension:current_rotation()

			if var_8_6 and var_8_7 then
				local var_8_8 = arg_8_0._anim_node_id
				local var_8_9 = var_8_1.forward_offset
				local var_8_10 = var_0_0(var_8_0, 0)
				local var_8_11 = var_0_1(var_8_0, var_8_8)
				local var_8_12 = var_0_2(var_8_10) * var_8_9
				local var_8_13 = var_0_3(var_8_11 + var_8_12, var_8_6, var_8_5)

				var_0_5(arg_8_1, 0, var_8_13)

				if var_8_1.use_anim_rotation then
					local var_8_14 = var_0_0(var_8_0, var_8_8)
					local var_8_15 = var_0_4(var_8_14, var_8_7, var_8_5)

					var_0_6(arg_8_1, 0, var_8_15)
				end
			end
		end
	end

	if arg_8_0._is_timed then
		arg_8_0:handle_timed_events(arg_8_5)
	end

	if arg_8_0._is_impact and not arg_8_0._stop_impacts then
		local var_8_16, var_8_17 = arg_8_0._impact_extension:recent_impacts()

		if var_8_17 > 0 then
			arg_8_0:handle_impacts(var_8_16, var_8_17, arg_8_5)
		end
	end
end

PlayerProjectileUnitExtension.handle_timed_events = function (arg_9_0, arg_9_1)
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

				if var_9_5 then
					local var_9_6 = Unit.local_rotation(var_9_0, 0)

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

PlayerProjectileUnitExtension.destroy = function (arg_10_0)
	if arg_10_0._projectile_unit and arg_10_0._active then
		arg_10_0:stop()
	end
end

PlayerProjectileUnitExtension.validate_position = function (arg_11_0, arg_11_1, arg_11_2, arg_11_3)
	for iter_11_0 = 1, 3 do
		local var_11_0 = arg_11_1[iter_11_0]

		if var_11_0 < arg_11_2 or arg_11_3 < var_11_0 then
			print("[PlayerProjectileUnitExtension] position is not valid, outside of NetworkConstants.position")

			return false
		end
	end

	return true
end

PlayerProjectileUnitExtension._alert_enemy = function (arg_12_0, arg_12_1, arg_12_2)
	local var_12_0 = arg_12_0._is_server
	local var_12_1 = Managers.state.network

	if var_12_0 then
		AiUtils.alert_unit_of_enemy(arg_12_1, arg_12_2)
	elseif Unit.alive(arg_12_2) then
		local var_12_2 = var_12_1:unit_game_object_id(arg_12_1)
		local var_12_3 = var_12_1:unit_game_object_id(arg_12_2)

		var_12_1.network_transmit:send_rpc_server("rpc_alert_enemy", var_12_2, var_12_3)
	end
end

local var_0_8 = {}

PlayerProjectileUnitExtension.handle_impacts = function (arg_13_0, arg_13_1, arg_13_2, arg_13_3)
	table.clear(var_0_8)

	local var_13_0 = arg_13_0._projectile_unit
	local var_13_1 = arg_13_0._owner_unit
	local var_13_2 = arg_13_0._is_server
	local var_13_3 = ProjectileImpactDataIndex.UNIT
	local var_13_4 = ProjectileImpactDataIndex.POSITION
	local var_13_5 = ProjectileImpactDataIndex.DIRECTION
	local var_13_6 = ProjectileImpactDataIndex.NORMAL
	local var_13_7 = ProjectileImpactDataIndex.ACTOR_INDEX
	local var_13_8 = arg_13_0._hit_units
	local var_13_9 = arg_13_0._hit_afro_units
	local var_13_10 = arg_13_0._impact_data
	local var_13_11 = Managers.state.network
	local var_13_12 = var_13_11.network_transmit
	local var_13_13 = var_13_11:unit_game_object_id(var_13_0)
	local var_13_14 = NetworkConstants.position.min
	local var_13_15 = NetworkConstants.position.max

	for iter_13_0 = 1, arg_13_2 / ProjectileImpactDataIndex.STRIDE do
		local var_13_16 = (iter_13_0 - 1) * ProjectileImpactDataIndex.STRIDE
		local var_13_17 = arg_13_1[var_13_16 + var_13_4]:unbox()
		local var_13_18 = arg_13_1[var_13_16 + var_13_3]
		local var_13_19 = arg_13_1[var_13_16 + var_13_7]
		local var_13_20 = Unit.actor(var_13_18, var_13_19)
		local var_13_21 = AiUtils.unit_breed(var_13_18)

		if var_13_21 then
			local var_13_22 = Actor.node(var_13_20)
			local var_13_23 = var_13_21.hit_zones_lookup[var_13_22]

			if var_13_23 and var_13_23.name ~= "afro" then
				local var_13_24 = var_0_8[var_13_18]

				if not var_13_24 or var_13_24 and var_13_23.prio < var_13_24.prio then
					var_0_8[var_13_18] = var_13_23
				end
			elseif not var_13_9[var_13_18] and var_13_23 and var_13_23.name == "afro" then
				arg_13_0:_alert_enemy(var_13_18, var_13_1)

				var_13_9[var_13_18] = true
			end
		end
	end

	for iter_13_1 = 1, arg_13_2 / ProjectileImpactDataIndex.STRIDE do
		repeat
			if arg_13_0._stop_impacts then
				return
			end

			local var_13_25 = (iter_13_1 - 1) * ProjectileImpactDataIndex.STRIDE
			local var_13_26 = arg_13_1[var_13_25 + var_13_3]
			local var_13_27 = arg_13_1[var_13_25 + var_13_4]:unbox()
			local var_13_28 = arg_13_1[var_13_25 + var_13_5]:unbox()
			local var_13_29 = arg_13_1[var_13_25 + var_13_6]:unbox()
			local var_13_30 = arg_13_1[var_13_25 + var_13_7]
			local var_13_31 = Unit.actor(var_13_26, var_13_30)
			local var_13_32 = arg_13_0:validate_position(var_13_27, var_13_14, var_13_15)

			if not var_13_32 then
				arg_13_0:stop()
			end

			local var_13_33, var_13_34 = ActionUtils.redirect_shield_hit(var_13_26, var_13_31)

			if not (var_13_33 == var_13_1) and var_13_32 and not var_13_8[var_13_33] then
				local var_13_35 = ScriptUnit.has_extension(var_13_1, "hud_system")

				if var_13_35 then
					var_13_35.show_critical_indication = false
				end

				local var_13_36 = arg_13_0._timed_data

				if var_13_36 and var_13_36.activate_life_time_on_impact then
					arg_13_0:_activate_life_time(arg_13_3)
				end

				local var_13_37 = AiUtils.unit_breed(var_13_33)

				if var_13_37 then
					local var_13_38 = var_0_8[var_13_33]

					if var_13_38 then
						local var_13_39 = Actor.node(var_13_34)
						local var_13_40 = var_13_37.hit_zones_lookup[var_13_39]

						if var_13_40 and var_13_40.name == var_13_38.name then
							var_13_8[var_13_33] = true
						else
							break
						end
					else
						break
					end
				else
					var_13_8[var_13_33] = true
				end

				local var_13_41, var_13_42 = var_13_11:game_object_or_level_id(var_13_33)

				if var_13_2 then
					if var_13_42 then
						var_13_12:send_rpc_clients("rpc_player_projectile_impact_level", var_13_13, var_13_41, var_13_27, var_13_28, var_13_29, var_13_30)
					elseif var_13_41 then
						var_13_12:send_rpc_clients("rpc_player_projectile_impact_dynamic", var_13_13, var_13_41, var_13_27, var_13_28, var_13_29, var_13_30)
					end
				elseif var_13_42 then
					var_13_12:send_rpc_server("rpc_player_projectile_impact_level", var_13_13, var_13_41, var_13_27, var_13_28, var_13_29, var_13_30)
				elseif var_13_41 then
					var_13_12:send_rpc_server("rpc_player_projectile_impact_dynamic", var_13_13, var_13_41, var_13_27, var_13_28, var_13_29, var_13_30)
				end

				local var_13_43 = Managers.state.side:is_enemy(var_13_1, var_13_33)
				local var_13_44, var_13_45 = ActionUtils.get_ranged_boost(var_13_1)

				if var_13_37 then
					if var_13_43 then
						arg_13_0:hit_enemy(var_13_10, var_13_33, var_13_27, var_13_28, var_13_29, var_13_34, var_13_37, var_13_44, var_13_45)

						break
					end

					if var_13_37.is_player then
						arg_13_0:hit_player(var_13_10, var_13_33, var_13_27, var_13_28, var_13_29, var_13_34, var_13_44, var_13_45)
					end

					break
				end

				if var_13_42 then
					arg_13_0:hit_level_unit(var_13_10, var_13_33, var_13_27, var_13_28, var_13_29, var_13_34, var_13_41, var_13_44, var_13_45)

					break
				end

				if not var_13_42 then
					arg_13_0:hit_non_level_unit(var_13_10, var_13_33, var_13_27, var_13_28, var_13_29, var_13_34, var_13_44, var_13_45)
				end
			end
		until true
	end
end

PlayerProjectileUnitExtension._activate_life_time = function (arg_14_0, arg_14_1)
	local var_14_0 = arg_14_0._timed_data
	local var_14_1 = var_14_0.life_time_activate_sound_start_event

	if var_14_1 then
		WwiseWorld.trigger_event(arg_14_0._wwise_world, var_14_1)
	end

	arg_14_0._life_time = arg_14_1 + var_14_0.life_time
end

PlayerProjectileUnitExtension.hit_enemy = function (arg_15_0, arg_15_1, arg_15_2, arg_15_3, arg_15_4, arg_15_5, arg_15_6, arg_15_7, arg_15_8, arg_15_9)
	local var_15_0 = false
	local var_15_1 = arg_15_1.damage_profile or "default"
	local var_15_2 = DamageProfileTemplates[var_15_1]
	local var_15_3 = true
	local var_15_4 = false
	local var_15_5 = arg_15_1.aoe

	arg_15_7 = AiUtils.unit_breed(arg_15_2)

	if not arg_15_7 then
		return
	end

	local var_15_6

	if var_15_2 then
		local var_15_7 = Actor.node(arg_15_6)

		var_15_6 = arg_15_7.hit_zones_lookup[var_15_7].name

		local var_15_8 = true
		local var_15_9 = var_15_2.charge_value or "projectile"
		local var_15_10 = arg_15_0._is_critical_strike
		local var_15_11 = arg_15_0._owner_unit
		local var_15_12 = arg_15_0._num_targets_hit + 1
		local var_15_13 = true

		if var_15_6 ~= "head" and HEALTH_ALIVE[arg_15_2] and arg_15_7 and arg_15_7.hit_zones and arg_15_7.hit_zones.head then
			local var_15_14 = ScriptUnit.has_extension(var_15_11, "buff_system")

			if var_15_14 and var_15_14:has_buff_perk("auto_headshot") and var_15_6 ~= "afro" then
				var_15_6 = "head"
				var_15_13 = false

				var_15_14:trigger_procs("on_auto_headshot")
			end
		end

		local var_15_15 = DamageUtils.get_item_buff_type(arg_15_0.item_name)

		DamageUtils.buff_on_attack(var_15_11, arg_15_2, var_15_9, var_15_10, var_15_6, var_15_12, var_15_8, var_15_15, var_15_13, arg_15_0.item_name)

		var_15_0, var_15_4 = arg_15_0:hit_enemy_damage(var_15_2, arg_15_2, arg_15_3, arg_15_4, arg_15_5, arg_15_6, arg_15_7, arg_15_8, arg_15_9)
		var_15_3 = var_15_6 ~= "ward"

		if var_15_3 and arg_15_7 and not var_15_0 then
			local var_15_16 = arg_15_1.pickup_settings

			if var_15_16 then
				var_15_3 = not not var_15_16.link_hit_zones[var_15_6]
			end
		end
	end

	if arg_15_0._num_additional_penetrations == 1 and var_15_5 and var_15_5.explosion then
		local var_15_17 = ScriptUnit.has_extension(arg_15_0._owner_unit, "talent_system")

		if var_15_17 and var_15_17:has_talent("bardin_engineer_ranged_pierce") then
			arg_15_0._num_additional_penetrations = arg_15_0._num_additional_penetrations - 1
		end
	end

	local var_15_18 = arg_15_1.grenade

	if arg_15_0._num_additional_penetrations == 0 then
		local var_15_19 = false

		if var_15_5 and (var_15_18 or arg_15_0._amount_of_mass_hit >= arg_15_0._max_mass) then
			arg_15_0:do_aoe(var_15_5, arg_15_3)

			if var_15_18 then
				local var_15_20 = arg_15_0._owner_unit
				local var_15_21 = ScriptUnit.has_extension(var_15_20, "buff_system")

				if var_15_21 then
					var_15_21:trigger_procs("on_grenade_exploded", arg_15_1, arg_15_3, arg_15_0._is_critical_strike, arg_15_0.item_name, Unit.local_rotation(arg_15_0._projectile_unit, 0), arg_15_0.scale, arg_15_0.power_level)
				end
			end

			var_15_19 = true
		end

		if arg_15_0.chain_hit_settings then
			local var_15_22 = Managers.time:time("game")
			local var_15_23 = Unit.has_node(arg_15_2, "j_spine") and Unit.world_position(arg_15_2, Unit.node(arg_15_2, "j_spine")) or POSITION_LOOKUP[arg_15_2] + Vector3(0, 0, 1.5)

			arg_15_0._weapon_system:try_fire_chained_projectile(arg_15_0.chain_hit_settings, arg_15_0.item_name, arg_15_0._is_critical_strike, arg_15_0.power_level, arg_15_9, var_15_22, arg_15_0._owner_unit, var_15_23, nil, arg_15_2, 1)

			var_15_19 = true
		end

		if var_15_19 then
			arg_15_0:stop(arg_15_2, var_15_6, arg_15_5)
		end
	end

	if arg_15_0._amount_of_mass_hit >= arg_15_0._max_mass then
		if arg_15_0._num_additional_penetrations > 0 then
			var_15_4 = true
		else
			local var_15_24 = true

			arg_15_0:_handle_linking(arg_15_1, arg_15_2, arg_15_3, arg_15_4, arg_15_5, arg_15_6, arg_15_0._did_damage, var_15_3, var_15_0, var_15_24)
			arg_15_0:stop(arg_15_2, var_15_6, arg_15_5)
		end
	end

	if arg_15_7.is_player or arg_15_7.play_ranged_hit_reacts then
		local var_15_25 = not arg_15_0._owner_player.local_player

		DamageUtils.add_hit_reaction(arg_15_2, arg_15_7, var_15_25, arg_15_4, false)
	end

	if arg_15_0.locomotion_extension.notify_hit_enemy then
		arg_15_0.locomotion_extension:notify_hit_enemy(arg_15_2)
	end

	if var_15_4 then
		arg_15_0._num_additional_penetrations = arg_15_0._num_additional_penetrations - 1
	end
end

PlayerProjectileUnitExtension.hit_enemy_damage = function (arg_16_0, arg_16_1, arg_16_2, arg_16_3, arg_16_4, arg_16_5, arg_16_6, arg_16_7, arg_16_8, arg_16_9)
	local var_16_0 = Managers.state.network
	local var_16_1 = arg_16_0._owner_player
	local var_16_2 = arg_16_0._owner_unit
	local var_16_3 = arg_16_0._current_action
	local var_16_4 = arg_16_0._is_server
	local var_16_5 = Actor.node(arg_16_6)
	local var_16_6 = arg_16_7.hit_zones_lookup[var_16_5]
	local var_16_7 = var_16_3.projectile_info.forced_hitzone or var_16_6.name
	local var_16_8 = arg_16_4
	local var_16_9 = false
	local var_16_10 = var_16_4 and HEALTH_ALIVE[arg_16_2] or AiUtils.client_predicted_unit_alive(arg_16_2)

	if var_16_10 then
		arg_16_0._num_targets_hit = arg_16_0._num_targets_hit + 1
	end

	if var_16_7 ~= "head" and HEALTH_ALIVE[arg_16_2] and arg_16_7 and arg_16_7.hit_zones and arg_16_7.hit_zones.head then
		local var_16_11 = ScriptUnit.has_extension(var_16_2, "buff_system")

		if var_16_11 and var_16_11:has_buff_perk("auto_headshot") and var_16_7 ~= "afro" then
			var_16_7 = "head"

			var_16_11:trigger_procs("on_auto_headshot")
		end
	end

	local var_16_12 = NetworkLookup.hit_zones[var_16_7]
	local var_16_13 = arg_16_0.power_level
	local var_16_14 = arg_16_0._is_critical_strike
	local var_16_15 = arg_16_1.default_target
	local var_16_16 = DamageUtils.get_attack_template(var_16_15.attack_template)
	local var_16_17 = var_16_0:unit_game_object_id(var_16_2)
	local var_16_18 = var_16_0:unit_game_object_id(arg_16_2)
	local var_16_19 = false
	local var_16_20 = var_16_15.trueflight_blocking

	if not var_16_3.ignore_shield_hit then
		var_16_19 = AiUtils.attack_is_shield_blocked(arg_16_2, var_16_2, var_16_20, arg_16_4)

		if var_16_19 and arg_16_7 and arg_16_7.blocking_hit_effect then
			EffectHelper.player_ranged_block_hit_particles(arg_16_0._world, arg_16_7.blocking_hit_effect, arg_16_3, arg_16_4, arg_16_2)
		end
	end

	arg_16_7 = AiUtils.unit_breed(arg_16_2)

	local var_16_21 = DamageUtils.get_breed_damage_multiplier_type(arg_16_7, var_16_7)

	if (var_16_21 == "headshot" or var_16_21 == "weakspot" and not var_16_19) and not var_16_3.no_headshot_sound and HEALTH_ALIVE[arg_16_2] then
		ScriptUnit.extension(var_16_2, "first_person_system"):play_hud_sound_event("Play_hud_headshot", nil, false)
	end

	if var_16_10 then
		local var_16_22 = var_16_3.hit_mass_count
		local var_16_23 = Managers.state.difficulty:get_difficulty_rank()
		local var_16_24 = var_16_19 and (arg_16_7.hit_mass_counts_block and (arg_16_7.hit_mass_counts_block[var_16_23] or arg_16_7.hit_mass_counts_block[2]) or arg_16_7.hit_mass_count_block) or arg_16_7.hit_mass_counts and (arg_16_7.hit_mass_counts[var_16_23] or arg_16_7.hit_mass_counts[2]) or arg_16_7.hit_mass_count or 1

		if var_16_22 and var_16_22[arg_16_7.name] then
			var_16_24 = var_16_24 * (var_16_22[arg_16_7.name] or 1)
		end

		arg_16_0._amount_of_mass_hit = arg_16_0._amount_of_mass_hit + var_16_24
	end

	local var_16_25 = math.ceil(arg_16_0._amount_of_mass_hit)
	local var_16_26 = var_16_3.hit_effect
	local var_16_27 = not var_16_1.local_player
	local var_16_28 = var_16_16.sound_type
	local var_16_29 = arg_16_7.name
	local var_16_30 = Quaternion.look(var_16_8, Vector3.up())
	local var_16_31 = arg_16_0.item_name
	local var_16_32 = NetworkLookup.damage_sources[var_16_31]
	local var_16_33 = arg_16_0._impact_damage_profile_id
	local var_16_34 = arg_16_0._weapon_system
	local var_16_35, var_16_36 = DamageUtils.calculate_damage(DamageOutput, arg_16_2, var_16_2, var_16_7, var_16_13, BoostCurves[var_16_15.boost_curve_type], arg_16_9, var_16_14, arg_16_1, var_16_25, nil, var_16_31)

	if not var_16_4 then
		local var_16_37 = Unit.alive(arg_16_2) and ScriptUnit.has_extension(arg_16_2, "health_system")

		if var_16_37 then
			local var_16_38 = DamageUtils.networkify_damage(var_16_35)

			var_16_37:apply_client_predicted_damage(var_16_38)
		end
	end

	var_16_34:send_rpc_attack_hit(var_16_32, var_16_17, var_16_18, var_16_12, arg_16_3, var_16_8, var_16_33, "power_level", var_16_13, "hit_target_index", var_16_25, "blocking", var_16_19, "shield_break_procced", false, "boost_curve_multiplier", arg_16_9, "is_critical_strike", var_16_14, "first_hit", arg_16_0._num_targets_hit == 1)

	local var_16_39 = var_16_35 <= 0

	if var_16_10 and var_16_39 then
		arg_16_0._did_damage = var_16_35

		if arg_16_0._num_additional_penetrations > 0 then
			var_16_9 = true
		else
			arg_16_0._amount_of_mass_hit = arg_16_0._max_mass

			arg_16_0:stop(arg_16_2, var_16_7, arg_16_5)
		end
	elseif var_16_10 and not var_16_3.ignore_armor and (arg_16_7.armor_category == 2 or arg_16_7.armor_category == 3 or var_16_19) then
		arg_16_0._did_damage = var_16_35

		if arg_16_0._num_additional_penetrations > 0 then
			var_16_9 = true
		else
			arg_16_0._amount_of_mass_hit = arg_16_0._max_mass

			arg_16_0:stop(arg_16_2, var_16_7, arg_16_5)
		end
	else
		arg_16_0._did_damage = var_16_35

		if var_16_7 == "head" or var_16_7 == "neck" then
			arg_16_0._did_damage = var_16_35 - 1
		end

		EffectHelper.player_critical_hit(arg_16_0._world, var_16_14, var_16_2, arg_16_2, arg_16_3)
	end

	if var_16_36 then
		var_16_26 = "invulnerable"

		DamageUtils.handle_hit_indication(var_16_2, arg_16_2, 0, var_16_7, false, true)
	end

	if var_16_26 then
		EffectHelper.play_skinned_surface_material_effects(var_16_26, arg_16_0._world, arg_16_2, arg_16_3, var_16_30, arg_16_5, var_16_27, var_16_29, var_16_28, var_16_39, var_16_7, var_16_19, arg_16_7)
	end

	if var_16_7 == "head" and not var_16_19 then
		local var_16_40 = ScriptUnit.extension(var_16_2, "buff_system")
		local var_16_41 = ScriptUnit.extension(var_16_2, "first_person_system")
		local var_16_42, var_16_43 = var_16_40:apply_buffs_to_value(0, "coop_stamina")

		if (var_16_43 or script_data.debug_legendary_traits) and HEALTH_ALIVE[arg_16_2] then
			local var_16_44 = arg_16_7.headshot_coop_stamina_fatigue_type or "headshot_clan_rat"
			local var_16_45 = NetworkLookup.fatigue_types[var_16_44]

			if var_16_4 then
				var_16_0.network_transmit:send_rpc_clients("rpc_replenish_fatigue_other_players", var_16_45)
			else
				var_16_0.network_transmit:send_rpc_server("rpc_replenish_fatigue_other_players", var_16_45)
			end

			StatusUtils.replenish_stamina_local_players(var_16_2, var_16_44)
			var_16_41:play_hud_sound_event("hud_player_buff_headshot", nil, false)
		end
	end

	return var_16_19, var_16_9
end

PlayerProjectileUnitExtension.hit_player = function (arg_17_0, arg_17_1, arg_17_2, arg_17_3, arg_17_4, arg_17_5, arg_17_6, arg_17_7, arg_17_8)
	local var_17_0 = Managers.state.difficulty:get_difficulty_settings()
	local var_17_1 = false
	local var_17_2 = false
	local var_17_3 = false
	local var_17_4 = false
	local var_17_5 = arg_17_0._owner_player
	local var_17_6 = arg_17_1.damage_profile or "default"
	local var_17_7 = DamageProfileTemplates[var_17_6]

	if var_17_7 and DamageUtils.allow_friendly_fire_ranged(var_17_0, var_17_5) then
		var_17_2 = arg_17_0:hit_player_damage(var_17_7, arg_17_2, arg_17_3, arg_17_4, arg_17_5, arg_17_6, arg_17_7, arg_17_8)
		var_17_1 = true
	end

	if var_17_1 then
		local var_17_8 = arg_17_1.aoe

		if var_17_8 and (arg_17_0._amount_of_mass_hit >= arg_17_0._max_mass or arg_17_0._stop_impacts) then
			arg_17_0:do_aoe(var_17_8, arg_17_3)

			if arg_17_1.grenade then
				local var_17_9 = arg_17_0._owner_unit
				local var_17_10 = ScriptUnit.has_extension(var_17_9, "buff_system")

				if var_17_10 then
					var_17_10:trigger_procs("on_grenade_exploded", arg_17_1, arg_17_3, arg_17_0._is_critical_strike, arg_17_0.item_name, Unit.local_rotation(arg_17_0._projectile_unit, 0), arg_17_0.scale, arg_17_0.power_level)
				end
			end

			arg_17_0:stop()
		end

		if not arg_17_1.no_stop_on_friendly_fire and arg_17_0._amount_of_mass_hit >= arg_17_0._max_mass then
			if arg_17_0._num_additional_penetrations > 0 then
				var_17_4 = true
			else
				local var_17_11 = true

				arg_17_0:_handle_linking(arg_17_1, arg_17_2, arg_17_3, arg_17_4, arg_17_5, arg_17_6, arg_17_0._did_damage, var_17_2, var_17_3, var_17_11)
				arg_17_0:stop()
			end
		end
	end

	if var_17_4 then
		arg_17_0._num_additional_penetrations = arg_17_0._num_additional_penetrations - 1
	end
end

PlayerProjectileUnitExtension.hit_player_damage = function (arg_18_0, arg_18_1, arg_18_2, arg_18_3, arg_18_4, arg_18_5, arg_18_6, arg_18_7, arg_18_8)
	local var_18_0 = arg_18_0._owner_unit
	local var_18_1 = Managers.state.network
	local var_18_2 = var_18_1:unit_game_object_id(var_18_0)
	local var_18_3 = var_18_1:unit_game_object_id(arg_18_2)
	local var_18_4 = arg_18_0._num_targets_hit + 1

	arg_18_0._num_targets_hit = var_18_4
	arg_18_0._amount_of_mass_hit = arg_18_0._amount_of_mass_hit + 1

	local var_18_5 = math.ceil(arg_18_0._amount_of_mass_hit)
	local var_18_6 = arg_18_1.default_target
	local var_18_7 = arg_18_0._current_action.hit_effect
	local var_18_8 = not arg_18_0._owner_player.local_player
	local var_18_9 = Quaternion.look(arg_18_4, Vector3.up())
	local var_18_10 = arg_18_0.item_name
	local var_18_11 = arg_18_0._impact_damage_profile_id
	local var_18_12 = arg_18_0.power_level
	local var_18_13 = AiUtils.unit_breed(arg_18_2)
	local var_18_14 = Actor.node(arg_18_6)
	local var_18_15 = var_18_13.hit_zones_lookup[var_18_14].name
	local var_18_16 = arg_18_0._is_critical_strike
	local var_18_17 = NetworkLookup.damage_sources[var_18_10]
	local var_18_18 = NetworkLookup.hit_zones[var_18_15]

	arg_18_0._weapon_system:send_rpc_attack_hit(var_18_17, var_18_2, var_18_3, var_18_18, arg_18_3, arg_18_4, var_18_11, "power_level", var_18_12, "hit_target_index", var_18_5, "blocking", false, "shield_break_procced", false, "boost_curve_multiplier", arg_18_8, "is_critical_strike", var_18_16, "first_hit", var_18_4 == 1)

	local var_18_19, var_18_20 = DamageUtils.calculate_damage(DamageOutput, arg_18_2, var_18_0, var_18_15, var_18_12, BoostCurves[var_18_6.boost_curve_type], arg_18_8, var_18_16, arg_18_1, var_18_5, nil, var_18_10)

	if var_18_19 <= 0 then
		arg_18_0._did_damage = false

		arg_18_0:stop()
	else
		arg_18_0._did_damage = var_18_19
	end

	if var_18_20 then
		var_18_7 = "invulnerable"

		DamageUtils.handle_hit_indication(var_18_0, arg_18_2, 0, var_18_15, false, true)
	end

	if var_18_7 then
		EffectHelper.play_skinned_surface_material_effects(var_18_7, arg_18_0._world, arg_18_2, arg_18_3, var_18_9, arg_18_5, var_18_8)
	end

	return false
end

PlayerProjectileUnitExtension.hit_level_unit = function (arg_19_0, arg_19_1, arg_19_2, arg_19_3, arg_19_4, arg_19_5, arg_19_6, arg_19_7, arg_19_8, arg_19_9)
	local var_19_0 = ScriptUnit.has_extension(arg_19_2, "health_system")
	local var_19_1 = arg_19_1.damage_profile_prop or arg_19_1.damage_profile or "default"
	local var_19_2 = DamageProfileTemplates[var_19_1]
	local var_19_3 = Unit.get_data(arg_19_2, "allow_ranged_damage") ~= false

	if var_19_2 and (GameSettingsDevelopment.allow_ranged_attacks_to_damage_props or var_19_3) then
		if var_19_0 then
			arg_19_0:hit_damagable_prop(var_19_2, arg_19_2, arg_19_3, arg_19_4, arg_19_5, arg_19_6, arg_19_7, arg_19_8, arg_19_9)
		elseif arg_19_2 and Unit.alive(arg_19_2) and arg_19_6 then
			local var_19_4 = Unit.set_flow_variable

			var_19_4(arg_19_2, "hit_actor", arg_19_6)
			var_19_4(arg_19_2, "hit_direction", arg_19_4)
			var_19_4(arg_19_2, "hit_position", arg_19_3)
			Unit.flow_event(arg_19_2, "lua_level_unit_hit_by_local_player_projectile")
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
		local var_19_14 = arg_19_1.max_bounces or 0
		local var_19_15 = arg_19_0.locomotion_extension
		local var_19_16 = var_19_14 + var_19_11

		if var_19_15.bounce and var_19_13 < var_19_16 then
			var_19_15:bounce(arg_19_3, arg_19_4, arg_19_5)

			arg_19_0._num_bounces = arg_19_0._num_bounces + 1
		else
			var_19_12 = true
		end
	end

	local var_19_17 = arg_19_1.aoe
	local var_19_18 = arg_19_1.aoe_on_bounce

	if var_19_17 and (not var_19_9 or var_19_12 or var_19_18) then
		arg_19_0:do_aoe(var_19_17, arg_19_3)

		if arg_19_1.grenade and var_19_10 then
			var_19_10:trigger_procs("on_grenade_exploded", arg_19_1, arg_19_3, arg_19_0._is_critical_strike, arg_19_0.item_name, Unit.local_rotation(arg_19_0._projectile_unit, 0), arg_19_0.scale, arg_19_0.power_level)
		end
	end

	if var_19_9 and not var_19_12 then
		return
	elseif arg_19_0._num_additional_penetrations == 0 or not var_19_0 or arg_19_1.grenade then
		arg_19_0:_handle_linking(arg_19_1, arg_19_2, arg_19_3, arg_19_4, arg_19_5, arg_19_6, false, true, false, false)
	end

	if var_19_0 and arg_19_0._num_additional_penetrations > 0 and not arg_19_1.grenade then
		arg_19_0._num_additional_penetrations = arg_19_0._num_additional_penetrations - 1
	else
		arg_19_0:stop(arg_19_2, nil, arg_19_5)
	end
end

PlayerProjectileUnitExtension.hit_damagable_prop = function (arg_20_0, arg_20_1, arg_20_2, arg_20_3, arg_20_4, arg_20_5, arg_20_6, arg_20_7, arg_20_8, arg_20_9)
	arg_20_0._amount_of_mass_hit = arg_20_0._amount_of_mass_hit + 1

	local var_20_0 = math.ceil(arg_20_0._amount_of_mass_hit)
	local var_20_1 = arg_20_0._owner_unit
	local var_20_2 = "full"
	local var_20_3 = arg_20_0.power_level
	local var_20_4 = arg_20_0._is_critical_strike
	local var_20_5 = arg_20_0.item_name

	DamageUtils.damage_level_unit(arg_20_2, var_20_1, var_20_2, var_20_3, arg_20_9, var_20_4, arg_20_1, var_20_0, arg_20_4, var_20_5)
end

PlayerProjectileUnitExtension.hit_non_level_unit = function (arg_21_0, arg_21_1, arg_21_2, arg_21_3, arg_21_4, arg_21_5, arg_21_6, arg_21_7, arg_21_8)
	local var_21_0 = arg_21_1.damage_profile_prop or arg_21_1.damage_profile or "default"
	local var_21_1 = DamageProfileTemplates[var_21_0]
	local var_21_2 = false

	if var_21_1 then
		if ScriptUnit.has_extension(arg_21_2, "health_system") then
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

	if arg_21_0._num_additional_penetrations == 0 then
		arg_21_0:_handle_linking(arg_21_1, arg_21_2, arg_21_3, arg_21_4, arg_21_5, arg_21_6, false, true, false, false)
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
			arg_21_0:stop(arg_21_2, nil, arg_21_5)
		end
	end
end

PlayerProjectileUnitExtension.hit_non_level_damagable_unit = function (arg_22_0, arg_22_1, arg_22_2, arg_22_3, arg_22_4, arg_22_5, arg_22_6, arg_22_7, arg_22_8)
	local var_22_0 = Managers.state.network
	local var_22_1 = "full"
	local var_22_2 = arg_22_0._owner_unit
	local var_22_3 = var_22_0:unit_game_object_id(var_22_2)
	local var_22_4 = var_22_0:unit_game_object_id(arg_22_2)
	local var_22_5 = NetworkLookup.hit_zones[var_22_1]
	local var_22_6 = arg_22_0.item_name
	local var_22_7 = NetworkLookup.damage_sources[var_22_6]
	local var_22_8 = arg_22_0._impact_damage_profile_id
	local var_22_9 = arg_22_0.power_level
	local var_22_10 = arg_22_0._is_critical_strike

	if not (Unit.get_data(arg_22_2, "allow_ranged_damage") ~= false) then
		return
	end

	arg_22_0._weapon_system:send_rpc_attack_hit(var_22_7, var_22_3, var_22_4, var_22_5, arg_22_3, arg_22_4, var_22_8, "power_level", var_22_9, "hit_target_index", nil, "blocking", false, "shield_break_procced", false, "boost_curve_multiplier", arg_22_8, "is_critical_strike", var_22_10)

	local var_22_11 = arg_22_0._current_action.hit_effect

	if var_22_11 then
		local var_22_12 = arg_22_0._world
		local var_22_13 = Quaternion.look(arg_22_4)
		local var_22_14 = not arg_22_0._owner_player.local_player

		EffectHelper.play_surface_material_effects(var_22_11, var_22_12, arg_22_2, arg_22_3, var_22_13, arg_22_5, nil, var_22_14, nil, arg_22_6)
	end
end

PlayerProjectileUnitExtension._get_projectile_units_names = function (arg_23_0, arg_23_1)
	local var_23_0 = arg_23_1.projectile_units_template

	if arg_23_1.use_weapon_skin then
		local var_23_1 = ScriptUnit.has_extension(arg_23_0._owner_unit, "inventory_system")

		if var_23_1 then
			local var_23_2 = "slot_ranged"
			local var_23_3 = var_23_1:get_slot_data(var_23_2)

			var_23_0 = var_23_3 and var_23_3.projectile_units_template or var_23_0
		end
	end

	return ProjectileUnits[var_23_0]
end

PlayerProjectileUnitExtension._get_weapon_unit = function (arg_24_0)
	local var_24_0 = ScriptUnit.has_extension(arg_24_0._owner_unit, "inventory_system")

	if var_24_0 then
		local var_24_1 = "slot_ranged"
		local var_24_2 = var_24_0:get_slot_data(var_24_1)
		local var_24_3 = var_24_2.right_unit_1p
		local var_24_4 = var_24_2.left_unit_1p

		return var_24_3 or var_24_4
	end
end

PlayerProjectileUnitExtension._handle_linking = function (arg_25_0, arg_25_1, arg_25_2, arg_25_3, arg_25_4, arg_25_5, arg_25_6, arg_25_7, arg_25_8, arg_25_9, arg_25_10)
	if not arg_25_1.link and not arg_25_1.link_pickup then
		return
	end

	local var_25_0 = arg_25_0.projectile_info
	local var_25_1 = arg_25_0:_get_projectile_units_names(var_25_0)
	local var_25_2 = var_25_1.dummy_linker_unit_name
	local var_25_3 = arg_25_1.depth or 0.15
	local var_25_4 = arg_25_1.depth_offset or 0.15

	if var_25_1.dummy_linker_broken_units then
		local var_25_5 = Math.random()

		if arg_25_7 and not arg_25_9 then
			var_25_5 = var_25_5 * math.clamp(arg_25_7 / 2, 0.75, 1.25)
		else
			var_25_5 = var_25_5 * 2
		end

		if var_25_5 <= 0.5 then
			local var_25_6 = #var_25_1.dummy_linker_broken_units
			local var_25_7 = Math.random(1, var_25_6)

			var_25_2 = var_25_1.dummy_linker_broken_units[var_25_7]

			if var_25_7 == 1 then
				var_25_3 = 0.05
				var_25_4 = 0.1
			else
				var_25_4 = 0.15
			end
		end
	elseif arg_25_7 and not arg_25_9 then
		local var_25_8 = arg_25_1.depth_damage_modifier_min or 1
		local var_25_9 = arg_25_1.depth_damage_modifier_max or 3

		var_25_3 = var_25_3 * math.clamp(arg_25_7, var_25_8, var_25_9)
	end

	if arg_25_9 then
		var_25_3 = -0.1
	end

	local var_25_10 = var_25_3 + var_25_4

	if arg_25_8 then
		local var_25_11 = Unit.get_data(arg_25_2, "allow_link")

		if var_25_11 ~= nil then
			arg_25_8 = var_25_11
		end
	end

	if arg_25_8 and arg_25_1.link then
		arg_25_0:_link_projectile(arg_25_2, arg_25_6, var_25_2, arg_25_3, arg_25_4, var_25_10, arg_25_9, arg_25_1.flow_event_on_init, arg_25_1.flow_event_on_walls)
	elseif arg_25_1.link_pickup then
		local var_25_12, var_25_13 = Managers.state.network:game_object_or_level_id(arg_25_2)

		if not var_25_12 and var_25_13 == nil then
			return
		end

		local var_25_14 = arg_25_1.pickup_settings
		local var_25_15

		if var_25_14.use_weapon_skin then
			local var_25_16 = ScriptUnit.has_extension(arg_25_0._owner_unit, "inventory_system")

			if var_25_16 then
				local var_25_17 = "slot_ranged"

				var_25_15 = var_25_16:get_slot_data(var_25_17)
			end
		end

		if arg_25_8 then
			local var_25_18 = var_25_15.link_pickup_template_name or var_25_14.link_pickup_name

			arg_25_0:_spawn_linked_pickup_projectile(var_25_18, arg_25_2, arg_25_6, arg_25_3, arg_25_4, arg_25_5, var_25_12, var_25_13, var_25_10, arg_25_9)
		else
			local var_25_19 = var_25_15.pickup_template_name or var_25_14.pickup_name

			arg_25_0:_spawn_pickup_projectile(var_25_19, arg_25_3, arg_25_4, arg_25_5, arg_25_10)
		end
	end
end

PlayerProjectileUnitExtension._redirect_shield_linking = function (arg_26_0, arg_26_1, arg_26_2, arg_26_3, arg_26_4)
	local var_26_0 = AiUtils.unit_breed(arg_26_1)

	if not (HEALTH_ALIVE[arg_26_1] and var_26_0 and not var_26_0.no_effects_on_shield_block and not var_26_0.is_player) then
		return arg_26_1, arg_26_2, arg_26_3
	end

	arg_26_1 = ScriptUnit.extension(arg_26_1, "ai_inventory_system").inventory_item_shield_unit

	local var_26_1 = Unit.node(arg_26_1, "c_mesh")
	local var_26_2 = var_0_1(arg_26_1, var_26_1) + arg_26_4
	local var_26_3 = arg_26_3 - var_26_2
	local var_26_4 = Vector3.length(var_26_3)

	arg_26_3 = var_26_2 + var_26_3 * math.min(var_26_4, 0.25)
	arg_26_2 = var_26_1

	return arg_26_1, arg_26_2, arg_26_3
end

PlayerProjectileUnitExtension._link_projectile = function (arg_27_0, arg_27_1, arg_27_2, arg_27_3, arg_27_4, arg_27_5, arg_27_6, arg_27_7, arg_27_8, arg_27_9)
	local var_27_0 = Managers.state.unit_spawner
	local var_27_1 = arg_27_0._projectile_linker_system
	local var_27_2 = Math.random() * 2.14 - 0.5
	local var_27_3 = Vector3.normalize(arg_27_5)
	local var_27_4 = var_27_3 * arg_27_6
	local var_27_5 = arg_27_4 + var_27_4
	local var_27_6 = Quaternion.multiply(Quaternion.look(var_27_3), Quaternion(Vector3.forward(), var_27_2))
	local var_27_7 = Actor.node(arg_27_2)

	if arg_27_7 then
		arg_27_1, var_27_7, var_27_5 = arg_27_0:_redirect_shield_linking(arg_27_1, var_27_7, var_27_5, var_27_4)
	end

	local var_27_8

	if ScriptUnit.has_extension(arg_27_1, "projectile_linker_system") then
		var_27_8 = var_27_0:spawn_local_unit(arg_27_3, var_27_5, var_27_6)

		local var_27_9 = var_0_0(arg_27_1, var_27_7)
		local var_27_10 = var_27_5 - var_0_1(arg_27_1, var_27_7)
		local var_27_11 = Vector3(Vector3.dot(Quaternion.right(var_27_9), var_27_10), Vector3.dot(var_0_2(var_27_9), var_27_10), Vector3.dot(Quaternion.up(var_27_9), var_27_10))
		local var_27_12 = Unit.has_data(arg_27_1, "breed")

		if arg_27_8 and var_27_12 then
			Unit.flow_event(var_27_8, arg_27_8)
		end

		ScriptUnit.extension(arg_27_1, "projectile_linker_system"):link_projectile(var_27_8, var_27_11, var_27_6, var_27_7)
		var_27_1:add_linked_projectile_reference(arg_27_1, var_27_8)
	else
		var_27_8 = var_27_0:spawn_local_unit(arg_27_3, var_27_5, var_27_6)

		var_27_1:add_linked_projectile_reference(arg_27_1, var_27_8)

		if arg_27_8 then
			Unit.flow_event(var_27_8, arg_27_8)
		end

		if arg_27_9 then
			Unit.flow_event(var_27_8, arg_27_9)
		end
	end

	if arg_27_0._material_settings_name then
		GearUtils.apply_material_settings(var_27_8, arg_27_0._material_settings_name)
	end
end

PlayerProjectileUnitExtension._spawn_linked_pickup_projectile = function (arg_28_0, arg_28_1, arg_28_2, arg_28_3, arg_28_4, arg_28_5, arg_28_6, arg_28_7, arg_28_8, arg_28_9, arg_28_10)
	local var_28_0 = Vector3.normalize(arg_28_5)
	local var_28_1 = var_28_0 * arg_28_9
	local var_28_2 = arg_28_4 + var_28_1
	local var_28_3 = Actor.node(arg_28_3)

	if arg_28_10 then
		arg_28_2, var_28_3, var_28_2 = arg_28_0:_redirect_shield_linking(arg_28_2, var_28_3, var_28_2, var_28_1)
	end

	local var_28_4 = 1
	local var_28_5 = arg_28_0:_get_weapon_unit()

	if var_28_5 then
		local var_28_6 = ScriptUnit.has_extension(var_28_5, "ammo_system")

		var_28_4 = var_28_6 and var_28_6:max_ammo()
	end

	local var_28_7 = Math.random_range(math.pi / 6, math.pi / 3)
	local var_28_8 = Math.random_range(-math.pi / 10, math.pi / 10)
	local var_28_9 = Vector3.normalize((var_28_0 - arg_28_6) * 0.5)
	local var_28_10 = Quaternion.look(var_28_9, Vector3.up())
	local var_28_11 = Quaternion.multiply(var_28_10, Quaternion(Vector3.forward(), var_28_8))
	local var_28_12 = Quaternion.multiply(var_28_11, Quaternion(Vector3.left(), var_28_7))
	local var_28_13 = NetworkLookup.pickup_names[arg_28_1]
	local var_28_14 = "dropped"
	local var_28_15 = NetworkLookup.pickup_spawn_types[var_28_14]
	local var_28_16 = NetworkLookup.material_settings_templates[arg_28_0._material_settings_name or "n/a"]

	Managers.state.network.network_transmit:send_rpc_server("rpc_spawn_linked_pickup", var_28_13, var_28_2, var_28_12, var_28_15, arg_28_7, var_28_3, arg_28_8, var_28_4, var_28_16)
end

PlayerProjectileUnitExtension._spawn_pickup_projectile = function (arg_29_0, arg_29_1, arg_29_2, arg_29_3, arg_29_4, arg_29_5)
	local var_29_0 = 1
	local var_29_1 = arg_29_0:_get_weapon_unit()

	if var_29_1 then
		local var_29_2 = ScriptUnit.has_extension(var_29_1, "ammo_system")

		var_29_0 = var_29_2 and var_29_2:max_ammo()
	end

	local var_29_3 = math.random(-math.half_pi, math.half_pi)
	local var_29_4 = arg_29_5 and arg_29_3 or Vector3.reflect(arg_29_3, arg_29_4)
	local var_29_5 = arg_29_2 + var_29_4 * 0.2
	local var_29_6 = Quaternion.axis_angle(var_29_4, var_29_3)
	local var_29_7 = NetworkLookup.pickup_names[arg_29_1]
	local var_29_8 = "dropped"
	local var_29_9 = NetworkLookup.pickup_spawn_types[var_29_8]
	local var_29_10 = AllPickups[arg_29_1]
	local var_29_11 = var_29_10.unit_name
	local var_29_12 = var_29_10.unit_template_name
	local var_29_13 = NetworkLookup.husks[var_29_11]
	local var_29_14 = NetworkLookup.go_types[var_29_12]
	local var_29_15 = var_29_4 * arg_29_0.locomotion_extension.speed * 0.001
	local var_29_16 = Unit.world_pose(arg_29_0._projectile_unit, 0)
	local var_29_17 = arg_29_0.projectile_info.bounce_angular_velocity
	local var_29_18 = Vector3(var_29_17[1], var_29_17[2], var_29_17[3])
	local var_29_19 = Matrix4x4.transform_without_translation(var_29_16, var_29_18)
	local var_29_20 = AiAnimUtils.position_network_scale(var_29_5, true)
	local var_29_21 = AiAnimUtils.rotation_network_scale(var_29_6, true)
	local var_29_22 = AiAnimUtils.velocity_network_scale(var_29_15, true)
	local var_29_23 = AiAnimUtils.velocity_network_scale(var_29_19, true)
	local var_29_24 = NetworkLookup.material_settings_templates[arg_29_0._material_settings_name or "n/a"]

	Managers.state.network.network_transmit:send_rpc_server("rpc_spawn_pickup_projectile", var_29_13, var_29_14, var_29_20, var_29_21, var_29_22, var_29_23, var_29_7, var_29_9, var_29_0, false, false, var_29_24)
end

PlayerProjectileUnitExtension.do_aoe = function (arg_30_0, arg_30_1, arg_30_2, arg_30_3)
	local var_30_0 = arg_30_0._world
	local var_30_1 = arg_30_0._projectile_unit
	local var_30_2 = arg_30_0._owner_unit
	local var_30_3 = arg_30_0.item_name
	local var_30_4 = arg_30_0._is_server
	local var_30_5 = var_30_2

	if arg_30_1.explosion then
		local var_30_6 = Unit.local_rotation(arg_30_0._projectile_unit, 0)
		local var_30_7 = arg_30_0.scale
		local var_30_8 = arg_30_0.power_level
		local var_30_9 = false

		if arg_30_3 then
			Managers.state.entity:system("area_damage_system"):create_explosion(var_30_2, arg_30_2, var_30_6, arg_30_1.name, var_30_7, var_30_3, var_30_8, arg_30_0._is_critical_strike, var_30_5)
		else
			DamageUtils.create_explosion(var_30_0, var_30_2, arg_30_2, var_30_6, arg_30_1, var_30_7, var_30_3, var_30_4, var_30_9, var_30_1, var_30_8, arg_30_0._is_critical_strike, var_30_5)
		end
	end

	if arg_30_1.spawn_unit then
		local var_30_10 = Managers.state.unit_storage:go_id(var_30_2)
		local var_30_11 = {
			darkness_system = {
				glow_time = arg_30_1.spawn_unit.glow_time,
				owner_unit_id = var_30_10,
				initial_position = arg_30_2
			}
		}
		local var_30_12 = arg_30_1.spawn_unit.unit_path
		local var_30_13 = arg_30_1.spawn_unit.unit_name

		Managers.state.unit_spawner:spawn_network_unit(var_30_12, var_30_13, var_30_11, arg_30_2)
	end

	if var_30_4 then
		if arg_30_1.aoe then
			DamageUtils.create_aoe(var_30_0, var_30_2, arg_30_2, var_30_3, arg_30_1)
		end

		if arg_30_1.taunt then
			DamageUtils.create_taunt(var_30_0, var_30_2, var_30_1, arg_30_2, arg_30_1)
		end
	end
end

PlayerProjectileUnitExtension.spawn_liquid_area = function (arg_31_0, arg_31_1, arg_31_2, arg_31_3, arg_31_4)
	local var_31_0 = arg_31_2
	local var_31_1 = arg_31_3
	local var_31_2 = math.floor(arg_31_0.scale * 30)
	local var_31_3 = {
		area_damage_system = {
			flow_dir = var_31_1,
			damage_table = arg_31_4.liquid_area.damage,
			liquid_template = arg_31_4.liquid_area.liquid_template,
			source_unit = arg_31_1,
			max_liquid = var_31_2
		}
	}
	local var_31_4 = "units/hub_elements/empty"
	local var_31_5 = Managers.state.unit_spawner:spawn_network_unit(var_31_4, "liquid_aoe_unit", var_31_3, var_31_0)

	ScriptUnit.extension(var_31_5, "area_damage_system"):ready()
end

PlayerProjectileUnitExtension.are_impacts_stopped = function (arg_32_0)
	return arg_32_0._stop_impacts
end

PlayerProjectileUnitExtension.trigger_external_event = function (arg_33_0, arg_33_1, arg_33_2)
	local var_33_0 = arg_33_0.projectile_info.external_events
	local var_33_1 = var_33_0 and var_33_0[arg_33_1]

	if var_33_1 then
		var_33_1(arg_33_0)

		if arg_33_2 then
			local var_33_2 = arg_33_0._is_server
			local var_33_3 = Managers.state.network
			local var_33_4 = var_33_3:unit_game_object_id(arg_33_0._projectile_unit)
			local var_33_5 = NetworkLookup.projectile_external_event[arg_33_1]

			if var_33_2 then
				var_33_3.network_transmit:send_rpc_clients("rpc_projectile_event", var_33_4, var_33_5)
			else
				var_33_3.network_transmit:send_rpc_server("rpc_projectile_event", var_33_4, var_33_5)
			end
		end
	end
end

PlayerProjectileUnitExtension.queue_delayed_external_event = function (arg_34_0, arg_34_1, arg_34_2, arg_34_3)
	if not arg_34_0._delayed_external_events then
		arg_34_0._delayed_external_events = {}
	end

	local var_34_0 = #arg_34_0._delayed_external_events

	arg_34_0._delayed_external_events[var_34_0 + 1] = {
		arg_34_2,
		arg_34_1,
		arg_34_3
	}
end

PlayerProjectileUnitExtension._update_delayed_external_event = function (arg_35_0, arg_35_1)
	local var_35_0 = arg_35_0._delayed_external_events
	local var_35_1 = #var_35_0

	for iter_35_0 = var_35_1, 1, -1 do
		local var_35_2 = var_35_0[iter_35_0]

		if arg_35_1 >= var_35_2[1] then
			arg_35_0:trigger_external_event(var_35_2[2], var_35_2[3])

			var_35_0[iter_35_0] = var_35_0[var_35_1]
			var_35_0[var_35_1] = nil
			var_35_1 = var_35_1 - 1
		end
	end

	if var_35_1 == 0 then
		arg_35_0._delayed_external_events = nil
	end
end
