-- chunkname: @scripts/settings/mutators/mutator_curse_egg_of_tzeentch.lua

local var_0_0 = {
	"chaos_troll",
	"chaos_spawn",
	"skaven_rat_ogre",
	"skaven_stormfiend",
	"beastmen_minotaur"
}
local var_0_1 = 2
local var_0_2 = 3
local var_0_3 = 4
local var_0_4 = 5
local var_0_5 = 6
local var_0_6 = {
	[var_0_1] = 30,
	[var_0_2] = 30,
	[var_0_3] = 30,
	[var_0_4] = 30,
	[var_0_5] = 30
}
local var_0_7 = {
	[var_0_1] = math.huge,
	[var_0_2] = math.huge,
	[var_0_3] = math.huge,
	[var_0_4] = math.huge,
	[var_0_5] = math.huge
}
local var_0_8 = {
	[var_0_1] = 100,
	[var_0_2] = 150,
	[var_0_3] = 200,
	[var_0_4] = 250,
	[var_0_5] = 300
}
local var_0_9 = {
	EGG_DESTROYED = "Play_curse_egg_of_tzeentch_alert_egg_destroyed",
	ALERT_MEDIUM = "Play_curse_egg_of_tzeentch_alert_medium",
	ALERT_LOW = "Play_curse_egg_of_tzeentch_alert_low",
	EGG_EXPLOSION = "Play_curse_egg_of_tzeentch_explosion",
	ALERT_HIGH = "Play_curse_egg_of_tzeentch_alert_high"
}
local var_0_10 = "fx/magic_wind_essence_explosion_02"
local var_0_11 = "egg_of_tzeentch"
local var_0_12 = "egg_of_tzeentch_unit"
local var_0_13 = "units/props/egg_of_tzeentch"
local var_0_14 = {
	buff_system = {
		initial_buff_names = {
			"objective_unit",
			"health_bar"
		}
	},
	health_system = {},
	death_system = {
		death_reaction_template = "destructible_buff_objective_unit"
	},
	hit_reaction_system = {
		hit_reaction_template = "level_object"
	},
	timed_spawner_system = {
		max_spawn_amount = 1
	}
}

local function var_0_15(arg_1_0, arg_1_1)
	local var_1_0 = {}

	for iter_1_0, iter_1_1 in ipairs(arg_1_0) do
		if arg_1_1[iter_1_1] then
			table.insert(var_1_0, iter_1_1)
		end
	end

	return var_1_0
end

local function var_0_16(arg_2_0, arg_2_1)
	return LocomotionUtils.pos_on_mesh(arg_2_0, arg_2_1, 1, 1) or GwNavQueries.inside_position_from_outside_position(arg_2_0, arg_2_1, 6, 6, 8, 0.5)
end

local function var_0_17(arg_3_0, arg_3_1, arg_3_2, arg_3_3, arg_3_4, arg_3_5)
	arg_3_5 = math.clamp(arg_3_5, 0, MainPathUtils.total_path_dist() - 0.1)

	local var_3_0 = arg_3_0.level_analysis:get_main_paths()
	local var_3_1 = MainPathUtils.point_on_mainpath(var_3_0, arg_3_5)
	local var_3_2 = var_3_1 and var_0_16(arg_3_2, var_3_1)

	if not var_3_2 then
		mutator_dprint("Couldn't find a spawn position on the navmesh")

		return
	end

	local var_3_3 = math.random() * math.pi * 2
	local var_3_4 = Quaternion.from_elements(0, 0, var_3_3, 0)
	local var_3_5 = arg_3_1:spawn_network_unit(var_0_13, var_0_12, arg_3_4, var_3_2, var_3_4)

	arg_3_3:request_mission("egg_of_tzeentch")
	Managers.state.entity:system("audio_system"):play_2d_audio_event(var_0_9.ALERT_LOW)

	return var_3_5
end

local function var_0_18(arg_4_0, arg_4_1, arg_4_2, arg_4_3)
	if arg_4_1 > MainPathUtils.total_path_dist() then
		return false
	end

	local var_4_0 = false
	local var_4_1 = 0
	local var_4_2 = math.huge

	for iter_4_0, iter_4_1 in ipairs(arg_4_3) do
		if arg_4_0 < iter_4_1 and iter_4_1 < var_4_2 then
			var_4_2 = iter_4_1
		end

		if var_4_1 < iter_4_1 then
			var_4_1 = iter_4_1
			var_4_0 = var_4_1 <= arg_4_1
		end
	end

	local var_4_3 = var_4_2 - arg_4_2

	if var_4_0 or var_4_3 < arg_4_1 then
		return false
	else
		return true
	end
end

return {
	display_name = "curse_egg_of_tzeentch_name",
	icon = "deus_curse_tzeentch_01",
	description = "curse_egg_of_tzeentch_desc",
	packages = {
		"resource_packages/mutators/mutator_curse_egg_of_tzeentch"
	},
	client_start_function = function (arg_5_0, arg_5_1)
		arg_5_1.vfx_ids = {}
		arg_5_1.wwise_world = Managers.world:wwise_world(arg_5_0.world)
	end,
	server_start_function = function (arg_6_0, arg_6_1)
		arg_6_1.seed = Managers.mechanism:get_level_seed()
		arg_6_1.difficulty_rank = Managers.state.difficulty:get_difficulty_rank()
		arg_6_1.mission_system = Managers.state.entity:system("mission_system")
		arg_6_1.unit_spawner = Managers.state.unit_spawner
		arg_6_1.nav_world = Managers.state.entity:system("ai_system"):nav_world()
		arg_6_1.num_available_eggs = var_0_7[arg_6_1.difficulty_rank] or var_0_7[var_0_1]
		arg_6_1.num_destroyed_eggs = 0
		arg_6_1.monster_spawned = arg_6_1.template.monster_spawned

		Managers.state.event:register(arg_6_1, "spawned_timed_breed", "monster_spawned")
	end,
	tweak_zones = function (arg_7_0, arg_7_1, arg_7_2, arg_7_3, arg_7_4)
		arg_7_1.conflict_director = Managers.state.conflict
		arg_7_1.peaks = arg_7_1.conflict_director:get_peaks()
	end,
	update_conflict_settings = function (arg_8_0, arg_8_1)
		CurrentBossSettings.disabled = true
	end,
	server_players_left_safe_zone = function (arg_9_0, arg_9_1)
		arg_9_1.timer = MutatorCommonSettings.deus.initial_activation_delay
	end,
	server_update_function = function (arg_10_0, arg_10_1, arg_10_2, arg_10_3)
		local var_10_0 = arg_10_1.mission_system
		local var_10_1 = var_10_0:get_missions()
		local var_10_2 = table.size(var_10_1)

		if not arg_10_1.timer and var_10_2 >= 2 and ALIVE[arg_10_1.egg_unit] and var_10_0:has_active_mission(var_0_11) then
			AiUtils.kill_unit(arg_10_1.egg_unit)

			arg_10_1.alert_timer = nil
			arg_10_1.alert_high_triggered = false
			arg_10_1.alert_medium_triggered = false
		end

		local var_10_3 = arg_10_1.conflict_director.pacing:get_state() == "pacing_frozen"

		if HEALTH_ALIVE[arg_10_1.last_spawned_monster] or var_10_3 or var_10_2 > 0 then
			return
		end

		local var_10_4 = Missions.egg_of_tzeentch
		local var_10_5 = arg_10_1.alert_timer
		local var_10_6 = var_10_5 and var_10_5 - arg_10_2

		arg_10_1.alert_timer = var_10_6

		if var_10_6 then
			if var_10_6 < var_10_4.alert_medium_timer and not arg_10_1.alert_medium_triggered then
				arg_10_1.alert_medium_triggered = true

				Managers.state.entity:system("audio_system"):play_2d_audio_event(var_0_9.ALERT_MEDIUM)

				local var_10_7 = Managers.state.entity:system("dialogue_system"):get_random_player()

				if var_10_7 then
					local var_10_8 = ScriptUnit.extension_input(var_10_7, "dialogue_system")
					local var_10_9 = FrameTable.alloc_table()

					var_10_8:trigger_dialogue_event("curse_move_on", var_10_9)
				end
			elseif var_10_6 < var_10_4.alert_high_timer and not arg_10_1.alert_high_triggered then
				arg_10_1.alert_high_triggered = true

				Managers.state.entity:system("audio_system"):play_2d_audio_event(var_0_9.ALERT_HIGH)

				arg_10_1.alert_timer = nil
			end
		end

		local var_10_10 = arg_10_1.timer
		local var_10_11 = var_10_10 and var_10_10 - arg_10_2
		local var_10_12 = var_10_11 and var_10_11 > 0

		if not var_10_11 or var_10_12 then
			arg_10_1.timer = var_10_11

			return
		end

		local var_10_13 = arg_10_1.conflict_director
		local var_10_14 = var_10_13.main_path_info
		local var_10_15 = var_10_13.main_path_player_info[var_10_14.ahead_unit]

		if not var_10_15 then
			return
		end

		local var_10_16 = var_10_15.travel_dist
		local var_10_17 = var_10_4.distance + var_10_16
		local var_10_18 = var_10_4.ahead_peak_distance

		if not var_0_18(var_10_16, var_10_17, var_10_18, arg_10_1.peaks) then
			return
		end

		arg_10_1.timer = nil

		local var_10_19 = Managers.state.difficulty:get_difficulty()
		local var_10_20 = CurrentConflictSettings.contained_breeds[var_10_19]
		local var_10_21 = var_0_15(var_0_0, var_10_20)
		local var_10_22 = var_10_4.duration
		local var_10_23 = table.clone(var_0_14)

		var_10_23.health_system.health = var_0_8[arg_10_1.difficulty_rank] or var_0_8[var_0_1]

		local var_10_24 = var_10_23.timed_spawner_system

		var_10_24.spawn_rate = var_10_22
		var_10_24.spawnable_breeds = var_10_21

		var_10_24.cb_unit_spawned_function = function (arg_11_0)
			arg_10_1.last_spawned_monster = arg_11_0

			Managers.state.entity:system("audio_system"):play_2d_audio_event(var_0_9.EGG_DESTROYED)
		end

		arg_10_1.alert_timer = var_10_22
		arg_10_1.alert_high_triggered = false
		arg_10_1.alert_medium_triggered = false
		arg_10_1.egg_unit = var_0_17(var_10_13, arg_10_1.unit_spawner, arg_10_1.nav_world, arg_10_1.mission_system, var_10_23, var_10_17)
	end,
	server_level_object_killed_function = function (arg_12_0, arg_12_1, arg_12_2)
		if Unit.is_a(arg_12_2, var_0_13) then
			arg_12_1.template.on_egg_destroyed(arg_12_1, arg_12_2)

			local var_12_0 = arg_12_1.mission_system

			if var_12_0:has_active_mission(var_0_11) then
				var_12_0:end_mission(var_0_11, true)
			end

			local var_12_1 = Managers.state.entity:system("dialogue_system"):get_random_player()

			if var_12_1 then
				local var_12_2 = ScriptUnit.extension_input(var_12_1, "dialogue_system")
				local var_12_3 = FrameTable.alloc_table()

				var_12_2:trigger_dialogue_event("curse_objective_achieved", var_12_3)
			end
		end
	end,
	on_egg_destroyed = function (arg_13_0, arg_13_1)
		if not Unit.is_a(arg_13_1, var_0_13) then
			return
		end

		arg_13_0.num_destroyed_eggs = arg_13_0.num_destroyed_eggs + 1

		if arg_13_0.num_destroyed_eggs < arg_13_0.num_available_eggs then
			arg_13_0.timer = var_0_6[arg_13_0.difficulty_rank] or var_0_6[var_0_1]
		else
			arg_13_0.timer = nil
		end
	end,
	monster_spawned = function (arg_14_0, arg_14_1)
		arg_14_0.template.on_egg_destroyed(arg_14_0, arg_14_1)

		local var_14_0 = Managers.state.entity:system("dialogue_system"):get_random_player()

		if var_14_0 then
			local var_14_1 = ScriptUnit.extension_input(var_14_0, "dialogue_system")
			local var_14_2 = FrameTable.alloc_table()

			var_14_1:trigger_dialogue_event("curse_very_negative_effect_happened", var_14_2)
		end
	end,
	server_stop_function = function (arg_15_0, arg_15_1, arg_15_2)
		CurrentBossSettings.disabled = false
	end,
	client_level_object_killed_function = function (arg_16_0, arg_16_1, arg_16_2)
		if Unit.is_a(arg_16_2, var_0_13) then
			local var_16_0 = POSITION_LOOKUP[arg_16_2]

			arg_16_1.template.play_effect(arg_16_0, arg_16_1, var_16_0, var_0_10, var_0_9.EGG_EXPLOSION)
		end

		arg_16_1.alert_timer = nil
	end,
	play_effect = function (arg_17_0, arg_17_1, arg_17_2, arg_17_3, arg_17_4)
		if arg_17_3 then
			local var_17_0 = World.create_particles(arg_17_0.world, arg_17_3, arg_17_2)

			table.insert(arg_17_1.vfx_ids, var_17_0)
		end

		if arg_17_4 then
			WwiseUtils.trigger_position_event(arg_17_0.world, arg_17_4, arg_17_2)
		end
	end,
	client_stop_function = function (arg_18_0, arg_18_1)
		for iter_18_0, iter_18_1 in ipairs(arg_18_1.vfx_ids) do
			World.destroy_particles(arg_18_0.world, iter_18_1)
		end
	end
}
