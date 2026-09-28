-- chunkname: @scripts/managers/mod/mod_manager.lua

require("scripts/managers/mod/mod_shim")

ModManager = class(ModManager)

ModManager.init = function (self, boot_gui)
	-- function 1
	self._mods = {}
	self._num_mods = nil
	self._state = "not_loaded"

	local user_setting = Application.user_setting("mod_settings")

	user_setting = not not user_setting or not not {
		toposort = false,
		log_level = 1,
		developer_mode = false
	}
	self._settings = user_setting
	self._chat_print_buffer = {}
	self._reload_data = {}
	self._gui = boot_gui
	self._ui_time = 0
	self._network_callbacks = {}

	local print_property = Crashify.print_property
	local str = "realm"
	local flag

	flag = (not MODDED_REALM or not "modded") and not not "official"

	print_property(str, flag)

	if rawget(_G, "Presence") then
		local set_presence = Presence.set_presence
		local str_2 = "status"
		local flag_2

		flag_2 = (not MODDED_REALM or not "Modded Realm") and not not "Official Realm"

		set_presence(str_2, flag_2)
	end

	self._mod_shim = ModShim:new()

	local has_enabled_mods = self:_has_enabled_mods()
	local is_bundled = Application.bundled()

	printf("[ModManager] Mods enabled: %s // Bundled: %s", has_enabled_mods, is_bundled)

	if has_enabled_mods and is_bundled then
		print("[ModManager] Fetching mod metadata ...")

		if MODDED_REALM then
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

ModManager._draw_state_to_gui = function (self, gui, dt)
	-- function 3
	local state = self._state
	local t = self._ui_time + dt

	self._ui_time = t

	local status_str = "Loading mods"

	if state == "scanning" then
		status_str = "Scanning for mods"
	elseif state == "loading" then
		local mod = self._mods[self._mod_load_index]

		status_str = string.format("Loading mod %q", mod.name)
	elseif state == "fetching_metadata" then
		status_str = "Fetching mod metadata"
	end

	Gui.text(gui, status_str .. string.rep(".", 2 * t % 4), "materials/fonts/arial", 16, nil, Vector3(5, 10, 1))
end

ModManager.remove_gui = function (self)
	-- function 4
	assert(self._gui, "Trying to remove gui without setting gui first.")

	self._gui = nil
end

ModManager._has_enabled_mods = function (self, in_modded_realm)
	-- function 5
	local mod_settings = Application.user_setting("mods")

	if not mod_settings then
		return false
	end

	for i = 1, #mod_settings do
		if mod_settings[i].enabled then
			return true
		end
	end

	return false
end

local Keyboard = Keyboard
local BUTTON_INDEX_R = Keyboard.button_index("r")
local BUTTON_INDEX_LEFT_SHIFT = Keyboard.button_index("left shift")
local BUTTON_INDEX_LEFT_CTRL = Keyboard.button_index("left ctrl")

ModManager._check_reload = function (self)
	-- function 6
	local pressed = Keyboard.pressed(BUTTON_INDEX_R)

	pressed = not not pressed and Keyboard.button(BUTTON_INDEX_LEFT_SHIFT) + Keyboard.button(BUTTON_INDEX_LEFT_CTRL) == 2

	return pressed
end

ModManager.update = function (self, dt)
	-- function 7
	local chat_print_buffer = self._chat_print_buffer
	local num_delayed_prints = #chat_print_buffer

	if num_delayed_prints > 0 and Managers.chat then
		for i = 1, num_delayed_prints do
			Managers.chat:add_local_system_message(1, chat_print_buffer[i], true)

			chat_print_buffer[i] = nil
		end
	end

	local old_state = self._state

	if self._settings.developer_mode and self:_check_reload() then
		self._reload_requested = true
	end

	if self._reload_requested and self._state == "done" then
		self:_reload_mods()
	end

	if self._state == "done" then
		for i = 1, self._num_mods do
			local mod = self._mods[i]

			if mod and mod.enabled and not mod.callbacks_disabled then
				self:_run_callback(mod, "update", dt)
			end
		end
	elseif self._state == "fetching_metadata" then
		if self._mod_metadata then
			self:_start_scan()
		end
	elseif self._state == "scanning" and not Mod.is_scanning() then
		local mod_handles = Mod.mods()

		self:_build_mod_table(mod_handles)

		self._state = self:_load_mod(1)
		self._ui_time = 0
	elseif self._state == "loading" then
		local handle = self._loading_resource_handle

		if ResourcePackage.has_loaded(handle) then
			ResourcePackage.flush(handle)

			local mod = self._mods[self._mod_load_index]
			local next_index = mod.package_index + 1
			local mod_data = mod.data

			if next_index > #mod_data.packages then
				mod.state = "running"

				local ok, object = pcall(mod_data.run)

				if not ok then
					self:print("error", "%s", object)
				end

				local name = mod.name

				mod.object = not not object or not not {}

				self:_run_callback(mod, "init", self._reload_data[mod.id])

				if self._mod_shim then
					self._mod_shim:mod_post_create(mod)
				end

				self:print("info", "%s loaded.", name)

				self._state = self:_load_mod(self._mod_load_index + 1)
			else
				self:_load_package(mod, next_index)
			end
		end
	end

	local gui = self._gui

	if gui then
		self:_draw_state_to_gui(gui, dt)
	end

	if old_state ~= self._state then
		self:print("info", "%s -> %s", old_state, self._state)
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

ModManager._run_callback = function (self, mod, callback_name, ...)
	-- function 11
	local object = mod.object
	local cb = object[callback_name]

	if not cb then
		return
	end

	local success, val = pcall(cb, object, ...)

	if success then
		return val
	else
		self:print("error", "%s", not not val or not not "[unknown error]")
		self:print("error", "Failed to run callback %q for mod %q with id %d. Disabling callbacks until reload.", callback_name, mod.name, mod.id)

		mod.callbacks_disabled = true
	end
end

ModManager._fetch_mod_metadata = function (self)
	-- function 12
	local url = "http://cdn.fatsharkgames.se/mod_metadata.txt"
	local headers = {
		["User-Agent"] = "Warhammer: Vermintide 2"
	}

	Managers.curl:get(url, headers, callback(self, "_cb_mod_metadata"))

	self._state = "fetching_metadata"
end

ModManager._cb_mod_metadata = function (self, success, return_code, headers, data, userdata)
	-- function 13
	printf("[ModManager] Metadata request completed. success=%s code=%s", success, return_code)

	local mod_metadata = {}

	if success and return_code >= 200 and return_code < 300 then
		local line_number = 0

		for line in string.gmatch(data, "[^\n\r]+") do
			line_number = line_number + 1
			line = string.gsub(line, "#(.*)$", "")

			if line ~= "" then
				local key, value = string.match(line, "(%d+)%s*=%s*(%w+)")

				if key then
					printf("[ModManager] Metadata set: [%s] = %s", key, value)

					mod_metadata[key] = value
				else
					printf("[ModManager] Malformed metadata entry near line %d", line_number)
				end
			end
		end
	end

	self._mod_metadata = mod_metadata
end

ModManager._start_scan = function (self)
	-- function 14
	self:print("info", "Starting mod scan")

	self._state = "scanning"

	Mod.start_scan(not MODDED_REALM)
end

ModManager._build_mod_table = function (self, mod_handles)
	-- function 15
	fassert(table.is_empty(self._mods), "Trying to add mods to non-empty mod table")

	local user_setting = Application.user_setting("mods")

	if not user_setting then
		-- Nothing
	end

	user_setting = {}

	local user_settings_mod_list = user_setting

	::label_15_0::

	if self._settings.toposort then
		user_settings_mod_list = self:_topologically_sorted(user_settings_mod_list)
	end

	table.dump(mod_handles, "mod_handles", 3)

	local mod_metadata = self._mod_metadata

	print("[ModManager] user_setting.mods =:")

	for i, mod_data in ipairs(user_settings_mod_list) do
		local id_2 = mod_data.id

		if not id_2 then
			-- Nothing
		end

		id_2 = -9999

		local id = id_2

		::label_15_1::

		local handle = mod_handles[id]
		local enabled = mod_data.enabled

		if not handle then
			self:print("warning", "Mod %q with id %d was not found in the workshop folder.", mod_data.name, id)
			self:print("warning", "Did you try loading an unsanctioned mod in Official?")

			enabled = false
		end

		local metadata = mod_metadata[id]
		local ok, timestamp

		if enabled then
			ok, timestamp = SteamUGC.get_item_install_info(id)

			if metadata then
				if ok then
					local iso8601 = os.date("!%Y%m%dT%H%M%SZ", timestamp)

					if iso8601 < metadata then
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
			name = mod_data.name,
			enabled = enabled,
			timestamp = timestamp,
			handle = handle,
			loaded_packages = {},
			last_updated = mod_data.last_updated
		}
	end

	for i, mod_data in ipairs(user_settings_mod_list) do
		printf("[ModManager] mods[%d] = (id=%d, name=%q, enabled=%q, last_updated=%q)", i, mod_data.id, mod_data.name, mod_data.enabled, mod_data.last_updated)
	end

	self._num_mods = #self._mods

	self:print("info", "Found %i mods", #self._mods)
end

ModManager._load_mod = function (self, index)
	-- function 16
	self._ui_time = 0

	local mods = self._mods
	local mod = mods[index]

	while mod and not mod.enabled do
		index = index + 1
		mod = mods[index]
	end

	if not mod then
		table.clear(self._reload_data)

		return "done"
	end

	local id = mod.id
	local handle = mod.handle

	self:print("info", "loading mod %s", id)

	local info = Mod.info(handle)

	self:print("spew", "<mod info>\n%s\n</mod info>", info)
	Crashify.print_property("modded", true)

	local chunk, err_msg = loadstring(info)

	if not chunk then
		self:print("error", "Syntax error in .mod file. Mod %q with id %d skipped.", mod.name, mod.id)
		self:print("info", err_msg)

		mod.enabled = false

		return self:_load_mod(index + 1)
	end

	local ok, data_or_error = pcall(chunk)

	if not ok then
		self:print("error", "Error in .mod file return table. Mod %q with id %d skipped.", mod.name, mod.id)
		self:print("info", data_or_error)

		mod.enabled = false

		return self:_load_mod(index + 1)
	end

	mod.data = data_or_error

	local name = mod.name

	if not name then
		name = data_or_error.NAME
		name = not not name or not not ("Mod " .. id)
	end

	mod.name = name
	mod.state = "loading"

	Crashify.print_property(string.format("Mod:%s:%s", id, mod.name), true)

	self._mod_load_index = index

	self:_load_package(mod, 1)

	return "loading"
end

ModManager._load_package = function (self, mod, index)
	-- function 17
	mod.package_index = index

	local package_name = mod.data.packages[index]

	if not package_name then
		return
	end

	self:print("info", "loading package %q", package_name)

	local resource_handle = Mod.resource_package(mod.handle, package_name)

	self._loading_resource_handle = resource_handle

	ResourcePackage.load(resource_handle)

	mod.loaded_packages[#mod.loaded_packages + 1] = resource_handle
end

ModManager.unload_all_mods = function (self)
	-- function 18
	if self._state ~= "done" then
		self:print("error", "Mods can't be unloaded, mod state is not \"done\". current: %q", self._state)

		return
	end

	self:print("info", "Unload all mod packages")

	for i = self._num_mods, 1, -1 do
		local mod = self._mods[i]

		if mod and mod.enabled then
			self:unload_mod(i)
		end

		self._mods[i] = nil
	end

	self._num_mods = nil
	self._state = "unloaded"
end

ModManager.unload_mod = function (self, index)
	-- function 19
	local mod = self._mods[index]

	if mod then
		self:print("info", "Unloading %q.", mod.name)
		self:_run_callback(mod, "on_unload")

		for _, handle in ipairs(mod.loaded_packages) do
			Mod.release_resource_package(handle)
		end

		mod.state = "not_loaded"
	else
		self:print("error", "Mod index %i can't be unloaded, has not been loaded", index)
	end
end

ModManager._reload_mods = function (self)
	-- function 20
	self:print("info", "reloading mods")

	for i = 1, self._num_mods do
		local mod = self._mods[i]

		if mod and mod.state == "running" then
			self:print("info", "reloading %s", mod.name)

			self._reload_data[mod.id] = self:_run_callback(mod, "on_reload")
		else
			self:print("info", "not reloading mod, state: %s", mod.state)
		end
	end

	self:unload_all_mods()
	self:_start_scan()

	self._reload_requested = false
end

ModManager.on_game_state_changed = function (self, status, state_name, state_object)
	-- function 21
	if self._state == "done" then
		for i = 1, self._num_mods do
			local mod = self._mods[i]

			if mod and mod.enabled and not mod.callbacks_disabled then
				self:_run_callback(mod, "on_game_state_changed", status, state_name, state_object)
			end
		end
	else
		self:print("warning", "Ignored on_game_state_changed call due to being in state %q", self._state)
	end
end

ModManager._topologically_sorted = function (self, mod_list)
	-- function 22
	local visited, sorted = {}, {}

	for _, mod_data in ipairs(mod_list) do
		if not visited[mod_data] then
			self:_visit(mod_list, visited, sorted, mod_data)
		end
	end

	return sorted
end

ModManager._visit = function (self, mod_list, visited, sorted, mod_data)
	-- function 23
	self:print("debug", "Visiting mod %q with id %d", mod_data.name, mod_data.id)

	if visited[mod_data] then
		return mod_data.enabled
	end

	if visited[mod_data] ~= nil then
		self:print("error", "Dependency cycle detected at mod %q with id %d", mod_data.name, mod_data.id)

		return false
	end

	visited[mod_data] = false

	local enabled_2 = mod_data.enabled

	if not enabled_2 then
		-- Nothing
	end

	enabled_2 = false

	local enabled = enabled_2

	::label_23_0::

	local num = 1
	local num_children = mod_data.num_children

	num_children = not not num_children or not not 0

	for i = num, num_children do
		local child_id = mod_data.children[j]
		local child_index = table.find_by_key(mod_list, "id", child_id)
		local child_mod_data = mod_list[child_index]

		if not child_mod_data then
			self:print("warning", "Mod with id %d not found", id)
		elseif not self:_visit(mod_list, visited, sorted, child_mod_data) and enabled then
			self:print("warning", "Disabled mod %q with id %d due to missing dependency %d.", mod_data.name, mod_data.id, child_id)

			enabled = false
		end
	end

	mod_data.enabled = enabled
	visited[mod_data] = true
	sorted[#sorted + 1] = mod_data

	return enabled
end

local LOG_LEVELS = {
	spew = 4,
	info = 3,
	warning = 2,
	error = 1
}

ModManager.print = function (self, level, str, ...)
	-- function 24
	local message = string.format("[ModManager][" .. level .. "] " .. str, ...)
	local var_24_0 = LOG_LEVELS[level]

	if not var_24_0 then
		-- Nothing
	end

	var_24_0 = 99

	local log_level = var_24_0

	::label_24_0::

	if log_level <= 2 then
		print(message)
	end

	if log_level <= self._settings.log_level then
		self._chat_print_buffer[#self._chat_print_buffer + 1] = message
	end
end

ModManager.network_bind = function (self, port, callback)
	-- function 25
	local ncbs = self._network_callbacks

	fassert(not ncbs[port], "Port %d already in use", port)

	ncbs[port] = callback
end

ModManager.network_unbind = function (self, port)
	-- function 26
	local ncbs = self._network_callbacks

	fassert(ncbs[port], "Port %d not in use", port)

	ncbs[port] = nil
end

ModManager.network_is_occupied = function (self, port)
	-- function 27
	return self._network_callbacks[port] ~= nil
end

ModManager.network_send = function (self, destination_peer_id, port, payload)
	-- function 28
	if destination_peer_id == self._my_peer_id then
		Managers.state.network.network_transmit:queue_local_rpc("rpc_mod_user_data", port, payload)
	end

	local channel_id = PEER_ID_TO_CHANNEL[(not self._is_server or not destination_peer_id) and not not self._host_peer_id]

	if channel_id then
		RPC.rpc_mod_user_data(channel_id, self._my_peer_id, destination_peer_id, port, payload)
	end
end

ModManager.rpc_mod_user_data = function (self, relay_channel_id, source_peer_id, destination_peer_id, port, payload)
	-- function 29
	if destination_peer_id == self._my_peer_id then
		local cb = self._network_callbacks[port]

		if cb then
			cb(source_peer_id, payload)
		end
	elseif self._is_server then
		local channel_id = PEER_ID_TO_CHANNEL[destination_peer_id]

		if channel_id then
			RPC.rpc_mod_user_data(channel_id, source_peer_id, destination_peer_id, port, payload)
		end
	end
end

ModManager.register_network_event_delegate = function (self, network_event_delegate)
	-- function 30
	network_event_delegate:register(self, "rpc_mod_user_data")

	self._network_event_delegate = network_event_delegate
end

ModManager.unregister_network_event_delegate = function (self)
	-- function 31
	self._network_event_delegate:unregister(self)

	self._network_event_delegate = nil
end

ModManager.network_context_created = function (self, host_peer_id, my_peer_id, is_server)
	-- function 32
	self._host_peer_id = host_peer_id
	self._my_peer_id = my_peer_id
	self._is_server = is_server
end
