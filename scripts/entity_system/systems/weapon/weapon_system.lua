-- chunkname: @scripts/entity_system/systems/weapon/weapon_system.lua

require("scripts/unit_extensions/weapons/weapon_unit_extension")
require("scripts/unit_extensions/weapons/husk_weapon_unit_extension")
require("scripts/unit_extensions/weapons/ai_weapon_unit_extension")
require("scripts/unit_extensions/weapons/single_weapon_unit_extension")

WeaponSystem = class(WeaponSystem, ExtensionSystemBase)
global_is_inside_inn = false

local var_0_0 = {
	"rpc_attack_hit",
	"rpc_alert_enemy",
	"rpc_ai_weapon_shoot_start",
	"rpc_ai_weapon_shoot",
	"rpc_ai_weapon_shoot_end",
	"rpc_start_beam",
	"rpc_end_beam",
	"rpc_start_flamethrower",
	"rpc_end_flamethrower",
	"rpc_set_stormfiend_beam",
	"rpc_start_geiser",
	"rpc_end_geiser",
	"rpc_weapon_blood",
	"rpc_play_fx",
	"rpc_change_single_weapon_state",
	"rpc_change_synced_weapon_state",
	"rpc_summon_vortex",
	"rpc_start_soul_rip",
	"rpc_stop_soul_rip",
	"rpc_soul_rip_burst"
}
local var_0_1 = {
	"WeaponUnitExtension",
	"HuskWeaponUnitExtension",
	"AiWeaponUnitExtension",
	"SingleWeaponUnitExtension"
}

WeaponSystem.init = function (arg_1_0, arg_1_1, arg_1_2)
	WeaponSystem.super.init(arg_1_0, arg_1_1, arg_1_2, var_0_1)

	local var_1_0 = arg_1_1.network_event_delegate

	arg_1_0.network_event_delegate = var_1_0

	var_1_0:register(arg_1_0, unpack(var_0_0))

	global_is_inside_inn = LevelSettings[arg_1_1.startup_data.level_key].hub_level or false
	arg_1_0._player_damage_forbidden = Managers.state.game_mode:setting("player_damage_forbidden")
	arg_1_0.game = Managers.state.network:game()
	arg_1_0.network_manager = Managers.state.network
	arg_1_0._beam_particle_effects = {}
	arg_1_0._geiser_particle_effects = {}
	arg_1_0._flamethrower_particle_effects = {}
	arg_1_0._soul_rip_spline_ids_lookup = {}
	arg_1_0._soul_rip_particle_effects = {}
	arg_1_0._chained_projectiles = {}
end

WeaponSystem.on_add_extension = function (arg_2_0, arg_2_1, arg_2_2, arg_2_3, arg_2_4)
	arg_2_4.weapon_system = arg_2_0

	local var_2_0 = WeaponSystem.super.on_add_extension(arg_2_0, arg_2_1, arg_2_2, arg_2_3, arg_2_4)

	arg_2_4.weapon_system = nil

	return var_2_0
end

WeaponSystem.rpc_alert_enemy = function (arg_3_0, arg_3_1, arg_3_2, arg_3_3)
	local var_3_0 = arg_3_0.unit_storage:unit(arg_3_2)

	if not HEALTH_ALIVE[var_3_0] then
		return
	end

	local var_3_1 = arg_3_0.unit_storage:unit(arg_3_3)

	AiUtils.alert_unit_of_enemy(var_3_0, var_3_1)
end

local var_0_2 = {
	{
		default = 0,
		name = "power_level",
		min = MIN_POWER_LEVEL,
		max = MAX_POWER_LEVEL
	},
	{
		default = 0,
		name = "hit_target_index"
	},
	{
		default = 0,
		name = "boost_curve_multiplier"
	},
	{
		default = false,
		name = "is_critical_strike"
	},
	{
		default = true,
		name = "can_damage"
	},
	{
		default = true,
		name = "can_stagger"
	},
	{
		default = 1,
		name = "hit_ragdoll_actor"
	},
	{
		default = false,
		name = "blocking"
	},
	{
		default = false,
		name = "shield_break_procced"
	},
	{
		default = 1,
		name = "backstab_multiplier"
	},
	{
		default = false,
		name = "attacker_is_level_unit"
	},
	{
		default = false,
		name = "first_hit"
	},
	{
		default = 0,
		name = "total_hits"
	}
}

for iter_0_0 = 1, #var_0_2 do
	var_0_2[var_0_2[iter_0_0].name] = iter_0_0
end

local var_0_3 = {}

WeaponSystem.send_rpc_attack_hit = function (arg_4_0, arg_4_1, arg_4_2, arg_4_3, arg_4_4, arg_4_5, arg_4_6, arg_4_7, ...)
	table.clear(var_0_3)

	local var_4_0 = select("#", ...)

	for iter_4_0 = 1, var_4_0, 2 do
		local var_4_1 = select(iter_4_0, ...)
		local var_4_2 = select(iter_4_0 + 1, ...)

		var_0_3[var_0_2[var_4_1]] = var_4_2
	end

	for iter_4_1 = 1, #var_0_2 do
		local var_4_3 = var_0_2[iter_4_1]
		local var_4_4 = var_0_3[iter_4_1]

		if var_4_4 == nil then
			var_4_4 = var_4_3.default
		end

		if var_4_3.min and var_4_3.max then
			var_4_4 = math.clamp(var_4_4, var_4_3.min, var_4_3.max)
		elseif var_4_3.min then
			var_4_4 = math.max(var_4_4, var_4_3.min)
		elseif var_4_3.max then
			var_4_4 = math.min(var_4_4, var_4_3.max)
		end

		var_0_3[iter_4_1] = var_4_4
	end

	if arg_4_0.is_server or LEVEL_EDITOR_TEST then
		arg_4_0:rpc_attack_hit(nil, arg_4_1, arg_4_2, arg_4_3, arg_4_4, arg_4_5, arg_4_6, arg_4_7, unpack(var_0_3))
	else
		Managers.state.network.network_transmit:send_rpc_server("rpc_attack_hit", arg_4_1, arg_4_2, arg_4_3, arg_4_4, arg_4_5, arg_4_6, arg_4_7, unpack(var_0_3))
	end

	local var_4_5 = arg_4_0.unit_storage:unit(arg_4_3)
	local var_4_6 = arg_4_0.unit_storage:unit(arg_4_2)

	if Managers.player:is_player_unit(var_4_6) then
		local var_4_7 = Managers.player:owner(var_4_6)

		if var_4_7.local_player and not var_4_7.bot_player then
			local var_4_8 = Unit.get_data(var_4_5, "breed")
			local var_4_9 = Managers.state.entity:system("ai_system"):get_attributes(var_4_5)

			if var_4_8 and var_4_8.show_health_bar or var_4_9.grudge_marked then
				Managers.state.event:trigger("boss_health_bar_register_unit", var_4_5, "damage_done")
			end
		end
	end
end

local var_0_4 = BLACKBOARDS

WeaponSystem.rpc_attack_hit = function (arg_5_0, arg_5_1, arg_5_2, arg_5_3, arg_5_4, arg_5_5, arg_5_6, arg_5_7, arg_5_8, arg_5_9, arg_5_10, arg_5_11, arg_5_12, arg_5_13, arg_5_14, arg_5_15, arg_5_16, arg_5_17, arg_5_18, arg_5_19, arg_5_20, arg_5_21)
	local var_5_0 = arg_5_0.unit_storage:unit(arg_5_4)
	local var_5_1 = arg_5_0.network_manager:game_object_or_level_unit(arg_5_3, arg_5_19)

	if not Unit.alive(var_5_0) or not Unit.alive(var_5_1) then
		return
	end

	local var_5_2 = NetworkLookup.damage_sources[arg_5_2]
	local var_5_3 = Managers.player
	local var_5_4 = var_5_3:is_player_unit(var_5_1)
	local var_5_5 = var_5_3:is_player_unit(var_5_0) and var_5_4

	if var_5_5 then
		if arg_5_0._player_damage_forbidden then
			return
		end

		if var_5_2 == "vs_ratling_gunner_gun" and ScriptUnit.extension(var_5_0, "status_system"):is_grabbed_by_pack_master() then
			ScriptUnit.extension_input(var_5_1, "dialogue_system"):trigger_dialogue_event("vs_shooting_hooked_hero")
		end
	end

	local var_5_6 = NetworkLookup.hit_zones[arg_5_5]
	local var_5_7 = var_0_4[var_5_0]
	local var_5_8 = ScriptUnit.has_extension(var_5_0, "ai_slot_system")
	local var_5_9 = ScriptUnit.has_extension(var_5_1, "target_override_system") and ScriptUnit.extension(var_5_1, "target_override_system") or nil
	local var_5_10 = ScriptUnit.has_extension(var_5_1, "status_system") and ScriptUnit.extension(var_5_1, "status_system") or nil
	local var_5_11 = var_5_10 and not var_5_10:is_disabled() or nil
	local var_5_12 = DamageUtils.is_enemy(var_5_1, var_5_0)
	local var_5_13 = NetworkLookup.hit_ragdoll_actors[arg_5_15]
	local var_5_14 = NetworkLookup.damage_profiles[arg_5_8]
	local var_5_15 = DamageProfileTemplates[var_5_14]

	if var_5_13 == "n/a" then
		var_5_13 = nil
	end

	if arg_5_10 == 0 then
		arg_5_10 = nil
	end

	if var_5_5 and arg_5_16 then
		local var_5_16 = var_5_15.fatigue_type
		local var_5_17 = 1
		local var_5_18 = true
		local var_5_19 = "left"
		local var_5_20 = Managers.state.network

		if arg_5_0.is_server then
			local var_5_21 = NetworkLookup.fatigue_types[var_5_16]

			var_5_20.network_transmit:send_rpc_server("rpc_player_blocked_attack", arg_5_4, var_5_21, arg_5_3, var_5_17, var_5_18, var_5_19, arg_5_19)
		end
	end

	local var_5_22
	local var_5_23 = false

	if var_5_7 and var_5_7.breed and var_5_7.breed.is_ai then
		if var_5_7.breed.use_predicted_damage_in_stagger_calculation then
			local var_5_24 = var_5_15.targets and var_5_15.targets[arg_5_10] or var_5_15.default_target

			if var_5_24 then
				local var_5_25 = BoostCurves[var_5_24.boost_curve_type]

				var_5_22 = DamageUtils.calculate_damage(DamageOutput, var_5_0, var_5_1, var_5_6, arg_5_9, var_5_25, arg_5_11, arg_5_12, var_5_15, arg_5_10, arg_5_18, var_5_2)
			end
		end

		if var_5_12 and var_5_8 and var_5_9 and var_5_11 and next(var_5_7.override_targets) and HEALTH_ALIVE[var_5_0] then
			local var_5_26 = Managers.time:time("game")

			var_5_9:add_to_override_targets(var_5_0, var_5_1, var_5_7, var_5_26)
		end

		var_5_23 = not var_5_7.breed.unbreakable_shield and (var_5_15.shield_break or arg_5_17)
	end

	local var_5_27 = arg_5_0.t

	DamageUtils.server_apply_hit(var_5_27, var_5_1, var_5_0, var_5_6 or "full", arg_5_6, arg_5_7, var_5_13, var_5_2, arg_5_9, var_5_15, arg_5_10, arg_5_11, arg_5_12, arg_5_13, arg_5_14, arg_5_16, var_5_23, arg_5_18, arg_5_20, arg_5_21, nil, var_5_22)
end

WeaponSystem.destroy = function (arg_6_0)
	local var_6_0 = arg_6_0.world

	for iter_6_0, iter_6_1 in pairs(arg_6_0._beam_particle_effects) do
		World.destroy_particles(var_6_0, iter_6_1.beam_effect)
		World.destroy_particles(var_6_0, iter_6_1.beam_end_effect)
	end

	arg_6_0._beam_particle_effects = nil

	arg_6_0.network_event_delegate:unregister(arg_6_0)
end

WeaponSystem.update = function (arg_7_0, arg_7_1, arg_7_2)
	WeaponSystem.super.update(arg_7_0, arg_7_1, arg_7_2)

	arg_7_0.t = arg_7_2

	arg_7_0:update_synced_beam_particle_effects()
	arg_7_0:update_synced_geiser_particle_effects(arg_7_1, arg_7_2)
	arg_7_0:update_synced_flamethrower_particle_effects()
	arg_7_0:_update_chained_projectiles(arg_7_2)
	arg_7_0:update_synced_soul_rip_particle_effects()
end

local var_0_5 = 1
local var_0_6 = 4

WeaponSystem.update_synced_beam_particle_effects = function (arg_8_0)
	local var_8_0 = arg_8_0.game
	local var_8_1 = arg_8_0.network_manager
	local var_8_2 = World.get_data(arg_8_0.world, "physics_world")

	for iter_8_0, iter_8_1 in pairs(arg_8_0._beam_particle_effects) do
		local var_8_3 = var_8_1:unit_game_object_id(iter_8_0)
		local var_8_4 = iter_8_1.weapon_unit

		if not var_8_3 or not Unit.alive(var_8_4) then
			World.destroy_particles(arg_8_0.world, iter_8_1.beam_effect)
			World.destroy_particles(arg_8_0.world, iter_8_1.beam_end_effect)

			arg_8_0._beam_particle_effects[iter_8_0] = nil
		else
			local var_8_5 = GameSession.game_object_field(var_8_0, var_8_3, "aim_direction")
			local var_8_6 = GameSession.game_object_field(var_8_0, var_8_3, "aim_position")
			local var_8_7 = iter_8_1.range
			local var_8_8 = PhysicsWorld.immediate_raycast_actors(var_8_2, var_8_6, var_8_5, var_8_7, "static_collision_filter", "filter_player_ray_projectile_static_only", "dynamic_collision_filter", "filter_player_ray_projectile_ai_only", "dynamic_collision_filter", "filter_player_ray_projectile_hitbox_only")
			local var_8_9 = var_8_6 + var_8_5 * var_8_7
			local var_8_10
			local var_8_11

			if var_8_8 then
				local var_8_12 = Managers.state.difficulty:get_difficulty_settings()
				local var_8_13 = Managers.player:owner(iter_8_0)
				local var_8_14 = var_8_13 and DamageUtils.allow_friendly_fire_ranged(var_8_12, var_8_13)

				for iter_8_2, iter_8_3 in pairs(var_8_8) do
					local var_8_15 = iter_8_3[var_0_5]
					local var_8_16 = iter_8_3[var_0_6]
					local var_8_17 = Actor.unit(var_8_16)

					if var_8_17 ~= iter_8_0 then
						local var_8_18 = Unit.get_data(var_8_17, "breed")
						local var_8_19

						if var_8_18 then
							local var_8_20 = DamageUtils.is_enemy(iter_8_0, var_8_17)
							local var_8_21 = Actor.node(var_8_16)
							local var_8_22 = var_8_18.hit_zones_lookup[var_8_21].name

							var_8_19 = (var_8_14 and var_8_18.is_player or var_8_20) and var_8_22 ~= "afro"
						else
							var_8_19 = true
						end

						if var_8_19 then
							var_8_10 = var_8_15
							var_8_11 = var_8_17
						end

						break
					end
				end
			end

			if var_8_11 then
				var_8_9 = var_8_10
			end

			local var_8_23 = Unit.world_position(var_8_4, Unit.node(var_8_4, "fx_muzzle"))
			local var_8_24 = Vector3.distance(var_8_23, var_8_9)
			local var_8_25 = Vector3.normalize(var_8_23 - var_8_9)
			local var_8_26 = Quaternion.look(var_8_25)
			local var_8_27 = arg_8_0.world

			World.move_particles(var_8_27, iter_8_1.beam_end_effect, var_8_9)
			World.move_particles(var_8_27, iter_8_1.beam_effect, var_8_9, var_8_26)
			World.set_particles_variable(var_8_27, iter_8_1.beam_effect, iter_8_1.beam_effect_length_id, Vector3(0.3, var_8_24, 0))
		end
	end
end

local function var_0_7(arg_9_0, arg_9_1, arg_9_2, arg_9_3, arg_9_4, arg_9_5, arg_9_6, arg_9_7)
	local var_9_0 = arg_9_2 / arg_9_1

	for iter_9_0 = 1, arg_9_1 do
		local var_9_1 = arg_9_3 + arg_9_4 * var_9_0
		local var_9_2 = var_9_1 - arg_9_3
		local var_9_3 = Vector3.normalize(var_9_2)
		local var_9_4 = Vector3.length(var_9_2)
		local var_9_5, var_9_6, var_9_7, var_9_8, var_9_9 = PhysicsWorld.immediate_raycast(arg_9_0, arg_9_3, var_9_3, var_9_4, "closest", "collision_filter", arg_9_6)

		if var_9_6 then
			return var_9_5, var_9_6, var_9_7, var_9_8, var_9_9
		end

		arg_9_4 = arg_9_4 + arg_9_5 * var_9_0
		arg_9_3 = var_9_1
	end

	return false, arg_9_3
end

WeaponSystem.update_synced_geiser_particle_effects = function (arg_10_0, arg_10_1, arg_10_2)
	local var_10_0 = arg_10_0.game
	local var_10_1 = arg_10_0.network_manager
	local var_10_2 = arg_10_0.world
	local var_10_3 = World.get_data(var_10_2, "physics_world")

	for iter_10_0, iter_10_1 in pairs(arg_10_0._geiser_particle_effects) do
		repeat
			local var_10_4 = var_10_1:game_object_or_level_unit(iter_10_0)

			if not ALIVE[var_10_4] then
				if iter_10_1.geiser_effect then
					World.destroy_particles(var_10_2, iter_10_1.geiser_effect)
				end

				arg_10_0._geiser_particle_effects[iter_10_0] = nil

				break
			end

			if not iter_10_1.geiser_effect then
				break
			end

			local var_10_5 = (arg_10_2 - iter_10_1.time_to_shoot) / iter_10_1.charge_time
			local var_10_6 = math.min(iter_10_1.max_radius, iter_10_1.max_radius * var_10_5 + iter_10_1.min_radius)
			local var_10_7 = GameSession.game_object_field(var_10_0, iter_10_0, "aim_position")
			local var_10_8 = Vector3(0, 0, 1)
			local var_10_9 = Quaternion.look(GameSession.game_object_field(var_10_0, iter_10_0, "aim_direction"), var_10_8)
			local var_10_10 = 10
			local var_10_11 = 1.5
			local var_10_12 = 15
			local var_10_13 = iter_10_1.angle
			local var_10_14 = Quaternion.forward(Quaternion.multiply(var_10_9, Quaternion(Vector3.right(), var_10_13))) * var_10_12
			local var_10_15 = Vector3(0, 0, -9.82)
			local var_10_16 = "filter_geiser_check"
			local var_10_17, var_10_18, var_10_19, var_10_20 = var_0_7(var_10_3, var_10_10, var_10_11, var_10_7, var_10_14, var_10_15, var_10_16, false)
			local var_10_21 = var_10_18

			World.move_particles(var_10_2, iter_10_1.geiser_effect, var_10_21)
			World.set_particles_variable(var_10_2, iter_10_1.geiser_effect, iter_10_1.geiser_effect_variable, Vector3(var_10_6 * 2, var_10_6 * 2, 1))
		until true
	end
end

WeaponSystem.update_synced_flamethrower_particle_effects = function (arg_11_0)
	local var_11_0 = arg_11_0.network_manager

	for iter_11_0, iter_11_1 in pairs(arg_11_0._flamethrower_particle_effects) do
		local var_11_1 = var_11_0:unit_game_object_id(iter_11_0)
		local var_11_2 = iter_11_1.weapon_unit

		if not var_11_1 or not Unit.alive(var_11_2) then
			World.stop_spawning_particles(arg_11_0.world, iter_11_1.flamethrower_effect)

			arg_11_0._flamethrower_particle_effects[iter_11_0] = nil
		else
			local var_11_3 = arg_11_0.world
			local var_11_4 = Unit.world_position(var_11_2, Unit.node(var_11_2, "fx_muzzle"))
			local var_11_5 = Unit.world_rotation(var_11_2, Unit.node(var_11_2, "fx_muzzle"))

			World.move_particles(var_11_3, iter_11_1.flamethrower_effect, var_11_4, var_11_5)
		end
	end
end

WeaponSystem.rpc_ai_weapon_shoot_start = function (arg_12_0, arg_12_1, arg_12_2, arg_12_3)
	local var_12_0 = Managers.state.unit_storage:unit(arg_12_2)

	if not var_12_0 then
		return
	end

	local var_12_1 = Unit.get_data(var_12_0, "breed")
	local var_12_2 = ScriptUnit.extension(var_12_0, "ai_inventory_system")
	local var_12_3 = var_12_1.default_inventory_template
	local var_12_4 = var_12_2:get_unit(var_12_3)

	ScriptUnit.extension(var_12_4, "weapon_system"):shoot_start(var_12_0, arg_12_3 / 100)
end

WeaponSystem.rpc_ai_weapon_shoot = function (arg_13_0, arg_13_1, arg_13_2)
	local var_13_0 = Managers.state.unit_storage:unit(arg_13_2)

	if not var_13_0 then
		return
	end

	local var_13_1 = Unit.get_data(var_13_0, "breed")
	local var_13_2 = ScriptUnit.extension(var_13_0, "ai_inventory_system")
	local var_13_3 = var_13_1.default_inventory_template
	local var_13_4 = var_13_2:get_unit(var_13_3)

	ScriptUnit.extension(var_13_4, "weapon_system"):shoot(var_13_0)
end

WeaponSystem.rpc_ai_weapon_shoot_end = function (arg_14_0, arg_14_1, arg_14_2)
	local var_14_0 = Managers.state.unit_storage:unit(arg_14_2)

	if not var_14_0 then
		return
	end

	local var_14_1 = Unit.get_data(var_14_0, "breed")
	local var_14_2 = ScriptUnit.extension(var_14_0, "ai_inventory_system")
	local var_14_3 = var_14_1.default_inventory_template
	local var_14_4 = var_14_2:get_unit(var_14_3)

	ScriptUnit.extension(var_14_4, "weapon_system"):shoot_end(var_14_0)
end

WeaponSystem.rpc_change_single_weapon_state = function (arg_15_0, arg_15_1, arg_15_2, arg_15_3)
	local var_15_0 = Managers.state.unit_storage:unit(arg_15_2)

	if not var_15_0 then
		return
	end

	local var_15_1 = NetworkLookup.single_weapon_states[arg_15_3]
	local var_15_2 = true
	local var_15_3 = CHANNEL_TO_PEER_ID[arg_15_1]

	arg_15_0:change_single_weapon_state(var_15_0, var_15_1, var_15_3, var_15_2)
end

WeaponSystem.change_single_weapon_state = function (arg_16_0, arg_16_1, arg_16_2, arg_16_3, arg_16_4)
	local var_16_0 = var_0_4[arg_16_1]

	if var_16_0 then
		local var_16_1 = var_16_0.weapon_unit

		if var_16_1 then
			ScriptUnit.extension(var_16_1, "weapon_system"):change_state(arg_16_2)
		end
	end

	local var_16_2 = Managers.state.unit_storage:go_id(arg_16_1)
	local var_16_3 = NetworkLookup.single_weapon_states[arg_16_2]

	if arg_16_0.is_server then
		arg_16_0.network_transmit:send_rpc_clients_except("rpc_change_single_weapon_state", arg_16_3, var_16_2, var_16_3)
	elseif not arg_16_4 then
		arg_16_0.network_transmit:send_rpc_server("rpc_change_single_weapon_state", var_16_2, var_16_3)
	end
end

WeaponSystem.rpc_change_synced_weapon_state = function (arg_17_0, arg_17_1, arg_17_2, arg_17_3)
	local var_17_0 = Managers.state.unit_storage:unit(arg_17_2)

	if not var_17_0 then
		return
	end

	local var_17_1 = true
	local var_17_2 = NetworkLookup.weapon_synced_states[arg_17_3]

	if var_17_2 == "n/a" then
		var_17_2 = nil
	end

	local var_17_3 = arg_17_0:_first_wielded_weapon_unit(var_17_0)
	local var_17_4 = ScriptUnit.has_extension(var_17_3, "weapon_system")

	if not var_17_4 then
		return
	end

	var_17_4:change_synced_state(var_17_2, var_17_1)

	if arg_17_0.is_server then
		local var_17_5 = CHANNEL_TO_PEER_ID[arg_17_1]

		arg_17_0.network_transmit:send_rpc_clients_except("rpc_change_synced_weapon_state", var_17_5, arg_17_2, arg_17_3)
	end
end

WeaponSystem.get_synced_weapon_state = function (arg_18_0, arg_18_1)
	local var_18_0 = arg_18_0:_first_wielded_weapon_unit(arg_18_1)

	if not var_18_0 then
		return nil
	end

	local var_18_1 = ScriptUnit.extension(var_18_0, "weapon_system")

	if not var_18_1.current_synced_state then
		return nil
	end

	return var_18_1:current_synced_state()
end

WeaponSystem._first_wielded_weapon_unit = function (arg_19_0, arg_19_1)
	local var_19_0 = ScriptUnit.extension(arg_19_1, "inventory_system"):equipment()

	return var_19_0.left_hand_wielded_unit or var_19_0.right_hand_wielded_unit or var_19_0.left_hand_wielded_unit_3p or var_19_0.right_hand_wielded_unit_3p
end

WeaponSystem.rpc_start_beam = function (arg_20_0, arg_20_1, arg_20_2, arg_20_3, arg_20_4, arg_20_5)
	if not LEVEL_EDITOR_TEST then
		local var_20_0 = arg_20_0.unit_storage:unit(arg_20_2)
		local var_20_1 = NetworkLookup.effects[arg_20_3]
		local var_20_2 = NetworkLookup.effects[arg_20_4]
		local var_20_3 = ScriptUnit.extension(var_20_0, "inventory_system"):equipment()
		local var_20_4 = var_20_3.right_hand_wielded_unit_3p or var_20_3.left_hand_wielded_unit_3p
		local var_20_5 = arg_20_0.world

		arg_20_0._beam_particle_effects[var_20_0] = {
			beam_effect = World.create_particles(var_20_5, var_20_1, Vector3.zero()),
			beam_end_effect = World.create_particles(var_20_5, var_20_2, Vector3.zero()),
			beam_effect_length_id = World.find_particles_variable(var_20_5, var_20_1, "trail_length"),
			beam_effect_name = var_20_1,
			beam_end_effect_name = var_20_2,
			range = arg_20_5,
			weapon_unit = var_20_4
		}

		if arg_20_0.is_server then
			local var_20_6 = CHANNEL_TO_PEER_ID[arg_20_1]

			arg_20_0.network_transmit:send_rpc_clients_except("rpc_start_beam", var_20_6, arg_20_2, arg_20_3, arg_20_4, arg_20_5)
		end
	end
end

WeaponSystem.rpc_end_beam = function (arg_21_0, arg_21_1, arg_21_2)
	if not LEVEL_EDITOR_TEST then
		local var_21_0 = arg_21_0.world
		local var_21_1 = arg_21_0.unit_storage:unit(arg_21_2)
		local var_21_2 = arg_21_0._beam_particle_effects[var_21_1]

		if var_21_2 then
			World.destroy_particles(var_21_0, var_21_2.beam_effect)
			World.destroy_particles(var_21_0, var_21_2.beam_end_effect)

			arg_21_0._beam_particle_effects[var_21_1] = nil

			if arg_21_0.is_server then
				local var_21_3 = CHANNEL_TO_PEER_ID[arg_21_1]

				arg_21_0.network_transmit:send_rpc_clients_except("rpc_end_beam", var_21_3, arg_21_2)
			end
		end
	end
end

WeaponSystem.rpc_start_geiser = function (arg_22_0, arg_22_1, arg_22_2, arg_22_3, arg_22_4, arg_22_5, arg_22_6, arg_22_7)
	if not LEVEL_EDITOR_TEST then
		local var_22_0 = CHANNEL_TO_PEER_ID[arg_22_1]

		if not var_22_0 then
			return
		end

		local var_22_1 = Managers.state.side
		local var_22_2 = var_22_1:get_side_from_player_unique_id(var_22_0 .. ":1")
		local var_22_3 = NetworkLookup.effects[arg_22_3]
		local var_22_4 = {
			side = var_22_2,
			min_radius = arg_22_4,
			max_radius = arg_22_5,
			charge_time = arg_22_6,
			angle = arg_22_7,
			time_to_shoot = Managers.time:time("game"),
			start_time = Managers.time:time("game"),
			geiser_effect_name = var_22_3
		}

		arg_22_0._geiser_particle_effects[arg_22_2] = var_22_4

		if arg_22_0.is_server then
			arg_22_0.network_transmit:send_rpc_side_clients_except("rpc_start_geiser", var_22_2, true, true, var_22_0, arg_22_2, arg_22_3, arg_22_4, arg_22_5, arg_22_6, arg_22_7)

			if DEDICATED_SERVER then
				return
			end

			local var_22_5 = Managers.player:local_player()
			local var_22_6 = var_22_1:get_side_from_player_unique_id(var_22_5:unique_id())

			if var_22_1:is_enemy_by_side(var_22_2, var_22_6) then
				return
			end
		end

		local var_22_7 = arg_22_0.world

		var_22_4.geiser_effect = World.create_particles(var_22_7, var_22_3, Vector3.zero())
		var_22_4.geiser_effect_variable = World.find_particles_variable(var_22_7, var_22_3, "charge_radius")
	end
end

WeaponSystem.rpc_end_geiser = function (arg_23_0, arg_23_1, arg_23_2)
	if not LEVEL_EDITOR_TEST then
		local var_23_0 = arg_23_0.world
		local var_23_1 = arg_23_0._geiser_particle_effects[arg_23_2]

		if var_23_1 and var_23_1.geiser_effect then
			World.destroy_particles(var_23_0, var_23_1.geiser_effect)
		end

		arg_23_0._geiser_particle_effects[arg_23_2] = nil

		if arg_23_0.is_server then
			local var_23_2 = CHANNEL_TO_PEER_ID[arg_23_1]

			arg_23_0.network_transmit:send_rpc_clients_except("rpc_end_geiser", var_23_2, arg_23_2)
		end
	end
end

WeaponSystem.rpc_start_flamethrower = function (arg_24_0, arg_24_1, arg_24_2, arg_24_3)
	if not LEVEL_EDITOR_TEST then
		local var_24_0 = arg_24_0.unit_storage:unit(arg_24_2)
		local var_24_1 = NetworkLookup.effects[arg_24_3]
		local var_24_2 = ScriptUnit.extension(var_24_0, "inventory_system"):equipment()
		local var_24_3 = var_24_2.right_hand_wielded_unit_3p or var_24_2.left_hand_wielded_unit_3p
		local var_24_4 = Unit.world_position(var_24_3, Unit.node(var_24_3, "fx_muzzle"))
		local var_24_5 = Unit.world_rotation(var_24_3, Unit.node(var_24_3, "fx_muzzle"))
		local var_24_6 = arg_24_0.world
		local var_24_7 = arg_24_0._flamethrower_particle_effects[var_24_0]

		if var_24_7 then
			World.stop_spawning_particles(var_24_6, var_24_7.flamethrower_effect)

			var_24_7.flamethrower_effect = World.create_particles(var_24_6, var_24_1, var_24_4, var_24_5)
			var_24_7.flamethrower_effect_name = var_24_1
			var_24_7.weapon_unit = var_24_3
		else
			arg_24_0._flamethrower_particle_effects[var_24_0] = {
				flamethrower_effect = World.create_particles(var_24_6, var_24_1, var_24_4, var_24_5),
				flamethrower_effect_name = var_24_1,
				weapon_unit = var_24_3
			}
		end

		if arg_24_0.is_server then
			local var_24_8 = CHANNEL_TO_PEER_ID[arg_24_1]

			arg_24_0.network_transmit:send_rpc_clients_except("rpc_start_flamethrower", var_24_8, arg_24_2, arg_24_3)
		end
	end
end

WeaponSystem.rpc_end_flamethrower = function (arg_25_0, arg_25_1, arg_25_2)
	if not LEVEL_EDITOR_TEST then
		local var_25_0 = arg_25_0.world
		local var_25_1 = arg_25_0.unit_storage:unit(arg_25_2)
		local var_25_2 = arg_25_0._flamethrower_particle_effects[var_25_1]

		if var_25_2 then
			World.stop_spawning_particles(var_25_0, var_25_2.flamethrower_effect)

			arg_25_0._flamethrower_particle_effects[var_25_1] = nil

			if arg_25_0.is_server then
				local var_25_3 = CHANNEL_TO_PEER_ID[arg_25_1]

				arg_25_0.network_transmit:send_rpc_clients_except("rpc_end_flamethrower", var_25_3, arg_25_2)
			end
		end
	end
end

WeaponSystem.rpc_summon_vortex = function (arg_26_0, arg_26_1, arg_26_2, arg_26_3)
	if not LEVEL_EDITOR_TEST then
		local var_26_0 = arg_26_0.unit_storage:unit(arg_26_2)
		local var_26_1 = arg_26_0.unit_storage:unit(arg_26_3)
		local var_26_2 = var_0_4[var_26_1]

		if var_26_2 then
			local var_26_3 = var_26_2.thornsister_vortex_ext

			if var_26_3 then
				var_26_3:refresh_duration()
			else
				local var_26_4 = POSITION_LOOKUP[var_26_1]

				if var_26_4 then
					arg_26_0:_summon_vortex(var_26_4, var_26_1, var_26_0)
				end
			end
		end
	end
end

WeaponSystem._summon_vortex = function (arg_27_0, arg_27_1, arg_27_2, arg_27_3)
	local var_27_0 = "units/weapons/enemy/wpn_chaos_plague_vortex/wpn_chaos_plague_vortex"
	local var_27_1 = "spirit_storm"
	local var_27_2 = Managers.state.side.side_by_unit[arg_27_3].side_id
	local var_27_3 = "vortex_unit"
	local var_27_4 = {
		area_damage_system = {
			vortex_template_name = var_27_1,
			owner_unit = arg_27_3,
			side_id = var_27_2,
			target_unit = arg_27_2
		}
	}

	Managers.state.unit_spawner:spawn_network_unit(var_27_0, var_27_3, var_27_4, arg_27_1, Quaternion.identity())
end

WeaponSystem.rpc_set_stormfiend_beam = function (arg_28_0, arg_28_1, arg_28_2, arg_28_3, arg_28_4)
	local var_28_0 = arg_28_0.unit_storage:unit(arg_28_2)

	if ALIVE[var_28_0] then
		local var_28_1 = ScriptUnit.extension(var_28_0, "ai_beam_effect_system")

		if var_28_1 then
			local var_28_2 = NetworkLookup.attack_arm[arg_28_3]

			var_28_1:set_beam(var_28_2, arg_28_4)
		end
	end
end

WeaponSystem.rpc_weapon_blood = function (arg_29_0, arg_29_1, arg_29_2, arg_29_3)
	local var_29_0 = arg_29_0.unit_storage:unit(arg_29_2)

	if not Unit.alive(var_29_0) then
		return
	end

	Managers.state.blood:add_weapon_blood(var_29_0, NetworkLookup.attack_templates[arg_29_3])

	if arg_29_0.is_server then
		local var_29_1 = CHANNEL_TO_PEER_ID[arg_29_1]

		arg_29_0.network_transmit:send_rpc_clients_except("rpc_weapon_blood", var_29_1, arg_29_2, arg_29_3)
	end
end

WeaponSystem.rpc_play_fx = function (arg_30_0, arg_30_1, arg_30_2, arg_30_3, arg_30_4)
	local var_30_0 = arg_30_0.world
	local var_30_1 = World.create_particles
	local var_30_2 = NetworkLookup.effects
	local var_30_3 = NetworkLookup.sound_events

	if #arg_30_3 > 0 then
		local var_30_4 = Managers.world:wwise_world(var_30_0)
		local var_30_5 = WwiseWorld.trigger_event
		local var_30_6 = WwiseWorld.make_auto_source
		local var_30_7 = Managers.state.entity:system("sound_environment_system")
		local var_30_8 = var_30_7.set_source_environment

		for iter_30_0 = 1, #arg_30_2 do
			local var_30_9 = var_30_2[arg_30_2[iter_30_0]]
			local var_30_10 = var_30_3[arg_30_3[iter_30_0]]
			local var_30_11 = arg_30_4[iter_30_0]

			var_30_1(var_30_0, var_30_9, var_30_11)

			local var_30_12 = var_30_6(var_30_4, var_30_11)

			var_30_5(var_30_4, var_30_10, var_30_12)
			var_30_8(var_30_7, var_30_12, var_30_11)
		end
	else
		for iter_30_1 = 1, #arg_30_2 do
			local var_30_13 = var_30_2[arg_30_2[iter_30_1]]

			var_30_1(var_30_0, var_30_13, arg_30_4[iter_30_1])
		end
	end
end

WeaponSystem.hot_join_sync = function (arg_31_0, arg_31_1)
	local var_31_0 = PEER_ID_TO_CHANNEL[arg_31_1]

	for iter_31_0, iter_31_1 in pairs(arg_31_0._beam_particle_effects) do
		local var_31_1 = Managers.state.network:unit_game_object_id(iter_31_0)
		local var_31_2 = NetworkLookup.effects[iter_31_1.beam_effect_name]
		local var_31_3 = NetworkLookup.effects[iter_31_1.beam_end_effect_name]

		RPC.rpc_start_beam(var_31_0, var_31_1, var_31_2, var_31_3, iter_31_1.range)
	end

	for iter_31_2, iter_31_3 in pairs(arg_31_0._geiser_particle_effects) do
		local var_31_4 = NetworkLookup.effects[iter_31_3.geiser_effect_name]
		local var_31_5 = iter_31_3.min_radius
		local var_31_6 = iter_31_3.max_radius
		local var_31_7 = iter_31_3.charge_time
		local var_31_8 = iter_31_3.angle
		local var_31_9 = iter_31_3.time_to_shoot - iter_31_3.start_time

		RPC.rpc_start_geiser(var_31_0, iter_31_2, var_31_4, var_31_5, var_31_6, var_31_7, var_31_8, var_31_9)
	end
end

WeaponSystem.start_soul_rip = function (arg_32_0, arg_32_1, arg_32_2, arg_32_3, arg_32_4, arg_32_5)
	local var_32_0 = arg_32_0.world

	if arg_32_0._soul_rip_particle_effects[arg_32_1] then
		arg_32_0:cleanup_soul_rip(arg_32_1)
	end

	local var_32_1 = Script.new_map(7)

	arg_32_0._soul_rip_particle_effects[arg_32_1] = var_32_1

	local var_32_2 = arg_32_0.unit_storage:go_id(arg_32_1)

	var_32_1.owner_unit_id = var_32_2
	var_32_1.target_unit = arg_32_2
	var_32_1.target_node_id = arg_32_3
	var_32_1.seed = arg_32_4

	local var_32_3 = arg_32_1
	local var_32_4 = false
	local var_32_5 = ScriptUnit.has_extension(arg_32_1, "first_person_system")

	if var_32_5 then
		var_32_3 = var_32_5:get_first_person_unit()

		local var_32_6 = "fx/wpnfx_necromancer_skullstaff_anticipation"
		local var_32_7 = Unit.has_node(var_32_3, "j_leftweaponattach") and Unit.node(var_32_3, "j_leftweaponattach") or 0

		var_32_1.anticipation_fx = ScriptWorld.create_particles_linked(var_32_0, var_32_6, var_32_3, var_32_7, "destroy")
		var_32_4 = var_32_5:first_person_mode_active()
	end

	local var_32_8 = var_32_4 and "units/test_unit/cup_test" or "units/test_unit/cup_test_3p"

	var_32_1.weapon_unit = var_32_3
	var_32_1.weapon_node_id = Unit.has_node(var_32_3, "j_leftweaponattach") and Unit.node(var_32_3, "j_leftweaponattach") or 0
	var_32_1.weapon_fx_unit = World.spawn_unit(var_32_0, var_32_8)
	var_32_1.target_node_id = Unit.has_node(arg_32_2, "j_spine") and Unit.node(arg_32_2, "j_spine") or 0
	var_32_1.target_fx_unit = World.spawn_unit(var_32_0, "units/test_unit/cup_test_3p")

	local var_32_9 = Vector3(2, 2, 2)

	Unit.set_local_scale(var_32_1.weapon_fx_unit, 0, var_32_9)

	local var_32_10 = Vector3(5, 5, 5)

	Unit.set_local_scale(var_32_1.target_fx_unit, 0, var_32_10)

	if arg_32_5 then
		local var_32_11 = arg_32_0.unit_storage:go_id(arg_32_2)

		if arg_32_0.is_server then
			arg_32_0.network_transmit:send_rpc_clients("rpc_start_soul_rip", var_32_2, var_32_11, arg_32_3, arg_32_4)
		else
			arg_32_0.network_transmit:send_rpc_server("rpc_start_soul_rip", var_32_2, var_32_11, arg_32_3, arg_32_4)
		end
	end
end

WeaponSystem.update_synced_soul_rip_particle_effects = function (arg_33_0)
	for iter_33_0, iter_33_1 in pairs(arg_33_0._soul_rip_particle_effects) do
		if not ALIVE[iter_33_0] or not ALIVE[iter_33_1.target_unit] then
			arg_33_0:cleanup_soul_rip(iter_33_0)
		else
			local var_33_0, var_33_1 = Unit.world_position(iter_33_1.target_unit, iter_33_1.target_node_id), Unit.world_position(iter_33_1.weapon_unit, iter_33_1.weapon_node_id)
			local var_33_2 = Vector3.normalize(var_33_0 - var_33_1)
			local var_33_3 = iter_33_1.weapon_fx_unit
			local var_33_4 = Unit.world_position(iter_33_1.weapon_unit, iter_33_1.weapon_node_id)

			Unit.set_local_position(var_33_3, 0, var_33_4)

			local var_33_5 = Quaternion.look(var_33_2)

			Unit.set_local_rotation(var_33_3, 0, var_33_5)

			local var_33_6 = iter_33_1.target_fx_unit
			local var_33_7 = Unit.world_position(iter_33_1.target_unit, iter_33_1.target_node_id)

			Unit.set_local_position(var_33_6, 0, var_33_7)

			local var_33_8 = Quaternion.look(-var_33_2)

			Unit.set_local_rotation(var_33_6, 0, var_33_8)
		end
	end
end

WeaponSystem.stop_soul_rip = function (arg_34_0, arg_34_1, arg_34_2)
	local var_34_0 = arg_34_0._soul_rip_particle_effects[arg_34_1]

	if var_34_0 then
		arg_34_0:cleanup_soul_rip(arg_34_1)

		if arg_34_2 then
			if arg_34_0.is_server then
				arg_34_0.network_transmit:send_rpc_clients("rpc_stop_soul_rip", var_34_0.owner_unit_id)
			else
				arg_34_0.network_transmit:send_rpc_server("rpc_stop_soul_rip", var_34_0.owner_unit_id)
			end
		end
	end
end

WeaponSystem.cleanup_soul_rip = function (arg_35_0, arg_35_1)
	local var_35_0 = arg_35_0._soul_rip_particle_effects[arg_35_1]

	if var_35_0 then
		local var_35_1 = arg_35_0.world

		if var_35_0.anticipation_fx then
			World.destroy_particles(var_35_1, var_35_0.anticipation_fx)
		end

		World.destroy_unit(var_35_1, var_35_0.weapon_fx_unit)
		World.destroy_unit(var_35_1, var_35_0.target_fx_unit)

		arg_35_0._soul_rip_particle_effects[arg_35_1] = nil
	end
end

WeaponSystem.soul_rip_burst = function (arg_36_0, arg_36_1, arg_36_2, arg_36_3, arg_36_4, arg_36_5, arg_36_6)
	local var_36_0 = arg_36_0.world
	local var_36_1 = arg_36_0.unit_storage:go_id(arg_36_1)
	local var_36_2 = Unit.world_position(arg_36_2, arg_36_3)
	local var_36_3 = GameSession.game_object_field(arg_36_0.game, var_36_1, "aim_position")
	local var_36_4 = Vector3.normalize(var_36_3 - var_36_2)
	local var_36_5 = Quaternion.look(var_36_4)
	local var_36_6 = Quaternion.right(var_36_5)
	local var_36_7 = Quaternion.forward(var_36_5)
	local var_36_8 = Vector3.up()
	local var_36_9 = World.create_particles(var_36_0, arg_36_4, var_36_2, Quaternion.look(var_36_8 * 0.5 + var_36_6 * 0.5))
	local var_36_10 = arg_36_0._soul_rip_spline_ids_lookup

	if not var_36_10[arg_36_4] then
		var_36_10[arg_36_4] = {
			World.find_particles_variable(var_36_0, arg_36_4, "spline_1"),
			World.find_particles_variable(var_36_0, arg_36_4, "spline_2"),
			World.find_particles_variable(var_36_0, arg_36_4, "spline_3"),
			World.find_particles_variable(var_36_0, arg_36_4, "spline_4")
		}
	end

	local var_36_11 = var_36_2
	local var_36_12 = var_36_11 + var_36_8 + var_36_6 * 2
	local var_36_13
	local var_36_14
	local var_36_15
	local var_36_16, var_36_17 = Math.next_random(arg_36_5)
	local var_36_18, var_36_19 = Math.next_random(var_36_16)
	local var_36_20 = var_36_11 + var_36_7 + Vector3(var_36_17 * 2 - 1, var_36_19 * 2 - 1, 2) + var_36_6 * 0.5
	local var_36_21, var_36_22 = Math.next_random(var_36_18)
	local var_36_23, var_36_24 = Math.next_random(var_36_21)
	local var_36_25 = var_36_11 + Vector3(var_36_22 * 2 - 1, var_36_24 * 2 - 1, 5) + var_36_6 * 0.5
	local var_36_26 = var_36_10[arg_36_4]

	World.set_particles_variable(var_36_0, var_36_9, var_36_26[1], var_36_11)
	World.set_particles_variable(var_36_0, var_36_9, var_36_26[2], var_36_12)
	World.set_particles_variable(var_36_0, var_36_9, var_36_26[3], var_36_20)
	World.set_particles_variable(var_36_0, var_36_9, var_36_26[4], var_36_25)

	if script_data.debug_soulrip then
		QuickDrawerStay:line(var_36_11, var_36_12, Color(255, 0, 0))
		QuickDrawerStay:line(var_36_12, var_36_20, Color(255, 0, 0))
		QuickDrawerStay:line(var_36_20, var_36_25, Color(255, 0, 0))
	end

	if arg_36_6 then
		local var_36_27 = arg_36_0.unit_storage:go_id(arg_36_2)
		local var_36_28 = NetworkLookup.effects[arg_36_4]

		if arg_36_0.is_server then
			arg_36_0.network_transmit:send_rpc_clients("rpc_soul_rip_burst", var_36_1, var_36_27, arg_36_3, var_36_28, arg_36_5)
		else
			arg_36_0.network_transmit:send_rpc_server("rpc_soul_rip_burst", var_36_1, var_36_27, arg_36_3, var_36_28, arg_36_5)
		end
	end
end

WeaponSystem.rpc_start_soul_rip = function (arg_37_0, arg_37_1, arg_37_2, arg_37_3, arg_37_4, arg_37_5)
	local var_37_0 = arg_37_0.unit_storage:unit(arg_37_2)
	local var_37_1 = arg_37_0.unit_storage:unit(arg_37_3)

	if not var_37_1 then
		return
	end

	arg_37_0:start_soul_rip(var_37_0, var_37_1, arg_37_4, arg_37_5, false)

	if arg_37_0.is_server then
		local var_37_2 = CHANNEL_TO_PEER_ID[arg_37_1]

		arg_37_0.network_transmit:send_rpc_clients_except("rpc_start_soul_rip", var_37_2, arg_37_2, arg_37_3, arg_37_4, arg_37_5)
	end
end

WeaponSystem.rpc_stop_soul_rip = function (arg_38_0, arg_38_1, arg_38_2)
	local var_38_0 = arg_38_0.unit_storage:unit(arg_38_2)

	arg_38_0:stop_soul_rip(var_38_0, false)

	if arg_38_0.is_server then
		local var_38_1 = CHANNEL_TO_PEER_ID[arg_38_1]

		arg_38_0.network_transmit:send_rpc_clients_except("rpc_stop_soul_rip", var_38_1, arg_38_2)
	end
end

WeaponSystem.rpc_soul_rip_burst = function (arg_39_0, arg_39_1, arg_39_2, arg_39_3, arg_39_4, arg_39_5, arg_39_6)
	local var_39_0 = arg_39_0.unit_storage:unit(arg_39_3)
	local var_39_1 = arg_39_0.unit_storage:unit(arg_39_2)

	if not ALIVE[var_39_0] or not ALIVE[var_39_1] then
		return
	end

	local var_39_2 = NetworkLookup.effects[arg_39_5]

	arg_39_0:soul_rip_burst(var_39_1, var_39_0, arg_39_4, var_39_2, arg_39_6, false)

	if arg_39_0.is_server then
		local var_39_3 = CHANNEL_TO_PEER_ID[arg_39_1]

		arg_39_0.network_transmit:send_rpc_clients_except("rpc_soul_rip_burst", var_39_3, arg_39_2, arg_39_3, arg_39_4, arg_39_5, arg_39_6)
	end
end

WeaponSystem._update_chained_projectiles = function (arg_40_0, arg_40_1)
	local var_40_0 = arg_40_0._chained_projectiles
	local var_40_1 = Managers.state.entity:system("ai_system").broadphase

	for iter_40_0 in pairs(var_40_0) do
		if not iter_40_0.next_target_unit and arg_40_1 >= iter_40_0.target_selection_t then
			if not arg_40_0:_select_next_chained_projectile_target(iter_40_0, var_40_1) then
				arg_40_0._chained_projectiles[iter_40_0] = nil
			end
		elseif arg_40_1 >= iter_40_0.next_chain_t then
			if arg_40_0:_apply_chained_projectile_damage(iter_40_0) then
				iter_40_0.next_target_unit = nil
				iter_40_0.next_chain_t = arg_40_1 + iter_40_0.settings.chain_delay
				iter_40_0.target_selection_t = arg_40_1 + iter_40_0.settings.target_selection_delay
			else
				arg_40_0._chained_projectiles[iter_40_0] = nil
			end
		end
	end
end

WeaponSystem.is_chained_projectile_active = function (arg_41_0, arg_41_1)
	return not not arg_41_0._chained_projectiles[arg_41_1]
end

local var_0_8 = {}

WeaponSystem._select_next_chained_projectile_target = function (arg_42_0, arg_42_1, arg_42_2)
	local var_42_0 = arg_42_1.settings
	local var_42_1 = arg_42_1.hit_units
	local var_42_2 = arg_42_1.last_chain_pos:unbox()
	local var_42_3 = var_0_8
	local var_42_4 = arg_42_0.world
	local var_42_5 = {
		World.find_particles_variable(var_42_4, "fx/wpnfx_staff_death/curse_spirit", "spline_1"),
		World.find_particles_variable(var_42_4, "fx/wpnfx_staff_death/curse_spirit", "spline_2"),
		World.find_particles_variable(var_42_4, "fx/wpnfx_staff_death/curse_spirit", "spline_3")
	}
	local var_42_6 = Managers.state.side.side_by_unit[arg_42_1.owner_unit]
	local var_42_7 = var_42_6 and var_42_6.enemy_broadphase_categories
	local var_42_8 = Broadphase.query(arg_42_2, var_42_2, var_42_0.chain_distance, var_42_3, var_42_7)

	for iter_42_0 = 1, var_42_8 do
		local var_42_9 = var_42_3[iter_42_0]

		if not var_42_1[var_42_9] and HEALTH_ALIVE[var_42_9] then
			var_42_1[var_42_9] = true

			local var_42_10 = Unit.has_node(var_42_9, "j_spine") and Unit.node(var_42_9, "j_spine") or 0
			local var_42_11 = Unit.world_position(var_42_9, var_42_10)
			local var_42_12 = Vector3(math.lerp(-0.5, 0.5, math.random()), math.lerp(-0.5, 0.5, math.random()), math.lerp(-0.5, 0.5, math.random()))
			local var_42_13 = var_42_2 + (var_42_11 - var_42_2) / 2 + var_42_12

			arg_42_0:_play_chained_projectile_fx("fx/wpnfx_staff_death/curse_spirit", var_42_5, var_42_2, var_42_13, var_42_11, true)

			arg_42_1.next_target_unit = var_42_9

			return true
		end
	end

	return false
end

WeaponSystem._play_chained_projectile_fx = function (arg_43_0, arg_43_1, arg_43_2, arg_43_3, arg_43_4, arg_43_5)
	local var_43_0 = NetworkLookup.effects[arg_43_1]
	local var_43_1 = {
		arg_43_3,
		arg_43_4,
		arg_43_5
	}

	if arg_43_0._fire_sound_event and arg_43_0.first_person_extension then
		arg_43_0.first_person_extension:play_hud_sound_event(arg_43_0._fire_sound_event)
	end

	if arg_43_0.is_server then
		Managers.state.network:rpc_play_particle_effect_spline(nil, var_43_0, arg_43_2, var_43_1)
	else
		Managers.state.network.network_transmit:send_rpc_server("rpc_play_particle_effect_spline", var_43_0, arg_43_2, var_43_1)
	end
end

WeaponSystem.try_fire_chained_projectile = function (arg_44_0, arg_44_1, arg_44_2, arg_44_3, arg_44_4, arg_44_5, arg_44_6, arg_44_7, arg_44_8, arg_44_9, arg_44_10, arg_44_11)
	local var_44_0 = {
		chain_count = 0,
		settings = arg_44_1,
		is_critical_strike = arg_44_3,
		power_level = arg_44_4,
		boost_curve_multiplier = arg_44_5,
		damage_source = arg_44_2,
		next_chain_t = arg_44_6 + (arg_44_1.chain_delay - arg_44_1.target_selection_delay),
		target_selection_t = math.huge,
		owner_unit = arg_44_7,
		hit_units = {},
		last_chain_pos = Vector3Box(arg_44_8),
		base_target_index = arg_44_11
	}

	if arg_44_10 then
		var_44_0.hit_units[arg_44_10] = true
	end

	if not arg_44_9 then
		local var_44_1 = Managers.state.entity:system("ai_system").broadphase

		arg_44_9 = arg_44_0:_select_next_chained_projectile_target(var_44_0, var_44_1)

		if not arg_44_9 then
			return
		end
	end

	var_44_0.hit_units[arg_44_9] = true
	arg_44_0._chained_projectiles[var_44_0] = true

	Managers.state.achievement:trigger_event("chained_projectile_fired", var_44_0, arg_44_7)
end

WeaponSystem._apply_chained_projectile_damage = function (arg_45_0, arg_45_1)
	local var_45_0 = arg_45_1.settings
	local var_45_1 = arg_45_1.chain_count + 1
	local var_45_2 = arg_45_1.next_target_unit
	local var_45_3 = arg_45_1.base_target_index + var_45_1

	if HEALTH_ALIVE[var_45_2] then
		local var_45_4 = arg_45_1.last_chain_pos:unbox()
		local var_45_5 = arg_45_1.is_critical_strike
		local var_45_6 = arg_45_1.power_level
		local var_45_7 = arg_45_1.boost_curve_multiplier
		local var_45_8 = var_45_0.damage_profile
		local var_45_9 = Managers.state.network
		local var_45_10 = var_45_9:unit_game_object_id(arg_45_1.owner_unit)

		if not var_45_10 then
			return
		end

		local var_45_11 = NetworkLookup.damage_profiles[var_45_8]
		local var_45_12, var_45_13 = var_45_9:game_object_or_level_id(var_45_2)
		local var_45_14 = NetworkLookup.damage_sources[arg_45_1.damage_source]
		local var_45_15 = NetworkLookup.hit_zones.torso
		local var_45_16 = Unit.world_position(var_45_2, 0) + Vector3.up()
		local var_45_17, var_45_18 = Vector3.direction_length(var_45_16 - var_45_4)

		if var_45_13 then
			local var_45_19 = "full"
			local var_45_20 = 1
			local var_45_21 = arg_45_0.item_name
			local var_45_22 = DamageProfileTemplates[var_45_8]

			DamageUtils.damage_level_unit(var_45_2, arg_45_1.owner_unit, var_45_19, var_45_6, arg_45_0.melee_boost_curve_multiplier, var_45_5, var_45_22, var_45_20, var_45_17, var_45_21)
		else
			arg_45_0:send_rpc_attack_hit(var_45_14, var_45_10, var_45_12, var_45_15, var_45_16, var_45_17, var_45_11, "power_level", var_45_6, "hit_target_index", var_45_3, "blocking", false, "shield_break_procced", false, "boost_curve_multiplier", var_45_7, "is_critical_strike", var_45_5, "can_damage", true, "can_stagger", true, "first_hit", var_45_3 == 1)
		end

		local var_45_23 = NetworkLookup.effects["fx/wpnfx_staff_death/curse_spirit_impact"]
		local var_45_24 = Quaternion.look(var_45_17)

		if arg_45_0.is_server then
			Managers.state.network:rpc_play_particle_effect(nil, var_45_23, NetworkConstants.invalid_game_object_id, 0, var_45_16, var_45_24, false)
		else
			Managers.state.network.network_transmit:send_rpc_server("rpc_play_particle_effect", var_45_23, NetworkConstants.invalid_game_object_id, 0, var_45_16, var_45_24, false)
		end

		Managers.state.entity:system("audio_system"):play_audio_unit_event("Play_career_necro_passive_shadow_blood", var_45_2)
	end

	if ALIVE[var_45_2] and var_45_1 < var_45_0.max_chain_count then
		local var_45_25

		if Unit.has_node(var_45_2, "j_spine") then
			local var_45_26 = Unit.node(var_45_2, "j_spine")

			var_45_25 = Unit.world_position(var_45_2, var_45_26)
		else
			var_45_25 = Unit.world_position(var_45_2, 0) + Vector3.up() * 0.8
		end

		arg_45_1.chain_count = var_45_1

		arg_45_1.last_chain_pos:store(var_45_25)

		return true
	else
		return false
	end
end
