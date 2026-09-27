-- chunkname: @scripts/helpers/breed_utils.lua

BreedUtils = {}

local tbl = {
	BreedCategory.Infantry,
	BreedCategory.Armored,
	[5] = BreedCategory.Berserker,
	[6] = BreedCategory.SuperArmor
}

BreedUtils.inject_breed_category_mask = function (self)
	-- function 1
	local num = 0

	if not self.special then
		self.immediate_threat = true
		num = bit.bor(num, BreedCategory.Special)
	end

	if not self.boss then
		num = bit.bor(num, BreedCategory.Boss)
	end

	if not self.shield_user then
		num = bit.bor(num, BreedCategory.Shielded)
	end

	local var_1_1 = tbl[self.armor_category]

	if not (not var_1_1 and self.special or not self.boss or self.armor_category ~= 2) then
		num = bit.bor(num, var_1_1)
	end

	self.category_mask = num
end
