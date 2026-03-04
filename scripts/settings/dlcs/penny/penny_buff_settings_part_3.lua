-- chunkname: @scripts/settings/dlcs/penny/penny_buff_settings_part_3.lua

local var_0_0 = DLCSettings.penny_part_3
local var_0_1 = require("scripts/unit_extensions/default_player_unit/buffs/settings/buff_perk_names")

var_0_0.buff_templates = {
	enemy_penny_curse_pulse = {
		buffs = {
			{
				update_func = "enemy_penny_curse_pulse",
				name = "penny_curse_pulse",
				radius = 3,
				tick_rate = 0.5
			}
		}
	},
	enemy_penny_curse = {
		buffs = {
			{
				duration = 5,
				name = "penny_curse",
				debuff = true,
				max_stacks = 50,
				icon = "troll_vomit_debuff",
				refresh_durations = true,
				perks = {
					var_0_1.slayer_curse
				}
			}
		}
	}
}
var_0_0.buff_function_templates = {
	enemy_penny_curse_pulse = function(arg_1_0, arg_1_1, arg_1_2, arg_1_3)
		local var_1_0 = arg_1_2.t

		if Managers.state.network.is_server and HEALTH_ALIVE[arg_1_0] and (arg_1_1.next_tick == nil or arg_1_1.next_tick and var_1_0 > arg_1_1.next_tick) then
			local var_1_1 = Managers.state.entity:system("buff_system")
			local var_1_2 = Managers.state.side
			local var_1_3 = arg_1_1.template
			local var_1_4 = var_1_3.tick_rate
			local var_1_5 = var_1_3.radius
			local var_1_6 = FrameTable.alloc_table()
			local var_1_7 = Managers.state.entity:system("proximity_system").player_units_broadphase

			Broadphase.query(var_1_7, POSITION_LOOKUP[arg_1_0], var_1_5, var_1_6)

			arg_1_1.next_tick = var_1_0 + var_1_4

			for iter_1_0, iter_1_1 in pairs(var_1_6) do
				local var_1_8 = Managers.player:owner(iter_1_1)

				if not (var_1_8 and not var_1_8:is_player_controlled()) and var_1_2:is_enemy(arg_1_0, iter_1_1) then
					var_1_1:add_buff(iter_1_1, "enemy_penny_curse", arg_1_0, false)
				end
			end
		end
	end
}
