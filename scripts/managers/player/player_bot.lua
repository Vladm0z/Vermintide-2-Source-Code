-- chunkname: @scripts/managers/player/player_bot.lua

require("scripts/managers/player/bulldozer_player")

PlayerBot = class(PlayerBot, BulldozerPlayer)
EnergyData = EnergyData or {}

local var_0_0 = {
	bright_wizard = QuaternionBox(255, 255, 127, 0),
	witch_hunter = QuaternionBox(255, 255, 215, 0),
	dwarf_ranger = QuaternionBox(255, 125, 125, 200),
	wood_elf = QuaternionBox(255, 50, 205, 50),
	empire_soldier = QuaternionBox(255, 220, 20, 60)
}

function PlayerBot.init(arg_1_0, arg_1_1, arg_1_2, arg_1_3, arg_1_4, arg_1_5, arg_1_6, arg_1_7, arg_1_8, arg_1_9, arg_1_10)
	arg_1_0.player_name = arg_1_2
	arg_1_0.bot_profile = PlayerBots[arg_1_3]
	arg_1_0._profile_index = arg_1_5
	arg_1_0._career_index = arg_1_6
	arg_1_0.game_object_id = nil
	arg_1_0.owned_units = {}
	arg_1_0.bot_player = true
	arg_1_0.is_server = arg_1_4
	arg_1_0.peer_id = Network.peer_id()
	arg_1_0.color = var_0_0[arg_1_2]
	arg_1_0.viewport_name = arg_1_2
	arg_1_0.network_manager = arg_1_1

	local var_1_0 = SPProfiles[arg_1_0._profile_index]

	arg_1_0.character_name = Localize(var_1_0.character_name)
	arg_1_0._local_player_id = arg_1_7
	arg_1_0._telemetry_id = "Bot_" .. arg_1_7
	arg_1_0._unique_id = arg_1_8
	arg_1_0._ui_id = arg_1_9
	arg_1_0._account_id = arg_1_10
	arg_1_0._spawn_state = "despawned"
end

function PlayerBot.profile_index(arg_2_0)
	return arg_2_0._profile_index
end

function PlayerBot.career_index(arg_3_0)
	return arg_3_0._career_index
end

function PlayerBot.stats_id(arg_4_0)
	return arg_4_0._unique_id
end

function PlayerBot.ui_id(arg_5_0)
	return arg_5_0._ui_id
end

function PlayerBot.local_player_id(arg_6_0)
	return arg_6_0._local_player_id
end

function PlayerBot.unique_id(arg_7_0)
	return arg_7_0._unique_id
end

function PlayerBot.platform_id(arg_8_0)
	ferror("Not implemented")
end

function PlayerBot.type(arg_9_0)
	return "PlayerBot"
end

function PlayerBot.is_player_controlled(arg_10_0)
	return false
end

function PlayerBot.set_player_unit(arg_11_0, arg_11_1)
	arg_11_0.player_unit = arg_11_1
end

function PlayerBot.profile_display_name(arg_12_0)
	local var_12_0 = SPProfiles[arg_12_0._profile_index]

	return var_12_0 and var_12_0.display_name
end

function PlayerBot.despawn(arg_13_0)
	arg_13_0:_set_spawn_state("despawned")

	local var_13_0 = arg_13_0.player_unit

	if Unit.alive(var_13_0) then
		Managers.state.unit_spawner:mark_for_deletion(var_13_0)
		Managers.telemetry_events:player_despawned(arg_13_0)
	else
		print("player_bot was already despawned. Should not happen.")
	end
end

function PlayerBot.name(arg_14_0)
	return arg_14_0.character_name
end

function PlayerBot.telemetry_id(arg_15_0)
	return arg_15_0._telemetry_id
end

function PlayerBot.spawn(arg_16_0, arg_16_1, arg_16_2, arg_16_3, arg_16_4, arg_16_5, arg_16_6, arg_16_7, arg_16_8, arg_16_9, arg_16_10, arg_16_11, arg_16_12)
	local var_16_0 = arg_16_0._profile_index
	local var_16_1 = SPProfiles[var_16_0]
	local var_16_2 = arg_16_0:career_index()
	local var_16_3 = var_16_1.careers[var_16_2]
	local var_16_4 = true

	fassert(var_16_1, "[SpawnManager] Trying to spawn with profile %q that doesn't exist in %q.", var_16_0, "SPProfiles")

	local var_16_5 = Managers.state.entity:system("ai_system"):nav_world()
	local var_16_6 = Managers.state.difficulty:get_difficulty_settings().max_hp
	local var_16_7 = Managers.state.game_mode
	local var_16_8 = var_16_7:get_player_wounds(var_16_1)
	local var_16_9 = {}

	for iter_16_0, iter_16_1 in ipairs(var_16_3.character_state_list) do
		var_16_9[#var_16_9 + 1] = rawget(_G, iter_16_1)
	end

	local var_16_10 = var_16_7:get_initial_inventory(arg_16_6, arg_16_7, arg_16_8, arg_16_10, var_16_1)
	local var_16_11 = var_16_3.base_skin
	local var_16_12 = "default"
	local var_16_13 = var_16_3.name
	local var_16_14 = BackendUtils.get_loadout_item(var_16_13, "slot_skin", var_16_4)
	local var_16_15 = var_16_14 and var_16_14.data.name or var_16_11
	local var_16_16 = Cosmetics[var_16_15]
	local var_16_17 = BackendUtils.get_loadout_item(var_16_13, "slot_frame", var_16_4)
	local var_16_18 = var_16_17 and var_16_17.data.name or var_16_12
	local var_16_19 = OverchargeData[var_16_13] or {}
	local var_16_20 = EnergyData[var_16_13] or {}
	local var_16_21 = "default_weapon_pose_01"
	local var_16_22 = BackendUtils.get_loadout_item(var_16_13, "slot_pose")
	local var_16_23 = var_16_22 and var_16_22.data or var_16_22
	local var_16_24 = var_16_23 and var_16_23.name or var_16_21
	local var_16_25 = Managers.party:get_status_from_unique_id(arg_16_0._unique_id)
	local var_16_26 = Managers.party:get_party(var_16_25.party_id)
	local var_16_27 = Managers.state.side.side_by_party[var_16_26]
	local var_16_28 = var_16_3.breed or var_16_1.breed
	local var_16_29 = {
		ai_system = {
			player = arg_16_0,
			bot_profile = arg_16_0.bot_profile,
			nav_world = var_16_5
		},
		ai_bot_group_system = {
			initial_inventory = var_16_10,
			side = var_16_27
		},
		input_system = {
			player = arg_16_0
		},
		character_state_machine_system = {
			start_state = "standing",
			nav_world = var_16_5,
			character_state_class_list = var_16_9,
			player = arg_16_0
		},
		health_system = {
			player = arg_16_0,
			profile_index = var_16_0,
			career_index = var_16_2
		},
		status_system = {
			wounds = var_16_8,
			profile_id = var_16_0,
			player = arg_16_0,
			respawn_unit = arg_16_12
		},
		hit_reaction_system = {
			is_husk = false,
			hit_reaction_template = "player"
		},
		death_system = {
			death_reaction_template = "player",
			is_husk = false
		},
		inventory_system = {
			profile = var_16_1,
			initial_inventory = var_16_10,
			player = arg_16_0,
			ammo_percent = {
				slot_melee = arg_16_4,
				slot_ranged = arg_16_5
			}
		},
		locomotion_system = {
			player = arg_16_0
		},
		camera_system = {
			player = arg_16_0
		},
		dialogue_context_system = {
			profile = var_16_1
		},
		dialogue_system = {
			wwise_career_switch_group = "player_career",
			faction = "player",
			wwise_voice_switch_group = "character",
			profile = var_16_1,
			wwise_voice_switch_value = var_16_1.character_vo,
			wwise_career_switch_value = var_16_13
		},
		first_person_system = {
			profile = var_16_1,
			skin_name = var_16_15
		},
		ai_navigation_system = {
			nav_world = var_16_5
		},
		whereabouts_system = {
			player = arg_16_0
		},
		aim_system = {
			is_husk = false,
			template = "player"
		},
		attachment_system = {
			profile = var_16_1,
			player = arg_16_0
		},
		cosmetic_system = {
			profile = var_16_1,
			skin_name = var_16_15,
			frame_name = var_16_18,
			pose_name = var_16_24,
			player = arg_16_0
		},
		buff_system = {
			is_husk = false,
			breed = var_16_28
		},
		statistics_system = {
			template = "player",
			statistics_id = arg_16_0.peer_id
		},
		ai_slot_system = {
			profile_index = var_16_0
		},
		talent_system = {
			player = arg_16_0,
			profile_index = var_16_0
		},
		career_system = {
			player = arg_16_0,
			profile_index = var_16_0,
			career_index = var_16_2,
			ability_cooldown_percent_int = arg_16_9
		},
		overcharge_system = {
			overcharge_data = var_16_19
		},
		energy_system = {
			energy_data = var_16_20
		},
		aggro_system = {
			side = var_16_27
		},
		proximity_system = {
			side = var_16_27,
			breed = var_16_28
		},
		target_override_system = {
			side = var_16_27
		},
		ai_commander_system = {
			player = arg_16_0
		}
	}
	local var_16_30 = "player_bot_unit"
	local var_16_31 = var_16_16.third_person
	local var_16_32 = arg_16_0:spawn_unit(var_16_31, var_16_29, var_16_30, arg_16_1, arg_16_2)

	Managers.state.event:trigger("new_player_unit", arg_16_0, var_16_32, arg_16_0:unique_id())
	ScriptUnit.extension(var_16_32, "attachment_system"):show_attachments(true)
	Unit.set_data(var_16_32, "sound_character", var_16_3.sound_character)
	Unit.create_actor(var_16_32, "bot_collision", false)

	local var_16_33 = LevelHelper:current_level_settings().climate_type or "default"

	Unit.set_flow_variable(var_16_32, "climate_type", var_16_33)
	Unit.flow_event(var_16_32, "climate_type_set")

	if arg_16_0.is_server then
		ScriptUnit.extension(var_16_32, "health_system"):create_health_game_object()
	end

	arg_16_0:_set_spawn_state("spawned")
	Managers.telemetry_events:player_spawned(arg_16_0)

	return var_16_32
end

function PlayerBot.create_game_object(arg_17_0)
	local var_17_0 = {
		ping = 0,
		player_controlled = false,
		go_type = NetworkLookup.go_types.player,
		network_id = arg_17_0:network_id(),
		local_player_id = arg_17_0:local_player_id(),
		account_id = arg_17_0.peer_id
	}
	local var_17_1 = callback(arg_17_0, "cb_game_session_disconnect")

	arg_17_0.game_object_id = Managers.state.network:create_player_game_object("bot_player", var_17_0, var_17_1)

	arg_17_0:create_sync_data()
end

function PlayerBot.destroy(arg_18_0)
	if arg_18_0.is_server and arg_18_0.game_object_id then
		Managers.state.network:destroy_game_object(arg_18_0.game_object_id)
	end

	if arg_18_0._player_sync_data then
		arg_18_0._player_sync_data:destroy()
	end
end
