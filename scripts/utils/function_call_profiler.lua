-- chunkname: @scripts/utils/function_call_profiler.lua

local var_0_0 = script_data

if _G.FunctionCallProfiler == nil then
	FunctionCallProfiler = {}
	FunctionCallProfiler.current_frame = 1
	FunctionCallProfiler.num_frames = 10
	FunctionCallProfiler.frames = {}

	for iter_0_0 = 1, FunctionCallProfiler.num_frames do
		FunctionCallProfiler.frames[iter_0_0] = {}
	end
end

FunctionCallProfiler.setup = function (arg_1_0)
	FunctionCallProfiler.world = arg_1_0
	FunctionCallProfiler.gui = World.create_screen_gui(arg_1_0, "material", "materials/fonts/gw_fonts", "immediate")
end

FunctionCallProfiler.destroy = function ()
	World.destroy_gui(FunctionCallProfiler.gui)

	FunctionCallProfiler.world = nil
end

local var_0_1 = 16
local var_0_2 = "arial"
local var_0_3 = "materials/fonts/" .. var_0_2

FunctionCallProfiler.render = function ()
	if not var_0_0.profile_function_calls then
		return
	end

	local var_3_0 = FunctionCallProfiler.num_frames
	local var_3_1 = Color(250, 255, 120, 0)
	local var_3_2, var_3_3 = Application.resolution()
	local var_3_4 = FunctionCallProfiler.gui
	local var_3_5 = FunctionCallProfiler.current_frame - 1
	local var_3_6 = FunctionCallProfiler.frames
	local var_3_7 = var_3_2 / 2
	local var_3_8 = var_3_3 / 2
	local var_3_9 = Vector3(var_3_7, var_3_8 - var_0_1, 200)

	for iter_3_0 = 1, var_3_0 do
		var_3_5 = var_3_5 % var_3_0 + 1

		local var_3_10 = var_3_6[var_3_5]

		for iter_3_1, iter_3_2 in pairs(var_3_10) do
			Gui.text(var_3_4, iter_3_1 .. "    " .. tostring(iter_3_2), var_0_3, var_0_1, var_0_2, var_3_9, var_3_1)

			var_3_9.y = var_3_9.y - var_0_1 * 1.5
		end

		var_3_9.y = var_3_9.y - var_0_1 * 1.5
	end

	Gui.rect(var_3_4, Vector3(var_3_7, var_3_9.y + var_0_1, 100), Vector2(250, var_3_8 - var_3_9.y), Color(240, 25, 50, 25))
end

FunctionCallProfiler.log_function_call = function (arg_4_0)
	if not var_0_0.profile_function_calls then
		return
	end

	local var_4_0 = FunctionCallProfiler.current_frame
	local var_4_1 = FunctionCallProfiler.frames[var_4_0]

	if var_4_1[arg_4_0] == nil then
		var_4_1[arg_4_0] = 0
	end

	var_4_1[arg_4_0] = var_4_1[arg_4_0] + 1
end

function LogFunctionCall(arg_5_0)
	FunctionCallProfiler.log_function_call(arg_5_0)
end
