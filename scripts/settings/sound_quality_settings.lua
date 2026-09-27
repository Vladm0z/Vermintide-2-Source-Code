-- chunkname: @scripts/settings/sound_quality_settings.lua

local PLATFORM = PLATFORM

if not IS_WINDOWS then
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
elseif not IS_LINUX then
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
elseif not IS_XB1 then
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
elseif not IS_PS4 then
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
	-- function 1
	local var_1_0 = SoundQualitySettings.templates[arg_1_0]

	if not var_1_0 then
		local get = DefaultUserSettings.get("user_settings", "sound_quality")

		var_1_0 = SoundQualitySettings.templates[get]

		if not LEVEL_EDITOR_TEST then
			printf("[SoundQualitySettings] No quality template for %q, using default %q", arg_1_0, get)
		end
	end

	return var_1_0
end

SoundQualitySettings.set_sound_quality = function (arg_2_0, arg_2_1)
	-- function 2
	local get_quality_template = SoundQualitySettings.get_quality_template(arg_2_1)
	local sound_performance = get_quality_template.sound_performance

	WwiseWorld.set_global_parameter(arg_2_0, "sound_performance", sound_performance)

	local max_num_voices = get_quality_template.max_num_voices

	Wwise.set_max_num_voices(max_num_voices)

	local occlusion = get_quality_template.occlusion
end
