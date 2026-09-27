-- chunkname: @scripts/game_state/components/pickup_package_loader.lua

PickupPackageLoader = class(PickupPackageLoader)

local tbl = {}
local tbl_2 = {}

PickupPackageLoader.init = function (self)
	-- function 1
	self._loaded_pickup_map = {}
end

PickupPackageLoader.network_context_created = function (self, arg_2_1, arg_2_2, arg_2_3, arg_2_4)
	-- function 2
	printf("[PickupPackageLoader] network_context_created (server_peer_id=%s, own_peer_id=%s)", arg_2_2, arg_2_3)

	self._lobby = arg_2_1

	local flag = arg_2_2 == arg_2_3

	self._is_server = flag

	if not flag then
		self._session_pickup_map = {}
	end

	self._network_handler = arg_2_4
end

PickupPackageLoader.matching_session = function (self, arg_3_1)
	-- function 3
	return self._network_handler == arg_3_1
end

PickupPackageLoader.network_context_destroyed = function (self)
	-- function 4
	print("[PickupPackageLoader] network_context_destroyed")

	self._lobby = nil
	self._network_handler = nil

	if not self._is_server then
		self._session_pickup_map = nil
	end

	self._is_server = nil
end

PickupPackageLoader.request_pickup = function (self, arg_5_1, arg_5_2)
	-- function 5
	assert(self._is_server, "[PickupPackageLoader] 'request_pickup' is a server only function")

	local var_5_0 = self._session_pickup_map[arg_5_1]

	if not var_5_0 then
		if not arg_5_2 then
			self._session_pickup_map[arg_5_1] = function ()
				-- function 6
				if var_5_0 ~= true then
					var_5_0()
				end

				arg_5_2()
			end
		end

		return
	end

	self._session_pickup_map[arg_5_1] = arg_5_2 or true

	self._network_handler:set_session_pickup_map(table.shallow_copy(self._session_pickup_map))
	self:_update_package_diffs()
end

PickupPackageLoader.is_pickup_processed = function (self, arg_7_1)
	-- function 7
	return self._network_handler:get_session_pickup_map()[arg_7_1]
end

PickupPackageLoader.processed_pickups = function (self)
	-- function 8
	return self._network_handler:get_session_pickup_map()
end

PickupPackageLoader._unload_package = function (self, arg_9_1)
	-- function 9
	assert(self._is_server, "[PickupPackageLoader] '_unload_package' is a server only function.")

	self._session_pickup_map[arg_9_1] = nil

	self._network_handler:set_session_pickup_map(table.shallow_copy(self._session_pickup_map))
	self:_update_package_diffs()
end

PickupPackageLoader.update = function (self)
	-- function 10
	if not self._initialized then
		if not Managers.package:has_loaded("resource_packages/pickups") then
			self._initialized = true
		end

		return
	end

	self:_update_package_diffs()
end

PickupPackageLoader._package_reference = function (arg_11_0, arg_11_1)
	-- function 11
	local var_11_0 = tbl[arg_11_1]

	if not var_11_0 then
		return var_11_0
	end

	tbl[arg_11_1] = "PickupPackageLoader_" .. arg_11_1

	return tbl[arg_11_1]
end

PickupPackageLoader._cached_3p = function (arg_12_0, arg_12_1)
	-- function 12
	local var_12_0 = tbl_2[arg_12_1]

	if not var_12_0 then
		return var_12_0
	end

	tbl_2[arg_12_1] = arg_12_1 .. "_3p"

	return tbl_2[arg_12_1]
end

PickupPackageLoader._has_loaded_pickup = function (self, arg_13_1)
	-- function 13
	local _package_reference = self:_package_reference(arg_13_1)
	local package = Managers.package
	local var_13_2 = AllPickups[arg_13_1]
	local unit_name = var_13_2.unit_name

	if not package:has_loaded(unit_name, _package_reference) then
		return false
	end

	local var_13_4 = rawget(ItemMasterList, var_13_2.item_name)

	if not var_13_4 then
		local temporary_template = var_13_4.temporary_template
		local get_weapon_template = WeaponUtils.get_weapon_template(temporary_template)
		local left_hand_unit = get_weapon_template.left_hand_unit

		if not (not left_hand_unit and not package:has_loaded(left_hand_unit, _package_reference) and package:has_loaded(self:_cached_3p(left_hand_unit), _package_reference)) then
			return false
		end

		local right_hand_unit = get_weapon_template.right_hand_unit

		if not (not right_hand_unit and not package:has_loaded(right_hand_unit, _package_reference) and package:has_loaded(self:_cached_3p(right_hand_unit), _package_reference)) then
			return false
		end
	end

	return true
end

PickupPackageLoader._is_loading_pickup = function (self, arg_14_1)
	-- function 14
	local _package_reference = self:_package_reference(arg_14_1)
	local package = Managers.package
	local var_14_2 = AllPickups[arg_14_1]
	local unit_name = var_14_2.unit_name

	if not package:is_loading(unit_name, _package_reference) then
		return true
	end

	local var_14_4 = rawget(ItemMasterList, var_14_2.item_name)

	if not var_14_4 then
		local temporary_template = var_14_4.temporary_template
		local get_weapon_template = WeaponUtils.get_weapon_template(temporary_template)
		local left_hand_unit = get_weapon_template.left_hand_unit

		if not left_hand_unit and package:is_loading(left_hand_unit, _package_reference) and not package:is_loading(self:_cached_3p(left_hand_unit), _package_reference) then
			return true
		end

		local right_hand_unit = get_weapon_template.right_hand_unit

		if not right_hand_unit and package:has_loaded(right_hand_unit, _package_reference) and not package:has_loaded(self:_cached_3p(right_hand_unit), _package_reference) then
			return true
		end
	end
end

PickupPackageLoader._load_pickup = function (self, arg_15_1, arg_15_2, arg_15_3)
	-- function 15
	local _package_reference = self:_package_reference(arg_15_1)
	local package = Managers.package
	local var_15_2 = AllPickups[arg_15_1]
	local unit_name = var_15_2.unit_name

	package:load(unit_name, _package_reference, nil, arg_15_2, arg_15_3)

	local var_15_4 = rawget(ItemMasterList, var_15_2.item_name)

	if not var_15_4 then
		local temporary_template = var_15_4.temporary_template
		local get_weapon_template = WeaponUtils.get_weapon_template(temporary_template)

		if not get_weapon_template then
			local left_hand_unit = get_weapon_template.left_hand_unit

			if not left_hand_unit then
				package:load(left_hand_unit, _package_reference, nil, arg_15_2, arg_15_3)
				package:load(self:_cached_3p(left_hand_unit), _package_reference, nil, arg_15_2, arg_15_3)
			end

			local right_hand_unit = get_weapon_template.right_hand_unit

			if not right_hand_unit then
				package:load(right_hand_unit, _package_reference, nil, arg_15_2, arg_15_3)
				package:load(self:_cached_3p(right_hand_unit), _package_reference, nil, arg_15_2, arg_15_3)
			end
		end
	end
end

PickupPackageLoader._unload_pickup = function (self, arg_16_1)
	-- function 16
	local _package_reference = self:_package_reference(arg_16_1)
	local package = Managers.package
	local var_16_2 = AllPickups[arg_16_1]
	local unit_name = var_16_2.unit_name

	package:unload(unit_name, _package_reference)

	local temporary_template = var_16_2.temporary_template

	if not temporary_template then
		local get_weapon_template = WeaponUtils.get_weapon_template(temporary_template)
		local left_hand_unit = get_weapon_template.left_hand_unit

		if not left_hand_unit then
			package:unload(left_hand_unit, _package_reference)
			package:unload(self:_cached_3p(left_hand_unit), _package_reference)
		end

		local right_hand_unit = get_weapon_template.right_hand_unit

		if not right_hand_unit then
			package:unload(right_hand_unit, _package_reference)
			package:unload(self:_cached_3p(right_hand_unit), _package_reference)
		end
	end
end

PickupPackageLoader._update_package_diffs = function (self, arg_17_1)
	-- function 17
	if not (not self._network_handler and self._network_handler:is_fully_synced()) then
		return
	end

	local flag = true
	local flag_2 = true
	local _loaded_pickup_map = self._loaded_pickup_map
	local _session_pickup_map = self._session_pickup_map

	_session_pickup_map = _session_pickup_map or self._network_handler:get_session_pickup_map()

	local get_own_loaded_session_pickup_map = self._network_handler:get_own_loaded_session_pickup_map()

	for k, v in pairs(_loaded_pickup_map) do
		if not _session_pickup_map[k] then
			self:_unload_pickup(k)

			_loaded_pickup_map[k] = nil
		end
	end

	for k_2, v_2 in pairs(_session_pickup_map) do
		local _has_loaded_pickup = self:_has_loaded_pickup(k_2)

		if not (_has_loaded_pickup or self:_is_loading_pickup(k_2)) then
			self:_load_pickup(k_2, flag, flag_2)
		elseif not (not _has_loaded_pickup and _loaded_pickup_map[k_2]) then
			_loaded_pickup_map[k_2] = true
		elseif v_2 == true or not self:is_pickup_loaded_on_all_peers(k_2) then
			v_2()

			_session_pickup_map[k_2] = true
		end
	end

	if not table.shallow_equal(_loaded_pickup_map, get_own_loaded_session_pickup_map) then
		self._network_handler:set_own_loaded_session_pickups(table.shallow_copy(_loaded_pickup_map))
	end

	if not self._is_server then
		local get_session_pickup_map = self._network_handler:get_session_pickup_map()

		if not table.shallow_equal(_session_pickup_map, get_session_pickup_map) then
			self._network_handler:set_session_pickup_map(table.shallow_copy(_session_pickup_map))
		end
	end
end

PickupPackageLoader.load_sync_done_for_peer = function (self, arg_18_1)
	-- function 18
	if not (not self._network_handler and self._network_handler:is_fully_synced()) then
		return false
	end

	local get_session_pickup_map = self._network_handler:get_session_pickup_map()
	local get_loaded_session_pickups = self._network_handler:get_loaded_session_pickups(arg_18_1)

	for k in pairs(get_session_pickup_map) do
		if not get_loaded_session_pickups[k] then
			return false
		end
	end

	return true
end

PickupPackageLoader.loading_completed = function (self)
	-- function 19
	if not (not self._network_handler and self._network_handler:is_fully_synced()) then
		return false
	end

	local get_session_pickup_map = self._network_handler:get_session_pickup_map()
	local _loaded_pickup_map = self._loaded_pickup_map

	for k in pairs(get_session_pickup_map) do
		if _loaded_pickup_map[k] ~= true then
			return false
		end
	end

	return true
end

PickupPackageLoader.on_application_shutdown = function (self)
	-- function 20
	local _loaded_pickup_map = self._loaded_pickup_map
	local _session_pickup_map = self._session_pickup_map

	for k, v in pairs(_loaded_pickup_map) do
		local _package_reference = self:_package_reference(k)
		local unit_name = AllPickups[k].unit_name

		Managers.package:unload(unit_name, _package_reference)

		if not self._is_server then
			_session_pickup_map[k] = nil
		end

		_loaded_pickup_map[k] = nil
	end
end

PickupPackageLoader.is_pickup_loaded_on_all_peers = function (self, arg_21_1, arg_21_2)
	-- function 21
	local _is_server = self._is_server

	_is_server = not _is_server and self._network_handler:hot_join_synced_peers()

	if not arg_21_2 then
		_is_server = table.shallow_copy(self._network_handler:get_peers(), true)
		_is_server = table.array_to_map(_is_server, function (arg_22_0, arg_22_1)
			-- function 22
			return arg_22_1, true
		end)
	end

	for k in pairs(_is_server) do
		if not self._network_handler:get_loaded_session_pickups(k)[arg_21_1] then
			return false
		end
	end

	return true
end

PickupPackageLoader.debug_loaded_pickups = function (self)
	-- function 23
	if not self._network_handler then
		Debug.text("[PickupPackageLoader] network handler not avaiable")

		return
	end

	local get_session_pickup_map = self._network_handler:get_session_pickup_map()

	if not table.is_empty(get_session_pickup_map) then
		Debug.text("No dynamic pickups to load. (DynamicPickupLoader)")
	else
		Debug.text("Dynamic pickups:")
	end

	local hot_join_synced_peers

	if not self._is_server then
		hot_join_synced_peers = self._network_handler:hot_join_synced_peers()

		if not hot_join_synced_peers then
			-- Nothing
		end
	end

	hot_join_synced_peers = self._network_handler:get_peers()

	::label_23_0::

	if not self._is_server then
		hot_join_synced_peers = table.shallow_copy(self._network_handler:get_peers(), true)
		hot_join_synced_peers = table.array_to_map(hot_join_synced_peers, function (arg_24_0, arg_24_1)
			-- function 24
			return arg_24_1, true
		end)
	end

	for k in pairs(get_session_pickup_map) do
		repeat
			Debug.text("   %s", k)

			if not self:is_pickup_loaded_on_all_peers(k, not self._is_server) then
				Debug.text("      --Waiting on Peer(s) to Load--")

				for k_2, v in pairs(hot_join_synced_peers) do
					if not self._network_handler:get_loaded_session_pickups(k_2)[k] then
						Debug.text("      %s", k_2)
					end
				end
			end
		until true
	end
end
