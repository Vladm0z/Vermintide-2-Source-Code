-- chunkname: @scripts/imgui/imgui_deus_load_level.lua

ImguiDeusLoadLevel = class(ImguiDeusLoadLevel)

local var_0_0 = {
	"normal",
	"hard",
	"harder",
	"hardest",
	"cataclysm"
}
local var_0_1 = {}

if DEUS_LEVEL_SETTINGS then
	for iter_0_0, iter_0_1 in pairs(DEUS_LEVEL_SETTINGS) do
		var_0_1[#var_0_1 + 1] = iter_0_0
	end
end

table.sort(var_0_1)

ImguiDeusLoadLevel.init = function (arg_1_0)
	arg_1_0._base_level_index = 1
	arg_1_0._path_index = 1
	arg_1_0._theme_index = 1
	arg_1_0._difficulty_index = 1
	arg_1_0._progress = 0
	arg_1_0._level_seed = 0
end

ImguiDeusLoadLevel.update = function (arg_2_0)
	return
end

ImguiDeusLoadLevel.is_persistent = function (arg_3_0)
	return false
end

ImguiDeusLoadLevel.draw = function (arg_4_0, arg_4_1)
	local var_4_0 = Managers.mechanism:current_mechanism_name()
	local var_4_1 = Imgui.begin_window("DeusLoadLevel", "always_auto_resize")

	if var_4_0 ~= "deus" then
		Imgui.text("This UI only works when playing with the deus mechanism.")
	else
		local var_4_2 = arg_4_0._base_level_index

		arg_4_0._base_level_index = Imgui.combo("Level", arg_4_0._base_level_index, var_0_1)

		if var_4_2 ~= arg_4_0._base_level_index then
			arg_4_0._path_index = 1
			arg_4_0._theme_index = 1
		end

		local var_4_3 = var_0_1[arg_4_0._base_level_index]
		local var_4_4 = DEUS_LEVEL_SETTINGS[var_4_3]
		local var_4_5

		if var_4_3 ~= "arena_belakor" then
			arg_4_0._path_index = Imgui.combo("Path", arg_4_0._path_index, var_4_4.paths)
			arg_4_0._theme_index = Imgui.combo("Theme", arg_4_0._theme_index, var_4_4.themes)
			arg_4_0._with_belakor = Imgui.checkbox("With Belakor", not not arg_4_0._with_belakor)
			var_4_5 = arg_4_0._with_belakor
		else
			Imgui.checkbox("With Belakor", true)

			var_4_5 = true
		end

		arg_4_0._difficulty_index = Imgui.combo("Difficulty", arg_4_0._difficulty_index, var_0_0)
		arg_4_0._progress = Imgui.slider_float("Run progress", arg_4_0._progress, 0, 0.999)
		arg_4_0._level_seed = Imgui.input_int("Level seed", arg_4_0._level_seed)

		Imgui.same_line()

		if Imgui.button("Randomize seed") then
			arg_4_0._level_seed = math.random_seed()
		end

		Imgui.text_colored("If entered manually: Press return to confirm the entered seed", 255, 255, 255, 128)
		Imgui.spacing()

		local var_4_6
		local var_4_7 = var_4_3 == "arena_belakor" and "arena_belakor" or var_4_3 .. "_" .. var_4_4.themes[arg_4_0._theme_index] .. "_path" .. var_4_4.paths[arg_4_0._path_index]

		if Imgui.button("Load") then
			Managers.mechanism:game_mechanism():debug_load_deus_level(var_4_7, var_0_0[arg_4_0._difficulty_index], arg_4_0._progress, arg_4_0._level_seed, var_4_5)
		end
	end

	Imgui.end_window()

	return var_4_1
end
