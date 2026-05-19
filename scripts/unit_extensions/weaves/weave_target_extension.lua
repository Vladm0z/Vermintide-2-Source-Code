-- chunkname: @scripts/unit_extensions/weaves/weave_target_extension.lua

WeaveTargetExtension = class(WeaveTargetExtension, BaseObjectiveExtension)
WeaveTargetExtension.NAME = "WeaveTargetExtension"

function WeaveTargetExtension.init(arg_1_0, arg_1_1, arg_1_2, arg_1_3)
	WeaveTargetExtension.super.init(arg_1_0, arg_1_1, arg_1_2, arg_1_3)

	arg_1_0._on_start_func = arg_1_3.on_start_func
	arg_1_0._on_progress_func = arg_1_3.on_progress_func
	arg_1_0._on_complete_func = arg_1_3.on_complete_func
	arg_1_0._audio_system = Managers.state.entity:system("audio_system")
	arg_1_0.keep_alive = true

	local var_1_0 = arg_1_3.terror_event_spawner_id

	Unit.set_data(arg_1_2, "terror_event_spawner_id", var_1_0)

	arg_1_0._attacks_allowed = arg_1_3.attacks_allowed or {
		melee = true,
		ranged = true
	}

	Unit.set_data(arg_1_2, "allow_melee_damage", arg_1_0._attacks_allowed.melee)
	Unit.set_data(arg_1_2, "allow_ranged_damage", arg_1_0._attacks_allowed.ranged)
end

function WeaveTargetExtension.extensions_ready(arg_2_0)
	arg_2_0._health_extension = ScriptUnit.has_extension(arg_2_0._unit, "health_system")

	if arg_2_0._health_extension then
		arg_2_0._max_health = arg_2_0._health_extension:current_health()
		arg_2_0._health = arg_2_0._max_health
	end
end

function WeaveTargetExtension.display_name(arg_3_0)
	return "objective_targets_name_single"
end

function WeaveTargetExtension.is_stacking_objective(arg_4_0)
	return "target"
end

function WeaveTargetExtension.initial_sync_data(arg_5_0, arg_5_1)
	arg_5_1.value = arg_5_0:get_percentage_done()
end

function WeaveTargetExtension._set_objective_data(arg_6_0, arg_6_1)
	return
end

function WeaveTargetExtension._activate(arg_7_0)
	local var_7_0 = ScriptUnit.has_extension(arg_7_0._unit, "tutorial_system")

	if var_7_0 then
		var_7_0:set_active(true)
	end
end

function WeaveTargetExtension._deactivate(arg_8_0)
	Unit.flow_event(arg_8_0._unit, "target_destroyed")

	ScriptUnit.extension(arg_8_0._unit, "tutorial_system").active = false

	local var_8_0 = Unit.local_position(arg_8_0._unit, 0)

	for iter_8_0 = 1, 3 do
		local var_8_1 = math.random(-10, 10) / 10
		local var_8_2 = math.random(-10, 10) / 10
		local var_8_3 = math.random(-10, 10) / 10

		Managers.state.entity:system("objective_system"):weave_essence_handler():spawn_essence_unit(var_8_0 + Vector3(0, 0, 0.5) + Vector3(var_8_1, var_8_2, var_8_3))
	end
end

function WeaveTargetExtension._server_update(arg_9_0, arg_9_1, arg_9_2)
	local var_9_0 = arg_9_0._health_extension:current_health()

	if var_9_0 ~= arg_9_0._health then
		if arg_9_0._on_start_func then
			arg_9_0._on_start_func(arg_9_0._unit)

			arg_9_0._on_start_func = nil
		end

		arg_9_0._audio_system:play_2d_audio_event("hud_text_reveal")

		if var_9_0 < arg_9_0._health and arg_9_0._on_progress_func then
			arg_9_0._on_progress_func(arg_9_0._unit, var_9_0, arg_9_0._max_health)
		end

		arg_9_0._health = var_9_0

		arg_9_0:server_set_value(arg_9_0:get_percentage_done())
	end
end

function WeaveTargetExtension._client_update(arg_10_0, arg_10_1, arg_10_2)
	return
end

function WeaveTargetExtension.is_done(arg_11_0)
	return arg_11_0._health_extension:is_dead()
end

function WeaveTargetExtension.attacks_allowed(arg_12_0)
	return arg_12_0._attacks_allowed
end

function WeaveTargetExtension.get_percentage_done(arg_13_0)
	return math.clamp(1 - arg_13_0._health / arg_13_0._max_health, 0, 1)
end
