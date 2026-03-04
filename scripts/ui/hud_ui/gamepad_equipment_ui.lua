-- chunkname: @scripts/ui/hud_ui/gamepad_equipment_ui.lua

local var_0_0 = local_require("scripts/ui/hud_ui/gamepad_equipment_ui_definitions")
local var_0_1 = var_0_0.scenegraph_definition
local var_0_2 = var_0_0.inventory_slot_backgrounds
local var_0_3 = var_0_0.animations_definitions

GamePadEquipmentUI = class(GamePadEquipmentUI)

local var_0_4 = 2
local var_0_5 = var_0_0.slot_size
local var_0_6 = var_0_0.NUM_SLOTS
local var_0_7 = {
	slot_healthkit = "wield_3",
	slot_grenade = "wield_5",
	slot_potion = "wield_4",
	slot_melee = "wield_1",
	slot_ranged = "wield_2"
}
local var_0_8 = {
	normal = Colors.get_color_table_with_alpha("white", 255),
	empty = Colors.get_color_table_with_alpha("red", 255),
	focus = Colors.get_color_table_with_alpha("font_default", 150),
	unfocused = Colors.get_color_table_with_alpha("font_default", 150)
}

local function var_0_9(arg_1_0, arg_1_1)
	return (arg_1_0.console_hud_index or 0) < (arg_1_1.console_hud_index or 0)
end

local function var_0_10()
	local var_2_0 = Managers.party:get_local_player_party()
	local var_2_1 = Managers.state.side.side_by_party[var_2_0]

	return var_2_1 and var_2_1:name() == "dark_pact"
end

function GamePadEquipmentUI.init(arg_3_0, arg_3_1, arg_3_2)
	arg_3_0._parent = arg_3_1
	arg_3_0.ui_renderer = arg_3_2.ui_renderer
	arg_3_0.ingame_ui = arg_3_2.ingame_ui
	arg_3_0.input_manager = arg_3_2.input_manager
	arg_3_0.peer_id = arg_3_2.peer_id
	arg_3_0.player_manager = arg_3_2.player_manager
	arg_3_0.ui_animations = {}
	arg_3_0._animations = {}
	arg_3_0.render_settings = {
		alpha_multiplier = 1,
		snap_pixel_positions = false
	}
	arg_3_0.is_in_inn = arg_3_2.is_in_inn
	arg_3_0.cleanui = arg_3_2.cleanui
	arg_3_0._retained_elements_visible = false
	arg_3_0.player = arg_3_2.player
	arg_3_0._game_options_dirty = true
	arg_3_0._reload_attempts = 0

	arg_3_0:_create_ui_elements()

	local var_3_0 = Managers.state.event

	var_3_0:register(arg_3_0, "input_changed", "event_input_changed")
	var_3_0:register(arg_3_0, "swap_equipment_from_storage", "event_swap_equipment_from_storage")
	var_3_0:register(arg_3_0, "on_game_options_changed", "_set_game_options_dirty")
	arg_3_0:_update_game_options()
end

function GamePadEquipmentUI._create_ui_elements(arg_4_0)
	arg_4_0.ui_scenegraph = UISceneGraph.init_scenegraph(var_0_1)

	local var_4_0 = {}
	local var_4_1 = {}
	local var_4_2 = {}
	local var_4_3 = {}
	local var_4_4 = {}
	local var_4_5 = {}
	local var_4_6 = {}
	local var_4_7 = {}
	local var_4_8 = {}
	local var_4_9 = {}

	for iter_4_0, iter_4_1 in pairs(var_0_0.widget_definitions) do
		local var_4_10 = UIWidget.init(iter_4_1)

		var_4_1[iter_4_0] = var_4_10
		var_4_9[#var_4_9 + 1] = var_4_10
	end

	for iter_4_2, iter_4_3 in pairs(var_0_0.career_widget_definitions) do
		local var_4_11 = UIWidget.init(iter_4_3)

		var_4_1[iter_4_2] = var_4_11
		var_4_8[iter_4_2] = var_4_11
		var_4_9[#var_4_9 + 1] = var_4_11
	end

	for iter_4_4, iter_4_5 in ipairs(var_0_0.slot_widget_definitions) do
		local var_4_12 = UIWidget.init(iter_4_5)

		var_4_0[iter_4_4] = var_4_12
		var_4_6[iter_4_4] = var_4_12
		var_4_7[iter_4_4] = var_4_12
	end

	for iter_4_6, iter_4_7 in pairs(var_0_0.ammo_widget_definitions) do
		local var_4_13 = UIWidget.init(iter_4_7)

		var_4_4[#var_4_4 + 1] = var_4_13
		var_4_5[iter_4_6] = var_4_13
		var_4_1[iter_4_6] = var_4_13
	end

	for iter_4_8, iter_4_9 in pairs(var_0_0.frame_definitions) do
		local var_4_14 = UIWidget.init(iter_4_9)

		var_4_2[#var_4_2 + 1] = var_4_14
		var_4_3[iter_4_8] = var_4_14
		var_4_1[iter_4_8] = var_4_14
	end

	arg_4_0._widgets = var_4_0
	arg_4_0._widgets_by_name = var_4_1
	arg_4_0._ammo_widgets = var_4_4
	arg_4_0._ammo_widgets_by_name = var_4_5
	arg_4_0._frame_widgets = var_4_2
	arg_4_0._frame_widgets_by_name = var_4_3
	arg_4_0._static_widgets = var_4_9
	arg_4_0._unused_widgets = var_4_6
	arg_4_0._slot_widgets = var_4_7
	arg_4_0._career_widgets = var_4_8
	arg_4_0._ui_animator = UIAnimator:new(arg_4_0.ui_scenegraph, var_0_3)

	local var_4_15 = {}

	for iter_4_10, iter_4_11 in ipairs(var_0_0.extra_storage_icon_definitions) do
		var_4_15[iter_4_10] = UIWidget.init(iter_4_11)
	end

	arg_4_0._extra_storage_icon_widgets = var_4_15
	var_4_1.overcharge_background.style.texture_id.color = {
		100,
		150,
		150,
		150
	}
	var_4_1.overcharge.style.texture_id.color = Colors.get_color_table_with_alpha("font_title", 255)
	arg_4_0._added_items = {}

	UIRenderer.clear_scenegraph_queue(arg_4_0.ui_renderer)
	arg_4_0:event_input_changed()
	arg_4_0:_set_widget_visibility(arg_4_0._ammo_widgets_by_name.reload_tip_text, false)
	arg_4_0:set_visible(true)
	arg_4_0:set_dirty()

	arg_4_0._num_added_items = 0
end

function GamePadEquipmentUI.event_swap_equipment_from_storage(arg_5_0, arg_5_1, arg_5_2)
	if arg_5_1 ~= "slot_grenade" then
		return
	end

	arg_5_0._widgets_by_name.extra_storage_bg.style.texture.color[1] = 163
	arg_5_0._time_fade_storage_slots = Managers.time:time("ui") + 2

	local var_5_0 = arg_5_0._extra_storage_icon_widgets

	for iter_5_0 = 1, #var_5_0 do
		local var_5_1 = var_5_0[iter_5_0]
		local var_5_2 = arg_5_2[iter_5_0]

		if var_5_2 then
			local var_5_3 = var_5_2.gamepad_hud_icon
			local var_5_4 = var_5_1.style
			local var_5_5 = var_5_1.content

			var_5_5.visible = true
			var_5_5.texture_icon = var_5_3
			var_5_5.texture_glow = var_5_3 .. "_glow"
			var_5_4.texture_icon.color[1] = 255

			local var_5_6 = Colors.color_definitions[var_5_2.key] or Colors.color_definitions.black
			local var_5_7 = var_5_4.texture_glow.color

			var_5_7[1] = 255
			var_5_7[2] = var_5_6[2]
			var_5_7[3] = var_5_6[3]
			var_5_7[4] = var_5_6[4]
		else
			var_5_1.content.visible = false
		end
	end
end

function GamePadEquipmentUI.event_input_changed(arg_6_0)
	local var_6_0 = "wield_switch_1"
	local var_6_1 = arg_6_0._widgets_by_name.weapon_slot

	arg_6_0:_set_switch_input(var_6_1, var_6_0)
	arg_6_0:_set_widget_dirty(var_6_1)

	local var_6_2 = "wield_"

	for iter_6_0, iter_6_1 in pairs(arg_6_0._slot_widgets) do
		local var_6_3 = var_6_2 .. iter_6_0 + 2

		arg_6_0:_set_slot_input(iter_6_1, var_6_3)
		arg_6_0:_set_widget_dirty(iter_6_1)
	end

	arg_6_0:set_dirty()
end

function GamePadEquipmentUI._set_switch_input(arg_7_0, arg_7_1, arg_7_2)
	local var_7_0, var_7_1, var_7_2 = arg_7_0:_get_input_texture_data(arg_7_2)

	if not var_7_1 or not UTF8Utils.string_length(var_7_1) then
		local var_7_3 = 0
	end

	local var_7_4 = 40
	local var_7_5 = arg_7_1.style
	local var_7_6 = arg_7_1.content
	local var_7_7 = var_7_5.input_text
	local var_7_8 = arg_7_0.ui_renderer

	var_7_6.input_action = arg_7_2

	if var_7_0 then
		var_7_1 = nil

		local var_7_9

		var_7_6.wield_switch_id, var_7_9 = var_7_0.texture, var_7_0.size
		var_7_6.input_text = ""

		local var_7_10 = var_7_5.wield_switch.texture_size

		var_7_10[1] = var_7_9[1]
		var_7_10[2] = var_7_9[2]
	elseif var_7_1 then
		var_7_6.input_text = UIRenderer.crop_text_width(var_7_8, var_7_1, var_7_4, var_7_7)
		var_7_6.wield_switch_id = nil
	end
end

function GamePadEquipmentUI._set_slot_input(arg_8_0, arg_8_1, arg_8_2)
	local var_8_0, var_8_1, var_8_2 = arg_8_0:_get_input_texture_data(arg_8_2)

	if not var_8_1 or not UTF8Utils.string_length(var_8_1) then
		local var_8_3 = 0
	end

	local var_8_4 = 40
	local var_8_5 = arg_8_1.style
	local var_8_6 = arg_8_1.content
	local var_8_7 = var_8_5.input_text
	local var_8_8 = arg_8_0.ui_renderer

	if var_8_1 then
		var_8_6.input_text = UIRenderer.crop_text_width(var_8_8, var_8_1, var_8_4, var_8_7)
	end
end

function GamePadEquipmentUI._get_input_texture_data(arg_9_0, arg_9_1)
	local var_9_0 = arg_9_0.input_manager
	local var_9_1 = var_9_0:get_service("Player")
	local var_9_2 = var_9_0:is_device_active("gamepad")
	local var_9_3 = PLATFORM

	if IS_WINDOWS and var_9_2 then
		var_9_3 = "xb1"
	elseif IS_XB1 and not var_9_2 then
		var_9_3 = "win32"
	end

	local var_9_4 = var_9_1:get_keymapping(arg_9_1, var_9_3)

	if not var_9_4 then
		Application.warning(string.format("[GamePadEquipmentUI] There is no keymap for %q on %q", arg_9_1, var_9_3))

		return nil, ""
	end

	local var_9_5 = var_9_4[1]
	local var_9_6 = var_9_4[2]
	local var_9_7 = var_9_4[3]
	local var_9_8

	if var_9_7 == "held" then
		var_9_8 = "matchmaking_prefix_hold"
	end

	local var_9_9 = var_9_6 == UNASSIGNED_KEY
	local var_9_10 = ""

	if var_9_5 == "keyboard" then
		local var_9_11 = var_9_9 and "" or Keyboard.button_locale_name(var_9_6) or Keyboard.button_name(var_9_6)

		if IS_XB1 then
			var_9_11 = string.upper(var_9_11)
		end

		return nil, var_9_11, var_9_8
	elseif var_9_5 == "mouse" then
		local var_9_12 = var_9_9 and "" or Mouse.button_name(var_9_6)

		return nil, var_9_12, var_9_8
	elseif var_9_5 == "gamepad" then
		local var_9_13 = var_9_9 and "" or Pad1.button_name(var_9_6)

		if UISettings.use_ps4_input_icons and IS_WINDOWS then
			var_9_3 = "win32_ps4"
		end

		return ButtonTextureByName(var_9_13, var_9_3), var_9_13, var_9_8
	end

	return nil, ""
end

function GamePadEquipmentUI._update_widgets(arg_10_0)
	local var_10_0 = arg_10_0._slot_widgets

	for iter_10_0, iter_10_1 in ipairs(var_10_0) do
		arg_10_0:_set_widget_dirty(iter_10_1)
	end

	arg_10_0:set_dirty()
end

function GamePadEquipmentUI._get_wield_scroll_input(arg_11_0)
	local var_11_0 = arg_11_0.player
	local var_11_1 = var_11_0.player_unit

	if not var_11_1 then
		return
	end

	local var_11_2 = var_11_0:network_id()

	return ScriptUnit.extension(var_11_1, "input_system"):get_last_scroll_value()
end

function GamePadEquipmentUI._set_wielded_item(arg_12_0, arg_12_1, arg_12_2)
	local var_12_0 = arg_12_0:_get_wield_scroll_input()
	local var_12_1 = arg_12_0._added_items

	for iter_12_0, iter_12_1 in ipairs(var_12_1) do
		local var_12_2 = iter_12_1.item_name == arg_12_0._wielded_item_name
		local var_12_3 = iter_12_1.item_name == arg_12_1
		local var_12_4 = iter_12_1.widget

		var_12_4.content.selected = var_12_3

		local var_12_5 = iter_12_1.slot_name

		if var_12_3 then
			local var_12_6 = var_12_5 == "slot_ranged"

			arg_12_0:_set_ammo_text_focus(var_12_6)
			arg_12_0:_add_animation(var_12_5 .. "_wield_anim", var_12_4, var_12_4, "_animate_slot_wield")
		elseif var_12_2 then
			arg_12_0:_add_animation(var_12_5 .. "_wield_anim", var_12_4, var_12_4, "_animate_slot_unwield")
		end

		iter_12_1.is_wielded = var_12_3
	end

	arg_12_0._wielded_item_name = arg_12_1
end

local var_0_11 = {
	slot_grenade = true,
	slot_healthkit = true,
	slot_potion = true,
	slot_melee = false,
	slot_ranged = false
}
local var_0_12 = {}
local var_0_13 = {}
local var_0_14 = {}

function GamePadEquipmentUI._update_equipment_lookup(arg_13_0, arg_13_1, arg_13_2)
	arg_13_0._equipment_lookup = arg_13_0._equipment_lookup or {}
	arg_13_0._equipment_lookup.additional_items_lookup = arg_13_0._equipment_lookup.additional_items_lookup or {}

	local var_13_0 = arg_13_0._equipment_lookup

	var_13_0.wielded_slot = arg_13_1.wielded_slot

	local var_13_1 = var_13_0.additional_items_lookup
	local var_13_2 = arg_13_2:get_additional_items_table()
	local var_13_3
	local var_13_4 = arg_13_1.slots

	for iter_13_0, iter_13_1 in pairs(var_0_11) do
		local var_13_5 = var_13_4[iter_13_0] and arg_13_2:get_item_template(var_13_4[iter_13_0])

		var_13_0[iter_13_0] = var_13_5 and var_13_5.name

		local var_13_6 = var_13_2 and var_13_2[iter_13_0]

		if var_13_6 then
			local var_13_7 = var_13_6.items[1]

			var_13_1[iter_13_0] = var_13_7 and var_13_7.key
		else
			var_13_1[iter_13_0] = nil
		end
	end

	local var_13_8 = var_13_4.slot_ranged

	if var_13_8 and var_13_8.item_data then
		local var_13_9 = BackendUtils.get_item_template(var_13_8.item_data)
		local var_13_10, var_13_11, var_13_12 = arg_13_0:_get_ammunition_count(var_13_8.left_unit_1p, var_13_8.right_unit_1p, var_13_9)

		var_13_0.ammo_count = var_13_10
		var_13_0.remaining_ammo = var_13_11
	end

	local var_13_13 = var_13_4.slot_grenade

	if var_13_13 and var_13_13.item_data then
		var_13_0.grenade_count = arg_13_2:get_total_item_count("slot_grenade")
	end
end

function GamePadEquipmentUI._check_equipment_changed(arg_14_0, arg_14_1, arg_14_2)
	if not arg_14_0._equipment_lookup then
		arg_14_0:_update_equipment_lookup(arg_14_1, arg_14_2)

		return true
	end

	if arg_14_0._equipment_lookup.wielded_slot ~= arg_14_1.wielded_slot then
		arg_14_0:_update_equipment_lookup(arg_14_1, arg_14_2)

		return true
	end

	local var_14_0
	local var_14_1
	local var_14_2
	local var_14_3 = arg_14_1.slots
	local var_14_4 = arg_14_2:get_additional_items_table()
	local var_14_5 = arg_14_0._equipment_lookup
	local var_14_6 = var_14_5.additional_items_lookup

	for iter_14_0, iter_14_1 in pairs(var_0_11) do
		local var_14_7 = var_14_3[iter_14_0]
		local var_14_8 = var_14_7 and arg_14_2:get_item_template(var_14_7)

		if (var_14_8 and var_14_8.name) ~= var_14_5[iter_14_0] then
			arg_14_0:_update_equipment_lookup(arg_14_1, arg_14_2)

			return true
		end

		local var_14_9 = var_14_4[iter_14_0]

		if var_14_9 then
			local var_14_10 = var_14_9.items[1]
			local var_14_11 = var_14_10 and var_14_10.key

			if var_14_6[iter_14_0] ~= var_14_11 then
				arg_14_0:_update_equipment_lookup(arg_14_1, arg_14_2)

				return true
			end
		end
	end

	local var_14_12 = var_14_3.slot_ranged

	if var_14_12 and var_14_12.item_data then
		local var_14_13 = BackendUtils.get_item_template(var_14_12.item_data)
		local var_14_14, var_14_15, var_14_16 = arg_14_0:_get_ammunition_count(var_14_12.left_unit_1p, var_14_12.right_unit_1p, var_14_13)

		if var_14_5.ammo_count ~= var_14_14 then
			arg_14_0:_update_equipment_lookup(arg_14_1, arg_14_2)

			return true
		end

		if var_14_5.remaining_ammo ~= var_14_15 then
			arg_14_0:_update_equipment_lookup(arg_14_1, arg_14_2)

			return true
		end
	end

	local var_14_17 = var_14_3.slot_grenade

	if var_14_17 and var_14_17.item_data and arg_14_2:has_additional_item_slots("slot_grenade") then
		local var_14_18 = arg_14_2:get_total_item_count("slot_grenade")

		if var_14_5.grenade_count ~= var_14_18 then
			arg_14_0:_update_equipment_lookup(arg_14_1, arg_14_2)

			return true
		end
	end

	return false
end

function GamePadEquipmentUI._sync_player_equipment(arg_15_0)
	local var_15_0 = Managers.input:is_device_active("gamepad")
	local var_15_1 = UISettings.use_gamepad_hud_layout

	if var_15_1 == "never" or var_15_1 == "auto" and not var_15_0 then
		return
	end

	local var_15_2 = arg_15_0.player
	local var_15_3 = var_15_2.player_unit

	if not var_15_3 then
		return
	end

	local var_15_4 = var_15_2:network_id()
	local var_15_5 = ScriptUnit.extension(var_15_3, "inventory_system")
	local var_15_6 = var_15_5:equipment()

	if not var_15_6 then
		return
	end

	if not arg_15_0:_check_equipment_changed(var_15_6, var_15_5) then
		return
	end

	table.clear(var_0_14)

	local var_15_7 = false
	local var_15_8
	local var_15_9 = var_15_6.slots
	local var_15_10 = var_15_6.wielded
	local var_15_11 = InventorySettings.slots
	local var_15_12 = #var_15_11
	local var_15_13 = arg_15_0._added_items

	for iter_15_0 = 1, var_15_12 do
		local var_15_14 = var_15_11[iter_15_0].name
		local var_15_15 = var_15_9[var_15_14]
		local var_15_16

		var_15_16 = var_15_15 and true or false

		local var_15_17 = var_15_15 and var_15_15.item_data
		local var_15_18 = var_15_17 and var_15_17.name
		local var_15_19 = var_15_18 and var_15_10 == var_15_17 or false

		if var_15_19 then
			local var_15_20 = var_15_17.slot_type
			local var_15_21 = arg_15_0._widgets_by_name.weapon_slot
			local var_15_22 = var_15_21.content
			local var_15_23 = var_15_21.style

			var_15_22.wielded_slot = var_15_20

			if arg_15_0._wielded_slot_name ~= var_15_14 then
				if var_15_20 == "melee" or var_15_20 == "ranged" then
					arg_15_0._weapon_was_wielded = true

					arg_15_0:_add_animation("weapon_slot", var_15_21, var_15_21, "_animate_weapon_wield", 1)
				elseif arg_15_0._weapon_was_wielded then
					arg_15_0._weapon_was_wielded = false

					arg_15_0:_add_animation("weapon_slot", var_15_21, var_15_21, "_animate_weapon_unwield", 4)
				end
			end

			arg_15_0._wielded_slot_name = var_15_14
		end

		if var_0_11[var_15_14] then
			local var_15_24 = 0
			local var_15_25 = false

			for iter_15_1 = 1, #var_15_13 do
				local var_15_26 = var_15_13[iter_15_1]
				local var_15_27 = var_15_26.item_name == var_15_18
				local var_15_28 = var_15_26.slot_name == var_15_14

				if var_15_28 then
					var_15_24 = iter_15_1
				end

				if var_15_27 then
					if not var_0_14[iter_15_1] then
						var_15_25 = true
						var_0_14[iter_15_1] = true

						break
					end
				elseif var_15_18 and var_15_28 then
					var_15_25 = true
					var_0_14[iter_15_1] = true

					arg_15_0:_add_item(var_15_15, var_15_26)

					var_15_24 = iter_15_1
					var_15_7 = true

					break
				end
			end

			if not var_15_25 and var_15_15 ~= nil then
				arg_15_0:_add_item(var_15_15)

				var_15_24 = #var_15_13
				var_0_14[#var_15_13] = true
				var_15_7 = true
			end

			if var_15_19 then
				var_15_8 = var_15_18
			end

			if var_15_14 == "slot_grenade" and var_15_17 and var_15_24 > 0 then
				local var_15_29 = var_15_5:has_additional_item_slots(var_15_14)
				local var_15_30 = var_15_5:get_total_item_count(var_15_14)
				local var_15_31 = var_15_13[var_15_24]
				local var_15_32 = var_15_31 and var_15_31.widget

				if var_15_32 then
					local var_15_33 = var_15_32.content
					local var_15_34 = var_15_5:get_total_item_count(var_15_14)

					if var_15_33.item_count ~= var_15_34 then
						var_15_33.item_count = var_15_34
						var_15_33.use_count_text = "x" .. var_15_34
						var_15_33.has_additional_slots = var_15_29

						arg_15_0:_set_widget_dirty(var_15_32)
					end

					local var_15_35 = var_15_5:can_swap_from_storage(var_15_14, SwapFromStorageType.Unique)

					if var_15_33.can_swap ~= var_15_35 then
						var_15_33.can_swap = var_15_35

						arg_15_0:_set_widget_dirty(var_15_32)
					end
				end
			elseif var_15_14 == "slot_potion" and var_15_17 and var_15_24 > 0 then
				local var_15_36 = var_15_13[var_15_24]
				local var_15_37 = var_15_36 and var_15_36.widget

				if var_15_37 then
					local var_15_38 = var_15_37.content
					local var_15_39 = var_15_37.style
					local var_15_40 = var_15_5:get_additional_items(var_15_14)

					if var_15_40 then
						local var_15_41 = var_15_40[1]

						if var_15_41 then
							local var_15_42 = var_15_41.gamepad_hud_icon

							var_15_38.secondary_texture_icon = var_15_42
							var_15_38.secondary_texture_icon_glow = var_15_42 .. "_glow"

							local var_15_43 = UISettings.inventory_consumable_slot_colors
							local var_15_44 = {
								255,
								0,
								0,
								0
							}
							local var_15_45 = {
								255,
								255,
								255,
								255
							}
							local var_15_46 = var_15_43[var_15_41.key]

							if var_15_46 then
								var_15_39.secondary_texture_icon.color = var_15_46
								var_15_39.secondary_texture_icon_glow.color = {
									255,
									0,
									0,
									0
								}
							else
								var_15_39.secondary_texture_icon.color = var_15_44
								var_15_39.secondary_texture_icon_glow.color = var_15_45
							end

							arg_15_0:_set_widget_dirty(var_15_37)
						else
							var_15_38.secondary_texture_icon = nil
							var_15_38.secondary_texture_icon_glow = nil

							arg_15_0:_set_widget_dirty(var_15_37)
						end
					else
						var_15_38.secondary_texture_icon = nil
						var_15_38.secondary_texture_icon_glow = nil

						arg_15_0:_set_widget_dirty(var_15_37)
					end
				end
			end
		else
			if var_15_14 == "slot_ranged" and var_15_17 then
				arg_15_0:_update_ammo_count(var_15_17, var_15_15, var_15_3)
				arg_15_0:_set_ammo_text_focus(var_15_19)
			end

			if var_15_19 then
				var_15_8 = var_15_18
			end
		end
	end

	table.clear(var_0_13)

	for iter_15_2 = 1, #var_15_13 do
		if not var_0_14[iter_15_2] then
			var_0_13[#var_0_13 + 1] = iter_15_2
		end
	end

	local var_15_47 = 0

	for iter_15_3 = 1, #var_0_13 do
		local var_15_48 = var_0_13[iter_15_3] - var_15_47

		arg_15_0:_remove_item(var_15_48)

		var_15_47 = var_15_47 + 1
		var_15_7 = true
	end

	if var_15_7 then
		arg_15_0:_update_widgets()
		table.sort(var_15_13, var_0_9)
	end

	if var_15_8 and arg_15_0._wielded_item_name ~= var_15_8 or var_15_7 then
		var_15_8 = var_15_8 or arg_15_0._wielded_item_name

		arg_15_0:_set_wielded_item(var_15_8, var_15_7)
	end
end

function GamePadEquipmentUI._update_ammo_count(arg_16_0, arg_16_1, arg_16_2, arg_16_3)
	local var_16_0 = BackendUtils.get_item_template(arg_16_1)
	local var_16_1 = arg_16_0._ammo_widgets_by_name
	local var_16_2 = false

	if var_16_0.ammo_data then
		local var_16_3, var_16_4, var_16_5 = arg_16_0:_get_ammunition_count(arg_16_2.left_unit_1p, arg_16_2.right_unit_1p, var_16_0)
		local var_16_6 = var_16_1.ammo_text_clip.content
		local var_16_7 = var_16_3 + var_16_4 == 0
		local var_16_8 = false

		if arg_16_0._ammo_count ~= var_16_3 then
			arg_16_0._ammo_count = var_16_3

			local var_16_9 = var_16_1.ammo_text_clip

			var_16_9.content.text = tostring(var_16_3)

			arg_16_0:_set_widget_dirty(var_16_9)

			var_16_8 = true
		end

		if arg_16_0._remaining_ammo ~= var_16_4 then
			arg_16_0._remaining_ammo = var_16_4

			local var_16_10 = var_16_1.ammo_text_remaining

			var_16_10.content.text = tostring(var_16_4)

			arg_16_0:_set_widget_dirty(var_16_10)

			var_16_8 = true
		end

		if var_16_8 then
			arg_16_0._ammo_counter_fade_delay = var_0_4
			arg_16_0._ammo_counter_fade_progress = 1

			arg_16_0:_set_ammo_counter_alpha(255)

			local var_16_11 = var_16_7 and var_0_8.empty or var_0_8.normal

			arg_16_0:_set_ammo_counter_color(var_16_11)
			arg_16_0:set_dirty()
		end
	else
		local var_16_12, var_16_13, var_16_14 = arg_16_0:_get_overcharge_amount(arg_16_3)

		if arg_16_0._overcharge_fraction ~= var_16_13 then
			arg_16_0._overcharge_fraction = var_16_13

			arg_16_0:_set_overheat_fraction(var_16_13)
		end

		var_16_2 = true
	end

	if arg_16_0._draw_overheat ~= var_16_2 then
		arg_16_0._draw_overheat = var_16_2

		arg_16_0:_show_overheat_meter(var_16_2)
	end
end

function GamePadEquipmentUI._animate_ammo_counter(arg_17_0, arg_17_1)
	local var_17_0 = arg_17_0._ammo_counter_fade_delay

	if var_17_0 then
		local var_17_1 = math.max(var_17_0 - arg_17_1, 0)

		if var_17_1 == 0 then
			arg_17_0._ammo_counter_fade_delay = nil
		else
			arg_17_0._ammo_counter_fade_delay = var_17_1
		end

		return
	end

	local var_17_2 = arg_17_0._ammo_counter_fade_progress

	if not var_17_2 then
		return
	end

	local var_17_3 = math.max(var_17_2 - 0.01, 0)
	local var_17_4 = 100 + 155 * var_17_3

	arg_17_0:_set_ammo_counter_alpha(var_17_4)

	if var_17_3 == 0 then
		arg_17_0._ammo_counter_fade_progress = nil
	else
		arg_17_0._ammo_counter_fade_progress = var_17_3
	end

	return true
end

function GamePadEquipmentUI._set_ammo_counter_alpha(arg_18_0, arg_18_1)
	local var_18_0 = arg_18_0._ammo_widgets_by_name
	local var_18_1 = var_18_0.ammo_text_clip

	var_18_1.style.text.text_color[1] = arg_18_1

	arg_18_0:_set_widget_dirty(var_18_1)

	local var_18_2 = var_18_0.ammo_text_remaining

	var_18_2.style.text.text_color[1] = arg_18_1

	arg_18_0:_set_widget_dirty(var_18_2)

	local var_18_3 = var_18_0.ammo_text_center

	var_18_3.style.text.text_color[1] = arg_18_1

	arg_18_0:_set_widget_dirty(var_18_3)
	arg_18_0:set_dirty()
end

function GamePadEquipmentUI._set_ammo_counter_color(arg_19_0, arg_19_1)
	local var_19_0 = arg_19_0._ammo_widgets_by_name.ammo_text_clip
	local var_19_1 = var_19_0.style.text.text_color

	var_19_1[2] = arg_19_1[2]
	var_19_1[3] = arg_19_1[3]
	var_19_1[4] = arg_19_1[4]

	arg_19_0:_set_widget_dirty(var_19_0)

	local var_19_2 = arg_19_0._ammo_widgets_by_name.ammo_text_remaining
	local var_19_3 = var_19_2.style.text.text_color

	var_19_3[2] = arg_19_1[2]
	var_19_3[3] = arg_19_1[3]
	var_19_3[4] = arg_19_1[4]

	arg_19_0:_set_widget_dirty(var_19_2)

	local var_19_4 = arg_19_0._ammo_widgets_by_name.ammo_text_center
	local var_19_5 = var_19_4.style.text.text_color

	var_19_5[2] = arg_19_1[2]
	var_19_5[3] = arg_19_1[3]
	var_19_5[4] = arg_19_1[4]

	arg_19_0:_set_widget_dirty(var_19_4)
	arg_19_0:set_dirty()
end

function GamePadEquipmentUI._set_ammo_text_focus(arg_20_0, arg_20_1)
	if arg_20_0._draw_overheat and arg_20_0._overcharge_fraction ~= nil then
		local var_20_0 = 1
		local var_20_1 = arg_20_1 and var_0_8.focus or var_0_8.unfocused
		local var_20_2 = arg_20_0._widgets_by_name
		local var_20_3 = var_20_2.overcharge
		local var_20_4 = var_20_2.overcharge_background
		local var_20_5 = var_20_3.style.texture_id.color
		local var_20_6 = var_20_4.style.texture_id.color

		var_20_5[2] = var_20_1[2] * var_20_0
		var_20_5[3] = var_20_1[3] * var_20_0
		var_20_5[4] = var_20_1[4] * var_20_0

		arg_20_0:_set_widget_dirty(var_20_3)
		arg_20_0:_set_widget_dirty(var_20_4)
		arg_20_0:set_dirty()
	end

	arg_20_0._ammo_dirty = true
end

function GamePadEquipmentUI._get_ammunition_count(arg_21_0, arg_21_1, arg_21_2, arg_21_3)
	local var_21_0

	if not arg_21_3.ammo_data then
		return
	end

	local var_21_1 = arg_21_3.ammo_data.ammo_hand

	if var_21_1 == "right" then
		var_21_0 = ScriptUnit.extension(arg_21_2, "ammo_system")
	elseif var_21_1 == "left" then
		var_21_0 = ScriptUnit.extension(arg_21_1, "ammo_system")
	else
		return
	end

	local var_21_2 = var_21_0:ammo_count()
	local var_21_3 = var_21_0:remaining_ammo()
	local var_21_4 = var_21_0:using_single_clip()

	return var_21_2, var_21_3, var_21_4
end

function GamePadEquipmentUI._get_overcharge_amount(arg_22_0, arg_22_1)
	local var_22_0 = ScriptUnit.extension(arg_22_1, "overcharge_system")
	local var_22_1 = var_22_0:overcharge_fraction()
	local var_22_2 = var_22_0:threshold_fraction()
	local var_22_3 = var_22_0:get_anim_blend_overcharge()

	return true, var_22_1, var_22_2, var_22_3
end

function GamePadEquipmentUI._add_animation(arg_23_0, arg_23_1, arg_23_2, arg_23_3, arg_23_4, arg_23_5)
	local var_23_0 = arg_23_0._animations
	local var_23_1 = UISettings.inventory_hud
	local var_23_2 = arg_23_5 or var_23_1.equip_animation_duration
	local var_23_3 = var_23_0[arg_23_1]

	if var_23_3 then
		var_23_3.total_time = var_23_2
		var_23_3.time = 0
		var_23_3.func = arg_23_4
	else
		var_23_0[arg_23_1] = {
			time = 0,
			total_time = var_23_2,
			style = arg_23_3,
			widget = arg_23_2,
			func = arg_23_4
		}
	end
end

function GamePadEquipmentUI._update_animations(arg_24_0, arg_24_1, arg_24_2)
	local var_24_0 = arg_24_0._time_fade_storage_slots

	if var_24_0 then
		local var_24_1 = math.clamp(var_24_0 - arg_24_2, 0, 1)
		local var_24_2 = arg_24_0._extra_storage_icon_widgets

		for iter_24_0 = 1, #var_24_2 do
			local var_24_3 = var_24_2[iter_24_0].style

			var_24_3.texture_icon.color[1] = 255 * var_24_1
			var_24_3.texture_glow.color[1] = 128 * var_24_1
		end

		local var_24_4 = arg_24_0._widgets_by_name.extra_storage_bg

		var_24_4.style.texture.color[1] = 189 * var_24_1

		arg_24_0:_set_widget_dirty(var_24_4)

		if var_24_1 == 0 then
			arg_24_0._time_fade_storage_slots = nil
		end
	end

	local var_24_5 = arg_24_0._animations
	local var_24_6 = false

	for iter_24_1, iter_24_2 in pairs(var_24_5) do
		var_24_5[iter_24_1] = arg_24_0[iter_24_2.func](arg_24_0, iter_24_2, arg_24_1)

		local var_24_7 = iter_24_2.widget

		arg_24_0:_set_widget_dirty(var_24_7)

		var_24_6 = true
	end

	return var_24_6
end

function GamePadEquipmentUI._animate_weapon_wield(arg_25_0, arg_25_1, arg_25_2)
	local var_25_0 = arg_25_1.widget
	local var_25_1 = arg_25_1.total_time
	local var_25_2 = arg_25_1.time + arg_25_2
	local var_25_3 = math.min(var_25_2 / var_25_1, 1)
	local var_25_4 = math.easeInCubic(var_25_3)
	local var_25_5 = math.easeOutCubic(var_25_3)

	var_25_0.style.melee_weapon_texture.color[2] = 255 - 192 * var_25_4
	var_25_0.style.melee_weapon_texture.color[3] = 255 - 192 * var_25_4
	var_25_0.style.melee_weapon_texture.color[4] = 255 - 192 * var_25_4
	var_25_0.style.ranged_weapon_texture.color[2] = 255 - 192 * var_25_4
	var_25_0.style.ranged_weapon_texture.color[3] = 255 - 192 * var_25_4
	var_25_0.style.ranged_weapon_texture.color[4] = 255 - 192 * var_25_4
	var_25_0.style.melee_weapon_texture_glow.color[1] = 255 - 255 * var_25_5
	var_25_0.style.ranged_weapon_texture_glow.color[1] = 255 - 255 * var_25_5
	arg_25_1.time = var_25_2

	return var_25_3 < 1 and arg_25_1 or nil
end

function GamePadEquipmentUI._animate_weapon_unwield(arg_26_0, arg_26_1, arg_26_2)
	local var_26_0 = arg_26_1.widget
	local var_26_1 = arg_26_1.total_time
	local var_26_2 = arg_26_1.time + arg_26_2
	local var_26_3 = math.min(var_26_2 / var_26_1, 1)
	local var_26_4 = math.easeInCubic(1 - var_26_3)
	local var_26_5 = math.easeOutCubic(var_26_3)

	var_26_0.style.highlight_weapon_texture.color[1] = 255 * var_26_4
	arg_26_1.time = var_26_2

	return var_26_3 < 1 and arg_26_1 or nil
end

function GamePadEquipmentUI._animate_slot_wield(arg_27_0, arg_27_1, arg_27_2)
	local var_27_0 = arg_27_1.widget
	local var_27_1 = arg_27_1.total_time
	local var_27_2 = arg_27_1.time + arg_27_2
	local var_27_3 = math.min(var_27_2 / var_27_1, 1)
	local var_27_4 = math.easeOutCubic(var_27_3)
	local var_27_5 = math.easeInCubic(1 - var_27_3)

	var_27_0.style.texture_icon.color[2] = 128 + 127 * var_27_4
	var_27_0.style.texture_icon.color[3] = 128 + 127 * var_27_4
	var_27_0.style.texture_icon.color[4] = 128 + 127 * var_27_4
	var_27_0.style.texture_selected.color[1] = 255 * var_27_4
	var_27_0.style.texture_selected_left_arrow_glow.color[1] = 255 * var_27_4
	var_27_0.style.texture_selected_up_arrow_glow.color[1] = 255 * var_27_4
	var_27_0.style.texture_selected_right_arrow_glow.color[1] = 255 * var_27_4
	var_27_0.style.texture_selected_left_arrow.color[2] = 128 + 127 * var_27_4
	var_27_0.style.texture_selected_left_arrow.color[3] = 128 + 127 * var_27_4
	var_27_0.style.texture_selected_left_arrow.color[4] = 128 + 127 * var_27_4
	var_27_0.style.texture_selected_up_arrow.color[2] = 128 + 127 * var_27_4
	var_27_0.style.texture_selected_up_arrow.color[3] = 128 + 127 * var_27_4
	var_27_0.style.texture_selected_up_arrow.color[4] = 128 + 127 * var_27_4
	var_27_0.style.texture_selected_right_arrow.color[2] = 128 + 127 * var_27_4
	var_27_0.style.texture_selected_right_arrow.color[3] = 128 + 127 * var_27_4
	var_27_0.style.texture_selected_right_arrow.color[4] = 128 + 127 * var_27_4
	arg_27_1.time = var_27_2

	return var_27_3 < 1 and arg_27_1 or nil
end

function GamePadEquipmentUI._animate_slot_unwield(arg_28_0, arg_28_1, arg_28_2)
	local var_28_0 = arg_28_1.widget
	local var_28_1 = arg_28_1.total_time
	local var_28_2 = arg_28_1.time + arg_28_2
	local var_28_3 = math.min(var_28_2 / var_28_1, 1)
	local var_28_4 = math.easeInCubic(1 - var_28_3)
	local var_28_5 = math.easeOutCubic(var_28_3)

	if var_28_0.content.is_filled then
		var_28_0.style.texture_icon.color[2] = 128 + 127 * var_28_4
		var_28_0.style.texture_icon.color[3] = 128 + 127 * var_28_4
		var_28_0.style.texture_icon.color[4] = 128 + 127 * var_28_4
	else
		var_28_0.style.texture_icon.color[1] = 255 * var_28_4
		var_28_0.style.texture_icon.color[2] = 128 + 127 * var_28_4
		var_28_0.style.texture_icon.color[3] = 128 + 127 * var_28_4
		var_28_0.style.texture_icon.color[4] = 128 + 127 * var_28_4
	end

	var_28_0.style.texture_selected.color[1] = 255 * var_28_4
	var_28_0.style.texture_selected_left_arrow_glow.color[1] = 255 * var_28_4
	var_28_0.style.texture_selected_up_arrow_glow.color[1] = 255 * var_28_4
	var_28_0.style.texture_selected_right_arrow_glow.color[1] = 255 * var_28_4
	var_28_0.style.texture_selected_left_arrow.color[2] = 128 + 127 * var_28_4
	var_28_0.style.texture_selected_left_arrow.color[3] = 128 + 127 * var_28_4
	var_28_0.style.texture_selected_left_arrow.color[4] = 128 + 127 * var_28_4
	var_28_0.style.texture_selected_up_arrow.color[2] = 128 + 127 * var_28_4
	var_28_0.style.texture_selected_up_arrow.color[3] = 128 + 127 * var_28_4
	var_28_0.style.texture_selected_up_arrow.color[4] = 128 + 127 * var_28_4
	var_28_0.style.texture_selected_right_arrow.color[2] = 128 + 127 * var_28_4
	var_28_0.style.texture_selected_right_arrow.color[3] = 128 + 127 * var_28_4
	var_28_0.style.texture_selected_right_arrow.color[4] = 128 + 127 * var_28_4
	arg_28_1.time = var_28_2

	return var_28_3 < 1 and arg_28_1 or nil
end

function GamePadEquipmentUI._add_item(arg_29_0, arg_29_1, arg_29_2)
	local var_29_0 = arg_29_0._num_added_items or 0
	local var_29_1 = arg_29_2 ~= nil

	if not var_29_1 and var_29_0 >= var_0_6 then
		return
	end

	local var_29_2 = arg_29_1.id
	local var_29_3 = InventorySettings.slots_by_name[var_29_2].console_hud_index
	local var_29_4

	if var_29_1 then
		var_29_4 = arg_29_2.widget
	else
		for iter_29_0, iter_29_1 in ipairs(arg_29_0._slot_widgets) do
			if iter_29_1.content.console_hud_index == var_29_3 then
				var_29_4 = iter_29_1

				break
			end
		end

		UIRenderer.set_element_visible(arg_29_0.ui_renderer, var_29_4.element, true)
	end

	local var_29_5 = var_29_4.content
	local var_29_6 = var_29_4.style
	local var_29_7 = var_29_5.normal_color

	var_29_5.is_filled = true

	local var_29_8 = arg_29_1.item_data
	local var_29_9 = var_29_8.name
	local var_29_10 = var_29_8.gamepad_hud_icon
	local var_29_11

	if var_29_2 == "slot_melee" then
		var_29_10 = "hud_icon_melee"
	elseif var_29_2 == "slot_ranged" then
		var_29_10 = "hud_icon_ranged"
	elseif var_29_10 then
		var_29_11 = var_29_10 .. "_glow"
	end

	local var_29_12 = UISettings.inventory_consumable_slot_colors
	local var_29_13 = var_29_12.default
	local var_29_14 = var_29_12[var_29_9] or var_29_13
	local var_29_15 = var_29_6.texture_selected.color

	var_29_15[2] = var_29_14[2]
	var_29_15[3] = var_29_14[3]
	var_29_15[4] = var_29_14[4]

	local var_29_16 = var_29_6.texture_selected_left_arrow_glow.color

	var_29_16[2] = var_29_14[2]
	var_29_16[3] = var_29_14[3]
	var_29_16[4] = var_29_14[4]

	local var_29_17 = var_29_6.texture_selected_up_arrow_glow.color

	var_29_17[2] = var_29_14[2]
	var_29_17[3] = var_29_14[3]
	var_29_17[4] = var_29_14[4]

	local var_29_18 = var_29_6.texture_selected_right_arrow_glow.color

	var_29_18[2] = var_29_14[2]
	var_29_18[3] = var_29_14[3]
	var_29_18[4] = var_29_14[4]
	var_29_5.texture_icon = var_29_10 or "icons_placeholder"
	var_29_5.texture_selected = var_29_11 or "icons_placeholder"
	var_29_6.texture_icon.color[1] = 255
	var_29_6.texture_selected_left_arrow.color[1] = 255
	var_29_6.texture_selected_up_arrow.color[1] = 255
	var_29_6.texture_selected_right_arrow.color[1] = 255
	var_29_6.texture_empty_slot.color[1] = 0
	arg_29_2 = arg_29_2 or {}
	arg_29_2.console_hud_index = var_29_3
	arg_29_2.slot_name = var_29_2
	arg_29_2.item_name = var_29_9
	arg_29_2.widget = var_29_4
	arg_29_2.wielded = false
	arg_29_2.icon = var_29_10

	if not var_29_1 then
		local var_29_19 = arg_29_0._added_items

		table.insert(var_29_19, #var_29_19 + 1, arg_29_2)

		arg_29_0._num_added_items = var_29_0 + 1
	end
end

function GamePadEquipmentUI._remove_item(arg_30_0, arg_30_1)
	local var_30_0 = arg_30_0._num_added_items or 0

	if var_30_0 <= 0 then
		return
	end

	local var_30_1 = arg_30_0._added_items
	local var_30_2 = table.remove(var_30_1, arg_30_1)
	local var_30_3 = var_30_2.slot_name
	local var_30_4 = var_30_2.widget
	local var_30_5 = var_30_4.content
	local var_30_6 = var_30_4.style

	var_30_5.is_filled = false
	var_30_6.texture_icon.color[1] = 0
	var_30_6.texture_arrow_left.color[1] = 0
	var_30_6.texture_arrow_up.color[1] = 0
	var_30_6.texture_arrow_right.color[1] = 0
	var_30_6.texture_empty_slot.color[1] = 128

	local var_30_7 = var_30_5.selected

	var_30_5.selected = false

	local var_30_8 = UISettings.inventory_consumable_slot_colors.default
	local var_30_9 = var_30_6.texture_background.color

	var_30_9[1] = 0
	var_30_9[2] = var_30_8[2]
	var_30_9[3] = var_30_8[3]
	var_30_9[4] = var_30_8[4]
	arg_30_0._num_added_items = var_30_0 - 1

	if var_30_7 then
		arg_30_0:_add_animation(var_30_3 .. "_wield_anim", var_30_4, var_30_4, "_animate_slot_unwield")
	else
		var_30_4.style.texture_selected.color[1] = 0
	end
end

function GamePadEquipmentUI.set_position(arg_31_0, arg_31_1, arg_31_2)
	local var_31_0 = arg_31_0.ui_scenegraph.pivot.local_position

	var_31_0[1] = arg_31_1
	var_31_0[2] = arg_31_2

	for iter_31_0, iter_31_1 in ipairs(arg_31_0._widgets) do
		arg_31_0:_set_widget_dirty(iter_31_1)
	end

	for iter_31_2, iter_31_3 in ipairs(arg_31_0._static_widgets) do
		arg_31_0:_set_widget_dirty(iter_31_3)
	end

	arg_31_0:set_dirty()
end

function GamePadEquipmentUI.destroy(arg_32_0)
	local var_32_0 = Managers.state.event

	var_32_0:unregister("input_changed", arg_32_0)
	var_32_0:unregister("swap_equipment_from_storage", arg_32_0)
	var_32_0:unregister("on_game_options_changed", arg_32_0)

	arg_32_0._ui_animator = nil

	arg_32_0:set_visible(false)
	print("[GamePadEquipmentUI] - Destroy")
end

function GamePadEquipmentUI.set_visible(arg_33_0, arg_33_1)
	arg_33_0._is_visible = arg_33_1

	arg_33_0:_set_elements_visible(arg_33_1)
end

function GamePadEquipmentUI._set_elements_visible(arg_34_0, arg_34_1)
	local var_34_0 = arg_34_0.ui_renderer

	for iter_34_0, iter_34_1 in ipairs(arg_34_0._widgets) do
		UIRenderer.set_element_visible(var_34_0, iter_34_1.element, arg_34_1)
	end

	for iter_34_2, iter_34_3 in ipairs(arg_34_0._static_widgets) do
		UIRenderer.set_element_visible(var_34_0, iter_34_3.element, arg_34_1)
	end

	for iter_34_4, iter_34_5 in ipairs(arg_34_0._ammo_widgets) do
		UIRenderer.set_element_visible(var_34_0, iter_34_5.element, arg_34_1)
	end

	for iter_34_6, iter_34_7 in ipairs(arg_34_0._frame_widgets) do
		UIRenderer.set_element_visible(var_34_0, iter_34_7.element, arg_34_1)
	end

	arg_34_0._retained_elements_visible = arg_34_1

	arg_34_0:set_dirty()
end

function GamePadEquipmentUI.update(arg_35_0, arg_35_1, arg_35_2)
	local var_35_0 = false

	arg_35_0:_update_game_options()

	local var_35_1, var_35_2 = arg_35_0._parent:get_crosshair_position()

	if arg_35_0:_apply_crosshair_position(var_35_1, var_35_2) then
		var_35_0 = true
	end

	if arg_35_0:_update_animations(arg_35_1, arg_35_2) then
		var_35_0 = true
	end

	if arg_35_0:_animate_ammo_counter(arg_35_1) then
		var_35_0 = true
	end

	if var_35_0 then
		arg_35_0:set_dirty()
	end

	arg_35_0:_handle_resolution_modified()
	arg_35_0:_sync_player_equipment()
	arg_35_0:_show_hold_to_reload(arg_35_2)
	arg_35_0:_handle_gamepad_activity()
	arg_35_0:draw(arg_35_1)
	arg_35_0._ui_animator:update(arg_35_1)
end

function GamePadEquipmentUI._handle_career_change(arg_36_0)
	local var_36_0 = arg_36_0._career_name
	local var_36_1 = Managers.player:local_player()
	local var_36_2 = var_36_1 and var_36_1.player_unit

	if not ALIVE[var_36_2] then
		return
	end

	arg_36_0._career_name = ScriptUnit.extension(var_36_2, "career_system"):career_name()

	if arg_36_0._career_name ~= var_36_0 then
		for iter_36_0, iter_36_1 in pairs(arg_36_0._career_widgets) do
			iter_36_1.content.visible = true

			arg_36_0:_set_widget_dirty(iter_36_1)
		end

		return true
	end
end

function GamePadEquipmentUI._handle_resolution_modified(arg_37_0)
	if RESOLUTION_LOOKUP.modified then
		arg_37_0:_on_resolution_modified()
	end
end

function GamePadEquipmentUI._on_resolution_modified(arg_38_0)
	for iter_38_0, iter_38_1 in ipairs(arg_38_0._widgets) do
		arg_38_0:_set_widget_dirty(iter_38_1)
	end

	for iter_38_2, iter_38_3 in ipairs(arg_38_0._static_widgets) do
		arg_38_0:_set_widget_dirty(iter_38_3)
	end

	for iter_38_4, iter_38_5 in pairs(arg_38_0._frame_widgets) do
		arg_38_0:_set_widget_dirty(iter_38_5)
	end

	arg_38_0:set_dirty()
end

function GamePadEquipmentUI._handle_gamepad_activity(arg_39_0)
	local var_39_0 = Managers.input:is_device_active("gamepad")
	local var_39_1 = Managers.input:get_most_recent_device()
	local var_39_2 = arg_39_0.gamepad_active_last_frame == nil or var_39_0 and var_39_1 ~= arg_39_0._most_recent_device

	if var_39_0 or IS_PS4 then
		if not arg_39_0.gamepad_active_last_frame or var_39_2 then
			arg_39_0.gamepad_active_last_frame = true

			arg_39_0:_update_gamepad_input_button()
			arg_39_0:event_input_changed()
		end
	elseif arg_39_0.gamepad_active_last_frame or var_39_2 then
		arg_39_0.gamepad_active_last_frame = false

		arg_39_0:_update_gamepad_input_button()
		arg_39_0:event_input_changed()
	end

	arg_39_0._most_recent_device = var_39_1
end

function GamePadEquipmentUI._set_game_options_dirty(arg_40_0)
	arg_40_0._game_options_dirty = true
end

function GamePadEquipmentUI._update_game_options(arg_41_0)
	if not arg_41_0._game_options_dirty then
		return
	end

	arg_41_0:_update_gamepad_input_button()
	arg_41_0:event_input_changed()

	arg_41_0._game_options_dirty = false
end

function GamePadEquipmentUI._update_gamepad_input_button(arg_42_0)
	local var_42_0 = Managers.input:get_service("Player")
	local var_42_1 = "weapon_reload_input"
	local var_42_2 = true
	local var_42_3, var_42_4, var_42_5, var_42_6 = UISettings.get_gamepad_input_texture_data(var_42_0, var_42_1, var_42_2)
	local var_42_7 = arg_42_0._widgets_by_name.engineer_base
	local var_42_8 = var_42_7.style
	local var_42_9 = var_42_7.content
	local var_42_10 = Managers.input:is_device_active("gamepad")

	if var_42_3 and var_42_10 then
		var_42_9.reload_button_id = var_42_3.texture
		var_42_9.input_text = ""

		local var_42_11 = var_42_8.reload_button.texture_size
		local var_42_12 = var_42_3.size

		var_42_11[1] = var_42_12[1]
		var_42_11[2] = var_42_12[2]
	else
		local var_42_13 = 40
		local var_42_14 = "weapon_reload"
		local var_42_15 = var_42_0:get_keymapping(var_42_14, "win32")

		if not var_42_15 then
			var_42_9.input_text = UIRenderer.crop_text_width(arg_42_0.ui_renderer, Localize("unassigned_keymap"), var_42_13, input_style)
		else
			local var_42_16 = var_42_15[1]
			local var_42_17 = var_42_15[2]
			local var_42_18 = var_42_8.input_text
			local var_42_19 = ""

			if var_42_17 ~= UNASSIGNED_KEY then
				local var_42_20 = var_42_16 == "mouse" and Mouse or Keyboard

				var_42_19 = var_42_20.button_locale_name(var_42_17) or var_42_20.button_name(var_42_17) or Localize("lb_unknown")
			end

			var_42_9.input_text = UIRenderer.crop_text_width(arg_42_0.ui_renderer, var_42_19, var_42_13, var_42_18)
		end
	end
end

function GamePadEquipmentUI._handle_gamepad(arg_43_0)
	if (not (Managers.input:is_device_active("gamepad") or not IS_WINDOWS) or UISettings.use_gamepad_hud_layout == "never") and UISettings.use_gamepad_hud_layout ~= "always" then
		if arg_43_0._retained_elements_visible then
			arg_43_0:_set_elements_visible(false)
		end

		return false
	else
		if not arg_43_0._retained_elements_visible then
			arg_43_0:_set_elements_visible(true)
			arg_43_0:event_input_changed()
		end

		return true
	end
end

function GamePadEquipmentUI.draw(arg_44_0, arg_44_1)
	if not arg_44_0._is_visible then
		return
	end

	local var_44_0 = arg_44_0:_handle_gamepad()

	if not var_44_0 then
		return
	end

	if not (arg_44_0:_handle_career_change() or var_44_0) then
		return
	end

	local var_44_1 = arg_44_0.ui_renderer
	local var_44_2 = arg_44_0.ui_scenegraph
	local var_44_3 = arg_44_0.input_manager:get_service("ingame_menu")
	local var_44_4 = arg_44_0.render_settings
	local var_44_5 = var_44_4.alpha_multiplier

	UIRenderer.begin_pass(var_44_1, var_44_2, var_44_3, arg_44_1, nil, var_44_4)

	var_44_4.snap_pixel_positions = true
	var_44_4.alpha_multiplier = arg_44_0.panel_alpha_multiplier or var_44_5

	for iter_44_0, iter_44_1 in ipairs(arg_44_0._slot_widgets) do
		UIRenderer.draw_widget(var_44_1, iter_44_1)
	end

	for iter_44_2, iter_44_3 in ipairs(arg_44_0._extra_storage_icon_widgets) do
		UIRenderer.draw_widget(var_44_1, iter_44_3)
	end

	var_44_4.snap_pixel_positions = true

	for iter_44_4, iter_44_5 in ipairs(arg_44_0._static_widgets) do
		UIRenderer.draw_widget(var_44_1, iter_44_5)
	end

	var_44_4.snap_pixel_positions = true

	for iter_44_6, iter_44_7 in ipairs(arg_44_0._ammo_widgets) do
		UIRenderer.draw_widget(var_44_1, iter_44_7)
	end

	var_44_4.alpha_multiplier = arg_44_0.frame_alpha_multiplier or var_44_5
	var_44_4.snap_pixel_positions = true

	for iter_44_8, iter_44_9 in ipairs(arg_44_0._frame_widgets) do
		UIRenderer.draw_widget(var_44_1, iter_44_9)
	end

	UIRenderer.end_pass(var_44_1)

	arg_44_0._dirty = false
	arg_44_0._ammo_dirty = false
end

function GamePadEquipmentUI._set_color(arg_45_0, arg_45_1, arg_45_2, arg_45_3)
	if not arg_45_3 then
		arg_45_1[1] = arg_45_2[1]
	end

	arg_45_1[2] = arg_45_2[2]
	arg_45_1[3] = arg_45_2[3]
	arg_45_1[4] = arg_45_2[4]
end

function GamePadEquipmentUI.set_dirty(arg_46_0)
	arg_46_0._dirty = true

	if arg_46_0.cleanui then
		arg_46_0.cleanui.dirty = true
	end
end

function GamePadEquipmentUI._set_widget_dirty(arg_47_0, arg_47_1)
	arg_47_1.element.dirty = true

	if arg_47_0.cleanui then
		arg_47_0.cleanui.dirty = true
	end
end

function GamePadEquipmentUI._set_overheat_fraction(arg_48_0, arg_48_1)
	local var_48_0 = arg_48_0._widgets_by_name.overcharge

	var_48_0.content.texture_id.uvs[2][1] = arg_48_1

	local var_48_1 = var_48_0.scenegraph_id
	local var_48_2 = arg_48_0.ui_scenegraph[var_48_1]
	local var_48_3 = var_0_1[var_48_1].size

	var_48_2.size[1] = var_48_3[1] * arg_48_1

	arg_48_0:_set_widget_dirty(var_48_0)
	arg_48_0:set_dirty()
end

function GamePadEquipmentUI._show_overheat_meter(arg_49_0, arg_49_1)
	local var_49_0 = arg_49_0._widgets_by_name
	local var_49_1 = arg_49_0._ammo_widgets_by_name

	arg_49_0:_set_widget_visibility(var_49_0.overcharge, false)
	arg_49_0:_set_widget_visibility(var_49_0.overcharge_background, false)
	arg_49_0:_set_widget_visibility(var_49_1.ammo_text_clip, not arg_49_1)
	arg_49_0:_set_widget_visibility(var_49_1.ammo_text_remaining, not arg_49_1)
	arg_49_0:_set_widget_visibility(var_49_1.ammo_text_center, not arg_49_1)
	arg_49_0:set_dirty()
end

function GamePadEquipmentUI._set_widget_visibility(arg_50_0, arg_50_1, arg_50_2)
	arg_50_1.content.visible = arg_50_2

	arg_50_0:_set_widget_dirty(arg_50_1)
end

function GamePadEquipmentUI.set_alpha(arg_51_0, arg_51_1)
	arg_51_0.render_settings.alpha_multiplier = arg_51_1

	for iter_51_0, iter_51_1 in pairs(arg_51_0._widgets) do
		arg_51_0:_set_widget_dirty(iter_51_1)
	end

	for iter_51_2, iter_51_3 in pairs(arg_51_0._slot_widgets) do
		arg_51_0:_set_widget_dirty(iter_51_3)
	end

	for iter_51_4, iter_51_5 in pairs(arg_51_0._static_widgets) do
		arg_51_0:_set_widget_dirty(iter_51_5)
	end

	for iter_51_6, iter_51_7 in pairs(arg_51_0._ammo_widgets) do
		arg_51_0:_set_widget_dirty(iter_51_7)
	end

	for iter_51_8, iter_51_9 in pairs(arg_51_0._frame_widgets) do
		arg_51_0:_set_widget_dirty(iter_51_9)
	end

	arg_51_0:set_dirty()
end

function GamePadEquipmentUI.set_ammo_alpha(arg_52_0, arg_52_1)
	arg_52_0.ammo_alpha_multiplier = arg_52_1

	for iter_52_0, iter_52_1 in pairs(arg_52_0._ammo_widgets) do
		arg_52_0:_set_widget_dirty(iter_52_1)
	end

	arg_52_0:set_dirty()
end

function GamePadEquipmentUI.set_frame_alpha(arg_53_0, arg_53_1)
	arg_53_0.frame_alpha_multiplier = arg_53_1

	for iter_53_0, iter_53_1 in pairs(arg_53_0._frame_widgets) do
		arg_53_0:_set_widget_dirty(iter_53_1)
	end

	arg_53_0:set_dirty()
end

function GamePadEquipmentUI.set_panel_alpha(arg_54_0, arg_54_1)
	arg_54_0.panel_alpha_multiplier = arg_54_1

	for iter_54_0, iter_54_1 in pairs(arg_54_0._widgets) do
		arg_54_0:_set_widget_dirty(iter_54_1)
	end

	for iter_54_2, iter_54_3 in pairs(arg_54_0._slot_widgets) do
		arg_54_0:_set_widget_dirty(iter_54_3)
	end

	for iter_54_4, iter_54_5 in pairs(arg_54_0._static_widgets) do
		arg_54_0:_set_widget_dirty(iter_54_5)
	end

	for iter_54_6, iter_54_7 in pairs(arg_54_0._ammo_widgets) do
		arg_54_0:_set_widget_dirty(iter_54_7)
	end

	arg_54_0:set_dirty()
end

function GamePadEquipmentUI._apply_crosshair_position(arg_55_0, arg_55_1, arg_55_2)
	local var_55_0 = "screen_bottom_pivot"
	local var_55_1 = arg_55_0.ui_scenegraph[var_55_0].local_position
	local var_55_2 = false

	if var_55_1[1] ~= arg_55_1 or var_55_1[2] ~= arg_55_2 then
		var_55_2 = true
	end

	var_55_1[1] = arg_55_1
	var_55_1[2] = arg_55_2

	if var_55_2 then
		local var_55_3 = arg_55_0._widgets_by_name
		local var_55_4 = arg_55_0._ammo_widgets_by_name

		arg_55_0:_set_widget_dirty(var_55_4.ammo_text_clip)
		arg_55_0:_set_widget_dirty(var_55_4.ammo_text_remaining)
		arg_55_0:_set_widget_dirty(var_55_4.ammo_text_center)
		arg_55_0:_set_widget_dirty(var_55_3.overcharge)
		arg_55_0:_set_widget_dirty(var_55_3.overcharge_background)
	end

	return var_55_2
end

function GamePadEquipmentUI._show_hold_to_reload(arg_56_0, arg_56_1)
	local var_56_0 = Managers.input:is_device_active("gamepad")

	if (not var_56_0 or UISettings.use_gamepad_hud_layout == "never") and UISettings.use_gamepad_hud_layout ~= "always" then
		return
	end

	local var_56_1 = (arg_56_0._is_spectator and arg_56_0._spectated_player or arg_56_0.player).player_unit

	if not var_56_1 then
		return
	end

	local var_56_2 = ScriptUnit.extension(var_56_1, "inventory_system"):equipment()
	local var_56_3 = var_56_2.wielded_slot
	local var_56_4 = false
	local var_56_5
	local var_56_6
	local var_56_7

	for iter_56_0, iter_56_1 in pairs(var_56_2.slots) do
		local var_56_8 = iter_56_1.item_data
		local var_56_9 = BackendUtils.get_item_template(var_56_8)

		if iter_56_1.id == var_56_3 and var_56_9.ammo_data and var_56_9.ammo_data.unique_ammo_type then
			var_56_5 = iter_56_1
			var_56_6 = var_56_8
			var_56_7 = var_56_9
			var_56_4 = true
		end
	end

	if not var_56_6 or not var_56_5 or not var_56_7 then
		return
	end

	local var_56_10, var_56_11, var_56_12 = arg_56_0:_get_ammunition_count(var_56_5.left_unit_1p, var_56_5.right_unit_1p, var_56_7)
	local var_56_13 = var_56_0 and "weapon_reload_hold_input" or "weapon_reload_hold"
	local var_56_14 = arg_56_0._ammo_widgets_by_name.reload_tip_text
	local var_56_15, var_56_16, var_56_17 = arg_56_0:_get_input_texture_data(var_56_13)
	local var_56_18 = var_56_14.style.text.text_color[1]
	local var_56_19 = string.format("{#color(193,91,36, %d)}", var_56_18)
	local var_56_20 = var_56_0 and string.format("$KEY;Player__%s:", var_56_13) or var_56_16

	var_56_14.content.text = string.format(Localize("reload_tip"), var_56_19, var_56_20, "{#reset()}")

	local var_56_21 = var_56_10 + var_56_11 == var_56_7.ammo_data.max_ammo

	if var_56_4 and not var_56_21 then
		if arg_56_0._reload_attempts >= 3 then
			arg_56_0._reload_tip_text_shown = true

			if not arg_56_0._reload_tip_anim or arg_56_0._ui_animator:is_animation_completed(arg_56_0._reload_tip_anim) then
				arg_56_0._reload_tip_anim = arg_56_0._ui_animator:start_animation("show_reload_tip", var_56_14, var_0_1)
			end
		end

		arg_56_0:_update_reload_ui_state(arg_56_1, var_56_7)
	end

	arg_56_0:_set_widget_dirty(var_56_14)
end

function GamePadEquipmentUI._update_reload_ui_state(arg_57_0, arg_57_1, arg_57_2)
	if not arg_57_0._ammo_widgets_by_name.reload_tip_text then
		return
	end

	local var_57_0 = Managers.input:get_service("Player")
	local var_57_1 = 5
	local var_57_2 = (Managers.input:is_device_active("gamepad") or not IS_WINDOWS) and "weapon_reload_hold_input" or "weapon_reload_hold"

	if var_57_0:get(var_57_2) then
		if not arg_57_0._ui_animator:is_animation_completed(arg_57_0._reload_tip_anim) then
			return
		end

		if not arg_57_0._listening_timer_start then
			arg_57_0._listening_timer_start = arg_57_1
		end

		if not arg_57_0._reload_start_time then
			arg_57_0._reload_start_time = arg_57_1
		end
	else
		local var_57_3 = arg_57_2.actions.weapon_reload.default.anim_time_scale

		if arg_57_0._reload_start_time and var_57_3 > arg_57_1 - arg_57_0._reload_start_time then
			arg_57_0._reload_attempts = arg_57_0._reload_attempts + 1
		end

		if arg_57_0._reload_start_time then
			arg_57_0._reload_start_time = nil
		end
	end

	local var_57_4 = 0

	if arg_57_0._listening_timer_start then
		var_57_4 = arg_57_0._listening_timer_start + var_57_1
	end

	if var_57_4 ~= 0 and var_57_4 < arg_57_1 or arg_57_0._reload_tip_text_shown then
		arg_57_0._listening_timer_start = nil
		arg_57_0._reload_attempts = 0
		arg_57_0._reload_tip_text_shown = false
	end
end
