-- chunkname: @scripts/unit_extensions/human/ai_player_unit/ai_husk_locomotion_extension.lua

require("scripts/helpers/mover_helper")

local var_0_0 = 0.5

AiHuskLocomotionExtension = class(AiHuskLocomotionExtension)

function AiHuskLocomotionExtension.init(arg_1_0, arg_1_1, arg_1_2, arg_1_3)
	arg_1_0._unit = arg_1_2
	arg_1_0._system_data = arg_1_3.system_data
	arg_1_0._game = arg_1_3.game
	arg_1_0._go_id = arg_1_3.go_id

	Unit.set_animation_merge_options(arg_1_2)

	arg_1_0._velocity = Vector3Box(0, 0, 0)
	arg_1_0.breed = arg_1_3.breed

	local var_1_0 = Managers.state.entity:system("ai_system")
	local var_1_1 = var_1_0:client_traverse_logic()

	arg_1_0._nav_world = var_1_0:nav_world()
	arg_1_0._world = arg_1_1.world
	arg_1_0._traverse_logic = var_1_1
	arg_1_0._move_speed_anim_var = Unit.animation_find_variable(arg_1_2, "move_speed")
	arg_1_0._animation_translation_scale = Vector3Box(1, 1, 1)
	arg_1_0._animation_rotation_scale = 1
	arg_1_0.is_affected_by_gravity = false
	arg_1_0.hit_wall = false

	local var_1_2 = LevelHelper:current_level_settings().on_spawn_flow_event

	if var_1_2 then
		Unit.flow_event(arg_1_2, var_1_2)
	end

	arg_1_0.constrain_min = {
		0,
		0,
		0
	}
	arg_1_0.constrain_max = {
		0,
		0,
		0
	}
	arg_1_0.last_lerp_position = Vector3Box(Unit.local_position(arg_1_2, 0))
	arg_1_0.last_lerp_position_offset = Vector3Box()
	arg_1_0.accumulated_movement = Vector3Box()

	local var_1_3 = GameSession.game_object_field(arg_1_0._game, arg_1_0._go_id, "has_teleported")

	arg_1_0.has_teleported = var_1_3
	arg_1_0._pos_lerp_time = 0
	arg_1_0._update_function_name = "update_network_driven"
	arg_1_0._mover_state = MoverHelper.create_mover_state()

	local var_1_4 = "c_mover_collision"

	if Unit.actor(arg_1_2, var_1_4) then
		arg_1_0._collision_state = MoverHelper.create_collision_state(arg_1_2, "c_mover_collision")
	end

	MoverHelper.set_active_mover(arg_1_2, arg_1_0._mover_state, arg_1_0.breed.default_mover or "mover")
	arg_1_0:set_mover_disable_reason("not_constrained_by_mover", true)

	arg_1_0._system_data.all_update_units[arg_1_2] = arg_1_0
	arg_1_0._system_data.pure_network_update_units[arg_1_2] = arg_1_0

	local var_1_5 = Managers.state.unit_spawner.unit_template_lut[arg_1_0.breed.unit_template]
	local var_1_6 = var_1_5 and var_1_5.go_type
	local var_1_7 = Managers.state.network:game_object_template(var_1_6)
	local var_1_8 = var_1_7 and not var_1_7.syncs_rotation and false

	arg_1_0._engine_extension_id = EngineOptimizedExtensions.ai_husk_locomotion_register_extension(arg_1_2, arg_1_0._go_id, var_1_3, var_1_1, var_1_8)

	EngineOptimizedExtensions.ai_husk_locomotion_set_is_network_driven(arg_1_0._engine_extension_id, true)

	arg_1_0.is_network_driven = true
end

function AiHuskLocomotionExtension.destroy(arg_2_0)
	arg_2_0:_cleanup()
end

function AiHuskLocomotionExtension.freeze(arg_3_0)
	arg_3_0:_cleanup()
end

function AiHuskLocomotionExtension._cleanup(arg_4_0)
	local var_4_0 = arg_4_0._unit

	arg_4_0._system_data.all_update_units[var_4_0] = nil
	arg_4_0._system_data.pure_network_update_units[var_4_0] = nil
	arg_4_0._system_data.other_update_units[var_4_0] = nil

	if arg_4_0._engine_extension_id then
		EngineOptimizedExtensions.ai_husk_locomotion_unregister_extension(arg_4_0._engine_extension_id)

		arg_4_0._engine_extension_id = nil
	end
end

function AiHuskLocomotionExtension.unfreeze(arg_5_0)
	local var_5_0 = arg_5_0._unit

	Unit.set_animation_merge_options(var_5_0)
	arg_5_0._velocity:store(Vector3(0, 0, 0))
	arg_5_0._animation_translation_scale:store(Vector3(1, 1, 1))

	arg_5_0._animation_rotation_scale = 1
	arg_5_0.is_affected_by_gravity = false
	arg_5_0.hit_wall = false

	local var_5_1 = LevelHelper:current_level_settings().on_spawn_flow_event

	if var_5_1 then
		Unit.flow_event(var_5_0, var_5_1)
	end

	arg_5_0.constrain_min = {
		0,
		0,
		0
	}
	arg_5_0.constrain_max = {
		0,
		0,
		0
	}

	arg_5_0.last_lerp_position:store(Unit.local_position(var_5_0, 0))
	arg_5_0.last_lerp_position_offset:store(Vector3(0, 0, 0))
	arg_5_0.accumulated_movement:store(Vector3(0, 0, 0))

	arg_5_0._pos_lerp_time = 0
	arg_5_0._update_function_name = "update_network_driven"
	arg_5_0._mover_state = MoverHelper.create_mover_state()

	local var_5_2 = "c_mover_collision"

	if Unit.actor(var_5_0, var_5_2) then
		arg_5_0._collision_state = MoverHelper.create_collision_state(var_5_0, "c_mover_collision")
	end

	MoverHelper.set_active_mover(var_5_0, arg_5_0._mover_state, arg_5_0.breed.default_mover or "mover")
	arg_5_0:set_mover_disable_reason("not_constrained_by_mover", true)

	arg_5_0._system_data.all_update_units[var_5_0] = arg_5_0
	arg_5_0._system_data.pure_network_update_units[var_5_0] = arg_5_0

	local var_5_3 = Managers.state.unit_spawner.unit_template_lut[arg_5_0.breed.unit_template]
	local var_5_4 = var_5_3 and var_5_3.go_type
	local var_5_5 = Managers.state.network:game_object_template(var_5_4)
	local var_5_6 = var_5_5 and not var_5_5.syncs_rotation and false

	arg_5_0._engine_extension_id = EngineOptimizedExtensions.ai_husk_locomotion_register_extension(var_5_0, arg_5_0._go_id, arg_5_0.has_teleported, arg_5_0._client_traverse_logic, var_5_6)

	EngineOptimizedExtensions.ai_husk_locomotion_set_is_network_driven(arg_5_0._engine_extension_id, true)

	arg_5_0.is_network_driven = true
end

function AiHuskLocomotionExtension.set_animation_translation_scale(arg_6_0, arg_6_1)
	arg_6_0._animation_translation_scale = Vector3Box(arg_6_1)

	if arg_6_0._engine_extension_id then
		EngineOptimizedExtensions.ai_husk_locomotion_set_animation_translation_scale(arg_6_0._engine_extension_id, arg_6_1)
	end
end

function AiHuskLocomotionExtension.set_animation_rotation_scale(arg_7_0, arg_7_1)
	arg_7_0._animation_rotation_scale = arg_7_1

	if arg_7_0._engine_extension_id then
		EngineOptimizedExtensions.ai_husk_locomotion_set_animation_rotation_scale(arg_7_0._engine_extension_id, arg_7_1)
	end
end

function AiHuskLocomotionExtension.set_affected_by_gravity(arg_8_0, arg_8_1)
	arg_8_0.is_affected_by_gravity = arg_8_1

	if arg_8_0._engine_extension_id then
		EngineOptimizedExtensions.ai_husk_locomotion_set_is_affected_by_gravity(arg_8_0._engine_extension_id, arg_8_1)
	end
end

function AiHuskLocomotionExtension.set_animation_driven(arg_9_0, arg_9_1, arg_9_2, arg_9_3, arg_9_4)
	if not arg_9_0._engine_extension_id then
		return
	end

	arg_9_2 = not not arg_9_2
	arg_9_0.is_animation_driven = arg_9_1
	arg_9_0.has_network_driven_rotation = arg_9_3
	arg_9_0.is_affected_by_gravity = arg_9_2
	arg_9_0.hit_wall = false

	local var_9_0 = not arg_9_4 and (not arg_9_1 or not arg_9_2)

	arg_9_0.is_network_driven = var_9_0

	arg_9_0:set_mover_disable_reason("not_constrained_by_mover", true)

	local var_9_1 = arg_9_0._system_data

	if var_9_0 then
		var_9_1.other_update_units[arg_9_0._unit] = nil
		var_9_1.pure_network_update_units[arg_9_0._unit] = arg_9_0
	else
		var_9_1.other_update_units[arg_9_0._unit] = arg_9_0
		var_9_1.pure_network_update_units[arg_9_0._unit] = nil
	end

	EngineOptimizedExtensions.ai_husk_locomotion_set_has_network_driven_rotation(arg_9_0._engine_extension_id, arg_9_3)
	EngineOptimizedExtensions.ai_husk_locomotion_set_is_network_driven(arg_9_0._engine_extension_id, var_9_0)
	EngineOptimizedExtensions.ai_husk_locomotion_set_is_affected_by_gravity(arg_9_0._engine_extension_id, arg_9_2)
end

function AiHuskLocomotionExtension.set_mover_disable_reason(arg_10_0, arg_10_1, arg_10_2)
	MoverHelper.set_disable_reason(arg_10_0._unit, arg_10_0._mover_state, arg_10_1, arg_10_2)
end

function AiHuskLocomotionExtension.set_constrained(arg_11_0, arg_11_1, arg_11_2, arg_11_3)
	if not arg_11_0._engine_extension_id then
		return
	end

	arg_11_0.is_constrained = arg_11_1

	if arg_11_1 then
		Vector3Aux.box(arg_11_0.constrain_min, arg_11_2)
		Vector3Aux.box(arg_11_0.constrain_max, arg_11_3)
	end

	EngineOptimizedExtensions.ai_husk_locomotion_set_is_constrained(arg_11_0._engine_extension_id, arg_11_1, arg_11_2, arg_11_3)
end

function AiHuskLocomotionExtension.teleport_to(arg_12_0, arg_12_1, arg_12_2, arg_12_3, arg_12_4)
	if not arg_12_0._engine_extension_id then
		return
	end

	arg_12_0.hit_wall = false

	local var_12_0 = arg_12_0._unit
	local var_12_1 = Unit.mover(var_12_0)

	if var_12_1 and not arg_12_4 then
		local var_12_2 = arg_12_0.breed.override_mover_move_distance or var_0_0

		Mover.set_position(var_12_1, arg_12_1)
		LocomotionUtils.separate_mover_fallbacks(var_12_1, var_12_2)

		arg_12_1 = Mover.position(var_12_1)
	end

	arg_12_3 = arg_12_3 or Vector3.zero()

	Unit.set_local_position(var_12_0, 0, arg_12_1)
	Unit.set_local_rotation(var_12_0, 0, arg_12_2)
	arg_12_0._velocity:store(arg_12_3)

	arg_12_0._pos_lerp_time = 0

	EngineOptimizedExtensions.ai_husk_locomotion_teleport_to(arg_12_0._engine_extension_id, arg_12_1, arg_12_2, arg_12_3)
end

function AiHuskLocomotionExtension.set_collision_disabled(arg_13_0, arg_13_1, arg_13_2)
	if arg_13_0._collision_state then
		MoverHelper.set_collision_disable_reason(arg_13_0._unit, arg_13_0._collision_state, arg_13_1, arg_13_2)
	end
end

function AiHuskLocomotionExtension.current_velocity(arg_14_0)
	return arg_14_0._velocity:unbox()
end

function AiHuskLocomotionExtension.traverse_logic(arg_15_0)
	return arg_15_0._traverse_logic
end

function AiHuskLocomotionExtension.hot_join_sync(arg_16_0, arg_16_1)
	assert(false, "ai is never husk on server")
end
