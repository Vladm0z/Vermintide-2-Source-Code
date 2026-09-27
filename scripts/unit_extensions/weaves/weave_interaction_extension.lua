-- chunkname: @scripts/unit_extensions/weaves/weave_interaction_extension.lua

WeaveInteractionExtension = class(WeaveInteractionExtension, BaseObjectiveExtension)
WeaveInteractionExtension.NAME = "WeaveInteractionExtension"

WeaveInteractionExtension.init = function (self, arg_1_1, arg_1_2, arg_1_3)
	-- function 1
	WeaveInteractionExtension.super.init(self, arg_1_1, arg_1_2, arg_1_3)

	self._on_start_func = arg_1_3.on_start_func
	self._on_interact_start_func = arg_1_3.on_interact_start_func
	self._on_interact_interupt_func = arg_1_3.on_interact_interupt_func
	self._on_interact_complete_func = arg_1_3.on_interact_complete_func
	self._on_progress_func = arg_1_3.on_progress_func
	self._on_complete_func = arg_1_3.on_complete_func

	local num_times_to_complete = arg_1_3.num_times_to_complete

	num_times_to_complete = num_times_to_complete or 1
	self._num_times_to_complete = num_times_to_complete

	local duration = arg_1_3.duration

	duration = duration or 5
	self._duration = duration
	self._audio_system = Managers.state.entity:system("audio_system")
	self._value = 0

	local terror_event_spawner_id = arg_1_3.terror_event_spawner_id

	Unit.set_data(arg_1_2, "terror_event_spawner_id", terror_event_spawner_id)
	Unit.set_data(arg_1_2, "interaction_data", "interaction_length", self._duration)

	self._max_value = self._duration * self._num_times_to_complete
end

WeaveInteractionExtension.extensions_ready = function (self)
	-- function 2
	self._interactable_extension = ScriptUnit.has_extension(self._unit, "interactable_system")
end

WeaveInteractionExtension.display_name = function (arg_3_0)
	-- function 3
	return "Interact with object"
end

WeaveInteractionExtension.initial_sync_data = function (self, arg_4_1)
	-- function 4
	arg_4_1.value = self:get_percentage_done()
end

WeaveInteractionExtension._set_objective_data = function (arg_5_0, arg_5_1)
	-- function 5
	return
end

WeaveInteractionExtension._activate = function (self)
	-- function 6
	local has_extension = ScriptUnit.has_extension(self._unit, "tutorial_system")

	if not has_extension then
		has_extension:set_active(true)
	end
end

WeaveInteractionExtension._deactivate = function (self)
	-- function 7
	local local_position = Unit.local_position(self._unit, 0)

	for i = 1, 3 do
		local num = math.random(-10, 10) / 10
		local num_2 = math.random(-10, 10) / 10
		local num_3 = math.random(-10, 10) / 10

		Managers.state.entity:system("objective_system"):weave_essence_handler():spawn_essence_unit(local_position + Vector3(0, 0, 0.5) + Vector3(num, num_2, num_3))
	end
end

WeaveInteractionExtension._server_update = function (self, arg_8_1, arg_8_2)
	-- function 8
	local interaction_result = self._interactable_extension.interaction_result
	local flag = false

	if not self._interactable_extension:is_being_interacted_with() then
		if interaction_result ~= self._interactable_state then
			if not self._on_start_func then
				self._on_start_func(self._unit)

				self._on_start_func = nil
			end

			if not self._on_interact_start_func then
				self._on_interact_start_func(self._unit)
			end
		else
			self._value = self._value + arg_8_1

			local flag_2 = true

			if not self._on_progress_func then
				self._on_progress_func(self._unit, self._value, self._max_value)
			end
		end

		self._interactable_state = interaction_result
	elseif not (interaction_result == self._interactable_state or self._interactable_state == 0) then
		self._value = self._interactable_extension.num_times_successfully_completed * self._duration

		local flag_3 = true

		if interaction_result == InteractionResult.SUCCESS then
			self._audio_system:play_audio_unit_event("emitter_rune_activate", self._unit)

			if not self._on_interact_complete_func then
				self._on_interact_complete_func(self._unit)
			end
		elseif interaction_result == InteractionResult.FAILURE or interaction_result == InteractionResult.USER_ENDED or not self._on_interact_interupt_func then
			self._on_interact_interupt_func(self._unit)
		end

		self._interactable_state = interaction_result
	elseif self._interactable_state ~= 0 then
		self._interactable_state = 0
	end

	self:server_set_value(self:get_percentage_done())
end

WeaveInteractionExtension._client_update = function (arg_9_0, arg_9_1, arg_9_2)
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
