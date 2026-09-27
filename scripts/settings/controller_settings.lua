-- chunkname: @scripts/settings/controller_settings.lua

require("scripts/utils/input_helper")

UNASSIGNED_KEY = "unassigned_keymap"
PlayerControllerKeymaps = {}

local PlayerControllerKeymaps = PlayerControllerKeymaps
local keymaps_key_approved = InputUtils.keymaps_key_approved("win32")

if not keymaps_key_approved then
	keymaps_key_approved = {
		toggle_input_helper = {
			"keyboard",
			"f1",
			"pressed"
		},
		action_one = {
			"mouse",
			"left",
			"pressed"
		},
		action_one_hold = {
			"mouse",
			"left",
			"held"
		},
		action_one_release = {
			"mouse",
			"left",
			"released"
		},
		action_two = {
			"mouse",
			"right",
			"pressed"
		},
		action_two_hold = {
			"mouse",
			"right",
			"held"
		},
		action_two_release = {
			"mouse",
			"right",
			"released"
		},
		action_three = {
			"keyboard",
			"v",
			"pressed"
		},
		action_three_hold = {
			"keyboard",
			"v",
			"held"
		},
		action_three_release = {
			"keyboard",
			"v",
			"released"
		},
		action_middle = {
			"mouse",
			"middle",
			"pressed"
		},
		action_inspect = {
			"keyboard",
			"z",
			"pressed"
		},
		action_inspect_hold = {
			"keyboard",
			"z",
			"held"
		},
		action_inspect_release = {
			"keyboard",
			"z",
			"released"
		},
		action_career = {
			"keyboard",
			"f",
			"pressed"
		},
		action_career_hold = {
			"keyboard",
			"f",
			"held"
		},
		action_career_release = {
			"keyboard",
			"f",
			"released"
		},
		action_one_softbutton_gamepad = {},
		action_one_mouse = {
			"mouse",
			"left",
			"pressed"
		},
		weapon_reload = {
			"keyboard",
			"r",
			"pressed"
		},
		weapon_reload_hold = {
			"keyboard",
			"r",
			"held"
		},
		character_inspecting = {
			"keyboard",
			"x",
			"held"
		},
		wield_1 = {
			"keyboard",
			"1",
			"pressed"
		},
		wield_2 = {
			"keyboard",
			"2",
			"pressed"
		},
		wield_3 = {
			"keyboard",
			"3",
			"pressed"
		}
	}

	local tbl

	if not IS_XB1 then
		tbl = {
			"keyboard",
			"5",
			"pressed"
		}

		if not tbl then
			-- Nothing
		end
	end

	tbl = {
		"keyboard",
		"4",
		"pressed"
	}

	::label_0_0::

	keymaps_key_approved.wield_4 = tbl
	keymaps_key_approved.wield_4_alt = {
		"keyboard",
		UNASSIGNED_KEY,
		"pressed"
	}

	local tbl_2

	if not IS_XB1 then
		tbl_2 = {
			"keyboard",
			"4",
			"pressed"
		}

		if not tbl_2 then
			-- Nothing
		end
	end

	tbl_2 = {
		"keyboard",
		"5",
		"pressed"
	}

	::label_0_1::

	keymaps_key_approved.wield_5 = tbl_2
	keymaps_key_approved.wield_6 = {
		"keyboard",
		"6",
		"pressed"
	}
	keymaps_key_approved.wield_7 = {
		"keyboard",
		"7",
		"pressed"
	}
	keymaps_key_approved.wield_8 = {
		"keyboard",
		"8",
		"pressed"
	}
	keymaps_key_approved.wield_9 = {
		"keyboard",
		"9",
		"pressed"
	}
	keymaps_key_approved.wield_0 = {
		"keyboard",
		"0",
		"pressed"
	}
	keymaps_key_approved.wield_switch = {
		"keyboard",
		"q",
		"pressed"
	}
	keymaps_key_approved.wield_switch_1 = {
		"keyboard",
		"q",
		"pressed"
	}
	keymaps_key_approved.wield_switch_2 = {}
	keymaps_key_approved.wield_scroll = {
		"mouse",
		"wheel",
		"axis"
	}
	keymaps_key_approved.wield_next = {
		"mouse",
		"wheel_down",
		"pressed"
	}
	keymaps_key_approved.wield_prev = {
		"mouse",
		"wheel_up",
		"pressed"
	}
	keymaps_key_approved.walk = {
		"keyboard",
		"left alt",
		"held"
	}
	keymaps_key_approved.interact = {
		"keyboard",
		"e",
		"pressed"
	}
	keymaps_key_approved.interacting = {
		"keyboard",
		"e",
		"held"
	}
	keymaps_key_approved.jump_1 = {
		"keyboard",
		"space",
		"pressed"
	}
	keymaps_key_approved.jump_2 = {}
	keymaps_key_approved.jump_only = {
		"keyboard",
		UNASSIGNED_KEY,
		"pressed"
	}
	keymaps_key_approved.dodge_hold = {
		"keyboard",
		"space",
		"held"
	}
	keymaps_key_approved.dodge = {
		"keyboard",
		UNASSIGNED_KEY,
		"pressed"
	}
	keymaps_key_approved.crouch = {
		"keyboard",
		"left ctrl",
		"pressed"
	}
	keymaps_key_approved.crouching = {
		"keyboard",
		"left ctrl",
		"held"
	}
	keymaps_key_approved.look_raw = {
		"mouse",
		"mouse",
		"axis"
	}
	keymaps_key_approved.look_raw_controller = {
		"gamepad",
		"right",
		"axis"
	}
	keymaps_key_approved.move_controller = {
		"gamepad",
		"left",
		"axis"
	}
	keymaps_key_approved.ping = {
		"keyboard",
		"t",
		"pressed"
	}
	keymaps_key_approved.ping_hold = {
		"keyboard",
		"t",
		"held"
	}
	keymaps_key_approved.ping_release = {
		"keyboard",
		"t",
		"released"
	}
	keymaps_key_approved.angular_velocity = {}
	keymaps_key_approved.social_wheel_only = {
		"keyboard",
		UNASSIGNED_KEY,
		"pressed"
	}
	keymaps_key_approved.social_wheel_only_hold = {
		"keyboard",
		UNASSIGNED_KEY,
		"held"
	}
	keymaps_key_approved.social_wheel_only_release = {
		"keyboard",
		UNASSIGNED_KEY,
		"released"
	}
	keymaps_key_approved.weapon_poses_only = {
		"keyboard",
		UNASSIGNED_KEY,
		"pressed"
	}
	keymaps_key_approved.weapon_poses_only_hold = {
		"keyboard",
		UNASSIGNED_KEY,
		"held"
	}
	keymaps_key_approved.weapon_poses_only_release = {
		"keyboard",
		UNASSIGNED_KEY,
		"released"
	}
	keymaps_key_approved.photomode_only = {
		"keyboard",
		"u",
		"pressed"
	}
	keymaps_key_approved.photomode_only_hold = {
		"keyboard",
		"u",
		"held"
	}
	keymaps_key_approved.photomode_only_release = {
		"keyboard",
		"u",
		"released"
	}
	keymaps_key_approved.social_wheel_page = {
		"keyboard",
		"e",
		"pressed"
	}
	keymaps_key_approved.ping_only = {
		"keyboard",
		UNASSIGNED_KEY,
		"pressed"
	}
	keymaps_key_approved.move_left = {
		"keyboard",
		"a",
		"soft_button"
	}
	keymaps_key_approved.move_right = {
		"keyboard",
		"d",
		"soft_button"
	}
	keymaps_key_approved.move_forward = {
		"keyboard",
		"w",
		"soft_button"
	}
	keymaps_key_approved.move_back = {
		"keyboard",
		"s",
		"soft_button"
	}
	keymaps_key_approved.move_left_pressed = {
		"keyboard",
		"a",
		"pressed"
	}
	keymaps_key_approved.move_right_pressed = {
		"keyboard",
		"d",
		"pressed"
	}
	keymaps_key_approved.move_forward_pressed = {
		"keyboard",
		"w",
		"pressed"
	}
	keymaps_key_approved.move_back_pressed = {
		"keyboard",
		"s",
		"pressed"
	}
	keymaps_key_approved.cursor = {
		"mouse",
		"cursor",
		"axis"
	}
	keymaps_key_approved.show_career_help = {
		"keyboard",
		"f1",
		"held"
	}
	keymaps_key_approved.next_observer_target = {
		"mouse",
		"left",
		"pressed"
	}
	keymaps_key_approved.previous_observer_target = {
		"mouse",
		"right",
		"pressed"
	}
	keymaps_key_approved.observer_change_offset = {
		"mouse",
		"wheel",
		"axis"
	}
	keymaps_key_approved.previous_observer_view = {
		"keyboard",
		"q",
		"pressed"
	}
	keymaps_key_approved.next_observer_view = {
		"keyboard",
		"e",
		"pressed"
	}
	keymaps_key_approved.next_observer_rotation_state = {
		"keyboard",
		"l",
		"pressed"
	}
	keymaps_key_approved.previous_observer_rotation_state = {
		"keyboard",
		"k",
		"pressed"
	}
	keymaps_key_approved.emote_camera_zoom = {
		"mouse",
		"wheel",
		"axis"
	}
	keymaps_key_approved.emote_toggle_hud_visibility = {
		"keyboard",
		"h",
		"pressed"
	}
	keymaps_key_approved.ghost_mode_enter = {
		"keyboard",
		"q",
		"pressed"
	}
	keymaps_key_approved.ghost_mode_exit = {
		"mouse",
		"right",
		"pressed"
	}
	keymaps_key_approved.versus_horde_ability = {
		"keyboard",
		"f",
		"pressed"
	}
	keymaps_key_approved.dark_pact_action_one = {
		"mouse",
		"left",
		"pressed"
	}
	keymaps_key_approved.dark_pact_action_one_hold = {
		"mouse",
		"left",
		"held"
	}
	keymaps_key_approved.dark_pact_action_one_release = {
		"mouse",
		"left",
		"released"
	}
	keymaps_key_approved.dark_pact_action_two = {
		"mouse",
		"right",
		"pressed"
	}
	keymaps_key_approved.dark_pact_action_two_hold = {
		"mouse",
		"right",
		"held"
	}
	keymaps_key_approved.dark_pact_action_two_release = {
		"mouse",
		"right",
		"released"
	}
	keymaps_key_approved.dark_pact_reload = {
		"keyboard",
		"r",
		"pressed"
	}
	keymaps_key_approved.dark_pact_reload_hold = {
		"keyboard",
		"r",
		"held"
	}
	keymaps_key_approved.dark_pact_interact = {
		"keyboard",
		"e",
		"pressed"
	}
	keymaps_key_approved.dark_pact_interacting = {
		"keyboard",
		"e",
		"held"
	}
	keymaps_key_approved.dark_pact_climb_point = {
		"keyboard",
		"e",
		"pressed"
	}
end

PlayerControllerKeymaps.win32 = keymaps_key_approved

local PlayerControllerKeymaps_2 = PlayerControllerKeymaps
local keymaps_key_approved_2 = InputUtils.keymaps_key_approved("xb1")

keymaps_key_approved_2 = not keymaps_key_approved_2 and {
	toggle_input_helper = {},
	action_one = {
		"gamepad",
		"right_trigger",
		"pressed"
	},
	action_one_hold = {
		"gamepad",
		"right_trigger",
		"held"
	},
	action_one_release = {
		"gamepad",
		"right_trigger",
		"released"
	},
	action_two = {
		"gamepad",
		"left_trigger",
		"pressed"
	},
	action_two_hold = {
		"gamepad",
		"left_trigger",
		"held"
	},
	action_two_release = {
		"gamepad",
		"left_trigger",
		"released"
	},
	action_three = {
		"gamepad",
		"right_thumb",
		"pressed"
	},
	action_three_hold = {
		"gamepad",
		"right_thumb",
		"held"
	},
	action_three_release = {
		"gamepad",
		"right_thumb",
		"released"
	},
	action_inspect = {
		"gamepad",
		"left_thumb",
		"pressed"
	},
	action_inspect_hold = {
		"gamepad",
		"left_thumb",
		"held"
	},
	action_inspect_release = {
		"gamepad",
		"left_thumb",
		"released"
	},
	active_ability_left_pressed = {
		"gamepad",
		"left_shoulder",
		"pressed"
	},
	active_ability_right_pressed = {
		"gamepad",
		"right_shoulder",
		"pressed"
	},
	active_ability_left_held = {
		"gamepad",
		"left_shoulder",
		"held"
	},
	active_ability_right_held = {
		"gamepad",
		"right_shoulder",
		"held"
	},
	active_ability_left_release = {
		"gamepad",
		"left_shoulder",
		"released"
	},
	active_ability_right_release = {
		"gamepad",
		"right_shoulder",
		"released"
	},
	action_one_softbutton_gamepad = {
		"gamepad",
		"right_trigger",
		"soft_button"
	},
	action_one_mouse = {},
	weapon_reload_input = {
		"gamepad",
		"x",
		"pressed"
	},
	weapon_reload_hold_input = {
		"gamepad",
		"x",
		"held"
	},
	character_inspecting = {
		"gamepad",
		"d_down",
		"held"
	},
	wield_1 = {},
	wield_2 = {},
	wield_3 = {
		"gamepad",
		"d_left",
		"pressed"
	},
	wield_4 = {
		"gamepad",
		"d_right",
		"pressed"
	},
	wield_4_alt = {},
	wield_5 = {
		"gamepad",
		"d_up",
		"pressed"
	},
	wield_6 = {},
	wield_7 = {},
	wield_8 = {},
	wield_9 = {},
	wield_0 = {},
	wield_switch_1 = {
		"gamepad",
		"y",
		"pressed"
	},
	wield_switch_2 = {},
	wield_scroll = {
		"mouse",
		"wheel",
		"axis"
	},
	wield_next = {},
	wield_prev = {},
	walk = {},
	interact = {
		"gamepad",
		"x",
		"pressed"
	},
	interacting = {
		"gamepad",
		"x",
		"held"
	},
	jump_1 = {
		"gamepad",
		"a",
		"pressed"
	},
	jump_2 = {},
	jump_only = {},
	dodge_1 = {
		"gamepad",
		"a",
		"held"
	},
	dodge_2 = {},
	dodge = {},
	crouch = {
		"gamepad",
		"b",
		"pressed"
	},
	crouching = {
		"gamepad",
		"b",
		"held"
	},
	ability = {
		"gamepad",
		"left_shoulder",
		"pressed"
	},
	ability_hold = {
		"gamepad",
		"left_shoulder",
		"held"
	},
	ability_release = {
		"gamepad",
		"left_shoulder",
		"released"
	},
	look_raw = {},
	look_raw_controller = {
		"gamepad",
		"right",
		"axis"
	},
	move_controller = {
		"gamepad",
		"left",
		"axis"
	},
	cursor = {
		"gamepad",
		"left",
		"axis"
	},
	ping = {
		"gamepad",
		"right_shoulder",
		"pressed"
	},
	ping_hold = {
		"gamepad",
		"right_shoulder",
		"held"
	},
	ping_release = {
		"gamepad",
		"right_shoulder",
		"released"
	},
	angular_velocity = {},
	social_wheel_only = {},
	social_wheel_only_hold = {},
	social_wheel_only_release = {},
	weapon_poses_only = {},
	weapon_poses_only_hold = {},
	weapon_poses_only_release = {},
	photomode_only = {},
	photomode_only_hold = {},
	photomode_only_release = {},
	social_wheel_page = {
		"gamepad",
		"x",
		"pressed"
	},
	ping_only = {},
	move_left = {},
	move_right = {},
	move_forward = {},
	move_back = {},
	move_left_pressed = {},
	move_right_pressed = {},
	move_forward_pressed = {},
	move_back_pressed = {},
	next_observer_target = {
		"gamepad",
		"a",
		"pressed"
	},
	previous_observer_target = {
		"gamepad",
		"b",
		"pressed"
	},
	emote_camera_zoom_in = {
		"gamepad",
		"right_trigger",
		"soft_button"
	},
	emote_camera_zoom_out = {
		"gamepad",
		"left_trigger",
		"soft_button"
	},
	emote_toggle_hud_visibility = {
		"gamepad",
		"x",
		"pressed"
	},
	ghost_mode_enter = {
		"gamepad",
		"y",
		"pressed"
	},
	ghost_mode_exit = {
		"gamepad",
		"x",
		"pressed"
	},
	versus_horde_ability = {
		"gamepad",
		"d_up",
		"pressed"
	},
	dark_pact_action_one = {
		"gamepad",
		"right_trigger",
		"pressed"
	},
	dark_pact_action_one_hold = {
		"gamepad",
		"right_trigger",
		"held"
	},
	dark_pact_action_one_release = {
		"gamepad",
		"right_trigger",
		"released"
	},
	dark_pact_action_two = {
		"gamepad",
		"left_trigger",
		"pressed"
	},
	dark_pact_action_two_hold = {
		"gamepad",
		"left_trigger",
		"held"
	},
	dark_pact_action_two_release = {
		"gamepad",
		"left_trigger",
		"released"
	},
	dark_pact_reload = {
		"gamepad",
		"x",
		"pressed"
	},
	dark_pact_reload_hold = {
		"gamepad",
		"x",
		"held"
	},
	dark_pact_interact = {
		"gamepad",
		"x",
		"pressed"
	},
	dark_pact_interacting = {
		"gamepad",
		"x",
		"held"
	},
	dark_pact_climb_point = {
		"gamepad",
		"x",
		"pressed"
	}
}
PlayerControllerKeymaps_2.xb1 = keymaps_key_approved_2

local PlayerControllerKeymaps_3 = PlayerControllerKeymaps
local str = "ps4"
local keymaps_key_approved_3 = InputUtils.keymaps_key_approved("ps4")

keymaps_key_approved_3 = not keymaps_key_approved_3 and {
	toggle_input_helper = {
		"keyboard",
		"f1",
		"pressed"
	},
	action_one = {
		"gamepad",
		"r2",
		"pressed"
	},
	action_one_hold = {
		"gamepad",
		"r2",
		"held"
	},
	action_one_release = {
		"gamepad",
		"r2",
		"released"
	},
	action_two = {
		"gamepad",
		"l2",
		"pressed"
	},
	action_two_hold = {
		"gamepad",
		"l2",
		"held"
	},
	action_two_release = {
		"gamepad",
		"l2",
		"released"
	},
	action_three = {
		"gamepad",
		"r3",
		"pressed"
	},
	action_three_hold = {
		"gamepad",
		"r3",
		"held"
	},
	action_three_release = {
		"gamepad",
		"r3",
		"released"
	},
	action_inspect = {
		"gamepad",
		"l3",
		"pressed"
	},
	action_inspect_hold = {
		"gamepad",
		"l3",
		"held"
	},
	action_inspect_release = {
		"gamepad",
		"l3",
		"released"
	},
	reset_view = {
		"gamepad",
		"l3",
		"pressed"
	},
	active_ability_left_pressed = {
		"gamepad",
		"l1",
		"pressed"
	},
	active_ability_right_pressed = {
		"gamepad",
		"r1",
		"pressed"
	},
	active_ability_left_held = {
		"gamepad",
		"l1",
		"held"
	},
	active_ability_right_held = {
		"gamepad",
		"r1",
		"held"
	},
	active_ability_left_release = {
		"gamepad",
		"l1",
		"released"
	},
	active_ability_right_release = {
		"gamepad",
		"r1",
		"released"
	},
	action_one_softbutton_gamepad = {
		"gamepad",
		"r2",
		"soft_button"
	},
	action_one_mouse = {},
	weapon_reload_input = {
		"gamepad",
		"square",
		"pressed"
	},
	weapon_reload_hold_input = {
		"gamepad",
		"square",
		"held"
	},
	character_inspecting = {
		"gamepad",
		"down",
		"held"
	},
	wield_1 = {},
	wield_2 = {},
	wield_3 = {
		"gamepad",
		"left",
		"pressed"
	},
	wield_4 = {
		"gamepad",
		"right",
		"pressed"
	},
	wield_4_alt = {},
	wield_5 = {
		"gamepad",
		"up",
		"pressed"
	},
	wield_6 = {},
	wield_7 = {},
	wield_8 = {},
	wield_9 = {},
	wield_0 = {},
	wield_switch_1 = {
		"gamepad",
		"triangle",
		"pressed"
	},
	wield_switch_2 = {},
	wield_scroll = {
		"mouse",
		"wheel",
		"axis"
	},
	wield_next = {},
	wield_prev = {},
	walk = {},
	interact = {
		"gamepad",
		"square",
		"pressed"
	},
	interacting = {
		"gamepad",
		"square",
		"held"
	},
	jump_1 = {
		"gamepad",
		"cross",
		"pressed"
	},
	jump_2 = {},
	jump_only = {},
	dodge_1 = {
		"gamepad",
		"cross",
		"held"
	},
	dodge_2 = {},
	dodge = {},
	crouch = {
		"gamepad",
		"circle",
		"pressed"
	},
	crouching = {
		"gamepad",
		"circle",
		"held"
	},
	ability = {
		"gamepad",
		"l1",
		"pressed"
	},
	ability_hold = {
		"gamepad",
		"l1",
		"held"
	},
	ability_release = {
		"gamepad",
		"l1",
		"released"
	},
	look_raw = {},
	look_raw_controller = {
		"gamepad",
		"right",
		"axis"
	},
	move_controller = {
		"gamepad",
		"left",
		"axis"
	},
	cursor = {
		"gamepad",
		"left",
		"axis"
	},
	ping = {
		"gamepad",
		"r1",
		"pressed"
	},
	ping_hold = {
		"gamepad",
		"r1",
		"held"
	},
	ping_release = {
		"gamepad",
		"r1",
		"released"
	},
	angular_velocity = {
		"gamepad",
		"angular_velocity",
		"axis"
	},
	social_wheel_only = {},
	social_wheel_only_hold = {},
	social_wheel_only_release = {},
	weapon_poses_only = {},
	weapon_poses_only_hold = {},
	weapon_poses_only_release = {},
	photomode_only = {},
	photomode_only_hold = {},
	photomode_only_release = {},
	social_wheel_page = {
		"gamepad",
		"square",
		"pressed"
	},
	ping_only = {},
	move_left = {},
	move_right = {},
	move_forward = {},
	move_back = {},
	move_left_pressed = {},
	move_right_pressed = {},
	move_forward_pressed = {},
	move_back_pressed = {},
	next_observer_target = {
		"gamepad",
		"cross",
		"pressed"
	},
	previous_observer_target = {
		"gamepad",
		"circle",
		"pressed"
	},
	emote_camera_zoom_in = {
		"gamepad",
		"r2",
		"soft_button"
	},
	emote_camera_zoom_out = {
		"gamepad",
		"l2",
		"soft_button"
	},
	emote_toggle_hud_visibility = {
		"gamepad",
		"square",
		"pressed"
	},
	ghost_mode_enter = {
		"gamepad",
		"triangle",
		"pressed"
	},
	ghost_mode_exit = {
		"gamepad",
		"square",
		"pressed"
	},
	versus_horde_ability = {
		"gamepad",
		"up",
		"pressed"
	},
	dark_pact_action_one = {
		"gamepad",
		"r2",
		"pressed"
	},
	dark_pact_action_one_hold = {
		"gamepad",
		"r2",
		"held"
	},
	dark_pact_action_one_release = {
		"gamepad",
		"r2",
		"released"
	},
	dark_pact_action_two = {
		"gamepad",
		"l2",
		"pressed"
	},
	dark_pact_action_two_hold = {
		"gamepad",
		"l2",
		"held"
	},
	dark_pact_action_two_release = {
		"gamepad",
		"l2",
		"released"
	},
	dark_pact_reload = {
		"gamepad",
		"square",
		"pressed"
	},
	dark_pact_reload_hold = {
		"gamepad",
		"square",
		"held"
	},
	dark_pact_interact = {
		"gamepad",
		"square",
		"pressed"
	},
	dark_pact_interacting = {
		"gamepad",
		"square",
		"held"
	},
	dark_pact_climb_point = {
		"gamepad",
		"square",
		"pressed"
	}
}
PlayerControllerKeymaps_3[str] = keymaps_key_approved_3

local PlayerControllerKeymaps_4 = PlayerControllerKeymaps
local str_2 = "ps_pad"
local keymaps_key_approved_4 = InputUtils.keymaps_key_approved("ps_pad")

keymaps_key_approved_4 = not keymaps_key_approved_4 and {
	toggle_input_helper = {
		"keyboard",
		"f1",
		"pressed"
	},
	action_one = {
		"ps_pad",
		"r2",
		"pressed"
	},
	action_one_hold = {
		"ps_pad",
		"r2",
		"held"
	},
	action_one_release = {
		"ps_pad",
		"r2",
		"released"
	},
	action_two = {
		"ps_pad",
		"l2",
		"pressed"
	},
	action_two_hold = {
		"ps_pad",
		"l2",
		"held"
	},
	action_two_release = {
		"ps_pad",
		"l2",
		"released"
	},
	action_three = {
		"ps_pad",
		"r3",
		"pressed"
	},
	action_three_hold = {
		"ps_pad",
		"r3",
		"held"
	},
	action_three_release = {
		"ps_pad",
		"r3",
		"released"
	},
	action_inspect = {
		"ps_pad",
		"l3",
		"pressed"
	},
	action_inspect_hold = {
		"ps_pad",
		"l3",
		"held"
	},
	action_inspect_release = {
		"ps_pad",
		"l3",
		"released"
	},
	reset_view = {
		"ps_pad",
		"l3",
		"pressed"
	},
	active_ability_left_pressed = {
		"ps_pad",
		"l1",
		"pressed"
	},
	active_ability_right_pressed = {
		"ps_pad",
		"r1",
		"pressed"
	},
	active_ability_left_held = {
		"ps_pad",
		"l1",
		"held"
	},
	active_ability_right_held = {
		"ps_pad",
		"r1",
		"held"
	},
	active_ability_left_release = {
		"ps_pad",
		"l1",
		"released"
	},
	active_ability_right_release = {
		"ps_pad",
		"r1",
		"released"
	},
	action_one_softbutton_gamepad = {
		"ps_pad",
		"r2",
		"soft_button"
	},
	action_one_mouse = {},
	weapon_reload_input = {
		"ps_pad",
		"square",
		"pressed"
	},
	weapon_reload_hold_input = {
		"ps_pad",
		"square",
		"held"
	},
	character_inspecting = {
		"ps_pad",
		"down",
		"held"
	},
	wield_1 = {},
	wield_2 = {},
	wield_3 = {
		"ps_pad",
		"left",
		"pressed"
	},
	wield_4 = {
		"ps_pad",
		"right",
		"pressed"
	},
	wield_4_alt = {},
	wield_5 = {
		"ps_pad",
		"up",
		"pressed"
	},
	wield_6 = {},
	wield_7 = {},
	wield_8 = {},
	wield_9 = {},
	wield_0 = {},
	wield_switch_1 = {
		"ps_pad",
		"triangle",
		"pressed"
	},
	wield_switch_2 = {},
	wield_scroll = {
		"mouse",
		"wheel",
		"axis"
	},
	wield_next = {},
	wield_prev = {},
	walk = {},
	interact = {
		"ps_pad",
		"square",
		"pressed"
	},
	interacting = {
		"ps_pad",
		"square",
		"held"
	},
	jump_1 = {
		"ps_pad",
		"cross",
		"pressed"
	},
	jump_2 = {},
	jump_only = {},
	dodge_1 = {
		"ps_pad",
		"cross",
		"held"
	},
	dodge_2 = {},
	dodge = {},
	crouch = {
		"ps_pad",
		"circle",
		"pressed"
	},
	crouching = {
		"ps_pad",
		"circle",
		"held"
	},
	ability = {
		"ps_pad",
		"l1",
		"pressed"
	},
	ability_hold = {
		"ps_pad",
		"l1",
		"held"
	},
	ability_release = {
		"ps_pad",
		"l1",
		"released"
	},
	look_raw = {},
	look_raw_controller = {
		"ps_pad",
		"right",
		"axis"
	},
	move_controller = {
		"ps_pad",
		"left",
		"axis"
	},
	cursor = {
		"ps_pad",
		"left",
		"axis"
	},
	ping = {
		"ps_pad",
		"r1",
		"pressed"
	},
	ping_hold = {
		"ps_pad",
		"r1",
		"held"
	},
	ping_release = {
		"ps_pad",
		"r1",
		"released"
	},
	angular_velocity = {
		"ps_pad",
		"angular_velocity",
		"axis"
	},
	social_wheel_only = {},
	social_wheel_only_hold = {},
	social_wheel_only_release = {},
	weapon_poses_only = {},
	weapon_poses_only_hold = {},
	weapon_poses_only_release = {},
	photomode_only = {},
	photomode_only_hold = {},
	photomode_only_release = {},
	social_wheel_page = {
		"ps_pad",
		"square",
		"pressed"
	},
	ping_only = {},
	move_left = {},
	move_right = {},
	move_forward = {},
	move_back = {},
	move_left_pressed = {},
	move_right_pressed = {},
	move_forward_pressed = {},
	move_back_pressed = {},
	next_observer_target = {
		"ps_pad",
		"cross",
		"pressed"
	},
	previous_observer_target = {
		"ps_pad",
		"circle",
		"pressed"
	},
	emote_camera_zoom_in = {
		"ps_pad",
		"r2",
		"soft_button"
	},
	emote_camera_zoom_out = {
		"ps_pad",
		"l2",
		"soft_button"
	},
	emote_toggle_hud_visibility = {
		"ps_pad",
		"square",
		"pressed"
	},
	ghost_mode_enter = {
		"ps_pad",
		"triangle",
		"pressed"
	},
	ghost_mode_exit = {
		"ps_pad",
		"square",
		"pressed"
	},
	versus_horde_ability = {
		"ps_pad",
		"up",
		"pressed"
	},
	dark_pact_action_one = {
		"ps_pad",
		"r2",
		"pressed"
	},
	dark_pact_action_one_hold = {
		"ps_pad",
		"r2",
		"held"
	},
	dark_pact_action_one_release = {
		"ps_pad",
		"r2",
		"released"
	},
	dark_pact_action_two = {
		"ps_pad",
		"l2",
		"pressed"
	},
	dark_pact_action_two_hold = {
		"ps_pad",
		"l2",
		"held"
	},
	dark_pact_action_two_release = {
		"ps_pad",
		"l2",
		"released"
	},
	dark_pact_reload = {
		"ps_pad",
		"square",
		"pressed"
	},
	dark_pact_reload_hold = {
		"ps_pad",
		"square",
		"held"
	},
	dark_pact_interact = {
		"ps_pad",
		"square",
		"pressed"
	},
	dark_pact_interacting = {
		"ps_pad",
		"square",
		"held"
	},
	dark_pact_climb_point = {
		"ps_pad",
		"square",
		"pressed"
	}
}
PlayerControllerKeymaps_4[str_2] = keymaps_key_approved_4
TutorialPlayerControllerKeymaps = table.clone(PlayerControllerKeymaps)
PlayerControllerFilters = {}

local PlayerControllerFilters = PlayerControllerFilters
local keymaps_key_approved_5 = InputUtils.keymaps_key_approved("win32")

keymaps_key_approved_5 = not keymaps_key_approved_5 and {
	move = {
		filter_type = "virtual_axis",
		input_mappings = {
			right = "move_right",
			back = "move_back",
			left = "move_left",
			forward = "move_forward"
		}
	},
	look = {
		filter_type = "scale_vector3_invert_y",
		multiplier = 0.0006,
		input_mapping = "look_raw"
	},
	jump = {
		filter_type = "or",
		input_mappings = {
			button_1 = "jump_1",
			button_2 = "jump_2"
		}
	},
	wield_switch = {
		filter_type = "or",
		input_mappings = {
			button_1 = "wield_switch_1"
		}
	},
	look_controller = {
		filter_type = "scale_vector3_xy_accelerated_x",
		multiplier_return_y = 1.75,
		acceleration_delay = 0.2,
		multiplier_y = 0.75,
		threshold = 0.925,
		multiplier_min_x = 1.5,
		accelerate_time_ref = 0.5,
		angle_to_slow_down_inside = 0.5,
		input_mapping = "look_raw_controller",
		power_of = 1.75,
		multiplier_x = 4
	},
	look_controller_ranged = {
		filter_type = "scale_vector3_xy_accelerated_x",
		multiplier_return_y = 1.75,
		acceleration_delay = 0.2,
		multiplier_y = 0.75,
		threshold = 0.925,
		multiplier_min_x = 1.25,
		accelerate_time_ref = 0.6,
		angle_to_slow_down_inside = 0.5,
		input_mapping = "look_raw_controller",
		power_of = 2,
		multiplier_x = 4
	},
	look_controller_melee = {
		filter_type = "scale_vector3_xy_accelerated_x",
		multiplier_return_y = 2,
		acceleration_delay = 0.2,
		turnaround_time_ref = 0.75,
		threshold = 0.65,
		multiplier_min_x = 2.5,
		turnaround_threshold = 0.925,
		turnaround_delay = 0.2,
		angle_to_slow_down_inside = 0.5,
		multiplier_y = 1,
		turnaround_multiplier_x = 3,
		input_mapping = "look_raw_controller",
		accelerate_time_ref = 0.15,
		power_of = 1.5,
		multiplier_x = 2,
		turnaround_power_of = 2
	},
	look_controller_zoom = {
		filter_type = "scale_vector3_xy_accelerated_x",
		multiplier_return_y = 1.5,
		acceleration_delay = 0,
		multiplier_y = 0.5,
		threshold = 0.95,
		multiplier_min_x = 0.5,
		accelerate_time_ref = 0.3,
		angle_to_slow_down_inside = 0.5,
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
	action_career_not_hold = {
		filter_type = "not",
		input_mappings = {
			button_1 = "action_career_hold"
		}
	}
}
PlayerControllerFilters.win32 = keymaps_key_approved_5

local PlayerControllerFilters_2 = PlayerControllerFilters
local keymaps_key_approved_6 = InputUtils.keymaps_key_approved("xb1")

keymaps_key_approved_6 = not keymaps_key_approved_6 and {
	look_controller = {
		filter_type = "scale_vector3_xy_accelerated_x",
		multiplier_return_y = 1.75,
		acceleration_delay = 0.01,
		multiplier_y = 0.75,
		threshold = 0.925,
		accelerate_time_ref = 0.3,
		multiplier_min_x = 1.5,
		angle_to_slow_down_inside = 0.5,
		input_mapping = "look_raw_controller",
		power_of = 2,
		multiplier_x = 5
	},
	look_controller_ranged = {
		filter_type = "scale_vector3_xy_accelerated_x",
		multiplier_return_y = 1.75,
		acceleration_delay = 0.01,
		multiplier_y = 0.75,
		threshold = 0.925,
		accelerate_time_ref = 0.3,
		multiplier_min_x = 1.25,
		angle_to_slow_down_inside = 0.5,
		input_mapping = "look_raw_controller",
		power_of = 1.25,
		multiplier_x = 5
	},
	look_controller_melee = {
		filter_type = "scale_vector3_xy_accelerated_x",
		multiplier_return_y = 2,
		acceleration_delay = 0.2,
		turnaround_time_ref = 0.15,
		threshold = 0.65,
		multiplier_min_x = 2.5,
		turnaround_threshold = 0.925,
		turnaround_delay = 0.01,
		angle_to_slow_down_inside = 0.5,
		multiplier_y = 1,
		turnaround_multiplier_x = 5,
		input_mapping = "look_raw_controller",
		accelerate_time_ref = 0.15,
		power_of = 1.5,
		multiplier_x = 2,
		turnaround_power_of = 2
	},
	look_controller_zoom = {
		filter_type = "scale_vector3_xy_accelerated_x",
		multiplier_return_y = 1.5,
		acceleration_delay = 0,
		multiplier_y = 0.5,
		threshold = 0.95,
		multiplier_min_x = 0.5,
		accelerate_time_ref = 0.3,
		angle_to_slow_down_inside = 0.5,
		input_mapping = "look_raw_controller",
		power_of = 1.1,
		multiplier_x = 1
	},
	look_controller_3p = {
		filter_type = "scale_vector3_xy_accelerated_x",
		multiplier_return_y = 1.5,
		acceleration_delay = 0,
		multiplier_y = 0.5,
		threshold = 0.95,
		multiplier_min_x = 0.5,
		accelerate_time_ref = 0.3,
		angle_to_slow_down_inside = 0.5,
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
		filter_type = "or",
		input_mappings = {
			button_1 = "weapon_reload_hold_input"
		}
	},
	weapon_reload = {
		filter_type = "or",
		input_mappings = {
			button_1 = "weapon_reload_input"
		}
	}
}
PlayerControllerFilters_2.xb1 = keymaps_key_approved_6

local tbl_3 = {
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
local PlayerControllerFilters_3 = PlayerControllerFilters
local str_3 = "ps4"
local keymaps_key_approved_7 = InputUtils.keymaps_key_approved("ps4")

keymaps_key_approved_7 = not keymaps_key_approved_7 and tbl_3
PlayerControllerFilters_3[str_3] = keymaps_key_approved_7

local PlayerControllerFilters_4 = PlayerControllerFilters
local str_4 = "ps_pad"
local keymaps_key_approved_8 = InputUtils.keymaps_key_approved("ps_pad")

keymaps_key_approved_8 = not keymaps_key_approved_8 and tbl_3
PlayerControllerFilters_4[str_4] = keymaps_key_approved_8
TutorialPlayerControllerFilters = table.clone(PlayerControllerFilters)
TwitchControllerSettings = {}

local TwitchControllerSettings = TwitchControllerSettings
local keymaps_key_approved_9 = InputUtils.keymaps_key_approved("win32")

keymaps_key_approved_9 = not keymaps_key_approved_9 and {
	execute_login_1 = {
		"keyboard",
		"enter",
		"pressed"
	},
	execute_login_2 = {
		"keyboard",
		"numpad enter",
		"pressed"
	},
	back = {
		"keyboard",
		"esc",
		"pressed"
	},
	cursor = {
		"mouse",
		"cursor",
		"axis"
	},
	left_release = {
		"mouse",
		"left",
		"released"
	},
	left_press = {
		"mouse",
		"left",
		"pressed"
	},
	left_hold = {
		"mouse",
		"left",
		"held"
	}
}
TwitchControllerSettings.win32 = keymaps_key_approved_9
TwitchControllerFilters = {}

local TwitchControllerFilters = TwitchControllerFilters
local keymaps_key_approved_10 = InputUtils.keymaps_key_approved("win32")

keymaps_key_approved_10 = not keymaps_key_approved_10 and {
	execute_login = {
		filter_type = "or",
		input_mappings = {
			button_1 = "execute_login_1",
			button_2 = "execute_login_2"
		}
	}
}
TwitchControllerFilters.win32 = keymaps_key_approved_10
ChatControllerSettings = {}

local ChatControllerSettings = ChatControllerSettings
local keymaps_key_approved_11 = InputUtils.keymaps_key_approved("win32")

keymaps_key_approved_11 = not keymaps_key_approved_11 and {
	activate_chat_input = {
		"keyboard",
		"y",
		"pressed"
	},
	execute_chat_input_1 = {
		"keyboard",
		"enter",
		"pressed"
	},
	execute_chat_input_2 = {
		"keyboard",
		"numpad enter",
		"pressed"
	},
	execute_chat_input_3 = {
		"keyboard",
		"left shift",
		"held"
	},
	deactivate_chat_input = {
		"keyboard",
		"esc",
		"pressed"
	},
	chat_left_alt_held = {
		"keyboard",
		"left alt",
		"held"
	},
	chat_left_alt_pressed = {
		"keyboard",
		"left alt",
		"pressed"
	},
	chat_left_alt_released = {
		"keyboard",
		"left alt",
		"released"
	},
	chat_scroll_up = {
		"keyboard",
		"page up",
		"held"
	},
	chat_scroll_down = {
		"keyboard",
		"page down",
		"held"
	},
	chat_scroll = {
		"mouse",
		"wheel",
		"axis"
	},
	chat_switch_channel = {
		"keyboard",
		"tab",
		"pressed"
	},
	chat_left_ctrl = {
		"keyboard",
		"left ctrl",
		"held"
	},
	chat_tab_pressed = {
		"keyboard",
		"tab",
		"pressed"
	},
	chat_backspace_pressed = {
		"keyboard",
		"backspace",
		"pressed"
	},
	chat_next_old_message = {
		"keyboard",
		"up",
		"pressed"
	},
	chat_previous_old_message = {
		"keyboard",
		"down",
		"pressed"
	},
	cursor = {
		"mouse",
		"cursor",
		"axis"
	},
	left_release = {
		"mouse",
		"left",
		"released"
	},
	left_press = {
		"mouse",
		"left",
		"pressed"
	},
	left_hold = {
		"mouse",
		"left",
		"held"
	},
	right_release = {
		"mouse",
		"right",
		"released"
	},
	right_press = {
		"mouse",
		"right",
		"pressed"
	},
	right_hold = {
		"mouse",
		"right",
		"held"
	},
	voip_push_to_talk = {
		"keyboard",
		"g",
		"held"
	}
}
ChatControllerSettings.win32 = keymaps_key_approved_11

local ChatControllerSettings_2 = ChatControllerSettings
local keymaps_key_approved_12 = InputUtils.keymaps_key_approved("xb1")

keymaps_key_approved_12 = not keymaps_key_approved_12 and {
	activate_chat_input = {
		"keyboard",
		"y",
		"pressed"
	},
	execute_chat_input = {
		"keyboard",
		"enter",
		"pressed"
	},
	deactivate_chat_input = {
		"keyboard",
		"esc",
		"pressed"
	},
	chat_left_alt_held = {
		"keyboard",
		"left alt",
		"held"
	},
	chat_left_alt_pressed = {
		"keyboard",
		"left alt",
		"pressed"
	},
	chat_left_alt_released = {
		"keyboard",
		"left alt",
		"released"
	},
	cursor = {
		"mouse",
		"cursor",
		"axis"
	},
	left_release = {
		"mouse",
		"left",
		"released"
	},
	left_press = {
		"mouse",
		"left",
		"pressed"
	},
	left_hold = {
		"mouse",
		"left",
		"held"
	},
	voip_push_to_talk = {}
}
ChatControllerSettings_2.xb1 = keymaps_key_approved_12

local ChatControllerSettings_3 = ChatControllerSettings
local str_5 = "ps4"
local keymaps_key_approved_13 = InputUtils.keymaps_key_approved("ps4")

keymaps_key_approved_13 = not keymaps_key_approved_13 and {
	activate_chat_input = {
		"keyboard",
		"y",
		"pressed"
	},
	execute_chat_input = {
		"keyboard",
		"enter",
		"pressed"
	},
	deactivate_chat_input = {
		"keyboard",
		"esc",
		"pressed"
	},
	chat_left_alt_held = {
		"keyboard",
		"left alt",
		"held"
	},
	chat_left_alt_pressed = {
		"keyboard",
		"left alt",
		"pressed"
	},
	chat_left_alt_released = {
		"keyboard",
		"left alt",
		"released"
	},
	cursor = {
		"mouse",
		"cursor",
		"axis"
	},
	left_release = {
		"mouse",
		"left",
		"released"
	},
	left_press = {
		"mouse",
		"left",
		"pressed"
	},
	left_hold = {
		"mouse",
		"left",
		"held"
	},
	voip_push_to_talk = {}
}
ChatControllerSettings_3[str_5] = keymaps_key_approved_13

local ChatControllerSettings_4 = ChatControllerSettings
local str_6 = "ps_pad"
local keymaps_key_approved_14 = InputUtils.keymaps_key_approved("ps_pad")

keymaps_key_approved_14 = not keymaps_key_approved_14 and {
	activate_chat_input = {
		"keyboard",
		"y",
		"pressed"
	},
	execute_chat_input = {
		"keyboard",
		"enter",
		"pressed"
	},
	deactivate_chat_input = {
		"keyboard",
		"esc",
		"pressed"
	},
	chat_left_alt_held = {
		"keyboard",
		"left alt",
		"held"
	},
	chat_left_alt_pressed = {
		"keyboard",
		"left alt",
		"pressed"
	},
	chat_left_alt_released = {
		"keyboard",
		"left alt",
		"released"
	},
	cursor = {
		"mouse",
		"cursor",
		"axis"
	},
	left_release = {
		"mouse",
		"left",
		"released"
	},
	left_press = {
		"mouse",
		"left",
		"pressed"
	},
	left_hold = {
		"mouse",
		"left",
		"held"
	},
	voip_push_to_talk = {}
}
ChatControllerSettings_4[str_6] = keymaps_key_approved_14
ChatControllerFilters = {}

local ChatControllerFilters = ChatControllerFilters
local keymaps_key_approved_15 = InputUtils.keymaps_key_approved("win32")

keymaps_key_approved_15 = not keymaps_key_approved_15 and {
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
	},
	execute_alt_chat_input = {
		filter_type = "and",
		input_mappings = {
			button_1 = "execute_chat_input_1",
			button_2 = "execute_chat_input_3"
		}
	},
	chat_switch_view = {
		filter_type = "and",
		input_mappings = {
			button_1 = "chat_left_ctrl",
			button_2 = "chat_tab_pressed"
		}
	},
	chat_backspace_word = {
		filter_type = "and",
		input_mappings = {
			button_1 = "chat_left_ctrl",
			button_2 = "chat_backspace_pressed"
		}
	},
	chat_switch_view = {
		filter_type = "and",
		input_mappings = {
			button_1 = "chat_left_ctrl",
			button_2 = "chat_tab_pressed"
		}
	}
}
ChatControllerFilters.win32 = keymaps_key_approved_15

local ChatControllerFilters_2 = ChatControllerFilters
local keymaps_key_approved_16 = InputUtils.keymaps_key_approved("xb1")

keymaps_key_approved_16 = not keymaps_key_approved_16 and {
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
ChatControllerFilters_2.xb1 = keymaps_key_approved_16

local tbl_4 = {
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
local ChatControllerFilters_3 = ChatControllerFilters
local str_7 = "ps4"
local keymaps_key_approved_17 = InputUtils.keymaps_key_approved("ps4")

keymaps_key_approved_17 = not keymaps_key_approved_17 and tbl_4
ChatControllerFilters_3[str_7] = keymaps_key_approved_17

local ChatControllerFilters_4 = ChatControllerFilters
local str_8 = "ps_pad"
local keymaps_key_approved_18 = InputUtils.keymaps_key_approved("ps_pad")

keymaps_key_approved_18 = not keymaps_key_approved_18 and tbl_4
ChatControllerFilters_4[str_8] = keymaps_key_approved_18
RconControllerSettings = {}

local RconControllerSettings = RconControllerSettings
local keymaps_key_approved_19 = InputUtils.keymaps_key_approved("win32")

keymaps_key_approved_19 = not keymaps_key_approved_19 and {
	activate_menu = {
		"keyboard",
		"f2",
		"pressed"
	},
	send_input = {
		"keyboard",
		"enter",
		"pressed"
	},
	deactivate_menu = {
		"keyboard",
		"esc",
		"pressed"
	},
	cursor = {
		"mouse",
		"cursor",
		"axis"
	},
	left_release = {
		"mouse",
		"left",
		"released"
	},
	left_press = {
		"mouse",
		"left",
		"pressed"
	},
	left_hold = {
		"mouse",
		"left",
		"held"
	},
	right_release = {
		"mouse",
		"right",
		"released"
	},
	right_press = {
		"mouse",
		"right",
		"pressed"
	},
	right_hold = {
		"mouse",
		"right",
		"held"
	}
}
RconControllerSettings.win32 = keymaps_key_approved_19

local RconControllerSettings_2 = RconControllerSettings
local keymaps_key_approved_20 = InputUtils.keymaps_key_approved("xb1")

keymaps_key_approved_20 = not keymaps_key_approved_20 and {
	activate_menu = {
		"keyboard",
		"f2",
		"pressed"
	},
	send_input = {
		"keyboard",
		"enter",
		"pressed"
	},
	deactivate_menu = {
		"keyboard",
		"esc",
		"pressed"
	},
	cursor = {
		"mouse",
		"cursor",
		"axis"
	},
	left_release = {
		"mouse",
		"left",
		"released"
	},
	left_press = {
		"mouse",
		"left",
		"pressed"
	},
	left_hold = {
		"mouse",
		"left",
		"held"
	},
	right_release = {
		"mouse",
		"right",
		"released"
	},
	right_press = {
		"mouse",
		"right",
		"pressed"
	},
	right_hold = {
		"mouse",
		"right",
		"held"
	}
}
RconControllerSettings_2.xb1 = keymaps_key_approved_20
RconControllerFilters = {}
FreeFlightKeymaps = {}

local FreeFlightKeymaps = FreeFlightKeymaps
local keymaps_key_approved_21 = InputUtils.keymaps_key_approved("win32")

keymaps_key_approved_21 = not keymaps_key_approved_21 and {
	quit_game = {
		"keyboard",
		"esc",
		"pressed"
	},
	projection_mode = {
		"keyboard",
		"f7",
		"pressed"
	},
	free_flight_toggle = {
		"keyboard",
		"f8",
		"pressed"
	},
	global_free_flight_toggle = {
		"keyboard",
		"f9",
		"pressed"
	},
	frustum_freeze_toggle = {
		"keyboard",
		"right shift",
		"pressed"
	},
	player_controls_toggle = {
		"keyboard",
		"f10",
		"pressed"
	},
	set_drop_position = {
		"keyboard",
		"enter",
		"pressed"
	},
	increase_fov = {
		"keyboard",
		"numpad +",
		"pressed"
	},
	decrease_fov = {
		"keyboard",
		"num -",
		"pressed"
	},
	toggle_debug_info = {
		"keyboard",
		"f12",
		"pressed"
	},
	move_forward = {
		"keyboard",
		"w",
		"soft_button"
	},
	move_right = {
		"keyboard",
		"d",
		"soft_button"
	},
	move_left = {
		"keyboard",
		"a",
		"soft_button"
	},
	move_back = {
		"keyboard",
		"s",
		"soft_button"
	},
	move_down = {
		"keyboard",
		"q",
		"soft_button"
	},
	move_up = {
		"keyboard",
		"e",
		"soft_button"
	},
	mark = {
		"keyboard",
		"c",
		"pressed"
	},
	toggle_control_points = {
		"keyboard",
		"y",
		"pressed"
	},
	step_frame_1 = {
		"keyboard",
		"left shift",
		"held"
	},
	step_frame_2 = {
		"keyboard",
		"up",
		"pressed"
	},
	play_pause_1 = {
		"keyboard",
		"left shift",
		"held"
	},
	play_pause_2 = {
		"keyboard",
		"down",
		"pressed"
	},
	increase_frame_step_1 = {
		"keyboard",
		"left shift",
		"held"
	},
	increase_frame_step_2 = {
		"keyboard",
		"right",
		"pressed"
	},
	decrease_frame_step_1 = {
		"keyboard",
		"left shift",
		"held"
	},
	decrease_frame_step_2 = {
		"keyboard",
		"left",
		"pressed"
	},
	reset_toggle_mod = {
		"keyboard",
		"left ctrl",
		"held"
	},
	toggle_dof = {
		"keyboard",
		"f",
		"pressed"
	},
	inc_dof_distance = {
		"keyboard",
		"g",
		"held"
	},
	dec_dof_distance = {
		"keyboard",
		"b",
		"held"
	},
	inc_dof_region = {
		"keyboard",
		"h",
		"held"
	},
	dec_dof_region = {
		"keyboard",
		"n",
		"held"
	},
	inc_dof_padding = {
		"keyboard",
		"j",
		"held"
	},
	dec_dof_padding = {
		"keyboard",
		"m",
		"held"
	},
	inc_dof_scale = {
		"keyboard",
		"k",
		"held"
	},
	dec_dof_scale = {
		"keyboard",
		"oem_comma (< ,)",
		"held"
	},
	look = {
		"mouse",
		"mouse",
		"axis"
	},
	speed_change = {
		"mouse",
		"wheel",
		"axis"
	},
	ray = {
		"mouse",
		"left",
		"pressed"
	},
	toggle_mouse_focus = {
		"mouse",
		"right",
		"pressed"
	},
	cursor = {
		"mouse",
		"cursor",
		"axis"
	},
	action_one = {
		"mouse",
		"left",
		"pressed"
	},
	action_two = {
		"mouse",
		"right",
		"pressed"
	},
	k = {
		"keyboard",
		"k",
		"pressed"
	},
	l = {
		"keyboard",
		"l",
		"pressed"
	},
	x = {
		"keyboard",
		"x",
		"pressed"
	},
	m = {
		"keyboard",
		"m",
		"pressed"
	},
	comma = {
		"keyboard",
		"oem_comma (< ,)",
		"pressed"
	},
	period = {
		"keyboard",
		"oem_period (> .)",
		"pressed"
	},
	left_ctrl = {
		"keyboard",
		"left ctrl",
		"pressed"
	},
	keyboard_1 = {
		"keyboard",
		"1",
		"pressed"
	},
	keyboard_2 = {
		"keyboard",
		"2",
		"pressed"
	},
	keyboard_3 = {
		"keyboard",
		"3",
		"pressed"
	},
	keyboard_4 = {
		"keyboard",
		"4",
		"pressed"
	},
	keyboard_5 = {
		"keyboard",
		"5",
		"pressed"
	},
	keyboard_6 = {
		"keyboard",
		"6",
		"pressed"
	},
	keyboard_7 = {
		"keyboard",
		"7",
		"pressed"
	},
	keyboard_8 = {
		"keyboard",
		"8",
		"pressed"
	},
	keyboard_9 = {
		"keyboard",
		"9",
		"pressed"
	},
	keyboard_0 = {
		"keyboard",
		"0",
		"pressed"
	}
}
FreeFlightKeymaps.win32 = keymaps_key_approved_21

local FreeFlightKeymaps_2 = FreeFlightKeymaps
local keymaps_key_approved_22 = InputUtils.keymaps_key_approved("xb1")

keymaps_key_approved_22 = not keymaps_key_approved_22 and {
	quit_game = {
		"keyboard",
		"esc",
		"pressed"
	},
	projection_mode = {
		"keyboard",
		"f7",
		"pressed"
	},
	frustum_freeze_toggle = {
		"gamepad",
		"x",
		"pressed"
	},
	set_drop_position = {
		"gamepad",
		"a",
		"pressed"
	},
	increase_fov = {
		"keyboard",
		"numpad +",
		"pressed"
	},
	decrease_fov = {
		"keyboard",
		"num -",
		"pressed"
	},
	toggle_debug_info = {
		"keyboard",
		"f12",
		"pressed"
	},
	move_forward = {
		"keyboard",
		"w",
		"soft_button"
	},
	move_right = {
		"keyboard",
		"d",
		"soft_button"
	},
	move_left = {
		"keyboard",
		"a",
		"soft_button"
	},
	move_back = {
		"keyboard",
		"s",
		"soft_button"
	},
	move_down = {
		"keyboard",
		"q",
		"soft_button"
	},
	move_up = {
		"keyboard",
		"e",
		"soft_button"
	},
	move = {
		"gamepad",
		"left",
		"axis"
	},
	mark = {
		"keyboard",
		"c",
		"pressed"
	},
	toggle_control_points = {
		"keyboard",
		"t",
		"pressed"
	},
	step_frame = {
		"keyboard",
		"up",
		"pressed"
	},
	play_pause = {
		"keyboard",
		"down",
		"pressed"
	},
	increase_frame_step = {
		"keyboard",
		"right",
		"pressed"
	},
	decrease_frame_step = {
		"keyboard",
		"left",
		"pressed"
	},
	left_shoulder_held = {
		"gamepad",
		"left_shoulder",
		"held"
	},
	right_shoulder = {
		"gamepad",
		"right_shoulder",
		"pressed"
	},
	right_thumb_held = {
		"gamepad",
		"right_thumb",
		"held"
	},
	left_thumb_held = {
		"gamepad",
		"left_thumb",
		"held"
	},
	right_trigger = {
		"gamepad",
		"right_trigger",
		"held"
	},
	right_trigger_held = {
		"gamepad",
		"right_trigger",
		"held"
	},
	left_trigger_held = {
		"gamepad",
		"left_trigger",
		"held"
	},
	look_raw_controller = {
		"gamepad",
		"right",
		"axis"
	},
	speed_change = {
		"mouse",
		"wheel",
		"axis"
	},
	ray = {
		"mouse",
		"left",
		"pressed"
	},
	toggle_mouse_focus = {
		"mouse",
		"right",
		"pressed"
	},
	cursor = {
		"mouse",
		"cursor",
		"axis"
	},
	action_one = {
		"mouse",
		"left",
		"pressed"
	},
	action_two = {
		"mouse",
		"right",
		"pressed"
	},
	gamepad_x_pressed = {
		"gamepad",
		"x",
		"pressed"
	},
	gamepad_y_pressed = {
		"gamepad",
		"y",
		"pressed"
	},
	gamepad_b_pressed = {
		"gamepad",
		"b",
		"pressed"
	},
	gamepad_a_pressed = {
		"gamepad",
		"a",
		"pressed"
	},
	gamepad_x_held = {
		"gamepad",
		"x",
		"held"
	},
	gamepad_y_held = {
		"gamepad",
		"y",
		"held"
	},
	gamepad_b_held = {
		"gamepad",
		"b",
		"held"
	},
	gamepad_a_held = {
		"gamepad",
		"a",
		"held"
	},
	reset_toggle_mod = {
		"keyboard",
		"left ctrl",
		"held"
	},
	toggle_dof = {
		"gamepad",
		"right_shoulder",
		"pressed"
	},
	inc_dof_distance = {
		"gamepad",
		"right_trigger",
		"held"
	},
	dec_dof_distance = {
		"gamepad",
		"left_trigger",
		"held"
	},
	k = {
		"keyboard",
		"k",
		"pressed"
	},
	l = {
		"keyboard",
		"l",
		"pressed"
	},
	x = {
		"keyboard",
		"x",
		"pressed"
	},
	m = {
		"keyboard",
		"m",
		"pressed"
	},
	comma = {
		"keyboard",
		"oem_comma (< ,)",
		"pressed"
	},
	period = {
		"keyboard",
		"oem_period (> .)",
		"pressed"
	},
	left_ctrl = {
		"keyboard",
		"left ctrl",
		"pressed"
	}
}
FreeFlightKeymaps_2.xb1 = keymaps_key_approved_22

local FreeFlightKeymaps_3 = FreeFlightKeymaps
local str_9 = "ps4"
local keymaps_key_approved_23 = InputUtils.keymaps_key_approved("ps4")

keymaps_key_approved_23 = not keymaps_key_approved_23 and {
	quit_game = {
		"keyboard",
		"esc",
		"pressed"
	},
	projection_mode = {
		"keyboard",
		"f7",
		"pressed"
	},
	frustum_freeze_toggle = {
		"gamepad",
		"square",
		"pressed"
	},
	set_drop_position = {
		"gamepad",
		"cross",
		"pressed"
	},
	increase_fov = {
		"keyboard",
		"numpad +",
		"pressed"
	},
	decrease_fov = {
		"keyboard",
		"num -",
		"pressed"
	},
	toggle_debug_info = {
		"keyboard",
		"f12",
		"pressed"
	},
	move_forward = {
		"keyboard",
		"w",
		"soft_button"
	},
	move_right = {
		"keyboard",
		"d",
		"soft_button"
	},
	move_left = {
		"keyboard",
		"a",
		"soft_button"
	},
	move_back = {
		"keyboard",
		"s",
		"soft_button"
	},
	move_down = {
		"keyboard",
		"q",
		"soft_button"
	},
	move_up = {
		"keyboard",
		"e",
		"soft_button"
	},
	move = {
		"gamepad",
		"left",
		"axis"
	},
	mark = {
		"keyboard",
		"c",
		"pressed"
	},
	toggle_control_points = {
		"keyboard",
		"t",
		"pressed"
	},
	step_frame = {
		"keyboard",
		"up",
		"pressed"
	},
	play_pause = {
		"keyboard",
		"down",
		"pressed"
	},
	increase_frame_step = {
		"keyboard",
		"right",
		"pressed"
	},
	decrease_frame_step = {
		"keyboard",
		"left",
		"pressed"
	},
	left_shoulder = {
		"gamepad",
		"l1",
		"pressed"
	},
	left_shoulder_held = {
		"gamepad",
		"l1",
		"held"
	},
	right_shoulder = {
		"gamepad",
		"r1",
		"pressed"
	},
	right_shoulder_held = {
		"gamepad",
		"r1",
		"held"
	},
	left_trigger = {
		"gamepad",
		"l2",
		"pressed"
	},
	left_trigger_held = {
		"gamepad",
		"l2",
		"held"
	},
	right_trigger = {
		"gamepad",
		"r2",
		"pressed"
	},
	right_trigger_held = {
		"gamepad",
		"r2",
		"held"
	},
	right_thumb = {
		"gamepad",
		"r3",
		"pressed"
	},
	right_thumb_held = {
		"gamepad",
		"r3",
		"held"
	},
	left_thumb = {
		"gamepad",
		"l3",
		"pressed"
	},
	left_thumb_held = {
		"gamepad",
		"l3",
		"held"
	},
	gamepad_cross_pressed = {
		"gamepad",
		"cross",
		"pressed"
	},
	gamepad_cross_held = {
		"gamepad",
		"cross",
		"held"
	},
	gamepad_square_pressed = {
		"gamepad",
		"square",
		"pressed"
	},
	gamepad_square_held = {
		"gamepad",
		"square",
		"held"
	},
	gamepad_triangle_pressed = {
		"gamepad",
		"triangle",
		"pressed"
	},
	gamepad_triangle_held = {
		"gamepad",
		"triangle",
		"held"
	},
	gamepad_circle_pressed = {
		"gamepad",
		"circle",
		"pressed"
	},
	gamepad_circle_held = {
		"gamepad",
		"circle",
		"held"
	},
	gamepad_left_stick = {
		"gamepad",
		"left",
		"axis"
	},
	gamepad_right_stick = {
		"gamepad",
		"right",
		"axis"
	},
	look_raw_controller = {
		"gamepad",
		"right",
		"axis"
	},
	speed_change = {
		"mouse",
		"wheel",
		"axis"
	},
	ray = {
		"mouse",
		"left",
		"pressed"
	},
	toggle_mouse_focus = {
		"mouse",
		"right",
		"pressed"
	},
	cursor = {
		"mouse",
		"cursor",
		"axis"
	},
	action_one = {
		"mouse",
		"left",
		"pressed"
	},
	action_two = {
		"mouse",
		"right",
		"pressed"
	},
	reset_toggle_mod = {
		"keyboard",
		"left ctrl",
		"held"
	},
	toggle_dof = {
		"gamepad",
		"right_shoulder",
		"pressed"
	},
	inc_dof_distance = {
		"gamepad",
		"right_trigger",
		"held"
	},
	dec_dof_distance = {
		"gamepad",
		"left_trigger",
		"held"
	},
	k = {
		"keyboard",
		"k",
		"pressed"
	},
	l = {
		"keyboard",
		"l",
		"pressed"
	},
	x = {
		"keyboard",
		"x",
		"pressed"
	},
	m = {
		"keyboard",
		"m",
		"pressed"
	},
	comma = {
		"keyboard",
		"oem_comma (< ,)",
		"pressed"
	},
	period = {
		"keyboard",
		"oem_period (> .)",
		"pressed"
	},
	left_ctrl = {
		"keyboard",
		"left ctrl",
		"pressed"
	}
}
FreeFlightKeymaps_3[str_9] = keymaps_key_approved_23

local FreeFlightKeymaps_4 = FreeFlightKeymaps
local str_10 = "ps_pad"
local keymaps_key_approved_24 = InputUtils.keymaps_key_approved("ps_pad")

keymaps_key_approved_24 = not keymaps_key_approved_24 and {
	quit_game = {
		"keyboard",
		"esc",
		"pressed"
	},
	projection_mode = {
		"keyboard",
		"f7",
		"pressed"
	},
	frustum_freeze_toggle = {
		"ps_pad",
		"square",
		"pressed"
	},
	set_drop_position = {
		"ps_pad",
		"cross",
		"pressed"
	},
	increase_fov = {
		"keyboard",
		"numpad +",
		"pressed"
	},
	decrease_fov = {
		"keyboard",
		"num -",
		"pressed"
	},
	toggle_debug_info = {
		"keyboard",
		"f12",
		"pressed"
	},
	move_forward = {
		"keyboard",
		"w",
		"soft_button"
	},
	move_right = {
		"keyboard",
		"d",
		"soft_button"
	},
	move_left = {
		"keyboard",
		"a",
		"soft_button"
	},
	move_back = {
		"keyboard",
		"s",
		"soft_button"
	},
	move_down = {
		"keyboard",
		"q",
		"soft_button"
	},
	move_up = {
		"keyboard",
		"e",
		"soft_button"
	},
	move = {
		"ps_pad",
		"left",
		"axis"
	},
	mark = {
		"keyboard",
		"c",
		"pressed"
	},
	toggle_control_points = {
		"keyboard",
		"t",
		"pressed"
	},
	step_frame = {
		"keyboard",
		"up",
		"pressed"
	},
	play_pause = {
		"keyboard",
		"down",
		"pressed"
	},
	increase_frame_step = {
		"keyboard",
		"right",
		"pressed"
	},
	decrease_frame_step = {
		"keyboard",
		"left",
		"pressed"
	},
	left_shoulder = {
		"ps_pad",
		"l1",
		"pressed"
	},
	left_shoulder_held = {
		"ps_pad",
		"l1",
		"held"
	},
	right_shoulder = {
		"ps_pad",
		"r1",
		"pressed"
	},
	right_shoulder_held = {
		"ps_pad",
		"r1",
		"held"
	},
	left_trigger = {
		"ps_pad",
		"l2",
		"pressed"
	},
	left_trigger_held = {
		"ps_pad",
		"l2",
		"held"
	},
	right_trigger = {
		"ps_pad",
		"r2",
		"pressed"
	},
	right_trigger_held = {
		"ps_pad",
		"r2",
		"held"
	},
	right_thumb = {
		"ps_pad",
		"r3",
		"pressed"
	},
	right_thumb_held = {
		"ps_pad",
		"r3",
		"held"
	},
	left_thumb = {
		"ps_pad",
		"l3",
		"pressed"
	},
	left_thumb_held = {
		"ps_pad",
		"l3",
		"held"
	},
	gamepad_cross_pressed = {
		"ps_pad",
		"cross",
		"pressed"
	},
	gamepad_cross_held = {
		"ps_pad",
		"cross",
		"held"
	},
	gamepad_square_pressed = {
		"ps_pad",
		"square",
		"pressed"
	},
	gamepad_square_held = {
		"ps_pad",
		"square",
		"held"
	},
	gamepad_triangle_pressed = {
		"ps_pad",
		"triangle",
		"pressed"
	},
	gamepad_triangle_held = {
		"ps_pad",
		"triangle",
		"held"
	},
	gamepad_circle_pressed = {
		"ps_pad",
		"circle",
		"pressed"
	},
	gamepad_circle_held = {
		"ps_pad",
		"circle",
		"held"
	},
	gamepad_left_stick = {
		"ps_pad",
		"left",
		"axis"
	},
	gamepad_right_stick = {
		"ps_pad",
		"right",
		"axis"
	},
	look_raw_controller = {
		"ps_pad",
		"right",
		"axis"
	},
	speed_change = {
		"mouse",
		"wheel",
		"axis"
	},
	ray = {
		"mouse",
		"left",
		"pressed"
	},
	toggle_mouse_focus = {
		"mouse",
		"right",
		"pressed"
	},
	cursor = {
		"mouse",
		"cursor",
		"axis"
	},
	action_one = {
		"mouse",
		"left",
		"pressed"
	},
	action_two = {
		"mouse",
		"right",
		"pressed"
	},
	reset_toggle_mod = {
		"keyboard",
		"left ctrl",
		"held"
	},
	toggle_dof = {
		"ps_pad",
		"r1",
		"pressed"
	},
	inc_dof_distance = {
		"ps_pad",
		"r2",
		"held"
	},
	dec_dof_distance = {
		"ps_pad",
		"l2",
		"held"
	},
	k = {
		"keyboard",
		"k",
		"pressed"
	},
	l = {
		"keyboard",
		"l",
		"pressed"
	},
	x = {
		"keyboard",
		"x",
		"pressed"
	},
	m = {
		"keyboard",
		"m",
		"pressed"
	},
	comma = {
		"keyboard",
		"oem_comma (< ,)",
		"pressed"
	},
	period = {
		"keyboard",
		"oem_period (> .)",
		"pressed"
	},
	left_ctrl = {
		"keyboard",
		"left ctrl",
		"pressed"
	}
}
FreeFlightKeymaps_4[str_10] = keymaps_key_approved_24
FreeFlightFilters = {}

local FreeFlightFilters = FreeFlightFilters
local keymaps_key_approved_25 = InputUtils.keymaps_key_approved("win32")

keymaps_key_approved_25 = not keymaps_key_approved_25 and {
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
	step_frame = {
		filter_type = "and",
		input_mappings = {
			button_1 = "step_frame_1",
			button_2 = "step_frame_2"
		}
	},
	play_pause = {
		filter_type = "and",
		input_mappings = {
			button_1 = "play_pause_1",
			button_2 = "play_pause_2"
		}
	},
	increase_frame_step = {
		filter_type = "and",
		input_mappings = {
			button_1 = "increase_frame_step_1",
			button_2 = "increase_frame_step_2"
		}
	},
	decrease_frame_step = {
		filter_type = "and",
		input_mappings = {
			button_1 = "decrease_frame_step_1",
			button_2 = "decrease_frame_step_2"
		}
	}
}
FreeFlightFilters.win32 = keymaps_key_approved_25

local FreeFlightFilters_2 = FreeFlightFilters
local keymaps_key_approved_26 = InputUtils.keymaps_key_approved("xb1")

keymaps_key_approved_26 = not keymaps_key_approved_26 and {
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
			button_2 = "gamepad_y_held"
		}
	},
	dec_dof_region = {
		filter_type = "and",
		input_mappings = {
			button_1 = "left_trigger_held",
			button_2 = "gamepad_y_held"
		}
	},
	inc_dof_padding = {
		filter_type = "and",
		input_mappings = {
			button_1 = "right_trigger_held",
			button_2 = "gamepad_b_held"
		}
	},
	dec_dof_padding = {
		filter_type = "and",
		input_mappings = {
			button_1 = "left_trigger_held",
			button_2 = "gamepad_b_held"
		}
	},
	inc_dof_scale = {
		filter_type = "and",
		input_mappings = {
			button_1 = "right_trigger_held",
			button_2 = "gamepad_x_held"
		}
	},
	dec_dof_scale = {
		filter_type = "and",
		input_mappings = {
			button_1 = "left_trigger_held",
			button_2 = "gamepad_x_held"
		}
	},
	free_flight_toggle = {
		filter_type = "and",
		name = "free_flight_toggle",
		input_mappings = {
			button_2 = "left_thumb_held",
			button_3 = "left_shoulder_held",
			button_1 = "right_thumb_held",
			button_4 = "right_shoulder"
		}
	},
	global_free_flight_toggle = {
		filter_type = "and",
		name = "global_free_flight_toggle",
		input_mappings = {
			button_1 = "left_thumb_held",
			button_2 = "gamepad_a_pressed"
		}
	}
}
FreeFlightFilters_2.xb1 = keymaps_key_approved_26

local tbl_5 = {
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
local FreeFlightFilters_3 = FreeFlightFilters
local str_11 = "ps4"
local keymaps_key_approved_27 = InputUtils.keymaps_key_approved("ps4")

keymaps_key_approved_27 = not keymaps_key_approved_27 and tbl_5
FreeFlightFilters_3[str_11] = keymaps_key_approved_27

local FreeFlightFilters_4 = FreeFlightFilters
local str_12 = "ps_pad"
local keymaps_key_approved_28 = InputUtils.keymaps_key_approved("ps_pad")

keymaps_key_approved_28 = not keymaps_key_approved_28 and tbl_5
FreeFlightFilters_4[str_12] = keymaps_key_approved_28
SplashScreenKeymaps = {}

local SplashScreenKeymaps = SplashScreenKeymaps
local keymaps_key_approved_29 = InputUtils.keymaps_key_approved("win32")

keymaps_key_approved_29 = not keymaps_key_approved_29 and {
	skip_splash_1 = {
		"keyboard",
		"enter",
		"pressed"
	},
	skip_splash_2 = {
		"keyboard",
		"space",
		"pressed"
	},
	skip_splash_3 = {
		"keyboard",
		"esc",
		"pressed"
	},
	skip_splash_4 = {
		"gamepad",
		"a",
		"pressed"
	},
	skip_splash_5 = {
		"mouse",
		"left",
		"pressed"
	},
	skip_splash_6 = {
		"mouse",
		"right",
		"pressed"
	}
}
SplashScreenKeymaps.win32 = keymaps_key_approved_29

local SplashScreenKeymaps_2 = SplashScreenKeymaps
local keymaps_key_approved_30 = InputUtils.keymaps_key_approved("xb1")

keymaps_key_approved_30 = not keymaps_key_approved_30 and {
	skip_splash = {
		"gamepad",
		"a",
		"pressed"
	}
}
SplashScreenKeymaps_2.xb1 = keymaps_key_approved_30

local SplashScreenKeymaps_3 = SplashScreenKeymaps
local str_13 = "ps4"
local keymaps_key_approved_31 = InputUtils.keymaps_key_approved("ps4")

keymaps_key_approved_31 = not keymaps_key_approved_31 and {
	skip_splash = {
		"gamepad",
		"cross",
		"pressed"
	}
}
SplashScreenKeymaps_3[str_13] = keymaps_key_approved_31

local SplashScreenKeymaps_4 = SplashScreenKeymaps
local str_14 = "ps_pad"
local keymaps_key_approved_32 = InputUtils.keymaps_key_approved("ps_pad")

keymaps_key_approved_32 = not keymaps_key_approved_32 and {
	skip_splash = {
		"ps_pad",
		"cross",
		"pressed"
	}
}
SplashScreenKeymaps_4[str_14] = keymaps_key_approved_32
SplashScreenFilters = {}

local SplashScreenFilters = SplashScreenFilters
local keymaps_key_approved_33 = InputUtils.keymaps_key_approved("win32")

keymaps_key_approved_33 = not keymaps_key_approved_33 and {
	skip_splash = {
		filter_type = "or",
		input_mappings = {
			button_4 = "skip_splash_4",
			button_5 = "skip_splash_5",
			button_3 = "skip_splash_3",
			button_6 = "skip_splash_6",
			button_2 = "skip_splash_2",
			button_1 = "skip_splash_1"
		}
	}
}
SplashScreenFilters.win32 = keymaps_key_approved_33

local SplashScreenFilters_2 = SplashScreenFilters
local keymaps_key_approved_34 = InputUtils.keymaps_key_approved("xb1")

keymaps_key_approved_34 = not keymaps_key_approved_34 and {}
SplashScreenFilters_2.xb1 = keymaps_key_approved_34

local SplashScreenFilters_3 = SplashScreenFilters
local str_15 = "ps4"
local keymaps_key_approved_35 = InputUtils.keymaps_key_approved("ps4")

keymaps_key_approved_35 = not keymaps_key_approved_35 and {}
SplashScreenFilters_3[str_15] = keymaps_key_approved_35

local SplashScreenFilters_4 = SplashScreenFilters
local str_16 = "ps_pad"
local keymaps_key_approved_36 = InputUtils.keymaps_key_approved("ps_pad")

keymaps_key_approved_36 = not keymaps_key_approved_36 and {}
SplashScreenFilters_4[str_16] = keymaps_key_approved_36
TitleLoadingKeyMaps = {}

local TitleLoadingKeyMaps = TitleLoadingKeyMaps
local keymaps_key_approved_37 = InputUtils.keymaps_key_approved("win32")

keymaps_key_approved_37 = not keymaps_key_approved_37 and {
	cancel_video_1 = {
		"keyboard",
		"space",
		"pressed"
	},
	cancel_video_2 = {
		"keyboard",
		"esc",
		"pressed"
	},
	cancel_video_3 = {
		"gamepad",
		"a",
		"pressed"
	},
	cursor = {
		"mouse",
		"cursor",
		"axis"
	},
	left_release = {
		"mouse",
		"left",
		"released"
	},
	left_press = {
		"mouse",
		"left",
		"pressed"
	},
	left_hold = {
		"mouse",
		"left",
		"held"
	},
	confirm = {
		"gamepad",
		"a",
		"released"
	},
	move_left = {
		"gamepad",
		"d_left",
		"pressed"
	},
	move_right = {
		"gamepad",
		"d_right",
		"pressed"
	},
	move_left_hold = {
		"gamepad",
		"d_left",
		"held"
	},
	move_right_hold = {
		"gamepad",
		"d_right",
		"held"
	},
	analog_input = {
		"gamepad",
		"left",
		"axis"
	}
}
TitleLoadingKeyMaps.win32 = keymaps_key_approved_37

local TitleLoadingKeyMaps_2 = TitleLoadingKeyMaps
local keymaps_key_approved_38 = InputUtils.keymaps_key_approved("xb1")

keymaps_key_approved_38 = not keymaps_key_approved_38 and {
	cancel_video_1 = {
		"gamepad",
		"a",
		"pressed"
	},
	confirm = {
		"gamepad",
		"a",
		"released"
	},
	move_left = {
		"gamepad",
		"d_left",
		"pressed"
	},
	move_right = {
		"gamepad",
		"d_right",
		"pressed"
	},
	move_left_hold = {
		"gamepad",
		"d_left",
		"held"
	},
	move_right_hold = {
		"gamepad",
		"d_right",
		"held"
	},
	analog_input = {
		"gamepad",
		"left",
		"axis"
	}
}
TitleLoadingKeyMaps_2.xb1 = keymaps_key_approved_38

local TitleLoadingKeyMaps_3 = TitleLoadingKeyMaps
local str_17 = "ps4"
local keymaps_key_approved_39 = InputUtils.keymaps_key_approved("ps4")

keymaps_key_approved_39 = not keymaps_key_approved_39 and {
	cancel_video_1 = {
		"gamepad",
		"cross",
		"pressed"
	},
	confirm = {
		"gamepad",
		"cross",
		"released"
	},
	move_left = {
		"gamepad",
		"left",
		"pressed"
	},
	move_right = {
		"gamepad",
		"right",
		"pressed"
	},
	move_left_hold = {
		"gamepad",
		"left",
		"held"
	},
	move_right_hold = {
		"gamepad",
		"right",
		"held"
	},
	analog_input = {
		"gamepad",
		"left",
		"axis"
	}
}
TitleLoadingKeyMaps_3[str_17] = keymaps_key_approved_39

local TitleLoadingKeyMaps_4 = TitleLoadingKeyMaps
local str_18 = "ps_pad"
local keymaps_key_approved_40 = InputUtils.keymaps_key_approved("ps_pad")

keymaps_key_approved_40 = not keymaps_key_approved_40 and {
	cancel_video_1 = {
		"ps_pad",
		"cross",
		"pressed"
	},
	confirm = {
		"ps_pad",
		"cross",
		"released"
	},
	move_left = {
		"ps_pad",
		"left",
		"pressed"
	},
	move_right = {
		"ps_pad",
		"right",
		"pressed"
	},
	move_left_hold = {
		"ps_pad",
		"left",
		"held"
	},
	move_right_hold = {
		"ps_pad",
		"right",
		"held"
	},
	analog_input = {
		"ps_pad",
		"left",
		"axis"
	}
}
TitleLoadingKeyMaps_4[str_18] = keymaps_key_approved_40
TitleLoadingFilters = {}

local TitleLoadingFilters = TitleLoadingFilters
local keymaps_key_approved_41 = InputUtils.keymaps_key_approved("win32")

keymaps_key_approved_41 = not keymaps_key_approved_41 and {
	cancel_video = {
		filter_type = "or",
		input_mappings = {
			button_2 = "cancel_video_2",
			button_3 = "cancel_video_3",
			button_1 = "cancel_video_1"
		}
	}
}
TitleLoadingFilters.win32 = keymaps_key_approved_41

local TitleLoadingFilters_2 = TitleLoadingFilters
local keymaps_key_approved_42 = InputUtils.keymaps_key_approved("xb1")

keymaps_key_approved_42 = not keymaps_key_approved_42 and {
	cancel_video = {
		filter_type = "or",
		input_mappings = {
			button_1 = "cancel_video_1"
		}
	}
}
TitleLoadingFilters_2.xb1 = keymaps_key_approved_42

local tbl_6 = {
	cancel_video = {
		filter_type = "or",
		input_mappings = {
			button_1 = "cancel_video_1"
		}
	}
}
local TitleLoadingFilters_3 = TitleLoadingFilters
local str_19 = "ps4"
local keymaps_key_approved_43 = InputUtils.keymaps_key_approved("ps4")

keymaps_key_approved_43 = not keymaps_key_approved_43 and tbl_6
TitleLoadingFilters_3[str_19] = keymaps_key_approved_43

local TitleLoadingFilters_4 = TitleLoadingFilters
local str_20 = "ps_pad"
local keymaps_key_approved_44 = InputUtils.keymaps_key_approved("ps_pad")

keymaps_key_approved_44 = not keymaps_key_approved_44 and tbl_6
TitleLoadingFilters_4[str_20] = keymaps_key_approved_44
TitleScreenKeyMaps = {}

local TitleScreenKeyMaps = TitleScreenKeyMaps
local keymaps_key_approved_45 = InputUtils.keymaps_key_approved("win32")

keymaps_key_approved_45 = not keymaps_key_approved_45 and {
	move_up_raw = {
		"keyboard",
		"up",
		"pressed"
	},
	move_down_raw = {
		"keyboard",
		"down",
		"pressed"
	},
	move_left_raw = {
		"keyboard",
		"left",
		"pressed"
	},
	move_right_raw = {
		"keyboard",
		"right",
		"pressed"
	},
	analog_input = {},
	move_up_alt_raw = {
		"keyboard",
		"w",
		"pressed"
	},
	move_down_alt_raw = {
		"keyboard",
		"s",
		"pressed"
	},
	move_left_alt_raw = {
		"keyboard",
		"a",
		"pressed"
	},
	move_right_alt_raw = {
		"keyboard",
		"d",
		"pressed"
	},
	cursor = {
		"mouse",
		"cursor",
		"axis"
	},
	left_press = {
		"mouse",
		"left",
		"pressed"
	},
	left_hold = {
		"mouse",
		"left",
		"held"
	},
	left_release = {
		"mouse",
		"left",
		"released"
	},
	back_1 = {
		"gamepad",
		"b",
		"pressed"
	},
	back_2 = {
		"keyboard",
		"esc",
		"pressed"
	},
	confirm_press = {},
	start_1 = {
		"keyboard",
		"enter",
		"pressed"
	},
	start_2 = {
		"keyboard",
		"space",
		"pressed"
	},
	start_3 = {
		"mouse",
		"left",
		"pressed"
	},
	start_4 = {
		"mouse",
		"right",
		"pressed"
	},
	start_5 = {
		"mouse",
		"extra_1",
		"pressed"
	},
	show_support_info_1 = {
		"keyboard",
		"left shift",
		"held"
	},
	show_support_info_2 = {
		"keyboard",
		"f12",
		"held"
	},
	previous = {},
	next = {},
	scroll_axis = {
		"mouse",
		"wheel",
		"axis"
	}
}
TitleScreenKeyMaps.win32 = keymaps_key_approved_45

local TitleScreenKeyMaps_2 = TitleScreenKeyMaps
local keymaps_key_approved_46 = InputUtils.keymaps_key_approved("xb1")

keymaps_key_approved_46 = not keymaps_key_approved_46 and {
	move_left_raw = {
		"gamepad",
		"d_left",
		"pressed"
	},
	move_right_raw = {
		"gamepad",
		"d_right",
		"pressed"
	},
	move_up_raw = {
		"gamepad",
		"d_up",
		"pressed"
	},
	move_down_raw = {
		"gamepad",
		"d_down",
		"pressed"
	},
	analog_input = {
		"gamepad",
		"left",
		"axis"
	},
	axis_cursor = {
		"gamepad",
		"left",
		"axis"
	},
	left_press = {
		"gamepad",
		"a",
		"pressed"
	},
	left_hold = {
		"gamepad",
		"a",
		"held"
	},
	left_release = {
		"gamepad",
		"a",
		"released"
	},
	confirm_press = {
		"gamepad",
		"a",
		"pressed"
	},
	special_1_press = {
		"gamepad",
		"x",
		"pressed"
	},
	start_1 = {
		"gamepad",
		"a",
		"pressed"
	},
	back_1 = {
		"gamepad",
		"b",
		"pressed"
	},
	delete_save = {
		"gamepad",
		"back",
		"pressed"
	},
	show_support_info_1 = {
		"gamepad",
		"left_shoulder",
		"held"
	},
	show_support_info_2 = {
		"gamepad",
		"right_shoulder",
		"held"
	},
	previous = {
		"gamepad",
		"left_shoulder",
		"pressed"
	},
	next = {
		"gamepad",
		"right_shoulder",
		"pressed"
	},
	scroll_axis = {
		"gamepad",
		"right",
		"axis"
	},
	gamepad_right_axis = {
		"gamepad",
		"right",
		"axis"
	},
	start_press = {
		"gamepad",
		"start",
		"pressed"
	}
}
TitleScreenKeyMaps_2.xb1 = keymaps_key_approved_46

local TitleScreenKeyMaps_3 = TitleScreenKeyMaps
local str_21 = "ps4"
local keymaps_key_approved_47 = InputUtils.keymaps_key_approved("ps4")

keymaps_key_approved_47 = not keymaps_key_approved_47 and {
	move_left_raw = {
		"gamepad",
		"left",
		"pressed"
	},
	move_right_raw = {
		"gamepad",
		"right",
		"pressed"
	},
	move_up_raw = {
		"gamepad",
		"up",
		"pressed"
	},
	move_down_raw = {
		"gamepad",
		"down",
		"pressed"
	},
	analog_input = {
		"gamepad",
		"left",
		"axis"
	},
	axis_cursor = {
		"gamepad",
		"left",
		"axis"
	},
	left_press = {
		"gamepad",
		"cross",
		"pressed"
	},
	left_hold = {
		"gamepad",
		"cross",
		"held"
	},
	left_release = {
		"gamepad",
		"cross",
		"released"
	},
	confirm_press = {
		"gamepad",
		"cross",
		"pressed"
	},
	special_1_press = {
		"gamepad",
		"square",
		"pressed"
	},
	start_1 = {
		"gamepad",
		"cross",
		"pressed"
	},
	back_1 = {
		"gamepad",
		"circle",
		"pressed"
	},
	delete_save = {
		"gamepad",
		"touch",
		"pressed"
	},
	show_support_info_1 = {
		"gamepad",
		"l1",
		"held"
	},
	show_support_info_2 = {
		"gamepad",
		"r1",
		"held"
	},
	previous = {
		"gamepad",
		"l1",
		"pressed"
	},
	next = {
		"gamepad",
		"r1",
		"pressed"
	},
	scroll_axis = {
		"gamepad",
		"right",
		"axis"
	},
	gamepad_right_axis = {
		"gamepad",
		"right",
		"axis"
	},
	start_press = {
		"gamepad",
		"options",
		"pressed"
	}
}
TitleScreenKeyMaps_3[str_21] = keymaps_key_approved_47

local TitleScreenKeyMaps_4 = TitleScreenKeyMaps
local str_22 = "ps_pad"
local keymaps_key_approved_48 = InputUtils.keymaps_key_approved("ps_pad")

keymaps_key_approved_48 = not keymaps_key_approved_48 and {
	move_left_raw = {
		"ps_pad",
		"left",
		"pressed"
	},
	move_right_raw = {
		"ps_pad",
		"right",
		"pressed"
	},
	move_up_raw = {
		"ps_pad",
		"up",
		"pressed"
	},
	move_down_raw = {
		"ps_pad",
		"down",
		"pressed"
	},
	analog_input = {
		"ps_pad",
		"left",
		"axis"
	},
	axis_cursor = {
		"ps_pad",
		"left",
		"axis"
	},
	left_press = {
		"ps_pad",
		"cross",
		"pressed"
	},
	left_hold = {
		"ps_pad",
		"cross",
		"held"
	},
	left_release = {
		"ps_pad",
		"cross",
		"released"
	},
	confirm_press = {
		"ps_pad",
		"cross",
		"pressed"
	},
	special_1_press = {
		"ps_pad",
		"square",
		"pressed"
	},
	start_1 = {
		"ps_pad",
		"cross",
		"pressed"
	},
	back_1 = {
		"ps_pad",
		"circle",
		"pressed"
	},
	delete_save = {
		"ps_pad",
		"touch",
		"pressed"
	},
	show_support_info_1 = {
		"ps_pad",
		"l1",
		"held"
	},
	show_support_info_2 = {
		"ps_pad",
		"r1",
		"held"
	},
	previous = {
		"ps_pad",
		"l1",
		"pressed"
	},
	next = {
		"ps_pad",
		"r1",
		"pressed"
	},
	scroll_axis = {
		"ps_pad",
		"right",
		"axis"
	},
	gamepad_right_axis = {
		"ps_pad",
		"right",
		"axis"
	},
	start_press = {
		"ps_pad",
		"options",
		"pressed"
	}
}
TitleScreenKeyMaps_4[str_22] = keymaps_key_approved_48
TitleScreenFilters = {}

local TitleScreenFilters = TitleScreenFilters
local keymaps_key_approved_49 = InputUtils.keymaps_key_approved("win32")

keymaps_key_approved_49 = not keymaps_key_approved_49 and {
	start = {
		filter_type = "or",
		input_mappings = {
			button_4 = "start_4",
			button_5 = "start_5",
			button_3 = "start_3",
			button_2 = "start_2",
			button_1 = "start_1"
		}
	},
	back = {
		filter_type = "or",
		input_mappings = {
			button_1 = "back_1",
			button_2 = "back_2"
		}
	},
	down = {
		filter_type = "move_filter",
		threshold = 0.7,
		input_mappings = {
			"move_down_raw",
			"move_down_alt_raw"
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
			"move_up_raw",
			"move_up_alt_raw"
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
			"move_left_raw",
			"move_left_altraw"
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
			"move_right_raw",
			"move_right_alt_raw"
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
TitleScreenFilters.win32 = keymaps_key_approved_49

local TitleScreenFilters_2 = TitleScreenFilters
local keymaps_key_approved_50 = InputUtils.keymaps_key_approved("xb1")

keymaps_key_approved_50 = not keymaps_key_approved_50 and {
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
TitleScreenFilters_2.xb1 = keymaps_key_approved_50

local tbl_7 = {
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
local TitleScreenFilters_3 = TitleScreenFilters
local str_23 = "ps4"
local keymaps_key_approved_51 = InputUtils.keymaps_key_approved("ps4")

keymaps_key_approved_51 = not keymaps_key_approved_51 and tbl_7
TitleScreenFilters_3[str_23] = keymaps_key_approved_51

local TitleScreenFilters_4 = TitleScreenFilters
local str_24 = "ps_pad"
local keymaps_key_approved_52 = InputUtils.keymaps_key_approved("ps_pad")

keymaps_key_approved_52 = not keymaps_key_approved_52 and tbl_7
TitleScreenFilters_4[str_24] = keymaps_key_approved_52
DemoUIKeyMaps = {}

local DemoUIKeyMaps = DemoUIKeyMaps
local keymaps_key_approved_53 = InputUtils.keymaps_key_approved("win32")

keymaps_key_approved_53 = not keymaps_key_approved_53 and {
	left = {
		"gamepad",
		"d_left",
		"pressed"
	},
	right = {
		"gamepad",
		"d_right",
		"pressed"
	},
	up = {
		"gamepad",
		"d_up",
		"pressed"
	},
	down = {
		"gamepad",
		"d_down",
		"pressed"
	},
	back_1 = {
		"gamepad",
		"b",
		"pressed"
	},
	back_2 = {
		"keyboard",
		"esc",
		"pressed"
	},
	confirm_1 = {
		"keyboard",
		"enter",
		"pressed"
	},
	confirm_2 = {
		"keyboard",
		"space",
		"pressed"
	},
	confirm_3 = {
		"mouse",
		"left",
		"pressed"
	},
	confirm_4 = {
		"mouse",
		"right",
		"pressed"
	},
	confirm_5 = {
		"mouse",
		"extra_1",
		"pressed"
	}
}
DemoUIKeyMaps.win32 = keymaps_key_approved_53

local DemoUIKeyMaps_2 = DemoUIKeyMaps
local keymaps_key_approved_54 = InputUtils.keymaps_key_approved("xb1")

keymaps_key_approved_54 = not keymaps_key_approved_54 and {
	left = {
		"gamepad",
		"d_left",
		"pressed"
	},
	right = {
		"gamepad",
		"d_right",
		"pressed"
	},
	up = {
		"gamepad",
		"d_up",
		"pressed"
	},
	down = {
		"gamepad",
		"d_down",
		"pressed"
	},
	confirm = {
		"gamepad",
		"a",
		"released"
	},
	back = {
		"gamepad",
		"b",
		"pressed"
	}
}
DemoUIKeyMaps_2.xb1 = keymaps_key_approved_54

local DemoUIKeyMaps_3 = DemoUIKeyMaps
local str_25 = "ps4"
local keymaps_key_approved_55 = InputUtils.keymaps_key_approved("ps4")

keymaps_key_approved_55 = not keymaps_key_approved_55 and {
	left = {
		"gamepad",
		"left",
		"pressed"
	},
	right = {
		"gamepad",
		"right",
		"pressed"
	},
	up = {
		"gamepad",
		"up",
		"pressed"
	},
	down = {
		"gamepad",
		"down",
		"pressed"
	},
	confirm = {
		"gamepad",
		"cross",
		"released"
	},
	back = {
		"gamepad",
		"circle",
		"pressed"
	}
}
DemoUIKeyMaps_3[str_25] = keymaps_key_approved_55

local DemoUIKeyMaps_4 = DemoUIKeyMaps
local str_26 = "ps_pad"
local keymaps_key_approved_56 = InputUtils.keymaps_key_approved("ps_pad")

keymaps_key_approved_56 = not keymaps_key_approved_56 and {
	left = {
		"ps_pad",
		"left",
		"pressed"
	},
	right = {
		"ps_pad",
		"right",
		"pressed"
	},
	up = {
		"ps_pad",
		"up",
		"pressed"
	},
	down = {
		"ps_pad",
		"down",
		"pressed"
	},
	confirm = {
		"ps_pad",
		"cross",
		"released"
	},
	back = {
		"ps_pad",
		"circle",
		"pressed"
	}
}
DemoUIKeyMaps_4[str_26] = keymaps_key_approved_56
DemoUIFilters = {}

local DemoUIFilters = DemoUIFilters
local keymaps_key_approved_57 = InputUtils.keymaps_key_approved("win32")

keymaps_key_approved_57 = not keymaps_key_approved_57 and {
	start = {
		filter_type = "or",
		input_mappings = {
			button_4 = "start_4",
			button_5 = "start_5",
			button_3 = "start_3",
			button_2 = "start_2",
			button_1 = "start_1"
		}
	},
	back = {
		filter_type = "or",
		input_mappings = {
			button_1 = "back_1",
			button_2 = "back_2"
		}
	}
}
DemoUIFilters.win32 = keymaps_key_approved_57

local DemoUIFilters_2 = DemoUIFilters
local keymaps_key_approved_58 = InputUtils.keymaps_key_approved("xb1")

keymaps_key_approved_58 = not keymaps_key_approved_58 and {}
DemoUIFilters_2.xb1 = keymaps_key_approved_58

local DemoUIFilters_3 = DemoUIFilters
local str_27 = "ps4"
local keymaps_key_approved_59 = InputUtils.keymaps_key_approved("ps4")

keymaps_key_approved_59 = not keymaps_key_approved_59 and {}
DemoUIFilters_3[str_27] = keymaps_key_approved_59

local DemoUIFilters_4 = DemoUIFilters
local str_28 = "ps_pad"
local keymaps_key_approved_60 = InputUtils.keymaps_key_approved("ps_pad")

keymaps_key_approved_60 = not keymaps_key_approved_60 and {}
DemoUIFilters_4[str_28] = keymaps_key_approved_60
IngamePlayerListKeymaps = {}

local IngamePlayerListKeymaps = IngamePlayerListKeymaps
local keymaps_key_approved_61 = InputUtils.keymaps_key_approved("win32")

keymaps_key_approved_61 = not keymaps_key_approved_61 and {
	toggle_menu = {
		"keyboard",
		"esc",
		"pressed"
	},
	cursor = {
		"mouse",
		"cursor",
		"axis"
	},
	left_release = {
		"mouse",
		"left",
		"released"
	},
	left_hold = {
		"mouse",
		"left",
		"held"
	},
	left_press = {
		"mouse",
		"left",
		"pressed"
	},
	right_press = {
		"mouse",
		"right",
		"pressed"
	},
	ingame_player_list_pressed = {
		"keyboard",
		"tab",
		"pressed"
	},
	ingame_player_list_held = {
		"keyboard",
		"tab",
		"held"
	},
	ingame_player_list_toggle = {},
	ingame_player_list_exit_1 = {
		"keyboard",
		"tab",
		"pressed"
	},
	ingame_player_list_exit_2 = {
		"keyboard",
		"esc",
		"pressed"
	},
	close_ingame_player_list = {
		"keyboard",
		"tab",
		"released"
	},
	activate_ingame_player_list_1 = {
		"mouse",
		"right",
		"pressed"
	},
	activate_ingame_player_list_2 = {
		"keyboard",
		"enter",
		"pressed"
	},
	menu_scroll = {
		"mouse",
		"wheel",
		"axis"
	},
	versus_status_list_pressed_1 = {
		"keyboard",
		"left alt",
		"pressed"
	},
	versus_status_list_pressed_2 = {
		"keyboard",
		"right alt",
		"pressed"
	},
	versus_status_list_held_1 = {
		"keyboard",
		"left alt",
		"held"
	},
	versus_status_list_held_2 = {
		"keyboard",
		"right alt",
		"held"
	},
	versus_status_list_toggle = {},
	versus_status_list_exit_1 = {
		"keyboard",
		"left alt",
		"pressed"
	},
	versus_status_list_exit_2 = {
		"keyboard",
		"right alt",
		"pressed"
	},
	versus_status_list_exit_3 = {
		"keyboard",
		"esc",
		"pressed"
	},
	close_versus_status_list_1 = {
		"keyboard",
		"left alt",
		"released"
	},
	close_versus_status_list_2 = {
		"keyboard",
		"right alt",
		"released"
	},
	activate_versus_status_list_1 = {
		"mouse",
		"right",
		"pressed"
	},
	activate_versus_status_list_2 = {
		"keyboard",
		"enter",
		"pressed"
	},
	force_start = {},
	switch_team = {},
	scroll_axis = {
		"mouse",
		"wheel",
		"axis"
	},
	move_up = {},
	move_down = {},
	mute_voice = {},
	mute_chat = {},
	kick_player = {},
	toggle_private = {},
	back = {},
	show_profile = {}
}
IngamePlayerListKeymaps.win32 = keymaps_key_approved_61

local IngamePlayerListKeymaps_2 = IngamePlayerListKeymaps
local keymaps_key_approved_62 = InputUtils.keymaps_key_approved("xb1")

keymaps_key_approved_62 = not keymaps_key_approved_62 and {
	toggle_menu = {
		"gamepad",
		"start",
		"pressed"
	},
	ingame_player_list_toggle = {
		"gamepad",
		"back",
		"pressed"
	},
	mute_voice = {
		"gamepad",
		"y",
		"released"
	},
	mute_chat = {
		"gamepad",
		"x",
		"released"
	},
	kick_player = {
		"gamepad",
		"right_thumb",
		"pressed"
	},
	toggle_private = {
		"gamepad",
		"left_thumb",
		"pressed"
	},
	back = {
		"gamepad",
		"b",
		"released"
	},
	show_profile = {
		"gamepad",
		"a",
		"pressed"
	},
	move_up = {
		"gamepad",
		"d_up",
		"pressed"
	},
	move_down = {
		"gamepad",
		"d_down",
		"pressed"
	},
	ingame_player_list_exit = {},
	activate_ingame_player_list = {},
	axis_cursor = {
		"gamepad",
		"left",
		"axis"
	},
	left_press = {
		"gamepad",
		"a",
		"pressed"
	},
	left_hold = {
		"gamepad",
		"a",
		"held"
	},
	left_release = {
		"gamepad",
		"a",
		"released"
	},
	right_press = {
		"gamepad",
		"right_shoulder",
		"pressed"
	},
	right_hold = {
		"gamepad",
		"right_shoulder",
		"held"
	},
	right_release = {
		"gamepad",
		"right_shoulder",
		"released"
	},
	versus_status_list_toggle = {
		"gamepad",
		"start",
		"pressed"
	},
	versus_status_list_exit = {},
	activate_versus_status_list = {},
	force_start = {
		"gamepad",
		"y",
		"pressed"
	},
	switch_team = {
		"gamepad",
		"x",
		"pressed"
	}
}
IngamePlayerListKeymaps_2.xb1 = keymaps_key_approved_62

local IngamePlayerListKeymaps_3 = IngamePlayerListKeymaps
local str_29 = "ps4"
local keymaps_key_approved_63 = InputUtils.keymaps_key_approved("ps4")

keymaps_key_approved_63 = not keymaps_key_approved_63 and {
	toggle_menu = {
		"gamepad",
		"options",
		"pressed"
	},
	ingame_player_list_toggle = {
		"gamepad",
		"touch",
		"pressed"
	},
	mute_voice = {
		"gamepad",
		"triangle",
		"released"
	},
	mute_chat = {
		"gamepad",
		"square",
		"released"
	},
	kick_player = {
		"gamepad",
		"r3",
		"pressed"
	},
	toggle_private = {
		"gamepad",
		"l3",
		"pressed"
	},
	back = {
		"gamepad",
		"circle",
		"released"
	},
	show_profile = {
		"gamepad",
		"cross",
		"pressed"
	},
	move_up = {
		"gamepad",
		"up",
		"pressed"
	},
	move_down = {
		"gamepad",
		"down",
		"pressed"
	},
	ingame_player_list_exit = {},
	activate_ingame_player_list = {},
	axis_cursor = {
		"gamepad",
		"left",
		"axis"
	},
	left_press = {
		"gamepad",
		"cross",
		"pressed"
	},
	left_hold = {
		"gamepad",
		"cross",
		"held"
	},
	left_release = {
		"gamepad",
		"cross",
		"released"
	},
	right_press = {
		"gamepad",
		"r1",
		"pressed"
	},
	right_hold = {
		"gamepad",
		"r1",
		"held"
	},
	right_release = {
		"gamepad",
		"r1",
		"released"
	},
	versus_status_list_toggle = {
		"gamepad",
		"options",
		"pressed"
	},
	versus_status_list_exit = {},
	activate_versus_status_list = {},
	force_start = {
		"gamepad",
		"triangle",
		"pressed"
	},
	switch_team = {
		"gamepad",
		"square",
		"pressed"
	}
}
IngamePlayerListKeymaps_3[str_29] = keymaps_key_approved_63

local IngamePlayerListKeymaps_4 = IngamePlayerListKeymaps
local str_30 = "ps_pad"
local keymaps_key_approved_64 = InputUtils.keymaps_key_approved("ps_pad")

keymaps_key_approved_64 = not keymaps_key_approved_64 and {
	toggle_menu = {
		"ps_pad",
		"options",
		"pressed"
	},
	ingame_player_list_toggle = {
		"ps_pad",
		"touch",
		"pressed"
	},
	mute_voice = {
		"ps_pad",
		"triangle",
		"released"
	},
	mute_chat = {
		"ps_pad",
		"square",
		"released"
	},
	kick_player = {
		"ps_pad",
		"r3",
		"pressed"
	},
	toggle_private = {
		"ps_pad",
		"l3",
		"pressed"
	},
	back = {
		"ps_pad",
		"circle",
		"released"
	},
	show_profile = {
		"ps_pad",
		"cross",
		"pressed"
	},
	move_up = {
		"ps_pad",
		"up",
		"pressed"
	},
	move_down = {
		"ps_pad",
		"down",
		"pressed"
	},
	ingame_player_list_exit = {},
	activate_ingame_player_list = {},
	axis_cursor = {
		"ps_pad",
		"left",
		"axis"
	},
	left_press = {
		"ps_pad",
		"cross",
		"pressed"
	},
	left_hold = {
		"ps_pad",
		"cross",
		"held"
	},
	left_release = {
		"ps_pad",
		"cross",
		"released"
	},
	right_press = {
		"ps_pad",
		"r1",
		"pressed"
	},
	right_hold = {
		"ps_pad",
		"r1",
		"held"
	},
	right_release = {
		"ps_pad",
		"r1",
		"released"
	},
	versus_status_list_toggle = {
		"ps_pad",
		"options",
		"pressed"
	},
	versus_status_list_exit = {},
	activate_versus_status_list = {},
	force_start = {
		"ps_pad",
		"triangle",
		"pressed"
	},
	switch_team = {
		"ps_pad",
		"square",
		"pressed"
	}
}
IngamePlayerListKeymaps_4[str_30] = keymaps_key_approved_64
IngamePlayerListFilters = {}

local IngamePlayerListFilters = IngamePlayerListFilters
local keymaps_key_approved_65 = InputUtils.keymaps_key_approved("win32")

keymaps_key_approved_65 = not keymaps_key_approved_65 and {
	ingame_player_list_exit = {
		filter_type = "or",
		input_mappings = {
			button_1 = "ingame_player_list_exit_1",
			button_2 = "ingame_player_list_exit_2"
		}
	},
	activate_ingame_player_list = {
		filter_type = "or",
		input_mappings = {
			button_1 = "activate_ingame_player_list_1",
			button_2 = "activate_ingame_player_list_2"
		}
	},
	versus_status_list_pressed = {
		filter_type = "or",
		input_mappings = {
			button_1 = "versus_status_list_pressed_1",
			button_2 = "versus_status_list_pressed_2"
		}
	},
	versus_status_list_held = {
		filter_type = "or",
		input_mappings = {
			button_1 = "versus_status_list_held_1",
			button_2 = "versus_status_list_held_2"
		}
	},
	close_versus_status_list = {
		filter_type = "or",
		input_mappings = {
			button_1 = "close_versus_status_list_1",
			button_2 = "close_versus_status_list_2"
		}
	},
	versus_status_list_exit = {
		filter_type = "or",
		input_mappings = {
			button_2 = "versus_status_list_exit_2",
			button_3 = "versus_status_list_exit_2",
			button_1 = "versus_status_list_exit_1"
		}
	},
	activate_versus_status_list = {
		filter_type = "or",
		input_mappings = {
			button_1 = "activate_versus_status_list_1",
			button_2 = "activate_versus_status_list_2"
		}
	}
}
IngamePlayerListFilters.win32 = keymaps_key_approved_65

local IngamePlayerListFilters_2 = IngamePlayerListFilters
local keymaps_key_approved_66 = InputUtils.keymaps_key_approved("xb1")

keymaps_key_approved_66 = not keymaps_key_approved_66 and {
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
IngamePlayerListFilters_2.xb1 = keymaps_key_approved_66

local tbl_8 = {
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
local IngamePlayerListFilters_3 = IngamePlayerListFilters
local str_31 = "ps4"
local keymaps_key_approved_67 = InputUtils.keymaps_key_approved("ps4")

keymaps_key_approved_67 = not keymaps_key_approved_67 and tbl_8
IngamePlayerListFilters_3[str_31] = keymaps_key_approved_67

local IngamePlayerListFilters_4 = IngamePlayerListFilters
local str_32 = "ps_pad"
local keymaps_key_approved_68 = InputUtils.keymaps_key_approved("ps_pad")

keymaps_key_approved_68 = not keymaps_key_approved_68 and tbl_8
IngamePlayerListFilters_4[str_32] = keymaps_key_approved_68
IngameMenuKeymaps = {}

local IngameMenuKeymaps = IngameMenuKeymaps
local keymaps_key_approved_69 = InputUtils.keymaps_key_approved("win32")

if not keymaps_key_approved_69 then
	keymaps_key_approved_69 = {
		ingame_vote_yes = {
			"keyboard",
			"f5",
			"pressed"
		},
		ingame_vote_no = {
			"keyboard",
			"f6",
			"pressed"
		},
		ui_reload_debug = {
			"keyboard",
			"f5",
			"pressed"
		},
		ui_debug = {
			"keyboard",
			"f6",
			"pressed"
		}
	}

	local tbl_9 = {
		"keyboard",
		nil,
		"pressed"
	}
	local flag

	flag = not IS_XB1 and "b" and "f10"
	tbl_9[2] = flag
	keymaps_key_approved_69.cancel_matchmaking = tbl_9

	local tbl_10 = {
		"keyboard",
		"esc",
		"pressed"
	}

	keymaps_key_approved_69.xbox_cancel_matchmaking = tbl_10

	local tbl_11 = {
		"keyboard",
		"f2",
		"pressed"
	}

	keymaps_key_approved_69.matchmaking_ready_instigate = tbl_11

	local tbl_12 = {
		"keyboard",
		"f2",
		"pressed"
	}

	keymaps_key_approved_69.matchmaking_ready = tbl_12

	local tbl_13 = {
		"keyboard",
		"f3",
		"pressed"
	}

	keymaps_key_approved_69.matchmaking_start = tbl_13

	local tbl_14 = {
		"keyboard",
		"esc",
		"pressed"
	}

	keymaps_key_approved_69.toggle_menu = tbl_14

	local tbl_15 = {
		"mouse",
		"right",
		"pressed"
	}

	keymaps_key_approved_69.back_menu = tbl_15

	local tbl_16 = {
		"mouse",
		"extra_1",
		"released"
	}

	keymaps_key_approved_69.back_menu_alt = tbl_16

	local tbl_17 = {
		"keyboard",
		"up",
		"pressed"
	}

	keymaps_key_approved_69.move_up_raw = tbl_17

	local tbl_18 = {
		"keyboard",
		"down",
		"pressed"
	}

	keymaps_key_approved_69.move_down_raw = tbl_18

	local tbl_19 = {
		"keyboard",
		"left",
		"pressed"
	}

	keymaps_key_approved_69.move_left_raw = tbl_19

	local tbl_20 = {
		"keyboard",
		"right",
		"pressed"
	}

	keymaps_key_approved_69.move_right_raw = tbl_20

	local tbl_21 = {
		"keyboard",
		"up",
		"held"
	}

	keymaps_key_approved_69.move_up_hold_raw = tbl_21

	local tbl_22 = {
		"keyboard",
		"down",
		"held"
	}

	keymaps_key_approved_69.move_down_hold_raw = tbl_22

	local tbl_23 = {
		"keyboard",
		"left",
		"held"
	}

	keymaps_key_approved_69.move_left_hold_raw = tbl_23

	local tbl_24 = {
		"keyboard",
		"right",
		"held"
	}

	keymaps_key_approved_69.move_right_hold_raw = tbl_24

	local tbl_25 = {
		"keyboard",
		"w",
		"pressed"
	}

	keymaps_key_approved_69.move_up_alt_raw = tbl_25

	local tbl_26 = {
		"keyboard",
		"s",
		"pressed"
	}

	keymaps_key_approved_69.move_down_alt_raw = tbl_26

	local tbl_27 = {
		"keyboard",
		"a",
		"pressed"
	}

	keymaps_key_approved_69.move_left_alt_raw = tbl_27

	local tbl_28 = {
		"keyboard",
		"d",
		"pressed"
	}

	keymaps_key_approved_69.move_right_alt_raw = tbl_28

	local tbl_29 = {
		"keyboard",
		"w",
		"held"
	}

	keymaps_key_approved_69.move_up_alt_hold_raw = tbl_29

	local tbl_30 = {
		"keyboard",
		"s",
		"held"
	}

	keymaps_key_approved_69.move_down_alt_hold_raw = tbl_30

	local tbl_31 = {
		"keyboard",
		"a",
		"held"
	}

	keymaps_key_approved_69.move_left_alt_hold_raw = tbl_31

	local tbl_32 = {
		"keyboard",
		"d",
		"held"
	}

	keymaps_key_approved_69.move_right_alt_hold_raw = tbl_32

	local tbl_33 = {
		"keyboard",
		"left alt",
		"pressed"
	}

	keymaps_key_approved_69.versus_menu_toggle = tbl_33

	local tbl_34 = {}

	keymaps_key_approved_69.analog_input = tbl_34

	local tbl_35 = {
		"keyboard",
		"space",
		"held"
	}

	keymaps_key_approved_69.skip = tbl_35

	local tbl_36 = {
		"keyboard",
		"space",
		"pressed"
	}

	keymaps_key_approved_69.skip_pressed = tbl_36
	keymaps_key_approved_69.cursor = {
		"mouse",
		"cursor",
		"axis"
	}

	local tbl_37 = {
		"mouse",
		"left",
		"released"
	}

	keymaps_key_approved_69.left_release = tbl_37

	local tbl_38 = {
		"mouse",
		"left",
		"held"
	}

	keymaps_key_approved_69.left_hold = tbl_38

	local tbl_39 = {
		"mouse",
		"left",
		"pressed"
	}

	keymaps_key_approved_69.left_press = tbl_39

	local tbl_40 = {
		"mouse",
		"right",
		"pressed"
	}

	keymaps_key_approved_69.right_press = tbl_40

	local tbl_41 = {
		"mouse",
		"middle",
		"pressed"
	}

	keymaps_key_approved_69.mouse_middle_press = tbl_41

	local tbl_42 = {
		"mouse",
		"middle",
		"held"
	}

	keymaps_key_approved_69.mouse_middle_held = tbl_42

	local tbl_43 = {
		"keyboard",
		"space",
		"released"
	}

	keymaps_key_approved_69.confirm = tbl_43

	local tbl_44 = {
		"keyboard",
		"space",
		"held"
	}

	keymaps_key_approved_69.confirm_hold = tbl_44

	local tbl_45 = {
		"keyboard",
		"space",
		"pressed"
	}

	keymaps_key_approved_69.confirm_press = tbl_45

	local tbl_46 = {}

	keymaps_key_approved_69.back = tbl_46

	local tbl_47 = {}

	keymaps_key_approved_69.refresh = tbl_47

	local tbl_48 = {}

	keymaps_key_approved_69.refresh_hold = tbl_48

	local tbl_49 = {}

	keymaps_key_approved_69.refresh_press = tbl_49

	local tbl_50 = {}

	keymaps_key_approved_69.special_1 = tbl_50

	local tbl_51 = {}

	keymaps_key_approved_69.special_1_hold = tbl_51

	local tbl_52 = {}

	keymaps_key_approved_69.special_1_press = tbl_52

	local tbl_53 = {}

	keymaps_key_approved_69.left_stick_press = tbl_53

	local tbl_54 = {}

	keymaps_key_approved_69.right_stick_press = tbl_54

	local tbl_55 = {
		"keyboard",
		"tab",
		"pressed"
	}

	keymaps_key_approved_69.cycle_next_raw = tbl_55

	local tbl_56 = {
		"keyboard",
		"tab",
		"held"
	}

	keymaps_key_approved_69.cycle_next_raw_hold = tbl_56

	local tbl_57 = {
		"keyboard",
		"e",
		"pressed"
	}

	keymaps_key_approved_69.cycle_next_alt_raw = tbl_57

	local tbl_58 = {
		"keyboard",
		"e",
		"held"
	}

	keymaps_key_approved_69.cycle_next_alt_raw_hold = tbl_58

	local tbl_59 = {
		"keyboard",
		"q",
		"pressed"
	}

	keymaps_key_approved_69.cycle_prev_raw = tbl_59

	local tbl_60 = {
		"keyboard",
		"q",
		"held"
	}

	keymaps_key_approved_69.cycle_prev_raw_held = tbl_60

	local tbl_61 = {}

	keymaps_key_approved_69.trigger_left_soft = tbl_61

	local tbl_62 = {}

	keymaps_key_approved_69.trigger_right_soft = tbl_62

	local tbl_63 = {}

	keymaps_key_approved_69.trigger_cycle_next = tbl_63

	local tbl_64 = {}

	keymaps_key_approved_69.trigger_cycle_next_hold = tbl_64

	local tbl_65 = {}

	keymaps_key_approved_69.trigger_cycle_previous = tbl_65

	local tbl_66 = {}

	keymaps_key_approved_69.trigger_cycle_previous_hold = tbl_66

	local tbl_67 = {}

	keymaps_key_approved_69.gamepad_left_axis = tbl_67

	local tbl_68 = {}

	keymaps_key_approved_69.gamepad_right_axis = tbl_68
	keymaps_key_approved_69.look_raw_controller = {}

	local tbl_69 = {
		"mouse",
		"left",
		"pressed"
	}

	keymaps_key_approved_69.show_information = tbl_69

	local tbl_70 = {
		"keyboard",
		"m",
		"pressed"
	}

	keymaps_key_approved_69.hotkey_map = tbl_70

	local tbl_71 = {
		"keyboard",
		"l",
		"pressed"
	}

	keymaps_key_approved_69.hotkey_weave_leaderboard = tbl_71

	local tbl_72 = {
		"keyboard",
		"k",
		"pressed"
	}

	keymaps_key_approved_69.hotkey_weave_forge = tbl_72

	local tbl_73 = {
		"keyboard",
		"j",
		"pressed"
	}

	keymaps_key_approved_69.hotkey_weave_play = tbl_73

	local tbl_74 = {
		"keyboard",
		"t",
		"pressed"
	}

	keymaps_key_approved_69.hotkey_talents = tbl_74

	local tbl_75 = {
		"keyboard",
		"h",
		"pressed"
	}

	keymaps_key_approved_69.hotkey_hero = tbl_75

	local tbl_76 = {
		"keyboard",
		"i",
		"pressed"
	}

	keymaps_key_approved_69.hotkey_inventory = tbl_76

	local tbl_77 = {
		"keyboard",
		"h",
		"pressed"
	}

	keymaps_key_approved_69.hotkey_altar = tbl_77

	local tbl_78 = {
		"keyboard",
		"u",
		"pressed"
	}

	keymaps_key_approved_69.hotkey_quests = tbl_78

	local tbl_79 = {
		"keyboard",
		"o",
		"pressed"
	}

	keymaps_key_approved_69.hotkey_achievements = tbl_79

	local tbl_80 = {
		"keyboard",
		"f",
		"pressed"
	}

	keymaps_key_approved_69.hotkey_mark_favorite_item = tbl_80

	local tbl_81 = {
		"keyboard",
		"c",
		"pressed"
	}

	keymaps_key_approved_69.hotkey_loot = tbl_81

	local tbl_82 = {
		"keyboard",
		"left shift",
		"held"
	}

	keymaps_key_approved_69.item_compare_1 = tbl_82

	local tbl_83 = {
		"keyboard",
		"right shift",
		"held"
	}

	keymaps_key_approved_69.item_compare_2 = tbl_83

	local tbl_84 = {
		"keyboard",
		"left ctrl",
		"held"
	}

	keymaps_key_approved_69.item_detail_1 = tbl_84

	local tbl_85 = {
		"keyboard",
		"right ctrl",
		"held"
	}

	keymaps_key_approved_69.item_detail_2 = tbl_85

	local tbl_86 = {
		"keyboard",
		"1",
		"pressed"
	}

	keymaps_key_approved_69.keyboard_1 = tbl_86

	local tbl_87 = {
		"keyboard",
		"2",
		"pressed"
	}

	keymaps_key_approved_69.keyboard_2 = tbl_87

	local tbl_88 = {
		"keyboard",
		"3",
		"pressed"
	}

	keymaps_key_approved_69.keyboard_3 = tbl_88

	local tbl_89 = {
		"keyboard",
		"4",
		"pressed"
	}

	keymaps_key_approved_69.keyboard_4 = tbl_89

	local tbl_90 = {
		"keyboard",
		"5",
		"pressed"
	}

	keymaps_key_approved_69.keyboard_5 = tbl_90

	local tbl_91 = {
		"keyboard",
		"6",
		"pressed"
	}

	keymaps_key_approved_69.keyboard_6 = tbl_91

	local tbl_92 = {
		"keyboard",
		"7",
		"pressed"
	}

	keymaps_key_approved_69.keyboard_7 = tbl_92

	local tbl_93 = {
		"keyboard",
		"8",
		"pressed"
	}

	keymaps_key_approved_69.keyboard_8 = tbl_93

	local tbl_94 = {
		"keyboard",
		"9",
		"pressed"
	}

	keymaps_key_approved_69.keyboard_9 = tbl_94

	local tbl_95 = {
		"keyboard",
		"0",
		"pressed"
	}

	keymaps_key_approved_69.keyboard_0 = tbl_95

	local tbl_96 = {
		"mouse",
		"wheel",
		"axis"
	}

	keymaps_key_approved_69.scroll_axis = tbl_96

	local tbl_97 = {
		"keyboard",
		"left shift",
		"held"
	}

	keymaps_key_approved_69.debug_pixeldistance_1 = tbl_97

	local tbl_98 = {
		"mouse",
		"right",
		"held"
	}

	keymaps_key_approved_69.debug_pixeldistance_2 = tbl_98

	local tbl_99 = {
		"keyboard",
		"enter",
		"pressed"
	}

	keymaps_key_approved_69.execute_login_1 = tbl_99

	local tbl_100 = {
		"keyboard",
		"numpad enter",
		"pressed"
	}

	keymaps_key_approved_69.execute_login_2 = tbl_100

	local tbl_101 = {
		"keyboard",
		"space",
		"held"
	}

	keymaps_key_approved_69.cancel_video_1 = tbl_101

	local tbl_102 = {
		"keyboard",
		"esc",
		"held"
	}

	keymaps_key_approved_69.cancel_video_2 = tbl_102

	local tbl_103 = {
		"mouse",
		"left",
		"held"
	}

	keymaps_key_approved_69.cancel_video_3 = tbl_103
end

IngameMenuKeymaps.win32 = keymaps_key_approved_69

local IngameMenuKeymaps_2 = IngameMenuKeymaps
local keymaps_key_approved_70 = InputUtils.keymaps_key_approved("xb1")

keymaps_key_approved_70 = not keymaps_key_approved_70 and {
	ingame_vote_yes = {
		"gamepad",
		"back",
		"held"
	},
	ingame_vote_no = {
		"gamepad",
		"start",
		"held"
	},
	ui_reload_debug = {
		"gamepad",
		"y",
		"held"
	},
	ui_debug = {
		"gamepad",
		"y",
		"held"
	},
	cancel_matchmaking = {
		"gamepad",
		"back",
		"pressed"
	},
	matchmaking_ready_instigate = {
		"gamepad",
		"left_shoulder",
		"pressed"
	},
	matchmaking_ready = {
		"gamepad",
		"left_shoulder",
		"held"
	},
	matchmaking_start = {
		"gamepad",
		"left_shoulder",
		"held"
	},
	toggle_menu = {
		"gamepad",
		"start",
		"pressed"
	},
	back_menu = {
		"gamepad",
		"b",
		"pressed"
	},
	move_up_raw = {
		"gamepad",
		"d_up",
		"pressed"
	},
	move_down_raw = {
		"gamepad",
		"d_down",
		"pressed"
	},
	move_left_raw = {
		"gamepad",
		"d_left",
		"pressed"
	},
	move_right_raw = {
		"gamepad",
		"d_right",
		"pressed"
	},
	move_up_hold_raw = {
		"gamepad",
		"d_up",
		"held"
	},
	move_down_hold_raw = {
		"gamepad",
		"d_down",
		"held"
	},
	move_left_hold_raw = {
		"gamepad",
		"d_left",
		"held"
	},
	move_right_hold_raw = {
		"gamepad",
		"d_right",
		"held"
	},
	analog_input = {
		"gamepad",
		"left",
		"axis"
	},
	versus_menu_toggle = {
		"gamepad",
		"start",
		"pressed"
	},
	confirm = {
		"gamepad",
		"a",
		"released"
	},
	confirm_hold = {
		"gamepad",
		"a",
		"held"
	},
	confirm_press = {
		"gamepad",
		"a",
		"pressed"
	},
	back = {
		"gamepad",
		"b",
		"released"
	},
	refresh = {
		"gamepad",
		"y",
		"released"
	},
	refresh_hold = {
		"gamepad",
		"y",
		"held"
	},
	refresh_press = {
		"gamepad",
		"y",
		"pressed"
	},
	special_1 = {
		"gamepad",
		"x",
		"released"
	},
	special_1_hold = {
		"gamepad",
		"x",
		"held"
	},
	special_1_press = {
		"gamepad",
		"x",
		"pressed"
	},
	left_stick_press = {
		"gamepad",
		"left_thumb",
		"pressed"
	},
	right_stick_press = {
		"gamepad",
		"right_thumb",
		"pressed"
	},
	cycle_next = {
		"gamepad",
		"right_shoulder",
		"pressed"
	},
	cycle_next_raw = {
		"gamepad",
		"right_shoulder",
		"pressed"
	},
	cycle_next_alt_raw = {
		"gamepad",
		"right_shoulder",
		"pressed"
	},
	cycle_next_hold = {
		"gamepad",
		"right_shoulder",
		"held"
	},
	cycle_previous = {
		"gamepad",
		"left_shoulder",
		"pressed"
	},
	cycle_previous_raw = {
		"gamepad",
		"left_shoulder",
		"pressed"
	},
	cycle_prev_raw = {
		"gamepad",
		"left_shoulder",
		"pressed"
	},
	cycle_previous_hold = {
		"gamepad",
		"left_shoulder",
		"held"
	},
	trigger_left_soft = {
		"gamepad",
		"left_trigger",
		"soft_button"
	},
	trigger_right_soft = {
		"gamepad",
		"right_trigger",
		"soft_button"
	},
	trigger_cycle_next = {
		"gamepad",
		"right_trigger",
		"pressed"
	},
	trigger_cycle_next_hold = {
		"gamepad",
		"right_trigger",
		"held"
	},
	trigger_cycle_previous = {
		"gamepad",
		"left_trigger",
		"pressed"
	},
	trigger_cycle_previous_hold = {
		"gamepad",
		"left_trigger",
		"held"
	},
	gamepad_left_axis = {
		"gamepad",
		"left",
		"axis"
	},
	gamepad_right_axis = {
		"gamepad",
		"right",
		"axis"
	},
	look_raw_controller = {
		"gamepad",
		"left",
		"axis"
	},
	show_gamercard = {
		"gamepad",
		"back",
		"pressed"
	},
	hotkey_mark_favorite_item = {
		"gamepad",
		"right_thumb",
		"pressed"
	},
	show_information = {
		"gamepad",
		"right_trigger",
		"pressed"
	},
	axis_cursor = {
		"gamepad",
		"left",
		"axis"
	},
	left_press = {
		"gamepad",
		"a",
		"pressed"
	},
	left_hold = {
		"gamepad",
		"a",
		"held"
	},
	left_release = {
		"gamepad",
		"a",
		"released"
	},
	right_press = {},
	right_hold = {},
	right_release = {},
	scroll_axis = {
		"gamepad",
		"right",
		"axis"
	},
	debug_pixeldistance_1 = {
		"gamepad",
		"left_trigger",
		"held"
	},
	debug_pixeldistance_2 = {
		"gamepad",
		"right_trigger",
		"held"
	},
	cancel_video_1 = {
		"gamepad",
		"a",
		"held"
	},
	cancel_video_2 = {
		"gamepad",
		"b",
		"held"
	}
}
IngameMenuKeymaps_2.xb1 = keymaps_key_approved_70

local IngameMenuKeymaps_3 = IngameMenuKeymaps
local str_33 = "ps4"
local keymaps_key_approved_71 = InputUtils.keymaps_key_approved("ps4")

keymaps_key_approved_71 = not keymaps_key_approved_71 and {
	ingame_vote_yes = {
		"gamepad",
		"l1",
		"held"
	},
	ingame_vote_no = {
		"gamepad",
		"l2",
		"held"
	},
	ui_reload_debug = {
		"gamepad",
		"triangle",
		"held"
	},
	ui_debug = {
		"gamepad",
		"triangle",
		"held"
	},
	cancel_matchmaking = {
		"gamepad",
		"touch",
		"pressed"
	},
	matchmaking_ready_instigate = {
		"gamepad",
		"l1",
		"pressed"
	},
	matchmaking_ready = {
		"gamepad",
		"l1",
		"held"
	},
	matchmaking_start = {
		"gamepad",
		"l1",
		"held"
	},
	toggle_menu = {
		"gamepad",
		"options",
		"pressed"
	},
	back_menu = {
		"gamepad",
		"circle",
		"pressed"
	},
	move_up_raw = {
		"gamepad",
		"up",
		"pressed"
	},
	move_down_raw = {
		"gamepad",
		"down",
		"pressed"
	},
	move_left_raw = {
		"gamepad",
		"left",
		"pressed"
	},
	move_right_raw = {
		"gamepad",
		"right",
		"pressed"
	},
	move_up_hold_raw = {
		"gamepad",
		"up",
		"held"
	},
	move_down_hold_raw = {
		"gamepad",
		"down",
		"held"
	},
	move_left_hold_raw = {
		"gamepad",
		"left",
		"held"
	},
	move_right_hold_raw = {
		"gamepad",
		"right",
		"held"
	},
	analog_input = {
		"gamepad",
		"left",
		"axis"
	},
	versus_menu_toggle = {
		"gamepad",
		"options",
		"pressed"
	},
	confirm = {
		"gamepad",
		"cross",
		"released"
	},
	confirm_hold = {
		"gamepad",
		"cross",
		"held"
	},
	confirm_press = {
		"gamepad",
		"cross",
		"pressed"
	},
	back = {
		"gamepad",
		"circle",
		"released"
	},
	refresh = {
		"gamepad",
		"triangle",
		"released"
	},
	refresh_hold = {
		"gamepad",
		"triangle",
		"held"
	},
	refresh_press = {
		"gamepad",
		"triangle",
		"pressed"
	},
	special_1 = {
		"gamepad",
		"square",
		"released"
	},
	special_1_hold = {
		"gamepad",
		"square",
		"held"
	},
	special_1_press = {
		"gamepad",
		"square",
		"pressed"
	},
	left_stick_press = {
		"gamepad",
		"l3",
		"pressed"
	},
	right_stick_press = {
		"gamepad",
		"r3",
		"pressed"
	},
	cycle_next = {
		"gamepad",
		"r1",
		"pressed"
	},
	cycle_next_raw = {
		"gamepad",
		"r1",
		"pressed"
	},
	cycle_next_alt_raw = {
		"gamepad",
		"r1",
		"pressed"
	},
	cycle_next_hold = {
		"gamepad",
		"r1",
		"held"
	},
	cycle_previous = {
		"gamepad",
		"l1",
		"pressed"
	},
	cycle_previous_raw = {
		"gamepad",
		"l1",
		"pressed"
	},
	cycle_prev_raw = {
		"gamepad",
		"l1",
		"pressed"
	},
	cycle_previous_hold = {
		"gamepad",
		"l1",
		"held"
	},
	trigger_left_soft = {
		"gamepad",
		"l2",
		"soft_button"
	},
	trigger_right_soft = {
		"gamepad",
		"r2",
		"soft_button"
	},
	trigger_cycle_next = {
		"gamepad",
		"r2",
		"pressed"
	},
	trigger_cycle_next_hold = {
		"gamepad",
		"r2",
		"held"
	},
	trigger_cycle_previous = {
		"gamepad",
		"l2",
		"pressed"
	},
	trigger_cycle_previous_hold = {
		"gamepad",
		"l2",
		"held"
	},
	axis_cursor = {
		"gamepad",
		"left",
		"axis"
	},
	left_press = {
		"gamepad",
		"cross",
		"pressed"
	},
	left_hold = {
		"gamepad",
		"cross",
		"held"
	},
	left_release = {
		"gamepad",
		"cross",
		"released"
	},
	right_press = {},
	right_hold = {},
	right_release = {},
	gamepad_left_axis = {
		"gamepad",
		"left",
		"axis"
	},
	gamepad_right_axis = {
		"gamepad",
		"right",
		"axis"
	},
	look_raw_controller = {
		"gamepad",
		"left",
		"axis"
	},
	show_gamercard = {
		"gamepad",
		"touch",
		"pressed"
	},
	hotkey_mark_favorite_item = {
		"gamepad",
		"r3",
		"pressed"
	},
	show_information = {
		"gamepad",
		"r2",
		"pressed"
	},
	scroll_axis = {
		"gamepad",
		"right",
		"axis"
	},
	debug_pixeldistance_1 = {
		"gamepad",
		"l2",
		"held"
	},
	debug_pixeldistance_2 = {
		"gamepad",
		"r2",
		"held"
	},
	cancel_video_1 = {
		"gamepad",
		"cross",
		"held"
	},
	cancel_video_2 = {
		"gamepad",
		"circle",
		"held"
	}
}
IngameMenuKeymaps_3[str_33] = keymaps_key_approved_71

local IngameMenuKeymaps_4 = IngameMenuKeymaps
local str_34 = "ps_pad"
local keymaps_key_approved_72 = InputUtils.keymaps_key_approved("ps_pad")

keymaps_key_approved_72 = not keymaps_key_approved_72 and {
	ingame_vote_yes = {
		"ps_pad",
		"l1",
		"held"
	},
	ingame_vote_no = {
		"ps_pad",
		"l2",
		"held"
	},
	ui_reload_debug = {
		"ps_pad",
		"triangle",
		"held"
	},
	ui_debug = {
		"ps_pad",
		"triangle",
		"held"
	},
	cancel_matchmaking = {
		"ps_pad",
		"touch",
		"pressed"
	},
	matchmaking_ready_instigate = {
		"ps_pad",
		"l1",
		"pressed"
	},
	matchmaking_ready = {
		"ps_pad",
		"l1",
		"held"
	},
	matchmaking_start = {
		"ps_pad",
		"l1",
		"held"
	},
	toggle_menu = {
		"ps_pad",
		"options",
		"pressed"
	},
	back_menu = {
		"ps_pad",
		"circle",
		"pressed"
	},
	move_up_raw = {
		"ps_pad",
		"up",
		"pressed"
	},
	move_down_raw = {
		"ps_pad",
		"down",
		"pressed"
	},
	move_left_raw = {
		"ps_pad",
		"left",
		"pressed"
	},
	move_right_raw = {
		"ps_pad",
		"right",
		"pressed"
	},
	move_up_hold_raw = {
		"ps_pad",
		"up",
		"held"
	},
	move_down_hold_raw = {
		"ps_pad",
		"down",
		"held"
	},
	move_left_hold_raw = {
		"ps_pad",
		"left",
		"held"
	},
	move_right_hold_raw = {
		"ps_pad",
		"right",
		"held"
	},
	analog_input = {
		"ps_pad",
		"left",
		"axis"
	},
	versus_menu_toggle = {
		"ps_pad",
		"options",
		"pressed"
	},
	confirm = {
		"ps_pad",
		"cross",
		"released"
	},
	confirm_hold = {
		"ps_pad",
		"cross",
		"held"
	},
	confirm_press = {
		"ps_pad",
		"cross",
		"pressed"
	},
	back = {
		"ps_pad",
		"circle",
		"released"
	},
	refresh = {
		"ps_pad",
		"triangle",
		"released"
	},
	refresh_hold = {
		"ps_pad",
		"triangle",
		"held"
	},
	refresh_press = {
		"ps_pad",
		"triangle",
		"pressed"
	},
	special_1 = {
		"ps_pad",
		"square",
		"released"
	},
	special_1_hold = {
		"ps_pad",
		"square",
		"held"
	},
	special_1_press = {
		"ps_pad",
		"square",
		"pressed"
	},
	left_stick_press = {
		"ps_pad",
		"l3",
		"pressed"
	},
	right_stick_press = {
		"ps_pad",
		"r3",
		"pressed"
	},
	cycle_next = {
		"ps_pad",
		"r1",
		"pressed"
	},
	cycle_next_raw = {
		"ps_pad",
		"r1",
		"pressed"
	},
	cycle_next_alt_raw = {
		"ps_pad",
		"r1",
		"pressed"
	},
	cycle_next_hold = {
		"ps_pad",
		"r1",
		"held"
	},
	cycle_previous = {
		"ps_pad",
		"l1",
		"pressed"
	},
	cycle_previous_raw = {
		"ps_pad",
		"l1",
		"pressed"
	},
	cycle_prev_raw = {
		"ps_pad",
		"l1",
		"pressed"
	},
	cycle_previous_hold = {
		"ps_pad",
		"l1",
		"held"
	},
	trigger_left_soft = {
		"ps_pad",
		"l2",
		"soft_button"
	},
	trigger_right_soft = {
		"ps_pad",
		"r2",
		"soft_button"
	},
	trigger_cycle_next = {
		"ps_pad",
		"r2",
		"pressed"
	},
	trigger_cycle_next_hold = {
		"ps_pad",
		"r2",
		"held"
	},
	trigger_cycle_previous = {
		"ps_pad",
		"l2",
		"pressed"
	},
	trigger_cycle_previous_hold = {
		"ps_pad",
		"l2",
		"held"
	},
	axis_cursor = {
		"ps_pad",
		"left",
		"axis"
	},
	left_press = {
		"ps_pad",
		"cross",
		"pressed"
	},
	left_hold = {
		"ps_pad",
		"cross",
		"held"
	},
	left_release = {
		"ps_pad",
		"cross",
		"released"
	},
	right_press = {},
	right_hold = {},
	right_release = {},
	gamepad_left_axis = {
		"ps_pad",
		"left",
		"axis"
	},
	gamepad_right_axis = {
		"ps_pad",
		"right",
		"axis"
	},
	look_raw_controller = {
		"ps_pad",
		"left",
		"axis"
	},
	show_gamercard = {
		"ps_pad",
		"touch",
		"pressed"
	},
	hotkey_mark_favorite_item = {
		"ps_pad",
		"r3",
		"pressed"
	},
	show_information = {
		"ps_pad",
		"r2",
		"pressed"
	},
	scroll_axis = {
		"ps_pad",
		"right",
		"axis"
	},
	debug_pixeldistance_1 = {
		"ps_pad",
		"l2",
		"held"
	},
	debug_pixeldistance_2 = {
		"ps_pad",
		"r2",
		"held"
	},
	cancel_video_1 = {
		"ps_pad",
		"cross",
		"held"
	},
	cancel_video_2 = {
		"ps_pad",
		"circle",
		"held"
	}
}
IngameMenuKeymaps_4[str_34] = keymaps_key_approved_72
IngameMenuFilters = {}

local IngameMenuFilters = IngameMenuFilters
local keymaps_key_approved_73 = InputUtils.keymaps_key_approved("win32")

keymaps_key_approved_73 = not keymaps_key_approved_73 and {
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
	start = {
		filter_type = "or",
		input_mappings = {
			button_1 = "start_1",
			button_2 = "start_2"
		}
	},
	move_down = {
		filter_type = "move_filter",
		threshold = 0.7,
		input_mappings = {
			"move_down_raw",
			"move_down_alt_raw"
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
			"move_up_raw",
			"move_up_alt_raw"
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
			"move_left_raw",
			"move_left_alt_raw"
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
			"move_right_raw",
			"move_right_alt_raw"
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
			"move_down_hold_raw",
			"move_down_alt_hold_raw"
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
			"move_up_hold_raw",
			"move_up_alt_hold_raw"
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
			"move_left_hold_raw",
			"move_left_alt_hold_raw"
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
			"move_right_hold_raw",
			"move_right_alt_hold_raw"
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
			"move_down_hold_raw",
			"move_down_alt_hold_raw"
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
			"move_up_hold_raw",
			"move_up_alt_hold_raw"
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
			"move_left_hold_raw",
			"move_left_alt_hold_raw"
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
			"move_right_hold_raw",
			"move_right_alt_hold_raw"
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
	item_compare = {
		filter_type = "or",
		input_mappings = {
			button_1 = "item_compare_1",
			button_2 = "item_compare_2"
		}
	},
	item_detail = {
		filter_type = "or",
		input_mappings = {
			button_1 = "item_detail_1",
			button_2 = "item_detail_2"
		}
	},
	execute_chat_input = {
		filter_type = "or",
		input_mappings = {
			button_1 = "execute_login_1",
			button_2 = "execute_login_2"
		}
	},
	cycle_next = {
		filter_type = "or",
		input_mappings = {
			button_1 = "cycle_next_raw",
			button_2 = "cycle_next_alt_raw"
		}
	},
	cycle_next_hold = {
		filter_type = "or",
		input_mappings = {
			button_1 = "cycle_next_raw_hold",
			button_2 = "cycle_next_alt_raw_hold"
		}
	},
	cycle_previous = {
		filter_type = "multiple_and",
		input_mappings = {
			{
				button_1 = "item_detail_1",
				button_2 = "cycle_next_raw"
			},
			{
				button_1 = "cycle_prev_raw"
			}
		}
	},
	cycle_previous_hold = {
		filter_type = "multiple_and",
		input_mappings = {
			{
				button_1 = "item_detail_1",
				button_2 = "cycle_next_raw_hold"
			},
			{
				button_1 = "cycle_prev_raw_held"
			}
		}
	},
	cancel_video = {
		filter_type = "or",
		input_mappings = {
			button_2 = "cancel_video_2",
			button_3 = "cancel_video_3",
			button_1 = "cancel_video_1"
		}
	}
}
IngameMenuFilters.win32 = keymaps_key_approved_73

local IngameMenuFilters_2 = IngameMenuFilters
local keymaps_key_approved_74 = InputUtils.keymaps_key_approved("xb1")

keymaps_key_approved_74 = not keymaps_key_approved_74 and {
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
IngameMenuFilters_2.xb1 = keymaps_key_approved_74

local tbl_104 = {
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
local IngameMenuFilters_3 = IngameMenuFilters
local str_35 = "ps4"
local keymaps_key_approved_75 = InputUtils.keymaps_key_approved("ps4")

keymaps_key_approved_75 = not keymaps_key_approved_75 and tbl_104
IngameMenuFilters_3[str_35] = keymaps_key_approved_75

local IngameMenuFilters_4 = IngameMenuFilters
local str_36 = "ps_pad"
local keymaps_key_approved_76 = InputUtils.keymaps_key_approved("ps_pad")

keymaps_key_approved_76 = not keymaps_key_approved_76 and tbl_104
IngameMenuFilters_4[str_36] = keymaps_key_approved_76
CutsceneKeymaps = {}

local CutsceneKeymaps = CutsceneKeymaps
local keymaps_key_approved_77 = InputUtils.keymaps_key_approved("win32")

keymaps_key_approved_77 = not keymaps_key_approved_77 and {
	skip_cutscene_1 = {
		"keyboard",
		"enter",
		"pressed"
	},
	skip_cutscene_2 = {
		"keyboard",
		"space",
		"pressed"
	},
	skip_cutscene_3 = {
		"keyboard",
		"esc",
		"pressed"
	},
	gdc_skip = {
		"keyboard",
		"space",
		"pressed"
	},
	gdc_debug_skip_1 = {
		"keyboard",
		"left shift",
		"held"
	},
	gdc_debug_skip_2 = {
		"keyboard",
		"space",
		"pressed"
	}
}
CutsceneKeymaps.win32 = keymaps_key_approved_77

local CutsceneKeymaps_2 = CutsceneKeymaps
local keymaps_key_approved_78 = InputUtils.keymaps_key_approved("xb1")

keymaps_key_approved_78 = not keymaps_key_approved_78 and {
	skip_cutscene = {
		"gamepad",
		"a",
		"pressed"
	},
	gdc_skip = {
		"gamepad",
		"a",
		"pressed"
	},
	gdc_debug_skip = {}
}
CutsceneKeymaps_2.xb1 = keymaps_key_approved_78

local CutsceneKeymaps_3 = CutsceneKeymaps
local str_37 = "ps4"
local keymaps_key_approved_79 = InputUtils.keymaps_key_approved("ps4")

keymaps_key_approved_79 = not keymaps_key_approved_79 and {
	skip_cutscene = {
		"gamepad",
		"cross",
		"pressed"
	},
	gdc_skip = {
		"gamepad",
		"cross",
		"pressed"
	},
	gdc_debug_skip = {}
}
CutsceneKeymaps_3[str_37] = keymaps_key_approved_79

local CutsceneKeymaps_4 = CutsceneKeymaps
local str_38 = "ps_pad"
local keymaps_key_approved_80 = InputUtils.keymaps_key_approved("ps_pad")

keymaps_key_approved_80 = not keymaps_key_approved_80 and {
	skip_cutscene = {
		"ps_pad",
		"cross",
		"pressed"
	},
	gdc_skip = {
		"ps_pad",
		"cross",
		"pressed"
	},
	gdc_debug_skip = {}
}
CutsceneKeymaps_4[str_38] = keymaps_key_approved_80
CutsceneFilters = {}

local CutsceneFilters = CutsceneFilters
local keymaps_key_approved_81 = InputUtils.keymaps_key_approved("win32")

keymaps_key_approved_81 = not keymaps_key_approved_81 and {
	skip_cutscene = {
		filter_type = "or",
		input_mappings = {
			button_2 = "skip_cutscene_2",
			button_3 = "skip_cutscene_3",
			button_1 = "skip_cutscene_1"
		}
	},
	gdc_debug_skip = {
		filter_type = "and",
		input_mappings = {
			button_1 = "gdc_debug_skip_1",
			button_2 = "gdc_debug_skip_2"
		}
	}
}
CutsceneFilters.win32 = keymaps_key_approved_81

local CutsceneFilters_2 = CutsceneFilters
local keymaps_key_approved_82 = InputUtils.keymaps_key_approved("xb1")

keymaps_key_approved_82 = not keymaps_key_approved_82 and {}
CutsceneFilters_2.xb1 = keymaps_key_approved_82

local CutsceneFilters_3 = CutsceneFilters
local str_39 = "ps4"
local keymaps_key_approved_83 = InputUtils.keymaps_key_approved("ps4")

keymaps_key_approved_83 = not keymaps_key_approved_83 and {}
CutsceneFilters_3[str_39] = keymaps_key_approved_83

local CutsceneFilters_4 = CutsceneFilters
local str_40 = "ps_pad"
local keymaps_key_approved_84 = InputUtils.keymaps_key_approved("ps_pad")

keymaps_key_approved_84 = not keymaps_key_approved_84 and {}
CutsceneFilters_4[str_40] = keymaps_key_approved_84
ControllerDisconnectKeymaps = {}

local ControllerDisconnectKeymaps = ControllerDisconnectKeymaps
local keymaps_key_approved_85 = InputUtils.keymaps_key_approved("xb1")

keymaps_key_approved_85 = not keymaps_key_approved_85 and {
	accept_held_1 = {
		"gamepad",
		"a",
		"held"
	},
	accept_held_2 = {
		"gamepad",
		"start",
		"held"
	},
	cancel_held_1 = {
		"gamepad",
		"b",
		"held"
	},
	cancel_held_2 = {
		"gamepad",
		"back",
		"held"
	},
	accept_1 = {
		"gamepad",
		"a",
		"released"
	},
	accept_2 = {
		"gamepad",
		"start",
		"released"
	},
	cancel_1 = {
		"gamepad",
		"b",
		"released"
	},
	cancel_2 = {
		"gamepad",
		"back",
		"released"
	}
}
ControllerDisconnectKeymaps.xb1 = keymaps_key_approved_85
ControllerDisconnectFilters = {}

local ControllerDisconnectFilters = ControllerDisconnectFilters
local keymaps_key_approved_86 = InputUtils.keymaps_key_approved("xb1")

keymaps_key_approved_86 = not keymaps_key_approved_86 and {
	accept_held = {
		filter_type = "or",
		input_mappings = {
			button_1 = "accept_held_1",
			button_2 = "accept_held_2"
		}
	},
	cancel_held = {
		filter_type = "or",
		input_mappings = {
			button_1 = "cancel_held_1",
			button_2 = "cancel_held_2"
		}
	},
	accept = {
		filter_type = "or",
		input_mappings = {
			button_1 = "accept_1",
			button_2 = "accept_2"
		}
	},
	cancel = {
		filter_type = "or",
		input_mappings = {
			button_1 = "cancel_1",
			button_2 = "cancel_2"
		}
	}
}
ControllerDisconnectFilters.xb1 = keymaps_key_approved_86
BenchmarkControllerSettings = {}

local BenchmarkControllerSettings = BenchmarkControllerSettings
local keymaps_key_approved_87 = InputUtils.keymaps_key_approved("win32")

keymaps_key_approved_87 = not keymaps_key_approved_87 and {
	cycle_through_views = {
		"keyboard",
		"tab",
		"pressed"
	}
}
BenchmarkControllerSettings.win32 = keymaps_key_approved_87
EndLevelViewKeymapsFilters = table.clone(IngameMenuFilters)

if not EndLevelViewKeymapsFilters.xb1 then
	EndLevelViewKeymapsFilters.xb1.cursor = nil
end

if not EndLevelViewKeymapsFilters.ps4 then
	EndLevelViewKeymapsFilters.ps4.cursor = nil
end

if not EndLevelViewKeymapsFilters.ps_pad then
	EndLevelViewKeymapsFilters.ps_pad.cursor = nil
end

DarkPactSelectionUIKeymaps = {}

local DarkPactSelectionUIKeymaps = DarkPactSelectionUIKeymaps
local keymaps_key_approved_88 = InputUtils.keymaps_key_approved("win32")

keymaps_key_approved_88 = not keymaps_key_approved_88 and {
	switch_dark_pact_profile = {
		"keyboard",
		"h",
		"pressed"
	},
	cursor = {
		"mouse",
		"cursor",
		"axis"
	},
	left_release = {
		"mouse",
		"left",
		"released"
	},
	left_hold = {
		"mouse",
		"left",
		"held"
	},
	left_press = {
		"mouse",
		"left",
		"pressed"
	},
	right_press = {
		"mouse",
		"right",
		"pressed"
	},
	next_observer_target = {
		"mouse",
		"left",
		"pressed"
	},
	previous_observer_target = {
		"mouse",
		"right",
		"pressed"
	},
	enable_camera_movement = {
		"keyboard",
		"left alt",
		"pressed"
	},
	camera_movement_held = {
		"keyboard",
		"left alt",
		"held"
	},
	confirm = {
		"keyboard",
		"space",
		"pressed"
	},
	move_left_alt_raw = {
		"keyboard",
		"a",
		"pressed"
	},
	move_right_alt_raw = {
		"keyboard",
		"d",
		"pressed"
	},
	move_left_raw = {
		"keyboard",
		"left",
		"pressed"
	},
	move_right_raw = {
		"keyboard",
		"right",
		"pressed"
	},
	analog_input = {}
}
DarkPactSelectionUIKeymaps.win32 = keymaps_key_approved_88
DarkPactSelectionUIFilters = {}

local DarkPactSelectionUIFilters = DarkPactSelectionUIFilters
local keymaps_key_approved_89 = InputUtils.keymaps_key_approved("win32")

keymaps_key_approved_89 = not keymaps_key_approved_89 and {
	move_left = {
		filter_type = "move_filter",
		threshold = 0.7,
		input_mappings = {
			"move_left_raw",
			"move_left_alt_raw"
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
			"move_right_raw",
			"move_right_alt_raw"
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
DarkPactSelectionUIFilters.win32 = keymaps_key_approved_89

local DarkPactSelectionUIKeymaps_2 = DarkPactSelectionUIKeymaps
local keymaps_key_approved_90 = InputUtils.keymaps_key_approved("xb1")

keymaps_key_approved_90 = not keymaps_key_approved_90 and {
	confirm = {
		"gamepad",
		"a",
		"released"
	},
	move_left_raw = {
		"gamepad",
		"d_left",
		"pressed"
	},
	move_right_raw = {
		"gamepad",
		"d_right",
		"pressed"
	},
	move_left_hold = {
		"gamepad",
		"d_left",
		"held"
	},
	move_right_hold = {
		"gamepad",
		"d_right",
		"held"
	},
	analog_input = {
		"gamepad",
		"left",
		"axis"
	},
	next_observer_target = {
		"gamepad",
		"right_shoulder",
		"pressed"
	},
	previous_observer_target = {
		"gamepad",
		"left_shoulder",
		"pressed"
	}
}
DarkPactSelectionUIKeymaps_2.xb1 = keymaps_key_approved_90

local DarkPactSelectionUIFilters_2 = DarkPactSelectionUIFilters
local keymaps_key_approved_91 = InputUtils.keymaps_key_approved("xb1")

keymaps_key_approved_91 = not keymaps_key_approved_91 and {
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
DarkPactSelectionUIFilters_2.xb1 = keymaps_key_approved_91

local DarkPactSelectionUIKeymaps_3 = DarkPactSelectionUIKeymaps
local str_41 = "ps4"
local keymaps_key_approved_92 = InputUtils.keymaps_key_approved("ps4")

keymaps_key_approved_92 = not keymaps_key_approved_92 and {
	confirm = {
		"gamepad",
		"cross",
		"released"
	},
	move_left_raw = {
		"gamepad",
		"left",
		"pressed"
	},
	move_right_raw = {
		"gamepad",
		"right",
		"pressed"
	},
	move_left_hold = {
		"gamepad",
		"left",
		"held"
	},
	move_right_hold = {
		"gamepad",
		"right",
		"held"
	},
	analog_input = {
		"gamepad",
		"left",
		"axis"
	},
	next_observer_target = {
		"gamepad",
		"r1",
		"pressed"
	},
	previous_observer_target = {
		"gamepad",
		"l1",
		"pressed"
	}
}
DarkPactSelectionUIKeymaps_3[str_41] = keymaps_key_approved_92
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

local DarkPactSelectionUIKeymaps_4 = DarkPactSelectionUIKeymaps
local str_42 = "ps_pad"
local keymaps_key_approved_93 = InputUtils.keymaps_key_approved("ps_pad")

keymaps_key_approved_93 = not keymaps_key_approved_93 and {
	confirm = {
		"ps_pad",
		"cross",
		"released"
	},
	move_left_raw = {
		"ps_pad",
		"left",
		"pressed"
	},
	move_right_raw = {
		"ps_pad",
		"right",
		"pressed"
	},
	move_left_hold = {
		"ps_pad",
		"left",
		"held"
	},
	move_right_hold = {
		"ps_pad",
		"right",
		"held"
	},
	analog_input = {
		"ps_pad",
		"left",
		"axis"
	},
	next_observer_target = {
		"ps_pad",
		"r1",
		"pressed"
	},
	previous_observer_target = {
		"ps_pad",
		"l1",
		"pressed"
	}
}
DarkPactSelectionUIKeymaps_4[str_42] = keymaps_key_approved_93

local DarkPactSelectionUIFilters_3 = DarkPactSelectionUIFilters
local str_43 = "ps4"
local keymaps_key_approved_94 = InputUtils.keymaps_key_approved("ps4")

keymaps_key_approved_94 = not keymaps_key_approved_94 and table.clone(DarkPactSelectionUIFilters_ps4)
DarkPactSelectionUIFilters_3[str_43] = keymaps_key_approved_94

local DarkPactSelectionUIFilters_4 = DarkPactSelectionUIFilters
local str_44 = "ps_pad"
local keymaps_key_approved_95 = InputUtils.keymaps_key_approved("ps_pad")

keymaps_key_approved_95 = not keymaps_key_approved_95 and table.clone(DarkPactSelectionUIFilters_ps4)
DarkPactSelectionUIFilters_4[str_44] = keymaps_key_approved_95
GamepadSettings = {
	menu_cooldown = 0.25,
	menu_analog_deadzone = 0.5,
	menu_speed_multiplier_frame_decrease = 0.025,
	menu_speed_multiplier_decrease = 1.3,
	menu_min_speed_multiplier = 0.5,
	quest_menu_navigation_cooldown = 0.15
}

for k, v in pairs(DLCSettings) do
	local controller_settings = v.controller_settings

	if not controller_settings then
		for k_2, v_2 in pairs(controller_settings) do
			local var_0_340 = rawget(_G, k_2)

			fassert(var_0_340, "controller_settings.lua - Could not find input table for: (%s)", k_2)

			for k_3, v_3 in pairs(v_2) do
				if not InputUtils.keymaps_key_approved(k_3) then
					for k_4, v_4 in pairs(v_3) do
						var_0_340[k_3][k_4] = v_4
					end
				end
			end
		end
	end
end

require("scripts/helpers/gamepad_alternate_layout_helper")
