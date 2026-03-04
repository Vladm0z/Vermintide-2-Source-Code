-- chunkname: @scripts/utils/debug_keymap.lua

require("scripts/utils/input_helper")

DebugKeymap = {}
DebugInputFilters = {}

local var_0_0

var_0_0 = BUILD == "dev" or BUILD == "debug"

local var_0_1 = "keyboard"
local var_0_2 = {
	f1 = {
		var_0_1,
		"f1",
		"pressed"
	},
	f2 = {
		var_0_1,
		"f2",
		"pressed"
	},
	f3 = {
		var_0_1,
		"f3",
		"pressed"
	},
	f4 = {
		var_0_1,
		"f4",
		"pressed"
	},
	f5 = {
		var_0_1,
		"f5",
		"pressed"
	},
	f6 = {
		var_0_1,
		"f6",
		"pressed"
	},
	f7 = {
		var_0_1,
		"f7",
		"pressed"
	},
	f8 = {
		var_0_1,
		"f8",
		"pressed"
	},
	f9 = {
		var_0_1,
		"f9",
		"pressed"
	},
	f10 = {
		var_0_1,
		"f10",
		"pressed"
	},
	f11 = {
		var_0_1,
		"f11",
		"pressed"
	},
	f12 = {
		var_0_1,
		"f12",
		"pressed"
	},
	["page up"] = {
		var_0_1,
		"page up",
		"pressed"
	},
	["page down"] = {
		var_0_1,
		"page down",
		"pressed"
	},
	home = {
		var_0_1,
		"home",
		"pressed"
	},
	["end"] = {
		var_0_1,
		"end",
		"pressed"
	},
	["left ctrl"] = {
		var_0_1,
		"left ctrl",
		"held"
	},
	["left shift"] = {
		var_0_1,
		"left shift",
		"held"
	},
	["right ctrl"] = {
		var_0_1,
		"right ctrl",
		"held"
	},
	["left alt"] = {
		var_0_1,
		"left alt",
		"held"
	},
	right_key = {
		var_0_1,
		"right",
		"pressed"
	},
	left_key = {
		var_0_1,
		"left",
		"pressed"
	},
	up_key = {
		var_0_1,
		"up",
		"held"
	},
	down_key = {
		var_0_1,
		"down",
		"held"
	},
	enter_key = {
		var_0_1,
		"enter",
		"pressed"
	},
	backspace = {
		var_0_1,
		"backspace",
		"pressed"
	},
	numpad_plus = {
		var_0_1,
		"numpad +",
		"pressed"
	},
	numpad_minus = {
		var_0_1,
		"num -",
		"pressed"
	},
	a = {
		var_0_1,
		"a",
		"pressed"
	},
	b = {
		var_0_1,
		"b",
		"pressed"
	},
	c = {
		var_0_1,
		"c",
		"pressed"
	},
	d = {
		var_0_1,
		"d",
		"pressed"
	},
	e = {
		var_0_1,
		"e",
		"pressed"
	},
	f = {
		var_0_1,
		"f",
		"pressed"
	},
	g = {
		var_0_1,
		"g",
		"pressed"
	},
	h = {
		var_0_1,
		"h",
		"pressed"
	},
	h_held = {
		var_0_1,
		"h",
		"held"
	},
	i = {
		var_0_1,
		"i",
		"pressed"
	},
	j = {
		var_0_1,
		"j",
		"pressed"
	},
	k = {
		var_0_1,
		"k",
		"pressed"
	},
	l = {
		var_0_1,
		"l",
		"pressed"
	},
	m = {
		var_0_1,
		"m",
		"pressed"
	},
	n = {
		var_0_1,
		"n",
		"pressed"
	},
	o = {
		var_0_1,
		"o",
		"pressed"
	},
	p = {
		var_0_1,
		"p",
		"pressed"
	},
	q = {
		var_0_1,
		"q",
		"pressed"
	},
	r = {
		var_0_1,
		"r",
		"pressed"
	},
	s = {
		var_0_1,
		"s",
		"pressed"
	},
	t = {
		var_0_1,
		"t",
		"pressed"
	},
	u = {
		var_0_1,
		"u",
		"pressed"
	},
	v = {
		var_0_1,
		"v",
		"pressed"
	},
	w = {
		var_0_1,
		"w",
		"pressed"
	},
	x = {
		var_0_1,
		"x",
		"pressed"
	},
	y = {
		var_0_1,
		"y",
		"pressed"
	},
	z = {
		var_0_1,
		"z",
		"pressed"
	},
	esc = {
		var_0_1,
		"esc",
		"pressed"
	},
	activate_chat_input = {
		var_0_1,
		"y",
		"pressed"
	},
	console_open_key = {
		var_0_1,
		"end",
		"pressed"
	},
	console_favorite_key = {
		var_0_1,
		"f",
		"pressed"
	},
	console_search_key = {
		var_0_1,
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

DebugKeymap.win32 = InputUtils.keymaps_key_approved("win32") and var_0_2
DebugInputFilters.win32 = InputUtils.keymaps_key_approved("win32") and {
	console_mod_key = {
		filter_type = "or",
		input_mappings = {
			["left ctrl"] = "left ctrl",
			["right ctrl"] = "right ctrl"
		}
	}
}
DebugKeymap.xb1 = InputUtils.keymaps_key_approved("xb1") and {
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
DebugInputFilters.xb1 = InputUtils.keymaps_key_approved("xb1") and {
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
DebugKeymap.ps4 = InputUtils.keymaps_key_approved("ps4") and {
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
DebugKeymap.ps_pad = InputUtils.keymaps_key_approved("ps_pad") and {
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

local var_0_3 = {
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

DebugInputFilters.ps4 = InputUtils.keymaps_key_approved("ps4") and var_0_3
DebugInputFilters.ps_pad = InputUtils.keymaps_key_approved("ps_pad") and var_0_3
