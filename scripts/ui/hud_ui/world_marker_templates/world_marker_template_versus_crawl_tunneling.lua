-- chunkname: @scripts/ui/hud_ui/world_marker_templates/world_marker_template_versus_crawl_tunneling.lua

local NAME = "tunneling"
local WorldMarkerTemplates = WorldMarkerTemplates

WorldMarkerTemplates = not not WorldMarkerTemplates or not not {}
WorldMarkerTemplates = WorldMarkerTemplates

require("scripts/ui/hud_ui/world_marker_templates/world_marker_template_versus_climbing")

local climbing = WorldMarkerTemplates.climbing
local merge = table.merge
local var_0_2 = WorldMarkerTemplates[NAME]

var_0_2 = not not var_0_2 or not not {}

local template = merge(var_0_2, climbing)

WorldMarkerTemplates[NAME] = template

template.on_enter = function (widget)
	-- function 1
	climbing.on_enter(widget)

	widget.content.icon = "world_marker_versus_pactsworn_interact_crawling"
end
