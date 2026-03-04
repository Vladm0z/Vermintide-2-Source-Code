-- chunkname: @scripts/ui/hud_ui/unit_frames_handler.lua

require("scripts/ui/hud_ui/unit_frames_ui_utils")
require("scripts/settings/ui_player_portrait_frame_settings")
require("scripts/ui/hud_ui/unit_frame_ui")

local var_0_0 = {
	slot_healthkit = true,
	slot_grenade = true,
	slot_potion = true
}
local var_0_1 = {
	slot_ranged = true,
	slot_melee = true
}
local var_0_2 = 3

UnitFramesHandler = class(UnitFramesHandler)

function UnitFramesHandler.init(arg_1_0, arg_1_1, arg_1_2)
	arg_1_0._parent = arg_1_1
	arg_1_0.ingame_ui_context = arg_1_2
	arg_1_0.ingame_ui = arg_1_2.ingame_ui
	arg_1_0.input_manager = arg_1_2.input_manager
	arg_1_0.peer_id = arg_1_2.peer_id
	arg_1_0.profile_synchronizer = arg_1_2.profile_synchronizer
	arg_1_0.player_manager = arg_1_2.player_manager
	arg_1_0.lobby = arg_1_2.network_lobby
	arg_1_0.my_player = arg_1_2.player
	arg_1_0.cleanui = arg_1_2.cleanui

	local var_1_0 = Managers.state.network.network_transmit

	arg_1_0.host_peer_id = var_1_0.server_peer_id or var_1_0.peer_id

	local var_1_1 = Managers.party
	local var_1_2 = 1
	local var_1_3 = var_1_1:get_player_status(arg_1_0.peer_id, var_1_2).party_id
	local var_1_4 = var_1_1:get_party(var_1_3)
	local var_1_5 = Managers.state.side.side_by_party[var_1_4]

	arg_1_0._party_id = var_1_3
	arg_1_0._is_dark_pact = var_1_5 and var_1_5:name() == "dark_pact"
	arg_1_0.platform = PLATFORM
	arg_1_0._unit_frames = {}
	arg_1_0._unit_frame_index_by_ui_id = {}
	arg_1_0.unit_frame_by_player = {}
	arg_1_0._cached_versus_level = {}
	arg_1_0._insignia_visibility = Application.user_setting("toggle_versus_level_in_all_game_modes")
	arg_1_0._insignia_dirty_id = 1
	arg_1_0._is_spectator = false
	arg_1_0._spectated_player = nil
	arg_1_0._spectated_player_unit = nil
	arg_1_0._numeric_ui_enabled = false
	arg_1_0._should_use_gamepad = false

	local var_1_6 = Managers.state.event

	var_1_6:register(arg_1_0, "add_respawn_counter_event", "add_respawn_counter_event")
	var_1_6:register(arg_1_0, "on_spectator_target_changed", "on_spectator_target_changed")
	var_1_6:register(arg_1_0, "on_game_options_changed", "on_game_options_changed")

	if arg_1_0._is_dark_pact then
		var_1_6:register(arg_1_0, "add_damage_feedback_event", "add_damage_feedback_event")
	end

	arg_1_0._current_frame_index = 1

	arg_1_0:_create_player_unit_frame()
	arg_1_0:_create_party_members_unit_frames()
	arg_1_0:_align_party_member_frames()

	if Application.user_setting("numeric_ui") then
		arg_1_0:_update_numeric_ui()
	end
end

function UnitFramesHandler.add_damage_feedback_event(arg_2_0, arg_2_1, arg_2_2, arg_2_3, arg_2_4, arg_2_5, arg_2_6)
	if arg_2_2 then
		if not Application.user_setting("hud_damage_feedback_on_yourself") then
			return
		end
	elseif not Application.user_setting("hud_damage_feedback_on_teammates") then
		return
	end

	local var_2_0 = arg_2_0.unit_frame_by_player[arg_2_4]

	if var_2_0 then
		var_2_0.widget:add_damage_feedback(arg_2_1, arg_2_2, arg_2_3, arg_2_4, arg_2_5, arg_2_6)
	end
end

function UnitFramesHandler.add_respawn_counter_event(arg_3_0, arg_3_1, arg_3_2, arg_3_3, arg_3_4)
	local var_3_0 = arg_3_0.unit_frame_by_player[arg_3_1]

	if var_3_0 and arg_3_3 > 0 then
		var_3_0.widget:show_respawn_countdown(arg_3_1, arg_3_2, arg_3_3)
	end
end

function UnitFramesHandler.on_spectator_target_changed(arg_4_0, arg_4_1)
	arg_4_0._spectated_player_unit = arg_4_1
	arg_4_0._spectated_player = Managers.player:owner(arg_4_1)
	arg_4_0._is_spectator = true

	arg_4_0:set_visible(false)

	local var_4_0 = arg_4_0._unit_frames

	for iter_4_0 = 1, #var_4_0 do
		local var_4_1 = var_4_0[iter_4_0]

		table.clear(var_4_1.data)
	end

	arg_4_0._unit_frames = {}
	arg_4_0._unit_frame_index_by_ui_id = {}
	arg_4_0.unit_frame_by_player = {}
	arg_4_0._current_frame_index = 1

	local var_4_2 = Managers.state.side:get_side_from_player_unique_id(arg_4_0._spectated_player:unique_id()):name() == "dark_pact"

	if var_4_2 ~= arg_4_0._is_dark_pact then
		arg_4_0._is_dark_pact = var_4_2
	end

	arg_4_0:_create_player_unit_frame()
	arg_4_0:_create_party_members_unit_frames()
	arg_4_0:_create_enemy_party_members_unit_frames()
	arg_4_0:_align_party_member_frames()
	arg_4_0:set_visible(true)
end

function UnitFramesHandler.on_game_options_changed(arg_5_0)
	local var_5_0 = arg_5_0._insignia_visibility
	local var_5_1 = Application.user_setting("toggle_versus_level_in_all_game_modes")

	if var_5_0 ~= var_5_1 then
		arg_5_0._insignia_visibility = var_5_1
		arg_5_0._insignia_dirty_id = arg_5_0._insignia_dirty_id + 1
	end
end

function UnitFramesHandler.unit_frame_amount(arg_6_0)
	return #arg_6_0._unit_frames
end

function UnitFramesHandler.get_unit_widget(arg_7_0, arg_7_1)
	return arg_7_0._unit_frames[arg_7_1].widget
end

local function var_0_3(arg_8_0, arg_8_1)
	return SPProfiles[arg_8_0].careers[arg_8_1].portrait_image
end

function UnitFramesHandler._create_player_unit_frame(arg_9_0)
	local var_9_0 = arg_9_0._is_spectator and arg_9_0._spectated_player or arg_9_0.my_player
	local var_9_1 = var_9_0:ui_id()
	local var_9_2 = {
		player_ui_id = var_9_1,
		player = var_9_0
	}

	var_9_2.own_player = true
	var_9_2.peer_id = var_9_0:network_id()
	var_9_2.local_player_id = var_9_0:local_player_id()

	local var_9_3, var_9_4 = arg_9_0:_get_unused_unit_frame()

	var_9_3 = var_9_3 or arg_9_0:_create_unit_frame_by_type("player")
	var_9_3.player_data = var_9_2
	var_9_3.sync = true
	arg_9_0._unit_frames[1] = var_9_3
	arg_9_0.unit_frame_by_player[var_9_0] = var_9_3
	arg_9_0._unit_frame_index_by_ui_id[var_9_1] = 1

	return true
end

function UnitFramesHandler._create_party_members_unit_frames(arg_10_0)
	local var_10_0 = arg_10_0._unit_frames

	for iter_10_0 = 1, var_0_2 do
		local var_10_1 = arg_10_0:_create_unit_frame_by_type("team", iter_10_0)

		var_10_0[#var_10_0 + 1] = var_10_1
	end

	return true
end

function UnitFramesHandler._create_enemy_party_members_unit_frames(arg_11_0)
	local var_11_0 = arg_11_0._unit_frames

	for iter_11_0 = 1, var_0_2 + 1 do
		local var_11_1 = arg_11_0:_create_unit_frame_by_type("enemy_team", iter_11_0)

		var_11_0[#var_11_0 + 1] = var_11_1
	end

	return true
end

function UnitFramesHandler._create_unit_frame_by_type(arg_12_0, arg_12_1, arg_12_2)
	local var_12_0 = arg_12_0.ingame_ui_context
	local var_12_1 = {}
	local var_12_2 = {}
	local var_12_3 = {}
	local var_12_4 = arg_12_0._is_dark_pact
	local var_12_5

	if arg_12_1 == "team" then
		if var_12_4 then
			var_12_5 = local_require("scripts/ui/hud_ui/dark_pact_team_member_unit_frame_ui_definitions")
		else
			var_12_5 = local_require("scripts/ui/hud_ui/team_member_unit_frame_ui_definitions")
		end
	elseif arg_12_1 == "player" then
		local var_12_6 = arg_12_0.input_manager:is_device_active("gamepad") or not IS_WINDOWS
		local var_12_7 = arg_12_0.platform ~= "win32" or (var_12_6 or UISettings.use_gamepad_hud_layout == "always") and UISettings.use_gamepad_hud_layout ~= "never"

		if var_12_4 then
			var_12_7 = false
		end

		if var_12_7 then
			var_12_5 = local_require("scripts/ui/hud_ui/player_console_unit_frame_ui_definitions")
			var_12_1.gamepad_version = true
		elseif var_12_4 then
			var_12_5 = local_require("scripts/ui/hud_ui/dark_pact_player_unit_frame_ui_definitions")
			var_12_3.is_player_darkpact = true
		else
			var_12_5 = local_require("scripts/ui/hud_ui/player_unit_frame_ui_definitions")
		end
	elseif var_12_4 then
		var_12_5 = local_require("scripts/ui/hud_ui/dark_pact_team_member_unit_frame_ui_definitions")
	else
		var_12_5 = local_require("scripts/ui/hud_ui/team_member_unit_frame_ui_definitions")
	end

	var_12_1.data = var_12_2
	var_12_1.player_data = var_12_3
	var_12_1.definitions = var_12_5
	var_12_1.features_list = var_12_5.features_list
	var_12_1.widget_name_by_feature = var_12_5.widget_name_by_feature
	var_12_1.widget = UnitFrameUI:new(var_12_0, var_12_5, var_12_2, arg_12_2, var_12_3, arg_12_1)

	return var_12_1
end

function UnitFramesHandler._get_unused_unit_frame(arg_13_0)
	local var_13_0 = arg_13_0._unit_frames

	for iter_13_0 = 1, #var_13_0 do
		local var_13_1 = var_13_0[iter_13_0]
		local var_13_2 = var_13_1.player_data

		if not var_13_2.peer_id and not var_13_2.connecting_peer_id then
			return var_13_1, iter_13_0
		end
	end
end

function UnitFramesHandler._get_unit_frame_by_connecting_peer_id(arg_14_0, arg_14_1)
	local var_14_0 = arg_14_0._unit_frames

	for iter_14_0 = 1, #var_14_0 do
		local var_14_1 = var_14_0[iter_14_0]

		if var_14_1.player_data.connecting_peer_id == arg_14_1 then
			return var_14_1, iter_14_0
		end
	end
end

function UnitFramesHandler._reset_unit_frame(arg_15_0, arg_15_1)
	arg_15_1.widget:reset()
	table.clear(arg_15_1.player_data)
	table.clear(arg_15_1.data)

	arg_15_1.sync = false
end

local var_0_4 = {}
local var_0_5 = {}
local var_0_6 = {}

function UnitFramesHandler._handle_unit_frame_assigning(arg_16_0)
	local var_16_0 = arg_16_0.player_manager
	local var_16_1 = arg_16_0._unit_frame_index_by_ui_id
	local var_16_2 = 0
	local var_16_3 = arg_16_0._is_spectator and arg_16_0._spectated_player or arg_16_0.my_player
	local var_16_4 = var_16_3:network_id()
	local var_16_5 = var_16_3:local_player_id()

	table.clear(var_0_4)
	table.clear(var_0_5)

	local var_16_6 = Managers.party:get_party_from_player_id(var_16_4, var_16_5)
	local var_16_7 = false

	if var_16_6 then
		local var_16_8 = var_16_6.occupied_slots

		arg_16_0._num_occupied_slots = #var_16_8

		for iter_16_0 = 1, #var_16_8 do
			local var_16_9 = var_16_8[iter_16_0]
			local var_16_10 = var_16_9.peer_id
			local var_16_11 = var_16_9.local_player_id
			local var_16_12 = var_16_0:player(var_16_10, var_16_11)

			if var_16_12 then
				local var_16_13 = var_16_12:ui_id()

				var_0_4[var_16_13] = true
				var_0_5[var_16_10] = true

				local var_16_14 = var_16_12 == var_16_3

				if not var_16_14 then
					if not var_16_1[var_16_13] then
						local var_16_15 = true

						if Managers.state.game_mode:game_mode_key() == "tutorial" then
							var_16_15 = Managers.state.entity:system("play_go_tutorial_system"):bot_portrait_enabled(var_16_12)
						end

						if var_16_15 then
							local var_16_16, var_16_17 = arg_16_0:_get_unit_frame_by_connecting_peer_id(var_16_10)

							if not var_16_16 then
								var_16_16, var_16_17 = arg_16_0:_get_unused_unit_frame()
							end

							if var_16_16 then
								var_16_1[var_16_13] = var_16_17

								table.clear(var_16_16.data)

								var_16_16.player_data = {
									player_ui_id = var_16_13,
									player = var_16_12,
									own_player = var_16_14,
									peer_id = var_16_10,
									local_player_id = var_16_11
								}
								var_16_16.sync = true
								var_16_7 = true

								if var_16_12:is_player_controlled() then
									var_16_2 = var_16_2 + 1
								end

								arg_16_0.unit_frame_by_player[var_16_12] = var_16_16
							end
						end
					elseif var_16_12:is_player_controlled() then
						var_16_2 = var_16_2 + 1
					end
				end
			end
		end
	end

	if arg_16_0._is_spectator then
		local var_16_18 = Managers.state.side.side_by_party[var_16_6]:get_enemy_sides()[1]
		local var_16_19 = var_16_18 and var_16_18.party

		if var_16_19 then
			local var_16_20 = var_16_19.occupied_slots

			arg_16_0._num_enemy_occupied_slots = #var_16_20

			for iter_16_1 = 1, #var_16_20 do
				local var_16_21 = var_16_20[iter_16_1]
				local var_16_22 = var_16_21.peer_id
				local var_16_23 = var_16_21.local_player_id
				local var_16_24 = var_16_0:player(var_16_22, var_16_23)

				if var_16_24 then
					local var_16_25 = var_16_24:ui_id()

					var_0_4[var_16_25] = true
					var_0_5[var_16_22] = true

					local var_16_26 = var_16_24 == var_16_3

					if not var_16_26 then
						if not var_16_1[var_16_25] then
							local var_16_27 = true

							if Managers.state.game_mode:game_mode_key() == "tutorial" then
								var_16_27 = Managers.state.entity:system("play_go_tutorial_system"):bot_portrait_enabled(var_16_24)
							end

							if var_16_27 then
								local var_16_28, var_16_29 = arg_16_0:_get_unit_frame_by_connecting_peer_id(var_16_22)

								if not var_16_28 then
									var_16_28, var_16_29 = arg_16_0:_get_unused_unit_frame()
								end

								if var_16_28 then
									var_16_1[var_16_25] = var_16_29

									table.clear(var_16_28.data)

									local var_16_30 = {
										player_ui_id = var_16_25,
										player = var_16_24
									}

									var_16_30.is_enemy = true
									var_16_30.own_player = var_16_26
									var_16_30.peer_id = var_16_22
									var_16_30.local_player_id = var_16_23
									var_16_28.player_data = var_16_30
									var_16_28.sync = true
									var_16_7 = true

									if var_16_24:is_player_controlled() then
										var_16_2 = var_16_2 + 1
									end

									arg_16_0.unit_frame_by_player[var_16_24] = var_16_28
								end
							end
						elseif var_16_24:is_player_controlled() then
							var_16_2 = var_16_2 + 1
						end
					end
				end
			end
		end
	end

	if Managers.mechanism:current_mechanism_name() == "adventure" and arg_16_0:_handle_connecting_peers(var_0_5, var_16_2) then
		var_16_7 = true
	end

	if arg_16_0:_cleanup_unused_unit_frames(var_0_4, var_0_6) then
		var_16_7 = true
	end

	if var_16_7 then
		arg_16_0:_align_party_member_frames()
	end
end

function UnitFramesHandler._handle_connecting_peers(arg_17_0, arg_17_1, arg_17_2)
	local var_17_0 = false

	table.clear(var_0_6)

	if arg_17_2 < 3 then
		local var_17_1 = Managers.party:get_players_in_party(arg_17_0._party_id)

		if var_17_1 then
			for iter_17_0 = 1, #var_17_1 do
				local var_17_2 = var_17_1[iter_17_0].peer_id

				if not arg_17_1[var_17_2] then
					if not arg_17_0:_get_unit_frame_by_connecting_peer_id(var_17_2) then
						local var_17_3, var_17_4 = arg_17_0:_get_unused_unit_frame()

						if var_17_3 then
							arg_17_0:_reset_unit_frame(var_17_3)

							var_17_3.player_data = {
								connecting_peer_id = var_17_2
							}
							var_17_0 = true
						end
					end

					var_0_6[var_17_2] = true
					arg_17_2 = arg_17_2 + 1

					if arg_17_2 == 3 then
						break
					end
				end
			end
		end
	end

	return var_17_0
end

function UnitFramesHandler._cleanup_unused_unit_frames(arg_18_0, arg_18_1, arg_18_2)
	local var_18_0 = false
	local var_18_1 = arg_18_0._unit_frames

	for iter_18_0 = 2, #var_18_1 do
		local var_18_2 = var_18_1[iter_18_0]
		local var_18_3 = var_18_2.player_data
		local var_18_4 = var_18_3.player_ui_id
		local var_18_5 = var_18_3.connecting_peer_id

		if var_18_5 and not arg_18_2[var_18_5] or var_18_4 and not arg_18_1[var_18_4] then
			arg_18_0:_reset_unit_frame(var_18_2)

			var_18_0 = true

			if var_18_4 then
				arg_18_0._unit_frame_index_by_ui_id[var_18_4] = nil
			end
		end
	end

	return var_18_0
end

function UnitFramesHandler._align_party_member_frames(arg_19_0)
	local var_19_0 = -100
	local var_19_1 = 80
	local var_19_2 = -80
	local var_19_3 = 220

	if arg_19_0._is_dark_pact then
		var_19_3 = 180
	end

	local var_19_4 = arg_19_0._is_visible
	local var_19_5 = 0
	local var_19_6 = 0
	local var_19_7 = arg_19_0._unit_frames

	for iter_19_0 = 2, #var_19_7 do
		local var_19_8 = var_19_7[iter_19_0]
		local var_19_9 = var_19_8.widget
		local var_19_10 = var_19_8.player_data
		local var_19_11 = var_19_10.peer_id
		local var_19_12 = var_19_10.connecting_peer_id

		if (var_19_11 or var_19_12) and var_19_4 then
			local var_19_13
			local var_19_14

			if var_19_10.is_enemy then
				var_19_13 = var_19_2
				var_19_14 = var_19_0 - var_19_6 * var_19_3
				var_19_6 = var_19_6 + 1
				var_19_9.ui_scenegraph.pivot.horizontal_alignment = "right"
			else
				var_19_13 = var_19_1
				var_19_14 = var_19_0 - var_19_5 * var_19_3
				var_19_5 = var_19_5 + 1
			end

			var_19_9:set_position(var_19_13, var_19_14)
			var_19_9:set_visible(true)
		else
			var_19_9:set_visible(false)
		end
	end
end

local function var_0_7(arg_20_0, arg_20_1, arg_20_2)
	local var_20_0

	if not arg_20_2.ammo_data then
		return
	end

	local var_20_1 = arg_20_2.ammo_data.ammo_hand

	if var_20_1 == "right" then
		var_20_0 = ScriptUnit.extension(arg_20_1, "ammo_system")
	elseif var_20_1 == "left" then
		var_20_0 = ScriptUnit.extension(arg_20_0, "ammo_system")
	else
		return
	end

	local var_20_2 = var_20_0:ammo_count()
	local var_20_3 = var_20_0:remaining_ammo()
	local var_20_4 = var_20_0:using_single_clip()
	local var_20_5 = var_20_0:max_ammo()

	return var_20_2, var_20_3, var_20_5, var_20_4
end

local function var_0_8(arg_21_0)
	local var_21_0 = ScriptUnit.extension(arg_21_0, "overcharge_system")
	local var_21_1 = var_21_0:overcharge_fraction()
	local var_21_2 = var_21_0:threshold_fraction()
	local var_21_3 = var_21_0:get_anim_blend_overcharge()

	return true, var_21_1, var_21_2, var_21_3
end

function UnitFramesHandler._set_player_extensions(arg_22_0, arg_22_1, arg_22_2)
	arg_22_1.extensions = {
		career = ScriptUnit.extension(arg_22_2, "career_system"),
		health = ScriptUnit.extension(arg_22_2, "health_system"),
		status = ScriptUnit.extension(arg_22_2, "status_system"),
		inventory = ScriptUnit.extension(arg_22_2, "inventory_system"),
		buff = ScriptUnit.extension(arg_22_2, "buff_system")
	}
	arg_22_1.player_unit = arg_22_2
end

local var_0_9 = {}

function UnitFramesHandler._sync_player_stats(arg_23_0, arg_23_1)
	if not arg_23_1.sync then
		return
	end

	local var_23_0 = arg_23_1.player_data
	local var_23_1 = var_23_0.player

	if not var_23_1 then
		return
	end

	local var_23_2 = Managers.input:is_device_active("gamepad")
	local var_23_3 = var_23_0.peer_id
	local var_23_4 = var_23_0.local_player_id
	local var_23_5 = arg_23_1.data
	local var_23_6 = arg_23_1.widget
	local var_23_7 = arg_23_0.profile_synchronizer

	if not var_23_0.extensions then
		local var_23_8 = var_23_1.player_unit

		if var_23_8 then
			arg_23_0:_set_player_extensions(var_23_0, var_23_8)
		end
	end

	local var_23_9 = var_23_7:profile_by_peer(var_23_3, var_23_4)

	if not var_23_9 then
		return
	end

	local var_23_10
	local var_23_11
	local var_23_12
	local var_23_13
	local var_23_14
	local var_23_15
	local var_23_16
	local var_23_17 = false
	local var_23_18 = var_23_0.player_unit

	if (not var_23_18 or not Unit.alive(var_23_18)) and var_23_0.extensions then
		var_23_0.extensions = nil
	end

	local var_23_19 = Managers.state.unit_storage:go_id(var_23_18)
	local var_23_20 = Managers.state.network:game()
	local var_23_21 = 0
	local var_23_22 = var_23_0.extensions
	local var_23_23
	local var_23_24
	local var_23_25

	if var_23_22 then
		local var_23_26 = var_23_22.career
		local var_23_27 = var_23_22.buff
		local var_23_28 = var_23_22.status
		local var_23_29 = var_23_22.health

		var_23_25 = var_23_22.inventory
		var_23_11 = var_23_28:is_dead() and 0 or var_23_29:current_health_percent()
		var_23_10 = var_23_28:is_dead() and 0 or var_23_29:current_permanent_health_percent()
		var_23_15 = var_23_28:is_wounded()
		var_23_13 = (var_23_28:is_knocked_down() or var_23_28:get_is_ledge_hanging()) and var_23_11 > 0
		var_23_16 = var_23_28:is_ready_for_assisted_respawn()
		var_23_14 = var_23_28:is_grabbed_by_pack_master() or var_23_28:is_hanging_from_hook() or var_23_28:is_pounced_down() or var_23_28:is_grabbed_by_corruptor() or var_23_28:is_in_vortex() or var_23_28:is_grabbed_by_chaos_spawn()

		local var_23_30 = var_23_27:num_buff_perk("skaven_grimoire")
		local var_23_31 = var_23_27:apply_buffs_to_value(PlayerUnitDamageSettings.GRIMOIRE_HEALTH_DEBUFF, "curse_protection")
		local var_23_32 = var_23_27:num_buff_perk("twitch_grimoire")
		local var_23_33 = var_23_27:apply_buffs_to_value(PlayerUnitDamageSettings.GRIMOIRE_HEALTH_DEBUFF, "curse_protection")
		local var_23_34 = var_23_27:num_buff_perk("slayer_curse")
		local var_23_35 = var_23_27:apply_buffs_to_value(PlayerUnitDamageSettings.SLAYER_CURSE_HEALTH_DEBUFF, "curse_protection")
		local var_23_36 = var_23_27:num_buff_perk("mutator_curse")
		local var_23_37 = WindSettings.light.curse_settings.value
		local var_23_38 = Managers.state.difficulty:get_difficulty_value_from_table(var_23_37)
		local var_23_39 = var_23_27:apply_buffs_to_value(var_23_38, "curse_protection")
		local var_23_40 = var_23_27:apply_buffs_to_value(0, "health_curse")
		local var_23_41 = var_23_27:apply_buffs_to_value(var_23_40, "curse_protection")

		var_23_12 = 1 + var_23_30 * var_23_31 + var_23_32 * var_23_33 + var_23_34 * var_23_35 + var_23_36 * var_23_39 + var_23_41
		var_23_23 = var_23_25:equipment()
		var_23_9 = var_23_26:profile_index()
		var_23_24 = var_23_26:career_index()

		if var_23_20 and var_23_19 then
			var_23_21 = GameSession.game_object_field(var_23_20, var_23_19, "ability_percentage") or 0
		end
	else
		var_23_10 = 0
		var_23_11 = 0
		var_23_12 = 1
		var_23_13 = false
	end

	local var_23_42 = var_23_11 <= 0
	local var_23_43 = var_23_1:is_player_controlled()
	local var_23_44 = UIRenderer.crop_text(var_23_1:name(), 17)
	local var_23_45 = var_23_43 and (ExperienceSettings.get_player_level(var_23_1) or "") or UISettings.bots_level_display_text
	local var_23_46 = var_23_43 and (ExperienceSettings.get_versus_player_level(var_23_1) or arg_23_0._cached_versus_level[var_23_3]) or 0

	arg_23_0._cached_versus_level[var_23_3] = var_23_46 or arg_23_0._cached_versus_level[var_23_3]

	local var_23_47 = var_23_24 and var_0_3(var_23_9, var_23_24) or "unit_frame_portrait_default"
	local var_23_48 = Managers.state.entity:system("cosmetic_system"):get_equipped_frame(var_23_18)
	local var_23_49 = arg_23_0.host_peer_id == var_23_3
	local var_23_50 = var_23_43 and var_23_49
	local var_23_51 = false
	local var_23_52 = false

	if var_23_13 then
		var_23_51 = false
	elseif var_23_42 or var_23_16 or var_23_14 then
		var_23_51 = true
	end

	local var_23_53 = false
	local var_23_54 = false
	local var_23_55 = false

	if var_23_5.connecting ~= var_23_52 then
		var_23_5.connecting = var_23_52

		var_23_6:set_connecting_status(var_23_52)
	end

	if var_23_5.is_knocked_down ~= var_23_13 then
		var_23_5.is_knocked_down = var_23_13
		var_23_54 = true
		var_23_55 = true
	end

	if var_23_5.is_dead ~= var_23_42 then
		var_23_5.is_dead = var_23_42
		var_23_55 = true
		var_23_54 = true
	end

	if var_23_5.is_wounded ~= var_23_15 then
		var_23_5.is_wounded = var_23_15
		var_23_55 = true
	end

	if var_23_5.needs_help ~= var_23_14 then
		var_23_5.needs_help = var_23_14
		var_23_54 = true
	end

	if var_23_5.is_talking ~= var_23_17 then
		var_23_5.is_talking = var_23_17

		var_23_6:set_talking(var_23_17)

		var_23_53 = true
	end

	if var_23_5.show_icon ~= var_23_51 then
		var_23_5.show_icon = var_23_51

		var_23_6:set_icon_visibility(var_23_51)

		var_23_53 = true
	end

	if var_23_5.assisted_respawn ~= var_23_16 then
		var_23_5.assisted_respawn = var_23_16
		var_23_54 = true
		var_23_53 = true
	end

	if var_23_5.show_health_bar ~= not var_23_16 then
		var_23_5.show_health_bar = not var_23_16
		var_23_55 = true
		var_23_53 = true
	end

	if var_23_5.portrait_texture ~= var_23_47 then
		var_23_5.portrait_texture = var_23_47

		var_23_6:set_portrait(var_23_47)

		var_23_53 = true
	end

	if var_23_5.frame_texture ~= var_23_48 or var_23_5.level_text ~= var_23_45 then
		var_23_5.frame_texture = var_23_48
		var_23_5.level_text = var_23_45

		var_23_6:set_portrait_frame(var_23_48, var_23_45)

		var_23_53 = true
	end

	if var_23_5.versus_level ~= var_23_46 or var_23_5.insignia_dirty_id ~= arg_23_0._insignia_dirty_id then
		var_23_5.versus_level = var_23_46

		var_23_6:set_versus_level(var_23_46)

		var_23_5.insignia_dirty_id = arg_23_0._insignia_dirty_id
	end

	if var_23_5.display_name ~= var_23_44 then
		var_23_5.display_name = var_23_44

		var_23_6:set_player_name(var_23_44)

		var_23_53 = true
	end

	if var_23_5.is_host ~= var_23_50 then
		var_23_5.is_host = var_23_50

		var_23_6:set_host_status(var_23_50)

		var_23_53 = true
	end

	if var_23_54 then
		var_23_6:set_portrait_status(var_23_13, var_23_14, var_23_42, var_23_16)

		var_23_53 = true
	end

	if var_23_5.total_health_percent ~= var_23_11 or var_23_5.active_percentage ~= var_23_12 then
		var_23_5.total_health_percent = var_23_11

		var_23_6:set_total_health_percentage(var_23_11, var_23_12)

		var_23_53 = true
	end

	if var_23_5.health_percent ~= var_23_10 or var_23_5.active_percentage ~= var_23_12 then
		var_23_5.health_percent = var_23_10

		var_23_6:set_health_percentage(var_23_10, var_23_12)

		var_23_53 = true
	end

	if var_23_5.active_percentage ~= var_23_12 then
		var_23_5.active_percentage = var_23_12

		var_23_6:set_active_percentage(var_23_12)

		var_23_53 = true
	end

	local var_23_56 = arg_23_1.features_list or var_0_9

	if var_23_56.ability and var_23_5.ability_cooldown_percentage ~= var_23_21 then
		var_23_5.ability_cooldown_percentage = var_23_21

		var_23_6:set_ability_percentage(1 - var_23_21)

		var_23_53 = true
	end

	local var_23_57 = var_23_56.equipment
	local var_23_58 = var_23_56.weapons
	local var_23_59 = var_23_56.ammo

	if var_23_23 and (var_23_57 or var_23_58 or var_23_59) then
		local var_23_60 = var_23_23.wielded

		if not var_23_5.inventory_slots then
			var_23_5.inventory_slots = {}
		end

		local var_23_61 = InventorySettings.slots
		local var_23_62 = var_23_5.inventory_slots

		for iter_23_0 = 1, #var_23_61 do
			local var_23_63 = var_23_61[iter_23_0].name
			local var_23_64 = var_23_23.slots[var_23_63]
			local var_23_65 = var_23_64 and var_23_64.item_data

			if var_23_65 and var_23_65.hide_in_frame_ui then
				local var_23_66 = false
				local var_23_67 = var_23_25:get_additional_items(var_23_63)

				if var_23_67 then
					for iter_23_1 = 1, #var_23_67 do
						local var_23_68 = var_23_67[iter_23_1]

						if not var_23_68.hide_in_frame_ui then
							var_23_65 = var_23_68
							var_23_66 = true

							break
						end
					end
				end

				if not var_23_66 then
					var_23_65 = nil
				end

				var_23_64 = nil
			end

			if not var_23_62[var_23_63] then
				var_23_62[var_23_63] = {}
			end

			local var_23_69 = var_23_62[var_23_63]

			if var_23_59 and var_23_63 == "slot_ranged" and var_23_65 then
				if BackendUtils.get_item_template(var_23_65).ammo_data then
					local var_23_70 = 1

					if var_23_20 and var_23_19 then
						var_23_70 = GameSession.game_object_field(var_23_20, var_23_19, "ammo_percentage")
					end

					if var_23_69.ammo_fraction ~= var_23_70 then
						var_23_6:set_ammo_percentage(var_23_70)

						var_23_69.ammo_fraction = var_23_70
					end
				else
					var_23_6:set_ammo_percentage(1)
				end
			end

			if var_23_57 and var_0_0[var_23_63] then
				local var_23_71 = var_23_65 and true or false
				local var_23_72 = var_23_65 and var_23_65.name
				local var_23_73 = var_23_25:has_additional_item_slots(var_23_63)

				if var_23_69.visible ~= var_23_71 or var_23_69.item_name ~= var_23_72 then
					var_23_69.visible = var_23_71
					var_23_69.item_name = var_23_72

					local var_23_74 = var_23_73 and arg_23_0:_slot_item_count(var_23_25, var_23_63)

					if var_23_74 and var_23_74 <= 1 then
						var_23_73 = nil
						var_23_74 = nil
					end

					var_23_69.has_additional_item_slots = var_23_73
					var_23_69.item_count = var_23_74

					var_23_6:set_inventory_slot_data(var_23_63, var_23_71, var_23_65, var_23_74)

					var_23_53 = true
				elseif var_23_69.visible and (var_23_69.has_additional_item_slots or var_23_73) then
					local var_23_75 = arg_23_0:_slot_item_count(var_23_25, var_23_63)

					if var_23_75 and var_23_75 <= 1 then
						var_23_73 = nil
						var_23_75 = nil
					end

					if var_23_69.item_count ~= var_23_75 then
						if not var_23_73 then
							var_23_75 = nil
						end

						var_23_69.has_additional_item_slots = var_23_73
						var_23_69.item_count = var_23_75

						var_23_6:set_inventory_slot_data(var_23_63, var_23_71, var_23_65, var_23_75)

						var_23_53 = true
					end
				end
			end

			if var_23_58 and var_0_1[var_23_63] and var_23_65 then
				local var_23_76 = var_23_65.name
				local var_23_77 = var_23_65.hud_icon
				local var_23_78 = var_23_60 == var_23_65

				if var_23_69.is_wielded ~= var_23_78 or var_23_69.item_name ~= var_23_76 then
					var_23_6:set_equipped_weapon_info(var_23_63, var_23_78, var_23_76, var_23_77)

					if var_23_69.item_name ~= var_23_76 then
						var_23_69.no_ammo = nil
					end

					var_23_69.is_wielded = var_23_78
					var_23_69.item_name = var_23_76
					var_23_69.hud_icon = var_23_77
					var_23_53 = true
				end

				local var_23_79 = BackendUtils.get_item_template(var_23_65)

				if var_23_79.ammo_data and var_23_64 then
					local var_23_80, var_23_81, var_23_82, var_23_83 = var_0_7(var_23_64.left_unit_1p, var_23_64.right_unit_1p, var_23_79)

					if var_23_69.ammo_count ~= var_23_80 or var_23_69.remaining_ammo ~= var_23_81 or var_23_69.no_ammo then
						var_23_69.ammo_count = var_23_80
						var_23_69.remaining_ammo = var_23_81
						var_23_69.no_ammo = nil

						var_23_6:set_ammo_for_slot(var_23_63, var_23_80, var_23_81, var_23_83)

						var_23_53 = true
					end

					if var_23_63 == "slot_ranged" and var_23_69.overcharge_fraction then
						var_23_6:set_overcharge_percentage(false, nil)

						var_23_69.overcharge_fraction = nil
					end
				else
					if not var_23_69.no_ammo then
						var_23_69.no_ammo = true
						var_23_53 = true

						var_23_6:set_ammo_for_slot(var_23_63, nil, nil)

						var_23_69.overcharge_fraction = nil
						var_23_69.ammo_count = nil
						var_23_69.remaining_ammo = nil
					end

					if var_23_63 == "slot_ranged" then
						local var_23_84, var_23_85, var_23_86 = var_0_8(var_23_18)

						if var_23_69.overcharge_fraction ~= var_23_85 then
							var_23_6:set_overcharge_percentage(var_23_84, var_23_85)

							var_23_69.overcharge_fraction = var_23_85
						end
					end
				end
			end
		end
	end

	if var_23_55 then
		local var_23_87 = var_23_16 or var_23_42

		var_23_6:set_health_bar_status(not var_23_87, var_23_13, var_23_15)

		var_23_53 = true
	end

	if var_23_53 then
		var_23_6:set_dirty()

		if arg_23_0.cleanui then
			arg_23_0.cleanui.dirty = true
		end
	end

	arg_23_0.gamepad_was_active = var_23_2
end

function UnitFramesHandler._slot_item_count(arg_24_0, arg_24_1, arg_24_2)
	local var_24_0 = 0
	local var_24_1 = arg_24_1:get_slot_data(arg_24_2)

	if var_24_1 and not var_24_1.item_data.hide_in_frame_ui then
		var_24_0 = var_24_0 + 1
	end

	local var_24_2 = arg_24_1:get_additional_items(arg_24_2)

	if var_24_2 then
		for iter_24_0 = 1, #var_24_2 do
			if not var_24_2[iter_24_0].hide_in_frame_ui then
				var_24_0 = var_24_0 + 1
			end
		end
	end

	return var_24_0
end

function UnitFramesHandler.destroy(arg_25_0)
	arg_25_0.ui_animator = nil

	arg_25_0:set_visible(false)

	local var_25_0 = Managers.state.event

	var_25_0:unregister("add_respawn_counter_event", arg_25_0)
	var_25_0:unregister("on_spectator_target_changed", arg_25_0)
	var_25_0:unregister("on_game_options_changed", arg_25_0)

	if arg_25_0._is_dark_pact then
		var_25_0:unregister("add_damage_feedback_event", arg_25_0)
	end
end

function UnitFramesHandler.set_visible(arg_26_0, arg_26_1)
	arg_26_0._is_visible = arg_26_1

	local var_26_0 = arg_26_0._parent:is_own_player_dead() and not arg_26_0._is_spectator
	local var_26_1 = arg_26_0._unit_frames

	for iter_26_0 = 1, #var_26_1 do
		local var_26_2 = var_26_1[iter_26_0]
		local var_26_3 = var_26_2.player_data

		if var_26_3.peer_id then
			if var_26_0 and iter_26_0 == 1 then
				var_26_2.widget:set_visible(false)
			else
				var_26_2.widget:set_visible(arg_26_1)
			end
		elseif var_26_3.connecting_peer_id then
			var_26_2.widget:set_visible(arg_26_1)
		elseif not arg_26_1 then
			var_26_2.widget:set_visible(false)
		end
	end
end

function UnitFramesHandler.on_gamepad_activated(arg_27_0)
	local var_27_0 = arg_27_0._unit_frames[1]

	if not var_27_0.gamepad_version then
		local var_27_1 = var_27_0.widget:is_visible()

		var_27_0.widget:destroy()

		local var_27_2 = arg_27_0:_create_unit_frame_by_type("player")

		var_27_2.player_data = var_27_0.player_data
		var_27_2.sync = true
		arg_27_0._unit_frames[1] = var_27_2

		var_27_2.widget:set_visible(var_27_1)
	end
end

function UnitFramesHandler.on_gamepad_deactivated(arg_28_0)
	local var_28_0 = arg_28_0._unit_frames[1]

	if var_28_0.gamepad_version then
		local var_28_1 = var_28_0.widget:is_visible()

		var_28_0.widget:destroy()

		local var_28_2 = arg_28_0:_create_unit_frame_by_type("player")

		var_28_2.player_data = var_28_0.player_data
		var_28_2.sync = true
		arg_28_0._unit_frames[1] = var_28_2

		var_28_2.widget:set_visible(var_28_1)
	end
end

function UnitFramesHandler.update(arg_29_0, arg_29_1, arg_29_2)
	if not arg_29_0._is_visible then
		return
	end

	local var_29_0 = arg_29_0._parent:is_own_player_dead() and not arg_29_0._is_spectator
	local var_29_1 = (arg_29_0.input_manager:is_device_active("gamepad") or not IS_WINDOWS or UISettings.use_gamepad_hud_layout == "always") and UISettings.use_gamepad_hud_layout ~= "never"

	var_29_1 = var_29_1 and not arg_29_0._is_dark_pact

	if var_29_1 then
		if not arg_29_0.gamepad_active_last_frame then
			arg_29_0.gamepad_active_last_frame = true

			arg_29_0:on_gamepad_activated()
		end
	elseif arg_29_0.gamepad_active_last_frame then
		arg_29_0.gamepad_active_last_frame = false

		arg_29_0:on_gamepad_deactivated()
	end

	arg_29_0:_handle_unit_frame_assigning()
	arg_29_0:_sync_player_stats(arg_29_0._unit_frames[arg_29_0._current_frame_index])

	arg_29_0._current_frame_index = 1 + arg_29_0._current_frame_index % #arg_29_0._unit_frames

	local var_29_2 = arg_29_0._unit_frames

	for iter_29_0 = 1, #var_29_2 do
		local var_29_3 = var_29_2[iter_29_0]

		if iter_29_0 ~= 1 or not var_29_0 then
			var_29_3.widget:update(arg_29_1, arg_29_2)
		end

		if var_29_3.widget:show_respawn_ui() then
			var_29_3.widget:update_respawn_countdown(arg_29_1, arg_29_2)
		end
	end

	if arg_29_0._update_resolution_modified then
		arg_29_0:resolution_modified()
	end

	arg_29_0:_draw(arg_29_1)
	arg_29_0:_update_numeric_ui()
end

function UnitFramesHandler.resolution_modified(arg_30_0)
	if not arg_30_0._is_visible then
		arg_30_0._update_resolution_modified = true

		return
	end

	local var_30_0 = arg_30_0._unit_frames

	for iter_30_0 = 1, #var_30_0 do
		var_30_0[iter_30_0].widget:on_resolution_modified()
	end

	arg_30_0._update_resolution_modified = nil
end

function UnitFramesHandler._draw(arg_31_0, arg_31_1)
	if not arg_31_0._is_visible then
		return
	end

	local var_31_0 = arg_31_0._unit_frames

	for iter_31_0 = 1, #var_31_0 do
		var_31_0[iter_31_0].widget:draw(arg_31_1)
	end
end

function UnitFramesHandler._update_numeric_ui(arg_32_0)
	local var_32_0 = false

	if arg_32_0._numeric_ui_enabled ~= Application.user_setting("numeric_ui") then
		arg_32_0._numeric_ui_enabled = Application.user_setting("numeric_ui")
		var_32_0 = true
	end

	if arg_32_0._should_use_gamepad ~= Application.user_setting("use_gamepad_hud_layout") then
		arg_32_0._should_use_gamepad = Application.user_setting("use_gamepad_hud_layout")
		var_32_0 = true
	end

	local var_32_1 = arg_32_0._unit_frames

	for iter_32_0 = 1, #var_32_1 do
		local var_32_2 = var_32_1[iter_32_0]
		local var_32_3 = var_32_2.widget

		if not var_32_3 then
			return
		end

		local var_32_4 = var_32_2.player_data
		local var_32_5 = var_32_4.player

		if not var_32_5 then
			return
		end

		local var_32_6 = var_32_5 and var_32_5.player_unit
		local var_32_7 = Managers.state.unit_storage:go_id(var_32_6)
		local var_32_8 = Managers.state.network:game()

		if var_32_4 and arg_32_0._numeric_ui_enabled and var_32_8 and var_32_7 then
			var_32_3:update_numeric_ui_health(var_32_4)
			var_32_3:update_numeric_ui_ammo(var_32_4)
			var_32_3:update_numeric_ui_career_ability(var_32_8, var_32_7, var_32_4)
		end

		if var_32_0 or var_32_3.weapon_changed then
			var_32_3:set_dirty()
		end
	end
end
