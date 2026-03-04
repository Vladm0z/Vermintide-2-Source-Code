-- chunkname: @scripts/ui/hud_ui/component_list_definitions/hud_component_list_inn_deus.lua

local var_0_0 = local_require("scripts/ui/hud_ui/component_list_definitions/hud_component_list_adventure")
local var_0_1 = require("scripts/ui/hud_ui/component_list_definitions/hud_component_list_deus_common")
local var_0_2 = {}

table.append(var_0_2, var_0_0.components)
table.append(var_0_2, var_0_1.components)

local var_0_3 = {}

table.append(var_0_3, var_0_1.visibility_groups)
table.append(var_0_3, var_0_0.visibility_groups)

return {
	components = var_0_2,
	visibility_groups = var_0_3
}
