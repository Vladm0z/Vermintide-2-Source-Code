-- chunkname: @scripts/game_state/components/general_synced_package_loader.lua

GeneralSyncedPackageLoader = class(GeneralSyncedPackageLoader)

local var_0_0 = {}

GeneralSyncedPackageLoader.init = function (arg_1_0)
	arg_1_0._loaded_mutator_map = {}
	arg_1_0._cached_mutator_map = {}
end

GeneralSyncedPackageLoader.network_context_created = function (arg_2_0, arg_2_1, arg_2_2, arg_2_3, arg_2_4)
	printf("[GeneralSyncedPackageLoader] network_context_created (server_peer_id=%s, own_peer_id=%s)", arg_2_2, arg_2_3)

	arg_2_0._lobby = arg_2_1
	arg_2_0._is_server = arg_2_2 == arg_2_3
	arg_2_0._network_handler = arg_2_4
end

GeneralSyncedPackageLoader.matching_session = function (arg_3_0, arg_3_1)
	return arg_3_0._network_handler == arg_3_1
end

GeneralSyncedPackageLoader.network_context_destroyed = function (arg_4_0)
	print("[GeneralSyncedPackageLoader] network_context_destroyed")

	arg_4_0._lobby = nil
	arg_4_0._network_handler = nil

	if arg_4_0._is_server then
		arg_4_0._session_mutator_map = nil
	end

	arg_4_0._is_server = nil
end

GeneralSyncedPackageLoader.update = function (arg_5_0)
	arg_5_0:_update_package_diffs()
end

GeneralSyncedPackageLoader._mutator_package_reference = function (arg_6_0, arg_6_1)
	local var_6_0 = var_0_0[arg_6_1]

	if var_6_0 then
		return var_6_0
	end

	var_0_0[arg_6_1] = "GeneralSyncedPackageLoader_" .. arg_6_1

	return var_0_0[arg_6_1]
end

GeneralSyncedPackageLoader._has_loaded_mutator = function (arg_7_0, arg_7_1)
	local var_7_0 = MutatorTemplates[arg_7_1].packages

	if not var_7_0 then
		return true
	end

	local var_7_1 = arg_7_0:_mutator_package_reference(arg_7_1)
	local var_7_2 = Managers.package

	for iter_7_0 = 1, #var_7_0 do
		local var_7_3 = var_7_0[iter_7_0]

		if not var_7_2:has_loaded(var_7_3, var_7_1) then
			return false
		end
	end

	return true
end

GeneralSyncedPackageLoader._is_loading_mutator = function (arg_8_0, arg_8_1)
	local var_8_0 = MutatorTemplates[arg_8_1].packages

	if not var_8_0 then
		return false
	end

	local var_8_1 = arg_8_0:_mutator_package_reference(arg_8_1)
	local var_8_2 = Managers.package

	for iter_8_0 = 1, #var_8_0 do
		local var_8_3 = var_8_0[iter_8_0]

		if var_8_2:is_loading(var_8_3, var_8_1) then
			return true
		end
	end

	return false
end

GeneralSyncedPackageLoader._load_mutator = function (arg_9_0, arg_9_1, arg_9_2, arg_9_3)
	local var_9_0 = MutatorTemplates[arg_9_1].packages

	if not var_9_0 then
		return
	end

	local var_9_1 = arg_9_0:_mutator_package_reference(arg_9_1)
	local var_9_2 = Managers.package

	for iter_9_0 = 1, #var_9_0 do
		local var_9_3 = var_9_0[iter_9_0]

		var_9_2:load(var_9_3, var_9_1, nil, arg_9_2, arg_9_3)
	end
end

GeneralSyncedPackageLoader._unload_mutator = function (arg_10_0, arg_10_1)
	local var_10_0 = MutatorTemplates[arg_10_1].packages

	if not var_10_0 then
		return
	end

	local var_10_1 = arg_10_0:_mutator_package_reference(arg_10_1)
	local var_10_2 = Managers.package

	for iter_10_0 = 1, #var_10_0 do
		local var_10_3 = var_10_0[iter_10_0]

		var_10_2:unload(var_10_3, var_10_1)
	end
end

GeneralSyncedPackageLoader._update_package_diffs = function (arg_11_0, arg_11_1)
	if not arg_11_0._network_handler or not arg_11_0._network_handler:is_fully_synced() then
		return
	end

	local var_11_0 = true
	local var_11_1 = true
	local var_11_2 = arg_11_0._loaded_mutator_map
	local var_11_3 = arg_11_0:_mutator_map()
	local var_11_4 = arg_11_0._network_handler:get_own_loaded_mutator_map()

	for iter_11_0, iter_11_1 in pairs(var_11_2) do
		if not var_11_3[iter_11_0] then
			arg_11_0:_unload_mutator(iter_11_0)

			var_11_2[iter_11_0] = nil
		end
	end

	for iter_11_2, iter_11_3 in pairs(var_11_3) do
		local var_11_5 = arg_11_0:_has_loaded_mutator(iter_11_2)

		if not var_11_5 and not arg_11_0:_is_loading_mutator(iter_11_2) then
			arg_11_0:_load_mutator(iter_11_2, var_11_0, var_11_1)
		elseif var_11_5 and not var_11_2[iter_11_2] then
			var_11_2[iter_11_2] = true
		elseif iter_11_3 ~= true and arg_11_0:is_mutator_loaded_on_all_peers(iter_11_2) then
			iter_11_3()

			var_11_3[iter_11_2] = true
		end
	end

	if not table.shallow_equal(var_11_2, var_11_4) then
		arg_11_0._network_handler:set_own_loaded_mutator_map(table.shallow_copy(var_11_2))
	end
end

GeneralSyncedPackageLoader.load_sync_done_for_peer = function (arg_12_0, arg_12_1)
	if not arg_12_0._network_handler or not arg_12_0._network_handler:is_fully_synced() then
		return false
	end

	local var_12_0 = arg_12_0:_mutator_map()
	local var_12_1 = arg_12_0._network_handler:get_loaded_mutator_map(arg_12_1)

	for iter_12_0 in pairs(var_12_0) do
		if not var_12_1[iter_12_0] then
			return false
		end
	end

	return true
end

GeneralSyncedPackageLoader.loading_completed = function (arg_13_0)
	if not arg_13_0._network_handler or not arg_13_0._network_handler:is_fully_synced() then
		return false
	end

	local var_13_0 = arg_13_0:_mutator_map()
	local var_13_1 = arg_13_0._loaded_mutator_map

	for iter_13_0 in pairs(var_13_0) do
		if var_13_1[iter_13_0] ~= true then
			return false
		end
	end

	return true
end

GeneralSyncedPackageLoader.on_application_shutdown = function (arg_14_0)
	local var_14_0 = arg_14_0._loaded_mutator_map

	for iter_14_0 in pairs(var_14_0) do
		local var_14_1 = arg_14_0:_mutator_package_reference(iter_14_0)
		local var_14_2 = MutatorTemplates[iter_14_0].packages

		if var_14_2 then
			for iter_14_1 = 1, #var_14_2 do
				local var_14_3 = var_14_2[iter_14_1]

				Managers.package:unload(var_14_3, var_14_1)
			end
		end

		var_14_0[iter_14_0] = nil
	end
end

GeneralSyncedPackageLoader.is_mutator_loaded_on_all_peers = function (arg_15_0, arg_15_1, arg_15_2)
	local var_15_0 = arg_15_0._is_server and arg_15_0._network_handler:hot_join_synced_peers()

	if arg_15_2 then
		var_15_0 = table.shallow_copy(arg_15_0._network_handler:get_peers(), true)
		var_15_0 = table.array_to_map(var_15_0, function (arg_16_0, arg_16_1)
			return arg_16_1, true
		end)
	end

	for iter_15_0 in pairs(var_15_0) do
		if not arg_15_0._network_handler:get_loaded_mutator_map(iter_15_0)[arg_15_1] then
			return false
		end
	end

	return true
end

GeneralSyncedPackageLoader._mutator_map = function (arg_17_0)
	local var_17_0 = arg_17_0._network_handler:state_revision()

	if arg_17_0._cached_mutator_map_version == var_17_0 then
		return arg_17_0._cached_mutator_map
	end

	arg_17_0._cached_mutator_map_version = var_17_0
	arg_17_0._cached_mutator_map = {}

	local var_17_1 = arg_17_0._network_handler:get_game_mode_event_data().mutators

	if var_17_1 then
		for iter_17_0 = 1, #var_17_1 do
			arg_17_0._cached_mutator_map[var_17_1[iter_17_0]] = true
		end
	end

	return arg_17_0._cached_mutator_map
end

GeneralSyncedPackageLoader.debug_loaded_packages = function (arg_18_0)
	if not arg_18_0._network_handler then
		Debug.text("[GeneralSyncedPackageLoader] network handler not avaiable")

		return
	end

	local var_18_0 = arg_18_0._network_handler:_mutator_map()

	if table.is_empty(var_18_0) then
		Debug.text("No mutators initialized. (DynamicPackageLoader)")
	else
		Debug.text("Initialized mutators:")
	end

	local var_18_1 = arg_18_0._is_server and arg_18_0._network_handler:hot_join_synced_peers() or arg_18_0._network_handler:get_peers()

	if not arg_18_0._is_server then
		var_18_1 = table.shallow_copy(arg_18_0._network_handler:get_peers(), true)
		var_18_1 = table.array_to_map(var_18_1, function (arg_19_0, arg_19_1)
			return arg_19_1, true
		end)
	end

	for iter_18_0 in pairs(var_18_0) do
		repeat
			Debug.text("   %s", iter_18_0)

			if not arg_18_0:is_mutator_loaded_on_all_peers(iter_18_0, not arg_18_0._is_server) then
				Debug.text("      --Waiting on Peer(s) to Load--")

				for iter_18_1, iter_18_2 in pairs(var_18_1) do
					if not arg_18_0._network_handler:get_loaded_mutator_map(iter_18_1)[iter_18_0] then
						Debug.text("      %s", iter_18_1)
					end
				end
			end
		until true
	end
end
