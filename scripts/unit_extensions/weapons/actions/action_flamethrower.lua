-- chunkname: @scripts/unit_extensions/weapons/actions/action_flamethrower.lua

ActionFlamethrower = class(ActionFlamethrower, ActionBase)

local var_0_0 = -1.5
local var_0_1 = math.abs(var_0_0) + 10
local var_0_2 = 2
local var_0_3 = 50
local var_0_4 = {
	"j_leftshoulder",
	"j_rightshoulder",
	"j_spine1"
}
local var_0_5 = #var_0_4

ActionFlamethrower.init = function (arg_1_0, arg_1_1, arg_1_2, arg_1_3, arg_1_4, arg_1_5, arg_1_6, arg_1_7, arg_1_8)
	ActionFlamethrower.super.init(arg_1_0, arg_1_1, arg_1_2, arg_1_3, arg_1_4, arg_1_5, arg_1_6, arg_1_7, arg_1_8)

	if ScriptUnit.has_extension(arg_1_7, "ammo_system") then
		arg_1_0.ammo_extension = ScriptUnit.extension(arg_1_7, "ammo_system")
	end

	arg_1_0.overcharge_extension = ScriptUnit.extension(arg_1_4, "overcharge_system")
	arg_1_0.buff_extension = ScriptUnit.extension(arg_1_4, "buff_system")
	arg_1_0.targets = {}
	arg_1_0.old_targets = {}
	arg_1_0.stop_sound_event = "Stop_player_combat_weapon_drakegun_flamethrower_shoot"
	arg_1_0.unit_id = Managers.state.network.unit_storage:go_id(arg_1_4)
end

ActionFlamethrower.client_owner_start_action = function (arg_2_0, arg_2_1, arg_2_2, arg_2_3, arg_2_4)
	ActionFlamethrower.super.client_owner_start_action(arg_2_0, arg_2_1, arg_2_2, arg_2_3, arg_2_4)

	arg_2_0.current_action = arg_2_1
	arg_2_0.power_level = arg_2_4
	arg_2_0.state = "waiting_to_shoot"
	arg_2_0.time_to_shoot = arg_2_2 + arg_2_1.fire_time
	arg_2_0.overcharge_timer = 0
	arg_2_0.damage_timer = 1
	arg_2_0.stop_sound_event = arg_2_1.stop_fire_event or arg_2_0.stop_sound_event
	arg_2_0.muzzle_node_name = arg_2_1.fx_node or "fx_muzzle"
	arg_2_0._fx_stopped = false
	arg_2_0.dot_check = arg_2_1.dot_check or 0.95
	arg_2_0.spray_range = arg_2_1.spray_range and math.abs(var_0_0) + arg_2_1.spray_range or var_0_1
	arg_2_0.charge_level = arg_2_3 and arg_2_3.charge_level or 1
	arg_2_0.max_flame_time = arg_2_1.fire_stop_time and arg_2_2 + arg_2_1.fire_stop_time or arg_2_2 + arg_2_0.charge_level * (arg_2_1.charge_fuel_time_multiplier or 3)

	if arg_2_0.buff_extension:has_buff_perk("full_charge_boost") and arg_2_0.charge_level >= 1 then
		arg_2_0.power_level = arg_2_0.buff_extension:apply_buffs_to_value(arg_2_0.power_level, "full_charge_boost")
	end

	if arg_2_3 and arg_2_3.charge_level and arg_2_0.charge_level and arg_2_0.charge_level >= 1 then
		arg_2_0.buff_extension:trigger_procs("on_full_charge_action", arg_2_1, arg_2_2, arg_2_3)
	end

	table.clear(arg_2_0.old_targets)
	table.clear(arg_2_0.targets)
end

local var_0_6 = 4

ActionFlamethrower.client_owner_post_update = function (arg_3_0, arg_3_1, arg_3_2, arg_3_3, arg_3_4)
	local var_3_0 = arg_3_0.owner_unit
	local var_3_1 = arg_3_0.first_person_unit
	local var_3_2 = arg_3_0.current_action
	local var_3_3 = arg_3_0.owner_player
	local var_3_4 = var_3_3.bot_player
	local var_3_5 = arg_3_0.network_transmit
	local var_3_6 = arg_3_0.is_server

	if arg_3_0.state == "waiting_to_shoot" and arg_3_2 >= arg_3_0.time_to_shoot then
		arg_3_0.state = "shooting"

		local var_3_7 = var_3_2.first_person_muzzle and var_3_1 or arg_3_0.weapon_unit
		local var_3_8 = arg_3_0.muzzle_node_name
		local var_3_9 = arg_3_0.unit_id
		local var_3_10 = Unit.node(var_3_7, var_3_8)
		local var_3_11 = Unit.world_position(var_3_7, var_3_10)
		local var_3_12 = Unit.world_rotation(var_3_7, var_3_10)
		local var_3_13 = var_3_2.particle_effect_flames
		local var_3_14 = var_3_2.particle_effect_flames_3p
		local var_3_15 = NetworkLookup.effects[var_3_14]

		if not var_3_4 then
			arg_3_0._flamethrower_effect = World.create_particles(arg_3_3, var_3_13, var_3_11, var_3_12)

			World.link_particles(arg_3_3, arg_3_0._flamethrower_effect, var_3_7, var_3_10, Matrix4x4.identity(), "destroy")
		end

		if not var_3_2.first_person_muzzle then
			if var_3_6 or LEVEL_EDITOR_TEST then
				if var_3_4 then
					var_3_5:send_rpc_all("rpc_start_flamethrower", var_3_9, var_3_15)
				else
					var_3_5:send_rpc_clients("rpc_start_flamethrower", var_3_9, var_3_15)
				end
			else
				var_3_5:send_rpc_server("rpc_start_flamethrower", var_3_9, var_3_15)
			end
		end

		if var_3_2.fire_sound_event then
			if arg_3_0._source_id then
				local var_3_16 = not arg_3_0.owner_player.local_player

				WwiseWorld.set_switch(arg_3_0.wwise_world, "husk", var_3_16 and "true" or "false", arg_3_0._source_id)
				WwiseWorld.trigger_event(arg_3_0.wwise_world, arg_3_0.stop_sound_event, arg_3_0._source_id)
			else
				arg_3_0._source_id = WwiseWorld.make_auto_source(arg_3_0.wwise_world, arg_3_0.weapon_unit)
			end

			local var_3_17 = not arg_3_0.owner_player.local_player

			WwiseWorld.set_switch(arg_3_0.wwise_world, "husk", var_3_17 and "true" or "false", arg_3_0._source_id)
			WwiseWorld.trigger_event(arg_3_0.wwise_world, var_3_2.fire_sound_event, arg_3_0._source_id)
		end
	end

	arg_3_0.overcharge_timer = arg_3_0.overcharge_timer + arg_3_1

	if arg_3_0.state == "shooting" and arg_3_0.overcharge_timer >= var_3_2.overcharge_interval then
		local var_3_18 = PlayerUnitStatusSettings.overcharge_values[var_3_2.overcharge_type]

		if arg_3_0.buff_extension then
			local var_3_19 = arg_3_0.buff_extension:has_buff_perk("no_overcharge_crit")

			if ActionUtils.is_critical_strike(var_3_0, var_3_2, arg_3_2) and var_3_19 then
				var_3_18 = 0
			end
		end

		arg_3_0.overcharge_extension:add_charge(var_3_18)

		arg_3_0.overcharge_timer = 0
	end

	if arg_3_0.state == "shooting" and arg_3_2 < arg_3_0.max_flame_time then
		local var_3_20 = ScriptUnit.extension(var_3_0, "first_person_system"):current_position()

		if not Managers.player:owner(var_3_0).bot_player and not arg_3_0._rumble_effect_id then
			arg_3_0._rumble_effect_id = Managers.state.controller_features:add_effect("persistent_rumble", {
				rumble_effect = "reload_start"
			})
		end

		local var_3_21 = var_3_2.damage_interval
		local var_3_22 = 0

		if var_3_21 then
			if arg_3_0.damage_timer >= var_3_2.damage_interval then
				arg_3_0.damage_timer = 0
			end

			if arg_3_0.damage_timer == 0 then
				arg_3_0:_check_critical_strike(arg_3_2)
				arg_3_0:_select_targets(arg_3_3, true)

				local var_3_23 = arg_3_0.targets
				local var_3_24 = true

				for iter_3_0 = 1, #var_3_23 do
					local var_3_25 = false
					local var_3_26 = var_3_23[iter_3_0]

					if Unit.alive(var_3_26) then
						local var_3_27 = Unit.get_data(var_3_26, "breed")
						local var_3_28 = "j_spine"

						if var_3_27 then
							var_3_22 = var_3_22 + 1

							local var_3_29 = math.round(Math.random_range(1, var_0_5))

							for iter_3_1 = 1, var_0_5 do
								local var_3_30 = math.index_wrapper(var_3_29 + iter_3_1 - 1, var_0_5)
								local var_3_31 = var_0_4[var_3_30]

								if Unit.has_node(var_3_26, var_3_31) then
									var_3_28 = var_3_31

									break
								end
							end
						end

						local var_3_32 = Unit.world_position(var_3_26, Unit.node(var_3_26, var_3_28))
						local var_3_33 = Vector3.normalize(var_3_32 - var_3_20)
						local var_3_34 = arg_3_0:raycast_to_target(arg_3_3, var_3_20, var_3_33, var_3_26)

						if var_3_34 then
							local var_3_35 = arg_3_0.power_level
							local var_3_36 = arg_3_0.old_targets and arg_3_0.old_targets[var_3_26]
							local var_3_37

							if var_3_36 then
								var_3_35 = var_3_35 * (math.clamp(var_3_36, 0, 4) * 0.5)

								if var_3_36 < 5 then
									var_3_37 = var_3_2.initial_damage_profile or var_3_2.damage_profile or "default"
								end
							else
								var_3_37 = var_3_2.initial_damage_profile or var_3_2.damage_profile or "default"
							end

							if DamageUtils.process_projectile_hit(arg_3_3, arg_3_0.item_name, var_3_0, var_3_6, var_3_34, var_3_2, var_3_33, var_3_24, var_3_26, nil, arg_3_0._is_critical_strike, var_3_35, var_3_37, var_3_22).buffs_checked then
								var_3_24 = var_3_24 and false
							end

							var_3_25 = true
						end
					end

					var_3_23[var_3_26] = var_3_25
				end

				local var_3_38 = var_3_2.spray_range or var_0_1
				local var_3_39 = World.get_data(arg_3_3, "physics_world")
				local var_3_40 = Unit.world_rotation(var_3_1, 0)
				local var_3_41 = Vector3.normalize(Quaternion.forward(var_3_40))
				local var_3_42 = PhysicsWorld.immediate_raycast_actors(var_3_39, var_3_20, var_3_41, var_3_38, "static_collision_filter", "filter_player_ray_projectile_static_only", "dynamic_collision_filter", "filter_player_ray_projectile_hitbox_only")
				local var_3_43

				if var_3_42 then
					local var_3_44 = Managers.state.difficulty:get_difficulty_settings()
					local var_3_45 = DamageUtils.allow_friendly_fire_ranged(var_3_44, var_3_3)
					local var_3_46 = Managers.state.side.side_by_unit[arg_3_0.owner_unit].PLAYER_AND_BOT_UNITS

					for iter_3_2, iter_3_3 in pairs(var_3_42) do
						local var_3_47 = iter_3_3[var_0_6]
						local var_3_48 = Actor.unit(var_3_47)
						local var_3_49 = var_3_43 and Unit.get_data(var_3_43, "breed")

						if var_3_48 ~= arg_3_0.owner_unit and not var_3_23[var_3_48] and not var_3_49 then
							if table.contains(var_3_46, var_3_48) then
								if var_3_45 then
									var_3_43 = var_3_48

									break
								end
							else
								var_3_43 = var_3_48

								break
							end
						end
					end

					if var_3_43 and var_3_42 then
						DamageUtils.process_projectile_hit(arg_3_3, arg_3_0.item_name, arg_3_0.owner_unit, var_3_6, var_3_42, var_3_2, var_3_41, var_3_24, var_3_43, nil, arg_3_0._is_critical_strike, arg_3_0.power_level)
					end
				end

				arg_3_0:_clear_targets()
			end

			arg_3_0.damage_timer = arg_3_0.damage_timer + arg_3_1
		end
	elseif arg_3_2 >= arg_3_0.max_flame_time and arg_3_0.state == "shooting" then
		arg_3_0.state = "shot"

		arg_3_0:_stop_fx()
		arg_3_0:_proc_spell_used(arg_3_0.buff_extension)
	end
end

ActionFlamethrower._stop_fx = function (arg_4_0)
	if arg_4_0._fx_stopped then
		return
	end

	if arg_4_0._flamethrower_effect then
		World.stop_spawning_particles(arg_4_0.world, arg_4_0._flamethrower_effect)

		arg_4_0._flamethrower_effect = nil
	end

	local var_4_0 = arg_4_0.unit_id

	if arg_4_0.is_server or LEVEL_EDITOR_TEST then
		if arg_4_0.owner_player.bot_player then
			arg_4_0.network_transmit:send_rpc_all("rpc_end_flamethrower", var_4_0)
		else
			arg_4_0.network_transmit:send_rpc_clients("rpc_end_flamethrower", var_4_0)
		end
	else
		arg_4_0.network_transmit:send_rpc_server("rpc_end_flamethrower", var_4_0)
	end

	local var_4_1 = arg_4_0._source_id

	if var_4_1 then
		local var_4_2 = not arg_4_0.owner_player.local_player

		WwiseWorld.set_switch(arg_4_0.wwise_world, "husk", var_4_2 and "true" or "false", var_4_1)
		WwiseWorld.trigger_event(arg_4_0.wwise_world, arg_4_0.stop_sound_event, var_4_1)

		arg_4_0._source_id = nil
	end

	local var_4_3 = ScriptUnit.has_extension(arg_4_0.owner_unit, "hud_system")

	if var_4_3 then
		var_4_3.show_critical_indication = false
	end

	if arg_4_0._rumble_effect_id then
		Managers.state.controller_features:stop_effect(arg_4_0._rumble_effect_id)

		arg_4_0._rumble_effect_id = nil
	end
end

ActionFlamethrower.finish = function (arg_5_0, arg_5_1)
	arg_5_0:_clear_targets()

	if arg_5_0.state ~= "shot" then
		arg_5_0:_proc_spell_used(arg_5_0.buff_extension)
	end

	arg_5_0:_stop_fx()
end

ActionFlamethrower.destroy = function (arg_6_0)
	if arg_6_0._flamethrower_effect then
		World.destroy_particles(arg_6_0.world, arg_6_0._flamethrower_effect)

		arg_6_0._flamethrower_effect = nil
	end
end

ActionFlamethrower._clear_targets = function (arg_7_0)
	local var_7_0 = arg_7_0.targets
	local var_7_1 = arg_7_0.old_targets
	local var_7_2 = {}

	for iter_7_0 = 1, #var_7_0 do
		local var_7_3 = var_7_1 and var_7_1[var_7_0[iter_7_0]] or 0

		var_7_2[var_7_0[iter_7_0]] = var_7_3 + 1
	end

	table.clear(arg_7_0.old_targets)
	table.clear(arg_7_0.targets)

	arg_7_0.old_targets = var_7_2
end

ActionFlamethrower._select_targets = function (arg_8_0, arg_8_1, arg_8_2)
	local var_8_0 = arg_8_0.owner_unit
	local var_8_1 = ScriptUnit.extension(var_8_0, "first_person_system")
	local var_8_2 = Vector3(0, 0, -0.4)
	local var_8_3 = var_8_1:current_position() + var_8_2
	local var_8_4 = arg_8_0.first_person_unit
	local var_8_5 = Unit.world_rotation(var_8_4, 0)
	local var_8_6 = Vector3.normalize(Quaternion.forward(var_8_5))
	local var_8_7 = not Managers.state.difficulty:get_difficulty_settings().friendly_fire_ranged
	local var_8_8 = var_8_3 + var_8_6 * var_0_0
	local var_8_9 = 6
	local var_8_10 = BLACKBOARDS[var_8_0].side
	local var_8_11 = {}
	local var_8_12 = AiUtils.broadphase_query(var_8_3 + var_8_6 * var_8_9, var_8_9, var_8_11)
	local var_8_13 = World.get_data(arg_8_1, "physics_world")

	PhysicsWorld.prepare_actors_for_overlap(var_8_13, var_8_8, var_0_1 * var_0_1)

	if var_8_12 > 0 then
		local var_8_14 = arg_8_0.targets
		local var_8_15, var_8_16, var_8_17 = Script.temp_count()
		local var_8_18 = 0

		for iter_8_0 = 1, var_8_12 do
			local var_8_19 = var_8_11[iter_8_0]
			local var_8_20 = POSITION_LOOKUP[var_8_19] + Vector3.up()

			if var_8_14[var_8_19] == nil then
				local var_8_21 = var_8_10.enemy_units_lookup[var_8_19]

				if (var_8_21 or not var_8_7) and arg_8_0:_is_infront_player(var_8_3, var_8_6, var_8_20) and arg_8_0:_check_within_cone(var_8_8, var_8_6, var_8_19, var_8_21) then
					var_8_14[#var_8_14 + 1] = var_8_19
					var_8_14[var_8_19] = false

					if var_8_21 and HEALTH_ALIVE[var_8_19] then
						var_8_18 = var_8_18 + 1
					end
				end

				if var_8_18 >= var_0_3 then
					break
				end
			end
		end

		Script.set_temp_count(var_8_15, var_8_16, var_8_17)
	end
end

ActionFlamethrower._check_within_cone = function (arg_9_0, arg_9_1, arg_9_2, arg_9_3, arg_9_4)
	local var_9_0 = Unit.world_position(arg_9_3, Unit.node(arg_9_3, "j_neck"))
	local var_9_1 = Vector3.normalize(var_9_0 - arg_9_1)

	if Vector3.dot(arg_9_2, var_9_1) >= (arg_9_4 and arg_9_0.dot_check or 0.99) then
		return true
	end

	return false
end

ActionFlamethrower._is_infront_player = function (arg_10_0, arg_10_1, arg_10_2, arg_10_3)
	local var_10_0 = Vector3.normalize(arg_10_3 - arg_10_1)

	if Vector3.dot(var_10_0, arg_10_2) > 0 then
		return true
	end
end

ActionFlamethrower.raycast_to_target = function (arg_11_0, arg_11_1, arg_11_2, arg_11_3, arg_11_4)
	local var_11_0 = World.get_data(arg_11_1, "physics_world")
	local var_11_1 = "filter_player_ray_projectile"

	return (PhysicsWorld.immediate_raycast(var_11_0, arg_11_2, arg_11_3, var_0_1, "all", "collision_filter", var_11_1))
end

ActionFlamethrower._check_critical_strike = function (arg_12_0, arg_12_1)
	local var_12_0 = arg_12_0.owner_unit
	local var_12_1 = arg_12_0.current_action
	local var_12_2 = ActionUtils.is_critical_strike(var_12_0, var_12_1, arg_12_1)
	local var_12_3 = ScriptUnit.has_extension(var_12_0, "hud_system")

	arg_12_0:_handle_critical_strike(var_12_2, arg_12_0.buff_extension, var_12_3, nil, "on_critical_shot", nil)

	arg_12_0._is_critical_strike = var_12_2
end
