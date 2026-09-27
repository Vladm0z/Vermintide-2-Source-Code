-- chunkname: @scripts/unit_extensions/generic/generic_unit_interactable_extension.lua

GenericUnitInteractableExtension = class(GenericUnitInteractableExtension)

GenericUnitInteractableExtension.init = function (self, arg_1_1, arg_1_2, arg_1_3)
	-- function 1
	self.unit = arg_1_2
	self._is_level_object = Unit.level(arg_1_2) ~= nil

	local get_data = Unit.get_data(arg_1_2, "interaction_data", "interaction_type")

	get_data = get_data or "player_generic"
	self.interactable_type = get_data
	self._override_interactable_action = Unit.get_data(arg_1_2, "override_interactable_action")
	self.interactor_unit = nil
	self._enabled = true
	self.num_times_successfully_completed = 0
	self.interaction_result = nil

	fassert(self.interactable_type, "Unit: %s missing interaction_type in its unit data, should it have an interaction extension?", arg_1_2)
end

GenericUnitInteractableExtension.destroy = function (arg_2_0)
	-- function 2
	return
end

GenericUnitInteractableExtension.interaction_type = function (self)
	-- function 3
	return self.interactable_type
end

GenericUnitInteractableExtension.local_only = function (arg_4_0)
	-- function 4
	return false
end

GenericUnitInteractableExtension.set_interactable_type = function (self, arg_5_1)
	-- function 5
	self.interactable_type = arg_5_1
end

GenericUnitInteractableExtension.set_is_being_interacted_with = function (self, arg_6_1, arg_6_2)
	-- function 6
	local unit = self.unit
	local interactable_type = self.interactable_type

	if not self.interactor_unit then
		fassert(arg_6_1 == nil, "Interactor unit was already set.")

		local interactor_unit = self.interactor_unit
		local str = "lua_interaction_stopped_" .. interactable_type .. "_" .. InteractionResult[arg_6_2]

		Unit.flow_event(unit, str)

		if not (not NetworkUnit.is_network_unit(interactor_unit) and NetworkUnit.is_husk_unit(interactor_unit)) then
			local str_2 = "lua_interaction_stopped_local_interactor_" .. interactable_type .. "_" .. InteractionResult[arg_6_2]

			Unit.flow_event(unit, str_2)
		end
	else
		fassert(arg_6_1 ~= nil, "Interactor unit was already nil.")
		Unit.set_flow_variable(unit, "lua_interaction_started_unit", arg_6_1)

		local str_3 = "lua_interaction_started_" .. interactable_type

		Unit.flow_event(unit, str_3)
	end

	self.interactor_unit = arg_6_1
	self.interaction_result = arg_6_2
end

GenericUnitInteractableExtension.is_being_interacted_with = function (self)
	-- function 7
	return self.interactor_unit
end

GenericUnitInteractableExtension.hot_join_sync = function (self, arg_8_1)
	-- function 8
	local unit = self.unit

	if not Unit.get_data(unit, "interaction_data", "only_once") then
		local game_object_or_level_id = Managers.state.network:game_object_or_level_id(self.unit)
		local get_data = Unit.get_data(unit, "interaction_data", "used")

		get_data = get_data or false

		local get_data_2 = Unit.get_data(unit, "interaction_data", "individual_pickup")

		get_data_2 = get_data_2 or false

		if get_data_2 or not get_data then
			local var_8_4 = PEER_ID_TO_CHANNEL[arg_8_1]

			RPC.rpc_sync_interactable_used_state(var_8_4, game_object_or_level_id, self._is_level_object, get_data)
		end
	end
end

GenericUnitInteractableExtension.is_enabled = function (self)
	-- function 9
	return self._enabled
end

GenericUnitInteractableExtension.set_enabled = function (self, arg_10_1)
	-- function 10
	self._enabled = arg_10_1
end

GenericUnitInteractableExtension.override_interactable_action = function (self)
	-- function 11
	return self._override_interactable_action
end
