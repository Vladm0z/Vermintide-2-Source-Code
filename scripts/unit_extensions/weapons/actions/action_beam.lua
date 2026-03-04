-- chunkname: @scripts/unit_extensions/weapons/actions/action_beam.lua

ActionBeam = class(ActionBeam, ActionBase)

ActionBeam.init = function (arg_1_0, arg_1_1, arg_1_2, arg_1_3, arg_1_4, arg_1_5, arg_1_6, arg_1_7, arg_1_8)
	ActionBeam.super.init(arg_1_0, arg_1_1, arg_1_2, arg_1_3, arg_1_4, arg_1_5, arg_1_6, arg_1_7, arg_1_8)

	if ScriptUnit.has_extension(arg_1_7, "ammo_system") then
		arg_1_0.ammo_extension = ScriptUnit.extension(arg_1_7, "ammo_system")
	end

	arg_1_0.inventory_extension = ScriptUnit.extension(arg_1_4, "inventory_system")
	arg_1_0.overcharge_extension = ScriptUnit.extension(arg_1_4, "overcharge_system")
	arg_1_0._rumble_effect_id = false
	arg_1_0.unit_id = Managers.state.network.unit_storage:go_id(arg_1_4)
end

ActionBeam.client_owner_start_action = function (arg_2_0, arg_2_1, arg_2_2, arg_2_3, arg_2_4)
	ActionBeam.super.client_owner_start_action(arg_2_0, arg_2_1, arg_2_2, arg_2_3, arg_2_4)

	arg_2_0.current_action = arg_2_1

	local var_2_0 = arg_2_0.owner_unit
	local var_2_1 = ScriptUnit.extension(var_2_0, "buff_system")

	arg_2_0.status_extension, arg_2_0.owner_buff_extension = ScriptUnit.extension(var_2_0, "status_system"), var_2_1
	arg_2_0.state = "waiting_to_shoot"
	arg_2_0.time_to_shoot = arg_2_2 + arg_2_1.fire_time
	arg_2_0.current_target = nil
	arg_2_0.damage_timer = 0
	arg_2_0.overcharge_timer = 0
	arg_2_0.ramping_interval = 1
	arg_2_0.consecutive_hits = 0
	arg_2_0.power_level = arg_2_4
	arg_2_0.do_zoom = arg_2_1.do_zoom
	arg_2_0.damage_interval = arg_2_1.damage_interval
	arg_2_0.charge_damage_profiles = arg_2_1.charge_damage_profiles
	arg_2_0.damage_profile = arg_2_1.damage_profile
	arg_2_0.charge_level = arg_2_3 and arg_2_3.charge_level or 0
	arg_2_0.power_level = arg_2_4 + arg_2_4 * arg_2_0.charge_level
	arg_2_0.damage_interval = arg_2_0.damage_interval - arg_2_0.damage_interval / 2 * arg_2_0.charge_level

	if arg_2_0.charge_damage_profiles then
		for iter_2_0 = 1, #arg_2_0.charge_damage_profiles do
			local var_2_2 = arg_2_0.charge_damage_profiles[iter_2_0]

			if arg_2_0.charge_level > var_2_2.threshold then
				arg_2_0.damage_profile = var_2_2.damage_profile
			end
		end
	end

	arg_2_0._is_critical_strike = false
	arg_2_0._num_hits = 0

	local var_2_3 = arg_2_1.particle_effect_trail
	local var_2_4 = arg_2_1.particle_effect_trail_3p
	local var_2_5 = arg_2_1.particle_effect_target
	local var_2_6 = NetworkLookup.effects[var_2_4]
	local var_2_7 = NetworkLookup.effects[var_2_5]
	local var_2_8 = arg_2_0.world

	if not arg_2_0.owner_player.bot_player then
		arg_2_0.beam_effect_id = World.create_particles(var_2_8, var_2_3, Vector3.zero())
		arg_2_0.beam_effect_length_id = World.find_particles_variable(var_2_8, var_2_3, "trail_length")
	end

	arg_2_0.beam_end_effect_id = World.create_particles(var_2_8, var_2_5, Vector3.zero())

	local var_2_9 = arg_2_0.unit_id

	if arg_2_0.is_server or LEVEL_EDITOR_TEST then
		if arg_2_0.owner_player.bot_player then
			arg_2_0.network_transmit:queue_local_rpc("rpc_start_beam", var_2_9, var_2_6, var_2_7, arg_2_1.range)
		else
			arg_2_0.network_transmit:send_rpc_clients("rpc_start_beam", var_2_9, var_2_6, var_2_7, arg_2_1.range)
		end
	else
		arg_2_0.network_transmit:send_rpc_server("rpc_start_beam", var_2_9, var_2_6, var_2_7, arg_2_1.range)
	end

	local var_2_10 = arg_2_1.overcharge_type

	if var_2_10 then
		local var_2_11 = PlayerUnitStatusSettings.overcharge_values[var_2_10]

		arg_2_0.overcharge_extension:add_charge(var_2_11)
	end

	arg_2_0.overcharge_target_hit = false

	arg_2_0:_start_charge_sound()
end

ActionBeam._start_charge_sound = function (arg_3_0)
	local var_3_0 = arg_3_0.current_action
	local var_3_1 = arg_3_0.owner_unit
	local var_3_2 = arg_3_0.owner_player
	local var_3_3 = var_3_2 and var_3_2.bot_player
	local var_3_4 = var_3_2 and not var_3_2.remote
	local var_3_5 = arg_3_0.wwise_world

	if var_3_4 and not var_3_3 then
		local var_3_6, var_3_7 = ActionUtils.start_charge_sound(var_3_5, arg_3_0.weapon_unit, var_3_1, var_3_0)

		arg_3_0.charging_sound_id = var_3_6
		arg_3_0.wwise_source_id = var_3_7
	end

	ActionUtils.play_husk_sound_event(var_3_5, var_3_0.charge_sound_husk_name, var_3_1, var_3_3)
end

ActionBeam._stop_charge_sound = function (arg_4_0)
	local var_4_0 = arg_4_0.current_action
	local var_4_1 = arg_4_0.owner_unit
	local var_4_2 = arg_4_0.owner_player
	local var_4_3 = var_4_2 and var_4_2.bot_player
	local var_4_4 = var_4_2 and not var_4_2.remote
	local var_4_5 = arg_4_0.wwise_world

	if var_4_4 and not var_4_3 then
		ActionUtils.stop_charge_sound(var_4_5, arg_4_0.charging_sound_id, arg_4_0.wwise_source_id, var_4_0)

		arg_4_0.charging_sound_id = nil
		arg_4_0.wwise_source_id = nil
	end

	ActionUtils.play_husk_sound_event(var_4_5, var_4_0.charge_sound_husk_stop_event, var_4_1, var_4_3)
end

local var_0_0 = 1
local var_0_1 = 4

ActionBeam.client_owner_post_update = function (arg_5_0, arg_5_1, arg_5_2, arg_5_3, arg_5_4)
	local var_5_0 = arg_5_0.owner_unit
	local var_5_1 = arg_5_0.current_action
	local var_5_2 = arg_5_0.is_server
	local var_5_3 = ScriptUnit.extension(arg_5_0.owner_unit, "input_system")
	local var_5_4 = arg_5_0.owner_buff_extension
	local var_5_5 = arg_5_0.status_extension

	if arg_5_0.do_zoom then
		if not var_5_5:is_zooming() then
			var_5_5:set_zooming(true)
		end

		if var_5_4:has_buff_type("increased_zoom") and var_5_5:is_zooming() and var_5_3:get("action_three") then
			var_5_5:switch_variable_zoom(var_5_1.buffed_zoom_thresholds)
		elseif var_5_1.zoom_thresholds and var_5_5:is_zooming() and var_5_3:get("action_three") then
			var_5_5:switch_variable_zoom(var_5_1.zoom_thresholds)
		end
	end

	if arg_5_0.state == "waiting_to_shoot" and arg_5_2 >= arg_5_0.time_to_shoot then
		arg_5_0.state = "shooting"
	end

	arg_5_0.overcharge_timer = arg_5_0.overcharge_timer + arg_5_1

	if arg_5_0.overcharge_timer >= var_5_1.overcharge_interval then
		local var_5_6 = PlayerUnitStatusSettings.overcharge_values.charging

		arg_5_0.overcharge_extension:add_charge(var_5_6)

		arg_5_0._is_critical_strike = ActionUtils.is_critical_strike(var_5_0, var_5_1, arg_5_2)
		arg_5_0.overcharge_timer = 0
		arg_5_0.overcharge_target_hit = false
	end

	if arg_5_0.state == "shooting" then
		if not Managers.player:owner(arg_5_0.owner_unit).bot_player and not arg_5_0._rumble_effect_id then
			arg_5_0._rumble_effect_id = Managers.state.controller_features:add_effect("persistent_rumble", {
				rumble_effect = "reload_start"
			})
		end

		local var_5_7 = ScriptUnit.extension(var_5_0, "first_person_system")
		local var_5_8, var_5_9 = var_5_7:get_projectile_start_position_rotation()
		local var_5_10 = Quaternion.forward(var_5_9)
		local var_5_11 = World.get_data(arg_5_0.world, "physics_world")
		local var_5_12 = var_5_1.range or 30
		local var_5_13 = PhysicsWorld.immediate_raycast_actors(var_5_11, var_5_8, var_5_10, var_5_12, "static_collision_filter", "filter_player_ray_projectile_static_only", "dynamic_collision_filter", "filter_player_ray_projectile_ai_only", "dynamic_collision_filter", "filter_player_ray_projectile_hitbox_only")
		local var_5_14 = var_5_8 + var_5_10 * var_5_12
		local var_5_15
		local var_5_16

		if var_5_13 then
			local var_5_17 = Managers.state.difficulty:get_difficulty_settings()
			local var_5_18 = arg_5_0.owner_player
			local var_5_19 = DamageUtils.allow_friendly_fire_ranged(var_5_17, var_5_18)

			for iter_5_0, iter_5_1 in pairs(var_5_13) do
				local var_5_20 = iter_5_1[var_0_0]
				local var_5_21 = iter_5_1[var_0_1]
				local var_5_22 = Actor.unit(var_5_21)
				local var_5_23, var_5_24 = ActionUtils.redirect_shield_hit(var_5_22, var_5_21)

				if var_5_23 ~= var_5_0 then
					local var_5_25 = Unit.get_data(var_5_23, "breed")
					local var_5_26

					if var_5_25 then
						local var_5_27 = DamageUtils.is_enemy(var_5_0, var_5_23)
						local var_5_28 = Actor.node(var_5_24)
						local var_5_29 = var_5_25.hit_zones_lookup[var_5_28].name

						var_5_26 = (var_5_19 and var_5_25.is_player or var_5_27) and var_5_29 ~= "afro"
					else
						var_5_26 = true
					end

					if var_5_26 then
						var_5_16 = var_5_20 - var_5_10 * 0.15
						var_5_15 = var_5_23

						break
					end
				end
			end

			if var_5_16 then
				var_5_14 = var_5_16
			end

			if var_5_15 then
				local var_5_30 = ScriptUnit.has_extension(var_5_15, "health_system")

				if var_5_30 then
					if var_5_15 ~= arg_5_0.current_target then
						arg_5_0.ramping_interval = 0.4
						arg_5_0.damage_timer = 0
						arg_5_0._num_hits = 0
					end

					if arg_5_0.damage_timer >= arg_5_0.damage_interval * arg_5_0.ramping_interval then
						Managers.state.entity:system("ai_system"):alert_enemies_within_range(var_5_0, POSITION_LOOKUP[var_5_0], 5)

						arg_5_0.damage_timer = 0
						arg_5_0.ramping_interval = math.clamp(arg_5_0.ramping_interval * 1.4, 0.45, 1.5)
					end

					if arg_5_0.damage_timer == 0 then
						local var_5_31 = arg_5_0._is_critical_strike
						local var_5_32 = ScriptUnit.has_extension(var_5_0, "hud_system")

						arg_5_0:_handle_critical_strike(var_5_31, var_5_4, var_5_32, var_5_7, "on_critical_shot", nil)

						if var_5_30 then
							local var_5_33 = arg_5_0.damage_profile
							local var_5_34 = arg_5_0.power_level * arg_5_0.ramping_interval

							if var_5_15 ~= arg_5_0.current_target then
								arg_5_0.consecutive_hits = 0
								var_5_34 = var_5_34 * 0.5
							else
								arg_5_0.consecutive_hits = arg_5_0.consecutive_hits + 1
							end

							if not arg_5_0.charge_damage_profiles and arg_5_0.consecutive_hits < 3 then
								var_5_33 = var_5_1.initial_damage_profile or var_5_1.damage_profile or "default"
							end

							var_5_7:play_hud_sound_event("staff_beam_hit_enemy", nil, false)

							local var_5_35 = arg_5_0._num_hits > 1

							DamageUtils.process_projectile_hit(arg_5_3, arg_5_0.item_name, var_5_0, var_5_2, var_5_13, var_5_1, var_5_10, var_5_35, nil, nil, arg_5_0._is_critical_strike, var_5_34, var_5_33)

							arg_5_0._num_hits = arg_5_0._num_hits + 1

							if not Managers.player:owner(arg_5_0.owner_unit).bot_player then
								Managers.state.controller_features:add_effect("rumble", {
									rumble_effect = "hit_character_light"
								})
							end

							if HEALTH_ALIVE[var_5_15] then
								local var_5_36 = PlayerUnitStatusSettings.overcharge_values[var_5_1.overcharge_type]

								if var_5_31 and var_5_4:has_buff_perk("no_overcharge_crit") then
									var_5_36 = 0
								end

								arg_5_0.overcharge_extension:add_charge(var_5_36 * arg_5_0.ramping_interval)
							end
						end
					end

					arg_5_0.damage_timer = arg_5_0.damage_timer + arg_5_1
					arg_5_0.current_target = var_5_15
				end
			end
		end

		if arg_5_0.beam_effect_id then
			local var_5_37 = arg_5_0.weapon_unit
			local var_5_38 = var_5_1.weapon_muzzle or Unit.node(var_5_37, "fx_muzzle")
			local var_5_39 = Unit.world_position(var_5_37, var_5_38)
			local var_5_40 = Vector3.distance(var_5_39, var_5_14)
			local var_5_41 = Vector3.normalize(var_5_39 - var_5_14)
			local var_5_42 = Quaternion.look(var_5_41)

			World.move_particles(arg_5_3, arg_5_0.beam_effect_id, var_5_14, var_5_42)
			World.set_particles_variable(arg_5_3, arg_5_0.beam_effect_id, arg_5_0.beam_effect_length_id, Vector3(0.3, var_5_40, 0))
			World.move_particles(arg_5_3, arg_5_0.beam_end_effect_id, var_5_14, var_5_42)
		end
	end
end

ActionBeam._stop_fx = function (arg_6_0)
	local var_6_0 = arg_6_0.world

	if arg_6_0.beam_end_effect_id then
		World.destroy_particles(var_6_0, arg_6_0.beam_end_effect_id)

		arg_6_0.beam_end_effect_id = nil
	end

	if arg_6_0.beam_effect_id then
		World.destroy_particles(var_6_0, arg_6_0.beam_effect_id)

		arg_6_0.beam_effect_id = nil
	end

	if arg_6_0._rumble_effect_id then
		Managers.state.controller_features:stop_effect(arg_6_0._rumble_effect_id)

		arg_6_0._rumble_effect_id = nil
	end

	arg_6_0:_stop_charge_sound()
end

ActionBeam._stop_client_vfx = function (arg_7_0)
	if Managers.state.network:game() then
		local var_7_0 = arg_7_0.unit_id

		if arg_7_0.is_server or LEVEL_EDITOR_TEST then
			if arg_7_0.owner_player.bot_player then
				arg_7_0.network_transmit:queue_local_rpc("rpc_end_beam", var_7_0)
			else
				arg_7_0.network_transmit:send_rpc_clients("rpc_end_beam", var_7_0)
			end
		else
			arg_7_0.network_transmit:send_rpc_server("rpc_end_beam", var_7_0)
		end
	end
end

ActionBeam.finish = function (arg_8_0, arg_8_1)
	if arg_8_0.do_zoom then
		arg_8_0.status_extension:set_zooming(false)
	end

	arg_8_0:_stop_client_vfx()
	arg_8_0:_stop_fx()
	arg_8_0:_proc_spell_used(arg_8_0.owner_buff_extension)

	return {
		beam_consecutive_hits = math.max(arg_8_0.consecutive_hits - 1, 0)
	}
end

ActionBeam.destroy = function (arg_9_0)
	arg_9_0:_stop_client_vfx()
	arg_9_0:_stop_fx()
end
