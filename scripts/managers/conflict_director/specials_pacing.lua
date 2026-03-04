-- chunkname: @scripts/managers/conflict_director/specials_pacing.lua

SpecialsPacing = class(SpecialsPacing)

SpecialsPacing.init = function (arg_1_0, arg_1_1, arg_1_2, arg_1_3, arg_1_4)
	arg_1_0._level = LevelHelper:current_level(arg_1_1)
	arg_1_0._nav_tag_volume_handler = arg_1_3
	arg_1_0.nav_world = arg_1_2
	arg_1_0._specials_timer = 0
	arg_1_0._disabled = false
	arg_1_0._specials_spawn_queue = {}
	arg_1_0._specials_slots = {}
	arg_1_0._state_data = {}
	arg_1_0._side = arg_1_4
	arg_1_0.method_name = CurrentSpecialsSettings.spawn_method

	arg_1_0:remove_unwanted_breeds()
end

SpecialsPacing.remove_unwanted_breeds = function (arg_2_0)
	print("SpecialsPacing:remove_unwanted_breeds:")

	for iter_2_0, iter_2_1 in pairs(SpecialsSettings) do
		local var_2_0 = iter_2_1.breeds

		if var_2_0 then
			for iter_2_2 = #var_2_0, 1, -1 do
				local var_2_1 = var_2_0[iter_2_2]

				if Breeds[var_2_1].disabled then
					print("remove_unwanted_breeds", var_2_1)
					table.remove(var_2_0, iter_2_2)
				end
			end
		end

		local var_2_2 = iter_2_1.rush_intervention and iter_2_1.rush_intervention.breeds

		if var_2_2 then
			for iter_2_3 = #var_2_2, 1, -1 do
				local var_2_3 = var_2_2[iter_2_3]

				if Breeds[var_2_3].disabled then
					print("remove_unwanted_breeds", var_2_3)
					table.remove(var_2_2, iter_2_3)
				end
			end
		end
	end
end

SpecialsPacing.start = function (arg_3_0)
	if arg_3_0.method_name then
		arg_3_0.method_data = CurrentSpecialsSettings.methods[arg_3_0.method_name]

		assert(arg_3_0.method_data, "Missing 'spawn_method' in SpecialsSettings")

		if SpecialsPacing.setup_functions[arg_3_0.method_name] then
			local var_3_0 = Managers.time:time("game")

			SpecialsPacing.setup_functions[arg_3_0.method_name](var_3_0, arg_3_0._specials_slots, arg_3_0.method_data, arg_3_0._state_data)
		end
	end
end

local var_0_0 = {
	"chaos_spawn",
	"skaven_rat_ogre",
	"skaven_stormfiend",
	"chaos_troll"
}

SpecialsPacing.setup_functions = {
	specials_by_slots = function (arg_4_0, arg_4_1, arg_4_2, arg_4_3)
		local var_4_0 = CurrentSpecialsSettings

		if #var_4_0.breeds == 0 then
			return
		end

		local var_4_1
		local var_4_2 = 2

		if arg_4_2.always_coordinated then
			var_4_1 = arg_4_0 + ConflictUtils.random_interval(arg_4_2.after_safe_zone_delay)
			arg_4_3.coordinated_timer = var_4_1

			if arg_4_2.same_breeds then
				local var_4_3 = var_4_0.breeds

				arg_4_3.override_breed_name = var_4_3[Math.random(1, #var_4_3)]
			end
		end

		arg_4_3.coord_time_check = arg_4_0

		for iter_4_0 = 1, var_4_0.max_specials do
			local var_4_4, var_4_5 = SpecialsPacing.select_breed_functions[arg_4_2.select_next_breed](arg_4_1, var_4_0, arg_4_2, arg_4_3)
			local var_4_6 = var_4_1 or arg_4_0 + ConflictUtils.random_interval(arg_4_2.after_safe_zone_delay)
			local var_4_7 = Breeds[var_4_4]
			local var_4_8
			local var_4_9

			if var_4_7.special_spawn_stinger then
				var_4_8 = var_4_7.special_spawn_stinger
				var_4_9 = var_4_6 - (var_4_7.special_spawn_stinger_time or 6)
			end

			arg_4_1[iter_4_0] = {
				state = "waiting",
				breed = var_4_4,
				time = var_4_6,
				health_modifier = var_4_5,
				special_spawn_stinger = var_4_8,
				special_spawn_stinger_at_t = var_4_9
			}
		end
	end
}
SpecialsPacing.select_breed_functions = {
	get_least_used_breeds = function (arg_5_0, arg_5_1, arg_5_2, arg_5_3)
		local var_5_0 = FrameTable.alloc_table()

		if #arg_5_0 == 0 then
			return
		end

		for iter_5_0 = 1, #arg_5_0 do
			local var_5_1 = arg_5_0[iter_5_0]

			var_5_0[var_5_1.breed] = (var_5_0[var_5_1.breed] or 0) + 1
		end

		local var_5_2 = FrameTable.alloc_table()
		local var_5_3 = math.huge

		for iter_5_1, iter_5_2 in pairs(var_5_0) do
			local var_5_4 = var_5_0[iter_5_1]

			if var_5_4 < var_5_3 then
				var_5_3 = var_5_4

				table.clear(var_5_2)
			end

			if var_5_4 <= var_5_3 then
				var_5_2[#var_5_2 + 1] = iter_5_1
			end
		end

		return var_5_2
	end,
	get_random_breed = function (arg_6_0, arg_6_1, arg_6_2, arg_6_3)
		if arg_6_3.override_breed_name then
			return arg_6_3.override_breed_name
		end

		local var_6_0 = arg_6_1.breeds
		local var_6_1 = #var_6_0

		if var_6_1 <= 0 then
			return nil
		end

		local var_6_2 = FrameTable.alloc_table()

		for iter_6_0 = 1, #arg_6_0 do
			local var_6_3 = arg_6_0[iter_6_0]

			var_6_2[var_6_3.breed] = (var_6_2[var_6_3.breed] or 0) + 1
		end

		local var_6_4 = 20
		local var_6_5
		local var_6_6 = 0

		repeat
			var_6_5 = var_6_0[Math.random(1, var_6_1)]
			var_6_6 = var_6_6 + 1
		until not var_6_2[var_6_5] or var_6_2[var_6_5] < arg_6_2.max_of_same or var_6_4 <= var_6_6

		return var_6_5
	end,
	get_same_breed = function (arg_7_0, arg_7_1, arg_7_2, arg_7_3, arg_7_4)
		if arg_7_3.override_breed_name then
			return arg_7_3.override_breed_name
		end

		local var_7_0 = arg_7_1.breeds
		local var_7_1 = arg_7_3.batch_amount or 0
		local var_7_2 = Managers.time:time("game")

		if not arg_7_3.batch_breed or arg_7_4 and var_7_2 > arg_7_3.coord_time_check or var_7_1 > arg_7_1.max_specials then
			arg_7_3.batch_amount = 0
			arg_7_3.batch_breed = var_7_0[Math.random(1, #var_7_0)]

			if arg_7_4 then
				arg_7_3.coord_time_check = var_7_2 + 15
			end
		end

		arg_7_3.batch_amount = arg_7_3.batch_amount + 1

		return arg_7_3.batch_breed
	end,
	get_chance_of_boss_breed = function (arg_8_0, arg_8_1, arg_8_2, arg_8_3)
		local var_8_0 = arg_8_1.breeds
		local var_8_1 = Math.random() <= 0.25
		local var_8_2

		if var_8_1 then
			var_8_2 = var_0_0[math.random(1, #var_0_0)]

			local var_8_3 = 0.25

			return var_8_2, var_8_3
		else
			local var_8_4 = FrameTable.alloc_table()

			for iter_8_0 = 1, #arg_8_0 do
				local var_8_5 = arg_8_0[iter_8_0]

				var_8_4[var_8_5.breed] = (var_8_4[var_8_5.breed] or 0) + 1
			end

			local var_8_6 = 20
			local var_8_7 = 0

			repeat
				local var_8_8 = Math.random(1, #var_8_0)

				var_8_2 = arg_8_3.override_breed_name or var_8_0[var_8_8]
				var_8_7 = var_8_7 + 1
			until not var_8_4[var_8_2] or var_8_4[var_8_2] < arg_8_2.max_of_same or var_8_6 <= var_8_7
		end

		return var_8_2
	end
}

SpecialsPacing._set_next_coordinated_attack = function (arg_9_0, arg_9_1, arg_9_2, arg_9_3, arg_9_4, arg_9_5)
	local var_9_0 = arg_9_0._state_data
	local var_9_1
	local var_9_2

	if arg_9_3.same_breeds then
		local var_9_3 = arg_9_2.breeds

		var_9_0.override_breed_name = var_9_3[Math.random(1, #var_9_3)]

		local var_9_4 = arg_9_3.coordinated_trickle_time
	end

	local var_9_5 = arg_9_1 + ConflictUtils.random_interval(arg_9_3.spawn_cooldown)

	for iter_9_0 = 1, #arg_9_4 do
		local var_9_6 = arg_9_4[iter_9_0]
		local var_9_7, var_9_8 = SpecialsPacing.select_breed_functions[arg_9_3.select_next_breed](arg_9_4, arg_9_2, arg_9_3, var_9_0)
		local var_9_9 = Breeds[var_9_7]
		local var_9_10 = arg_9_3.coordinated_trickle_time

		var_9_5 = var_9_5 + (var_9_10 and iter_9_0 * var_9_10 or 2)

		if var_9_9.special_spawn_stinger then
			var_9_6.special_spawn_stinger = var_9_9.special_spawn_stinger
			var_9_6.special_spawn_stinger_at_t = var_9_5 - (var_9_9.special_spawn_stinger_time or 6)
		else
			var_9_6.special_spawn_stinger = nil
			var_9_6.special_spawn_stinger_at_t = nil
		end

		var_9_6.time = var_9_5
		var_9_6.breed = var_9_7
		var_9_6.unit = nil
		var_9_6.state = "waiting"
		var_9_6.health_modifier = var_9_8
		var_9_6.desc = "coordinated attack"
		arg_9_5[#arg_9_5 + 1] = var_9_6
	end

	var_9_0.coordinated_timer = var_9_5 + 1
end

SpecialsPacing.specials_by_slots = function (arg_10_0, arg_10_1, arg_10_2, arg_10_3, arg_10_4, arg_10_5)
	local var_10_0 = #arg_10_4
	local var_10_1 = 0
	local var_10_2 = false

	if arg_10_3.always_coordinated then
		if arg_10_1 > arg_10_0._state_data.coordinated_timer then
			arg_10_0:_set_next_coordinated_attack(arg_10_1, arg_10_2, arg_10_3, arg_10_4, arg_10_5)
		end

		arg_10_0._specials_timer = arg_10_1 + 1

		return
	end

	for iter_10_0 = 1, var_10_0 do
		local var_10_3 = arg_10_4[iter_10_0]

		if var_10_3.state == "waiting" then
			if arg_10_1 > var_10_3.time then
				var_10_3.unit = nil
				arg_10_5[#arg_10_5 + 1] = var_10_3
				var_10_3.state = arg_10_3.always_coordinated and "coordinating" or "wants_to_spawn"
				var_10_3.time = nil
				var_10_3.dest = ""
			else
				var_10_1 = var_10_1 + 1
			end

			if var_10_3.special_spawn_stinger and arg_10_1 > var_10_3.special_spawn_stinger_at_t then
				arg_10_0:_play_stinger(var_10_3.special_spawn_stinger, var_10_3)

				var_10_3.special_spawn_stinger = nil
				var_10_3.special_spawn_stinger_at_t = nil
			end
		end

		if var_10_3.state == "alive" and not HEALTH_ALIVE[var_10_3.unit] then
			local var_10_4, var_10_5 = SpecialsPacing.select_breed_functions[arg_10_3.select_next_breed](arg_10_4, arg_10_2, arg_10_3, arg_10_0._state_data)
			local var_10_6 = Breeds[var_10_4]
			local var_10_7 = arg_10_1 + ConflictUtils.random_interval(arg_10_3.spawn_cooldown)

			if var_10_6.special_spawn_stinger then
				var_10_3.special_spawn_stinger = var_10_6.special_spawn_stinger
				var_10_3.special_spawn_stinger_at_t = var_10_7 - (var_10_6.special_spawn_stinger_time or 6)
			else
				var_10_3.special_spawn_stinger = nil
				var_10_3.special_spawn_stinger_at_t = nil
			end

			var_10_3.time = var_10_7
			var_10_3.breed = var_10_4
			var_10_3.unit = nil
			var_10_3.state = "waiting"
			var_10_3.desc = ""
			var_10_3.health_modifier = var_10_5
			var_10_2 = true
			var_10_1 = var_10_1 + 1
		end
	end

	if var_10_2 and var_10_1 == var_10_0 then
		local var_10_8 = Math.random() <= arg_10_3.chance_of_coordinated_attack

		if var_10_8 then
			print("Coordinated attack!")

			local var_10_9 = arg_10_1 + 40
			local var_10_10 = 0
			local var_10_11 = arg_10_3.coordinated_attack_cooldown_multiplier or 0.5

			for iter_10_1 = 1, var_10_0 do
				var_10_10 = var_10_10 + arg_10_4[iter_10_1].time
			end

			if var_10_10 > 0 then
				var_10_9 = arg_10_1 + (var_10_10 / var_10_0 - arg_10_1) * var_10_11
			end

			local var_10_12 = arg_10_0._state_data

			for iter_10_2 = 1, var_10_0 do
				local var_10_13 = arg_10_4[iter_10_2]
				local var_10_14, var_10_15 = SpecialsPacing.select_breed_functions[arg_10_3.select_next_breed](arg_10_4, arg_10_2, arg_10_3, var_10_12, var_10_8)
				local var_10_16 = Breeds[var_10_14]
				local var_10_17 = var_10_9 + (arg_10_3.coordinated_trickle_time and iter_10_2 * arg_10_3.coordinated_trickle_time or iter_10_2 * 2)

				if var_10_16.special_spawn_stinger then
					var_10_13.special_spawn_stinger = var_10_16.special_spawn_stinger
					var_10_13.special_spawn_stinger_at_t = var_10_17 - (var_10_16.special_spawn_stinger_time or 6)
				else
					var_10_13.special_spawn_stinger = nil
					var_10_13.special_spawn_stinger_at_t = nil
				end

				var_10_13.time = var_10_17
				var_10_13.breed = var_10_14
				var_10_13.unit = nil
				var_10_13.state = "waiting"
				var_10_13.health_modifier = var_10_15

				local var_10_18 = true

				var_10_13.desc = "coordinated attack"
			end
		end
	end

	arg_10_0._specials_timer = arg_10_1 + 1
end

SpecialsPacing.specials_by_time_window = function (arg_11_0, arg_11_1, arg_11_2, arg_11_3, arg_11_4, arg_11_5, arg_11_6)
	if arg_11_1 > arg_11_0._specials_timer then
		local var_11_0 = #arg_11_6
		local var_11_1 = 1

		while var_11_1 <= var_11_0 do
			local var_11_2 = arg_11_6[var_11_1]

			if not ALIVE[var_11_2] then
				arg_11_6[var_11_1] = arg_11_6[var_11_0]
				arg_11_6[var_11_0] = nil
				var_11_0 = var_11_0 - 1
			else
				var_11_1 = var_11_1 + 1
			end
		end

		local var_11_3 = arg_11_2.max_specials

		if var_11_0 + #arg_11_4 <= 0 then
			local var_11_4 = ConflictUtils.random_interval(arg_11_3.lull_time)
			local var_11_5 = arg_11_2.breeds

			if arg_11_3.even_out_breeds and var_11_3 > 1 then
				local var_11_6 = table.clone(var_11_5)
				local var_11_7 = 0

				for iter_11_0 = 1, var_11_3 do
					if var_11_7 <= 0 then
						table.shuffle(var_11_6)

						var_11_7 = #var_11_6
					end

					arg_11_4[iter_11_0] = {
						breed = var_11_6[var_11_7]
					}
					var_11_7 = var_11_7 - 1
				end
			else
				for iter_11_1 = 1, var_11_3 do
					arg_11_4[iter_11_1].breed = var_11_5[Math.random(1, #var_11_5)]
				end
			end

			local var_11_8 = ConflictUtils.random_interval(arg_11_3.spawn_interval)
			local var_11_9 = 0
			local var_11_10 = {}

			for iter_11_2 = 1, var_11_3 do
				var_11_9 = var_11_9 + Math.random()
				var_11_10[iter_11_2] = var_11_9
			end

			local var_11_11

			for iter_11_3 = 1, var_11_3 do
				local var_11_12 = arg_11_1 + var_11_10[var_11_3 - iter_11_3 + 1] / var_11_9 * var_11_8 + var_11_4

				arg_11_4[iter_11_3].time = var_11_12
			end

			arg_11_0._specials_timer = arg_11_1 + var_11_4

			table.clear(arg_11_5)
		end

		local var_11_13 = arg_11_4[#arg_11_4]

		if var_11_13 and arg_11_1 > var_11_13.time then
			arg_11_4[#arg_11_4] = nil
			arg_11_5[#arg_11_5 + 1] = var_11_13
		end

		arg_11_0._specials_timer = arg_11_1 + 1
	end
end

SpecialsPacing.enable = function (arg_12_0, arg_12_1)
	arg_12_0._disabled = not arg_12_1
end

SpecialsPacing.is_disabled = function (arg_13_0)
	return arg_13_0._disabled
end

local function var_0_1(arg_14_0, arg_14_1, arg_14_2)
	local var_14_0 = arg_14_2.slot
	local var_14_1 = arg_14_2.alive_specials

	var_14_0.unit = arg_14_0
	var_14_0.state = "alive"

	if arg_14_1.special then
		var_14_1[#var_14_1 + 1] = arg_14_0
	end
end

SpecialsPacing.update = function (arg_15_0, arg_15_1, arg_15_2, arg_15_3, arg_15_4)
	local var_15_0 = CurrentSpecialsSettings

	if var_15_0.disabled then
		return
	end

	if arg_15_0._disabled then
		return
	end

	if arg_15_3 < 1 then
		return
	end

	local var_15_1 = arg_15_0._specials_spawn_queue

	if arg_15_1 > arg_15_0._specials_timer then
		if Managers.state.conflict.delay_specials then
			arg_15_0._specials_timer = arg_15_1 + 3
		else
			local var_15_2 = var_15_0.methods[var_15_0.spawn_method]

			SpecialsPacing[arg_15_0.method_name](arg_15_0, arg_15_1, var_15_0, var_15_2, arg_15_0._specials_slots, var_15_1, arg_15_2)
		end

		if #var_15_1 > 0 then
			local var_15_3 = var_15_1[#var_15_1]
			local var_15_4 = Breeds[var_15_3.breed]
			local var_15_5 = arg_15_0:get_special_spawn_pos(var_15_4.spawning_rule)

			if var_15_5 then
				local var_15_6 = {
					spawned_func = var_0_1,
					alive_specials = arg_15_2,
					slot = var_15_3,
					parent = arg_15_0,
					max_health_modifier = var_15_3.health_modifier
				}

				Managers.state.conflict:spawn_queued_unit(var_15_4, Vector3Box(var_15_5), QuaternionBox(Vector3.up(), 0), "specials_pacing", nil, nil, var_15_6)

				var_15_3.state = "wants_to_spawn"
				var_15_3.spawn_type = nil
				var_15_1[#var_15_1] = nil
				arg_15_0._specials_timer = arg_15_1 + 0.5
				var_15_3.health_modifier = nil

				if var_15_3.special_spawn_stinger and not var_15_3.has_played_special_stinger then
					arg_15_0:_play_stinger(var_15_3.special_spawn_stinger, var_15_3)

					var_15_3.has_played_special_stinger = nil
				end

				var_15_3.special_spawn_stinger = nil
				var_15_3.special_spawn_stinger_at_t = nil
			else
				arg_15_0._specials_timer = arg_15_1 + 1
			end
		end
	end
end

SpecialsPacing.spawn_versus_darkpact_bot = function (arg_16_0, arg_16_1, arg_16_2, arg_16_3)
	local var_16_0 = Breeds[arg_16_1]
	local var_16_1 = arg_16_0:get_special_spawn_pos(var_16_0.spawning_rule)

	if var_16_1 then
		local var_16_2 = {
			spawned_func = arg_16_2,
			bot_data = arg_16_3
		}

		Managers.state.conflict:spawn_queued_unit(var_16_0, Vector3Box(var_16_1), QuaternionBox(Vector3.up(), 0), "specials_pacing", nil, nil, var_16_2)

		return true
	end
end

SpecialsPacing._play_stinger = function (arg_17_0, arg_17_1, arg_17_2)
	Managers.state.entity:system("audio_system"):play_2d_audio_event(arg_17_1)

	arg_17_2.has_played_special_stinger = true
end

SpecialsPacing.delay_spawning = function (arg_18_0, arg_18_1, arg_18_2, arg_18_3, arg_18_4)
	local var_18_0 = arg_18_0._specials_slots
	local var_18_1 = CurrentSpecialsSettings

	if var_18_1.disabled then
		return
	end

	local var_18_2 = var_18_1.methods[var_18_1.spawn_method]
	local var_18_3 = not arg_18_4 and Math.random() <= var_18_2.chance_of_coordinated_attack

	for iter_18_0 = 1, #var_18_0 do
		local var_18_4 = var_18_0[iter_18_0]
		local var_18_5, var_18_6 = SpecialsPacing.select_breed_functions[var_18_2.select_next_breed](var_18_0, var_18_1, var_18_2, arg_18_0._state_data)
		local var_18_7 = Breeds[var_18_5]
		local var_18_8
		local var_18_9
		local var_18_12

		if var_18_3 then
			local var_18_10 = var_18_2.coordinated_attack_cooldown_multiplier or 0.5
			local var_18_11 = arg_18_2 * var_18_10

			var_18_8 = arg_18_1 + var_18_10 + arg_18_3 * iter_18_0 * var_18_10
			var_18_12 = "coordinated attack"
		else
			var_18_8 = arg_18_1 + arg_18_2 + arg_18_3 * iter_18_0
			var_18_12 = ""
		end

		var_18_4.breed = var_18_5
		var_18_4.time = var_18_8
		var_18_4.unit = nil
		var_18_4.state = "waiting"
		var_18_4.desc = var_18_12
		var_18_4.health_modifier = var_18_6

		if var_18_7.special_spawn_stinger then
			var_18_4.special_spawn_stinger = var_18_7.special_spawn_stinger
			var_18_4.special_spawn_stinger_at_t = var_18_4.time - (var_18_7.special_spawn_stinger_time or 6)
		else
			var_18_4.special_spawn_stinger = nil
			var_18_4.special_spawn_stinger_at_t = nil
		end
	end

	local var_18_13 = arg_18_0._specials_spawn_queue

	for iter_18_1 = 1, #var_18_13 do
		var_18_13[iter_18_1] = nil
	end
end

SpecialsPacing.debug_spawn = function (arg_19_0)
	local var_19_0 = CurrentSpecialsSettings.breeds
	local var_19_1 = var_19_0[math.random(#var_19_0)]
	local var_19_2 = Breeds[var_19_1]
	local var_19_3 = arg_19_0:get_special_spawn_pos(var_19_2.spawning_rule)

	if var_19_3 then
		QuickDrawerStay:sphere(var_19_3, 4, Color(125, 255, 47))
		print("debug spawning special: ", var_19_1)

		local var_19_4

		Managers.state.conflict:spawn_queued_unit(var_19_2, Vector3Box(var_19_3), QuaternionBox(Quaternion(Vector3.up(), 0)), "specials_pacing", nil, nil, var_19_4)
	else
		print("debug spawning special could not find spawn position")
	end
end

SpecialsPacing.get_special_spawn_pos = function (arg_20_0, arg_20_1)
	local var_20_0 = Managers.state.conflict
	local var_20_1 = var_20_0.main_path_info
	local var_20_2 = var_20_0.main_path_player_info
	local var_20_3 = arg_20_0._level
	local var_20_4 = arg_20_0._nav_tag_volume_handler
	local var_20_5 = var_20_0.level_analysis:get_main_paths()
	local var_20_6 = arg_20_0._side
	local var_20_7, var_20_8, var_20_9, var_20_10 = var_20_0:get_cluster_and_loneliness(10, var_20_6.ENEMY_PLAYER_POSITIONS, var_20_6.ENEMY_PLAYER_UNITS)
	local var_20_11 = var_20_1.ahead_unit
	local var_20_12 = var_20_1.behind_unit
	local var_20_13
	local var_20_14 = false
	local var_20_15

	if not var_20_11 or not var_20_12 then
		var_20_13 = POSITION_LOOKUP[var_20_10]

		local var_20_16 = "specialspawn: loneliest -->"
	elseif arg_20_1 == "always_ahead" then
		var_20_13 = arg_20_0:get_relative_main_path_pos(var_20_5, var_20_2[var_20_11], 20)

		local var_20_17 = "specialspawn: rule: only_ahead -->"
	elseif var_20_9 > 10 then
		if var_20_11 == var_20_10 then
			var_20_13 = arg_20_0:get_relative_main_path_pos(var_20_5, var_20_2[var_20_11], 20)

			local var_20_18 = "specialspawn: ahead == lonliest -->"
		elseif var_20_12 == var_20_10 then
			var_20_13 = POSITION_LOOKUP[var_20_12]

			local var_20_19 = "specialspawn: behind == lonliest -->"
		else
			local var_20_20 = "specialspawn: random-pick -->"

			var_20_14 = true
		end
	else
		var_20_14 = true
	end

	if var_20_14 then
		if Math.random() < 0.75 then
			var_20_13 = arg_20_0:get_relative_main_path_pos(var_20_5, var_20_2[var_20_11], 10)

			local var_20_21 = "specialspawn: random infront"
		else
			var_20_13 = POSITION_LOOKUP[var_20_12]

			local var_20_22 = "specialspawn: random behind"
		end
	end

	if not var_20_13 then
		local var_20_23 = arg_20_0._side.ENEMY_PLAYER_POSITIONS

		var_20_13 = var_20_23[math.random(#var_20_23)]

		local var_20_24 = "specialspawn: fallback - epicenter around random player"
	end

	local var_20_25 = var_20_0._world
	local var_20_26 = arg_20_0._side.ENEMY_PLAYER_AND_BOT_POSITIONS
	local var_20_27 = LevelHelper.current_level_settings().check_no_spawn_volumes_for_special_spawning
	local var_20_28

	if var_20_13 then
		var_20_28 = ConflictUtils.get_hidden_pos(var_20_25, arg_20_0.nav_world, var_20_3, var_20_4, var_20_27, var_20_13, var_20_26, 30, 10, 225, 10)

		if not var_20_28 then
			local var_20_29 = ConflictUtils.get_random_hidden_spawner(var_20_13, 40)

			if var_20_29 then
				var_20_28 = Unit.local_position(var_20_29, 0)
			else
				var_20_28 = ConflictUtils.get_hidden_pos(var_20_25, arg_20_0.nav_world, var_20_3, var_20_4, var_20_27, var_20_13, var_20_26, 16, 5, 225, 3)
			end
		end
	end

	if not var_20_28 then
		return
	end

	return var_20_28
end

local function var_0_2(arg_21_0, arg_21_1, arg_21_2, arg_21_3, arg_21_4, arg_21_5, arg_21_6, arg_21_7)
	local var_21_0 = arg_21_7.ENEMY_PLAYER_AND_BOT_POSITIONS
	local var_21_1 = ConflictUtils.get_hidden_pos(arg_21_0, arg_21_1, arg_21_2, arg_21_3, arg_21_4, arg_21_5, var_21_0, 30, 10, arg_21_6, 15)

	if not var_21_1 then
		print("Intervention Spawn: Failed to find spawn pos, trying hidden spawner")

		local var_21_2 = ConflictUtils.get_random_hidden_spawner(arg_21_5, 40)

		if var_21_2 then
			var_21_1 = Unit.local_position(var_21_2, 0)
		else
			print("Intervention Spawn: Failed to find hidden spawner, trying random pos")

			var_21_1 = ConflictUtils.get_spawn_pos_on_circle(arg_21_1, arg_21_5, 30, 10, 20)
		end

		if not var_21_1 then
			print("Intervention Spawn: Failed to find spawn pos")

			return false, "Failed to find special spawn pos"
		end
	end

	return var_21_1
end

local function var_0_3(arg_22_0)
	local var_22_0
	local var_22_1 = 0
	local var_22_2 = #arg_22_0

	for iter_22_0 = 1, var_22_2 do
		local var_22_3 = arg_22_0[iter_22_0]

		if var_22_3.state == "waiting" and var_22_1 < var_22_3.time then
			var_22_0 = iter_22_0
			var_22_1 = var_22_3.time
		end
	end

	return var_22_0
end

local function var_0_4(arg_23_0, arg_23_1, arg_23_2)
	local var_23_0 = arg_23_2.slot

	var_23_0.breed = arg_23_1.name
	var_23_0.unit = arg_23_0
	var_23_0.time = nil
	var_23_0.state = "alive"
	var_23_0.desc = "rush intervention"

	local var_23_1 = arg_23_2.alive_specials

	var_23_1[#var_23_1 + 1] = arg_23_0

	print("rush intervention - spawning ", arg_23_1.name)
end

SpecialsPacing.request_rushing_intervention = function (arg_24_0, arg_24_1, arg_24_2, arg_24_3, arg_24_4, arg_24_5)
	if script_data.ai_specials_spawning_disabled or Managers.state.game_mode:setting("ai_specials_spawning_disabled") then
		return false, "specials spawning disabled"
	end

	if arg_24_5 and arg_24_5.specials then
		return false, "no intervention, since game mode disabled it"
	end

	if ScriptUnit.extension(arg_24_2, "status_system"):is_disabled() then
		return false, "no intervention, since ahead unit is disabled"
	end

	local var_24_0 = CurrentSpecialsSettings.rush_intervention.breeds

	if #var_24_0 <= 0 then
		print("No rush intervention breeds available. Cannot intervent rushing player by spawning a special (SpecialsSettings.specials.rush_intervention.breeds)")

		return false, "No rush intervention breeds set"
	end

	fassert(arg_24_3.ahead_unit, "Missing ahead unit in request_rushing_intervention")

	local var_24_1 = arg_24_0._specials_slots
	local var_24_2 = var_0_3(var_24_1)

	if var_24_2 then
		local var_24_3 = var_24_1[var_24_2]
		local var_24_4 = var_24_0[Math.random(1, #var_24_0)]
		local var_24_5 = Breeds[var_24_4]
		local var_24_6 = Managers.state.conflict
		local var_24_7 = var_24_6.level_analysis:get_main_paths()
		local var_24_8 = var_24_6._world
		local var_24_9 = arg_24_0.nav_world
		local var_24_10 = arg_24_0._level
		local var_24_11 = arg_24_0._nav_tag_volume_handler
		local var_24_12 = 25
		local var_24_13 = arg_24_0:get_relative_main_path_pos(var_24_7, arg_24_4[arg_24_3.ahead_unit], 20)
		local var_24_14 = LevelHelper.current_level_settings().check_no_spawn_volumes_for_special_spawning
		local var_24_15, var_24_16 = var_0_2(var_24_8, var_24_9, var_24_10, var_24_11, var_24_14, var_24_13, var_24_12, arg_24_0._side)

		if not var_24_15 then
			return false, var_24_16
		end

		local var_24_17 = var_24_6:alive_specials()
		local var_24_18 = {
			spawned_func = var_0_4,
			slot = var_24_3,
			alive_specials = var_24_17
		}

		var_24_3.state = "wants_to_spawn"

		if var_24_5.special_spawn_stinger then
			arg_24_0:_play_stinger(var_24_5.special_spawn_stinger, var_24_3)
		end

		Managers.state.conflict:spawn_queued_unit(var_24_5, Vector3Box(var_24_15), QuaternionBox(Quaternion(Vector3.up(), 0)), "rush_intervention", nil, nil, var_24_18)

		return true, "rush special"
	end
end

local function var_0_5(arg_25_0, arg_25_1, arg_25_2)
	local var_25_0 = arg_25_2.slot

	var_25_0.breed = arg_25_1.name
	var_25_0.unit = arg_25_0
	var_25_0.time = nil
	var_25_0.state = "alive"
	var_25_0.desc = "speed running intervention"

	local var_25_1 = arg_25_2.alive_specials

	var_25_1[#var_25_1 + 1] = arg_25_0

	print("Speed run intervention - spawning ", arg_25_1.name)
end

SpecialsPacing.request_speed_running_intervention = function (arg_26_0, arg_26_1, arg_26_2, arg_26_3)
	if script_data.ai_specials_spawning_disabled or Managers.state.game_mode:setting("ai_specials_spawning_disabled") then
		return false, "specials spawning disabled"
	end

	if ScriptUnit.extension(arg_26_2, "status_system"):is_disabled() then
		return false, "no speed running intervention, since speed runner is disabled"
	end

	local var_26_0 = CurrentSpecialsSettings
	local var_26_1 = (CurrentSpecialsSettings.speed_running_intervention or SpecialsSettings.default.speed_running_intervention).breeds
	local var_26_2 = arg_26_0._specials_slots
	local var_26_3 = var_0_3(var_26_2)

	if var_26_3 then
		local var_26_4 = var_26_2[var_26_3]
		local var_26_5 = var_26_1[Math.random(1, #var_26_1)]
		local var_26_6 = Breeds[var_26_5]
		local var_26_7 = Managers.state.conflict
		local var_26_8 = var_26_7.level_analysis:get_main_paths()
		local var_26_9 = var_26_7._world
		local var_26_10 = arg_26_0.nav_world
		local var_26_11 = arg_26_0._level
		local var_26_12 = arg_26_0._nav_tag_volume_handler
		local var_26_13 = 25
		local var_26_14 = arg_26_0:get_relative_main_path_pos(var_26_8, arg_26_3[arg_26_2], 20)
		local var_26_15 = LevelHelper.current_level_settings().check_no_spawn_volumes_for_special_spawning
		local var_26_16, var_26_17 = var_0_2(var_26_9, var_26_10, var_26_11, var_26_12, var_26_15, var_26_14, var_26_13, arg_26_0._side)

		if not var_26_16 then
			return false, var_26_17
		end

		local var_26_18 = var_26_7:alive_specials()
		local var_26_19 = {
			spawned_func = var_0_5,
			slot = var_26_4,
			alive_specials = var_26_18
		}

		var_26_4.state = "wants_to_spawn"

		if var_26_6.special_spawn_stinger then
			arg_26_0:_play_stinger(var_26_6.special_spawn_stinger, var_26_4)
		end

		Managers.state.conflict:spawn_queued_unit(var_26_6, Vector3Box(var_26_16), QuaternionBox(Quaternion(Vector3.up(), 0)), "speed_run_intervention", nil, nil, var_26_19)

		return true, var_26_5
	end

	return false, "no slots available"
end

SpecialsPacing.get_relative_main_path_pos = function (arg_27_0, arg_27_1, arg_27_2, arg_27_3)
	local var_27_0, var_27_1 = MainPathUtils.point_on_mainpath(arg_27_1, arg_27_2.travel_dist + arg_27_3)
	local var_27_2
	local var_27_3

	if var_27_0 and var_27_1 == arg_27_2.path_index then
		var_27_2 = var_27_0
	else
		var_27_2 = POSITION_LOOKUP[arg_27_2.unit]
		var_27_3 = true
	end

	return var_27_2, var_27_3
end

SpecialsPacing.debug = function (arg_28_0, arg_28_1, arg_28_2, arg_28_3, arg_28_4)
	if script_data.debug_ai_pacing then
		local var_28_0 = ""

		for iter_28_0 = 1, #arg_28_4 do
			local var_28_1 = arg_28_4[iter_28_0]

			if var_28_1.time then
				local var_28_2 = var_28_1.time - arg_28_1

				if var_28_2 > 0.5 then
					if var_28_1.special_spawn_stinger then
						Debug.text(string.format(" [%d] %s: SPAWNS IN %0.1f, STINGER IN %0.1f ", iter_28_0, var_28_1.breed, var_28_2, math.max(var_28_1.special_spawn_stinger_at_t - arg_28_1, 0)))
					elseif var_28_1.health_modifier then
						Debug.text(string.format(" [%d] %s: SPAWNS IN %0.1f, HEALTH MODIFIER ", iter_28_0, var_28_1.breed, var_28_2))
					else
						Debug.text(string.format(" [%d] %s: SPAWNS IN %0.1f, ", iter_28_0, var_28_1.breed, var_28_2))
					end
				else
					Debug.text(string.format(" [%d] %s: SPAWNING NOW, ", iter_28_0, var_28_1.breed))
				end
			elseif var_28_1.state == "coordinating" and var_28_1.health_modifier then
				Debug.text(string.format(" [%d] %s: COODINATED SPAWN, HEALTH MODIFIER %s", iter_28_0, var_28_1.breed))
			elseif var_28_1.state == "coordinating" then
				Debug.text(string.format(" [%d] %s: COORDINATING, %s", iter_28_0, var_28_1.breed, tostring(var_28_1.desc)))
			else
				Debug.text(string.format(" [%d] %s: ALIVE, %s", iter_28_0, var_28_1.breed, tostring(var_28_1.desc)))
			end
		end

		Debug.text("Specials: " .. var_28_0)
	end
end
