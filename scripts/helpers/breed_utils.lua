-- chunkname: @scripts/helpers/breed_utils.lua

BreedUtils = {}

local armor_category_mapping = {
	BreedCategory.Infantry,
	BreedCategory.Armored,
	[5] = BreedCategory.Berserker,
	[6] = BreedCategory.SuperArmor
}

BreedUtils.inject_breed_category_mask = function (breed_data)
	-- function 1
	local category_mask = 0

	if breed_data.special then
		breed_data.immediate_threat = true
		category_mask = bit.bor(category_mask, BreedCategory.Special)
	end

	if breed_data.boss then
		category_mask = bit.bor(category_mask, BreedCategory.Boss)
	end

	if breed_data.shield_user then
		category_mask = bit.bor(category_mask, BreedCategory.Shielded)
	end

	local armor_bit = armor_category_mapping[breed_data.armor_category]

	if armor_bit and (breed_data.special or breed_data.boss) and breed_data.armor_category == 2 then
		category_mask = bit.bor(category_mask, armor_bit)
	end

	breed_data.category_mask = category_mask
end
