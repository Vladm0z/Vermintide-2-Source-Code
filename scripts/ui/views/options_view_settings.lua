-- chunkname: @scripts/ui/views/options_view_settings.lua

local tbl = {
	{
		text = "settings_view_header_display",
		widget_type = "title"
	},
	{
		setup = "cb_fullscreen_setup",
		saved_value = "cb_fullscreen_saved_value",
		callback = "cb_fullscreen",
		tooltip_text = "tooltip_screen_mode",
		widget_type = "drop_down"
	},
	{
		setup = "cb_resolutions_setup",
		name = "resolutions",
		saved_value = "cb_resolutions_saved_value",
		callback = "cb_resolutions",
		ignore_upper_case = true,
		tooltip_text = "tooltip_resolutions",
		widget_type = "drop_down"
	},
	{
		setup = "cb_minimize_on_alt_tab_setup",
		name = "minimize_on_alt_tab",
		saved_value = "cb_minimize_on_alt_tab_saved_value",
		callback = "cb_minimize_on_alt_tab",
		tooltip_text = "tooltip_minimize_on_alt_tab",
		widget_type = "stepper"
	},
	{
		setup = "cb_fov_setup",
		saved_value = "cb_fov_saved_value",
		callback = "cb_fov",
		tooltip_text = "tooltip_fov",
		widget_type = "slider"
	},
	{
		setup = "cb_vsync_setup",
		saved_value = "cb_vsync_saved_value",
		tooltip_text = "tooltip_vsync",
		callback = "cb_vsync",
		condition = "cb_vsync_condition",
		widget_type = "stepper"
	},
	{
		setup = "cb_max_stacking_frames_setup",
		saved_value = "cb_max_stacking_frames_saved_value",
		callback = "cb_max_stacking_frames",
		tooltip_text = "tooltip_max_stacking_frames",
		widget_type = "stepper"
	},
	{
		setup = "cb_gamma_setup",
		saved_value = "cb_gamma_saved_value",
		callback = "cb_gamma",
		tooltip_text = "tooltip_gamma",
		widget_type = "slider",
		slider_image = {
			slider_image = "gamma_settings_image_02",
			size = {
				420,
				50
			}
		}
	},
	{
		size_y = 30,
		widget_type = "empty"
	},
	{
		text = "settings_view_header_overall_quality",
		widget_type = "title"
	},
	{
		setup = "cb_graphics_quality_setup",
		name = "graphics_quality_settings",
		saved_value = "cb_graphics_quality_saved_value",
		callback = "cb_graphics_quality",
		tooltip_text = "tooltip_graphics_quality",
		widget_type = "stepper"
	},
	{
		size_y = 30,
		widget_type = "empty"
	},
	{
		text = "settings_view_header_textures",
		widget_type = "title"
	},
	{
		setup = "cb_char_texture_quality_setup",
		saved_value = "cb_char_texture_quality_saved_value",
		callback = "cb_char_texture_quality",
		tooltip_text = "tooltip_char_texture_quality",
		widget_type = "stepper"
	},
	{
		setup = "cb_env_texture_quality_setup",
		saved_value = "cb_env_texture_quality_saved_value",
		callback = "cb_env_texture_quality",
		tooltip_text = "tooltip_env_texture_quality",
		widget_type = "stepper"
	},
	{
		size_y = 30,
		widget_type = "empty"
	},
	{
		text = "settings_view_header_particles",
		widget_type = "title"
	},
	{
		setup = "cb_particles_quality_setup",
		saved_value = "cb_particles_quality_saved_value",
		callback = "cb_particles_quality",
		tooltip_text = "tooltip_particle_quality",
		widget_type = "stepper"
	},
	{
		setup = "cb_particles_resolution_setup",
		saved_value = "cb_particles_resolution_saved_value",
		callback = "cb_particles_resolution",
		tooltip_text = "tooltip_low_resolution_transparency",
		widget_type = "stepper"
	},
	{
		setup = "cb_scatter_density_setup",
		saved_value = "cb_scatter_density_saved_value",
		callback = "cb_scatter_density",
		tooltip_text = "tooltip_scatter_density",
		widget_type = "stepper"
	},
	{
		setup = "cb_blood_decals_setup",
		saved_value = "cb_blood_decals_saved_value",
		callback = "cb_blood_decals",
		tooltip_text = "tooltip_blood_decals",
		widget_type = "slider"
	},
	{
		size_y = 30,
		widget_type = "empty"
	},
	{
		text = "settings_view_header_lighting",
		widget_type = "title"
	},
	{
		setup = "cb_local_light_shadow_quality_setup",
		saved_value = "cb_local_light_shadow_quality_saved_value",
		callback = "cb_local_light_shadow_quality",
		tooltip_text = "tooltip_local_light_shadows",
		widget_type = "stepper"
	},
	{
		setup = "cb_sun_shadows_setup",
		saved_value = "cb_sun_shadows_saved_value",
		callback = "cb_sun_shadows",
		tooltip_text = "tooltip_sun_shadows",
		widget_type = "stepper"
	},
	{
		setup = "cb_maximum_shadow_casting_lights_setup",
		saved_value = "cb_maximum_shadow_casting_lights_saved_value",
		callback = "cb_maximum_shadow_casting_lights",
		tooltip_text = "tooltip_max_local_light_shadows",
		widget_type = "slider"
	},
	{
		setup = "cb_volumetric_fog_quality_setup",
		saved_value = "cb_volumetric_fog_quality_saved_value",
		callback = "cb_volumetric_fog_quality",
		tooltip_text = "tooltip_volumetric_fog_quality",
		widget_type = "stepper"
	},
	{
		setup = "cb_ambient_light_quality_setup",
		saved_value = "cb_ambient_light_quality_saved_value",
		callback = "cb_ambient_light_quality",
		tooltip_text = "tooltip_ambient_light_quality",
		widget_type = "stepper"
	},
	{
		setup = "cb_auto_exposure_speed_setup",
		saved_value = "cb_auto_exposure_speed_saved_value",
		callback = "cb_auto_exposure_speed",
		tooltip_text = "tooltip_auto_exposure",
		widget_type = "slider"
	},
	{
		size_y = 30,
		widget_type = "empty"
	},
	{
		text = "menu_settings_performance",
		widget_type = "title"
	},
	{
		setup = "cb_fsr_enabled_setup",
		name = "fsr_enabled_settings",
		tooltip_text = "tooltip_fsr_enabled",
		callback = "cb_fsr_enabled",
		disabled_tooltip_text = "tooltip_fsr_disabled",
		saved_value = "cb_fsr_enabled_saved_value",
		condition = "cb_fsr_enabled_condition",
		widget_type = "stepper"
	},
	{
		setup = "cb_fsr_quality_setup",
		saved_value = "cb_fsr_quality_saved_value",
		tooltip_text = "tooltip_fsr_quality",
		callback = "cb_fsr_quality",
		disabled_tooltip_text = "tooltip_fsr_disabled",
		indent_level = 1,
		condition = "cb_fsr_quality_condition",
		widget_type = "drop_down"
	},
	{
		setup = "cb_fsr2_enabled_setup",
		saved_value = "cb_fsr2_enabled_saved_value",
		tooltip_text = "tooltip_fsr2_enabled",
		callback = "cb_fsr2_enabled",
		condition = "cb_fsr2_enabled_condition",
		widget_type = "stepper"
	},
	{
		setup = "cb_fsr2_quality_setup",
		saved_value = "cb_fsr2_quality_saved_value",
		tooltip_text = "tooltip_fsr2_quality",
		callback = "cb_fsr2_quality",
		indent_level = 1,
		condition = "cb_fsr2_quality_condition",
		widget_type = "drop_down"
	},
	{
		setup = "cb_dlss_enabled_setup",
		saved_value = "cb_dlss_enabled_saved_value",
		tooltip_text = "tooltip_dlss_enabled",
		callback = "cb_dlss_enabled",
		condition = "cb_dlss_enabled_condition",
		widget_type = "stepper",
		required_render_caps = {
			dlss_supported = true
		}
	},
	{
		setup = "cb_dlss_frame_generation_setup",
		saved_value = "cb_dlss_frame_generation_saved_value",
		tooltip_text = "tooltip_dlss_frame_generation",
		callback = "cb_dlss_frame_generation",
		indent_level = 1,
		condition = "cb_dlss_frame_generation_condition",
		widget_type = "stepper",
		required_render_caps = {
			dlss_supported = true
		}
	},
	{
		setup = "cb_dlss_super_resolution_setup",
		saved_value = "cb_dlss_super_resolution_saved_value",
		tooltip_text = "tooltip_dlss_super_resolution",
		callback = "cb_dlss_super_resolution",
		indent_level = 1,
		condition = "cb_dlss_super_resolution_condition",
		widget_type = "drop_down",
		required_render_caps = {
			dlss_supported = true
		}
	},
	{
		setup = "cb_reflex_low_latency_setup",
		saved_value = "cb_reflex_low_latency_saved_value",
		tooltip_text = "tooltip_reflex_low_latency",
		callback = "cb_reflex_low_latency",
		condition = "cb_reflex_low_latency_condition",
		widget_type = "drop_down",
		required_render_caps = {
			reflex_supported = true
		}
	},
	{
		setup = "cb_reflex_framerate_cap_setup",
		saved_value = "cb_reflex_framerate_cap_saved_value",
		callback = "cb_reflex_framerate_cap",
		tooltip_text = "tooltip_reflex_framerate_cap",
		widget_type = "drop_down",
		required_render_caps = {
			reflex_supported = true
		}
	},
	{
		setup = "cb_lock_framerate_setup",
		saved_value = "cb_lock_framerate_saved_value",
		callback = "cb_lock_framerate",
		tooltip_text = "tooltip_lock_framerate",
		widget_type = "drop_down",
		required_render_caps = {
			reflex_supported = false
		}
	},
	{
		size_y = 30,
		widget_type = "empty"
	},
	{
		text = "settings_view_header_post_processing",
		widget_type = "title"
	},
	{
		setup = "cb_anti_aliasing_setup",
		saved_value = "cb_anti_aliasing_saved_value",
		tooltip_text = "tooltip_anti_aliasing",
		callback = "cb_anti_aliasing",
		condition = "cb_anti_aliasing_condition",
		widget_type = "drop_down"
	},
	{
		setup = "cb_sharpen_setup",
		saved_value = "cb_sharpen_saved_value",
		tooltip_text = "tooltip_sharpen",
		callback = "cb_sharpen",
		condition = "cb_sharpen_condition",
		widget_type = "stepper"
	},
	{
		setup = "cb_ssao_setup",
		saved_value = "cb_ssao_saved_value",
		callback = "cb_ssao",
		tooltip_text = "tooltip_ssao",
		widget_type = "stepper"
	},
	{
		setup = "cb_bloom_setup",
		saved_value = "cb_bloom_saved_value",
		callback = "cb_bloom",
		tooltip_text = "tooltip_bloom",
		widget_type = "stepper"
	},
	{
		setup = "cb_skin_shading_setup",
		saved_value = "cb_skin_shading_saved_value",
		callback = "cb_skin_shading",
		tooltip_text = "tooltip_skin_shading",
		widget_type = "stepper"
	},
	{
		setup = "cb_dof_setup",
		saved_value = "cb_dof_saved_value",
		callback = "cb_dof",
		tooltip_text = "tooltip_dof",
		widget_type = "stepper"
	},
	{
		setup = "cb_ssr_setup",
		saved_value = "cb_ssr_saved_value",
		callback = "cb_ssr",
		tooltip_text = "tooltip_ssr",
		widget_type = "stepper"
	},
	{
		setup = "cb_light_shafts_setup",
		saved_value = "cb_light_shafts_saved_value",
		callback = "cb_light_shafts",
		tooltip_text = "tooltip_light_shafts",
		widget_type = "stepper"
	},
	{
		setup = "cb_sun_flare_setup",
		saved_value = "cb_sun_flare_saved_value",
		callback = "cb_sun_flare",
		tooltip_text = "tooltip_sun_flare",
		widget_type = "stepper"
	},
	{
		setup = "cb_lens_quality_setup",
		saved_value = "cb_lens_quality_saved_value",
		callback = "cb_lens_quality",
		tooltip_text = "tooltip_lens_quality",
		widget_type = "stepper"
	},
	{
		setup = "cb_motion_blur_setup",
		saved_value = "cb_motion_blur_saved_value",
		callback = "cb_motion_blur",
		tooltip_text = "tooltip_motion_blur",
		widget_type = "stepper"
	},
	{
		size_y = 30,
		widget_type = "empty"
	},
	{
		text = "settings_view_header_other",
		widget_type = "title"
	},
	{
		setup = "cb_physic_debris_setup",
		saved_value = "cb_physic_debris_saved_value",
		callback = "cb_physic_debris",
		tooltip_text = "tooltip_physics_debris",
		widget_type = "stepper"
	},
	{
		setup = "cb_animation_lod_distance_setup",
		saved_value = "cb_animation_lod_distance_saved_value",
		callback = "cb_animation_lod_distance",
		tooltip_text = "tooltip_animation_lod_distance",
		widget_type = "slider"
	},
	{
		size_y = 30,
		widget_type = "empty"
	}
}
local get_color_table_with_alpha = Colors.get_color_table_with_alpha("black", UISettings.subtitles_background_alpha)

local function fn(self, arg_1_1, arg_1_2)
	-- function 1
	local num = 5
	local slider_image_base_size_x = self.slider_image_base_size_x

	slider_image_base_size_x = slider_image_base_size_x or arg_1_1.slider_image.size[1]
	self.slider_image_base_size_x = slider_image_base_size_x

	local slider_image_base_offset_x = self.slider_image_base_offset_x

	slider_image_base_offset_x = slider_image_base_offset_x or arg_1_1.slider_image.offset[1]
	self.slider_image_base_offset_x = slider_image_base_offset_x

	local slider_image_text_base_offset_x = self.slider_image_text_base_offset_x

	slider_image_text_base_offset_x = slider_image_text_base_offset_x or arg_1_1.slider_image_text.offset[1]
	self.slider_image_text_base_offset_x = slider_image_text_base_offset_x

	local slider_image_text = self.slider_image_text
	local get_text_width = UIUtils.get_text_width(arg_1_2.ui_renderer, arg_1_1.slider_image_text, slider_image_text)

	arg_1_1.slider_image.size[1] = get_text_width + num * 2

	local num_2 = get_text_width - self.slider_image_base_size_x + num * 2

	arg_1_1.slider_image.offset[1] = self.slider_image_base_offset_x - num_2
	arg_1_1.slider_image_text.offset[1] = self.slider_image_text_base_offset_x - num_2
end

local tbl_2 = {
	{
		text = "settings_view_header_game_sound",
		widget_type = "title"
	},
	{
		setup = "cb_master_volume_setup",
		saved_value = "cb_master_volume_saved_value",
		callback = "cb_master_volume",
		tooltip_text = "tooltip_master_volume",
		widget_type = "slider"
	},
	{
		setup = "cb_music_bus_volume_setup",
		saved_value = "cb_music_bus_volume_saved_value",
		callback = "cb_music_bus_volume",
		tooltip_text = "tooltip_music_volume",
		widget_type = "slider"
	},
	{
		setting_name = "mute_in_background",
		widget_type = "stepper",
		options = {
			{
				value = true,
				text = Localize("menu_settings_on")
			},
			{
				value = false,
				text = Localize("menu_settings_off")
			}
		}
	},
	{
		show_only_with_voip = true,
		size_y = 30,
		widget_type = "empty"
	},
	{
		text = "settings_view_header_voice_communication",
		show_only_with_voip = true,
		widget_type = "title"
	},
	{
		setup = "cb_voip_enabled_setup",
		saved_value = "cb_voip_enabled_saved_value",
		show_only_with_voip = true,
		callback = "cb_voip_enabled",
		tooltip_text = "tooltip_voip_enabled",
		widget_type = "stepper"
	},
	{
		setup = "cb_voip_push_to_talk_setup",
		saved_value = "cb_voip_push_to_talk_saved_value",
		show_only_with_voip = true,
		callback = "cb_voip_push_to_talk",
		tooltip_text = "tooltip_voip_push_to_talk",
		widget_type = "stepper"
	},
	{
		setup = "cb_voip_bus_volume_setup",
		saved_value = "cb_voip_bus_volume_saved_value",
		show_only_with_voip = true,
		callback = "cb_voip_bus_volume",
		tooltip_text = "tooltip_voip_volume",
		widget_type = "slider"
	},
	{
		size_y = 30,
		widget_type = "empty"
	},
	{
		text = "settings_view_header_other",
		widget_type = "title"
	},
	{
		setup = "cb_sound_panning_rule_setup",
		saved_value = "cb_sound_panning_rule_saved_value",
		callback = "cb_sound_panning_rule",
		tooltip_text = "tooltip_panning_rule",
		widget_type = "stepper"
	},
	{
		setup = "cb_sound_quality_setup",
		saved_value = "cb_sound_quality_saved_value",
		callback = "cb_sound_quality",
		tooltip_text = "tooltip_sound_quality",
		widget_type = "stepper"
	},
	{
		setup = "cb_dynamic_range_sound_setup",
		saved_value = "cb_dynamic_range_sound_saved_value",
		callback = "cb_dynamic_range_sound",
		tooltip_text = "tooltip_dynamic_range_sound",
		widget_type = "stepper"
	},
	{
		setting_name = "sound_channel_configuration",
		widget_type = "stepper",
		value_set_function = function (arg_2_0, arg_2_1, arg_2_2)
			-- function 2
			Wwise.set_bus_config("ingame_mastering_channel", arg_2_2)
		end,
		options = {
			{
				text = Localize("menu_settings_auto"),
				value = Wwise.AK_SPEAKER_SETUP_AUTO
			},
			{
				text = Localize("menu_settings_mono"),
				value = Wwise.AK_SPEAKER_SETUP_MONO
			},
			{
				text = Localize("menu_settings_stereo"),
				value = Wwise.AK_SPEAKER_SETUP_STEREO
			},
			{
				text = Localize("menu_settings_surround_5_1"),
				value = Wwise.AK_SPEAKER_SETUP_5POINT1
			},
			{
				text = Localize("menu_settings_surround_7_1"),
				value = Wwise.AK_SPEAKER_SETUP_7POINT1
			}
		}
	},
	{
		setup = "cb_subtitles_setup",
		saved_value = "cb_subtitles_saved_value",
		callback = "cb_subtitles",
		tooltip_text = "tooltip_subtitles",
		widget_type = "stepper"
	},
	{
		setting_name = "subtitles_background_opacity",
		widget_type = "slider",
		value_set_function = function (arg_3_0, arg_3_1, arg_3_2)
			-- function 3
			get_color_table_with_alpha[1] = 2.55 * arg_3_2
		end,
		value_saved_function = function (arg_4_0, arg_4_1, arg_4_2)
			-- function 4
			get_color_table_with_alpha[1] = 2.55 * arg_4_2
		end,
		options = {
			decimals = 0,
			min = 0,
			max = 100
		}
	},
	{
		setting_name = "subtitles_font_size",
		widget_type = "slider",
		value_set_function = function (arg_5_0, arg_5_1, arg_5_2, arg_5_3)
			-- function 5
			arg_5_1.slider_image_text.font_size = arg_5_2

			fn(arg_5_0, arg_5_1, arg_5_3)
		end,
		value_saved_function = function (arg_6_0, arg_6_1, arg_6_2, arg_6_3)
			-- function 6
			arg_6_1.slider_image.color = get_color_table_with_alpha
			arg_6_1.slider_image_text.font_size = arg_6_2

			fn(arg_6_0, arg_6_1, arg_6_3)
		end,
		slider_image = {
			slider_image = "rect_masked",
			size = {
				420,
				50
			},
			color = get_color_table_with_alpha
		},
		slider_image_text = {
			text = string.format("%s: %s", Localize("subtitle_name_witch_hunter"), Localize("pwh_activate_ability_zealot_03")),
			font_size = UISettings.subtitles_font_size,
			color = Colors.get_table("white")
		},
		options = {
			decimals = 0,
			min = 16,
			max = 32
		}
	}
}
local tbl_3 = {}

for i = 1, #tbl_2 do
	local var_0_5 = tbl_2[i]

	if not var_0_5.show_only_with_voip then
		tbl_3[#tbl_3 + 1] = var_0_5
	end
end

local tbl_4 = {
	{
		text = "settings_view_header_input",
		widget_type = "title"
	},
	{
		setup = "cb_mouse_look_sensitivity_setup",
		saved_value = "cb_mouse_look_sensitivity_saved_value",
		callback = "cb_mouse_look_sensitivity",
		tooltip_text = "tooltip_mouselook_sensitivity",
		widget_type = "slider"
	},
	{
		setup = "cb_mouse_look_invert_y_setup",
		saved_value = "cb_mouse_look_invert_y_saved_value",
		callback = "cb_mouse_look_invert_y",
		tooltip_text = "tooltip_mouselook_invert_y",
		widget_type = "stepper"
	},
	{
		setup = "cb_weapon_scroll_type_setup",
		saved_value = "cb_weapon_scroll_type_saved_value",
		callback = "cb_weapon_scroll_type",
		tooltip_text = "tooltip_weapon_scroll_type",
		widget_type = "stepper"
	},
	{
		setup = "cb_double_tap_dodge_setup",
		saved_value = "cb_double_tap_dodge_saved_value",
		callback = "cb_double_tap_dodge",
		tooltip_text = "tooltip_double_tap_dodge",
		widget_type = "stepper"
	},
	{
		setup = "cb_toggle_crouch_setup",
		saved_value = "cb_toggle_crouch_saved_value",
		callback = "cb_toggle_crouch",
		tooltip_text = "tooltip_toggle_crouch",
		widget_type = "stepper"
	},
	{
		setup = "cb_input_buffer_setup",
		saved_value = "cb_input_buffer_saved_value",
		setting_name = "input_buffer",
		callback = "cb_input_buffer",
		tooltip_text = "tooltip_input_buffer",
		widget_type = "slider"
	},
	{
		setup = "cb_priority_input_buffer_setup",
		saved_value = "cb_priority_input_buffer_saved_value",
		setting_name = "priority_input_buffer",
		callback = "cb_priority_input_buffer",
		tooltip_text = "tooltip_priority_input_buffer",
		widget_type = "slider"
	},
	{
		setting_name = "give_on_defend",
		widget_type = "stepper",
		options = {
			{
				value = true,
				text = Localize("menu_settings_on")
			},
			{
				value = false,
				text = Localize("menu_settings_off")
			}
		}
	},
	{
		setting_name = "social_wheel_delay",
		widget_type = "slider",
		options = {
			decimals = 2,
			min = 0.01,
			max = 0.5
		}
	},
	{
		setting_name = "social_wheel_gamepad_layout",
		widget_type = "stepper",
		options = {
			{
				value = "auto",
				text = Localize("menu_settings_auto")
			},
			{
				value = "always",
				text = Localize("menu_settings_always")
			},
			{
				value = "never",
				text = Localize("menu_settings_never")
			}
		}
	},
	{
		size_y = 30,
		widget_type = "empty"
	},
	{
		text = "settings_view_header_visual_effects",
		widget_type = "title"
	},
	{
		setting_name = "head_bob",
		widget_type = "stepper",
		options = {
			{
				value = true,
				text = Localize("menu_settings_on")
			},
			{
				value = false,
				text = Localize("menu_settings_off")
			}
		}
	},
	{
		setting_name = "motion_sickness_hit",
		widget_type = "drop_down",
		options = {
			{
				value = "normal",
				text = Localize("menu_settings_normal")
			},
			{
				value = "low",
				text = Localize("menu_settings_low")
			},
			{
				value = "lower",
				text = Localize("menu_settings_lower")
			},
			{
				value = "lowest",
				text = Localize("menu_settings_lowest")
			},
			{
				value = "off",
				text = Localize("menu_settings_off")
			}
		}
	},
	{
		setting_name = "motion_sickness_swing",
		widget_type = "drop_down",
		options = {
			{
				value = "normal",
				text = Localize("menu_settings_normal")
			},
			{
				value = "low",
				text = Localize("menu_settings_low")
			},
			{
				value = "lower",
				text = Localize("menu_settings_lower")
			},
			{
				value = "lowest",
				text = Localize("menu_settings_lowest")
			},
			{
				value = "off",
				text = Localize("menu_settings_off")
			}
		}
	},
	{
		setting_name = "motion_sickness_misc_cam",
		widget_type = "drop_down",
		options = {
			{
				value = "normal",
				text = Localize("menu_settings_normal")
			},
			{
				value = "no_career_camera",
				text = Localize("menu_settings_no_career")
			},
			{
				value = "no_dodge_camera",
				text = Localize("menu_settings_no_dodge")
			},
			{
				value = "no_player_hit_camera",
				text = Localize("menu_settings_no_player_hit")
			},
			{
				value = "no_misc_camera",
				text = Localize("menu_settings_no_misc")
			}
		}
	},
	{
		setting_name = "camera_shake",
		widget_type = "stepper",
		options = {
			{
				value = true,
				text = Localize("menu_settings_on")
			},
			{
				value = false,
				text = Localize("menu_settings_off")
			}
		}
	},
	{
		setting_name = "weapon_trails",
		widget_type = "stepper",
		options = {
			{
				value = "normal",
				text = Localize("menu_settings_normal")
			},
			{
				value = "no_crits",
				text = Localize("menu_settings_no_crits")
			},
			{
				value = "none",
				text = Localize("menu_settings_no_misc")
			}
		}
	},
	{
		setup = "cb_player_outlines_setup",
		saved_value = "cb_player_outlines_saved_value",
		callback = "cb_player_outlines",
		tooltip_text = "tooltip_outlines",
		widget_type = "stepper"
	},
	{
		setup = "cb_minion_outlines_setup",
		saved_value = "cb_minion_outlines_saved_value",
		callback = "cb_minion_outlines",
		tooltip_text = "tooltip_minion_outlines",
		widget_type = "stepper"
	},
	{
		setup = "cb_blood_enabled_setup",
		saved_value = "cb_blood_enabled_saved_value",
		callback = "cb_blood_enabled",
		tooltip_text = "tooltip_blood_enabled",
		widget_type = "stepper"
	},
	{
		setup = "cb_screen_blood_enabled_setup",
		saved_value = "cb_screen_blood_enabled_saved_value",
		callback = "cb_screen_blood_enabled",
		tooltip_text = "tooltip_screen_blood_enabled",
		widget_type = "stepper"
	},
	{
		setup = "cb_dismemberment_enabled_setup",
		saved_value = "cb_dismemberment_enabled_saved_value",
		callback = "cb_dismemberment_enabled",
		tooltip_text = "tooltip_dismemberment_enabled",
		widget_type = "stepper"
	},
	{
		setup = "cb_ragdoll_enabled_setup",
		saved_value = "cb_ragdoll_enabled_saved_value",
		callback = "cb_ragdoll_enabled",
		tooltip_text = "tooltip_ragdoll_enabled",
		widget_type = "stepper"
	},
	{
		size_y = 30,
		widget_type = "empty"
	},
	{
		text = "settings_view_header_interface",
		widget_type = "title"
	},
	{
		setup = "cb_enabled_pc_menu_layout_setup",
		saved_value = "cb_enabled_pc_menu_layout_saved_value",
		callback = "cb_enabled_pc_menu_layout",
		tooltip_text = "tooltip_enabled_pc_menu_layout",
		widget_type = "stepper"
	},
	{
		setting_name = "play_intro_cinematic",
		widget_type = "stepper",
		options = {
			{
				value = true,
				text = Localize("menu_settings_on")
			},
			{
				value = false,
				text = Localize("menu_settings_off")
			}
		}
	},
	{
		setup = "cb_chat_enabled_setup",
		saved_value = "cb_chat_enabled_saved_value",
		callback = "cb_chat_enabled",
		tooltip_text = "tooltip_chat_enabled",
		widget_type = "stepper"
	},
	{
		setup = "cb_chat_font_size_setup",
		saved_value = "cb_chat_font_size_saved_value",
		callback = "cb_chat_font_size",
		tooltip_text = "tooltip_chat_font_size",
		widget_type = "drop_down"
	},
	{
		setup = "cb_clan_tag_setup",
		saved_value = "cb_clan_tag_saved_value",
		callback = "cb_clan_tag",
		tooltip_text = "tooltip_clan_tag",
		widget_type = "stepper"
	},
	{
		setting_name = "playerlist_build_privacy",
		widget_type = "stepper",
		options = {
			{
				text = Localize("visibility_friends"),
				value = PrivacyLevels.friends
			},
			{
				text = Localize("visibility_private"),
				value = PrivacyLevels.private
			},
			{
				text = Localize("visibility_public"),
				value = PrivacyLevels.public
			}
		}
	},
	{
		size_y = 30,
		widget_type = "empty"
	},
	{
		text = "settings_view_header_hud_customization",
		widget_type = "title"
	},
	{
		setup = "cb_enabled_gamepad_hud_layout_setup",
		saved_value = "cb_enabled_gamepad_hud_layout_saved_value",
		callback = "cb_enabled_gamepad_hud_layout",
		tooltip_text = "tooltip_enabled_gamepad_hud_layout",
		widget_type = "stepper"
	},
	{
		setup = "cb_hud_custom_scale_setup",
		saved_value = "cb_hud_custom_scale_saved_value",
		callback = "cb_hud_custom_scale",
		tooltip_text = "tooltip_hud_custom_scale",
		widget_type = "stepper"
	},
	{
		setup = "cb_hud_scale_setup",
		callback_on_release = true,
		saved_value = "cb_hud_scale_saved_value",
		callback = "cb_hud_scale",
		name = "hud_scale",
		tooltip_text = "tooltip_hud_scale",
		widget_type = "slider"
	},
	{
		setup = "cb_hud_clamp_ui_scaling_setup",
		saved_value = "cb_hud_clamp_ui_scaling_saved_value",
		callback = "cb_hud_clamp_ui_scaling",
		tooltip_text = "tooltip_hud_clamp_ui_scaling",
		widget_type = "stepper"
	},
	{
		setup = "cb_enabled_crosshairs_setup",
		saved_value = "cb_enabled_crosshairs_saved_value",
		callback = "cb_enabled_crosshairs",
		tooltip_text = "tooltip_enabled_crosshairs",
		widget_type = "stepper"
	},
	{
		setup = "cb_overcharge_opacity_setup",
		saved_value = "cb_overcharge_opacity_saved_value",
		callback = "cb_overcharge_opacity",
		tooltip_text = "tooltip_overcharge_opacity",
		widget_type = "slider"
	},
	{
		setting_name = "numeric_ui",
		widget_type = "stepper",
		options = {
			{
				value = true,
				text = Localize("menu_settings_on")
			},
			{
				value = false,
				text = Localize("menu_settings_off")
			}
		}
	},
	{
		setting_name = "persistent_ammo_counter",
		widget_type = "stepper",
		options = {
			{
				value = true,
				text = Localize("menu_settings_on")
			},
			{
				value = false,
				text = Localize("menu_settings_off")
			}
		}
	},
	{
		setting_name = "crosshair_kill_confirm",
		widget_type = "drop_down",
		options = {
			{
				text = Localize("menu_settings_off"),
				value = CrosshairKillConfirmSettingsGroups.off
			},
			{
				text = Localize("crosshair_kill_confirm_all"),
				value = CrosshairKillConfirmSettingsGroups.all
			},
			{
				text = Localize("crosshair_kill_confirm_elites_above"),
				value = CrosshairKillConfirmSettingsGroups.elites_above
			},
			{
				text = Localize("crosshair_kill_confirm_bosses_specials"),
				value = CrosshairKillConfirmSettingsGroups.bosses_specials
			},
			{
				text = Localize("crosshair_kill_confirm_elites_specials"),
				value = CrosshairKillConfirmSettingsGroups.elites_specials
			},
			{
				text = Localize("crosshair_kill_confirm_specials_only"),
				value = CrosshairKillConfirmSettingsGroups.specials_only
			}
		}
	},
	{
		setting_name = "friendly_fire_crosshair",
		widget_type = "stepper",
		options = {
			{
				value = true,
				text = Localize("menu_settings_on")
			},
			{
				value = false,
				text = Localize("menu_settings_off")
			}
		}
	},
	{
		setting_name = "friendly_fire_hit_marker",
		widget_type = "stepper",
		options = {
			{
				value = true,
				text = Localize("menu_settings_on")
			},
			{
				value = false,
				text = Localize("menu_settings_off")
			}
		}
	},
	{
		size_y = 30,
		widget_type = "empty"
	},
	{
		text = "settings_view_header_twitch",
		widget_type = "title"
	},
	{
		setup = "cb_twitch_vote_time_setup",
		saved_value = "cb_twitch_vote_time_saved_value",
		callback = "cb_twitch_vote_time",
		tooltip_text = "tooltip_twitch_vote_time",
		widget_type = "drop_down"
	},
	{
		setup = "cb_twitch_time_between_votes_setup",
		saved_value = "cb_twitch_time_between_votes_saved_value",
		callback = "cb_twitch_time_between_votes",
		tooltip_text = "tooltip_twitch_time_between_votes",
		widget_type = "drop_down"
	},
	{
		setup = "cb_twitch_spawn_amount_setup",
		callback_on_release = true,
		saved_value = "cb_twitch_spawn_amount_saved_value",
		callback = "cb_twitch_spawn_amount",
		tooltip_text = "tooltip_twitch_spawn_amount",
		widget_type = "slider"
	},
	{
		setting_name = "twitch_disable_positive_votes",
		widget_type = "stepper",
		options = {
			{
				text = Localize("twitch_enable_positive_votes"),
				value = TwitchSettings.positive_vote_options.enable_positive_votes
			},
			{
				text = Localize("twitch_disable_giving_items"),
				value = TwitchSettings.positive_vote_options.disable_giving_items
			},
			{
				text = Localize("twitch_disable_positive_votes"),
				value = TwitchSettings.positive_vote_options.disable_positive_votes
			}
		}
	},
	{
		menu_setting_name = "menu_settings_twitch_enable_mutators",
		setting_name = "twitch_disable_mutators",
		tooltip_text = "tooltip_twitch_enable_mutators",
		widget_type = "stepper",
		options = {
			{
				value = true,
				text = Localize("menu_settings_on")
			},
			{
				value = false,
				text = Localize("menu_settings_off")
			}
		},
		options = {
			{
				value = false,
				text = Localize("menu_settings_on")
			},
			{
				value = true,
				text = Localize("menu_settings_off")
			}
		}
	},
	{
		setting_name = "twitch_mutator_duration",
		widget_type = "stepper",
		options = {
			{
				value = 1,
				text = Localize("percent_100")
			},
			{
				value = 1.5,
				text = Localize("percent_150")
			},
			{
				value = 2,
				text = Localize("percent_200")
			}
		}
	},
	{
		size_y = 30,
		widget_type = "empty"
	}
}

local function fn_2(arg_7_0, arg_7_1, arg_7_2)
	-- function 7
	local num = arg_7_1 - arg_7_0

	return (math.clamp(arg_7_2, arg_7_0, arg_7_1) - arg_7_0) / num
end

local function fn_3(self, arg_8_1, arg_8_2, arg_8_3, arg_8_4, arg_8_5)
	-- function 8
	local var_8_0

	if arg_8_2 == "slider" then
		var_8_0 = arg_8_3.value
	else
		var_8_0 = arg_8_3.options_values[arg_8_3.current_selection]
	end

	local setting_type = arg_8_3.definition.setting_type

	setting_type = setting_type or "user_settings"

	self:_set_setting(setting_type, arg_8_1, var_8_0)
	arg_8_5(arg_8_3, arg_8_4, var_8_0, self)
end

local function fn_4(arg_9_0, arg_9_1, arg_9_2, arg_9_3, arg_9_4)
	-- function 9
	local setting_type = arg_9_4.setting_type

	setting_type = setting_type or "user_settings"

	local get = DefaultUserSettings.get(setting_type, arg_9_1)
	local var_9_2

	if setting_type == "user_settings" then
		var_9_2 = Application.user_setting(arg_9_1)
	else
		var_9_2 = Application.user_setting(setting_type, arg_9_1)
	end

	local menu_setting_name = arg_9_4.menu_setting_name

	menu_setting_name = menu_setting_name or "menu_settings_" .. arg_9_1

	if arg_9_2 == "slider" then
		local min = arg_9_3.min
		local max = arg_9_3.max
		local decimals = arg_9_3.decimals

		return fn_2(min, max, var_9_2), min, max, decimals, menu_setting_name, get
	else
		local var_9_7
		local var_9_8

		for i, v in ipairs(arg_9_3) do
			local value = v.value

			if value == var_9_2 then
				var_9_7 = i
			end

			if value == get then
				var_9_8 = i
			end
		end

		fassert(var_9_8, "Default value %q for %q does not exist in passed options table", tostring(get), arg_9_1)

		var_9_7 = var_9_7 or var_9_8

		return var_9_7, arg_9_3, menu_setting_name, var_9_8
	end
end

local function fn_5(self, arg_10_1, arg_10_2, arg_10_3, arg_10_4)
	-- function 10
	local setting_type = arg_10_3.content.definition.setting_type

	setting_type = setting_type or "user_settings"

	local _get_setting = self:_get_setting(setting_type, arg_10_1)
	local get = DefaultUserSettings.get(setting_type, arg_10_1)

	if _get_setting == nil then
		_get_setting = get
	end

	local content = arg_10_3.content
	local style = arg_10_3.style

	if arg_10_2 == "slider" then
		local min = content.min
		local max = content.max

		_get_setting = math.clamp(_get_setting, min, max)
		content.internal_value = fn_2(min, max, _get_setting)
		content.value = _get_setting
	else
		local find = table.find(content.options_values, _get_setting)

		find = find or table.find(content.options_values, get)
		content.current_selection = find
	end

	arg_10_4(content, style, _get_setting, self)
end

local function fn_6(arg_11_0)
	-- function 11
	for k, v in pairs(arg_11_0) do
		local setting_name = v.setting_name

		if not setting_name then
			local str = "cb_" .. setting_name
			local var_11_2 = str

			v.callback = str

			local widget_type = v.widget_type

			OptionsView[var_11_2] = function (arg_12_0, arg_12_1, arg_12_2)
				-- function 12
				local var_12_0 = fn_3
				local var_12_1 = arg_12_0
				local var_12_2 = setting_name
				local var_12_3 = widget_type
				local var_12_4 = arg_12_1
				local var_12_5 = arg_12_2
				local value_set_function = v.value_set_function

				value_set_function = value_set_function or NOP

				return var_12_0(var_12_1, var_12_2, var_12_3, var_12_4, var_12_5, value_set_function)
			end

			local str_2 = str .. "_setup"

			v.setup = str_2
			OptionsView[str_2] = function (arg_13_0)
				-- function 13
				return fn_4(arg_13_0, setting_name, widget_type, v.options, v)
			end

			local str_3 = str .. "_saved_value"

			v.saved_value = str_3
			OptionsView[str_3] = function (arg_14_0, arg_14_1)
				-- function 14
				local var_14_0 = fn_5
				local var_14_1 = arg_14_0
				local var_14_2 = setting_name
				local var_14_3 = widget_type
				local var_14_4 = arg_14_1
				local value_saved_function = v.value_saved_function

				value_saved_function = value_saved_function or NOP

				return var_14_0(var_14_1, var_14_2, var_14_3, var_14_4, value_saved_function)
			end

			if not v.tooltip_text then
				v.tooltip_text = "tooltip_" .. setting_name
			end
		end
	end
end

fn_6(tbl_2)
fn_6(tbl_4)
fn_6(tbl)

local var_0_12 = rawget(_G, "LightFX")
local var_0_13 = rawget(_G, "RazerChroma")

if var_0_12 or not RazerChroma then
	tbl_4[#tbl_4 + 1] = {
		size_y = 30,
		widget_type = "empty"
	}
	tbl_4[#tbl_4 + 1] = {
		text = "settings_view_header_misc",
		widget_type = "title"
	}
end

if not var_0_12 then
	tbl_4[#tbl_4 + 1] = {
		setup = "cb_alien_fx_setup",
		saved_value = "cb_alien_fx_saved_value",
		callback = "cb_alien_fx",
		tooltip_text = "tooltip_alien_fx",
		widget_type = "stepper"
	}
end

if not RazerChroma then
	tbl_4[#tbl_4 + 1] = {
		setup = "cb_razer_chroma_setup",
		saved_value = "cb_razer_chroma_saved_value",
		callback = "cb_razer_chroma",
		tooltip_text = "tooltip_razer_chroma",
		widget_type = "stepper"
	}
end

tbl_4[#tbl_4 + 1] = {
	size_y = 110,
	widget_type = "empty"
}

local tbl_5 = {
	{
		size_y = 30,
		widget_type = "empty"
	},
	{
		text = "Monitor",
		widget_type = "title"
	}
}
local tbl_6 = {
	{
		text = "settings_view_header_movement",
		widget_type = "title"
	},
	{
		keybind_description = "move_forward",
		keymappings_key = "PlayerControllerKeymaps",
		widget_type = "keybind",
		actions = {
			"move_forward",
			"move_forward_pressed"
		}
	},
	{
		keybind_description = "move_left",
		keymappings_key = "PlayerControllerKeymaps",
		widget_type = "keybind",
		actions = {
			"move_left",
			"move_left_pressed"
		}
	},
	{
		keybind_description = "move_back",
		keymappings_key = "PlayerControllerKeymaps",
		widget_type = "keybind",
		actions = {
			"move_back",
			"move_back_pressed"
		}
	},
	{
		keybind_description = "move_right",
		keymappings_key = "PlayerControllerKeymaps",
		widget_type = "keybind",
		actions = {
			"move_right",
			"move_right_pressed"
		}
	},
	{
		keybind_description = "jump_1",
		keymappings_key = "PlayerControllerKeymaps",
		widget_type = "keybind",
		actions = {
			"jump_1",
			"dodge_hold"
		}
	},
	{
		keybind_description = "jump_only",
		keymappings_key = "PlayerControllerKeymaps",
		widget_type = "keybind",
		actions = {
			"jump_only"
		}
	},
	{
		keybind_description = "dodge",
		keymappings_key = "PlayerControllerKeymaps",
		widget_type = "keybind",
		actions = {
			"dodge"
		}
	},
	{
		keybind_description = "crouch",
		keymappings_key = "PlayerControllerKeymaps",
		widget_type = "keybind",
		actions = {
			"crouch",
			"crouching"
		}
	},
	{
		keybind_description = "walk",
		keymappings_key = "PlayerControllerKeymaps",
		widget_type = "keybind",
		actions = {
			"walk"
		}
	},
	{
		size_y = 30,
		widget_type = "empty"
	},
	{
		text = "settings_view_header_combat",
		widget_type = "title"
	},
	{
		keybind_description = "action_one",
		keymappings_key = "PlayerControllerKeymaps",
		widget_type = "keybind",
		actions = {
			"action_one",
			"action_one_hold",
			"action_one_release",
			"action_one_mouse"
		}
	},
	{
		keybind_description = "action_two",
		keymappings_key = "PlayerControllerKeymaps",
		widget_type = "keybind",
		actions = {
			"action_two",
			"action_two_hold",
			"action_two_release"
		}
	},
	{
		keybind_description = "weapon_reload",
		keymappings_key = "PlayerControllerKeymaps",
		widget_type = "keybind",
		actions = {
			"weapon_reload",
			"weapon_reload_hold"
		}
	},
	{
		keybind_description = "action_three",
		keymappings_key = "PlayerControllerKeymaps",
		widget_type = "keybind",
		actions = {
			"action_three",
			"action_three_hold",
			"action_three_release"
		}
	},
	{
		keybind_description = "input_active_ability",
		keymappings_key = "PlayerControllerKeymaps",
		widget_type = "keybind",
		actions = {
			"action_career",
			"action_career_hold",
			"action_career_release"
		}
	},
	{
		keybind_description = "ping",
		keymappings_key = "PlayerControllerKeymaps",
		widget_type = "keybind",
		actions = {
			"ping",
			"ping_hold",
			"ping_release"
		}
	},
	{
		keybind_description = "ping_only",
		keymappings_key = "PlayerControllerKeymaps",
		widget_type = "keybind",
		actions = {
			"ping_only"
		}
	},
	{
		keybind_description = "social_wheel_only",
		keymappings_key = "PlayerControllerKeymaps",
		widget_type = "keybind",
		actions = {
			"social_wheel_only",
			"social_wheel_only_hold",
			"social_wheel_only_release"
		}
	},
	{
		keybind_description = "weapon_poses_only",
		keymappings_key = "PlayerControllerKeymaps",
		widget_type = "keybind",
		actions = {
			"weapon_poses_only",
			"weapon_poses_only_hold",
			"weapon_poses_only_release"
		}
	},
	{
		keybind_description = "social_wheel_page",
		keymappings_key = "PlayerControllerKeymaps",
		widget_type = "keybind",
		actions = {
			"social_wheel_page"
		}
	},
	{
		keybind_description = "photomode_only",
		keymappings_key = "PlayerControllerKeymaps",
		widget_type = "keybind",
		actions = {
			"photomode_only",
			"photomode_only_hold",
			"photomode_only_release"
		}
	},
	{
		keybind_description = "interact",
		keymappings_key = "PlayerControllerKeymaps",
		widget_type = "keybind",
		actions = {
			"interact",
			"interacting"
		}
	},
	{
		keybind_description = "wield_1",
		keymappings_key = "PlayerControllerKeymaps",
		widget_type = "keybind",
		actions = {
			"wield_1"
		}
	},
	{
		keybind_description = "wield_2",
		keymappings_key = "PlayerControllerKeymaps",
		widget_type = "keybind",
		actions = {
			"wield_2"
		}
	},
	{
		keybind_description = "wield_3",
		keymappings_key = "PlayerControllerKeymaps",
		widget_type = "keybind",
		actions = {
			"wield_3"
		}
	},
	{
		keybind_description = "wield_4",
		keymappings_key = "PlayerControllerKeymaps",
		widget_type = "keybind",
		actions = {
			"wield_4"
		}
	},
	{
		keybind_description = "wield_4_alt",
		required_dlc = "shovel",
		keymappings_key = "PlayerControllerKeymaps",
		widget_type = "keybind",
		actions = {
			"wield_4_alt"
		}
	},
	{
		keybind_description = "wield_5",
		keymappings_key = "PlayerControllerKeymaps",
		widget_type = "keybind",
		actions = {
			"wield_5"
		}
	},
	{
		keybind_description = "wield_switch_1",
		keymappings_key = "PlayerControllerKeymaps",
		widget_type = "keybind",
		actions = {
			"wield_switch",
			"wield_switch_1"
		}
	},
	{
		keybind_description = "wield_next",
		keymappings_key = "PlayerControllerKeymaps",
		widget_type = "keybind",
		actions = {
			"wield_next"
		}
	},
	{
		keybind_description = "wield_prev",
		keymappings_key = "PlayerControllerKeymaps",
		widget_type = "keybind",
		actions = {
			"wield_prev"
		}
	},
	{
		keybind_description = "character_inspecting",
		keymappings_key = "PlayerControllerKeymaps",
		widget_type = "keybind",
		actions = {
			"character_inspecting"
		}
	},
	{
		keybind_description = "action_inspect",
		keymappings_key = "PlayerControllerKeymaps",
		widget_type = "keybind",
		actions = {
			"action_inspect",
			"action_inspect_hold",
			"action_inspect_release"
		}
	},
	{
		size_y = 30,
		widget_type = "empty"
	},
	{
		text = "settings_view_header_menu_hotkeys",
		widget_type = "title"
	},
	{
		keybind_description = "ingame_player_list_pressed",
		keymappings_key = "IngamePlayerListKeymaps",
		widget_type = "keybind",
		actions = {
			"ingame_player_list_pressed",
			"ingame_player_list_held",
			"ingame_player_list_exit_1"
		}
	},
	{
		keybind_description = "hotkey_map",
		keymappings_key = "IngameMenuKeymaps",
		widget_type = "keybind",
		actions = {
			"hotkey_map"
		}
	},
	{
		keybind_description = "hotkey_inventory",
		keymappings_key = "IngameMenuKeymaps",
		widget_type = "keybind",
		actions = {
			"hotkey_inventory"
		}
	},
	{
		keybind_description = "hotkey_loot",
		keymappings_key = "IngameMenuKeymaps",
		widget_type = "keybind",
		actions = {
			"hotkey_loot"
		}
	},
	{
		keybind_description = "hotkey_hero",
		keymappings_key = "IngameMenuKeymaps",
		widget_type = "keybind",
		actions = {
			"hotkey_hero"
		}
	},
	{
		keybind_description = "hotkey_store",
		keymappings_key = "IngameMenuKeymaps",
		widget_type = "keybind",
		actions = {
			"hotkey_store"
		}
	},
	{
		keybind_description = "hotkey_achievements",
		keymappings_key = "IngameMenuKeymaps",
		widget_type = "keybind",
		actions = {
			"hotkey_achievements"
		}
	},
	{
		keybind_description = "hotkey_weave_forge",
		keymappings_key = "IngameMenuKeymaps",
		widget_type = "keybind",
		actions = {
			"hotkey_weave_forge"
		}
	},
	{
		keybind_description = "hotkey_weave_play",
		keymappings_key = "IngameMenuKeymaps",
		widget_type = "keybind",
		actions = {
			"hotkey_weave_play"
		}
	},
	{
		keybind_description = "hotkey_weave_leaderboard",
		keymappings_key = "IngameMenuKeymaps",
		widget_type = "keybind",
		actions = {
			"hotkey_weave_leaderboard"
		}
	},
	{
		keybind_description = "hotkey_deus_inventory",
		keymappings_key = "IngameMenuKeymaps",
		widget_type = "keybind",
		actions = {
			"hotkey_deus_inventory"
		}
	},
	{
		size_y = 30,
		widget_type = "empty"
	},
	{
		text = "settings_view_header_multiplayer",
		widget_type = "title"
	},
	{
		keybind_description = "voip_push_to_talk",
		keymappings_key = "ChatControllerSettings",
		widget_type = "keybind",
		actions = {
			"voip_push_to_talk"
		}
	},
	{
		keybind_description = "activate_chat_input",
		keymappings_key = "ChatControllerSettings",
		widget_type = "keybind",
		actions = {
			"activate_chat_input"
		}
	},
	{
		keybind_description = "execute_chat_input_1",
		keymappings_key = "ChatControllerSettings",
		widget_type = "keybind",
		actions = {
			"execute_chat_input_1"
		}
	},
	{
		keybind_description = "ingame_vote_yes",
		keymappings_key = "IngameMenuKeymaps",
		widget_type = "keybind",
		actions = {
			"ingame_vote_yes"
		}
	},
	{
		keybind_description = "ingame_vote_no",
		keymappings_key = "IngameMenuKeymaps",
		widget_type = "keybind",
		actions = {
			"ingame_vote_no"
		}
	},
	{
		size_y = 30,
		widget_type = "empty"
	},
	{
		text = "settings_view_versus",
		widget_type = "title"
	},
	{
		keybind_description = "action_dark_pact_action_one",
		keymappings_key = "PlayerControllerKeymaps",
		widget_type = "keybind",
		actions = {
			"dark_pact_action_one",
			"dark_pact_action_one_hold",
			"dark_pact_action_one_release"
		}
	},
	{
		keybind_description = "action_dark_pact_action_two",
		keymappings_key = "PlayerControllerKeymaps",
		widget_type = "keybind",
		actions = {
			"dark_pact_action_two",
			"dark_pact_action_two_hold",
			"dark_pact_action_two_release"
		}
	},
	{
		keybind_description = "action_dark_pact_reload",
		keymappings_key = "PlayerControllerKeymaps",
		widget_type = "keybind",
		actions = {
			"dark_pact_reload",
			"dark_pact_reload_hold"
		}
	},
	{
		keybind_description = "action_versus_horde_ability",
		keymappings_key = "PlayerControllerKeymaps",
		widget_type = "keybind",
		actions = {
			"versus_horde_ability"
		}
	},
	{
		keybind_description = "action_dark_pact_interact",
		keymappings_key = "PlayerControllerKeymaps",
		widget_type = "keybind",
		actions = {
			"dark_pact_interact"
		}
	},
	{
		keybind_description = "action_dark_pact_climb_point",
		keymappings_key = "PlayerControllerKeymaps",
		widget_type = "keybind",
		actions = {
			"dark_pact_climb_point"
		}
	},
	{
		keybind_description = "action_ghost_mode_exit",
		keymappings_key = "PlayerControllerKeymaps",
		widget_type = "keybind",
		actions = {
			"ghost_mode_exit"
		}
	},
	{
		keybind_description = "vs_ghost_catch_up",
		keymappings_key = "PlayerControllerKeymaps",
		widget_type = "keybind",
		actions = {
			"ghost_mode_enter"
		}
	},
	{
		keybind_description = "ping_only_movement",
		keymappings_key = "PlayerControllerKeymaps",
		widget_type = "keybind",
		actions = {
			"ping_only_movement"
		}
	},
	{
		size_y = 30,
		widget_type = "empty"
	}
}

for i_2, v in ipairs(tbl_6) do
	if not v.keymappings_table_key then
		v.keymappings_table_key = "win32"
	end
end

local tbl_7 = {
	gamepad_right_axis = true,
	analog_input = true,
	look_raw = true,
	gamepad_left_axis = true,
	wield_scroll = true,
	move_controller = true,
	look_raw_controller = true,
	scroll_axis = true,
	cursor = true
}
local tbl_8 = {
	{
		size_y = 30,
		widget_type = "empty"
	},
	{
		bg_image2 = "controller_image_ps4",
		bg_image = "controller_image_xb1",
		widget_type = "gamepad_layout",
		bg_image_size = {
			1260,
			400
		},
		bg_image_size2 = {
			1260,
			440
		}
	},
	{
		setup = "cb_gamepad_layout_setup",
		name = "gamepad_layout",
		saved_value = "cb_gamepad_layout_saved_value",
		callback = "cb_gamepad_layout",
		tooltip_text = "tooltip_gamepad_layout",
		widget_type = "stepper"
	},
	{
		setup = "cb_gamepad_left_handed_enabled_setup",
		saved_value = "cb_gamepad_left_handed_enabled_saved_value",
		callback = "cb_gamepad_left_handed_enabled",
		tooltip_text = "tooltip_gamepad_left_handed_enabled",
		widget_type = "stepper"
	},
	{
		setup = "cb_gamepad_look_invert_y_setup",
		saved_value = "cb_gamepad_look_invert_y_saved_value",
		callback = "cb_gamepad_look_invert_y",
		tooltip_text = "tooltip_gamepad_invert_y",
		widget_type = "stepper"
	},
	{
		size_y = 30,
		widget_type = "empty"
	},
	{
		setup = "cb_gamepad_look_sensitivity_setup",
		saved_value = "cb_gamepad_look_sensitivity_saved_value",
		callback = "cb_gamepad_look_sensitivity",
		tooltip_text = "tooltip_gamepad_look_sensitivity",
		widget_type = "slider"
	},
	{
		size_y = 10,
		widget_type = "empty"
	},
	{
		setup = "cb_gamepad_look_sensitivity_y_setup",
		saved_value = "cb_gamepad_look_sensitivity_y_saved_value",
		callback = "cb_gamepad_look_sensitivity_y",
		tooltip_text = "tooltip_gamepad_look_sensitivity",
		widget_type = "slider"
	},
	{
		size_y = 30,
		widget_type = "empty"
	},
	{
		setup = "cb_gamepad_zoom_sensitivity_setup",
		saved_value = "cb_gamepad_zoom_sensitivity_saved_value",
		callback = "cb_gamepad_zoom_sensitivity",
		tooltip_text = "tooltip_gamepad_zoom_sensitivity",
		widget_type = "slider"
	},
	{
		size_y = 10,
		widget_type = "empty"
	},
	{
		setup = "cb_gamepad_zoom_sensitivity_y_setup",
		saved_value = "cb_gamepad_zoom_sensitivity_y_saved_value",
		callback = "cb_gamepad_zoom_sensitivity_y",
		tooltip_text = "tooltip_gamepad_zoom_sensitivity",
		widget_type = "slider"
	},
	{
		size_y = 30,
		widget_type = "empty"
	},
	{
		setup = "cb_gamepad_auto_aim_enabled_setup",
		saved_value = "cb_gamepad_auto_aim_enabled_saved_value",
		callback = "cb_gamepad_auto_aim_enabled",
		tooltip_text = "tooltip_gamepad_auto_aim_enabled",
		widget_type = "stepper"
	},
	{
		setup = "cb_gamepad_acceleration_enabled_setup",
		saved_value = "cb_gamepad_acceleration_enabled_saved_value",
		callback = "cb_gamepad_acceleration_enabled",
		tooltip_text = "tooltip_gamepad_acceleration_enabled",
		widget_type = "stepper"
	},
	{
		setup = "cb_gamepad_rumble_enabled_setup",
		saved_value = "cb_gamepad_rumble_enabled_saved_value",
		callback = "cb_gamepad_rumble_enabled",
		tooltip_text = "tooltip_gamepad_rumble_enabled_pc",
		widget_type = "stepper"
	},
	{
		setup = "cb_gamepad_use_ps4_style_input_icons_setup",
		saved_value = "cb_gamepad_use_ps4_style_input_icons_saved_value",
		callback = "cb_gamepad_use_ps4_style_input_icons",
		tooltip_text = "tooltip_gamepad_use_ps4_style_input_icons",
		widget_type = "stepper"
	}
}
local var_0_18

if not rawget(_G, "Tobii") then
	var_0_18 = {}

	local function fn_7(arg_15_0, arg_15_1)
		-- function 15
		var_0_18[#var_0_18 + 1] = {
			widget_type = "stepper",
			callback = "cb_" .. arg_15_0,
			setup = "cb_" .. arg_15_0 .. "_setup",
			saved_value = "cb_" .. arg_15_0 .. "_saved_value",
			tooltip_text = arg_15_1
		}
	end

	local function fn_8(arg_16_0, arg_16_1)
		-- function 16
		var_0_18[#var_0_18 + 1] = {
			widget_type = "slider",
			callback = "cb_" .. arg_16_0,
			setup = "cb_" .. arg_16_0 .. "_setup",
			saved_value = "cb_" .. arg_16_0 .. "_saved_value",
			tooltip_text = arg_16_1
		}
	end

	var_0_18[#var_0_18 + 1] = {
		text = "settings_view_header_eyetracker",
		widget_type = "title"
	}

	fn_7("tobii_eyetracking", "tooltip_tobii_eyetracking")
	fn_7("tobii_extended_view", "tooltip_tobii_extended_view")
	fn_8("tobii_extended_view_sensitivity", "tooltip_tobii_extended_view_sensitivity")
	fn_7("tobii_extended_view_use_head_tracking", "tooltip_tobii_extended_view_use_head_tracking")
	fn_7("tobii_aim_at_gaze", "tooltip_tobii_aim_at_gaze")
	fn_7("tobii_fire_at_gaze", "tooltip_tobii_fire_at_gaze")
	fn_7("tobii_clean_ui", "tooltip_tobii_clean_ui")
end

local tbl_9 = {
	{
		text = "settings_view_matchmaking_display",
		widget_type = "title"
	},
	{
		setting_name = "allow_occupied_hero_lobbies",
		widget_type = "stepper",
		options = {
			{
				value = true,
				text = Localize("menu_settings_on")
			},
			{
				value = false,
				text = Localize("menu_settings_off")
			}
		}
	},
	{
		setting_name = "always_ask_hero_when_joining",
		widget_type = "stepper",
		options = {
			{
				value = true,
				text = Localize("menu_settings_on")
			},
			{
				value = false,
				text = Localize("menu_settings_off")
			}
		}
	},
	{
		setting_name = "friend_join_mode",
		widget_type = "stepper",
		options = {
			{
				value = "lobby_friends",
				text = Localize("menu_settings_friend_join_setting_lobby_friends")
			},
			{
				value = "host_friends_only",
				text = Localize("menu_settings_friend_join_setting_host_friends_only")
			},
			{
				value = "disabled",
				text = Localize("menu_settings_friend_join_setting_disabled")
			}
		}
	},
	{
		size_y = 30,
		widget_type = "empty"
	},
	{
		text = "settings_view_header_other",
		widget_type = "title"
	},
	{
		setup = "cb_max_upload_speed_setup",
		saved_value = "cb_max_upload_speed_saved_value",
		callback = "cb_max_upload_speed",
		tooltip_text = "tooltip_max_upload_speed",
		widget_type = "drop_down"
	},
	{
		setup = "cb_small_network_packets_setup",
		saved_value = "cb_small_network_packets_saved_value",
		callback = "cb_small_network_packets",
		tooltip_text = "tooltip_small_network_packets",
		widget_type = "stepper"
	},
	{
		setup = "cb_max_quick_play_search_range_setup",
		saved_value = "cb_max_quick_play_search_range_saved_value",
		callback = "cb_max_quick_play_search_range",
		tooltip_text = "tooltip_max_quick_play_search_range",
		widget_type = "drop_down"
	},
	{
		setting_name = "show_numerical_latency",
		widget_type = "stepper",
		options = {
			{
				value = true,
				text = Localize("menu_settings_on")
			},
			{
				value = false,
				text = Localize("menu_settings_off")
			}
		}
	}
}

fn_6(tbl_9)

local tbl_10 = {
	{
		text = "settings_view_versus_damage_feedback",
		widget_type = "title"
	},
	{
		setup = "cb_vs_floating_damage_setup",
		saved_value = "cb_vs_floating_damage_saved_value",
		callback = "cb_vs_floating_damage",
		tooltip_text = "tooltip_vs_floating_damage",
		widget_type = "stepper"
	},
	{
		setup = "cb_vs_hud_damage_feedback_in_world_setup",
		saved_value = "cb_vs_hud_damage_feedback_in_world_saved_value",
		callback = "cb_vs_hud_damage_feedback_in_world",
		tooltip_text = "tooltip_vs_hud_damage_feedback_in_world",
		widget_type = "stepper"
	},
	{
		setup = "cb_vs_hud_damage_feedback_on_yourself_setup",
		saved_value = "cb_vs_hud_damage_feedback_on_yourself_saved_value",
		callback = "cb_vs_hud_damage_feedback_on_yourself",
		tooltip_text = "tooltip_vs_hud_damage_feedback_on_yourself",
		widget_type = "stepper"
	},
	{
		setup = "cb_vs_hud_damage_feedback_on_teammates_setup",
		saved_value = "cb_vs_hud_damage_feedback_on_yourself_saved_value",
		callback = "cb_vs_hud_damage_feedback_on_teammates",
		tooltip_text = "tooltip_vs_hud_damage_feedback_on_teammates",
		widget_type = "stepper"
	},
	{
		size_y = 30,
		widget_type = "empty"
	},
	{
		text = "settings_view_header_hud_customization",
		widget_type = "title"
	},
	{
		setting_name = "toggle_pactsworn_help_ui",
		widget_type = "stepper",
		options = {
			{
				value = true,
				text = Localize("menu_settings_on")
			},
			{
				value = false,
				text = Localize("menu_settings_off")
			}
		}
	},
	{
		setting_name = "toggle_pactsworn_overhead_name_ui",
		widget_type = "stepper",
		options = {
			{
				value = true,
				text = Localize("menu_settings_on")
			},
			{
				value = false,
				text = Localize("menu_settings_off")
			}
		}
	},
	{
		setting_name = "toggle_versus_level_in_all_game_modes",
		widget_type = "stepper",
		options = {
			{
				value = true,
				text = Localize("menu_settings_on")
			},
			{
				value = false,
				text = Localize("menu_settings_off")
			}
		}
	}
}

fn_6(tbl_10)

local tbl_11 = {
	"screen_resolution",
	"fullscreen",
	"borderless_fullscreen",
	"vsync",
	"gamma",
	"skin_material_enabled",
	"char_texture_quality",
	"env_texture_quality",
	"sun_shadows",
	"sun_shadow_quality",
	"taa_enabled",
	"graphics_quality",
	"adapter_index",
	"use_physic_debris",
	"max_shadow_casting_lights",
	"local_light_shadow_quality",
	"lod_object_multiplier",
	"lod_scatter_density",
	"dof_enabled",
	"ssr_enabled",
	"ssr_high_quality",
	"low_res_transparency",
	"volumetric_lighting_local_lights",
	"volumetric_lighting_local_shadows",
	"volumetric_data_size",
	"volumetric_extrapolation_high_quality",
	"volumetric_extrapolation_volumetric_shadows",
	"ambient_light_quality",
	"particles_quality",
	"ao_quality",
	"local_probes_enabled",
	"volumetric_fog_quality"
}
local tbl_12 = {
	"char_texture_quality",
	"env_texture_quality",
	"use_physic_debris",
	"use_baked_enemy_meshes"
}

SettingsMenuNavigation = {
	"gameplay_settings",
	"video_settings",
	"audio_settings",
	"keybind_settings",
	"gamepad_settings",
	"network_settings"
}
TutorialSettingsMenuNavigation = {
	true,
	true,
	true,
	true,
	true,
	true,
	true
}

local tbl_13 = {}

tbl_13[#tbl_13 + 1] = UIWidgets.create_text_button("settings_button_1", "settings_view_gameplay", 18)
tbl_13[#tbl_13 + 1] = UIWidgets.create_text_button("settings_button_3", "settings_view_video", 18)
tbl_13[#tbl_13 + 1] = UIWidgets.create_text_button("settings_button_4", "settings_view_sound", 18)
tbl_13[#tbl_13 + 1] = UIWidgets.create_text_button("settings_button_5", "settings_view_keybind", 18)
tbl_13[#tbl_13 + 1] = UIWidgets.create_text_button("settings_button_6", "settings_view_gamepad", 18)
tbl_13[#tbl_13 + 1] = UIWidgets.create_text_button("settings_button_7", "settings_view_network", 18)

if not rawget(_G, "Tobii") then
	tbl_13[#tbl_13 + 1] = UIWidgets.create_text_button("settings_button_8", "settings_view_eyetracking", 18)
	SettingsMenuNavigation[#SettingsMenuNavigation + 1] = "tobii_eyetracking_settings"
end

tbl_13[#tbl_13 + 1] = UIWidgets.create_text_button("settings_button_10", "settings_view_versus", 18)
SettingsMenuNavigation[#SettingsMenuNavigation + 1] = "versus_settings"

return {
	video_settings_definition = tbl,
	audio_settings_definition = tbl_2,
	audio_settings_definition_without_voip = tbl_3,
	gameplay_settings_definition = tbl_4,
	display_settings_definition = tbl_5,
	keybind_settings_definition = tbl_6,
	gamepad_settings_definition = tbl_8,
	tobii_settings_definition = var_0_18,
	network_settings_definition = tbl_9,
	versus_settings_definition = tbl_10,
	needs_restart_settings = tbl_12,
	needs_reload_settings = tbl_11,
	ignore_keybind = tbl_7,
	title_button_definitions = tbl_13
}
