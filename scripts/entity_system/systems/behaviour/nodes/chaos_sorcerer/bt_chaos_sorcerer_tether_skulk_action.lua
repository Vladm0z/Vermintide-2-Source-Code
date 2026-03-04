-- chunkname: @scripts/entity_system/systems/behaviour/nodes/chaos_sorcerer/bt_chaos_sorcerer_tether_skulk_action.lua

require("scripts/entity_system/systems/behaviour/nodes/bt_node")

BTChaosSorcererTetherSkulkAction = class(BTChaosSorcererTetherSkulkAction, BTNode)

local var_0_0 = BTChaosSorcererTetherSkulkAction
local var_0_1 = POSITION_LOOKUP

function var_0_0.init(arg_1_0, ...)
	var_0_0.super.init(arg_1_0, ...)
end

var_0_0.name = "BTChaosSorcererTetherSkulkAction"

function var_0_0.enter(arg_2_0, arg_2_1, arg_2_2, arg_2_3)
	local var_2_0 = arg_2_0._tree_node.action_data
	local var_2_1 = arg_2_2.skulk_data or {}

	arg_2_2.skulk_data = var_2_1
	var_2_1.direction = var_2_1.direction or var_2_0.direction or 1 - math.random(0, 1) * 2
	var_2_1.radius = var_2_1.radius or arg_2_2.target_dist
	var_2_1.last_reference_pos = var_2_1.last_reference_pos or Vector3Box()

	var_2_1.last_reference_pos:store(Vector3.zero())

	arg_2_2.action = var_2_0

	if arg_2_2.move_state ~= "idle" then
		arg_2_0:idle(arg_2_1, arg_2_2)
	end

	LocomotionUtils.set_animation_driven_movement(arg_2_1, false)

	if arg_2_2.move_pos then
		local var_2_2 = arg_2_2.move_pos:unbox()

		arg_2_0:move_to(var_2_2, arg_2_1, arg_2_2)
	end

	arg_2_2.health_extension = ScriptUnit.extension(arg_2_1, "health_system")

	arg_2_2.locomotion_extension:use_lerp_rotation(true)
	arg_2_2.locomotion_extension:set_rotation_speed(math.pi)
end

function var_0_0.leave(arg_3_0, arg_3_1, arg_3_2, arg_3_3, arg_3_4, arg_3_5)
	local var_3_0 = arg_3_2.skulk_data
	local var_3_1 = AiUtils.get_default_breed_move_speed(arg_3_1, arg_3_2)
	local var_3_2 = arg_3_2.navigation_extension

	var_3_2:set_max_speed(var_3_1)

	if arg_3_4 == "aborted" then
		local var_3_3 = var_3_2:is_following_path()

		if arg_3_2.move_pos and var_3_3 and arg_3_2.move_state == "idle" then
			arg_3_0:start_move_animation(arg_3_1, arg_3_2)
		end
	end

	var_3_0.animation_state = nil
	arg_3_2.action = nil

	arg_3_2.locomotion_extension:use_lerp_rotation(false)
	arg_3_2.locomotion_extension:set_rotation_speed(nil)

	if arg_3_4 == "failed" then
		arg_3_2.target_unit = nil
	end
end

function var_0_0.run(arg_4_0, arg_4_1, arg_4_2, arg_4_3, arg_4_4)
	if not Unit.alive(arg_4_2.target_unit) then
		return "failed"
	end

	local var_4_0 = arg_4_2.navigation_extension
	local var_4_1 = var_4_0:is_following_path()
	local var_4_2 = var_4_0:number_failed_move_attempts()

	if arg_4_2.move_pos and var_4_1 and arg_4_2.move_state == "idle" then
		arg_4_0:start_move_animation(arg_4_1, arg_4_2)
	end

	if arg_4_2.vanish_timer and arg_4_3 < arg_4_2.vanish_timer then
		Managers.state.entity:system("ping_system"):remove_ping_from_unit(arg_4_1)

		return "running"
	end

	if arg_4_2.move_pos then
		if arg_4_0:at_goal(arg_4_1, arg_4_2) or var_4_2 > 0 then
			arg_4_2.move_pos = nil
		end

		return "running"
	end

	local var_4_3 = arg_4_0:get_skulk_target(arg_4_1, arg_4_2)

	if var_4_3 then
		arg_4_0:move_to(var_4_3, arg_4_1, arg_4_2)

		return "running"
	end

	if arg_4_2.move_state ~= "idle" then
		arg_4_0:idle(arg_4_1, arg_4_2)
	end

	return "running"
end

function var_0_0.at_goal(arg_5_0, arg_5_1, arg_5_2)
	local var_5_0 = arg_5_2.move_pos
	local var_5_1 = var_0_1[arg_5_1]

	if not var_5_0 then
		return false
	end

	local var_5_2 = var_5_0:unbox()

	if (var_5_2[3] - var_5_1[3])^2 > 0.5 then
		return false
	end

	return (var_5_2[1] - var_5_1[1])^2 + (var_5_2[2] - var_5_1[2])^2 < 1
end

function var_0_0.move_to(arg_6_0, arg_6_1, arg_6_2, arg_6_3)
	arg_6_3.navigation_extension:move_to(arg_6_1)

	arg_6_3.move_pos = Vector3Box(arg_6_1)
end

function var_0_0.idle(arg_7_0, arg_7_1, arg_7_2)
	arg_7_0:anim_event(arg_7_1, arg_7_2, "idle")

	arg_7_2.move_state = "idle"
end

function var_0_0.start_move_animation(arg_8_0, arg_8_1, arg_8_2)
	local var_8_0 = arg_8_2.action.move_animation

	arg_8_0:anim_event(arg_8_1, arg_8_2, var_8_0)

	arg_8_2.move_state = "moving"
end

function var_0_0.anim_event(arg_9_0, arg_9_1, arg_9_2, arg_9_3)
	local var_9_0 = arg_9_2.skulk_data

	if var_9_0.animation_state ~= arg_9_3 then
		Managers.state.network:anim_event(arg_9_1, arg_9_3)

		var_9_0.animation_state = arg_9_3
	end
end

local var_0_2 = 30

function var_0_0.get_skulk_target(arg_10_0, arg_10_1, arg_10_2, arg_10_3)
	local var_10_0 = arg_10_2.target_unit

	if not var_10_0 then
		return
	end

	local var_10_1 = arg_10_2.action
	local var_10_2 = arg_10_2.skulk_data
	local var_10_3 = var_10_2.direction
	local var_10_4 = var_0_1[var_10_0]
	local var_10_5 = var_0_1[arg_10_1]
	local var_10_6 = var_10_2.last_reference_pos:unbox()

	if Vector3.length_squared(var_10_6) <= 0 then
		var_10_6 = var_10_5
	end

	local var_10_7 = var_10_4 - var_10_6
	local var_10_8 = Vector3.normalize(var_10_7)
	local var_10_9 = var_10_1.preferred_distance_variance or 0
	local var_10_10 = (var_10_1.preferred_distance or 20) + math.lerp(-var_10_9, var_10_9, math.random())
	local var_10_11 = var_10_1.distance_before_turn or 5
	local var_10_12 = var_10_10 * 2 * math.pi

	assert(var_10_11 < var_10_12 * 0.25, "preferred distance is too small to move %s units before turning. Minimum %s (quarter of the circumference)", var_10_11, var_10_12 * 0.25)

	local var_10_13 = math.tau * (var_10_11 / var_10_12)
	local var_10_14 = Quaternion.rotate(Quaternion.axis_angle(Vector3.up() * var_10_3, var_10_13), -var_10_8) * var_10_10
	local var_10_15 = var_10_4 + var_10_14
	local var_10_16 = var_10_15 - var_10_5
	local var_10_17 = GwNavQueries.raycango
	local var_10_18 = arg_10_2.nav_world
	local var_10_19 = arg_10_2.navigation_extension:traverse_logic()
	local var_10_20 = math.pi * 2 / var_0_2
	local var_10_21 = Quaternion.axis_angle(Vector3(0, 0, math.sign(Vector3.cross(var_10_14, var_10_16)[3])), var_10_20)
	local var_10_22 = Vector3.normalize(var_10_16)
	local var_10_23
	local var_10_24

	for iter_10_0 = 1, var_0_2 do
		local var_10_25 = var_10_5 + var_10_22 * var_10_11

		var_10_25 = LocomotionUtils.pos_on_mesh(var_10_18, var_10_25, 5, 5) or var_10_25

		local var_10_26, var_10_27 = var_10_17(var_10_18, var_10_5, var_10_25, var_10_19)

		if var_10_26 then
			local var_10_28 = LocomotionUtils.pos_on_mesh(var_10_18, var_10_25, 2, 2)

			if var_10_28 then
				var_10_23 = var_10_28
			end

			break
		end

		if var_10_27 then
			local var_10_29 = LocomotionUtils.pos_on_mesh(var_10_18, var_10_5 + (var_10_27 - var_10_5) * 0.5, 1, 1)

			if var_10_29 then
				var_10_24 = var_10_29
			end
		end

		var_10_22 = Quaternion.rotate(var_10_21, var_10_22)
	end

	var_10_23 = var_10_23 or var_10_24

	var_10_2.last_reference_pos:store(var_10_15)

	return var_10_23
end
