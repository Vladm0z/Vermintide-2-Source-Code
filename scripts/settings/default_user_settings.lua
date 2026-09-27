-- chunkname: @scripts/settings/default_user_settings.lua

require("scripts/settings/render_settings_templates")
require("scripts/settings/camera_transition_templates")
require("scripts/settings/camera_settings")
require("scripts/managers/blood/blood_settings")
require("scripts/settings/sound_quality_settings")
require("scripts/managers/player/player_sync_data")
require("scripts/ui/views/crosshair_kill_confirm_settings")

local render_caps, var_0_1, var_0_2 = Application.render_caps("dlss_supported", "dlss_g_supported", "reflex_supported")
local tbl = {
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
	env_texture_quality = TextureQuality.default_environment
}
local default_local_light_shadow_quality = script_data.settings.default_local_light_shadow_quality

default_local_light_shadow_quality = default_local_light_shadow_quality or "high"
tbl.local_light_shadow_quality = default_local_light_shadow_quality

local default_particles_quality = script_data.settings.default_particles_quality

default_particles_quality = default_particles_quality or "high"
tbl.particles_quality = default_particles_quality

local default_sun_shadow_quality = script_data.settings.default_sun_shadow_quality

default_sun_shadow_quality = default_sun_shadow_quality or "high"
tbl.sun_shadow_quality = default_sun_shadow_quality

local default_use_physic_debris = script_data.settings.default_use_physic_debris

default_use_physic_debris = default_use_physic_debris or true
tbl.use_physic_debris = default_use_physic_debris

local num_decals = BloodSettings.blood_decals.num_decals

num_decals = num_decals or 100
tbl.num_blood_decals = num_decals

local default_volumetric_fog_quality = script_data.settings.default_volumetric_fog_quality

default_volumetric_fog_quality = default_volumetric_fog_quality or "lowest"
tbl.volumetric_fog_quality = default_volumetric_fog_quality

local default_ambient_light_quality = script_data.settings.default_ambient_light_quality

default_ambient_light_quality = default_ambient_light_quality or "high"
tbl.ambient_light_quality = default_ambient_light_quality

local default_ao_quality = script_data.settings.default_ao_quality

default_ao_quality = default_ao_quality or "medium"
tbl.ao_quality = default_ao_quality
tbl.playerlist_build_privacy = PrivacyLevels.friends
tbl.crosshair_kill_confirm = CrosshairKillConfirmSettingsGroups.off
tbl.sound_channel_configuration = Wwise.AK_SPEAKER_SETUP_AUTO

local tbl_2 = {
	dlss_frame_generation = not not var_0_1
}
local flag

flag = not render_caps and "auto" and "none"
tbl_2.dlss_super_resolution = flag
tbl.overriden_settings = tbl_2

local tbl_3 = {
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
	motion_blur_enabled = true
}
local flag_2

flag_2 = not IS_WINDOWS and 1 and 2
tbl_3.max_shadow_casting_lights = flag_2

local default_fov = script_data.settings.default_fov

default_fov = default_fov or CameraSettings.first_person._node.vertical_fov
tbl_3.fov = default_fov
tbl_3.nv_low_latency_mode = not not var_0_2

local tbl_4 = {
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
local tbl_5 = {}
local var_0_19 = TextureQuality.characters[tbl.char_texture_quality]
local var_0_20 = TextureQuality.environment[tbl.env_texture_quality]

for i = 1, #var_0_19 do
	local var_0_21 = var_0_19[i]

	tbl_5[var_0_21.texture_setting] = var_0_21.mip_level
end

for j = 1, #var_0_20 do
	local var_0_22 = var_0_20[j]

	tbl_5[var_0_22.texture_setting] = var_0_22.mip_level
end

local var_0_23 = SunShadowQuality[tbl.sun_shadow_quality]

for k, v in pairs(var_0_23) do
	tbl_3[k] = v
end

local var_0_24 = ParticlesQuality[tbl.particles_quality]

for k_2, v_2 in pairs(var_0_24) do
	tbl_3[k_2] = v_2
end

local var_0_25 = AmbientLightQuality[tbl.ambient_light_quality]

for k_3, v_3 in pairs(var_0_25) do
	tbl_3[k_3] = v_3
end

local var_0_26 = AmbientOcclusionQuality[tbl.ao_quality]

for k_4, v_4 in pairs(var_0_26) do
	tbl_3[k_4] = v_4
end

local var_0_27 = LocalLightShadowQuality[tbl.local_light_shadow_quality]

for k_5, v_5 in pairs(var_0_27) do
	tbl_3[k_5] = v_5
end

local var_0_28 = VolumetricFogQuality[tbl.volumetric_fog_quality]

for k_6, v_6 in pairs(var_0_28) do
	tbl_3[k_6] = v_6
end

DefaultUserSettings = {}

DefaultUserSettings.set_default_user_settings = function ()
	-- function 1
	if not LEVEL_EDITOR_TEST then
		return
	end

	local flag = false

	for k, v in pairs(tbl) do
		if Application.user_setting(k) == nil then
			Application.set_user_setting(k, v)

			flag = true
		end
	end

	local flag_2 = false

	for k_2, v_2 in pairs(tbl_3) do
		if Application.user_setting("render_settings", k_2) == nil then
			Application.set_user_setting("render_settings", k_2, v_2)

			flag = true
			flag_2 = true
		end
	end

	for k_3, v_3 in pairs(tbl_5) do
		if Application.user_setting("texture_settings", k_3) == nil then
			Application.set_user_setting("texture_settings", k_3, v_3)

			flag = true
			flag_2 = true
		end
	end

	for k_4, v_4 in pairs(tbl_4) do
		if Application.user_setting("versus_settings", k_4) == nil then
			Application.set_user_setting("versus_settings", k_4, v_4)

			flag = true
		end
	end

	if not flag_2 then
		Application.apply_user_settings()

		if not rawget(_G, "GlobalShaderFlags") then
			GlobalShaderFlags.apply_settings()
		end
	end

	if not flag then
		Application.save_user_settings()
	end
end

DefaultUserSettings.clone_default_settings = function ()
	-- function 2
	return table.clone(tbl)
end

DefaultUserSettings.get = function (arg_3_0, arg_3_1)
	-- function 3
	local var_3_0

	if arg_3_0 == "user_settings" then
		var_3_0 = tbl[arg_3_1]
	elseif arg_3_0 == "render_settings" then
		var_3_0 = tbl_3[arg_3_1]
	elseif arg_3_0 == "texture_settings" then
		var_3_0 = tbl_5[arg_3_1]
	elseif arg_3_0 == "versus_settings" then
		var_3_0 = tbl_4[arg_3_1]
	end

	fassert(var_3_0 ~= nil, "No default setting set for setting %s", arg_3_1)

	return var_3_0
end

DefaultUserSettings.setup_resolution = function ()
	-- function 4
	local user_setting = Application.user_setting
	local set_user_setting = Application.set_user_setting
	local save_user_settings = Application.save_user_settings
	local apply_user_settings = Application.apply_user_settings
	local settings = Application:settings()

	settings = settings or {}

	table.dump(settings, "Application Settings", 4)

	local var_4_5 = user_setting("user_settings")

	print("HAS USER_SETTINGS: " .. tostring(var_4_5))

	local flag = false
	local tbl = {
		Application.argv()
	}

	for k, v in pairs(tbl) do
		if v == "-safe-mode" then
			flag = true
		end
	end

	print("SAFE MODE:", flag)

	if not settings.auto_detect_video and var_4_5 and not flag then
		print("################### AUTO DETECT VIDEO ###################")

		local var_4_8 = user_setting("screen_resolution")

		table.dump(var_4_8, "resolution", 2)

		local num = 0
		local enum_display_modes = Application.enum_display_modes()

		enum_display_modes = enum_display_modes or {}

		if #enum_display_modes == 0 then
			enum_display_modes = DefaultDisplayModes

			print("Could not fetch display modes ... using default")
		end

		table.dump(enum_display_modes, "display_modes", 2)

		local flag_2 = false
		local var_4_12 = enum_display_modes[1]

		print("lowest available", var_4_12)

		for i, v_2 in ipairs(enum_display_modes) do
			if not ((v_2[1] >= var_4_12[1] or v_2[2] >= var_4_12[2]) and v_2[3] ~= num) then
				var_4_12 = v_2
			end
		end

		print("highest available", var_4_12)

		if not flag then
			print("¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤ SETTING LOWEST RESOLUTION ¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤")

			local var_4_13 = enum_display_modes[1]

			var_4_8[1] = var_4_13[1]
			var_4_8[2] = var_4_13[2]
			var_4_8[3] = var_4_13[3]

			table.dump(var_4_8, "res", 1)
			set_user_setting("borderless_fullscreen", false)
		else
			print("¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤ SETTING MAX RESOLUTION ¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤")

			var_4_8[1] = var_4_12[1]
			var_4_8[2] = var_4_12[2]
			var_4_8[3] = var_4_12[3]

			table.dump(var_4_8, "res", 1)
			set_user_setting("borderless_fullscreen", true)
		end

		local tbl_2 = {
			var_4_8[1],
			var_4_8[2],
			var_4_8[3]
		}

		set_user_setting("screen_resolution", tbl_2)
		set_user_setting("fullscreen", false)
		set_user_setting("fullscreen_output", tbl_2[3])
		set_user_setting("adapter_index", 0)
		set_user_setting("aspect_ratio", -1)
		set_user_setting("user_settings", true)
		save_user_settings()
		apply_user_settings()
		print("################### AUTO DETECT VIDEO END ###################")

		return true
	end
end
