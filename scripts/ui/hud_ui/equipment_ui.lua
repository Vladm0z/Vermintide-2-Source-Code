-- chunkname: @scripts/ui/hud_ui/equipment_ui.lua

local var_0_0 = local_require("scripts/ui/hud_ui/equipment_ui_definitions")
local var_0_1 = var_0_0.scenegraph_definition
local var_0_2 = var_0_0.animations_definitions

EquipmentUI = class(EquipmentUI)

local var_0_3 = 2
local var_0_4 = Application.user_setting("persistent_ammo_counter")
local var_0_5 = var_0_0.slot_size
local var_0_6 = var_0_0.NUM_SLOTS
local var_0_7 = {
	slot_potion = "wield_4",
	slot_grenade = "wield_5",
	slot_healthkit = "wield_3",
	slot_career_skill_weapon = "weapon_reload",
	slot_melee = "wield_1",
	slot_ranged = "wield_2"
}
local var_0_8 = {
	slot_grenade = true,
	slot_healthkit = true,
	slot_potion = true,
	slot_career_skill_weapon = true,
	slot_melee = true,
	slot_ranged = true
}
local var_0_9 = {
	normal = Colors.get_color_table_with_alpha("white", 255),
	empty = Colors.get_color_table_with_alpha("red", 255),
	focus = Colors.get_color_table_with_alpha("font_default", 150),
	unfocused = Colors.get_color_table_with_alpha("font_default", 150)
}

local function var_0_10(arg_1_0, arg_1_1)
	return (arg_1_0.hud_index or 0) < (arg_1_1.hud_index or 0)
end

local function var_0_11()
	local var_2_0 = Managers.party:get_local_player_party()
	local var_2_1 = Managers.state.side.side_by_party[var_2_0]

	return var_2_1 and var_2_1:name() == "dark_pact"
end

function EquipmentUI.init(arg_3_0, arg_3_1, arg_3_2)
	arg_3_0._parent = arg_3_1
	arg_3_0.ui_renderer = arg_3_2.ui_renderer
	arg_3_0.ingame_ui = arg_3_2.ingame_ui
	arg_3_0.input_manager = arg_3_2.input_manager
	arg_3_0.peer_id = arg_3_2.peer_id
	arg_3_0.player = arg_3_2.player
	arg_3_0.ui_animations = {}
	arg_3_0._animations = {}
	arg_3_0.render_settings = {
		alpha_multiplier = 1,
		snap_pixel_positions = false
	}
	arg_3_0.is_in_inn = arg_3_2.is_in_inn
	arg_3_0.cleanui = arg_3_2.cleanui
	arg_3_0._is_spectator = false
	arg_3_0._spectated_player = nil
	arg_3_0._spectated_player_unit = nil
	arg_3_0._reload_attempts = 0

	local var_3_0 = Managers.state.event

	var_3_0:register(arg_3_0, "input_changed", "event_input_changed")
	var_3_0:register(arg_3_0, "on_spectator_target_changed", "on_spectator_target_changed")
	var_3_0:register(arg_3_0, "swap_equipment_from_storage", "event_swap_equipment_from_storage")
	arg_3_0:_create_ui_elements()
end

function EquipmentUI._create_ui_elements(arg_4_0)
	arg_4_0.ui_scenegraph = UISceneGraph.init_scenegraph(var_0_1)

	local var_4_0 = {}
	local var_4_1 = {}
	local var_4_2 = {}
	local var_4_3 = {}
	local var_4_4 = {}
	local var_4_5 = {}
	local var_4_6 = {}
	local var_4_7 = 1

	for iter_4_0, iter_4_1 in pairs(var_0_0.widget_definitions) do
		local var_4_8 = UIWidget.init(iter_4_1)

		var_4_1[iter_4_0] = var_4_8
		var_4_6[var_4_7] = var_4_8
		var_4_7 = var_4_7 + 1
	end

	for iter_4_2, iter_4_3 in ipairs(var_0_0.slot_widget_definitions) do
		local var_4_9 = UIWidget.init(iter_4_3)

		var_4_0[iter_4_2] = var_4_9
		var_4_4[iter_4_2] = var_4_9
		var_4_5[iter_4_2] = var_4_9
	end

	for iter_4_4, iter_4_5 in pairs(var_0_0.ammo_widget_definitions) do
		local var_4_10 = UIWidget.init(iter_4_5)

		var_4_2[#var_4_2 + 1] = var_4_10
		var_4_3[iter_4_4] = var_4_10
		var_4_1[iter_4_4] = var_4_10
	end

	local var_4_11 = {}

	for iter_4_6, iter_4_7 in ipairs(var_0_0.extra_storage_icon_definitions) do
		var_4_11[iter_4_6] = UIWidget.init(iter_4_7)
	end

	arg_4_0._extra_storage_icon_widgets = var_4_11
	arg_4_0._widgets = var_4_0
	arg_4_0._widgets_by_name = var_4_1
	arg_4_0._ammo_widgets = var_4_2
	arg_4_0._ammo_widgets_by_name = var_4_3
	arg_4_0._static_widgets = var_4_6
	arg_4_0._unused_widgets = var_4_4
	arg_4_0._slot_widgets = var_4_5
	arg_4_0._ui_animator = UIAnimator:new(arg_4_0.ui_scenegraph, var_0_2)
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

function EquipmentUI.event_input_changed(arg_5_0)
	local var_5_0 = InventorySettings.slots
	local var_5_1 = #var_5_0

	for iter_5_0 = 1, var_5_1 do
		local var_5_2 = var_5_0[iter_5_0]
		local var_5_3 = var_5_2.name
		local var_5_4 = var_5_2.hud_index

		for iter_5_1, iter_5_2 in ipairs(arg_5_0._slot_widgets) do
			if iter_5_2.content.hud_index == var_5_4 then
				arg_5_0:_set_slot_input(iter_5_2, var_5_3)
				arg_5_0:_set_widget_dirty(iter_5_2)
			end
		end
	end

	arg_5_0:set_dirty()
end

function EquipmentUI.on_spectator_target_changed(arg_6_0, arg_6_1)
	arg_6_0._spectated_player_unit = arg_6_1
	arg_6_0._spectated_player = Managers.player:owner(arg_6_1)
	arg_6_0._is_spectator = true

	if Managers.state.side:get_side_from_player_unique_id(arg_6_0._spectated_player:unique_id()):name() == "dark_pact" then
		arg_6_0:set_visible(false)
	else
		arg_6_0:set_visible(true)
	end
end

function EquipmentUI.event_swap_equipment_from_storage(arg_7_0, arg_7_1, arg_7_2)
	if arg_7_1 ~= "slot_grenade" then
		return
	end

	arg_7_0._widgets_by_name.extra_storage_bg.style.texture.color[1] = 163
	arg_7_0._time_fade_storage_slots = Managers.time:time("ui") + 2

	local var_7_0 = arg_7_0._extra_storage_icon_widgets

	for iter_7_0 = 1, #var_7_0 do
		local var_7_1 = var_7_0[iter_7_0]
		local var_7_2 = arg_7_2[iter_7_0]

		if var_7_2 then
			local var_7_3 = var_7_2.gamepad_hud_icon
			local var_7_4 = var_7_1.style
			local var_7_5 = var_7_1.content

			var_7_5.visible = true
			var_7_5.texture_icon = var_7_3
			var_7_5.texture_glow = var_7_3 .. "_glow"
			var_7_4.texture_icon.color[1] = 255

			local var_7_6 = Colors.color_definitions[var_7_2.key] or Colors.color_definitions.black
			local var_7_7 = var_7_4.texture_glow.color

			var_7_7[1] = 255
			var_7_7[2] = var_7_6[2]
			var_7_7[3] = var_7_6[3]
			var_7_7[4] = var_7_6[4]
		else
			var_7_1.content.visible = false
		end
	end
end

function EquipmentUI._set_slot_input(arg_8_0, arg_8_1, arg_8_2)
	local var_8_0 = var_0_7[arg_8_2]
	local var_8_1, var_8_2, var_8_3 = arg_8_0:_get_input_texture_data(var_8_0)

	if not var_8_2 or not UTF8Utils.string_length(var_8_2) then
		local var_8_4 = 0
	end

	local var_8_5 = 40
	local var_8_6 = arg_8_1.style.input_text
	local var_8_7 = arg_8_0.ui_renderer

	var_8_2 = var_8_2 and UIRenderer.crop_text_width(var_8_7, var_8_2, var_8_5, var_8_6)
	arg_8_1.content.input_text = var_8_2 or ""
	arg_8_1.content.input_action = var_8_0
end

function EquipmentUI._get_input_texture_data(arg_9_0, arg_9_1)
	local var_9_0 = arg_9_0.input_manager
	local var_9_1 = var_9_0:get_service("Player")
	local var_9_2 = var_9_0:is_device_active("gamepad")
	local var_9_3 = PLATFORM

	if IS_WINDOWS and var_9_2 then
		var_9_3 = "xb1"
	end

	local var_9_4 = var_9_1:get_keymapping(arg_9_1, var_9_3)
	local var_9_5 = var_9_4 and var_9_4[1]
	local var_9_6 = var_9_4 and var_9_4[2] or UNASSIGNED_KEY
	local var_9_7 = var_9_4 and var_9_4[3]
	local var_9_8

	if var_9_7 == "held" then
		var_9_8 = "matchmaking_prefix_hold"
	end

	local var_9_9 = var_9_6 == UNASSIGNED_KEY
	local var_9_10 = ""

	if var_9_5 == "keyboard" then
		local var_9_11 = var_9_9 and "" or Keyboard.button_locale_name(var_9_6)

		return nil, var_9_11, var_9_8
	elseif var_9_5 == "mouse" then
		local var_9_12 = var_9_9 and "" or Mouse.button_name(var_9_6)

		return nil, var_9_12, var_9_8
	elseif var_9_5 == "gamepad" then
		local var_9_13 = var_9_9 and "" or Pad1.button_name(var_9_6)

		return ButtonTextureByName(var_9_13, var_9_3), var_9_13, var_9_8
	end

	return nil, ""
end

function EquipmentUI._update_widgets(arg_10_0)
	local var_10_0 = arg_10_0._slot_widgets

	for iter_10_0, iter_10_1 in ipairs(var_10_0) do
		arg_10_0:_set_widget_dirty(iter_10_1)
	end

	arg_10_0:set_dirty()
end

function EquipmentUI._get_wield_scroll_input(arg_11_0)
	local var_11_0 = arg_11_0.player_manager
	local var_11_1 = arg_11_0._is_spectator and arg_11_0._spectated_player or arg_11_0.player
	local var_11_2 = var_11_1.player_unit

	if not var_11_2 then
		return
	end

	local var_11_3 = var_11_1:network_id()

	return ScriptUnit.has_extension(var_11_2, "input_system"):get_last_scroll_value()
end

function EquipmentUI._set_wielded_item(arg_12_0, arg_12_1)
	local var_12_0 = arg_12_0._added_items

	for iter_12_0, iter_12_1 in ipairs(var_12_0) do
		local var_12_1 = iter_12_1.slot_name == arg_12_0._wielded_slot_name
		local var_12_2 = iter_12_1.slot_name == arg_12_1
		local var_12_3 = iter_12_1.widget

		var_12_3.content.selected = var_12_2

		local var_12_4 = iter_12_1.slot_name

		if var_12_2 then
			local var_12_5 = var_12_4 == "slot_ranged"

			arg_12_0:_set_ammo_text_focus(var_12_5)
			arg_12_0:_add_animation(var_12_4 .. "_wield_anim", var_12_3, var_12_3, "_animate_slot_wield")
		elseif var_12_1 then
			arg_12_0:_add_animation(var_12_4 .. "_wield_anim", var_12_3, var_12_3, "_animate_slot_unwield")
		end

		iter_12_1.is_wielded = var_12_2
	end

	arg_12_0._wielded_slot_name = arg_12_1
end

local var_0_12 = {}
local var_0_13 = {}

function EquipmentUI._sync_player_equipment(arg_13_0)
	local var_13_0 = arg_13_0._is_spectator and arg_13_0._spectated_player or arg_13_0.player
	local var_13_1 = var_13_0.player_unit

	if not var_13_1 then
		return
	end

	local var_13_2 = ScriptUnit.extension(var_13_1, "inventory_system")
	local var_13_3 = var_13_2:equipment()

	if not var_13_3 then
		return
	end

	table.clear(var_0_13)

	local var_13_4 = false
	local var_13_5
	local var_13_6 = var_13_3.slots
	local var_13_7 = var_13_3.wielded_slot
	local var_13_8 = InventorySettings.slots
	local var_13_9 = #var_13_8
	local var_13_10 = var_13_0:career_name()
	local var_13_11 = arg_13_0._widgets_by_name.background_panel.content
	local var_13_12 = UISettings.hud_inventory_panel_data[var_13_10] or UISettings.hud_inventory_panel_data.default

	var_13_11.texture_id = var_13_12.texture_id
	arg_13_0._widgets_by_name.background_panel.style.texture_id.texture_size = var_13_12.texture_size

	local var_13_13 = var_13_10 == "dr_engineer"
	local var_13_14 = arg_13_0._added_items

	for iter_13_0 = 1, var_13_9 do
		local var_13_15 = var_13_8[iter_13_0].name

		if not var_0_8[var_13_15] or var_13_15 == "slot_career_skill_weapon" and not var_13_13 then
			-- block empty
		else
			local var_13_16 = var_13_6[var_13_15]
			local var_13_17 = var_13_16 and var_13_16.item_data
			local var_13_18 = var_13_17 and var_13_17.name
			local var_13_19 = var_13_17 and var_13_17.backend_id
			local var_13_20 = var_13_15 and var_13_7 == var_13_15 or false
			local var_13_21 = false
			local var_13_22 = 0

			for iter_13_1 = 1, #var_13_14 do
				local var_13_23 = var_13_14[iter_13_1]
				local var_13_24

				if var_13_19 then
					var_13_24 = var_13_23.item_id == var_13_19
				else
					var_13_24 = var_13_23.item_name == var_13_18
				end

				local var_13_25 = var_13_23.slot_name == var_13_15

				if var_13_25 then
					var_13_22 = iter_13_1
				end

				if var_13_24 then
					if not var_0_13[iter_13_1] then
						var_13_21 = true
						var_0_13[iter_13_1] = true

						break
					end
				elseif var_13_18 and var_13_25 then
					var_13_21 = true
					var_0_13[iter_13_1] = true

					arg_13_0:_add_item(var_13_16, var_13_23)

					var_13_4 = true

					break
				end
			end

			if not var_13_21 and var_13_16 ~= nil then
				arg_13_0:_add_item(var_13_16)

				var_0_13[#var_13_14] = true
				var_13_4 = true
			end

			if var_13_20 then
				var_13_5 = var_13_15
			end

			if var_13_15 == "slot_ranged" and var_13_17 and (var_13_16.left_unit_1p or var_13_16.right_unit_1p) then
				arg_13_0:_update_ammo_count(var_13_17, var_13_16, var_13_1)
			end

			if var_13_15 == "slot_grenade" and var_13_17 and var_13_22 > 0 then
				local var_13_26 = var_13_2:has_additional_item_slots(var_13_15)
				local var_13_27 = var_13_2:get_total_item_count(var_13_15)
				local var_13_28 = var_13_14[var_13_22]
				local var_13_29 = var_13_28 and var_13_28.widget

				if var_13_29 then
					local var_13_30 = var_13_29.content

					if var_13_30.use_count ~= var_13_27 then
						var_13_30.use_count = var_13_27
						var_13_30.use_count_text = "x" .. var_13_27
						var_13_30.has_additional_slots = var_13_26

						arg_13_0:_set_widget_dirty(var_13_29)
					end

					local var_13_31 = var_13_2:can_swap_from_storage(var_13_15, SwapFromStorageType.Unique)

					if var_13_30.can_swap ~= var_13_31 then
						var_13_30.can_swap = var_13_31

						arg_13_0:_set_widget_dirty(var_13_29)
					end
				end
			end

			if var_13_15 == "slot_potion" and var_13_17 and var_13_22 > 0 then
				local var_13_32 = var_13_14[var_13_22]
				local var_13_33 = var_13_32 and var_13_32.widget

				if var_13_33 then
					local var_13_34 = var_13_33.content
					local var_13_35 = var_13_33.style
					local var_13_36 = var_13_2:has_additional_item_slots(var_13_15)
					local var_13_37 = var_13_2:get_additional_items(var_13_15)

					if var_13_37 then
						local var_13_38 = var_13_37[1]

						if var_13_38 then
							local var_13_39 = var_13_38.gamepad_hud_icon

							var_13_34.secondary_texture_icon = var_13_39
							var_13_34.secondary_texture_icon_glow = var_13_39 .. "_glow"
							var_13_34.has_additional_slots = var_13_36

							local var_13_40 = var_13_38.key

							if var_13_34.additional_item_key ~= var_13_40 then
								var_13_34.additional_item_key = var_13_40

								local var_13_41 = UISettings.inventory_consumable_slot_colors
								local var_13_42 = {
									255,
									0,
									0,
									0
								}
								local var_13_43 = {
									255,
									255,
									255,
									255
								}
								local var_13_44 = var_13_41[var_13_38.key]

								if var_13_44 then
									var_13_35.secondary_texture_icon.color = var_13_44
									var_13_35.secondary_texture_icon_glow.color = {
										255,
										0,
										0,
										0
									}
								else
									var_13_35.secondary_texture_icon.color = var_13_42
									var_13_35.secondary_texture_icon_glow.color = var_13_43
								end

								local var_13_45 = UISettings.additional_inventory_slot_angles.default
								local var_13_46 = UISettings.additional_inventory_slot_angles[var_13_38.key] or var_13_45

								var_13_35.secondary_texture_icon.angle = var_13_46
								var_13_35.secondary_texture_icon_glow.angle = var_13_46

								arg_13_0:_set_widget_dirty(var_13_33)
							end
						elseif not var_13_38 and var_13_34.additional_item_key then
							var_13_34.secondary_texture_icon = nil
							var_13_34.secondary_texture_icon_glow = nil
							var_13_34.has_additional_slots = var_13_36
							var_13_34.additional_item_key = nil

							arg_13_0:_set_widget_dirty(var_13_33)
						end
					elseif var_13_34.has_additional_slots and not var_13_36 then
						var_13_34.secondary_texture_icon = nil
						var_13_34.secondary_texture_icon_glow = nil
						var_13_34.has_additional_slots = var_13_36
						var_13_34.additional_item_key = nil

						arg_13_0:_set_widget_dirty(var_13_33)
					end
				end
			end

			if var_13_15 == "slot_career_skill_weapon" and var_13_17 and var_13_22 > 0 then
				local var_13_47 = var_13_14[var_13_22]
				local var_13_48 = var_13_47 and var_13_47.widget

				if var_13_48 then
					local var_13_49, var_13_50 = ScriptUnit.has_extension(var_13_1, "career_system"):current_ability_cooldown(1)
					local var_13_51 = ScriptUnit.has_extension(var_13_1, "buff_system"):has_buff_type("bardin_engineer_pump_max_exhaustion_buff")
					local var_13_52 = var_13_3.wielded_slot == "slot_career_skill_weapon" and var_13_49 > 0 and not var_13_51

					if var_13_48.content.can_reload ~= var_13_52 or var_13_48.content.is_exhausted ~= var_13_51 then
						var_13_48.content.can_reload = var_13_52
						var_13_48.content.is_exhausted = var_13_51

						arg_13_0:_set_widget_dirty(var_13_48)
					end

					local var_13_53 = WeaponUtils.get_weapon_template(var_13_17.template).actions.action_one.default.condition_func

					if var_13_52 and not var_13_53(var_13_1, nil) then
						local var_13_54 = Managers.time:time("ui")

						var_13_48.style.reload_icon.color[1] = 255 - 155 * (0.5 + 0.5 * math.sin(5 * var_13_54))

						arg_13_0:_set_widget_dirty(var_13_48)
					else
						var_13_48.style.reload_icon.color[1] = 235
					end

					var_13_48.style.reload_icon.color[3] = var_13_51 and 100 or 255
					var_13_48.style.reload_icon.color[4] = var_13_51 and 69 or 255
				end
			end
		end
	end

	table.clear(var_0_12)

	for iter_13_2 = 1, #var_13_14 do
		if not var_0_13[iter_13_2] then
			var_0_12[#var_0_12 + 1] = iter_13_2
		end
	end

	local var_13_55 = 0

	for iter_13_3 = 1, #var_0_12 do
		local var_13_56 = var_0_12[iter_13_3] - var_13_55

		arg_13_0:_remove_item(var_13_56)

		var_13_55 = var_13_55 + 1
		var_13_4 = true
	end

	if var_13_4 then
		arg_13_0:_update_widgets()
		table.sort(var_13_14, var_0_10)
	end

	if var_13_7 and not var_13_5 then
		var_13_5 = var_13_7

		arg_13_0:_set_ammo_text_focus(false)
	end

	if var_13_5 and arg_13_0._wielded_slot_name ~= var_13_5 or var_13_4 then
		var_13_5 = var_13_5 or arg_13_0._wielded_slot_name

		arg_13_0:_set_wielded_item(var_13_5)
	end
end

function EquipmentUI._update_ammo_count(arg_14_0, arg_14_1, arg_14_2, arg_14_3)
	local var_14_0 = BackendUtils.get_item_template(arg_14_1)
	local var_14_1 = arg_14_0._ammo_widgets_by_name
	local var_14_2 = false

	if var_14_0.ammo_data then
		if var_14_0.ammo_data.hide_ammo_ui then
			arg_14_0._draw_ammo = false
		else
			arg_14_0._draw_ammo = true

			local var_14_3, var_14_4, var_14_5 = arg_14_0:_get_ammunition_count(arg_14_2.left_unit_1p, arg_14_2.right_unit_1p, var_14_0)
			local var_14_6 = var_14_1.ammo_text_clip.content
			local var_14_7 = var_14_3 + var_14_4 == 0
			local var_14_8 = false

			if arg_14_0._ammo_count ~= var_14_3 then
				arg_14_0._ammo_count = var_14_3

				local var_14_9 = var_14_1.ammo_text_clip

				var_14_9.content.text = tostring(var_14_3)

				arg_14_0:_set_widget_dirty(var_14_9)

				var_14_8 = true
			end

			if arg_14_0._remaining_ammo ~= var_14_4 then
				arg_14_0._remaining_ammo = var_14_4

				local var_14_10 = var_14_1.ammo_text_remaining

				var_14_10.content.text = tostring(var_14_4)

				arg_14_0:_set_widget_dirty(var_14_10)

				var_14_8 = true
			end

			if var_14_8 then
				arg_14_0._ammo_counter_fade_delay = var_0_3
				arg_14_0._ammo_counter_fade_progress = 1

				arg_14_0:_set_ammo_counter_alpha(255)

				local var_14_11 = var_14_7 and var_0_9.empty or var_0_9.normal

				arg_14_0:_set_ammo_counter_color(var_14_11)
				arg_14_0:set_dirty()
			end
		end
	else
		local var_14_12, var_14_13, var_14_14 = arg_14_0:_get_overcharge_amount(arg_14_3)

		if arg_14_0._overcharge_fraction ~= var_14_13 then
			arg_14_0._overcharge_fraction = var_14_13

			arg_14_0:_set_overheat_fraction(var_14_13)
		end

		var_14_2 = true
	end

	if arg_14_0._draw_overheat ~= var_14_2 then
		arg_14_0._draw_overheat = var_14_2

		arg_14_0:_show_overheat_meter(var_14_2)
	end
end

function EquipmentUI._animate_ammo_counter(arg_15_0, arg_15_1)
	local var_15_0 = arg_15_0._ammo_counter_fade_delay

	if var_15_0 then
		local var_15_1 = math.max(var_15_0 - arg_15_1, 0)

		if var_15_1 == 0 then
			arg_15_0._ammo_counter_fade_delay = nil
		else
			arg_15_0._ammo_counter_fade_delay = var_15_1
		end

		return
	end

	local var_15_2 = arg_15_0._ammo_counter_fade_progress

	if not var_15_2 then
		return
	end

	local var_15_3 = math.max(var_15_2 - arg_15_1, 0)
	local var_15_4 = 100 + 155 * var_15_3

	arg_15_0:_set_ammo_counter_alpha(var_15_4)

	if var_15_3 == 0 then
		arg_15_0._ammo_counter_fade_progress = nil
	else
		arg_15_0._ammo_counter_fade_progress = var_15_3
	end

	return true
end

function EquipmentUI._set_ammo_counter_alpha(arg_16_0, arg_16_1)
	local var_16_0 = arg_16_0._ammo_widgets_by_name
	local var_16_1 = var_16_0.ammo_text_clip

	var_16_1.style.text.text_color[1] = arg_16_1

	arg_16_0:_set_widget_dirty(var_16_1)

	local var_16_2 = var_16_0.ammo_text_remaining

	var_16_2.style.text.text_color[1] = arg_16_1

	arg_16_0:_set_widget_dirty(var_16_2)

	local var_16_3 = var_16_0.ammo_text_center

	var_16_3.style.text.text_color[1] = arg_16_1

	arg_16_0:_set_widget_dirty(var_16_3)
	arg_16_0:set_dirty()
end

function EquipmentUI._set_ammo_counter_color(arg_17_0, arg_17_1)
	local var_17_0 = arg_17_0._ammo_widgets_by_name.ammo_text_clip
	local var_17_1 = var_17_0.style.text.text_color

	var_17_1[2] = arg_17_1[2]
	var_17_1[3] = arg_17_1[3]
	var_17_1[4] = arg_17_1[4]

	arg_17_0:_set_widget_dirty(var_17_0)

	local var_17_2 = arg_17_0._ammo_widgets_by_name.ammo_text_remaining
	local var_17_3 = var_17_2.style.text.text_color

	var_17_3[2] = arg_17_1[2]
	var_17_3[3] = arg_17_1[3]
	var_17_3[4] = arg_17_1[4]

	arg_17_0:_set_widget_dirty(var_17_2)

	local var_17_4 = arg_17_0._ammo_widgets_by_name.ammo_text_center
	local var_17_5 = var_17_4.style.text.text_color

	var_17_5[2] = arg_17_1[2]
	var_17_5[3] = arg_17_1[3]
	var_17_5[4] = arg_17_1[4]

	arg_17_0:_set_widget_dirty(var_17_4)
	arg_17_0:set_dirty()
end

function EquipmentUI._set_ammo_text_focus(arg_18_0, arg_18_1)
	if arg_18_0._draw_overheat then
		if arg_18_0._overcharge_fraction ~= nil then
			local var_18_0 = 1
			local var_18_1 = arg_18_1 and var_0_9.focus or var_0_9.unfocused
			local var_18_2 = arg_18_0._widgets_by_name
			local var_18_3 = var_18_2.overcharge
			local var_18_4 = var_18_2.overcharge_background
			local var_18_5 = var_18_3.style.texture_id.color
			local var_18_6 = var_18_4.style.texture_id.color

			var_18_5[2] = var_18_1[2] * var_18_0
			var_18_5[3] = var_18_1[3] * var_18_0
			var_18_5[4] = var_18_1[4] * var_18_0

			arg_18_0:_set_widget_dirty(var_18_3)
			arg_18_0:_set_widget_dirty(var_18_4)
			arg_18_0:set_dirty()
		end
	elseif arg_18_0._draw_ammo then
		local var_18_7 = arg_18_0._ammo_widgets_by_name

		if not var_0_4 or arg_18_1 then
			arg_18_0._ammo_counter_fade_progress = 1
			arg_18_0._ammo_counter_fade_delay = var_0_3

			arg_18_0:_set_ammo_counter_alpha(255)
		end

		if not var_0_4 and (arg_18_0._ammo_count ~= nil or arg_18_0._remaining_ammo ~= nil) then
			local var_18_8 = 1

			if not arg_18_1 or not var_0_9.focus then
				local var_18_9 = var_0_9.unfocused
			end

			local var_18_10 = arg_18_0._widgets_by_name.ammo_background

			var_18_10.content.visible = arg_18_1

			arg_18_0:_set_widget_dirty(var_18_10)

			local var_18_11 = var_18_7.ammo_text_clip

			var_18_11.content.visible = arg_18_1

			arg_18_0:_set_widget_dirty(var_18_11)

			local var_18_12 = var_18_7.ammo_text_remaining

			var_18_12.content.visible = arg_18_1

			arg_18_0:_set_widget_dirty(var_18_12)

			local var_18_13 = var_18_7.ammo_text_center

			var_18_13.content.visible = arg_18_1

			arg_18_0:_set_widget_dirty(var_18_13)
			arg_18_0:set_dirty()
		end
	end

	if not var_0_4 then
		arg_18_0._show_ammo_meter = arg_18_1

		if not arg_18_1 then
			local var_18_14 = arg_18_0._widgets_by_name
			local var_18_15 = arg_18_0._ammo_widgets_by_name
			local var_18_16 = var_18_14.overcharge
			local var_18_17 = var_18_14.overcharge_background
			local var_18_18 = var_18_14.ammo_background
			local var_18_19 = var_18_15.ammo_text_clip
			local var_18_20 = var_18_15.ammo_text_remaining
			local var_18_21 = var_18_15.ammo_text_center
			local var_18_22 = var_18_15.reload_tip_text

			arg_18_0:_set_widget_visibility(var_18_16, false)
			arg_18_0:_set_widget_visibility(var_18_17, false)
			arg_18_0:_set_widget_visibility(var_18_18, false)
			arg_18_0:_set_widget_visibility(var_18_19, false)
			arg_18_0:_set_widget_visibility(var_18_20, false)
			arg_18_0:_set_widget_visibility(var_18_21, false)
			arg_18_0:_set_widget_visibility(var_18_22, false)

			arg_18_0._ammo_dirty = true
		end
	end
end

function EquipmentUI._get_ammunition_count(arg_19_0, arg_19_1, arg_19_2, arg_19_3)
	local var_19_0

	if not arg_19_3.ammo_data then
		return
	end

	local var_19_1 = arg_19_3.ammo_data.ammo_hand

	if var_19_1 == "right" then
		var_19_0 = ScriptUnit.extension(arg_19_2, "ammo_system")
	elseif var_19_1 == "left" then
		var_19_0 = ScriptUnit.extension(arg_19_1, "ammo_system")
	else
		return
	end

	local var_19_2 = var_19_0:ammo_count()
	local var_19_3 = var_19_0:remaining_ammo()
	local var_19_4 = var_19_0:using_single_clip()

	return var_19_2, var_19_3, var_19_4
end

function EquipmentUI._get_overcharge_amount(arg_20_0, arg_20_1)
	local var_20_0 = ScriptUnit.extension(arg_20_1, "overcharge_system")
	local var_20_1 = var_20_0:overcharge_fraction()
	local var_20_2 = var_20_0:threshold_fraction()
	local var_20_3 = var_20_0:get_anim_blend_overcharge()

	return true, var_20_1, var_20_2, var_20_3
end

function EquipmentUI._add_animation(arg_21_0, arg_21_1, arg_21_2, arg_21_3, arg_21_4)
	local var_21_0 = arg_21_0._animations
	local var_21_1 = UISettings.inventory_hud.equip_animation_duration
	local var_21_2 = var_21_0[arg_21_1]

	if var_21_2 then
		var_21_2.total_time = var_21_1
		var_21_2.time = 0
		var_21_2.func = arg_21_4
	else
		var_21_0[arg_21_1] = {
			time = 0,
			total_time = var_21_1,
			style = arg_21_3,
			widget = arg_21_2,
			func = arg_21_4
		}
	end
end

function EquipmentUI._update_animations(arg_22_0, arg_22_1, arg_22_2)
	local var_22_0 = arg_22_0._time_fade_storage_slots

	if var_22_0 then
		local var_22_1 = math.clamp(var_22_0 - arg_22_2, 0, 1)
		local var_22_2 = arg_22_0._extra_storage_icon_widgets

		for iter_22_0 = 1, #var_22_2 do
			local var_22_3 = var_22_2[iter_22_0].style

			var_22_3.texture_icon.color[1] = 255 * var_22_1
			var_22_3.texture_glow.color[1] = 128 * var_22_1
		end

		local var_22_4 = arg_22_0._widgets_by_name.extra_storage_bg

		var_22_4.style.texture.color[1] = 189 * var_22_1

		arg_22_0:_set_widget_dirty(var_22_4)

		if var_22_1 == 0 then
			arg_22_0._time_fade_storage_slots = nil
		end
	end

	local var_22_5 = arg_22_0._animations
	local var_22_6 = false

	for iter_22_1, iter_22_2 in pairs(var_22_5) do
		var_22_5[iter_22_1] = arg_22_0[iter_22_2.func](arg_22_0, iter_22_2, arg_22_1)

		local var_22_7 = iter_22_2.widget

		arg_22_0:_set_widget_dirty(var_22_7)

		var_22_6 = true
	end

	return var_22_6
end

function EquipmentUI._animate_slot_wield(arg_23_0, arg_23_1, arg_23_2)
	local var_23_0 = arg_23_1.widget
	local var_23_1 = arg_23_1.total_time
	local var_23_2 = arg_23_1.time + arg_23_2
	local var_23_3 = math.min(var_23_2 / var_23_1, 1)
	local var_23_4 = math.easeOutCubic(var_23_3)
	local var_23_5 = math.easeInCubic(1 - var_23_3)

	var_23_0.style.texture_selected.color[1] = 255 * var_23_4
	arg_23_1.time = var_23_2

	return var_23_3 < 1 and arg_23_1 or nil
end

function EquipmentUI._animate_slot_unwield(arg_24_0, arg_24_1, arg_24_2)
	local var_24_0 = arg_24_1.widget
	local var_24_1 = arg_24_1.total_time
	local var_24_2 = arg_24_1.time + arg_24_2
	local var_24_3 = math.min(var_24_2 / var_24_1, 1)
	local var_24_4 = math.easeInCubic(1 - var_24_3)
	local var_24_5 = math.easeOutCubic(var_24_3)

	var_24_0.style.texture_selected.color[1] = 255 * var_24_4
	arg_24_1.time = var_24_2

	return var_24_3 < 1 and arg_24_1 or nil
end

function EquipmentUI._animate_slot_equip(arg_25_0, arg_25_1, arg_25_2)
	local var_25_0 = arg_25_1.style
	local var_25_1 = arg_25_1.total_time
	local var_25_2 = arg_25_1.time + arg_25_2
	local var_25_3 = math.min(var_25_2 / var_25_1, 1)
	local var_25_4 = math.catmullrom(var_25_3, -10, 0, 0, -4)
	local var_25_5 = math.easeOutCubic(var_25_3)

	var_25_0.color[1] = 255 * var_25_5
	arg_25_1.time = var_25_2

	return var_25_3 < 1 and arg_25_1 or nil
end

function EquipmentUI._add_item(arg_26_0, arg_26_1, arg_26_2)
	local var_26_0 = arg_26_0._num_added_items or 0
	local var_26_1 = arg_26_2 ~= nil

	if not var_26_1 and var_26_0 >= var_0_6 then
		return
	end

	local var_26_2 = arg_26_1.id
	local var_26_3 = arg_26_1.item_data.slot_type
	local var_26_4 = InventorySettings.slots_by_name[var_26_2].hud_index
	local var_26_5

	if var_26_1 then
		var_26_5 = arg_26_2.widget
	else
		for iter_26_0, iter_26_1 in ipairs(arg_26_0._slot_widgets) do
			if iter_26_1.content.hud_index == var_26_4 then
				var_26_5 = iter_26_1

				break
			end
		end

		UIRenderer.set_element_visible(arg_26_0.ui_renderer, var_26_5.element, true)
	end

	local var_26_6 = var_26_5.content
	local var_26_7 = var_26_5.style
	local var_26_8 = var_26_6.normal_color
	local var_26_9 = arg_26_1.item_data
	local var_26_10 = var_26_9.name
	local var_26_11 = var_26_9.hud_icon

	if var_26_3 == "melee" then
		var_26_11 = "hud_inventory_icon_melee"
	elseif var_26_3 == "ranged" then
		var_26_11 = "hud_inventory_icon_ranged"
	elseif var_26_2 == "slot_career_skill_weapon" then
		var_26_11 = "hud_ability_cog_icon"
	end

	local var_26_12 = var_26_7.texture_background

	if var_26_12 then
		local var_26_13 = UISettings.inventory_consumable_slot_colors
		local var_26_14 = var_26_13.default
		local var_26_15 = var_26_13[var_26_10] or var_26_14

		Colors.copy_to(var_26_12.color, var_26_15)
	end

	var_26_6.texture_icon = var_26_11 or "icons_placeholder"
	var_26_7.texture_icon.color[1] = 255
	var_26_6.visible = true
	arg_26_2 = arg_26_2 or {}
	arg_26_2.hud_index = var_26_4
	arg_26_2.slot_name = var_26_2
	arg_26_2.item_name = var_26_10
	arg_26_2.widget = var_26_5
	arg_26_2.wielded = false
	arg_26_2.icon = var_26_11
	arg_26_2.item_id = var_26_9.backend_id

	if not var_26_1 then
		local var_26_16 = arg_26_0._added_items

		table.insert(var_26_16, #var_26_16 + 1, arg_26_2)

		arg_26_0._num_added_items = var_26_0 + 1
	end
end

function EquipmentUI._remove_item(arg_27_0, arg_27_1)
	local var_27_0 = arg_27_0._num_added_items or 0

	if var_27_0 <= 0 then
		return
	end

	local var_27_1 = arg_27_0._added_items
	local var_27_2 = table.remove(var_27_1, arg_27_1)
	local var_27_3 = var_27_2.slot_name
	local var_27_4 = var_27_2.widget
	local var_27_5 = var_27_4.content
	local var_27_6 = var_27_4.style

	var_27_6.texture_icon.color[1] = 0

	local var_27_7 = var_27_5.selected

	var_27_5.selected = false

	local var_27_8 = UISettings.inventory_consumable_slot_colors.default

	if var_27_6.texture_background then
		local var_27_9 = var_27_6.texture_background.color

		var_27_9[2] = var_27_8[2]
		var_27_9[3] = var_27_8[3]
		var_27_9[4] = var_27_8[4]
	end

	var_27_5.visible = false
	arg_27_0._num_added_items = var_27_0 - 1

	if var_27_7 then
		arg_27_0:_add_animation(var_27_3 .. "_wield_anim", var_27_4, var_27_4, "_animate_slot_unwield")
	else
		var_27_4.style.texture_selected.color[1] = 0
	end
end

function EquipmentUI.set_position(arg_28_0, arg_28_1, arg_28_2)
	local var_28_0 = arg_28_0.ui_scenegraph.pivot.local_position

	var_28_0[1] = arg_28_1
	var_28_0[2] = arg_28_2

	for iter_28_0, iter_28_1 in ipairs(arg_28_0._widgets) do
		arg_28_0:_set_widget_dirty(iter_28_1)
	end

	for iter_28_2, iter_28_3 in ipairs(arg_28_0._static_widgets) do
		arg_28_0:_set_widget_dirty(iter_28_3)
	end

	arg_28_0:set_dirty()
end

function EquipmentUI.destroy(arg_29_0)
	local var_29_0 = Managers.state.event

	var_29_0:unregister("input_changed", arg_29_0)
	var_29_0:unregister("on_spectator_target_changed", arg_29_0)
	var_29_0:unregister("swap_equipment_from_storage", arg_29_0)
	arg_29_0:set_visible(false)

	arg_29_0._ui_animator = nil

	print("[EquipmentUI] - Destroy")
end

function EquipmentUI.set_visible(arg_30_0, arg_30_1)
	arg_30_0._is_visible = arg_30_1

	arg_30_0:_set_elements_visible(arg_30_1)
end

function EquipmentUI._set_elements_visible(arg_31_0, arg_31_1)
	local var_31_0 = arg_31_0.ui_renderer

	for iter_31_0, iter_31_1 in ipairs(arg_31_0._widgets) do
		UIRenderer.set_element_visible(var_31_0, iter_31_1.element, arg_31_1)
	end

	for iter_31_2, iter_31_3 in ipairs(arg_31_0._static_widgets) do
		UIRenderer.set_element_visible(var_31_0, iter_31_3.element, arg_31_1)
	end

	for iter_31_4, iter_31_5 in ipairs(arg_31_0._ammo_widgets) do
		UIRenderer.set_element_visible(var_31_0, iter_31_5.element, arg_31_1)
	end

	arg_31_0._retained_elements_visible = arg_31_1

	arg_31_0:set_dirty()
end

local var_0_14 = {
	lock_y = true,
	registry_key = "player_status",
	drag_scenegraph_id = "background_panel",
	root_scenegraph_id = "root",
	label = "Player status",
	lock_x = false
}
local var_0_15 = {
	root_scenegraph_id = "ammo_background",
	label = "Ammo",
	registry_key = "ammo",
	drag_scenegraph_id = "ammo_background"
}

function EquipmentUI.update(arg_32_0, arg_32_1, arg_32_2)
	if not arg_32_0._is_visible then
		return
	end

	if HudCustomizer.run(arg_32_0.ui_renderer, arg_32_0.ui_scenegraph, var_0_14) then
		UIUtils.mark_dirty(arg_32_0._widgets_by_name)
		UIUtils.mark_dirty(arg_32_0._widgets)
		UIUtils.mark_dirty(arg_32_0._extra_storage_icon_widgets)
	end

	if HudCustomizer.run(arg_32_0.ui_renderer, arg_32_0.ui_scenegraph, var_0_15) then
		UIUtils.mark_dirty(arg_32_0._ammo_widgets)
	end

	local var_32_0 = false
	local var_32_1, var_32_2 = arg_32_0._parent:get_crosshair_position()

	if arg_32_0:_apply_crosshair_position(var_32_1, var_32_2) then
		var_32_0 = true
	end

	if arg_32_0:_update_animations(arg_32_1, arg_32_2) then
		var_32_0 = true
	end

	if arg_32_0:_animate_ammo_counter(arg_32_1) then
		var_32_0 = true
	end

	if var_32_0 then
		arg_32_0:set_dirty()
	end

	arg_32_0:_handle_resolution_modified()
	arg_32_0:_show_hold_to_reload(arg_32_2)
	arg_32_0:_sync_player_equipment()
	arg_32_0:draw(arg_32_1)
	arg_32_0._ui_animator:update(arg_32_1)
end

function EquipmentUI._handle_resolution_modified(arg_33_0)
	if RESOLUTION_LOOKUP.modified then
		arg_33_0:_on_resolution_modified()
	end
end

function EquipmentUI._on_resolution_modified(arg_34_0)
	for iter_34_0, iter_34_1 in ipairs(arg_34_0._widgets) do
		arg_34_0:_set_widget_dirty(iter_34_1)
	end

	for iter_34_2, iter_34_3 in ipairs(arg_34_0._static_widgets) do
		arg_34_0:_set_widget_dirty(iter_34_3)
	end

	for iter_34_4, iter_34_5 in ipairs(arg_34_0._ammo_widgets) do
		arg_34_0:_set_widget_dirty(iter_34_5)
	end

	arg_34_0:set_dirty()
end

function EquipmentUI._handle_gamepad(arg_35_0)
	if (Managers.input:is_device_active("gamepad") or not IS_WINDOWS or UISettings.use_gamepad_hud_layout == "always") and UISettings.use_gamepad_hud_layout ~= "never" then
		if arg_35_0._retained_elements_visible then
			arg_35_0:_set_elements_visible(false)
		end

		return false
	else
		if not arg_35_0._retained_elements_visible then
			arg_35_0:_set_elements_visible(true)
			arg_35_0:event_input_changed()
		end

		return arg_35_0._dirty
	end
end

function EquipmentUI.draw(arg_36_0, arg_36_1)
	if not arg_36_0._is_visible then
		return
	end

	if not arg_36_0:_handle_gamepad() then
		return
	end

	local var_36_0 = arg_36_0.ui_renderer
	local var_36_1 = arg_36_0.ui_scenegraph
	local var_36_2 = arg_36_0.input_manager:get_service("ingame_menu")
	local var_36_3 = arg_36_0.render_settings
	local var_36_4 = var_36_3.alpha_multiplier

	UIRenderer.begin_pass(var_36_0, var_36_1, var_36_2, arg_36_1, nil, var_36_3)

	var_36_3.snap_pixel_positions = true
	var_36_3.alpha_multiplier = arg_36_0.panel_alpha_multiplier or var_36_4

	for iter_36_0, iter_36_1 in ipairs(arg_36_0._slot_widgets) do
		UIRenderer.draw_widget(var_36_0, iter_36_1)
	end

	for iter_36_2, iter_36_3 in ipairs(arg_36_0._extra_storage_icon_widgets) do
		UIRenderer.draw_widget(var_36_0, iter_36_3)
	end

	var_36_3.snap_pixel_positions = true

	for iter_36_4, iter_36_5 in ipairs(arg_36_0._static_widgets) do
		UIRenderer.draw_widget(var_36_0, iter_36_5)
	end

	if var_0_4 or arg_36_0._show_ammo_meter or arg_36_0._ammo_dirty then
		var_36_3.alpha_multiplier = arg_36_0.ammo_alpha_multiplier or var_36_4
		var_36_3.snap_pixel_positions = true

		for iter_36_6, iter_36_7 in ipairs(arg_36_0._ammo_widgets) do
			UIRenderer.draw_widget(var_36_0, iter_36_7)
		end
	end

	UIRenderer.end_pass(var_36_0)

	arg_36_0._dirty = false
	arg_36_0._ammo_dirty = false
end

function EquipmentUI._set_color(arg_37_0, arg_37_1, arg_37_2, arg_37_3)
	if not arg_37_3 then
		arg_37_1[1] = arg_37_2[1]
	end

	arg_37_1[2] = arg_37_2[2]
	arg_37_1[3] = arg_37_2[3]
	arg_37_1[4] = arg_37_2[4]
end

function EquipmentUI.set_dirty(arg_38_0)
	arg_38_0._dirty = true

	if arg_38_0.cleanui then
		arg_38_0.cleanui.dirty = true
	end
end

function EquipmentUI._set_widget_dirty(arg_39_0, arg_39_1)
	arg_39_1.element.dirty = true
	arg_39_0._dirty = true

	if arg_39_0.cleanui then
		arg_39_0.cleanui.dirty = true
	end
end

function EquipmentUI.on_gamepad_activated(arg_40_0)
	arg_40_0:_update_widgets()
end

function EquipmentUI.on_gamepad_deactivated(arg_41_0)
	arg_41_0:_update_widgets()
end

function EquipmentUI._set_overheat_fraction(arg_42_0, arg_42_1)
	local var_42_0 = arg_42_0._widgets_by_name.overcharge

	var_42_0.content.texture_id.uvs[2][1] = arg_42_1

	local var_42_1 = var_42_0.scenegraph_id
	local var_42_2 = arg_42_0.ui_scenegraph[var_42_1]
	local var_42_3 = var_0_1[var_42_1].size

	var_42_2.size[1] = var_42_3[1] * arg_42_1

	arg_42_0:_set_widget_dirty(var_42_0)
	arg_42_0:set_dirty()
end

function EquipmentUI._show_overheat_meter(arg_43_0, arg_43_1)
	local var_43_0 = arg_43_0._widgets_by_name
	local var_43_1 = arg_43_0._ammo_widgets_by_name

	arg_43_0:_set_widget_visibility(var_43_0.overcharge, false)
	arg_43_0:_set_widget_visibility(var_43_0.overcharge_background, false)
	arg_43_0:_set_widget_visibility(var_43_1.ammo_text_clip, not arg_43_1)
	arg_43_0:_set_widget_visibility(var_43_1.ammo_text_remaining, not arg_43_1)
	arg_43_0:_set_widget_visibility(var_43_1.ammo_text_center, not arg_43_1)
	arg_43_0:_set_widget_visibility(var_43_0.ammo_background, not arg_43_1)
	arg_43_0:set_dirty()
end

function EquipmentUI._set_widget_visibility(arg_44_0, arg_44_1, arg_44_2)
	arg_44_1.content.visible = arg_44_2

	arg_44_0:_set_widget_dirty(arg_44_1)
end

function EquipmentUI.set_alpha(arg_45_0, arg_45_1)
	arg_45_0.render_settings.alpha_multiplier = arg_45_1

	for iter_45_0, iter_45_1 in pairs(arg_45_0._widgets) do
		arg_45_0:_set_widget_dirty(iter_45_1)
	end

	for iter_45_2, iter_45_3 in pairs(arg_45_0._slot_widgets) do
		arg_45_0:_set_widget_dirty(iter_45_3)
	end

	for iter_45_4, iter_45_5 in pairs(arg_45_0._static_widgets) do
		arg_45_0:_set_widget_dirty(iter_45_5)
	end

	for iter_45_6, iter_45_7 in pairs(arg_45_0._ammo_widgets) do
		arg_45_0:_set_widget_dirty(iter_45_7)
	end

	arg_45_0:set_dirty()
end

function EquipmentUI.set_ammo_alpha(arg_46_0, arg_46_1)
	arg_46_0.ammo_alpha_multiplier = arg_46_1

	for iter_46_0, iter_46_1 in pairs(arg_46_0._ammo_widgets) do
		arg_46_0:_set_widget_dirty(iter_46_1)
	end

	arg_46_0:set_dirty()
end

function EquipmentUI.set_panel_alpha(arg_47_0, arg_47_1)
	arg_47_0.panel_alpha_multiplier = arg_47_1

	for iter_47_0, iter_47_1 in pairs(arg_47_0._widgets) do
		arg_47_0:_set_widget_dirty(iter_47_1)
	end

	for iter_47_2, iter_47_3 in pairs(arg_47_0._slot_widgets) do
		arg_47_0:_set_widget_dirty(iter_47_3)
	end

	for iter_47_4, iter_47_5 in pairs(arg_47_0._static_widgets) do
		arg_47_0:_set_widget_dirty(iter_47_5)
	end

	arg_47_0:set_dirty()
end

function EquipmentUI._apply_crosshair_position(arg_48_0, arg_48_1, arg_48_2)
	local var_48_0 = "screen_bottom_pivot"
	local var_48_1 = arg_48_0.ui_scenegraph[var_48_0].local_position
	local var_48_2 = false

	if var_48_1[1] ~= arg_48_1 or var_48_1[2] ~= arg_48_2 then
		var_48_2 = true
	end

	var_48_1[1] = arg_48_1
	var_48_1[2] = arg_48_2

	if var_48_2 then
		local var_48_3 = arg_48_0._widgets_by_name
		local var_48_4 = arg_48_0._ammo_widgets_by_name

		arg_48_0:_set_widget_dirty(var_48_4.ammo_text_clip)
		arg_48_0:_set_widget_dirty(var_48_4.ammo_text_remaining)
		arg_48_0:_set_widget_dirty(var_48_4.ammo_text_center)
		arg_48_0:_set_widget_dirty(var_48_3.overcharge)
		arg_48_0:_set_widget_dirty(var_48_3.overcharge_background)
	end

	return var_48_2
end

function EquipmentUI._show_hold_to_reload(arg_49_0, arg_49_1)
	local var_49_0 = (arg_49_0._is_spectator and arg_49_0._spectated_player or arg_49_0.player).player_unit

	if not var_49_0 then
		return
	end

	local var_49_1 = ScriptUnit.extension(var_49_0, "inventory_system"):equipment()
	local var_49_2 = var_49_1.wielded_slot
	local var_49_3 = false
	local var_49_4
	local var_49_5
	local var_49_6

	for iter_49_0, iter_49_1 in pairs(var_49_1.slots) do
		local var_49_7 = iter_49_1.item_data
		local var_49_8 = BackendUtils.get_item_template(var_49_7)

		if iter_49_1.id == var_49_2 and var_49_8.ammo_data and var_49_8.ammo_data.unique_ammo_type then
			var_49_4 = iter_49_1
			var_49_5 = var_49_7
			var_49_6 = var_49_8
			var_49_3 = true
		end
	end

	if not var_49_5 or not var_49_4 or not var_49_6 then
		return
	end

	local var_49_9, var_49_10, var_49_11 = arg_49_0:_get_ammunition_count(var_49_4.left_unit_1p, var_49_4.right_unit_1p, var_49_6)
	local var_49_12 = arg_49_0._ammo_widgets_by_name.reload_tip_text
	local var_49_13, var_49_14, var_49_15 = arg_49_0:_get_input_texture_data("weapon_reload_hold")
	local var_49_16 = var_49_12.style.text.text_color[1]
	local var_49_17 = string.format("{#color(193,91,36, %d)}", var_49_16)

	var_49_12.content.text = string.format(Localize("reload_tip"), var_49_17, var_49_14, "{#reset()}")

	local var_49_18 = var_49_9 + var_49_10 == var_49_6.ammo_data.max_ammo

	if var_49_3 and not var_49_18 then
		if arg_49_0._reload_attempts >= 3 then
			arg_49_0._reload_tip_text_shown = true

			if not arg_49_0._reload_tip_anim or arg_49_0._ui_animator:is_animation_completed(arg_49_0._reload_tip_anim) then
				arg_49_0._reload_tip_anim = arg_49_0._ui_animator:start_animation("show_reload_tip", var_49_12, var_0_1)
			end
		end

		arg_49_0:_update_reload_ui_state(arg_49_1, var_49_6)
	end

	arg_49_0:_set_widget_dirty(var_49_12)
end

function EquipmentUI._update_reload_ui_state(arg_50_0, arg_50_1, arg_50_2)
	if not arg_50_0._ammo_widgets_by_name.reload_tip_text then
		return
	end

	local var_50_0 = Managers.input:get_service("Player")
	local var_50_1 = 5

	if var_50_0:get("weapon_reload_hold") then
		if not arg_50_0._ui_animator:is_animation_completed(arg_50_0._reload_tip_anim) then
			return
		end

		if not arg_50_0._listening_timer_start then
			arg_50_0._listening_timer_start = arg_50_1
		end

		if not arg_50_0._reload_start_time then
			arg_50_0._reload_start_time = arg_50_1
		end
	else
		local var_50_2 = arg_50_2.actions.weapon_reload.default.anim_time_scale

		if arg_50_0._reload_start_time and var_50_2 > arg_50_1 - arg_50_0._reload_start_time then
			arg_50_0._reload_attempts = arg_50_0._reload_attempts + 1
		end

		if arg_50_0._reload_start_time then
			arg_50_0._reload_start_time = nil
		end
	end

	local var_50_3 = 0

	if arg_50_0._listening_timer_start then
		var_50_3 = arg_50_0._listening_timer_start + var_50_1
	end

	if var_50_3 ~= 0 and var_50_3 < arg_50_1 or arg_50_0._reload_tip_text_shown then
		arg_50_0._listening_timer_start = nil
		arg_50_0._reload_attempts = 0
		arg_50_0._reload_tip_text_shown = false
	end
end
