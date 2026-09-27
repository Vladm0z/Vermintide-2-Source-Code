-- chunkname: @scripts/imgui/imgui_hint_ui.lua

ImguiHintUI = class(ImguiHintUI)

local Gui = Gui
local Imgui = Imgui
local flag = true

ImguiHintUI.init = function (self)
	-- function 1
	self._active = false
	self._first_launch = true
end

ImguiHintUI.update = function (self)
	-- function 2
	if not flag then
		self:init()

		flag = false
	end
end

ImguiHintUI.on_show = function (self)
	-- function 3
	self._active = true
end

ImguiHintUI.on_hide = function (self)
	-- function 4
	self._active = false
end

ImguiHintUI.draw = function (self, arg_5_1)
	-- function 5
	return (self:_do_main_window())
end

ImguiHintUI.is_persistent = function (arg_6_0)
	-- function 6
	return true
end

ImguiHintUI._do_main_window = function (self)
	-- function 7
	if not self._first_launch then
		local resolution, var_7_1 = Application.resolution()

		Imgui.set_next_window_size(resolution * 0.25, var_7_1 * 0.7)
	end

	local begin_window = Imgui.begin_window("Hint UI Debug", "menu_bar")

	Imgui.text("Add Hint to the Hint Templates settings file \nand verify the info from here")
	Imgui.separator()
	self:_do_clear_saved_hints_button()
	Imgui.dummy(2, 5)
	self:_do_hint_buttons()
	Imgui:end_window()

	return begin_window
end

ImguiHintUI._do_hint_buttons = function (arg_8_0)
	-- function 8
	for k, v in pairs(HintTemplates) do
		if not Imgui.button(k, 250, 25) then
			Managers.state.event:trigger("ui_show_hint", k)
		end
	end
end

local function fn()
	-- function 9
	print("ImguiHintUI - Cleared save hints from SaveData")
end

local function fn_2()
	-- function 10
	SaveData.viewed_hints = {}

	Managers.save:auto_save(SaveFileName, SaveData, fn)
end

ImguiHintUI._do_clear_saved_hints_button = function (arg_11_0)
	-- function 11
	if not Imgui.button("Clear Saved Hints", 250, 35) then
		fn_2()
	end

	Managers.ui:ingame_ui().hint_ui_handler:parse_unseen_hints()
end
