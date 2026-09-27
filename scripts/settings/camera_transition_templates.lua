-- chunkname: @scripts/settings/camera_transition_templates.lua

require("scripts/settings/player_movement_settings")

local CameraTransitionTemplates = CameraTransitionTemplates

CameraTransitionTemplates = CameraTransitionTemplates or {}
CameraTransitionTemplates = CameraTransitionTemplates

local CameraTransitionSettings = CameraTransitionSettings

CameraTransitionSettings = CameraTransitionSettings or {}
CameraTransitionSettings = CameraTransitionSettings
CameraTransitionSettings.perspective_transition_time = 0.6

local num = 0.3

CameraTransitionTemplates.instant_cut = {}
CameraTransitionTemplates.dead = {
	position = {
		class = "CameraTransitionPositionLinear",
		duration = CameraTransitionSettings.perspective_transition_time,
		transition_func = function (arg_1_0)
			-- function 1
			return math.sin(0.5 * arg_1_0 * math.pi) * 0.8 + 0.2
		end
	},
	rotation = {
		class = "CameraTransitionRotationLerp",
		duration = CameraTransitionSettings.perspective_transition_time * 0.8
	}
}
CameraTransitionTemplates.reviving = {
	position = {
		class = "CameraTransitionPositionLinear",
		duration = CameraTransitionSettings.perspective_transition_time,
		transition_func = function (arg_2_0)
			-- function 2
			return math.sin(0.5 * arg_2_0 * math.pi) * 0.8 + 0.2
		end
	},
	rotation = {
		class = "CameraTransitionRotationLerp",
		duration = CameraTransitionSettings.perspective_transition_time * 0.8
	}
}
CameraTransitionTemplates.first_person = {
	position = {
		class = "CameraTransitionPositionLinear",
		duration = CameraTransitionSettings.perspective_transition_time,
		transition_func = function (arg_3_0)
			-- function 3
			return arg_3_0^2 * 0.8
		end
	},
	rotation = {
		class = "CameraTransitionRotationLerp",
		duration = CameraTransitionSettings.perspective_transition_time * 0.8
	}
}
CameraTransitionTemplates.first_person_fast = {
	position = {
		duration = 0.4,
		class = "CameraTransitionPositionLinear",
		transition_func = function (arg_4_0)
			-- function 4
			return arg_4_0^2 * 0.8
		end
	},
	rotation = {
		class = "CameraTransitionRotationLerp",
		duration = 0.4
	}
}
CameraTransitionTemplates.over_shoulder = {
	position = {
		class = "CameraTransitionPositionLinear",
		duration = num,
		transition_func = function (arg_5_0)
			-- function 5
			return math.sin(0.5 * arg_5_0 * math.pi)
		end
	},
	rotation = {
		class = "CameraTransitionRotationLerp",
		duration = num * 0.05
	},
	vertical_fov = {
		parameter = "vertical_fov",
		class = "CameraTransitionGeneric",
		duration = num,
		transition_func = function (arg_6_0)
			-- function 6
			return math.smoothstep(arg_6_0, 0, 1)
		end
	}
}
CameraTransitionTemplates.grabbed_by_chaos_spawn = {
	position = {
		class = "CameraTransitionPositionLinear",
		duration = num,
		transition_func = function (arg_7_0)
			-- function 7
			return math.sin(0.25 * arg_7_0 * math.pi)
		end
	},
	rotation = {
		class = "CameraTransitionRotationLerp",
		duration = num * 0.05
	},
	vertical_fov = {
		parameter = "vertical_fov",
		class = "CameraTransitionGeneric",
		duration = num,
		transition_func = function (arg_8_0)
			-- function 8
			return math.smoothstep(arg_8_0, 0, 1)
		end
	}
}
CameraTransitionTemplates.zoom = {
	position = {
		class = "CameraTransitionPositionLinear",
		duration = num,
		transition_func = function (arg_9_0)
			-- function 9
			return math.sin(0.5 * arg_9_0 * math.pi)
		end
	},
	rotation = {
		class = "CameraTransitionRotationLerp",
		duration = num * 0.05
	},
	vertical_fov = {
		parameter = "vertical_fov",
		class = "CameraTransitionGeneric",
		duration = num,
		transition_func = function (arg_10_0)
			-- function 10
			return math.smoothstep(arg_10_0, 0, 1)
		end
	}
}
