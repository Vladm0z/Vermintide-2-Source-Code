-- chunkname: @scripts/managers/player/player_sync_data.lua

PrivacyLevels = table.mirror_array_inplace({
	"private",
	"friends",
	"public"
})
PlayerSyncData = class(PlayerSyncData)

PlayerSyncData.init = function (arg_1_0, arg_1_1, arg_1_2)
	arg_1_0._player = arg_1_1
	arg_1_0._network_manager = arg_1_2

	if arg_1_1.local_player or arg_1_1.bot_player and arg_1_1.is_server then
		local var_1_0 = arg_1_0:_calc_highest_unlocked_difficulty()
		local var_1_1 = {
			power_level = 0,
			go_type = NetworkLookup.go_types.player_sync_data,
			network_id = arg_1_1:network_id(),
			local_player_id = arg_1_1:local_player_id(),
			is_dev = not arg_1_1.bot_player and SteamHelper.is_dev(),
			best_aquired_power_level = DEDICATED_SERVER and 0 or BackendUtils.best_aquired_power_level(),
			highest_unlocked_difficulty = NetworkLookup.difficulties[var_1_0],
			slot_frame = NetworkLookup.cosmetics.default,
			slot_skin = NetworkLookup.cosmetics.default,
			slot_hat = NetworkLookup.item_names["n/a"],
			slot_melee = NetworkLookup.item_names["n/a"],
			slot_melee_skin = NetworkLookup.weapon_skins["n/a"],
			slot_ranged = NetworkLookup.item_names["n/a"],
			slot_ranged_skin = NetworkLookup.weapon_skins["n/a"],
			slot_pose = NetworkLookup.item_names["n/a"],
			slot_pose_skin = NetworkLookup.item_names["n/a"],
			playerlist_build_privacy = Application.user_setting("playerlist_build_privacy")
		}
		local var_1_2 = callback(arg_1_0, "cb_game_session_disconnect")

		arg_1_0._game_object_id = arg_1_2:create_game_object("player_sync_data", var_1_1, var_1_2)

		Managers.state.event:register(arg_1_0, "on_game_options_changed", "_on_game_options_changed")
	end
end

PlayerSyncData._on_game_options_changed = function (arg_2_0)
	arg_2_0:set_data("playerlist_build_privacy", Application.user_setting("playerlist_build_privacy"))
end

PlayerSyncData._calc_highest_unlocked_difficulty = function (arg_3_0)
	if Development.parameter("unlock_all_difficulties") then
		local var_3_0 = "normal"
		local var_3_1 = 0

		for iter_3_0, iter_3_1 in pairs(DifficultySettings) do
			if DefaultDifficultyLookup[iter_3_0] and var_3_1 < iter_3_1.rank then
				var_3_1 = iter_3_1.rank
				var_3_0 = iter_3_0
			end
		end

		return var_3_0
	end

	if DEDICATED_SERVER then
		return "versus_base"
	end

	local var_3_2 = "normal"
	local var_3_3 = 2

	for iter_3_2, iter_3_3 in pairs(DifficultySettings) do
		if DefaultDifficultyLookup[iter_3_2] then
			local var_3_4 = true

			if iter_3_3.extra_requirement_name then
				local var_3_5 = iter_3_3.extra_requirement_name

				if not ExtraDifficultyRequirements[var_3_5].requirement_function() then
					var_3_4 = false
				end
			end

			if var_3_4 and var_3_3 < iter_3_3.rank then
				var_3_2 = iter_3_2
				var_3_3 = iter_3_3.rank
			end
		end
	end

	return var_3_2
end

PlayerSyncData.reevaluate_highest_difficulty = function (arg_4_0)
	if not arg_4_0._game_object_id then
		return
	end

	if not arg_4_0._network_manager:game() then
		return
	end

	local var_4_0 = arg_4_0:_calc_highest_unlocked_difficulty()

	arg_4_0:set_data("highest_unlocked_difficulty", NetworkLookup.difficulties[var_4_0])
end

PlayerSyncData.cb_game_session_disconnect = function (arg_5_0)
	arg_5_0._game_object_id = nil
end

PlayerSyncData.set_game_object_id = function (arg_6_0, arg_6_1)
	arg_6_0._game_object_id = arg_6_1
end

PlayerSyncData.active = function (arg_7_0)
	return arg_7_0._game_object_id ~= nil
end

PlayerSyncData.destroy = function (arg_8_0)
	local var_8_0 = arg_8_0._player

	if (var_8_0.local_player or var_8_0.bot_player and var_8_0.is_server) and arg_8_0._game_object_id then
		local var_8_1 = arg_8_0._network_manager:game()

		if GameSession.game_object_exists(var_8_1, arg_8_0._game_object_id) then
			arg_8_0._network_manager:destroy_game_object(arg_8_0._game_object_id)
		end

		Managers.state.event:unregister("on_game_options_changed", arg_8_0)
	end

	arg_8_0._game_object_id = nil
	arg_8_0._network_manager = nil
	arg_8_0._player = nil
end

PlayerSyncData.set_data = function (arg_9_0, arg_9_1, arg_9_2)
	if not arg_9_0._game_object_id then
		return
	end

	local var_9_0 = arg_9_0._network_manager:game()

	if not var_9_0 then
		return
	end

	GameSession.set_game_object_field(var_9_0, arg_9_0._game_object_id, arg_9_1, arg_9_2)
end

PlayerSyncData.get_data = function (arg_10_0, arg_10_1)
	if not arg_10_0._game_object_id then
		print("[PlayerSyncData] Game object id is not initialized")

		return nil
	end

	local var_10_0 = arg_10_0._network_manager:game()

	if not var_10_0 then
		print("[PlayerSyncData] Game session is not initialized")

		return nil
	end

	return GameSession.game_object_field(var_10_0, arg_10_0._game_object_id, arg_10_1)
end
