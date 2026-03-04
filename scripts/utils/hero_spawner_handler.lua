-- chunkname: @scripts/utils/hero_spawner_handler.lua

HeroSpawnerHandler = class(HeroSpawnerHandler)

HeroSpawnerHandler.init = function (arg_1_0, arg_1_1, arg_1_2, arg_1_3)
	arg_1_0.profile_synchronizer = arg_1_2
	arg_1_0.is_server = arg_1_1
	arg_1_0.request_id = 0
	arg_1_0.network_event_delegate = arg_1_3

	arg_1_3:register(arg_1_0, "rpc_to_client_spawn_player")
end

HeroSpawnerHandler.destroy = function (arg_2_0)
	arg_2_0.network_event_delegate:unregister(arg_2_0)
end

HeroSpawnerHandler.spawn_hero_request = function (arg_3_0, arg_3_1, arg_3_2)
	if arg_3_0.pending_profile_request then
		return false
	end

	arg_3_0.peer_id = Network.peer_id()
	arg_3_0.player = arg_3_1
	arg_3_0.hero_name = arg_3_2
	arg_3_0.hero_index = FindProfileIndex(arg_3_2)
	arg_3_0.result = nil
	arg_3_0.request_id = arg_3_0.request_id + 1

	Managers.transition:fade_in(2, callback(arg_3_0, "start"))

	arg_3_0.hero_spawner_faded_in = true

	return arg_3_0.request_id
end

HeroSpawnerHandler.start = function (arg_4_0)
	local var_4_0 = arg_4_0.player
	local var_4_1 = var_4_0.player_unit

	if var_4_1 then
		local var_4_2 = Unit.world_position(var_4_1, 0)
		local var_4_3 = Unit.world_rotation(var_4_1, 0)

		var_4_0:set_spawn_position_rotation(var_4_2, var_4_3)

		arg_4_0.despawning_player_unit = var_4_0.player_unit

		Managers.state.spawn:delayed_despawn(var_4_0)
	else
		arg_4_0.profile_synchronizer:request_select_profile(arg_4_0.hero_index, var_4_0:local_player_id())
	end

	arg_4_0.pending_profile_request = true
end

HeroSpawnerHandler.update = function (arg_5_0, arg_5_1)
	if arg_5_0.pending_profile_request then
		local var_5_0 = arg_5_0.profile_synchronizer

		if arg_5_0.despawning_player_unit then
			if not Unit.alive(arg_5_0.despawning_player_unit) then
				var_5_0:request_select_profile(arg_5_0.hero_index, arg_5_0.player:local_player_id())

				arg_5_0.hero_index = nil
				arg_5_0.despawning_player_unit = nil

				if arg_5_0.is_server then
					Managers.state.network.network_server:peer_despawned_player(arg_5_0.peer_id)
				end
			end
		else
			local var_5_1, var_5_2 = var_5_0:profile_request_result()
			local var_5_3 = arg_5_0.player:local_player_id()

			assert(not var_5_1 or var_5_3 == var_5_2, "Local player id mismatch between ui and request.")

			if var_5_1 == "success" then
				local var_5_4 = arg_5_0.peer_id
				local var_5_5 = var_5_0:profile_by_peer(var_5_4, var_5_3)

				arg_5_0.player:set_profile_index(var_5_5)
				arg_5_0:save_selected_profile(var_5_5)

				arg_5_0.result = "success"

				var_5_0:clear_profile_request_result()

				arg_5_0.pending_profile_request = nil
			elseif var_5_1 then
				arg_5_0.result = "failed"

				var_5_0:clear_profile_request_result()

				arg_5_0.pending_profile_request = nil
			end
		end
	end
end

HeroSpawnerHandler.save_selected_profile = function (arg_6_0, arg_6_1)
	local var_6_0 = Managers.save

	SaveData.wanted_profile_index = arg_6_1

	var_6_0:auto_save(SaveFileName, SaveData, nil)
end

HeroSpawnerHandler.query_result = function (arg_7_0, arg_7_1)
	fassert(arg_7_1 == arg_7_0.request_id, "HeroSpawnerHandler:query_result with invalid request_id")

	return arg_7_0.result
end

HeroSpawnerHandler.rpc_to_client_spawn_player = function (arg_8_0, arg_8_1, arg_8_2, arg_8_3, arg_8_4, arg_8_5, arg_8_6, arg_8_7)
	if arg_8_0.hero_spawner_faded_in then
		Managers.transition:fade_out(1)

		arg_8_0.hero_spawner_faded_in = false
	end
end
