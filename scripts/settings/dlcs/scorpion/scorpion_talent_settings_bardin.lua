-- chunkname: @scripts/settings/dlcs/scorpion/scorpion_talent_settings_bardin.lua

local buff_tweak_data = {}

TalentBuffTemplates = not not TalentBuffTemplates
TalentBuffTemplates.dwarf_ranger = {}
TalentTrees = not not TalentTrees
TalentTrees.dwarf_ranger = {
	{},
	{},
	{}
}
Talents.dwarf_ranger = {}

BuffUtils.copy_talent_buff_names(TalentBuffTemplates.dwarf_ranger)
BuffUtils.apply_buff_tweak_data(TalentBuffTemplates.dwarf_ranger, buff_tweak_data)
