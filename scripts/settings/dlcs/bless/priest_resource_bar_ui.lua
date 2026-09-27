-- chunkname: @scripts/settings/dlcs/bless/priest_resource_bar_ui.lua

local var_0_0 = local_require("scripts/settings/dlcs/bless/priest_resource_bar_ui_definition")

PriestResourceBarUI = class(PriestResourceBarUI)

local tbl = {
	material = "overcharge_bar_warrior_priest",
	color = {
		255,
		144,
		54,
		36
	}
}
local tbl_2 = {
	detail_bar_passive_active = 0.2,
	glow_brightness_min = 0.1,
	detail_bar_passive_inactive = -0.4,
	glow_brightness_max = 0.8
}

PriestResourceBarUI.init = function (self, arg_1_1, arg_1_2)
	-- function 1
	self._parent = arg_1_1
	self.platform = PLATFORM
	self.ui_renderer = arg_1_2.ui_renderer
	self._gui = arg_1_2.ui_renderer.gui
	self.input_manager = arg_1_2.input_manager
	self._gui = arg_1_2.ui_renderer.gui

	self:create_ui_elements()

	self.peer_id = arg_1_2.peer_id
	self.player_manager = arg_1_2.player_manager
	self.render_settings = {
		alpha_multiplier = 1,
		snap_pixel_positions = true
	}
	self._previous_overcharge_fraction = 0
	self._is_spectator = false
	self._spectated_player = nil
	self._spectated_player_unit = nil
	self._value = 0.1
	self._bar_feedback_state = "increase"
	self._active_passive = false
	self._animations = {}

	local event = Managers.state.event

	event:register(self, "on_spectator_target_changed", "on_spectator_target_changed")
	event:register(self, "glow_feedback", "glow_feedback")
	event:register(self, "active_passive_feedback", "active_passive_feedback")
end

local function fn(arg_2_0)
	-- function 2
	local get_resource_fraction = ScriptUnit.extension(arg_2_0, "career_system"):get_passive_ability():get_resource_fraction()
	local num = 0.8
	local num_2 = 0.5

	return get_resource_fraction, num, 0.8, num_2
end

PriestResourceBarUI.on_spectator_target_changed = function (self, arg_3_1)
	-- function 3
	self._spectated_player_unit = arg_3_1
	self._spectated_player = Managers.player:owner(arg_3_1)
	self._is_spectator = true
end

PriestResourceBarUI._set_player_extensions = function (self, arg_4_1)
	-- function 4
	self.inventory_extension = ScriptUnit.extension(arg_4_1, "inventory_system")
	self.initialize_charge_bar = true
end

PriestResourceBarUI._update_resource_bar = function (self, arg_5_1, arg_5_2)
	-- function 5
	if not arg_5_1 then
		return
	end

	local player_unit = arg_5_1.player_unit

	if not ALIVE[player_unit] then
		return
	end

	local get_passive_ability = ScriptUnit.extension(player_unit, "career_system"):get_passive_ability()

	if not (not get_passive_ability and get_passive_ability.uses_resource) then
		return
	end

	local var_5_2, var_5_3, var_5_4, var_5_5 = fn(player_unit)

	if var_5_2 > 0 then
		self:set_charge_bar_fraction(arg_5_1, var_5_2, 0.3, var_5_4, var_5_5, arg_5_2)

		return true
	end
end

PriestResourceBarUI.create_ui_elements = function (self)
	-- function 6
	UIRenderer.clear_scenegraph_queue(self.ui_renderer)

	self.ui_scenegraph = UISceneGraph.init_scenegraph(var_0_0.scenegraph_definition)

	local inventory_entry_definitions = var_0_0.inventory_entry_definitions

	self.charge_bar = UIWidget.init(var_0_0.widget_definitions.charge_bar)
end

local tbl_3 = {
	root_scenegraph_id = "screen_bottom_pivot_parent",
	label = "Overcharge",
	registry_key = "overcharge",
	drag_scenegraph_id = "charge_bar"
}

PriestResourceBarUI.update = function (self, arg_7_1, arg_7_2, arg_7_3)
	-- function 7
	local ui_renderer = self.ui_renderer
	local ui_scenegraph = self.ui_scenegraph
	local input_manager = self.input_manager
	local get_service = input_manager:get_service("ingame_menu")
	local is_device_active = input_manager:is_device_active("gamepad")
	local _spectated_player

	if not self._is_spectator then
		_spectated_player = self._spectated_player

		if not _spectated_player then
			-- Nothing
		end
	end

	_spectated_player = arg_7_3

	::label_7_0::

	if not HudCustomizer.run(ui_renderer, ui_scenegraph, tbl_3) then
		UISceneGraph.update_scenegraph(ui_scenegraph)
	end

	local _update_resource_bar = self:_update_resource_bar(_spectated_player, arg_7_1)
	local is_activated = Managers.twitch:is_activated()

	if is_activated ~= self._has_twitch then
		local offset = self.charge_bar.offset
		local flag

		flag = not is_activated and 140 and 0
		offset[2] = flag
		self._has_twitch = is_activated
		_update_resource_bar = true
	end

	for k, v in pairs(self._animations) do
		UIAnimation.update(v, arg_7_1)

		if not UIAnimation.completed(v) then
			self._animations[k] = nil
		end
	end

	if not _update_resource_bar then
		local get_crosshair_position, var_7_11 = self._parent:get_crosshair_position()

		self:_apply_crosshair_position(get_crosshair_position, var_7_11)
		UIRenderer.begin_pass(ui_renderer, ui_scenegraph, get_service, arg_7_1, nil, self.render_settings)
		UIRenderer.draw_widget(ui_renderer, self.charge_bar)
		UIRenderer.end_pass(ui_renderer)
	end
end

PriestResourceBarUI.set_charge_bar_fraction = function (self, arg_8_1, arg_8_2, arg_8_3, arg_8_4, arg_8_5, arg_8_6)
	-- function 8
	local charge_bar = self.charge_bar
	local style = charge_bar.style
	local content = charge_bar.content
	local size = content.size
	local lerp = math.lerp
	local internal_gradient_threshold = content.internal_gradient_threshold

	internal_gradient_threshold = internal_gradient_threshold or 0
	arg_8_2 = lerp(internal_gradient_threshold, math.min(arg_8_2, 1), 0.3)
	content.internal_gradient_threshold = arg_8_2
	style.bar_1.gradient_threshold = arg_8_2

	local color = style.bar_1.color
	local var_8_7 = tbl
	local color_2 = var_8_7.color

	content.bar_1 = var_8_7.material

	local glow = style.glow
	local size_2 = glow.size

	glow.offset[1] = size[1] * arg_8_2 - size_2[1] / 2 + 2

	self:handle_glow_feedback(charge_bar, arg_8_6)

	style.bar_detail.gradient_threshold = arg_8_2

	local bar_detail = charge_bar.content.bar_detail
	local material = Gui.material(self._gui, bar_detail)

	Material.set_scalar(material, "gradient_threshold", arg_8_2)

	if not self._active_passive then
		local num = 0 + 0.5 * math.sin(2.5 * Managers.time:time("ui"))
		local bar_active = charge_bar.content.bar_active
		local material_2 = Gui.material(self._gui, bar_active)

		Material.set_scalar(material_2, "detail_offset", num)
		Material.set_scalar(material_2, "gradient_threshold", arg_8_2)

		glow.size = {
			150,
			150
		}
		glow.offset[2] = -75 + content.size[2] / 2

		self:handle_active_passive_feedback(tbl_2.detail_bar_passive_active)
	else
		glow.size = {
			75,
			75
		}
		glow.offset[2] = -37.5 + content.size[2] / 2

		self:handle_active_passive_feedback(tbl_2.detail_bar_passive_inactive)
	end

	color[2] = color_2[2]
	color[3] = color_2[3]
	color[4] = color_2[4]
end

PriestResourceBarUI.destroy = function (arg_9_0)
	-- function 9
	Managers.state.event:unregister("on_spectator_target_changed", arg_9_0)
	Managers.state.event:unregister("glow_feedback", arg_9_0)
	Managers.state.event:unregister("activate_passive_feedback", arg_9_0)
end

PriestResourceBarUI.set_alpha = function (arg_10_0, arg_10_1)
	-- function 10
	arg_10_0.render_settings.alpha_multiplier = arg_10_1
end

PriestResourceBarUI._apply_crosshair_position = function (self, arg_11_1, arg_11_2)
	-- function 11
	local str = "screen_bottom_pivot"
	local local_position = self.ui_scenegraph[str].local_position

	local_position[1] = arg_11_1
	local_position[2] = arg_11_2
end

PriestResourceBarUI.glow_feedback = function (self)
	-- function 12
	if not self._play_glow_feedback then
		self._play_glow_feedback = true
	end
end

PriestResourceBarUI.handle_glow_feedback = function (self, arg_13_1, arg_13_2)
	-- function 13
	if not self._play_glow_feedback then
		return
	end

	local glow_brightness_min = tbl_2.glow_brightness_min
	local glow_brightness_max = tbl_2.glow_brightness_max
	local _value = self._value

	if self._bar_feedback_state == "increase" then
		_value = _value + 5 * arg_13_2

		if glow_brightness_max <= _value then
			self._bar_feedback_state = "decrease"
		end
	elseif self._bar_feedback_state == "decrease" then
		_value = _value - 2.5 * arg_13_2

		if _value <= glow_brightness_min then
			self._bar_feedback_state = "done"
		end
	elseif self._bar_feedback_state == "done" then
		self._value = glow_brightness_min
		self._play_glow_feedback = false
		self._bar_feedback_state = "increase"
	end

	self._value = _value

	local glow = arg_13_1.content.glow
	local material = Gui.material(self._gui, glow)

	Material.set_scalar(material, "detail_offset", _value)
end

PriestResourceBarUI.active_passive_feedback = function (self, arg_14_1)
	-- function 14
	self._active_passive = arg_14_1

	if not arg_14_1 then
		self._animations.fade_in = UIAnimation.init(UIAnimation.function_by_time, self.charge_bar.style.bar_active.color, 1, 0, 255, 0.3, math.ease_in_exp)
	else
		self._animations.fade_in = UIAnimation.init(UIAnimation.function_by_time, self.charge_bar.style.bar_active.color, 1, 255, 0, 0.3, math.ease_in_exp)
	end
end

PriestResourceBarUI.handle_active_passive_feedback = function (self, arg_15_1)
	-- function 15
	local bar_detail = self.charge_bar.content.bar_detail
	local material = Gui.material(self._gui, bar_detail)

	Material.set_scalar(material, "detail_offset", arg_15_1)
end
