-- chunkname: @scripts/settings/mutators/mutator_deus_more_specials.lua

require("scripts/settings/dlcs/morris/deus_terror_event_tags")

local num = 2
local num_2 = 1

return {
	description = "mutator_deus_more_specials_desc",
	display_name = "mutator_deus_more_specials_name",
	hide_from_player_ui = true,
	icon = "mutator_icon_deus_more_specials",
	update_conflict_settings = function (arg_1_0, arg_1_1)
		-- function 1
		MutatorUtils.update_conflict_settings_specials_frequency(num, num_2)
	end,
	get_terror_event_tags = function (arg_2_0, arg_2_1, arg_2_2)
		-- function 2
		arg_2_2[#arg_2_2 + 1] = DeusTerrorEventTags.MORE_SPECIALS
	end
}
