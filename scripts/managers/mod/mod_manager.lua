-- chunkname: @scripts/managers/mod/mod_manager.lua

require("scripts/managers/mod/mod_shim")

ModManager = class(ModManager)

ModManager.init = function (self, arg_1_1)
	-- function 1
	self._mods = {}
	self._num_mods = nil
	self._state = "not_loaded"

	local user_setting = Application.user_setting("mod_settings")

	user_setting = user_setting or {
		toposort = false,
		log_level = 1,
		developer_mode = false
	}
	self._settings = user_setting
	self._chat_print_buffer = {}
	self._reload_data = {}
	self._gui = arg_1_1
	self._ui_time = 0
	self._network_callbacks = {}

	local print_property = Crashify.print_property
	local str = "realm"
	local flag

	flag = not MODDED_REALM and "modded" and "official"

	print_property(str, flag)

	if not rawget(_G, "Presence") then
		local set_presence = Presence.set_presence
		local str_2 = "status"
		local flag_2

		flag_2 = not MODDED_REALM and "Modded Realm" and "Official Realm"

		set_presence(str_2, flag_2)
	end

	self._mod_shim = ModShim:new()

	local _has_enabled_mods = self:_has_enabled_mods()
	local bundled = Application.bundled()

	printf("[ModManager] Mods enabled: %s // Bundled: %s", _has_enabled_mods, bundled)

	if not _has_enabled_mods and not bundled then
		print("[ModManager] Fetching mod metadata ...")

		if not MODDED_REALM then
			self._mod_metadata = {}
			self._state = "fetching_metadata"
		else
			self:_fetch_mod_metadata()
		end
	else
		self._state = "done"
		self._num_mods = 0
	end
end

ModManager.developer_mode_enabled = function (self)
	-- function 2
	return self._settings.developer_mode
end

ModManager._draw_state_to_gui = function (self, arg_3_1, arg_3_2)
	-- function 3
	local _state = self._state
	local num = self._ui_time + arg_3_2

	self._ui_time = num

	local str = "Loading mods"

	if _state == "scanning" then
		str = "Scanning for mods"
	elseif _state == "loading" then
		local var_3_3 = self._mods[self._mod_load_index]

		str = string.format("Loading mod %q", var_3_3.name)
	elseif _state == "fetching_metadata" then
		str = "Fetching mod metadata"
	end

	Gui.text(arg_3_1, str .. string.rep(".", 2 * num % 4), "materials/fonts/arial", 16, nil, Vector3(5, 10, 1))
end

ModManager.remove_gui = function (self)
	-- function 4
	assert(self._gui, "Trying to remove gui without setting gui first.")

	self._gui = nil
end

ModManager._has_enabled_mods = function (arg_5_0, arg_5_1)
	-- function 5
	local user_setting = Application.user_setting("mods")

	if not user_setting then
		return false
	end

	for i = 1, #user_setting do
		if not user_setting[i].enabled then
			return true
		end
	end

	return false
end

local Keyboard = Keyboard
local button_index = Keyboard.button_index("r")
local button_index_2 = Keyboard.button_index("left shift")
local button_index_3 = Keyboard.button_index("left ctrl")

ModManager._check_reload = function (arg_6_0)
	-- function 6
	local pressed = Keyboard.pressed(button_index)

	pressed = not pressed and Keyboard.button(button_index_2) + Keyboard.button(button_index_3) == 2

	return pressed
end

ModManager.update = function (self, arg_7_1)
	-- function 7
	local _chat_print_buffer = self._chat_print_buffer
	local count = #_chat_print_buffer

	if not (count > 0) or not Managers.chat then
		for i = 1, count do
			Managers.chat:add_local_system_message(1, _chat_print_buffer[i], true)

			_chat_print_buffer[i] = nil
		end
	end

	local _state = self._state

	if not self._settings.developer_mode and not self:_check_reload() then
		self._reload_requested = true
	end

	if not (not self._reload_requested and self._state ~= "done") then
		self:_reload_mods()
	end

	if self._state == "done" then
		for j = 1, self._num_mods do
			local var_7_3 = self._mods[j]

			if not (not var_7_3 and not var_7_3.enabled and var_7_3.callbacks_disabled) then
				self:_run_callback(var_7_3, "update", arg_7_1)
			end
		end
	elseif self._state == "fetching_metadata" then
		if not self._mod_metadata then
			self:_start_scan()
		end
	elseif not (self._state ~= "scanning" or Mod.is_scanning()) then
		local mods = Mod.mods()

		self:_build_mod_table(mods)

		self._state = self:_load_mod(1)
		self._ui_time = 0
	elseif self._state == "loading" then
		local _loading_resource_handle = self._loading_resource_handle

		if not ResourcePackage.has_loaded(_loading_resource_handle) then
			ResourcePackage.flush(_loading_resource_handle)

			local var_7_6 = self._mods[self._mod_load_index]
			local num = var_7_6.package_index + 1
			local data = var_7_6.data

			if num > #data.packages then
				var_7_6.state = "running"

				local var_7_9, var_7_10 = pcall(data.run)

				if not var_7_9 then
					self:print("error", "%s", var_7_10)
				end

				local name = var_7_6.name

				var_7_6.object = var_7_10 or {}

				self:_run_callback(var_7_6, "init", self._reload_data[var_7_6.id])

				if not self._mod_shim then
					self._mod_shim:mod_post_create(var_7_6)
				end

				self:print("info", "%s loaded.", name)

				self._state = self:_load_mod(self._mod_load_index + 1)
			else
				self:_load_package(var_7_6, num)
			end
		end
	end

	local _gui = self._gui

	if not _gui then
		self:_draw_state_to_gui(_gui, arg_7_1)
	end

	if _state ~= self._state then
		self:print("info", "%s -> %s", _state, self._state)
	end
end

ModManager.currently_loading_mod = function (self)
	-- function 8
	return self._mods[self._mod_load_index]
end

ModManager.all_mods_loaded = function (self)
	-- function 9
	return self._state == "done"
end

ModManager.destroy = function (self)
	-- function 10
	self:unload_all_mods()
end

ModManager._run_callback = function (self, arg_11_1, arg_11_2, ...)
	-- function 11
	local object = arg_11_1.object
	local var_11_1 = object[arg_11_2]

	if not var_11_1 then
		return
	end

	local var_11_2, var_11_3 = pcall(var_11_1, object, ...)

	if not var_11_2 then
		return var_11_3
	else
		self:print("error", "%s", var_11_3 or "[unknown error]")
		self:print("error", "Failed to run callback %q for mod %q with id %d. Disabling callbacks until reload.", arg_11_2, arg_11_1.name, arg_11_1.id)

		arg_11_1.callbacks_disabled = true
	end
end

ModManager._fetch_mod_metadata = function (self)
	-- function 12
	local str = "http://cdn.fatsharkgames.se/mod_metadata.txt"
	local tbl = {
		["User-Agent"] = "Warhammer: Vermintide 2"
	}

	Managers.curl:get(str, tbl, callback(self, "_cb_mod_metadata"))

	self._state = "fetching_metadata"
end

ModManager._cb_mod_metadata = function (self, arg_13_1, arg_13_2, arg_13_3, arg_13_4, arg_13_5)
	-- function 13
	printf("[ModManager] Metadata request completed. success=%s code=%s", arg_13_1, arg_13_2)

	local tbl = {}

	if not (not arg_13_1 and not (arg_13_2 >= 200) or not (arg_13_2 < 300)) then
		local num = 0

		for iter_13_0 in string.gmatch(arg_13_4, "[^\n\r]+") do
			num = num + 1
			iter_13_0 = string.gsub(iter_13_0, "#(.*)$", "")

			if iter_13_0 ~= "" then
				local match, var_13_3 = string.match(iter_13_0, "(%d+)%s*=%s*(%w+)")

				if not match then
					printf("[ModManager] Metadata set: [%s] = %s", match, var_13_3)

					tbl[match] = var_13_3
				else
					printf("[ModManager] Malformed metadata entry near line %d", num)
				end
			end
		end
	end

	self._mod_metadata = tbl
end

ModManager._start_scan = function (self)
	-- function 14
	self:print("info", "Starting mod scan")

	self._state = "scanning"

	Mod.start_scan(not MODDED_REALM)
end

ModManager._build_mod_table = function (self, arg_15_1)
	-- function 15
	fassert(table.is_empty(self._mods), "Trying to add mods to non-empty mod table")

	local user_setting = Application.user_setting("mods")

	user_setting = user_setting or {}

	if not self._settings.toposort then
		user_setting = self:_topologically_sorted(user_setting)
	end

	table.dump(arg_15_1, "mod_handles", 3)

	local _mod_metadata = self._mod_metadata

	print("[ModManager] user_setting.mods =:")

	for i, v in ipairs(user_setting) do
		local id = v.id

		id = id or -9999

		local var_15_3 = arg_15_1[id]
		local enabled = v.enabled

		if not var_15_3 then
			self:print("warning", "Mod %q with id %d was not found in the workshop folder.", v.name, id)
			self:print("warning", "Did you try loading an unsanctioned mod in Official?")

			enabled = false
		end

		local var_15_5 = _mod_metadata[id]
		local var_15_6
		local var_15_7

		if not enabled then
			local get_item_install_info

			get_item_install_info, var_15_7 = SteamUGC.get_item_install_info(id)

			if not var_15_5 then
				if not get_item_install_info then
					if var_15_5 > os.date("!%Y%m%dT%H%M%SZ", var_15_7) then
						enabled = false
					end
				else
					printf("[ModManager] Could not get item install info for item %q", id)

					enabled = false
				end
			end
		end

		self._mods[i] = {
			state = "not_loaded",
			callbacks_disabled = false,
			id = id,
			name = v.name,
			enabled = enabled,
			timestamp = var_15_7,
			handle = var_15_3,
			loaded_packages = {},
			last_updated = v.last_updated
		}
	end

	for i_2, v_2 in ipairs(user_setting) do
		printf("[ModManager] mods[%d] = (id=%d, name=%q, enabled=%q, last_updated=%q)", i_2, v_2.id, v_2.name, v_2.enabled, v_2.last_updated)
	end

	self._num_mods = #self._mods

	self:print("info", "Found %i mods", #self._mods)
end

ModManager._load_mod = function (self, arg_16_1)
	-- function 16
	self._ui_time = 0

	local _mods = self._mods
	local var_16_1 = _mods[arg_16_1]

	while not (not var_16_1 and var_16_1.enabled) do
		arg_16_1 = arg_16_1 + 1
		var_16_1 = _mods[arg_16_1]
	end

	if not var_16_1 then
		table.clear(self._reload_data)

		return "done"
	end

	local id = var_16_1.id
	local handle = var_16_1.handle

	self:print("info", "loading mod %s", id)

	local info = Mod.info(handle)

	self:print("spew", "<mod info>\n%s\n</mod info>", info)
	Crashify.print_property("modded", true)

	local var_16_5, var_16_6 = loadstring(info)

	if not var_16_5 then
		self:print("error", "Syntax error in .mod file. Mod %q with id %d skipped.", var_16_1.name, var_16_1.id)
		self:print("info", var_16_6)

		var_16_1.enabled = false

		return self:_load_mod(arg_16_1 + 1)
	end

	local var_16_7, var_16_8 = pcall(var_16_5)

	if not var_16_7 then
		self:print("error", "Error in .mod file return table. Mod %q with id %d skipped.", var_16_1.name, var_16_1.id)
		self:print("info", var_16_8)

		var_16_1.enabled = false

		return self:_load_mod(arg_16_1 + 1)
	end

	var_16_1.data = var_16_8

	local name = var_16_1.name

	if not name then
		name = var_16_8.NAME
		name = name or "Mod " .. id
	end

	var_16_1.name = name
	var_16_1.state = "loading"

	Crashify.print_property(string.format("Mod:%s:%s", id, var_16_1.name), true)

	self._mod_load_index = arg_16_1

	self:_load_package(var_16_1, 1)

	return "loading"
end

ModManager._load_package = function (self, arg_17_1, arg_17_2)
	-- function 17
	arg_17_1.package_index = arg_17_2

	local var_17_0 = arg_17_1.data.packages[arg_17_2]

	if not var_17_0 then
		return
	end

	self:print("info", "loading package %q", var_17_0)

	local resource_package = Mod.resource_package(arg_17_1.handle, var_17_0)

	self._loading_resource_handle = resource_package

	ResourcePackage.load(resource_package)

	arg_17_1.loaded_packages[#arg_17_1.loaded_packages + 1] = resource_package
end

ModManager.unload_all_mods = function (self)
	-- function 18
	if self._state ~= "done" then
		self:print("error", "Mods can't be unloaded, mod state is not \"done\". current: %q", self._state)

		return
	end

	self:print("info", "Unload all mod packages")

	for i = self._num_mods, 1, -1 do
		local var_18_0 = self._mods[i]

		if not var_18_0 and not var_18_0.enabled then
			self:unload_mod(i)
		end

		self._mods[i] = nil
	end

	self._num_mods = nil
	self._state = "unloaded"
end

ModManager.unload_mod = function (self, arg_19_1)
	-- function 19
	local var_19_0 = self._mods[arg_19_1]

	if not var_19_0 then
		self:print("info", "Unloading %q.", var_19_0.name)
		self:_run_callback(var_19_0, "on_unload")

		for i, v in ipairs(var_19_0.loaded_packages) do
			Mod.release_resource_package(v)
		end

		var_19_0.state = "not_loaded"
	else
		self:print("error", "Mod index %i can't be unloaded, has not been loaded", arg_19_1)
	end
end

ModManager._reload_mods = function (self)
	-- function 20
	self:print("info", "reloading mods")

	for i = 1, self._num_mods do
		local var_20_0 = self._mods[i]

		if not (not var_20_0 and var_20_0.state ~= "running") then
			self:print("info", "reloading %s", var_20_0.name)

			self._reload_data[var_20_0.id] = self:_run_callback(var_20_0, "on_reload")
		else
			self:print("info", "not reloading mod, state: %s", var_20_0.state)
		end
	end

	self:unload_all_mods()
	self:_start_scan()

	self._reload_requested = false
end

ModManager.on_game_state_changed = function (self, arg_21_1, arg_21_2, arg_21_3)
	-- function 21
	if self._state == "done" then
		for i = 1, self._num_mods do
			local var_21_0 = self._mods[i]

			if not (not var_21_0 and not var_21_0.enabled and var_21_0.callbacks_disabled) then
				self:_run_callback(var_21_0, "on_game_state_changed", arg_21_1, arg_21_2, arg_21_3)
			end
		end
	else
		self:print("warning", "Ignored on_game_state_changed call due to being in state %q", self._state)
	end
end

ModManager._topologically_sorted = function (self, arg_22_1)
	-- function 22
	local tbl = {}
	local tbl_2 = {}

	for i, v in ipairs(arg_22_1) do
		if not tbl[v] then
			self:_visit(arg_22_1, tbl, tbl_2, v)
		end
	end

	return tbl_2
end

ModManager._visit = function (self, arg_23_1, arg_23_2, arg_23_3, arg_23_4)
	-- function 23
	self:print("debug", "Visiting mod %q with id %d", arg_23_4.name, arg_23_4.id)

	if not arg_23_2[arg_23_4] then
		return arg_23_4.enabled
	end

	if arg_23_2[arg_23_4] ~= nil then
		self:print("error", "Dependency cycle detected at mod %q with id %d", arg_23_4.name, arg_23_4.id)

		return false
	end

	arg_23_2[arg_23_4] = false

	local enabled = arg_23_4.enabled

	enabled = enabled or false

	local num = 1
	local num_children = arg_23_4.num_children

	num_children = num_children or 0

	for i = num, num_children do
		local var_23_3 = arg_23_4.children[j]
		local var_23_4 = arg_23_1[table.find_by_key(arg_23_1, "id", var_23_3)]

		if not var_23_4 then
			self:print("warning", "Mod with id %d not found", id)
		elseif self:_visit(arg_23_1, arg_23_2, arg_23_3, var_23_4) or not enabled then
			self:print("warning", "Disabled mod %q with id %d due to missing dependency %d.", arg_23_4.name, arg_23_4.id, var_23_3)

			enabled = false
		end
	end

	arg_23_4.enabled = enabled
	arg_23_2[arg_23_4] = true
	arg_23_3[#arg_23_3 + 1] = arg_23_4

	return enabled
end

local tbl = {
	spew = 4,
	info = 3,
	warning = 2,
	error = 1
}

ModManager.print = function (self, arg_24_1, arg_24_2, ...)
	-- function 24
	local format = string.format("[ModManager][" .. arg_24_1 .. "] " .. arg_24_2, ...)
	local var_24_1 = tbl[arg_24_1]

	var_24_1 = var_24_1 or 99

	if var_24_1 <= 2 then
		print(format)
	end

	if var_24_1 <= self._settings.log_level then
		self._chat_print_buffer[#self._chat_print_buffer + 1] = format
	end
end

ModManager.network_bind = function (self, arg_25_1, arg_25_2)
	-- function 25
	local _network_callbacks = self._network_callbacks

	fassert(not _network_callbacks[arg_25_1], "Port %d already in use", arg_25_1)

	_network_callbacks[arg_25_1] = arg_25_2
end

ModManager.network_unbind = function (self, arg_26_1)
	-- function 26
	local _network_callbacks = self._network_callbacks

	fassert(_network_callbacks[arg_26_1], "Port %d not in use", arg_26_1)

	_network_callbacks[arg_26_1] = nil
end

ModManager.network_is_occupied = function (self, arg_27_1)
	-- function 27
	return self._network_callbacks[arg_27_1] ~= nil
end

ModManager.network_send = function (self, arg_28_1, arg_28_2, arg_28_3)
	-- function 28
	if arg_28_1 == self._my_peer_id then
		Managers.state.network.network_transmit:queue_local_rpc("rpc_mod_user_data", arg_28_2, arg_28_3)
	end

	local var_28_0 = PEER_ID_TO_CHANNEL[not self._is_server and arg_28_1 and self._host_peer_id]

	if not var_28_0 then
		RPC.rpc_mod_user_data(var_28_0, self._my_peer_id, arg_28_1, arg_28_2, arg_28_3)
	end
end

ModManager.rpc_mod_user_data = function (self, arg_29_1, arg_29_2, arg_29_3, arg_29_4, arg_29_5)
	-- function 29
	if arg_29_3 == self._my_peer_id then
		local var_29_0 = self._network_callbacks[arg_29_4]

		if not var_29_0 then
			var_29_0(arg_29_2, arg_29_5)
		end
	elseif not self._is_server then
		local var_29_1 = PEER_ID_TO_CHANNEL[arg_29_3]

		if not var_29_1 then
			RPC.rpc_mod_user_data(var_29_1, arg_29_2, arg_29_3, arg_29_4, arg_29_5)
		end
	end
end

ModManager.register_network_event_delegate = function (self, arg_30_1)
	-- function 30
	arg_30_1:register(self, "rpc_mod_user_data")

	self._network_event_delegate = arg_30_1
end

ModManager.unregister_network_event_delegate = function (self)
	-- function 31
	self._network_event_delegate:unregister(self)

	self._network_event_delegate = nil
end

ModManager.network_context_created = function (self, arg_32_1, arg_32_2, arg_32_3)
	-- function 32
	self._host_peer_id = arg_32_1
	self._my_peer_id = arg_32_2
	self._is_server = arg_32_3
end
