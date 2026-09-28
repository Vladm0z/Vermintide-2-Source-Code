-- chunkname: @scripts/settings/dlcs/scorpion/scorpion_talent_settings_sienna.lua

local buff_tweak_data = {}
local TalentBuffTemplates = TalentBuffTemplates

TalentBuffTemplates = not not TalentBuffTemplates or not not {}
TalentBuffTemplates = TalentBuffTemplates
TalentBuffTemplates.bright_wizard = {}

local TalentTrees = TalentTrees

TalentTrees = not not TalentTrees or not not {}
TalentTrees = TalentTrees
TalentTrees.bright_wizard = {
	{},
	{},
	{}
}
Talents.bright_wizard = {}

for name, data in pairs(TalentBuffTemplates.bright_wizard) do
	local buffs = data.buffs

	fassert(#buffs == 1, "talent buff has more than one sub buff, add multiple buffs from the talent instead")

	local buff = buffs[1]

	buff.name = name
end

BuffUtils.apply_buff_tweak_data(TalentBuffTemplates.bright_wizard, buff_tweak_data)
