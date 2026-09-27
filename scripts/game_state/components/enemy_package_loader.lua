-- chunkname: @scripts/game_state/components/enemy_package_loader.lua

require("scripts/settings/enemy_package_loader_settings")
require("scripts/managers/conflict_director/main_path_spawning_generator")
require("scripts/managers/conflict_director/conflict_utils")

EnemyPackageLoader = class(EnemyPackageLoader)

local str = "EnemyPackageLoader"
local breed_path = EnemyPackageLoaderSettings.breed_path
local alias_to_breed = EnemyPackageLoaderSettings.alias_to_breed
local breed_to_aliases = EnemyPackageLoaderSettings.breed_to_aliases
local opt_lookup_breed_names = EnemyPackageLoaderSettings.opt_lookup_breed_names

local function fn(arg_1_0, arg_1_1, arg_1_2)
	-- function 1
	local num = 0
	local count = #arg_1_1

	for i = 1, count do
		local num_2 = num + arg_1_2[arg_1_1[i]]

		if not (not (num <= arg_1_0) or not (arg_1_0 < num_2)) then
			return i
		end

		num = num_2
	end

	return count
end

local function fn_2(self, arg_2_1, arg_2_2)
	-- function 2
	local num = 0

	for i = 1, #self do
		local var_2_1 = self[i]

		if not arg_2_1[var_2_1] then
			arg_2_1[var_2_1] = arg_2_2
		end

		num = num + arg_2_1[var_2_1]
	end

	for k, v in pairs(arg_2_1) do
		arg_2_1[k] = v / num
	end

	print("Updated list weights for random:")

	local num_2 = 0

	for l = 1, #self do
		local var_2_3 = self[l]
		local var_2_4 = arg_2_1[var_2_3]

		printf("\t %s, %.2f (%.2f-%.2f)", var_2_3, var_2_4, num_2, num_2 + var_2_4)

		num_2 = num_2 + var_2_4
	end
end

EnemyPackageLoader.init = function (self)
	-- function 3
	self._use_optimized = script_data.use_optimized_breed_units
	self._breed_to_package_name_cache = {}
	self._locked_breeds = {}
	self._random_director_list = nil
	self._breed_category_loaded_packages = {}
	self._breed_category_lookup = {}
	self._loaded_breed_map = {}
end

local tbl = {}

EnemyPackageLoader.register_rpcs = function (self, arg_4_1)
	-- function 4
	self.network_event_delegate = arg_4_1

	arg_4_1:register(self, unpack(tbl))
end

EnemyPackageLoader.unregister_rpcs = function (self)
	-- function 5
	self.network_event_delegate:unregister(self)

	self.network_event_delegate = nil
end

EnemyPackageLoader.set_unit_spawner = function (self, arg_6_1)
	-- function 6
	self._unit_spawner = arg_6_1
end

EnemyPackageLoader.network_context_created = function (self, arg_7_1, arg_7_2, arg_7_3, arg_7_4)
	-- function 7
	printf("[EnemyPackageLoader] network_context_created (server_peer_id=%s, own_peer_id=%s)", arg_7_2, arg_7_3)

	self._lobby = arg_7_1
	self._server_peer_id = arg_7_2
	self._peer_id = arg_7_3

	local flag = arg_7_2 == arg_7_3

	self._is_server = flag

	if not flag then
		self._breeds_to_load_at_startup = {}
		self._session_breed_map = {}
	end

	self._network_handler = arg_7_4
end

EnemyPackageLoader.matching_session = function (self, arg_8_1)
	-- function 8
	return self._network_handler == arg_8_1
end

EnemyPackageLoader.network_context_destroyed = function (self)
	-- function 9
	print("[EnemyPackageLoader] network_context_destroyed")

	self._lobby = nil
	self._server_peer_id = nil
	self._peer_id = nil
	self._network_handler = nil

	if not self._is_server then
		self._session_breed_map = nil
	end

	self._is_server = nil
end

EnemyPackageLoader._find_unused_breed_to_unload = function (self, arg_10_1)
	-- function 10
	local conflict = Managers.state.conflict
	local num_spawned_by_breed = conflict.num_spawned_by_breed
	local num_queued_spawn_by_breed = conflict.num_queued_spawn_by_breed
	local _unit_spawner = self._unit_spawner
	local _locked_breeds = self._locked_breeds
	local package = Managers.package

	for k, v in pairs(arg_10_1) do
		if not (_locked_breeds[k] or not (num_queued_spawn_by_breed[k] <= 0) or not (num_spawned_by_breed[k] <= 0) or _unit_spawner:breed_in_death_watch(k)) then
			local var_10_6 = breed_to_aliases[k]
			local flag = false

			if not var_10_6 then
				local count = #var_10_6

				for k_2 = 1, count do
					local var_10_9 = var_10_6[k_2]

					if num_queued_spawn_by_breed[var_10_9] > 0 or num_spawned_by_breed[var_10_9] > 0 or not _unit_spawner:breed_in_death_watch(var_10_9) then
						flag = true

						break
					end
				end
			end

			if flag or not package:can_unload(self:_breed_package_name(k)) then
				return k
			end
		end
	end
end

EnemyPackageLoader._pick_breed_from_processed_breeds = function (self, arg_11_1, arg_11_2)
	-- function 11
	local get_session_breed_map = self._network_handler:get_session_breed_map()
	local random = math.random(1, arg_11_2)
	local num = 0
	local count = #arg_11_1

	for i = 1, count do
		local var_11_4 = arg_11_1[i]

		if not get_session_breed_map[var_11_4] then
			num = num + 1

			if random <= num then
				return var_11_4
			end
		end
	end

	ferror("[EnemyPackageLoader:_pick_breed_from_processed_breeds] No breed found, this should not happen!")
end

EnemyPackageLoader.request_breed = function (self, arg_12_1, arg_12_2, arg_12_3)
	-- function 12
	assert(self._is_server, "[EnemyPackageLoader] 'request_breed' is a server only function")

	arg_12_1 = alias_to_breed[arg_12_1] or arg_12_1

	local _category = self:_category(arg_12_1)
	local current = _category.current
	local limit = _category.limit

	if not (arg_12_2 or not (limit <= current)) then
		local loaded_breeds = _category.loaded_breeds
		local _find_unused_breed_to_unload = self:_find_unused_breed_to_unload(loaded_breeds)

		if not _find_unused_breed_to_unload then
			self:_unload_package(_find_unused_breed_to_unload)
		else
			local replacement_breed_override_funcs = _category.replacement_breed_override_funcs

			replacement_breed_override_funcs = not replacement_breed_override_funcs and _category.replacement_breed_override_funcs[arg_12_3]

			if not replacement_breed_override_funcs then
				local var_12_6 = self[replacement_breed_override_funcs](self)

				return false, var_12_6
			else
				local breeds = _category.breeds
				local _pick_breed_from_processed_breeds = self:_pick_breed_from_processed_breeds(breeds, limit)

				return false, _pick_breed_from_processed_breeds
			end
		end
	end

	self:_load_package(arg_12_1, _category)

	return true
end

local tbl_2 = {}
local tbl_3 = {}

EnemyPackageLoader.find_patrol_replacement = function (self)
	-- function 13
	table.clear(tbl_2)
	table.clear(tbl_3)

	local _breeds_to_load_at_startup = self._breeds_to_load_at_startup

	for i, v in ipairs(_breeds_to_load_at_startup) do
		local var_13_1 = Breeds[v]

		if not var_13_1.patrol_passive_perception and not var_13_1.patrol_passive_target_selection then
			if not var_13_1.elite then
				tbl_2[#tbl_2 + 1] = v
			elseif not (var_13_1.boss or var_13_1.special) then
				tbl_3[#tbl_3 + 1] = v
			end
		end
	end

	print("### REPLACING BREED IN PATROL")

	local var_13_2

	if table.size(tbl_2) > 0 then
		local random = Math.random(#tbl_2)

		var_13_2 = tbl_2[random]
	else
		local random_2 = Math.random(#tbl_3)

		var_13_2 = tbl_3[random_2]
	end

	print(string.format(" - Replacement breed name %q", var_13_2))

	return var_13_2
end

EnemyPackageLoader.is_breed_processed = function (self, arg_14_1)
	-- function 14
	arg_14_1 = alias_to_breed[arg_14_1] or arg_14_1

	return self._network_handler:get_session_breed_map()[arg_14_1]
end

EnemyPackageLoader.processed_breeds = function (self)
	-- function 15
	return self._network_handler:get_session_breed_map()
end

EnemyPackageLoader._set_breed_package_lock = function (self, arg_16_1, arg_16_2)
	-- function 16
	local flag

	flag = not arg_16_2 and 1 and -1

	local _locked_breeds = self._locked_breeds
	local var_16_2 = breed_to_aliases[arg_16_1]

	if not var_16_2 then
		local count = #var_16_2

		for i = 1, count do
			local var_16_4 = var_16_2[i]
			local var_16_5 = _locked_breeds[var_16_4]

			var_16_5 = var_16_5 or 0
			_locked_breeds[var_16_4] = var_16_5 + flag

			if _locked_breeds[var_16_4] == 0 then
				_locked_breeds[var_16_4] = nil
			end
		end
	end

	local var_16_6 = _locked_breeds[arg_16_1]

	var_16_6 = var_16_6 or 0
	_locked_breeds[arg_16_1] = var_16_6 + flag

	if _locked_breeds[arg_16_1] == 0 then
		_locked_breeds[arg_16_1] = nil
	end

	fassert(not _locked_breeds[arg_16_1] and _locked_breeds[arg_16_1] > 0, "EnemyPackageLoader: Called unlock breed package more times than lock!")
end

EnemyPackageLoader.lock_breed_package = function (self, arg_17_1)
	-- function 17
	self:_set_breed_package_lock(arg_17_1, true)
end

EnemyPackageLoader.unlock_breed_package = function (self, arg_18_1)
	-- function 18
	self:_set_breed_package_lock(arg_18_1, false)
end

EnemyPackageLoader._load_package = function (self, arg_19_1, arg_19_2)
	-- function 19
	assert(self._is_server, "[EnemyPackageLoader] '_load_package' is a server only function.")

	arg_19_2.current = arg_19_2.current + 1

	assert(not self._session_breed_map[arg_19_1], "[EnemyPackageLoader] Attempted to load same breed twice")

	self._session_breed_map[arg_19_1] = true

	self._network_handler:set_session_breed_map(table.shallow_copy(self._session_breed_map))
	self:_update_package_diffs()
end

EnemyPackageLoader._unload_package = function (self, arg_20_1)
	-- function 20
	assert(self._is_server, "[EnemyPackageLoader] '_unload_package' is a server only function.")

	local var_20_0 = self._breeds_to_load_at_startup[arg_20_1]

	fassert(not var_20_0, "EnemyPackageLoader:_unload_package: Trying to unload a startup breed!")

	local var_20_1 = self._locked_breeds[arg_20_1]

	fassert(not var_20_1, "EnemyPackageLoader:_unload_package: Trying to unload a locked breed!")

	self._session_breed_map[arg_20_1] = nil

	self._network_handler:set_session_breed_map(table.shallow_copy(self._session_breed_map))
	self:_update_package_diffs()
end

EnemyPackageLoader.update = function (self)
	-- function 21
	self:_update_package_diffs()
end

EnemyPackageLoader._update_package_diffs = function (self)
	-- function 22
	if not (not self._network_handler and self._network_handler:is_fully_synced()) then
		return
	end

	local flag = true
	local flag_2 = true
	local package = Managers.package
	local _loaded_breed_map = self._loaded_breed_map
	local _session_breed_map = self._session_breed_map

	_session_breed_map = _session_breed_map or self._network_handler:get_session_breed_map()

	local get_own_loaded_session_breed_map = self._network_handler:get_own_loaded_session_breed_map()

	for k, v in pairs(_loaded_breed_map) do
		if not _session_breed_map[k] then
			local _breed_package_name = self:_breed_package_name(k)

			package:unload(_breed_package_name, str)

			local _category = self:_category(k)

			_category.current = _category.current - 1
			_category.loaded_breeds[k] = nil
			_loaded_breed_map[k] = nil
		end
	end

	for k_2 in pairs(_session_breed_map) do
		local _breed_package_name_2 = self:_breed_package_name(k_2)
		local has_loaded = package:has_loaded(_breed_package_name_2, str)

		if not (has_loaded or package:is_loading(_breed_package_name_2, str)) then
			package:load(_breed_package_name_2, str, nil, flag, flag_2)
		elseif not (not has_loaded and _loaded_breed_map[k_2]) then
			self:_category(k_2).loaded_breeds[k_2] = true
			_loaded_breed_map[k_2] = true
		end
	end

	if not table.shallow_equal(_loaded_breed_map, get_own_loaded_session_breed_map) then
		self._network_handler:set_own_loaded_session_breeds(table.shallow_copy(_loaded_breed_map))
	end

	if not self._is_server then
		local get_session_breed_map = self._network_handler:get_session_breed_map()

		if not table.shallow_equal(_session_breed_map, get_session_breed_map) then
			self._network_handler:set_session_breed_map(table.shallow_copy(_session_breed_map))
		end
	end
end

EnemyPackageLoader.load_sync_done_for_peer = function (self, arg_23_1)
	-- function 23
	if not (not self._network_handler and self._network_handler:is_fully_synced()) then
		return false
	end

	local get_session_breed_map = self._network_handler:get_session_breed_map()
	local get_loaded_session_breeds = self._network_handler:get_loaded_session_breeds(arg_23_1)

	for k in pairs(get_session_breed_map) do
		if not get_loaded_session_breeds[k] then
			return false
		end
	end

	return true
end

EnemyPackageLoader._breed_package_name = function (self, arg_24_1)
	-- function 24
	local _breed_to_package_name_cache = self._breed_to_package_name_cache
	local var_24_1 = _breed_to_package_name_cache[arg_24_1]

	if not var_24_1 then
		local var_24_2 = breed_path
		local var_24_3

		if not self._use_optimized then
			var_24_3 = opt_lookup_breed_names[arg_24_1]

			if not var_24_3 then
				-- Nothing
			end
		end

		var_24_3 = arg_24_1

		::label_24_0::

		var_24_1 = var_24_2 .. var_24_3
		_breed_to_package_name_cache[arg_24_1] = var_24_1
	end

	return var_24_1
end

EnemyPackageLoader._category = function (self, arg_25_1)
	-- function 25
	local _breed_category_lookup = self._breed_category_lookup
	local var_25_1 = _breed_category_lookup[arg_25_1]

	if not var_25_1 then
		return var_25_1
	end

	local _breed_category_loaded_packages = self._breed_category_loaded_packages
	local categories = EnemyPackageLoaderSettings.categories

	for i = 1, #categories do
		local var_25_4 = categories[i]

		if BUILD == var_25_4.forbidden_in_build or not table.find(var_25_4.breeds, arg_25_1) then
			local id = var_25_4.id
			local var_25_6 = _breed_category_loaded_packages[var_25_4.id]

			var_25_6 = var_25_6 or {
				current = 0,
				name = var_25_4.id,
				dynamic_loading = var_25_4.dynamic_loading,
				limit = var_25_4.limit,
				loaded_breeds = {},
				breeds = {},
				replacement_breed_override_funcs = var_25_4.replacement_breed_override_funcs
			}
			_breed_category_loaded_packages[id] = var_25_6
		end
	end

	local dynamic_breeds = _breed_category_loaded_packages.dynamic_breeds

	dynamic_breeds = dynamic_breeds or {
		name = "dynamic_breeds",
		is_generated_category = true,
		current = 0,
		dynamic_loading = true,
		limit = math.huge,
		loaded_breeds = {},
		breeds = {}
	}
	_breed_category_loaded_packages.dynamic_breeds = dynamic_breeds

	table.insert(_breed_category_loaded_packages.dynamic_breeds.breeds, arg_25_1)

	_breed_category_lookup[arg_25_1] = _breed_category_loaded_packages.dynamic_breeds

	return _breed_category_lookup[arg_25_1]
end

function print_breed_hash(arg_26_0, arg_26_1)
	-- function 26
	local flag = arg_26_1 or ""

	for k, v in pairs(arg_26_0) do
		flag = flag .. k .. " "
	end

	print(flag)
end

EnemyPackageLoader._remove_locked_directors = function (arg_27_0, arg_27_1, arg_27_2)
	-- function 27
	print("checking dlc's against conflict directors")

	for i = #arg_27_1, 1, -1 do
		local var_27_0 = arg_27_1[i]
		local var_27_1 = ConflictDirectors[var_27_0]
		local locked_func_name = var_27_1.locked_func_name

		if not locked_func_name and not table.find(arg_27_2, locked_func_name) then
			table.swap_delete(arg_27_1, i)
			printf("- removing conflict director '%s'", var_27_1.name)
		end
	end
end

EnemyPackageLoader._get_directors_from_breed_budget = function (arg_28_0, arg_28_1, arg_28_2, arg_28_3, arg_28_4, arg_28_5, arg_28_6, arg_28_7)
	-- function 28
	local num = arg_28_4 - table.size(arg_28_1)

	fassert(num >= 0, "Fail, too many breeds! ")

	local tbl = {}
	local var_28_2
	local tbl_2 = {}
	local var_28_4

	printf("--- --- ---")
	printf("Starting... difficulty '%s'", arg_28_5)

	if not table.is_empty(arg_28_6) then
		printf("There are no starting conflict directors!")
	else
		printf("These are the starting conflict directors:")

		for k, v in pairs(arg_28_6) do
			printf("\t %s", k)
		end
	end

	printf("--- --- ---\n")

	for k_2 = 1, arg_28_2 do
		print("")
		print("Looking for a new director:")
		print_breed_hash(arg_28_1, sprintf("(free: %s) master hash is: ", num))

		arg_28_7 = table.shuffle(arg_28_3, arg_28_7)

		while #arg_28_3 > 0 do
			local num_2 = 0

			table.clear(tbl_2)

			local var_28_6 = arg_28_3[1]
			local var_28_7 = ConflictDirectors[var_28_6]
			local var_28_8 = var_28_7.contained_breeds[arg_28_5]

			print("->trying director:", var_28_7.name)

			var_28_4 = true

			for k_3, v_2 in pairs(var_28_8) do
				if not arg_28_1[k_3] then
					num_2 = num_2 + 1
					tbl_2[k_3] = v_2

					if num < num_2 then
						var_28_4 = false

						table.swap_delete(arg_28_3, 1)
						print("\t--> fail!")

						break
					end
				end
			end

			if not var_28_4 then
				print("\t--> success!")

				for k_4, v_3 in pairs(var_28_8) do
					if not arg_28_1[k_4] then
						arg_28_1[k_4] = true
						num = num - 1
					end
				end

				tbl[#tbl + 1] = var_28_7

				if num_2 > 0 then
					print_breed_hash(tbl_2, "\t--> Added these breeds: ")

					break
				end

				print("\t--> re-used the same breeds")

				break
			end
		end

		fassert(var_28_4, "---> failed to find a director with matching breeds")
	end

	print("")
	print("DONE! Found the following directors:")

	for i7 = 1, #tbl do
		local var_28_9 = tbl[i7]

		printf("\t %s", var_28_9.name)
	end

	print_breed_hash(arg_28_1, sprintf("(free: %s), Master hash is: ", num))

	return tbl
end

EnemyPackageLoader._remove_directors_by_breed_budget = function (arg_29_0, arg_29_1, arg_29_2, arg_29_3, arg_29_4)
	-- function 29
	local tbl = {}

	for i = #arg_29_1, 1, -1 do
		local var_29_1 = arg_29_1[i]
		local var_29_2 = ConflictDirectors[var_29_1].contained_breeds[arg_29_3]
		local num = 0

		table.clear(tbl)

		for k, v in pairs(var_29_2) do
			if not arg_29_2[k] then
				num = num + 1
				tbl[k] = v

				if arg_29_4 < num then
					table.swap_delete(arg_29_1, i)

					break
				end
			end
		end
	end
end

EnemyPackageLoader._get_factions_from_directors = function (arg_30_0, arg_30_1)
	-- function 30
	local tbl = {}

	for i = 1, #arg_30_1 do
		local var_30_1 = arg_30_1[i]
		local var_30_2 = ConflictDirectors[var_30_1]
		local flag = not var_30_2 and var_30_2.factions

		if not flag then
			for j = 1, #flag do
				local var_30_4 = flag[j]

				if table.index_of(tbl, var_30_4) == -1 then
					table.insert(tbl, var_30_4)
				end
			end
		end
	end

	return tbl
end

EnemyPackageLoader._make_faction_list = function (arg_31_0, arg_31_1, arg_31_2, arg_31_3, arg_31_4, arg_31_5)
	-- function 31
	local var_31_0

	print("number of factions to include", arg_31_5)

	if arg_31_5 < #arg_31_1 then
		var_31_0 = table.shallow_copy(arg_31_2)

		table.array_remove_if(arg_31_1, function (arg_32_0)
			-- function 32
			return table.index_of(var_31_0, arg_32_0) > 0
		end)

		local count = #var_31_0

		while count < arg_31_5 do
			fn_2(arg_31_1, arg_31_3, DefaultConflictFactionWeight)

			local var_31_2
			local var_31_3

			arg_31_4, var_31_3 = Math.next_random(arg_31_4)

			local var_31_4 = fn(var_31_3, arg_31_1, arg_31_3)
			local var_31_5 = arg_31_1[var_31_4]

			print("Rolled random faction:", var_31_3, var_31_5)
			table.swap_delete(arg_31_1, var_31_4)
			table.insert(var_31_0, var_31_5)

			count = count + 1
		end
	else
		var_31_0 = table.shallow_copy(arg_31_1)
	end

	print("number of factions added", #var_31_0)

	return arg_31_4, var_31_0
end

EnemyPackageLoader._remove_directors_not_in_factions = function (arg_33_0, arg_33_1, arg_33_2)
	-- function 33
	table.array_remove_if(arg_33_1, function (arg_34_0)
		-- function 34
		local var_34_0 = ConflictDirectors[arg_34_0]
		local flag = not var_34_0 and var_34_0.factions

		if not flag then
			for i = 1, #flag do
				local var_34_2 = flag[i]

				if table.index_of(arg_33_2, var_34_2) == -1 then
					return true
				end
			end
		end

		return false
	end)
end

EnemyPackageLoader._get_startup_breeds = function (self, arg_35_1, arg_35_2, arg_35_3, arg_35_4, arg_35_5, arg_35_6, arg_35_7)
	-- function 35
	local var_35_0 = LevelSettings[arg_35_1]
	local level_name = var_35_0.level_name

	if LevelResource.nested_level_count(level_name) > 0 then
		level_name = LevelResource.nested_level_resource_name(level_name, 0)
	end

	local str = level_name .. "_spawn_zones"

	if not Application.can_get("lua", str) then
		ferror("Cant get %s, make sure this is added to the \\resource_packages\\level_scripts.package file. Or have you forgotten to run generate_resource_packages.bat? If it only crashes when running from a bundle, it might be that this level needs to be whitelisted.", str)
	end

	local tbl = {}
	local composition = DifficultyTweak.converters.composition(arg_35_6, arg_35_7)
	local rank = DifficultySettings[composition].rank
	local var_35_6 = TerrorEventBlueprints[arg_35_1]

	if not var_35_6 then
		for k, v in pairs(var_35_6) do
			ConflictUtils.add_breeds_from_event(k, v, composition, rank, tbl, var_35_6)
		end
	end

	local clone = table.clone(MainPathSpawningGenerator.load_spawn_zone_data(str))
	local crossroads = clone.crossroads
	local main_paths = clone.main_paths
	local zones = clone.zones
	local num_main_zones = clone.num_main_zones
	local path_markers = clone.path_markers
	local generate_crossroad_path_choices = MainPathSpawningGenerator.generate_crossroad_path_choices(crossroads, arg_35_2)
	local remove_crossroads_extra_path_branches, var_35_15, var_35_16 = MainPathSpawningGenerator.remove_crossroads_extra_path_branches(crossroads, generate_crossroad_path_choices, main_paths, zones, num_main_zones, path_markers, arg_35_2)

	if not remove_crossroads_extra_path_branches then
		num_main_zones = var_35_15
	end

	local var_35_17
	local var_35_18
	local process_conflict_directors_zones, var_35_20

	process_conflict_directors_zones, var_35_20, arg_35_2 = MainPathSpawningGenerator.process_conflict_directors_zones(arg_35_5, zones, num_main_zones, arg_35_2)

	for k_2, v_2 in pairs(process_conflict_directors_zones) do
		local var_35_21 = ConflictDirectors[k_2].contained_breeds[composition]

		table.merge(tbl, var_35_21)
	end

	if not arg_35_4 then
		local shallow_copy = table.shallow_copy
		local conflict_director_set = var_35_0.conflict_director_set

		conflict_director_set = conflict_director_set or DefaultConflictDirectorSet

		local var_35_24 = shallow_copy(conflict_director_set)
		local shallow_copy_2 = table.shallow_copy
		local conflict_faction_weights = var_35_0.conflict_faction_weights

		conflict_faction_weights = conflict_faction_weights or DefaultConflictFactionSetWeights

		local var_35_27 = shallow_copy_2(conflict_faction_weights)
		local breed_cap_override = var_35_0.breed_cap_override

		breed_cap_override = breed_cap_override or EnemyPackageLoaderSettings.max_loaded_breed_cap

		local var_35_29
		local var_35_30

		arg_35_2, var_35_30 = Math.next_random(arg_35_2)

		local DefaultConflictPreferredFactionCountChances = DefaultConflictPreferredFactionCountChances
		local num = 0

		for i4 = 1, #DefaultConflictPreferredFactionCountChances do
			if var_35_30 <= DefaultConflictPreferredFactionCountChances[i4] then
				num = i4
			end
		end

		if not DEDICATED_SERVER then
			self:_remove_locked_directors(var_35_24, arg_35_3)
		end

		self:_remove_directors_by_breed_budget(var_35_24, tbl, composition, breed_cap_override)

		local keys = table.keys(process_conflict_directors_zones)
		local _get_factions_from_directors = self:_get_factions_from_directors(keys)
		local _get_factions_from_directors_2 = self:_get_factions_from_directors(var_35_24)
		local var_35_36
		local var_35_37

		arg_35_2, var_35_37 = self:_make_faction_list(_get_factions_from_directors_2, _get_factions_from_directors, var_35_27, arg_35_2, num)

		self:_remove_directors_not_in_factions(var_35_24, var_35_37)

		self._random_director_list = self:_get_directors_from_breed_budget(tbl, var_35_20, var_35_24, breed_cap_override, composition, process_conflict_directors_zones, arg_35_2, arg_35_3)
	end

	local flag = true

	while not flag do
		flag = false

		for k_3, v_3 in pairs(tbl) do
			local var_35_39 = Breeds[k_3]

			if not var_35_39.additional_breed_packages_to_load then
				local additional_breed_packages_to_load = var_35_39.additional_breed_packages_to_load(composition)

				if not additional_breed_packages_to_load then
					for i7 = 1, #additional_breed_packages_to_load do
						local var_35_41 = additional_breed_packages_to_load[i7]

						if not (tbl[var_35_41] or not (table.size(tbl) < EnemyPackageLoaderSettings.max_loaded_breed_cap)) then
							tbl[var_35_41] = true
							flag = true
						end
					end
				end
			end
		end
	end

	print("[EnemyPackageLoader] breed_lookup: " .. table.tostring(tbl))

	return tbl
end

EnemyPackageLoader.setup_startup_enemies = function (self, arg_36_1, arg_36_2, arg_36_3, arg_36_4, arg_36_5, arg_36_6, arg_36_7)
	-- function 36
	fassert(self._is_server, "[EnemyPackageLoader] 'setup_startup_enemies' is a server only function")
	fassert(arg_36_2, "Cannot setup_startup_enemies without level_seed!")
	print("[EnemyPackageLoader] setup_startup_enemies - level_key:", arg_36_1, "- level_seed:", arg_36_2, "- use_random_directors:", arg_36_4, "- conflict_director_name:", arg_36_5)

	if not LevelHelper:should_load_enemies(arg_36_1) then
		print("[EnemyPackageLoader] Load no enemies on this level")
	else
		local _breeds_to_load_at_startup = self._breeds_to_load_at_startup
		local tbl = {}

		self._breeds_to_load_at_startup = tbl

		local _get_startup_breeds = self:_get_startup_breeds(arg_36_1, arg_36_2, arg_36_3, arg_36_4, arg_36_5, arg_36_6, arg_36_7)
		local tbl_2 = {}
		local categories = EnemyPackageLoaderSettings.categories
		local count = #categories

		for i = 1, count do
			local var_36_6 = categories[i]

			if BUILD ~= var_36_6.forbidden_in_build then
				local breeds = var_36_6.breeds
				local count_2 = #breeds

				for j = 1, count_2 do
					local var_36_9 = breeds[j]

					tbl_2[var_36_9] = var_36_9

					if not var_36_6.dynamic_loading then
						tbl[var_36_9] = true
					end
				end
			end
		end

		for k, v in pairs(_get_startup_breeds) do
			k = alias_to_breed[k] or k

			if not tbl_2[k] then
				tbl_2[k] = k

				local _category = self:_category(k)
				local dynamic_loading = _category.dynamic_loading
				local is_generated_category = _category.is_generated_category

				if not dynamic_loading and not is_generated_category then
					tbl[k] = true
				end
			end
		end

		self:_load_startup_enemy_packages(_breeds_to_load_at_startup)
	end
end

EnemyPackageLoader._load_startup_enemy_packages = function (self, arg_37_1)
	-- function 37
	assert(self._is_server, "[EnemyPackageLoader] '_load_startup_enemy_packages' is a server only function.")

	local _session_breed_map = self._session_breed_map
	local _breeds_to_load_at_startup = self._breeds_to_load_at_startup

	for k in pairs(_breeds_to_load_at_startup) do
		_session_breed_map[k] = true
	end

	for k_2 in pairs(arg_37_1) do
		if not _breeds_to_load_at_startup[k_2] then
			_session_breed_map[k_2] = nil
		end
	end

	self._network_handler:set_startup_breeds(table.shallow_copy(_breeds_to_load_at_startup))
	self:_update_package_diffs()
end

EnemyPackageLoader.loading_completed = function (self)
	-- function 38
	if not (not self._network_handler and self._network_handler:is_fully_synced()) then
		return false
	end

	local get_session_breed_map = self._network_handler:get_session_breed_map()
	local _loaded_breed_map = self._loaded_breed_map

	for k in pairs(get_session_breed_map) do
		if _loaded_breed_map[k] ~= true then
			return false
		end
	end

	return true
end

EnemyPackageLoader.random_director_list = function (self)
	-- function 39
	return self._random_director_list
end

EnemyPackageLoader.on_application_shutdown = function (self)
	-- function 40
	printf("[EnemyPackageLoader] unload_enemy_packages")

	local _locked_breeds = self._locked_breeds
	local _loaded_breed_map = self._loaded_breed_map
	local _session_breed_map = self._session_breed_map

	for k, v in pairs(_loaded_breed_map) do
		fassert(not _locked_breeds[k], "EnemyPackageLoader:on_application_shutdown: Trying to unload a locked breed, remember to unlock breed on shutdown! If you are locking packages via level flow, use unload_enemy_packages external in event to unload.")

		local _breed_package_name = self:_breed_package_name(k)

		Managers.package:unload(_breed_package_name, str)

		if not self._is_server then
			_session_breed_map[k] = nil
		end

		_loaded_breed_map[k] = nil
	end
end

EnemyPackageLoader.get_startup_breeds = function (self)
	-- function 41
	if not self._is_server then
		return self._breeds_to_load_at_startup
	else
		return self._network_handler:get_startup_breeds()
	end
end

EnemyPackageLoader.client_connected = function (arg_42_0, arg_42_1)
	-- function 42
	return
end

EnemyPackageLoader.client_disconnected = function (arg_43_0, arg_43_1)
	-- function 43
	return
end

EnemyPackageLoader.is_breed_loaded_on_all_peers = function (self, arg_44_1)
	-- function 44
	arg_44_1 = alias_to_breed[arg_44_1] or arg_44_1

	local hot_join_synced_peers = self._network_handler:hot_join_synced_peers()

	for k in pairs(hot_join_synced_peers) do
		if not self._network_handler:get_loaded_session_breeds(k)[arg_44_1] then
			return false
		end
	end

	return true
end

EnemyPackageLoader.debug_loaded_breeds = function (self)
	-- function 45
	if not self._is_server then
		Debug.text("[EnemyPackageLoader] no client debug support. need to fetch peers some other way")

		return
	end

	if not self._network_handler then
		Debug.text("[EnemyPackageLoader] network handler not avaiable")

		return
	end

	local num_spawned_by_breed = Managers.state.conflict.num_spawned_by_breed
	local _breed_category_loaded_packages = self._breed_category_loaded_packages
	local _locked_breeds = self._locked_breeds
	local hot_join_synced_peers

	if not self._network_handler then
		hot_join_synced_peers = self._network_handler:hot_join_synced_peers()

		if not hot_join_synced_peers then
			-- Nothing
		end
	end

	hot_join_synced_peers = {}

	::label_45_0::

	Debug.text("EnemyPackageLoader Policy=%s", EnemyPackageLoaderSettings.policy)

	for k, v in pairs(_breed_category_loaded_packages) do
		Debug.text("Loaded %s:", k)

		for k_2, v_2 in pairs(self._loaded_breed_map) do
			repeat
				if self:_category(k_2).name ~= k then
					break
				end

				local str = ""
				local flag = false

				if not self._is_server then
					flag = self._unit_spawner:breed_in_death_watch(k_2)
					str = num_spawned_by_breed[k_2]

					local var_45_6 = breed_to_aliases[k_2]

					if not var_45_6 then
						local count = #var_45_6

						for i4 = 1, count do
							local var_45_8 = var_45_6[i4]

							str = str + num_spawned_by_breed[var_45_8]
							flag = flag or self._unit_spawner:breed_in_death_watch(var_45_8)
						end
					end
				end

				local flag_2

				flag_2 = not _locked_breeds[k_2] and "[LOCKED]" and ""

				local text = Debug.text
				local str_2 = "   %s=%s %s %s %s"
				local var_45_12 = k_2
				local var_45_13 = v_2
				local flag_3

				flag_3 = not flag and "DL" and ""

				text(str_2, var_45_12, var_45_13, flag_3, tostring(str), flag_2)

				if not (not self._is_server and self:is_breed_loaded_on_all_peers(k_2)) then
					Debug.text("         --Waiting on Peer(s) to Load--")

					for k_3, v_3 in pairs(hot_join_synced_peers) do
						if not self._network_handler:get_loaded_session_breeds(k_3)[k_2] then
							Debug.text("         %s", k_3)
						end
					end
				end
			until true
		end
	end

	if not self._is_server then
		Debug.text("Server=%s", self._peer_id)

		if not self._unique_connections then
			for k_4, v_4 in pairs(self._unique_connections) do
				Debug.text("   Peer=%s | Key=%s", k_4, v_4)
			end
		end
	else
		local text_2 = Debug.text
		local str_3 = "Peer=%s | Server=%s | Key=%s"
		local _peer_id = self._peer_id
		local _server_peer_id = self._server_peer_id

		_server_peer_id = _server_peer_id or "nil"

		local _unique_connection_key = self._unique_connection_key

		_unique_connection_key = _unique_connection_key or "nil"

		text_2(str_3, _peer_id, _server_peer_id, _unique_connection_key)
	end
end
