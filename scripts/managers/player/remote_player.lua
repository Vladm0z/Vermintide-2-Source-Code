-- chunkname: @scripts/managers/player/remote_player.lua

RemotePlayer = class(RemotePlayer)

function RemotePlayer.init(arg_1_0, arg_1_1, arg_1_2, arg_1_3, arg_1_4, arg_1_5, arg_1_6, arg_1_7, arg_1_8, arg_1_9)
	arg_1_0.network_manager = arg_1_1
	arg_1_0.remote = true
	arg_1_0.peer_id = arg_1_2
	arg_1_0.is_server = arg_1_4
	arg_1_0._player_controlled = arg_1_3
	arg_1_0._ui_id = arg_1_8
	arg_1_0._observed_unit = nil
	arg_1_0._account_id = arg_1_9
	arg_1_0._debug_name = Localize("tutorial_no_text")
	arg_1_0.owned_units = {}
	arg_1_0.game_object_id = nil
	arg_1_0._unique_id = arg_1_6
	arg_1_0._local_player_id = arg_1_5
	arg_1_0._clan_tag = arg_1_7

	if arg_1_4 then
		arg_1_0:create_game_object()
	end

	arg_1_0.index = arg_1_0.game_object_id
	arg_1_0._cached_name = nil
end

function RemotePlayer.profile_id(arg_2_0)
	return arg_2_0._unique_id
end

function RemotePlayer.ui_id(arg_3_0)
	return arg_3_0._ui_id
end

function RemotePlayer.unique_id(arg_4_0)
	return arg_4_0._unique_id
end

function RemotePlayer.platform_id(arg_5_0)
	if IS_WINDOWS or IS_LINUX then
		return arg_5_0.peer_id
	else
		return arg_5_0._account_id
	end
end

function RemotePlayer.despawn(arg_6_0)
	assert(arg_6_0.is_server)
end

function RemotePlayer.type(arg_7_0)
	return "RemotePlayer"
end

function RemotePlayer.set_player_unit(arg_8_0, arg_8_1)
	arg_8_0.player_unit = arg_8_1
	arg_8_0._career_index = ScriptUnit.extension(arg_8_1, "career_system"):career_index()
end

function RemotePlayer.profile_index(arg_9_0)
	return (arg_9_0.network_manager.profile_synchronizer:profile_by_peer(arg_9_0.peer_id, arg_9_0._local_player_id))
end

function RemotePlayer.set_profile_index(arg_10_0, arg_10_1)
	assert(true, "Why are we trying to set profile index for a remote player?")
end

function RemotePlayer.set_career_index(arg_11_0, arg_11_1)
	error("Why are we trying to set career index for a remote player?")
end

function RemotePlayer.character_name(arg_12_0)
	local var_12_0 = arg_12_0.network_manager.profile_synchronizer:profile_by_peer(arg_12_0.peer_id, arg_12_0._local_player_id)

	if var_12_0 then
		local var_12_1 = SPProfiles[var_12_0]

		return var_12_1 and var_12_1.character_name
	else
		return ""
	end
end

function RemotePlayer.profile_display_name(arg_13_0)
	local var_13_0 = arg_13_0.network_manager.profile_synchronizer:profile_by_peer(arg_13_0.peer_id, arg_13_0._local_player_id)

	if var_13_0 then
		local var_13_1 = SPProfiles[var_13_0]

		return var_13_1 and var_13_1.display_name
	else
		return ""
	end
end

function RemotePlayer.career_index(arg_14_0)
	local var_14_0, var_14_1 = arg_14_0.network_manager.profile_synchronizer:profile_by_peer(arg_14_0.peer_id, arg_14_0._local_player_id)

	return var_14_1 or 1
end

function RemotePlayer.career_name(arg_15_0)
	local var_15_0 = arg_15_0:profile_index()
	local var_15_1 = SPProfiles[var_15_0]

	if var_15_1 and var_15_1.display_name then
		local var_15_2 = arg_15_0:career_index()

		return var_15_1.careers[var_15_2].name
	end
end

function RemotePlayer.stats_id(arg_16_0)
	return arg_16_0._unique_id
end

function RemotePlayer.telemetry_id(arg_17_0)
	return arg_17_0._unique_id
end

function RemotePlayer.local_player_id(arg_18_0)
	return arg_18_0._local_player_id
end

function RemotePlayer.network_id(arg_19_0)
	return arg_19_0.peer_id
end

function RemotePlayer.is_player_controlled(arg_20_0)
	return arg_20_0._player_controlled
end

function RemotePlayer.get_data(arg_21_0, arg_21_1)
	return arg_21_0._player_sync_data:get_data(arg_21_1)
end

function RemotePlayer.name(arg_22_0)
	local var_22_0

	if not arg_22_0._player_controlled then
		var_22_0 = Localize(arg_22_0:character_name())
		arg_22_0._cached_name = var_22_0
	elseif rawget(_G, "Steam") then
		if arg_22_0._cached_name then
			return arg_22_0._cached_name
		else
			local var_22_1 = ""
			local var_22_2 = Managers.state.network:game()
			local var_22_3 = arg_22_0.game_object_id

			if var_22_2 and var_22_3 then
				local var_22_4 = GameSession.game_object_field(var_22_2, var_22_3, "clan_tag")

				if var_22_4 and var_22_4 ~= "0" then
					local var_22_5 = tostring(Clans.clan_tag(var_22_4))

					if var_22_5 ~= "" then
						var_22_1 = var_22_5 .. "|"
					end
				end
			end

			var_22_0 = var_22_1 .. Steam.user_name(arg_22_0:network_id())
			arg_22_0._cached_name = var_22_0
		end
	elseif IS_CONSOLE then
		if arg_22_0._cached_name then
			return arg_22_0._cached_name
		end

		local var_22_6 = Managers.state.network:lobby()
		local var_22_7 = arg_22_0:network_id()

		if var_22_6 and var_22_6.user_name and var_22_7 then
			var_22_0 = var_22_6:user_name(var_22_7)
			arg_22_0._cached_name = var_22_0 or "Remote #" .. tostring(var_22_7:sub(-3, -1))
		end
	elseif Managers.game_server then
		if arg_22_0._cached_name then
			return arg_22_0._cached_name
		end

		var_22_0 = Managers.game_server:peer_name(arg_22_0:network_id())
		arg_22_0._cached_name = var_22_0
	else
		var_22_0 = "Remote #" .. tostring(arg_22_0.peer_id:sub(-3, -1))
	end

	return var_22_0
end

function RemotePlayer.cached_name(arg_23_0)
	return arg_23_0._cached_name or arg_23_0._debug_name
end

function RemotePlayer.destroy(arg_24_0)
	if arg_24_0._player_sync_data then
		arg_24_0._player_sync_data:destroy()
	end

	if arg_24_0.is_server then
		if arg_24_0.game_object_id then
			arg_24_0.network_manager:destroy_game_object(arg_24_0.game_object_id)
		end

		Managers.state.event:trigger("delete_limited_owned_pickups", arg_24_0.peer_id)
	end
end

function RemotePlayer.create_game_object(arg_25_0)
	local var_25_0 = {
		ping = 0,
		go_type = NetworkLookup.go_types.player,
		network_id = arg_25_0:network_id(),
		local_player_id = arg_25_0:local_player_id(),
		player_controlled = arg_25_0._player_controlled,
		clan_tag = arg_25_0._clan_tag,
		account_id = arg_25_0._account_id
	}
	local var_25_1 = callback(arg_25_0, "cb_game_session_disconnect")

	arg_25_0.game_object_id = arg_25_0.network_manager:create_player_game_object("player", var_25_0, var_25_1)

	arg_25_0:create_sync_data()

	if script_data.network_debug then
		print("RemotePlayer:create_game_object( )", arg_25_0.game_object_id)
	end
end

function RemotePlayer.cb_game_session_disconnect(arg_26_0)
	arg_26_0.game_object_id = nil
end

function RemotePlayer.set_game_object_id(arg_27_0, arg_27_1)
	arg_27_0.game_object_id = arg_27_1
end

function RemotePlayer.create_sync_data(arg_28_0)
	assert(arg_28_0._player_sync_data == nil)

	arg_28_0._player_sync_data = PlayerSyncData:new(arg_28_0, arg_28_0.network_manager)
end

function RemotePlayer.set_sync_data_game_object_id(arg_29_0, arg_29_1)
	arg_29_0._player_sync_data:set_game_object_id(arg_29_1)
end

function RemotePlayer.sync_data_active(arg_30_0)
	return arg_30_0._player_sync_data and arg_30_0._player_sync_data:active()
end

function RemotePlayer.get_party(arg_31_0)
	local var_31_0 = Managers.party:get_status_from_unique_id(arg_31_0._unique_id)

	return Managers.party:get_party(var_31_0.party_id)
end

function RemotePlayer.observed_unit(arg_32_0)
	return arg_32_0._observed_unit
end

function RemotePlayer.set_observed_unit(arg_33_0, arg_33_1)
	arg_33_0._observed_unit = arg_33_1
end
