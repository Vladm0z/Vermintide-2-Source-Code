-- chunkname: @scripts/settings/dlcs/skulls_2023/buff_settings_skulls_2023.lua

local skulls_2023 = DLCSettings.skulls_2023
local num = 30
local num_2 = 5
local num_3 = 1
local tbl = {
	"skulls_2023_buff_power_level",
	"skulls_2023_buff_attack_speed",
	"skulls_2023_buff_crit_chance",
	"skulls_2023_buff_movement_speed",
	"skulls_2023_buff_cooldown_regen"
}
local num_4 = 30
local num_5 = 15
local num_6 = 20

local function fn(arg_1_0, arg_1_1)
	-- function 1
	local num = num_4 + num_5 * num_2 - num_5 * arg_1_0

	if not (ScriptUnit.extension(arg_1_1, "buff_system"):num_buff_stacks("power_up_boon_skulls_set_bonus_02_event") > 0) then
		num = num * (1 + MorrisBuffTweakData.boon_skulls_set_bonus_02.duration_amplify_amount)
	end

	return num
end

local function fn_2(arg_2_0, arg_2_1, arg_2_2, arg_2_3)
	-- function 2
	local num_buff_stacks = arg_2_3:num_buff_stacks("skulls_2023_buff")

	return fn(math.min(num_buff_stacks, num_2), arg_2_0)
end

local function fn_3(arg_3_0, arg_3_1)
	-- function 3
	local tbl_2 = {
		external_optional_duration = fn(arg_3_1, arg_3_0)
	}
	local system = Managers.state.entity:system("buff_system")

	for i = 1, math.min(arg_3_1, #tbl) do
		system:add_buff_synced(arg_3_0, tbl[i], BuffSyncType.LocalAndServer, tbl_2)
	end
end

skulls_2023.buff_templates = {
	skulls_2023_buff = {
		buffs = {
			{
				name = "skulls_2023_buff",
				max_stacks = num_2
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
				duration = num,
				duration_modifier_func = fn_2
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
				duration = num
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
				duration = num
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
				duration = num
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
				duration = num
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
				duration = num
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
				max_stacks = num_3
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
				duration = num_6,
				max_stacks = num_2
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
				duration = num_6
			}
		}
	}
}

local function fn_4(arg_4_0)
	-- function 4
	local owner = Managers.player:owner(arg_4_0)

	return not owner and not owner.remote
end

local function fn_5(arg_5_0)
	-- function 5
	local owner = Managers.player:owner(arg_5_0)

	return not owner and owner.bot_player
end

skulls_2023.buff_function_templates = {
	apply_skulls_2023_buff = function (arg_6_0, arg_6_1, arg_6_2, arg_6_3)
		-- function 6
		if not fn_4(arg_6_0) then
			return
		end

		local extension = ScriptUnit.extension(arg_6_0, "buff_system")
		local get_stacking_buff = extension:get_stacking_buff("skulls_2023_debuff")

		if not get_stacking_buff then
			for i = #get_stacking_buff, 1, -1 do
				local id = get_stacking_buff[i].id

				extension:remove_buff(id)
			end
		end

		local count = #extension:get_stacking_buff("skulls_2023_buff")

		fn_3(arg_6_0, math.min(count, num_2))

		if not fn_5(arg_6_0) then
			local extension_2 = ScriptUnit.extension(arg_6_0, "first_person_system")
			local create_screen_particles = extension_2:create_screen_particles("fx/skulls_2023/screenspace_skulls_2023_buff")

			if not create_screen_particles then
				local num = (count - 1) / (num_2 - 1)
				local lerp = math.lerp(-0.55, 0.4, num)

				World.set_particles_material_scalar(arg_6_3, create_screen_particles, "overlay", "shadow_amount", lerp)

				arg_6_1.effect_id = create_screen_particles
			end

			extension_2:play_hud_sound_event("Play_skulls_event_buff_on")
		end
	end,
	reapply_skulls_2023_buff = function (arg_7_0, arg_7_1, arg_7_2, arg_7_3)
		-- function 7
		if not fn_4(arg_7_0) then
			return
		end

		local count = #ScriptUnit.extension(arg_7_0, "buff_system"):get_stacking_buff("skulls_2023_buff")

		fn_3(arg_7_0, math.min(count, num_2))

		if not fn_5(arg_7_0) then
			local effect_id = arg_7_1.effect_id

			if not effect_id then
				local num = (count - 1) / (num_2 - 1)
				local lerp = math.lerp(-0.55, 0.4, num)

				World.set_particles_material_scalar(arg_7_3, effect_id, "overlay", "shadow_amount", lerp)
			end

			if not (not (count >= num_2) or arg_7_1.sound_played) then
				ScriptUnit.extension(arg_7_0, "first_person_system"):play_hud_sound_event("Play_skulls_event_buff_max_stacks")

				arg_7_1.sound_played = true
			end
		end
	end,
	remove_skulls_2023_buff = function (arg_8_0, arg_8_1, arg_8_2, arg_8_3)
		-- function 8
		if not arg_8_1.effect_id then
			ScriptUnit.extension(arg_8_0, "first_person_system"):stop_spawning_screen_particles(arg_8_1.effect_id)

			arg_8_1.effect_id = nil
		end

		if not fn_4(arg_8_0) then
			return
		end

		local extension = ScriptUnit.extension(arg_8_0, "buff_system")
		local get_stacking_buff = extension:get_stacking_buff("skulls_2023_buff_refresh")

		if not get_stacking_buff then
			for i = #get_stacking_buff, 1, -1 do
				local id = get_stacking_buff[i].id

				extension:remove_buff(id)
			end
		end

		local start_time = arg_8_1.start_time

		start_time = start_time or 0

		local duration = arg_8_1.duration

		duration = duration or 0

		local num = start_time + duration

		if not (not num and not (num <= arg_8_2.t)) then
			local system = Managers.state.entity:system("buff_system")
			local get_stacking_buff_2 = extension:get_stacking_buff("skulls_2023_buff")
			local count

			if not get_stacking_buff_2 then
				count = #get_stacking_buff_2

				if not count then
					-- Nothing
				end
			end

			count = 0

			::label_8_0::

			for j = 1, count do
				system:add_buff_synced(arg_8_0, "skulls_2023_debuff", BuffSyncType.LocalAndServer, {
					external_optional_value = count
				})
			end
		end
	end,
	cleanup_skulls_2023_buff = function (arg_9_0, arg_9_1, arg_9_2, arg_9_3)
		-- function 9
		if not (not ALIVE[arg_9_0] and fn_4(arg_9_0)) then
			return
		end

		local extension = ScriptUnit.extension(arg_9_0, "buff_system")
		local get_stacking_buff = extension:get_stacking_buff("skulls_2023_buff")

		if not get_stacking_buff then
			for i = #get_stacking_buff, 1, -1 do
				local id = get_stacking_buff[i].id

				extension:remove_buff(id)
			end
		end
	end,
	apply_skulls_2023_debuff = function (arg_10_0, arg_10_1, arg_10_2, arg_10_3)
		-- function 10
		if not (fn_5(arg_10_0) or fn_4(arg_10_0)) then
			return
		end

		local get_stacking_buff = ScriptUnit.extension(arg_10_0, "buff_system"):get_stacking_buff("skulls_2023_debuff")
		local count

		if not get_stacking_buff then
			count = #get_stacking_buff

			if not count then
				-- Nothing
			end
		end

		count = 0

		::label_10_0::

		if count <= 0 then
			local extension = ScriptUnit.extension(arg_10_0, "first_person_system")

			arg_10_1.effect_id = extension:create_screen_particles("fx/skulls_2023/screenspace_skulls_2023_debuff")
			arg_10_1.effect_size_id = World.find_particles_variable(arg_10_3, "fx/skulls_2023/screenspace_skulls_2023_debuff", "size")

			local effect_id = arg_10_1.effect_id
			local effect_size_id = arg_10_1.effect_size_id
			local value = arg_10_2.value

			value = value or 1

			local num = (value - 1) / (num_2 - 1)
			local lerp = math.lerp(1, 0.95, num)
			local lerp_2 = math.lerp(5.5, 4, num)

			World.set_particles_material_scalar(arg_10_3, effect_id, "overlay", "intensity", lerp)
			World.set_particles_variable(arg_10_3, effect_id, effect_size_id, Vector3(lerp_2 * 1.33, lerp_2, lerp_2))
			extension:play_hud_sound_event("Play_skulls_event_buff_off")
		end
	end,
	remove_skulls_2023_debuff = function (arg_11_0, arg_11_1, arg_11_2, arg_11_3)
		-- function 11
		if not arg_11_1.effect_id then
			ScriptUnit.extension(arg_11_0, "first_person_system"):stop_spawning_screen_particles(arg_11_1.effect_id)

			arg_11_1.effect_id = nil
		end
	end,
	update_skulls_2023_debuff_dot = function (arg_12_0, arg_12_1, arg_12_2, arg_12_3)
		-- function 12
		if not Managers.state.network.is_server then
			return
		end

		local extension = ScriptUnit.extension(arg_12_0, "health_system")
		local current_health = extension:current_health()
		local num = 1

		if num < current_health then
			local num_buff_stacks = ScriptUnit.extension(arg_12_0, "buff_system"):num_buff_stacks("skulls_2023_debuff")
			local get_max_health = extension:get_max_health()
			local networkify_damage = DamageUtils.networkify_damage(get_max_health * arg_12_1.template.damage_percentage * num_buff_stacks)
			local min = math.min(networkify_damage, current_health - num)

			if min > 0 then
				local num_2 = -Vector3.up()

				DamageUtils.add_damage_network(arg_12_0, arg_12_0, min, "torso", "wounded_dot", nil, num_2, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, 1)
			end
		end
	end
}
skulls_2023.proc_functions = {
	on_kill_skulls_2023_buff = function (arg_13_0, arg_13_1, arg_13_2)
		-- function 13
		if not fn_4(arg_13_0) then
			return
		end

		if not arg_13_2[2] then
			ScriptUnit.extension(arg_13_0, "buff_system"):add_buff("skulls_2023_buff_refresh")
		end
	end
}
skulls_2023.stacking_buff_functions = {
	skulls_2023_buff_refresh = function (arg_14_0, arg_14_1)
		-- function 14
		if not ALIVE[arg_14_0] then
			local num_buff_stacks = ScriptUnit.has_extension(arg_14_0, "buff_system"):num_buff_stacks("skulls_2023_buff")

			fn_3(arg_14_0, num_buff_stacks)
		end
	end,
	skulls_2023_stack_refresh = function (arg_15_0, arg_15_1)
		-- function 15
		if not ALIVE[arg_15_0] then
			Managers.state.entity:system("buff_system"):add_buff_synced(arg_15_0, "skulls_2023_buff", BuffSyncType.LocalAndServer, {
				refresh_duration_only = true
			})
		end
	end
}
