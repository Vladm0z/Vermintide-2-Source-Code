-- chunkname: @scripts/network/game_object_initializers_extractors.lua

local var_0_0
local tbl = {}
local EnergyData = EnergyData

EnergyData = EnergyData or {}
EnergyData = EnergyData

local function fn(arg_1_0, arg_1_1, arg_1_2)
	-- function 1
	local game_object_field = GameSession.game_object_field(arg_1_1, arg_1_2, "breed_name")
	local var_1_1 = NetworkLookup.breeds[game_object_field]
	local var_1_2 = Breeds[var_1_1]

	Unit.set_data(arg_1_0, "breed", var_1_2)

	local game_object_field_2 = GameSession.game_object_field(arg_1_1, arg_1_2, "side_id")

	return var_1_2, var_1_1, game_object_field_2
end

local function fn_2(self, arg_2_1, arg_2_2, arg_2_3)
	-- function 2
	local unique_id = self:unique_id()
	local get_status_from_unique_id = Managers.party:get_status_from_unique_id(unique_id)
	local get_party = Managers.party:get_party(get_status_from_unique_id.party_id)
	local var_2_3 = Managers.state.side.side_by_party[get_party]
	local breed = arg_2_2.breed

	breed = breed or arg_2_1.breed

	local var_2_5 = BLACKBOARDS[arg_2_3]

	var_2_5 = var_2_5 or {}
	var_2_5.is_player = true
	var_2_5.side = var_2_3
	var_2_5.breed = breed
	BLACKBOARDS[arg_2_3] = var_2_5
end

local tbl_2 = {
	initializers = {
		player_unit = function (arg_3_0, arg_3_1, arg_3_2, arg_3_3)
			-- function 3
			local player = ScriptUnit.extension(arg_3_0, "input_system").player
			local mover = Unit.mover(arg_3_0)
			local profile_index = player:profile_index()
			local var_3_3 = SPProfiles[profile_index]

			fassert(var_3_3, "No such profile with index %s", tostring(profile_index))

			local get_interface = Managers.backend:get_interface("hero_attributes")
			local career_index = ScriptUnit.extension(arg_3_0, "career_system"):career_index()
			local extension = ScriptUnit.extension(arg_3_0, "cosmetic_system")
			local name = extension:get_equipped_skin().name
			local get_equipped_frame_name = extension:get_equipped_frame_name()
			local third_person_husk = Cosmetics[name].third_person_husk
			local current_position = ScriptUnit.extension(arg_3_0, "first_person_system"):current_position()
			local local_rotation = Unit.local_rotation(arg_3_0, 0)
			local get_experience = ExperienceSettings.get_experience(var_3_3.display_name)
			local get_level = ExperienceSettings.get_level(get_experience)
			local flag = Managers.mechanism:current_mechanism_name() == "versus"
			local get_versus_experience = ExperienceSettings.get_versus_experience()
			local get_versus_level_from_experience

			if flag or not Application.user_setting("toggle_versus_level_in_all_game_modes") then
				get_versus_level_from_experience = ExperienceSettings.get_versus_level_from_experience(get_versus_experience)

				if not get_versus_level_from_experience then
					-- Nothing
				end
			end

			get_versus_level_from_experience = 0

			::label_3_0::

			local max_wounds_network_safe = ScriptUnit.extension(arg_3_0, "status_system"):max_wounds_network_safe()
			local var_3_18 = var_3_3.careers[career_index]

			fassert(var_3_18, "No such career with career_index %s", tostring(career_index))

			local tbl = {}
			local get_persistent_buff_names = ScriptUnit.extension(arg_3_0, "buff_system"):get_persistent_buff_names()

			for k, v in pairs(get_persistent_buff_names) do
				local var_3_21 = NetworkLookup.buff_templates[v]

				table.insert(tbl, var_3_21)
			end

			fn_2(player, var_3_3, var_3_18, arg_3_0)

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
				husk_unit = NetworkLookup.husks[third_person_husk],
				skin_name = NetworkLookup.cosmetics[name],
				frame_name = NetworkLookup.cosmetics[get_equipped_frame_name],
				wounds = max_wounds_network_safe,
				level = get_level,
				versus_level = get_versus_level_from_experience,
				prestige_level = ProgressionUnlocks.get_prestige_level(var_3_3.display_name),
				position = Mover.position(mover),
				pitch = Quaternion.pitch(local_rotation),
				yaw = Quaternion.yaw(local_rotation),
				owner_peer_id = player:network_id(),
				local_player_id = player:local_player_id(),
				aim_direction = Vector3(1, 0, 0),
				aim_position = current_position,
				velocity = Vector3(0, 0, 0),
				average_velocity = Vector3(0, 0, 0),
				profile_id = profile_index,
				career_id = career_index,
				network_buff_ids = tbl
			}
		end,
		player_bot_unit = function (arg_4_0, arg_4_1, arg_4_2, arg_4_3)
			-- function 4
			local owner = Managers.player:owner(arg_4_0)
			local mover = Unit.mover(arg_4_0)
			local profile_index = owner:profile_index()
			local var_4_3 = SPProfiles[profile_index]

			fassert(var_4_3, "No such profile with index %s", tostring(profile_index))

			local extension = ScriptUnit.extension(arg_4_0, "cosmetic_system")
			local name = extension:get_equipped_skin().name
			local get_equipped_frame_name = extension:get_equipped_frame_name()
			local third_person_husk = Cosmetics[name].third_person_husk
			local max_wounds_network_safe = ScriptUnit.extension(arg_4_0, "status_system"):max_wounds_network_safe()
			local career_index = ScriptUnit.extension(arg_4_0, "career_system"):career_index()
			local var_4_10 = var_4_3.careers[career_index]

			fassert(var_4_10, "No such career with career_index %s", tostring(career_index))
			fn_2(owner, var_4_3, var_4_10, arg_4_0)

			local local_rotation = Unit.local_rotation(arg_4_0, 0)
			local tbl = {
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
				husk_unit = NetworkLookup.husks[third_person_husk],
				skin_name = NetworkLookup.cosmetics[name],
				frame_name = NetworkLookup.cosmetics[get_equipped_frame_name],
				wounds = max_wounds_network_safe
			}
			local position

			if not mover then
				position = Mover.position(mover)

				if not position then
					-- Nothing
				end
			end

			position = Unit.local_position(arg_4_0, 0)

			::label_4_0::

			tbl.position = position
			tbl.pitch = Quaternion.pitch(local_rotation)
			tbl.yaw = Quaternion.yaw(local_rotation)
			tbl.velocity = Vector3(0, 0, 0)
			tbl.average_velocity = Vector3(0, 0, 0)
			tbl.owner_peer_id = owner:network_id()
			tbl.local_player_id = owner:local_player_id()
			tbl.aim_direction = Vector3(1, 0, 0)
			tbl.profile_id = profile_index
			tbl.career_id = career_index

			return tbl
		end,
		ai_unit = function (arg_5_0, arg_5_1, arg_5_2, arg_5_3)
			-- function 5
			local mover = Unit.mover(arg_5_0)
			local get_data = Unit.get_data(arg_5_0, "breed")
			local size_variation, var_5_3 = ScriptUnit.extension(arg_5_0, "ai_system"):size_variation()
			local side_id = Managers.state.side.side_by_unit[arg_5_0].side_id
			local get_group_id = Managers.state.entity:system("ai_group_system"):get_group_id(arg_5_0)
			local tbl = {
				has_teleported = 1,
				go_type = NetworkLookup.go_types.ai_unit,
				husk_unit = NetworkLookup.husks[arg_5_1],
				health = ScriptUnit.extension(arg_5_0, "health_system"):get_max_health()
			}
			local position

			if not mover then
				position = Mover.position(mover)

				if not position then
					-- Nothing
				end
			end

			position = Unit.local_position(arg_5_0, 0)

			::label_5_0::

			tbl.position = position
			tbl.yaw_rot = Quaternion.yaw(Unit.local_rotation(arg_5_0, 0))
			tbl.velocity = Vector3(0, 0, 0)
			tbl.breed_name = NetworkLookup.breeds[get_data.name]
			tbl.uniform_scale = size_variation
			tbl.bt_action_name = NetworkLookup.bt_action_names["n/a"]
			tbl.side_id = side_id
			tbl.ai_group_id = get_group_id or AIGroupSystem.invalid_group_uid

			return tbl
		end,
		ai_unit_training_dummy_bob = function (arg_6_0, arg_6_1, arg_6_2, arg_6_3)
			-- function 6
			local mover = Unit.mover(arg_6_0)
			local get_data = Unit.get_data(arg_6_0, "breed")
			local size_variation, var_6_3 = ScriptUnit.extension(arg_6_0, "ai_system"):size_variation()
			local side_id = Managers.state.side.side_by_unit[arg_6_0].side_id
			local extension = ScriptUnit.extension(arg_6_0, "projectile_locomotion_system")
			local network_position = extension.network_position
			local network_rotation = extension.network_rotation
			local network_velocity = extension.network_velocity
			local network_angular_velocity = extension.network_angular_velocity
			local extension_2 = ScriptUnit.extension(arg_6_0, "pickup_system")
			local pickup_name = extension_2.pickup_name
			local has_physics = extension_2.has_physics
			local spawn_type = extension_2.spawn_type
			local get_group_id = Managers.state.entity:system("ai_group_system"):get_group_id(arg_6_0)
			local tbl = {
				damage = 0,
				has_teleported = 1,
				go_type = NetworkLookup.go_types.ai_unit_training_dummy_bob,
				husk_unit = NetworkLookup.husks[arg_6_1],
				health = ScriptUnit.extension(arg_6_0, "health_system"):get_max_health()
			}
			local position

			if not mover then
				position = Mover.position(mover)

				if not position then
					-- Nothing
				end
			end

			position = Unit.local_position(arg_6_0, 0)

			::label_6_0::

			tbl.position = position
			tbl.yaw_rot = Quaternion.yaw(Unit.local_rotation(arg_6_0, 0))
			tbl.velocity = Vector3(0, 0, 0)
			tbl.breed_name = NetworkLookup.breeds[get_data.name]
			tbl.uniform_scale = size_variation
			tbl.bt_action_name = NetworkLookup.bt_action_names["n/a"]
			tbl.side_id = side_id
			tbl.ai_group_id = get_group_id or AIGroupSystem.invalid_group_uid
			tbl.rotation = Unit.local_rotation(arg_6_0, 0)
			tbl.network_position = network_position
			tbl.network_rotation = network_rotation
			tbl.network_velocity = network_velocity
			tbl.network_angular_velocity = network_angular_velocity
			tbl.pickup_name = NetworkLookup.pickup_names[pickup_name]
			tbl.has_physics = has_physics
			tbl.spawn_type = NetworkLookup.pickup_spawn_types[spawn_type]

			return tbl
		end,
		ai_unit_beastmen_bestigor = function (arg_7_0, arg_7_1, arg_7_2, arg_7_3)
			-- function 7
			local mover = Unit.mover(arg_7_0)
			local get_data = Unit.get_data(arg_7_0, "breed")
			local size_variation, var_7_3 = ScriptUnit.extension(arg_7_0, "ai_system"):size_variation()
			local inventory_configuration_name = ScriptUnit.extension(arg_7_0, "ai_inventory_system").inventory_configuration_name
			local side_id = Managers.state.side.side_by_unit[arg_7_0].side_id
			local get_group_id = Managers.state.entity:system("ai_group_system"):get_group_id(arg_7_0)
			local tbl = {
				has_teleported = 1,
				go_type = NetworkLookup.go_types.ai_unit_beastmen_bestigor,
				husk_unit = NetworkLookup.husks[arg_7_1],
				health = ScriptUnit.extension(arg_7_0, "health_system"):get_max_health()
			}
			local position

			if not mover then
				position = Mover.position(mover)

				if not position then
					-- Nothing
				end
			end

			position = Unit.local_position(arg_7_0, 0)

			::label_7_0::

			tbl.position = position
			tbl.yaw_rot = Quaternion.yaw(Unit.local_rotation(arg_7_0, 0))
			tbl.velocity = Vector3(0, 0, 0)
			tbl.breed_name = NetworkLookup.breeds[get_data.name]
			tbl.uniform_scale = size_variation
			tbl.inventory_configuration = NetworkLookup.ai_inventory[inventory_configuration_name]
			tbl.bt_action_name = NetworkLookup.bt_action_names["n/a"]
			tbl.side_id = side_id
			tbl.ai_group_id = get_group_id or AIGroupSystem.invalid_group_uid

			return tbl
		end,
		ai_unit_beastmen_minotaur = function (arg_8_0, arg_8_1, arg_8_2, arg_8_3)
			-- function 8
			local mover = Unit.mover(arg_8_0)
			local get_data = Unit.get_data(arg_8_0, "breed")
			local size_variation, var_8_3 = ScriptUnit.extension(arg_8_0, "ai_system"):size_variation()
			local inventory_configuration_name = ScriptUnit.extension(arg_8_0, "ai_inventory_system").inventory_configuration_name
			local side_id = Managers.state.side.side_by_unit[arg_8_0].side_id
			local get_group_id = Managers.state.entity:system("ai_group_system"):get_group_id(arg_8_0)
			local tbl = {
				lean_downwards = false,
				has_teleported = 1,
				go_type = NetworkLookup.go_types.ai_unit_beastmen_minotaur,
				husk_unit = NetworkLookup.husks[arg_8_1],
				health = ScriptUnit.extension(arg_8_0, "health_system"):get_max_health()
			}
			local position

			if not mover then
				position = Mover.position(mover)

				if not position then
					-- Nothing
				end
			end

			position = Unit.local_position(arg_8_0, 0)

			::label_8_0::

			tbl.position = position
			tbl.yaw_rot = Quaternion.yaw(Unit.local_rotation(arg_8_0, 0))
			tbl.velocity = Vector3(0, 0, 0)
			tbl.breed_name = NetworkLookup.breeds[get_data.name]
			tbl.uniform_scale = size_variation
			tbl.inventory_configuration = NetworkLookup.ai_inventory[inventory_configuration_name]
			tbl.bt_action_name = NetworkLookup.bt_action_names["n/a"]
			tbl.side_id = side_id
			tbl.ai_group_id = get_group_id or AIGroupSystem.invalid_group_uid

			return tbl
		end,
		ai_unit_grey_seer = function (arg_9_0, arg_9_1, arg_9_2, arg_9_3)
			-- function 9
			local mover = Unit.mover(arg_9_0)
			local get_data = Unit.get_data(arg_9_0, "breed")
			local size_variation, var_9_3 = ScriptUnit.extension(arg_9_0, "ai_system"):size_variation()
			local side_id = Managers.state.side.side_by_unit[arg_9_0].side_id
			local get_group_id = Managers.state.entity:system("ai_group_system"):get_group_id(arg_9_0)
			local tbl = {
				show_health_bar = false,
				has_teleported = 1,
				go_type = NetworkLookup.go_types.ai_unit,
				husk_unit = NetworkLookup.husks[arg_9_1],
				health = ScriptUnit.extension(arg_9_0, "health_system"):get_max_health()
			}
			local position

			if not mover then
				position = Mover.position(mover)

				if not position then
					-- Nothing
				end
			end

			position = Unit.local_position(arg_9_0, 0)

			::label_9_0::

			tbl.position = position
			tbl.yaw_rot = Quaternion.yaw(Unit.local_rotation(arg_9_0, 0))
			tbl.velocity = Vector3(0, 0, 0)
			tbl.breed_name = NetworkLookup.breeds[get_data.name]
			tbl.uniform_scale = size_variation
			tbl.bt_action_name = NetworkLookup.bt_action_names["n/a"]
			tbl.side_id = side_id
			tbl.ai_group_id = get_group_id or AIGroupSystem.invalid_group_uid

			return tbl
		end,
		ai_unit_tentacle = function (arg_10_0, arg_10_1, arg_10_2, arg_10_3)
			-- function 10
			local mover = Unit.mover(arg_10_0)
			local get_data = Unit.get_data(arg_10_0, "breed")
			local size_variation, var_10_3 = ScriptUnit.extension(arg_10_0, "ai_system"):size_variation()
			local extension = ScriptUnit.extension(arg_10_0, "ai_supplementary_system")
			local portal_unit = extension.portal_unit
			local side_id = Managers.state.side.side_by_unit[arg_10_0].side_id
			local get_group_id = Managers.state.entity:system("ai_group_system"):get_group_id(arg_10_0)
			local tbl = {
				reach_distance = 0,
				has_teleported = 1,
				go_type = NetworkLookup.go_types.ai_unit_tentacle,
				husk_unit = NetworkLookup.husks[arg_10_1],
				health = ScriptUnit.extension(arg_10_0, "health_system"):get_max_health()
			}
			local position

			if not mover then
				position = Mover.position(mover)

				if not position then
					-- Nothing
				end
			end

			position = Unit.local_position(arg_10_0, 0)

			::label_10_0::

			tbl.position = position
			tbl.rotation = Unit.local_rotation(arg_10_0, 0)
			tbl.velocity = Vector3(0, 0, 0)
			tbl.breed_name = NetworkLookup.breeds[get_data.name]
			tbl.uniform_scale = size_variation
			tbl.bt_action_name = NetworkLookup.bt_action_names["n/a"]
			tbl.portal_unit_id = Managers.state.network:unit_game_object_id(portal_unit)
			tbl.tentacle_template_id = NetworkLookup.tentacle_templates[extension.tentacle_template_name]
			tbl.side_id = side_id
			tbl.ai_group_id = get_group_id or AIGroupSystem.invalid_group_uid

			return tbl
		end,
		ai_unit_vortex = function (arg_11_0, arg_11_1, arg_11_2, arg_11_3)
			-- function 11
			local mover = Unit.mover(arg_11_0)
			local get_data = Unit.get_data(arg_11_0, "breed")
			local extension = ScriptUnit.extension(arg_11_0, "ai_system")
			local extension_2 = ScriptUnit.extension(arg_11_0, "ai_supplementary_system")
			local size_variation, var_11_5 = extension:size_variation()
			local _inner_decal_unit = extension_2._inner_decal_unit
			local invalid_game_object_id = NetworkConstants.invalid_game_object_id

			if not Unit.alive(_inner_decal_unit) then
				invalid_game_object_id = Managers.state.network:unit_game_object_id(_inner_decal_unit)
			end

			local _outer_decal_unit = extension_2._outer_decal_unit
			local invalid_game_object_id_2 = NetworkConstants.invalid_game_object_id

			if not Unit.alive(_outer_decal_unit) then
				invalid_game_object_id_2 = Managers.state.network:unit_game_object_id(_outer_decal_unit)
			end

			local _owner_unit = extension_2._owner_unit
			local invalid_game_object_id_3 = NetworkConstants.invalid_game_object_id

			if not Unit.alive(_owner_unit) then
				invalid_game_object_id_3 = Managers.state.network:unit_game_object_id(_owner_unit)
			end

			local side_id = Managers.state.side.side_by_unit[arg_11_0].side_id
			local tbl = {
				height_percentage = 0,
				fx_radius_percentage = 0,
				has_teleported = 1,
				inner_radius_percentage = 0,
				go_type = NetworkLookup.go_types.ai_unit_vortex,
				husk_unit = NetworkLookup.husks[arg_11_1]
			}
			local position

			if not mover then
				position = Mover.position(mover)

				if not position then
					-- Nothing
				end
			end

			position = Unit.local_position(arg_11_0, 0)

			::label_11_0::

			tbl.position = position
			tbl.yaw_rot = Quaternion.yaw(Unit.local_rotation(arg_11_0, 0))
			tbl.velocity = Vector3(0, 0, 0)
			tbl.breed_name = NetworkLookup.breeds[get_data.name]
			tbl.uniform_scale = size_variation
			tbl.bt_action_name = NetworkLookup.bt_action_names["n/a"]
			tbl.vortex_template_id = NetworkLookup.vortex_templates[extension_2.vortex_template_name]
			tbl.inner_decal_unit_id = invalid_game_object_id
			tbl.outer_decal_unit_id = invalid_game_object_id_2
			tbl.owner_unit_id = invalid_game_object_id_3
			tbl.side_id = side_id

			return tbl
		end,
		ai_unit_plague_wave_spawner = function (arg_12_0, arg_12_1, arg_12_2, arg_12_3)
			-- function 12
			local get_data = Unit.get_data(arg_12_0, "breed")
			local extension = ScriptUnit.extension(arg_12_0, "ai_system")
			local side_id = Managers.state.side.side_by_unit[arg_12_0].side_id

			return {
				go_type = NetworkLookup.go_types.ai_unit_plague_wave_spawner,
				husk_unit = NetworkLookup.husks[arg_12_1],
				position = Unit.local_position(arg_12_0, 0),
				yaw_rot = Quaternion.yaw(Unit.local_rotation(arg_12_0, 0)),
				breed_name = NetworkLookup.breeds[get_data.name],
				bt_action_name = NetworkLookup.bt_action_names["n/a"],
				side_id = side_id
			}
		end,
		ai_unit_tentacle_portal = function (arg_13_0, arg_13_1, arg_13_2, arg_13_3)
			-- function 13
			local side_id = Managers.state.side.side_by_unit[arg_13_0].side_id

			return {
				go_type = NetworkLookup.go_types.ai_unit_tentacle_portal,
				husk_unit = NetworkLookup.husks[arg_13_1],
				position = Unit.local_position(arg_13_0, 0),
				rotation = Unit.local_rotation(arg_13_0, 0),
				health = ScriptUnit.extension(arg_13_0, "health_system"):get_max_health(),
				side_id = side_id
			}
		end,
		ai_unit_with_inventory = function (arg_14_0, arg_14_1, arg_14_2, arg_14_3)
			-- function 14
			local mover = Unit.mover(arg_14_0)
			local get_data = Unit.get_data(arg_14_0, "breed")
			local size_variation, var_14_3 = ScriptUnit.extension(arg_14_0, "ai_system"):size_variation()
			local inventory_configuration_name = ScriptUnit.extension(arg_14_0, "ai_inventory_system").inventory_configuration_name
			local side_id = Managers.state.side.side_by_unit[arg_14_0].side_id
			local get_group_id = Managers.state.entity:system("ai_group_system"):get_group_id(arg_14_0)

			get_group_id = get_group_id or 0

			local tbl = {
				has_teleported = 1,
				go_type = NetworkLookup.go_types.ai_unit_with_inventory,
				husk_unit = NetworkLookup.husks[arg_14_1],
				health = ScriptUnit.extension(arg_14_0, "health_system"):get_max_health()
			}
			local position

			if not mover then
				position = Mover.position(mover)

				if not position then
					-- Nothing
				end
			end

			position = Unit.local_position(arg_14_0, 0)

			::label_14_0::

			tbl.position = position
			tbl.yaw_rot = Quaternion.yaw(Unit.local_rotation(arg_14_0, 0))
			tbl.velocity = Vector3(0, 0, 0)
			tbl.breed_name = NetworkLookup.breeds[get_data.name]
			tbl.uniform_scale = size_variation
			tbl.inventory_configuration = NetworkLookup.ai_inventory[inventory_configuration_name]
			tbl.bt_action_name = NetworkLookup.bt_action_names["n/a"]
			tbl.side_id = side_id
			tbl.ai_group_id = get_group_id or AIGroupSystem.invalid_group_uid

			return tbl
		end,
		ai_unit_with_inventory_and_shield = function (arg_15_0, arg_15_1, arg_15_2, arg_15_3)
			-- function 15
			local mover = Unit.mover(arg_15_0)
			local get_data = Unit.get_data(arg_15_0, "breed")
			local size_variation, var_15_3 = ScriptUnit.extension(arg_15_0, "ai_system"):size_variation()
			local inventory_configuration_name = ScriptUnit.extension(arg_15_0, "ai_inventory_system").inventory_configuration_name
			local is_blocking = ScriptUnit.extension(arg_15_0, "ai_shield_system").is_blocking
			local side_id = Managers.state.side.side_by_unit[arg_15_0].side_id
			local get_group_id = Managers.state.entity:system("ai_group_system"):get_group_id(arg_15_0)
			local tbl = {
				has_teleported = 1,
				go_type = NetworkLookup.go_types.ai_unit_with_inventory_and_shield,
				husk_unit = NetworkLookup.husks[arg_15_1],
				health = ScriptUnit.extension(arg_15_0, "health_system"):get_max_health()
			}
			local position

			if not mover then
				position = Mover.position(mover)

				if not position then
					-- Nothing
				end
			end

			position = Unit.local_position(arg_15_0, 0)

			::label_15_0::

			tbl.position = position
			tbl.yaw_rot = Quaternion.yaw(Unit.local_rotation(arg_15_0, 0))
			tbl.velocity = Vector3(0, 0, 0)
			tbl.breed_name = NetworkLookup.breeds[get_data.name]
			tbl.uniform_scale = size_variation
			tbl.inventory_configuration = NetworkLookup.ai_inventory[inventory_configuration_name]
			tbl.bt_action_name = NetworkLookup.bt_action_names["n/a"]
			tbl.is_blocking = is_blocking
			tbl.side_id = side_id
			tbl.ai_group_id = get_group_id or AIGroupSystem.invalid_group_uid

			return tbl
		end,
		ai_unit_storm_vermin_warlord = function (arg_16_0, arg_16_1, arg_16_2, arg_16_3)
			-- function 16
			local mover = Unit.mover(arg_16_0)
			local get_data = Unit.get_data(arg_16_0, "breed")
			local size_variation, var_16_3 = ScriptUnit.extension(arg_16_0, "ai_system"):size_variation()
			local inventory_configuration_name = ScriptUnit.extension(arg_16_0, "ai_inventory_system").inventory_configuration_name
			local extension = ScriptUnit.extension(arg_16_0, "ai_shield_system")
			local is_blocking = extension.is_blocking
			local is_dodging = extension.is_dodging
			local side_id = Managers.state.side.side_by_unit[arg_16_0].side_id
			local get_group_id = Managers.state.entity:system("ai_group_system"):get_group_id(arg_16_0)
			local tbl = {
				show_health_bar = false,
				has_teleported = 1,
				go_type = NetworkLookup.go_types.ai_unit_storm_vermin_warlord,
				husk_unit = NetworkLookup.husks[arg_16_1],
				health = ScriptUnit.extension(arg_16_0, "health_system"):get_max_health()
			}
			local position

			if not mover then
				position = Mover.position(mover)

				if not position then
					-- Nothing
				end
			end

			position = Unit.local_position(arg_16_0, 0)

			::label_16_0::

			tbl.position = position
			tbl.yaw_rot = Quaternion.yaw(Unit.local_rotation(arg_16_0, 0))
			tbl.velocity = Vector3(0, 0, 0)
			tbl.breed_name = NetworkLookup.breeds[get_data.name]
			tbl.uniform_scale = size_variation
			tbl.inventory_configuration = NetworkLookup.ai_inventory[inventory_configuration_name]
			tbl.bt_action_name = NetworkLookup.bt_action_names["n/a"]
			tbl.is_blocking = is_blocking
			tbl.is_dodging = is_dodging
			tbl.side_id = side_id
			tbl.ai_group_id = get_group_id or AIGroupSystem.invalid_group_uid

			return tbl
		end,
		ai_unit_chaos_troll = function (arg_17_0, arg_17_1, arg_17_2, arg_17_3)
			-- function 17
			local mover = Unit.mover(arg_17_0)
			local get_data = Unit.get_data(arg_17_0, "breed")
			local size_variation, var_17_3 = ScriptUnit.extension(arg_17_0, "ai_system"):size_variation()
			local inventory_configuration_name = ScriptUnit.extension(arg_17_0, "ai_inventory_system").inventory_configuration_name
			local side_id = Managers.state.side.side_by_unit[arg_17_0].side_id
			local get_group_id = Managers.state.entity:system("ai_group_system"):get_group_id(arg_17_0)
			local tbl = {
				has_teleported = 1,
				go_type = NetworkLookup.go_types.ai_unit_chaos_troll,
				husk_unit = NetworkLookup.husks[arg_17_1],
				health = ScriptUnit.extension(arg_17_0, "health_system"):get_max_health()
			}
			local position

			if not mover then
				position = Mover.position(mover)

				if not position then
					-- Nothing
				end
			end

			position = Unit.local_position(arg_17_0, 0)

			::label_17_0::

			tbl.position = position
			tbl.yaw_rot = Quaternion.yaw(Unit.local_rotation(arg_17_0, 0))
			tbl.velocity = Vector3(0, 0, 0)
			tbl.breed_name = NetworkLookup.breeds[get_data.name]
			tbl.uniform_scale = size_variation
			tbl.inventory_configuration = NetworkLookup.ai_inventory[inventory_configuration_name]
			tbl.bt_action_name = NetworkLookup.bt_action_names["n/a"]
			tbl.side_id = side_id
			tbl.ai_group_id = get_group_id or AIGroupSystem.invalid_group_uid

			return tbl
		end,
		ai_lord_with_inventory = function (arg_18_0, arg_18_1, arg_18_2, arg_18_3)
			-- function 18
			local mover = Unit.mover(arg_18_0)
			local get_data = Unit.get_data(arg_18_0, "breed")
			local size_variation, var_18_3 = ScriptUnit.extension(arg_18_0, "ai_system"):size_variation()
			local inventory_configuration_name = ScriptUnit.extension(arg_18_0, "ai_inventory_system").inventory_configuration_name
			local side_id = Managers.state.side.side_by_unit[arg_18_0].side_id
			local get_group_id = Managers.state.entity:system("ai_group_system"):get_group_id(arg_18_0)
			local tbl = {
				show_health_bar = false,
				has_teleported = 1,
				go_type = NetworkLookup.go_types.ai_lord_with_inventory,
				husk_unit = NetworkLookup.husks[arg_18_1],
				health = ScriptUnit.extension(arg_18_0, "health_system"):get_max_health()
			}
			local position

			if not mover then
				position = Mover.position(mover)

				if not position then
					-- Nothing
				end
			end

			position = Unit.local_position(arg_18_0, 0)

			::label_18_0::

			tbl.position = position
			tbl.yaw_rot = Quaternion.yaw(Unit.local_rotation(arg_18_0, 0))
			tbl.velocity = Vector3(0, 0, 0)
			tbl.breed_name = NetworkLookup.breeds[get_data.name]
			tbl.uniform_scale = size_variation
			tbl.inventory_configuration = NetworkLookup.ai_inventory[inventory_configuration_name]
			tbl.bt_action_name = NetworkLookup.bt_action_names["n/a"]
			tbl.side_id = side_id
			tbl.ai_group_id = get_group_id or AIGroupSystem.invalid_group_uid

			return tbl
		end,
		ai_unit_pack_master = function (arg_19_0, arg_19_1, arg_19_2, arg_19_3)
			-- function 19
			local mover = Unit.mover(arg_19_0)
			local get_data = Unit.get_data(arg_19_0, "breed")
			local size_variation, var_19_3 = ScriptUnit.extension(arg_19_0, "ai_system"):size_variation()
			local inventory_configuration_name = ScriptUnit.extension(arg_19_0, "ai_inventory_system").inventory_configuration_name
			local side_id = Managers.state.side.side_by_unit[arg_19_0].side_id
			local tbl = {
				has_teleported = 1,
				go_type = NetworkLookup.go_types.ai_unit_pack_master,
				husk_unit = NetworkLookup.husks[arg_19_1],
				health = ScriptUnit.extension(arg_19_0, "health_system"):get_max_health()
			}
			local position

			if not mover then
				position = Mover.position(mover)

				if not position then
					-- Nothing
				end
			end

			position = Unit.local_position(arg_19_0, 0)

			::label_19_0::

			tbl.position = position
			tbl.yaw_rot = Quaternion.yaw(Unit.local_rotation(arg_19_0, 0))
			tbl.velocity = Vector3(0, 0, 0)
			tbl.breed_name = NetworkLookup.breeds[get_data.name]
			tbl.uniform_scale = size_variation
			tbl.inventory_configuration = NetworkLookup.ai_inventory[inventory_configuration_name]
			tbl.aim_target = Vector3.zero()
			tbl.bt_action_name = NetworkLookup.bt_action_names["n/a"]
			tbl.side_id = side_id

			return tbl
		end,
		ai_unit_ratling_gunner = function (arg_20_0, arg_20_1, arg_20_2, arg_20_3)
			-- function 20
			local mover = Unit.mover(arg_20_0)
			local get_data = Unit.get_data(arg_20_0, "breed")
			local size_variation, var_20_3 = ScriptUnit.extension(arg_20_0, "ai_system"):size_variation()
			local inventory_configuration_name = ScriptUnit.extension(arg_20_0, "ai_inventory_system").inventory_configuration_name
			local side_id = Managers.state.side.side_by_unit[arg_20_0].side_id
			local get_group_id = Managers.state.entity:system("ai_group_system"):get_group_id(arg_20_0)
			local tbl = {
				has_teleported = 1,
				go_type = NetworkLookup.go_types.ai_unit_ratling_gunner,
				husk_unit = NetworkLookup.husks[arg_20_1],
				health = ScriptUnit.extension(arg_20_0, "health_system"):get_max_health()
			}
			local position

			if not mover then
				position = Mover.position(mover)

				if not position then
					-- Nothing
				end
			end

			position = Unit.local_position(arg_20_0, 0)

			::label_20_0::

			tbl.position = position
			tbl.yaw_rot = Quaternion.yaw(Unit.local_rotation(arg_20_0, 0))
			tbl.velocity = Vector3(0, 0, 0)
			tbl.breed_name = NetworkLookup.breeds[get_data.name]
			tbl.uniform_scale = size_variation
			tbl.inventory_configuration = NetworkLookup.ai_inventory[inventory_configuration_name]
			tbl.aim_target = Vector3.zero()
			tbl.bt_action_name = NetworkLookup.bt_action_names["n/a"]
			tbl.side_id = side_id
			tbl.ai_group_id = get_group_id or AIGroupSystem.invalid_group_uid

			return tbl
		end,
		ai_unit_warpfire_thrower = function (arg_21_0, arg_21_1, arg_21_2, arg_21_3)
			-- function 21
			local mover = Unit.mover(arg_21_0)
			local get_data = Unit.get_data(arg_21_0, "breed")
			local size_variation, var_21_3 = ScriptUnit.extension(arg_21_0, "ai_system"):size_variation()
			local inventory_configuration_name = ScriptUnit.extension(arg_21_0, "ai_inventory_system").inventory_configuration_name
			local side_id = Managers.state.side.side_by_unit[arg_21_0].side_id
			local get_group_id = Managers.state.entity:system("ai_group_system"):get_group_id(arg_21_0)
			local tbl = {
				has_teleported = 1,
				go_type = NetworkLookup.go_types.ai_unit_warpfire_thrower,
				husk_unit = NetworkLookup.husks[arg_21_1],
				health = ScriptUnit.extension(arg_21_0, "health_system"):get_max_health()
			}
			local position

			if not mover then
				position = Mover.position(mover)

				if not position then
					-- Nothing
				end
			end

			position = Unit.local_position(arg_21_0, 0)

			::label_21_0::

			tbl.position = position
			tbl.yaw_rot = Quaternion.yaw(Unit.local_rotation(arg_21_0, 0))
			tbl.velocity = Vector3(0, 0, 0)
			tbl.breed_name = NetworkLookup.breeds[get_data.name]
			tbl.uniform_scale = size_variation
			tbl.inventory_configuration = NetworkLookup.ai_inventory[inventory_configuration_name]
			tbl.aim_target = Vector3.zero()
			tbl.bt_action_name = NetworkLookup.bt_action_names["n/a"]
			tbl.side_id = side_id
			tbl.ai_group_id = get_group_id or AIGroupSystem.invalid_group_uid

			return tbl
		end,
		ai_unit_stormfiend = function (arg_22_0, arg_22_1, arg_22_2, arg_22_3)
			-- function 22
			local mover = Unit.mover(arg_22_0)
			local get_data = Unit.get_data(arg_22_0, "breed")
			local size_variation, var_22_3 = ScriptUnit.extension(arg_22_0, "ai_system"):size_variation()
			local inventory_configuration_name = ScriptUnit.extension(arg_22_0, "ai_inventory_system").inventory_configuration_name
			local side_id = Managers.state.side.side_by_unit[arg_22_0].side_id
			local get_group_id = Managers.state.entity:system("ai_group_system"):get_group_id(arg_22_0)
			local tbl = {
				attack_arm = 1,
				has_teleported = 1,
				go_type = NetworkLookup.go_types.ai_unit_stormfiend,
				husk_unit = NetworkLookup.husks[arg_22_1],
				health = ScriptUnit.extension(arg_22_0, "health_system"):get_max_health()
			}
			local position

			if not mover then
				position = Mover.position(mover)

				if not position then
					-- Nothing
				end
			end

			position = Unit.local_position(arg_22_0, 0)

			::label_22_0::

			tbl.position = position
			tbl.yaw_rot = Quaternion.yaw(Unit.local_rotation(arg_22_0, 0))
			tbl.velocity = Vector3.zero()
			tbl.breed_name = NetworkLookup.breeds[get_data.name]
			tbl.uniform_scale = size_variation
			tbl.inventory_configuration = NetworkLookup.ai_inventory[inventory_configuration_name]
			tbl.aim_target = Vector3.zero()
			tbl.bt_action_name = NetworkLookup.bt_action_names["n/a"]
			tbl.side_id = side_id
			tbl.ai_group_id = get_group_id or AIGroupSystem.invalid_group_uid

			return tbl
		end,
		ai_unit_stormfiend_boss = function (arg_23_0, arg_23_1, arg_23_2, arg_23_3)
			-- function 23
			local mover = Unit.mover(arg_23_0)
			local get_data = Unit.get_data(arg_23_0, "breed")
			local size_variation, var_23_3 = ScriptUnit.extension(arg_23_0, "ai_system"):size_variation()
			local inventory_configuration_name = ScriptUnit.extension(arg_23_0, "ai_inventory_system").inventory_configuration_name
			local side_id = Managers.state.side.side_by_unit[arg_23_0].side_id
			local get_group_id = Managers.state.entity:system("ai_group_system"):get_group_id(arg_23_0)
			local tbl = {
				show_health_bar = false,
				attack_arm = 1,
				has_teleported = 1,
				go_type = NetworkLookup.go_types.ai_unit_stormfiend,
				husk_unit = NetworkLookup.husks[arg_23_1],
				health = ScriptUnit.extension(arg_23_0, "health_system"):get_max_health()
			}
			local position

			if not mover then
				position = Mover.position(mover)

				if not position then
					-- Nothing
				end
			end

			position = Unit.local_position(arg_23_0, 0)

			::label_23_0::

			tbl.position = position
			tbl.yaw_rot = Quaternion.yaw(Unit.local_rotation(arg_23_0, 0))
			tbl.velocity = Vector3.zero()
			tbl.breed_name = NetworkLookup.breeds[get_data.name]
			tbl.uniform_scale = size_variation
			tbl.inventory_configuration = NetworkLookup.ai_inventory[inventory_configuration_name]
			tbl.aim_target = Vector3.zero()
			tbl.bt_action_name = NetworkLookup.bt_action_names["n/a"]
			tbl.side_id = side_id
			tbl.ai_group_id = get_group_id or AIGroupSystem.invalid_group_uid

			return tbl
		end,
		player_projectile_unit = function (arg_24_0, arg_24_1, arg_24_2, arg_24_3)
			-- function 24
			local extension = ScriptUnit.extension(arg_24_0, "projectile_locomotion_system")
			local angle = extension.angle
			local target_vector = extension.target_vector
			local unbox = extension.initial_position_boxed:unbox()
			local speed = extension.speed
			local gravity_settings = extension.gravity_settings
			local trajectory_template_name = extension.trajectory_template_name
			local rotation_speed = extension.rotation_speed
			local num = -(extension.t - Managers.time:time("game"))
			local owner_unit = ScriptUnit.extension(arg_24_0, "projectile_impact_system").owner_unit
			local extension_2 = ScriptUnit.extension(arg_24_0, "projectile_system")
			local item_name = extension_2.item_name
			local item_template_name = extension_2.action_lookup_data.item_template_name
			local action_name = extension_2.action_lookup_data.action_name
			local sub_action_name = extension_2.action_lookup_data.sub_action_name
			local num_2 = extension_2.scale * 100
			local power_level = extension_2.power_level
			local tbl = {
				go_type = NetworkLookup.go_types.player_projectile_unit,
				husk_unit = NetworkLookup.husks[arg_24_1],
				position = Unit.local_position(arg_24_0, 0),
				rotation = Unit.local_rotation(arg_24_0, 0),
				angle = angle,
				initial_position = unbox,
				target_vector = target_vector,
				speed = speed,
				gravity_settings = NetworkLookup.projectile_gravity_settings[gravity_settings],
				trajectory_template_name = NetworkLookup.projectile_templates[trajectory_template_name]
			}
			local unit_game_object_id

			if not Unit.alive(owner_unit) then
				unit_game_object_id = Managers.state.network:unit_game_object_id(owner_unit)

				if not unit_game_object_id then
					-- Nothing
				end
			end

			unit_game_object_id = 0

			::label_24_0::

			tbl.owner_unit = unit_game_object_id
			tbl.item_name = NetworkLookup.item_names[item_name]
			tbl.item_template_name = NetworkLookup.item_template_names[item_template_name]
			tbl.action_name = NetworkLookup.actions[action_name]
			tbl.sub_action_name = NetworkLookup.sub_actions[sub_action_name]
			tbl.scale = num_2
			tbl.fast_forward_time = num
			tbl.rotation_speed = rotation_speed
			tbl.power_level = power_level

			return tbl
		end,
		sticky_projectile_unit = function (arg_25_0, arg_25_1, arg_25_2, arg_25_3)
			-- function 25
			local extension = ScriptUnit.extension(arg_25_0, "projectile_locomotion_system")
			local target_vector = extension.target_vector
			local unbox = extension.initial_position_boxed:unbox()
			local speed = extension.speed
			local target_unit = extension.target_unit
			local stopped = extension.stopped
			local seed = extension.seed
			local owner_unit = ScriptUnit.extension(arg_25_0, "projectile_impact_system").owner_unit
			local extension_2 = ScriptUnit.extension(arg_25_0, "projectile_system")
			local item_name = extension_2.item_name
			local item_template_name = extension_2.action_lookup_data.item_template_name
			local action_name = extension_2.action_lookup_data.action_name
			local sub_action_name = extension_2.action_lookup_data.sub_action_name
			local num = extension_2.scale * 100
			local power_level = extension_2.power_level
			local num_2 = extension_2.charge_level * 100
			local tbl = {
				go_type = NetworkLookup.go_types.sticky_projectile_unit,
				husk_unit = NetworkLookup.husks[arg_25_1],
				position = Unit.local_position(arg_25_0, 0),
				rotation = Unit.local_rotation(arg_25_0, 0),
				initial_position = unbox,
				target_vector = target_vector,
				speed = speed
			}
			local unit_game_object_id

			if not Unit.alive(owner_unit) then
				unit_game_object_id = Managers.state.network:unit_game_object_id(owner_unit)

				if not unit_game_object_id then
					-- Nothing
				end
			end

			unit_game_object_id = 0

			::label_25_0::

			tbl.owner_unit = unit_game_object_id
			tbl.item_name = NetworkLookup.item_names[item_name]
			tbl.item_template_name = NetworkLookup.item_template_names[item_template_name]
			tbl.action_name = NetworkLookup.actions[action_name]
			tbl.sub_action_name = NetworkLookup.sub_actions[sub_action_name]
			tbl.scale = num
			tbl.power_level = power_level

			local unit_game_object_id_2

			if not Unit.alive(target_unit) then
				unit_game_object_id_2 = Managers.state.network:unit_game_object_id(target_unit)

				if not unit_game_object_id_2 then
					-- Nothing
				end
			end

			unit_game_object_id_2 = 0

			::label_25_1::

			tbl.target_unit = unit_game_object_id_2
			tbl.stopped = stopped
			tbl.seed = seed
			tbl.charge_level = num_2

			return tbl
		end,
		player_projectile_physic_unit = function (arg_26_0, arg_26_1, arg_26_2, arg_26_3)
			-- function 26
			local extension = ScriptUnit.extension(arg_26_0, "projectile_locomotion_system")
			local owner_unit = extension.owner_unit
			local network_position = extension.network_position
			local network_rotation = extension.network_rotation
			local network_velocity = extension.network_velocity
			local network_angular_velocity = extension.network_angular_velocity
			local extension_2 = ScriptUnit.extension(arg_26_0, "projectile_impact_system")
			local collision_filter = extension_2.collision_filter
			local owner_unit_2 = extension_2.owner_unit
			local extension_3 = ScriptUnit.extension(arg_26_0, "projectile_system")
			local item_name = extension_3.item_name
			local item_template_name = extension_3.action_lookup_data.item_template_name
			local action_name = extension_3.action_lookup_data.action_name
			local sub_action_name = extension_3.action_lookup_data.sub_action_name
			local time_initialized = extension_3.time_initialized
			local num = extension_3.scale * 100

			return {
				go_type = NetworkLookup.go_types.player_projectile_physic_unit,
				husk_unit = NetworkLookup.husks[arg_26_1],
				position = Unit.local_position(arg_26_0, 0),
				rotation = Unit.local_rotation(arg_26_0, 0),
				collision_filter = NetworkLookup.collision_filters[collision_filter],
				owner_unit = Managers.state.network:unit_game_object_id(owner_unit_2),
				item_name = NetworkLookup.item_names[item_name],
				item_template_name = NetworkLookup.item_template_names[item_template_name],
				action_name = NetworkLookup.actions[action_name],
				sub_action_name = NetworkLookup.sub_actions[sub_action_name],
				scale = num
			}
		end,
		prop_projectile_unit = function (arg_27_0, arg_27_1, arg_27_2, arg_27_3)
			-- function 27
			local extension = ScriptUnit.extension(arg_27_0, "projectile_locomotion_system")
			local network_position = extension.network_position
			local network_rotation = extension.network_rotation
			local network_velocity = extension.network_velocity
			local network_angular_velocity = extension.network_angular_velocity

			return {
				go_type = NetworkLookup.go_types.prop_projectile_unit,
				husk_unit = NetworkLookup.husks[arg_27_1],
				position = Unit.local_position(arg_27_0, 0),
				rotation = Unit.local_rotation(arg_27_0, 0),
				network_position = network_position,
				network_rotation = network_rotation,
				network_velocity = network_velocity,
				network_angular_velocity = network_angular_velocity,
				debug_pos = Unit.local_position(arg_27_0, 0)
			}
		end,
		pickup_projectile_unit = function (arg_28_0, arg_28_1, arg_28_2, arg_28_3)
			-- function 28
			local extension = ScriptUnit.extension(arg_28_0, "projectile_locomotion_system")
			local network_position = extension.network_position
			local network_rotation = extension.network_rotation
			local network_velocity = extension.network_velocity
			local network_angular_velocity = extension.network_angular_velocity
			local extension_2 = ScriptUnit.extension(arg_28_0, "pickup_system")
			local pickup_name = extension_2.pickup_name
			local has_physics = extension_2.has_physics
			local spawn_type = extension_2.spawn_type

			return {
				go_type = NetworkLookup.go_types.pickup_projectile_unit,
				husk_unit = NetworkLookup.husks[arg_28_1],
				position = Unit.local_position(arg_28_0, 0),
				rotation = Unit.local_rotation(arg_28_0, 0),
				network_position = network_position,
				network_rotation = network_rotation,
				network_velocity = network_velocity,
				network_angular_velocity = network_angular_velocity,
				debug_pos = Unit.local_position(arg_28_0, 0),
				pickup_name = NetworkLookup.pickup_names[pickup_name],
				has_physics = has_physics,
				spawn_type = NetworkLookup.pickup_spawn_types[spawn_type]
			}
		end,
		limited_owned_pickup_projectile_unit = function (arg_29_0, arg_29_1, arg_29_2, arg_29_3)
			-- function 29
			local extension = ScriptUnit.extension(arg_29_0, "projectile_locomotion_system")
			local network_position = extension.network_position
			local network_rotation = extension.network_rotation
			local network_velocity = extension.network_velocity
			local network_angular_velocity = extension.network_angular_velocity
			local extension_2 = ScriptUnit.extension(arg_29_0, "pickup_system")
			local pickup_name = extension_2.pickup_name
			local has_physics = extension_2.has_physics
			local spawn_type = extension_2.spawn_type
			local owner_peer_id = extension_2.owner_peer_id
			local spawn_limit = extension_2.spawn_limit

			return {
				go_type = NetworkLookup.go_types.limited_owned_pickup_projectile_unit,
				husk_unit = NetworkLookup.husks[arg_29_1],
				position = Unit.local_position(arg_29_0, 0),
				rotation = Unit.local_rotation(arg_29_0, 0),
				network_position = network_position,
				network_rotation = network_rotation,
				network_velocity = network_velocity,
				network_angular_velocity = network_angular_velocity,
				debug_pos = Unit.local_position(arg_29_0, 0),
				pickup_name = NetworkLookup.pickup_names[pickup_name],
				has_physics = has_physics,
				spawn_type = NetworkLookup.pickup_spawn_types[spawn_type],
				owner_peer_id = owner_peer_id,
				spawn_limit = spawn_limit
			}
		end,
		life_time_pickup_projectile_unit = function (arg_30_0, arg_30_1, arg_30_2, arg_30_3)
			-- function 30
			local extension = ScriptUnit.extension(arg_30_0, "projectile_locomotion_system")
			local network_position = extension.network_position
			local network_rotation = extension.network_rotation
			local network_velocity = extension.network_velocity
			local network_angular_velocity = extension.network_angular_velocity
			local extension_2 = ScriptUnit.extension(arg_30_0, "pickup_system")
			local pickup_name = extension_2.pickup_name
			local has_physics = extension_2.has_physics
			local spawn_type = extension_2.spawn_type

			return {
				go_type = NetworkLookup.go_types.life_time_pickup_projectile_unit,
				husk_unit = NetworkLookup.husks[arg_30_1],
				position = Unit.local_position(arg_30_0, 0),
				rotation = Unit.local_rotation(arg_30_0, 0),
				network_position = network_position,
				network_rotation = network_rotation,
				network_velocity = network_velocity,
				network_angular_velocity = network_angular_velocity,
				debug_pos = Unit.local_position(arg_30_0, 0),
				pickup_name = NetworkLookup.pickup_names[pickup_name],
				has_physics = has_physics,
				spawn_type = NetworkLookup.pickup_spawn_types[spawn_type]
			}
		end,
		pickup_training_dummy_unit = function (arg_31_0, arg_31_1, arg_31_2, arg_31_3)
			-- function 31
			local extension = ScriptUnit.extension(arg_31_0, "projectile_locomotion_system")
			local network_position = extension.network_position
			local network_rotation = extension.network_rotation
			local network_velocity = extension.network_velocity
			local network_angular_velocity = extension.network_angular_velocity
			local extension_2 = ScriptUnit.extension(arg_31_0, "pickup_system")
			local pickup_name = extension_2.pickup_name
			local has_physics = extension_2.has_physics
			local spawn_type = extension_2.spawn_type

			return {
				damage = 0,
				go_type = NetworkLookup.go_types.pickup_training_dummy_unit,
				husk_unit = NetworkLookup.husks[arg_31_1],
				position = Unit.local_position(arg_31_0, 0),
				rotation = Unit.local_rotation(arg_31_0, 0),
				network_position = network_position,
				network_rotation = network_rotation,
				network_velocity = network_velocity,
				network_angular_velocity = network_angular_velocity,
				pickup_name = NetworkLookup.pickup_names[pickup_name],
				has_physics = has_physics,
				spawn_type = NetworkLookup.pickup_spawn_types[spawn_type]
			}
		end,
		versus_volume_objective_unit = function (arg_32_0, arg_32_1, arg_32_2, arg_32_3)
			-- function 32
			local objective_name = ScriptUnit.extension(arg_32_0, "objective_system"):objective_name()

			return {
				go_type = NetworkLookup.go_types.versus_volume_objective_unit,
				husk_unit = NetworkLookup.husks[arg_32_1],
				position = Unit.local_position(arg_32_0, 0),
				rotation = Unit.local_rotation(arg_32_0, 0),
				scale = Unit.local_scale(arg_32_0, 0)[1],
				objective_name = NetworkLookup.objective_names[objective_name]
			}
		end,
		versus_capture_point_objective_unit = function (arg_33_0, arg_33_1, arg_33_2, arg_33_3)
			-- function 33
			local extension = ScriptUnit.extension(arg_33_0, "objective_system")
			local objective_name = extension:objective_name()

			return {
				go_type = NetworkLookup.go_types.versus_capture_point_objective_unit,
				husk_unit = NetworkLookup.husks[arg_33_1],
				position = Unit.local_position(arg_33_0, 0),
				rotation = Unit.local_rotation(arg_33_0, 0),
				scale = Unit.local_scale(arg_33_0, 0)[1],
				objective_name = NetworkLookup.objective_names[objective_name],
				timer = extension._timer
			}
		end,
		versus_mission_objective_unit = function (arg_34_0, arg_34_1, arg_34_2, arg_34_3)
			-- function 34
			local objective_name = ScriptUnit.extension(arg_34_0, "objective_system"):objective_name()

			return {
				go_type = NetworkLookup.go_types.versus_mission_objective_unit,
				husk_unit = NetworkLookup.husks[arg_34_1],
				position = Unit.local_position(arg_34_0, 0),
				rotation = Unit.local_rotation(arg_34_0, 0),
				scale = Unit.local_scale(arg_34_0, 0)[1],
				objective_name = NetworkLookup.objective_names[objective_name]
			}
		end,
		weave_capture_point_unit = function (arg_35_0, arg_35_1, arg_35_2, arg_35_3)
			-- function 35
			local extension = ScriptUnit.extension(arg_35_0, "objective_system")
			local objective_name = extension:objective_name()

			return {
				go_type = NetworkLookup.go_types.weave_capture_point_unit,
				husk_unit = NetworkLookup.husks[arg_35_1],
				position = Unit.local_position(arg_35_0, 0),
				rotation = Unit.local_rotation(arg_35_0, 0),
				scale = Unit.local_scale(arg_35_0, 0)[1],
				objective_name = NetworkLookup.objective_names[objective_name],
				timer = extension._timer
			}
		end,
		weave_target_unit = function (arg_36_0, arg_36_1, arg_36_2, arg_36_3)
			-- function 36
			local extension = ScriptUnit.extension(arg_36_0, "objective_system")
			local current_health = ScriptUnit.extension(arg_36_0, "health_system"):current_health()
			local objective_name = extension:objective_name()
			local attacks_allowed = extension:attacks_allowed()

			return {
				go_type = NetworkLookup.go_types.weave_target_unit,
				husk_unit = NetworkLookup.husks[arg_36_1],
				position = Unit.local_position(arg_36_0, 0),
				rotation = Unit.local_rotation(arg_36_0, 0),
				objective_name = NetworkLookup.objective_names[objective_name],
				health = current_health,
				allow_melee_damage = attacks_allowed.melee,
				allow_ranged_damage = attacks_allowed.ranged
			}
		end,
		weave_interaction_unit = function (arg_37_0, arg_37_1, arg_37_2, arg_37_3)
			-- function 37
			local extension = ScriptUnit.extension(arg_37_0, "objective_system")
			local objective_name = extension:objective_name()

			return {
				go_type = NetworkLookup.go_types.weave_interaction_unit,
				husk_unit = NetworkLookup.husks[arg_37_1],
				position = Unit.local_position(arg_37_0, 0),
				rotation = Unit.local_rotation(arg_37_0, 0),
				objective_name = NetworkLookup.objective_names[objective_name],
				num_times_to_complete = extension._num_times_to_complete,
				duration = extension._duration
			}
		end,
		weave_doom_wheel_unit = function (arg_38_0, arg_38_1, arg_38_2, arg_38_3)
			-- function 38
			local objective_name = ScriptUnit.extension(arg_38_0, "objective_system"):objective_name()

			return {
				go_type = NetworkLookup.go_types.weave_doom_wheel_unit,
				husk_unit = NetworkLookup.husks[arg_38_1],
				position = Unit.local_position(arg_38_0, 0),
				rotation = Unit.local_rotation(arg_38_0, 0),
				objective_name = NetworkLookup.objective_names[objective_name]
			}
		end,
		pickup_torch_unit_init = function (arg_39_0, arg_39_1, arg_39_2, arg_39_3)
			-- function 39
			return
		end,
		weave_kill_enemies_unit = function (arg_40_0, arg_40_1, arg_40_2, arg_40_3)
			-- function 40
			local extension = ScriptUnit.extension(arg_40_0, "objective_system")
			local objective_name = extension:objective_name()

			return {
				go_type = NetworkLookup.go_types.weave_kill_enemies_unit,
				husk_unit = NetworkLookup.husks[arg_40_1],
				position = Unit.local_position(arg_40_0, 0),
				rotation = Unit.local_rotation(arg_40_0, 0),
				objective_name = NetworkLookup.objective_names[objective_name],
				amount = extension._kills_required
			}
		end,
		pickup_torch_unit_init = function (arg_41_0, arg_41_1, arg_41_2, arg_41_3)
			-- function 41
			local extension = ScriptUnit.extension(arg_41_0, "projectile_locomotion_system")
			local network_position = extension.network_position
			local network_rotation = extension.network_rotation
			local network_velocity = extension.network_velocity
			local network_angular_velocity = extension.network_angular_velocity
			local extension_2 = ScriptUnit.extension(arg_41_0, "pickup_system")
			local pickup_name = extension_2.pickup_name
			local has_physics = extension_2.has_physics
			local spawn_type = extension_2.spawn_type

			return {
				go_type = NetworkLookup.go_types.pickup_torch_unit,
				husk_unit = NetworkLookup.husks[arg_41_1],
				position = Unit.local_position(arg_41_0, 0),
				rotation = Unit.local_rotation(arg_41_0, 0),
				network_position = network_position,
				network_rotation = network_rotation,
				network_velocity = network_velocity,
				network_angular_velocity = network_angular_velocity,
				debug_pos = Unit.local_position(arg_41_0, 0),
				pickup_name = NetworkLookup.pickup_names[pickup_name],
				has_physics = has_physics,
				spawn_type = NetworkLookup.pickup_spawn_types[spawn_type]
			}
		end,
		pickup_torch_unit = function (arg_42_0, arg_42_1, arg_42_2, arg_42_3)
			-- function 42
			local extension = ScriptUnit.extension(arg_42_0, "projectile_locomotion_system")
			local network_position = extension.network_position
			local network_rotation = extension.network_rotation
			local network_velocity = extension.network_velocity
			local network_angular_velocity = extension.network_angular_velocity
			local extension_2 = ScriptUnit.extension(arg_42_0, "pickup_system")
			local pickup_name = extension_2.pickup_name
			local has_physics = extension_2.has_physics
			local spawn_type = extension_2.spawn_type

			return {
				go_type = NetworkLookup.go_types.pickup_torch_unit,
				husk_unit = NetworkLookup.husks[arg_42_1],
				position = Unit.local_position(arg_42_0, 0),
				rotation = Unit.local_rotation(arg_42_0, 0),
				network_position = network_position,
				network_rotation = network_rotation,
				network_velocity = network_velocity,
				network_angular_velocity = network_angular_velocity,
				debug_pos = Unit.local_position(arg_42_0, 0),
				pickup_name = NetworkLookup.pickup_names[pickup_name],
				has_physics = has_physics,
				spawn_type = NetworkLookup.pickup_spawn_types[spawn_type]
			}
		end,
		pickup_projectile_unit_limited = function (arg_43_0, arg_43_1, arg_43_2, arg_43_3)
			-- function 43
			local extension = ScriptUnit.extension(arg_43_0, "projectile_locomotion_system")
			local network_position = extension.network_position
			local network_rotation = extension.network_rotation
			local network_velocity = extension.network_velocity
			local network_angular_velocity = extension.network_angular_velocity
			local extension_2 = ScriptUnit.extension(arg_43_0, "pickup_system")
			local pickup_name = extension_2.pickup_name
			local owner_peer_id = extension_2.owner_peer_id
			local has_physics = extension_2.has_physics
			local spawn_type = extension_2.spawn_type
			local extension_3 = ScriptUnit.extension(arg_43_0, "limited_item_track_system")
			local spawner_unit = extension_3.spawner_unit
			local id = extension_3.id
			local game_object_or_level_id, var_43_14 = Managers.state.network:game_object_or_level_id(spawner_unit)

			return {
				go_type = NetworkLookup.go_types.pickup_projectile_unit_limited,
				husk_unit = NetworkLookup.husks[arg_43_1],
				position = Unit.local_position(arg_43_0, 0),
				rotation = Unit.local_rotation(arg_43_0, 0),
				network_position = network_position,
				network_rotation = network_rotation,
				network_velocity = network_velocity,
				network_angular_velocity = network_angular_velocity,
				debug_pos = Unit.local_position(arg_43_0, 0),
				spawner_unit = game_object_or_level_id or NetworkConstants.invalid_game_object_id,
				spawner_unit_is_level_unit = var_43_14 or false,
				limited_item_id = id,
				pickup_name = NetworkLookup.pickup_names[pickup_name],
				owner_peer_id = owner_peer_id,
				has_physics = has_physics,
				spawn_type = NetworkLookup.pickup_spawn_types[spawn_type]
			}
		end,
		explosive_pickup_projectile_unit = function (arg_44_0, arg_44_1, arg_44_2, arg_44_3)
			-- function 44
			local extension = ScriptUnit.extension(arg_44_0, "projectile_locomotion_system")
			local network_position = extension.network_position
			local network_rotation = extension.network_rotation
			local network_velocity = extension.network_velocity
			local network_angular_velocity = extension.network_angular_velocity
			local extension_2 = ScriptUnit.extension(arg_44_0, "pickup_system")
			local pickup_name = extension_2.pickup_name
			local has_physics = extension_2.has_physics
			local spawn_type = extension_2.spawn_type
			local extension_3 = ScriptUnit.extension(arg_44_0, "health_system")
			local damage = extension_3.damage
			local extension_4 = ScriptUnit.extension(arg_44_0, "death_system")
			local num = 0
			local num_2 = 0
			local always_show = ScriptUnit.extension(arg_44_0, "tutorial_system").always_show

			always_show = always_show or false

			if not extension_3.ignited then
				local health_data = extension_3:health_data()

				num = health_data.explode_time
				num_2 = health_data.fuse_time
			end

			local item_name = extension_4.item_name

			item_name = item_name or AllPickups[pickup_name].item_name

			return {
				go_type = NetworkLookup.go_types.explosive_pickup_projectile_unit,
				husk_unit = NetworkLookup.husks[arg_44_1],
				position = Unit.local_position(arg_44_0, 0),
				rotation = Unit.local_rotation(arg_44_0, 0),
				network_position = network_position,
				network_rotation = network_rotation,
				network_velocity = network_velocity,
				network_angular_velocity = network_angular_velocity,
				debug_pos = Unit.local_position(arg_44_0, 0),
				pickup_name = NetworkLookup.pickup_names[pickup_name],
				has_physics = has_physics,
				spawn_type = NetworkLookup.pickup_spawn_types[spawn_type],
				damage = damage,
				explode_time = num,
				fuse_time = num_2,
				item_name = NetworkLookup.item_names[item_name],
				always_show = always_show
			}
		end,
		explosive_pickup_projectile_unit_limited = function (arg_45_0, arg_45_1, arg_45_2, arg_45_3)
			-- function 45
			local extension = ScriptUnit.extension(arg_45_0, "projectile_locomotion_system")
			local network_position = extension.network_position
			local network_rotation = extension.network_rotation
			local network_velocity = extension.network_velocity
			local network_angular_velocity = extension.network_angular_velocity
			local extension_2 = ScriptUnit.extension(arg_45_0, "pickup_system")
			local pickup_name = extension_2.pickup_name
			local has_physics = extension_2.has_physics
			local spawn_type = extension_2.spawn_type
			local extension_3 = ScriptUnit.extension(arg_45_0, "limited_item_track_system")
			local spawner_unit = extension_3.spawner_unit
			local id = extension_3.id
			local extension_4 = ScriptUnit.extension(arg_45_0, "health_system")
			local damage = extension_4.damage
			local extension_5 = ScriptUnit.extension(arg_45_0, "death_system")
			local num = 0
			local num_2 = 0
			local always_show = ScriptUnit.extension(arg_45_0, "tutorial_system").always_show

			always_show = always_show or false

			if not extension_4.ignited then
				local health_data = extension_4:health_data()

				num = health_data.explode_time
				num_2 = health_data.fuse_time
			end

			local item_name = extension_5.item_name

			item_name = item_name or AllPickups[pickup_name].item_name

			local game_object_or_level_id, var_45_21 = Managers.state.network:game_object_or_level_id(spawner_unit)

			return {
				go_type = NetworkLookup.go_types.explosive_pickup_projectile_unit_limited,
				husk_unit = NetworkLookup.husks[arg_45_1],
				position = Unit.local_position(arg_45_0, 0),
				rotation = Unit.local_rotation(arg_45_0, 0),
				network_position = network_position,
				network_rotation = network_rotation,
				network_velocity = network_velocity,
				network_angular_velocity = network_angular_velocity,
				debug_pos = Unit.local_position(arg_45_0, 0),
				pickup_name = NetworkLookup.pickup_names[pickup_name],
				has_physics = has_physics,
				spawn_type = NetworkLookup.pickup_spawn_types[spawn_type],
				spawner_unit = game_object_or_level_id or NetworkConstants.invalid_game_object_id,
				spawner_unit_is_level_unit = var_45_21 or false,
				limited_item_id = id,
				damage = damage,
				explode_time = num,
				fuse_time = num_2,
				item_name = NetworkLookup.item_names[item_name],
				always_show = always_show
			}
		end,
		true_flight_projectile_unit = function (arg_46_0, arg_46_1, arg_46_2, arg_46_3)
			-- function 46
			local extension = ScriptUnit.extension(arg_46_0, "projectile_locomotion_system")
			local true_flight_template_name = extension.true_flight_template_name
			local angle = extension.angle
			local target_vector = extension.target_vector
			local speed = extension.speed
			local gravity_settings = extension.gravity_settings
			local unbox = extension.initial_position_boxed:unbox()
			local trajectory_template_name = extension.trajectory_template_name
			local game_object_id_max = NetworkConstants.game_object_id_max

			if not extension.target_unit then
				game_object_id_max = Managers.state.network:unit_game_object_id(extension.target_unit)
			end

			local extension_2 = ScriptUnit.extension(arg_46_0, "projectile_impact_system")
			local server_side_raycast = extension_2.server_side_raycast
			local collision_filter = extension_2.collision_filter
			local owner_unit = extension_2.owner_unit
			local extension_3 = ScriptUnit.extension(arg_46_0, "projectile_system")
			local item_name = extension_3.item_name
			local item_template_name = extension_3.action_lookup_data.item_template_name
			local action_name = extension_3.action_lookup_data.action_name
			local sub_action_name = extension_3.action_lookup_data.sub_action_name
			local time_initialized = extension_3.time_initialized
			local num = extension_3.scale * 100
			local power_level = extension_3.power_level

			return {
				go_type = NetworkLookup.go_types.true_flight_projectile_unit,
				husk_unit = NetworkLookup.husks[arg_46_1],
				position = Unit.local_position(arg_46_0, 0),
				rotation = Unit.local_rotation(arg_46_0, 0),
				true_flight_template_id = TrueFlightTemplates[true_flight_template_name].lookup_id,
				target_unit_id = game_object_id_max,
				angle = angle,
				initial_position = unbox,
				target_vector = target_vector,
				speed = speed,
				gravity_settings = NetworkLookup.projectile_gravity_settings[gravity_settings],
				trajectory_template_id = NetworkLookup.projectile_templates[trajectory_template_name],
				collision_filter = NetworkLookup.collision_filters[collision_filter],
				server_side_raycast = server_side_raycast,
				owner_unit = Managers.state.network:unit_game_object_id(owner_unit),
				item_name = NetworkLookup.item_names[item_name],
				item_template_name = NetworkLookup.item_template_names[item_template_name],
				action_name = NetworkLookup.actions[action_name],
				sub_action_name = NetworkLookup.sub_actions[sub_action_name],
				scale = num,
				power_level = power_level
			}
		end,
		ai_true_flight_projectile_unit = function (arg_47_0, arg_47_1, arg_47_2, arg_47_3)
			-- function 47
			local extension = ScriptUnit.extension(arg_47_0, "projectile_locomotion_system")
			local true_flight_template_name = extension.true_flight_template_name
			local angle = extension.angle
			local target_vector = extension.target_vector
			local speed = extension.speed
			local gravity_settings = extension.gravity_settings
			local unbox = extension.initial_position_boxed:unbox()
			local trajectory_template_name = extension.trajectory_template_name
			local owner_unit = extension.owner_unit
			local game_object_id_max = NetworkConstants.game_object_id_max

			if not extension.target_unit then
				game_object_id_max = Managers.state.network:unit_game_object_id(extension.target_unit)
			end

			local has_extension = ScriptUnit.has_extension(arg_47_0, "projectile_impact_system")
			local server_side_raycast = has_extension.server_side_raycast
			local collision_filter = has_extension.collision_filter
			local extension_2 = ScriptUnit.extension(arg_47_0, "projectile_system")
			local impact_template_name = extension_2.impact_template_name
			local damage_source = extension_2.damage_source

			return {
				go_type = NetworkLookup.go_types.ai_true_flight_projectile_unit,
				husk_unit = NetworkLookup.husks[arg_47_1],
				position = Unit.local_position(arg_47_0, 0),
				rotation = Unit.local_rotation(arg_47_0, 0),
				true_flight_template_id = TrueFlightTemplates[true_flight_template_name].lookup_id,
				target_unit_id = game_object_id_max,
				angle = angle,
				initial_position = unbox,
				target_vector = target_vector,
				speed = speed,
				gravity_settings = NetworkLookup.projectile_gravity_settings[gravity_settings],
				trajectory_template_id = NetworkLookup.projectile_templates[trajectory_template_name],
				impact_template_name = NetworkLookup.projectile_templates[impact_template_name],
				collision_filter = NetworkLookup.collision_filters[collision_filter],
				server_side_raycast = server_side_raycast,
				owner_unit = Managers.state.network:unit_game_object_id(owner_unit)
			}
		end,
		ai_true_flight_projectile_unit_without_raycast = function (arg_48_0, arg_48_1, arg_48_2, arg_48_3)
			-- function 48
			local extension = ScriptUnit.extension(arg_48_0, "projectile_locomotion_system")
			local true_flight_template_name = extension.true_flight_template_name
			local angle = extension.angle
			local target_vector = extension.target_vector
			local speed = extension.speed
			local gravity_settings = extension.gravity_settings
			local unbox = extension.initial_position_boxed:unbox()
			local trajectory_template_name = extension.trajectory_template_name
			local owner_unit = extension.owner_unit
			local game_object_id_max = NetworkConstants.game_object_id_max

			if not extension.target_unit then
				game_object_id_max = Managers.state.network:unit_game_object_id(extension.target_unit)
			end

			local extension_2 = ScriptUnit.extension(arg_48_0, "projectile_system")
			local impact_template_name = extension_2.impact_template_name
			local damage_source = extension_2.damage_source

			return {
				go_type = NetworkLookup.go_types.ai_true_flight_projectile_unit_without_raycast,
				husk_unit = NetworkLookup.husks[arg_48_1],
				position = Unit.local_position(arg_48_0, 0),
				rotation = Unit.local_rotation(arg_48_0, 0),
				true_flight_template_id = TrueFlightTemplates[true_flight_template_name].lookup_id,
				target_unit_id = game_object_id_max,
				angle = angle,
				initial_position = unbox,
				target_vector = target_vector,
				speed = speed,
				gravity_settings = NetworkLookup.projectile_gravity_settings[gravity_settings],
				trajectory_template_id = NetworkLookup.projectile_templates[trajectory_template_name],
				impact_template_name = NetworkLookup.projectile_templates[impact_template_name],
				owner_unit = Managers.state.network:unit_game_object_id(owner_unit)
			}
		end,
		aoe_projectile_unit = function (arg_49_0, arg_49_1, arg_49_2, arg_49_3)
			-- function 49
			local extension = ScriptUnit.extension(arg_49_0, "projectile_locomotion_system")
			local angle = extension.angle
			local speed = extension.speed
			local gravity_settings = extension.gravity_settings
			local target_vector = extension.target_vector
			local unbox = extension.initial_position_boxed:unbox()
			local trajectory_template_name = extension.trajectory_template_name
			local extension_2 = ScriptUnit.extension(arg_49_0, "projectile_impact_system")
			local collision_filter = extension_2.collision_filter
			local server_side_raycast = extension_2.server_side_raycast
			local owner_unit = extension_2.owner_unit
			local extension_3 = ScriptUnit.extension(arg_49_0, "projectile_system")
			local impact_template_name = extension_3.impact_template_name
			local damage_source = extension_3.damage_source
			local extension_4 = ScriptUnit.extension(arg_49_0, "area_damage_system")
			local aoe_dot_damage = extension_4.aoe_dot_damage
			local aoe_init_damage = extension_4.aoe_init_damage
			local aoe_dot_damage_interval = extension_4.aoe_dot_damage_interval
			local radius = extension_4.radius
			local life_time = extension_4.life_time
			local damage_players = extension_4.damage_players
			local player_screen_effect_name = extension_4.player_screen_effect_name
			local dot_effect_name = extension_4.dot_effect_name
			local area_damage_template = extension_4.area_damage_template
			local source_attacker_unit = extension_4.source_attacker_unit
			local network = Managers.state.network

			return {
				go_type = NetworkLookup.go_types.aoe_projectile_unit,
				husk_unit = NetworkLookup.husks[arg_49_1],
				angle = angle,
				speed = speed,
				gravity_settings = NetworkLookup.projectile_gravity_settings[gravity_settings],
				initial_position = unbox,
				target_vector = target_vector,
				trajectory_template_name = NetworkLookup.projectile_templates[trajectory_template_name],
				owner_unit = network:unit_game_object_id(owner_unit),
				collision_filter = NetworkLookup.collision_filters[collision_filter],
				server_side_raycast = server_side_raycast,
				impact_template_name = NetworkLookup.projectile_templates[impact_template_name],
				aoe_dot_damage = aoe_dot_damage,
				aoe_init_damage = aoe_init_damage,
				aoe_dot_damage_interval = aoe_dot_damage_interval,
				radius = radius,
				life_time = life_time,
				damage_players = damage_players,
				player_screen_effect_name = NetworkLookup.effects[player_screen_effect_name],
				dot_effect_name = NetworkLookup.effects[dot_effect_name],
				area_damage_template = NetworkLookup.area_damage_templates[area_damage_template],
				source_attacker_unit = network:unit_game_object_id(source_attacker_unit),
				damage_source_id = NetworkLookup.damage_sources[damage_source]
			}
		end,
		aoe_projectile_unit_fixed_impact = function (arg_50_0, arg_50_1, arg_50_2, arg_50_3)
			-- function 50
			local extension = ScriptUnit.extension(arg_50_0, "projectile_locomotion_system")
			local angle = extension.angle
			local speed = extension.speed
			local gravity_settings = extension.gravity_settings
			local target_vector = extension.target_vector
			local unbox = extension.initial_position_boxed:unbox()
			local trajectory_template_name = extension.trajectory_template_name
			local extension_2 = ScriptUnit.extension(arg_50_0, "projectile_impact_system")
			local impact_data = extension_2.impact_data
			local unbox_2 = impact_data.position:unbox()
			local unbox_3 = impact_data.hit_normal:unbox()
			local unbox_4 = impact_data.direction:unbox()
			local hit_unit = impact_data.hit_unit
			local actor_index = impact_data.actor_index
			local time = impact_data.time
			local owner_unit = extension_2.owner_unit
			local extension_3 = ScriptUnit.extension(arg_50_0, "projectile_system")
			local impact_template_name = extension_3.impact_template_name
			local damage_source = extension_3.damage_source
			local extension_4 = ScriptUnit.extension(arg_50_0, "area_damage_system")
			local aoe_dot_damage = extension_4.aoe_dot_damage
			local aoe_init_damage = extension_4.aoe_init_damage
			local aoe_dot_damage_interval = extension_4.aoe_dot_damage_interval
			local radius = extension_4.radius
			local life_time = extension_4.life_time
			local damage_players = extension_4.damage_players
			local player_screen_effect_name = extension_4.player_screen_effect_name
			local dot_effect_name = extension_4.dot_effect_name
			local area_damage_template = extension_4.area_damage_template
			local source_attacker_unit = extension_4.source_attacker_unit
			local network = Managers.state.network
			local game_object_or_level_id, var_50_32 = network:game_object_or_level_id(hit_unit)

			return {
				go_type = NetworkLookup.go_types.aoe_projectile_unit_fixed_impact,
				husk_unit = NetworkLookup.husks[arg_50_1],
				angle = angle,
				speed = speed,
				gravity_settings = NetworkLookup.projectile_gravity_settings[gravity_settings],
				initial_position = unbox,
				target_vector = target_vector,
				trajectory_template_name = NetworkLookup.projectile_templates[trajectory_template_name],
				owner_unit = network:unit_game_object_id(owner_unit),
				impact_position = unbox_2,
				impact_time = time,
				impact_unit = game_object_or_level_id or NetworkConstants.invalid_game_object_id,
				impact_unit_is_level_unit = var_50_32 or false,
				impact_actor = actor_index,
				impact_direction = unbox_4,
				impact_normal = unbox_3,
				impact_template_name = NetworkLookup.projectile_templates[impact_template_name],
				aoe_dot_damage = aoe_dot_damage,
				aoe_init_damage = aoe_init_damage,
				aoe_dot_damage_interval = aoe_dot_damage_interval,
				radius = radius,
				life_time = life_time,
				damage_players = damage_players,
				player_screen_effect_name = NetworkLookup.effects[player_screen_effect_name],
				dot_effect_name = NetworkLookup.effects[dot_effect_name],
				area_damage_template = NetworkLookup.area_damage_templates[area_damage_template],
				source_attacker_unit = network:unit_game_object_id(source_attacker_unit),
				damage_source_id = NetworkLookup.damage_sources[damage_source]
			}
		end,
		projectile_unit = function (arg_51_0, arg_51_1, arg_51_2, arg_51_3)
			-- function 51
			local extension = ScriptUnit.extension(arg_51_0, "projectile_system")
			local angle = extension.angle
			local speed = extension.speed
			local target_vector = extension.target_vector
			local initial_position = extension.initial_position
			local trajectory_template_name = extension.trajectory_template_name
			local impact_template_name = extension.impact_template_name
			local owner_unit = extension.owner_unit
			local network = Managers.state.network

			return {
				go_type = NetworkLookup.go_types.projectile_unit,
				husk_unit = NetworkLookup.husks[arg_51_1],
				angle = angle,
				speed = speed,
				initial_position = initial_position,
				target_vector = target_vector,
				trajectory_template_name = NetworkLookup.projectile_templates[trajectory_template_name],
				impact_template_name = NetworkLookup.projectile_templates[impact_template_name],
				owner_unit = network:unit_game_object_id(owner_unit)
			}
		end,
		damage_wave_unit = function (arg_52_0, arg_52_1, arg_52_2, arg_52_3)
			-- function 52
			local extension = ScriptUnit.extension(arg_52_0, "area_damage_system")
			local damage_wave_template_name = extension.damage_wave_template_name
			local source_unit = extension.source_unit
			local network = Managers.state.network

			return {
				height_percentage = 0,
				go_type = NetworkLookup.go_types.damage_wave_unit,
				husk_unit = NetworkLookup.husks[arg_52_1],
				position = Unit.local_position(arg_52_0, 0),
				rotation = Unit.local_rotation(arg_52_0, 0),
				damage_wave_template_name = NetworkLookup.damage_wave_templates[damage_wave_template_name],
				source_unit = network:unit_game_object_id(source_unit)
			}
		end,
		damage_blob_unit = function (arg_53_0, arg_53_1, arg_53_2, arg_53_3)
			-- function 53
			local extension = ScriptUnit.extension(arg_53_0, "area_damage_system")
			local damage_blob_template_name = extension.damage_blob_template_name
			local _source_unit = extension._source_unit
			local network = Managers.state.network

			return {
				go_type = NetworkLookup.go_types.damage_blob_unit,
				husk_unit = NetworkLookup.husks[arg_53_1],
				position = Unit.local_position(arg_53_0, 0),
				rotation = Unit.local_rotation(arg_53_0, 0),
				damage_blob_template_name = NetworkLookup.damage_blob_templates[damage_blob_template_name],
				source_unit = network:unit_game_object_id(_source_unit)
			}
		end,
		liquid_aoe_unit = function (arg_54_0, arg_54_1, arg_54_2, arg_54_3)
			-- function 54
			local extension = ScriptUnit.extension(arg_54_0, "area_damage_system")
			local _liquid_area_damage_template = extension._liquid_area_damage_template
			local _source_attacker_unit = extension._source_attacker_unit
			local network = Managers.state.network

			return {
				go_type = NetworkLookup.go_types.liquid_aoe_unit,
				husk_unit = NetworkLookup.husks[arg_54_1],
				liquid_area_damage_template = NetworkLookup.liquid_area_damage_templates[_liquid_area_damage_template],
				source_unit = network:unit_game_object_id(_source_attacker_unit),
				position = Unit.local_position(arg_54_0, 0),
				rotation = Unit.local_rotation(arg_54_0, 0)
			}
		end,
		lure_unit = function (arg_55_0, arg_55_1, arg_55_2, arg_55_3)
			-- function 55
			return {
				go_type = NetworkLookup.go_types.lure_unit,
				husk_unit = NetworkLookup.husks[arg_55_1],
				position = Unit.local_position(arg_55_0, 0),
				rotation = Unit.local_rotation(arg_55_0, 0)
			}
		end,
		aoe_unit = function (arg_56_0, arg_56_1, arg_56_2, arg_56_3)
			-- function 56
			local extension = ScriptUnit.extension(arg_56_0, "area_damage_system")
			local aoe_dot_damage = extension.aoe_dot_damage
			local aoe_init_damage = extension.aoe_init_damage
			local aoe_dot_damage_interval = extension.aoe_dot_damage_interval
			local radius = extension.radius
			local life_time = extension.life_time
			local player_screen_effect_name = extension.player_screen_effect_name
			local dot_effect_name = extension.dot_effect_name
			local area_damage_template = extension.area_damage_template
			local invisible_unit = extension.invisible_unit
			local extra_dot_effect_name = extension.extra_dot_effect_name
			local explosion_template_name = extension.explosion_template_name
			local owner_player = extension.owner_player
			local source_attacker_unit = extension.source_attacker_unit

			if dot_effect_name == nil then
				dot_effect_name = "n/a"
			end

			if extra_dot_effect_name == nil then
				extra_dot_effect_name = "n/a"
			end

			if explosion_template_name == nil then
				explosion_template_name = "n/a"
			end

			if player_screen_effect_name == nil then
				player_screen_effect_name = "n/a"
			end

			local invalid_game_object_id = NetworkConstants.invalid_game_object_id

			if not owner_player then
				invalid_game_object_id = owner_player.game_object_id
			end

			local invalid_game_object_id_2 = NetworkConstants.invalid_game_object_id

			if not source_attacker_unit then
				invalid_game_object_id_2 = Managers.state.network:unit_game_object_id(source_attacker_unit)
			end

			return {
				go_type = NetworkLookup.go_types.aoe_unit,
				husk_unit = NetworkLookup.husks[arg_56_1],
				aoe_dot_damage = aoe_dot_damage,
				aoe_init_damage = aoe_init_damage,
				aoe_dot_damage_interval = aoe_dot_damage_interval,
				position = Unit.local_position(arg_56_0, 0),
				rotation = Unit.local_rotation(arg_56_0, 0),
				radius = radius,
				life_time = life_time,
				player_screen_effect_name = NetworkLookup.effects[player_screen_effect_name],
				dot_effect_name = NetworkLookup.effects[dot_effect_name],
				extra_dot_effect_name = NetworkLookup.effects[extra_dot_effect_name],
				invisible_unit = invisible_unit,
				area_damage_template = NetworkLookup.area_damage_templates[area_damage_template],
				explosion_template_name = NetworkLookup.explosion_templates[explosion_template_name],
				owner_player_id = invalid_game_object_id,
				source_attacker_unit_id = invalid_game_object_id_2
			}
		end,
		thorn_bush_unit = function (arg_57_0, arg_57_1, arg_57_2, arg_57_3)
			-- function 57
			local extension = ScriptUnit.extension(arg_57_0, "area_damage_system")
			local aoe_dot_damage = extension.aoe_dot_damage
			local aoe_init_damage = extension.aoe_init_damage
			local aoe_dot_damage_interval = extension.aoe_dot_damage_interval
			local radius = extension.radius
			local life_time = extension.life_time
			local player_screen_effect_name = extension.player_screen_effect_name
			local dot_effect_name = extension.dot_effect_name
			local area_damage_template = extension.area_damage_template
			local invisible_unit = extension.invisible_unit
			local extra_dot_effect_name = extension.extra_dot_effect_name
			local explosion_template_name = extension.explosion_template_name
			local owner_player = extension.owner_player
			local extension_2 = ScriptUnit.extension(arg_57_0, "props_system")
			local spawn_animation_time = extension_2.spawn_animation_time
			local despawn_animation_time = extension_2.despawn_animation_time
			local slow_modifier = extension_2.slow_modifier

			if dot_effect_name == nil then
				dot_effect_name = "n/a"
			end

			if extra_dot_effect_name == nil then
				extra_dot_effect_name = "n/a"
			end

			if explosion_template_name == nil then
				explosion_template_name = "n/a"
			end

			if player_screen_effect_name == nil then
				player_screen_effect_name = "n/a"
			end

			local invalid_game_object_id = NetworkConstants.invalid_game_object_id

			if not owner_player then
				invalid_game_object_id = owner_player.game_object_id
			end

			return {
				go_type = NetworkLookup.go_types.thorn_bush_unit,
				husk_unit = NetworkLookup.husks[arg_57_1],
				aoe_dot_damage = aoe_dot_damage,
				aoe_init_damage = aoe_init_damage,
				aoe_dot_damage_interval = aoe_dot_damage_interval,
				position = Unit.local_position(arg_57_0, 0),
				rotation = Unit.local_rotation(arg_57_0, 0),
				radius = radius,
				life_time = life_time,
				player_screen_effect_name = NetworkLookup.effects[player_screen_effect_name],
				dot_effect_name = NetworkLookup.effects[dot_effect_name],
				extra_dot_effect_name = NetworkLookup.effects[extra_dot_effect_name],
				invisible_unit = invisible_unit,
				area_damage_template = NetworkLookup.area_damage_templates[area_damage_template],
				explosion_template_name = NetworkLookup.explosion_templates[explosion_template_name],
				owner_player_id = invalid_game_object_id,
				spawn_animation_time = spawn_animation_time,
				despawn_animation_time = despawn_animation_time,
				slow_modifier = slow_modifier
			}
		end,
		shadow_flare_light = function (arg_58_0, arg_58_1, arg_58_2, arg_58_3)
			-- function 58
			local extension = ScriptUnit.extension(arg_58_0, "darkness_system")
			local glow_time = extension.glow_time
			local owner_unit_id = extension.owner_unit_id

			return {
				go_type = NetworkLookup.go_types.shadow_flare_light,
				husk_unit = NetworkLookup.husks[arg_58_1],
				glow_time = glow_time,
				owner_unit_id = owner_unit_id,
				position = Unit.local_position(arg_58_0, 0)
			}
		end,
		timed_explosion_unit = function (arg_59_0, arg_59_1, arg_59_2, arg_59_3)
			-- function 59
			local extension = ScriptUnit.extension(arg_59_0, "area_damage_system")
			local follow_unit = extension.follow_unit
			local explosion_template_name = extension.explosion_template_name
			local network = Managers.state.network

			return {
				go_type = NetworkLookup.go_types.timed_explosion_unit,
				husk_unit = NetworkLookup.husks[arg_59_1],
				follow_unit = network:unit_game_object_id(follow_unit),
				explosion_template_name = NetworkLookup.explosion_templates[explosion_template_name],
				position = Unit.local_position(arg_59_0, 0),
				rotation = Unit.local_rotation(arg_59_0, 0)
			}
		end,
		pickup_unit = function (arg_60_0, arg_60_1, arg_60_2, arg_60_3)
			-- function 60
			local extension = ScriptUnit.extension(arg_60_0, "pickup_system")
			local pickup_name = extension.pickup_name
			local has_physics = extension.has_physics
			local spawn_type = extension.spawn_type
			local dropped_by_breed = extension.dropped_by_breed

			return {
				go_type = NetworkLookup.go_types.pickup_unit,
				husk_unit = NetworkLookup.husks[arg_60_1],
				pickup_name = NetworkLookup.pickup_names[pickup_name],
				has_physics = has_physics,
				spawn_type = NetworkLookup.pickup_spawn_types[spawn_type],
				dropped_by_breed = NetworkLookup.breeds[dropped_by_breed],
				position = Unit.local_position(arg_60_0, 0),
				rotation = Unit.local_rotation(arg_60_0, 0)
			}
		end,
		limited_owned_pickup_unit = function (arg_61_0, arg_61_1, arg_61_2, arg_61_3)
			-- function 61
			local extension = ScriptUnit.extension(arg_61_0, "pickup_system")
			local pickup_name = extension.pickup_name
			local has_physics = extension.has_physics
			local spawn_type = extension.spawn_type
			local owner_peer_id = extension.owner_peer_id
			local spawn_limit = extension.spawn_limit
			local material_settings_name = extension.material_settings_name

			material_settings_name = material_settings_name or "n/a"

			return {
				go_type = NetworkLookup.go_types.limited_owned_pickup_unit,
				husk_unit = NetworkLookup.husks[arg_61_1],
				pickup_name = NetworkLookup.pickup_names[pickup_name],
				has_physics = has_physics,
				spawn_type = NetworkLookup.pickup_spawn_types[spawn_type],
				position = Unit.local_position(arg_61_0, 0),
				rotation = Unit.local_rotation(arg_61_0, 0),
				owner_peer_id = owner_peer_id,
				spawn_limit = spawn_limit,
				material_settings_id = NetworkLookup.material_settings_templates[material_settings_name]
			}
		end,
		life_time_pickup_unit = function (arg_62_0, arg_62_1, arg_62_2, arg_62_3)
			-- function 62
			local extension = ScriptUnit.extension(arg_62_0, "projectile_locomotion_system")
			local network_position = extension.network_position
			local network_rotation = extension.network_rotation
			local network_velocity = extension.network_velocity
			local network_angular_velocity = extension.network_angular_velocity
			local extension_2 = ScriptUnit.extension(arg_62_0, "pickup_system")
			local pickup_name = extension_2.pickup_name
			local has_physics = extension_2.has_physics
			local spawn_type = extension_2.spawn_type

			return {
				go_type = NetworkLookup.go_types.life_time_pickup_unit,
				husk_unit = NetworkLookup.husks[arg_62_1],
				position = Unit.local_position(arg_62_0, 0),
				rotation = Unit.local_rotation(arg_62_0, 0),
				network_position = network_position,
				network_rotation = network_rotation,
				network_velocity = network_velocity,
				network_angular_velocity = network_angular_velocity,
				debug_pos = Unit.local_position(arg_62_0, 0),
				pickup_name = NetworkLookup.pickup_names[pickup_name],
				has_physics = has_physics,
				spawn_type = NetworkLookup.pickup_spawn_types[spawn_type]
			}
		end,
		objective_pickup_unit = function (arg_63_0, arg_63_1, arg_63_2, arg_63_3)
			-- function 63
			local extension = ScriptUnit.extension(arg_63_0, "pickup_system")
			local pickup_name = extension.pickup_name
			local has_physics = extension.has_physics
			local spawn_type = extension.spawn_type
			local has_extension = ScriptUnit.has_extension(arg_63_0, "tutorial_system")
			local always_show

			if not has_extension then
				always_show = has_extension.always_show

				if not always_show then
					-- Nothing
				end
			end

			always_show = false

			::label_63_0::

			return {
				go_type = NetworkLookup.go_types.objective_pickup_unit,
				husk_unit = NetworkLookup.husks[arg_63_1],
				pickup_name = NetworkLookup.pickup_names[pickup_name],
				has_physics = has_physics,
				spawn_type = NetworkLookup.pickup_spawn_types[spawn_type],
				always_show = always_show,
				position = Unit.local_position(arg_63_0, 0),
				rotation = Unit.local_rotation(arg_63_0, 0)
			}
		end,
		prop_unit = function (arg_64_0, arg_64_1, arg_64_2, arg_64_3)
			-- function 64
			return {
				go_type = NetworkLookup.go_types.prop_unit,
				husk_unit = NetworkLookup.husks[arg_64_1]
			}
		end,
		positioned_prop_unit = function (arg_65_0, arg_65_1, arg_65_2, arg_65_3)
			-- function 65
			return {
				go_type = NetworkLookup.go_types.positioned_prop_unit,
				husk_unit = NetworkLookup.husks[arg_65_1],
				position = Unit.local_position(arg_65_0, 0),
				rotation = Unit.local_rotation(arg_65_0, 0)
			}
		end,
		positioned_blob_unit = function (arg_66_0, arg_66_1, arg_66_2, arg_66_3)
			-- function 66
			return {
				go_type = NetworkLookup.go_types.positioned_blob_unit,
				husk_unit = NetworkLookup.husks[arg_66_1],
				position = Unit.local_position(arg_66_0, 0),
				rotation = Unit.local_rotation(arg_66_0, 0)
			}
		end,
		destructible_objective_unit = function (arg_67_0, arg_67_1, arg_67_2, arg_67_3)
			-- function 67
			local has_extension = ScriptUnit.has_extension(arg_67_0, "health_system")

			return {
				go_type = NetworkLookup.go_types.destructible_objective_unit,
				husk_unit = NetworkLookup.husks[arg_67_1],
				position = Unit.local_position(arg_67_0, 0),
				rotation = Unit.local_rotation(arg_67_0, 0),
				health = has_extension:get_max_health()
			}
		end,
		objective_unit = function (arg_68_0, arg_68_1, arg_68_2, arg_68_3)
			-- function 68
			return {
				go_type = NetworkLookup.go_types.objective_unit,
				husk_unit = NetworkLookup.husks[arg_68_1],
				position = Unit.local_position(arg_68_0, 0)
			}
		end,
		standard_unit = function (arg_69_0, arg_69_1, arg_69_2, arg_69_3)
			-- function 69
			local has_extension = ScriptUnit.has_extension(arg_69_0, "health_system")
			local extension = ScriptUnit.extension(arg_69_0, "ai_supplementary_system")
			local extension_2 = ScriptUnit.extension(arg_69_0, "ping_system")

			return {
				go_type = NetworkLookup.go_types.standard_unit,
				husk_unit = NetworkLookup.husks[arg_69_1],
				position = Unit.local_position(arg_69_0, 0),
				rotation = Unit.local_rotation(arg_69_0, 0),
				health = has_extension:get_max_health(),
				standard_template_id = NetworkLookup.standard_templates[extension.standard_template_name],
				always_pingable = extension_2.always_pingable
			}
		end,
		overpowering_blob_unit = function (arg_70_0, arg_70_1, arg_70_2, arg_70_3)
			-- function 70
			local has_extension = ScriptUnit.has_extension(arg_70_0, "health_system")

			return {
				go_type = NetworkLookup.go_types.overpowering_blob_unit,
				husk_unit = NetworkLookup.husks[arg_70_1],
				health = has_extension:get_max_health()
			}
		end,
		network_synched_dummy_unit = function (arg_71_0, arg_71_1, arg_71_2, arg_71_3)
			-- function 71
			local local_scale = Unit.local_scale(arg_71_0, 0)

			return {
				go_type = NetworkLookup.go_types.network_synched_dummy_unit,
				husk_unit = NetworkLookup.husks[arg_71_1],
				position = Unit.local_position(arg_71_0, 0),
				yaw_rot = Quaternion.yaw(Unit.local_rotation(arg_71_0, 0)),
				uniform_scale = local_scale.x
			}
		end,
		position_synched_dummy_unit = function (arg_72_0, arg_72_1, arg_72_2, arg_72_3)
			-- function 72
			return {
				go_type = NetworkLookup.go_types.position_synched_dummy_unit,
				husk_unit = NetworkLookup.husks[arg_72_1],
				rotation = Unit.local_rotation(arg_72_0, 0),
				position = Unit.local_position(arg_72_0, 0)
			}
		end,
		buff_aoe_unit = function (arg_73_0, arg_73_1, arg_73_2, arg_73_3)
			-- function 73
			local extension = ScriptUnit.extension(arg_73_0, "buff_area_system")
			local owner_unit = extension.owner_unit
			local source_unit = extension.source_unit
			local life_time = extension.life_time
			local radius = extension.radius
			local name = extension.template.name
			local invalid_game_object_id = NetworkConstants.invalid_game_object_id

			if not owner_unit then
				invalid_game_object_id = Managers.state.network:unit_game_object_id(owner_unit)
			end

			local invalid_game_object_id_2 = NetworkConstants.invalid_game_object_id

			if not source_unit then
				invalid_game_object_id_2 = Managers.state.network:unit_game_object_id(source_unit)
			end

			return {
				go_type = NetworkLookup.go_types.buff_aoe_unit,
				husk_unit = NetworkLookup.husks[arg_73_1],
				position = Unit.local_position(arg_73_0, 0),
				life_time = life_time,
				radius = radius,
				owner_unit_id = invalid_game_object_id,
				source_unit_id = invalid_game_object_id_2,
				buff_template_id = NetworkLookup.buff_templates[name],
				sub_buff_id = extension.sub_buff_id,
				side_id = extension.side_id
			}
		end,
		buff_unit = function (arg_74_0, arg_74_1, arg_74_2, arg_74_3)
			-- function 74
			return {
				go_type = NetworkLookup.go_types.buff_unit,
				husk_unit = NetworkLookup.husks[arg_74_1],
				position = Unit.local_position(arg_74_0, 0)
			}
		end,
		thrown_weapon_unit = function (arg_75_0, arg_75_1, arg_75_2, arg_75_3)
			-- function 75
			return {
				go_type = NetworkLookup.go_types.thrown_weapon_unit,
				husk_unit = NetworkLookup.husks[arg_75_1],
				position = Unit.local_position(arg_75_0, 0),
				rotation = Unit.local_rotation(arg_75_0, 0)
			}
		end,
		interest_point_level_unit = function (arg_76_0, arg_76_1, arg_76_2, arg_76_3)
			-- function 76
			return {
				go_type = NetworkLookup.go_types.interest_point_level_unit
			}
		end,
		interest_point_unit = function (arg_77_0, arg_77_1, arg_77_2, arg_77_3)
			-- function 77
			return {
				go_type = NetworkLookup.go_types.interest_point_unit,
				husk_unit = NetworkLookup.husks[arg_77_1],
				position = Unit.local_position(arg_77_0, 0),
				rotation = Unit.local_rotation(arg_77_0, 0)
			}
		end,
		sync_unit = function (arg_78_0, arg_78_1, arg_78_2, arg_78_3)
			-- function 78
			local extension = ScriptUnit.extension(arg_78_0, "game_object_system")

			return {
				go_type = NetworkLookup.go_types.sync_unit,
				sync_name = NetworkLookup.sync_names[extension.sync_name]
			}
		end,
		rotating_hazard = function (arg_79_0, arg_79_1, arg_79_2, arg_79_3)
			-- function 79
			local extension = ScriptUnit.extension(arg_79_0, "props_system")

			return {
				go_type = NetworkLookup.go_types.rotating_hazard,
				husk_unit = NetworkLookup.husks[arg_79_1],
				position = Unit.local_position(arg_79_0, 0),
				rotation = Unit.local_rotation(arg_79_0, 0),
				start_network_time = extension._start_t,
				state = extension._state
			}
		end,
		dialogue_node = function (arg_80_0, arg_80_1, arg_80_2, arg_80_3)
			-- function 80
			local dialogue_profile = ScriptUnit.extension(arg_80_0, "dialogue_system").dialogue_profile
			local var_80_1 = Managers.state.side.side_by_unit[arg_80_0]
			local flag = not var_80_1 and var_80_1.side_id

			return {
				go_type = NetworkLookup.go_types.dialogue_node,
				husk_unit = NetworkLookup.husks[arg_80_1],
				dialogue_profile = NetworkLookup.dialogue_profiles[dialogue_profile],
				side_id = not flag and flag > 0 and flag and nil
			}
		end,
		explosive_barrel_socket = function (arg_81_0, arg_81_1, arg_81_2, arg_81_3)
			-- function 81
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
			-- function 82
			local game_object_field = GameSession.game_object_field(arg_82_0, arg_82_1, "wounds")
			local game_object_field_2 = GameSession.game_object_field(arg_82_0, arg_82_1, "profile_id")
			local game_object_field_3 = GameSession.game_object_field(arg_82_0, arg_82_1, "career_id")
			local game_object_field_4 = GameSession.game_object_field(arg_82_0, arg_82_1, "skin_name")
			local game_object_field_5 = GameSession.game_object_field(arg_82_0, arg_82_1, "frame_name")
			local game_object_field_6 = GameSession.game_object_field(arg_82_0, arg_82_1, "ability_percentage")
			local game_object_field_7 = GameSession.game_object_field(arg_82_0, arg_82_1, "has_moved_from_start_position")
			local var_82_7 = SPProfiles[game_object_field_2]

			fassert(var_82_7, "No such profile with index %s", tostring(game_object_field_2))

			local aim_template = var_82_7.aim_template

			aim_template = aim_template or "player"

			local var_82_9 = var_82_7.careers[game_object_field_3]
			local sound_character = var_82_9.sound_character

			fassert(var_82_9, "No such career with career_index %s", tostring(game_object_field_3))
			Unit.set_data(arg_82_3, "sound_character", sound_character)

			local career_voice_parameter = var_82_7.career_voice_parameter

			if not career_voice_parameter then
				local var_82_12 = var_82_7.career_voice_parameter_values[game_object_field_3]

				if not var_82_12 and not GameSettingsDevelopment.use_career_voice_pitch then
					local world = arg_82_4.world
					local wwise_world = Wwise.wwise_world(world)

					WwiseWorld.set_global_parameter(wwise_world, career_voice_parameter, var_82_12)
				end
			end

			local game_object_field_8 = GameSession.game_object_field(arg_82_0, arg_82_1, "local_player_id")
			local game_object_field_9 = GameSession.game_object_field(arg_82_0, arg_82_1, "owner_peer_id")
			local player = Managers.player:player(game_object_field_9, game_object_field_8)
			local var_82_18 = NetworkLookup.cosmetics[game_object_field_4]
			local var_82_19 = NetworkLookup.cosmetics[game_object_field_5]
			local name = var_82_9.name
			local var_82_21 = OverchargeData[name]

			var_82_21 = var_82_21 or {}

			local game_object_field_10 = GameSession.game_object_field(arg_82_0, arg_82_1, "overcharge_max_value")
			local var_82_23 = EnergyData[name]

			var_82_23 = var_82_23 or {}

			local game_object_field_11 = GameSession.game_object_field(arg_82_0, arg_82_1, "energy_max_value")
			local unique_id = player:unique_id()
			local get_status_from_unique_id = Managers.party:get_status_from_unique_id(unique_id)
			local get_party = Managers.party:get_party(get_status_from_unique_id.party_id)
			local var_82_28 = Managers.state.side.side_by_party[get_party]
			local game_object_field_12 = GameSession.game_object_field(arg_82_0, arg_82_1, "network_buff_ids")
			local tbl = {}

			if not game_object_field_12 then
				for i, v in ipairs(game_object_field_12) do
					local var_82_31 = NetworkLookup.buff_templates[v]

					table.insert(tbl, var_82_31)
				end
			end

			fn_2(player, var_82_7, var_82_9, arg_82_3)

			local breed = var_82_9.breed
			local tbl_2 = {
				locomotion_system = {
					id = arg_82_1,
					game = arg_82_0,
					player = player,
					has_moved_from_start_position = game_object_field_7
				},
				health_system = {
					player = player,
					game_object_id = arg_82_1,
					profile_index = game_object_field_2,
					career_index = game_object_field_3
				},
				hit_reaction_system = {
					is_husk = true,
					hit_reaction_template = "player",
					hit_effect_template = breed.hit_effect_template
				},
				death_system = {
					death_reaction_template = "player",
					is_husk = true
				},
				aim_system = {
					is_husk = true,
					go_id = arg_82_1,
					template = aim_template
				},
				status_system = {
					wounds = game_object_field,
					profile_id = game_object_field_2,
					player = player
				},
				inventory_system = {
					id = arg_82_1,
					game = arg_82_0,
					player = player
				},
				attachment_system = {
					profile = var_82_7,
					player = player
				},
				cosmetic_system = {
					profile = var_82_7,
					skin_name = var_82_18,
					frame_name = var_82_19,
					player = player
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
					wwise_career_switch_value = name
				},
				whereabouts_system = {
					player = player
				},
				buff_system = {
					is_husk = true,
					initial_buff_names = tbl,
					breed = breed
				},
				statistics_system = {
					template = "player",
					statistics_id = player:stats_id()
				},
				ai_slot_system = {
					profile_index = game_object_field_2
				},
				talent_system = {
					is_husk = true,
					player = player,
					profile_index = game_object_field_2
				},
				career_system = {
					player = player,
					profile_index = game_object_field_2,
					career_index = game_object_field_3,
					initial_ability_percentage = game_object_field_6
				},
				overcharge_system = {
					overcharge_max_value = game_object_field_10,
					overcharge_data = var_82_21
				},
				energy_system = {
					energy_max_value = game_object_field_11,
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
					player = player
				}
			}
			local unit_template_name = var_82_7.unit_template_name

			unit_template_name = unit_template_name or "player_unit_3rd"

			return unit_template_name, tbl_2
		end,
		player_bot_unit = function (arg_83_0, arg_83_1, arg_83_2, arg_83_3, arg_83_4)
			-- function 83
			local game_object_field = GameSession.game_object_field(arg_83_0, arg_83_1, "wounds")
			local game_object_field_2 = GameSession.game_object_field(arg_83_0, arg_83_1, "profile_id")
			local game_object_field_3 = GameSession.game_object_field(arg_83_0, arg_83_1, "career_id")
			local game_object_field_4 = GameSession.game_object_field(arg_83_0, arg_83_1, "skin_name")
			local game_object_field_5 = GameSession.game_object_field(arg_83_0, arg_83_1, "frame_name")
			local game_object_field_6 = GameSession.game_object_field(arg_83_0, arg_83_1, "ability_percentage")
			local game_object_field_7 = GameSession.game_object_field(arg_83_0, arg_83_1, "has_moved_from_start_position")
			local var_83_7 = SPProfiles[game_object_field_2]

			fassert(var_83_7, "No such profile with index %s", tostring(game_object_field_2))

			local var_83_8 = var_83_7.careers[game_object_field_3]

			fassert(var_83_8, "No such career with career_index %s", tostring(game_object_field_3))
			Unit.set_data(arg_83_3, "sound_character", var_83_8.sound_character)

			local career_voice_parameter = var_83_7.career_voice_parameter

			if not career_voice_parameter then
				local var_83_10 = var_83_7.career_voice_parameter_values[game_object_field_3]

				if not var_83_10 and not GameSettingsDevelopment.use_career_voice_pitch then
					local world = arg_83_4.world
					local wwise_world = Wwise.wwise_world(world)

					WwiseWorld.set_global_parameter(wwise_world, career_voice_parameter, var_83_10)
				end
			end

			local game_object_field_8 = GameSession.game_object_field(arg_83_0, arg_83_1, "local_player_id")
			local game_object_field_9 = GameSession.game_object_field(arg_83_0, arg_83_1, "owner_peer_id")
			local player = Managers.player:player(game_object_field_9, game_object_field_8)
			local var_83_16 = NetworkLookup.cosmetics[game_object_field_4]
			local var_83_17 = NetworkLookup.cosmetics[game_object_field_5]
			local name = var_83_8.name
			local var_83_19 = OverchargeData[name]

			var_83_19 = var_83_19 or {}

			local game_object_field_10 = GameSession.game_object_field(arg_83_0, arg_83_1, "overcharge_max_value")
			local var_83_21 = EnergyData[name]

			var_83_21 = var_83_21 or {}

			local game_object_field_11 = GameSession.game_object_field(arg_83_0, arg_83_1, "energy_max_value")
			local unique_id = player:unique_id()
			local get_status_from_unique_id = Managers.party:get_status_from_unique_id(unique_id)
			local get_party = Managers.party:get_party(get_status_from_unique_id.party_id)
			local var_83_26 = Managers.state.side.side_by_party[get_party]

			fn_2(player, var_83_7, var_83_8, arg_83_3)

			local breed = var_83_8.breed
			local tbl = {
				locomotion_system = {
					id = arg_83_1,
					game = arg_83_0,
					player = player,
					has_moved_from_start_position = game_object_field_7
				},
				health_system = {
					player = player,
					game_object_id = arg_83_1,
					profile_index = game_object_field_2,
					career_index = game_object_field_3
				},
				death_system = {
					death_reaction_template = "player",
					is_husk = true
				},
				inventory_system = {
					id = arg_83_1,
					game = arg_83_0,
					player = player
				},
				hit_reaction_system = {
					is_husk = true,
					hit_reaction_template = "player",
					hit_effect_template = breed.hit_effect_template
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
					wounds = game_object_field,
					profile_id = game_object_field_2,
					player = player
				},
				dialogue_system = {
					wwise_career_switch_group = "player_career",
					faction = "player",
					wwise_voice_switch_group = "character",
					profile = var_83_7,
					wwise_voice_switch_value = var_83_7.character_vo,
					wwise_career_switch_value = name
				},
				whereabouts_system = {
					player = player
				},
				attachment_system = {
					profile = var_83_7
				},
				cosmetic_system = {
					profile = var_83_7,
					skin_name = var_83_16,
					frame_name = var_83_17,
					player = player
				},
				buff_system = {
					is_husk = true,
					breed = breed
				},
				statistics_system = {
					template = "player",
					statistics_id = player:stats_id()
				},
				ai_slot_system = {
					profile_index = game_object_field_2
				},
				talent_system = {
					is_husk = true,
					player = player,
					profile_index = game_object_field_2
				},
				career_system = {
					player = player,
					profile_index = game_object_field_2,
					career_index = game_object_field_3,
					initial_ability_percentage = game_object_field_6
				},
				overcharge_system = {
					overcharge_max_value = game_object_field_10,
					overcharge_data = var_83_19
				},
				energy_system = {
					energy_max_value = game_object_field_11,
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
					player = player
				}
			}

			return "player_bot_unit", tbl
		end,
		ai_unit = function (arg_84_0, arg_84_1, arg_84_2, arg_84_3, arg_84_4)
			-- function 84
			local var_84_0, var_84_1, var_84_2 = fn(arg_84_3, arg_84_0, arg_84_1)
			local game_object_field = GameSession.game_object_field(arg_84_0, arg_84_1, "health")
			local tbl = {
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
					health = game_object_field
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

			return var_84_0.unit_template, tbl
		end,
		ai_unit_training_dummy_bob = function (arg_85_0, arg_85_1, arg_85_2, arg_85_3, arg_85_4)
			-- function 85
			local var_85_0, var_85_1, var_85_2 = fn(arg_85_3, arg_85_0, arg_85_1)
			local game_object_field = GameSession.game_object_field(arg_85_0, arg_85_1, "health")
			local game_object_field_2 = GameSession.game_object_field(arg_85_0, arg_85_1, "network_position")
			local game_object_field_3 = GameSession.game_object_field(arg_85_0, arg_85_1, "network_rotation")
			local game_object_field_4 = GameSession.game_object_field(arg_85_0, arg_85_1, "network_velocity")
			local game_object_field_5 = GameSession.game_object_field(arg_85_0, arg_85_1, "network_angular_velocity")
			local game_object_field_6 = GameSession.game_object_field(arg_85_0, arg_85_1, "pickup_name")
			local game_object_field_7 = GameSession.game_object_field(arg_85_0, arg_85_1, "has_physics")
			local game_object_field_8 = GameSession.game_object_field(arg_85_0, arg_85_1, "spawn_type")
			local tbl = {
				ai_system = {
					go_id = arg_85_1,
					game = arg_85_0,
					side_id = var_85_2
				},
				health_system = {
					damage = 0,
					health = game_object_field
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
					network_position = game_object_field_2,
					network_rotation = game_object_field_3,
					network_velocity = game_object_field_4,
					network_angular_velocity = game_object_field_5
				},
				pickup_system = {
					pickup_name = NetworkLookup.pickup_names[game_object_field_6],
					has_physics = game_object_field_7,
					spawn_type = NetworkLookup.pickup_spawn_types[game_object_field_8]
				}
			}

			return "ai_unit_training_dummy_bob", tbl
		end,
		ai_unit_beastmen_bestigor = function (arg_86_0, arg_86_1, arg_86_2, arg_86_3, arg_86_4)
			-- function 86
			local var_86_0, var_86_1, var_86_2 = fn(arg_86_3, arg_86_0, arg_86_1)
			local var_86_3 = NetworkLookup.ai_inventory[GameSession.game_object_field(arg_86_0, arg_86_1, "inventory_configuration")]
			local game_object_field = GameSession.game_object_field(arg_86_0, arg_86_1, "health")
			local tbl = {
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
					health = game_object_field
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

			return var_86_0.unit_template, tbl
		end,
		ai_unit_beastmen_minotaur = function (arg_87_0, arg_87_1, arg_87_2, arg_87_3, arg_87_4)
			-- function 87
			local var_87_0, var_87_1, var_87_2 = fn(arg_87_3, arg_87_0, arg_87_1)
			local var_87_3 = NetworkLookup.ai_inventory[GameSession.game_object_field(arg_87_0, arg_87_1, "inventory_configuration")]
			local game_object_field = GameSession.game_object_field(arg_87_0, arg_87_1, "health")
			local tbl = {
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
					health = game_object_field
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

			return var_87_0.unit_template, tbl
		end,
		ai_unit_grey_seer = function (arg_88_0, arg_88_1, arg_88_2, arg_88_3, arg_88_4)
			-- function 88
			local var_88_0, var_88_1, var_88_2 = fn(arg_88_3, arg_88_0, arg_88_1)
			local game_object_field = GameSession.game_object_field(arg_88_0, arg_88_1, "health")
			local tbl = {
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
					health = game_object_field
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

			return var_88_0.unit_template, tbl
		end,
		ai_unit_tentacle = function (arg_89_0, arg_89_1, arg_89_2, arg_89_3, arg_89_4)
			-- function 89
			local var_89_0, var_89_1, var_89_2 = fn(arg_89_3, arg_89_0, arg_89_1)
			local game_object_field = GameSession.game_object_field(arg_89_0, arg_89_1, "portal_unit_id")
			local unit = Managers.state.unit_storage:unit(game_object_field)
			local game_object_field_2 = GameSession.game_object_field(arg_89_0, arg_89_1, "health")
			local game_object_field_3 = GameSession.game_object_field(arg_89_0, arg_89_1, "tentacle_template_id")
			local tbl = {
				ai_supplementary_system = {
					portal_unit = unit,
					tentacle_template_name = game_object_field_3
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
					health = game_object_field_2
				},
				proximity_system = {
					breed = var_89_0
				},
				buff_system = {
					breed = var_89_0
				}
			}

			return var_89_0.unit_template, tbl
		end,
		ai_unit_vortex = function (arg_90_0, arg_90_1, arg_90_2, arg_90_3, arg_90_4)
			-- function 90
			local var_90_0, var_90_1, var_90_2 = fn(arg_90_3, arg_90_0, arg_90_1)
			local game_object_field = GameSession.game_object_field(arg_90_0, arg_90_1, "vortex_template_id")
			local var_90_4 = NetworkLookup.vortex_templates[game_object_field]
			local game_object_field_2 = GameSession.game_object_field(arg_90_0, arg_90_1, "inner_decal_unit_id")
			local unit = Managers.state.unit_storage:unit(game_object_field_2)
			local game_object_field_3 = GameSession.game_object_field(arg_90_0, arg_90_1, "outer_decal_unit_id")
			local unit_2 = Managers.state.unit_storage:unit(game_object_field_3)
			local game_object_field_4 = GameSession.game_object_field(arg_90_0, arg_90_1, "owner_unit_id")
			local unit_3 = Managers.state.unit_storage:unit(game_object_field_4)
			local tbl = {
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
					inner_decal_unit = unit,
					outer_decal_unit = unit_2,
					owner_unit = unit_3
				}
			}

			return var_90_0.unit_template, tbl
		end,
		ai_unit_plague_wave_spawner = function (arg_91_0, arg_91_1, arg_91_2, arg_91_3, arg_91_4)
			-- function 91
			local var_91_0, var_91_1, var_91_2 = fn(arg_91_3, arg_91_0, arg_91_1)
			local tbl = {
				ai_system = {
					go_id = arg_91_1,
					game = arg_91_0,
					side_id = var_91_2
				}
			}

			return var_91_0.unit_template, tbl
		end,
		ai_unit_tentacle_portal = function (arg_92_0, arg_92_1, arg_92_2, arg_92_3, arg_92_4)
			-- function 92
			local str = "ai_unit_tentacle_portal"
			local game_object_field = GameSession.game_object_field(arg_92_0, arg_92_1, "health")
			local tbl = {
				health_system = {
					health = game_object_field
				},
				death_system = {
					death_reaction_template = "chaos_tentacle_portal",
					is_husk = true
				}
			}

			return str, tbl
		end,
		ai_unit_with_inventory = function (arg_93_0, arg_93_1, arg_93_2, arg_93_3, arg_93_4)
			-- function 93
			local var_93_0, var_93_1, var_93_2 = fn(arg_93_3, arg_93_0, arg_93_1)
			local var_93_3 = NetworkLookup.ai_inventory[GameSession.game_object_field(arg_93_0, arg_93_1, "inventory_configuration")]
			local game_object_field = GameSession.game_object_field(arg_93_0, arg_93_1, "health")
			local tbl = {
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
					health = game_object_field
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

			return var_93_0.unit_template, tbl
		end,
		ai_unit_with_inventory_and_shield = function (arg_94_0, arg_94_1, arg_94_2, arg_94_3, arg_94_4)
			-- function 94
			local var_94_0, var_94_1, var_94_2 = fn(arg_94_3, arg_94_0, arg_94_1)
			local var_94_3 = NetworkLookup.ai_inventory[GameSession.game_object_field(arg_94_0, arg_94_1, "inventory_configuration")]
			local game_object_field = GameSession.game_object_field(arg_94_0, arg_94_1, "health")
			local game_object_field_2 = GameSession.game_object_field(arg_94_0, arg_94_1, "is_blocking")
			local tbl = {
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
					health = game_object_field
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
					is_blocking = game_object_field_2
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

			return var_94_0.unit_template, tbl
		end,
		ai_unit_storm_vermin_warlord = function (arg_95_0, arg_95_1, arg_95_2, arg_95_3, arg_95_4)
			-- function 95
			local var_95_0, var_95_1, var_95_2 = fn(arg_95_3, arg_95_0, arg_95_1)
			local var_95_3 = NetworkLookup.ai_inventory[GameSession.game_object_field(arg_95_0, arg_95_1, "inventory_configuration")]
			local game_object_field = GameSession.game_object_field(arg_95_0, arg_95_1, "health")
			local game_object_field_2 = GameSession.game_object_field(arg_95_0, arg_95_1, "is_blocking")
			local game_object_field_3 = GameSession.game_object_field(arg_95_0, arg_95_1, "is_dodging")
			local tbl = {
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
					health = game_object_field
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
					is_blocking = game_object_field_2
				},
				proximity_system = {
					breed = var_95_0
				},
				buff_system = {
					breed = var_95_0
				}
			}

			return var_95_0.unit_template, tbl
		end,
		ai_unit_chaos_troll = function (arg_96_0, arg_96_1, arg_96_2, arg_96_3, arg_96_4)
			-- function 96
			local var_96_0, var_96_1 = fn(arg_96_3, arg_96_0, arg_96_1)
			local var_96_2 = NetworkLookup.ai_inventory[GameSession.game_object_field(arg_96_0, arg_96_1, "inventory_configuration")]
			local game_object_field = GameSession.game_object_field(arg_96_0, arg_96_1, "side_id")
			local game_object_field_2 = GameSession.game_object_field(arg_96_0, arg_96_1, "health")
			local tbl = {
				ai_system = {
					go_id = arg_96_1,
					game = arg_96_0,
					side_id = game_object_field
				},
				locomotion_system = {
					go_id = arg_96_1,
					breed = var_96_0,
					game = arg_96_0
				},
				health_system = {
					health = game_object_field_2,
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

			return var_96_0.unit_template, tbl
		end,
		ai_lord_with_inventory = function (arg_97_0, arg_97_1, arg_97_2, arg_97_3, arg_97_4)
			-- function 97
			local game_object_field = GameSession.game_object_field(arg_97_0, arg_97_1, "side_id")
			local game_object_field_2 = GameSession.game_object_field(arg_97_0, arg_97_1, "breed_name")
			local var_97_2 = NetworkLookup.breeds[game_object_field_2]
			local var_97_3 = Breeds[var_97_2]

			Unit.set_data(arg_97_3, "breed", var_97_3)

			local var_97_4 = NetworkLookup.ai_inventory[GameSession.game_object_field(arg_97_0, arg_97_1, "inventory_configuration")]
			local game_object_field_3 = GameSession.game_object_field(arg_97_0, arg_97_1, "health")
			local tbl = {
				ai_system = {
					go_id = arg_97_1,
					game = arg_97_0,
					side_id = game_object_field
				},
				locomotion_system = {
					go_id = arg_97_1,
					breed = var_97_3,
					game = arg_97_0
				},
				health_system = {
					health = game_object_field_3
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

			return var_97_3.unit_template, tbl
		end,
		ai_unit_pack_master = function (arg_98_0, arg_98_1, arg_98_2, arg_98_3, arg_98_4)
			-- function 98
			local var_98_0, var_98_1, var_98_2 = fn(arg_98_3, arg_98_0, arg_98_1)
			local var_98_3 = NetworkLookup.ai_inventory[GameSession.game_object_field(arg_98_0, arg_98_1, "inventory_configuration")]
			local game_object_field = GameSession.game_object_field(arg_98_0, arg_98_1, "health")
			local tbl = {
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
					health = game_object_field
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

			return var_98_0.unit_template, tbl
		end,
		ai_unit_ratling_gunner = function (arg_99_0, arg_99_1, arg_99_2, arg_99_3, arg_99_4)
			-- function 99
			local var_99_0, var_99_1, var_99_2 = fn(arg_99_3, arg_99_0, arg_99_1)
			local var_99_3 = NetworkLookup.ai_inventory[GameSession.game_object_field(arg_99_0, arg_99_1, "inventory_configuration")]
			local game_object_field = GameSession.game_object_field(arg_99_0, arg_99_1, "health")
			local tbl = {
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
					health = game_object_field
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

			return var_99_0.unit_template, tbl
		end,
		ai_unit_warpfire_thrower = function (arg_100_0, arg_100_1, arg_100_2, arg_100_3, arg_100_4)
			-- function 100
			local var_100_0, var_100_1, var_100_2 = fn(arg_100_3, arg_100_0, arg_100_1)
			local var_100_3 = NetworkLookup.ai_inventory[GameSession.game_object_field(arg_100_0, arg_100_1, "inventory_configuration")]
			local game_object_field = GameSession.game_object_field(arg_100_0, arg_100_1, "health")
			local tbl = {
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
					health = game_object_field
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

			return var_100_0.unit_template, tbl
		end,
		ai_unit_stormfiend = function (arg_101_0, arg_101_1, arg_101_2, arg_101_3, arg_101_4)
			-- function 101
			local var_101_0, var_101_1, var_101_2 = fn(arg_101_3, arg_101_0, arg_101_1)
			local var_101_3 = NetworkLookup.ai_inventory[GameSession.game_object_field(arg_101_0, arg_101_1, "inventory_configuration")]
			local game_object_field = GameSession.game_object_field(arg_101_0, arg_101_1, "health")
			local tbl = {
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
					health = game_object_field
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

			return var_101_0.unit_template, tbl
		end,
		ai_unit_stormfiend_boss = function (arg_102_0, arg_102_1, arg_102_2, arg_102_3, arg_102_4)
			-- function 102
			local var_102_0, var_102_1, var_102_2 = fn(arg_102_3, arg_102_0, arg_102_1)
			local var_102_3 = NetworkLookup.ai_inventory[GameSession.game_object_field(arg_102_0, arg_102_1, "inventory_configuration")]
			local game_object_field = GameSession.game_object_field(arg_102_0, arg_102_1, "health")
			local tbl = {
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
					health = game_object_field
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

			return var_102_0.unit_template, tbl
		end,
		player_projectile_unit = function (arg_103_0, arg_103_1, arg_103_2, arg_103_3, arg_103_4)
			-- function 103
			local game_object_field = GameSession.game_object_field(arg_103_0, arg_103_1, "angle")
			local game_object_field_2 = GameSession.game_object_field(arg_103_0, arg_103_1, "target_vector")
			local game_object_field_3 = GameSession.game_object_field(arg_103_0, arg_103_1, "initial_position")
			local game_object_field_4 = GameSession.game_object_field(arg_103_0, arg_103_1, "speed")
			local game_object_field_5 = GameSession.game_object_field(arg_103_0, arg_103_1, "gravity_settings")
			local game_object_field_6 = GameSession.game_object_field(arg_103_0, arg_103_1, "trajectory_template_name")
			local game_object_field_7 = GameSession.game_object_field(arg_103_0, arg_103_1, "owner_unit")
			local game_object_field_8 = GameSession.game_object_field(arg_103_0, arg_103_1, "item_name")
			local game_object_field_9 = GameSession.game_object_field(arg_103_0, arg_103_1, "item_template_name")
			local game_object_field_10 = GameSession.game_object_field(arg_103_0, arg_103_1, "action_name")
			local game_object_field_11 = GameSession.game_object_field(arg_103_0, arg_103_1, "sub_action_name")
			local time = Managers.time:time("game")
			local game_object_field_12 = GameSession.game_object_field(arg_103_0, arg_103_1, "fast_forward_time")
			local game_object_field_13 = GameSession.game_object_field(arg_103_0, arg_103_1, "rotation_speed")
			local num = GameSession.game_object_field(arg_103_0, arg_103_1, "scale") / 100
			local var_103_15 = NetworkLookup.item_names[game_object_field_8]
			local var_103_16 = NetworkLookup.item_template_names[game_object_field_9]
			local var_103_17 = NetworkLookup.actions[game_object_field_10]
			local var_103_18 = NetworkLookup.sub_actions[game_object_field_11]
			local game_object_field_14 = GameSession.game_object_field(arg_103_0, arg_103_1, "power_level")
			local unit

			if game_object_field_7 ~= 0 then
				unit = Managers.state.unit_storage:unit(game_object_field_7)

				if not unit then
					-- Nothing
				end
			end

			unit = nil

			::label_103_0::

			local tbl = {
				projectile_locomotion_system = {
					is_husk = true,
					angle = game_object_field,
					speed = game_object_field_4,
					target_vector = game_object_field_2,
					initial_position = game_object_field_3,
					gravity_settings = NetworkLookup.projectile_gravity_settings[game_object_field_5],
					trajectory_template_name = NetworkLookup.projectile_templates[game_object_field_6],
					fast_forward_time = game_object_field_12,
					rotation_speed = game_object_field_13
				},
				projectile_impact_system = {
					item_name = var_103_15,
					owner_unit = unit
				},
				projectile_system = {
					item_name = var_103_15,
					item_template_name = var_103_16,
					action_name = var_103_17,
					sub_action_name = var_103_18,
					owner_unit = unit,
					time_initialized = time,
					scale = num,
					power_level = game_object_field_14
				}
			}
			local projectile_unit_template_name = WeaponUtils.get_weapon_template(var_103_16).actions[var_103_17][var_103_18].projectile_info.projectile_unit_template_name

			projectile_unit_template_name = projectile_unit_template_name or "player_projectile_unit"

			return projectile_unit_template_name, tbl
		end,
		sticky_projectile_unit = function (arg_104_0, arg_104_1, arg_104_2, arg_104_3, arg_104_4)
			-- function 104
			local game_object_field = GameSession.game_object_field(arg_104_0, arg_104_1, "target_vector")
			local game_object_field_2 = GameSession.game_object_field(arg_104_0, arg_104_1, "initial_position")
			local game_object_field_3 = GameSession.game_object_field(arg_104_0, arg_104_1, "speed")
			local game_object_field_4 = GameSession.game_object_field(arg_104_0, arg_104_1, "target_unit")
			local game_object_field_5 = GameSession.game_object_field(arg_104_0, arg_104_1, "stopped")
			local game_object_field_6 = GameSession.game_object_field(arg_104_0, arg_104_1, "seed")
			local game_object_field_7 = GameSession.game_object_field(arg_104_0, arg_104_1, "charge_level")
			local game_object_field_8 = GameSession.game_object_field(arg_104_0, arg_104_1, "owner_unit")
			local game_object_field_9 = GameSession.game_object_field(arg_104_0, arg_104_1, "item_name")
			local game_object_field_10 = GameSession.game_object_field(arg_104_0, arg_104_1, "item_template_name")
			local game_object_field_11 = GameSession.game_object_field(arg_104_0, arg_104_1, "action_name")
			local game_object_field_12 = GameSession.game_object_field(arg_104_0, arg_104_1, "sub_action_name")
			local num = GameSession.game_object_field(arg_104_0, arg_104_1, "scale") / 100
			local var_104_13 = NetworkLookup.item_names[game_object_field_9]
			local var_104_14 = NetworkLookup.item_template_names[game_object_field_10]
			local var_104_15 = NetworkLookup.actions[game_object_field_11]
			local var_104_16 = NetworkLookup.sub_actions[game_object_field_12]
			local game_object_field_13 = GameSession.game_object_field(arg_104_0, arg_104_1, "power_level")
			local unit

			if game_object_field_8 ~= 0 then
				unit = Managers.state.unit_storage:unit(game_object_field_8)

				if not unit then
					-- Nothing
				end
			end

			unit = nil

			do
				local unit_2
			end

			::label_104_0::

			if game_object_field_4 ~= 0 then
				unit_2 = Managers.state.unit_storage:unit(game_object_field_4)

				if not unit_2 then
					-- Nothing
				end
			end

			unit_2 = nil

			::label_104_1::

			local tbl = {
				projectile_locomotion_system = {
					is_husk = true,
					speed = game_object_field_3,
					target_vector = game_object_field,
					initial_position = game_object_field_2,
					target_unit = unit_2,
					stopped = game_object_field_5,
					seed = game_object_field_6
				},
				projectile_impact_system = {
					item_name = var_104_13,
					owner_unit = unit
				},
				projectile_system = {
					item_name = var_104_13,
					item_template_name = var_104_14,
					action_name = var_104_15,
					sub_action_name = var_104_16,
					owner_unit = unit,
					time_initialized = Managers.time:time("game"),
					scale = num,
					power_level = game_object_field_13,
					stopped = game_object_field_5,
					charge_level = game_object_field_7
				}
			}
			local projectile_unit_template_name = WeaponUtils.get_weapon_template(var_104_14).actions[var_104_15][var_104_16].projectile_info.projectile_unit_template_name

			projectile_unit_template_name = projectile_unit_template_name or "player_projectile_unit"

			return projectile_unit_template_name, tbl
		end,
		prop_projectile_unit = function (arg_105_0, arg_105_1, arg_105_2, arg_105_3, arg_105_4)
			-- function 105
			local game_object_field = GameSession.game_object_field(arg_105_0, arg_105_1, "network_position")
			local game_object_field_2 = GameSession.game_object_field(arg_105_0, arg_105_1, "network_rotation")
			local game_object_field_3 = GameSession.game_object_field(arg_105_0, arg_105_1, "network_velocity")
			local game_object_field_4 = GameSession.game_object_field(arg_105_0, arg_105_1, "network_angular_velocity")
			local tbl = {
				projectile_locomotion_system = {
					network_position = game_object_field,
					network_rotation = game_object_field_2,
					network_velocity = game_object_field_3,
					network_angular_velocity = game_object_field_4
				}
			}

			return "prop_projectile_unit", tbl
		end,
		pickup_projectile_unit = function (arg_106_0, arg_106_1, arg_106_2, arg_106_3, arg_106_4)
			-- function 106
			local game_object_field = GameSession.game_object_field(arg_106_0, arg_106_1, "network_position")
			local game_object_field_2 = GameSession.game_object_field(arg_106_0, arg_106_1, "network_rotation")
			local game_object_field_3 = GameSession.game_object_field(arg_106_0, arg_106_1, "network_velocity")
			local game_object_field_4 = GameSession.game_object_field(arg_106_0, arg_106_1, "network_angular_velocity")
			local game_object_field_5 = GameSession.game_object_field(arg_106_0, arg_106_1, "pickup_name")
			local game_object_field_6 = GameSession.game_object_field(arg_106_0, arg_106_1, "has_physics")
			local game_object_field_7 = GameSession.game_object_field(arg_106_0, arg_106_1, "spawn_type")
			local tbl = {
				projectile_locomotion_system = {
					network_position = game_object_field,
					network_rotation = game_object_field_2,
					network_velocity = game_object_field_3,
					network_angular_velocity = game_object_field_4
				},
				pickup_system = {
					pickup_name = NetworkLookup.pickup_names[game_object_field_5],
					has_physics = game_object_field_6,
					spawn_type = NetworkLookup.pickup_spawn_types[game_object_field_7]
				}
			}

			return "pickup_projectile_unit", tbl
		end,
		limited_owned_pickup_projectile_unit = function (arg_107_0, arg_107_1, arg_107_2, arg_107_3, arg_107_4)
			-- function 107
			local game_object_field = GameSession.game_object_field(arg_107_0, arg_107_1, "network_position")
			local game_object_field_2 = GameSession.game_object_field(arg_107_0, arg_107_1, "network_rotation")
			local game_object_field_3 = GameSession.game_object_field(arg_107_0, arg_107_1, "network_velocity")
			local game_object_field_4 = GameSession.game_object_field(arg_107_0, arg_107_1, "network_angular_velocity")
			local game_object_field_5 = GameSession.game_object_field(arg_107_0, arg_107_1, "pickup_name")
			local game_object_field_6 = GameSession.game_object_field(arg_107_0, arg_107_1, "has_physics")
			local game_object_field_7 = GameSession.game_object_field(arg_107_0, arg_107_1, "spawn_type")
			local game_object_field_8 = GameSession.game_object_field(arg_107_0, arg_107_1, "owner_peer_id")
			local game_object_field_9 = GameSession.game_object_field(arg_107_0, arg_107_1, "spawn_limit")
			local tbl = {
				projectile_locomotion_system = {
					network_position = game_object_field,
					network_rotation = game_object_field_2,
					network_velocity = game_object_field_3,
					network_angular_velocity = game_object_field_4
				},
				pickup_system = {
					pickup_name = NetworkLookup.pickup_names[game_object_field_5],
					has_physics = game_object_field_6,
					spawn_type = NetworkLookup.pickup_spawn_types[game_object_field_7],
					owner_peer_id = game_object_field_8,
					spawn_limit = game_object_field_9
				}
			}

			return "limited_owned_pickup_projectile_unit", tbl
		end,
		life_time_pickup_projectile_unit = function (arg_108_0, arg_108_1, arg_108_2, arg_108_3, arg_108_4)
			-- function 108
			local game_object_field = GameSession.game_object_field(arg_108_0, arg_108_1, "network_position")
			local game_object_field_2 = GameSession.game_object_field(arg_108_0, arg_108_1, "network_rotation")
			local game_object_field_3 = GameSession.game_object_field(arg_108_0, arg_108_1, "network_velocity")
			local game_object_field_4 = GameSession.game_object_field(arg_108_0, arg_108_1, "network_angular_velocity")
			local game_object_field_5 = GameSession.game_object_field(arg_108_0, arg_108_1, "pickup_name")
			local game_object_field_6 = GameSession.game_object_field(arg_108_0, arg_108_1, "has_physics")
			local game_object_field_7 = GameSession.game_object_field(arg_108_0, arg_108_1, "spawn_type")
			local tbl = {
				projectile_locomotion_system = {
					network_position = game_object_field,
					network_rotation = game_object_field_2,
					network_velocity = game_object_field_3,
					network_angular_velocity = game_object_field_4
				},
				pickup_system = {
					pickup_name = NetworkLookup.pickup_names[game_object_field_5],
					has_physics = game_object_field_6,
					spawn_type = NetworkLookup.pickup_spawn_types[game_object_field_7]
				}
			}

			return "life_time_pickup_projectile_unit", tbl
		end,
		pickup_training_dummy_unit = function (arg_109_0, arg_109_1, arg_109_2, arg_109_3, arg_109_4)
			-- function 109
			local game_object_field = GameSession.game_object_field(arg_109_0, arg_109_1, "network_position")
			local game_object_field_2 = GameSession.game_object_field(arg_109_0, arg_109_1, "network_rotation")
			local game_object_field_3 = GameSession.game_object_field(arg_109_0, arg_109_1, "network_velocity")
			local game_object_field_4 = GameSession.game_object_field(arg_109_0, arg_109_1, "network_angular_velocity")
			local game_object_field_5 = GameSession.game_object_field(arg_109_0, arg_109_1, "pickup_name")
			local game_object_field_6 = GameSession.game_object_field(arg_109_0, arg_109_1, "has_physics")
			local game_object_field_7 = GameSession.game_object_field(arg_109_0, arg_109_1, "spawn_type")
			local tbl = {
				projectile_locomotion_system = {
					network_position = game_object_field,
					network_rotation = game_object_field_2,
					network_velocity = game_object_field_3,
					network_angular_velocity = game_object_field_4
				},
				pickup_system = {
					pickup_name = NetworkLookup.pickup_names[game_object_field_5],
					has_physics = game_object_field_6,
					spawn_type = NetworkLookup.pickup_spawn_types[game_object_field_7]
				},
				health_system = {
					damage = 0,
					health = 100
				},
				death_system = {},
				hit_reaction_system = {}
			}

			return "pickup_training_dummy_unit", tbl
		end,
		versus_volume_objective_unit = function (arg_110_0, arg_110_1, arg_110_2, arg_110_3, arg_110_4)
			-- function 110
			local game_object_field = GameSession.game_object_field(arg_110_0, arg_110_1, "objective_name")
			local game_object_field_2 = GameSession.game_object_field(arg_110_0, arg_110_1, "scale")
			local tbl = {
				objective_system = {
					objective_name = NetworkLookup.objective_names[game_object_field],
					scale = Vector3(game_object_field_2, game_object_field_2, game_object_field_2)
				}
			}

			return "versus_volume_objective_unit", tbl
		end,
		versus_capture_point_objective_unit = function (arg_111_0, arg_111_1, arg_111_2, arg_111_3, arg_111_4)
			-- function 111
			local game_object_field = GameSession.game_object_field(arg_111_0, arg_111_1, "objective_name")
			local game_object_field_2 = GameSession.game_object_field(arg_111_0, arg_111_1, "scale")
			local game_object_field_3 = GameSession.game_object_field(arg_111_0, arg_111_1, "timer")
			local tbl = {
				objective_system = {
					objective_name = NetworkLookup.objective_names[game_object_field],
					scale = Vector3(game_object_field_2, game_object_field_2, game_object_field_2),
					timer = game_object_field_3
				}
			}

			return "versus_capture_point_objective_unit", tbl
		end,
		versus_mission_objective_unit = function (arg_112_0, arg_112_1, arg_112_2, arg_112_3, arg_112_4)
			-- function 112
			local game_object_field = GameSession.game_object_field(arg_112_0, arg_112_1, "objective_name")
			local game_object_field_2 = GameSession.game_object_field(arg_112_0, arg_112_1, "scale")
			local tbl = {
				objective_system = {
					objective_name = NetworkLookup.objective_names[game_object_field],
					scale = Vector3(game_object_field_2, game_object_field_2, game_object_field_2)
				}
			}

			return "versus_mission_objective_unit", tbl
		end,
		weave_capture_point_unit = function (arg_113_0, arg_113_1, arg_113_2, arg_113_3, arg_113_4)
			-- function 113
			local game_object_field = GameSession.game_object_field(arg_113_0, arg_113_1, "objective_name")
			local game_object_field_2 = GameSession.game_object_field(arg_113_0, arg_113_1, "timer")
			local game_object_field_3 = GameSession.game_object_field(arg_113_0, arg_113_1, "scale")
			local tbl = {
				objective_system = {
					objective_name = NetworkLookup.objective_names[game_object_field],
					timer = game_object_field_2,
					scale = Vector3(game_object_field_3, game_object_field_3, game_object_field_3)
				}
			}

			return "weave_capture_point_unit", tbl
		end,
		weave_target_unit = function (arg_114_0, arg_114_1, arg_114_2, arg_114_3, arg_114_4)
			-- function 114
			local game_object_field = GameSession.game_object_field(arg_114_0, arg_114_1, "objective_name")
			local game_object_field_2 = GameSession.game_object_field(arg_114_0, arg_114_1, "health")
			local tbl = {
				melee = GameSession.game_object_field(arg_114_0, arg_114_1, "allow_melee_damage"),
				ranged = GameSession.game_object_field(arg_114_0, arg_114_1, "allow_ranged_damage")
			}
			local tbl_2 = {
				objective_system = {
					objective_name = NetworkLookup.objective_names[game_object_field],
					attacks_allowed = tbl
				},
				health_system = {
					health = game_object_field_2
				}
			}

			return "weave_target_unit", tbl_2
		end,
		weave_interaction_unit = function (arg_115_0, arg_115_1, arg_115_2, arg_115_3, arg_115_4)
			-- function 115
			local game_object_field = GameSession.game_object_field(arg_115_0, arg_115_1, "objective_name")
			local game_object_field_2 = GameSession.game_object_field(arg_115_0, arg_115_1, "num_times_to_complete")
			local game_object_field_3 = GameSession.game_object_field(arg_115_0, arg_115_1, "duration")
			local tbl = {
				objective_system = {
					objective_name = NetworkLookup.objective_names[game_object_field],
					num_times_to_complete = game_object_field_2,
					duration = game_object_field_3
				}
			}

			return "weave_interaction_unit", tbl
		end,
		weave_doom_wheel_unit = function (arg_116_0, arg_116_1, arg_116_2, arg_116_3, arg_116_4)
			-- function 116
			local game_object_field = GameSession.game_object_field(arg_116_0, arg_116_1, "objective_name")
			local tbl = {
				objective_system = {
					objective_name = NetworkLookup.objective_names[game_object_field]
				}
			}

			return "weave_doom_wheel", tbl
		end,
		weave_kill_enemies_unit = function (arg_117_0, arg_117_1, arg_117_2, arg_117_3, arg_117_4)
			-- function 117
			local game_object_field = GameSession.game_object_field(arg_117_0, arg_117_1, "objective_name")
			local game_object_field_2 = GameSession.game_object_field(arg_117_0, arg_117_1, "amount")
			local tbl = {
				objective_system = {
					objective_name = NetworkLookup.objective_names[game_object_field],
					amount = game_object_field_2
				}
			}

			return "weave_kill_enemies_unit", tbl
		end,
		pickup_torch_unit_init = function (arg_118_0, arg_118_1, arg_118_2, arg_118_3, arg_118_4)
			-- function 118
			local game_object_field = GameSession.game_object_field(arg_118_0, arg_118_1, "network_position")
			local game_object_field_2 = GameSession.game_object_field(arg_118_0, arg_118_1, "network_rotation")
			local game_object_field_3 = GameSession.game_object_field(arg_118_0, arg_118_1, "network_velocity")
			local game_object_field_4 = GameSession.game_object_field(arg_118_0, arg_118_1, "network_angular_velocity")
			local game_object_field_5 = GameSession.game_object_field(arg_118_0, arg_118_1, "pickup_name")
			local game_object_field_6 = GameSession.game_object_field(arg_118_0, arg_118_1, "has_physics")
			local game_object_field_7 = GameSession.game_object_field(arg_118_0, arg_118_1, "spawn_type")
			local tbl = {
				projectile_locomotion_system = {
					network_position = game_object_field,
					network_rotation = game_object_field_2,
					network_velocity = game_object_field_3,
					network_angular_velocity = game_object_field_4
				},
				pickup_system = {
					pickup_name = NetworkLookup.pickup_names[game_object_field_5],
					has_physics = game_object_field_6,
					spawn_type = NetworkLookup.pickup_spawn_types[game_object_field_7]
				}
			}

			return "pickup_torch_unit", tbl
		end,
		pickup_torch_unit = function (arg_119_0, arg_119_1, arg_119_2, arg_119_3, arg_119_4)
			-- function 119
			local game_object_field = GameSession.game_object_field(arg_119_0, arg_119_1, "network_position")
			local game_object_field_2 = GameSession.game_object_field(arg_119_0, arg_119_1, "network_rotation")
			local game_object_field_3 = GameSession.game_object_field(arg_119_0, arg_119_1, "network_velocity")
			local game_object_field_4 = GameSession.game_object_field(arg_119_0, arg_119_1, "network_angular_velocity")
			local game_object_field_5 = GameSession.game_object_field(arg_119_0, arg_119_1, "pickup_name")
			local game_object_field_6 = GameSession.game_object_field(arg_119_0, arg_119_1, "has_physics")
			local game_object_field_7 = GameSession.game_object_field(arg_119_0, arg_119_1, "spawn_type")
			local tbl = {
				projectile_locomotion_system = {
					network_position = game_object_field,
					network_rotation = game_object_field_2,
					network_velocity = game_object_field_3,
					network_angular_velocity = game_object_field_4
				},
				pickup_system = {
					pickup_name = NetworkLookup.pickup_names[game_object_field_5],
					has_physics = game_object_field_6,
					spawn_type = NetworkLookup.pickup_spawn_types[game_object_field_7]
				}
			}

			return "pickup_torch_unit", tbl
		end,
		pickup_projectile_unit_limited = function (arg_120_0, arg_120_1, arg_120_2, arg_120_3, arg_120_4)
			-- function 120
			local game_object_field = GameSession.game_object_field(arg_120_0, arg_120_1, "network_position")
			local game_object_field_2 = GameSession.game_object_field(arg_120_0, arg_120_1, "network_rotation")
			local game_object_field_3 = GameSession.game_object_field(arg_120_0, arg_120_1, "network_velocity")
			local game_object_field_4 = GameSession.game_object_field(arg_120_0, arg_120_1, "network_angular_velocity")
			local game_object_field_5 = GameSession.game_object_field(arg_120_0, arg_120_1, "pickup_name")
			local game_object_field_6 = GameSession.game_object_field(arg_120_0, arg_120_1, "owner_peer_id")
			local game_object_field_7 = GameSession.game_object_field(arg_120_0, arg_120_1, "has_physics")
			local game_object_field_8 = GameSession.game_object_field(arg_120_0, arg_120_1, "spawn_type")
			local game_object_field_9 = GameSession.game_object_field(arg_120_0, arg_120_1, "spawner_unit")
			local game_object_field_10 = GameSession.game_object_field(arg_120_0, arg_120_1, "spawner_unit_is_level_unit")
			local game_object_field_11 = GameSession.game_object_field(arg_120_0, arg_120_1, "limited_item_id")
			local game_object_or_level_unit = Managers.state.network:game_object_or_level_unit(game_object_field_9, game_object_field_10)
			local tbl = {
				projectile_locomotion_system = {
					network_position = game_object_field,
					network_rotation = game_object_field_2,
					network_velocity = game_object_field_3,
					network_angular_velocity = game_object_field_4
				},
				pickup_system = {
					pickup_name = NetworkLookup.pickup_names[game_object_field_5],
					owner_peer_id = game_object_field_6,
					has_physics = game_object_field_7,
					spawn_type = NetworkLookup.pickup_spawn_types[game_object_field_8]
				},
				limited_item_track_system = {
					spawner_unit = game_object_or_level_unit,
					id = game_object_field_11
				}
			}

			return "pickup_projectile_unit_limited", tbl
		end,
		explosive_pickup_projectile_unit = function (arg_121_0, arg_121_1, arg_121_2, arg_121_3, arg_121_4)
			-- function 121
			local game_object_field = GameSession.game_object_field(arg_121_0, arg_121_1, "network_position")
			local game_object_field_2 = GameSession.game_object_field(arg_121_0, arg_121_1, "network_rotation")
			local game_object_field_3 = GameSession.game_object_field(arg_121_0, arg_121_1, "network_velocity")
			local game_object_field_4 = GameSession.game_object_field(arg_121_0, arg_121_1, "network_angular_velocity")
			local game_object_field_5 = GameSession.game_object_field(arg_121_0, arg_121_1, "pickup_name")
			local game_object_field_6 = GameSession.game_object_field(arg_121_0, arg_121_1, "has_physics")
			local game_object_field_7 = GameSession.game_object_field(arg_121_0, arg_121_1, "spawn_type")
			local game_object_field_8 = GameSession.game_object_field(arg_121_0, arg_121_1, "damage")
			local game_object_field_9 = GameSession.game_object_field(arg_121_0, arg_121_1, "explode_time")
			local game_object_field_10 = GameSession.game_object_field(arg_121_0, arg_121_1, "fuse_time")
			local game_object_field_11 = GameSession.game_object_field(arg_121_0, arg_121_1, "item_name")
			local game_object_field_12 = GameSession.game_object_field(arg_121_0, arg_121_1, "always_show")
			local var_121_12

			if game_object_field_9 ~= 0 then
				var_121_12 = {
					explode_time = game_object_field_9,
					fuse_time = game_object_field_10
				}
			end

			local tbl = {
				projectile_locomotion_system = {
					network_position = game_object_field,
					network_rotation = game_object_field_2,
					network_velocity = game_object_field_3,
					network_angular_velocity = game_object_field_4
				},
				pickup_system = {
					pickup_name = NetworkLookup.pickup_names[game_object_field_5],
					has_physics = game_object_field_6,
					spawn_type = NetworkLookup.pickup_spawn_types[game_object_field_7]
				},
				health_system = {
					in_hand = false,
					item_name = NetworkLookup.item_names[game_object_field_11],
					damage = game_object_field_8,
					health_data = var_121_12
				},
				death_system = {
					in_hand = false,
					item_name = NetworkLookup.item_names[game_object_field_11]
				},
				tutorial_system = {
					always_show = game_object_field_12
				}
			}

			return "explosive_pickup_projectile_unit", tbl
		end,
		explosive_pickup_projectile_unit_limited = function (arg_122_0, arg_122_1, arg_122_2, arg_122_3, arg_122_4)
			-- function 122
			local game_object_field = GameSession.game_object_field(arg_122_0, arg_122_1, "network_position")
			local game_object_field_2 = GameSession.game_object_field(arg_122_0, arg_122_1, "network_rotation")
			local game_object_field_3 = GameSession.game_object_field(arg_122_0, arg_122_1, "network_velocity")
			local game_object_field_4 = GameSession.game_object_field(arg_122_0, arg_122_1, "network_angular_velocity")
			local game_object_field_5 = GameSession.game_object_field(arg_122_0, arg_122_1, "pickup_name")
			local game_object_field_6 = GameSession.game_object_field(arg_122_0, arg_122_1, "has_physics")
			local game_object_field_7 = GameSession.game_object_field(arg_122_0, arg_122_1, "spawn_type")
			local game_object_field_8 = GameSession.game_object_field(arg_122_0, arg_122_1, "spawner_unit")
			local game_object_field_9 = GameSession.game_object_field(arg_122_0, arg_122_1, "spawner_unit_is_level_unit")
			local game_object_field_10 = GameSession.game_object_field(arg_122_0, arg_122_1, "limited_item_id")
			local game_object_field_11 = GameSession.game_object_field(arg_122_0, arg_122_1, "damage")
			local game_object_field_12 = GameSession.game_object_field(arg_122_0, arg_122_1, "explode_time")
			local game_object_field_13 = GameSession.game_object_field(arg_122_0, arg_122_1, "fuse_time")
			local game_object_field_14 = GameSession.game_object_field(arg_122_0, arg_122_1, "item_name")
			local var_122_14

			if game_object_field_12 ~= 0 then
				var_122_14 = {
					explode_time = game_object_field_12,
					fuse_time = game_object_field_13
				}
			end

			local world = arg_122_4.world
			local current_level = LevelHelper:current_level(world)
			local game_object_or_level_unit = Managers.state.network:game_object_or_level_unit(game_object_field_8, game_object_field_9)
			local tbl = {
				projectile_locomotion_system = {
					network_position = game_object_field,
					network_rotation = game_object_field_2,
					network_velocity = game_object_field_3,
					network_angular_velocity = game_object_field_4
				},
				pickup_system = {
					pickup_name = NetworkLookup.pickup_names[game_object_field_5],
					has_physics = game_object_field_6,
					spawn_type = NetworkLookup.pickup_spawn_types[game_object_field_7]
				},
				health_system = {
					in_hand = false,
					item_name = NetworkLookup.item_names[game_object_field_14],
					health_data = var_122_14,
					damage = game_object_field_11
				},
				death_system = {
					in_hand = false,
					item_name = NetworkLookup.item_names[game_object_field_14]
				},
				limited_item_track_system = {
					spawner_unit = game_object_or_level_unit,
					id = game_object_field_10
				}
			}

			return "explosive_pickup_projectile_unit_limited", tbl
		end,
		true_flight_projectile_unit = function (arg_123_0, arg_123_1, arg_123_2, arg_123_3, arg_123_4)
			-- function 123
			local game_object_field = GameSession.game_object_field(arg_123_0, arg_123_1, "angle")
			local game_object_field_2 = GameSession.game_object_field(arg_123_0, arg_123_1, "target_vector")
			local game_object_field_3 = GameSession.game_object_field(arg_123_0, arg_123_1, "initial_position")
			local game_object_field_4 = GameSession.game_object_field(arg_123_0, arg_123_1, "speed")
			local game_object_field_5 = GameSession.game_object_field(arg_123_0, arg_123_1, "gravity_settings")
			local game_object_field_6 = GameSession.game_object_field(arg_123_0, arg_123_1, "trajectory_template_id")
			local game_object_field_7 = GameSession.game_object_field(arg_123_0, arg_123_1, "true_flight_template_id")
			local game_object_field_8 = GameSession.game_object_field(arg_123_0, arg_123_1, "target_unit_id")
			local game_object_field_9 = GameSession.game_object_field(arg_123_0, arg_123_1, "collision_filter")
			local game_object_field_10 = GameSession.game_object_field(arg_123_0, arg_123_1, "server_side_raycast")
			local game_object_field_11 = GameSession.game_object_field(arg_123_0, arg_123_1, "owner_unit")
			local game_object_field_12 = GameSession.game_object_field(arg_123_0, arg_123_1, "item_template_name")
			local game_object_field_13 = GameSession.game_object_field(arg_123_0, arg_123_1, "item_name")
			local game_object_field_14 = GameSession.game_object_field(arg_123_0, arg_123_1, "action_name")
			local game_object_field_15 = GameSession.game_object_field(arg_123_0, arg_123_1, "sub_action_name")
			local time = Managers.time:time("game")
			local num = GameSession.game_object_field(arg_123_0, arg_123_1, "scale") / 100
			local var_123_17 = NetworkLookup.item_template_names[game_object_field_12]
			local var_123_18 = NetworkLookup.item_names[game_object_field_13]
			local var_123_19 = NetworkLookup.actions[game_object_field_14]
			local var_123_20 = NetworkLookup.sub_actions[game_object_field_15]
			local game_object_field_16 = GameSession.game_object_field(arg_123_0, arg_123_1, "power_level")
			local var_123_22

			if game_object_field_8 ~= NetworkConstants.game_object_id_max then
				var_123_22 = Managers.state.unit_storage:unit(game_object_field_8)
			end

			local unit = Managers.state.unit_storage:unit(game_object_field_11)
			local tbl = {
				projectile_locomotion_system = {
					is_husk = true,
					true_flight_template_name = TrueFlightTemplatesLookup[game_object_field_7],
					target_unit = var_123_22,
					owner_unit = unit,
					angle = game_object_field,
					speed = game_object_field_4,
					target_vector = game_object_field_2,
					initial_position = game_object_field_3,
					gravity_settings = NetworkLookup.projectile_gravity_settings[game_object_field_5],
					trajectory_template_name = NetworkLookup.projectile_templates[game_object_field_6]
				},
				projectile_impact_system = {
					item_name = var_123_18,
					collision_filter = NetworkLookup.collision_filters[game_object_field_9],
					server_side_raycast = game_object_field_10,
					owner_unit = unit
				},
				projectile_system = {
					item_name = var_123_18,
					item_template_name = var_123_17,
					action_name = var_123_19,
					sub_action_name = var_123_20,
					owner_unit = unit,
					time_initialized = time,
					scale = num,
					power_level = game_object_field_16
				}
			}

			return "true_flight_projectile_unit", tbl
		end,
		ai_true_flight_projectile_unit = function (arg_124_0, arg_124_1, arg_124_2, arg_124_3, arg_124_4)
			-- function 124
			local game_object_field = GameSession.game_object_field(arg_124_0, arg_124_1, "owner_unit")
			local game_object_field_2 = GameSession.game_object_field(arg_124_0, arg_124_1, "angle")
			local game_object_field_3 = GameSession.game_object_field(arg_124_0, arg_124_1, "target_vector")
			local game_object_field_4 = GameSession.game_object_field(arg_124_0, arg_124_1, "initial_position")
			local game_object_field_5 = GameSession.game_object_field(arg_124_0, arg_124_1, "speed")
			local game_object_field_6 = GameSession.game_object_field(arg_124_0, arg_124_1, "gravity_settings")
			local game_object_field_7 = GameSession.game_object_field(arg_124_0, arg_124_1, "trajectory_template_id")
			local game_object_field_8 = GameSession.game_object_field(arg_124_0, arg_124_1, "true_flight_template_id")
			local game_object_field_9 = GameSession.game_object_field(arg_124_0, arg_124_1, "target_unit_id")
			local game_object_field_10 = GameSession.game_object_field(arg_124_0, arg_124_1, "collision_filter")
			local game_object_field_11 = GameSession.game_object_field(arg_124_0, arg_124_1, "server_side_raycast")
			local game_object_field_12 = GameSession.game_object_field(arg_124_0, arg_124_1, "impact_template_name")
			local var_124_12

			if game_object_field_9 ~= NetworkConstants.game_object_id_max then
				var_124_12 = Managers.state.unit_storage:unit(game_object_field_9)
			end

			local unit = Managers.state.unit_storage:unit(game_object_field)
			local var_124_14 = TrueFlightTemplatesLookup[game_object_field_8]
			local tbl = {
				projectile_locomotion_system = {
					is_husk = true,
					true_flight_template_name = var_124_14,
					target_unit = var_124_12,
					owner_unit = unit,
					angle = game_object_field_2,
					speed = game_object_field_5,
					target_vector = game_object_field_3,
					initial_position = game_object_field_4,
					gravity_settings = NetworkLookup.projectile_gravity_settings[game_object_field_6],
					trajectory_template_name = NetworkLookup.projectile_templates[game_object_field_7]
				},
				projectile_impact_system = {
					collision_filter = NetworkLookup.collision_filters[game_object_field_10],
					server_side_raycast = game_object_field_11,
					owner_unit = unit
				},
				projectile_system = {
					impact_template_name = NetworkLookup.projectile_templates[game_object_field_12],
					owner_unit = unit
				}
			}

			return "ai_true_flight_projectile_unit", tbl, var_124_14
		end,
		ai_true_flight_projectile_unit_without_raycast = function (arg_125_0, arg_125_1, arg_125_2, arg_125_3, arg_125_4)
			-- function 125
			local game_object_field = GameSession.game_object_field(arg_125_0, arg_125_1, "owner_unit")
			local game_object_field_2 = GameSession.game_object_field(arg_125_0, arg_125_1, "angle")
			local game_object_field_3 = GameSession.game_object_field(arg_125_0, arg_125_1, "target_vector")
			local game_object_field_4 = GameSession.game_object_field(arg_125_0, arg_125_1, "initial_position")
			local game_object_field_5 = GameSession.game_object_field(arg_125_0, arg_125_1, "speed")
			local game_object_field_6 = GameSession.game_object_field(arg_125_0, arg_125_1, "gravity_settings")
			local game_object_field_7 = GameSession.game_object_field(arg_125_0, arg_125_1, "trajectory_template_id")
			local game_object_field_8 = GameSession.game_object_field(arg_125_0, arg_125_1, "true_flight_template_id")
			local game_object_field_9 = GameSession.game_object_field(arg_125_0, arg_125_1, "target_unit_id")
			local game_object_field_10 = GameSession.game_object_field(arg_125_0, arg_125_1, "impact_template_name")
			local var_125_10

			if game_object_field_9 ~= NetworkConstants.game_object_id_max then
				var_125_10 = Managers.state.unit_storage:unit(game_object_field_9)
			end

			local unit = Managers.state.unit_storage:unit(game_object_field)
			local tbl = {
				projectile_locomotion_system = {
					is_husk = true,
					true_flight_template_name = TrueFlightTemplatesLookup[game_object_field_8],
					target_unit = var_125_10,
					owner_unit = unit,
					angle = game_object_field_2,
					speed = game_object_field_5,
					target_vector = game_object_field_3,
					initial_position = game_object_field_4,
					gravity_settings = NetworkLookup.projectile_gravity_settings[game_object_field_6],
					trajectory_template_name = NetworkLookup.projectile_templates[game_object_field_7]
				},
				projectile_system = {
					impact_template_name = NetworkLookup.projectile_templates[game_object_field_10],
					owner_unit = unit
				}
			}

			return "ai_true_flight_projectile_unit_without_raycast", tbl
		end,
		aoe_projectile_unit = function (arg_126_0, arg_126_1, arg_126_2, arg_126_3, arg_126_4)
			-- function 126
			local game_object_field = GameSession.game_object_field(arg_126_0, arg_126_1, "angle")
			local game_object_field_2 = GameSession.game_object_field(arg_126_0, arg_126_1, "speed")
			local game_object_field_3 = GameSession.game_object_field(arg_126_0, arg_126_1, "gravity_settings")
			local game_object_field_4 = GameSession.game_object_field(arg_126_0, arg_126_1, "target_vector")
			local game_object_field_5 = GameSession.game_object_field(arg_126_0, arg_126_1, "initial_position")
			local game_object_field_6 = GameSession.game_object_field(arg_126_0, arg_126_1, "trajectory_template_name")
			local game_object_field_7 = GameSession.game_object_field(arg_126_0, arg_126_1, "owner_unit")
			local game_object_field_8 = GameSession.game_object_field(arg_126_0, arg_126_1, "source_attacker_unit")
			local game_object_field_9 = GameSession.game_object_field(arg_126_0, arg_126_1, "server_side_raycast")
			local game_object_field_10 = GameSession.game_object_field(arg_126_0, arg_126_1, "collision_filter")
			local game_object_field_11 = GameSession.game_object_field(arg_126_0, arg_126_1, "impact_template_name")
			local game_object_field_12 = GameSession.game_object_field(arg_126_0, arg_126_1, "aoe_init_damage")
			local game_object_field_13 = GameSession.game_object_field(arg_126_0, arg_126_1, "aoe_dot_damage")
			local game_object_field_14 = GameSession.game_object_field(arg_126_0, arg_126_1, "aoe_dot_damage_interval")
			local game_object_field_15 = GameSession.game_object_field(arg_126_0, arg_126_1, "radius")
			local game_object_field_16 = GameSession.game_object_field(arg_126_0, arg_126_1, "life_time")
			local game_object_field_17 = GameSession.game_object_field(arg_126_0, arg_126_1, "damage_players")
			local game_object_field_18 = GameSession.game_object_field(arg_126_0, arg_126_1, "player_screen_effect_name")
			local game_object_field_19 = GameSession.game_object_field(arg_126_0, arg_126_1, "dot_effect_name")
			local game_object_field_20 = GameSession.game_object_field(arg_126_0, arg_126_1, "area_damage_template")
			local game_object_field_21 = GameSession.game_object_field(arg_126_0, arg_126_1, "damage_source_id")
			local unit = Managers.state.unit_storage:unit(game_object_field_7)
			local unit_owner = Managers.player:unit_owner(unit)
			local unit_2 = Managers.state.unit_storage:unit(game_object_field_8)
			local tbl = {
				projectile_locomotion_system = {
					is_husk = true,
					angle = game_object_field,
					speed = game_object_field_2,
					gravity_settings = NetworkLookup.projectile_gravity_settings[game_object_field_3],
					target_vector = game_object_field_4,
					initial_position = game_object_field_5,
					trajectory_template_name = NetworkLookup.projectile_templates[game_object_field_6]
				},
				projectile_impact_system = {
					collision_filter = NetworkLookup.collision_filters[game_object_field_10],
					server_side_raycast = game_object_field_9,
					owner_unit = unit
				},
				projectile_system = {
					impact_template_name = NetworkLookup.projectile_templates[game_object_field_11],
					owner_unit = unit,
					damage_source = NetworkLookup.damage_sources[game_object_field_21]
				},
				area_damage_system = {
					aoe_dot_damage = game_object_field_13,
					aoe_init_damage = game_object_field_12,
					aoe_dot_damage_interval = game_object_field_14,
					radius = game_object_field_15,
					life_time = game_object_field_16,
					damage_players = game_object_field_17,
					player_screen_effect_name = NetworkLookup.effects[game_object_field_18],
					dot_effect_name = NetworkLookup.effects[game_object_field_19],
					area_damage_template = NetworkLookup.area_damage_templates[game_object_field_20],
					damage_source = NetworkLookup.damage_sources[game_object_field_21],
					source_attacker_unit = unit_2,
					owner_player = unit_owner
				}
			}

			return "aoe_projectile_unit", tbl
		end,
		aoe_projectile_unit_fixed_impact = function (arg_127_0, arg_127_1, arg_127_2, arg_127_3, arg_127_4)
			-- function 127
			local game_object_field = GameSession.game_object_field(arg_127_0, arg_127_1, "angle")
			local game_object_field_2 = GameSession.game_object_field(arg_127_0, arg_127_1, "speed")
			local game_object_field_3 = GameSession.game_object_field(arg_127_0, arg_127_1, "gravity_settings")
			local game_object_field_4 = GameSession.game_object_field(arg_127_0, arg_127_1, "target_vector")
			local game_object_field_5 = GameSession.game_object_field(arg_127_0, arg_127_1, "initial_position")
			local game_object_field_6 = GameSession.game_object_field(arg_127_0, arg_127_1, "trajectory_template_name")
			local game_object_field_7 = GameSession.game_object_field(arg_127_0, arg_127_1, "owner_unit")
			local game_object_field_8 = GameSession.game_object_field(arg_127_0, arg_127_1, "source_attacker_unit")
			local game_object_field_9 = GameSession.game_object_field(arg_127_0, arg_127_1, "impact_position")
			local game_object_field_10 = GameSession.game_object_field(arg_127_0, arg_127_1, "impact_normal")
			local game_object_field_11 = GameSession.game_object_field(arg_127_0, arg_127_1, "impact_direction")
			local game_object_field_12 = GameSession.game_object_field(arg_127_0, arg_127_1, "impact_unit")
			local game_object_field_13 = GameSession.game_object_field(arg_127_0, arg_127_1, "impact_unit_is_level_unit")
			local game_object_field_14 = GameSession.game_object_field(arg_127_0, arg_127_1, "impact_actor")
			local game_object_field_15 = GameSession.game_object_field(arg_127_0, arg_127_1, "impact_time")
			local game_object_field_16 = GameSession.game_object_field(arg_127_0, arg_127_1, "impact_template_name")
			local game_object_field_17 = GameSession.game_object_field(arg_127_0, arg_127_1, "aoe_init_damage")
			local game_object_field_18 = GameSession.game_object_field(arg_127_0, arg_127_1, "aoe_dot_damage")
			local game_object_field_19 = GameSession.game_object_field(arg_127_0, arg_127_1, "aoe_dot_damage_interval")
			local game_object_field_20 = GameSession.game_object_field(arg_127_0, arg_127_1, "radius")
			local game_object_field_21 = GameSession.game_object_field(arg_127_0, arg_127_1, "life_time")
			local game_object_field_22 = GameSession.game_object_field(arg_127_0, arg_127_1, "damage_players")
			local game_object_field_23 = GameSession.game_object_field(arg_127_0, arg_127_1, "player_screen_effect_name")
			local game_object_field_24 = GameSession.game_object_field(arg_127_0, arg_127_1, "dot_effect_name")
			local game_object_field_25 = GameSession.game_object_field(arg_127_0, arg_127_1, "area_damage_template")
			local game_object_field_26 = GameSession.game_object_field(arg_127_0, arg_127_1, "damage_source_id")
			local unit = Managers.state.unit_storage:unit(game_object_field_7)
			local unit_owner = Managers.player:unit_owner(unit)
			local unit_2 = Managers.state.unit_storage:unit(game_object_field_8)
			local tbl = {
				position = Vector3Box(game_object_field_9),
				direction = Vector3Box(game_object_field_11),
				hit_unit = Managers.state.network:game_object_or_level_unit(game_object_field_12, game_object_field_13),
				actor_index = game_object_field_14,
				hit_normal = Vector3Box(game_object_field_10),
				time = game_object_field_15
			}
			local tbl_2 = {
				projectile_locomotion_system = {
					is_husk = true,
					angle = game_object_field,
					speed = game_object_field_2,
					gravity_settings = NetworkLookup.projectile_gravity_settings[game_object_field_3],
					target_vector = game_object_field_4,
					initial_position = game_object_field_5,
					trajectory_template_name = NetworkLookup.projectile_templates[game_object_field_6]
				},
				projectile_impact_system = {
					impact_data = tbl,
					owner_unit = unit
				},
				projectile_system = {
					impact_template_name = NetworkLookup.projectile_templates[game_object_field_16],
					owner_unit = unit,
					damage_source = NetworkLookup.damage_sources[game_object_field_26]
				},
				area_damage_system = {
					aoe_dot_damage = game_object_field_18,
					aoe_init_damage = game_object_field_17,
					aoe_dot_damage_interval = game_object_field_19,
					radius = game_object_field_20,
					life_time = game_object_field_21,
					damage_players = game_object_field_22,
					player_screen_effect_name = NetworkLookup.effects[game_object_field_23],
					dot_effect_name = NetworkLookup.effects[game_object_field_24],
					area_damage_template = NetworkLookup.area_damage_templates[game_object_field_25],
					damage_source = NetworkLookup.damage_sources[game_object_field_26],
					source_attacker_unit = unit_2,
					owner_player = unit_owner
				}
			}

			return "aoe_projectile_unit_fixed_impact", tbl_2
		end,
		projectile_unit = function (arg_128_0, arg_128_1, arg_128_2, arg_128_3, arg_128_4)
			-- function 128
			local game_object_field = GameSession.game_object_field(arg_128_0, arg_128_1, "angle")
			local game_object_field_2 = GameSession.game_object_field(arg_128_0, arg_128_1, "speed")
			local game_object_field_3 = GameSession.game_object_field(arg_128_0, arg_128_1, "target_vector")
			local game_object_field_4 = GameSession.game_object_field(arg_128_0, arg_128_1, "initial_position")
			local game_object_field_5 = GameSession.game_object_field(arg_128_0, arg_128_1, "trajectory_template_name")
			local game_object_field_6 = GameSession.game_object_field(arg_128_0, arg_128_1, "impact_template_name")
			local game_object_field_7 = GameSession.game_object_field(arg_128_0, arg_128_1, "owner_unit")
			local tbl = {
				projectile_system = {
					is_husk = true,
					angle = game_object_field,
					speed = game_object_field_2,
					target_vector = game_object_field_3,
					initial_position = game_object_field_4,
					trajectory_template_name = NetworkLookup.projectile_templates[game_object_field_5],
					impact_template_name = NetworkLookup.projectile_templates[game_object_field_6],
					owner_unit = Managers.state.unit_storage:unit(game_object_field_7)
				}
			}

			return "projectile_unit", tbl
		end,
		damage_wave_unit = function (arg_129_0, arg_129_1, arg_129_2, arg_129_3, arg_129_4)
			-- function 129
			local game_object_field = GameSession.game_object_field(arg_129_0, arg_129_1, "damage_wave_template_name")
			local game_object_field_2 = GameSession.game_object_field(arg_129_0, arg_129_1, "source_unit")
			local tbl = {
				area_damage_system = {
					damage_wave_template_name = NetworkLookup.damage_wave_templates[game_object_field],
					source_unit = Managers.state.unit_storage:unit(game_object_field_2)
				}
			}

			return "damage_wave_unit", tbl
		end,
		damage_blob_unit = function (arg_130_0, arg_130_1, arg_130_2, arg_130_3, arg_130_4)
			-- function 130
			local game_object_field = GameSession.game_object_field(arg_130_0, arg_130_1, "damage_blob_template_name")
			local game_object_field_2 = GameSession.game_object_field(arg_130_0, arg_130_1, "source_unit")
			local tbl = {
				area_damage_system = {
					damage_blob_template_name = NetworkLookup.damage_blob_templates[game_object_field],
					source_unit = Managers.state.unit_storage:unit(game_object_field_2)
				}
			}

			return "damage_blob_unit", tbl
		end,
		liquid_aoe_unit = function (arg_131_0, arg_131_1, arg_131_2, arg_131_3, arg_131_4)
			-- function 131
			local game_object_field = GameSession.game_object_field(arg_131_0, arg_131_1, "liquid_area_damage_template")
			local game_object_field_2 = GameSession.game_object_field(arg_131_0, arg_131_1, "source_unit")
			local tbl = {
				area_damage_system = {
					liquid_template = NetworkLookup.liquid_area_damage_templates[game_object_field],
					source_unit = Managers.state.unit_storage:unit(game_object_field_2)
				}
			}

			return "liquid_aoe_unit", tbl
		end,
		lure_unit = function (arg_132_0, arg_132_1, arg_132_2, arg_132_3, arg_132_4)
			-- function 132
			local str = "lure_unit"
			local tbl = {
				health_system = {
					duration = 5
				},
				death_system = {
					death_reaction_template = "lure_unit"
				}
			}

			return str, tbl
		end,
		aoe_unit = function (arg_133_0, arg_133_1, arg_133_2, arg_133_3, arg_133_4)
			-- function 133
			local game_object_field = GameSession.game_object_field(arg_133_0, arg_133_1, "aoe_dot_damage")
			local game_object_field_2 = GameSession.game_object_field(arg_133_0, arg_133_1, "aoe_init_damage")
			local game_object_field_3 = GameSession.game_object_field(arg_133_0, arg_133_1, "aoe_dot_damage_interval")
			local game_object_field_4 = GameSession.game_object_field(arg_133_0, arg_133_1, "radius")
			local game_object_field_5 = GameSession.game_object_field(arg_133_0, arg_133_1, "life_time")
			local game_object_field_6 = GameSession.game_object_field(arg_133_0, arg_133_1, "player_screen_effect_name")
			local game_object_field_7 = GameSession.game_object_field(arg_133_0, arg_133_1, "dot_effect_name")
			local game_object_field_8 = GameSession.game_object_field(arg_133_0, arg_133_1, "area_damage_template")
			local game_object_field_9 = GameSession.game_object_field(arg_133_0, arg_133_1, "invisible_unit")
			local game_object_field_10 = GameSession.game_object_field(arg_133_0, arg_133_1, "extra_dot_effect_name")
			local game_object_field_11 = GameSession.game_object_field(arg_133_0, arg_133_1, "explosion_template_name")
			local game_object_field_12 = GameSession.game_object_field(arg_133_0, arg_133_1, "owner_player_id")
			local game_object_field_13 = GameSession.game_object_field(arg_133_0, arg_133_1, "source_attacker_unit_id")
			local var_133_13 = NetworkLookup.effects[game_object_field_10]

			if var_133_13 == "n/a" then
				var_133_13 = nil
			end

			local var_133_14 = NetworkLookup.explosion_templates[game_object_field_11]

			if var_133_14 == "n/a" then
				var_133_14 = nil
			end

			local var_133_15 = NetworkLookup.effects[game_object_field_6]

			if var_133_15 == "n/a" then
				var_133_15 = nil
			end

			local var_133_16 = NetworkLookup.effects[game_object_field_7]

			if var_133_16 == "n/a" then
				var_133_16 = nil
			end

			local var_133_17

			if not var_133_14 then
				local get_template = ExplosionUtils.get_template(var_133_14)

				if not get_template then
					var_133_17 = get_template.aoe.nav_mesh_effect
				end
			end

			local var_133_19

			if game_object_field_12 ~= NetworkConstants.invalid_game_object_id then
				var_133_19 = Managers.player:player_from_game_object_id(game_object_field_12)
			end

			local var_133_20

			if game_object_field_13 ~= NetworkConstants.invalid_game_object_id then
				var_133_20 = Managers.state.unit_storage:unit(game_object_field_13)
			end

			local tbl = {
				area_damage_system = {
					aoe_dot_damage = game_object_field,
					aoe_init_damage = game_object_field_2,
					aoe_dot_damage_interval = game_object_field_3,
					radius = game_object_field_4,
					life_time = game_object_field_5,
					invisible_unit = game_object_field_9,
					player_screen_effect_name = var_133_15,
					dot_effect_name = var_133_16,
					nav_mesh_effect = var_133_17,
					extra_dot_effect_name = var_133_13,
					area_damage_template = NetworkLookup.area_damage_templates[game_object_field_8],
					explosion_template_name = var_133_14,
					owner_player = var_133_19,
					source_attacker_unit = var_133_20
				}
			}

			return "aoe_unit", tbl
		end,
		thorn_bush_unit = function (arg_134_0, arg_134_1, arg_134_2, arg_134_3, arg_134_4)
			-- function 134
			local game_object_field = GameSession.game_object_field(arg_134_0, arg_134_1, "aoe_dot_damage")
			local game_object_field_2 = GameSession.game_object_field(arg_134_0, arg_134_1, "aoe_init_damage")
			local game_object_field_3 = GameSession.game_object_field(arg_134_0, arg_134_1, "aoe_dot_damage_interval")
			local game_object_field_4 = GameSession.game_object_field(arg_134_0, arg_134_1, "radius")
			local game_object_field_5 = GameSession.game_object_field(arg_134_0, arg_134_1, "life_time")
			local game_object_field_6 = GameSession.game_object_field(arg_134_0, arg_134_1, "player_screen_effect_name")
			local game_object_field_7 = GameSession.game_object_field(arg_134_0, arg_134_1, "dot_effect_name")
			local game_object_field_8 = GameSession.game_object_field(arg_134_0, arg_134_1, "area_damage_template")
			local game_object_field_9 = GameSession.game_object_field(arg_134_0, arg_134_1, "invisible_unit")
			local game_object_field_10 = GameSession.game_object_field(arg_134_0, arg_134_1, "extra_dot_effect_name")
			local game_object_field_11 = GameSession.game_object_field(arg_134_0, arg_134_1, "explosion_template_name")
			local game_object_field_12 = GameSession.game_object_field(arg_134_0, arg_134_1, "owner_player_id")
			local game_object_field_13 = GameSession.game_object_field(arg_134_0, arg_134_1, "spawn_animation_time")
			local game_object_field_14 = GameSession.game_object_field(arg_134_0, arg_134_1, "despawn_animation_time")
			local game_object_field_15 = GameSession.game_object_field(arg_134_0, arg_134_1, "slow_modifier")
			local var_134_15 = NetworkLookup.effects[game_object_field_10]

			if var_134_15 == "n/a" then
				var_134_15 = nil
			end

			local var_134_16 = NetworkLookup.explosion_templates[game_object_field_11]

			if var_134_16 == "n/a" then
				var_134_16 = nil
			end

			local var_134_17 = NetworkLookup.effects[game_object_field_6]

			if var_134_17 == "n/a" then
				var_134_17 = nil
			end

			local var_134_18 = NetworkLookup.effects[game_object_field_7]

			if var_134_18 == "n/a" then
				var_134_18 = nil
			end

			local var_134_19

			if not var_134_16 then
				local get_template = ExplosionUtils.get_template(var_134_16)

				if not get_template then
					var_134_19 = get_template.aoe.nav_mesh_effect
				end
			end

			local var_134_21

			if game_object_field_12 ~= NetworkConstants.invalid_game_object_id then
				var_134_21 = Managers.player:player_from_game_object_id(game_object_field_12)
			end

			local tbl = {
				area_damage_system = {
					aoe_dot_damage = game_object_field,
					aoe_init_damage = game_object_field_2,
					aoe_dot_damage_interval = game_object_field_3,
					radius = game_object_field_4,
					life_time = game_object_field_5,
					invisible_unit = game_object_field_9,
					player_screen_effect_name = var_134_17,
					dot_effect_name = var_134_18,
					nav_mesh_effect = var_134_19,
					extra_dot_effect_name = var_134_15,
					area_damage_template = NetworkLookup.area_damage_templates[game_object_field_8],
					explosion_template_name = var_134_16,
					owner_player = var_134_21,
					slow_modifier = game_object_field_15
				},
				props_system = {
					spawn_animation_time = game_object_field_13,
					despawn_animation_time = game_object_field_14
				}
			}

			return "thorn_bush_unit", tbl
		end,
		shadow_flare_light = function (arg_135_0, arg_135_1, arg_135_2, arg_135_3, arg_135_4)
			-- function 135
			local game_object_field = GameSession.game_object_field(arg_135_0, arg_135_1, "glow_time")
			local game_object_field_2 = GameSession.game_object_field(arg_135_0, arg_135_1, "owner_unit_id")
			local tbl = {
				darkness_system = {
					glow_time = game_object_field,
					owner_unit_id = game_object_field_2
				}
			}

			return "shadow_flare_light", tbl
		end,
		timed_explosion_unit = function (arg_136_0, arg_136_1, arg_136_2, arg_136_3, arg_136_4)
			-- function 136
			local game_object_field = GameSession.game_object_field(arg_136_0, arg_136_1, "follow_unit")
			local game_object_field_2 = GameSession.game_object_field(arg_136_0, arg_136_1, "explosion_template_name")
			local tbl = {
				area_damage_system = {
					follow_unit = Managers.state.unit_storage:unit(game_object_field),
					explosion_template_name = NetworkLookup.explosion_templates[game_object_field_2]
				}
			}

			return "timed_explosion_unit", tbl
		end,
		pickup_unit = function (arg_137_0, arg_137_1, arg_137_2, arg_137_3, arg_137_4)
			-- function 137
			local game_object_field = GameSession.game_object_field(arg_137_0, arg_137_1, "pickup_name")
			local game_object_field_2 = GameSession.game_object_field(arg_137_0, arg_137_1, "has_physics")
			local game_object_field_3 = GameSession.game_object_field(arg_137_0, arg_137_1, "spawn_type")
			local game_object_field_4 = GameSession.game_object_field(arg_137_0, arg_137_1, "dropped_by_breed")
			local tbl = {
				pickup_system = {
					pickup_name = NetworkLookup.pickup_names[game_object_field],
					has_physics = game_object_field_2,
					spawn_type = NetworkLookup.pickup_spawn_types[game_object_field_3],
					dropped_by_breed = NetworkLookup.breeds[game_object_field_4]
				}
			}

			return "pickup_unit", tbl
		end,
		limited_owned_pickup_unit = function (arg_138_0, arg_138_1, arg_138_2, arg_138_3, arg_138_4)
			-- function 138
			local game_object_field = GameSession.game_object_field(arg_138_0, arg_138_1, "pickup_name")
			local game_object_field_2 = GameSession.game_object_field(arg_138_0, arg_138_1, "has_physics")
			local game_object_field_3 = GameSession.game_object_field(arg_138_0, arg_138_1, "spawn_type")
			local game_object_field_4 = GameSession.game_object_field(arg_138_0, arg_138_1, "owner_peer_id")
			local game_object_field_5 = GameSession.game_object_field(arg_138_0, arg_138_1, "spawn_limit")
			local game_object_field_6 = GameSession.game_object_field(arg_138_0, arg_138_1, "material_settings_id")
			local tbl = {
				pickup_system = {
					pickup_name = NetworkLookup.pickup_names[game_object_field],
					has_physics = game_object_field_2,
					spawn_type = NetworkLookup.pickup_spawn_types[game_object_field_3],
					owner_peer_id = game_object_field_4,
					spawn_limit = game_object_field_5,
					material_settings_name = NetworkLookup.material_settings_templates[game_object_field_6]
				}
			}

			return "limited_owned_pickup_unit", tbl
		end,
		life_time_pickup_unit = function (arg_139_0, arg_139_1, arg_139_2, arg_139_3, arg_139_4)
			-- function 139
			local game_object_field = GameSession.game_object_field(arg_139_0, arg_139_1, "pickup_name")
			local game_object_field_2 = GameSession.game_object_field(arg_139_0, arg_139_1, "has_physics")
			local game_object_field_3 = GameSession.game_object_field(arg_139_0, arg_139_1, "spawn_type")
			local tbl = {
				pickup_system = {
					pickup_name = NetworkLookup.pickup_names[game_object_field],
					has_physics = game_object_field_2,
					spawn_type = NetworkLookup.pickup_spawn_types[game_object_field_3]
				}
			}

			return "life_time_pickup_unit", tbl
		end,
		objective_pickup_unit = function (arg_140_0, arg_140_1, arg_140_2, arg_140_3, arg_140_4)
			-- function 140
			local game_object_field = GameSession.game_object_field(arg_140_0, arg_140_1, "pickup_name")
			local game_object_field_2 = GameSession.game_object_field(arg_140_0, arg_140_1, "has_physics")
			local game_object_field_3 = GameSession.game_object_field(arg_140_0, arg_140_1, "spawn_type")
			local game_object_field_4 = GameSession.game_object_field(arg_140_0, arg_140_1, "always_show")
			local tbl = {
				pickup_system = {
					pickup_name = NetworkLookup.pickup_names[game_object_field],
					has_physics = game_object_field_2,
					spawn_type = NetworkLookup.pickup_spawn_types[game_object_field_3]
				},
				tutorial_system = {
					always_show = game_object_field_4
				}
			}

			return "objective_pickup_unit", tbl
		end,
		prop_unit = function (arg_141_0, arg_141_1, arg_141_2, arg_141_3, arg_141_4)
			-- function 141
			local str = "prop_unit"
			local var_141_1

			return str, var_141_1
		end,
		positioned_prop_unit = function (arg_142_0, arg_142_1, arg_142_2, arg_142_3, arg_142_4)
			-- function 142
			local str = "positioned_prop_unit"
			local var_142_1

			return str, var_142_1
		end,
		positioned_blob_unit = function (arg_143_0, arg_143_1, arg_143_2, arg_143_3, arg_143_4)
			-- function 143
			local str = "nurgle_liquid_blob_dynamic"
			local tbl = {
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

			return str, tbl
		end,
		destructible_objective_unit = function (arg_144_0, arg_144_1, arg_144_2, arg_144_3, arg_144_4)
			-- function 144
			local game_object_field = GameSession.game_object_field(arg_144_0, arg_144_1, "health")
			local str = "destructible_objective_unit"
			local tbl = {
				health_system = {
					health = game_object_field
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

			return str, tbl
		end,
		objective_unit = function (arg_145_0, arg_145_1, arg_145_2, arg_145_3, arg_145_4)
			-- function 145
			local str = "objective_unit"
			local var_145_1

			return str, var_145_1
		end,
		standard_unit = function (arg_146_0, arg_146_1, arg_146_2, arg_146_3, arg_146_4)
			-- function 146
			local game_object_field = GameSession.game_object_field(arg_146_0, arg_146_1, "health")
			local str = "standard_unit"
			local game_object_field_2 = GameSession.game_object_field(arg_146_0, arg_146_1, "standard_template_id")
			local game_object_field_3 = GameSession.game_object_field(arg_146_0, arg_146_1, "always_pingable")
			local tbl = {
				health_system = {
					health = game_object_field
				},
				death_system = {
					death_reaction_template = "standard",
					is_husk = true
				},
				ai_supplementary_system = {
					standard_template_name = NetworkLookup.standard_templates[game_object_field_2]
				},
				ping_system = {
					always_pingable = game_object_field_3
				}
			}

			return str, tbl
		end,
		overpowering_blob_unit = function (arg_147_0, arg_147_1, arg_147_2, arg_147_3, arg_147_4)
			-- function 147
			local game_object_field = GameSession.game_object_field(arg_147_0, arg_147_1, "health")
			local str = "overpowering_blob_unit"
			local tbl = {
				health_system = {
					health = game_object_field
				},
				death_system = {
					death_reaction_template = "lure_unit",
					is_husk = true
				}
			}

			return str, tbl
		end,
		network_synched_dummy_unit = function (arg_148_0, arg_148_1, arg_148_2, arg_148_3, arg_148_4)
			-- function 148
			local str = "network_synched_dummy_unit"
			local var_148_1

			return str, var_148_1
		end,
		position_synched_dummy_unit = function (arg_149_0, arg_149_1, arg_149_2, arg_149_3, arg_149_4)
			-- function 149
			local str = "position_synched_dummy_unit"
			local var_149_1

			return str, var_149_1
		end,
		buff_aoe_unit = function (arg_150_0, arg_150_1, arg_150_2, arg_150_3, arg_150_4)
			-- function 150
			local game_object_field = GameSession.game_object_field(arg_150_0, arg_150_1, "life_time")
			local game_object_field_2 = GameSession.game_object_field(arg_150_0, arg_150_1, "radius")
			local game_object_field_3 = GameSession.game_object_field(arg_150_0, arg_150_1, "owner_unit_id")
			local game_object_field_4 = GameSession.game_object_field(arg_150_0, arg_150_1, "source_unit_id")
			local game_object_field_5 = GameSession.game_object_field(arg_150_0, arg_150_1, "buff_template_id")
			local game_object_field_6 = GameSession.game_object_field(arg_150_0, arg_150_1, "sub_buff_id")
			local game_object_field_7 = GameSession.game_object_field(arg_150_0, arg_150_1, "side_id")
			local var_150_7

			if game_object_field_3 ~= NetworkConstants.invalid_game_object_id then
				var_150_7 = Managers.state.unit_storage:unit(game_object_field_3)
			end

			local var_150_8

			if game_object_field_4 ~= NetworkConstants.invalid_game_object_id then
				var_150_8 = Managers.state.unit_storage:unit(game_object_field_4)
			end

			local tbl = {
				buff_area_system = {
					life_time = game_object_field,
					radius = game_object_field_2,
					owner_unit = var_150_7,
					source_unit = var_150_8,
					sub_buff_template = BuffTemplates[NetworkLookup.buff_templates[game_object_field_5]].buffs[game_object_field_6],
					sub_buff_id = game_object_field_6,
					side_id = game_object_field_7
				}
			}

			return "buff_aoe_unit", tbl
		end,
		buff_unit = function (arg_151_0, arg_151_1, arg_151_2, arg_151_3, arg_151_4)
			-- function 151
			local tbl = {
				buff_system = {
					is_husk = true
				}
			}

			return "buff_unit", tbl
		end,
		ai_unit_dummy_sorcerer = function (arg_152_0, arg_152_1, arg_152_2, arg_152_3, arg_152_4)
			-- function 152
			local str = "ai_unit_dummy_sorcerer"
			local var_152_1

			return str, var_152_1
		end,
		thrown_weapon_unit = function (arg_153_0, arg_153_1, arg_153_2, arg_153_3, arg_153_4)
			-- function 153
			local str = "thrown_weapon_unit"
			local var_153_1

			return str, var_153_1
		end,
		interest_point_level_unit = function (arg_154_0, arg_154_1, arg_154_2, arg_154_3, arg_154_4)
			-- function 154
			local str = "interest_point_level"
			local var_154_1

			return str, var_154_1
		end,
		interest_point_unit = function (arg_155_0, arg_155_1, arg_155_2, arg_155_3, arg_155_4)
			-- function 155
			local str = "interest_point"
			local var_155_1

			return str, var_155_1
		end,
		sync_unit = function (arg_156_0, arg_156_1, arg_156_2, arg_156_3, arg_156_4)
			-- function 156
			error("We don't use this path for this kind of game object")
		end,
		rotating_hazard = function (arg_157_0, arg_157_1, arg_157_2, arg_157_3, arg_157_4)
			-- function 157
			local str = "rotating_hazard"
			local game_object_field = GameSession.game_object_field(arg_157_0, arg_157_1, "start_network_time")
			local game_object_field_2 = GameSession.game_object_field(arg_157_0, arg_157_1, "state")
			local tbl = {
				props_system = {
					start_network_time = game_object_field,
					state = game_object_field_2
				}
			}

			return str, tbl
		end,
		dialogue_node = function (arg_158_0, arg_158_1, arg_158_2, arg_158_3, arg_158_4)
			-- function 158
			local game_object_field = GameSession.game_object_field(arg_158_0, arg_158_1, "dialogue_profile")
			local game_object_field_2 = GameSession.game_object_field(arg_158_0, arg_158_1, "side_id")

			game_object_field_2 = not (game_object_field_2 > 0) or not game_object_field_2 or nil

			local tbl = {
				dialogue_system = {
					dialogue_profile = NetworkLookup.dialogue_profiles[game_object_field]
				},
				surrounding_aware_system = {
					side_id = game_object_field_2
				}
			}

			return "dialogue_node", tbl
		end,
		explosive_barrel_socket = function (arg_159_0, arg_159_1, arg_159_2, arg_159_3, arg_159_4)
			-- function 159
			local tbl = {}

			return "explosive_barrel_socket", tbl
		end
	},
	unit_from_gameobject_creator_func = function (self, arg_160_1, arg_160_2, arg_160_3)
		-- function 160
		local var_160_0

		if not arg_160_3.is_level_unit then
			local game_object_field = GameSession.game_object_field(arg_160_1, arg_160_2, "level_id")

			error("NetworkLookup.levels doesn´t exist. Talk to Anders E")

			local var_160_2 = NetworkLookup.levels[GameSession.game_object_field(arg_160_1, arg_160_2, "level_name_id")]
			local var_160_3 = GLOBAL.current_levels[var_160_2]

			var_160_0 = Level.unit_by_index(var_160_3, game_object_field)
		else
			local var_160_4 = NetworkLookup.husks[GameSession.game_object_field(arg_160_1, arg_160_2, "husk_unit")]
			local var_160_5
			local var_160_6

			if not arg_160_3.syncs_position then
				var_160_5 = GameSession.game_object_field(arg_160_1, arg_160_2, "position")
			end

			if not arg_160_3.syncs_rotation then
				var_160_6 = GameSession.game_object_field(arg_160_1, arg_160_2, "rotation")
			elseif not arg_160_3.syncs_yaw then
				local game_object_field_2 = GameSession.game_object_field(arg_160_1, arg_160_2, "yaw_rot")

				var_160_6 = Quaternion(Vector3.up(), game_object_field_2)
			elseif not arg_160_3.syncs_pitch_yaw then
				local game_object_field_3 = GameSession.game_object_field(arg_160_1, arg_160_2, "yaw")
				local game_object_field_4 = GameSession.game_object_field(arg_160_1, arg_160_2, "pitch")
				local var_160_10 = Quaternion(Vector3.up(), game_object_field_3)
				local var_160_11 = Quaternion(Vector3.right(), game_object_field_4)

				var_160_6 = Quaternion.multiply(var_160_10, var_160_11)
			end

			if not arg_160_3.has_uniform_scaling then
				local game_object_field_5 = GameSession.game_object_field(arg_160_1, arg_160_2, "uniform_scale")
				local var_160_13 = Vector3(game_object_field_5, game_object_field_5, game_object_field_5)
				local from_quaternion_position = Matrix4x4.from_quaternion_position(var_160_6, var_160_5)

				Matrix4x4.set_scale(from_quaternion_position, var_160_13)

				var_160_0 = self:spawn_local_unit(var_160_4, from_quaternion_position)

				return var_160_0
			end

			var_160_0 = self:spawn_local_unit(var_160_4, var_160_5, var_160_6)
		end

		return var_160_0
	end
}

DLCUtils.merge("game_object_initializers", tbl_2.initializers)
DLCUtils.merge("game_object_extractors", tbl_2.extractors)

local initializers = tbl_2.initializers

initializers.ai_true_flight_killable_projectile_unit = function (arg_161_0, arg_161_1, arg_161_2, arg_161_3)
	-- function 161
	local ai_true_flight_projectile_unit = initializers.ai_true_flight_projectile_unit(arg_161_0, arg_161_1, arg_161_2, arg_161_3)

	ai_true_flight_projectile_unit.health = ScriptUnit.has_extension(arg_161_0, "health_system"):get_max_health()
	ai_true_flight_projectile_unit.go_type = NetworkLookup.go_types.ai_true_flight_killable_projectile_unit

	return ai_true_flight_projectile_unit
end

local extractors = tbl_2.extractors

extractors.ai_true_flight_killable_projectile_unit = function (arg_162_0, arg_162_1, arg_162_2, arg_162_3, arg_162_4)
	-- function 162
	local ai_true_flight_projectile_unit, var_162_1, var_162_2 = extractors.ai_true_flight_projectile_unit(arg_162_0, arg_162_1, arg_162_2, arg_162_3, arg_162_4)
	local var_162_3 = TrueFlightTemplates[var_162_2]
	local game_object_field = GameSession.game_object_field(arg_162_0, arg_162_1, "health")

	var_162_1.health_system = {
		health = game_object_field
	}
	var_162_1.death_system = {
		is_husk = true,
		death_reaction_template = var_162_3.death_reaction_template
	}

	return "ai_true_flight_killable_projectile_unit", var_162_1
end

return tbl_2
