-- chunkname: @scripts/ui/views/player_inventory_ui.lua

local var_0_0 = local_require("scripts/ui/views/player_inventory_ui_definitions")

require("scripts/settings/inventory_settings")

PlayerInventoryUI = class(PlayerInventoryUI)

local weapon_slots = InventorySettings.weapon_slots
local tbl = {}

for i, v in ipairs(weapon_slots) do
	local name = v.name

	if not (name == "slot_melee" or name ~= "slot_ranged") then
		tbl[i] = v
	end
end

local tbl_2 = {
	slot_healthkit = 1,
	slot_grenade = 3,
	slot_potion = 2
}
local tbl_3 = {
	slot_healthkit = "consumables_medpack",
	slot_grenade = "consumables_frag",
	slot_potion = "consumables_potion_01"
}
local tbl_4 = {}
local tbl_5 = {}
local tbl_6 = {}
local tbl_7 = {}
local tbl_8 = {}
local tbl_9 = {}
local tbl_10 = {}
local tbl_11 = {}
local tbl_12 = {}
local tbl_13 = {}
local tbl_14 = {}
local tbl_15 = {}
local tbl_16 = {}
local tbl_17 = {}
local tbl_18 = {}
local tbl_19 = {}
local tbl_20 = {}

PlayerInventoryUI.init = function (self, arg_1_1, arg_1_2)
	-- function 1
	self._parent = arg_1_1
	self.platform = PLATFORM
	self.ui_renderer = arg_1_2.ui_renderer
	self.input_manager = arg_1_2.input_manager
	self.slot_equip_animations = {}
	self.slot_animations = {}
	self.ui_animations = {}

	self:create_ui_elements()

	self.profile_synchronizer = arg_1_2.profile_synchronizer
	self.peer_id = arg_1_2.peer_id
	self.player_manager = arg_1_2.player_manager
	self.render_settings = {
		snap_pixel_positions = true
	}
	self._visible = not self.input_manager:is_device_active("gamepad")
end

PlayerInventoryUI.destroy = function (self)
	-- function 2
	self:set_visible(false)
end

local tbl_21 = {
	var_0_0.top_inventory_widget_definition,
	var_0_0.inventory_widget_definition,
	var_0_0.small_inventory_widget_definition,
	var_0_0.small_inventory_widget_definition,
	var_0_0.small_inventory_widget_definition
}

PlayerInventoryUI.create_ui_elements = function (self)
	-- function 3
	UIRenderer.clear_scenegraph_queue(self.ui_renderer)

	local inventory_entry_definitions = var_0_0.inventory_entry_definitions

	self.inventory_slots_widgets = {}

	for i = 1, #inventory_entry_definitions do
		self.inventory_slots_widgets[i] = UIWidget.init(inventory_entry_definitions[i])
	end

	self.ui_scenegraph = UISceneGraph.init_scenegraph(var_0_0.scenegraph_definition)
	self.inventory_widgets = {}

	for i_2, v in ipairs(tbl_21) do
		if not tbl_8[i_2] then
			tbl_8[i_2] = "inventory_slot_" .. i_2
		end

		v.scenegraph_id = tbl_8[i_2]
		self.inventory_widgets[i_2] = UIWidget.init(v)
	end
end

PlayerInventoryUI.set_visible = function (self, arg_4_1)
	-- function 4
	if not arg_4_1 and not self.input_manager:is_device_active("gamepad") then
		arg_4_1 = false
	end

	for i, v in ipairs(weapon_slots) do
		local var_4_0 = self.inventory_slots_widgets[i]

		UIRenderer.set_element_visible(self.ui_renderer, var_4_0.element, arg_4_1)
	end

	self._visible = arg_4_1
end

local function fn(arg_5_0, arg_5_1, arg_5_2)
	-- function 5
	local var_5_0

	if not arg_5_2.ammo_data then
		return
	end

	local ammo_hand = arg_5_2.ammo_data.ammo_hand

	if ammo_hand == "right" then
		var_5_0 = ScriptUnit.extension(arg_5_1, "ammo_system")
	elseif ammo_hand == "left" then
		var_5_0 = ScriptUnit.extension(arg_5_0, "ammo_system")
	else
		return
	end

	local using_single_clip = var_5_0:using_single_clip()
	local ammo_count = var_5_0:ammo_count()
	local remaining_ammo = var_5_0:remaining_ammo()

	return ammo_count, not not using_single_clip or remaining_ammo
end

PlayerInventoryUI.overcharge_amount = function (arg_6_0, arg_6_1)
	-- function 6
	local extension = ScriptUnit.extension(arg_6_1, "overcharge_system")
	local overcharge_fraction = extension:overcharge_fraction()
	local threshold_fraction = extension:threshold_fraction()
	local get_anim_blend_overcharge = extension:get_anim_blend_overcharge()

	return overcharge_fraction, threshold_fraction, get_anim_blend_overcharge
end

PlayerInventoryUI.update = function (self, arg_7_1, arg_7_2, arg_7_3)
	-- function 7
	local ui_scenegraph = self.ui_scenegraph
	local input_manager = self.input_manager
	local get_service = input_manager:get_service("ingame_menu")
	local is_device_active = input_manager:is_device_active("gamepad")
	local ui_renderer = self.ui_renderer

	if not is_device_active then
		if not self.gamepad_active_last_frame then
			self.gamepad_active_last_frame = true

			self:on_gamepad_activated()
		end
	elseif not self.gamepad_active_last_frame then
		self.gamepad_active_last_frame = false

		self:on_gamepad_deactivated()
	end

	if not self.stance_bar_lit_animation then
		UIAnimation.update(self.stance_bar_lit_animation, arg_7_1)

		if not UIAnimation.completed(self.stance_bar_lit_animation) then
			self.stance_bar_lit_animation = nil
		end
	end

	for k, v in pairs(self.ui_animations) do
		UIAnimation.update(v, arg_7_1)

		if not UIAnimation.completed(v) then
			self.ui_animations[k] = nil
		end
	end

	if not self._visible then
		return
	end

	self:update_slot_animations(arg_7_1)
	self:update_inventory_slots_positions(arg_7_1)
	UIRenderer.begin_pass(ui_renderer, ui_scenegraph, get_service, arg_7_1, nil, self.render_settings)

	if not RESOLUTION_LOOKUP.modified then
		for i, v_2 in ipairs(weapon_slots) do
			self.inventory_slots_widgets[i].element.dirty = true
		end
	end

	if not arg_7_3 then
		local profile_index = arg_7_3:profile_index()

		if profile_index ~= self.profile_index then
			self.selected_index = nil
			self.profile_index = profile_index
		end

		self:update_inventory_slots(arg_7_1, ui_scenegraph, ui_renderer, arg_7_3)
	end

	UIRenderer.end_pass(ui_renderer)
end

PlayerInventoryUI.on_gamepad_activated = function (self)
	-- function 8
	local user_setting = Application.user_setting("gamepad_layout")

	self:set_visible(false)
end

PlayerInventoryUI.on_gamepad_deactivated = function (self)
	-- function 9
	self:set_visible(true)
end

PlayerInventoryUI.update_inventory_slots = function (self, arg_10_1, arg_10_2, arg_10_3, arg_10_4)
	-- function 10
	local profile_synchronizer = self.profile_synchronizer
	local player_unit = arg_10_4.player_unit
	local var_10_2
	local inventory_hud = UISettings.inventory_hud
	local var_10_4

	if not player_unit then
		local extension = ScriptUnit.extension(player_unit, "health_system")
		local extension_2 = ScriptUnit.extension(player_unit, "status_system")

		var_10_2 = ScriptUnit.extension(player_unit, "inventory_system")
		var_10_4 = ScriptUnit.extension(player_unit, "hud_system")
	end

	if not var_10_2 then
		local inventory_widgets = self.inventory_widgets
		local equipment = var_10_2:equipment()
		local var_10_9 = weapon_slots
		local wielded = equipment.wielded
		local get_picked_up_ammo = var_10_4:get_picked_up_ammo()

		if not get_picked_up_ammo then
			var_10_4:set_picked_up_ammo(false)
		end

		for i, v in ipairs(var_10_9) do
			local name = v.name
			local var_10_13 = equipment.slots[name]
			local var_10_14 = self.inventory_slots_widgets[i]
			local content = var_10_14.content
			local style = var_10_14.style

			if not var_10_13 then
				if not content.has_data then
					content.has_data = nil
				end

				if content.ammo_text_1 ~= "" then
					content.ammo_text_1 = ""
					content.ammo_text_2 = ""
				end

				if not content.stance_bar then
					content.stance_bar.active = false
				end

				if content.icon ~= "weapon_icon_empty" then
					content.icon = "weapon_icon_empty"
				end
			else
				local item_data = var_10_13.item_data
				local flag = wielded == var_10_13.item_data
				local flag_2 = false
				local name_2

				if not item_data then
					name_2 = item_data.name

					if not name_2 then
						-- Nothing
					end
				end

				name_2 = "no_master_item_found"

				do
					local hud_icon
				end

				::label_10_0::

				if not item_data then
					hud_icon = item_data.hud_icon

					if not hud_icon then
						-- Nothing
					end
				end

				hud_icon = tbl_3[name]

				::label_10_1::

				if not tbl_13[hud_icon] then
					tbl_13[hud_icon] = hud_icon .. "_lit"
				end

				if content.icon ~= hud_icon then
					var_10_14.element.dirty = true
					content.icon = hud_icon

					assert(content.icon, "No hud icon for weapon %s", name_2)

					content.icon_lit = tbl_13[hud_icon]
				end

				if not flag and not self:on_inventory_selected_slot_changed(i) then
					local bar_textures = var_0_0.bar_textures
					local overcharge_amount, var_10_24 = self:overcharge_amount(player_unit)

					if not overcharge_amount then
						content.stance_bar.texture_id = bar_textures.stance_bar.bar
						content.stance_bar_glow = bar_textures.stance_bar.glow
					else
						content.stance_bar.texture_id = bar_textures.charge_bar.bar
						content.stance_bar_glow = bar_textures.charge_bar.glow
					end
				end

				if not content.has_data then
					content.has_data = true
				end

				local get_item_template = BackendUtils.get_item_template(item_data)
				local var_10_26, var_10_27 = fn(var_10_13.left_unit_1p, var_10_13.right_unit_1p, get_item_template)

				if not var_10_26 then
					local ammo_data = get_item_template.ammo_data

					if not (not ammo_data and ammo_data.destroy_when_out_of_ammo) then
						local var_10_29 = tostring(var_10_26)
						local var_10_30

						if not var_10_27 then
							var_10_30 = tostring(var_10_27)

							if not var_10_30 then
								-- Nothing
							end
						end

						var_10_30 = ""

						::label_10_2::

						if not (var_10_29 ~= content.ammo_text_1 or var_10_30 == content.ammo_text_2) then
							var_10_14.element.dirty = true
							content.ammo_text_1 = var_10_29
							content.ammo_text_2 = var_10_30
						end

						if not tbl_9[name] then
							tbl_9[name] = name .. "ammo_text_1_flash"
							tbl_10[name] = name .. "ammo_text_2_flash"
							tbl_11[name] = name .. "ammo_text_1_pulse"
							tbl_12[name] = name .. "ammo_text_2_pulse"
						end

						if not get_picked_up_ammo then
							self.ui_animations[tbl_9[name]] = UIAnimation.init(UIAnimation.text_flash, style.ammo_text_1.text_color, 1, 255, 200, 5, 0.7)
							self.ui_animations[tbl_10[name]] = UIAnimation.init(UIAnimation.text_flash, style.ammo_text_2.text_color, 1, 255, 200, 5, 0.7)
							self.ui_animations[tbl_11[name]] = UIAnimation.init(UIAnimation.pulse_animation3, style.ammo_text_1, "font_size", 26, 24, 5, 0.7)
							self.ui_animations[tbl_12[name]] = UIAnimation.init(UIAnimation.pulse_animation3, style.ammo_text_2, "font_size", 26, 24, 5, 0.7)
						end
					else
						content.ammo_text_1 = ""
						content.ammo_text_2 = ""
					end

					content.stance_bar.active = false
				else
					local var_10_31
					local overcharge_amount_2, var_10_33, var_10_34 = self:overcharge_amount(player_unit)

					if not overcharge_amount_2 then
						var_10_31 = math.min(overcharge_amount_2, 1)
					else
						var_10_31 = 0
					end

					local lerp = math.lerp(content.stance_bar.bar_value, math.min(var_10_31, 1), 0.3)
					local stance_bar = content.stance_bar
					local flag_3

					flag_3 = item_data.slot_type == "melee" or not true or false
					stance_bar.active = flag_3
					content.stance_bar.bar_value = lerp

					if not tbl_4[name] then
						tbl_4[name] = name .. "stance_bar_glow_pulse"
						tbl_5[name] = name .. "stance_bar_lit_glow_out"
						tbl_6[name] = name .. "stance_bar_glow_fade_out"
					end

					if not (self.ui_animations[tbl_4[name]] or not (lerp >= 1)) then
						self.ui_animations[tbl_4[name]] = UIAnimation.init(UIAnimation.pulse_animation, style.stance_bar_glow.color, 1, 0, 255, inventory_hud.bar_lit_pulse_duration)
					elseif not (not self.ui_animations[tbl_4[name]] and self.ui_animations[tbl_5[name]] or not (lerp < 1)) then
						self.ui_animations[tbl_4[name]] = nil
						self.ui_animations[tbl_6[name]] = UIAnimation.init(UIAnimation.function_by_time, style.stance_bar_glow.color, 1, style.stance_bar_glow.color[1], 0, inventory_hud.bar_lit_fade_out_duration, math.easeInCubic)
					end

					content.ammo_text_1 = ""
					content.ammo_text_2 = ""
				end

				local num = -26
				local num_2 = -5

				if not tbl_7[i] then
					tbl_7[i] = "inventory_entry_root_" .. i
				end

				if not content.stance_bar.active then
					if self.ui_scenegraph[tbl_7[i]].local_position[1] ~= num then
						self.ui_scenegraph[tbl_7[i]].local_position[1] = num
					end
				elseif self.ui_scenegraph[tbl_7[i]].local_position[1] ~= num_2 then
					self.ui_scenegraph[tbl_7[i]].local_position[1] = num_2
				end
			end

			UIRenderer.draw_widget(arg_10_3, var_10_14)
		end
	end
end

PlayerInventoryUI.update_inventory_slots_positions = function (self, arg_11_1)
	-- function 11
	local scenegraph_definition = var_0_0.scenegraph_definition

	if not self.selected_index then
		local num = 0
	end

	local previous_selected_index = self.previous_selected_index
	local ui_scenegraph = self.ui_scenegraph
	local slot_spacing = UISettings.inventory_hud.slot_spacing
	local num_2 = 0

	for i = #weapon_slots, 1, -1 do
		local name = weapon_slots[i].name
		local flag

		flag = not tbl_2[name] and true and false

		local flag_2

		flag_2 = not flag and 0.9 and 0.6

		if not tbl_14[i] then
			tbl_14[i] = "inventory_entry_background_" .. i
		end

		local var_11_9 = tbl_14[i]
		local var_11_10 = self.inventory_slots_widgets[i]
		local num_3 = i - 1
		local var_11_12 = self.inventory_slots_widgets[num_3]
		local num_4 = ui_scenegraph[var_11_9].size[2] * flag_2

		if not tbl_7[i] then
			tbl_7[i] = "inventory_entry_root_" .. i
		end

		ui_scenegraph[tbl_7[i]].position[2] = num_2 + num_4 * 0.5
		num_2 = num_2 + num_4 + slot_spacing
	end
end

PlayerInventoryUI.on_inventory_selected_slot_changed = function (self, arg_12_1)
	-- function 12
	if self.selected_index == arg_12_1 then
		return
	end

	local add_animation_for_slot_index = self:add_animation_for_slot_index(arg_12_1, true)

	for i = 1, #weapon_slots do
		if i ~= arg_12_1 then
			self:add_animation_for_slot_index(i, false, add_animation_for_slot_index)
		end
	end

	self.previous_selected_index = self.selected_index
	self.selected_index = arg_12_1

	return true
end

PlayerInventoryUI.add_animation_for_slot_index = function (self, arg_13_1, arg_13_2, arg_13_3)
	-- function 13
	local slot_animations = self.slot_animations
	local ui_scenegraph = self.ui_scenegraph
	local scenegraph_definition = var_0_0.scenegraph_definition

	if not tbl_15[arg_13_1] then
		tbl_15[arg_13_1] = "inventory_entry_" .. arg_13_1
		tbl_16[arg_13_1] = "inventory_entry_icon_" .. arg_13_1
	end

	local var_13_3 = tbl_15[arg_13_1]
	local var_13_4 = tbl_16[arg_13_1]
	local var_13_5 = self.inventory_slots_widgets[arg_13_1]
	local size = ui_scenegraph[var_13_4].size
	local var_13_7 = var_0_0.scenegraph_definition[var_13_4].size[1]
	local select_animation_duration = UISettings.inventory_hud.select_animation_duration
	local flag = arg_13_3 or 0

	if not arg_13_2 then
		if not arg_13_3 then
			flag = (1 - (size[1] - var_13_7) / var_13_7) * select_animation_duration
		end

		self.animating_selected_slot = true
	elseif not arg_13_3 then
		for k, v in pairs(slot_animations) do
			if not v.selected then
				flag = v.total_time - v.time

				break
			end
		end
	end

	local size_2 = ui_scenegraph[var_13_4].size
	local size_3 = var_0_0.scenegraph_definition[var_13_4].size
	local num = size_2[1] / size_3[1]

	if not slot_animations[var_13_3] then
		local var_13_13 = slot_animations[var_13_3]

		var_13_13.total_time = flag
		var_13_13.time = 0
		var_13_13.selected = arg_13_2
		var_13_13.icon_start_size = ui_scenegraph[var_13_4].size
		var_13_13.start_alpha = var_13_5.style.icon.color[1]
		var_13_13.start_selected_alpha = var_13_5.style.background_lit.color[1]
		var_13_13.start_scale_fraction = num

		local flag_2

		flag_2 = not arg_13_2 and 1 and 0.8
		var_13_13.target_scale_fraction = flag_2
	else
		local tbl = {
			time = 0,
			total_time = flag,
			widget = self.inventory_slots_widgets[arg_13_1],
			scenegraph_id = var_13_3,
			start_scale_fraction = num
		}
		local flag_3

		flag_3 = not arg_13_2 and 1 and 0.8
		tbl.target_scale_fraction = flag_3
		tbl.start_size = ui_scenegraph[var_13_4].size
		tbl.start_alpha = var_13_5.style.icon.color[1]
		tbl.start_selected_alpha = var_13_5.style.background_lit.color[1]
		tbl.selected = arg_13_2
		tbl.index = arg_13_1
		slot_animations[var_13_3] = tbl
	end

	return flag
end

PlayerInventoryUI.update_slot_animations = function (self, arg_14_1)
	-- function 14
	local slot_animations = self.slot_animations

	for k, v in pairs(slot_animations) do
		slot_animations[k] = self:animate_slot_widget(v, arg_14_1)
	end
end

PlayerInventoryUI.animate_slot_widget = function (self, arg_15_1, arg_15_2)
	-- function 15
	local ui_scenegraph = self.ui_scenegraph
	local scenegraph_definition = var_0_0.scenegraph_definition
	local widget = arg_15_1.widget
	local total_time = arg_15_1.total_time
	local time = arg_15_1.time
	local selected = arg_15_1.selected
	local index = arg_15_1.index
	local start_size = arg_15_1.start_size
	local start_alpha = arg_15_1.start_alpha
	local start_scale_fraction = arg_15_1.start_scale_fraction
	local target_scale_fraction = arg_15_1.target_scale_fraction
	local start_selected_alpha = arg_15_1.start_selected_alpha
	local content = widget.content
	local style = widget.style
	local inventory_hud = UISettings.inventory_hud
	local num = time + arg_15_2
	local min = math.min(num / total_time, 1)
	local smoothstep = math.smoothstep(min, 0, 1)
	local min_2 = math.min(min * 2, 1)
	local smoothstep_2 = math.smoothstep(min_2, 0, 1)
	local min_3

	if not selected then
		min_3 = math.min(math.max(0, (min - 0.8) / 0.2), 1)

		if not min_3 then
			-- Nothing
		end
	end

	min_3 = math.min(math.max(0, min / 0.2), 1)

	::label_15_0::

	if not tbl_15[index] then
		tbl_15[index] = "inventory_entry_" .. index
		tbl_14[index] = "inventory_entry_background_" .. index
		tbl_16[index] = "inventory_entry_icon_" .. index
	end

	if not tbl_17[index] then
		tbl_17[index] = "inventory_entry_stance_bar_" .. index
		tbl_18[index] = "inventory_entry_stance_bar_fill_" .. index
		tbl_19[index] = "inventory_entry_stance_bar_lit_" .. index
		tbl_20[index] = "inventory_entry_stance_bar_glow_" .. index
	end

	local var_15_21 = tbl_15[index]
	local var_15_22 = tbl_14[index]
	local var_15_23 = tbl_16[index]
	local var_15_24 = tbl_17[index]
	local var_15_25 = tbl_18[index]
	local var_15_26 = tbl_19[index]
	local var_15_27 = tbl_20[index]
	local var_15_28 = ui_scenegraph[var_15_21]
	local var_15_29 = ui_scenegraph[var_15_23]
	local var_15_30 = ui_scenegraph[var_15_22]

	widget.element.dirty = true

	local num_2

	if not selected then
		num_2 = target_scale_fraction - start_scale_fraction

		if not num_2 then
			-- Nothing
		end
	end

	num_2 = start_scale_fraction - target_scale_fraction

	do
		local num_3
	end

	::label_15_1::

	if not selected then
		num_3 = start_scale_fraction + num_2 * smoothstep

		if not num_3 then
			-- Nothing
		end
	end

	num_3 = start_scale_fraction - num_2 * smoothstep

	::label_15_2::

	local size = scenegraph_definition[var_15_23].size

	var_15_29.size[1] = size[1] * num_3
	var_15_29.size[2] = size[2] * num_3

	local size_2 = scenegraph_definition[var_15_22].size

	var_15_30.size[1] = size_2[1] * num_3
	var_15_30.size[2] = size_2[2] * num_3

	local num_4 = 0

	if not selected then
		num_4 = start_selected_alpha + (255 - start_selected_alpha) * smoothstep_2
	else
		num_4 = start_selected_alpha - start_selected_alpha * smoothstep_2
	end

	style.background_lit.color[1] = num_4
	style.background_lit.color[1] = num_4
	style.icon_lit.color[1] = num_4
	style.icon.color[1] = 255 - num_4
	style.stance_bar_lit.color[1] = num_4
	style.stance_bar_fg.color[1] = 255 - num_4

	local var_15_36 = ui_scenegraph[var_15_24]
	local size_3 = scenegraph_definition[var_15_24].size

	var_15_36.size[1] = size_3[1] * num_3
	var_15_36.size[2] = size_3[2] * num_3

	local var_15_38 = ui_scenegraph[var_15_25]
	local var_15_39 = scenegraph_definition[var_15_25]
	local size_4 = var_15_39.size
	local position = var_15_39.position

	var_15_38.size[1] = size_4[1] * num_3
	var_15_38.size[2] = size_4[2] * num_3
	var_15_38.local_position[1] = position[1] * num_3
	var_15_38.local_position[2] = position[2] * num_3
	style.stance_bar.uv_scale_pixels = 67 * num_3

	local var_15_42 = ui_scenegraph[var_15_27]
	local size_5 = scenegraph_definition[var_15_27].size

	var_15_42.size[1] = size_5[1] * num_3
	var_15_42.size[2] = size_5[2] * num_3

	local slot_default_alpha = inventory_hud.slot_default_alpha
	local slot_select_alpha = inventory_hud.slot_select_alpha
	local flag = not selected and slot_select_alpha and slot_default_alpha
	local icon = style.icon

	if icon.color[1] ~= flag then
		local num_5

		if not selected then
			num_5 = flag - start_alpha

			if not num_5 then
				-- Nothing
			end
		end

		num_5 = start_alpha - flag

		do
			local num_6
		end

		::label_15_3::

		if not selected then
			num_6 = start_alpha + num_5 * smoothstep

			if not num_6 then
				-- Nothing
			end
		end

		num_6 = start_alpha - num_5 * smoothstep

		::label_15_4::

		icon.color[1] = num_6

		local ammo_text_1 = style.ammo_text_1
		local stance_bar = style.stance_bar

		if not (not selected and min_3 * flag) then
			local num_7 = (1 - min_3) * slot_select_alpha
		end

		stance_bar.color[1] = num_6
		ammo_text_1.text_color[1] = num_6
	end

	if min < 1 then
		arg_15_1.time = num

		if not (not selected and content.selected or not (min > 0.8)) then
			content.selected = selected
		elseif not ((selected or not widget.content.selected) and min_3 ~= 1) then
			widget.content.selected = selected
		end

		return arg_15_1
	else
		if not selected then
			self.animating_selected_slot = nil
		end

		return nil
	end
end
