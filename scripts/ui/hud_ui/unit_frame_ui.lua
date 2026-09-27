-- chunkname: @scripts/ui/hud_ui/unit_frame_ui.lua

local num = 10

UnitFrameUI = class(UnitFrameUI)

UnitFrameUI.init = function (self, arg_1_1, arg_1_2, arg_1_3, arg_1_4, arg_1_5, arg_1_6)
	-- function 1
	self.definitions = arg_1_2
	self.features_list = arg_1_2.features_list
	self.widget_name_by_feature = arg_1_2.widget_name_by_feature
	self.inventory_consumable_icons = arg_1_2.inventory_consumable_icons
	self.inventory_index_by_slot = arg_1_2.inventory_index_by_slot
	self.weapon_slot_widget_settings = arg_1_2.weapon_slot_widget_settings
	self.render_settings = {
		alpha_multiplier = 1,
		snap_pixel_positions = true
	}
	self.ui_renderer = arg_1_1.ui_renderer
	self.ingame_ui = arg_1_1.ingame_ui
	self.input_manager = arg_1_1.input_manager
	self.peer_id = arg_1_1.peer_id
	self.player_manager = arg_1_1.player_manager
	self.ui_animations = {}
	self._damage_events = {}
	self._dmg_part_pool = {}
	self._hash_order = {}
	self._hash_widget_lookup = {}
	self.world = arg_1_1.world_manager:world("level_world")
	self._show_respawn_ui = false
	self.data = arg_1_3
	self._frame_type = arg_1_6

	self:_create_ui_elements(arg_1_4)

	self._ammo_ui_data = {}
	self.weapon_changed = false

	if not arg_1_5.is_player_darkpact then
		Managers.state.event:register(self, "enter_ghostmode", "on_enter_ghostmode")
	end
end

UnitFrameUI.on_enter_ghostmode = function (self, arg_2_1, arg_2_2)
	-- function 2
	self:show_main_healthbar(not arg_2_1)
end

UnitFrameUI._create_ui_elements = function (self, arg_3_1)
	-- function 3
	local definitions = self.definitions
	local scenegraph_definition = self.definitions.scenegraph_definition

	self.ui_scenegraph = UISceneGraph.init_scenegraph(scenegraph_definition)

	local tbl = {}

	for k, v in pairs(definitions.widget_definitions) do
		tbl[k] = UIWidget.init(v)
	end

	self._widgets = tbl
	self._default_widgets = {
		default_dynamic = tbl.default_dynamic,
		default_static = tbl.default_static
	}
	self._damage_widgets = {}

	if not self.features_list.damage then
		for k_2, v_2 in pairs(definitions.damage_widget_definitions) do
			self._damage_widgets[#self._damage_widgets + 1] = UIWidget.init(v_2)
		end
	end

	self._portrait_widgets = {
		portrait_static = tbl.portrait_static,
		versus_insignia_static = tbl.versus_insignia_static
	}
	self._equipment_widgets = {
		loadout_dynamic = tbl.loadout_dynamic,
		loadout_static = tbl.loadout_static
	}
	self._health_widgets = {
		health_dynamic = tbl.health_dynamic
	}
	self._ability_widgets = {
		ability_dynamic = tbl.ability_dynamic
	}
	self._respawn_widgets = {
		respawn_dynamic = tbl.respawn_dynamic
	}

	UIRenderer.clear_scenegraph_queue(self.ui_renderer)

	self.slot_equip_animations = {}
	self.bar_animations = {}

	self:reset()

	if not arg_3_1 then
		self:_widget_by_name("health_dynamic").content.hp_bar.texture_id = "teammate_hp_bar_color_tint_" .. arg_3_1
		self:_widget_by_name("health_dynamic").content.total_health_bar.texture_id = "teammate_hp_bar_" .. arg_3_1
	end

	self:set_visible(false)
	self:set_dirty()
end

UnitFrameUI._widget_by_name = function (self, arg_4_1)
	-- function 4
	return self._widgets[arg_4_1]
end

UnitFrameUI._widget_by_feature = function (self, arg_5_1, arg_5_2)
	-- function 5
	local var_5_0 = self.widget_name_by_feature[arg_5_2][arg_5_1]

	return self:_widget_by_name(var_5_0)
end

UnitFrameUI.set_position = function (self, arg_6_1, arg_6_2)
	-- function 6
	local local_position = self.ui_scenegraph.pivot.local_position

	local_position[1] = arg_6_1
	local_position[2] = arg_6_2

	local local_position_2 = self.ui_scenegraph.insignia_pivot.local_position

	local_position_2[1] = arg_6_1
	local_position_2[2] = arg_6_2

	for k, v in pairs(self._widgets) do
		self:_set_widget_dirty(v)
	end

	self:set_dirty()
end

UnitFrameUI.destroy = function (self)
	-- function 7
	self:set_visible(false)
	Managers.state.event:unregister("enter_ghostmode", self)
end

UnitFrameUI.is_visible = function (self)
	-- function 8
	return self._is_visible
end

UnitFrameUI.set_visible = function (self, arg_9_1)
	-- function 9
	self._is_visible = arg_9_1

	local ui_renderer = self.ui_renderer

	for k, v in pairs(self._widgets) do
		UIRenderer.set_element_visible(ui_renderer, v.element, arg_9_1)
	end

	self:set_dirty()
end

UnitFrameUI.set_alpha = function (self, arg_10_1)
	-- function 10
	self.render_settings.alpha_multiplier = arg_10_1

	for k, v in pairs(self._widgets) do
		self:_set_widget_dirty(v)
	end

	self:set_dirty()
end

UnitFrameUI.set_default_alpha = function (self, arg_11_1)
	-- function 11
	self._default_alpha_multiplier = arg_11_1

	for k, v in pairs(self._default_widgets) do
		self:_set_widget_dirty(v)
	end

	self:set_dirty()
end

UnitFrameUI.set_portrait_alpha = function (self, arg_12_1)
	-- function 12
	self._portrait_alpha_multiplier = arg_12_1

	for k, v in pairs(self._portrait_widgets) do
		self:_set_widget_dirty(v)
	end

	self:set_dirty()
end

UnitFrameUI.set_damage_alpha = function (self, arg_13_1)
	-- function 13
	self._damage_alpha_multiplier = arg_13_1

	for k, v in pairs(self._damage_widgets) do
		self:_set_widget_dirty(v)
	end

	self:set_dirty()
end

UnitFrameUI.set_equipment_alpha = function (self, arg_14_1)
	-- function 14
	self._equipment_alpha_multiplier = arg_14_1

	for k, v in pairs(self._equipment_widgets) do
		self:_set_widget_dirty(v)
	end

	self:set_dirty()
end

UnitFrameUI.set_health_alpha = function (self, arg_15_1)
	-- function 15
	self._health_alpha_multiplier = arg_15_1

	for k, v in pairs(self._health_widgets) do
		self:_set_widget_dirty(v)
	end

	self:set_dirty()
end

UnitFrameUI.set_ability_alpha = function (self, arg_16_1)
	-- function 16
	self._ability_alpha_multiplier = arg_16_1

	for k, v in pairs(self._ability_widgets) do
		self:_set_widget_dirty(v)
	end

	self:set_dirty()
end

UnitFrameUI.set_respawn_alpha = function (self, arg_17_1)
	-- function 17
	self._respawn_alpha_multiplier = arg_17_1

	for k, v in pairs(self._respawn_widgets) do
		self:_set_widget_dirty(v)
	end

	self:set_dirty()
end

UnitFrameUI.show_main_healthbar = function (self, arg_18_1)
	-- function 18
	self._widgets.health_dynamic.content.visible = arg_18_1
	self._widgets.default_static.content.show_health_bar = arg_18_1

	self:set_dirty()
end

UnitFrameUI.update = function (self, arg_19_1, arg_19_2)
	-- function 19
	local features_list = self.features_list
	local equipment = features_list.equipment
	local weapons = features_list.weapons
	local damage = features_list.damage
	local flag = false
	local data = self.data
	local is_dead = data.is_dead
	local is_talking = data.is_talking
	local is_knocked_down = data.is_knocked_down
	local assisted_respawn = data.assisted_respawn
	local needs_help = data.needs_help
	local overlay_time = self.overlay_time

	overlay_time = overlay_time or 0
	self.overlay_time = overlay_time + arg_19_1 * 1.4

	if not self:_update_portrait_opacity(is_dead, is_knocked_down, needs_help, assisted_respawn) then
		flag = true
	end

	if not self:_update_voice_animation(arg_19_1, arg_19_2, is_talking) then
		flag = true
	end

	if not self:_update_bar_animations(arg_19_1, arg_19_2) then
		flag = true
	end

	if not self:_update_health_bar_animation(arg_19_1, arg_19_2) then
		flag = true
	end

	if not self:_update_total_health_bar_animation(arg_19_1, arg_19_2) then
		flag = true
	end

	if not weapons and not self:_update_overcharge_animation(arg_19_1, arg_19_2) then
		flag = true
	end

	if not equipment and not self:_update_slot_equip_animations(arg_19_1, arg_19_2) then
		flag = true
	end

	if not self:_update_connection_animation(arg_19_1, arg_19_2) then
		flag = true
	end

	if not damage and not self:_update_damage_feedback(arg_19_1, arg_19_2) then
		flag = true
	end

	if not flag then
		self:set_dirty()
	end
end

UnitFrameUI.on_resolution_modified = function (self)
	-- function 20
	local var_20_0 = self
	local set_player_name = self.set_player_name
	local _player_name = self._player_name

	_player_name = _player_name or ""

	set_player_name(var_20_0, _player_name)

	for k, v in pairs(self._widgets) do
		self:_set_widget_dirty(v)
	end

	self:set_dirty()
end

local tbl = {
	root_scenegraph_id = "portrait_pivot",
	label = "You",
	registry_key = "player_portrait",
	drag_scenegraph_id = "portrait_pivot_dragger"
}
local tbl_2 = {
	root_scenegraph_id = "player_status",
	is_child = true,
	registry_key = "player_status"
}
local tbl_3 = {
	root_scenegraph_id = "pivot",
	label = "Team",
	registry_key = "teammate_portrait",
	drag_scenegraph_id = "pivot_dragger"
}

UnitFrameUI.draw = function (self, arg_21_1)
	-- function 21
	if not self._is_visible then
		return
	end

	if self._frame_type == "player" then
		if not HudCustomizer.run(self.ui_renderer, self.ui_scenegraph, tbl) then
			UIUtils.mark_dirty(self._portrait_widgets)
			UIUtils.mark_dirty(self._default_widgets)
			UIUtils.mark_dirty(self._damage_widgets)

			self._dirty = true
		elseif not HudCustomizer.run(self.ui_renderer, self.ui_scenegraph, tbl_2) then
			UIUtils.mark_dirty(self._health_widgets)
			UIUtils.mark_dirty(self._ability_widgets)
			UIUtils.mark_dirty(self._damage_widgets)

			self._dirty = true
		end
	elseif self._frame_type ~= "team" or not HudCustomizer.run(self.ui_renderer, self.ui_scenegraph, tbl_3) then
		UIUtils.mark_dirty(self._portrait_widgets)
		UIUtils.mark_dirty(self._default_widgets)
		UIUtils.mark_dirty(self._health_widgets)
		UIUtils.mark_dirty(self._ability_widgets)
		UIUtils.mark_dirty(self._damage_widgets)

		self._dirty = true
	end

	if not self._dirty then
		return
	end

	local ui_renderer = self.ui_renderer
	local ui_scenegraph = self.ui_scenegraph
	local get_service = self.input_manager:get_service("ingame_menu")
	local render_settings = self.render_settings
	local alpha_multiplier = render_settings.alpha_multiplier

	UIRenderer.begin_pass(ui_renderer, ui_scenegraph, get_service, arg_21_1, nil, self.render_settings)

	local _default_alpha_multiplier = self._default_alpha_multiplier

	_default_alpha_multiplier = _default_alpha_multiplier or alpha_multiplier
	render_settings.alpha_multiplier = _default_alpha_multiplier

	for k, v in pairs(self._default_widgets) do
		UIRenderer.draw_widget(ui_renderer, v)
	end

	local _damage_alpha_multiplier = self._damage_alpha_multiplier

	_damage_alpha_multiplier = _damage_alpha_multiplier or alpha_multiplier
	render_settings.alpha_multiplier = _damage_alpha_multiplier

	for k_2, v_2 in pairs(self._damage_widgets) do
		UIRenderer.draw_widget(ui_renderer, v_2)
	end

	local _portrait_alpha_multiplier = self._portrait_alpha_multiplier

	_portrait_alpha_multiplier = _portrait_alpha_multiplier or alpha_multiplier
	render_settings.alpha_multiplier = _portrait_alpha_multiplier

	for k_3, v_3 in pairs(self._portrait_widgets) do
		UIRenderer.draw_widget(ui_renderer, v_3)
	end

	local _equipment_alpha_multiplier = self._equipment_alpha_multiplier

	_equipment_alpha_multiplier = _equipment_alpha_multiplier or alpha_multiplier
	render_settings.alpha_multiplier = _equipment_alpha_multiplier

	for k_4, v_4 in pairs(self._equipment_widgets) do
		UIRenderer.draw_widget(ui_renderer, v_4)
	end

	local _health_alpha_multiplier = self._health_alpha_multiplier

	_health_alpha_multiplier = _health_alpha_multiplier or alpha_multiplier
	render_settings.alpha_multiplier = _health_alpha_multiplier

	for k_5, v_5 in pairs(self._health_widgets) do
		UIRenderer.draw_widget(ui_renderer, v_5)
	end

	local _ability_alpha_multiplier = self._ability_alpha_multiplier

	_ability_alpha_multiplier = _ability_alpha_multiplier or alpha_multiplier
	render_settings.alpha_multiplier = _ability_alpha_multiplier

	for k_6, v_6 in pairs(self._ability_widgets) do
		UIRenderer.draw_widget(ui_renderer, v_6)
	end

	local _respawn_alpha_multiplier = self._respawn_alpha_multiplier

	_respawn_alpha_multiplier = _respawn_alpha_multiplier or alpha_multiplier
	render_settings.alpha_multiplier = _respawn_alpha_multiplier

	for k_7, v_7 in pairs(self._respawn_widgets) do
		UIRenderer.draw_widget(ui_renderer, v_7)
	end

	UIRenderer.end_pass(ui_renderer)

	self._dirty = false
end

UnitFrameUI.set_dirty = function (self)
	-- function 22
	self._dirty = true
end

UnitFrameUI._set_widget_dirty = function (arg_23_0, arg_23_1)
	-- function 23
	arg_23_1.element.dirty = true
end

UnitFrameUI.reset = function (self)
	-- function 24
	self:set_player_name("")
	self:set_talking(false)
	self:set_icon_visibility(false)
	self:set_connecting_status(true)
	self:_reset_voice_animation()

	local flag = true
	local flag_2 = false
	local flag_3 = false

	self:set_health_bar_status(flag, flag_2, flag_3)

	if not self.features_list.equipment then
		for k, v in pairs(self.inventory_index_by_slot) do
			self:set_inventory_slot_data(k, false)
		end
	end

	self:set_dirty()
end

UnitFrameUI.set_portrait_frame = function (self, arg_25_1, arg_25_2)
	-- function 25
	local _widgets = self._widgets
	local _portrait_widgets = self._portrait_widgets
	local portrait_static = _widgets.portrait_static

	if not (portrait_static.content.frame_settings_name ~= arg_25_1 or portrait_static.content.level_text ~= arg_25_2) then
		return
	end

	local scale = portrait_static.content.scale

	scale = scale or 1

	UIWidget.destroy(self.ui_renderer, portrait_static)

	local flag = true
	local create_portrait_frame = UIWidgets.create_portrait_frame("portrait_pivot", arg_25_1, arg_25_2, scale, flag)
	local var_25_6 = UIWidget.init(create_portrait_frame, self.ui_renderer)

	_widgets.portrait_static = var_25_6
	_portrait_widgets.portrait_static = _widgets.portrait_static

	local content = var_25_6.content

	content.frame_settings_name = arg_25_1
	content.level_text = arg_25_2

	self:_set_widget_dirty(var_25_6)
end

UnitFrameUI.set_portrait = function (self, arg_26_1)
	-- function 26
	local _widget_by_feature = self:_widget_by_feature("default", "static")

	_widget_by_feature.content.character_portrait = arg_26_1

	self:_set_widget_dirty(_widget_by_feature)
end

UnitFrameUI.set_host_status = function (self, arg_27_1)
	-- function 27
	local _widget_by_feature = self:_widget_by_feature("default", "static")

	_widget_by_feature.content.is_host = arg_27_1

	self:_set_widget_dirty(_widget_by_feature)
end

UnitFrameUI.set_versus_level = function (self, arg_28_1)
	-- function 28
	local get_insignia_texture_settings_from_level, var_28_1 = UIAtlasHelper.get_insignia_texture_settings_from_level(arg_28_1)
	local _widget_by_feature = self:_widget_by_feature("versus_insignia", "static")

	if not _widget_by_feature then
		return
	end

	local current_mechanism_name = Managers.mechanism:current_mechanism_name()
	local user_setting = Application.user_setting("toggle_versus_level_in_all_game_modes")
	local flag = current_mechanism_name == "versus" or user_setting
	local content = _widget_by_feature.content

	content.insignia_main.uvs = get_insignia_texture_settings_from_level
	content.insignia_addon.uvs = var_28_1
	content.level = arg_28_1
	content.visible = not flag and arg_28_1 > 0

	if current_mechanism_name ~= "versus" then
		local scenegraph_definition = self.definitions.scenegraph_definition
		local position = self.ui_scenegraph.player_status.position
		local var_28_9 = scenegraph_definition.player_status.position[1]
		local flag_2

		flag_2 = not user_setting and 0 and UISettings.INSIGNIA_OFFSET
		position[1] = var_28_9 - flag_2

		local position_2 = self.ui_scenegraph.portrait_pivot_parent.position
		local var_28_12 = scenegraph_definition.portrait_pivot_parent.position[1]
		local flag_3

		flag_3 = not user_setting and 0 and UISettings.INSIGNIA_OFFSET
		position_2[1] = var_28_12 - flag_3
	end

	for k, v in pairs(self._widgets) do
		self:_set_widget_dirty(v)
	end

	self:set_dirty()
end

UnitFrameUI.set_talking = function (self, arg_29_1)
	-- function 29
	local _widget_by_feature = self:_widget_by_feature("default", "dynamic")

	_widget_by_feature.content.is_talking = arg_29_1

	self:_set_widget_dirty(_widget_by_feature)
end

UnitFrameUI.set_status_icon = function (self, arg_30_1, arg_30_2)
	-- function 30
	local _widget_by_feature = self:_widget_by_feature("status_icon", "dynamic")
	local content = _widget_by_feature.content
	local style = _widget_by_feature.style

	content.portrait_icon = arg_30_1
	style.portrait_icon.color[1] = arg_30_2 or 255

	self:_set_widget_dirty(_widget_by_feature)
end

UnitFrameUI.set_connecting_status = function (self, arg_31_1)
	-- function 31
	local _widget_by_feature = self:_widget_by_feature("default", "dynamic")

	_widget_by_feature.content.connecting = arg_31_1

	self:_set_widget_dirty(_widget_by_feature)
end

UnitFrameUI.set_icon_visibility = function (self, arg_32_1)
	-- function 32
	local _widget_by_feature = self:_widget_by_feature("status_icon", "dynamic")

	_widget_by_feature.content.display_portrait_icon = arg_32_1

	self:_set_widget_dirty(_widget_by_feature)
end

UnitFrameUI.set_portrait_status = function (self, arg_33_1, arg_33_2, arg_33_3, arg_33_4)
	-- function 33
	local _widget_by_feature = self:_widget_by_feature("default", "static")
	local character_portrait = _widget_by_feature.content.character_portrait
	local gui_retained = self.ui_renderer.gui_retained
	local material = Gui.material(gui_retained, character_portrait)

	if arg_33_1 or arg_33_2 or not arg_33_3 then
		Material.set_vector2(material, "saturate_params", Vector2(0.7, 1))
	else
		Material.set_vector2(material, "saturate_params", Vector2(0, 1))
	end

	if not arg_33_2 then
		self:set_status_icon("status_icon_needs_assist", 150)
	elseif not arg_33_4 then
		self:set_status_icon("status_icon_respawn", 150)
	elseif not arg_33_3 then
		self:set_status_icon("status_icon_dead", 255)
	end

	self:_set_widget_dirty(_widget_by_feature)
end

UnitFrameUI.set_player_name = function (self, arg_34_1)
	-- function 34
	local _widget_by_feature = self:_widget_by_feature("player_name", "static")

	if not _widget_by_feature then
		local content = _widget_by_feature.content
		local var_34_2 = arg_34_1
		local num_2 = 170 * RESOLUTION_LOOKUP.scale

		if not IS_PS4 then
			local player_name = _widget_by_feature.style.player_name
			local player_name_shadow = _widget_by_feature.style.player_name_shadow

			player_name.font_size = 18
			player_name_shadow.font_size = 18

			local scaled_font_size_by_width = UIRenderer.scaled_font_size_by_width(self.ui_renderer, var_34_2, num_2, player_name)

			_widget_by_feature.style.player_name.font_size = scaled_font_size_by_width
			player_name_shadow.font_size = UIRenderer.scaled_font_size_by_width(self.ui_renderer, var_34_2, num_2, player_name_shadow)
		else
			var_34_2 = not _widget_by_feature.style.player_name and Utf8.length(arg_34_1) > num and UIRenderer.crop_text_width(self.ui_renderer, arg_34_1, num_2, _widget_by_feature.style.player_name) and arg_34_1
		end

		content.player_name = var_34_2

		self:_set_widget_dirty(_widget_by_feature)
	end

	self._player_name = arg_34_1
end

local tbl_4 = {
	"item_count_1",
	"item_count_2",
	"item_count_3"
}

UnitFrameUI.set_inventory_slot_data = function (self, arg_35_1, arg_35_2, arg_35_3, arg_35_4)
	-- function 35
	local flag = not arg_35_2 and arg_35_3.name
	local flag_2 = not arg_35_2 and arg_35_3.hud_icon
	local _widget_by_feature = self:_widget_by_feature("equipment", "dynamic")
	local content = _widget_by_feature.content
	local style = _widget_by_feature.style
	local inventory_consumable_slot_colors = UISettings.inventory_consumable_slot_colors
	local var_35_6 = self.inventory_index_by_slot[arg_35_1]

	if not var_35_6 then
		local str = "item_slot_" .. var_35_6
		local str_2 = "item_slot_bg_" .. var_35_6
		local str_3 = "item_slot_frame_" .. var_35_6

		content[str] = not arg_35_2 and flag_2 and "icons_placeholder"

		local color = style[str].color
		local flag_3

		flag_3 = not arg_35_2 and 255 and 0
		color[1] = flag_3

		local color_2 = style[str_2].color
		local flag_4

		flag_4 = not arg_35_2 and 255 and 100
		color_2[1] = flag_4

		local color_3 = style[str_3].color
		local flag_5

		flag_5 = not arg_35_2 and 255 and 100
		color_3[1] = flag_5

		local var_35_16 = tbl_4[var_35_6]

		if not var_35_16 then
			if not (not arg_35_4 and not (arg_35_4 > 0)) then
				content[var_35_16] = arg_35_4
			else
				content[var_35_16] = nil
			end
		end

		if not inventory_consumable_slot_colors then
			local default = inventory_consumable_slot_colors.default
			local var_35_18

			if not arg_35_2 then
				var_35_18 = inventory_consumable_slot_colors[flag]

				if not (var_35_18 or default) then
					-- Nothing
				end
			end

			::label_35_0::

			var_35_18 = default

			::label_35_1::

			local color_4 = style[str_2].color

			color_4[2] = var_35_18[2]
			color_4[3] = var_35_18[3]
			color_4[4] = var_35_18[4]
		end

		if not arg_35_2 then
			self:_add_slot_equip_animation(arg_35_1 .. "_equip_anim", _widget_by_feature, style["item_slot_highlight_" .. var_35_6])
		end
	end

	self:_set_widget_dirty(_widget_by_feature)
end

UnitFrameUI.set_equipped_weapon_info = function (self, arg_36_1, arg_36_2, arg_36_3, arg_36_4)
	-- function 36
	local _widget_by_feature = self:_widget_by_feature("weapons", "dynamic")
	local content = _widget_by_feature.content
	local style = _widget_by_feature.style

	if not arg_36_2 then
		content.equipped_weapon = arg_36_4
		content.equipped_weapon_slot = arg_36_1
	elseif not (content.equipped_weapon_slot == arg_36_1 or content.equipped_weapon) then
		content.equipped_weapon = arg_36_4
	end

	for k, v in pairs(self.weapon_slot_widget_settings.ammo_fields) do
		if arg_36_1 == k then
			local flag

			flag = not arg_36_2 and 255 and 100
			style[v].text_color[1] = flag
			style[v .. "_2"].text_color[1] = flag
			style[v .. "_3"].text_color[1] = flag
		end
	end

	self:_set_widget_dirty(_widget_by_feature)
end

local str = " "

UnitFrameUI.set_ammo_for_slot = function (self, arg_37_1, arg_37_2, arg_37_3, arg_37_4)
	-- function 37
	local _widget_by_feature = self:_widget_by_feature("weapons", "dynamic")
	local content = _widget_by_feature.content
	local var_37_2 = self.weapon_slot_widget_settings.ammo_fields[arg_37_1]

	if not (not arg_37_2 and arg_37_3) then
		content[var_37_2] = " "
		content[var_37_2 .. "_2"] = " "
		content[var_37_2 .. "_3"] = " "
	else
		content[var_37_2] = str .. tostring(arg_37_2)

		local str_2 = var_37_2 .. "_2"
		local var_37_4

		if not arg_37_4 then
			var_37_4 = str

			if not var_37_4 then
				-- Nothing
			end
		end

		var_37_4 = "|"

		::label_37_0::

		content[str_2] = var_37_4

		local str_3 = var_37_2 .. "_3"
		local var_37_6

		if not arg_37_4 then
			var_37_6 = str

			if not var_37_6 then
				-- Nothing
			end
		end

		var_37_6 = tostring(arg_37_3)

		::label_37_1::

		content[str_3] = var_37_6
	end

	self:_set_widget_dirty(_widget_by_feature)
end

UnitFrameUI.set_ammo_percentage = function (self, arg_38_1)
	-- function 38
	local _widget_by_feature = self:_widget_by_feature("ammo", "dynamic")

	_widget_by_feature.content.ammo_percent = arg_38_1

	self:_set_widget_dirty(_widget_by_feature)
	self:set_dirty()
end

UnitFrameUI.set_ability_percentage = function (self, arg_39_1)
	-- function 39
	local _widget_by_feature = self:_widget_by_feature("ability", "dynamic")

	_widget_by_feature.content.actual_ability_percent = arg_39_1

	self:_on_player_ability_changed("ability", _widget_by_feature, arg_39_1)
	self:_set_widget_dirty(_widget_by_feature)
end

UnitFrameUI.set_overcharge_percentage = function (self, arg_40_1, arg_40_2)
	-- function 40
	local _widget_by_feature = self:_widget_by_feature("weapons", "dynamic")
	local content = _widget_by_feature.content

	content.has_overcharge = arg_40_1
	content.overcharge_fill.has_overcharge = arg_40_1
	content.overcharge_fill.overcharge_percent = arg_40_2 or 0

	self:_set_widget_dirty(_widget_by_feature)
end

UnitFrameUI.set_active_percentage = function (self, arg_41_1)
	-- function 41
	local _widget_by_feature = self:_widget_by_feature("health", "dynamic")

	_widget_by_feature.content.actual_active_percentage = arg_41_1

	self:_set_widget_dirty(_widget_by_feature)
end

UnitFrameUI.set_health_percentage = function (self, arg_42_1, arg_42_2)
	-- function 42
	local _widget_by_feature = self:_widget_by_feature("health", "dynamic")

	_widget_by_feature.content.actual_health_percent = arg_42_1

	self:_on_player_health_changed("health", _widget_by_feature, arg_42_1 * arg_42_2)
	self:_set_widget_dirty(_widget_by_feature)
end

UnitFrameUI.set_total_health_percentage = function (self, arg_43_1, arg_43_2)
	-- function 43
	local _widget_by_feature = self:_widget_by_feature("health", "dynamic")

	_widget_by_feature.content.actual_total_health_percent = arg_43_1

	self:_on_player_total_health_changed("total_health", _widget_by_feature, arg_43_1 * arg_43_2)
	self:_set_widget_dirty(_widget_by_feature)
end

UnitFrameUI.set_health_bar_status = function (self, arg_44_1, arg_44_2, arg_44_3)
	-- function 44
	local _widget_by_feature = self:_widget_by_feature("health", "dynamic")
	local style = _widget_by_feature.style
	local content = _widget_by_feature.content
	local total_health_bar = content.total_health_bar
	local hp_bar = content.hp_bar
	local total_health_bar_2 = style.total_health_bar

	total_health_bar.draw_health_bar = arg_44_1
	total_health_bar.is_knocked_down = arg_44_2
	total_health_bar.is_wounded = arg_44_3

	if not self.features_list.equipment then
		self:_widget_by_feature("equipment", "dynamic").content.draw_health_bar = arg_44_1
	end

	local color = total_health_bar_2.color

	if not arg_44_2 then
		color[2] = 255
		color[3] = 0
		color[4] = 0
		hp_bar.hide = true
	else
		color[2] = 255
		color[3] = 255
		color[4] = 255
		hp_bar.hide = false
	end

	self:_set_widget_dirty(_widget_by_feature)
end

UnitFrameUI.set_health_bar_divider_amount = function (self, arg_45_1)
	-- function 45
	local _widget_by_feature = self:_widget_by_feature("health", "dynamic")

	_widget_by_feature.style.hp_bar_divider.texture_amount = arg_45_1

	self:_set_widget_dirty(_widget_by_feature)
end

UnitFrameUI._update_portrait_opacity = function (self, arg_46_1, arg_46_2, arg_46_3, arg_46_4)
	-- function 46
	local var_46_0
	local _widget_by_feature = self:_widget_by_feature("default", "static")
	local color = _widget_by_feature.style.character_portrait.color

	if arg_46_2 or arg_46_3 or not arg_46_4 then
		var_46_0 = 255 * math.sirp(0.6, 1, self.overlay_time)
	elseif not arg_46_1 then
		var_46_0 = 0
	elseif color[1] ~= 255 then
		var_46_0 = 255
	end

	if not var_46_0 then
		color[1] = var_46_0

		self:_set_widget_dirty(_widget_by_feature)

		return true
	end
end

UnitFrameUI._reset_voice_animation = function (self)
	-- function 47
	local _widget_by_feature = self:_widget_by_feature("default", "dynamic")
	local style = _widget_by_feature.style
	local color = style.talk_indicator.color
	local color_2 = style.talk_indicator_glow.color
	local color_3 = style.talk_indicator_highlight.color
	local color_4 = style.talk_indicator_highlight_glow.color

	color[1] = 0
	color_2[1] = 0
	color_3[1] = 0
	color_4[1] = 0

	self:_set_widget_dirty(_widget_by_feature)
end

UnitFrameUI._update_voice_animation = function (self, arg_48_1, arg_48_2, arg_48_3)
	-- function 48
	local _widget_by_feature = self:_widget_by_feature("default", "dynamic")
	local style = _widget_by_feature.style
	local color = style.talk_indicator.color
	local color_2 = style.talk_indicator_glow.color
	local color_3 = _widget_by_feature.style.talk_indicator_highlight.color
	local var_48_5 = color[1]
	local flag

	flag = not arg_48_3 and 1 and -1

	local num = var_48_5 + flag * 255 * arg_48_1
	local var_48_8 = color_3[1]
	local flag_2

	flag_2 = not arg_48_3 and 1 and -1

	local num_2 = var_48_8 + flag_2 * 255 * arg_48_1

	if not arg_48_3 then
		num_2 = num_2 + math.sin(arg_48_2 * 3) * 20
		num_2 = num_2 + math.cos((arg_48_2 + 1) * 13) * 20
	end

	local clamp = math.clamp(num_2, 0, 255)
	local clamp_2 = math.clamp(num, 0, 255)

	if not (clamp ~= color_3[1] or var_48_5 == clamp_2) then
		color[1] = clamp_2
		color_2[1] = clamp_2
		color_3[1] = clamp
		style.talk_indicator_highlight_glow.color[1] = clamp

		self:_set_widget_dirty(_widget_by_feature)

		return true
	end
end

UnitFrameUI._update_health_bar_animation = function (self, arg_49_1, arg_49_2)
	-- function 49
	local hp_bar = self:_widget_by_feature("health", "dynamic").content.hp_bar
	local bar_value = hp_bar.bar_value

	if bar_value ~= hp_bar.internal_bar_value then
		hp_bar.internal_bar_value = bar_value

		return true
	end
end

UnitFrameUI._update_total_health_bar_animation = function (self, arg_50_1, arg_50_2)
	-- function 50
	local total_health_bar = self:_widget_by_feature("health", "dynamic").content.total_health_bar
	local bar_value = total_health_bar.bar_value

	if bar_value ~= total_health_bar.internal_bar_value then
		total_health_bar.internal_bar_value = bar_value

		return true
	end
end

UnitFrameUI.show_respawn_ui = function (self)
	-- function 51
	return self._show_respawn_ui
end

UnitFrameUI.show_respawn_countdown = function (self, arg_52_1, arg_52_2, arg_52_3)
	-- function 52
	self._show_respawn_ui = true

	local _widget_by_name

	if self._frame_type == "player" then
		_widget_by_name = self:_widget_by_name("respawn_dynamic")

		if not _widget_by_name then
			-- Nothing
		end
	end

	_widget_by_name = self:_widget_by_name("default_dynamic")

	::label_52_0::

	local content = _widget_by_name.content

	content.respawn_timer = arg_52_3
	content.total_countdown_time = arg_52_3
	content.state = "countdown"
	content.respawn_info_text = Localize("vs_respawn_in_ghostmode")

	local style = _widget_by_name.style
	local respawn_countdown_text = style.respawn_countdown_text

	if not respawn_countdown_text then
		respawn_countdown_text.text_color[1] = 255
	end

	local respawn_info_text = style.respawn_info_text

	if not respawn_info_text then
		respawn_info_text.text_color[1] = 255
	end
end

UnitFrameUI.update_respawn_countdown = function (self, arg_53_1, arg_53_2)
	-- function 53
	arg_53_2, arg_53_1 = Managers.time:time_and_delta("game")

	local ui_renderer = self.ui_renderer
	local ui_scenegraph = self.ui_scenegraph
	local get_service = self.input_manager:get_service("Player")
	local flag = self._frame_type == "player"
	local _widget_by_name

	if not flag then
		_widget_by_name = self:_widget_by_name("respawn_dynamic")

		if not _widget_by_name then
			-- Nothing
		end
	end

	_widget_by_name = self:_widget_by_name("default_dynamic")

	::label_53_0::

	local content = _widget_by_name.content
	local state = content.state
	local num = 0.66

	if state == "countdown" then
		local num_2 = content.respawn_timer - Managers.time:time("game")
		local total_fadeout_time = content.total_fadeout_time

		total_fadeout_time = total_fadeout_time or num

		if num_2 <= total_fadeout_time then
			content.fadeout_time = total_fadeout_time
			state = "fadeout"
		end

		content.respawn_countdown_text = tostring(math.ceil(math.abs(num_2)))
	elseif state == "fadeout" then
		local style = _widget_by_name.style
		local fadeout_time = content.fadeout_time

		fadeout_time = fadeout_time or num

		local num_3 = fadeout_time - arg_53_1
		local total_fadeout_time_2 = content.total_fadeout_time

		total_fadeout_time_2 = total_fadeout_time_2 or num

		local flag_2

		flag_2 = not (total_fadeout_time_2 <= 0) or not 0 or math.max(num_3, 0) / total_fadeout_time_2

		local num_4 = flag_2 * 255

		style.respawn_countdown_text.text_color[1] = num_4

		if not flag then
			style.respawn_info_text.text_color[1] = num_4
		end

		content.fadeout_time = num_3

		if num_3 <= 0 then
			state = "hidden"
			self._show_respawn_ui = false
			content.respawn_countdown_text = ""

			if not flag then
				content.respawn_info_text = ""
			end
		end
	end

	content.state = state

	Debug.text("RESPAWN GUI UPDATED")
	UIRenderer.begin_pass(ui_renderer, ui_scenegraph, get_service, arg_53_1)
	UIRenderer.draw_widget(ui_renderer, _widget_by_name)
	UIRenderer.end_pass(ui_renderer)
	self:set_dirty()

	return true
end

UnitFrameUI._update_overcharge_animation = function (self, arg_54_1, arg_54_2)
	-- function 54
	local _widget_by_feature = self:_widget_by_feature("weapons", "dynamic")
	local content = _widget_by_feature.content
	local style = _widget_by_feature.style

	if not content.has_overcharge then
		return
	end

	local overcharge_fill = style.overcharge_fill
	local overcharge_fill_2 = content.overcharge_fill
	local overcharge_percent = overcharge_fill_2.overcharge_percent

	if not (overcharge_fill_2.internal_overcharge_percent ~= overcharge_percent) then
		local bar_start_side = content.bar_start_side
		local uv_start_pixels = overcharge_fill.uv_start_pixels
		local uv_scale_pixels = overcharge_fill.uv_scale_pixels
		local scale_axis = overcharge_fill.scale_axis
		local offset = overcharge_fill.offset
		local size = overcharge_fill.size
		local uvs = overcharge_fill_2.uvs
		local var_54_13 = uv_scale_pixels
		local num = uv_start_pixels + uv_scale_pixels
		local num_2 = uv_start_pixels + uv_scale_pixels * overcharge_percent

		size[scale_axis] = num_2

		if bar_start_side == "left" then
			uvs[2][scale_axis] = num / (uv_start_pixels + uv_scale_pixels)

			local start_offset = overcharge_fill.start_offset

			offset[scale_axis] = math.max(start_offset + var_54_13, start_offset + uv_scale_pixels - num_2)
		else
			uvs[2][scale_axis] = num / (uv_start_pixels + uv_scale_pixels)
			offset[scale_axis] = overcharge_fill.start_offset + var_54_13 - num_2
		end

		overcharge_fill_2.internal_overcharge_percent = overcharge_percent

		return true
	end
end

UnitFrameUI._on_num_grimoires_changed = function (self, arg_55_1, arg_55_2, arg_55_3)
	-- function 55
	if not self.bar_animations then
		self.bar_animations = {}
	end

	local var_55_0 = self.bar_animations[arg_55_1]

	var_55_0 = var_55_0 or {}

	if arg_55_3 ~= var_55_0.current_health_debuff then
		local bar_value = arg_55_2.content.grimoire_debuff.bar_value
		local grimoire_debuff = arg_55_2.style.grimoire_debuff
		local hp_bar = arg_55_2.style.hp_bar
		local health_bar_lerp_time = UISettings.unit_frames.health_bar_lerp_time
		local var_55_5

		if bar_value < arg_55_3 then
			var_55_5 = (arg_55_3 - bar_value) * health_bar_lerp_time
		else
			var_55_5 = (bar_value - arg_55_3) * health_bar_lerp_time
		end

		local num = grimoire_debuff.uv_scale_pixels - hp_bar.uv_scale_pixels
		local num_2 = (hp_bar.uv_scale_pixels * arg_55_3 + num * 0.5) / grimoire_debuff.uv_scale_pixels

		arg_55_3 = num_2
		var_55_0.animate = true
		var_55_0.new_value = num_2
		var_55_0.previous_value = bar_value
		var_55_0.time = 0
		var_55_0.total_time = var_55_5
		var_55_0.widget = arg_55_2
		var_55_0.bar = arg_55_2.content.grimoire_debuff
	end

	var_55_0.current_health_debuff = arg_55_3
	self.bar_animations[arg_55_1] = var_55_0
end

UnitFrameUI._on_overcharge_changed = function (self, arg_56_1, arg_56_2, arg_56_3)
	-- function 56
	if not self.bar_animations then
		self.bar_animations = {}
	end

	local var_56_0 = self.bar_animations[arg_56_1]

	var_56_0 = var_56_0 or {}

	if arg_56_3 ~= var_56_0.current_overcharge_percent then
		local bar_value = arg_56_2.content.overcharge_fill.bar_value
		local health_bar_lerp_time = UISettings.unit_frames.health_bar_lerp_time
		local var_56_3

		if bar_value < arg_56_3 then
			var_56_3 = (arg_56_3 - bar_value) * health_bar_lerp_time
		else
			var_56_3 = (bar_value - arg_56_3) * health_bar_lerp_time
		end

		var_56_0.animate = true
		var_56_0.new_value = arg_56_3
		var_56_0.previous_value = bar_value
		var_56_0.time = 0
		var_56_0.total_time = var_56_3
		var_56_0.widget = arg_56_2
		var_56_0.bar = arg_56_2.content.overcharge_fill
	end

	var_56_0.current_overcharge_percent = arg_56_3
	self.bar_animations[arg_56_1] = var_56_0
end

UnitFrameUI._on_player_ammo_changed = function (self, arg_57_1, arg_57_2, arg_57_3)
	-- function 57
	local var_57_0 = self.bar_animations[arg_57_1]

	var_57_0 = var_57_0 or {}
	self.bar_animations[arg_57_1] = var_57_0

	local current_health = var_57_0.current_health

	var_57_0.current_health = arg_57_3

	if not (not (arg_57_3 <= 1) or arg_57_3 == current_health) then
		local bar_value = arg_57_2.content.ammo_bar.bar_value
		local health_bar_lerp_time = UISettings.unit_frames.health_bar_lerp_time
		local var_57_4

		if bar_value < arg_57_3 then
			var_57_4 = (arg_57_3 - bar_value) * health_bar_lerp_time
		else
			var_57_4 = (bar_value - arg_57_3) * health_bar_lerp_time
		end

		var_57_0.animate = true
		var_57_0.new_value = arg_57_3
		var_57_0.previous_value = bar_value
		var_57_0.time = 0
		var_57_0.total_time = var_57_4
		var_57_0.widget = arg_57_2
		var_57_0.content = arg_57_2.content.ammo_bar
		var_57_0.style = arg_57_2.style.ammo_bar

		return true
	end
end

UnitFrameUI._on_player_ability_changed = function (self, arg_58_1, arg_58_2, arg_58_3)
	-- function 58
	local var_58_0 = self.bar_animations[arg_58_1]

	var_58_0 = var_58_0 or {}
	self.bar_animations[arg_58_1] = var_58_0

	local current_health = var_58_0.current_health

	var_58_0.current_health = arg_58_3

	if not (not (arg_58_3 <= 1) or arg_58_3 == current_health) then
		local bar_value = arg_58_2.content.ability_bar.bar_value
		local health_bar_lerp_time = UISettings.unit_frames.health_bar_lerp_time
		local var_58_4

		if bar_value < arg_58_3 then
			var_58_4 = (arg_58_3 - bar_value) * health_bar_lerp_time
		else
			var_58_4 = (bar_value - arg_58_3) * health_bar_lerp_time
		end

		var_58_0.animate = true
		var_58_0.new_value = arg_58_3
		var_58_0.previous_value = bar_value
		var_58_0.time = 0
		var_58_0.total_time = var_58_4
		var_58_0.widget = arg_58_2
		var_58_0.content = arg_58_2.content.ability_bar
		var_58_0.style = arg_58_2.style.ability_bar

		return true
	end
end

UnitFrameUI._on_player_health_changed = function (self, arg_59_1, arg_59_2, arg_59_3)
	-- function 59
	local var_59_0 = self.bar_animations[arg_59_1]

	var_59_0 = var_59_0 or {}
	self.bar_animations[arg_59_1] = var_59_0

	local current_health = var_59_0.current_health

	var_59_0.current_health = arg_59_3

	if not (not (arg_59_3 <= 1) or arg_59_3 == current_health) then
		local is_knocked_down = arg_59_2.content.hp_bar.is_knocked_down
		local bar_value = arg_59_2.content.hp_bar.bar_value
		local health_bar_lerp_time = UISettings.unit_frames.health_bar_lerp_time
		local var_59_5

		if bar_value < arg_59_3 then
			var_59_5 = (arg_59_3 - bar_value) * health_bar_lerp_time
		else
			var_59_5 = (bar_value - arg_59_3) * health_bar_lerp_time
		end

		local flag

		flag = not ((is_knocked_down or not (arg_59_3 < (current_health or 1))) and false) and 0 and var_59_0.animate_damage_highlight
		var_59_0.animate_damage_highlight = flag
		var_59_0.animate = true
		var_59_0.new_value = arg_59_3
		var_59_0.previous_value = bar_value
		var_59_0.time = 0
		var_59_0.total_time = var_59_5
		var_59_0.widget = arg_59_2
		var_59_0.content = arg_59_2.content.hp_bar
		var_59_0.style = arg_59_2.style.hp_bar

		return true
	end
end

UnitFrameUI._on_player_total_health_changed = function (self, arg_60_1, arg_60_2, arg_60_3)
	-- function 60
	local var_60_0 = self.bar_animations[arg_60_1]

	var_60_0 = var_60_0 or {}
	self.bar_animations[arg_60_1] = var_60_0

	local current_health = var_60_0.current_health

	var_60_0.current_health = arg_60_3

	if not (not (arg_60_3 <= 1) or arg_60_3 == current_health) then
		local is_knocked_down = arg_60_2.content.hp_bar.is_knocked_down
		local bar_value = arg_60_2.content.total_health_bar.bar_value
		local health_bar_lerp_time = UISettings.unit_frames.health_bar_lerp_time
		local var_60_5

		if bar_value < arg_60_3 then
			var_60_5 = (arg_60_3 - bar_value) * health_bar_lerp_time
		else
			var_60_5 = (bar_value - arg_60_3) * health_bar_lerp_time
		end

		local flag

		flag = not ((is_knocked_down or not (arg_60_3 < (current_health or 1))) and false) and 0 and var_60_0.animate_bar_flash
		var_60_0.animate_bar_flash = flag
		var_60_0.animate = true
		var_60_0.new_value = arg_60_3
		var_60_0.previous_value = bar_value
		var_60_0.time = 0
		var_60_0.total_time = var_60_5
		var_60_0.widget = arg_60_2
		var_60_0.content = arg_60_2.content.total_health_bar
		var_60_0.style = arg_60_2.style.total_health_bar

		return true
	end
end

UnitFrameUI._update_bar_animations = function (self, arg_61_1)
	-- function 61
	local flag = false
	local bar_animations = self.bar_animations

	if not bar_animations then
		for k, v in pairs(bar_animations) do
			local flag_2 = false
			local widget = v.widget
			local content = v.content
			local style = v.style

			if not content and not content.low_health then
				UIAnimation.update(v.low_health_animation, arg_61_1)

				flag = true
				flag_2 = true
			end

			if not v.animate_damage_highlight then
				v.animate_damage_highlight = self:_update_damage_highlight(widget, v.animate_damage_highlight, arg_61_1)
				flag = true
				flag_2 = true
			end

			if not v.animate_bar_flash then
				v.animate_bar_flash = self:_update_bar_flash(widget, style, v.animate_bar_flash, arg_61_1)
				flag = true
				flag_2 = true
			end

			if not v.animate then
				local time = v.time
				local total_time = v.total_time
				local new_value = v.new_value
				local previous_value = v.previous_value
				local _update_player_bar_animation = self:_update_player_bar_animation(content, style, time, total_time, previous_value, new_value, arg_61_1)

				flag_2 = true

				if not _update_player_bar_animation then
					v.time = _update_player_bar_animation
				else
					v.animate = nil
				end

				flag = true
			end

			if not flag_2 then
				self:_set_widget_dirty(widget)
			end
		end
	end

	return flag
end

UnitFrameUI._update_bar_flash = function (self, arg_62_1, arg_62_2, arg_62_3, arg_62_4)
	-- function 62
	local num = 0.3

	arg_62_3 = arg_62_3 + arg_62_4

	if num > 0 then
		local min = math.min(arg_62_3 / num, 1)
		local num_2 = 155 + 100 * math.max(1 - math.ease_pulse(min), 0)

		arg_62_2.color[1] = num_2

		self:_set_widget_dirty(arg_62_1)

		return not (min < 1) or not arg_62_3 or nil
	end

	return nil
end

UnitFrameUI._update_damage_highlight = function (self, arg_63_1, arg_63_2, arg_63_3)
	-- function 63
	local num = 0.2

	arg_63_2 = arg_63_2 + arg_63_3

	if num > 0 then
		local style = arg_63_1.style
		local min = math.min(arg_63_2 / num, 1)
		local num_2 = 255 * math.catmullrom(min, -8, 0, 0, -8)

		style.hp_bar_highlight.color[1] = num_2

		self:_set_widget_dirty(arg_63_1)

		return not (min < 1) or not arg_63_2 or nil
	end

	return nil
end

UnitFrameUI._update_player_bar_animation = function (arg_64_0, arg_64_1, arg_64_2, arg_64_3, arg_64_4, arg_64_5, arg_64_6, arg_64_7)
	-- function 64
	arg_64_3 = arg_64_3 + arg_64_7

	if arg_64_4 > 0 then
		local min = math.min(arg_64_3 / arg_64_4, 1)
		local num = 7
		local num_2 = (min * (num - 1) + 1) / num
		local var_64_3

		if arg_64_5 < arg_64_6 then
			var_64_3 = arg_64_5 + (arg_64_6 - arg_64_5) * num_2
		else
			var_64_3 = arg_64_5 - (arg_64_5 - arg_64_6) * num_2
		end

		arg_64_1.bar_value = var_64_3

		if not arg_64_2.gradient_threshold then
			arg_64_2.gradient_threshold = var_64_3
		end

		return not (min < 1) or not arg_64_3 or nil
	end

	arg_64_1.bar_value = arg_64_6

	if not arg_64_2.gradient_threshold then
		arg_64_2.gradient_threshold = arg_64_6
	end

	return nil
end

UnitFrameUI._add_slot_equip_animation = function (self, arg_65_1, arg_65_2, arg_65_3)
	-- function 65
	local slot_equip_animations = self.slot_equip_animations
	local equip_animation_duration = UISettings.inventory_hud.equip_animation_duration
	local var_65_2 = slot_equip_animations[arg_65_1]

	if not var_65_2 then
		var_65_2.total_time = equip_animation_duration
		var_65_2.time = 0
	else
		slot_equip_animations[arg_65_1] = {
			time = 0,
			total_time = equip_animation_duration,
			style = arg_65_3,
			widget = arg_65_2
		}
	end
end

UnitFrameUI._animate_slot_equip = function (arg_66_0, arg_66_1, arg_66_2)
	-- function 66
	local style = arg_66_1.style
	local total_time = arg_66_1.total_time
	local num = arg_66_1.time + arg_66_2
	local min = math.min(num / total_time, 1)
	local catmullrom = math.catmullrom(min, -10, 0, 0, -4)

	style.color[1] = 255 * catmullrom
	arg_66_1.time = num

	return not (min < 1) or not arg_66_1 or nil
end

UnitFrameUI._update_slot_equip_animations = function (self, arg_67_1)
	-- function 67
	local slot_equip_animations = self.slot_equip_animations
	local flag = false

	for k, v in pairs(slot_equip_animations) do
		slot_equip_animations[k] = self:_animate_slot_equip(v, arg_67_1)

		local widget = v.widget

		self:_set_widget_dirty(widget)

		flag = true
	end

	return flag
end

UnitFrameUI._update_connection_animation = function (self, arg_68_1)
	-- function 68
	if not self._is_visible then
		return false
	end

	local _widget_by_feature = self:_widget_by_feature("default", "dynamic")

	if not _widget_by_feature.content.connecting then
		local connecting_icon = _widget_by_feature.style.connecting_icon
		local num = arg_68_1 * 400 % 360
		local degrees_to_radians = math.degrees_to_radians(num)

		connecting_icon.angle = connecting_icon.angle + degrees_to_radians

		self:_set_widget_dirty(_widget_by_feature)

		return true
	end
end

UnitFrameUI.update_numeric_ui_health = function (self, arg_69_1)
	-- function 69
	local _widget_by_feature = self:_widget_by_feature("health", "dynamic")
	local player = arg_69_1.player
	local flag = not player and player.player_unit

	if not ALIVE[flag] then
		_widget_by_feature.content.numeric_health = ""

		return
	end

	local extensions = arg_69_1.extensions
	local flag_2 = not extensions and extensions.health

	if not flag_2 then
		return
	end

	local ceil = math.ceil(flag_2:get_max_health())
	local ceil_2 = math.ceil(flag_2:current_permanent_health())
	local ceil_3 = math.ceil(flag_2:current_temporary_health())

	if not _widget_by_feature.content.numeric_health then
		return
	end

	if not (self._frame_type == "player") then
		_widget_by_feature.content.numeric_health = string.format("%d(%d)/%d", ceil_2, ceil_3, ceil)
	else
		_widget_by_feature.content.numeric_health = string.format("%d/%d", ceil_2, ceil)
	end

	self:_set_widget_dirty(_widget_by_feature)
end

UnitFrameUI.update_numeric_ui_ammo = function (self, arg_70_1)
	-- function 70
	if self._frame_type == "player" then
		return
	end

	local _ammo_ui_data = self._ammo_ui_data
	local _widget_by_name = self:_widget_by_name("default_dynamic")
	local player = arg_70_1.player
	local flag = not player and player.player_unit

	if not ALIVE[flag] then
		_widget_by_name.content.has_ranged_weapon = false

		return
	end

	local extensions = arg_70_1.extensions
	local flag_2 = not extensions and extensions.inventory

	if not flag_2 then
		return
	end

	if self._frame_type == "team" then
		local slots = flag_2:equipment().slots
		local name = InventorySettings.slots_by_name.slot_ranged.name

		if name == "slot_ranged" then
			local var_70_8 = slots[name]

			if not var_70_8 then
				_widget_by_name.content.has_ranged_weapon = false

				return
			end

			local item_template = var_70_8.item_template

			if not item_template then
				return
			end

			local ammo_data = item_template.ammo_data

			if not ammo_data and not ammo_data.hide_ammo_ui then
				return
			end

			local ammo_status, var_70_12 = flag_2:ammo_status()

			if not ammo_data and not ammo_status and not var_70_12 then
				_widget_by_name.content.has_ranged_weapon = true
				_widget_by_name.content.ammo_count = string.format("%d / %d", ammo_status, var_70_12)

				if _ammo_ui_data[player.peer_id] ~= item_template.name then
					_ammo_ui_data[player.peer_id] = item_template.name
					self.weapon_changed = true
				else
					self.weapon_changed = false
				end
			else
				_widget_by_name.content.has_ranged_weapon = false
			end
		end
	end

	self:_set_widget_dirty(_widget_by_name)
end

UnitFrameUI.update_numeric_ui_career_ability = function (self, arg_71_1, arg_71_2, arg_71_3)
	-- function 71
	local _widget_by_name = self:_widget_by_name("default_dynamic")
	local player = arg_71_3.player
	local flag = not player and player.player_unit

	if not ALIVE[flag] then
		_widget_by_name.content.ability_cooldown = ""

		return
	end

	if not _widget_by_name.content.ability_cooldown then
		return
	end

	local extensions = arg_71_3.extensions
	local flag_2 = not extensions and extensions.career

	if not flag_2 then
		return
	end

	local career_name = flag_2:career_name()
	local game_object_field = GameSession.game_object_field(arg_71_1, arg_71_2, "ability_percentage")
	local flag_3

	flag_3 = not (game_object_field > 0.01) or not true or false
	_widget_by_name.content.on_cooldown = flag_3

	if not flag_3 then
		return
	end

	local playfab_name = CareerSettings[career_name].playfab_name
	local var_71_9

	if not playfab_name then
		_, var_71_9 = flag_2:current_ability_cooldown()
	else
		var_71_9 = ActivatedAbilitySettings[playfab_name][1].cooldown
	end

	local num = var_71_9 * game_object_field

	_widget_by_name.content.ability_cooldown = UIUtils.format_time(num)

	self:_set_widget_dirty(_widget_by_name)
end

local num_2 = 0.01
local num_3 = 0.7
local num_4 = 2
local tbl_5 = {
	[0] = ".00",
	[75] = ".75",
	[25] = ".25",
	[50] = ".50",
	[100] = ".00"
}, {
	[0] = " ",
	[75] = "¾",
	[25] = "¼",
	[50] = "½",
	[100] = " "
}
local num_5 = 4

UnitFrameUI.add_damage_feedback = function (self, arg_72_1, arg_72_2, arg_72_3, arg_72_4, arg_72_5, arg_72_6)
	-- function 72
	local _damage_events = self._damage_events
	local str = arg_72_1 .. arg_72_3
	local _hash_order = self._hash_order
	local _dmg_part_pool = self._dmg_part_pool
	local time = Managers.time:time("game")
	local var_72_5 = _damage_events[str]
	local cached_name = arg_72_5:cached_name()

	cached_name = cached_name or arg_72_5.character_name

	if not var_72_5 then
		var_72_5 = {
			shown_amount_decimal = "",
			running_parts = 0,
			num_dmg_parts = 0,
			text_width = 0,
			first_index = 0,
			text = "",
			shown_amount = 0,
			last_index = 0,
			event_type = arg_72_3,
			dmg_parts = Script.new_array(32),
			next_increment = time - num_2,
			remove_time = math.huge,
			local_player = arg_72_2,
			target_name = cached_name
		}
		_damage_events[str] = var_72_5

		local num = #_hash_order + 1

		_hash_order[num] = str
		var_72_5.hash_order = num

		local var_72_8 = self._damage_widgets[num]

		self._hash_widget_lookup[str] = var_72_8
		var_72_8.content.visible = true
	elseif not var_72_5.disabled then
		var_72_5.disabled = false

		local num_3 = #_hash_order + 1

		_hash_order[num_3] = str
		var_72_5.hash_order = num_3

		local var_72_10 = self._damage_widgets[num_3]

		self._hash_widget_lookup[str] = var_72_10
		var_72_10.content.visible = true
	end

	local dmg_parts = var_72_5.dmg_parts

	var_72_5.num_dmg_parts = var_72_5.num_dmg_parts + 1

	local floor = math.floor(arg_72_6)
	local num_4 = arg_72_6 - floor
	local num_6 = math.floor((num_4 + 0.125) * 4) * 25
	local var_72_15 = tbl_5[num_6]

	var_72_15 = var_72_15 or "  "

	local str_2 = floor .. var_72_15

	dmg_parts[var_72_5.num_dmg_parts] = {
		arg_72_6,
		0,
		"no_id_yet",
		str_2,
		0
	}
	var_72_5.remove_time = math.huge

	if #_hash_order > num_5 then
		fassert(false)

		_damage_events[_hash_order[1]] = nil

		table.remove(_hash_order, 1)
		table.remove(self._hash_widget_lookup, 1)
	end
end

local tbl_6 = {
	dealing_damage = {
		text_function = function (arg_73_0, arg_73_1, arg_73_2)
			-- function 73
			return string.format("%s", arg_73_1), arg_73_0, arg_73_2
		end,
		sound_function = function ()
			-- function 74
			return
		end
	},
	other_dealing_damage = {
		text_function = function (arg_75_0, arg_75_1, arg_75_2)
			-- function 75
			return string.format("%s  ", arg_75_1), arg_75_0, arg_75_2
		end,
		sound_function = function ()
			-- function 76
			return "versus_ui_team_damage_indicator"
		end
	}
}
local tbl_7 = {
	"text_last_dmg",
	"text_last_dmg_2",
	"text_last_dmg_3",
	"text_last_dmg_4",
	"text_last_dmg_5",
	"text_last_dmg_6",
	"text_last_dmg_7",
	"text_last_dmg_8",
	"text_last_dmg_9",
	"text_last_dmg_10"
}

UnitFrameUI._cleanup_damage_event = function (self, arg_77_1, arg_77_2)
	-- function 77
	arg_77_1.num_dmg_parts = 0
	arg_77_1.shown_amount = 0
	arg_77_1.shown_amount_decimal = ""
	arg_77_1.last_index = 0
	arg_77_1.first_index = 0
	arg_77_1.remove_time = math.huge
	arg_77_1.text = ""
	arg_77_1.running_parts = 0
	arg_77_1.disabled = true

	local style = self._hash_widget_lookup[arg_77_2].style
	local dmg_parts = arg_77_1.dmg_parts

	for i = 1, #dmg_parts do
		local var_77_2 = dmg_parts[i]

		var_77_2[1] = 0
		var_77_2[2] = math.huge

		local var_77_3 = style[var_77_2[3]]

		if not var_77_3 then
			var_77_3.text_color[1] = 0
		end
	end
end

UnitFrameUI._update_damage_feedback = function (self, arg_78_1, arg_78_2)
	-- function 78
	local _hash_order = self._hash_order
	local count = #_hash_order

	if count <= 0 then
		return
	end

	local ui_renderer = self.ui_renderer
	local ui_scenegraph = self.ui_scenegraph
	local get_service = self.input_manager:get_service("Player")

	for i = count, 1, -1 do
		local var_78_5 = _hash_order[i]
		local var_78_6 = self._hash_widget_lookup[var_78_5]
		local content = var_78_6.content
		local style = var_78_6.style
		local var_78_9 = self._damage_events[var_78_5]
		local var_78_10 = tbl_6[var_78_9.event_type]

		if arg_78_2 > var_78_9.remove_time then
			self:_cleanup_damage_event(var_78_9, var_78_5)
			table.remove(_hash_order, i)

			content.visible = false
		elseif not (not (arg_78_2 > var_78_9.next_increment) or not (var_78_9.last_index < var_78_9.num_dmg_parts)) then
			var_78_9.last_index = var_78_9.last_index + 1

			local var_78_11 = var_78_9.dmg_parts[var_78_9.last_index]

			var_78_11[2] = arg_78_2 + num_4

			local num = (var_78_9.last_index - 1) % 10 + 1

			var_78_11[3] = tbl_7[num]
			var_78_11[5] = num
			var_78_9.old_shown_amount = var_78_9.shown_amount
			var_78_9.shown_amount = var_78_9.shown_amount + var_78_11[1]
			var_78_9.old_shown_amount_decimal = var_78_9.shown_amount_decimal

			local num_5 = var_78_9.shown_amount - math.floor(var_78_9.shown_amount)
			local num_6 = math.floor((num_5 + 0.125) * 4) * 25
			local var_78_15 = tbl_5[num_6]

			var_78_15 = var_78_15 or ".??"
			var_78_9.shown_amount_decimal = var_78_15

			if var_78_9.running_parts == 0 then
				var_78_9.first_index = 1
			end

			var_78_9.running_parts = var_78_9.running_parts + 1
			var_78_9.next_increment = arg_78_2 + num_2
			var_78_9.scale_timer = arg_78_2 + num_3

			local wwise_world = Managers.world:wwise_world(self.world)
			local sound_function = var_78_10.sound_function()

			if not sound_function then
				WwiseWorld.trigger_event(wwise_world, sound_function)
			end

			var_78_9.text = var_78_9.target_name
			var_78_9.remove_time = arg_78_2 + num_4

			local var_78_18, var_78_19 = UIFontByResolution(style.text)

			var_78_9.text_width = UIRenderer.text_size(ui_renderer, var_78_9.text, var_78_18[1], var_78_19)
		end

		local num_7 = var_78_9.remove_time - arg_78_2
		local fade_duration = UISettings.damage_feedback.fade_duration
		local num_8 = 255 * math.clamp(num_7 / fade_duration, 0, 1)

		content.text = var_78_9.text
		content.icon_texture = var_78_9.icon_texture
		style.text.text_color[1] = num_8
		style.text.offset[1] = var_78_9.text_width * 0.5

		local num_9 = 0
		local num_10 = 0
		local num_11 = 0

		if not var_78_9.scale_timer then
			if arg_78_2 <= var_78_9.scale_timer then
				num_9 = math.clamp((var_78_9.scale_timer - arg_78_2) / num_3, 0, 1)
				num_10 = not (num_9 > 0.5) or not 0.7 or 0
				num_11 = math.ease_pulse(num_9)
			else
				var_78_9.scale_timer = nil
			end
		end

		local old_shown_amount

		if num_9 > 0.5 then
			old_shown_amount = var_78_9.old_shown_amount

			if not old_shown_amount then
				-- Nothing
			end
		end

		old_shown_amount = var_78_9.shown_amount

		::label_78_0::

		var_78_9.text_total_sum = old_shown_amount

		local var_78_27, var_78_28 = UIFontByResolution(var_78_6.style.text_total_sum)

		var_78_9.text_width_total_sum = UIRenderer.text_size(ui_renderer, math.floor(var_78_9.text_total_sum), var_78_27[1], var_78_28)

		local get_color_from_damage = DamageUtils.get_color_from_damage(var_78_9.text_total_sum)
		local num_12 = 24

		style.text_total_sum.font_size = num_12 + 10 * num_11

		local num_13 = num_12 * #tostring("99.99") * 0.2
		local num_14 = style.text.offset[1] + var_78_9.text_width * 0.5 + num_13

		style.text_total_sum.offset[1] = num_14
		style.text_total_sum.text_color = get_color_from_damage
		style.text_total_sum.text_color[1] = math.clamp(num_8, 1, 254)

		local damage_icon = style.damage_icon

		damage_icon.color = get_color_from_damage

		local num_15 = 24 + 10 * num_11 * num_10

		damage_icon.size[1] = num_15
		damage_icon.size[2] = num_15
		var_78_6.content.text_total_sum = math.floor(var_78_9.text_total_sum)

		local old_shown_amount_decimal

		if num_9 > 0.5 then
			old_shown_amount_decimal = var_78_9.old_shown_amount_decimal

			if not old_shown_amount_decimal then
				-- Nothing
			end
		end

		old_shown_amount_decimal = var_78_9.shown_amount_decimal

		::label_78_1::

		var_78_9.text_total_sum_decimal_part = old_shown_amount_decimal
		var_78_6.content.text_total_sum_decimal_part = var_78_9.text_total_sum_decimal_part
		style.text_total_sum_decimal_part.offset[1] = num_14 + var_78_9.text_width_total_sum * 0.5
		style.text_total_sum_decimal_part.text_color = style.text_total_sum.text_color

		local num_16 = num_14 + num_13
		local dmg_parts = var_78_9.dmg_parts
		local first_index = var_78_9.first_index

		if var_78_9.running_parts > 0 then
			if arg_78_2 > dmg_parts[first_index][2] then
				local var_78_39 = dmg_parts[first_index]

				style[var_78_39[3]].text_color[1] = 0
				var_78_39[2] = math.huge
				first_index = first_index + 1
				var_78_9.first_index = first_index
				var_78_9.running_parts = var_78_9.running_parts - 1
			end

			local var_78_40 = first_index
			local last_index = var_78_9.last_index
			local num_17 = 1

			for j = var_78_40, last_index do
				local var_78_43 = dmg_parts[j]
				local var_78_44 = var_78_43[4]
				local var_78_45 = var_78_43[2]
				local var_78_46 = var_78_43[3]
				local var_78_47 = style[var_78_46]
				local clamp = math.clamp((var_78_45 - arg_78_2) / num_4, 0, 1)

				var_78_47.offset[1] = num_16 + math.easeOutCubic(1 - clamp) * 200
				var_78_47.text_color[2] = get_color_from_damage[2]
				var_78_47.text_color[3] = get_color_from_damage[3]
				var_78_47.text_color[4] = get_color_from_damage[4]
				var_78_47.text_color[1] = clamp * clamp * 255
				content[var_78_46] = var_78_44
				num_17 = num_17 + 1
			end
		end
	end

	UIRenderer.begin_pass(ui_renderer, ui_scenegraph, get_service, arg_78_1)

	for k, v in pairs(self._hash_widget_lookup) do
		UIRenderer.draw_widget(ui_renderer, v)
	end

	UIRenderer.end_pass(ui_renderer)

	return true
end
