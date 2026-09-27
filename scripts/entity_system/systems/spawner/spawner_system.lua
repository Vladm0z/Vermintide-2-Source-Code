-- chunkname: @scripts/entity_system/systems/spawner/spawner_system.lua

require("scripts/hub_elements/ai_spawner")

local function fn(...)
	-- function 1
	if not script_data.debug_hordes then
		printf(...)
	end
end

SpawnerSystem = class(SpawnerSystem, ExtensionSystemBase)

local tbl = {
	"AISpawner"
}
local script_data = script_data

SpawnerSystem.init = function (self, arg_2_1, arg_2_2)
	-- function 2
	SpawnerSystem.super.init(self, arg_2_1, arg_2_2, tbl)

	self._spawn_list = {}
	self._active_spawners = {}
	self._enabled_spawners = {}
	self._disabled_spawners = {}
	self._num_hidden_spawners = 0
	self._id_lookup = {}
	self._raw_id_lookup = {}
	self._hidden_spawners = {}
	self._disabled_hidden_spawners = {}
	self._spawner_broadphase_id = {}

	Managers.state.event:register(self, "spawn_horde", "spawn_horde")

	self.hidden_spawners_broadphase = Broadphase(40, 512)
	self._use_alt_horde_spawning = Managers.mechanism:setting("use_alt_horde_spawning")
	self._breed_limits = {}
end

local tbl_2 = {
	"skaven_slave",
	"skaven_clan_rat",
	"skaven_slave",
	"skaven_clan_rat",
	"skaven_slave",
	"skaven_clan_rat",
	"skaven_slave",
	"skaven_clan_rat",
	"skaven_slave",
	"skaven_clan_rat"
}

SpawnerSystem.update_test_all_spawners = function (self, arg_3_1)
	-- function 3
	local _enabled_spawners = self._enabled_spawners
	local index = self._test_data.index
	local num = 0
	local num_2 = 2

	while not (not (index <= #_enabled_spawners) or not (self.tests_running < 6) or not (num < 10)) do
		local var_3_4 = _enabled_spawners[index]
		local tbl = {
			template = "spawn_test",
			size = 10,
			id = Managers.state.entity:system("ai_group_system"):generate_group_id(),
			spawner_unit = var_3_4,
			group_data = {
				spawner_unit = var_3_4
			}
		}
		local local_position = Unit.local_position(var_3_4, 0)

		QuickDrawerStay:sphere(local_position, 0.66, Color(60, 200, 0))
		Debug.world_sticky_text(local_position, tbl.id, "green")
		print("START TEST for ", tbl.id)
		self:spawn_horde(var_3_4, tbl_2, num_2, tbl)

		index = index + 1
		num = num + 1
		self.tests_running = self.tests_running + 1
	end

	if index > #_enabled_spawners then
		print("All spawners tested")

		self._test_data = nil
	else
		self._test_data.index = index
	end
end

SpawnerSystem.test_all_spawners = function (self)
	-- function 4
	self.tests_running = 0

	print("")
	print(string.format("Starting spawner test. Found %d spawners.", #self._enabled_spawners))

	self._test_data = {
		index = 1
	}
end

SpawnerSystem.running_spawners = function (self)
	-- function 5
	return self._active_spawners
end

SpawnerSystem.enabled_spawners = function (self)
	-- function 6
	return self._enabled_spawners
end

SpawnerSystem.hidden_spawners_lookup = function (self)
	-- function 7
	return self._hidden_spawners
end

SpawnerSystem.register_enabled_spawner = function (self, arg_8_1, arg_8_2, arg_8_3)
	-- function 8
	self._enabled_spawners[#self._enabled_spawners + 1] = arg_8_1

	if not arg_8_2 then
		local var_8_0 = self._id_lookup[arg_8_2]

		if not var_8_0 then
			var_8_0 = {}
			self._id_lookup[arg_8_2] = var_8_0
		end

		var_8_0[#var_8_0 + 1] = arg_8_1
	end

	if not arg_8_3 then
		self:_add_broadphase(arg_8_1)
	end
end

SpawnerSystem.hibernate_spawner = function (self, arg_9_1, arg_9_2)
	-- function 9
	local _enabled_spawners = self._enabled_spawners
	local count = #_enabled_spawners
	local _disabled_spawners = self._disabled_spawners
	local var_9_3 = _disabled_spawners[arg_9_1]
	local _hidden_spawners = self._hidden_spawners
	local var_9_5 = _hidden_spawners[arg_9_1]
	local _disabled_hidden_spawners = self._disabled_hidden_spawners
	local var_9_7 = _disabled_hidden_spawners[arg_9_1]

	if not arg_9_2 then
		if not var_9_3 then
			self:_hibernate_spawner(count, _enabled_spawners, _disabled_spawners, arg_9_1)
		end

		if not (not var_9_5 and var_9_7) then
			self:_hibernate_hidden_spawner(_hidden_spawners, _disabled_hidden_spawners, arg_9_1)
			self:_remove_broadphase(arg_9_1)
		end
	else
		if not var_9_3 then
			self:_awaken_spawner(_enabled_spawners, _disabled_spawners, arg_9_1)
		end

		if not var_9_7 then
			self:_awaken_hidden_spawner(_hidden_spawners, _disabled_hidden_spawners, arg_9_1)
			self:_add_broadphase(arg_9_1)
		end
	end
end

SpawnerSystem._hibernate_spawner = function (arg_10_0, arg_10_1, arg_10_2, arg_10_3, arg_10_4)
	-- function 10
	for i = 1, arg_10_1 do
		if arg_10_2[i] == arg_10_4 then
			table.swap_delete(arg_10_2, i)

			arg_10_3[arg_10_4] = true

			break
		end
	end
end

SpawnerSystem._hibernate_hidden_spawner = function (arg_11_0, arg_11_1, arg_11_2, arg_11_3)
	-- function 11
	arg_11_1[arg_11_3] = nil
	arg_11_2[arg_11_3] = true
end

SpawnerSystem._awaken_spawner = function (arg_12_0, arg_12_1, arg_12_2, arg_12_3)
	-- function 12
	arg_12_2[arg_12_3] = nil
	arg_12_1[#arg_12_1 + 1] = arg_12_3
end

SpawnerSystem._awaken_hidden_spawner = function (arg_13_0, arg_13_1, arg_13_2, arg_13_3)
	-- function 13
	arg_13_2[arg_13_3] = nil
	arg_13_1[arg_13_3] = true
end

SpawnerSystem._add_broadphase = function (self, arg_14_1)
	-- function 14
	local local_position = Unit.local_position(arg_14_1, 0)
	local add = Broadphase.add(self.hidden_spawners_broadphase, arg_14_1, local_position, 1)

	self._hidden_spawners[arg_14_1] = true
	self._spawner_broadphase_id[arg_14_1] = add
	self._num_hidden_spawners = self._num_hidden_spawners + 1
end

SpawnerSystem._remove_broadphase = function (self, arg_15_1)
	-- function 15
	local var_15_0 = self._spawner_broadphase_id[arg_15_1]

	Broadphase.remove(self.hidden_spawners_broadphase, var_15_0)

	self._spawner_broadphase_id[arg_15_1] = nil
	self._num_hidden_spawners = self._num_hidden_spawners - 1
end

SpawnerSystem.register_raw_spawner = function (self, arg_16_1, arg_16_2)
	-- function 16
	if not arg_16_2 then
		local var_16_0 = self._raw_id_lookup[arg_16_2]

		if not var_16_0 then
			var_16_0 = {}
			self._raw_id_lookup[arg_16_2] = var_16_0
		end

		var_16_0[#var_16_0 + 1] = arg_16_1
	end
end

local tbl_3 = {}
local tbl_4 = {}
local tbl_5 = {}

SpawnerSystem.spawn_horde = function (arg_17_0, arg_17_1, arg_17_2, arg_17_3, arg_17_4, arg_17_5)
	-- function 17
	local extension = ScriptUnit.extension(arg_17_1, "spawner_system")

	arg_17_0._active_spawners[arg_17_1] = extension

	extension:on_activate(arg_17_2, arg_17_3, arg_17_4, arg_17_5)

	return (extension:spawn_rate())
end

local function fn_2(self, arg_18_1, arg_18_2, arg_18_3)
	-- function 18
	local num = 1

	for i = arg_18_1, arg_18_2 do
		arg_18_3[num] = self[i]
		num = num + 1
	end
end

SpawnerSystem.set_breed_event_horde_spawn_limit = function (arg_19_0, arg_19_1, arg_19_2)
	-- function 19
	arg_19_0._breed_limits[arg_19_1] = arg_19_2
end

local tbl_6 = {}
local tbl_7 = {}
local num = 1

for k, v in pairs(Breeds) do
	tbl_7[num] = k
	num = num + 1
end

table.sort(tbl_7, function (arg_20_0, arg_20_1)
	-- function 20
	return Breeds[arg_20_0].exchange_order < Breeds[arg_20_1].exchange_order
end)
table.dump(tbl_7)

SpawnerSystem._try_spawn_breed = function (self, arg_21_1, arg_21_2, arg_21_3, arg_21_4, arg_21_5, arg_21_6, arg_21_7)
	-- function 21
	local var_21_0 = arg_21_2[arg_21_1]

	if not var_21_0 then
		local var_21_1 = arg_21_4[arg_21_1]

		if not var_21_1 then
			local min = math.min(arg_21_5 + var_21_0 - var_21_1.max_active_enemies, var_21_0)
			local exchange_ratio = var_21_1.exchange_ratio

			if exchange_ratio < min then
				local floor = math.floor(min / exchange_ratio)

				var_21_0 = var_21_0 - floor * exchange_ratio

				local spawn_breed = var_21_1.spawn_breed

				if type(spawn_breed) == "table" then
					local count = #spawn_breed

					for i = 1, floor do
						local var_21_7 = spawn_breed[Math.random(1, count)]
						local var_21_8 = arg_21_2[var_21_7]

						var_21_8 = var_21_8 or 0
						arg_21_2[var_21_7] = var_21_8 + 1
					end

					for j = 1, count do
						arg_21_5 = arg_21_5 + self:_try_spawn_breed(spawn_breed[j], arg_21_2, arg_21_3, arg_21_4, arg_21_5, arg_21_6, arg_21_7)
					end
				else
					local var_21_9 = arg_21_2[spawn_breed]

					var_21_9 = var_21_9 or 0
					arg_21_2[spawn_breed] = var_21_9 + floor
					arg_21_5 = arg_21_5 + self:_try_spawn_breed(spawn_breed, arg_21_2, arg_21_3, arg_21_4, arg_21_5, arg_21_6, arg_21_7)
				end
			end
		end

		local num = #arg_21_3 + 1

		arg_21_5 = arg_21_5 + var_21_0

		if not arg_21_7 then
			arg_21_7.size = arg_21_7.size + var_21_0
		end

		local num_2 = num + var_21_0 - 1

		for k = num, num_2 do
			arg_21_3[k] = arg_21_1
		end
	end

	return arg_21_5
end

SpawnerSystem._fill_spawners = function (arg_22_0, arg_22_1, arg_22_2, arg_22_3, arg_22_4, arg_22_5, arg_22_6, arg_22_7, arg_22_8)
	-- function 22
	local count = #arg_22_1

	if count <= 0 then
		return count
	end

	local count_2 = #arg_22_2

	table.shuffle(arg_22_2)

	if not arg_22_3 then
		if not arg_22_6 then
			local var_22_2 = POSITION_LOOKUP[arg_22_7]

			while arg_22_3 < #arg_22_2 do
				local num = 1
				local num_2 = 0

				for i = 1, #arg_22_2 do
					local distance_squared = Vector3.distance_squared(var_22_2, Unit.local_position(arg_22_2[i], 0))

					if num_2 < distance_squared then
						num_2 = distance_squared
						num = i
					end
				end

				table.swap_delete(arg_22_2, num)
			end
		else
			for j = arg_22_3 + 1, count_2 do
				arg_22_2[j] = nil
			end
		end

		count_2 = #arg_22_2
	end

	local num_3 = 1

	for k = 1, count_2 do
		local floor = math.floor(count / (count_2 - k + 1))

		count = count - floor

		local var_22_8 = arg_22_2[k]
		local extension = ScriptUnit.extension(var_22_8, "spawner_system")

		arg_22_0._active_spawners[var_22_8] = extension

		table.clear_array(tbl_5, #tbl_5)
		fn_2(arg_22_1, num_3, num_3 + floor - 1, tbl_5)
		extension:on_activate(tbl_5, arg_22_4, arg_22_5, arg_22_8)

		num_3 = num_3 + floor
	end

	return #arg_22_1
end

local tbl_8 = {
	skaven_clan_rat = true,
	skaven_slave = true
}

SpawnerSystem.spawn_horde_from_terror_event_ids = function (self, arg_23_1, arg_23_2, arg_23_3, arg_23_4, arg_23_5, arg_23_6, arg_23_7, arg_23_8, arg_23_9)
	-- function 23
	local ConflictUtils = ConflictUtils
	local must_use_hidden_spawners = arg_23_2.must_use_hidden_spawners
	local var_23_2
	local var_23_3
	local var_23_4
	local random = math.random()

	if not (not arg_23_1 and not (#arg_23_1 > 0)) then
		var_23_2 = {}
		var_23_3 = {}

		for i, v in ipairs(arg_23_1) do
			local var_23_6 = self._id_lookup[v]

			if not var_23_6 then
				for k = 1, #var_23_6 do
					local var_23_7 = var_23_6[k]

					if not self._disabled_spawners[var_23_7] then
						if not Unit.get_data(var_23_7, "hidden") then
							var_23_3[#var_23_3 + 1] = var_23_7
						end

						var_23_2[#var_23_2 + 1] = var_23_7
					end
				end
			else
				fassert("No horde spawners found with terror_id %d ", v)

				return
			end
		end

		if #var_23_2 == 0 then
			return
		end

		var_23_4 = self._use_alt_horde_spawning ~= true
	else
		local PLAYER_POSITIONS = Managers.state.side:get_side_from_name("heroes").PLAYER_POSITIONS

		if not arg_23_5 then
			var_23_2, var_23_3 = ConflictUtils.filter_horde_spawners_strictly(PLAYER_POSITIONS, self._enabled_spawners, self._hidden_spawners, 10, 35)
		else
			var_23_2, var_23_3 = ConflictUtils.filter_horde_spawners(PLAYER_POSITIONS, self._enabled_spawners, self._hidden_spawners, 10, 35)
		end

		if not (not must_use_hidden_spawners and #var_23_3 ~= 0) then
			local var_23_9 = PLAYER_POSITIONS[1]

			if not var_23_9 then
				local get_random_hidden_spawner = ConflictUtils.get_random_hidden_spawner(var_23_9, 40)

				if not get_random_hidden_spawner then
					var_23_3 = {
						get_random_hidden_spawner
					}
				end
			end

			if #var_23_3 == 0 then
				print("Can't find any hidden spawners for this breed")

				return
			end
		end

		if not next(var_23_2) then
			return
		end
	end

	if #var_23_2 == 0 then
		return
	end

	local difficulty = Managers.state.difficulty.difficulty
	local difficulty_breeds = arg_23_2.difficulty_breeds
	local var_23_13

	if not difficulty_breeds then
		var_23_13 = difficulty_breeds[difficulty]

		if not var_23_13 then
			-- Nothing
		end
	end

	var_23_13 = arg_23_2.breeds

	::label_23_0::

	local var_23_14 = tbl_3

	table.clear_array(var_23_14, #var_23_14)

	local var_23_15 = tbl_4

	table.clear_array(var_23_15, #var_23_15)

	for l = 1, #var_23_13, 2 do
		local var_23_16 = var_23_13[l]
		local var_23_17 = var_23_13[l + 1]
		local var_23_18

		if type(var_23_17) == "table" then
			var_23_18 = Math.random(var_23_17[1], var_23_17[2])
		else
			var_23_18 = var_23_17
		end

		if not script_data.big_hordes then
			local round = math.round
			local var_23_20 = tonumber(script_data.big_hordes)

			var_23_20 = var_23_20 or 1
			var_23_18 = round(var_23_18 * var_23_20)
		end

		tbl_6[var_23_16] = var_23_18
	end

	local var_23_21 = tbl_7
	local _breed_limits = self._breed_limits
	local count = #var_23_21
	local num_active_enemies = Managers.state.performance:num_active_enemies()

	for i4 = 1, count do
		local var_23_25 = var_23_21[i4]

		if var_23_4 or not tbl_8[var_23_25] then
			self:_try_spawn_breed(var_23_25, tbl_6, var_23_14, _breed_limits, num_active_enemies, arg_23_6, arg_23_4)
		else
			self:_try_spawn_breed(var_23_25, tbl_6, var_23_15, _breed_limits, num_active_enemies, arg_23_6, arg_23_4)
		end
	end

	table.clear(tbl_6)
	table.shuffle(var_23_14)

	local num = 0
	local num_2 = 0
	local _fill_spawners = self:_fill_spawners(var_23_14, var_23_2, arg_23_3, arg_23_6, arg_23_4, arg_23_7, arg_23_8, arg_23_9)

	if var_23_4 or not must_use_hidden_spawners then
		local _fill_spawners_2 = self:_fill_spawners(var_23_15, var_23_3, arg_23_3, arg_23_6, arg_23_4, arg_23_7, arg_23_8, arg_23_9)

		if _fill_spawners_2 > 0 then
			return "success", _fill_spawners + _fill_spawners_2
		end
	end

	if _fill_spawners > 0 then
		return "success", _fill_spawners
	end
end

SpawnerSystem.change_spawner_id = function (self, arg_24_1, arg_24_2, arg_24_3)
	-- function 24
	if not arg_24_1 then
		local get_data = Unit.get_data(arg_24_1, "terror_event_id")

		if not (get_data == "" or get_data ~= arg_24_3) then
			return
		end

		local var_24_1 = self._id_lookup[get_data]

		if not var_24_1 then
			local count = #var_24_1

			for i = 1, count do
				if var_24_1[i] == arg_24_1 then
					var_24_1[i] = var_24_1[count]
					var_24_1[count] = nil

					break
				end
			end
		end

		local var_24_3 = self._id_lookup[arg_24_3]

		if not var_24_3 then
			var_24_3 = {}
			self._id_lookup[arg_24_3] = var_24_3
		end

		var_24_3[#var_24_3 + 1] = arg_24_1

		Unit.set_data(arg_24_1, "terror_event_id", arg_24_3)

		return
	end

	local var_24_4 = self._id_lookup[arg_24_2]
	local var_24_5 = self._id_lookup[arg_24_3]

	if not var_24_5 then
		var_24_5 = {}
		self._id_lookup[arg_24_3] = var_24_5
	end

	if not var_24_4 then
		local count_2 = #var_24_4
		local count_3 = #var_24_5

		for j = 1, count_2 do
			var_24_5[count_3 + j] = var_24_4[j]

			Unit.set_data(var_24_4[j], "terror_event_id", arg_24_3)

			var_24_4[j] = nil
		end
	else
		print("Can't find spawners called: ", arg_24_2, " so cannot rename any")
	end
end

SpawnerSystem.get_raw_spawner_unit = function (self, arg_25_1)
	-- function 25
	local var_25_0 = self._raw_id_lookup[arg_25_1]

	var_25_0 = var_25_0 or self._id_lookup[arg_25_1]

	if not var_25_0 then
		local var_25_1 = var_25_0[math.random(1, #var_25_0)]
		local get_data = Unit.get_data(var_25_1, "idle_animation")

		return var_25_1, get_data
	end
end

SpawnerSystem.get_raw_spawner_units = function (self, arg_26_1)
	-- function 26
	local var_26_0 = self._raw_id_lookup[arg_26_1]

	var_26_0 = var_26_0 or self._id_lookup[arg_26_1]

	return var_26_0
end

SpawnerSystem.deactivate_spawner = function (arg_27_0, arg_27_1)
	-- function 27
	arg_27_0._active_spawners[arg_27_1] = nil
end

SpawnerSystem.debug_show_spawners = function (arg_28_0, arg_28_1, arg_28_2)
	-- function 28
	local num = 70
	local var_28_1 = Vector3(0, 0, num)
	local var_28_2 = Color(255, 0, 200, 0)

	for k, v in pairs(arg_28_2) do
		local local_position = Unit.local_position(k, 0)

		QuickDrawer:line(local_position, local_position + var_28_1, var_28_2)

		local num_2 = 7 * (arg_28_1 % 10)

		QuickDrawer:sphere(local_position + Vector3(0, 0, num_2), 0.5, var_28_2)
		QuickDrawer:sphere(local_position + Vector3(0, 0, (num_2 + 10) % num), 0.5, var_28_2)
		QuickDrawer:sphere(local_position + Vector3(0, 0, (num_2 + 20) % num), 0.5, var_28_2)
	end
end

SpawnerSystem.set_spawn_list = function (self, arg_29_1)
	-- function 29
	self._spawn_list = arg_29_1
end

SpawnerSystem.pop_pawn_list = function (self)
	-- function 30
	local _spawn_list = self._spawn_list
	local count = #_spawn_list

	if count <= 0 then
		return
	end

	local var_30_2 = _spawn_list[count]

	_spawn_list[count] = nil

	return var_30_2
end

local tbl_9 = {}
local tbl_10 = {}

SpawnerSystem.update = function (self, arg_31_1, arg_31_2, arg_31_3)
	-- function 31
	for k, v in pairs(self._active_spawners) do
		v:update(k, tbl_9, arg_31_3, arg_31_1, arg_31_2)
	end
end

SpawnerSystem.show_hidden_spawners = function (self, arg_32_1)
	-- function 32
	local local_position = Unit.local_position
	local var_32_1 = Managers.state.side:get_side_from_name("heroes").PLAYER_POSITIONS[1]
	local free_flight = Managers.free_flight

	if not free_flight:active("global") then
		var_32_1 = free_flight:camera_position_rotation()
	end

	local sin = math.sin(arg_32_1 * 10)
	local var_32_4 = Color(192 + 64 * sin, 192 + 64 * sin, 0)
	local var_32_5 = Color(192 + 64 * sin, 0, 0)
	local num = 0
	local num_2 = 0
	local num_3 = 40

	if not var_32_1 then
		local nav_world = Managers.state.entity:system("ai_system"):nav_world()

		num = Broadphase.query(self.hidden_spawners_broadphase, var_32_1, num_3, tbl_10)

		local num_4 = math.sin(arg_32_1 * 5) * 0.33
		local var_32_11 = Vector3(num_4, num_4, 0)
		local var_32_12 = Vector3(num_4, num_4, 30)

		for i = 1, num do
			local var_32_13 = tbl_10[i]
			local var_32_14 = local_position(var_32_13, 0)

			if not GwNavQueries.triangle_from_position(nav_world, var_32_14, 0.5, 0.5) then
				QuickDrawer:line(var_32_14 + var_32_11, var_32_14 + var_32_12, var_32_4)
				QuickDrawer:sphere(var_32_14, 0.15, var_32_4)
			else
				QuickDrawer:line(var_32_14 + var_32_11, var_32_14 + var_32_12, var_32_5)
				QuickDrawer:sphere(var_32_14, 0.15, var_32_4)

				num_2 = num_2 + 1
			end
		end
	end

	if num_2 == 0 then
		Debug.text("This level has %d hidden spawners. (%d within %d meters)", self._num_hidden_spawners, num, num_3)

		if not var_32_1 then
			QuickDrawer:circle(var_32_1 + Vector3(0, 0, 20), num_3, Vector3.up(), var_32_4)
		end
	else
		Debug.text("This level has %d hidden spawners. (%d within %d meters, %d are not on nav-mesh)", self._num_hidden_spawners, num, num_3, num_2)

		if not var_32_1 then
			QuickDrawer:circle(var_32_1 + Vector3(0, 0, 20), num_3, Vector3.up(), var_32_5)
		end
	end
end
