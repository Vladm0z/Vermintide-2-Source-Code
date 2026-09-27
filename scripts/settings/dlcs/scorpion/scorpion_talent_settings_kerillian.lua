-- chunkname: @scripts/settings/dlcs/scorpion/scorpion_talent_settings_kerillian.lua

local tbl = {}
local TalentBuffTemplates = TalentBuffTemplates

TalentBuffTemplates = TalentBuffTemplates or {}
TalentBuffTemplates = TalentBuffTemplates
TalentBuffTemplates.wood_elf = {}

local TalentTrees = TalentTrees

TalentTrees = TalentTrees or {}
TalentTrees = TalentTrees
TalentTrees.wood_elf = {
	{},
	{},
	{}
}
Talents.wood_elf = {}

BuffUtils.copy_talent_buff_names(TalentBuffTemplates.wood_elf)
BuffUtils.apply_buff_tweak_data(TalentBuffTemplates.wood_elf, tbl)
