-- chunkname: @scripts/settings/equipment/item_master_list.lua

require("foundation/scripts/util/table")
require("scripts/settings/equipment/projectile_units")
require("scripts/settings/equipment/pickups")

local CanWieldAllItemTemplates = CanWieldAllItemTemplates

CanWieldAllItemTemplates = CanWieldAllItemTemplates or {}
CanWieldAllItemTemplates = CanWieldAllItemTemplates

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
	-- function 1
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

for i = 1, #ItemMasertListUpdateQueue do
	local var_0_1 = ItemMasertListUpdateQueue[i][1]
	local var_0_2 = ItemMasertListUpdateQueue[i][2]

	for j = 1, #var_0_1 do
		local var_0_3 = var_0_1[j]
		local var_0_4 = ItemMasterList[var_0_3]

		fassert(var_0_4, "No such item %s found in item master list while trying to insert career %s", var_0_3, var_0_2)
		fassert(var_0_4.can_wield ~= CanWieldAllItemTemplates, "Trying to patch item %s that can already be wielded by all careers, you don't need to do that.", var_0_3)
		table.insert(var_0_4.can_wield, var_0_2)
	end
end

SteamitemdefidToMasterList = {}

if not HAS_STEAM then
	for k, v in pairs(ItemMasterList) do
		local steam_itemdefid = v.steam_itemdefid

		if not steam_itemdefid then
			fassert(SteamitemdefidToMasterList[steam_itemdefid] == nil, "duplicated steam item server item in ItemMasterList(%s)", steam_itemdefid)

			SteamitemdefidToMasterList[steam_itemdefid] = k
		end
	end
end

MagicItemByUnlockName = {}

for k_2, v_2 in pairs(ItemMasterList) do
	if not v_2.matching_item_key then
		local var_0_6 = ItemMasterList[v_2.matching_item_key]

		fassert(var_0_6, "Missing matching item %s referenced by %s", v_2.matching_item_key, k_2)

		v_2.can_wield = var_0_6.can_wield
	end

	if v_2.slot_type == "hat" then
		if table.find(v_2.can_wield, "bw_unchained") or not table.find(v_2.can_wield, "bw_adept") then
			v_2.item_preview_environment = "hats_bloom_01"
		end
	elseif v_2.slot_type ~= "weapon_skin" or not string.find(k_2, "_runed_") then
		v_2.item_preview_object_set_name = "flow_rune_weapon_lights"
	end

	if not ((v_2.rarity ~= "magic" or not v_2.required_unlock_item) and v_2.item_type == "weapon_skin") then
		local required_unlock_item = v_2.required_unlock_item

		MagicItemByUnlockName[required_unlock_item] = k_2
	end

	if v_2.slot_type == "frame" then
		local display_unit = v_2.display_unit

		display_unit = display_unit or "units/weapons/weapon_display/display_portrait_frame"
		v_2.display_unit = display_unit
	end
end

all_item_types = {}

function parse_item_master_list()
	-- function 2
	for k, v in pairs(ItemMasterList) do
		v.key = k
		v.name = k

		if not v.display_name then
			v.localized_name = Localize(v.display_name)
		else
			v.display_name = string.format("No_display_name_for_item_%q", tostring(k))
			v.localized_name = "<" .. v.display_name .. ">"
		end

		if not v.item_type then
			all_item_types[v.item_type] = true
		end
	end
end

if not Managers.localizer then
	parse_item_master_list()
end

local ItemMasterListMeta = ItemMasterListMeta

ItemMasterListMeta = ItemMasterListMeta or {}
ItemMasterListMeta = ItemMasterListMeta

ItemMasterListMeta.__index = function (arg_3_0, arg_3_1)
	-- function 3
	Crashify.print_exception("[ItemMasterList]", "ItemMaster List has no item %s", arg_3_1)
end

setmetatable(ItemMasterList, ItemMasterListMeta)
