-- chunkname: @scripts/settings/mutators/mutator_curse_egg_of_tzeentch.lua

local tbl = {
	"chaos_troll",
	"chaos_spawn",
	"skaven_rat_ogre",
	"skaven_stormfiend",
	"beastmen_minotaur"
}
local num = 2
local num_2 = 3
local num_3 = 4
local num_4 = 5
local num_5 = 6
local tbl_2 = {
	[num] = 30,
	[num_2] = 30,
	[num_3] = 30,
	[num_4] = 30,
	[num_5] = 30
}
local tbl_3 = {
	[num] = math.huge,
	[num_2] = math.huge,
	[num_3] = math.huge,
	[num_4] = math.huge,
	[num_5] = math.huge
}
local tbl_4 = {
	[num] = 100,
	[num_2] = 150,
	[num_3] = 200,
	[num_4] = 250,
	[num_5] = 300
}
local tbl_5 = {
	EGG_DESTROYED = "Play_curse_egg_of_tzeentch_alert_egg_destroyed",
	ALERT_MEDIUM = "Play_curse_egg_of_tzeentch_alert_medium",
	ALERT_LOW = "Play_curse_egg_of_tzeentch_alert_low",
	EGG_EXPLOSION = "Play_curse_egg_of_tzeentch_explosion",
	ALERT_HIGH = "Play_curse_egg_of_tzeentch_alert_high"
}
local str = "fx/magic_wind_essence_explosion_02"
local str_2 = "egg_of_tzeentch"
local str_3 = "egg_of_tzeentch_unit"
local str_4 = "units/props/egg_of_tzeentch"
local tbl_6 = {
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

local function fn(arg_1_0, arg_1_1)
	-- function 1
	local tbl = {}

	for i, v in ipairs(arg_1_0) do
		if not arg_1_1[v] then
			table.insert(tbl, v)
		end
	end

	return tbl
end

local function fn_2(arg_2_0, arg_2_1)
	-- function 2
	local pos_on_mesh = LocomotionUtils.pos_on_mesh(arg_2_0, arg_2_1, 1, 1)

	pos_on_mesh = pos_on_mesh or GwNavQueries.inside_position_from_outside_position(arg_2_0, arg_2_1, 6, 6, 8, 0.5)

	return pos_on_mesh
end

local function fn_3(self, arg_3_1, arg_3_2, arg_3_3, arg_3_4, arg_3_5)
	-- function 3
	arg_3_5 = math.clamp(arg_3_5, 0, MainPathUtils.total_path_dist() - 0.1)

	local get_main_paths = self.level_analysis:get_main_paths()
	local point_on_mainpath = MainPathUtils.point_on_mainpath(get_main_paths, arg_3_5)
	local flag = not point_on_mainpath and fn_2(arg_3_2, point_on_mainpath)

	if not flag then
		mutator_dprint("Couldn't find a spawn position on the navmesh")

		return
	end

	local num = math.random() * math.pi * 2
	local from_elements = Quaternion.from_elements(0, 0, num, 0)
	local spawn_network_unit = arg_3_1:spawn_network_unit(str_4, str_3, arg_3_4, flag, from_elements)

	arg_3_3:request_mission("egg_of_tzeentch")
	Managers.state.entity:system("audio_system"):play_2d_audio_event(tbl_5.ALERT_LOW)

	return spawn_network_unit
end

local function fn_4(arg_4_0, arg_4_1, arg_4_2, arg_4_3)
	-- function 4
	if arg_4_1 > MainPathUtils.total_path_dist() then
		return false
	end

	local flag = false
	local num = 0
	local huge = math.huge

	for i, v in ipairs(arg_4_3) do
		if not (not (arg_4_0 < v) or not (v < huge)) then
			huge = v
		end

		if num < v then
			num = v
			flag = num <= arg_4_1
		end
	end

	local num_2 = huge - arg_4_2

	if not (flag or not (num_2 < arg_4_1)) then
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
	client_start_function = function (self, arg_5_1)
		-- function 5
		arg_5_1.vfx_ids = {}
		arg_5_1.wwise_world = Managers.world:wwise_world(self.world)
	end,
	server_start_function = function (arg_6_0, arg_6_1)
		-- function 6
		arg_6_1.seed = Managers.mechanism:get_level_seed()
		arg_6_1.difficulty_rank = Managers.state.difficulty:get_difficulty_rank()
		arg_6_1.mission_system = Managers.state.entity:system("mission_system")
		arg_6_1.unit_spawner = Managers.state.unit_spawner
		arg_6_1.nav_world = Managers.state.entity:system("ai_system"):nav_world()

		local var_6_0 = tbl_3[arg_6_1.difficulty_rank]

		var_6_0 = var_6_0 or tbl_3[num]
		arg_6_1.num_available_eggs = var_6_0
		arg_6_1.num_destroyed_eggs = 0
		arg_6_1.monster_spawned = arg_6_1.template.monster_spawned

		Managers.state.event:register(arg_6_1, "spawned_timed_breed", "monster_spawned")
	end,
	tweak_zones = function (arg_7_0, arg_7_1, arg_7_2, arg_7_3, arg_7_4)
		-- function 7
		arg_7_1.conflict_director = Managers.state.conflict
		arg_7_1.peaks = arg_7_1.conflict_director:get_peaks()
	end,
	update_conflict_settings = function (arg_8_0, arg_8_1)
		-- function 8
		CurrentBossSettings.disabled = true
	end,
	server_players_left_safe_zone = function (arg_9_0, arg_9_1)
		-- function 9
		arg_9_1.timer = MutatorCommonSettings.deus.initial_activation_delay
	end,
	server_update_function = function (arg_10_0, arg_10_1, arg_10_2, arg_10_3)
		-- function 10
		local mission_system = arg_10_1.mission_system
		local get_missions = mission_system:get_missions()
		local size = table.size(get_missions)

		if (arg_10_1.timer or not (size >= 2) or not ALIVE[arg_10_1.egg_unit]) and not mission_system:has_active_mission(str_2) then
			AiUtils.kill_unit(arg_10_1.egg_unit)

			arg_10_1.alert_timer = nil
			arg_10_1.alert_high_triggered = false
			arg_10_1.alert_medium_triggered = false
		end

		local flag = arg_10_1.conflict_director.pacing:get_state() == "pacing_frozen"

		if not (HEALTH_ALIVE[arg_10_1.last_spawned_monster] or flag or not (size > 0)) then
			return
		end

		local egg_of_tzeentch = Missions.egg_of_tzeentch
		local alert_timer = arg_10_1.alert_timer
		local flag_2 = not alert_timer and alert_timer - arg_10_2

		arg_10_1.alert_timer = flag_2

		if not flag_2 then
			if not (not (flag_2 < egg_of_tzeentch.alert_medium_timer) or arg_10_1.alert_medium_triggered) then
				arg_10_1.alert_medium_triggered = true

				Managers.state.entity:system("audio_system"):play_2d_audio_event(tbl_5.ALERT_MEDIUM)

				local get_random_player = Managers.state.entity:system("dialogue_system"):get_random_player()

				if not get_random_player then
					local extension_input = ScriptUnit.extension_input(get_random_player, "dialogue_system")
					local alloc_table = FrameTable.alloc_table()

					extension_input:trigger_dialogue_event("curse_move_on", alloc_table)
				end
			elseif not (not (flag_2 < egg_of_tzeentch.alert_high_timer) or arg_10_1.alert_high_triggered) then
				arg_10_1.alert_high_triggered = true

				Managers.state.entity:system("audio_system"):play_2d_audio_event(tbl_5.ALERT_HIGH)

				arg_10_1.alert_timer = nil
			end
		end

		local timer = arg_10_1.timer
		local flag_3 = not timer and timer - arg_10_2
		local flag_4 = not flag_3 and flag_3 > 0

		if not flag_3 and not flag_4 then
			arg_10_1.timer = flag_3

			return
		end

		local conflict_director = arg_10_1.conflict_director
		local main_path_info = conflict_director.main_path_info
		local var_10_15 = conflict_director.main_path_player_info[main_path_info.ahead_unit]

		if not var_10_15 then
			return
		end

		local travel_dist = var_10_15.travel_dist
		local num_2 = egg_of_tzeentch.distance + travel_dist
		local ahead_peak_distance = egg_of_tzeentch.ahead_peak_distance

		if not fn_4(travel_dist, num_2, ahead_peak_distance, arg_10_1.peaks) then
			return
		end

		arg_10_1.timer = nil

		local get_difficulty = Managers.state.difficulty:get_difficulty()
		local var_10_20 = CurrentConflictSettings.contained_breeds[get_difficulty]
		local var_10_21 = fn(tbl, var_10_20)
		local duration = egg_of_tzeentch.duration
		local clone = table.clone(tbl_6)
		local health_system = clone.health_system
		local var_10_25 = tbl_4[arg_10_1.difficulty_rank]

		var_10_25 = var_10_25 or tbl_4[num]
		health_system.health = var_10_25

		local timed_spawner_system = clone.timed_spawner_system

		timed_spawner_system.spawn_rate = duration
		timed_spawner_system.spawnable_breeds = var_10_21

		timed_spawner_system.cb_unit_spawned_function = function (arg_11_0)
			-- function 11
			arg_10_1.last_spawned_monster = arg_11_0

			Managers.state.entity:system("audio_system"):play_2d_audio_event(tbl_5.EGG_DESTROYED)
		end

		arg_10_1.alert_timer = duration
		arg_10_1.alert_high_triggered = false
		arg_10_1.alert_medium_triggered = false
		arg_10_1.egg_unit = fn_3(conflict_director, arg_10_1.unit_spawner, arg_10_1.nav_world, arg_10_1.mission_system, clone, num_2)
	end,
	server_level_object_killed_function = function (arg_12_0, arg_12_1, arg_12_2)
		-- function 12
		if not Unit.is_a(arg_12_2, str_4) then
			arg_12_1.template.on_egg_destroyed(arg_12_1, arg_12_2)

			local mission_system = arg_12_1.mission_system

			if not mission_system:has_active_mission(str_2) then
				mission_system:end_mission(str_2, true)
			end

			local get_random_player = Managers.state.entity:system("dialogue_system"):get_random_player()

			if not get_random_player then
				local extension_input = ScriptUnit.extension_input(get_random_player, "dialogue_system")
				local alloc_table = FrameTable.alloc_table()

				extension_input:trigger_dialogue_event("curse_objective_achieved", alloc_table)
			end
		end
	end,
	on_egg_destroyed = function (self, arg_13_1)
		-- function 13
		if not Unit.is_a(arg_13_1, str_4) then
			return
		end

		self.num_destroyed_eggs = self.num_destroyed_eggs + 1

		if self.num_destroyed_eggs < self.num_available_eggs then
			local var_13_0 = tbl_2[self.difficulty_rank]

			var_13_0 = var_13_0 or tbl_2[num]
			self.timer = var_13_0
		else
			self.timer = nil
		end
	end,
	monster_spawned = function (self, arg_14_1)
		-- function 14
		self.template.on_egg_destroyed(self, arg_14_1)

		local get_random_player = Managers.state.entity:system("dialogue_system"):get_random_player()

		if not get_random_player then
			local extension_input = ScriptUnit.extension_input(get_random_player, "dialogue_system")
			local alloc_table = FrameTable.alloc_table()

			extension_input:trigger_dialogue_event("curse_very_negative_effect_happened", alloc_table)
		end
	end,
	server_stop_function = function (arg_15_0, arg_15_1, arg_15_2)
		-- function 15
		CurrentBossSettings.disabled = false
	end,
	client_level_object_killed_function = function (arg_16_0, arg_16_1, arg_16_2)
		-- function 16
		if not Unit.is_a(arg_16_2, str_4) then
			local var_16_0 = POSITION_LOOKUP[arg_16_2]

			arg_16_1.template.play_effect(arg_16_0, arg_16_1, var_16_0, str, tbl_5.EGG_EXPLOSION)
		end

		arg_16_1.alert_timer = nil
	end,
	play_effect = function (self, arg_17_1, arg_17_2, arg_17_3, arg_17_4)
		-- function 17
		if not arg_17_3 then
			local create_particles = World.create_particles(self.world, arg_17_3, arg_17_2)

			table.insert(arg_17_1.vfx_ids, create_particles)
		end

		if not arg_17_4 then
			WwiseUtils.trigger_position_event(self.world, arg_17_4, arg_17_2)
		end
	end,
	client_stop_function = function (self, arg_18_1)
		-- function 18
		for i, v in ipairs(arg_18_1.vfx_ids) do
			World.destroy_particles(self.world, v)
		end
	end
}
