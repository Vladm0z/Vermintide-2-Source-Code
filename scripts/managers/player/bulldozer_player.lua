-- chunkname: @scripts/managers/player/bulldozer_player.lua

BulldozerPlayer = class(BulldozerPlayer, Player)

local EnergyData = EnergyData

EnergyData = EnergyData or {}
EnergyData = EnergyData

BulldozerPlayer.init = function (self, arg_1_1, arg_1_2, arg_1_3, arg_1_4, arg_1_5, arg_1_6, arg_1_7, arg_1_8, arg_1_9)
	-- function 1
	BulldozerPlayer.super.init(self, arg_1_1, arg_1_2, arg_1_3, arg_1_4, arg_1_5, arg_1_6)

	self.local_player = true
	self.game_object_id = nil
	self.camera_follow_unit = nil
	self.player_unit = nil
	self.peer_id = Network.peer_id()
	self._local_player_id = arg_1_6
	self._unique_id = arg_1_7
	self._ui_id = arg_1_8
	self._backend_id = arg_1_9
	self.is_server = arg_1_5

	Managers.music:register_active_player(arg_1_6)
	Managers.free_flight:register_player(arg_1_6)

	self._cached_name = nil
end

BulldozerPlayer.profile_index = function (self)
	-- function 2
	if not self._profile_index then
		return self._profile_index
	end

	return (self.network_manager.profile_synchronizer:profile_by_peer(self.peer_id, self._local_player_id))
end

BulldozerPlayer.set_profile_index = function (self, arg_3_1)
	-- function 3
	self._profile_index = arg_3_1
end

BulldozerPlayer.set_player_unit = function (self, arg_4_1)
	-- function 4
	self.player_unit = arg_4_1
end

BulldozerPlayer.type = function (arg_5_0)
	-- function 5
	return "BulldozerPlayer"
end

BulldozerPlayer.profile_display_name = function (self)
	-- function 6
	local profile_index = self:profile_index()
	local var_6_1 = SPProfiles[profile_index]

	return not var_6_1 and var_6_1.display_name
end

BulldozerPlayer.despawn = function (self)
	-- function 7
	if self._spawn_state == "despawned" then
		return
	end

	self:_set_spawn_state("despawned")

	for k, v in pairs(MoodSettings) do
		Managers.state.camera:clear_mood(k)
	end

	Managers.state.camera:set_additional_fov_multiplier(1)

	local has_extension = ScriptUnit.has_extension(self.player_unit, "first_person_system")

	if not has_extension then
		has_extension:play_hud_sound_event("Stop_ability_loop_turn_off")
	end

	local player_unit = self.player_unit

	if not Unit.alive(player_unit) then
		Managers.state.unit_spawner:mark_for_deletion(player_unit)
		Managers.telemetry_events:player_despawned(self)
	elseif not Boot.is_controlled_exit then
		Application.warning("bulldozer_player unit was already despawned. Should not happen.")
	end

	Managers.state.event:trigger("delete_limited_owned_pickups", self.peer_id)
end

BulldozerPlayer.career_index = function (self)
	-- function 8
	if not self._career_index then
		return self._career_index
	end

	local profile_by_peer, var_8_1 = self.network_manager.profile_synchronizer:profile_by_peer(self.peer_id, self._local_player_id)

	return var_8_1
end

BulldozerPlayer.set_career_index = function (self, arg_9_1)
	-- function 9
	self._career_index = arg_9_1
end

BulldozerPlayer.career_name = function (self)
	-- function 10
	local profile_index = self:profile_index()
	local var_10_1 = SPProfiles[profile_index]

	if not (not var_10_1 and var_10_1.display_name) then
		local career_index = self:career_index()

		return var_10_1.careers[career_index].name
	end
end

BulldozerPlayer.set_spawn_position_rotation = function (self, arg_11_1, arg_11_2)
	-- function 11
	self.spawn_position = Vector3Box(arg_11_1)
	self.spawn_rotation = QuaternionBox(arg_11_2)
end

BulldozerPlayer._spawn_unit_at_pos_rot = function (self, arg_12_1, arg_12_2, arg_12_3, arg_12_4, arg_12_5)
	-- function 12
	local var_12_0
	local unit_spawner = Managers.state.unit_spawner

	if not LEVEL_EDITOR_TEST then
		var_12_0 = unit_spawner:spawn_network_unit(arg_12_1, arg_12_3, arg_12_2, arg_12_4, arg_12_5)

		if not self.is_server then
			ScriptUnit.extension(var_12_0, "health_system"):sync_health_state()
		end
	else
		var_12_0 = unit_spawner:spawn_local_unit_with_extensions(arg_12_1, arg_12_3, arg_12_2, arg_12_4, arg_12_5)
	end

	return var_12_0
end

BulldozerPlayer.spawn_unit = function (self, arg_13_1, arg_13_2, arg_13_3, arg_13_4, arg_13_5)
	-- function 13
	if not LEVEL_EDITOR_TEST then
		local get_data = Application.get_data("camera")
		local translation = Matrix4x4.translation(get_data)
		local rotation = Matrix4x4.rotation(get_data)

		return self:_spawn_unit_at_pos_rot(arg_13_1, arg_13_2, arg_13_3, translation, rotation)
	else
		local forward = Quaternion.forward(arg_13_5)
		local look = Quaternion.look(Vector3.flat(forward), Vector3.up())

		return self:_spawn_unit_at_pos_rot(arg_13_1, arg_13_2, arg_13_3, arg_13_4, look)
	end
end

BulldozerPlayer.spawn = function (self, arg_14_1, arg_14_2, arg_14_3, arg_14_4, arg_14_5, arg_14_6, arg_14_7, arg_14_8, arg_14_9, arg_14_10, arg_14_11, arg_14_12)
	-- function 14
	local profile_index = self:profile_index()
	local var_14_1 = SPProfiles[profile_index]
	local careers = var_14_1.careers
	local career_index = self:career_index()

	fassert(var_14_1, "[SpawnManager] Trying to spawn with profile %q that doesn't exist in %q.", profile_index, "SPProfiles")

	local game_mode = Managers.state.game_mode
	local get_player_wounds = game_mode:get_player_wounds(var_14_1)

	if not self.spawn_position then
		arg_14_1 = self.spawn_position:unbox()
		self.spawn_position = nil
	end

	if not self.spawn_rotation then
		arg_14_2 = self.spawn_rotation:unbox()
		self.spawn_rotation = nil
	end

	local aim_template = var_14_1.aim_template

	aim_template = aim_template or "player"

	local get_initial_inventory = game_mode:get_initial_inventory(arg_14_6, arg_14_7, arg_14_8, arg_14_10, var_14_1)
	local display_name = var_14_1.display_name
	local var_14_9 = var_14_1.careers[career_index]
	local tbl = {}

	for i, v in ipairs(var_14_9.character_state_list) do
		tbl[#tbl + 1] = rawget(_G, v)
	end

	local base_skin = var_14_9.base_skin
	local str = "default"
	local name = var_14_9.name
	local get_loadout_item = BackendUtils.get_loadout_item(name, "slot_skin")

	get_loadout_item = get_loadout_item or BackendUtils.try_set_loadout_item(name, "slot_skin", base_skin)

	local name_2

	if not get_loadout_item then
		name_2 = get_loadout_item.data.name

		if not name_2 then
			-- Nothing
		end
	end

	name_2 = base_skin

	::label_14_0::

	local var_14_16 = Cosmetics[name_2]
	local get_loadout_item_2 = BackendUtils.get_loadout_item(name, "slot_frame")

	get_loadout_item_2 = get_loadout_item_2 or BackendUtils.try_set_loadout_item(name, "slot_frame", "frame_0000")

	local get_loadout_item_3 = BackendUtils.get_loadout_item(name, "slot_pose")

	get_loadout_item_3 = get_loadout_item_3 or BackendUtils.try_set_loadout_item(name, "slot_pose", "default_weapon_pose_01")

	local data

	if not get_loadout_item_3 then
		data = get_loadout_item_3.data

		if not data then
			-- Nothing
		end
	end

	data = nil

	do
		local name_3
	end

	::label_14_1::

	if not data then
		name_3 = data.name

		if not name_3 then
			-- Nothing
		end
	end

	name_3 = nil

	do
		local name_4
	end

	::label_14_2::

	if not get_loadout_item_2 then
		name_4 = get_loadout_item_2.data.name

		if not name_4 then
			-- Nothing
		end
	end

	name_4 = str

	::label_14_3::

	local var_14_22 = OverchargeData[name]

	var_14_22 = var_14_22 or {}

	local var_14_23 = EnergyData[name]

	var_14_23 = var_14_23 or {}

	local dialogue_faction = var_14_1.dialogue_faction

	dialogue_faction = dialogue_faction or "player"

	local get_status_from_unique_id = Managers.party:get_status_from_unique_id(self._unique_id)
	local game_mode_data = get_status_from_unique_id.game_mode_data
	local flag

	flag = get_status_from_unique_id.game_mode_data.first_spawn ~= nil or not true or false
	game_mode_data.first_spawn = flag

	local get_party = Managers.party:get_party(get_status_from_unique_id.party_id)
	local var_14_29 = Managers.state.side.side_by_party[get_party]
	local breed = var_14_9.breed

	breed = breed or var_14_1.breed

	local nav_world = Managers.state.entity:system("ai_system"):nav_world()
	local tbl_2 = {
		input_system = {
			player = self
		},
		character_state_machine_system = {
			start_state = "standing",
			character_state_class_list = tbl,
			player = self,
			nav_world = nav_world
		},
		health_system = {
			player = self,
			profile_index = profile_index,
			career_index = career_index
		},
		status_system = {
			wounds = get_player_wounds,
			profile_id = profile_index,
			player = self,
			respawn_unit = arg_14_12
		},
		hit_reaction_system = {
			is_husk = false,
			hit_reaction_template = "player",
			hit_effect_template = breed.hit_effect_template
		},
		death_system = {
			death_reaction_template = "player",
			is_husk = false
		},
		inventory_system = {
			profile = var_14_1,
			initial_inventory = get_initial_inventory,
			player = self,
			ammo_percent = {
				slot_melee = arg_14_4,
				slot_ranged = arg_14_5
			}
		},
		attachment_system = {
			profile = var_14_1,
			player = self
		},
		cosmetic_system = {
			profile = var_14_1,
			skin_name = name_2,
			frame_name = name_4,
			pose_name = name_3,
			player = self
		},
		locomotion_system = {
			player = self
		},
		camera_system = {
			player = self
		},
		first_person_system = {
			profile = var_14_1,
			skin_name = name_2
		},
		dialogue_context_system = {
			profile = var_14_1
		},
		dialogue_system = {
			local_player = true,
			wwise_career_switch_group = "player_career",
			wwise_voice_switch_group = "character",
			profile = var_14_1,
			faction = dialogue_faction,
			wwise_voice_switch_value = var_14_1.character_vo,
			wwise_career_switch_value = name
		},
		whereabouts_system = {
			player = self
		},
		aim_system = {
			is_husk = false,
			template = aim_template
		},
		buff_system = {
			is_husk = false,
			initial_buff_names = arg_14_11,
			breed = breed
		},
		statistics_system = {
			template = "player",
			statistics_id = self:telemetry_id()
		},
		ai_slot_system = {
			profile_index = profile_index
		},
		talent_system = {
			is_husk = false,
			player = self,
			profile_index = profile_index
		},
		career_system = {
			player = self,
			profile_index = profile_index,
			career_index = career_index,
			ability_cooldown_percent_int = arg_14_9
		},
		overcharge_system = {
			overcharge_data = var_14_22
		},
		energy_system = {
			energy_data = var_14_23
		},
		smart_targeting_system = {
			player = self,
			side = var_14_29
		},
		aggro_system = {
			side = var_14_29
		},
		proximity_system = {
			side = var_14_29,
			breed = breed
		},
		boon_system = {
			profile_index = profile_index
		},
		target_override_system = {
			side = var_14_29
		},
		ai_commander_system = {
			player = self
		},
		ping_system = {
			player = self
		}
	}

	if not Managers.mechanism:mechanism_setting("using_ghost_mode_system") then
		tbl_2.ghost_mode_system = {
			side_id = var_14_29.side_id,
			player = self
		}
	end

	local third_person = var_14_16.third_person
	local tbl_3 = {
		unit_name = third_person,
		extension_init_data = tbl_2,
		unit_template_name = var_14_1.unit_template_name
	}
	local spawn = Managers.state.spawn
	local spawn_unit = self:spawn_unit(third_person, tbl_2, var_14_1.unit_template_name, arg_14_1, arg_14_2)
	local player = Managers.player
	local world = spawn.world

	LevelHelper:set_flow_parameter(world, "local_player_profile_name", display_name)
	Unit.set_data(spawn_unit, "sound_character", var_14_9.sound_character)

	if not breed.starting_animation then
		local starting_animation = breed.starting_animation
		local extension = ScriptUnit.extension(spawn_unit, "first_person_system")

		CharacterStateHelper.play_animation_event_first_person(extension, starting_animation)
	end

	local career_voice_parameter = var_14_1.career_voice_parameter

	if not career_voice_parameter then
		local var_14_42 = var_14_1.career_voice_parameter_values[career_index]

		if not var_14_42 and not GameSettingsDevelopment.use_career_voice_pitch then
			local wwise_world = Wwise.wwise_world(world)

			WwiseWorld.set_global_parameter(wwise_world, career_voice_parameter, var_14_42)
		end
	end

	local flag_2 = true

	player:assign_unit_ownership(spawn_unit, self, flag_2)
	Managers.state.event:trigger("level_start_local_player_spawned", arg_14_3, spawn_unit, var_14_29, breed)
	Managers.telemetry_events:player_spawned(self)
	Managers.state.event:trigger("new_player_unit", self, spawn_unit, self:unique_id())

	if not breed.is_hero then
		Unit.create_actor(spawn_unit, "enemy_collision", false)
	else
		Unit.create_actor(spawn_unit, "human_collision", false)
	end

	if not self.is_server then
		ScriptUnit.extension(spawn_unit, "health_system"):create_health_game_object()
	end

	Managers.state.event:trigger("camera_teleported")
	self:_set_spawn_state("spawned")

	return spawn_unit
end

BulldozerPlayer.create_game_object = function (self)
	-- function 15
	local tbl = {
		ping = 0,
		player_controlled = true,
		go_type = NetworkLookup.go_types.player,
		network_id = self:network_id(),
		local_player_id = self:local_player_id()
	}
	local user_setting = Application.user_setting("clan_tag")

	user_setting = user_setting or "0"
	tbl.clan_tag = user_setting

	local account_id = Managers.account:account_id()

	account_id = account_id or "0"
	tbl.account_id = account_id

	local var_15_3 = callback(self, "cb_game_session_disconnect")

	self.game_object_id = self.network_manager:create_player_game_object("player", tbl, var_15_3)

	self:create_sync_data()
end

BulldozerPlayer.create_sync_data = function (self)
	-- function 16
	fassert(self._player_sync_data == nil)

	self._player_sync_data = PlayerSyncData:new(self, self.network_manager)
end

BulldozerPlayer.cb_game_session_disconnect = function (self)
	-- function 17
	self.game_object_id = nil
	self._player_sync_data = nil
end

BulldozerPlayer.game_object_destroyed = function (self)
	-- function 18
	printf("destroyed player game object with id %s callback", self.game_object_id)

	self.game_object_id = nil
end

BulldozerPlayer.network_id = function (self)
	-- function 19
	return self.peer_id
end

BulldozerPlayer.local_player_id = function (self)
	-- function 20
	return self._local_player_id
end

BulldozerPlayer.platform_id = function (self)
	-- function 21
	if IS_WINDOWS or not IS_LINUX then
		return self.peer_id
	else
		return Managers.account:account_id()
	end
end

BulldozerPlayer.profile_id = function (self)
	-- function 22
	return self._unique_id
end

BulldozerPlayer.ui_id = function (self)
	-- function 23
	return self._ui_id
end

BulldozerPlayer.unique_id = function (self)
	-- function 24
	return self._unique_id
end

BulldozerPlayer.stats_id = function (self)
	-- function 25
	return self._unique_id
end

BulldozerPlayer.telemetry_id = function (self)
	-- function 26
	local _backend_id = self._backend_id

	_backend_id = _backend_id or self._unique_id

	return _backend_id
end

BulldozerPlayer.is_player_controlled = function (arg_27_0)
	-- function 27
	return true
end

BulldozerPlayer.set_game_object_id = function (self, arg_28_1)
	-- function 28
	self.game_object_id = arg_28_1
end

BulldozerPlayer.sync_data_active = function (self)
	-- function 29
	local _player_sync_data = self._player_sync_data

	_player_sync_data = not _player_sync_data and self._player_sync_data:active()

	return _player_sync_data
end

BulldozerPlayer.set_data = function (self, arg_30_1, arg_30_2)
	-- function 30
	self._player_sync_data:set_data(arg_30_1, arg_30_2)
end

BulldozerPlayer.get_data = function (self, arg_31_1)
	-- function 31
	return self._player_sync_data:get_data(arg_31_1)
end

BulldozerPlayer.reevaluate_highest_difficulty = function (self)
	-- function 32
	self._player_sync_data:reevaluate_highest_difficulty()
end

BulldozerPlayer.name = function (self)
	-- function 33
	if not self._cached_name then
		return self._cached_name
	end

	local player_name = PlayerUtils.player_name(self.peer_id, Managers.state.network:lobby())
	local user_setting = Application.user_setting("clan_tag")

	if not (not user_setting and user_setting == "0") then
		local var_33_2 = tostring(Clans.clan_tag(user_setting))

		if var_33_2 ~= "" then
			player_name = var_33_2 .. "|" .. player_name
		end
	end

	self._cached_name = player_name

	return player_name
end

BulldozerPlayer.cached_name = function (self)
	-- function 34
	local _cached_name = self._cached_name

	_cached_name = _cached_name or self._debug_name

	return _cached_name
end

BulldozerPlayer.destroy = function (self)
	-- function 35
	if not self._player_sync_data then
		self._player_sync_data:destroy()
	end

	if not self.is_server then
		if not self.game_object_id then
			self.network_manager:destroy_game_object(self.game_object_id)
		end

		Managers.state.event:trigger("delete_limited_owned_pickups", self.peer_id)
	end

	Managers.free_flight:unregister_player(self:local_player_id())
	Managers.music:unregister_active_player(self._local_player_id)

	self._destroyed = true
end

BulldozerPlayer.best_aquired_power_level = function (arg_36_0)
	-- function 36
	return BackendUtils.best_aquired_power_level()
end

BulldozerPlayer.get_party = function (self)
	-- function 37
	local get_status_from_unique_id = Managers.party:get_status_from_unique_id(self._unique_id)

	return Managers.party:get_party(get_status_from_unique_id.party_id)
end

BulldozerPlayer.observed_unit = function (self)
	-- function 38
	return self._observed_unit
end

BulldozerPlayer.set_observed_unit = function (self, arg_39_1)
	-- function 39
	self._observed_unit = arg_39_1
end
