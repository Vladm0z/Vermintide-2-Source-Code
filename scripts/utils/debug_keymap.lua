-- chunkname: @scripts/utils/debug_keymap.lua

require("scripts/utils/input_helper")

DebugKeymap = {}
DebugInputFilters = {}

local valid_debug_build = BUILD == "dev" or BUILD == "debug"
local keyboard_device = "keyboard"
local keyboard_keymaps = {
	f1 = {
		keyboard_device,
		"f1",
		"pressed"
	},
	f2 = {
		keyboard_device,
		"f2",
		"pressed"
	},
	f3 = {
		keyboard_device,
		"f3",
		"pressed"
	},
	f4 = {
		keyboard_device,
		"f4",
		"pressed"
	},
	f5 = {
		keyboard_device,
		"f5",
		"pressed"
	},
	f6 = {
		keyboard_device,
		"f6",
		"pressed"
	},
	f7 = {
		keyboard_device,
		"f7",
		"pressed"
	},
	f8 = {
		keyboard_device,
		"f8",
		"pressed"
	},
	f9 = {
		keyboard_device,
		"f9",
		"pressed"
	},
	f10 = {
		keyboard_device,
		"f10",
		"pressed"
	},
	f11 = {
		keyboard_device,
		"f11",
		"pressed"
	},
	f12 = {
		keyboard_device,
		"f12",
		"pressed"
	},
	["page up"] = {
		keyboard_device,
		"page up",
		"pressed"
	},
	["page down"] = {
		keyboard_device,
		"page down",
		"pressed"
	},
	home = {
		keyboard_device,
		"home",
		"pressed"
	},
	["end"] = {
		keyboard_device,
		"end",
		"pressed"
	},
	["left ctrl"] = {
		keyboard_device,
		"left ctrl",
		"held"
	},
	["left shift"] = {
		keyboard_device,
		"left shift",
		"held"
	},
	["right ctrl"] = {
		keyboard_device,
		"right ctrl",
		"held"
	},
	["left alt"] = {
		keyboard_device,
		"left alt",
		"held"
	},
	right_key = {
		keyboard_device,
		"right",
		"pressed"
	},
	left_key = {
		keyboard_device,
		"left",
		"pressed"
	},
	up_key = {
		keyboard_device,
		"up",
		"held"
	},
	down_key = {
		keyboard_device,
		"down",
		"held"
	},
	enter_key = {
		keyboard_device,
		"enter",
		"pressed"
	},
	backspace = {
		keyboard_device,
		"backspace",
		"pressed"
	},
	numpad_plus = {
		keyboard_device,
		"numpad +",
		"pressed"
	},
	numpad_minus = {
		keyboard_device,
		"num -",
		"pressed"
	},
	a = {
		keyboard_device,
		"a",
		"pressed"
	},
	b = {
		keyboard_device,
		"b",
		"pressed"
	},
	c = {
		keyboard_device,
		"c",
		"pressed"
	},
	d = {
		keyboard_device,
		"d",
		"pressed"
	},
	e = {
		keyboard_device,
		"e",
		"pressed"
	},
	f = {
		keyboard_device,
		"f",
		"pressed"
	},
	g = {
		keyboard_device,
		"g",
		"pressed"
	},
	h = {
		keyboard_device,
		"h",
		"pressed"
	},
	h_held = {
		keyboard_device,
		"h",
		"held"
	},
	i = {
		keyboard_device,
		"i",
		"pressed"
	},
	j = {
		keyboard_device,
		"j",
		"pressed"
	},
	k = {
		keyboard_device,
		"k",
		"pressed"
	},
	l = {
		keyboard_device,
		"l",
		"pressed"
	},
	m = {
		keyboard_device,
		"m",
		"pressed"
	},
	n = {
		keyboard_device,
		"n",
		"pressed"
	},
	o = {
		keyboard_device,
		"o",
		"pressed"
	},
	p = {
		keyboard_device,
		"p",
		"pressed"
	},
	q = {
		keyboard_device,
		"q",
		"pressed"
	},
	r = {
		keyboard_device,
		"r",
		"pressed"
	},
	s = {
		keyboard_device,
		"s",
		"pressed"
	},
	t = {
		keyboard_device,
		"t",
		"pressed"
	},
	u = {
		keyboard_device,
		"u",
		"pressed"
	},
	v = {
		keyboard_device,
		"v",
		"pressed"
	},
	w = {
		keyboard_device,
		"w",
		"pressed"
	},
	x = {
		keyboard_device,
		"x",
		"pressed"
	},
	y = {
		keyboard_device,
		"y",
		"pressed"
	},
	z = {
		keyboard_device,
		"z",
		"pressed"
	},
	esc = {
		keyboard_device,
		"esc",
		"pressed"
	},
	activate_chat_input = {
		keyboard_device,
		"y",
		"pressed"
	},
	console_open_key = {
		keyboard_device,
		"end",
		"pressed"
	},
	console_favorite_key = {
		keyboard_device,
		"f",
		"pressed"
	},
	console_search_key = {
		keyboard_device,
		"backspace",
		"pressed"
	},
	cursor = {
		"mouse",
		"cursor",
		"axis"
	},
	look = {
		"mouse",
		"mouse",
		"axis"
	},
	mouse_left_held = {
		"mouse",
		"left",
		"held"
	},
	mouse_middle_held = {
		"mouse",
		"middle",
		"held"
	},
	mouse_right_held = {
		"mouse",
		"right",
		"held"
	}
}

DebugKeymap.win32 = InputUtils.keymaps_key_approved("win32")
DebugInputFilters.win32 = InputUtils.keymaps_key_approved("win32")
DebugKeymap.xb1 = InputUtils.keymaps_key_approved("xb1")
DebugInputFilters.xb1 = InputUtils.keymaps_key_approved("xb1")
DebugKeymap.ps4 = InputUtils.keymaps_key_approved("ps4")
DebugKeymap.ps_pad = InputUtils.keymaps_key_approved("ps_pad")

local DebugInputFilters_ps4 = {
	n_switch = {
		filter_type = "and",
		input_mappings = {
			l3 = "l3",
			r2 = "r2",
			left = "left"
		}
	},
	n = {
		filter_type = "and",
		input_mappings = {
			l3 = "l3",
			r2 = "r2",
			up = "up"
		}
	},
	o = {
		filter_type = "and",
		input_mappings = {
			l3 = "l3",
			left = "left",
			l2 = "l2"
		}
	},
	p = {
		filter_type = "and",
		input_mappings = {
			l3 = "l3",
			up = "up",
			l2 = "l2"
		}
	},
	l = {
		filter_type = "and",
		input_mappings = {
			l3 = "l3",
			down = "down"
		}
	},
	u = {
		filter_type = "and",
		input_mappings = {
			l3 = "l3",
			down = "down",
			l2 = "l2"
		}
	},
	c = {
		filter_type = "and",
		input_mappings = {
			l3 = "l3",
			up = "up"
		}
	},
	v = {
		filter_type = "or",
		input_mappings = {
			r3 = "r3"
		}
	},
	b = {
		filter_type = "and",
		input_mappings = {
			left = "left",
			l2 = "l2"
		}
	},
	h = {
		filter_type = "and",
		input_mappings = {
			l3 = "l3",
			circle = "circle",
			r3 = "r3"
		}
	},
	right_key = {
		filter_type = "and",
		input_mappings = {
			l3 = "l3",
			right = "right"
		}
	},
	time_scale = {
		filter_type = "and",
		input_mappings = {
			l3 = "l3",
			r3 = "r3"
		}
	},
	time_scale_axis = {
		filter_type = "sub",
		input_mappings = {
			l2_soft = "l2_soft",
			r2_soft = "r2_soft"
		}
	},
	look = {
		filter_type = "scale_vector3",
		multiplier = 10,
		input_mapping = "look_raw"
	}
}

DebugInputFilters.ps4 = InputUtils.keymaps_key_approved("ps4")
DebugInputFilters.ps_pad = InputUtils.keymaps_key_approved("ps_pad")
