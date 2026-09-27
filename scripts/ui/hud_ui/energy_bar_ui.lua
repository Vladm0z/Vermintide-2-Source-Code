-- chunkname: @scripts/ui/hud_ui/energy_bar_ui.lua

local var_0_0 = local_require("scripts/ui/hud_ui/energy_bar_ui_definitions")

EnergyBarUI = class(EnergyBarUI)

EnergyBarUI.init = function (self, arg_1_1, arg_1_2)
	-- function 1
	self._parent = arg_1_1
	self.ui_renderer = arg_1_2.ui_renderer
	self.input_manager = arg_1_2.input_manager
	self.render_settings = {
		alpha_multiplier = 1,
		snap_pixel_positions = true
	}

	self:create_ui_elements()
end

EnergyBarUI._update_energy = function (self, arg_2_1, arg_2_2)
	-- function 2
	local player_unit = arg_2_1.player_unit

	if not Unit.alive(player_unit) then
		return
	end

	local has_extension = ScriptUnit.has_extension(player_unit, "energy_system")

	if not has_extension then
		return
	end

	local get_fraction = has_extension:get_fraction()

	if not (get_fraction >= 1) then
		local is_drainable = has_extension:is_drainable()

		self:_set_charge_bar_fraction(get_fraction, is_drainable)

		return true
	end

	return false
end

EnergyBarUI.create_ui_elements = function (self)
	-- function 3
	UIRenderer.clear_scenegraph_queue(self.ui_renderer)

	self.ui_scenegraph = UISceneGraph.init_scenegraph(var_0_0.scenegraph_definition)
	self.charge_bar = UIWidget.init(var_0_0.widget_definitions.charge_bar)
end

EnergyBarUI.update = function (self, arg_4_1, arg_4_2, arg_4_3)
	-- function 4
	local _update_energy = self:_update_energy(arg_4_3, arg_4_1)
	local is_activated = Managers.twitch:is_activated()

	if is_activated ~= self._has_twitch then
		local offset = self.charge_bar.offset
		local flag

		flag = not is_activated and 140 and 0
		offset[2] = flag
		self._has_twitch = is_activated
		_update_energy = true
	end

	if not _update_energy then
		local ui_scenegraph = self.ui_scenegraph
		local get_service = self.input_manager:get_service("ingame_menu")
		local get_crosshair_position, var_4_7 = self._parent:get_crosshair_position()

		self:_apply_crosshair_position(get_crosshair_position, var_4_7)

		local ui_renderer = self.ui_renderer

		UIRenderer.begin_pass(ui_renderer, ui_scenegraph, get_service, arg_4_1, nil, self.render_settings)
		UIRenderer.draw_widget(ui_renderer, self.charge_bar)
		UIRenderer.end_pass(ui_renderer)
	end
end

local tbl = {
	normal = {
		255,
		0,
		255,
		255
	}
}

EnergyBarUI._set_charge_bar_fraction = function (self, arg_5_1, arg_5_2)
	-- function 5
	local charge_bar = self.charge_bar
	local style = charge_bar.style
	local content = charge_bar.content
	local lerp = math.lerp
	local internal_gradient_threshold = content.internal_gradient_threshold

	internal_gradient_threshold = internal_gradient_threshold or 1
	arg_5_1 = lerp(internal_gradient_threshold, math.min(arg_5_1, 1), 0.3)
	content.internal_gradient_threshold = arg_5_1
	style.bar_1.gradient_threshold = arg_5_1

	local var_5_5
	local color = style.icon.color
	local color_2 = style.bar_1.color
	local normal = tbl.normal

	color_2[1] = normal[1]
	color_2[2] = normal[2]
	color_2[3] = normal[3]
	color_2[4] = normal[4]

	local num = 10
	local num_2 = 0

	if not arg_5_2 then
		local min = math.min(math.max(arg_5_1, 0.95) / 0.050000000000000044 * 1.3, 1)

		num_2 = (100 + (0.5 + math.sin(Managers.time:time("ui") * num) * 0.5) * 155) * min
	end

	style.frame.color[1] = num_2
	color[1] = 0
	color[2] = normal[2]
	color[3] = normal[3]
	color[4] = normal[4]
end

EnergyBarUI.destroy = function (arg_6_0)
	-- function 6
	return
end

EnergyBarUI.set_alpha = function (arg_7_0, arg_7_1)
	-- function 7
	arg_7_0.render_settings.alpha_multiplier = arg_7_1
end

EnergyBarUI._apply_crosshair_position = function (self, arg_8_1, arg_8_2)
	-- function 8
	local str = "screen_bottom_pivot"
	local local_position = self.ui_scenegraph[str].local_position

	local_position[1] = arg_8_1
	local_position[2] = arg_8_2
end
