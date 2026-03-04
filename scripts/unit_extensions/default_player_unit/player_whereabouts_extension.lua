-- chunkname: @scripts/unit_extensions/default_player_unit/player_whereabouts_extension.lua

require("scripts/unit_extensions/generic/generic_state_machine")

PlayerWhereaboutsExtension = class(PlayerWhereaboutsExtension)

local var_0_0 = POSITION_LOOKUP

PlayerWhereaboutsExtension.init = function (arg_1_0, arg_1_1, arg_1_2, arg_1_3)
	arg_1_0.unit = arg_1_2
	arg_1_0._nav_world = Managers.state.entity:system("ai_system"):nav_world()
	arg_1_0._player = arg_1_3.player
	arg_1_0.closest_positions = {}
	arg_1_0._input = {}

	arg_1_0:_setup(arg_1_0._nav_world, arg_1_2)

	arg_1_0._last_onground_pos_on_nav_mesh = Vector3Box(Vector3.invalid_vector())
	arg_1_0._jumping = false
	arg_1_0._falling = false
	arg_1_0._nav_traverse_logic = Managers.state.bot_nav_transition:traverse_logic()
	arg_1_0._jump_position = Vector3Box(Vector3.invalid_vector())
	arg_1_0._fall_position = Vector3Box(Vector3.invalid_vector())
	arg_1_0._free_fall_position = Vector3Box(Vector3.invalid_vector())
end

PlayerWhereaboutsExtension._setup = function (arg_2_0, arg_2_1, arg_2_2)
	local var_2_0 = var_0_0[arg_2_2]

	if not LevelHelper:current_level_settings().no_bots_allowed then
		local var_2_1, var_2_2 = GwNavQueries.triangle_from_position(arg_2_1, var_2_0)

		arg_2_0._last_pos_on_nav_mesh = Vector3Box(var_2_0.x, var_2_0.y, var_2_2 or var_2_0.z)
	else
		arg_2_0._last_pos_on_nav_mesh = Vector3Box(Vector3.invalid_vector())
	end
end

PlayerWhereaboutsExtension.destroy = function (arg_3_0)
	return
end

PlayerWhereaboutsExtension.set_is_onground = function (arg_4_0)
	arg_4_0._input.is_onground = true
end

PlayerWhereaboutsExtension.set_fell = function (arg_5_0, arg_5_1)
	arg_5_0._input.fell = true
	arg_5_0._input.player_state = arg_5_1
end

PlayerWhereaboutsExtension.set_jumped = function (arg_6_0)
	arg_6_0._input.jumped = true
end

PlayerWhereaboutsExtension.set_landed = function (arg_7_0)
	arg_7_0._input.landed = true
end

PlayerWhereaboutsExtension.set_no_landing = function (arg_8_0)
	arg_8_0._input.no_landing = true
end

PlayerWhereaboutsExtension.update = function (arg_9_0, arg_9_1, arg_9_2, arg_9_3, arg_9_4, arg_9_5)
	local var_9_0 = var_0_0[arg_9_1]
	local var_9_1 = arg_9_0._input

	arg_9_0:_get_closest_positions(var_9_0, var_9_1.is_onground, arg_9_0.closest_positions)

	local var_9_2 = arg_9_0._nav_world
	local var_9_3 = arg_9_0:last_position_on_navmesh()

	if var_9_3 and not arg_9_0.player_on_nav_mesh and not GwNavQueries.triangle_from_position(var_9_2, var_9_3, 0.2, 0.3) then
		arg_9_0._last_pos_on_nav_mesh:store(Vector3.invalid_vector())
	end

	local var_9_4 = arg_9_0:last_position_onground_on_navmesh()

	if var_9_4 and (not arg_9_0.player_on_nav_mesh or not var_9_1.is_onground) and not GwNavQueries.triangle_from_position(var_9_2, var_9_4, 0.2, 0.3) then
		arg_9_0._last_onground_pos_on_nav_mesh:store(Vector3.invalid_vector())
	end

	if not arg_9_0._player.remote then
		arg_9_0:_check_bot_nav_transition(var_9_2, var_9_1, var_9_0)
	end

	if arg_9_0.hang_ledge_position then
		arg_9_0:_calculate_hang_ledge_spawn_position(arg_9_0.hang_ledge_position:unbox())

		arg_9_0.hang_ledge_position = nil
	end

	table.clear(var_9_1)
end

PlayerWhereaboutsExtension.last_position_on_navmesh = function (arg_10_0)
	local var_10_0 = arg_10_0._last_pos_on_nav_mesh:unbox()

	return Vector3.is_valid(var_10_0) and var_10_0 or nil
end

PlayerWhereaboutsExtension.last_position_onground_on_navmesh = function (arg_11_0)
	local var_11_0 = arg_11_0._last_onground_pos_on_nav_mesh:unbox()

	return Vector3.is_valid(var_11_0) and var_11_0 or nil
end

local var_0_1 = 0.0001

PlayerWhereaboutsExtension._find_start_position = function (arg_12_0, arg_12_1, arg_12_2)
	local var_12_0 = arg_12_0._last_onground_pos_on_nav_mesh:unbox()

	if Vector3.is_valid(var_12_0) then
		local var_12_1 = arg_12_1 - var_12_0

		if Vector3.length_squared(var_12_1) > var_0_1 then
			local var_12_2 = GwNavQueries.move_on_navmesh(arg_12_0._nav_world, var_12_0, var_12_1, 1, arg_12_0._nav_traverse_logic)

			if not arg_12_2 or Vector3.distance_squared(arg_12_1, var_12_2) < 4 then
				return var_12_2
			end
		else
			return var_12_0
		end
	end
end

PlayerWhereaboutsExtension._check_bot_nav_transition = function (arg_13_0, arg_13_1, arg_13_2, arg_13_3)
	if arg_13_2.jumped then
		fassert(not arg_13_0._falling and not arg_13_0._jumping, "Tried to jump or fall while falling without aborting landing")

		arg_13_0._jumping = true

		local var_13_0 = arg_13_2.player_state == nil or arg_13_2.player_state ~= "lunging" and arg_13_2.player_state ~= "leaping"
		local var_13_1 = arg_13_0:_find_start_position(arg_13_3, var_13_0)

		if var_13_1 then
			arg_13_0._jump_position:store(var_13_1)
			arg_13_0._free_fall_position:store(arg_13_3)
		end
	elseif arg_13_2.fell then
		fassert(not arg_13_0._jumping and not arg_13_0._falling, "Tried to fall or jump while jumping without aborting landing")

		arg_13_0._falling = true

		local var_13_2 = arg_13_2.player_state == nil or arg_13_2.player_state ~= "lunging" and arg_13_2.player_state ~= "leaping"
		local var_13_3 = arg_13_0:_find_start_position(arg_13_3, var_13_2)

		if var_13_3 then
			arg_13_0._fall_position:store(var_13_3)
			arg_13_0._free_fall_position:store(arg_13_3)
		end
	end

	if arg_13_2.no_landing then
		fassert(arg_13_0._jumping or arg_13_0._falling, "Tried to not land without falling or jumping")

		arg_13_0._jumping = false
		arg_13_0._falling = false

		local var_13_4 = Vector3.invalid_vector()

		arg_13_0._jump_position:store(var_13_4)
		arg_13_0._fall_position:store(var_13_4)
		arg_13_0._free_fall_position:store(var_13_4)
	elseif arg_13_2.landed then
		fassert(arg_13_0._jumping or arg_13_0._falling, "Tried to land without falling or jumping")

		if arg_13_0._jumping then
			local var_13_5 = arg_13_0._jump_position:unbox()

			if Vector3.is_valid(var_13_5) then
				Managers.state.bot_nav_transition:create_transition(var_13_5, arg_13_0._free_fall_position:unbox(), arg_13_3, true)
			end

			local var_13_6 = Vector3.invalid_vector()

			arg_13_0._jump_position:store(var_13_6)
			arg_13_0._free_fall_position:store(var_13_6)

			arg_13_0._jumping = false
		elseif arg_13_0._falling then
			local var_13_7 = arg_13_0._fall_position:unbox()

			if Vector3.is_valid(var_13_7) then
				Managers.state.bot_nav_transition:create_transition(var_13_7, arg_13_0._free_fall_position:unbox(), arg_13_3, false)
			end

			local var_13_8 = Vector3.invalid_vector()

			arg_13_0._fall_position:store(var_13_8)
			arg_13_0._free_fall_position:store(var_13_8)

			arg_13_0._falling = false
		end
	end
end

PlayerWhereaboutsExtension._get_closest_positions = function (arg_14_0, arg_14_1, arg_14_2, arg_14_3)
	local var_14_0 = arg_14_0._nav_world

	arg_14_0.player_on_nav_mesh = GwNavQueries.triangle_from_position(var_14_0, arg_14_1, 0.2, 0.3)

	if arg_14_0.player_on_nav_mesh then
		arg_14_0._last_pos_on_nav_mesh:store(arg_14_1)

		if arg_14_2 then
			arg_14_0._last_onground_pos_on_nav_mesh:store(arg_14_1)
		end

		return
	end

	local var_14_1 = GwNavQueries.inside_position_from_outside_position(var_14_0, arg_14_1, 3, 3, 2.1, 0.5)

	if var_14_1 then
		arg_14_3[1] = Vector3Box(var_14_1)

		for iter_14_0 = 2, #arg_14_3 do
			arg_14_3[iter_14_0] = nil
		end

		return
	end

	local var_14_2 = GwNavQueries.inside_position_from_outside_position(var_14_0, arg_14_1, 5, 5, 10, 0.5)

	if var_14_2 then
		arg_14_3[1] = Vector3Box(var_14_2)

		for iter_14_1 = 2, #arg_14_3 do
			arg_14_3[iter_14_1] = nil
		end

		return
	end

	local var_14_3 = #arg_14_3

	for iter_14_2 = 1, var_14_3 do
		arg_14_3[iter_14_2] = nil
	end

	LocomotionUtils.closest_mesh_positions_outward(var_14_0, arg_14_1, 10, arg_14_3)
end

PlayerWhereaboutsExtension.closest_positions_when_outside_navmesh = function (arg_15_0)
	return arg_15_0.closest_positions, arg_15_0.player_on_nav_mesh
end

PlayerWhereaboutsExtension.set_new_hang_ledge_position = function (arg_16_0, arg_16_1)
	arg_16_0.hang_ledge_position = Vector3Box(arg_16_1)
end

PlayerWhereaboutsExtension._calculate_hang_ledge_spawn_position = function (arg_17_0, arg_17_1)
	local var_17_0 = arg_17_0._nav_world
	local var_17_1 = GwNavQueries.inside_position_from_outside_position(var_17_0, arg_17_1, 5, 5, 10, 0.25)

	if var_17_1 then
		arg_17_0.hang_ledge_spawn_position = Vector3Box(var_17_1)
	else
		print("Could not find spawn position for hang ledge.")

		arg_17_0.hang_ledge_spawn_position = Vector3Box(arg_17_1)
	end
end

PlayerWhereaboutsExtension.get_hang_ledge_spawn_position = function (arg_18_0)
	return arg_18_0.hang_ledge_spawn_position:unbox()
end

PlayerWhereaboutsExtension._debug_draw = function (arg_19_0, arg_19_1, arg_19_2, arg_19_3)
	local var_19_0 = arg_19_0._last_onground_pos_on_nav_mesh:unbox()
	local var_19_1 = math.abs(math.cos(arg_19_3))
	local var_19_2 = math.abs(math.cos(2 * arg_19_3))
	local var_19_3 = math.abs(math.sin(arg_19_3))

	if Vector3.is_valid(var_19_0) then
		local var_19_4 = Color(var_19_1 * 255, var_19_3 * 255, var_19_1 * 255)

		QuickDrawer:sphere(var_19_0, 0.25, var_19_4)
		QuickDrawer:line(arg_19_1, var_19_0, var_19_4)
		QuickDrawer:sphere(arg_19_1, var_19_2 * 0.2 + 0.05, var_19_4)
	end

	local var_19_5 = arg_19_0._last_pos_on_nav_mesh:unbox()

	if Vector3.is_valid(var_19_5) then
		local var_19_6 = Color(0, var_19_3 * 125, var_19_1 * 125)

		QuickDrawer:sphere(var_19_5, 0.1, var_19_6)
		QuickDrawer:line(arg_19_1, var_19_5, var_19_6)
		QuickDrawer:sphere(arg_19_1, var_19_2 * 0.05 + 0.05, var_19_6)
	end

	for iter_19_0 = 1, #arg_19_2 do
		local var_19_7 = arg_19_2[iter_19_0]:unbox()

		QuickDrawer:sphere(var_19_7 + Vector3(0, 0, 0.25), 0.77, Color(255, 144, 23, 67))
	end
end
