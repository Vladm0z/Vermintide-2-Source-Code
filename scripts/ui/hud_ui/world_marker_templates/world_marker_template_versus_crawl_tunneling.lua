-- chunkname: @scripts/ui/hud_ui/world_marker_templates/world_marker_template_versus_crawl_tunneling.lua

local var_0_0 = "tunneling"

WorldMarkerTemplates = WorldMarkerTemplates or {}

require("scripts/ui/hud_ui/world_marker_templates/world_marker_template_versus_climbing")

local var_0_1 = WorldMarkerTemplates.climbing
local var_0_2 = table.merge(WorldMarkerTemplates[var_0_0] or {}, var_0_1)

WorldMarkerTemplates[var_0_0] = var_0_2

var_0_2.on_enter = function (arg_1_0)
	var_0_1.on_enter(arg_1_0)

	arg_1_0.content.icon = "world_marker_versus_pactsworn_interact_crawling"
end
