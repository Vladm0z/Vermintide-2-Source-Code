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

local function var_0_0(arg_1_0)
	for iter_1_0, iter_1_1 in pairs(arg_1_0) do
		Development.set_parameter(iter_1_0, iter_1_1)

		script_data[iter_1_0] = iter_1_1
	end
end

local function var_0_1(arg_2_0)
	local var_2_0 = BenchmarkSettings.auto_host_level
	local var_2_1 = LevelSettings[var_2_0]

	var_2_1.display_name = arg_2_0.display_name
	var_2_1.loading_screen_wwise_events = arg_2_0.loading_screen_wwise_events
	script_data.no_loading_screen_tip_texts = true
end

local function var_0_2(arg_3_0)
	local function var_3_0(arg_4_0)
		return arg_3_0[arg_4_0]
	end

	Development.parameter = var_3_0
end

local var_0_3 = false
local var_0_4 = {
	Application.argv()
}

for iter_0_0, iter_0_1 in pairs(var_0_4) do
	if iter_0_1 == "-attract-mode" then
		LAUNCH_MODE = "attract"

		Development.set_parameter("attract_mode", true)
		var_0_0(BenchmarkSettings.parameters)
		var_0_1(BenchmarkSettings.attract_mode_settings)

		break
	end

	if iter_0_1 == "-benchmark-mode" then
		LAUNCH_MODE = "attract_benchmark"
		BenchmarkSettings.attract_benchmark = true
		BenchmarkSettings.parameters.hide_fps = false
		BenchmarkSettings.parameters.show_fps = true
		BenchmarkSettings.parameters.attract_mode = true
		BenchmarkSettings.parameters.skip_start_screen = true

		var_0_1(BenchmarkSettings.benchmark_mode_settings)
		var_0_2(BenchmarkSettings.parameters)

		break
	end

	if iter_0_1 == "-demo-mode" then
		var_0_3 = true
	end
end

function BenchmarkSettings.demo_mode_overrides()
	if var_0_3 then
		print("Entering demo mode")

		for iter_5_0, iter_5_1 in pairs(PackSpawningSettings) do
			iter_5_1.area_density_coefficient = iter_5_1.area_density_coefficient * 0.75
		end

		for iter_5_2, iter_5_3 in pairs(BreedPacks) do
			if iter_5_3.patrol_overrides then
				iter_5_3.patrol_overrides.patrol_chance = 0
			end
		end

		SpecialsSettings.chaos.breeds = {
			"skaven_pack_master",
			"skaven_gutter_runner",
			"skaven_warpfire_thrower"
		}
	end
end
