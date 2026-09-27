-- chunkname: @scripts/managers/input/input_aux.lua

local InputAux = InputAux

InputAux = InputAux or {}
InputAux = InputAux

local InputAux_2 = InputAux
local input_device_mapping = InputAux_2.input_device_mapping

input_device_mapping = input_device_mapping or {
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
InputAux_2.input_device_mapping = input_device_mapping

if not InputAux_2.input_device_mapping.ps_pad then
	InputAux_2.input_device_mapping.ps_pad = {}

	local gamepad = InputAux_2.input_device_mapping.gamepad

	for i, v in ipairs(gamepad) do
		if v.type() == "sce_pad" then
			InputAux_2.input_device_mapping.ps_pad[#InputAux_2.input_device_mapping.ps_pad + 1] = v
		end
	end
end

if not InputAux_2.input_device_type_lookup then
	InputAux_2.input_device_type_lookup = {}

	for k, v_2 in pairs(InputAux_2.input_device_mapping) do
		for i_2, v_3 in ipairs(v_2) do
			InputAux_2.input_device_type_lookup[v_3] = k
		end
	end
end

InputAux_2.input_map_types = {
	soft_button = "number",
	released = "boolean",
	axis = "Vector3",
	pressed = "boolean",
	held = "boolean"
}

InputAux_2.get_device_type = function (arg_1_0)
	-- function 1
	return InputAux_2.input_device_type_lookup[arg_1_0]
end

InputAux_2.remove_device = function (arg_2_0, arg_2_1)
	-- function 2
	local find = table.find(InputAux_2.input_device_mapping[arg_2_0], arg_2_1)

	fassert(find, "[InputAux] There is no controller with the name %s available", arg_2_1.name())
	table.remove(InputAux_2.input_device_mapping[arg_2_0], find)
end

InputAux_2.add_device = function (arg_3_0, arg_3_1)
	-- function 3
	InputAux_2.input_device_mapping[arg_3_0][#InputAux_2.input_device_mapping[arg_3_0] + 1] = arg_3_1
end

InputAux_2.combination_functions = {
	max = math.max,
	min = math.min,
	add = function (arg_4_0, arg_4_1)
		-- function 4
		return arg_4_0 + arg_4_1
	end,
	sub = function (arg_5_0, arg_5_1)
		-- function 5
		return arg_5_0 - arg_5_1
	end,
	mul = function (arg_6_0, arg_6_1)
		-- function 6
		return arg_6_0 * arg_6_1
	end,
	avg = function (arg_7_0, arg_7_1)
		-- function 7
		return (arg_7_0 + arg_7_1) / 2
	end,
	["or"] = function (arg_8_0, arg_8_1)
		-- function 8
		return arg_8_0 or arg_8_1
	end,
	["and"] = function (arg_9_0, arg_9_1)
		-- function 9
		return not arg_9_0 and arg_9_1
	end
}
InputAux_2.default_values_for_types = {
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
