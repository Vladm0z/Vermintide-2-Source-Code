-- chunkname: @scripts/entity_system/systems/behaviour/nodes/bt_dummy_stagger_action.lua

require("scripts/entity_system/systems/behaviour/nodes/bt_node")

local scripts_utils_stagger_types = require("scripts/utils/stagger_types")

BTDummyStaggerAction = class(BTDummyStaggerAction, BTNode)

BTDummyStaggerAction.init = function (arg_1_0, ...)
	-- function 1
	BTDummyStaggerAction.super.init(arg_1_0, ...)
end

BTDummyStaggerAction.name = "BTDummyStaggerAction"

local num = 0.35

BTDummyStaggerAction.enter = function (self, arg_2_1, arg_2_2, arg_2_3)
	-- function 2
	local breed = arg_2_2.breed

	if not arg_2_2.staggering_id then
		local flag

		flag = arg_2_2.stagger ~= arg_2_2.staggering_id
	end

	arg_2_2.stagger_anim_done = false
	arg_2_2.stagger_hit_wall = nil
	arg_2_2.stagger_ignore_anim_cb = nil
	arg_2_2.staggering_id = arg_2_2.stagger
	arg_2_2.attack_aborted = true
	arg_2_2.move_state = "stagger"
	arg_2_2.active_node = BTDummyStaggerAction
	arg_2_2.stagger_time = arg_2_3 + 0.35

	local action_data = self._tree_node.action_data

	arg_2_2.action = action_data

	ScriptUnit.extension(arg_2_1, "ai_system"):increase_stagger_count()

	local var_2_3
	local var_2_4
	local var_2_5
	local var_2_6
	local str = "idle"
	local var_2_8 = action_data.stagger_anims[arg_2_2.stagger_type]
	local unbox = arg_2_2.stagger_direction:unbox()
	local _select_animation, var_2_11 = self:_select_animation(arg_2_1, arg_2_2, unbox, var_2_8)

	Managers.state.network:anim_event(arg_2_1, _select_animation)
end

BTDummyStaggerAction._select_animation = function (arg_3_0, arg_3_1, arg_3_2, arg_3_3, arg_3_4)
	-- function 3
	local normalize = Vector3.normalize(arg_3_3)
	local forward = Quaternion.forward(Unit.local_rotation(arg_3_1, 0))
	local dot = Vector3.dot(forward, normalize)
	local clamp = math.clamp(dot, -1, 1)
	local acos = math.acos(clamp)
	local action = arg_3_2.action
	local locomotion_extension = arg_3_2.locomotion_extension
	local current_velocity

	if not locomotion_extension then
		current_velocity = locomotion_extension:current_velocity()

		if not current_velocity then
			-- Nothing
		end
	end

	current_velocity = Vector3(0, 0, 0)

	::label_3_0::

	local var_3_8
	local var_3_9
	local moving_stagger_minimum_destination_distance = action.moving_stagger_minimum_destination_distance
	local flag = not moving_stagger_minimum_destination_distance and moving_stagger_minimum_destination_distance < arg_3_2.destination_dist
	local moving_stagger_threshold = action.moving_stagger_threshold
	local dot_2 = Vector3.dot(current_velocity, forward)
	local flag_2 = not moving_stagger_threshold and moving_stagger_threshold < dot_2
	local flag_3 = false

	if not arg_3_2.always_stagger_suffered then
		flag_3 = not flag and flag_2
	end

	arg_3_2.always_stagger_suffered = nil

	if arg_3_3.z ~= -1 or not arg_3_4.dwn then
		normalize.z = 0
		var_3_8 = Quaternion.look(-normalize)
		var_3_9 = not flag_3 and arg_3_4.moving_dwn and arg_3_4.dwn
	else
		normalize.z = 0

		if acos > math.pi * 0.75 then
			var_3_8 = Quaternion.look(-normalize)
			var_3_9 = not flag_3 and arg_3_4.moving_bwd and arg_3_4.bwd
		elseif acos < math.pi * 0.25 then
			var_3_8 = Quaternion.look(normalize)
			var_3_9 = not flag_3 and arg_3_4.moving_fwd and arg_3_4.fwd
		elseif Vector3.cross(forward, normalize).z > 0 then
			local cross = Vector3.cross(Vector3(0, 0, -1), normalize)

			var_3_8 = Quaternion.look(cross)
			var_3_9 = not flag_3 and arg_3_4.moving_left and arg_3_4.left
		else
			local cross_2 = Vector3.cross(Vector3(0, 0, 1), normalize)

			var_3_8 = Quaternion.look(cross_2)
			var_3_9 = not flag_3 and arg_3_4.moving_right and arg_3_4.right
		end
	end

	local count = #var_3_9
	local random = Math.random(1, count)
	local var_3_20 = var_3_9[random]

	if var_3_20 == arg_3_2.last_stagger_anim then
		var_3_20 = var_3_9[random % count + 1]
	end

	arg_3_2.last_stagger_anim = var_3_20

	local yaw = Quaternion.yaw(var_3_8)
	local var_3_22 = Quaternion(Vector3.up(), yaw)

	return var_3_20, var_3_22
end

BTDummyStaggerAction.clean_blackboard = function (arg_4_0, arg_4_1)
	-- function 4
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

BTDummyStaggerAction.leave = function (self, arg_5_1, arg_5_2, arg_5_3, arg_5_4, arg_5_5)
	-- function 5
	self:clean_blackboard(arg_5_2)

	if not arg_5_5 then
		local network = Managers.state.network
		local var_5_1

		if not arg_5_2.post_stagger_event then
			var_5_1 = arg_5_2.post_stagger_event
			arg_5_2.post_stagger_event = nil
		else
			var_5_1 = "stagger_finished"
		end

		network:anim_event(arg_5_1, var_5_1)
	end

	local run_on_stagger_action_done = arg_5_2.breed.run_on_stagger_action_done

	if not run_on_stagger_action_done then
		run_on_stagger_action_done(arg_5_1, arg_5_2, arg_5_3)
	end

	ScriptUnit.has_extension(arg_5_1, "hit_reaction_system").force_ragdoll_on_death = nil
end

BTDummyStaggerAction.run = function (self, arg_6_1, arg_6_2, arg_6_3, arg_6_4)
	-- function 6
	if arg_6_2.stagger ~= arg_6_2.staggering_id then
		self:enter(arg_6_1, arg_6_2, arg_6_3)
	end

	local locomotion_extension = arg_6_2.locomotion_extension
	local stagger_anim_done = arg_6_2.stagger_anim_done
	local flag = arg_6_3 > arg_6_2.stagger_time
	local stagger_ignore_anim_cb = arg_6_2.stagger_ignore_anim_cb

	if not (not arg_6_2.stagger_immune_time and not (arg_6_3 > arg_6_2.stagger_immune_time)) then
		arg_6_2.stagger_immune_time = nil
	end

	if not (not arg_6_2.heavy_stagger_immune_time and not (arg_6_3 > arg_6_2.heavy_stagger_immune_time)) then
		arg_6_2.heavy_stagger_immune_time = nil
	end

	if not flag then
		return "done"
	else
		return "running"
	end
end

BTDummyStaggerAction.anim_cb_push_cancel = function (arg_7_0, arg_7_1, arg_7_2)
	-- function 7
	if not (not arg_7_2.stagger_type and arg_7_2.stagger_type ~= 9) then
		Managers.state.network:anim_event(arg_7_1, "stagger_finished")

		arg_7_2.stagger_anim_done = true
	end
end
