-- chunkname: @scripts/settings/dlcs/scorpion/scorpion_talent_settings_kerillian.lua

local buff_tweak_data = {}
local TalentBuffTemplates = TalentBuffTemplates

TalentBuffTemplates = not not TalentBuffTemplates or not not {}
TalentBuffTemplates = TalentBuffTemplates
TalentBuffTemplates.wood_elf = {}

local TalentTrees = TalentTrees

TalentTrees = not not TalentTrees or not not {}
TalentTrees = TalentTrees
TalentTrees.wood_elf = {
	{},
	{},
	{}
}
Talents.wood_elf = {}

BuffUtils.copy_talent_buff_names(TalentBuffTemplates.wood_elf)
BuffUtils.apply_buff_tweak_data(TalentBuffTemplates.wood_elf, buff_tweak_data)
