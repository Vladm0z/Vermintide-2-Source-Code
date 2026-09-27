-- chunkname: @scripts/entity_system/systems/behaviour/nodes/chaos_sorcerer/bt_chaos_sorcerer_tether_skulk_action.lua

require("scripts/entity_system/systems/behaviour/nodes/bt_node")

BTChaosSorcererTetherSkulkAction = class(BTChaosSorcererTetherSkulkAction, BTNode)

local BTChaosSorcererTetherSkulkAction = BTChaosSorcererTetherSkulkAction
local POSITION_LOOKUP = POSITION_LOOKUP

BTChaosSorcererTetherSkulkAction.init = function (arg_1_0, ...)
	-- function 1
	BTChaosSorcererTetherSkulkAction.super.init(arg_1_0, ...)
end

BTChaosSorcererTetherSkulkAction.name = "BTChaosSorcererTetherSkulkAction"

BTChaosSorcererTetherSkulkAction.enter = function (self, arg_2_1, arg_2_2, arg_2_3)
	-- function 2
	local action_data = self._tree_node.action_data
	local skulk_data = arg_2_2.skulk_data

	skulk_data = skulk_data or {}
	arg_2_2.skulk_data = skulk_data

	local direction = skulk_data.direction

	if not direction then
		direction = action_data.direction
		direction = direction or 1 - math.random(0, 1) * 2
	end

	skulk_data.direction = direction

	local radius = skulk_data.radius

	radius = radius or arg_2_2.target_dist
	skulk_data.radius = radius

	local last_reference_pos = skulk_data.last_reference_pos

	last_reference_pos = last_reference_pos or Vector3Box()
	skulk_data.last_reference_pos = last_reference_pos

	skulk_data.last_reference_pos:store(Vector3.zero())

	arg_2_2.action = action_data

	if arg_2_2.move_state ~= "idle" then
		self:idle(arg_2_1, arg_2_2)
	end

	LocomotionUtils.set_animation_driven_movement(arg_2_1, false)

	if not arg_2_2.move_pos then
		local unbox = arg_2_2.move_pos:unbox()

		self:move_to(unbox, arg_2_1, arg_2_2)
	end

	arg_2_2.health_extension = ScriptUnit.extension(arg_2_1, "health_system")

	arg_2_2.locomotion_extension:use_lerp_rotation(true)
	arg_2_2.locomotion_extension:set_rotation_speed(math.pi)
end

BTChaosSorcererTetherSkulkAction.leave = function (self, arg_3_1, arg_3_2, arg_3_3, arg_3_4, arg_3_5)
	-- function 3
	local skulk_data = arg_3_2.skulk_data
	local get_default_breed_move_speed = AiUtils.get_default_breed_move_speed(arg_3_1, arg_3_2)
	local navigation_extension = arg_3_2.navigation_extension

	navigation_extension:set_max_speed(get_default_breed_move_speed)

	if arg_3_4 == "aborted" then
		local is_following_path = navigation_extension:is_following_path()

		if not (not arg_3_2.move_pos and not is_following_path and arg_3_2.move_state ~= "idle") then
			self:start_move_animation(arg_3_1, arg_3_2)
		end
	end

	skulk_data.animation_state = nil
	arg_3_2.action = nil

	arg_3_2.locomotion_extension:use_lerp_rotation(false)
	arg_3_2.locomotion_extension:set_rotation_speed(nil)

	if arg_3_4 == "failed" then
		arg_3_2.target_unit = nil
	end
end

BTChaosSorcererTetherSkulkAction.run = function (self, arg_4_1, arg_4_2, arg_4_3, arg_4_4)
	-- function 4
	if not Unit.alive(arg_4_2.target_unit) then
		return "failed"
	end

	local navigation_extension = arg_4_2.navigation_extension
	local is_following_path = navigation_extension:is_following_path()
	local number_failed_move_attempts = navigation_extension:number_failed_move_attempts()

	if not (not arg_4_2.move_pos and not is_following_path and arg_4_2.move_state ~= "idle") then
		self:start_move_animation(arg_4_1, arg_4_2)
	end

	if not (not arg_4_2.vanish_timer and not (arg_4_3 < arg_4_2.vanish_timer)) then
		Managers.state.entity:system("ping_system"):remove_ping_from_unit(arg_4_1)

		return "running"
	end

	if not arg_4_2.move_pos then
		if not (self:at_goal(arg_4_1, arg_4_2) or not (number_failed_move_attempts > 0)) then
			arg_4_2.move_pos = nil
		end

		return "running"
	end

	local get_skulk_target = self:get_skulk_target(arg_4_1, arg_4_2)

	if not get_skulk_target then
		self:move_to(get_skulk_target, arg_4_1, arg_4_2)

		return "running"
	end

	if arg_4_2.move_state ~= "idle" then
		self:idle(arg_4_1, arg_4_2)
	end

	return "running"
end

BTChaosSorcererTetherSkulkAction.at_goal = function (arg_5_0, arg_5_1, arg_5_2)
	-- function 5
	local move_pos = arg_5_2.move_pos
	local var_5_1 = POSITION_LOOKUP[arg_5_1]

	if not move_pos then
		return false
	end

	local unbox = move_pos:unbox()

	if (unbox[3] - var_5_1[3])^2 > 0.5 then
		return false
	end

	return (unbox[1] - var_5_1[1])^2 + (unbox[2] - var_5_1[2])^2 < 1
end

BTChaosSorcererTetherSkulkAction.move_to = function (arg_6_0, arg_6_1, arg_6_2, arg_6_3)
	-- function 6
	arg_6_3.navigation_extension:move_to(arg_6_1)

	arg_6_3.move_pos = Vector3Box(arg_6_1)
end

BTChaosSorcererTetherSkulkAction.idle = function (self, arg_7_1, arg_7_2)
	-- function 7
	self:anim_event(arg_7_1, arg_7_2, "idle")

	arg_7_2.move_state = "idle"
end

BTChaosSorcererTetherSkulkAction.start_move_animation = function (self, arg_8_1, arg_8_2)
	-- function 8
	local move_animation = arg_8_2.action.move_animation

	self:anim_event(arg_8_1, arg_8_2, move_animation)

	arg_8_2.move_state = "moving"
end

BTChaosSorcererTetherSkulkAction.anim_event = function (arg_9_0, arg_9_1, arg_9_2, arg_9_3)
	-- function 9
	local skulk_data = arg_9_2.skulk_data

	if skulk_data.animation_state ~= arg_9_3 then
		Managers.state.network:anim_event(arg_9_1, arg_9_3)

		skulk_data.animation_state = arg_9_3
	end
end

local num = 30

BTChaosSorcererTetherSkulkAction.get_skulk_target = function (arg_10_0, arg_10_1, arg_10_2, arg_10_3)
	-- function 10
	local target_unit = arg_10_2.target_unit

	if not target_unit then
		return
	end

	local action = arg_10_2.action
	local skulk_data = arg_10_2.skulk_data
	local direction = skulk_data.direction
	local var_10_4 = POSITION_LOOKUP[target_unit]
	local var_10_5 = POSITION_LOOKUP[arg_10_1]
	local unbox = skulk_data.last_reference_pos:unbox()

	if Vector3.length_squared(unbox) <= 0 then
		unbox = var_10_5
	end

	local num_2 = var_10_4 - unbox
	local normalize = Vector3.normalize(num_2)
	local preferred_distance_variance = action.preferred_distance_variance

	preferred_distance_variance = preferred_distance_variance or 0

	local preferred_distance = action.preferred_distance

	preferred_distance = preferred_distance or 20

	local num_3 = preferred_distance + math.lerp(-preferred_distance_variance, preferred_distance_variance, math.random())
	local distance_before_turn = action.distance_before_turn

	distance_before_turn = distance_before_turn or 5

	local num_4 = num_3 * 2 * math.pi

	assert(distance_before_turn < num_4 * 0.25, "preferred distance is too small to move %s units before turning. Minimum %s (quarter of the circumference)", distance_before_turn, num_4 * 0.25)

	local num_5 = math.tau * (distance_before_turn / num_4)
	local num_6 = Quaternion.rotate(Quaternion.axis_angle(Vector3.up() * direction, num_5), -normalize) * num_3
	local num_7 = var_10_4 + num_6
	local num_8 = num_7 - var_10_5
	local raycango = GwNavQueries.raycango
	local nav_world = arg_10_2.nav_world
	local traverse_logic = arg_10_2.navigation_extension:traverse_logic()
	local num_9 = math.pi * 2 / num
	local axis_angle = Quaternion.axis_angle(Vector3(0, 0, math.sign(Vector3.cross(num_6, num_8)[3])), num_9)
	local normalize_2 = Vector3.normalize(num_8)
	local var_10_24
	local var_10_25

	for i = 1, num do
		local num_10 = var_10_5 + normalize_2 * distance_before_turn

		num_10 = LocomotionUtils.pos_on_mesh(nav_world, num_10, 5, 5) or num_10

		local var_10_27, var_10_28 = raycango(nav_world, var_10_5, num_10, traverse_logic)

		if not var_10_27 then
			local pos_on_mesh = LocomotionUtils.pos_on_mesh(nav_world, num_10, 2, 2)

			if not pos_on_mesh then
				var_10_24 = pos_on_mesh
			end

			break
		end

		if not var_10_28 then
			local pos_on_mesh_2 = LocomotionUtils.pos_on_mesh(nav_world, var_10_5 + (var_10_28 - var_10_5) * 0.5, 1, 1)

			if not pos_on_mesh_2 then
				var_10_25 = pos_on_mesh_2
			end
		end

		normalize_2 = Quaternion.rotate(axis_angle, normalize_2)
	end

	var_10_24 = var_10_24 or var_10_25

	skulk_data.last_reference_pos:store(num_7)

	return var_10_24
end
