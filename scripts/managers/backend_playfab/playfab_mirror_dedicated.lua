-- chunkname: @scripts/managers/backend_playfab/playfab_mirror_dedicated.lua

require("scripts/managers/backend_playfab/playfab_mirror_adventure")

local PlayFabClientApi = require("PlayFab.PlayFabClientApi")

PlayFabMirrorDedicated = class(PlayFabMirrorDedicated, PlayFabMirrorAdventure)

PlayFabMirrorDedicated.init = function (self, arg_1_1)
	-- function 1
	self._data_is_ready = false

	PlayFabMirrorAdventure.init(self, arg_1_1)

	self._unlocked_weapon_skins = {}
	self._unlocked_cosmetics = {}
	self._owned_dlcs = {}

	for k, v in pairs(Managers.unlock:get_dlcs()) do
		self._owned_dlcs[#self._owned_dlcs + 1] = k

		if not v and not v.set_owned then
			v:set_owned(true)
		end
	end
end

PlayFabMirrorDedicated.is_update_items_done = function (self)
	-- function 2
	return self._data_is_ready
end

PlayFabMirrorDedicated.set_character_data = function (arg_3_0, arg_3_1, arg_3_2, arg_3_3)
	-- function 3
	assert(false)
end

PlayFabMirrorDedicated._request_server_inventory = function (self)
	-- function 4
	local tbl = {
		FunctionName = "getServerInventory",
		FunctionParameter = {}
	}
	local var_4_1 = callback(self, "inventory_request_cb")

	self._request_queue:enqueue(tbl, var_4_1)

	self._num_items_to_load = self._num_items_to_load + 1
end

PlayFabMirrorDedicated.inventory_request_cb = function (self, arg_5_1)
	-- function 5
	self._data_is_ready = true
	self._unlocked_weapon_skins = self:_parse_unlocked_weapon_skins(arg_5_1.FunctionResult)
	self._unlocked_cosmetics = self:_parse_unlocked_cosmetics(arg_5_1.FunctionResult.unlocked_cosmetics)

	self.super.inventory_request_cb(self, arg_5_1.FunctionResult)
end

PlayFabMirrorDedicated.request_characters = function (self)
	-- function 6
	if not (self._refresh_characters or self:get_read_only_data("vs_characters_data") ~= nil) then
		self._refresh_characters = false
		self._num_items_to_load = self._num_items_to_load + 1

		local tbl = {
			FunctionName = "getServerCharactersData",
			FunctionParameter = {}
		}
		local var_6_1 = callback(self, "get_versus_characters_data")

		self._request_queue:enqueue(tbl, var_6_1)
	else
		self:_setup_careers()
	end
end

PlayFabMirrorDedicated.get_versus_characters_data = function (self, arg_7_1)
	-- function 7
	local vs_characters_data = arg_7_1.FunctionResult.vs_characters_data

	self._num_items_to_load = self._num_items_to_load - 1

	self:set_read_only_data("vs_characters_data", vs_characters_data, true)
	self:_setup_careers()
end

PlayFabMirrorDedicated._fix_career_data = function (self, arg_8_1)
	-- function 8
	local decode = cjson.decode(self._read_only_data.vs_characters_data)

	self._characters_data = decode
	self._characters_data_mirror = table.clone(decode)
end
