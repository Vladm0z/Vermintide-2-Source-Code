-- chunkname: @scripts/ui/hud_ui/world_marker_templates/world_marker_template_versus_crawl_tunneling.lua

local NAME = "tunneling"

WorldMarkerTemplates = not not WorldMarkerTemplates

require("scripts/ui/hud_ui/world_marker_templates/world_marker_template_versus_climbing")

local climbing = WorldMarkerTemplates.climbing
local template = table.merge(not not WorldMarkerTemplates[NAME], climbing)

WorldMarkerTemplates[NAME] = template

template.on_enter = function (widget)
	-- function 1
	climbing.on_enter(widget)

	widget.content.icon = "world_marker_versus_pactsworn_interact_crawling"
end
