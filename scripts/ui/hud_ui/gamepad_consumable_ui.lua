-- chunkname: @scripts/ui/hud_ui/gamepad_consumable_ui.lua

local var_0_0 = local_require("scripts/ui/hud_ui/gamepad_consumable_ui_definitions")
local animations = var_0_0.animations
local scenegraph_definition = var_0_0.scenegraph_definition
local weapon_slots = InventorySettings.weapon_slots
local tbl = {
	slot_healthkit = 4,
	slot_grenade = 1,
	slot_potion = 2
}
local tbl_2 = {
	slot_healthkit = "consumables_medpack",
	slot_grenade = "consumables_frag",
	slot_potion = "consumables_potion_01"
}
local tbl_3 = {
	slot_grenade = {
		"default_grenade_icon",
		"default_grenade_icon_lit"
	},
	slot_potion = {
		"default_potion_icon",
		"default_potion_icon_lit"
	},
	slot_healthkit = {
		"default_heal_icon",
		"default_heal_icon_lit"
	}
}
local num = 5

hud_icon_texture_lit_lookup_table = {}
GamepadConsumableUI = class(GamepadConsumableUI)

GamepadConsumableUI.init = function (self, arg_1_1)
	-- function 1
	self.platform = PLATFORM
	self.ui_renderer = arg_1_1.ui_renderer
	self.ingame_ui = arg_1_1.ingame_ui
	self.input_manager = arg_1_1.input_manager
	self.peer_id = arg_1_1.peer_id
	self.player_manager = arg_1_1.player_manager
	self.render_settings = {
		snap_pixel_positions = true
	}
	self.ui_animations = {}

	self:_create_ui_elements()
end

GamepadConsumableUI._create_ui_elements = function (self)
	-- function 2
	self.ui_scenegraph = UISceneGraph.init_scenegraph(scenegraph_definition)
	self.selection_widget = UIWidget.init(var_0_0.widget_definitions.selection)
	self.background_widget = UIWidget.init(var_0_0.widget_definitions.background)

	local tbl = {}
	local tbl_2 = {}

	for k, v in pairs(tbl_3) do
		local var_2_2 = UIWidget.init(var_0_0.widget_definitions[k])

		var_2_2.content.texture_icon = v[1]
		tbl[#tbl + 1] = var_2_2
		tbl_2[k] = var_2_2
	end

	self.slot_widgets = tbl
	self.slot_widgets_by_name = tbl_2

	UIRenderer.clear_scenegraph_queue(self.ui_renderer)

	self.ui_animator = UIAnimator:new(self.ui_scenegraph, animations)

	self:_align_widgets()
	self:_set_dirty()
end

GamepadConsumableUI.destroy = function (self)
	-- function 3
	self.ui_animator = nil

	self:set_visible(false)
end

GamepadConsumableUI.set_visible = function (self, arg_4_1)
	-- function 4
	local is_device_active = self.input_manager:is_device_active("gamepad")

	if not (not arg_4_1 and is_device_active) then
		return
	end

	self._is_visible = arg_4_1

	local ui_renderer = self.ui_renderer

	for i, v in ipairs(self.slot_widgets) do
		UIRenderer.set_element_visible(ui_renderer, v.element, arg_4_1)
	end

	UIRenderer.set_element_visible(ui_renderer, self.selection_widget.element, arg_4_1)
end

GamepadConsumableUI.update = function (self, arg_5_1, arg_5_2, arg_5_3)
	-- function 5
	if not self.input_manager:is_device_active("gamepad") then
		if not self.gamepad_active_last_frame then
			self.gamepad_active_last_frame = true

			self:on_gamepad_activated()
		end
	elseif not self.gamepad_active_last_frame then
		self.gamepad_active_last_frame = false

		self:on_gamepad_deactivated()
	end

	if not RESOLUTION_LOOKUP.modified then
		for i, v in ipairs(self.slot_widgets) do
			self:_set_widget_dirty(v)
		end

		self:_set_dirty()
	end

	self:_update_extension_changes(arg_5_1, arg_5_3)

	local ui_animator = self.ui_animator

	ui_animator:update(arg_5_1)

	local ui_animations = self.ui_animations

	for i_2, v_2 in ipairs(ui_animations) do
		if not ui_animator:is_animation_completed(v_2) then
			ui_animator:stop_animation(v_2)

			ui_animations[i_2] = nil
		end

		self:_set_dirty()
	end

	self:_draw(arg_5_1)

	self._dirty = nil
end

local function fn(arg_6_0, arg_6_1, arg_6_2)
	-- function 6
	local var_6_0

	if not arg_6_2.ammo_data then
		return
	end

	local ammo_hand = arg_6_2.ammo_data.ammo_hand

	if ammo_hand == "right" then
		var_6_0 = ScriptUnit.extension(arg_6_1, "ammo_system")
	elseif ammo_hand == "left" then
		var_6_0 = ScriptUnit.extension(arg_6_0, "ammo_system")
	else
		return
	end

	local ammo_count = var_6_0:ammo_count()
	local remaining_ammo = var_6_0:remaining_ammo()

	return ammo_count, remaining_ammo
end

GamepadConsumableUI._draw = function (self, arg_7_1)
	-- function 7
	if not self._is_visible then
		return
	end

	local ui_renderer = self.ui_renderer
	local ui_scenegraph = self.ui_scenegraph
	local get_service = self.input_manager:get_service("ingame_menu")

	UIRenderer.begin_pass(ui_renderer, ui_scenegraph, get_service, arg_7_1, nil, self.render_settings)

	for i, v in ipairs(self.slot_widgets) do
		UIRenderer.draw_widget(ui_renderer, v)
	end

	if not self._draw_selection then
		UIRenderer.draw_widget(ui_renderer, self.selection_widget)
	end

	UIRenderer.draw_widget(ui_renderer, self.background_widget)
	UIRenderer.end_pass(ui_renderer)
end

GamepadConsumableUI._set_dirty = function (self)
	-- function 8
	self._dirty = true
end

GamepadConsumableUI._set_widget_dirty = function (arg_9_0, arg_9_1)
	-- function 9
	arg_9_1.element.dirty = true
end

GamepadConsumableUI._update_extension_changes = function (self, arg_10_1, arg_10_2)
	-- function 10
	if not arg_10_2 then
		return
	end

	local flag = false
	local slot_widgets_by_name = self.slot_widgets_by_name
	local get_selected_consumable_slot_name = arg_10_2:get_selected_consumable_slot_name()
	local equipment = arg_10_2:equipment()

	for i, v in ipairs(weapon_slots) do
		local flag_2 = false
		local name = v.name
		local var_10_6 = equipment.slots[name]
		local var_10_7 = slot_widgets_by_name[name]

		if not var_10_7 then
			local content = var_10_7.content

			if not var_10_6 then
				if not self:_reset_slot_widget(var_10_7, name, i) then
					flag_2 = true
				end
			else
				if not content.has_data then
					content.has_data = true
					flag_2 = true
				end

				local item_data = var_10_6.item_data
				local flag_3 = get_selected_consumable_slot_name == name
				local _update_slot_icon = self:_update_slot_icon(var_10_7, item_data, flag_3)
				local _update_slot_ammo = self:_update_slot_ammo(var_10_7, var_10_6, item_data, flag_3)

				if content.wielded ~= flag_3 then
					content.wielded = flag_3
					flag_2 = true

					if not flag_3 then
						self:_on_slot_selected(var_10_7)
					end
				end

				if _update_slot_ammo or not _update_slot_icon then
					flag_2 = true
				end
			end

			if not flag_2 then
				flag = true

				self:_set_widget_dirty(var_10_7)
			end
		end
	end

	if not get_selected_consumable_slot_name then
		self:_clear_selection()
	end

	if not flag then
		self:_set_dirty()
	end
end

GamepadConsumableUI._on_slot_selected = function (self, arg_11_1)
	-- function 11
	local ui_renderer = self.ui_renderer
	local offset = arg_11_1.offset
	local selection_widget = self.selection_widget
	local offset_2 = selection_widget.offset

	offset_2[1] = offset[1]
	offset_2[2] = offset[2]

	self:_set_widget_dirty(selection_widget)

	self._draw_selection = true

	UIRenderer.set_element_visible(ui_renderer, selection_widget.element, true)
end

GamepadConsumableUI._clear_selection = function (self)
	-- function 12
	local ui_renderer = self.ui_renderer
	local selection_widget = self.selection_widget

	UIRenderer.set_element_visible(ui_renderer, selection_widget.element, false)
	self:_set_widget_dirty(selection_widget)

	self._draw_selection = nil
end

GamepadConsumableUI._update_slot_icon = function (arg_13_0, arg_13_1, arg_13_2, arg_13_3)
	-- function 13
	local flag = false
	local style = arg_13_1.style
	local content = arg_13_1.content
	local hud_icon

	if not arg_13_2 then
		hud_icon = arg_13_2.hud_icon

		if not hud_icon then
			-- Nothing
		end
	end

	hud_icon = tbl_2[slot_name]

	::label_13_0::

	if not hud_icon_texture_lit_lookup_table[hud_icon] then
		hud_icon_texture_lit_lookup_table[hud_icon] = hud_icon .. "_lit"
	end

	if content.texture_icon ~= hud_icon then
		flag = true
		content.texture_icon = hud_icon

		local name

		if not arg_13_2 then
			name = arg_13_2.name

			if not name then
				-- Nothing
			end
		end

		name = "no_master_item_found"

		::label_13_1::

		assert(content.texture_icon, "No hud icon for weapon %s", name)

		content.texture_icon_lit = hud_icon_texture_lit_lookup_table[hud_icon]

		local color = style.texture_icon.color
		local color_2 = style.texture_icon_lit.color

		style.texture_bg.color[1] = 150
		color[1] = 255
		color_2[1] = 255
	end

	return flag
end

GamepadConsumableUI._update_slot_ammo = function (arg_14_0, arg_14_1, arg_14_2, arg_14_3, arg_14_4)
	-- function 14
	local flag = false
	local content = arg_14_1.content
	local get_item_template = BackendUtils.get_item_template(arg_14_3)
	local var_14_3, var_14_4 = fn(arg_14_2.left_unit_1p, arg_14_2.right_unit_1p, get_item_template)
	local flag_2 = not get_item_template and get_item_template.ammo_data

	if not (not flag_2 and not var_14_3 and flag_2.hide_ammo_ui) then
		local num = var_14_3 + var_14_4

		if not (not (num > 1) or content.total_ammo == num) then
			content.text_ammo = "x" .. tostring(var_14_3 + var_14_4)
			content.total_ammo = num
			content.show_ammo = true
			flag = true
		end
	elseif not content.show_ammo then
		content.show_ammo = false
		flag = true
	end

	return flag
end

GamepadConsumableUI._reset_slot_widget = function (arg_15_0, arg_15_1, arg_15_2, arg_15_3)
	-- function 15
	local flag = false
	local content = arg_15_1.content

	if not content.has_data then
		content.has_data = nil
		flag = true

		if arg_15_2 == "slot_healthkit" then
			-- Nothing
		end

		if not content.show_ammo then
			content.show_ammo = false
			content.ammo_text_1 = ""
			content.ammo_text_2 = ""
		end

		local var_15_2 = tbl_3[arg_15_2]

		if content.texture_icon ~= var_15_2[1] then
			local num = 50
			local style = arg_15_1.style

			content.texture_icon = var_15_2[1]
			content.texture_icon_lit = var_15_2[2]
			content.wielded = false

			local color = style.texture_icon.color
			local color_2 = style.texture_icon_lit.color

			style.texture_bg.color[1] = 100
			color[1] = num
			color_2[1] = num
		end
	end

	return flag
end

GamepadConsumableUI._change_heal_other_slot_state = function (self, arg_16_1)
	-- function 16
	local slot_widgets = self.slot_widgets

	if arg_16_1 == "active" then
		local var_16_1 = slot_widgets[3]
		local content = var_16_1.content

		if not content.has_data and not content.wielded then
			content.wielded = false
			content.has_data = true
			var_16_1.style.texture_icon.color[1] = 255
			var_16_1.style.texture_icon_lit.color[1] = 255
			var_16_1.element.dirty = true
		end
	elseif arg_16_1 == "wielded" then
		local var_16_3 = slot_widgets[3]
		local content_2 = var_16_3.content

		if not content_2.wielded then
			content_2.wielded = true
			content_2.has_data = true
			var_16_3.style.texture_icon.color[1] = 255
			var_16_3.style.texture_icon_lit.color[1] = 255
			var_16_3.element.dirty = true
		end
	elseif arg_16_1 == "reset" then
		local var_16_5 = slot_widgets[3]
		local content_3 = var_16_5.content

		if not content_3.has_data then
			content_3.wielded = false
			content_3.has_data = false
			var_16_5.style.texture_icon.color[1] = 50
			var_16_5.style.texture_icon_lit.color[1] = 50
			var_16_5.element.dirty = true
		end
	end
end

GamepadConsumableUI._animate_slot_fill = function (self, arg_17_1, arg_17_2)
	-- function 17
	local tbl = {}
	local tbl_2 = {
		arg_17_1
	}
	local ui_animations = self.ui_animations

	ui_animations[#ui_animations + 1] = self.ui_animator:start_animation("pickup", tbl_2, scenegraph_definition, tbl)
end

GamepadConsumableUI._align_widgets = function (self)
	-- function 18
	local slot_widgets = self.slot_widgets
	local num = 63
	local num_2 = 0
	local num_3 = 0

	for i, v in ipairs(slot_widgets) do
		local style = v.style

		v.offset[1] = num_3
		num_3 = num_3 + num + num_2
	end
end

GamepadConsumableUI._update_slot_positions = function (self)
	-- function 19
	local ui_scenegraph = self.ui_scenegraph
	local slot_spacing = UISettings.inventory_hud.slot_spacing
	local num = 0.9
	local slot_widgets = self.slot_widgets
	local count = #slot_widgets
	local num_2 = 0

	for i = count, 1, -1 do
		local var_19_6 = slot_widgets[i]
		local texture_bg = var_19_6.style.texture_bg
		local offset = texture_bg.offset
		local size = texture_bg.size
		local offset_2 = var_19_6.offset
		local num_3 = size[1] * num

		offset_2[1] = num_2 + num_3 * 0.5
		num_2 = num_2 + num_3 + slot_spacing
		var_19_6.element.dirty = true
	end

	self:_set_dirty()
end

GamepadConsumableUI.on_gamepad_activated = function (self)
	-- function 20
	self:set_visible(true)
	self:_set_dirty()
end

GamepadConsumableUI.on_gamepad_deactivated = function (self)
	-- function 21
	self:set_visible(false)
	self:_set_dirty()
end
