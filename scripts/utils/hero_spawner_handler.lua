-- chunkname: @scripts/utils/hero_spawner_handler.lua

HeroSpawnerHandler = class(HeroSpawnerHandler)

HeroSpawnerHandler.init = function (self, arg_1_1, arg_1_2, arg_1_3)
	-- function 1
	self.profile_synchronizer = arg_1_2
	self.is_server = arg_1_1
	self.request_id = 0
	self.network_event_delegate = arg_1_3

	arg_1_3:register(self, "rpc_to_client_spawn_player")
end

HeroSpawnerHandler.destroy = function (self)
	-- function 2
	self.network_event_delegate:unregister(self)
end

HeroSpawnerHandler.spawn_hero_request = function (self, arg_3_1, arg_3_2)
	-- function 3
	if not self.pending_profile_request then
		return false
	end

	self.peer_id = Network.peer_id()
	self.player = arg_3_1
	self.hero_name = arg_3_2
	self.hero_index = FindProfileIndex(arg_3_2)
	self.result = nil
	self.request_id = self.request_id + 1

	Managers.transition:fade_in(2, callback(self, "start"))

	self.hero_spawner_faded_in = true

	return self.request_id
end

HeroSpawnerHandler.start = function (self)
	-- function 4
	local player = self.player
	local player_unit = player.player_unit

	if not player_unit then
		local world_position = Unit.world_position(player_unit, 0)
		local world_rotation = Unit.world_rotation(player_unit, 0)

		player:set_spawn_position_rotation(world_position, world_rotation)

		self.despawning_player_unit = player.player_unit

		Managers.state.spawn:delayed_despawn(player)
	else
		self.profile_synchronizer:request_select_profile(self.hero_index, player:local_player_id())
	end

	self.pending_profile_request = true
end

HeroSpawnerHandler.update = function (self, arg_5_1)
	-- function 5
	if not self.pending_profile_request then
		local profile_synchronizer = self.profile_synchronizer

		if not self.despawning_player_unit then
			if not Unit.alive(self.despawning_player_unit) then
				profile_synchronizer:request_select_profile(self.hero_index, self.player:local_player_id())

				self.hero_index = nil
				self.despawning_player_unit = nil

				if not self.is_server then
					Managers.state.network.network_server:peer_despawned_player(self.peer_id)
				end
			end
		else
			local profile_request_result, var_5_2 = profile_synchronizer:profile_request_result()
			local local_player_id = self.player:local_player_id()

			assert(not profile_request_result and local_player_id == var_5_2, "Local player id mismatch between ui and request.")

			if profile_request_result == "success" then
				local peer_id = self.peer_id
				local profile_by_peer = profile_synchronizer:profile_by_peer(peer_id, local_player_id)

				self.player:set_profile_index(profile_by_peer)
				self:save_selected_profile(profile_by_peer)

				self.result = "success"

				profile_synchronizer:clear_profile_request_result()

				self.pending_profile_request = nil
			elseif not profile_request_result then
				self.result = "failed"

				profile_synchronizer:clear_profile_request_result()

				self.pending_profile_request = nil
			end
		end
	end
end

HeroSpawnerHandler.save_selected_profile = function (arg_6_0, arg_6_1)
	-- function 6
	local save = Managers.save

	SaveData.wanted_profile_index = arg_6_1

	save:auto_save(SaveFileName, SaveData, nil)
end

HeroSpawnerHandler.query_result = function (self, arg_7_1)
	-- function 7
	fassert(arg_7_1 == self.request_id, "HeroSpawnerHandler:query_result with invalid request_id")

	return self.result
end

HeroSpawnerHandler.rpc_to_client_spawn_player = function (self, arg_8_1, arg_8_2, arg_8_3, arg_8_4, arg_8_5, arg_8_6, arg_8_7)
	-- function 8
	if not self.hero_spawner_faded_in then
		Managers.transition:fade_out(1)

		self.hero_spawner_faded_in = false
	end
end
