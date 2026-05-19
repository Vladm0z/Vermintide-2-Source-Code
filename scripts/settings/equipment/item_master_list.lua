-- chunkname: @scripts/settings/equipment/item_master_list.lua

require("foundation/scripts/util/table")
require("scripts/settings/equipment/projectile_units")
require("scripts/settings/equipment/pickups")

CanWieldAllItemTemplates = CanWieldAllItemTemplates or {}

table.append(CanWieldAllItemTemplates, {
	"bw_scholar",
	"bw_adept",
	"bw_unchained",
	"we_shade",
	"we_maidenguard",
	"we_waywatcher",
	"dr_ironbreaker",
	"dr_slayer",
	"dr_ranger",
	"wh_zealot",
	"wh_bountyhunter",
	"wh_captain",
	"es_huntsman",
	"es_knight",
	"es_mercenary",
	"empire_soldier_tutorial"
})

ItemMasertListUpdateQueue = {}

function UpdateItemMasterList(arg_1_0, arg_1_1)
	if not table.contains(CanWieldAllItemTemplates, arg_1_1) then
		table.insert(CanWieldAllItemTemplates, arg_1_1)
	end

	table.insert(ItemMasertListUpdateQueue, {
		arg_1_0,
		arg_1_1
	})
end

local_require("scripts/settings/equipment/item_master_list_local")
local_require("scripts/settings/equipment/item_master_list_exported")
local_require("scripts/settings/equipment/item_master_list_weapon_skins")
local_require("scripts/settings/equipment/item_master_list_test_items")
local_require("scripts/settings/equipment/item_master_list_steam_items")
local_require("scripts/settings/equipment/item_master_list_weapon_poses")
DLCUtils.require_list("item_master_list_file_names", true)

for iter_0_0 = 1, #ItemMasertListUpdateQueue do
	local var_0_0 = ItemMasertListUpdateQueue[iter_0_0][1]
	local var_0_1 = ItemMasertListUpdateQueue[iter_0_0][2]

	for iter_0_1 = 1, #var_0_0 do
		local var_0_2 = var_0_0[iter_0_1]
		local var_0_3 = ItemMasterList[var_0_2]

		fassert(var_0_3, "No such item %s found in item master list while trying to insert career %s", var_0_2, var_0_1)
		fassert(var_0_3.can_wield ~= CanWieldAllItemTemplates, "Trying to patch item %s that can already be wielded by all careers, you don't need to do that.", var_0_2)
		table.insert(var_0_3.can_wield, var_0_1)
	end
end

SteamitemdefidToMasterList = {}

if HAS_STEAM then
	for iter_0_2, iter_0_3 in pairs(ItemMasterList) do
		local var_0_4 = iter_0_3.steam_itemdefid

		if var_0_4 then
			fassert(SteamitemdefidToMasterList[var_0_4] == nil, "duplicated steam item server item in ItemMasterList(%s)", var_0_4)

			SteamitemdefidToMasterList[var_0_4] = iter_0_2
		end
	end
end

MagicItemByUnlockName = {}

for iter_0_4, iter_0_5 in pairs(ItemMasterList) do
	if iter_0_5.matching_item_key then
		local var_0_5 = ItemMasterList[iter_0_5.matching_item_key]

		fassert(var_0_5, "Missing matching item %s referenced by %s", iter_0_5.matching_item_key, iter_0_4)

		iter_0_5.can_wield = var_0_5.can_wield
	end

	if iter_0_5.slot_type == "hat" then
		if table.find(iter_0_5.can_wield, "bw_unchained") or table.find(iter_0_5.can_wield, "bw_adept") then
			iter_0_5.item_preview_environment = "hats_bloom_01"
		end
	elseif iter_0_5.slot_type == "weapon_skin" and string.find(iter_0_4, "_runed_") then
		iter_0_5.item_preview_object_set_name = "flow_rune_weapon_lights"
	end

	if iter_0_5.rarity == "magic" and iter_0_5.required_unlock_item and iter_0_5.item_type ~= "weapon_skin" then
		local var_0_6 = iter_0_5.required_unlock_item

		MagicItemByUnlockName[var_0_6] = iter_0_4
	end

	if iter_0_5.slot_type == "frame" then
		iter_0_5.display_unit = iter_0_5.display_unit or "units/weapons/weapon_display/display_portrait_frame"
	end
end

all_item_types = {}

function parse_item_master_list()
	for iter_2_0, iter_2_1 in pairs(ItemMasterList) do
		iter_2_1.key = iter_2_0
		iter_2_1.name = iter_2_0

		if iter_2_1.display_name then
			iter_2_1.localized_name = Localize(iter_2_1.display_name)
		else
			iter_2_1.display_name = string.format("No_display_name_for_item_%q", tostring(iter_2_0))
			iter_2_1.localized_name = "<" .. iter_2_1.display_name .. ">"
		end

		if iter_2_1.item_type then
			all_item_types[iter_2_1.item_type] = true
		end
	end
end

if Managers.localizer then
	parse_item_master_list()
end

ItemMasterListMeta = ItemMasterListMeta or {}

function ItemMasterListMeta.__index(arg_3_0, arg_3_1)
	Crashify.print_exception("[ItemMasterList]", "ItemMaster List has no item %s", arg_3_1)
end

setmetatable(ItemMasterList, ItemMasterListMeta)
