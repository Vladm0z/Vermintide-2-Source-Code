-- chunkname: @scripts/unit_extensions/human/ai_player_unit/ai_utils.lua

local scripts_utils_stagger_types = require("scripts/utils/stagger_types")

require("scripts/entity_system/systems/behaviour/utility/utility")

local get_data = Unit.get_data
local script_data = script_data
local alive = Unit.alive
local local_rotation = Unit.local_rotation
local animation_event = Unit.animation_event
local BLACKBOARDS = BLACKBOARDS

function aiprint(...)
	-- function 1
	if not script_data.debug_ai_movement then
		print(...)
	end
end

local AiUtils = AiUtils

AiUtils = AiUtils or {}
AiUtils = AiUtils
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
	-- function 2
	return bit.band(arg_2_0, arg_2_1) == arg_2_0
end

AiUtils.special_dead_cleanup = function (arg_3_0, arg_3_1)
	-- function 3
	if not arg_3_1.target_unit then
		return
	end

	arg_3_1.group_blackboard.special_targets[arg_3_1.target_unit] = nil
	arg_3_1.group_blackboard.disabled_by_special[arg_3_1.target_unit] = nil
end

AiUtils.aggro_unit_of_enemy = function (arg_4_0, arg_4_1)
	-- function 4
	arg_4_1 = AiUtils.get_actual_attacker_unit(arg_4_1)

	if not ALIVE[arg_4_1] then
		return
	end

	local has_extension = ScriptUnit.has_extension(arg_4_0, "ai_system")

	if not has_extension then
		has_extension:enemy_aggro(arg_4_0, arg_4_1)
	end
end

AiUtils.activate_unit = function (self)
	-- function 5
	if not self.activation_lock then
		return
	end

	local breed = self.breed

	if not (self.confirmed_player_sighting or breed.ignore_activate_unit) then
		local unit = self.unit

		if not HEALTH_ALIVE[unit] then
			return
		end

		Managers.state.event:trigger("ai_unit_activated", unit, breed.name, self.master_event_id)

		self.confirmed_player_sighting = true
		self.activated = true
	end
end

AiUtils.deactivate_unit = function (self)
	-- function 6
	if not self.confirmed_player_sighting then
		local breed = self.breed
		local unit = self.unit

		Managers.state.event:trigger("ai_unit_deactivated", unit, breed.name, self.master_event_id)

		self.confirmed_player_sighting = false
		self.activated = false
	end
end

AiUtils.enter_combat = function (arg_7_0, arg_7_1)
	-- function 7
	Managers.state.network:anim_event(arg_7_0, "to_combat")

	arg_7_1.in_combat = true
end

AiUtils.enter_passive = function (arg_8_0, arg_8_1)
	-- function 8
	Managers.state.network:anim_event(arg_8_0, "to_passive")

	arg_8_1.in_combat = false
end

AiUtils.in_combat = function (self)
	-- function 9
	return self.in_combat
end

AiUtils.stormvermin_champion_hack_check_ward = function (arg_10_0, arg_10_1)
	-- function 10
	if not (not arg_10_1.ward_active and arg_10_1.defensive_mode_duration) then
		arg_10_1.ward_active = false

		AiUtils.stormvermin_champion_set_ward_state(arg_10_0, false, true)
	end
end

AiUtils.stormvermin_champion_set_ward_state = function (arg_11_0, arg_11_1, arg_11_2)
	-- function 11
	local actor = Unit.actor(arg_11_0, "c_trophy_rack_ward")

	if not actor then
		Actor.set_scene_query_enabled(actor, arg_11_1)
	end

	if not arg_11_1 then
		Unit.flow_event(arg_11_0, "skulls_glow_on")
	else
		Unit.flow_event(arg_11_0, "skulls_glow_off")
	end

	if not arg_11_2 then
		local network = Managers.state.network
		local unit_game_object_id = network:unit_game_object_id(arg_11_0)

		network.network_transmit:send_rpc_clients("rpc_set_ward_state", unit_game_object_id, arg_11_1)
	end
end

AiUtils.chaos_exalted_champion_set_shield_state = function (arg_12_0, arg_12_1, arg_12_2)
	-- function 12
	if not arg_12_1 then
		Unit.flow_event(arg_12_0, "chaos_shields_on")
	else
		Unit.flow_event(arg_12_0, "chaos_shields_off")
	end
end

AiUtils.alert_unit_of_enemy = function (arg_13_0, arg_13_1)
	-- function 13
	arg_13_1 = AiUtils.get_actual_attacker_unit(arg_13_1)

	if not HEALTH_ALIVE[arg_13_1] then
		return
	end

	local has_extension = ScriptUnit.has_extension(arg_13_0, "ai_system")

	if not has_extension then
		has_extension:enemy_alert(arg_13_0, arg_13_1)
	end
end

AiUtils.alert_unit = function (arg_14_0, arg_14_1)
	-- function 14
	local network = Managers.state.network

	if not network.is_server then
		AiUtils.alert_unit_of_enemy(arg_14_1, arg_14_0)
	else
		local unit_game_object_id = network:unit_game_object_id(arg_14_0)
		local unit_game_object_id_2 = network:unit_game_object_id(arg_14_1)

		network.network_transmit:send_rpc_server("rpc_alert_enemy", unit_game_object_id_2, unit_game_object_id)
	end
end

local tbl = {}

AiUtils.alert_nearby_friends_of_enemy = function (arg_15_0, arg_15_1, arg_15_2, arg_15_3)
	-- function 15
	arg_15_3 = arg_15_3 or 5
	arg_15_2 = AiUtils.get_actual_attacker_unit(arg_15_2)

	if not ALIVE[arg_15_2] then
		return
	end

	local query = Broadphase.query(arg_15_1, Unit.local_position(arg_15_0, 0), arg_15_3, tbl)

	for i = 1, query do
		local var_15_1 = tbl[i]

		if var_15_1 ~= arg_15_0 then
			local has_extension = ScriptUnit.has_extension(var_15_1, "ai_system")

			if not has_extension then
				has_extension:enemy_alert(arg_15_0, arg_15_2)
			end
		end

		tbl[i] = nil
	end
end

AiUtils.print = function (arg_16_0, ...)
	-- function 16
	if not Development.parameter(arg_16_0) then
		print(...)
	end
end

AiUtils.printf = function (arg_17_0, ...)
	-- function 17
	if not Development.parameter(arg_17_0) then
		printf(...)
	end
end

AiUtils.breed_name = function (arg_18_0)
	-- function 18
	return Unit.get_data(arg_18_0, "breed").name
end

AiUtils.stagger_target = function (arg_19_0, arg_19_1, arg_19_2, arg_19_3, arg_19_4, arg_19_5, arg_19_6, arg_19_7, arg_19_8, arg_19_9)
	-- function 19
	local calculate_stagger, var_19_1 = DamageUtils.calculate_stagger(arg_19_3, arg_19_6, arg_19_1, arg_19_0, arg_19_7, arg_19_8, arg_19_9)

	if calculate_stagger > 0 then
		local var_19_2 = BLACKBOARDS[arg_19_1]

		AiUtils.stagger(arg_19_1, var_19_2, arg_19_0, arg_19_4, arg_19_2, calculate_stagger, var_19_1, nil, arg_19_5)
	end
end

AiUtils.calculate_ai_stagger_strength = function (self, arg_20_1, arg_20_2, arg_20_3, arg_20_4, arg_20_5)
	-- function 20
	local ai_toughness_break_t = arg_20_1.ai_toughness_break_t

	ai_toughness_break_t = ai_toughness_break_t or 0

	local num = arg_20_2 - ai_toughness_break_t
	local max = math.max
	local ai_toughness_break = arg_20_1.ai_toughness_break

	ai_toughness_break = ai_toughness_break or 0

	local var_20_4 = max(ai_toughness_break - num, 0)
	local ai_toughness = arg_20_1.breed.ai_toughness

	ai_toughness = ai_toughness or 0

	local num_2 = ai_toughness - var_20_4
	local ai_strength = self.breed.ai_strength

	ai_strength = ai_strength or 0

	local round = math.round(math.clamp(ai_strength - num_2, scripts_utils_stagger_types.none, scripts_utils_stagger_types.heavy))

	if not arg_20_3 then
		arg_20_1.ai_toughness_break = var_20_4 + ai_strength
		arg_20_1.ai_toughness_break_t = arg_20_2

		if not (not arg_20_4 and not (arg_20_4 <= round)) then
			arg_20_1.ai_toughness_break = arg_20_1.ai_toughness_break * arg_20_5
		end
	end

	return round
end

AiUtils.calculate_ai_stagger_impact = function (arg_21_0)
	-- function 21
	local num = (0.15 + 0.1 * math.random()) * arg_21_0

	return {
		arg_21_0
	}, num
end

AiUtils.damage_target = function (arg_22_0, arg_22_1, arg_22_2, arg_22_3, arg_22_4)
	-- function 22
	arg_22_3 = DamageUtils.calculate_damage(arg_22_3, arg_22_0, arg_22_1)

	local var_22_0 = POSITION_LOOKUP[arg_22_1]

	var_22_0 = var_22_0 or Unit.world_position(arg_22_1, 0)

	local var_22_1 = POSITION_LOOKUP[arg_22_0]

	var_22_1 = var_22_1 or Unit.world_position(arg_22_0, 0)

	local normalize = Vector3.normalize(var_22_1 - var_22_0)
	local game_object_or_level_id, var_22_4 = Managers.state.network:game_object_or_level_id(arg_22_0)

	arg_22_4 = arg_22_4 or AiUtils.breed_name(arg_22_1)

	local var_22_5
	local var_22_6
	local var_22_7 = BLACKBOARDS[arg_22_1]
	local flag = not var_22_7 and var_22_7.commander_unit

	if not var_22_4 then
		var_22_5 = DamageUtils.add_damage_network(arg_22_0, arg_22_1, arg_22_3, "torso", arg_22_2.damage_type, nil, normalize, arg_22_4, nil, flag, nil, arg_22_2.hit_react_type, nil, nil, nil, nil, nil, nil, 1)
	else
		local difficulty = Managers.state.difficulty
		local get_difficulty_settings = difficulty:get_difficulty_settings()
		local diminishing_damage = arg_22_2.diminishing_damage
		local has_extension = ScriptUnit.has_extension(arg_22_0, "ai_slot_system")

		if not diminishing_damage and not has_extension and not has_extension.has_slots_attached then
			local delayed_num_occupied_slots = has_extension.delayed_num_occupied_slots

			if delayed_num_occupied_slots > 0 then
				local damage = diminishing_damage[math.min(delayed_num_occupied_slots, 9)].damage
				local damage_2 = diminishing_damage[1].damage
				local weave = Managers.weave

				if not weave:get_active_weave() then
					local get_scaling_value = weave:get_scaling_value("diminishing_damage")

					damage = math.lerp(damage, damage_2, get_scaling_value)
				end

				arg_22_3 = arg_22_3 * damage
			end
		end

		local is_player_unit = DamageUtils.is_player_unit(arg_22_0)

		if not is_player_unit then
			local get_difficulty_rank = difficulty:get_difficulty_rank()

			if not (not get_difficulty_rank and not (get_difficulty_rank < 3)) then
				local has_extension_2 = ScriptUnit.has_extension(arg_22_0, "status_system")

				if not has_extension_2 and not has_extension_2:is_knocked_down() then
					local knocked_down_damage_multiplier = get_difficulty_settings.knocked_down_damage_multiplier

					knocked_down_damage_multiplier = knocked_down_damage_multiplier or 1
					arg_22_3 = arg_22_3 * knocked_down_damage_multiplier
				end

				local has_extension_3 = ScriptUnit.has_extension(arg_22_0, "health_system")

				if not has_extension_3 then
					local damage_percent_cap = get_difficulty_settings.damage_percent_cap
					local num = has_extension_3:get_max_health() * damage_percent_cap

					arg_22_3 = math.clamp(arg_22_3, 0, num)
				end

				local damage_multiplier = get_difficulty_settings.damage_multiplier

				damage_multiplier = damage_multiplier or 1
				arg_22_3 = arg_22_3 * damage_multiplier
			end
		else
			local var_22_26 = BLACKBOARDS[arg_22_0]

			if not var_22_26 and not var_22_7 then
				local time = Managers.time:time("game")
				local breed = var_22_7.breed
				local breed_2 = var_22_26.breed
				local var_22_30

				if not (not arg_22_2.unblockable and arg_22_2.attack_intensity_type ~= "push") then
					var_22_30 = scripts_utils_stagger_types[arg_22_2.hit_react_type]
				end

				var_22_30 = var_22_30 or AiUtils.calculate_ai_stagger_strength(var_22_7, var_22_26, time, true, scripts_utils_stagger_types.medium, 0.25)

				if var_22_30 <= 0 then
					if (not breed_2.strong_hit_reacts and var_22_26.past_damage_in_attack == false or not var_22_26.stagger) and not var_22_26.stagger_anim_done then
						local forward = Quaternion.forward(local_rotation(arg_22_0, 0))
						local flat_angle = Vector3.flat_angle(normalize, forward)
						local var_22_33

						if not (flat_angle < -math.pi * 0.75 or not (flat_angle > math.pi * 0.75)) then
							var_22_33 = breed_2.strong_hit_reacts.bwd
						elseif flat_angle < -math.pi * 0.25 then
							var_22_33 = breed_2.strong_hit_reacts.left
						elseif flat_angle < math.pi * 0.25 then
							var_22_33 = breed_2.strong_hit_reacts.fwd
						else
							var_22_33 = breed_2.strong_hit_reacts.right
						end

						if not var_22_33 then
							local var_22_34 = var_22_33[math.random(1, #var_22_33)]

							animation_event(arg_22_0, var_22_34)
						end
					elseif not breed_2.disable_local_hit_reactions then
						local forward_2 = Quaternion.forward(local_rotation(arg_22_0, 0))
						local flat_angle_2 = Vector3.flat_angle(forward_2, normalize)
						local var_22_37
						local flag_2

						flag_2 = (flat_angle_2 < -math.pi * 0.75 or flat_angle_2 > math.pi * 0.75 or "hit_reaction_backward" or not (flat_angle_2 < -math.pi * 0.25) or not "hit_reaction_left" or not (flat_angle_2 < math.pi * 0.25)) and (not "hit_reaction_forward" or "hit_reaction_right")

						if not flag_2 then
							animation_event(arg_22_0, flag_2)
						end
					end
				else
					local calculate_ai_stagger_impact, var_22_40 = AiUtils.calculate_ai_stagger_impact(var_22_30)

					AiUtils.stagger_target(arg_22_1, arg_22_0, var_22_40, calculate_ai_stagger_impact, normalize, time)
				end

				local damage_multiplier_vs_ai = breed.damage_multiplier_vs_ai

				damage_multiplier_vs_ai = damage_multiplier_vs_ai or 0.25
				arg_22_3 = arg_22_3 * damage_multiplier_vs_ai

				local var_22_42
				local hitzone_armor_categories = breed_2.hitzone_armor_categories
				local torso

				if not hitzone_armor_categories then
					torso = hitzone_armor_categories.torso

					if not torso then
						-- Nothing
					end
				end

				torso = breed_2.armor_category

				::label_22_0::

				if not (not (arg_22_3 < 0.25) or torso ~= 2) then
					var_22_42 = "fx/hit_armored"
				elseif not breed_2.no_blood_splatter_on_damage then
					var_22_42 = BloodSettings:get_hit_effect_for_race(breed_2.race) or breed_2.hit_effect
				end

				if not var_22_42 then
					local world = var_22_26.world
					local torso_2 = breed_2.hit_zones_lookup.torso

					torso_2 = torso_2 or 0

					local num_2 = Unit.world_position(arg_22_0, torso_2) + Vector3(0, 0, math.random() * breed_2.aoe_height * 0.1)

					EffectHelper.player_melee_hit_particles(world, var_22_42, num_2, normalize, arg_22_2.damage_type, arg_22_0, arg_22_3)
				end
			end
		end

		var_22_5 = DamageUtils.add_damage_network(arg_22_0, arg_22_1, arg_22_3, "torso", arg_22_2.damage_type, nil, normalize, arg_22_4, nil, flag, nil, arg_22_2.hit_react_type, nil, nil, nil, nil, nil, nil, 1)

		local player_push_speed = arg_22_2.player_push_speed

		if not (not is_player_unit and not player_push_speed and ScriptUnit.extension(arg_22_0, "status_system"):is_disabled()) then
			ScriptUnit.extension(arg_22_0, "locomotion_system"):add_external_velocity(player_push_speed * normalize, arg_22_2.max_player_push_speed)
		end
	end

	local var_22_49 = BLACKBOARDS[arg_22_1]

	if not var_22_49 then
		var_22_49.hit_through_block = false
	end

	return var_22_5
end

AiUtils.add_attack_intensity = function (arg_23_0, arg_23_1, arg_23_2)
	-- function 23
	local has_extension = ScriptUnit.has_extension(arg_23_0, "attack_intensity_system")

	if not has_extension then
		return
	end

	local attack_intensity_type = arg_23_1.attack_intensity_type

	if not attack_intensity_type then
		return
	end

	local get_difficulty = Managers.state.difficulty:get_difficulty()
	local difficulty_attack_intensity = arg_23_1.difficulty_attack_intensity

	difficulty_attack_intensity = not difficulty_attack_intensity and arg_23_1.difficulty_attack_intensity[attack_intensity_type][get_difficulty]

	if not difficulty_attack_intensity then
		return
	end

	local add_random_intensity = arg_23_1.add_random_intensity

	for k, v in pairs(difficulty_attack_intensity) do
		local num

		if not add_random_intensity then
			num = 0.75 + 0.5 * math.random()

			if not num then
				-- Nothing
			end
		end

		num = 1

		::label_23_0::

		local num_2 = v * num

		has_extension:add_attack_intensity(k, num_2)
	end
end

AiUtils.poison_explode_unit = function (arg_24_0, arg_24_1, arg_24_2)
	-- function 24
	local local_position = Unit.local_position(arg_24_0, 0)
	local get_difficulty_rank = Managers.state.difficulty:get_difficulty_rank()
	local var_24_2 = arg_24_1.aoe_dot_damage[get_difficulty_rank]

	var_24_2 = var_24_2 or arg_24_1.aoe_dot_damage[2]

	local calculate_damage = DamageUtils.calculate_damage(var_24_2)
	local var_24_4 = arg_24_1.aoe_init_damage[get_difficulty_rank]

	var_24_4 = var_24_4 or arg_24_1.aoe_init_damage[2]

	local calculate_damage_2 = DamageUtils.calculate_damage(var_24_4)
	local aoe_dot_damage_interval = arg_24_1.aoe_dot_damage_interval
	local radius = arg_24_1.radius
	local initial_radius = arg_24_1.initial_radius
	local duration = arg_24_1.duration
	local create_nav_tag_volume = arg_24_1.create_nav_tag_volume
	local nav_tag_volume_layer = arg_24_1.nav_tag_volume_layer
	local tbl = {
		area_damage_system = {
			area_damage_template = "globadier_area_dot_damage",
			invisible_unit = true,
			player_screen_effect_name = "fx/screenspace_poison_globe_impact",
			area_ai_random_death_template = "area_poison_ai_random_death",
			dot_effect_name = "fx/wpnfx_poison_wind_globe_impact",
			extra_dot_effect_name = "fx/chr_gutter_death",
			damage_players = true,
			aoe_dot_damage = calculate_damage,
			aoe_init_damage = calculate_damage_2,
			aoe_dot_damage_interval = aoe_dot_damage_interval,
			radius = radius,
			initial_radius = initial_radius,
			life_time = duration,
			damage_source = arg_24_2.breed.name,
			create_nav_tag_volume = create_nav_tag_volume,
			nav_tag_volume_layer = nav_tag_volume_layer,
			source_attacker_unit = arg_24_0
		}
	}
	local str = "units/weapons/projectile/poison_wind_globe/poison_wind_globe"
	local spawn_network_unit = Managers.state.unit_spawner:spawn_network_unit(str, "aoe_unit", tbl, local_position)
	local go_id = Managers.state.unit_storage:go_id(spawn_network_unit)

	Unit.set_unit_visibility(spawn_network_unit, false)

	local world = arg_24_2.world

	assert(world)
	Managers.state.network.network_transmit:send_rpc_all("rpc_area_damage", go_id, local_position)
	Managers.state.unit_spawner:mark_for_deletion(arg_24_0)
end

AiUtils.warpfire_explode_unit = function (arg_25_0, arg_25_1)
	-- function 25
	local world = arg_25_1.world
	local get_template = ExplosionUtils.get_template("warpfire_explosion")
	local node = Unit.node(arg_25_0, "j_backpack")
	local world_position = Unit.world_position(arg_25_0, node)
	local go_id = Managers.state.unit_storage:go_id(arg_25_0)
	local warpfire_explosion = NetworkLookup.explosion_templates.warpfire_explosion
	local name = arg_25_1.breed.name
	local var_25_7 = NetworkLookup.damage_sources[name]

	Unit.flow_event(arg_25_0, "lua_hide_backpack")

	local actor = Unit.actor(arg_25_0, "c_backpack")

	Actor.set_collision_filter(actor, "filter_trigger")
	Actor.set_scene_query_enabled(actor, false)
	DamageUtils.create_explosion(world, arg_25_0, world_position, Quaternion.identity(), get_template, 1, name, true, false, arg_25_0, 0, false)
	Managers.state.network.network_transmit:send_rpc_clients("rpc_create_explosion", go_id, false, world_position, Quaternion.identity(), warpfire_explosion, 1, var_25_7, 0, false, go_id)

	local var_25_9 = POSITION_LOOKUP[arg_25_0]
	local nav_world = Managers.state.entity:system("ai_system"):nav_world()
	local get_close_pos_below_on_mesh = LocomotionUtils.get_close_pos_below_on_mesh(nav_world, var_25_9, 4)

	if not get_close_pos_below_on_mesh then
		local local_rotation = Unit.local_rotation(arg_25_0, 0)
		local forward = Quaternion.forward(local_rotation)
		local flat = Vector3.flat(forward)
		local tbl = {
			area_damage_system = {
				liquid_template = "warpfire_death_fire",
				flow_dir = flat,
				source_unit = arg_25_0
			}
		}
		local str = "units/hub_elements/empty"
		local spawn_network_unit = Managers.state.unit_spawner:spawn_network_unit(str, "liquid_aoe_unit", tbl, get_close_pos_below_on_mesh)

		ScriptUnit.extension(spawn_network_unit, "area_damage_system"):ready()
	end
end

AiUtils.chaos_zombie_explosion = function (arg_26_0, arg_26_1, arg_26_2, arg_26_3)
	-- function 26
	local local_position = Unit.local_position(arg_26_0, 0)
	local name = arg_26_2.breed.name
	local world = arg_26_2.world
	local num = local_position + Vector3.up()
	local get_template = ExplosionUtils.get_template("chaos_zombie_explosion")

	DamageUtils.create_explosion(world, arg_26_0, num, Quaternion.identity(), get_template, 1, name, true, false, arg_26_0, 0, false)

	local go_id = Managers.state.unit_storage:go_id(arg_26_0)
	local chaos_zombie_explosion = NetworkLookup.explosion_templates.chaos_zombie_explosion
	local var_26_7 = NetworkLookup.damage_sources[name]

	Managers.state.network.network_transmit:send_rpc_clients("rpc_create_explosion", go_id, false, num, Quaternion.identity(), chaos_zombie_explosion, 1, var_26_7, 0, false, go_id)

	if not arg_26_3 then
		Managers.state.unit_spawner:mark_for_deletion(arg_26_0)
	end

	local up = Quaternion.up(Unit.local_rotation(arg_26_0, 0))

	Managers.state.blood:add_blood_ball(local_position, up, "default", arg_26_0)
end

AiUtils.generic_mutator_explosion = function (arg_27_0, arg_27_1, arg_27_2, arg_27_3)
	-- function 27
	local local_position = Unit.local_position(arg_27_0, 0)
	local get_difficulty_rank = Managers.state.difficulty:get_difficulty_rank()
	local name = arg_27_1.breed.name
	local world = arg_27_1.world
	local num = local_position + Vector3.up()
	local get_template = ExplosionUtils.get_template(arg_27_2)

	DamageUtils.create_explosion(world, not arg_27_3 and arg_27_0, num, Quaternion.identity(), get_template, 1, name, true, false, arg_27_0, 0, false)

	local go_id = Managers.state.unit_storage:go_id(arg_27_0)
	local var_27_7 = NetworkLookup.explosion_templates[arg_27_2]
	local var_27_8 = NetworkLookup.damage_sources[name]

	Managers.state.network.network_transmit:send_rpc_clients("rpc_create_explosion", go_id, false, num, Quaternion.identity(), var_27_7, 1, var_27_8, 0, false, go_id)

	local up = Quaternion.up(Unit.local_rotation(arg_27_0, 0))

	Managers.state.blood:add_blood_ball(local_position, up, "default", arg_27_0)
end

AiUtils.ai_explosion = function (arg_28_0, arg_28_1, arg_28_2, arg_28_3, arg_28_4)
	-- function 28
	local local_position = Unit.local_position(arg_28_0, 0)
	local name = arg_28_2.breed.name
	local world = arg_28_2.world

	DamageUtils.create_explosion(world, arg_28_0, local_position, Quaternion.identity(), arg_28_4, 1, name, true, false, arg_28_1, false)

	local go_id = Managers.state.unit_storage:go_id(arg_28_1)
	local var_28_4 = NetworkLookup.explosion_templates[arg_28_4.name]
	local var_28_5 = NetworkLookup.damage_sources[name]

	Managers.state.network.network_transmit:send_rpc_clients("rpc_create_explosion", go_id, false, local_position, Quaternion.identity(), var_28_4, 1, var_28_5, 0, false, go_id)
	Managers.state.unit_spawner:mark_for_deletion(arg_28_0)
end

AiUtils.loot_rat_explosion = function (arg_29_0, arg_29_1, arg_29_2, arg_29_3, arg_29_4)
	-- function 29
	local local_position = Unit.local_position(arg_29_0, 0)
	local name = arg_29_2.breed.name
	local world = arg_29_2.world

	DamageUtils.create_explosion(world, arg_29_0, local_position, Quaternion.identity(), arg_29_4, 1, name, true, false, arg_29_1, false)

	local go_id = Managers.state.unit_storage:go_id(arg_29_1)
	local var_29_4 = NetworkLookup.explosion_templates[arg_29_4.name]
	local var_29_5 = NetworkLookup.damage_sources[name]

	Managers.state.network.network_transmit:send_rpc_clients("rpc_create_explosion", go_id, false, local_position, Quaternion.identity(), var_29_4, 1, var_29_5, 0, false, go_id)

	arg_29_2.delete_at_t = Managers.time:time("game") + 0.1
end

AiUtils.spawn_overpowering_blob = function (self, arg_30_1, arg_30_2, arg_30_3)
	-- function 30
	local var_30_0 = POSITION_LOOKUP[arg_30_1]
	local str = "units/weapons/enemy/wpn_overpowering_blob/wpn_overpowering_blob"
	local tbl = {
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
	local from_quaternion_position = Matrix4x4.from_quaternion_position(Quaternion.identity(), var_30_0)

	Matrix4x4.set_scale(from_quaternion_position, Vector3(var_30_3[1], var_30_3[2], var_30_3[3]))

	local spawn_network_unit = Managers.state.unit_spawner:spawn_network_unit(str, "overpowering_blob_unit", tbl, from_quaternion_position)
	local node = Unit.node(arg_30_1, "c_spine")
	local var_30_7 = spawn_network_unit
	local num = 0
	local main_world = Application.main_world()

	World.link_unit(main_world, var_30_7, arg_30_1, node)

	local unit_game_object_id = self:unit_game_object_id(var_30_7)
	local unit_game_object_id_2 = self:unit_game_object_id(arg_30_1)

	self.network_transmit:send_rpc_clients("rpc_link_unit", unit_game_object_id, num, unit_game_object_id_2, node)

	return spawn_network_unit
end

AiUtils.broadphase_query = function (arg_31_0, arg_31_1, arg_31_2, arg_31_3)
	-- function 31
	fassert(arg_31_2, "No result_table given to AiUtils,broadphase_query")

	local broadphase = Managers.state.entity:system("ai_system").group_blackboard.broadphase

	return (Broadphase.query(broadphase, arg_31_0, arg_31_1, arg_31_2, arg_31_3))
end

AiUtils.get_angle_between_vectors = function (self, arg_32_1)
	-- function 32
	self = Vector3.normalize(Vector3.flat(self))
	arg_32_1 = Vector3.normalize(Vector3.flat(arg_32_1))

	local num = math.atan2(self.y, self.x) - math.atan2(arg_32_1.y, arg_32_1.x)
	local radians_to_degrees = math.radians_to_degrees(num)

	return math.abs(radians_to_degrees), radians_to_degrees, num
end

AiUtils.rotate_vector = function (self, arg_33_1)
	-- function 33
	local length = Vector3.length(self)
	local num = math.atan2(self.y, self.x) + arg_33_1
	local cos = math.cos(num)
	local sin = math.sin(num)

	return Vector3(cos, sin, 0) * length
end

AiUtils.constrain_radians = function (arg_34_0)
	-- function 34
	if arg_34_0 > math.pi then
		arg_34_0 = -math.pi + (arg_34_0 - math.pi)
	elseif arg_34_0 < -math.pi then
		arg_34_0 = math.pi + (arg_34_0 + math.pi)
	end

	return arg_34_0
end

AiUtils.calculate_oobb = function (arg_35_0, arg_35_1, arg_35_2, arg_35_3, arg_35_4)
	-- function 35
	local flag = arg_35_3 or 2
	local num = (arg_35_4 or 2) * 0.5
	local num_2 = arg_35_0 * 0.5
	local num_3 = flag * 0.5
	local var_35_4 = Vector3(num, num_2, num_3)
	local num_4 = Quaternion.rotate(arg_35_2, Vector3.forward()) * num_2
	local num_5 = Vector3.up() * num_3

	return arg_35_1 + num_4 + num_5, arg_35_2, var_35_4
end

local num = 0

AiUtils.calculate_bot_threat_time = function (self)
	-- function 36
	local duration = self.duration
	local max_start_delay = self.max_start_delay

	max_start_delay = max_start_delay or 0

	local random = math.random()
	local num_2 = num + random

	if num_2 > 1 then
		num_2 = random
	end

	local num_3 = num_2 * max_start_delay
	local num_4 = self.start_time + num_3

	num = num_2

	return num_4, duration - num_3
end

AiUtils.get_actual_attacker_unit = function (arg_37_0)
	-- function 37
	local has_extension = ScriptUnit.has_extension(arg_37_0, "projectile_system")

	if not has_extension and ScriptUnit.has_extension(arg_37_0, "limited_item_track_system") or not ALIVE[has_extension.owner_unit] then
		return has_extension.owner_unit
	end

	local has_extension_2 = ScriptUnit.has_extension(arg_37_0, "area_damage_system")

	if not has_extension_2 then
		local owner_player = has_extension_2.owner_player

		if not owner_player and not ALIVE[owner_player.player_unit] then
			return owner_player.player_unit
		end
	end

	return arg_37_0
end

AiUtils.get_actual_attacker_breed = function (arg_38_0, arg_38_1, arg_38_2, arg_38_3, arg_38_4)
	-- function 38
	local has_extension = ScriptUnit.has_extension(arg_38_1, "status_system")
	local flag = not has_extension and has_extension:query_pack_master_player()

	if not (not flag and flag ~= arg_38_4 or arg_38_2 ~= "skaven_pack_master") then
		return PlayerBreeds.vs_packmaster
	end

	local has_source_attacker_unit_data = Managers.state.entity:system("area_damage_system"):has_source_attacker_unit_data(arg_38_3)

	if not has_source_attacker_unit_data then
		return has_source_attacker_unit_data.breed
	end

	if not arg_38_4 then
		local profile_index = arg_38_4:profile_index()
		local career_index = arg_38_4:career_index()

		if not profile_index and not career_index then
			return SPProfiles[profile_index].careers[career_index].breed
		end
	end

	return arg_38_0
end

AiUtils.get_actual_attacker_player = function (arg_39_0, arg_39_1, arg_39_2)
	-- function 39
	local owner = Managers.player:owner(arg_39_0)
	local has_extension = ScriptUnit.has_extension(arg_39_0, "projectile_system")

	if not (not has_extension and ScriptUnit.has_extension(arg_39_0, "limited_item_track_system")) then
		local owner_unit = has_extension.owner_unit
		local owner_2 = Managers.player:owner(owner_unit)

		if not owner_2 then
			return owner_2
		end
	end

	local has_extension_2 = ScriptUnit.has_extension(arg_39_0, "area_damage_system")

	if not has_extension_2 then
		local owner_player = has_extension_2.owner_player

		if not owner_player then
			return owner_player
		end
	end

	if arg_39_2 == "skaven_pack_master" then
		local has_extension_3 = ScriptUnit.has_extension(arg_39_1, "status_system")
		local flag = not has_extension_3 and has_extension_3:query_pack_master_player()

		if not flag then
			return flag
		end
	end

	local get_commander_unit = Managers.state.entity:system("ai_commander_system"):get_commander_unit(arg_39_0)
	local owner_3 = Managers.player:owner(get_commander_unit)

	if not owner_3 then
		return owner_3
	end

	return owner
end

AiUtils.unit_breed = function (arg_40_0)
	-- function 40
	if not ALIVE[arg_40_0] then
		return
	end

	return get_data(arg_40_0, "breed")
end

AiUtils.downed_duration = function (self)
	-- function 41
	local downed_duration = self.downed_duration

	if type(downed_duration) == "table" then
		return downed_duration[Managers.state.difficulty:get_difficulty_rank()]
	end

	return downed_duration
end

AiUtils.client_predicted_unit_alive = function (arg_42_0)
	-- function 42
	if not alive(arg_42_0) then
		return false
	end

	local has_extension = ScriptUnit.has_extension(arg_42_0, "health_system")

	return not has_extension and has_extension:client_predicted_is_alive()
end

AiUtils.unit_invincible = function (arg_43_0)
	-- function 43
	if not ALIVE[arg_43_0] then
		return false
	end

	local has_extension = ScriptUnit.has_extension(arg_43_0, "health_system")

	return not has_extension and has_extension:get_is_invincible()
end

AiUtils.unit_knocked_down = function (arg_44_0)
	-- function 44
	if not ALIVE[arg_44_0] then
		return false
	end

	local has_extension = ScriptUnit.has_extension(arg_44_0, "status_system")

	if not has_extension then
		return false
	end

	return (has_extension:is_knocked_down())
end

AiUtils.unit_disabled = function (arg_45_0)
	-- function 45
	if not ALIVE[arg_45_0] then
		return false
	end

	local has_extension = ScriptUnit.has_extension(arg_45_0, "status_system")

	if not has_extension then
		return false
	end

	return (has_extension:is_disabled())
end

AiUtils.is_unwanted_target = function (self, arg_46_1)
	-- function 46
	if not self.VALID_ENEMY_TARGETS_PLAYERS_AND_BOTS[arg_46_1] and not ScriptUnit.extension(arg_46_1, "status_system"):is_grabbed_by_chaos_spawn() then
		return true
	end

	return false
end

AiUtils.is_of_interest_to_gutter_runner = function (arg_47_0, arg_47_1, arg_47_2, arg_47_3)
	-- function 47
	if not Managers.state.side.side_by_unit[arg_47_0].VALID_ENEMY_TARGETS_PLAYERS_AND_BOTS[arg_47_1] then
		return
	end

	local var_47_0 = arg_47_2.group_blackboard.disabled_by_special[arg_47_1]

	if not (not var_47_0 and var_47_0 == arg_47_0) then
		return
	end

	local extension = ScriptUnit.extension(arg_47_1, "status_system")

	if not (not extension:is_knocked_down() and arg_47_3) then
		return
	end

	if not extension:is_grabbed_by_pack_master() then
		return
	end

	if not extension:is_grabbed_by_corruptor() then
		return
	end

	if not extension:is_grabbed_by_chaos_spawn() then
		return
	end

	if not extension:get_is_ledge_hanging() then
		return
	end

	if not (not extension:is_pounced_down() and extension:get_pouncer_unit() == arg_47_0) then
		return
	end

	if not extension.using_transport then
		return
	end

	return true
end

AiUtils.is_of_interest_to_packmaster = function (arg_48_0, arg_48_1)
	-- function 48
	if not Managers.state.side.side_by_unit[arg_48_0].VALID_ENEMY_TARGETS_PLAYERS_AND_BOTS[arg_48_1] then
		local extension = ScriptUnit.extension(arg_48_1, "status_system")
		local is_knocked_down = extension:is_knocked_down()
		local is_pounced_down = extension:is_pounced_down()
		local is_grabbed_by_chaos_spawn = extension:is_grabbed_by_chaos_spawn()
		local flag = not extension:is_grabbed_by_pack_master() and extension:get_pack_master_grabber() ~= arg_48_0
		local flag_2 = extension.pack_master_status == "pack_master_hanging"
		local using_transport = extension.using_transport
		local is_ledge_hanging = extension.is_ledge_hanging
		local is_grabbed_by_corruptor = extension:is_grabbed_by_corruptor()

		if not (is_knocked_down or is_pounced_down or flag or flag_2 or using_transport or is_ledge_hanging or is_grabbed_by_chaos_spawn or is_grabbed_by_corruptor) then
			return true
		end
	end

	return false
end

AiUtils.is_of_interest_to_corruptor = function (arg_49_0, arg_49_1)
	-- function 49
	if not Managers.state.side.side_by_unit[arg_49_0].VALID_ENEMY_TARGETS_PLAYERS_AND_BOTS[arg_49_1] then
		local extension = ScriptUnit.extension(arg_49_1, "status_system")
		local is_knocked_down = extension:is_knocked_down()
		local is_pounced_down = extension:is_pounced_down()
		local is_grabbed_by_chaos_spawn = extension:is_grabbed_by_chaos_spawn()
		local flag = not extension:is_grabbed_by_corruptor() and extension.corruptor_unit ~= arg_49_0
		local flag_2 = extension.pack_master_status == "pack_master_hanging"
		local using_transport = extension.using_transport
		local is_ledge_hanging = extension.is_ledge_hanging
		local is_grabbed_by_pack_master = extension:is_grabbed_by_pack_master()

		if not (is_knocked_down or is_pounced_down or flag or flag_2 or using_transport or is_ledge_hanging or is_grabbed_by_chaos_spawn or is_grabbed_by_pack_master) then
			return true
		end
	end

	return false
end

AiUtils.is_of_interest_to_tentacle = function (arg_50_0, arg_50_1)
	-- function 50
	local extension = ScriptUnit.extension(arg_50_0, "status_system")
	local is_knocked_down = extension:is_knocked_down()
	local is_pounced_down = extension:is_pounced_down()
	local is_grabbed_by_chaos_spawn = extension:is_grabbed_by_chaos_spawn()
	local flag = extension.pack_master_status == "pack_master_hanging"
	local using_transport = extension.using_transport
	local is_ledge_hanging = extension.is_ledge_hanging
	local in_end_zone = extension.in_end_zone
	local is_grabbed_by_corruptor = extension:is_grabbed_by_corruptor()

	if not (is_knocked_down or is_pounced_down or flag or using_transport or is_ledge_hanging or is_grabbed_by_chaos_spawn or in_end_zone or is_grabbed_by_corruptor) then
		return true
	end

	return false
end

AiUtils.is_of_interest_to_vortex = function (arg_51_0)
	-- function 51
	local extension = ScriptUnit.extension(arg_51_0, "status_system")
	local is_knocked_down = extension:is_knocked_down()
	local is_pounced_down = extension:is_pounced_down()
	local is_grabbed_by_pack_master = extension:is_grabbed_by_pack_master()
	local flag = extension.pack_master_status == "pack_master_hanging"
	local using_transport = extension.using_transport
	local is_ledge_hanging = extension.is_ledge_hanging
	local is_grabbed_by_chaos_spawn = extension:is_grabbed_by_chaos_spawn()
	local is_in_vortex = extension:is_in_vortex()
	local in_end_zone = extension.in_end_zone
	local is_grabbed_by_corruptor = extension:is_grabbed_by_corruptor()

	if not (is_knocked_down or is_pounced_down or is_grabbed_by_pack_master or flag or using_transport or is_ledge_hanging or is_grabbed_by_chaos_spawn or is_in_vortex or in_end_zone or is_grabbed_by_corruptor) then
		return true
	end

	return false
end

AiUtils.is_of_interest_plague_wave_sorcerer = function (arg_52_0)
	-- function 52
	local has_extension = ScriptUnit.has_extension(arg_52_0, "status_system")

	if not has_extension then
		return false
	end

	local is_knocked_down = has_extension:is_knocked_down()
	local is_pounced_down = has_extension:is_pounced_down()
	local is_grabbed_by_pack_master = has_extension:is_grabbed_by_pack_master()
	local flag = has_extension.pack_master_status == "pack_master_hanging"
	local using_transport = has_extension.using_transport
	local is_ledge_hanging = has_extension.is_ledge_hanging
	local is_grabbed_by_chaos_spawn = has_extension:is_grabbed_by_chaos_spawn()
	local overpowered = has_extension.overpowered
	local in_end_zone = has_extension.in_end_zone

	if not (is_knocked_down or is_pounced_down or is_grabbed_by_pack_master or flag or using_transport or is_ledge_hanging or is_grabbed_by_chaos_spawn or overpowered or in_end_zone) then
		return true
	end

	return false
end

AiUtils.is_of_interest_boss_sorcerer = function (arg_53_0)
	-- function 53
	local extension = ScriptUnit.extension(arg_53_0, "status_system")
	local is_knocked_down = extension:is_knocked_down()
	local is_pounced_down = extension:is_pounced_down()
	local is_grabbed_by_pack_master = extension:is_grabbed_by_pack_master()
	local flag = extension.pack_master_status == "pack_master_hanging"
	local using_transport = extension.using_transport
	local is_ledge_hanging = extension.is_ledge_hanging
	local is_grabbed_by_chaos_spawn = extension:is_grabbed_by_chaos_spawn()
	local is_in_vortex = extension:is_in_vortex()
	local overpowered = extension.overpowered

	if not (is_knocked_down or is_pounced_down or is_grabbed_by_pack_master or flag or using_transport or is_ledge_hanging or is_grabbed_by_chaos_spawn or is_in_vortex or overpowered) then
		return true
	end

	return false
end

AiUtils.is_of_interest_stormfiend_demo = function (arg_54_0)
	-- function 54
	return not Managers.player:unit_owner(arg_54_0).bot_player
end

AiUtils.show_polearm = function (arg_55_0, arg_55_1)
	-- function 55
	local num = 1
	local go_id = Managers.state.unit_storage:go_id(arg_55_0)
	local network = Managers.state.network

	if not network:game() then
		network.network_transmit:send_rpc_all("rpc_ai_show_single_item", go_id, num, arg_55_1)
	end
end

AiUtils.stagger = function (arg_56_0, arg_56_1, arg_56_2, arg_56_3, arg_56_4, arg_56_5, arg_56_6, arg_56_7, arg_56_8, arg_56_9, arg_56_10, arg_56_11, arg_56_12, arg_56_13, arg_56_14)
	-- function 56
	fassert(arg_56_5 > 0, "Tried to use invalid stagger type %q", arg_56_5)

	local flag = not arg_56_1.stagger and arg_56_1.stagger_type == scripts_utils_stagger_types.explosion
	local flag_2 = arg_56_5 == scripts_utils_stagger_types.explosion

	if not ((arg_56_10 or arg_56_11 or not flag) and flag_2) then
		return
	end

	local breed = arg_56_1.breed

	if not (not breed.boss_staggers and not (arg_56_5 < scripts_utils_stagger_types.explosion)) then
		return
	end

	local stagger_modifier = Managers.state.difficulty:get_difficulty_settings().stagger_modifier

	arg_56_1.pushing_unit = arg_56_2
	arg_56_1.stagger_direction = Vector3Box(arg_56_3)
	arg_56_1.stagger_length = arg_56_4
	arg_56_1.stagger_time = arg_56_6 * stagger_modifier + arg_56_8

	local flag_3 = arg_56_9 or 1
	local num

	if not arg_56_1.stagger then
		num = arg_56_1.stagger + flag_3

		if not num then
			-- Nothing
		end
	end

	num = flag_3

	::label_56_0::

	arg_56_1.stagger = num
	arg_56_1.stagger_type = arg_56_5
	arg_56_1.stagger_animation_scale = arg_56_7
	arg_56_1.always_stagger_suffered = arg_56_10
	arg_56_1.stagger_was_push = arg_56_11

	local has_extension = ScriptUnit.has_extension(arg_56_0, "ai_shield_system")

	if not (not has_extension and (has_extension.is_blocking or not arg_56_1.attack_token or not arg_56_1.stagger) and not (arg_56_1.stagger < 3)) then
		arg_56_1.stagger = 3
	end

	if arg_56_0 == arg_56_2 or not ScriptUnit.has_extension(arg_56_0, "ai_system") then
		local extension = ScriptUnit.extension(arg_56_0, "ai_system")

		if not breed.using_combo and not arg_56_10 then
			Unit.set_data(arg_56_2, "last_combo_t", arg_56_8)
		end

		if not breed.before_stagger_enter_function then
			breed.before_stagger_enter_function(arg_56_0, arg_56_1, arg_56_2, arg_56_11, flag_3, arg_56_13, arg_56_14)
		end

		if not extension.attacked then
			extension:attacked(arg_56_2, arg_56_8)
		end
	end

	if not arg_56_12 then
		local push_sound_event = arg_56_1.breed.push_sound_event

		push_sound_event = push_sound_event or "Play_generic_pushed_impact_small"

		Managers.state.entity:system("audio_system"):play_audio_unit_event(push_sound_event, arg_56_0)
	end
end

AiUtils.override_stagger = function (arg_57_0, arg_57_1, arg_57_2, arg_57_3, arg_57_4, arg_57_5, arg_57_6, arg_57_7, arg_57_8, arg_57_9)
	-- function 57
	local active_node = arg_57_1.active_node

	if not (not active_node and active_node.stagger_override) then
		return false
	end

	if not active_node:stagger_override(arg_57_0, arg_57_1, arg_57_2, arg_57_3, arg_57_4, arg_57_5, arg_57_6, arg_57_7, arg_57_8, arg_57_9) then
		assert(arg_57_5 > scripts_utils_stagger_types.none, "Tried to use invalid stagger type %q", arg_57_5)

		if arg_57_0 == arg_57_2 or not ScriptUnit.has_extension(arg_57_0, "ai_system") then
			local extension = ScriptUnit.extension(arg_57_0, "ai_system")

			if not extension.attacked then
				extension:attacked(arg_57_2, arg_57_8)
			end
		end

		return true
	end

	return false
end

AiUtils.random = function (arg_58_0, arg_58_1)
	-- function 58
	return arg_58_0 + Math.random() * (arg_58_1 - arg_58_0)
end

local num_2 = 10
local num_3 = 4
local num_4 = 8
local num_5 = 0

AiUtils.advance_towards_target = function (arg_59_0, arg_59_1, arg_59_2, arg_59_3, arg_59_4, arg_59_5, arg_59_6, arg_59_7, arg_59_8, arg_59_9, arg_59_10)
	-- function 59
	local target_unit = arg_59_1.target_unit

	if not HEALTH_ALIVE[target_unit] then
		return
	end

	local var_59_1 = num_2
	local flag = arg_59_4 or num_3
	local flag_2 = arg_59_5 or num_4
	local flag_3 = arg_59_6 or num_5

	arg_59_8 = arg_59_8 or 1 - math.random(0, 1) * 2

	local var_59_5 = POSITION_LOOKUP[arg_59_0]
	local var_59_6 = POSITION_LOOKUP[target_unit]

	for i = 1, 2 do
		for j = 1, var_59_1 do
			local num = flag_3 + math.random(flag * j, flag_2 * j) * arg_59_8
			local outside_goal, var_59_9 = LocomotionUtils.outside_goal(arg_59_1.nav_world, var_59_5, var_59_6, arg_59_2, arg_59_3, num, 3, arg_59_9, arg_59_10)

			if not outside_goal then
				return outside_goal, var_59_9, arg_59_8
			end
		end

		arg_59_8 = -arg_59_8
	end

	return false
end

AiUtils.temp_anim_event = function (arg_60_0, arg_60_1, arg_60_2)
	-- function 60
	local str = "temp_anim_event"
	local node = Unit.node(arg_60_0, "c_head")
	local str_2 = "player_1"
	local var_60_3 = Vector3(255, 0, 0)
	local var_60_4 = Vector3(0, 0, 1)
	local num = 0.5
	local var_60_6 = arg_60_1

	if not arg_60_2 then
		var_60_6 = arg_60_1 .. ": " .. math.round_with_precision(arg_60_2, 1)
	end

	Managers.state.debug_text:clear_unit_text(arg_60_0, str)
	Managers.state.debug_text:output_unit_text(var_60_6, num, arg_60_0, node, var_60_4, nil, str, var_60_3, str_2)
end

AiUtils.clear_temp_anim_event = function (arg_61_0)
	-- function 61
	local str = "temp_anim_event"

	Managers.state.debug_text:clear_unit_text(arg_61_0, str)
end

AiUtils.anim_event = function (arg_62_0, arg_62_1, arg_62_2)
	-- function 62
	if not (not arg_62_1.anim_event and arg_62_1.anim_event ~= arg_62_2) then
		return
	end

	Managers.state.network:anim_event(arg_62_0, arg_62_2)

	arg_62_1.anim_event = arg_62_2
end

AiUtils.get_default_breed_move_speed = function (arg_63_0, arg_63_1)
	-- function 63
	local var_63_0
	local breed = arg_63_1.breed

	if not arg_63_1.is_passive then
		var_63_0 = breed.passive_walk_speed or breed.walk_speed
	else
		var_63_0 = breed.run_speed
	end

	return var_63_0
end

AiUtils.clear_anim_event = function (self)
	-- function 64
	self.anim_event = nil
end

AiUtils.set_default_anim_constraint = function (arg_65_0, arg_65_1)
	-- function 65
	local var_65_0 = POSITION_LOOKUP[arg_65_0]
	local world_rotation = Unit.world_rotation(arg_65_0, 0)
	local num = var_65_0 + Quaternion.forward(world_rotation) * 5 + Vector3.up() * 1.25

	Unit.animation_set_constraint_target(arg_65_0, arg_65_1, num)
end

AiUtils.ninja_vanish_when_taking_damage = function (arg_66_0, arg_66_1)
	-- function 66
	local recent_damages, var_66_1 = ScriptUnit.extension(arg_66_0, "health_system"):recent_damages()

	if var_66_1 > 0 then
		arg_66_1.ninja_vanish = true
	end
end

AiUtils.initialize_cost_table = function (arg_67_0, arg_67_1)
	-- function 67
	for i, v in ipairs(LAYER_ID_MAPPING) do
		local var_67_0 = arg_67_1[v]

		if not (var_67_0 == 0 or var_67_0 ~= nil) then
			GwNavTagLayerCostTable.forbid_layer(arg_67_0, i)
		else
			GwNavTagLayerCostTable.allow_layer(arg_67_0, i)
			GwNavTagLayerCostTable.set_layer_cost_multiplier(arg_67_0, i, var_67_0)
		end
	end
end

AiUtils.initialize_nav_cost_map_cost_table = function (arg_68_0, arg_68_1, arg_68_2)
	-- function 68
	for i, v in ipairs(NAV_COST_MAP_LAYER_ID_MAPPING) do
		local var_68_0

		if not arg_68_1 then
			var_68_0 = arg_68_1[v]

			if not var_68_0 then
				-- Nothing
			end
		end

		var_68_0 = arg_68_2 or 0

		::label_68_0::

		GwNavCostMap.cost_table_set_cost(arg_68_0, i, var_68_0)
	end
end

AiUtils.kill_unit = function (arg_69_0, arg_69_1, arg_69_2, arg_69_3, arg_69_4, arg_69_5)
	-- function 69
	local max = NetworkConstants.damage.max

	arg_69_1 = arg_69_1 or arg_69_0

	if not HEALTH_ALIVE[arg_69_0] then
		arg_69_2 = arg_69_2 or "full"
		arg_69_3 = arg_69_3 or "kinetic"
		arg_69_5 = arg_69_5 or "suicide"
		arg_69_4 = arg_69_4 or Vector3(0, 0, 1)

		local current_health = ScriptUnit.extension(arg_69_0, "health_system"):current_health()
		local flag = true

		for i = 1, math.ceil(current_health / max) do
			DamageUtils.add_damage_network(arg_69_0, arg_69_1, max, arg_69_2, arg_69_3, nil, arg_69_4, arg_69_5, nil, nil, nil, nil, false, false, nil, nil, nil, flag, 1)
		end
	end
end

local tbl_2 = {
	ranged = 1,
	melee = 1,
	grenade = 1
}

AiUtils.update_aggro = function (arg_70_0, arg_70_1, arg_70_2, arg_70_3, arg_70_4)
	-- function 70
	local aggro_list = arg_70_1.aggro_list
	local recent_damages, var_70_2 = ScriptUnit.extension(arg_70_0, "health_system"):recent_damages()
	local num = arg_70_4 * arg_70_2.perception_weights.aggro_decay_per_sec

	for k, v in pairs(aggro_list) do
		aggro_list[k] = math.clamp(v - num, 0, 100)
	end

	local aggro_multipliers = arg_70_2.perception_weights.aggro_multipliers

	aggro_multipliers = aggro_multipliers or tbl_2

	if var_70_2 > 0 then
		local STRIDE = DamageDataIndex.STRIDE
		local num_2 = 0

		for k_2 = 1, var_70_2 / STRIDE do
			local var_70_7 = recent_damages[num_2 + DamageDataIndex.ATTACKER]
			local var_70_8 = recent_damages[num_2 + DamageDataIndex.DAMAGE_AMOUNT]
			local var_70_9 = recent_damages[num_2 + DamageDataIndex.DAMAGE_SOURCE_NAME]
			local var_70_10 = rawget(ItemMasterList, var_70_9)

			if not var_70_10 then
				local var_70_11 = aggro_multipliers[var_70_10.slot_type]

				var_70_11 = var_70_11 or 1
				var_70_8 = var_70_8 * var_70_11
			end

			local var_70_12 = aggro_list[var_70_7]

			if not var_70_12 then
				aggro_list[var_70_7] = var_70_12 + var_70_8
			else
				aggro_list[var_70_7] = var_70_8
			end

			num_2 = num_2 + STRIDE
		end
	end
end

AiUtils.debug_bot_transitions = function (arg_71_0, arg_71_1, arg_71_2, arg_71_3)
	-- function 71
	local num = 16
	local str = "arial"
	local str_2 = "materials/fonts/" .. str
	local res_w = RESOLUTION_LOOKUP.res_w
	local res_h = RESOLUTION_LOOKUP.res_h
	local num_2 = 20
	local num_3 = 20
	local num_4 = 330
	local num_5 = 20

	arg_71_2 = arg_71_2 + num_2 + 20
	arg_71_3 = arg_71_3 + num_3 + 20

	local var_71_9 = arg_71_3
	local get_color_with_alpha = Colors.get_color_with_alpha("lavender", 255)
	local get_color_with_alpha_2 = Colors.get_color_with_alpha("sky_blue", 255)
	local get_color_with_alpha_3 = Colors.get_color_with_alpha("orange", 255)

	ScriptGUI.ictext(arg_71_0, res_w, res_h, "BOT TRANSITIONS: ", str_2, num, str, arg_71_2 - 10, var_71_9, num_5, get_color_with_alpha_3)

	local num_6 = var_71_9 + 20
	local human_and_bot_players = Managers.player:human_and_bot_players()

	for k, v in pairs(human_and_bot_players) do
		if not v.bot_player then
			local player_unit = v.player_unit

			if not ALIVE[player_unit] then
				local profile_index = v:profile_index()
				local var_71_17 = SPProfiles[profile_index]
				local flag = not var_71_17 and var_71_17.unit_name
				local _active_nav_transitions = ScriptUnit.extension(player_unit, "ai_navigation_system")._active_nav_transitions
				local str_3 = "[" .. flag .. "]"

				ScriptGUI.ictext(arg_71_0, res_w, res_h, str_3, str_2, num, str, arg_71_2 - 10, num_6, num_5, get_color_with_alpha)

				num_6 = num_6 + 20
				k = 1

				for k_2, v_2 in pairs(_active_nav_transitions) do
					local format = string.format("    %d) %s", k, tostring(Unit.debug_name(k_2)))

					ScriptGUI.ictext(arg_71_0, res_w, res_h, format, str_2, num, str, arg_71_2 - 10, num_6, num_5, get_color_with_alpha_2)

					num_6 = num_6 + 20
					k = k + 1
				end
			end
		end
	end

	local num_7 = num_6 + 20

	ScriptGUI.icrect(arg_71_0, res_w, res_h, num_2, num_3, arg_71_2 + num_4, num_7, num_5 - 1, Color(200, 20, 20, 20))
end

AiUtils.push_intersecting_players = function (arg_72_0, arg_72_1, arg_72_2, arg_72_3, arg_72_4, arg_72_5, arg_72_6, ...)
	-- function 72
	local forward = Quaternion.forward(Unit.local_rotation(arg_72_0, 0))
	local local_position = Unit.local_position(arg_72_0, 0)
	local num = local_position + forward * arg_72_3.push_forward_offset
	local num_2 = arg_72_3.push_width * 1.5
	local dodged_width = arg_72_3.dodged_width

	dodged_width = not dodged_width and arg_72_3.dodged_width * 1.5

	local num_3 = local_position + forward * 3

	if not (not HEALTH_ALIVE[arg_72_1] and arg_72_1) then
		-- Nothing
	end

	::label_72_0::

	local var_72_6 = HEALTH_ALIVE[arg_72_0]

	var_72_6 = not var_72_6 and arg_72_0

	::label_72_1::

	local var_72_7 = Managers.state.side.side_by_unit[var_72_6]
	local flag = not var_72_7 and var_72_7.ENEMY_PLAYER_AND_BOT_UNITS

	if not flag then
		for i = 1, #flag do
			local var_72_9 = num_2
			local var_72_10 = flag[i]

			if not arg_72_2[var_72_10] then
				if arg_72_4 > arg_72_2[var_72_10] then
					arg_72_2[var_72_10] = nil
				end
			else
				local local_position_2 = Unit.local_position(var_72_10, 0)
				local num_4 = local_position_2 - num

				if not dodged_width then
					local has_extension = ScriptUnit.has_extension(var_72_10, "status_system")

					if not has_extension and not has_extension:get_is_dodging() then
						var_72_9 = dodged_width
					end
				end

				if var_72_9 > Vector3.length(num_4) then
					local num_5 = arg_72_3.push_width * arg_72_3.push_width
					local closest_point_on_line = Geometry.closest_point_on_line(local_position_2, local_position, num_3)
					local num_6 = local_position_2 - closest_point_on_line

					if num_5 > Vector3.length_squared(num_6) then
						local distance = Vector3.distance(local_position, closest_point_on_line)

						if not (not (distance < arg_72_3.ahead_dist) or ScriptUnit.has_extension(var_72_10, "status_system").knocked_down) then
							if not arg_72_2[var_72_10] then
								local num_7 = arg_72_3.player_pushed_speed * Vector3.normalize(local_position_2 - local_position)
								local extension = ScriptUnit.extension(var_72_10, "locomotion_system")
								local num_8 = 1 - distance / arg_72_3.ahead_dist
								local num_9 = num_8 * num_8

								extension:add_external_velocity(num_7 * num_9)

								if not arg_72_6 then
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
	-- function 73
	if not arg_73_4 then
		local var_73_0

		for i = 0, Unit.num_meshes(arg_73_0) - 1 do
			local mesh = Unit.mesh(arg_73_0, i)

			if not Mesh.has_material(mesh, arg_73_2) then
				local material = Mesh.material(mesh, arg_73_2)

				Material.set_scalar(material, arg_73_1, arg_73_3)
			end
		end
	else
		local mesh_2 = Unit.mesh(arg_73_0, arg_73_5)
		local material_2 = Mesh.material(mesh_2, arg_73_2)

		Material.set_scalar(material_2, arg_73_1, arg_73_3)
	end
end

AiUtils.allow_smart_object_layers = function (self, arg_74_1)
	-- function 74
	self:allow_layer("ledges", arg_74_1)
	self:allow_layer("ledges_with_fence", arg_74_1)
	self:allow_layer("doors", arg_74_1)
	self:allow_layer("planks", arg_74_1)
	self:allow_layer("jumps", arg_74_1)
	self:allow_layer("teleporters", arg_74_1)
end

AiUtils.shield_user = function (arg_75_0)
	-- function 75
	if not ScriptUnit.has_extension(arg_75_0, "ai_shield_system") then
		return false
	end

	return not ScriptUnit.extension(arg_75_0, "ai_shield_system").broken_shield
end

AiUtils.attack_is_shield_blocked = function (arg_76_0, arg_76_1, arg_76_2, arg_76_3)
	-- function 76
	assert(arg_76_1)

	if not ScriptUnit.has_extension(arg_76_0, "ai_shield_system") then
		return false
	end

	return (ScriptUnit.extension(arg_76_0, "ai_shield_system"):can_block_attack(arg_76_1, arg_76_2, arg_76_3))
end

AiUtils.attack_is_dodged = function (arg_77_0)
	-- function 77
	local go_id = Managers.state.unit_storage:go_id(arg_77_0)
	local game = Managers.state.network:game()

	return (GameSession.game_object_field(game, go_id, "is_dodging"))
end

AiUtils.unit_is_flanking_player = function (arg_78_0, arg_78_1, arg_78_2)
	-- function 78
	local network = Managers.state.network
	local unit_game_object_id = network:unit_game_object_id(arg_78_1)
	local game = network:game()

	if not game and not unit_game_object_id then
		local normalize = Vector3.normalize(POSITION_LOOKUP[arg_78_0] - POSITION_LOOKUP[arg_78_1])
		local flag = arg_78_2 or GameSession.game_object_field(game, unit_game_object_id, "aim_direction")
		local forward = Quaternion.forward(Quaternion.look(flag))

		return Vector3.dot(normalize, forward) < 0.4
	end

	return false
end

local num_6 = 0.0001

AiUtils.remove_bad_boxed_spline_points = function (self, arg_79_1)
	-- function 79
	local tbl = {}
	local unbox = self[1]:unbox()
	local var_79_2

	tbl[1] = unbox

	for i = 2, #self do
		local unbox_2 = self[i]:unbox()

		if Vector3.distance_squared(unbox, unbox_2) > num_6 then
			tbl[#tbl + 1] = unbox_2
			unbox = unbox_2
		else
			print("SPLINE HAS FAULTY POINTS (create_formation_data):", arg_79_1, i)
		end
	end

	return tbl
end

AiUtils.remove_bad_spline_points = function (self, arg_80_1)
	-- function 80
	local tbl = {}
	local var_80_1 = self[1]
	local var_80_2

	tbl[1] = var_80_1

	for i = 2, #self do
		local var_80_3 = self[i]

		if Vector3.distance_squared(var_80_1, var_80_3) > num_6 then
			tbl[#tbl + 1] = var_80_3
			var_80_1 = var_80_3
		else
			print("SPLINE HAS FAULTY POINTS (create_formation_data):", arg_80_1, i)
		end
	end

	return tbl
end

AiUtils.get_combat_conditions = function (self)
	-- function 81
	local target_unit = self.target_unit

	if not target_unit then
		local count = #self.proximite_enemies
		local get_data = Unit.get_data(target_unit, "breed")
		local tbl = {}
		local flag

		flag = (not (count > 3) or not 2 or not (count > 1)) and (not 1 or 0)
		tbl.enemy_arc = flag

		local primary_armor_category

		if not get_data then
			primary_armor_category = get_data.primary_armor_category

			if not primary_armor_category then
				-- Nothing
			end

			primary_armor_category = get_data.armor_category

			if not primary_armor_category then
				-- Nothing
			end
		end

		primary_armor_category = 1

		::label_81_0::

		tbl.target_armor = primary_armor_category

		return tbl
	end

	return nil
end

local num_7 = 5
local tbl_3 = {
	tap_attack = {
		speed_mod = 1.2,
		arc = 0,
		max_range = num_7,
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
		max_range = num_7,
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
local num_8 = 2
local tbl_4 = {
	0,
	0.2,
	0.4
}
local tbl_5 = {
	0.5,
	2,
	1.5,
	1,
	1.3,
	2
}
local tbl_6 = {
	1,
	-1,
	0,
	0,
	0,
	-2
}
local abs = math.abs

AiUtils.get_melee_weapon_score = function (self, arg_82_1)
	-- function 82
	local attack_meta_data

	if not arg_82_1 then
		attack_meta_data = arg_82_1.attack_meta_data

		if not attack_meta_data then
			-- Nothing
		end
	end

	attack_meta_data = tbl_3

	::label_82_0::

	local num = -1
	local str = "tap_attack"
	local var_82_3 = attack_meta_data[str]

	if not self then
		for k, v in pairs(attack_meta_data) do
			local num_2 = 0
			local target_armor = self.target_armor
			local clamp = math.clamp(self.enemy_arc + tbl_6[target_armor], 0, 2)
			local num_3 = 1 - abs(clamp - v.arc) / num_8
			local num_4 = num_2 + tbl_4[clamp + 1] * num_3
			local armor_modifiers = v.armor_modifiers

			if not armor_modifiers then
				local var_82_10 = armor_modifiers[target_armor]

				var_82_10 = var_82_10 or 0

				local var_82_11 = tbl_5[target_armor]

				var_82_11 = var_82_11 or 1

				local num_5 = var_82_10 * var_82_11
				local speed_mod = v.speed_mod

				speed_mod = speed_mod or 1
				num_4 = num_4 + num_5 * speed_mod
			end

			if num < num_4 then
				num = num_4
				str = k
				var_82_3 = v
			end
		end
	end

	return str, var_82_3, num
end

local num_9 = 0
local num_10 = 30 - num_9

AiUtils.get_party_danger = function ()
	-- function 83
	local conflict = Managers.state.conflict

	if not conflict then
		local get_threat_value = conflict:get_threat_value()

		return math.clamp((get_threat_value - num_9) / num_10, 0, 1)
	end

	return 0
end

AiUtils.get_bot_weapon_extension = function (self)
	-- function 84
	if not self then
		local inventory_extension = self.inventory_extension
		local get_item_data_and_weapon_extensions, var_84_2, var_84_3 = CharacterStateHelper.get_item_data_and_weapon_extensions(inventory_extension)
		local get_current_action_data, var_84_5, var_84_6 = CharacterStateHelper.get_current_action_data(var_84_3, var_84_2)

		if not var_84_5 then
			return var_84_5
		end

		local flag = not get_item_data_and_weapon_extensions and BackendUtils.get_item_template(get_item_data_and_weapon_extensions)

		if not flag and not flag.dominant_left then
			return var_84_3 or var_84_2
		else
			return var_84_2 or var_84_3
		end
	end

	return nil
end

AiUtils.taunt_unit = function (arg_85_0, arg_85_1, arg_85_2, arg_85_3)
	-- function 85
	local var_85_0 = BLACKBOARDS[arg_85_0]

	if not var_85_0 then
		local breed = var_85_0.breed

		if not ((not breed and not not breed.ignore_taunts or not breed.boss) and arg_85_3) then
			local time = Managers.time:time("game")
			local num = time + arg_85_2

			if var_85_0.taunt_unit == arg_85_1 then
				var_85_0.taunt_end_time = num
			else
				if var_85_0.target_unit == arg_85_1 then
					var_85_0.no_taunt_hesitate = true
				end

				var_85_0.taunt_unit = arg_85_1
				var_85_0.taunt_end_time = num
				var_85_0.target_unit = arg_85_1
				var_85_0.target_unit_found_time = time
			end
		end
	end
end

AiUtils.taunt_nearby_units = function (arg_86_0, arg_86_1, arg_86_2, arg_86_3, arg_86_4, arg_86_5)
	-- function 86
	local var_86_0 = Managers.state.side.side_by_unit[arg_86_0]
	local var_86_1 = POSITION_LOOKUP[arg_86_0]
	local alloc_table = FrameTable.alloc_table()
	local enemy_broadphase_categories = var_86_0.enemy_broadphase_categories
	local broadphase_query = AiUtils.broadphase_query(var_86_1, arg_86_1, alloc_table, enemy_broadphase_categories)

	for i = 1, broadphase_query do
		local var_86_5 = alloc_table[i]
		local var_86_6 = BLACKBOARDS[var_86_5]
		local override_targets = var_86_6.override_targets

		table.clear(override_targets)

		var_86_6.target_unit = nil
		override_targets[arg_86_0] = arg_86_3 + arg_86_2
	end

	if not arg_86_4 then
		local var_86_8 = NetworkLookup.effects[arg_86_4]
		local num = 0
		local flag = false

		Managers.state.network:rpc_play_particle_effect_no_rotation(nil, var_86_8, NetworkConstants.invalid_game_object_id, num, var_86_1, flag)
	end

	if not arg_86_5 then
		Managers.state.entity:system("audio_system"):play_audio_unit_event(arg_86_5, arg_86_0)
	end

	return alloc_table
end

AiUtils.calculate_animation_movespeed = function (self, arg_87_1, arg_87_2, arg_87_3)
	-- function 87
	local value = self[1].value
	local var_87_1 = POSITION_LOOKUP[arg_87_1]
	local var_87_2 = POSITION_LOOKUP[arg_87_2]
	local distance = Vector3.distance(var_87_1, var_87_2)

	if distance > math.epsilon then
		local has_extension = ScriptUnit.has_extension(arg_87_2, "locomotion_system")

		if not has_extension and not has_extension.current_velocity then
			local current_velocity = has_extension:current_velocity()

			if Vector3.length_squared(current_velocity) > 0 then
				local num = current_velocity * (1 + (arg_87_3 or 1))
				local current_velocity_2 = ScriptUnit.extension(arg_87_1, "locomotion_system"):current_velocity()
				local length = Vector3.length(current_velocity_2)

				if length > 0 then
					local var_87_9 = num
					local num_2 = Vector3.normalize(var_87_2 - var_87_1) * Vector3.length(num)
					local num_3 = Vector3.dot(var_87_9, num_2) / distance * num_2

					distance = distance + Vector3.length(num_3 / length)
				end
			end
		end
	end

	local var_87_12 = value
	local count = #self

	for i = 1, count do
		local var_87_14 = self[i]
		local distance_2 = var_87_14.distance
		local value_2 = var_87_14.value

		if i < count then
			local var_87_17 = self[i + 1]
			local distance_3 = var_87_17.distance
			local value_3 = var_87_17.value

			if distance_3 < distance then
				local inv_lerp = math.inv_lerp(distance_2, distance_3, distance)

				var_87_12 = math.lerp_clamped(value_2, value_3, inv_lerp)

				break
			end
		else
			var_87_12 = value_2
		end
	end

	return var_87_12
end

AiUtils.magic_entrance_optional_spawned_func = function (arg_88_0, arg_88_1, arg_88_2)
	-- function 88
	if not (arg_88_1.special or arg_88_1.boss or arg_88_1.cannot_be_aggroed) then
		local get_random_alive_hero = PlayerUtils.get_random_alive_hero()

		AiUtils.aggro_unit_of_enemy(arg_88_0, get_random_alive_hero)
	end

	local str = "fx/grudge_marks_shadow_step"
	local var_88_2 = NetworkLookup.effects[str]
	local num = 0

	Managers.state.network:rpc_play_particle_effect_no_rotation(nil, var_88_2, NetworkConstants.invalid_game_object_id, num, POSITION_LOOKUP[arg_88_0], false)

	local var_88_4 = BLACKBOARDS[arg_88_0]

	if not var_88_4 then
		Managers.state.entity:system("audio_system"):play_audio_unit_event("Play_normal_spawn_stinger", arg_88_0)

		local forward = Quaternion.forward(Quaternion.axis_angle(Vector3.up(), math.pi * 2 * math.random()))
		local num_2 = 0.5
		local medium = scripts_utils_stagger_types.medium
		local num_3 = 0.5
		local time = Managers.time:time("game")

		AiUtils.stagger(arg_88_0, var_88_4, arg_88_0, forward, num_2, medium, num_3, nil, time)
	end
end

AiUtils.is_part_of_patrol = function (arg_89_0)
	-- function 89
	local go_id = Managers.state.unit_storage:go_id(arg_89_0)

	if not go_id then
		return false
	end

	if not ScriptUnit.has_extension(arg_89_0, "ai_group_system") then
		return false
	end

	local game = Managers.state.network:game()

	return GameSession.game_object_field(game, go_id, "ai_group_id") ~= AIGroupSystem.invalid_group_uid
end

AiUtils.is_aggroed = function (arg_90_0)
	-- function 90
	local go_id = Managers.state.unit_storage:go_id(arg_90_0)

	if not go_id then
		return false
	end

	local game = Managers.state.network:game()

	return GameSession.game_object_field(game, go_id, "target_unit_id") ~= NetworkConstants.invalid_game_object_id
end

AiUtils.breed_height = function (arg_91_0)
	-- function 91
	local var_91_0 = BLACKBOARDS[arg_91_0]
	local breed

	if not var_91_0 then
		breed = var_91_0.breed

		if not breed then
			-- Nothing
		end
	end

	breed = Unit.get_data(arg_91_0, "breed")

	::label_91_0::

	local height = breed.height

	if not height then
		return nil
	end

	return height * Unit.local_scale(arg_91_0, 0)[3]
end

local num_11 = 1
local tbl_7 = {
	"j_hips",
	"j_leftforearm",
	"j_rightforearm",
	"j_head"
}
local count = #tbl_7

local function fn(arg_92_0, arg_92_1, arg_92_2)
	-- function 92
	local var_92_0 = tbl_7[arg_92_2]
	local has_node = Unit.has_node(arg_92_1, var_92_0)
	local var_92_2

	if not has_node then
		local node = Unit.node(arg_92_1, var_92_0)
		local get_data = World.get_data(Unit.world(arg_92_1), "physics_world")
		local world_position = Unit.world_position(arg_92_1, node)
		local distance = Vector3.distance(arg_92_0, world_position)
		local var_92_7 = world_position

		if distance > num_11 then
			local num = (world_position - arg_92_0) / distance
			local immediate_raycast, var_92_10 = PhysicsWorld.immediate_raycast(get_data, arg_92_0, num, distance, "closest", "types", "statics", "collision_filter", "filter_ai_line_of_sight_check")

			if not immediate_raycast then
				return false
			end
		end
	end

	return true
end

AiUtils.line_of_sight_from_random_point = function (arg_93_0, arg_93_1, arg_93_2, arg_93_3)
	-- function 93
	local min = math.min(arg_93_2 or 1, count)
	local flag = arg_93_3 or math.random(1, count)
	local var_93_2

	for i = 1, min do
		var_93_2 = math.index_wrapper(flag + i - 1, count)

		if not fn(arg_93_0, arg_93_1, var_93_2) then
			return true
		end
	end

	return false, var_93_2
end

AiUtils.bot_melee_aim_pos = function (arg_94_0, arg_94_1, arg_94_2)
	-- function 94
	local var_94_0 = BLACKBOARDS[arg_94_1]
	local flag = not var_94_0 and var_94_0.breed
	local bot_melee_aim_node

	if not flag then
		bot_melee_aim_node = flag.bot_melee_aim_node

		if not bot_melee_aim_node then
			bot_melee_aim_node = "j_spine"
		end
	else
		bot_melee_aim_node = "rp_center"
	end

	local local_position = Unit.local_position(arg_94_0, 0)
	local var_94_4

	if type(bot_melee_aim_node) == "table" then
		local huge = math.huge
		local var_94_6

		for i = 1, #bot_melee_aim_node do
			local var_94_7 = bot_melee_aim_node[i]

			if not Unit.has_node(arg_94_1, var_94_7) then
				local world_position = Unit.world_position(arg_94_1, Unit.node(arg_94_1, var_94_7))
				local distance_squared = Vector3.distance_squared(local_position, world_position)

				if distance_squared < huge then
					var_94_6 = world_position
					huge = distance_squared
				end
			end
		end

		var_94_4 = var_94_6 or Unit.world_position(arg_94_1, 0)
	else
		var_94_4 = not Unit.has_node(arg_94_1, bot_melee_aim_node) and Unit.world_position(arg_94_1, Unit.node(arg_94_1, bot_melee_aim_node)) and Unit.world_position(arg_94_1, 0)
	end

	if not arg_94_2 then
		arg_94_2:store(var_94_4)
	end

	return var_94_4
end
