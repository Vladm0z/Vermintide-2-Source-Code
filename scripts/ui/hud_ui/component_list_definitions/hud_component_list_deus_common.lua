-- chunkname: @scripts/ui/hud_ui/component_list_definitions/hud_component_list_deus_common.lua

local tbl = {
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

if BUILD ~= "release" or not script_data.debug_enabled then
	table.insert(tbl, {
		use_hud_scale = true,
		class_name = "DeusDebugUI",
		filename = "scripts/ui/hud_ui/deus_debug_ui",
		visibility_groups = {
			"dead",
			"alive"
		}
	})
	table.insert(tbl, {
		use_hud_scale = true,
		class_name = "DeusDebugMapUI",
		filename = "scripts/ui/hud_ui/deus_debug_map_ui",
		visibility_groups = {
			"dead",
			"alive"
		}
	})
end

local tbl_2 = {
	{
		name = "deus_run_stats",
		order = 7,
		validation_function = function (self)
			-- function 1
			local component = self:component("DeusRunStatsView")

			return not component and component:is_ui_active()
		end
	}
}

for i = 1, #tbl do
	require(tbl[i].filename)
end

return {
	components = tbl,
	visibility_groups = tbl_2
}
