-- chunkname: @scripts/ui/hud_ui/component_list_definitions/hud_component_list_deus_common.lua

local var_0_0 = {
	{
		use_hud_scale = true,
		class_name = "DeusSoftCurrencyIndicatorUI",
		filename = "scripts/ui/hud_ui/deus_soft_currency_indicator_ui",
		visibility_groups = {
			"dead",
			"alive"
		}
	}
}

if BUILD ~= "release" or script_data.debug_enabled then
	table.insert(var_0_0, {
		use_hud_scale = true,
		class_name = "DeusDebugUI",
		filename = "scripts/ui/hud_ui/deus_debug_ui",
		visibility_groups = {
			"dead",
			"alive"
		}
	})
	table.insert(var_0_0, {
		use_hud_scale = true,
		class_name = "DeusDebugMapUI",
		filename = "scripts/ui/hud_ui/deus_debug_map_ui",
		visibility_groups = {
			"dead",
			"alive"
		}
	})
end

local var_0_1 = {
	{
		name = "deus_run_stats",
		order = 7,
		validation_function = function(arg_1_0)
			local var_1_0 = arg_1_0:component("DeusRunStatsView")

			return var_1_0 and var_1_0:is_ui_active()
		end
	}
}

for iter_0_0 = 1, #var_0_0 do
	require(var_0_0[iter_0_0].filename)
end

return {
	components = var_0_0,
	visibility_groups = var_0_1
}
