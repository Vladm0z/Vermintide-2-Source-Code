-- chunkname: @scripts/ui/hud_ui/component_list_definitions/hud_component_list_deus.lua

local var_0_0 = local_require("scripts/ui/hud_ui/component_list_definitions/hud_component_list_adventure")
local scripts_ui_hud_ui_component_list_definitions_hud_component_list_deus_common = require("scripts/ui/hud_ui/component_list_definitions/hud_component_list_deus_common")
local tbl = {
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
local tbl_2 = {}

table.append(tbl_2, var_0_0.components)
table.append(tbl_2, scripts_ui_hud_ui_component_list_definitions_hud_component_list_deus_common.components)
table.append(tbl_2, tbl)

local tbl_3 = {}

table.append(tbl_3, scripts_ui_hud_ui_component_list_definitions_hud_component_list_deus_common.visibility_groups)
table.append(tbl_3, var_0_0.visibility_groups)

for i = 1, #tbl do
	require(tbl[i].filename)
end

return {
	components = tbl_2,
	visibility_groups = tbl_3
}
