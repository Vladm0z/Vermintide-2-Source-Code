-- chunkname: @scripts/entity_system/systems/behaviour/nodes/bt_jump_across_action.lua

require("scripts/entity_system/systems/behaviour/nodes/bt_node")

local function var_0_0()
	local var_1_0 = Managers.state.debug.graph_drawer:graph("BTJumpAcrossAction")

	if var_1_0 == nil then
		var_1_0 = Managers.state.debug.graph_drawer:create_graph("BTJumpAcrossAction", {
			"time",
			"unit altitude"
		})
	end

	return var_1_0
end

local function var_0_1(arg_2_0)
	if type(arg_2_0) == "table" then
		return arg_2_0[Math.random(1, #arg_2_0)]
	else
		return arg_2_0
	end
end

BTJumpAcrossAction = class(BTJumpAcrossAction, BTNode)

BTJumpAcrossAction.init = function (arg_3_0, ...)
	BTJumpAcrossAction.super.init(arg_3_0, ...)
end

BTJumpAcrossAction.name = "BTJumpAcrossAction"

BTJumpAcrossAction.enter = function (arg_4_0, arg_4_1, arg_4_2, arg_4_3)
	Managers.state.debug:drawer({
		mode = "retained",
		name = "BTJumpAcrossAction"
	}):reset()

	local var_4_0 = arg_4_2.next_smart_object_data
	local var_4_1 = var_4_0.entrance_pos:unbox()
	local var_4_2 = var_4_0.exit_pos:unbox()

	arg_4_2.jump_entrance_pos = Vector3Box(var_4_1)
	arg_4_2.jump_exit_pos = Vector3Box(var_4_2)
	arg_4_2.jump_ledge_lookat_direction = Vector3Box(Vector3.normalize(Vector3.flat(var_4_2 - var_4_1)))

	local var_4_3 = arg_4_2.locomotion_extension

	var_4_3:set_affected_by_gravity(false)
	var_4_3:set_movement_type("snap_to_navmesh")
	var_4_3:set_rotation_speed(10)

	arg_4_2.jump_state = "moving_to_ledge"

	if script_data.ai_debug_smartobject then
		Unit.set_animation_logging(arg_4_1, true)

		local var_4_4 = POSITION_LOOKUP[arg_4_1]

		var_0_0():reset()
		var_0_0():set_active(true)
		var_0_0():add_annotation({
			color = "green",
			x = arg_4_3,
			y = var_4_4.z,
			text = "starting BTJumpAcrossAction" .. tostring(var_4_4)
		})
	else
		var_0_0():set_active(false)
	end
end

BTJumpAcrossAction.leave = function (arg_5_0, arg_5_1, arg_5_2, arg_5_3, arg_5_4, arg_5_5)
	arg_5_2.jump_spline_ground = nil
	arg_5_2.jump_spline_ledge = nil
	arg_5_2.jump_entrance_pos = nil
	arg_5_2.jump_state = nil
	arg_5_2.is_jumping = nil
	arg_5_2.jump_ledge_lookat_direction = nil
	arg_5_2.jump_entrance_pos = nil
	arg_5_2.jump_exit_pos = nil
	arg_5_2.is_smart_objecting = nil
	arg_5_2.jump_start_finished = nil

	if not arg_5_5 then
		LocomotionUtils.set_animation_driven_movement(arg_5_1, false, true)
		LocomotionUtils.set_animation_translation_scale(arg_5_1, Vector3(1, 1, 1))
		arg_5_2.locomotion_extension:set_movement_type("snap_to_navmesh")
	end

	local var_5_0 = arg_5_2.navigation_extension

	var_5_0:set_enabled(true)

	ScriptUnit.extension(arg_5_1, "hit_reaction_system").force_ragdoll_on_death = nil

	if var_5_0:is_using_smart_object() then
		local var_5_1 = var_5_0:use_smart_object(false)
	end
end

BTJumpAcrossAction.run = function (arg_6_0, arg_6_1, arg_6_2, arg_6_3, arg_6_4)
	local var_6_0 = arg_6_2.navigation_extension
	local var_6_1 = arg_6_2.locomotion_extension
	local var_6_2 = POSITION_LOOKUP[arg_6_1]
	local var_6_3 = arg_6_2.jump_entrance_pos:unbox()
	local var_6_4 = arg_6_2.jump_exit_pos:unbox()

	if script_data.ai_debug_smartobject then
		arg_6_0:_debug_draw_update(arg_6_1, arg_6_2, arg_6_3)
	end

	if arg_6_2.jump_state == "moving_to_ledge" and arg_6_2.is_in_smartobject_range then
		LocomotionUtils.set_animation_driven_movement(arg_6_1, false)
		var_6_1:set_wanted_velocity(Vector3.zero())
		var_6_1:set_movement_type("script_driven")
		var_6_0:set_enabled(false)

		if var_6_0:use_smart_object(true) then
			arg_6_2.is_smart_objecting = true
			arg_6_2.is_jumping = true
			arg_6_2.jump_state = "moving_towards_smartobject_entrance"
		else
			print("BTJumpAcrossAction - failing to use smart object")

			return "failed"
		end
	end

	if arg_6_2.jump_state == "moving_towards_smartobject_entrance" then
		local var_6_5 = var_6_3
		local var_6_6 = arg_6_2.jump_ledge_lookat_direction:unbox()
		local var_6_7 = Quaternion.look(var_6_6)
		local var_6_8 = var_6_5 - var_6_2
		local var_6_9 = Vector3.length(var_6_8)

		if var_6_9 > 0.1 then
			local var_6_10 = arg_6_2.breed.run_speed

			if var_6_9 < var_6_10 * arg_6_4 then
				var_6_10 = var_6_9 / arg_6_4
			end

			local var_6_11 = Vector3.normalize(var_6_8) * var_6_10

			var_6_1:set_wanted_velocity(var_6_11)
			var_6_1:set_wanted_rotation(var_6_7)

			if script_data.ai_debug_smartobject then
				local var_6_12 = Managers.state.debug:drawer({
					mode = "immediate",
					name = "BTJumpAcrossAction2"
				})

				var_6_12:vector(var_6_2 + Vector3.up() * 0.3, var_6_8)
				var_6_12:sphere(var_6_5, 0.3, Colors.get("blue"))
			end
		else
			var_6_1:teleport_to(var_6_5, var_6_7)
			LocomotionUtils.set_animation_driven_movement(arg_6_1, true)

			local var_6_13 = var_6_4 - var_6_3
			local var_6_14 = Vector3.length(Vector3.flat(var_6_13))
			local var_6_15 = SmartObjectSettings.templates[arg_6_2.breed.smart_object_template].jump_across_anim_thresholds

			for iter_6_0 = 1, #var_6_15 do
				local var_6_16 = var_6_15[iter_6_0]

				if var_6_14 < var_6_16.horizontal_threshold then
					Managers.state.network:anim_event(arg_6_1, var_0_1(var_6_16.animation_jump))

					local var_6_17 = var_6_14 / var_6_16.horizontal_length
					local var_6_18 = var_6_13.z
					local var_6_19 = 1 / ScriptUnit.extension(arg_6_1, "ai_system"):size_variation()

					LocomotionUtils.set_animation_translation_scale(arg_6_1, Vector3(var_6_17 * var_6_19, var_6_17 * var_6_19, var_6_18 * var_6_19))

					break
				end
			end

			ScriptUnit.extension(arg_6_1, "hit_reaction_system").force_ragdoll_on_death = true
			arg_6_2.jump_state = "waiting_to_reach_end"
		end
	end

	if arg_6_2.jump_state == "waiting_to_reach_end" and arg_6_2.jump_start_finished then
		var_6_0:set_navbot_position(var_6_4)
		var_6_1:teleport_to(var_6_4)
		Managers.state.network:anim_event(arg_6_1, "move_fwd")

		arg_6_2.spawn_to_running = true
		arg_6_2.jump_state = "done"
	end

	if arg_6_2.jump_state == "done" then
		arg_6_2.jump_state = "done_for_reals"
	elseif arg_6_2.jump_state == "done_for_reals" then
		arg_6_2.jump_state = "done_for_reals2"
	elseif arg_6_2.jump_state == "done_for_reals2" then
		return "done"
	end

	return "running"
end

BTJumpAcrossAction._debug_draw_update = function (arg_7_0, arg_7_1, arg_7_2, arg_7_3)
	local var_7_0 = Managers.state.debug:drawer({
		mode = "immediate",
		name = "BTJumpAcrossAction2"
	})
	local var_7_1 = POSITION_LOOKUP[arg_7_1]
	local var_7_2 = arg_7_2.jump_entrance_pos:unbox()
	local var_7_3 = arg_7_2.jump_exit_pos:unbox()

	Debug.text("BTJumpAcrossAction state=           %s", arg_7_2.jump_state)
	Debug.text("BTJumpAcrossAction entrance_pos=%s", tostring(var_7_2))
	Debug.text("BTJumpAcrossAction exit_pos=        %s", tostring(var_7_3))
	Debug.text("BTJumpAcrossAction pos=             %s", tostring(var_7_1))
	var_7_0:sphere(var_7_2, 0.3, Colors.get("yellow"))
	var_7_0:sphere(var_7_3, 0.3, Colors.get("red"))
	var_7_0:sphere(var_7_1, 0.3 + math.sin(arg_7_3 * 5) * 0.01, Colors.get("purple"))
	var_0_0():add_point(arg_7_3, var_7_1.z)
end
