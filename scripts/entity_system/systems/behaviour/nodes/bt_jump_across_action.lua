-- chunkname: @scripts/entity_system/systems/behaviour/nodes/bt_jump_across_action.lua

require("scripts/entity_system/systems/behaviour/nodes/bt_node")

local function fn()
	-- function 1
	local graph = Managers.state.debug.graph_drawer:graph("BTJumpAcrossAction")

	if graph == nil then
		graph = Managers.state.debug.graph_drawer:create_graph("BTJumpAcrossAction", {
			"time",
			"unit altitude"
		})
	end

	return graph
end

local function fn_2(self)
	-- function 2
	if type(self) == "table" then
		return self[Math.random(1, #self)]
	else
		return self
	end
end

BTJumpAcrossAction = class(BTJumpAcrossAction, BTNode)

BTJumpAcrossAction.init = function (arg_3_0, ...)
	-- function 3
	BTJumpAcrossAction.super.init(arg_3_0, ...)
end

BTJumpAcrossAction.name = "BTJumpAcrossAction"

BTJumpAcrossAction.enter = function (arg_4_0, arg_4_1, arg_4_2, arg_4_3)
	-- function 4
	Managers.state.debug:drawer({
		mode = "retained",
		name = "BTJumpAcrossAction"
	}):reset()

	local next_smart_object_data = arg_4_2.next_smart_object_data
	local unbox = next_smart_object_data.entrance_pos:unbox()
	local unbox_2 = next_smart_object_data.exit_pos:unbox()

	arg_4_2.jump_entrance_pos = Vector3Box(unbox)
	arg_4_2.jump_exit_pos = Vector3Box(unbox_2)
	arg_4_2.jump_ledge_lookat_direction = Vector3Box(Vector3.normalize(Vector3.flat(unbox_2 - unbox)))

	local locomotion_extension = arg_4_2.locomotion_extension

	locomotion_extension:set_affected_by_gravity(false)
	locomotion_extension:set_movement_type("snap_to_navmesh")
	locomotion_extension:set_rotation_speed(10)

	arg_4_2.jump_state = "moving_to_ledge"

	if not script_data.ai_debug_smartobject then
		Unit.set_animation_logging(arg_4_1, true)

		local var_4_4 = POSITION_LOOKUP[arg_4_1]

		fn():reset()
		fn():set_active(true)
		fn():add_annotation({
			color = "green",
			x = arg_4_3,
			y = var_4_4.z,
			text = "starting BTJumpAcrossAction" .. tostring(var_4_4)
		})
	else
		fn():set_active(false)
	end
end

BTJumpAcrossAction.leave = function (arg_5_0, arg_5_1, arg_5_2, arg_5_3, arg_5_4, arg_5_5)
	-- function 5
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

	local navigation_extension = arg_5_2.navigation_extension

	navigation_extension:set_enabled(true)

	ScriptUnit.extension(arg_5_1, "hit_reaction_system").force_ragdoll_on_death = nil

	if not navigation_extension:is_using_smart_object() then
		local use_smart_object = navigation_extension:use_smart_object(false)
	end
end

BTJumpAcrossAction.run = function (self, arg_6_1, arg_6_2, arg_6_3, arg_6_4)
	-- function 6
	local navigation_extension = arg_6_2.navigation_extension
	local locomotion_extension = arg_6_2.locomotion_extension
	local var_6_2 = POSITION_LOOKUP[arg_6_1]
	local unbox = arg_6_2.jump_entrance_pos:unbox()
	local unbox_2 = arg_6_2.jump_exit_pos:unbox()

	if not script_data.ai_debug_smartobject then
		self:_debug_draw_update(arg_6_1, arg_6_2, arg_6_3)
	end

	if arg_6_2.jump_state ~= "moving_to_ledge" or not arg_6_2.is_in_smartobject_range then
		LocomotionUtils.set_animation_driven_movement(arg_6_1, false)
		locomotion_extension:set_wanted_velocity(Vector3.zero())
		locomotion_extension:set_movement_type("script_driven")
		navigation_extension:set_enabled(false)

		if not navigation_extension:use_smart_object(true) then
			arg_6_2.is_smart_objecting = true
			arg_6_2.is_jumping = true
			arg_6_2.jump_state = "moving_towards_smartobject_entrance"
		else
			print("BTJumpAcrossAction - failing to use smart object")

			return "failed"
		end
	end

	if arg_6_2.jump_state == "moving_towards_smartobject_entrance" then
		local var_6_5 = unbox
		local unbox_3 = arg_6_2.jump_ledge_lookat_direction:unbox()
		local look = Quaternion.look(unbox_3)
		local num = var_6_5 - var_6_2
		local length = Vector3.length(num)

		if length > 0.1 then
			local run_speed = arg_6_2.breed.run_speed

			if length < run_speed * arg_6_4 then
				run_speed = length / arg_6_4
			end

			local num_2 = Vector3.normalize(num) * run_speed

			locomotion_extension:set_wanted_velocity(num_2)
			locomotion_extension:set_wanted_rotation(look)

			if not script_data.ai_debug_smartobject then
				local drawer = Managers.state.debug:drawer({
					mode = "immediate",
					name = "BTJumpAcrossAction2"
				})

				drawer:vector(var_6_2 + Vector3.up() * 0.3, num)
				drawer:sphere(var_6_5, 0.3, Colors.get("blue"))
			end
		else
			locomotion_extension:teleport_to(var_6_5, look)
			LocomotionUtils.set_animation_driven_movement(arg_6_1, true)

			local num_3 = unbox_2 - unbox
			local length_2 = Vector3.length(Vector3.flat(num_3))
			local jump_across_anim_thresholds = SmartObjectSettings.templates[arg_6_2.breed.smart_object_template].jump_across_anim_thresholds

			for i = 1, #jump_across_anim_thresholds do
				local var_6_16 = jump_across_anim_thresholds[i]

				if length_2 < var_6_16.horizontal_threshold then
					Managers.state.network:anim_event(arg_6_1, fn_2(var_6_16.animation_jump))

					local num_4 = length_2 / var_6_16.horizontal_length
					local z = num_3.z
					local num_5 = 1 / ScriptUnit.extension(arg_6_1, "ai_system"):size_variation()

					LocomotionUtils.set_animation_translation_scale(arg_6_1, Vector3(num_4 * num_5, num_4 * num_5, z * num_5))

					break
				end
			end

			ScriptUnit.extension(arg_6_1, "hit_reaction_system").force_ragdoll_on_death = true
			arg_6_2.jump_state = "waiting_to_reach_end"
		end
	end

	if arg_6_2.jump_state ~= "waiting_to_reach_end" or not arg_6_2.jump_start_finished then
		navigation_extension:set_navbot_position(unbox_2)
		locomotion_extension:teleport_to(unbox_2)
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
	-- function 7
	local drawer = Managers.state.debug:drawer({
		mode = "immediate",
		name = "BTJumpAcrossAction2"
	})
	local var_7_1 = POSITION_LOOKUP[arg_7_1]
	local unbox = arg_7_2.jump_entrance_pos:unbox()
	local unbox_2 = arg_7_2.jump_exit_pos:unbox()

	Debug.text("BTJumpAcrossAction state=           %s", arg_7_2.jump_state)
	Debug.text("BTJumpAcrossAction entrance_pos=%s", tostring(unbox))
	Debug.text("BTJumpAcrossAction exit_pos=        %s", tostring(unbox_2))
	Debug.text("BTJumpAcrossAction pos=             %s", tostring(var_7_1))
	drawer:sphere(unbox, 0.3, Colors.get("yellow"))
	drawer:sphere(unbox_2, 0.3, Colors.get("red"))
	drawer:sphere(var_7_1, 0.3 + math.sin(arg_7_3 * 5) * 0.01, Colors.get("purple"))
	fn():add_point(arg_7_3, var_7_1.z)
end
