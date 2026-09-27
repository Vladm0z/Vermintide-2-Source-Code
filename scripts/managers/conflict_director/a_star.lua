-- chunkname: @scripts/managers/conflict_director/a_star.lua

local LuaAStar = LuaAStar

LuaAStar = LuaAStar or {}
LuaAStar = LuaAStar
LuaAStar.cached_paths = {}

local cached_paths = LuaAStar.cached_paths

function dist_between(arg_1_0, arg_1_1)
	-- function 1
	return Vector3.distance(arg_1_0, arg_1_1)
end

function dist_between_nodes(self, arg_2_1)
	-- function 2
	return Vector3.distance(self:get_group_center():unbox(), arg_2_1:get_group_center():unbox())
end

function heuristic_cost_estimate(arg_3_0, arg_3_1)
	-- function 3
	return dist_between_nodes(arg_3_0, arg_3_1)
end

function is_valid_node(arg_4_0, arg_4_1)
	-- function 4
	return true
end

function lowest_f_score_node(self, arg_5_1)
	-- function 5
	local huge = math.huge
	local var_5_1

	for i = 1, #self do
		local var_5_2 = self[i]
		local var_5_3 = arg_5_1[var_5_2]

		if var_5_3 < huge then
			huge, var_5_1 = var_5_3, var_5_2
		end
	end

	return var_5_1
end

function neighbour_nodes(self, arg_6_1)
	-- function 6
	local get_group_neighbours = self:get_group_neighbours()
	local tbl = {}

	for k, v in pairs(get_group_neighbours) do
		tbl[#tbl + 1] = k
	end

	return tbl
end

function not_in(self, arg_7_1)
	-- function 7
	local count = #self

	for i = 1, count do
		if self[i] == arg_7_1 then
			return false
		end
	end

	return true
end

function remove_node(self, arg_8_1)
	-- function 8
	local count = #self

	for i = 1, count do
		if self[i] == arg_8_1 then
			self[i] = self[count]
			self[count] = nil

			break
		end
	end
end

function reconstruct_path(arg_9_0, arg_9_1, arg_9_2)
	-- function 9
	if not arg_9_1[arg_9_2] then
		table.insert(arg_9_0, 1, arg_9_1[arg_9_2])

		return reconstruct_path(arg_9_0, arg_9_1, arg_9_1[arg_9_2])
	else
		return arg_9_0
	end
end

LuaAStar.a_star_plain = function (arg_10_0, arg_10_1, arg_10_2)
	-- function 10
	local tbl = {}
	local tbl_2 = {
		arg_10_1
	}
	local tbl_3 = {}
	local tbl_4 = {}
	local tbl_5 = {}

	tbl_4[arg_10_1] = 0
	tbl_5[arg_10_1] = tbl_4[arg_10_1] + heuristic_cost_estimate(arg_10_1, arg_10_2)

	while #tbl_2 > 0 do
		local var_10_5 = lowest_f_score_node(tbl_2, tbl_5)

		if var_10_5 == arg_10_2 then
			local var_10_6 = reconstruct_path({}, tbl_3, arg_10_2)

			var_10_6[#var_10_6 + 1] = arg_10_2

			return var_10_6, tbl_5[var_10_5]
		end

		remove_node(tbl_2, var_10_5)

		tbl[#tbl + 1] = var_10_5

		local var_10_7 = neighbour_nodes(var_10_5, arg_10_0)

		for i = 1, #var_10_7 do
			local var_10_8 = var_10_7[i]

			if not not_in(tbl, var_10_8) then
				local num = tbl_4[var_10_5] + dist_between_nodes(var_10_5, var_10_8)

				if not (not_in(tbl_2, var_10_8) or not (num < tbl_4[var_10_8])) then
					tbl_3[var_10_8] = var_10_5
					tbl_4[var_10_8] = num
					tbl_5[var_10_8] = tbl_4[var_10_8] + heuristic_cost_estimate(var_10_8, arg_10_2)

					if not not_in(tbl_2, var_10_8) then
						tbl_2[#tbl_2 + 1] = var_10_8
					end
				end
			end
		end
	end

	return nil
end

LuaAStar.clear_cached_paths = function ()
	-- function 11
	cached_paths = nil
end

LuaAStar.a_star_cached = function (arg_12_0, arg_12_1, arg_12_2)
	-- function 12
	if not cached_paths[arg_12_1] then
		cached_paths[arg_12_1] = {}
	elseif not cached_paths[arg_12_1][arg_12_2] then
		local var_12_0 = cached_paths[arg_12_1][arg_12_2]

		return var_12_0[1], var_12_0[2], true
	end

	local a_star_plain, var_12_2 = LuaAStar.a_star_plain(arg_12_0, arg_12_1, arg_12_2)

	cached_paths[arg_12_1][arg_12_2] = {
		a_star_plain,
		var_12_2
	}

	return a_star_plain, var_12_2
end
