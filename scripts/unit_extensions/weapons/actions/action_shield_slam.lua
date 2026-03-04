-- chunkname: @scripts/unit_extensions/weapons/actions/action_shield_slam.lua

ActionShieldSlam = class(ActionShieldSlam, ActionBase)

local var_0_0 = POSITION_LOOKUP

ActionShieldSlam.init = function (arg_1_0, arg_1_1, arg_1_2, arg_1_3, arg_1_4, arg_1_5, arg_1_6, arg_1_7, arg_1_8)
	ActionShieldSlam.super.init(arg_1_0, arg_1_1, arg_1_2, arg_1_3, arg_1_4, arg_1_5, arg_1_6, arg_1_7, arg_1_8)

	if ScriptUnit.has_extension(arg_1_7, "ammo_system") then
		arg_1_0.ammo_extension = ScriptUnit.extension(arg_1_7, "ammo_system")
	end

	arg_1_0.overcharge_extension = ScriptUnit.extension(arg_1_4, "overcharge_system")
	arg_1_0.status_extension = ScriptUnit.extension(arg_1_4, "status_system")
	arg_1_0.hit_units = {}
	arg_1_0.inner_hit_units = {}
	arg_1_0.target_hit_zones_names = {}
	arg_1_0.target_hit_unit_positions = {}
end

ActionShieldSlam.client_owner_start_action = function (arg_2_0, arg_2_1, arg_2_2, arg_2_3, arg_2_4, arg_2_5)
	ActionShieldSlam.super.client_owner_start_action(arg_2_0, arg_2_1, arg_2_2, arg_2_3, arg_2_4, arg_2_5)

	arg_2_0.current_action = arg_2_1
	arg_2_0.target_breed_unit = nil

	local var_2_0 = arg_2_0.owner_unit
	local var_2_1 = arg_2_0.first_person_unit
	local var_2_2 = ScriptUnit.extension(var_2_0, "buff_system")
	local var_2_3 = ScriptUnit.extension(var_2_0, "career_system")

	arg_2_0.owner_career_extension = var_2_3
	arg_2_0.owner_buff_extension = var_2_2

	local var_2_4, var_2_5 = var_2_3:has_melee_boost()
	local var_2_6 = ActionUtils.is_critical_strike(var_2_0, arg_2_1, arg_2_2)

	arg_2_0.melee_boost_curve_multiplier = var_2_5
	arg_2_0.power_level = arg_2_4

	if not Managers.player:owner(var_2_0).bot_player then
		Managers.state.controller_features:add_effect("rumble", {
			rumble_effect = "light_swing"
		})
	end

	local var_2_7 = arg_2_5 and arg_2_5.action_hand
	local var_2_8 = var_2_7 and arg_2_1["damage_profile_" .. var_2_7] or arg_2_1.damage_profile or "default"

	arg_2_0.damage_profile_id = NetworkLookup.damage_profiles[var_2_8]
	arg_2_0.damage_profile = DamageProfileTemplates[var_2_8]

	local var_2_9 = var_2_7 and arg_2_1["damage_profile_aoe_" .. var_2_7] or arg_2_1.damage_profile_aoe or "default"

	arg_2_0.damage_profile_aoe_id = NetworkLookup.damage_profiles[var_2_9]
	arg_2_0.damage_profile_aoe = DamageProfileTemplates[var_2_9]

	local var_2_10 = var_2_7 and arg_2_1["damage_profile_target" .. var_2_7] or arg_2_1.damage_profile_target or "default"

	arg_2_0.damage_profile_target_id = NetworkLookup.damage_profiles[var_2_10]
	arg_2_0.damage_profile_target = DamageProfileTemplates[var_2_10]

	local var_2_11 = arg_2_0.ammo_extension

	if var_2_11 and var_2_11:is_reloading() then
		var_2_11:abort_reload()
	end

	local var_2_12 = ScriptUnit.has_extension(var_2_0, "hud_system")
	local var_2_13 = ScriptUnit.extension(var_2_0, "first_person_system")

	arg_2_0:_handle_critical_strike(var_2_6, var_2_2, var_2_12, var_2_13, "on_critical_sweep", "Play_player_combat_crit_swing_2D")

	arg_2_0._is_critical_strike = var_2_6

	Unit.flow_event(var_2_1, "sfx_swing_started")
	var_2_13:disable_rig_movement()

	local var_2_14 = World.get_data(arg_2_0.world, "physics_world")
	local var_2_15 = var_2_13:current_position()
	local var_2_16 = var_2_13:current_rotation()
	local var_2_17 = Quaternion.forward(var_2_16)
	local var_2_18 = Managers.state.difficulty:get_difficulty_settings()
	local var_2_19 = Managers.player:owner(var_2_0)
	local var_2_20 = DamageUtils.allow_friendly_fire_melee(var_2_18, var_2_19)
	local var_2_21 = var_2_20 and "filter_melee_sweep" or "filter_melee_sweep_no_player"
	local var_2_22 = PhysicsWorld.immediate_raycast(var_2_14, var_2_15, var_2_17, arg_2_1.dedicated_target_range, "all", "collision_filter", var_2_21)

	if var_2_22 then
		local var_2_23 = Managers.state.side
		local var_2_24 = #var_2_22

		for iter_2_0 = 1, var_2_24 do
			local var_2_25 = var_2_22[iter_2_0][4]
			local var_2_26 = Actor.unit(var_2_25)

			if not var_2_20 and var_2_23:is_ally(var_2_0, var_2_26) then
				-- Nothing
			else
				local var_2_27 = Unit.get_data(var_2_26, "breed")

				if var_2_27 then
					local var_2_28 = Actor.node(var_2_25)

					if var_2_27.hit_zones_lookup[var_2_28].name ~= "afro" and HEALTH_ALIVE[var_2_26] then
						arg_2_0.target_breed_unit = var_2_26

						break
					end
				end
			end
		end
	end

	if not arg_2_0.target_breed_unit and ScriptUnit.has_extension(var_2_0, "smart_targeting_system") then
		local var_2_29 = ScriptUnit.extension(var_2_0, "smart_targeting_system"):get_targeting_data().unit

		if HEALTH_ALIVE[var_2_29] then
			local var_2_30 = Unit.has_node(var_2_29, "j_spine") and Unit.world_position(var_2_29, Unit.node(var_2_29, "j_spine"))
			local var_2_31 = var_0_0[var_2_29] or Unit.world_position(var_2_29, 0)
			local var_2_32 = var_2_30 or var_2_31
			local var_2_33 = Vector3.length(var_2_15 - var_2_32)

			if HEALTH_ALIVE[var_2_29] and var_2_33 < arg_2_1.dedicated_target_range then
				arg_2_0.target_breed_unit = var_2_29
			end
		end
	end

	arg_2_0.state = "waiting_to_hit"

	local var_2_34 = ActionUtils.get_action_time_scale(var_2_0, arg_2_1)

	arg_2_0.time_to_hit = arg_2_2 + (arg_2_1.hit_time or 0) / var_2_34

	table.clear(arg_2_0.hit_units)
	table.clear(arg_2_0.inner_hit_units)
	table.clear(arg_2_0.target_hit_zones_names)
	table.clear(arg_2_0.target_hit_unit_positions)

	local var_2_35 = arg_2_0.current_action.overcharge_type

	if var_2_35 then
		local var_2_36 = PlayerUnitStatusSettings.overcharge_values[var_2_35]

		arg_2_0.overcharge_extension:add_charge(var_2_36)
	end

	arg_2_0._num_targets_hit = 0
end

ActionShieldSlam.client_owner_post_update = function (arg_3_0, arg_3_1, arg_3_2, arg_3_3, arg_3_4)
	local var_3_0 = arg_3_0.current_action
	local var_3_1 = arg_3_0.owner_unit

	if arg_3_0.state == "waiting_to_hit" and arg_3_2 >= arg_3_0.time_to_hit then
		arg_3_0.state = "hitting"
	end

	if arg_3_0.state == "hitting" then
		arg_3_0:_hit(arg_3_3, arg_3_4, var_3_1, var_3_0)

		if not Managers.player:owner(arg_3_0.owner_unit).bot_player then
			Managers.state.controller_features:add_effect("rumble", {
				rumble_effect = "hit_character_light"
			})
		end
	end
end

ActionShieldSlam._hit = function (arg_4_0, arg_4_1, arg_4_2, arg_4_3, arg_4_4)
	local var_4_0 = Managers.state.network
	local var_4_1 = World.get_data(arg_4_1, "physics_world")
	local var_4_2 = var_4_0:unit_game_object_id(arg_4_3)
	local var_4_3 = arg_4_0.first_person_unit
	local var_4_4 = Quaternion.forward(Unit.local_rotation(var_4_3, 0))
	local var_4_5 = ScriptUnit.extension(arg_4_3, "first_person_system"):current_position()
	local var_4_6 = arg_4_4.forward_offset or 1
	local var_4_7 = var_4_5 + var_4_4 * var_4_6
	local var_4_8 = arg_4_4.push_radius
	local var_4_9 = "filter_melee_sweep"
	local var_4_10, var_4_11 = PhysicsWorld.immediate_overlap(var_4_1, "shape", "sphere", "position", var_4_7, "size", var_4_8, "types", "dynamics", "collision_filter", var_4_9)
	local var_4_12 = var_4_5 + var_4_4 * (var_4_6 + var_4_8 * 0.65)
	local var_4_13 = var_4_5 + var_4_4
	local var_4_14 = arg_4_4.inner_push_radius or var_4_8 * 0.4
	local var_4_15 = var_4_14 * var_4_14
	local var_4_16 = arg_4_0.inner_hit_units
	local var_4_17 = arg_4_0.hit_units
	local var_4_18 = Unit.get_data

	if script_data.debug_weapons then
		arg_4_0._drawer:sphere(var_4_7, var_4_8, Color(255, 0, 0))
		arg_4_0._drawer:sphere(var_4_13, var_4_14, Color(0, 255, 0))
		arg_4_0._drawer:sphere(var_4_12, var_4_14, Color(0, 255, 0))
	end

	local var_4_19 = arg_4_0.target_breed_unit

	if not HEALTH_ALIVE[var_4_19] then
		var_4_19 = nil
	end

	local var_4_20 = Managers.state.side

	for iter_4_0 = 1, var_4_11 do
		repeat
			local var_4_21 = var_4_10[iter_4_0]
			local var_4_22 = Actor.unit(var_4_21)

			if var_4_17[var_4_22] then
				break
			end

			var_4_17[var_4_22] = true

			if var_4_20:is_ally(arg_4_3, var_4_22) then
				break
			end

			local var_4_23 = var_4_18(var_4_22, "breed")
			local var_4_24 = var_4_22 == arg_4_3

			if var_4_23 then
				if var_4_22 == var_4_19 then
					break
				end

				local var_4_25 = Actor.node(var_4_21)
				local var_4_26 = var_4_23 and var_4_23.hit_zones_lookup[var_4_25]
				local var_4_27 = var_4_26 and var_4_26.name or "torso"
				local var_4_28 = Unit.has_node(var_4_22, "j_spine") and Unit.world_position(var_4_22, Unit.node(var_4_22, "j_spine"))
				local var_4_29 = var_0_0[var_4_22] or Unit.world_position(var_4_22, 0)
				local var_4_30 = var_4_28 or var_4_29

				arg_4_0.target_hit_zones_names[var_4_22] = var_4_27
				arg_4_0.target_hit_unit_positions[var_4_22] = var_4_30

				local var_4_31 = Vector3.normalize(var_4_30 - var_4_5)
				local var_4_32 = var_4_0:unit_game_object_id(var_4_22)
				local var_4_33 = NetworkLookup.hit_zones[var_4_27]

				if arg_4_0:_is_infront_player(var_4_5, var_4_4, var_4_30) then
					if var_4_15 >= math.min(Vector3.distance_squared(var_4_30, var_4_12), Vector3.distance_squared(var_4_30, var_4_13)) then
						var_4_16[var_4_22] = true

						break
					end

					local var_4_34 = AiUtils.attack_is_shield_blocked(var_4_22, arg_4_3)
					local var_4_35 = arg_4_0.item_name
					local var_4_36 = NetworkLookup.damage_sources[var_4_35]
					local var_4_37 = arg_4_0.weapon_system
					local var_4_38 = arg_4_0.power_level
					local var_4_39 = arg_4_0.is_server
					local var_4_40 = arg_4_0.damage_profile_aoe
					local var_4_41 = 1
					local var_4_42 = arg_4_0._is_critical_strike

					arg_4_0._overridable_settings = arg_4_4

					ActionSweep._play_character_impact(arg_4_0, var_4_39, arg_4_3, var_4_22, var_4_23, var_4_30, var_4_27, arg_4_4, var_4_40, var_4_41, var_4_38, var_4_31, var_4_34, arg_4_0.melee_boost_curve_multiplier, var_4_42)

					arg_4_0._num_targets_hit = arg_4_0._num_targets_hit + 1

					var_4_37:send_rpc_attack_hit(var_4_36, var_4_2, var_4_32, var_4_33, var_4_30, var_4_31, arg_4_0.damage_profile_aoe_id, "power_level", var_4_38, "hit_target_index", var_4_41, "blocking", var_4_34, "shield_break_procced", false, "boost_curve_multiplier", arg_4_0.melee_boost_curve_multiplier, "is_critical_strike", arg_4_0._is_critical_strike, "can_damage", true, "can_stagger", true, "first_hit", arg_4_0._num_targets_hit == 1)
				end

				break
			end

			if not var_4_24 and ScriptUnit.has_extension(var_4_22, "health_system") then
				local var_4_43, var_4_44 = Managers.state.network:game_object_or_level_id(var_4_22)

				if var_4_44 then
					if not var_4_18(var_4_22, "no_damage_from_players") then
						local var_4_45 = Unit.world_position(var_4_22, 0)

						if var_4_15 >= math.min(Vector3.distance_squared(var_4_45, var_4_12), Vector3.distance_squared(var_4_45, var_4_13)) then
							var_4_16[var_4_22] = true

							break
						end

						local var_4_46 = "full"
						local var_4_47 = 1
						local var_4_48 = arg_4_0.damage_profile_aoe
						local var_4_49 = arg_4_0.item_name
						local var_4_50 = arg_4_0.power_level
						local var_4_51 = arg_4_0._is_critical_strike
						local var_4_52 = Vector3.normalize(var_4_45 - var_4_5)

						DamageUtils.damage_level_unit(var_4_22, arg_4_3, var_4_46, var_4_50, arg_4_0.melee_boost_curve_multiplier, var_4_51, var_4_48, var_4_47, var_4_52, var_4_49)
					end

					break
				end

				local var_4_53 = var_0_0[var_4_22] or Unit.world_position(var_4_22, 0)

				if var_4_15 >= math.min(Vector3.distance_squared(var_4_53, var_4_12), Vector3.distance_squared(var_4_53, var_4_13)) then
					var_4_16[var_4_22] = true
				end

				local var_4_54 = arg_4_0.item_name
				local var_4_55 = NetworkLookup.damage_sources[var_4_54]
				local var_4_56 = arg_4_0.weapon_system
				local var_4_57 = arg_4_0.power_level
				local var_4_58 = NetworkLookup.hit_zones.full
				local var_4_59 = Vector3.normalize(var_4_53 - var_4_5)

				var_4_56:send_rpc_attack_hit(var_4_55, var_4_2, var_4_43, var_4_58, var_4_53, var_4_59, arg_4_0.damage_profile_aoe_id, "power_level", var_4_57, "hit_target_index", nil, "boost_curve_multiplier", arg_4_0.melee_boost_curve_multiplier, "is_critical_strike", arg_4_0._is_critical_strike, "can_damage", true, "can_stagger", true)
			end
		until true
	end

	if Unit.alive(var_4_19) and not arg_4_0.hit_target_breed_unit then
		var_4_16[var_4_19] = true
	end

	local var_4_60 = 1

	for iter_4_1, iter_4_2 in pairs(var_4_16) do
		local var_4_61 = var_4_18(iter_4_1, "breed")
		local var_4_62 = arg_4_0.target_hit_zones_names[iter_4_1] or "torso"
		local var_4_63 = Unit.has_node(iter_4_1, "j_spine") and Unit.world_position(iter_4_1, Unit.node(iter_4_1, "j_spine"))
		local var_4_64 = var_0_0[iter_4_1] or Unit.world_position(iter_4_1, 0)
		local var_4_65 = var_4_63 or var_4_64
		local var_4_66 = Vector3.normalize(var_4_65 - var_4_5)
		local var_4_67, var_4_68 = var_4_0:game_object_or_level_id(iter_4_1)
		local var_4_69 = NetworkLookup.hit_zones[var_4_62]

		if var_4_61 and arg_4_0:_is_infront_player(var_4_5, var_4_4, var_4_65, arg_4_4.push_dot) then
			local var_4_70 = arg_4_0.is_server
			local var_4_71 = iter_4_1 == var_4_19
			local var_4_72 = var_4_71 and arg_4_0.damage_profile_target or arg_4_0.damage_profile
			local var_4_73 = var_4_71 and arg_4_0.damage_profile_target_id or arg_4_0.damage_profile_id
			local var_4_74 = 1
			local var_4_75 = arg_4_0.power_level
			local var_4_76 = arg_4_0._is_critical_strike
			local var_4_77 = AiUtils.attack_is_shield_blocked(iter_4_1, arg_4_3)
			local var_4_78 = Unit.find_actor(iter_4_1, "c_spine") and Unit.actor(iter_4_1, "c_spine")
			local var_4_79 = var_4_78 and Actor.center_of_mass(var_4_78)

			if var_4_79 then
				arg_4_0._overridable_settings = arg_4_4

				ActionSweep._play_character_impact(arg_4_0, var_4_70, arg_4_3, iter_4_1, var_4_61, var_4_79, var_4_62, arg_4_4, var_4_72, var_4_74, var_4_75, var_4_66, var_4_77, arg_4_0.melee_boost_curve_multiplier, var_4_76)
			end

			local var_4_80 = true
			local var_4_81 = var_4_72.charge_value or "heavy_attack"
			local var_4_82 = DamageUtils.get_item_buff_type(arg_4_0.item_name)

			DamageUtils.buff_on_attack(arg_4_3, iter_4_1, var_4_81, var_4_76, var_4_62, var_4_60, var_4_80, var_4_82, nil, arg_4_0.item_name)

			local var_4_83 = NetworkLookup.damage_sources[arg_4_0.item_name]
			local var_4_84 = arg_4_0.weapon_system

			arg_4_0._num_targets_hit = arg_4_0._num_targets_hit + 1

			var_4_84:send_rpc_attack_hit(var_4_83, var_4_2, var_4_67, var_4_69, var_4_65, var_4_66, var_4_73, "power_level", var_4_75, "hit_target_index", var_4_74, "blocking", var_4_77, "shield_break_procced", false, "boost_curve_multiplier", arg_4_0.melee_boost_curve_multiplier, "is_critical_strike", var_4_76, "can_damage", true, "can_stagger", true, "first_hit", arg_4_0._num_targets_hit == 1)

			if arg_4_0.is_critical_strike and arg_4_0.critical_strike_particle_id then
				World.destroy_particles(arg_4_0.world, arg_4_0.critical_strike_particle_id)

				arg_4_0.critical_strike_particle_id = nil
			end

			if not Managers.player:owner(arg_4_0.owner_unit).bot_player then
				Managers.state.controller_features:add_effect("rumble", {
					rumble_effect = "handgun_fire"
				})
			end

			arg_4_0.hit_target_breed_unit = true
			var_4_60 = var_4_60 + 1
		elseif ScriptUnit.has_extension(iter_4_1, "health_system") then
			if var_4_68 then
				if not var_4_18(iter_4_1, "no_damage_from_players") then
					local var_4_85 = "full"
					local var_4_86 = 1
					local var_4_87 = arg_4_0.damage_profile
					local var_4_88 = arg_4_0.item_name
					local var_4_89 = arg_4_0.power_level
					local var_4_90 = arg_4_0._is_critical_strike
					local var_4_91 = Unit.world_position(iter_4_1, 0)
					local var_4_92 = Vector3.normalize(var_4_91 - var_4_5)

					DamageUtils.damage_level_unit(iter_4_1, arg_4_3, var_4_85, var_4_89, arg_4_0.melee_boost_curve_multiplier, var_4_90, var_4_87, var_4_86, var_4_92, var_4_88)
				end
			else
				local var_4_93 = arg_4_0.item_name
				local var_4_94 = NetworkLookup.damage_sources[var_4_93]
				local var_4_95 = arg_4_0.weapon_system
				local var_4_96 = arg_4_0.power_level
				local var_4_97 = NetworkLookup.hit_zones.full
				local var_4_98 = Unit.world_position(iter_4_1, 0)
				local var_4_99 = Vector3.normalize(var_4_98 - var_4_5)

				var_4_95:send_rpc_attack_hit(var_4_94, var_4_2, var_4_67, var_4_97, var_4_98, var_4_99, arg_4_0.damage_profile_id, "power_level", var_4_96, "hit_target_index", nil, "boost_curve_multiplier", arg_4_0.melee_boost_curve_multiplier, "is_critical_strike", arg_4_0._is_critical_strike, "can_damage", true, "can_stagger", true)
			end
		end
	end

	arg_4_0.state = "hit"
end

ActionShieldSlam.finish = function (arg_5_0, arg_5_1)
	local var_5_0 = ScriptUnit.has_extension(arg_5_0.owner_unit, "hud_system")

	if var_5_0 then
		var_5_0.show_critical_indication = false
	end

	arg_5_0.hit_target_breed_unit = false

	local var_5_1 = arg_5_0.owner_unit
	local var_5_2 = arg_5_0.current_action

	if arg_5_1 == "action_complete" and arg_5_0.state ~= "hit" then
		arg_5_0:_hit(arg_5_0.world, true, var_5_1, var_5_2)
	end

	local var_5_3 = arg_5_0.ammo_extension

	if arg_5_1 ~= "new_interupting_action" then
		local var_5_4 = var_5_2.reload_when_out_of_ammo_condition_func
		local var_5_5 = not var_5_4 and true or var_5_4(var_5_1, arg_5_1)

		if var_5_3 and var_5_2.reload_when_out_of_ammo and var_5_5 and var_5_3:ammo_count() == 0 and var_5_3:can_reload() then
			local var_5_6 = true

			var_5_3:start_reload(var_5_6)
		end
	end
end

ActionShieldSlam._is_infront_player = function (arg_6_0, arg_6_1, arg_6_2, arg_6_3, arg_6_4)
	local var_6_0 = Vector3.normalize(arg_6_3 - arg_6_1)

	if Vector3.dot(var_6_0, arg_6_2) > (arg_6_4 or 0.35) then
		return true
	end
end

ActionShieldSlam.destroy = function (arg_7_0)
	if arg_7_0.critical_strike_particle_id then
		World.destroy_particles(arg_7_0.world, arg_7_0.critical_strike_particle_id)

		arg_7_0.critical_strike_particle_id = nil
	end
end
