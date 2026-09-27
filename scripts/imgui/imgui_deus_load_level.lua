-- chunkname: @scripts/imgui/imgui_deus_load_level.lua

ImguiDeusLoadLevel = class(ImguiDeusLoadLevel)

local tbl = {
	"normal",
	"hard",
	"harder",
	"hardest",
	"cataclysm"
}
local tbl_2 = {}

if not DEUS_LEVEL_SETTINGS then
	for k, v in pairs(DEUS_LEVEL_SETTINGS) do
		tbl_2[#tbl_2 + 1] = k
	end
end

table.sort(tbl_2)

ImguiDeusLoadLevel.init = function (self)
	-- function 1
	self._base_level_index = 1
	self._path_index = 1
	self._theme_index = 1
	self._difficulty_index = 1
	self._progress = 0
	self._level_seed = 0
end

ImguiDeusLoadLevel.update = function (arg_2_0)
	-- function 2
	return
end

ImguiDeusLoadLevel.is_persistent = function (arg_3_0)
	-- function 3
	return false
end

ImguiDeusLoadLevel.draw = function (self, arg_4_1)
	-- function 4
	local current_mechanism_name = Managers.mechanism:current_mechanism_name()
	local begin_window = Imgui.begin_window("DeusLoadLevel", "always_auto_resize")

	if current_mechanism_name ~= "deus" then
		Imgui.text("This UI only works when playing with the deus mechanism.")
	else
		local _base_level_index = self._base_level_index

		self._base_level_index = Imgui.combo("Level", self._base_level_index, tbl_2)

		if _base_level_index ~= self._base_level_index then
			self._path_index = 1
			self._theme_index = 1
		end

		local var_4_3 = tbl_2[self._base_level_index]
		local var_4_4 = DEUS_LEVEL_SETTINGS[var_4_3]
		local var_4_5

		if var_4_3 ~= "arena_belakor" then
			self._path_index = Imgui.combo("Path", self._path_index, var_4_4.paths)
			self._theme_index = Imgui.combo("Theme", self._theme_index, var_4_4.themes)
			self._with_belakor = Imgui.checkbox("With Belakor", not not self._with_belakor)
			var_4_5 = self._with_belakor
		else
			Imgui.checkbox("With Belakor", true)

			var_4_5 = true
		end

		self._difficulty_index = Imgui.combo("Difficulty", self._difficulty_index, tbl)
		self._progress = Imgui.slider_float("Run progress", self._progress, 0, 0.999)
		self._level_seed = Imgui.input_int("Level seed", self._level_seed)

		Imgui.same_line()

		if not Imgui.button("Randomize seed") then
			self._level_seed = math.random_seed()
		end

		Imgui.text_colored("If entered manually: Press return to confirm the entered seed", 255, 255, 255, 128)
		Imgui.spacing()

		local var_4_6
		local flag

		flag = var_4_3 ~= "arena_belakor" or not "arena_belakor" or var_4_3 .. "_" .. var_4_4.themes[self._theme_index] .. "_path" .. var_4_4.paths[self._path_index]

		if not Imgui.button("Load") then
			Managers.mechanism:game_mechanism():debug_load_deus_level(flag, tbl[self._difficulty_index], self._progress, self._level_seed, var_4_5)
		end
	end

	Imgui.end_window()

	return begin_window
end
