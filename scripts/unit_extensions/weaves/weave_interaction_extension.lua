-- chunkname: @scripts/unit_extensions/weaves/weave_interaction_extension.lua

WeaveInteractionExtension = class(WeaveInteractionExtension, BaseObjectiveExtension)
WeaveInteractionExtension.NAME = "WeaveInteractionExtension"

function WeaveInteractionExtension.init(arg_1_0, arg_1_1, arg_1_2, arg_1_3)
	WeaveInteractionExtension.super.init(arg_1_0, arg_1_1, arg_1_2, arg_1_3)

	arg_1_0._on_start_func = arg_1_3.on_start_func
	arg_1_0._on_interact_start_func = arg_1_3.on_interact_start_func
	arg_1_0._on_interact_interupt_func = arg_1_3.on_interact_interupt_func
	arg_1_0._on_interact_complete_func = arg_1_3.on_interact_complete_func
	arg_1_0._on_progress_func = arg_1_3.on_progress_func
	arg_1_0._on_complete_func = arg_1_3.on_complete_func
	arg_1_0._num_times_to_complete = arg_1_3.num_times_to_complete or 1
	arg_1_0._duration = arg_1_3.duration or 5
	arg_1_0._audio_system = Managers.state.entity:system("audio_system")
	arg_1_0._value = 0

	local var_1_0 = arg_1_3.terror_event_spawner_id

	Unit.set_data(arg_1_2, "terror_event_spawner_id", var_1_0)
	Unit.set_data(arg_1_2, "interaction_data", "interaction_length", arg_1_0._duration)

	arg_1_0._max_value = arg_1_0._duration * arg_1_0._num_times_to_complete
end

function WeaveInteractionExtension.extensions_ready(arg_2_0)
	arg_2_0._interactable_extension = ScriptUnit.has_extension(arg_2_0._unit, "interactable_system")
end

function WeaveInteractionExtension.display_name(arg_3_0)
	return "Interact with object"
end

function WeaveInteractionExtension.initial_sync_data(arg_4_0, arg_4_1)
	arg_4_1.value = arg_4_0:get_percentage_done()
end

function WeaveInteractionExtension._set_objective_data(arg_5_0, arg_5_1)
	return
end

function WeaveInteractionExtension._activate(arg_6_0)
	local var_6_0 = ScriptUnit.has_extension(arg_6_0._unit, "tutorial_system")

	if var_6_0 then
		var_6_0:set_active(true)
	end
end

function WeaveInteractionExtension._deactivate(arg_7_0)
	local var_7_0 = Unit.local_position(arg_7_0._unit, 0)

	for iter_7_0 = 1, 3 do
		local var_7_1 = math.random(-10, 10) / 10
		local var_7_2 = math.random(-10, 10) / 10
		local var_7_3 = math.random(-10, 10) / 10

		Managers.state.entity:system("objective_system"):weave_essence_handler():spawn_essence_unit(var_7_0 + Vector3(0, 0, 0.5) + Vector3(var_7_1, var_7_2, var_7_3))
	end
end

function WeaveInteractionExtension._server_update(arg_8_0, arg_8_1, arg_8_2)
	local var_8_0 = arg_8_0._interactable_extension.interaction_result
	local var_8_1 = false

	if arg_8_0._interactable_extension:is_being_interacted_with() then
		if var_8_0 ~= arg_8_0._interactable_state then
			if arg_8_0._on_start_func then
				arg_8_0._on_start_func(arg_8_0._unit)

				arg_8_0._on_start_func = nil
			end

			if arg_8_0._on_interact_start_func then
				arg_8_0._on_interact_start_func(arg_8_0._unit)
			end
		else
			arg_8_0._value = arg_8_0._value + arg_8_1

			local var_8_2 = true

			if arg_8_0._on_progress_func then
				arg_8_0._on_progress_func(arg_8_0._unit, arg_8_0._value, arg_8_0._max_value)
			end
		end

		arg_8_0._interactable_state = var_8_0
	elseif var_8_0 ~= arg_8_0._interactable_state and arg_8_0._interactable_state ~= 0 then
		arg_8_0._value = arg_8_0._interactable_extension.num_times_successfully_completed * arg_8_0._duration

		local var_8_3 = true

		if var_8_0 == InteractionResult.SUCCESS then
			arg_8_0._audio_system:play_audio_unit_event("emitter_rune_activate", arg_8_0._unit)

			if arg_8_0._on_interact_complete_func then
				arg_8_0._on_interact_complete_func(arg_8_0._unit)
			end
		elseif (var_8_0 == InteractionResult.FAILURE or var_8_0 == InteractionResult.USER_ENDED) and arg_8_0._on_interact_interupt_func then
			arg_8_0._on_interact_interupt_func(arg_8_0._unit)
		end

		arg_8_0._interactable_state = var_8_0
	elseif arg_8_0._interactable_state ~= 0 then
		arg_8_0._interactable_state = 0
	end

	arg_8_0:server_set_value(arg_8_0:get_percentage_done())
end

function WeaveInteractionExtension._client_update(arg_9_0, arg_9_1, arg_9_2)
	return
end

function WeaveInteractionExtension.is_done(arg_10_0)
	return arg_10_0._interactable_extension.num_times_successfully_completed >= arg_10_0._num_times_to_complete
end

function WeaveInteractionExtension.get_percentage_done(arg_11_0)
	return math.clamp(arg_11_0._value / arg_11_0._max_value, 0, 1)
end
