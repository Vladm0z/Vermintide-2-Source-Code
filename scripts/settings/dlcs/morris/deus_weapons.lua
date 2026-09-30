-- chunkname: @scripts/settings/dlcs/morris/deus_weapons.lua

local property_table_mapping = {
	melee = "deus_melee",
	ranged = "deus_ranged"
}
local trait_table_mapping = {
	melee = "deus_melee",
	trollhammer_torpedo = "deus_trollhammer_torpedo",
	ranged_energy = "deus_ranged_energy",
	ranged_heat = "deus_ranged_heat",
	ranged_ammo = "deus_ranged_ammo"
}

DeusWeapons = DeusWeapons
DeusDefaultLoadout = DeusDefaultLoadout
DeusStartingWeaponTypeMapping = DeusStartingWeaponTypeMapping
DeusWeaponGroups = DeusWeaponGroups
DeusWeaponArchetypes = DeusWeaponArchetypes
DeusSlotChance = DeusSlotChance
DeusDropRarityWeights = DeusDropRarityWeights
DeusStarterWeaponPowerLevels = DeusStarterWeaponPowerLevels
DeusDropPowerlevelRanges = DeusDropPowerlevelRanges

for _, data in pairs(DeusWeapons) do
	local base_item = ItemMasterList[data.base_item]

	data.property_table_name = data.property_table_name
	data.trait_table_name = data.trait_table_name

	local trait_combinations = WeaponTraits.combinations[data.trait_table_name]
	local baked_trait_combinations = {}

	for _, combination in ipairs(trait_combinations) do
		local valid = true

		for _, trait_name in ipairs(combination) do
			local trait_data = WeaponTraits.traits[trait_name]

			valid = valid and (not trait_data.compatible_weapon_list or trait_data.compatible_weapon_list[data.base_item])
		end

		if valid then
			baked_trait_combinations[#baked_trait_combinations + 1] = combination
		end
	end

	data.baked_trait_combinations = baked_trait_combinations
end

fassert(DeusStarterWeaponPowerLevels.default, "DeusStarterWeaponPowerLevels must define a default config")

local rarities = {
	"plentiful",
	"common",
	"rare",
	"exotic",
	"unique"
}

fassert(DeusDropRarityWeights.default, "DeusDropRarityWeights must define a default config")

for _, config in pairs(DeusDropRarityWeights) do
	for _, rarity in ipairs(rarities) do
		fassert(config[rarity], "DeusDropRarityWeights must contains config for '" .. rarity .. "'")
	end

	local count

	for rarity, weights in pairs(config) do
		fassert(not count or #weights == count, "DeusDropRarityWeights weights must all have the same ammount, '" .. rarity .. "' has a different weight count")

		count = #weights
	end
end

fassert(DeusDropPowerlevelRanges.default, "DeusDropPowerlevelRanges must define a default config")

for _, config in pairs(DeusDropPowerlevelRanges) do
	for _, rarity in ipairs(rarities) do
		fassert(config[rarity], "DeusDropPowerlevelRanges must contains config for '" .. rarity .. "'")
	end

	for rarity, weights in pairs(config) do
		fassert(#weights == 2, "DeusDropPowerlevelRanges weights must define only 2 values, a min and a max, '" .. rarity .. "' has a different weight count")
	end
end

for key, item in pairs(DeusWeapons) do
	fassert(item.base_item, "DeusWeapon " .. key .. " must provide a base_item.")
	fassert(ItemMasterList[item.base_item], "DeusWeapon " .. key .. " must provide a base_item that exists in the base game ItemMasterList.")

	if item.archetypes then
		fassert(not item.fixed_traits, "DeusWeapons item " .. key .. " provides fixed traits and archetypes. Provide only one or the other.")
		fassert(not item.fixed_properties, "DeusWeapons item " .. key .. " provides fixed properties and archetypes. Provide only one or the other.")

		for i, archetype in ipairs(item.archetypes) do
			fassert(DeusWeaponArchetypes[archetype], "DeusWeapons item " .. key .. " deus_archetype " .. archetype .. " is not defined in DeusWeaponArchetypes")
		end
	end
end

for group_key, group in pairs(DeusWeaponGroups) do
	fassert(group.default, "DeusWeaponGroup " .. group_key .. " needs to have a default item defined")
	fassert(DeusWeapons[group.default], "DeusWeaponGroup " .. group_key .. " default item not found in DeusWeapons")
	fassert(group.can_wield, "DeusWeaponGroup " .. group_key .. " needs to have can_wield defined")
	fassert(group.slot_type, "DeusWeaponGroup " .. group_key .. " needs to have slot_type defined")

	if group.items_per_rarity then
		for _, items in pairs(group.items_per_rarity) do
			for i, item_key in ipairs(items) do
				local deus_item_data = DeusWeapons[item_key]

				fassert(deus_item_data, "DeusWeaponGroup " .. group_key .. " item " .. item_key .. " not found in DeusWeapons")

				local base_item_data = ItemMasterList[deus_item_data.base_item]

				table.sort(base_item_data.can_wield)
				table.sort(group.can_wield)
				fassert(table.compare(base_item_data.can_wield, group.can_wield), "DeusWeaponGroup " .. group_key .. " " .. table.tostring(base_item_data.can_wield) .. " item " .. item_key .. " " .. table.tostring(group.can_wield) .. " has mismatching can_wield")
			end
		end
	end
end

local function readonlytable(table)
	-- function 1
	return setmetatable(table, {
		__newindex = function (table, key, value)
			-- function 2
			error("Trying to modify read only table. (debug only assert)")
		end
	})
end

readonlytable(DeusDefaultLoadout)
readonlytable(DeusDropPowerlevelRanges)
readonlytable(DeusDropRarityWeights)
readonlytable(DeusSlotChance)
readonlytable(DeusStarterWeaponPowerLevels)
readonlytable(DeusStartingWeaponTypeMapping)
readonlytable(DeusWeaponArchetypes)
readonlytable(DeusWeaponGroups)
readonlytable(DeusWeapons)
