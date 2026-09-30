-- chunkname: @scripts/unit_extensions/weaves/weave_interaction_extension.lua

WeaveInteractionExtension = class(WeaveInteractionExtension, BaseObjectiveExtension)
WeaveInteractionExtension.NAME = "WeaveInteractionExtension"

WeaveInteractionExtension.init = function (self, extension_init_context, unit, extension_init_data)
	-- function 1
	WeaveInteractionExtension.super.init(self, extension_init_context, unit, extension_init_data)

	self._on_start_func = extension_init_data.on_start_func
	self._on_interact_start_func = extension_init_data.on_interact_start_func
	self._on_interact_interupt_func = extension_init_data.on_interact_interupt_func
	self._on_interact_complete_func = extension_init_data.on_interact_complete_func
	self._on_progress_func = extension_init_data.on_progress_func
	self._on_complete_func = extension_init_data.on_complete_func
	self._num_times_to_complete = extension_init_data.num_times_to_complete
	self._duration = extension_init_data.duration
	self._audio_system = Managers.state.entity:system("audio_system")
	self._value = 0

	local terror_event_spawner_id = extension_init_data.terror_event_spawner_id

	Unit.set_data(unit, "terror_event_spawner_id", terror_event_spawner_id)
	Unit.set_data(unit, "interaction_data", "interaction_length", self._duration)

	self._max_value = self._duration * self._num_times_to_complete
end

WeaveInteractionExtension.extensions_ready = function (self)
	-- function 2
	self._interactable_extension = ScriptUnit.has_extension(self._unit, "interactable_system")
end

WeaveInteractionExtension.display_name = function (self)
	-- function 3
	return "Interact with object"
end

WeaveInteractionExtension.initial_sync_data = function (self, game_object_data_table)
	-- function 4
	game_object_data_table.value = self:get_percentage_done()
end

WeaveInteractionExtension._set_objective_data = function (self, objective_data)
	-- function 5
	return
end

WeaveInteractionExtension._activate = function (self)
	-- function 6
	local extension = ScriptUnit.has_extension(self._unit, "tutorial_system")

	if extension then
		extension:set_active(true)
	end
end

WeaveInteractionExtension._deactivate = function (self)
	-- function 7
	local position = Unit.local_position(self._unit, 0)

	for i = 1, 3 do
		local x_offset = math.random(-10, 10) / 10
		local y_offset = math.random(-10, 10) / 10
		local z_offset = math.random(-10, 10) / 10
		local objective_system = Managers.state.entity:system("objective_system")
		local weave_essence_handler = objective_system:weave_essence_handler()

		weave_essence_handler:spawn_essence_unit(position + Vector3(0, 0, 0.5) + Vector3(x_offset, y_offset, z_offset))
	end
end

WeaveInteractionExtension._server_update = function (self, dt, t)
	-- function 8
	local interaction_result = self._interactable_extension.interaction_result
	local value_changed = false

	if self._interactable_extension:is_being_interacted_with() then
		if interaction_result ~= self._interactable_state then
			if self._on_start_func then
				self._on_start_func(self._unit)

				self._on_start_func = nil
			end

			if self._on_interact_start_func then
				self._on_interact_start_func(self._unit)
			end
		else
			self._value = self._value + dt
			value_changed = true

			if self._on_progress_func then
				self._on_progress_func(self._unit, self._value, self._max_value)
			end
		end

		self._interactable_state = interaction_result
	elseif interaction_result ~= self._interactable_state and self._interactable_state ~= 0 then
		local num_times_completed = self._interactable_extension.num_times_successfully_completed

		self._value = num_times_completed * self._duration
		value_changed = true

		if interaction_result == InteractionResult.SUCCESS then
			self._audio_system:play_audio_unit_event("emitter_rune_activate", self._unit)

			if self._on_interact_complete_func then
				self._on_interact_complete_func(self._unit)
			end
		elseif interaction_result == InteractionResult.FAILURE and self._on_interact_interupt_func or not (interaction_result == InteractionResult.FAILURE) and interaction_result == InteractionResult.USER_ENDED and self._on_interact_interupt_func then
			self._on_interact_interupt_func(self._unit)
		end

		self._interactable_state = interaction_result
	elseif self._interactable_state ~= 0 then
		self._interactable_state = 0
	end

	self:server_set_value(self:get_percentage_done())
end

WeaveInteractionExtension._client_update = function (self, dt, t)
	-- function 9
	return
end

WeaveInteractionExtension.is_done = function (self)
	-- function 10
	return self._interactable_extension.num_times_successfully_completed >= self._num_times_to_complete
end

WeaveInteractionExtension.get_percentage_done = function (self)
	-- function 11
	return math.clamp(self._value / self._max_value, 0, 1)
end
