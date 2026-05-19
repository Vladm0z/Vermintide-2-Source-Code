-- chunkname: @scripts/settings/dlcs/mutators_batch_02/mutators_batch_02_buff_settings.lua

local var_0_0 = DLCSettings.mutators_batch_02
local var_0_1 = require("scripts/unit_extensions/default_player_unit/buffs/settings/buff_perk_names")

var_0_0.buff_templates = {
	slayer_curse_debuff = {
		buffs = {
			{
				name = "slayer_curse_debuff",
				icon = "buff_icon_mutator_icon_slayer_curse",
				debuff = true,
				perks = {
					var_0_1.slayer_curse
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

local function var_0_2(arg_1_0)
	local var_1_0 = Managers.player:owner(arg_1_0)

	return var_1_0 and not var_1_0.remote
end

local function var_0_3(arg_2_0)
	local var_2_0 = Managers.player:owner(arg_2_0)

	return var_2_0 and var_2_0.bot_player
end

var_0_0.buff_function_templates = {
	apply_bloodlust = function(arg_3_0, arg_3_1, arg_3_2, arg_3_3)
		if var_0_3(arg_3_0) or not var_0_2(arg_3_0) then
			return
		end

		local var_3_0 = ScriptUnit.extension(arg_3_0, "buff_system")
		local var_3_1 = "mutator_bloodlust"

		if var_3_0:num_buff_type(var_3_1) <= 1 then
			arg_3_1.effect_id = ScriptUnit.extension(arg_3_0, "first_person_system"):create_screen_particles("fx/screenspace_mutator_bloodlust_02")
		end
	end,
	remove_bloodlust = function(arg_4_0, arg_4_1, arg_4_2, arg_4_3)
		if var_0_3(arg_4_0) or not var_0_2(arg_4_0) then
			return
		end

		if arg_4_1.effect_id then
			ScriptUnit.extension(arg_4_0, "first_person_system"):stop_spawning_screen_particles(arg_4_1.effect_id)
		end
	end,
	apply_bloodlust_debuff = function(arg_5_0, arg_5_1, arg_5_2, arg_5_3)
		if not Managers.state.network.is_server then
			return
		end

		arg_5_1.next_damage_tick_t = arg_5_2.t + arg_5_1.template.damage_frequency
	end,
	update_bloodlust_debuff = function(arg_6_0, arg_6_1, arg_6_2, arg_6_3)
		if not Managers.state.network.is_server then
			return
		end

		local var_6_0 = arg_6_2.t

		if var_6_0 > arg_6_1.next_damage_tick_t then
			local var_6_1 = ScriptUnit.extension(arg_6_0, "health_system")
			local var_6_2 = var_6_1:get_max_health()
			local var_6_3 = var_6_1:current_health()
			local var_6_4 = DamageUtils.networkify_damage(var_6_2 * arg_6_1.template.damage_percentage)

			if var_6_3 - var_6_4 > 0 then
				local var_6_5 = -Vector3.up()

				DamageUtils.add_damage_network(arg_6_0, arg_6_0, var_6_4, "torso", "wounded_dot", nil, var_6_5, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, 1)

				arg_6_1.next_damage_tick_t = var_6_0 + arg_6_1.template.damage_frequency
			end
		end
	end,
	remove_bloodlust_debuff = function(arg_7_0, arg_7_1, arg_7_2, arg_7_3)
		return
	end
}
