-- chunkname: @scripts/entity_system/systems/dialogues/dialogue_queries.lua

local tbl = {}
local tbl_2 = {}

tbl.get_sound_event_duration = function (self, arg_1_1)
	-- function 1
	local sound_events_duration = self.sound_events_duration

	sound_events_duration = sound_events_duration or tbl_2

	local var_1_1 = sound_events_duration[arg_1_1]

	if not var_1_1 then
		return var_1_1
	end

	return DialogueSettings.sound_event_default_length
end

tbl.get_dialogue_event = function (self, arg_2_1)
	-- function 2
	return self.sound_events[arg_2_1], self.localization_strings[arg_2_1], self.face_animations[arg_2_1], self.dialogue_animations[arg_2_1]
end

tbl.build_randomized_indexes = function (self)
	-- function 3
	if not self.sound_events_weights then
		local tbl = {}
		local tbl_2 = {}

		for i = 1, self.sound_events_n do
			tbl[i] = self.sound_events_weights[i]
			tbl_2[i] = i
		end

		local sound_events_n = self.sound_events_n
		local num = 1

		for j = 1, self.sound_events_n do
			local num_2 = math.random() * num
			local num_3 = 1

			for k = 1, sound_events_n do
				if num_2 <= tbl[k] then
					num_3 = k

					break
				end
			end

			if sound_events_n > 1 then
				local var_3_6 = tbl[num_3]
				local flag

				flag = num_3 ~= 1 or not 0 or tbl[num_3 - 1]

				local num_4 = var_3_6 - flag

				for l = num_3 + 1, sound_events_n do
					tbl[l] = tbl[l] - num_4
				end

				table.remove(tbl, num_3)

				sound_events_n = sound_events_n - 1
				num = num - num_4
			end

			self.randomize_indexes[j] = tbl_2[num_3]

			table.remove(tbl_2, num_3)
		end

		self.randomize_indexes_n = self.sound_events_n
	else
		local tbl_3 = {}

		for i4 = 1, self.sound_events_n do
			tbl_3[i4] = i4
		end

		self.randomize_indexes = {}

		for i5 = 1, self.sound_events_n do
			local random = math.random(1, self.sound_events_n + 1 - i5)
			local remove = table.remove(tbl_3, random)

			self.randomize_indexes[i5] = remove
		end

		self.randomize_indexes_n = self.sound_events_n
	end
end

tbl.get_dialogue_event_index = function (self, arg_4_1)
	-- function 4
	local sound_events_n = self.sound_events_n

	if sound_events_n == 1 then
		return 1
	end

	local flag = false

	if self.randomize_indexes_n == 0 then
		if not arg_4_1 then
			flag = true
			self.randomize_indexes_n = sound_events_n
		else
			tbl.build_randomized_indexes(self)
		end
	end

	local randomize_indexes_n = self.randomize_indexes_n

	self.randomize_indexes_n = self.randomize_indexes_n - 1

	return self.randomize_indexes[randomize_indexes_n], flag
end

tbl.get_filtered_dialogue_event_index = function (self, arg_5_1, arg_5_2)
	-- function 5
	local get_dialogue_event_index, var_5_1 = tbl.get_dialogue_event_index(self)
	local flag = false

	for i = 1, self.sound_events_n do
		if not tbl.filter_sound_event(self, get_dialogue_event_index, arg_5_1, arg_5_2) then
			break
		end

		local var_5_3
		local var_5_4

		get_dialogue_event_index, var_5_4 = tbl.get_dialogue_event_index(self, true)
		var_5_1 = var_5_1 or var_5_4
	end

	if not var_5_1 then
		tbl.build_randomized_indexes(self)
	end

	return get_dialogue_event_index
end

tbl.filter_sound_event = function (self, arg_6_1, arg_6_2, arg_6_3)
	-- function 6
	local var_6_0 = self.sound_events[arg_6_1]
	local var_6_1 = arg_6_3[var_6_0]

	if not var_6_1 then
		for i = 1, #var_6_1 do
			local var_6_2 = var_6_1[i]
			local var_6_3 = var_6_2[1]
			local var_6_4 = var_6_2[2]
			local var_6_5 = var_6_2[3]
			local var_6_6 = var_6_2[4]
			local var_6_7 = arg_6_2[var_6_3][var_6_4]

			var_6_7 = var_6_7 or false

			if not TagQuery.FilterOP[var_6_5](var_6_7, var_6_6) then
				return false
			end
		end
	end

	local sound_event_filters = self.sound_event_filters
	local flag = not sound_event_filters and sound_event_filters[var_6_0]

	if not flag then
		for j = 1, #flag do
			local var_6_10 = flag[j]
			local var_6_11 = var_6_10[1]
			local var_6_12 = var_6_10[2]
			local var_6_13 = var_6_10[3]
			local var_6_14 = var_6_10[4]
			local var_6_15 = arg_6_2[var_6_11][var_6_12]

			var_6_15 = var_6_15 or false

			if not TagQuery.FilterOP[var_6_13](var_6_15, var_6_14) then
				return false
			end
		end
	end

	return true
end

return tbl
