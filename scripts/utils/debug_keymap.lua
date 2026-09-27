-- chunkname: @scripts/utils/debug_keymap.lua

require("scripts/utils/input_helper")

DebugKeymap = {}
DebugInputFilters = {}

local flag

flag = BUILD == "dev" or BUILD == "debug"

local str = "keyboard"
local tbl = {
	f1 = {
		str,
		"f1",
		"pressed"
	},
	f2 = {
		str,
		"f2",
		"pressed"
	},
	f3 = {
		str,
		"f3",
		"pressed"
	},
	f4 = {
		str,
		"f4",
		"pressed"
	},
	f5 = {
		str,
		"f5",
		"pressed"
	},
	f6 = {
		str,
		"f6",
		"pressed"
	},
	f7 = {
		str,
		"f7",
		"pressed"
	},
	f8 = {
		str,
		"f8",
		"pressed"
	},
	f9 = {
		str,
		"f9",
		"pressed"
	},
	f10 = {
		str,
		"f10",
		"pressed"
	},
	f11 = {
		str,
		"f11",
		"pressed"
	},
	f12 = {
		str,
		"f12",
		"pressed"
	},
	["page up"] = {
		str,
		"page up",
		"pressed"
	},
	["page down"] = {
		str,
		"page down",
		"pressed"
	},
	home = {
		str,
		"home",
		"pressed"
	},
	["end"] = {
		str,
		"end",
		"pressed"
	},
	["left ctrl"] = {
		str,
		"left ctrl",
		"held"
	},
	["left shift"] = {
		str,
		"left shift",
		"held"
	},
	["right ctrl"] = {
		str,
		"right ctrl",
		"held"
	},
	["left alt"] = {
		str,
		"left alt",
		"held"
	},
	right_key = {
		str,
		"right",
		"pressed"
	},
	left_key = {
		str,
		"left",
		"pressed"
	},
	up_key = {
		str,
		"up",
		"held"
	},
	down_key = {
		str,
		"down",
		"held"
	},
	enter_key = {
		str,
		"enter",
		"pressed"
	},
	backspace = {
		str,
		"backspace",
		"pressed"
	},
	numpad_plus = {
		str,
		"numpad +",
		"pressed"
	},
	numpad_minus = {
		str,
		"num -",
		"pressed"
	},
	a = {
		str,
		"a",
		"pressed"
	},
	b = {
		str,
		"b",
		"pressed"
	},
	c = {
		str,
		"c",
		"pressed"
	},
	d = {
		str,
		"d",
		"pressed"
	},
	e = {
		str,
		"e",
		"pressed"
	},
	f = {
		str,
		"f",
		"pressed"
	},
	g = {
		str,
		"g",
		"pressed"
	},
	h = {
		str,
		"h",
		"pressed"
	},
	h_held = {
		str,
		"h",
		"held"
	},
	i = {
		str,
		"i",
		"pressed"
	},
	j = {
		str,
		"j",
		"pressed"
	},
	k = {
		str,
		"k",
		"pressed"
	},
	l = {
		str,
		"l",
		"pressed"
	},
	m = {
		str,
		"m",
		"pressed"
	},
	n = {
		str,
		"n",
		"pressed"
	},
	o = {
		str,
		"o",
		"pressed"
	},
	p = {
		str,
		"p",
		"pressed"
	},
	q = {
		str,
		"q",
		"pressed"
	},
	r = {
		str,
		"r",
		"pressed"
	},
	s = {
		str,
		"s",
		"pressed"
	},
	t = {
		str,
		"t",
		"pressed"
	},
	u = {
		str,
		"u",
		"pressed"
	},
	v = {
		str,
		"v",
		"pressed"
	},
	w = {
		str,
		"w",
		"pressed"
	},
	x = {
		str,
		"x",
		"pressed"
	},
	y = {
		str,
		"y",
		"pressed"
	},
	z = {
		str,
		"z",
		"pressed"
	},
	esc = {
		str,
		"esc",
		"pressed"
	},
	activate_chat_input = {
		str,
		"y",
		"pressed"
	},
	console_open_key = {
		str,
		"end",
		"pressed"
	},
	console_favorite_key = {
		str,
		"f",
		"pressed"
	},
	console_search_key = {
		str,
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
local DebugKeymap = DebugKeymap
local keymaps_key_approved = InputUtils.keymaps_key_approved("win32")

keymaps_key_approved = not keymaps_key_approved and tbl
DebugKeymap.win32 = keymaps_key_approved

local DebugInputFilters = DebugInputFilters
local keymaps_key_approved_2 = InputUtils.keymaps_key_approved("win32")

keymaps_key_approved_2 = not keymaps_key_approved_2 and {
	console_mod_key = {
		filter_type = "or",
		input_mappings = {
			["left ctrl"] = "left ctrl",
			["right ctrl"] = "right ctrl"
		}
	}
}
DebugInputFilters.win32 = keymaps_key_approved_2

local DebugKeymap_2 = DebugKeymap
local keymaps_key_approved_3 = InputUtils.keymaps_key_approved("xb1")

keymaps_key_approved_3 = not keymaps_key_approved_3 and {
	left_thumb = {
		"gamepad",
		"left_thumb",
		"held"
	},
	right_thumb = {
		"gamepad",
		"right_thumb",
		"held"
	},
	right_trigger = {
		"gamepad",
		"right_trigger",
		"held"
	},
	right_trigger_soft = {
		"gamepad",
		"right_trigger",
		"soft_button"
	},
	right_shoulder = {
		"gamepad",
		"right_shoulder",
		"held"
	},
	left_trigger = {
		"gamepad",
		"left_trigger",
		"held"
	},
	left_trigger_soft = {
		"gamepad",
		"left_trigger",
		"soft_button"
	},
	left_shoulder = {
		"gamepad",
		"left_shoulder",
		"held"
	},
	d_down = {
		"gamepad",
		"d_down",
		"pressed"
	},
	d_left = {
		"gamepad",
		"d_left",
		"pressed"
	},
	d_right = {
		"gamepad",
		"d_right",
		"pressed"
	},
	d_up = {
		"gamepad",
		"d_up",
		"pressed"
	},
	x = {
		"gamepad",
		"x",
		"pressed"
	},
	y = {
		"gamepad",
		"y",
		"pressed"
	},
	b = {
		"gamepad",
		"b",
		"pressed"
	},
	exclusive_right_key = {
		"gamepad",
		"d_right",
		"pressed"
	},
	left_key = {
		"gamepad",
		"d_left",
		"pressed"
	},
	up_key = {
		"gamepad",
		"d_up",
		"held"
	},
	down_key = {
		"gamepad",
		"d_down",
		"held"
	},
	right_shoulder_held = {
		"gamepad",
		"right_shoulder",
		"held"
	},
	look_raw = {
		"gamepad",
		"right",
		"axis"
	},
	console_favorite_key = {
		"gamepad",
		"y",
		"pressed"
	},
	["left ctrl"] = {},
	["left shift"] = {}
}
DebugKeymap_2.xb1 = keymaps_key_approved_3

local DebugInputFilters_2 = DebugInputFilters
local keymaps_key_approved_4 = InputUtils.keymaps_key_approved("xb1")

keymaps_key_approved_4 = not keymaps_key_approved_4 and {
	n_switch = {
		filter_type = "and",
		input_mappings = {
			right_trigger = "right_trigger",
			d_left = "d_left",
			left_thumb = "left_thumb"
		}
	},
	n = {
		filter_type = "and",
		input_mappings = {
			right_trigger = "right_trigger",
			d_up = "d_up",
			left_thumb = "left_thumb"
		}
	},
	o = {
		filter_type = "and",
		input_mappings = {
			left_trigger = "left_trigger",
			d_left = "d_left",
			left_thumb = "left_thumb"
		}
	},
	p = {
		filter_type = "and",
		input_mappings = {
			d_up = "d_up",
			left_trigger = "left_trigger",
			left_thumb = "left_thumb"
		}
	},
	l = {
		filter_type = "and",
		input_mappings = {
			d_down = "d_down",
			left_thumb = "left_thumb"
		}
	},
	u = {
		filter_type = "and",
		input_mappings = {
			left_trigger = "left_trigger",
			d_down = "d_down",
			left_thumb = "left_thumb"
		}
	},
	c = {
		filter_type = "and",
		input_mappings = {
			d_up = "d_up",
			left_thumb = "left_thumb"
		}
	},
	home = {
		filter_type = "and",
		input_mappings = {
			x = "x",
			right_thumb = "right_thumb"
		}
	},
	v = {
		filter_type = "and",
		input_mappings = {
			y = "y",
			right_thumb = "right_thumb"
		}
	},
	show_behaviour = {
		filter_type = "and",
		input_mappings = {
			b = "b",
			right_thumb = "right_thumb"
		}
	},
	right_key = {
		filter_type = "and",
		input_mappings = {
			d_right = "d_right",
			left_thumb = "left_thumb"
		}
	},
	time_scale = {
		filter_type = "and",
		input_mappings = {
			right_thumb = "right_thumb",
			left_thumb = "left_thumb"
		}
	},
	time_scale_axis = {
		filter_type = "sub",
		input_mappings = {
			right_trigger_soft = "right_trigger_soft",
			left_trigger_soft = "left_trigger_soft"
		}
	}
}
DebugInputFilters_2.xb1 = keymaps_key_approved_4

local DebugKeymap_3 = DebugKeymap
local keymaps_key_approved_5 = InputUtils.keymaps_key_approved("ps4")

keymaps_key_approved_5 = not keymaps_key_approved_5 and {
	l3 = {
		"gamepad",
		"l3",
		"held"
	},
	r3 = {
		"gamepad",
		"r3",
		"held"
	},
	l2 = {
		"gamepad",
		"l2",
		"held"
	},
	r2 = {
		"gamepad",
		"r2",
		"held"
	},
	l1 = {
		"gamepad",
		"l1",
		"held"
	},
	r1 = {
		"gamepad",
		"r1",
		"held"
	},
	l2_soft = {
		"gamepad",
		"l2",
		"soft_button"
	},
	r2_soft = {
		"gamepad",
		"r2",
		"soft_button"
	},
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
	circle = {
		"gamepad",
		"circle",
		"pressed"
	},
	b = {
		"gamepad",
		"b",
		"pressed"
	},
	mouse_middle_held = {
		"gamepad",
		"l2",
		"held"
	},
	exclusive_right_key = {
		"gamepad",
		"right",
		"pressed"
	},
	left_key = {
		"gamepad",
		"left",
		"pressed"
	},
	up_key = {
		"gamepad",
		"up",
		"held"
	},
	down_key = {
		"gamepad",
		"down",
		"held"
	},
	right_shoulder_held = {
		"gamepad",
		"right_shoulder",
		"held"
	},
	look_raw = {
		"gamepad",
		"right",
		"axis"
	},
	console_favorite_key = {
		"gamepad",
		"triangle",
		"pressed"
	}
}
DebugKeymap_3.ps4 = keymaps_key_approved_5

local DebugKeymap_4 = DebugKeymap
local keymaps_key_approved_6 = InputUtils.keymaps_key_approved("ps_pad")

keymaps_key_approved_6 = not keymaps_key_approved_6 and {
	l3 = {
		"ps_pad",
		"l3",
		"held"
	},
	r3 = {
		"ps_pad",
		"r3",
		"held"
	},
	l2 = {
		"ps_pad",
		"l2",
		"held"
	},
	r2 = {
		"ps_pad",
		"r2",
		"held"
	},
	l1 = {
		"ps_pad",
		"l1",
		"held"
	},
	r1 = {
		"ps_pad",
		"r1",
		"held"
	},
	l2_soft = {
		"ps_pad",
		"l2",
		"soft_button"
	},
	r2_soft = {
		"ps_pad",
		"r2",
		"soft_button"
	},
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
	circle = {
		"ps_pad",
		"circle",
		"pressed"
	},
	b = {
		"ps_pad",
		"circle",
		"pressed"
	},
	mouse_middle_held = {
		"ps_pad",
		"l2",
		"held"
	},
	exclusive_right_key = {
		"ps_pad",
		"right",
		"pressed"
	},
	left_key = {
		"ps_pad",
		"left",
		"pressed"
	},
	up_key = {
		"ps_pad",
		"up",
		"held"
	},
	down_key = {
		"ps_pad",
		"down",
		"held"
	},
	right_shoulder_held = {
		"ps_pad",
		"r1",
		"held"
	},
	look_raw = {
		"ps_pad",
		"right",
		"axis"
	},
	console_favorite_key = {
		"ps_pad",
		"triangle",
		"pressed"
	}
}
DebugKeymap_4.ps_pad = keymaps_key_approved_6

local tbl_2 = {
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
local DebugInputFilters_3 = DebugInputFilters
local keymaps_key_approved_7 = InputUtils.keymaps_key_approved("ps4")

keymaps_key_approved_7 = not keymaps_key_approved_7 and tbl_2
DebugInputFilters_3.ps4 = keymaps_key_approved_7

local DebugInputFilters_4 = DebugInputFilters
local keymaps_key_approved_8 = InputUtils.keymaps_key_approved("ps_pad")

keymaps_key_approved_8 = not keymaps_key_approved_8 and tbl_2
DebugInputFilters_4.ps_pad = keymaps_key_approved_8
