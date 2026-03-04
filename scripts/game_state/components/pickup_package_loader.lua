-- chunkname: @scripts/game_state/components/pickup_package_loader.lua

PickupPackageLoader = class(PickupPackageLoader)

local var_0_0 = {}
local var_0_1 = {}

function PickupPackageLoader.init(arg_1_0)
	arg_1_0._loaded_pickup_map = {}
end

function PickupPackageLoader.network_context_created(arg_2_0, arg_2_1, arg_2_2, arg_2_3, arg_2_4)
	printf("[PickupPackageLoader] network_context_created (server_peer_id=%s, own_peer_id=%s)", arg_2_2, arg_2_3)

	arg_2_0._lobby = arg_2_1

	local var_2_0 = arg_2_2 == arg_2_3

	arg_2_0._is_server = var_2_0

	if var_2_0 then
		arg_2_0._session_pickup_map = {}
	end

	arg_2_0._network_handler = arg_2_4
end

function PickupPackageLoader.matching_session(arg_3_0, arg_3_1)
	return arg_3_0._network_handler == arg_3_1
end

function PickupPackageLoader.network_context_destroyed(arg_4_0)
	print("[PickupPackageLoader] network_context_destroyed")

	arg_4_0._lobby = nil
	arg_4_0._network_handler = nil

	if arg_4_0._is_server then
		arg_4_0._session_pickup_map = nil
	end

	arg_4_0._is_server = nil
end

function PickupPackageLoader.request_pickup(arg_5_0, arg_5_1, arg_5_2)
	assert(arg_5_0._is_server, "[PickupPackageLoader] 'request_pickup' is a server only function")

	local var_5_0 = arg_5_0._session_pickup_map[arg_5_1]

	if var_5_0 then
		if arg_5_2 then
			arg_5_0._session_pickup_map[arg_5_1] = function()
				if var_5_0 ~= true then
					var_5_0()
				end

				arg_5_2()
			end
		end

		return
	end

	arg_5_0._session_pickup_map[arg_5_1] = arg_5_2 or true

	arg_5_0._network_handler:set_session_pickup_map(table.shallow_copy(arg_5_0._session_pickup_map))
	arg_5_0:_update_package_diffs()
end

function PickupPackageLoader.is_pickup_processed(arg_7_0, arg_7_1)
	return arg_7_0._network_handler:get_session_pickup_map()[arg_7_1]
end

function PickupPackageLoader.processed_pickups(arg_8_0)
	return arg_8_0._network_handler:get_session_pickup_map()
end

function PickupPackageLoader._unload_package(arg_9_0, arg_9_1)
	assert(arg_9_0._is_server, "[PickupPackageLoader] '_unload_package' is a server only function.")

	arg_9_0._session_pickup_map[arg_9_1] = nil

	arg_9_0._network_handler:set_session_pickup_map(table.shallow_copy(arg_9_0._session_pickup_map))
	arg_9_0:_update_package_diffs()
end

function PickupPackageLoader.update(arg_10_0)
	if not arg_10_0._initialized then
		if Managers.package:has_loaded("resource_packages/pickups") then
			arg_10_0._initialized = true
		end

		return
	end

	arg_10_0:_update_package_diffs()
end

function PickupPackageLoader._package_reference(arg_11_0, arg_11_1)
	local var_11_0 = var_0_0[arg_11_1]

	if var_11_0 then
		return var_11_0
	end

	var_0_0[arg_11_1] = "PickupPackageLoader_" .. arg_11_1

	return var_0_0[arg_11_1]
end

function PickupPackageLoader._cached_3p(arg_12_0, arg_12_1)
	local var_12_0 = var_0_1[arg_12_1]

	if var_12_0 then
		return var_12_0
	end

	var_0_1[arg_12_1] = arg_12_1 .. "_3p"

	return var_0_1[arg_12_1]
end

function PickupPackageLoader._has_loaded_pickup(arg_13_0, arg_13_1)
	local var_13_0 = arg_13_0:_package_reference(arg_13_1)
	local var_13_1 = Managers.package
	local var_13_2 = AllPickups[arg_13_1]
	local var_13_3 = var_13_2.unit_name

	if not var_13_1:has_loaded(var_13_3, var_13_0) then
		return false
	end

	local var_13_4 = rawget(ItemMasterList, var_13_2.item_name)

	if var_13_4 then
		local var_13_5 = var_13_4.temporary_template
		local var_13_6 = WeaponUtils.get_weapon_template(var_13_5)
		local var_13_7 = var_13_6.left_hand_unit

		if var_13_7 and (not var_13_1:has_loaded(var_13_7, var_13_0) or not var_13_1:has_loaded(arg_13_0:_cached_3p(var_13_7), var_13_0)) then
			return false
		end

		local var_13_8 = var_13_6.right_hand_unit

		if var_13_8 and (not var_13_1:has_loaded(var_13_8, var_13_0) or not var_13_1:has_loaded(arg_13_0:_cached_3p(var_13_8), var_13_0)) then
			return false
		end
	end

	return true
end

function PickupPackageLoader._is_loading_pickup(arg_14_0, arg_14_1)
	local var_14_0 = arg_14_0:_package_reference(arg_14_1)
	local var_14_1 = Managers.package
	local var_14_2 = AllPickups[arg_14_1]
	local var_14_3 = var_14_2.unit_name

	if var_14_1:is_loading(var_14_3, var_14_0) then
		return true
	end

	local var_14_4 = rawget(ItemMasterList, var_14_2.item_name)

	if var_14_4 then
		local var_14_5 = var_14_4.temporary_template
		local var_14_6 = WeaponUtils.get_weapon_template(var_14_5)
		local var_14_7 = var_14_6.left_hand_unit

		if var_14_7 and (var_14_1:is_loading(var_14_7, var_14_0) or var_14_1:is_loading(arg_14_0:_cached_3p(var_14_7), var_14_0)) then
			return true
		end

		local var_14_8 = var_14_6.right_hand_unit

		if var_14_8 and (var_14_1:has_loaded(var_14_8, var_14_0) or var_14_1:has_loaded(arg_14_0:_cached_3p(var_14_8), var_14_0)) then
			return true
		end
	end
end

function PickupPackageLoader._load_pickup(arg_15_0, arg_15_1, arg_15_2, arg_15_3)
	local var_15_0 = arg_15_0:_package_reference(arg_15_1)
	local var_15_1 = Managers.package
	local var_15_2 = AllPickups[arg_15_1]
	local var_15_3 = var_15_2.unit_name

	var_15_1:load(var_15_3, var_15_0, nil, arg_15_2, arg_15_3)

	local var_15_4 = rawget(ItemMasterList, var_15_2.item_name)

	if var_15_4 then
		local var_15_5 = var_15_4.temporary_template
		local var_15_6 = WeaponUtils.get_weapon_template(var_15_5)

		if var_15_6 then
			local var_15_7 = var_15_6.left_hand_unit

			if var_15_7 then
				var_15_1:load(var_15_7, var_15_0, nil, arg_15_2, arg_15_3)
				var_15_1:load(arg_15_0:_cached_3p(var_15_7), var_15_0, nil, arg_15_2, arg_15_3)
			end

			local var_15_8 = var_15_6.right_hand_unit

			if var_15_8 then
				var_15_1:load(var_15_8, var_15_0, nil, arg_15_2, arg_15_3)
				var_15_1:load(arg_15_0:_cached_3p(var_15_8), var_15_0, nil, arg_15_2, arg_15_3)
			end
		end
	end
end

function PickupPackageLoader._unload_pickup(arg_16_0, arg_16_1)
	local var_16_0 = arg_16_0:_package_reference(arg_16_1)
	local var_16_1 = Managers.package
	local var_16_2 = AllPickups[arg_16_1]
	local var_16_3 = var_16_2.unit_name

	var_16_1:unload(var_16_3, var_16_0)

	local var_16_4 = var_16_2.temporary_template

	if var_16_4 then
		local var_16_5 = WeaponUtils.get_weapon_template(var_16_4)
		local var_16_6 = var_16_5.left_hand_unit

		if var_16_6 then
			var_16_1:unload(var_16_6, var_16_0)
			var_16_1:unload(arg_16_0:_cached_3p(var_16_6), var_16_0)
		end

		local var_16_7 = var_16_5.right_hand_unit

		if var_16_7 then
			var_16_1:unload(var_16_7, var_16_0)
			var_16_1:unload(arg_16_0:_cached_3p(var_16_7), var_16_0)
		end
	end
end

function PickupPackageLoader._update_package_diffs(arg_17_0, arg_17_1)
	if not arg_17_0._network_handler or not arg_17_0._network_handler:is_fully_synced() then
		return
	end

	local var_17_0 = true
	local var_17_1 = true
	local var_17_2 = arg_17_0._loaded_pickup_map
	local var_17_3 = arg_17_0._session_pickup_map or arg_17_0._network_handler:get_session_pickup_map()
	local var_17_4 = arg_17_0._network_handler:get_own_loaded_session_pickup_map()

	for iter_17_0, iter_17_1 in pairs(var_17_2) do
		if not var_17_3[iter_17_0] then
			arg_17_0:_unload_pickup(iter_17_0)

			var_17_2[iter_17_0] = nil
		end
	end

	for iter_17_2, iter_17_3 in pairs(var_17_3) do
		local var_17_5 = arg_17_0:_has_loaded_pickup(iter_17_2)

		if not var_17_5 and not arg_17_0:_is_loading_pickup(iter_17_2) then
			arg_17_0:_load_pickup(iter_17_2, var_17_0, var_17_1)
		elseif var_17_5 and not var_17_2[iter_17_2] then
			var_17_2[iter_17_2] = true
		elseif iter_17_3 ~= true and arg_17_0:is_pickup_loaded_on_all_peers(iter_17_2) then
			iter_17_3()

			var_17_3[iter_17_2] = true
		end
	end

	if not table.shallow_equal(var_17_2, var_17_4) then
		arg_17_0._network_handler:set_own_loaded_session_pickups(table.shallow_copy(var_17_2))
	end

	if arg_17_0._is_server then
		local var_17_6 = arg_17_0._network_handler:get_session_pickup_map()

		if not table.shallow_equal(var_17_3, var_17_6) then
			arg_17_0._network_handler:set_session_pickup_map(table.shallow_copy(var_17_3))
		end
	end
end

function PickupPackageLoader.load_sync_done_for_peer(arg_18_0, arg_18_1)
	if not arg_18_0._network_handler or not arg_18_0._network_handler:is_fully_synced() then
		return false
	end

	local var_18_0 = arg_18_0._network_handler:get_session_pickup_map()
	local var_18_1 = arg_18_0._network_handler:get_loaded_session_pickups(arg_18_1)

	for iter_18_0 in pairs(var_18_0) do
		if not var_18_1[iter_18_0] then
			return false
		end
	end

	return true
end

function PickupPackageLoader.loading_completed(arg_19_0)
	if not arg_19_0._network_handler or not arg_19_0._network_handler:is_fully_synced() then
		return false
	end

	local var_19_0 = arg_19_0._network_handler:get_session_pickup_map()
	local var_19_1 = arg_19_0._loaded_pickup_map

	for iter_19_0 in pairs(var_19_0) do
		if var_19_1[iter_19_0] ~= true then
			return false
		end
	end

	return true
end

function PickupPackageLoader.on_application_shutdown(arg_20_0)
	local var_20_0 = arg_20_0._loaded_pickup_map
	local var_20_1 = arg_20_0._session_pickup_map

	for iter_20_0, iter_20_1 in pairs(var_20_0) do
		local var_20_2 = arg_20_0:_package_reference(iter_20_0)
		local var_20_3 = AllPickups[iter_20_0].unit_name

		Managers.package:unload(var_20_3, var_20_2)

		if arg_20_0._is_server then
			var_20_1[iter_20_0] = nil
		end

		var_20_0[iter_20_0] = nil
	end
end

function PickupPackageLoader.is_pickup_loaded_on_all_peers(arg_21_0, arg_21_1, arg_21_2)
	local var_21_0 = arg_21_0._is_server and arg_21_0._network_handler:hot_join_synced_peers()

	if arg_21_2 then
		var_21_0 = table.shallow_copy(arg_21_0._network_handler:get_peers(), true)
		var_21_0 = table.array_to_map(var_21_0, function(arg_22_0, arg_22_1)
			return arg_22_1, true
		end)
	end

	for iter_21_0 in pairs(var_21_0) do
		if not arg_21_0._network_handler:get_loaded_session_pickups(iter_21_0)[arg_21_1] then
			return false
		end
	end

	return true
end

function PickupPackageLoader.debug_loaded_pickups(arg_23_0)
	if not arg_23_0._network_handler then
		Debug.text("[PickupPackageLoader] network handler not avaiable")

		return
	end

	local var_23_0 = arg_23_0._network_handler:get_session_pickup_map()

	if table.is_empty(var_23_0) then
		Debug.text("No dynamic pickups to load. (DynamicPickupLoader)")
	else
		Debug.text("Dynamic pickups:")
	end

	local var_23_1 = arg_23_0._is_server and arg_23_0._network_handler:hot_join_synced_peers() or arg_23_0._network_handler:get_peers()

	if not arg_23_0._is_server then
		var_23_1 = table.shallow_copy(arg_23_0._network_handler:get_peers(), true)
		var_23_1 = table.array_to_map(var_23_1, function(arg_24_0, arg_24_1)
			return arg_24_1, true
		end)
	end

	for iter_23_0 in pairs(var_23_0) do
		repeat
			Debug.text("   %s", iter_23_0)

			if not arg_23_0:is_pickup_loaded_on_all_peers(iter_23_0, not arg_23_0._is_server) then
				Debug.text("      --Waiting on Peer(s) to Load--")

				for iter_23_1, iter_23_2 in pairs(var_23_1) do
					if not arg_23_0._network_handler:get_loaded_session_pickups(iter_23_1)[iter_23_0] then
						Debug.text("      %s", iter_23_1)
					end
				end
			end
		until true
	end
end
