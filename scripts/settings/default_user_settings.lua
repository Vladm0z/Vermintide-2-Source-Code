-- chunkname: @scripts/settings/default_user_settings.lua

require("scripts/settings/render_settings_templates")
require("scripts/settings/camera_transition_templates")
require("scripts/settings/camera_settings")
require("scripts/managers/blood/blood_settings")
require("scripts/settings/sound_quality_settings")
require("scripts/managers/player/player_sync_data")
require("scripts/ui/views/crosshair_kill_confirm_settings")

local var_0_0, var_0_1, var_0_2 = Application.render_caps("dlss_supported", "dlss_g_supported", "reflex_supported")
local var_0_3 = {
	gamepad_left_handed = false,
	gamepad_auto_aim_enabled = true,
	play_intro_cinematic = true,
	gamepad_look_invert_y = false,
	tutorials_enabled = true,
	mouse_look_invert_y = false,
	master_bus_volume = 100,
	vsync = true,
	enable_gamepad_acceleration = true,
	root_scale_y = 1,
	always_ask_hero_when_joining = false,
	enabled_crosshairs = "all",
	max_fps = 0,
	sfx_bus_volume = 100,
	input_buffer = 0.5,
	borderless_fullscreen = false,
	dlss_enabled = false,
	hud_clamp_ui_scaling = false,
	voip_push_to_talk = true,
	overcharge_opacity = 100,
	use_subtitles = true,
	camera_shake = true,
	twitch_vote_time = 45,
	max_stacking_frames = -1,
	use_gamepad_hud_layout = "auto",
	adapter_index = 0,
	twitch_disable_positive_votes = "enable_positive_votes",
	max_quick_play_search_range = "far",
	double_tap_dodge = false,
	use_high_quality_fur = true,
	give_on_defend = true,
	use_alien_fx = false,
	gamepad_look_sensitivity_y = 0,
	gamepad_rumble_enabled = true,
	use_baked_enemy_meshes = false,
	sound_quality = "high",
	toggle_stationary_dodge = false,
	priority_input_buffer = 1,
	fullscreen = true,
	tobii_eyetracking = true,
	voice_bus_volume = 100,
	mouse_look_sensitivity = 0,
	twitch_spawn_amount = 1,
	social_wheel_gamepad_layout = "auto",
	tobii_extended_view_sensitivity = 50,
	sound_panning_rule = "speakers",
	tobii_clean_ui = true,
	tobii_extended_view_use_head_tracking = false,
	allow_occupied_hero_lobbies = true,
	write_network_debug_output_to_log = false,
	gamepad_zoom_sensitivity_y = 0,
	twitch_difficulty = 50,
	tobii_fire_at_gaze = true,
	max_upload_speed = 512,
	tobii_aim_at_gaze = true,
	deadlock_timeout = 15,
	use_custom_hud_scale = false,
	process_priority = "unchanged",
	fullscreen_minimize_on_alt_tab = true,
	weapon_scroll_type = "scroll_wrap",
	voip_is_enabled = true,
	screen_blood_enabled = true,
	profanity_check = false,
	twitch_disable_mutators = false,
	show_numerical_latency = false,
	toggle_crouch = false,
	social_wheel_delay = 0.12,
	double_tap_dodge_threshold = 0.25,
	hud_scale = 100,
	friend_join_mode = "lobby_friends",
	ragdoll_enabled = true,
	tobii_extended_view = true,
	use_razer_chroma = false,
	friendly_fire_crosshair = true,
	language_id = "en",
	toggle_pactsworn_overhead_name_ui = true,
	player_outlines = "on",
	friendly_fire_hit_marker = true,
	vs_floating_damage = "both",
	hud_damage_feedback_in_world = true,
	twitch_mutator_duration = 1,
	motion_sickness_misc_cam = "normal",
	gamepad_use_ps4_style_input_icons = false,
	hud_damage_feedback_on_yourself = false,
	use_pc_menu_layout = false,
	gamepad_layout = "default",
	chat_enabled = true,
	hud_damage_feedback_on_teammates = true,
	small_network_packets = false,
	twitch_time_between_votes = 30,
	music_bus_volume = 100,
	toggle_alternate_attack = false,
	toggle_pactsworn_help_ui = true,
	persistent_ammo_counter = false,
	mute_in_background = false,
	voip_bus_volume = 100,
	blood_enabled = true,
	toggle_versus_level_in_all_game_modes = true,
	gamepad_look_sensitivity = 0,
	subtitles_font_size = 20,
	subtitles_background_opacity = 20,
	motion_sickness_hit = "normal",
	fsr2_enabled = false,
	motion_sickness_swing = "normal",
	root_scale_x = 1,
	dismemberment_enabled = true,
	head_bob = true,
	melee_camera_movement = true,
	numeric_ui = false,
	minion_outlines = "off",
	gamepad_zoom_sensitivity = 0,
	dynamic_range_sound = "high",
	weapon_trails = "normal",
	chat_font_size = 20,
	char_texture_quality = TextureQuality.default_characters,
	env_texture_quality = TextureQuality.default_environment,
	local_light_shadow_quality = script_data.settings.default_local_light_shadow_quality or "high",
	particles_quality = script_data.settings.default_particles_quality or "high",
	sun_shadow_quality = script_data.settings.default_sun_shadow_quality or "high",
	use_physic_debris = script_data.settings.default_use_physic_debris or true,
	num_blood_decals = BloodSettings.blood_decals.num_decals or 100,
	volumetric_fog_quality = script_data.settings.default_volumetric_fog_quality or "lowest",
	ambient_light_quality = script_data.settings.default_ambient_light_quality or "high",
	ao_quality = script_data.settings.default_ao_quality or "medium",
	playerlist_build_privacy = PrivacyLevels.friends,
	crosshair_kill_confirm = CrosshairKillConfirmSettingsGroups.off,
	sound_channel_configuration = Wwise.AK_SPEAKER_SETUP_AUTO,
	overriden_settings = {
		dlss_frame_generation = not not var_0_1,
		dlss_super_resolution = var_0_0 and "auto" or "none"
	}
}
local var_0_4 = {
	lod_scatter_density = 1,
	local_probes_enabled = true,
	upscaling_mode = "none",
	fsr_quality = 4,
	sun_shadows = true,
	skin_material_enabled = false,
	eye_adaptation_speed = 1,
	fsr_enabled = false,
	lens_quality_enabled = false,
	sun_flare_enabled = false,
	lod_decoration_density = 1,
	dof_enabled = false,
	nv_framerate_cap = 0,
	taa_enabled = false,
	ssr_high_quality = false,
	light_shafts_enabled = false,
	dlss_g_enabled = false,
	fxaa_enabled = false,
	upscaling_quality = "none",
	lens_flares_enabled = false,
	ao_enabled = true,
	ao_high_quality = false,
	ssr_enabled = false,
	bloom_enabled = true,
	gamma = 2.2,
	lod_object_multiplier = 1,
	sharpen_enabled = false,
	nv_low_latency_boost = false,
	upscaling_enabled = false,
	motion_blur_enabled = true,
	max_shadow_casting_lights = IS_WINDOWS and 1 or 2,
	fov = script_data.settings.default_fov or CameraSettings.first_person._node.vertical_fov,
	nv_low_latency_mode = not not var_0_2
}
local var_0_5 = {
	tagging_enabled = true,
	early_win_enabled = true,
	custom_loadout_enabled = true,
	gutter_runner_enabled = true,
	knockdown_hp = 250,
	bile_troll_enabled = true,
	catch_up_enabled = true,
	difficulty = "normal",
	ratling_gunner_enabled = true,
	hero_hp_percent = 100,
	starting_as_heroes = "random",
	enemy_outlines = "on",
	pactsworn_respawn_timer = 25,
	warpfire_thrower_enabled = true,
	hero_bots_enabled = true,
	career_changing_enabled = false,
	special_choice_amount = 2,
	ranged_weapons = true,
	healing_item = "medium",
	horde_ability_recharge_rate_percent = 100,
	packmaster_enabled = true,
	wounds_amount = 3,
	globadier_enabled = true,
	hero_rescues_enabled = false
}
local var_0_6 = {}
local var_0_7 = TextureQuality.characters[var_0_3.char_texture_quality]
local var_0_8 = TextureQuality.environment[var_0_3.env_texture_quality]

for iter_0_0 = 1, #var_0_7 do
	local var_0_9 = var_0_7[iter_0_0]

	var_0_6[var_0_9.texture_setting] = var_0_9.mip_level
end

for iter_0_1 = 1, #var_0_8 do
	local var_0_10 = var_0_8[iter_0_1]

	var_0_6[var_0_10.texture_setting] = var_0_10.mip_level
end

local var_0_11 = SunShadowQuality[var_0_3.sun_shadow_quality]

for iter_0_2, iter_0_3 in pairs(var_0_11) do
	var_0_4[iter_0_2] = iter_0_3
end

local var_0_12 = ParticlesQuality[var_0_3.particles_quality]

for iter_0_4, iter_0_5 in pairs(var_0_12) do
	var_0_4[iter_0_4] = iter_0_5
end

local var_0_13 = AmbientLightQuality[var_0_3.ambient_light_quality]

for iter_0_6, iter_0_7 in pairs(var_0_13) do
	var_0_4[iter_0_6] = iter_0_7
end

local var_0_14 = AmbientOcclusionQuality[var_0_3.ao_quality]

for iter_0_8, iter_0_9 in pairs(var_0_14) do
	var_0_4[iter_0_8] = iter_0_9
end

local var_0_15 = LocalLightShadowQuality[var_0_3.local_light_shadow_quality]

for iter_0_10, iter_0_11 in pairs(var_0_15) do
	var_0_4[iter_0_10] = iter_0_11
end

local var_0_16 = VolumetricFogQuality[var_0_3.volumetric_fog_quality]

for iter_0_12, iter_0_13 in pairs(var_0_16) do
	var_0_4[iter_0_12] = iter_0_13
end

DefaultUserSettings = {}

DefaultUserSettings.set_default_user_settings = function ()
	if LEVEL_EDITOR_TEST then
		return
	end

	local var_1_0 = false

	for iter_1_0, iter_1_1 in pairs(var_0_3) do
		if Application.user_setting(iter_1_0) == nil then
			Application.set_user_setting(iter_1_0, iter_1_1)

			var_1_0 = true
		end
	end

	local var_1_1 = false

	for iter_1_2, iter_1_3 in pairs(var_0_4) do
		if Application.user_setting("render_settings", iter_1_2) == nil then
			Application.set_user_setting("render_settings", iter_1_2, iter_1_3)

			var_1_0 = true
			var_1_1 = true
		end
	end

	for iter_1_4, iter_1_5 in pairs(var_0_6) do
		if Application.user_setting("texture_settings", iter_1_4) == nil then
			Application.set_user_setting("texture_settings", iter_1_4, iter_1_5)

			var_1_0 = true
			var_1_1 = true
		end
	end

	for iter_1_6, iter_1_7 in pairs(var_0_5) do
		if Application.user_setting("versus_settings", iter_1_6) == nil then
			Application.set_user_setting("versus_settings", iter_1_6, iter_1_7)

			var_1_0 = true
		end
	end

	if var_1_1 then
		Application.apply_user_settings()

		if rawget(_G, "GlobalShaderFlags") then
			GlobalShaderFlags.apply_settings()
		end
	end

	if var_1_0 then
		Application.save_user_settings()
	end
end

DefaultUserSettings.clone_default_settings = function ()
	return table.clone(var_0_3)
end

DefaultUserSettings.get = function (arg_3_0, arg_3_1)
	local var_3_0

	if arg_3_0 == "user_settings" then
		var_3_0 = var_0_3[arg_3_1]
	elseif arg_3_0 == "render_settings" then
		var_3_0 = var_0_4[arg_3_1]
	elseif arg_3_0 == "texture_settings" then
		var_3_0 = var_0_6[arg_3_1]
	elseif arg_3_0 == "versus_settings" then
		var_3_0 = var_0_5[arg_3_1]
	end

	fassert(var_3_0 ~= nil, "No default setting set for setting %s", arg_3_1)

	return var_3_0
end

DefaultUserSettings.setup_resolution = function ()
	local var_4_0 = Application.user_setting
	local var_4_1 = Application.set_user_setting
	local var_4_2 = Application.save_user_settings
	local var_4_3 = Application.apply_user_settings
	local var_4_4 = Application:settings() or {}

	table.dump(var_4_4, "Application Settings", 4)

	local var_4_5 = var_4_0("user_settings")

	print("HAS USER_SETTINGS: " .. tostring(var_4_5))

	local var_4_6 = false
	local var_4_7 = {
		Application.argv()
	}

	for iter_4_0, iter_4_1 in pairs(var_4_7) do
		if iter_4_1 == "-safe-mode" then
			var_4_6 = true
		end
	end

	print("SAFE MODE:", var_4_6)

	if var_4_4.auto_detect_video and not var_4_5 or var_4_6 then
		print("################### AUTO DETECT VIDEO ###################")

		local var_4_8 = var_4_0("screen_resolution")

		table.dump(var_4_8, "resolution", 2)

		local var_4_9 = 0
		local var_4_10 = Application.enum_display_modes() or {}

		if #var_4_10 == 0 then
			var_4_10 = DefaultDisplayModes

			print("Could not fetch display modes ... using default")
		end

		table.dump(var_4_10, "display_modes", 2)

		local var_4_11 = false
		local var_4_12 = var_4_10[1]

		print("lowest available", var_4_12)

		for iter_4_2, iter_4_3 in ipairs(var_4_10) do
			if (iter_4_3[1] >= var_4_12[1] or iter_4_3[2] >= var_4_12[2]) and iter_4_3[3] == var_4_9 then
				var_4_12 = iter_4_3
			end
		end

		print("highest available", var_4_12)

		if var_4_6 then
			print("¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤ SETTING LOWEST RESOLUTION ¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤")

			local var_4_13 = var_4_10[1]

			var_4_8[1] = var_4_13[1]
			var_4_8[2] = var_4_13[2]
			var_4_8[3] = var_4_13[3]

			table.dump(var_4_8, "res", 1)
			var_4_1("borderless_fullscreen", false)
		else
			print("¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤ SETTING MAX RESOLUTION ¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤")

			var_4_8[1] = var_4_12[1]
			var_4_8[2] = var_4_12[2]
			var_4_8[3] = var_4_12[3]

			table.dump(var_4_8, "res", 1)
			var_4_1("borderless_fullscreen", true)
		end

		local var_4_14 = {
			var_4_8[1],
			var_4_8[2],
			var_4_8[3]
		}

		var_4_1("screen_resolution", var_4_14)
		var_4_1("fullscreen", false)
		var_4_1("fullscreen_output", var_4_14[3])
		var_4_1("adapter_index", 0)
		var_4_1("aspect_ratio", -1)
		var_4_1("user_settings", true)
		var_4_2()
		var_4_3()
		print("################### AUTO DETECT VIDEO END ###################")

		return true
	end
end
