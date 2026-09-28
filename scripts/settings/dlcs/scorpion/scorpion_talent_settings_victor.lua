-- chunkname: @scripts/settings/dlcs/scorpion/scorpion_talent_settings_victor.lua

local buff_tweak_data = {}
local TalentBuffTemplates = TalentBuffTemplates

TalentBuffTemplates = not not TalentBuffTemplates or not not {}
TalentBuffTemplates = TalentBuffTemplates
TalentBuffTemplates.witch_hunter = {}

local TalentTrees = TalentTrees

TalentTrees = not not TalentTrees or not not {}
TalentTrees = TalentTrees
TalentTrees.witch_hunter = {
	{},
	{},
	{}
}
Talents.witch_hunter = {}

for name, data in pairs(TalentBuffTemplates.witch_hunter) do
	local buffs = data.buffs

	fassert(#buffs == 1, "talent buff has more than one sub buff, add multiple buffs from the talent instead")

	local buff = buffs[1]

	buff.name = name
end

BuffUtils.apply_buff_tweak_data(TalentBuffTemplates.witch_hunter, buff_tweak_data)
