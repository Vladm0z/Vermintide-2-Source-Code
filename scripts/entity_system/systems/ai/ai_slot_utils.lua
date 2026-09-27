-- chunkname: @scripts/entity_system/systems/ai/ai_slot_utils.lua

local tbl = {}
local copy = Vector3.copy
local triangle_from_position = GwNavQueries.triangle_from_position
local inside_position_from_outside_position = GwNavQueries.inside_position_from_outside_position
local num = 1.5
local num_2 = 1.5
local num_3 = 7.5

tbl.clamp_position_on_navmesh = function (arg_1_0, arg_1_1, arg_1_2, arg_1_3)
	-- function 1
	arg_1_3 = arg_1_3 or num_2
	arg_1_2 = arg_1_2 or num

	local var_1_0, var_1_1 = triangle_from_position(arg_1_1, arg_1_0, arg_1_2, arg_1_3)

	if not var_1_0 then
		local var_1_2 = copy(arg_1_0)

		var_1_2.z = var_1_1

		return var_1_2
	end

	return nil
end

tbl.get_target_pos_on_navmesh = function (arg_2_0, arg_2_1)
	-- function 2
	local clamp_position_on_navmesh = tbl.clamp_position_on_navmesh(arg_2_0, arg_2_1)

	if not clamp_position_on_navmesh then
		return clamp_position_on_navmesh
	end

	local var_2_1 = num
	local var_2_2 = num_2
	local num_4 = 1
	local num_5 = 0.05
	local var_2_5 = inside_position_from_outside_position(arg_2_1, arg_2_0, var_2_1, var_2_2, num_4, num_5)

	if not var_2_5 then
		return var_2_5
	end

	local var_2_6 = num
	local var_2_7 = num_3
	local clamp_position_on_navmesh_2 = tbl.clamp_position_on_navmesh(arg_2_0, arg_2_1, var_2_6, var_2_7)

	if not clamp_position_on_navmesh_2 then
		return clamp_position_on_navmesh_2
	end

	return nil
end

return tbl
