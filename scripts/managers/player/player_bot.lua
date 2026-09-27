-- chunkname: @scripts/managers/player/player_bot.lua

require("scripts/managers/player/bulldozer_player")

PlayerBot = class(PlayerBot, BulldozerPlayer)

local EnergyData = EnergyData

EnergyData = EnergyData or {}
EnergyData = EnergyData

local tbl = {
	bright_wizard = QuaternionBox(255, 255, 127, 0),
	witch_hunter = QuaternionBox(255, 255, 215, 0),
	dwarf_ranger = QuaternionBox(255, 125, 125, 200),
	wood_elf = QuaternionBox(255, 50, 205, 50),
	empire_soldier = QuaternionBox(255, 220, 20, 60)
}

PlayerBot.init = function (self, arg_1_1, arg_1_2, arg_1_3, arg_1_4, arg_1_5, arg_1_6, arg_1_7, arg_1_8, arg_1_9, arg_1_10)
	-- function 1
	self.player_name = arg_1_2
	self.bot_profile = PlayerBots[arg_1_3]
	self._profile_index = arg_1_5
	self._career_index = arg_1_6
	self.game_object_id = nil
	self.owned_units = {}
	self.bot_player = true
	self.is_server = arg_1_4
	self.peer_id = Network.peer_id()
	self.color = tbl[arg_1_2]
	self.viewport_name = arg_1_2
	self.network_manager = arg_1_1

	local var_1_0 = SPProfiles[self._profile_index]

	self.character_name = Localize(var_1_0.character_name)
	self._local_player_id = arg_1_7
	self._telemetry_id = "Bot_" .. arg_1_7
	self._unique_id = arg_1_8
	self._ui_id = arg_1_9
	self._account_id = arg_1_10
	self._spawn_state = "despawned"
end

PlayerBot.profile_index = function (self)
	-- function 2
	return self._profile_index
end

PlayerBot.career_index = function (self)
	-- function 3
	return self._career_index
end

PlayerBot.stats_id = function (self)
	-- function 4
	return self._unique_id
end

PlayerBot.ui_id = function (self)
	-- function 5
	return self._ui_id
end

PlayerBot.local_player_id = function (self)
	-- function 6
	return self._local_player_id
end

PlayerBot.unique_id = function (self)
	-- function 7
	return self._unique_id
end

PlayerBot.platform_id = function (arg_8_0)
	-- function 8
	ferror("Not implemented")
end

PlayerBot.type = function (arg_9_0)
	-- function 9
	return "PlayerBot"
end

PlayerBot.is_player_controlled = function (arg_10_0)
	-- function 10
	return false
end

PlayerBot.set_player_unit = function (self, arg_11_1)
	-- function 11
	self.player_unit = arg_11_1
end

PlayerBot.profile_display_name = function (self)
	-- function 12
	local var_12_0 = SPProfiles[self._profile_index]

	return not var_12_0 and var_12_0.display_name
end

PlayerBot.despawn = function (self)
	-- function 13
	self:_set_spawn_state("despawned")

	local player_unit = self.player_unit

	if not Unit.alive(player_unit) then
		Managers.state.unit_spawner:mark_for_deletion(player_unit)
		Managers.telemetry_events:player_despawned(self)
	else
		print("player_bot was already despawned. Should not happen.")
	end
end

PlayerBot.name = function (self)
	-- function 14
	return self.character_name
end

PlayerBot.telemetry_id = function (self)
	-- function 15
	return self._telemetry_id
end

PlayerBot.spawn = function (self, arg_16_1, arg_16_2, arg_16_3, arg_16_4, arg_16_5, arg_16_6, arg_16_7, arg_16_8, arg_16_9, arg_16_10, arg_16_11, arg_16_12)
	-- function 16
	local _profile_index = self._profile_index
	local var_16_1 = SPProfiles[_profile_index]
	local career_index = self:career_index()
	local var_16_3 = var_16_1.careers[career_index]
	local flag = true

	fassert(var_16_1, "[SpawnManager] Trying to spawn with profile %q that doesn't exist in %q.", _profile_index, "SPProfiles")

	local nav_world = Managers.state.entity:system("ai_system"):nav_world()
	local max_hp = Managers.state.difficulty:get_difficulty_settings().max_hp
	local game_mode = Managers.state.game_mode
	local get_player_wounds = game_mode:get_player_wounds(var_16_1)
	local tbl = {}

	for i, v in ipairs(var_16_3.character_state_list) do
		tbl[#tbl + 1] = rawget(_G, v)
	end

	local get_initial_inventory = game_mode:get_initial_inventory(arg_16_6, arg_16_7, arg_16_8, arg_16_10, var_16_1)
	local base_skin = var_16_3.base_skin
	local str = "default"
	local name = var_16_3.name
	local get_loadout_item = BackendUtils.get_loadout_item(name, "slot_skin", flag)
	local name_2

	if not get_loadout_item then
		name_2 = get_loadout_item.data.name

		if not name_2 then
			-- Nothing
		end
	end

	name_2 = base_skin

	::label_16_0::

	local var_16_16 = Cosmetics[name_2]
	local get_loadout_item_2 = BackendUtils.get_loadout_item(name, "slot_frame", flag)
	local name_3

	if not get_loadout_item_2 then
		name_3 = get_loadout_item_2.data.name

		if not name_3 then
			-- Nothing
		end
	end

	name_3 = str

	::label_16_1::

	local var_16_19 = OverchargeData[name]

	var_16_19 = var_16_19 or {}

	local var_16_20 = EnergyData[name]

	var_16_20 = var_16_20 or {}

	local str_2 = "default_weapon_pose_01"
	local get_loadout_item_3 = BackendUtils.get_loadout_item(name, "slot_pose")
	local data

	if not get_loadout_item_3 then
		data = get_loadout_item_3.data

		if not data then
			-- Nothing
		end
	end

	data = get_loadout_item_3

	do
		local name_4
	end

	::label_16_2::

	if not data then
		name_4 = data.name

		if not name_4 then
			-- Nothing
		end
	end

	name_4 = str_2

	::label_16_3::

	local get_status_from_unique_id = Managers.party:get_status_from_unique_id(self._unique_id)
	local get_party = Managers.party:get_party(get_status_from_unique_id.party_id)
	local var_16_27 = Managers.state.side.side_by_party[get_party]
	local breed = var_16_3.breed

	breed = breed or var_16_1.breed

	local tbl_2 = {
		ai_system = {
			player = self,
			bot_profile = self.bot_profile,
			nav_world = nav_world
		},
		ai_bot_group_system = {
			initial_inventory = get_initial_inventory,
			side = var_16_27
		},
		input_system = {
			player = self
		},
		character_state_machine_system = {
			start_state = "standing",
			nav_world = nav_world,
			character_state_class_list = tbl,
			player = self
		},
		health_system = {
			player = self,
			profile_index = _profile_index,
			career_index = career_index
		},
		status_system = {
			wounds = get_player_wounds,
			profile_id = _profile_index,
			player = self,
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
			initial_inventory = get_initial_inventory,
			player = self,
			ammo_percent = {
				slot_melee = arg_16_4,
				slot_ranged = arg_16_5
			}
		},
		locomotion_system = {
			player = self
		},
		camera_system = {
			player = self
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
			wwise_career_switch_value = name
		},
		first_person_system = {
			profile = var_16_1,
			skin_name = name_2
		},
		ai_navigation_system = {
			nav_world = nav_world
		},
		whereabouts_system = {
			player = self
		},
		aim_system = {
			is_husk = false,
			template = "player"
		},
		attachment_system = {
			profile = var_16_1,
			player = self
		},
		cosmetic_system = {
			profile = var_16_1,
			skin_name = name_2,
			frame_name = name_3,
			pose_name = name_4,
			player = self
		},
		buff_system = {
			is_husk = false,
			breed = breed
		},
		statistics_system = {
			template = "player",
			statistics_id = self.peer_id
		},
		ai_slot_system = {
			profile_index = _profile_index
		},
		talent_system = {
			player = self,
			profile_index = _profile_index
		},
		career_system = {
			player = self,
			profile_index = _profile_index,
			career_index = career_index,
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
			breed = breed
		},
		target_override_system = {
			side = var_16_27
		},
		ai_commander_system = {
			player = self
		}
	}
	local str_3 = "player_bot_unit"
	local third_person = var_16_16.third_person
	local spawn_unit = self:spawn_unit(third_person, tbl_2, str_3, arg_16_1, arg_16_2)

	Managers.state.event:trigger("new_player_unit", self, spawn_unit, self:unique_id())
	ScriptUnit.extension(spawn_unit, "attachment_system"):show_attachments(true)
	Unit.set_data(spawn_unit, "sound_character", var_16_3.sound_character)
	Unit.create_actor(spawn_unit, "bot_collision", false)

	local climate_type = LevelHelper:current_level_settings().climate_type

	climate_type = climate_type or "default"

	Unit.set_flow_variable(spawn_unit, "climate_type", climate_type)
	Unit.flow_event(spawn_unit, "climate_type_set")

	if not self.is_server then
		ScriptUnit.extension(spawn_unit, "health_system"):create_health_game_object()
	end

	self:_set_spawn_state("spawned")
	Managers.telemetry_events:player_spawned(self)

	return spawn_unit
end

PlayerBot.create_game_object = function (self)
	-- function 17
	local tbl = {
		ping = 0,
		player_controlled = false,
		go_type = NetworkLookup.go_types.player,
		network_id = self:network_id(),
		local_player_id = self:local_player_id(),
		account_id = self.peer_id
	}
	local var_17_1 = callback(self, "cb_game_session_disconnect")

	self.game_object_id = Managers.state.network:create_player_game_object("bot_player", tbl, var_17_1)

	self:create_sync_data()
end

PlayerBot.destroy = function (self)
	-- function 18
	if not self.is_server and not self.game_object_id then
		Managers.state.network:destroy_game_object(self.game_object_id)
	end

	if not self._player_sync_data then
		self._player_sync_data:destroy()
	end
end
