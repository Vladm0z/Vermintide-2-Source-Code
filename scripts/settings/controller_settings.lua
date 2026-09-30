-- chunkname: @scripts/settings/controller_settings.lua

require("scripts/utils/input_helper")

UNASSIGNED_KEY = "unassigned_keymap"
PlayerControllerKeymaps = {}
PlayerControllerKeymaps.win32 = InputUtils.keymaps_key_approved("win32")
PlayerControllerKeymaps.xb1 = InputUtils.keymaps_key_approved("xb1")
PlayerControllerKeymaps.ps4 = InputUtils.keymaps_key_approved("ps4")
PlayerControllerKeymaps.ps_pad = InputUtils.keymaps_key_approved("ps_pad")
TutorialPlayerControllerKeymaps = table.clone(PlayerControllerKeymaps)
PlayerControllerFilters = {}
PlayerControllerFilters.win32 = InputUtils.keymaps_key_approved("win32")
PlayerControllerFilters.xb1 = InputUtils.keymaps_key_approved("xb1")

local PlayerControllerFilters_ps4 = {
	look_controller = {
		filter_type = "scale_vector3_xy_accelerated_x",
		multiplier_min_x = 1.5,
		acceleration_delay = 0.2,
		threshold = 0.925,
		accelerate_time_ref = 0.5,
		multiplier_y = 0.75,
		input_mapping = "look_raw_controller",
		power_of = 1.75,
		multiplier_x = 4
	},
	look_controller_ranged = {
		filter_type = "scale_vector3_xy_accelerated_x",
		multiplier_min_x = 1.25,
		acceleration_delay = 0.2,
		threshold = 0.925,
		accelerate_time_ref = 0.6,
		multiplier_y = 0.75,
		input_mapping = "look_raw_controller",
		power_of = 2,
		multiplier_x = 4
	},
	look_controller_melee = {
		filter_type = "scale_vector3_xy_accelerated_x",
		multiplier_min_x = 2.5,
		acceleration_delay = 0.2,
		turnaround_time_ref = 0.75,
		threshold = 0.65,
		accelerate_time_ref = 0.15,
		turnaround_delay = 0.2,
		turnaround_multiplier_x = 3,
		multiplier_y = 1,
		multiplier_x = 2,
		input_mapping = "look_raw_controller",
		power_of = 1.5,
		turnaround_threshold = 0.925,
		turnaround_power_of = 2
	},
	look_controller_zoom = {
		filter_type = "scale_vector3_xy_accelerated_x",
		multiplier_min_x = 0.5,
		acceleration_delay = 0,
		threshold = 0.95,
		accelerate_time_ref = 0.3,
		multiplier_y = 0.5,
		input_mapping = "look_raw_controller",
		power_of = 1.1,
		multiplier_x = 1
	},
	look_controller_3p = {
		filter_type = "scale_vector3_xy_accelerated_x",
		multiplier_min_x = 0.5,
		acceleration_delay = 0,
		threshold = 0.95,
		accelerate_time_ref = 0.3,
		multiplier_y = 0.5,
		input_mapping = "look_raw_controller",
		power_of = 1.5,
		multiplier_x = 1.5
	},
	move_controller_up = {
		filter_type = "axis_check",
		axis_requirement = 0.7,
		input_mapping = "move_controller",
		axis = {
			0,
			1,
			0
		}
	},
	move_controller_down = {
		filter_type = "axis_check",
		axis_requirement = 0.7,
		input_mapping = "move_controller",
		axis = {
			0,
			-1,
			0
		}
	},
	move_controller_left = {
		filter_type = "axis_check",
		axis_requirement = 0.7,
		input_mapping = "move_controller",
		axis = {
			-1,
			0,
			0
		}
	},
	move_controller_right = {
		filter_type = "axis_check",
		axis_requirement = 0.7,
		input_mapping = "move_controller",
		axis = {
			1,
			0,
			0
		}
	},
	wield_switch = {
		filter_type = "or",
		input_mappings = {
			button_1 = "wield_switch_1"
		}
	},
	jump = {
		filter_type = "or",
		input_mappings = {
			button_1 = "jump_1",
			button_2 = "jump_2"
		}
	},
	dodge_hold = {
		filter_type = "or",
		input_mappings = {
			button_1 = "dodge_1",
			button_2 = "dodge_2"
		}
	},
	dodge = {
		filter_type = "or",
		input_mappings = {
			button_1 = "dodge_1",
			button_2 = "dodge_2"
		}
	},
	action_career = {
		max_delay = 0.05,
		filter_type = "or",
		input_mappings = {
			button_1 = "ability"
		},
		held = {
			button_1 = "ability_hold"
		}
	},
	action_career_hold = {
		filter_type = "or",
		input_mappings = {
			button_1 = "ability_hold"
		}
	},
	action_career_not_hold = {
		filter_type = "not",
		input_mappings = {
			button_1 = "ability_hold"
		}
	},
	action_career_release = {
		filter_type = "or",
		input_mappings = {
			button_1 = "ability_release"
		}
	},
	weapon_reload_hold = {
		filter_type = "exclusive_and",
		input_mappings = {
			button_1 = "weapon_reload_hold_input"
		},
		exclusive_input_mappings = {
			button_2 = "action_career_hold",
			button_3 = "action_career_release",
			button_1 = "action_career"
		}
	},
	weapon_reload = {
		filter_type = "exclusive_and",
		input_mappings = {
			button_1 = "weapon_reload_input"
		},
		exclusive_input_mappings = {
			button_2 = "action_career_hold",
			button_3 = "action_career_release",
			button_1 = "action_career"
		}
	}
}

PlayerControllerFilters.ps4 = InputUtils.keymaps_key_approved("ps4")
PlayerControllerFilters.ps_pad = InputUtils.keymaps_key_approved("ps_pad")
TutorialPlayerControllerFilters = table.clone(PlayerControllerFilters)
TwitchControllerSettings = {}
TwitchControllerSettings.win32 = InputUtils.keymaps_key_approved("win32")
TwitchControllerFilters = {}
TwitchControllerFilters.win32 = InputUtils.keymaps_key_approved("win32")
ChatControllerSettings = {}
ChatControllerSettings.win32 = InputUtils.keymaps_key_approved("win32")
ChatControllerSettings.xb1 = InputUtils.keymaps_key_approved("xb1")
ChatControllerSettings.ps4 = InputUtils.keymaps_key_approved("ps4")
ChatControllerSettings.ps_pad = InputUtils.keymaps_key_approved("ps_pad")
ChatControllerFilters = {}
ChatControllerFilters.win32 = InputUtils.keymaps_key_approved("win32")
ChatControllerFilters.xb1 = InputUtils.keymaps_key_approved("xb1")

local ChatControllerFilters_ps4 = {
	unallowed_activate_chat_input = {
		filter_type = "or",
		input_mappings = {
			button_2 = "chat_left_alt_pressed",
			button_3 = "chat_left_alt_released",
			button_1 = "chat_left_alt_held"
		}
	},
	execute_chat_input = {
		filter_type = "or",
		input_mappings = {
			button_1 = "execute_chat_input_1",
			button_2 = "execute_chat_input_2"
		}
	}
}

ChatControllerFilters.ps4 = InputUtils.keymaps_key_approved("ps4")
ChatControllerFilters.ps_pad = InputUtils.keymaps_key_approved("ps_pad")
RconControllerSettings = {}
RconControllerSettings.win32 = InputUtils.keymaps_key_approved("win32")
RconControllerSettings.xb1 = InputUtils.keymaps_key_approved("xb1")
RconControllerFilters = {}
FreeFlightKeymaps = {}
FreeFlightKeymaps.win32 = InputUtils.keymaps_key_approved("win32")
FreeFlightKeymaps.xb1 = InputUtils.keymaps_key_approved("xb1")
FreeFlightKeymaps.ps4 = InputUtils.keymaps_key_approved("ps4")
FreeFlightKeymaps.ps_pad = InputUtils.keymaps_key_approved("ps_pad")
FreeFlightFilters = {}
FreeFlightFilters.win32 = InputUtils.keymaps_key_approved("win32")
FreeFlightFilters.xb1 = InputUtils.keymaps_key_approved("xb1")

local FreeFlightFilters_ps4 = {
	look = {
		multiplier_y = -400.5,
		power_of = 2,
		acceleration_delay = 0,
		input_mapping = "look_raw_controller",
		threshold = 0.925,
		accelerate_time_ref = 0.1,
		multiplier_x = 600,
		filter_type = "scale_vector3_xy_accelerated_x"
	},
	move = {
		filter_type = "virtual_axis",
		input_mappings = {
			down = "move_down",
			up = "move_up",
			forward = "move_forward",
			back = "move_back",
			left = "move_left",
			right = "move_right"
		}
	},
	dof_reset = {
		filter_type = "and",
		input_mappings = {
			button_1 = "reset_toggle_mod",
			button_2 = "toggle_dof"
		}
	},
	inc_dof_region = {
		filter_type = "and",
		input_mappings = {
			button_1 = "right_trigger_held",
			button_2 = "gamepad_triangle_held"
		}
	},
	dec_dof_region = {
		filter_type = "and",
		input_mappings = {
			button_1 = "left_trigger_held",
			button_2 = "gamepad_triangle_held"
		}
	},
	inc_dof_padding = {
		filter_type = "and",
		input_mappings = {
			button_1 = "right_trigger_held",
			button_2 = "gamepad_circle_held"
		}
	},
	dec_dof_padding = {
		filter_type = "and",
		input_mappings = {
			button_1 = "left_trigger_held",
			button_2 = "gamepad_circle_held"
		}
	},
	inc_dof_scale = {
		filter_type = "and",
		input_mappings = {
			button_1 = "right_trigger_held",
			button_2 = "gamepad_square_held"
		}
	},
	dec_dof_scale = {
		filter_type = "and",
		input_mappings = {
			button_1 = "left_trigger_held",
			button_2 = "gamepad_square_held"
		}
	},
	free_flight_toggle = {
		filter_type = "and",
		input_mappings = {
			button_2 = "left_thumb_held",
			button_3 = "left_shoulder_held",
			button_1 = "right_thumb_held",
			button_4 = "right_shoulder"
		}
	},
	global_free_flight_toggle = {
		filter_type = "and",
		input_mappings = {
			button_1 = "left_thumb_held",
			button_2 = "gamepad_cross_pressed"
		}
	}
}

FreeFlightFilters.ps4 = InputUtils.keymaps_key_approved("ps4")
FreeFlightFilters.ps_pad = InputUtils.keymaps_key_approved("ps_pad")
SplashScreenKeymaps = {}
SplashScreenKeymaps.win32 = InputUtils.keymaps_key_approved("win32")
SplashScreenKeymaps.xb1 = InputUtils.keymaps_key_approved("xb1")
SplashScreenKeymaps.ps4 = InputUtils.keymaps_key_approved("ps4")
SplashScreenKeymaps.ps_pad = InputUtils.keymaps_key_approved("ps_pad")
SplashScreenFilters = {}
SplashScreenFilters.win32 = InputUtils.keymaps_key_approved("win32")
SplashScreenFilters.xb1 = InputUtils.keymaps_key_approved("xb1")
SplashScreenFilters.ps4 = InputUtils.keymaps_key_approved("ps4")
SplashScreenFilters.ps_pad = InputUtils.keymaps_key_approved("ps_pad")
TitleLoadingKeyMaps = {}
TitleLoadingKeyMaps.win32 = InputUtils.keymaps_key_approved("win32")
TitleLoadingKeyMaps.xb1 = InputUtils.keymaps_key_approved("xb1")
TitleLoadingKeyMaps.ps4 = InputUtils.keymaps_key_approved("ps4")
TitleLoadingKeyMaps.ps_pad = InputUtils.keymaps_key_approved("ps_pad")
TitleLoadingFilters = {}
TitleLoadingFilters.win32 = InputUtils.keymaps_key_approved("win32")
TitleLoadingFilters.xb1 = InputUtils.keymaps_key_approved("xb1")

local TitleLoadingFilters_ps4 = {
	cancel_video = {
		filter_type = "or",
		input_mappings = {
			button_1 = "cancel_video_1"
		}
	}
}

TitleLoadingFilters.ps4 = InputUtils.keymaps_key_approved("ps4")
TitleLoadingFilters.ps_pad = InputUtils.keymaps_key_approved("ps_pad")
TitleScreenKeyMaps = {}
TitleScreenKeyMaps.win32 = InputUtils.keymaps_key_approved("win32")
TitleScreenKeyMaps.xb1 = InputUtils.keymaps_key_approved("xb1")
TitleScreenKeyMaps.ps4 = InputUtils.keymaps_key_approved("ps4")
TitleScreenKeyMaps.ps_pad = InputUtils.keymaps_key_approved("ps_pad")
TitleScreenFilters = {}
TitleScreenFilters.win32 = InputUtils.keymaps_key_approved("win32")
TitleScreenFilters.xb1 = InputUtils.keymaps_key_approved("xb1")

local TitleScreenFilters_ps4 = {
	start = {
		filter_type = "or",
		input_mappings = {
			button_1 = "start_1"
		}
	},
	back = {
		filter_type = "or",
		input_mappings = {
			button_1 = "back_1"
		}
	},
	cursor = {
		filter_type = "gamepad_cursor",
		multiplier = 1000,
		acceleration_delay = 0.2,
		acceleration_threshold = 0.5,
		threshold = 0.1,
		min_multiplier_y = 25,
		accelerate_time_ref = 1.2,
		input_mapping = "axis_cursor",
		multiplier_y = 40,
		multiplier_x = 40,
		min_multiplier_x = 25,
		hover_multiplier = 0.3
	},
	down = {
		filter_type = "move_filter",
		threshold = 0.7,
		input_mappings = {
			"move_down_raw"
		},
		axis_mappings = {
			"analog_input"
		},
		axis = {
			0,
			-1,
			0
		}
	},
	up = {
		filter_type = "move_filter",
		threshold = 0.7,
		input_mappings = {
			"move_up_raw"
		},
		axis_mappings = {
			"analog_input"
		},
		axis = {
			0,
			1,
			0
		}
	},
	left = {
		filter_type = "move_filter",
		threshold = 0.7,
		input_mappings = {
			"move_left_raw"
		},
		axis_mappings = {
			"analog_input"
		},
		axis = {
			-1,
			0,
			0
		}
	},
	right = {
		filter_type = "move_filter",
		threshold = 0.7,
		input_mappings = {
			"move_right_raw"
		},
		axis_mappings = {
			"analog_input"
		},
		axis = {
			1,
			0,
			0
		}
	}
}

TitleScreenFilters.ps4 = InputUtils.keymaps_key_approved("ps4")
TitleScreenFilters.ps_pad = InputUtils.keymaps_key_approved("ps_pad")
DemoUIKeyMaps = {}
DemoUIKeyMaps.win32 = InputUtils.keymaps_key_approved("win32")
DemoUIKeyMaps.xb1 = InputUtils.keymaps_key_approved("xb1")
DemoUIKeyMaps.ps4 = InputUtils.keymaps_key_approved("ps4")
DemoUIKeyMaps.ps_pad = InputUtils.keymaps_key_approved("ps_pad")
DemoUIFilters = {}
DemoUIFilters.win32 = InputUtils.keymaps_key_approved("win32")
DemoUIFilters.xb1 = InputUtils.keymaps_key_approved("xb1")
DemoUIFilters.ps4 = InputUtils.keymaps_key_approved("ps4")
DemoUIFilters.ps_pad = InputUtils.keymaps_key_approved("ps_pad")
IngamePlayerListKeymaps = {}
IngamePlayerListKeymaps.win32 = InputUtils.keymaps_key_approved("win32")
IngamePlayerListKeymaps.xb1 = InputUtils.keymaps_key_approved("xb1")
IngamePlayerListKeymaps.ps4 = InputUtils.keymaps_key_approved("ps4")
IngamePlayerListKeymaps.ps_pad = InputUtils.keymaps_key_approved("ps_pad")
IngamePlayerListFilters = {}
IngamePlayerListFilters.win32 = InputUtils.keymaps_key_approved("win32")
IngamePlayerListFilters.xb1 = InputUtils.keymaps_key_approved("xb1")

local IngamePlayerListFilters_ps4 = {
	cursor = {
		filter_type = "gamepad_cursor",
		multiplier = 1000,
		acceleration_delay = 0.2,
		acceleration_threshold = 0.5,
		threshold = 0.1,
		min_multiplier_y = 25,
		accelerate_time_ref = 1.2,
		input_mapping = "axis_cursor",
		multiplier_y = 40,
		multiplier_x = 40,
		min_multiplier_x = 25,
		hover_multiplier = 0.3
	}
}

IngamePlayerListFilters.ps4 = InputUtils.keymaps_key_approved("ps4")
IngamePlayerListFilters.ps_pad = InputUtils.keymaps_key_approved("ps_pad")
IngameMenuKeymaps = {}
IngameMenuKeymaps.win32 = InputUtils.keymaps_key_approved("win32")
IngameMenuKeymaps.xb1 = InputUtils.keymaps_key_approved("xb1")
IngameMenuKeymaps.ps4 = InputUtils.keymaps_key_approved("ps4")
IngameMenuKeymaps.ps_pad = InputUtils.keymaps_key_approved("ps_pad")
IngameMenuFilters = {}
IngameMenuFilters.win32 = InputUtils.keymaps_key_approved("win32")
IngameMenuFilters.xb1 = InputUtils.keymaps_key_approved("xb1")

local IngameMenuFilters_ps4 = {
	debug_pixeldistance = {
		filter_type = "and",
		input_mappings = {
			button_1 = "debug_pixeldistance_1",
			button_2 = "debug_pixeldistance_2"
		}
	},
	show_support_info = {
		filter_type = "and",
		input_mappings = {
			button_1 = "show_support_info_1",
			button_2 = "show_support_info_2"
		}
	},
	move_down = {
		filter_type = "move_filter",
		threshold = 0.7,
		input_mappings = {
			"move_down_raw"
		},
		axis_mappings = {
			"analog_input"
		},
		axis = {
			0,
			-1,
			0
		}
	},
	move_up = {
		filter_type = "move_filter",
		threshold = 0.7,
		input_mappings = {
			"move_up_raw"
		},
		axis_mappings = {
			"analog_input"
		},
		axis = {
			0,
			1,
			0
		}
	},
	move_left = {
		filter_type = "move_filter",
		threshold = 0.7,
		input_mappings = {
			"move_left_raw"
		},
		axis_mappings = {
			"analog_input"
		},
		axis = {
			-1,
			0,
			0
		}
	},
	move_right = {
		filter_type = "move_filter",
		threshold = 0.7,
		input_mappings = {
			"move_right_raw"
		},
		axis_mappings = {
			"analog_input"
		},
		axis = {
			1,
			0,
			0
		}
	},
	move_down_hold = {
		filter_type = "move_filter",
		hold = true,
		threshold = 0.7,
		input_mappings = {
			"move_down_hold_raw"
		},
		axis_mappings = {
			"analog_input"
		},
		axis = {
			0,
			-1,
			0
		}
	},
	move_up_hold = {
		filter_type = "move_filter",
		hold = true,
		threshold = 0.7,
		input_mappings = {
			"move_up_hold_raw"
		},
		axis_mappings = {
			"analog_input"
		},
		axis = {
			0,
			1,
			0
		}
	},
	move_left_hold = {
		filter_type = "move_filter",
		hold = true,
		threshold = 0.7,
		input_mappings = {
			"move_left_hold_raw"
		},
		axis_mappings = {
			"analog_input"
		},
		axis = {
			-1,
			0,
			0
		}
	},
	move_right_hold = {
		filter_type = "move_filter",
		hold = true,
		threshold = 0.7,
		input_mappings = {
			"move_right_hold_raw"
		},
		axis_mappings = {
			"analog_input"
		},
		axis = {
			1,
			0,
			0
		}
	},
	move_down_hold_continuous = {
		filter_type = "move_filter_continuous",
		hold = true,
		threshold = 0.7,
		input_mappings = {
			"move_down_hold_raw"
		},
		axis_mappings = {
			"analog_input"
		},
		axis = {
			0,
			-1,
			0
		}
	},
	move_up_hold_continuous = {
		filter_type = "move_filter_continuous",
		hold = true,
		threshold = 0.7,
		input_mappings = {
			"move_up_hold_raw"
		},
		axis_mappings = {
			"analog_input"
		},
		axis = {
			0,
			1,
			0
		}
	},
	move_left_hold_continuous = {
		filter_type = "move_filter_continuous",
		hold = true,
		threshold = 0.7,
		input_mappings = {
			"move_left_hold_raw"
		},
		axis_mappings = {
			"analog_input"
		},
		axis = {
			-1,
			0,
			0
		}
	},
	move_right_hold_continuous = {
		filter_type = "move_filter_continuous",
		hold = true,
		threshold = 0.7,
		input_mappings = {
			"move_right_hold_raw"
		},
		axis_mappings = {
			"analog_input"
		},
		axis = {
			1,
			0,
			0
		}
	},
	cursor = {
		filter_type = "gamepad_cursor",
		multiplier = 1000,
		acceleration_delay = 0.2,
		acceleration_threshold = 0.5,
		threshold = 0.1,
		min_multiplier_y = 25,
		accelerate_time_ref = 1.2,
		input_mapping = "axis_cursor",
		multiplier_y = 40,
		multiplier_x = 40,
		min_multiplier_x = 25,
		hover_multiplier = 0.3
	},
	cancel_video = {
		filter_type = "or",
		input_mappings = {
			button_1 = "cancel_video_1",
			button_2 = "cancel_video_2"
		}
	}
}

IngameMenuFilters.ps4 = InputUtils.keymaps_key_approved("ps4")
IngameMenuFilters.ps_pad = InputUtils.keymaps_key_approved("ps_pad")
CutsceneKeymaps = {}
CutsceneKeymaps.win32 = InputUtils.keymaps_key_approved("win32")
CutsceneKeymaps.xb1 = InputUtils.keymaps_key_approved("xb1")
CutsceneKeymaps.ps4 = InputUtils.keymaps_key_approved("ps4")
CutsceneKeymaps.ps_pad = InputUtils.keymaps_key_approved("ps_pad")
CutsceneFilters = {}
CutsceneFilters.win32 = InputUtils.keymaps_key_approved("win32")
CutsceneFilters.xb1 = InputUtils.keymaps_key_approved("xb1")
CutsceneFilters.ps4 = InputUtils.keymaps_key_approved("ps4")
CutsceneFilters.ps_pad = InputUtils.keymaps_key_approved("ps_pad")
ControllerDisconnectKeymaps = {}
ControllerDisconnectKeymaps.xb1 = InputUtils.keymaps_key_approved("xb1")
ControllerDisconnectFilters = {}
ControllerDisconnectFilters.xb1 = InputUtils.keymaps_key_approved("xb1")
BenchmarkControllerSettings = {}
BenchmarkControllerSettings.win32 = InputUtils.keymaps_key_approved("win32")
EndLevelViewKeymapsFilters = table.clone(IngameMenuFilters)

if EndLevelViewKeymapsFilters.xb1 then
	EndLevelViewKeymapsFilters.xb1.cursor = nil
end

if EndLevelViewKeymapsFilters.ps4 then
	EndLevelViewKeymapsFilters.ps4.cursor = nil
end

if EndLevelViewKeymapsFilters.ps_pad then
	EndLevelViewKeymapsFilters.ps_pad.cursor = nil
end

DarkPactSelectionUIKeymaps = {}
DarkPactSelectionUIKeymaps.win32 = InputUtils.keymaps_key_approved("win32")
DarkPactSelectionUIFilters = {}
DarkPactSelectionUIFilters.win32 = InputUtils.keymaps_key_approved("win32")
DarkPactSelectionUIKeymaps.xb1 = InputUtils.keymaps_key_approved("xb1")
DarkPactSelectionUIFilters.xb1 = InputUtils.keymaps_key_approved("xb1")
DarkPactSelectionUIKeymaps.ps4 = InputUtils.keymaps_key_approved("ps4")
DarkPactSelectionUIFilters_ps4 = {
	move_left = {
		filter_type = "move_filter",
		threshold = 0.7,
		input_mappings = {
			"move_left_raw"
		},
		axis_mappings = {
			"analog_input"
		},
		axis = {
			-1,
			0,
			0
		}
	},
	move_right = {
		filter_type = "move_filter",
		threshold = 0.7,
		input_mappings = {
			"move_right_raw"
		},
		axis_mappings = {
			"analog_input"
		},
		axis = {
			1,
			0,
			0
		}
	}
}
DarkPactSelectionUIKeymaps.ps_pad = InputUtils.keymaps_key_approved("ps_pad")
DarkPactSelectionUIFilters.ps4 = InputUtils.keymaps_key_approved("ps4")
DarkPactSelectionUIFilters.ps_pad = InputUtils.keymaps_key_approved("ps_pad")
GamepadSettings = {
	menu_cooldown = 0.25,
	menu_analog_deadzone = 0.5,
	menu_speed_multiplier_frame_decrease = 0.025,
	menu_speed_multiplier_decrease = 1.3,
	menu_min_speed_multiplier = 0.5,
	quest_menu_navigation_cooldown = 0.15
}

for name, dlc in pairs(DLCSettings) do
	local controller_settings = dlc.controller_settings

	if controller_settings then
		for input_table_name, input_tables in pairs(controller_settings) do
			local input_table = rawget(_G, input_table_name)

			fassert(input_table, "controller_settings.lua - Could not find input table for: (%s)", input_table_name)

			for table_key, inputs in pairs(input_tables) do
				if InputUtils.keymaps_key_approved(table_key) then
					for action_name, input_settings in pairs(inputs) do
						input_table[table_key][action_name] = input_settings
					end
				end
			end
		end
	end
end

require("scripts/helpers/gamepad_alternate_layout_helper")
