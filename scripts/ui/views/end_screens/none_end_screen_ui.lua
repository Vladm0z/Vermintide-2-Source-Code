-- chunkname: @scripts/ui/views/end_screens/none_end_screen_ui.lua

require("scripts/ui/views/end_screens/base_end_screen_ui")

local var_0_0 = local_require("scripts/ui/views/end_screens/none_end_screen_ui_definitions")

NoneEndScreenUI = class(NoneEndScreenUI, BaseEndScreenUI)

NoneEndScreenUI.init = function (arg_1_0, arg_1_1, arg_1_2, arg_1_3, arg_1_4)
	-- function 1
	NoneEndScreenUI.super.init(arg_1_0, arg_1_1, arg_1_2, var_0_0, arg_1_4)
end

NoneEndScreenUI._start = function (self)
	-- function 2
	self:_on_completed()
end
