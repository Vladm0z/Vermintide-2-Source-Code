-- chunkname: @scripts/settings/profiles/base_units.lua

local tbl = {
	first_person_bot = "units/beings/player/first_person_base/chr_first_person_bot_base",
	first_person = "units/beings/player/first_person_base/chr_first_person_base"
}
local tbl_2 = {
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

for k, v in pairs(tbl_2) do
	if not BaseUnits[k] then
		BaseUnits[k] = {}
	end

	for k_2, v_2 in pairs(tbl) do
		BaseUnits[k][k_2] = v_2
	end

	for k_3, v_3 in pairs(v) do
		BaseUnits[k][k_3] = v_3
	end
end
