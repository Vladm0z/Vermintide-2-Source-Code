-- chunkname: @scripts/settings/dlcs/penny/penny_buff_settings_part_3.lua

local penny_part_3 = DLCSettings.penny_part_3
local scripts_unit_extensions_default_player_unit_buffs_settings_buff_perk_names = require("scripts/unit_extensions/default_player_unit/buffs/settings/buff_perk_names")

penny_part_3.buff_templates = {
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
					scripts_unit_extensions_default_player_unit_buffs_settings_buff_perk_names.slayer_curse
				}
			}
		}
	}
}
penny_part_3.buff_function_templates = {
	enemy_penny_curse_pulse = function (arg_1_0, arg_1_1, arg_1_2, arg_1_3)
		-- function 1
		local t = arg_1_2.t

		if not ((not Managers.state.network.is_server and not HEALTH_ALIVE[arg_1_0] and arg_1_1.next_tick == nil or not arg_1_1.next_tick) and not (t > arg_1_1.next_tick)) then
			local system = Managers.state.entity:system("buff_system")
			local side = Managers.state.side
			local template = arg_1_1.template
			local tick_rate = template.tick_rate
			local radius = template.radius
			local alloc_table = FrameTable.alloc_table()
			local player_units_broadphase = Managers.state.entity:system("proximity_system").player_units_broadphase

			Broadphase.query(player_units_broadphase, POSITION_LOOKUP[arg_1_0], radius, alloc_table)

			arg_1_1.next_tick = t + tick_rate

			for k, v in pairs(alloc_table) do
				local owner = Managers.player:owner(v)

				if not owner and not owner:is_player_controlled() or not side:is_enemy(arg_1_0, v) then
					system:add_buff(v, "enemy_penny_curse", arg_1_0, false)
				end
			end
		end
	end
}
