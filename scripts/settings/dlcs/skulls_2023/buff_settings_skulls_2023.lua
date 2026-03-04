-- chunkname: @scripts/settings/dlcs/skulls_2023/buff_settings_skulls_2023.lua

local var_0_0 = DLCSettings.skulls_2023
local var_0_1 = 30
local var_0_2 = 5
local var_0_3 = 1
local var_0_4 = {
	"skulls_2023_buff_power_level",
	"skulls_2023_buff_attack_speed",
	"skulls_2023_buff_crit_chance",
	"skulls_2023_buff_movement_speed",
	"skulls_2023_buff_cooldown_regen"
}
local var_0_5 = 30
local var_0_6 = 15
local var_0_7 = 20

local function var_0_8(arg_1_0, arg_1_1)
	local var_1_0 = var_0_5 + var_0_6 * var_0_2 - var_0_6 * arg_1_0

	if ScriptUnit.extension(arg_1_1, "buff_system"):num_buff_stacks("power_up_boon_skulls_set_bonus_02_event") > 0 then
		var_1_0 = var_1_0 * (1 + MorrisBuffTweakData.boon_skulls_set_bonus_02.duration_amplify_amount)
	end

	return var_1_0
end

local function var_0_9(arg_2_0, arg_2_1, arg_2_2, arg_2_3)
	local var_2_0 = arg_2_3:num_buff_stacks("skulls_2023_buff")

	return var_0_8(math.min(var_2_0, var_0_2), arg_2_0)
end

local function var_0_10(arg_3_0, arg_3_1)
	local var_3_0 = {
		external_optional_duration = var_0_8(arg_3_1, arg_3_0)
	}
	local var_3_1 = Managers.state.entity:system("buff_system")

	for iter_3_0 = 1, math.min(arg_3_1, #var_0_4) do
		var_3_1:add_buff_synced(arg_3_0, var_0_4[iter_3_0], BuffSyncType.LocalAndServer, var_3_0)
	end
end

var_0_0.buff_templates = {
	skulls_2023_buff = {
		buffs = {
			{
				name = "skulls_2023_buff",
				max_stacks = var_0_2
			},
			{
				event = "on_kill",
				name = "skulls_2023_buff_kill_tracker",
				max_stacks = 1,
				buff_func = "on_kill_skulls_2023_buff"
			},
			{
				name = "skulls_2023_buff_main",
				refresh_durations = true,
				duration_end_func = "cleanup_skulls_2023_buff",
				event = "on_knocked_down",
				remove_buff_func = "remove_skulls_2023_buff",
				apply_buff_func = "apply_skulls_2023_buff",
				buff_func = "dummy_function",
				remove_on_proc = true,
				max_stacks = 1,
				reapply_buff_func = "reapply_skulls_2023_buff",
				duration = var_0_1,
				duration_modifier_func = var_0_9
			}
		}
	},
	skulls_2023_buff_power_level = {
		buffs = {
			{
				name = "skulls_2023_buff_power_level",
				multiplier = 0.15,
				stat_buff = "power_level",
				buff_func = "dummy_function",
				event = "on_knocked_down",
				refresh_durations = true,
				priority_buff = true,
				remove_on_proc = true,
				max_stacks = 1,
				icon = "potion_liquid_bravado",
				duration = var_0_1
			}
		}
	},
	skulls_2023_buff_attack_speed = {
		buffs = {
			{
				name = "skulls_2023_buff_attack_speed",
				multiplier = 0.12,
				stat_buff = "attack_speed",
				buff_func = "dummy_function",
				event = "on_knocked_down",
				refresh_durations = true,
				priority_buff = true,
				remove_on_proc = true,
				max_stacks = 1,
				icon = "grudge_mark_frenzy_debuff",
				duration = var_0_1
			}
		}
	},
	skulls_2023_buff_crit_chance = {
		buffs = {
			{
				name = "skulls_2023_buff_crit_chance",
				stat_buff = "critical_strike_chance",
				buff_func = "dummy_function",
				event = "on_knocked_down",
				refresh_durations = true,
				priority_buff = true,
				remove_on_proc = true,
				max_stacks = 1,
				icon = "bardin_slayer_crit_chance",
				bonus = 0.2,
				duration = var_0_1
			}
		}
	},
	skulls_2023_buff_movement_speed = {
		buffs = {
			{
				priority_buff = true,
				name = "skulls_2023_buff_movement_speed",
				icon = "mutator_skulls_movement_speed",
				buff_func = "dummy_function",
				event = "on_knocked_down",
				remove_buff_func = "remove_movement_buff",
				refresh_durations = true,
				multiplier = 1.2,
				apply_buff_func = "apply_movement_buff",
				remove_on_proc = true,
				max_stacks = 1,
				path_to_movement_setting_to_modify = {
					"move_speed"
				},
				duration = var_0_1
			}
		}
	},
	skulls_2023_buff_cooldown_regen = {
		buffs = {
			{
				name = "skulls_2023_buff_cooldown_regen",
				multiplier = 0.25,
				stat_buff = "cooldown_regen",
				buff_func = "dummy_function",
				event = "on_knocked_down",
				refresh_durations = true,
				priority_buff = true,
				remove_on_proc = true,
				max_stacks = 1,
				icon = "mutator_skulls_cooldown_reduction",
				duration = var_0_1
			}
		}
	},
	skulls_2023_buff_refresh = {
		buffs = {
			{
				reset_on_max_stacks = true,
				name = "skulls_2023_buff_refresh",
				buff_func = "dummy_function",
				on_max_stacks_func = "skulls_2023_stack_refresh",
				icon = "buff_icon_mutator_icon_slayer_curse",
				event = "on_knocked_down",
				remove_on_proc = true,
				max_stacks = var_0_3
			}
		}
	},
	skulls_2023_debuff = {
		buffs = {
			{
				priority_buff = true,
				name = "skulls_2023_debuff",
				icon = "grudge_mark_cursed_debuff",
				buff_func = "dummy_function",
				event = "on_knocked_down",
				remove_buff_func = "remove_skulls_2023_debuff",
				apply_buff_func = "apply_skulls_2023_debuff",
				refresh_durations = true,
				remove_on_proc = true,
				debuff = true,
				duration = var_0_7,
				max_stacks = var_0_2
			},
			{
				name = "skulls_2023_debuff_dot",
				damage_percentage = 0.01,
				buff_func = "dummy_function",
				event = "on_knocked_down",
				refresh_durations = true,
				remove_on_proc = true,
				update_start_delay = 1,
				max_stacks = 1,
				update_func = "update_skulls_2023_debuff_dot",
				update_frequency = 1,
				duration = var_0_7
			}
		}
	}
}

local function var_0_11(arg_4_0)
	local var_4_0 = Managers.player:owner(arg_4_0)

	return var_4_0 and not var_4_0.remote
end

local function var_0_12(arg_5_0)
	local var_5_0 = Managers.player:owner(arg_5_0)

	return var_5_0 and var_5_0.bot_player
end

var_0_0.buff_function_templates = {
	apply_skulls_2023_buff = function (arg_6_0, arg_6_1, arg_6_2, arg_6_3)
		if not var_0_11(arg_6_0) then
			return
		end

		local var_6_0 = ScriptUnit.extension(arg_6_0, "buff_system")
		local var_6_1 = var_6_0:get_stacking_buff("skulls_2023_debuff")

		if var_6_1 then
			for iter_6_0 = #var_6_1, 1, -1 do
				local var_6_2 = var_6_1[iter_6_0].id

				var_6_0:remove_buff(var_6_2)
			end
		end

		local var_6_3 = #var_6_0:get_stacking_buff("skulls_2023_buff")

		var_0_10(arg_6_0, math.min(var_6_3, var_0_2))

		if not var_0_12(arg_6_0) then
			local var_6_4 = ScriptUnit.extension(arg_6_0, "first_person_system")
			local var_6_5 = var_6_4:create_screen_particles("fx/skulls_2023/screenspace_skulls_2023_buff")

			if var_6_5 then
				local var_6_6 = (var_6_3 - 1) / (var_0_2 - 1)
				local var_6_7 = math.lerp(-0.55, 0.4, var_6_6)

				World.set_particles_material_scalar(arg_6_3, var_6_5, "overlay", "shadow_amount", var_6_7)

				arg_6_1.effect_id = var_6_5
			end

			var_6_4:play_hud_sound_event("Play_skulls_event_buff_on")
		end
	end,
	reapply_skulls_2023_buff = function (arg_7_0, arg_7_1, arg_7_2, arg_7_3)
		if not var_0_11(arg_7_0) then
			return
		end

		local var_7_0 = #ScriptUnit.extension(arg_7_0, "buff_system"):get_stacking_buff("skulls_2023_buff")

		var_0_10(arg_7_0, math.min(var_7_0, var_0_2))

		if not var_0_12(arg_7_0) then
			local var_7_1 = arg_7_1.effect_id

			if var_7_1 then
				local var_7_2 = (var_7_0 - 1) / (var_0_2 - 1)
				local var_7_3 = math.lerp(-0.55, 0.4, var_7_2)

				World.set_particles_material_scalar(arg_7_3, var_7_1, "overlay", "shadow_amount", var_7_3)
			end

			if var_7_0 >= var_0_2 and not arg_7_1.sound_played then
				ScriptUnit.extension(arg_7_0, "first_person_system"):play_hud_sound_event("Play_skulls_event_buff_max_stacks")

				arg_7_1.sound_played = true
			end
		end
	end,
	remove_skulls_2023_buff = function (arg_8_0, arg_8_1, arg_8_2, arg_8_3)
		if arg_8_1.effect_id then
			ScriptUnit.extension(arg_8_0, "first_person_system"):stop_spawning_screen_particles(arg_8_1.effect_id)

			arg_8_1.effect_id = nil
		end

		if not var_0_11(arg_8_0) then
			return
		end

		local var_8_0 = ScriptUnit.extension(arg_8_0, "buff_system")
		local var_8_1 = var_8_0:get_stacking_buff("skulls_2023_buff_refresh")

		if var_8_1 then
			for iter_8_0 = #var_8_1, 1, -1 do
				local var_8_2 = var_8_1[iter_8_0].id

				var_8_0:remove_buff(var_8_2)
			end
		end

		local var_8_3 = (arg_8_1.start_time or 0) + (arg_8_1.duration or 0)

		if var_8_3 and var_8_3 <= arg_8_2.t then
			local var_8_4 = Managers.state.entity:system("buff_system")
			local var_8_5 = var_8_0:get_stacking_buff("skulls_2023_buff")
			local var_8_6 = var_8_5 and #var_8_5 or 0

			for iter_8_1 = 1, var_8_6 do
				var_8_4:add_buff_synced(arg_8_0, "skulls_2023_debuff", BuffSyncType.LocalAndServer, {
					external_optional_value = var_8_6
				})
			end
		end
	end,
	cleanup_skulls_2023_buff = function (arg_9_0, arg_9_1, arg_9_2, arg_9_3)
		if not ALIVE[arg_9_0] or not var_0_11(arg_9_0) then
			return
		end

		local var_9_0 = ScriptUnit.extension(arg_9_0, "buff_system")
		local var_9_1 = var_9_0:get_stacking_buff("skulls_2023_buff")

		if var_9_1 then
			for iter_9_0 = #var_9_1, 1, -1 do
				local var_9_2 = var_9_1[iter_9_0].id

				var_9_0:remove_buff(var_9_2)
			end
		end
	end,
	apply_skulls_2023_debuff = function (arg_10_0, arg_10_1, arg_10_2, arg_10_3)
		if var_0_12(arg_10_0) or not var_0_11(arg_10_0) then
			return
		end

		local var_10_0 = ScriptUnit.extension(arg_10_0, "buff_system"):get_stacking_buff("skulls_2023_debuff")

		if (var_10_0 and #var_10_0 or 0) <= 0 then
			local var_10_1 = ScriptUnit.extension(arg_10_0, "first_person_system")

			arg_10_1.effect_id = var_10_1:create_screen_particles("fx/skulls_2023/screenspace_skulls_2023_debuff")
			arg_10_1.effect_size_id = World.find_particles_variable(arg_10_3, "fx/skulls_2023/screenspace_skulls_2023_debuff", "size")

			local var_10_2 = arg_10_1.effect_id
			local var_10_3 = arg_10_1.effect_size_id
			local var_10_4 = ((arg_10_2.value or 1) - 1) / (var_0_2 - 1)
			local var_10_5 = math.lerp(1, 0.95, var_10_4)
			local var_10_6 = math.lerp(5.5, 4, var_10_4)

			World.set_particles_material_scalar(arg_10_3, var_10_2, "overlay", "intensity", var_10_5)
			World.set_particles_variable(arg_10_3, var_10_2, var_10_3, Vector3(var_10_6 * 1.33, var_10_6, var_10_6))
			var_10_1:play_hud_sound_event("Play_skulls_event_buff_off")
		end
	end,
	remove_skulls_2023_debuff = function (arg_11_0, arg_11_1, arg_11_2, arg_11_3)
		if arg_11_1.effect_id then
			ScriptUnit.extension(arg_11_0, "first_person_system"):stop_spawning_screen_particles(arg_11_1.effect_id)

			arg_11_1.effect_id = nil
		end
	end,
	update_skulls_2023_debuff_dot = function (arg_12_0, arg_12_1, arg_12_2, arg_12_3)
		if not Managers.state.network.is_server then
			return
		end

		local var_12_0 = ScriptUnit.extension(arg_12_0, "health_system")
		local var_12_1 = var_12_0:current_health()
		local var_12_2 = 1

		if var_12_2 < var_12_1 then
			local var_12_3 = ScriptUnit.extension(arg_12_0, "buff_system"):num_buff_stacks("skulls_2023_debuff")
			local var_12_4 = var_12_0:get_max_health()
			local var_12_5 = DamageUtils.networkify_damage(var_12_4 * arg_12_1.template.damage_percentage * var_12_3)
			local var_12_6 = math.min(var_12_5, var_12_1 - var_12_2)

			if var_12_6 > 0 then
				local var_12_7 = -Vector3.up()

				DamageUtils.add_damage_network(arg_12_0, arg_12_0, var_12_6, "torso", "wounded_dot", nil, var_12_7, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, 1)
			end
		end
	end
}
var_0_0.proc_functions = {
	on_kill_skulls_2023_buff = function (arg_13_0, arg_13_1, arg_13_2)
		if not var_0_11(arg_13_0) then
			return
		end

		if arg_13_2[2] then
			ScriptUnit.extension(arg_13_0, "buff_system"):add_buff("skulls_2023_buff_refresh")
		end
	end
}
var_0_0.stacking_buff_functions = {
	skulls_2023_buff_refresh = function (arg_14_0, arg_14_1)
		if ALIVE[arg_14_0] then
			local var_14_0 = ScriptUnit.has_extension(arg_14_0, "buff_system"):num_buff_stacks("skulls_2023_buff")

			var_0_10(arg_14_0, var_14_0)
		end
	end,
	skulls_2023_stack_refresh = function (arg_15_0, arg_15_1)
		if ALIVE[arg_15_0] then
			Managers.state.entity:system("buff_system"):add_buff_synced(arg_15_0, "skulls_2023_buff", BuffSyncType.LocalAndServer, {
				refresh_duration_only = true
			})
		end
	end
}
