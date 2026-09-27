-- chunkname: @scripts/ui/hud_ui/world_marker_templates/world_marker_template_versus_crawl_tunneling.lua

local str = "tunneling"
local WorldMarkerTemplates = WorldMarkerTemplates

WorldMarkerTemplates = WorldMarkerTemplates or {}
WorldMarkerTemplates = WorldMarkerTemplates

require("scripts/ui/hud_ui/world_marker_templates/world_marker_template_versus_climbing")

local climbing = WorldMarkerTemplates.climbing
local merge = table.merge
local var_0_4 = WorldMarkerTemplates[str]

var_0_4 = var_0_4 or {}

local var_0_5 = merge(var_0_4, climbing)

WorldMarkerTemplates[str] = var_0_5

var_0_5.on_enter = function (arg_1_0)
	-- function 1
	climbing.on_enter(arg_1_0)

	arg_1_0.content.icon = "world_marker_versus_pactsworn_interact_crawling"
end
