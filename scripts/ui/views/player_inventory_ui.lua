-- chunkname: @scripts/ui/views/player_inventory_ui.lua

local var_0_0 = local_require("scripts/ui/views/player_inventory_ui_definitions")

require("scripts/settings/inventory_settings")

PlayerInventoryUI = class(PlayerInventoryUI)

local var_0_1 = InventorySettings.weapon_slots
local var_0_2 = {}

for iter_0_0, iter_0_1 in ipairs(var_0_1) do
	local var_0_3 = iter_0_1.name

	if var_0_3 == "slot_melee" or var_0_3 == "slot_ranged" then
		var_0_2[iter_0_0] = iter_0_1
	end
end

local var_0_4 = {
	slot_healthkit = 1,
	slot_grenade = 3,
	slot_potion = 2
}
local var_0_5 = {
	slot_healthkit = "consumables_medpack",
	slot_grenade = "consumables_frag",
	slot_potion = "consumables_potion_01"
}
local var_0_6 = {}
local var_0_7 = {}
local var_0_8 = {}
local var_0_9 = {}
local var_0_10 = {}
local var_0_11 = {}
local var_0_12 = {}
local var_0_13 = {}
local var_0_14 = {}
local var_0_15 = {}
local var_0_16 = {}
local var_0_17 = {}
local var_0_18 = {}
local var_0_19 = {}
local var_0_20 = {}
local var_0_21 = {}
local var_0_22 = {}

function PlayerInventoryUI.init(arg_1_0, arg_1_1, arg_1_2)
	arg_1_0._parent = arg_1_1
	arg_1_0.platform = PLATFORM
	arg_1_0.ui_renderer = arg_1_2.ui_renderer
	arg_1_0.input_manager = arg_1_2.input_manager
	arg_1_0.slot_equip_animations = {}
	arg_1_0.slot_animations = {}
	arg_1_0.ui_animations = {}

	arg_1_0:create_ui_elements()

	arg_1_0.profile_synchronizer = arg_1_2.profile_synchronizer
	arg_1_0.peer_id = arg_1_2.peer_id
	arg_1_0.player_manager = arg_1_2.player_manager
	arg_1_0.render_settings = {
		snap_pixel_positions = true
	}
	arg_1_0._visible = not arg_1_0.input_manager:is_device_active("gamepad")
end

function PlayerInventoryUI.destroy(arg_2_0)
	arg_2_0:set_visible(false)
end

local var_0_23 = {
	var_0_0.top_inventory_widget_definition,
	var_0_0.inventory_widget_definition,
	var_0_0.small_inventory_widget_definition,
	var_0_0.small_inventory_widget_definition,
	var_0_0.small_inventory_widget_definition
}

function PlayerInventoryUI.create_ui_elements(arg_3_0)
	UIRenderer.clear_scenegraph_queue(arg_3_0.ui_renderer)

	local var_3_0 = var_0_0.inventory_entry_definitions

	arg_3_0.inventory_slots_widgets = {}

	for iter_3_0 = 1, #var_3_0 do
		arg_3_0.inventory_slots_widgets[iter_3_0] = UIWidget.init(var_3_0[iter_3_0])
	end

	arg_3_0.ui_scenegraph = UISceneGraph.init_scenegraph(var_0_0.scenegraph_definition)
	arg_3_0.inventory_widgets = {}

	for iter_3_1, iter_3_2 in ipairs(var_0_23) do
		if not var_0_10[iter_3_1] then
			var_0_10[iter_3_1] = "inventory_slot_" .. iter_3_1
		end

		iter_3_2.scenegraph_id = var_0_10[iter_3_1]
		arg_3_0.inventory_widgets[iter_3_1] = UIWidget.init(iter_3_2)
	end
end

function PlayerInventoryUI.set_visible(arg_4_0, arg_4_1)
	if arg_4_1 and arg_4_0.input_manager:is_device_active("gamepad") then
		arg_4_1 = false
	end

	for iter_4_0, iter_4_1 in ipairs(var_0_1) do
		local var_4_0 = arg_4_0.inventory_slots_widgets[iter_4_0]

		UIRenderer.set_element_visible(arg_4_0.ui_renderer, var_4_0.element, arg_4_1)
	end

	arg_4_0._visible = arg_4_1
end

local function var_0_24(arg_5_0, arg_5_1, arg_5_2)
	local var_5_0

	if not arg_5_2.ammo_data then
		return
	end

	local var_5_1 = arg_5_2.ammo_data.ammo_hand

	if var_5_1 == "right" then
		var_5_0 = ScriptUnit.extension(arg_5_1, "ammo_system")
	elseif var_5_1 == "left" then
		var_5_0 = ScriptUnit.extension(arg_5_0, "ammo_system")
	else
		return
	end

	local var_5_2 = var_5_0:using_single_clip()
	local var_5_3 = var_5_0:ammo_count()
	local var_5_4 = var_5_0:remaining_ammo()

	return var_5_3, not var_5_2 and var_5_4
end

function PlayerInventoryUI.overcharge_amount(arg_6_0, arg_6_1)
	local var_6_0 = ScriptUnit.extension(arg_6_1, "overcharge_system")
	local var_6_1 = var_6_0:overcharge_fraction()
	local var_6_2 = var_6_0:threshold_fraction()
	local var_6_3 = var_6_0:get_anim_blend_overcharge()

	return var_6_1, var_6_2, var_6_3
end

function PlayerInventoryUI.update(arg_7_0, arg_7_1, arg_7_2, arg_7_3)
	local var_7_0 = arg_7_0.ui_scenegraph
	local var_7_1 = arg_7_0.input_manager
	local var_7_2 = var_7_1:get_service("ingame_menu")
	local var_7_3 = var_7_1:is_device_active("gamepad")
	local var_7_4 = arg_7_0.ui_renderer

	if var_7_3 then
		if not arg_7_0.gamepad_active_last_frame then
			arg_7_0.gamepad_active_last_frame = true

			arg_7_0:on_gamepad_activated()
		end
	elseif arg_7_0.gamepad_active_last_frame then
		arg_7_0.gamepad_active_last_frame = false

		arg_7_0:on_gamepad_deactivated()
	end

	if arg_7_0.stance_bar_lit_animation then
		UIAnimation.update(arg_7_0.stance_bar_lit_animation, arg_7_1)

		if UIAnimation.completed(arg_7_0.stance_bar_lit_animation) then
			arg_7_0.stance_bar_lit_animation = nil
		end
	end

	for iter_7_0, iter_7_1 in pairs(arg_7_0.ui_animations) do
		UIAnimation.update(iter_7_1, arg_7_1)

		if UIAnimation.completed(iter_7_1) then
			arg_7_0.ui_animations[iter_7_0] = nil
		end
	end

	if not arg_7_0._visible then
		return
	end

	arg_7_0:update_slot_animations(arg_7_1)
	arg_7_0:update_inventory_slots_positions(arg_7_1)
	UIRenderer.begin_pass(var_7_4, var_7_0, var_7_2, arg_7_1, nil, arg_7_0.render_settings)

	if RESOLUTION_LOOKUP.modified then
		for iter_7_2, iter_7_3 in ipairs(var_0_1) do
			arg_7_0.inventory_slots_widgets[iter_7_2].element.dirty = true
		end
	end

	if arg_7_3 then
		local var_7_5 = arg_7_3:profile_index()

		if var_7_5 ~= arg_7_0.profile_index then
			arg_7_0.selected_index = nil
			arg_7_0.profile_index = var_7_5
		end

		arg_7_0:update_inventory_slots(arg_7_1, var_7_0, var_7_4, arg_7_3)
	end

	UIRenderer.end_pass(var_7_4)
end

function PlayerInventoryUI.on_gamepad_activated(arg_8_0)
	local var_8_0 = Application.user_setting("gamepad_layout")

	arg_8_0:set_visible(false)
end

function PlayerInventoryUI.on_gamepad_deactivated(arg_9_0)
	arg_9_0:set_visible(true)
end

function PlayerInventoryUI.update_inventory_slots(arg_10_0, arg_10_1, arg_10_2, arg_10_3, arg_10_4)
	local var_10_0 = arg_10_0.profile_synchronizer
	local var_10_1 = arg_10_4.player_unit
	local var_10_2
	local var_10_3 = UISettings.inventory_hud
	local var_10_4

	if var_10_1 then
		local var_10_5 = ScriptUnit.extension(var_10_1, "health_system")
		local var_10_6 = ScriptUnit.extension(var_10_1, "status_system")

		var_10_2 = ScriptUnit.extension(var_10_1, "inventory_system")
		var_10_4 = ScriptUnit.extension(var_10_1, "hud_system")
	end

	if var_10_2 then
		local var_10_7 = arg_10_0.inventory_widgets
		local var_10_8 = var_10_2:equipment()
		local var_10_9 = var_0_1
		local var_10_10 = var_10_8.wielded
		local var_10_11 = var_10_4:get_picked_up_ammo()

		if var_10_11 then
			var_10_4:set_picked_up_ammo(false)
		end

		for iter_10_0, iter_10_1 in ipairs(var_10_9) do
			local var_10_12 = iter_10_1.name
			local var_10_13 = var_10_8.slots[var_10_12]
			local var_10_14 = arg_10_0.inventory_slots_widgets[iter_10_0]
			local var_10_15 = var_10_14.content
			local var_10_16 = var_10_14.style

			if not var_10_13 then
				if var_10_15.has_data then
					var_10_15.has_data = nil
				end

				if var_10_15.ammo_text_1 ~= "" then
					var_10_15.ammo_text_1 = ""
					var_10_15.ammo_text_2 = ""
				end

				if var_10_15.stance_bar then
					var_10_15.stance_bar.active = false
				end

				if var_10_15.icon ~= "weapon_icon_empty" then
					var_10_15.icon = "weapon_icon_empty"
				end
			else
				local var_10_17 = var_10_13.item_data
				local var_10_18 = var_10_10 == var_10_13.item_data
				local var_10_19 = false
				local var_10_20 = var_10_17 and var_10_17.name or "no_master_item_found"
				local var_10_21 = var_10_17 and var_10_17.hud_icon or var_0_5[var_10_12]

				if not var_0_15[var_10_21] then
					var_0_15[var_10_21] = var_10_21 .. "_lit"
				end

				if var_10_15.icon ~= var_10_21 then
					var_10_14.element.dirty = true
					var_10_15.icon = var_10_21

					assert(var_10_15.icon, "No hud icon for weapon %s", var_10_20)

					var_10_15.icon_lit = var_0_15[var_10_21]
				end

				if var_10_18 and arg_10_0:on_inventory_selected_slot_changed(iter_10_0) then
					local var_10_22 = var_0_0.bar_textures
					local var_10_23, var_10_24 = arg_10_0:overcharge_amount(var_10_1)

					if not var_10_23 then
						var_10_15.stance_bar.texture_id = var_10_22.stance_bar.bar
						var_10_15.stance_bar_glow = var_10_22.stance_bar.glow
					else
						var_10_15.stance_bar.texture_id = var_10_22.charge_bar.bar
						var_10_15.stance_bar_glow = var_10_22.charge_bar.glow
					end
				end

				if not var_10_15.has_data then
					var_10_15.has_data = true
				end

				local var_10_25 = BackendUtils.get_item_template(var_10_17)
				local var_10_26, var_10_27 = var_0_24(var_10_13.left_unit_1p, var_10_13.right_unit_1p, var_10_25)

				if var_10_26 then
					local var_10_28 = var_10_25.ammo_data

					if var_10_28 and not var_10_28.destroy_when_out_of_ammo then
						local var_10_29 = tostring(var_10_26)
						local var_10_30 = var_10_27 and tostring(var_10_27) or ""

						if var_10_29 ~= var_10_15.ammo_text_1 or var_10_30 ~= var_10_15.ammo_text_2 then
							var_10_14.element.dirty = true
							var_10_15.ammo_text_1 = var_10_29
							var_10_15.ammo_text_2 = var_10_30
						end

						if not var_0_11[var_10_12] then
							var_0_11[var_10_12] = var_10_12 .. "ammo_text_1_flash"
							var_0_12[var_10_12] = var_10_12 .. "ammo_text_2_flash"
							var_0_13[var_10_12] = var_10_12 .. "ammo_text_1_pulse"
							var_0_14[var_10_12] = var_10_12 .. "ammo_text_2_pulse"
						end

						if var_10_11 then
							arg_10_0.ui_animations[var_0_11[var_10_12]] = UIAnimation.init(UIAnimation.text_flash, var_10_16.ammo_text_1.text_color, 1, 255, 200, 5, 0.7)
							arg_10_0.ui_animations[var_0_12[var_10_12]] = UIAnimation.init(UIAnimation.text_flash, var_10_16.ammo_text_2.text_color, 1, 255, 200, 5, 0.7)
							arg_10_0.ui_animations[var_0_13[var_10_12]] = UIAnimation.init(UIAnimation.pulse_animation3, var_10_16.ammo_text_1, "font_size", 26, 24, 5, 0.7)
							arg_10_0.ui_animations[var_0_14[var_10_12]] = UIAnimation.init(UIAnimation.pulse_animation3, var_10_16.ammo_text_2, "font_size", 26, 24, 5, 0.7)
						end
					else
						var_10_15.ammo_text_1 = ""
						var_10_15.ammo_text_2 = ""
					end

					var_10_15.stance_bar.active = false
				else
					local var_10_31
					local var_10_32, var_10_33, var_10_34 = arg_10_0:overcharge_amount(var_10_1)

					if var_10_32 then
						var_10_31 = math.min(var_10_32, 1)
					else
						var_10_31 = 0
					end

					local var_10_35 = math.lerp(var_10_15.stance_bar.bar_value, math.min(var_10_31, 1), 0.3)

					var_10_15.stance_bar.active = var_10_17.slot_type ~= "melee" and true or false
					var_10_15.stance_bar.bar_value = var_10_35

					if not var_0_6[var_10_12] then
						var_0_6[var_10_12] = var_10_12 .. "stance_bar_glow_pulse"
						var_0_7[var_10_12] = var_10_12 .. "stance_bar_lit_glow_out"
						var_0_8[var_10_12] = var_10_12 .. "stance_bar_glow_fade_out"
					end

					if not arg_10_0.ui_animations[var_0_6[var_10_12]] and var_10_35 >= 1 then
						arg_10_0.ui_animations[var_0_6[var_10_12]] = UIAnimation.init(UIAnimation.pulse_animation, var_10_16.stance_bar_glow.color, 1, 0, 255, var_10_3.bar_lit_pulse_duration)
					elseif arg_10_0.ui_animations[var_0_6[var_10_12]] and not arg_10_0.ui_animations[var_0_7[var_10_12]] and var_10_35 < 1 then
						arg_10_0.ui_animations[var_0_6[var_10_12]] = nil
						arg_10_0.ui_animations[var_0_8[var_10_12]] = UIAnimation.init(UIAnimation.function_by_time, var_10_16.stance_bar_glow.color, 1, var_10_16.stance_bar_glow.color[1], 0, var_10_3.bar_lit_fade_out_duration, math.easeInCubic)
					end

					var_10_15.ammo_text_1 = ""
					var_10_15.ammo_text_2 = ""
				end

				local var_10_36 = -26
				local var_10_37 = -5

				if not var_0_9[iter_10_0] then
					var_0_9[iter_10_0] = "inventory_entry_root_" .. iter_10_0
				end

				if var_10_15.stance_bar.active then
					if arg_10_0.ui_scenegraph[var_0_9[iter_10_0]].local_position[1] ~= var_10_36 then
						arg_10_0.ui_scenegraph[var_0_9[iter_10_0]].local_position[1] = var_10_36
					end
				elseif arg_10_0.ui_scenegraph[var_0_9[iter_10_0]].local_position[1] ~= var_10_37 then
					arg_10_0.ui_scenegraph[var_0_9[iter_10_0]].local_position[1] = var_10_37
				end
			end

			UIRenderer.draw_widget(arg_10_3, var_10_14)
		end
	end
end

function PlayerInventoryUI.update_inventory_slots_positions(arg_11_0, arg_11_1)
	local var_11_0 = var_0_0.scenegraph_definition

	if not arg_11_0.selected_index then
		local var_11_1 = 0
	end

	local var_11_2 = arg_11_0.previous_selected_index
	local var_11_3 = arg_11_0.ui_scenegraph
	local var_11_4 = UISettings.inventory_hud.slot_spacing
	local var_11_5 = 0

	for iter_11_0 = #var_0_1, 1, -1 do
		local var_11_6 = var_0_1[iter_11_0].name
		local var_11_7 = (var_0_4[var_11_6] and true or false) and 0.9 or 0.6

		if not var_0_16[iter_11_0] then
			var_0_16[iter_11_0] = "inventory_entry_background_" .. iter_11_0
		end

		local var_11_8 = var_0_16[iter_11_0]
		local var_11_9 = arg_11_0.inventory_slots_widgets[iter_11_0]
		local var_11_10 = iter_11_0 - 1
		local var_11_11 = arg_11_0.inventory_slots_widgets[var_11_10]
		local var_11_12 = var_11_3[var_11_8].size[2] * var_11_7

		if not var_0_9[iter_11_0] then
			var_0_9[iter_11_0] = "inventory_entry_root_" .. iter_11_0
		end

		var_11_3[var_0_9[iter_11_0]].position[2] = var_11_5 + var_11_12 * 0.5
		var_11_5 = var_11_5 + var_11_12 + var_11_4
	end
end

function PlayerInventoryUI.on_inventory_selected_slot_changed(arg_12_0, arg_12_1)
	if arg_12_0.selected_index == arg_12_1 then
		return
	end

	local var_12_0 = arg_12_0:add_animation_for_slot_index(arg_12_1, true)

	for iter_12_0 = 1, #var_0_1 do
		if iter_12_0 ~= arg_12_1 then
			arg_12_0:add_animation_for_slot_index(iter_12_0, false, var_12_0)
		end
	end

	arg_12_0.previous_selected_index = arg_12_0.selected_index
	arg_12_0.selected_index = arg_12_1

	return true
end

function PlayerInventoryUI.add_animation_for_slot_index(arg_13_0, arg_13_1, arg_13_2, arg_13_3)
	local var_13_0 = arg_13_0.slot_animations
	local var_13_1 = arg_13_0.ui_scenegraph
	local var_13_2 = var_0_0.scenegraph_definition

	if not var_0_17[arg_13_1] then
		var_0_17[arg_13_1] = "inventory_entry_" .. arg_13_1
		var_0_18[arg_13_1] = "inventory_entry_icon_" .. arg_13_1
	end

	local var_13_3 = var_0_17[arg_13_1]
	local var_13_4 = var_0_18[arg_13_1]
	local var_13_5 = arg_13_0.inventory_slots_widgets[arg_13_1]
	local var_13_6 = var_13_1[var_13_4].size
	local var_13_7 = var_0_0.scenegraph_definition[var_13_4].size[1]
	local var_13_8 = UISettings.inventory_hud.select_animation_duration
	local var_13_9 = arg_13_3 or 0

	if arg_13_2 then
		if not arg_13_3 then
			var_13_9 = (1 - (var_13_6[1] - var_13_7) / var_13_7) * var_13_8
		end

		arg_13_0.animating_selected_slot = true
	elseif not arg_13_3 then
		for iter_13_0, iter_13_1 in pairs(var_13_0) do
			if iter_13_1.selected then
				var_13_9 = iter_13_1.total_time - iter_13_1.time

				break
			end
		end
	end

	local var_13_10 = var_13_1[var_13_4].size
	local var_13_11 = var_0_0.scenegraph_definition[var_13_4].size
	local var_13_12 = var_13_10[1] / var_13_11[1]

	if var_13_0[var_13_3] then
		local var_13_13 = var_13_0[var_13_3]

		var_13_13.total_time = var_13_9
		var_13_13.time = 0
		var_13_13.selected = arg_13_2
		var_13_13.icon_start_size = var_13_1[var_13_4].size
		var_13_13.start_alpha = var_13_5.style.icon.color[1]
		var_13_13.start_selected_alpha = var_13_5.style.background_lit.color[1]
		var_13_13.start_scale_fraction = var_13_12
		var_13_13.target_scale_fraction = arg_13_2 and 1 or 0.8
	else
		var_13_0[var_13_3] = {
			time = 0,
			total_time = var_13_9,
			widget = arg_13_0.inventory_slots_widgets[arg_13_1],
			scenegraph_id = var_13_3,
			start_scale_fraction = var_13_12,
			target_scale_fraction = arg_13_2 and 1 or 0.8,
			start_size = var_13_1[var_13_4].size,
			start_alpha = var_13_5.style.icon.color[1],
			start_selected_alpha = var_13_5.style.background_lit.color[1],
			selected = arg_13_2,
			index = arg_13_1
		}
	end

	return var_13_9
end

function PlayerInventoryUI.update_slot_animations(arg_14_0, arg_14_1)
	local var_14_0 = arg_14_0.slot_animations

	for iter_14_0, iter_14_1 in pairs(var_14_0) do
		var_14_0[iter_14_0] = arg_14_0:animate_slot_widget(iter_14_1, arg_14_1)
	end
end

function PlayerInventoryUI.animate_slot_widget(arg_15_0, arg_15_1, arg_15_2)
	local var_15_0 = arg_15_0.ui_scenegraph
	local var_15_1 = var_0_0.scenegraph_definition
	local var_15_2 = arg_15_1.widget
	local var_15_3 = arg_15_1.total_time
	local var_15_4 = arg_15_1.time
	local var_15_5 = arg_15_1.selected
	local var_15_6 = arg_15_1.index
	local var_15_7 = arg_15_1.start_size
	local var_15_8 = arg_15_1.start_alpha
	local var_15_9 = arg_15_1.start_scale_fraction
	local var_15_10 = arg_15_1.target_scale_fraction
	local var_15_11 = arg_15_1.start_selected_alpha
	local var_15_12 = var_15_2.content
	local var_15_13 = var_15_2.style
	local var_15_14 = UISettings.inventory_hud
	local var_15_15 = var_15_4 + arg_15_2
	local var_15_16 = math.min(var_15_15 / var_15_3, 1)
	local var_15_17 = math.smoothstep(var_15_16, 0, 1)
	local var_15_18 = math.min(var_15_16 * 2, 1)
	local var_15_19 = math.smoothstep(var_15_18, 0, 1)
	local var_15_20 = var_15_5 and math.min(math.max(0, (var_15_16 - 0.8) / 0.2), 1) or math.min(math.max(0, var_15_16 / 0.2), 1)

	if not var_0_17[var_15_6] then
		var_0_17[var_15_6] = "inventory_entry_" .. var_15_6
		var_0_16[var_15_6] = "inventory_entry_background_" .. var_15_6
		var_0_18[var_15_6] = "inventory_entry_icon_" .. var_15_6
	end

	if not var_0_19[var_15_6] then
		var_0_19[var_15_6] = "inventory_entry_stance_bar_" .. var_15_6
		var_0_20[var_15_6] = "inventory_entry_stance_bar_fill_" .. var_15_6
		var_0_21[var_15_6] = "inventory_entry_stance_bar_lit_" .. var_15_6
		var_0_22[var_15_6] = "inventory_entry_stance_bar_glow_" .. var_15_6
	end

	local var_15_21 = var_0_17[var_15_6]
	local var_15_22 = var_0_16[var_15_6]
	local var_15_23 = var_0_18[var_15_6]
	local var_15_24 = var_0_19[var_15_6]
	local var_15_25 = var_0_20[var_15_6]
	local var_15_26 = var_0_21[var_15_6]
	local var_15_27 = var_0_22[var_15_6]
	local var_15_28 = var_15_0[var_15_21]
	local var_15_29 = var_15_0[var_15_23]
	local var_15_30 = var_15_0[var_15_22]

	var_15_2.element.dirty = true

	local var_15_31 = var_15_5 and var_15_10 - var_15_9 or var_15_9 - var_15_10
	local var_15_32 = var_15_5 and var_15_9 + var_15_31 * var_15_17 or var_15_9 - var_15_31 * var_15_17
	local var_15_33 = var_15_1[var_15_23].size

	var_15_29.size[1] = var_15_33[1] * var_15_32
	var_15_29.size[2] = var_15_33[2] * var_15_32

	local var_15_34 = var_15_1[var_15_22].size

	var_15_30.size[1] = var_15_34[1] * var_15_32
	var_15_30.size[2] = var_15_34[2] * var_15_32

	local var_15_35 = 0

	if var_15_5 then
		var_15_35 = var_15_11 + (255 - var_15_11) * var_15_19
	else
		var_15_35 = var_15_11 - var_15_11 * var_15_19
	end

	var_15_13.background_lit.color[1] = var_15_35
	var_15_13.background_lit.color[1] = var_15_35
	var_15_13.icon_lit.color[1] = var_15_35
	var_15_13.icon.color[1] = 255 - var_15_35
	var_15_13.stance_bar_lit.color[1] = var_15_35
	var_15_13.stance_bar_fg.color[1] = 255 - var_15_35

	local var_15_36 = var_15_0[var_15_24]
	local var_15_37 = var_15_1[var_15_24].size

	var_15_36.size[1] = var_15_37[1] * var_15_32
	var_15_36.size[2] = var_15_37[2] * var_15_32

	local var_15_38 = var_15_0[var_15_25]
	local var_15_39 = var_15_1[var_15_25]
	local var_15_40 = var_15_39.size
	local var_15_41 = var_15_39.position

	var_15_38.size[1] = var_15_40[1] * var_15_32
	var_15_38.size[2] = var_15_40[2] * var_15_32
	var_15_38.local_position[1] = var_15_41[1] * var_15_32
	var_15_38.local_position[2] = var_15_41[2] * var_15_32
	var_15_13.stance_bar.uv_scale_pixels = 67 * var_15_32

	local var_15_42 = var_15_0[var_15_27]
	local var_15_43 = var_15_1[var_15_27].size

	var_15_42.size[1] = var_15_43[1] * var_15_32
	var_15_42.size[2] = var_15_43[2] * var_15_32

	local var_15_44 = var_15_14.slot_default_alpha
	local var_15_45 = var_15_14.slot_select_alpha
	local var_15_46 = var_15_5 and var_15_45 or var_15_44
	local var_15_47 = var_15_13.icon

	if var_15_47.color[1] ~= var_15_46 then
		local var_15_48 = var_15_5 and var_15_46 - var_15_8 or var_15_8 - var_15_46
		local var_15_49 = var_15_5 and var_15_8 + var_15_48 * var_15_17 or var_15_8 - var_15_48 * var_15_17

		var_15_47.color[1] = var_15_49

		local var_15_50 = var_15_13.ammo_text_1
		local var_15_51 = var_15_13.stance_bar

		if not var_15_5 or not (var_15_20 * var_15_46) then
			local var_15_52 = (1 - var_15_20) * var_15_45
		end

		var_15_51.color[1] = var_15_49
		var_15_50.text_color[1] = var_15_49
	end

	if var_15_16 < 1 then
		arg_15_1.time = var_15_15

		if var_15_5 and not var_15_12.selected and var_15_16 > 0.8 then
			var_15_12.selected = var_15_5
		elseif not var_15_5 and var_15_2.content.selected and var_15_20 == 1 then
			var_15_2.content.selected = var_15_5
		end

		return arg_15_1
	else
		if var_15_5 then
			arg_15_0.animating_selected_slot = nil
		end

		return nil
	end
end
