-- chunkname: @scripts/settings/dlcs/scorpion/scorpion_talent_settings_kerillian.lua

local var_0_0 = {}

TalentBuffTemplates = TalentBuffTemplates or {}
TalentBuffTemplates.wood_elf = {}
TalentTrees = TalentTrees or {}
TalentTrees.wood_elf = {
	{},
	{},
	{}
}
Talents.wood_elf = {}

BuffUtils.copy_talent_buff_names(TalentBuffTemplates.wood_elf)
BuffUtils.apply_buff_tweak_data(TalentBuffTemplates.wood_elf, var_0_0)
