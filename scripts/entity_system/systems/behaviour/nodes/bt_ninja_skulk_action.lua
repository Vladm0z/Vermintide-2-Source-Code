-- chunkname: @scripts/entity_system/systems/behaviour/nodes/bt_ninja_skulk_action.lua

require("scripts/entity_system/systems/behaviour/nodes/bt_node")

BTNinjaSkulkAction = class(BTNinjaSkulkAction, BTNode)
BTNinjaSkulkAction.name = "BTNinjaSkulkAction"

local POSITION_LOOKUP = POSITION_LOOKUP
local script_data = script_data

BTNinjaSkulkAction.init = function (arg_1_0, ...)
	-- function 1
	BTNinjaSkulkAction.super.init(arg_1_0, ...)
end

local function fn(arg_2_0, arg_2_1, arg_2_2)
	-- function 2
	if not script_data.debug_ai_movement then
		Debug.world_sticky_text(POSITION_LOOKUP[arg_2_0], arg_2_1, arg_2_2)
	end
end

BTNinjaSkulkAction.enter = function (self, arg_3_1, arg_3_2, arg_3_3)
	-- function 3
	arg_3_2.action = self._tree_node.action_data

	LocomotionUtils.set_animation_driven_movement(arg_3_1, false)
	Managers.state.network:anim_event(arg_3_1, "move_fwd")
	arg_3_2.navigation_extension:set_max_speed(arg_3_2.breed.run_speed)

	arg_3_2.target_skulk_time = arg_3_3 + 0.5

	local skulk_jump_tries = arg_3_2.skulk_jump_tries

	skulk_jump_tries = skulk_jump_tries or 0
	arg_3_2.skulk_jump_tries = skulk_jump_tries

	local locomotion_extension = arg_3_2.locomotion_extension

	locomotion_extension:set_rotation_speed(5)
	locomotion_extension:set_movement_type("snap_to_navmesh")

	if not arg_3_2.skulk_data then
		arg_3_2.skulk_data = {}
	end

	local skulk_data = arg_3_2.skulk_data

	if not arg_3_2.skulk_pos then
		local unbox = arg_3_2.skulk_pos:unbox()

		arg_3_2.navigation_extension:move_to(unbox)
	end
end

BTNinjaSkulkAction.leave = function (arg_4_0, arg_4_1, arg_4_2, arg_4_3, arg_4_4, arg_4_5)
	-- function 4
	if arg_4_4 == "aborted" then
		-- Nothing
	end

	arg_4_2.in_los = nil
	arg_4_2.action = nil
	arg_4_2.ninja_approach = false

	local get_default_breed_move_speed = AiUtils.get_default_breed_move_speed(arg_4_1, arg_4_2)

	arg_4_2.navigation_extension:set_max_speed(get_default_breed_move_speed)
end

local tbl = {}
local num = 8

BTNinjaSkulkAction.run = function (self, arg_5_1, arg_5_2, arg_5_3, arg_5_4)
	-- function 5
	local locomotion_extension = arg_5_2.locomotion_extension
	local breed = arg_5_2.breed

	if not arg_5_2.skulk_pos then
		if not self:get_new_goal(arg_5_1, arg_5_2) then
			aiprint("Tried to find new GR skulk goal, but could not")
		end

		if not self:get_fallback_goal(arg_5_1, arg_5_2) then
			fn(arg_5_1, "SkulkAction 2nd fallback goal 1", "green")
			aiprint("Failed finding 2nd fallback goal")

			return "done"
		end
	end

	if not arg_5_2.dodging then
		if arg_5_3 > arg_5_2.dodging then
			arg_5_2.dodging = nil
		end
	else
		local in_crosshairs_dodge, var_5_3 = LocomotionUtils.in_crosshairs_dodge(arg_5_1, arg_5_2, arg_5_3, 1, nil)

		if not in_crosshairs_dodge then
			self:dodge(arg_5_1, arg_5_2, in_crosshairs_dodge, var_5_3)
			Managers.state.network:anim_event(arg_5_1, "dodge_run_fwd")

			arg_5_2.dodging = arg_5_3 + 1.5
		end
	end

	if not arg_5_2.dodge_pos then
		local unbox = arg_5_2.dodge_pos:unbox()
		local var_5_5 = POSITION_LOOKUP[arg_5_1]
		local num_2 = unbox - var_5_5
		local local_rotation = Unit.local_rotation(arg_5_1, 0)
		local forward = Quaternion.forward(local_rotation)

		if Vector3.dot(Vector3.normalize(num_2), forward) < 0 then
			arg_5_2.dodge_pos = nil

			arg_5_2.navigation_extension:move_to(arg_5_2.skulk_pos:unbox())

			if not script_data.debug_ai_movement then
				QuickDrawerStay:line(var_5_5, var_5_5 + Vector3(0, 0, 3), Color(255, 0, 0))
			end
		else
			return "running"
		end
	end

	if not (not arg_5_2.urgency_to_engage and not (arg_5_2.urgency_to_engage > 0)) then
		local var_5_9 = POSITION_LOOKUP[arg_5_2.target_unit]
		local var_5_10 = POSITION_LOOKUP[arg_5_1]
		local distance = Vector3.distance(var_5_10, var_5_9)
		local flag = distance < num

		if arg_5_3 > arg_5_2.target_skulk_time or not flag then
			if distance < breed.jump_range then
				arg_5_2.skulk_jump_tries = arg_5_2.skulk_jump_tries + 1

				local random = math.random()
				local flag_2 = true

				if not flag_2 then
					arg_5_2.in_los = BTNinjaSkulkAction:check_free_los(arg_5_1, arg_5_2)

					if not arg_5_2.in_los then
						arg_5_2.skulk_jump_tries = 0

						fn(arg_5_1, "SkulkAction in LOS done!", "green")

						return "done"
					end

					fn(arg_5_1, "SkulkAction not in LOS", "yellow")
				elseif not flag then
					arg_5_2.in_los = BTNinjaSkulkAction:check_free_los(arg_5_1, arg_5_2)

					if not arg_5_2.in_los then
						arg_5_2.skulk_jump_tries = 0

						fn(arg_5_1, "SkulkAction in LOS(close) done!", "green")

						return "done"
					end

					self:get_new_goal(arg_5_1, arg_5_2)
					fn(arg_5_1, "SkulkAction not in LOS", "yellow")
				end
			else
				aiprint("Too far away to crazy jump (B)")
			end

			arg_5_2.target_skulk_time = arg_5_3 + 0.5

			aiprint("skulk try failed:", arg_5_2.skulk_jump_tries)
		end
	else
		aiprint("GR no urgency to engage")
	end

	if not script_data.debug_ai_movement then
		self:debug(arg_5_1, arg_5_2)
	end

	locomotion_extension:set_wanted_rotation(nil)

	local unbox_2 = arg_5_2.skulk_pos:unbox()

	if Vector3.distance(unbox_2, POSITION_LOOKUP[arg_5_1]) < 3 then
		if not self:get_new_goal(arg_5_1, arg_5_2) then
			return "running"
		end

		arg_5_2.in_los = LocomotionUtils.target_in_los(arg_5_1, arg_5_2)

		if not arg_5_2.in_los then
			fn(arg_5_1, "SkulkAction in LOS first fallback", "green")

			return "done"
		end

		if not self:get_fallback_goal(arg_5_1, arg_5_2) then
			aiprint("Failed finding 2nd fallback goal")
			fn(arg_5_1, "SkulkAction in LOS 2nd fallback goal 2", "green")

			return "done"
		end
	end

	local _nav_bot = arg_5_2.navigation_extension._nav_bot
	local is_path_recomputation_needed = GwNavBot.is_path_recomputation_needed(_nav_bot)
	local is_following_path = GwNavBot.is_following_path(_nav_bot)

	if not (is_path_recomputation_needed or is_following_path) then
		Debug.text("NEED NEW GOAL")
		self:set_goal_at_target(arg_5_1, arg_5_2)
	end

	if not arg_5_2.waiting_for_path then
		if not GwNavBot.is_following_path(_nav_bot) then
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

local tbl_2 = {}
local tbl_3 = {
	0.4,
	0.5,
	-4,
	0.5,
	0,
	1.5
}

BTNinjaSkulkAction.check_free_los = function (arg_6_0, arg_6_1, arg_6_2, arg_6_3)
	-- function 6
	local num = Unit.world_position(arg_6_2.target_unit, 0) + Vector3(0, 0, 0.2)
	local var_6_1 = POSITION_LOOKUP[arg_6_2.target_unit]

	if num.z < var_6_1.z then
		Vector3.set_z(num, var_6_1.z + 0.1)
	end

	local num_2 = POSITION_LOOKUP[arg_6_1] + Vector3(0, 0, 0.2)
	local num_3 = num_2.z - num.z
	local var_6_4

	if math.abs(num_3) < 2 then
		local get_data = World.get_data(arg_6_2.world, "physics_world")

		var_6_4 = WeaponHelper.multi_ray_test(get_data, num_2, num, tbl_3)
	else
		var_6_4 = BTPrepareForCrazyJumpAction.test_trajectory(arg_6_2, num_2, num, tbl_2)
	end

	return var_6_4
end

BTNinjaSkulkAction.try_dodge_pos = function (arg_7_0, arg_7_1, arg_7_2, arg_7_3, arg_7_4)
	-- function 7
	local triangle_from_position, var_7_1 = GwNavQueries.triangle_from_position(arg_7_2.nav_world, arg_7_4, 3, 3)

	if not triangle_from_position then
		Vector3.set_z(arg_7_4, var_7_1)

		if not script_data.debug_ai_movement then
			QuickDrawerStay:sphere(arg_7_3, 0.25)
			QuickDrawerStay:sphere(arg_7_4, 0.25, Color(0, 0, 100))
			QuickDrawerStay:line(arg_7_3, arg_7_4)
		end

		if not GwNavQueries.raycast(arg_7_2.nav_world, arg_7_3, arg_7_4) then
			if not script_data.debug_ai_movement then
				QuickDrawerStay:line(arg_7_4, arg_7_4 + Vector3(0, 0, 0.5), Color(0, 255, 120))
			end

			arg_7_2.navigation_extension:move_to(arg_7_4)

			return true
		end
	end
end

local num_2 = 2
local num_3 = num_2 - 0.3

BTNinjaSkulkAction.dodge = function (self, arg_8_1, arg_8_2, arg_8_3, arg_8_4)
	-- function 8
	local var_8_0 = POSITION_LOOKUP[arg_8_1]
	local current_velocity = arg_8_2.locomotion_extension:current_velocity()
	local normalize = Vector3.normalize(current_velocity)
	local normalize_2 = Vector3.normalize(arg_8_3)
	local cross = Vector3.cross(-arg_8_4, Vector3.up())

	if Vector3.cross(normalize_2, arg_8_4).z > 0 then
		cross = -cross
	end

	local num = cross * 2 + normalize
	local num_4 = var_8_0 + num * num_2

	if not self:try_dodge_pos(arg_8_1, arg_8_2, var_8_0, num_4) then
		local num_5 = var_8_0 + num * num_3

		arg_8_2.dodge_pos = Vector3Box(num_5)

		return
	end

	local num_6 = var_8_0 - num * num_2

	if not self:try_dodge_pos(arg_8_1, arg_8_2, var_8_0, num_6) then
		local num_7 = var_8_0 - num * num_3

		arg_8_2.dodge_pos = Vector3Box(num_7)
	end
end

BTNinjaSkulkAction.in_crosshairs = function (arg_9_0, arg_9_1, arg_9_2, arg_9_3, arg_9_4)
	-- function 9
	local ENEMY_PLAYER_AND_BOT_UNITS = arg_9_2.side.ENEMY_PLAYER_AND_BOT_UNITS

	for i = 1, #ENEMY_PLAYER_AND_BOT_UNITS do
		local var_9_1 = ENEMY_PLAYER_AND_BOT_UNITS[i]

		status_extension = ScriptUnit.extension(var_9_1, "status_system")

		if not arg_9_4.aiming_at_me then
			if status_extension.aim_unit ~= arg_9_4.aiming_at_me then
				arg_9_4.aim_at_me_timer = arg_9_3 + 0.5
			elseif arg_9_3 > arg_9_4.aim_at_me_timer then
				return true
			end
		end

		if not status_extension.aim_unit then
			arg_9_4.aiming_at_me = status_extension.aim_unit
		end
	end
end

BTNinjaSkulkAction.get_fallback_goal = function (arg_10_0, arg_10_1, arg_10_2)
	-- function 10
	table.clear(tbl)

	local var_10_0 = POSITION_LOOKUP[arg_10_2.target_unit]
	local new_random_goal = LocomotionUtils.new_random_goal(arg_10_2.nav_world, arg_10_2, var_10_0, 1, 5, 10, tbl)

	if not new_random_goal then
		arg_10_2.debug_state = "2nd fallback"

		aiprint("skulk around 2nd fallback -> success")

		arg_10_2.skulk_pos = Vector3Box(new_random_goal)

		arg_10_2.navigation_extension:move_to(new_random_goal)

		return true
	end
end

BTNinjaSkulkAction.set_goal_at_target = function (arg_11_0, arg_11_1, arg_11_2)
	-- function 11
	local num = POSITION_LOOKUP[arg_11_2.target_unit] + Vector3(0, 0, 0)
	local find_center_tri = ConflictUtils.find_center_tri(arg_11_2.nav_world, num)

	if not find_center_tri then
		arg_11_2.skulk_pos:store(find_center_tri)

		arg_11_2.waiting_for_path = true

		arg_11_2.navigation_extension:move_to(find_center_tri)
	end
end

BTNinjaSkulkAction.get_new_goal = function (arg_12_0, arg_12_1, arg_12_2)
	-- function 12
	local target_unit = arg_12_2.target_unit

	if not Unit.alive(target_unit) then
		local var_12_1
		local num = 10
		local num_2 = 15
		local skulk_around_dir = arg_12_2.skulk_around_dir

		skulk_around_dir = skulk_around_dir or 1 - math.random(0, 1) * 2
		arg_12_2.skulk_around_dir = skulk_around_dir

		local num_3 = math.random(10, 35) * skulk_around_dir
		local num_4 = 5
		local outside_goal = LocomotionUtils.outside_goal(arg_12_2.nav_world, POSITION_LOOKUP[arg_12_1], POSITION_LOOKUP[target_unit], num, num_2, num_3, num_4)

		if not outside_goal then
			arg_12_2.skulk_pos = Vector3Box(outside_goal)

			arg_12_2.navigation_extension:move_to(outside_goal)

			return true
		end
	end
end

BTNinjaSkulkAction.anim_cb_dodge_finished = function (arg_13_0, arg_13_1, arg_13_2)
	-- function 13
	blackboard.anim_cb_dodge_finished = nil
end

BTNinjaSkulkAction.debug = function (arg_14_0, arg_14_1, arg_14_2)
	-- function 14
	if not arg_14_2.skulk_pos then
		local unbox = arg_14_2.skulk_pos:unbox()

		QuickDrawer:sphere(unbox + Vector3(0, 0, 1), 0.5, Color(255, 144, 43, 207))
		QuickDrawer:sphere(unbox + Vector3(0, 0, 1.5), 0.25, Color(255, 144, 43, 207))
		QuickDrawer:sphere(unbox + Vector3(0, 0, 1.725), 0.125, Color(255, 144, 43, 207))

		if not arg_14_2.in_los then
			QuickDrawer:sphere(unbox + Vector3(0, 0, 2), 0.25, Color(255, 144, 43, 43))
		end
	else
		local var_14_1 = POSITION_LOOKUP[arg_14_1]

		QuickDrawer:sphere(var_14_1 + Vector3(0, 0, 1), 0.5, Color(255, 144, 43, 207))
		QuickDrawer:sphere(var_14_1 + Vector3(0, 0, 1.55), 0.25, Color(255, 144, 43, 207))
		QuickDrawer:sphere(var_14_1 + Vector3(0, 0, 1.725), 0.125, Color(255, 144, 43, 207))
	end

	for i = 1, #tbl do
		local unbox_2 = tbl[i]:unbox()

		QuickDrawer:sphere(unbox_2 + Vector3(0, 0, 2), 0.5, Color(255, 43, 43, 207))
	end
end
