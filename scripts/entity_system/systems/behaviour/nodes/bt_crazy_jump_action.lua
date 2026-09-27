-- chunkname: @scripts/entity_system/systems/behaviour/nodes/bt_crazy_jump_action.lua

require("scripts/entity_system/systems/behaviour/nodes/bt_node")

BTCrazyJumpAction = class(BTCrazyJumpAction, BTNode)

local POSITION_LOOKUP = POSITION_LOOKUP

BTCrazyJumpAction.init = function (arg_1_0, ...)
	-- function 1
	BTCrazyJumpAction.super.init(arg_1_0, ...)
end

BTCrazyJumpAction.name = "BTCrazyJumpAction"

local function fn(arg_2_0, arg_2_1, arg_2_2)
	-- function 2
	if not script_data.debug_ai_movement then
		Debug.world_sticky_text(POSITION_LOOKUP[arg_2_0], arg_2_1, arg_2_2)
	end
end

BTCrazyJumpAction.enter = function (self, arg_3_1, arg_3_2, arg_3_3)
	-- function 3
	aiprint("ENTER CRAZY JUMP ACTION")

	local action_data = self._tree_node.action_data

	arg_3_2.action = action_data

	local jump_data = arg_3_2.jump_data
	local network = Managers.state.network
	local extension = ScriptUnit.extension(arg_3_1, "ai_system")
	local var_3_4 = action_data.difficulty_jump_delay_time[Managers.state.difficulty:get_difficulty_rank()]

	var_3_4 = var_3_4 or action_data.difficulty_jump_delay_time[2]

	if not jump_data.delay_jump_start then
		jump_data.state = "align_for_push_off"
		jump_data.start_jump = arg_3_3 + (var_3_4 or 0.3)
		jump_data.delay_jump_start = nil
	elseif not jump_data.instant_jump then
		network:anim_event(arg_3_1, "to_crouch")
		network:anim_event(arg_3_1, "jump_start")

		jump_data.state = "push_off"
		jump_data.start_jump = arg_3_3
		jump_data.start_check_obstacles = arg_3_3 + 0.8

		self:create_bot_threat(arg_3_1, arg_3_2, arg_3_3)
	else
		network:anim_event(arg_3_1, "jump_start")

		jump_data.state = "push_off"
		jump_data.start_jump = arg_3_3 + (var_3_4 or 0.3)
		jump_data.start_check_obstacles = arg_3_3 + 0.8

		self:create_bot_threat(arg_3_1, arg_3_2, arg_3_3)
	end

	jump_data.target_unit = arg_3_2.target_unit
	jump_data.overlap_context = extension:get_overlap_context()
	jump_data.anim_jump_rot_var = Unit.animation_find_variable(arg_3_1, "jump_rotation")

	LocomotionUtils.set_animation_driven_movement(arg_3_1, false)

	local locomotion_extension = arg_3_2.locomotion_extension

	locomotion_extension:set_gravity(arg_3_2.breed.jump_gravity)
	locomotion_extension:set_check_falling(false)
end

BTCrazyJumpAction.leave = function (self, arg_4_1, arg_4_2, arg_4_3, arg_4_4, arg_4_5)
	-- function 4
	arg_4_2.skulk_pos = nil
	arg_4_2.comitted_to_target = false

	local locomotion_extension = arg_4_2.locomotion_extension

	if not locomotion_extension._engine_extension_id then
		return
	end

	locomotion_extension:set_mover_displacement()

	if arg_4_4 == "aborted" then
		if not arg_4_2.jump_data.updating_jump_rot then
			self:update_anim_variable_done(arg_4_1, arg_4_2.jump_data)
		end

		arg_4_2.jump_data = nil

		if not arg_4_2.smash_door then
			Managers.state.network:anim_event(arg_4_1, "to_upright")
		end

		arg_4_2.high_ground_opportunity = nil

		locomotion_extension:set_movement_type("snap_to_navmesh")
	end

	if arg_4_4 == "failed" then
		arg_4_2.jump_data = nil
		arg_4_2.high_ground_opportunity = nil
	end

	arg_4_2.navigation_extension:set_enabled(true)
	locomotion_extension:set_check_falling(true)
end

local num = 2.7

BTCrazyJumpAction.run = function (self, arg_5_1, arg_5_2, arg_5_3, arg_5_4)
	-- function 5
	local locomotion_extension = arg_5_2.locomotion_extension
	local jump_data = arg_5_2.jump_data
	local target_unit = jump_data.target_unit

	if not script_data.debug_ai_movement then
		self:debug(arg_5_1, arg_5_2, jump_data, arg_5_3)
	end

	if not AiUtils.is_of_interest_to_gutter_runner(arg_5_1, target_unit, arg_5_2) then
		arg_5_2.skulk_pos = nil
		jump_data.snap_failed = true

		if jump_data.state == "align_for_push_off" then
			return "failed"
		elseif not (jump_data.state == "in_air" or jump_data.state ~= "snapping") then
			jump_data.state = "in_air_no_target"
		end
	end

	if jump_data.state == "align_for_push_off" then
		local rotation_towards_unit_flat = LocomotionUtils.rotation_towards_unit_flat(arg_5_1, arg_5_2.target_unit)

		locomotion_extension:set_wanted_rotation(rotation_towards_unit_flat)
	else
		locomotion_extension:set_wanted_rotation(nil)
	end

	if arg_5_3 > jump_data.start_jump then
		if jump_data.state == "align_for_push_off" then
			Managers.state.network:anim_event(arg_5_1, "jump_start")

			jump_data.state = "push_off"
			jump_data.start_jump = arg_5_3 + 0.3
			jump_data.start_check_obstacles = arg_5_3 + 0.8

			self:create_bot_threat(arg_5_1, arg_5_2, arg_5_3)
		elseif jump_data.state == "push_off" then
			if not jump_data.jump_velocity_boxed then
				jump_data.state = "in_air"

				local overlap_context = jump_data.overlap_context

				overlap_context.has_gotten_callback = false
				overlap_context.num_hits = 0
				arg_5_2.last_jump = arg_5_3

				BTCrazyJumpAction:setup_jump(arg_5_1, arg_5_2, jump_data)
				locomotion_extension:set_mover_displacement(Vector3(0, 0, 0.5), 0.5)
			else
				return "failed"
			end
		elseif jump_data.state == "in_air" then
			arg_5_2.comitted_to_target = true

			local overlap_context_2 = jump_data.overlap_context
			local world_position = Unit.world_position(arg_5_1, overlap_context_2.spine_node)
			local num_2 = POSITION_LOOKUP[target_unit] - world_position
			local flat = Vector3.flat(num_2)
			local length = Vector3.length(flat)

			if not script_data.debug_ai_movement then
				QuickDrawerStay:sphere(world_position, 0.04)
			end

			if not (jump_data.snap_failed or not (length < num)) then
				if not ScriptUnit.extension(target_unit, "status_system").pounced_down then
					jump_data.state = "pounce_down_fail"

					self:update_anim_variable_done(arg_5_1, jump_data)

					jump_data.fail_time = arg_5_3 + 1

					Managers.state.network:anim_event(arg_5_1, "jump_fail")
					LocomotionUtils.set_animation_driven_movement(arg_5_1, true, false, false)
					aiprint("fail already snapped!")

					return "running"
				end

				jump_data.state = "snapping"

				self:update_anim_variable_done(arg_5_1, jump_data)

				return "running"
			end

			if not self:check_colliding_players(arg_5_1, arg_5_2, world_position) then
				return "done"
			end

			local mover = Unit.mover(arg_5_1)

			if arg_5_3 > jump_data.start_check_obstacles then
				if not Mover.collides_sides(mover) then
					jump_data.state = "hit_obstacle"

					self:update_anim_variable_done(arg_5_1, jump_data)
				elseif not (not Mover.collides_down(mover) and not (arg_5_3 - arg_5_2.last_jump > 0.1)) then
					arg_5_2.skulk_pos = nil
					jump_data.state = "landing"

					return "running"
				end
			end
		elseif jump_data.state == "in_air_no_target" then
			local overlap_context_3 = jump_data.overlap_context
			local world_position_2 = Unit.world_position(arg_5_1, overlap_context_3.spine_node)

			if not self:check_colliding_players(arg_5_1, arg_5_2, world_position_2) then
				return "done"
			end

			local mover_2 = Unit.mover(arg_5_1)

			if not Mover.collides_sides(mover_2) then
				jump_data.state = "hit_obstacle"

				self:update_anim_variable_done(arg_5_1, jump_data)
			elseif not (not Mover.collides_down(mover_2) and not (arg_5_3 - arg_5_2.last_jump > 0.1)) then
				arg_5_2.skulk_pos = nil
				jump_data.state = "landing"

				return "running"
			end
		elseif jump_data.state == "snapping" then
			local num_3 = 2
			local overlap_context_4 = jump_data.overlap_context
			local world_position_3 = Unit.world_position(arg_5_1, overlap_context_4.spine_node)
			local world_position_4 = Unit.world_position(target_unit, overlap_context_4.enemy_spine_node)
			local num_4 = world_position_4 - world_position_3
			local length_2 = Vector3.length(num_4)

			if not script_data.debug_ai_movement then
				QuickDrawerStay:sphere(world_position_3, 0.04, Color(200, 90, 0))
			end

			local current_velocity = arg_5_2.locomotion_extension:current_velocity()
			local normalize = Vector3.normalize(current_velocity)

			if Vector3.dot(normalize, Vector3.normalize(num_4)) < 0 then
				aiprint("GR missed crazy jump, player side-stepped")

				jump_data.state = "in_air"
				jump_data.snap_failed = true

				fn(arg_5_1, "JumpAction snapping->in_air player side-stepped", "yellow")

				return "running"
			end

			if not script_data.debug_ai_movement then
				QuickDrawer:sphere(world_position_3, num_3)
			end

			if not self:check_colliding_players(arg_5_1, arg_5_2, world_position_3) then
				fn(arg_5_1, "JumpAction snapping accidental!", "green")

				return "done"
			end

			if length_2 < num_3 then
				local num_5 = 1
				local closest_point_on_line = Geometry.closest_point_on_line(world_position_3, world_position_3, world_position_3 + normalize * 3)
				local flat_2 = Vector3.flat(closest_point_on_line - world_position_4)

				if num_5 > Vector3.length(flat_2) then
					fn(arg_5_1, "JumpAction snapping success SNAPPED!", "green")

					return "done"
				end
			end

			local flat_3 = Vector3.flat(jump_data.jump_target_pos:unbox() - world_position_3)

			if Vector3.dot(normalize, Vector3.normalize(flat_3)) < 0 then
				if not script_data.debug_ai_movement then
					QuickDrawerStay:sphere(world_position_3, 0.045, Color(200, 190, 0))
				end

				local mover_3 = Unit.mover(arg_5_1)

				if not (not Mover.collides_down(mover_3) and not (arg_5_3 - arg_5_2.last_jump > 0.1)) then
					fn(arg_5_1, "JumpAction snapping failed collides_down", "red")

					arg_5_2.skulk_pos = nil
					jump_data.state = "landing"

					return "running"
				end
			end

			return "running"
		elseif jump_data.state == "landing" then
			self:update_anim_variable_done(arg_5_1, jump_data)

			if not jump_data.land_time then
				if arg_5_3 > jump_data.land_time then
					jump_data.land_time = nil

					return "failed"
				end
			else
				LocomotionUtils.set_animation_driven_movement(arg_5_1, false)
				locomotion_extension:set_wanted_velocity(Vector3.zero())
				locomotion_extension:set_movement_type("snap_to_navmesh")
				Managers.state.network:anim_event(arg_5_1, "jump_land")

				jump_data.land_time = arg_5_3 + 0.5
			end

			return "running"
		elseif jump_data.state == "hit_obstacle" then
			locomotion_extension:set_wanted_velocity(Vector3.zero())

			arg_5_2.is_falling = true

			do return "failed" end

			local mover_4 = Unit.mover(arg_5_1)
			local standing_frames = Mover.standing_frames(mover_4)
			local network = Managers.state.network

			network:anim_event(arg_5_1, "to_upright")
			network:anim_event(arg_5_1, "jump_down")

			local current_velocity_2 = locomotion_extension:current_velocity()

			locomotion_extension:set_wanted_velocity(current_velocity_2)

			if standing_frames > 0 then
				Debug.sticky_text("Gutter runner - in air hit obstacle, but have landed again")

				return "failed"
			else
				network:anim_event(arg_5_1, "jump_down_land")

				return "running"
			end
		elseif jump_data.state == "pounce_down_fail" then
			if arg_5_3 < jump_data.fail_time then
				fn(arg_5_1, "Pounce down fail", "purple")

				return "running"
			end

			aiprint("pounce_down_fail done!!!!")

			arg_5_2.target_unit = nil
			arg_5_2.jump_data.target_unit = nil

			LocomotionUtils.set_animation_driven_movement(arg_5_1, false)
			fn(arg_5_1, "JumpAction pounce_down_fail failed", "red")

			return "failed"
		end
	end

	return "running"
end

BTCrazyJumpAction.create_bot_threat = function (arg_6_0, arg_6_1, arg_6_2, arg_6_3)
	-- function 6
	local has_extension = ScriptUnit.has_extension(arg_6_2.target_unit, "first_person_system")

	if not has_extension then
		local current_position = has_extension:current_position()
		local current_rotation = has_extension:current_rotation()
		local normalize = Vector3.normalize(current_position - POSITION_LOOKUP[arg_6_1])
		local forward = Quaternion.forward(current_rotation)
		local dot = Vector3.dot(forward, normalize)

		if not (not (dot >= 0.55) or dot <= 1) then
			local var_6_6 = POSITION_LOOKUP[arg_6_1]
			local num = POSITION_LOOKUP[arg_6_2.target_unit] - var_6_6
			local length = Vector3.length(num)
			local calculate_oobb, var_6_10, var_6_11 = AiUtils.calculate_oobb(length + 3, var_6_6, Quaternion.look(num))
			local num_2 = 0.5

			Managers.state.entity:system("ai_bot_group_system"):aoe_threat_created(calculate_oobb, "oobb", var_6_11, var_6_10, num_2, "Crazy Jump")
		end
	end
end

local flag = true

BTCrazyJumpAction.check_colliding_players = function (self, arg_7_1, arg_7_2, arg_7_3)
	-- function 7
	if not flag then
		local num = 1
		local immediate_overlap, var_7_2 = PhysicsWorld.immediate_overlap(self.physics_world, "shape", "sphere", "position", arg_7_3, "size", num, "types", "both", "collision_filter", "filter_player_and_husk_trigger")

		if var_7_2 > 0 then
			for i = 1, var_7_2 do
				local var_7_3 = immediate_overlap[i]
				local unit = Actor.unit(var_7_3)

				if not AiUtils.is_of_interest_to_gutter_runner(arg_7_1, unit, arg_7_2) then
					arg_7_2.jump_data.target_unit = unit
					arg_7_2.target_unit = unit

					return unit
				end
			end
		end
	else
		local ENEMY_PLAYER_AND_BOT_UNITS = arg_7_2.side.ENEMY_PLAYER_AND_BOT_UNITS
		local num_2 = 4
		local var_7_7

		for j = 1, #ENEMY_PLAYER_AND_BOT_UNITS do
			local var_7_8 = ENEMY_PLAYER_AND_BOT_UNITS[j]
			local var_7_9 = POSITION_LOOKUP[var_7_8]
			local distance_squared = Vector3.distance_squared(arg_7_3, var_7_9)

			if distance_squared < num_2 then
				var_7_7 = var_7_8
				num_2 = distance_squared
			end
		end

		return var_7_7
	end
end

BTCrazyJumpAction.setup_jump = function (self, arg_8_1, arg_8_2, arg_8_3)
	-- function 8
	local unbox = arg_8_3.jump_target_pos:unbox()
	local unbox_2 = arg_8_3.jump_velocity_boxed:unbox()

	arg_8_2.navigation_extension:set_enabled(false)
	LocomotionUtils.set_animation_driven_movement(arg_8_1, false)

	local override_mover_move_distance = arg_8_2.breed.override_mover_move_distance
	local locomotion_extension = arg_8_2.locomotion_extension

	locomotion_extension:set_affected_by_gravity(true)
	locomotion_extension:set_movement_type("constrained_by_mover", override_mover_move_distance, arg_8_3.instant_jump)
	locomotion_extension:set_wanted_velocity(unbox_2)

	arg_8_3.overlap_context.spine_node = Unit.node(arg_8_1, "j_neck")
	arg_8_3.overlap_context.enemy_spine_node = arg_8_3.enemy_spine_node

	local world = arg_8_2.world

	self.physics_world = World.get_data(world, "physics_world")

	Managers.state.entity:system("animation_system"):start_anim_variable_update_by_distance(arg_8_1, arg_8_3.anim_jump_rot_var, unbox, 2, true)

	arg_8_3.updating_jump_rot = true
end

BTCrazyJumpAction.update_anim_variable_done = function (arg_9_0, arg_9_1, arg_9_2)
	-- function 9
	Managers.state.entity:system("animation_system"):set_update_anim_variable_done(arg_9_1)

	arg_9_2.updating_jump_rot = false
end

local num_2 = 1
local num_3 = 2
local num_4 = 3
local num_5 = 4
local tbl = {}

BTCrazyJumpAction.ray_cast = function (arg_10_0, arg_10_1, arg_10_2, arg_10_3)
	-- function 10
	local num = arg_10_1 - arg_10_0
	local normalize = Vector3.normalize(num)
	local length = Vector3.length(num)
	local get_data = World.get_data(arg_10_2.world, "physics_world")
	local immediate_raycast = PhysicsWorld.immediate_raycast(get_data, arg_10_0, normalize, length, "all", "collision_filter", "filter_ray_projectile")

	if not immediate_raycast then
		local var_10_5 = tbl

		table.clear(var_10_5)

		local count = #immediate_raycast

		for i = 1, count do
			local var_10_7 = immediate_raycast[i]
			local var_10_8 = var_10_7[num_2]
			local var_10_9 = var_10_7[num_3]
			local var_10_10 = var_10_7[num_4]
			local var_10_11 = var_10_7[num_5]
			local unit = Actor.unit(var_10_11)

			if not (unit == arg_10_3 or unit == arg_10_3) then
				return unit
			end
		end
	end

	return nil
end

BTCrazyJumpAction.debug = function (arg_11_0, arg_11_1, arg_11_2, arg_11_3, arg_11_4)
	-- function 11
	if not (arg_11_3.state == "in_air" or arg_11_3.state ~= "snapping") then
		local overlap_context = arg_11_3.overlap_context
		local world_position = Unit.world_position(arg_11_1, overlap_context.spine_node)
		local var_11_2 = POSITION_LOOKUP[arg_11_2.jump_data.target_unit]

		if not var_11_2 then
			local current_velocity = arg_11_2.locomotion_extension:current_velocity()
			local normalize = Vector3.normalize(current_velocity)
			local closest_point_on_line = Geometry.closest_point_on_line(var_11_2, world_position, world_position + normalize * 20)
			local flat = Vector3.flat(closest_point_on_line - var_11_2)
			local length = Vector3.length(flat)

			QuickDrawer:line(closest_point_on_line, Vector3(var_11_2.x, var_11_2.y, closest_point_on_line.z))
			QuickDrawer:line(world_position, world_position + normalize * 20, Color(255, 0, 0))
			QuickDrawer:sphere(closest_point_on_line, 0.05, Color(255, 0, 200, 100))
		end
	end
end
