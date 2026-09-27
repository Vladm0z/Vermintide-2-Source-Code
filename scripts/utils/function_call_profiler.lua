-- chunkname: @scripts/utils/function_call_profiler.lua

local script_data = script_data

if _G.FunctionCallProfiler == nil then
	FunctionCallProfiler = {}
	FunctionCallProfiler.current_frame = 1
	FunctionCallProfiler.num_frames = 10
	FunctionCallProfiler.frames = {}

	for i = 1, FunctionCallProfiler.num_frames do
		FunctionCallProfiler.frames[i] = {}
	end
end

FunctionCallProfiler.setup = function (arg_1_0)
	-- function 1
	FunctionCallProfiler.world = arg_1_0
	FunctionCallProfiler.gui = World.create_screen_gui(arg_1_0, "material", "materials/fonts/gw_fonts", "immediate")
end

FunctionCallProfiler.destroy = function ()
	-- function 2
	World.destroy_gui(FunctionCallProfiler.gui)

	FunctionCallProfiler.world = nil
end

local num = 16
local str = "arial"
local str_2 = "materials/fonts/" .. str

FunctionCallProfiler.render = function ()
	-- function 3
	if not script_data.profile_function_calls then
		return
	end

	local num_frames = FunctionCallProfiler.num_frames
	local var_3_1 = Color(250, 255, 120, 0)
	local resolution, var_3_3 = Application.resolution()
	local gui = FunctionCallProfiler.gui
	local num_2 = FunctionCallProfiler.current_frame - 1
	local frames = FunctionCallProfiler.frames
	local num_3 = resolution / 2
	local num_4 = var_3_3 / 2
	local var_3_9 = Vector3(num_3, num_4 - num, 200)

	for i = 1, num_frames do
		num_2 = num_2 % num_frames + 1

		local var_3_10 = frames[num_2]

		for k, v in pairs(var_3_10) do
			Gui.text(gui, k .. "    " .. tostring(v), str_2, num, str, var_3_9, var_3_1)

			var_3_9.y = var_3_9.y - num * 1.5
		end

		var_3_9.y = var_3_9.y - num * 1.5
	end

	Gui.rect(gui, Vector3(num_3, var_3_9.y + num, 100), Vector2(250, num_4 - var_3_9.y), Color(240, 25, 50, 25))
end

FunctionCallProfiler.log_function_call = function (arg_4_0)
	-- function 4
	if not script_data.profile_function_calls then
		return
	end

	local current_frame = FunctionCallProfiler.current_frame
	local var_4_1 = FunctionCallProfiler.frames[current_frame]

	if var_4_1[arg_4_0] == nil then
		var_4_1[arg_4_0] = 0
	end

	var_4_1[arg_4_0] = var_4_1[arg_4_0] + 1
end

function LogFunctionCall(arg_5_0)
	-- function 5
	FunctionCallProfiler.log_function_call(arg_5_0)
end
