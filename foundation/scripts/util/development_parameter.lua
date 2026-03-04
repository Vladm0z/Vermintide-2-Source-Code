-- chunkname: @foundation/scripts/util/development_parameter.lua

Development._hardcoded_dev_params = {
	package_debug = true,
	use_beta_overlay = true,
	disable_tutorial_at_start = false,
	network_debug = true,
	matchmaking_debug = true,
	hide_version_info = true,
	use_local_backend = false,
	spawn_empty_chest = true,
	tobii_button = false,
	disable_debug_draw = true,
	force_debug_disabled = true,
	use_telemetry = true,
	packaged_build = true,
	dont_show_unseen_rewards = false,
	text_watermark = "BETA",
	telemetry_log_interval = "600",
	qr_watermark = false,
	disable_intro_trailer = false,
	force_steam = true,
	debug_interactions = false,
	beta_level_progression = false,
	disable_water_mark = true,
	show_fps = false,
	use_tech_telemetry = true,
	hide_fps = true
}
Development._hardcoded_benchmark_mode_params = {
	attract_benchmark = true,
	use_local_backend = false,
	disable_tutorial_at_start = true,
	disable_gutter_runner = true,
	disable_pack_master = true,
	screen_space_player_camera_reactions = false,
	show_fps = true,
	hide_fps = false,
	use_lan_backend = false,
	disable_debug_draw = true,
	infinite_ammo = true,
	force_steam = true,
	tobii_button = false,
	player_invincible = true,
	attract_mode = true,
	wanted_profile = "bright_wizard"
}

local var_0_0 = Development._hardcoded_dev_params

if LAUNCH_MODE == "attract_benchmark" then
	var_0_0 = Development._hardcoded_benchmark_mode_params
end

Development.parameter = function (arg_1_0)
	return var_0_0[arg_1_0]
end

Development.clear_param_cache = function (arg_2_0)
	return
end

Development.set_parameter = function (arg_3_0, arg_3_1)
	return
end

Development.init_parameters = function ()
	for iter_4_0, iter_4_1 in pairs(var_0_0) do
		script_data[iter_4_0] = iter_4_1
	end

	new_params = {}

	for iter_4_2, iter_4_3 in pairs(var_0_0) do
		if iter_4_2:find("_") then
			new_param = iter_4_2:gsub("_", "-")
			new_params[new_param] = iter_4_3
		end
	end

	for iter_4_4, iter_4_5 in pairs(new_params) do
		var_0_0[iter_4_4] = iter_4_5
	end
end
