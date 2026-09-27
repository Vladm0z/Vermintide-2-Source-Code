-- chunkname: @scripts/ui/hud_ui/component_list_definitions/hud_component_list_inn_deus.lua

local var_0_0 = local_require("scripts/ui/hud_ui/component_list_definitions/hud_component_list_adventure")
local scripts_ui_hud_ui_component_list_definitions_hud_component_list_deus_common = require("scripts/ui/hud_ui/component_list_definitions/hud_component_list_deus_common")
local tbl = {}

table.append(tbl, var_0_0.components)
table.append(tbl, scripts_ui_hud_ui_component_list_definitions_hud_component_list_deus_common.components)

local tbl_2 = {}

table.append(tbl_2, scripts_ui_hud_ui_component_list_definitions_hud_component_list_deus_common.visibility_groups)
table.append(tbl_2, var_0_0.visibility_groups)

return {
	components = tbl,
	visibility_groups = tbl_2
}
