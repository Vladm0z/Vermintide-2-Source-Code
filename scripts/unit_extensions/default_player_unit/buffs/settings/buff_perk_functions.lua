-- chunkname: @scripts/unit_extensions/default_player_unit/buffs/settings/buff_perk_functions.lua

local var_0_0 = require("scripts/unit_extensions/default_player_unit/buffs/settings/buff_perk_names")
local var_0_1 = "BUFF_PERK"

return {
	[var_0_0.overpowered] = {
		added = function(arg_1_0, arg_1_1, arg_1_2, arg_1_3)
			if arg_1_3 then
				StatusUtils.set_overpowered_network(arg_1_1, true, "slow_bomb", arg_1_1)
			end
		end,
		removed = function(arg_2_0, arg_2_1, arg_2_2, arg_2_3)
			if arg_2_3 then
				StatusUtils.set_overpowered_network(arg_2_1, false, "slow_bomb", nil)
			end
		end
	},
	[var_0_0.poisoned] = {
		added = function(arg_3_0, arg_3_1, arg_3_2, arg_3_3)
			Managers.state.status_effect:set_status(arg_3_1, StatusEffectNames.poisoned, var_0_1, true)
		end,
		removed = function(arg_4_0, arg_4_1, arg_4_2, arg_4_3)
			if not HEALTH_ALIVE[arg_4_1] then
				Managers.state.status_effect:add_timed_status(arg_4_1, StatusEffectNames.poisoned)
			end

			Managers.state.status_effect:set_status(arg_4_1, StatusEffectNames.poisoned, var_0_1, false)
		end
	},
	[var_0_0.burning] = {
		added = function(arg_5_0, arg_5_1, arg_5_2, arg_5_3)
			Managers.state.status_effect:set_status(arg_5_1, StatusEffectNames.burning, var_0_1, true)
		end,
		removed = function(arg_6_0, arg_6_1, arg_6_2, arg_6_3)
			if not HEALTH_ALIVE[arg_6_1] then
				Managers.state.status_effect:add_timed_status(arg_6_1, StatusEffectNames.burning)
			end

			Managers.state.status_effect:set_status(arg_6_1, StatusEffectNames.burning, var_0_1, false)
		end
	},
	[var_0_0.burning_balefire] = {
		added = function(arg_7_0, arg_7_1, arg_7_2, arg_7_3)
			Managers.state.status_effect:set_status(arg_7_1, StatusEffectNames.burning_balefire, var_0_1, true)
		end,
		removed = function(arg_8_0, arg_8_1, arg_8_2, arg_8_3)
			if not HEALTH_ALIVE[arg_8_1] then
				Managers.state.status_effect:add_timed_status(arg_8_1, StatusEffectNames.burning_balefire)
			end

			Managers.state.status_effect:set_status(arg_8_1, StatusEffectNames.burning_balefire, var_0_1, false)
		end
	},
	[var_0_0.burning_elven_magic] = {
		added = function(arg_9_0, arg_9_1, arg_9_2, arg_9_3)
			Managers.state.status_effect:set_status(arg_9_1, StatusEffectNames.burning_elven_magic, var_0_1, true)
		end,
		removed = function(arg_10_0, arg_10_1, arg_10_2, arg_10_3)
			if not HEALTH_ALIVE[arg_10_1] then
				Managers.state.status_effect:add_timed_status(arg_10_1, StatusEffectNames.burning_elven_magic)
			end

			Managers.state.status_effect:set_status(arg_10_1, StatusEffectNames.burning_elven_magic, var_0_1, false)
		end
	},
	[var_0_0.burning_warpfire] = {
		added = function(arg_11_0, arg_11_1, arg_11_2, arg_11_3)
			local var_11_0 = Managers.state.status_effect:has_status(arg_11_1, StatusEffectNames.burning_warpfire)

			if arg_11_2.template.timed_status_effect_time and not var_11_0 then
				Managers.state.status_effect:add_timed_status(arg_11_1, StatusEffectNames.burning_warpfire, arg_11_2.template.timed_status_effect_time)
			elseif not var_11_0 then
				Managers.state.status_effect:set_status(arg_11_1, StatusEffectNames.burning_warpfire, var_0_1, true)
			end
		end,
		removed = function(arg_12_0, arg_12_1, arg_12_2, arg_12_3)
			if not HEALTH_ALIVE[arg_12_1] then
				Managers.state.status_effect:add_timed_status(arg_12_1, StatusEffectNames.burning_warpfire)
			end

			if not arg_12_2.template.timed_status_effect_time then
				Managers.state.status_effect:set_status(arg_12_1, StatusEffectNames.burning_warpfire, var_0_1, false)
			end
		end
	}
}
