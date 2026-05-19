-- chunkname: @scripts/unit_extensions/objectives/base_objective_extension.lua

BaseObjectiveExtension = class(BaseObjectiveExtension)
BaseObjectiveExtension.NAME = "BaseObjectiveExtension"

function BaseObjectiveExtension.init(arg_1_0, arg_1_1, arg_1_2, arg_1_3)
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

function BaseObjectiveExtension.set_objective_data(arg_2_0, arg_2_1)
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

function BaseObjectiveExtension.activate(arg_3_0)
	arg_3_0:_activate()
	arg_3_0:_store_position()
	arg_3_0:_store_local_player()

	arg_3_0._activated = true
end

function BaseObjectiveExtension.objective_tag(arg_4_0)
	return arg_4_0._objective_tag
end

function BaseObjectiveExtension._store_local_player(arg_5_0)
	if not DEDICATED_SERVER then
		arg_5_0:_local_side()
	end
end

function BaseObjectiveExtension.sync_objective(arg_6_0, arg_6_1, arg_6_2)
	arg_6_0._game_object_id = arg_6_1
end

function BaseObjectiveExtension.desync_objective(arg_7_0)
	arg_7_0._game_object_id = nil
end

function BaseObjectiveExtension._local_side(arg_8_0)
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

function BaseObjectiveExtension.complete(arg_9_0, arg_9_1, arg_9_2, arg_9_3)
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

function BaseObjectiveExtension.deactivate(arg_10_0)
	arg_10_0:_deactivate()

	arg_10_0._percentage = 1
	arg_10_0._game_object_id = nil
	arg_10_0._activated = false
end

function BaseObjectiveExtension.play_local_sound(arg_11_0, arg_11_1)
	WwiseWorld.trigger_event(arg_11_0._wwise_world, arg_11_1)
end

function BaseObjectiveExtension.play_local_unit_sound(arg_12_0, arg_12_1)
	WwiseUtils.trigger_unit_event(arg_12_0._world, arg_12_1, arg_12_0._unit, 0)
end

function BaseObjectiveExtension.play_unit_sound(arg_13_0, arg_13_1)
	arg_13_0._audio_system:play_audio_unit_event(arg_13_1, arg_13_0._unit)
end

function BaseObjectiveExtension.unit(arg_14_0)
	return arg_14_0._unit
end

function BaseObjectiveExtension.display_name(arg_15_0)
	return arg_15_0._display_name
end

function BaseObjectiveExtension.is_stacking_objective(arg_16_0)
	return false
end

function BaseObjectiveExtension.update(arg_17_0, arg_17_1, arg_17_2)
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

function BaseObjectiveExtension.on_section_completed(arg_18_0)
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

function BaseObjectiveExtension.server_set_value(arg_19_0, arg_19_1)
	local var_19_0 = Network.game_session()

	if var_19_0 then
		GameSession.set_game_object_field(var_19_0, arg_19_0._game_object_id, "value", math.clamp01(arg_19_1))
	end
end

function BaseObjectiveExtension.client_get_value(arg_20_0)
	local var_20_0 = Network.game_session()

	if not var_20_0 or not arg_20_0._game_object_id then
		return arg_20_0._cached_value
	end

	arg_20_0._cached_value = GameSession.game_object_field(var_20_0, arg_20_0._game_object_id, "value")

	return arg_20_0._cached_value
end

function BaseObjectiveExtension._store_position(arg_21_0)
	local var_21_0 = Unit.local_position(arg_21_0._unit, 0)

	arg_21_0._position = Vector3Box(var_21_0)
end

function BaseObjectiveExtension._activate(arg_22_0)
	error("This function needs to be overwritten")
end

function BaseObjectiveExtension._deactivate(arg_23_0)
	error("This function needs to be overwritten")
end

function BaseObjectiveExtension._server_update(arg_24_0, arg_24_1, arg_24_2)
	error("This function needs to be overwritten")
end

function BaseObjectiveExtension._client_update(arg_25_0, arg_25_1, arg_25_2)
	error("This function needs to be overwritten")
end

function BaseObjectiveExtension.get_percentage_done(arg_26_0)
	error("This function needs to be overwritten")
end

function BaseObjectiveExtension.objective_name(arg_27_0)
	return arg_27_0._objective_name
end

function BaseObjectiveExtension.get_current_section(arg_28_0)
	return arg_28_0._current_section
end

function BaseObjectiveExtension.get_total_sections(arg_29_0)
	return arg_29_0._num_sections
end

function BaseObjectiveExtension.get_num_sections_left(arg_30_0)
	return arg_30_0._current_section - arg_30_0._num_sections
end

function BaseObjectiveExtension.get_time_per_section(arg_31_0)
	return arg_31_0._time_per_section
end

function BaseObjectiveExtension.get_score_per_section(arg_32_0)
	return arg_32_0._score_per_section
end

function BaseObjectiveExtension.get_time_for_completion(arg_33_0)
	return arg_33_0._time_for_completion
end

function BaseObjectiveExtension.get_score_for_completion(arg_34_0)
	return arg_34_0._score_for_completion
end

function BaseObjectiveExtension.get_position(arg_35_0)
	if arg_35_0._position then
		return arg_35_0._position:unbox()
	else
		return Unit.world_position(arg_35_0._unit, 0)
	end
end

function BaseObjectiveExtension.is_optional(arg_36_0)
	return arg_36_0._optional
end

function BaseObjectiveExtension.description(arg_37_0)
	return arg_37_0._description
end

function BaseObjectiveExtension.objective_icon(arg_38_0)
	return arg_38_0._objective_icon
end

function BaseObjectiveExtension.objective_type(arg_39_0)
	return arg_39_0._objective_type
end

function BaseObjectiveExtension.is_done(arg_40_0)
	return arg_40_0:get_percentage_done() >= 1
end

function BaseObjectiveExtension.is_active(arg_41_0)
	return arg_41_0._activated
end

function BaseObjectiveExtension.always_show_objective_marker(arg_42_0)
	return arg_42_0._always_show_objective_marker
end
