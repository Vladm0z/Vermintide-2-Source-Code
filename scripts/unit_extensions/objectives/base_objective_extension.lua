-- chunkname: @scripts/unit_extensions/objectives/base_objective_extension.lua

BaseObjectiveExtension = class(BaseObjectiveExtension)
BaseObjectiveExtension.NAME = "BaseObjectiveExtension"

BaseObjectiveExtension.init = function (arg_1_0, arg_1_1, arg_1_2, arg_1_3)
	arg_1_0._is_server = arg_1_1.is_server
	arg_1_0._unit = arg_1_2
	arg_1_0._world = arg_1_1.world
	arg_1_0._objective_name = arg_1_3.objective_name or Unit.get_data(arg_1_2, "objective_id")
	arg_1_0._objecive_system = Managers.state.entity:system("objective_system")
	arg_1_0._objective_name = arg_1_0._objective_name or Unit.get_data(arg_1_2, "versus_objective_id") or Unit.get_data(arg_1_2, "weave_objective_id")

	assert(arg_1_0._objective_name, "[BaseObjectiveExtension] Missing objective name")

	arg_1_0._audio_system = Managers.state.entity:system("audio_system")
	arg_1_0._wwise_world = Managers.world:wwise_world(arg_1_0._world)
	arg_1_0._scale = arg_1_3.scale or Vector3(1, 1, 1)
	arg_1_0._num_sections = 1
	arg_1_0._current_section = 0
	arg_1_0._percentage = 0
	arg_1_0._cached_value = 0

	Unit.set_local_scale(arg_1_2, 0, arg_1_0._scale)
end

BaseObjectiveExtension.set_objective_data = function (arg_2_0, arg_2_1)
	arg_2_0._objective_type = arg_2_1.objective_type
	arg_2_0._objective_tag = arg_2_1.objective_tag
	arg_2_0._on_complete_func = arg_2_1.on_complete_func
	arg_2_0._description = arg_2_1.description or "unlocalized_description"
	arg_2_0._display_name = arg_2_1.display_name
	arg_2_0._objective_icon = arg_2_1.objective_type or "icons_placeholder"
	arg_2_0._score_for_completion = arg_2_1.score_for_completion or 0
	arg_2_0._time_for_completion = arg_2_1.time_for_completion or 0
	arg_2_0._on_last_leaf_complete_sound_event = arg_2_1.on_last_leaf_complete_sound_event
	arg_2_0._on_leaf_complete_sound_event = arg_2_1.on_leaf_complete_sound_event
	arg_2_0._on_section_progress_sound_event = arg_2_1.on_section_progress_sound_event
	arg_2_0._always_show_objective_marker = arg_2_1.always_show_objective_marker

	arg_2_0:_set_objective_data(arg_2_1)
end

BaseObjectiveExtension.activate = function (arg_3_0)
	arg_3_0:_activate()
	arg_3_0:_store_position()
	arg_3_0:_store_local_player()

	arg_3_0._activated = true
end

BaseObjectiveExtension.objective_tag = function (arg_4_0)
	return arg_4_0._objective_tag
end

BaseObjectiveExtension._store_local_player = function (arg_5_0)
	if not DEDICATED_SERVER then
		arg_5_0:_local_side()
	end
end

BaseObjectiveExtension.sync_objective = function (arg_6_0, arg_6_1, arg_6_2)
	arg_6_0._game_object_id = arg_6_1
end

BaseObjectiveExtension.desync_objective = function (arg_7_0)
	arg_7_0._game_object_id = nil
end

BaseObjectiveExtension._local_side = function (arg_8_0)
	local var_8_0 = Managers.player:local_player()

	if var_8_0 then
		local var_8_1 = var_8_0:network_id()
		local var_8_2 = var_8_0:local_player_id()
		local var_8_3 = Managers.party:get_party_from_player_id(var_8_1, var_8_2)

		if var_8_3 then
			arg_8_0._local_side_cached = Managers.state.side.side_by_party[var_8_3]
		end
	end

	return arg_8_0._local_side_cached
end

BaseObjectiveExtension.complete = function (arg_9_0, arg_9_1, arg_9_2, arg_9_3)
	if arg_9_0._is_server and arg_9_0._on_complete_func then
		arg_9_0._on_complete_func(arg_9_0._unit)
	end

	if not DEDICATED_SERVER then
		local var_9_0 = arg_9_0._on_leaf_complete_sound_event
		local var_9_1 = arg_9_0._on_last_leaf_complete_sound_event or var_9_0

		if arg_9_3 and var_9_1 then
			local var_9_2 = var_9_1[arg_9_0:_local_side():name()]

			if var_9_2 then
				arg_9_0:play_local_sound(var_9_2)
			end
		elseif var_9_0 and arg_9_2 then
			local var_9_3 = var_9_0[arg_9_0:_local_side():name()]

			if var_9_3 then
				arg_9_0:play_local_sound(var_9_3)
			end
		end
	end

	arg_9_0:deactivate()
end

BaseObjectiveExtension.deactivate = function (arg_10_0)
	arg_10_0:_deactivate()

	arg_10_0._percentage = 1
	arg_10_0._game_object_id = nil
	arg_10_0._activated = false
end

BaseObjectiveExtension.play_local_sound = function (arg_11_0, arg_11_1)
	WwiseWorld.trigger_event(arg_11_0._wwise_world, arg_11_1)
end

BaseObjectiveExtension.play_local_unit_sound = function (arg_12_0, arg_12_1)
	WwiseUtils.trigger_unit_event(arg_12_0._world, arg_12_1, arg_12_0._unit, 0)
end

BaseObjectiveExtension.play_unit_sound = function (arg_13_0, arg_13_1)
	arg_13_0._audio_system:play_audio_unit_event(arg_13_1, arg_13_0._unit)
end

BaseObjectiveExtension.unit = function (arg_14_0)
	return arg_14_0._unit
end

BaseObjectiveExtension.display_name = function (arg_15_0)
	return arg_15_0._display_name
end

BaseObjectiveExtension.is_stacking_objective = function (arg_16_0)
	return false
end

BaseObjectiveExtension.update = function (arg_17_0, arg_17_1, arg_17_2)
	if script_data.testify and arg_17_0.update_testify then
		arg_17_0:update_testify(arg_17_1, arg_17_2)
	end

	if not arg_17_0._activated then
		return
	end

	if arg_17_0._is_server then
		arg_17_0:_server_update(arg_17_1, arg_17_2)
	else
		arg_17_0:_client_update(arg_17_1, arg_17_2)
	end
end

BaseObjectiveExtension.on_section_completed = function (arg_18_0)
	arg_18_0._current_section = arg_18_0._current_section + 1

	Managers.state.event:trigger("obj_objective_section_completed", arg_18_0)

	if arg_18_0:is_done() then
		return
	end

	local var_18_0 = arg_18_0._on_section_progress_sound_event

	if var_18_0 then
		local var_18_1 = arg_18_0:_local_side()

		if var_18_1 then
			local var_18_2 = var_18_0[var_18_1:name()]

			if var_18_2 then
				arg_18_0:play_local_sound(var_18_2)
			end
		end
	end
end

BaseObjectiveExtension.server_set_value = function (arg_19_0, arg_19_1)
	local var_19_0 = Network.game_session()

	if var_19_0 then
		GameSession.set_game_object_field(var_19_0, arg_19_0._game_object_id, "value", math.clamp01(arg_19_1))
	end
end

BaseObjectiveExtension.client_get_value = function (arg_20_0)
	local var_20_0 = Network.game_session()

	if not var_20_0 or not arg_20_0._game_object_id then
		return arg_20_0._cached_value
	end

	arg_20_0._cached_value = GameSession.game_object_field(var_20_0, arg_20_0._game_object_id, "value")

	return arg_20_0._cached_value
end

BaseObjectiveExtension._store_position = function (arg_21_0)
	local var_21_0 = Unit.local_position(arg_21_0._unit, 0)

	arg_21_0._position = Vector3Box(var_21_0)
end

BaseObjectiveExtension._activate = function (arg_22_0)
	error("This function needs to be overwritten")
end

BaseObjectiveExtension._deactivate = function (arg_23_0)
	error("This function needs to be overwritten")
end

BaseObjectiveExtension._server_update = function (arg_24_0, arg_24_1, arg_24_2)
	error("This function needs to be overwritten")
end

BaseObjectiveExtension._client_update = function (arg_25_0, arg_25_1, arg_25_2)
	error("This function needs to be overwritten")
end

BaseObjectiveExtension.get_percentage_done = function (arg_26_0)
	error("This function needs to be overwritten")
end

BaseObjectiveExtension.objective_name = function (arg_27_0)
	return arg_27_0._objective_name
end

BaseObjectiveExtension.get_current_section = function (arg_28_0)
	return arg_28_0._current_section
end

BaseObjectiveExtension.get_total_sections = function (arg_29_0)
	return arg_29_0._num_sections
end

BaseObjectiveExtension.get_num_sections_left = function (arg_30_0)
	return arg_30_0._current_section - arg_30_0._num_sections
end

BaseObjectiveExtension.get_time_per_section = function (arg_31_0)
	return arg_31_0._time_per_section
end

BaseObjectiveExtension.get_score_per_section = function (arg_32_0)
	return arg_32_0._score_per_section
end

BaseObjectiveExtension.get_time_for_completion = function (arg_33_0)
	return arg_33_0._time_for_completion
end

BaseObjectiveExtension.get_score_for_completion = function (arg_34_0)
	return arg_34_0._score_for_completion
end

BaseObjectiveExtension.get_position = function (arg_35_0)
	if arg_35_0._position then
		return arg_35_0._position:unbox()
	else
		return Unit.world_position(arg_35_0._unit, 0)
	end
end

BaseObjectiveExtension.is_optional = function (arg_36_0)
	return arg_36_0._optional
end

BaseObjectiveExtension.description = function (arg_37_0)
	return arg_37_0._description
end

BaseObjectiveExtension.objective_icon = function (arg_38_0)
	return arg_38_0._objective_icon
end

BaseObjectiveExtension.objective_type = function (arg_39_0)
	return arg_39_0._objective_type
end

BaseObjectiveExtension.is_done = function (arg_40_0)
	return arg_40_0:get_percentage_done() >= 1
end

BaseObjectiveExtension.is_active = function (arg_41_0)
	return arg_41_0._activated
end

BaseObjectiveExtension.always_show_objective_marker = function (arg_42_0)
	return arg_42_0._always_show_objective_marker
end
