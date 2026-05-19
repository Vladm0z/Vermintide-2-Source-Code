-- chunkname: @scripts/helpers/breed_utils.lua

BreedUtils = {}

local var_0_0 = {
	BreedCategory.Infantry,
	BreedCategory.Armored,
	[5] = BreedCategory.Berserker,
	[6] = BreedCategory.SuperArmor
}

function BreedUtils.inject_breed_category_mask(arg_1_0)
	local var_1_0 = 0

	if arg_1_0.special then
		arg_1_0.immediate_threat = true
		var_1_0 = bit.bor(var_1_0, BreedCategory.Special)
	end

	if arg_1_0.boss then
		var_1_0 = bit.bor(var_1_0, BreedCategory.Boss)
	end

	if arg_1_0.shield_user then
		var_1_0 = bit.bor(var_1_0, BreedCategory.Shielded)
	end

	local var_1_1 = var_0_0[arg_1_0.armor_category]

	if var_1_1 and (not arg_1_0.special and not arg_1_0.boss or arg_1_0.armor_category == 2) then
		var_1_0 = bit.bor(var_1_0, var_1_1)
	end

	arg_1_0.category_mask = var_1_0
end
