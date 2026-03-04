-- chunkname: @scripts/managers/input/input_aux.lua

InputAux = InputAux or {}

local var_0_0 = InputAux

var_0_0.input_device_mapping = var_0_0.input_device_mapping or {
	gamepad = {
		rawget(_G, "Pad1"),
		rawget(_G, "Pad2"),
		rawget(_G, "Pad3"),
		rawget(_G, "Pad4"),
		rawget(_G, "Pad5"),
		rawget(_G, "Pad6"),
		rawget(_G, "Pad7"),
		rawget(_G, "Pad8")
	},
	mouse = {
		rawget(_G, "Mouse")
	},
	keyboard = {
		rawget(_G, "Keyboard")
	},
	network = {
		NetworkInputDevice
	},
	recording = {
		PlayRecordingInputDevice
	}
}

if not var_0_0.input_device_mapping.ps_pad then
	var_0_0.input_device_mapping.ps_pad = {}

	local var_0_1 = var_0_0.input_device_mapping.gamepad

	for iter_0_0, iter_0_1 in ipairs(var_0_1) do
		if iter_0_1.type() == "sce_pad" then
			var_0_0.input_device_mapping.ps_pad[#var_0_0.input_device_mapping.ps_pad + 1] = iter_0_1
		end
	end
end

if not var_0_0.input_device_type_lookup then
	var_0_0.input_device_type_lookup = {}

	for iter_0_2, iter_0_3 in pairs(var_0_0.input_device_mapping) do
		for iter_0_4, iter_0_5 in ipairs(iter_0_3) do
			var_0_0.input_device_type_lookup[iter_0_5] = iter_0_2
		end
	end
end

var_0_0.input_map_types = {
	soft_button = "number",
	released = "boolean",
	axis = "Vector3",
	pressed = "boolean",
	held = "boolean"
}

var_0_0.get_device_type = function (arg_1_0)
	return var_0_0.input_device_type_lookup[arg_1_0]
end

var_0_0.remove_device = function (arg_2_0, arg_2_1)
	local var_2_0 = table.find(var_0_0.input_device_mapping[arg_2_0], arg_2_1)

	fassert(var_2_0, "[InputAux] There is no controller with the name %s available", arg_2_1.name())
	table.remove(var_0_0.input_device_mapping[arg_2_0], var_2_0)
end

var_0_0.add_device = function (arg_3_0, arg_3_1)
	var_0_0.input_device_mapping[arg_3_0][#var_0_0.input_device_mapping[arg_3_0] + 1] = arg_3_1
end

var_0_0.combination_functions = {
	max = math.max,
	min = math.min,
	add = function (arg_4_0, arg_4_1)
		return arg_4_0 + arg_4_1
	end,
	sub = function (arg_5_0, arg_5_1)
		return arg_5_0 - arg_5_1
	end,
	mul = function (arg_6_0, arg_6_1)
		return arg_6_0 * arg_6_1
	end,
	avg = function (arg_7_0, arg_7_1)
		return (arg_7_0 + arg_7_1) / 2
	end,
	["or"] = function (arg_8_0, arg_8_1)
		return arg_8_0 or arg_8_1
	end,
	["and"] = function (arg_9_0, arg_9_1)
		return arg_9_0 and arg_9_1
	end
}
var_0_0.default_values_for_types = {
	boolean = false,
	number = 0
}
TestKeyMap = {
	super_attack = {
		input_mappings = {
			{
				"keyboard",
				"left shift",
				"held",
				"mouse",
				"right",
				"pressed"
			}
		}
	},
	weak_attack = {
		input_mappings = {
			{
				"keyboard",
				"k",
				"held"
			}
		}
	},
	move_up = {
		combination_type = "max",
		input_mappings = {
			{
				"keyboard",
				"oem_comma (< ,)",
				"soft_button"
			},
			{
				"mouse",
				"right",
				"soft_button"
			}
		}
	},
	move_down = {
		input_mappings = {
			{
				"keyboard",
				"o",
				"soft_button"
			}
		}
	},
	move_left = {
		input_mappings = {
			{
				"keyboard",
				"e",
				"soft_button"
			}
		}
	},
	move_right = {
		input_mappings = {
			{
				"keyboard",
				"a",
				"soft_button"
			}
		}
	}
}
TestFilters = {
	move = {
		filter_type = "virtual_axis",
		input_mappings = {
			down = "move_down",
			up = "move_up",
			left = "move_left",
			right = "move_right"
		}
	}
}
