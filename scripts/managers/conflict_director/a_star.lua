-- chunkname: @scripts/managers/conflict_director/a_star.lua

LuaAStar = LuaAStar or {}
LuaAStar.cached_paths = {}

local var_0_0 = LuaAStar.cached_paths

function dist_between(arg_1_0, arg_1_1)
	return Vector3.distance(arg_1_0, arg_1_1)
end

function dist_between_nodes(arg_2_0, arg_2_1)
	return Vector3.distance(arg_2_0:get_group_center():unbox(), arg_2_1:get_group_center():unbox())
end

function heuristic_cost_estimate(arg_3_0, arg_3_1)
	return dist_between_nodes(arg_3_0, arg_3_1)
end

function is_valid_node(arg_4_0, arg_4_1)
	return true
end

function lowest_f_score_node(arg_5_0, arg_5_1)
	local var_5_0 = math.huge
	local var_5_1

	for iter_5_0 = 1, #arg_5_0 do
		local var_5_2 = arg_5_0[iter_5_0]
		local var_5_3 = arg_5_1[var_5_2]

		if var_5_3 < var_5_0 then
			var_5_0, var_5_1 = var_5_3, var_5_2
		end
	end

	return var_5_1
end

function neighbour_nodes(arg_6_0, arg_6_1)
	local var_6_0 = arg_6_0:get_group_neighbours()
	local var_6_1 = {}

	for iter_6_0, iter_6_1 in pairs(var_6_0) do
		var_6_1[#var_6_1 + 1] = iter_6_0
	end

	return var_6_1
end

function not_in(arg_7_0, arg_7_1)
	local var_7_0 = #arg_7_0

	for iter_7_0 = 1, var_7_0 do
		if arg_7_0[iter_7_0] == arg_7_1 then
			return false
		end
	end

	return true
end

function remove_node(arg_8_0, arg_8_1)
	local var_8_0 = #arg_8_0

	for iter_8_0 = 1, var_8_0 do
		if arg_8_0[iter_8_0] == arg_8_1 then
			arg_8_0[iter_8_0] = arg_8_0[var_8_0]
			arg_8_0[var_8_0] = nil

			break
		end
	end
end

function reconstruct_path(arg_9_0, arg_9_1, arg_9_2)
	if arg_9_1[arg_9_2] then
		table.insert(arg_9_0, 1, arg_9_1[arg_9_2])

		return reconstruct_path(arg_9_0, arg_9_1, arg_9_1[arg_9_2])
	else
		return arg_9_0
	end
end

function LuaAStar.a_star_plain(arg_10_0, arg_10_1, arg_10_2)
	local var_10_0 = {}
	local var_10_1 = {
		arg_10_1
	}
	local var_10_2 = {}
	local var_10_3 = {}
	local var_10_4 = {}

	var_10_3[arg_10_1] = 0
	var_10_4[arg_10_1] = var_10_3[arg_10_1] + heuristic_cost_estimate(arg_10_1, arg_10_2)

	while #var_10_1 > 0 do
		local var_10_5 = lowest_f_score_node(var_10_1, var_10_4)

		if var_10_5 == arg_10_2 then
			local var_10_6 = reconstruct_path({}, var_10_2, arg_10_2)

			var_10_6[#var_10_6 + 1] = arg_10_2

			return var_10_6, var_10_4[var_10_5]
		end

		remove_node(var_10_1, var_10_5)

		var_10_0[#var_10_0 + 1] = var_10_5

		local var_10_7 = neighbour_nodes(var_10_5, arg_10_0)

		for iter_10_0 = 1, #var_10_7 do
			local var_10_8 = var_10_7[iter_10_0]

			if not_in(var_10_0, var_10_8) then
				local var_10_9 = var_10_3[var_10_5] + dist_between_nodes(var_10_5, var_10_8)

				if not_in(var_10_1, var_10_8) or var_10_9 < var_10_3[var_10_8] then
					var_10_2[var_10_8] = var_10_5
					var_10_3[var_10_8] = var_10_9
					var_10_4[var_10_8] = var_10_3[var_10_8] + heuristic_cost_estimate(var_10_8, arg_10_2)

					if not_in(var_10_1, var_10_8) then
						var_10_1[#var_10_1 + 1] = var_10_8
					end
				end
			end
		end
	end

	return nil
end

function LuaAStar.clear_cached_paths()
	var_0_0 = nil
end

function LuaAStar.a_star_cached(arg_12_0, arg_12_1, arg_12_2)
	if not var_0_0[arg_12_1] then
		var_0_0[arg_12_1] = {}
	elseif var_0_0[arg_12_1][arg_12_2] then
		local var_12_0 = var_0_0[arg_12_1][arg_12_2]

		return var_12_0[1], var_12_0[2], true
	end

	local var_12_1, var_12_2 = LuaAStar.a_star_plain(arg_12_0, arg_12_1, arg_12_2)

	var_0_0[arg_12_1][arg_12_2] = {
		var_12_1,
		var_12_2
	}

	return var_12_1, var_12_2
end
