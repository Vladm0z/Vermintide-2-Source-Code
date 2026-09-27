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

local ProjectileUnits = ProjectileUnits
local tbl = {
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
local tbl_2 = {
	"GenericImpactProjectileUnitExtension",
	"PlayerProjectileUnitExtension",
	"PlayerProjectileHuskExtension"
}
local num = 10
local num_2 = math.pi * 2

ProjectileSystem.init = function (self, arg_1_1, arg_1_2)
	-- function 1
	ProjectileSystem.super.init(self, arg_1_1, arg_1_2, tbl_2)

	local network_event_delegate = arg_1_1.network_event_delegate

	self.network_event_delegate = network_event_delegate

	network_event_delegate:register(self, unpack(tbl))

	self.network_manager = arg_1_1.network_manager
	self.player_projectile_units = {}
	self.indexed_player_projectile_units = {}
	self.owner_units_count = 0
	self._current_id = 1

	self.projectile_owner_destroy_callback = function (arg_2_0)
		-- function 2
		for k, v in pairs(self.player_projectile_units) do
			if k == arg_2_0 then
				for k_2, v_2 in pairs(v) do
					self:_remove_player_projectile_reference(k_2, k)

					if not Unit.alive(k_2) then
						Managers.state.unit_spawner:mark_for_deletion(k_2)
					end
				end
			end
		end

		self.player_projectile_units[arg_2_0] = nil
		self.owner_units_count = self.owner_units_count - 1
	end

	local max = NetworkConstants.light_weight_projectile_index.max

	self._light_weight = {
		husk_list = {},
		own_data = {
			is_owner = true,
			current_index = 0,
			projectiles = Script.new_array(max),
			max_index = max,
			owner_peer_id = Network.peer_id()
		},
		husk_shoot_list = {}
	}
	self._wwise_world = Managers.world:wwise_world(self.world)
	self._projectile_linker_system = Managers.state.entity:system("projectile_linker_system")

	local type_info = Network.type_info("rnd_seed")

	self._drone_seed_per_source = {
		min_seed = type_info.min,
		max_seed = type_info.max
	}
end

ProjectileSystem.on_add_extension = function (self, arg_3_1, arg_3_2, arg_3_3, ...)
	-- function 3
	if not self.is_server then
		Managers.level_transition_handler.transient_package_loader:add_projectile(arg_3_2)
	end

	return ExtensionSystemBase.on_add_extension(self, arg_3_1, arg_3_2, arg_3_3, ...)
end

ProjectileSystem.on_remove_extension = function (self, arg_4_1, arg_4_2)
	-- function 4
	ExtensionSystemBase.on_remove_extension(self, arg_4_1, arg_4_2)

	if not self.is_server then
		Managers.level_transition_handler.transient_package_loader:remove_projectile(arg_4_1)
	end
end

local tbl_3 = {}
local tbl_4 = {}

ProjectileSystem.update = function (self, arg_5_1, arg_5_2)
	-- function 5
	ProjectileSystem.super.update(self, arg_5_1, arg_5_2)

	local player_projectile_units = self.player_projectile_units

	for k, v in pairs(player_projectile_units) do
		for k_2, v_2 in pairs(v) do
			local alive = Unit.alive(k_2)

			if not (v_2 <= arg_5_2 or alive) then
				tbl_3[k_2] = alive
				tbl_4[k_2] = k
			end
		end
	end

	for k_3, v_3 in pairs(tbl_3) do
		local var_5_2 = tbl_4[k_3]

		self:_remove_player_projectile_reference(k_3, var_5_2)

		if not v_3 then
			Managers.state.unit_spawner:mark_for_deletion(k_3)
		end
	end

	table.clear(tbl_3)
	table.clear(tbl_4)
	self:_update_shooting(arg_5_1.dt, arg_5_2, self._light_weight.husk_shoot_list)
	self:_update_light_weight_projectiles(arg_5_1.dt, arg_5_2, self._light_weight)
	self:_update_drones(arg_5_1.dt, arg_5_2)
end

ProjectileSystem.destroy = function (self)
	-- function 6
	self.network_event_delegate:unregister(self)
end

ProjectileSystem._get_projectile_units_names = function (arg_7_0, arg_7_1, arg_7_2)
	-- function 7
	local projectile_units_template = arg_7_1.projectile_units_template

	if not arg_7_1.use_weapon_skin then
		local has_extension = ScriptUnit.has_extension(arg_7_2, "inventory_system")

		if not has_extension then
			local str = "slot_ranged"
			local get_slot_data = has_extension:get_slot_data(str)

			projectile_units_template = not get_slot_data and get_slot_data.projectile_units_template and projectile_units_template
		end
	end

	return ProjectileUnits[projectile_units_template]
end

ProjectileSystem.spawn_player_projectile = function (self, arg_8_1, arg_8_2, arg_8_3, arg_8_4, arg_8_5, arg_8_6, arg_8_7, arg_8_8, arg_8_9, arg_8_10, arg_8_11, arg_8_12, arg_8_13, arg_8_14, arg_8_15, arg_8_16)
	-- function 8
	local var_8_0 = WeaponUtils.get_weapon_template(arg_8_9).actions[arg_8_10][arg_8_11]
	local projectile_info = var_8_0.projectile_info
	local gravity_settings = projectile_info.gravity_settings

	gravity_settings = not arg_8_15 and projectile_info.gaze_override_gravity_settings and gravity_settings

	local trajectory_template_name = projectile_info.trajectory_template_name
	local linear_dampening = projectile_info.linear_dampening
	local rotation_speed = projectile_info.rotation_speed

	rotation_speed = rotation_speed or 0

	local rotation_offset = projectile_info.rotation_offset

	arg_8_4 = arg_8_4 / 100

	local radius_min = projectile_info.radius_min
	local radius_max = projectile_info.radius_max
	local radius = projectile_info.radius

	if not radius then
		if not radius_min and not radius_max then
			radius = math.lerp(projectile_info.radius_min, projectile_info.radius_max, arg_8_4)

			if not radius then
				-- Nothing
			end
		end

		radius = nil
	end

	do
		local generate_seed
	end

	::label_8_0::

	if not var_8_0.generate_seed then
		generate_seed = var_8_0.generate_seed()

		if not generate_seed then
			-- Nothing
		end
	end

	generate_seed = nil

	::label_8_1::

	local time = Managers.time:time("game")
	local tbl = {
		projectile_locomotion_system = {
			angle = arg_8_5,
			speed = arg_8_7,
			seed = generate_seed,
			initial_position = arg_8_2,
			target_vector = arg_8_6,
			gravity_settings = gravity_settings,
			linear_dampening = linear_dampening,
			trajectory_template_name = trajectory_template_name,
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
			rotation_speed = rotation_speed,
			rotation_offset = rotation_offset
		},
		projectile_impact_system = {
			item_name = arg_8_8,
			item_template_name = arg_8_9,
			action_name = arg_8_10,
			sub_action_name = arg_8_11,
			owner_unit = arg_8_1,
			radius = radius
		},
		projectile_system = {
			item_name = arg_8_8,
			item_template_name = arg_8_9,
			action_name = arg_8_10,
			sub_action_name = arg_8_11,
			owner_unit = arg_8_1,
			time_initialized = time,
			scale = arg_8_4,
			fast_forward_time = arg_8_12,
			is_critical_strike = arg_8_13,
			power_level = arg_8_14,
			charge_level = arg_8_16
		}
	}
	local projectile_unit_name = self:_get_projectile_units_names(projectile_info, arg_8_1).projectile_unit_name
	local unit_spawner = Managers.state.unit_spawner
	local var_8_15 = unit_spawner
	local spawn_network_unit = unit_spawner.spawn_network_unit
	local var_8_17 = projectile_unit_name
	local projectile_unit_template_name = projectile_info.projectile_unit_template_name

	projectile_unit_template_name = projectile_unit_template_name or "player_projectile_unit"

	local var_8_19 = spawn_network_unit(var_8_15, var_8_17, projectile_unit_template_name, tbl, arg_8_2, arg_8_3)

	self:_add_player_projectile_reference(arg_8_1, var_8_19, projectile_info)
	Managers.state.achievement:trigger_event("on_player_projectile_spawned", var_8_19, arg_8_1, arg_8_9)
end

ProjectileSystem.spawn_globadier_globe = function (self, arg_9_1, arg_9_2, arg_9_3, arg_9_4, arg_9_5, arg_9_6, arg_9_7, arg_9_8, arg_9_9, arg_9_10, arg_9_11, arg_9_12, arg_9_13, arg_9_14, arg_9_15)
	-- function 9
	if not self.is_server then
		local flag

		flag = not arg_9_13 and "bot_poison_wind" and nil

		local flag_2 = Managers.mechanism:current_mechanism_name() == "versus"

		if not arg_9_14 then
			local tbl = {}
			local tbl_2 = {
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
				life_time = arg_9_7
			}
			local flag_3

			flag_3 = not flag_2 and "globadier_area_dot_damage_vs" and "globadier_area_dot_damage"
			tbl_2.area_damage_template = flag_3
			tbl_2.damage_source = arg_9_9
			tbl_2.create_nav_tag_volume = arg_9_13
			tbl_2.nav_tag_volume_layer = flag
			tbl_2.source_attacker_unit = arg_9_8
			tbl_2.threat_duration = arg_9_7
			tbl.area_damage_system = tbl_2

			local str = "units/weapons/projectile/poison_wind_globe/poison_wind_globe"
			local spawn_network_unit = Managers.state.unit_spawner:spawn_network_unit(str, "aoe_unit", tbl, arg_9_1)
			local go_id = Managers.state.unit_storage:go_id(spawn_network_unit)

			Unit.set_unit_visibility(spawn_network_unit, false)
			Managers.state.network.network_transmit:send_rpc_all("rpc_area_damage", go_id, arg_9_1)
		else
			local tbl_3 = {
				projectile_locomotion_system = {
					trajectory_template_name = "throw_trajectory",
					angle = arg_9_3,
					speed = arg_9_4,
					target_vector = arg_9_2,
					initial_position = arg_9_1
				}
			}
			local tbl_4 = {
				damage_source = arg_9_9
			}
			local flag_4

			flag_4 = not flag_2 and "vs_globadier_impact" and "explosion_impact"
			tbl_4.impact_template_name = flag_4
			tbl_4.owner_unit = arg_9_8
			tbl_3.projectile_system = tbl_4

			local tbl_5 = {
				invisible_unit = false,
				player_screen_effect_name = "fx/screenspace_poison_globe_impact",
				area_ai_random_death_template = "area_poison_ai_random_death",
				damage_players = true,
				aoe_dot_damage = arg_9_10,
				aoe_init_damage = arg_9_11,
				aoe_dot_damage_interval = arg_9_12,
				radius = arg_9_6,
				initial_radius = arg_9_5,
				life_time = arg_9_7
			}
			local flag_5

			flag_5 = not flag_2 and "fx/wpnfx_poison_wind_globe_impact_vs" and "fx/wpnfx_poison_wind_globe_impact"
			tbl_5.dot_effect_name = flag_5

			local flag_6

			flag_6 = not flag_2 and "globadier_area_dot_damage_vs" and "globadier_area_dot_damage"
			tbl_5.area_damage_template = flag_6
			tbl_5.damage_source = arg_9_9
			tbl_5.create_nav_tag_volume = arg_9_13
			tbl_5.nav_tag_volume_layer = flag
			tbl_5.source_attacker_unit = arg_9_8
			tbl_5.owner_player = Managers.player:owner(arg_9_8)
			tbl_5.threat_duration = arg_9_7
			tbl_3.area_damage_system = tbl_5

			local var_9_14
			local str_2

			if not arg_9_15 then
				tbl_3.projectile_impact_system = {
					owner_unit = arg_9_8,
					impact_data = arg_9_15
				}
				str_2 = "aoe_projectile_unit_fixed_impact"
			else
				tbl_3.projectile_impact_system = {
					server_side_raycast = true,
					collision_filter = "filter_enemy_ray_projectile",
					owner_unit = arg_9_8
				}
				str_2 = "aoe_projectile_unit"
			end

			local str_3 = "units/weapons/projectile/poison_wind_globe/poison_wind_globe"

			Managers.state.unit_spawner:spawn_network_unit(str_3, str_2, tbl_3, arg_9_1)
		end
	else
		local go_id_2 = self.unit_storage:go_id(arg_9_8)
		local var_9_18 = NetworkLookup.damage_sources[arg_9_9]
		local var_9_19
		local var_9_20

		if not arg_9_15 then
			local hit_unit = arg_9_15.hit_unit

			var_9_20 = self.network_manager:level_object_id(hit_unit)
			var_9_19 = var_9_20 ~= nil
		end

		if not var_9_19 then
			print("fixed impact!")

			local unbox = arg_9_15.position:unbox()
			local unbox_2 = arg_9_15.direction:unbox()
			local unbox_3 = arg_9_15.hit_normal:unbox()
			local actor_index = arg_9_15.actor_index
			local time = arg_9_15.time

			self.network_transmit:send_rpc_server("rpc_spawn_globadier_globe_fixed_impact", arg_9_1, arg_9_2, arg_9_3, arg_9_4, arg_9_5, arg_9_6, arg_9_7, go_id_2, var_9_18, arg_9_10, arg_9_11, arg_9_12, arg_9_13, arg_9_14, var_9_20, unbox, unbox_2, unbox_3, actor_index, time)
		else
			print("Standard impact!")
			self.network_transmit:send_rpc_server("rpc_spawn_globadier_globe", arg_9_1, arg_9_2, arg_9_3, arg_9_4, arg_9_5, arg_9_6, arg_9_7, go_id_2, var_9_18, arg_9_10, arg_9_11, arg_9_12, arg_9_13, arg_9_14)
		end
	end
end

ProjectileSystem.rpc_spawn_globadier_globe = function (self, arg_10_1, arg_10_2, arg_10_3, arg_10_4, arg_10_5, arg_10_6, arg_10_7, arg_10_8, arg_10_9, arg_10_10, arg_10_11, arg_10_12, arg_10_13, arg_10_14, arg_10_15)
	-- function 10
	fassert(self.is_server, "Have to be server")

	local unit = self.unit_storage:unit(arg_10_9)
	local var_10_1 = NetworkLookup.damage_sources[arg_10_10]

	self:spawn_globadier_globe(arg_10_2, arg_10_3, arg_10_4, arg_10_5, arg_10_6, arg_10_7, arg_10_8, unit, var_10_1, arg_10_11, arg_10_12, arg_10_13, arg_10_14, arg_10_15)
end

ProjectileSystem.rpc_spawn_globadier_globe_fixed_impact = function (self, arg_11_1, arg_11_2, arg_11_3, arg_11_4, arg_11_5, arg_11_6, arg_11_7, arg_11_8, arg_11_9, arg_11_10, arg_11_11, arg_11_12, arg_11_13, arg_11_14, arg_11_15, arg_11_16, arg_11_17, arg_11_18, arg_11_19, arg_11_20, arg_11_21)
	-- function 11
	fassert(self.is_server, "Have to be server")

	local game_object_or_level_unit = Managers.state.network:game_object_or_level_unit(arg_11_16, true)

	if not Unit.alive(game_object_or_level_unit) then
		self:rpc_spawn_globadier_globe(arg_11_1, arg_11_2, arg_11_3, arg_11_4, arg_11_5, arg_11_6, arg_11_7, arg_11_8, arg_11_9, arg_11_10, arg_11_11, arg_11_12, arg_11_13, arg_11_14, arg_11_15)

		return
	end

	local unit = self.unit_storage:unit(arg_11_9)
	local var_11_2 = NetworkLookup.damage_sources[arg_11_10]
	local tbl = {
		position = Vector3Box(arg_11_17),
		direction = Vector3Box(arg_11_18),
		hit_unit = game_object_or_level_unit,
		actor_index = arg_11_20,
		hit_normal = Vector3Box(arg_11_19),
		time = arg_11_21
	}

	self:spawn_globadier_globe(arg_11_2, arg_11_3, arg_11_4, arg_11_5, arg_11_6, arg_11_7, arg_11_8, unit, var_11_2, arg_11_11, arg_11_12, arg_11_13, arg_11_14, arg_11_15, tbl)
end

ProjectileSystem.rpc_projectile_stopped = function (self, arg_12_1, arg_12_2)
	-- function 12
	local unit = self.unit_storage:unit(arg_12_2)

	ScriptUnit.extension(unit, "projectile_locomotion_system"):stop()
end

ProjectileSystem.rpc_drop_projectile = function (self, arg_13_1, arg_13_2)
	-- function 13
	local unit = self.unit_storage:unit(arg_13_2)

	ScriptUnit.extension(unit, "projectile_locomotion_system"):drop()
end

ProjectileSystem.rpc_projectile_event = function (self, arg_14_1, arg_14_2, arg_14_3)
	-- function 14
	local unit = self.unit_storage:unit(arg_14_2)
	local extension = ScriptUnit.extension(unit, "projectile_system")
	local var_14_2 = NetworkLookup.projectile_external_event[arg_14_3]

	extension:trigger_external_event(var_14_2)

	if not self.is_server then
		local var_14_3 = CHANNEL_TO_PEER_ID[arg_14_1]

		Managers.state.network.network_transmit:send_rpc_clients_except("rpc_projectile_event", var_14_3, arg_14_2, arg_14_3)
	end
end

ProjectileSystem.rpc_spawn_pickup_projectile = function (arg_15_0, arg_15_1, arg_15_2, arg_15_3, arg_15_4, arg_15_5, arg_15_6, arg_15_7, arg_15_8, arg_15_9, arg_15_10, arg_15_11, arg_15_12, arg_15_13)
	-- function 15
	if not Managers.state.network:game() then
		return
	end

	local var_15_0

	if not arg_15_1 then
		var_15_0 = CHANNEL_TO_PEER_ID[arg_15_1]

		if not var_15_0 then
			-- Nothing
		end
	end

	var_15_0 = Network.peer_id()

	::label_15_0::

	local var_15_1 = NetworkLookup.husks[arg_15_2]
	local var_15_2 = NetworkLookup.go_types[arg_15_3]
	local var_15_3 = NetworkLookup.pickup_names[arg_15_8]
	local var_15_4 = NetworkLookup.pickup_spawn_types[arg_15_9]
	local var_15_5 = NetworkLookup.material_settings_templates[arg_15_13]
	local tbl = {
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
	local position_network_scale = AiAnimUtils.position_network_scale(arg_15_4)
	local rotation_network_scale = AiAnimUtils.rotation_network_scale(arg_15_5)
	local var_15_9 = AllPickups[var_15_3]
	local var_15_10
	local spawn_override_func = var_15_9.spawn_override_func

	if not spawn_override_func then
		var_15_10 = spawn_override_func(var_15_9, tbl, position_network_scale, rotation_network_scale)
	else
		var_15_10 = Managers.state.unit_spawner:spawn_network_unit(var_15_1, var_15_2, tbl, position_network_scale, rotation_network_scale)
	end

	if not arg_15_12 then
		ScriptUnit.extension(var_15_10, "tutorial_system"):set_active(true)
	end
end

ProjectileSystem.rpc_spawn_pickup_projectile_limited = function (self, arg_16_1, arg_16_2, arg_16_3, arg_16_4, arg_16_5, arg_16_6, arg_16_7, arg_16_8, arg_16_9, arg_16_10, arg_16_11, arg_16_12, arg_16_13)
	-- function 16
	if not Managers.state.network:game() then
		return
	end

	local var_16_0 = CHANNEL_TO_PEER_ID[arg_16_1]

	var_16_0 = var_16_0 or Network.peer_id()

	local var_16_1 = NetworkLookup.husks[arg_16_2]
	local var_16_2 = NetworkLookup.go_types[arg_16_3]
	local var_16_3 = NetworkLookup.pickup_names[arg_16_8]
	local var_16_4 = NetworkLookup.pickup_spawn_types[arg_16_11]
	local current_level = LevelHelper:current_level(self.world)
	local unit_by_index = Level.unit_by_index(current_level, arg_16_9)
	local tbl = {
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
			spawner_unit = unit_by_index,
			id = arg_16_10
		},
		tutorial_system = {
			always_show = arg_16_12
		}
	}
	local position_network_scale = AiAnimUtils.position_network_scale(arg_16_4)
	local rotation_network_scale = AiAnimUtils.rotation_network_scale(arg_16_5)
	local spawn_network_unit = Managers.state.unit_spawner:spawn_network_unit(var_16_1, var_16_2, tbl, position_network_scale, rotation_network_scale)

	if not arg_16_13 then
		ScriptUnit.extension(spawn_network_unit, "tutorial_system"):set_active(true)
	end
end

ProjectileSystem.rpc_spawn_explosive_pickup_projectile = function (arg_17_0, arg_17_1, arg_17_2, arg_17_3, arg_17_4, arg_17_5, arg_17_6, arg_17_7, arg_17_8, arg_17_9, arg_17_10, arg_17_11, arg_17_12, arg_17_13, arg_17_14, arg_17_15, arg_17_16)
	-- function 17
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

	local tbl = {
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
	local position_network_scale = AiAnimUtils.position_network_scale(arg_17_4)
	local rotation_network_scale = AiAnimUtils.rotation_network_scale(arg_17_5)
	local spawn_network_unit = Managers.state.unit_spawner:spawn_network_unit(var_17_0, var_17_1, tbl, position_network_scale, rotation_network_scale)

	if not arg_17_16 then
		ScriptUnit.extension(spawn_network_unit, "tutorial_system"):set_active(true)
	end
end

ProjectileSystem.rpc_spawn_explosive_pickup_projectile_limited = function (self, arg_18_1, arg_18_2, arg_18_3, arg_18_4, arg_18_5, arg_18_6, arg_18_7, arg_18_8, arg_18_9, arg_18_10, arg_18_11, arg_18_12, arg_18_13, arg_18_14, arg_18_15, arg_18_16, arg_18_17, arg_18_18)
	-- function 18
	if not Managers.state.network:game() then
		return
	end

	local var_18_0 = NetworkLookup.husks[arg_18_2]
	local var_18_1 = NetworkLookup.go_types[arg_18_3]
	local var_18_2 = NetworkLookup.pickup_names[arg_18_8]
	local current_level = LevelHelper:current_level(self.world)
	local unit_by_index = Level.unit_by_index(current_level, arg_18_9)
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

	local tbl = {
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
			spawner_unit = unit_by_index,
			id = arg_18_10
		},
		tutorial_system = {
			always_show = arg_18_17
		}
	}
	local position_network_scale = AiAnimUtils.position_network_scale(arg_18_4)
	local rotation_network_scale = AiAnimUtils.rotation_network_scale(arg_18_5)
	local spawn_network_unit = Managers.state.unit_spawner:spawn_network_unit(var_18_0, var_18_1, tbl, position_network_scale, rotation_network_scale)

	if not arg_18_18 then
		ScriptUnit.extension(spawn_network_unit, "tutorial_system"):set_active(true)
	end
end

ProjectileSystem.spawn_true_flight_projectile = function (self, arg_19_1, arg_19_2, arg_19_3, arg_19_4, arg_19_5, arg_19_6, arg_19_7, arg_19_8, arg_19_9, arg_19_10, arg_19_11, arg_19_12, arg_19_13, arg_19_14, arg_19_15)
	-- function 19
	local projectile_info = WeaponUtils.get_weapon_template(arg_19_10).actions[arg_19_11][arg_19_12].projectile_info
	local gravity_settings = projectile_info.gravity_settings
	local trajectory_template_name = projectile_info.trajectory_template_name
	local radius_min = projectile_info.radius_min
	local radius_max = projectile_info.radius_max
	local radius = projectile_info.radius

	if not radius then
		if not radius_min and not radius_max then
			radius = math.lerp(projectile_info.radius_min, projectile_info.radius_max, arg_19_13)

			if not radius then
				-- Nothing
			end
		end

		radius = nil
	end

	::label_19_0::

	local tbl = {
		projectile_locomotion_system = {
			angle = arg_19_6,
			speed = arg_19_8,
			gravity_settings = gravity_settings,
			trajectory_template_name = trajectory_template_name,
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
			radius = radius
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
	local projectile_unit_name = self:_get_projectile_units_names(projectile_info, arg_19_1).projectile_unit_name
	local spawn_network_unit = Managers.state.unit_spawner:spawn_network_unit(projectile_unit_name, "true_flight_projectile_unit", tbl, arg_19_4, arg_19_5)

	self:_add_player_projectile_reference(arg_19_1, spawn_network_unit, projectile_info)
end

ProjectileSystem.spawn_ai_true_flight_projectile = function (self, arg_20_1, arg_20_2, arg_20_3, arg_20_4, arg_20_5, arg_20_6, arg_20_7, arg_20_8, arg_20_9, arg_20_10, arg_20_11, arg_20_12, arg_20_13)
	-- function 20
	local gravity_settings = arg_20_9.gravity_settings
	local trajectory_template_name = arg_20_9.trajectory_template_name
	local var_20_2 = TrueFlightTemplates[arg_20_3]
	local dont_target_friendly = var_20_2.dont_target_friendly
	local dont_target_patrols = var_20_2.dont_target_patrols
	local ignore_dead = var_20_2.ignore_dead
	local radius_min = arg_20_9.radius_min
	local radius_max = arg_20_9.radius_max
	local radius = arg_20_9.radius

	if not radius then
		if not radius_min and not radius_max then
			radius = math.lerp(arg_20_9.radius_min, arg_20_9.radius_max, arg_20_11)

			if not radius then
				-- Nothing
			end
		end

		radius = nil
	end

	::label_20_0::

	local tbl = {
		projectile_locomotion_system = {
			angle = arg_20_6,
			speed = arg_20_8,
			gravity_settings = gravity_settings,
			trajectory_template_name = trajectory_template_name,
			initial_position = arg_20_4,
			target_vector = arg_20_7,
			true_flight_template_name = arg_20_3,
			target_unit = arg_20_2,
			owner_unit = arg_20_1
		},
		projectile_impact_system = {
			owner_unit = arg_20_1,
			radius = radius,
			dont_target_friendly = dont_target_friendly,
			dont_target_patrols = dont_target_patrols,
			ignore_dead = ignore_dead
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
	local projectile_unit_name = self:_get_projectile_units_names(arg_20_9, arg_20_1).projectile_unit_name
	local projectile_unit_template_name = arg_20_9.projectile_unit_template_name

	projectile_unit_template_name = projectile_unit_template_name or "ai_true_flight_projectile_unit"

	local spawn_network_unit = Managers.state.unit_spawner:spawn_network_unit(projectile_unit_name, projectile_unit_template_name, tbl, arg_20_4, arg_20_5)

	self:_add_player_projectile_reference(arg_20_1, spawn_network_unit, arg_20_9)
end

ProjectileSystem._add_player_projectile_reference = function (self, arg_21_1, arg_21_2, arg_21_3)
	-- function 21
	local time = Managers.time:time("game")

	if not self.player_projectile_units[arg_21_1] then
		self.player_projectile_units[arg_21_1] = {}
		self.owner_units_count = self.owner_units_count + 1

		Managers.state.unit_spawner:add_destroy_listener(arg_21_1, "projectile_owner_" .. self.owner_units_count, self.projectile_owner_destroy_callback)
	end

	local var_21_1 = self.player_projectile_units[arg_21_1]
	local unit_life_time = arg_21_3.unit_life_time

	unit_life_time = unit_life_time or num
	var_21_1[arg_21_2] = time + unit_life_time

	if not arg_21_3.indexed then
		if not self.indexed_player_projectile_units[arg_21_1] then
			self.indexed_player_projectile_units[arg_21_1] = {}
		end

		self.indexed_player_projectile_units[arg_21_1][#self.indexed_player_projectile_units[arg_21_1] + 1] = arg_21_2
	end
end

ProjectileSystem._remove_player_projectile_reference = function (self, arg_22_1, arg_22_2)
	-- function 22
	for k, v in pairs(self.player_projectile_units) do
		v[arg_22_1] = nil
	end

	local var_22_0 = self.indexed_player_projectile_units[arg_22_2]

	if not var_22_0 then
		local find = table.find(var_22_0, arg_22_1)

		if not find then
			table.remove(var_22_0, find)
		end
	end
end

ProjectileSystem.get_indexed_projectile_count = function (self, arg_23_1)
	-- function 23
	local var_23_0 = self.indexed_player_projectile_units[arg_23_1]

	if not var_23_0 then
		return 0
	end

	return #var_23_0
end

ProjectileSystem.get_and_delete_indexed_projectile = function (self, arg_24_1, arg_24_2, arg_24_3)
	-- function 24
	local var_24_0 = self.indexed_player_projectile_units[arg_24_1]

	if not var_24_0 then
		return nil
	end

	local unit_spawner = Managers.state.unit_spawner
	local remove = table.remove(var_24_0, arg_24_2)
	local flag = not remove and Unit.alive(remove)

	if not flag and not flag and not unit_spawner:is_marked_for_deletion(remove) then
		return nil
	end

	for k, v in pairs(self.player_projectile_units) do
		v[remove] = nil
	end

	if not (not Unit.alive(remove) and unit_spawner:is_marked_for_deletion(remove) or arg_24_3) then
		unit_spawner:mark_for_deletion(remove)
	end

	return remove
end

ProjectileSystem.delete_indexed_projectiles = function (self, arg_25_1)
	-- function 25
	local var_25_0 = self.indexed_player_projectile_units[arg_25_1]

	if not var_25_0 then
		return
	end

	local unit_spawner = Managers.state.unit_spawner
	local var_25_2 = self.player_projectile_units[arg_25_1]

	for i = 1, #var_25_0 do
		local var_25_3 = var_25_0[i]

		if not var_25_3 then
			if not Unit.alive(var_25_3) then
				unit_spawner:mark_for_deletion(var_25_3)
			end

			if not var_25_2 then
				var_25_2[var_25_3] = nil
			end
		end
	end

	self.indexed_player_projectile_units[arg_25_1] = nil
end

ProjectileSystem.rpc_generic_impact_projectile_impact = function (self, arg_26_1, arg_26_2, arg_26_3, arg_26_4, arg_26_5, arg_26_6, arg_26_7, arg_26_8, arg_26_9)
	-- function 26
	if not self.is_server then
		local var_26_0 = CHANNEL_TO_PEER_ID[arg_26_1]

		Managers.state.network.network_transmit:send_rpc_clients_except("rpc_generic_impact_projectile_impact", var_26_0, arg_26_2, arg_26_3, arg_26_4, arg_26_5, arg_26_6, arg_26_7, arg_26_8, arg_26_9)
	end

	local unit_storage = self.unit_storage
	local unit = unit_storage:unit(arg_26_2)
	local var_26_3

	if arg_26_3 == NetworkConstants.game_object_id_max then
		local current_level = LevelHelper:current_level(self.world)

		var_26_3 = Level.unit_by_index(current_level, arg_26_4)
	else
		var_26_3 = unit_storage:unit(arg_26_3)
	end

	if not Unit.alive(var_26_3) then
		return
	end

	if not self.bufferd_impacts then
		self.bufferd_impacts = {}
	end

	self.bufferd_impacts[var_26_3] = {
		var_26_3,
		Vector3Box(arg_26_5),
		Vector3Box(arg_26_6),
		Vector3Box(arg_26_7),
		arg_26_8
	}

	local num

	if not self.impact_buffer_counter then
		num = self.impact_buffer_counter + 1

		if not num then
			-- Nothing
		end
	end

	num = 1

	::label_26_0::

	self.impact_buffer_counter = num

	if arg_26_9 <= self.impact_buffer_counter then
		local num_2 = 0

		for k, v in pairs(self.bufferd_impacts) do
			if not Unit.alive(k) then
				num_2 = num_2 + 1

				local actor = Unit.actor(k, v[ProjectileImpactDataIndex.ACTOR_INDEX])

				ScriptUnit.extension(unit, "projectile_system"):impact(k, v[ProjectileImpactDataIndex.POSITION]:unbox(), v[ProjectileImpactDataIndex.DIRECTION]:unbox(), v[ProjectileImpactDataIndex.NORMAL]:unbox(), actor, num_2)
			end
		end

		self.bufferd_impacts = nil
		self.impact_buffer_counter = 0
	end
end

ProjectileSystem.rpc_generic_impact_projectile_force_impact = function (self, arg_27_1, arg_27_2, arg_27_3)
	-- function 27
	if not self.is_server then
		local var_27_0 = CHANNEL_TO_PEER_ID[arg_27_1]

		Managers.state.network.network_transmit:send_rpc_clients_except("rpc_generic_impact_projectile_force_impact", var_27_0, arg_27_2, arg_27_3)
	end

	local unit = self.unit_storage:unit(arg_27_2)

	ScriptUnit.extension(unit, "projectile_system"):force_impact(unit, arg_27_3)
end

ProjectileSystem.rpc_player_projectile_impact_level = function (self, arg_28_1, arg_28_2, arg_28_3, arg_28_4, arg_28_5, arg_28_6, arg_28_7)
	-- function 28
	if not self.is_server then
		local var_28_0 = CHANNEL_TO_PEER_ID[arg_28_1]

		Managers.state.network.network_transmit:send_rpc_clients_except("rpc_player_projectile_impact_level", var_28_0, arg_28_2, arg_28_3, arg_28_4, arg_28_5, arg_28_6, arg_28_7)
	end

	local current_level = LevelHelper:current_level(self.world)
	local unit_by_index = Level.unit_by_index(current_level, arg_28_3)
	local unit = self.unit_storage:unit(arg_28_2)

	if not unit_by_index then
		local actor = Unit.actor(unit_by_index, arg_28_7)

		ScriptUnit.extension(unit, "projectile_system"):impact_level(unit_by_index, arg_28_4, arg_28_5, arg_28_6, actor, arg_28_3)
	end
end

ProjectileSystem.rpc_player_projectile_impact_dynamic = function (self, arg_29_1, arg_29_2, arg_29_3, arg_29_4, arg_29_5, arg_29_6, arg_29_7)
	-- function 29
	if not self.is_server then
		local var_29_0 = CHANNEL_TO_PEER_ID[arg_29_1]

		Managers.state.network.network_transmit:send_rpc_clients_except("rpc_player_projectile_impact_dynamic", var_29_0, arg_29_2, arg_29_3, arg_29_4, arg_29_5, arg_29_6, arg_29_7)
	end

	local unit_storage = self.unit_storage
	local unit = unit_storage:unit(arg_29_2)
	local unit_2 = unit_storage:unit(arg_29_3)

	if not unit_2 then
		local actor = Unit.actor(unit_2, arg_29_7)

		ScriptUnit.extension(unit, "projectile_system"):impact_dynamic(unit_2, arg_29_4, arg_29_5, arg_29_6, actor)
	end
end

ProjectileSystem.create_light_weight_projectile = function (self, arg_30_1, arg_30_2, arg_30_3, arg_30_4, arg_30_5, arg_30_6, arg_30_7, arg_30_8, arg_30_9, arg_30_10, arg_30_11, arg_30_12, arg_30_13, arg_30_14, arg_30_15, arg_30_16, arg_30_17)
	-- function 30
	local world = self.world
	local is_server = self.is_server
	local look = Quaternion.look(arg_30_4, Vector3.up())
	local flag = not arg_30_13
	local var_30_4
	local var_30_5 = arg_30_17

	if not arg_30_16 then
		var_30_4 = arg_30_16
	elseif not flag then
		var_30_4 = self._light_weight.own_data
		var_30_5 = self._current_id
		self._current_id = 1 + self._current_id % 65535
	else
		local var_30_6 = self._light_weight.husk_list[arg_30_12]

		if not var_30_6 then
			local max = NetworkConstants.light_weight_projectile_index.max

			var_30_6 = {
				is_owner = false,
				current_index = 0,
				projectiles = Script.new_array(max),
				max_index = max,
				owner_peer_id = arg_30_12
			}
			self._light_weight.husk_list[arg_30_12] = var_30_6
		end

		var_30_4 = var_30_6
	end

	local num = var_30_4.current_index + 1
	local max_index = var_30_4.max_index

	if max_index < num then
		if not arg_30_14 then
			assert(is_server, "Client trying to spawn more projectiles light weight projectiles than there's room for.")
		end

		self:_remove_light_weight_projectile(var_30_4, Math.random(1, max_index))

		num = max_index
	end

	local tbl = {
		damage_source = arg_30_1,
		position = Vector3Box(arg_30_3),
		direction = Vector3Box(arg_30_4),
		rotation = QuaternionBox(look),
		speed = arg_30_5,
		flat_speed = arg_30_7 or 0,
		index = num,
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
	local flag_2 = not var_30_11 and var_30_11.vfx

	if not flag_2 then
		for i = 1, #flag_2 do
			local var_30_13 = flag_2[i]
			local condition_function = var_30_13.condition_function

			if not condition_function and not condition_function(arg_30_2) then
				local var_30_15
				local particle_name = var_30_13.particle_name
				local link = var_30_13.link

				if not link then
					local unit_function = var_30_13.unit_function(arg_30_2)
					local node = Unit.node(unit_function, link)

					var_30_15 = ScriptWorld.create_particles_linked(world, particle_name, unit_function, node, "destroy")
				else
					var_30_15 = World.create_particles(world, particle_name, arg_30_3, look)
				end

				tbl.particle_settings[var_30_15] = var_30_13
			end
		end
	end

	local flag_3 = not var_30_11 and var_30_11.sfx

	if not flag_3 then
		for j = 1, #flag_3 do
			local var_30_21 = flag_3[j]
			local looping_sound_event_name = var_30_21.looping_sound_event_name
			local make_manual_source = WwiseWorld.make_manual_source(self._wwise_world, arg_30_3)

			WwiseWorld.trigger_event(self._wwise_world, looping_sound_event_name, make_manual_source)

			tbl.sound_settings[make_manual_source] = var_30_21
		end
	end

	if not flag then
		local var_30_24 = callback(self, "physics_cb_light_weight_projectile_hit", tbl)
		local get_data = World.get_data(world, "physics_world")

		tbl.raycast = PhysicsWorld.make_raycast(get_data, var_30_24, "all", "types", "both", "collision_filter", arg_30_9)
		tbl.distance_moved = 0
		tbl.range = arg_30_8
		tbl.action_data = arg_30_10
		tbl.owner_unit = arg_30_2
		tbl.effect_name = arg_30_11

		local light_weight_projectile_speed = NetworkConstants.light_weight_projectile_speed
		local min = light_weight_projectile_speed.min
		local max_2 = light_weight_projectile_speed.max

		fassert(not (min <= arg_30_5) or arg_30_5 <= max_2, "Trying to create particle with speed (%i) outside of global.network_config bounds (%i:%i), raise \"light_weight_projectile_speed\" max.", arg_30_5, min, max_2)

		local game_object_or_level_id, var_30_30 = self.network_manager:game_object_or_level_id(arg_30_2)

		if not arg_30_14 then
			if not self.is_server then
				self.network_transmit:send_rpc_clients("rpc_client_spawn_light_weight_projectile", NetworkLookup.damage_sources[arg_30_1], game_object_or_level_id, arg_30_3, arg_30_4, arg_30_5, arg_30_6 or 0, arg_30_7 or 0, NetworkLookup.light_weight_projectile_effects[arg_30_11], var_30_30, arg_30_12, tbl.identifier)
			else
				self.network_transmit:send_rpc_server("rpc_client_spawn_light_weight_projectile", NetworkLookup.damage_sources[arg_30_1], game_object_or_level_id, arg_30_3, arg_30_4, arg_30_5, arg_30_6 or 0, arg_30_7 or 0, NetworkLookup.light_weight_projectile_effects[arg_30_11], var_30_30, arg_30_12, tbl.identifier)
			end
		end
	elseif not (not self.is_server and arg_30_14) then
		local game_object_or_level_id_2, var_30_32 = self.network_manager:game_object_or_level_id(arg_30_2)

		self.network_transmit:send_rpc_clients_except("rpc_client_spawn_light_weight_projectile", arg_30_12, NetworkLookup.damage_sources[arg_30_1], game_object_or_level_id_2, arg_30_3, arg_30_4, arg_30_5, arg_30_6 or 0, arg_30_7 or 0, NetworkLookup.light_weight_projectile_effects[arg_30_11], var_30_32, arg_30_12, tbl.identifier)
	end

	var_30_4.projectiles[num] = tbl
	var_30_4.current_index = num
end

ProjectileSystem.hot_join_sync = function (self, arg_31_1)
	-- function 31
	ProjectileSystem.super.hot_join_sync(self, arg_31_1)

	local network = Managers.state.network
	local network_transmit = network.network_transmit
	local own_data = self._light_weight.own_data
	local projectiles = own_data.projectiles
	local owner_peer_id = own_data.owner_peer_id

	for i = 1, own_data.current_index do
		local var_31_5 = projectiles[i]
		local unbox = var_31_5.position:unbox()
		local unbox_2 = var_31_5.direction:unbox()
		local speed = var_31_5.speed
		local effect_name = var_31_5.effect_name
		local gravity = var_31_5.gravity
		local flat_speed = var_31_5.flat_speed
		local skip_rpc = var_31_5.skip_rpc
		local identifier = var_31_5.identifier

		if not skip_rpc then
			local game_object_or_level_id, var_31_15 = network:game_object_or_level_id(var_31_5.owner_unit)

			network_transmit:send_rpc("rpc_client_spawn_light_weight_projectile", arg_31_1, NetworkLookup.damage_sources[var_31_5.damage_source], game_object_or_level_id, unbox, unbox_2, speed, gravity, flat_speed, NetworkLookup.light_weight_projectile_effects[effect_name], var_31_15, owner_peer_id, identifier)
		end
	end
end

ProjectileSystem.rpc_clients_continuous_shoot_start = function (arg_32_0, arg_32_1, arg_32_2, arg_32_3, arg_32_4, arg_32_5, arg_32_6, arg_32_7)
	-- function 32
	local game_object_or_level_unit = Managers.state.network:game_object_or_level_unit(arg_32_2, arg_32_3)
	local var_32_1 = NetworkLookup.breeds[arg_32_4]
	local var_32_2 = Breeds[var_32_1]
	local default_inventory_template = var_32_2.default_inventory_template
	local get_unit = ScriptUnit.extension(game_object_or_level_unit, "ai_inventory_system"):get_unit(default_inventory_template)
	local time = Managers.time:time("game")
	local var_32_6 = NetworkLookup.bt_action_names[arg_32_5]
	local var_32_7 = BreedActions[var_32_1][var_32_6]
	local light_weight_projectile_template_name = var_32_7.light_weight_projectile_template_name
	local var_32_9 = LightWeightProjectiles[light_weight_projectile_template_name]
	local num = 1 / var_32_7.fire_rate_at_start
	local num_2 = 1 / var_32_7.fire_rate_at_end
	local num_3 = 1 / var_32_7.max_fire_rate_at_percentage
	local max = NetworkConstants.light_weight_projectile_index.max

	arg_32_0._light_weight.husk_shoot_list[arg_32_2] = {
		shots_fired = 0,
		owner_unit = game_object_or_level_unit,
		owner_unit_id = arg_32_2,
		light_weight_projectile_template = var_32_9,
		shoot_start = time,
		shoot_duration = arg_32_6,
		max_fire_rate_at_percentage_modifier = num_3,
		time_between_shots_at_start = num,
		time_between_shots_at_end = num_2,
		ratling_gun_unit = get_unit,
		owner_peer_id = arg_32_7,
		breed = var_32_2,
		projectile_list = {
			is_owner = false,
			current_index = 0,
			max_index = max,
			projectiles = Script.new_array(max),
			owner_peer_id = arg_32_7
		}
	}
end

ProjectileSystem._update_shooting = function (self, arg_33_1, arg_33_2, arg_33_3)
	-- function 33
	for k, v in pairs(arg_33_3) do
		local owner_unit = v.owner_unit
		local num = arg_33_2 - v.shoot_start
		local clamp = math.clamp(num / v.shoot_duration * v.max_fire_rate_at_percentage_modifier, 0, 1)
		local lerp = math.lerp(v.time_between_shots_at_start, v.time_between_shots_at_end, clamp)
		local num_2 = math.floor(num / lerp) + 1 - v.shots_fired
		local light_weight_projectile_template = v.light_weight_projectile_template

		for k_2 = 1, num_2 do
			v.shots_fired = v.shots_fired + 1

			self:_shoot(k, v, arg_33_2, arg_33_1)
		end
	end
end

ProjectileSystem._fire_from_position_direction = function (arg_34_0, arg_34_1, arg_34_2)
	-- function 34
	local node = Unit.node(arg_34_1, "p_fx")
	local world_position = Unit.world_position(arg_34_1, node)
	local game = Managers.state.network:game()
	local game_object_field = GameSession.game_object_field(game, arg_34_2, "aim_position")
	local var_34_4

	if not game_object_field then
		var_34_4 = game_object_field - world_position
	else
		var_34_4 = Quaternion.forward(Unit.world_rotation(arg_34_1, node))
	end

	return world_position - Vector3.normalize(var_34_4) * 0.25, var_34_4
end

ProjectileSystem._shoot = function (self, arg_35_1, arg_35_2, arg_35_3, arg_35_4)
	-- function 35
	local _fire_from_position_direction, var_35_1 = self:_fire_from_position_direction(arg_35_2.ratling_gun_unit, arg_35_2.owner_unit_id)
	local light_weight_projectile_template = arg_35_2.light_weight_projectile_template
	local normalize = Vector3.normalize(var_35_1)
	local num = Math.random() * light_weight_projectile_template.spread
	local look = Quaternion.look(normalize, Vector3.up())
	local var_35_6 = Quaternion(Vector3.right(), num)
	local var_35_7 = Quaternion(Vector3.forward(), Math.random() * num_2)
	local multiply = Quaternion.multiply(Quaternion.multiply(look, var_35_7), var_35_6)
	local forward = Quaternion.forward(multiply)
	local str = "filter_enemy_player_afro_ray_projectile"
	local get_difficulty_rank = Managers.state.difficulty:get_difficulty_rank()
	local var_35_12 = light_weight_projectile_template.attack_power_level[get_difficulty_rank]

	var_35_12 = var_35_12 or light_weight_projectile_template.attack_power_level[2]

	local tbl = {
		power_level = var_35_12,
		damage_profile = light_weight_projectile_template.damage_profile,
		hit_effect = light_weight_projectile_template.hit_effect,
		player_push_velocity = Vector3Box(normalize * light_weight_projectile_template.impact_push_speed),
		projectile_linker = light_weight_projectile_template.projectile_linker,
		first_person_hit_flow_events = light_weight_projectile_template.first_person_hit_flow_events
	}
	local peer_id = arg_35_2.peer_id
	local flag = true
	local flag_2 = true

	self:create_light_weight_projectile(arg_35_2.breed.name, arg_35_2.owner_unit, _fire_from_position_direction, forward, light_weight_projectile_template.projectile_speed, nil, nil, light_weight_projectile_template.projectile_max_range, str, tbl, light_weight_projectile_template.light_weight_projectile_effect, arg_35_1, nil, flag, flag_2, arg_35_2.projectile_list)
end

ProjectileSystem.rpc_clients_continuous_shoot_stop = function (self, arg_36_1, arg_36_2)
	-- function 36
	local husk_shoot_list = self._light_weight.husk_shoot_list
	local var_36_1 = husk_shoot_list[arg_36_2]

	if not var_36_1 then
		return
	end

	for i = #var_36_1.projectile_list.projectiles, 1, -1 do
		self:_remove_light_weight_projectile(var_36_1.projectile_list, i)
	end

	husk_shoot_list[arg_36_2] = nil
end

ProjectileSystem.rpc_client_spawn_light_weight_projectile = function (self, arg_37_1, arg_37_2, arg_37_3, arg_37_4, arg_37_5, arg_37_6, arg_37_7, arg_37_8, arg_37_9, arg_37_10, arg_37_11, arg_37_12)
	-- function 37
	local var_37_0 = NetworkLookup.light_weight_projectile_effects[arg_37_9]
	local game_object_or_level_unit = self.network_manager:game_object_or_level_unit(arg_37_3, arg_37_10)
	local var_37_2 = NetworkLookup.damage_sources[arg_37_2]
	local flag = true

	self:create_light_weight_projectile(var_37_2, game_object_or_level_unit, arg_37_4, arg_37_5, arg_37_6, arg_37_7, arg_37_8, nil, nil, nil, var_37_0, arg_37_11, flag, nil, nil, nil, arg_37_12)
end

ProjectileSystem.rpc_client_despawn_light_weight_projectile = function (self, arg_38_1, arg_38_2, arg_38_3, arg_38_4)
	-- function 38
	local var_38_0 = self._light_weight.husk_list[arg_38_2]

	if not var_38_0 then
		for k, v in pairs(var_38_0.projectiles) do
			if v.identifier == arg_38_4 then
				arg_38_3 = k

				break
			end
		end

		self:_remove_light_weight_projectile(var_38_0, arg_38_3)
	end
end

ProjectileSystem.rpc_client_create_aoe = function (self, arg_39_1, arg_39_2, arg_39_3, arg_39_4, arg_39_5, arg_39_6)
	-- function 39
	local world = self.world
	local unit = self.unit_storage:unit(arg_39_2)
	local var_39_2 = NetworkLookup.damage_sources[arg_39_4]
	local var_39_3 = NetworkLookup.explosion_templates[arg_39_5]
	local get_template = ExplosionUtils.get_template(var_39_3)

	DamageUtils.create_aoe(world, unit, arg_39_3, var_39_2, get_template, arg_39_6)
end

ProjectileSystem.spawn_drones = function (self, arg_40_1, arg_40_2, arg_40_3, arg_40_4, arg_40_5, arg_40_6)
	-- function 40
	local has_extension = ScriptUnit.has_extension(arg_40_1, "buff_system")

	if not has_extension then
		arg_40_3 = has_extension:apply_buffs_to_value(arg_40_3, "increased_drone_count")
	end

	local go_id = self.unit_storage:go_id(arg_40_1)
	local var_40_2 = NetworkLookup.drone_templates[arg_40_2]

	arg_40_4 = math.round(arg_40_4)

	local var_40_3 = SideRelationLookup[arg_40_5]
	local var_40_4 = NetworkLookup.damage_profiles[arg_40_6]

	self.network_transmit:send_rpc_server("rpc_request_spawn_drones", go_id, var_40_2, arg_40_3, arg_40_4, var_40_3, var_40_4)
end

local tbl_5 = {}

ProjectileSystem.rpc_request_spawn_drones = function (self, arg_41_1, arg_41_2, arg_41_3, arg_41_4, arg_41_5, arg_41_6, arg_41_7)
	-- function 41
	local unit = self.unit_storage:unit(arg_41_2)

	if not Unit.alive(unit) then
		return
	end

	local var_41_1 = Managers.state.side.side_by_unit[unit]
	local var_41_2 = SideRelationLookup[arg_41_6]
	local broadphase_categories_by_relation = var_41_1:broadphase_categories_by_relation(var_41_2)
	local broadphase_query = AiUtils.broadphase_query(Unit.local_position(unit, 0), arg_41_5, tbl_5, broadphase_categories_by_relation)
	local num = 0

	for i = 1, broadphase_query do
		local go_id = self.unit_storage:go_id(tbl_5[i])

		if not go_id then
			num = num + 1
			tbl_5[num] = go_id
		end
	end

	local min = math.min(num, Network.type_info("game_object_id_array_8").max_size)

	if min == 0 then
		return
	end

	local _drone_seed_per_source = self._drone_seed_per_source
	local var_41_9 = _drone_seed_per_source[unit]

	if not var_41_9 then
		_drone_seed_per_source[unit] = math.random(_drone_seed_per_source.min_seed, _drone_seed_per_source.max_seed)
	else
		_drone_seed_per_source[unit] = Math.next_random(var_41_9)
	end

	local tbl = {}

	for j = 1, arg_41_4 do
		tbl[j] = tbl_5[math.random(1, min)]
	end

	self.network_transmit:send_rpc_all("rpc_spawn_drones", arg_41_2, arg_41_3, _drone_seed_per_source[unit], arg_41_7, tbl)
end

local num_3 = 0.1
local num_4 = 0.025
local num_5 = 100
local num_6 = 5
local num_7 = 14
local num_8 = 3
local num_9 = 0
local num_10 = math.pi * 0.18
local num_11 = 2
local num_12 = 10
local num_13 = -math.pi * 0.1
local num_14 = math.pi * 0.3
local num_15 = math.pi * 0.1
local num_16 = math.pi * 2
local var_0_22 = num_12
local var_0_23 = num_11

ProjectileSystem.rpc_spawn_drones = function (self, arg_42_1, arg_42_2, arg_42_3, arg_42_4, arg_42_5, arg_42_6)
	-- function 42
	local unit = self.unit_storage:unit(arg_42_2)

	if not Unit.alive(unit) then
		return
	end

	local _drones = self._drones

	_drones = _drones or {}
	self._drones = _drones

	local _drones_2 = self._drones
	local var_42_3 = NetworkLookup.drone_templates[arg_42_3]
	local var_42_4 = DroneTemplates[var_42_3]
	local var_42_5 = NetworkLookup.damage_profiles[arg_42_5]
	local var_42_6 = arg_42_4

	for i = 1, #arg_42_6 do
		repeat
			var_42_6 = Math.next_random(var_42_6)

			local var_42_7
			local var_42_8

			var_42_6, var_42_8 = Math.next_random(var_42_6, 0, 1)

			local num = var_42_8 * 2 - 1
			local unit_2 = self.unit_storage:unit(arg_42_6[i])

			if not ALIVE[unit_2] then
				break
			end

			_drones_2[#_drones_2 + 1] = {
				source_unit = unit,
				time_to_spawn = num_3,
				target_unit = unit_2,
				drone_template = var_42_4,
				last_known_target_pos = Vector3Box(POSITION_LOOKUP[unit_2]),
				source_pos = Vector3Box(),
				current_pos = Vector3Box(),
				current_rot = QuaternionBox(),
				damage_profile_name = var_42_5,
				drone_group_i = i,
				upward_side = num,
				vfx_seed = var_42_6
			}
		until true
	end
end

local function fn(self, arg_43_1, arg_43_2)
	-- function 43
	local source_unit = self.source_unit

	if not Unit.alive(source_unit) then
		return nil
	end

	local local_position = Unit.local_position(source_unit, 0)
	local length = Vector3.length(arg_43_1 - local_position)

	if length < math.epsilon then
		return nil
	end

	local upward_side = self.upward_side
	local normalize = Vector3.normalize(arg_43_1 - local_position)
	local cross = Vector3.cross(Vector3.up(), normalize)
	local num = local_position + (Vector3(0, 0, 1) + cross * 0.75 * upward_side + normalize * -0.5)
	local next_random, var_43_8 = Math.next_random(self.vfx_seed)
	local num_2 = num_13 + var_43_8 * (num_14 - num_13)
	local remap = math.remap(num_11, num_12, num_9, num_10, length)
	local normalize_2 = Vector3.normalize(arg_43_1 - num)
	local rotate = Quaternion.rotate(Quaternion.axis_angle(Vector3.cross(normalize_2, Vector3.up()), num_2), normalize_2)
	local rotate_2 = Quaternion.rotate(Quaternion.axis_angle(Vector3.up() * upward_side, remap), rotate)
	local look = Quaternion.look(rotate_2)

	self.source_pos:store(num)
	self.current_pos:store(num)
	self.current_rot:store(look)

	local drone_template = self.drone_template

	if not drone_template.spawn_sfx then
		WwiseUtils.trigger_position_event(arg_43_2, drone_template.spawn_sfx, num)
	end

	if not drone_template.linked_vfx then
		return World.create_particles(arg_43_2, drone_template.linked_vfx.name, num, look)
	else
		return -1
	end
end

local function fn_2(self, arg_44_1, arg_44_2, arg_44_3, arg_44_4)
	-- function 44
	local unbox = self.source_pos:unbox()
	local unbox_2 = self.current_pos:unbox()
	local unbox_3 = self.current_rot:unbox()
	local closest_point_on_line = Geometry.closest_point_on_line(unbox_2, unbox, arg_44_1)
	local distance = Vector3.distance(arg_44_1, closest_point_on_line)
	local var_44_5
	local remap = math.remap(var_0_22, var_0_23, num_15, num_16, distance)
	local num = arg_44_1 - unbox_2
	local look = Quaternion.look(num)
	local num_2 = remap * arg_44_3
	local angle = Quaternion.angle(look, unbox_3)

	if not (remap >= num_16 or not (angle <= num_2 * 1.05)) then
		var_44_5 = look
	else
		local forward = Quaternion.forward(unbox_3)
		local normalize = Vector3.normalize(Vector3.cross(num, forward))

		if Vector3.length_squared(normalize) <= math.epsilon then
			var_44_5 = Quaternion.look(num)
		else
			var_44_5 = Quaternion.multiply(Quaternion.axis_angle(normalize, num_2), unbox_3)

			if angle < Quaternion.angle(look, var_44_5) then
				local normalize_2 = Vector3.normalize(Vector3.cross(forward, num))

				var_44_5 = Quaternion.multiply(Quaternion.axis_angle(normalize_2, num_2), unbox_3)
			end
		end
	end

	local num_3 = arg_44_4 - self.spawn_t
	local lerp_clamped = math.lerp_clamped(num_6, num_7, num_3 / num_8)
	local num_4 = Quaternion.forward(var_44_5) * lerp_clamped * arg_44_3 / math.clamp(math.cos(angle), 0.1, 1)

	if Vector3.length_squared(num_4) >= distance * distance then
		return true
	end

	local num_5 = unbox_2 + num_4

	self.current_pos:store(num_5)
	self.current_rot:store(var_44_5)
	World.move_particles(arg_44_2, self.vfx_id, num_5, var_44_5)
end

local function fn_3(self, arg_45_1, arg_45_2)
	-- function 45
	local drone_template = self.drone_template
	local vfx_id = self.vfx_id

	if not (not vfx_id and not (vfx_id >= 0)) then
		if drone_template.linked_vfx.destroy_policy == "stop" then
			World.stop_spawning_particles(arg_45_1, vfx_id)
		else
			World.destroy_particles(arg_45_1, vfx_id)
		end
	end

	local unbox = self.current_pos:unbox()

	if not drone_template.impact_vfx then
		local unbox_2 = self.current_rot:unbox()

		World.create_particles(arg_45_1, drone_template.impact_vfx, unbox, unbox_2)
	end

	if not drone_template.impact_sfx then
		WwiseUtils.trigger_position_event(arg_45_1, drone_template.impact_sfx, unbox)
	end

	if not arg_45_2 then
		return
	end

	local var_45_4 = DamageProfileTemplates[self.damage_profile_name]
	local target_unit = self.target_unit
	local source_unit

	if not HEALTH_ALIVE[self.source_unit] then
		source_unit = self.source_unit

		if not source_unit then
			-- Nothing
		end
	end

	source_unit = target_unit

	::label_45_0::

	if not HEALTH_ALIVE[target_unit] then
		local DefaultPowerLevel = DefaultPowerLevel
		local has_extension = ScriptUnit.has_extension(self.source_unit, "career_system")

		if not has_extension then
			DefaultPowerLevel = has_extension:get_career_power_level()
		end

		local str = "full"
		local unbox_3 = self.current_pos:unbox()
		local forward = Quaternion.forward(self.current_rot:unbox())
		local str_2 = "buff"
		local flag = false
		local var_45_14
		local flag_2 = false
		local flag_3 = false
		local flag_4 = false
		local num = self.drone_group_i + 1
		local var_45_19

		DamageUtils.add_damage_network_player(var_45_4, self.drone_group_i, DefaultPowerLevel, target_unit, source_unit, str, unbox_3, forward, str_2, flag, var_45_14, flag_2, flag_3, flag_4, num, var_45_19, source_unit)
	end
end

ProjectileSystem._update_drones = function (self, arg_46_1, arg_46_2)
	-- function 46
	local _drones = self._drones

	if not _drones then
		return
	end

	local remap = math.remap(0, num_5, num_3, num_4, math.clamp(#_drones, 0, num_5))
	local num = num_3 / remap
	local num_2 = 1

	while num_2 <= #_drones do
		local var_46_4 = _drones[num_2]

		if not var_46_4.spawn_t then
			var_46_4.time_to_spawn = var_46_4.time_to_spawn - arg_46_1 * num

			if var_46_4.time_to_spawn > 0 then
				return
			else
				var_46_4.spawn_t = arg_46_2

				local var_46_5 = _drones[num_2 + 1]

				if not var_46_5 then
					local abs = math.abs(var_46_4.time_to_spawn)

					var_46_5.time_to_spawn = var_46_5.time_to_spawn - abs
				end
			end
		end

		local last_known_target_pos = var_46_4.last_known_target_pos
		local target_unit = var_46_4.target_unit

		if not Unit.alive(target_unit) then
			if not Unit.has_node(target_unit, "j_spine") then
				last_known_target_pos:store(Unit.world_position(target_unit, Unit.node(target_unit, "j_spine")))
			else
				local num_6

				if not Unit.get_data(target_unit, "breed") then
					num_6 = AiUtils.breed_height(target_unit) * 0.6

					if not num_6 then
						-- Nothing
					end
				end

				num_6 = 0

				::label_46_0::

				last_known_target_pos:store(POSITION_LOOKUP[target_unit] + Vector3(0, 0, num_6))
			end
		end

		local unbox = last_known_target_pos:unbox()

		if not var_46_4.vfx_id then
			var_46_4.vfx_id = fn(var_46_4, unbox, self.world)

			if not var_46_4.vfx_id then
				fn_3(var_46_4, self.world, self.is_server)
				table.remove(_drones, num_2)

				num_2 = num_2 - 1
			end
		elseif not fn_2(var_46_4, unbox, self.world, arg_46_1, arg_46_2) then
			fn_3(var_46_4, self.world, self.is_server)
			table.remove(_drones, num_2)

			num_2 = num_2 - 1
		end

		num_2 = num_2 + 1
	end
end

ProjectileSystem._remove_light_weight_projectile = function (self, arg_47_1, arg_47_2)
	-- function 47
	local world = self.world
	local flag = not arg_47_1 and arg_47_1.projectiles
	local flag_2 = not flag and flag[arg_47_2]

	if not flag_2 then
		return
	end

	local current_index = arg_47_1.current_index
	local identifier = flag_2.identifier

	if arg_47_2 ~= current_index then
		local var_47_5 = flag[current_index]

		var_47_5.index = arg_47_2
		flag[current_index] = flag_2
		flag[arg_47_2] = var_47_5
	end

	for k, v in pairs(flag_2.particle_settings) do
		if v.kill_policy == "stop" then
			World.stop_spawning_particles(world, k)
		elseif v.kill_policy == "destroy" then
			World.destroy_particles(world, k)
		end
	end

	for k_2, v_2 in pairs(flag_2.sound_settings) do
		local looping_sound_stop_event_name = v_2.looping_sound_stop_event_name

		if not looping_sound_stop_event_name then
			WwiseWorld.trigger_event(self._wwise_world, looping_sound_stop_event_name, k_2)
		end

		WwiseWorld.destroy_manual_source(self._wwise_world, k_2)
	end

	flag[current_index] = nil
	arg_47_1.current_index = current_index - 1

	local is_server = self.is_server

	if not flag_2.skip_rpc then
		return
	end

	if not arg_47_1.is_owner then
		if not is_server then
			Managers.state.network.network_transmit:send_rpc_clients("rpc_client_despawn_light_weight_projectile", arg_47_1.owner_peer_id, arg_47_2, identifier)
		else
			Managers.state.network.network_transmit:send_rpc_server("rpc_client_despawn_light_weight_projectile", arg_47_1.owner_peer_id, arg_47_2, identifier)
		end
	elseif not is_server then
		Managers.state.network.network_transmit:send_rpc_clients_except("rpc_client_despawn_light_weight_projectile", arg_47_1.owner_peer_id, arg_47_1.owner_peer_id, arg_47_2, identifier)
	end
end

ProjectileSystem.physics_cb_light_weight_projectile_hit = function (self, arg_48_1, arg_48_2)
	-- function 48
	if not arg_48_2 then
		return
	end

	if not Unit.alive(arg_48_1.owner_unit) then
		self:_remove_light_weight_projectile(self._light_weight.own_data, arg_48_1.index)

		return
	end

	if not arg_48_1.projectile_list_reference then
		self:_remove_light_weight_projectile(arg_48_1.projectile_list_reference, arg_48_1.index)
	elseif not arg_48_1.husk_projectile then
		self:_remove_light_weight_projectile(self._light_weight.own_data, arg_48_1.index)
	else
		local action_data = arg_48_1.action_data
		local process_projectile_hit = DamageUtils.process_projectile_hit(self.world, arg_48_1.damage_source, arg_48_1.owner_unit, self.is_server, arg_48_2, action_data, arg_48_1.direction:unbox(), false, nil, nil, false, action_data.power_level)

		if not process_projectile_hit.stop then
			self:_remove_light_weight_projectile(self._light_weight.own_data, arg_48_1.index)

			local hit_player = process_projectile_hit.hit_player

			if hit_player or not action_data.projectile_linker then
				self:_link_projectile(process_projectile_hit, action_data.projectile_linker)
			end

			local hit_unit = process_projectile_hit.hit_unit

			if not (not hit_unit and not hit_player and not action_data.first_person_hit_flow_events and process_projectile_hit.shield_blocked) then
				local count = #action_data.first_person_hit_flow_events
				local var_48_5 = action_data.first_person_hit_flow_events[Math.random(count)]
				local network_id = Managers.player:owner(hit_unit):network_id()
				local go_id = Managers.state.unit_storage:go_id(hit_unit)
				local var_48_8 = NetworkLookup.flow_events[var_48_5]

				Managers.state.network.network_transmit:send_rpc("rpc_first_person_flow_event", network_id, go_id, var_48_8)
			end
		end
	end
end

ProjectileSystem._redirect_shield_linking = function (arg_49_0, arg_49_1, arg_49_2, arg_49_3, arg_49_4)
	-- function 49
	local unit_breed = AiUtils.unit_breed(arg_49_1)
	local var_49_1 = HEALTH_ALIVE[arg_49_1]

	var_49_1 = not var_49_1 and not unit_breed and not not unit_breed.no_effects_on_shield_block or not unit_breed.is_player

	if not var_49_1 then
		return arg_49_1, arg_49_2, arg_49_3
	end

	arg_49_1 = ScriptUnit.extension(arg_49_1, "ai_inventory_system").inventory_item_shield_unit

	local node = Unit.node(arg_49_1, "c_mesh")
	local num = Unit.world_position(arg_49_1, node) + arg_49_4
	local num_2 = arg_49_3 - num
	local length = Vector3.length(num_2)

	arg_49_3 = num + num_2 * math.min(length, 0.25)
	arg_49_2 = node

	return arg_49_1, arg_49_2, arg_49_3
end

ProjectileSystem._link_projectile = function (self, arg_50_1, arg_50_2)
	-- function 50
	local hit_unit = arg_50_1.hit_unit
	local hit_actor = arg_50_1.hit_actor
	local hit_position = arg_50_1.hit_position
	local hit_direction = arg_50_1.hit_direction
	local predicted_damage = arg_50_1.predicted_damage
	local shield_blocked = arg_50_1.shield_blocked
	local depth = arg_50_2.depth

	depth = depth or 0.15

	local depth_offset = arg_50_2.depth_offset

	depth_offset = depth_offset or 0.15

	local unit = arg_50_2.unit
	local flag = true
	local get_data = Unit.get_data(hit_unit, "allow_link")

	if get_data ~= nil then
		flag = get_data
	end

	if not flag then
		return
	end

	if not arg_50_2.broken_units then
		local random = Math.random()

		if not (not predicted_damage and shield_blocked) then
			random = random * math.clamp(predicted_damage / 2, 0.75, 1.25)
		else
			random = random * 2
		end

		if random <= 0.5 then
			local count = #arg_50_2.broken_units
			local random_2 = Math.random(1, count)

			unit = arg_50_2.broken_units[random_2]

			if random_2 == 1 then
				depth = 0.05
				depth_offset = 0.1
			else
				depth_offset = 0.15
			end
		end
	elseif not (not predicted_damage and shield_blocked) then
		depth = depth * math.clamp(predicted_damage, 1, 3)
	end

	if not shield_blocked then
		depth = -0.1
	end

	local num = depth + depth_offset
	local num_2 = Math.random() * 2.14 - 0.5
	local normalize = Vector3.normalize(hit_direction)
	local num_3 = normalize * num
	local num_4 = hit_position + num_3
	local multiply = Quaternion.multiply(Quaternion.look(normalize), Quaternion(Vector3.forward(), num_2))
	local node = Actor.node(hit_actor)

	if not shield_blocked then
		hit_unit, node, num_4 = self:_redirect_shield_linking(hit_unit, node, num_4, num_3)
	end

	local var_50_21 = NetworkLookup.husks[unit]
	local game_object_or_level_id, var_50_23 = self.network_manager:game_object_or_level_id(hit_unit)

	if not (game_object_or_level_id or var_50_23 ~= nil) then
		return
	end

	Managers.state.network.network_transmit:send_rpc_all("rpc_spawn_and_link_units", var_50_21, num_4, multiply, game_object_or_level_id, node, var_50_23)
end

ProjectileSystem._update_light_weight_projectiles = function (self, arg_51_1, arg_51_2, arg_51_3)
	-- function 51
	self:_server_update_light_weight_projectiles(arg_51_1, arg_51_2, self._light_weight.own_data)

	for k, v in pairs(self._light_weight.husk_list) do
		self:_client_update_light_weight_projectiles(arg_51_1, arg_51_2, v)
	end

	for k_2, v_2 in pairs(self._light_weight.husk_shoot_list) do
		self:_server_update_light_weight_projectiles(arg_51_1, arg_51_2, v_2.projectile_list)
	end
end

ProjectileSystem._print_debug = function (self)
	-- function 52
	if not Development.parameter("debug_light_weight_projectiles") then
		Debug.text("Own projectiles: " .. tostring(table.size(self._light_weight.own_data.projectiles)))
		Debug.text("Husk list: " .. tostring(table.size(self._light_weight.husk_list)))

		local num = 0

		for k, v in pairs(self._light_weight.husk_list) do
			num = num + table.size(v.projectiles)
		end

		Debug.text("Husk projectiles: " .. tostring(num))

		local num_2 = 0

		for k_2, v_2 in pairs(self._light_weight.husk_shoot_list) do
			num_2 = num_2 + table.size(v_2.projectile_list.projectiles)
		end

		Debug.text("Local husk projectiles: " .. tostring(num_2))
	end
end

local tbl_6 = {}

ProjectileSystem._server_update_light_weight_projectiles = function (self, arg_53_1, arg_53_2, arg_53_3)
	-- function 53
	local projectiles = arg_53_3.projectiles
	local current_index = arg_53_3.current_index
	local world = self.world
	local var_53_3 = tbl_6

	for i = 1, current_index do
		local var_53_4 = projectiles[i]

		if var_53_4.distance_moved < var_53_4.range then
			local _move_light_weight_projectile, var_53_6, var_53_7 = self:_move_light_weight_projectile(arg_53_1, world, var_53_4)

			var_53_4.distance_moved = var_53_4.distance_moved + var_53_7

			var_53_4.raycast:cast(_move_light_weight_projectile, var_53_6, var_53_7)
		else
			var_53_3[#var_53_3 + 1] = i
		end
	end

	table.reverse(var_53_3)

	for i_2, v in ipairs(var_53_3) do
		self:_remove_light_weight_projectile(arg_53_3, v)
	end

	table.clear(var_53_3)
end

ProjectileSystem._client_update_light_weight_projectiles = function (self, arg_54_1, arg_54_2, arg_54_3)
	-- function 54
	local projectiles = arg_54_3.projectiles
	local current_index = arg_54_3.current_index
	local world = self.world

	for i = 1, current_index do
		local var_54_3 = projectiles[i]

		self:_move_light_weight_projectile(arg_54_1, world, var_54_3, debug)
	end
end

ProjectileSystem._move_light_weight_projectile = function (self, arg_55_1, arg_55_2, arg_55_3, arg_55_4)
	-- function 55
	local unbox = arg_55_3.position:unbox()
	local unbox_2 = arg_55_3.direction:unbox()
	local unbox_3 = arg_55_3.rotation:unbox()
	local num = arg_55_3.speed * arg_55_1
	local gravity = arg_55_3.gravity
	local num_2 = unbox + unbox_2 * num

	if gravity ~= 0 then
		num = arg_55_3.flat_speed * arg_55_1
		num_2 = unbox + unbox_2 * num
		num_2 = num_2 - Vector3(0, 0, gravity) * arg_55_1 * arg_55_1
		unbox_2 = Vector3.normalize(num_2 - unbox)

		arg_55_3.direction:store(unbox_2)

		unbox_3 = Quaternion.look(unbox_2, Vector3.up())

		arg_55_3.rotation:store(unbox_3)
	end

	for k, v in pairs(arg_55_3.particle_settings) do
		if not v.link then
			World.move_particles(arg_55_2, k, num_2, unbox_3)
		end
	end

	for k_2, v_2 in pairs(arg_55_3.sound_settings) do
		WwiseWorld.set_source_position(self._wwise_world, k_2, num_2)
	end

	arg_55_3.position:store(num_2)

	return unbox, unbox_2, num
end
