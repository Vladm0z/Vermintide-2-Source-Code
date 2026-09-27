-- chunkname: @scripts/ui/hud_ui/equipment_ui.lua

local var_0_0 = local_require("scripts/ui/hud_ui/equipment_ui_definitions")
local scenegraph_definition = var_0_0.scenegraph_definition
local animations_definitions = var_0_0.animations_definitions

EquipmentUI = class(EquipmentUI)

local num = 2
local user_setting = Application.user_setting("persistent_ammo_counter")
local slot_size = var_0_0.slot_size
local NUM_SLOTS = var_0_0.NUM_SLOTS
local tbl = {
	slot_potion = "wield_4",
	slot_grenade = "wield_5",
	slot_healthkit = "wield_3",
	slot_career_skill_weapon = "weapon_reload",
	slot_melee = "wield_1",
	slot_ranged = "wield_2"
}
local tbl_2 = {
	slot_grenade = true,
	slot_healthkit = true,
	slot_potion = true,
	slot_career_skill_weapon = true,
	slot_melee = true,
	slot_ranged = true
}
local tbl_3 = {
	normal = Colors.get_color_table_with_alpha("white", 255),
	empty = Colors.get_color_table_with_alpha("red", 255),
	focus = Colors.get_color_table_with_alpha("font_default", 150),
	unfocused = Colors.get_color_table_with_alpha("font_default", 150)
}

local function fn(self, arg_1_1)
	-- function 1
	local hud_index = self.hud_index

	hud_index = hud_index or 0

	local hud_index_2 = arg_1_1.hud_index

	hud_index_2 = hud_index_2 or 0

	return hud_index < hud_index_2
end

local function fn_2()
	-- function 2
	local get_local_player_party = Managers.party:get_local_player_party()
	local var_2_1 = Managers.state.side.side_by_party[get_local_player_party]

	return not var_2_1 and var_2_1:name() == "dark_pact"
end

EquipmentUI.init = function (self, arg_3_1, arg_3_2)
	-- function 3
	self._parent = arg_3_1
	self.ui_renderer = arg_3_2.ui_renderer
	self.ingame_ui = arg_3_2.ingame_ui
	self.input_manager = arg_3_2.input_manager
	self.peer_id = arg_3_2.peer_id
	self.player = arg_3_2.player
	self.ui_animations = {}
	self._animations = {}
	self.render_settings = {
		alpha_multiplier = 1,
		snap_pixel_positions = false
	}
	self.is_in_inn = arg_3_2.is_in_inn
	self.cleanui = arg_3_2.cleanui
	self._is_spectator = false
	self._spectated_player = nil
	self._spectated_player_unit = nil
	self._reload_attempts = 0

	local event = Managers.state.event

	event:register(self, "input_changed", "event_input_changed")
	event:register(self, "on_spectator_target_changed", "on_spectator_target_changed")
	event:register(self, "swap_equipment_from_storage", "event_swap_equipment_from_storage")
	self:_create_ui_elements()
end

EquipmentUI._create_ui_elements = function (self)
	-- function 4
	self.ui_scenegraph = UISceneGraph.init_scenegraph(scenegraph_definition)

	local tbl = {}
	local tbl_2 = {}
	local tbl_3 = {}
	local tbl_4 = {}
	local tbl_5 = {}
	local tbl_6 = {}
	local tbl_7 = {}
	local num = 1

	for k, v in pairs(var_0_0.widget_definitions) do
		local var_4_8 = UIWidget.init(v)

		tbl_2[k] = var_4_8
		tbl_7[num] = var_4_8
		num = num + 1
	end

	for i, v_2 in ipairs(var_0_0.slot_widget_definitions) do
		local var_4_9 = UIWidget.init(v_2)

		tbl[i] = var_4_9
		tbl_5[i] = var_4_9
		tbl_6[i] = var_4_9
	end

	for k_2, v_3 in pairs(var_0_0.ammo_widget_definitions) do
		local var_4_10 = UIWidget.init(v_3)

		tbl_3[#tbl_3 + 1] = var_4_10
		tbl_4[k_2] = var_4_10
		tbl_2[k_2] = var_4_10
	end

	local tbl_8 = {}

	for i_2, v_4 in ipairs(var_0_0.extra_storage_icon_definitions) do
		tbl_8[i_2] = UIWidget.init(v_4)
	end

	self._extra_storage_icon_widgets = tbl_8
	self._widgets = tbl
	self._widgets_by_name = tbl_2
	self._ammo_widgets = tbl_3
	self._ammo_widgets_by_name = tbl_4
	self._static_widgets = tbl_7
	self._unused_widgets = tbl_5
	self._slot_widgets = tbl_6
	self._ui_animator = UIAnimator:new(self.ui_scenegraph, animations_definitions)
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

EquipmentUI.event_input_changed = function (self)
	-- function 5
	local slots = InventorySettings.slots
	local count = #slots

	for i = 1, count do
		local var_5_2 = slots[i]
		local name = var_5_2.name
		local hud_index = var_5_2.hud_index

		for i_2, v in ipairs(self._slot_widgets) do
			if v.content.hud_index == hud_index then
				self:_set_slot_input(v, name)
				self:_set_widget_dirty(v)
			end
		end
	end

	self:set_dirty()
end

EquipmentUI.on_spectator_target_changed = function (self, arg_6_1)
	-- function 6
	self._spectated_player_unit = arg_6_1
	self._spectated_player = Managers.player:owner(arg_6_1)
	self._is_spectator = true

	if Managers.state.side:get_side_from_player_unique_id(self._spectated_player:unique_id()):name() == "dark_pact" then
		self:set_visible(false)
	else
		self:set_visible(true)
	end
end

EquipmentUI.event_swap_equipment_from_storage = function (self, arg_7_1, arg_7_2)
	-- function 7
	if arg_7_1 ~= "slot_grenade" then
		return
	end

	self._widgets_by_name.extra_storage_bg.style.texture.color[1] = 163
	self._time_fade_storage_slots = Managers.time:time("ui") + 2

	local _extra_storage_icon_widgets = self._extra_storage_icon_widgets

	for i = 1, #_extra_storage_icon_widgets do
		local var_7_1 = _extra_storage_icon_widgets[i]
		local var_7_2 = arg_7_2[i]

		if not var_7_2 then
			local gamepad_hud_icon = var_7_2.gamepad_hud_icon
			local style = var_7_1.style
			local content = var_7_1.content

			content.visible = true
			content.texture_icon = gamepad_hud_icon
			content.texture_glow = gamepad_hud_icon .. "_glow"
			style.texture_icon.color[1] = 255

			local var_7_6 = Colors.color_definitions[var_7_2.key]

			var_7_6 = var_7_6 or Colors.color_definitions.black

			local color = style.texture_glow.color

			color[1] = 255
			color[2] = var_7_6[2]
			color[3] = var_7_6[3]
			color[4] = var_7_6[4]
		else
			var_7_1.content.visible = false
		end
	end
end

EquipmentUI._set_slot_input = function (self, arg_8_1, arg_8_2)
	-- function 8
	local var_8_0 = tbl[arg_8_2]
	local _get_input_texture_data, var_8_2, var_8_3 = self:_get_input_texture_data(var_8_0)

	if not (not var_8_2 and Utf8.length(var_8_2)) then
		local num = 0
	end

	local num_2 = 40
	local input_text = arg_8_1.style.input_text
	local ui_renderer = self.ui_renderer

	var_8_2 = not var_8_2 and UIRenderer.crop_text_width(ui_renderer, var_8_2, num_2, input_text)
	arg_8_1.content.input_text = var_8_2 or ""
	arg_8_1.content.input_action = var_8_0
end

EquipmentUI._get_input_texture_data = function (self, arg_9_1)
	-- function 9
	local input_manager = self.input_manager
	local get_service = input_manager:get_service("Player")
	local is_device_active = input_manager:is_device_active("gamepad")
	local PLATFORM = PLATFORM

	if not IS_WINDOWS and not is_device_active then
		PLATFORM = "xb1"
	end

	local get_keymapping = get_service:get_keymapping(arg_9_1, PLATFORM)
	local flag = not get_keymapping and get_keymapping[1]
	local var_9_6

	if not get_keymapping then
		var_9_6 = get_keymapping[2]

		if not var_9_6 then
			-- Nothing
		end
	end

	var_9_6 = UNASSIGNED_KEY

	::label_9_0::

	local flag_2 = not get_keymapping and get_keymapping[3]
	local var_9_8

	if flag_2 == "held" then
		var_9_8 = "matchmaking_prefix_hold"
	end

	local flag_3 = var_9_6 == UNASSIGNED_KEY
	local str = ""

	if flag == "keyboard" then
		local flag_4

		flag_4 = not flag_3 and "" and Keyboard.button_locale_name(var_9_6)

		return nil, flag_4, var_9_8
	elseif flag == "mouse" then
		local flag_5

		flag_5 = not flag_3 and "" and Mouse.button_name(var_9_6)

		return nil, flag_5, var_9_8
	elseif flag == "gamepad" then
		local flag_6

		flag_6 = not flag_3 and "" and Pad1.button_name(var_9_6)

		return ButtonTextureByName(flag_6, PLATFORM), flag_6, var_9_8
	end

	return nil, ""
end

EquipmentUI._update_widgets = function (self)
	-- function 10
	local _slot_widgets = self._slot_widgets

	for i, v in ipairs(_slot_widgets) do
		self:_set_widget_dirty(v)
	end

	self:set_dirty()
end

EquipmentUI._get_wield_scroll_input = function (self)
	-- function 11
	local player_manager = self.player_manager
	local _spectated_player

	if not self._is_spectator then
		_spectated_player = self._spectated_player

		if not _spectated_player then
			-- Nothing
		end
	end

	_spectated_player = self.player

	::label_11_0::

	local player_unit = _spectated_player.player_unit

	if not player_unit then
		return
	end

	local network_id = _spectated_player:network_id()

	return ScriptUnit.has_extension(player_unit, "input_system"):get_last_scroll_value()
end

EquipmentUI._set_wielded_item = function (self, arg_12_1)
	-- function 12
	local _added_items = self._added_items

	for i, v in ipairs(_added_items) do
		local flag = v.slot_name == self._wielded_slot_name
		local flag_2 = v.slot_name == arg_12_1
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

	self._wielded_slot_name = arg_12_1
end

local tbl_4 = {}
local tbl_5 = {}

EquipmentUI._sync_player_equipment = function (self)
	-- function 13
	local _spectated_player

	if not self._is_spectator then
		_spectated_player = self._spectated_player

		if not _spectated_player then
			-- Nothing
		end
	end

	_spectated_player = self.player

	::label_13_0::

	local player_unit = _spectated_player.player_unit

	if not player_unit then
		return
	end

	local extension = ScriptUnit.extension(player_unit, "inventory_system")
	local equipment = extension:equipment()

	if not equipment then
		return
	end

	table.clear(tbl_5)

	local flag = false
	local var_13_5
	local slots = equipment.slots
	local wielded_slot = equipment.wielded_slot
	local slots_2 = InventorySettings.slots
	local count = #slots_2
	local career_name = _spectated_player:career_name()
	local content = self._widgets_by_name.background_panel.content
	local var_13_12 = UISettings.hud_inventory_panel_data[career_name]

	var_13_12 = var_13_12 or UISettings.hud_inventory_panel_data.default
	content.texture_id = var_13_12.texture_id
	self._widgets_by_name.background_panel.style.texture_id.texture_size = var_13_12.texture_size

	local flag_2 = career_name == "dr_engineer"
	local _added_items = self._added_items

	for i = 1, count do
		local name = slots_2[i].name

		if not (not tbl_2[name] and name ~= "slot_career_skill_weapon" and flag_2) then
			-- Nothing
		else
			local var_13_16 = slots[name]
			local flag_3 = not var_13_16 and var_13_16.item_data
			local flag_4 = not flag_3 and flag_3.name
			local flag_5 = not flag_3 and flag_3.backend_id
			local flag_6 = not name and wielded_slot == name or false
			local flag_7 = false
			local num = 0

			for j = 1, #_added_items do
				local var_13_23 = _added_items[j]
				local var_13_24

				if not flag_5 then
					var_13_24 = var_13_23.item_id == flag_5
				else
					var_13_24 = var_13_23.item_name == flag_4
				end

				local flag_8 = var_13_23.slot_name == name

				if not flag_8 then
					num = j
				end

				if not var_13_24 then
					if not tbl_5[j] then
						flag_7 = true
						tbl_5[j] = true

						break
					end
				elseif not flag_4 and not flag_8 then
					flag_7 = true
					tbl_5[j] = true

					self:_add_item(var_13_16, var_13_23)

					flag = true

					break
				end
			end

			if not (flag_7 or var_13_16 == nil) then
				self:_add_item(var_13_16)

				tbl_5[#_added_items] = true
				flag = true
			end

			if not flag_6 then
				var_13_5 = name
			end

			if (name ~= "slot_ranged" or not flag_3) and var_13_16.left_unit_1p and not var_13_16.right_unit_1p then
				self:_update_ammo_count(flag_3, var_13_16, player_unit)
			end

			if not ((name ~= "slot_grenade" or not flag_3) and not (num > 0)) then
				local has_additional_item_slots = extension:has_additional_item_slots(name)
				local get_total_item_count = extension:get_total_item_count(name)
				local var_13_28 = _added_items[num]
				local flag_9 = not var_13_28 and var_13_28.widget

				if not flag_9 then
					local content_2 = flag_9.content

					if content_2.use_count ~= get_total_item_count then
						content_2.use_count = get_total_item_count
						content_2.use_count_text = "x" .. get_total_item_count
						content_2.has_additional_slots = has_additional_item_slots

						self:_set_widget_dirty(flag_9)
					end

					local can_swap_from_storage = extension:can_swap_from_storage(name, SwapFromStorageType.Unique)

					if content_2.can_swap ~= can_swap_from_storage then
						content_2.can_swap = can_swap_from_storage

						self:_set_widget_dirty(flag_9)
					end
				end
			end

			if not ((name ~= "slot_potion" or not flag_3) and not (num > 0)) then
				local var_13_32 = _added_items[num]
				local flag_10 = not var_13_32 and var_13_32.widget

				if not flag_10 then
					local content_3 = flag_10.content
					local style = flag_10.style
					local has_additional_item_slots_2 = extension:has_additional_item_slots(name)
					local get_additional_items = extension:get_additional_items(name)

					if not get_additional_items then
						local var_13_38 = get_additional_items[1]

						if not var_13_38 then
							local gamepad_hud_icon = var_13_38.gamepad_hud_icon

							content_3.secondary_texture_icon = gamepad_hud_icon
							content_3.secondary_texture_icon_glow = gamepad_hud_icon .. "_glow"
							content_3.has_additional_slots = has_additional_item_slots_2

							local key = var_13_38.key

							if content_3.additional_item_key ~= key then
								content_3.additional_item_key = key

								local inventory_consumable_slot_colors = UISettings.inventory_consumable_slot_colors
								local tbl = {
									255,
									0,
									0,
									0
								}
								local tbl_3 = {
									255,
									255,
									255,
									255
								}
								local var_13_44 = inventory_consumable_slot_colors[var_13_38.key]

								if not var_13_44 then
									style.secondary_texture_icon.color = var_13_44
									style.secondary_texture_icon_glow.color = {
										255,
										0,
										0,
										0
									}
								else
									style.secondary_texture_icon.color = tbl
									style.secondary_texture_icon_glow.color = tbl_3
								end

								local default = UISettings.additional_inventory_slot_angles.default
								local var_13_46 = UISettings.additional_inventory_slot_angles[var_13_38.key]

								var_13_46 = var_13_46 or default
								style.secondary_texture_icon.angle = var_13_46
								style.secondary_texture_icon_glow.angle = var_13_46

								self:_set_widget_dirty(flag_10)
							end
						elseif var_13_38 or not content_3.additional_item_key then
							content_3.secondary_texture_icon = nil
							content_3.secondary_texture_icon_glow = nil
							content_3.has_additional_slots = has_additional_item_slots_2
							content_3.additional_item_key = nil

							self:_set_widget_dirty(flag_10)
						end
					elseif not (not content_3.has_additional_slots and has_additional_item_slots_2) then
						content_3.secondary_texture_icon = nil
						content_3.secondary_texture_icon_glow = nil
						content_3.has_additional_slots = has_additional_item_slots_2
						content_3.additional_item_key = nil

						self:_set_widget_dirty(flag_10)
					end
				end
			end

			if not ((name ~= "slot_career_skill_weapon" or not flag_3) and not (num > 0)) then
				local var_13_47 = _added_items[num]
				local flag_11 = not var_13_47 and var_13_47.widget

				if not flag_11 then
					local current_ability_cooldown, var_13_50 = ScriptUnit.has_extension(player_unit, "career_system"):current_ability_cooldown(1)
					local has_buff_type = ScriptUnit.has_extension(player_unit, "buff_system"):has_buff_type("bardin_engineer_pump_max_exhaustion_buff")
					local flag_12 = equipment.wielded_slot ~= "slot_career_skill_weapon" or not (current_ability_cooldown > 0) or not has_buff_type

					if not (flag_11.content.can_reload ~= flag_12 or flag_11.content.is_exhausted ~= has_buff_type) then
						flag_11.content.can_reload = flag_12
						flag_11.content.is_exhausted = has_buff_type

						self:_set_widget_dirty(flag_11)
					end

					local condition_func = WeaponUtils.get_weapon_template(flag_3.template).actions.action_one.default.condition_func

					if not (not flag_12 and condition_func(player_unit, nil)) then
						local time = Managers.time:time("ui")

						flag_11.style.reload_icon.color[1] = 255 - 155 * (0.5 + 0.5 * math.sin(5 * time))

						self:_set_widget_dirty(flag_11)
					else
						flag_11.style.reload_icon.color[1] = 235
					end

					local color = flag_11.style.reload_icon.color
					local flag_13

					flag_13 = not has_buff_type and 100 and 255
					color[3] = flag_13

					local color_2 = flag_11.style.reload_icon.color
					local flag_14

					flag_14 = not has_buff_type and 69 and 255
					color_2[4] = flag_14
				end
			end
		end
	end

	table.clear(tbl_4)

	for k = 1, #_added_items do
		if not tbl_5[k] then
			tbl_4[#tbl_4 + 1] = k
		end
	end

	local num_2 = 0

	for l = 1, #tbl_4 do
		local num_3 = tbl_4[l] - num_2

		self:_remove_item(num_3)

		num_2 = num_2 + 1
		flag = true
	end

	if not flag then
		self:_update_widgets()
		table.sort(_added_items, fn)
	end

	if not (not wielded_slot and var_13_5) then
		var_13_5 = wielded_slot

		self:_set_ammo_text_focus(false)
	end

	if not var_13_5 and self._wielded_slot_name ~= var_13_5 and not flag then
		var_13_5 = var_13_5 or self._wielded_slot_name

		self:_set_wielded_item(var_13_5)
	end
end

EquipmentUI._update_ammo_count = function (self, arg_14_1, arg_14_2, arg_14_3)
	-- function 14
	local get_item_template = BackendUtils.get_item_template(arg_14_1)
	local _ammo_widgets_by_name = self._ammo_widgets_by_name
	local flag = false

	if not get_item_template.ammo_data then
		if not get_item_template.ammo_data.hide_ammo_ui then
			self._draw_ammo = false
		else
			self._draw_ammo = true

			local _get_ammunition_count, var_14_4, var_14_5 = self:_get_ammunition_count(arg_14_2.left_unit_1p, arg_14_2.right_unit_1p, get_item_template)
			local content = _ammo_widgets_by_name.ammo_text_clip.content
			local flag_2 = _get_ammunition_count + var_14_4 == 0
			local flag_3 = false

			if self._ammo_count ~= _get_ammunition_count then
				self._ammo_count = _get_ammunition_count

				local ammo_text_clip = _ammo_widgets_by_name.ammo_text_clip

				ammo_text_clip.content.text = tostring(_get_ammunition_count)

				self:_set_widget_dirty(ammo_text_clip)

				flag_3 = true
			end

			if self._remaining_ammo ~= var_14_4 then
				self._remaining_ammo = var_14_4

				local ammo_text_remaining = _ammo_widgets_by_name.ammo_text_remaining

				ammo_text_remaining.content.text = tostring(var_14_4)

				self:_set_widget_dirty(ammo_text_remaining)

				flag_3 = true
			end

			if not flag_3 then
				self._ammo_counter_fade_delay = num
				self._ammo_counter_fade_progress = 1

				self:_set_ammo_counter_alpha(255)

				local empty

				if not flag_2 then
					empty = tbl_3.empty

					if not empty then
						-- Nothing
					end
				end

				empty = tbl_3.normal

				::label_14_0::

				self:_set_ammo_counter_color(empty)
				self:set_dirty()
			end
		end
	else
		local _get_overcharge_amount, var_14_13, var_14_14 = self:_get_overcharge_amount(arg_14_3)

		if self._overcharge_fraction ~= var_14_13 then
			self._overcharge_fraction = var_14_13

			self:_set_overheat_fraction(var_14_13)
		end

		flag = true
	end

	if self._draw_overheat ~= flag then
		self._draw_overheat = flag

		self:_show_overheat_meter(flag)
	end
end

EquipmentUI._animate_ammo_counter = function (self, arg_15_1)
	-- function 15
	local _ammo_counter_fade_delay = self._ammo_counter_fade_delay

	if not _ammo_counter_fade_delay then
		local max = math.max(_ammo_counter_fade_delay - arg_15_1, 0)

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

	local max_2 = math.max(_ammo_counter_fade_progress - arg_15_1, 0)
	local num = 100 + 155 * max_2

	self:_set_ammo_counter_alpha(num)

	if max_2 == 0 then
		self._ammo_counter_fade_progress = nil
	else
		self._ammo_counter_fade_progress = max_2
	end

	return true
end

EquipmentUI._set_ammo_counter_alpha = function (self, arg_16_1)
	-- function 16
	local _ammo_widgets_by_name = self._ammo_widgets_by_name
	local ammo_text_clip = _ammo_widgets_by_name.ammo_text_clip

	ammo_text_clip.style.text.text_color[1] = arg_16_1

	self:_set_widget_dirty(ammo_text_clip)

	local ammo_text_remaining = _ammo_widgets_by_name.ammo_text_remaining

	ammo_text_remaining.style.text.text_color[1] = arg_16_1

	self:_set_widget_dirty(ammo_text_remaining)

	local ammo_text_center = _ammo_widgets_by_name.ammo_text_center

	ammo_text_center.style.text.text_color[1] = arg_16_1

	self:_set_widget_dirty(ammo_text_center)
	self:set_dirty()
end

EquipmentUI._set_ammo_counter_color = function (self, arg_17_1)
	-- function 17
	local ammo_text_clip = self._ammo_widgets_by_name.ammo_text_clip
	local text_color = ammo_text_clip.style.text.text_color

	text_color[2] = arg_17_1[2]
	text_color[3] = arg_17_1[3]
	text_color[4] = arg_17_1[4]

	self:_set_widget_dirty(ammo_text_clip)

	local ammo_text_remaining = self._ammo_widgets_by_name.ammo_text_remaining
	local text_color_2 = ammo_text_remaining.style.text.text_color

	text_color_2[2] = arg_17_1[2]
	text_color_2[3] = arg_17_1[3]
	text_color_2[4] = arg_17_1[4]

	self:_set_widget_dirty(ammo_text_remaining)

	local ammo_text_center = self._ammo_widgets_by_name.ammo_text_center
	local text_color_3 = ammo_text_center.style.text.text_color

	text_color_3[2] = arg_17_1[2]
	text_color_3[3] = arg_17_1[3]
	text_color_3[4] = arg_17_1[4]

	self:_set_widget_dirty(ammo_text_center)
	self:set_dirty()
end

EquipmentUI._set_ammo_text_focus = function (self, arg_18_1)
	-- function 18
	if not self._draw_overheat then
		if self._overcharge_fraction ~= nil then
			local num_2 = 1
			local focus

			if not arg_18_1 then
				focus = tbl_3.focus

				if not focus then
					-- Nothing
				end
			end

			focus = tbl_3.unfocused

			::label_18_0::

			local _widgets_by_name = self._widgets_by_name
			local overcharge = _widgets_by_name.overcharge
			local overcharge_background = _widgets_by_name.overcharge_background
			local color = overcharge.style.texture_id.color
			local color_2 = overcharge_background.style.texture_id.color

			color[2] = focus[2] * num_2
			color[3] = focus[3] * num_2
			color[4] = focus[4] * num_2

			self:_set_widget_dirty(overcharge)
			self:_set_widget_dirty(overcharge_background)
			self:set_dirty()
		end
	elseif not self._draw_ammo then
		local _ammo_widgets_by_name = self._ammo_widgets_by_name

		if not user_setting and not arg_18_1 then
			self._ammo_counter_fade_progress = 1
			self._ammo_counter_fade_delay = num

			self:_set_ammo_counter_alpha(255)
		end

		if not (user_setting or self._ammo_count ~= nil or self._remaining_ammo == nil) then
			local num_3 = 1

			if not (not arg_18_1 and tbl_3.focus) then
				local unfocused = tbl_3.unfocused
			end

			local ammo_background = self._widgets_by_name.ammo_background

			ammo_background.content.visible = arg_18_1

			self:_set_widget_dirty(ammo_background)

			local ammo_text_clip = _ammo_widgets_by_name.ammo_text_clip

			ammo_text_clip.content.visible = arg_18_1

			self:_set_widget_dirty(ammo_text_clip)

			local ammo_text_remaining = _ammo_widgets_by_name.ammo_text_remaining

			ammo_text_remaining.content.visible = arg_18_1

			self:_set_widget_dirty(ammo_text_remaining)

			local ammo_text_center = _ammo_widgets_by_name.ammo_text_center

			ammo_text_center.content.visible = arg_18_1

			self:_set_widget_dirty(ammo_text_center)
			self:set_dirty()
		end
	end

	if not user_setting then
		self._show_ammo_meter = arg_18_1

		if not arg_18_1 then
			local _widgets_by_name_2 = self._widgets_by_name
			local _ammo_widgets_by_name_2 = self._ammo_widgets_by_name
			local overcharge_2 = _widgets_by_name_2.overcharge
			local overcharge_background_2 = _widgets_by_name_2.overcharge_background
			local ammo_background_2 = _widgets_by_name_2.ammo_background
			local ammo_text_clip_2 = _ammo_widgets_by_name_2.ammo_text_clip
			local ammo_text_remaining_2 = _ammo_widgets_by_name_2.ammo_text_remaining
			local ammo_text_center_2 = _ammo_widgets_by_name_2.ammo_text_center
			local reload_tip_text = _ammo_widgets_by_name_2.reload_tip_text

			self:_set_widget_visibility(overcharge_2, false)
			self:_set_widget_visibility(overcharge_background_2, false)
			self:_set_widget_visibility(ammo_background_2, false)
			self:_set_widget_visibility(ammo_text_clip_2, false)
			self:_set_widget_visibility(ammo_text_remaining_2, false)
			self:_set_widget_visibility(ammo_text_center_2, false)
			self:_set_widget_visibility(reload_tip_text, false)

			self._ammo_dirty = true
		end
	end
end

EquipmentUI._get_ammunition_count = function (arg_19_0, arg_19_1, arg_19_2, arg_19_3)
	-- function 19
	local var_19_0

	if not arg_19_3.ammo_data then
		return
	end

	local ammo_hand = arg_19_3.ammo_data.ammo_hand

	if ammo_hand == "right" then
		var_19_0 = ScriptUnit.extension(arg_19_2, "ammo_system")
	elseif ammo_hand == "left" then
		var_19_0 = ScriptUnit.extension(arg_19_1, "ammo_system")
	else
		return
	end

	local ammo_count = var_19_0:ammo_count()
	local remaining_ammo = var_19_0:remaining_ammo()
	local using_single_clip = var_19_0:using_single_clip()

	return ammo_count, remaining_ammo, using_single_clip
end

EquipmentUI._get_overcharge_amount = function (arg_20_0, arg_20_1)
	-- function 20
	local extension = ScriptUnit.extension(arg_20_1, "overcharge_system")
	local overcharge_fraction = extension:overcharge_fraction()
	local threshold_fraction = extension:threshold_fraction()
	local get_anim_blend_overcharge = extension:get_anim_blend_overcharge()

	return true, overcharge_fraction, threshold_fraction, get_anim_blend_overcharge
end

EquipmentUI._add_animation = function (self, arg_21_1, arg_21_2, arg_21_3, arg_21_4)
	-- function 21
	local _animations = self._animations
	local equip_animation_duration = UISettings.inventory_hud.equip_animation_duration
	local var_21_2 = _animations[arg_21_1]

	if not var_21_2 then
		var_21_2.total_time = equip_animation_duration
		var_21_2.time = 0
		var_21_2.func = arg_21_4
	else
		_animations[arg_21_1] = {
			time = 0,
			total_time = equip_animation_duration,
			style = arg_21_3,
			widget = arg_21_2,
			func = arg_21_4
		}
	end
end

EquipmentUI._update_animations = function (self, arg_22_1, arg_22_2)
	-- function 22
	local _time_fade_storage_slots = self._time_fade_storage_slots

	if not _time_fade_storage_slots then
		local clamp = math.clamp(_time_fade_storage_slots - arg_22_2, 0, 1)
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
		_animations[k] = self[v.func](self, v, arg_22_1)

		local widget = v.widget

		self:_set_widget_dirty(widget)

		flag = true
	end

	return flag
end

EquipmentUI._animate_slot_wield = function (arg_23_0, arg_23_1, arg_23_2)
	-- function 23
	local widget = arg_23_1.widget
	local total_time = arg_23_1.total_time
	local num = arg_23_1.time + arg_23_2
	local min = math.min(num / total_time, 1)
	local easeOutCubic = math.easeOutCubic(min)
	local easeInCubic = math.easeInCubic(1 - min)

	widget.style.texture_selected.color[1] = 255 * easeOutCubic
	arg_23_1.time = num

	return not (min < 1) or not arg_23_1 or nil
end

EquipmentUI._animate_slot_unwield = function (arg_24_0, arg_24_1, arg_24_2)
	-- function 24
	local widget = arg_24_1.widget
	local total_time = arg_24_1.total_time
	local num = arg_24_1.time + arg_24_2
	local min = math.min(num / total_time, 1)
	local easeInCubic = math.easeInCubic(1 - min)
	local easeOutCubic = math.easeOutCubic(min)

	widget.style.texture_selected.color[1] = 255 * easeInCubic
	arg_24_1.time = num

	return not (min < 1) or not arg_24_1 or nil
end

EquipmentUI._animate_slot_equip = function (arg_25_0, arg_25_1, arg_25_2)
	-- function 25
	local style = arg_25_1.style
	local total_time = arg_25_1.total_time
	local num = arg_25_1.time + arg_25_2
	local min = math.min(num / total_time, 1)
	local catmullrom = math.catmullrom(min, -10, 0, 0, -4)
	local easeOutCubic = math.easeOutCubic(min)

	style.color[1] = 255 * easeOutCubic
	arg_25_1.time = num

	return not (min < 1) or not arg_25_1 or nil
end

EquipmentUI._add_item = function (self, arg_26_1, arg_26_2)
	-- function 26
	local _num_added_items = self._num_added_items

	_num_added_items = _num_added_items or 0

	local flag = arg_26_2 ~= nil

	if not (flag or not (_num_added_items >= NUM_SLOTS)) then
		return
	end

	local id = arg_26_1.id
	local slot_type = arg_26_1.item_data.slot_type
	local hud_index = InventorySettings.slots_by_name[id].hud_index
	local var_26_5

	if not flag then
		var_26_5 = arg_26_2.widget
	else
		for i, v in ipairs(self._slot_widgets) do
			if v.content.hud_index == hud_index then
				var_26_5 = v

				break
			end
		end

		UIRenderer.set_element_visible(self.ui_renderer, var_26_5.element, true)
	end

	local content = var_26_5.content
	local style = var_26_5.style
	local normal_color = content.normal_color
	local item_data = arg_26_1.item_data
	local name = item_data.name
	local hud_icon = item_data.hud_icon

	if slot_type == "melee" then
		hud_icon = "hud_inventory_icon_melee"
	elseif slot_type == "ranged" then
		hud_icon = "hud_inventory_icon_ranged"
	elseif id == "slot_career_skill_weapon" then
		hud_icon = "hud_ability_cog_icon"
	end

	local texture_background = style.texture_background

	if not texture_background then
		local inventory_consumable_slot_colors = UISettings.inventory_consumable_slot_colors
		local default = inventory_consumable_slot_colors.default
		local var_26_15 = inventory_consumable_slot_colors[name]

		var_26_15 = var_26_15 or default

		Colors.copy_to(texture_background.color, var_26_15)
	end

	content.texture_icon = hud_icon or "icons_placeholder"
	style.texture_icon.color[1] = 255
	content.visible = true
	arg_26_2 = arg_26_2 or {}
	arg_26_2.hud_index = hud_index
	arg_26_2.slot_name = id
	arg_26_2.item_name = name
	arg_26_2.widget = var_26_5
	arg_26_2.wielded = false
	arg_26_2.icon = hud_icon
	arg_26_2.item_id = item_data.backend_id

	if not flag then
		local _added_items = self._added_items

		table.insert(_added_items, #_added_items + 1, arg_26_2)

		self._num_added_items = _num_added_items + 1
	end
end

EquipmentUI._remove_item = function (self, arg_27_1)
	-- function 27
	local _num_added_items = self._num_added_items

	_num_added_items = _num_added_items or 0

	if _num_added_items <= 0 then
		return
	end

	local _added_items = self._added_items
	local remove = table.remove(_added_items, arg_27_1)
	local slot_name = remove.slot_name
	local widget = remove.widget
	local content = widget.content
	local style = widget.style

	style.texture_icon.color[1] = 0

	local selected = content.selected

	content.selected = false

	local default = UISettings.inventory_consumable_slot_colors.default

	if not style.texture_background then
		local color = style.texture_background.color

		color[2] = default[2]
		color[3] = default[3]
		color[4] = default[4]
	end

	content.visible = false
	self._num_added_items = _num_added_items - 1

	if not selected then
		self:_add_animation(slot_name .. "_wield_anim", widget, widget, "_animate_slot_unwield")
	else
		widget.style.texture_selected.color[1] = 0
	end
end

EquipmentUI.set_position = function (self, arg_28_1, arg_28_2)
	-- function 28
	local local_position = self.ui_scenegraph.pivot.local_position

	local_position[1] = arg_28_1
	local_position[2] = arg_28_2

	for i, v in ipairs(self._widgets) do
		self:_set_widget_dirty(v)
	end

	for i_2, v_2 in ipairs(self._static_widgets) do
		self:_set_widget_dirty(v_2)
	end

	self:set_dirty()
end

EquipmentUI.destroy = function (self)
	-- function 29
	local event = Managers.state.event

	event:unregister("input_changed", self)
	event:unregister("on_spectator_target_changed", self)
	event:unregister("swap_equipment_from_storage", self)
	self:set_visible(false)

	self._ui_animator = nil

	print("[EquipmentUI] - Destroy")
end

EquipmentUI.set_visible = function (self, arg_30_1)
	-- function 30
	self._is_visible = arg_30_1

	self:_set_elements_visible(arg_30_1)
end

EquipmentUI._set_elements_visible = function (self, arg_31_1)
	-- function 31
	local ui_renderer = self.ui_renderer

	for i, v in ipairs(self._widgets) do
		UIRenderer.set_element_visible(ui_renderer, v.element, arg_31_1)
	end

	for i_2, v_2 in ipairs(self._static_widgets) do
		UIRenderer.set_element_visible(ui_renderer, v_2.element, arg_31_1)
	end

	for i_3, v_3 in ipairs(self._ammo_widgets) do
		UIRenderer.set_element_visible(ui_renderer, v_3.element, arg_31_1)
	end

	self._retained_elements_visible = arg_31_1

	self:set_dirty()
end

local tbl_6 = {
	lock_y = true,
	registry_key = "player_status",
	drag_scenegraph_id = "background_panel",
	root_scenegraph_id = "root",
	label = "Player status",
	lock_x = false
}
local tbl_7 = {
	root_scenegraph_id = "ammo_background",
	label = "Ammo",
	registry_key = "ammo",
	drag_scenegraph_id = "ammo_background"
}

EquipmentUI.update = function (self, arg_32_1, arg_32_2)
	-- function 32
	if not self._is_visible then
		return
	end

	if not HudCustomizer.run(self.ui_renderer, self.ui_scenegraph, tbl_6) then
		UIUtils.mark_dirty(self._widgets_by_name)
		UIUtils.mark_dirty(self._widgets)
		UIUtils.mark_dirty(self._extra_storage_icon_widgets)
	end

	if not HudCustomizer.run(self.ui_renderer, self.ui_scenegraph, tbl_7) then
		UIUtils.mark_dirty(self._ammo_widgets)
	end

	local flag = false
	local get_crosshair_position, var_32_2 = self._parent:get_crosshair_position()

	if not self:_apply_crosshair_position(get_crosshair_position, var_32_2) then
		flag = true
	end

	if not self:_update_animations(arg_32_1, arg_32_2) then
		flag = true
	end

	if not self:_animate_ammo_counter(arg_32_1) then
		flag = true
	end

	if not flag then
		self:set_dirty()
	end

	self:_handle_resolution_modified()
	self:_show_hold_to_reload(arg_32_2)
	self:_sync_player_equipment()
	self:draw(arg_32_1)
	self._ui_animator:update(arg_32_1)
end

EquipmentUI._handle_resolution_modified = function (self)
	-- function 33
	if not RESOLUTION_LOOKUP.modified then
		self:_on_resolution_modified()
	end
end

EquipmentUI._on_resolution_modified = function (self)
	-- function 34
	for i, v in ipairs(self._widgets) do
		self:_set_widget_dirty(v)
	end

	for i_2, v_2 in ipairs(self._static_widgets) do
		self:_set_widget_dirty(v_2)
	end

	for i_3, v_3 in ipairs(self._ammo_widgets) do
		self:_set_widget_dirty(v_3)
	end

	self:set_dirty()
end

EquipmentUI._handle_gamepad = function (self)
	-- function 35
	local is_device_active = Managers.input:is_device_active("gamepad")

	is_device_active = is_device_active or not IS_WINDOWS

	if not ((is_device_active or UISettings.use_gamepad_hud_layout == "always") and UISettings.use_gamepad_hud_layout == "never") then
		if not self._retained_elements_visible then
			self:_set_elements_visible(false)
		end

		return false
	else
		if not self._retained_elements_visible then
			self:_set_elements_visible(true)
			self:event_input_changed()
		end

		return self._dirty
	end
end

EquipmentUI.draw = function (self, arg_36_1)
	-- function 36
	if not self._is_visible then
		return
	end

	if not self:_handle_gamepad() then
		return
	end

	local ui_renderer = self.ui_renderer
	local ui_scenegraph = self.ui_scenegraph
	local get_service = self.input_manager:get_service("ingame_menu")
	local render_settings = self.render_settings
	local alpha_multiplier = render_settings.alpha_multiplier

	UIRenderer.begin_pass(ui_renderer, ui_scenegraph, get_service, arg_36_1, nil, render_settings)

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

	if user_setting or self._show_ammo_meter or not self._ammo_dirty then
		local ammo_alpha_multiplier = self.ammo_alpha_multiplier

		ammo_alpha_multiplier = ammo_alpha_multiplier or alpha_multiplier
		render_settings.alpha_multiplier = ammo_alpha_multiplier
		render_settings.snap_pixel_positions = true

		for i_4, v_4 in ipairs(self._ammo_widgets) do
			UIRenderer.draw_widget(ui_renderer, v_4)
		end
	end

	UIRenderer.end_pass(ui_renderer)

	self._dirty = false
	self._ammo_dirty = false
end

EquipmentUI._set_color = function (arg_37_0, arg_37_1, arg_37_2, arg_37_3)
	-- function 37
	if not arg_37_3 then
		arg_37_1[1] = arg_37_2[1]
	end

	arg_37_1[2] = arg_37_2[2]
	arg_37_1[3] = arg_37_2[3]
	arg_37_1[4] = arg_37_2[4]
end

EquipmentUI.set_dirty = function (self)
	-- function 38
	self._dirty = true

	if not self.cleanui then
		self.cleanui.dirty = true
	end
end

EquipmentUI._set_widget_dirty = function (self, arg_39_1)
	-- function 39
	arg_39_1.element.dirty = true
	self._dirty = true

	if not self.cleanui then
		self.cleanui.dirty = true
	end
end

EquipmentUI.on_gamepad_activated = function (self)
	-- function 40
	self:_update_widgets()
end

EquipmentUI.on_gamepad_deactivated = function (self)
	-- function 41
	self:_update_widgets()
end

EquipmentUI._set_overheat_fraction = function (self, arg_42_1)
	-- function 42
	local overcharge = self._widgets_by_name.overcharge

	overcharge.content.texture_id.uvs[2][1] = arg_42_1

	local scenegraph_id = overcharge.scenegraph_id
	local var_42_2 = self.ui_scenegraph[scenegraph_id]
	local size = scenegraph_definition[scenegraph_id].size

	var_42_2.size[1] = size[1] * arg_42_1

	self:_set_widget_dirty(overcharge)
	self:set_dirty()
end

EquipmentUI._show_overheat_meter = function (self, arg_43_1)
	-- function 43
	local _widgets_by_name = self._widgets_by_name
	local _ammo_widgets_by_name = self._ammo_widgets_by_name

	self:_set_widget_visibility(_widgets_by_name.overcharge, false)
	self:_set_widget_visibility(_widgets_by_name.overcharge_background, false)
	self:_set_widget_visibility(_ammo_widgets_by_name.ammo_text_clip, not arg_43_1)
	self:_set_widget_visibility(_ammo_widgets_by_name.ammo_text_remaining, not arg_43_1)
	self:_set_widget_visibility(_ammo_widgets_by_name.ammo_text_center, not arg_43_1)
	self:_set_widget_visibility(_widgets_by_name.ammo_background, not arg_43_1)
	self:set_dirty()
end

EquipmentUI._set_widget_visibility = function (self, arg_44_1, arg_44_2)
	-- function 44
	arg_44_1.content.visible = arg_44_2

	self:_set_widget_dirty(arg_44_1)
end

EquipmentUI.set_alpha = function (self, arg_45_1)
	-- function 45
	self.render_settings.alpha_multiplier = arg_45_1

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

EquipmentUI.set_ammo_alpha = function (self, arg_46_1)
	-- function 46
	self.ammo_alpha_multiplier = arg_46_1

	for k, v in pairs(self._ammo_widgets) do
		self:_set_widget_dirty(v)
	end

	self:set_dirty()
end

EquipmentUI.set_panel_alpha = function (self, arg_47_1)
	-- function 47
	self.panel_alpha_multiplier = arg_47_1

	for k, v in pairs(self._widgets) do
		self:_set_widget_dirty(v)
	end

	for k_2, v_2 in pairs(self._slot_widgets) do
		self:_set_widget_dirty(v_2)
	end

	for k_3, v_3 in pairs(self._static_widgets) do
		self:_set_widget_dirty(v_3)
	end

	self:set_dirty()
end

EquipmentUI._apply_crosshair_position = function (self, arg_48_1, arg_48_2)
	-- function 48
	local str = "screen_bottom_pivot"
	local local_position = self.ui_scenegraph[str].local_position
	local flag = false

	if not (local_position[1] ~= arg_48_1 or local_position[2] == arg_48_2) then
		flag = true
	end

	local_position[1] = arg_48_1
	local_position[2] = arg_48_2

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

EquipmentUI._show_hold_to_reload = function (self, arg_49_1)
	-- function 49
	local _spectated_player

	if not self._is_spectator then
		_spectated_player = self._spectated_player

		if not _spectated_player then
			-- Nothing
		end
	end

	_spectated_player = self.player

	::label_49_0::

	local player_unit = _spectated_player.player_unit

	if not player_unit then
		return
	end

	local equipment = ScriptUnit.extension(player_unit, "inventory_system"):equipment()
	local wielded_slot = equipment.wielded_slot
	local flag = false
	local var_49_5
	local var_49_6
	local var_49_7

	for k, v in pairs(equipment.slots) do
		local item_data = v.item_data
		local get_item_template = BackendUtils.get_item_template(item_data)

		if v.id == wielded_slot then
			local ammo_data = get_item_template.ammo_data

			ammo_data = not ammo_data and get_item_template.ammo_data.unique_ammo_type

			if not ammo_data then
				var_49_5 = v
				var_49_6 = item_data
				var_49_7 = get_item_template
				flag = true
			end
		end
	end

	if not (not var_49_6 and not var_49_5 and var_49_7) then
		return
	end

	local _get_ammunition_count, var_49_12, var_49_13 = self:_get_ammunition_count(var_49_5.left_unit_1p, var_49_5.right_unit_1p, var_49_7)
	local reload_tip_text = self._ammo_widgets_by_name.reload_tip_text
	local _get_input_texture_data, var_49_16, var_49_17 = self:_get_input_texture_data("weapon_reload_hold")
	local var_49_18 = reload_tip_text.style.text.text_color[1]
	local format = string.format("{#color(193,91,36, %d)}", var_49_18)

	reload_tip_text.content.text = string.format(Localize("reload_tip"), format, var_49_16, "{#reset()}")

	local flag_2 = _get_ammunition_count + var_49_12 == var_49_7.ammo_data.max_ammo

	if not (not flag and flag_2) then
		if self._reload_attempts >= 3 then
			self._reload_tip_text_shown = true

			if not self._reload_tip_anim and not self._ui_animator:is_animation_completed(self._reload_tip_anim) then
				self._reload_tip_anim = self._ui_animator:start_animation("show_reload_tip", reload_tip_text, scenegraph_definition)
			end
		end

		self:_update_reload_ui_state(arg_49_1, var_49_7)
	end

	self:_set_widget_dirty(reload_tip_text)
end

EquipmentUI._update_reload_ui_state = function (self, arg_50_1, arg_50_2)
	-- function 50
	if not self._ammo_widgets_by_name.reload_tip_text then
		return
	end

	local get_service = Managers.input:get_service("Player")
	local num = 5

	if not get_service:get("weapon_reload_hold") then
		if not self._ui_animator:is_animation_completed(self._reload_tip_anim) then
			return
		end

		if not self._listening_timer_start then
			self._listening_timer_start = arg_50_1
		end

		if not self._reload_start_time then
			self._reload_start_time = arg_50_1
		end
	else
		local anim_time_scale = arg_50_2.actions.weapon_reload.default.anim_time_scale
		local _reload_start_time = self._reload_start_time

		_reload_start_time = not _reload_start_time and anim_time_scale > arg_50_1 - self._reload_start_time

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

	if (num_2 == 0 or not (num_2 < arg_50_1)) and not self._reload_tip_text_shown then
		self._listening_timer_start = nil
		self._reload_attempts = 0
		self._reload_tip_text_shown = false
	end
end
