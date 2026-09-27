-- chunkname: @scripts/unit_extensions/objectives/base_objective_extension.lua

BaseObjectiveExtension = class(BaseObjectiveExtension)
BaseObjectiveExtension.NAME = "BaseObjectiveExtension"

BaseObjectiveExtension.init = function (self, arg_1_1, arg_1_2, arg_1_3)
	-- function 1
	self._is_server = arg_1_1.is_server
	self._unit = arg_1_2
	self._world = arg_1_1.world

	local objective_name = arg_1_3.objective_name

	objective_name = objective_name or Unit.get_data(arg_1_2, "objective_id")
	self._objective_name = objective_name
	self._objecive_system = Managers.state.entity:system("objective_system")

	local _objective_name = self._objective_name

	if not _objective_name then
		_objective_name = Unit.get_data(arg_1_2, "versus_objective_id")
		_objective_name = _objective_name or Unit.get_data(arg_1_2, "weave_objective_id")
	end

	self._objective_name = _objective_name

	assert(self._objective_name, "[BaseObjectiveExtension] Missing objective name")

	self._audio_system = Managers.state.entity:system("audio_system")
	self._wwise_world = Managers.world:wwise_world(self._world)

	local scale = arg_1_3.scale

	scale = scale or Vector3(1, 1, 1)
	self._scale = scale
	self._num_sections = 1
	self._current_section = 0
	self._percentage = 0
	self._cached_value = 0

	Unit.set_local_scale(arg_1_2, 0, self._scale)
end

BaseObjectiveExtension.set_objective_data = function (self, arg_2_1)
	-- function 2
	self._objective_type = arg_2_1.objective_type
	self._objective_tag = arg_2_1.objective_tag
	self._on_complete_func = arg_2_1.on_complete_func

	local description = arg_2_1.description

	description = description or "unlocalized_description"
	self._description = description
	self._display_name = arg_2_1.display_name

	local objective_type = arg_2_1.objective_type

	objective_type = objective_type or "icons_placeholder"
	self._objective_icon = objective_type

	local score_for_completion = arg_2_1.score_for_completion

	score_for_completion = score_for_completion or 0
	self._score_for_completion = score_for_completion

	local time_for_completion = arg_2_1.time_for_completion

	time_for_completion = time_for_completion or 0
	self._time_for_completion = time_for_completion
	self._on_last_leaf_complete_sound_event = arg_2_1.on_last_leaf_complete_sound_event
	self._on_leaf_complete_sound_event = arg_2_1.on_leaf_complete_sound_event
	self._on_section_progress_sound_event = arg_2_1.on_section_progress_sound_event
	self._always_show_objective_marker = arg_2_1.always_show_objective_marker

	self:_set_objective_data(arg_2_1)
end

BaseObjectiveExtension.activate = function (self)
	-- function 3
	self:_activate()
	self:_store_position()
	self:_store_local_player()

	self._activated = true
end

BaseObjectiveExtension.objective_tag = function (self)
	-- function 4
	return self._objective_tag
end

BaseObjectiveExtension._store_local_player = function (self)
	-- function 5
	if not DEDICATED_SERVER then
		self:_local_side()
	end
end

BaseObjectiveExtension.sync_objective = function (self, arg_6_1, arg_6_2)
	-- function 6
	self._game_object_id = arg_6_1
end

BaseObjectiveExtension.desync_objective = function (self)
	-- function 7
	self._game_object_id = nil
end

BaseObjectiveExtension._local_side = function (self)
	-- function 8
	local local_player = Managers.player:local_player()

	if not local_player then
		local network_id = local_player:network_id()
		local local_player_id = local_player:local_player_id()
		local get_party_from_player_id = Managers.party:get_party_from_player_id(network_id, local_player_id)

		if not get_party_from_player_id then
			self._local_side_cached = Managers.state.side.side_by_party[get_party_from_player_id]
		end
	end

	return self._local_side_cached
end

BaseObjectiveExtension.complete = function (self, arg_9_1, arg_9_2, arg_9_3)
	-- function 9
	if not self._is_server and not self._on_complete_func then
		self._on_complete_func(self._unit)
	end

	if not DEDICATED_SERVER then
		local _on_leaf_complete_sound_event = self._on_leaf_complete_sound_event
		local _on_last_leaf_complete_sound_event = self._on_last_leaf_complete_sound_event

		_on_last_leaf_complete_sound_event = _on_last_leaf_complete_sound_event or _on_leaf_complete_sound_event

		if not arg_9_3 and not _on_last_leaf_complete_sound_event then
			local var_9_2 = _on_last_leaf_complete_sound_event[self:_local_side():name()]

			if not var_9_2 then
				self:play_local_sound(var_9_2)
			end
		elseif not _on_leaf_complete_sound_event and not arg_9_2 then
			local var_9_3 = _on_leaf_complete_sound_event[self:_local_side():name()]

			if not var_9_3 then
				self:play_local_sound(var_9_3)
			end
		end
	end

	self:deactivate()
end

BaseObjectiveExtension.deactivate = function (self)
	-- function 10
	self:_deactivate()

	self._percentage = 1
	self._game_object_id = nil
	self._activated = false
end

BaseObjectiveExtension.play_local_sound = function (self, arg_11_1)
	-- function 11
	WwiseWorld.trigger_event(self._wwise_world, arg_11_1)
end

BaseObjectiveExtension.play_local_unit_sound = function (self, arg_12_1)
	-- function 12
	WwiseUtils.trigger_unit_event(self._world, arg_12_1, self._unit, 0)
end

BaseObjectiveExtension.play_unit_sound = function (self, arg_13_1)
	-- function 13
	self._audio_system:play_audio_unit_event(arg_13_1, self._unit)
end

BaseObjectiveExtension.unit = function (self)
	-- function 14
	return self._unit
end

BaseObjectiveExtension.display_name = function (self)
	-- function 15
	return self._display_name
end

BaseObjectiveExtension.is_stacking_objective = function (arg_16_0)
	-- function 16
	return false
end

BaseObjectiveExtension.update = function (self, arg_17_1, arg_17_2)
	-- function 17
	if not script_data.testify and not self.update_testify then
		self:update_testify(arg_17_1, arg_17_2)
	end

	if not self._activated then
		return
	end

	if not self._is_server then
		self:_server_update(arg_17_1, arg_17_2)
	else
		self:_client_update(arg_17_1, arg_17_2)
	end
end

BaseObjectiveExtension.on_section_completed = function (self)
	-- function 18
	self._current_section = self._current_section + 1

	Managers.state.event:trigger("obj_objective_section_completed", self)

	if not self:is_done() then
		return
	end

	local _on_section_progress_sound_event = self._on_section_progress_sound_event

	if not _on_section_progress_sound_event then
		local _local_side = self:_local_side()

		if not _local_side then
			local var_18_2 = _on_section_progress_sound_event[_local_side:name()]

			if not var_18_2 then
				self:play_local_sound(var_18_2)
			end
		end
	end
end

BaseObjectiveExtension.server_set_value = function (self, arg_19_1)
	-- function 19
	local game_session = Network.game_session()

	if not game_session then
		GameSession.set_game_object_field(game_session, self._game_object_id, "value", math.clamp01(arg_19_1))
	end
end

BaseObjectiveExtension.client_get_value = function (self)
	-- function 20
	local game_session = Network.game_session()

	if not (not game_session and self._game_object_id) then
		return self._cached_value
	end

	self._cached_value = GameSession.game_object_field(game_session, self._game_object_id, "value")

	return self._cached_value
end

BaseObjectiveExtension._store_position = function (self)
	-- function 21
	local local_position = Unit.local_position(self._unit, 0)

	self._position = Vector3Box(local_position)
end

BaseObjectiveExtension._activate = function (arg_22_0)
	-- function 22
	error("This function needs to be overwritten")
end

BaseObjectiveExtension._deactivate = function (arg_23_0)
	-- function 23
	error("This function needs to be overwritten")
end

BaseObjectiveExtension._server_update = function (arg_24_0, arg_24_1, arg_24_2)
	-- function 24
	error("This function needs to be overwritten")
end

BaseObjectiveExtension._client_update = function (arg_25_0, arg_25_1, arg_25_2)
	-- function 25
	error("This function needs to be overwritten")
end

BaseObjectiveExtension.get_percentage_done = function (arg_26_0)
	-- function 26
	error("This function needs to be overwritten")
end

BaseObjectiveExtension.objective_name = function (self)
	-- function 27
	return self._objective_name
end

BaseObjectiveExtension.get_current_section = function (self)
	-- function 28
	return self._current_section
end

BaseObjectiveExtension.get_total_sections = function (self)
	-- function 29
	return self._num_sections
end

BaseObjectiveExtension.get_num_sections_left = function (self)
	-- function 30
	return self._current_section - self._num_sections
end

BaseObjectiveExtension.get_time_per_section = function (self)
	-- function 31
	return self._time_per_section
end

BaseObjectiveExtension.get_score_per_section = function (self)
	-- function 32
	return self._score_per_section
end

BaseObjectiveExtension.get_time_for_completion = function (self)
	-- function 33
	return self._time_for_completion
end

BaseObjectiveExtension.get_score_for_completion = function (self)
	-- function 34
	return self._score_for_completion
end

BaseObjectiveExtension.get_position = function (self)
	-- function 35
	if not self._position then
		return self._position:unbox()
	else
		return Unit.world_position(self._unit, 0)
	end
end

BaseObjectiveExtension.is_optional = function (self)
	-- function 36
	return self._optional
end

BaseObjectiveExtension.description = function (self)
	-- function 37
	return self._description
end

BaseObjectiveExtension.objective_icon = function (self)
	-- function 38
	return self._objective_icon
end

BaseObjectiveExtension.objective_type = function (self)
	-- function 39
	return self._objective_type
end

BaseObjectiveExtension.is_done = function (self)
	-- function 40
	return self:get_percentage_done() >= 1
end

BaseObjectiveExtension.is_active = function (self)
	-- function 41
	return self._activated
end

BaseObjectiveExtension.always_show_objective_marker = function (self)
	-- function 42
	return self._always_show_objective_marker
end
