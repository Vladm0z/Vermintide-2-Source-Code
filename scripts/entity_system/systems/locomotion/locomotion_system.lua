-- chunkname: @scripts/entity_system/systems/locomotion/locomotion_system.lua

LocomotionSystem = class(LocomotionSystem, ExtensionSystemBase)

require("scripts/unit_extensions/default_player_unit/player_unit_locomotion_extension")
require("scripts/unit_extensions/default_player_unit/player_husk_locomotion_extension")
require("scripts/entity_system/systems/locomotion/locomotion_templates_ai")
require("scripts/entity_system/systems/locomotion/locomotion_templates_ai_c")
require("scripts/entity_system/systems/locomotion/locomotion_templates_ai_husk")
require("scripts/entity_system/systems/locomotion/locomotion_templates_player")

local var_0_0 = LocomotionTemplates
local var_0_1 = {
	"rpc_set_animation_driven_script_movement",
	"rpc_set_script_driven",
	"rpc_set_animation_driven",
	"rpc_set_animation_translation_scale",
	"rpc_set_animation_rotation_scale",
	"rpc_disable_locomotion",
	"rpc_teleport_unit_to",
	"rpc_teleport_unit_with_yaw_rotation",
	"rpc_enable_linked_movement",
	"rpc_disable_linked_movement",
	"rpc_add_external_velocity",
	"rpc_add_external_velocity_with_upper_limit",
	"rpc_constrain_ai",
	"rpc_set_on_moving_platform",
	"rpc_hot_join_nail_to_wall_fix",
	"rpc_set_forced_velocity",
	"rpc_set_affected_by_gravity",
	"rpc_set_linked_transport_driven"
}
local var_0_2 = {
	"AiHuskLocomotionExtension",
	"AILocomotionExtension",
	"AILocomotionExtensionC",
	"PlayerHuskLocomotionExtension",
	"PlayerUnitLocomotionExtension"
}

function LocomotionSystem.init(arg_1_0, arg_1_1, arg_1_2)
	LocomotionSystem.super.init(arg_1_0, arg_1_1, arg_1_2, var_0_2)

	local var_1_0 = arg_1_1.network_event_delegate

	arg_1_0.network_event_delegate = var_1_0

	var_1_0:register(arg_1_0, unpack(var_0_1))

	arg_1_0.world = arg_1_1.world
	arg_1_0.animation_lod_units = {}
	arg_1_0.player_units = {}
	arg_1_0.template_data = {}

	for iter_1_0, iter_1_1 in pairs(var_0_0) do
		if iter_1_0 ~= "AILocomotionExtensionC" then
			local var_1_1 = {}

			iter_1_1.init(var_1_1, GLOBAL_AI_NAVWORLD)

			arg_1_0.template_data[iter_1_0] = var_1_1
		elseif iter_1_0 == "PlayerUnitLocomotionExtension" then
			local var_1_2 = {}

			iter_1_1.init(var_1_2, GLOBAL_AI_NAVWORLD)

			arg_1_0.template_data[iter_1_0] = var_1_2
		end
	end

	EngineOptimizedExtensions.init_husk_extensions()

	if GameSettingsDevelopment.use_engine_optimized_ai_locomotion then
		local var_1_3 = World.get_data(arg_1_0.world, "physics_world")
		local var_1_4 = Managers.state.network:game()

		EngineOptimizedExtensions.init_extensions(var_1_3, GLOBAL_AI_NAVWORLD, var_1_4)
	end

	if not GameSettingsDevelopment.use_engine_optimized_ai_locomotion then
		var_0_2.AILocomotionExtensionC = nil
	end

	EngineOptimized.bone_lod_init(GameSettingsDevelopment.bone_lod_husks.lod_in_range_sq, GameSettingsDevelopment.bone_lod_husks.lod_out_range_sq, GameSettingsDevelopment.bone_lod_husks.lod_multiplier)
end

function LocomotionSystem.destroy(arg_2_0)
	arg_2_0.network_event_delegate:unregister(arg_2_0)
	EngineOptimized.bone_lod_destroy()
	EngineOptimizedExtensions.destroy_husk_extensions()

	if GameSettingsDevelopment.use_engine_optimized_ai_locomotion then
		EngineOptimizedExtensions.destroy_extensions()
	end
end

function LocomotionSystem.on_add_extension(arg_3_0, arg_3_1, arg_3_2, arg_3_3, arg_3_4)
	if arg_3_3 == "AILocomotionExtension" then
		local var_3_0 = network_manager:unit_game_object_id(selected_unit)
		local var_3_1 = BLACKBOARDS[arg_3_2]
		local var_3_2 = var_3_1.navigation_extension._wanted_destination
		local var_3_3 = 20
		local var_3_4 = var_3_1.breed.run_speed

		EngineOptimized.ai_locomotion_register_extension(arg_3_2, var_3_0, var_3_2, var_3_3, var_3_4, breed.sync_full_rotation)
	else
		arg_3_4.system_data = arg_3_0.template_data[arg_3_3]

		return (LocomotionSystem.super.on_add_extension(arg_3_0, arg_3_1, arg_3_2, arg_3_3, arg_3_4))
	end
end

function LocomotionSystem.extensions_ready(arg_4_0, arg_4_1, arg_4_2, arg_4_3)
	local var_4_0 = ScriptUnit.extension(arg_4_2, "locomotion_system")

	if arg_4_3 == "AILocomotionExtensionC" or arg_4_3 == "AILocomotionExtension" or arg_4_3 == "AiHuskLocomotionExtension" then
		if var_4_0.breed.bone_lod_level > 0 and not script_data.bone_lod_disable then
			var_4_0.bone_lod_extension_id = EngineOptimized.bone_lod_register_extension(arg_4_2)
			arg_4_0.animation_lod_units[arg_4_2] = var_4_0
		end
	else
		arg_4_0.player_units[arg_4_2] = var_4_0
	end
end

function LocomotionSystem.on_remove_extension(arg_5_0, arg_5_1, arg_5_2)
	arg_5_0:_cleanup_extension(arg_5_1, arg_5_2)
	LocomotionSystem.super.on_remove_extension(arg_5_0, arg_5_1, arg_5_2)
end

function LocomotionSystem.on_freeze_extension(arg_6_0, arg_6_1, arg_6_2)
	return
end

function LocomotionSystem._cleanup_extension(arg_7_0, arg_7_1, arg_7_2)
	if arg_7_2 == "AILocomotionExtensionC" or arg_7_2 == "AILocomotionExtension" or arg_7_2 == "AiHuskLocomotionExtension" then
		local var_7_0 = arg_7_0.animation_lod_units[arg_7_1]

		if var_7_0 then
			EngineOptimized.bone_lod_unregister_extension(var_7_0.bone_lod_extension_id)

			var_7_0.bone_lod_extension_id = nil
			arg_7_0.animation_lod_units[arg_7_1] = nil
		end
	end
end

function LocomotionSystem.freeze(arg_8_0, arg_8_1, arg_8_2, arg_8_3)
	fassert(arg_8_2 == "AILocomotionExtensionC" or arg_8_2 == "AiHuskLocomotionExtension", "Unsupported freeze extension")
	arg_8_0:_cleanup_extension(arg_8_1, arg_8_2)
	ScriptUnit.extension(arg_8_1, "locomotion_system"):freeze(arg_8_3)
end

function LocomotionSystem.unfreeze(arg_9_0, arg_9_1, arg_9_2)
	local var_9_0 = ScriptUnit.extension(arg_9_1, "locomotion_system")

	var_9_0:unfreeze(arg_9_1)

	if (arg_9_2 == "AILocomotionExtensionC" or arg_9_2 == "AILocomotionExtension" or arg_9_2 == "AiHuskLocomotionExtension") and var_9_0.breed.bone_lod_level > 0 and not script_data.bone_lod_disable then
		var_9_0.bone_lod_extension_id = EngineOptimized.bone_lod_register_extension(arg_9_1)
		arg_9_0.animation_lod_units[arg_9_1] = var_9_0
	end
end

function LocomotionSystem.post_update(arg_10_0, arg_10_1, arg_10_2)
	local var_10_0 = arg_10_1.dt

	arg_10_0:post_update_extension("PlayerUnitLocomotionExtension", var_10_0, arg_10_1, arg_10_2)
	LocomotionSystem.super.post_update(arg_10_0, arg_10_1, arg_10_2)
end

function LocomotionSystem.update(arg_11_0, arg_11_1, arg_11_2)
	arg_11_0:update_extensions(arg_11_1, arg_11_2)
	arg_11_0:update_animation_lods()
	arg_11_0:update_actor_proximity_shapes()
end

function LocomotionSystem.update_extensions(arg_12_0, arg_12_1, arg_12_2)
	local var_12_0 = arg_12_1.dt

	arg_12_0:update_extension("PlayerHuskLocomotionExtension", var_12_0, arg_12_1, arg_12_2)
	arg_12_0:update_extension("PlayerUnitLocomotionExtension", var_12_0, arg_12_1, arg_12_2)

	if GameSettingsDevelopment.use_engine_optimized_ai_locomotion then
		if arg_12_0.is_server then
			var_0_0.AILocomotionExtensionC.update(nil, arg_12_2, var_12_0)
		else
			local var_12_1 = arg_12_0.template_data.AiHuskLocomotionExtension

			var_0_0.AiHuskLocomotionExtension.update(var_12_1, arg_12_2, var_12_0)
		end

		local var_12_2 = arg_12_0.template_data.PlayerUnitLocomotionExtension

		var_0_0.PlayerUnitLocomotionExtension.update(var_12_2, arg_12_2, var_12_0)
	else
		for iter_12_0, iter_12_1 in pairs(arg_12_0.template_data) do
			var_0_0[iter_12_0].update(iter_12_1, arg_12_2, var_12_0)
		end
	end
end

function LocomotionSystem.set_override_player(arg_13_0, arg_13_1)
	arg_13_0._override_player = arg_13_1
end

function LocomotionSystem.update_animation_lods(arg_14_0)
	if DEDICATED_SERVER then
		return
	end

	local var_14_0 = (arg_14_0._override_player or Managers.player:local_player()).viewport_name
	local var_14_1 = ScriptWorld.viewport(arg_14_0.world, var_14_0)
	local var_14_2 = ScriptViewport.camera(var_14_1)

	EngineOptimized.bone_lod_update(arg_14_0.world, var_14_2)
end

function LocomotionSystem.update_actor_proximity_shapes(arg_15_0)
	local var_15_0 = POSITION_LOOKUP
	local var_15_1 = Managers.player
	local var_15_2 = World.get_data(arg_15_0.world, "physics_world")
	local var_15_3 = math.degrees_to_radians(17)
	local var_15_4 = Quaternion.forward
	local var_15_5 = var_15_1:human_and_bot_players()

	for iter_15_0, iter_15_1 in pairs(var_15_5) do
		local var_15_6 = iter_15_1.player_unit

		if Unit.alive(var_15_6) and not iter_15_1.remote then
			local var_15_7 = ScriptUnit.extension(var_15_6, "first_person_system")
			local var_15_8 = ScriptUnit.extension(var_15_6, "inventory_system")
			local var_15_9 = var_15_7:current_position()
			local var_15_10 = var_15_4(var_15_7:current_rotation())
			local var_15_11

			if var_15_8:get_wielded_slot_name() == "slot_ranged" then
				local var_15_12 = var_15_8:equipment()
				local var_15_13 = var_15_12.right_hand_wielded_unit or var_15_12.left_hand_wielded_unit

				if var_15_13 and ScriptUnit.has_extension(var_15_13, "spread_system") then
					local var_15_14, var_15_15 = ScriptUnit.extension(var_15_13, "spread_system"):get_current_pitch_and_yaw()

					var_15_11 = math.degrees_to_radians(math.max(var_15_14, var_15_15))
				end
			end

			PhysicsWorld.commit_actor_proximity_shape(var_15_2, var_15_9, var_15_10, 36, var_15_11, true)
		end
	end
end

function LocomotionSystem.rpc_set_affected_by_gravity(arg_16_0, arg_16_1, arg_16_2, arg_16_3)
	local var_16_0 = arg_16_0.unit_storage:unit(arg_16_2)

	if not var_16_0 then
		printf("unit from game_object_id %d is nil", arg_16_2)

		return
	end

	ScriptUnit.extension(var_16_0, "locomotion_system"):set_affected_by_gravity(arg_16_3)
end

local var_0_3 = 9

function LocomotionSystem.rpc_set_animation_driven_movement(arg_17_0, arg_17_1, arg_17_2, arg_17_3, arg_17_4, arg_17_5, arg_17_6, arg_17_7, arg_17_8)
	local var_17_0 = arg_17_0.unit_storage:unit(arg_17_2)

	if not var_17_0 then
		printf("unit from game_object_id %d is nil", arg_17_2)

		return
	end

	local var_17_1 = ScriptUnit.extension(var_17_0, "locomotion_system")

	var_17_1:set_animation_driven(arg_17_3, arg_17_5, arg_17_4, arg_17_6)

	if arg_17_3 then
		local var_17_2 = Unit.local_position(var_17_0, 0)
		local var_17_3 = Vector3.distance_squared(var_17_2, arg_17_7)

		if var_17_3 > var_0_3 then
			local var_17_4 = AiUtils.unit_breed(var_17_0)
			local var_17_5 = var_17_4 and var_17_4.name or "n/a"

			Managers.telemetry_events:breed_position_desync(var_17_2, arg_17_7, var_17_3, var_17_5)
		end

		var_17_1:teleport_to(arg_17_7, arg_17_8, var_17_1:current_velocity())
	end
end

function LocomotionSystem.rpc_set_animation_driven_script_movement(arg_18_0, arg_18_1, arg_18_2, arg_18_3, arg_18_4, arg_18_5)
	arg_18_0:rpc_set_animation_driven_movement(arg_18_1, arg_18_2, true, true, arg_18_5, false, arg_18_3, arg_18_4)
end

function LocomotionSystem.rpc_set_animation_driven(arg_19_0, arg_19_1, arg_19_2, arg_19_3, arg_19_4, arg_19_5)
	arg_19_0:rpc_set_animation_driven_movement(arg_19_1, arg_19_2, true, false, arg_19_5, false, arg_19_3, arg_19_4)
end

function LocomotionSystem.rpc_set_script_driven(arg_20_0, arg_20_1, arg_20_2, arg_20_3)
	arg_20_0:rpc_set_animation_driven_movement(arg_20_1, arg_20_2, false, true, arg_20_3, false)
end

function LocomotionSystem.rpc_set_linked_transport_driven(arg_21_0, arg_21_1, arg_21_2, arg_21_3)
	arg_21_0:rpc_set_animation_driven_movement(arg_21_1, arg_21_2, false, true, arg_21_3, true)
end

function LocomotionSystem.rpc_set_animation_translation_scale(arg_22_0, arg_22_1, arg_22_2, arg_22_3)
	local var_22_0 = arg_22_0.unit_storage:unit(arg_22_2)

	if not var_22_0 then
		printf("unit from game_object_id %d is nil", arg_22_2)

		return
	end

	ScriptUnit.extension(var_22_0, "locomotion_system"):set_animation_translation_scale(arg_22_3)

	if arg_22_0.is_server then
		local var_22_1 = CHANNEL_TO_PEER_ID[arg_22_1]

		arg_22_0.network_transmit:send_rpc_clients_except("rpc_set_animation_translation_scale", var_22_1, arg_22_2, arg_22_3)
	end
end

function LocomotionSystem.rpc_set_animation_rotation_scale(arg_23_0, arg_23_1, arg_23_2, arg_23_3)
	local var_23_0 = arg_23_0.unit_storage:unit(arg_23_2)

	if not var_23_0 then
		printf("unit from game_object_id %d is nil", arg_23_2)

		return
	end

	ScriptUnit.extension(var_23_0, "locomotion_system"):set_animation_rotation_scale(arg_23_3)
end

function LocomotionSystem.rpc_disable_locomotion(arg_24_0, arg_24_1, arg_24_2, arg_24_3, arg_24_4)
	local var_24_0 = arg_24_0.unit_storage:unit(arg_24_2)

	if not var_24_0 then
		printf("unit from game_object_id %d is nil", arg_24_2)

		return
	end

	local var_24_1 = ScriptUnit.extension(var_24_0, "locomotion_system")
	local var_24_2 = LocomotionUtils[NetworkLookup.movement_funcs[arg_24_4]]

	var_24_1:set_disabled(arg_24_3, var_24_2)

	if arg_24_0.is_server then
		local var_24_3 = CHANNEL_TO_PEER_ID[arg_24_1]

		arg_24_0.network_transmit:send_rpc_clients_except("rpc_disable_locomotion", var_24_3, arg_24_2, arg_24_3, arg_24_4)
	end
end

function LocomotionSystem.rpc_teleport_unit_to(arg_25_0, arg_25_1, arg_25_2, arg_25_3, arg_25_4)
	local var_25_0 = arg_25_0.unit_storage:unit(arg_25_2)

	if not var_25_0 then
		printf("unit from game_object_id %d is nil", arg_25_2)

		return
	end

	ScriptUnit.extension(var_25_0, "locomotion_system"):teleport_to(arg_25_3, arg_25_4)

	if arg_25_0.is_server then
		local var_25_1 = CHANNEL_TO_PEER_ID[arg_25_1]

		arg_25_0.network_transmit:send_rpc_clients_except("rpc_teleport_unit_to", var_25_1, arg_25_2, arg_25_3, arg_25_4)
	end
end

function LocomotionSystem.rpc_teleport_unit_with_yaw_rotation(arg_26_0, arg_26_1, arg_26_2, arg_26_3, arg_26_4)
	local var_26_0 = arg_26_0.unit_storage:unit(arg_26_2)

	if not var_26_0 then
		printf("unit from game_object_id %d is nil", arg_26_2)

		return
	end

	local var_26_1 = Quaternion(Vector3.up(), arg_26_4)

	ScriptUnit.extension(var_26_0, "locomotion_system"):teleport_to(arg_26_3, var_26_1)
end

function LocomotionSystem.rpc_enable_linked_movement(arg_27_0, arg_27_1, arg_27_2, arg_27_3, arg_27_4, arg_27_5)
	local var_27_0 = arg_27_0.unit_storage:unit(arg_27_2)

	if not var_27_0 then
		printf("unit from game_object_id %d is nil", arg_27_2)

		return
	end

	local var_27_1 = ScriptUnit.extension(var_27_0, "locomotion_system")
	local var_27_2 = LevelHelper:current_level(arg_27_0.world)
	local var_27_3 = Level.unit_by_index(var_27_2, arg_27_3)

	var_27_1:enable_linked_movement(var_27_3, arg_27_4, arg_27_5)
end

function LocomotionSystem.rpc_disable_linked_movement(arg_28_0, arg_28_1, arg_28_2)
	local var_28_0 = arg_28_0.unit_storage:unit(arg_28_2)

	if not var_28_0 then
		printf("unit from game_object_id %d is nil", arg_28_2)

		return
	end

	ScriptUnit.extension(var_28_0, "locomotion_system"):disable_linked_movement()
end

function LocomotionSystem.rpc_add_external_velocity(arg_29_0, arg_29_1, arg_29_2, arg_29_3)
	local var_29_0 = arg_29_0.unit_storage:unit(arg_29_2)

	if not var_29_0 then
		printf("unit from game_object_id %d is nil", arg_29_2)

		return
	end

	ScriptUnit.extension(var_29_0, "locomotion_system"):add_external_velocity(arg_29_3)
end

function LocomotionSystem.rpc_add_external_velocity_with_upper_limit(arg_30_0, arg_30_1, arg_30_2, arg_30_3, arg_30_4)
	local var_30_0 = arg_30_0.unit_storage:unit(arg_30_2)

	if not var_30_0 then
		printf("unit from game_object_id %d is nil", arg_30_2)

		return
	end

	ScriptUnit.extension(var_30_0, "locomotion_system"):add_external_velocity(arg_30_3, arg_30_4)
end

function LocomotionSystem.rpc_set_forced_velocity(arg_31_0, arg_31_1, arg_31_2, arg_31_3)
	local var_31_0 = arg_31_0.unit_storage:unit(arg_31_2)

	if not var_31_0 then
		printf("unit from game_object_id %d is nil", arg_31_2)

		return
	end

	ScriptUnit.extension(var_31_0, "locomotion_system"):set_forced_velocity(arg_31_3)
end

function LocomotionSystem.rpc_constrain_ai(arg_32_0, arg_32_1, arg_32_2, arg_32_3, arg_32_4)
	local var_32_0 = arg_32_0.unit_storage:unit(arg_32_2)

	if not var_32_0 then
		printf("unit from game_object_id %d is nil", arg_32_2)

		return
	end

	local var_32_1 = arg_32_4[1]
	local var_32_2 = arg_32_4[2]

	ScriptUnit.extension(var_32_0, "locomotion_system"):set_constrained(arg_32_3, var_32_1, var_32_2)
end

function LocomotionSystem.rpc_set_on_moving_platform(arg_33_0, arg_33_1, arg_33_2, arg_33_3)
	local var_33_0 = arg_33_0.unit_storage:unit(arg_33_2)

	if not var_33_0 then
		printf("unit from game_object_id %d is nil", arg_33_2)

		return
	end

	local var_33_1 = LevelHelper:current_level(arg_33_0.world)
	local var_33_2 = Level.unit_by_index(var_33_1, arg_33_3)

	ScriptUnit.extension(var_33_0, "locomotion_system"):set_on_moving_platform(var_33_2)
end

function LocomotionSystem.rpc_hot_join_nail_to_wall_fix(arg_34_0, arg_34_1, arg_34_2)
	local var_34_0 = arg_34_0.unit_storage:unit(arg_34_2)

	if Unit.has_animation_state_machine(var_34_0) then
		Unit.animation_event(var_34_0, "ragdoll")
	end
end
