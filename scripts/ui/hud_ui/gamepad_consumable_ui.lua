-- chunkname: @scripts/ui/hud_ui/gamepad_consumable_ui.lua

local var_0_0 = local_require("scripts/ui/hud_ui/gamepad_consumable_ui_definitions")
local var_0_1 = var_0_0.animations
local var_0_2 = var_0_0.scenegraph_definition
local var_0_3 = InventorySettings.weapon_slots
local var_0_4 = {
	slot_healthkit = 4,
	slot_grenade = 1,
	slot_potion = 2
}
local var_0_5 = {
	slot_healthkit = "consumables_medpack",
	slot_grenade = "consumables_frag",
	slot_potion = "consumables_potion_01"
}
local var_0_6 = {
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
local var_0_7 = 5

hud_icon_texture_lit_lookup_table = {}
GamepadConsumableUI = class(GamepadConsumableUI)

function GamepadConsumableUI.init(arg_1_0, arg_1_1)
	arg_1_0.platform = PLATFORM
	arg_1_0.ui_renderer = arg_1_1.ui_renderer
	arg_1_0.ingame_ui = arg_1_1.ingame_ui
	arg_1_0.input_manager = arg_1_1.input_manager
	arg_1_0.peer_id = arg_1_1.peer_id
	arg_1_0.player_manager = arg_1_1.player_manager
	arg_1_0.render_settings = {
		snap_pixel_positions = true
	}
	arg_1_0.ui_animations = {}

	arg_1_0:_create_ui_elements()
end

function GamepadConsumableUI._create_ui_elements(arg_2_0)
	arg_2_0.ui_scenegraph = UISceneGraph.init_scenegraph(var_0_2)
	arg_2_0.selection_widget = UIWidget.init(var_0_0.widget_definitions.selection)
	arg_2_0.background_widget = UIWidget.init(var_0_0.widget_definitions.background)

	local var_2_0 = {}
	local var_2_1 = {}

	for iter_2_0, iter_2_1 in pairs(var_0_6) do
		local var_2_2 = UIWidget.init(var_0_0.widget_definitions[iter_2_0])

		var_2_2.content.texture_icon = iter_2_1[1]
		var_2_0[#var_2_0 + 1] = var_2_2
		var_2_1[iter_2_0] = var_2_2
	end

	arg_2_0.slot_widgets = var_2_0
	arg_2_0.slot_widgets_by_name = var_2_1

	UIRenderer.clear_scenegraph_queue(arg_2_0.ui_renderer)

	arg_2_0.ui_animator = UIAnimator:new(arg_2_0.ui_scenegraph, var_0_1)

	arg_2_0:_align_widgets()
	arg_2_0:_set_dirty()
end

function GamepadConsumableUI.destroy(arg_3_0)
	arg_3_0.ui_animator = nil

	arg_3_0:set_visible(false)
end

function GamepadConsumableUI.set_visible(arg_4_0, arg_4_1)
	local var_4_0 = arg_4_0.input_manager:is_device_active("gamepad")

	if arg_4_1 and not var_4_0 then
		return
	end

	arg_4_0._is_visible = arg_4_1

	local var_4_1 = arg_4_0.ui_renderer

	for iter_4_0, iter_4_1 in ipairs(arg_4_0.slot_widgets) do
		UIRenderer.set_element_visible(var_4_1, iter_4_1.element, arg_4_1)
	end

	UIRenderer.set_element_visible(var_4_1, arg_4_0.selection_widget.element, arg_4_1)
end

function GamepadConsumableUI.update(arg_5_0, arg_5_1, arg_5_2, arg_5_3)
	if arg_5_0.input_manager:is_device_active("gamepad") then
		if not arg_5_0.gamepad_active_last_frame then
			arg_5_0.gamepad_active_last_frame = true

			arg_5_0:on_gamepad_activated()
		end
	elseif arg_5_0.gamepad_active_last_frame then
		arg_5_0.gamepad_active_last_frame = false

		arg_5_0:on_gamepad_deactivated()
	end

	if RESOLUTION_LOOKUP.modified then
		for iter_5_0, iter_5_1 in ipairs(arg_5_0.slot_widgets) do
			arg_5_0:_set_widget_dirty(iter_5_1)
		end

		arg_5_0:_set_dirty()
	end

	arg_5_0:_update_extension_changes(arg_5_1, arg_5_3)

	local var_5_0 = arg_5_0.ui_animator

	var_5_0:update(arg_5_1)

	local var_5_1 = arg_5_0.ui_animations

	for iter_5_2, iter_5_3 in ipairs(var_5_1) do
		if var_5_0:is_animation_completed(iter_5_3) then
			var_5_0:stop_animation(iter_5_3)

			var_5_1[iter_5_2] = nil
		end

		arg_5_0:_set_dirty()
	end

	arg_5_0:_draw(arg_5_1)

	arg_5_0._dirty = nil
end

local function var_0_8(arg_6_0, arg_6_1, arg_6_2)
	local var_6_0

	if not arg_6_2.ammo_data then
		return
	end

	local var_6_1 = arg_6_2.ammo_data.ammo_hand

	if var_6_1 == "right" then
		var_6_0 = ScriptUnit.extension(arg_6_1, "ammo_system")
	elseif var_6_1 == "left" then
		var_6_0 = ScriptUnit.extension(arg_6_0, "ammo_system")
	else
		return
	end

	local var_6_2 = var_6_0:ammo_count()
	local var_6_3 = var_6_0:remaining_ammo()

	return var_6_2, var_6_3
end

function GamepadConsumableUI._draw(arg_7_0, arg_7_1)
	if not arg_7_0._is_visible then
		return
	end

	local var_7_0 = arg_7_0.ui_renderer
	local var_7_1 = arg_7_0.ui_scenegraph
	local var_7_2 = arg_7_0.input_manager:get_service("ingame_menu")

	UIRenderer.begin_pass(var_7_0, var_7_1, var_7_2, arg_7_1, nil, arg_7_0.render_settings)

	for iter_7_0, iter_7_1 in ipairs(arg_7_0.slot_widgets) do
		UIRenderer.draw_widget(var_7_0, iter_7_1)
	end

	if arg_7_0._draw_selection then
		UIRenderer.draw_widget(var_7_0, arg_7_0.selection_widget)
	end

	UIRenderer.draw_widget(var_7_0, arg_7_0.background_widget)
	UIRenderer.end_pass(var_7_0)
end

function GamepadConsumableUI._set_dirty(arg_8_0)
	arg_8_0._dirty = true
end

function GamepadConsumableUI._set_widget_dirty(arg_9_0, arg_9_1)
	arg_9_1.element.dirty = true
end

function GamepadConsumableUI._update_extension_changes(arg_10_0, arg_10_1, arg_10_2)
	if not arg_10_2 then
		return
	end

	local var_10_0 = false
	local var_10_1 = arg_10_0.slot_widgets_by_name
	local var_10_2 = arg_10_2:get_selected_consumable_slot_name()
	local var_10_3 = arg_10_2:equipment()

	for iter_10_0, iter_10_1 in ipairs(var_0_3) do
		local var_10_4 = false
		local var_10_5 = iter_10_1.name
		local var_10_6 = var_10_3.slots[var_10_5]
		local var_10_7 = var_10_1[var_10_5]

		if var_10_7 then
			local var_10_8 = var_10_7.content

			if not var_10_6 then
				if arg_10_0:_reset_slot_widget(var_10_7, var_10_5, iter_10_0) then
					var_10_4 = true
				end
			else
				if not var_10_8.has_data then
					var_10_8.has_data = true
					var_10_4 = true
				end

				local var_10_9 = var_10_6.item_data
				local var_10_10 = var_10_2 == var_10_5
				local var_10_11 = arg_10_0:_update_slot_icon(var_10_7, var_10_9, var_10_10)
				local var_10_12 = arg_10_0:_update_slot_ammo(var_10_7, var_10_6, var_10_9, var_10_10)

				if var_10_8.wielded ~= var_10_10 then
					var_10_8.wielded = var_10_10
					var_10_4 = true

					if var_10_10 then
						arg_10_0:_on_slot_selected(var_10_7)
					end
				end

				if var_10_12 or var_10_11 then
					var_10_4 = true
				end
			end

			if var_10_4 then
				var_10_0 = true

				arg_10_0:_set_widget_dirty(var_10_7)
			end
		end
	end

	if not var_10_2 then
		arg_10_0:_clear_selection()
	end

	if var_10_0 then
		arg_10_0:_set_dirty()
	end
end

function GamepadConsumableUI._on_slot_selected(arg_11_0, arg_11_1)
	local var_11_0 = arg_11_0.ui_renderer
	local var_11_1 = arg_11_1.offset
	local var_11_2 = arg_11_0.selection_widget
	local var_11_3 = var_11_2.offset

	var_11_3[1] = var_11_1[1]
	var_11_3[2] = var_11_1[2]

	arg_11_0:_set_widget_dirty(var_11_2)

	arg_11_0._draw_selection = true

	UIRenderer.set_element_visible(var_11_0, var_11_2.element, true)
end

function GamepadConsumableUI._clear_selection(arg_12_0)
	local var_12_0 = arg_12_0.ui_renderer
	local var_12_1 = arg_12_0.selection_widget

	UIRenderer.set_element_visible(var_12_0, var_12_1.element, false)
	arg_12_0:_set_widget_dirty(var_12_1)

	arg_12_0._draw_selection = nil
end

function GamepadConsumableUI._update_slot_icon(arg_13_0, arg_13_1, arg_13_2, arg_13_3)
	local var_13_0 = false
	local var_13_1 = arg_13_1.style
	local var_13_2 = arg_13_1.content
	local var_13_3 = arg_13_2 and arg_13_2.hud_icon or var_0_5[slot_name]

	if not hud_icon_texture_lit_lookup_table[var_13_3] then
		hud_icon_texture_lit_lookup_table[var_13_3] = var_13_3 .. "_lit"
	end

	if var_13_2.texture_icon ~= var_13_3 then
		var_13_0 = true
		var_13_2.texture_icon = var_13_3

		local var_13_4 = arg_13_2 and arg_13_2.name or "no_master_item_found"

		assert(var_13_2.texture_icon, "No hud icon for weapon %s", var_13_4)

		var_13_2.texture_icon_lit = hud_icon_texture_lit_lookup_table[var_13_3]

		local var_13_5 = var_13_1.texture_icon.color
		local var_13_6 = var_13_1.texture_icon_lit.color

		var_13_1.texture_bg.color[1] = 150
		var_13_5[1] = 255
		var_13_6[1] = 255
	end

	return var_13_0
end

function GamepadConsumableUI._update_slot_ammo(arg_14_0, arg_14_1, arg_14_2, arg_14_3, arg_14_4)
	local var_14_0 = false
	local var_14_1 = arg_14_1.content
	local var_14_2 = BackendUtils.get_item_template(arg_14_3)
	local var_14_3, var_14_4 = var_0_8(arg_14_2.left_unit_1p, arg_14_2.right_unit_1p, var_14_2)
	local var_14_5 = var_14_2 and var_14_2.ammo_data

	if var_14_5 and var_14_3 and not var_14_5.hide_ammo_ui then
		local var_14_6 = var_14_3 + var_14_4

		if var_14_6 > 1 and var_14_1.total_ammo ~= var_14_6 then
			var_14_1.text_ammo = "x" .. tostring(var_14_3 + var_14_4)
			var_14_1.total_ammo = var_14_6
			var_14_1.show_ammo = true
			var_14_0 = true
		end
	elseif var_14_1.show_ammo then
		var_14_1.show_ammo = false
		var_14_0 = true
	end

	return var_14_0
end

function GamepadConsumableUI._reset_slot_widget(arg_15_0, arg_15_1, arg_15_2, arg_15_3)
	local var_15_0 = false
	local var_15_1 = arg_15_1.content

	if var_15_1.has_data then
		var_15_1.has_data = nil
		var_15_0 = true

		if arg_15_2 == "slot_healthkit" then
			-- block empty
		end

		if var_15_1.show_ammo then
			var_15_1.show_ammo = false
			var_15_1.ammo_text_1 = ""
			var_15_1.ammo_text_2 = ""
		end

		local var_15_2 = var_0_6[arg_15_2]

		if var_15_1.texture_icon ~= var_15_2[1] then
			local var_15_3 = 50
			local var_15_4 = arg_15_1.style

			var_15_1.texture_icon = var_15_2[1]
			var_15_1.texture_icon_lit = var_15_2[2]
			var_15_1.wielded = false

			local var_15_5 = var_15_4.texture_icon.color
			local var_15_6 = var_15_4.texture_icon_lit.color

			var_15_4.texture_bg.color[1] = 100
			var_15_5[1] = var_15_3
			var_15_6[1] = var_15_3
		end
	end

	return var_15_0
end

function GamepadConsumableUI._change_heal_other_slot_state(arg_16_0, arg_16_1)
	local var_16_0 = arg_16_0.slot_widgets

	if arg_16_1 == "active" then
		local var_16_1 = var_16_0[3]
		local var_16_2 = var_16_1.content

		if not var_16_2.has_data or var_16_2.wielded then
			var_16_2.wielded = false
			var_16_2.has_data = true
			var_16_1.style.texture_icon.color[1] = 255
			var_16_1.style.texture_icon_lit.color[1] = 255
			var_16_1.element.dirty = true
		end
	elseif arg_16_1 == "wielded" then
		local var_16_3 = var_16_0[3]
		local var_16_4 = var_16_3.content

		if not var_16_4.wielded then
			var_16_4.wielded = true
			var_16_4.has_data = true
			var_16_3.style.texture_icon.color[1] = 255
			var_16_3.style.texture_icon_lit.color[1] = 255
			var_16_3.element.dirty = true
		end
	elseif arg_16_1 == "reset" then
		local var_16_5 = var_16_0[3]
		local var_16_6 = var_16_5.content

		if var_16_6.has_data then
			var_16_6.wielded = false
			var_16_6.has_data = false
			var_16_5.style.texture_icon.color[1] = 50
			var_16_5.style.texture_icon_lit.color[1] = 50
			var_16_5.element.dirty = true
		end
	end
end

function GamepadConsumableUI._animate_slot_fill(arg_17_0, arg_17_1, arg_17_2)
	local var_17_0 = {}
	local var_17_1 = {
		arg_17_1
	}
	local var_17_2 = arg_17_0.ui_animations

	var_17_2[#var_17_2 + 1] = arg_17_0.ui_animator:start_animation("pickup", var_17_1, var_0_2, var_17_0)
end

function GamepadConsumableUI._align_widgets(arg_18_0)
	local var_18_0 = arg_18_0.slot_widgets
	local var_18_1 = 63
	local var_18_2 = 0
	local var_18_3 = 0

	for iter_18_0, iter_18_1 in ipairs(var_18_0) do
		local var_18_4 = iter_18_1.style

		iter_18_1.offset[1] = var_18_3
		var_18_3 = var_18_3 + var_18_1 + var_18_2
	end
end

function GamepadConsumableUI._update_slot_positions(arg_19_0)
	local var_19_0 = arg_19_0.ui_scenegraph
	local var_19_1 = UISettings.inventory_hud.slot_spacing
	local var_19_2 = 0.9
	local var_19_3 = arg_19_0.slot_widgets
	local var_19_4 = #var_19_3
	local var_19_5 = 0

	for iter_19_0 = var_19_4, 1, -1 do
		local var_19_6 = var_19_3[iter_19_0]
		local var_19_7 = var_19_6.style.texture_bg
		local var_19_8 = var_19_7.offset
		local var_19_9 = var_19_7.size
		local var_19_10 = var_19_6.offset
		local var_19_11 = var_19_9[1] * var_19_2

		var_19_10[1] = var_19_5 + var_19_11 * 0.5
		var_19_5 = var_19_5 + var_19_11 + var_19_1
		var_19_6.element.dirty = true
	end

	arg_19_0:_set_dirty()
end

function GamepadConsumableUI.on_gamepad_activated(arg_20_0)
	arg_20_0:set_visible(true)
	arg_20_0:_set_dirty()
end

function GamepadConsumableUI.on_gamepad_deactivated(arg_21_0)
	arg_21_0:set_visible(false)
	arg_21_0:_set_dirty()
end
