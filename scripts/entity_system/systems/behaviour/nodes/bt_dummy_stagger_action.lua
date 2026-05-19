-- chunkname: @scripts/entity_system/systems/behaviour/nodes/bt_dummy_stagger_action.lua

require("scripts/entity_system/systems/behaviour/nodes/bt_node")

local var_0_0 = require("scripts/utils/stagger_types")

BTDummyStaggerAction = class(BTDummyStaggerAction, BTNode)

function BTDummyStaggerAction.init(arg_1_0, ...)
	BTDummyStaggerAction.super.init(arg_1_0, ...)
end

BTDummyStaggerAction.name = "BTDummyStaggerAction"

local var_0_1 = 0.35

function BTDummyStaggerAction.enter(arg_2_0, arg_2_1, arg_2_2, arg_2_3)
	local var_2_0 = arg_2_2.breed

	if arg_2_2.staggering_id then
		local var_2_1

		var_2_1 = arg_2_2.stagger ~= arg_2_2.staggering_id
	end

	arg_2_2.stagger_anim_done = false
	arg_2_2.stagger_hit_wall = nil
	arg_2_2.stagger_ignore_anim_cb = nil
	arg_2_2.staggering_id = arg_2_2.stagger
	arg_2_2.attack_aborted = true
	arg_2_2.move_state = "stagger"
	arg_2_2.active_node = BTDummyStaggerAction
	arg_2_2.stagger_time = arg_2_3 + 0.35

	local var_2_2 = arg_2_0._tree_node.action_data

	arg_2_2.action = var_2_2

	ScriptUnit.extension(arg_2_1, "ai_system"):increase_stagger_count()

	local var_2_3
	local var_2_4
	local var_2_5
	local var_2_6
	local var_2_7 = "idle"
	local var_2_8 = var_2_2.stagger_anims[arg_2_2.stagger_type]
	local var_2_9 = arg_2_2.stagger_direction:unbox()
	local var_2_10, var_2_11 = arg_2_0:_select_animation(arg_2_1, arg_2_2, var_2_9, var_2_8)

	Managers.state.network:anim_event(arg_2_1, var_2_10)
end

function BTDummyStaggerAction._select_animation(arg_3_0, arg_3_1, arg_3_2, arg_3_3, arg_3_4)
	local var_3_0 = Vector3.normalize(arg_3_3)
	local var_3_1 = Quaternion.forward(Unit.local_rotation(arg_3_1, 0))
	local var_3_2 = Vector3.dot(var_3_1, var_3_0)
	local var_3_3 = math.clamp(var_3_2, -1, 1)
	local var_3_4 = math.acos(var_3_3)
	local var_3_5 = arg_3_2.action
	local var_3_6 = arg_3_2.locomotion_extension
	local var_3_7 = var_3_6 and var_3_6:current_velocity() or Vector3(0, 0, 0)
	local var_3_8
	local var_3_9
	local var_3_10 = var_3_5.moving_stagger_minimum_destination_distance
	local var_3_11 = var_3_10 and var_3_10 < arg_3_2.destination_dist
	local var_3_12 = var_3_5.moving_stagger_threshold
	local var_3_13 = Vector3.dot(var_3_7, var_3_1)
	local var_3_14 = var_3_12 and var_3_12 < var_3_13
	local var_3_15 = false

	if not arg_3_2.always_stagger_suffered then
		var_3_15 = var_3_11 and var_3_14
	end

	arg_3_2.always_stagger_suffered = nil

	if arg_3_3.z == -1 and arg_3_4.dwn then
		var_3_0.z = 0
		var_3_8 = Quaternion.look(-var_3_0)
		var_3_9 = var_3_15 and arg_3_4.moving_dwn or arg_3_4.dwn
	else
		var_3_0.z = 0

		if var_3_4 > math.pi * 0.75 then
			var_3_8 = Quaternion.look(-var_3_0)
			var_3_9 = var_3_15 and arg_3_4.moving_bwd or arg_3_4.bwd
		elseif var_3_4 < math.pi * 0.25 then
			var_3_8 = Quaternion.look(var_3_0)
			var_3_9 = var_3_15 and arg_3_4.moving_fwd or arg_3_4.fwd
		elseif Vector3.cross(var_3_1, var_3_0).z > 0 then
			local var_3_16 = Vector3.cross(Vector3(0, 0, -1), var_3_0)

			var_3_8 = Quaternion.look(var_3_16)
			var_3_9 = var_3_15 and arg_3_4.moving_left or arg_3_4.left
		else
			local var_3_17 = Vector3.cross(Vector3(0, 0, 1), var_3_0)

			var_3_8 = Quaternion.look(var_3_17)
			var_3_9 = var_3_15 and arg_3_4.moving_right or arg_3_4.right
		end
	end

	local var_3_18 = #var_3_9
	local var_3_19 = Math.random(1, var_3_18)
	local var_3_20 = var_3_9[var_3_19]

	if var_3_20 == arg_3_2.last_stagger_anim then
		var_3_20 = var_3_9[var_3_19 % var_3_18 + 1]
	end

	arg_3_2.last_stagger_anim = var_3_20

	local var_3_21 = Quaternion.yaw(var_3_8)
	local var_3_22 = Quaternion(Vector3.up(), var_3_21)

	return var_3_20, var_3_22
end

function BTDummyStaggerAction.clean_blackboard(arg_4_0, arg_4_1)
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
end

function BTDummyStaggerAction.leave(arg_5_0, arg_5_1, arg_5_2, arg_5_3, arg_5_4, arg_5_5)
	arg_5_0:clean_blackboard(arg_5_2)

	if not arg_5_5 then
		local var_5_0 = Managers.state.network
		local var_5_1

		if arg_5_2.post_stagger_event then
			var_5_1 = arg_5_2.post_stagger_event
			arg_5_2.post_stagger_event = nil
		else
			var_5_1 = "stagger_finished"
		end

		var_5_0:anim_event(arg_5_1, var_5_1)
	end

	local var_5_2 = arg_5_2.breed.run_on_stagger_action_done

	if var_5_2 then
		var_5_2(arg_5_1, arg_5_2, arg_5_3)
	end

	ScriptUnit.has_extension(arg_5_1, "hit_reaction_system").force_ragdoll_on_death = nil
end

function BTDummyStaggerAction.run(arg_6_0, arg_6_1, arg_6_2, arg_6_3, arg_6_4)
	if arg_6_2.stagger ~= arg_6_2.staggering_id then
		arg_6_0:enter(arg_6_1, arg_6_2, arg_6_3)
	end

	local var_6_0 = arg_6_2.locomotion_extension
	local var_6_1 = arg_6_2.stagger_anim_done
	local var_6_2 = arg_6_3 > arg_6_2.stagger_time
	local var_6_3 = arg_6_2.stagger_ignore_anim_cb

	if arg_6_2.stagger_immune_time and arg_6_3 > arg_6_2.stagger_immune_time then
		arg_6_2.stagger_immune_time = nil
	end

	if arg_6_2.heavy_stagger_immune_time and arg_6_3 > arg_6_2.heavy_stagger_immune_time then
		arg_6_2.heavy_stagger_immune_time = nil
	end

	if var_6_2 then
		return "done"
	else
		return "running"
	end
end

function BTDummyStaggerAction.anim_cb_push_cancel(arg_7_0, arg_7_1, arg_7_2)
	if arg_7_2.stagger_type and arg_7_2.stagger_type == 9 then
		Managers.state.network:anim_event(arg_7_1, "stagger_finished")

		arg_7_2.stagger_anim_done = true
	end
end
