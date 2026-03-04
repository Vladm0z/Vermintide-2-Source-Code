-- chunkname: @scripts/game_state/components/enemy_package_loader.lua

require("scripts/settings/enemy_package_loader_settings")
require("scripts/managers/conflict_director/main_path_spawning_generator")
require("scripts/managers/conflict_director/conflict_utils")

EnemyPackageLoader = class(EnemyPackageLoader)

local var_0_0 = "EnemyPackageLoader"
local var_0_1 = EnemyPackageLoaderSettings.breed_path
local var_0_2 = EnemyPackageLoaderSettings.alias_to_breed
local var_0_3 = EnemyPackageLoaderSettings.breed_to_aliases
local var_0_4 = EnemyPackageLoaderSettings.opt_lookup_breed_names

local function var_0_5(arg_1_0, arg_1_1, arg_1_2)
	local var_1_0 = 0
	local var_1_1 = #arg_1_1

	for iter_1_0 = 1, var_1_1 do
		local var_1_2 = var_1_0 + arg_1_2[arg_1_1[iter_1_0]]

		if var_1_0 <= arg_1_0 and arg_1_0 < var_1_2 then
			return iter_1_0
		end

		var_1_0 = var_1_2
	end

	return var_1_1
end

local function var_0_6(arg_2_0, arg_2_1, arg_2_2)
	local var_2_0 = 0

	for iter_2_0 = 1, #arg_2_0 do
		local var_2_1 = arg_2_0[iter_2_0]

		if not arg_2_1[var_2_1] then
			arg_2_1[var_2_1] = arg_2_2
		end

		var_2_0 = var_2_0 + arg_2_1[var_2_1]
	end

	for iter_2_1, iter_2_2 in pairs(arg_2_1) do
		arg_2_1[iter_2_1] = iter_2_2 / var_2_0
	end

	print("Updated list weights for random:")

	local var_2_2 = 0

	for iter_2_3 = 1, #arg_2_0 do
		local var_2_3 = arg_2_0[iter_2_3]
		local var_2_4 = arg_2_1[var_2_3]

		printf("\t %s, %.2f (%.2f-%.2f)", var_2_3, var_2_4, var_2_2, var_2_2 + var_2_4)

		var_2_2 = var_2_2 + var_2_4
	end
end

EnemyPackageLoader.init = function (arg_3_0)
	arg_3_0._use_optimized = script_data.use_optimized_breed_units
	arg_3_0._breed_to_package_name_cache = {}
	arg_3_0._locked_breeds = {}
	arg_3_0._random_director_list = nil
	arg_3_0._breed_category_loaded_packages = {}
	arg_3_0._breed_category_lookup = {}
	arg_3_0._loaded_breed_map = {}
end

local var_0_7 = {}

EnemyPackageLoader.register_rpcs = function (arg_4_0, arg_4_1)
	arg_4_0.network_event_delegate = arg_4_1

	arg_4_1:register(arg_4_0, unpack(var_0_7))
end

EnemyPackageLoader.unregister_rpcs = function (arg_5_0)
	arg_5_0.network_event_delegate:unregister(arg_5_0)

	arg_5_0.network_event_delegate = nil
end

EnemyPackageLoader.set_unit_spawner = function (arg_6_0, arg_6_1)
	arg_6_0._unit_spawner = arg_6_1
end

EnemyPackageLoader.network_context_created = function (arg_7_0, arg_7_1, arg_7_2, arg_7_3, arg_7_4)
	printf("[EnemyPackageLoader] network_context_created (server_peer_id=%s, own_peer_id=%s)", arg_7_2, arg_7_3)

	arg_7_0._lobby = arg_7_1
	arg_7_0._server_peer_id = arg_7_2
	arg_7_0._peer_id = arg_7_3

	local var_7_0 = arg_7_2 == arg_7_3

	arg_7_0._is_server = var_7_0

	if var_7_0 then
		arg_7_0._breeds_to_load_at_startup = {}
		arg_7_0._session_breed_map = {}
	end

	arg_7_0._network_handler = arg_7_4
end

EnemyPackageLoader.matching_session = function (arg_8_0, arg_8_1)
	return arg_8_0._network_handler == arg_8_1
end

EnemyPackageLoader.network_context_destroyed = function (arg_9_0)
	print("[EnemyPackageLoader] network_context_destroyed")

	arg_9_0._lobby = nil
	arg_9_0._server_peer_id = nil
	arg_9_0._peer_id = nil
	arg_9_0._network_handler = nil

	if arg_9_0._is_server then
		arg_9_0._session_breed_map = nil
	end

	arg_9_0._is_server = nil
end

EnemyPackageLoader._find_unused_breed_to_unload = function (arg_10_0, arg_10_1)
	local var_10_0 = Managers.state.conflict
	local var_10_1 = var_10_0.num_spawned_by_breed
	local var_10_2 = var_10_0.num_queued_spawn_by_breed
	local var_10_3 = arg_10_0._unit_spawner
	local var_10_4 = arg_10_0._locked_breeds
	local var_10_5 = Managers.package

	for iter_10_0, iter_10_1 in pairs(arg_10_1) do
		if not var_10_4[iter_10_0] and var_10_2[iter_10_0] <= 0 and var_10_1[iter_10_0] <= 0 and not var_10_3:breed_in_death_watch(iter_10_0) then
			local var_10_6 = var_0_3[iter_10_0]
			local var_10_7 = false

			if var_10_6 then
				local var_10_8 = #var_10_6

				for iter_10_2 = 1, var_10_8 do
					local var_10_9 = var_10_6[iter_10_2]

					if var_10_2[var_10_9] > 0 or var_10_1[var_10_9] > 0 or var_10_3:breed_in_death_watch(var_10_9) then
						var_10_7 = true

						break
					end
				end
			end

			if not var_10_7 and var_10_5:can_unload(arg_10_0:_breed_package_name(iter_10_0)) then
				return iter_10_0
			end
		end
	end
end

EnemyPackageLoader._pick_breed_from_processed_breeds = function (arg_11_0, arg_11_1, arg_11_2)
	local var_11_0 = arg_11_0._network_handler:get_session_breed_map()
	local var_11_1 = math.random(1, arg_11_2)
	local var_11_2 = 0
	local var_11_3 = #arg_11_1

	for iter_11_0 = 1, var_11_3 do
		local var_11_4 = arg_11_1[iter_11_0]

		if var_11_0[var_11_4] then
			var_11_2 = var_11_2 + 1

			if var_11_1 <= var_11_2 then
				return var_11_4
			end
		end
	end

	ferror("[EnemyPackageLoader:_pick_breed_from_processed_breeds] No breed found, this should not happen!")
end

EnemyPackageLoader.request_breed = function (arg_12_0, arg_12_1, arg_12_2, arg_12_3)
	assert(arg_12_0._is_server, "[EnemyPackageLoader] 'request_breed' is a server only function")

	arg_12_1 = var_0_2[arg_12_1] or arg_12_1

	local var_12_0 = arg_12_0:_category(arg_12_1)
	local var_12_1 = var_12_0.current
	local var_12_2 = var_12_0.limit

	if not arg_12_2 and var_12_2 <= var_12_1 then
		local var_12_3 = var_12_0.loaded_breeds
		local var_12_4 = arg_12_0:_find_unused_breed_to_unload(var_12_3)

		if var_12_4 then
			arg_12_0:_unload_package(var_12_4)
		else
			local var_12_5 = var_12_0.replacement_breed_override_funcs and var_12_0.replacement_breed_override_funcs[arg_12_3]

			if var_12_5 then
				local var_12_6 = arg_12_0[var_12_5](arg_12_0)

				return false, var_12_6
			else
				local var_12_7 = var_12_0.breeds
				local var_12_8 = arg_12_0:_pick_breed_from_processed_breeds(var_12_7, var_12_2)

				return false, var_12_8
			end
		end
	end

	arg_12_0:_load_package(arg_12_1, var_12_0)

	return true
end

local var_0_8 = {}
local var_0_9 = {}

EnemyPackageLoader.find_patrol_replacement = function (arg_13_0)
	table.clear(var_0_8)
	table.clear(var_0_9)

	local var_13_0 = arg_13_0._breeds_to_load_at_startup

	for iter_13_0, iter_13_1 in ipairs(var_13_0) do
		local var_13_1 = Breeds[iter_13_1]

		if var_13_1.patrol_passive_perception and var_13_1.patrol_passive_target_selection then
			if var_13_1.elite then
				var_0_8[#var_0_8 + 1] = iter_13_1
			elseif not var_13_1.boss and not var_13_1.special then
				var_0_9[#var_0_9 + 1] = iter_13_1
			end
		end
	end

	print("### REPLACING BREED IN PATROL")

	local var_13_2

	if table.size(var_0_8) > 0 then
		local var_13_3 = Math.random(#var_0_8)

		var_13_2 = var_0_8[var_13_3]
	else
		local var_13_4 = Math.random(#var_0_9)

		var_13_2 = var_0_9[var_13_4]
	end

	print(string.format(" - Replacement breed name %q", var_13_2))

	return var_13_2
end

EnemyPackageLoader.is_breed_processed = function (arg_14_0, arg_14_1)
	arg_14_1 = var_0_2[arg_14_1] or arg_14_1

	return arg_14_0._network_handler:get_session_breed_map()[arg_14_1]
end

EnemyPackageLoader.processed_breeds = function (arg_15_0)
	return arg_15_0._network_handler:get_session_breed_map()
end

EnemyPackageLoader._set_breed_package_lock = function (arg_16_0, arg_16_1, arg_16_2)
	local var_16_0 = arg_16_2 and 1 or -1
	local var_16_1 = arg_16_0._locked_breeds
	local var_16_2 = var_0_3[arg_16_1]

	if var_16_2 then
		local var_16_3 = #var_16_2

		for iter_16_0 = 1, var_16_3 do
			local var_16_4 = var_16_2[iter_16_0]

			var_16_1[var_16_4] = (var_16_1[var_16_4] or 0) + var_16_0

			if var_16_1[var_16_4] == 0 then
				var_16_1[var_16_4] = nil
			end
		end
	end

	var_16_1[arg_16_1] = (var_16_1[arg_16_1] or 0) + var_16_0

	if var_16_1[arg_16_1] == 0 then
		var_16_1[arg_16_1] = nil
	end

	fassert(not var_16_1[arg_16_1] or var_16_1[arg_16_1] > 0, "EnemyPackageLoader: Called unlock breed package more times than lock!")
end

EnemyPackageLoader.lock_breed_package = function (arg_17_0, arg_17_1)
	arg_17_0:_set_breed_package_lock(arg_17_1, true)
end

EnemyPackageLoader.unlock_breed_package = function (arg_18_0, arg_18_1)
	arg_18_0:_set_breed_package_lock(arg_18_1, false)
end

EnemyPackageLoader._load_package = function (arg_19_0, arg_19_1, arg_19_2)
	assert(arg_19_0._is_server, "[EnemyPackageLoader] '_load_package' is a server only function.")

	arg_19_2.current = arg_19_2.current + 1

	assert(not arg_19_0._session_breed_map[arg_19_1], "[EnemyPackageLoader] Attempted to load same breed twice")

	arg_19_0._session_breed_map[arg_19_1] = true

	arg_19_0._network_handler:set_session_breed_map(table.shallow_copy(arg_19_0._session_breed_map))
	arg_19_0:_update_package_diffs()
end

EnemyPackageLoader._unload_package = function (arg_20_0, arg_20_1)
	assert(arg_20_0._is_server, "[EnemyPackageLoader] '_unload_package' is a server only function.")

	local var_20_0 = arg_20_0._breeds_to_load_at_startup[arg_20_1]

	fassert(not var_20_0, "EnemyPackageLoader:_unload_package: Trying to unload a startup breed!")

	local var_20_1 = arg_20_0._locked_breeds[arg_20_1]

	fassert(not var_20_1, "EnemyPackageLoader:_unload_package: Trying to unload a locked breed!")

	arg_20_0._session_breed_map[arg_20_1] = nil

	arg_20_0._network_handler:set_session_breed_map(table.shallow_copy(arg_20_0._session_breed_map))
	arg_20_0:_update_package_diffs()
end

EnemyPackageLoader.update = function (arg_21_0)
	arg_21_0:_update_package_diffs()
end

EnemyPackageLoader._update_package_diffs = function (arg_22_0)
	if not arg_22_0._network_handler or not arg_22_0._network_handler:is_fully_synced() then
		return
	end

	local var_22_0 = true
	local var_22_1 = true
	local var_22_2 = Managers.package
	local var_22_3 = arg_22_0._loaded_breed_map
	local var_22_4 = arg_22_0._session_breed_map or arg_22_0._network_handler:get_session_breed_map()
	local var_22_5 = arg_22_0._network_handler:get_own_loaded_session_breed_map()

	for iter_22_0, iter_22_1 in pairs(var_22_3) do
		if not var_22_4[iter_22_0] then
			local var_22_6 = arg_22_0:_breed_package_name(iter_22_0)

			var_22_2:unload(var_22_6, var_0_0)

			local var_22_7 = arg_22_0:_category(iter_22_0)

			var_22_7.current = var_22_7.current - 1
			var_22_7.loaded_breeds[iter_22_0] = nil
			var_22_3[iter_22_0] = nil
		end
	end

	for iter_22_2 in pairs(var_22_4) do
		local var_22_8 = arg_22_0:_breed_package_name(iter_22_2)
		local var_22_9 = var_22_2:has_loaded(var_22_8, var_0_0)

		if not var_22_9 and not var_22_2:is_loading(var_22_8, var_0_0) then
			var_22_2:load(var_22_8, var_0_0, nil, var_22_0, var_22_1)
		elseif var_22_9 and not var_22_3[iter_22_2] then
			arg_22_0:_category(iter_22_2).loaded_breeds[iter_22_2] = true
			var_22_3[iter_22_2] = true
		end
	end

	if not table.shallow_equal(var_22_3, var_22_5) then
		arg_22_0._network_handler:set_own_loaded_session_breeds(table.shallow_copy(var_22_3))
	end

	if arg_22_0._is_server then
		local var_22_10 = arg_22_0._network_handler:get_session_breed_map()

		if not table.shallow_equal(var_22_4, var_22_10) then
			arg_22_0._network_handler:set_session_breed_map(table.shallow_copy(var_22_4))
		end
	end
end

EnemyPackageLoader.load_sync_done_for_peer = function (arg_23_0, arg_23_1)
	if not arg_23_0._network_handler or not arg_23_0._network_handler:is_fully_synced() then
		return false
	end

	local var_23_0 = arg_23_0._network_handler:get_session_breed_map()
	local var_23_1 = arg_23_0._network_handler:get_loaded_session_breeds(arg_23_1)

	for iter_23_0 in pairs(var_23_0) do
		if not var_23_1[iter_23_0] then
			return false
		end
	end

	return true
end

EnemyPackageLoader._breed_package_name = function (arg_24_0, arg_24_1)
	local var_24_0 = arg_24_0._breed_to_package_name_cache
	local var_24_1 = var_24_0[arg_24_1]

	if not var_24_1 then
		var_24_1 = var_0_1 .. (arg_24_0._use_optimized and var_0_4[arg_24_1] or arg_24_1)
		var_24_0[arg_24_1] = var_24_1
	end

	return var_24_1
end

EnemyPackageLoader._category = function (arg_25_0, arg_25_1)
	local var_25_0 = arg_25_0._breed_category_lookup
	local var_25_1 = var_25_0[arg_25_1]

	if var_25_1 then
		return var_25_1
	end

	local var_25_2 = arg_25_0._breed_category_loaded_packages
	local var_25_3 = EnemyPackageLoaderSettings.categories

	for iter_25_0 = 1, #var_25_3 do
		local var_25_4 = var_25_3[iter_25_0]

		if BUILD ~= var_25_4.forbidden_in_build and table.find(var_25_4.breeds, arg_25_1) then
			var_25_2[var_25_4.id] = var_25_2[var_25_4.id] or {
				current = 0,
				name = var_25_4.id,
				dynamic_loading = var_25_4.dynamic_loading,
				limit = var_25_4.limit,
				loaded_breeds = {},
				breeds = {},
				replacement_breed_override_funcs = var_25_4.replacement_breed_override_funcs
			}
		end
	end

	var_25_2.dynamic_breeds = var_25_2.dynamic_breeds or {
		name = "dynamic_breeds",
		is_generated_category = true,
		current = 0,
		dynamic_loading = true,
		limit = math.huge,
		loaded_breeds = {},
		breeds = {}
	}

	table.insert(var_25_2.dynamic_breeds.breeds, arg_25_1)

	var_25_0[arg_25_1] = var_25_2.dynamic_breeds

	return var_25_0[arg_25_1]
end

function print_breed_hash(arg_26_0, arg_26_1)
	local var_26_0 = arg_26_1 or ""

	for iter_26_0, iter_26_1 in pairs(arg_26_0) do
		var_26_0 = var_26_0 .. iter_26_0 .. " "
	end

	print(var_26_0)
end

EnemyPackageLoader._remove_locked_directors = function (arg_27_0, arg_27_1, arg_27_2)
	print("checking dlc's against conflict directors")

	for iter_27_0 = #arg_27_1, 1, -1 do
		local var_27_0 = arg_27_1[iter_27_0]
		local var_27_1 = ConflictDirectors[var_27_0]
		local var_27_2 = var_27_1.locked_func_name

		if var_27_2 and table.find(arg_27_2, var_27_2) then
			table.swap_delete(arg_27_1, iter_27_0)
			printf("- removing conflict director '%s'", var_27_1.name)
		end
	end
end

EnemyPackageLoader._get_directors_from_breed_budget = function (arg_28_0, arg_28_1, arg_28_2, arg_28_3, arg_28_4, arg_28_5, arg_28_6, arg_28_7)
	local var_28_0 = arg_28_4 - table.size(arg_28_1)

	fassert(var_28_0 >= 0, "Fail, too many breeds! ")

	local var_28_1 = {}
	local var_28_2
	local var_28_3 = {}
	local var_28_4

	printf("--- --- ---")
	printf("Starting... difficulty '%s'", arg_28_5)

	if table.is_empty(arg_28_6) then
		printf("There are no starting conflict directors!")
	else
		printf("These are the starting conflict directors:")

		for iter_28_0, iter_28_1 in pairs(arg_28_6) do
			printf("\t %s", iter_28_0)
		end
	end

	printf("--- --- ---\n")

	for iter_28_2 = 1, arg_28_2 do
		print("")
		print("Looking for a new director:")
		print_breed_hash(arg_28_1, sprintf("(free: %s) master hash is: ", var_28_0))

		arg_28_7 = table.shuffle(arg_28_3, arg_28_7)

		while #arg_28_3 > 0 do
			local var_28_5 = 0

			table.clear(var_28_3)

			local var_28_6 = arg_28_3[1]
			local var_28_7 = ConflictDirectors[var_28_6]
			local var_28_8 = var_28_7.contained_breeds[arg_28_5]

			print("->trying director:", var_28_7.name)

			var_28_4 = true

			for iter_28_3, iter_28_4 in pairs(var_28_8) do
				if not arg_28_1[iter_28_3] then
					var_28_5 = var_28_5 + 1
					var_28_3[iter_28_3] = iter_28_4

					if var_28_0 < var_28_5 then
						var_28_4 = false

						table.swap_delete(arg_28_3, 1)
						print("\t--> fail!")

						break
					end
				end
			end

			if var_28_4 then
				print("\t--> success!")

				for iter_28_5, iter_28_6 in pairs(var_28_8) do
					if not arg_28_1[iter_28_5] then
						arg_28_1[iter_28_5] = true
						var_28_0 = var_28_0 - 1
					end
				end

				var_28_1[#var_28_1 + 1] = var_28_7

				if var_28_5 > 0 then
					print_breed_hash(var_28_3, "\t--> Added these breeds: ")

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

	for iter_28_7 = 1, #var_28_1 do
		local var_28_9 = var_28_1[iter_28_7]

		printf("\t %s", var_28_9.name)
	end

	print_breed_hash(arg_28_1, sprintf("(free: %s), Master hash is: ", var_28_0))

	return var_28_1
end

EnemyPackageLoader._remove_directors_by_breed_budget = function (arg_29_0, arg_29_1, arg_29_2, arg_29_3, arg_29_4)
	local var_29_0 = {}

	for iter_29_0 = #arg_29_1, 1, -1 do
		local var_29_1 = arg_29_1[iter_29_0]
		local var_29_2 = ConflictDirectors[var_29_1].contained_breeds[arg_29_3]
		local var_29_3 = 0

		table.clear(var_29_0)

		for iter_29_1, iter_29_2 in pairs(var_29_2) do
			if not arg_29_2[iter_29_1] then
				var_29_3 = var_29_3 + 1
				var_29_0[iter_29_1] = iter_29_2

				if arg_29_4 < var_29_3 then
					table.swap_delete(arg_29_1, iter_29_0)

					break
				end
			end
		end
	end
end

EnemyPackageLoader._get_factions_from_directors = function (arg_30_0, arg_30_1)
	local var_30_0 = {}

	for iter_30_0 = 1, #arg_30_1 do
		local var_30_1 = arg_30_1[iter_30_0]
		local var_30_2 = ConflictDirectors[var_30_1]
		local var_30_3 = var_30_2 and var_30_2.factions

		if var_30_3 then
			for iter_30_1 = 1, #var_30_3 do
				local var_30_4 = var_30_3[iter_30_1]

				if table.index_of(var_30_0, var_30_4) == -1 then
					table.insert(var_30_0, var_30_4)
				end
			end
		end
	end

	return var_30_0
end

EnemyPackageLoader._make_faction_list = function (arg_31_0, arg_31_1, arg_31_2, arg_31_3, arg_31_4, arg_31_5)
	local var_31_0

	print("number of factions to include", arg_31_5)

	if arg_31_5 < #arg_31_1 then
		var_31_0 = table.shallow_copy(arg_31_2)

		table.array_remove_if(arg_31_1, function (arg_32_0)
			return table.index_of(var_31_0, arg_32_0) > 0
		end)

		local var_31_1 = #var_31_0

		while var_31_1 < arg_31_5 do
			var_0_6(arg_31_1, arg_31_3, DefaultConflictFactionWeight)

			local var_31_2
			local var_31_3

			arg_31_4, var_31_3 = Math.next_random(arg_31_4)

			local var_31_4 = var_0_5(var_31_3, arg_31_1, arg_31_3)
			local var_31_5 = arg_31_1[var_31_4]

			print("Rolled random faction:", var_31_3, var_31_5)
			table.swap_delete(arg_31_1, var_31_4)
			table.insert(var_31_0, var_31_5)

			var_31_1 = var_31_1 + 1
		end
	else
		var_31_0 = table.shallow_copy(arg_31_1)
	end

	print("number of factions added", #var_31_0)

	return arg_31_4, var_31_0
end

EnemyPackageLoader._remove_directors_not_in_factions = function (arg_33_0, arg_33_1, arg_33_2)
	table.array_remove_if(arg_33_1, function (arg_34_0)
		local var_34_0 = ConflictDirectors[arg_34_0]
		local var_34_1 = var_34_0 and var_34_0.factions

		if var_34_1 then
			for iter_34_0 = 1, #var_34_1 do
				local var_34_2 = var_34_1[iter_34_0]

				if table.index_of(arg_33_2, var_34_2) == -1 then
					return true
				end
			end
		end

		return false
	end)
end

EnemyPackageLoader._get_startup_breeds = function (arg_35_0, arg_35_1, arg_35_2, arg_35_3, arg_35_4, arg_35_5, arg_35_6, arg_35_7)
	local var_35_0 = LevelSettings[arg_35_1]
	local var_35_1 = var_35_0.level_name

	if LevelResource.nested_level_count(var_35_1) > 0 then
		var_35_1 = LevelResource.nested_level_resource_name(var_35_1, 0)
	end

	local var_35_2 = var_35_1 .. "_spawn_zones"

	if not Application.can_get("lua", var_35_2) then
		ferror("Cant get %s, make sure this is added to the \\resource_packages\\level_scripts.package file. Or have you forgotten to run generate_resource_packages.bat? If it only crashes when running from a bundle, it might be that this level needs to be whitelisted.", var_35_2)
	end

	local var_35_3 = {}
	local var_35_4 = DifficultyTweak.converters.composition(arg_35_6, arg_35_7)
	local var_35_5 = DifficultySettings[var_35_4].rank
	local var_35_6 = TerrorEventBlueprints[arg_35_1]

	if var_35_6 then
		for iter_35_0, iter_35_1 in pairs(var_35_6) do
			ConflictUtils.add_breeds_from_event(iter_35_0, iter_35_1, var_35_4, var_35_5, var_35_3, var_35_6)
		end
	end

	local var_35_7 = table.clone(MainPathSpawningGenerator.load_spawn_zone_data(var_35_2))
	local var_35_8 = var_35_7.crossroads
	local var_35_9 = var_35_7.main_paths
	local var_35_10 = var_35_7.zones
	local var_35_11 = var_35_7.num_main_zones
	local var_35_12 = var_35_7.path_markers
	local var_35_13 = MainPathSpawningGenerator.generate_crossroad_path_choices(var_35_8, arg_35_2)
	local var_35_14, var_35_15, var_35_16 = MainPathSpawningGenerator.remove_crossroads_extra_path_branches(var_35_8, var_35_13, var_35_9, var_35_10, var_35_11, var_35_12, arg_35_2)

	if var_35_14 then
		var_35_11 = var_35_15
	end

	local var_35_17
	local var_35_18
	local var_35_19, var_35_20

	var_35_19, var_35_20, arg_35_2 = MainPathSpawningGenerator.process_conflict_directors_zones(arg_35_5, var_35_10, var_35_11, arg_35_2)

	for iter_35_2, iter_35_3 in pairs(var_35_19) do
		local var_35_21 = ConflictDirectors[iter_35_2].contained_breeds[var_35_4]

		table.merge(var_35_3, var_35_21)
	end

	if arg_35_4 then
		local var_35_22 = table.shallow_copy(var_35_0.conflict_director_set or DefaultConflictDirectorSet)
		local var_35_23 = table.shallow_copy(var_35_0.conflict_faction_weights or DefaultConflictFactionSetWeights)
		local var_35_24 = var_35_0.breed_cap_override or EnemyPackageLoaderSettings.max_loaded_breed_cap
		local var_35_25
		local var_35_26

		arg_35_2, var_35_26 = Math.next_random(arg_35_2)

		local var_35_27 = DefaultConflictPreferredFactionCountChances
		local var_35_28 = 0

		for iter_35_4 = 1, #var_35_27 do
			if var_35_26 <= var_35_27[iter_35_4] then
				var_35_28 = iter_35_4
			end
		end

		if not DEDICATED_SERVER then
			arg_35_0:_remove_locked_directors(var_35_22, arg_35_3)
		end

		arg_35_0:_remove_directors_by_breed_budget(var_35_22, var_35_3, var_35_4, var_35_24)

		local var_35_29 = table.keys(var_35_19)
		local var_35_30 = arg_35_0:_get_factions_from_directors(var_35_29)
		local var_35_31 = arg_35_0:_get_factions_from_directors(var_35_22)
		local var_35_32
		local var_35_33

		arg_35_2, var_35_33 = arg_35_0:_make_faction_list(var_35_31, var_35_30, var_35_23, arg_35_2, var_35_28)

		arg_35_0:_remove_directors_not_in_factions(var_35_22, var_35_33)

		arg_35_0._random_director_list = arg_35_0:_get_directors_from_breed_budget(var_35_3, var_35_20, var_35_22, var_35_24, var_35_4, var_35_19, arg_35_2, arg_35_3)
	end

	local var_35_34 = true

	while var_35_34 do
		var_35_34 = false

		for iter_35_5, iter_35_6 in pairs(var_35_3) do
			local var_35_35 = Breeds[iter_35_5]

			if var_35_35.additional_breed_packages_to_load then
				local var_35_36 = var_35_35.additional_breed_packages_to_load(var_35_4)

				if var_35_36 then
					for iter_35_7 = 1, #var_35_36 do
						local var_35_37 = var_35_36[iter_35_7]

						if not var_35_3[var_35_37] and table.size(var_35_3) < EnemyPackageLoaderSettings.max_loaded_breed_cap then
							var_35_3[var_35_37] = true
							var_35_34 = true
						end
					end
				end
			end
		end
	end

	print("[EnemyPackageLoader] breed_lookup: " .. table.tostring(var_35_3))

	return var_35_3
end

EnemyPackageLoader.setup_startup_enemies = function (arg_36_0, arg_36_1, arg_36_2, arg_36_3, arg_36_4, arg_36_5, arg_36_6, arg_36_7)
	fassert(arg_36_0._is_server, "[EnemyPackageLoader] 'setup_startup_enemies' is a server only function")
	fassert(arg_36_2, "Cannot setup_startup_enemies without level_seed!")
	print("[EnemyPackageLoader] setup_startup_enemies - level_key:", arg_36_1, "- level_seed:", arg_36_2, "- use_random_directors:", arg_36_4, "- conflict_director_name:", arg_36_5)

	if not LevelHelper:should_load_enemies(arg_36_1) then
		print("[EnemyPackageLoader] Load no enemies on this level")
	else
		local var_36_0 = arg_36_0._breeds_to_load_at_startup
		local var_36_1 = {}

		arg_36_0._breeds_to_load_at_startup = var_36_1

		local var_36_2 = arg_36_0:_get_startup_breeds(arg_36_1, arg_36_2, arg_36_3, arg_36_4, arg_36_5, arg_36_6, arg_36_7)
		local var_36_3 = {}
		local var_36_4 = EnemyPackageLoaderSettings.categories
		local var_36_5 = #var_36_4

		for iter_36_0 = 1, var_36_5 do
			local var_36_6 = var_36_4[iter_36_0]

			if BUILD ~= var_36_6.forbidden_in_build then
				local var_36_7 = var_36_6.breeds
				local var_36_8 = #var_36_7

				for iter_36_1 = 1, var_36_8 do
					local var_36_9 = var_36_7[iter_36_1]

					var_36_3[var_36_9] = var_36_9

					if not var_36_6.dynamic_loading then
						var_36_1[var_36_9] = true
					end
				end
			end
		end

		for iter_36_2, iter_36_3 in pairs(var_36_2) do
			iter_36_2 = var_0_2[iter_36_2] or iter_36_2

			if not var_36_3[iter_36_2] then
				var_36_3[iter_36_2] = iter_36_2

				local var_36_10 = arg_36_0:_category(iter_36_2)
				local var_36_11 = var_36_10.dynamic_loading
				local var_36_12 = var_36_10.is_generated_category

				if not var_36_11 or var_36_12 then
					var_36_1[iter_36_2] = true
				end
			end
		end

		arg_36_0:_load_startup_enemy_packages(var_36_0)
	end
end

EnemyPackageLoader._load_startup_enemy_packages = function (arg_37_0, arg_37_1)
	assert(arg_37_0._is_server, "[EnemyPackageLoader] '_load_startup_enemy_packages' is a server only function.")

	local var_37_0 = arg_37_0._session_breed_map
	local var_37_1 = arg_37_0._breeds_to_load_at_startup

	for iter_37_0 in pairs(var_37_1) do
		var_37_0[iter_37_0] = true
	end

	for iter_37_1 in pairs(arg_37_1) do
		if not var_37_1[iter_37_1] then
			var_37_0[iter_37_1] = nil
		end
	end

	arg_37_0._network_handler:set_startup_breeds(table.shallow_copy(var_37_1))
	arg_37_0:_update_package_diffs()
end

EnemyPackageLoader.loading_completed = function (arg_38_0)
	if not arg_38_0._network_handler or not arg_38_0._network_handler:is_fully_synced() then
		return false
	end

	local var_38_0 = arg_38_0._network_handler:get_session_breed_map()
	local var_38_1 = arg_38_0._loaded_breed_map

	for iter_38_0 in pairs(var_38_0) do
		if var_38_1[iter_38_0] ~= true then
			return false
		end
	end

	return true
end

EnemyPackageLoader.random_director_list = function (arg_39_0)
	return arg_39_0._random_director_list
end

EnemyPackageLoader.on_application_shutdown = function (arg_40_0)
	printf("[EnemyPackageLoader] unload_enemy_packages")

	local var_40_0 = arg_40_0._locked_breeds
	local var_40_1 = arg_40_0._loaded_breed_map
	local var_40_2 = arg_40_0._session_breed_map

	for iter_40_0, iter_40_1 in pairs(var_40_1) do
		fassert(not var_40_0[iter_40_0], "EnemyPackageLoader:on_application_shutdown: Trying to unload a locked breed, remember to unlock breed on shutdown! If you are locking packages via level flow, use unload_enemy_packages external in event to unload.")

		local var_40_3 = arg_40_0:_breed_package_name(iter_40_0)

		Managers.package:unload(var_40_3, var_0_0)

		if arg_40_0._is_server then
			var_40_2[iter_40_0] = nil
		end

		var_40_1[iter_40_0] = nil
	end
end

EnemyPackageLoader.get_startup_breeds = function (arg_41_0)
	if arg_41_0._is_server then
		return arg_41_0._breeds_to_load_at_startup
	else
		return arg_41_0._network_handler:get_startup_breeds()
	end
end

EnemyPackageLoader.client_connected = function (arg_42_0, arg_42_1)
	return
end

EnemyPackageLoader.client_disconnected = function (arg_43_0, arg_43_1)
	return
end

EnemyPackageLoader.is_breed_loaded_on_all_peers = function (arg_44_0, arg_44_1)
	arg_44_1 = var_0_2[arg_44_1] or arg_44_1

	local var_44_0 = arg_44_0._network_handler:hot_join_synced_peers()

	for iter_44_0 in pairs(var_44_0) do
		if not arg_44_0._network_handler:get_loaded_session_breeds(iter_44_0)[arg_44_1] then
			return false
		end
	end

	return true
end

EnemyPackageLoader.debug_loaded_breeds = function (arg_45_0)
	if not arg_45_0._is_server then
		Debug.text("[EnemyPackageLoader] no client debug support. need to fetch peers some other way")

		return
	end

	if not arg_45_0._network_handler then
		Debug.text("[EnemyPackageLoader] network handler not avaiable")

		return
	end

	local var_45_0 = Managers.state.conflict.num_spawned_by_breed
	local var_45_1 = arg_45_0._breed_category_loaded_packages
	local var_45_2 = arg_45_0._locked_breeds
	local var_45_3 = arg_45_0._network_handler and arg_45_0._network_handler:hot_join_synced_peers() or {}

	Debug.text("EnemyPackageLoader Policy=%s", EnemyPackageLoaderSettings.policy)

	for iter_45_0, iter_45_1 in pairs(var_45_1) do
		Debug.text("Loaded %s:", iter_45_0)

		for iter_45_2, iter_45_3 in pairs(arg_45_0._loaded_breed_map) do
			repeat
				if arg_45_0:_category(iter_45_2).name ~= iter_45_0 then
					break
				end

				local var_45_4 = ""
				local var_45_5 = false

				if arg_45_0._is_server then
					var_45_5 = arg_45_0._unit_spawner:breed_in_death_watch(iter_45_2)
					var_45_4 = var_45_0[iter_45_2]

					local var_45_6 = var_0_3[iter_45_2]

					if var_45_6 then
						local var_45_7 = #var_45_6

						for iter_45_4 = 1, var_45_7 do
							local var_45_8 = var_45_6[iter_45_4]

							var_45_4 = var_45_4 + var_45_0[var_45_8]
							var_45_5 = var_45_5 or arg_45_0._unit_spawner:breed_in_death_watch(var_45_8)
						end
					end
				end

				local var_45_9 = var_45_2[iter_45_2] and "[LOCKED]" or ""

				Debug.text("   %s=%s %s %s %s", iter_45_2, iter_45_3, var_45_5 and "DL" or "", tostring(var_45_4), var_45_9)

				if arg_45_0._is_server and not arg_45_0:is_breed_loaded_on_all_peers(iter_45_2) then
					Debug.text("         --Waiting on Peer(s) to Load--")

					for iter_45_5, iter_45_6 in pairs(var_45_3) do
						if not arg_45_0._network_handler:get_loaded_session_breeds(iter_45_5)[iter_45_2] then
							Debug.text("         %s", iter_45_5)
						end
					end
				end
			until true
		end
	end

	if arg_45_0._is_server then
		Debug.text("Server=%s", arg_45_0._peer_id)

		if arg_45_0._unique_connections then
			for iter_45_7, iter_45_8 in pairs(arg_45_0._unique_connections) do
				Debug.text("   Peer=%s | Key=%s", iter_45_7, iter_45_8)
			end
		end
	else
		Debug.text("Peer=%s | Server=%s | Key=%s", arg_45_0._peer_id, arg_45_0._server_peer_id or "nil", arg_45_0._unique_connection_key or "nil")
	end
end
