-- chunkname: @scripts/entity_system/systems/keep_decoration/keep_decoration_system.lua

require("scripts/settings/keep_decoration_settings")
require("scripts/unit_extensions/level/keep_decoration_painting_extension")
require("scripts/unit_extensions/level/keep_decoration_trophy_extension")
require("scripts/settings/trophies")

KeepDecorationSystem = class(KeepDecorationSystem, ExtensionSystemBase)

local tbl = {
	"KeepDecorationPaintingExtension",
	"KeepDecorationTrophyExtension"
}
local tbl_2 = {
	"rpc_request_painting",
	"rpc_send_painting"
}

KeepDecorationSystem.init = function (self, arg_1_1, arg_1_2)
	-- function 1
	KeepDecorationSystem.super.init(self, arg_1_1, arg_1_2, tbl)

	self._network_event_delegate = arg_1_1.network_event_delegate

	self._network_event_delegate:register(self, unpack(tbl_2))

	self._network_trasmit = Managers.state.network.network_transmit
	self._extensions = {}
	self._unit_extensions = {}
	self._painting_extensions = {}
	self._used_settings_keys = {}
	self._used_backend_keys = {}
	self._update_index = 0
	self._is_leader = Managers.party:is_leader(Network.peer_id())
	self._client_paintings = {}
	self._client_painting_extensions = {}
	self._num_players = 0
end

KeepDecorationSystem.destroy = function (self)
	-- function 2
	self._extensions = nil
	self._unit_extensions = nil
	self._painting_extensions = nil

	self._network_event_delegate:unregister(self)
end

KeepDecorationSystem.on_add_extension = function (self, arg_3_1, arg_3_2, arg_3_3, arg_3_4, ...)
	-- function 3
	local get_data = Unit.get_data(arg_3_2, "decoration_settings_key")
	local _used_settings_keys = self._used_settings_keys
	local _used_backend_keys = self._used_backend_keys

	fassert(not _used_settings_keys[get_data], "Multiple units has the same decoration_settings_key \"" .. tostring(get_data) .. "\". Fix it in the unit data!")

	local var_3_3 = KeepDecorationSettings[get_data]

	fassert(var_3_3, "No settings found for decoration_settings_key \"" .. tostring(get_data) .. "\". Fix it in keep_decoration_settings.lua!")

	local backend_key = var_3_3.backend_key

	fassert(not _used_backend_keys[backend_key], "Multiple decoration settings has the same backend_key \"" .. tostring(backend_key) .. "\". Fix it in keep_decoration_settings.lua!")

	local on_add_extension = KeepDecorationSystem.super.on_add_extension(self, arg_3_1, arg_3_2, arg_3_3, arg_3_4, ...)

	if arg_3_3 == "KeepDecorationPaintingExtension" then
		if not Unit.get_data(arg_3_2, "painting_data", "is_client_painting") then
			self._client_painting_extensions[#self._client_painting_extensions + 1] = on_add_extension
		end

		self._painting_extensions[#self._painting_extensions + 1] = on_add_extension
	end

	on_add_extension.keep_decoration_system = self
	self._extensions[#self._extensions + 1] = on_add_extension
	self._unit_extensions[arg_3_2] = on_add_extension
	self._used_settings_keys[get_data] = true
	self._used_backend_keys[backend_key] = true

	return on_add_extension
end

KeepDecorationSystem.update = function (self, arg_4_1, arg_4_2)
	-- function 4
	local _extensions = self._extensions
	local count = #_extensions

	if count == 0 then
		return
	end

	local num = self._update_index + 1

	if count < num then
		num = 1
	end

	_extensions[num]:distributed_update()

	local level_key = Managers.state.game_mode:level_key()
	local var_4_4 = LevelSettings[level_key]

	if not self._is_leader and not var_4_4.use_keep_decorations then
		local human_players = Managers.player:human_players()
		local num_2 = 0

		for k, v in pairs(human_players) do
			num_2 = num_2 + 1
		end

		if not (not self._is_leader and num_2 == self._num_players) then
			self._num_players = num_2

			self:_sync_client_paintings()
			self:_refresh_client_paintings()
		end
	end

	self._update_index = num
end

KeepDecorationSystem.on_painting_set = function (self, arg_5_1, arg_5_2)
	-- function 5
	local _painting_extensions = self._painting_extensions
	local frame = Paintings[arg_5_1].frame

	for i = 1, #_painting_extensions do
		local var_5_2 = _painting_extensions[i]
		local get_selected_decoration = var_5_2:get_selected_decoration()
		local frame_2 = Paintings[get_selected_decoration].frame
		local is_client_painting = var_5_2:is_client_painting()

		if not (get_selected_decoration ~= arg_5_1 or arg_5_2 == var_5_2 or frame ~= frame_2 or is_client_painting) then
			var_5_2:decoration_selected("hor_none")
			var_5_2:sync_decoration()
		end
	end
end

KeepDecorationSystem.on_decoration_set = function (self, arg_6_1, arg_6_2, arg_6_3)
	-- function 6
	local _extensions = self._extensions

	for i = 1, #_extensions do
		local var_6_1 = _extensions[i]

		if not (var_6_1:get_selected_decoration() ~= arg_6_1 or arg_6_2 == var_6_1) then
			local flag

			flag = (arg_6_3 ~= "painting" or not "hor_none" or arg_6_3 ~= "trophy") and "hub_trophy_empty"

			var_6_1:decoration_selected(flag)
			var_6_1:sync_decoration()
		end
	end
end

KeepDecorationSystem.is_decoration_in_use = function (self, arg_7_1)
	-- function 7
	local _extensions = self._extensions

	for i = 1, #_extensions do
		if _extensions[i]:get_selected_decoration() == arg_7_1 then
			return true
		end
	end

	return false
end

KeepDecorationSystem._add_client_painting = function (arg_8_0, arg_8_1, arg_8_2)
	-- function 8
	arg_8_0._client_paintings[arg_8_1] = arg_8_2
end

KeepDecorationSystem._sync_client_paintings = function (self)
	-- function 9
	local _client_paintings = self._client_paintings
	local human_players = Managers.player:human_players()
	local peer_id = Network.peer_id()

	for k, v in pairs(_client_paintings) do
		local flag = false

		for k_2, v_2 in pairs(human_players) do
			if not (k ~= v_2.peer_id or v_2.peer_id == peer_id) then
				flag = true

				break
			end
		end

		if not flag then
			_client_paintings[k] = nil
		end
	end

	self._client_paintings = _client_paintings
end

KeepDecorationSystem._refresh_client_paintings = function (self)
	-- function 10
	local _client_paintings = self._client_paintings
	local tbl = {}
	local num = 1

	for k, v in pairs(_client_paintings) do
		tbl[num] = v
		num = num + 1
	end

	for k_2 = 1, 3 do
		local var_10_3 = tbl[k_2]

		var_10_3 = var_10_3 or "hidden"

		self._client_painting_extensions[k_2]:set_client_painting(var_10_3)
	end
end

KeepDecorationSystem.rpc_send_painting = function (self, arg_11_1, arg_11_2)
	-- function 11
	local var_11_0 = CHANNEL_TO_PEER_ID[arg_11_1]

	self:_add_client_painting(var_11_0, arg_11_2)
	self:_refresh_client_paintings()
end

KeepDecorationSystem.rpc_request_painting = function (self, arg_12_1)
	-- function 12
	local get_decoration = Managers.backend:get_interface("keep_decorations"):get_decoration("keep_hall_painting_wood_base_5")

	get_decoration = get_decoration or "hor_none"

	self.network_transmit:send_rpc_server("rpc_send_painting", get_decoration)
end

KeepDecorationSystem.hot_join_sync = function (arg_13_0, arg_13_1)
	-- function 13
	local level_key = Managers.state.game_mode:level_key()

	if not LevelSettings[level_key].use_keep_decorations then
		local var_13_1 = PEER_ID_TO_CHANNEL[arg_13_1]

		RPC.rpc_request_painting(var_13_1)
	end
end
