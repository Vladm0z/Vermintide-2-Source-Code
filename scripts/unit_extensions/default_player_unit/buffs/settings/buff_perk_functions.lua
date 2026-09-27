-- chunkname: @scripts/unit_extensions/default_player_unit/buffs/settings/buff_perk_functions.lua

local scripts_unit_extensions_default_player_unit_buffs_settings_buff_perk_names = require("scripts/unit_extensions/default_player_unit/buffs/settings/buff_perk_names")
local str = "BUFF_PERK"

return {
	[scripts_unit_extensions_default_player_unit_buffs_settings_buff_perk_names.overpowered] = {
		added = function (arg_1_0, arg_1_1, arg_1_2, arg_1_3)
			-- function 1
			if not arg_1_3 then
				StatusUtils.set_overpowered_network(arg_1_1, true, "slow_bomb", arg_1_1)
			end
		end,
		removed = function (arg_2_0, arg_2_1, arg_2_2, arg_2_3)
			-- function 2
			if not arg_2_3 then
				StatusUtils.set_overpowered_network(arg_2_1, false, "slow_bomb", nil)
			end
		end
	},
	[scripts_unit_extensions_default_player_unit_buffs_settings_buff_perk_names.poisoned] = {
		added = function (arg_3_0, arg_3_1, arg_3_2, arg_3_3)
			-- function 3
			Managers.state.status_effect:set_status(arg_3_1, StatusEffectNames.poisoned, str, true)
		end,
		removed = function (arg_4_0, arg_4_1, arg_4_2, arg_4_3)
			-- function 4
			if not HEALTH_ALIVE[arg_4_1] then
				Managers.state.status_effect:add_timed_status(arg_4_1, StatusEffectNames.poisoned)
			end

			Managers.state.status_effect:set_status(arg_4_1, StatusEffectNames.poisoned, str, false)
		end
	},
	[scripts_unit_extensions_default_player_unit_buffs_settings_buff_perk_names.burning] = {
		added = function (arg_5_0, arg_5_1, arg_5_2, arg_5_3)
			-- function 5
			Managers.state.status_effect:set_status(arg_5_1, StatusEffectNames.burning, str, true)
		end,
		removed = function (arg_6_0, arg_6_1, arg_6_2, arg_6_3)
			-- function 6
			if not HEALTH_ALIVE[arg_6_1] then
				Managers.state.status_effect:add_timed_status(arg_6_1, StatusEffectNames.burning)
			end

			Managers.state.status_effect:set_status(arg_6_1, StatusEffectNames.burning, str, false)
		end
	},
	[scripts_unit_extensions_default_player_unit_buffs_settings_buff_perk_names.burning_balefire] = {
		added = function (arg_7_0, arg_7_1, arg_7_2, arg_7_3)
			-- function 7
			Managers.state.status_effect:set_status(arg_7_1, StatusEffectNames.burning_balefire, str, true)
		end,
		removed = function (arg_8_0, arg_8_1, arg_8_2, arg_8_3)
			-- function 8
			if not HEALTH_ALIVE[arg_8_1] then
				Managers.state.status_effect:add_timed_status(arg_8_1, StatusEffectNames.burning_balefire)
			end

			Managers.state.status_effect:set_status(arg_8_1, StatusEffectNames.burning_balefire, str, false)
		end
	},
	[scripts_unit_extensions_default_player_unit_buffs_settings_buff_perk_names.burning_elven_magic] = {
		added = function (arg_9_0, arg_9_1, arg_9_2, arg_9_3)
			-- function 9
			Managers.state.status_effect:set_status(arg_9_1, StatusEffectNames.burning_elven_magic, str, true)
		end,
		removed = function (arg_10_0, arg_10_1, arg_10_2, arg_10_3)
			-- function 10
			if not HEALTH_ALIVE[arg_10_1] then
				Managers.state.status_effect:add_timed_status(arg_10_1, StatusEffectNames.burning_elven_magic)
			end

			Managers.state.status_effect:set_status(arg_10_1, StatusEffectNames.burning_elven_magic, str, false)
		end
	},
	[scripts_unit_extensions_default_player_unit_buffs_settings_buff_perk_names.burning_warpfire] = {
		added = function (arg_11_0, arg_11_1, arg_11_2, arg_11_3)
			-- function 11
			local has_status = Managers.state.status_effect:has_status(arg_11_1, StatusEffectNames.burning_warpfire)

			if not (not arg_11_2.template.timed_status_effect_time and has_status) then
				Managers.state.status_effect:add_timed_status(arg_11_1, StatusEffectNames.burning_warpfire, arg_11_2.template.timed_status_effect_time)
			elseif not has_status then
				Managers.state.status_effect:set_status(arg_11_1, StatusEffectNames.burning_warpfire, str, true)
			end
		end,
		removed = function (arg_12_0, arg_12_1, arg_12_2, arg_12_3)
			-- function 12
			if not HEALTH_ALIVE[arg_12_1] then
				Managers.state.status_effect:add_timed_status(arg_12_1, StatusEffectNames.burning_warpfire)
			end

			if not arg_12_2.template.timed_status_effect_time then
				Managers.state.status_effect:set_status(arg_12_1, StatusEffectNames.burning_warpfire, str, false)
			end
		end
	}
}
