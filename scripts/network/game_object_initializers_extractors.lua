-- chunkname: @scripts/network/game_object_initializers_extractors.lua

local var_0_0
local var_0_1 = {}

EnergyData = EnergyData or {}

local function var_0_2(arg_1_0, arg_1_1, arg_1_2)
	local var_1_0 = GameSession.game_object_field(arg_1_1, arg_1_2, "breed_name")
	local var_1_1 = NetworkLookup.breeds[var_1_0]
	local var_1_2 = Breeds[var_1_1]

	Unit.set_data(arg_1_0, "breed", var_1_2)

	local var_1_3 = GameSession.game_object_field(arg_1_1, arg_1_2, "side_id")

	return var_1_2, var_1_1, var_1_3
end

local function var_0_3(arg_2_0, arg_2_1, arg_2_2, arg_2_3)
	local var_2_0 = arg_2_0:unique_id()
	local var_2_1 = Managers.party:get_status_from_unique_id(var_2_0)
	local var_2_2 = Managers.party:get_party(var_2_1.party_id)
	local var_2_3 = Managers.state.side.side_by_party[var_2_2]
	local var_2_4 = arg_2_2.breed or arg_2_1.breed
	local var_2_5 = BLACKBOARDS[arg_2_3] or {}

	var_2_5.is_player = true
	var_2_5.side = var_2_3
	var_2_5.breed = var_2_4
	BLACKBOARDS[arg_2_3] = var_2_5
end

local var_0_4 = {
	initializers = {
		player_unit = function (arg_3_0, arg_3_1, arg_3_2, arg_3_3)
			local var_3_0 = ScriptUnit.extension(arg_3_0, "input_system").player
			local var_3_1 = Unit.mover(arg_3_0)
			local var_3_2 = var_3_0:profile_index()
			local var_3_3 = SPProfiles[var_3_2]

			fassert(var_3_3, "No such profile with index %s", tostring(var_3_2))

			local var_3_4 = Managers.backend:get_interface("hero_attributes")
			local var_3_5 = ScriptUnit.extension(arg_3_0, "career_system"):career_index()
			local var_3_6 = ScriptUnit.extension(arg_3_0, "cosmetic_system")
			local var_3_7 = var_3_6:get_equipped_skin().name
			local var_3_8 = var_3_6:get_equipped_frame_name()
			local var_3_9 = Cosmetics[var_3_7].third_person_husk
			local var_3_10 = ScriptUnit.extension(arg_3_0, "first_person_system"):current_position()
			local var_3_11 = Unit.local_rotation(arg_3_0, 0)
			local var_3_12 = ExperienceSettings.get_experience(var_3_3.display_name)
			local var_3_13 = ExperienceSettings.get_level(var_3_12)
			local var_3_14 = Managers.mechanism:current_mechanism_name() == "versus"
			local var_3_15 = ExperienceSettings.get_versus_experience()
			local var_3_16 = (var_3_14 or Application.user_setting("toggle_versus_level_in_all_game_modes")) and ExperienceSettings.get_versus_level_from_experience(var_3_15) or 0
			local var_3_17 = ScriptUnit.extension(arg_3_0, "status_system"):max_wounds_network_safe()
			local var_3_18 = var_3_3.careers[var_3_5]

			fassert(var_3_18, "No such career with career_index %s", tostring(var_3_5))

			local var_3_19 = {}
			local var_3_20 = ScriptUnit.extension(arg_3_0, "buff_system"):get_persistent_buff_names()

			for iter_3_0, iter_3_1 in pairs(var_3_20) do
				local var_3_21 = NetworkLookup.buff_templates[iter_3_1]

				table.insert(var_3_19, var_3_21)
			end

			var_0_3(var_3_0, var_3_3, var_3_18, arg_3_0)

			return {
				ammo_percentage = 1,
				overcharge_threshold_percentage = 0,
				has_moved_from_start_position = false,
				ability_percentage = 0,
				overcharge_max_value = 40,
				moving_platform_soft_linked = false,
				overcharge_percentage = 0,
				moving_platform = 0,
				go_type = NetworkLookup.go_types.player_unit,
				husk_unit = NetworkLookup.husks[var_3_9],
				skin_name = NetworkLookup.cosmetics[var_3_7],
				frame_name = NetworkLookup.cosmetics[var_3_8],
				wounds = var_3_17,
				level = var_3_13,
				versus_level = var_3_16,
				prestige_level = ProgressionUnlocks.get_prestige_level(var_3_3.display_name),
				position = Mover.position(var_3_1),
				pitch = Quaternion.pitch(var_3_11),
				yaw = Quaternion.yaw(var_3_11),
				owner_peer_id = var_3_0:network_id(),
				local_player_id = var_3_0:local_player_id(),
				aim_direction = Vector3(1, 0, 0),
				aim_position = var_3_10,
				velocity = Vector3(0, 0, 0),
				average_velocity = Vector3(0, 0, 0),
				profile_id = var_3_2,
				career_id = var_3_5,
				network_buff_ids = var_3_19
			}
		end,
		player_bot_unit = function (arg_4_0, arg_4_1, arg_4_2, arg_4_3)
			local var_4_0 = Managers.player:owner(arg_4_0)
			local var_4_1 = Unit.mover(arg_4_0)
			local var_4_2 = var_4_0:profile_index()
			local var_4_3 = SPProfiles[var_4_2]

			fassert(var_4_3, "No such profile with index %s", tostring(var_4_2))

			local var_4_4 = ScriptUnit.extension(arg_4_0, "cosmetic_system")
			local var_4_5 = var_4_4:get_equipped_skin().name
			local var_4_6 = var_4_4:get_equipped_frame_name()
			local var_4_7 = Cosmetics[var_4_5].third_person_husk
			local var_4_8 = ScriptUnit.extension(arg_4_0, "status_system"):max_wounds_network_safe()
			local var_4_9 = ScriptUnit.extension(arg_4_0, "career_system"):career_index()
			local var_4_10 = var_4_3.careers[var_4_9]

			fassert(var_4_10, "No such career with career_index %s", tostring(var_4_9))
			var_0_3(var_4_0, var_4_3, var_4_10, arg_4_0)

			local var_4_11 = Unit.local_rotation(arg_4_0, 0)

			return {
				moving_platform_soft_linked = false,
				ammo_percentage = 1,
				overcharge_threshold_percentage = 0,
				ability_percentage = 0,
				prestige_level = 0,
				overcharge_max_value = 40,
				level = 0,
				overcharge_percentage = 0,
				moving_platform = 0,
				go_type = NetworkLookup.go_types.player_bot_unit,
				husk_unit = NetworkLookup.husks[var_4_7],
				skin_name = NetworkLookup.cosmetics[var_4_5],
				frame_name = NetworkLookup.cosmetics[var_4_6],
				wounds = var_4_8,
				position = var_4_1 and Mover.position(var_4_1) or Unit.local_position(arg_4_0, 0),
				pitch = Quaternion.pitch(var_4_11),
				yaw = Quaternion.yaw(var_4_11),
				velocity = Vector3(0, 0, 0),
				average_velocity = Vector3(0, 0, 0),
				owner_peer_id = var_4_0:network_id(),
				local_player_id = var_4_0:local_player_id(),
				aim_direction = Vector3(1, 0, 0),
				profile_id = var_4_2,
				career_id = var_4_9
			}
		end,
		ai_unit = function (arg_5_0, arg_5_1, arg_5_2, arg_5_3)
			local var_5_0 = Unit.mover(arg_5_0)
			local var_5_1 = Unit.get_data(arg_5_0, "breed")
			local var_5_2, var_5_3 = ScriptUnit.extension(arg_5_0, "ai_system"):size_variation()
			local var_5_4 = Managers.state.side.side_by_unit[arg_5_0].side_id
			local var_5_5 = Managers.state.entity:system("ai_group_system"):get_group_id(arg_5_0)

			return {
				has_teleported = 1,
				go_type = NetworkLookup.go_types.ai_unit,
				husk_unit = NetworkLookup.husks[arg_5_1],
				health = ScriptUnit.extension(arg_5_0, "health_system"):get_max_health(),
				position = var_5_0 and Mover.position(var_5_0) or Unit.local_position(arg_5_0, 0),
				yaw_rot = Quaternion.yaw(Unit.local_rotation(arg_5_0, 0)),
				velocity = Vector3(0, 0, 0),
				breed_name = NetworkLookup.breeds[var_5_1.name],
				uniform_scale = var_5_2,
				bt_action_name = NetworkLookup.bt_action_names["n/a"],
				side_id = var_5_4,
				ai_group_id = var_5_5 or AIGroupSystem.invalid_group_uid
			}
		end,
		ai_unit_training_dummy_bob = function (arg_6_0, arg_6_1, arg_6_2, arg_6_3)
			local var_6_0 = Unit.mover(arg_6_0)
			local var_6_1 = Unit.get_data(arg_6_0, "breed")
			local var_6_2, var_6_3 = ScriptUnit.extension(arg_6_0, "ai_system"):size_variation()
			local var_6_4 = Managers.state.side.side_by_unit[arg_6_0].side_id
			local var_6_5 = ScriptUnit.extension(arg_6_0, "projectile_locomotion_system")
			local var_6_6 = var_6_5.network_position
			local var_6_7 = var_6_5.network_rotation
			local var_6_8 = var_6_5.network_velocity
			local var_6_9 = var_6_5.network_angular_velocity
			local var_6_10 = ScriptUnit.extension(arg_6_0, "pickup_system")
			local var_6_11 = var_6_10.pickup_name
			local var_6_12 = var_6_10.has_physics
			local var_6_13 = var_6_10.spawn_type
			local var_6_14 = Managers.state.entity:system("ai_group_system"):get_group_id(arg_6_0)

			return {
				damage = 0,
				has_teleported = 1,
				go_type = NetworkLookup.go_types.ai_unit_training_dummy_bob,
				husk_unit = NetworkLookup.husks[arg_6_1],
				health = ScriptUnit.extension(arg_6_0, "health_system"):get_max_health(),
				position = var_6_0 and Mover.position(var_6_0) or Unit.local_position(arg_6_0, 0),
				yaw_rot = Quaternion.yaw(Unit.local_rotation(arg_6_0, 0)),
				velocity = Vector3(0, 0, 0),
				breed_name = NetworkLookup.breeds[var_6_1.name],
				uniform_scale = var_6_2,
				bt_action_name = NetworkLookup.bt_action_names["n/a"],
				side_id = var_6_4,
				ai_group_id = var_6_14 or AIGroupSystem.invalid_group_uid,
				rotation = Unit.local_rotation(arg_6_0, 0),
				network_position = var_6_6,
				network_rotation = var_6_7,
				network_velocity = var_6_8,
				network_angular_velocity = var_6_9,
				pickup_name = NetworkLookup.pickup_names[var_6_11],
				has_physics = var_6_12,
				spawn_type = NetworkLookup.pickup_spawn_types[var_6_13]
			}
		end,
		ai_unit_beastmen_bestigor = function (arg_7_0, arg_7_1, arg_7_2, arg_7_3)
			local var_7_0 = Unit.mover(arg_7_0)
			local var_7_1 = Unit.get_data(arg_7_0, "breed")
			local var_7_2, var_7_3 = ScriptUnit.extension(arg_7_0, "ai_system"):size_variation()
			local var_7_4 = ScriptUnit.extension(arg_7_0, "ai_inventory_system").inventory_configuration_name
			local var_7_5 = Managers.state.side.side_by_unit[arg_7_0].side_id
			local var_7_6 = Managers.state.entity:system("ai_group_system"):get_group_id(arg_7_0)

			return {
				has_teleported = 1,
				go_type = NetworkLookup.go_types.ai_unit_beastmen_bestigor,
				husk_unit = NetworkLookup.husks[arg_7_1],
				health = ScriptUnit.extension(arg_7_0, "health_system"):get_max_health(),
				position = var_7_0 and Mover.position(var_7_0) or Unit.local_position(arg_7_0, 0),
				yaw_rot = Quaternion.yaw(Unit.local_rotation(arg_7_0, 0)),
				velocity = Vector3(0, 0, 0),
				breed_name = NetworkLookup.breeds[var_7_1.name],
				uniform_scale = var_7_2,
				inventory_configuration = NetworkLookup.ai_inventory[var_7_4],
				bt_action_name = NetworkLookup.bt_action_names["n/a"],
				side_id = var_7_5,
				ai_group_id = var_7_6 or AIGroupSystem.invalid_group_uid
			}
		end,
		ai_unit_beastmen_minotaur = function (arg_8_0, arg_8_1, arg_8_2, arg_8_3)
			local var_8_0 = Unit.mover(arg_8_0)
			local var_8_1 = Unit.get_data(arg_8_0, "breed")
			local var_8_2, var_8_3 = ScriptUnit.extension(arg_8_0, "ai_system"):size_variation()
			local var_8_4 = ScriptUnit.extension(arg_8_0, "ai_inventory_system").inventory_configuration_name
			local var_8_5 = Managers.state.side.side_by_unit[arg_8_0].side_id
			local var_8_6 = Managers.state.entity:system("ai_group_system"):get_group_id(arg_8_0)

			return {
				lean_downwards = false,
				has_teleported = 1,
				go_type = NetworkLookup.go_types.ai_unit_beastmen_minotaur,
				husk_unit = NetworkLookup.husks[arg_8_1],
				health = ScriptUnit.extension(arg_8_0, "health_system"):get_max_health(),
				position = var_8_0 and Mover.position(var_8_0) or Unit.local_position(arg_8_0, 0),
				yaw_rot = Quaternion.yaw(Unit.local_rotation(arg_8_0, 0)),
				velocity = Vector3(0, 0, 0),
				breed_name = NetworkLookup.breeds[var_8_1.name],
				uniform_scale = var_8_2,
				inventory_configuration = NetworkLookup.ai_inventory[var_8_4],
				bt_action_name = NetworkLookup.bt_action_names["n/a"],
				side_id = var_8_5,
				ai_group_id = var_8_6 or AIGroupSystem.invalid_group_uid
			}
		end,
		ai_unit_grey_seer = function (arg_9_0, arg_9_1, arg_9_2, arg_9_3)
			local var_9_0 = Unit.mover(arg_9_0)
			local var_9_1 = Unit.get_data(arg_9_0, "breed")
			local var_9_2, var_9_3 = ScriptUnit.extension(arg_9_0, "ai_system"):size_variation()
			local var_9_4 = Managers.state.side.side_by_unit[arg_9_0].side_id
			local var_9_5 = Managers.state.entity:system("ai_group_system"):get_group_id(arg_9_0)

			return {
				show_health_bar = false,
				has_teleported = 1,
				go_type = NetworkLookup.go_types.ai_unit,
				husk_unit = NetworkLookup.husks[arg_9_1],
				health = ScriptUnit.extension(arg_9_0, "health_system"):get_max_health(),
				position = var_9_0 and Mover.position(var_9_0) or Unit.local_position(arg_9_0, 0),
				yaw_rot = Quaternion.yaw(Unit.local_rotation(arg_9_0, 0)),
				velocity = Vector3(0, 0, 0),
				breed_name = NetworkLookup.breeds[var_9_1.name],
				uniform_scale = var_9_2,
				bt_action_name = NetworkLookup.bt_action_names["n/a"],
				side_id = var_9_4,
				ai_group_id = var_9_5 or AIGroupSystem.invalid_group_uid
			}
		end,
		ai_unit_tentacle = function (arg_10_0, arg_10_1, arg_10_2, arg_10_3)
			local var_10_0 = Unit.mover(arg_10_0)
			local var_10_1 = Unit.get_data(arg_10_0, "breed")
			local var_10_2, var_10_3 = ScriptUnit.extension(arg_10_0, "ai_system"):size_variation()
			local var_10_4 = ScriptUnit.extension(arg_10_0, "ai_supplementary_system")
			local var_10_5 = var_10_4.portal_unit
			local var_10_6 = Managers.state.side.side_by_unit[arg_10_0].side_id
			local var_10_7 = Managers.state.entity:system("ai_group_system"):get_group_id(arg_10_0)

			return {
				reach_distance = 0,
				has_teleported = 1,
				go_type = NetworkLookup.go_types.ai_unit_tentacle,
				husk_unit = NetworkLookup.husks[arg_10_1],
				health = ScriptUnit.extension(arg_10_0, "health_system"):get_max_health(),
				position = var_10_0 and Mover.position(var_10_0) or Unit.local_position(arg_10_0, 0),
				rotation = Unit.local_rotation(arg_10_0, 0),
				velocity = Vector3(0, 0, 0),
				breed_name = NetworkLookup.breeds[var_10_1.name],
				uniform_scale = var_10_2,
				bt_action_name = NetworkLookup.bt_action_names["n/a"],
				portal_unit_id = Managers.state.network:unit_game_object_id(var_10_5),
				tentacle_template_id = NetworkLookup.tentacle_templates[var_10_4.tentacle_template_name],
				side_id = var_10_6,
				ai_group_id = var_10_7 or AIGroupSystem.invalid_group_uid
			}
		end,
		ai_unit_vortex = function (arg_11_0, arg_11_1, arg_11_2, arg_11_3)
			local var_11_0 = Unit.mover(arg_11_0)
			local var_11_1 = Unit.get_data(arg_11_0, "breed")
			local var_11_2 = ScriptUnit.extension(arg_11_0, "ai_system")
			local var_11_3 = ScriptUnit.extension(arg_11_0, "ai_supplementary_system")
			local var_11_4, var_11_5 = var_11_2:size_variation()
			local var_11_6 = var_11_3._inner_decal_unit
			local var_11_7 = NetworkConstants.invalid_game_object_id

			if Unit.alive(var_11_6) then
				var_11_7 = Managers.state.network:unit_game_object_id(var_11_6)
			end

			local var_11_8 = var_11_3._outer_decal_unit
			local var_11_9 = NetworkConstants.invalid_game_object_id

			if Unit.alive(var_11_8) then
				var_11_9 = Managers.state.network:unit_game_object_id(var_11_8)
			end

			local var_11_10 = var_11_3._owner_unit
			local var_11_11 = NetworkConstants.invalid_game_object_id

			if Unit.alive(var_11_10) then
				var_11_11 = Managers.state.network:unit_game_object_id(var_11_10)
			end

			local var_11_12 = Managers.state.side.side_by_unit[arg_11_0].side_id

			return {
				height_percentage = 0,
				fx_radius_percentage = 0,
				has_teleported = 1,
				inner_radius_percentage = 0,
				go_type = NetworkLookup.go_types.ai_unit_vortex,
				husk_unit = NetworkLookup.husks[arg_11_1],
				position = var_11_0 and Mover.position(var_11_0) or Unit.local_position(arg_11_0, 0),
				yaw_rot = Quaternion.yaw(Unit.local_rotation(arg_11_0, 0)),
				velocity = Vector3(0, 0, 0),
				breed_name = NetworkLookup.breeds[var_11_1.name],
				uniform_scale = var_11_4,
				bt_action_name = NetworkLookup.bt_action_names["n/a"],
				vortex_template_id = NetworkLookup.vortex_templates[var_11_3.vortex_template_name],
				inner_decal_unit_id = var_11_7,
				outer_decal_unit_id = var_11_9,
				owner_unit_id = var_11_11,
				side_id = var_11_12
			}
		end,
		ai_unit_plague_wave_spawner = function (arg_12_0, arg_12_1, arg_12_2, arg_12_3)
			local var_12_0 = Unit.get_data(arg_12_0, "breed")
			local var_12_1 = ScriptUnit.extension(arg_12_0, "ai_system")
			local var_12_2 = Managers.state.side.side_by_unit[arg_12_0].side_id

			return {
				go_type = NetworkLookup.go_types.ai_unit_plague_wave_spawner,
				husk_unit = NetworkLookup.husks[arg_12_1],
				position = Unit.local_position(arg_12_0, 0),
				yaw_rot = Quaternion.yaw(Unit.local_rotation(arg_12_0, 0)),
				breed_name = NetworkLookup.breeds[var_12_0.name],
				bt_action_name = NetworkLookup.bt_action_names["n/a"],
				side_id = var_12_2
			}
		end,
		ai_unit_tentacle_portal = function (arg_13_0, arg_13_1, arg_13_2, arg_13_3)
			local var_13_0 = Managers.state.side.side_by_unit[arg_13_0].side_id

			return {
				go_type = NetworkLookup.go_types.ai_unit_tentacle_portal,
				husk_unit = NetworkLookup.husks[arg_13_1],
				position = Unit.local_position(arg_13_0, 0),
				rotation = Unit.local_rotation(arg_13_0, 0),
				health = ScriptUnit.extension(arg_13_0, "health_system"):get_max_health(),
				side_id = var_13_0
			}
		end,
		ai_unit_with_inventory = function (arg_14_0, arg_14_1, arg_14_2, arg_14_3)
			local var_14_0 = Unit.mover(arg_14_0)
			local var_14_1 = Unit.get_data(arg_14_0, "breed")
			local var_14_2, var_14_3 = ScriptUnit.extension(arg_14_0, "ai_system"):size_variation()
			local var_14_4 = ScriptUnit.extension(arg_14_0, "ai_inventory_system").inventory_configuration_name
			local var_14_5 = Managers.state.side.side_by_unit[arg_14_0].side_id
			local var_14_6 = Managers.state.entity:system("ai_group_system"):get_group_id(arg_14_0) or 0

			return {
				has_teleported = 1,
				go_type = NetworkLookup.go_types.ai_unit_with_inventory,
				husk_unit = NetworkLookup.husks[arg_14_1],
				health = ScriptUnit.extension(arg_14_0, "health_system"):get_max_health(),
				position = var_14_0 and Mover.position(var_14_0) or Unit.local_position(arg_14_0, 0),
				yaw_rot = Quaternion.yaw(Unit.local_rotation(arg_14_0, 0)),
				velocity = Vector3(0, 0, 0),
				breed_name = NetworkLookup.breeds[var_14_1.name],
				uniform_scale = var_14_2,
				inventory_configuration = NetworkLookup.ai_inventory[var_14_4],
				bt_action_name = NetworkLookup.bt_action_names["n/a"],
				side_id = var_14_5,
				ai_group_id = var_14_6 or AIGroupSystem.invalid_group_uid
			}
		end,
		ai_unit_with_inventory_and_shield = function (arg_15_0, arg_15_1, arg_15_2, arg_15_3)
			local var_15_0 = Unit.mover(arg_15_0)
			local var_15_1 = Unit.get_data(arg_15_0, "breed")
			local var_15_2, var_15_3 = ScriptUnit.extension(arg_15_0, "ai_system"):size_variation()
			local var_15_4 = ScriptUnit.extension(arg_15_0, "ai_inventory_system").inventory_configuration_name
			local var_15_5 = ScriptUnit.extension(arg_15_0, "ai_shield_system").is_blocking
			local var_15_6 = Managers.state.side.side_by_unit[arg_15_0].side_id
			local var_15_7 = Managers.state.entity:system("ai_group_system"):get_group_id(arg_15_0)

			return {
				has_teleported = 1,
				go_type = NetworkLookup.go_types.ai_unit_with_inventory_and_shield,
				husk_unit = NetworkLookup.husks[arg_15_1],
				health = ScriptUnit.extension(arg_15_0, "health_system"):get_max_health(),
				position = var_15_0 and Mover.position(var_15_0) or Unit.local_position(arg_15_0, 0),
				yaw_rot = Quaternion.yaw(Unit.local_rotation(arg_15_0, 0)),
				velocity = Vector3(0, 0, 0),
				breed_name = NetworkLookup.breeds[var_15_1.name],
				uniform_scale = var_15_2,
				inventory_configuration = NetworkLookup.ai_inventory[var_15_4],
				bt_action_name = NetworkLookup.bt_action_names["n/a"],
				is_blocking = var_15_5,
				side_id = var_15_6,
				ai_group_id = var_15_7 or AIGroupSystem.invalid_group_uid
			}
		end,
		ai_unit_storm_vermin_warlord = function (arg_16_0, arg_16_1, arg_16_2, arg_16_3)
			local var_16_0 = Unit.mover(arg_16_0)
			local var_16_1 = Unit.get_data(arg_16_0, "breed")
			local var_16_2, var_16_3 = ScriptUnit.extension(arg_16_0, "ai_system"):size_variation()
			local var_16_4 = ScriptUnit.extension(arg_16_0, "ai_inventory_system").inventory_configuration_name
			local var_16_5 = ScriptUnit.extension(arg_16_0, "ai_shield_system")
			local var_16_6 = var_16_5.is_blocking
			local var_16_7 = var_16_5.is_dodging
			local var_16_8 = Managers.state.side.side_by_unit[arg_16_0].side_id
			local var_16_9 = Managers.state.entity:system("ai_group_system"):get_group_id(arg_16_0)

			return {
				show_health_bar = false,
				has_teleported = 1,
				go_type = NetworkLookup.go_types.ai_unit_storm_vermin_warlord,
				husk_unit = NetworkLookup.husks[arg_16_1],
				health = ScriptUnit.extension(arg_16_0, "health_system"):get_max_health(),
				position = var_16_0 and Mover.position(var_16_0) or Unit.local_position(arg_16_0, 0),
				yaw_rot = Quaternion.yaw(Unit.local_rotation(arg_16_0, 0)),
				velocity = Vector3(0, 0, 0),
				breed_name = NetworkLookup.breeds[var_16_1.name],
				uniform_scale = var_16_2,
				inventory_configuration = NetworkLookup.ai_inventory[var_16_4],
				bt_action_name = NetworkLookup.bt_action_names["n/a"],
				is_blocking = var_16_6,
				is_dodging = var_16_7,
				side_id = var_16_8,
				ai_group_id = var_16_9 or AIGroupSystem.invalid_group_uid
			}
		end,
		ai_unit_chaos_troll = function (arg_17_0, arg_17_1, arg_17_2, arg_17_3)
			local var_17_0 = Unit.mover(arg_17_0)
			local var_17_1 = Unit.get_data(arg_17_0, "breed")
			local var_17_2, var_17_3 = ScriptUnit.extension(arg_17_0, "ai_system"):size_variation()
			local var_17_4 = ScriptUnit.extension(arg_17_0, "ai_inventory_system").inventory_configuration_name
			local var_17_5 = Managers.state.side.side_by_unit[arg_17_0].side_id
			local var_17_6 = Managers.state.entity:system("ai_group_system"):get_group_id(arg_17_0)

			return {
				has_teleported = 1,
				go_type = NetworkLookup.go_types.ai_unit_chaos_troll,
				husk_unit = NetworkLookup.husks[arg_17_1],
				health = ScriptUnit.extension(arg_17_0, "health_system"):get_max_health(),
				position = var_17_0 and Mover.position(var_17_0) or Unit.local_position(arg_17_0, 0),
				yaw_rot = Quaternion.yaw(Unit.local_rotation(arg_17_0, 0)),
				velocity = Vector3(0, 0, 0),
				breed_name = NetworkLookup.breeds[var_17_1.name],
				uniform_scale = var_17_2,
				inventory_configuration = NetworkLookup.ai_inventory[var_17_4],
				bt_action_name = NetworkLookup.bt_action_names["n/a"],
				side_id = var_17_5,
				ai_group_id = var_17_6 or AIGroupSystem.invalid_group_uid
			}
		end,
		ai_lord_with_inventory = function (arg_18_0, arg_18_1, arg_18_2, arg_18_3)
			local var_18_0 = Unit.mover(arg_18_0)
			local var_18_1 = Unit.get_data(arg_18_0, "breed")
			local var_18_2, var_18_3 = ScriptUnit.extension(arg_18_0, "ai_system"):size_variation()
			local var_18_4 = ScriptUnit.extension(arg_18_0, "ai_inventory_system").inventory_configuration_name
			local var_18_5 = Managers.state.side.side_by_unit[arg_18_0].side_id
			local var_18_6 = Managers.state.entity:system("ai_group_system"):get_group_id(arg_18_0)

			return {
				show_health_bar = false,
				has_teleported = 1,
				go_type = NetworkLookup.go_types.ai_lord_with_inventory,
				husk_unit = NetworkLookup.husks[arg_18_1],
				health = ScriptUnit.extension(arg_18_0, "health_system"):get_max_health(),
				position = var_18_0 and Mover.position(var_18_0) or Unit.local_position(arg_18_0, 0),
				yaw_rot = Quaternion.yaw(Unit.local_rotation(arg_18_0, 0)),
				velocity = Vector3(0, 0, 0),
				breed_name = NetworkLookup.breeds[var_18_1.name],
				uniform_scale = var_18_2,
				inventory_configuration = NetworkLookup.ai_inventory[var_18_4],
				bt_action_name = NetworkLookup.bt_action_names["n/a"],
				side_id = var_18_5,
				ai_group_id = var_18_6 or AIGroupSystem.invalid_group_uid
			}
		end,
		ai_unit_pack_master = function (arg_19_0, arg_19_1, arg_19_2, arg_19_3)
			local var_19_0 = Unit.mover(arg_19_0)
			local var_19_1 = Unit.get_data(arg_19_0, "breed")
			local var_19_2, var_19_3 = ScriptUnit.extension(arg_19_0, "ai_system"):size_variation()
			local var_19_4 = ScriptUnit.extension(arg_19_0, "ai_inventory_system").inventory_configuration_name
			local var_19_5 = Managers.state.side.side_by_unit[arg_19_0].side_id

			return {
				has_teleported = 1,
				go_type = NetworkLookup.go_types.ai_unit_pack_master,
				husk_unit = NetworkLookup.husks[arg_19_1],
				health = ScriptUnit.extension(arg_19_0, "health_system"):get_max_health(),
				position = var_19_0 and Mover.position(var_19_0) or Unit.local_position(arg_19_0, 0),
				yaw_rot = Quaternion.yaw(Unit.local_rotation(arg_19_0, 0)),
				velocity = Vector3(0, 0, 0),
				breed_name = NetworkLookup.breeds[var_19_1.name],
				uniform_scale = var_19_2,
				inventory_configuration = NetworkLookup.ai_inventory[var_19_4],
				aim_target = Vector3.zero(),
				bt_action_name = NetworkLookup.bt_action_names["n/a"],
				side_id = var_19_5
			}
		end,
		ai_unit_ratling_gunner = function (arg_20_0, arg_20_1, arg_20_2, arg_20_3)
			local var_20_0 = Unit.mover(arg_20_0)
			local var_20_1 = Unit.get_data(arg_20_0, "breed")
			local var_20_2, var_20_3 = ScriptUnit.extension(arg_20_0, "ai_system"):size_variation()
			local var_20_4 = ScriptUnit.extension(arg_20_0, "ai_inventory_system").inventory_configuration_name
			local var_20_5 = Managers.state.side.side_by_unit[arg_20_0].side_id
			local var_20_6 = Managers.state.entity:system("ai_group_system"):get_group_id(arg_20_0)

			return {
				has_teleported = 1,
				go_type = NetworkLookup.go_types.ai_unit_ratling_gunner,
				husk_unit = NetworkLookup.husks[arg_20_1],
				health = ScriptUnit.extension(arg_20_0, "health_system"):get_max_health(),
				position = var_20_0 and Mover.position(var_20_0) or Unit.local_position(arg_20_0, 0),
				yaw_rot = Quaternion.yaw(Unit.local_rotation(arg_20_0, 0)),
				velocity = Vector3(0, 0, 0),
				breed_name = NetworkLookup.breeds[var_20_1.name],
				uniform_scale = var_20_2,
				inventory_configuration = NetworkLookup.ai_inventory[var_20_4],
				aim_target = Vector3.zero(),
				bt_action_name = NetworkLookup.bt_action_names["n/a"],
				side_id = var_20_5,
				ai_group_id = var_20_6 or AIGroupSystem.invalid_group_uid
			}
		end,
		ai_unit_warpfire_thrower = function (arg_21_0, arg_21_1, arg_21_2, arg_21_3)
			local var_21_0 = Unit.mover(arg_21_0)
			local var_21_1 = Unit.get_data(arg_21_0, "breed")
			local var_21_2, var_21_3 = ScriptUnit.extension(arg_21_0, "ai_system"):size_variation()
			local var_21_4 = ScriptUnit.extension(arg_21_0, "ai_inventory_system").inventory_configuration_name
			local var_21_5 = Managers.state.side.side_by_unit[arg_21_0].side_id
			local var_21_6 = Managers.state.entity:system("ai_group_system"):get_group_id(arg_21_0)

			return {
				has_teleported = 1,
				go_type = NetworkLookup.go_types.ai_unit_warpfire_thrower,
				husk_unit = NetworkLookup.husks[arg_21_1],
				health = ScriptUnit.extension(arg_21_0, "health_system"):get_max_health(),
				position = var_21_0 and Mover.position(var_21_0) or Unit.local_position(arg_21_0, 0),
				yaw_rot = Quaternion.yaw(Unit.local_rotation(arg_21_0, 0)),
				velocity = Vector3(0, 0, 0),
				breed_name = NetworkLookup.breeds[var_21_1.name],
				uniform_scale = var_21_2,
				inventory_configuration = NetworkLookup.ai_inventory[var_21_4],
				aim_target = Vector3.zero(),
				bt_action_name = NetworkLookup.bt_action_names["n/a"],
				side_id = var_21_5,
				ai_group_id = var_21_6 or AIGroupSystem.invalid_group_uid
			}
		end,
		ai_unit_stormfiend = function (arg_22_0, arg_22_1, arg_22_2, arg_22_3)
			local var_22_0 = Unit.mover(arg_22_0)
			local var_22_1 = Unit.get_data(arg_22_0, "breed")
			local var_22_2, var_22_3 = ScriptUnit.extension(arg_22_0, "ai_system"):size_variation()
			local var_22_4 = ScriptUnit.extension(arg_22_0, "ai_inventory_system").inventory_configuration_name
			local var_22_5 = Managers.state.side.side_by_unit[arg_22_0].side_id
			local var_22_6 = Managers.state.entity:system("ai_group_system"):get_group_id(arg_22_0)

			return {
				attack_arm = 1,
				has_teleported = 1,
				go_type = NetworkLookup.go_types.ai_unit_stormfiend,
				husk_unit = NetworkLookup.husks[arg_22_1],
				health = ScriptUnit.extension(arg_22_0, "health_system"):get_max_health(),
				position = var_22_0 and Mover.position(var_22_0) or Unit.local_position(arg_22_0, 0),
				yaw_rot = Quaternion.yaw(Unit.local_rotation(arg_22_0, 0)),
				velocity = Vector3.zero(),
				breed_name = NetworkLookup.breeds[var_22_1.name],
				uniform_scale = var_22_2,
				inventory_configuration = NetworkLookup.ai_inventory[var_22_4],
				aim_target = Vector3.zero(),
				bt_action_name = NetworkLookup.bt_action_names["n/a"],
				side_id = var_22_5,
				ai_group_id = var_22_6 or AIGroupSystem.invalid_group_uid
			}
		end,
		ai_unit_stormfiend_boss = function (arg_23_0, arg_23_1, arg_23_2, arg_23_3)
			local var_23_0 = Unit.mover(arg_23_0)
			local var_23_1 = Unit.get_data(arg_23_0, "breed")
			local var_23_2, var_23_3 = ScriptUnit.extension(arg_23_0, "ai_system"):size_variation()
			local var_23_4 = ScriptUnit.extension(arg_23_0, "ai_inventory_system").inventory_configuration_name
			local var_23_5 = Managers.state.side.side_by_unit[arg_23_0].side_id
			local var_23_6 = Managers.state.entity:system("ai_group_system"):get_group_id(arg_23_0)

			return {
				show_health_bar = false,
				attack_arm = 1,
				has_teleported = 1,
				go_type = NetworkLookup.go_types.ai_unit_stormfiend,
				husk_unit = NetworkLookup.husks[arg_23_1],
				health = ScriptUnit.extension(arg_23_0, "health_system"):get_max_health(),
				position = var_23_0 and Mover.position(var_23_0) or Unit.local_position(arg_23_0, 0),
				yaw_rot = Quaternion.yaw(Unit.local_rotation(arg_23_0, 0)),
				velocity = Vector3.zero(),
				breed_name = NetworkLookup.breeds[var_23_1.name],
				uniform_scale = var_23_2,
				inventory_configuration = NetworkLookup.ai_inventory[var_23_4],
				aim_target = Vector3.zero(),
				bt_action_name = NetworkLookup.bt_action_names["n/a"],
				side_id = var_23_5,
				ai_group_id = var_23_6 or AIGroupSystem.invalid_group_uid
			}
		end,
		player_projectile_unit = function (arg_24_0, arg_24_1, arg_24_2, arg_24_3)
			local var_24_0 = ScriptUnit.extension(arg_24_0, "projectile_locomotion_system")
			local var_24_1 = var_24_0.angle
			local var_24_2 = var_24_0.target_vector
			local var_24_3 = var_24_0.initial_position_boxed:unbox()
			local var_24_4 = var_24_0.speed
			local var_24_5 = var_24_0.gravity_settings
			local var_24_6 = var_24_0.trajectory_template_name
			local var_24_7 = var_24_0.rotation_speed
			local var_24_8 = -(var_24_0.t - Managers.time:time("game"))
			local var_24_9 = ScriptUnit.extension(arg_24_0, "projectile_impact_system").owner_unit
			local var_24_10 = ScriptUnit.extension(arg_24_0, "projectile_system")
			local var_24_11 = var_24_10.item_name
			local var_24_12 = var_24_10.action_lookup_data.item_template_name
			local var_24_13 = var_24_10.action_lookup_data.action_name
			local var_24_14 = var_24_10.action_lookup_data.sub_action_name
			local var_24_15 = var_24_10.scale * 100
			local var_24_16 = var_24_10.power_level

			return {
				go_type = NetworkLookup.go_types.player_projectile_unit,
				husk_unit = NetworkLookup.husks[arg_24_1],
				position = Unit.local_position(arg_24_0, 0),
				rotation = Unit.local_rotation(arg_24_0, 0),
				angle = var_24_1,
				initial_position = var_24_3,
				target_vector = var_24_2,
				speed = var_24_4,
				gravity_settings = NetworkLookup.projectile_gravity_settings[var_24_5],
				trajectory_template_name = NetworkLookup.projectile_templates[var_24_6],
				owner_unit = Unit.alive(var_24_9) and Managers.state.network:unit_game_object_id(var_24_9) or 0,
				item_name = NetworkLookup.item_names[var_24_11],
				item_template_name = NetworkLookup.item_template_names[var_24_12],
				action_name = NetworkLookup.actions[var_24_13],
				sub_action_name = NetworkLookup.sub_actions[var_24_14],
				scale = var_24_15,
				fast_forward_time = var_24_8,
				rotation_speed = var_24_7,
				power_level = var_24_16
			}
		end,
		sticky_projectile_unit = function (arg_25_0, arg_25_1, arg_25_2, arg_25_3)
			local var_25_0 = ScriptUnit.extension(arg_25_0, "projectile_locomotion_system")
			local var_25_1 = var_25_0.target_vector
			local var_25_2 = var_25_0.initial_position_boxed:unbox()
			local var_25_3 = var_25_0.speed
			local var_25_4 = var_25_0.target_unit
			local var_25_5 = var_25_0.stopped
			local var_25_6 = var_25_0.seed
			local var_25_7 = ScriptUnit.extension(arg_25_0, "projectile_impact_system").owner_unit
			local var_25_8 = ScriptUnit.extension(arg_25_0, "projectile_system")
			local var_25_9 = var_25_8.item_name
			local var_25_10 = var_25_8.action_lookup_data.item_template_name
			local var_25_11 = var_25_8.action_lookup_data.action_name
			local var_25_12 = var_25_8.action_lookup_data.sub_action_name
			local var_25_13 = var_25_8.scale * 100
			local var_25_14 = var_25_8.power_level
			local var_25_15 = var_25_8.charge_level * 100

			return {
				go_type = NetworkLookup.go_types.sticky_projectile_unit,
				husk_unit = NetworkLookup.husks[arg_25_1],
				position = Unit.local_position(arg_25_0, 0),
				rotation = Unit.local_rotation(arg_25_0, 0),
				initial_position = var_25_2,
				target_vector = var_25_1,
				speed = var_25_3,
				owner_unit = Unit.alive(var_25_7) and Managers.state.network:unit_game_object_id(var_25_7) or 0,
				item_name = NetworkLookup.item_names[var_25_9],
				item_template_name = NetworkLookup.item_template_names[var_25_10],
				action_name = NetworkLookup.actions[var_25_11],
				sub_action_name = NetworkLookup.sub_actions[var_25_12],
				scale = var_25_13,
				power_level = var_25_14,
				target_unit = Unit.alive(var_25_4) and Managers.state.network:unit_game_object_id(var_25_4) or 0,
				stopped = var_25_5,
				seed = var_25_6,
				charge_level = var_25_15
			}
		end,
		player_projectile_physic_unit = function (arg_26_0, arg_26_1, arg_26_2, arg_26_3)
			local var_26_0 = ScriptUnit.extension(arg_26_0, "projectile_locomotion_system")
			local var_26_1 = var_26_0.owner_unit
			local var_26_2 = var_26_0.network_position
			local var_26_3 = var_26_0.network_rotation
			local var_26_4 = var_26_0.network_velocity
			local var_26_5 = var_26_0.network_angular_velocity
			local var_26_6 = ScriptUnit.extension(arg_26_0, "projectile_impact_system")
			local var_26_7 = var_26_6.collision_filter
			local var_26_8 = var_26_6.owner_unit
			local var_26_9 = ScriptUnit.extension(arg_26_0, "projectile_system")
			local var_26_10 = var_26_9.item_name
			local var_26_11 = var_26_9.action_lookup_data.item_template_name
			local var_26_12 = var_26_9.action_lookup_data.action_name
			local var_26_13 = var_26_9.action_lookup_data.sub_action_name
			local var_26_14 = var_26_9.time_initialized
			local var_26_15 = var_26_9.scale * 100

			return {
				go_type = NetworkLookup.go_types.player_projectile_physic_unit,
				husk_unit = NetworkLookup.husks[arg_26_1],
				position = Unit.local_position(arg_26_0, 0),
				rotation = Unit.local_rotation(arg_26_0, 0),
				collision_filter = NetworkLookup.collision_filters[var_26_7],
				owner_unit = Managers.state.network:unit_game_object_id(var_26_8),
				item_name = NetworkLookup.item_names[var_26_10],
				item_template_name = NetworkLookup.item_template_names[var_26_11],
				action_name = NetworkLookup.actions[var_26_12],
				sub_action_name = NetworkLookup.sub_actions[var_26_13],
				scale = var_26_15
			}
		end,
		prop_projectile_unit = function (arg_27_0, arg_27_1, arg_27_2, arg_27_3)
			local var_27_0 = ScriptUnit.extension(arg_27_0, "projectile_locomotion_system")
			local var_27_1 = var_27_0.network_position
			local var_27_2 = var_27_0.network_rotation
			local var_27_3 = var_27_0.network_velocity
			local var_27_4 = var_27_0.network_angular_velocity

			return {
				go_type = NetworkLookup.go_types.prop_projectile_unit,
				husk_unit = NetworkLookup.husks[arg_27_1],
				position = Unit.local_position(arg_27_0, 0),
				rotation = Unit.local_rotation(arg_27_0, 0),
				network_position = var_27_1,
				network_rotation = var_27_2,
				network_velocity = var_27_3,
				network_angular_velocity = var_27_4,
				debug_pos = Unit.local_position(arg_27_0, 0)
			}
		end,
		pickup_projectile_unit = function (arg_28_0, arg_28_1, arg_28_2, arg_28_3)
			local var_28_0 = ScriptUnit.extension(arg_28_0, "projectile_locomotion_system")
			local var_28_1 = var_28_0.network_position
			local var_28_2 = var_28_0.network_rotation
			local var_28_3 = var_28_0.network_velocity
			local var_28_4 = var_28_0.network_angular_velocity
			local var_28_5 = ScriptUnit.extension(arg_28_0, "pickup_system")
			local var_28_6 = var_28_5.pickup_name
			local var_28_7 = var_28_5.has_physics
			local var_28_8 = var_28_5.spawn_type

			return {
				go_type = NetworkLookup.go_types.pickup_projectile_unit,
				husk_unit = NetworkLookup.husks[arg_28_1],
				position = Unit.local_position(arg_28_0, 0),
				rotation = Unit.local_rotation(arg_28_0, 0),
				network_position = var_28_1,
				network_rotation = var_28_2,
				network_velocity = var_28_3,
				network_angular_velocity = var_28_4,
				debug_pos = Unit.local_position(arg_28_0, 0),
				pickup_name = NetworkLookup.pickup_names[var_28_6],
				has_physics = var_28_7,
				spawn_type = NetworkLookup.pickup_spawn_types[var_28_8]
			}
		end,
		limited_owned_pickup_projectile_unit = function (arg_29_0, arg_29_1, arg_29_2, arg_29_3)
			local var_29_0 = ScriptUnit.extension(arg_29_0, "projectile_locomotion_system")
			local var_29_1 = var_29_0.network_position
			local var_29_2 = var_29_0.network_rotation
			local var_29_3 = var_29_0.network_velocity
			local var_29_4 = var_29_0.network_angular_velocity
			local var_29_5 = ScriptUnit.extension(arg_29_0, "pickup_system")
			local var_29_6 = var_29_5.pickup_name
			local var_29_7 = var_29_5.has_physics
			local var_29_8 = var_29_5.spawn_type
			local var_29_9 = var_29_5.owner_peer_id
			local var_29_10 = var_29_5.spawn_limit

			return {
				go_type = NetworkLookup.go_types.limited_owned_pickup_projectile_unit,
				husk_unit = NetworkLookup.husks[arg_29_1],
				position = Unit.local_position(arg_29_0, 0),
				rotation = Unit.local_rotation(arg_29_0, 0),
				network_position = var_29_1,
				network_rotation = var_29_2,
				network_velocity = var_29_3,
				network_angular_velocity = var_29_4,
				debug_pos = Unit.local_position(arg_29_0, 0),
				pickup_name = NetworkLookup.pickup_names[var_29_6],
				has_physics = var_29_7,
				spawn_type = NetworkLookup.pickup_spawn_types[var_29_8],
				owner_peer_id = var_29_9,
				spawn_limit = var_29_10
			}
		end,
		life_time_pickup_projectile_unit = function (arg_30_0, arg_30_1, arg_30_2, arg_30_3)
			local var_30_0 = ScriptUnit.extension(arg_30_0, "projectile_locomotion_system")
			local var_30_1 = var_30_0.network_position
			local var_30_2 = var_30_0.network_rotation
			local var_30_3 = var_30_0.network_velocity
			local var_30_4 = var_30_0.network_angular_velocity
			local var_30_5 = ScriptUnit.extension(arg_30_0, "pickup_system")
			local var_30_6 = var_30_5.pickup_name
			local var_30_7 = var_30_5.has_physics
			local var_30_8 = var_30_5.spawn_type

			return {
				go_type = NetworkLookup.go_types.life_time_pickup_projectile_unit,
				husk_unit = NetworkLookup.husks[arg_30_1],
				position = Unit.local_position(arg_30_0, 0),
				rotation = Unit.local_rotation(arg_30_0, 0),
				network_position = var_30_1,
				network_rotation = var_30_2,
				network_velocity = var_30_3,
				network_angular_velocity = var_30_4,
				debug_pos = Unit.local_position(arg_30_0, 0),
				pickup_name = NetworkLookup.pickup_names[var_30_6],
				has_physics = var_30_7,
				spawn_type = NetworkLookup.pickup_spawn_types[var_30_8]
			}
		end,
		pickup_training_dummy_unit = function (arg_31_0, arg_31_1, arg_31_2, arg_31_3)
			local var_31_0 = ScriptUnit.extension(arg_31_0, "projectile_locomotion_system")
			local var_31_1 = var_31_0.network_position
			local var_31_2 = var_31_0.network_rotation
			local var_31_3 = var_31_0.network_velocity
			local var_31_4 = var_31_0.network_angular_velocity
			local var_31_5 = ScriptUnit.extension(arg_31_0, "pickup_system")
			local var_31_6 = var_31_5.pickup_name
			local var_31_7 = var_31_5.has_physics
			local var_31_8 = var_31_5.spawn_type

			return {
				damage = 0,
				go_type = NetworkLookup.go_types.pickup_training_dummy_unit,
				husk_unit = NetworkLookup.husks[arg_31_1],
				position = Unit.local_position(arg_31_0, 0),
				rotation = Unit.local_rotation(arg_31_0, 0),
				network_position = var_31_1,
				network_rotation = var_31_2,
				network_velocity = var_31_3,
				network_angular_velocity = var_31_4,
				pickup_name = NetworkLookup.pickup_names[var_31_6],
				has_physics = var_31_7,
				spawn_type = NetworkLookup.pickup_spawn_types[var_31_8]
			}
		end,
		versus_volume_objective_unit = function (arg_32_0, arg_32_1, arg_32_2, arg_32_3)
			local var_32_0 = ScriptUnit.extension(arg_32_0, "objective_system"):objective_name()

			return {
				go_type = NetworkLookup.go_types.versus_volume_objective_unit,
				husk_unit = NetworkLookup.husks[arg_32_1],
				position = Unit.local_position(arg_32_0, 0),
				rotation = Unit.local_rotation(arg_32_0, 0),
				scale = Unit.local_scale(arg_32_0, 0)[1],
				objective_name = NetworkLookup.objective_names[var_32_0]
			}
		end,
		versus_capture_point_objective_unit = function (arg_33_0, arg_33_1, arg_33_2, arg_33_3)
			local var_33_0 = ScriptUnit.extension(arg_33_0, "objective_system")
			local var_33_1 = var_33_0:objective_name()

			return {
				go_type = NetworkLookup.go_types.versus_capture_point_objective_unit,
				husk_unit = NetworkLookup.husks[arg_33_1],
				position = Unit.local_position(arg_33_0, 0),
				rotation = Unit.local_rotation(arg_33_0, 0),
				scale = Unit.local_scale(arg_33_0, 0)[1],
				objective_name = NetworkLookup.objective_names[var_33_1],
				timer = var_33_0._timer
			}
		end,
		versus_mission_objective_unit = function (arg_34_0, arg_34_1, arg_34_2, arg_34_3)
			local var_34_0 = ScriptUnit.extension(arg_34_0, "objective_system"):objective_name()

			return {
				go_type = NetworkLookup.go_types.versus_mission_objective_unit,
				husk_unit = NetworkLookup.husks[arg_34_1],
				position = Unit.local_position(arg_34_0, 0),
				rotation = Unit.local_rotation(arg_34_0, 0),
				scale = Unit.local_scale(arg_34_0, 0)[1],
				objective_name = NetworkLookup.objective_names[var_34_0]
			}
		end,
		weave_capture_point_unit = function (arg_35_0, arg_35_1, arg_35_2, arg_35_3)
			local var_35_0 = ScriptUnit.extension(arg_35_0, "objective_system")
			local var_35_1 = var_35_0:objective_name()

			return {
				go_type = NetworkLookup.go_types.weave_capture_point_unit,
				husk_unit = NetworkLookup.husks[arg_35_1],
				position = Unit.local_position(arg_35_0, 0),
				rotation = Unit.local_rotation(arg_35_0, 0),
				scale = Unit.local_scale(arg_35_0, 0)[1],
				objective_name = NetworkLookup.objective_names[var_35_1],
				timer = var_35_0._timer
			}
		end,
		weave_target_unit = function (arg_36_0, arg_36_1, arg_36_2, arg_36_3)
			local var_36_0 = ScriptUnit.extension(arg_36_0, "objective_system")
			local var_36_1 = ScriptUnit.extension(arg_36_0, "health_system"):current_health()
			local var_36_2 = var_36_0:objective_name()
			local var_36_3 = var_36_0:attacks_allowed()

			return {
				go_type = NetworkLookup.go_types.weave_target_unit,
				husk_unit = NetworkLookup.husks[arg_36_1],
				position = Unit.local_position(arg_36_0, 0),
				rotation = Unit.local_rotation(arg_36_0, 0),
				objective_name = NetworkLookup.objective_names[var_36_2],
				health = var_36_1,
				allow_melee_damage = var_36_3.melee,
				allow_ranged_damage = var_36_3.ranged
			}
		end,
		weave_interaction_unit = function (arg_37_0, arg_37_1, arg_37_2, arg_37_3)
			local var_37_0 = ScriptUnit.extension(arg_37_0, "objective_system")
			local var_37_1 = var_37_0:objective_name()

			return {
				go_type = NetworkLookup.go_types.weave_interaction_unit,
				husk_unit = NetworkLookup.husks[arg_37_1],
				position = Unit.local_position(arg_37_0, 0),
				rotation = Unit.local_rotation(arg_37_0, 0),
				objective_name = NetworkLookup.objective_names[var_37_1],
				num_times_to_complete = var_37_0._num_times_to_complete,
				duration = var_37_0._duration
			}
		end,
		weave_doom_wheel_unit = function (arg_38_0, arg_38_1, arg_38_2, arg_38_3)
			local var_38_0 = ScriptUnit.extension(arg_38_0, "objective_system"):objective_name()

			return {
				go_type = NetworkLookup.go_types.weave_doom_wheel_unit,
				husk_unit = NetworkLookup.husks[arg_38_1],
				position = Unit.local_position(arg_38_0, 0),
				rotation = Unit.local_rotation(arg_38_0, 0),
				objective_name = NetworkLookup.objective_names[var_38_0]
			}
		end,
		pickup_torch_unit_init = function (arg_39_0, arg_39_1, arg_39_2, arg_39_3)
			return
		end,
		weave_kill_enemies_unit = function (arg_40_0, arg_40_1, arg_40_2, arg_40_3)
			local var_40_0 = ScriptUnit.extension(arg_40_0, "objective_system")
			local var_40_1 = var_40_0:objective_name()

			return {
				go_type = NetworkLookup.go_types.weave_kill_enemies_unit,
				husk_unit = NetworkLookup.husks[arg_40_1],
				position = Unit.local_position(arg_40_0, 0),
				rotation = Unit.local_rotation(arg_40_0, 0),
				objective_name = NetworkLookup.objective_names[var_40_1],
				amount = var_40_0._kills_required
			}
		end,
		pickup_torch_unit_init = function (arg_41_0, arg_41_1, arg_41_2, arg_41_3)
			local var_41_0 = ScriptUnit.extension(arg_41_0, "projectile_locomotion_system")
			local var_41_1 = var_41_0.network_position
			local var_41_2 = var_41_0.network_rotation
			local var_41_3 = var_41_0.network_velocity
			local var_41_4 = var_41_0.network_angular_velocity
			local var_41_5 = ScriptUnit.extension(arg_41_0, "pickup_system")
			local var_41_6 = var_41_5.pickup_name
			local var_41_7 = var_41_5.has_physics
			local var_41_8 = var_41_5.spawn_type

			return {
				go_type = NetworkLookup.go_types.pickup_torch_unit,
				husk_unit = NetworkLookup.husks[arg_41_1],
				position = Unit.local_position(arg_41_0, 0),
				rotation = Unit.local_rotation(arg_41_0, 0),
				network_position = var_41_1,
				network_rotation = var_41_2,
				network_velocity = var_41_3,
				network_angular_velocity = var_41_4,
				debug_pos = Unit.local_position(arg_41_0, 0),
				pickup_name = NetworkLookup.pickup_names[var_41_6],
				has_physics = var_41_7,
				spawn_type = NetworkLookup.pickup_spawn_types[var_41_8]
			}
		end,
		pickup_torch_unit = function (arg_42_0, arg_42_1, arg_42_2, arg_42_3)
			local var_42_0 = ScriptUnit.extension(arg_42_0, "projectile_locomotion_system")
			local var_42_1 = var_42_0.network_position
			local var_42_2 = var_42_0.network_rotation
			local var_42_3 = var_42_0.network_velocity
			local var_42_4 = var_42_0.network_angular_velocity
			local var_42_5 = ScriptUnit.extension(arg_42_0, "pickup_system")
			local var_42_6 = var_42_5.pickup_name
			local var_42_7 = var_42_5.has_physics
			local var_42_8 = var_42_5.spawn_type

			return {
				go_type = NetworkLookup.go_types.pickup_torch_unit,
				husk_unit = NetworkLookup.husks[arg_42_1],
				position = Unit.local_position(arg_42_0, 0),
				rotation = Unit.local_rotation(arg_42_0, 0),
				network_position = var_42_1,
				network_rotation = var_42_2,
				network_velocity = var_42_3,
				network_angular_velocity = var_42_4,
				debug_pos = Unit.local_position(arg_42_0, 0),
				pickup_name = NetworkLookup.pickup_names[var_42_6],
				has_physics = var_42_7,
				spawn_type = NetworkLookup.pickup_spawn_types[var_42_8]
			}
		end,
		pickup_projectile_unit_limited = function (arg_43_0, arg_43_1, arg_43_2, arg_43_3)
			local var_43_0 = ScriptUnit.extension(arg_43_0, "projectile_locomotion_system")
			local var_43_1 = var_43_0.network_position
			local var_43_2 = var_43_0.network_rotation
			local var_43_3 = var_43_0.network_velocity
			local var_43_4 = var_43_0.network_angular_velocity
			local var_43_5 = ScriptUnit.extension(arg_43_0, "pickup_system")
			local var_43_6 = var_43_5.pickup_name
			local var_43_7 = var_43_5.owner_peer_id
			local var_43_8 = var_43_5.has_physics
			local var_43_9 = var_43_5.spawn_type
			local var_43_10 = ScriptUnit.extension(arg_43_0, "limited_item_track_system")
			local var_43_11 = var_43_10.spawner_unit
			local var_43_12 = var_43_10.id
			local var_43_13, var_43_14 = Managers.state.network:game_object_or_level_id(var_43_11)

			return {
				go_type = NetworkLookup.go_types.pickup_projectile_unit_limited,
				husk_unit = NetworkLookup.husks[arg_43_1],
				position = Unit.local_position(arg_43_0, 0),
				rotation = Unit.local_rotation(arg_43_0, 0),
				network_position = var_43_1,
				network_rotation = var_43_2,
				network_velocity = var_43_3,
				network_angular_velocity = var_43_4,
				debug_pos = Unit.local_position(arg_43_0, 0),
				spawner_unit = var_43_13 or NetworkConstants.invalid_game_object_id,
				spawner_unit_is_level_unit = var_43_14 or false,
				limited_item_id = var_43_12,
				pickup_name = NetworkLookup.pickup_names[var_43_6],
				owner_peer_id = var_43_7,
				has_physics = var_43_8,
				spawn_type = NetworkLookup.pickup_spawn_types[var_43_9]
			}
		end,
		explosive_pickup_projectile_unit = function (arg_44_0, arg_44_1, arg_44_2, arg_44_3)
			local var_44_0 = ScriptUnit.extension(arg_44_0, "projectile_locomotion_system")
			local var_44_1 = var_44_0.network_position
			local var_44_2 = var_44_0.network_rotation
			local var_44_3 = var_44_0.network_velocity
			local var_44_4 = var_44_0.network_angular_velocity
			local var_44_5 = ScriptUnit.extension(arg_44_0, "pickup_system")
			local var_44_6 = var_44_5.pickup_name
			local var_44_7 = var_44_5.has_physics
			local var_44_8 = var_44_5.spawn_type
			local var_44_9 = ScriptUnit.extension(arg_44_0, "health_system")
			local var_44_10 = var_44_9.damage
			local var_44_11 = ScriptUnit.extension(arg_44_0, "death_system")
			local var_44_12 = 0
			local var_44_13 = 0
			local var_44_14 = ScriptUnit.extension(arg_44_0, "tutorial_system").always_show or false

			if var_44_9.ignited then
				local var_44_15 = var_44_9:health_data()

				var_44_12 = var_44_15.explode_time
				var_44_13 = var_44_15.fuse_time
			end

			local var_44_16 = var_44_11.item_name or AllPickups[var_44_6].item_name

			return {
				go_type = NetworkLookup.go_types.explosive_pickup_projectile_unit,
				husk_unit = NetworkLookup.husks[arg_44_1],
				position = Unit.local_position(arg_44_0, 0),
				rotation = Unit.local_rotation(arg_44_0, 0),
				network_position = var_44_1,
				network_rotation = var_44_2,
				network_velocity = var_44_3,
				network_angular_velocity = var_44_4,
				debug_pos = Unit.local_position(arg_44_0, 0),
				pickup_name = NetworkLookup.pickup_names[var_44_6],
				has_physics = var_44_7,
				spawn_type = NetworkLookup.pickup_spawn_types[var_44_8],
				damage = var_44_10,
				explode_time = var_44_12,
				fuse_time = var_44_13,
				item_name = NetworkLookup.item_names[var_44_16],
				always_show = var_44_14
			}
		end,
		explosive_pickup_projectile_unit_limited = function (arg_45_0, arg_45_1, arg_45_2, arg_45_3)
			local var_45_0 = ScriptUnit.extension(arg_45_0, "projectile_locomotion_system")
			local var_45_1 = var_45_0.network_position
			local var_45_2 = var_45_0.network_rotation
			local var_45_3 = var_45_0.network_velocity
			local var_45_4 = var_45_0.network_angular_velocity
			local var_45_5 = ScriptUnit.extension(arg_45_0, "pickup_system")
			local var_45_6 = var_45_5.pickup_name
			local var_45_7 = var_45_5.has_physics
			local var_45_8 = var_45_5.spawn_type
			local var_45_9 = ScriptUnit.extension(arg_45_0, "limited_item_track_system")
			local var_45_10 = var_45_9.spawner_unit
			local var_45_11 = var_45_9.id
			local var_45_12 = ScriptUnit.extension(arg_45_0, "health_system")
			local var_45_13 = var_45_12.damage
			local var_45_14 = ScriptUnit.extension(arg_45_0, "death_system")
			local var_45_15 = 0
			local var_45_16 = 0
			local var_45_17 = ScriptUnit.extension(arg_45_0, "tutorial_system").always_show or false

			if var_45_12.ignited then
				local var_45_18 = var_45_12:health_data()

				var_45_15 = var_45_18.explode_time
				var_45_16 = var_45_18.fuse_time
			end

			local var_45_19 = var_45_14.item_name or AllPickups[var_45_6].item_name
			local var_45_20, var_45_21 = Managers.state.network:game_object_or_level_id(var_45_10)

			return {
				go_type = NetworkLookup.go_types.explosive_pickup_projectile_unit_limited,
				husk_unit = NetworkLookup.husks[arg_45_1],
				position = Unit.local_position(arg_45_0, 0),
				rotation = Unit.local_rotation(arg_45_0, 0),
				network_position = var_45_1,
				network_rotation = var_45_2,
				network_velocity = var_45_3,
				network_angular_velocity = var_45_4,
				debug_pos = Unit.local_position(arg_45_0, 0),
				pickup_name = NetworkLookup.pickup_names[var_45_6],
				has_physics = var_45_7,
				spawn_type = NetworkLookup.pickup_spawn_types[var_45_8],
				spawner_unit = var_45_20 or NetworkConstants.invalid_game_object_id,
				spawner_unit_is_level_unit = var_45_21 or false,
				limited_item_id = var_45_11,
				damage = var_45_13,
				explode_time = var_45_15,
				fuse_time = var_45_16,
				item_name = NetworkLookup.item_names[var_45_19],
				always_show = var_45_17
			}
		end,
		true_flight_projectile_unit = function (arg_46_0, arg_46_1, arg_46_2, arg_46_3)
			local var_46_0 = ScriptUnit.extension(arg_46_0, "projectile_locomotion_system")
			local var_46_1 = var_46_0.true_flight_template_name
			local var_46_2 = var_46_0.angle
			local var_46_3 = var_46_0.target_vector
			local var_46_4 = var_46_0.speed
			local var_46_5 = var_46_0.gravity_settings
			local var_46_6 = var_46_0.initial_position_boxed:unbox()
			local var_46_7 = var_46_0.trajectory_template_name
			local var_46_8 = NetworkConstants.game_object_id_max

			if var_46_0.target_unit then
				var_46_8 = Managers.state.network:unit_game_object_id(var_46_0.target_unit)
			end

			local var_46_9 = ScriptUnit.extension(arg_46_0, "projectile_impact_system")
			local var_46_10 = var_46_9.server_side_raycast
			local var_46_11 = var_46_9.collision_filter
			local var_46_12 = var_46_9.owner_unit
			local var_46_13 = ScriptUnit.extension(arg_46_0, "projectile_system")
			local var_46_14 = var_46_13.item_name
			local var_46_15 = var_46_13.action_lookup_data.item_template_name
			local var_46_16 = var_46_13.action_lookup_data.action_name
			local var_46_17 = var_46_13.action_lookup_data.sub_action_name
			local var_46_18 = var_46_13.time_initialized
			local var_46_19 = var_46_13.scale * 100
			local var_46_20 = var_46_13.power_level

			return {
				go_type = NetworkLookup.go_types.true_flight_projectile_unit,
				husk_unit = NetworkLookup.husks[arg_46_1],
				position = Unit.local_position(arg_46_0, 0),
				rotation = Unit.local_rotation(arg_46_0, 0),
				true_flight_template_id = TrueFlightTemplates[var_46_1].lookup_id,
				target_unit_id = var_46_8,
				angle = var_46_2,
				initial_position = var_46_6,
				target_vector = var_46_3,
				speed = var_46_4,
				gravity_settings = NetworkLookup.projectile_gravity_settings[var_46_5],
				trajectory_template_id = NetworkLookup.projectile_templates[var_46_7],
				collision_filter = NetworkLookup.collision_filters[var_46_11],
				server_side_raycast = var_46_10,
				owner_unit = Managers.state.network:unit_game_object_id(var_46_12),
				item_name = NetworkLookup.item_names[var_46_14],
				item_template_name = NetworkLookup.item_template_names[var_46_15],
				action_name = NetworkLookup.actions[var_46_16],
				sub_action_name = NetworkLookup.sub_actions[var_46_17],
				scale = var_46_19,
				power_level = var_46_20
			}
		end,
		ai_true_flight_projectile_unit = function (arg_47_0, arg_47_1, arg_47_2, arg_47_3)
			local var_47_0 = ScriptUnit.extension(arg_47_0, "projectile_locomotion_system")
			local var_47_1 = var_47_0.true_flight_template_name
			local var_47_2 = var_47_0.angle
			local var_47_3 = var_47_0.target_vector
			local var_47_4 = var_47_0.speed
			local var_47_5 = var_47_0.gravity_settings
			local var_47_6 = var_47_0.initial_position_boxed:unbox()
			local var_47_7 = var_47_0.trajectory_template_name
			local var_47_8 = var_47_0.owner_unit
			local var_47_9 = NetworkConstants.game_object_id_max

			if var_47_0.target_unit then
				var_47_9 = Managers.state.network:unit_game_object_id(var_47_0.target_unit)
			end

			local var_47_10 = ScriptUnit.has_extension(arg_47_0, "projectile_impact_system")
			local var_47_11 = var_47_10.server_side_raycast
			local var_47_12 = var_47_10.collision_filter
			local var_47_13 = ScriptUnit.extension(arg_47_0, "projectile_system")
			local var_47_14 = var_47_13.impact_template_name
			local var_47_15 = var_47_13.damage_source

			return {
				go_type = NetworkLookup.go_types.ai_true_flight_projectile_unit,
				husk_unit = NetworkLookup.husks[arg_47_1],
				position = Unit.local_position(arg_47_0, 0),
				rotation = Unit.local_rotation(arg_47_0, 0),
				true_flight_template_id = TrueFlightTemplates[var_47_1].lookup_id,
				target_unit_id = var_47_9,
				angle = var_47_2,
				initial_position = var_47_6,
				target_vector = var_47_3,
				speed = var_47_4,
				gravity_settings = NetworkLookup.projectile_gravity_settings[var_47_5],
				trajectory_template_id = NetworkLookup.projectile_templates[var_47_7],
				impact_template_name = NetworkLookup.projectile_templates[var_47_14],
				collision_filter = NetworkLookup.collision_filters[var_47_12],
				server_side_raycast = var_47_11,
				owner_unit = Managers.state.network:unit_game_object_id(var_47_8)
			}
		end,
		ai_true_flight_projectile_unit_without_raycast = function (arg_48_0, arg_48_1, arg_48_2, arg_48_3)
			local var_48_0 = ScriptUnit.extension(arg_48_0, "projectile_locomotion_system")
			local var_48_1 = var_48_0.true_flight_template_name
			local var_48_2 = var_48_0.angle
			local var_48_3 = var_48_0.target_vector
			local var_48_4 = var_48_0.speed
			local var_48_5 = var_48_0.gravity_settings
			local var_48_6 = var_48_0.initial_position_boxed:unbox()
			local var_48_7 = var_48_0.trajectory_template_name
			local var_48_8 = var_48_0.owner_unit
			local var_48_9 = NetworkConstants.game_object_id_max

			if var_48_0.target_unit then
				var_48_9 = Managers.state.network:unit_game_object_id(var_48_0.target_unit)
			end

			local var_48_10 = ScriptUnit.extension(arg_48_0, "projectile_system")
			local var_48_11 = var_48_10.impact_template_name
			local var_48_12 = var_48_10.damage_source

			return {
				go_type = NetworkLookup.go_types.ai_true_flight_projectile_unit_without_raycast,
				husk_unit = NetworkLookup.husks[arg_48_1],
				position = Unit.local_position(arg_48_0, 0),
				rotation = Unit.local_rotation(arg_48_0, 0),
				true_flight_template_id = TrueFlightTemplates[var_48_1].lookup_id,
				target_unit_id = var_48_9,
				angle = var_48_2,
				initial_position = var_48_6,
				target_vector = var_48_3,
				speed = var_48_4,
				gravity_settings = NetworkLookup.projectile_gravity_settings[var_48_5],
				trajectory_template_id = NetworkLookup.projectile_templates[var_48_7],
				impact_template_name = NetworkLookup.projectile_templates[var_48_11],
				owner_unit = Managers.state.network:unit_game_object_id(var_48_8)
			}
		end,
		aoe_projectile_unit = function (arg_49_0, arg_49_1, arg_49_2, arg_49_3)
			local var_49_0 = ScriptUnit.extension(arg_49_0, "projectile_locomotion_system")
			local var_49_1 = var_49_0.angle
			local var_49_2 = var_49_0.speed
			local var_49_3 = var_49_0.gravity_settings
			local var_49_4 = var_49_0.target_vector
			local var_49_5 = var_49_0.initial_position_boxed:unbox()
			local var_49_6 = var_49_0.trajectory_template_name
			local var_49_7 = ScriptUnit.extension(arg_49_0, "projectile_impact_system")
			local var_49_8 = var_49_7.collision_filter
			local var_49_9 = var_49_7.server_side_raycast
			local var_49_10 = var_49_7.owner_unit
			local var_49_11 = ScriptUnit.extension(arg_49_0, "projectile_system")
			local var_49_12 = var_49_11.impact_template_name
			local var_49_13 = var_49_11.damage_source
			local var_49_14 = ScriptUnit.extension(arg_49_0, "area_damage_system")
			local var_49_15 = var_49_14.aoe_dot_damage
			local var_49_16 = var_49_14.aoe_init_damage
			local var_49_17 = var_49_14.aoe_dot_damage_interval
			local var_49_18 = var_49_14.radius
			local var_49_19 = var_49_14.life_time
			local var_49_20 = var_49_14.damage_players
			local var_49_21 = var_49_14.player_screen_effect_name
			local var_49_22 = var_49_14.dot_effect_name
			local var_49_23 = var_49_14.area_damage_template
			local var_49_24 = var_49_14.source_attacker_unit
			local var_49_25 = Managers.state.network

			return {
				go_type = NetworkLookup.go_types.aoe_projectile_unit,
				husk_unit = NetworkLookup.husks[arg_49_1],
				angle = var_49_1,
				speed = var_49_2,
				gravity_settings = NetworkLookup.projectile_gravity_settings[var_49_3],
				initial_position = var_49_5,
				target_vector = var_49_4,
				trajectory_template_name = NetworkLookup.projectile_templates[var_49_6],
				owner_unit = var_49_25:unit_game_object_id(var_49_10),
				collision_filter = NetworkLookup.collision_filters[var_49_8],
				server_side_raycast = var_49_9,
				impact_template_name = NetworkLookup.projectile_templates[var_49_12],
				aoe_dot_damage = var_49_15,
				aoe_init_damage = var_49_16,
				aoe_dot_damage_interval = var_49_17,
				radius = var_49_18,
				life_time = var_49_19,
				damage_players = var_49_20,
				player_screen_effect_name = NetworkLookup.effects[var_49_21],
				dot_effect_name = NetworkLookup.effects[var_49_22],
				area_damage_template = NetworkLookup.area_damage_templates[var_49_23],
				source_attacker_unit = var_49_25:unit_game_object_id(var_49_24),
				damage_source_id = NetworkLookup.damage_sources[var_49_13]
			}
		end,
		aoe_projectile_unit_fixed_impact = function (arg_50_0, arg_50_1, arg_50_2, arg_50_3)
			local var_50_0 = ScriptUnit.extension(arg_50_0, "projectile_locomotion_system")
			local var_50_1 = var_50_0.angle
			local var_50_2 = var_50_0.speed
			local var_50_3 = var_50_0.gravity_settings
			local var_50_4 = var_50_0.target_vector
			local var_50_5 = var_50_0.initial_position_boxed:unbox()
			local var_50_6 = var_50_0.trajectory_template_name
			local var_50_7 = ScriptUnit.extension(arg_50_0, "projectile_impact_system")
			local var_50_8 = var_50_7.impact_data
			local var_50_9 = var_50_8.position:unbox()
			local var_50_10 = var_50_8.hit_normal:unbox()
			local var_50_11 = var_50_8.direction:unbox()
			local var_50_12 = var_50_8.hit_unit
			local var_50_13 = var_50_8.actor_index
			local var_50_14 = var_50_8.time
			local var_50_15 = var_50_7.owner_unit
			local var_50_16 = ScriptUnit.extension(arg_50_0, "projectile_system")
			local var_50_17 = var_50_16.impact_template_name
			local var_50_18 = var_50_16.damage_source
			local var_50_19 = ScriptUnit.extension(arg_50_0, "area_damage_system")
			local var_50_20 = var_50_19.aoe_dot_damage
			local var_50_21 = var_50_19.aoe_init_damage
			local var_50_22 = var_50_19.aoe_dot_damage_interval
			local var_50_23 = var_50_19.radius
			local var_50_24 = var_50_19.life_time
			local var_50_25 = var_50_19.damage_players
			local var_50_26 = var_50_19.player_screen_effect_name
			local var_50_27 = var_50_19.dot_effect_name
			local var_50_28 = var_50_19.area_damage_template
			local var_50_29 = var_50_19.source_attacker_unit
			local var_50_30 = Managers.state.network
			local var_50_31, var_50_32 = var_50_30:game_object_or_level_id(var_50_12)

			return {
				go_type = NetworkLookup.go_types.aoe_projectile_unit_fixed_impact,
				husk_unit = NetworkLookup.husks[arg_50_1],
				angle = var_50_1,
				speed = var_50_2,
				gravity_settings = NetworkLookup.projectile_gravity_settings[var_50_3],
				initial_position = var_50_5,
				target_vector = var_50_4,
				trajectory_template_name = NetworkLookup.projectile_templates[var_50_6],
				owner_unit = var_50_30:unit_game_object_id(var_50_15),
				impact_position = var_50_9,
				impact_time = var_50_14,
				impact_unit = var_50_31 or NetworkConstants.invalid_game_object_id,
				impact_unit_is_level_unit = var_50_32 or false,
				impact_actor = var_50_13,
				impact_direction = var_50_11,
				impact_normal = var_50_10,
				impact_template_name = NetworkLookup.projectile_templates[var_50_17],
				aoe_dot_damage = var_50_20,
				aoe_init_damage = var_50_21,
				aoe_dot_damage_interval = var_50_22,
				radius = var_50_23,
				life_time = var_50_24,
				damage_players = var_50_25,
				player_screen_effect_name = NetworkLookup.effects[var_50_26],
				dot_effect_name = NetworkLookup.effects[var_50_27],
				area_damage_template = NetworkLookup.area_damage_templates[var_50_28],
				source_attacker_unit = var_50_30:unit_game_object_id(var_50_29),
				damage_source_id = NetworkLookup.damage_sources[var_50_18]
			}
		end,
		projectile_unit = function (arg_51_0, arg_51_1, arg_51_2, arg_51_3)
			local var_51_0 = ScriptUnit.extension(arg_51_0, "projectile_system")
			local var_51_1 = var_51_0.angle
			local var_51_2 = var_51_0.speed
			local var_51_3 = var_51_0.target_vector
			local var_51_4 = var_51_0.initial_position
			local var_51_5 = var_51_0.trajectory_template_name
			local var_51_6 = var_51_0.impact_template_name
			local var_51_7 = var_51_0.owner_unit
			local var_51_8 = Managers.state.network

			return {
				go_type = NetworkLookup.go_types.projectile_unit,
				husk_unit = NetworkLookup.husks[arg_51_1],
				angle = var_51_1,
				speed = var_51_2,
				initial_position = var_51_4,
				target_vector = var_51_3,
				trajectory_template_name = NetworkLookup.projectile_templates[var_51_5],
				impact_template_name = NetworkLookup.projectile_templates[var_51_6],
				owner_unit = var_51_8:unit_game_object_id(var_51_7)
			}
		end,
		damage_wave_unit = function (arg_52_0, arg_52_1, arg_52_2, arg_52_3)
			local var_52_0 = ScriptUnit.extension(arg_52_0, "area_damage_system")
			local var_52_1 = var_52_0.damage_wave_template_name
			local var_52_2 = var_52_0.source_unit
			local var_52_3 = Managers.state.network

			return {
				height_percentage = 0,
				go_type = NetworkLookup.go_types.damage_wave_unit,
				husk_unit = NetworkLookup.husks[arg_52_1],
				position = Unit.local_position(arg_52_0, 0),
				rotation = Unit.local_rotation(arg_52_0, 0),
				damage_wave_template_name = NetworkLookup.damage_wave_templates[var_52_1],
				source_unit = var_52_3:unit_game_object_id(var_52_2)
			}
		end,
		damage_blob_unit = function (arg_53_0, arg_53_1, arg_53_2, arg_53_3)
			local var_53_0 = ScriptUnit.extension(arg_53_0, "area_damage_system")
			local var_53_1 = var_53_0.damage_blob_template_name
			local var_53_2 = var_53_0._source_unit
			local var_53_3 = Managers.state.network

			return {
				go_type = NetworkLookup.go_types.damage_blob_unit,
				husk_unit = NetworkLookup.husks[arg_53_1],
				position = Unit.local_position(arg_53_0, 0),
				rotation = Unit.local_rotation(arg_53_0, 0),
				damage_blob_template_name = NetworkLookup.damage_blob_templates[var_53_1],
				source_unit = var_53_3:unit_game_object_id(var_53_2)
			}
		end,
		liquid_aoe_unit = function (arg_54_0, arg_54_1, arg_54_2, arg_54_3)
			local var_54_0 = ScriptUnit.extension(arg_54_0, "area_damage_system")
			local var_54_1 = var_54_0._liquid_area_damage_template
			local var_54_2 = var_54_0._source_attacker_unit
			local var_54_3 = Managers.state.network

			return {
				go_type = NetworkLookup.go_types.liquid_aoe_unit,
				husk_unit = NetworkLookup.husks[arg_54_1],
				liquid_area_damage_template = NetworkLookup.liquid_area_damage_templates[var_54_1],
				source_unit = var_54_3:unit_game_object_id(var_54_2),
				position = Unit.local_position(arg_54_0, 0),
				rotation = Unit.local_rotation(arg_54_0, 0)
			}
		end,
		lure_unit = function (arg_55_0, arg_55_1, arg_55_2, arg_55_3)
			return {
				go_type = NetworkLookup.go_types.lure_unit,
				husk_unit = NetworkLookup.husks[arg_55_1],
				position = Unit.local_position(arg_55_0, 0),
				rotation = Unit.local_rotation(arg_55_0, 0)
			}
		end,
		aoe_unit = function (arg_56_0, arg_56_1, arg_56_2, arg_56_3)
			local var_56_0 = ScriptUnit.extension(arg_56_0, "area_damage_system")
			local var_56_1 = var_56_0.aoe_dot_damage
			local var_56_2 = var_56_0.aoe_init_damage
			local var_56_3 = var_56_0.aoe_dot_damage_interval
			local var_56_4 = var_56_0.radius
			local var_56_5 = var_56_0.life_time
			local var_56_6 = var_56_0.player_screen_effect_name
			local var_56_7 = var_56_0.dot_effect_name
			local var_56_8 = var_56_0.area_damage_template
			local var_56_9 = var_56_0.invisible_unit
			local var_56_10 = var_56_0.extra_dot_effect_name
			local var_56_11 = var_56_0.explosion_template_name
			local var_56_12 = var_56_0.owner_player
			local var_56_13 = var_56_0.source_attacker_unit

			if var_56_7 == nil then
				var_56_7 = "n/a"
			end

			if var_56_10 == nil then
				var_56_10 = "n/a"
			end

			if var_56_11 == nil then
				var_56_11 = "n/a"
			end

			if var_56_6 == nil then
				var_56_6 = "n/a"
			end

			local var_56_14 = NetworkConstants.invalid_game_object_id

			if var_56_12 then
				var_56_14 = var_56_12.game_object_id
			end

			local var_56_15 = NetworkConstants.invalid_game_object_id

			if var_56_13 then
				var_56_15 = Managers.state.network:unit_game_object_id(var_56_13)
			end

			return {
				go_type = NetworkLookup.go_types.aoe_unit,
				husk_unit = NetworkLookup.husks[arg_56_1],
				aoe_dot_damage = var_56_1,
				aoe_init_damage = var_56_2,
				aoe_dot_damage_interval = var_56_3,
				position = Unit.local_position(arg_56_0, 0),
				rotation = Unit.local_rotation(arg_56_0, 0),
				radius = var_56_4,
				life_time = var_56_5,
				player_screen_effect_name = NetworkLookup.effects[var_56_6],
				dot_effect_name = NetworkLookup.effects[var_56_7],
				extra_dot_effect_name = NetworkLookup.effects[var_56_10],
				invisible_unit = var_56_9,
				area_damage_template = NetworkLookup.area_damage_templates[var_56_8],
				explosion_template_name = NetworkLookup.explosion_templates[var_56_11],
				owner_player_id = var_56_14,
				source_attacker_unit_id = var_56_15
			}
		end,
		thorn_bush_unit = function (arg_57_0, arg_57_1, arg_57_2, arg_57_3)
			local var_57_0 = ScriptUnit.extension(arg_57_0, "area_damage_system")
			local var_57_1 = var_57_0.aoe_dot_damage
			local var_57_2 = var_57_0.aoe_init_damage
			local var_57_3 = var_57_0.aoe_dot_damage_interval
			local var_57_4 = var_57_0.radius
			local var_57_5 = var_57_0.life_time
			local var_57_6 = var_57_0.player_screen_effect_name
			local var_57_7 = var_57_0.dot_effect_name
			local var_57_8 = var_57_0.area_damage_template
			local var_57_9 = var_57_0.invisible_unit
			local var_57_10 = var_57_0.extra_dot_effect_name
			local var_57_11 = var_57_0.explosion_template_name
			local var_57_12 = var_57_0.owner_player
			local var_57_13 = ScriptUnit.extension(arg_57_0, "props_system")
			local var_57_14 = var_57_13.spawn_animation_time
			local var_57_15 = var_57_13.despawn_animation_time
			local var_57_16 = var_57_13.slow_modifier

			if var_57_7 == nil then
				var_57_7 = "n/a"
			end

			if var_57_10 == nil then
				var_57_10 = "n/a"
			end

			if var_57_11 == nil then
				var_57_11 = "n/a"
			end

			if var_57_6 == nil then
				var_57_6 = "n/a"
			end

			local var_57_17 = NetworkConstants.invalid_game_object_id

			if var_57_12 then
				var_57_17 = var_57_12.game_object_id
			end

			return {
				go_type = NetworkLookup.go_types.thorn_bush_unit,
				husk_unit = NetworkLookup.husks[arg_57_1],
				aoe_dot_damage = var_57_1,
				aoe_init_damage = var_57_2,
				aoe_dot_damage_interval = var_57_3,
				position = Unit.local_position(arg_57_0, 0),
				rotation = Unit.local_rotation(arg_57_0, 0),
				radius = var_57_4,
				life_time = var_57_5,
				player_screen_effect_name = NetworkLookup.effects[var_57_6],
				dot_effect_name = NetworkLookup.effects[var_57_7],
				extra_dot_effect_name = NetworkLookup.effects[var_57_10],
				invisible_unit = var_57_9,
				area_damage_template = NetworkLookup.area_damage_templates[var_57_8],
				explosion_template_name = NetworkLookup.explosion_templates[var_57_11],
				owner_player_id = var_57_17,
				spawn_animation_time = var_57_14,
				despawn_animation_time = var_57_15,
				slow_modifier = var_57_16
			}
		end,
		shadow_flare_light = function (arg_58_0, arg_58_1, arg_58_2, arg_58_3)
			local var_58_0 = ScriptUnit.extension(arg_58_0, "darkness_system")
			local var_58_1 = var_58_0.glow_time
			local var_58_2 = var_58_0.owner_unit_id

			return {
				go_type = NetworkLookup.go_types.shadow_flare_light,
				husk_unit = NetworkLookup.husks[arg_58_1],
				glow_time = var_58_1,
				owner_unit_id = var_58_2,
				position = Unit.local_position(arg_58_0, 0)
			}
		end,
		timed_explosion_unit = function (arg_59_0, arg_59_1, arg_59_2, arg_59_3)
			local var_59_0 = ScriptUnit.extension(arg_59_0, "area_damage_system")
			local var_59_1 = var_59_0.follow_unit
			local var_59_2 = var_59_0.explosion_template_name
			local var_59_3 = Managers.state.network

			return {
				go_type = NetworkLookup.go_types.timed_explosion_unit,
				husk_unit = NetworkLookup.husks[arg_59_1],
				follow_unit = var_59_3:unit_game_object_id(var_59_1),
				explosion_template_name = NetworkLookup.explosion_templates[var_59_2],
				position = Unit.local_position(arg_59_0, 0),
				rotation = Unit.local_rotation(arg_59_0, 0)
			}
		end,
		pickup_unit = function (arg_60_0, arg_60_1, arg_60_2, arg_60_3)
			local var_60_0 = ScriptUnit.extension(arg_60_0, "pickup_system")
			local var_60_1 = var_60_0.pickup_name
			local var_60_2 = var_60_0.has_physics
			local var_60_3 = var_60_0.spawn_type
			local var_60_4 = var_60_0.dropped_by_breed

			return {
				go_type = NetworkLookup.go_types.pickup_unit,
				husk_unit = NetworkLookup.husks[arg_60_1],
				pickup_name = NetworkLookup.pickup_names[var_60_1],
				has_physics = var_60_2,
				spawn_type = NetworkLookup.pickup_spawn_types[var_60_3],
				dropped_by_breed = NetworkLookup.breeds[var_60_4],
				position = Unit.local_position(arg_60_0, 0),
				rotation = Unit.local_rotation(arg_60_0, 0)
			}
		end,
		limited_owned_pickup_unit = function (arg_61_0, arg_61_1, arg_61_2, arg_61_3)
			local var_61_0 = ScriptUnit.extension(arg_61_0, "pickup_system")
			local var_61_1 = var_61_0.pickup_name
			local var_61_2 = var_61_0.has_physics
			local var_61_3 = var_61_0.spawn_type
			local var_61_4 = var_61_0.owner_peer_id
			local var_61_5 = var_61_0.spawn_limit
			local var_61_6 = var_61_0.material_settings_name or "n/a"

			return {
				go_type = NetworkLookup.go_types.limited_owned_pickup_unit,
				husk_unit = NetworkLookup.husks[arg_61_1],
				pickup_name = NetworkLookup.pickup_names[var_61_1],
				has_physics = var_61_2,
				spawn_type = NetworkLookup.pickup_spawn_types[var_61_3],
				position = Unit.local_position(arg_61_0, 0),
				rotation = Unit.local_rotation(arg_61_0, 0),
				owner_peer_id = var_61_4,
				spawn_limit = var_61_5,
				material_settings_id = NetworkLookup.material_settings_templates[var_61_6]
			}
		end,
		life_time_pickup_unit = function (arg_62_0, arg_62_1, arg_62_2, arg_62_3)
			local var_62_0 = ScriptUnit.extension(arg_62_0, "projectile_locomotion_system")
			local var_62_1 = var_62_0.network_position
			local var_62_2 = var_62_0.network_rotation
			local var_62_3 = var_62_0.network_velocity
			local var_62_4 = var_62_0.network_angular_velocity
			local var_62_5 = ScriptUnit.extension(arg_62_0, "pickup_system")
			local var_62_6 = var_62_5.pickup_name
			local var_62_7 = var_62_5.has_physics
			local var_62_8 = var_62_5.spawn_type

			return {
				go_type = NetworkLookup.go_types.life_time_pickup_unit,
				husk_unit = NetworkLookup.husks[arg_62_1],
				position = Unit.local_position(arg_62_0, 0),
				rotation = Unit.local_rotation(arg_62_0, 0),
				network_position = var_62_1,
				network_rotation = var_62_2,
				network_velocity = var_62_3,
				network_angular_velocity = var_62_4,
				debug_pos = Unit.local_position(arg_62_0, 0),
				pickup_name = NetworkLookup.pickup_names[var_62_6],
				has_physics = var_62_7,
				spawn_type = NetworkLookup.pickup_spawn_types[var_62_8]
			}
		end,
		objective_pickup_unit = function (arg_63_0, arg_63_1, arg_63_2, arg_63_3)
			local var_63_0 = ScriptUnit.extension(arg_63_0, "pickup_system")
			local var_63_1 = var_63_0.pickup_name
			local var_63_2 = var_63_0.has_physics
			local var_63_3 = var_63_0.spawn_type
			local var_63_4 = ScriptUnit.has_extension(arg_63_0, "tutorial_system")
			local var_63_5 = var_63_4 and var_63_4.always_show or false

			return {
				go_type = NetworkLookup.go_types.objective_pickup_unit,
				husk_unit = NetworkLookup.husks[arg_63_1],
				pickup_name = NetworkLookup.pickup_names[var_63_1],
				has_physics = var_63_2,
				spawn_type = NetworkLookup.pickup_spawn_types[var_63_3],
				always_show = var_63_5,
				position = Unit.local_position(arg_63_0, 0),
				rotation = Unit.local_rotation(arg_63_0, 0)
			}
		end,
		prop_unit = function (arg_64_0, arg_64_1, arg_64_2, arg_64_3)
			return {
				go_type = NetworkLookup.go_types.prop_unit,
				husk_unit = NetworkLookup.husks[arg_64_1]
			}
		end,
		positioned_prop_unit = function (arg_65_0, arg_65_1, arg_65_2, arg_65_3)
			return {
				go_type = NetworkLookup.go_types.positioned_prop_unit,
				husk_unit = NetworkLookup.husks[arg_65_1],
				position = Unit.local_position(arg_65_0, 0),
				rotation = Unit.local_rotation(arg_65_0, 0)
			}
		end,
		positioned_blob_unit = function (arg_66_0, arg_66_1, arg_66_2, arg_66_3)
			return {
				go_type = NetworkLookup.go_types.positioned_blob_unit,
				husk_unit = NetworkLookup.husks[arg_66_1],
				position = Unit.local_position(arg_66_0, 0),
				rotation = Unit.local_rotation(arg_66_0, 0)
			}
		end,
		destructible_objective_unit = function (arg_67_0, arg_67_1, arg_67_2, arg_67_3)
			local var_67_0 = ScriptUnit.has_extension(arg_67_0, "health_system")

			return {
				go_type = NetworkLookup.go_types.destructible_objective_unit,
				husk_unit = NetworkLookup.husks[arg_67_1],
				position = Unit.local_position(arg_67_0, 0),
				rotation = Unit.local_rotation(arg_67_0, 0),
				health = var_67_0:get_max_health()
			}
		end,
		objective_unit = function (arg_68_0, arg_68_1, arg_68_2, arg_68_3)
			return {
				go_type = NetworkLookup.go_types.objective_unit,
				husk_unit = NetworkLookup.husks[arg_68_1],
				position = Unit.local_position(arg_68_0, 0)
			}
		end,
		standard_unit = function (arg_69_0, arg_69_1, arg_69_2, arg_69_3)
			local var_69_0 = ScriptUnit.has_extension(arg_69_0, "health_system")
			local var_69_1 = ScriptUnit.extension(arg_69_0, "ai_supplementary_system")
			local var_69_2 = ScriptUnit.extension(arg_69_0, "ping_system")

			return {
				go_type = NetworkLookup.go_types.standard_unit,
				husk_unit = NetworkLookup.husks[arg_69_1],
				position = Unit.local_position(arg_69_0, 0),
				rotation = Unit.local_rotation(arg_69_0, 0),
				health = var_69_0:get_max_health(),
				standard_template_id = NetworkLookup.standard_templates[var_69_1.standard_template_name],
				always_pingable = var_69_2.always_pingable
			}
		end,
		overpowering_blob_unit = function (arg_70_0, arg_70_1, arg_70_2, arg_70_3)
			local var_70_0 = ScriptUnit.has_extension(arg_70_0, "health_system")

			return {
				go_type = NetworkLookup.go_types.overpowering_blob_unit,
				husk_unit = NetworkLookup.husks[arg_70_1],
				health = var_70_0:get_max_health()
			}
		end,
		network_synched_dummy_unit = function (arg_71_0, arg_71_1, arg_71_2, arg_71_3)
			local var_71_0 = Unit.local_scale(arg_71_0, 0)

			return {
				go_type = NetworkLookup.go_types.network_synched_dummy_unit,
				husk_unit = NetworkLookup.husks[arg_71_1],
				position = Unit.local_position(arg_71_0, 0),
				yaw_rot = Quaternion.yaw(Unit.local_rotation(arg_71_0, 0)),
				uniform_scale = var_71_0.x
			}
		end,
		position_synched_dummy_unit = function (arg_72_0, arg_72_1, arg_72_2, arg_72_3)
			return {
				go_type = NetworkLookup.go_types.position_synched_dummy_unit,
				husk_unit = NetworkLookup.husks[arg_72_1],
				rotation = Unit.local_rotation(arg_72_0, 0),
				position = Unit.local_position(arg_72_0, 0)
			}
		end,
		buff_aoe_unit = function (arg_73_0, arg_73_1, arg_73_2, arg_73_3)
			local var_73_0 = ScriptUnit.extension(arg_73_0, "buff_area_system")
			local var_73_1 = var_73_0.owner_unit
			local var_73_2 = var_73_0.source_unit
			local var_73_3 = var_73_0.life_time
			local var_73_4 = var_73_0.radius
			local var_73_5 = var_73_0.template.name
			local var_73_6 = NetworkConstants.invalid_game_object_id

			if var_73_1 then
				var_73_6 = Managers.state.network:unit_game_object_id(var_73_1)
			end

			local var_73_7 = NetworkConstants.invalid_game_object_id

			if var_73_2 then
				var_73_7 = Managers.state.network:unit_game_object_id(var_73_2)
			end

			return {
				go_type = NetworkLookup.go_types.buff_aoe_unit,
				husk_unit = NetworkLookup.husks[arg_73_1],
				position = Unit.local_position(arg_73_0, 0),
				life_time = var_73_3,
				radius = var_73_4,
				owner_unit_id = var_73_6,
				source_unit_id = var_73_7,
				buff_template_id = NetworkLookup.buff_templates[var_73_5],
				sub_buff_id = var_73_0.sub_buff_id,
				side_id = var_73_0.side_id
			}
		end,
		buff_unit = function (arg_74_0, arg_74_1, arg_74_2, arg_74_3)
			return {
				go_type = NetworkLookup.go_types.buff_unit,
				husk_unit = NetworkLookup.husks[arg_74_1],
				position = Unit.local_position(arg_74_0, 0)
			}
		end,
		thrown_weapon_unit = function (arg_75_0, arg_75_1, arg_75_2, arg_75_3)
			return {
				go_type = NetworkLookup.go_types.thrown_weapon_unit,
				husk_unit = NetworkLookup.husks[arg_75_1],
				position = Unit.local_position(arg_75_0, 0),
				rotation = Unit.local_rotation(arg_75_0, 0)
			}
		end,
		interest_point_level_unit = function (arg_76_0, arg_76_1, arg_76_2, arg_76_3)
			return {
				go_type = NetworkLookup.go_types.interest_point_level_unit
			}
		end,
		interest_point_unit = function (arg_77_0, arg_77_1, arg_77_2, arg_77_3)
			return {
				go_type = NetworkLookup.go_types.interest_point_unit,
				husk_unit = NetworkLookup.husks[arg_77_1],
				position = Unit.local_position(arg_77_0, 0),
				rotation = Unit.local_rotation(arg_77_0, 0)
			}
		end,
		sync_unit = function (arg_78_0, arg_78_1, arg_78_2, arg_78_3)
			local var_78_0 = ScriptUnit.extension(arg_78_0, "game_object_system")

			return {
				go_type = NetworkLookup.go_types.sync_unit,
				sync_name = NetworkLookup.sync_names[var_78_0.sync_name]
			}
		end,
		rotating_hazard = function (arg_79_0, arg_79_1, arg_79_2, arg_79_3)
			local var_79_0 = ScriptUnit.extension(arg_79_0, "props_system")

			return {
				go_type = NetworkLookup.go_types.rotating_hazard,
				husk_unit = NetworkLookup.husks[arg_79_1],
				position = Unit.local_position(arg_79_0, 0),
				rotation = Unit.local_rotation(arg_79_0, 0),
				start_network_time = var_79_0._start_t,
				state = var_79_0._state
			}
		end,
		dialogue_node = function (arg_80_0, arg_80_1, arg_80_2, arg_80_3)
			local var_80_0 = ScriptUnit.extension(arg_80_0, "dialogue_system").dialogue_profile
			local var_80_1 = Managers.state.side.side_by_unit[arg_80_0]
			local var_80_2 = var_80_1 and var_80_1.side_id

			return {
				go_type = NetworkLookup.go_types.dialogue_node,
				husk_unit = NetworkLookup.husks[arg_80_1],
				dialogue_profile = NetworkLookup.dialogue_profiles[var_80_0],
				side_id = var_80_2 and var_80_2 > 0 and var_80_2 or nil
			}
		end,
		explosive_barrel_socket = function (arg_81_0, arg_81_1, arg_81_2, arg_81_3)
			return {
				position = Unit.local_position(arg_81_0, 0),
				rotation = Unit.local_rotation(arg_81_0, 0),
				go_type = NetworkLookup.go_types.explosive_barrel_socket,
				husk_unit = NetworkLookup.husks[arg_81_1]
			}
		end
	},
	extractors = {
		player_unit = function (arg_82_0, arg_82_1, arg_82_2, arg_82_3, arg_82_4)
			local var_82_0 = GameSession.game_object_field(arg_82_0, arg_82_1, "wounds")
			local var_82_1 = GameSession.game_object_field(arg_82_0, arg_82_1, "profile_id")
			local var_82_2 = GameSession.game_object_field(arg_82_0, arg_82_1, "career_id")
			local var_82_3 = GameSession.game_object_field(arg_82_0, arg_82_1, "skin_name")
			local var_82_4 = GameSession.game_object_field(arg_82_0, arg_82_1, "frame_name")
			local var_82_5 = GameSession.game_object_field(arg_82_0, arg_82_1, "ability_percentage")
			local var_82_6 = GameSession.game_object_field(arg_82_0, arg_82_1, "has_moved_from_start_position")
			local var_82_7 = SPProfiles[var_82_1]

			fassert(var_82_7, "No such profile with index %s", tostring(var_82_1))

			local var_82_8 = var_82_7.aim_template or "player"
			local var_82_9 = var_82_7.careers[var_82_2]
			local var_82_10 = var_82_9.sound_character

			fassert(var_82_9, "No such career with career_index %s", tostring(var_82_2))
			Unit.set_data(arg_82_3, "sound_character", var_82_10)

			local var_82_11 = var_82_7.career_voice_parameter

			if var_82_11 then
				local var_82_12 = var_82_7.career_voice_parameter_values[var_82_2]

				if var_82_12 and GameSettingsDevelopment.use_career_voice_pitch then
					local var_82_13 = arg_82_4.world
					local var_82_14 = Wwise.wwise_world(var_82_13)

					WwiseWorld.set_global_parameter(var_82_14, var_82_11, var_82_12)
				end
			end

			local var_82_15 = GameSession.game_object_field(arg_82_0, arg_82_1, "local_player_id")
			local var_82_16 = GameSession.game_object_field(arg_82_0, arg_82_1, "owner_peer_id")
			local var_82_17 = Managers.player:player(var_82_16, var_82_15)
			local var_82_18 = NetworkLookup.cosmetics[var_82_3]
			local var_82_19 = NetworkLookup.cosmetics[var_82_4]
			local var_82_20 = var_82_9.name
			local var_82_21 = OverchargeData[var_82_20] or {}
			local var_82_22 = GameSession.game_object_field(arg_82_0, arg_82_1, "overcharge_max_value")
			local var_82_23 = EnergyData[var_82_20] or {}
			local var_82_24 = GameSession.game_object_field(arg_82_0, arg_82_1, "energy_max_value")
			local var_82_25 = var_82_17:unique_id()
			local var_82_26 = Managers.party:get_status_from_unique_id(var_82_25)
			local var_82_27 = Managers.party:get_party(var_82_26.party_id)
			local var_82_28 = Managers.state.side.side_by_party[var_82_27]
			local var_82_29 = GameSession.game_object_field(arg_82_0, arg_82_1, "network_buff_ids")
			local var_82_30 = {}

			if var_82_29 then
				for iter_82_0, iter_82_1 in ipairs(var_82_29) do
					local var_82_31 = NetworkLookup.buff_templates[iter_82_1]

					table.insert(var_82_30, var_82_31)
				end
			end

			var_0_3(var_82_17, var_82_7, var_82_9, arg_82_3)

			local var_82_32 = var_82_9.breed
			local var_82_33 = {
				locomotion_system = {
					id = arg_82_1,
					game = arg_82_0,
					player = var_82_17,
					has_moved_from_start_position = var_82_6
				},
				health_system = {
					player = var_82_17,
					game_object_id = arg_82_1,
					profile_index = var_82_1,
					career_index = var_82_2
				},
				hit_reaction_system = {
					is_husk = true,
					hit_reaction_template = "player",
					hit_effect_template = var_82_32.hit_effect_template
				},
				death_system = {
					death_reaction_template = "player",
					is_husk = true
				},
				aim_system = {
					is_husk = true,
					go_id = arg_82_1,
					template = var_82_8
				},
				status_system = {
					wounds = var_82_0,
					profile_id = var_82_1,
					player = var_82_17
				},
				inventory_system = {
					id = arg_82_1,
					game = arg_82_0,
					player = var_82_17
				},
				attachment_system = {
					profile = var_82_7,
					player = var_82_17
				},
				cosmetic_system = {
					profile = var_82_7,
					skin_name = var_82_18,
					frame_name = var_82_19,
					player = var_82_17
				},
				dialogue_context_system = {
					profile = var_82_7
				},
				dialogue_system = {
					wwise_career_switch_group = "player_career",
					faction = "player",
					wwise_voice_switch_group = "character",
					profile = var_82_7,
					wwise_voice_switch_value = var_82_7.character_vo,
					wwise_career_switch_value = var_82_20
				},
				whereabouts_system = {
					player = var_82_17
				},
				buff_system = {
					is_husk = true,
					initial_buff_names = var_82_30,
					breed = var_82_32
				},
				statistics_system = {
					template = "player",
					statistics_id = var_82_17:stats_id()
				},
				ai_slot_system = {
					profile_index = var_82_1
				},
				talent_system = {
					is_husk = true,
					player = var_82_17,
					profile_index = var_82_1
				},
				career_system = {
					player = var_82_17,
					profile_index = var_82_1,
					career_index = var_82_2,
					initial_ability_percentage = var_82_5
				},
				overcharge_system = {
					overcharge_max_value = var_82_22,
					overcharge_data = var_82_21
				},
				energy_system = {
					energy_max_value = var_82_24,
					energy_data = var_82_23
				},
				aggro_system = {
					side = var_82_28
				},
				proximity_system = {
					profile = var_82_7,
					side = var_82_28
				},
				target_override_system = {
					side = var_82_28
				},
				ai_commander_system = {
					player = var_82_17
				}
			}

			return var_82_7.unit_template_name or "player_unit_3rd", var_82_33
		end,
		player_bot_unit = function (arg_83_0, arg_83_1, arg_83_2, arg_83_3, arg_83_4)
			local var_83_0 = GameSession.game_object_field(arg_83_0, arg_83_1, "wounds")
			local var_83_1 = GameSession.game_object_field(arg_83_0, arg_83_1, "profile_id")
			local var_83_2 = GameSession.game_object_field(arg_83_0, arg_83_1, "career_id")
			local var_83_3 = GameSession.game_object_field(arg_83_0, arg_83_1, "skin_name")
			local var_83_4 = GameSession.game_object_field(arg_83_0, arg_83_1, "frame_name")
			local var_83_5 = GameSession.game_object_field(arg_83_0, arg_83_1, "ability_percentage")
			local var_83_6 = GameSession.game_object_field(arg_83_0, arg_83_1, "has_moved_from_start_position")
			local var_83_7 = SPProfiles[var_83_1]

			fassert(var_83_7, "No such profile with index %s", tostring(var_83_1))

			local var_83_8 = var_83_7.careers[var_83_2]

			fassert(var_83_8, "No such career with career_index %s", tostring(var_83_2))
			Unit.set_data(arg_83_3, "sound_character", var_83_8.sound_character)

			local var_83_9 = var_83_7.career_voice_parameter

			if var_83_9 then
				local var_83_10 = var_83_7.career_voice_parameter_values[var_83_2]

				if var_83_10 and GameSettingsDevelopment.use_career_voice_pitch then
					local var_83_11 = arg_83_4.world
					local var_83_12 = Wwise.wwise_world(var_83_11)

					WwiseWorld.set_global_parameter(var_83_12, var_83_9, var_83_10)
				end
			end

			local var_83_13 = GameSession.game_object_field(arg_83_0, arg_83_1, "local_player_id")
			local var_83_14 = GameSession.game_object_field(arg_83_0, arg_83_1, "owner_peer_id")
			local var_83_15 = Managers.player:player(var_83_14, var_83_13)
			local var_83_16 = NetworkLookup.cosmetics[var_83_3]
			local var_83_17 = NetworkLookup.cosmetics[var_83_4]
			local var_83_18 = var_83_8.name
			local var_83_19 = OverchargeData[var_83_18] or {}
			local var_83_20 = GameSession.game_object_field(arg_83_0, arg_83_1, "overcharge_max_value")
			local var_83_21 = EnergyData[var_83_18] or {}
			local var_83_22 = GameSession.game_object_field(arg_83_0, arg_83_1, "energy_max_value")
			local var_83_23 = var_83_15:unique_id()
			local var_83_24 = Managers.party:get_status_from_unique_id(var_83_23)
			local var_83_25 = Managers.party:get_party(var_83_24.party_id)
			local var_83_26 = Managers.state.side.side_by_party[var_83_25]

			var_0_3(var_83_15, var_83_7, var_83_8, arg_83_3)

			local var_83_27 = var_83_8.breed
			local var_83_28 = {
				locomotion_system = {
					id = arg_83_1,
					game = arg_83_0,
					player = var_83_15,
					has_moved_from_start_position = var_83_6
				},
				health_system = {
					player = var_83_15,
					game_object_id = arg_83_1,
					profile_index = var_83_1,
					career_index = var_83_2
				},
				death_system = {
					death_reaction_template = "player",
					is_husk = true
				},
				inventory_system = {
					id = arg_83_1,
					game = arg_83_0,
					player = var_83_15
				},
				hit_reaction_system = {
					is_husk = true,
					hit_reaction_template = "player",
					hit_effect_template = var_83_27.hit_effect_template
				},
				dialogue_context_system = {
					profile = var_83_7
				},
				aim_system = {
					template = "player",
					is_husk = true,
					go_id = arg_83_1
				},
				status_system = {
					wounds = var_83_0,
					profile_id = var_83_1,
					player = var_83_15
				},
				dialogue_system = {
					wwise_career_switch_group = "player_career",
					faction = "player",
					wwise_voice_switch_group = "character",
					profile = var_83_7,
					wwise_voice_switch_value = var_83_7.character_vo,
					wwise_career_switch_value = var_83_18
				},
				whereabouts_system = {
					player = var_83_15
				},
				attachment_system = {
					profile = var_83_7
				},
				cosmetic_system = {
					profile = var_83_7,
					skin_name = var_83_16,
					frame_name = var_83_17,
					player = var_83_15
				},
				buff_system = {
					is_husk = true,
					breed = var_83_27
				},
				statistics_system = {
					template = "player",
					statistics_id = var_83_15:stats_id()
				},
				ai_slot_system = {
					profile_index = var_83_1
				},
				talent_system = {
					is_husk = true,
					player = var_83_15,
					profile_index = var_83_1
				},
				career_system = {
					player = var_83_15,
					profile_index = var_83_1,
					career_index = var_83_2,
					initial_ability_percentage = var_83_5
				},
				overcharge_system = {
					overcharge_max_value = var_83_20,
					overcharge_data = var_83_19
				},
				energy_system = {
					energy_max_value = var_83_22,
					energy_data = var_83_21
				},
				aggro_system = {
					side = var_83_26
				},
				proximity_system = {
					profile = var_83_7,
					side = var_83_26
				},
				target_override_system = {
					side = var_83_26
				},
				ai_commander_system = {
					player = var_83_15
				}
			}

			return "player_bot_unit", var_83_28
		end,
		ai_unit = function (arg_84_0, arg_84_1, arg_84_2, arg_84_3, arg_84_4)
			local var_84_0, var_84_1, var_84_2 = var_0_2(arg_84_3, arg_84_0, arg_84_1)
			local var_84_3 = GameSession.game_object_field(arg_84_0, arg_84_1, "health")
			local var_84_4 = {
				ai_system = {
					go_id = arg_84_1,
					game = arg_84_0,
					side_id = var_84_2
				},
				locomotion_system = {
					go_id = arg_84_1,
					breed = var_84_0,
					game = arg_84_0
				},
				health_system = {
					health = var_84_3
				},
				death_system = {
					is_husk = true,
					death_reaction_template = var_84_0.death_reaction,
					disable_second_hit_ragdoll = var_84_0.disable_second_hit_ragdoll
				},
				hit_reaction_system = {
					is_husk = true,
					hit_reaction_template = var_84_0.hit_reaction,
					hit_effect_template = var_84_0.hit_effect_template
				},
				dialogue_system = {
					faction = "enemy",
					breed_name = var_84_1
				},
				proximity_system = {
					breed = var_84_0
				},
				buff_system = {
					breed = var_84_0
				}
			}

			return var_84_0.unit_template, var_84_4
		end,
		ai_unit_training_dummy_bob = function (arg_85_0, arg_85_1, arg_85_2, arg_85_3, arg_85_4)
			local var_85_0, var_85_1, var_85_2 = var_0_2(arg_85_3, arg_85_0, arg_85_1)
			local var_85_3 = GameSession.game_object_field(arg_85_0, arg_85_1, "health")
			local var_85_4 = GameSession.game_object_field(arg_85_0, arg_85_1, "network_position")
			local var_85_5 = GameSession.game_object_field(arg_85_0, arg_85_1, "network_rotation")
			local var_85_6 = GameSession.game_object_field(arg_85_0, arg_85_1, "network_velocity")
			local var_85_7 = GameSession.game_object_field(arg_85_0, arg_85_1, "network_angular_velocity")
			local var_85_8 = GameSession.game_object_field(arg_85_0, arg_85_1, "pickup_name")
			local var_85_9 = GameSession.game_object_field(arg_85_0, arg_85_1, "has_physics")
			local var_85_10 = GameSession.game_object_field(arg_85_0, arg_85_1, "spawn_type")
			local var_85_11 = {
				ai_system = {
					go_id = arg_85_1,
					game = arg_85_0,
					side_id = var_85_2
				},
				health_system = {
					damage = 0,
					health = var_85_3
				},
				death_system = {
					is_husk = true,
					death_reaction_template = var_85_0.death_reaction,
					disable_second_hit_ragdoll = var_85_0.disable_second_hit_ragdoll
				},
				hit_reaction_system = {
					is_husk = true,
					hit_reaction_template = var_85_0.hit_reaction,
					hit_effect_template = var_85_0.hit_effect_template
				},
				dialogue_system = {
					faction = "enemy",
					breed_name = var_85_1
				},
				proximity_system = {
					breed = var_85_0
				},
				buff_system = {
					breed = var_85_0
				},
				projectile_locomotion_system = {
					network_position = var_85_4,
					network_rotation = var_85_5,
					network_velocity = var_85_6,
					network_angular_velocity = var_85_7
				},
				pickup_system = {
					pickup_name = NetworkLookup.pickup_names[var_85_8],
					has_physics = var_85_9,
					spawn_type = NetworkLookup.pickup_spawn_types[var_85_10]
				}
			}

			return "ai_unit_training_dummy_bob", var_85_11
		end,
		ai_unit_beastmen_bestigor = function (arg_86_0, arg_86_1, arg_86_2, arg_86_3, arg_86_4)
			local var_86_0, var_86_1, var_86_2 = var_0_2(arg_86_3, arg_86_0, arg_86_1)
			local var_86_3 = NetworkLookup.ai_inventory[GameSession.game_object_field(arg_86_0, arg_86_1, "inventory_configuration")]
			local var_86_4 = GameSession.game_object_field(arg_86_0, arg_86_1, "health")
			local var_86_5 = {
				ai_system = {
					go_id = arg_86_1,
					game = arg_86_0,
					side_id = var_86_2
				},
				locomotion_system = {
					go_id = arg_86_1,
					breed = var_86_0,
					game = arg_86_0
				},
				health_system = {
					health = var_86_4
				},
				death_system = {
					is_husk = true,
					death_reaction_template = var_86_0.death_reaction,
					disable_second_hit_ragdoll = var_86_0.disable_second_hit_ragdoll
				},
				hit_reaction_system = {
					is_husk = true,
					hit_reaction_template = var_86_0.hit_reaction,
					hit_effect_template = var_86_0.hit_effect_template
				},
				ai_inventory_system = {
					inventory_configuration_name = var_86_3
				},
				dialogue_system = {
					faction = "enemy",
					breed_name = var_86_1
				},
				animation_movement_system = {
					is_husk = true,
					template = var_86_0.animation_movement_template
				},
				proximity_system = {
					breed = var_86_0
				}
			}

			return var_86_0.unit_template, var_86_5
		end,
		ai_unit_beastmen_minotaur = function (arg_87_0, arg_87_1, arg_87_2, arg_87_3, arg_87_4)
			local var_87_0, var_87_1, var_87_2 = var_0_2(arg_87_3, arg_87_0, arg_87_1)
			local var_87_3 = NetworkLookup.ai_inventory[GameSession.game_object_field(arg_87_0, arg_87_1, "inventory_configuration")]
			local var_87_4 = GameSession.game_object_field(arg_87_0, arg_87_1, "health")
			local var_87_5 = {
				ai_system = {
					go_id = arg_87_1,
					game = arg_87_0,
					side_id = var_87_2
				},
				locomotion_system = {
					go_id = arg_87_1,
					breed = var_87_0,
					game = arg_87_0
				},
				health_system = {
					health = var_87_4
				},
				death_system = {
					is_husk = true,
					death_reaction_template = var_87_0.death_reaction,
					disable_second_hit_ragdoll = var_87_0.disable_second_hit_ragdoll
				},
				hit_reaction_system = {
					is_husk = true,
					hit_reaction_template = var_87_0.hit_reaction,
					hit_effect_template = var_87_0.hit_effect_template
				},
				ai_inventory_system = {
					inventory_configuration_name = var_87_3
				},
				dialogue_system = {
					faction = "enemy",
					breed_name = var_87_1
				},
				animation_movement_system = {
					is_husk = true,
					template = var_87_0.animation_movement_template
				},
				proximity_system = {
					breed = var_87_0
				}
			}

			return var_87_0.unit_template, var_87_5
		end,
		ai_unit_grey_seer = function (arg_88_0, arg_88_1, arg_88_2, arg_88_3, arg_88_4)
			local var_88_0, var_88_1, var_88_2 = var_0_2(arg_88_3, arg_88_0, arg_88_1)
			local var_88_3 = GameSession.game_object_field(arg_88_0, arg_88_1, "health")
			local var_88_4 = {
				ai_system = {
					go_id = arg_88_1,
					game = arg_88_0,
					side_id = var_88_2
				},
				locomotion_system = {
					go_id = arg_88_1,
					breed = var_88_0,
					game = arg_88_0
				},
				health_system = {
					health = var_88_3
				},
				death_system = {
					is_husk = true,
					death_reaction_template = var_88_0.death_reaction,
					disable_second_hit_ragdoll = var_88_0.disable_second_hit_ragdoll
				},
				hit_reaction_system = {
					is_husk = true,
					hit_reaction_template = var_88_0.hit_reaction,
					hit_effect_template = var_88_0.hit_effect_template
				},
				dialogue_system = {
					faction = "enemy",
					breed_name = var_88_1
				},
				proximity_system = {
					breed = var_88_0
				},
				buff_system = {
					breed = var_88_0
				}
			}

			return var_88_0.unit_template, var_88_4
		end,
		ai_unit_tentacle = function (arg_89_0, arg_89_1, arg_89_2, arg_89_3, arg_89_4)
			local var_89_0, var_89_1, var_89_2 = var_0_2(arg_89_3, arg_89_0, arg_89_1)
			local var_89_3 = GameSession.game_object_field(arg_89_0, arg_89_1, "portal_unit_id")
			local var_89_4 = Managers.state.unit_storage:unit(var_89_3)
			local var_89_5 = GameSession.game_object_field(arg_89_0, arg_89_1, "health")
			local var_89_6 = GameSession.game_object_field(arg_89_0, arg_89_1, "tentacle_template_id")
			local var_89_7 = {
				ai_supplementary_system = {
					portal_unit = var_89_4,
					tentacle_template_name = var_89_6
				},
				ai_system = {
					go_id = arg_89_1,
					game = arg_89_0,
					side_id = var_89_2
				},
				death_system = {
					is_husk = true,
					death_reaction_template = var_89_0.death_reaction,
					disable_second_hit_ragdoll = var_89_0.disable_second_hit_ragdoll
				},
				dialogue_system = {
					faction = "enemy",
					breed_name = var_89_1
				},
				health_system = {
					health = var_89_5
				},
				proximity_system = {
					breed = var_89_0
				},
				buff_system = {
					breed = var_89_0
				}
			}

			return var_89_0.unit_template, var_89_7
		end,
		ai_unit_vortex = function (arg_90_0, arg_90_1, arg_90_2, arg_90_3, arg_90_4)
			local var_90_0, var_90_1, var_90_2 = var_0_2(arg_90_3, arg_90_0, arg_90_1)
			local var_90_3 = GameSession.game_object_field(arg_90_0, arg_90_1, "vortex_template_id")
			local var_90_4 = NetworkLookup.vortex_templates[var_90_3]
			local var_90_5 = GameSession.game_object_field(arg_90_0, arg_90_1, "inner_decal_unit_id")
			local var_90_6 = Managers.state.unit_storage:unit(var_90_5)
			local var_90_7 = GameSession.game_object_field(arg_90_0, arg_90_1, "outer_decal_unit_id")
			local var_90_8 = Managers.state.unit_storage:unit(var_90_7)
			local var_90_9 = GameSession.game_object_field(arg_90_0, arg_90_1, "owner_unit_id")
			local var_90_10 = Managers.state.unit_storage:unit(var_90_9)
			local var_90_11 = {
				ai_system = {
					go_id = arg_90_1,
					game = arg_90_0,
					side_id = var_90_2
				},
				locomotion_system = {
					go_id = arg_90_1,
					breed = var_90_0,
					game = arg_90_0
				},
				ai_supplementary_system = {
					vortex_template_name = var_90_4,
					inner_decal_unit = var_90_6,
					outer_decal_unit = var_90_8,
					owner_unit = var_90_10
				}
			}

			return var_90_0.unit_template, var_90_11
		end,
		ai_unit_plague_wave_spawner = function (arg_91_0, arg_91_1, arg_91_2, arg_91_3, arg_91_4)
			local var_91_0, var_91_1, var_91_2 = var_0_2(arg_91_3, arg_91_0, arg_91_1)
			local var_91_3 = {
				ai_system = {
					go_id = arg_91_1,
					game = arg_91_0,
					side_id = var_91_2
				}
			}

			return var_91_0.unit_template, var_91_3
		end,
		ai_unit_tentacle_portal = function (arg_92_0, arg_92_1, arg_92_2, arg_92_3, arg_92_4)
			local var_92_0 = "ai_unit_tentacle_portal"
			local var_92_1 = GameSession.game_object_field(arg_92_0, arg_92_1, "health")
			local var_92_2 = {
				health_system = {
					health = var_92_1
				},
				death_system = {
					death_reaction_template = "chaos_tentacle_portal",
					is_husk = true
				}
			}

			return var_92_0, var_92_2
		end,
		ai_unit_with_inventory = function (arg_93_0, arg_93_1, arg_93_2, arg_93_3, arg_93_4)
			local var_93_0, var_93_1, var_93_2 = var_0_2(arg_93_3, arg_93_0, arg_93_1)
			local var_93_3 = NetworkLookup.ai_inventory[GameSession.game_object_field(arg_93_0, arg_93_1, "inventory_configuration")]
			local var_93_4 = GameSession.game_object_field(arg_93_0, arg_93_1, "health")
			local var_93_5 = {
				ai_system = {
					go_id = arg_93_1,
					game = arg_93_0,
					side_id = var_93_2
				},
				locomotion_system = {
					go_id = arg_93_1,
					breed = var_93_0,
					game = arg_93_0
				},
				health_system = {
					health = var_93_4
				},
				death_system = {
					is_husk = true,
					death_reaction_template = var_93_0.death_reaction,
					disable_second_hit_ragdoll = var_93_0.disable_second_hit_ragdoll
				},
				hit_reaction_system = {
					is_husk = true,
					hit_reaction_template = var_93_0.hit_reaction,
					hit_effect_template = var_93_0.hit_effect_template
				},
				ai_inventory_system = {
					inventory_configuration_name = var_93_3
				},
				aim_system = {
					is_husk = true,
					template = var_93_0.aim_template
				},
				dialogue_system = {
					faction = "enemy",
					breed_name = var_93_1
				},
				proximity_system = {
					breed = var_93_0
				},
				buff_system = {
					breed = var_93_0
				},
				animation_movement_system = {
					is_husk = true,
					template = var_93_0.animation_movement_template
				}
			}

			return var_93_0.unit_template, var_93_5
		end,
		ai_unit_with_inventory_and_shield = function (arg_94_0, arg_94_1, arg_94_2, arg_94_3, arg_94_4)
			local var_94_0, var_94_1, var_94_2 = var_0_2(arg_94_3, arg_94_0, arg_94_1)
			local var_94_3 = NetworkLookup.ai_inventory[GameSession.game_object_field(arg_94_0, arg_94_1, "inventory_configuration")]
			local var_94_4 = GameSession.game_object_field(arg_94_0, arg_94_1, "health")
			local var_94_5 = GameSession.game_object_field(arg_94_0, arg_94_1, "is_blocking")
			local var_94_6 = {
				ai_system = {
					go_id = arg_94_1,
					game = arg_94_0,
					side_id = var_94_2
				},
				locomotion_system = {
					go_id = arg_94_1,
					breed = var_94_0,
					game = arg_94_0
				},
				health_system = {
					health = var_94_4
				},
				death_system = {
					is_husk = true,
					death_reaction_template = var_94_0.death_reaction,
					disable_second_hit_ragdoll = var_94_0.disable_second_hit_ragdoll
				},
				hit_reaction_system = {
					is_husk = true,
					hit_reaction_template = var_94_0.hit_reaction,
					hit_effect_template = var_94_0.hit_effect_template
				},
				ai_inventory_system = {
					inventory_configuration_name = var_94_3
				},
				dialogue_system = {
					faction = "enemy",
					breed_name = var_94_1
				},
				ai_shield_system = {
					is_blocking = var_94_5
				},
				aim_system = {
					is_husk = true,
					template = var_94_0.aim_template
				},
				proximity_system = {
					breed = var_94_0
				},
				buff_system = {
					breed = var_94_0
				}
			}

			return var_94_0.unit_template, var_94_6
		end,
		ai_unit_storm_vermin_warlord = function (arg_95_0, arg_95_1, arg_95_2, arg_95_3, arg_95_4)
			local var_95_0, var_95_1, var_95_2 = var_0_2(arg_95_3, arg_95_0, arg_95_1)
			local var_95_3 = NetworkLookup.ai_inventory[GameSession.game_object_field(arg_95_0, arg_95_1, "inventory_configuration")]
			local var_95_4 = GameSession.game_object_field(arg_95_0, arg_95_1, "health")
			local var_95_5 = GameSession.game_object_field(arg_95_0, arg_95_1, "is_blocking")
			local var_95_6 = GameSession.game_object_field(arg_95_0, arg_95_1, "is_dodging")
			local var_95_7 = {
				ai_system = {
					go_id = arg_95_1,
					game = arg_95_0,
					side_id = var_95_2
				},
				locomotion_system = {
					go_id = arg_95_1,
					breed = var_95_0,
					game = arg_95_0
				},
				health_system = {
					health = var_95_4
				},
				death_system = {
					is_husk = true,
					death_reaction_template = var_95_0.death_reaction,
					disable_second_hit_ragdoll = var_95_0.disable_second_hit_ragdoll
				},
				hit_reaction_system = {
					is_husk = true,
					hit_reaction_template = var_95_0.hit_reaction,
					hit_effect_template = var_95_0.hit_effect_template
				},
				ai_inventory_system = {
					inventory_configuration_name = var_95_3
				},
				dialogue_system = {
					faction = "enemy",
					breed_name = var_95_1
				},
				ai_shield_system = {
					is_blocking = var_95_5
				},
				proximity_system = {
					breed = var_95_0
				},
				buff_system = {
					breed = var_95_0
				}
			}

			return var_95_0.unit_template, var_95_7
		end,
		ai_unit_chaos_troll = function (arg_96_0, arg_96_1, arg_96_2, arg_96_3, arg_96_4)
			local var_96_0, var_96_1 = var_0_2(arg_96_3, arg_96_0, arg_96_1)
			local var_96_2 = NetworkLookup.ai_inventory[GameSession.game_object_field(arg_96_0, arg_96_1, "inventory_configuration")]
			local var_96_3 = GameSession.game_object_field(arg_96_0, arg_96_1, "side_id")
			local var_96_4 = GameSession.game_object_field(arg_96_0, arg_96_1, "health")
			local var_96_5 = {
				ai_system = {
					go_id = arg_96_1,
					game = arg_96_0,
					side_id = var_96_3
				},
				locomotion_system = {
					go_id = arg_96_1,
					breed = var_96_0,
					game = arg_96_0
				},
				health_system = {
					health = var_96_4,
					breed = var_96_0
				},
				death_system = {
					is_husk = true,
					death_reaction_template = var_96_0.death_reaction,
					disable_second_hit_ragdoll = var_96_0.disable_second_hit_ragdoll
				},
				hit_reaction_system = {
					is_husk = true,
					hit_reaction_template = var_96_0.hit_reaction,
					hit_effect_template = var_96_0.hit_effect_template
				},
				ai_inventory_system = {
					inventory_configuration_name = var_96_2
				},
				dialogue_system = {
					faction = "enemy",
					breed_name = var_96_1
				},
				aim_system = {
					is_husk = true,
					template = var_96_0.aim_template
				},
				animation_movement_system = {
					is_husk = true,
					template = var_96_0.animation_movement_template
				},
				proximity_system = {
					breed = var_96_0
				},
				buff_system = {
					breed = var_96_0
				}
			}

			return var_96_0.unit_template, var_96_5
		end,
		ai_lord_with_inventory = function (arg_97_0, arg_97_1, arg_97_2, arg_97_3, arg_97_4)
			local var_97_0 = GameSession.game_object_field(arg_97_0, arg_97_1, "side_id")
			local var_97_1 = GameSession.game_object_field(arg_97_0, arg_97_1, "breed_name")
			local var_97_2 = NetworkLookup.breeds[var_97_1]
			local var_97_3 = Breeds[var_97_2]

			Unit.set_data(arg_97_3, "breed", var_97_3)

			local var_97_4 = NetworkLookup.ai_inventory[GameSession.game_object_field(arg_97_0, arg_97_1, "inventory_configuration")]
			local var_97_5 = GameSession.game_object_field(arg_97_0, arg_97_1, "health")
			local var_97_6 = {
				ai_system = {
					go_id = arg_97_1,
					game = arg_97_0,
					side_id = var_97_0
				},
				locomotion_system = {
					go_id = arg_97_1,
					breed = var_97_3,
					game = arg_97_0
				},
				health_system = {
					health = var_97_5
				},
				death_system = {
					is_husk = true,
					death_reaction_template = var_97_3.death_reaction,
					disable_second_hit_ragdoll = var_97_3.disable_second_hit_ragdoll
				},
				hit_reaction_system = {
					is_husk = true,
					hit_reaction_template = var_97_3.hit_reaction,
					hit_effect_template = var_97_3.hit_effect_template
				},
				ai_inventory_system = {
					inventory_configuration_name = var_97_4
				},
				dialogue_system = {
					faction = "enemy",
					breed_name = var_97_2
				},
				aim_system = {
					is_husk = true,
					template = var_97_3.aim_template
				},
				proximity_system = {
					breed = var_97_3
				},
				buff_system = {
					breed = var_97_3
				}
			}

			return var_97_3.unit_template, var_97_6
		end,
		ai_unit_pack_master = function (arg_98_0, arg_98_1, arg_98_2, arg_98_3, arg_98_4)
			local var_98_0, var_98_1, var_98_2 = var_0_2(arg_98_3, arg_98_0, arg_98_1)
			local var_98_3 = NetworkLookup.ai_inventory[GameSession.game_object_field(arg_98_0, arg_98_1, "inventory_configuration")]
			local var_98_4 = GameSession.game_object_field(arg_98_0, arg_98_1, "health")
			local var_98_5 = {
				ai_system = {
					go_id = arg_98_1,
					game = arg_98_0,
					side_id = var_98_2
				},
				locomotion_system = {
					go_id = arg_98_1,
					breed = var_98_0,
					game = arg_98_0
				},
				health_system = {
					health = var_98_4
				},
				death_system = {
					is_husk = true,
					death_reaction_template = var_98_0.death_reaction,
					disable_second_hit_ragdoll = var_98_0.disable_second_hit_ragdoll
				},
				hit_reaction_system = {
					is_husk = true,
					hit_reaction_template = var_98_0.hit_reaction,
					hit_effect_template = var_98_0.hit_effect_template
				},
				ai_inventory_system = {
					inventory_configuration_name = var_98_3
				},
				dialogue_system = {
					faction = "enemy",
					breed_name = var_98_1
				},
				aim_system = {
					template = "pack_master",
					is_husk = true
				},
				proximity_system = {
					breed = var_98_0
				},
				buff_system = {
					breed = var_98_0
				}
			}

			return var_98_0.unit_template, var_98_5
		end,
		ai_unit_ratling_gunner = function (arg_99_0, arg_99_1, arg_99_2, arg_99_3, arg_99_4)
			local var_99_0, var_99_1, var_99_2 = var_0_2(arg_99_3, arg_99_0, arg_99_1)
			local var_99_3 = NetworkLookup.ai_inventory[GameSession.game_object_field(arg_99_0, arg_99_1, "inventory_configuration")]
			local var_99_4 = GameSession.game_object_field(arg_99_0, arg_99_1, "health")
			local var_99_5 = {
				ai_system = {
					go_id = arg_99_1,
					game = arg_99_0,
					side_id = var_99_2
				},
				locomotion_system = {
					go_id = arg_99_1,
					breed = var_99_0,
					game = arg_99_0
				},
				health_system = {
					health = var_99_4
				},
				death_system = {
					is_husk = true,
					death_reaction_template = var_99_0.death_reaction,
					disable_second_hit_ragdoll = var_99_0.disable_second_hit_ragdoll
				},
				hit_reaction_system = {
					is_husk = true,
					hit_reaction_template = var_99_0.hit_reaction,
					hit_effect_template = var_99_0.hit_effect_template
				},
				ai_inventory_system = {
					inventory_configuration_name = var_99_3
				},
				dialogue_system = {
					faction = "enemy",
					breed_name = var_99_1
				},
				aim_system = {
					template = "ratling_gunner",
					is_husk = true
				},
				proximity_system = {
					breed = var_99_0
				},
				buff_system = {
					breed = var_99_0
				}
			}

			return var_99_0.unit_template, var_99_5
		end,
		ai_unit_warpfire_thrower = function (arg_100_0, arg_100_1, arg_100_2, arg_100_3, arg_100_4)
			local var_100_0, var_100_1, var_100_2 = var_0_2(arg_100_3, arg_100_0, arg_100_1)
			local var_100_3 = NetworkLookup.ai_inventory[GameSession.game_object_field(arg_100_0, arg_100_1, "inventory_configuration")]
			local var_100_4 = GameSession.game_object_field(arg_100_0, arg_100_1, "health")
			local var_100_5 = {
				ai_system = {
					go_id = arg_100_1,
					game = arg_100_0,
					side_id = var_100_2
				},
				locomotion_system = {
					go_id = arg_100_1,
					breed = var_100_0,
					game = arg_100_0
				},
				health_system = {
					health = var_100_4
				},
				death_system = {
					is_husk = true,
					death_reaction_template = var_100_0.death_reaction
				},
				hit_reaction_system = {
					is_husk = true,
					hit_reaction_template = var_100_0.hit_reaction,
					hit_effect_template = var_100_0.hit_effect_template
				},
				ai_inventory_system = {
					inventory_configuration_name = var_100_3
				},
				dialogue_system = {
					faction = "enemy",
					breed_name = var_100_1
				},
				aim_system = {
					template = "ratling_gunner",
					is_husk = true
				},
				proximity_system = {
					breed = var_100_0
				},
				buff_system = {
					breed = var_100_0
				}
			}

			return var_100_0.unit_template, var_100_5
		end,
		ai_unit_stormfiend = function (arg_101_0, arg_101_1, arg_101_2, arg_101_3, arg_101_4)
			local var_101_0, var_101_1, var_101_2 = var_0_2(arg_101_3, arg_101_0, arg_101_1)
			local var_101_3 = NetworkLookup.ai_inventory[GameSession.game_object_field(arg_101_0, arg_101_1, "inventory_configuration")]
			local var_101_4 = GameSession.game_object_field(arg_101_0, arg_101_1, "health")
			local var_101_5 = {
				ai_system = {
					go_id = arg_101_1,
					game = arg_101_0,
					side_id = var_101_2
				},
				locomotion_system = {
					go_id = arg_101_1,
					breed = var_101_0,
					game = arg_101_0
				},
				health_system = {
					health = var_101_4
				},
				death_system = {
					is_husk = true,
					death_reaction_template = var_101_0.death_reaction,
					disable_second_hit_ragdoll = var_101_0.disable_second_hit_ragdoll
				},
				hit_reaction_system = {
					is_husk = true,
					hit_reaction_template = var_101_0.hit_reaction,
					hit_effect_template = var_101_0.hit_effect_template
				},
				ai_inventory_system = {
					inventory_configuration_name = var_101_3
				},
				dialogue_system = {
					faction = "enemy",
					breed_name = var_101_1
				},
				aim_system = {
					is_husk = true,
					template = var_101_0.aim_template
				},
				proximity_system = {
					breed = var_101_0
				},
				buff_system = {
					breed = var_101_0
				}
			}

			return var_101_0.unit_template, var_101_5
		end,
		ai_unit_stormfiend_boss = function (arg_102_0, arg_102_1, arg_102_2, arg_102_3, arg_102_4)
			local var_102_0, var_102_1, var_102_2 = var_0_2(arg_102_3, arg_102_0, arg_102_1)
			local var_102_3 = NetworkLookup.ai_inventory[GameSession.game_object_field(arg_102_0, arg_102_1, "inventory_configuration")]
			local var_102_4 = GameSession.game_object_field(arg_102_0, arg_102_1, "health")
			local var_102_5 = {
				ai_system = {
					go_id = arg_102_1,
					game = arg_102_0,
					side_id = var_102_2
				},
				locomotion_system = {
					go_id = arg_102_1,
					breed = var_102_0,
					game = arg_102_0
				},
				health_system = {
					health = var_102_4
				},
				death_system = {
					is_husk = true,
					death_reaction_template = var_102_0.death_reaction,
					disable_second_hit_ragdoll = var_102_0.disable_second_hit_ragdoll
				},
				hit_reaction_system = {
					is_husk = true,
					hit_reaction_template = var_102_0.hit_reaction,
					hit_effect_template = var_102_0.hit_effect_template
				},
				ai_inventory_system = {
					inventory_configuration_name = var_102_3
				},
				dialogue_system = {
					faction = "enemy",
					breed_name = var_102_1
				},
				aim_system = {
					is_husk = true,
					template = var_102_0.aim_template
				},
				proximity_system = {
					breed = var_102_0
				},
				buff_system = {
					breed = var_102_0
				}
			}

			return var_102_0.unit_template, var_102_5
		end,
		player_projectile_unit = function (arg_103_0, arg_103_1, arg_103_2, arg_103_3, arg_103_4)
			local var_103_0 = GameSession.game_object_field(arg_103_0, arg_103_1, "angle")
			local var_103_1 = GameSession.game_object_field(arg_103_0, arg_103_1, "target_vector")
			local var_103_2 = GameSession.game_object_field(arg_103_0, arg_103_1, "initial_position")
			local var_103_3 = GameSession.game_object_field(arg_103_0, arg_103_1, "speed")
			local var_103_4 = GameSession.game_object_field(arg_103_0, arg_103_1, "gravity_settings")
			local var_103_5 = GameSession.game_object_field(arg_103_0, arg_103_1, "trajectory_template_name")
			local var_103_6 = GameSession.game_object_field(arg_103_0, arg_103_1, "owner_unit")
			local var_103_7 = GameSession.game_object_field(arg_103_0, arg_103_1, "item_name")
			local var_103_8 = GameSession.game_object_field(arg_103_0, arg_103_1, "item_template_name")
			local var_103_9 = GameSession.game_object_field(arg_103_0, arg_103_1, "action_name")
			local var_103_10 = GameSession.game_object_field(arg_103_0, arg_103_1, "sub_action_name")
			local var_103_11 = Managers.time:time("game")
			local var_103_12 = GameSession.game_object_field(arg_103_0, arg_103_1, "fast_forward_time")
			local var_103_13 = GameSession.game_object_field(arg_103_0, arg_103_1, "rotation_speed")
			local var_103_14 = GameSession.game_object_field(arg_103_0, arg_103_1, "scale") / 100
			local var_103_15 = NetworkLookup.item_names[var_103_7]
			local var_103_16 = NetworkLookup.item_template_names[var_103_8]
			local var_103_17 = NetworkLookup.actions[var_103_9]
			local var_103_18 = NetworkLookup.sub_actions[var_103_10]
			local var_103_19 = GameSession.game_object_field(arg_103_0, arg_103_1, "power_level")
			local var_103_20 = var_103_6 ~= 0 and Managers.state.unit_storage:unit(var_103_6) or nil
			local var_103_21 = {
				projectile_locomotion_system = {
					is_husk = true,
					angle = var_103_0,
					speed = var_103_3,
					target_vector = var_103_1,
					initial_position = var_103_2,
					gravity_settings = NetworkLookup.projectile_gravity_settings[var_103_4],
					trajectory_template_name = NetworkLookup.projectile_templates[var_103_5],
					fast_forward_time = var_103_12,
					rotation_speed = var_103_13
				},
				projectile_impact_system = {
					item_name = var_103_15,
					owner_unit = var_103_20
				},
				projectile_system = {
					item_name = var_103_15,
					item_template_name = var_103_16,
					action_name = var_103_17,
					sub_action_name = var_103_18,
					owner_unit = var_103_20,
					time_initialized = var_103_11,
					scale = var_103_14,
					power_level = var_103_19
				}
			}

			return WeaponUtils.get_weapon_template(var_103_16).actions[var_103_17][var_103_18].projectile_info.projectile_unit_template_name or "player_projectile_unit", var_103_21
		end,
		sticky_projectile_unit = function (arg_104_0, arg_104_1, arg_104_2, arg_104_3, arg_104_4)
			local var_104_0 = GameSession.game_object_field(arg_104_0, arg_104_1, "target_vector")
			local var_104_1 = GameSession.game_object_field(arg_104_0, arg_104_1, "initial_position")
			local var_104_2 = GameSession.game_object_field(arg_104_0, arg_104_1, "speed")
			local var_104_3 = GameSession.game_object_field(arg_104_0, arg_104_1, "target_unit")
			local var_104_4 = GameSession.game_object_field(arg_104_0, arg_104_1, "stopped")
			local var_104_5 = GameSession.game_object_field(arg_104_0, arg_104_1, "seed")
			local var_104_6 = GameSession.game_object_field(arg_104_0, arg_104_1, "charge_level")
			local var_104_7 = GameSession.game_object_field(arg_104_0, arg_104_1, "owner_unit")
			local var_104_8 = GameSession.game_object_field(arg_104_0, arg_104_1, "item_name")
			local var_104_9 = GameSession.game_object_field(arg_104_0, arg_104_1, "item_template_name")
			local var_104_10 = GameSession.game_object_field(arg_104_0, arg_104_1, "action_name")
			local var_104_11 = GameSession.game_object_field(arg_104_0, arg_104_1, "sub_action_name")
			local var_104_12 = GameSession.game_object_field(arg_104_0, arg_104_1, "scale") / 100
			local var_104_13 = NetworkLookup.item_names[var_104_8]
			local var_104_14 = NetworkLookup.item_template_names[var_104_9]
			local var_104_15 = NetworkLookup.actions[var_104_10]
			local var_104_16 = NetworkLookup.sub_actions[var_104_11]
			local var_104_17 = GameSession.game_object_field(arg_104_0, arg_104_1, "power_level")
			local var_104_18 = var_104_7 ~= 0 and Managers.state.unit_storage:unit(var_104_7) or nil
			local var_104_19 = var_104_3 ~= 0 and Managers.state.unit_storage:unit(var_104_3) or nil
			local var_104_20 = {
				projectile_locomotion_system = {
					is_husk = true,
					speed = var_104_2,
					target_vector = var_104_0,
					initial_position = var_104_1,
					target_unit = var_104_19,
					stopped = var_104_4,
					seed = var_104_5
				},
				projectile_impact_system = {
					item_name = var_104_13,
					owner_unit = var_104_18
				},
				projectile_system = {
					item_name = var_104_13,
					item_template_name = var_104_14,
					action_name = var_104_15,
					sub_action_name = var_104_16,
					owner_unit = var_104_18,
					time_initialized = Managers.time:time("game"),
					scale = var_104_12,
					power_level = var_104_17,
					stopped = var_104_4,
					charge_level = var_104_6
				}
			}

			return WeaponUtils.get_weapon_template(var_104_14).actions[var_104_15][var_104_16].projectile_info.projectile_unit_template_name or "player_projectile_unit", var_104_20
		end,
		prop_projectile_unit = function (arg_105_0, arg_105_1, arg_105_2, arg_105_3, arg_105_4)
			local var_105_0 = GameSession.game_object_field(arg_105_0, arg_105_1, "network_position")
			local var_105_1 = GameSession.game_object_field(arg_105_0, arg_105_1, "network_rotation")
			local var_105_2 = GameSession.game_object_field(arg_105_0, arg_105_1, "network_velocity")
			local var_105_3 = GameSession.game_object_field(arg_105_0, arg_105_1, "network_angular_velocity")
			local var_105_4 = {
				projectile_locomotion_system = {
					network_position = var_105_0,
					network_rotation = var_105_1,
					network_velocity = var_105_2,
					network_angular_velocity = var_105_3
				}
			}

			return "prop_projectile_unit", var_105_4
		end,
		pickup_projectile_unit = function (arg_106_0, arg_106_1, arg_106_2, arg_106_3, arg_106_4)
			local var_106_0 = GameSession.game_object_field(arg_106_0, arg_106_1, "network_position")
			local var_106_1 = GameSession.game_object_field(arg_106_0, arg_106_1, "network_rotation")
			local var_106_2 = GameSession.game_object_field(arg_106_0, arg_106_1, "network_velocity")
			local var_106_3 = GameSession.game_object_field(arg_106_0, arg_106_1, "network_angular_velocity")
			local var_106_4 = GameSession.game_object_field(arg_106_0, arg_106_1, "pickup_name")
			local var_106_5 = GameSession.game_object_field(arg_106_0, arg_106_1, "has_physics")
			local var_106_6 = GameSession.game_object_field(arg_106_0, arg_106_1, "spawn_type")
			local var_106_7 = {
				projectile_locomotion_system = {
					network_position = var_106_0,
					network_rotation = var_106_1,
					network_velocity = var_106_2,
					network_angular_velocity = var_106_3
				},
				pickup_system = {
					pickup_name = NetworkLookup.pickup_names[var_106_4],
					has_physics = var_106_5,
					spawn_type = NetworkLookup.pickup_spawn_types[var_106_6]
				}
			}

			return "pickup_projectile_unit", var_106_7
		end,
		limited_owned_pickup_projectile_unit = function (arg_107_0, arg_107_1, arg_107_2, arg_107_3, arg_107_4)
			local var_107_0 = GameSession.game_object_field(arg_107_0, arg_107_1, "network_position")
			local var_107_1 = GameSession.game_object_field(arg_107_0, arg_107_1, "network_rotation")
			local var_107_2 = GameSession.game_object_field(arg_107_0, arg_107_1, "network_velocity")
			local var_107_3 = GameSession.game_object_field(arg_107_0, arg_107_1, "network_angular_velocity")
			local var_107_4 = GameSession.game_object_field(arg_107_0, arg_107_1, "pickup_name")
			local var_107_5 = GameSession.game_object_field(arg_107_0, arg_107_1, "has_physics")
			local var_107_6 = GameSession.game_object_field(arg_107_0, arg_107_1, "spawn_type")
			local var_107_7 = GameSession.game_object_field(arg_107_0, arg_107_1, "owner_peer_id")
			local var_107_8 = GameSession.game_object_field(arg_107_0, arg_107_1, "spawn_limit")
			local var_107_9 = {
				projectile_locomotion_system = {
					network_position = var_107_0,
					network_rotation = var_107_1,
					network_velocity = var_107_2,
					network_angular_velocity = var_107_3
				},
				pickup_system = {
					pickup_name = NetworkLookup.pickup_names[var_107_4],
					has_physics = var_107_5,
					spawn_type = NetworkLookup.pickup_spawn_types[var_107_6],
					owner_peer_id = var_107_7,
					spawn_limit = var_107_8
				}
			}

			return "limited_owned_pickup_projectile_unit", var_107_9
		end,
		life_time_pickup_projectile_unit = function (arg_108_0, arg_108_1, arg_108_2, arg_108_3, arg_108_4)
			local var_108_0 = GameSession.game_object_field(arg_108_0, arg_108_1, "network_position")
			local var_108_1 = GameSession.game_object_field(arg_108_0, arg_108_1, "network_rotation")
			local var_108_2 = GameSession.game_object_field(arg_108_0, arg_108_1, "network_velocity")
			local var_108_3 = GameSession.game_object_field(arg_108_0, arg_108_1, "network_angular_velocity")
			local var_108_4 = GameSession.game_object_field(arg_108_0, arg_108_1, "pickup_name")
			local var_108_5 = GameSession.game_object_field(arg_108_0, arg_108_1, "has_physics")
			local var_108_6 = GameSession.game_object_field(arg_108_0, arg_108_1, "spawn_type")
			local var_108_7 = {
				projectile_locomotion_system = {
					network_position = var_108_0,
					network_rotation = var_108_1,
					network_velocity = var_108_2,
					network_angular_velocity = var_108_3
				},
				pickup_system = {
					pickup_name = NetworkLookup.pickup_names[var_108_4],
					has_physics = var_108_5,
					spawn_type = NetworkLookup.pickup_spawn_types[var_108_6]
				}
			}

			return "life_time_pickup_projectile_unit", var_108_7
		end,
		pickup_training_dummy_unit = function (arg_109_0, arg_109_1, arg_109_2, arg_109_3, arg_109_4)
			local var_109_0 = GameSession.game_object_field(arg_109_0, arg_109_1, "network_position")
			local var_109_1 = GameSession.game_object_field(arg_109_0, arg_109_1, "network_rotation")
			local var_109_2 = GameSession.game_object_field(arg_109_0, arg_109_1, "network_velocity")
			local var_109_3 = GameSession.game_object_field(arg_109_0, arg_109_1, "network_angular_velocity")
			local var_109_4 = GameSession.game_object_field(arg_109_0, arg_109_1, "pickup_name")
			local var_109_5 = GameSession.game_object_field(arg_109_0, arg_109_1, "has_physics")
			local var_109_6 = GameSession.game_object_field(arg_109_0, arg_109_1, "spawn_type")
			local var_109_7 = {
				projectile_locomotion_system = {
					network_position = var_109_0,
					network_rotation = var_109_1,
					network_velocity = var_109_2,
					network_angular_velocity = var_109_3
				},
				pickup_system = {
					pickup_name = NetworkLookup.pickup_names[var_109_4],
					has_physics = var_109_5,
					spawn_type = NetworkLookup.pickup_spawn_types[var_109_6]
				},
				health_system = {
					damage = 0,
					health = 100
				},
				death_system = {},
				hit_reaction_system = {}
			}

			return "pickup_training_dummy_unit", var_109_7
		end,
		versus_volume_objective_unit = function (arg_110_0, arg_110_1, arg_110_2, arg_110_3, arg_110_4)
			local var_110_0 = GameSession.game_object_field(arg_110_0, arg_110_1, "objective_name")
			local var_110_1 = GameSession.game_object_field(arg_110_0, arg_110_1, "scale")
			local var_110_2 = {
				objective_system = {
					objective_name = NetworkLookup.objective_names[var_110_0],
					scale = Vector3(var_110_1, var_110_1, var_110_1)
				}
			}

			return "versus_volume_objective_unit", var_110_2
		end,
		versus_capture_point_objective_unit = function (arg_111_0, arg_111_1, arg_111_2, arg_111_3, arg_111_4)
			local var_111_0 = GameSession.game_object_field(arg_111_0, arg_111_1, "objective_name")
			local var_111_1 = GameSession.game_object_field(arg_111_0, arg_111_1, "scale")
			local var_111_2 = GameSession.game_object_field(arg_111_0, arg_111_1, "timer")
			local var_111_3 = {
				objective_system = {
					objective_name = NetworkLookup.objective_names[var_111_0],
					scale = Vector3(var_111_1, var_111_1, var_111_1),
					timer = var_111_2
				}
			}

			return "versus_capture_point_objective_unit", var_111_3
		end,
		versus_mission_objective_unit = function (arg_112_0, arg_112_1, arg_112_2, arg_112_3, arg_112_4)
			local var_112_0 = GameSession.game_object_field(arg_112_0, arg_112_1, "objective_name")
			local var_112_1 = GameSession.game_object_field(arg_112_0, arg_112_1, "scale")
			local var_112_2 = {
				objective_system = {
					objective_name = NetworkLookup.objective_names[var_112_0],
					scale = Vector3(var_112_1, var_112_1, var_112_1)
				}
			}

			return "versus_mission_objective_unit", var_112_2
		end,
		weave_capture_point_unit = function (arg_113_0, arg_113_1, arg_113_2, arg_113_3, arg_113_4)
			local var_113_0 = GameSession.game_object_field(arg_113_0, arg_113_1, "objective_name")
			local var_113_1 = GameSession.game_object_field(arg_113_0, arg_113_1, "timer")
			local var_113_2 = GameSession.game_object_field(arg_113_0, arg_113_1, "scale")
			local var_113_3 = {
				objective_system = {
					objective_name = NetworkLookup.objective_names[var_113_0],
					timer = var_113_1,
					scale = Vector3(var_113_2, var_113_2, var_113_2)
				}
			}

			return "weave_capture_point_unit", var_113_3
		end,
		weave_target_unit = function (arg_114_0, arg_114_1, arg_114_2, arg_114_3, arg_114_4)
			local var_114_0 = GameSession.game_object_field(arg_114_0, arg_114_1, "objective_name")
			local var_114_1 = GameSession.game_object_field(arg_114_0, arg_114_1, "health")
			local var_114_2 = {
				melee = GameSession.game_object_field(arg_114_0, arg_114_1, "allow_melee_damage"),
				ranged = GameSession.game_object_field(arg_114_0, arg_114_1, "allow_ranged_damage")
			}
			local var_114_3 = {
				objective_system = {
					objective_name = NetworkLookup.objective_names[var_114_0],
					attacks_allowed = var_114_2
				},
				health_system = {
					health = var_114_1
				}
			}

			return "weave_target_unit", var_114_3
		end,
		weave_interaction_unit = function (arg_115_0, arg_115_1, arg_115_2, arg_115_3, arg_115_4)
			local var_115_0 = GameSession.game_object_field(arg_115_0, arg_115_1, "objective_name")
			local var_115_1 = GameSession.game_object_field(arg_115_0, arg_115_1, "num_times_to_complete")
			local var_115_2 = GameSession.game_object_field(arg_115_0, arg_115_1, "duration")
			local var_115_3 = {
				objective_system = {
					objective_name = NetworkLookup.objective_names[var_115_0],
					num_times_to_complete = var_115_1,
					duration = var_115_2
				}
			}

			return "weave_interaction_unit", var_115_3
		end,
		weave_doom_wheel_unit = function (arg_116_0, arg_116_1, arg_116_2, arg_116_3, arg_116_4)
			local var_116_0 = GameSession.game_object_field(arg_116_0, arg_116_1, "objective_name")
			local var_116_1 = {
				objective_system = {
					objective_name = NetworkLookup.objective_names[var_116_0]
				}
			}

			return "weave_doom_wheel", var_116_1
		end,
		weave_kill_enemies_unit = function (arg_117_0, arg_117_1, arg_117_2, arg_117_3, arg_117_4)
			local var_117_0 = GameSession.game_object_field(arg_117_0, arg_117_1, "objective_name")
			local var_117_1 = GameSession.game_object_field(arg_117_0, arg_117_1, "amount")
			local var_117_2 = {
				objective_system = {
					objective_name = NetworkLookup.objective_names[var_117_0],
					amount = var_117_1
				}
			}

			return "weave_kill_enemies_unit", var_117_2
		end,
		pickup_torch_unit_init = function (arg_118_0, arg_118_1, arg_118_2, arg_118_3, arg_118_4)
			local var_118_0 = GameSession.game_object_field(arg_118_0, arg_118_1, "network_position")
			local var_118_1 = GameSession.game_object_field(arg_118_0, arg_118_1, "network_rotation")
			local var_118_2 = GameSession.game_object_field(arg_118_0, arg_118_1, "network_velocity")
			local var_118_3 = GameSession.game_object_field(arg_118_0, arg_118_1, "network_angular_velocity")
			local var_118_4 = GameSession.game_object_field(arg_118_0, arg_118_1, "pickup_name")
			local var_118_5 = GameSession.game_object_field(arg_118_0, arg_118_1, "has_physics")
			local var_118_6 = GameSession.game_object_field(arg_118_0, arg_118_1, "spawn_type")
			local var_118_7 = {
				projectile_locomotion_system = {
					network_position = var_118_0,
					network_rotation = var_118_1,
					network_velocity = var_118_2,
					network_angular_velocity = var_118_3
				},
				pickup_system = {
					pickup_name = NetworkLookup.pickup_names[var_118_4],
					has_physics = var_118_5,
					spawn_type = NetworkLookup.pickup_spawn_types[var_118_6]
				}
			}

			return "pickup_torch_unit", var_118_7
		end,
		pickup_torch_unit = function (arg_119_0, arg_119_1, arg_119_2, arg_119_3, arg_119_4)
			local var_119_0 = GameSession.game_object_field(arg_119_0, arg_119_1, "network_position")
			local var_119_1 = GameSession.game_object_field(arg_119_0, arg_119_1, "network_rotation")
			local var_119_2 = GameSession.game_object_field(arg_119_0, arg_119_1, "network_velocity")
			local var_119_3 = GameSession.game_object_field(arg_119_0, arg_119_1, "network_angular_velocity")
			local var_119_4 = GameSession.game_object_field(arg_119_0, arg_119_1, "pickup_name")
			local var_119_5 = GameSession.game_object_field(arg_119_0, arg_119_1, "has_physics")
			local var_119_6 = GameSession.game_object_field(arg_119_0, arg_119_1, "spawn_type")
			local var_119_7 = {
				projectile_locomotion_system = {
					network_position = var_119_0,
					network_rotation = var_119_1,
					network_velocity = var_119_2,
					network_angular_velocity = var_119_3
				},
				pickup_system = {
					pickup_name = NetworkLookup.pickup_names[var_119_4],
					has_physics = var_119_5,
					spawn_type = NetworkLookup.pickup_spawn_types[var_119_6]
				}
			}

			return "pickup_torch_unit", var_119_7
		end,
		pickup_projectile_unit_limited = function (arg_120_0, arg_120_1, arg_120_2, arg_120_3, arg_120_4)
			local var_120_0 = GameSession.game_object_field(arg_120_0, arg_120_1, "network_position")
			local var_120_1 = GameSession.game_object_field(arg_120_0, arg_120_1, "network_rotation")
			local var_120_2 = GameSession.game_object_field(arg_120_0, arg_120_1, "network_velocity")
			local var_120_3 = GameSession.game_object_field(arg_120_0, arg_120_1, "network_angular_velocity")
			local var_120_4 = GameSession.game_object_field(arg_120_0, arg_120_1, "pickup_name")
			local var_120_5 = GameSession.game_object_field(arg_120_0, arg_120_1, "owner_peer_id")
			local var_120_6 = GameSession.game_object_field(arg_120_0, arg_120_1, "has_physics")
			local var_120_7 = GameSession.game_object_field(arg_120_0, arg_120_1, "spawn_type")
			local var_120_8 = GameSession.game_object_field(arg_120_0, arg_120_1, "spawner_unit")
			local var_120_9 = GameSession.game_object_field(arg_120_0, arg_120_1, "spawner_unit_is_level_unit")
			local var_120_10 = GameSession.game_object_field(arg_120_0, arg_120_1, "limited_item_id")
			local var_120_11 = Managers.state.network:game_object_or_level_unit(var_120_8, var_120_9)
			local var_120_12 = {
				projectile_locomotion_system = {
					network_position = var_120_0,
					network_rotation = var_120_1,
					network_velocity = var_120_2,
					network_angular_velocity = var_120_3
				},
				pickup_system = {
					pickup_name = NetworkLookup.pickup_names[var_120_4],
					owner_peer_id = var_120_5,
					has_physics = var_120_6,
					spawn_type = NetworkLookup.pickup_spawn_types[var_120_7]
				},
				limited_item_track_system = {
					spawner_unit = var_120_11,
					id = var_120_10
				}
			}

			return "pickup_projectile_unit_limited", var_120_12
		end,
		explosive_pickup_projectile_unit = function (arg_121_0, arg_121_1, arg_121_2, arg_121_3, arg_121_4)
			local var_121_0 = GameSession.game_object_field(arg_121_0, arg_121_1, "network_position")
			local var_121_1 = GameSession.game_object_field(arg_121_0, arg_121_1, "network_rotation")
			local var_121_2 = GameSession.game_object_field(arg_121_0, arg_121_1, "network_velocity")
			local var_121_3 = GameSession.game_object_field(arg_121_0, arg_121_1, "network_angular_velocity")
			local var_121_4 = GameSession.game_object_field(arg_121_0, arg_121_1, "pickup_name")
			local var_121_5 = GameSession.game_object_field(arg_121_0, arg_121_1, "has_physics")
			local var_121_6 = GameSession.game_object_field(arg_121_0, arg_121_1, "spawn_type")
			local var_121_7 = GameSession.game_object_field(arg_121_0, arg_121_1, "damage")
			local var_121_8 = GameSession.game_object_field(arg_121_0, arg_121_1, "explode_time")
			local var_121_9 = GameSession.game_object_field(arg_121_0, arg_121_1, "fuse_time")
			local var_121_10 = GameSession.game_object_field(arg_121_0, arg_121_1, "item_name")
			local var_121_11 = GameSession.game_object_field(arg_121_0, arg_121_1, "always_show")
			local var_121_12

			if var_121_8 ~= 0 then
				var_121_12 = {
					explode_time = var_121_8,
					fuse_time = var_121_9
				}
			end

			local var_121_13 = {
				projectile_locomotion_system = {
					network_position = var_121_0,
					network_rotation = var_121_1,
					network_velocity = var_121_2,
					network_angular_velocity = var_121_3
				},
				pickup_system = {
					pickup_name = NetworkLookup.pickup_names[var_121_4],
					has_physics = var_121_5,
					spawn_type = NetworkLookup.pickup_spawn_types[var_121_6]
				},
				health_system = {
					in_hand = false,
					item_name = NetworkLookup.item_names[var_121_10],
					damage = var_121_7,
					health_data = var_121_12
				},
				death_system = {
					in_hand = false,
					item_name = NetworkLookup.item_names[var_121_10]
				},
				tutorial_system = {
					always_show = var_121_11
				}
			}

			return "explosive_pickup_projectile_unit", var_121_13
		end,
		explosive_pickup_projectile_unit_limited = function (arg_122_0, arg_122_1, arg_122_2, arg_122_3, arg_122_4)
			local var_122_0 = GameSession.game_object_field(arg_122_0, arg_122_1, "network_position")
			local var_122_1 = GameSession.game_object_field(arg_122_0, arg_122_1, "network_rotation")
			local var_122_2 = GameSession.game_object_field(arg_122_0, arg_122_1, "network_velocity")
			local var_122_3 = GameSession.game_object_field(arg_122_0, arg_122_1, "network_angular_velocity")
			local var_122_4 = GameSession.game_object_field(arg_122_0, arg_122_1, "pickup_name")
			local var_122_5 = GameSession.game_object_field(arg_122_0, arg_122_1, "has_physics")
			local var_122_6 = GameSession.game_object_field(arg_122_0, arg_122_1, "spawn_type")
			local var_122_7 = GameSession.game_object_field(arg_122_0, arg_122_1, "spawner_unit")
			local var_122_8 = GameSession.game_object_field(arg_122_0, arg_122_1, "spawner_unit_is_level_unit")
			local var_122_9 = GameSession.game_object_field(arg_122_0, arg_122_1, "limited_item_id")
			local var_122_10 = GameSession.game_object_field(arg_122_0, arg_122_1, "damage")
			local var_122_11 = GameSession.game_object_field(arg_122_0, arg_122_1, "explode_time")
			local var_122_12 = GameSession.game_object_field(arg_122_0, arg_122_1, "fuse_time")
			local var_122_13 = GameSession.game_object_field(arg_122_0, arg_122_1, "item_name")
			local var_122_14

			if var_122_11 ~= 0 then
				var_122_14 = {
					explode_time = var_122_11,
					fuse_time = var_122_12
				}
			end

			local var_122_15 = arg_122_4.world
			local var_122_16 = LevelHelper:current_level(var_122_15)
			local var_122_17 = Managers.state.network:game_object_or_level_unit(var_122_7, var_122_8)
			local var_122_18 = {
				projectile_locomotion_system = {
					network_position = var_122_0,
					network_rotation = var_122_1,
					network_velocity = var_122_2,
					network_angular_velocity = var_122_3
				},
				pickup_system = {
					pickup_name = NetworkLookup.pickup_names[var_122_4],
					has_physics = var_122_5,
					spawn_type = NetworkLookup.pickup_spawn_types[var_122_6]
				},
				health_system = {
					in_hand = false,
					item_name = NetworkLookup.item_names[var_122_13],
					health_data = var_122_14,
					damage = var_122_10
				},
				death_system = {
					in_hand = false,
					item_name = NetworkLookup.item_names[var_122_13]
				},
				limited_item_track_system = {
					spawner_unit = var_122_17,
					id = var_122_9
				}
			}

			return "explosive_pickup_projectile_unit_limited", var_122_18
		end,
		true_flight_projectile_unit = function (arg_123_0, arg_123_1, arg_123_2, arg_123_3, arg_123_4)
			local var_123_0 = GameSession.game_object_field(arg_123_0, arg_123_1, "angle")
			local var_123_1 = GameSession.game_object_field(arg_123_0, arg_123_1, "target_vector")
			local var_123_2 = GameSession.game_object_field(arg_123_0, arg_123_1, "initial_position")
			local var_123_3 = GameSession.game_object_field(arg_123_0, arg_123_1, "speed")
			local var_123_4 = GameSession.game_object_field(arg_123_0, arg_123_1, "gravity_settings")
			local var_123_5 = GameSession.game_object_field(arg_123_0, arg_123_1, "trajectory_template_id")
			local var_123_6 = GameSession.game_object_field(arg_123_0, arg_123_1, "true_flight_template_id")
			local var_123_7 = GameSession.game_object_field(arg_123_0, arg_123_1, "target_unit_id")
			local var_123_8 = GameSession.game_object_field(arg_123_0, arg_123_1, "collision_filter")
			local var_123_9 = GameSession.game_object_field(arg_123_0, arg_123_1, "server_side_raycast")
			local var_123_10 = GameSession.game_object_field(arg_123_0, arg_123_1, "owner_unit")
			local var_123_11 = GameSession.game_object_field(arg_123_0, arg_123_1, "item_template_name")
			local var_123_12 = GameSession.game_object_field(arg_123_0, arg_123_1, "item_name")
			local var_123_13 = GameSession.game_object_field(arg_123_0, arg_123_1, "action_name")
			local var_123_14 = GameSession.game_object_field(arg_123_0, arg_123_1, "sub_action_name")
			local var_123_15 = Managers.time:time("game")
			local var_123_16 = GameSession.game_object_field(arg_123_0, arg_123_1, "scale") / 100
			local var_123_17 = NetworkLookup.item_template_names[var_123_11]
			local var_123_18 = NetworkLookup.item_names[var_123_12]
			local var_123_19 = NetworkLookup.actions[var_123_13]
			local var_123_20 = NetworkLookup.sub_actions[var_123_14]
			local var_123_21 = GameSession.game_object_field(arg_123_0, arg_123_1, "power_level")
			local var_123_22

			if var_123_7 ~= NetworkConstants.game_object_id_max then
				var_123_22 = Managers.state.unit_storage:unit(var_123_7)
			end

			local var_123_23 = Managers.state.unit_storage:unit(var_123_10)
			local var_123_24 = {
				projectile_locomotion_system = {
					is_husk = true,
					true_flight_template_name = TrueFlightTemplatesLookup[var_123_6],
					target_unit = var_123_22,
					owner_unit = var_123_23,
					angle = var_123_0,
					speed = var_123_3,
					target_vector = var_123_1,
					initial_position = var_123_2,
					gravity_settings = NetworkLookup.projectile_gravity_settings[var_123_4],
					trajectory_template_name = NetworkLookup.projectile_templates[var_123_5]
				},
				projectile_impact_system = {
					item_name = var_123_18,
					collision_filter = NetworkLookup.collision_filters[var_123_8],
					server_side_raycast = var_123_9,
					owner_unit = var_123_23
				},
				projectile_system = {
					item_name = var_123_18,
					item_template_name = var_123_17,
					action_name = var_123_19,
					sub_action_name = var_123_20,
					owner_unit = var_123_23,
					time_initialized = var_123_15,
					scale = var_123_16,
					power_level = var_123_21
				}
			}

			return "true_flight_projectile_unit", var_123_24
		end,
		ai_true_flight_projectile_unit = function (arg_124_0, arg_124_1, arg_124_2, arg_124_3, arg_124_4)
			local var_124_0 = GameSession.game_object_field(arg_124_0, arg_124_1, "owner_unit")
			local var_124_1 = GameSession.game_object_field(arg_124_0, arg_124_1, "angle")
			local var_124_2 = GameSession.game_object_field(arg_124_0, arg_124_1, "target_vector")
			local var_124_3 = GameSession.game_object_field(arg_124_0, arg_124_1, "initial_position")
			local var_124_4 = GameSession.game_object_field(arg_124_0, arg_124_1, "speed")
			local var_124_5 = GameSession.game_object_field(arg_124_0, arg_124_1, "gravity_settings")
			local var_124_6 = GameSession.game_object_field(arg_124_0, arg_124_1, "trajectory_template_id")
			local var_124_7 = GameSession.game_object_field(arg_124_0, arg_124_1, "true_flight_template_id")
			local var_124_8 = GameSession.game_object_field(arg_124_0, arg_124_1, "target_unit_id")
			local var_124_9 = GameSession.game_object_field(arg_124_0, arg_124_1, "collision_filter")
			local var_124_10 = GameSession.game_object_field(arg_124_0, arg_124_1, "server_side_raycast")
			local var_124_11 = GameSession.game_object_field(arg_124_0, arg_124_1, "impact_template_name")
			local var_124_12

			if var_124_8 ~= NetworkConstants.game_object_id_max then
				var_124_12 = Managers.state.unit_storage:unit(var_124_8)
			end

			local var_124_13 = Managers.state.unit_storage:unit(var_124_0)
			local var_124_14 = TrueFlightTemplatesLookup[var_124_7]
			local var_124_15 = {
				projectile_locomotion_system = {
					is_husk = true,
					true_flight_template_name = var_124_14,
					target_unit = var_124_12,
					owner_unit = var_124_13,
					angle = var_124_1,
					speed = var_124_4,
					target_vector = var_124_2,
					initial_position = var_124_3,
					gravity_settings = NetworkLookup.projectile_gravity_settings[var_124_5],
					trajectory_template_name = NetworkLookup.projectile_templates[var_124_6]
				},
				projectile_impact_system = {
					collision_filter = NetworkLookup.collision_filters[var_124_9],
					server_side_raycast = var_124_10,
					owner_unit = var_124_13
				},
				projectile_system = {
					impact_template_name = NetworkLookup.projectile_templates[var_124_11],
					owner_unit = var_124_13
				}
			}

			return "ai_true_flight_projectile_unit", var_124_15, var_124_14
		end,
		ai_true_flight_projectile_unit_without_raycast = function (arg_125_0, arg_125_1, arg_125_2, arg_125_3, arg_125_4)
			local var_125_0 = GameSession.game_object_field(arg_125_0, arg_125_1, "owner_unit")
			local var_125_1 = GameSession.game_object_field(arg_125_0, arg_125_1, "angle")
			local var_125_2 = GameSession.game_object_field(arg_125_0, arg_125_1, "target_vector")
			local var_125_3 = GameSession.game_object_field(arg_125_0, arg_125_1, "initial_position")
			local var_125_4 = GameSession.game_object_field(arg_125_0, arg_125_1, "speed")
			local var_125_5 = GameSession.game_object_field(arg_125_0, arg_125_1, "gravity_settings")
			local var_125_6 = GameSession.game_object_field(arg_125_0, arg_125_1, "trajectory_template_id")
			local var_125_7 = GameSession.game_object_field(arg_125_0, arg_125_1, "true_flight_template_id")
			local var_125_8 = GameSession.game_object_field(arg_125_0, arg_125_1, "target_unit_id")
			local var_125_9 = GameSession.game_object_field(arg_125_0, arg_125_1, "impact_template_name")
			local var_125_10

			if var_125_8 ~= NetworkConstants.game_object_id_max then
				var_125_10 = Managers.state.unit_storage:unit(var_125_8)
			end

			local var_125_11 = Managers.state.unit_storage:unit(var_125_0)
			local var_125_12 = {
				projectile_locomotion_system = {
					is_husk = true,
					true_flight_template_name = TrueFlightTemplatesLookup[var_125_7],
					target_unit = var_125_10,
					owner_unit = var_125_11,
					angle = var_125_1,
					speed = var_125_4,
					target_vector = var_125_2,
					initial_position = var_125_3,
					gravity_settings = NetworkLookup.projectile_gravity_settings[var_125_5],
					trajectory_template_name = NetworkLookup.projectile_templates[var_125_6]
				},
				projectile_system = {
					impact_template_name = NetworkLookup.projectile_templates[var_125_9],
					owner_unit = var_125_11
				}
			}

			return "ai_true_flight_projectile_unit_without_raycast", var_125_12
		end,
		aoe_projectile_unit = function (arg_126_0, arg_126_1, arg_126_2, arg_126_3, arg_126_4)
			local var_126_0 = GameSession.game_object_field(arg_126_0, arg_126_1, "angle")
			local var_126_1 = GameSession.game_object_field(arg_126_0, arg_126_1, "speed")
			local var_126_2 = GameSession.game_object_field(arg_126_0, arg_126_1, "gravity_settings")
			local var_126_3 = GameSession.game_object_field(arg_126_0, arg_126_1, "target_vector")
			local var_126_4 = GameSession.game_object_field(arg_126_0, arg_126_1, "initial_position")
			local var_126_5 = GameSession.game_object_field(arg_126_0, arg_126_1, "trajectory_template_name")
			local var_126_6 = GameSession.game_object_field(arg_126_0, arg_126_1, "owner_unit")
			local var_126_7 = GameSession.game_object_field(arg_126_0, arg_126_1, "source_attacker_unit")
			local var_126_8 = GameSession.game_object_field(arg_126_0, arg_126_1, "server_side_raycast")
			local var_126_9 = GameSession.game_object_field(arg_126_0, arg_126_1, "collision_filter")
			local var_126_10 = GameSession.game_object_field(arg_126_0, arg_126_1, "impact_template_name")
			local var_126_11 = GameSession.game_object_field(arg_126_0, arg_126_1, "aoe_init_damage")
			local var_126_12 = GameSession.game_object_field(arg_126_0, arg_126_1, "aoe_dot_damage")
			local var_126_13 = GameSession.game_object_field(arg_126_0, arg_126_1, "aoe_dot_damage_interval")
			local var_126_14 = GameSession.game_object_field(arg_126_0, arg_126_1, "radius")
			local var_126_15 = GameSession.game_object_field(arg_126_0, arg_126_1, "life_time")
			local var_126_16 = GameSession.game_object_field(arg_126_0, arg_126_1, "damage_players")
			local var_126_17 = GameSession.game_object_field(arg_126_0, arg_126_1, "player_screen_effect_name")
			local var_126_18 = GameSession.game_object_field(arg_126_0, arg_126_1, "dot_effect_name")
			local var_126_19 = GameSession.game_object_field(arg_126_0, arg_126_1, "area_damage_template")
			local var_126_20 = GameSession.game_object_field(arg_126_0, arg_126_1, "damage_source_id")
			local var_126_21 = Managers.state.unit_storage:unit(var_126_6)
			local var_126_22 = Managers.player:unit_owner(var_126_21)
			local var_126_23 = Managers.state.unit_storage:unit(var_126_7)
			local var_126_24 = {
				projectile_locomotion_system = {
					is_husk = true,
					angle = var_126_0,
					speed = var_126_1,
					gravity_settings = NetworkLookup.projectile_gravity_settings[var_126_2],
					target_vector = var_126_3,
					initial_position = var_126_4,
					trajectory_template_name = NetworkLookup.projectile_templates[var_126_5]
				},
				projectile_impact_system = {
					collision_filter = NetworkLookup.collision_filters[var_126_9],
					server_side_raycast = var_126_8,
					owner_unit = var_126_21
				},
				projectile_system = {
					impact_template_name = NetworkLookup.projectile_templates[var_126_10],
					owner_unit = var_126_21,
					damage_source = NetworkLookup.damage_sources[var_126_20]
				},
				area_damage_system = {
					aoe_dot_damage = var_126_12,
					aoe_init_damage = var_126_11,
					aoe_dot_damage_interval = var_126_13,
					radius = var_126_14,
					life_time = var_126_15,
					damage_players = var_126_16,
					player_screen_effect_name = NetworkLookup.effects[var_126_17],
					dot_effect_name = NetworkLookup.effects[var_126_18],
					area_damage_template = NetworkLookup.area_damage_templates[var_126_19],
					damage_source = NetworkLookup.damage_sources[var_126_20],
					source_attacker_unit = var_126_23,
					owner_player = var_126_22
				}
			}

			return "aoe_projectile_unit", var_126_24
		end,
		aoe_projectile_unit_fixed_impact = function (arg_127_0, arg_127_1, arg_127_2, arg_127_3, arg_127_4)
			local var_127_0 = GameSession.game_object_field(arg_127_0, arg_127_1, "angle")
			local var_127_1 = GameSession.game_object_field(arg_127_0, arg_127_1, "speed")
			local var_127_2 = GameSession.game_object_field(arg_127_0, arg_127_1, "gravity_settings")
			local var_127_3 = GameSession.game_object_field(arg_127_0, arg_127_1, "target_vector")
			local var_127_4 = GameSession.game_object_field(arg_127_0, arg_127_1, "initial_position")
			local var_127_5 = GameSession.game_object_field(arg_127_0, arg_127_1, "trajectory_template_name")
			local var_127_6 = GameSession.game_object_field(arg_127_0, arg_127_1, "owner_unit")
			local var_127_7 = GameSession.game_object_field(arg_127_0, arg_127_1, "source_attacker_unit")
			local var_127_8 = GameSession.game_object_field(arg_127_0, arg_127_1, "impact_position")
			local var_127_9 = GameSession.game_object_field(arg_127_0, arg_127_1, "impact_normal")
			local var_127_10 = GameSession.game_object_field(arg_127_0, arg_127_1, "impact_direction")
			local var_127_11 = GameSession.game_object_field(arg_127_0, arg_127_1, "impact_unit")
			local var_127_12 = GameSession.game_object_field(arg_127_0, arg_127_1, "impact_unit_is_level_unit")
			local var_127_13 = GameSession.game_object_field(arg_127_0, arg_127_1, "impact_actor")
			local var_127_14 = GameSession.game_object_field(arg_127_0, arg_127_1, "impact_time")
			local var_127_15 = GameSession.game_object_field(arg_127_0, arg_127_1, "impact_template_name")
			local var_127_16 = GameSession.game_object_field(arg_127_0, arg_127_1, "aoe_init_damage")
			local var_127_17 = GameSession.game_object_field(arg_127_0, arg_127_1, "aoe_dot_damage")
			local var_127_18 = GameSession.game_object_field(arg_127_0, arg_127_1, "aoe_dot_damage_interval")
			local var_127_19 = GameSession.game_object_field(arg_127_0, arg_127_1, "radius")
			local var_127_20 = GameSession.game_object_field(arg_127_0, arg_127_1, "life_time")
			local var_127_21 = GameSession.game_object_field(arg_127_0, arg_127_1, "damage_players")
			local var_127_22 = GameSession.game_object_field(arg_127_0, arg_127_1, "player_screen_effect_name")
			local var_127_23 = GameSession.game_object_field(arg_127_0, arg_127_1, "dot_effect_name")
			local var_127_24 = GameSession.game_object_field(arg_127_0, arg_127_1, "area_damage_template")
			local var_127_25 = GameSession.game_object_field(arg_127_0, arg_127_1, "damage_source_id")
			local var_127_26 = Managers.state.unit_storage:unit(var_127_6)
			local var_127_27 = Managers.player:unit_owner(var_127_26)
			local var_127_28 = Managers.state.unit_storage:unit(var_127_7)
			local var_127_29 = {
				position = Vector3Box(var_127_8),
				direction = Vector3Box(var_127_10),
				hit_unit = Managers.state.network:game_object_or_level_unit(var_127_11, var_127_12),
				actor_index = var_127_13,
				hit_normal = Vector3Box(var_127_9),
				time = var_127_14
			}
			local var_127_30 = {
				projectile_locomotion_system = {
					is_husk = true,
					angle = var_127_0,
					speed = var_127_1,
					gravity_settings = NetworkLookup.projectile_gravity_settings[var_127_2],
					target_vector = var_127_3,
					initial_position = var_127_4,
					trajectory_template_name = NetworkLookup.projectile_templates[var_127_5]
				},
				projectile_impact_system = {
					impact_data = var_127_29,
					owner_unit = var_127_26
				},
				projectile_system = {
					impact_template_name = NetworkLookup.projectile_templates[var_127_15],
					owner_unit = var_127_26,
					damage_source = NetworkLookup.damage_sources[var_127_25]
				},
				area_damage_system = {
					aoe_dot_damage = var_127_17,
					aoe_init_damage = var_127_16,
					aoe_dot_damage_interval = var_127_18,
					radius = var_127_19,
					life_time = var_127_20,
					damage_players = var_127_21,
					player_screen_effect_name = NetworkLookup.effects[var_127_22],
					dot_effect_name = NetworkLookup.effects[var_127_23],
					area_damage_template = NetworkLookup.area_damage_templates[var_127_24],
					damage_source = NetworkLookup.damage_sources[var_127_25],
					source_attacker_unit = var_127_28,
					owner_player = var_127_27
				}
			}

			return "aoe_projectile_unit_fixed_impact", var_127_30
		end,
		projectile_unit = function (arg_128_0, arg_128_1, arg_128_2, arg_128_3, arg_128_4)
			local var_128_0 = GameSession.game_object_field(arg_128_0, arg_128_1, "angle")
			local var_128_1 = GameSession.game_object_field(arg_128_0, arg_128_1, "speed")
			local var_128_2 = GameSession.game_object_field(arg_128_0, arg_128_1, "target_vector")
			local var_128_3 = GameSession.game_object_field(arg_128_0, arg_128_1, "initial_position")
			local var_128_4 = GameSession.game_object_field(arg_128_0, arg_128_1, "trajectory_template_name")
			local var_128_5 = GameSession.game_object_field(arg_128_0, arg_128_1, "impact_template_name")
			local var_128_6 = GameSession.game_object_field(arg_128_0, arg_128_1, "owner_unit")
			local var_128_7 = {
				projectile_system = {
					is_husk = true,
					angle = var_128_0,
					speed = var_128_1,
					target_vector = var_128_2,
					initial_position = var_128_3,
					trajectory_template_name = NetworkLookup.projectile_templates[var_128_4],
					impact_template_name = NetworkLookup.projectile_templates[var_128_5],
					owner_unit = Managers.state.unit_storage:unit(var_128_6)
				}
			}

			return "projectile_unit", var_128_7
		end,
		damage_wave_unit = function (arg_129_0, arg_129_1, arg_129_2, arg_129_3, arg_129_4)
			local var_129_0 = GameSession.game_object_field(arg_129_0, arg_129_1, "damage_wave_template_name")
			local var_129_1 = GameSession.game_object_field(arg_129_0, arg_129_1, "source_unit")
			local var_129_2 = {
				area_damage_system = {
					damage_wave_template_name = NetworkLookup.damage_wave_templates[var_129_0],
					source_unit = Managers.state.unit_storage:unit(var_129_1)
				}
			}

			return "damage_wave_unit", var_129_2
		end,
		damage_blob_unit = function (arg_130_0, arg_130_1, arg_130_2, arg_130_3, arg_130_4)
			local var_130_0 = GameSession.game_object_field(arg_130_0, arg_130_1, "damage_blob_template_name")
			local var_130_1 = GameSession.game_object_field(arg_130_0, arg_130_1, "source_unit")
			local var_130_2 = {
				area_damage_system = {
					damage_blob_template_name = NetworkLookup.damage_blob_templates[var_130_0],
					source_unit = Managers.state.unit_storage:unit(var_130_1)
				}
			}

			return "damage_blob_unit", var_130_2
		end,
		liquid_aoe_unit = function (arg_131_0, arg_131_1, arg_131_2, arg_131_3, arg_131_4)
			local var_131_0 = GameSession.game_object_field(arg_131_0, arg_131_1, "liquid_area_damage_template")
			local var_131_1 = GameSession.game_object_field(arg_131_0, arg_131_1, "source_unit")
			local var_131_2 = {
				area_damage_system = {
					liquid_template = NetworkLookup.liquid_area_damage_templates[var_131_0],
					source_unit = Managers.state.unit_storage:unit(var_131_1)
				}
			}

			return "liquid_aoe_unit", var_131_2
		end,
		lure_unit = function (arg_132_0, arg_132_1, arg_132_2, arg_132_3, arg_132_4)
			local var_132_0 = "lure_unit"
			local var_132_1 = {
				health_system = {
					duration = 5
				},
				death_system = {
					death_reaction_template = "lure_unit"
				}
			}

			return var_132_0, var_132_1
		end,
		aoe_unit = function (arg_133_0, arg_133_1, arg_133_2, arg_133_3, arg_133_4)
			local var_133_0 = GameSession.game_object_field(arg_133_0, arg_133_1, "aoe_dot_damage")
			local var_133_1 = GameSession.game_object_field(arg_133_0, arg_133_1, "aoe_init_damage")
			local var_133_2 = GameSession.game_object_field(arg_133_0, arg_133_1, "aoe_dot_damage_interval")
			local var_133_3 = GameSession.game_object_field(arg_133_0, arg_133_1, "radius")
			local var_133_4 = GameSession.game_object_field(arg_133_0, arg_133_1, "life_time")
			local var_133_5 = GameSession.game_object_field(arg_133_0, arg_133_1, "player_screen_effect_name")
			local var_133_6 = GameSession.game_object_field(arg_133_0, arg_133_1, "dot_effect_name")
			local var_133_7 = GameSession.game_object_field(arg_133_0, arg_133_1, "area_damage_template")
			local var_133_8 = GameSession.game_object_field(arg_133_0, arg_133_1, "invisible_unit")
			local var_133_9 = GameSession.game_object_field(arg_133_0, arg_133_1, "extra_dot_effect_name")
			local var_133_10 = GameSession.game_object_field(arg_133_0, arg_133_1, "explosion_template_name")
			local var_133_11 = GameSession.game_object_field(arg_133_0, arg_133_1, "owner_player_id")
			local var_133_12 = GameSession.game_object_field(arg_133_0, arg_133_1, "source_attacker_unit_id")
			local var_133_13 = NetworkLookup.effects[var_133_9]

			if var_133_13 == "n/a" then
				var_133_13 = nil
			end

			local var_133_14 = NetworkLookup.explosion_templates[var_133_10]

			if var_133_14 == "n/a" then
				var_133_14 = nil
			end

			local var_133_15 = NetworkLookup.effects[var_133_5]

			if var_133_15 == "n/a" then
				var_133_15 = nil
			end

			local var_133_16 = NetworkLookup.effects[var_133_6]

			if var_133_16 == "n/a" then
				var_133_16 = nil
			end

			local var_133_17

			if var_133_14 then
				local var_133_18 = ExplosionUtils.get_template(var_133_14)

				if var_133_18 then
					var_133_17 = var_133_18.aoe.nav_mesh_effect
				end
			end

			local var_133_19

			if var_133_11 ~= NetworkConstants.invalid_game_object_id then
				var_133_19 = Managers.player:player_from_game_object_id(var_133_11)
			end

			local var_133_20

			if var_133_12 ~= NetworkConstants.invalid_game_object_id then
				var_133_20 = Managers.state.unit_storage:unit(var_133_12)
			end

			local var_133_21 = {
				area_damage_system = {
					aoe_dot_damage = var_133_0,
					aoe_init_damage = var_133_1,
					aoe_dot_damage_interval = var_133_2,
					radius = var_133_3,
					life_time = var_133_4,
					invisible_unit = var_133_8,
					player_screen_effect_name = var_133_15,
					dot_effect_name = var_133_16,
					nav_mesh_effect = var_133_17,
					extra_dot_effect_name = var_133_13,
					area_damage_template = NetworkLookup.area_damage_templates[var_133_7],
					explosion_template_name = var_133_14,
					owner_player = var_133_19,
					source_attacker_unit = var_133_20
				}
			}

			return "aoe_unit", var_133_21
		end,
		thorn_bush_unit = function (arg_134_0, arg_134_1, arg_134_2, arg_134_3, arg_134_4)
			local var_134_0 = GameSession.game_object_field(arg_134_0, arg_134_1, "aoe_dot_damage")
			local var_134_1 = GameSession.game_object_field(arg_134_0, arg_134_1, "aoe_init_damage")
			local var_134_2 = GameSession.game_object_field(arg_134_0, arg_134_1, "aoe_dot_damage_interval")
			local var_134_3 = GameSession.game_object_field(arg_134_0, arg_134_1, "radius")
			local var_134_4 = GameSession.game_object_field(arg_134_0, arg_134_1, "life_time")
			local var_134_5 = GameSession.game_object_field(arg_134_0, arg_134_1, "player_screen_effect_name")
			local var_134_6 = GameSession.game_object_field(arg_134_0, arg_134_1, "dot_effect_name")
			local var_134_7 = GameSession.game_object_field(arg_134_0, arg_134_1, "area_damage_template")
			local var_134_8 = GameSession.game_object_field(arg_134_0, arg_134_1, "invisible_unit")
			local var_134_9 = GameSession.game_object_field(arg_134_0, arg_134_1, "extra_dot_effect_name")
			local var_134_10 = GameSession.game_object_field(arg_134_0, arg_134_1, "explosion_template_name")
			local var_134_11 = GameSession.game_object_field(arg_134_0, arg_134_1, "owner_player_id")
			local var_134_12 = GameSession.game_object_field(arg_134_0, arg_134_1, "spawn_animation_time")
			local var_134_13 = GameSession.game_object_field(arg_134_0, arg_134_1, "despawn_animation_time")
			local var_134_14 = GameSession.game_object_field(arg_134_0, arg_134_1, "slow_modifier")
			local var_134_15 = NetworkLookup.effects[var_134_9]

			if var_134_15 == "n/a" then
				var_134_15 = nil
			end

			local var_134_16 = NetworkLookup.explosion_templates[var_134_10]

			if var_134_16 == "n/a" then
				var_134_16 = nil
			end

			local var_134_17 = NetworkLookup.effects[var_134_5]

			if var_134_17 == "n/a" then
				var_134_17 = nil
			end

			local var_134_18 = NetworkLookup.effects[var_134_6]

			if var_134_18 == "n/a" then
				var_134_18 = nil
			end

			local var_134_19

			if var_134_16 then
				local var_134_20 = ExplosionUtils.get_template(var_134_16)

				if var_134_20 then
					var_134_19 = var_134_20.aoe.nav_mesh_effect
				end
			end

			local var_134_21

			if var_134_11 ~= NetworkConstants.invalid_game_object_id then
				var_134_21 = Managers.player:player_from_game_object_id(var_134_11)
			end

			local var_134_22 = {
				area_damage_system = {
					aoe_dot_damage = var_134_0,
					aoe_init_damage = var_134_1,
					aoe_dot_damage_interval = var_134_2,
					radius = var_134_3,
					life_time = var_134_4,
					invisible_unit = var_134_8,
					player_screen_effect_name = var_134_17,
					dot_effect_name = var_134_18,
					nav_mesh_effect = var_134_19,
					extra_dot_effect_name = var_134_15,
					area_damage_template = NetworkLookup.area_damage_templates[var_134_7],
					explosion_template_name = var_134_16,
					owner_player = var_134_21,
					slow_modifier = var_134_14
				},
				props_system = {
					spawn_animation_time = var_134_12,
					despawn_animation_time = var_134_13
				}
			}

			return "thorn_bush_unit", var_134_22
		end,
		shadow_flare_light = function (arg_135_0, arg_135_1, arg_135_2, arg_135_3, arg_135_4)
			local var_135_0 = GameSession.game_object_field(arg_135_0, arg_135_1, "glow_time")
			local var_135_1 = GameSession.game_object_field(arg_135_0, arg_135_1, "owner_unit_id")
			local var_135_2 = {
				darkness_system = {
					glow_time = var_135_0,
					owner_unit_id = var_135_1
				}
			}

			return "shadow_flare_light", var_135_2
		end,
		timed_explosion_unit = function (arg_136_0, arg_136_1, arg_136_2, arg_136_3, arg_136_4)
			local var_136_0 = GameSession.game_object_field(arg_136_0, arg_136_1, "follow_unit")
			local var_136_1 = GameSession.game_object_field(arg_136_0, arg_136_1, "explosion_template_name")
			local var_136_2 = {
				area_damage_system = {
					follow_unit = Managers.state.unit_storage:unit(var_136_0),
					explosion_template_name = NetworkLookup.explosion_templates[var_136_1]
				}
			}

			return "timed_explosion_unit", var_136_2
		end,
		pickup_unit = function (arg_137_0, arg_137_1, arg_137_2, arg_137_3, arg_137_4)
			local var_137_0 = GameSession.game_object_field(arg_137_0, arg_137_1, "pickup_name")
			local var_137_1 = GameSession.game_object_field(arg_137_0, arg_137_1, "has_physics")
			local var_137_2 = GameSession.game_object_field(arg_137_0, arg_137_1, "spawn_type")
			local var_137_3 = GameSession.game_object_field(arg_137_0, arg_137_1, "dropped_by_breed")
			local var_137_4 = {
				pickup_system = {
					pickup_name = NetworkLookup.pickup_names[var_137_0],
					has_physics = var_137_1,
					spawn_type = NetworkLookup.pickup_spawn_types[var_137_2],
					dropped_by_breed = NetworkLookup.breeds[var_137_3]
				}
			}

			return "pickup_unit", var_137_4
		end,
		limited_owned_pickup_unit = function (arg_138_0, arg_138_1, arg_138_2, arg_138_3, arg_138_4)
			local var_138_0 = GameSession.game_object_field(arg_138_0, arg_138_1, "pickup_name")
			local var_138_1 = GameSession.game_object_field(arg_138_0, arg_138_1, "has_physics")
			local var_138_2 = GameSession.game_object_field(arg_138_0, arg_138_1, "spawn_type")
			local var_138_3 = GameSession.game_object_field(arg_138_0, arg_138_1, "owner_peer_id")
			local var_138_4 = GameSession.game_object_field(arg_138_0, arg_138_1, "spawn_limit")
			local var_138_5 = GameSession.game_object_field(arg_138_0, arg_138_1, "material_settings_id")
			local var_138_6 = {
				pickup_system = {
					pickup_name = NetworkLookup.pickup_names[var_138_0],
					has_physics = var_138_1,
					spawn_type = NetworkLookup.pickup_spawn_types[var_138_2],
					owner_peer_id = var_138_3,
					spawn_limit = var_138_4,
					material_settings_name = NetworkLookup.material_settings_templates[var_138_5]
				}
			}

			return "limited_owned_pickup_unit", var_138_6
		end,
		life_time_pickup_unit = function (arg_139_0, arg_139_1, arg_139_2, arg_139_3, arg_139_4)
			local var_139_0 = GameSession.game_object_field(arg_139_0, arg_139_1, "pickup_name")
			local var_139_1 = GameSession.game_object_field(arg_139_0, arg_139_1, "has_physics")
			local var_139_2 = GameSession.game_object_field(arg_139_0, arg_139_1, "spawn_type")
			local var_139_3 = {
				pickup_system = {
					pickup_name = NetworkLookup.pickup_names[var_139_0],
					has_physics = var_139_1,
					spawn_type = NetworkLookup.pickup_spawn_types[var_139_2]
				}
			}

			return "life_time_pickup_unit", var_139_3
		end,
		objective_pickup_unit = function (arg_140_0, arg_140_1, arg_140_2, arg_140_3, arg_140_4)
			local var_140_0 = GameSession.game_object_field(arg_140_0, arg_140_1, "pickup_name")
			local var_140_1 = GameSession.game_object_field(arg_140_0, arg_140_1, "has_physics")
			local var_140_2 = GameSession.game_object_field(arg_140_0, arg_140_1, "spawn_type")
			local var_140_3 = GameSession.game_object_field(arg_140_0, arg_140_1, "always_show")
			local var_140_4 = {
				pickup_system = {
					pickup_name = NetworkLookup.pickup_names[var_140_0],
					has_physics = var_140_1,
					spawn_type = NetworkLookup.pickup_spawn_types[var_140_2]
				},
				tutorial_system = {
					always_show = var_140_3
				}
			}

			return "objective_pickup_unit", var_140_4
		end,
		prop_unit = function (arg_141_0, arg_141_1, arg_141_2, arg_141_3, arg_141_4)
			local var_141_0 = "prop_unit"
			local var_141_1

			return var_141_0, var_141_1
		end,
		positioned_prop_unit = function (arg_142_0, arg_142_1, arg_142_2, arg_142_3, arg_142_4)
			local var_142_0 = "positioned_prop_unit"
			local var_142_1

			return var_142_0, var_142_1
		end,
		positioned_blob_unit = function (arg_143_0, arg_143_1, arg_143_2, arg_143_3, arg_143_4)
			local var_143_0 = "nurgle_liquid_blob_dynamic"
			local var_143_1 = {
				props_system = {
					start_size = 0.3,
					duration = 0.5,
					end_size = 1
				},
				death_system = {
					death_reaction_template = "nurgle_liquid_blob",
					shrink_and_despawn_time = 3
				},
				area_damage_system = {
					catapult_strength = 3,
					range = 2,
					detonation_time = 3,
					arm_time = 3,
					explosion_template = "bubonic_catapult_explosion"
				}
			}

			return var_143_0, var_143_1
		end,
		destructible_objective_unit = function (arg_144_0, arg_144_1, arg_144_2, arg_144_3, arg_144_4)
			local var_144_0 = GameSession.game_object_field(arg_144_0, arg_144_1, "health")
			local var_144_1 = "destructible_objective_unit"
			local var_144_2 = {
				health_system = {
					health = var_144_0
				},
				death_system = {
					death_reaction_template = "level_object",
					is_husk = true
				},
				hit_reaction_system = {
					is_husk = true,
					hit_reaction_template = "level_object"
				}
			}

			return var_144_1, var_144_2
		end,
		objective_unit = function (arg_145_0, arg_145_1, arg_145_2, arg_145_3, arg_145_4)
			local var_145_0 = "objective_unit"
			local var_145_1

			return var_145_0, var_145_1
		end,
		standard_unit = function (arg_146_0, arg_146_1, arg_146_2, arg_146_3, arg_146_4)
			local var_146_0 = GameSession.game_object_field(arg_146_0, arg_146_1, "health")
			local var_146_1 = "standard_unit"
			local var_146_2 = GameSession.game_object_field(arg_146_0, arg_146_1, "standard_template_id")
			local var_146_3 = GameSession.game_object_field(arg_146_0, arg_146_1, "always_pingable")
			local var_146_4 = {
				health_system = {
					health = var_146_0
				},
				death_system = {
					death_reaction_template = "standard",
					is_husk = true
				},
				ai_supplementary_system = {
					standard_template_name = NetworkLookup.standard_templates[var_146_2]
				},
				ping_system = {
					always_pingable = var_146_3
				}
			}

			return var_146_1, var_146_4
		end,
		overpowering_blob_unit = function (arg_147_0, arg_147_1, arg_147_2, arg_147_3, arg_147_4)
			local var_147_0 = GameSession.game_object_field(arg_147_0, arg_147_1, "health")
			local var_147_1 = "overpowering_blob_unit"
			local var_147_2 = {
				health_system = {
					health = var_147_0
				},
				death_system = {
					death_reaction_template = "lure_unit",
					is_husk = true
				}
			}

			return var_147_1, var_147_2
		end,
		network_synched_dummy_unit = function (arg_148_0, arg_148_1, arg_148_2, arg_148_3, arg_148_4)
			local var_148_0 = "network_synched_dummy_unit"
			local var_148_1

			return var_148_0, var_148_1
		end,
		position_synched_dummy_unit = function (arg_149_0, arg_149_1, arg_149_2, arg_149_3, arg_149_4)
			local var_149_0 = "position_synched_dummy_unit"
			local var_149_1

			return var_149_0, var_149_1
		end,
		buff_aoe_unit = function (arg_150_0, arg_150_1, arg_150_2, arg_150_3, arg_150_4)
			local var_150_0 = GameSession.game_object_field(arg_150_0, arg_150_1, "life_time")
			local var_150_1 = GameSession.game_object_field(arg_150_0, arg_150_1, "radius")
			local var_150_2 = GameSession.game_object_field(arg_150_0, arg_150_1, "owner_unit_id")
			local var_150_3 = GameSession.game_object_field(arg_150_0, arg_150_1, "source_unit_id")
			local var_150_4 = GameSession.game_object_field(arg_150_0, arg_150_1, "buff_template_id")
			local var_150_5 = GameSession.game_object_field(arg_150_0, arg_150_1, "sub_buff_id")
			local var_150_6 = GameSession.game_object_field(arg_150_0, arg_150_1, "side_id")
			local var_150_7

			if var_150_2 ~= NetworkConstants.invalid_game_object_id then
				var_150_7 = Managers.state.unit_storage:unit(var_150_2)
			end

			local var_150_8

			if var_150_3 ~= NetworkConstants.invalid_game_object_id then
				var_150_8 = Managers.state.unit_storage:unit(var_150_3)
			end

			local var_150_9 = {
				buff_area_system = {
					life_time = var_150_0,
					radius = var_150_1,
					owner_unit = var_150_7,
					source_unit = var_150_8,
					sub_buff_template = BuffTemplates[NetworkLookup.buff_templates[var_150_4]].buffs[var_150_5],
					sub_buff_id = var_150_5,
					side_id = var_150_6
				}
			}

			return "buff_aoe_unit", var_150_9
		end,
		buff_unit = function (arg_151_0, arg_151_1, arg_151_2, arg_151_3, arg_151_4)
			local var_151_0 = {
				buff_system = {
					is_husk = true
				}
			}

			return "buff_unit", var_151_0
		end,
		ai_unit_dummy_sorcerer = function (arg_152_0, arg_152_1, arg_152_2, arg_152_3, arg_152_4)
			local var_152_0 = "ai_unit_dummy_sorcerer"
			local var_152_1

			return var_152_0, var_152_1
		end,
		thrown_weapon_unit = function (arg_153_0, arg_153_1, arg_153_2, arg_153_3, arg_153_4)
			local var_153_0 = "thrown_weapon_unit"
			local var_153_1

			return var_153_0, var_153_1
		end,
		interest_point_level_unit = function (arg_154_0, arg_154_1, arg_154_2, arg_154_3, arg_154_4)
			local var_154_0 = "interest_point_level"
			local var_154_1

			return var_154_0, var_154_1
		end,
		interest_point_unit = function (arg_155_0, arg_155_1, arg_155_2, arg_155_3, arg_155_4)
			local var_155_0 = "interest_point"
			local var_155_1

			return var_155_0, var_155_1
		end,
		sync_unit = function (arg_156_0, arg_156_1, arg_156_2, arg_156_3, arg_156_4)
			error("We don't use this path for this kind of game object")
		end,
		rotating_hazard = function (arg_157_0, arg_157_1, arg_157_2, arg_157_3, arg_157_4)
			local var_157_0 = "rotating_hazard"
			local var_157_1 = GameSession.game_object_field(arg_157_0, arg_157_1, "start_network_time")
			local var_157_2 = GameSession.game_object_field(arg_157_0, arg_157_1, "state")
			local var_157_3 = {
				props_system = {
					start_network_time = var_157_1,
					state = var_157_2
				}
			}

			return var_157_0, var_157_3
		end,
		dialogue_node = function (arg_158_0, arg_158_1, arg_158_2, arg_158_3, arg_158_4)
			local var_158_0 = GameSession.game_object_field(arg_158_0, arg_158_1, "dialogue_profile")
			local var_158_1 = GameSession.game_object_field(arg_158_0, arg_158_1, "side_id")

			var_158_1 = var_158_1 > 0 and var_158_1 or nil

			local var_158_2 = {
				dialogue_system = {
					dialogue_profile = NetworkLookup.dialogue_profiles[var_158_0]
				},
				surrounding_aware_system = {
					side_id = var_158_1
				}
			}

			return "dialogue_node", var_158_2
		end,
		explosive_barrel_socket = function (arg_159_0, arg_159_1, arg_159_2, arg_159_3, arg_159_4)
			local var_159_0 = {}

			return "explosive_barrel_socket", var_159_0
		end
	},
	unit_from_gameobject_creator_func = function (arg_160_0, arg_160_1, arg_160_2, arg_160_3)
		local var_160_0

		if arg_160_3.is_level_unit then
			local var_160_1 = GameSession.game_object_field(arg_160_1, arg_160_2, "level_id")

			error("NetworkLookup.levels doesn´t exist. Talk to Anders E")

			local var_160_2 = NetworkLookup.levels[GameSession.game_object_field(arg_160_1, arg_160_2, "level_name_id")]
			local var_160_3 = GLOBAL.current_levels[var_160_2]

			var_160_0 = Level.unit_by_index(var_160_3, var_160_1)
		else
			local var_160_4 = NetworkLookup.husks[GameSession.game_object_field(arg_160_1, arg_160_2, "husk_unit")]
			local var_160_5
			local var_160_6

			if arg_160_3.syncs_position then
				var_160_5 = GameSession.game_object_field(arg_160_1, arg_160_2, "position")
			end

			if arg_160_3.syncs_rotation then
				var_160_6 = GameSession.game_object_field(arg_160_1, arg_160_2, "rotation")
			elseif arg_160_3.syncs_yaw then
				local var_160_7 = GameSession.game_object_field(arg_160_1, arg_160_2, "yaw_rot")

				var_160_6 = Quaternion(Vector3.up(), var_160_7)
			elseif arg_160_3.syncs_pitch_yaw then
				local var_160_8 = GameSession.game_object_field(arg_160_1, arg_160_2, "yaw")
				local var_160_9 = GameSession.game_object_field(arg_160_1, arg_160_2, "pitch")
				local var_160_10 = Quaternion(Vector3.up(), var_160_8)
				local var_160_11 = Quaternion(Vector3.right(), var_160_9)

				var_160_6 = Quaternion.multiply(var_160_10, var_160_11)
			end

			if arg_160_3.has_uniform_scaling then
				local var_160_12 = GameSession.game_object_field(arg_160_1, arg_160_2, "uniform_scale")
				local var_160_13 = Vector3(var_160_12, var_160_12, var_160_12)
				local var_160_14 = Matrix4x4.from_quaternion_position(var_160_6, var_160_5)

				Matrix4x4.set_scale(var_160_14, var_160_13)

				var_160_0 = arg_160_0:spawn_local_unit(var_160_4, var_160_14)

				return var_160_0
			end

			var_160_0 = arg_160_0:spawn_local_unit(var_160_4, var_160_5, var_160_6)
		end

		return var_160_0
	end
}

DLCUtils.merge("game_object_initializers", var_0_4.initializers)
DLCUtils.merge("game_object_extractors", var_0_4.extractors)

local var_0_5 = var_0_4.initializers

var_0_5.ai_true_flight_killable_projectile_unit = function (arg_161_0, arg_161_1, arg_161_2, arg_161_3)
	local var_161_0 = var_0_5.ai_true_flight_projectile_unit(arg_161_0, arg_161_1, arg_161_2, arg_161_3)

	var_161_0.health = ScriptUnit.has_extension(arg_161_0, "health_system"):get_max_health()
	var_161_0.go_type = NetworkLookup.go_types.ai_true_flight_killable_projectile_unit

	return var_161_0
end

local var_0_6 = var_0_4.extractors

var_0_6.ai_true_flight_killable_projectile_unit = function (arg_162_0, arg_162_1, arg_162_2, arg_162_3, arg_162_4)
	local var_162_0, var_162_1, var_162_2 = var_0_6.ai_true_flight_projectile_unit(arg_162_0, arg_162_1, arg_162_2, arg_162_3, arg_162_4)
	local var_162_3 = TrueFlightTemplates[var_162_2]
	local var_162_4 = GameSession.game_object_field(arg_162_0, arg_162_1, "health")

	var_162_1.health_system = {
		health = var_162_4
	}
	var_162_1.death_system = {
		is_husk = true,
		death_reaction_template = var_162_3.death_reaction_template
	}

	return "ai_true_flight_killable_projectile_unit", var_162_1
end

return var_0_4
