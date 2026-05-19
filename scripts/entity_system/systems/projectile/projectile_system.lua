-- chunkname: @scripts/entity_system/systems/projectile/projectile_system.lua

require("scripts/unit_extensions/weapons/projectiles/projectile_templates")
require("scripts/unit_extensions/weapons/projectiles/generic_impact_projectile_unit_extension")
require("scripts/unit_extensions/weapons/projectiles/player_projectile_unit_extension")
require("scripts/unit_extensions/weapons/projectiles/player_projectile_husk_extension")
require("scripts/unit_extensions/weapons/projectiles/projectile_true_flight_locomotion_extension")
require("scripts/unit_extensions/weapons/projectiles/projectile_homing_skull_locomotion_extension")
require("scripts/unit_extensions/weapons/projectiles/projectile_extrapolated_husk_locomotion_extension")
require("scripts/unit_extensions/weapons/projectiles/projectile_ethereal_skull_locomotion_extension")
require("scripts/settings/light_weight_projectile_effects")
require("scripts/entity_system/systems/projectile/drone_templates")

ProjectileSystem = class(ProjectileSystem, ExtensionSystemBase)

local var_0_0 = ProjectileUnits
local var_0_1 = {
	"rpc_spawn_pickup_projectile",
	"rpc_spawn_pickup_projectile_limited",
	"rpc_spawn_explosive_pickup_projectile",
	"rpc_spawn_explosive_pickup_projectile_limited",
	"rpc_projectile_stopped",
	"rpc_drop_projectile",
	"rpc_generic_impact_projectile_impact",
	"rpc_generic_impact_projectile_force_impact",
	"rpc_player_projectile_impact_level",
	"rpc_player_projectile_impact_dynamic",
	"rpc_client_spawn_light_weight_projectile",
	"rpc_client_despawn_light_weight_projectile",
	"rpc_client_create_aoe",
	"rpc_spawn_globadier_globe",
	"rpc_spawn_globadier_globe_fixed_impact",
	"rpc_clients_continuous_shoot_start",
	"rpc_clients_continuous_shoot_stop",
	"rpc_projectile_event",
	"rpc_request_spawn_drones",
	"rpc_spawn_drones"
}
local var_0_2 = {
	"GenericImpactProjectileUnitExtension",
	"PlayerProjectileUnitExtension",
	"PlayerProjectileHuskExtension"
}
local var_0_3 = 10
local var_0_4 = math.pi * 2

function ProjectileSystem.init(arg_1_0, arg_1_1, arg_1_2)
	ProjectileSystem.super.init(arg_1_0, arg_1_1, arg_1_2, var_0_2)

	local var_1_0 = arg_1_1.network_event_delegate

	arg_1_0.network_event_delegate = var_1_0

	var_1_0:register(arg_1_0, unpack(var_0_1))

	arg_1_0.network_manager = arg_1_1.network_manager
	arg_1_0.player_projectile_units = {}
	arg_1_0.indexed_player_projectile_units = {}
	arg_1_0.owner_units_count = 0
	arg_1_0._current_id = 1

	function arg_1_0.projectile_owner_destroy_callback(arg_2_0)
		for iter_2_0, iter_2_1 in pairs(arg_1_0.player_projectile_units) do
			if iter_2_0 == arg_2_0 then
				for iter_2_2, iter_2_3 in pairs(iter_2_1) do
					arg_1_0:_remove_player_projectile_reference(iter_2_2, iter_2_0)

					if Unit.alive(iter_2_2) then
						Managers.state.unit_spawner:mark_for_deletion(iter_2_2)
					end
				end
			end
		end

		arg_1_0.player_projectile_units[arg_2_0] = nil
		arg_1_0.owner_units_count = arg_1_0.owner_units_count - 1
	end

	local var_1_1 = NetworkConstants.light_weight_projectile_index.max

	arg_1_0._light_weight = {
		husk_list = {},
		own_data = {
			is_owner = true,
			current_index = 0,
			projectiles = Script.new_array(var_1_1),
			max_index = var_1_1,
			owner_peer_id = Network.peer_id()
		},
		husk_shoot_list = {}
	}
	arg_1_0._wwise_world = Managers.world:wwise_world(arg_1_0.world)
	arg_1_0._projectile_linker_system = Managers.state.entity:system("projectile_linker_system")

	local var_1_2 = Network.type_info("rnd_seed")

	arg_1_0._drone_seed_per_source = {
		min_seed = var_1_2.min,
		max_seed = var_1_2.max
	}
end

function ProjectileSystem.on_add_extension(arg_3_0, arg_3_1, arg_3_2, arg_3_3, ...)
	if arg_3_0.is_server then
		Managers.level_transition_handler.transient_package_loader:add_projectile(arg_3_2)
	end

	return ExtensionSystemBase.on_add_extension(arg_3_0, arg_3_1, arg_3_2, arg_3_3, ...)
end

function ProjectileSystem.on_remove_extension(arg_4_0, arg_4_1, arg_4_2)
	ExtensionSystemBase.on_remove_extension(arg_4_0, arg_4_1, arg_4_2)

	if arg_4_0.is_server then
		Managers.level_transition_handler.transient_package_loader:remove_projectile(arg_4_1)
	end
end

local var_0_5 = {}
local var_0_6 = {}

function ProjectileSystem.update(arg_5_0, arg_5_1, arg_5_2)
	ProjectileSystem.super.update(arg_5_0, arg_5_1, arg_5_2)

	local var_5_0 = arg_5_0.player_projectile_units

	for iter_5_0, iter_5_1 in pairs(var_5_0) do
		for iter_5_2, iter_5_3 in pairs(iter_5_1) do
			local var_5_1 = Unit.alive(iter_5_2)

			if iter_5_3 <= arg_5_2 or not var_5_1 then
				var_0_5[iter_5_2] = var_5_1
				var_0_6[iter_5_2] = iter_5_0
			end
		end
	end

	for iter_5_4, iter_5_5 in pairs(var_0_5) do
		local var_5_2 = var_0_6[iter_5_4]

		arg_5_0:_remove_player_projectile_reference(iter_5_4, var_5_2)

		if iter_5_5 then
			Managers.state.unit_spawner:mark_for_deletion(iter_5_4)
		end
	end

	table.clear(var_0_5)
	table.clear(var_0_6)
	arg_5_0:_update_shooting(arg_5_1.dt, arg_5_2, arg_5_0._light_weight.husk_shoot_list)
	arg_5_0:_update_light_weight_projectiles(arg_5_1.dt, arg_5_2, arg_5_0._light_weight)
	arg_5_0:_update_drones(arg_5_1.dt, arg_5_2)
end

function ProjectileSystem.destroy(arg_6_0)
	arg_6_0.network_event_delegate:unregister(arg_6_0)
end

function ProjectileSystem._get_projectile_units_names(arg_7_0, arg_7_1, arg_7_2)
	local var_7_0 = arg_7_1.projectile_units_template

	if arg_7_1.use_weapon_skin then
		local var_7_1 = ScriptUnit.has_extension(arg_7_2, "inventory_system")

		if var_7_1 then
			local var_7_2 = "slot_ranged"
			local var_7_3 = var_7_1:get_slot_data(var_7_2)

			var_7_0 = var_7_3 and var_7_3.projectile_units_template or var_7_0
		end
	end

	return var_0_0[var_7_0]
end

function ProjectileSystem.spawn_player_projectile(arg_8_0, arg_8_1, arg_8_2, arg_8_3, arg_8_4, arg_8_5, arg_8_6, arg_8_7, arg_8_8, arg_8_9, arg_8_10, arg_8_11, arg_8_12, arg_8_13, arg_8_14, arg_8_15, arg_8_16)
	local var_8_0 = WeaponUtils.get_weapon_template(arg_8_9).actions[arg_8_10][arg_8_11]
	local var_8_1 = var_8_0.projectile_info
	local var_8_2 = var_8_1.gravity_settings

	var_8_2 = arg_8_15 and var_8_1.gaze_override_gravity_settings or var_8_2

	local var_8_3 = var_8_1.trajectory_template_name
	local var_8_4 = var_8_1.linear_dampening
	local var_8_5 = var_8_1.rotation_speed or 0
	local var_8_6 = var_8_1.rotation_offset

	arg_8_4 = arg_8_4 / 100

	local var_8_7 = var_8_1.radius_min
	local var_8_8 = var_8_1.radius_max
	local var_8_9 = var_8_1.radius or var_8_7 and var_8_8 and math.lerp(var_8_1.radius_min, var_8_1.radius_max, arg_8_4) or nil
	local var_8_10 = var_8_0.generate_seed and var_8_0.generate_seed() or nil
	local var_8_11 = Managers.time:time("game")
	local var_8_12 = {
		projectile_locomotion_system = {
			angle = arg_8_5,
			speed = arg_8_7,
			seed = var_8_10,
			initial_position = arg_8_2,
			target_vector = arg_8_6,
			gravity_settings = var_8_2,
			linear_dampening = var_8_4,
			trajectory_template_name = var_8_3,
			data = {
				arg_8_1,
				arg_8_2,
				arg_8_3,
				arg_8_4,
				arg_8_5,
				arg_8_6,
				arg_8_7,
				arg_8_8,
				arg_8_9,
				arg_8_10,
				arg_8_11
			},
			fast_forward_time = arg_8_12,
			rotation_speed = var_8_5,
			rotation_offset = var_8_6
		},
		projectile_impact_system = {
			item_name = arg_8_8,
			item_template_name = arg_8_9,
			action_name = arg_8_10,
			sub_action_name = arg_8_11,
			owner_unit = arg_8_1,
			radius = var_8_9
		},
		projectile_system = {
			item_name = arg_8_8,
			item_template_name = arg_8_9,
			action_name = arg_8_10,
			sub_action_name = arg_8_11,
			owner_unit = arg_8_1,
			time_initialized = var_8_11,
			scale = arg_8_4,
			fast_forward_time = arg_8_12,
			is_critical_strike = arg_8_13,
			power_level = arg_8_14,
			charge_level = arg_8_16
		}
	}
	local var_8_13 = arg_8_0:_get_projectile_units_names(var_8_1, arg_8_1).projectile_unit_name
	local var_8_14 = Managers.state.unit_spawner:spawn_network_unit(var_8_13, var_8_1.projectile_unit_template_name or "player_projectile_unit", var_8_12, arg_8_2, arg_8_3)

	arg_8_0:_add_player_projectile_reference(arg_8_1, var_8_14, var_8_1)
	Managers.state.achievement:trigger_event("on_player_projectile_spawned", var_8_14, arg_8_1, arg_8_9)
end

function ProjectileSystem.spawn_globadier_globe(arg_9_0, arg_9_1, arg_9_2, arg_9_3, arg_9_4, arg_9_5, arg_9_6, arg_9_7, arg_9_8, arg_9_9, arg_9_10, arg_9_11, arg_9_12, arg_9_13, arg_9_14, arg_9_15)
	if arg_9_0.is_server then
		local var_9_0 = arg_9_13 and "bot_poison_wind" or nil
		local var_9_1 = Managers.mechanism:current_mechanism_name() == "versus"

		if arg_9_14 then
			local var_9_2 = {
				area_damage_system = {
					invisible_unit = true,
					player_screen_effect_name = "fx/screenspace_poison_globe_impact",
					area_ai_random_death_template = "area_poison_ai_random_death",
					dot_effect_name = "fx/wpnfx_poison_wind_globe_impact",
					extra_dot_effect_name = "fx/chr_gutter_death",
					damage_players = true,
					aoe_dot_damage = arg_9_10,
					aoe_init_damage = arg_9_11,
					aoe_dot_damage_interval = arg_9_12,
					radius = arg_9_6,
					initial_radius = arg_9_5,
					life_time = arg_9_7,
					area_damage_template = var_9_1 and "globadier_area_dot_damage_vs" or "globadier_area_dot_damage",
					damage_source = arg_9_9,
					create_nav_tag_volume = arg_9_13,
					nav_tag_volume_layer = var_9_0,
					source_attacker_unit = arg_9_8,
					threat_duration = arg_9_7
				}
			}
			local var_9_3 = "units/weapons/projectile/poison_wind_globe/poison_wind_globe"
			local var_9_4 = Managers.state.unit_spawner:spawn_network_unit(var_9_3, "aoe_unit", var_9_2, arg_9_1)
			local var_9_5 = Managers.state.unit_storage:go_id(var_9_4)

			Unit.set_unit_visibility(var_9_4, false)
			Managers.state.network.network_transmit:send_rpc_all("rpc_area_damage", var_9_5, arg_9_1)
		else
			local var_9_6 = {
				projectile_locomotion_system = {
					trajectory_template_name = "throw_trajectory",
					angle = arg_9_3,
					speed = arg_9_4,
					target_vector = arg_9_2,
					initial_position = arg_9_1
				},
				projectile_system = {
					damage_source = arg_9_9,
					impact_template_name = var_9_1 and "vs_globadier_impact" or "explosion_impact",
					owner_unit = arg_9_8
				},
				area_damage_system = {
					invisible_unit = false,
					player_screen_effect_name = "fx/screenspace_poison_globe_impact",
					area_ai_random_death_template = "area_poison_ai_random_death",
					damage_players = true,
					aoe_dot_damage = arg_9_10,
					aoe_init_damage = arg_9_11,
					aoe_dot_damage_interval = arg_9_12,
					radius = arg_9_6,
					initial_radius = arg_9_5,
					life_time = arg_9_7,
					dot_effect_name = var_9_1 and "fx/wpnfx_poison_wind_globe_impact_vs" or "fx/wpnfx_poison_wind_globe_impact",
					area_damage_template = var_9_1 and "globadier_area_dot_damage_vs" or "globadier_area_dot_damage",
					damage_source = arg_9_9,
					create_nav_tag_volume = arg_9_13,
					nav_tag_volume_layer = var_9_0,
					source_attacker_unit = arg_9_8,
					owner_player = Managers.player:owner(arg_9_8),
					threat_duration = arg_9_7
				}
			}
			local var_9_7
			local var_9_8

			if arg_9_15 then
				var_9_6.projectile_impact_system = {
					owner_unit = arg_9_8,
					impact_data = arg_9_15
				}
				var_9_8 = "aoe_projectile_unit_fixed_impact"
			else
				var_9_6.projectile_impact_system = {
					server_side_raycast = true,
					collision_filter = "filter_enemy_ray_projectile",
					owner_unit = arg_9_8
				}
				var_9_8 = "aoe_projectile_unit"
			end

			local var_9_9 = "units/weapons/projectile/poison_wind_globe/poison_wind_globe"

			Managers.state.unit_spawner:spawn_network_unit(var_9_9, var_9_8, var_9_6, arg_9_1)
		end
	else
		local var_9_10 = arg_9_0.unit_storage:go_id(arg_9_8)
		local var_9_11 = NetworkLookup.damage_sources[arg_9_9]
		local var_9_12
		local var_9_13

		if arg_9_15 then
			local var_9_14 = arg_9_15.hit_unit

			var_9_13 = arg_9_0.network_manager:level_object_id(var_9_14)
			var_9_12 = var_9_13 ~= nil
		end

		if var_9_12 then
			print("fixed impact!")

			local var_9_15 = arg_9_15.position:unbox()
			local var_9_16 = arg_9_15.direction:unbox()
			local var_9_17 = arg_9_15.hit_normal:unbox()
			local var_9_18 = arg_9_15.actor_index
			local var_9_19 = arg_9_15.time

			arg_9_0.network_transmit:send_rpc_server("rpc_spawn_globadier_globe_fixed_impact", arg_9_1, arg_9_2, arg_9_3, arg_9_4, arg_9_5, arg_9_6, arg_9_7, var_9_10, var_9_11, arg_9_10, arg_9_11, arg_9_12, arg_9_13, arg_9_14, var_9_13, var_9_15, var_9_16, var_9_17, var_9_18, var_9_19)
		else
			print("Standard impact!")
			arg_9_0.network_transmit:send_rpc_server("rpc_spawn_globadier_globe", arg_9_1, arg_9_2, arg_9_3, arg_9_4, arg_9_5, arg_9_6, arg_9_7, var_9_10, var_9_11, arg_9_10, arg_9_11, arg_9_12, arg_9_13, arg_9_14)
		end
	end
end

function ProjectileSystem.rpc_spawn_globadier_globe(arg_10_0, arg_10_1, arg_10_2, arg_10_3, arg_10_4, arg_10_5, arg_10_6, arg_10_7, arg_10_8, arg_10_9, arg_10_10, arg_10_11, arg_10_12, arg_10_13, arg_10_14, arg_10_15)
	fassert(arg_10_0.is_server, "Have to be server")

	local var_10_0 = arg_10_0.unit_storage:unit(arg_10_9)
	local var_10_1 = NetworkLookup.damage_sources[arg_10_10]

	arg_10_0:spawn_globadier_globe(arg_10_2, arg_10_3, arg_10_4, arg_10_5, arg_10_6, arg_10_7, arg_10_8, var_10_0, var_10_1, arg_10_11, arg_10_12, arg_10_13, arg_10_14, arg_10_15)
end

function ProjectileSystem.rpc_spawn_globadier_globe_fixed_impact(arg_11_0, arg_11_1, arg_11_2, arg_11_3, arg_11_4, arg_11_5, arg_11_6, arg_11_7, arg_11_8, arg_11_9, arg_11_10, arg_11_11, arg_11_12, arg_11_13, arg_11_14, arg_11_15, arg_11_16, arg_11_17, arg_11_18, arg_11_19, arg_11_20, arg_11_21)
	fassert(arg_11_0.is_server, "Have to be server")

	local var_11_0 = Managers.state.network:game_object_or_level_unit(arg_11_16, true)

	if not Unit.alive(var_11_0) then
		arg_11_0:rpc_spawn_globadier_globe(arg_11_1, arg_11_2, arg_11_3, arg_11_4, arg_11_5, arg_11_6, arg_11_7, arg_11_8, arg_11_9, arg_11_10, arg_11_11, arg_11_12, arg_11_13, arg_11_14, arg_11_15)

		return
	end

	local var_11_1 = arg_11_0.unit_storage:unit(arg_11_9)
	local var_11_2 = NetworkLookup.damage_sources[arg_11_10]
	local var_11_3 = {
		position = Vector3Box(arg_11_17),
		direction = Vector3Box(arg_11_18),
		hit_unit = var_11_0,
		actor_index = arg_11_20,
		hit_normal = Vector3Box(arg_11_19),
		time = arg_11_21
	}

	arg_11_0:spawn_globadier_globe(arg_11_2, arg_11_3, arg_11_4, arg_11_5, arg_11_6, arg_11_7, arg_11_8, var_11_1, var_11_2, arg_11_11, arg_11_12, arg_11_13, arg_11_14, arg_11_15, var_11_3)
end

function ProjectileSystem.rpc_projectile_stopped(arg_12_0, arg_12_1, arg_12_2)
	local var_12_0 = arg_12_0.unit_storage:unit(arg_12_2)

	ScriptUnit.extension(var_12_0, "projectile_locomotion_system"):stop()
end

function ProjectileSystem.rpc_drop_projectile(arg_13_0, arg_13_1, arg_13_2)
	local var_13_0 = arg_13_0.unit_storage:unit(arg_13_2)

	ScriptUnit.extension(var_13_0, "projectile_locomotion_system"):drop()
end

function ProjectileSystem.rpc_projectile_event(arg_14_0, arg_14_1, arg_14_2, arg_14_3)
	local var_14_0 = arg_14_0.unit_storage:unit(arg_14_2)
	local var_14_1 = ScriptUnit.extension(var_14_0, "projectile_system")
	local var_14_2 = NetworkLookup.projectile_external_event[arg_14_3]

	var_14_1:trigger_external_event(var_14_2)

	if arg_14_0.is_server then
		local var_14_3 = CHANNEL_TO_PEER_ID[arg_14_1]

		Managers.state.network.network_transmit:send_rpc_clients_except("rpc_projectile_event", var_14_3, arg_14_2, arg_14_3)
	end
end

function ProjectileSystem.rpc_spawn_pickup_projectile(arg_15_0, arg_15_1, arg_15_2, arg_15_3, arg_15_4, arg_15_5, arg_15_6, arg_15_7, arg_15_8, arg_15_9, arg_15_10, arg_15_11, arg_15_12, arg_15_13)
	if not Managers.state.network:game() then
		return
	end

	local var_15_0 = arg_15_1 and CHANNEL_TO_PEER_ID[arg_15_1] or Network.peer_id()
	local var_15_1 = NetworkLookup.husks[arg_15_2]
	local var_15_2 = NetworkLookup.go_types[arg_15_3]
	local var_15_3 = NetworkLookup.pickup_names[arg_15_8]
	local var_15_4 = NetworkLookup.pickup_spawn_types[arg_15_9]
	local var_15_5 = NetworkLookup.material_settings_templates[arg_15_13]
	local var_15_6 = {
		projectile_locomotion_system = {
			network_position = arg_15_4,
			network_rotation = arg_15_5,
			network_velocity = arg_15_6,
			network_angular_velocity = arg_15_7,
			owner_peer_id = var_15_0
		},
		pickup_system = {
			has_physics = true,
			pickup_name = var_15_3,
			spawn_type = var_15_4,
			owner_peer_id = var_15_0,
			spawn_limit = arg_15_10 or 1
		}
	}
	local var_15_7 = AiAnimUtils.position_network_scale(arg_15_4)
	local var_15_8 = AiAnimUtils.rotation_network_scale(arg_15_5)
	local var_15_9 = AllPickups[var_15_3]
	local var_15_10
	local var_15_11 = var_15_9.spawn_override_func

	if var_15_11 then
		var_15_10 = var_15_11(var_15_9, var_15_6, var_15_7, var_15_8)
	else
		var_15_10 = Managers.state.unit_spawner:spawn_network_unit(var_15_1, var_15_2, var_15_6, var_15_7, var_15_8)
	end

	if arg_15_12 then
		ScriptUnit.extension(var_15_10, "tutorial_system"):set_active(true)
	end
end

function ProjectileSystem.rpc_spawn_pickup_projectile_limited(arg_16_0, arg_16_1, arg_16_2, arg_16_3, arg_16_4, arg_16_5, arg_16_6, arg_16_7, arg_16_8, arg_16_9, arg_16_10, arg_16_11, arg_16_12, arg_16_13)
	if not Managers.state.network:game() then
		return
	end

	local var_16_0 = CHANNEL_TO_PEER_ID[arg_16_1] or Network.peer_id()
	local var_16_1 = NetworkLookup.husks[arg_16_2]
	local var_16_2 = NetworkLookup.go_types[arg_16_3]
	local var_16_3 = NetworkLookup.pickup_names[arg_16_8]
	local var_16_4 = NetworkLookup.pickup_spawn_types[arg_16_11]
	local var_16_5 = LevelHelper:current_level(arg_16_0.world)
	local var_16_6 = Level.unit_by_index(var_16_5, arg_16_9)
	local var_16_7 = {
		projectile_locomotion_system = {
			network_position = arg_16_4,
			network_rotation = arg_16_5,
			network_velocity = arg_16_6,
			network_angular_velocity = arg_16_7
		},
		pickup_system = {
			has_physics = true,
			pickup_name = var_16_3,
			owner_peer_id = var_16_0,
			spawn_type = var_16_4
		},
		limited_item_track_system = {
			spawner_unit = var_16_6,
			id = arg_16_10
		},
		tutorial_system = {
			always_show = arg_16_12
		}
	}
	local var_16_8 = AiAnimUtils.position_network_scale(arg_16_4)
	local var_16_9 = AiAnimUtils.rotation_network_scale(arg_16_5)
	local var_16_10 = Managers.state.unit_spawner:spawn_network_unit(var_16_1, var_16_2, var_16_7, var_16_8, var_16_9)

	if arg_16_13 then
		ScriptUnit.extension(var_16_10, "tutorial_system"):set_active(true)
	end
end

function ProjectileSystem.rpc_spawn_explosive_pickup_projectile(arg_17_0, arg_17_1, arg_17_2, arg_17_3, arg_17_4, arg_17_5, arg_17_6, arg_17_7, arg_17_8, arg_17_9, arg_17_10, arg_17_11, arg_17_12, arg_17_13, arg_17_14, arg_17_15, arg_17_16)
	if not Managers.state.network:game() then
		return
	end

	local var_17_0 = NetworkLookup.husks[arg_17_2]
	local var_17_1 = NetworkLookup.go_types[arg_17_3]
	local var_17_2 = NetworkLookup.pickup_names[arg_17_8]
	local var_17_3 = NetworkLookup.item_names[arg_17_13]
	local var_17_4 = NetworkLookup.pickup_spawn_types[arg_17_14]
	local var_17_5

	if arg_17_10 ~= 0 then
		var_17_5 = {
			explode_time = arg_17_10,
			fuse_time = arg_17_11,
			attacker_unit_id = arg_17_12
		}
	end

	local var_17_6 = {
		projectile_locomotion_system = {
			network_position = arg_17_4,
			network_rotation = arg_17_5,
			network_velocity = arg_17_6,
			network_angular_velocity = arg_17_7
		},
		pickup_system = {
			has_physics = true,
			pickup_name = var_17_2,
			spawn_type = var_17_4
		},
		death_system = {
			in_hand = false,
			item_name = var_17_3
		},
		health_system = {
			in_hand = false,
			item_name = var_17_3,
			damage = arg_17_9,
			health_data = var_17_5
		},
		tutorial_system = {
			always_show = arg_17_15
		}
	}
	local var_17_7 = AiAnimUtils.position_network_scale(arg_17_4)
	local var_17_8 = AiAnimUtils.rotation_network_scale(arg_17_5)
	local var_17_9 = Managers.state.unit_spawner:spawn_network_unit(var_17_0, var_17_1, var_17_6, var_17_7, var_17_8)

	if arg_17_16 then
		ScriptUnit.extension(var_17_9, "tutorial_system"):set_active(true)
	end
end

function ProjectileSystem.rpc_spawn_explosive_pickup_projectile_limited(arg_18_0, arg_18_1, arg_18_2, arg_18_3, arg_18_4, arg_18_5, arg_18_6, arg_18_7, arg_18_8, arg_18_9, arg_18_10, arg_18_11, arg_18_12, arg_18_13, arg_18_14, arg_18_15, arg_18_16, arg_18_17, arg_18_18)
	if not Managers.state.network:game() then
		return
	end

	local var_18_0 = NetworkLookup.husks[arg_18_2]
	local var_18_1 = NetworkLookup.go_types[arg_18_3]
	local var_18_2 = NetworkLookup.pickup_names[arg_18_8]
	local var_18_3 = LevelHelper:current_level(arg_18_0.world)
	local var_18_4 = Level.unit_by_index(var_18_3, arg_18_9)
	local var_18_5 = NetworkLookup.item_names[arg_18_15]
	local var_18_6 = NetworkLookup.pickup_spawn_types[arg_18_16]
	local var_18_7

	if arg_18_12 ~= 0 then
		var_18_7 = {
			explode_time = arg_18_12,
			fuse_time = arg_18_13,
			attacker_unit_id = arg_18_14
		}
	end

	local var_18_8 = {
		projectile_locomotion_system = {
			network_position = arg_18_4,
			network_rotation = arg_18_5,
			network_velocity = arg_18_6,
			network_angular_velocity = arg_18_7
		},
		pickup_system = {
			has_physics = true,
			pickup_name = var_18_2,
			spawn_type = var_18_6
		},
		death_system = {
			in_hand = false,
			death_data = var_18_7,
			item_name = var_18_5
		},
		health_system = {
			health_data = var_18_7,
			item_name = var_18_5,
			damage = arg_18_11
		},
		limited_item_track_system = {
			spawner_unit = var_18_4,
			id = arg_18_10
		},
		tutorial_system = {
			always_show = arg_18_17
		}
	}
	local var_18_9 = AiAnimUtils.position_network_scale(arg_18_4)
	local var_18_10 = AiAnimUtils.rotation_network_scale(arg_18_5)
	local var_18_11 = Managers.state.unit_spawner:spawn_network_unit(var_18_0, var_18_1, var_18_8, var_18_9, var_18_10)

	if arg_18_18 then
		ScriptUnit.extension(var_18_11, "tutorial_system"):set_active(true)
	end
end

function ProjectileSystem.spawn_true_flight_projectile(arg_19_0, arg_19_1, arg_19_2, arg_19_3, arg_19_4, arg_19_5, arg_19_6, arg_19_7, arg_19_8, arg_19_9, arg_19_10, arg_19_11, arg_19_12, arg_19_13, arg_19_14, arg_19_15)
	local var_19_0 = WeaponUtils.get_weapon_template(arg_19_10).actions[arg_19_11][arg_19_12].projectile_info
	local var_19_1 = var_19_0.gravity_settings
	local var_19_2 = var_19_0.trajectory_template_name
	local var_19_3 = var_19_0.radius_min
	local var_19_4 = var_19_0.radius_max
	local var_19_5 = var_19_0.radius or var_19_3 and var_19_4 and math.lerp(var_19_0.radius_min, var_19_0.radius_max, arg_19_13) or nil
	local var_19_6 = {
		projectile_locomotion_system = {
			angle = arg_19_6,
			speed = arg_19_8,
			gravity_settings = var_19_1,
			trajectory_template_name = var_19_2,
			initial_position = arg_19_4,
			target_vector = arg_19_7,
			true_flight_template_name = arg_19_3,
			target_unit = arg_19_2,
			owner_unit = arg_19_1
		},
		projectile_impact_system = {
			item_name = arg_19_9,
			item_template_name = arg_19_10,
			action_name = arg_19_11,
			sub_action_name = arg_19_12,
			owner_unit = arg_19_1,
			radius = var_19_5
		},
		projectile_system = {
			item_name = arg_19_9,
			item_template_name = arg_19_10,
			action_name = arg_19_11,
			sub_action_name = arg_19_12,
			owner_unit = arg_19_1,
			time_initialized = Managers.time:time("game"),
			scale = arg_19_13,
			is_critical_strike = arg_19_14,
			power_level = arg_19_15
		}
	}
	local var_19_7 = arg_19_0:_get_projectile_units_names(var_19_0, arg_19_1).projectile_unit_name
	local var_19_8 = Managers.state.unit_spawner:spawn_network_unit(var_19_7, "true_flight_projectile_unit", var_19_6, arg_19_4, arg_19_5)

	arg_19_0:_add_player_projectile_reference(arg_19_1, var_19_8, var_19_0)
end

function ProjectileSystem.spawn_ai_true_flight_projectile(arg_20_0, arg_20_1, arg_20_2, arg_20_3, arg_20_4, arg_20_5, arg_20_6, arg_20_7, arg_20_8, arg_20_9, arg_20_10, arg_20_11, arg_20_12, arg_20_13)
	local var_20_0 = arg_20_9.gravity_settings
	local var_20_1 = arg_20_9.trajectory_template_name
	local var_20_2 = TrueFlightTemplates[arg_20_3]
	local var_20_3 = var_20_2.dont_target_friendly
	local var_20_4 = var_20_2.dont_target_patrols
	local var_20_5 = var_20_2.ignore_dead
	local var_20_6 = arg_20_9.radius_min
	local var_20_7 = arg_20_9.radius_max
	local var_20_8 = arg_20_9.radius or var_20_6 and var_20_7 and math.lerp(arg_20_9.radius_min, arg_20_9.radius_max, arg_20_11) or nil
	local var_20_9 = {
		projectile_locomotion_system = {
			angle = arg_20_6,
			speed = arg_20_8,
			gravity_settings = var_20_0,
			trajectory_template_name = var_20_1,
			initial_position = arg_20_4,
			target_vector = arg_20_7,
			true_flight_template_name = arg_20_3,
			target_unit = arg_20_2,
			owner_unit = arg_20_1
		},
		projectile_impact_system = {
			owner_unit = arg_20_1,
			radius = var_20_8,
			dont_target_friendly = var_20_3,
			dont_target_patrols = var_20_4,
			ignore_dead = var_20_5
		},
		projectile_system = {
			owner_unit = arg_20_1,
			time_initialized = Managers.time:time("game"),
			scale = arg_20_11,
			is_critical_strike = arg_20_12,
			power_level = arg_20_13,
			impact_template_name = arg_20_10
		}
	}
	local var_20_10 = arg_20_0:_get_projectile_units_names(arg_20_9, arg_20_1).projectile_unit_name
	local var_20_11 = arg_20_9.projectile_unit_template_name or "ai_true_flight_projectile_unit"
	local var_20_12 = Managers.state.unit_spawner:spawn_network_unit(var_20_10, var_20_11, var_20_9, arg_20_4, arg_20_5)

	arg_20_0:_add_player_projectile_reference(arg_20_1, var_20_12, arg_20_9)
end

function ProjectileSystem._add_player_projectile_reference(arg_21_0, arg_21_1, arg_21_2, arg_21_3)
	local var_21_0 = Managers.time:time("game")

	if not arg_21_0.player_projectile_units[arg_21_1] then
		arg_21_0.player_projectile_units[arg_21_1] = {}
		arg_21_0.owner_units_count = arg_21_0.owner_units_count + 1

		Managers.state.unit_spawner:add_destroy_listener(arg_21_1, "projectile_owner_" .. arg_21_0.owner_units_count, arg_21_0.projectile_owner_destroy_callback)
	end

	arg_21_0.player_projectile_units[arg_21_1][arg_21_2] = var_21_0 + (arg_21_3.unit_life_time or var_0_3)

	if arg_21_3.indexed then
		if not arg_21_0.indexed_player_projectile_units[arg_21_1] then
			arg_21_0.indexed_player_projectile_units[arg_21_1] = {}
		end

		arg_21_0.indexed_player_projectile_units[arg_21_1][#arg_21_0.indexed_player_projectile_units[arg_21_1] + 1] = arg_21_2
	end
end

function ProjectileSystem._remove_player_projectile_reference(arg_22_0, arg_22_1, arg_22_2)
	for iter_22_0, iter_22_1 in pairs(arg_22_0.player_projectile_units) do
		iter_22_1[arg_22_1] = nil
	end

	local var_22_0 = arg_22_0.indexed_player_projectile_units[arg_22_2]

	if var_22_0 then
		local var_22_1 = table.find(var_22_0, arg_22_1)

		if var_22_1 then
			table.remove(var_22_0, var_22_1)
		end
	end
end

function ProjectileSystem.get_indexed_projectile_count(arg_23_0, arg_23_1)
	local var_23_0 = arg_23_0.indexed_player_projectile_units[arg_23_1]

	if not var_23_0 then
		return 0
	end

	return #var_23_0
end

function ProjectileSystem.get_and_delete_indexed_projectile(arg_24_0, arg_24_1, arg_24_2, arg_24_3)
	local var_24_0 = arg_24_0.indexed_player_projectile_units[arg_24_1]

	if not var_24_0 then
		return nil
	end

	local var_24_1 = Managers.state.unit_spawner
	local var_24_2 = table.remove(var_24_0, arg_24_2)
	local var_24_3 = var_24_2 and Unit.alive(var_24_2)

	if not var_24_3 or var_24_3 and var_24_1:is_marked_for_deletion(var_24_2) then
		return nil
	end

	for iter_24_0, iter_24_1 in pairs(arg_24_0.player_projectile_units) do
		iter_24_1[var_24_2] = nil
	end

	if Unit.alive(var_24_2) and not var_24_1:is_marked_for_deletion(var_24_2) and not arg_24_3 then
		var_24_1:mark_for_deletion(var_24_2)
	end

	return var_24_2
end

function ProjectileSystem.delete_indexed_projectiles(arg_25_0, arg_25_1)
	local var_25_0 = arg_25_0.indexed_player_projectile_units[arg_25_1]

	if not var_25_0 then
		return
	end

	local var_25_1 = Managers.state.unit_spawner
	local var_25_2 = arg_25_0.player_projectile_units[arg_25_1]

	for iter_25_0 = 1, #var_25_0 do
		local var_25_3 = var_25_0[iter_25_0]

		if var_25_3 then
			if Unit.alive(var_25_3) then
				var_25_1:mark_for_deletion(var_25_3)
			end

			if var_25_2 then
				var_25_2[var_25_3] = nil
			end
		end
	end

	arg_25_0.indexed_player_projectile_units[arg_25_1] = nil
end

function ProjectileSystem.rpc_generic_impact_projectile_impact(arg_26_0, arg_26_1, arg_26_2, arg_26_3, arg_26_4, arg_26_5, arg_26_6, arg_26_7, arg_26_8, arg_26_9)
	if arg_26_0.is_server then
		local var_26_0 = CHANNEL_TO_PEER_ID[arg_26_1]

		Managers.state.network.network_transmit:send_rpc_clients_except("rpc_generic_impact_projectile_impact", var_26_0, arg_26_2, arg_26_3, arg_26_4, arg_26_5, arg_26_6, arg_26_7, arg_26_8, arg_26_9)
	end

	local var_26_1 = arg_26_0.unit_storage
	local var_26_2 = var_26_1:unit(arg_26_2)
	local var_26_3

	if arg_26_3 == NetworkConstants.game_object_id_max then
		local var_26_4 = LevelHelper:current_level(arg_26_0.world)

		var_26_3 = Level.unit_by_index(var_26_4, arg_26_4)
	else
		var_26_3 = var_26_1:unit(arg_26_3)
	end

	if not Unit.alive(var_26_3) then
		return
	end

	if not arg_26_0.bufferd_impacts then
		arg_26_0.bufferd_impacts = {}
	end

	arg_26_0.bufferd_impacts[var_26_3] = {
		var_26_3,
		Vector3Box(arg_26_5),
		Vector3Box(arg_26_6),
		Vector3Box(arg_26_7),
		arg_26_8
	}
	arg_26_0.impact_buffer_counter = arg_26_0.impact_buffer_counter and arg_26_0.impact_buffer_counter + 1 or 1

	if arg_26_9 <= arg_26_0.impact_buffer_counter then
		local var_26_5 = 0

		for iter_26_0, iter_26_1 in pairs(arg_26_0.bufferd_impacts) do
			if Unit.alive(iter_26_0) then
				var_26_5 = var_26_5 + 1

				local var_26_6 = Unit.actor(iter_26_0, iter_26_1[ProjectileImpactDataIndex.ACTOR_INDEX])

				ScriptUnit.extension(var_26_2, "projectile_system"):impact(iter_26_0, iter_26_1[ProjectileImpactDataIndex.POSITION]:unbox(), iter_26_1[ProjectileImpactDataIndex.DIRECTION]:unbox(), iter_26_1[ProjectileImpactDataIndex.NORMAL]:unbox(), var_26_6, var_26_5)
			end
		end

		arg_26_0.bufferd_impacts = nil
		arg_26_0.impact_buffer_counter = 0
	end
end

function ProjectileSystem.rpc_generic_impact_projectile_force_impact(arg_27_0, arg_27_1, arg_27_2, arg_27_3)
	if arg_27_0.is_server then
		local var_27_0 = CHANNEL_TO_PEER_ID[arg_27_1]

		Managers.state.network.network_transmit:send_rpc_clients_except("rpc_generic_impact_projectile_force_impact", var_27_0, arg_27_2, arg_27_3)
	end

	local var_27_1 = arg_27_0.unit_storage:unit(arg_27_2)

	ScriptUnit.extension(var_27_1, "projectile_system"):force_impact(var_27_1, arg_27_3)
end

function ProjectileSystem.rpc_player_projectile_impact_level(arg_28_0, arg_28_1, arg_28_2, arg_28_3, arg_28_4, arg_28_5, arg_28_6, arg_28_7)
	if arg_28_0.is_server then
		local var_28_0 = CHANNEL_TO_PEER_ID[arg_28_1]

		Managers.state.network.network_transmit:send_rpc_clients_except("rpc_player_projectile_impact_level", var_28_0, arg_28_2, arg_28_3, arg_28_4, arg_28_5, arg_28_6, arg_28_7)
	end

	local var_28_1 = LevelHelper:current_level(arg_28_0.world)
	local var_28_2 = Level.unit_by_index(var_28_1, arg_28_3)
	local var_28_3 = arg_28_0.unit_storage:unit(arg_28_2)

	if var_28_2 then
		local var_28_4 = Unit.actor(var_28_2, arg_28_7)

		ScriptUnit.extension(var_28_3, "projectile_system"):impact_level(var_28_2, arg_28_4, arg_28_5, arg_28_6, var_28_4, arg_28_3)
	end
end

function ProjectileSystem.rpc_player_projectile_impact_dynamic(arg_29_0, arg_29_1, arg_29_2, arg_29_3, arg_29_4, arg_29_5, arg_29_6, arg_29_7)
	if arg_29_0.is_server then
		local var_29_0 = CHANNEL_TO_PEER_ID[arg_29_1]

		Managers.state.network.network_transmit:send_rpc_clients_except("rpc_player_projectile_impact_dynamic", var_29_0, arg_29_2, arg_29_3, arg_29_4, arg_29_5, arg_29_6, arg_29_7)
	end

	local var_29_1 = arg_29_0.unit_storage
	local var_29_2 = var_29_1:unit(arg_29_2)
	local var_29_3 = var_29_1:unit(arg_29_3)

	if var_29_3 then
		local var_29_4 = Unit.actor(var_29_3, arg_29_7)

		ScriptUnit.extension(var_29_2, "projectile_system"):impact_dynamic(var_29_3, arg_29_4, arg_29_5, arg_29_6, var_29_4)
	end
end

function ProjectileSystem.create_light_weight_projectile(arg_30_0, arg_30_1, arg_30_2, arg_30_3, arg_30_4, arg_30_5, arg_30_6, arg_30_7, arg_30_8, arg_30_9, arg_30_10, arg_30_11, arg_30_12, arg_30_13, arg_30_14, arg_30_15, arg_30_16, arg_30_17)
	local var_30_0 = arg_30_0.world
	local var_30_1 = arg_30_0.is_server
	local var_30_2 = Quaternion.look(arg_30_4, Vector3.up())
	local var_30_3 = not arg_30_13
	local var_30_4
	local var_30_5 = arg_30_17

	if arg_30_16 then
		var_30_4 = arg_30_16
	elseif var_30_3 then
		var_30_4 = arg_30_0._light_weight.own_data
		var_30_5 = arg_30_0._current_id
		arg_30_0._current_id = 1 + arg_30_0._current_id % 65535
	else
		local var_30_6 = arg_30_0._light_weight.husk_list[arg_30_12]

		if not var_30_6 then
			local var_30_7 = NetworkConstants.light_weight_projectile_index.max

			var_30_6 = {
				is_owner = false,
				current_index = 0,
				projectiles = Script.new_array(var_30_7),
				max_index = var_30_7,
				owner_peer_id = arg_30_12
			}
			arg_30_0._light_weight.husk_list[arg_30_12] = var_30_6
		end

		var_30_4 = var_30_6
	end

	local var_30_8 = var_30_4.current_index + 1
	local var_30_9 = var_30_4.max_index

	if var_30_9 < var_30_8 then
		if not arg_30_14 then
			assert(var_30_1, "Client trying to spawn more projectiles light weight projectiles than there's room for.")
		end

		arg_30_0:_remove_light_weight_projectile(var_30_4, Math.random(1, var_30_9))

		var_30_8 = var_30_9
	end

	local var_30_10 = {
		damage_source = arg_30_1,
		position = Vector3Box(arg_30_3),
		direction = Vector3Box(arg_30_4),
		rotation = QuaternionBox(var_30_2),
		speed = arg_30_5,
		flat_speed = arg_30_7 or 0,
		index = var_30_8,
		owner_unit = arg_30_2,
		particle_settings = {},
		sound_settings = {},
		gravity = arg_30_6 or 0,
		skip_rpc = arg_30_14,
		husk_projectile = arg_30_15,
		projectile_list_reference = arg_30_16,
		identifier = var_30_5
	}
	local var_30_11 = LightWeightProjectileEffects[arg_30_11]
	local var_30_12 = var_30_11 and var_30_11.vfx

	if var_30_12 then
		for iter_30_0 = 1, #var_30_12 do
			local var_30_13 = var_30_12[iter_30_0]
			local var_30_14 = var_30_13.condition_function

			if not var_30_14 or var_30_14(arg_30_2) then
				local var_30_15
				local var_30_16 = var_30_13.particle_name
				local var_30_17 = var_30_13.link

				if var_30_17 then
					local var_30_18 = var_30_13.unit_function(arg_30_2)
					local var_30_19 = Unit.node(var_30_18, var_30_17)

					var_30_15 = ScriptWorld.create_particles_linked(var_30_0, var_30_16, var_30_18, var_30_19, "destroy")
				else
					var_30_15 = World.create_particles(var_30_0, var_30_16, arg_30_3, var_30_2)
				end

				var_30_10.particle_settings[var_30_15] = var_30_13
			end
		end
	end

	local var_30_20 = var_30_11 and var_30_11.sfx

	if var_30_20 then
		for iter_30_1 = 1, #var_30_20 do
			local var_30_21 = var_30_20[iter_30_1]
			local var_30_22 = var_30_21.looping_sound_event_name
			local var_30_23 = WwiseWorld.make_manual_source(arg_30_0._wwise_world, arg_30_3)

			WwiseWorld.trigger_event(arg_30_0._wwise_world, var_30_22, var_30_23)

			var_30_10.sound_settings[var_30_23] = var_30_21
		end
	end

	if var_30_3 then
		local var_30_24 = callback(arg_30_0, "physics_cb_light_weight_projectile_hit", var_30_10)
		local var_30_25 = World.get_data(var_30_0, "physics_world")

		var_30_10.raycast = PhysicsWorld.make_raycast(var_30_25, var_30_24, "all", "types", "both", "collision_filter", arg_30_9)
		var_30_10.distance_moved = 0
		var_30_10.range = arg_30_8
		var_30_10.action_data = arg_30_10
		var_30_10.owner_unit = arg_30_2
		var_30_10.effect_name = arg_30_11

		local var_30_26 = NetworkConstants.light_weight_projectile_speed
		local var_30_27 = var_30_26.min
		local var_30_28 = var_30_26.max

		fassert(var_30_27 <= arg_30_5 and arg_30_5 <= var_30_28, "Trying to create particle with speed (%i) outside of global.network_config bounds (%i:%i), raise \"light_weight_projectile_speed\" max.", arg_30_5, var_30_27, var_30_28)

		local var_30_29, var_30_30 = arg_30_0.network_manager:game_object_or_level_id(arg_30_2)

		if not arg_30_14 then
			if arg_30_0.is_server then
				arg_30_0.network_transmit:send_rpc_clients("rpc_client_spawn_light_weight_projectile", NetworkLookup.damage_sources[arg_30_1], var_30_29, arg_30_3, arg_30_4, arg_30_5, arg_30_6 or 0, arg_30_7 or 0, NetworkLookup.light_weight_projectile_effects[arg_30_11], var_30_30, arg_30_12, var_30_10.identifier)
			else
				arg_30_0.network_transmit:send_rpc_server("rpc_client_spawn_light_weight_projectile", NetworkLookup.damage_sources[arg_30_1], var_30_29, arg_30_3, arg_30_4, arg_30_5, arg_30_6 or 0, arg_30_7 or 0, NetworkLookup.light_weight_projectile_effects[arg_30_11], var_30_30, arg_30_12, var_30_10.identifier)
			end
		end
	elseif arg_30_0.is_server and not arg_30_14 then
		local var_30_31, var_30_32 = arg_30_0.network_manager:game_object_or_level_id(arg_30_2)

		arg_30_0.network_transmit:send_rpc_clients_except("rpc_client_spawn_light_weight_projectile", arg_30_12, NetworkLookup.damage_sources[arg_30_1], var_30_31, arg_30_3, arg_30_4, arg_30_5, arg_30_6 or 0, arg_30_7 or 0, NetworkLookup.light_weight_projectile_effects[arg_30_11], var_30_32, arg_30_12, var_30_10.identifier)
	end

	var_30_4.projectiles[var_30_8] = var_30_10
	var_30_4.current_index = var_30_8
end

function ProjectileSystem.hot_join_sync(arg_31_0, arg_31_1)
	ProjectileSystem.super.hot_join_sync(arg_31_0, arg_31_1)

	local var_31_0 = Managers.state.network
	local var_31_1 = var_31_0.network_transmit
	local var_31_2 = arg_31_0._light_weight.own_data
	local var_31_3 = var_31_2.projectiles
	local var_31_4 = var_31_2.owner_peer_id

	for iter_31_0 = 1, var_31_2.current_index do
		local var_31_5 = var_31_3[iter_31_0]
		local var_31_6 = var_31_5.position:unbox()
		local var_31_7 = var_31_5.direction:unbox()
		local var_31_8 = var_31_5.speed
		local var_31_9 = var_31_5.effect_name
		local var_31_10 = var_31_5.gravity
		local var_31_11 = var_31_5.flat_speed
		local var_31_12 = var_31_5.skip_rpc
		local var_31_13 = var_31_5.identifier

		if not var_31_12 then
			local var_31_14, var_31_15 = var_31_0:game_object_or_level_id(var_31_5.owner_unit)

			var_31_1:send_rpc("rpc_client_spawn_light_weight_projectile", arg_31_1, NetworkLookup.damage_sources[var_31_5.damage_source], var_31_14, var_31_6, var_31_7, var_31_8, var_31_10, var_31_11, NetworkLookup.light_weight_projectile_effects[var_31_9], var_31_15, var_31_4, var_31_13)
		end
	end
end

function ProjectileSystem.rpc_clients_continuous_shoot_start(arg_32_0, arg_32_1, arg_32_2, arg_32_3, arg_32_4, arg_32_5, arg_32_6, arg_32_7)
	local var_32_0 = Managers.state.network:game_object_or_level_unit(arg_32_2, arg_32_3)
	local var_32_1 = NetworkLookup.breeds[arg_32_4]
	local var_32_2 = Breeds[var_32_1]
	local var_32_3 = var_32_2.default_inventory_template
	local var_32_4 = ScriptUnit.extension(var_32_0, "ai_inventory_system"):get_unit(var_32_3)
	local var_32_5 = Managers.time:time("game")
	local var_32_6 = NetworkLookup.bt_action_names[arg_32_5]
	local var_32_7 = BreedActions[var_32_1][var_32_6]
	local var_32_8 = var_32_7.light_weight_projectile_template_name
	local var_32_9 = LightWeightProjectiles[var_32_8]
	local var_32_10 = 1 / var_32_7.fire_rate_at_start
	local var_32_11 = 1 / var_32_7.fire_rate_at_end
	local var_32_12 = 1 / var_32_7.max_fire_rate_at_percentage
	local var_32_13 = NetworkConstants.light_weight_projectile_index.max

	arg_32_0._light_weight.husk_shoot_list[arg_32_2] = {
		shots_fired = 0,
		owner_unit = var_32_0,
		owner_unit_id = arg_32_2,
		light_weight_projectile_template = var_32_9,
		shoot_start = var_32_5,
		shoot_duration = arg_32_6,
		max_fire_rate_at_percentage_modifier = var_32_12,
		time_between_shots_at_start = var_32_10,
		time_between_shots_at_end = var_32_11,
		ratling_gun_unit = var_32_4,
		owner_peer_id = arg_32_7,
		breed = var_32_2,
		projectile_list = {
			is_owner = false,
			current_index = 0,
			max_index = var_32_13,
			projectiles = Script.new_array(var_32_13),
			owner_peer_id = arg_32_7
		}
	}
end

function ProjectileSystem._update_shooting(arg_33_0, arg_33_1, arg_33_2, arg_33_3)
	for iter_33_0, iter_33_1 in pairs(arg_33_3) do
		local var_33_0 = iter_33_1.owner_unit
		local var_33_1 = arg_33_2 - iter_33_1.shoot_start
		local var_33_2 = math.clamp(var_33_1 / iter_33_1.shoot_duration * iter_33_1.max_fire_rate_at_percentage_modifier, 0, 1)
		local var_33_3 = math.lerp(iter_33_1.time_between_shots_at_start, iter_33_1.time_between_shots_at_end, var_33_2)
		local var_33_4 = math.floor(var_33_1 / var_33_3) + 1 - iter_33_1.shots_fired
		local var_33_5 = iter_33_1.light_weight_projectile_template

		for iter_33_2 = 1, var_33_4 do
			iter_33_1.shots_fired = iter_33_1.shots_fired + 1

			arg_33_0:_shoot(iter_33_0, iter_33_1, arg_33_2, arg_33_1)
		end
	end
end

function ProjectileSystem._fire_from_position_direction(arg_34_0, arg_34_1, arg_34_2)
	local var_34_0 = Unit.node(arg_34_1, "p_fx")
	local var_34_1 = Unit.world_position(arg_34_1, var_34_0)
	local var_34_2 = Managers.state.network:game()
	local var_34_3 = GameSession.game_object_field(var_34_2, arg_34_2, "aim_position")
	local var_34_4

	if var_34_3 then
		var_34_4 = var_34_3 - var_34_1
	else
		var_34_4 = Quaternion.forward(Unit.world_rotation(arg_34_1, var_34_0))
	end

	return var_34_1 - Vector3.normalize(var_34_4) * 0.25, var_34_4
end

function ProjectileSystem._shoot(arg_35_0, arg_35_1, arg_35_2, arg_35_3, arg_35_4)
	local var_35_0, var_35_1 = arg_35_0:_fire_from_position_direction(arg_35_2.ratling_gun_unit, arg_35_2.owner_unit_id)
	local var_35_2 = arg_35_2.light_weight_projectile_template
	local var_35_3 = Vector3.normalize(var_35_1)
	local var_35_4 = Math.random() * var_35_2.spread
	local var_35_5 = Quaternion.look(var_35_3, Vector3.up())
	local var_35_6 = Quaternion(Vector3.right(), var_35_4)
	local var_35_7 = Quaternion(Vector3.forward(), Math.random() * var_0_4)
	local var_35_8 = Quaternion.multiply(Quaternion.multiply(var_35_5, var_35_7), var_35_6)
	local var_35_9 = Quaternion.forward(var_35_8)
	local var_35_10 = "filter_enemy_player_afro_ray_projectile"
	local var_35_11 = Managers.state.difficulty:get_difficulty_rank()
	local var_35_12 = var_35_2.attack_power_level[var_35_11] or var_35_2.attack_power_level[2]
	local var_35_13 = {
		power_level = var_35_12,
		damage_profile = var_35_2.damage_profile,
		hit_effect = var_35_2.hit_effect,
		player_push_velocity = Vector3Box(var_35_3 * var_35_2.impact_push_speed),
		projectile_linker = var_35_2.projectile_linker,
		first_person_hit_flow_events = var_35_2.first_person_hit_flow_events
	}
	local var_35_14 = arg_35_2.peer_id
	local var_35_15 = true
	local var_35_16 = true

	arg_35_0:create_light_weight_projectile(arg_35_2.breed.name, arg_35_2.owner_unit, var_35_0, var_35_9, var_35_2.projectile_speed, nil, nil, var_35_2.projectile_max_range, var_35_10, var_35_13, var_35_2.light_weight_projectile_effect, arg_35_1, nil, var_35_15, var_35_16, arg_35_2.projectile_list)
end

function ProjectileSystem.rpc_clients_continuous_shoot_stop(arg_36_0, arg_36_1, arg_36_2)
	local var_36_0 = arg_36_0._light_weight.husk_shoot_list
	local var_36_1 = var_36_0[arg_36_2]

	if not var_36_1 then
		return
	end

	for iter_36_0 = #var_36_1.projectile_list.projectiles, 1, -1 do
		arg_36_0:_remove_light_weight_projectile(var_36_1.projectile_list, iter_36_0)
	end

	var_36_0[arg_36_2] = nil
end

function ProjectileSystem.rpc_client_spawn_light_weight_projectile(arg_37_0, arg_37_1, arg_37_2, arg_37_3, arg_37_4, arg_37_5, arg_37_6, arg_37_7, arg_37_8, arg_37_9, arg_37_10, arg_37_11, arg_37_12)
	local var_37_0 = NetworkLookup.light_weight_projectile_effects[arg_37_9]
	local var_37_1 = arg_37_0.network_manager:game_object_or_level_unit(arg_37_3, arg_37_10)
	local var_37_2 = NetworkLookup.damage_sources[arg_37_2]
	local var_37_3 = true

	arg_37_0:create_light_weight_projectile(var_37_2, var_37_1, arg_37_4, arg_37_5, arg_37_6, arg_37_7, arg_37_8, nil, nil, nil, var_37_0, arg_37_11, var_37_3, nil, nil, nil, arg_37_12)
end

function ProjectileSystem.rpc_client_despawn_light_weight_projectile(arg_38_0, arg_38_1, arg_38_2, arg_38_3, arg_38_4)
	local var_38_0 = arg_38_0._light_weight.husk_list[arg_38_2]

	if var_38_0 then
		for iter_38_0, iter_38_1 in pairs(var_38_0.projectiles) do
			if iter_38_1.identifier == arg_38_4 then
				arg_38_3 = iter_38_0

				break
			end
		end

		arg_38_0:_remove_light_weight_projectile(var_38_0, arg_38_3)
	end
end

function ProjectileSystem.rpc_client_create_aoe(arg_39_0, arg_39_1, arg_39_2, arg_39_3, arg_39_4, arg_39_5, arg_39_6)
	local var_39_0 = arg_39_0.world
	local var_39_1 = arg_39_0.unit_storage:unit(arg_39_2)
	local var_39_2 = NetworkLookup.damage_sources[arg_39_4]
	local var_39_3 = NetworkLookup.explosion_templates[arg_39_5]
	local var_39_4 = ExplosionUtils.get_template(var_39_3)

	DamageUtils.create_aoe(var_39_0, var_39_1, arg_39_3, var_39_2, var_39_4, arg_39_6)
end

function ProjectileSystem.spawn_drones(arg_40_0, arg_40_1, arg_40_2, arg_40_3, arg_40_4, arg_40_5, arg_40_6)
	local var_40_0 = ScriptUnit.has_extension(arg_40_1, "buff_system")

	if var_40_0 then
		arg_40_3 = var_40_0:apply_buffs_to_value(arg_40_3, "increased_drone_count")
	end

	local var_40_1 = arg_40_0.unit_storage:go_id(arg_40_1)
	local var_40_2 = NetworkLookup.drone_templates[arg_40_2]

	arg_40_4 = math.round(arg_40_4)

	local var_40_3 = SideRelationLookup[arg_40_5]
	local var_40_4 = NetworkLookup.damage_profiles[arg_40_6]

	arg_40_0.network_transmit:send_rpc_server("rpc_request_spawn_drones", var_40_1, var_40_2, arg_40_3, arg_40_4, var_40_3, var_40_4)
end

local var_0_7 = {}

function ProjectileSystem.rpc_request_spawn_drones(arg_41_0, arg_41_1, arg_41_2, arg_41_3, arg_41_4, arg_41_5, arg_41_6, arg_41_7)
	local var_41_0 = arg_41_0.unit_storage:unit(arg_41_2)

	if not Unit.alive(var_41_0) then
		return
	end

	local var_41_1 = Managers.state.side.side_by_unit[var_41_0]
	local var_41_2 = SideRelationLookup[arg_41_6]
	local var_41_3 = var_41_1:broadphase_categories_by_relation(var_41_2)
	local var_41_4 = AiUtils.broadphase_query(Unit.local_position(var_41_0, 0), arg_41_5, var_0_7, var_41_3)
	local var_41_5 = 0

	for iter_41_0 = 1, var_41_4 do
		local var_41_6 = arg_41_0.unit_storage:go_id(var_0_7[iter_41_0])

		if var_41_6 then
			var_41_5 = var_41_5 + 1
			var_0_7[var_41_5] = var_41_6
		end
	end

	local var_41_7 = math.min(var_41_5, Network.type_info("game_object_id_array_8").max_size)

	if var_41_7 == 0 then
		return
	end

	local var_41_8 = arg_41_0._drone_seed_per_source
	local var_41_9 = var_41_8[var_41_0]

	if not var_41_9 then
		var_41_8[var_41_0] = math.random(var_41_8.min_seed, var_41_8.max_seed)
	else
		var_41_8[var_41_0] = Math.next_random(var_41_9)
	end

	local var_41_10 = {}

	for iter_41_1 = 1, arg_41_4 do
		var_41_10[iter_41_1] = var_0_7[math.random(1, var_41_7)]
	end

	arg_41_0.network_transmit:send_rpc_all("rpc_spawn_drones", arg_41_2, arg_41_3, var_41_8[var_41_0], arg_41_7, var_41_10)
end

local var_0_8 = 0.1
local var_0_9 = 0.025
local var_0_10 = 100
local var_0_11 = 5
local var_0_12 = 14
local var_0_13 = 3
local var_0_14 = 0
local var_0_15 = math.pi * 0.18
local var_0_16 = 2
local var_0_17 = 10
local var_0_18 = -math.pi * 0.1
local var_0_19 = math.pi * 0.3
local var_0_20 = math.pi * 0.1
local var_0_21 = math.pi * 2
local var_0_22 = var_0_17
local var_0_23 = var_0_16

function ProjectileSystem.rpc_spawn_drones(arg_42_0, arg_42_1, arg_42_2, arg_42_3, arg_42_4, arg_42_5, arg_42_6)
	local var_42_0 = arg_42_0.unit_storage:unit(arg_42_2)

	if not Unit.alive(var_42_0) then
		return
	end

	arg_42_0._drones = arg_42_0._drones or {}

	local var_42_1 = arg_42_0._drones
	local var_42_2 = NetworkLookup.drone_templates[arg_42_3]
	local var_42_3 = DroneTemplates[var_42_2]
	local var_42_4 = NetworkLookup.damage_profiles[arg_42_5]
	local var_42_5 = arg_42_4

	for iter_42_0 = 1, #arg_42_6 do
		repeat
			var_42_5 = Math.next_random(var_42_5)

			local var_42_6
			local var_42_7

			var_42_5, var_42_7 = Math.next_random(var_42_5, 0, 1)

			local var_42_8 = var_42_7 * 2 - 1
			local var_42_9 = arg_42_0.unit_storage:unit(arg_42_6[iter_42_0])

			if not ALIVE[var_42_9] then
				break
			end

			var_42_1[#var_42_1 + 1] = {
				source_unit = var_42_0,
				time_to_spawn = var_0_8,
				target_unit = var_42_9,
				drone_template = var_42_3,
				last_known_target_pos = Vector3Box(POSITION_LOOKUP[var_42_9]),
				source_pos = Vector3Box(),
				current_pos = Vector3Box(),
				current_rot = QuaternionBox(),
				damage_profile_name = var_42_4,
				drone_group_i = iter_42_0,
				upward_side = var_42_8,
				vfx_seed = var_42_5
			}
		until true
	end
end

local function var_0_24(arg_43_0, arg_43_1, arg_43_2)
	local var_43_0 = arg_43_0.source_unit

	if not Unit.alive(var_43_0) then
		return nil
	end

	local var_43_1 = Unit.local_position(var_43_0, 0)
	local var_43_2 = Vector3.length(arg_43_1 - var_43_1)

	if var_43_2 < math.epsilon then
		return nil
	end

	local var_43_3 = arg_43_0.upward_side
	local var_43_4 = Vector3.normalize(arg_43_1 - var_43_1)
	local var_43_5 = Vector3.cross(Vector3.up(), var_43_4)
	local var_43_6 = var_43_1 + (Vector3(0, 0, 1) + var_43_5 * 0.75 * var_43_3 + var_43_4 * -0.5)
	local var_43_7, var_43_8 = Math.next_random(arg_43_0.vfx_seed)
	local var_43_9 = var_0_18 + var_43_8 * (var_0_19 - var_0_18)
	local var_43_10 = math.remap(var_0_16, var_0_17, var_0_14, var_0_15, var_43_2)
	local var_43_11 = Vector3.normalize(arg_43_1 - var_43_6)
	local var_43_12 = Quaternion.rotate(Quaternion.axis_angle(Vector3.cross(var_43_11, Vector3.up()), var_43_9), var_43_11)
	local var_43_13 = Quaternion.rotate(Quaternion.axis_angle(Vector3.up() * var_43_3, var_43_10), var_43_12)
	local var_43_14 = Quaternion.look(var_43_13)

	arg_43_0.source_pos:store(var_43_6)
	arg_43_0.current_pos:store(var_43_6)
	arg_43_0.current_rot:store(var_43_14)

	local var_43_15 = arg_43_0.drone_template

	if var_43_15.spawn_sfx then
		WwiseUtils.trigger_position_event(arg_43_2, var_43_15.spawn_sfx, var_43_6)
	end

	if var_43_15.linked_vfx then
		return World.create_particles(arg_43_2, var_43_15.linked_vfx.name, var_43_6, var_43_14)
	else
		return -1
	end
end

local function var_0_25(arg_44_0, arg_44_1, arg_44_2, arg_44_3, arg_44_4)
	local var_44_0 = arg_44_0.source_pos:unbox()
	local var_44_1 = arg_44_0.current_pos:unbox()
	local var_44_2 = arg_44_0.current_rot:unbox()
	local var_44_3 = Geometry.closest_point_on_line(var_44_1, var_44_0, arg_44_1)
	local var_44_4 = Vector3.distance(arg_44_1, var_44_3)
	local var_44_5
	local var_44_6 = math.remap(var_0_22, var_0_23, var_0_20, var_0_21, var_44_4)
	local var_44_7 = arg_44_1 - var_44_1
	local var_44_8 = Quaternion.look(var_44_7)
	local var_44_9 = var_44_6 * arg_44_3
	local var_44_10 = Quaternion.angle(var_44_8, var_44_2)

	if var_44_6 >= var_0_21 or var_44_10 <= var_44_9 * 1.05 then
		var_44_5 = var_44_8
	else
		local var_44_11 = Quaternion.forward(var_44_2)
		local var_44_12 = Vector3.normalize(Vector3.cross(var_44_7, var_44_11))

		if Vector3.length_squared(var_44_12) <= math.epsilon then
			var_44_5 = Quaternion.look(var_44_7)
		else
			var_44_5 = Quaternion.multiply(Quaternion.axis_angle(var_44_12, var_44_9), var_44_2)

			if var_44_10 < Quaternion.angle(var_44_8, var_44_5) then
				local var_44_13 = Vector3.normalize(Vector3.cross(var_44_11, var_44_7))

				var_44_5 = Quaternion.multiply(Quaternion.axis_angle(var_44_13, var_44_9), var_44_2)
			end
		end
	end

	local var_44_14 = arg_44_4 - arg_44_0.spawn_t
	local var_44_15 = math.lerp_clamped(var_0_11, var_0_12, var_44_14 / var_0_13)
	local var_44_16 = Quaternion.forward(var_44_5) * var_44_15 * arg_44_3 / math.clamp(math.cos(var_44_10), 0.1, 1)

	if Vector3.length_squared(var_44_16) >= var_44_4 * var_44_4 then
		return true
	end

	local var_44_17 = var_44_1 + var_44_16

	arg_44_0.current_pos:store(var_44_17)
	arg_44_0.current_rot:store(var_44_5)
	World.move_particles(arg_44_2, arg_44_0.vfx_id, var_44_17, var_44_5)
end

local function var_0_26(arg_45_0, arg_45_1, arg_45_2)
	local var_45_0 = arg_45_0.drone_template
	local var_45_1 = arg_45_0.vfx_id

	if var_45_1 and var_45_1 >= 0 then
		if var_45_0.linked_vfx.destroy_policy == "stop" then
			World.stop_spawning_particles(arg_45_1, var_45_1)
		else
			World.destroy_particles(arg_45_1, var_45_1)
		end
	end

	local var_45_2 = arg_45_0.current_pos:unbox()

	if var_45_0.impact_vfx then
		local var_45_3 = arg_45_0.current_rot:unbox()

		World.create_particles(arg_45_1, var_45_0.impact_vfx, var_45_2, var_45_3)
	end

	if var_45_0.impact_sfx then
		WwiseUtils.trigger_position_event(arg_45_1, var_45_0.impact_sfx, var_45_2)
	end

	if not arg_45_2 then
		return
	end

	local var_45_4 = DamageProfileTemplates[arg_45_0.damage_profile_name]
	local var_45_5 = arg_45_0.target_unit
	local var_45_6 = HEALTH_ALIVE[arg_45_0.source_unit] and arg_45_0.source_unit or var_45_5

	if HEALTH_ALIVE[var_45_5] then
		local var_45_7 = DefaultPowerLevel
		local var_45_8 = ScriptUnit.has_extension(arg_45_0.source_unit, "career_system")

		if var_45_8 then
			var_45_7 = var_45_8:get_career_power_level()
		end

		local var_45_9 = "full"
		local var_45_10 = arg_45_0.current_pos:unbox()
		local var_45_11 = Quaternion.forward(arg_45_0.current_rot:unbox())
		local var_45_12 = "buff"
		local var_45_13 = false
		local var_45_14
		local var_45_15 = false
		local var_45_16 = false
		local var_45_17 = false
		local var_45_18 = arg_45_0.drone_group_i + 1
		local var_45_19

		DamageUtils.add_damage_network_player(var_45_4, arg_45_0.drone_group_i, var_45_7, var_45_5, var_45_6, var_45_9, var_45_10, var_45_11, var_45_12, var_45_13, var_45_14, var_45_15, var_45_16, var_45_17, var_45_18, var_45_19, var_45_6)
	end
end

function ProjectileSystem._update_drones(arg_46_0, arg_46_1, arg_46_2)
	local var_46_0 = arg_46_0._drones

	if not var_46_0 then
		return
	end

	local var_46_1 = math.remap(0, var_0_10, var_0_8, var_0_9, math.clamp(#var_46_0, 0, var_0_10))
	local var_46_2 = var_0_8 / var_46_1
	local var_46_3 = 1

	while var_46_3 <= #var_46_0 do
		local var_46_4 = var_46_0[var_46_3]

		if not var_46_4.spawn_t then
			var_46_4.time_to_spawn = var_46_4.time_to_spawn - arg_46_1 * var_46_2

			if var_46_4.time_to_spawn > 0 then
				return
			else
				var_46_4.spawn_t = arg_46_2

				local var_46_5 = var_46_0[var_46_3 + 1]

				if var_46_5 then
					local var_46_6 = math.abs(var_46_4.time_to_spawn)

					var_46_5.time_to_spawn = var_46_5.time_to_spawn - var_46_6
				end
			end
		end

		local var_46_7 = var_46_4.last_known_target_pos
		local var_46_8 = var_46_4.target_unit

		if Unit.alive(var_46_8) then
			if Unit.has_node(var_46_8, "j_spine") then
				var_46_7:store(Unit.world_position(var_46_8, Unit.node(var_46_8, "j_spine")))
			else
				local var_46_9 = Unit.get_data(var_46_8, "breed") and AiUtils.breed_height(var_46_8) * 0.6 or 0

				var_46_7:store(POSITION_LOOKUP[var_46_8] + Vector3(0, 0, var_46_9))
			end
		end

		local var_46_10 = var_46_7:unbox()

		if not var_46_4.vfx_id then
			var_46_4.vfx_id = var_0_24(var_46_4, var_46_10, arg_46_0.world)

			if not var_46_4.vfx_id then
				var_0_26(var_46_4, arg_46_0.world, arg_46_0.is_server)
				table.remove(var_46_0, var_46_3)

				var_46_3 = var_46_3 - 1
			end
		elseif var_0_25(var_46_4, var_46_10, arg_46_0.world, arg_46_1, arg_46_2) then
			var_0_26(var_46_4, arg_46_0.world, arg_46_0.is_server)
			table.remove(var_46_0, var_46_3)

			var_46_3 = var_46_3 - 1
		end

		var_46_3 = var_46_3 + 1
	end
end

function ProjectileSystem._remove_light_weight_projectile(arg_47_0, arg_47_1, arg_47_2)
	local var_47_0 = arg_47_0.world
	local var_47_1 = arg_47_1 and arg_47_1.projectiles
	local var_47_2 = var_47_1 and var_47_1[arg_47_2]

	if not var_47_2 then
		return
	end

	local var_47_3 = arg_47_1.current_index
	local var_47_4 = var_47_2.identifier

	if arg_47_2 ~= var_47_3 then
		local var_47_5 = var_47_1[var_47_3]

		var_47_5.index = arg_47_2
		var_47_1[var_47_3] = var_47_2
		var_47_1[arg_47_2] = var_47_5
	end

	for iter_47_0, iter_47_1 in pairs(var_47_2.particle_settings) do
		if iter_47_1.kill_policy == "stop" then
			World.stop_spawning_particles(var_47_0, iter_47_0)
		elseif iter_47_1.kill_policy == "destroy" then
			World.destroy_particles(var_47_0, iter_47_0)
		end
	end

	for iter_47_2, iter_47_3 in pairs(var_47_2.sound_settings) do
		local var_47_6 = iter_47_3.looping_sound_stop_event_name

		if var_47_6 then
			WwiseWorld.trigger_event(arg_47_0._wwise_world, var_47_6, iter_47_2)
		end

		WwiseWorld.destroy_manual_source(arg_47_0._wwise_world, iter_47_2)
	end

	var_47_1[var_47_3] = nil
	arg_47_1.current_index = var_47_3 - 1

	local var_47_7 = arg_47_0.is_server

	if var_47_2.skip_rpc then
		return
	end

	if arg_47_1.is_owner then
		if var_47_7 then
			Managers.state.network.network_transmit:send_rpc_clients("rpc_client_despawn_light_weight_projectile", arg_47_1.owner_peer_id, arg_47_2, var_47_4)
		else
			Managers.state.network.network_transmit:send_rpc_server("rpc_client_despawn_light_weight_projectile", arg_47_1.owner_peer_id, arg_47_2, var_47_4)
		end
	elseif var_47_7 then
		Managers.state.network.network_transmit:send_rpc_clients_except("rpc_client_despawn_light_weight_projectile", arg_47_1.owner_peer_id, arg_47_1.owner_peer_id, arg_47_2, var_47_4)
	end
end

function ProjectileSystem.physics_cb_light_weight_projectile_hit(arg_48_0, arg_48_1, arg_48_2)
	if not arg_48_2 then
		return
	end

	if not Unit.alive(arg_48_1.owner_unit) then
		arg_48_0:_remove_light_weight_projectile(arg_48_0._light_weight.own_data, arg_48_1.index)

		return
	end

	if arg_48_1.projectile_list_reference then
		arg_48_0:_remove_light_weight_projectile(arg_48_1.projectile_list_reference, arg_48_1.index)
	elseif arg_48_1.husk_projectile then
		arg_48_0:_remove_light_weight_projectile(arg_48_0._light_weight.own_data, arg_48_1.index)
	else
		local var_48_0 = arg_48_1.action_data
		local var_48_1 = DamageUtils.process_projectile_hit(arg_48_0.world, arg_48_1.damage_source, arg_48_1.owner_unit, arg_48_0.is_server, arg_48_2, var_48_0, arg_48_1.direction:unbox(), false, nil, nil, false, var_48_0.power_level)

		if var_48_1.stop then
			arg_48_0:_remove_light_weight_projectile(arg_48_0._light_weight.own_data, arg_48_1.index)

			local var_48_2 = var_48_1.hit_player

			if not var_48_2 and var_48_0.projectile_linker then
				arg_48_0:_link_projectile(var_48_1, var_48_0.projectile_linker)
			end

			local var_48_3 = var_48_1.hit_unit

			if var_48_3 and var_48_2 and var_48_0.first_person_hit_flow_events and not var_48_1.shield_blocked then
				local var_48_4 = #var_48_0.first_person_hit_flow_events
				local var_48_5 = var_48_0.first_person_hit_flow_events[Math.random(var_48_4)]
				local var_48_6 = Managers.player:owner(var_48_3):network_id()
				local var_48_7 = Managers.state.unit_storage:go_id(var_48_3)
				local var_48_8 = NetworkLookup.flow_events[var_48_5]

				Managers.state.network.network_transmit:send_rpc("rpc_first_person_flow_event", var_48_6, var_48_7, var_48_8)
			end
		end
	end
end

function ProjectileSystem._redirect_shield_linking(arg_49_0, arg_49_1, arg_49_2, arg_49_3, arg_49_4)
	local var_49_0 = AiUtils.unit_breed(arg_49_1)

	if not (HEALTH_ALIVE[arg_49_1] and var_49_0 and not var_49_0.no_effects_on_shield_block and not var_49_0.is_player) then
		return arg_49_1, arg_49_2, arg_49_3
	end

	arg_49_1 = ScriptUnit.extension(arg_49_1, "ai_inventory_system").inventory_item_shield_unit

	local var_49_1 = Unit.node(arg_49_1, "c_mesh")
	local var_49_2 = Unit.world_position(arg_49_1, var_49_1) + arg_49_4
	local var_49_3 = arg_49_3 - var_49_2
	local var_49_4 = Vector3.length(var_49_3)

	arg_49_3 = var_49_2 + var_49_3 * math.min(var_49_4, 0.25)
	arg_49_2 = var_49_1

	return arg_49_1, arg_49_2, arg_49_3
end

function ProjectileSystem._link_projectile(arg_50_0, arg_50_1, arg_50_2)
	local var_50_0 = arg_50_1.hit_unit
	local var_50_1 = arg_50_1.hit_actor
	local var_50_2 = arg_50_1.hit_position
	local var_50_3 = arg_50_1.hit_direction
	local var_50_4 = arg_50_1.predicted_damage
	local var_50_5 = arg_50_1.shield_blocked
	local var_50_6 = arg_50_2.depth or 0.15
	local var_50_7 = arg_50_2.depth_offset or 0.15
	local var_50_8 = arg_50_2.unit
	local var_50_9 = true
	local var_50_10 = Unit.get_data(var_50_0, "allow_link")

	if var_50_10 ~= nil then
		var_50_9 = var_50_10
	end

	if not var_50_9 then
		return
	end

	if arg_50_2.broken_units then
		local var_50_11 = Math.random()

		if var_50_4 and not var_50_5 then
			var_50_11 = var_50_11 * math.clamp(var_50_4 / 2, 0.75, 1.25)
		else
			var_50_11 = var_50_11 * 2
		end

		if var_50_11 <= 0.5 then
			local var_50_12 = #arg_50_2.broken_units
			local var_50_13 = Math.random(1, var_50_12)

			var_50_8 = arg_50_2.broken_units[var_50_13]

			if var_50_13 == 1 then
				var_50_6 = 0.05
				var_50_7 = 0.1
			else
				var_50_7 = 0.15
			end
		end
	elseif var_50_4 and not var_50_5 then
		var_50_6 = var_50_6 * math.clamp(var_50_4, 1, 3)
	end

	if var_50_5 then
		var_50_6 = -0.1
	end

	local var_50_14 = var_50_6 + var_50_7
	local var_50_15 = Math.random() * 2.14 - 0.5
	local var_50_16 = Vector3.normalize(var_50_3)
	local var_50_17 = var_50_16 * var_50_14
	local var_50_18 = var_50_2 + var_50_17
	local var_50_19 = Quaternion.multiply(Quaternion.look(var_50_16), Quaternion(Vector3.forward(), var_50_15))
	local var_50_20 = Actor.node(var_50_1)

	if var_50_5 then
		var_50_0, var_50_20, var_50_18 = arg_50_0:_redirect_shield_linking(var_50_0, var_50_20, var_50_18, var_50_17)
	end

	local var_50_21 = NetworkLookup.husks[var_50_8]
	local var_50_22, var_50_23 = arg_50_0.network_manager:game_object_or_level_id(var_50_0)

	if not var_50_22 and var_50_23 == nil then
		return
	end

	Managers.state.network.network_transmit:send_rpc_all("rpc_spawn_and_link_units", var_50_21, var_50_18, var_50_19, var_50_22, var_50_20, var_50_23)
end

function ProjectileSystem._update_light_weight_projectiles(arg_51_0, arg_51_1, arg_51_2, arg_51_3)
	arg_51_0:_server_update_light_weight_projectiles(arg_51_1, arg_51_2, arg_51_0._light_weight.own_data)

	for iter_51_0, iter_51_1 in pairs(arg_51_0._light_weight.husk_list) do
		arg_51_0:_client_update_light_weight_projectiles(arg_51_1, arg_51_2, iter_51_1)
	end

	for iter_51_2, iter_51_3 in pairs(arg_51_0._light_weight.husk_shoot_list) do
		arg_51_0:_server_update_light_weight_projectiles(arg_51_1, arg_51_2, iter_51_3.projectile_list)
	end
end

function ProjectileSystem._print_debug(arg_52_0)
	if Development.parameter("debug_light_weight_projectiles") then
		Debug.text("Own projectiles: " .. tostring(table.size(arg_52_0._light_weight.own_data.projectiles)))
		Debug.text("Husk list: " .. tostring(table.size(arg_52_0._light_weight.husk_list)))

		local var_52_0 = 0

		for iter_52_0, iter_52_1 in pairs(arg_52_0._light_weight.husk_list) do
			var_52_0 = var_52_0 + table.size(iter_52_1.projectiles)
		end

		Debug.text("Husk projectiles: " .. tostring(var_52_0))

		local var_52_1 = 0

		for iter_52_2, iter_52_3 in pairs(arg_52_0._light_weight.husk_shoot_list) do
			var_52_1 = var_52_1 + table.size(iter_52_3.projectile_list.projectiles)
		end

		Debug.text("Local husk projectiles: " .. tostring(var_52_1))
	end
end

local var_0_27 = {}

function ProjectileSystem._server_update_light_weight_projectiles(arg_53_0, arg_53_1, arg_53_2, arg_53_3)
	local var_53_0 = arg_53_3.projectiles
	local var_53_1 = arg_53_3.current_index
	local var_53_2 = arg_53_0.world
	local var_53_3 = var_0_27

	for iter_53_0 = 1, var_53_1 do
		local var_53_4 = var_53_0[iter_53_0]

		if var_53_4.distance_moved < var_53_4.range then
			local var_53_5, var_53_6, var_53_7 = arg_53_0:_move_light_weight_projectile(arg_53_1, var_53_2, var_53_4)

			var_53_4.distance_moved = var_53_4.distance_moved + var_53_7

			var_53_4.raycast:cast(var_53_5, var_53_6, var_53_7)
		else
			var_53_3[#var_53_3 + 1] = iter_53_0
		end
	end

	table.reverse(var_53_3)

	for iter_53_1, iter_53_2 in ipairs(var_53_3) do
		arg_53_0:_remove_light_weight_projectile(arg_53_3, iter_53_2)
	end

	table.clear(var_53_3)
end

function ProjectileSystem._client_update_light_weight_projectiles(arg_54_0, arg_54_1, arg_54_2, arg_54_3)
	local var_54_0 = arg_54_3.projectiles
	local var_54_1 = arg_54_3.current_index
	local var_54_2 = arg_54_0.world

	for iter_54_0 = 1, var_54_1 do
		local var_54_3 = var_54_0[iter_54_0]

		arg_54_0:_move_light_weight_projectile(arg_54_1, var_54_2, var_54_3, debug)
	end
end

function ProjectileSystem._move_light_weight_projectile(arg_55_0, arg_55_1, arg_55_2, arg_55_3, arg_55_4)
	local var_55_0 = arg_55_3.position:unbox()
	local var_55_1 = arg_55_3.direction:unbox()
	local var_55_2 = arg_55_3.rotation:unbox()
	local var_55_3 = arg_55_3.speed * arg_55_1
	local var_55_4 = arg_55_3.gravity
	local var_55_5 = var_55_0 + var_55_1 * var_55_3

	if var_55_4 ~= 0 then
		var_55_3 = arg_55_3.flat_speed * arg_55_1
		var_55_5 = var_55_0 + var_55_1 * var_55_3
		var_55_5 = var_55_5 - Vector3(0, 0, var_55_4) * arg_55_1 * arg_55_1
		var_55_1 = Vector3.normalize(var_55_5 - var_55_0)

		arg_55_3.direction:store(var_55_1)

		var_55_2 = Quaternion.look(var_55_1, Vector3.up())

		arg_55_3.rotation:store(var_55_2)
	end

	for iter_55_0, iter_55_1 in pairs(arg_55_3.particle_settings) do
		if not iter_55_1.link then
			World.move_particles(arg_55_2, iter_55_0, var_55_5, var_55_2)
		end
	end

	for iter_55_2, iter_55_3 in pairs(arg_55_3.sound_settings) do
		WwiseWorld.set_source_position(arg_55_0._wwise_world, iter_55_2, var_55_5)
	end

	arg_55_3.position:store(var_55_5)

	return var_55_0, var_55_1, var_55_3
end
