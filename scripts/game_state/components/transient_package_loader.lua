-- chunkname: @scripts/game_state/components/transient_package_loader.lua

TransientPackageLoader = class(TransientPackageLoader)

local num = 60
local get_data = Unit.get_data

local function fn(self)
	-- function 1
	table.clear(self.units)
	table.clear(self.refs)
end

local function fn_2(arg_2_0, arg_2_1, arg_2_2)
	-- function 2
	arg_2_2.units[arg_2_0] = arg_2_1

	local refs = arg_2_2.refs
	local var_2_1 = arg_2_2.refs[arg_2_1]

	var_2_1 = var_2_1 or 0
	refs[arg_2_1] = var_2_1 + 1
end

local function fn_3(arg_3_0, arg_3_1)
	-- function 3
	local var_3_0 = arg_3_1.units[arg_3_0]

	if not var_3_0 then
		arg_3_1.units[arg_3_0] = nil

		local refs = arg_3_1.refs

		if refs[var_3_0] <= 1 then
			refs[var_3_0] = nil
		else
			refs[var_3_0] = refs[var_3_0] - 1
		end
	end
end

TransientPackageLoader.init = function (self)
	-- function 4
	self._unload_package_queue = {}
	self._load_package_queue = {}
	self._tracked_projectiles = {
		units = {},
		refs = {}
	}
	self._tracked_units = {
		units = {},
		refs = {}
	}
end

local tbl = {
	"rpc_sync_transient_projectile_packages",
	"rpc_sync_transient_unit_packages",
	"rpc_sync_transient_ready"
}

TransientPackageLoader.register_rpcs = function (self, arg_5_1)
	-- function 5
	self.network_event_delegate = arg_5_1

	arg_5_1:register(self, unpack(tbl))
end

TransientPackageLoader.unregister_rpcs = function (self)
	-- function 6
	self.network_event_delegate:unregister(self)

	self.network_event_delegate = nil
end

TransientPackageLoader.network_context_created = function (self, arg_7_1, arg_7_2, arg_7_3)
	-- function 7
	printf("[TransientPackageLoader] network_context_created (server_peer_id=%s, own_peer_id=%s)", arg_7_2, arg_7_3)

	self._sync_ready = arg_7_2 == arg_7_3
	self._loaded = arg_7_2 == arg_7_3
	self._loading_started = self._loaded
	self._should_unload_packages_t = nil
	self._last_package_checked = nil
end

TransientPackageLoader.network_context_destroyed = function (self)
	-- function 8
	print("[TransientPackageLoader] network_context_destroyed")

	self._should_unload_packages_t = nil
	self._last_package_checked = nil

	fn(self._tracked_projectiles)
	fn(self._tracked_units)
end

TransientPackageLoader.update = function (self)
	-- function 9
	if not (not self._should_unload_packages_t and not (self._should_unload_packages_t < Managers.time:time("game"))) then
		local _unload_package_queue = self._unload_package_queue
		local package = Managers.package
		local var_9_2 = next(_unload_package_queue, self._last_package_checked)

		self._last_package_checked = var_9_2

		if not var_9_2 and package:num_references(var_9_2) > 1 and not package:can_unload(var_9_2) then
			Managers.package:unload(var_9_2, "TransientPackageLoader")

			_unload_package_queue[var_9_2] = nil
		end

		if not (var_9_2 ~= nil or next(_unload_package_queue) ~= nil) then
			self._should_unload_packages_t = nil
			self._last_package_checked = nil
		end
	elseif self._loaded or not self._sync_ready then
		local package_2 = Managers.package

		if not self._loading_started then
			for k in pairs(self._load_package_queue) do
				if not package_2:has_loaded(k) then
					return false
				else
					self._unload_package_queue[k] = self._load_package_queue[k]
					self._load_package_queue[k] = nil
				end
			end

			self._loaded = true
		else
			for k_2 in pairs(self._load_package_queue) do
				Managers.package:load(k_2, "TransientPackageLoader", nil, true)
			end

			self._loading_started = true
		end
	end
end

TransientPackageLoader.signal_in_game = function (self)
	-- function 10
	self._should_unload_packages_t = Managers.time:time("game") + num
end

TransientPackageLoader.unload_all_packages = function (self)
	-- function 11
	for k in pairs(self._load_package_queue) do
		Managers.package:unload(k, "TransientPackageLoader")
	end

	for k_2 in pairs(self._unload_package_queue) do
		Managers.package:unload(k_2, "TransientPackageLoader")
	end

	table.clear(self._load_package_queue)
	table.clear(self._unload_package_queue)
	fn(self._tracked_projectiles)
	fn(self._tracked_units)

	self._last_package_checked = nil
	self._should_unload_packages_t = nil
end

TransientPackageLoader.loading_completed = function (self)
	-- function 12
	return self._loaded
end

TransientPackageLoader.add_projectile = function (self, arg_13_1)
	-- function 13
	local var_13_0 = get_data(arg_13_1, "unit_name")
	local var_13_1 = ProjectileUnitsFromUnitName[var_13_0]
	local var_13_2 = ProjectileUnits[var_13_1]

	if not (not var_13_2 and var_13_2.transient_package_loader_ignore) then
		fn_2(arg_13_1, var_13_1, self._tracked_projectiles)
	end
end

TransientPackageLoader.add_unit = function (self, arg_14_1, arg_14_2)
	-- function 14
	fn_2(arg_14_1, arg_14_2 or get_data(arg_14_1, "unit_name"), self._tracked_units)
end

TransientPackageLoader.remove_projectile = function (self, arg_15_1)
	-- function 15
	fn_3(arg_15_1, self._tracked_projectiles)
end

TransientPackageLoader.remove_unit = function (self, arg_16_1)
	-- function 16
	fn_3(arg_16_1, self._tracked_units)
end

TransientPackageLoader.hot_join_sync = function (self, arg_17_1)
	-- function 17
	local var_17_0 = PEER_ID_TO_CHANNEL[arg_17_1]
	local tbl = {}
	local num = 0
	local refs = self._tracked_projectiles.refs

	table.clear(tbl)

	local num_2 = 0

	for k in pairs(refs) do
		num_2 = num_2 + 1
		tbl[num_2] = NetworkLookup.projectile_units[k]
	end

	if num_2 > 0 then
		RPC.rpc_sync_transient_projectile_packages(var_17_0, tbl)
	end

	local refs_2 = self._tracked_units.refs

	table.clear(tbl)

	local num_3 = 0

	for k_2 in pairs(refs_2) do
		num_3 = num_3 + 1
		tbl[num_3] = NetworkLookup.husks[k_2]
	end

	if num_3 > 0 then
		RPC.rpc_sync_transient_unit_packages(var_17_0, tbl)
	end

	RPC.rpc_sync_transient_ready(var_17_0)
end

TransientPackageLoader.rpc_sync_transient_projectile_packages = function (self, arg_18_1, arg_18_2)
	-- function 18
	local _load_package_queue = self._load_package_queue

	for i = 1, #arg_18_2 do
		local var_18_1 = arg_18_2[i]
		local var_18_2 = NetworkLookup.projectile_units[var_18_1]
		local var_18_3 = ProjectileUnits[var_18_2]

		if not var_18_3.projectile_unit_name then
			_load_package_queue[var_18_3.projectile_unit_name] = true
		end

		if not var_18_3.dummy_linker_unit_name then
			_load_package_queue[var_18_3.dummy_linker_unit_name] = true
		end

		local dummy_linker_broken_units = var_18_3.dummy_linker_broken_units

		if not dummy_linker_broken_units then
			for j = 1, #dummy_linker_broken_units do
				_load_package_queue[dummy_linker_broken_units[j]] = true
			end
		end
	end
end

TransientPackageLoader.rpc_sync_transient_unit_packages = function (self, arg_19_1, arg_19_2)
	-- function 19
	local _load_package_queue = self._load_package_queue

	for i = 1, #arg_19_2 do
		local var_19_1 = arg_19_2[i]

		_load_package_queue[NetworkLookup.husks[var_19_1]] = true
	end
end

TransientPackageLoader.rpc_sync_transient_ready = function (self, arg_20_1)
	-- function 20
	self._sync_ready = true
end
