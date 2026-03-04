-- chunkname: @scripts/entity_system/systems/ai/ai_slot_utils.lua

local var_0_0 = {}
local var_0_1 = Vector3.copy
local var_0_2 = GwNavQueries.triangle_from_position
local var_0_3 = GwNavQueries.inside_position_from_outside_position
local var_0_4 = 1.5
local var_0_5 = 1.5
local var_0_6 = 7.5

function var_0_0.clamp_position_on_navmesh(arg_1_0, arg_1_1, arg_1_2, arg_1_3)
	arg_1_3 = arg_1_3 or var_0_5
	arg_1_2 = arg_1_2 or var_0_4

	local var_1_0, var_1_1 = var_0_2(arg_1_1, arg_1_0, arg_1_2, arg_1_3)

	if var_1_0 then
		local var_1_2 = var_0_1(arg_1_0)

		var_1_2.z = var_1_1

		return var_1_2
	end

	return nil
end

function var_0_0.get_target_pos_on_navmesh(arg_2_0, arg_2_1)
	local var_2_0 = var_0_0.clamp_position_on_navmesh(arg_2_0, arg_2_1)

	if var_2_0 then
		return var_2_0
	end

	local var_2_1 = var_0_4
	local var_2_2 = var_0_5
	local var_2_3 = 1
	local var_2_4 = 0.05
	local var_2_5 = var_0_3(arg_2_1, arg_2_0, var_2_1, var_2_2, var_2_3, var_2_4)

	if var_2_5 then
		return var_2_5
	end

	local var_2_6 = var_0_4
	local var_2_7 = var_0_6
	local var_2_8 = var_0_0.clamp_position_on_navmesh(arg_2_0, arg_2_1, var_2_6, var_2_7)

	if var_2_8 then
		return var_2_8
	end

	return nil
end

return var_0_0
