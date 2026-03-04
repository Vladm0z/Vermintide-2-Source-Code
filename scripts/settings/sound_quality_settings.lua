-- chunkname: @scripts/settings/sound_quality_settings.lua

local var_0_0 = PLATFORM

if IS_WINDOWS then
	SoundQualitySettings = {
		templates = {
			low = {
				max_num_voices = 28,
				sound_performance = 1,
				occlusion = false
			},
			medium = {
				max_num_voices = 64,
				sound_performance = 0.5,
				occlusion = false
			},
			high = {
				max_num_voices = 80,
				sound_performance = 0,
				occlusion = true
			}
		}
	}
elseif IS_LINUX then
	SoundQualitySettings = {
		templates = {
			low = {
				max_num_voices = 28,
				sound_performance = 1,
				occlusion = false
			},
			medium = {
				max_num_voices = 64,
				sound_performance = 0.5,
				occlusion = false
			},
			high = {
				max_num_voices = 80,
				sound_performance = 0,
				occlusion = true
			}
		}
	}
elseif IS_XB1 then
	SoundQualitySettings = {
		templates = {
			low = {
				max_num_voices = 28,
				sound_performance = 1,
				occlusion = false
			},
			medium = {
				max_num_voices = 64,
				sound_performance = 0.5,
				occlusion = false
			},
			high = {
				max_num_voices = 80,
				sound_performance = 0,
				occlusion = true
			}
		}
	}
elseif IS_PS4 then
	SoundQualitySettings = {
		templates = {
			low = {
				max_num_voices = 28,
				sound_performance = 1,
				occlusion = false
			},
			medium = {
				max_num_voices = 64,
				sound_performance = 0.5,
				occlusion = false
			},
			high = {
				max_num_voices = 80,
				sound_performance = 0,
				occlusion = true
			}
		}
	}
end

assert(SoundQualitySettings, "No SoundQualitySettings set?")

SoundQualitySettings.get_quality_template = function (arg_1_0)
	local var_1_0 = SoundQualitySettings.templates[arg_1_0]

	if not var_1_0 then
		local var_1_1 = DefaultUserSettings.get("user_settings", "sound_quality")

		var_1_0 = SoundQualitySettings.templates[var_1_1]

		if not LEVEL_EDITOR_TEST then
			printf("[SoundQualitySettings] No quality template for %q, using default %q", arg_1_0, var_1_1)
		end
	end

	return var_1_0
end

SoundQualitySettings.set_sound_quality = function (arg_2_0, arg_2_1)
	local var_2_0 = SoundQualitySettings.get_quality_template(arg_2_1)
	local var_2_1 = var_2_0.sound_performance

	WwiseWorld.set_global_parameter(arg_2_0, "sound_performance", var_2_1)

	local var_2_2 = var_2_0.max_num_voices

	Wwise.set_max_num_voices(var_2_2)

	local var_2_3 = var_2_0.occlusion
end
