-- chunkname: @scripts/settings/dlcs/scorpion/scorpion_talent_settings_victor.lua

local var_0_0 = {}

TalentBuffTemplates = TalentBuffTemplates or {}
TalentBuffTemplates.witch_hunter = {}
TalentTrees = TalentTrees or {}
TalentTrees.witch_hunter = {
	{},
	{},
	{}
}
Talents.witch_hunter = {}

for iter_0_0, iter_0_1 in pairs(TalentBuffTemplates.witch_hunter) do
	local var_0_1 = iter_0_1.buffs

	fassert(#var_0_1 == 1, "talent buff has more than one sub buff, add multiple buffs from the talent instead")

	var_0_1[1].name = iter_0_0
end

BuffUtils.apply_buff_tweak_data(TalentBuffTemplates.witch_hunter, var_0_0)
