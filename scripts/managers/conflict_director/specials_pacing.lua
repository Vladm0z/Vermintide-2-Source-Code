-- chunkname: @scripts/managers/conflict_director/specials_pacing.lua

SpecialsPacing = class(SpecialsPacing)

SpecialsPacing.init = function (self, arg_1_1, arg_1_2, arg_1_3, arg_1_4)
	-- function 1
	self._level = LevelHelper:current_level(arg_1_1)
	self._nav_tag_volume_handler = arg_1_3
	self.nav_world = arg_1_2
	self._specials_timer = 0
	self._disabled = false
	self._specials_spawn_queue = {}
	self._specials_slots = {}
	self._state_data = {}
	self._side = arg_1_4
	self.method_name = CurrentSpecialsSettings.spawn_method

	self:remove_unwanted_breeds()
end

SpecialsPacing.remove_unwanted_breeds = function (arg_2_0)
	-- function 2
	print("SpecialsPacing:remove_unwanted_breeds:")

	for k, v in pairs(SpecialsSettings) do
		local breeds = v.breeds

		if not breeds then
			for k_2 = #breeds, 1, -1 do
				local var_2_1 = breeds[k_2]

				if not Breeds[var_2_1].disabled then
					print("remove_unwanted_breeds", var_2_1)
					table.remove(breeds, k_2)
				end
			end
		end

		local rush_intervention = v.rush_intervention

		rush_intervention = not rush_intervention and v.rush_intervention.breeds

		if not rush_intervention then
			for l = #rush_intervention, 1, -1 do
				local var_2_3 = rush_intervention[l]

				if not Breeds[var_2_3].disabled then
					print("remove_unwanted_breeds", var_2_3)
					table.remove(rush_intervention, l)
				end
			end
		end
	end
end

SpecialsPacing.start = function (self)
	-- function 3
	if not self.method_name then
		self.method_data = CurrentSpecialsSettings.methods[self.method_name]

		assert(self.method_data, "Missing 'spawn_method' in SpecialsSettings")

		if not SpecialsPacing.setup_functions[self.method_name] then
			local time = Managers.time:time("game")

			SpecialsPacing.setup_functions[self.method_name](time, self._specials_slots, self.method_data, self._state_data)
		end
	end
end

local tbl = {
	"chaos_spawn",
	"skaven_rat_ogre",
	"skaven_stormfiend",
	"chaos_troll"
}

SpecialsPacing.setup_functions = {
	specials_by_slots = function (arg_4_0, arg_4_1, arg_4_2, arg_4_3)
		-- function 4
		local CurrentSpecialsSettings = CurrentSpecialsSettings

		if #CurrentSpecialsSettings.breeds == 0 then
			return
		end

		local var_4_1
		local num = 2

		if not arg_4_2.always_coordinated then
			var_4_1 = arg_4_0 + ConflictUtils.random_interval(arg_4_2.after_safe_zone_delay)
			arg_4_3.coordinated_timer = var_4_1

			if not arg_4_2.same_breeds then
				local breeds = CurrentSpecialsSettings.breeds

				arg_4_3.override_breed_name = breeds[Math.random(1, #breeds)]
			end
		end

		arg_4_3.coord_time_check = arg_4_0

		for i = 1, CurrentSpecialsSettings.max_specials do
			local var_4_4, var_4_5 = SpecialsPacing.select_breed_functions[arg_4_2.select_next_breed](arg_4_1, CurrentSpecialsSettings, arg_4_2, arg_4_3)
			local flag = var_4_1 or arg_4_0 + ConflictUtils.random_interval(arg_4_2.after_safe_zone_delay)
			local var_4_7 = Breeds[var_4_4]
			local var_4_8
			local var_4_9

			if not var_4_7.special_spawn_stinger then
				var_4_8 = var_4_7.special_spawn_stinger

				local special_spawn_stinger_time = var_4_7.special_spawn_stinger_time

				special_spawn_stinger_time = special_spawn_stinger_time or 6
				var_4_9 = flag - special_spawn_stinger_time
			end

			arg_4_1[i] = {
				state = "waiting",
				breed = var_4_4,
				time = flag,
				health_modifier = var_4_5,
				special_spawn_stinger = var_4_8,
				special_spawn_stinger_at_t = var_4_9
			}
		end
	end
}
SpecialsPacing.select_breed_functions = {
	get_least_used_breeds = function (self, arg_5_1, arg_5_2, arg_5_3)
		-- function 5
		local alloc_table = FrameTable.alloc_table()

		if #self == 0 then
			return
		end

		for i = 1, #self do
			local var_5_1 = self[i]
			local breed = var_5_1.breed
			local var_5_3 = alloc_table[var_5_1.breed]

			var_5_3 = var_5_3 or 0
			alloc_table[breed] = var_5_3 + 1
		end

		local alloc_table_2 = FrameTable.alloc_table()
		local huge = math.huge

		for k, v in pairs(alloc_table) do
			local var_5_6 = alloc_table[k]

			if var_5_6 < huge then
				huge = var_5_6

				table.clear(alloc_table_2)
			end

			if var_5_6 <= huge then
				alloc_table_2[#alloc_table_2 + 1] = k
			end
		end

		return alloc_table_2
	end,
	get_random_breed = function (self, arg_6_1, arg_6_2, arg_6_3)
		-- function 6
		if not arg_6_3.override_breed_name then
			return arg_6_3.override_breed_name
		end

		local breeds = arg_6_1.breeds
		local count = #breeds

		if count <= 0 then
			return nil
		end

		local alloc_table = FrameTable.alloc_table()

		for i = 1, #self do
			local var_6_3 = self[i]
			local breed = var_6_3.breed
			local var_6_5 = alloc_table[var_6_3.breed]

			var_6_5 = var_6_5 or 0
			alloc_table[breed] = var_6_5 + 1
		end

		local num = 20
		local var_6_7
		local num_2 = 0

		repeat
			var_6_7 = breeds[Math.random(1, count)]
			num_2 = num_2 + 1
		until not (not alloc_table[var_6_7] and alloc_table[var_6_7] < arg_6_2.max_of_same or not (num <= num_2))

		return var_6_7
	end,
	get_same_breed = function (arg_7_0, arg_7_1, arg_7_2, arg_7_3, arg_7_4)
		-- function 7
		if not arg_7_3.override_breed_name then
			return arg_7_3.override_breed_name
		end

		local breeds = arg_7_1.breeds
		local batch_amount = arg_7_3.batch_amount

		batch_amount = batch_amount or 0

		local time = Managers.time:time("game")

		if not (not arg_7_3.batch_breed and not arg_7_4 and time > arg_7_3.coord_time_check or not (batch_amount > arg_7_1.max_specials)) then
			arg_7_3.batch_amount = 0
			arg_7_3.batch_breed = breeds[Math.random(1, #breeds)]

			if not arg_7_4 then
				arg_7_3.coord_time_check = time + 15
			end
		end

		arg_7_3.batch_amount = arg_7_3.batch_amount + 1

		return arg_7_3.batch_breed
	end,
	get_chance_of_boss_breed = function (self, arg_8_1, arg_8_2, arg_8_3)
		-- function 8
		local breeds = arg_8_1.breeds
		local flag = Math.random() <= 0.25
		local var_8_2

		if not flag then
			var_8_2 = tbl[math.random(1, #tbl)]

			local num = 0.25

			return var_8_2, num
		else
			local alloc_table = FrameTable.alloc_table()

			for i = 1, #self do
				local var_8_5 = self[i]
				local breed = var_8_5.breed
				local var_8_7 = alloc_table[var_8_5.breed]

				var_8_7 = var_8_7 or 0
				alloc_table[breed] = var_8_7 + 1
			end

			local num_2 = 20
			local num_3 = 0

			repeat
				local random = Math.random(1, #breeds)

				var_8_2 = arg_8_3.override_breed_name or breeds[random]
				num_3 = num_3 + 1
			until not (not alloc_table[var_8_2] and alloc_table[var_8_2] < arg_8_2.max_of_same or not (num_2 <= num_3))
		end

		return var_8_2
	end
}

SpecialsPacing._set_next_coordinated_attack = function (self, arg_9_1, arg_9_2, arg_9_3, arg_9_4, arg_9_5)
	-- function 9
	local _state_data = self._state_data
	local var_9_1
	local var_9_2

	if not arg_9_3.same_breeds then
		local breeds = arg_9_2.breeds

		_state_data.override_breed_name = breeds[Math.random(1, #breeds)]

		local coordinated_trickle_time = arg_9_3.coordinated_trickle_time
	end

	local num = arg_9_1 + ConflictUtils.random_interval(arg_9_3.spawn_cooldown)

	for i = 1, #arg_9_4 do
		local var_9_6 = arg_9_4[i]
		local var_9_7, var_9_8 = SpecialsPacing.select_breed_functions[arg_9_3.select_next_breed](arg_9_4, arg_9_2, arg_9_3, _state_data)
		local var_9_9 = Breeds[var_9_7]
		local coordinated_trickle_time_2 = arg_9_3.coordinated_trickle_time
		local num_2

		if not coordinated_trickle_time_2 then
			num_2 = i * coordinated_trickle_time_2

			if not num_2 then
				-- Nothing
			end
		end

		num_2 = 2

		::label_9_0::

		num = num + num_2

		if not var_9_9.special_spawn_stinger then
			var_9_6.special_spawn_stinger = var_9_9.special_spawn_stinger

			local special_spawn_stinger_time = var_9_9.special_spawn_stinger_time

			special_spawn_stinger_time = special_spawn_stinger_time or 6
			var_9_6.special_spawn_stinger_at_t = num - special_spawn_stinger_time
		else
			var_9_6.special_spawn_stinger = nil
			var_9_6.special_spawn_stinger_at_t = nil
		end

		var_9_6.time = num
		var_9_6.breed = var_9_7
		var_9_6.unit = nil
		var_9_6.state = "waiting"
		var_9_6.health_modifier = var_9_8
		var_9_6.desc = "coordinated attack"
		arg_9_5[#arg_9_5 + 1] = var_9_6
	end

	_state_data.coordinated_timer = num + 1
end

SpecialsPacing.specials_by_slots = function (self, arg_10_1, arg_10_2, arg_10_3, arg_10_4, arg_10_5)
	-- function 10
	local count = #arg_10_4
	local num = 0
	local flag = false

	if not arg_10_3.always_coordinated then
		if arg_10_1 > self._state_data.coordinated_timer then
			self:_set_next_coordinated_attack(arg_10_1, arg_10_2, arg_10_3, arg_10_4, arg_10_5)
		end

		self._specials_timer = arg_10_1 + 1

		return
	end

	for i = 1, count do
		local var_10_3 = arg_10_4[i]

		if var_10_3.state == "waiting" then
			if arg_10_1 > var_10_3.time then
				var_10_3.unit = nil
				arg_10_5[#arg_10_5 + 1] = var_10_3

				local flag_2

				flag_2 = not arg_10_3.always_coordinated and "coordinating" and "wants_to_spawn"
				var_10_3.state = flag_2
				var_10_3.time = nil
				var_10_3.dest = ""
			else
				num = num + 1
			end

			if not (not var_10_3.special_spawn_stinger and not (arg_10_1 > var_10_3.special_spawn_stinger_at_t)) then
				self:_play_stinger(var_10_3.special_spawn_stinger, var_10_3)

				var_10_3.special_spawn_stinger = nil
				var_10_3.special_spawn_stinger_at_t = nil
			end
		end

		if not (var_10_3.state ~= "alive" or HEALTH_ALIVE[var_10_3.unit]) then
			local var_10_5, var_10_6 = SpecialsPacing.select_breed_functions[arg_10_3.select_next_breed](arg_10_4, arg_10_2, arg_10_3, self._state_data)
			local var_10_7 = Breeds[var_10_5]
			local num_2 = arg_10_1 + ConflictUtils.random_interval(arg_10_3.spawn_cooldown)

			if not var_10_7.special_spawn_stinger then
				var_10_3.special_spawn_stinger = var_10_7.special_spawn_stinger

				local special_spawn_stinger_time = var_10_7.special_spawn_stinger_time

				special_spawn_stinger_time = special_spawn_stinger_time or 6
				var_10_3.special_spawn_stinger_at_t = num_2 - special_spawn_stinger_time
			else
				var_10_3.special_spawn_stinger = nil
				var_10_3.special_spawn_stinger_at_t = nil
			end

			var_10_3.time = num_2
			var_10_3.breed = var_10_5
			var_10_3.unit = nil
			var_10_3.state = "waiting"
			var_10_3.desc = ""
			var_10_3.health_modifier = var_10_6
			flag = true
			num = num + 1
		end
	end

	if not (not flag and num ~= count) then
		local flag_3 = Math.random() <= arg_10_3.chance_of_coordinated_attack

		if not flag_3 then
			print("Coordinated attack!")

			local num_3 = arg_10_1 + 40
			local num_4 = 0
			local coordinated_attack_cooldown_multiplier = arg_10_3.coordinated_attack_cooldown_multiplier

			coordinated_attack_cooldown_multiplier = coordinated_attack_cooldown_multiplier or 0.5

			for j = 1, count do
				num_4 = num_4 + arg_10_4[j].time
			end

			if num_4 > 0 then
				num_3 = arg_10_1 + (num_4 / count - arg_10_1) * coordinated_attack_cooldown_multiplier
			end

			local _state_data = self._state_data

			for k = 1, count do
				local var_10_15 = arg_10_4[k]
				local var_10_16, var_10_17 = SpecialsPacing.select_breed_functions[arg_10_3.select_next_breed](arg_10_4, arg_10_2, arg_10_3, _state_data, flag_3)
				local var_10_18 = Breeds[var_10_16]
				local num_5

				if not arg_10_3.coordinated_trickle_time then
					num_5 = k * arg_10_3.coordinated_trickle_time

					if not num_5 then
						-- Nothing
					end
				end

				num_5 = k * 2

				::label_10_0::

				local num_6 = num_3 + num_5

				if not var_10_18.special_spawn_stinger then
					var_10_15.special_spawn_stinger = var_10_18.special_spawn_stinger

					local special_spawn_stinger_time_2 = var_10_18.special_spawn_stinger_time

					special_spawn_stinger_time_2 = special_spawn_stinger_time_2 or 6
					var_10_15.special_spawn_stinger_at_t = num_6 - special_spawn_stinger_time_2
				else
					var_10_15.special_spawn_stinger = nil
					var_10_15.special_spawn_stinger_at_t = nil
				end

				var_10_15.time = num_6
				var_10_15.breed = var_10_16
				var_10_15.unit = nil
				var_10_15.state = "waiting"
				var_10_15.health_modifier = var_10_17

				local flag_4 = true

				var_10_15.desc = "coordinated attack"
			end
		end
	end

	self._specials_timer = arg_10_1 + 1
end

SpecialsPacing.specials_by_time_window = function (self, arg_11_1, arg_11_2, arg_11_3, arg_11_4, arg_11_5, arg_11_6)
	-- function 11
	if arg_11_1 > self._specials_timer then
		local count = #arg_11_6
		local num = 1

		while num <= count do
			local var_11_2 = arg_11_6[num]

			if not ALIVE[var_11_2] then
				arg_11_6[num] = arg_11_6[count]
				arg_11_6[count] = nil
				count = count - 1
			else
				num = num + 1
			end
		end

		local max_specials = arg_11_2.max_specials

		if count + #arg_11_4 <= 0 then
			local random_interval = ConflictUtils.random_interval(arg_11_3.lull_time)
			local breeds = arg_11_2.breeds

			if not (not arg_11_3.even_out_breeds and not (max_specials > 1)) then
				local clone = table.clone(breeds)
				local num_2 = 0

				for i = 1, max_specials do
					if num_2 <= 0 then
						table.shuffle(clone)

						num_2 = #clone
					end

					arg_11_4[i] = {
						breed = clone[num_2]
					}
					num_2 = num_2 - 1
				end
			else
				for j = 1, max_specials do
					arg_11_4[j].breed = breeds[Math.random(1, #breeds)]
				end
			end

			local random_interval_2 = ConflictUtils.random_interval(arg_11_3.spawn_interval)
			local num_3 = 0
			local tbl = {}

			for k = 1, max_specials do
				num_3 = num_3 + Math.random()
				tbl[k] = num_3
			end

			local var_11_11

			for l = 1, max_specials do
				local num_4 = arg_11_1 + tbl[max_specials - l + 1] / num_3 * random_interval_2 + random_interval

				arg_11_4[l].time = num_4
			end

			self._specials_timer = arg_11_1 + random_interval

			table.clear(arg_11_5)
		end

		local var_11_13 = arg_11_4[#arg_11_4]

		if not (not var_11_13 and not (arg_11_1 > var_11_13.time)) then
			arg_11_4[#arg_11_4] = nil
			arg_11_5[#arg_11_5 + 1] = var_11_13
		end

		self._specials_timer = arg_11_1 + 1
	end
end

SpecialsPacing.enable = function (self, arg_12_1)
	-- function 12
	self._disabled = not arg_12_1
end

SpecialsPacing.is_disabled = function (self)
	-- function 13
	return self._disabled
end

local function fn(arg_14_0, arg_14_1, arg_14_2)
	-- function 14
	local slot = arg_14_2.slot
	local alive_specials = arg_14_2.alive_specials

	slot.unit = arg_14_0
	slot.state = "alive"

	if not arg_14_1.special then
		alive_specials[#alive_specials + 1] = arg_14_0
	end
end

SpecialsPacing.update = function (self, arg_15_1, arg_15_2, arg_15_3, arg_15_4)
	-- function 15
	local CurrentSpecialsSettings = CurrentSpecialsSettings

	if not CurrentSpecialsSettings.disabled then
		return
	end

	if not self._disabled then
		return
	end

	if arg_15_3 < 1 then
		return
	end

	local _specials_spawn_queue = self._specials_spawn_queue

	if arg_15_1 > self._specials_timer then
		if not Managers.state.conflict.delay_specials then
			self._specials_timer = arg_15_1 + 3
		else
			local var_15_2 = CurrentSpecialsSettings.methods[CurrentSpecialsSettings.spawn_method]

			SpecialsPacing[self.method_name](self, arg_15_1, CurrentSpecialsSettings, var_15_2, self._specials_slots, _specials_spawn_queue, arg_15_2)
		end

		if #_specials_spawn_queue > 0 then
			local var_15_3 = _specials_spawn_queue[#_specials_spawn_queue]
			local var_15_4 = Breeds[var_15_3.breed]
			local get_special_spawn_pos = self:get_special_spawn_pos(var_15_4.spawning_rule)

			if not get_special_spawn_pos then
				local tbl = {
					spawned_func = fn,
					alive_specials = arg_15_2,
					slot = var_15_3,
					parent = self,
					max_health_modifier = var_15_3.health_modifier
				}

				Managers.state.conflict:spawn_queued_unit(var_15_4, Vector3Box(get_special_spawn_pos), QuaternionBox(Vector3.up(), 0), "specials_pacing", nil, nil, tbl)

				var_15_3.state = "wants_to_spawn"
				var_15_3.spawn_type = nil
				_specials_spawn_queue[#_specials_spawn_queue] = nil
				self._specials_timer = arg_15_1 + 0.5
				var_15_3.health_modifier = nil

				if not (not var_15_3.special_spawn_stinger and var_15_3.has_played_special_stinger) then
					self:_play_stinger(var_15_3.special_spawn_stinger, var_15_3)

					var_15_3.has_played_special_stinger = nil
				end

				var_15_3.special_spawn_stinger = nil
				var_15_3.special_spawn_stinger_at_t = nil
			else
				self._specials_timer = arg_15_1 + 1
			end
		end
	end
end

SpecialsPacing.spawn_versus_darkpact_bot = function (self, arg_16_1, arg_16_2, arg_16_3)
	-- function 16
	local var_16_0 = Breeds[arg_16_1]
	local get_special_spawn_pos = self:get_special_spawn_pos(var_16_0.spawning_rule)

	if not get_special_spawn_pos then
		local tbl = {
			spawned_func = arg_16_2,
			bot_data = arg_16_3
		}

		Managers.state.conflict:spawn_queued_unit(var_16_0, Vector3Box(get_special_spawn_pos), QuaternionBox(Vector3.up(), 0), "specials_pacing", nil, nil, tbl)

		return true
	end
end

SpecialsPacing._play_stinger = function (arg_17_0, arg_17_1, arg_17_2)
	-- function 17
	Managers.state.entity:system("audio_system"):play_2d_audio_event(arg_17_1)

	arg_17_2.has_played_special_stinger = true
end

SpecialsPacing.delay_spawning = function (self, arg_18_1, arg_18_2, arg_18_3, arg_18_4)
	-- function 18
	local _specials_slots = self._specials_slots
	local CurrentSpecialsSettings = CurrentSpecialsSettings

	if not CurrentSpecialsSettings.disabled then
		return
	end

	local var_18_2 = CurrentSpecialsSettings.methods[CurrentSpecialsSettings.spawn_method]
	local flag = not not arg_18_4 or Math.random() <= var_18_2.chance_of_coordinated_attack

	for i = 1, #_specials_slots do
		local var_18_4 = _specials_slots[i]
		local var_18_5, var_18_6 = SpecialsPacing.select_breed_functions[var_18_2.select_next_breed](_specials_slots, CurrentSpecialsSettings, var_18_2, self._state_data)
		local var_18_7 = Breeds[var_18_5]
		local var_18_8
		local var_18_9
		local str

		if not flag then
			local coordinated_attack_cooldown_multiplier = var_18_2.coordinated_attack_cooldown_multiplier

			coordinated_attack_cooldown_multiplier = coordinated_attack_cooldown_multiplier or 0.5

			local num = arg_18_2 * coordinated_attack_cooldown_multiplier

			var_18_8 = arg_18_1 + coordinated_attack_cooldown_multiplier + arg_18_3 * i * coordinated_attack_cooldown_multiplier
			str = "coordinated attack"
		else
			var_18_8 = arg_18_1 + arg_18_2 + arg_18_3 * i
			str = ""
		end

		var_18_4.breed = var_18_5
		var_18_4.time = var_18_8
		var_18_4.unit = nil
		var_18_4.state = "waiting"
		var_18_4.desc = str
		var_18_4.health_modifier = var_18_6

		if not var_18_7.special_spawn_stinger then
			var_18_4.special_spawn_stinger = var_18_7.special_spawn_stinger

			local time = var_18_4.time
			local special_spawn_stinger_time = var_18_7.special_spawn_stinger_time

			special_spawn_stinger_time = special_spawn_stinger_time or 6
			var_18_4.special_spawn_stinger_at_t = time - special_spawn_stinger_time
		else
			var_18_4.special_spawn_stinger = nil
			var_18_4.special_spawn_stinger_at_t = nil
		end
	end

	local _specials_spawn_queue = self._specials_spawn_queue

	for j = 1, #_specials_spawn_queue do
		_specials_spawn_queue[j] = nil
	end
end

SpecialsPacing.debug_spawn = function (self)
	-- function 19
	local breeds = CurrentSpecialsSettings.breeds
	local var_19_1 = breeds[math.random(#breeds)]
	local var_19_2 = Breeds[var_19_1]
	local get_special_spawn_pos = self:get_special_spawn_pos(var_19_2.spawning_rule)

	if not get_special_spawn_pos then
		QuickDrawerStay:sphere(get_special_spawn_pos, 4, Color(125, 255, 47))
		print("debug spawning special: ", var_19_1)

		local var_19_4

		Managers.state.conflict:spawn_queued_unit(var_19_2, Vector3Box(get_special_spawn_pos), QuaternionBox(Quaternion(Vector3.up(), 0)), "specials_pacing", nil, nil, var_19_4)
	else
		print("debug spawning special could not find spawn position")
	end
end

SpecialsPacing.get_special_spawn_pos = function (self, arg_20_1)
	-- function 20
	local conflict = Managers.state.conflict
	local main_path_info = conflict.main_path_info
	local main_path_player_info = conflict.main_path_player_info
	local _level = self._level
	local _nav_tag_volume_handler = self._nav_tag_volume_handler
	local get_main_paths = conflict.level_analysis:get_main_paths()
	local _side = self._side
	local get_cluster_and_loneliness, var_20_8, var_20_9, var_20_10 = conflict:get_cluster_and_loneliness(10, _side.ENEMY_PLAYER_POSITIONS, _side.ENEMY_PLAYER_UNITS)
	local ahead_unit = main_path_info.ahead_unit
	local behind_unit = main_path_info.behind_unit
	local var_20_13
	local flag = false
	local var_20_15

	if not (not ahead_unit and behind_unit) then
		var_20_13 = POSITION_LOOKUP[var_20_10]

		local str = "specialspawn: loneliest -->"
	elseif arg_20_1 == "always_ahead" then
		var_20_13 = self:get_relative_main_path_pos(get_main_paths, main_path_player_info[ahead_unit], 20)

		local str_2 = "specialspawn: rule: only_ahead -->"
	elseif var_20_9 > 10 then
		if ahead_unit == var_20_10 then
			var_20_13 = self:get_relative_main_path_pos(get_main_paths, main_path_player_info[ahead_unit], 20)

			local str_3 = "specialspawn: ahead == lonliest -->"
		elseif behind_unit == var_20_10 then
			var_20_13 = POSITION_LOOKUP[behind_unit]

			local str_4 = "specialspawn: behind == lonliest -->"
		else
			local str_5 = "specialspawn: random-pick -->"

			flag = true
		end
	else
		flag = true
	end

	if not flag then
		if not (Math.random() < 0.75) then
			var_20_13 = self:get_relative_main_path_pos(get_main_paths, main_path_player_info[ahead_unit], 10)

			local str_6 = "specialspawn: random infront"
		else
			var_20_13 = POSITION_LOOKUP[behind_unit]

			local str_7 = "specialspawn: random behind"
		end
	end

	if not var_20_13 then
		local ENEMY_PLAYER_POSITIONS = self._side.ENEMY_PLAYER_POSITIONS

		var_20_13 = ENEMY_PLAYER_POSITIONS[math.random(#ENEMY_PLAYER_POSITIONS)]

		local str_8 = "specialspawn: fallback - epicenter around random player"
	end

	local _world = conflict._world
	local ENEMY_PLAYER_AND_BOT_POSITIONS = self._side.ENEMY_PLAYER_AND_BOT_POSITIONS
	local check_no_spawn_volumes_for_special_spawning = LevelHelper.current_level_settings().check_no_spawn_volumes_for_special_spawning
	local var_20_28

	if not var_20_13 then
		var_20_28 = ConflictUtils.get_hidden_pos(_world, self.nav_world, _level, _nav_tag_volume_handler, check_no_spawn_volumes_for_special_spawning, var_20_13, ENEMY_PLAYER_AND_BOT_POSITIONS, 30, 10, 225, 10)

		if not var_20_28 then
			local get_random_hidden_spawner = ConflictUtils.get_random_hidden_spawner(var_20_13, 40)

			if not get_random_hidden_spawner then
				var_20_28 = Unit.local_position(get_random_hidden_spawner, 0)
			else
				var_20_28 = ConflictUtils.get_hidden_pos(_world, self.nav_world, _level, _nav_tag_volume_handler, check_no_spawn_volumes_for_special_spawning, var_20_13, ENEMY_PLAYER_AND_BOT_POSITIONS, 16, 5, 225, 3)
			end
		end
	end

	if not var_20_28 then
		return
	end

	return var_20_28
end

local function fn_2(arg_21_0, arg_21_1, arg_21_2, arg_21_3, arg_21_4, arg_21_5, arg_21_6, arg_21_7)
	-- function 21
	local ENEMY_PLAYER_AND_BOT_POSITIONS = arg_21_7.ENEMY_PLAYER_AND_BOT_POSITIONS
	local get_hidden_pos = ConflictUtils.get_hidden_pos(arg_21_0, arg_21_1, arg_21_2, arg_21_3, arg_21_4, arg_21_5, ENEMY_PLAYER_AND_BOT_POSITIONS, 30, 10, arg_21_6, 15)

	if not get_hidden_pos then
		print("Intervention Spawn: Failed to find spawn pos, trying hidden spawner")

		local get_random_hidden_spawner = ConflictUtils.get_random_hidden_spawner(arg_21_5, 40)

		if not get_random_hidden_spawner then
			get_hidden_pos = Unit.local_position(get_random_hidden_spawner, 0)
		else
			print("Intervention Spawn: Failed to find hidden spawner, trying random pos")

			get_hidden_pos = ConflictUtils.get_spawn_pos_on_circle(arg_21_1, arg_21_5, 30, 10, 20)
		end

		if not get_hidden_pos then
			print("Intervention Spawn: Failed to find spawn pos")

			return false, "Failed to find special spawn pos"
		end
	end

	return get_hidden_pos
end

local function fn_3(self)
	-- function 22
	local var_22_0
	local num = 0
	local count = #self

	for i = 1, count do
		local var_22_3 = self[i]

		if not (var_22_3.state ~= "waiting" or not (num < var_22_3.time)) then
			var_22_0 = i
			num = var_22_3.time
		end
	end

	return var_22_0
end

local function fn_4(arg_23_0, arg_23_1, arg_23_2)
	-- function 23
	local slot = arg_23_2.slot

	slot.breed = arg_23_1.name
	slot.unit = arg_23_0
	slot.time = nil
	slot.state = "alive"
	slot.desc = "rush intervention"

	local alive_specials = arg_23_2.alive_specials

	alive_specials[#alive_specials + 1] = arg_23_0

	print("rush intervention - spawning ", arg_23_1.name)
end

SpecialsPacing.request_rushing_intervention = function (self, arg_24_1, arg_24_2, arg_24_3, arg_24_4, arg_24_5)
	-- function 24
	if script_data.ai_specials_spawning_disabled or not Managers.state.game_mode:setting("ai_specials_spawning_disabled") then
		return false, "specials spawning disabled"
	end

	if not arg_24_5 and not arg_24_5.specials then
		return false, "no intervention, since game mode disabled it"
	end

	if not ScriptUnit.extension(arg_24_2, "status_system"):is_disabled() then
		return false, "no intervention, since ahead unit is disabled"
	end

	local breeds = CurrentSpecialsSettings.rush_intervention.breeds

	if #breeds <= 0 then
		print("No rush intervention breeds available. Cannot intervent rushing player by spawning a special (SpecialsSettings.specials.rush_intervention.breeds)")

		return false, "No rush intervention breeds set"
	end

	fassert(arg_24_3.ahead_unit, "Missing ahead unit in request_rushing_intervention")

	local _specials_slots = self._specials_slots
	local var_24_2 = fn_3(_specials_slots)

	if not var_24_2 then
		local var_24_3 = _specials_slots[var_24_2]
		local var_24_4 = breeds[Math.random(1, #breeds)]
		local var_24_5 = Breeds[var_24_4]
		local conflict = Managers.state.conflict
		local get_main_paths = conflict.level_analysis:get_main_paths()
		local _world = conflict._world
		local nav_world = self.nav_world
		local _level = self._level
		local _nav_tag_volume_handler = self._nav_tag_volume_handler
		local num = 25
		local get_relative_main_path_pos = self:get_relative_main_path_pos(get_main_paths, arg_24_4[arg_24_3.ahead_unit], 20)
		local check_no_spawn_volumes_for_special_spawning = LevelHelper.current_level_settings().check_no_spawn_volumes_for_special_spawning
		local var_24_15, var_24_16 = fn_2(_world, nav_world, _level, _nav_tag_volume_handler, check_no_spawn_volumes_for_special_spawning, get_relative_main_path_pos, num, self._side)

		if not var_24_15 then
			return false, var_24_16
		end

		local alive_specials = conflict:alive_specials()
		local tbl = {
			spawned_func = fn_4,
			slot = var_24_3,
			alive_specials = alive_specials
		}

		var_24_3.state = "wants_to_spawn"

		if not var_24_5.special_spawn_stinger then
			self:_play_stinger(var_24_5.special_spawn_stinger, var_24_3)
		end

		Managers.state.conflict:spawn_queued_unit(var_24_5, Vector3Box(var_24_15), QuaternionBox(Quaternion(Vector3.up(), 0)), "rush_intervention", nil, nil, tbl)

		return true, "rush special"
	end
end

local function fn_5(arg_25_0, arg_25_1, arg_25_2)
	-- function 25
	local slot = arg_25_2.slot

	slot.breed = arg_25_1.name
	slot.unit = arg_25_0
	slot.time = nil
	slot.state = "alive"
	slot.desc = "speed running intervention"

	local alive_specials = arg_25_2.alive_specials

	alive_specials[#alive_specials + 1] = arg_25_0

	print("Speed run intervention - spawning ", arg_25_1.name)
end

SpecialsPacing.request_speed_running_intervention = function (self, arg_26_1, arg_26_2, arg_26_3)
	-- function 26
	if script_data.ai_specials_spawning_disabled or not Managers.state.game_mode:setting("ai_specials_spawning_disabled") then
		return false, "specials spawning disabled"
	end

	if not ScriptUnit.extension(arg_26_2, "status_system"):is_disabled() then
		return false, "no speed running intervention, since speed runner is disabled"
	end

	local CurrentSpecialsSettings = CurrentSpecialsSettings
	local speed_running_intervention = CurrentSpecialsSettings.speed_running_intervention

	speed_running_intervention = speed_running_intervention or SpecialsSettings.default.speed_running_intervention

	local breeds = speed_running_intervention.breeds
	local _specials_slots = self._specials_slots
	local var_26_4 = fn_3(_specials_slots)

	if not var_26_4 then
		local var_26_5 = _specials_slots[var_26_4]
		local var_26_6 = breeds[Math.random(1, #breeds)]
		local var_26_7 = Breeds[var_26_6]
		local conflict = Managers.state.conflict
		local get_main_paths = conflict.level_analysis:get_main_paths()
		local _world = conflict._world
		local nav_world = self.nav_world
		local _level = self._level
		local _nav_tag_volume_handler = self._nav_tag_volume_handler
		local num = 25
		local get_relative_main_path_pos = self:get_relative_main_path_pos(get_main_paths, arg_26_3[arg_26_2], 20)
		local check_no_spawn_volumes_for_special_spawning = LevelHelper.current_level_settings().check_no_spawn_volumes_for_special_spawning
		local var_26_17, var_26_18 = fn_2(_world, nav_world, _level, _nav_tag_volume_handler, check_no_spawn_volumes_for_special_spawning, get_relative_main_path_pos, num, self._side)

		if not var_26_17 then
			return false, var_26_18
		end

		local alive_specials = conflict:alive_specials()
		local tbl = {
			spawned_func = fn_5,
			slot = var_26_5,
			alive_specials = alive_specials
		}

		var_26_5.state = "wants_to_spawn"

		if not var_26_7.special_spawn_stinger then
			self:_play_stinger(var_26_7.special_spawn_stinger, var_26_5)
		end

		Managers.state.conflict:spawn_queued_unit(var_26_7, Vector3Box(var_26_17), QuaternionBox(Quaternion(Vector3.up(), 0)), "speed_run_intervention", nil, nil, tbl)

		return true, var_26_6
	end

	return false, "no slots available"
end

SpecialsPacing.get_relative_main_path_pos = function (arg_27_0, arg_27_1, arg_27_2, arg_27_3)
	-- function 27
	local point_on_mainpath, var_27_1 = MainPathUtils.point_on_mainpath(arg_27_1, arg_27_2.travel_dist + arg_27_3)
	local var_27_2
	local var_27_3

	if not (not point_on_mainpath and var_27_1 ~= arg_27_2.path_index) then
		var_27_2 = point_on_mainpath
	else
		var_27_2 = POSITION_LOOKUP[arg_27_2.unit]
		var_27_3 = true
	end

	return var_27_2, var_27_3
end

SpecialsPacing.debug = function (arg_28_0, arg_28_1, arg_28_2, arg_28_3, arg_28_4)
	-- function 28
	if not script_data.debug_ai_pacing then
		local str = ""

		for i = 1, #arg_28_4 do
			local var_28_1 = arg_28_4[i]

			if not var_28_1.time then
				local num = var_28_1.time - arg_28_1

				if num > 0.5 then
					if not var_28_1.special_spawn_stinger then
						Debug.text(string.format(" [%d] %s: SPAWNS IN %0.1f, STINGER IN %0.1f ", i, var_28_1.breed, num, math.max(var_28_1.special_spawn_stinger_at_t - arg_28_1, 0)))
					elseif not var_28_1.health_modifier then
						Debug.text(string.format(" [%d] %s: SPAWNS IN %0.1f, HEALTH MODIFIER ", i, var_28_1.breed, num))
					else
						Debug.text(string.format(" [%d] %s: SPAWNS IN %0.1f, ", i, var_28_1.breed, num))
					end
				else
					Debug.text(string.format(" [%d] %s: SPAWNING NOW, ", i, var_28_1.breed))
				end
			elseif var_28_1.state ~= "coordinating" or not var_28_1.health_modifier then
				Debug.text(string.format(" [%d] %s: COODINATED SPAWN, HEALTH MODIFIER %s", i, var_28_1.breed))
			elseif var_28_1.state == "coordinating" then
				Debug.text(string.format(" [%d] %s: COORDINATING, %s", i, var_28_1.breed, tostring(var_28_1.desc)))
			else
				Debug.text(string.format(" [%d] %s: ALIVE, %s", i, var_28_1.breed, tostring(var_28_1.desc)))
			end
		end

		Debug.text("Specials: " .. str)
	end
end
