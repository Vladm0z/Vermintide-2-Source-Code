-- chunkname: @scripts/ui/hud_ui/deus_debug_ui.lua

DeusDebugUI = class(DeusDebugUI)

DeusDebugUI.init = function (self, arg_1_1, arg_1_2)
	-- function 1
	self._world = arg_1_2.world_manager:world("level_world")
	self._gui = World.create_screen_gui(self._world, "immediate", "material", "materials/fonts/gw_fonts")
end

DeusDebugUI.destroy = function (self)
	-- function 2
	World.destroy_gui(self._world, self._gui)

	self._gui = nil
end

DeusDebugUI.update = function (self, arg_3_1, arg_3_2)
	-- function 3
	self:_draw(arg_3_1, arg_3_2)
end

DeusDebugUI._draw = function (self, arg_4_1, arg_4_2)
	-- function 4
	self:_draw_left_side(arg_4_1, arg_4_2)
	self:_draw_right_side(arg_4_1, arg_4_2)
end

DeusDebugUI._draw_right_side = function (self, arg_5_1, arg_5_2)
	-- function 5
	local str = "materials/fonts/arial"
	local str_2 = "arial"
	local num = 12
	local resolution, var_5_4 = Gui.resolution()
	local num_2 = resolution * 0.75
	local var_5_6 = var_5_4
	local str_3 = ""
	local get_deus_run_controller = Managers.mechanism:game_mechanism():get_deus_run_controller()

	if not get_deus_run_controller then
		str_3 = str_3 .. "Run seed: " .. get_deus_run_controller:get_run_seed()
	end

	if not IS_WINDOWS and not rawget(_G, "Steam") then
		str_3 = str_3 .. " User: " .. Steam.user_name()
	end

	if str_3 == "" then
		return
	end

	local text_extents, var_5_10 = Gui.text_extents(self._gui, str_3, str, num)
	local num_3 = var_5_10.x - text_extents.x
	local y = var_5_10.y
	local num_4 = 5
	local num_5 = num_2 - num_3 * 0.5 - num_4
	local num_6 = var_5_6 - y - num_4
	local num_7 = num_3 + num_4 * 2
	local num_8 = y + num_4 * 2
	local num_9 = num_5 - num_4
	local num_10 = num_6 - num_4

	Gui.rect(self._gui, Vector2(num_9, num_10), Vector2(num_7, num_8), Color(128, 0, 0, 0))
	Gui.text(self._gui, str_3, str, num, str_2, Vector3(num_5, num_6, 0), Color(255, 255, 255, 0))
end

DeusDebugUI._draw_left_side = function (self, arg_6_1, arg_6_2)
	-- function 6
	local get_deus_run_controller = Managers.mechanism:game_mechanism():get_deus_run_controller()

	if not get_deus_run_controller then
		return
	end

	local str = "materials/fonts/arial"
	local str_2 = "arial"
	local num = 12
	local resolution, var_6_5 = Gui.resolution()
	local num_2 = resolution * 0.25
	local var_6_7 = var_6_5
	local str_3 = "Level: " .. get_deus_run_controller:get_current_node().level
	local text_extents, var_6_10 = Gui.text_extents(self._gui, str_3, str, num)
	local num_3 = var_6_10.x - text_extents.x
	local y = var_6_10.y
	local num_4 = 5
	local num_5 = num_2 - num_3 * 0.5 - num_4
	local num_6 = var_6_7 - y - num_4
	local num_7 = num_3 + num_4 * 2
	local num_8 = y + num_4 * 2
	local num_9 = num_5 - num_4
	local num_10 = num_6 - num_4

	Gui.rect(self._gui, Vector2(num_9, num_10), Vector2(num_7, num_8), Color(128, 0, 0, 0))
	Gui.text(self._gui, str_3, str, num, str_2, Vector3(num_5, num_6, 0), Color(255, 255, 255, 0))
end
