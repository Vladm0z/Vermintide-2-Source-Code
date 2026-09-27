-- chunkname: @scripts/managers/backend_playfab/playfab_mirror_adventure.lua

require("scripts/managers/backend_playfab/playfab_mirror_base")

local PlayFabClientApi = require("PlayFab.PlayFabClientApi")

PlayFabMirrorAdventure = class(PlayFabMirrorAdventure, PlayFabMirrorBase)

PlayFabMirrorAdventure.init = function (self, arg_1_1)
	-- function 1
	local current_mechanism_name = Managers.mechanism:current_mechanism_name()

	self:set_mechanism(current_mechanism_name)
	PlayFabMirrorBase.init(self, arg_1_1)
end

PlayFabMirrorAdventure.set_mechanism = function (self, arg_2_1)
	-- function 2
	printf("[PlayFabMirrorAdventure] Setting mechanism %s", arg_2_1)
	rawset(_G, "debug_characters_data_unsafe_write", not self._mechanism_key and self._mechanism_key ~= arg_2_1 or nil)

	self._mechanism_key = arg_2_1

	local clone = table.clone(InventorySettings.slots_per_affiliation)

	table.insert(clone.heroes, "talents")

	if arg_2_1 == "versus" then
		self._characters_data_key = "vs_characters_data"
	else
		self._characters_data_key = "characters_data"
		clone = {
			heroes = clone.heroes
		}
	end

	self._verify_slot_keys_per_affiliation = clone
end

PlayFabMirrorAdventure.request_characters = function (self, arg_3_1)
	-- function 3
	arg_3_1 = arg_3_1 or self._mechanism_key

	if arg_3_1 == "versus" then
		local flag = false
		local get_read_only_data = self:get_read_only_data("vs_characters_data")

		if not (not get_read_only_data and self:get_read_only_data("vs_profile_data") ~= nil) then
			flag = true
		elseif not get_read_only_data then
			local decode = cjson.decode(get_read_only_data)

			for k, v in pairs(decode) do
				if not table.is_empty(v.careers) then
					flag = true

					break
				end
			end

			if not flag then
				local dark_pact = PROFILES_BY_AFFILIATION.dark_pact

				for k_2 = 1, #dark_pact do
					local var_3_4 = dark_pact[k_2]

					if not (var_3_4 == "vs_undecided" or decode[var_3_4]) then
						flag = true

						break
					end
				end
			end
		end

		if not flag then
			self._num_items_to_load = self._num_items_to_load + 1

			local tbl = {
				FunctionName = "versusPlayerSetup",
				FunctionParameter = {}
			}
			local var_3_6 = callback(self, "versus_player_setup_cb")

			self._request_queue:enqueue(tbl, var_3_6)
		else
			self:_verify_career_loadouts()
		end
	else
		self:_verify_career_loadouts()
	end
end

PlayFabMirrorAdventure._verify_career_loadouts = function (self)
	-- function 4
	self._num_items_to_load = self._num_items_to_load + 1

	local tbl = {
		FunctionName = "verifyCareerLoadouts",
		FunctionParameter = {}
	}
	local var_4_1 = callback(self, "verify_career_loadouts_cb")

	self._request_queue:enqueue(tbl, var_4_1)
end

PlayFabMirrorAdventure.verify_career_loadouts_cb = function (self, arg_5_1)
	-- function 5
	local FunctionResult = arg_5_1.FunctionResult
	local characters_data = FunctionResult.characters_data
	local vs_characters_data = FunctionResult.vs_characters_data

	if not characters_data then
		self:set_read_only_data("characters_data", characters_data, true)
	end

	if not vs_characters_data then
		self:set_read_only_data("vs_characters_data", vs_characters_data, true)
	end

	self._num_items_to_load = self._num_items_to_load - 1

	self:_verify_dlc_careers()
end

PlayFabMirrorAdventure.versus_player_setup_cb = function (self, arg_6_1)
	-- function 6
	local FunctionResult = arg_6_1.FunctionResult
	local vs_characters_data = FunctionResult.vs_characters_data
	local vs_profile_data = FunctionResult.vs_profile_data
	local num_items_granted = FunctionResult.num_items_granted

	self:set_read_only_data("vs_characters_data", vs_characters_data, true)
	self:set_read_only_data("vs_profile_data", vs_profile_data, true)

	self._num_items_to_load = self._num_items_to_load - 1

	local unlocked_cosmetics = FunctionResult.unlocked_cosmetics

	if not unlocked_cosmetics then
		self:set_read_only_data("unlocked_cosmetics", unlocked_cosmetics, true)

		self._unlocked_cosmetics = self:_parse_unlocked_cosmetics()
	end

	if num_items_granted > 0 then
		self:_request_user_inventory()
	else
		self:_verify_career_loadouts()
	end
end

PlayFabMirrorAdventure._set_inital_career_data_weaves = function (self, arg_7_1, arg_7_2, arg_7_3)
	-- function 7
	local tbl = {}

	for i = 1, #arg_7_3 do
		local var_7_1 = arg_7_3[i]
		local var_7_2 = arg_7_2[var_7_1]
		local Value

		if type(var_7_2) == "table" then
			Value = var_7_2.Value

			if not Value then
				-- Nothing
			end
		end

		Value = var_7_2

		::label_7_0::

		if not Value then
			tbl[var_7_1] = true
		elseif not self._inventory_items[Value] then
			tbl[var_7_1] = true
		end
	end

	if table.size(tbl) > 0 then
		return tbl
	end
end

PlayFabMirrorAdventure._check_weaves_loadout = function (self)
	-- function 8
	local get_read_only_data = self:get_read_only_data(self._characters_data_key)
	local decode = cjson.decode(get_read_only_data)
	local tbl = {}

	for k, v in pairs(decode) do
		for k_2, v_2 in pairs(v.careers) do
			local str = "weaves_loadout_" .. k_2
			local get_read_only_data_2 = self:get_read_only_data(str)
			local decode_2 = cjson.decode(get_read_only_data_2)
			local _set_inital_career_data_weaves = self:_set_inital_career_data_weaves(k_2, decode_2, {
				"slot_melee",
				"slot_ranged"
			})

			if not _set_inital_career_data_weaves then
				tbl[k_2] = _set_inital_career_data_weaves

				print("Broken item slots for career", str)
				table.dump(_set_inital_career_data_weaves)
			end
		end
	end

	if not table.is_empty(tbl) then
		self:_fix_career_data(tbl, "weaves", "fix_weaves_career_data_request_cb")
	else
		self:unequip_disabled_items()
	end
end

PlayFabMirrorAdventure.fix_weaves_career_data_request_cb = function (self, arg_9_1)
	-- function 9
	self.broken_slots_data = nil
	self._num_items_to_load = self._num_items_to_load - 1

	local FunctionResult = arg_9_1.FunctionResult

	if FunctionResult.num_items_granted > 0 then
		self:_request_user_inventory()

		return
	end

	local character_starting_gear = FunctionResult.character_starting_gear

	self:merge_read_only_data(character_starting_gear, true)
	self:unequip_disabled_items()
end
