-- chunkname: @scripts/settings/dlcs/scorpion/scorpion_talent_settings_markus.lua

local var_0_0 = {}

TalentBuffTemplates = TalentBuffTemplates or {}
TalentBuffTemplates.empire_soldier = {}
TalentTrees = TalentTrees or {}
TalentTrees.empire_soldier = {
	{},
	{},
	{}
}
Talents.empire_soldier = {}

for iter_0_0, iter_0_1 in pairs(TalentBuffTemplates.empire_soldier) do
	local var_0_1 = iter_0_1.buffs

	fassert(#var_0_1 == 1, "talent buff has more than one sub buff, add multiple buffs from the talent instead")

	var_0_1[1].name = iter_0_0
end

BuffUtils.apply_buff_tweak_data(TalentBuffTemplates.empire_soldier, var_0_0)
