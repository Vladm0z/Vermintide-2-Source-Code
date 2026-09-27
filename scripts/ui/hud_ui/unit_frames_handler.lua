-- chunkname: @scripts/ui/hud_ui/unit_frames_handler.lua

require("scripts/ui/hud_ui/unit_frames_ui_utils")
require("scripts/settings/ui_player_portrait_frame_settings")
require("scripts/ui/hud_ui/unit_frame_ui")

local tbl = {
	slot_healthkit = true,
	slot_grenade = true,
	slot_potion = true
}
local tbl_2 = {
	slot_ranged = true,
	slot_melee = true
}
local num = 3

UnitFramesHandler = class(UnitFramesHandler)

UnitFramesHandler.init = function (self, arg_1_1, arg_1_2)
	-- function 1
	self._parent = arg_1_1
	self.ingame_ui_context = arg_1_2
	self.ingame_ui = arg_1_2.ingame_ui
	self.input_manager = arg_1_2.input_manager
	self.peer_id = arg_1_2.peer_id
	self.profile_synchronizer = arg_1_2.profile_synchronizer
	self.player_manager = arg_1_2.player_manager
	self.lobby = arg_1_2.network_lobby
	self.my_player = arg_1_2.player
	self.cleanui = arg_1_2.cleanui

	local network_transmit = Managers.state.network.network_transmit

	self.host_peer_id = network_transmit.server_peer_id or network_transmit.peer_id

	local party = Managers.party
	local num = 1
	local party_id = party:get_player_status(self.peer_id, num).party_id
	local get_party = party:get_party(party_id)
	local var_1_5 = Managers.state.side.side_by_party[get_party]

	self._party_id = party_id
	self._is_dark_pact = not var_1_5 and var_1_5:name() == "dark_pact"
	self.platform = PLATFORM
	self._unit_frames = {}
	self._unit_frame_index_by_ui_id = {}
	self.unit_frame_by_player = {}
	self._cached_versus_level = {}
	self._insignia_visibility = Application.user_setting("toggle_versus_level_in_all_game_modes")
	self._insignia_dirty_id = 1
	self._is_spectator = false
	self._spectated_player = nil
	self._spectated_player_unit = nil
	self._numeric_ui_enabled = false
	self._should_use_gamepad = false

	local event = Managers.state.event

	event:register(self, "add_respawn_counter_event", "add_respawn_counter_event")
	event:register(self, "on_spectator_target_changed", "on_spectator_target_changed")
	event:register(self, "on_game_options_changed", "on_game_options_changed")

	if not self._is_dark_pact then
		event:register(self, "add_damage_feedback_event", "add_damage_feedback_event")
	end

	self._current_frame_index = 1

	self:_create_player_unit_frame()
	self:_create_party_members_unit_frames()
	self:_align_party_member_frames()

	if not Application.user_setting("numeric_ui") then
		self:_update_numeric_ui()
	end
end

UnitFramesHandler.add_damage_feedback_event = function (self, arg_2_1, arg_2_2, arg_2_3, arg_2_4, arg_2_5, arg_2_6)
	-- function 2
	if not arg_2_2 then
		if not Application.user_setting("hud_damage_feedback_on_yourself") then
			return
		end
	elseif not Application.user_setting("hud_damage_feedback_on_teammates") then
		return
	end

	local var_2_0 = self.unit_frame_by_player[arg_2_4]

	if not var_2_0 then
		var_2_0.widget:add_damage_feedback(arg_2_1, arg_2_2, arg_2_3, arg_2_4, arg_2_5, arg_2_6)
	end
end

UnitFramesHandler.add_respawn_counter_event = function (self, arg_3_1, arg_3_2, arg_3_3, arg_3_4)
	-- function 3
	local var_3_0 = self.unit_frame_by_player[arg_3_1]

	if not (not var_3_0 and not (arg_3_3 > 0)) then
		var_3_0.widget:show_respawn_countdown(arg_3_1, arg_3_2, arg_3_3)
	end
end

UnitFramesHandler.on_spectator_target_changed = function (self, arg_4_1)
	-- function 4
	self._spectated_player_unit = arg_4_1
	self._spectated_player = Managers.player:owner(arg_4_1)
	self._is_spectator = true

	self:set_visible(false)

	local _unit_frames = self._unit_frames

	for i = 1, #_unit_frames do
		local var_4_1 = _unit_frames[i]

		table.clear(var_4_1.data)
	end

	self._unit_frames = {}
	self._unit_frame_index_by_ui_id = {}
	self.unit_frame_by_player = {}
	self._current_frame_index = 1

	local flag = Managers.state.side:get_side_from_player_unique_id(self._spectated_player:unique_id()):name() == "dark_pact"

	if flag ~= self._is_dark_pact then
		self._is_dark_pact = flag
	end

	self:_create_player_unit_frame()
	self:_create_party_members_unit_frames()
	self:_create_enemy_party_members_unit_frames()
	self:_align_party_member_frames()
	self:set_visible(true)
end

UnitFramesHandler.on_game_options_changed = function (self)
	-- function 5
	local _insignia_visibility = self._insignia_visibility
	local user_setting = Application.user_setting("toggle_versus_level_in_all_game_modes")

	if _insignia_visibility ~= user_setting then
		self._insignia_visibility = user_setting
		self._insignia_dirty_id = self._insignia_dirty_id + 1
	end
end

UnitFramesHandler.unit_frame_amount = function (self)
	-- function 6
	return #self._unit_frames
end

UnitFramesHandler.get_unit_widget = function (self, arg_7_1)
	-- function 7
	return self._unit_frames[arg_7_1].widget
end

local function fn(arg_8_0, arg_8_1)
	-- function 8
	return SPProfiles[arg_8_0].careers[arg_8_1].portrait_image
end

UnitFramesHandler._create_player_unit_frame = function (self)
	-- function 9
	local _spectated_player

	if not self._is_spectator then
		_spectated_player = self._spectated_player

		if not _spectated_player then
			-- Nothing
		end
	end

	_spectated_player = self.my_player

	::label_9_0::

	local ui_id = _spectated_player:ui_id()
	local tbl = {
		player_ui_id = ui_id,
		player = _spectated_player
	}

	tbl.own_player = true
	tbl.peer_id = _spectated_player:network_id()
	tbl.local_player_id = _spectated_player:local_player_id()

	local _get_unused_unit_frame, var_9_4 = self:_get_unused_unit_frame()

	_get_unused_unit_frame = _get_unused_unit_frame or self:_create_unit_frame_by_type("player")
	_get_unused_unit_frame.player_data = tbl
	_get_unused_unit_frame.sync = true
	self._unit_frames[1] = _get_unused_unit_frame
	self.unit_frame_by_player[_spectated_player] = _get_unused_unit_frame
	self._unit_frame_index_by_ui_id[ui_id] = 1

	return true
end

UnitFramesHandler._create_party_members_unit_frames = function (self)
	-- function 10
	local _unit_frames = self._unit_frames

	for i = 1, num do
		local _create_unit_frame_by_type = self:_create_unit_frame_by_type("team", i)

		_unit_frames[#_unit_frames + 1] = _create_unit_frame_by_type
	end

	return true
end

UnitFramesHandler._create_enemy_party_members_unit_frames = function (self)
	-- function 11
	local _unit_frames = self._unit_frames

	for i = 1, num + 1 do
		local _create_unit_frame_by_type = self:_create_unit_frame_by_type("enemy_team", i)

		_unit_frames[#_unit_frames + 1] = _create_unit_frame_by_type
	end

	return true
end

UnitFramesHandler._create_unit_frame_by_type = function (self, arg_12_1, arg_12_2)
	-- function 12
	local ingame_ui_context = self.ingame_ui_context
	local tbl = {}
	local tbl_2 = {}
	local tbl_3 = {}
	local _is_dark_pact = self._is_dark_pact
	local var_12_5

	if arg_12_1 == "team" then
		if not _is_dark_pact then
			var_12_5 = local_require("scripts/ui/hud_ui/dark_pact_team_member_unit_frame_ui_definitions")
		else
			var_12_5 = local_require("scripts/ui/hud_ui/team_member_unit_frame_ui_definitions")
		end
	elseif arg_12_1 == "player" then
		local is_device_active = self.input_manager:is_device_active("gamepad")

		is_device_active = is_device_active or not IS_WINDOWS

		local flag = (self.platform ~= "win32" or is_device_active or UISettings.use_gamepad_hud_layout == "always") and UISettings.use_gamepad_hud_layout ~= "never"

		if not _is_dark_pact then
			flag = false
		end

		if not flag then
			var_12_5 = local_require("scripts/ui/hud_ui/player_console_unit_frame_ui_definitions")
			tbl.gamepad_version = true
		elseif not _is_dark_pact then
			var_12_5 = local_require("scripts/ui/hud_ui/dark_pact_player_unit_frame_ui_definitions")
			tbl_3.is_player_darkpact = true
		else
			var_12_5 = local_require("scripts/ui/hud_ui/player_unit_frame_ui_definitions")
		end
	elseif not _is_dark_pact then
		var_12_5 = local_require("scripts/ui/hud_ui/dark_pact_team_member_unit_frame_ui_definitions")
	else
		var_12_5 = local_require("scripts/ui/hud_ui/team_member_unit_frame_ui_definitions")
	end

	tbl.data = tbl_2
	tbl.player_data = tbl_3
	tbl.definitions = var_12_5
	tbl.features_list = var_12_5.features_list
	tbl.widget_name_by_feature = var_12_5.widget_name_by_feature
	tbl.widget = UnitFrameUI:new(ingame_ui_context, var_12_5, tbl_2, arg_12_2, tbl_3, arg_12_1)

	return tbl
end

UnitFramesHandler._get_unused_unit_frame = function (self)
	-- function 13
	local _unit_frames = self._unit_frames

	for i = 1, #_unit_frames do
		local var_13_1 = _unit_frames[i]
		local player_data = var_13_1.player_data

		if not (player_data.peer_id or player_data.connecting_peer_id) then
			return var_13_1, i
		end
	end
end

UnitFramesHandler._get_unit_frame_by_connecting_peer_id = function (self, arg_14_1)
	-- function 14
	local _unit_frames = self._unit_frames

	for i = 1, #_unit_frames do
		local var_14_1 = _unit_frames[i]

		if var_14_1.player_data.connecting_peer_id == arg_14_1 then
			return var_14_1, i
		end
	end
end

UnitFramesHandler._reset_unit_frame = function (arg_15_0, arg_15_1)
	-- function 15
	arg_15_1.widget:reset()
	table.clear(arg_15_1.player_data)
	table.clear(arg_15_1.data)

	arg_15_1.sync = false
end

local tbl_3 = {}
local tbl_4 = {}
local tbl_5 = {}

UnitFramesHandler._handle_unit_frame_assigning = function (self)
	-- function 16
	local player_manager = self.player_manager
	local _unit_frame_index_by_ui_id = self._unit_frame_index_by_ui_id
	local num = 0
	local _spectated_player

	if not self._is_spectator then
		_spectated_player = self._spectated_player

		if not _spectated_player then
			-- Nothing
		end
	end

	_spectated_player = self.my_player

	::label_16_0::

	local network_id = _spectated_player:network_id()
	local local_player_id = _spectated_player:local_player_id()

	table.clear(tbl_3)
	table.clear(tbl_4)

	local get_party_from_player_id = Managers.party:get_party_from_player_id(network_id, local_player_id)
	local flag = false

	if not get_party_from_player_id then
		local occupied_slots = get_party_from_player_id.occupied_slots

		self._num_occupied_slots = #occupied_slots

		for i = 1, #occupied_slots do
			local var_16_9 = occupied_slots[i]
			local peer_id = var_16_9.peer_id
			local local_player_id_2 = var_16_9.local_player_id
			local player = player_manager:player(peer_id, local_player_id_2)

			if not player then
				local ui_id = player:ui_id()

				tbl_3[ui_id] = true
				tbl_4[peer_id] = true

				local flag_2 = player == _spectated_player

				if not flag_2 then
					if not _unit_frame_index_by_ui_id[ui_id] then
						local flag_3 = true

						if Managers.state.game_mode:game_mode_key() == "tutorial" then
							flag_3 = Managers.state.entity:system("play_go_tutorial_system"):bot_portrait_enabled(player)
						end

						if not flag_3 then
							local _get_unit_frame_by_connecting_peer_id, var_16_17 = self:_get_unit_frame_by_connecting_peer_id(peer_id)

							if not _get_unit_frame_by_connecting_peer_id then
								_get_unit_frame_by_connecting_peer_id, var_16_17 = self:_get_unused_unit_frame()
							end

							if not _get_unit_frame_by_connecting_peer_id then
								_unit_frame_index_by_ui_id[ui_id] = var_16_17

								table.clear(_get_unit_frame_by_connecting_peer_id.data)

								_get_unit_frame_by_connecting_peer_id.player_data = {
									player_ui_id = ui_id,
									player = player,
									own_player = flag_2,
									peer_id = peer_id,
									local_player_id = local_player_id_2
								}
								_get_unit_frame_by_connecting_peer_id.sync = true
								flag = true

								if not player:is_player_controlled() then
									num = num + 1
								end

								self.unit_frame_by_player[player] = _get_unit_frame_by_connecting_peer_id
							end
						end
					elseif not player:is_player_controlled() then
						num = num + 1
					end
				end
			end
		end
	end

	if not self._is_spectator then
		local var_16_18 = Managers.state.side.side_by_party[get_party_from_player_id]:get_enemy_sides()[1]
		local flag_4 = not var_16_18 and var_16_18.party

		if not flag_4 then
			local occupied_slots_2 = flag_4.occupied_slots

			self._num_enemy_occupied_slots = #occupied_slots_2

			for j = 1, #occupied_slots_2 do
				local var_16_21 = occupied_slots_2[j]
				local peer_id_2 = var_16_21.peer_id
				local local_player_id_3 = var_16_21.local_player_id
				local player_2 = player_manager:player(peer_id_2, local_player_id_3)

				if not player_2 then
					local ui_id_2 = player_2:ui_id()

					tbl_3[ui_id_2] = true
					tbl_4[peer_id_2] = true

					local flag_5 = player_2 == _spectated_player

					if not flag_5 then
						if not _unit_frame_index_by_ui_id[ui_id_2] then
							local flag_6 = true

							if Managers.state.game_mode:game_mode_key() == "tutorial" then
								flag_6 = Managers.state.entity:system("play_go_tutorial_system"):bot_portrait_enabled(player_2)
							end

							if not flag_6 then
								local _get_unit_frame_by_connecting_peer_id_2, var_16_29 = self:_get_unit_frame_by_connecting_peer_id(peer_id_2)

								if not _get_unit_frame_by_connecting_peer_id_2 then
									_get_unit_frame_by_connecting_peer_id_2, var_16_29 = self:_get_unused_unit_frame()
								end

								if not _get_unit_frame_by_connecting_peer_id_2 then
									_unit_frame_index_by_ui_id[ui_id_2] = var_16_29

									table.clear(_get_unit_frame_by_connecting_peer_id_2.data)

									local tbl = {
										player_ui_id = ui_id_2,
										player = player_2
									}

									tbl.is_enemy = true
									tbl.own_player = flag_5
									tbl.peer_id = peer_id_2
									tbl.local_player_id = local_player_id_3
									_get_unit_frame_by_connecting_peer_id_2.player_data = tbl
									_get_unit_frame_by_connecting_peer_id_2.sync = true
									flag = true

									if not player_2:is_player_controlled() then
										num = num + 1
									end

									self.unit_frame_by_player[player_2] = _get_unit_frame_by_connecting_peer_id_2
								end
							end
						elseif not player_2:is_player_controlled() then
							num = num + 1
						end
					end
				end
			end
		end
	end

	if Managers.mechanism:current_mechanism_name() ~= "adventure" or not self:_handle_connecting_peers(tbl_4, num) then
		flag = true
	end

	if not self:_cleanup_unused_unit_frames(tbl_3, tbl_5) then
		flag = true
	end

	if not flag then
		self:_align_party_member_frames()
	end
end

UnitFramesHandler._handle_connecting_peers = function (self, arg_17_1, arg_17_2)
	-- function 17
	local flag = false

	table.clear(tbl_5)

	if arg_17_2 < 3 then
		local get_players_in_party = Managers.party:get_players_in_party(self._party_id)

		if not get_players_in_party then
			for i = 1, #get_players_in_party do
				local peer_id = get_players_in_party[i].peer_id

				if not arg_17_1[peer_id] then
					if not self:_get_unit_frame_by_connecting_peer_id(peer_id) then
						local _get_unused_unit_frame, var_17_4 = self:_get_unused_unit_frame()

						if not _get_unused_unit_frame then
							self:_reset_unit_frame(_get_unused_unit_frame)

							_get_unused_unit_frame.player_data = {
								connecting_peer_id = peer_id
							}
							flag = true
						end
					end

					tbl_5[peer_id] = true
					arg_17_2 = arg_17_2 + 1

					if arg_17_2 == 3 then
						break
					end
				end
			end
		end
	end

	return flag
end

UnitFramesHandler._cleanup_unused_unit_frames = function (self, arg_18_1, arg_18_2)
	-- function 18
	local flag = false
	local _unit_frames = self._unit_frames

	for i = 2, #_unit_frames do
		local var_18_2 = _unit_frames[i]
		local player_data = var_18_2.player_data
		local player_ui_id = player_data.player_ui_id
		local connecting_peer_id = player_data.connecting_peer_id

		if not ((not connecting_peer_id and not not arg_18_2[connecting_peer_id] or not player_ui_id) and not arg_18_1[player_ui_id]) then
			self:_reset_unit_frame(var_18_2)

			flag = true

			if not player_ui_id then
				self._unit_frame_index_by_ui_id[player_ui_id] = nil
			end
		end
	end

	return flag
end

UnitFramesHandler._align_party_member_frames = function (self)
	-- function 19
	local num = -100
	local num_2 = 80
	local num_3 = -80
	local num_4 = 220

	if not self._is_dark_pact then
		num_4 = 180
	end

	local _is_visible = self._is_visible
	local num_5 = 0
	local num_6 = 0
	local _unit_frames = self._unit_frames

	for i = 2, #_unit_frames do
		local var_19_8 = _unit_frames[i]
		local widget = var_19_8.widget
		local player_data = var_19_8.player_data
		local peer_id = player_data.peer_id
		local connecting_peer_id = player_data.connecting_peer_id

		if peer_id or not connecting_peer_id or not _is_visible then
			local var_19_13
			local var_19_14

			if not player_data.is_enemy then
				var_19_13 = num_3
				var_19_14 = num - num_6 * num_4
				num_6 = num_6 + 1
				widget.ui_scenegraph.pivot.horizontal_alignment = "right"
			else
				var_19_13 = num_2
				var_19_14 = num - num_5 * num_4
				num_5 = num_5 + 1
			end

			widget:set_position(var_19_13, var_19_14)
			widget:set_visible(true)
		else
			widget:set_visible(false)
		end
	end
end

local function fn_2(arg_20_0, arg_20_1, arg_20_2)
	-- function 20
	local var_20_0

	if not arg_20_2.ammo_data then
		return
	end

	local ammo_hand = arg_20_2.ammo_data.ammo_hand

	if ammo_hand == "right" then
		var_20_0 = ScriptUnit.extension(arg_20_1, "ammo_system")
	elseif ammo_hand == "left" then
		var_20_0 = ScriptUnit.extension(arg_20_0, "ammo_system")
	else
		return
	end

	local ammo_count = var_20_0:ammo_count()
	local remaining_ammo = var_20_0:remaining_ammo()
	local using_single_clip = var_20_0:using_single_clip()
	local max_ammo = var_20_0:max_ammo()

	return ammo_count, remaining_ammo, max_ammo, using_single_clip
end

local function fn_3(arg_21_0)
	-- function 21
	local extension = ScriptUnit.extension(arg_21_0, "overcharge_system")
	local overcharge_fraction = extension:overcharge_fraction()
	local threshold_fraction = extension:threshold_fraction()
	local get_anim_blend_overcharge = extension:get_anim_blend_overcharge()

	return true, overcharge_fraction, threshold_fraction, get_anim_blend_overcharge
end

UnitFramesHandler._set_player_extensions = function (arg_22_0, arg_22_1, arg_22_2)
	-- function 22
	arg_22_1.extensions = {
		career = ScriptUnit.extension(arg_22_2, "career_system"),
		health = ScriptUnit.extension(arg_22_2, "health_system"),
		status = ScriptUnit.extension(arg_22_2, "status_system"),
		inventory = ScriptUnit.extension(arg_22_2, "inventory_system"),
		buff = ScriptUnit.extension(arg_22_2, "buff_system")
	}
	arg_22_1.player_unit = arg_22_2
end

local tbl_6 = {}

UnitFramesHandler._sync_player_stats = function (self, arg_23_1)
	-- function 23
	if not arg_23_1.sync then
		return
	end

	local player_data = arg_23_1.player_data
	local player = player_data.player

	if not player then
		return
	end

	local is_device_active = Managers.input:is_device_active("gamepad")
	local peer_id = player_data.peer_id
	local local_player_id = player_data.local_player_id
	local data = arg_23_1.data
	local widget = arg_23_1.widget
	local profile_synchronizer = self.profile_synchronizer

	if not player_data.extensions then
		local player_unit = player.player_unit

		if not player_unit then
			self:_set_player_extensions(player_data, player_unit)
		end
	end

	local profile_by_peer = profile_synchronizer:profile_by_peer(peer_id, local_player_id)

	if not profile_by_peer then
		return
	end

	local var_23_10
	local var_23_11
	local var_23_12
	local var_23_13
	local var_23_14
	local var_23_15
	local var_23_16
	local flag = false
	local player_unit_2 = player_data.player_unit

	if not player_unit_2 and Unit.alive(player_unit_2) or not player_data.extensions then
		player_data.extensions = nil
	end

	local go_id = Managers.state.unit_storage:go_id(player_unit_2)
	local game = Managers.state.network:game()
	local num = 0
	local extensions = player_data.extensions
	local var_23_23
	local var_23_24
	local var_23_25

	if not extensions then
		local career = extensions.career
		local buff = extensions.buff
		local status = extensions.status
		local health = extensions.health

		var_23_25 = extensions.inventory
		var_23_11 = not status:is_dead() and 0 and health:current_health_percent()
		var_23_10 = not status:is_dead() and 0 and health:current_permanent_health_percent()
		var_23_15 = status:is_wounded()
		var_23_13 = status:is_knocked_down() or not status:get_is_ledge_hanging() or var_23_11 > 0
		var_23_16 = status:is_ready_for_assisted_respawn()
		var_23_14 = status:is_grabbed_by_pack_master() or status:is_hanging_from_hook() or status:is_pounced_down() or status:is_grabbed_by_corruptor() or status:is_in_vortex() or status:is_grabbed_by_chaos_spawn()

		local num_buff_perk = buff:num_buff_perk("skaven_grimoire")
		local apply_buffs_to_value = buff:apply_buffs_to_value(PlayerUnitDamageSettings.GRIMOIRE_HEALTH_DEBUFF, "curse_protection")
		local num_buff_perk_2 = buff:num_buff_perk("twitch_grimoire")
		local apply_buffs_to_value_2 = buff:apply_buffs_to_value(PlayerUnitDamageSettings.GRIMOIRE_HEALTH_DEBUFF, "curse_protection")
		local num_buff_perk_3 = buff:num_buff_perk("slayer_curse")
		local apply_buffs_to_value_3 = buff:apply_buffs_to_value(PlayerUnitDamageSettings.SLAYER_CURSE_HEALTH_DEBUFF, "curse_protection")
		local num_buff_perk_4 = buff:num_buff_perk("mutator_curse")
		local value = WindSettings.light.curse_settings.value
		local get_difficulty_value_from_table = Managers.state.difficulty:get_difficulty_value_from_table(value)
		local apply_buffs_to_value_4 = buff:apply_buffs_to_value(get_difficulty_value_from_table, "curse_protection")
		local apply_buffs_to_value_5 = buff:apply_buffs_to_value(0, "health_curse")
		local apply_buffs_to_value_6 = buff:apply_buffs_to_value(apply_buffs_to_value_5, "curse_protection")

		var_23_12 = 1 + num_buff_perk * apply_buffs_to_value + num_buff_perk_2 * apply_buffs_to_value_2 + num_buff_perk_3 * apply_buffs_to_value_3 + num_buff_perk_4 * apply_buffs_to_value_4 + apply_buffs_to_value_6
		var_23_23 = var_23_25:equipment()
		profile_by_peer = career:profile_index()
		var_23_24 = career:career_index()

		if not game and not go_id then
			num = GameSession.game_object_field(game, go_id, "ability_percentage") or 0
		end
	else
		var_23_10 = 0
		var_23_11 = 0
		var_23_12 = 1
		var_23_13 = false
	end

	local flag_2 = var_23_11 <= 0
	local is_player_controlled = player:is_player_controlled()
	local crop_text = UIRenderer.crop_text(player:name(), 17)
	local get_player_level

	if not is_player_controlled then
		get_player_level = ExperienceSettings.get_player_level(player)

		if not get_player_level then
			get_player_level = ""
		end
	else
		get_player_level = UISettings.bots_level_display_text
	end

	local get_versus_player_level

	if not is_player_controlled then
		get_versus_player_level = ExperienceSettings.get_versus_player_level(player)

		if not get_versus_player_level then
			-- Nothing
		end

		get_versus_player_level = self._cached_versus_level[peer_id]

		if not get_versus_player_level then
			-- Nothing
		end
	end

	get_versus_player_level = 0

	::label_23_0::

	self._cached_versus_level[peer_id] = get_versus_player_level or self._cached_versus_level[peer_id]

	local var_23_47

	if not var_23_24 then
		var_23_47 = fn(profile_by_peer, var_23_24)

		if not var_23_47 then
			-- Nothing
		end
	end

	var_23_47 = "unit_frame_portrait_default"

	::label_23_1::

	local get_equipped_frame = Managers.state.entity:system("cosmetic_system"):get_equipped_frame(player_unit_2)
	local flag_3 = self.host_peer_id == peer_id
	local flag_4 = not is_player_controlled and flag_3
	local flag_5 = false
	local flag_6 = false

	if not var_23_13 then
		flag_5 = false
	elseif flag_2 or var_23_16 or not var_23_14 then
		flag_5 = true
	end

	local flag_7 = false
	local flag_8 = false
	local flag_9 = false

	if data.connecting ~= flag_6 then
		data.connecting = flag_6

		widget:set_connecting_status(flag_6)
	end

	if data.is_knocked_down ~= var_23_13 then
		data.is_knocked_down = var_23_13
		flag_8 = true
		flag_9 = true
	end

	if data.is_dead ~= flag_2 then
		data.is_dead = flag_2
		flag_9 = true
		flag_8 = true
	end

	if data.is_wounded ~= var_23_15 then
		data.is_wounded = var_23_15
		flag_9 = true
	end

	if data.needs_help ~= var_23_14 then
		data.needs_help = var_23_14
		flag_8 = true
	end

	if data.is_talking ~= flag then
		data.is_talking = flag

		widget:set_talking(flag)

		flag_7 = true
	end

	if data.show_icon ~= flag_5 then
		data.show_icon = flag_5

		widget:set_icon_visibility(flag_5)

		flag_7 = true
	end

	if data.assisted_respawn ~= var_23_16 then
		data.assisted_respawn = var_23_16
		flag_8 = true
		flag_7 = true
	end

	if data.show_health_bar ~= not var_23_16 then
		data.show_health_bar = not var_23_16
		flag_9 = true
		flag_7 = true
	end

	if data.portrait_texture ~= var_23_47 then
		data.portrait_texture = var_23_47

		widget:set_portrait(var_23_47)

		flag_7 = true
	end

	if not (data.frame_texture ~= get_equipped_frame or data.level_text == get_player_level) then
		data.frame_texture = get_equipped_frame
		data.level_text = get_player_level

		widget:set_portrait_frame(get_equipped_frame, get_player_level)

		flag_7 = true
	end

	if not (data.versus_level ~= get_versus_player_level or data.insignia_dirty_id == self._insignia_dirty_id) then
		data.versus_level = get_versus_player_level

		widget:set_versus_level(get_versus_player_level)

		data.insignia_dirty_id = self._insignia_dirty_id
	end

	if data.display_name ~= crop_text then
		data.display_name = crop_text

		widget:set_player_name(crop_text)

		flag_7 = true
	end

	if data.is_host ~= flag_4 then
		data.is_host = flag_4

		widget:set_host_status(flag_4)

		flag_7 = true
	end

	if not flag_8 then
		widget:set_portrait_status(var_23_13, var_23_14, flag_2, var_23_16)

		flag_7 = true
	end

	if not (data.total_health_percent ~= var_23_11 or data.active_percentage == var_23_12) then
		data.total_health_percent = var_23_11

		widget:set_total_health_percentage(var_23_11, var_23_12)

		flag_7 = true
	end

	if not (data.health_percent ~= var_23_10 or data.active_percentage == var_23_12) then
		data.health_percent = var_23_10

		widget:set_health_percentage(var_23_10, var_23_12)

		flag_7 = true
	end

	if data.active_percentage ~= var_23_12 then
		data.active_percentage = var_23_12

		widget:set_active_percentage(var_23_12)

		flag_7 = true
	end

	local features_list = arg_23_1.features_list

	features_list = features_list or tbl_6

	if not (not features_list.ability and data.ability_cooldown_percentage == num) then
		data.ability_cooldown_percentage = num

		widget:set_ability_percentage(1 - num)

		flag_7 = true
	end

	local equipment = features_list.equipment
	local weapons = features_list.weapons
	local ammo = features_list.ammo

	if not var_23_23 and equipment and weapons and not ammo then
		local wielded = var_23_23.wielded

		if not data.inventory_slots then
			data.inventory_slots = {}
		end

		local slots = InventorySettings.slots
		local inventory_slots = data.inventory_slots

		for i = 1, #slots do
			local name = slots[i].name
			local var_23_64 = var_23_23.slots[name]
			local flag_10 = not var_23_64 and var_23_64.item_data

			if not flag_10 and not flag_10.hide_in_frame_ui then
				local flag_11 = false
				local get_additional_items = var_23_25:get_additional_items(name)

				if not get_additional_items then
					for j = 1, #get_additional_items do
						local var_23_68 = get_additional_items[j]

						if not var_23_68.hide_in_frame_ui then
							flag_10 = var_23_68
							flag_11 = true

							break
						end
					end
				end

				if not flag_11 then
					flag_10 = nil
				end

				var_23_64 = nil
			end

			if not inventory_slots[name] then
				inventory_slots[name] = {}
			end

			local var_23_69 = inventory_slots[name]

			if not ammo and name ~= "slot_ranged" or not flag_10 then
				if not BackendUtils.get_item_template(flag_10).ammo_data then
					local num_2 = 1

					if not game and not go_id then
						num_2 = GameSession.game_object_field(game, go_id, "ammo_percentage")
					end

					if var_23_69.ammo_fraction ~= num_2 then
						widget:set_ammo_percentage(num_2)

						var_23_69.ammo_fraction = num_2
					end
				else
					widget:set_ammo_percentage(1)
				end
			end

			if not equipment and not tbl[name] then
				local flag_12

				flag_12 = not flag_10 and true and false

				local flag_13 = not flag_10 and flag_10.name
				local has_additional_item_slots = var_23_25:has_additional_item_slots(name)

				if not (var_23_69.visible ~= flag_12 or var_23_69.item_name == flag_13) then
					var_23_69.visible = flag_12
					var_23_69.item_name = flag_13

					local flag_14 = not has_additional_item_slots and self:_slot_item_count(var_23_25, name)

					if not (not flag_14 and not (flag_14 <= 1)) then
						has_additional_item_slots = nil
						flag_14 = nil
					end

					var_23_69.has_additional_item_slots = has_additional_item_slots
					var_23_69.item_count = flag_14

					widget:set_inventory_slot_data(name, flag_12, flag_10, flag_14)

					flag_7 = true
				elseif not var_23_69.visible and var_23_69.has_additional_item_slots and not has_additional_item_slots then
					local _slot_item_count = self:_slot_item_count(var_23_25, name)

					if not (not _slot_item_count and not (_slot_item_count <= 1)) then
						has_additional_item_slots = nil
						_slot_item_count = nil
					end

					if var_23_69.item_count ~= _slot_item_count then
						if not has_additional_item_slots then
							_slot_item_count = nil
						end

						var_23_69.has_additional_item_slots = has_additional_item_slots
						var_23_69.item_count = _slot_item_count

						widget:set_inventory_slot_data(name, flag_12, flag_10, _slot_item_count)

						flag_7 = true
					end
				end
			end

			if not weapons and not tbl_2[name] and not flag_10 then
				local name_2 = flag_10.name
				local hud_icon = flag_10.hud_icon
				local flag_15 = wielded == flag_10

				if not (var_23_69.is_wielded ~= flag_15 or var_23_69.item_name == name_2) then
					widget:set_equipped_weapon_info(name, flag_15, name_2, hud_icon)

					if var_23_69.item_name ~= name_2 then
						var_23_69.no_ammo = nil
					end

					var_23_69.is_wielded = flag_15
					var_23_69.item_name = name_2
					var_23_69.hud_icon = hud_icon
					flag_7 = true
				end

				local get_item_template = BackendUtils.get_item_template(flag_10)

				if not get_item_template.ammo_data and not var_23_64 then
					local var_23_80, var_23_81, var_23_82, var_23_83 = fn_2(var_23_64.left_unit_1p, var_23_64.right_unit_1p, get_item_template)

					if var_23_69.ammo_count ~= var_23_80 or var_23_69.remaining_ammo ~= var_23_81 or not var_23_69.no_ammo then
						var_23_69.ammo_count = var_23_80
						var_23_69.remaining_ammo = var_23_81
						var_23_69.no_ammo = nil

						widget:set_ammo_for_slot(name, var_23_80, var_23_81, var_23_83)

						flag_7 = true
					end

					if name ~= "slot_ranged" or not var_23_69.overcharge_fraction then
						widget:set_overcharge_percentage(false, nil)

						var_23_69.overcharge_fraction = nil
					end
				else
					if not var_23_69.no_ammo then
						var_23_69.no_ammo = true
						flag_7 = true

						widget:set_ammo_for_slot(name, nil, nil)

						var_23_69.overcharge_fraction = nil
						var_23_69.ammo_count = nil
						var_23_69.remaining_ammo = nil
					end

					if name == "slot_ranged" then
						local var_23_84, var_23_85, var_23_86 = fn_3(player_unit_2)

						if var_23_69.overcharge_fraction ~= var_23_85 then
							widget:set_overcharge_percentage(var_23_84, var_23_85)

							var_23_69.overcharge_fraction = var_23_85
						end
					end
				end
			end
		end
	end

	if not flag_9 then
		local flag_16 = var_23_16 or flag_2

		widget:set_health_bar_status(not flag_16, var_23_13, var_23_15)

		flag_7 = true
	end

	if not flag_7 then
		widget:set_dirty()

		if not self.cleanui then
			self.cleanui.dirty = true
		end
	end

	self.gamepad_was_active = is_device_active
end

UnitFramesHandler._slot_item_count = function (arg_24_0, arg_24_1, arg_24_2)
	-- function 24
	local num = 0
	local get_slot_data = arg_24_1:get_slot_data(arg_24_2)

	if not (not get_slot_data and get_slot_data.item_data.hide_in_frame_ui) then
		num = num + 1
	end

	local get_additional_items = arg_24_1:get_additional_items(arg_24_2)

	if not get_additional_items then
		for i = 1, #get_additional_items do
			if not get_additional_items[i].hide_in_frame_ui then
				num = num + 1
			end
		end
	end

	return num
end

UnitFramesHandler.destroy = function (self)
	-- function 25
	self.ui_animator = nil

	self:set_visible(false)

	local event = Managers.state.event

	event:unregister("add_respawn_counter_event", self)
	event:unregister("on_spectator_target_changed", self)
	event:unregister("on_game_options_changed", self)

	if not self._is_dark_pact then
		event:unregister("add_damage_feedback_event", self)
	end
end

UnitFramesHandler.set_visible = function (self, arg_26_1)
	-- function 26
	self._is_visible = arg_26_1

	local is_own_player_dead = self._parent:is_own_player_dead()

	is_own_player_dead = not is_own_player_dead and not self._is_spectator

	local _unit_frames = self._unit_frames

	for i = 1, #_unit_frames do
		local var_26_2 = _unit_frames[i]
		local player_data = var_26_2.player_data

		if not player_data.peer_id then
			if not (not is_own_player_dead and i ~= 1) then
				var_26_2.widget:set_visible(false)
			else
				var_26_2.widget:set_visible(arg_26_1)
			end
		elseif not player_data.connecting_peer_id then
			var_26_2.widget:set_visible(arg_26_1)
		elseif not arg_26_1 then
			var_26_2.widget:set_visible(false)
		end
	end
end

UnitFramesHandler.on_gamepad_activated = function (self)
	-- function 27
	local var_27_0 = self._unit_frames[1]

	if not var_27_0.gamepad_version then
		local is_visible = var_27_0.widget:is_visible()

		var_27_0.widget:destroy()

		local _create_unit_frame_by_type = self:_create_unit_frame_by_type("player")

		_create_unit_frame_by_type.player_data = var_27_0.player_data
		_create_unit_frame_by_type.sync = true
		self._unit_frames[1] = _create_unit_frame_by_type

		_create_unit_frame_by_type.widget:set_visible(is_visible)
	end
end

UnitFramesHandler.on_gamepad_deactivated = function (self)
	-- function 28
	local var_28_0 = self._unit_frames[1]

	if not var_28_0.gamepad_version then
		local is_visible = var_28_0.widget:is_visible()

		var_28_0.widget:destroy()

		local _create_unit_frame_by_type = self:_create_unit_frame_by_type("player")

		_create_unit_frame_by_type.player_data = var_28_0.player_data
		_create_unit_frame_by_type.sync = true
		self._unit_frames[1] = _create_unit_frame_by_type

		_create_unit_frame_by_type.widget:set_visible(is_visible)
	end
end

UnitFramesHandler.update = function (self, arg_29_1, arg_29_2)
	-- function 29
	if not self._is_visible then
		return
	end

	local is_own_player_dead = self._parent:is_own_player_dead()

	is_own_player_dead = not is_own_player_dead and not self._is_spectator

	local is_device_active = self.input_manager:is_device_active("gamepad")

	is_device_active = is_device_active or not IS_WINDOWS

	local flag = (is_device_active or UISettings.use_gamepad_hud_layout == "always") and UISettings.use_gamepad_hud_layout ~= "never"

	flag = not flag and not self._is_dark_pact

	if not flag then
		if not self.gamepad_active_last_frame then
			self.gamepad_active_last_frame = true

			self:on_gamepad_activated()
		end
	elseif not self.gamepad_active_last_frame then
		self.gamepad_active_last_frame = false

		self:on_gamepad_deactivated()
	end

	self:_handle_unit_frame_assigning()
	self:_sync_player_stats(self._unit_frames[self._current_frame_index])

	self._current_frame_index = 1 + self._current_frame_index % #self._unit_frames

	local _unit_frames = self._unit_frames

	for i = 1, #_unit_frames do
		local var_29_4 = _unit_frames[i]

		if not (i ~= 1 or is_own_player_dead) then
			var_29_4.widget:update(arg_29_1, arg_29_2)
		end

		if not var_29_4.widget:show_respawn_ui() then
			var_29_4.widget:update_respawn_countdown(arg_29_1, arg_29_2)
		end
	end

	if not self._update_resolution_modified then
		self:resolution_modified()
	end

	self:_draw(arg_29_1)
	self:_update_numeric_ui()
end

UnitFramesHandler.resolution_modified = function (self)
	-- function 30
	if not self._is_visible then
		self._update_resolution_modified = true

		return
	end

	local _unit_frames = self._unit_frames

	for i = 1, #_unit_frames do
		_unit_frames[i].widget:on_resolution_modified()
	end

	self._update_resolution_modified = nil
end

UnitFramesHandler._draw = function (self, arg_31_1)
	-- function 31
	if not self._is_visible then
		return
	end

	local _unit_frames = self._unit_frames

	for i = 1, #_unit_frames do
		_unit_frames[i].widget:draw(arg_31_1)
	end
end

UnitFramesHandler._update_numeric_ui = function (self)
	-- function 32
	local flag = false

	if self._numeric_ui_enabled ~= Application.user_setting("numeric_ui") then
		self._numeric_ui_enabled = Application.user_setting("numeric_ui")
		flag = true
	end

	if self._should_use_gamepad ~= Application.user_setting("use_gamepad_hud_layout") then
		self._should_use_gamepad = Application.user_setting("use_gamepad_hud_layout")
		flag = true
	end

	local _unit_frames = self._unit_frames

	for i = 1, #_unit_frames do
		local var_32_2 = _unit_frames[i]
		local widget = var_32_2.widget

		if not widget then
			return
		end

		local player_data = var_32_2.player_data
		local player = player_data.player

		if not player then
			return
		end

		local flag_2 = not player and player.player_unit
		local go_id = Managers.state.unit_storage:go_id(flag_2)
		local game = Managers.state.network:game()

		if not player_data and not self._numeric_ui_enabled and not game and not go_id then
			widget:update_numeric_ui_health(player_data)
			widget:update_numeric_ui_ammo(player_data)
			widget:update_numeric_ui_career_ability(game, go_id, player_data)
		end

		if flag or not widget.weapon_changed then
			widget:set_dirty()
		end
	end
end
