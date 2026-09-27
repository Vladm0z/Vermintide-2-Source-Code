-- chunkname: @scripts/entity_system/systems/dialogues/dialogue_flow_events.lua

DialogueSystemFlow = class(DialogueSystemFlow)

DialogueSystemFlow.init = function (self, arg_1_1, arg_1_2)
	-- function 1
	self._current_sound_event_subtitles = {}
	self._hud_system = arg_1_2
	self._wwise_world = arg_1_1
end

DialogueSystemFlow.trigger_sound_event_with_subtitles = function (arg_2_0, arg_2_1, arg_2_2, arg_2_3, arg_2_4, arg_2_5)
	-- function 2
	local tbl = {
		subtitle_event = arg_2_2,
		speaker_name = arg_2_3,
		sound_event = arg_2_1,
		source_unit = arg_2_4
	}

	if not arg_2_4 and not arg_2_5 and not Unit.has_node(arg_2_4, arg_2_5) then
		tbl.unit_node_index = Unit.node(arg_2_4, arg_2_5)
	else
		tbl.unit_node_index = 0
	end

	arg_2_0._current_sound_event_subtitles[#arg_2_0._current_sound_event_subtitles + 1] = tbl
end

DialogueSystemFlow.update_sound_event_subtitles = function (self)
	-- function 3
	if not table.is_empty(self._current_sound_event_subtitles) then
		return
	end

	local var_3_0 = self._current_sound_event_subtitles[1]
	local speaker_name = var_3_0.speaker_name
	local subtitle_event = var_3_0.subtitle_event
	local sound_event = var_3_0.sound_event
	local source_unit = var_3_0.source_unit
	local unit_node = var_3_0.unit_node

	if not var_3_0.has_started_playing then
		self._hud_system:add_subtitle(speaker_name, subtitle_event)

		local var_3_6

		if not source_unit then
			var_3_6 = WwiseWorld.trigger_event(self._wwise_world, sound_event, source_unit, unit_node)
		else
			var_3_6 = WwiseWorld.trigger_event(self._wwise_world, sound_event)
		end

		var_3_0.id = var_3_6
		var_3_0.has_started_playing = true
	elseif not (not var_3_0.id and WwiseWorld.is_playing(self._wwise_world, var_3_0.id)) then
		self._hud_system:remove_subtitle(speaker_name)
		table.remove(self._current_sound_event_subtitles, 1)
	end
end
