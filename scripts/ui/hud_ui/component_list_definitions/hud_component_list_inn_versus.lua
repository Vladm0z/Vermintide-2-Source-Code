-- chunkname: @scripts/ui/hud_ui/component_list_definitions/hud_component_list_inn_versus.lua

local var_0_0 = local_require("scripts/ui/hud_ui/component_list_definitions/hud_component_list_adventure")
local tbl = {}

table.append(tbl, var_0_0.components)

local tbl_2 = {}

table.append(tbl_2, var_0_0.visibility_groups)

return {
	components = tbl,
	visibility_groups = tbl_2
}
