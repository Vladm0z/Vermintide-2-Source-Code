-- chunkname: @scripts/managers/conflict_director/gathering.lua

Gathering = class(Gathering)

Gathering.init = function (self, arg_1_1, arg_1_2, arg_1_3)
	-- function 1
	arg_1_3 = arg_1_3 or Vector3(0, 0, 0)
	self.traverse_logic = arg_1_2
	self.balls = {}
	self.static_units = {}
	self.num_balls = 0
	self.dogpiled_attackers_on_unit = {}
	self.selected_ball = nil
	self.debug_draw = false
	self.nav_world = arg_1_1
	self.ball_broadphase = Broadphase(1, 128)
	self.lookup_broadphase_id = {}
	self.target_unit_to_ball_lookup = {}
	self.version = "fast"
	self.last_index = 1
end

local tbl = {
	"red",
	"blue",
	"green",
	"yellow"
}

Gathering.write_dogpiled_attackers = function (arg_2_0, arg_2_1)
	-- function 2
	local str = ""
	local sides = Managers.state.side:sides()

	for i = 1, #sides do
		local var_2_2 = sides[i]
		local _units = var_2_2._units
		local side_id = var_2_2.side_id

		for j = 1, #_units do
			local var_2_5 = _units[j]
			local var_2_6 = tbl[side_id]

			var_2_6 = var_2_6 or "white"

			local get = Colors.get(var_2_6)
			local var_2_8 = POSITION_LOOKUP[var_2_5]
			local var_2_9 = BLACKBOARDS[var_2_5]
			local flag = not var_2_9 and var_2_9.breed

			if not (not flag and flag.is_player) then
				local var_2_11 = arg_2_1[var_2_5]

				if not var_2_11 and not next(var_2_11) then
					str = str .. " | ("

					local flag_2 = true

					for k, v in pairs(var_2_11) do
						local var_2_13 = str
						local flag_3

						flag_3 = not flag_2 and "" and ", "
						str = var_2_13 .. flag_3 .. tostring(Unit.get_data(k, "unique_id"))
						flag_2 = false
					end

					str = str .. ") -> u" .. tostring(Unit.get_data(var_2_5, "unique_id"))
				end
			end
		end
	end

	Debug.text("Dogpiled: %s", str)
end

Gathering.draw = function (self)
	-- function 3
	if not script_data.debug_gathering then
		local text = Debug.text
		local str = "balls=%d, bchecks=%d, uchecks=%d"
		local num_balls = self.num_balls
		local num_boid_checks = self.num_boid_checks

		num_boid_checks = num_boid_checks or 0

		local num_unit_checks = self.num_unit_checks

		num_unit_checks = num_unit_checks or 0

		text(str, num_balls, num_boid_checks, num_unit_checks)
	end

	local dogpiled_attackers_on_unit = self.dogpiled_attackers_on_unit
	local balls = self.balls
	local var_3_7 = Color(0, 200, 200)
	local var_3_8 = Color(70, 200, 0)
	local str_2 = ""

	for i = 1, self.num_balls do
		local var_3_10 = balls[i]
		local pos = var_3_10.pos
		local var_3_12 = tbl[var_3_10.side_id]

		var_3_12 = var_3_12 or "white"

		local get = Colors.get(var_3_12)
		local var_3_14 = Vector3(pos[1], pos[2], pos[3] + 0.01)

		QuickDrawer:circle(var_3_14, var_3_10.rad, Vector3.up(), get)

		if not var_3_10.target_unit and not var_3_10.owner_unit then
			local var_3_15 = POSITION_LOOKUP[var_3_10.owner_unit]

			QuickDrawer:line(var_3_14, var_3_15, get)
		end

		local var_3_16 = dogpiled_attackers_on_unit[var_3_10.owner_unit]
		local size

		if not var_3_16 then
			size = table.size(var_3_16)

			if not size then
				-- Nothing
			end
		end

		size = 0

		::label_3_0::

		str_2 = str_2 .. " | " .. var_3_10.id .. "(" .. size .. ")"
	end

	if not script_data.debug_gathering then
		Debug.text("Balls: %s", str_2)
	end

	if self.version ~= "fast" or not script_data.debug_gathering then
		self:write_dogpiled_attackers(dogpiled_attackers_on_unit)
	end
end

Gathering.respawn_balls = function (self, arg_4_1, arg_4_2)
	-- function 4
	for i = 1, 100 do
		self:add_ball(arg_4_1 + Vector3(math.random() * 10 - 5, math.random() * 10 - 5, 0), math.random() + 0.25, nil, arg_4_2)
	end
end

Gathering.add_static_ball = function (self, arg_5_1, arg_5_2, arg_5_3)
	-- function 5
	local add_ball = self:add_ball(arg_5_1, arg_5_2, arg_5_3, nil, true)

	self.static_units[arg_5_3] = add_ball
end

Gathering.remove_static_ball = function (self, arg_6_1)
	-- function 6
	local id = self.static_units[arg_6_1].id

	self:remove_ball(id)

	self.static_units[arg_6_1] = nil
end

Gathering.add_ball = function (self, arg_7_1, arg_7_2, arg_7_3, arg_7_4, arg_7_5)
	-- function 7
	fassert(arg_7_3 ~= arg_7_4, "Wut?!? can't have yourself as your target")

	local balls = self.balls
	local num = self.num_balls + 1
	local var_7_2 = Managers.state.side.side_by_unit[arg_7_3]

	var_7_2 = var_7_2 or Managers.state.side:sides(1)

	local add

	if self.version == "fast" then
		add = Broadphase.add(self.ball_broadphase, nil, arg_7_1, arg_7_2)

		if not add then
			-- Nothing
		end
	end

	add = nil

	::label_7_0::

	local tbl = {
		id = num,
		pos = {
			arg_7_1.x,
			arg_7_1.y,
			arg_7_1.z
		},
		last_pos = {
			arg_7_1.x,
			arg_7_1.y,
			arg_7_1.z
		},
		rad = arg_7_2,
		owner_unit = arg_7_3,
		target_unit = arg_7_4,
		side_id = var_7_2.side_id,
		is_static = arg_7_5,
		broadphase_id = add
	}

	balls[num] = tbl
	self.num_balls = num
	self.target_unit_to_ball_lookup[arg_7_4] = tbl
	self.lookup_broadphase_id[add] = tbl

	local var_7_5 = self.dogpiled_attackers_on_unit[arg_7_4]

	if not var_7_5 then
		self.dogpiled_attackers_on_unit[arg_7_4] = {
			[arg_7_3] = tbl
		}

		return tbl
	end

	var_7_5[arg_7_3] = tbl

	return tbl
end

Gathering.remove_ball = function (self, arg_8_1)
	-- function 8
	if not arg_8_1.destroyed then
		return
	end

	self.dogpiled_attackers_on_unit[arg_8_1.target_unit][arg_8_1.owner_unit] = nil

	local balls = self.balls
	local id = arg_8_1.id

	self.target_unit_to_ball_lookup[arg_8_1.target_unit] = nil

	local broadphase_id = arg_8_1.broadphase_id

	if self.version == "fast" then
		Broadphase.remove(self.ball_broadphase, broadphase_id)
	end

	self.lookup_broadphase_id[broadphase_id] = nil

	local num_balls = self.num_balls

	arg_8_1.destroyed = true

	local var_8_4 = balls[num_balls]

	balls[id] = var_8_4
	var_8_4.id = id
	balls[num_balls] = nil
	self.num_balls = num_balls - 1
end

Gathering.release_attacking_balls = function (arg_9_0, arg_9_1)
	-- function 9
	return
end

Gathering.notify_attackers = function (self, arg_10_1)
	-- function 10
	notify_attackers(arg_10_1, self.dogpiled_attackers_on_unit)
end

function notify_attackers(arg_11_0, arg_11_1)
	-- function 11
	local var_11_0 = arg_11_1[arg_11_0]

	if not var_11_0 then
		return
	end

	for k, v in pairs(var_11_0) do
		fassert(k ~= arg_11_0, "Waat, unit is enemy of itself?")

		local has_extension = ScriptUnit.has_extension(k, "ai_slot_system")

		if not has_extension then
			has_extension:_detach_from_ai_slot("notify_attackers")
		end
	end

	table.clear(var_11_0)
end

local function fn(arg_12_0, arg_12_1, arg_12_2, arg_12_3, arg_12_4, arg_12_5)
	-- function 12
	return (arg_12_0 - arg_12_3) * (arg_12_0 - arg_12_3) + (arg_12_1 - arg_12_4) * (arg_12_1 - arg_12_4) <= (arg_12_2 + arg_12_5) * (arg_12_2 + arg_12_5)
end

local tbl_2 = {}

Gathering.overlap_update = function (self, arg_13_1, arg_13_2)
	-- function 13
	local broadphase_query = AiUtils.broadphase_query

	for i = 1, self.num_balls do
		local var_13_1 = broadphase_query(position, 3, tbl_2)
	end
end

Gathering.slot_vs_slot_overlap = function (arg_14_0, arg_14_1, arg_14_2, arg_14_3, arg_14_4, arg_14_5, arg_14_6)
	-- function 14
	local distance = Vector3.distance(Vector3(arg_14_1[1], arg_14_1[2], 0), Vector3(arg_14_3[1], arg_14_3[2], 0))

	if distance < 0.001 then
		arg_14_1[1] = arg_14_1[1] - arg_14_2 * 0.1
		arg_14_3[2] = arg_14_3[2] - arg_14_2 * 0.1

		return
	end

	local num = (distance - arg_14_2 - arg_14_4) * 0.5

	if num < 0 then
		arg_14_1[1] = arg_14_1[1] - num * (arg_14_1[1] - arg_14_3[1]) / distance
		arg_14_1[2] = arg_14_1[2] - num * (arg_14_1[2] - arg_14_3[2]) / distance
		arg_14_3[1] = arg_14_3[1] + num * (arg_14_1[1] - arg_14_3[1]) / distance
		arg_14_3[2] = arg_14_3[2] + num * (arg_14_1[2] - arg_14_3[2]) / distance
	end
end

Gathering.slot_vs_breed_overlap = function (arg_15_0, arg_15_1, arg_15_2, arg_15_3, arg_15_4, arg_15_5)
	-- function 15
	local distance = Vector3.distance(Vector3(arg_15_1[1], arg_15_1[2], 0), Vector3(arg_15_3[1], arg_15_3[2], 0))

	if distance < 0.001 then
		arg_15_1[1] = arg_15_1[1] - arg_15_2 * 0.1

		return
	end

	local num = distance - arg_15_2 - arg_15_4

	if num < 0 then
		arg_15_1[1] = arg_15_1[1] - num * (arg_15_1[1] - arg_15_3[1]) / distance
		arg_15_1[2] = arg_15_1[2] - num * (arg_15_1[2] - arg_15_3[2]) / distance
	end
end

Gathering.update_efficient = function (self, arg_16_1, arg_16_2)
	-- function 16
	local nav_world = self.nav_world
	local balls = self.balls
	local broadphase_query = AiUtils.broadphase_query
	local ball_broadphase = self.ball_broadphase
	local lookup_broadphase_id = self.lookup_broadphase_id
	local num = 0
	local num_2 = 0
	local num_3 = 10
	local last_index = self.last_index
	local num_4 = self.last_index + num_3

	if num_4 >= self.num_balls then
		self.last_index = 1
		num_4 = self.num_balls
	else
		self.last_index = num_4 + 1
	end

	for i = last_index, num_4 do
		repeat
			local var_16_10 = balls[i]
			local side_id = var_16_10.side_id
			local pos = var_16_10.pos
			local rad = var_16_10.rad
			local var_16_14 = POSITION_LOOKUP[var_16_10.target_unit]

			if not var_16_14 then
				break
			end

			pos[1] = pos[1] - (pos[1] - var_16_14[1]) * arg_16_2
			pos[2] = pos[2] - (pos[2] - var_16_14[2]) * arg_16_2
			pos[3] = var_16_14[3]

			local var_16_15 = Vector3(pos[1], pos[2], 0)
			local query = Broadphase.query(ball_broadphase, var_16_15, 1, tbl_2)

			for j = 1, query do
				local var_16_17 = lookup_broadphase_id[tbl_2[j]]

				if var_16_17 ~= var_16_10 then
					self:slot_vs_slot_overlap(pos, rad, var_16_17.pos, var_16_17.rad, var_16_10, var_16_17)

					num = num + 1
				end
			end

			local var_16_18 = Vector3(pos[1], pos[2], pos[3])
			local num_5 = 2.2 + rad
			local var_16_20 = broadphase_query(var_16_18, num_5, tbl_2)

			for k = 1, var_16_20 do
				local var_16_21 = tbl_2[k]

				if side_id ~= BLACKBOARDS[var_16_21].side.side_id then
					local var_16_22 = tbl_2[k]
					local var_16_23 = POSITION_LOOKUP[var_16_22]
					local num_6 = 2.2

					self:slot_vs_breed_overlap(pos, rad, var_16_23, num_6, var_16_10)

					num_2 = num_2 + 1
				end
			end
		until true
	end

	local traverse_logic = self.traverse_logic

	for l = 1, self.num_balls do
		local var_16_26 = balls[l]
		local pos_2 = var_16_26.pos
		local last_pos = var_16_26.last_pos

		if not (Vector3.distance_squared(Vector3(pos_2[1], pos_2[2], pos_2[3]), Vector3(last_pos[1], last_pos[2], last_pos[3])) > 0.0001) then
			local var_16_29 = Vector3(pos_2[1], pos_2[2], pos_2[3])
			local var_16_30 = POSITION_LOOKUP[var_16_26.target_unit]

			if not var_16_30 then
				local raycast, var_16_32 = GwNavQueries.raycast(nav_world, var_16_30, var_16_29, traverse_logic)

				var_16_29 = var_16_32
			end

			local var_16_33 = Vector3(var_16_29[1], var_16_29[2], 0)

			Broadphase.move(ball_broadphase, var_16_26.broadphase_id, var_16_33)

			pos_2[1], pos_2[2], pos_2[3] = var_16_29[1], var_16_29[2], var_16_29[3]
			last_pos[1], last_pos[2], last_pos[3] = var_16_29[1], var_16_29[2], var_16_29[3]
		end
	end

	self.num_boid_checks = num
	self.num_unit_checks = num_2
end

Gathering.update_brute_force = function (self, arg_17_1, arg_17_2)
	-- function 17
	local nav_world = self.nav_world
	local balls = self.balls

	for i = 1, self.num_balls do
		local var_17_2 = balls[i]
		local pos = var_17_2.pos
		local rad = var_17_2.rad
		local target_unit = var_17_2.target_unit

		if not target_unit then
			local var_17_6 = POSITION_LOOKUP[target_unit]

			var_17_6 = GwNavQueries.inside_position_from_outside_position(nav_world, var_17_6, 2, 2) or var_17_6
			pos[1] = pos[1] - (pos[1] - var_17_6[1]) * arg_17_2
			pos[2] = pos[2] - (pos[2] - var_17_6[2]) * arg_17_2
		elseif not var_17_2.is_static then
			local var_17_7 = POSITION_LOOKUP[var_17_2.owner_unit]

			pos[1] = var_17_7.x
			pos[2] = var_17_7.y
		end

		local is_static = var_17_2.is_static
		local flag = not is_static
		local side_id = var_17_2.side_id
		local broadphase_query = AiUtils.broadphase_query

		for j = 1, self.num_balls do
			local var_17_12 = balls[j]
			local is_static_2 = var_17_12.is_static
			local flag_2 = not is_static_2
			local flag_3 = var_17_12.side_id ~= side_id
			local flag_4 = not flag_3
			local flag_5 = not is_static and not flag_2 and flag_3
			local flag_6 = not is_static_2 and not flag and flag_3
			local flag_7 = not flag and not flag_2 and flag_4

			if var_17_2 == var_17_12 or flag_5 or flag_6 or not flag_7 then
				local pos_2 = var_17_12.pos
				local rad_2 = var_17_12.rad

				if not fn(pos[1], pos[2], rad, pos_2[1], pos_2[2], rad_2) then
					local distance = Vector3.distance(Vector3(pos[1], pos[2], 0), Vector3(pos_2[1], pos_2[2], 0))
					local num = (distance - rad - rad_2) * 0.5

					pos[1] = pos[1] - num * (pos[1] - pos_2[1]) / distance
					pos[2] = pos[2] - num * (pos[2] - pos_2[2]) / distance
					pos_2[1] = pos_2[1] + num * (pos[1] - pos_2[1]) / distance
					pos_2[2] = pos_2[2] + num * (pos[2] - pos_2[2]) / distance
				end
			end
		end
	end
end

Gathering.update = function (self, arg_18_1, arg_18_2)
	-- function 18
	self:update_efficient(arg_18_1, arg_18_2)

	if not self.debug_draw then
		self:draw()
	end
end
