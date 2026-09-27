-- chunkname: @scripts/utils/debug_key_handler.lua

local script_data = script_data
local debug_key_handler_visible = script_data.debug_key_handler_visible

debug_key_handler_visible = debug_key_handler_visible or Development.parameter("debug_key_handler_visible")
script_data.debug_key_handler_visible = debug_key_handler_visible

local tbl = {}

local function fn(arg_1_0)
	-- function 1
	if tbl[arg_1_0] == nil then
		tbl[arg_1_0] = arg_1_0 .. "(M)"
	end

	return tbl[arg_1_0]
end

local tbl_2 = {
	["left shift"] = {},
	["right shift"] = {},
	["left ctrl"] = {},
	["right ctrl"] = {},
	["left alt"] = {}
}

local function fn_2(arg_2_0, arg_2_1, arg_2_2)
	-- function 2
	local var_2_0 = tbl_2[arg_2_1]

	if var_2_0[arg_2_0] == nil then
		var_2_0[arg_2_0] = {
			exist = arg_2_1 .. "+" .. arg_2_0,
			missing = arg_2_1 .. "(M)+" .. arg_2_0
		}
	end

	local missing

	if not arg_2_2 then
		missing = var_2_0[arg_2_0].missing

		if not missing then
			-- Nothing
		end
	end

	missing = var_2_0[arg_2_0].exist

	::label_2_0::

	return missing
end

local DebugKeyHandler = DebugKeyHandler

DebugKeyHandler = DebugKeyHandler or {
	num_keys = 0,
	keys = {}
}
DebugKeyHandler = DebugKeyHandler

local DebugKeyHandler_2 = DebugKeyHandler

DebugKeyHandler_2.setup = function (arg_3_0, arg_3_1)
	-- function 3
	DebugKeyHandler_2.gui = World.create_screen_gui(arg_3_0, "material", "materials/fonts/gw_fonts", "immediate")
	DebugKeyHandler_2.enabled = true
	DebugKeyHandler_2.input_manager = arg_3_1
	DebugKeyHandler_2.current_y = 0
end

DebugKeyHandler_2.set_enabled = function (arg_4_0)
	-- function 4
	DebugKeyHandler_2.enabled = arg_4_0
end

local tbl_3 = {
	"left ctrl",
	"left shift",
	"right ctrl",
	"left alt"
}

DebugKeyHandler_2.key_pressed = function (arg_5_0, arg_5_1, arg_5_2, arg_5_3, arg_5_4)
	-- function 5
	if not DebugKeyHandler_2.enabled and not IS_LINUX then
		return
	end

	local get_service = DebugKeyHandler_2.input_manager:get_service(arg_5_4 or "Debug")

	if not get_service then
		return
	end

	if not script_data.debug_key_handler_visible then
		DebugKeyHandler_2.num_keys = DebugKeyHandler_2.num_keys + 1
		arg_5_2 = arg_5_2 or "misc"

		local var_5_1 = DebugKeyHandler_2.keys[arg_5_2]

		if var_5_1 == nil then
			var_5_1 = {}
			DebugKeyHandler_2.keys[arg_5_2] = var_5_1
		end

		local flag = not get_service:has(arg_5_0) and arg_5_0 and fn(arg_5_0)

		if not arg_5_3 then
			flag = not get_service:has(arg_5_0) and fn_2(arg_5_0, arg_5_3) and fn_2(arg_5_0, arg_5_3, true)
		end

		var_5_1[flag] = arg_5_1
	end

	local flag_2 = true

	if not arg_5_3 then
		flag_2 = get_service:get(arg_5_3)
	else
		for i = 1, #tbl_3 do
			local var_5_4 = tbl_3[i]

			if var_5_4 == arg_5_0 or not get_service:get(var_5_4) then
				flag_2 = false

				break
			end
		end
	end

	return not flag_2 and get_service:get(arg_5_0)
end

DebugKeyHandler_2.frame_clear = function ()
	-- function 6
	DebugKeyHandler_2.num_keys = 0

	for k, v in pairs(DebugKeyHandler_2.keys) do
		if next(v) == nil then
			DebugKeyHandler_2.keys[k] = nil
		end

		table.clear(v)
	end
end

local num = 16
local str = "arial"
local str_2 = "materials/fonts/" .. str

DebugKeyHandler_2.render = function ()
	-- function 7
	if not script_data.debug_key_handler_visible then
		return
	end

	local num_2 = 1

	if not DebugKeyHandler_2.enabled then
		num_2 = 0.3
	end

	local var_7_1 = Color(num_2 * 250, 255, 255, 100)
	local var_7_2 = Color(num_2 * 250, 255, 255, 255)
	local var_7_3 = Color(num_2 * 250, 255, 120, 0)
	local var_7_4 = Color(num_2 * 255, 150, 150, 150)
	local resolution, var_7_6 = Application.resolution()
	local gui = DebugKeyHandler_2.gui
	local current_y = DebugKeyHandler_2.current_y

	DebugKeyHandler_2.current_y = math.lerp(current_y, var_7_6 / 2 + DebugKeyHandler_2.num_keys * num / 2 + table.size(DebugKeyHandler_2.keys) * num / 2, 0.1)

	local var_7_9 = Vector3(resolution - 230, current_y, 200)

	Gui.text(gui, "Debug keys", str_2, num, str, var_7_9, var_7_1)

	var_7_9.y = var_7_9.y - num * 1.5

	local flag = false

	for k, v in pairs(DebugKeyHandler_2.keys) do
		local y = var_7_9.y

		Gui.text(gui, k, str_2, num, str, var_7_9, var_7_2)

		var_7_9.y = var_7_9.y - num

		for k_2, v_2 in pairs(v) do
			Gui.text(gui, k_2, str_2, num, str, var_7_9, var_7_3)
			Gui.text(gui, v_2, str_2, num, str, var_7_9 + Vector3(80, 0, 0), var_7_4)

			var_7_9.y = var_7_9.y - num
		end

		var_7_9.y = var_7_9.y - num / 2
	end

	Gui.rect(gui, Vector3(resolution - 250, var_7_9.y + num, 100), Vector2(250, current_y - var_7_9.y), Color(num_2 * 240, 25, 50, 25))

	if not DebugKeyHandler_2.enabled then
		Gui.rect(gui, Vector3(resolution - 250, var_7_9.y + num, 300), Vector2(250, current_y - var_7_9.y), Color(num_2 * 200, 20, 20, 20))
	end
end
