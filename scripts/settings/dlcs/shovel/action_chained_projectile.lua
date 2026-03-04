-- chunkname: @scripts/settings/dlcs/shovel/action_chained_projectile.lua

ActionChainedProjectile = class(ActionChainedProjectile, ActionBase)

ActionChainedProjectile.init = function (arg_1_0, arg_1_1, arg_1_2, arg_1_3, arg_1_4, arg_1_5, arg_1_6, arg_1_7, arg_1_8)
	ActionChainedProjectile.super.init(arg_1_0, arg_1_1, arg_1_2, arg_1_3, arg_1_4, arg_1_5, arg_1_6, arg_1_7, arg_1_8)

	arg_1_0.ammo_extension = ScriptUnit.has_extension(arg_1_7, "ammo_system")
	arg_1_0.inventory_extension = ScriptUnit.extension(arg_1_4, "inventory_system")
	arg_1_0.overcharge_extension = ScriptUnit.extension(arg_1_4, "overcharge_system")
	arg_1_0.first_person_extension = ScriptUnit.has_extension(arg_1_4, "first_person_system")
	arg_1_0.owner_buff_extension = ScriptUnit.extension(arg_1_4, "buff_system")
	arg_1_0.weapon_extension = ScriptUnit.extension(arg_1_7, "weapon_system")
	arg_1_0.status_extension = ScriptUnit.extension(arg_1_4, "status_system")
	arg_1_0.hud_extension = ScriptUnit.has_extension(arg_1_4, "hud_system")
	arg_1_0.owner_unit = arg_1_4

	if arg_1_0.first_person_extension then
		arg_1_0.first_person_unit = arg_1_0.first_person_extension:get_first_person_unit()
	end

	arg_1_0._rumble_effect_id = false
	arg_1_0.unit_id = Managers.state.network.unit_storage:go_id(arg_1_4)
	arg_1_0._audio_system = Managers.state.entity:system("audio_system")
	arg_1_0._active_projectiles = Script.new_array(4)
	arg_1_0._active_projectiles_n = 0
	arg_1_0.fx_spline_ids = {
		World.find_particles_variable(arg_1_1, "fx/wpnfx_staff_death/curse_spirit", "spline_1"),
		World.find_particles_variable(arg_1_1, "fx/wpnfx_staff_death/curse_spirit", "spline_2"),
		World.find_particles_variable(arg_1_1, "fx/wpnfx_staff_death/curse_spirit", "spline_3")
	}
end

local var_0_0 = 1
local var_0_1 = 2
local var_0_2 = 3
local var_0_3 = 4

ActionChainedProjectile.client_owner_start_action = function (arg_2_0, arg_2_1, arg_2_2, arg_2_3, arg_2_4)
	ActionChainedProjectile.super.client_owner_start_action(arg_2_0, arg_2_1, arg_2_2, arg_2_3, arg_2_4)

	arg_2_0._fire_t = arg_2_2 + arg_2_1.fire_time
	arg_2_0.state = "waiting_to_shoot"
	arg_2_0._power_level = arg_2_4
	arg_2_0._fire_sound_event = arg_2_1.fire_sound_event
	arg_2_0._chain_sound_event = arg_2_1.chain_sound_event
end

ActionChainedProjectile.client_owner_post_update = function (arg_3_0, arg_3_1, arg_3_2, arg_3_3, arg_3_4)
	if arg_3_0.state == "waiting_to_shoot" and arg_3_2 >= arg_3_0._fire_t then
		arg_3_0.state = "shooting"
	end

	if arg_3_0.state == "shooting" then
		arg_3_0.state = "shot"

		arg_3_0:_shoot(arg_3_2)
	end
end

ActionChainedProjectile.finish = function (arg_4_0, arg_4_1)
	ActionChainedProjectile.super.finish(arg_4_0, arg_4_1)
end

ActionChainedProjectile._shoot = function (arg_5_0, arg_5_1)
	local var_5_0 = 100
	local var_5_1 = 0.15
	local var_5_2 = arg_5_0.physics_world
	local var_5_3 = arg_5_0.owner_unit
	local var_5_4 = Managers.state.side
	local var_5_5 = var_5_4.side_by_unit
	local var_5_6 = var_5_5[var_5_3]
	local var_5_7, var_5_8 = arg_5_0.first_person_extension:get_projectile_start_position_rotation()
	local var_5_9 = Quaternion.forward(var_5_8)
	local var_5_10, var_5_11, var_5_12, var_5_13, var_5_14 = PhysicsWorld.immediate_raycast(var_5_2, var_5_7, var_5_9, var_5_0, "closest", "collision_filter", "filter_player_ray_projectile_static_only")
	local var_5_15 = var_5_12 or var_5_0
	local var_5_16 = var_5_7 + var_5_9 * var_5_15 / 2
	local var_5_17 = var_5_15 / 2

	PhysicsWorld.prepare_actors_for_overlap(var_5_2, var_5_16, var_5_17 * var_5_17)

	local var_5_18 = PhysicsWorld.linear_sphere_sweep(var_5_2, var_5_7 + var_5_9 * (var_5_1 / 2), var_5_7 + var_5_9 * var_5_15, var_5_1, 100, "types", "both", "collision_filter", "filter_player_ray_projectile", "report_initial_overlap")
	local var_5_19 = var_5_18 and #var_5_18 or 0
	local var_5_20

	for iter_5_0 = 1, var_5_19 do
		local var_5_21 = var_5_18[iter_5_0].actor

		if var_5_21 then
			local var_5_22 = Actor.unit(var_5_21)

			if ScriptUnit.has_extension(var_5_22, "health_system") then
				local var_5_23 = var_5_5[var_5_22]

				if not var_5_6 or not var_5_23 or var_5_4:is_enemy_by_side(var_5_6, var_5_23) then
					local var_5_24 = Actor.node(var_5_21)
					local var_5_25 = AiUtils.unit_breed(var_5_22)
					local var_5_26 = var_5_25 and var_5_25.hit_zones_lookup[var_5_24]

					if not var_5_26 or var_5_26.name ~= "afro" then
						var_5_20 = var_5_22

						break
					end
				end
			end
		end
	end

	local var_5_27
	local var_5_28 = var_5_7 + var_5_9 * var_5_15
	local var_5_29

	if var_5_20 then
		var_5_29 = var_5_20

		local var_5_30, var_5_31 = Managers.state.network:game_object_or_level_id(var_5_29)

		if not var_5_31 then
			local var_5_32 = Unit.has_node(var_5_20, "j_spine") and Unit.node(var_5_20, "j_spine") or 0

			var_5_28 = Unit.world_position(var_5_20, var_5_32)
		end
	elseif var_5_10 then
		local var_5_33 = Actor.unit(var_5_14)
		local var_5_34, var_5_35 = Managers.state.network:game_object_or_level_id(var_5_33)

		if not var_5_35 then
			var_5_29 = var_5_33
		end
	end

	if var_5_29 then
		local var_5_36 = arg_5_0.current_action.chain_hit_settings

		if Unit.get_data(var_5_29, "breed") then
			arg_5_0._is_critical_strike = ActionUtils.is_critical_strike(arg_5_0.owner_unit, arg_5_0.current_action, arg_5_1)

			arg_5_0:_handle_critical_strike(arg_5_0._is_critical_strike, arg_5_0.buff_extension, arg_5_0.hud_extension, nil, "on_critical_shot", nil)

			local var_5_37 = 1
			local var_5_38 = true
			local var_5_39 = DamageProfileTemplates[var_5_36.damage_profile].charge_value or "projectile"
			local var_5_40 = DamageUtils.get_item_buff_type(arg_5_0.item_name)

			DamageUtils.buff_on_attack(arg_5_0.owner_unit, var_5_29, var_5_39, arg_5_0._is_critical_strike, "full", var_5_37, var_5_38, var_5_40, nil, arg_5_0.item_name)
		else
			arg_5_0._is_critical_strike = false
		end

		local var_5_41 = arg_5_0._power_level
		local var_5_42, var_5_43 = ActionUtils.get_ranged_boost(var_5_3)
		local var_5_44 = arg_5_0._is_critical_strike
		local var_5_45 = arg_5_0._active_projectiles
		local var_5_46 = arg_5_0._active_projectiles_n + 1

		arg_5_0._active_projectiles_n = var_5_46
		var_5_45[var_5_46] = {
			chain_count = 0,
			settings = var_5_36,
			is_critical_strike = var_5_44,
			power_level = var_5_41,
			boost_curve_multiplier = var_5_43,
			next_chain_t = arg_5_1 + (var_5_36.chain_delay - var_5_36.target_selection_delay),
			target_selection_t = math.huge,
			next_target_unit = var_5_29,
			hit_units = {
				[var_5_29] = true
			},
			last_chain_pos = Vector3Box(var_5_28)
		}
	elseif var_5_13 then
		local var_5_47 = var_5_13
		local var_5_48 = Vector3.reflect(var_5_9, var_5_47)
		local var_5_49 = NetworkLookup.effects["fx/wpnfx_staff_death/curse_spirit_impact"]

		if arg_5_0.is_server then
			Managers.state.network:rpc_play_particle_effect(nil, var_5_49, NetworkConstants.invalid_game_object_id, 0, var_5_28, Quaternion.look(var_5_48), false)
		else
			Managers.state.network.network_transmit:send_rpc_server("rpc_play_particle_effect", var_5_49, NetworkConstants.invalid_game_object_id, 0, var_5_28, Quaternion.look(var_5_48), false)
		end
	end

	local var_5_50 = arg_5_0.current_action.start_offset
	local var_5_51 = Quaternion.rotate(var_5_8, Vector3(math.lerp(var_5_50.min[1], var_5_50.max[1], math.random()), math.lerp(var_5_50.min[2], var_5_50.max[2], math.random()), math.lerp(var_5_50.min[3], var_5_50.max[3], math.random())))
	local var_5_52 = arg_5_0.current_action.curve_offset
	local var_5_53 = Quaternion.rotate(var_5_8, Vector3(math.lerp(var_5_52.min[1], var_5_52.max[1], math.random()), math.lerp(var_5_52.min[2], var_5_52.max[2], math.random()), math.lerp(var_5_52.min[3], var_5_52.max[3], math.random())))
	local var_5_54 = Unit.node(arg_5_0.first_person_unit, "j_aim_target")
	local var_5_55 = Unit.world_position(arg_5_0.first_person_unit, var_5_54) + var_5_51
	local var_5_56 = var_5_55 + (var_5_28 - var_5_55) / 3 + var_5_53

	arg_5_0:_play_fx("fx/wpnfx_staff_death/curse_spirit_first", var_5_55, var_5_56, var_5_28, false)

	local var_5_57 = arg_5_0.current_action
	local var_5_58 = var_5_57.overcharge_type

	if var_5_58 and not arg_5_0.extra_buff_shot then
		local var_5_59 = PlayerUnitStatusSettings.overcharge_values[var_5_58]
		local var_5_60 = ScriptUnit.extension(var_5_3, "buff_system")

		if arg_5_0._is_critical_strike and var_5_60:has_buff_perk("no_overcharge_crit") then
			var_5_59 = 0
		end

		if var_5_57.scale_overcharge then
			arg_5_0.overcharge_extension:add_charge(var_5_59, arg_5_0.charge_level)
		else
			arg_5_0.overcharge_extension:add_charge(var_5_59)
		end
	end

	arg_5_0:_proc_spell_used(arg_5_0.owner_buff_extension)
end

ActionChainedProjectile._apply_damage = function (arg_6_0, arg_6_1, arg_6_2, arg_6_3, arg_6_4, arg_6_5, arg_6_6, arg_6_7)
	local var_6_0 = Managers.state.network
	local var_6_1 = var_6_0:unit_game_object_id(arg_6_0.owner_unit)

	arg_6_0:_handle_critical_strike(arg_6_3, arg_6_0.owner_buff_extension, arg_6_0.hud_extension, arg_6_0.first_person_extension, "on_critical_shot", nil)

	local var_6_2 = NetworkLookup.damage_profiles[arg_6_6]
	local var_6_3, var_6_4 = var_6_0:game_object_or_level_id(arg_6_1)
	local var_6_5 = NetworkLookup.damage_sources[arg_6_0.item_name]
	local var_6_6 = NetworkLookup.hit_zones.torso
	local var_6_7 = Unit.world_position(arg_6_1, 0) + Vector3.up()
	local var_6_8, var_6_9 = Vector3.direction_length(var_6_7 - arg_6_7)

	if var_6_4 then
		local var_6_10 = "full"
		local var_6_11 = 1
		local var_6_12 = arg_6_0.item_name
		local var_6_13 = DamageProfileTemplates[arg_6_6]

		DamageUtils.damage_level_unit(arg_6_1, arg_6_0.owner_unit, var_6_10, arg_6_4, arg_6_0.melee_boost_curve_multiplier, arg_6_3, var_6_13, var_6_11, var_6_8, var_6_12)
	else
		arg_6_0.weapon_system:send_rpc_attack_hit(var_6_5, var_6_1, var_6_3, var_6_6, var_6_7, var_6_8, var_6_2, "power_level", arg_6_4, "hit_target_index", arg_6_2, "blocking", false, "shield_break_procced", false, "boost_curve_multiplier", arg_6_5, "is_critical_strike", arg_6_3, "can_damage", true, "can_stagger", true, "first_hit", arg_6_2 == 1)
	end

	local var_6_14 = NetworkLookup.effects["fx/wpnfx_staff_death/curse_spirit_impact"]
	local var_6_15 = Quaternion.look(var_6_8)

	if arg_6_0.is_server then
		Managers.state.network:rpc_play_particle_effect(nil, var_6_14, NetworkConstants.invalid_game_object_id, 0, var_6_7, var_6_15, false)
	else
		Managers.state.network.network_transmit:send_rpc_server("rpc_play_particle_effect", var_6_14, NetworkConstants.invalid_game_object_id, 0, var_6_7, var_6_15, false)
	end

	Managers.state.entity:system("audio_system"):play_audio_unit_event("Play_career_necro_passive_shadow_blood", arg_6_1)
end

ActionChainedProjectile.destroy = function (arg_7_0)
	return
end

ActionChainedProjectile.passive_update = function (arg_8_0, arg_8_1, arg_8_2)
	if arg_8_0._active_projectiles_n <= 0 then
		return
	end

	local var_8_0 = arg_8_0.owner_unit
	local var_8_1 = Managers.state.entity:system("ai_system").broadphase
	local var_8_2 = Managers.state.side.side_by_unit[var_8_0]
	local var_8_3 = var_8_2 and var_8_2.enemy_broadphase_categories
	local var_8_4 = arg_8_0._active_projectiles

	for iter_8_0 = arg_8_0._active_projectiles_n, 1, -1 do
		local var_8_5 = var_8_4[iter_8_0]

		if not var_8_5.next_target_unit and arg_8_2 >= var_8_5.target_selection_t then
			if not arg_8_0:_select_next_target(var_8_5, var_8_1, var_8_3) then
				table.swap_delete(var_8_4, iter_8_0)

				arg_8_0._active_projectiles_n = arg_8_0._active_projectiles_n - 1
			end
		elseif arg_8_2 >= var_8_5.next_chain_t then
			if arg_8_0:_apply_chain_damage(var_8_5, var_8_1, var_8_3) then
				var_8_5.next_target_unit = nil
				var_8_5.next_chain_t = arg_8_2 + var_8_5.settings.chain_delay
				var_8_5.target_selection_t = arg_8_2 + var_8_5.settings.target_selection_delay
			else
				table.swap_delete(var_8_4, iter_8_0)

				arg_8_0._active_projectiles_n = arg_8_0._active_projectiles_n - 1
			end
		end
	end
end

local var_0_4 = {}

ActionChainedProjectile._select_next_target = function (arg_9_0, arg_9_1, arg_9_2, arg_9_3)
	local var_9_0 = arg_9_1.settings
	local var_9_1 = arg_9_1.hit_units
	local var_9_2 = arg_9_1.last_chain_pos:unbox()

	table.clear(var_0_4)

	local var_9_3 = var_0_4
	local var_9_4 = Broadphase.query(arg_9_2, var_9_2, var_9_0.chain_distance, var_9_3, arg_9_3)

	for iter_9_0 = 1, var_9_4 do
		local var_9_5 = var_9_3[iter_9_0]

		if not var_9_1[var_9_5] and HEALTH_ALIVE[var_9_5] then
			var_9_1[var_9_5] = true

			local var_9_6 = Unit.has_node(var_9_5, "j_spine") and Unit.node(var_9_5, "j_spine") or 0
			local var_9_7 = Unit.world_position(var_9_5, var_9_6)
			local var_9_8 = Vector3(math.lerp(-0.5, 0.5, math.random()), math.lerp(-0.5, 0.5, math.random()), math.lerp(-0.5, 0.5, math.random()))
			local var_9_9 = var_9_2 + (var_9_7 - var_9_2) / 2 + var_9_8

			arg_9_0:_play_fx("fx/wpnfx_staff_death/curse_spirit", var_9_2, var_9_9, var_9_7, true)

			arg_9_1.next_target_unit = var_9_5

			return true
		end
	end

	return false
end

ActionChainedProjectile._play_fx = function (arg_10_0, arg_10_1, arg_10_2, arg_10_3, arg_10_4, arg_10_5)
	local var_10_0 = NetworkLookup.effects[arg_10_1]
	local var_10_1 = {
		arg_10_2,
		arg_10_3,
		arg_10_4
	}

	if arg_10_5 then
		if arg_10_0._chain_sound_event then
			arg_10_0._audio_system:play_audio_position_event(arg_10_0._chain_sound_event, arg_10_2)
		end
	elseif arg_10_0._fire_sound_event and arg_10_0.first_person_extension then
		arg_10_0.first_person_extension:play_hud_sound_event(arg_10_0._fire_sound_event)
	end

	if arg_10_0.is_server then
		Managers.state.network:rpc_play_particle_effect_spline(nil, var_10_0, arg_10_0.fx_spline_ids, var_10_1)
	else
		Managers.state.network.network_transmit:send_rpc_server("rpc_play_particle_effect_spline", var_10_0, arg_10_0.fx_spline_ids, var_10_1)
	end
end

ActionChainedProjectile._apply_chain_damage = function (arg_11_0, arg_11_1, arg_11_2, arg_11_3)
	local var_11_0 = arg_11_1.settings
	local var_11_1 = arg_11_1.chain_count + 1
	local var_11_2 = arg_11_1.next_target_unit

	if HEALTH_ALIVE[var_11_2] then
		local var_11_3 = arg_11_1.last_chain_pos:unbox()

		arg_11_0:_apply_damage(var_11_2, var_11_1 + 1, arg_11_1.is_critical_strike, arg_11_1.power_level, arg_11_1.boost_curve_multiplier, var_11_0.damage_profile, var_11_3)
	end

	if ALIVE[var_11_2] and var_11_1 <= var_11_0.max_chain_count then
		local var_11_4

		if Unit.has_node(var_11_2, "j_spine") then
			local var_11_5 = Unit.node(var_11_2, "j_spine")

			var_11_4 = Unit.world_position(var_11_2, var_11_5)
		else
			var_11_4 = Unit.world_position(var_11_2, 0) + Vector3.up() * 0.8
		end

		arg_11_1.chain_count = var_11_1

		arg_11_1.last_chain_pos:store(var_11_4)

		return true
	else
		return false
	end
end
