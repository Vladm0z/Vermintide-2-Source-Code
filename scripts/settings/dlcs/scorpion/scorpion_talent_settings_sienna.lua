-- chunkname: @scripts/settings/dlcs/scorpion/scorpion_talent_settings_sienna.lua

local var_0_0 = {}

TalentBuffTemplates = TalentBuffTemplates or {}
TalentBuffTemplates.bright_wizard = {}
TalentTrees = TalentTrees or {}
TalentTrees.bright_wizard = {
	{},
	{},
	{}
}
Talents.bright_wizard = {}

for iter_0_0, iter_0_1 in pairs(TalentBuffTemplates.bright_wizard) do
	local var_0_1 = iter_0_1.buffs

	fassert(#var_0_1 == 1, "talent buff has more than one sub buff, add multiple buffs from the talent instead")

	var_0_1[1].name = iter_0_0
end

BuffUtils.apply_buff_tweak_data(TalentBuffTemplates.bright_wizard, var_0_0)
