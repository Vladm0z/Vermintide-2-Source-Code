-- chunkname: @scripts/entity_system/systems/dialogues/dialogue_flow_events.lua

DialogueSystemFlow = class(DialogueSystemFlow)

DialogueSystemFlow.init = function (arg_1_0, arg_1_1, arg_1_2)
	arg_1_0._current_sound_event_subtitles = {}
	arg_1_0._hud_system = arg_1_2
	arg_1_0._wwise_world = arg_1_1
end

DialogueSystemFlow.trigger_sound_event_with_subtitles = function (arg_2_0, arg_2_1, arg_2_2, arg_2_3, arg_2_4, arg_2_5)
	local var_2_0 = {
		subtitle_event = arg_2_2,
		speaker_name = arg_2_3,
		sound_event = arg_2_1,
		source_unit = arg_2_4
	}

	if arg_2_4 and arg_2_5 and Unit.has_node(arg_2_4, arg_2_5) then
		var_2_0.unit_node_index = Unit.node(arg_2_4, arg_2_5)
	else
		var_2_0.unit_node_index = 0
	end

	arg_2_0._current_sound_event_subtitles[#arg_2_0._current_sound_event_subtitles + 1] = var_2_0
end

DialogueSystemFlow.update_sound_event_subtitles = function (arg_3_0)
	if table.is_empty(arg_3_0._current_sound_event_subtitles) then
		return
	end

	local var_3_0 = arg_3_0._current_sound_event_subtitles[1]
	local var_3_1 = var_3_0.speaker_name
	local var_3_2 = var_3_0.subtitle_event
	local var_3_3 = var_3_0.sound_event
	local var_3_4 = var_3_0.source_unit
	local var_3_5 = var_3_0.unit_node

	if not var_3_0.has_started_playing then
		arg_3_0._hud_system:add_subtitle(var_3_1, var_3_2)

		local var_3_6

		if var_3_4 then
			var_3_6 = WwiseWorld.trigger_event(arg_3_0._wwise_world, var_3_3, var_3_4, var_3_5)
		else
			var_3_6 = WwiseWorld.trigger_event(arg_3_0._wwise_world, var_3_3)
		end

		var_3_0.id = var_3_6
		var_3_0.has_started_playing = true
	elseif var_3_0.id and not WwiseWorld.is_playing(arg_3_0._wwise_world, var_3_0.id) then
		arg_3_0._hud_system:remove_subtitle(var_3_1)
		table.remove(arg_3_0._current_sound_event_subtitles, 1)
	end
end
