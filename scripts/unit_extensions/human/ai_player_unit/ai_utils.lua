-- chunkname: @scripts/unit_extensions/human/ai_player_unit/ai_utils.lua

local var_0_0 = require("scripts/utils/stagger_types")

require("scripts/entity_system/systems/behaviour/utility/utility")

local var_0_1 = Unit.get_data
local var_0_2 = script_data
local var_0_3 = Unit.alive
local var_0_4 = Unit.local_rotation
local var_0_5 = Unit.animation_event
local var_0_6 = BLACKBOARDS

function aiprint(...)
	if var_0_2.debug_ai_movement then
		print(...)
	end
end

AiUtils = AiUtils or {}
BreedCategory = {
	Boss = 8,
	Special = 64,
	Armored = 16,
	Infantry = 1,
	Shielded = 2,
	SuperArmor = 32,
	Berserker = 4
}

AiUtils.has_breed_categories = function (arg_2_0, arg_2_1)
	return bit.band(arg_2_0, arg_2_1) == arg_2_0
end

AiUtils.special_dead_cleanup = function (arg_3_0, arg_3_1)
	if not arg_3_1.target_unit then
		return
	end

	arg_3_1.group_blackboard.special_targets[arg_3_1.target_unit] = nil
	arg_3_1.group_blackboard.disabled_by_special[arg_3_1.target_unit] = nil
end

AiUtils.aggro_unit_of_enemy = function (arg_4_0, arg_4_1)
	arg_4_1 = AiUtils.get_actual_attacker_unit(arg_4_1)

	if not ALIVE[arg_4_1] then
		return
	end

	local var_4_0 = ScriptUnit.has_extension(arg_4_0, "ai_system")

	if var_4_0 then
		var_4_0:enemy_aggro(arg_4_0, arg_4_1)
	end
end

AiUtils.activate_unit = function (arg_5_0)
	if arg_5_0.activation_lock then
		return
	end

	local var_5_0 = arg_5_0.breed

	if not arg_5_0.confirmed_player_sighting and not var_5_0.ignore_activate_unit then
		local var_5_1 = arg_5_0.unit

		if not HEALTH_ALIVE[var_5_1] then
			return
		end

		Managers.state.event:trigger("ai_unit_activated", var_5_1, var_5_0.name, arg_5_0.master_event_id)

		arg_5_0.confirmed_player_sighting = true
		arg_5_0.activated = true
	end
end

AiUtils.deactivate_unit = function (arg_6_0)
	if arg_6_0.confirmed_player_sighting then
		local var_6_0 = arg_6_0.breed
		local var_6_1 = arg_6_0.unit

		Managers.state.event:trigger("ai_unit_deactivated", var_6_1, var_6_0.name, arg_6_0.master_event_id)

		arg_6_0.confirmed_player_sighting = false
		arg_6_0.activated = false
	end
end

AiUtils.enter_combat = function (arg_7_0, arg_7_1)
	Managers.state.network:anim_event(arg_7_0, "to_combat")

	arg_7_1.in_combat = true
end

AiUtils.enter_passive = function (arg_8_0, arg_8_1)
	Managers.state.network:anim_event(arg_8_0, "to_passive")

	arg_8_1.in_combat = false
end

AiUtils.in_combat = function (arg_9_0)
	return arg_9_0.in_combat
end

AiUtils.stormvermin_champion_hack_check_ward = function (arg_10_0, arg_10_1)
	if arg_10_1.ward_active and not arg_10_1.defensive_mode_duration then
		arg_10_1.ward_active = false

		AiUtils.stormvermin_champion_set_ward_state(arg_10_0, false, true)
	end
end

AiUtils.stormvermin_champion_set_ward_state = function (arg_11_0, arg_11_1, arg_11_2)
	local var_11_0 = Unit.actor(arg_11_0, "c_trophy_rack_ward")

	if var_11_0 then
		Actor.set_scene_query_enabled(var_11_0, arg_11_1)
	end

	if arg_11_1 then
		Unit.flow_event(arg_11_0, "skulls_glow_on")
	else
		Unit.flow_event(arg_11_0, "skulls_glow_off")
	end

	if arg_11_2 then
		local var_11_1 = Managers.state.network
		local var_11_2 = var_11_1:unit_game_object_id(arg_11_0)

		var_11_1.network_transmit:send_rpc_clients("rpc_set_ward_state", var_11_2, arg_11_1)
	end
end

AiUtils.chaos_exalted_champion_set_shield_state = function (arg_12_0, arg_12_1, arg_12_2)
	if arg_12_1 then
		Unit.flow_event(arg_12_0, "chaos_shields_on")
	else
		Unit.flow_event(arg_12_0, "chaos_shields_off")
	end
end

AiUtils.alert_unit_of_enemy = function (arg_13_0, arg_13_1)
	arg_13_1 = AiUtils.get_actual_attacker_unit(arg_13_1)

	if not HEALTH_ALIVE[arg_13_1] then
		return
	end

	local var_13_0 = ScriptUnit.has_extension(arg_13_0, "ai_system")

	if var_13_0 then
		var_13_0:enemy_alert(arg_13_0, arg_13_1)
	end
end

AiUtils.alert_unit = function (arg_14_0, arg_14_1)
	local var_14_0 = Managers.state.network

	if var_14_0.is_server then
		AiUtils.alert_unit_of_enemy(arg_14_1, arg_14_0)
	else
		local var_14_1 = var_14_0:unit_game_object_id(arg_14_0)
		local var_14_2 = var_14_0:unit_game_object_id(arg_14_1)

		var_14_0.network_transmit:send_rpc_server("rpc_alert_enemy", var_14_2, var_14_1)
	end
end

local var_0_7 = {}

AiUtils.alert_nearby_friends_of_enemy = function (arg_15_0, arg_15_1, arg_15_2, arg_15_3)
	arg_15_3 = arg_15_3 or 5
	arg_15_2 = AiUtils.get_actual_attacker_unit(arg_15_2)

	if not ALIVE[arg_15_2] then
		return
	end

	local var_15_0 = Broadphase.query(arg_15_1, Unit.local_position(arg_15_0, 0), arg_15_3, var_0_7)

	for iter_15_0 = 1, var_15_0 do
		local var_15_1 = var_0_7[iter_15_0]

		if var_15_1 ~= arg_15_0 then
			local var_15_2 = ScriptUnit.has_extension(var_15_1, "ai_system")

			if var_15_2 then
				var_15_2:enemy_alert(arg_15_0, arg_15_2)
			end
		end

		var_0_7[iter_15_0] = nil
	end
end

AiUtils.print = function (arg_16_0, ...)
	if Development.parameter(arg_16_0) then
		print(...)
	end
end

AiUtils.printf = function (arg_17_0, ...)
	if Development.parameter(arg_17_0) then
		printf(...)
	end
end

AiUtils.breed_name = function (arg_18_0)
	return Unit.get_data(arg_18_0, "breed").name
end

AiUtils.stagger_target = function (arg_19_0, arg_19_1, arg_19_2, arg_19_3, arg_19_4, arg_19_5, arg_19_6, arg_19_7, arg_19_8, arg_19_9)
	local var_19_0, var_19_1 = DamageUtils.calculate_stagger(arg_19_3, arg_19_6, arg_19_1, arg_19_0, arg_19_7, arg_19_8, arg_19_9)

	if var_19_0 > 0 then
		local var_19_2 = var_0_6[arg_19_1]

		AiUtils.stagger(arg_19_1, var_19_2, arg_19_0, arg_19_4, arg_19_2, var_19_0, var_19_1, nil, arg_19_5)
	end
end

AiUtils.calculate_ai_stagger_strength = function (arg_20_0, arg_20_1, arg_20_2, arg_20_3, arg_20_4, arg_20_5)
	local var_20_0 = arg_20_2 - (arg_20_1.ai_toughness_break_t or 0)
	local var_20_1 = math.max((arg_20_1.ai_toughness_break or 0) - var_20_0, 0)
	local var_20_2 = (arg_20_1.breed.ai_toughness or 0) - var_20_1
	local var_20_3 = arg_20_0.breed.ai_strength or 0
	local var_20_4 = math.round(math.clamp(var_20_3 - var_20_2, var_0_0.none, var_0_0.heavy))

	if arg_20_3 then
		arg_20_1.ai_toughness_break = var_20_1 + var_20_3
		arg_20_1.ai_toughness_break_t = arg_20_2

		if arg_20_4 and arg_20_4 <= var_20_4 then
			arg_20_1.ai_toughness_break = arg_20_1.ai_toughness_break * arg_20_5
		end
	end

	return var_20_4
end

AiUtils.calculate_ai_stagger_impact = function (arg_21_0)
	local var_21_0 = (0.15 + 0.1 * math.random()) * arg_21_0

	return {
		arg_21_0
	}, var_21_0
end

AiUtils.damage_target = function (arg_22_0, arg_22_1, arg_22_2, arg_22_3, arg_22_4)
	arg_22_3 = DamageUtils.calculate_damage(arg_22_3, arg_22_0, arg_22_1)

	local var_22_0 = POSITION_LOOKUP[arg_22_1] or Unit.world_position(arg_22_1, 0)
	local var_22_1 = POSITION_LOOKUP[arg_22_0] or Unit.world_position(arg_22_0, 0)
	local var_22_2 = Vector3.normalize(var_22_1 - var_22_0)
	local var_22_3, var_22_4 = Managers.state.network:game_object_or_level_id(arg_22_0)

	arg_22_4 = arg_22_4 or AiUtils.breed_name(arg_22_1)

	local var_22_5
	local var_22_6
	local var_22_7 = var_0_6[arg_22_1]
	local var_22_8 = var_22_7 and var_22_7.commander_unit

	if var_22_4 then
		var_22_5 = DamageUtils.add_damage_network(arg_22_0, arg_22_1, arg_22_3, "torso", arg_22_2.damage_type, nil, var_22_2, arg_22_4, nil, var_22_8, nil, arg_22_2.hit_react_type, nil, nil, nil, nil, nil, nil, 1)
	else
		local var_22_9 = Managers.state.difficulty
		local var_22_10 = var_22_9:get_difficulty_settings()
		local var_22_11 = arg_22_2.diminishing_damage
		local var_22_12 = ScriptUnit.has_extension(arg_22_0, "ai_slot_system")

		if var_22_11 and var_22_12 and var_22_12.has_slots_attached then
			local var_22_13 = var_22_12.delayed_num_occupied_slots

			if var_22_13 > 0 then
				local var_22_14 = var_22_11[math.min(var_22_13, 9)].damage
				local var_22_15 = var_22_11[1].damage
				local var_22_16 = Managers.weave

				if var_22_16:get_active_weave() then
					local var_22_17 = var_22_16:get_scaling_value("diminishing_damage")

					var_22_14 = math.lerp(var_22_14, var_22_15, var_22_17)
				end

				arg_22_3 = arg_22_3 * var_22_14
			end
		end

		local var_22_18 = DamageUtils.is_player_unit(arg_22_0)

		if var_22_18 then
			local var_22_19 = var_22_9:get_difficulty_rank()

			if var_22_19 and var_22_19 < 3 then
				local var_22_20 = ScriptUnit.has_extension(arg_22_0, "status_system")

				if var_22_20 and var_22_20:is_knocked_down() then
					arg_22_3 = arg_22_3 * (var_22_10.knocked_down_damage_multiplier or 1)
				end

				local var_22_21 = ScriptUnit.has_extension(arg_22_0, "health_system")

				if var_22_21 then
					local var_22_22 = var_22_10.damage_percent_cap
					local var_22_23 = var_22_21:get_max_health() * var_22_22

					arg_22_3 = math.clamp(arg_22_3, 0, var_22_23)
				end

				arg_22_3 = arg_22_3 * (var_22_10.damage_multiplier or 1)
			end
		else
			local var_22_24 = var_0_6[arg_22_0]

			if var_22_24 and var_22_7 then
				local var_22_25 = Managers.time:time("game")
				local var_22_26 = var_22_7.breed
				local var_22_27 = var_22_24.breed
				local var_22_28

				if arg_22_2.unblockable and arg_22_2.attack_intensity_type == "push" then
					var_22_28 = var_0_0[arg_22_2.hit_react_type]
				end

				var_22_28 = var_22_28 or AiUtils.calculate_ai_stagger_strength(var_22_7, var_22_24, var_22_25, true, var_0_0.medium, 0.25)

				if var_22_28 <= 0 then
					if var_22_27.strong_hit_reacts and var_22_24.past_damage_in_attack ~= false and (not var_22_24.stagger or var_22_24.stagger_anim_done) then
						local var_22_29 = Quaternion.forward(var_0_4(arg_22_0, 0))
						local var_22_30 = Vector3.flat_angle(var_22_2, var_22_29)
						local var_22_31

						if var_22_30 < -math.pi * 0.75 or var_22_30 > math.pi * 0.75 then
							var_22_31 = var_22_27.strong_hit_reacts.bwd
						elseif var_22_30 < -math.pi * 0.25 then
							var_22_31 = var_22_27.strong_hit_reacts.left
						elseif var_22_30 < math.pi * 0.25 then
							var_22_31 = var_22_27.strong_hit_reacts.fwd
						else
							var_22_31 = var_22_27.strong_hit_reacts.right
						end

						if var_22_31 then
							local var_22_32 = var_22_31[math.random(1, #var_22_31)]

							var_0_5(arg_22_0, var_22_32)
						end
					elseif not var_22_27.disable_local_hit_reactions then
						local var_22_33 = Quaternion.forward(var_0_4(arg_22_0, 0))
						local var_22_34 = Vector3.flat_angle(var_22_33, var_22_2)
						local var_22_35
						local var_22_36 = (var_22_34 < -math.pi * 0.75 or var_22_34 > math.pi * 0.75) and "hit_reaction_backward" or var_22_34 < -math.pi * 0.25 and "hit_reaction_left" or var_22_34 < math.pi * 0.25 and "hit_reaction_forward" or "hit_reaction_right"

						if var_22_36 then
							var_0_5(arg_22_0, var_22_36)
						end
					end
				else
					local var_22_37, var_22_38 = AiUtils.calculate_ai_stagger_impact(var_22_28)

					AiUtils.stagger_target(arg_22_1, arg_22_0, var_22_38, var_22_37, var_22_2, var_22_25)
				end

				arg_22_3 = arg_22_3 * (var_22_26.damage_multiplier_vs_ai or 0.25)

				local var_22_39
				local var_22_40 = var_22_27.hitzone_armor_categories
				local var_22_41 = var_22_40 and var_22_40.torso or var_22_27.armor_category

				if arg_22_3 < 0.25 and var_22_41 == 2 then
					var_22_39 = "fx/hit_armored"
				elseif not var_22_27.no_blood_splatter_on_damage then
					var_22_39 = BloodSettings:get_hit_effect_for_race(var_22_27.race) or var_22_27.hit_effect
				end

				if var_22_39 then
					local var_22_42 = var_22_24.world
					local var_22_43 = var_22_27.hit_zones_lookup.torso or 0
					local var_22_44 = Unit.world_position(arg_22_0, var_22_43) + Vector3(0, 0, math.random() * var_22_27.aoe_height * 0.1)

					EffectHelper.player_melee_hit_particles(var_22_42, var_22_39, var_22_44, var_22_2, arg_22_2.damage_type, arg_22_0, arg_22_3)
				end
			end
		end

		var_22_5 = DamageUtils.add_damage_network(arg_22_0, arg_22_1, arg_22_3, "torso", arg_22_2.damage_type, nil, var_22_2, arg_22_4, nil, var_22_8, nil, arg_22_2.hit_react_type, nil, nil, nil, nil, nil, nil, 1)

		local var_22_45 = arg_22_2.player_push_speed

		if var_22_18 and var_22_45 and not ScriptUnit.extension(arg_22_0, "status_system"):is_disabled() then
			ScriptUnit.extension(arg_22_0, "locomotion_system"):add_external_velocity(var_22_45 * var_22_2, arg_22_2.max_player_push_speed)
		end
	end

	local var_22_46 = var_0_6[arg_22_1]

	if var_22_46 then
		var_22_46.hit_through_block = false
	end

	return var_22_5
end

AiUtils.add_attack_intensity = function (arg_23_0, arg_23_1, arg_23_2)
	local var_23_0 = ScriptUnit.has_extension(arg_23_0, "attack_intensity_system")

	if not var_23_0 then
		return
	end

	local var_23_1 = arg_23_1.attack_intensity_type

	if not var_23_1 then
		return
	end

	local var_23_2 = Managers.state.difficulty:get_difficulty()
	local var_23_3 = arg_23_1.difficulty_attack_intensity and arg_23_1.difficulty_attack_intensity[var_23_1][var_23_2]

	if not var_23_3 then
		return
	end

	local var_23_4 = arg_23_1.add_random_intensity

	for iter_23_0, iter_23_1 in pairs(var_23_3) do
		local var_23_5 = iter_23_1 * (var_23_4 and 0.75 + 0.5 * math.random() or 1)

		var_23_0:add_attack_intensity(iter_23_0, var_23_5)
	end
end

AiUtils.poison_explode_unit = function (arg_24_0, arg_24_1, arg_24_2)
	local var_24_0 = Unit.local_position(arg_24_0, 0)
	local var_24_1 = Managers.state.difficulty:get_difficulty_rank()
	local var_24_2 = arg_24_1.aoe_dot_damage[var_24_1] or arg_24_1.aoe_dot_damage[2]
	local var_24_3 = DamageUtils.calculate_damage(var_24_2)
	local var_24_4 = arg_24_1.aoe_init_damage[var_24_1] or arg_24_1.aoe_init_damage[2]
	local var_24_5 = DamageUtils.calculate_damage(var_24_4)
	local var_24_6 = arg_24_1.aoe_dot_damage_interval
	local var_24_7 = arg_24_1.radius
	local var_24_8 = arg_24_1.initial_radius
	local var_24_9 = arg_24_1.duration
	local var_24_10 = arg_24_1.create_nav_tag_volume
	local var_24_11 = arg_24_1.nav_tag_volume_layer
	local var_24_12 = {
		area_damage_system = {
			area_damage_template = "globadier_area_dot_damage",
			invisible_unit = true,
			player_screen_effect_name = "fx/screenspace_poison_globe_impact",
			area_ai_random_death_template = "area_poison_ai_random_death",
			dot_effect_name = "fx/wpnfx_poison_wind_globe_impact",
			extra_dot_effect_name = "fx/chr_gutter_death",
			damage_players = true,
			aoe_dot_damage = var_24_3,
			aoe_init_damage = var_24_5,
			aoe_dot_damage_interval = var_24_6,
			radius = var_24_7,
			initial_radius = var_24_8,
			life_time = var_24_9,
			damage_source = arg_24_2.breed.name,
			create_nav_tag_volume = var_24_10,
			nav_tag_volume_layer = var_24_11,
			source_attacker_unit = arg_24_0
		}
	}
	local var_24_13 = "units/weapons/projectile/poison_wind_globe/poison_wind_globe"
	local var_24_14 = Managers.state.unit_spawner:spawn_network_unit(var_24_13, "aoe_unit", var_24_12, var_24_0)
	local var_24_15 = Managers.state.unit_storage:go_id(var_24_14)

	Unit.set_unit_visibility(var_24_14, false)

	local var_24_16 = arg_24_2.world

	assert(var_24_16)
	Managers.state.network.network_transmit:send_rpc_all("rpc_area_damage", var_24_15, var_24_0)
	Managers.state.unit_spawner:mark_for_deletion(arg_24_0)
end

AiUtils.warpfire_explode_unit = function (arg_25_0, arg_25_1)
	local var_25_0 = arg_25_1.world
	local var_25_1 = ExplosionUtils.get_template("warpfire_explosion")
	local var_25_2 = Unit.node(arg_25_0, "j_backpack")
	local var_25_3 = Unit.world_position(arg_25_0, var_25_2)
	local var_25_4 = Managers.state.unit_storage:go_id(arg_25_0)
	local var_25_5 = NetworkLookup.explosion_templates.warpfire_explosion
	local var_25_6 = arg_25_1.breed.name
	local var_25_7 = NetworkLookup.damage_sources[var_25_6]

	Unit.flow_event(arg_25_0, "lua_hide_backpack")

	local var_25_8 = Unit.actor(arg_25_0, "c_backpack")

	Actor.set_collision_filter(var_25_8, "filter_trigger")
	Actor.set_scene_query_enabled(var_25_8, false)
	DamageUtils.create_explosion(var_25_0, arg_25_0, var_25_3, Quaternion.identity(), var_25_1, 1, var_25_6, true, false, arg_25_0, 0, false)
	Managers.state.network.network_transmit:send_rpc_clients("rpc_create_explosion", var_25_4, false, var_25_3, Quaternion.identity(), var_25_5, 1, var_25_7, 0, false, var_25_4)

	local var_25_9 = POSITION_LOOKUP[arg_25_0]
	local var_25_10 = Managers.state.entity:system("ai_system"):nav_world()
	local var_25_11 = LocomotionUtils.get_close_pos_below_on_mesh(var_25_10, var_25_9, 4)

	if var_25_11 then
		local var_25_12 = Unit.local_rotation(arg_25_0, 0)
		local var_25_13 = Quaternion.forward(var_25_12)
		local var_25_14 = Vector3.flat(var_25_13)
		local var_25_15 = {
			area_damage_system = {
				liquid_template = "warpfire_death_fire",
				flow_dir = var_25_14,
				source_unit = arg_25_0
			}
		}
		local var_25_16 = "units/hub_elements/empty"
		local var_25_17 = Managers.state.unit_spawner:spawn_network_unit(var_25_16, "liquid_aoe_unit", var_25_15, var_25_11)

		ScriptUnit.extension(var_25_17, "area_damage_system"):ready()
	end
end

AiUtils.chaos_zombie_explosion = function (arg_26_0, arg_26_1, arg_26_2, arg_26_3)
	local var_26_0 = Unit.local_position(arg_26_0, 0)
	local var_26_1 = arg_26_2.breed.name
	local var_26_2 = arg_26_2.world
	local var_26_3 = var_26_0 + Vector3.up()
	local var_26_4 = ExplosionUtils.get_template("chaos_zombie_explosion")

	DamageUtils.create_explosion(var_26_2, arg_26_0, var_26_3, Quaternion.identity(), var_26_4, 1, var_26_1, true, false, arg_26_0, 0, false)

	local var_26_5 = Managers.state.unit_storage:go_id(arg_26_0)
	local var_26_6 = NetworkLookup.explosion_templates.chaos_zombie_explosion
	local var_26_7 = NetworkLookup.damage_sources[var_26_1]

	Managers.state.network.network_transmit:send_rpc_clients("rpc_create_explosion", var_26_5, false, var_26_3, Quaternion.identity(), var_26_6, 1, var_26_7, 0, false, var_26_5)

	if arg_26_3 then
		Managers.state.unit_spawner:mark_for_deletion(arg_26_0)
	end

	local var_26_8 = Quaternion.up(Unit.local_rotation(arg_26_0, 0))

	Managers.state.blood:add_blood_ball(var_26_0, var_26_8, "default", arg_26_0)
end

AiUtils.generic_mutator_explosion = function (arg_27_0, arg_27_1, arg_27_2, arg_27_3)
	local var_27_0 = Unit.local_position(arg_27_0, 0)
	local var_27_1 = Managers.state.difficulty:get_difficulty_rank()
	local var_27_2 = arg_27_1.breed.name
	local var_27_3 = arg_27_1.world
	local var_27_4 = var_27_0 + Vector3.up()
	local var_27_5 = ExplosionUtils.get_template(arg_27_2)

	DamageUtils.create_explosion(var_27_3, arg_27_3 and arg_27_0, var_27_4, Quaternion.identity(), var_27_5, 1, var_27_2, true, false, arg_27_0, 0, false)

	local var_27_6 = Managers.state.unit_storage:go_id(arg_27_0)
	local var_27_7 = NetworkLookup.explosion_templates[arg_27_2]
	local var_27_8 = NetworkLookup.damage_sources[var_27_2]

	Managers.state.network.network_transmit:send_rpc_clients("rpc_create_explosion", var_27_6, false, var_27_4, Quaternion.identity(), var_27_7, 1, var_27_8, 0, false, var_27_6)

	local var_27_9 = Quaternion.up(Unit.local_rotation(arg_27_0, 0))

	Managers.state.blood:add_blood_ball(var_27_0, var_27_9, "default", arg_27_0)
end

AiUtils.ai_explosion = function (arg_28_0, arg_28_1, arg_28_2, arg_28_3, arg_28_4)
	local var_28_0 = Unit.local_position(arg_28_0, 0)
	local var_28_1 = arg_28_2.breed.name
	local var_28_2 = arg_28_2.world

	DamageUtils.create_explosion(var_28_2, arg_28_0, var_28_0, Quaternion.identity(), arg_28_4, 1, var_28_1, true, false, arg_28_1, false)

	local var_28_3 = Managers.state.unit_storage:go_id(arg_28_1)
	local var_28_4 = NetworkLookup.explosion_templates[arg_28_4.name]
	local var_28_5 = NetworkLookup.damage_sources[var_28_1]

	Managers.state.network.network_transmit:send_rpc_clients("rpc_create_explosion", var_28_3, false, var_28_0, Quaternion.identity(), var_28_4, 1, var_28_5, 0, false, var_28_3)
	Managers.state.unit_spawner:mark_for_deletion(arg_28_0)
end

AiUtils.loot_rat_explosion = function (arg_29_0, arg_29_1, arg_29_2, arg_29_3, arg_29_4)
	local var_29_0 = Unit.local_position(arg_29_0, 0)
	local var_29_1 = arg_29_2.breed.name
	local var_29_2 = arg_29_2.world

	DamageUtils.create_explosion(var_29_2, arg_29_0, var_29_0, Quaternion.identity(), arg_29_4, 1, var_29_1, true, false, arg_29_1, false)

	local var_29_3 = Managers.state.unit_storage:go_id(arg_29_1)
	local var_29_4 = NetworkLookup.explosion_templates[arg_29_4.name]
	local var_29_5 = NetworkLookup.damage_sources[var_29_1]

	Managers.state.network.network_transmit:send_rpc_clients("rpc_create_explosion", var_29_3, false, var_29_0, Quaternion.identity(), var_29_4, 1, var_29_5, 0, false, var_29_3)

	arg_29_2.delete_at_t = Managers.time:time("game") + 0.1
end

AiUtils.spawn_overpowering_blob = function (arg_30_0, arg_30_1, arg_30_2, arg_30_3)
	local var_30_0 = POSITION_LOOKUP[arg_30_1]
	local var_30_1 = "units/weapons/enemy/wpn_overpowering_blob/wpn_overpowering_blob"
	local var_30_2 = {
		health_system = {
			health = arg_30_2,
			target_unit = arg_30_1,
			life_time = arg_30_3
		},
		death_system = {
			death_reaction_template = "lure_unit"
		}
	}
	local var_30_3 = Vector3(1, 1, 1)
	local var_30_4 = Matrix4x4.from_quaternion_position(Quaternion.identity(), var_30_0)

	Matrix4x4.set_scale(var_30_4, Vector3(var_30_3[1], var_30_3[2], var_30_3[3]))

	local var_30_5 = Managers.state.unit_spawner:spawn_network_unit(var_30_1, "overpowering_blob_unit", var_30_2, var_30_4)
	local var_30_6 = Unit.node(arg_30_1, "c_spine")
	local var_30_7 = var_30_5
	local var_30_8 = 0
	local var_30_9 = Application.main_world()

	World.link_unit(var_30_9, var_30_7, arg_30_1, var_30_6)

	local var_30_10 = arg_30_0:unit_game_object_id(var_30_7)
	local var_30_11 = arg_30_0:unit_game_object_id(arg_30_1)

	arg_30_0.network_transmit:send_rpc_clients("rpc_link_unit", var_30_10, var_30_8, var_30_11, var_30_6)

	return var_30_5
end

AiUtils.broadphase_query = function (arg_31_0, arg_31_1, arg_31_2, arg_31_3)
	fassert(arg_31_2, "No result_table given to AiUtils,broadphase_query")

	local var_31_0 = Managers.state.entity:system("ai_system").group_blackboard.broadphase

	return (Broadphase.query(var_31_0, arg_31_0, arg_31_1, arg_31_2, arg_31_3))
end

AiUtils.get_angle_between_vectors = function (arg_32_0, arg_32_1)
	arg_32_0 = Vector3.normalize(Vector3.flat(arg_32_0))
	arg_32_1 = Vector3.normalize(Vector3.flat(arg_32_1))

	local var_32_0 = math.atan2(arg_32_0.y, arg_32_0.x) - math.atan2(arg_32_1.y, arg_32_1.x)
	local var_32_1 = math.radians_to_degrees(var_32_0)

	return math.abs(var_32_1), var_32_1, var_32_0
end

AiUtils.rotate_vector = function (arg_33_0, arg_33_1)
	local var_33_0 = Vector3.length(arg_33_0)
	local var_33_1 = math.atan2(arg_33_0.y, arg_33_0.x) + arg_33_1
	local var_33_2 = math.cos(var_33_1)
	local var_33_3 = math.sin(var_33_1)

	return Vector3(var_33_2, var_33_3, 0) * var_33_0
end

AiUtils.constrain_radians = function (arg_34_0)
	if arg_34_0 > math.pi then
		arg_34_0 = -math.pi + (arg_34_0 - math.pi)
	elseif arg_34_0 < -math.pi then
		arg_34_0 = math.pi + (arg_34_0 + math.pi)
	end

	return arg_34_0
end

AiUtils.calculate_oobb = function (arg_35_0, arg_35_1, arg_35_2, arg_35_3, arg_35_4)
	local var_35_0 = arg_35_3 or 2
	local var_35_1 = (arg_35_4 or 2) * 0.5
	local var_35_2 = arg_35_0 * 0.5
	local var_35_3 = var_35_0 * 0.5
	local var_35_4 = Vector3(var_35_1, var_35_2, var_35_3)
	local var_35_5 = Quaternion.rotate(arg_35_2, Vector3.forward()) * var_35_2
	local var_35_6 = Vector3.up() * var_35_3

	return arg_35_1 + var_35_5 + var_35_6, arg_35_2, var_35_4
end

local var_0_8 = 0

AiUtils.calculate_bot_threat_time = function (arg_36_0)
	local var_36_0 = arg_36_0.duration
	local var_36_1 = arg_36_0.max_start_delay or 0
	local var_36_2 = math.random()
	local var_36_3 = var_0_8 + var_36_2

	if var_36_3 > 1 then
		var_36_3 = var_36_2
	end

	local var_36_4 = var_36_3 * var_36_1
	local var_36_5 = arg_36_0.start_time + var_36_4

	var_0_8 = var_36_3

	return var_36_5, var_36_0 - var_36_4
end

AiUtils.get_actual_attacker_unit = function (arg_37_0)
	local var_37_0 = ScriptUnit.has_extension(arg_37_0, "projectile_system")

	if var_37_0 and not ScriptUnit.has_extension(arg_37_0, "limited_item_track_system") and ALIVE[var_37_0.owner_unit] then
		return var_37_0.owner_unit
	end

	local var_37_1 = ScriptUnit.has_extension(arg_37_0, "area_damage_system")

	if var_37_1 then
		local var_37_2 = var_37_1.owner_player

		if var_37_2 and ALIVE[var_37_2.player_unit] then
			return var_37_2.player_unit
		end
	end

	return arg_37_0
end

AiUtils.get_actual_attacker_breed = function (arg_38_0, arg_38_1, arg_38_2, arg_38_3, arg_38_4)
	local var_38_0 = ScriptUnit.has_extension(arg_38_1, "status_system")
	local var_38_1 = var_38_0 and var_38_0:query_pack_master_player()

	if var_38_1 and var_38_1 == arg_38_4 and arg_38_2 == "skaven_pack_master" then
		return PlayerBreeds.vs_packmaster
	end

	local var_38_2 = Managers.state.entity:system("area_damage_system"):has_source_attacker_unit_data(arg_38_3)

	if var_38_2 then
		return var_38_2.breed
	end

	if arg_38_4 then
		local var_38_3 = arg_38_4:profile_index()
		local var_38_4 = arg_38_4:career_index()

		if var_38_3 and var_38_4 then
			return SPProfiles[var_38_3].careers[var_38_4].breed
		end
	end

	return arg_38_0
end

AiUtils.get_actual_attacker_player = function (arg_39_0, arg_39_1, arg_39_2)
	local var_39_0 = Managers.player:owner(arg_39_0)
	local var_39_1 = ScriptUnit.has_extension(arg_39_0, "projectile_system")

	if var_39_1 and not ScriptUnit.has_extension(arg_39_0, "limited_item_track_system") then
		local var_39_2 = var_39_1.owner_unit
		local var_39_3 = Managers.player:owner(var_39_2)

		if var_39_3 then
			return var_39_3
		end
	end

	local var_39_4 = ScriptUnit.has_extension(arg_39_0, "area_damage_system")

	if var_39_4 then
		local var_39_5 = var_39_4.owner_player

		if var_39_5 then
			return var_39_5
		end
	end

	if arg_39_2 == "skaven_pack_master" then
		local var_39_6 = ScriptUnit.has_extension(arg_39_1, "status_system")
		local var_39_7 = var_39_6 and var_39_6:query_pack_master_player()

		if var_39_7 then
			return var_39_7
		end
	end

	local var_39_8 = Managers.state.entity:system("ai_commander_system"):get_commander_unit(arg_39_0)
	local var_39_9 = Managers.player:owner(var_39_8)

	if var_39_9 then
		return var_39_9
	end

	return var_39_0
end

AiUtils.unit_breed = function (arg_40_0)
	if not ALIVE[arg_40_0] then
		return
	end

	return var_0_1(arg_40_0, "breed")
end

AiUtils.downed_duration = function (arg_41_0)
	local var_41_0 = arg_41_0.downed_duration

	if type(var_41_0) == "table" then
		return var_41_0[Managers.state.difficulty:get_difficulty_rank()]
	end

	return var_41_0
end

AiUtils.client_predicted_unit_alive = function (arg_42_0)
	if not var_0_3(arg_42_0) then
		return false
	end

	local var_42_0 = ScriptUnit.has_extension(arg_42_0, "health_system")

	return var_42_0 and var_42_0:client_predicted_is_alive()
end

AiUtils.unit_invincible = function (arg_43_0)
	if not ALIVE[arg_43_0] then
		return false
	end

	local var_43_0 = ScriptUnit.has_extension(arg_43_0, "health_system")

	return var_43_0 and var_43_0:get_is_invincible()
end

AiUtils.unit_knocked_down = function (arg_44_0)
	if not ALIVE[arg_44_0] then
		return false
	end

	local var_44_0 = ScriptUnit.has_extension(arg_44_0, "status_system")

	if not var_44_0 then
		return false
	end

	return (var_44_0:is_knocked_down())
end

AiUtils.unit_disabled = function (arg_45_0)
	if not ALIVE[arg_45_0] then
		return false
	end

	local var_45_0 = ScriptUnit.has_extension(arg_45_0, "status_system")

	if not var_45_0 then
		return false
	end

	return (var_45_0:is_disabled())
end

AiUtils.is_unwanted_target = function (arg_46_0, arg_46_1)
	if arg_46_0.VALID_ENEMY_TARGETS_PLAYERS_AND_BOTS[arg_46_1] and ScriptUnit.extension(arg_46_1, "status_system"):is_grabbed_by_chaos_spawn() then
		return true
	end

	return false
end

AiUtils.is_of_interest_to_gutter_runner = function (arg_47_0, arg_47_1, arg_47_2, arg_47_3)
	if not Managers.state.side.side_by_unit[arg_47_0].VALID_ENEMY_TARGETS_PLAYERS_AND_BOTS[arg_47_1] then
		return
	end

	local var_47_0 = arg_47_2.group_blackboard.disabled_by_special[arg_47_1]

	if var_47_0 and var_47_0 ~= arg_47_0 then
		return
	end

	local var_47_1 = ScriptUnit.extension(arg_47_1, "status_system")

	if var_47_1:is_knocked_down() and not arg_47_3 then
		return
	end

	if var_47_1:is_grabbed_by_pack_master() then
		return
	end

	if var_47_1:is_grabbed_by_corruptor() then
		return
	end

	if var_47_1:is_grabbed_by_chaos_spawn() then
		return
	end

	if var_47_1:get_is_ledge_hanging() then
		return
	end

	if var_47_1:is_pounced_down() and var_47_1:get_pouncer_unit() ~= arg_47_0 then
		return
	end

	if var_47_1.using_transport then
		return
	end

	return true
end

AiUtils.is_of_interest_to_packmaster = function (arg_48_0, arg_48_1)
	if Managers.state.side.side_by_unit[arg_48_0].VALID_ENEMY_TARGETS_PLAYERS_AND_BOTS[arg_48_1] then
		local var_48_0 = ScriptUnit.extension(arg_48_1, "status_system")
		local var_48_1 = var_48_0:is_knocked_down()
		local var_48_2 = var_48_0:is_pounced_down()
		local var_48_3 = var_48_0:is_grabbed_by_chaos_spawn()
		local var_48_4 = var_48_0:is_grabbed_by_pack_master() and var_48_0:get_pack_master_grabber() ~= arg_48_0
		local var_48_5 = var_48_0.pack_master_status == "pack_master_hanging"
		local var_48_6 = var_48_0.using_transport
		local var_48_7 = var_48_0.is_ledge_hanging
		local var_48_8 = var_48_0:is_grabbed_by_corruptor()

		if not var_48_1 and not var_48_2 and not var_48_4 and not var_48_5 and not var_48_6 and not var_48_7 and not var_48_3 and not var_48_8 then
			return true
		end
	end

	return false
end

AiUtils.is_of_interest_to_corruptor = function (arg_49_0, arg_49_1)
	if Managers.state.side.side_by_unit[arg_49_0].VALID_ENEMY_TARGETS_PLAYERS_AND_BOTS[arg_49_1] then
		local var_49_0 = ScriptUnit.extension(arg_49_1, "status_system")
		local var_49_1 = var_49_0:is_knocked_down()
		local var_49_2 = var_49_0:is_pounced_down()
		local var_49_3 = var_49_0:is_grabbed_by_chaos_spawn()
		local var_49_4 = var_49_0:is_grabbed_by_corruptor() and var_49_0.corruptor_unit ~= arg_49_0
		local var_49_5 = var_49_0.pack_master_status == "pack_master_hanging"
		local var_49_6 = var_49_0.using_transport
		local var_49_7 = var_49_0.is_ledge_hanging
		local var_49_8 = var_49_0:is_grabbed_by_pack_master()

		if not var_49_1 and not var_49_2 and not var_49_4 and not var_49_5 and not var_49_6 and not var_49_7 and not var_49_3 and not var_49_8 then
			return true
		end
	end

	return false
end

AiUtils.is_of_interest_to_tentacle = function (arg_50_0, arg_50_1)
	local var_50_0 = ScriptUnit.extension(arg_50_0, "status_system")
	local var_50_1 = var_50_0:is_knocked_down()
	local var_50_2 = var_50_0:is_pounced_down()
	local var_50_3 = var_50_0:is_grabbed_by_chaos_spawn()
	local var_50_4 = var_50_0.pack_master_status == "pack_master_hanging"
	local var_50_5 = var_50_0.using_transport
	local var_50_6 = var_50_0.is_ledge_hanging
	local var_50_7 = var_50_0.in_end_zone
	local var_50_8 = var_50_0:is_grabbed_by_corruptor()

	if not var_50_1 and not var_50_2 and not var_50_4 and not var_50_5 and not var_50_6 and not var_50_3 and not var_50_7 and not var_50_8 then
		return true
	end

	return false
end

AiUtils.is_of_interest_to_vortex = function (arg_51_0)
	local var_51_0 = ScriptUnit.extension(arg_51_0, "status_system")
	local var_51_1 = var_51_0:is_knocked_down()
	local var_51_2 = var_51_0:is_pounced_down()
	local var_51_3 = var_51_0:is_grabbed_by_pack_master()
	local var_51_4 = var_51_0.pack_master_status == "pack_master_hanging"
	local var_51_5 = var_51_0.using_transport
	local var_51_6 = var_51_0.is_ledge_hanging
	local var_51_7 = var_51_0:is_grabbed_by_chaos_spawn()
	local var_51_8 = var_51_0:is_in_vortex()
	local var_51_9 = var_51_0.in_end_zone
	local var_51_10 = var_51_0:is_grabbed_by_corruptor()

	if not var_51_1 and not var_51_2 and not var_51_3 and not var_51_4 and not var_51_5 and not var_51_6 and not var_51_7 and not var_51_8 and not var_51_9 and not var_51_10 then
		return true
	end

	return false
end

AiUtils.is_of_interest_plague_wave_sorcerer = function (arg_52_0)
	local var_52_0 = ScriptUnit.has_extension(arg_52_0, "status_system")

	if not var_52_0 then
		return false
	end

	local var_52_1 = var_52_0:is_knocked_down()
	local var_52_2 = var_52_0:is_pounced_down()
	local var_52_3 = var_52_0:is_grabbed_by_pack_master()
	local var_52_4 = var_52_0.pack_master_status == "pack_master_hanging"
	local var_52_5 = var_52_0.using_transport
	local var_52_6 = var_52_0.is_ledge_hanging
	local var_52_7 = var_52_0:is_grabbed_by_chaos_spawn()
	local var_52_8 = var_52_0.overpowered
	local var_52_9 = var_52_0.in_end_zone

	if not var_52_1 and not var_52_2 and not var_52_3 and not var_52_4 and not var_52_5 and not var_52_6 and not var_52_7 and not var_52_8 and not var_52_9 then
		return true
	end

	return false
end

AiUtils.is_of_interest_boss_sorcerer = function (arg_53_0)
	local var_53_0 = ScriptUnit.extension(arg_53_0, "status_system")
	local var_53_1 = var_53_0:is_knocked_down()
	local var_53_2 = var_53_0:is_pounced_down()
	local var_53_3 = var_53_0:is_grabbed_by_pack_master()
	local var_53_4 = var_53_0.pack_master_status == "pack_master_hanging"
	local var_53_5 = var_53_0.using_transport
	local var_53_6 = var_53_0.is_ledge_hanging
	local var_53_7 = var_53_0:is_grabbed_by_chaos_spawn()
	local var_53_8 = var_53_0:is_in_vortex()
	local var_53_9 = var_53_0.overpowered

	if not var_53_1 and not var_53_2 and not var_53_3 and not var_53_4 and not var_53_5 and not var_53_6 and not var_53_7 and not var_53_8 and not var_53_9 then
		return true
	end

	return false
end

AiUtils.is_of_interest_stormfiend_demo = function (arg_54_0)
	return not Managers.player:unit_owner(arg_54_0).bot_player
end

AiUtils.show_polearm = function (arg_55_0, arg_55_1)
	local var_55_0 = 1
	local var_55_1 = Managers.state.unit_storage:go_id(arg_55_0)
	local var_55_2 = Managers.state.network

	if var_55_2:game() then
		var_55_2.network_transmit:send_rpc_all("rpc_ai_show_single_item", var_55_1, var_55_0, arg_55_1)
	end
end

AiUtils.stagger = function (arg_56_0, arg_56_1, arg_56_2, arg_56_3, arg_56_4, arg_56_5, arg_56_6, arg_56_7, arg_56_8, arg_56_9, arg_56_10, arg_56_11, arg_56_12, arg_56_13)
	fassert(arg_56_5 > 0, "Tried to use invalid stagger type %q", arg_56_5)

	local var_56_0 = arg_56_1.stagger and arg_56_1.stagger_type == var_0_0.explosion
	local var_56_1 = arg_56_5 == var_0_0.explosion

	if not arg_56_10 and not arg_56_11 and var_56_0 and not var_56_1 then
		return
	end

	local var_56_2 = arg_56_1.breed

	if var_56_2.boss_staggers and arg_56_5 < var_0_0.explosion then
		return
	end

	local var_56_3 = Managers.state.difficulty:get_difficulty_settings().stagger_modifier

	arg_56_1.pushing_unit = arg_56_2
	arg_56_1.stagger_direction = Vector3Box(arg_56_3)
	arg_56_1.stagger_length = arg_56_4
	arg_56_1.stagger_time = arg_56_6 * var_56_3 + arg_56_8

	local var_56_4 = arg_56_9 or 1

	arg_56_1.stagger = arg_56_1.stagger and arg_56_1.stagger + var_56_4 or var_56_4
	arg_56_1.stagger_type = arg_56_5
	arg_56_1.stagger_animation_scale = arg_56_7
	arg_56_1.always_stagger_suffered = arg_56_10
	arg_56_1.stagger_was_push = arg_56_11

	local var_56_5 = ScriptUnit.has_extension(arg_56_0, "ai_shield_system")

	if var_56_5 and not var_56_5.is_blocking and arg_56_1.attack_token and arg_56_1.stagger and arg_56_1.stagger < 3 then
		arg_56_1.stagger = 3
	end

	if arg_56_0 ~= arg_56_2 and ScriptUnit.has_extension(arg_56_0, "ai_system") then
		local var_56_6 = ScriptUnit.extension(arg_56_0, "ai_system")

		if var_56_2.using_combo and arg_56_10 then
			Unit.set_data(arg_56_2, "last_combo_t", arg_56_8)
		end

		if var_56_2.before_stagger_enter_function then
			var_56_2.before_stagger_enter_function(arg_56_0, arg_56_1, arg_56_2, arg_56_11, var_56_4, arg_56_13)
		end

		if var_56_6.attacked then
			var_56_6:attacked(arg_56_2, arg_56_8)
		end
	end

	if arg_56_12 then
		local var_56_7 = arg_56_1.breed.push_sound_event or "Play_generic_pushed_impact_small"

		Managers.state.entity:system("audio_system"):play_audio_unit_event(var_56_7, arg_56_0)
	end
end

AiUtils.override_stagger = function (arg_57_0, arg_57_1, arg_57_2, arg_57_3, arg_57_4, arg_57_5, arg_57_6, arg_57_7, arg_57_8, arg_57_9)
	local var_57_0 = arg_57_1.active_node

	if not var_57_0 or not var_57_0.stagger_override then
		return false
	end

	if var_57_0:stagger_override(arg_57_0, arg_57_1, arg_57_2, arg_57_3, arg_57_4, arg_57_5, arg_57_6, arg_57_7, arg_57_8, arg_57_9) then
		assert(arg_57_5 > var_0_0.none, "Tried to use invalid stagger type %q", arg_57_5)

		if arg_57_0 ~= arg_57_2 and ScriptUnit.has_extension(arg_57_0, "ai_system") then
			local var_57_1 = ScriptUnit.extension(arg_57_0, "ai_system")

			if var_57_1.attacked then
				var_57_1:attacked(arg_57_2, arg_57_8)
			end
		end

		return true
	end

	return false
end

AiUtils.random = function (arg_58_0, arg_58_1)
	return arg_58_0 + Math.random() * (arg_58_1 - arg_58_0)
end

local var_0_9 = 10
local var_0_10 = 4
local var_0_11 = 8
local var_0_12 = 0

AiUtils.advance_towards_target = function (arg_59_0, arg_59_1, arg_59_2, arg_59_3, arg_59_4, arg_59_5, arg_59_6, arg_59_7, arg_59_8, arg_59_9, arg_59_10)
	local var_59_0 = arg_59_1.target_unit

	if not HEALTH_ALIVE[var_59_0] then
		return
	end

	local var_59_1 = var_0_9
	local var_59_2 = arg_59_4 or var_0_10
	local var_59_3 = arg_59_5 or var_0_11
	local var_59_4 = arg_59_6 or var_0_12

	arg_59_8 = arg_59_8 or 1 - math.random(0, 1) * 2

	local var_59_5 = POSITION_LOOKUP[arg_59_0]
	local var_59_6 = POSITION_LOOKUP[var_59_0]

	for iter_59_0 = 1, 2 do
		for iter_59_1 = 1, var_59_1 do
			local var_59_7 = var_59_4 + math.random(var_59_2 * iter_59_1, var_59_3 * iter_59_1) * arg_59_8
			local var_59_8, var_59_9 = LocomotionUtils.outside_goal(arg_59_1.nav_world, var_59_5, var_59_6, arg_59_2, arg_59_3, var_59_7, 3, arg_59_9, arg_59_10)

			if var_59_8 then
				return var_59_8, var_59_9, arg_59_8
			end
		end

		arg_59_8 = -arg_59_8
	end

	return false
end

AiUtils.temp_anim_event = function (arg_60_0, arg_60_1, arg_60_2)
	local var_60_0 = "temp_anim_event"
	local var_60_1 = Unit.node(arg_60_0, "c_head")
	local var_60_2 = "player_1"
	local var_60_3 = Vector3(255, 0, 0)
	local var_60_4 = Vector3(0, 0, 1)
	local var_60_5 = 0.5
	local var_60_6 = arg_60_1

	if arg_60_2 then
		var_60_6 = arg_60_1 .. ": " .. math.round_with_precision(arg_60_2, 1)
	end

	Managers.state.debug_text:clear_unit_text(arg_60_0, var_60_0)
	Managers.state.debug_text:output_unit_text(var_60_6, var_60_5, arg_60_0, var_60_1, var_60_4, nil, var_60_0, var_60_3, var_60_2)
end

AiUtils.clear_temp_anim_event = function (arg_61_0)
	local var_61_0 = "temp_anim_event"

	Managers.state.debug_text:clear_unit_text(arg_61_0, var_61_0)
end

AiUtils.anim_event = function (arg_62_0, arg_62_1, arg_62_2)
	if arg_62_1.anim_event and arg_62_1.anim_event == arg_62_2 then
		return
	end

	Managers.state.network:anim_event(arg_62_0, arg_62_2)

	arg_62_1.anim_event = arg_62_2
end

AiUtils.get_default_breed_move_speed = function (arg_63_0, arg_63_1)
	local var_63_0
	local var_63_1 = arg_63_1.breed

	if arg_63_1.is_passive then
		var_63_0 = var_63_1.passive_walk_speed or var_63_1.walk_speed
	else
		var_63_0 = var_63_1.run_speed
	end

	return var_63_0
end

AiUtils.clear_anim_event = function (arg_64_0)
	arg_64_0.anim_event = nil
end

AiUtils.set_default_anim_constraint = function (arg_65_0, arg_65_1)
	local var_65_0 = POSITION_LOOKUP[arg_65_0]
	local var_65_1 = Unit.world_rotation(arg_65_0, 0)
	local var_65_2 = var_65_0 + Quaternion.forward(var_65_1) * 5 + Vector3.up() * 1.25

	Unit.animation_set_constraint_target(arg_65_0, arg_65_1, var_65_2)
end

AiUtils.ninja_vanish_when_taking_damage = function (arg_66_0, arg_66_1)
	local var_66_0, var_66_1 = ScriptUnit.extension(arg_66_0, "health_system"):recent_damages()

	if var_66_1 > 0 then
		arg_66_1.ninja_vanish = true
	end
end

AiUtils.initialize_cost_table = function (arg_67_0, arg_67_1)
	for iter_67_0, iter_67_1 in ipairs(LAYER_ID_MAPPING) do
		local var_67_0 = arg_67_1[iter_67_1]

		if var_67_0 == 0 or var_67_0 == nil then
			GwNavTagLayerCostTable.forbid_layer(arg_67_0, iter_67_0)
		else
			GwNavTagLayerCostTable.allow_layer(arg_67_0, iter_67_0)
			GwNavTagLayerCostTable.set_layer_cost_multiplier(arg_67_0, iter_67_0, var_67_0)
		end
	end
end

AiUtils.initialize_nav_cost_map_cost_table = function (arg_68_0, arg_68_1, arg_68_2)
	for iter_68_0, iter_68_1 in ipairs(NAV_COST_MAP_LAYER_ID_MAPPING) do
		local var_68_0 = arg_68_1 and arg_68_1[iter_68_1] or arg_68_2 or 0

		GwNavCostMap.cost_table_set_cost(arg_68_0, iter_68_0, var_68_0)
	end
end

AiUtils.kill_unit = function (arg_69_0, arg_69_1, arg_69_2, arg_69_3, arg_69_4, arg_69_5)
	local var_69_0 = NetworkConstants.damage.max

	arg_69_1 = arg_69_1 or arg_69_0

	if HEALTH_ALIVE[arg_69_0] then
		arg_69_2 = arg_69_2 or "full"
		arg_69_3 = arg_69_3 or "kinetic"
		arg_69_5 = arg_69_5 or "suicide"
		arg_69_4 = arg_69_4 or Vector3(0, 0, 1)

		local var_69_1 = ScriptUnit.extension(arg_69_0, "health_system"):current_health()
		local var_69_2 = true

		for iter_69_0 = 1, math.ceil(var_69_1 / var_69_0) do
			DamageUtils.add_damage_network(arg_69_0, arg_69_1, var_69_0, arg_69_2, arg_69_3, nil, arg_69_4, arg_69_5, nil, nil, nil, nil, false, false, nil, nil, nil, var_69_2, 1)
		end
	end
end

local var_0_13 = {
	ranged = 1,
	melee = 1,
	grenade = 1
}

AiUtils.update_aggro = function (arg_70_0, arg_70_1, arg_70_2, arg_70_3, arg_70_4)
	local var_70_0 = arg_70_1.aggro_list
	local var_70_1, var_70_2 = ScriptUnit.extension(arg_70_0, "health_system"):recent_damages()
	local var_70_3 = arg_70_4 * arg_70_2.perception_weights.aggro_decay_per_sec

	for iter_70_0, iter_70_1 in pairs(var_70_0) do
		var_70_0[iter_70_0] = math.clamp(iter_70_1 - var_70_3, 0, 100)
	end

	local var_70_4 = arg_70_2.perception_weights.aggro_multipliers or var_0_13

	if var_70_2 > 0 then
		local var_70_5 = DamageDataIndex.STRIDE
		local var_70_6 = 0

		for iter_70_2 = 1, var_70_2 / var_70_5 do
			local var_70_7 = var_70_1[var_70_6 + DamageDataIndex.ATTACKER]
			local var_70_8 = var_70_1[var_70_6 + DamageDataIndex.DAMAGE_AMOUNT]
			local var_70_9 = var_70_1[var_70_6 + DamageDataIndex.DAMAGE_SOURCE_NAME]
			local var_70_10 = rawget(ItemMasterList, var_70_9)

			if var_70_10 then
				var_70_8 = var_70_8 * (var_70_4[var_70_10.slot_type] or 1)
			end

			local var_70_11 = var_70_0[var_70_7]

			if var_70_11 then
				var_70_0[var_70_7] = var_70_11 + var_70_8
			else
				var_70_0[var_70_7] = var_70_8
			end

			var_70_6 = var_70_6 + var_70_5
		end
	end
end

AiUtils.debug_bot_transitions = function (arg_71_0, arg_71_1, arg_71_2, arg_71_3)
	local var_71_0 = 16
	local var_71_1 = "arial"
	local var_71_2 = "materials/fonts/" .. var_71_1
	local var_71_3 = RESOLUTION_LOOKUP.res_w
	local var_71_4 = RESOLUTION_LOOKUP.res_h
	local var_71_5 = 20
	local var_71_6 = 20
	local var_71_7 = 330
	local var_71_8 = 20

	arg_71_2 = arg_71_2 + var_71_5 + 20
	arg_71_3 = arg_71_3 + var_71_6 + 20

	local var_71_9 = arg_71_3
	local var_71_10 = Colors.get_color_with_alpha("lavender", 255)
	local var_71_11 = Colors.get_color_with_alpha("sky_blue", 255)
	local var_71_12 = Colors.get_color_with_alpha("orange", 255)

	ScriptGUI.ictext(arg_71_0, var_71_3, var_71_4, "BOT TRANSITIONS: ", var_71_2, var_71_0, var_71_1, arg_71_2 - 10, var_71_9, var_71_8, var_71_12)

	local var_71_13 = var_71_9 + 20
	local var_71_14 = Managers.player:human_and_bot_players()

	for iter_71_0, iter_71_1 in pairs(var_71_14) do
		if iter_71_1.bot_player then
			local var_71_15 = iter_71_1.player_unit

			if ALIVE[var_71_15] then
				local var_71_16 = iter_71_1:profile_index()
				local var_71_17 = SPProfiles[var_71_16]
				local var_71_18 = var_71_17 and var_71_17.unit_name
				local var_71_19 = ScriptUnit.extension(var_71_15, "ai_navigation_system")._active_nav_transitions
				local var_71_20 = "[" .. var_71_18 .. "]"

				ScriptGUI.ictext(arg_71_0, var_71_3, var_71_4, var_71_20, var_71_2, var_71_0, var_71_1, arg_71_2 - 10, var_71_13, var_71_8, var_71_10)

				var_71_13 = var_71_13 + 20
				k = 1

				for iter_71_2, iter_71_3 in pairs(var_71_19) do
					local var_71_21 = string.format("    %d) %s", k, tostring(Unit.debug_name(iter_71_2)))

					ScriptGUI.ictext(arg_71_0, var_71_3, var_71_4, var_71_21, var_71_2, var_71_0, var_71_1, arg_71_2 - 10, var_71_13, var_71_8, var_71_11)

					var_71_13 = var_71_13 + 20
					k = k + 1
				end
			end
		end
	end

	local var_71_22 = var_71_13 + 20

	ScriptGUI.icrect(arg_71_0, var_71_3, var_71_4, var_71_5, var_71_6, arg_71_2 + var_71_7, var_71_22, var_71_8 - 1, Color(200, 20, 20, 20))
end

AiUtils.push_intersecting_players = function (arg_72_0, arg_72_1, arg_72_2, arg_72_3, arg_72_4, arg_72_5, arg_72_6, ...)
	local var_72_0 = Quaternion.forward(Unit.local_rotation(arg_72_0, 0))
	local var_72_1 = Unit.local_position(arg_72_0, 0)
	local var_72_2 = var_72_1 + var_72_0 * arg_72_3.push_forward_offset
	local var_72_3 = arg_72_3.push_width * 1.5
	local var_72_4 = arg_72_3.dodged_width and arg_72_3.dodged_width * 1.5
	local var_72_5 = var_72_1 + var_72_0 * 3
	local var_72_6 = HEALTH_ALIVE[arg_72_1] and arg_72_1 or HEALTH_ALIVE[arg_72_0] and arg_72_0
	local var_72_7 = Managers.state.side.side_by_unit[var_72_6]
	local var_72_8 = var_72_7 and var_72_7.ENEMY_PLAYER_AND_BOT_UNITS

	if var_72_8 then
		for iter_72_0 = 1, #var_72_8 do
			local var_72_9 = var_72_3
			local var_72_10 = var_72_8[iter_72_0]

			if arg_72_2[var_72_10] then
				if arg_72_4 > arg_72_2[var_72_10] then
					arg_72_2[var_72_10] = nil
				end
			else
				local var_72_11 = Unit.local_position(var_72_10, 0)
				local var_72_12 = var_72_11 - var_72_2

				if var_72_4 then
					local var_72_13 = ScriptUnit.has_extension(var_72_10, "status_system")

					if var_72_13 and var_72_13:get_is_dodging() then
						var_72_9 = var_72_4
					end
				end

				if var_72_9 > Vector3.length(var_72_12) then
					local var_72_14 = arg_72_3.push_width * arg_72_3.push_width
					local var_72_15 = Geometry.closest_point_on_line(var_72_11, var_72_1, var_72_5)
					local var_72_16 = var_72_11 - var_72_15

					if var_72_14 > Vector3.length_squared(var_72_16) then
						local var_72_17 = Vector3.distance(var_72_1, var_72_15)

						if var_72_17 < arg_72_3.ahead_dist and not ScriptUnit.has_extension(var_72_10, "status_system").knocked_down then
							if not arg_72_2[var_72_10] then
								local var_72_18 = arg_72_3.player_pushed_speed * Vector3.normalize(var_72_11 - var_72_1)
								local var_72_19 = ScriptUnit.extension(var_72_10, "locomotion_system")
								local var_72_20 = 1 - var_72_17 / arg_72_3.ahead_dist
								local var_72_21 = var_72_20 * var_72_20

								var_72_19:add_external_velocity(var_72_18 * var_72_21)

								if arg_72_6 then
									arg_72_6(var_72_10, arg_72_0, ...)
								end
							end

							arg_72_2[var_72_10] = arg_72_4 + 0.1
						end
					end
				end
			end
		end
	end
end

AiUtils.set_material_property = function (arg_73_0, arg_73_1, arg_73_2, arg_73_3, arg_73_4, arg_73_5)
	if arg_73_4 then
		local var_73_0

		for iter_73_0 = 0, Unit.num_meshes(arg_73_0) - 1 do
			local var_73_1 = Unit.mesh(arg_73_0, iter_73_0)

			if Mesh.has_material(var_73_1, arg_73_2) then
				local var_73_2 = Mesh.material(var_73_1, arg_73_2)

				Material.set_scalar(var_73_2, arg_73_1, arg_73_3)
			end
		end
	else
		local var_73_3 = Unit.mesh(arg_73_0, arg_73_5)
		local var_73_4 = Mesh.material(var_73_3, arg_73_2)

		Material.set_scalar(var_73_4, arg_73_1, arg_73_3)
	end
end

AiUtils.allow_smart_object_layers = function (arg_74_0, arg_74_1)
	arg_74_0:allow_layer("ledges", arg_74_1)
	arg_74_0:allow_layer("ledges_with_fence", arg_74_1)
	arg_74_0:allow_layer("doors", arg_74_1)
	arg_74_0:allow_layer("planks", arg_74_1)
	arg_74_0:allow_layer("jumps", arg_74_1)
	arg_74_0:allow_layer("teleporters", arg_74_1)
end

AiUtils.shield_user = function (arg_75_0)
	if not ScriptUnit.has_extension(arg_75_0, "ai_shield_system") then
		return false
	end

	return not ScriptUnit.extension(arg_75_0, "ai_shield_system").broken_shield
end

AiUtils.attack_is_shield_blocked = function (arg_76_0, arg_76_1, arg_76_2, arg_76_3)
	assert(arg_76_1)

	if not ScriptUnit.has_extension(arg_76_0, "ai_shield_system") then
		return false
	end

	return (ScriptUnit.extension(arg_76_0, "ai_shield_system"):can_block_attack(arg_76_1, arg_76_2, arg_76_3))
end

AiUtils.attack_is_dodged = function (arg_77_0)
	local var_77_0 = Managers.state.unit_storage:go_id(arg_77_0)
	local var_77_1 = Managers.state.network:game()

	return (GameSession.game_object_field(var_77_1, var_77_0, "is_dodging"))
end

AiUtils.unit_is_flanking_player = function (arg_78_0, arg_78_1, arg_78_2)
	local var_78_0 = Managers.state.network
	local var_78_1 = var_78_0:unit_game_object_id(arg_78_1)
	local var_78_2 = var_78_0:game()

	if var_78_2 and var_78_1 then
		local var_78_3 = Vector3.normalize(POSITION_LOOKUP[arg_78_0] - POSITION_LOOKUP[arg_78_1])
		local var_78_4 = arg_78_2 or GameSession.game_object_field(var_78_2, var_78_1, "aim_direction")
		local var_78_5 = Quaternion.forward(Quaternion.look(var_78_4))

		return Vector3.dot(var_78_3, var_78_5) < 0.4
	end

	return false
end

local var_0_14 = 0.0001

AiUtils.remove_bad_boxed_spline_points = function (arg_79_0, arg_79_1)
	local var_79_0 = {}
	local var_79_1 = arg_79_0[1]:unbox()
	local var_79_2

	var_79_0[1] = var_79_1

	for iter_79_0 = 2, #arg_79_0 do
		local var_79_3 = arg_79_0[iter_79_0]:unbox()

		if Vector3.distance_squared(var_79_1, var_79_3) > var_0_14 then
			var_79_0[#var_79_0 + 1] = var_79_3
			var_79_1 = var_79_3
		else
			print("SPLINE HAS FAULTY POINTS (create_formation_data):", arg_79_1, iter_79_0)
		end
	end

	return var_79_0
end

AiUtils.remove_bad_spline_points = function (arg_80_0, arg_80_1)
	local var_80_0 = {}
	local var_80_1 = arg_80_0[1]
	local var_80_2

	var_80_0[1] = var_80_1

	for iter_80_0 = 2, #arg_80_0 do
		local var_80_3 = arg_80_0[iter_80_0]

		if Vector3.distance_squared(var_80_1, var_80_3) > var_0_14 then
			var_80_0[#var_80_0 + 1] = var_80_3
			var_80_1 = var_80_3
		else
			print("SPLINE HAS FAULTY POINTS (create_formation_data):", arg_80_1, iter_80_0)
		end
	end

	return var_80_0
end

AiUtils.get_combat_conditions = function (arg_81_0)
	local var_81_0 = arg_81_0.target_unit

	if var_81_0 then
		local var_81_1 = #arg_81_0.proximite_enemies
		local var_81_2 = Unit.get_data(var_81_0, "breed")

		return {
			enemy_arc = var_81_1 > 3 and 2 or var_81_1 > 1 and 1 or 0,
			target_armor = var_81_2 and (var_81_2.primary_armor_category or var_81_2.armor_category) or 1
		}
	end

	return nil
end

local var_0_15 = 5
local var_0_16 = {
	tap_attack = {
		speed_mod = 1.2,
		arc = 0,
		max_range = var_0_15,
		armor_modifiers = {
			0.1,
			0.1,
			0.1,
			0.1,
			0.1,
			0.1
		}
	},
	hold_attack = {
		speed_mod = 0.8,
		arc = 2,
		max_range = var_0_15,
		armor_modifiers = {
			0.1,
			0.1,
			0.1,
			0.1,
			0.1,
			0.1
		}
	}
}
local var_0_17 = 2
local var_0_18 = {
	0,
	0.2,
	0.4
}
local var_0_19 = {
	0.5,
	2,
	1.5,
	1,
	1.3,
	2
}
local var_0_20 = {
	1,
	-1,
	0,
	0,
	0,
	-2
}
local var_0_21 = math.abs

AiUtils.get_melee_weapon_score = function (arg_82_0, arg_82_1)
	local var_82_0 = arg_82_1 and arg_82_1.attack_meta_data or var_0_16
	local var_82_1 = -1
	local var_82_2 = "tap_attack"
	local var_82_3 = var_82_0[var_82_2]

	if arg_82_0 then
		for iter_82_0, iter_82_1 in pairs(var_82_0) do
			local var_82_4 = 0
			local var_82_5 = arg_82_0.target_armor
			local var_82_6 = math.clamp(arg_82_0.enemy_arc + var_0_20[var_82_5], 0, 2)
			local var_82_7 = 1 - var_0_21(var_82_6 - iter_82_1.arc) / var_0_17
			local var_82_8 = var_82_4 + var_0_18[var_82_6 + 1] * var_82_7
			local var_82_9 = iter_82_1.armor_modifiers

			if var_82_9 then
				var_82_8 = var_82_8 + (var_82_9[var_82_5] or 0) * (var_0_19[var_82_5] or 1) * (iter_82_1.speed_mod or 1)
			end

			if var_82_1 < var_82_8 then
				var_82_1 = var_82_8
				var_82_2 = iter_82_0
				var_82_3 = iter_82_1
			end
		end
	end

	return var_82_2, var_82_3, var_82_1
end

local var_0_22 = 0
local var_0_23 = 30 - var_0_22

AiUtils.get_party_danger = function ()
	local var_83_0 = Managers.state.conflict

	if var_83_0 then
		local var_83_1 = var_83_0:get_threat_value()

		return math.clamp((var_83_1 - var_0_22) / var_0_23, 0, 1)
	end

	return 0
end

AiUtils.get_bot_weapon_extension = function (arg_84_0)
	if arg_84_0 then
		local var_84_0 = arg_84_0.inventory_extension
		local var_84_1, var_84_2, var_84_3 = CharacterStateHelper.get_item_data_and_weapon_extensions(var_84_0)
		local var_84_4, var_84_5, var_84_6 = CharacterStateHelper.get_current_action_data(var_84_3, var_84_2)

		if var_84_5 then
			return var_84_5
		end

		local var_84_7 = var_84_1 and BackendUtils.get_item_template(var_84_1)

		if var_84_7 and var_84_7.dominant_left then
			return var_84_3 or var_84_2
		else
			return var_84_2 or var_84_3
		end
	end

	return nil
end

AiUtils.taunt_unit = function (arg_85_0, arg_85_1, arg_85_2, arg_85_3)
	local var_85_0 = var_0_6[arg_85_0]

	if var_85_0 then
		local var_85_1 = var_85_0.breed

		if var_85_1 and not var_85_1.ignore_taunts and (not var_85_1.boss or arg_85_3) then
			local var_85_2 = Managers.time:time("game")
			local var_85_3 = var_85_2 + arg_85_2

			if var_85_0.taunt_unit == arg_85_1 then
				var_85_0.taunt_end_time = var_85_3
			else
				if var_85_0.target_unit == arg_85_1 then
					var_85_0.no_taunt_hesitate = true
				end

				var_85_0.taunt_unit = arg_85_1
				var_85_0.taunt_end_time = var_85_3
				var_85_0.target_unit = arg_85_1
				var_85_0.target_unit_found_time = var_85_2
			end
		end
	end
end

AiUtils.taunt_nearby_units = function (arg_86_0, arg_86_1, arg_86_2, arg_86_3, arg_86_4, arg_86_5)
	local var_86_0 = Managers.state.side.side_by_unit[arg_86_0]
	local var_86_1 = POSITION_LOOKUP[arg_86_0]
	local var_86_2 = FrameTable.alloc_table()
	local var_86_3 = var_86_0.enemy_broadphase_categories
	local var_86_4 = AiUtils.broadphase_query(var_86_1, arg_86_1, var_86_2, var_86_3)

	for iter_86_0 = 1, var_86_4 do
		local var_86_5 = var_86_2[iter_86_0]
		local var_86_6 = var_0_6[var_86_5]
		local var_86_7 = var_86_6.override_targets

		table.clear(var_86_7)

		var_86_6.target_unit = nil
		var_86_7[arg_86_0] = arg_86_3 + arg_86_2
	end

	if arg_86_4 then
		local var_86_8 = NetworkLookup.effects[arg_86_4]
		local var_86_9 = 0
		local var_86_10 = false

		Managers.state.network:rpc_play_particle_effect_no_rotation(nil, var_86_8, NetworkConstants.invalid_game_object_id, var_86_9, var_86_1, var_86_10)
	end

	if arg_86_5 then
		Managers.state.entity:system("audio_system"):play_audio_unit_event(arg_86_5, arg_86_0)
	end

	return var_86_2
end

AiUtils.calculate_animation_movespeed = function (arg_87_0, arg_87_1, arg_87_2, arg_87_3)
	local var_87_0 = arg_87_0[1].value
	local var_87_1 = POSITION_LOOKUP[arg_87_1]
	local var_87_2 = POSITION_LOOKUP[arg_87_2]
	local var_87_3 = Vector3.distance(var_87_1, var_87_2)

	if var_87_3 > math.epsilon then
		local var_87_4 = ScriptUnit.has_extension(arg_87_2, "locomotion_system")

		if var_87_4 and var_87_4.current_velocity then
			local var_87_5 = var_87_4:current_velocity()

			if Vector3.length_squared(var_87_5) > 0 then
				local var_87_6 = var_87_5 * (1 + (arg_87_3 or 1))
				local var_87_7 = ScriptUnit.extension(arg_87_1, "locomotion_system"):current_velocity()
				local var_87_8 = Vector3.length(var_87_7)

				if var_87_8 > 0 then
					local var_87_9 = var_87_6
					local var_87_10 = Vector3.normalize(var_87_2 - var_87_1) * Vector3.length(var_87_6)
					local var_87_11 = Vector3.dot(var_87_9, var_87_10) / var_87_3 * var_87_10

					var_87_3 = var_87_3 + Vector3.length(var_87_11 / var_87_8)
				end
			end
		end
	end

	local var_87_12 = var_87_0
	local var_87_13 = #arg_87_0

	for iter_87_0 = 1, var_87_13 do
		local var_87_14 = arg_87_0[iter_87_0]
		local var_87_15 = var_87_14.distance
		local var_87_16 = var_87_14.value

		if iter_87_0 < var_87_13 then
			local var_87_17 = arg_87_0[iter_87_0 + 1]
			local var_87_18 = var_87_17.distance
			local var_87_19 = var_87_17.value

			if var_87_18 < var_87_3 then
				local var_87_20 = math.inv_lerp(var_87_15, var_87_18, var_87_3)

				var_87_12 = math.lerp_clamped(var_87_16, var_87_19, var_87_20)

				break
			end
		else
			var_87_12 = var_87_16
		end
	end

	return var_87_12
end

AiUtils.magic_entrance_optional_spawned_func = function (arg_88_0, arg_88_1, arg_88_2)
	if not arg_88_1.special and not arg_88_1.boss and not arg_88_1.cannot_be_aggroed then
		local var_88_0 = PlayerUtils.get_random_alive_hero()

		AiUtils.aggro_unit_of_enemy(arg_88_0, var_88_0)
	end

	local var_88_1 = "fx/grudge_marks_shadow_step"
	local var_88_2 = NetworkLookup.effects[var_88_1]
	local var_88_3 = 0

	Managers.state.network:rpc_play_particle_effect_no_rotation(nil, var_88_2, NetworkConstants.invalid_game_object_id, var_88_3, POSITION_LOOKUP[arg_88_0], false)

	local var_88_4 = var_0_6[arg_88_0]

	if var_88_4 then
		Managers.state.entity:system("audio_system"):play_audio_unit_event("Play_normal_spawn_stinger", arg_88_0)

		local var_88_5 = Quaternion.forward(Quaternion.axis_angle(Vector3.up(), math.pi * 2 * math.random()))
		local var_88_6 = 0.5
		local var_88_7 = var_0_0.medium
		local var_88_8 = 0.5
		local var_88_9 = Managers.time:time("game")

		AiUtils.stagger(arg_88_0, var_88_4, arg_88_0, var_88_5, var_88_6, var_88_7, var_88_8, nil, var_88_9)
	end
end

AiUtils.is_part_of_patrol = function (arg_89_0)
	local var_89_0 = Managers.state.unit_storage:go_id(arg_89_0)

	if not var_89_0 then
		return false
	end

	if not ScriptUnit.has_extension(arg_89_0, "ai_group_system") then
		return false
	end

	local var_89_1 = Managers.state.network:game()

	return GameSession.game_object_field(var_89_1, var_89_0, "ai_group_id") ~= AIGroupSystem.invalid_group_uid
end

AiUtils.is_aggroed = function (arg_90_0)
	local var_90_0 = Managers.state.unit_storage:go_id(arg_90_0)

	if not var_90_0 then
		return false
	end

	local var_90_1 = Managers.state.network:game()

	return GameSession.game_object_field(var_90_1, var_90_0, "target_unit_id") ~= NetworkConstants.invalid_game_object_id
end

AiUtils.breed_height = function (arg_91_0)
	local var_91_0 = var_0_6[arg_91_0]
	local var_91_1 = (var_91_0 and var_91_0.breed or Unit.get_data(arg_91_0, "breed")).height

	if not var_91_1 then
		return nil
	end

	return var_91_1 * Unit.local_scale(arg_91_0, 0)[3]
end

local var_0_24 = 1
local var_0_25 = {
	"j_hips",
	"j_leftforearm",
	"j_rightforearm",
	"j_head"
}
local var_0_26 = #var_0_25

local function var_0_27(arg_92_0, arg_92_1, arg_92_2)
	local var_92_0 = var_0_25[arg_92_2]
	local var_92_1 = Unit.has_node(arg_92_1, var_92_0)
	local var_92_2

	if var_92_1 then
		local var_92_3 = Unit.node(arg_92_1, var_92_0)
		local var_92_4 = World.get_data(Unit.world(arg_92_1), "physics_world")
		local var_92_5 = Unit.world_position(arg_92_1, var_92_3)
		local var_92_6 = Vector3.distance(arg_92_0, var_92_5)
		local var_92_7 = var_92_5

		if var_92_6 > var_0_24 then
			local var_92_8 = (var_92_5 - arg_92_0) / var_92_6
			local var_92_9, var_92_10 = PhysicsWorld.immediate_raycast(var_92_4, arg_92_0, var_92_8, var_92_6, "closest", "types", "statics", "collision_filter", "filter_ai_line_of_sight_check")

			if var_92_9 then
				return false
			end
		end
	end

	return true
end

AiUtils.line_of_sight_from_random_point = function (arg_93_0, arg_93_1, arg_93_2, arg_93_3)
	local var_93_0 = math.min(arg_93_2 or 1, var_0_26)
	local var_93_1 = arg_93_3 or math.random(1, var_0_26)
	local var_93_2

	for iter_93_0 = 1, var_93_0 do
		var_93_2 = math.index_wrapper(var_93_1 + iter_93_0 - 1, var_0_26)

		if var_0_27(arg_93_0, arg_93_1, var_93_2) then
			return true
		end
	end

	return false, var_93_2
end

AiUtils.bot_melee_aim_pos = function (arg_94_0, arg_94_1, arg_94_2)
	local var_94_0 = var_0_6[arg_94_1]
	local var_94_1 = var_94_0 and var_94_0.breed
	local var_94_2 = var_94_1 and (var_94_1.bot_melee_aim_node or "j_spine") or "rp_center"
	local var_94_3 = Unit.local_position(arg_94_0, 0)
	local var_94_4

	if type(var_94_2) == "table" then
		local var_94_5 = math.huge
		local var_94_6

		for iter_94_0 = 1, #var_94_2 do
			local var_94_7 = var_94_2[iter_94_0]

			if Unit.has_node(arg_94_1, var_94_7) then
				local var_94_8 = Unit.world_position(arg_94_1, Unit.node(arg_94_1, var_94_7))
				local var_94_9 = Vector3.distance_squared(var_94_3, var_94_8)

				if var_94_9 < var_94_5 then
					var_94_6 = var_94_8
					var_94_5 = var_94_9
				end
			end
		end

		var_94_4 = var_94_6 or Unit.world_position(arg_94_1, 0)
	else
		var_94_4 = Unit.has_node(arg_94_1, var_94_2) and Unit.world_position(arg_94_1, Unit.node(arg_94_1, var_94_2)) or Unit.world_position(arg_94_1, 0)
	end

	if arg_94_2 then
		arg_94_2:store(var_94_4)
	end

	return var_94_4
end
