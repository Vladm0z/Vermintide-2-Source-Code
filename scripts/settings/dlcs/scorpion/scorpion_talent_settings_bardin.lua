-- chunkname: @scripts/settings/dlcs/scorpion/scorpion_talent_settings_bardin.lua

local tbl = {}
local TalentBuffTemplates = TalentBuffTemplates

TalentBuffTemplates = TalentBuffTemplates or {}
TalentBuffTemplates = TalentBuffTemplates
TalentBuffTemplates.dwarf_ranger = {}

local TalentTrees = TalentTrees

TalentTrees = TalentTrees or {}
TalentTrees = TalentTrees
TalentTrees.dwarf_ranger = {
	{},
	{},
	{}
}
Talents.dwarf_ranger = {}

BuffUtils.copy_talent_buff_names(TalentBuffTemplates.dwarf_ranger)
BuffUtils.apply_buff_tweak_data(TalentBuffTemplates.dwarf_ranger, tbl)
