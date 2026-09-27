-- chunkname: @scripts/settings/dlcs/scorpion/scorpion_talent_settings_sienna.lua

local tbl = {}
local TalentBuffTemplates = TalentBuffTemplates

TalentBuffTemplates = TalentBuffTemplates or {}
TalentBuffTemplates = TalentBuffTemplates
TalentBuffTemplates.bright_wizard = {}

local TalentTrees = TalentTrees

TalentTrees = TalentTrees or {}
TalentTrees = TalentTrees
TalentTrees.bright_wizard = {
	{},
	{},
	{}
}
Talents.bright_wizard = {}

for k, v in pairs(TalentBuffTemplates.bright_wizard) do
	local buffs = v.buffs

	fassert(#buffs == 1, "talent buff has more than one sub buff, add multiple buffs from the talent instead")

	buffs[1].name = k
end

BuffUtils.apply_buff_tweak_data(TalentBuffTemplates.bright_wizard, tbl)
