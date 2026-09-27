-- chunkname: @scripts/ui/hud_ui/overcharge_bar_ui.lua

local var_0_0 = local_require("scripts/ui/hud_ui/overcharge_bar_ui_definitions")

OverchargeBarUI = class(OverchargeBarUI)

local tbl = {
	slot_ranged = true,
	slot_melee = true
}
local tbl_2 = {
	material = "overcharge_bar",
	color_normal = {
		255,
		255,
		255,
		255
	},
	color_medium = {
		255,
		255,
		165,
		0
	},
	color_high = {
		255,
		255,
		0,
		0
	}
}
local num = 0.5

OverchargeBarUI.init = function (self, arg_1_1, arg_1_2)
	-- function 1
	self._parent = arg_1_1
	self.platform = PLATFORM
	self.ui_renderer = arg_1_2.ui_renderer
	self.input_manager = arg_1_2.input_manager
	self.slot_equip_animations = {}
	self.slot_animations = {}
	self.ui_animations = {}

	self:create_ui_elements()

	self.peer_id = arg_1_2.peer_id
	self.player_manager = arg_1_2.player_manager
	self.render_settings = {
		alpha_multiplier = 1,
		snap_pixel_positions = true
	}
	self._previous_overcharge_fraction = 0
	self._keep_at_0_t = 0
	self._is_spectator = false
	self._spectated_player = nil
	self._spectated_player_unit = nil

	Managers.state.event:register(self, "on_spectator_target_changed", "on_spectator_target_changed")
end

local function fn(arg_2_0)
	-- function 2
	local extension = ScriptUnit.extension(arg_2_0, "overcharge_system")
	local lerped_overcharge_fraction = extension:lerped_overcharge_fraction()
	local threshold_fraction = extension:threshold_fraction()
	local get_anim_blend_overcharge = extension:get_anim_blend_overcharge()

	return lerped_overcharge_fraction, threshold_fraction, 0.8, get_anim_blend_overcharge
end

OverchargeBarUI.on_spectator_target_changed = function (self, arg_3_1)
	-- function 3
	self._spectated_player_unit = arg_3_1
	self._spectated_player = Managers.player:owner(arg_3_1)
	self._is_spectator = true
end

OverchargeBarUI._set_player_extensions = function (self, arg_4_1)
	-- function 4
	self.inventory_extension = ScriptUnit.extension(arg_4_1, "inventory_system")
	self.initialize_charge_bar = true
end

OverchargeBarUI._update_overcharge = function (self, arg_5_1, arg_5_2)
	-- function 5
	if not arg_5_1 then
		return
	end

	local player_unit = arg_5_1.player_unit

	if not Unit.alive(player_unit) then
		return
	end

	if not ScriptUnit.has_extension(player_unit, "overcharge_system") then
		return
	end

	local equipment = ScriptUnit.extension(player_unit, "inventory_system"):equipment()

	if not equipment then
		return
	end

	local wielded = equipment.wielded
	local slots = InventorySettings.slots

	for i, v in ipairs(slots) do
		local name = v.name

		if not tbl[name] then
			local var_5_5 = equipment.slots[name]

			if not var_5_5 then
				local item_data = var_5_5.item_data
				local name_2 = item_data.name
				local flag

				flag = wielded == item_data

				local var_5_9, var_5_10, var_5_11, var_5_12 = fn(player_unit)
				local flag_2 = not var_5_9 and var_5_9 > 0

				if not (flag_2 or not (arg_5_2 < self._keep_at_0_t)) then
					if not (not self.wielded_item_name and self.wielded_item_name == name_2) then
						self.wielded_item_name = name_2
					end

					local get_max_value = ScriptUnit.extension(player_unit, "overcharge_system"):get_max_value()

					self:update_bar_size(get_max_value, var_5_10, var_5_11)
					self:set_charge_bar_fraction(arg_5_1, var_5_9, var_5_10, var_5_11, var_5_12)

					if not flag_2 then
						self._keep_at_0_t = arg_5_2 + num
					end

					return true
				end
			end
		end
	end
end

OverchargeBarUI.create_ui_elements = function (self)
	-- function 6
	UIRenderer.clear_scenegraph_queue(self.ui_renderer)

	self.ui_scenegraph = UISceneGraph.init_scenegraph(var_0_0.scenegraph_definition)

	local var_6_0

	self._party = Managers.party:get_local_player_party()
	self._side = Managers.state.side.side_by_party[self._party]

	if not (not self._side and self._side:name() ~= "dark_pact") then
		var_6_0 = UIWidgets.create_dark_pact_overcharge_bar_widget("charge_bar_dark_pact", nil, nil, nil, nil, var_0_0.DEFAULT_DARK_PACT_BAR_SIZE)
	else
		var_6_0 = UIWidgets.create_overcharge_bar_widget("charge_bar", nil, nil, nil, nil, var_0_0.DEFAULT_BAR_SIZE)
	end

	self.charge_bar = UIWidget.init(var_6_0)
end

local tbl_3 = {
	root_scenegraph_id = "screen_bottom_pivot_parent",
	label = "Overcharge",
	registry_key = "overcharge",
	drag_scenegraph_id = "charge_bar"
}

OverchargeBarUI.update = function (self, arg_7_1, arg_7_2, arg_7_3)
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

	local _update_overcharge = self:_update_overcharge(_spectated_player, arg_7_2)
	local is_activated = Managers.twitch:is_activated()

	if is_activated ~= self._has_twitch then
		local offset = self.charge_bar.offset
		local flag

		flag = not is_activated and 140 and 0
		offset[2] = flag
		self._has_twitch = is_activated
		_update_overcharge = true
	end

	if not _update_overcharge then
		local get_crosshair_position, var_7_11 = self._parent:get_crosshair_position()

		self:_apply_crosshair_position(get_crosshair_position, var_7_11)
		UIRenderer.begin_pass(ui_renderer, ui_scenegraph, get_service, arg_7_1, nil, self.render_settings)
		UIRenderer.draw_widget(ui_renderer, self.charge_bar)
		UIRenderer.end_pass(ui_renderer)
	end
end

OverchargeBarUI.update_bar_size = function (self, arg_8_1, arg_8_2, arg_8_3)
	-- function 8
	local var_8_0

	if self._side:name() == "dark_pact" then
		var_8_0 = var_0_0.DEFAULT_DARK_PACT_BAR_SIZE[1]

		if not var_8_0 then
			-- Nothing
		end
	end

	var_8_0 = var_0_0.DEFAULT_BAR_SIZE[1]

	::label_8_0::

	local remap = math.remap(0, 40, 0, var_8_0, arg_8_1)
	local charge_bar = self.charge_bar

	charge_bar.content.size[1] = remap - 6

	local style = charge_bar.style

	if not style.frame then
		style.frame.size[1] = remap
	end

	style.bar_1.size[1] = remap - 6
	style.icon.offset[1] = remap
	style.icon_shadow.offset[1] = remap + 2

	if not style.bar_bg then
		style.bar_bg.size[1] = remap - 6
	end

	style.bar_fg.size[1] = remap

	if style.min_threshold or not style.max_threshold then
		style.min_threshold.offset[1] = 3 + arg_8_2 * remap
		style.max_threshold.offset[1] = 3 + arg_8_3 * remap
	end

	self.ui_scenegraph.charge_bar.size[1] = remap
end

OverchargeBarUI.set_charge_bar_fraction = function (self, arg_9_1, arg_9_2, arg_9_3, arg_9_4, arg_9_5)
	-- function 9
	local charge_bar = self.charge_bar
	local style = charge_bar.style
	local content = charge_bar.content
	local lerp = math.lerp
	local internal_gradient_threshold = content.internal_gradient_threshold

	internal_gradient_threshold = internal_gradient_threshold or 0
	arg_9_2 = lerp(internal_gradient_threshold, math.min(arg_9_2, 1), 0.3)
	content.internal_gradient_threshold = arg_9_2
	style.bar_1.gradient_threshold = arg_9_2

	local num = 1
	local var_9_6
	local color = style.icon.color
	local color_2 = style.bar_1.color
	local career_name = arg_9_1:career_name()
	local var_9_10 = OverchargeData[career_name]
	local overcharge_ui

	if not var_9_10 then
		overcharge_ui = var_9_10.overcharge_ui

		if not overcharge_ui then
			-- Nothing
		end
	end

	overcharge_ui = tbl_2

	::label_9_0::

	content.bar_1 = overcharge_ui.material

	if arg_9_2 <= arg_9_3 then
		var_9_6 = overcharge_ui.color_normal
		num = 0.6
	elseif arg_9_2 <= arg_9_4 then
		num = 0.8
		var_9_6 = overcharge_ui.color_medium
	else
		var_9_6 = overcharge_ui.color_high
	end

	color_2[1] = var_9_6[1] * num
	color_2[2] = var_9_6[2]
	color_2[3] = var_9_6[3]
	color_2[4] = var_9_6[4]

	local num_2 = 10
	local min = math.min(math.max(arg_9_2 - arg_9_4, 0) / (1 - arg_9_4) * 1.3, 1)
	local num_3 = (100 + (0.5 + math.sin(Managers.time:time("ui") * num_2) * 0.5) * 155) * min

	if not style.frame then
		style.frame.color[1] = num_3
	end

	color[1] = num_3
	color[2] = var_9_6[2]
	color[3] = var_9_6[3]
	color[4] = var_9_6[4]
end

OverchargeBarUI.destroy = function (arg_10_0)
	-- function 10
	Managers.state.event:unregister("on_spectator_target_changed", arg_10_0)
end

OverchargeBarUI.set_alpha = function (arg_11_0, arg_11_1)
	-- function 11
	arg_11_0.render_settings.alpha_multiplier = arg_11_1
end

OverchargeBarUI._apply_crosshair_position = function (self, arg_12_1, arg_12_2)
	-- function 12
	local str = "screen_bottom_pivot"
	local local_position = self.ui_scenegraph[str].local_position

	local_position[1] = arg_12_1
	local_position[2] = arg_12_2
end
