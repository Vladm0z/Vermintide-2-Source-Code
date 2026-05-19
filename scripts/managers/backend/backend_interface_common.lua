-- chunkname: @scripts/managers/backend/backend_interface_common.lua

BackendInterfaceCommon = class(BackendInterfaceCommon)

require("scripts/settings/equipment/weapon_skins")

function BackendInterfaceCommon.init(arg_1_0, arg_1_1)
	arg_1_0._backend_mirror = arg_1_1
end

function BackendInterfaceCommon.ready(arg_2_0)
	return true
end

function BackendInterfaceCommon.can_wield(arg_3_0, arg_3_1, arg_3_2)
	local var_3_0 = arg_3_2.can_wield

	assert(var_3_0, "BackendInterfaceCommon - Item %q has not specified what profiles that can use it.", arg_3_2.name or "(item_data missing name)")

	for iter_3_0, iter_3_1 in ipairs(var_3_0) do
		if arg_3_1 == iter_3_1 then
			return true
		end
	end
end

local var_0_0 = {
	["not"] = {
		4,
		1,
		function(arg_4_0)
			return not arg_4_0
		end
	},
	["<"] = {
		3,
		2,
		function(arg_5_0, arg_5_1)
			return arg_5_0 < arg_5_1
		end
	},
	[">"] = {
		3,
		2,
		function(arg_6_0, arg_6_1)
			return arg_6_1 < arg_6_0
		end
	},
	["<="] = {
		3,
		2,
		function(arg_7_0, arg_7_1)
			return arg_7_0 <= arg_7_1
		end
	},
	[">="] = {
		3,
		2,
		function(arg_8_0, arg_8_1)
			return arg_8_1 <= arg_8_0
		end
	},
	["~="] = {
		3,
		2,
		function(arg_9_0, arg_9_1)
			return arg_9_0 ~= arg_9_1
		end
	},
	["=="] = {
		3,
		2,
		function(arg_10_0, arg_10_1)
			return arg_10_0 == arg_10_1
		end
	},
	["and"] = {
		2,
		2,
		function(arg_11_0, arg_11_1)
			return arg_11_0 and arg_11_1
		end
	},
	["or"] = {
		1,
		2,
		function(arg_12_0, arg_12_1)
			return arg_12_0 or arg_12_1
		end
	}
}

local function var_0_1(arg_13_0)
	return function(arg_14_0, arg_14_1)
		local var_14_0 = SPProfiles[FindProfileIndex(arg_13_0)].careers

		for iter_14_0, iter_14_1 in ipairs(var_14_0) do
			if table.contains(arg_14_0.data.can_wield, iter_14_1.name) then
				return true
			end
		end

		return false
	end
end

local function var_0_2(arg_15_0)
	return function(arg_16_0, arg_16_1)
		return table.contains(arg_16_0.data.can_wield, arg_15_0)
	end
end

local var_0_3 = {}
local var_0_4 = {
	item_key = function(arg_17_0, arg_17_1)
		return arg_17_0.data.key
	end,
	item_rarity = function(arg_18_0, arg_18_1)
		local var_18_0 = arg_18_0.data

		return (Managers.backend:get_interface("items"):get_item_rarity(arg_18_1))
	end,
	slot_type = function(arg_19_0, arg_19_1)
		return arg_19_0.data.slot_type
	end,
	item_type = function(arg_20_0, arg_20_1)
		return arg_20_0.data.item_type
	end,
	selection = function(arg_21_0, arg_21_1)
		return arg_21_0.data.selection
	end,
	default_selection = function(arg_22_0, arg_22_1)
		local var_22_0 = arg_22_0.data

		return var_22_0.selection == "default" or var_22_0.selection == nil
	end,
	is_pactsworn_item = function(arg_23_0, arg_23_1)
		local var_23_0 = false
		local var_23_1 = arg_23_0.data
		local var_23_2 = var_23_1.can_wield

		if var_23_2 ~= CanWieldAllItemTemplates and (var_23_1.item_type == "skin" or var_23_1.item_type == "cosmetic_bundle") then
			for iter_23_0 = 1, #var_23_2 do
				local var_23_3 = var_23_2[iter_23_0]

				if PROFILES_BY_CAREER_NAMES[var_23_3].affiliation == "dark_pact" then
					var_23_0 = true

					break
				end
			end
		end

		return var_23_0
	end,
	chest_categories = function(arg_24_0, arg_24_1)
		return arg_24_0.data.chest_categories
	end,
	discounted_items = function(arg_25_0, arg_25_1)
		local var_25_0 = arg_25_0.data
		local var_25_1 = var_25_0.key
		local var_25_2 = Managers.backend:get_interface("peddler")
		local var_25_3 = var_25_0.steam_itemdefid

		if HAS_STEAM and var_25_3 then
			local var_25_4 = arg_25_0.steam_data

			if var_25_4 and var_25_4.discount_is_active then
				return true
			end
		end

		return var_25_2:is_discounted_shilling_item(var_25_1)
	end,
	is_weapon = function(arg_26_0, arg_26_1)
		local var_26_0 = arg_26_0.data.slot_type

		return var_26_0 == "melee" or var_26_0 == "ranged"
	end,
	equipped_by_current_career = function(arg_27_0, arg_27_1, arg_27_2)
		local var_27_0 = arg_27_0.data
		local var_27_1 = Managers.state.network.profile_synchronizer
		local var_27_2

		if arg_27_2 and arg_27_2.player then
			var_27_2 = arg_27_2.player
		else
			var_27_2 = Managers.player:local_player()
		end

		if not var_27_2 then
			return false
		end

		local var_27_3 = var_27_2:profile_index()

		if not var_27_3 or var_27_3 == 0 then
			return false
		end

		local var_27_4 = var_27_2:career_index()

		if not var_27_4 or var_27_4 == 0 then
			return false
		end

		local var_27_5 = SPProfiles[var_27_3].careers[var_27_4].name
		local var_27_6 = Managers.backend:get_interface("items"):equipped_by(arg_27_1)

		return table.contains(var_27_6, var_27_5)
	end,
	is_equipped = function(arg_28_0, arg_28_1)
		local var_28_0 = arg_28_0.data

		if #Managers.backend:get_interface("items"):equipped_by(arg_28_1) > 0 then
			return true
		end

		return false
	end,
	is_equipped_by_any_loadout = function(arg_29_0, arg_29_1)
		local var_29_0 = arg_29_0.data

		if #Managers.backend:get_interface("items"):is_equipped_by_any_loadout(arg_29_1) > 0 then
			return true
		end

		return false
	end,
	is_equipment_slot = function(arg_30_0, arg_30_1)
		local var_30_0 = arg_30_0.data
		local var_30_1 = false

		for iter_30_0, iter_30_1 in ipairs(InventorySettings.equipment_slots) do
			if var_30_0.slot_type == iter_30_1.type then
				var_30_1 = true

				break
			end
		end

		return var_30_1
	end,
	current_hero = function(arg_31_0, arg_31_1)
		local var_31_0 = arg_31_0.data
		local var_31_1 = Managers.state.network.profile_synchronizer
		local var_31_2 = Managers.player:local_player()
		local var_31_3 = var_31_1:profile_by_peer(var_31_2:network_id(), var_31_2:local_player_id())

		return SPProfiles[var_31_3].display_name
	end,
	can_wield_by_current_career = function(arg_32_0, arg_32_1, arg_32_2)
		local var_32_0 = arg_32_0.data
		local var_32_1 = Managers.state.network.profile_synchronizer
		local var_32_2 = Managers.player:local_player()
		local var_32_3 = arg_32_2 and arg_32_2.profile_index or var_32_2:profile_index()
		local var_32_4 = arg_32_2 and arg_32_2.career_index or var_32_2:career_index()
		local var_32_5 = SPProfiles[var_32_3].careers[var_32_4].name
		local var_32_6 = var_32_0.can_wield

		return table.contains(var_32_6, var_32_5)
	end,
	can_wield_by_current_hero = function(arg_33_0, arg_33_1, arg_33_2)
		local var_33_0 = arg_33_0.data
		local var_33_1 = Managers.state.network.profile_synchronizer
		local var_33_2 = Managers.player:local_player()
		local var_33_3 = arg_33_2 and arg_33_2.profile_index or var_33_2:profile_index()

		if not arg_33_2 or not arg_33_2.career_index then
			local var_33_4 = var_33_2:career_index()
		end

		local var_33_5 = SPProfiles[var_33_3].careers
		local var_33_6 = var_33_0.can_wield

		for iter_33_0, iter_33_1 in ipairs(var_33_5) do
			local var_33_7 = iter_33_1.name

			if table.contains(var_33_6, var_33_7) then
				return true
			end
		end

		return false
	end,
	is_new = function(arg_34_0, arg_34_1)
		return PlayerData.new_item_ids[arg_34_1]
	end,
	is_plentiful = function(arg_35_0, arg_35_1)
		return Managers.backend:get_interface("items"):get_item_rarity(arg_35_1) == "plentiful"
	end,
	is_common = function(arg_36_0, arg_36_1)
		return Managers.backend:get_interface("items"):get_item_rarity(arg_36_1) == "common"
	end,
	is_rare = function(arg_37_0, arg_37_1)
		return Managers.backend:get_interface("items"):get_item_rarity(arg_37_1) == "rare"
	end,
	is_exotic = function(arg_38_0, arg_38_1)
		return Managers.backend:get_interface("items"):get_item_rarity(arg_38_1) == "exotic"
	end,
	is_unique = function(arg_39_0, arg_39_1)
		return Managers.backend:get_interface("items"):get_item_rarity(arg_39_1) == "unique"
	end,
	is_promo = function(arg_40_0, arg_40_1)
		return Managers.backend:get_interface("items"):get_item_rarity(arg_40_1) == "promo"
	end,
	is_default = function(arg_41_0, arg_41_1)
		return Managers.backend:get_interface("items"):get_item_rarity(arg_41_1) == "default"
	end,
	is_magic = function(arg_42_0, arg_42_1)
		return Managers.backend:get_interface("items"):get_item_rarity(arg_42_1) == "magic"
	end,
	is_event = function(arg_43_0, arg_43_1)
		return Managers.backend:get_interface("items"):get_item_rarity(arg_43_1) == "event"
	end,
	can_wield_bright_wizard = var_0_1("bright_wizard"),
	can_wield_bw_scholar = var_0_2("bw_scholar"),
	can_wield_bw_adept = var_0_2("bw_adept"),
	can_wield_bw_unchained = var_0_2("bw_unchained"),
	can_wield_bw_necromancer = var_0_2("bw_necromancer"),
	can_wield_dwarf_ranger = var_0_1("dwarf_ranger"),
	can_wield_dr_ironbreaker = var_0_2("dr_ironbreaker"),
	can_wield_dr_slayer = var_0_2("dr_slayer"),
	can_wield_dr_ranger = var_0_2("dr_ranger"),
	can_wield_dr_engineer = var_0_2("dr_engineer"),
	can_wield_empire_soldier = var_0_1("empire_soldier"),
	can_wield_es_huntsman = var_0_2("es_huntsman"),
	can_wield_es_knight = var_0_2("es_knight"),
	can_wield_es_mercenary = var_0_2("es_mercenary"),
	can_wield_es_questingknight = var_0_2("es_questingknight"),
	can_wield_witch_hunter = var_0_1("witch_hunter"),
	can_wield_wh_captain = var_0_2("wh_captain"),
	can_wield_wh_bountyhunter = var_0_2("wh_bountyhunter"),
	can_wield_wh_zealot = var_0_2("wh_zealot"),
	can_wield_wh_priest = var_0_2("wh_priest"),
	can_wield_wood_elf = var_0_1("wood_elf"),
	can_wield_we_waywatcher = var_0_2("we_waywatcher"),
	can_wield_we_maidenguard = var_0_2("we_maidenguard"),
	can_wield_we_shade = var_0_2("we_shade"),
	can_wield_we_thornsister = var_0_2("we_thornsister"),
	player_owns_item_key = function(arg_44_0, arg_44_1)
		local var_44_0 = arg_44_0.data
		local var_44_1 = Managers.backend:get_interface("items"):get_all_backend_items()

		for iter_44_0, iter_44_1 in pairs(var_44_1) do
			if var_44_0.key == iter_44_1.key then
				return true
			end
		end

		return false
	end,
	can_salvage = function(arg_45_0, arg_45_1)
		local var_45_0 = arg_45_0.data.slot_type

		if var_45_0 == "ranged" or var_45_0 == "melee" or var_45_0 == "ring" or var_45_0 == "necklace" or var_45_0 == "trinket" then
			local var_45_1 = Managers.backend:get_interface("items")
			local var_45_2 = var_45_1:get_item_rarity(arg_45_1)

			if var_45_2 ~= "default" and var_45_2 ~= "promo" and var_45_2 ~= "magic" and #var_45_1:equipped_by(arg_45_1) == 0 then
				return not ItemHelper.is_favorite_backend_id(arg_45_1, arg_45_0)
			end
		end

		return false
	end,
	has_properties = function(arg_46_0, arg_46_1)
		if arg_46_0.properties then
			return true
		end

		return false
	end,
	has_traits = function(arg_47_0, arg_47_1)
		if arg_47_0.traits then
			return true
		end

		return false
	end,
	has_applied_skin = function(arg_48_0, arg_48_1)
		local var_48_0 = arg_48_0.data.slot_type

		if arg_48_0.skin and var_48_0 ~= "weapon_skin" then
			return true
		end

		return false
	end,
	can_apply_skin = function(arg_49_0, arg_49_1)
		local var_49_0 = arg_49_0.data
		local var_49_1 = var_49_0.slot_type

		if var_49_1 == "ranged" or var_49_1 == "melee" then
			if Managers.backend:get_interface("items"):get_item_rarity(arg_49_1) == "magic" then
				return false
			end

			local var_49_2 = Managers.backend:get_interface("crafting")
			local var_49_3 = var_49_0.skin_combination_table

			if var_49_3 then
				local var_49_4 = WeaponSkins.skin_combinations[var_49_3]
				local var_49_5 = var_49_2:get_unlocked_weapon_skins()

				if var_49_5[WeaponSkins.default_skins[arg_49_0.ItemId]] then
					return true
				end

				for iter_49_0, iter_49_1 in pairs(var_49_4) do
					for iter_49_2, iter_49_3 in ipairs(iter_49_1) do
						if var_49_5[iter_49_3] then
							return true
						end
					end
				end
			end
		end

		return false
	end,
	can_upgrade = function(arg_50_0, arg_50_1)
		local var_50_0 = arg_50_0.data.slot_type

		if var_50_0 == "ranged" or var_50_0 == "melee" or var_50_0 == "ring" or var_50_0 == "necklace" or var_50_0 == "trinket" then
			local var_50_1 = Managers.backend:get_interface("items"):get_item_rarity(arg_50_1)

			if var_50_1 == "plentiful" or var_50_1 == "common" or var_50_1 == "rare" or var_50_1 == "exotic" then
				return true
			end
		end
	end,
	can_craft_with = function(arg_51_0, arg_51_1)
		local var_51_0 = arg_51_0.data.slot_type

		if (var_51_0 == "ranged" or var_51_0 == "melee" or var_51_0 == "ring" or var_51_0 == "necklace" or var_51_0 == "trinket") and Managers.backend:get_interface("items"):get_item_rarity(arg_51_1) == "default" then
			return true
		end
	end,
	available_in_mechanism_versus = function(arg_52_0, arg_52_1)
		local var_52_0 = arg_52_0.data
		local var_52_1 = var_52_0.mechanisms

		return table.contains({
			"hat",
			"weapon_skin",
			"frame",
			"skin",
			"weapon_pose"
		}, var_52_0.slot_type) or var_52_1 and table.contains(var_52_1, "versus")
	end,
	available_in_mechanism_adventure = function(arg_53_0, arg_53_1)
		local var_53_0 = arg_53_0.data
		local var_53_1 = var_53_0.mechanisms

		return table.contains({
			"hat",
			"weapon_skin",
			"frame",
			"skin",
			"weapon_pose"
		}, var_53_0.slot_type) or not var_53_1 or table.contains(var_53_1, "adventure")
	end,
	available_in_current_mechanism = function(arg_54_0, arg_54_1)
		if script_data.disable_mechanism_item_filter then
			return true
		end

		local var_54_0 = arg_54_0.data
		local var_54_1 = var_54_0.mechanisms
		local var_54_2 = Managers.mechanism:current_mechanism_name()

		if table.contains({
			"hat",
			"weapon_skin",
			"frame",
			"skin",
			"weapon_pose"
		}, var_54_0.slot_type) then
			return true
		end

		if LoadoutUtils.is_item_disabled(arg_54_0.ItemId) then
			return false
		end

		local var_54_3 = var_54_1 and table.contains(var_54_1, var_54_2)
		local var_54_4 = not var_54_1 and Managers.mechanism:mechanism_setting("default_inventory")

		return var_54_3 or var_54_4 or false
	end,
	owned = function(arg_55_0, arg_55_1)
		return arg_55_0.owned
	end,
	is_fake_item = function(arg_56_0, arg_56_1)
		if Managers.backend:get_interface("items"):get_all_fake_backend_items()[arg_56_1] then
			return true
		end
	end,
	gather_weapon_pose_blueprints = function(arg_57_0, arg_57_1, arg_57_2)
		local var_57_0 = arg_57_0.data.slot_type

		if var_57_0 == "melee" or var_57_0 == "ranged" then
			local var_57_1 = Managers.backend:get_interface("items")

			if var_57_1:get_item_rarity(arg_57_1) == "default" then
				local var_57_2 = var_57_1:get_unlocked_weapon_poses()[string.gsub(arg_57_0.ItemId, "^vs_", "")] or var_0_3

				return not table.is_empty(var_57_2)
			end
		end

		return false
	end,
	weapon_pose_parent = function(arg_58_0, arg_58_1)
		local var_58_0 = arg_58_0.data

		if var_58_0.slot_type == "weapon_pose" then
			return var_58_0.parent
		end
	end,
	is_event_item = function(arg_59_0, arg_59_1)
		return not not arg_59_0.data.events
	end,
	is_active_event_item = function(arg_60_0, arg_60_1)
		local var_60_0 = false
		local var_60_1 = arg_60_0.data.events

		if var_60_1 then
			local var_60_2 = Managers.backend:get_interface("live_events")
			local var_60_3 = var_60_2 and var_60_2:get_active_events()

			if var_60_3 then
				local var_60_4 = false

				for iter_60_0 = 1, #var_60_1 do
					local var_60_5 = var_60_1[iter_60_0]

					if not not table.find(var_60_3, var_60_5) == true then
						var_60_0 = true

						break
					end
				end
			end
		end

		return var_60_0
	end
}

BackendInterfaceCommon.filter_postfix_cache = BackendInterfaceCommon.filter_postfix_cache or {}

local var_0_5 = {}
local var_0_6 = {}
local var_0_7 = {}

function BackendInterfaceCommon.filter_items(arg_61_0, arg_61_1, arg_61_2, arg_61_3)
	local var_61_0 = BackendInterfaceCommon.filter_postfix_cache[arg_61_2]

	if not var_61_0 then
		var_61_0 = arg_61_0:_infix_to_postfix_item_filter(arg_61_2)
		BackendInterfaceCommon.filter_postfix_cache[arg_61_2] = var_61_0
	end

	local var_61_1 = {}
	local var_61_2 = 0
	local var_61_3 = var_0_6
	local var_61_4 = var_0_7

	for iter_61_0, iter_61_1 in pairs(arg_61_1) do
		table.clear(var_61_3)
		table.clear(var_61_4)

		local var_61_5 = 0

		for iter_61_2 = 1, #var_61_0 do
			local var_61_6 = var_61_0[iter_61_2]

			if var_0_0[var_61_6] then
				local var_61_7 = var_0_0[var_61_6][2]
				local var_61_8 = var_0_0[var_61_6][3]
				local var_61_9 = var_61_3[var_61_5]

				var_61_3[var_61_5] = nil
				var_61_5 = var_61_5 - 1

				if var_61_7 == 1 then
					local var_61_10 = var_61_8(var_61_9)

					if var_61_10 ~= nil then
						var_61_5 = var_61_5 + 1
						var_61_3[var_61_5] = var_61_10
					end
				else
					local var_61_11 = var_61_3[var_61_5]
					local var_61_12 = var_61_8(var_61_9, var_61_11)

					if var_61_12 ~= nil then
						var_61_3[var_61_5] = var_61_12
					else
						var_61_3[var_61_5] = nil
						var_61_5 = var_61_5 - 1
					end
				end
			else
				local var_61_13 = var_0_4[var_61_6]

				if var_61_13 then
					local var_61_14 = var_61_4[var_61_6]

					if var_61_14 ~= nil then
						var_61_5 = var_61_5 + 1
						var_61_3[var_61_5] = var_61_14
					else
						local var_61_15 = var_61_13(iter_61_1, iter_61_0, arg_61_3 or var_0_5)

						if var_61_15 ~= nil then
							var_61_4[var_61_6] = var_61_15
							var_61_5 = var_61_5 + 1
							var_61_3[var_61_5] = var_61_15
						end
					end
				elseif var_61_6 ~= nil then
					var_61_5 = var_61_5 + 1
					var_61_3[var_61_5] = var_61_6
				end
			end
		end

		if var_61_3[1] == true then
			var_61_2 = var_61_2 + 1
			var_61_1[var_61_2] = table.clone(iter_61_1)
		end
	end

	return var_61_1
end

function BackendInterfaceCommon._infix_to_postfix_item_filter(arg_62_0, arg_62_1)
	local var_62_0 = {}
	local var_62_1 = {}

	for iter_62_0 in string.gmatch(arg_62_1, "%S+") do
		if var_0_0[iter_62_0] then
			while #var_62_1 > 0 do
				local var_62_2 = var_62_1[#var_62_1]

				if var_0_0[var_62_2] and var_0_0[iter_62_0][1] <= var_0_0[var_62_2][1] then
					var_62_0[#var_62_0 + 1] = table.remove(var_62_1)
				else
					break
				end
			end

			var_62_1[#var_62_1 + 1] = iter_62_0
		elseif iter_62_0 == "(" then
			var_62_1[#var_62_1 + 1] = "("
		elseif iter_62_0 == ")" then
			while #var_62_1 > 0 do
				if var_62_1[#var_62_1] ~= "(" then
					var_62_0[#var_62_0 + 1] = table.remove(var_62_1)
				else
					var_62_1[#var_62_1] = nil

					break
				end
			end
		else
			var_62_0[#var_62_0 + 1] = iter_62_0
		end
	end

	while #var_62_1 > 0 do
		var_62_0[#var_62_0 + 1] = table.remove(var_62_1)
	end

	for iter_62_1 = 1, #var_62_0 do
		local var_62_3 = var_62_0[iter_62_1]

		if var_62_3 == "true" then
			var_62_0[iter_62_1] = true
		elseif var_62_3 == "false" then
			var_62_0[iter_62_1] = false
		elseif tonumber(var_62_3) then
			var_62_0[iter_62_1] = tonumber(var_62_3)
		end
	end

	return var_62_0
end

function BackendInterfaceCommon.serialize_traits(arg_63_0, arg_63_1)
	local var_63_0 = ""

	for iter_63_0, iter_63_1 in pairs(arg_63_1) do
		local var_63_1 = iter_63_1.trait_name

		for iter_63_2, iter_63_3 in pairs(iter_63_1) do
			if iter_63_2 ~= "trait_name" then
				var_63_1 = var_63_1 .. string.format(",%s,%.3f", iter_63_2, iter_63_3)
			end
		end

		local var_63_2 = var_63_1 .. ";"

		var_63_0 = var_63_0 .. var_63_2
	end

	return var_63_0
end

function BackendInterfaceCommon.serialize_runes(arg_64_0, arg_64_1)
	local var_64_0 = ""

	for iter_64_0, iter_64_1 in pairs(arg_64_1) do
		local var_64_1 = iter_64_1.rune_slot
		local var_64_2 = iter_64_1.rune
		local var_64_3 = var_64_1 .. string.format(",%s,%.3f", var_64_2, 0) .. ";"

		var_64_0 = var_64_0 .. var_64_3
	end

	return var_64_0
end

function BackendInterfaceCommon.commit_load_time_data(arg_65_0, arg_65_1)
	if Managers.account:offline_mode() then
		return
	end

	local var_65_0 = Managers.player:human_players()
	local var_65_1 = {}
	local var_65_2
	local var_65_3

	for iter_65_0, iter_65_1 in pairs(var_65_0) do
		local var_65_4 = iter_65_1:platform_id()

		if not IS_XB1 then
			var_65_4 = Application.hex64_to_dec(var_65_4)
		end

		local var_65_5 = iter_65_1:cached_name()

		if not var_65_5 or var_65_5 == "" then
			var_65_5 = iter_65_1:name()
		end

		var_65_1[#var_65_1 + 1] = {
			platform_id = var_65_4,
			name = var_65_5,
			career = iter_65_1:career_name()
		}
	end

	local var_65_6 = {
		FunctionName = "reportTimer",
		FunctionParameter = {
			identifier = arg_65_1.identifier,
			duration = arg_65_1.duration,
			parameters = arg_65_1.parameters,
			players = var_65_1
		}
	}

	arg_65_0._backend_mirror:request_queue():enqueue(var_65_6, function()
		print("Commit load time data")
	end, false)
end
