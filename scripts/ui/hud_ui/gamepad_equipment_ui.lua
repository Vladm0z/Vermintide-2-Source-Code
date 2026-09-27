-- chunkname: @scripts/ui/hud_ui/gamepad_equipment_ui.lua

local var_0_0 = local_require("scripts/ui/hud_ui/gamepad_equipment_ui_definitions")
local scenegraph_definition = var_0_0.scenegraph_definition
local inventory_slot_backgrounds = var_0_0.inventory_slot_backgrounds
local animations_definitions = var_0_0.animations_definitions

GamePadEquipmentUI = class(GamePadEquipmentUI)

local num = 2
local slot_size = var_0_0.slot_size
local NUM_SLOTS = var_0_0.NUM_SLOTS
local tbl = {
	slot_healthkit = "wield_3",
	slot_grenade = "wield_5",
	slot_potion = "wield_4",
	slot_melee = "wield_1",
	slot_ranged = "wield_2"
}
local tbl_2 = {
	normal = Colors.get_color_table_with_alpha("white", 255),
	empty = Colors.get_color_table_with_alpha("red", 255),
	focus = Colors.get_color_table_with_alpha("font_default", 150),
	unfocused = Colors.get_color_table_with_alpha("font_default", 150)
}

local function fn(self, arg_1_1)
	-- function 1
	local console_hud_index = self.console_hud_index

	console_hud_index = console_hud_index or 0

	local console_hud_index_2 = arg_1_1.console_hud_index

	console_hud_index_2 = console_hud_index_2 or 0

	return console_hud_index < console_hud_index_2
end

local function fn_2()
	-- function 2
	local get_local_player_party = Managers.party:get_local_player_party()
	local var_2_1 = Managers.state.side.side_by_party[get_local_player_party]

	return not var_2_1 and var_2_1:name() == "dark_pact"
end

GamePadEquipmentUI.init = function (self, arg_3_1, arg_3_2)
	-- function 3
	self._parent = arg_3_1
	self.ui_renderer = arg_3_2.ui_renderer
	self.ingame_ui = arg_3_2.ingame_ui
	self.input_manager = arg_3_2.input_manager
	self.peer_id = arg_3_2.peer_id
	self.player_manager = arg_3_2.player_manager
	self.ui_animations = {}
	self._animations = {}
	self.render_settings = {
		alpha_multiplier = 1,
		snap_pixel_positions = false
	}
	self.is_in_inn = arg_3_2.is_in_inn
	self.cleanui = arg_3_2.cleanui
	self._retained_elements_visible = false
	self.player = arg_3_2.player
	self._game_options_dirty = true
	self._reload_attempts = 0

	self:_create_ui_elements()

	local event = Managers.state.event

	event:register(self, "input_changed", "event_input_changed")
	event:register(self, "swap_equipment_from_storage", "event_swap_equipment_from_storage")
	event:register(self, "on_game_options_changed", "_set_game_options_dirty")
	self:_update_game_options()
end

GamePadEquipmentUI._create_ui_elements = function (self)
	-- function 4
	self.ui_scenegraph = UISceneGraph.init_scenegraph(scenegraph_definition)

	local tbl = {}
	local tbl_2 = {}
	local tbl_3 = {}
	local tbl_4 = {}
	local tbl_5 = {}
	local tbl_6 = {}
	local tbl_7 = {}
	local tbl_8 = {}
	local tbl_9 = {}
	local tbl_10 = {}

	for k, v in pairs(var_0_0.widget_definitions) do
		local var_4_10 = UIWidget.init(v)

		tbl_2[k] = var_4_10
		tbl_10[#tbl_10 + 1] = var_4_10
	end

	for k_2, v_2 in pairs(var_0_0.career_widget_definitions) do
		local var_4_11 = UIWidget.init(v_2)

		tbl_2[k_2] = var_4_11
		tbl_9[k_2] = var_4_11
		tbl_10[#tbl_10 + 1] = var_4_11
	end

	for i, v_3 in ipairs(var_0_0.slot_widget_definitions) do
		local var_4_12 = UIWidget.init(v_3)

		tbl[i] = var_4_12
		tbl_7[i] = var_4_12
		tbl_8[i] = var_4_12
	end

	for k_3, v_4 in pairs(var_0_0.ammo_widget_definitions) do
		local var_4_13 = UIWidget.init(v_4)

		tbl_5[#tbl_5 + 1] = var_4_13
		tbl_6[k_3] = var_4_13
		tbl_2[k_3] = var_4_13
	end

	for k_4, v_5 in pairs(var_0_0.frame_definitions) do
		local var_4_14 = UIWidget.init(v_5)

		tbl_3[#tbl_3 + 1] = var_4_14
		tbl_4[k_4] = var_4_14
		tbl_2[k_4] = var_4_14
	end

	self._widgets = tbl
	self._widgets_by_name = tbl_2
	self._ammo_widgets = tbl_5
	self._ammo_widgets_by_name = tbl_6
	self._frame_widgets = tbl_3
	self._frame_widgets_by_name = tbl_4
	self._static_widgets = tbl_10
	self._unused_widgets = tbl_7
	self._slot_widgets = tbl_8
	self._career_widgets = tbl_9
	self._ui_animator = UIAnimator:new(self.ui_scenegraph, animations_definitions)

	local tbl_11 = {}

	for i_2, v_6 in ipairs(var_0_0.extra_storage_icon_definitions) do
		tbl_11[i_2] = UIWidget.init(v_6)
	end

	self._extra_storage_icon_widgets = tbl_11
	tbl_2.overcharge_background.style.texture_id.color = {
		100,
		150,
		150,
		150
	}
	tbl_2.overcharge.style.texture_id.color = Colors.get_color_table_with_alpha("font_title", 255)
	self._added_items = {}

	UIRenderer.clear_scenegraph_queue(self.ui_renderer)
	self:event_input_changed()
	self:_set_widget_visibility(self._ammo_widgets_by_name.reload_tip_text, false)
	self:set_visible(true)
	self:set_dirty()

	self._num_added_items = 0
end

GamePadEquipmentUI.event_swap_equipment_from_storage = function (self, arg_5_1, arg_5_2)
	-- function 5
	if arg_5_1 ~= "slot_grenade" then
		return
	end

	self._widgets_by_name.extra_storage_bg.style.texture.color[1] = 163
	self._time_fade_storage_slots = Managers.time:time("ui") + 2

	local _extra_storage_icon_widgets = self._extra_storage_icon_widgets

	for i = 1, #_extra_storage_icon_widgets do
		local var_5_1 = _extra_storage_icon_widgets[i]
		local var_5_2 = arg_5_2[i]

		if not var_5_2 then
			local gamepad_hud_icon = var_5_2.gamepad_hud_icon
			local style = var_5_1.style
			local content = var_5_1.content

			content.visible = true
			content.texture_icon = gamepad_hud_icon
			content.texture_glow = gamepad_hud_icon .. "_glow"
			style.texture_icon.color[1] = 255

			local var_5_6 = Colors.color_definitions[var_5_2.key]

			var_5_6 = var_5_6 or Colors.color_definitions.black

			local color = style.texture_glow.color

			color[1] = 255
			color[2] = var_5_6[2]
			color[3] = var_5_6[3]
			color[4] = var_5_6[4]
		else
			var_5_1.content.visible = false
		end
	end
end

GamePadEquipmentUI.event_input_changed = function (self)
	-- function 6
	local str = "wield_switch_1"
	local weapon_slot = self._widgets_by_name.weapon_slot

	self:_set_switch_input(weapon_slot, str)
	self:_set_widget_dirty(weapon_slot)

	local str_2 = "wield_"

	for k, v in pairs(self._slot_widgets) do
		local str_3 = str_2 .. k + 2

		self:_set_slot_input(v, str_3)
		self:_set_widget_dirty(v)
	end

	self:set_dirty()
end

GamePadEquipmentUI._set_switch_input = function (self, arg_7_1, arg_7_2)
	-- function 7
	local _get_input_texture_data, var_7_1, var_7_2 = self:_get_input_texture_data(arg_7_2)

	if not (not var_7_1 and Utf8.length(var_7_1)) then
		local num = 0
	end

	local num_2 = 40
	local style = arg_7_1.style
	local content = arg_7_1.content
	local input_text = style.input_text
	local ui_renderer = self.ui_renderer

	content.input_action = arg_7_2

	if not _get_input_texture_data then
		var_7_1 = nil

		local size

		content.wield_switch_id, size = _get_input_texture_data.texture, _get_input_texture_data.size
		content.input_text = ""

		local texture_size = style.wield_switch.texture_size

		texture_size[1] = size[1]
		texture_size[2] = size[2]
	elseif not var_7_1 then
		content.input_text = UIRenderer.crop_text_width(ui_renderer, var_7_1, num_2, input_text)
		content.wield_switch_id = nil
	end
end

GamePadEquipmentUI._set_slot_input = function (self, arg_8_1, arg_8_2)
	-- function 8
	local _get_input_texture_data, var_8_1, var_8_2 = self:_get_input_texture_data(arg_8_2)

	if not (not var_8_1 and Utf8.length(var_8_1)) then
		local num = 0
	end

	local num_2 = 40
	local style = arg_8_1.style
	local content = arg_8_1.content
	local input_text = style.input_text
	local ui_renderer = self.ui_renderer

	if not var_8_1 then
		content.input_text = UIRenderer.crop_text_width(ui_renderer, var_8_1, num_2, input_text)
	end
end

GamePadEquipmentUI._get_input_texture_data = function (self, arg_9_1)
	-- function 9
	local input_manager = self.input_manager
	local get_service = input_manager:get_service("Player")
	local is_device_active = input_manager:is_device_active("gamepad")
	local PLATFORM = PLATFORM

	if not IS_WINDOWS and not is_device_active then
		PLATFORM = "xb1"
	elseif not (not IS_XB1 and is_device_active) then
		PLATFORM = "win32"
	end

	local get_keymapping = get_service:get_keymapping(arg_9_1, PLATFORM)

	if not get_keymapping then
		Application.warning(string.format("[GamePadEquipmentUI] There is no keymap for %q on %q", arg_9_1, PLATFORM))

		return nil, ""
	end

	local var_9_5 = get_keymapping[1]
	local var_9_6 = get_keymapping[2]
	local var_9_7 = get_keymapping[3]
	local var_9_8

	if var_9_7 == "held" then
		var_9_8 = "matchmaking_prefix_hold"
	end

	local flag = var_9_6 == UNASSIGNED_KEY
	local str = ""

	if var_9_5 == "keyboard" then
		local flag_2

		flag_2 = not flag and "" and Keyboard.button_locale_name(var_9_6) or Keyboard.button_name(var_9_6)

		if not IS_XB1 then
			flag_2 = string.upper(flag_2)
		end

		return nil, flag_2, var_9_8
	elseif var_9_5 == "mouse" then
		local flag_3

		flag_3 = not flag and "" and Mouse.button_name(var_9_6)

		return nil, flag_3, var_9_8
	elseif var_9_5 == "gamepad" then
		local flag_4

		flag_4 = not flag and "" and Pad1.button_name(var_9_6)

		if not UISettings.use_ps4_input_icons and not IS_WINDOWS then
			PLATFORM = "win32_ps4"
		end

		return ButtonTextureByName(flag_4, PLATFORM), flag_4, var_9_8
	end

	return nil, ""
end

GamePadEquipmentUI._update_widgets = function (self)
	-- function 10
	local _slot_widgets = self._slot_widgets

	for i, v in ipairs(_slot_widgets) do
		self:_set_widget_dirty(v)
	end

	self:set_dirty()
end

GamePadEquipmentUI._get_wield_scroll_input = function (self)
	-- function 11
	local player = self.player
	local player_unit = player.player_unit

	if not player_unit then
		return
	end

	local network_id = player:network_id()

	return ScriptUnit.extension(player_unit, "input_system"):get_last_scroll_value()
end

GamePadEquipmentUI._set_wielded_item = function (self, arg_12_1, arg_12_2)
	-- function 12
	local _get_wield_scroll_input = self:_get_wield_scroll_input()
	local _added_items = self._added_items

	for i, v in ipairs(_added_items) do
		local flag = v.item_name == self._wielded_item_name
		local flag_2 = v.item_name == arg_12_1
		local widget = v.widget

		widget.content.selected = flag_2

		local slot_name = v.slot_name

		if not flag_2 then
			local flag_3 = slot_name == "slot_ranged"

			self:_set_ammo_text_focus(flag_3)
			self:_add_animation(slot_name .. "_wield_anim", widget, widget, "_animate_slot_wield")
		elseif not flag then
			self:_add_animation(slot_name .. "_wield_anim", widget, widget, "_animate_slot_unwield")
		end

		v.is_wielded = flag_2
	end

	self._wielded_item_name = arg_12_1
end

local tbl_3 = {
	slot_grenade = true,
	slot_healthkit = true,
	slot_potion = true,
	slot_melee = false,
	slot_ranged = false
}
local tbl_4 = {}
local tbl_5 = {}
local tbl_6 = {}

GamePadEquipmentUI._update_equipment_lookup = function (self, arg_13_1, arg_13_2)
	-- function 13
	local _equipment_lookup = self._equipment_lookup

	_equipment_lookup = _equipment_lookup or {}
	self._equipment_lookup = _equipment_lookup

	local _equipment_lookup_2 = self._equipment_lookup
	local additional_items_lookup = self._equipment_lookup.additional_items_lookup

	additional_items_lookup = additional_items_lookup or {}
	_equipment_lookup_2.additional_items_lookup = additional_items_lookup

	local _equipment_lookup_3 = self._equipment_lookup

	_equipment_lookup_3.wielded_slot = arg_13_1.wielded_slot

	local additional_items_lookup_2 = _equipment_lookup_3.additional_items_lookup
	local get_additional_items_table = arg_13_2:get_additional_items_table()
	local var_13_6
	local slots = arg_13_1.slots

	for k, v in pairs(tbl_3) do
		local flag = not slots[k] and arg_13_2:get_item_template(slots[k])

		_equipment_lookup_3[k] = not flag and flag.name

		local flag_2 = not get_additional_items_table and get_additional_items_table[k]

		if not flag_2 then
			local var_13_10 = flag_2.items[1]

			additional_items_lookup_2[k] = not var_13_10 and var_13_10.key
		else
			additional_items_lookup_2[k] = nil
		end
	end

	local slot_ranged = slots.slot_ranged

	if not slot_ranged and not slot_ranged.item_data then
		local get_item_template = BackendUtils.get_item_template(slot_ranged.item_data)
		local _get_ammunition_count, var_13_14, var_13_15 = self:_get_ammunition_count(slot_ranged.left_unit_1p, slot_ranged.right_unit_1p, get_item_template)

		_equipment_lookup_3.ammo_count = _get_ammunition_count
		_equipment_lookup_3.remaining_ammo = var_13_14
	end

	local slot_grenade = slots.slot_grenade

	if not slot_grenade and not slot_grenade.item_data then
		_equipment_lookup_3.grenade_count = arg_13_2:get_total_item_count("slot_grenade")
	end
end

GamePadEquipmentUI._check_equipment_changed = function (self, arg_14_1, arg_14_2)
	-- function 14
	if not self._equipment_lookup then
		self:_update_equipment_lookup(arg_14_1, arg_14_2)

		return true
	end

	if self._equipment_lookup.wielded_slot ~= arg_14_1.wielded_slot then
		self:_update_equipment_lookup(arg_14_1, arg_14_2)

		return true
	end

	local var_14_0
	local var_14_1
	local var_14_2
	local slots = arg_14_1.slots
	local get_additional_items_table = arg_14_2:get_additional_items_table()
	local _equipment_lookup = self._equipment_lookup
	local additional_items_lookup = _equipment_lookup.additional_items_lookup

	for k, v in pairs(tbl_3) do
		local var_14_7 = slots[k]
		local flag = not var_14_7 and arg_14_2:get_item_template(var_14_7)

		if (not flag and flag.name) ~= _equipment_lookup[k] then
			self:_update_equipment_lookup(arg_14_1, arg_14_2)

			return true
		end

		local var_14_9 = get_additional_items_table[k]

		if not var_14_9 then
			local var_14_10 = var_14_9.items[1]
			local flag_2 = not var_14_10 and var_14_10.key

			if additional_items_lookup[k] ~= flag_2 then
				self:_update_equipment_lookup(arg_14_1, arg_14_2)

				return true
			end
		end
	end

	local slot_ranged = slots.slot_ranged

	if not slot_ranged and not slot_ranged.item_data then
		local get_item_template = BackendUtils.get_item_template(slot_ranged.item_data)
		local _get_ammunition_count, var_14_15, var_14_16 = self:_get_ammunition_count(slot_ranged.left_unit_1p, slot_ranged.right_unit_1p, get_item_template)

		if _equipment_lookup.ammo_count ~= _get_ammunition_count then
			self:_update_equipment_lookup(arg_14_1, arg_14_2)

			return true
		end

		if _equipment_lookup.remaining_ammo ~= var_14_15 then
			self:_update_equipment_lookup(arg_14_1, arg_14_2)

			return true
		end
	end

	local slot_grenade = slots.slot_grenade

	if not slot_grenade and not slot_grenade.item_data and not arg_14_2:has_additional_item_slots("slot_grenade") then
		local get_total_item_count = arg_14_2:get_total_item_count("slot_grenade")

		if _equipment_lookup.grenade_count ~= get_total_item_count then
			self:_update_equipment_lookup(arg_14_1, arg_14_2)

			return true
		end
	end

	return false
end

GamePadEquipmentUI._sync_player_equipment = function (self)
	-- function 15
	local is_device_active = Managers.input:is_device_active("gamepad")
	local use_gamepad_hud_layout = UISettings.use_gamepad_hud_layout

	if not (use_gamepad_hud_layout == "never" or use_gamepad_hud_layout ~= "auto" or is_device_active) then
		return
	end

	local player = self.player
	local player_unit = player.player_unit

	if not player_unit then
		return
	end

	local network_id = player:network_id()
	local extension = ScriptUnit.extension(player_unit, "inventory_system")
	local equipment = extension:equipment()

	if not equipment then
		return
	end

	if not self:_check_equipment_changed(equipment, extension) then
		return
	end

	table.clear(tbl_6)

	local flag = false
	local var_15_8
	local slots = equipment.slots
	local wielded = equipment.wielded
	local slots_2 = InventorySettings.slots
	local count = #slots_2
	local _added_items = self._added_items

	for i = 1, count do
		local name = slots_2[i].name
		local var_15_15 = slots[name]
		local flag_2

		flag_2 = not var_15_15 and true and false

		local flag_3 = not var_15_15 and var_15_15.item_data
		local flag_4 = not flag_3 and flag_3.name
		local flag_5 = not flag_4 and wielded == flag_3 or false

		if not flag_5 then
			local slot_type = flag_3.slot_type
			local weapon_slot = self._widgets_by_name.weapon_slot
			local content = weapon_slot.content
			local style = weapon_slot.style

			content.wielded_slot = slot_type

			if self._wielded_slot_name ~= name then
				if not (slot_type == "melee" or slot_type ~= "ranged") then
					self._weapon_was_wielded = true

					self:_add_animation("weapon_slot", weapon_slot, weapon_slot, "_animate_weapon_wield", 1)
				elseif not self._weapon_was_wielded then
					self._weapon_was_wielded = false

					self:_add_animation("weapon_slot", weapon_slot, weapon_slot, "_animate_weapon_unwield", 4)
				end
			end

			self._wielded_slot_name = name
		end

		if not tbl_3[name] then
			local num = 0
			local flag_6 = false

			for j = 1, #_added_items do
				local var_15_26 = _added_items[j]
				local flag_7 = var_15_26.item_name == flag_4
				local flag_8 = var_15_26.slot_name == name

				if not flag_8 then
					num = j
				end

				if not flag_7 then
					if not tbl_6[j] then
						flag_6 = true
						tbl_6[j] = true

						break
					end
				elseif not flag_4 and not flag_8 then
					flag_6 = true
					tbl_6[j] = true

					self:_add_item(var_15_15, var_15_26)

					num = j
					flag = true

					break
				end
			end

			if not (flag_6 or var_15_15 == nil) then
				self:_add_item(var_15_15)

				num = #_added_items
				tbl_6[#_added_items] = true
				flag = true
			end

			if not flag_5 then
				var_15_8 = flag_4
			end

			if not ((name ~= "slot_grenade" or not flag_3) and not (num > 0)) then
				local has_additional_item_slots = extension:has_additional_item_slots(name)
				local get_total_item_count = extension:get_total_item_count(name)
				local var_15_31 = _added_items[num]
				local flag_9 = not var_15_31 and var_15_31.widget

				if not flag_9 then
					local content_2 = flag_9.content
					local get_total_item_count_2 = extension:get_total_item_count(name)

					if content_2.item_count ~= get_total_item_count_2 then
						content_2.item_count = get_total_item_count_2
						content_2.use_count_text = "x" .. get_total_item_count_2
						content_2.has_additional_slots = has_additional_item_slots

						self:_set_widget_dirty(flag_9)
					end

					local can_swap_from_storage = extension:can_swap_from_storage(name, SwapFromStorageType.Unique)

					if content_2.can_swap ~= can_swap_from_storage then
						content_2.can_swap = can_swap_from_storage

						self:_set_widget_dirty(flag_9)
					end
				end
			elseif not ((name ~= "slot_potion" or not flag_3) and not (num > 0)) then
				local var_15_36 = _added_items[num]
				local flag_10 = not var_15_36 and var_15_36.widget

				if not flag_10 then
					local content_3 = flag_10.content
					local style_2 = flag_10.style
					local get_additional_items = extension:get_additional_items(name)

					if not get_additional_items then
						local var_15_41 = get_additional_items[1]

						if not var_15_41 then
							local gamepad_hud_icon = var_15_41.gamepad_hud_icon

							content_3.secondary_texture_icon = gamepad_hud_icon
							content_3.secondary_texture_icon_glow = gamepad_hud_icon .. "_glow"

							local inventory_consumable_slot_colors = UISettings.inventory_consumable_slot_colors
							local tbl = {
								255,
								0,
								0,
								0
							}
							local tbl_2 = {
								255,
								255,
								255,
								255
							}
							local var_15_46 = inventory_consumable_slot_colors[var_15_41.key]

							if not var_15_46 then
								style_2.secondary_texture_icon.color = var_15_46
								style_2.secondary_texture_icon_glow.color = {
									255,
									0,
									0,
									0
								}
							else
								style_2.secondary_texture_icon.color = tbl
								style_2.secondary_texture_icon_glow.color = tbl_2
							end

							self:_set_widget_dirty(flag_10)
						else
							content_3.secondary_texture_icon = nil
							content_3.secondary_texture_icon_glow = nil

							self:_set_widget_dirty(flag_10)
						end
					else
						content_3.secondary_texture_icon = nil
						content_3.secondary_texture_icon_glow = nil

						self:_set_widget_dirty(flag_10)
					end
				end
			end
		else
			if name ~= "slot_ranged" or not flag_3 then
				self:_update_ammo_count(flag_3, var_15_15, player_unit)
				self:_set_ammo_text_focus(flag_5)
			end

			if not flag_5 then
				var_15_8 = flag_4
			end
		end
	end

	table.clear(tbl_5)

	for k = 1, #_added_items do
		if not tbl_6[k] then
			tbl_5[#tbl_5 + 1] = k
		end
	end

	local num_2 = 0

	for l = 1, #tbl_5 do
		local num_3 = tbl_5[l] - num_2

		self:_remove_item(num_3)

		num_2 = num_2 + 1
		flag = true
	end

	if not flag then
		self:_update_widgets()
		table.sort(_added_items, fn)
	end

	if not var_15_8 and self._wielded_item_name ~= var_15_8 and not flag then
		var_15_8 = var_15_8 or self._wielded_item_name

		self:_set_wielded_item(var_15_8, flag)
	end
end

GamePadEquipmentUI._update_ammo_count = function (self, arg_16_1, arg_16_2, arg_16_3)
	-- function 16
	local get_item_template = BackendUtils.get_item_template(arg_16_1)
	local _ammo_widgets_by_name = self._ammo_widgets_by_name
	local flag = false

	if not get_item_template.ammo_data then
		local _get_ammunition_count, var_16_4, var_16_5 = self:_get_ammunition_count(arg_16_2.left_unit_1p, arg_16_2.right_unit_1p, get_item_template)
		local content = _ammo_widgets_by_name.ammo_text_clip.content
		local flag_2 = _get_ammunition_count + var_16_4 == 0
		local flag_3 = false

		if self._ammo_count ~= _get_ammunition_count then
			self._ammo_count = _get_ammunition_count

			local ammo_text_clip = _ammo_widgets_by_name.ammo_text_clip

			ammo_text_clip.content.text = tostring(_get_ammunition_count)

			self:_set_widget_dirty(ammo_text_clip)

			flag_3 = true
		end

		if self._remaining_ammo ~= var_16_4 then
			self._remaining_ammo = var_16_4

			local ammo_text_remaining = _ammo_widgets_by_name.ammo_text_remaining

			ammo_text_remaining.content.text = tostring(var_16_4)

			self:_set_widget_dirty(ammo_text_remaining)

			flag_3 = true
		end

		if not flag_3 then
			self._ammo_counter_fade_delay = num
			self._ammo_counter_fade_progress = 1

			self:_set_ammo_counter_alpha(255)

			local empty

			if not flag_2 then
				empty = tbl_2.empty

				if not empty then
					-- Nothing
				end
			end

			empty = tbl_2.normal

			::label_16_0::

			self:_set_ammo_counter_color(empty)
			self:set_dirty()
		end
	else
		local _get_overcharge_amount, var_16_13, var_16_14 = self:_get_overcharge_amount(arg_16_3)

		if self._overcharge_fraction ~= var_16_13 then
			self._overcharge_fraction = var_16_13

			self:_set_overheat_fraction(var_16_13)
		end

		flag = true
	end

	if self._draw_overheat ~= flag then
		self._draw_overheat = flag

		self:_show_overheat_meter(flag)
	end
end

GamePadEquipmentUI._animate_ammo_counter = function (self, arg_17_1)
	-- function 17
	local _ammo_counter_fade_delay = self._ammo_counter_fade_delay

	if not _ammo_counter_fade_delay then
		local max = math.max(_ammo_counter_fade_delay - arg_17_1, 0)

		if max == 0 then
			self._ammo_counter_fade_delay = nil
		else
			self._ammo_counter_fade_delay = max
		end

		return
	end

	local _ammo_counter_fade_progress = self._ammo_counter_fade_progress

	if not _ammo_counter_fade_progress then
		return
	end

	local max_2 = math.max(_ammo_counter_fade_progress - 0.01, 0)
	local num = 100 + 155 * max_2

	self:_set_ammo_counter_alpha(num)

	if max_2 == 0 then
		self._ammo_counter_fade_progress = nil
	else
		self._ammo_counter_fade_progress = max_2
	end

	return true
end

GamePadEquipmentUI._set_ammo_counter_alpha = function (self, arg_18_1)
	-- function 18
	local _ammo_widgets_by_name = self._ammo_widgets_by_name
	local ammo_text_clip = _ammo_widgets_by_name.ammo_text_clip

	ammo_text_clip.style.text.text_color[1] = arg_18_1

	self:_set_widget_dirty(ammo_text_clip)

	local ammo_text_remaining = _ammo_widgets_by_name.ammo_text_remaining

	ammo_text_remaining.style.text.text_color[1] = arg_18_1

	self:_set_widget_dirty(ammo_text_remaining)

	local ammo_text_center = _ammo_widgets_by_name.ammo_text_center

	ammo_text_center.style.text.text_color[1] = arg_18_1

	self:_set_widget_dirty(ammo_text_center)
	self:set_dirty()
end

GamePadEquipmentUI._set_ammo_counter_color = function (self, arg_19_1)
	-- function 19
	local ammo_text_clip = self._ammo_widgets_by_name.ammo_text_clip
	local text_color = ammo_text_clip.style.text.text_color

	text_color[2] = arg_19_1[2]
	text_color[3] = arg_19_1[3]
	text_color[4] = arg_19_1[4]

	self:_set_widget_dirty(ammo_text_clip)

	local ammo_text_remaining = self._ammo_widgets_by_name.ammo_text_remaining
	local text_color_2 = ammo_text_remaining.style.text.text_color

	text_color_2[2] = arg_19_1[2]
	text_color_2[3] = arg_19_1[3]
	text_color_2[4] = arg_19_1[4]

	self:_set_widget_dirty(ammo_text_remaining)

	local ammo_text_center = self._ammo_widgets_by_name.ammo_text_center
	local text_color_3 = ammo_text_center.style.text.text_color

	text_color_3[2] = arg_19_1[2]
	text_color_3[3] = arg_19_1[3]
	text_color_3[4] = arg_19_1[4]

	self:_set_widget_dirty(ammo_text_center)
	self:set_dirty()
end

GamePadEquipmentUI._set_ammo_text_focus = function (self, arg_20_1)
	-- function 20
	if not (not self._draw_overheat and self._overcharge_fraction == nil) then
		local num = 1
		local focus

		if not arg_20_1 then
			focus = tbl_2.focus

			if not focus then
				-- Nothing
			end
		end

		focus = tbl_2.unfocused

		::label_20_0::

		local _widgets_by_name = self._widgets_by_name
		local overcharge = _widgets_by_name.overcharge
		local overcharge_background = _widgets_by_name.overcharge_background
		local color = overcharge.style.texture_id.color
		local color_2 = overcharge_background.style.texture_id.color

		color[2] = focus[2] * num
		color[3] = focus[3] * num
		color[4] = focus[4] * num

		self:_set_widget_dirty(overcharge)
		self:_set_widget_dirty(overcharge_background)
		self:set_dirty()
	end

	self._ammo_dirty = true
end

GamePadEquipmentUI._get_ammunition_count = function (arg_21_0, arg_21_1, arg_21_2, arg_21_3)
	-- function 21
	local var_21_0

	if not arg_21_3.ammo_data then
		return
	end

	local ammo_hand = arg_21_3.ammo_data.ammo_hand

	if ammo_hand == "right" then
		var_21_0 = ScriptUnit.extension(arg_21_2, "ammo_system")
	elseif ammo_hand == "left" then
		var_21_0 = ScriptUnit.extension(arg_21_1, "ammo_system")
	else
		return
	end

	local ammo_count = var_21_0:ammo_count()
	local remaining_ammo = var_21_0:remaining_ammo()
	local using_single_clip = var_21_0:using_single_clip()

	return ammo_count, remaining_ammo, using_single_clip
end

GamePadEquipmentUI._get_overcharge_amount = function (arg_22_0, arg_22_1)
	-- function 22
	local extension = ScriptUnit.extension(arg_22_1, "overcharge_system")
	local overcharge_fraction = extension:overcharge_fraction()
	local threshold_fraction = extension:threshold_fraction()
	local get_anim_blend_overcharge = extension:get_anim_blend_overcharge()

	return true, overcharge_fraction, threshold_fraction, get_anim_blend_overcharge
end

GamePadEquipmentUI._add_animation = function (self, arg_23_1, arg_23_2, arg_23_3, arg_23_4, arg_23_5)
	-- function 23
	local _animations = self._animations
	local inventory_hud = UISettings.inventory_hud
	local flag = arg_23_5 or inventory_hud.equip_animation_duration
	local var_23_3 = _animations[arg_23_1]

	if not var_23_3 then
		var_23_3.total_time = flag
		var_23_3.time = 0
		var_23_3.func = arg_23_4
	else
		_animations[arg_23_1] = {
			time = 0,
			total_time = flag,
			style = arg_23_3,
			widget = arg_23_2,
			func = arg_23_4
		}
	end
end

GamePadEquipmentUI._update_animations = function (self, arg_24_1, arg_24_2)
	-- function 24
	local _time_fade_storage_slots = self._time_fade_storage_slots

	if not _time_fade_storage_slots then
		local clamp = math.clamp(_time_fade_storage_slots - arg_24_2, 0, 1)
		local _extra_storage_icon_widgets = self._extra_storage_icon_widgets

		for i = 1, #_extra_storage_icon_widgets do
			local style = _extra_storage_icon_widgets[i].style

			style.texture_icon.color[1] = 255 * clamp
			style.texture_glow.color[1] = 128 * clamp
		end

		local extra_storage_bg = self._widgets_by_name.extra_storage_bg

		extra_storage_bg.style.texture.color[1] = 189 * clamp

		self:_set_widget_dirty(extra_storage_bg)

		if clamp == 0 then
			self._time_fade_storage_slots = nil
		end
	end

	local _animations = self._animations
	local flag = false

	for k, v in pairs(_animations) do
		_animations[k] = self[v.func](self, v, arg_24_1)

		local widget = v.widget

		self:_set_widget_dirty(widget)

		flag = true
	end

	return flag
end

GamePadEquipmentUI._animate_weapon_wield = function (arg_25_0, arg_25_1, arg_25_2)
	-- function 25
	local widget = arg_25_1.widget
	local total_time = arg_25_1.total_time
	local num = arg_25_1.time + arg_25_2
	local min = math.min(num / total_time, 1)
	local easeInCubic = math.easeInCubic(min)
	local easeOutCubic = math.easeOutCubic(min)

	widget.style.melee_weapon_texture.color[2] = 255 - 192 * easeInCubic
	widget.style.melee_weapon_texture.color[3] = 255 - 192 * easeInCubic
	widget.style.melee_weapon_texture.color[4] = 255 - 192 * easeInCubic
	widget.style.ranged_weapon_texture.color[2] = 255 - 192 * easeInCubic
	widget.style.ranged_weapon_texture.color[3] = 255 - 192 * easeInCubic
	widget.style.ranged_weapon_texture.color[4] = 255 - 192 * easeInCubic
	widget.style.melee_weapon_texture_glow.color[1] = 255 - 255 * easeOutCubic
	widget.style.ranged_weapon_texture_glow.color[1] = 255 - 255 * easeOutCubic
	arg_25_1.time = num

	return not (min < 1) or not arg_25_1 or nil
end

GamePadEquipmentUI._animate_weapon_unwield = function (arg_26_0, arg_26_1, arg_26_2)
	-- function 26
	local widget = arg_26_1.widget
	local total_time = arg_26_1.total_time
	local num = arg_26_1.time + arg_26_2
	local min = math.min(num / total_time, 1)
	local easeInCubic = math.easeInCubic(1 - min)
	local easeOutCubic = math.easeOutCubic(min)

	widget.style.highlight_weapon_texture.color[1] = 255 * easeInCubic
	arg_26_1.time = num

	return not (min < 1) or not arg_26_1 or nil
end

GamePadEquipmentUI._animate_slot_wield = function (arg_27_0, arg_27_1, arg_27_2)
	-- function 27
	local widget = arg_27_1.widget
	local total_time = arg_27_1.total_time
	local num = arg_27_1.time + arg_27_2
	local min = math.min(num / total_time, 1)
	local easeOutCubic = math.easeOutCubic(min)
	local easeInCubic = math.easeInCubic(1 - min)

	widget.style.texture_icon.color[2] = 128 + 127 * easeOutCubic
	widget.style.texture_icon.color[3] = 128 + 127 * easeOutCubic
	widget.style.texture_icon.color[4] = 128 + 127 * easeOutCubic
	widget.style.texture_selected.color[1] = 255 * easeOutCubic
	widget.style.texture_selected_left_arrow_glow.color[1] = 255 * easeOutCubic
	widget.style.texture_selected_up_arrow_glow.color[1] = 255 * easeOutCubic
	widget.style.texture_selected_right_arrow_glow.color[1] = 255 * easeOutCubic
	widget.style.texture_selected_left_arrow.color[2] = 128 + 127 * easeOutCubic
	widget.style.texture_selected_left_arrow.color[3] = 128 + 127 * easeOutCubic
	widget.style.texture_selected_left_arrow.color[4] = 128 + 127 * easeOutCubic
	widget.style.texture_selected_up_arrow.color[2] = 128 + 127 * easeOutCubic
	widget.style.texture_selected_up_arrow.color[3] = 128 + 127 * easeOutCubic
	widget.style.texture_selected_up_arrow.color[4] = 128 + 127 * easeOutCubic
	widget.style.texture_selected_right_arrow.color[2] = 128 + 127 * easeOutCubic
	widget.style.texture_selected_right_arrow.color[3] = 128 + 127 * easeOutCubic
	widget.style.texture_selected_right_arrow.color[4] = 128 + 127 * easeOutCubic
	arg_27_1.time = num

	return not (min < 1) or not arg_27_1 or nil
end

GamePadEquipmentUI._animate_slot_unwield = function (arg_28_0, arg_28_1, arg_28_2)
	-- function 28
	local widget = arg_28_1.widget
	local total_time = arg_28_1.total_time
	local num = arg_28_1.time + arg_28_2
	local min = math.min(num / total_time, 1)
	local easeInCubic = math.easeInCubic(1 - min)
	local easeOutCubic = math.easeOutCubic(min)

	if not widget.content.is_filled then
		widget.style.texture_icon.color[2] = 128 + 127 * easeInCubic
		widget.style.texture_icon.color[3] = 128 + 127 * easeInCubic
		widget.style.texture_icon.color[4] = 128 + 127 * easeInCubic
	else
		widget.style.texture_icon.color[1] = 255 * easeInCubic
		widget.style.texture_icon.color[2] = 128 + 127 * easeInCubic
		widget.style.texture_icon.color[3] = 128 + 127 * easeInCubic
		widget.style.texture_icon.color[4] = 128 + 127 * easeInCubic
	end

	widget.style.texture_selected.color[1] = 255 * easeInCubic
	widget.style.texture_selected_left_arrow_glow.color[1] = 255 * easeInCubic
	widget.style.texture_selected_up_arrow_glow.color[1] = 255 * easeInCubic
	widget.style.texture_selected_right_arrow_glow.color[1] = 255 * easeInCubic
	widget.style.texture_selected_left_arrow.color[2] = 128 + 127 * easeInCubic
	widget.style.texture_selected_left_arrow.color[3] = 128 + 127 * easeInCubic
	widget.style.texture_selected_left_arrow.color[4] = 128 + 127 * easeInCubic
	widget.style.texture_selected_up_arrow.color[2] = 128 + 127 * easeInCubic
	widget.style.texture_selected_up_arrow.color[3] = 128 + 127 * easeInCubic
	widget.style.texture_selected_up_arrow.color[4] = 128 + 127 * easeInCubic
	widget.style.texture_selected_right_arrow.color[2] = 128 + 127 * easeInCubic
	widget.style.texture_selected_right_arrow.color[3] = 128 + 127 * easeInCubic
	widget.style.texture_selected_right_arrow.color[4] = 128 + 127 * easeInCubic
	arg_28_1.time = num

	return not (min < 1) or not arg_28_1 or nil
end

GamePadEquipmentUI._add_item = function (self, arg_29_1, arg_29_2)
	-- function 29
	local _num_added_items = self._num_added_items

	_num_added_items = _num_added_items or 0

	local flag = arg_29_2 ~= nil

	if not (flag or not (_num_added_items >= NUM_SLOTS)) then
		return
	end

	local id = arg_29_1.id
	local console_hud_index = InventorySettings.slots_by_name[id].console_hud_index
	local var_29_4

	if not flag then
		var_29_4 = arg_29_2.widget
	else
		for i, v in ipairs(self._slot_widgets) do
			if v.content.console_hud_index == console_hud_index then
				var_29_4 = v

				break
			end
		end

		UIRenderer.set_element_visible(self.ui_renderer, var_29_4.element, true)
	end

	local content = var_29_4.content
	local style = var_29_4.style
	local normal_color = content.normal_color

	content.is_filled = true

	local item_data = arg_29_1.item_data
	local name = item_data.name
	local gamepad_hud_icon = item_data.gamepad_hud_icon
	local var_29_11

	if id == "slot_melee" then
		gamepad_hud_icon = "hud_icon_melee"
	elseif id == "slot_ranged" then
		gamepad_hud_icon = "hud_icon_ranged"
	elseif not gamepad_hud_icon then
		var_29_11 = gamepad_hud_icon .. "_glow"
	end

	local inventory_consumable_slot_colors = UISettings.inventory_consumable_slot_colors
	local default = inventory_consumable_slot_colors.default
	local var_29_14 = inventory_consumable_slot_colors[name]

	var_29_14 = var_29_14 or default

	local color = style.texture_selected.color

	color[2] = var_29_14[2]
	color[3] = var_29_14[3]
	color[4] = var_29_14[4]

	local color_2 = style.texture_selected_left_arrow_glow.color

	color_2[2] = var_29_14[2]
	color_2[3] = var_29_14[3]
	color_2[4] = var_29_14[4]

	local color_3 = style.texture_selected_up_arrow_glow.color

	color_3[2] = var_29_14[2]
	color_3[3] = var_29_14[3]
	color_3[4] = var_29_14[4]

	local color_4 = style.texture_selected_right_arrow_glow.color

	color_4[2] = var_29_14[2]
	color_4[3] = var_29_14[3]
	color_4[4] = var_29_14[4]
	content.texture_icon = gamepad_hud_icon or "icons_placeholder"
	content.texture_selected = var_29_11 or "icons_placeholder"
	style.texture_icon.color[1] = 255
	style.texture_selected_left_arrow.color[1] = 255
	style.texture_selected_up_arrow.color[1] = 255
	style.texture_selected_right_arrow.color[1] = 255
	style.texture_empty_slot.color[1] = 0
	arg_29_2 = arg_29_2 or {}
	arg_29_2.console_hud_index = console_hud_index
	arg_29_2.slot_name = id
	arg_29_2.item_name = name
	arg_29_2.widget = var_29_4
	arg_29_2.wielded = false
	arg_29_2.icon = gamepad_hud_icon

	if not flag then
		local _added_items = self._added_items

		table.insert(_added_items, #_added_items + 1, arg_29_2)

		self._num_added_items = _num_added_items + 1
	end
end

GamePadEquipmentUI._remove_item = function (self, arg_30_1)
	-- function 30
	local _num_added_items = self._num_added_items

	_num_added_items = _num_added_items or 0

	if _num_added_items <= 0 then
		return
	end

	local _added_items = self._added_items
	local remove = table.remove(_added_items, arg_30_1)
	local slot_name = remove.slot_name
	local widget = remove.widget
	local content = widget.content
	local style = widget.style

	content.is_filled = false
	style.texture_icon.color[1] = 0
	style.texture_arrow_left.color[1] = 0
	style.texture_arrow_up.color[1] = 0
	style.texture_arrow_right.color[1] = 0
	style.texture_empty_slot.color[1] = 128

	local selected = content.selected

	content.selected = false

	local default = UISettings.inventory_consumable_slot_colors.default
	local color = style.texture_background.color

	color[1] = 0
	color[2] = default[2]
	color[3] = default[3]
	color[4] = default[4]
	self._num_added_items = _num_added_items - 1

	if not selected then
		self:_add_animation(slot_name .. "_wield_anim", widget, widget, "_animate_slot_unwield")
	else
		widget.style.texture_selected.color[1] = 0
	end
end

GamePadEquipmentUI.set_position = function (self, arg_31_1, arg_31_2)
	-- function 31
	local local_position = self.ui_scenegraph.pivot.local_position

	local_position[1] = arg_31_1
	local_position[2] = arg_31_2

	for i, v in ipairs(self._widgets) do
		self:_set_widget_dirty(v)
	end

	for i_2, v_2 in ipairs(self._static_widgets) do
		self:_set_widget_dirty(v_2)
	end

	self:set_dirty()
end

GamePadEquipmentUI.destroy = function (self)
	-- function 32
	local event = Managers.state.event

	event:unregister("input_changed", self)
	event:unregister("swap_equipment_from_storage", self)
	event:unregister("on_game_options_changed", self)

	self._ui_animator = nil

	self:set_visible(false)
	print("[GamePadEquipmentUI] - Destroy")
end

GamePadEquipmentUI.set_visible = function (self, arg_33_1)
	-- function 33
	self._is_visible = arg_33_1

	self:_set_elements_visible(arg_33_1)
end

GamePadEquipmentUI._set_elements_visible = function (self, arg_34_1)
	-- function 34
	local ui_renderer = self.ui_renderer

	for i, v in ipairs(self._widgets) do
		UIRenderer.set_element_visible(ui_renderer, v.element, arg_34_1)
	end

	for i_2, v_2 in ipairs(self._static_widgets) do
		UIRenderer.set_element_visible(ui_renderer, v_2.element, arg_34_1)
	end

	for i_3, v_3 in ipairs(self._ammo_widgets) do
		UIRenderer.set_element_visible(ui_renderer, v_3.element, arg_34_1)
	end

	for i_4, v_4 in ipairs(self._frame_widgets) do
		UIRenderer.set_element_visible(ui_renderer, v_4.element, arg_34_1)
	end

	self._retained_elements_visible = arg_34_1

	self:set_dirty()
end

GamePadEquipmentUI.update = function (self, arg_35_1, arg_35_2)
	-- function 35
	local flag = false

	self:_update_game_options()

	local get_crosshair_position, var_35_2 = self._parent:get_crosshair_position()

	if not self:_apply_crosshair_position(get_crosshair_position, var_35_2) then
		flag = true
	end

	if not self:_update_animations(arg_35_1, arg_35_2) then
		flag = true
	end

	if not self:_animate_ammo_counter(arg_35_1) then
		flag = true
	end

	if not flag then
		self:set_dirty()
	end

	self:_handle_resolution_modified()
	self:_sync_player_equipment()
	self:_show_hold_to_reload(arg_35_2)
	self:_handle_gamepad_activity()
	self:draw(arg_35_1)
	self._ui_animator:update(arg_35_1)
end

GamePadEquipmentUI._handle_career_change = function (self)
	-- function 36
	local _career_name = self._career_name
	local local_player = Managers.player:local_player()
	local flag = not local_player and local_player.player_unit

	if not ALIVE[flag] then
		return
	end

	self._career_name = ScriptUnit.extension(flag, "career_system"):career_name()

	if self._career_name ~= _career_name then
		for k, v in pairs(self._career_widgets) do
			v.content.visible = true

			self:_set_widget_dirty(v)
		end

		return true
	end
end

GamePadEquipmentUI._handle_resolution_modified = function (self)
	-- function 37
	if not RESOLUTION_LOOKUP.modified then
		self:_on_resolution_modified()
	end
end

GamePadEquipmentUI._on_resolution_modified = function (self)
	-- function 38
	for i, v in ipairs(self._widgets) do
		self:_set_widget_dirty(v)
	end

	for i_2, v_2 in ipairs(self._static_widgets) do
		self:_set_widget_dirty(v_2)
	end

	for k, v_3 in pairs(self._frame_widgets) do
		self:_set_widget_dirty(v_3)
	end

	self:set_dirty()
end

GamePadEquipmentUI._handle_gamepad_activity = function (self)
	-- function 39
	local is_device_active = Managers.input:is_device_active("gamepad")
	local get_most_recent_device = Managers.input:get_most_recent_device()
	local flag = self.gamepad_active_last_frame == nil or not is_device_active or get_most_recent_device ~= self._most_recent_device

	if is_device_active or not IS_PS4 then
		if not self.gamepad_active_last_frame and not flag then
			self.gamepad_active_last_frame = true

			self:_update_gamepad_input_button()
			self:event_input_changed()
		end
	elseif self.gamepad_active_last_frame or not flag then
		self.gamepad_active_last_frame = false

		self:_update_gamepad_input_button()
		self:event_input_changed()
	end

	self._most_recent_device = get_most_recent_device
end

GamePadEquipmentUI._set_game_options_dirty = function (self)
	-- function 40
	self._game_options_dirty = true
end

GamePadEquipmentUI._update_game_options = function (self)
	-- function 41
	if not self._game_options_dirty then
		return
	end

	self:_update_gamepad_input_button()
	self:event_input_changed()

	self._game_options_dirty = false
end

GamePadEquipmentUI._update_gamepad_input_button = function (self)
	-- function 42
	local get_service = Managers.input:get_service("Player")
	local str = "weapon_reload_input"
	local flag = true
	local get_gamepad_input_texture_data, var_42_4, var_42_5, var_42_6 = UISettings.get_gamepad_input_texture_data(get_service, str, flag)
	local engineer_base = self._widgets_by_name.engineer_base
	local style = engineer_base.style
	local content = engineer_base.content
	local is_device_active = Managers.input:is_device_active("gamepad")

	if not get_gamepad_input_texture_data and not is_device_active then
		content.reload_button_id = get_gamepad_input_texture_data.texture
		content.input_text = ""

		local texture_size = style.reload_button.texture_size
		local size = get_gamepad_input_texture_data.size

		texture_size[1] = size[1]
		texture_size[2] = size[2]
	else
		local num = 40
		local str_2 = "weapon_reload"
		local get_keymapping = get_service:get_keymapping(str_2, "win32")

		if not get_keymapping then
			content.input_text = UIRenderer.crop_text_width(self.ui_renderer, Localize("unassigned_keymap"), num, input_style)
		else
			local var_42_16 = get_keymapping[1]
			local var_42_17 = get_keymapping[2]
			local input_text = style.input_text
			local str_3 = ""

			if var_42_17 ~= UNASSIGNED_KEY then
				local Mouse

				if var_42_16 == "mouse" then
					Mouse = Mouse

					if not Mouse then
						-- Nothing
					end
				end

				Mouse = Keyboard

				::label_42_0::

				str_3 = Mouse.button_locale_name(var_42_17) or Mouse.button_name(var_42_17) or Localize("lb_unknown")
			end

			content.input_text = UIRenderer.crop_text_width(self.ui_renderer, str_3, num, input_text)
		end
	end
end

GamePadEquipmentUI._handle_gamepad = function (self)
	-- function 43
	local is_device_active = Managers.input:is_device_active("gamepad")

	is_device_active = is_device_active or not IS_WINDOWS

	if not (not is_device_active and UISettings.use_gamepad_hud_layout ~= "never" and UISettings.use_gamepad_hud_layout == "always") then
		if not self._retained_elements_visible then
			self:_set_elements_visible(false)
		end

		return false
	else
		if not self._retained_elements_visible then
			self:_set_elements_visible(true)
			self:event_input_changed()
		end

		return true
	end
end

GamePadEquipmentUI.draw = function (self, arg_44_1)
	-- function 44
	if not self._is_visible then
		return
	end

	local _handle_gamepad = self:_handle_gamepad()

	if not _handle_gamepad then
		return
	end

	local _handle_career_change = self:_handle_career_change()

	_handle_career_change = _handle_career_change or _handle_gamepad

	if not _handle_career_change then
		return
	end

	local ui_renderer = self.ui_renderer
	local ui_scenegraph = self.ui_scenegraph
	local get_service = self.input_manager:get_service("ingame_menu")
	local render_settings = self.render_settings
	local alpha_multiplier = render_settings.alpha_multiplier

	UIRenderer.begin_pass(ui_renderer, ui_scenegraph, get_service, arg_44_1, nil, render_settings)

	render_settings.snap_pixel_positions = true

	local panel_alpha_multiplier = self.panel_alpha_multiplier

	panel_alpha_multiplier = panel_alpha_multiplier or alpha_multiplier
	render_settings.alpha_multiplier = panel_alpha_multiplier

	for i, v in ipairs(self._slot_widgets) do
		UIRenderer.draw_widget(ui_renderer, v)
	end

	for i_2, v_2 in ipairs(self._extra_storage_icon_widgets) do
		UIRenderer.draw_widget(ui_renderer, v_2)
	end

	render_settings.snap_pixel_positions = true

	for i_3, v_3 in ipairs(self._static_widgets) do
		UIRenderer.draw_widget(ui_renderer, v_3)
	end

	render_settings.snap_pixel_positions = true

	for i_4, v_4 in ipairs(self._ammo_widgets) do
		UIRenderer.draw_widget(ui_renderer, v_4)
	end

	local frame_alpha_multiplier = self.frame_alpha_multiplier

	frame_alpha_multiplier = frame_alpha_multiplier or alpha_multiplier
	render_settings.alpha_multiplier = frame_alpha_multiplier
	render_settings.snap_pixel_positions = true

	for i_5, v_5 in ipairs(self._frame_widgets) do
		UIRenderer.draw_widget(ui_renderer, v_5)
	end

	UIRenderer.end_pass(ui_renderer)

	self._dirty = false
	self._ammo_dirty = false
end

GamePadEquipmentUI._set_color = function (arg_45_0, arg_45_1, arg_45_2, arg_45_3)
	-- function 45
	if not arg_45_3 then
		arg_45_1[1] = arg_45_2[1]
	end

	arg_45_1[2] = arg_45_2[2]
	arg_45_1[3] = arg_45_2[3]
	arg_45_1[4] = arg_45_2[4]
end

GamePadEquipmentUI.set_dirty = function (self)
	-- function 46
	self._dirty = true

	if not self.cleanui then
		self.cleanui.dirty = true
	end
end

GamePadEquipmentUI._set_widget_dirty = function (self, arg_47_1)
	-- function 47
	arg_47_1.element.dirty = true

	if not self.cleanui then
		self.cleanui.dirty = true
	end
end

GamePadEquipmentUI._set_overheat_fraction = function (self, arg_48_1)
	-- function 48
	local overcharge = self._widgets_by_name.overcharge

	overcharge.content.texture_id.uvs[2][1] = arg_48_1

	local scenegraph_id = overcharge.scenegraph_id
	local var_48_2 = self.ui_scenegraph[scenegraph_id]
	local size = scenegraph_definition[scenegraph_id].size

	var_48_2.size[1] = size[1] * arg_48_1

	self:_set_widget_dirty(overcharge)
	self:set_dirty()
end

GamePadEquipmentUI._show_overheat_meter = function (self, arg_49_1)
	-- function 49
	local _widgets_by_name = self._widgets_by_name
	local _ammo_widgets_by_name = self._ammo_widgets_by_name

	self:_set_widget_visibility(_widgets_by_name.overcharge, false)
	self:_set_widget_visibility(_widgets_by_name.overcharge_background, false)
	self:_set_widget_visibility(_ammo_widgets_by_name.ammo_text_clip, not arg_49_1)
	self:_set_widget_visibility(_ammo_widgets_by_name.ammo_text_remaining, not arg_49_1)
	self:_set_widget_visibility(_ammo_widgets_by_name.ammo_text_center, not arg_49_1)
	self:set_dirty()
end

GamePadEquipmentUI._set_widget_visibility = function (self, arg_50_1, arg_50_2)
	-- function 50
	arg_50_1.content.visible = arg_50_2

	self:_set_widget_dirty(arg_50_1)
end

GamePadEquipmentUI.set_alpha = function (self, arg_51_1)
	-- function 51
	self.render_settings.alpha_multiplier = arg_51_1

	for k, v in pairs(self._widgets) do
		self:_set_widget_dirty(v)
	end

	for k_2, v_2 in pairs(self._slot_widgets) do
		self:_set_widget_dirty(v_2)
	end

	for k_3, v_3 in pairs(self._static_widgets) do
		self:_set_widget_dirty(v_3)
	end

	for k_4, v_4 in pairs(self._ammo_widgets) do
		self:_set_widget_dirty(v_4)
	end

	for k_5, v_5 in pairs(self._frame_widgets) do
		self:_set_widget_dirty(v_5)
	end

	self:set_dirty()
end

GamePadEquipmentUI.set_ammo_alpha = function (self, arg_52_1)
	-- function 52
	self.ammo_alpha_multiplier = arg_52_1

	for k, v in pairs(self._ammo_widgets) do
		self:_set_widget_dirty(v)
	end

	self:set_dirty()
end

GamePadEquipmentUI.set_frame_alpha = function (self, arg_53_1)
	-- function 53
	self.frame_alpha_multiplier = arg_53_1

	for k, v in pairs(self._frame_widgets) do
		self:_set_widget_dirty(v)
	end

	self:set_dirty()
end

GamePadEquipmentUI.set_panel_alpha = function (self, arg_54_1)
	-- function 54
	self.panel_alpha_multiplier = arg_54_1

	for k, v in pairs(self._widgets) do
		self:_set_widget_dirty(v)
	end

	for k_2, v_2 in pairs(self._slot_widgets) do
		self:_set_widget_dirty(v_2)
	end

	for k_3, v_3 in pairs(self._static_widgets) do
		self:_set_widget_dirty(v_3)
	end

	for k_4, v_4 in pairs(self._ammo_widgets) do
		self:_set_widget_dirty(v_4)
	end

	self:set_dirty()
end

GamePadEquipmentUI._apply_crosshair_position = function (self, arg_55_1, arg_55_2)
	-- function 55
	local str = "screen_bottom_pivot"
	local local_position = self.ui_scenegraph[str].local_position
	local flag = false

	if not (local_position[1] ~= arg_55_1 or local_position[2] == arg_55_2) then
		flag = true
	end

	local_position[1] = arg_55_1
	local_position[2] = arg_55_2

	if not flag then
		local _widgets_by_name = self._widgets_by_name
		local _ammo_widgets_by_name = self._ammo_widgets_by_name

		self:_set_widget_dirty(_ammo_widgets_by_name.ammo_text_clip)
		self:_set_widget_dirty(_ammo_widgets_by_name.ammo_text_remaining)
		self:_set_widget_dirty(_ammo_widgets_by_name.ammo_text_center)
		self:_set_widget_dirty(_widgets_by_name.overcharge)
		self:_set_widget_dirty(_widgets_by_name.overcharge_background)
	end

	return flag
end

GamePadEquipmentUI._show_hold_to_reload = function (self, arg_56_1)
	-- function 56
	local is_device_active = Managers.input:is_device_active("gamepad")

	if not (not is_device_active and UISettings.use_gamepad_hud_layout ~= "never" and UISettings.use_gamepad_hud_layout == "always") then
		return
	end

	local _spectated_player

	if not self._is_spectator then
		_spectated_player = self._spectated_player

		if not _spectated_player then
			-- Nothing
		end
	end

	_spectated_player = self.player

	::label_56_0::

	local player_unit = _spectated_player.player_unit

	if not player_unit then
		return
	end

	local equipment = ScriptUnit.extension(player_unit, "inventory_system"):equipment()
	local wielded_slot = equipment.wielded_slot
	local flag = false
	local var_56_6
	local var_56_7
	local var_56_8

	for k, v in pairs(equipment.slots) do
		local item_data = v.item_data
		local get_item_template = BackendUtils.get_item_template(item_data)

		if v.id == wielded_slot then
			local ammo_data = get_item_template.ammo_data

			ammo_data = not ammo_data and get_item_template.ammo_data.unique_ammo_type

			if not ammo_data then
				var_56_6 = v
				var_56_7 = item_data
				var_56_8 = get_item_template
				flag = true
			end
		end
	end

	if not (not var_56_7 and not var_56_6 and var_56_8) then
		return
	end

	local _get_ammunition_count, var_56_13, var_56_14 = self:_get_ammunition_count(var_56_6.left_unit_1p, var_56_6.right_unit_1p, var_56_8)
	local flag_2

	flag_2 = not is_device_active and "weapon_reload_hold_input" and "weapon_reload_hold"

	local reload_tip_text = self._ammo_widgets_by_name.reload_tip_text
	local _get_input_texture_data, var_56_18, var_56_19 = self:_get_input_texture_data(flag_2)
	local var_56_20 = reload_tip_text.style.text.text_color[1]
	local format = string.format("{#color(193,91,36, %d)}", var_56_20)
	local format_2

	if not is_device_active then
		format_2 = string.format("$KEY;Player__%s:", flag_2)

		if not format_2 then
			-- Nothing
		end
	end

	format_2 = var_56_18

	::label_56_1::

	reload_tip_text.content.text = string.format(Localize("reload_tip"), format, format_2, "{#reset()}")

	local flag_3 = _get_ammunition_count + var_56_13 == var_56_8.ammo_data.max_ammo

	if not (not flag and flag_3) then
		if self._reload_attempts >= 3 then
			self._reload_tip_text_shown = true

			if not self._reload_tip_anim and not self._ui_animator:is_animation_completed(self._reload_tip_anim) then
				self._reload_tip_anim = self._ui_animator:start_animation("show_reload_tip", reload_tip_text, scenegraph_definition)
			end
		end

		self:_update_reload_ui_state(arg_56_1, var_56_8)
	end

	self:_set_widget_dirty(reload_tip_text)
end

GamePadEquipmentUI._update_reload_ui_state = function (self, arg_57_1, arg_57_2)
	-- function 57
	if not self._ammo_widgets_by_name.reload_tip_text then
		return
	end

	local get_service = Managers.input:get_service("Player")
	local num = 5
	local is_device_active = Managers.input:is_device_active("gamepad")

	is_device_active = is_device_active or not IS_WINDOWS

	local flag

	flag = not is_device_active and "weapon_reload_hold_input" and "weapon_reload_hold"

	if not get_service:get(flag) then
		if not self._ui_animator:is_animation_completed(self._reload_tip_anim) then
			return
		end

		if not self._listening_timer_start then
			self._listening_timer_start = arg_57_1
		end

		if not self._reload_start_time then
			self._reload_start_time = arg_57_1
		end
	else
		local anim_time_scale = arg_57_2.actions.weapon_reload.default.anim_time_scale
		local _reload_start_time = self._reload_start_time

		_reload_start_time = not _reload_start_time and anim_time_scale > arg_57_1 - self._reload_start_time

		if not _reload_start_time then
			self._reload_attempts = self._reload_attempts + 1
		end

		if not self._reload_start_time then
			self._reload_start_time = nil
		end
	end

	local num_2 = 0

	if not self._listening_timer_start then
		num_2 = self._listening_timer_start + num
	end

	if (num_2 == 0 or not (num_2 < arg_57_1)) and not self._reload_tip_text_shown then
		self._listening_timer_start = nil
		self._reload_attempts = 0
		self._reload_tip_text_shown = false
	end
end
