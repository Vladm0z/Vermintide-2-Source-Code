-- chunkname: @scripts/game_state/components/general_synced_package_loader.lua

GeneralSyncedPackageLoader = class(GeneralSyncedPackageLoader)

local tbl = {}

GeneralSyncedPackageLoader.init = function (self)
	-- function 1
	self._loaded_mutator_map = {}
	self._cached_mutator_map = {}
end

GeneralSyncedPackageLoader.network_context_created = function (self, arg_2_1, arg_2_2, arg_2_3, arg_2_4)
	-- function 2
	printf("[GeneralSyncedPackageLoader] network_context_created (server_peer_id=%s, own_peer_id=%s)", arg_2_2, arg_2_3)

	self._lobby = arg_2_1
	self._is_server = arg_2_2 == arg_2_3
	self._network_handler = arg_2_4
end

GeneralSyncedPackageLoader.matching_session = function (self, arg_3_1)
	-- function 3
	return self._network_handler == arg_3_1
end

GeneralSyncedPackageLoader.network_context_destroyed = function (self)
	-- function 4
	print("[GeneralSyncedPackageLoader] network_context_destroyed")

	self._lobby = nil
	self._network_handler = nil

	if not self._is_server then
		self._session_mutator_map = nil
	end

	self._is_server = nil
end

GeneralSyncedPackageLoader.update = function (self)
	-- function 5
	self:_update_package_diffs()
end

GeneralSyncedPackageLoader._mutator_package_reference = function (arg_6_0, arg_6_1)
	-- function 6
	local var_6_0 = tbl[arg_6_1]

	if not var_6_0 then
		return var_6_0
	end

	tbl[arg_6_1] = "GeneralSyncedPackageLoader_" .. arg_6_1

	return tbl[arg_6_1]
end

GeneralSyncedPackageLoader._has_loaded_mutator = function (self, arg_7_1)
	-- function 7
	local packages = MutatorTemplates[arg_7_1].packages

	if not packages then
		return true
	end

	local _mutator_package_reference = self:_mutator_package_reference(arg_7_1)
	local package = Managers.package

	for i = 1, #packages do
		local var_7_3 = packages[i]

		if not package:has_loaded(var_7_3, _mutator_package_reference) then
			return false
		end
	end

	return true
end

GeneralSyncedPackageLoader._is_loading_mutator = function (self, arg_8_1)
	-- function 8
	local packages = MutatorTemplates[arg_8_1].packages

	if not packages then
		return false
	end

	local _mutator_package_reference = self:_mutator_package_reference(arg_8_1)
	local package = Managers.package

	for i = 1, #packages do
		local var_8_3 = packages[i]

		if not package:is_loading(var_8_3, _mutator_package_reference) then
			return true
		end
	end

	return false
end

GeneralSyncedPackageLoader._load_mutator = function (self, arg_9_1, arg_9_2, arg_9_3)
	-- function 9
	local packages = MutatorTemplates[arg_9_1].packages

	if not packages then
		return
	end

	local _mutator_package_reference = self:_mutator_package_reference(arg_9_1)
	local package = Managers.package

	for i = 1, #packages do
		local var_9_3 = packages[i]

		package:load(var_9_3, _mutator_package_reference, nil, arg_9_2, arg_9_3)
	end
end

GeneralSyncedPackageLoader._unload_mutator = function (self, arg_10_1)
	-- function 10
	local packages = MutatorTemplates[arg_10_1].packages

	if not packages then
		return
	end

	local _mutator_package_reference = self:_mutator_package_reference(arg_10_1)
	local package = Managers.package

	for i = 1, #packages do
		local var_10_3 = packages[i]

		package:unload(var_10_3, _mutator_package_reference)
	end
end

GeneralSyncedPackageLoader._update_package_diffs = function (self, arg_11_1)
	-- function 11
	if not (not self._network_handler and self._network_handler:is_fully_synced()) then
		return
	end

	local flag = true
	local flag_2 = true
	local _loaded_mutator_map = self._loaded_mutator_map
	local _mutator_map = self:_mutator_map()
	local get_own_loaded_mutator_map = self._network_handler:get_own_loaded_mutator_map()

	for k, v in pairs(_loaded_mutator_map) do
		if not _mutator_map[k] then
			self:_unload_mutator(k)

			_loaded_mutator_map[k] = nil
		end
	end

	for k_2, v_2 in pairs(_mutator_map) do
		local _has_loaded_mutator = self:_has_loaded_mutator(k_2)

		if not (_has_loaded_mutator or self:_is_loading_mutator(k_2)) then
			self:_load_mutator(k_2, flag, flag_2)
		elseif not (not _has_loaded_mutator and _loaded_mutator_map[k_2]) then
			_loaded_mutator_map[k_2] = true
		elseif v_2 == true or not self:is_mutator_loaded_on_all_peers(k_2) then
			v_2()

			_mutator_map[k_2] = true
		end
	end

	if not table.shallow_equal(_loaded_mutator_map, get_own_loaded_mutator_map) then
		self._network_handler:set_own_loaded_mutator_map(table.shallow_copy(_loaded_mutator_map))
	end
end

GeneralSyncedPackageLoader.load_sync_done_for_peer = function (self, arg_12_1)
	-- function 12
	if not (not self._network_handler and self._network_handler:is_fully_synced()) then
		return false
	end

	local _mutator_map = self:_mutator_map()
	local get_loaded_mutator_map = self._network_handler:get_loaded_mutator_map(arg_12_1)

	for k in pairs(_mutator_map) do
		if not get_loaded_mutator_map[k] then
			return false
		end
	end

	return true
end

GeneralSyncedPackageLoader.loading_completed = function (self)
	-- function 13
	if not (not self._network_handler and self._network_handler:is_fully_synced()) then
		return false
	end

	local _mutator_map = self:_mutator_map()
	local _loaded_mutator_map = self._loaded_mutator_map

	for k in pairs(_mutator_map) do
		if _loaded_mutator_map[k] ~= true then
			return false
		end
	end

	return true
end

GeneralSyncedPackageLoader.on_application_shutdown = function (self)
	-- function 14
	local _loaded_mutator_map = self._loaded_mutator_map

	for k in pairs(_loaded_mutator_map) do
		local _mutator_package_reference = self:_mutator_package_reference(k)
		local packages = MutatorTemplates[k].packages

		if not packages then
			for j = 1, #packages do
				local var_14_3 = packages[j]

				Managers.package:unload(var_14_3, _mutator_package_reference)
			end
		end

		_loaded_mutator_map[k] = nil
	end
end

GeneralSyncedPackageLoader.is_mutator_loaded_on_all_peers = function (self, arg_15_1, arg_15_2)
	-- function 15
	local _is_server = self._is_server

	_is_server = not _is_server and self._network_handler:hot_join_synced_peers()

	if not arg_15_2 then
		_is_server = table.shallow_copy(self._network_handler:get_peers(), true)
		_is_server = table.array_to_map(_is_server, function (arg_16_0, arg_16_1)
			-- function 16
			return arg_16_1, true
		end)
	end

	for k in pairs(_is_server) do
		if not self._network_handler:get_loaded_mutator_map(k)[arg_15_1] then
			return false
		end
	end

	return true
end

GeneralSyncedPackageLoader._mutator_map = function (self)
	-- function 17
	local state_revision = self._network_handler:state_revision()

	if self._cached_mutator_map_version == state_revision then
		return self._cached_mutator_map
	end

	self._cached_mutator_map_version = state_revision
	self._cached_mutator_map = {}

	local mutators = self._network_handler:get_game_mode_event_data().mutators

	if not mutators then
		for i = 1, #mutators do
			self._cached_mutator_map[mutators[i]] = true
		end
	end

	return self._cached_mutator_map
end

GeneralSyncedPackageLoader.debug_loaded_packages = function (self)
	-- function 18
	if not self._network_handler then
		Debug.text("[GeneralSyncedPackageLoader] network handler not avaiable")

		return
	end

	local _mutator_map = self._network_handler:_mutator_map()

	if not table.is_empty(_mutator_map) then
		Debug.text("No mutators initialized. (DynamicPackageLoader)")
	else
		Debug.text("Initialized mutators:")
	end

	local hot_join_synced_peers

	if not self._is_server then
		hot_join_synced_peers = self._network_handler:hot_join_synced_peers()

		if not hot_join_synced_peers then
			-- Nothing
		end
	end

	hot_join_synced_peers = self._network_handler:get_peers()

	::label_18_0::

	if not self._is_server then
		hot_join_synced_peers = table.shallow_copy(self._network_handler:get_peers(), true)
		hot_join_synced_peers = table.array_to_map(hot_join_synced_peers, function (arg_19_0, arg_19_1)
			-- function 19
			return arg_19_1, true
		end)
	end

	for k in pairs(_mutator_map) do
		repeat
			Debug.text("   %s", k)

			if not self:is_mutator_loaded_on_all_peers(k, not self._is_server) then
				Debug.text("      --Waiting on Peer(s) to Load--")

				for k_2, v in pairs(hot_join_synced_peers) do
					if not self._network_handler:get_loaded_mutator_map(k_2)[k] then
						Debug.text("      %s", k_2)
					end
				end
			end
		until true
	end
end
