-- chunkname: @scripts/unit_extensions/human/ai_player_unit/ai_locomotion_extension_c.lua

require("scripts/helpers/mover_helper")

local var_0_0 = 20

AILocomotionExtensionC = class(AILocomotionExtensionC)

function AILocomotionExtensionC.init(arg_1_0, arg_1_1, arg_1_2, arg_1_3)
	arg_1_0._unit = arg_1_2

	local var_1_0 = arg_1_3.breed

	arg_1_0.breed = var_1_0

	local var_1_1 = Managers.state.unit_spawner.unit_template_lut[var_1_0.unit_template].go_type
	local var_1_2 = Managers.state.network:game_object_template(var_1_1)

	fassert(var_1_2.syncs_rotation or var_1_2.syncs_yaw, "AI Locomotion error. AI units must have syncs_rotation or syncs_yaw set in its game_object_template.")

	local var_1_3 = var_1_0.run_speed
	local var_1_4 = var_1_2.syncs_rotation or false

	arg_1_0._engine_extension_id = EngineOptimizedExtensions.ai_locomotion_register_extension(arg_1_2, var_0_0, var_1_3, var_1_4)
	arg_1_0._animation_rotation_scale = 1
	arg_1_0._animation_translation_scale_box = Vector3Box(1, 1, 1)
	arg_1_0._mover_state = MoverHelper.create_mover_state()

	local var_1_5 = "c_mover_collision"

	if Unit.actor(arg_1_2, var_1_5) then
		arg_1_0._collision_state = MoverHelper.create_collision_state(arg_1_2, var_1_5)
	end

	MoverHelper.set_active_mover(arg_1_2, arg_1_0._mover_state, var_1_0.default_mover or "mover")
end

function AILocomotionExtensionC.ready(arg_2_0, arg_2_1, arg_2_2)
	if arg_2_0._engine_extension_id then
		EngineOptimizedExtensions.ai_locomotion_ai_ready(arg_2_0._engine_extension_id, arg_2_1)
	end
end

function AILocomotionExtensionC.destroy(arg_3_0)
	if arg_3_0._engine_extension_id then
		EngineOptimizedExtensions.ai_locomotion_destroy_extension(arg_3_0._engine_extension_id)

		arg_3_0._engine_extension_id = nil
	end
end

function AILocomotionExtensionC.freeze(arg_4_0)
	if arg_4_0._engine_extension_id then
		EngineOptimizedExtensions.ai_locomotion_destroy_extension(arg_4_0._engine_extension_id)

		arg_4_0._engine_extension_id = nil
	end
end

function AILocomotionExtensionC.unfreeze(arg_5_0, arg_5_1)
	local var_5_0 = BLACKBOARDS[arg_5_1].breed
	local var_5_1 = var_5_0.run_speed
	local var_5_2 = Managers.state.unit_spawner.unit_template_lut[var_5_0.unit_template].go_type
	local var_5_3 = Managers.state.network:game_object_template(var_5_2).syncs_rotation or false

	arg_5_0._engine_extension_id = EngineOptimizedExtensions.ai_locomotion_register_extension(arg_5_1, var_0_0, var_5_1, var_5_3)
	arg_5_0._animation_rotation_scale = 1

	arg_5_0._animation_translation_scale_box:store(1, 1, 1)
	MoverHelper.set_active_mover(arg_5_1, arg_5_0._mover_state, var_5_0.default_mover or "mover")
	arg_5_0:teleport_to(POSITION_LOOKUP[arg_5_1], Unit.local_rotation(arg_5_1, 0))
end

function AILocomotionExtensionC.hot_join_sync(arg_6_0, arg_6_1)
	if FROZEN[arg_6_0._unit] then
		return
	end

	local var_6_0 = PEER_ID_TO_CHANNEL[arg_6_1]
	local var_6_1 = arg_6_0._unit
	local var_6_2 = Managers.state.network:unit_game_object_id(var_6_1)

	if Unit.has_animation_state_machine(var_6_1) then
		local var_6_3 = BLACKBOARDS[var_6_1].breed

		RPC[var_6_3.animation_sync_rpc](var_6_0, var_6_2, Unit.animation_get_state(var_6_1))
	else
		RPC.rpc_hot_join_nail_to_wall_fix(var_6_0, var_6_2)
	end
end

function AILocomotionExtensionC.set_mover_displacement(arg_7_0, arg_7_1, arg_7_2)
	if arg_7_0._engine_extension_id then
		EngineOptimizedExtensions.ai_locomotion_set_mover_displacement(arg_7_0._engine_extension_id, arg_7_1, arg_7_2)
	end
end

function AILocomotionExtensionC.teleport_to(arg_8_0, arg_8_1, arg_8_2)
	if arg_8_0._engine_extension_id then
		EngineOptimizedExtensions.ai_locomotion_teleport_to(arg_8_0._engine_extension_id, arg_8_1, arg_8_2)
	end
end

function AILocomotionExtensionC.set_animation_driven(arg_9_0, arg_9_1, arg_9_2, arg_9_3, arg_9_4)
	if not arg_9_0._engine_extension_id then
		return
	end

	arg_9_2 = arg_9_2 or false

	local var_9_0, var_9_1, var_9_2, var_9_3 = EngineOptimizedExtensions.ai_locomotion_set_animation_driven(arg_9_0._engine_extension_id, arg_9_1, arg_9_2, arg_9_3, arg_9_4)

	if var_9_0 == 1 then
		local var_9_4 = Managers.state.network.network_transmit
		local var_9_5 = var_9_1
		local var_9_6 = var_9_2
		local var_9_7 = var_9_3

		var_9_4:send_rpc_clients("rpc_set_animation_driven_script_movement", var_9_5, var_9_6, var_9_7, arg_9_2)
	elseif var_9_0 == 2 then
		local var_9_8 = Managers.state.network.network_transmit
		local var_9_9 = var_9_1
		local var_9_10 = var_9_2
		local var_9_11 = var_9_3

		var_9_8:send_rpc_clients("rpc_set_animation_driven", var_9_9, var_9_10, var_9_11, arg_9_2)
	elseif var_9_0 == 3 then
		local var_9_12 = Managers.state.network.network_transmit
		local var_9_13 = var_9_1

		var_9_12:send_rpc_clients("rpc_set_script_driven", var_9_13, arg_9_2)
	elseif var_9_0 == 4 then
		local var_9_14 = Managers.state.network.network_transmit
		local var_9_15 = var_9_1

		var_9_14:send_rpc_clients("rpc_set_affected_by_gravity", var_9_15, arg_9_2)
	elseif var_9_0 == 5 then
		local var_9_16 = Managers.state.network.network_transmit
		local var_9_17 = var_9_1

		var_9_16:send_rpc_clients("rpc_set_linked_transport_driven", var_9_17, arg_9_2)
	end
end

function AILocomotionExtensionC.set_animation_translation_scale(arg_10_0, arg_10_1)
	if not arg_10_0._engine_extension_id then
		return
	end

	EngineOptimizedExtensions.ai_locomotion_set_animation_translation_scale(arg_10_0._engine_extension_id, arg_10_1)
	arg_10_0._animation_translation_scale_box:store(arg_10_1)
end

function AILocomotionExtensionC.set_animation_rotation_scale(arg_11_0, arg_11_1)
	if not arg_11_0._engine_extension_id then
		return
	end

	EngineOptimizedExtensions.ai_locomotion_set_animation_rotation_scale(arg_11_0._engine_extension_id, arg_11_1)

	arg_11_0._animation_rotation_scale = arg_11_1
end

function AILocomotionExtensionC.set_wanted_velocity_flat(arg_12_0, arg_12_1)
	if not arg_12_0._engine_extension_id then
		return
	end

	EngineOptimizedExtensions.ai_locomotion_set_wanted_velocity_flat(arg_12_0._engine_extension_id, arg_12_1)
end

function AILocomotionExtensionC.set_wanted_velocity(arg_13_0, arg_13_1)
	if not arg_13_0._engine_extension_id then
		return
	end

	EngineOptimizedExtensions.ai_locomotion_set_wanted_velocity(arg_13_0._engine_extension_id, arg_13_1)
end

function AILocomotionExtensionC.set_external_velocity(arg_14_0, arg_14_1)
	if not arg_14_0._engine_extension_id then
		return
	end

	EngineOptimizedExtensions.ai_locomotion_set_external_velocity(arg_14_0._engine_extension_id, arg_14_1)
end

function AILocomotionExtensionC.set_animation_external_velocity(arg_15_0, arg_15_1)
	if not arg_15_0._engine_extension_id then
		return
	end

	EngineOptimizedExtensions.ai_locomotion_set_animation_external_velocity(arg_15_0._engine_extension_id, arg_15_1)
end

function AILocomotionExtensionC.set_wanted_rotation(arg_16_0, arg_16_1)
	if not arg_16_0._engine_extension_id then
		return
	end

	EngineOptimizedExtensions.ai_locomotion_set_wanted_rotation(arg_16_0._engine_extension_id, arg_16_1)
end

function AILocomotionExtensionC.use_lerp_rotation(arg_17_0, arg_17_1)
	if not arg_17_0._engine_extension_id then
		return
	end

	EngineOptimizedExtensions.ai_locomotion_use_lerp_rotation(arg_17_0._engine_extension_id, arg_17_1)
end

function AILocomotionExtensionC.set_rotation_speed(arg_18_0, arg_18_1)
	if not arg_18_0._engine_extension_id then
		return
	end

	EngineOptimizedExtensions.ai_locomotion_set_rotation_speed(arg_18_0._engine_extension_id, arg_18_1)
end

function AILocomotionExtensionC.set_rotation_speed_modifier(arg_19_0, arg_19_1, arg_19_2, arg_19_3)
	if not arg_19_0._engine_extension_id then
		return
	end

	EngineOptimizedExtensions.ai_locomotion_set_rotation_speed_modifier(arg_19_0._engine_extension_id, arg_19_1, arg_19_2, arg_19_3)
end

function AILocomotionExtensionC.set_affected_by_gravity(arg_20_0, arg_20_1)
	if not arg_20_0._engine_extension_id then
		return
	end

	EngineOptimizedExtensions.ai_locomotion_set_affected_by_gravity(arg_20_0._engine_extension_id, arg_20_1)
end

function AILocomotionExtensionC.set_gravity(arg_21_0, arg_21_1)
	if not arg_21_0._engine_extension_id then
		return
	end

	EngineOptimizedExtensions.ai_locomotion_set_gravity(arg_21_0._engine_extension_id, arg_21_1)
end

function AILocomotionExtensionC.set_check_falling(arg_22_0, arg_22_1)
	if not arg_22_0._engine_extension_id then
		return
	end

	EngineOptimizedExtensions.ai_locomotion_set_check_falling(arg_22_0._engine_extension_id, arg_22_1)
end

local var_0_1 = {
	script_driven = 0,
	snap_to_navmesh = 1,
	constrained_by_mover = 2,
	disabled = 3
}

function AILocomotionExtensionC.set_movement_type(arg_23_0, arg_23_1, arg_23_2, arg_23_3)
	if not arg_23_0._engine_extension_id then
		return
	end

	if arg_23_1 == arg_23_0.movement_type then
		return true
	end

	arg_23_0.movement_type = arg_23_1

	if arg_23_1 == "script_driven" then
		MoverHelper.set_disable_reason(arg_23_0._unit, arg_23_0._mover_state, "constrained_by_mover", true)
	elseif arg_23_1 == "snap_to_navmesh" then
		MoverHelper.set_disable_reason(arg_23_0._unit, arg_23_0._mover_state, "constrained_by_mover", true)
	elseif arg_23_1 == "constrained_by_mover" then
		MoverHelper.set_disable_reason(arg_23_0._unit, arg_23_0._mover_state, "constrained_by_mover", false)
	end

	local var_23_0 = EngineOptimizedExtensions.ai_locomotion_set_movement_type(arg_23_0._engine_extension_id, var_0_1[arg_23_1], arg_23_2)

	if var_23_0 and not arg_23_3 then
		local var_23_1 = "forced"
		local var_23_2 = Vector3(0, 0, -1)

		AiUtils.kill_unit(arg_23_0._unit, nil, nil, var_23_1, var_23_2)
	end

	return not var_23_0
end

function AILocomotionExtensionC.current_velocity(arg_24_0)
	if not arg_24_0._engine_extension_id then
		return
	end

	return EngineOptimizedExtensions.ai_locomotion_get_velocity(arg_24_0._engine_extension_id)
end

function AILocomotionExtensionC.is_falling(arg_25_0)
	if not arg_25_0._engine_extension_id then
		return
	end

	return EngineOptimizedExtensions.ai_locomotion_is_falling(arg_25_0._engine_extension_id)
end

function AILocomotionExtensionC.get_rotation_speed(arg_26_0)
	if not arg_26_0._engine_extension_id then
		return
	end

	return EngineOptimizedExtensions.ai_locomotion_get_rotation_speed(arg_26_0._engine_extension_id)
end

function AILocomotionExtensionC.get_rotation_speed_modifier(arg_27_0)
	if not arg_27_0._engine_extension_id then
		return
	end

	return EngineOptimizedExtensions.ai_locomotion_get_rotation_speed_modifier(arg_27_0._engine_extension_id)
end

function AILocomotionExtensionC.get_animation_rotation_scale(arg_28_0)
	return arg_28_0._animation_rotation_scale
end

function AILocomotionExtensionC.get_animation_translation_scale(arg_29_0)
	return arg_29_0._animation_translation_scale_box:unbox()
end

function AILocomotionExtensionC.set_disabled(arg_30_0)
	if not arg_30_0._engine_extension_id then
		return
	end

	EngineOptimizedExtensions.ai_locomotion_set_disabled(arg_30_0._engine_extension_id)
	MoverHelper.set_disable_reason(arg_30_0._unit, arg_30_0._mover_state, "constrained_by_mover", true)
end

function AILocomotionExtensionC.set_mover_disable_reason(arg_31_0, arg_31_1, arg_31_2)
	MoverHelper.set_disable_reason(arg_31_0._unit, arg_31_0._mover_state, arg_31_1, arg_31_2)
end

function AILocomotionExtensionC.set_collision_disabled(arg_32_0, arg_32_1, arg_32_2)
	if arg_32_0._collision_state then
		MoverHelper.set_collision_disable_reason(arg_32_0._unit, arg_32_0._collision_state, arg_32_1, arg_32_2)
	end
end
