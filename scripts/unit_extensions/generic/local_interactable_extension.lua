-- chunkname: @scripts/unit_extensions/generic/local_interactable_extension.lua

LocalInteractableExtension = class(LocalInteractableExtension)

LocalInteractableExtension.init = function (self, arg_1_1, arg_1_2, arg_1_3)
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
	fassert(InteractionDefinitions[self.interactable_type], "Missing definition for interaction of type '%s'", self.interactable_type)
	fassert(not InteractionDefinitions[self.interactable_type].server, "Interactable of type '%s' contains server logic but is used in a local only interactable.", self.interactable_type)
end

LocalInteractableExtension.destroy = function (arg_2_0)
	-- function 2
	return
end

LocalInteractableExtension.interaction_type = function (self)
	-- function 3
	return self.interactable_type
end

LocalInteractableExtension.local_only = function (arg_4_0)
	-- function 4
	return true
end

LocalInteractableExtension.set_interactable_type = function (self, arg_5_1)
	-- function 5
	self.interactable_type = arg_5_1
end

LocalInteractableExtension.set_is_being_interacted_with = function (self, arg_6_1, arg_6_2)
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

LocalInteractableExtension.is_being_interacted_with = function (self)
	-- function 7
	return self.interactor_unit
end

LocalInteractableExtension.is_enabled = function (self)
	-- function 8
	return self._enabled
end

LocalInteractableExtension.set_enabled = function (self, arg_9_1)
	-- function 9
	self._enabled = arg_9_1
end

LocalInteractableExtension.override_interactable_action = function (self)
	-- function 10
	return self._override_interactable_action
end
