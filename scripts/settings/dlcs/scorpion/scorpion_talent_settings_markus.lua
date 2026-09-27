-- chunkname: @scripts/settings/dlcs/scorpion/scorpion_talent_settings_markus.lua

local tbl = {}
local TalentBuffTemplates = TalentBuffTemplates

TalentBuffTemplates = TalentBuffTemplates or {}
TalentBuffTemplates = TalentBuffTemplates
TalentBuffTemplates.empire_soldier = {}

local TalentTrees = TalentTrees

TalentTrees = TalentTrees or {}
TalentTrees = TalentTrees
TalentTrees.empire_soldier = {
	{},
	{},
	{}
}
Talents.empire_soldier = {}

for k, v in pairs(TalentBuffTemplates.empire_soldier) do
	local buffs = v.buffs

	fassert(#buffs == 1, "talent buff has more than one sub buff, add multiple buffs from the talent instead")

	buffs[1].name = k
end

BuffUtils.apply_buff_tweak_data(TalentBuffTemplates.empire_soldier, tbl)
