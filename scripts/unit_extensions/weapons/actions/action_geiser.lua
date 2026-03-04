-- chunkname: @scripts/unit_extensions/weapons/actions/action_geiser.lua

ActionGeiser = class(ActionGeiser, ActionBase)

ActionGeiser.init = function (arg_1_0, arg_1_1, arg_1_2, arg_1_3, arg_1_4, arg_1_5, arg_1_6, arg_1_7, arg_1_8)
	ActionGeiser.super.init(arg_1_0, arg_1_1, arg_1_2, arg_1_3, arg_1_4, arg_1_5, arg_1_6, arg_1_7, arg_1_8)

	arg_1_0.overcharge_extension = ScriptUnit.extension(arg_1_4, "overcharge_system")
	arg_1_0._damage_buffer = {}
	arg_1_0._damage_buffer_index = 1
	arg_1_0._check_buffs = false
end

ActionGeiser.client_owner_start_action = function (arg_2_0, arg_2_1, arg_2_2, arg_2_3, arg_2_4)
	ActionGeiser.super.client_owner_start_action(arg_2_0, arg_2_1, arg_2_2, arg_2_3, arg_2_4)

	arg_2_0.current_action = arg_2_1

	local var_2_0 = arg_2_0.owner_unit
	local var_2_1 = ActionUtils.is_critical_strike(var_2_0, arg_2_1)
	local var_2_2 = ScriptUnit.extension(var_2_0, "buff_system")
	local var_2_3 = arg_2_3.charge_value

	arg_2_0.charge_value = var_2_3
	arg_2_0.power_level = ActionUtils.scale_geiser_power_level(arg_2_4, var_2_3)

	if var_2_2:has_buff_perk("full_charge_boost") and arg_2_0.charge_value >= 1 then
		arg_2_0.power_level = var_2_2:apply_buffs_to_value(arg_2_0.power_level, "full_charge_boost")
	end

	arg_2_0.owner_buff_extension = var_2_2
	arg_2_0.state = "waiting_to_shoot"
	arg_2_0.time_to_shoot = arg_2_2 + (arg_2_1.fire_time or 0)
	arg_2_0.radius = arg_2_3.radius
	arg_2_0.height = arg_2_3.height
	arg_2_0.position = arg_2_3.position

	table.clear(arg_2_0._damage_buffer)

	arg_2_0._damage_buffer_index = 1
	arg_2_0._check_buffs = true
	arg_2_0._is_critical_strike = var_2_1

	if arg_2_0.charge_value and arg_2_0.charge_value >= 1 then
		var_2_2:trigger_procs("on_full_charge_action", arg_2_1, arg_2_2, arg_2_3)
	end
end

ActionGeiser.client_owner_post_update = function (arg_3_0, arg_3_1, arg_3_2, arg_3_3, arg_3_4)
	local var_3_0 = arg_3_0.current_action

	if arg_3_0.state == "waiting_to_shoot" and arg_3_2 >= arg_3_0.time_to_shoot then
		arg_3_0.state = "shooting"
	end

	if arg_3_0.state == "shooting" then
		arg_3_0:fire()

		arg_3_0.state = "doing_damage"
	end

	if arg_3_0.state == "doing_damage" and arg_3_0:_update_damage(var_3_0) then
		arg_3_0:_proc_spell_used(arg_3_0.owner_buff_extension)

		arg_3_0.state = "shot"
	end
end

ActionGeiser.finish = function (arg_4_0, arg_4_1)
	if arg_4_0.state ~= "waiting_to_shoot" and arg_4_0.state ~= "shot" then
		arg_4_0:_proc_spell_used(arg_4_0.owner_buff_extension)
	end

	arg_4_0.position = nil

	local var_4_0 = ScriptUnit.has_extension(arg_4_0.owner_unit, "hud_system")

	if var_4_0 then
		var_4_0.show_critical_indication = false
	end
end

ActionGeiser.fire = function (arg_5_0, arg_5_1)
	local var_5_0 = arg_5_0.current_action
	local var_5_1 = arg_5_0.owner_unit
	local var_5_2 = arg_5_0.owner_player
	local var_5_3 = arg_5_0.radius
	local var_5_4 = arg_5_0.height * 0.5
	local var_5_5 = arg_5_0.position:unbox()
	local var_5_6 = World.get_data(arg_5_0.world, "physics_world")
	local var_5_7 = Managers.state.network
	local var_5_8 = var_5_5 + Vector3(0, 0, var_5_4)
	local var_5_9 = var_5_5
	local var_5_10 = var_5_4 + var_5_3
	local var_5_11 = var_5_10 - var_5_3 > 0 and "capsule" or "sphere"
	local var_5_12, var_5_13 = PhysicsWorld.immediate_overlap(var_5_6, "shape", var_5_11, "position", var_5_8, "size", Vector3(var_5_3, var_5_10, var_5_3), "rotation", Quaternion.look(Vector3.up(), Vector3.up()), "collision_filter", "filter_character_trigger")
	local var_5_14 = arg_5_0.charge_value
	local var_5_15 = var_5_0.particle_effect
	local var_5_16 = var_5_0.overcharge_type
	local var_5_17 = Managers.state.difficulty:get_difficulty_settings()
	local var_5_18 = not DamageUtils.allow_friendly_fire_ranged(var_5_17, var_5_2)
	local var_5_19 = var_5_0.small_charge_value or 0.33
	local var_5_20 = var_5_0.medium_charge_value or 0.66
	local var_5_21 = var_5_0.large_charge_value or 1
	local var_5_22 = not global_is_inside_inn or var_5_0.can_proc_in_inn
	local var_5_23 = "_large"

	if var_5_14 < var_5_19 then
		var_5_23 = "_small"
	elseif var_5_14 < var_5_20 then
		var_5_23 = "_medium"
	elseif var_5_21 <= var_5_14 and var_5_22 then
		var_5_23 = "_large"

		local var_5_24 = var_5_7:unit_game_object_id(var_5_1)
		local var_5_25 = NetworkLookup.damage_sources[arg_5_0.item_name]
		local var_5_26 = var_5_0.aoe_name
		local var_5_27 = NetworkLookup.explosion_templates[var_5_26]

		var_5_16 = var_5_0.overcharge_type_heavy

		arg_5_0.network_transmit:send_rpc_server("rpc_client_create_aoe", var_5_24, var_5_9, var_5_25, var_5_27, var_5_3)
	end

	if var_5_15 then
		local var_5_28 = var_5_15 .. var_5_23
		local var_5_29 = var_5_0.particle_radius_variable
		local var_5_30 = NetworkLookup.effects[var_5_28]
		local var_5_31 = NetworkLookup.effects[var_5_29]
		local var_5_32 = Vector3(var_5_3, 1, 1)

		arg_5_0.network_transmit:send_rpc_server("rpc_play_simple_particle_with_vector_variable", var_5_30, var_5_5, var_5_31, var_5_32)
	end

	if var_5_16 then
		local var_5_33 = PlayerUnitStatusSettings.overcharge_values[var_5_16]
		local var_5_34 = ScriptUnit.extension(var_5_1, "buff_system")

		if arg_5_0._is_critical_strike and var_5_34:has_buff_perk("no_overcharge_crit") then
			var_5_33 = 0
		end

		arg_5_0.overcharge_extension:add_charge(var_5_33, var_5_14, var_5_16)
	end

	local var_5_35 = arg_5_0.current_action.fire_sound_event

	if var_5_35 then
		local var_5_36 = arg_5_0.current_action.fire_sound_on_husk

		ScriptUnit.extension(var_5_1, "first_person_system"):play_hud_sound_event(var_5_35, nil, var_5_36)
	end

	local var_5_37 = arg_5_0._damage_buffer
	local var_5_38 = {}
	local var_5_39 = var_5_0.damage_profile or "default"
	local var_5_40 = DamageProfileTemplates[var_5_39]
	local var_5_41 = Managers.state.side
	local var_5_42 = var_5_41.side_by_unit[var_5_1]
	local var_5_43 = var_5_2 and var_5_2.player_unit

	if var_5_13 > 0 then
		local var_5_44 = 0

		for iter_5_0 = 1, var_5_13 do
			local var_5_45 = var_5_12[iter_5_0]
			local var_5_46 = Actor.unit(var_5_45)
			local var_5_47 = POSITION_LOOKUP[var_5_46] or Unit.local_position(var_5_46, 0)
			local var_5_48 = Unit.get_data(var_5_46, "breed")

			if not var_5_38[var_5_46] then
				local var_5_49 = var_5_41:is_enemy(var_5_1, var_5_46)
				local var_5_50 = var_5_42 == var_5_41.side_by_unit[var_5_46] and not var_5_18
				local var_5_51 = var_5_49 or var_5_50

				if not var_5_49 then
					local var_5_52 = var_5_48 and var_5_48.is_player
					local var_5_53 = var_5_48 and not var_5_52
					local var_5_54 = not var_5_49 and var_5_41:is_ally(var_5_1, var_5_46)

					if var_5_43 and var_5_53 and var_5_54 then
						var_5_51 = false
					end
				end

				if var_5_51 then
					local var_5_55 = var_5_47 - var_5_9
					local var_5_56 = Vector3.length(var_5_55)
					local var_5_57

					if var_5_40.target_radius and var_5_40.targets then
						local var_5_58 = var_5_56 / var_5_3

						if AiUtils.attack_is_shield_blocked(var_5_46, var_5_1) then
							var_5_58 = math.lerp(var_5_58, 1, 0.5)
						end

						for iter_5_1, iter_5_2 in pairs(var_5_40.target_radius) do
							if var_5_58 <= iter_5_2 then
								var_5_57 = iter_5_1

								break
							end
						end
					end

					var_5_38[var_5_46] = true

					if HEALTH_ALIVE[var_5_46] then
						var_5_44 = var_5_44 + 1
					end

					local var_5_59 = {
						hit_zone_name = "torso",
						hit_unit = var_5_46,
						damage_profile_name = var_5_39,
						target_index = var_5_57,
						allow_critical_proc = var_5_57 == 1,
						hit_index = var_5_44
					}

					var_5_37[#var_5_37 + 1] = var_5_59
				end
			end
		end
	end

	if var_5_0.alert_enemies then
		Managers.state.entity:system("ai_system"):alert_enemies_within_range(var_5_1, var_5_9, var_5_0.alert_sound_range_fire)
	end

	local var_5_60 = ScriptUnit.has_extension(var_5_1, "hud_system")

	arg_5_0:_handle_critical_strike(arg_5_0._is_critical_strike, arg_5_0.owner_buff_extension, var_5_60, nil, "on_critical_shot", nil)
end

local var_0_0 = 1

ActionGeiser._update_damage = function (arg_6_0, arg_6_1)
	local var_6_0 = arg_6_0._damage_buffer
	local var_6_1 = arg_6_0._damage_buffer_index
	local var_6_2 = var_6_1 + var_0_0 - 1
	local var_6_3 = Managers.state.network
	local var_6_4 = arg_6_0.owner_unit
	local var_6_5 = arg_6_0.item_name
	local var_6_6 = NetworkLookup.damage_sources[var_6_5]
	local var_6_7 = var_6_3:unit_game_object_id(var_6_4)
	local var_6_8 = arg_6_0.position:unbox()

	for iter_6_0 = var_6_1, var_6_2 do
		repeat
			local var_6_9 = var_6_0[iter_6_0]

			if not var_6_9 then
				return true
			end

			local var_6_10 = var_6_9.hit_unit
			local var_6_11 = var_6_9.damage_profile_name
			local var_6_12 = var_6_9.target_index
			local var_6_13 = var_6_9.hit_zone_name
			local var_6_14 = var_6_9.allow_critical_proc
			local var_6_15 = var_6_9.hit_index

			if not Unit.alive(var_6_10) then
				break
			end

			local var_6_16, var_6_17 = ActionUtils.get_ranged_boost(var_6_4)
			local var_6_18 = arg_6_0._is_critical_strike or var_6_16
			local var_6_19 = true
			local var_6_20 = DamageUtils.get_item_buff_type(arg_6_0.item_name)

			DamageUtils.buff_on_attack(var_6_4, var_6_10, "aoe", var_6_18 and var_6_14, var_6_13, var_6_15, var_6_19, var_6_20, nil, arg_6_0.item_name)

			local var_6_21 = var_6_3:unit_game_object_id(var_6_10)

			if not var_6_21 then
				break
			end

			local var_6_22 = NetworkLookup.hit_zones[var_6_13]
			local var_6_23 = NetworkLookup.damage_profiles[var_6_11]
			local var_6_24 = POSITION_LOOKUP[var_6_10] or Unit.local_position(var_6_10, 0)
			local var_6_25 = Vector3.normalize(var_6_24 - var_6_8)
			local var_6_26 = arg_6_0.power_level
			local var_6_27 = false
			local var_6_28 = false

			Managers.state.entity:system("weapon_system"):send_rpc_attack_hit(var_6_6, var_6_7, var_6_21, var_6_22, var_6_24, var_6_25, var_6_23, "power_level", var_6_26, "hit_target_index", var_6_12, "blocking", var_6_27, "shield_break_procced", var_6_28, "boost_curve_multiplier", var_6_17, "is_critical_strike", var_6_18)
		until true
	end

	arg_6_0._damage_buffer_index = var_6_2 + 1
end
