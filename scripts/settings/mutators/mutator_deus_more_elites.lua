-- chunkname: @scripts/settings/mutators/mutator_deus_more_elites.lua

require("scripts/settings/dlcs/morris/deus_terror_event_tags")

local var_0_0 = {
	shield_rats_no_elites = "shield_rats",
	beastmen = "beastmen_elites",
	marauders_and_warriors = "marauders_elites",
	beastmen_light = "beastmen",
	standard_no_elites = "standard"
}

return {
	description = "mutator_deus_more_elites_desc",
	display_name = "mutator_deus_more_elites_name",
	hide_from_player_ui = true,
	icon = "mutator_icon_deus_more_elites",
	tweak_pack_spawning_settings = function (arg_1_0, arg_1_1)
		MutatorUtils.tweak_pack_spawning_settings_convert_breeds(arg_1_1, var_0_0)
	end,
	get_terror_event_tags = function (arg_2_0, arg_2_1, arg_2_2)
		arg_2_2[#arg_2_2 + 1] = DeusTerrorEventTags.MORE_ELITES
	end
}
