-- chunkname: @scripts/unit_extensions/generic/generic_husk_interactor_extension.lua

GenericHuskInteractorExtension = class(GenericHuskInteractorExtension)

GenericHuskInteractorExtension.init = function (self, arg_1_1, arg_1_2, arg_1_3)
	-- function 1
	self.world = arg_1_1.world
	self.unit = arg_1_2
	self.state = "waiting_to_interact"
	self.interaction_context = {
		data = {
			is_husk = true,
			dice_keeper = arg_1_1.dice_keeper,
			statistics_db = arg_1_1.statistics_db
		}
	}
	self.is_server = Managers.player.is_server

	self.interactable_unit_destroy_callback = function (arg_2_0)
		-- function 2
		local time = Managers.time:time("game")

		self:_stop_interaction(arg_2_0, time)
	end
end

GenericHuskInteractorExtension.game_object_unit_destroyed = function (self)
	-- function 3
	if not Managers.state.network:game() and not self.is_server then
		local interactable_unit = self.interaction_context.interactable_unit

		if not (not Unit.alive(interactable_unit) and self.state ~= "doing_interaction") then
			InteractionHelper.printf("[GenericHuskInteractorExtension] stopping due to game_object_unit_destroyed")
			InteractionHelper:complete_interaction(self.unit, interactable_unit, InteractionResult.FAILURE)
		end
	end
end

GenericHuskInteractorExtension.destroy = function (self)
	-- function 4
	local interactable_unit = self.interaction_context.interactable_unit

	if not Unit.alive(interactable_unit) then
		Managers.state.unit_spawner:remove_destroy_listener(interactable_unit, "interactable_unit_for_husk")
	end
end

GenericHuskInteractorExtension.update = function (self, arg_5_1, arg_5_2, arg_5_3, arg_5_4, arg_5_5)
	-- function 5
	local world = self.world
	local interaction_context = self.interaction_context
	local interactable_unit = interaction_context.interactable_unit
	local data = interaction_context.data

	data.is_server = self.is_server

	local interaction_type = interaction_context.interaction_type
	local var_5_5 = InteractionDefinitions[interaction_type]
	local config

	if not var_5_5 then
		config = var_5_5.config

		if not config then
			-- Nothing
		end
	end

	config = nil

	::label_5_0::

	if self.state == "starting_interaction" then
		var_5_5.client.start(world, arg_5_1, interactable_unit, data, config, arg_5_5)

		if not self.is_server then
			var_5_5.server.start(world, arg_5_1, interactable_unit, data, config, arg_5_5)
		end

		interaction_context.previous_state = self.state
		self.state = "doing_interaction"
	end

	if self.state == "doing_interaction" then
		var_5_5.client.update(world, arg_5_1, interactable_unit, data, config, arg_5_3, arg_5_5)

		if not self.is_server then
			local update = var_5_5.server.update(world, arg_5_1, interactable_unit, data, config, arg_5_3, arg_5_5)

			interaction_context.result = update

			if update ~= InteractionResult.ONGOING then
				InteractionHelper:complete_interaction(arg_5_1, interactable_unit, update)
			end
		end
	end
end

GenericHuskInteractorExtension._stop_interaction = function (self, arg_6_1, arg_6_2)
	-- function 6
	Managers.state.unit_spawner:remove_destroy_listener(arg_6_1, "interactable_unit_for_husk")

	local world = self.world
	local unit = self.unit
	local interaction_context = self.interaction_context
	local data = interaction_context.data

	data.is_server = self.is_server

	local interaction_type = interaction_context.interaction_type
	local var_6_5 = InteractionDefinitions[interaction_type]
	local config

	if not var_6_5 then
		config = var_6_5.config

		if not config then
			-- Nothing
		end
	end

	config = nil

	::label_6_0::

	local local_only = interaction_context.local_only
	local game_object_or_level_id, var_6_9 = Managers.state.network:game_object_or_level_id(arg_6_1)

	if not (var_6_9 or game_object_or_level_id ~= nil) then
		InteractionHelper.printf("[GenericUnitInteractorExtension] game object doesnt exist, changing result from %s to %s", InteractionResult[interaction_context.result], InteractionResult[InteractionResult.FAILURE])

		interaction_context.result = InteractionResult.FAILURE
	end

	local result = interaction_context.result

	if not (result == InteractionResult.ONGOING or result ~= nil) then
		result = InteractionResult.FAILURE
		interaction_context.result = result
	end

	InteractionHelper.printf("[GenericHuskInteractorExtension] Stopping interaction %s with result %s", interaction_type, InteractionResult[result])
	var_6_5.client.stop(world, unit, arg_6_1, data, config, arg_6_2, result)

	if not (not self.is_server and local_only) then
		var_6_5.server.stop(world, unit, arg_6_1, data, config, arg_6_2, result)
	end

	interaction_context.previous_state = self.state
	self.state = "waiting_to_interact"
end

GenericHuskInteractorExtension.is_interacting = function (self)
	-- function 7
	local interaction_type = self.interaction_context.interaction_type

	return self.state ~= "waiting_to_interact", interaction_type
end

GenericHuskInteractorExtension.is_stopping = function (self)
	-- function 8
	return self.state == "stopping_interaction"
end

GenericHuskInteractorExtension.interactable_unit = function (self)
	-- function 9
	assert(self:is_interacting(), "Attempted to get interactable unit when interactor unit wasn't interacting.")

	return self.interaction_context.interactable_unit
end

GenericHuskInteractorExtension.hot_join_sync = function (self, arg_10_1)
	-- function 10
	if not self:is_interacting() then
		return
	end

	local network = Managers.state.network
	local interaction_context = self.interaction_context
	local var_10_2 = NetworkLookup.interaction_states[self.state]
	local var_10_3 = NetworkLookup.interactions[interaction_context.interaction_type]
	local game_object_or_level_id, var_10_5 = network:game_object_or_level_id(interaction_context.interactable_unit)
	local data = interaction_context.data
	local start_time = data.start_time
	local duration = data.duration

	duration = duration or 0

	local unit_game_object_id = network:unit_game_object_id(self.unit)
	local var_10_10 = PEER_ID_TO_CHANNEL[arg_10_1]

	RPC.rpc_sync_interaction_state(var_10_10, unit_game_object_id, var_10_2, var_10_3, game_object_or_level_id, start_time, duration, var_10_5)
end

GenericHuskInteractorExtension.set_interaction_context = function (self, arg_11_1, arg_11_2, arg_11_3, arg_11_4, arg_11_5)
	-- function 11
	InteractionHelper.printf("[GenericHuskInteractorExtension] set_interaction_context %s %s %s", arg_11_1, arg_11_2, tostring(arg_11_3))

	self.interaction_context.previous_state = self.state
	self.state = arg_11_1
	self.interaction_context.data.start_time = arg_11_4
	self.interaction_context.data.duration = arg_11_5
	self.interaction_context.interactable_unit = arg_11_3
	self.interaction_context.interaction_type = arg_11_2
	self.interaction_context.result = InteractionResult.ONGOING

	ScriptUnit.extension(arg_11_3, "interactable_system"):set_is_being_interacted_with(self.unit)
end

GenericHuskInteractorExtension.interaction_approved = function (self, arg_12_1, arg_12_2)
	-- function 12
	if not Unit.alive(arg_12_2) then
		InteractionHelper.printf("[GenericHuskInteractorExtension] interaction_approved interactable_unit no longer alive interaction_type:%s", arg_12_1)

		return
	end

	InteractionHelper.printf("[GenericHuskInteractorExtension] interaction_approved %s %s", arg_12_1, tostring(arg_12_2))

	self.interaction_context.previous_state = self.state
	self.state = "starting_interaction"

	local interaction_context = self.interaction_context

	interaction_context.interaction_type = arg_12_1
	interaction_context.interactable_unit = arg_12_2
	interaction_context.result = InteractionResult.ONGOING

	local data = interaction_context.data

	data.duration = InteractionDefinitions[arg_12_1].config.duration
	data.start_time = Managers.time:time("game")

	Managers.state.unit_spawner:add_destroy_listener(arg_12_2, "interactable_unit_for_husk", self.interactable_unit_destroy_callback)
end

GenericHuskInteractorExtension.interaction_completed = function (self, arg_13_1)
	-- function 13
	local state = self.state

	InteractionHelper.printf("[GenericHuskInteractorExtension] interaction_completed during state %s with result %s", state, InteractionResult[arg_13_1])
	assert(state ~= "waiting_to_interact", "Was in wrong state when getting interaction completed.")

	self.interaction_context.result = arg_13_1

	local interactable_unit = self.interaction_context.interactable_unit
	local time = Managers.time:time("game")

	self:_stop_interaction(interactable_unit, time)
end
