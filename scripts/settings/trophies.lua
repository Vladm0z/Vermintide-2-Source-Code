-- chunkname: @scripts/settings/trophies.lua

local Trophies = Trophies

Trophies = Trophies or {}
Trophies = Trophies
Trophies.hub_trophy_empty = {
	sound_event = "hub_trophy_empty_description",
	unit_name = "units/props/inn/hub_trophy/hub_trophy_empty",
	display_name = "hub_trophy_empty_name",
	description = "hub_trophy_empty_description",
	icon = "icon_placeholder"
}
Trophies.hub_trophy_holly = {
	sound_event = "keep_trophy_holly_description",
	unit_name = "units/props/inn/hub_trophy/hub_trophy_holly",
	display_name = "interaction_holly_stone",
	description = "keep_trophy_holly_description",
	icon = "icon_placeholder"
}
Trophies.hub_trophy_skarrik = {
	sound_event = "keep_trophy_skarrik_description",
	unit_name = "units/props/inn/hub_trophy/hub_trophy_skarrik",
	display_name = "keep_trophy_skarrik",
	description = "keep_trophy_skarrik_description",
	icon = "icon_placeholder"
}
Trophies.hub_trophy_bugman = {
	sound_event = "keep_trophy_bugman_description",
	unit_name = "units/props/inn/hub_trophy/hub_trophy_bugman",
	display_name = "interaction_bugmans",
	description = "keep_trophy_bugman_description",
	icon = "icon_placeholder"
}
Trophies.hub_trophy_bodvarr = {
	sound_event = "keep_trophy_bodvarr_description",
	unit_name = "units/props/inn/hub_trophy/hub_trophy_bodvarr",
	display_name = "keep_trophy_bodvarr",
	description = "keep_trophy_bodvarr_description",
	icon = "icon_placeholder"
}
Trophies.hub_trophy_burblespue = {
	sound_event = "keep_trophy_burblespue_description",
	unit_name = "units/props/inn/hub_trophy/hub_trophy_burblespue",
	display_name = "keep_trophy_burblespue",
	description = "keep_trophy_burblespue_description",
	icon = "icon_placeholder"
}
Trophies.hub_trophy_nurgloth = {
	sound_event = "keep_trophy_nurgloth_description",
	unit_name = "units/props/inn/hub_trophy/hub_trophy_nurgloth",
	display_name = "keep_trophy_nurgloth",
	description = "keep_trophy_nurgloth_description",
	icon = "icon_placeholder"
}
Trophies.hub_trophy_bogenhafen = {
	sound_event = "keep_trophy_bogenhafen_description",
	unit_name = "units/props/inn/hub_trophy/hub_trophy_bogenhafen",
	display_name = "keep_trophy_bogenhafen",
	description = "keep_trophy_bogenhafen_description",
	icon = "icon_placeholder"
}
Trophies.hub_trophy_rasknitt = {
	sound_event = "keep_trophy_rasknitt_description",
	unit_name = "units/props/inn/hub_trophy/hub_trophy_rasknitt",
	display_name = "keep_trophy_rasknitt",
	description = "keep_trophy_rasknitt_description",
	icon = "icon_placeholder"
}
DefaultTrophies = {
	"hub_trophy_empty"
}

local tbl = {
	"hub_trophy_empty",
	"hub_trophy_holly",
	"hub_trophy_skarrik",
	"hub_trophy_bugman",
	"hub_trophy_bodvarr",
	"hub_trophy_burblespue",
	"hub_trophy_nurgloth",
	"hub_trophy_bogenhafen",
	"hub_trophy_rasknitt"
}
local TrophyOrder = TrophyOrder

TrophyOrder = TrophyOrder or {}
TrophyOrder = TrophyOrder

for i, v in ipairs(tbl) do
	if not (table.contains(TrophyOrder, v) or table.contains(DefaultTrophies, v)) then
		TrophyOrder[#TrophyOrder + 1] = v
	end
end

table.sort(TrophyOrder)
