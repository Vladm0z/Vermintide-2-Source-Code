-- chunkname: @scripts/managers/conflict_director/gathering.lua

Gathering = class(Gathering)

Gathering.init = function (arg_1_0, arg_1_1, arg_1_2, arg_1_3)
	arg_1_3 = arg_1_3 or Vector3(0, 0, 0)
	arg_1_0.traverse_logic = arg_1_2
	arg_1_0.balls = {}
	arg_1_0.static_units = {}
	arg_1_0.num_balls = 0
	arg_1_0.dogpiled_attackers_on_unit = {}
	arg_1_0.selected_ball = nil
	arg_1_0.debug_draw = false
	arg_1_0.nav_world = arg_1_1
	arg_1_0.ball_broadphase = Broadphase(1, 128)
	arg_1_0.lookup_broadphase_id = {}
	arg_1_0.target_unit_to_ball_lookup = {}
	arg_1_0.version = "fast"
	arg_1_0.last_index = 1
end

local var_0_0 = {
	"red",
	"blue",
	"green",
	"yellow"
}

Gathering.write_dogpiled_attackers = function (arg_2_0, arg_2_1)
	local var_2_0 = ""
	local var_2_1 = Managers.state.side:sides()

	for iter_2_0 = 1, #var_2_1 do
		local var_2_2 = var_2_1[iter_2_0]
		local var_2_3 = var_2_2._units
		local var_2_4 = var_2_2.side_id

		for iter_2_1 = 1, #var_2_3 do
			local var_2_5 = var_2_3[iter_2_1]
			local var_2_6 = var_0_0[var_2_4] or "white"
			local var_2_7 = Colors.get(var_2_6)
			local var_2_8 = POSITION_LOOKUP[var_2_5]
			local var_2_9 = BLACKBOARDS[var_2_5]
			local var_2_10 = var_2_9 and var_2_9.breed

			if var_2_10 and not var_2_10.is_player then
				local var_2_11 = arg_2_1[var_2_5]

				if var_2_11 and next(var_2_11) then
					var_2_0 = var_2_0 .. " | ("

					local var_2_12 = true

					for iter_2_2, iter_2_3 in pairs(var_2_11) do
						var_2_0 = var_2_0 .. (var_2_12 and "" or ", ") .. tostring(Unit.get_data(iter_2_2, "unique_id"))
						var_2_12 = false
					end

					var_2_0 = var_2_0 .. ") -> u" .. tostring(Unit.get_data(var_2_5, "unique_id"))
				end
			end
		end
	end

	Debug.text("Dogpiled: %s", var_2_0)
end

Gathering.draw = function (arg_3_0)
	if script_data.debug_gathering then
		Debug.text("balls=%d, bchecks=%d, uchecks=%d", arg_3_0.num_balls, arg_3_0.num_boid_checks or 0, arg_3_0.num_unit_checks or 0)
	end

	local var_3_0 = arg_3_0.dogpiled_attackers_on_unit
	local var_3_1 = arg_3_0.balls
	local var_3_2 = Color(0, 200, 200)
	local var_3_3 = Color(70, 200, 0)
	local var_3_4 = ""

	for iter_3_0 = 1, arg_3_0.num_balls do
		local var_3_5 = var_3_1[iter_3_0]
		local var_3_6 = var_3_5.pos
		local var_3_7 = var_0_0[var_3_5.side_id] or "white"
		local var_3_8 = Colors.get(var_3_7)
		local var_3_9 = Vector3(var_3_6[1], var_3_6[2], var_3_6[3] + 0.01)

		QuickDrawer:circle(var_3_9, var_3_5.rad, Vector3.up(), var_3_8)

		if var_3_5.target_unit and var_3_5.owner_unit then
			local var_3_10 = POSITION_LOOKUP[var_3_5.owner_unit]

			QuickDrawer:line(var_3_9, var_3_10, var_3_8)
		end

		local var_3_11 = var_3_0[var_3_5.owner_unit]
		local var_3_12 = var_3_11 and table.size(var_3_11) or 0

		var_3_4 = var_3_4 .. " | " .. var_3_5.id .. "(" .. var_3_12 .. ")"
	end

	if script_data.debug_gathering then
		Debug.text("Balls: %s", var_3_4)
	end

	if arg_3_0.version == "fast" and script_data.debug_gathering then
		arg_3_0:write_dogpiled_attackers(var_3_0)
	end
end

Gathering.respawn_balls = function (arg_4_0, arg_4_1, arg_4_2)
	for iter_4_0 = 1, 100 do
		arg_4_0:add_ball(arg_4_1 + Vector3(math.random() * 10 - 5, math.random() * 10 - 5, 0), math.random() + 0.25, nil, arg_4_2)
	end
end

Gathering.add_static_ball = function (arg_5_0, arg_5_1, arg_5_2, arg_5_3)
	local var_5_0 = arg_5_0:add_ball(arg_5_1, arg_5_2, arg_5_3, nil, true)

	arg_5_0.static_units[arg_5_3] = var_5_0
end

Gathering.remove_static_ball = function (arg_6_0, arg_6_1)
	local var_6_0 = arg_6_0.static_units[arg_6_1].id

	arg_6_0:remove_ball(var_6_0)

	arg_6_0.static_units[arg_6_1] = nil
end

Gathering.add_ball = function (arg_7_0, arg_7_1, arg_7_2, arg_7_3, arg_7_4, arg_7_5)
	fassert(arg_7_3 ~= arg_7_4, "Wut?!? can't have yourself as your target")

	local var_7_0 = arg_7_0.balls
	local var_7_1 = arg_7_0.num_balls + 1
	local var_7_2 = Managers.state.side.side_by_unit[arg_7_3] or Managers.state.side:sides(1)
	local var_7_3 = arg_7_0.version == "fast" and Broadphase.add(arg_7_0.ball_broadphase, nil, arg_7_1, arg_7_2) or nil
	local var_7_4 = {
		id = var_7_1,
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
		broadphase_id = var_7_3
	}

	var_7_0[var_7_1] = var_7_4
	arg_7_0.num_balls = var_7_1
	arg_7_0.target_unit_to_ball_lookup[arg_7_4] = var_7_4
	arg_7_0.lookup_broadphase_id[var_7_3] = var_7_4

	local var_7_5 = arg_7_0.dogpiled_attackers_on_unit[arg_7_4]

	if not var_7_5 then
		arg_7_0.dogpiled_attackers_on_unit[arg_7_4] = {
			[arg_7_3] = var_7_4
		}

		return var_7_4
	end

	var_7_5[arg_7_3] = var_7_4

	return var_7_4
end

Gathering.remove_ball = function (arg_8_0, arg_8_1)
	if arg_8_1.destroyed then
		return
	end

	arg_8_0.dogpiled_attackers_on_unit[arg_8_1.target_unit][arg_8_1.owner_unit] = nil

	local var_8_0 = arg_8_0.balls
	local var_8_1 = arg_8_1.id

	arg_8_0.target_unit_to_ball_lookup[arg_8_1.target_unit] = nil

	local var_8_2 = arg_8_1.broadphase_id

	if arg_8_0.version == "fast" then
		Broadphase.remove(arg_8_0.ball_broadphase, var_8_2)
	end

	arg_8_0.lookup_broadphase_id[var_8_2] = nil

	local var_8_3 = arg_8_0.num_balls

	arg_8_1.destroyed = true

	local var_8_4 = var_8_0[var_8_3]

	var_8_0[var_8_1] = var_8_4
	var_8_4.id = var_8_1
	var_8_0[var_8_3] = nil
	arg_8_0.num_balls = var_8_3 - 1
end

Gathering.release_attacking_balls = function (arg_9_0, arg_9_1)
	return
end

Gathering.notify_attackers = function (arg_10_0, arg_10_1)
	notify_attackers(arg_10_1, arg_10_0.dogpiled_attackers_on_unit)
end

function notify_attackers(arg_11_0, arg_11_1)
	local var_11_0 = arg_11_1[arg_11_0]

	if not var_11_0 then
		return
	end

	for iter_11_0, iter_11_1 in pairs(var_11_0) do
		fassert(iter_11_0 ~= arg_11_0, "Waat, unit is enemy of itself?")

		local var_11_1 = ScriptUnit.has_extension(iter_11_0, "ai_slot_system")

		if var_11_1 then
			var_11_1:_detach_from_ai_slot("notify_attackers")
		end
	end

	table.clear(var_11_0)
end

local function var_0_1(arg_12_0, arg_12_1, arg_12_2, arg_12_3, arg_12_4, arg_12_5)
	return (arg_12_0 - arg_12_3) * (arg_12_0 - arg_12_3) + (arg_12_1 - arg_12_4) * (arg_12_1 - arg_12_4) <= (arg_12_2 + arg_12_5) * (arg_12_2 + arg_12_5)
end

local var_0_2 = {}

Gathering.overlap_update = function (arg_13_0, arg_13_1, arg_13_2)
	local var_13_0 = AiUtils.broadphase_query

	for iter_13_0 = 1, arg_13_0.num_balls do
		local var_13_1 = var_13_0(position, 3, var_0_2)
	end
end

Gathering.slot_vs_slot_overlap = function (arg_14_0, arg_14_1, arg_14_2, arg_14_3, arg_14_4, arg_14_5, arg_14_6)
	local var_14_0 = Vector3.distance(Vector3(arg_14_1[1], arg_14_1[2], 0), Vector3(arg_14_3[1], arg_14_3[2], 0))

	if var_14_0 < 0.001 then
		arg_14_1[1] = arg_14_1[1] - arg_14_2 * 0.1
		arg_14_3[2] = arg_14_3[2] - arg_14_2 * 0.1

		return
	end

	local var_14_1 = (var_14_0 - arg_14_2 - arg_14_4) * 0.5

	if var_14_1 < 0 then
		arg_14_1[1] = arg_14_1[1] - var_14_1 * (arg_14_1[1] - arg_14_3[1]) / var_14_0
		arg_14_1[2] = arg_14_1[2] - var_14_1 * (arg_14_1[2] - arg_14_3[2]) / var_14_0
		arg_14_3[1] = arg_14_3[1] + var_14_1 * (arg_14_1[1] - arg_14_3[1]) / var_14_0
		arg_14_3[2] = arg_14_3[2] + var_14_1 * (arg_14_1[2] - arg_14_3[2]) / var_14_0
	end
end

Gathering.slot_vs_breed_overlap = function (arg_15_0, arg_15_1, arg_15_2, arg_15_3, arg_15_4, arg_15_5)
	local var_15_0 = Vector3.distance(Vector3(arg_15_1[1], arg_15_1[2], 0), Vector3(arg_15_3[1], arg_15_3[2], 0))

	if var_15_0 < 0.001 then
		arg_15_1[1] = arg_15_1[1] - arg_15_2 * 0.1

		return
	end

	local var_15_1 = var_15_0 - arg_15_2 - arg_15_4

	if var_15_1 < 0 then
		arg_15_1[1] = arg_15_1[1] - var_15_1 * (arg_15_1[1] - arg_15_3[1]) / var_15_0
		arg_15_1[2] = arg_15_1[2] - var_15_1 * (arg_15_1[2] - arg_15_3[2]) / var_15_0
	end
end

Gathering.update_efficient = function (arg_16_0, arg_16_1, arg_16_2)
	local var_16_0 = arg_16_0.nav_world
	local var_16_1 = arg_16_0.balls
	local var_16_2 = AiUtils.broadphase_query
	local var_16_3 = arg_16_0.ball_broadphase
	local var_16_4 = arg_16_0.lookup_broadphase_id
	local var_16_5 = 0
	local var_16_6 = 0
	local var_16_7 = 10
	local var_16_8 = arg_16_0.last_index
	local var_16_9 = arg_16_0.last_index + var_16_7

	if var_16_9 >= arg_16_0.num_balls then
		arg_16_0.last_index = 1
		var_16_9 = arg_16_0.num_balls
	else
		arg_16_0.last_index = var_16_9 + 1
	end

	for iter_16_0 = var_16_8, var_16_9 do
		repeat
			local var_16_10 = var_16_1[iter_16_0]
			local var_16_11 = var_16_10.side_id
			local var_16_12 = var_16_10.pos
			local var_16_13 = var_16_10.rad
			local var_16_14 = POSITION_LOOKUP[var_16_10.target_unit]

			if not var_16_14 then
				break
			end

			var_16_12[1] = var_16_12[1] - (var_16_12[1] - var_16_14[1]) * arg_16_2
			var_16_12[2] = var_16_12[2] - (var_16_12[2] - var_16_14[2]) * arg_16_2
			var_16_12[3] = var_16_14[3]

			local var_16_15 = Vector3(var_16_12[1], var_16_12[2], 0)
			local var_16_16 = Broadphase.query(var_16_3, var_16_15, 1, var_0_2)

			for iter_16_1 = 1, var_16_16 do
				local var_16_17 = var_16_4[var_0_2[iter_16_1]]

				if var_16_17 ~= var_16_10 then
					arg_16_0:slot_vs_slot_overlap(var_16_12, var_16_13, var_16_17.pos, var_16_17.rad, var_16_10, var_16_17)

					var_16_5 = var_16_5 + 1
				end
			end

			local var_16_18 = Vector3(var_16_12[1], var_16_12[2], var_16_12[3])
			local var_16_19 = 2.2 + var_16_13
			local var_16_20 = var_16_2(var_16_18, var_16_19, var_0_2)

			for iter_16_2 = 1, var_16_20 do
				local var_16_21 = var_0_2[iter_16_2]

				if var_16_11 ~= BLACKBOARDS[var_16_21].side.side_id then
					local var_16_22 = var_0_2[iter_16_2]
					local var_16_23 = POSITION_LOOKUP[var_16_22]
					local var_16_24 = 2.2

					arg_16_0:slot_vs_breed_overlap(var_16_12, var_16_13, var_16_23, var_16_24, var_16_10)

					var_16_6 = var_16_6 + 1
				end
			end
		until true
	end

	local var_16_25 = arg_16_0.traverse_logic

	for iter_16_3 = 1, arg_16_0.num_balls do
		local var_16_26 = var_16_1[iter_16_3]
		local var_16_27 = var_16_26.pos
		local var_16_28 = var_16_26.last_pos

		if Vector3.distance_squared(Vector3(var_16_27[1], var_16_27[2], var_16_27[3]), Vector3(var_16_28[1], var_16_28[2], var_16_28[3])) > 0.0001 then
			local var_16_29 = Vector3(var_16_27[1], var_16_27[2], var_16_27[3])
			local var_16_30 = POSITION_LOOKUP[var_16_26.target_unit]

			if var_16_30 then
				local var_16_31, var_16_32 = GwNavQueries.raycast(var_16_0, var_16_30, var_16_29, var_16_25)

				var_16_29 = var_16_32
			end

			local var_16_33 = Vector3(var_16_29[1], var_16_29[2], 0)

			Broadphase.move(var_16_3, var_16_26.broadphase_id, var_16_33)

			var_16_27[1], var_16_27[2], var_16_27[3] = var_16_29[1], var_16_29[2], var_16_29[3]
			var_16_28[1], var_16_28[2], var_16_28[3] = var_16_29[1], var_16_29[2], var_16_29[3]
		end
	end

	arg_16_0.num_boid_checks = var_16_5
	arg_16_0.num_unit_checks = var_16_6
end

Gathering.update_brute_force = function (arg_17_0, arg_17_1, arg_17_2)
	local var_17_0 = arg_17_0.nav_world
	local var_17_1 = arg_17_0.balls

	for iter_17_0 = 1, arg_17_0.num_balls do
		local var_17_2 = var_17_1[iter_17_0]
		local var_17_3 = var_17_2.pos
		local var_17_4 = var_17_2.rad
		local var_17_5 = var_17_2.target_unit

		if var_17_5 then
			local var_17_6 = POSITION_LOOKUP[var_17_5]

			var_17_6 = GwNavQueries.inside_position_from_outside_position(var_17_0, var_17_6, 2, 2) or var_17_6
			var_17_3[1] = var_17_3[1] - (var_17_3[1] - var_17_6[1]) * arg_17_2
			var_17_3[2] = var_17_3[2] - (var_17_3[2] - var_17_6[2]) * arg_17_2
		elseif var_17_2.is_static then
			local var_17_7 = POSITION_LOOKUP[var_17_2.owner_unit]

			var_17_3[1] = var_17_7.x
			var_17_3[2] = var_17_7.y
		end

		local var_17_8 = var_17_2.is_static
		local var_17_9 = not var_17_8
		local var_17_10 = var_17_2.side_id
		local var_17_11 = AiUtils.broadphase_query

		for iter_17_1 = 1, arg_17_0.num_balls do
			local var_17_12 = var_17_1[iter_17_1]
			local var_17_13 = var_17_12.is_static
			local var_17_14 = not var_17_13
			local var_17_15 = var_17_12.side_id ~= var_17_10
			local var_17_16 = not var_17_15
			local var_17_17 = var_17_8 and var_17_14 and var_17_15
			local var_17_18 = var_17_13 and var_17_9 and var_17_15
			local var_17_19 = var_17_9 and var_17_14 and var_17_16

			if var_17_2 ~= var_17_12 and (var_17_17 or var_17_18 or var_17_19) then
				local var_17_20 = var_17_12.pos
				local var_17_21 = var_17_12.rad

				if var_0_1(var_17_3[1], var_17_3[2], var_17_4, var_17_20[1], var_17_20[2], var_17_21) then
					local var_17_22 = Vector3.distance(Vector3(var_17_3[1], var_17_3[2], 0), Vector3(var_17_20[1], var_17_20[2], 0))
					local var_17_23 = (var_17_22 - var_17_4 - var_17_21) * 0.5

					var_17_3[1] = var_17_3[1] - var_17_23 * (var_17_3[1] - var_17_20[1]) / var_17_22
					var_17_3[2] = var_17_3[2] - var_17_23 * (var_17_3[2] - var_17_20[2]) / var_17_22
					var_17_20[1] = var_17_20[1] + var_17_23 * (var_17_3[1] - var_17_20[1]) / var_17_22
					var_17_20[2] = var_17_20[2] + var_17_23 * (var_17_3[2] - var_17_20[2]) / var_17_22
				end
			end
		end
	end
end

Gathering.update = function (arg_18_0, arg_18_1, arg_18_2)
	arg_18_0:update_efficient(arg_18_1, arg_18_2)

	if arg_18_0.debug_draw then
		arg_18_0:draw()
	end
end
