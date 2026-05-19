-- chunkname: @scripts/managers/mod/mod_manager.lua

require("scripts/managers/mod/mod_shim")

ModManager = class(ModManager)

function ModManager.init(arg_1_0, arg_1_1)
	arg_1_0._mods = {}
	arg_1_0._num_mods = nil
	arg_1_0._state = "not_loaded"
	arg_1_0._settings = Application.user_setting("mod_settings") or {
		toposort = false,
		log_level = 1,
		developer_mode = false
	}
	arg_1_0._chat_print_buffer = {}
	arg_1_0._reload_data = {}
	arg_1_0._gui = arg_1_1
	arg_1_0._ui_time = 0
	arg_1_0._network_callbacks = {}

	local var_1_0 = script_data["eac-untrusted"]

	Crashify.print_property("realm", var_1_0 and "modded" or "official")

	if rawget(_G, "Presence") then
		Presence.set_presence("status", var_1_0 and "Modded Realm" or "Official Realm")
	end

	arg_1_0._mod_shim = ModShim:new()

	local var_1_1 = arg_1_0:_has_enabled_mods()
	local var_1_2 = Application.bundled()

	printf("[ModManager] Mods enabled: %s // Bundled: %s", var_1_1, var_1_2)

	if var_1_1 and var_1_2 then
		print("[ModManager] Fetching mod metadata ...")

		if var_1_0 then
			arg_1_0._mod_metadata = {}
			arg_1_0._state = "fetching_metadata"
		else
			arg_1_0:_fetch_mod_metadata()
		end
	else
		arg_1_0._state = "done"
		arg_1_0._num_mods = 0
	end
end

function ModManager.developer_mode_enabled(arg_2_0)
	return arg_2_0._settings.developer_mode
end

function ModManager._draw_state_to_gui(arg_3_0, arg_3_1, arg_3_2)
	local var_3_0 = arg_3_0._state
	local var_3_1 = arg_3_0._ui_time + arg_3_2

	arg_3_0._ui_time = var_3_1

	local var_3_2 = "Loading mods"

	if var_3_0 == "scanning" then
		var_3_2 = "Scanning for mods"
	elseif var_3_0 == "loading" then
		local var_3_3 = arg_3_0._mods[arg_3_0._mod_load_index]

		var_3_2 = string.format("Loading mod %q", var_3_3.name)
	elseif var_3_0 == "fetching_metadata" then
		var_3_2 = "Fetching mod metadata"
	end

	Gui.text(arg_3_1, var_3_2 .. string.rep(".", 2 * var_3_1 % 4), "materials/fonts/arial", 16, nil, Vector3(5, 10, 1))
end

function ModManager.remove_gui(arg_4_0)
	assert(arg_4_0._gui, "Trying to remove gui without setting gui first.")

	arg_4_0._gui = nil
end

function ModManager._has_enabled_mods(arg_5_0, arg_5_1)
	local var_5_0 = Application.user_setting("mods")

	if not var_5_0 then
		return false
	end

	for iter_5_0 = 1, #var_5_0 do
		if var_5_0[iter_5_0].enabled then
			return true
		end
	end

	return false
end

local var_0_0 = Keyboard
local var_0_1 = var_0_0.button_index("r")
local var_0_2 = var_0_0.button_index("left shift")
local var_0_3 = var_0_0.button_index("left ctrl")

function ModManager._check_reload(arg_6_0)
	return var_0_0.pressed(var_0_1) and var_0_0.button(var_0_2) + var_0_0.button(var_0_3) == 2
end

function ModManager.update(arg_7_0, arg_7_1)
	local var_7_0 = arg_7_0._chat_print_buffer
	local var_7_1 = #var_7_0

	if var_7_1 > 0 and Managers.chat then
		for iter_7_0 = 1, var_7_1 do
			Managers.chat:add_local_system_message(1, var_7_0[iter_7_0], true)

			var_7_0[iter_7_0] = nil
		end
	end

	local var_7_2 = arg_7_0._state

	if arg_7_0._settings.developer_mode and arg_7_0:_check_reload() then
		arg_7_0._reload_requested = true
	end

	if arg_7_0._reload_requested and arg_7_0._state == "done" then
		arg_7_0:_reload_mods()
	end

	if arg_7_0._state == "done" then
		for iter_7_1 = 1, arg_7_0._num_mods do
			local var_7_3 = arg_7_0._mods[iter_7_1]

			if var_7_3 and var_7_3.enabled and not var_7_3.callbacks_disabled then
				arg_7_0:_run_callback(var_7_3, "update", arg_7_1)
			end
		end
	elseif arg_7_0._state == "fetching_metadata" then
		if arg_7_0._mod_metadata then
			arg_7_0:_start_scan()
		end
	elseif arg_7_0._state == "scanning" and not Mod.is_scanning() then
		local var_7_4 = Mod.mods()

		arg_7_0:_build_mod_table(var_7_4)

		arg_7_0._state = arg_7_0:_load_mod(1)
		arg_7_0._ui_time = 0
	elseif arg_7_0._state == "loading" then
		local var_7_5 = arg_7_0._loading_resource_handle

		if ResourcePackage.has_loaded(var_7_5) then
			ResourcePackage.flush(var_7_5)

			local var_7_6 = arg_7_0._mods[arg_7_0._mod_load_index]
			local var_7_7 = var_7_6.package_index + 1
			local var_7_8 = var_7_6.data

			if var_7_7 > #var_7_8.packages then
				var_7_6.state = "running"

				local var_7_9, var_7_10 = pcall(var_7_8.run)

				if not var_7_9 then
					arg_7_0:print("error", "%s", var_7_10)
				end

				local var_7_11 = var_7_6.name

				var_7_6.object = var_7_10 or {}

				arg_7_0:_run_callback(var_7_6, "init", arg_7_0._reload_data[var_7_6.id])

				if arg_7_0._mod_shim then
					arg_7_0._mod_shim:mod_post_create(var_7_6)
				end

				arg_7_0:print("info", "%s loaded.", var_7_11)

				arg_7_0._state = arg_7_0:_load_mod(arg_7_0._mod_load_index + 1)
			else
				arg_7_0:_load_package(var_7_6, var_7_7)
			end
		end
	end

	local var_7_12 = arg_7_0._gui

	if var_7_12 then
		arg_7_0:_draw_state_to_gui(var_7_12, arg_7_1)
	end

	if var_7_2 ~= arg_7_0._state then
		arg_7_0:print("info", "%s -> %s", var_7_2, arg_7_0._state)
	end
end

function ModManager.currently_loading_mod(arg_8_0)
	return arg_8_0._mods[arg_8_0._mod_load_index]
end

function ModManager.all_mods_loaded(arg_9_0)
	return arg_9_0._state == "done"
end

function ModManager.destroy(arg_10_0)
	arg_10_0:unload_all_mods()
end

function ModManager._run_callback(arg_11_0, arg_11_1, arg_11_2, ...)
	local var_11_0 = arg_11_1.object
	local var_11_1 = var_11_0[arg_11_2]

	if not var_11_1 then
		return
	end

	local var_11_2, var_11_3 = pcall(var_11_1, var_11_0, ...)

	if var_11_2 then
		return var_11_3
	else
		arg_11_0:print("error", "%s", var_11_3 or "[unknown error]")
		arg_11_0:print("error", "Failed to run callback %q for mod %q with id %d. Disabling callbacks until reload.", arg_11_2, arg_11_1.name, arg_11_1.id)

		arg_11_1.callbacks_disabled = true
	end
end

function ModManager._fetch_mod_metadata(arg_12_0)
	local var_12_0 = "http://cdn.fatsharkgames.se/mod_metadata.txt"
	local var_12_1 = {
		["User-Agent"] = "Warhammer: Vermintide 2"
	}

	Managers.curl:get(var_12_0, var_12_1, callback(arg_12_0, "_cb_mod_metadata"))

	arg_12_0._state = "fetching_metadata"
end

function ModManager._cb_mod_metadata(arg_13_0, arg_13_1, arg_13_2, arg_13_3, arg_13_4, arg_13_5)
	printf("[ModManager] Metadata request completed. success=%s code=%s", arg_13_1, arg_13_2)

	local var_13_0 = {}

	if arg_13_1 and arg_13_2 >= 200 and arg_13_2 < 300 then
		local var_13_1 = 0

		for iter_13_0 in string.gmatch(arg_13_4, "[^\n\r]+") do
			var_13_1 = var_13_1 + 1
			iter_13_0 = string.gsub(iter_13_0, "#(.*)$", "")

			if iter_13_0 ~= "" then
				local var_13_2, var_13_3 = string.match(iter_13_0, "(%d+)%s*=%s*(%w+)")

				if var_13_2 then
					printf("[ModManager] Metadata set: [%s] = %s", var_13_2, var_13_3)

					var_13_0[var_13_2] = var_13_3
				else
					printf("[ModManager] Malformed metadata entry near line %d", var_13_1)
				end
			end
		end
	end

	arg_13_0._mod_metadata = var_13_0
end

function ModManager._start_scan(arg_14_0)
	arg_14_0:print("info", "Starting mod scan")

	arg_14_0._state = "scanning"

	Mod.start_scan(not script_data["eac-untrusted"])
end

function ModManager._build_mod_table(arg_15_0, arg_15_1)
	fassert(table.is_empty(arg_15_0._mods), "Trying to add mods to non-empty mod table")

	local var_15_0 = Application.user_setting("mods") or {}

	if arg_15_0._settings.toposort then
		var_15_0 = arg_15_0:_topologically_sorted(var_15_0)
	end

	table.dump(arg_15_1, "mod_handles", 3)

	local var_15_1 = arg_15_0._mod_metadata

	print("[ModManager] user_setting.mods =:")

	for iter_15_0, iter_15_1 in ipairs(var_15_0) do
		local var_15_2 = iter_15_1.id or -9999
		local var_15_3 = arg_15_1[var_15_2]
		local var_15_4 = iter_15_1.enabled

		if not var_15_3 then
			arg_15_0:print("warning", "Mod %q with id %d was not found in the workshop folder.", iter_15_1.name, var_15_2)
			arg_15_0:print("warning", "Did you try loading an unsanctioned mod in Official?")

			var_15_4 = false
		end

		local var_15_5 = var_15_1[var_15_2]
		local var_15_6
		local var_15_7

		if var_15_4 then
			local var_15_8

			var_15_8, var_15_7 = SteamUGC.get_item_install_info(var_15_2)

			if var_15_5 then
				if var_15_8 then
					if var_15_5 > os.date("!%Y%m%dT%H%M%SZ", var_15_7) then
						var_15_4 = false
					end
				else
					printf("[ModManager] Could not get item install info for item %q", var_15_2)

					var_15_4 = false
				end
			end
		end

		arg_15_0._mods[iter_15_0] = {
			state = "not_loaded",
			callbacks_disabled = false,
			id = var_15_2,
			name = iter_15_1.name,
			enabled = var_15_4,
			timestamp = var_15_7,
			handle = var_15_3,
			loaded_packages = {},
			last_updated = iter_15_1.last_updated
		}
	end

	for iter_15_2, iter_15_3 in ipairs(var_15_0) do
		printf("[ModManager] mods[%d] = (id=%d, name=%q, enabled=%q, last_updated=%q)", iter_15_2, iter_15_3.id, iter_15_3.name, iter_15_3.enabled, iter_15_3.last_updated)
	end

	arg_15_0._num_mods = #arg_15_0._mods

	arg_15_0:print("info", "Found %i mods", #arg_15_0._mods)
end

function ModManager._load_mod(arg_16_0, arg_16_1)
	arg_16_0._ui_time = 0

	local var_16_0 = arg_16_0._mods
	local var_16_1 = var_16_0[arg_16_1]

	while var_16_1 and not var_16_1.enabled do
		arg_16_1 = arg_16_1 + 1
		var_16_1 = var_16_0[arg_16_1]
	end

	if not var_16_1 then
		table.clear(arg_16_0._reload_data)

		return "done"
	end

	local var_16_2 = var_16_1.id
	local var_16_3 = var_16_1.handle

	arg_16_0:print("info", "loading mod %s", var_16_2)

	local var_16_4 = Mod.info(var_16_3)

	arg_16_0:print("spew", "<mod info>\n%s\n</mod info>", var_16_4)
	Crashify.print_property("modded", true)

	local var_16_5, var_16_6 = loadstring(var_16_4)

	if not var_16_5 then
		arg_16_0:print("error", "Syntax error in .mod file. Mod %q with id %d skipped.", var_16_1.name, var_16_1.id)
		arg_16_0:print("info", var_16_6)

		var_16_1.enabled = false

		return arg_16_0:_load_mod(arg_16_1 + 1)
	end

	local var_16_7, var_16_8 = pcall(var_16_5)

	if not var_16_7 then
		arg_16_0:print("error", "Error in .mod file return table. Mod %q with id %d skipped.", var_16_1.name, var_16_1.id)
		arg_16_0:print("info", var_16_8)

		var_16_1.enabled = false

		return arg_16_0:_load_mod(arg_16_1 + 1)
	end

	var_16_1.data = var_16_8
	var_16_1.name = var_16_1.name or var_16_8.NAME or "Mod " .. var_16_2
	var_16_1.state = "loading"

	Crashify.print_property(string.format("Mod:%s:%s", var_16_2, var_16_1.name), true)

	arg_16_0._mod_load_index = arg_16_1

	arg_16_0:_load_package(var_16_1, 1)

	return "loading"
end

function ModManager._load_package(arg_17_0, arg_17_1, arg_17_2)
	arg_17_1.package_index = arg_17_2

	local var_17_0 = arg_17_1.data.packages[arg_17_2]

	if not var_17_0 then
		return
	end

	arg_17_0:print("info", "loading package %q", var_17_0)

	local var_17_1 = Mod.resource_package(arg_17_1.handle, var_17_0)

	arg_17_0._loading_resource_handle = var_17_1

	ResourcePackage.load(var_17_1)

	arg_17_1.loaded_packages[#arg_17_1.loaded_packages + 1] = var_17_1
end

function ModManager.unload_all_mods(arg_18_0)
	if arg_18_0._state ~= "done" then
		arg_18_0:print("error", "Mods can't be unloaded, mod state is not \"done\". current: %q", arg_18_0._state)

		return
	end

	arg_18_0:print("info", "Unload all mod packages")

	for iter_18_0 = arg_18_0._num_mods, 1, -1 do
		local var_18_0 = arg_18_0._mods[iter_18_0]

		if var_18_0 and var_18_0.enabled then
			arg_18_0:unload_mod(iter_18_0)
		end

		arg_18_0._mods[iter_18_0] = nil
	end

	arg_18_0._num_mods = nil
	arg_18_0._state = "unloaded"
end

function ModManager.unload_mod(arg_19_0, arg_19_1)
	local var_19_0 = arg_19_0._mods[arg_19_1]

	if var_19_0 then
		arg_19_0:print("info", "Unloading %q.", var_19_0.name)
		arg_19_0:_run_callback(var_19_0, "on_unload")

		for iter_19_0, iter_19_1 in ipairs(var_19_0.loaded_packages) do
			Mod.release_resource_package(iter_19_1)
		end

		var_19_0.state = "not_loaded"
	else
		arg_19_0:print("error", "Mod index %i can't be unloaded, has not been loaded", arg_19_1)
	end
end

function ModManager._reload_mods(arg_20_0)
	arg_20_0:print("info", "reloading mods")

	for iter_20_0 = 1, arg_20_0._num_mods do
		local var_20_0 = arg_20_0._mods[iter_20_0]

		if var_20_0 and var_20_0.state == "running" then
			arg_20_0:print("info", "reloading %s", var_20_0.name)

			arg_20_0._reload_data[var_20_0.id] = arg_20_0:_run_callback(var_20_0, "on_reload")
		else
			arg_20_0:print("info", "not reloading mod, state: %s", var_20_0.state)
		end
	end

	arg_20_0:unload_all_mods()
	arg_20_0:_start_scan()

	arg_20_0._reload_requested = false
end

function ModManager.on_game_state_changed(arg_21_0, arg_21_1, arg_21_2, arg_21_3)
	if arg_21_0._state == "done" then
		for iter_21_0 = 1, arg_21_0._num_mods do
			local var_21_0 = arg_21_0._mods[iter_21_0]

			if var_21_0 and var_21_0.enabled and not var_21_0.callbacks_disabled then
				arg_21_0:_run_callback(var_21_0, "on_game_state_changed", arg_21_1, arg_21_2, arg_21_3)
			end
		end
	else
		arg_21_0:print("warning", "Ignored on_game_state_changed call due to being in state %q", arg_21_0._state)
	end
end

function ModManager._topologically_sorted(arg_22_0, arg_22_1)
	local var_22_0 = {}
	local var_22_1 = {}

	for iter_22_0, iter_22_1 in ipairs(arg_22_1) do
		if not var_22_0[iter_22_1] then
			arg_22_0:_visit(arg_22_1, var_22_0, var_22_1, iter_22_1)
		end
	end

	return var_22_1
end

function ModManager._visit(arg_23_0, arg_23_1, arg_23_2, arg_23_3, arg_23_4)
	arg_23_0:print("debug", "Visiting mod %q with id %d", arg_23_4.name, arg_23_4.id)

	if arg_23_2[arg_23_4] then
		return arg_23_4.enabled
	end

	if arg_23_2[arg_23_4] ~= nil then
		arg_23_0:print("error", "Dependency cycle detected at mod %q with id %d", arg_23_4.name, arg_23_4.id)

		return false
	end

	arg_23_2[arg_23_4] = false

	local var_23_0 = arg_23_4.enabled or false

	for iter_23_0 = 1, arg_23_4.num_children or 0 do
		local var_23_1 = arg_23_4.children[j]
		local var_23_2 = arg_23_1[table.find_by_key(arg_23_1, "id", var_23_1)]

		if not var_23_2 then
			arg_23_0:print("warning", "Mod with id %d not found", id)
		elseif not arg_23_0:_visit(arg_23_1, arg_23_2, arg_23_3, var_23_2) and var_23_0 then
			arg_23_0:print("warning", "Disabled mod %q with id %d due to missing dependency %d.", arg_23_4.name, arg_23_4.id, var_23_1)

			var_23_0 = false
		end
	end

	arg_23_4.enabled = var_23_0
	arg_23_2[arg_23_4] = true
	arg_23_3[#arg_23_3 + 1] = arg_23_4

	return var_23_0
end

local var_0_4 = {
	spew = 4,
	info = 3,
	warning = 2,
	error = 1
}

function ModManager.print(arg_24_0, arg_24_1, arg_24_2, ...)
	local var_24_0 = string.format("[ModManager][" .. arg_24_1 .. "] " .. arg_24_2, ...)
	local var_24_1 = var_0_4[arg_24_1] or 99

	if var_24_1 <= 2 then
		print(var_24_0)
	end

	if var_24_1 <= arg_24_0._settings.log_level then
		arg_24_0._chat_print_buffer[#arg_24_0._chat_print_buffer + 1] = var_24_0
	end
end

function ModManager.network_bind(arg_25_0, arg_25_1, arg_25_2)
	local var_25_0 = arg_25_0._network_callbacks

	fassert(not var_25_0[arg_25_1], "Port %d already in use", arg_25_1)

	var_25_0[arg_25_1] = arg_25_2
end

function ModManager.network_unbind(arg_26_0, arg_26_1)
	local var_26_0 = arg_26_0._network_callbacks

	fassert(var_26_0[arg_26_1], "Port %d not in use", arg_26_1)

	var_26_0[arg_26_1] = nil
end

function ModManager.network_is_occupied(arg_27_0, arg_27_1)
	return arg_27_0._network_callbacks[arg_27_1] ~= nil
end

function ModManager.network_send(arg_28_0, arg_28_1, arg_28_2, arg_28_3)
	if arg_28_1 == arg_28_0._my_peer_id then
		Managers.state.network.network_transmit:queue_local_rpc("rpc_mod_user_data", arg_28_2, arg_28_3)
	end

	local var_28_0 = PEER_ID_TO_CHANNEL[arg_28_0._is_server and arg_28_1 or arg_28_0._host_peer_id]

	if var_28_0 then
		RPC.rpc_mod_user_data(var_28_0, arg_28_0._my_peer_id, arg_28_1, arg_28_2, arg_28_3)
	end
end

function ModManager.rpc_mod_user_data(arg_29_0, arg_29_1, arg_29_2, arg_29_3, arg_29_4, arg_29_5)
	if arg_29_3 == arg_29_0._my_peer_id then
		local var_29_0 = arg_29_0._network_callbacks[arg_29_4]

		if var_29_0 then
			var_29_0(arg_29_2, arg_29_5)
		end
	elseif arg_29_0._is_server then
		local var_29_1 = PEER_ID_TO_CHANNEL[arg_29_3]

		if var_29_1 then
			RPC.rpc_mod_user_data(var_29_1, arg_29_2, arg_29_3, arg_29_4, arg_29_5)
		end
	end
end

function ModManager.register_network_event_delegate(arg_30_0, arg_30_1)
	arg_30_1:register(arg_30_0, "rpc_mod_user_data")

	arg_30_0._network_event_delegate = arg_30_1
end

function ModManager.unregister_network_event_delegate(arg_31_0)
	arg_31_0._network_event_delegate:unregister(arg_31_0)

	arg_31_0._network_event_delegate = nil
end

function ModManager.network_context_created(arg_32_0, arg_32_1, arg_32_2, arg_32_3)
	arg_32_0._host_peer_id = arg_32_1
	arg_32_0._my_peer_id = arg_32_2
	arg_32_0._is_server = arg_32_3
end
