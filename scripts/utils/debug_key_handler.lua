-- chunkname: @scripts/utils/debug_key_handler.lua

script_data.debug_key_handler_visible = script_data.debug_key_handler_visible or Development.parameter("debug_key_handler_visible")

local var_0_0 = {}

local function var_0_1(arg_1_0)
	if var_0_0[arg_1_0] == nil then
		var_0_0[arg_1_0] = arg_1_0 .. "(M)"
	end

	return var_0_0[arg_1_0]
end

local var_0_2 = {
	["left shift"] = {},
	["right shift"] = {},
	["left ctrl"] = {},
	["right ctrl"] = {},
	["left alt"] = {}
}

local function var_0_3(arg_2_0, arg_2_1, arg_2_2)
	local var_2_0 = var_0_2[arg_2_1]

	if var_2_0[arg_2_0] == nil then
		var_2_0[arg_2_0] = {
			exist = arg_2_1 .. "+" .. arg_2_0,
			missing = arg_2_1 .. "(M)+" .. arg_2_0
		}
	end

	return arg_2_2 and var_2_0[arg_2_0].missing or var_2_0[arg_2_0].exist
end

DebugKeyHandler = DebugKeyHandler or {
	num_keys = 0,
	keys = {}
}

local var_0_4 = DebugKeyHandler

var_0_4.setup = function (arg_3_0, arg_3_1)
	var_0_4.gui = World.create_screen_gui(arg_3_0, "material", "materials/fonts/gw_fonts", "immediate")
	var_0_4.enabled = true
	var_0_4.input_manager = arg_3_1
	var_0_4.current_y = 0
end

var_0_4.set_enabled = function (arg_4_0)
	var_0_4.enabled = arg_4_0
end

local var_0_5 = {
	"left ctrl",
	"left shift",
	"right ctrl",
	"left alt"
}

var_0_4.key_pressed = function (arg_5_0, arg_5_1, arg_5_2, arg_5_3, arg_5_4)
	if not var_0_4.enabled or IS_LINUX then
		return
	end

	local var_5_0 = var_0_4.input_manager:get_service(arg_5_4 or "Debug")

	if not var_5_0 then
		return
	end

	if script_data.debug_key_handler_visible then
		var_0_4.num_keys = var_0_4.num_keys + 1
		arg_5_2 = arg_5_2 or "misc"

		local var_5_1 = var_0_4.keys[arg_5_2]

		if var_5_1 == nil then
			var_5_1 = {}
			var_0_4.keys[arg_5_2] = var_5_1
		end

		local var_5_2 = var_5_0:has(arg_5_0) and arg_5_0 or var_0_1(arg_5_0)

		if arg_5_3 then
			var_5_2 = var_5_0:has(arg_5_0) and var_0_3(arg_5_0, arg_5_3) or var_0_3(arg_5_0, arg_5_3, true)
		end

		var_5_1[var_5_2] = arg_5_1
	end

	local var_5_3 = true

	if arg_5_3 then
		var_5_3 = var_5_0:get(arg_5_3)
	else
		for iter_5_0 = 1, #var_0_5 do
			local var_5_4 = var_0_5[iter_5_0]

			if var_5_4 ~= arg_5_0 and var_5_0:get(var_5_4) then
				var_5_3 = false

				break
			end
		end
	end

	return var_5_3 and var_5_0:get(arg_5_0)
end

var_0_4.frame_clear = function ()
	var_0_4.num_keys = 0

	for iter_6_0, iter_6_1 in pairs(var_0_4.keys) do
		if next(iter_6_1) == nil then
			var_0_4.keys[iter_6_0] = nil
		end

		table.clear(iter_6_1)
	end
end

local var_0_6 = 16
local var_0_7 = "arial"
local var_0_8 = "materials/fonts/" .. var_0_7

var_0_4.render = function ()
	if not script_data.debug_key_handler_visible then
		return
	end

	local var_7_0 = 1

	if not var_0_4.enabled then
		var_7_0 = 0.3
	end

	local var_7_1 = Color(var_7_0 * 250, 255, 255, 100)
	local var_7_2 = Color(var_7_0 * 250, 255, 255, 255)
	local var_7_3 = Color(var_7_0 * 250, 255, 120, 0)
	local var_7_4 = Color(var_7_0 * 255, 150, 150, 150)
	local var_7_5, var_7_6 = Application.resolution()
	local var_7_7 = var_0_4.gui
	local var_7_8 = var_0_4.current_y

	var_0_4.current_y = math.lerp(var_7_8, var_7_6 / 2 + var_0_4.num_keys * var_0_6 / 2 + table.size(var_0_4.keys) * var_0_6 / 2, 0.1)

	local var_7_9 = Vector3(var_7_5 - 230, var_7_8, 200)

	Gui.text(var_7_7, "Debug keys", var_0_8, var_0_6, var_0_7, var_7_9, var_7_1)

	var_7_9.y = var_7_9.y - var_0_6 * 1.5

	local var_7_10 = false

	for iter_7_0, iter_7_1 in pairs(var_0_4.keys) do
		local var_7_11 = var_7_9.y

		Gui.text(var_7_7, iter_7_0, var_0_8, var_0_6, var_0_7, var_7_9, var_7_2)

		var_7_9.y = var_7_9.y - var_0_6

		for iter_7_2, iter_7_3 in pairs(iter_7_1) do
			Gui.text(var_7_7, iter_7_2, var_0_8, var_0_6, var_0_7, var_7_9, var_7_3)
			Gui.text(var_7_7, iter_7_3, var_0_8, var_0_6, var_0_7, var_7_9 + Vector3(80, 0, 0), var_7_4)

			var_7_9.y = var_7_9.y - var_0_6
		end

		var_7_9.y = var_7_9.y - var_0_6 / 2
	end

	Gui.rect(var_7_7, Vector3(var_7_5 - 250, var_7_9.y + var_0_6, 100), Vector2(250, var_7_8 - var_7_9.y), Color(var_7_0 * 240, 25, 50, 25))

	if not var_0_4.enabled then
		Gui.rect(var_7_7, Vector3(var_7_5 - 250, var_7_9.y + var_0_6, 300), Vector2(250, var_7_8 - var_7_9.y), Color(var_7_0 * 200, 20, 20, 20))
	end
end
