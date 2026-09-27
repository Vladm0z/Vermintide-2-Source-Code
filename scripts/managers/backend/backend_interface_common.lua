-- chunkname: @scripts/managers/backend/backend_interface_common.lua

BackendInterfaceCommon = class(BackendInterfaceCommon)

require("scripts/settings/equipment/weapon_skins")

BackendInterfaceCommon.init = function (self, arg_1_1)
	-- function 1
	self._backend_mirror = arg_1_1
end

BackendInterfaceCommon.ready = function (arg_2_0)
	-- function 2
	return true
end

BackendInterfaceCommon.can_wield = function (arg_3_0, arg_3_1, arg_3_2)
	-- function 3
	local can_wield = arg_3_2.can_wield
	local assert = assert
	local var_3_2 = can_wield
	local str = "BackendInterfaceCommon - Item %q has not specified what profiles that can use it."
	local name = arg_3_2.name

	name = name or "(item_data missing name)"

	assert(var_3_2, str, name)

	for i, v in ipairs(can_wield) do
		if arg_3_1 == v then
			return true
		end
	end
end

local tbl = {
	["not"] = {
		4,
		1,
		function (arg_4_0)
			-- function 4
			return not arg_4_0
		end
	},
	["<"] = {
		3,
		2,
		function (arg_5_0, arg_5_1)
			-- function 5
			return arg_5_0 < arg_5_1
		end
	},
	[">"] = {
		3,
		2,
		function (arg_6_0, arg_6_1)
			-- function 6
			return arg_6_1 < arg_6_0
		end
	},
	["<="] = {
		3,
		2,
		function (arg_7_0, arg_7_1)
			-- function 7
			return arg_7_0 <= arg_7_1
		end
	},
	[">="] = {
		3,
		2,
		function (arg_8_0, arg_8_1)
			-- function 8
			return arg_8_1 <= arg_8_0
		end
	},
	["~="] = {
		3,
		2,
		function (arg_9_0, arg_9_1)
			-- function 9
			return arg_9_0 ~= arg_9_1
		end
	},
	["=="] = {
		3,
		2,
		function (arg_10_0, arg_10_1)
			-- function 10
			return arg_10_0 == arg_10_1
		end
	},
	["and"] = {
		2,
		2,
		function (arg_11_0, arg_11_1)
			-- function 11
			return not arg_11_0 and arg_11_1
		end
	},
	["or"] = {
		1,
		2,
		function (arg_12_0, arg_12_1)
			-- function 12
			return arg_12_0 or arg_12_1
		end
	}
}

local function fn(arg_13_0)
	-- function 13
	return function (self, arg_14_1)
		-- function 14
		local careers = SPProfiles[FindProfileIndex(arg_13_0)].careers

		for i, v in ipairs(careers) do
			if not table.contains(self.data.can_wield, v.name) then
				return true
			end
		end

		return false
	end
end

local function fn_2(arg_15_0)
	-- function 15
	return function (self, arg_16_1)
		-- function 16
		return table.contains(self.data.can_wield, arg_15_0)
	end
end

local tbl_2 = {}
local tbl_3 = {
	item_key = function (self, arg_17_1)
		-- function 17
		return self.data.key
	end,
	item_rarity = function (self, arg_18_1)
		-- function 18
		local data = self.data

		return (Managers.backend:get_interface("items"):get_item_rarity(arg_18_1))
	end,
	slot_type = function (self, arg_19_1)
		-- function 19
		return self.data.slot_type
	end,
	item_type = function (self, arg_20_1)
		-- function 20
		return self.data.item_type
	end,
	selection = function (self, arg_21_1)
		-- function 21
		return self.data.selection
	end,
	default_selection = function (self, arg_22_1)
		-- function 22
		local data = self.data

		return data.selection == "default" or data.selection == nil
	end,
	is_pactsworn_item = function (self, arg_23_1)
		-- function 23
		local flag = false
		local data = self.data
		local can_wield = data.can_wield

		if not (can_wield == CanWieldAllItemTemplates or data.item_type == "skin" or data.item_type ~= "cosmetic_bundle") then
			for i = 1, #can_wield do
				local var_23_3 = can_wield[i]

				if PROFILES_BY_CAREER_NAMES[var_23_3].affiliation == "dark_pact" then
					flag = true

					break
				end
			end
		end

		return flag
	end,
	chest_categories = function (self, arg_24_1)
		-- function 24
		return self.data.chest_categories
	end,
	discounted_items = function (self, arg_25_1)
		-- function 25
		local data = self.data
		local key = data.key
		local get_interface = Managers.backend:get_interface("peddler")
		local steam_itemdefid = data.steam_itemdefid

		if not HAS_STEAM and not steam_itemdefid then
			local steam_data = self.steam_data

			if not steam_data and not steam_data.discount_is_active then
				return true
			end
		end

		return get_interface:is_discounted_shilling_item(key)
	end,
	is_weapon = function (self, arg_26_1)
		-- function 26
		local slot_type = self.data.slot_type

		return slot_type == "melee" or slot_type == "ranged"
	end,
	equipped_by_current_career = function (self, arg_27_1, arg_27_2)
		-- function 27
		local data = self.data
		local profile_synchronizer = Managers.state.network.profile_synchronizer
		local var_27_2

		if not arg_27_2 and not arg_27_2.player then
			var_27_2 = arg_27_2.player
		else
			var_27_2 = Managers.player:local_player()
		end

		if not var_27_2 then
			return false
		end

		local profile_index = var_27_2:profile_index()

		if not (not profile_index and profile_index ~= 0) then
			return false
		end

		local career_index = var_27_2:career_index()

		if not (not career_index and career_index ~= 0) then
			return false
		end

		local name = SPProfiles[profile_index].careers[career_index].name
		local equipped_by = Managers.backend:get_interface("items"):equipped_by(arg_27_1)

		return table.contains(equipped_by, name)
	end,
	is_equipped = function (self, arg_28_1)
		-- function 28
		local data = self.data

		if #Managers.backend:get_interface("items"):equipped_by(arg_28_1) > 0 then
			return true
		end

		return false
	end,
	is_equipped_by_any_loadout = function (self, arg_29_1)
		-- function 29
		local data = self.data

		if #Managers.backend:get_interface("items"):is_equipped_by_any_loadout(arg_29_1) > 0 then
			return true
		end

		return false
	end,
	is_equipment_slot = function (self, arg_30_1)
		-- function 30
		local data = self.data
		local flag = false

		for i, v in ipairs(InventorySettings.equipment_slots) do
			if data.slot_type == v.type then
				flag = true

				break
			end
		end

		return flag
	end,
	current_hero = function (self, arg_31_1)
		-- function 31
		local data = self.data
		local profile_synchronizer = Managers.state.network.profile_synchronizer
		local local_player = Managers.player:local_player()
		local profile_by_peer = profile_synchronizer:profile_by_peer(local_player:network_id(), local_player:local_player_id())

		return SPProfiles[profile_by_peer].display_name
	end,
	can_wield_by_current_career = function (self, arg_32_1, arg_32_2)
		-- function 32
		local data = self.data
		local profile_synchronizer = Managers.state.network.profile_synchronizer
		local local_player = Managers.player:local_player()
		local profile_index

		if not arg_32_2 then
			profile_index = arg_32_2.profile_index

			if not profile_index then
				-- Nothing
			end
		end

		profile_index = local_player:profile_index()

		do
			local career_index
		end

		::label_32_0::

		if not arg_32_2 then
			career_index = arg_32_2.career_index

			if not career_index then
				-- Nothing
			end
		end

		career_index = local_player:career_index()

		::label_32_1::

		local name = SPProfiles[profile_index].careers[career_index].name
		local can_wield = data.can_wield

		return table.contains(can_wield, name)
	end,
	can_wield_by_current_hero = function (self, arg_33_1, arg_33_2)
		-- function 33
		local data = self.data
		local profile_synchronizer = Managers.state.network.profile_synchronizer
		local local_player = Managers.player:local_player()
		local profile_index

		if not arg_33_2 then
			profile_index = arg_33_2.profile_index

			if not profile_index then
				-- Nothing
			end
		end

		profile_index = local_player:profile_index()

		::label_33_0::

		if not (not arg_33_2 and arg_33_2.career_index) then
			local career_index = local_player:career_index()
		end

		local careers = SPProfiles[profile_index].careers
		local can_wield = data.can_wield

		for i, v in ipairs(careers) do
			local name = v.name

			if not table.contains(can_wield, name) then
				return true
			end
		end

		return false
	end,
	is_new = function (arg_34_0, arg_34_1)
		-- function 34
		return PlayerData.new_item_ids[arg_34_1]
	end,
	is_plentiful = function (arg_35_0, arg_35_1)
		-- function 35
		return Managers.backend:get_interface("items"):get_item_rarity(arg_35_1) == "plentiful"
	end,
	is_common = function (arg_36_0, arg_36_1)
		-- function 36
		return Managers.backend:get_interface("items"):get_item_rarity(arg_36_1) == "common"
	end,
	is_rare = function (arg_37_0, arg_37_1)
		-- function 37
		return Managers.backend:get_interface("items"):get_item_rarity(arg_37_1) == "rare"
	end,
	is_exotic = function (arg_38_0, arg_38_1)
		-- function 38
		return Managers.backend:get_interface("items"):get_item_rarity(arg_38_1) == "exotic"
	end,
	is_unique = function (arg_39_0, arg_39_1)
		-- function 39
		return Managers.backend:get_interface("items"):get_item_rarity(arg_39_1) == "unique"
	end,
	is_promo = function (arg_40_0, arg_40_1)
		-- function 40
		return Managers.backend:get_interface("items"):get_item_rarity(arg_40_1) == "promo"
	end,
	is_default = function (arg_41_0, arg_41_1)
		-- function 41
		return Managers.backend:get_interface("items"):get_item_rarity(arg_41_1) == "default"
	end,
	is_magic = function (arg_42_0, arg_42_1)
		-- function 42
		return Managers.backend:get_interface("items"):get_item_rarity(arg_42_1) == "magic"
	end,
	is_event = function (arg_43_0, arg_43_1)
		-- function 43
		return Managers.backend:get_interface("items"):get_item_rarity(arg_43_1) == "event"
	end,
	can_wield_bright_wizard = fn("bright_wizard"),
	can_wield_bw_scholar = fn_2("bw_scholar"),
	can_wield_bw_adept = fn_2("bw_adept"),
	can_wield_bw_unchained = fn_2("bw_unchained"),
	can_wield_bw_necromancer = fn_2("bw_necromancer"),
	can_wield_dwarf_ranger = fn("dwarf_ranger"),
	can_wield_dr_ironbreaker = fn_2("dr_ironbreaker"),
	can_wield_dr_slayer = fn_2("dr_slayer"),
	can_wield_dr_ranger = fn_2("dr_ranger"),
	can_wield_dr_engineer = fn_2("dr_engineer"),
	can_wield_empire_soldier = fn("empire_soldier"),
	can_wield_es_huntsman = fn_2("es_huntsman"),
	can_wield_es_knight = fn_2("es_knight"),
	can_wield_es_mercenary = fn_2("es_mercenary"),
	can_wield_es_questingknight = fn_2("es_questingknight"),
	can_wield_witch_hunter = fn("witch_hunter"),
	can_wield_wh_captain = fn_2("wh_captain"),
	can_wield_wh_bountyhunter = fn_2("wh_bountyhunter"),
	can_wield_wh_zealot = fn_2("wh_zealot"),
	can_wield_wh_priest = fn_2("wh_priest"),
	can_wield_wood_elf = fn("wood_elf"),
	can_wield_we_waywatcher = fn_2("we_waywatcher"),
	can_wield_we_maidenguard = fn_2("we_maidenguard"),
	can_wield_we_shade = fn_2("we_shade"),
	can_wield_we_thornsister = fn_2("we_thornsister"),
	player_owns_item_key = function (self, arg_44_1)
		-- function 44
		local data = self.data
		local get_all_backend_items = Managers.backend:get_interface("items"):get_all_backend_items()

		for k, v in pairs(get_all_backend_items) do
			if data.key == v.key then
				return true
			end
		end

		return false
	end,
	can_salvage = function (self, arg_45_1)
		-- function 45
		local slot_type = self.data.slot_type

		if not (slot_type == "ranged" or slot_type == "melee" or slot_type == "ring" or slot_type == "necklace" or slot_type ~= "trinket") then
			local get_interface = Managers.backend:get_interface("items")
			local get_item_rarity = get_interface:get_item_rarity(arg_45_1)

			if not (get_item_rarity == "default" or get_item_rarity == "promo" or get_item_rarity == "magic" or #get_interface:equipped_by(arg_45_1) ~= 0) then
				return not ItemHelper.is_favorite_backend_id(arg_45_1, self)
			end
		end

		return false
	end,
	has_properties = function (self, arg_46_1)
		-- function 46
		if not self.properties then
			return true
		end

		return false
	end,
	has_traits = function (self, arg_47_1)
		-- function 47
		if not self.traits then
			return true
		end

		return false
	end,
	has_applied_skin = function (self, arg_48_1)
		-- function 48
		local slot_type = self.data.slot_type

		if not (not self.skin and slot_type == "weapon_skin") then
			return true
		end

		return false
	end,
	can_apply_skin = function (self, arg_49_1)
		-- function 49
		local data = self.data
		local slot_type = data.slot_type

		if not (slot_type == "ranged" or slot_type ~= "melee") then
			if Managers.backend:get_interface("items"):get_item_rarity(arg_49_1) == "magic" then
				return false
			end

			local get_interface = Managers.backend:get_interface("crafting")
			local skin_combination_table = data.skin_combination_table

			if not skin_combination_table then
				local var_49_4 = WeaponSkins.skin_combinations[skin_combination_table]
				local get_unlocked_weapon_skins = get_interface:get_unlocked_weapon_skins()

				if not get_unlocked_weapon_skins[WeaponSkins.default_skins[self.ItemId]] then
					return true
				end

				for k, v in pairs(var_49_4) do
					for i, v_2 in ipairs(v) do
						if not get_unlocked_weapon_skins[v_2] then
							return true
						end
					end
				end
			end
		end

		return false
	end,
	can_upgrade = function (self, arg_50_1)
		-- function 50
		local slot_type = self.data.slot_type

		if not (slot_type == "ranged" or slot_type == "melee" or slot_type == "ring" or slot_type == "necklace" or slot_type ~= "trinket") then
			local get_item_rarity = Managers.backend:get_interface("items"):get_item_rarity(arg_50_1)

			if not (get_item_rarity == "plentiful" or get_item_rarity == "common" or get_item_rarity == "rare" or get_item_rarity ~= "exotic") then
				return true
			end
		end
	end,
	can_craft_with = function (self, arg_51_1)
		-- function 51
		local slot_type = self.data.slot_type

		if not ((slot_type == "ranged" or slot_type == "melee" or slot_type == "ring" or slot_type == "necklace" or slot_type == "trinket") and Managers.backend:get_interface("items"):get_item_rarity(arg_51_1) ~= "default") then
			return true
		end
	end,
	available_in_mechanism_versus = function (self, arg_52_1)
		-- function 52
		local data = self.data
		local mechanisms = data.mechanisms

		return table.contains({
			"hat",
			"weapon_skin",
			"frame",
			"skin",
			"weapon_pose"
		}, data.slot_type) or not mechanisms or table.contains(mechanisms, "versus")
	end,
	available_in_mechanism_adventure = function (self, arg_53_1)
		-- function 53
		local data = self.data
		local mechanisms = data.mechanisms

		return (table.contains({
			"hat",
			"weapon_skin",
			"frame",
			"skin",
			"weapon_pose"
		}, data.slot_type) or not mechanisms) and table.contains(mechanisms, "adventure")
	end,
	available_in_current_mechanism = function (self, arg_54_1)
		-- function 54
		if not script_data.disable_mechanism_item_filter then
			return true
		end

		local data = self.data
		local mechanisms = data.mechanisms
		local current_mechanism_name = Managers.mechanism:current_mechanism_name()

		if not table.contains({
			"hat",
			"weapon_skin",
			"frame",
			"skin",
			"weapon_pose"
		}, data.slot_type) then
			return true
		end

		if not LoadoutUtils.is_item_disabled(self.ItemId) then
			return false
		end

		local flag = not mechanisms and table.contains(mechanisms, current_mechanism_name)
		local flag_2 = not not mechanisms or Managers.mechanism:mechanism_setting("default_inventory")

		return flag or flag_2 or false
	end,
	owned = function (self, arg_55_1)
		-- function 55
		return self.owned
	end,
	is_fake_item = function (arg_56_0, arg_56_1)
		-- function 56
		if not Managers.backend:get_interface("items"):get_all_fake_backend_items()[arg_56_1] then
			return true
		end
	end,
	gather_weapon_pose_blueprints = function (self, arg_57_1, arg_57_2)
		-- function 57
		local slot_type = self.data.slot_type

		if not (slot_type == "melee" or slot_type ~= "ranged") then
			local get_interface = Managers.backend:get_interface("items")

			if get_interface:get_item_rarity(arg_57_1) == "default" then
				local var_57_2 = get_interface:get_unlocked_weapon_poses()[string.gsub(self.ItemId, "^vs_", "")]

				var_57_2 = var_57_2 or tbl_2

				return not table.is_empty(var_57_2)
			end
		end

		return false
	end,
	weapon_pose_parent = function (self, arg_58_1)
		-- function 58
		local data = self.data

		if data.slot_type == "weapon_pose" then
			return data.parent
		end
	end,
	is_event_item = function (self, arg_59_1)
		-- function 59
		return not not self.data.events
	end,
	is_active_event_item = function (self, arg_60_1)
		-- function 60
		local flag = false
		local events = self.data.events

		if not events then
			local get_interface = Managers.backend:get_interface("live_events")
			local flag_2 = not get_interface and get_interface:get_active_events()

			if not flag_2 then
				local flag_3 = false

				for i = 1, #events do
					local var_60_5 = events[i]

					if not not table.find(flag_2, var_60_5) == true then
						flag = true

						break
					end
				end
			end
		end

		return flag
	end
}
local BackendInterfaceCommon = BackendInterfaceCommon
local filter_postfix_cache = BackendInterfaceCommon.filter_postfix_cache

filter_postfix_cache = filter_postfix_cache or {}
BackendInterfaceCommon.filter_postfix_cache = filter_postfix_cache

local tbl_4 = {}
local tbl_5 = {}
local tbl_6 = {}

BackendInterfaceCommon.filter_items = function (self, arg_61_1, arg_61_2, arg_61_3)
	-- function 61
	local var_61_0 = BackendInterfaceCommon.filter_postfix_cache[arg_61_2]

	if not var_61_0 then
		var_61_0 = self:_infix_to_postfix_item_filter(arg_61_2)
		BackendInterfaceCommon.filter_postfix_cache[arg_61_2] = var_61_0
	end

	local tbl_2 = {}
	local num = 0
	local var_61_3 = tbl_5
	local var_61_4 = tbl_6

	for k, v in pairs(arg_61_1) do
		table.clear(var_61_3)
		table.clear(var_61_4)

		local num_2 = 0

		for k_2 = 1, #var_61_0 do
			local var_61_6 = var_61_0[k_2]

			if not tbl[var_61_6] then
				local var_61_7 = tbl[var_61_6][2]
				local var_61_8 = tbl[var_61_6][3]
				local var_61_9 = var_61_3[num_2]

				var_61_3[num_2] = nil
				num_2 = num_2 - 1

				if var_61_7 == 1 then
					local var_61_10 = var_61_8(var_61_9)

					if var_61_10 ~= nil then
						num_2 = num_2 + 1
						var_61_3[num_2] = var_61_10
					end
				else
					local var_61_11 = var_61_3[num_2]
					local var_61_12 = var_61_8(var_61_9, var_61_11)

					if var_61_12 ~= nil then
						var_61_3[num_2] = var_61_12
					else
						var_61_3[num_2] = nil
						num_2 = num_2 - 1
					end
				end
			else
				local var_61_13 = tbl_3[var_61_6]

				if not var_61_13 then
					local var_61_14 = var_61_4[var_61_6]

					if var_61_14 ~= nil then
						num_2 = num_2 + 1
						var_61_3[num_2] = var_61_14
					else
						local var_61_15 = var_61_13(v, k, arg_61_3 or tbl_4)

						if var_61_15 ~= nil then
							var_61_4[var_61_6] = var_61_15
							num_2 = num_2 + 1
							var_61_3[num_2] = var_61_15
						end
					end
				elseif var_61_6 ~= nil then
					num_2 = num_2 + 1
					var_61_3[num_2] = var_61_6
				end
			end
		end

		if var_61_3[1] == true then
			num = num + 1
			tbl_2[num] = table.clone(v)
		end
	end

	return tbl_2
end

BackendInterfaceCommon._infix_to_postfix_item_filter = function (arg_62_0, arg_62_1)
	-- function 62
	local tbl_2 = {}
	local tbl_3 = {}

	for iter_62_0 in string.gmatch(arg_62_1, "%S+") do
		if not tbl[iter_62_0] then
			while #tbl_3 > 0 do
				local var_62_2 = tbl_3[#tbl_3]

				if not (not tbl[var_62_2] and not (tbl[iter_62_0][1] <= tbl[var_62_2][1])) then
					tbl_2[#tbl_2 + 1] = table.remove(tbl_3)
				else
					break
				end
			end

			tbl_3[#tbl_3 + 1] = iter_62_0
		elseif iter_62_0 == "(" then
			tbl_3[#tbl_3 + 1] = "("
		elseif iter_62_0 == ")" then
			while #tbl_3 > 0 do
				if tbl_3[#tbl_3] ~= "(" then
					tbl_2[#tbl_2 + 1] = table.remove(tbl_3)
				else
					tbl_3[#tbl_3] = nil

					break
				end
			end
		else
			tbl_2[#tbl_2 + 1] = iter_62_0
		end
	end

	while #tbl_3 > 0 do
		tbl_2[#tbl_2 + 1] = table.remove(tbl_3)
	end

	for j = 1, #tbl_2 do
		local var_62_3 = tbl_2[j]

		if var_62_3 == "true" then
			tbl_2[j] = true
		elseif var_62_3 == "false" then
			tbl_2[j] = false
		elseif not tonumber(var_62_3) then
			tbl_2[j] = tonumber(var_62_3)
		end
	end

	return tbl_2
end

BackendInterfaceCommon.serialize_traits = function (arg_63_0, arg_63_1)
	-- function 63
	local str = ""

	for k, v in pairs(arg_63_1) do
		local trait_name = v.trait_name

		for k_2, v_2 in pairs(v) do
			if k_2 ~= "trait_name" then
				trait_name = trait_name .. string.format(",%s,%.3f", k_2, v_2)
			end
		end

		local str_2 = trait_name .. ";"

		str = str .. str_2
	end

	return str
end

BackendInterfaceCommon.serialize_runes = function (arg_64_0, arg_64_1)
	-- function 64
	local str = ""

	for k, v in pairs(arg_64_1) do
		local rune_slot = v.rune_slot
		local rune = v.rune
		local str_2 = rune_slot .. string.format(",%s,%.3f", rune, 0) .. ";"

		str = str .. str_2
	end

	return str
end

BackendInterfaceCommon.commit_load_time_data = function (self, arg_65_1)
	-- function 65
	if not Managers.account:offline_mode() then
		return
	end

	local human_players = Managers.player:human_players()
	local tbl = {}
	local var_65_2
	local var_65_3

	for k, v in pairs(human_players) do
		local platform_id = v:platform_id()

		if not IS_XB1 then
			platform_id = Application.hex64_to_dec(platform_id)
		end

		local cached_name = v:cached_name()

		if not (not cached_name and cached_name ~= "") then
			cached_name = v:name()
		end

		tbl[#tbl + 1] = {
			platform_id = platform_id,
			name = cached_name,
			career = v:career_name()
		}
	end

	local tbl_2 = {
		FunctionName = "reportTimer",
		FunctionParameter = {
			identifier = arg_65_1.identifier,
			duration = arg_65_1.duration,
			parameters = arg_65_1.parameters,
			players = tbl
		}
	}

	self._backend_mirror:request_queue():enqueue(tbl_2, function ()
		-- function 66
		print("Commit load time data")
	end, false)
end
