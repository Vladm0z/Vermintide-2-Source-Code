-- chunkname: @scripts/ui/hud_ui/component_list_definitions/hud_component_list_deus.lua

local var_0_0 = local_require("scripts/ui/hud_ui/component_list_definitions/hud_component_list_adventure")
local var_0_1 = require("scripts/ui/hud_ui/component_list_definitions/hud_component_list_deus_common")
local var_0_2 = {
	{
		use_hud_scale = true,
		class_name = "DeusCurseUI",
		filename = "scripts/ui/hud_ui/deus_curse_ui",
		visibility_groups = {
			"alive"
		}
	},
	{
		use_hud_scale = true,
		class_name = "DeusRunStatsView",
		filename = "scripts/ui/views/deus_menu/deus_run_stats_view",
		visibility_groups = {
			"deus_run_stats",
			"game_mode_disable_hud",
			"dead",
			"alive"
		}
	}
}
local var_0_3 = {}

table.append(var_0_3, var_0_0.components)
table.append(var_0_3, var_0_1.components)
table.append(var_0_3, var_0_2)

local var_0_4 = {}

table.append(var_0_4, var_0_1.visibility_groups)
table.append(var_0_4, var_0_0.visibility_groups)

for iter_0_0 = 1, #var_0_2 do
	require(var_0_2[iter_0_0].filename)
end

return {
	components = var_0_3,
	visibility_groups = var_0_4
}
