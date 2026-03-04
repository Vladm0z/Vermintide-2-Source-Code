-- chunkname: @scripts/settings/profiles/base_units.lua

local var_0_0 = {
	first_person_bot = "units/beings/player/first_person_base/chr_first_person_bot_base",
	first_person = "units/beings/player/first_person_base/chr_first_person_base"
}
local var_0_1 = {
	witch_hunter = {
		third_person_husk = "units/beings/player/third_person_base/witch_hunter/chr_third_person_husk_base",
		third_person_bot = "units/beings/player/third_person_base/witch_hunter/chr_third_person_base",
		third_person = "units/beings/player/third_person_base/witch_hunter/chr_third_person_base"
	},
	bright_wizard = {
		third_person_husk = "units/beings/player/third_person_base/bright_wizard/chr_third_person_husk_base",
		third_person_bot = "units/beings/player/third_person_base/bright_wizard/chr_third_person_base",
		third_person = "units/beings/player/third_person_base/bright_wizard/chr_third_person_base"
	},
	dwarf_ranger = {
		third_person_husk = "units/beings/player/third_person_base/dwarf_ranger/chr_third_person_husk_base",
		third_person_bot = "units/beings/player/third_person_base/dwarf_ranger/chr_third_person_base",
		third_person = "units/beings/player/third_person_base/dwarf_ranger/chr_third_person_base"
	},
	wood_elf = {
		third_person_husk = "units/beings/player/third_person_base/way_watcher/chr_third_person_husk_base",
		third_person_bot = "units/beings/player/third_person_base/way_watcher/chr_third_person_base",
		third_person = "units/beings/player/third_person_base/way_watcher/chr_third_person_base"
	},
	empire_soldier = {
		third_person_husk = "units/beings/player/third_person_base/empire_soldier/chr_third_person_husk_base",
		third_person_bot = "units/beings/player/third_person_base/empire_soldier/chr_third_person_base",
		third_person = "units/beings/player/third_person_base/empire_soldier/chr_third_person_base"
	}
}

BaseUnits = {}

for iter_0_0, iter_0_1 in pairs(var_0_1) do
	if not BaseUnits[iter_0_0] then
		BaseUnits[iter_0_0] = {}
	end

	for iter_0_2, iter_0_3 in pairs(var_0_0) do
		BaseUnits[iter_0_0][iter_0_2] = iter_0_3
	end

	for iter_0_4, iter_0_5 in pairs(iter_0_1) do
		BaseUnits[iter_0_0][iter_0_4] = iter_0_5
	end
end
