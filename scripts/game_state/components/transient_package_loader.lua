-- chunkname: @scripts/game_state/components/transient_package_loader.lua

TransientPackageLoader = class(TransientPackageLoader)

local var_0_0 = 60
local var_0_1 = Unit.get_data

local function var_0_2(arg_1_0)
	table.clear(arg_1_0.units)
	table.clear(arg_1_0.refs)
end

local function var_0_3(arg_2_0, arg_2_1, arg_2_2)
	arg_2_2.units[arg_2_0] = arg_2_1
	arg_2_2.refs[arg_2_1] = (arg_2_2.refs[arg_2_1] or 0) + 1
end

local function var_0_4(arg_3_0, arg_3_1)
	local var_3_0 = arg_3_1.units[arg_3_0]

	if var_3_0 then
		arg_3_1.units[arg_3_0] = nil

		local var_3_1 = arg_3_1.refs

		if var_3_1[var_3_0] <= 1 then
			var_3_1[var_3_0] = nil
		else
			var_3_1[var_3_0] = var_3_1[var_3_0] - 1
		end
	end
end

TransientPackageLoader.init = function (arg_4_0)
	arg_4_0._unload_package_queue = {}
	arg_4_0._load_package_queue = {}
	arg_4_0._tracked_projectiles = {
		units = {},
		refs = {}
	}
	arg_4_0._tracked_units = {
		units = {},
		refs = {}
	}
end

local var_0_5 = {
	"rpc_sync_transient_projectile_packages",
	"rpc_sync_transient_unit_packages",
	"rpc_sync_transient_ready"
}

TransientPackageLoader.register_rpcs = function (arg_5_0, arg_5_1)
	arg_5_0.network_event_delegate = arg_5_1

	arg_5_1:register(arg_5_0, unpack(var_0_5))
end

TransientPackageLoader.unregister_rpcs = function (arg_6_0)
	arg_6_0.network_event_delegate:unregister(arg_6_0)

	arg_6_0.network_event_delegate = nil
end

TransientPackageLoader.network_context_created = function (arg_7_0, arg_7_1, arg_7_2, arg_7_3)
	printf("[TransientPackageLoader] network_context_created (server_peer_id=%s, own_peer_id=%s)", arg_7_2, arg_7_3)

	arg_7_0._sync_ready = arg_7_2 == arg_7_3
	arg_7_0._loaded = arg_7_2 == arg_7_3
	arg_7_0._loading_started = arg_7_0._loaded
	arg_7_0._should_unload_packages_t = nil
	arg_7_0._last_package_checked = nil
end

TransientPackageLoader.network_context_destroyed = function (arg_8_0)
	print("[TransientPackageLoader] network_context_destroyed")

	arg_8_0._should_unload_packages_t = nil
	arg_8_0._last_package_checked = nil

	var_0_2(arg_8_0._tracked_projectiles)
	var_0_2(arg_8_0._tracked_units)
end

TransientPackageLoader.update = function (arg_9_0)
	if arg_9_0._should_unload_packages_t and arg_9_0._should_unload_packages_t < Managers.time:time("game") then
		local var_9_0 = arg_9_0._unload_package_queue
		local var_9_1 = Managers.package
		local var_9_2 = next(var_9_0, arg_9_0._last_package_checked)

		arg_9_0._last_package_checked = var_9_2

		if var_9_2 and (var_9_1:num_references(var_9_2) > 1 or var_9_1:can_unload(var_9_2)) then
			Managers.package:unload(var_9_2, "TransientPackageLoader")

			var_9_0[var_9_2] = nil
		end

		if var_9_2 == nil and next(var_9_0) == nil then
			arg_9_0._should_unload_packages_t = nil
			arg_9_0._last_package_checked = nil
		end
	elseif not arg_9_0._loaded and arg_9_0._sync_ready then
		local var_9_3 = Managers.package

		if arg_9_0._loading_started then
			for iter_9_0 in pairs(arg_9_0._load_package_queue) do
				if not var_9_3:has_loaded(iter_9_0) then
					return false
				else
					arg_9_0._unload_package_queue[iter_9_0] = arg_9_0._load_package_queue[iter_9_0]
					arg_9_0._load_package_queue[iter_9_0] = nil
				end
			end

			arg_9_0._loaded = true
		else
			for iter_9_1 in pairs(arg_9_0._load_package_queue) do
				Managers.package:load(iter_9_1, "TransientPackageLoader", nil, true)
			end

			arg_9_0._loading_started = true
		end
	end
end

TransientPackageLoader.signal_in_game = function (arg_10_0)
	arg_10_0._should_unload_packages_t = Managers.time:time("game") + var_0_0
end

TransientPackageLoader.unload_all_packages = function (arg_11_0)
	for iter_11_0 in pairs(arg_11_0._load_package_queue) do
		Managers.package:unload(iter_11_0, "TransientPackageLoader")
	end

	for iter_11_1 in pairs(arg_11_0._unload_package_queue) do
		Managers.package:unload(iter_11_1, "TransientPackageLoader")
	end

	table.clear(arg_11_0._load_package_queue)
	table.clear(arg_11_0._unload_package_queue)
	var_0_2(arg_11_0._tracked_projectiles)
	var_0_2(arg_11_0._tracked_units)

	arg_11_0._last_package_checked = nil
	arg_11_0._should_unload_packages_t = nil
end

TransientPackageLoader.loading_completed = function (arg_12_0)
	return arg_12_0._loaded
end

TransientPackageLoader.add_projectile = function (arg_13_0, arg_13_1)
	local var_13_0 = var_0_1(arg_13_1, "unit_name")
	local var_13_1 = ProjectileUnitsFromUnitName[var_13_0]
	local var_13_2 = ProjectileUnits[var_13_1]

	if var_13_2 and not var_13_2.transient_package_loader_ignore then
		var_0_3(arg_13_1, var_13_1, arg_13_0._tracked_projectiles)
	end
end

TransientPackageLoader.add_unit = function (arg_14_0, arg_14_1, arg_14_2)
	var_0_3(arg_14_1, arg_14_2 or var_0_1(arg_14_1, "unit_name"), arg_14_0._tracked_units)
end

TransientPackageLoader.remove_projectile = function (arg_15_0, arg_15_1)
	var_0_4(arg_15_1, arg_15_0._tracked_projectiles)
end

TransientPackageLoader.remove_unit = function (arg_16_0, arg_16_1)
	var_0_4(arg_16_1, arg_16_0._tracked_units)
end

TransientPackageLoader.hot_join_sync = function (arg_17_0, arg_17_1)
	local var_17_0 = PEER_ID_TO_CHANNEL[arg_17_1]
	local var_17_1 = {}
	local var_17_2 = 0
	local var_17_3 = arg_17_0._tracked_projectiles.refs

	table.clear(var_17_1)

	local var_17_4 = 0

	for iter_17_0 in pairs(var_17_3) do
		var_17_4 = var_17_4 + 1
		var_17_1[var_17_4] = NetworkLookup.projectile_units[iter_17_0]
	end

	if var_17_4 > 0 then
		RPC.rpc_sync_transient_projectile_packages(var_17_0, var_17_1)
	end

	local var_17_5 = arg_17_0._tracked_units.refs

	table.clear(var_17_1)

	local var_17_6 = 0

	for iter_17_1 in pairs(var_17_5) do
		var_17_6 = var_17_6 + 1
		var_17_1[var_17_6] = NetworkLookup.husks[iter_17_1]
	end

	if var_17_6 > 0 then
		RPC.rpc_sync_transient_unit_packages(var_17_0, var_17_1)
	end

	RPC.rpc_sync_transient_ready(var_17_0)
end

TransientPackageLoader.rpc_sync_transient_projectile_packages = function (arg_18_0, arg_18_1, arg_18_2)
	local var_18_0 = arg_18_0._load_package_queue

	for iter_18_0 = 1, #arg_18_2 do
		local var_18_1 = arg_18_2[iter_18_0]
		local var_18_2 = NetworkLookup.projectile_units[var_18_1]
		local var_18_3 = ProjectileUnits[var_18_2]

		if var_18_3.projectile_unit_name then
			var_18_0[var_18_3.projectile_unit_name] = true
		end

		if var_18_3.dummy_linker_unit_name then
			var_18_0[var_18_3.dummy_linker_unit_name] = true
		end

		local var_18_4 = var_18_3.dummy_linker_broken_units

		if var_18_4 then
			for iter_18_1 = 1, #var_18_4 do
				var_18_0[var_18_4[iter_18_1]] = true
			end
		end
	end
end

TransientPackageLoader.rpc_sync_transient_unit_packages = function (arg_19_0, arg_19_1, arg_19_2)
	local var_19_0 = arg_19_0._load_package_queue

	for iter_19_0 = 1, #arg_19_2 do
		local var_19_1 = arg_19_2[iter_19_0]

		var_19_0[NetworkLookup.husks[var_19_1]] = true
	end
end

TransientPackageLoader.rpc_sync_transient_ready = function (arg_20_0, arg_20_1)
	arg_20_0._sync_ready = true
end
