-- chunkname: @scripts/settings/mutators/mutator_easier_packs.lua

local tbl = {
	marauders_and_warriors = "marauders",
	shield_rats = "shield_rats_no_elites",
	beastmen_elites = "beastmen",
	standard = "standard_no_elites",
	beastmen = "beastmen_light",
	marauders_elites = "marauders_and_warriors"
}
local num = 0.8

return {
	hide_from_player_ui = true,
	tweak_pack_spawning_settings = function (arg_1_0, arg_1_1)
		-- function 1
		MutatorUtils.tweak_pack_spawning_settings_density_multiplier(arg_1_1, num)
		MutatorUtils.tweak_pack_spawning_settings_convert_breeds(arg_1_1, tbl)
	end
}
