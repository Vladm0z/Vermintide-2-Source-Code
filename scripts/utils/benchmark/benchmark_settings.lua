-- chunkname: @scripts/utils/benchmark/benchmark_settings.lua

require("scripts/settings/level_settings")

BenchmarkSettings = {
	cycle_view_time = 30,
	main_path_teleport_time = 2,
	initial_cycle_time = 30,
	debug = false,
	bot_selection_timer = 3,
	cycle_views = true,
	overview_downtime = 60,
	attract_benchmark = false,
	overview_duration = 10,
	cycle_time = 90,
	is_story_based = true,
	destroy_close_enemies_radius = 20,
	auto_host_level = "military",
	bot_damage_multiplier = 5,
	game_seed = 846387,
	destroy_close_enemies_timer = 90,
	initial_overview_time = math.huge,
	parameters = {
		player_invincible = true,
		network_debug = false,
		disable_tutorial_at_start = true,
		disable_gutter_runner = true,
		hide_version_info = true,
		network_debug_connections = false,
		spawn_empty_chest = true,
		disable_debug_draw = true,
		disable_pack_master = true,
		network_log_messages = false,
		disable_intro_trailer = true,
		force_steam = true,
		debug_interactions = false,
		screen_space_player_camera_reactions = false,
		infinite_ammo = true,
		honduras_demo = false,
		hide_fps = true
	},
	attract_mode_settings = {
		display_name = "intel_loading_screen_attract_mode",
		loading_screen_wwise_events = {}
	},
	benchmark_mode_settings = {
		display_name = "intel_loading_screen_benchmark_mode",
		loading_screen_wwise_events = {}
	}
}

local function fn(arg_1_0)
	-- function 1
	for k, v in pairs(arg_1_0) do
		Development.set_parameter(k, v)

		script_data[k] = v
	end
end

local function fn_2(self)
	-- function 2
	local auto_host_level = BenchmarkSettings.auto_host_level
	local var_2_1 = LevelSettings[auto_host_level]

	var_2_1.display_name = self.display_name
	var_2_1.loading_screen_wwise_events = self.loading_screen_wwise_events
	script_data.no_loading_screen_tip_texts = true
end

local function fn_3(arg_3_0)
	-- function 3
	local function fn(arg_4_0)
		-- function 4
		return arg_3_0[arg_4_0]
	end

	Development.parameter = fn
end

local flag = false
local tbl = {
	Application.argv()
}

for k, v in pairs(tbl) do
	if v == "-attract-mode" then
		LAUNCH_MODE = "attract"

		Development.set_parameter("attract_mode", true)
		fn(BenchmarkSettings.parameters)
		fn_2(BenchmarkSettings.attract_mode_settings)

		break
	end

	if v == "-benchmark-mode" then
		LAUNCH_MODE = "attract_benchmark"
		BenchmarkSettings.attract_benchmark = true
		BenchmarkSettings.parameters.hide_fps = false
		BenchmarkSettings.parameters.show_fps = true
		BenchmarkSettings.parameters.attract_mode = true
		BenchmarkSettings.parameters.skip_start_screen = true

		fn_2(BenchmarkSettings.benchmark_mode_settings)
		fn_3(BenchmarkSettings.parameters)

		break
	end

	if v == "-demo-mode" then
		flag = true
	end
end

BenchmarkSettings.demo_mode_overrides = function ()
	-- function 5
	if not flag then
		print("Entering demo mode")

		for k, v in pairs(PackSpawningSettings) do
			v.area_density_coefficient = v.area_density_coefficient * 0.75
		end

		for k_2, v_2 in pairs(BreedPacks) do
			if not v_2.patrol_overrides then
				v_2.patrol_overrides.patrol_chance = 0
			end
		end

		SpecialsSettings.chaos.breeds = {
			"skaven_pack_master",
			"skaven_gutter_runner",
			"skaven_warpfire_thrower"
		}
	end
end
