-- chunkname: @scripts/managers/player/bulldozer_player.lua

BulldozerPlayer = class(BulldozerPlayer, Player)
EnergyData = EnergyData or {}

BulldozerPlayer.init = function (arg_1_0, arg_1_1, arg_1_2, arg_1_3, arg_1_4, arg_1_5, arg_1_6, arg_1_7, arg_1_8, arg_1_9)
	BulldozerPlayer.super.init(arg_1_0, arg_1_1, arg_1_2, arg_1_3, arg_1_4, arg_1_5, arg_1_6)

	arg_1_0.local_player = true
	arg_1_0.game_object_id = nil
	arg_1_0.camera_follow_unit = nil
	arg_1_0.player_unit = nil
	arg_1_0.peer_id = Network.peer_id()
	arg_1_0._local_player_id = arg_1_6
	arg_1_0._unique_id = arg_1_7
	arg_1_0._ui_id = arg_1_8
	arg_1_0._backend_id = arg_1_9
	arg_1_0.is_server = arg_1_5

	Managers.music:register_active_player(arg_1_6)
	Managers.free_flight:register_player(arg_1_6)

	arg_1_0._cached_name = nil
end

BulldozerPlayer.profile_index = function (arg_2_0)
	if arg_2_0._profile_index then
		return arg_2_0._profile_index
	end

	return (arg_2_0.network_manager.profile_synchronizer:profile_by_peer(arg_2_0.peer_id, arg_2_0._local_player_id))
end

BulldozerPlayer.set_profile_index = function (arg_3_0, arg_3_1)
	arg_3_0._profile_index = arg_3_1
end

BulldozerPlayer.set_player_unit = function (arg_4_0, arg_4_1)
	arg_4_0.player_unit = arg_4_1
end

BulldozerPlayer.type = function (arg_5_0)
	return "BulldozerPlayer"
end

BulldozerPlayer.profile_display_name = function (arg_6_0)
	local var_6_0 = arg_6_0:profile_index()
	local var_6_1 = SPProfiles[var_6_0]

	return var_6_1 and var_6_1.display_name
end

BulldozerPlayer.despawn = function (arg_7_0)
	if arg_7_0._spawn_state == "despawned" then
		return
	end

	arg_7_0:_set_spawn_state("despawned")

	for iter_7_0, iter_7_1 in pairs(MoodSettings) do
		Managers.state.camera:clear_mood(iter_7_0)
	end

	Managers.state.camera:set_additional_fov_multiplier(1)

	local var_7_0 = ScriptUnit.has_extension(arg_7_0.player_unit, "first_person_system")

	if var_7_0 then
		var_7_0:play_hud_sound_event("Stop_ability_loop_turn_off")
	end

	local var_7_1 = arg_7_0.player_unit

	if Unit.alive(var_7_1) then
		Managers.state.unit_spawner:mark_for_deletion(var_7_1)
		Managers.telemetry_events:player_despawned(arg_7_0)
	elseif not Boot.is_controlled_exit then
		Application.warning("bulldozer_player unit was already despawned. Should not happen.")
	end

	Managers.state.event:trigger("delete_limited_owned_pickups", arg_7_0.peer_id)
end

BulldozerPlayer.career_index = function (arg_8_0)
	if arg_8_0._career_index then
		return arg_8_0._career_index
	end

	local var_8_0, var_8_1 = arg_8_0.network_manager.profile_synchronizer:profile_by_peer(arg_8_0.peer_id, arg_8_0._local_player_id)

	return var_8_1
end

BulldozerPlayer.set_career_index = function (arg_9_0, arg_9_1)
	arg_9_0._career_index = arg_9_1
end

BulldozerPlayer.career_name = function (arg_10_0)
	local var_10_0 = arg_10_0:profile_index()
	local var_10_1 = SPProfiles[var_10_0]

	if var_10_1 and var_10_1.display_name then
		local var_10_2 = arg_10_0:career_index()

		return var_10_1.careers[var_10_2].name
	end
end

BulldozerPlayer.set_spawn_position_rotation = function (arg_11_0, arg_11_1, arg_11_2)
	arg_11_0.spawn_position = Vector3Box(arg_11_1)
	arg_11_0.spawn_rotation = QuaternionBox(arg_11_2)
end

BulldozerPlayer._spawn_unit_at_pos_rot = function (arg_12_0, arg_12_1, arg_12_2, arg_12_3, arg_12_4, arg_12_5)
	local var_12_0
	local var_12_1 = Managers.state.unit_spawner

	if not LEVEL_EDITOR_TEST then
		var_12_0 = var_12_1:spawn_network_unit(arg_12_1, arg_12_3, arg_12_2, arg_12_4, arg_12_5)

		if arg_12_0.is_server then
			ScriptUnit.extension(var_12_0, "health_system"):sync_health_state()
		end
	else
		var_12_0 = var_12_1:spawn_local_unit_with_extensions(arg_12_1, arg_12_3, arg_12_2, arg_12_4, arg_12_5)
	end

	return var_12_0
end

BulldozerPlayer.spawn_unit = function (arg_13_0, arg_13_1, arg_13_2, arg_13_3, arg_13_4, arg_13_5)
	if LEVEL_EDITOR_TEST then
		local var_13_0 = Application.get_data("camera")
		local var_13_1 = Matrix4x4.translation(var_13_0)
		local var_13_2 = Matrix4x4.rotation(var_13_0)

		return arg_13_0:_spawn_unit_at_pos_rot(arg_13_1, arg_13_2, arg_13_3, var_13_1, var_13_2)
	else
		local var_13_3 = Quaternion.forward(arg_13_5)
		local var_13_4 = Quaternion.look(Vector3.flat(var_13_3), Vector3.up())

		return arg_13_0:_spawn_unit_at_pos_rot(arg_13_1, arg_13_2, arg_13_3, arg_13_4, var_13_4)
	end
end

BulldozerPlayer.spawn = function (arg_14_0, arg_14_1, arg_14_2, arg_14_3, arg_14_4, arg_14_5, arg_14_6, arg_14_7, arg_14_8, arg_14_9, arg_14_10, arg_14_11, arg_14_12)
	local var_14_0 = arg_14_0:profile_index()
	local var_14_1 = SPProfiles[var_14_0]
	local var_14_2 = var_14_1.careers
	local var_14_3 = arg_14_0:career_index()

	fassert(var_14_1, "[SpawnManager] Trying to spawn with profile %q that doesn't exist in %q.", var_14_0, "SPProfiles")

	local var_14_4 = Managers.state.game_mode
	local var_14_5 = var_14_4:get_player_wounds(var_14_1)

	if arg_14_0.spawn_position then
		arg_14_1 = arg_14_0.spawn_position:unbox()
		arg_14_0.spawn_position = nil
	end

	if arg_14_0.spawn_rotation then
		arg_14_2 = arg_14_0.spawn_rotation:unbox()
		arg_14_0.spawn_rotation = nil
	end

	local var_14_6 = var_14_1.aim_template or "player"
	local var_14_7 = var_14_4:get_initial_inventory(arg_14_6, arg_14_7, arg_14_8, arg_14_10, var_14_1)
	local var_14_8 = var_14_1.display_name
	local var_14_9 = var_14_1.careers[var_14_3]
	local var_14_10 = {}

	for iter_14_0, iter_14_1 in ipairs(var_14_9.character_state_list) do
		var_14_10[#var_14_10 + 1] = rawget(_G, iter_14_1)
	end

	local var_14_11 = var_14_9.base_skin
	local var_14_12 = "default"
	local var_14_13 = var_14_9.name
	local var_14_14 = BackendUtils.get_loadout_item(var_14_13, "slot_skin") or BackendUtils.try_set_loadout_item(var_14_13, "slot_skin", var_14_11)
	local var_14_15 = var_14_14 and var_14_14.data.name or var_14_11
	local var_14_16 = Cosmetics[var_14_15]
	local var_14_17 = BackendUtils.get_loadout_item(var_14_13, "slot_frame") or BackendUtils.try_set_loadout_item(var_14_13, "slot_frame", "frame_0000")
	local var_14_18 = BackendUtils.get_loadout_item(var_14_13, "slot_pose") or BackendUtils.try_set_loadout_item(var_14_13, "slot_pose", "default_weapon_pose_01")
	local var_14_19 = var_14_18 and var_14_18.data or nil
	local var_14_20 = var_14_19 and var_14_19.name or nil
	local var_14_21 = var_14_17 and var_14_17.data.name or var_14_12
	local var_14_22 = OverchargeData[var_14_13] or {}
	local var_14_23 = EnergyData[var_14_13] or {}
	local var_14_24 = var_14_1.dialogue_faction or "player"
	local var_14_25 = Managers.party:get_status_from_unique_id(arg_14_0._unique_id)

	var_14_25.game_mode_data.first_spawn = var_14_25.game_mode_data.first_spawn == nil and true or false

	local var_14_26 = Managers.party:get_party(var_14_25.party_id)
	local var_14_27 = Managers.state.side.side_by_party[var_14_26]
	local var_14_28 = var_14_9.breed or var_14_1.breed
	local var_14_29 = Managers.state.entity:system("ai_system"):nav_world()
	local var_14_30 = {
		input_system = {
			player = arg_14_0
		},
		character_state_machine_system = {
			start_state = "standing",
			character_state_class_list = var_14_10,
			player = arg_14_0,
			nav_world = var_14_29
		},
		health_system = {
			player = arg_14_0,
			profile_index = var_14_0,
			career_index = var_14_3
		},
		status_system = {
			wounds = var_14_5,
			profile_id = var_14_0,
			player = arg_14_0,
			respawn_unit = arg_14_12
		},
		hit_reaction_system = {
			is_husk = false,
			hit_reaction_template = "player",
			hit_effect_template = var_14_28.hit_effect_template
		},
		death_system = {
			death_reaction_template = "player",
			is_husk = false
		},
		inventory_system = {
			profile = var_14_1,
			initial_inventory = var_14_7,
			player = arg_14_0,
			ammo_percent = {
				slot_melee = arg_14_4,
				slot_ranged = arg_14_5
			}
		},
		attachment_system = {
			profile = var_14_1,
			player = arg_14_0
		},
		cosmetic_system = {
			profile = var_14_1,
			skin_name = var_14_15,
			frame_name = var_14_21,
			pose_name = var_14_20,
			player = arg_14_0
		},
		locomotion_system = {
			player = arg_14_0
		},
		camera_system = {
			player = arg_14_0
		},
		first_person_system = {
			profile = var_14_1,
			skin_name = var_14_15
		},
		dialogue_context_system = {
			profile = var_14_1
		},
		dialogue_system = {
			local_player = true,
			wwise_career_switch_group = "player_career",
			wwise_voice_switch_group = "character",
			profile = var_14_1,
			faction = var_14_24,
			wwise_voice_switch_value = var_14_1.character_vo,
			wwise_career_switch_value = var_14_13
		},
		whereabouts_system = {
			player = arg_14_0
		},
		aim_system = {
			is_husk = false,
			template = var_14_6
		},
		buff_system = {
			is_husk = false,
			initial_buff_names = arg_14_11,
			breed = var_14_28
		},
		statistics_system = {
			template = "player",
			statistics_id = arg_14_0:telemetry_id()
		},
		ai_slot_system = {
			profile_index = var_14_0
		},
		talent_system = {
			is_husk = false,
			player = arg_14_0,
			profile_index = var_14_0
		},
		career_system = {
			player = arg_14_0,
			profile_index = var_14_0,
			career_index = var_14_3,
			ability_cooldown_percent_int = arg_14_9
		},
		overcharge_system = {
			overcharge_data = var_14_22
		},
		energy_system = {
			energy_data = var_14_23
		},
		smart_targeting_system = {
			player = arg_14_0,
			side = var_14_27
		},
		aggro_system = {
			side = var_14_27
		},
		proximity_system = {
			side = var_14_27,
			breed = var_14_28
		},
		boon_system = {
			profile_index = var_14_0
		},
		target_override_system = {
			side = var_14_27
		},
		ai_commander_system = {
			player = arg_14_0
		},
		ping_system = {
			player = arg_14_0
		}
	}

	if Managers.mechanism:mechanism_setting("using_ghost_mode_system") then
		var_14_30.ghost_mode_system = {
			side_id = var_14_27.side_id,
			player = arg_14_0
		}
	end

	local var_14_31 = var_14_16.third_person
	local var_14_32 = {
		unit_name = var_14_31,
		extension_init_data = var_14_30,
		unit_template_name = var_14_1.unit_template_name
	}
	local var_14_33 = Managers.state.spawn
	local var_14_34 = arg_14_0:spawn_unit(var_14_31, var_14_30, var_14_1.unit_template_name, arg_14_1, arg_14_2)
	local var_14_35 = Managers.player
	local var_14_36 = var_14_33.world

	LevelHelper:set_flow_parameter(var_14_36, "local_player_profile_name", var_14_8)
	Unit.set_data(var_14_34, "sound_character", var_14_9.sound_character)

	if var_14_28.starting_animation then
		local var_14_37 = var_14_28.starting_animation
		local var_14_38 = ScriptUnit.extension(var_14_34, "first_person_system")

		CharacterStateHelper.play_animation_event_first_person(var_14_38, var_14_37)
	end

	local var_14_39 = var_14_1.career_voice_parameter

	if var_14_39 then
		local var_14_40 = var_14_1.career_voice_parameter_values[var_14_3]

		if var_14_40 and GameSettingsDevelopment.use_career_voice_pitch then
			local var_14_41 = Wwise.wwise_world(var_14_36)

			WwiseWorld.set_global_parameter(var_14_41, var_14_39, var_14_40)
		end
	end

	local var_14_42 = true

	var_14_35:assign_unit_ownership(var_14_34, arg_14_0, var_14_42)
	Managers.state.event:trigger("level_start_local_player_spawned", arg_14_3, var_14_34, var_14_27, var_14_28)
	Managers.telemetry_events:player_spawned(arg_14_0)
	Managers.state.event:trigger("new_player_unit", arg_14_0, var_14_34, arg_14_0:unique_id())

	if not var_14_28.is_hero then
		Unit.create_actor(var_14_34, "enemy_collision", false)
	else
		Unit.create_actor(var_14_34, "human_collision", false)
	end

	if arg_14_0.is_server then
		ScriptUnit.extension(var_14_34, "health_system"):create_health_game_object()
	end

	Managers.state.event:trigger("camera_teleported")
	arg_14_0:_set_spawn_state("spawned")

	return var_14_34
end

BulldozerPlayer.create_game_object = function (arg_15_0)
	local var_15_0 = {
		ping = 0,
		player_controlled = true,
		go_type = NetworkLookup.go_types.player,
		network_id = arg_15_0:network_id(),
		local_player_id = arg_15_0:local_player_id(),
		clan_tag = Application.user_setting("clan_tag") or "0",
		account_id = Managers.account:account_id() or "0"
	}
	local var_15_1 = callback(arg_15_0, "cb_game_session_disconnect")

	arg_15_0.game_object_id = arg_15_0.network_manager:create_player_game_object("player", var_15_0, var_15_1)

	arg_15_0:create_sync_data()
end

BulldozerPlayer.create_sync_data = function (arg_16_0)
	fassert(arg_16_0._player_sync_data == nil)

	arg_16_0._player_sync_data = PlayerSyncData:new(arg_16_0, arg_16_0.network_manager)
end

BulldozerPlayer.cb_game_session_disconnect = function (arg_17_0)
	arg_17_0.game_object_id = nil
	arg_17_0._player_sync_data = nil
end

BulldozerPlayer.game_object_destroyed = function (arg_18_0)
	printf("destroyed player game object with id %s callback", arg_18_0.game_object_id)

	arg_18_0.game_object_id = nil
end

BulldozerPlayer.network_id = function (arg_19_0)
	return arg_19_0.peer_id
end

BulldozerPlayer.local_player_id = function (arg_20_0)
	return arg_20_0._local_player_id
end

BulldozerPlayer.platform_id = function (arg_21_0)
	if IS_WINDOWS or IS_LINUX then
		return arg_21_0.peer_id
	else
		return Managers.account:account_id()
	end
end

BulldozerPlayer.profile_id = function (arg_22_0)
	return arg_22_0._unique_id
end

BulldozerPlayer.ui_id = function (arg_23_0)
	return arg_23_0._ui_id
end

BulldozerPlayer.unique_id = function (arg_24_0)
	return arg_24_0._unique_id
end

BulldozerPlayer.stats_id = function (arg_25_0)
	return arg_25_0._unique_id
end

BulldozerPlayer.telemetry_id = function (arg_26_0)
	return arg_26_0._backend_id or arg_26_0._unique_id
end

BulldozerPlayer.is_player_controlled = function (arg_27_0)
	return true
end

BulldozerPlayer.set_game_object_id = function (arg_28_0, arg_28_1)
	arg_28_0.game_object_id = arg_28_1
end

BulldozerPlayer.sync_data_active = function (arg_29_0)
	return arg_29_0._player_sync_data and arg_29_0._player_sync_data:active()
end

BulldozerPlayer.set_data = function (arg_30_0, arg_30_1, arg_30_2)
	arg_30_0._player_sync_data:set_data(arg_30_1, arg_30_2)
end

BulldozerPlayer.get_data = function (arg_31_0, arg_31_1)
	return arg_31_0._player_sync_data:get_data(arg_31_1)
end

BulldozerPlayer.reevaluate_highest_difficulty = function (arg_32_0)
	arg_32_0._player_sync_data:reevaluate_highest_difficulty()
end

BulldozerPlayer.name = function (arg_33_0)
	if arg_33_0._cached_name then
		return arg_33_0._cached_name
	end

	local var_33_0 = PlayerUtils.player_name(arg_33_0.peer_id, Managers.state.network:lobby())
	local var_33_1 = Application.user_setting("clan_tag")

	if var_33_1 and var_33_1 ~= "0" then
		local var_33_2 = tostring(Clans.clan_tag(var_33_1))

		if var_33_2 ~= "" then
			var_33_0 = var_33_2 .. "|" .. var_33_0
		end
	end

	arg_33_0._cached_name = var_33_0

	return var_33_0
end

BulldozerPlayer.cached_name = function (arg_34_0)
	return arg_34_0._cached_name or arg_34_0._debug_name
end

BulldozerPlayer.destroy = function (arg_35_0)
	if arg_35_0._player_sync_data then
		arg_35_0._player_sync_data:destroy()
	end

	if arg_35_0.is_server then
		if arg_35_0.game_object_id then
			arg_35_0.network_manager:destroy_game_object(arg_35_0.game_object_id)
		end

		Managers.state.event:trigger("delete_limited_owned_pickups", arg_35_0.peer_id)
	end

	Managers.free_flight:unregister_player(arg_35_0:local_player_id())
	Managers.music:unregister_active_player(arg_35_0._local_player_id)

	arg_35_0._destroyed = true
end

BulldozerPlayer.best_aquired_power_level = function (arg_36_0)
	return BackendUtils.best_aquired_power_level()
end

BulldozerPlayer.get_party = function (arg_37_0)
	local var_37_0 = Managers.party:get_status_from_unique_id(arg_37_0._unique_id)

	return Managers.party:get_party(var_37_0.party_id)
end

BulldozerPlayer.observed_unit = function (arg_38_0)
	return arg_38_0._observed_unit
end

BulldozerPlayer.set_observed_unit = function (arg_39_0, arg_39_1)
	arg_39_0._observed_unit = arg_39_1
end
