-- chunkname: @scripts/unit_extensions/wizards/trail_urn_alignment_extension.lua

TrailUrnAlignmentExtension = class(TrailUrnAlignmentExtension)

local tbl = {
	MOVE_TO_NODE = 2,
	WAITING_FOR_INTERACTION = 1,
	IS_ALIGNED = 3
}
local num = 0.3

TrailUrnAlignmentExtension.init = function (self, arg_1_1, arg_1_2, arg_1_3)
	-- function 1
	self._unit = arg_1_2
	self._interactable_type = Unit.get_data(arg_1_2, "interaction_data", "interaction_type")
	self._elapsed_time = 0
	self._start_time = 0
	self._start_position = nil
	self._start_offset = nil
	self._interaction_position = Vector3Box(Vector3.zero())
	self._position = Vector3Box(Unit.world_position(self._unit, 0))
	self._nav_world = Managers.state.entity:system("ai_system"):nav_world()
	self._interaction_distance = Unit.get_data(arg_1_2, "animation_distance")
	self._align_state = tbl.WAITING_FOR_INTERACTION
end

TrailUrnAlignmentExtension.update_interaction_position = function (self, arg_2_1)
	-- function 2
	local var_2_0 = POSITION_LOOKUP[arg_2_1]
	local unbox = self._position:unbox()
	local num = Vector3.normalize(var_2_0 - unbox) * self._interaction_distance + unbox
	local triangle_from_position, var_2_4 = GwNavQueries.triangle_from_position(self._nav_world, num, 1, 1)

	if not triangle_from_position then
		num.z = var_2_4

		return num
	else
		local num_2 = 10
		local num_3 = 1

		for i = 1, num_2 do
			local num_4 = 2 * math.pi / num_2 * i
			local var_2_8 = Vector3(math.sin(num_4) * self._interaction_distance * num_3, -math.cos(num_4) * self._interaction_distance * num_3, 0)

			num_3 = num_3 * -1

			local num_5 = unbox + var_2_8
			local triangle_from_position_2, var_2_11 = GwNavQueries.triangle_from_position(self._nav_world, num_5, 1, 1)

			if not triangle_from_position_2 then
				num_5.z = var_2_11

				return num_5
			end
		end
	end
end

TrailUrnAlignmentExtension.can_interact = function (self)
	-- function 3
	if self._align_state ~= tbl.WAITING_FOR_INTERACTION then
		return false
	end

	return true
end

TrailUrnAlignmentExtension.on_client_start_interaction = function (self, arg_4_1, arg_4_2)
	-- function 4
	self._elapsed_time = 0
	self._start_time = arg_4_2
	self._start_position = Vector3Box(POSITION_LOOKUP[arg_4_1])

	local update_interaction_position = self:update_interaction_position(arg_4_1)

	self._interaction_position:store(update_interaction_position)

	self._align_state = tbl.MOVE_TO_NODE
end

local num_2 = 1

TrailUrnAlignmentExtension.is_unit_pushed_out_off_range = function (self, arg_5_1, arg_5_2)
	-- function 5
	local var_5_0 = POSITION_LOOKUP[arg_5_1]
	local unbox = self._start_offset:unbox()
	local num = var_5_0 - self._position:unbox()

	if Vector3.distance_squared(unbox, num) > num_2 then
		self._align_state = tbl.WAITING_FOR_INTERACTION

		return true
	end

	return false
end

TrailUrnAlignmentExtension.on_client_move_to_node = function (self, arg_6_1, arg_6_2, arg_6_3, arg_6_4)
	-- function 6
	if self._align_state ~= tbl.MOVE_TO_NODE then
		return false
	end

	local unbox = self._position:unbox()
	local var_6_1 = POSITION_LOOKUP[arg_6_1]
	local lerp_to_node = self:lerp_to_node(arg_6_1, num, arg_6_4)

	if not arg_6_3 then
		local extension = ScriptUnit.extension(arg_6_1, "locomotion_system")

		extension:enable_wanted_position_movement()
		extension:set_wanted_pos(lerp_to_node)

		local num_2 = unbox - var_6_1
		local look = Quaternion.look(Vector3.flat(num_2), Vector3.up())

		Unit.set_local_rotation(arg_6_1, 0, look)
	end

	if not (self._interaction_distance * self._interaction_distance >= Vector3.distance_squared(var_6_1, self._position:unbox()) or not (self._elapsed_time > num)) then
		self._start_offset = Vector3Box(POSITION_LOOKUP[arg_6_1] - self._position:unbox())
		self._align_state = tbl.IS_ALIGNED
	end
end

TrailUrnAlignmentExtension.lerp_to_node = function (self, arg_7_1, arg_7_2, arg_7_3)
	-- function 7
	self._elapsed_time = arg_7_3 - self._start_time

	local num = self._elapsed_time / arg_7_2
	local ease_out_quad = math.ease_out_quad(num)
	local clamp = math.clamp(ease_out_quad, 0, 1)

	return (Vector3.lerp(self._start_position:unbox(), self._interaction_position:unbox(), clamp))
end

TrailUrnAlignmentExtension.on_client_stop = function (self, arg_8_1)
	-- function 8
	if arg_8_1 == InteractionResult.SUCCESS then
		local str = "lua_interaction_stopped_" .. self._interactable_type .. "_" .. arg_8_1

		Unit.flow_event(self._unit, str)

		self._align_state = tbl.DONE
	else
		self._align_state = tbl.WAITING_FOR_INTERACTION
	end
end

TrailUrnAlignmentExtension.is_state_move_to_node = function (self)
	-- function 9
	if self._align_state == tbl.MOVE_TO_NODE then
		return true
	end

	return false
end

TrailUrnAlignmentExtension.set_state_waiting_for_interaction = function (self)
	-- function 10
	self._align_state = tbl.WAITING_FOR_INTERACTION
end

TrailUrnAlignmentExtension.is_state_aligned = function (self)
	-- function 11
	if self._align_state == tbl.IS_ALIGNED then
		return true
	end

	return false
end
