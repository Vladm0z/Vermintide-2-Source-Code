-- chunkname: @scripts/ui/views/fatigue_ui.lua

local var_0_0 = local_require("scripts/ui/views/fatigue_ui_definitions")

FatigueUI = class(FatigueUI)

FatigueUI.init = function (self, arg_1_1, arg_1_2)
	-- function 1
	self._parent = arg_1_1
	self.ui_renderer = arg_1_2.ui_renderer
	self.ingame_ui = arg_1_2.ingame_ui
	self.input_manager = arg_1_2.input_manager
	self.local_player = arg_1_2.player_manager:local_player()

	self:create_ui_elements()
end

FatigueUI.create_ui_elements = function (self)
	-- function 2
	self.ui_scenegraph = UISceneGraph.init_scenegraph(var_0_0.scenegraph_definition)

	local tbl = {}

	for i = 1, UISettings.max_fatigue_shields do
		tbl[i] = UIWidget.init(var_0_0.shield_definition)
	end

	self.active_shields = 0
	self.shields = tbl
end

FatigueUI.destroy = function (arg_3_0)
	-- function 3
	return
end

FatigueUI.shield_state = function (arg_4_0, arg_4_1, arg_4_2)
	-- function 4
	local num = arg_4_2 - arg_4_1

	if num >= 0 then
		return "state_1"
	elseif num == -0.5 then
		return "state_2"
	else
		return "state_3"
	end
end

FatigueUI.setup_hud = function (self, arg_5_1)
	-- function 5
	local current_fatigue_points, var_5_1 = arg_5_1:current_fatigue_points()
	local clamp = math.clamp(current_fatigue_points, 0, UISettings.max_fatigue_shields * 2)
	local clamp_2 = math.clamp(var_5_1, 0, UISettings.max_fatigue_shields * 2)
	local floor = math.floor(clamp_2 / 2 + 0.5)
	local num = 30
	local num_2 = num * (floor - 1) / 2
	local num_3 = clamp_2 * 0.5 - clamp * 0.5
	local shields = self.shields

	for i = 1, floor do
		local var_5_9 = shields[i]
		local style = var_5_9.style
		local num_4 = num_2 - num * (i - 1)

		style.offset[1] = num_4
		style.texture_glow_id.offset[1] = num_4
		var_5_9.state = self:shield_state(i, num_3)
		var_5_9.content.texture_id = style.state_textures[var_5_9.state]

		if not self.active then
			style.color[1] = 255
			style.texture_glow_id.color[1] = 255
		end
	end

	self.active_shields = floor
	self.current_fatigue = clamp
	self.max_fatigue_points = clamp_2
end

FatigueUI.start_fade_in = function (self)
	-- function 6
	local active_shields = self.active_shields
	local shields = self.shields

	for i = 1, active_shields do
		local var_6_2 = shields[i]
		local style = var_6_2.style
		local num = 0
		local num_2 = 255

		UIWidget.stop_animations(var_6_2)
		UIWidget.animate(var_6_2, UIAnimation.init(UIAnimation.function_by_time, style.color, 1, num, num_2, 0.2, math.easeInCubic))
		UIWidget.animate(var_6_2, UIAnimation.init(UIAnimation.function_by_time, style.texture_glow_id.color, 1, num, num_2, 0.2, math.easeInCubic))
	end
end

FatigueUI.start_fade_out = function (self)
	-- function 7
	local active_shields = self.active_shields
	local shields = self.shields

	for i = 1, active_shields do
		local var_7_2 = shields[i]
		local style = var_7_2.style
		local var_7_4 = style.color[1]
		local num = 0

		UIWidget.stop_animations(var_7_2)
		UIWidget.animate(var_7_2, UIAnimation.init(UIAnimation.function_by_time, style.color, 1, var_7_4, num, 0.2, math.easeInCubic))
		UIWidget.animate(var_7_2, UIAnimation.init(UIAnimation.function_by_time, style.texture_glow_id.color, 1, var_7_4, num, 0.2, math.easeInCubic))
	end
end

local tbl = {
	root_scenegraph_id = "background",
	label = "Stamina",
	registry_key = "fatigue",
	drag_scenegraph_id = "background_dragger"
}

FatigueUI.update = function (self, arg_8_1)
	-- function 8
	local player_unit = self.local_player.player_unit

	if not Unit.alive(player_unit) then
		return
	end

	HudCustomizer.run(self.ui_renderer, self.ui_scenegraph, tbl)

	local extension = ScriptUnit.extension(player_unit, "status_system")
	local check_active = self:check_active(extension)

	if self.active or not check_active then
		self.active = true

		self:setup_hud(extension)
		self:start_fade_in()
	elseif not self.active then
		local current_fatigue_points, var_8_4 = extension:current_fatigue_points()

		if not (not (current_fatigue_points / var_8_4 < 0.6) or check_active) then
			self.active = false

			self:start_fade_out()
		end
	end

	if not self.active then
		self:update_shields(extension, arg_8_1)
	end

	local active_shields = self.active_shields
	local shields = self.shields

	for i = 1, active_shields do
		local var_8_7 = shields[i]
		local style = var_8_7.style

		if not extension.has_bonus_fatigue_active then
			var_8_7.content.show_glow = false
		else
			var_8_7.content.show_glow = false
		end
	end

	self:draw(arg_8_1)
end

FatigueUI.check_active = function (arg_9_0, arg_9_1)
	-- function 9
	local is_blocking = arg_9_1:is_blocking()

	is_blocking = is_blocking or arg_9_1.show_fatigue_gui

	return is_blocking
end

FatigueUI.update_shields = function (self, arg_10_1, arg_10_2)
	-- function 10
	local current_fatigue = self.current_fatigue
	local current_fatigue_points, var_10_2 = arg_10_1:current_fatigue_points()

	if var_10_2 ~= self.max_fatigue_points then
		self:setup_hud(arg_10_1)
	end

	if current_fatigue_points == current_fatigue then
		return
	end

	local num = var_10_2 * 0.5 - current_fatigue_points * 0.5
	local active_shields = self.active_shields
	local shields = self.shields

	for i = 1, active_shields do
		local var_10_6 = shields[i]
		local style = var_10_6.style
		local state = var_10_6.state
		local shield_state = self:shield_state(i, num)

		if state ~= shield_state then
			local var_10_10 = style.state_animations[state]

			if not var_10_10 and not var_10_10[shield_state] then
				local var_10_11 = var_10_10[shield_state]

				UIWidget.animate(var_10_6, UIAnimation.init(UIAnimation.picture_sequence, var_10_6.content, "texture_id", var_10_11.pictures, var_10_11.time))
			else
				var_10_6.content.texture_id = style.state_textures[shield_state]
			end
		end

		var_10_6.state = shield_state
	end

	self.current_fatigue = current_fatigue_points
end

FatigueUI.draw = function (self, arg_11_1)
	-- function 11
	local ui_renderer = self.ui_renderer
	local ui_scenegraph = self.ui_scenegraph
	local get_service = self.input_manager:get_service("ingame_menu")

	UIRenderer.begin_pass(ui_renderer, ui_scenegraph, get_service, arg_11_1)

	local shields = self.shields
	local active_shields = self.active_shields

	for i = 1, active_shields do
		local var_11_5 = shields[i]

		UIRenderer.draw_widget(ui_renderer, var_11_5)
	end

	UIRenderer.end_pass(ui_renderer)
end
