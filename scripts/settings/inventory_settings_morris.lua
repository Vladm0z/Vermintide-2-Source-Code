-- chunkname: @scripts/settings/inventory_settings_morris.lua

local var_0_0 = {
	"dr_deus_01",
	"es_deus_01",
	"bw_deus_01",
	"wh_deus_01",
	"we_deus_01"
}
local var_0_1 = {
	slot_level_event = {
		drop_reasons = {
			deus_cursed_chest = true,
			deus_weapon_chest = true
		}
	}
}

for iter_0_0, iter_0_1 in pairs(InventorySettings.slots) do
	local var_0_2 = var_0_1[iter_0_1.name]

	if var_0_2 then
		table.merge_recursive(iter_0_1, var_0_2)
	end
end

table.merge_recursive(InventorySettings.item_types, var_0_0)
