-- chunkname: @scripts/entity_system/systems/behaviour/nodes/bt_jump_slam_action.lua

require("scripts/entity_system/systems/behaviour/nodes/bt_node")

local POSITION_LOOKUP = POSITION_LOOKUP

BTJumpSlamAction = class(BTJumpSlamAction, BTNode)

BTJumpSlamAction.init = function (arg_1_0, ...)
	-- function 1
	BTJumpSlamAction.super.init(arg_1_0, ...)
end

BTJumpSlamAction.name = "BTJumpSlamAction"

BTJumpSlamAction.enter = function (self, arg_2_1, arg_2_2, arg_2_3)
	-- function 2
	local jump_slam_data = arg_2_2.jump_slam_data

	jump_slam_data.anim_jump_rot_var = Unit.animation_find_variable(arg_2_1, "jump_rotation")
	jump_slam_data.start_jump_time = arg_2_3
	jump_slam_data.landing_time = arg_2_3 + jump_slam_data.time_of_flight
	arg_2_2.keep_target = true

	Managers.state.entity:system("animation_system"):start_anim_variable_update_by_time(arg_2_1, jump_slam_data.anim_jump_rot_var, jump_slam_data.time_of_flight, 2)
	BTJumpSlamAction.progress_to_in_flight(arg_2_2, arg_2_1, jump_slam_data.initial_velociy_boxed:unbox())
	Managers.state.conflict:freeze_intensity_decay(15)

	local action_data = self._tree_node.action_data
	local bot_threats = action_data.bot_threats

	if not bot_threats then
		local num = 1
		local start_time_before_landing = bot_threats[num].start_time_before_landing
		local landing_time = jump_slam_data.landing_time

		arg_2_2.create_bot_threat_at_t = math.max(landing_time - start_time_before_landing, 0)
		arg_2_2.current_bot_threat_index = num
		arg_2_2.bot_threats_data = bot_threats
	end

	arg_2_2.action = action_data

	local target_unit = arg_2_2.target_unit

	AiUtils.add_attack_intensity(target_unit, action_data, arg_2_2)
end

BTJumpSlamAction.leave = function (arg_3_0, arg_3_1, arg_3_2, arg_3_3, arg_3_4, arg_3_5)
	-- function 3
	Managers.state.entity:system("animation_system"):set_update_anim_variable_done(arg_3_1)

	arg_3_2.jump_slam_data.updating_jump_rot = false

	arg_3_2.navigation_extension:set_enabled(true)

	if not arg_3_2.jump_slam_data.constrained then
		LocomotionUtils.constrain_on_clients(arg_3_1, false)
	end

	if arg_3_4 == "aborted" then
		LocomotionUtils.set_animation_driven_movement(arg_3_1, false, true)

		arg_3_2.keep_target = nil
		arg_3_2.jump_slam_data = nil
	end

	arg_3_2.action = nil
	arg_3_2.create_bot_threat_at_t = nil
	arg_3_2.current_bot_threat_index = nil
	arg_3_2.bot_threats_data = nil
end

BTJumpSlamAction.run = function (self, arg_4_1, arg_4_2, arg_4_3, arg_4_4)
	-- function 4
	local jump_slam_data = arg_4_2.jump_slam_data

	if not (not (arg_4_2.locomotion_extension:current_velocity().z < 0) or jump_slam_data.constrained) then
		jump_slam_data.constrained = true

		local num = POSITION_LOOKUP[arg_4_1] + Vector3.up() * 2
		local unbox = jump_slam_data.target_pos:unbox()

		LocomotionUtils.constrain_on_clients(arg_4_1, true, unbox, num)
	end

	local create_bot_threat_at_t = arg_4_2.create_bot_threat_at_t

	if not (not create_bot_threat_at_t and not (create_bot_threat_at_t < arg_4_3)) then
		local action = arg_4_2.action
		local bot_threats_data = arg_4_2.bot_threats_data
		local unbox_2 = jump_slam_data.attack_rotation:unbox()
		local current_bot_threat_index = arg_4_2.current_bot_threat_index
		local var_4_8 = bot_threats_data[current_bot_threat_index]

		self:_create_bot_aoe_threat(jump_slam_data, unbox_2, action, var_4_8)

		local num_2 = current_bot_threat_index + 1
		local var_4_10 = bot_threats_data[num_2]

		if not var_4_10 then
			arg_4_2.create_bot_threat_at_t = jump_slam_data.landing_time - var_4_10.start_time_before_landing
			arg_4_2.current_bot_threat_index = num_2
		else
			arg_4_2.create_bot_threat_at_t = nil
			arg_4_2.current_bot_threat_index = nil
		end
	end

	if arg_4_3 + arg_4_4 >= jump_slam_data.landing_time then
		BTJumpSlamAction.progress_to_landing(arg_4_2, arg_4_1, jump_slam_data)

		return "done"
	end

	return "running"
end

BTJumpSlamAction._calculate_sphere_collision = function (arg_5_0, arg_5_1, arg_5_2, arg_5_3, arg_5_4)
	-- function 5
	local radius = arg_5_2.radius

	radius = radius or arg_5_1.radius

	local offset_forward = arg_5_2.offset_forward

	offset_forward = offset_forward or arg_5_1.forward_offset

	return arg_5_3 + Quaternion.forward(arg_5_4) * offset_forward, radius
end

BTJumpSlamAction._create_bot_aoe_threat = function (self, arg_6_1, arg_6_2, arg_6_3, arg_6_4)
	-- function 6
	local duration = arg_6_4.duration
	local unbox = arg_6_1.target_pos:unbox()
	local _calculate_sphere_collision, var_6_3 = self:_calculate_sphere_collision(arg_6_3, arg_6_4, unbox, arg_6_2)

	Managers.state.entity:system("ai_bot_group_system"):aoe_threat_created(_calculate_sphere_collision, "sphere", var_6_3, nil, duration, "Jump Slam")
end

BTJumpSlamAction.progress_to_landing = function (self, arg_7_1, arg_7_2)
	-- function 7
	LocomotionUtils.set_animation_driven_movement(arg_7_1, true, false, false)
	Managers.state.network:anim_event(arg_7_1, "attack_jump_land")

	local locomotion_extension = self.locomotion_extension

	locomotion_extension:set_movement_type("snap_to_navmesh")
	locomotion_extension:set_wanted_velocity(Vector3.zero())
	locomotion_extension:set_gravity(nil)
end

BTJumpSlamAction.progress_to_in_flight = function (self, arg_8_1, arg_8_2)
	-- function 8
	LocomotionUtils.set_animation_driven_movement(arg_8_1, false, true)

	local locomotion_extension = self.locomotion_extension

	locomotion_extension:set_movement_type("script_driven")
	locomotion_extension:set_gravity(self.breed.jump_slam_gravity)
	locomotion_extension:set_wanted_velocity(arg_8_2)
end
