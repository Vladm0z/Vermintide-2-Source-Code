-- chunkname: @scripts/entity_system/systems/behaviour/nodes/bt_combat_step_action.lua

require("scripts/entity_system/systems/behaviour/nodes/bt_node")

BTCombatStepAction = class(BTCombatStepAction, BTNode)

BTCombatStepAction.init = function (arg_1_0, ...)
	-- function 1
	BTCombatStepAction.super.init(arg_1_0, ...)
end

BTCombatStepAction.name = "BTCombatStepAction"

local function fn(self)
	-- function 2
	if type(self) == "table" then
		return self[Math.random(1, #self)]
	else
		return self
	end
end

BTCombatStepAction.enter = function (self, arg_3_1, arg_3_2, arg_3_3)
	-- function 3
	arg_3_2.action = self._tree_node.action_data
	arg_3_2.active_node = BTCombatStepAction
	arg_3_2.start_finished = nil
	arg_3_2.start_started_since = arg_3_3

	local navigation_extension = arg_3_2.navigation_extension
	local target_unit = arg_3_2.target_unit
	local rotation_towards_unit_flat = LocomotionUtils.rotation_towards_unit_flat(arg_3_1, target_unit)
	local local_rotation = Unit.local_rotation(arg_3_1, 0)
	local forward = Quaternion.forward(local_rotation)
	local action = arg_3_2.action
	local force_combat_step_animation = action.force_combat_step_animation

	force_combat_step_animation = force_combat_step_animation or self:_get_animation(rotation_towards_unit_flat, forward)

	local move_speed = action.move_speed

	if not move_speed then
		navigation_extension:set_max_speed(move_speed)
	end

	local var_3_8 = fn(force_combat_step_animation)

	Managers.state.network:anim_event(arg_3_1, var_3_8)

	arg_3_2.move_state = "moving"

	Managers.state.entity:system("ai_slot_system"):do_slot_search(arg_3_1, false)

	local nav_world = arg_3_2.nav_world
	local ray_can_go_on_mesh = LocomotionUtils.ray_can_go_on_mesh(nav_world, POSITION_LOOKUP[arg_3_1], POSITION_LOOKUP[target_unit], nil, 1, 1)

	if force_combat_step_animation == "combat_step_fwd" or not ray_can_go_on_mesh then
		arg_3_2.locomotion_extension:use_lerp_rotation(false)
		LocomotionUtils.set_animation_driven_movement(arg_3_1, true, true, false)

		local var_3_11 = POSITION_LOOKUP[target_unit]
		local get_animation_rotation_scale = AiAnimUtils.get_animation_rotation_scale(arg_3_1, var_3_11, force_combat_step_animation, action.start_anims_data)

		LocomotionUtils.set_animation_rotation_scale(arg_3_1, get_animation_rotation_scale)

		arg_3_2.is_not_forward_combat_step = true
	else
		local locomotion_extension = arg_3_2.locomotion_extension
		local rotation_towards_unit_flat_2 = LocomotionUtils.rotation_towards_unit_flat(arg_3_1, target_unit)

		locomotion_extension:set_wanted_rotation(rotation_towards_unit_flat_2)
	end
end

BTCombatStepAction.leave = function (arg_4_0, arg_4_1, arg_4_2, arg_4_3, arg_4_4, arg_4_5)
	-- function 4
	arg_4_2.start_finished = nil
	arg_4_2.start_started_since = nil

	Managers.state.entity:system("ai_slot_system"):do_slot_search(arg_4_1, true)

	arg_4_2.active_node = nil

	local get_default_breed_move_speed = AiUtils.get_default_breed_move_speed(arg_4_1, arg_4_2)

	arg_4_2.navigation_extension:set_max_speed(get_default_breed_move_speed)

	if not arg_4_2.is_not_forward_combat_step then
		local locomotion_extension = arg_4_2.locomotion_extension

		locomotion_extension:use_lerp_rotation(true)
		LocomotionUtils.set_animation_driven_movement(arg_4_1, false)
		LocomotionUtils.set_animation_rotation_scale(arg_4_1, 1)

		arg_4_2.is_not_forward_combat_step = nil

		locomotion_extension:set_rotation_speed(10)
		locomotion_extension:set_wanted_rotation(nil)
		locomotion_extension:set_movement_type("snap_to_navmesh")
	end
end

BTCombatStepAction.run = function (arg_5_0, arg_5_1, arg_5_2, arg_5_3, arg_5_4)
	-- function 5
	if not (arg_5_2.start_finished or not (arg_5_3 - arg_5_2.start_started_since > 10)) then
		return "done"
	end

	return "running"
end

BTCombatStepAction.anim_cb_combat_step_stop = function (arg_6_0, arg_6_1, arg_6_2)
	-- function 6
	local navigation_extension = arg_6_2.navigation_extension

	if not navigation_extension:is_following_path() then
		navigation_extension:stop()
	end

	Managers.state.entity:system("ai_slot_system"):do_slot_search(arg_6_1, false)
end

BTCombatStepAction._get_animation = function (arg_7_0, arg_7_1, arg_7_2)
	-- function 7
	local right = Quaternion.right(arg_7_1)
	local dot = Vector3.dot(right, arg_7_2)
	local abs = math.abs(dot)
	local forward = Quaternion.forward(arg_7_1)
	local dot_2 = Vector3.dot(forward, arg_7_2)
	local abs_2 = math.abs(dot_2)
	local var_7_6
	local flag

	flag = (not (abs_2 < abs) or not (dot > 0) or not "combat_step_left" or not (abs_2 < abs)) and (not "combat_step_right" or not (dot_2 >= 0) or not "combat_step_fwd" or "combat_step_bwd")

	return flag
end
