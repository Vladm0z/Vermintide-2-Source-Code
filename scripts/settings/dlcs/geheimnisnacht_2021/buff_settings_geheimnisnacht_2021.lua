-- chunkname: @scripts/settings/dlcs/geheimnisnacht_2021/buff_settings_geheimnisnacht_2021.lua

local var_0_0 = DLCSettings.geheimnisnacht_2021
local var_0_1 = require("scripts/unit_extensions/default_player_unit/buffs/settings/buff_perk_names")

var_0_0.buff_templates = {
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
var_0_0.buff_function_templates = {
	geheimnisnacht_2021_apply_eye_glow = function (arg_1_0, arg_1_1, arg_1_2)
		local var_1_0 = ScriptUnit.has_extension(arg_1_0, "buff_system")

		if not ALIVE[arg_1_0] then
			return
		end

		if not var_1_0.reset_material_cache then
			var_1_0.reset_material_cache = Unit.get_material_resource_id(arg_1_0, "mtr_eyes")
		end

		Unit.set_material(arg_1_0, "mtr_eyes", "units/beings/enemies/mtr_eyes_geheimnisnacht")
	end,
	geheimnisnacht_2021_remove_eye_glow = function (arg_2_0, arg_2_1, arg_2_2)
		local var_2_0 = ScriptUnit.has_extension(arg_2_0, "buff_system")

		if not ALIVE[arg_2_0] or not var_2_0.reset_material_cache then
			return
		end

		Unit.set_material_from_id(arg_2_0, "mtr_eyes", var_2_0.reset_material_cache)
	end
}
var_0_0.proc_functions = {}
var_0_0.stacking_buff_functions = {}
