-- chunkname: @scripts/entity_system/systems/deus_chest/deus_chest_preload_system.lua

require("scripts/network/shared_state")

DeusChestPreloadSystem = class(DeusChestPreloadSystem, ExtensionSystemBase)

local function fn(self, arg_1_1)
	-- function 1
	local num = 0

	for k, v in pairs(self) do
		if arg_1_1[k] ~= v then
			return false
		end

		num = num + 1
	end

	local num_2 = 0

	for k_2, v_2 in pairs(arg_1_1) do
		if self[k_2] ~= v_2 then
			return false
		end

		num_2 = num_2 + 1
	end

	return num == num_2
end

local function fn_2(arg_2_0)
	-- function 2
	local tbl = {}
	local inventory_packages = NetworkLookup.inventory_packages

	for k, v in pairs(arg_2_0) do
		local var_2_2 = inventory_packages[k]

		assert(var_2_2, "No existing inventory package for attempted name %q", k)

		tbl[#tbl + 1] = var_2_2
	end

	return (cjson.encode(tbl))
end

local function fn_3(arg_3_0)
	-- function 3
	local decode = cjson.decode(arg_3_0)
	local tbl = {}
	local inventory_packages = NetworkLookup.inventory_packages

	for i, v in ipairs(decode) do
		tbl[inventory_packages[v]] = true
	end

	return tbl
end

local tbl = {
	server = {},
	peer = {
		preload_packages = {
			type = "table",
			default_value = {},
			composite_keys = {
				local_player_id = true
			},
			encode = fn_2,
			decode = fn_3
		}
	}
}

SharedState.validate_spec(tbl)

local str = "DeusChestPreloadSystem"
local num = 1
local num_2 = 50
local num_3 = 5
local tbl_2 = {}

DeusChestPreloadSystem.init = function (self, arg_4_1, arg_4_2, arg_4_3)
	-- function 4
	DeusChestPreloadSystem.super.init(self, arg_4_1, arg_4_2, arg_4_3)

	self._deus_chest_to_extension = {}
	self._broadphase = Broadphase(255, 30)
	self._broadphase_ids = {}
	self._loaded_or_loading_packages = {}
	self._player_manager = Managers.player
	self._package_manager = Managers.package

	local is_server = arg_4_1.is_server
	local network_handler = Managers.mechanism:network_handler()
	local server_peer_id = network_handler.server_peer_id
	local peer_id = Network.peer_id()

	self._shared_state = SharedState:new("deus_chest_preload", tbl, is_server, network_handler, server_peer_id, peer_id)

	local network_event_delegate = arg_4_1.network_event_delegate

	self._shared_state:register_rpcs(network_event_delegate)
	self:_setup_weapon_preload_settings()
end

DeusChestPreloadSystem._setup_weapon_preload_settings = function (self)
	-- function 5
	local flag = false
	local var_5_1
	local get_deus_weapon_preload_settings = Managers.backend:get_deus_weapon_preload_settings()

	if not IS_XB1 then
		local console_type_string = XboxOne.console_type_string()
		local var_5_4 = get_deus_weapon_preload_settings[console_type_string]
		local default = get_deus_weapon_preload_settings.default

		if not var_5_4 then
			print(string.format("[DeusChestPreloadSystem] Loading weapon preload settings for platform: %q", console_type_string))
			table.dump(var_5_4, "WEAPON_PRELOAD_SETTINGS", 2)

			self._deus_chest_preload_amount = var_5_4.deus_chest_preload_amount
			self._deus_chest_check_range = var_5_4.deus_chest_check_range
			self._deus_chest_update_frequency = var_5_4.deus_chest_update_frequency
			flag = true
		elseif not default then
			print(string.format("[DeusChestPreloadSystem] Failed getting weapon preload settings for platform: %q --> using default settings for %q", console_type_string, PLATFORM))
			table.dump(default, "WEAPON_PRELOAD_SETTINGS", 2)

			self._deus_chest_preload_amount = default.deus_chest_preload_amount
			self._deus_chest_check_range = default.deus_chest_check_range
			self._deus_chest_update_frequency = default.deus_chest_update_frequency
			flag = true
		end
	elseif not IS_PS4 then
		local str = "ps4"

		if not PS4.is_ps5() then
			str = "ps5"
		elseif not PS4.is_pro() then
			str = "ps4_pro"
		end

		local var_5_7 = get_deus_weapon_preload_settings[str]
		local default_2 = get_deus_weapon_preload_settings.default

		if not var_5_7 then
			print(string.format("[DeusChestPreloadSystem] Loading weapon preload settings for platform: %q", str))
			table.dump(var_5_7, "WEAPON_PRELOAD_SETTINGS", 2)

			self._deus_chest_preload_amount = var_5_7.deus_chest_preload_amount
			self._deus_chest_check_range = var_5_7.deus_chest_check_range
			self._deus_chest_update_frequency = var_5_7.deus_chest_update_frequency
			flag = true
		elseif not default_2 then
			print(string.format("[DeusChestPreloadSystem] Failed getting weapon preload settings for platform: %q --> using default settings for %q", str, PLATFORM))
			table.dump(default_2, "WEAPON_PRELOAD_SETTINGS", 2)

			self._deus_chest_preload_amount = default_2.deus_chest_preload_amount
			self._deus_chest_check_range = default_2.deus_chest_check_range
			self._deus_chest_update_frequency = default_2.deus_chest_update_frequency
			flag = true
		end
	elseif not get_deus_weapon_preload_settings then
		local default_3 = get_deus_weapon_preload_settings.default

		if not default_3 then
			print(string.format("[DeusChestPreloadSystem] Loading weapon preload settings for platform: %q", PLATFORM))
			table.dump(default_3, "WEAPON_PRELOAD_SETTINGS", 2)

			self._deus_chest_preload_amount = default_3.deus_chest_preload_amount
			self._deus_chest_check_range = default_3.deus_chest_check_range
			self._deus_chest_update_frequency = default_3.deus_chest_update_frequency
		end
	end

	if not flag then
		print(string.format("[DeusChestPreloadSystem] Couldn't find settings for platform: %q --> Using fallback settings", PLATFORM))

		self._deus_chest_preload_amount = num
		self._deus_chest_check_range = num_2
		self._deus_chest_update_frequency = num_3
	end

	fassert(self._deus_chest_preload_amount, "[DeusChestPreloadSystem] Missing weapon preload settings for chest_preload_amount")
	fassert(self._deus_chest_check_range, "[DeusChestPreloadSystem] Missing weapon preload settings for chest_range_check")
	fassert(self._deus_chest_update_frequency, "[DeusChestPreloadSystem] Missing weapon preload settings for chest_update_frequency")
end

DeusChestPreloadSystem.destroy = function (self)
	-- function 6
	self._shared_state:unregister_rpcs()

	local _loaded_or_loading_packages = self._loaded_or_loading_packages
	local _package_manager = self._package_manager

	for k, v in pairs(_loaded_or_loading_packages) do
		_package_manager:unload(k, str)
	end
end

local tbl_3 = {}
local tbl_4 = {}
local tbl_5 = {}

DeusChestPreloadSystem.update = function (self, arg_7_1, arg_7_2)
	-- function 7
	if self._deus_chest_preload_amount == 0 then
		return
	end

	local _timer = self._timer

	_timer = _timer or arg_7_2 + self._deus_chest_update_frequency
	self._timer = _timer

	if arg_7_2 <= self._timer then
		return
	end

	local local_player = Managers.player:local_player()
	local flag = not local_player and local_player.player_unit

	if not ALIVE[flag] then
		return
	end

	local get_player_preload_packages = self:get_player_preload_packages(local_player)

	if not get_player_preload_packages then
		return
	end

	DeusChestPreloadSystem.super.update(self, arg_7_1, arg_7_2)
	table.clear(tbl_4)

	local var_7_4 = POSITION_LOOKUP[flag]
	local query = Broadphase.query(self._broadphase, var_7_4, self._deus_chest_check_range, tbl_2)
	local min = math.min(query, self._deus_chest_preload_amount)
	local _deus_chest_to_extension = self._deus_chest_to_extension

	for i = 1, min do
		local get_weapon_preload_packages = _deus_chest_to_extension[tbl_2[i]]:get_weapon_preload_packages()

		for i_2, v in ipairs(get_weapon_preload_packages) do
			tbl_4[v] = true
		end
	end

	if not not fn(tbl_4, get_player_preload_packages) then
		self:set_player_preload_packages(local_player, tbl_4)
	end

	table.clear(tbl_4)
	table.clear(tbl_3)
	table.clear(tbl_5)

	local _package_manager = self._package_manager
	local human_players = self._player_manager:human_players()

	for k, v_2 in pairs(human_players) do
		local get_player_preload_packages_2 = self:get_player_preload_packages(v_2)

		for k_2, v_3 in pairs(get_player_preload_packages_2) do
			tbl_4[k_2] = true
		end

		for k_3, v_4 in pairs(get_player_preload_packages_2) do
			if not _package_manager:has_loaded(k_3, str) then
				tbl_3[k_3] = true
			end
		end
	end

	local _loaded_or_loading_packages = self._loaded_or_loading_packages

	for k_4, v_5 in pairs(tbl_3) do
		if not _package_manager:is_loading(k_4) then
			local flag_2 = true

			_loaded_or_loading_packages[k_4] = true

			_package_manager:load(k_4, str, nil, flag_2)
		end
	end

	for k_5, v_6 in pairs(_loaded_or_loading_packages) do
		tbl_5[k_5] = true
	end

	for k_6, v_7 in pairs(tbl_4) do
		tbl_5[k_6] = nil
	end

	for k_7, v_8 in pairs(tbl_5) do
		if not _package_manager:can_unload(k_7) then
			_package_manager:unload(k_7, str)

			_loaded_or_loading_packages[k_7] = nil
		end
	end

	self._timer = arg_7_2 + self._deus_chest_update_frequency
end

DeusChestPreloadSystem.on_add_extension = function (self, arg_8_1, arg_8_2, arg_8_3, arg_8_4, ...)
	-- function 8
	local on_add_extension = DeusChestPreloadSystem.super.on_add_extension(self, arg_8_1, arg_8_2, arg_8_3, arg_8_4)
	local var_8_1 = POSITION_LOOKUP[arg_8_2]
	local add = Broadphase.add(self._broadphase, arg_8_2, var_8_1, 0.1)

	self._broadphase_ids[arg_8_2] = add
	self._deus_chest_to_extension[arg_8_2] = on_add_extension

	return on_add_extension
end

DeusChestPreloadSystem.on_remove_extension = function (self, arg_9_1, arg_9_2, ...)
	-- function 9
	local _broadphase_ids = self._broadphase_ids
	local var_9_1 = _broadphase_ids[arg_9_1]

	Broadphase.remove(self._broadphase, var_9_1)

	_broadphase_ids[arg_9_1] = nil
	self._deus_chest_to_extension[arg_9_1] = nil

	return DeusChestPreloadSystem.super.on_remove_extension(self, arg_9_1, arg_9_2, ...)
end

DeusChestPreloadSystem.get_player_preload_packages = function (self, arg_10_1)
	-- function 10
	local peer_id = arg_10_1.peer_id
	local local_player_id = arg_10_1:local_player_id()

	if not peer_id and not local_player_id then
		local get_key = self._shared_state:get_key("preload_packages", nil, local_player_id)

		return self._shared_state:get_peer(peer_id, get_key)
	else
		return nil
	end
end

DeusChestPreloadSystem.set_player_preload_packages = function (self, arg_11_1, arg_11_2)
	-- function 11
	local peer_id = arg_11_1.peer_id
	local local_player_id = arg_11_1:local_player_id()
	local get_key = self._shared_state:get_key("preload_packages", nil, local_player_id)

	self._shared_state:set_peer(peer_id, get_key, table.clone(arg_11_2))
end
