-- chunkname: @scripts/entity_system/systems/behaviour/nodes/bt_crazy_jump_action.lua

require("scripts/entity_system/systems/behaviour/nodes/bt_node")

BTCrazyJumpAction = class(BTCrazyJumpAction, BTNode)

local var_0_0 = POSITION_LOOKUP

BTCrazyJumpAction.init = function (arg_1_0, ...)
	BTCrazyJumpAction.super.init(arg_1_0, ...)
end

BTCrazyJumpAction.name = "BTCrazyJumpAction"

local function var_0_1(arg_2_0, arg_2_1, arg_2_2)
	if script_data.debug_ai_movement then
		Debug.world_sticky_text(var_0_0[arg_2_0], arg_2_1, arg_2_2)
	end
end

BTCrazyJumpAction.enter = function (arg_3_0, arg_3_1, arg_3_2, arg_3_3)
	aiprint("ENTER CRAZY JUMP ACTION")

	local var_3_0 = arg_3_0._tree_node.action_data

	arg_3_2.action = var_3_0

	local var_3_1 = arg_3_2.jump_data
	local var_3_2 = Managers.state.network
	local var_3_3 = ScriptUnit.extension(arg_3_1, "ai_system")
	local var_3_4 = var_3_0.difficulty_jump_delay_time[Managers.state.difficulty:get_difficulty_rank()] or var_3_0.difficulty_jump_delay_time[2]

	if var_3_1.delay_jump_start then
		var_3_1.state = "align_for_push_off"
		var_3_1.start_jump = arg_3_3 + (var_3_4 or 0.3)
		var_3_1.delay_jump_start = nil
	elseif var_3_1.instant_jump then
		var_3_2:anim_event(arg_3_1, "to_crouch")
		var_3_2:anim_event(arg_3_1, "jump_start")

		var_3_1.state = "push_off"
		var_3_1.start_jump = arg_3_3
		var_3_1.start_check_obstacles = arg_3_3 + 0.8

		arg_3_0:create_bot_threat(arg_3_1, arg_3_2, arg_3_3)
	else
		var_3_2:anim_event(arg_3_1, "jump_start")

		var_3_1.state = "push_off"
		var_3_1.start_jump = arg_3_3 + (var_3_4 or 0.3)
		var_3_1.start_check_obstacles = arg_3_3 + 0.8

		arg_3_0:create_bot_threat(arg_3_1, arg_3_2, arg_3_3)
	end

	var_3_1.target_unit = arg_3_2.target_unit
	var_3_1.overlap_context = var_3_3:get_overlap_context()
	var_3_1.anim_jump_rot_var = Unit.animation_find_variable(arg_3_1, "jump_rotation")

	LocomotionUtils.set_animation_driven_movement(arg_3_1, false)

	local var_3_5 = arg_3_2.locomotion_extension

	var_3_5:set_gravity(arg_3_2.breed.jump_gravity)
	var_3_5:set_check_falling(false)
end

BTCrazyJumpAction.leave = function (arg_4_0, arg_4_1, arg_4_2, arg_4_3, arg_4_4, arg_4_5)
	arg_4_2.skulk_pos = nil
	arg_4_2.comitted_to_target = false

	local var_4_0 = arg_4_2.locomotion_extension

	if not var_4_0._engine_extension_id then
		return
	end

	var_4_0:set_mover_displacement()

	if arg_4_4 == "aborted" then
		if arg_4_2.jump_data.updating_jump_rot then
			arg_4_0:update_anim_variable_done(arg_4_1, arg_4_2.jump_data)
		end

		arg_4_2.jump_data = nil

		if arg_4_2.smash_door then
			Managers.state.network:anim_event(arg_4_1, "to_upright")
		end

		arg_4_2.high_ground_opportunity = nil

		var_4_0:set_movement_type("snap_to_navmesh")
	end

	if arg_4_4 == "failed" then
		arg_4_2.jump_data = nil
		arg_4_2.high_ground_opportunity = nil
	end

	arg_4_2.navigation_extension:set_enabled(true)
	var_4_0:set_check_falling(true)
end

local var_0_2 = 2.7

BTCrazyJumpAction.run = function (arg_5_0, arg_5_1, arg_5_2, arg_5_3, arg_5_4)
	local var_5_0 = arg_5_2.locomotion_extension
	local var_5_1 = arg_5_2.jump_data
	local var_5_2 = var_5_1.target_unit

	if script_data.debug_ai_movement then
		arg_5_0:debug(arg_5_1, arg_5_2, var_5_1, arg_5_3)
	end

	if not AiUtils.is_of_interest_to_gutter_runner(arg_5_1, var_5_2, arg_5_2) then
		arg_5_2.skulk_pos = nil
		var_5_1.snap_failed = true

		if var_5_1.state == "align_for_push_off" then
			return "failed"
		elseif var_5_1.state == "in_air" or var_5_1.state == "snapping" then
			var_5_1.state = "in_air_no_target"
		end
	end

	if var_5_1.state == "align_for_push_off" then
		local var_5_3 = LocomotionUtils.rotation_towards_unit_flat(arg_5_1, arg_5_2.target_unit)

		var_5_0:set_wanted_rotation(var_5_3)
	else
		var_5_0:set_wanted_rotation(nil)
	end

	if arg_5_3 > var_5_1.start_jump then
		if var_5_1.state == "align_for_push_off" then
			Managers.state.network:anim_event(arg_5_1, "jump_start")

			var_5_1.state = "push_off"
			var_5_1.start_jump = arg_5_3 + 0.3
			var_5_1.start_check_obstacles = arg_5_3 + 0.8

			arg_5_0:create_bot_threat(arg_5_1, arg_5_2, arg_5_3)
		elseif var_5_1.state == "push_off" then
			if var_5_1.jump_velocity_boxed then
				var_5_1.state = "in_air"

				local var_5_4 = var_5_1.overlap_context

				var_5_4.has_gotten_callback = false
				var_5_4.num_hits = 0
				arg_5_2.last_jump = arg_5_3

				BTCrazyJumpAction:setup_jump(arg_5_1, arg_5_2, var_5_1)
				var_5_0:set_mover_displacement(Vector3(0, 0, 0.5), 0.5)
			else
				return "failed"
			end
		elseif var_5_1.state == "in_air" then
			arg_5_2.comitted_to_target = true

			local var_5_5 = var_5_1.overlap_context
			local var_5_6 = Unit.world_position(arg_5_1, var_5_5.spine_node)
			local var_5_7 = var_0_0[var_5_2] - var_5_6
			local var_5_8 = Vector3.flat(var_5_7)
			local var_5_9 = Vector3.length(var_5_8)

			if script_data.debug_ai_movement then
				QuickDrawerStay:sphere(var_5_6, 0.04)
			end

			if not var_5_1.snap_failed and var_5_9 < var_0_2 then
				if ScriptUnit.extension(var_5_2, "status_system").pounced_down then
					var_5_1.state = "pounce_down_fail"

					arg_5_0:update_anim_variable_done(arg_5_1, var_5_1)

					var_5_1.fail_time = arg_5_3 + 1

					Managers.state.network:anim_event(arg_5_1, "jump_fail")
					LocomotionUtils.set_animation_driven_movement(arg_5_1, true, false, false)
					aiprint("fail already snapped!")

					return "running"
				end

				var_5_1.state = "snapping"

				arg_5_0:update_anim_variable_done(arg_5_1, var_5_1)

				return "running"
			end

			if arg_5_0:check_colliding_players(arg_5_1, arg_5_2, var_5_6) then
				return "done"
			end

			local var_5_10 = Unit.mover(arg_5_1)

			if arg_5_3 > var_5_1.start_check_obstacles then
				if Mover.collides_sides(var_5_10) then
					var_5_1.state = "hit_obstacle"

					arg_5_0:update_anim_variable_done(arg_5_1, var_5_1)
				elseif Mover.collides_down(var_5_10) and arg_5_3 - arg_5_2.last_jump > 0.1 then
					arg_5_2.skulk_pos = nil
					var_5_1.state = "landing"

					return "running"
				end
			end
		elseif var_5_1.state == "in_air_no_target" then
			local var_5_11 = var_5_1.overlap_context
			local var_5_12 = Unit.world_position(arg_5_1, var_5_11.spine_node)

			if arg_5_0:check_colliding_players(arg_5_1, arg_5_2, var_5_12) then
				return "done"
			end

			local var_5_13 = Unit.mover(arg_5_1)

			if Mover.collides_sides(var_5_13) then
				var_5_1.state = "hit_obstacle"

				arg_5_0:update_anim_variable_done(arg_5_1, var_5_1)
			elseif Mover.collides_down(var_5_13) and arg_5_3 - arg_5_2.last_jump > 0.1 then
				arg_5_2.skulk_pos = nil
				var_5_1.state = "landing"

				return "running"
			end
		elseif var_5_1.state == "snapping" then
			local var_5_14 = 2
			local var_5_15 = var_5_1.overlap_context
			local var_5_16 = Unit.world_position(arg_5_1, var_5_15.spine_node)
			local var_5_17 = Unit.world_position(var_5_2, var_5_15.enemy_spine_node)
			local var_5_18 = var_5_17 - var_5_16
			local var_5_19 = Vector3.length(var_5_18)

			if script_data.debug_ai_movement then
				QuickDrawerStay:sphere(var_5_16, 0.04, Color(200, 90, 0))
			end

			local var_5_20 = arg_5_2.locomotion_extension:current_velocity()
			local var_5_21 = Vector3.normalize(var_5_20)

			if Vector3.dot(var_5_21, Vector3.normalize(var_5_18)) < 0 then
				aiprint("GR missed crazy jump, player side-stepped")

				var_5_1.state = "in_air"
				var_5_1.snap_failed = true

				var_0_1(arg_5_1, "JumpAction snapping->in_air player side-stepped", "yellow")

				return "running"
			end

			if script_data.debug_ai_movement then
				QuickDrawer:sphere(var_5_16, var_5_14)
			end

			if arg_5_0:check_colliding_players(arg_5_1, arg_5_2, var_5_16) then
				var_0_1(arg_5_1, "JumpAction snapping accidental!", "green")

				return "done"
			end

			if var_5_19 < var_5_14 then
				local var_5_22 = 1
				local var_5_23 = Geometry.closest_point_on_line(var_5_16, var_5_16, var_5_16 + var_5_21 * 3)
				local var_5_24 = Vector3.flat(var_5_23 - var_5_17)

				if var_5_22 > Vector3.length(var_5_24) then
					var_0_1(arg_5_1, "JumpAction snapping success SNAPPED!", "green")

					return "done"
				end
			end

			local var_5_25 = Vector3.flat(var_5_1.jump_target_pos:unbox() - var_5_16)

			if Vector3.dot(var_5_21, Vector3.normalize(var_5_25)) < 0 then
				if script_data.debug_ai_movement then
					QuickDrawerStay:sphere(var_5_16, 0.045, Color(200, 190, 0))
				end

				local var_5_26 = Unit.mover(arg_5_1)

				if Mover.collides_down(var_5_26) and arg_5_3 - arg_5_2.last_jump > 0.1 then
					var_0_1(arg_5_1, "JumpAction snapping failed collides_down", "red")

					arg_5_2.skulk_pos = nil
					var_5_1.state = "landing"

					return "running"
				end
			end

			return "running"
		elseif var_5_1.state == "landing" then
			arg_5_0:update_anim_variable_done(arg_5_1, var_5_1)

			if var_5_1.land_time then
				if arg_5_3 > var_5_1.land_time then
					var_5_1.land_time = nil

					return "failed"
				end
			else
				LocomotionUtils.set_animation_driven_movement(arg_5_1, false)
				var_5_0:set_wanted_velocity(Vector3.zero())
				var_5_0:set_movement_type("snap_to_navmesh")
				Managers.state.network:anim_event(arg_5_1, "jump_land")

				var_5_1.land_time = arg_5_3 + 0.5
			end

			return "running"
		elseif var_5_1.state == "hit_obstacle" then
			var_5_0:set_wanted_velocity(Vector3.zero())

			arg_5_2.is_falling = true

			do return "failed" end

			local var_5_27 = Unit.mover(arg_5_1)
			local var_5_28 = Mover.standing_frames(var_5_27)
			local var_5_29 = Managers.state.network

			var_5_29:anim_event(arg_5_1, "to_upright")
			var_5_29:anim_event(arg_5_1, "jump_down")

			local var_5_30 = var_5_0:current_velocity()

			var_5_0:set_wanted_velocity(var_5_30)

			if var_5_28 > 0 then
				Debug.sticky_text("Gutter runner - in air hit obstacle, but have landed again")

				return "failed"
			else
				var_5_29:anim_event(arg_5_1, "jump_down_land")

				return "running"
			end
		elseif var_5_1.state == "pounce_down_fail" then
			if arg_5_3 < var_5_1.fail_time then
				var_0_1(arg_5_1, "Pounce down fail", "purple")

				return "running"
			end

			aiprint("pounce_down_fail done!!!!")

			arg_5_2.target_unit = nil
			arg_5_2.jump_data.target_unit = nil

			LocomotionUtils.set_animation_driven_movement(arg_5_1, false)
			var_0_1(arg_5_1, "JumpAction pounce_down_fail failed", "red")

			return "failed"
		end
	end

	return "running"
end

BTCrazyJumpAction.create_bot_threat = function (arg_6_0, arg_6_1, arg_6_2, arg_6_3)
	local var_6_0 = ScriptUnit.has_extension(arg_6_2.target_unit, "first_person_system")

	if var_6_0 then
		local var_6_1 = var_6_0:current_position()
		local var_6_2 = var_6_0:current_rotation()
		local var_6_3 = Vector3.normalize(var_6_1 - POSITION_LOOKUP[arg_6_1])
		local var_6_4 = Quaternion.forward(var_6_2)
		local var_6_5 = Vector3.dot(var_6_4, var_6_3)

		if not (var_6_5 >= 0.55 and var_6_5 <= 1) then
			local var_6_6 = POSITION_LOOKUP[arg_6_1]
			local var_6_7 = POSITION_LOOKUP[arg_6_2.target_unit] - var_6_6
			local var_6_8 = Vector3.length(var_6_7)
			local var_6_9, var_6_10, var_6_11 = AiUtils.calculate_oobb(var_6_8 + 3, var_6_6, Quaternion.look(var_6_7))
			local var_6_12 = 0.5

			Managers.state.entity:system("ai_bot_group_system"):aoe_threat_created(var_6_9, "oobb", var_6_11, var_6_10, var_6_12, "Crazy Jump")
		end
	end
end

local var_0_3 = true

BTCrazyJumpAction.check_colliding_players = function (arg_7_0, arg_7_1, arg_7_2, arg_7_3)
	if var_0_3 then
		local var_7_0 = 1
		local var_7_1, var_7_2 = PhysicsWorld.immediate_overlap(arg_7_0.physics_world, "shape", "sphere", "position", arg_7_3, "size", var_7_0, "types", "both", "collision_filter", "filter_player_and_husk_trigger")

		if var_7_2 > 0 then
			for iter_7_0 = 1, var_7_2 do
				local var_7_3 = var_7_1[iter_7_0]
				local var_7_4 = Actor.unit(var_7_3)

				if AiUtils.is_of_interest_to_gutter_runner(arg_7_1, var_7_4, arg_7_2) then
					arg_7_2.jump_data.target_unit = var_7_4
					arg_7_2.target_unit = var_7_4

					return var_7_4
				end
			end
		end
	else
		local var_7_5 = arg_7_2.side.ENEMY_PLAYER_AND_BOT_UNITS
		local var_7_6 = 4
		local var_7_7

		for iter_7_1 = 1, #var_7_5 do
			local var_7_8 = var_7_5[iter_7_1]
			local var_7_9 = var_0_0[var_7_8]
			local var_7_10 = Vector3.distance_squared(arg_7_3, var_7_9)

			if var_7_10 < var_7_6 then
				var_7_7 = var_7_8
				var_7_6 = var_7_10
			end
		end

		return var_7_7
	end
end

BTCrazyJumpAction.setup_jump = function (arg_8_0, arg_8_1, arg_8_2, arg_8_3)
	local var_8_0 = arg_8_3.jump_target_pos:unbox()
	local var_8_1 = arg_8_3.jump_velocity_boxed:unbox()

	arg_8_2.navigation_extension:set_enabled(false)
	LocomotionUtils.set_animation_driven_movement(arg_8_1, false)

	local var_8_2 = arg_8_2.breed.override_mover_move_distance
	local var_8_3 = arg_8_2.locomotion_extension

	var_8_3:set_affected_by_gravity(true)
	var_8_3:set_movement_type("constrained_by_mover", var_8_2, arg_8_3.instant_jump)
	var_8_3:set_wanted_velocity(var_8_1)

	arg_8_3.overlap_context.spine_node = Unit.node(arg_8_1, "j_neck")
	arg_8_3.overlap_context.enemy_spine_node = arg_8_3.enemy_spine_node

	local var_8_4 = arg_8_2.world

	arg_8_0.physics_world = World.get_data(var_8_4, "physics_world")

	Managers.state.entity:system("animation_system"):start_anim_variable_update_by_distance(arg_8_1, arg_8_3.anim_jump_rot_var, var_8_0, 2, true)

	arg_8_3.updating_jump_rot = true
end

BTCrazyJumpAction.update_anim_variable_done = function (arg_9_0, arg_9_1, arg_9_2)
	Managers.state.entity:system("animation_system"):set_update_anim_variable_done(arg_9_1)

	arg_9_2.updating_jump_rot = false
end

local var_0_4 = 1
local var_0_5 = 2
local var_0_6 = 3
local var_0_7 = 4
local var_0_8 = {}

BTCrazyJumpAction.ray_cast = function (arg_10_0, arg_10_1, arg_10_2, arg_10_3)
	local var_10_0 = arg_10_1 - arg_10_0
	local var_10_1 = Vector3.normalize(var_10_0)
	local var_10_2 = Vector3.length(var_10_0)
	local var_10_3 = World.get_data(arg_10_2.world, "physics_world")
	local var_10_4 = PhysicsWorld.immediate_raycast(var_10_3, arg_10_0, var_10_1, var_10_2, "all", "collision_filter", "filter_ray_projectile")

	if var_10_4 then
		local var_10_5 = var_0_8

		table.clear(var_10_5)

		local var_10_6 = #var_10_4

		for iter_10_0 = 1, var_10_6 do
			local var_10_7 = var_10_4[iter_10_0]
			local var_10_8 = var_10_7[var_0_4]
			local var_10_9 = var_10_7[var_0_5]
			local var_10_10 = var_10_7[var_0_6]
			local var_10_11 = var_10_7[var_0_7]
			local var_10_12 = Actor.unit(var_10_11)

			if not (var_10_12 == arg_10_3) and var_10_12 ~= arg_10_3 then
				return var_10_12
			end
		end
	end

	return nil
end

BTCrazyJumpAction.debug = function (arg_11_0, arg_11_1, arg_11_2, arg_11_3, arg_11_4)
	if arg_11_3.state == "in_air" or arg_11_3.state == "snapping" then
		local var_11_0 = arg_11_3.overlap_context
		local var_11_1 = Unit.world_position(arg_11_1, var_11_0.spine_node)
		local var_11_2 = var_0_0[arg_11_2.jump_data.target_unit]

		if var_11_2 then
			local var_11_3 = arg_11_2.locomotion_extension:current_velocity()
			local var_11_4 = Vector3.normalize(var_11_3)
			local var_11_5 = Geometry.closest_point_on_line(var_11_2, var_11_1, var_11_1 + var_11_4 * 20)
			local var_11_6 = Vector3.flat(var_11_5 - var_11_2)
			local var_11_7 = Vector3.length(var_11_6)

			QuickDrawer:line(var_11_5, Vector3(var_11_2.x, var_11_2.y, var_11_5.z))
			QuickDrawer:line(var_11_1, var_11_1 + var_11_4 * 20, Color(255, 0, 0))
			QuickDrawer:sphere(var_11_5, 0.05, Color(255, 0, 200, 100))
		end
	end
end
