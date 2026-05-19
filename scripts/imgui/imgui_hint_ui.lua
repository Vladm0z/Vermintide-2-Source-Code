-- chunkname: @scripts/imgui/imgui_hint_ui.lua

ImguiHintUI = class(ImguiHintUI)

local var_0_0 = Gui
local var_0_1 = Imgui
local var_0_2 = true

function ImguiHintUI.init(arg_1_0)
	arg_1_0._active = false
	arg_1_0._first_launch = true
end

function ImguiHintUI.update(arg_2_0)
	if var_0_2 then
		arg_2_0:init()

		var_0_2 = false
	end
end

function ImguiHintUI.on_show(arg_3_0)
	arg_3_0._active = true
end

function ImguiHintUI.on_hide(arg_4_0)
	arg_4_0._active = false
end

function ImguiHintUI.draw(arg_5_0, arg_5_1)
	return (arg_5_0:_do_main_window())
end

function ImguiHintUI.is_persistent(arg_6_0)
	return true
end

function ImguiHintUI._do_main_window(arg_7_0)
	if arg_7_0._first_launch then
		local var_7_0, var_7_1 = Application.resolution()

		var_0_1.set_next_window_size(var_7_0 * 0.25, var_7_1 * 0.7)
	end

	local var_7_2 = var_0_1.begin_window("Hint UI Debug", "menu_bar")

	var_0_1.text("Add Hint to the Hint Templates settings file \nand verify the info from here")
	var_0_1.separator()
	arg_7_0:_do_clear_saved_hints_button()
	var_0_1.dummy(2, 5)
	arg_7_0:_do_hint_buttons()
	var_0_1:end_window()

	return var_7_2
end

function ImguiHintUI._do_hint_buttons(arg_8_0)
	for iter_8_0, iter_8_1 in pairs(HintTemplates) do
		if var_0_1.button(iter_8_0, 250, 25) then
			Managers.state.event:trigger("ui_show_hint", iter_8_0)
		end
	end
end

local function var_0_3()
	print("ImguiHintUI - Cleared save hints from SaveData")
end

local function var_0_4()
	SaveData.viewed_hints = {}

	Managers.save:auto_save(SaveFileName, SaveData, var_0_3)
end

function ImguiHintUI._do_clear_saved_hints_button(arg_11_0)
	if var_0_1.button("Clear Saved Hints", 250, 35) then
		var_0_4()
	end

	Managers.ui:ingame_ui().hint_ui_handler:parse_unseen_hints()
end
