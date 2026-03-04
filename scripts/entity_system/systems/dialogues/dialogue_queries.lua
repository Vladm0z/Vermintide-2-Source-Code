-- chunkname: @scripts/entity_system/systems/dialogues/dialogue_queries.lua

local var_0_0 = {}
local var_0_1 = {}

function var_0_0.get_sound_event_duration(arg_1_0, arg_1_1)
	local var_1_0 = (arg_1_0.sound_events_duration or var_0_1)[arg_1_1]

	if var_1_0 then
		return var_1_0
	end

	return DialogueSettings.sound_event_default_length
end

function var_0_0.get_dialogue_event(arg_2_0, arg_2_1)
	return arg_2_0.sound_events[arg_2_1], arg_2_0.localization_strings[arg_2_1], arg_2_0.face_animations[arg_2_1], arg_2_0.dialogue_animations[arg_2_1]
end

function var_0_0.build_randomized_indexes(arg_3_0)
	if arg_3_0.sound_events_weights then
		local var_3_0 = {}
		local var_3_1 = {}

		for iter_3_0 = 1, arg_3_0.sound_events_n do
			var_3_0[iter_3_0] = arg_3_0.sound_events_weights[iter_3_0]
			var_3_1[iter_3_0] = iter_3_0
		end

		local var_3_2 = arg_3_0.sound_events_n
		local var_3_3 = 1

		for iter_3_1 = 1, arg_3_0.sound_events_n do
			local var_3_4 = math.random() * var_3_3
			local var_3_5 = 1

			for iter_3_2 = 1, var_3_2 do
				if var_3_4 <= var_3_0[iter_3_2] then
					var_3_5 = iter_3_2

					break
				end
			end

			if var_3_2 > 1 then
				local var_3_6 = var_3_0[var_3_5] - (var_3_5 == 1 and 0 or var_3_0[var_3_5 - 1])

				for iter_3_3 = var_3_5 + 1, var_3_2 do
					var_3_0[iter_3_3] = var_3_0[iter_3_3] - var_3_6
				end

				table.remove(var_3_0, var_3_5)

				var_3_2 = var_3_2 - 1
				var_3_3 = var_3_3 - var_3_6
			end

			arg_3_0.randomize_indexes[iter_3_1] = var_3_1[var_3_5]

			table.remove(var_3_1, var_3_5)
		end

		arg_3_0.randomize_indexes_n = arg_3_0.sound_events_n
	else
		local var_3_7 = {}

		for iter_3_4 = 1, arg_3_0.sound_events_n do
			var_3_7[iter_3_4] = iter_3_4
		end

		arg_3_0.randomize_indexes = {}

		for iter_3_5 = 1, arg_3_0.sound_events_n do
			local var_3_8 = math.random(1, arg_3_0.sound_events_n + 1 - iter_3_5)
			local var_3_9 = table.remove(var_3_7, var_3_8)

			arg_3_0.randomize_indexes[iter_3_5] = var_3_9
		end

		arg_3_0.randomize_indexes_n = arg_3_0.sound_events_n
	end
end

function var_0_0.get_dialogue_event_index(arg_4_0, arg_4_1)
	local var_4_0 = arg_4_0.sound_events_n

	if var_4_0 == 1 then
		return 1
	end

	local var_4_1 = false

	if arg_4_0.randomize_indexes_n == 0 then
		if arg_4_1 then
			var_4_1 = true
			arg_4_0.randomize_indexes_n = var_4_0
		else
			var_0_0.build_randomized_indexes(arg_4_0)
		end
	end

	local var_4_2 = arg_4_0.randomize_indexes_n

	arg_4_0.randomize_indexes_n = arg_4_0.randomize_indexes_n - 1

	return arg_4_0.randomize_indexes[var_4_2], var_4_1
end

function var_0_0.get_filtered_dialogue_event_index(arg_5_0, arg_5_1, arg_5_2)
	local var_5_0, var_5_1 = var_0_0.get_dialogue_event_index(arg_5_0)
	local var_5_2 = false

	for iter_5_0 = 1, arg_5_0.sound_events_n do
		if var_0_0.filter_sound_event(arg_5_0, var_5_0, arg_5_1, arg_5_2) then
			break
		end

		local var_5_3
		local var_5_4

		var_5_0, var_5_4 = var_0_0.get_dialogue_event_index(arg_5_0, true)
		var_5_1 = var_5_1 or var_5_4
	end

	if var_5_1 then
		var_0_0.build_randomized_indexes(arg_5_0)
	end

	return var_5_0
end

function var_0_0.filter_sound_event(arg_6_0, arg_6_1, arg_6_2, arg_6_3)
	local var_6_0 = arg_6_0.sound_events[arg_6_1]
	local var_6_1 = arg_6_3[var_6_0]

	if var_6_1 then
		for iter_6_0 = 1, #var_6_1 do
			local var_6_2 = var_6_1[iter_6_0]
			local var_6_3 = var_6_2[1]
			local var_6_4 = var_6_2[2]
			local var_6_5 = var_6_2[3]
			local var_6_6 = var_6_2[4]
			local var_6_7 = arg_6_2[var_6_3][var_6_4] or false

			if TagQuery.FilterOP[var_6_5](var_6_7, var_6_6) then
				return false
			end
		end
	end

	local var_6_8 = arg_6_0.sound_event_filters
	local var_6_9 = var_6_8 and var_6_8[var_6_0]

	if var_6_9 then
		for iter_6_1 = 1, #var_6_9 do
			local var_6_10 = var_6_9[iter_6_1]
			local var_6_11 = var_6_10[1]
			local var_6_12 = var_6_10[2]
			local var_6_13 = var_6_10[3]
			local var_6_14 = var_6_10[4]
			local var_6_15 = arg_6_2[var_6_11][var_6_12] or false

			if TagQuery.FilterOP[var_6_13](var_6_15, var_6_14) then
				return false
			end
		end
	end

	return true
end

return var_0_0
