-- chunkname: @scripts/unit_extensions/default_player_unit/player_whereabouts_extension.lua

require("scripts/unit_extensions/generic/generic_state_machine")

PlayerWhereaboutsExtension = class(PlayerWhereaboutsExtension)

local POSITION_LOOKUP = POSITION_LOOKUP

PlayerWhereaboutsExtension.init = function (self, arg_1_1, arg_1_2, arg_1_3)
	-- function 1
	self.unit = arg_1_2
	self._nav_world = Managers.state.entity:system("ai_system"):nav_world()
	self._player = arg_1_3.player
	self.closest_positions = {}
	self._input = {}

	self:_setup(self._nav_world, arg_1_2)

	self._last_onground_pos_on_nav_mesh = Vector3Box(Vector3.invalid_vector())
	self._jumping = false
	self._falling = false
	self._nav_traverse_logic = Managers.state.bot_nav_transition:traverse_logic()
	self._jump_position = Vector3Box(Vector3.invalid_vector())
	self._fall_position = Vector3Box(Vector3.invalid_vector())
	self._free_fall_position = Vector3Box(Vector3.invalid_vector())
end

PlayerWhereaboutsExtension._setup = function (self, arg_2_1, arg_2_2)
	-- function 2
	local var_2_0 = POSITION_LOOKUP[arg_2_2]

	if not not LevelHelper:current_level_settings().no_bots_allowed then
		local triangle_from_position, var_2_2 = GwNavQueries.triangle_from_position(arg_2_1, var_2_0)

		self._last_pos_on_nav_mesh = Vector3Box(var_2_0.x, var_2_0.y, var_2_2 or var_2_0.z)
	else
		self._last_pos_on_nav_mesh = Vector3Box(Vector3.invalid_vector())
	end
end

PlayerWhereaboutsExtension.destroy = function (arg_3_0)
	-- function 3
	return
end

PlayerWhereaboutsExtension.set_is_onground = function (arg_4_0)
	-- function 4
	arg_4_0._input.is_onground = true
end

PlayerWhereaboutsExtension.set_fell = function (arg_5_0, arg_5_1)
	-- function 5
	arg_5_0._input.fell = true
	arg_5_0._input.player_state = arg_5_1
end

PlayerWhereaboutsExtension.set_jumped = function (arg_6_0)
	-- function 6
	arg_6_0._input.jumped = true
end

PlayerWhereaboutsExtension.set_landed = function (arg_7_0)
	-- function 7
	arg_7_0._input.landed = true
end

PlayerWhereaboutsExtension.set_no_landing = function (arg_8_0)
	-- function 8
	arg_8_0._input.no_landing = true
end

PlayerWhereaboutsExtension.update = function (self, arg_9_1, arg_9_2, arg_9_3, arg_9_4, arg_9_5)
	-- function 9
	local var_9_0 = POSITION_LOOKUP[arg_9_1]
	local _input = self._input

	self:_get_closest_positions(var_9_0, _input.is_onground, self.closest_positions)

	local _nav_world = self._nav_world
	local last_position_on_navmesh = self:last_position_on_navmesh()

	if not (not last_position_on_navmesh and self.player_on_nav_mesh or GwNavQueries.triangle_from_position(_nav_world, last_position_on_navmesh, 0.2, 0.3)) then
		self._last_pos_on_nav_mesh:store(Vector3.invalid_vector())
	end

	local last_position_onground_on_navmesh = self:last_position_onground_on_navmesh()

	if not (not last_position_onground_on_navmesh and not self.player_on_nav_mesh and _input.is_onground and GwNavQueries.triangle_from_position(_nav_world, last_position_onground_on_navmesh, 0.2, 0.3)) then
		self._last_onground_pos_on_nav_mesh:store(Vector3.invalid_vector())
	end

	if not self._player.remote then
		self:_check_bot_nav_transition(_nav_world, _input, var_9_0)
	end

	if not self.hang_ledge_position then
		self:_calculate_hang_ledge_spawn_position(self.hang_ledge_position:unbox())

		self.hang_ledge_position = nil
	end

	table.clear(_input)
end

PlayerWhereaboutsExtension.last_position_on_navmesh = function (self)
	-- function 10
	local unbox = self._last_pos_on_nav_mesh:unbox()

	return not Vector3.is_valid(unbox) and unbox and nil
end

PlayerWhereaboutsExtension.last_position_onground_on_navmesh = function (self)
	-- function 11
	local unbox = self._last_onground_pos_on_nav_mesh:unbox()

	return not Vector3.is_valid(unbox) and unbox and nil
end

local num = 0.0001

PlayerWhereaboutsExtension._find_start_position = function (self, arg_12_1, arg_12_2)
	-- function 12
	local unbox = self._last_onground_pos_on_nav_mesh:unbox()

	if not Vector3.is_valid(unbox) then
		local num_2 = arg_12_1 - unbox

		if Vector3.length_squared(num_2) > num then
			local move_on_navmesh = GwNavQueries.move_on_navmesh(self._nav_world, unbox, num_2, 1, self._nav_traverse_logic)

			if not (not arg_12_2 and not (Vector3.distance_squared(arg_12_1, move_on_navmesh) < 4)) then
				return move_on_navmesh
			end
		else
			return unbox
		end
	end
end

PlayerWhereaboutsExtension._check_bot_nav_transition = function (self, arg_13_1, arg_13_2, arg_13_3)
	-- function 13
	if not arg_13_2.jumped then
		fassert(not not self._falling or not self._jumping, "Tried to jump or fall while falling without aborting landing")

		self._jumping = true

		local flag = arg_13_2.player_state == nil or arg_13_2.player_state == "lunging" or arg_13_2.player_state ~= "leaping"
		local _find_start_position = self:_find_start_position(arg_13_3, flag)

		if not _find_start_position then
			self._jump_position:store(_find_start_position)
			self._free_fall_position:store(arg_13_3)
		end
	elseif not arg_13_2.fell then
		fassert(not not self._jumping or not self._falling, "Tried to fall or jump while jumping without aborting landing")

		self._falling = true

		local flag_2 = arg_13_2.player_state == nil or arg_13_2.player_state == "lunging" or arg_13_2.player_state ~= "leaping"
		local _find_start_position_2 = self:_find_start_position(arg_13_3, flag_2)

		if not _find_start_position_2 then
			self._fall_position:store(_find_start_position_2)
			self._free_fall_position:store(arg_13_3)
		end
	end

	if not arg_13_2.no_landing then
		local fassert = fassert
		local _jumping = self._jumping

		_jumping = _jumping or self._falling

		fassert(_jumping, "Tried to not land without falling or jumping")

		self._jumping = false
		self._falling = false

		local invalid_vector = Vector3.invalid_vector()

		self._jump_position:store(invalid_vector)
		self._fall_position:store(invalid_vector)
		self._free_fall_position:store(invalid_vector)
	elseif not arg_13_2.landed then
		local fassert_2 = fassert
		local _jumping_2 = self._jumping

		_jumping_2 = _jumping_2 or self._falling

		fassert_2(_jumping_2, "Tried to land without falling or jumping")

		if not self._jumping then
			local unbox = self._jump_position:unbox()

			if not Vector3.is_valid(unbox) then
				Managers.state.bot_nav_transition:create_transition(unbox, self._free_fall_position:unbox(), arg_13_3, true)
			end

			local invalid_vector_2 = Vector3.invalid_vector()

			self._jump_position:store(invalid_vector_2)
			self._free_fall_position:store(invalid_vector_2)

			self._jumping = false
		elseif not self._falling then
			local unbox_2 = self._fall_position:unbox()

			if not Vector3.is_valid(unbox_2) then
				Managers.state.bot_nav_transition:create_transition(unbox_2, self._free_fall_position:unbox(), arg_13_3, false)
			end

			local invalid_vector_3 = Vector3.invalid_vector()

			self._fall_position:store(invalid_vector_3)
			self._free_fall_position:store(invalid_vector_3)

			self._falling = false
		end
	end
end

PlayerWhereaboutsExtension._get_closest_positions = function (self, arg_14_1, arg_14_2, arg_14_3)
	-- function 14
	local _nav_world = self._nav_world

	self.player_on_nav_mesh = GwNavQueries.triangle_from_position(_nav_world, arg_14_1, 0.2, 0.3)

	if not self.player_on_nav_mesh then
		self._last_pos_on_nav_mesh:store(arg_14_1)

		if not arg_14_2 then
			self._last_onground_pos_on_nav_mesh:store(arg_14_1)
		end

		return
	end

	local inside_position_from_outside_position = GwNavQueries.inside_position_from_outside_position(_nav_world, arg_14_1, 3, 3, 2.1, 0.5)

	if not inside_position_from_outside_position then
		arg_14_3[1] = Vector3Box(inside_position_from_outside_position)

		for i = 2, #arg_14_3 do
			arg_14_3[i] = nil
		end

		return
	end

	local inside_position_from_outside_position_2 = GwNavQueries.inside_position_from_outside_position(_nav_world, arg_14_1, 5, 5, 10, 0.5)

	if not inside_position_from_outside_position_2 then
		arg_14_3[1] = Vector3Box(inside_position_from_outside_position_2)

		for j = 2, #arg_14_3 do
			arg_14_3[j] = nil
		end

		return
	end

	local count = #arg_14_3

	for k = 1, count do
		arg_14_3[k] = nil
	end

	LocomotionUtils.closest_mesh_positions_outward(_nav_world, arg_14_1, 10, arg_14_3)
end

PlayerWhereaboutsExtension.closest_positions_when_outside_navmesh = function (self)
	-- function 15
	return self.closest_positions, self.player_on_nav_mesh
end

PlayerWhereaboutsExtension.set_new_hang_ledge_position = function (self, arg_16_1)
	-- function 16
	self.hang_ledge_position = Vector3Box(arg_16_1)
end

PlayerWhereaboutsExtension._calculate_hang_ledge_spawn_position = function (self, arg_17_1)
	-- function 17
	local _nav_world = self._nav_world
	local inside_position_from_outside_position = GwNavQueries.inside_position_from_outside_position(_nav_world, arg_17_1, 5, 5, 10, 0.25)

	if not inside_position_from_outside_position then
		self.hang_ledge_spawn_position = Vector3Box(inside_position_from_outside_position)
	else
		print("Could not find spawn position for hang ledge.")

		self.hang_ledge_spawn_position = Vector3Box(arg_17_1)
	end
end

PlayerWhereaboutsExtension.get_hang_ledge_spawn_position = function (self)
	-- function 18
	return self.hang_ledge_spawn_position:unbox()
end

PlayerWhereaboutsExtension._debug_draw = function (self, arg_19_1, arg_19_2, arg_19_3)
	-- function 19
	local unbox = self._last_onground_pos_on_nav_mesh:unbox()
	local abs = math.abs(math.cos(arg_19_3))
	local abs_2 = math.abs(math.cos(2 * arg_19_3))
	local abs_3 = math.abs(math.sin(arg_19_3))

	if not Vector3.is_valid(unbox) then
		local var_19_4 = Color(abs * 255, abs_3 * 255, abs * 255)

		QuickDrawer:sphere(unbox, 0.25, var_19_4)
		QuickDrawer:line(arg_19_1, unbox, var_19_4)
		QuickDrawer:sphere(arg_19_1, abs_2 * 0.2 + 0.05, var_19_4)
	end

	local unbox_2 = self._last_pos_on_nav_mesh:unbox()

	if not Vector3.is_valid(unbox_2) then
		local var_19_6 = Color(0, abs_3 * 125, abs * 125)

		QuickDrawer:sphere(unbox_2, 0.1, var_19_6)
		QuickDrawer:line(arg_19_1, unbox_2, var_19_6)
		QuickDrawer:sphere(arg_19_1, abs_2 * 0.05 + 0.05, var_19_6)
	end

	for i = 1, #arg_19_2 do
		local unbox_3 = arg_19_2[i]:unbox()

		QuickDrawer:sphere(unbox_3 + Vector3(0, 0, 0.25), 0.77, Color(255, 144, 23, 67))
	end
end
