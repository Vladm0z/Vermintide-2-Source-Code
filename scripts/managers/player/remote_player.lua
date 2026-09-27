-- chunkname: @scripts/managers/player/remote_player.lua

RemotePlayer = class(RemotePlayer)

RemotePlayer.init = function (self, arg_1_1, arg_1_2, arg_1_3, arg_1_4, arg_1_5, arg_1_6, arg_1_7, arg_1_8, arg_1_9)
	-- function 1
	self.network_manager = arg_1_1
	self.remote = true
	self.peer_id = arg_1_2
	self.is_server = arg_1_4
	self._player_controlled = arg_1_3
	self._ui_id = arg_1_8
	self._observed_unit = nil
	self._account_id = arg_1_9
	self._debug_name = Localize("tutorial_no_text")
	self.owned_units = {}
	self.game_object_id = nil
	self._unique_id = arg_1_6
	self._local_player_id = arg_1_5
	self._clan_tag = arg_1_7

	if not arg_1_4 then
		self:create_game_object()
	end

	self.index = self.game_object_id
	self._cached_name = nil
end

RemotePlayer.profile_id = function (self)
	-- function 2
	return self._unique_id
end

RemotePlayer.ui_id = function (self)
	-- function 3
	return self._ui_id
end

RemotePlayer.unique_id = function (self)
	-- function 4
	return self._unique_id
end

RemotePlayer.platform_id = function (self)
	-- function 5
	if IS_WINDOWS or not IS_LINUX then
		return self.peer_id
	else
		return self._account_id
	end
end

RemotePlayer.despawn = function (self)
	-- function 6
	assert(self.is_server)
end

RemotePlayer.type = function (arg_7_0)
	-- function 7
	return "RemotePlayer"
end

RemotePlayer.set_player_unit = function (self, arg_8_1)
	-- function 8
	self.player_unit = arg_8_1
	self._career_index = ScriptUnit.extension(arg_8_1, "career_system"):career_index()
end

RemotePlayer.profile_index = function (self)
	-- function 9
	return (self.network_manager.profile_synchronizer:profile_by_peer(self.peer_id, self._local_player_id))
end

RemotePlayer.set_profile_index = function (arg_10_0, arg_10_1)
	-- function 10
	assert(true, "Why are we trying to set profile index for a remote player?")
end

RemotePlayer.set_career_index = function (arg_11_0, arg_11_1)
	-- function 11
	error("Why are we trying to set career index for a remote player?")
end

RemotePlayer.character_name = function (self)
	-- function 12
	local profile_by_peer = self.network_manager.profile_synchronizer:profile_by_peer(self.peer_id, self._local_player_id)

	if not profile_by_peer then
		local var_12_1 = SPProfiles[profile_by_peer]

		return not var_12_1 and var_12_1.character_name
	else
		return ""
	end
end

RemotePlayer.profile_display_name = function (self)
	-- function 13
	local profile_by_peer = self.network_manager.profile_synchronizer:profile_by_peer(self.peer_id, self._local_player_id)

	if not profile_by_peer then
		local var_13_1 = SPProfiles[profile_by_peer]

		return not var_13_1 and var_13_1.display_name
	else
		return ""
	end
end

RemotePlayer.career_index = function (self)
	-- function 14
	local profile_by_peer, var_14_1 = self.network_manager.profile_synchronizer:profile_by_peer(self.peer_id, self._local_player_id)

	return var_14_1 or 1
end

RemotePlayer.career_name = function (self)
	-- function 15
	local profile_index = self:profile_index()
	local var_15_1 = SPProfiles[profile_index]

	if not (not var_15_1 and var_15_1.display_name) then
		local career_index = self:career_index()

		return var_15_1.careers[career_index].name
	end
end

RemotePlayer.stats_id = function (self)
	-- function 16
	return self._unique_id
end

RemotePlayer.telemetry_id = function (self)
	-- function 17
	return self._unique_id
end

RemotePlayer.local_player_id = function (self)
	-- function 18
	return self._local_player_id
end

RemotePlayer.network_id = function (self)
	-- function 19
	return self.peer_id
end

RemotePlayer.is_player_controlled = function (self)
	-- function 20
	return self._player_controlled
end

RemotePlayer.get_data = function (self, arg_21_1)
	-- function 21
	return self._player_sync_data:get_data(arg_21_1)
end

RemotePlayer.name = function (self)
	-- function 22
	local var_22_0

	if not self._player_controlled then
		var_22_0 = Localize(self:character_name())
		self._cached_name = var_22_0
	elseif not rawget(_G, "Steam") then
		if not self._cached_name then
			return self._cached_name
		else
			local str = ""
			local game = Managers.state.network:game()
			local game_object_id = self.game_object_id

			if not game and not game_object_id then
				local game_object_field = GameSession.game_object_field(game, game_object_id, "clan_tag")

				if not (not game_object_field and game_object_field == "0") then
					local var_22_5 = tostring(Clans.clan_tag(game_object_field))

					if var_22_5 ~= "" then
						str = var_22_5 .. "|"
					end
				end
			end

			var_22_0 = str .. Steam.user_name(self:network_id())
			self._cached_name = var_22_0
		end
	elseif not IS_CONSOLE then
		if not self._cached_name then
			return self._cached_name
		end

		local lobby = Managers.state.network:lobby()
		local network_id = self:network_id()

		if not lobby and not lobby.user_name and not network_id then
			var_22_0 = lobby:user_name(network_id)
			self._cached_name = var_22_0 or "Remote #" .. tostring(network_id:sub(-3, -1))
		end
	elseif not Managers.game_server then
		if not self._cached_name then
			return self._cached_name
		end

		var_22_0 = Managers.game_server:peer_name(self:network_id())
		self._cached_name = var_22_0
	else
		var_22_0 = "Remote #" .. tostring(self.peer_id:sub(-3, -1))
	end

	return var_22_0
end

RemotePlayer.cached_name = function (self)
	-- function 23
	local _cached_name = self._cached_name

	_cached_name = _cached_name or self._debug_name

	return _cached_name
end

RemotePlayer.destroy = function (self)
	-- function 24
	if not self._player_sync_data then
		self._player_sync_data:destroy()
	end

	if not self.is_server then
		if not self.game_object_id then
			self.network_manager:destroy_game_object(self.game_object_id)
		end

		Managers.state.event:trigger("delete_limited_owned_pickups", self.peer_id)
	end
end

RemotePlayer.create_game_object = function (self)
	-- function 25
	local tbl = {
		ping = 0,
		go_type = NetworkLookup.go_types.player,
		network_id = self:network_id(),
		local_player_id = self:local_player_id(),
		player_controlled = self._player_controlled,
		clan_tag = self._clan_tag,
		account_id = self._account_id
	}
	local var_25_1 = callback(self, "cb_game_session_disconnect")

	self.game_object_id = self.network_manager:create_player_game_object("player", tbl, var_25_1)

	self:create_sync_data()

	if not script_data.network_debug then
		print("RemotePlayer:create_game_object( )", self.game_object_id)
	end
end

RemotePlayer.cb_game_session_disconnect = function (self)
	-- function 26
	self.game_object_id = nil
end

RemotePlayer.set_game_object_id = function (self, arg_27_1)
	-- function 27
	self.game_object_id = arg_27_1
end

RemotePlayer.create_sync_data = function (self)
	-- function 28
	assert(self._player_sync_data == nil)

	self._player_sync_data = PlayerSyncData:new(self, self.network_manager)
end

RemotePlayer.set_sync_data_game_object_id = function (self, arg_29_1)
	-- function 29
	self._player_sync_data:set_game_object_id(arg_29_1)
end

RemotePlayer.sync_data_active = function (self)
	-- function 30
	local _player_sync_data = self._player_sync_data

	_player_sync_data = not _player_sync_data and self._player_sync_data:active()

	return _player_sync_data
end

RemotePlayer.get_party = function (self)
	-- function 31
	local get_status_from_unique_id = Managers.party:get_status_from_unique_id(self._unique_id)

	return Managers.party:get_party(get_status_from_unique_id.party_id)
end

RemotePlayer.observed_unit = function (self)
	-- function 32
	return self._observed_unit
end

RemotePlayer.set_observed_unit = function (self, arg_33_1)
	-- function 33
	self._observed_unit = arg_33_1
end
