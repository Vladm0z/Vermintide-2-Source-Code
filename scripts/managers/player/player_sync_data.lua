-- chunkname: @scripts/managers/player/player_sync_data.lua

PrivacyLevels = table.mirror_array_inplace({
	"private",
	"friends",
	"public"
})
PlayerSyncData = class(PlayerSyncData)

PlayerSyncData.init = function (self, arg_1_1, arg_1_2)
	-- function 1
	self._player = arg_1_1
	self._network_manager = arg_1_2

	if arg_1_1.local_player or not arg_1_1.bot_player or not arg_1_1.is_server then
		local _calc_highest_unlocked_difficulty = self:_calc_highest_unlocked_difficulty()
		local tbl = {
			power_level = 0,
			go_type = NetworkLookup.go_types.player_sync_data,
			network_id = arg_1_1:network_id(),
			local_player_id = arg_1_1:local_player_id(),
			is_dev = not not arg_1_1.bot_player or SteamHelper.is_dev()
		}
		local flag

		flag = not DEDICATED_SERVER and 0 and BackendUtils.best_aquired_power_level()
		tbl.best_aquired_power_level = flag
		tbl.highest_unlocked_difficulty = NetworkLookup.difficulties[_calc_highest_unlocked_difficulty]
		tbl.slot_frame = NetworkLookup.cosmetics.default
		tbl.slot_skin = NetworkLookup.cosmetics.default
		tbl.slot_hat = NetworkLookup.item_names["n/a"]
		tbl.slot_melee = NetworkLookup.item_names["n/a"]
		tbl.slot_melee_skin = NetworkLookup.weapon_skins["n/a"]
		tbl.slot_ranged = NetworkLookup.item_names["n/a"]
		tbl.slot_ranged_skin = NetworkLookup.weapon_skins["n/a"]
		tbl.slot_pose = NetworkLookup.item_names["n/a"]
		tbl.slot_pose_skin = NetworkLookup.item_names["n/a"]
		tbl.playerlist_build_privacy = Application.user_setting("playerlist_build_privacy")

		local var_1_3 = callback(self, "cb_game_session_disconnect")

		self._game_object_id = arg_1_2:create_game_object("player_sync_data", tbl, var_1_3)

		Managers.state.event:register(self, "on_game_options_changed", "_on_game_options_changed")
	end
end

PlayerSyncData._on_game_options_changed = function (self)
	-- function 2
	self:set_data("playerlist_build_privacy", Application.user_setting("playerlist_build_privacy"))
end

PlayerSyncData._calc_highest_unlocked_difficulty = function (arg_3_0)
	-- function 3
	if not Development.parameter("unlock_all_difficulties") then
		local str = "normal"
		local num = 0

		for k, v in pairs(DifficultySettings) do
			if not (not DefaultDifficultyLookup[k] and not (num < v.rank)) then
				num = v.rank
				str = k
			end
		end

		return str
	end

	if not DEDICATED_SERVER then
		return "versus_base"
	end

	local str_2 = "normal"
	local num_2 = 2

	for k_2, v_2 in pairs(DifficultySettings) do
		if not DefaultDifficultyLookup[k_2] then
			local flag = true

			if not v_2.extra_requirement_name then
				local extra_requirement_name = v_2.extra_requirement_name

				if not ExtraDifficultyRequirements[extra_requirement_name].requirement_function() then
					flag = false
				end
			end

			if not (not flag and not (num_2 < v_2.rank)) then
				str_2 = k_2
				num_2 = v_2.rank
			end
		end
	end

	return str_2
end

PlayerSyncData.reevaluate_highest_difficulty = function (self)
	-- function 4
	if not self._game_object_id then
		return
	end

	if not self._network_manager:game() then
		return
	end

	local _calc_highest_unlocked_difficulty = self:_calc_highest_unlocked_difficulty()

	self:set_data("highest_unlocked_difficulty", NetworkLookup.difficulties[_calc_highest_unlocked_difficulty])
end

PlayerSyncData.cb_game_session_disconnect = function (self)
	-- function 5
	self._game_object_id = nil
end

PlayerSyncData.set_game_object_id = function (self, arg_6_1)
	-- function 6
	self._game_object_id = arg_6_1
end

PlayerSyncData.active = function (self)
	-- function 7
	return self._game_object_id ~= nil
end

PlayerSyncData.destroy = function (self)
	-- function 8
	local _player = self._player

	if _player.local_player or not _player.bot_player or not _player.is_server or not self._game_object_id then
		local game = self._network_manager:game()

		if not GameSession.game_object_exists(game, self._game_object_id) then
			self._network_manager:destroy_game_object(self._game_object_id)
		end

		Managers.state.event:unregister("on_game_options_changed", self)
	end

	self._game_object_id = nil
	self._network_manager = nil
	self._player = nil
end

PlayerSyncData.set_data = function (self, arg_9_1, arg_9_2)
	-- function 9
	if not self._game_object_id then
		return
	end

	local game = self._network_manager:game()

	if not game then
		return
	end

	GameSession.set_game_object_field(game, self._game_object_id, arg_9_1, arg_9_2)
end

PlayerSyncData.get_data = function (self, arg_10_1)
	-- function 10
	if not self._game_object_id then
		print("[PlayerSyncData] Game object id is not initialized")

		return nil
	end

	local game = self._network_manager:game()

	if not game then
		print("[PlayerSyncData] Game session is not initialized")

		return nil
	end

	return GameSession.game_object_field(game, self._game_object_id, arg_10_1)
end
