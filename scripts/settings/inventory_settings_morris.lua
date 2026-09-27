-- chunkname: @scripts/settings/inventory_settings_morris.lua

local tbl = {
	"dr_deus_01",
	"es_deus_01",
	"bw_deus_01",
	"wh_deus_01",
	"we_deus_01"
}
local tbl_2 = {
	slot_level_event = {
		drop_reasons = {
			deus_cursed_chest = true,
			deus_weapon_chest = true
		}
	}
}

for k, v in pairs(InventorySettings.slots) do
	local var_0_2 = tbl_2[v.name]

	if not var_0_2 then
		table.merge_recursive(v, var_0_2)
	end
end

table.merge_recursive(InventorySettings.item_types, tbl)
