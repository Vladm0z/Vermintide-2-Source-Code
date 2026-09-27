-- chunkname: @scripts/entity_system/systems/behaviour/nodes/bt_vortex_wander_action.lua

require("scripts/entity_system/systems/behaviour/nodes/bt_node")

BTVortexWanderAction = class(BTVortexWanderAction, BTNode)

local POSITION_LOOKUP = POSITION_LOOKUP

BTVortexWanderAction.init = function (arg_1_0, ...)
	-- function 1
	BTVortexWanderAction.super.init(arg_1_0, ...)
end

BTVortexWanderAction.name = "BTVortexWanderAction"

BTVortexWanderAction.enter = function (self, arg_2_1, arg_2_2, arg_2_3)
	-- function 2
	arg_2_2.action = self._tree_node.action_data
end

BTVortexWanderAction.leave = function (arg_3_0, arg_3_1, arg_3_2, arg_3_3, arg_3_4, arg_3_5)
	-- function 3
	return
end

BTVortexWanderAction.run = function (self, arg_4_1, arg_4_2, arg_4_3, arg_4_4)
	-- function 4
	local vortex_data = arg_4_2.vortex_data

	self:_wander_around(arg_4_1, arg_4_3, arg_4_4, arg_4_2, vortex_data)

	return "running"
end

BTVortexWanderAction._wander_around = function (arg_5_0, arg_5_1, arg_5_2, arg_5_3, arg_5_4, arg_5_5)
	-- function 5
	local action = arg_5_4.action
	local wander_state = arg_5_5.wander_state
	local vortex_template = arg_5_5.vortex_template
	local num_players_inside = arg_5_5.num_players_inside
	local navigation_extension = arg_5_4.navigation_extension
	local is_following_path = navigation_extension:is_following_path()
	local flag

	flag = not is_following_path and "moving" and "idle"
	arg_5_4.move_state = flag

	if not (not vortex_template.stop_and_process_player and not (num_players_inside > 0) or wander_state == "standing_still" or wander_state == "forced_standing_still") then
		arg_5_5.wander_state = "standing_still"

		navigation_extension:stop()
	elseif not (num_players_inside ~= 0 or arg_5_5.wander_state ~= "standing_still") then
		arg_5_5.wander_state = "recalc_path"
	end

	if wander_state == "wandering" then
		if not (navigation_extension:has_reached_destination(0.5) or not (arg_5_2 > arg_5_5.wander_time)) then
			arg_5_5.wander_state = "recalc_path"
		end
	elseif wander_state == "calculating_path" then
		local is_computing_path = navigation_extension:is_computing_path()
		local flag_2 = not arg_5_4.no_path_found

		if not (is_computing_path or is_following_path or flag_2) then
			if not flag_2 then
				arg_5_5.wander_state = "wandering"
				arg_5_5.wander_time = arg_5_2 + 1
			else
				arg_5_5.wander_state = "no_path_found"
				arg_5_5.idle_time = arg_5_2 + 2 + math.random()
			end
		end
	elseif wander_state == "recalc_path" then
		local nav_world = arg_5_4.nav_world
		local target_unit = arg_5_4.target_unit
		local var_5_11 = POSITION_LOOKUP[arg_5_1]
		local random_wander = vortex_template.random_wander

		random_wander = random_wander or not target_unit

		local directed_wander_position_boxed = arg_5_4.directed_wander_position_boxed

		directed_wander_position_boxed = not directed_wander_position_boxed and arg_5_4.directed_wander_position_boxed:unbox()

		if not directed_wander_position_boxed then
			navigation_extension:move_to(directed_wander_position_boxed)

			arg_5_5.wander_state = "calculating_path"
		elseif not random_wander then
			local get_spawn_pos_on_circle = ConflictUtils.get_spawn_pos_on_circle(nav_world, var_5_11, 5, 10, 7)

			if not get_spawn_pos_on_circle then
				navigation_extension:move_to(get_spawn_pos_on_circle)

				arg_5_5.wander_state = "calculating_path"
			else
				arg_5_5.idle_time = arg_5_2 + math.random() * 0.5
				arg_5_5.wander_state = "no_path_found"
			end
		elseif not Unit.alive(target_unit) then
			local var_5_15 = POSITION_LOOKUP[target_unit]
			local pos_on_mesh = LocomotionUtils.pos_on_mesh(nav_world, var_5_15, 1, 2)

			if not pos_on_mesh then
				if Vector3.length_squared(pos_on_mesh - var_5_11) > 0.25 then
					navigation_extension:move_to(pos_on_mesh)

					arg_5_5.wander_state = "calculating_path"
				end
			else
				arg_5_5.idle_time = arg_5_2 + math.random() * 0.5
				arg_5_5.wander_state = "no_path_found"
			end
		else
			arg_5_5.idle_time = arg_5_2 + 2 + math.random()
			arg_5_5.wander_state = "no_path_found"
		end
	elseif wander_state == "no_path_found" then
		if arg_5_2 > arg_5_5.idle_time then
			arg_5_5.wander_state = "recalc_path"
		end
	elseif not (wander_state == "standing_still" or wander_state ~= "forced_standing_still") then
		-- Nothing
	end
end
