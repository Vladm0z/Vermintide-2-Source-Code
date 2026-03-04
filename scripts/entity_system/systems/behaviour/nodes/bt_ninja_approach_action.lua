-- chunkname: @scripts/entity_system/systems/behaviour/nodes/bt_ninja_approach_action.lua

require("scripts/entity_system/systems/behaviour/nodes/bt_node")

BTNinjaApproachAction = class(BTNinjaApproachAction, BTNode)
BTNinjaApproachAction.name = "BTNinjaApproachAction"

local var_0_0 = POSITION_LOOKUP
local var_0_1 = script_data

BTNinjaApproachAction.init = function (arg_1_0, ...)
	BTNinjaApproachAction.super.init(arg_1_0, ...)
end

local function var_0_2(arg_2_0, arg_2_1, arg_2_2)
	if var_0_1.debug_ai_movement then
		Debug.world_sticky_text(var_0_0[arg_2_0], arg_2_1, arg_2_2)
	end
end

BTNinjaApproachAction.enter = function (arg_3_0, arg_3_1, arg_3_2, arg_3_3)
	arg_3_2.action = arg_3_0._tree_node.action_data
	arg_3_2.approach_fail_into_vanish_timer = arg_3_2.approach_fail_into_vanish_timer or 0

	LocomotionUtils.set_animation_driven_movement(arg_3_1, false)
	Managers.state.network:anim_event(arg_3_1, "move_fwd")

	arg_3_2.move_state = "moving"

	arg_3_2.navigation_extension:set_max_speed(arg_3_2.breed.run_speed)

	arg_3_2.target_skulk_time = arg_3_3 + 0.5
	arg_3_2.skulk_jump_tries = arg_3_2.skulk_jump_tries or 0

	local var_3_0 = arg_3_2.locomotion_extension

	var_3_0:set_rotation_speed(5)
	var_3_0:set_movement_type("snap_to_navmesh")

	if not arg_3_2.skulk_data then
		arg_3_2.skulk_data = {}
	end

	local var_3_1 = arg_3_2.skulk_data

	if arg_3_2.need_to_recalculate_skulk_pos then
		arg_3_2.need_to_recalculate_skulk_pos = false
		arg_3_2.skulk_pos = nil
	end

	if arg_3_2.skulk_pos then
		local var_3_2 = arg_3_2.skulk_pos:unbox()

		arg_3_2.navigation_extension:move_to(var_3_2)
	end
end

BTNinjaApproachAction.leave = function (arg_4_0, arg_4_1, arg_4_2, arg_4_3, arg_4_4, arg_4_5)
	if arg_4_4 == "aborted" then
		-- Nothing
	end

	arg_4_2.in_los = nil
	arg_4_2.action = nil
	arg_4_2.ninja_approach = false

	local var_4_0 = AiUtils.get_default_breed_move_speed(arg_4_1, arg_4_2)

	arg_4_2.navigation_extension:set_max_speed(var_4_0)
end

local var_0_3 = {}
local var_0_4 = 8

BTNinjaApproachAction.run = function (arg_5_0, arg_5_1, arg_5_2, arg_5_3, arg_5_4)
	local var_5_0 = arg_5_2.locomotion_extension
	local var_5_1 = arg_5_2.breed

	if not var_0_0[arg_5_2.target_unit] then
		arg_5_2.target_unit = nil

		return "failed"
	end

	if arg_5_2.high_ground_opportunity then
		arg_5_2.high_ground_opportunity = false

		return "done"
	end

	if not arg_5_2.skulk_pos and not arg_5_0:get_new_goal(arg_5_1, arg_5_2, arg_5_3) then
		aiprint("Tried to find new GR skulk goal, but could not")

		if not arg_5_0:get_fallback_goal(arg_5_1, arg_5_2) then
			var_0_2(arg_5_1, "SkulkAction 2nd fallback goal 1", "green")
			aiprint("Failed finding 2nd fallback goal")

			return "done"
		end
	end

	if arg_5_2.dodging then
		if arg_5_3 > arg_5_2.dodging then
			arg_5_2.dodging = nil
		end
	else
		local var_5_2, var_5_3 = LocomotionUtils.in_crosshairs_dodge(arg_5_1, arg_5_2, arg_5_3, 1, nil)

		if var_5_2 then
			arg_5_0:dodge(arg_5_1, arg_5_2, var_5_2, var_5_3)
			Managers.state.network:anim_event(arg_5_1, "dodge_run_fwd")

			arg_5_2.dodging = arg_5_3 + 1.5
		end
	end

	if arg_5_2.dodge_pos then
		local var_5_4 = arg_5_2.dodge_pos:unbox()
		local var_5_5 = var_0_0[arg_5_1]
		local var_5_6 = var_5_4 - var_5_5
		local var_5_7 = Unit.local_rotation(arg_5_1, 0)
		local var_5_8 = Quaternion.forward(var_5_7)

		if Vector3.dot(Vector3.normalize(var_5_6), var_5_8) < 0 then
			arg_5_2.dodge_pos = nil

			arg_5_2.navigation_extension:move_to(arg_5_2.skulk_pos:unbox())

			if var_0_1.debug_ai_movement then
				QuickDrawerStay:line(var_5_5, var_5_5 + Vector3(0, 0, 3), Color(255, 0, 0))
			end
		else
			return "running"
		end
	end

	if not arg_5_2.urgency_to_engage or arg_5_2.urgency_to_engage > 0 then
		local var_5_9 = POSITION_LOOKUP[arg_5_2.target_unit]
		local var_5_10 = var_0_0[arg_5_1]
		local var_5_11 = Vector3.distance(var_5_10, var_5_9)
		local var_5_12 = var_5_11 < var_0_4

		if arg_5_3 > arg_5_2.target_skulk_time or var_5_12 then
			if var_5_11 < var_5_1.jump_range then
				arg_5_2.skulk_jump_tries = arg_5_2.skulk_jump_tries + 1

				if math.random() < arg_5_2.skulk_jump_tries / 3 then
					arg_5_2.in_los = arg_5_0:check_free_los(arg_5_1, arg_5_2)

					if arg_5_2.in_los then
						arg_5_2.skulk_jump_tries = 0

						var_0_2(arg_5_1, "SkulkAction in LOS done!", "green")

						return "done"
					else
						arg_5_0:get_new_goal(arg_5_1, arg_5_2, arg_5_3)
					end

					var_0_2(arg_5_1, "ApproachAction not in LOS", "yellow")
				elseif var_5_12 then
					arg_5_2.in_los = arg_5_0:check_free_los(arg_5_1, arg_5_2)

					if arg_5_2.in_los then
						arg_5_2.skulk_jump_tries = 0

						var_0_2(arg_5_1, "SkulkAction in LOS(close) done!", "green")

						return "done"
					end

					arg_5_0:get_new_goal(arg_5_1, arg_5_2, arg_5_3)
					var_0_2(arg_5_1, "SkulkAction not in LOS", "yellow")
				end
			else
				aiprint("Too far away to crazy jump (A)")
			end

			arg_5_2.target_skulk_time = arg_5_3 + 0.5

			aiprint("skulk try failed:", arg_5_2.skulk_jump_tries)
		end

		if arg_5_2.no_path_found then
			if arg_5_3 > arg_5_2.approach_fail_into_vanish_timer then
				arg_5_2.approach_fail_into_vanish_timer = arg_5_3 + 10
				arg_5_2.ninja_vanish = true
			elseif arg_5_2.skulk_around_dir then
				arg_5_2.skulk_around_dir = -arg_5_2.skulk_around_dir

				arg_5_0:get_new_goal(arg_5_1, arg_5_2, arg_5_3)
			end
		end
	else
		aiprint("GR no urgency to engage")
	end

	if var_0_1.debug_ai_movement then
		arg_5_0:debug(arg_5_1, arg_5_2)
	end

	var_5_0:set_wanted_rotation(nil)

	local var_5_13 = arg_5_2.skulk_pos:unbox()

	if Vector3.distance(var_5_13, var_0_0[arg_5_1]) < 3 then
		if arg_5_0:get_new_goal(arg_5_1, arg_5_2, arg_5_3) then
			return "running"
		end

		arg_5_2.in_los = arg_5_0:check_free_los(arg_5_1, arg_5_2)

		if arg_5_2.in_los and arg_5_3 > arg_5_2.target_skulk_time then
			var_0_2(arg_5_1, "SkulkAction in LOS first fallback", "green")

			return "done"
		end

		if not arg_5_0:get_fallback_goal(arg_5_1, arg_5_2) then
			aiprint("Failed finding 2nd fallback goal")
			var_0_2(arg_5_1, "SkulkAction in LOS 2nd fallback goal 2", "green")

			return "done"
		end
	end

	if arg_5_2.navigation_extension:number_failed_move_attempts() > 1 then
		arg_5_2.ninja_vanish = true

		return "running"
	end

	local var_5_14 = arg_5_2.navigation_extension._nav_bot
	local var_5_15 = GwNavBot.is_path_recomputation_needed(var_5_14)
	local var_5_16 = GwNavBot.is_following_path(var_5_14)
	local var_5_17 = GwNavBot.is_computing_new_path(var_5_14)

	if arg_5_2.waiting_for_path then
		if var_5_16 then
			arg_5_2.waiting_for_path = nil

			if arg_5_2.move_state == "idle" then
				arg_5_2.move_state = "moving"

				Managers.state.network:anim_event(arg_5_1, "move_fwd")
			end
		elseif arg_5_2.move_state ~= "idle" then
			arg_5_2.move_state = "idle"

			Managers.state.network:anim_event(arg_5_1, "idle")
		end
	end

	return "running"
end

local var_0_5 = {}
local var_0_6 = {
	0.4,
	0.5,
	-0.4,
	0.5,
	0,
	1.5
}

BTNinjaApproachAction.check_free_los = function (arg_6_0, arg_6_1, arg_6_2, arg_6_3)
	local var_6_0 = Unit.world_position(arg_6_2.target_unit, 0) + Vector3(0, 0, 0.2)
	local var_6_1 = POSITION_LOOKUP[arg_6_2.target_unit]

	if var_6_0.z < var_6_1.z then
		Vector3.set_z(var_6_0, var_6_1.z + 0.1)
	end

	local var_6_2 = var_0_0[arg_6_1] + Vector3(0, 0, 0.5)
	local var_6_3 = var_6_2.z - var_6_0.z
	local var_6_4

	if math.abs(var_6_3) < 2 then
		local var_6_5 = World.get_data(arg_6_2.world, "physics_world")

		var_6_4 = WeaponHelper.multi_ray_test(var_6_5, var_6_2, var_6_0, var_0_6)
	else
		var_6_4 = BTPrepareForCrazyJumpAction.test_trajectory(arg_6_2, var_6_2, var_6_0, var_0_5)
	end

	return var_6_4
end

BTNinjaApproachAction.try_dodge_pos = function (arg_7_0, arg_7_1, arg_7_2, arg_7_3, arg_7_4)
	local var_7_0, var_7_1 = GwNavQueries.triangle_from_position(arg_7_2.nav_world, arg_7_4, 3, 3)

	if var_7_0 then
		Vector3.set_z(arg_7_4, var_7_1)

		if var_0_1.debug_ai_movement then
			QuickDrawerStay:sphere(arg_7_3, 0.25)
			QuickDrawerStay:sphere(arg_7_4, 0.25, Color(0, 0, 100))
			QuickDrawerStay:line(arg_7_3, arg_7_4)
		end

		if GwNavQueries.raycast(arg_7_2.nav_world, arg_7_3, arg_7_4) then
			if var_0_1.debug_ai_movement then
				QuickDrawerStay:line(arg_7_4, arg_7_4 + Vector3(0, 0, 0.5), Color(0, 255, 120))
			end

			arg_7_2.navigation_extension:move_to(arg_7_4)

			return true
		end
	end
end

local var_0_7 = 2
local var_0_8 = var_0_7 - 0.3

BTNinjaApproachAction.dodge = function (arg_8_0, arg_8_1, arg_8_2, arg_8_3, arg_8_4)
	local var_8_0 = var_0_0[arg_8_1]
	local var_8_1 = arg_8_2.locomotion_extension:current_velocity()
	local var_8_2 = Vector3.normalize(var_8_1)
	local var_8_3 = Vector3.normalize(arg_8_3)
	local var_8_4 = Vector3.cross(-arg_8_4, Vector3.up())

	if Vector3.cross(var_8_3, arg_8_4).z > 0 then
		var_8_4 = -var_8_4
	end

	local var_8_5 = var_8_4 * 2 + var_8_2
	local var_8_6 = var_8_0 + var_8_5 * var_0_7

	if arg_8_0:try_dodge_pos(arg_8_1, arg_8_2, var_8_0, var_8_6) then
		local var_8_7 = var_8_0 + var_8_5 * var_0_8

		arg_8_2.dodge_pos = Vector3Box(var_8_7)

		return
	end

	local var_8_8 = var_8_0 - var_8_5 * var_0_7

	if arg_8_0:try_dodge_pos(arg_8_1, arg_8_2, var_8_0, var_8_8) then
		local var_8_9 = var_8_0 - var_8_5 * var_0_8

		arg_8_2.dodge_pos = Vector3Box(var_8_9)
	end
end

BTNinjaApproachAction.in_crosshairs = function (arg_9_0, arg_9_1, arg_9_2, arg_9_3, arg_9_4)
	local var_9_0 = arg_9_2.side.ENEMY_PLAYER_AND_BOT_UNITS

	for iter_9_0 = 1, #var_9_0 do
		local var_9_1 = var_9_0[iter_9_0]

		status_extension = ScriptUnit.extension(var_9_1, "status_system")

		if arg_9_4.aiming_at_me then
			if status_extension.aim_unit ~= arg_9_4.aiming_at_me then
				arg_9_4.aim_at_me_timer = arg_9_3 + 0.5
			elseif arg_9_3 > arg_9_4.aim_at_me_timer then
				return true
			end
		end

		if status_extension.aim_unit then
			arg_9_4.aiming_at_me = status_extension.aim_unit
		end
	end
end

BTNinjaApproachAction.get_fallback_goal = function (arg_10_0, arg_10_1, arg_10_2)
	local var_10_0 = var_0_0[arg_10_2.target_unit]

	if not var_10_0 then
		return
	end

	table.clear(var_0_3)

	local var_10_1 = LocomotionUtils.new_random_goal(arg_10_2.nav_world, arg_10_2, var_10_0, 1, 5, 10, var_0_3)

	if var_10_1 then
		arg_10_2.debug_state = "2nd fallback"

		aiprint("skulk around 2nd fallback -> success")

		arg_10_2.skulk_pos = Vector3Box(var_10_1)

		arg_10_2.navigation_extension:move_to(var_10_1)

		return true
	end
end

BTNinjaApproachAction.set_goal_at_target = function (arg_11_0, arg_11_1, arg_11_2)
	local var_11_0 = POSITION_LOOKUP[arg_11_2.target_unit] + Vector3(0, 0, 0)
	local var_11_1 = ConflictUtils.find_center_tri(arg_11_2.nav_world, var_11_0)

	if var_11_1 then
		arg_11_2.skulk_pos:store(var_11_1)

		arg_11_2.waiting_for_path = true

		arg_11_2.navigation_extension:move_to(var_11_1)
	end
end

BTNinjaApproachAction.get_straight_at_goal = function (arg_12_0, arg_12_1, arg_12_2)
	local var_12_0 = arg_12_2.target_unit
	local var_12_1 = POSITION_LOOKUP[arg_12_1]
	local var_12_2 = POSITION_LOOKUP[var_12_0]
	local var_12_3

	if arg_12_2.target_outside_navmesh then
		local var_12_4 = ScriptUnit.extension(var_12_0, "whereabouts_system").closest_positions[1]

		if var_12_4 then
			var_12_3 = var_12_4:unbox()
		end
	else
		var_12_3 = var_12_2
	end

	if var_12_3 then
		arg_12_2.skulk_pos = Vector3Box(var_12_3)

		return true
	end

	return true
end

BTNinjaApproachAction.check_high_point_on_line = function (arg_13_0, arg_13_1, arg_13_2, arg_13_3, arg_13_4, arg_13_5, arg_13_6, arg_13_7, arg_13_8)
	arg_13_4 = arg_13_4 or math.floor(Vector3.distance(p1, rat_pos))

	for iter_13_0 = 2, arg_13_4 + 1 do
		local var_13_0 = arg_13_2 + arg_13_3 * iter_13_0
		local var_13_1, var_13_2 = GwNavQueries.triangle_from_position(arg_13_1, var_13_0, arg_13_7, arg_13_8)

		QuickDrawer:sphere(var_13_0, 0.2, Color(255, 255, 0))

		if var_13_1 and arg_13_6 < var_13_2 - arg_13_5 then
			Vector3.set_z(var_13_0, var_13_2)
			QuickDrawer:sphere(var_13_0, 0.3, Color(0, 255, 0))

			return var_13_0, iter_13_0
		else
			QuickDrawer:sphere(var_13_0, 0.3, Color(255, 0, 0))
		end
	end
end

BTNinjaApproachAction.get_new_goal = function (arg_14_0, arg_14_1, arg_14_2, arg_14_3)
	local var_14_0 = arg_14_2.target_unit

	if Unit.alive(var_14_0) then
		local var_14_1
		local var_14_2 = 10
		local var_14_3 = 15
		local var_14_4 = arg_14_2.skulk_around_dir or 1 - math.random(0, 1) * 2

		arg_14_2.skulk_around_dir = var_14_4

		local var_14_5 = math.random(10, 35) * var_14_4
		local var_14_6 = 5
		local var_14_7 = LocomotionUtils.outside_goal(arg_14_2.nav_world, POSITION_LOOKUP[arg_14_1], POSITION_LOOKUP[var_14_0], var_14_2, var_14_3, var_14_5, var_14_6)

		if var_14_7 then
			arg_14_2.skulk_pos = Vector3Box(var_14_7)

			arg_14_2.navigation_extension:move_to(var_14_7)

			return true
		end
	end
end

BTNinjaApproachAction.anim_cb_dodge_finished = function (arg_15_0, arg_15_1, arg_15_2)
	blackboard.anim_cb_dodge_finished = nil
end

BTNinjaApproachAction.debug = function (arg_16_0, arg_16_1, arg_16_2)
	if arg_16_2.skulk_pos then
		local var_16_0 = arg_16_2.skulk_pos:unbox()

		QuickDrawer:sphere(var_16_0 + Vector3(0, 0, 1), 0.5, Color(255, 144, 43, 207))
		QuickDrawer:sphere(var_16_0 + Vector3(0, 0, 1.5), 0.25, Color(255, 144, 43, 207))
		QuickDrawer:sphere(var_16_0 + Vector3(0, 0, 1.725), 0.125, Color(255, 144, 43, 207))

		if arg_16_2.in_los then
			QuickDrawer:sphere(var_16_0 + Vector3(0, 0, 2), 0.25, Color(255, 144, 43, 43))
		end
	else
		local var_16_1 = var_0_0[arg_16_1]

		QuickDrawer:sphere(var_16_1 + Vector3(0, 0, 1), 0.5, Color(255, 144, 43, 207))
		QuickDrawer:sphere(var_16_1 + Vector3(0, 0, 1.55), 0.25, Color(255, 144, 43, 207))
		QuickDrawer:sphere(var_16_1 + Vector3(0, 0, 1.725), 0.125, Color(255, 144, 43, 207))
	end

	for iter_16_0 = 1, #var_0_3 do
		local var_16_2 = var_0_3[iter_16_0]:unbox()

		QuickDrawer:sphere(var_16_2 + Vector3(0, 0, 2), 0.5, Color(255, 43, 43, 207))
	end
end
