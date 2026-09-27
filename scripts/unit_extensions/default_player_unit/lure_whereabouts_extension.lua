-- chunkname: @scripts/unit_extensions/default_player_unit/lure_whereabouts_extension.lua

require("scripts/unit_extensions/generic/generic_state_machine")

LureWhereaboutsExtension = class(LureWhereaboutsExtension)

LureWhereaboutsExtension.init = function (self, arg_1_1, arg_1_2, arg_1_3)
	-- function 1
	self._unit = arg_1_2

	local nav_world = Managers.state.entity:system("ai_system"):nav_world()

	self._closest_positions = {}

	local world_position = Unit.world_position(arg_1_2, 0)
	local num = 1
	local num_2 = 5
	local triangle_from_position, var_1_5 = GwNavQueries.triangle_from_position(nav_world, world_position, num, num_2)

	if not triangle_from_position then
		self._closest_positions[1] = Vector3Box(Vector3(world_position.x, world_position.y, var_1_5))
		self._on_navmesh = true
	else
		self._on_navmesh = false

		local num_3 = 5
		local num_4 = 0.1
		local inside_position_from_outside_position = GwNavQueries.inside_position_from_outside_position(nav_world, world_position, num, num_2, num_3, num_4)

		if not inside_position_from_outside_position then
			self._closest_positions[1] = Vector3Box(inside_position_from_outside_position)
		end
	end
end

LureWhereaboutsExtension.destroy = function (arg_2_0)
	-- function 2
	return
end

LureWhereaboutsExtension.closest_positions_when_outside_navmesh = function (self)
	-- function 3
	return self._closest_positions, self._on_navmesh
end
