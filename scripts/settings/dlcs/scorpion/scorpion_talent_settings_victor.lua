-- chunkname: @scripts/settings/dlcs/scorpion/scorpion_talent_settings_victor.lua

local tbl = {}
local TalentBuffTemplates = TalentBuffTemplates

TalentBuffTemplates = TalentBuffTemplates or {}
TalentBuffTemplates = TalentBuffTemplates
TalentBuffTemplates.witch_hunter = {}

local TalentTrees = TalentTrees

TalentTrees = TalentTrees or {}
TalentTrees = TalentTrees
TalentTrees.witch_hunter = {
	{},
	{},
	{}
}
Talents.witch_hunter = {}

for k, v in pairs(TalentBuffTemplates.witch_hunter) do
	local buffs = v.buffs

	fassert(#buffs == 1, "talent buff has more than one sub buff, add multiple buffs from the talent instead")

	buffs[1].name = k
end

BuffUtils.apply_buff_tweak_data(TalentBuffTemplates.witch_hunter, tbl)
