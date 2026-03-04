-- chunkname: @scripts/entity_system/systems/behaviour/nodes/bt_stagger_action.lua

require("scripts/entity_system/systems/behaviour/nodes/bt_node")

local var_0_0 = require("scripts/utils/stagger_types")

BTStaggerAction = class(BTStaggerAction, BTNode)

function BTStaggerAction.init(arg_1_0, ...)
	BTStaggerAction.super.init(arg_1_0, ...)
end

BTStaggerAction.name = "BTStaggerAction"

local var_0_1 = 0.35

function BTStaggerAction.enter(arg_2_0, arg_2_1, arg_2_2, arg_2_3)
	local var_2_0 = arg_2_2.locomotion_extension

	arg_2_2.navigation_extension:set_enabled(false)

	local var_2_1 = arg_2_2.breed
	local var_2_2 = arg_2_2.staggering_id and arg_2_2.stagger ~= arg_2_2.staggering_id

	if not var_2_2 then
		local var_2_3 = var_2_1.override_mover_move_distance

		var_2_0:set_movement_type("constrained_by_mover", var_2_3, true)
	end

	arg_2_2.stagger_anim_done = false
	arg_2_2.stagger_hit_wall = nil
	arg_2_2.stagger_ignore_anim_cb = nil
	arg_2_2.staggering_id = arg_2_2.stagger
	arg_2_2.attack_aborted = true
	arg_2_2.move_state = "stagger"
	arg_2_2.active_node = BTStaggerAction

	local var_2_4 = arg_2_0._tree_node.action_data

	arg_2_2.action = var_2_4

	ScriptUnit.extension(arg_2_1, "ai_system"):increase_stagger_count()

	local var_2_5
	local var_2_6
	local var_2_7
	local var_2_8
	local var_2_9 = var_2_4.custom_enter_function

	if var_2_9 then
		local var_2_10

		var_2_5, var_2_6, var_2_10, var_2_8 = var_2_9(arg_2_1, arg_2_2, arg_2_3, var_2_4)

		if var_2_10 then
			arg_2_2.post_stagger_event = var_2_10
		end
	else
		var_2_6 = "idle"
		var_2_5 = var_2_4.stagger_anims[arg_2_2.stagger_type]
	end

	if var_2_4.custom_weakspot_function and arg_2_2.stagger_type == var_0_0.weakspot then
		var_2_4.custom_weakspot_function(arg_2_1, arg_2_2, arg_2_3, var_2_4)
	end

	local var_2_11 = arg_2_2.stagger_direction:unbox()
	local var_2_12, var_2_13 = arg_2_0:_select_animation(arg_2_1, arg_2_2, var_2_11, var_2_5)

	Unit.set_local_rotation(arg_2_1, 0, var_2_8 or var_2_13)

	local var_2_14 = Managers.state.network

	if var_2_4.scale_animation_speeds then
		local var_2_15 = var_2_4.stagger_animation_scale or arg_2_2.stagger_animation_scale or 1

		var_2_14:anim_event_with_variable_float(arg_2_1, var_2_12, "stagger_scale", var_2_15)
	else
		var_2_14:anim_event(arg_2_1, var_2_12)
	end

	var_2_14:anim_event(arg_2_1, var_2_6)

	local var_2_16 = arg_2_2.stagger_length

	LocomotionUtils.set_animation_translation_scale(arg_2_1, Vector3(var_2_16, var_2_16, var_2_16))

	if var_2_2 then
		local var_2_17 = var_2_14:unit_game_object_id(arg_2_1)
		local var_2_18 = POSITION_LOOKUP[arg_2_1]
		local var_2_19 = Quaternion.yaw(var_2_13)

		var_2_14.network_transmit:send_rpc_clients("rpc_teleport_unit_with_yaw_rotation", var_2_17, var_2_18, var_2_19)
	else
		LocomotionUtils.set_animation_driven_movement(arg_2_1, true, true, false)
	end

	if arg_2_2.stagger_type == var_0_0.heavy or arg_2_2.stagger_type == var_0_0.explosion then
		ScriptUnit.extension(arg_2_1, "hit_reaction_system").force_ragdoll_on_death = true
	end

	var_2_0:set_rotation_speed(100)
	var_2_0:set_wanted_velocity(Vector3.zero())
	var_2_0:use_lerp_rotation(false)

	arg_2_2.spawn_to_running = nil

	local var_2_20 = Managers.state.entity:system("ai_slot_system")

	var_2_20:do_slot_search(arg_2_1, false)
	var_2_20:ai_unit_staggered(arg_2_1)
end

function BTStaggerAction._select_animation(arg_3_0, arg_3_1, arg_3_2, arg_3_3, arg_3_4)
	local var_3_0 = Vector3.normalize(arg_3_3)
	local var_3_1 = Quaternion.forward(Unit.local_rotation(arg_3_1, 0))
	local var_3_2 = Vector3.dot(var_3_1, var_3_0)
	local var_3_3 = math.clamp(var_3_2, -1, 1)
	local var_3_4 = math.acos(var_3_3)
	local var_3_5 = arg_3_2.action
	local var_3_6 = arg_3_2.locomotion_extension:current_velocity()
	local var_3_7
	local var_3_8
	local var_3_9 = var_3_5.moving_stagger_minimum_destination_distance
	local var_3_10 = var_3_9 and var_3_9 < arg_3_2.destination_dist
	local var_3_11 = var_3_5.moving_stagger_threshold
	local var_3_12 = Vector3.dot(var_3_6, var_3_1)
	local var_3_13 = var_3_11 and var_3_11 < var_3_12
	local var_3_14 = false

	if not arg_3_2.always_stagger_suffered then
		var_3_14 = var_3_10 and var_3_13
	end

	arg_3_2.always_stagger_suffered = nil

	if arg_3_3.z == -1 and arg_3_4.dwn then
		var_3_0.z = 0
		var_3_7 = Quaternion.look(-var_3_0)
		var_3_8 = var_3_14 and arg_3_4.moving_dwn or arg_3_4.dwn
	else
		var_3_0.z = 0

		if var_3_4 > math.pi * 0.75 then
			var_3_7 = Quaternion.look(-var_3_0)
			var_3_8 = var_3_14 and arg_3_4.moving_bwd or arg_3_4.bwd
		elseif var_3_4 < math.pi * 0.25 then
			var_3_7 = Quaternion.look(var_3_0)
			var_3_8 = var_3_14 and arg_3_4.moving_fwd or arg_3_4.fwd
		elseif Vector3.cross(var_3_1, var_3_0).z > 0 then
			local var_3_15 = Vector3.cross(Vector3(0, 0, -1), var_3_0)

			var_3_7 = Quaternion.look(var_3_15)
			var_3_8 = var_3_14 and arg_3_4.moving_left or arg_3_4.left
		else
			local var_3_16 = Vector3.cross(Vector3(0, 0, 1), var_3_0)

			var_3_7 = Quaternion.look(var_3_16)
			var_3_8 = var_3_14 and arg_3_4.moving_right or arg_3_4.right
		end
	end

	local var_3_17 = #var_3_8
	local var_3_18 = Math.random(1, var_3_17)
	local var_3_19 = var_3_8[var_3_18]

	if var_3_19 == arg_3_2.last_stagger_anim then
		var_3_19 = var_3_8[var_3_18 % var_3_17 + 1]
	end

	arg_3_2.last_stagger_anim = var_3_19

	local var_3_20 = Quaternion.yaw(var_3_7)
	local var_3_21 = Quaternion(Vector3.up(), var_3_20)

	return var_3_19, var_3_21
end

function BTStaggerAction.clean_blackboard(arg_4_0, arg_4_1)
	arg_4_1.action = nil
	arg_4_1.heavy_stagger_immune_time = nil
	arg_4_1.pushing_unit = nil
	arg_4_1.stagger = nil
	arg_4_1.stagger_anim_done = nil
	arg_4_1.stagger_direction = nil
	arg_4_1.stagger_hit_wall = nil
	arg_4_1.stagger_ignore_anim_cb = nil
	arg_4_1.stagger_immune_time = nil
	arg_4_1.stagger_length = nil
	arg_4_1.stagger_time = nil
	arg_4_1.stagger_type = nil
	arg_4_1.staggering_id = nil
	arg_4_1.active_node = nil
	arg_4_1.stagger_activated = nil
end

function BTStaggerAction.leave(arg_5_0, arg_5_1, arg_5_2, arg_5_3, arg_5_4, arg_5_5)
	if not arg_5_5 then
		LocomotionUtils.set_animation_driven_movement(arg_5_1, false, false)
	end

	if ScriptUnit.has_extension(arg_5_1, "ai_shield_system") and not arg_5_2.action.ignore_block_on_leave then
		ScriptUnit.extension(arg_5_1, "ai_shield_system"):set_is_blocking(true)
	end

	arg_5_0:clean_blackboard(arg_5_2)

	if not arg_5_5 then
		local var_5_0 = arg_5_2.locomotion_extension

		var_5_0:set_rotation_speed(10)
		var_5_0:set_wanted_rotation(nil)
		var_5_0:set_movement_type("snap_to_navmesh")
		var_5_0:use_lerp_rotation(true)
		var_5_0:set_wanted_velocity(Vector3.zero())
		LocomotionUtils.set_animation_translation_scale(arg_5_1, Vector3(1, 1, 1))

		local var_5_1 = Managers.state.network
		local var_5_2

		if arg_5_2.post_stagger_event then
			var_5_2 = arg_5_2.post_stagger_event
			arg_5_2.post_stagger_event = nil
		else
			var_5_2 = "stagger_finished"
		end

		var_5_1:anim_event(arg_5_1, var_5_2)
	end

	arg_5_2.navigation_extension:set_enabled(true)

	local var_5_3 = arg_5_2.breed.run_on_stagger_action_done

	if var_5_3 then
		var_5_3(arg_5_1, arg_5_2, arg_5_3)
	end

	ScriptUnit.has_extension(arg_5_1, "hit_reaction_system").force_ragdoll_on_death = nil

	Managers.state.entity:system("ai_slot_system"):do_slot_search(arg_5_1, true)
end

function BTStaggerAction.run(arg_6_0, arg_6_1, arg_6_2, arg_6_3, arg_6_4)
	if arg_6_2.stagger ~= arg_6_2.staggering_id then
		arg_6_0:enter(arg_6_1, arg_6_2, arg_6_3)
	end

	local var_6_0 = arg_6_2.locomotion_extension
	local var_6_1 = arg_6_2.stagger_anim_done

	if var_6_0.movement_type ~= "constrained_by_mover" and not arg_6_2.stagger_hit_wall then
		local var_6_2 = POSITION_LOOKUP[arg_6_1]
		local var_6_3 = var_6_0:current_velocity()
		local var_6_4 = arg_6_2.nav_world
		local var_6_5 = arg_6_2.world
		local var_6_6 = World.physics_world(var_6_5)
		local var_6_7 = arg_6_2.navigation_extension:traverse_logic()
		local var_6_8 = LocomotionUtils.navmesh_movement_check(var_6_2, var_6_3, var_6_4, var_6_6, var_6_7)

		if var_6_8 == "navmesh_hit_wall" then
			arg_6_2.stagger_hit_wall = true
		elseif var_6_8 == "navmesh_use_mover" then
			local var_6_9 = arg_6_2.breed.override_mover_move_distance
			local var_6_10 = true

			if not var_6_0:set_movement_type("constrained_by_mover", var_6_9, var_6_10) then
				var_6_0:set_movement_type("snap_to_navmesh")

				arg_6_2.stagger_hit_wall = true
			end
		end
	end

	local var_6_11 = arg_6_3 > arg_6_2.stagger_time
	local var_6_12 = arg_6_2.stagger_ignore_anim_cb

	if arg_6_2.stagger_immune_time and arg_6_3 > arg_6_2.stagger_immune_time then
		arg_6_2.stagger_immune_time = nil
	end

	if arg_6_2.heavy_stagger_immune_time and arg_6_3 > arg_6_2.heavy_stagger_immune_time then
		arg_6_2.heavy_stagger_immune_time = nil
	end

	if var_6_11 and (var_6_12 or var_6_1) then
		return "done"
	else
		return "running"
	end
end

function BTStaggerAction.anim_cb_push_cancel(arg_7_0, arg_7_1, arg_7_2)
	if arg_7_2.stagger_type and arg_7_2.stagger_type == 9 then
		Managers.state.network:anim_event(arg_7_1, "stagger_finished")

		arg_7_2.stagger_anim_done = true
	end
end
