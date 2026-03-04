-- chunkname: @scripts/ui/views/hero_view/windows/hero_window_cosmetics_loadout_pose_inventory_console.lua

local var_0_0 = local_require("scripts/ui/views/hero_view/windows/definitions/hero_window_cosmetics_loadout_pose_inventory_console_definitions")
local var_0_1 = var_0_0.widgets
local var_0_2 = var_0_0.category_settings
local var_0_3 = var_0_0.scenegraph_definition
local var_0_4 = var_0_0.animation_definitions
local var_0_5 = var_0_0.generic_input_actions
local var_0_6 = var_0_0.create_illusion_button
local var_0_7 = var_0_0.weapon_illusion_base_widgets
local var_0_8 = false
local var_0_9 = "trigger_cycle_next"
local var_0_10 = "trigger_cycle_previous"

local function var_0_11(arg_1_0, arg_1_1)
	local var_1_0 = arg_1_0.data
	local var_1_1 = arg_1_1.data
	local var_1_2 = var_1_0.key
	local var_1_3 = var_1_1.key
	local var_1_4 = arg_1_0.power_level or 0
	local var_1_5 = arg_1_1.power_level or 0
	local var_1_6 = arg_1_0.backend_id
	local var_1_7 = arg_1_1.backend_id
	local var_1_8 = ItemHelper.is_favorite_backend_id(var_1_6, arg_1_0)

	if var_1_8 == ItemHelper.is_favorite_backend_id(var_1_7, arg_1_1) then
		if var_1_4 == var_1_5 then
			local var_1_9 = arg_1_0.rarity or var_1_0.rarity
			local var_1_10 = arg_1_1.rarity or var_1_1.rarity
			local var_1_11 = UISettings.item_rarity_order
			local var_1_12 = var_1_11[var_1_9]
			local var_1_13 = var_1_11[var_1_10]

			if var_1_12 == var_1_13 then
				local var_1_14 = Localize(var_1_0.item_type)
				local var_1_15 = Localize(var_1_1.item_type)

				if var_1_14 == var_1_15 then
					local var_1_16, var_1_17 = UIUtils.get_ui_information_from_item(arg_1_0)
					local var_1_18, var_1_19 = UIUtils.get_ui_information_from_item(arg_1_1)

					return Localize(var_1_17) < Localize(var_1_19)
				else
					return var_1_14 < var_1_15
				end
			else
				return var_1_12 < var_1_13
			end
		else
			return var_1_5 < var_1_4
		end
	elseif var_1_8 then
		return true
	else
		return false
	end
end

HeroWindowCosmeticsLoadoutPoseInventoryConsole = class(HeroWindowCosmeticsLoadoutPoseInventoryConsole)
HeroWindowCosmeticsLoadoutPoseInventoryConsole.NAME = "HeroWindowCosmeticsLoadoutPoseInventoryConsole"

function HeroWindowCosmeticsLoadoutPoseInventoryConsole.on_enter(arg_2_0, arg_2_1, arg_2_2)
	print("[HeroViewWindow] Enter Substate HeroWindowCosmeticsLoadoutPoseInventoryConsole")

	arg_2_0._params = arg_2_1
	arg_2_0._parent = arg_2_1.parent

	local var_2_0 = arg_2_1.ingame_ui_context

	arg_2_0._ui_renderer = var_2_0.ui_renderer
	arg_2_0._ui_top_renderer = var_2_0.ui_top_renderer
	arg_2_0._input_manager = var_2_0.input_manager
	arg_2_0._statistics_db = var_2_0.statistics_db
	arg_2_0._render_settings = {
		snap_pixel_positions = true
	}
	arg_2_0._world_previewer = arg_2_1.world_previewer

	local var_2_1 = Managers.player
	local var_2_2 = var_2_1:local_player()

	arg_2_0._stats_id = var_2_2:stats_id()
	arg_2_0._player_manager = var_2_1
	arg_2_0._peer_id = var_2_0.peer_id
	arg_2_0._hero_name = arg_2_1.hero_name
	arg_2_0._career_index = arg_2_1.career_index
	arg_2_0._profile_index = arg_2_1.profile_index
	arg_2_0._career_name = SPProfiles[arg_2_0._profile_index].careers[arg_2_0._career_index].name
	arg_2_0._current_input_description = "default"
	arg_2_0._animations = {}

	arg_2_0:create_ui_elements(arg_2_1, arg_2_2)
	arg_2_0:_setup_input_buttons()

	local var_2_3 = {
		profile_index = arg_2_1.profile_index,
		career_index = arg_2_1.career_index
	}
	local var_2_4 = ItemGridUI:new(var_0_2, arg_2_0._widgets_by_name.item_grid, arg_2_0._hero_name, arg_2_0._career_index, var_2_3)

	arg_2_0._item_grid = var_2_4

	var_2_4:mark_locked_items(true)
	var_2_4:disable_locked_items(true)
	var_2_4:disable_unwieldable_items(true)
	var_2_4:mark_equipped_weapon_pose_parent(true)
	var_2_4:disable_item_drag()
	var_2_4:apply_item_sorting_function(var_0_11)
	arg_2_0:_set_item_compare_enable_state(false)
	arg_2_0:_show_equipped_weapon_pose()

	local var_2_5 = var_2_2 and var_2_2.player_unit

	if var_2_5 then
		local var_2_6 = ScriptUnit.has_extension(var_2_5, "inventory_system")

		if var_2_6 then
			var_2_6:check_and_drop_pickups("enter_inventory")
		end
	end

	arg_2_0:_start_transition_animation("on_enter")
end

function HeroWindowCosmeticsLoadoutPoseInventoryConsole._show_equipped_weapon_pose(arg_3_0)
	local var_3_0 = Managers.backend:get_interface("items")
	local var_3_1 = var_3_0:get_loadout_item_id(arg_3_0._career_name, "slot_pose")

	if not var_3_1 then
		return
	end

	local var_3_2 = var_3_0:get_item_from_id(var_3_1).data
	local var_3_3 = var_3_2.parent
	local var_3_4 = rawget(ItemMasterList, var_3_3)

	if var_3_4 then
		local var_3_5 = table.clone(var_3_4)
		local var_3_6 = var_3_0:get_equipped_weapon_pose_skin(var_3_3)
		local var_3_7

		if var_3_6 then
			var_3_7 = var_3_6
		end

		arg_3_0._parent:set_temporary_loadout_item({
			data = var_3_5,
			skin = var_3_7
		})
		arg_3_0._parent:set_character_pose_animation(var_3_2.data.anim_event)
	end
end

local var_0_12 = {}

function HeroWindowCosmeticsLoadoutPoseInventoryConsole._start_transition_animation(arg_4_0, arg_4_1, arg_4_2)
	local var_4_0 = {
		wwise_world = arg_4_0.wwise_world,
		render_settings = arg_4_0._render_settings
	}
	local var_4_1 = arg_4_2 or var_0_12
	local var_4_2 = arg_4_0.ui_animator:start_animation(arg_4_1, var_4_1, var_0_3, var_4_0)

	arg_4_0._animations[arg_4_1] = var_4_2
end

function HeroWindowCosmeticsLoadoutPoseInventoryConsole.create_ui_elements(arg_5_0, arg_5_1, arg_5_2)
	arg_5_0.ui_scenegraph = UISceneGraph.init_scenegraph(var_0_3)

	local var_5_0 = {}
	local var_5_1 = {}

	for iter_5_0, iter_5_1 in pairs(var_0_1) do
		local var_5_2 = UIWidget.init(iter_5_1)

		var_5_0[#var_5_0 + 1] = var_5_2
		var_5_1[iter_5_0] = var_5_2
	end

	arg_5_0._widgets = var_5_0
	arg_5_0._widgets_by_name = var_5_1
	arg_5_0._illusion_widgets = {}
	arg_5_0._illusion_base_widgets = {}

	local var_5_3 = Managers.input:get_service("hero_view")
	local var_5_4 = UILayer.controller_description

	arg_5_0._menu_input_description = MenuInputDescriptionUI:new(nil, arg_5_0._ui_top_renderer, var_5_3, 7, var_5_4, var_0_5.default, true)

	arg_5_0._menu_input_description:set_input_description(nil)
	UIRenderer.clear_scenegraph_queue(arg_5_0._ui_renderer)

	arg_5_0.ui_animator = UIAnimator:new(arg_5_0.ui_scenegraph, var_0_4)

	if arg_5_2 then
		local var_5_5 = arg_5_0.ui_scenegraph.window.local_position

		var_5_5[1] = var_5_5[1] + arg_5_2[1]
		var_5_5[2] = var_5_5[2] + arg_5_2[2]
		var_5_5[3] = var_5_5[3] + arg_5_2[3]
	end

	var_5_1.item_tooltip.content.profile_index = arg_5_0._params.profile_index
	var_5_1.item_tooltip.content.career_index = arg_5_0._params.career_index
	var_5_1.item_tooltip_compare.content.profile_index = arg_5_0._params.profile_index
	var_5_1.item_tooltip_compare.content.career_index = arg_5_0._params.career_index
end

function HeroWindowCosmeticsLoadoutPoseInventoryConsole._input_service(arg_6_0)
	local var_6_0 = arg_6_0._parent

	if var_6_0:is_friends_list_active() then
		return FAKE_INPUT_SERVICE
	end

	return var_6_0:window_input_service()
end

function HeroWindowCosmeticsLoadoutPoseInventoryConsole.set_focus(arg_7_0, arg_7_1)
	arg_7_0._focused = arg_7_1
	arg_7_0._render_settings.alpha_multiplier = arg_7_1 and 1 or 0.5
	arg_7_0._widgets_by_name.item_tooltip.content.visible = arg_7_1
end

function HeroWindowCosmeticsLoadoutPoseInventoryConsole.on_exit(arg_8_0, arg_8_1)
	print("[HeroViewWindow] Exit Substate HeroWindowCosmeticsLoadoutPoseInventoryConsole")

	arg_8_0.ui_animator = nil

	arg_8_0._item_grid:destroy()

	arg_8_0._item_grid = nil

	arg_8_0._menu_input_description:destroy()

	arg_8_0._menu_input_description = nil

	arg_8_0._parent:set_character_pose_animation(nil)
	arg_8_0._parent:clear_temporary_loadout()
end

function HeroWindowCosmeticsLoadoutPoseInventoryConsole.update(arg_9_0, arg_9_1, arg_9_2)
	if var_0_8 then
		var_0_8 = false

		arg_9_0:create_ui_elements()
	end

	arg_9_0._item_grid:update(arg_9_1, arg_9_2)
	arg_9_0:_update_animations(arg_9_1)
	arg_9_0:_update_selected_cosmetic_slot_index()
	arg_9_0:_update_loadout_sync()
	arg_9_0:_update_page_info()
	arg_9_0:_update_input_description()
	arg_9_0:_update_illusions(arg_9_1, arg_9_2)
	arg_9_0:_update_remove_button_state(arg_9_1, arg_9_2)

	if arg_9_0._focused then
		arg_9_0:_handle_gamepad_activity()
		arg_9_0:_update_selected_item_tooltip()
		arg_9_0:_handle_input(arg_9_1, arg_9_2)
		arg_9_0:_handle_gamepad_input(arg_9_1, arg_9_2)
	end

	arg_9_0:draw(arg_9_1)
end

function HeroWindowCosmeticsLoadoutPoseInventoryConsole.post_update(arg_10_0, arg_10_1, arg_10_2)
	return
end

function HeroWindowCosmeticsLoadoutPoseInventoryConsole._update_illusions(arg_11_0, arg_11_1, arg_11_2)
	local var_11_0 = arg_11_0._illusion_widgets

	if table.is_empty(var_11_0) then
		return
	end

	local var_11_1 = arg_11_0._widgets_by_name
	local var_11_2 = false

	for iter_11_0, iter_11_1 in ipairs(var_11_0) do
		if UIUtils.is_button_pressed(iter_11_1) then
			local var_11_3 = false
			local var_11_4 = true

			arg_11_0:_on_illusion_index_pressed(iter_11_0, var_11_3, var_11_4)

			return
		elseif UIUtils.is_button_hover_enter(iter_11_1) then
			arg_11_0:_play_sound("play_gui_equipment_inventory_hover")

			local var_11_5 = iter_11_1.content.skin_key
			local var_11_6 = WeaponSkins.skins[var_11_5]

			arg_11_0._widgets_by_name.illusions_name.content.text = Localize(var_11_6.display_name)

			return
		elseif UIUtils.is_button_hover(iter_11_1) then
			var_11_2 = true
		end
	end

	if not var_11_2 then
		local var_11_7 = var_11_0[arg_11_0._selected_skin_index].content.skin_key
		local var_11_8 = WeaponSkins.skins[var_11_7]

		var_11_1.illusions_name.content.text = Localize(var_11_8.display_name)
	end

	if UIUtils.is_button_pressed(var_11_1.apply_illusion_button) then
		arg_11_0:_apply_illusion()
	end
end

function HeroWindowCosmeticsLoadoutPoseInventoryConsole._update_remove_button_state(arg_12_0, arg_12_1, arg_12_2)
	local var_12_0 = Managers.backend:get_interface("items")
	local var_12_1 = BackendUtils.get_loadout_item_id(arg_12_0._career_name, "slot_pose")
	local var_12_2 = var_12_1 and var_12_0:get_item_from_id(var_12_1)
	local var_12_3 = var_12_2 and var_12_2.key
	local var_12_4 = arg_12_0._widgets_by_name.button_remove

	UIUtils.enable_button(var_12_4, not var_12_3 or var_12_3 ~= "default_weapon_pose_01")
end

function HeroWindowCosmeticsLoadoutPoseInventoryConsole._apply_illusion(arg_13_0)
	local var_13_0 = arg_13_0._illusion_widgets[arg_13_0._selected_skin_index].content

	if not var_13_0.locked then
		local var_13_1 = var_13_0.skin_key
		local var_13_2 = ItemMasterList[var_13_1]
		local var_13_3 = Managers.backend:get_interface("items")
		local var_13_4 = string.gsub(arg_13_0._selected_blueprint_name, "^vs_", "")

		if var_13_2.matching_item_key == var_13_4 then
			local var_13_5, var_13_6 = var_13_3:get_weapon_skin_from_skin_key(var_13_1)

			var_13_3:set_weapon_pose_skin(var_13_4, var_13_5)

			local var_13_7 = true
			local var_13_8 = true

			arg_13_0:_select_illusion_by_key(var_13_1, var_13_7, var_13_8)

			local var_13_9 = var_13_3:get_loadout_item_id(arg_13_0._career_name, "slot_pose")
			local var_13_10 = var_13_3:get_item_from_id(var_13_9)
			local var_13_11 = var_13_10 and var_13_10.data

			if var_13_4 == (var_13_11 and var_13_11.parent) then
				local var_13_12 = Managers.player:local_player()

				CosmeticUtils.update_cosmetic_slot(var_13_12, "slot_pose", var_13_10.key)
			end
		end
	end
end

function HeroWindowCosmeticsLoadoutPoseInventoryConsole._update_input_description(arg_14_0)
	local var_14_0 = "default"

	if arg_14_0._selected_blueprint_name then
		var_14_0 = arg_14_0._gamepad_illusion_buttons_active and (arg_14_0._widgets_by_name.apply_illusion_button.content.visible and "apply_weapon_skin" or "weapon_skin") or "pose_selection"
	end

	if var_14_0 ~= arg_14_0._current_input_description then
		arg_14_0._menu_input_description:change_generic_actions(var_0_5[var_14_0])

		arg_14_0._current_input_description = var_14_0
	end
end

function HeroWindowCosmeticsLoadoutPoseInventoryConsole._set_item_compare_enable_state(arg_15_0, arg_15_1)
	arg_15_0._widgets_by_name.item_tooltip_compare.content.visible = arg_15_1
	arg_15_0._draw_item_compare = arg_15_1
end

function HeroWindowCosmeticsLoadoutPoseInventoryConsole._update_equipped_item_tooltip(arg_16_0)
	local var_16_0 = arg_16_0._selected_cosmetic_slot_index
	local var_16_1 = InventorySettings.slots_by_cosmetic_index[var_16_0].name
	local var_16_2 = Managers.backend:get_interface("items")
	local var_16_3 = BackendUtils.get_loadout_item_id(arg_16_0._career_name, var_16_1)
	local var_16_4 = var_16_3 and var_16_2:get_item_from_id(var_16_3)

	arg_16_0._widgets_by_name.item_tooltip_compare.content.item = var_16_4
end

function HeroWindowCosmeticsLoadoutPoseInventoryConsole._update_selected_item_tooltip(arg_17_0)
	local var_17_0 = arg_17_0._item_grid:selected_item()
	local var_17_1 = var_17_0 and var_17_0.backend_id

	if var_17_1 ~= arg_17_0._selected_backend_id then
		arg_17_0._widgets_by_name.item_tooltip.content.item = var_17_0
	end

	arg_17_0._selected_backend_id = var_17_1
end

function HeroWindowCosmeticsLoadoutPoseInventoryConsole._update_animations(arg_18_0, arg_18_1)
	arg_18_0.ui_animator:update(arg_18_1)

	local var_18_0 = arg_18_0._animations
	local var_18_1 = arg_18_0.ui_animator

	for iter_18_0, iter_18_1 in pairs(var_18_0) do
		if var_18_1:is_animation_completed(iter_18_1) then
			var_18_1:stop_animation(iter_18_1)

			var_18_0[iter_18_0] = nil
		end
	end

	local var_18_2 = arg_18_0._widgets_by_name
	local var_18_3 = var_18_2.page_button_next
	local var_18_4 = var_18_2.page_button_previous

	UIWidgetUtils.animate_arrow_button(var_18_3, arg_18_1)
	UIWidgetUtils.animate_arrow_button(var_18_4, arg_18_1)

	if not table.is_empty(arg_18_0._illusion_base_widgets) then
		UIWidgetUtils.animate_default_button(var_18_2.apply_illusion_button, arg_18_1)
	end

	UIWidgetUtils.animate_default_button(var_18_2.button_remove, arg_18_1)
end

function HeroWindowCosmeticsLoadoutPoseInventoryConsole._handle_gamepad_input(arg_19_0, arg_19_1, arg_19_2)
	if Managers.input:is_device_active("mouse") then
		return
	end

	local var_19_0 = arg_19_0._parent
	local var_19_1 = arg_19_0:_input_service()
	local var_19_2 = arg_19_0._item_grid

	if arg_19_0._gamepad_illusion_buttons_active then
		local var_19_3 = arg_19_0._selected_skin_index
		local var_19_4 = arg_19_0._illusion_widgets

		if var_19_1:get("special_1", true) or var_19_1:get("back_menu", true) then
			arg_19_0:_toggle_gamepad_illusion_buttons()

			return
		elseif var_19_1:get("confirm", true) then
			arg_19_0:_apply_illusion()

			return
		end

		local var_19_5 = false

		if var_19_3 > 1 and var_19_1:get("move_left_hold_continuous") then
			var_19_3 = var_19_3 - 1
			var_19_5 = true
		elseif var_19_3 < #var_19_4 and var_19_1:get("move_right_hold_continuous") then
			var_19_3 = var_19_3 + 1
			var_19_5 = true
		end

		if var_19_5 then
			local var_19_6 = false
			local var_19_7 = true

			arg_19_0:_on_illusion_index_pressed(var_19_3, var_19_6, var_19_7)
		end
	else
		if var_19_2:handle_gamepad_selection(var_19_1) then
			arg_19_0:_play_sound("play_gui_inventory_item_hover")
		end

		if var_19_1:get("confirm", true) then
			local var_19_8, var_19_9 = var_19_2:selected_item()

			if var_19_8 then
				local var_19_10 = var_19_8.data

				if var_19_10.slot_type == "weapon_pose" then
					if arg_19_0._widgets_by_name.apply_illusion_button.content.visible then
						arg_19_0:_apply_illusion()
					elseif not var_19_9 then
						var_19_0:_set_loadout_item(var_19_8)
						arg_19_0:_play_sound("play_gui_equipment_equip_hero")
					end
				else
					arg_19_0._selected_blueprint_name, arg_19_0._selected_blueprint_item = var_19_10.name, table.clone(var_19_8)

					local var_19_11 = "weapon_pose_parent == " .. string.gsub(arg_19_0._selected_blueprint_name, "^vs_", "")

					arg_19_0:_change_item_filter(var_19_11)
					arg_19_0._parent:set_temporary_loadout_item(var_19_8)
					arg_19_0:_setup_illusions(var_19_8)
				end
			end
		elseif var_19_1:get("special_1", true) then
			arg_19_0:_toggle_gamepad_illusion_buttons()
		else
			local var_19_12, var_19_13 = var_19_2:selected_item()

			if var_19_12 then
				local var_19_14 = var_19_12.data

				if var_19_14.slot_type == "weapon_pose" then
					local var_19_15 = var_19_14.data.anim_event

					if arg_19_0._current_anim_event ~= var_19_15 then
						arg_19_0._parent:set_character_pose_animation(var_19_15)

						arg_19_0._current_anim_event = var_19_15
					end
				end
			elseif arg_19_0._current_anim_event then
				arg_19_0._parent:clear_character_animation()

				arg_19_0._current_anim_event = nil
				arg_19_0._current_hovered_item = nil
			end
		end

		if arg_19_0._selected_blueprint_name and (var_19_1:get("back_menu", true) or var_19_1:get("toggle_menu", true)) then
			arg_19_0:_back()
		elseif var_19_1:get("refresh") then
			arg_19_0:_equip_default()

			return
		end

		local var_19_16 = arg_19_0._current_page
		local var_19_17 = arg_19_0._total_pages

		if var_19_16 and var_19_17 then
			if var_19_16 < var_19_17 and var_19_1:get(var_0_9) then
				var_19_2:set_item_page(var_19_16 + 1)
				arg_19_0:_play_sound("play_gui_equipment_inventory_next_click")

				local var_19_18 = var_19_2:get_item_in_slot(1, 1)

				var_19_2:set_item_selected(var_19_18)
			elseif var_19_16 > 1 and var_19_1:get(var_0_10) then
				var_19_2:set_item_page(var_19_16 - 1)
				arg_19_0:_play_sound("play_gui_equipment_inventory_next_click")

				local var_19_19 = var_19_2:get_item_in_slot(1, 1)

				var_19_2:set_item_selected(var_19_19)
			end
		end
	end
end

function HeroWindowCosmeticsLoadoutPoseInventoryConsole._toggle_gamepad_illusion_buttons(arg_20_0)
	arg_20_0._gamepad_illusion_buttons_active = not arg_20_0._gamepad_illusion_buttons_active
end

function HeroWindowCosmeticsLoadoutPoseInventoryConsole._handle_input(arg_21_0, arg_21_1, arg_21_2)
	local var_21_0 = arg_21_0._widgets_by_name
	local var_21_1 = arg_21_0._parent
	local var_21_2 = arg_21_0._item_grid
	local var_21_3 = arg_21_0._selected_blueprint_name == nil
	local var_21_4, var_21_5 = var_21_2:is_item_pressed(var_21_3)
	local var_21_6, var_21_7 = var_21_2:get_item_hovered()
	local var_21_8 = arg_21_0:_input_service()

	if not Managers.input:is_device_active("mouse") then
		return
	end

	if arg_21_0._selected_blueprint_name and var_21_8:get("toggle_menu", true) then
		arg_21_0:_back()

		return
	end

	if var_21_2:is_item_hovered() then
		arg_21_0:_play_sound("play_gui_inventory_item_hover")
	end

	if var_21_2:handle_favorite_marking(var_21_8) then
		arg_21_0:_play_sound("play_gui_inventory_item_hover")
	end

	if var_21_4 then
		local var_21_9 = var_21_4.data

		if var_21_9.slot_type == "weapon_pose" then
			if not var_21_5 then
				arg_21_0:_set_loadout_item(var_21_4)
				arg_21_0:_play_sound("play_gui_equipment_equip_hero")
			end
		else
			arg_21_0._selected_blueprint_name, arg_21_0._selected_blueprint_item = var_21_9.name, table.clone(var_21_4)

			local var_21_10 = "weapon_pose_parent == " .. string.gsub(arg_21_0._selected_blueprint_name, "^vs_", "")

			arg_21_0:_change_item_filter(var_21_10)
			arg_21_0:_setup_illusions(var_21_4)
		end
	elseif var_21_6 then
		local var_21_11 = var_21_6.data

		if var_21_11.slot_type == "weapon_pose" then
			local var_21_12 = var_21_11.data.anim_event

			if arg_21_0._current_anim_event ~= var_21_12 then
				arg_21_0._parent:set_character_pose_animation(var_21_12)

				arg_21_0._current_anim_event = var_21_12
				arg_21_0._current_hovered_item = var_21_6
			end
		end
	end

	local var_21_13 = var_21_0.page_button_next
	local var_21_14 = var_21_0.page_button_previous

	if UIUtils.is_button_hover_enter(var_21_13) or UIUtils.is_button_hover_enter(var_21_14) then
		arg_21_0:_play_sound("play_gui_inventory_next_hover")
	end

	if UIUtils.is_button_pressed(var_21_13) then
		local var_21_15 = arg_21_0._current_page + 1

		var_21_2:set_item_page(var_21_15)
		arg_21_0:_play_sound("play_gui_equipment_inventory_next_click")
	elseif UIUtils.is_button_pressed(var_21_14) then
		local var_21_16 = arg_21_0._current_page - 1

		var_21_2:set_item_page(var_21_16)
		arg_21_0:_play_sound("play_gui_equipment_inventory_next_click")
	end

	local var_21_17 = var_21_0.button_remove

	if UIUtils.is_button_hover_enter(var_21_17) then
		arg_21_0:_play_sound("play_gui_equipment_inventory_hover")
	end

	if UIUtils.is_button_pressed(var_21_17) then
		arg_21_0:_equip_default()
	end
end

function HeroWindowCosmeticsLoadoutPoseInventoryConsole._equip_default(arg_22_0)
	arg_22_0:_play_sound("play_gui_equipment_equip_hero")

	local var_22_0 = Managers.backend:get_interface("items"):get_item_from_key("default_weapon_pose_01")

	if var_22_0 then
		arg_22_0._parent:_set_loadout_item(var_22_0)
	end
end

function HeroWindowCosmeticsLoadoutPoseInventoryConsole._set_loadout_item(arg_23_0, arg_23_1)
	arg_23_0._parent:_set_loadout_item(arg_23_1)

	local var_23_0 = arg_23_1.data
	local var_23_1 = Managers.player:local_player()

	CosmeticUtils.update_cosmetic_slot(var_23_1, "slot_pose", var_23_0.name)
end

function HeroWindowCosmeticsLoadoutPoseInventoryConsole._select_illusion_by_key(arg_24_0, arg_24_1, arg_24_2, arg_24_3)
	if not arg_24_1 then
		return
	end

	local var_24_0 = arg_24_0._illusion_widgets

	for iter_24_0, iter_24_1 in ipairs(var_24_0) do
		if iter_24_1.content.skin_key == arg_24_1 then
			arg_24_0:_on_illusion_index_pressed(iter_24_0, arg_24_2, arg_24_3)

			break
		end
	end
end

function HeroWindowCosmeticsLoadoutPoseInventoryConsole._on_illusion_index_pressed(arg_25_0, arg_25_1, arg_25_2, arg_25_3)
	local var_25_0 = arg_25_0._illusion_widgets[arg_25_1].content
	local var_25_1 = var_25_0.skin_key

	arg_25_0._skin_dirty = false

	local var_25_2 = var_25_0.locked
	local var_25_3 = arg_25_0._selected_blueprint_item

	var_25_3.skin = var_25_1

	arg_25_0._parent:clear_temporary_loadout()
	arg_25_0._parent:set_temporary_loadout_item(var_25_3, arg_25_3)

	if not var_25_2 then
		local var_25_4 = Managers.backend:get_interface("items")
		local var_25_5 = var_25_4:get_unlocked_weapon_poses()
		local var_25_6 = arg_25_0._selected_blueprint_name
		local var_25_7 = ItemMasterList[var_25_6]
		local var_25_8 = string.gsub(var_25_7.name, "^vs_", "")

		if not var_25_5[var_25_8] then
			local var_25_9 = var_0_12
		end

		local var_25_10 = WeaponSkins.default_skins[var_25_8]
		local var_25_11, var_25_12 = var_25_4:get_weapon_skin_from_skin_key(var_25_10)
		local var_25_13 = var_25_4:get_equipped_weapon_pose_skin(var_25_8)

		if not var_25_13 and var_25_1 ~= var_25_10 or var_25_13 and var_25_13 ~= var_25_1 then
			arg_25_0:_enable_apply_illusion_button(true, true)
		else
			arg_25_0:_enable_apply_illusion_button(false)
		end
	else
		arg_25_0:_enable_apply_illusion_button(false)
	end

	local var_25_14 = arg_25_0._widgets_by_name
	local var_25_15 = WeaponSkins.skins[var_25_1]

	var_25_14.illusions_name.content.text = Localize(var_25_15.display_name)

	local var_25_16 = arg_25_0._illusion_widgets

	for iter_25_0, iter_25_1 in ipairs(var_25_16) do
		local var_25_17 = iter_25_0 == arg_25_1
		local var_25_18 = iter_25_1.content

		var_25_18.button_hotspot.is_selected = var_25_17

		if arg_25_2 then
			var_25_18.equipped = var_25_17
		end
	end

	arg_25_0._selected_skin_index = arg_25_1

	arg_25_0:_play_sound("play_gui_equipment_equip")
end

function HeroWindowCosmeticsLoadoutPoseInventoryConsole._enable_apply_illusion_button(arg_26_0, arg_26_1, arg_26_2)
	if script_data["eac-untrusted"] then
		arg_26_1 = false
	end

	local var_26_0 = arg_26_0._widgets_by_name.apply_illusion_button

	var_26_0.content.visible = arg_26_1
	var_26_0.content.button_hotspot.disable_button = not arg_26_1
end

function HeroWindowCosmeticsLoadoutPoseInventoryConsole._get_item(arg_27_0, arg_27_1)
	arg_27_0._item_backend_id = arg_27_1

	return Managers.backend:get_interface("items"):get_item_from_id(arg_27_1)
end

local function var_0_13(arg_28_0, arg_28_1)
	local var_28_0 = WeaponSkins.skins
	local var_28_1 = UISettings.item_rarity_order
	local var_28_2 = arg_28_0.content
	local var_28_3 = arg_28_1.content
	local var_28_4 = var_28_2.rarity
	local var_28_5 = var_28_3.rarity

	return (var_28_1[var_28_4] or 0) > (var_28_1[var_28_5] or 0)
end

function HeroWindowCosmeticsLoadoutPoseInventoryConsole._clear_illusion_widgets(arg_29_0)
	table.clear(arg_29_0._illusion_base_widgets)
	table.clear(arg_29_0._illusion_widgets)
end

function HeroWindowCosmeticsLoadoutPoseInventoryConsole._setup_illusions(arg_30_0, arg_30_1)
	local var_30_0 = {}
	local var_30_1 = arg_30_0._widgets_by_name

	for iter_30_0, iter_30_1 in pairs(var_0_7) do
		local var_30_2 = UIWidget.init(iter_30_1)

		var_30_0[#var_30_0 + 1] = var_30_2
		var_30_1[iter_30_0] = var_30_2
	end

	arg_30_0._illusion_base_widgets = var_30_0

	local var_30_3 = string.gsub(arg_30_1.key, "^vs_", "")
	local var_30_4 = arg_30_1.data
	local var_30_5 = ItemMasterList[var_30_3]
	local var_30_6 = var_30_5 or var_30_4
	local var_30_7 = 0
	local var_30_8 = var_30_6.skin_combination_table
	local var_30_9 = WeaponSkins.skin_combinations[var_30_8] or var_0_12
	local var_30_10 = Managers.backend:get_interface("quests")
	local var_30_11 = Managers.backend:get_interface("crafting"):get_unlocked_weapon_skins()
	local var_30_12 = WeaponSkins.default_skins[var_30_3]
	local var_30_13
	local var_30_14 = 51
	local var_30_15 = -5
	local var_30_16 = -var_30_15
	local var_30_17 = {}
	local var_30_18 = {}
	local var_30_19 = RaritySettings
	local var_30_20 = var_0_6()

	for iter_30_2, iter_30_3 in pairs(var_30_9) do
		for iter_30_4, iter_30_5 in ipairs(iter_30_3) do
			if not var_30_18[iter_30_5] then
				if not var_30_19[iter_30_2] then
					local var_30_21 = WeaponSkins.skins[iter_30_5]

					iter_30_2 = var_30_21 and var_30_21.rarity or iter_30_2
				end

				local var_30_22 = var_30_11[iter_30_5] or iter_30_5 == var_30_12
				local var_30_23 = true
				local var_30_24 = (ItemMasterList[iter_30_5] or var_0_12).event_quest_requirement

				if not var_30_22 and var_30_24 then
					var_30_23 = var_30_10:get_quest_key(var_30_24)
				end

				if var_30_23 then
					local var_30_25 = "button_illusion_" .. iter_30_2

					if not UIAtlasHelper.has_texture_by_name(var_30_25) then
						var_30_25 = "button_illusion_default"
					end

					if var_30_22 then
						var_30_7 = var_30_7 + 1
					else
						var_30_25 = "button_illusion_locked"
					end

					local var_30_26 = UIWidget.init(var_30_20)

					var_30_17[#var_30_17 + 1] = var_30_26

					local var_30_27 = var_30_26.content

					var_30_27.skin_key = iter_30_5
					var_30_27.icon_texture = var_30_25
					var_30_27.locked = not var_30_22
					var_30_27.rarity = iter_30_2
					var_30_16 = var_30_16 + var_30_15 + var_30_14
					var_30_18[iter_30_5] = true
				end
			end
		end
	end

	if var_30_12 and not var_30_18[var_30_12] then
		local var_30_28 = true
		local var_30_29 = "plentiful"
		local var_30_30 = "button_illusion_" .. var_30_29

		if not UIAtlasHelper.has_texture_by_name(var_30_30) then
			var_30_30 = "button_illusion_default"
		end

		local var_30_31 = UIWidget.init(var_30_20)

		var_30_17[#var_30_17 + 1] = var_30_31

		local var_30_32 = var_30_31.content

		var_30_32.skin_key = var_30_12
		var_30_32.icon_texture = var_30_30
		var_30_32.locked = not var_30_28
		var_30_32.rarity = var_30_29
		var_30_16 = var_30_16 + var_30_15 + var_30_14
		var_30_7 = var_30_7 + 1
	end

	table.sort(var_30_17, var_0_13)

	local var_30_33 = var_30_14 / 2

	for iter_30_6, iter_30_7 in ipairs(var_30_17) do
		iter_30_7.offset[1] = -var_30_16 / 2 + var_30_33
		var_30_33 = var_30_33 + var_30_14 + var_30_15
	end

	arg_30_0._illusion_widgets = var_30_17

	local var_30_34 = Managers.backend:get_interface("items")
	local var_30_35 = var_30_34:get_equipped_weapon_pose_skins()[var_30_3]
	local var_30_36 = var_30_35 and var_30_34:get_weapon_skin_from_skin_key(var_30_35)
	local var_30_37 = var_30_36 and var_30_34:get_item_from_id(var_30_36)
	local var_30_38 = var_30_37 and var_30_37.skin or var_30_5.skin or var_30_12
	local var_30_39 = true

	arg_30_0:_select_illusion_by_key(var_30_38, var_30_39)

	arg_30_0._widgets_by_name.illusions_counter.content.text = "(" .. tostring(var_30_7) .. "/" .. tostring(#var_30_17) .. ")"

	arg_30_0:_start_transition_animation("animate_illusion_widgets")
end

function HeroWindowCosmeticsLoadoutPoseInventoryConsole._back(arg_31_0)
	local var_31_0 = var_0_2[arg_31_0._current_category_index]
	local var_31_1 = var_31_0.name
	local var_31_2 = var_31_0.display_name

	arg_31_0._item_grid:change_category(var_31_1)

	arg_31_0._selected_blueprint_name = nil

	arg_31_0:_play_sound("play_gui_equipment_inventory_next_click")
	arg_31_0:_start_transition_animation("on_enter")

	if not Managers.input:is_device_active("mouse") then
		local var_31_3 = arg_31_0._item_grid
		local var_31_4 = var_31_3:get_item_in_slot(1, 1)

		var_31_3:set_item_selected(var_31_4)
	end

	arg_31_0:_show_equipped_weapon_pose()
	arg_31_0:_clear_illusion_widgets()
	arg_31_0._item_grid:mark_equipped_items(false)
end

function HeroWindowCosmeticsLoadoutPoseInventoryConsole._change_item_filter(arg_32_0, arg_32_1)
	arg_32_0._item_grid:change_item_filter(arg_32_1, true)
	arg_32_0:_play_sound("play_gui_equipment_inventory_next_click")
	arg_32_0:_start_transition_animation("on_enter")

	if not Managers.input:is_device_active("mouse") then
		local var_32_0 = arg_32_0._item_grid
		local var_32_1 = var_32_0:get_item_in_slot(1, 1)

		var_32_0:set_item_selected(var_32_1)
	end

	arg_32_0._item_grid:mark_equipped_items(true)
end

function HeroWindowCosmeticsLoadoutPoseInventoryConsole._update_page_info(arg_33_0)
	local var_33_0, var_33_1 = arg_33_0._item_grid:get_page_info()

	if var_33_0 ~= arg_33_0._current_page or var_33_1 ~= arg_33_0._total_pages then
		arg_33_0._total_pages = var_33_1
		arg_33_0._current_page = var_33_0
		var_33_0 = var_33_0 or 1
		var_33_1 = var_33_1 or 1

		local var_33_2 = arg_33_0._widgets_by_name

		var_33_2.page_text_left.content.text = tostring(var_33_0)
		var_33_2.page_text_right.content.text = tostring(var_33_1)
		var_33_2.page_button_next.content.hotspot.disable_button = var_33_0 == var_33_1
		var_33_2.page_button_previous.content.hotspot.disable_button = var_33_0 == 1
	end
end

function HeroWindowCosmeticsLoadoutPoseInventoryConsole._update_selected_cosmetic_slot_index(arg_34_0)
	local var_34_0 = arg_34_0._parent:get_selected_cosmetic_slot_index()

	if var_34_0 ~= arg_34_0._selected_cosmetic_slot_index then
		arg_34_0._selected_cosmetic_slot_index = var_34_0

		arg_34_0:_change_category_by_index(var_34_0)
	end
end

function HeroWindowCosmeticsLoadoutPoseInventoryConsole._update_loadout_sync(arg_35_0)
	local var_35_0 = arg_35_0._item_grid
	local var_35_1 = arg_35_0._parent.loadout_sync_id

	if var_35_1 ~= arg_35_0._loadout_sync_id then
		arg_35_0._loadout_sync_id = var_35_1

		var_35_0:update_items_status()
		arg_35_0:_update_equipped_item_tooltip()
	end
end

function HeroWindowCosmeticsLoadoutPoseInventoryConsole._exit(arg_36_0, arg_36_1)
	arg_36_0.exit = true
	arg_36_0.exit_level_id = arg_36_1
end

function HeroWindowCosmeticsLoadoutPoseInventoryConsole.draw(arg_37_0, arg_37_1)
	local var_37_0 = arg_37_0._ui_renderer
	local var_37_1 = arg_37_0._ui_top_renderer
	local var_37_2 = arg_37_0.ui_scenegraph
	local var_37_3 = arg_37_0:_input_service()
	local var_37_4 = Managers.input:is_device_active("gamepad")
	local var_37_5 = arg_37_0._render_settings
	local var_37_6 = var_37_5.alpha_multiplier

	UIRenderer.begin_pass(var_37_1, var_37_2, var_37_3, arg_37_1, nil, var_37_5)

	for iter_37_0, iter_37_1 in ipairs(arg_37_0._widgets) do
		var_37_5.alpha_multiplier = iter_37_1.alpha_multiplier or var_37_6

		UIRenderer.draw_widget(var_37_1, iter_37_1)
	end

	if not var_37_4 or arg_37_0._gamepad_illusion_buttons_active then
		for iter_37_2, iter_37_3 in ipairs(arg_37_0._illusion_widgets) do
			var_37_5.alpha_multiplier = iter_37_3.alpha_multiplier or var_37_6

			UIRenderer.draw_widget(var_37_1, iter_37_3)
		end

		for iter_37_4, iter_37_5 in ipairs(arg_37_0._illusion_base_widgets) do
			var_37_5.alpha_multiplier = iter_37_5.alpha_multiplier or var_37_6

			UIRenderer.draw_widget(var_37_1, iter_37_5)
		end
	end

	local var_37_7 = arg_37_0._active_node_widgets

	if var_37_7 then
		for iter_37_6, iter_37_7 in ipairs(var_37_7) do
			UIRenderer.draw_widget(var_37_1, iter_37_7)
		end
	end

	UIRenderer.end_pass(var_37_1)

	if var_37_4 and arg_37_0._menu_input_description then
		arg_37_0._menu_input_description:draw(var_37_1, arg_37_1)
	end
end

function HeroWindowCosmeticsLoadoutPoseInventoryConsole._play_sound(arg_38_0, arg_38_1)
	arg_38_0._parent:play_sound(arg_38_1)
end

function HeroWindowCosmeticsLoadoutPoseInventoryConsole._change_category_by_index(arg_39_0, arg_39_1, arg_39_2)
	if arg_39_2 then
		arg_39_1 = arg_39_0._current_category_index or 1
	end

	if arg_39_0._current_category_index == arg_39_1 then
		return
	end

	arg_39_0._current_category_index = arg_39_1

	local var_39_0 = var_0_2[arg_39_1]
	local var_39_1 = var_39_0.name
	local var_39_2 = var_39_0.display_name

	arg_39_0._item_grid:change_category(var_39_1)

	return true
end

function HeroWindowCosmeticsLoadoutPoseInventoryConsole._setup_input_buttons(arg_40_0)
	local var_40_0 = arg_40_0._parent:window_input_service()
	local var_40_1 = UISettings.get_gamepad_input_texture_data(var_40_0, var_0_9, true)
	local var_40_2 = UISettings.get_gamepad_input_texture_data(var_40_0, var_0_10, true)
	local var_40_3 = arg_40_0._widgets_by_name
	local var_40_4 = var_40_3.input_icon_next
	local var_40_5 = var_40_3.input_icon_previous
	local var_40_6 = var_40_4.style.texture_id

	var_40_6.horizontal_alignment = "center"
	var_40_6.vertical_alignment = "center"
	var_40_6.texture_size = {
		var_40_1.size[1],
		var_40_1.size[2]
	}
	var_40_4.content.texture_id = var_40_1.texture

	local var_40_7 = var_40_5.style.texture_id

	var_40_7.horizontal_alignment = "center"
	var_40_7.vertical_alignment = "center"
	var_40_7.texture_size = {
		var_40_2.size[1],
		var_40_2.size[2]
	}
	var_40_5.content.texture_id = var_40_2.texture
end

function HeroWindowCosmeticsLoadoutPoseInventoryConsole._set_gamepad_input_buttons_visibility(arg_41_0, arg_41_1)
	local var_41_0 = arg_41_0._widgets_by_name
	local var_41_1 = var_41_0.input_icon_next
	local var_41_2 = var_41_0.input_icon_previous
	local var_41_3 = var_41_0.input_arrow_next
	local var_41_4 = var_41_0.input_arrow_previous

	var_41_1.content.visible = arg_41_1
	var_41_2.content.visible = arg_41_1
	var_41_3.content.visible = arg_41_1
	var_41_4.content.visible = arg_41_1
end

function HeroWindowCosmeticsLoadoutPoseInventoryConsole._handle_gamepad_activity(arg_42_0)
	local var_42_0 = Managers.input:is_device_active("mouse")
	local var_42_1 = arg_42_0.gamepad_active_last_frame == nil

	if not var_42_0 then
		if not arg_42_0.gamepad_active_last_frame or var_42_1 then
			arg_42_0.gamepad_active_last_frame = true

			local var_42_2 = arg_42_0._item_grid
			local var_42_3 = var_42_2:get_item_in_slot(1, 1)

			var_42_2:set_item_selected(arg_42_0._current_hovered_item or var_42_3)
			arg_42_0:_set_gamepad_input_buttons_visibility(true)
		end
	elseif arg_42_0.gamepad_active_last_frame or var_42_1 then
		arg_42_0.gamepad_active_last_frame = false

		arg_42_0._item_grid:set_item_selected(nil)
		arg_42_0:_set_gamepad_input_buttons_visibility(false)

		arg_42_0._gamepad_illusion_buttons_active = false
	end
end
