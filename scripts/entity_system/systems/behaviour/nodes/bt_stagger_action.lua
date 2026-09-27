-- chunkname: @scripts/entity_system/systems/behaviour/nodes/bt_stagger_action.lua

require("scripts/entity_system/systems/behaviour/nodes/bt_node")

local scripts_utils_stagger_types = require("scripts/utils/stagger_types")

BTStaggerAction = class(BTStaggerAction, BTNode)

BTStaggerAction.init = function (arg_1_0, ...)
	-- function 1
	BTStaggerAction.super.init(arg_1_0, ...)
end

BTStaggerAction.name = "BTStaggerAction"

local num = 0.35

BTStaggerAction.enter = function (self, arg_2_1, arg_2_2, arg_2_3)
	-- function 2
	local locomotion_extension = arg_2_2.locomotion_extension

	arg_2_2.navigation_extension:set_enabled(false)

	local breed = arg_2_2.breed
	local staggering_id = arg_2_2.staggering_id

	staggering_id = not staggering_id and arg_2_2.stagger ~= arg_2_2.staggering_id

	if not staggering_id then
		local override_mover_move_distance = breed.override_mover_move_distance

		locomotion_extension:set_movement_type("constrained_by_mover", override_mover_move_distance, true)
	end

	arg_2_2.stagger_anim_done = false
	arg_2_2.stagger_hit_wall = nil
	arg_2_2.stagger_ignore_anim_cb = nil
	arg_2_2.staggering_id = arg_2_2.stagger
	arg_2_2.attack_aborted = true
	arg_2_2.move_state = "stagger"
	arg_2_2.active_node = BTStaggerAction

	local action_data = self._tree_node.action_data

	arg_2_2.action = action_data

	ScriptUnit.extension(arg_2_1, "ai_system"):increase_stagger_count()

	local var_2_5
	local var_2_6
	local var_2_7
	local var_2_8
	local custom_enter_function = action_data.custom_enter_function

	if not custom_enter_function then
		local var_2_10

		var_2_5, var_2_6, var_2_10, var_2_8 = custom_enter_function(arg_2_1, arg_2_2, arg_2_3, action_data)

		if not var_2_10 then
			arg_2_2.post_stagger_event = var_2_10
		end
	else
		var_2_6 = "idle"
		var_2_5 = action_data.stagger_anims[arg_2_2.stagger_type]
	end

	if not (not action_data.custom_weakspot_function and arg_2_2.stagger_type ~= scripts_utils_stagger_types.weakspot) then
		action_data.custom_weakspot_function(arg_2_1, arg_2_2, arg_2_3, action_data)
	end

	local unbox = arg_2_2.stagger_direction:unbox()
	local _select_animation, var_2_13 = self:_select_animation(arg_2_1, arg_2_2, unbox, var_2_5)

	Unit.set_local_rotation(arg_2_1, 0, var_2_8 or var_2_13)

	local network = Managers.state.network

	if not action_data.scale_animation_speeds then
		local stagger_animation_scale = action_data.stagger_animation_scale

		if not stagger_animation_scale then
			stagger_animation_scale = arg_2_2.stagger_animation_scale
			stagger_animation_scale = stagger_animation_scale or 1
		end

		network:anim_event_with_variable_float(arg_2_1, _select_animation, "stagger_scale", stagger_animation_scale)
	else
		network:anim_event(arg_2_1, _select_animation)
	end

	network:anim_event(arg_2_1, var_2_6)

	local stagger_length = arg_2_2.stagger_length

	LocomotionUtils.set_animation_translation_scale(arg_2_1, Vector3(stagger_length, stagger_length, stagger_length))

	if not staggering_id then
		local unit_game_object_id = network:unit_game_object_id(arg_2_1)
		local var_2_18 = POSITION_LOOKUP[arg_2_1]
		local yaw = Quaternion.yaw(var_2_13)

		network.network_transmit:send_rpc_clients("rpc_teleport_unit_with_yaw_rotation", unit_game_object_id, var_2_18, yaw)
	else
		LocomotionUtils.set_animation_driven_movement(arg_2_1, true, true, false)
	end

	if not (arg_2_2.stagger_type == scripts_utils_stagger_types.heavy or arg_2_2.stagger_type ~= scripts_utils_stagger_types.explosion) then
		ScriptUnit.extension(arg_2_1, "hit_reaction_system").force_ragdoll_on_death = true
	end

	locomotion_extension:set_rotation_speed(100)
	locomotion_extension:set_wanted_velocity(Vector3.zero())
	locomotion_extension:use_lerp_rotation(false)

	arg_2_2.spawn_to_running = nil

	local system = Managers.state.entity:system("ai_slot_system")

	system:do_slot_search(arg_2_1, false)
	system:ai_unit_staggered(arg_2_1)
end

BTStaggerAction._select_animation = function (arg_3_0, arg_3_1, arg_3_2, arg_3_3, arg_3_4)
	-- function 3
	local normalize = Vector3.normalize(arg_3_3)
	local forward = Quaternion.forward(Unit.local_rotation(arg_3_1, 0))
	local dot = Vector3.dot(forward, normalize)
	local clamp = math.clamp(dot, -1, 1)
	local acos = math.acos(clamp)
	local action = arg_3_2.action
	local current_velocity = arg_3_2.locomotion_extension:current_velocity()
	local var_3_7
	local var_3_8
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
		var_3_7 = Quaternion.look(-normalize)
		var_3_8 = not flag_3 and arg_3_4.moving_dwn and arg_3_4.dwn
	else
		normalize.z = 0

		if acos > math.pi * 0.75 then
			var_3_7 = Quaternion.look(-normalize)
			var_3_8 = not flag_3 and arg_3_4.moving_bwd and arg_3_4.bwd
		elseif acos < math.pi * 0.25 then
			var_3_7 = Quaternion.look(normalize)
			var_3_8 = not flag_3 and arg_3_4.moving_fwd and arg_3_4.fwd
		elseif Vector3.cross(forward, normalize).z > 0 then
			local cross = Vector3.cross(Vector3(0, 0, -1), normalize)

			var_3_7 = Quaternion.look(cross)
			var_3_8 = not flag_3 and arg_3_4.moving_left and arg_3_4.left
		else
			local cross_2 = Vector3.cross(Vector3(0, 0, 1), normalize)

			var_3_7 = Quaternion.look(cross_2)
			var_3_8 = not flag_3 and arg_3_4.moving_right and arg_3_4.right
		end
	end

	local count = #var_3_8
	local random = Math.random(1, count)
	local var_3_19 = var_3_8[random]

	if var_3_19 == arg_3_2.last_stagger_anim then
		var_3_19 = var_3_8[random % count + 1]
	end

	arg_3_2.last_stagger_anim = var_3_19

	local yaw = Quaternion.yaw(var_3_7)
	local var_3_21 = Quaternion(Vector3.up(), yaw)

	return var_3_19, var_3_21
end

BTStaggerAction.clean_blackboard = function (arg_4_0, arg_4_1)
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
	arg_4_1.stagger_activated = nil
end

BTStaggerAction.leave = function (self, arg_5_1, arg_5_2, arg_5_3, arg_5_4, arg_5_5)
	-- function 5
	if not arg_5_5 then
		LocomotionUtils.set_animation_driven_movement(arg_5_1, false, false)
	end

	if not (not ScriptUnit.has_extension(arg_5_1, "ai_shield_system") and arg_5_2.action.ignore_block_on_leave) then
		ScriptUnit.extension(arg_5_1, "ai_shield_system"):set_is_blocking(true)
	end

	self:clean_blackboard(arg_5_2)

	if not arg_5_5 then
		local locomotion_extension = arg_5_2.locomotion_extension

		locomotion_extension:set_rotation_speed(10)
		locomotion_extension:set_wanted_rotation(nil)
		locomotion_extension:set_movement_type("snap_to_navmesh")
		locomotion_extension:use_lerp_rotation(true)
		locomotion_extension:set_wanted_velocity(Vector3.zero())
		LocomotionUtils.set_animation_translation_scale(arg_5_1, Vector3(1, 1, 1))

		local network = Managers.state.network
		local var_5_2

		if not arg_5_2.post_stagger_event then
			var_5_2 = arg_5_2.post_stagger_event
			arg_5_2.post_stagger_event = nil
		else
			var_5_2 = "stagger_finished"
		end

		network:anim_event(arg_5_1, var_5_2)
	end

	arg_5_2.navigation_extension:set_enabled(true)

	local run_on_stagger_action_done = arg_5_2.breed.run_on_stagger_action_done

	if not run_on_stagger_action_done then
		run_on_stagger_action_done(arg_5_1, arg_5_2, arg_5_3)
	end

	ScriptUnit.has_extension(arg_5_1, "hit_reaction_system").force_ragdoll_on_death = nil

	Managers.state.entity:system("ai_slot_system"):do_slot_search(arg_5_1, true)
end

BTStaggerAction.run = function (self, arg_6_1, arg_6_2, arg_6_3, arg_6_4)
	-- function 6
	if arg_6_2.stagger ~= arg_6_2.staggering_id then
		self:enter(arg_6_1, arg_6_2, arg_6_3)
	end

	local locomotion_extension = arg_6_2.locomotion_extension
	local stagger_anim_done = arg_6_2.stagger_anim_done

	if not (locomotion_extension.movement_type == "constrained_by_mover" or arg_6_2.stagger_hit_wall) then
		local var_6_2 = POSITION_LOOKUP[arg_6_1]
		local current_velocity = locomotion_extension:current_velocity()
		local nav_world = arg_6_2.nav_world
		local world = arg_6_2.world
		local physics_world = World.physics_world(world)
		local traverse_logic = arg_6_2.navigation_extension:traverse_logic()
		local navmesh_movement_check = LocomotionUtils.navmesh_movement_check(var_6_2, current_velocity, nav_world, physics_world, traverse_logic)

		if navmesh_movement_check == "navmesh_hit_wall" then
			arg_6_2.stagger_hit_wall = true
		elseif navmesh_movement_check == "navmesh_use_mover" then
			local override_mover_move_distance = arg_6_2.breed.override_mover_move_distance
			local flag = true

			if not locomotion_extension:set_movement_type("constrained_by_mover", override_mover_move_distance, flag) then
				locomotion_extension:set_movement_type("snap_to_navmesh")

				arg_6_2.stagger_hit_wall = true
			end
		end
	end

	local flag_2 = arg_6_3 > arg_6_2.stagger_time
	local stagger_ignore_anim_cb = arg_6_2.stagger_ignore_anim_cb

	if not (not arg_6_2.stagger_immune_time and not (arg_6_3 > arg_6_2.stagger_immune_time)) then
		arg_6_2.stagger_immune_time = nil
	end

	if not (not arg_6_2.heavy_stagger_immune_time and not (arg_6_3 > arg_6_2.heavy_stagger_immune_time)) then
		arg_6_2.heavy_stagger_immune_time = nil
	end

	if not flag_2 and stagger_ignore_anim_cb and not stagger_anim_done then
		return "done"
	else
		return "running"
	end
end

BTStaggerAction.anim_cb_push_cancel = function (arg_7_0, arg_7_1, arg_7_2)
	-- function 7
	if not (not arg_7_2.stagger_type and arg_7_2.stagger_type ~= 9) then
		Managers.state.network:anim_event(arg_7_1, "stagger_finished")

		arg_7_2.stagger_anim_done = true
	end
end
