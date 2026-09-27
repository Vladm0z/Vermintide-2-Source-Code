-- chunkname: @scripts/settings/dlcs/geheimnisnacht_2021/buff_settings_geheimnisnacht_2021.lua

local geheimnisnacht_2021 = DLCSettings.geheimnisnacht_2021
local scripts_unit_extensions_default_player_unit_buffs_settings_buff_perk_names = require("scripts/unit_extensions/default_player_unit/buffs/settings/buff_perk_names")

geheimnisnacht_2021.buff_templates = {
	geheimnisnacht_2021_event_horde_buff = {
		buffs = {
			{
				multiplier = 0.25,
				name = "geheimnisnacht_2021_event_damage",
				stat_buff = "damage_dealt"
			},
			{
				multiplier = 1.25,
				name = "geheimnisnacht_2021_event_health",
				stat_buff = "max_health"
			},
			{
				remove_buff_func = "ai_update_max_health",
				name = "geheimnisnacht_2021_event_health_update",
				apply_buff_func = "ai_update_max_health"
			},
			{
				remove_buff_func = "geheimnisnacht_2021_remove_eye_glow",
				name = "geheimnisnacht_2021_event_eye_glow",
				apply_buff_func = "geheimnisnacht_2021_apply_eye_glow"
			},
			{
				multiplier = 1.1,
				name = "geheimnisnacht_2021_event_stagger",
				stat_buff = "stagger_resistance"
			},
			{
				multiplier = 0.9,
				name = "geheimnisnacht_2021_event_hit_mass",
				stat_buff = "hit_mass_amount"
			}
		}
	},
	geheimnisnacht_2021_event_cultist_buff = {
		buffs = {
			{
				multiplier = 0.25,
				name = "geheimnisnacht_2021_event_damage",
				stat_buff = "damage_dealt"
			},
			{
				multiplier = 1.25,
				name = "geheimnisnacht_2021_event_health",
				stat_buff = "max_health"
			},
			{
				remove_buff_func = "ai_update_max_health",
				name = "geheimnisnacht_2021_event_health_update",
				apply_buff_func = "ai_update_max_health"
			},
			{
				remove_buff_func = "geheimnisnacht_2021_remove_eye_glow",
				name = "geheimnisnacht_2021_event_eye_glow",
				apply_buff_func = "geheimnisnacht_2021_apply_eye_glow"
			},
			{
				multiplier = 1.1,
				name = "geheimnisnacht_2021_event_stagger",
				stat_buff = "stagger_resistance"
			},
			{
				multiplier = 0.9,
				name = "geheimnisnacht_2021_event_hit_mass",
				stat_buff = "hit_mass_amount"
			}
		}
	}
}
geheimnisnacht_2021.buff_function_templates = {
	geheimnisnacht_2021_apply_eye_glow = function (arg_1_0, arg_1_1, arg_1_2)
		-- function 1
		local has_extension = ScriptUnit.has_extension(arg_1_0, "buff_system")

		if not ALIVE[arg_1_0] then
			return
		end

		if not has_extension.reset_material_cache then
			has_extension.reset_material_cache = Unit.get_material_resource_id(arg_1_0, "mtr_eyes")
		end

		Unit.set_material(arg_1_0, "mtr_eyes", "units/beings/enemies/mtr_eyes_geheimnisnacht")
	end,
	geheimnisnacht_2021_remove_eye_glow = function (arg_2_0, arg_2_1, arg_2_2)
		-- function 2
		local has_extension = ScriptUnit.has_extension(arg_2_0, "buff_system")

		if not (not ALIVE[arg_2_0] and has_extension.reset_material_cache) then
			return
		end

		Unit.set_material_from_id(arg_2_0, "mtr_eyes", has_extension.reset_material_cache)
	end
}
geheimnisnacht_2021.proc_functions = {}
geheimnisnacht_2021.stacking_buff_functions = {}
