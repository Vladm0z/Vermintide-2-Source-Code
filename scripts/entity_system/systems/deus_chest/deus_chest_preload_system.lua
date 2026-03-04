-- chunkname: @scripts/entity_system/systems/deus_chest/deus_chest_preload_system.lua

require("scripts/network/shared_state")

DeusChestPreloadSystem = class(DeusChestPreloadSystem, ExtensionSystemBase)

local function var_0_0(arg_1_0, arg_1_1)
	local var_1_0 = 0

	for iter_1_0, iter_1_1 in pairs(arg_1_0) do
		if arg_1_1[iter_1_0] ~= iter_1_1 then
			return false
		end

		var_1_0 = var_1_0 + 1
	end

	local var_1_1 = 0

	for iter_1_2, iter_1_3 in pairs(arg_1_1) do
		if arg_1_0[iter_1_2] ~= iter_1_3 then
			return false
		end

		var_1_1 = var_1_1 + 1
	end

	return var_1_0 == var_1_1
end

local function var_0_1(arg_2_0)
	local var_2_0 = {}
	local var_2_1 = NetworkLookup.inventory_packages

	for iter_2_0, iter_2_1 in pairs(arg_2_0) do
		local var_2_2 = var_2_1[iter_2_0]

		assert(var_2_2, "No existing inventory package for attempted name %q", iter_2_0)

		var_2_0[#var_2_0 + 1] = var_2_2
	end

	return (cjson.encode(var_2_0))
end

local function var_0_2(arg_3_0)
	local var_3_0 = cjson.decode(arg_3_0)
	local var_3_1 = {}
	local var_3_2 = NetworkLookup.inventory_packages

	for iter_3_0, iter_3_1 in ipairs(var_3_0) do
		var_3_1[var_3_2[iter_3_1]] = true
	end

	return var_3_1
end

local var_0_3 = {
	server = {},
	peer = {
		preload_packages = {
			type = "table",
			default_value = {},
			composite_keys = {
				local_player_id = true
			},
			encode = var_0_1,
			decode = var_0_2
		}
	}
}

SharedState.validate_spec(var_0_3)

local var_0_4 = "DeusChestPreloadSystem"
local var_0_5 = 1
local var_0_6 = 50
local var_0_7 = 5
local var_0_8 = {}

function DeusChestPreloadSystem.init(arg_4_0, arg_4_1, arg_4_2, arg_4_3)
	DeusChestPreloadSystem.super.init(arg_4_0, arg_4_1, arg_4_2, arg_4_3)

	arg_4_0._deus_chest_to_extension = {}
	arg_4_0._broadphase = Broadphase(255, 30)
	arg_4_0._broadphase_ids = {}
	arg_4_0._loaded_or_loading_packages = {}
	arg_4_0._player_manager = Managers.player
	arg_4_0._package_manager = Managers.package

	local var_4_0 = arg_4_1.is_server
	local var_4_1 = Managers.mechanism:network_handler()
	local var_4_2 = var_4_1.server_peer_id
	local var_4_3 = Network.peer_id()

	arg_4_0._shared_state = SharedState:new("deus_chest_preload", var_0_3, var_4_0, var_4_1, var_4_2, var_4_3)

	local var_4_4 = arg_4_1.network_event_delegate

	arg_4_0._shared_state:register_rpcs(var_4_4)
	arg_4_0:_setup_weapon_preload_settings()
end

function DeusChestPreloadSystem._setup_weapon_preload_settings(arg_5_0)
	local var_5_0 = false
	local var_5_1
	local var_5_2 = Managers.backend:get_deus_weapon_preload_settings()

	if IS_XB1 then
		local var_5_3 = XboxOne.console_type_string()
		local var_5_4 = var_5_2[var_5_3]
		local var_5_5 = var_5_2.default

		if var_5_4 then
			print(string.format("[DeusChestPreloadSystem] Loading weapon preload settings for platform: %q", var_5_3))
			table.dump(var_5_4, "WEAPON_PRELOAD_SETTINGS", 2)

			arg_5_0._deus_chest_preload_amount = var_5_4.deus_chest_preload_amount
			arg_5_0._deus_chest_check_range = var_5_4.deus_chest_check_range
			arg_5_0._deus_chest_update_frequency = var_5_4.deus_chest_update_frequency
			var_5_0 = true
		elseif var_5_5 then
			print(string.format("[DeusChestPreloadSystem] Failed getting weapon preload settings for platform: %q --> using default settings for %q", var_5_3, PLATFORM))
			table.dump(var_5_5, "WEAPON_PRELOAD_SETTINGS", 2)

			arg_5_0._deus_chest_preload_amount = var_5_5.deus_chest_preload_amount
			arg_5_0._deus_chest_check_range = var_5_5.deus_chest_check_range
			arg_5_0._deus_chest_update_frequency = var_5_5.deus_chest_update_frequency
			var_5_0 = true
		end
	elseif IS_PS4 then
		local var_5_6 = "ps4"

		if PS4.is_ps5() then
			var_5_6 = "ps5"
		elseif PS4.is_pro() then
			var_5_6 = "ps4_pro"
		end

		local var_5_7 = var_5_2[var_5_6]
		local var_5_8 = var_5_2.default

		if var_5_7 then
			print(string.format("[DeusChestPreloadSystem] Loading weapon preload settings for platform: %q", var_5_6))
			table.dump(var_5_7, "WEAPON_PRELOAD_SETTINGS", 2)

			arg_5_0._deus_chest_preload_amount = var_5_7.deus_chest_preload_amount
			arg_5_0._deus_chest_check_range = var_5_7.deus_chest_check_range
			arg_5_0._deus_chest_update_frequency = var_5_7.deus_chest_update_frequency
			var_5_0 = true
		elseif var_5_8 then
			print(string.format("[DeusChestPreloadSystem] Failed getting weapon preload settings for platform: %q --> using default settings for %q", var_5_6, PLATFORM))
			table.dump(var_5_8, "WEAPON_PRELOAD_SETTINGS", 2)

			arg_5_0._deus_chest_preload_amount = var_5_8.deus_chest_preload_amount
			arg_5_0._deus_chest_check_range = var_5_8.deus_chest_check_range
			arg_5_0._deus_chest_update_frequency = var_5_8.deus_chest_update_frequency
			var_5_0 = true
		end
	elseif var_5_2 then
		local var_5_9 = var_5_2.default

		if var_5_9 then
			print(string.format("[DeusChestPreloadSystem] Loading weapon preload settings for platform: %q", PLATFORM))
			table.dump(var_5_9, "WEAPON_PRELOAD_SETTINGS", 2)

			arg_5_0._deus_chest_preload_amount = var_5_9.deus_chest_preload_amount
			arg_5_0._deus_chest_check_range = var_5_9.deus_chest_check_range
			arg_5_0._deus_chest_update_frequency = var_5_9.deus_chest_update_frequency
		end
	end

	if not var_5_0 then
		print(string.format("[DeusChestPreloadSystem] Couldn't find settings for platform: %q --> Using fallback settings", PLATFORM))

		arg_5_0._deus_chest_preload_amount = var_0_5
		arg_5_0._deus_chest_check_range = var_0_6
		arg_5_0._deus_chest_update_frequency = var_0_7
	end

	fassert(arg_5_0._deus_chest_preload_amount, "[DeusChestPreloadSystem] Missing weapon preload settings for chest_preload_amount")
	fassert(arg_5_0._deus_chest_check_range, "[DeusChestPreloadSystem] Missing weapon preload settings for chest_range_check")
	fassert(arg_5_0._deus_chest_update_frequency, "[DeusChestPreloadSystem] Missing weapon preload settings for chest_update_frequency")
end

function DeusChestPreloadSystem.destroy(arg_6_0)
	arg_6_0._shared_state:unregister_rpcs()

	local var_6_0 = arg_6_0._loaded_or_loading_packages
	local var_6_1 = arg_6_0._package_manager

	for iter_6_0, iter_6_1 in pairs(var_6_0) do
		var_6_1:unload(iter_6_0, var_0_4)
	end
end

local var_0_9 = {}
local var_0_10 = {}
local var_0_11 = {}

function DeusChestPreloadSystem.update(arg_7_0, arg_7_1, arg_7_2)
	if arg_7_0._deus_chest_preload_amount == 0 then
		return
	end

	arg_7_0._timer = arg_7_0._timer or arg_7_2 + arg_7_0._deus_chest_update_frequency

	if arg_7_2 <= arg_7_0._timer then
		return
	end

	local var_7_0 = Managers.player:local_player()
	local var_7_1 = var_7_0 and var_7_0.player_unit

	if not ALIVE[var_7_1] then
		return
	end

	local var_7_2 = arg_7_0:get_player_preload_packages(var_7_0)

	if not var_7_2 then
		return
	end

	DeusChestPreloadSystem.super.update(arg_7_0, arg_7_1, arg_7_2)
	table.clear(var_0_10)

	local var_7_3 = POSITION_LOOKUP[var_7_1]
	local var_7_4 = Broadphase.query(arg_7_0._broadphase, var_7_3, arg_7_0._deus_chest_check_range, var_0_8)
	local var_7_5 = math.min(var_7_4, arg_7_0._deus_chest_preload_amount)
	local var_7_6 = arg_7_0._deus_chest_to_extension

	for iter_7_0 = 1, var_7_5 do
		local var_7_7 = var_7_6[var_0_8[iter_7_0]]:get_weapon_preload_packages()

		for iter_7_1, iter_7_2 in ipairs(var_7_7) do
			var_0_10[iter_7_2] = true
		end
	end

	if not var_0_0(var_0_10, var_7_2) then
		arg_7_0:set_player_preload_packages(var_7_0, var_0_10)
	end

	table.clear(var_0_10)
	table.clear(var_0_9)
	table.clear(var_0_11)

	local var_7_8 = arg_7_0._package_manager
	local var_7_9 = arg_7_0._player_manager:human_players()

	for iter_7_3, iter_7_4 in pairs(var_7_9) do
		local var_7_10 = arg_7_0:get_player_preload_packages(iter_7_4)

		for iter_7_5, iter_7_6 in pairs(var_7_10) do
			var_0_10[iter_7_5] = true
		end

		for iter_7_7, iter_7_8 in pairs(var_7_10) do
			if not var_7_8:has_loaded(iter_7_7, var_0_4) then
				var_0_9[iter_7_7] = true
			end
		end
	end

	local var_7_11 = arg_7_0._loaded_or_loading_packages

	for iter_7_9, iter_7_10 in pairs(var_0_9) do
		if not var_7_8:is_loading(iter_7_9) then
			local var_7_12 = true

			var_7_11[iter_7_9] = true

			var_7_8:load(iter_7_9, var_0_4, nil, var_7_12)
		end
	end

	for iter_7_11, iter_7_12 in pairs(var_7_11) do
		var_0_11[iter_7_11] = true
	end

	for iter_7_13, iter_7_14 in pairs(var_0_10) do
		var_0_11[iter_7_13] = nil
	end

	for iter_7_15, iter_7_16 in pairs(var_0_11) do
		if var_7_8:can_unload(iter_7_15) then
			var_7_8:unload(iter_7_15, var_0_4)

			var_7_11[iter_7_15] = nil
		end
	end

	arg_7_0._timer = arg_7_2 + arg_7_0._deus_chest_update_frequency
end

function DeusChestPreloadSystem.on_add_extension(arg_8_0, arg_8_1, arg_8_2, arg_8_3, arg_8_4, ...)
	local var_8_0 = DeusChestPreloadSystem.super.on_add_extension(arg_8_0, arg_8_1, arg_8_2, arg_8_3, arg_8_4)
	local var_8_1 = POSITION_LOOKUP[arg_8_2]
	local var_8_2 = Broadphase.add(arg_8_0._broadphase, arg_8_2, var_8_1, 0.1)

	arg_8_0._broadphase_ids[arg_8_2] = var_8_2
	arg_8_0._deus_chest_to_extension[arg_8_2] = var_8_0

	return var_8_0
end

function DeusChestPreloadSystem.on_remove_extension(arg_9_0, arg_9_1, arg_9_2, ...)
	local var_9_0 = arg_9_0._broadphase_ids
	local var_9_1 = var_9_0[arg_9_1]

	Broadphase.remove(arg_9_0._broadphase, var_9_1)

	var_9_0[arg_9_1] = nil
	arg_9_0._deus_chest_to_extension[arg_9_1] = nil

	return DeusChestPreloadSystem.super.on_remove_extension(arg_9_0, arg_9_1, arg_9_2, ...)
end

function DeusChestPreloadSystem.get_player_preload_packages(arg_10_0, arg_10_1)
	local var_10_0 = arg_10_1.peer_id
	local var_10_1 = arg_10_1:local_player_id()

	if var_10_0 and var_10_1 then
		local var_10_2 = arg_10_0._shared_state:get_key("preload_packages", nil, var_10_1)

		return arg_10_0._shared_state:get_peer(var_10_0, var_10_2)
	else
		return nil
	end
end

function DeusChestPreloadSystem.set_player_preload_packages(arg_11_0, arg_11_1, arg_11_2)
	local var_11_0 = arg_11_1.peer_id
	local var_11_1 = arg_11_1:local_player_id()
	local var_11_2 = arg_11_0._shared_state:get_key("preload_packages", nil, var_11_1)

	arg_11_0._shared_state:set_peer(var_11_0, var_11_2, table.clone(arg_11_2))
end
