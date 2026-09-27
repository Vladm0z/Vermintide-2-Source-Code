-- chunkname: @scripts/settings/dlcs/mutators_batch_02/mutators_batch_02_buff_settings.lua

local mutators_batch_02 = DLCSettings.mutators_batch_02
local scripts_unit_extensions_default_player_unit_buffs_settings_buff_perk_names = require("scripts/unit_extensions/default_player_unit/buffs/settings/buff_perk_names")

mutators_batch_02.buff_templates = {
	slayer_curse_debuff = {
		buffs = {
			{
				name = "slayer_curse_debuff",
				icon = "buff_icon_mutator_icon_slayer_curse",
				debuff = true,
				perks = {
					scripts_unit_extensions_default_player_unit_buffs_settings_buff_perk_names.slayer_curse
				}
			}
		}
	},
	mutator_bloodlust = {
		buffs = {
			{
				icon = "bardin_slayer_crit_chance",
				name = "mutator_bloodlust",
				stat_buff = "attack_speed",
				multiplier = 0.05,
				max_stacks = 10,
				duration = 4,
				refresh_durations = true
			},
			{
				remove_buff_func = "remove_movement_buff",
				name = "mutator_bloodlust_movement",
				multiplier = 1.05,
				max_stacks = 10,
				duration = 4,
				apply_buff_func = "apply_movement_buff",
				refresh_durations = true,
				path_to_movement_setting_to_modify = {
					"move_speed"
				}
			},
			{
				duration = 4,
				name = "mutator_bloodlust_trigger",
				refresh_durations = true,
				max_stacks = 10,
				remove_buff_func = "remove_bloodlust",
				apply_buff_func = "apply_bloodlust"
			}
		}
	},
	mutator_bloodlust_debuff = {
		buffs = {
			{
				update_func = "update_bloodlust_debuff",
				name = "mutator_bloodlust_debuff",
				damage_percentage = 0.05,
				icon = "troll_vomit_debuff",
				remove_buff_func = "remove_bloodlust_debuff",
				apply_buff_func = "apply_bloodlust_debuff",
				damage_frequency = 1
			}
		}
	}
}

local function fn(arg_1_0)
	-- function 1
	local owner = Managers.player:owner(arg_1_0)

	return not owner and not owner.remote
end

local function fn_2(arg_2_0)
	-- function 2
	local owner = Managers.player:owner(arg_2_0)

	return not owner and owner.bot_player
end

mutators_batch_02.buff_function_templates = {
	apply_bloodlust = function (arg_3_0, arg_3_1, arg_3_2, arg_3_3)
		-- function 3
		if not (fn_2(arg_3_0) or fn(arg_3_0)) then
			return
		end

		local extension = ScriptUnit.extension(arg_3_0, "buff_system")
		local str = "mutator_bloodlust"

		if extension:num_buff_type(str) <= 1 then
			arg_3_1.effect_id = ScriptUnit.extension(arg_3_0, "first_person_system"):create_screen_particles("fx/screenspace_mutator_bloodlust_02")
		end
	end,
	remove_bloodlust = function (arg_4_0, arg_4_1, arg_4_2, arg_4_3)
		-- function 4
		if not (fn_2(arg_4_0) or fn(arg_4_0)) then
			return
		end

		if not arg_4_1.effect_id then
			ScriptUnit.extension(arg_4_0, "first_person_system"):stop_spawning_screen_particles(arg_4_1.effect_id)
		end
	end,
	apply_bloodlust_debuff = function (arg_5_0, arg_5_1, arg_5_2, arg_5_3)
		-- function 5
		if not Managers.state.network.is_server then
			return
		end

		arg_5_1.next_damage_tick_t = arg_5_2.t + arg_5_1.template.damage_frequency
	end,
	update_bloodlust_debuff = function (arg_6_0, arg_6_1, arg_6_2, arg_6_3)
		-- function 6
		if not Managers.state.network.is_server then
			return
		end

		local t = arg_6_2.t

		if t > arg_6_1.next_damage_tick_t then
			local extension = ScriptUnit.extension(arg_6_0, "health_system")
			local get_max_health = extension:get_max_health()
			local current_health = extension:current_health()
			local networkify_damage = DamageUtils.networkify_damage(get_max_health * arg_6_1.template.damage_percentage)

			if current_health - networkify_damage > 0 then
				local num = -Vector3.up()

				DamageUtils.add_damage_network(arg_6_0, arg_6_0, networkify_damage, "torso", "wounded_dot", nil, num, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, 1)

				arg_6_1.next_damage_tick_t = t + arg_6_1.template.damage_frequency
			end
		end
	end,
	remove_bloodlust_debuff = function (arg_7_0, arg_7_1, arg_7_2, arg_7_3)
		-- function 7
		return
	end
}
