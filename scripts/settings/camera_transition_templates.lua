-- chunkname: @scripts/settings/camera_transition_templates.lua

require("scripts/settings/player_movement_settings")

CameraTransitionTemplates = CameraTransitionTemplates or {}
CameraTransitionSettings = CameraTransitionSettings or {}
CameraTransitionSettings.perspective_transition_time = 0.6

local var_0_0 = 0.3

CameraTransitionTemplates.instant_cut = {}
CameraTransitionTemplates.dead = {
	position = {
		class = "CameraTransitionPositionLinear",
		duration = CameraTransitionSettings.perspective_transition_time,
		transition_func = function (arg_1_0)
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
		duration = var_0_0,
		transition_func = function (arg_5_0)
			return math.sin(0.5 * arg_5_0 * math.pi)
		end
	},
	rotation = {
		class = "CameraTransitionRotationLerp",
		duration = var_0_0 * 0.05
	},
	vertical_fov = {
		parameter = "vertical_fov",
		class = "CameraTransitionGeneric",
		duration = var_0_0,
		transition_func = function (arg_6_0)
			return math.smoothstep(arg_6_0, 0, 1)
		end
	}
}
CameraTransitionTemplates.grabbed_by_chaos_spawn = {
	position = {
		class = "CameraTransitionPositionLinear",
		duration = var_0_0,
		transition_func = function (arg_7_0)
			return math.sin(0.25 * arg_7_0 * math.pi)
		end
	},
	rotation = {
		class = "CameraTransitionRotationLerp",
		duration = var_0_0 * 0.05
	},
	vertical_fov = {
		parameter = "vertical_fov",
		class = "CameraTransitionGeneric",
		duration = var_0_0,
		transition_func = function (arg_8_0)
			return math.smoothstep(arg_8_0, 0, 1)
		end
	}
}
CameraTransitionTemplates.zoom = {
	position = {
		class = "CameraTransitionPositionLinear",
		duration = var_0_0,
		transition_func = function (arg_9_0)
			return math.sin(0.5 * arg_9_0 * math.pi)
		end
	},
	rotation = {
		class = "CameraTransitionRotationLerp",
		duration = var_0_0 * 0.05
	},
	vertical_fov = {
		parameter = "vertical_fov",
		class = "CameraTransitionGeneric",
		duration = var_0_0,
		transition_func = function (arg_10_0)
			return math.smoothstep(arg_10_0, 0, 1)
		end
	}
}
