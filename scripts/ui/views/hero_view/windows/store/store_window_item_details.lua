-- chunkname: @scripts/ui/views/hero_view/windows/store/store_window_item_details.lua

local var_0_0 = local_require("scripts/ui/views/hero_view/windows/store/definitions/store_window_item_details_definitions")
local var_0_1 = var_0_0.widgets
local var_0_2 = var_0_0.scenegraph_definition
local var_0_3 = var_0_0.animation_definitions
local var_0_4 = var_0_0.create_career_icon

StoreWindowItemDetails = class(StoreWindowItemDetails)
StoreWindowItemDetails.NAME = "StoreWindowItemDetails"

function StoreWindowItemDetails.on_enter(arg_1_0, arg_1_1, arg_1_2)
	print("[HeroViewWindow] Enter Substate StoreWindowItemDetails")

	arg_1_0._params = arg_1_1
	arg_1_0._parent = arg_1_1.parent

	local var_1_0, var_1_1 = arg_1_0._parent:get_renderers()

	arg_1_0._ui_renderer = var_1_0
	arg_1_0._ui_top_renderer = var_1_1
	arg_1_0._render_settings = {
		snap_pixel_positions = true
	}
	arg_1_0._layout_settings = arg_1_1.layout_settings
	arg_1_0._animations = {}
	arg_1_0._ui_animations = {}

	arg_1_0:_create_ui_elements(arg_1_1, arg_1_2)
	arg_1_0:_start_transition_animation("on_enter")
	arg_1_0._parent:set_list_details_visibility(true)
	arg_1_0._parent:set_list_details_length(680, 0.3)
	arg_1_0._parent:change_generic_actions("default")
end

function StoreWindowItemDetails._start_transition_animation(arg_2_0, arg_2_1)
	local var_2_0 = {
		render_settings = arg_2_0._render_settings
	}
	local var_2_1 = arg_2_0._widgets_by_name
	local var_2_2 = arg_2_0._ui_animator:start_animation(arg_2_1, var_2_1, var_0_2, var_2_0)

	arg_2_0._animations[arg_2_1] = var_2_2
end

function StoreWindowItemDetails._create_ui_elements(arg_3_0, arg_3_1, arg_3_2)
	arg_3_0._ui_scenegraph = UISceneGraph.init_scenegraph(var_0_2)

	local var_3_0 = {}
	local var_3_1 = {}

	for iter_3_0, iter_3_1 in pairs(var_0_1) do
		local var_3_2 = UIWidget.init(iter_3_1)

		var_3_0[#var_3_0 + 1] = var_3_2
		var_3_1[iter_3_0] = var_3_2
	end

	arg_3_0._widgets = var_3_0
	arg_3_0._widgets_by_name = var_3_1

	UIRenderer.clear_scenegraph_queue(arg_3_0._ui_top_renderer)

	arg_3_0._ui_animator = UIAnimator:new(arg_3_0._ui_scenegraph, var_0_3)
end

function StoreWindowItemDetails.on_exit(arg_4_0, arg_4_1)
	print("[HeroViewWindow] Exit Substate StoreWindowItemDetails")

	arg_4_0._ui_animator = nil
end

function StoreWindowItemDetails.update(arg_5_0, arg_5_1, arg_5_2)
	arg_5_0:_sync_presentation_item()
	arg_5_0:_update_animations(arg_5_1)
	arg_5_0:_draw(arg_5_1)
end

function StoreWindowItemDetails.post_update(arg_6_0, arg_6_1, arg_6_2)
	arg_6_0:_handle_input(arg_6_1, arg_6_2)
end

function StoreWindowItemDetails._update_animations(arg_7_0, arg_7_1)
	local var_7_0 = arg_7_0._ui_animations
	local var_7_1 = arg_7_0._animations
	local var_7_2 = arg_7_0._ui_animator

	for iter_7_0, iter_7_1 in pairs(arg_7_0._ui_animations) do
		UIAnimation.update(iter_7_1, arg_7_1)

		if UIAnimation.completed(iter_7_1) then
			arg_7_0._ui_animations[iter_7_0] = nil
		end
	end

	var_7_2:update(arg_7_1)

	for iter_7_2, iter_7_3 in pairs(var_7_1) do
		if var_7_2:is_animation_completed(iter_7_3) then
			var_7_2:stop_animation(iter_7_3)

			var_7_1[iter_7_2] = nil
		end
	end
end

function StoreWindowItemDetails._sync_presentation_item(arg_8_0)
	local var_8_0 = arg_8_0._params.selected_product

	if var_8_0 ~= arg_8_0._selected_product then
		local var_8_1 = not arg_8_0._selected_product or arg_8_0._selected_product.product_id ~= var_8_0.product_id

		arg_8_0._selected_product = var_8_0

		if var_8_1 then
			local var_8_2 = var_8_0.type

			if var_8_2 == "item" then
				local var_8_3 = var_8_0.item

				arg_8_0:_present_item(var_8_3)

				arg_8_0._show_loading_overlay = true
			elseif var_8_2 == "dlc" then
				local var_8_4 = var_8_0.dlc_settings

				arg_8_0:_present_dlc(var_8_4)
			end
		end
	end
end

function StoreWindowItemDetails._present_dlc(arg_9_0, arg_9_1)
	local var_9_0 = arg_9_1.name
	local var_9_1 = arg_9_1.information_text
	local var_9_2 = "dlc1_2_dlc_level_locked_tooltip"

	arg_9_0:_set_title_text(Localize(var_9_0))
	arg_9_0:_set_sub_title_text(Localize(var_9_2))
	arg_9_0:_set_description_text(Localize(var_9_1))
end

function StoreWindowItemDetails._present_item(arg_10_0, arg_10_1)
	local var_10_0 = arg_10_1.data
	local var_10_1 = var_10_0.key
	local var_10_2 = var_10_0.rarity
	local var_10_3 = var_10_0.item_type
	local var_10_4 = var_10_0.can_wield
	local var_10_5 = table.compare(var_10_4, CanWieldAllItemTemplates)
	local var_10_6, var_10_7, var_10_8, var_10_9 = arg_10_0:_get_hero_wield_info_by_item(arg_10_1)
	local var_10_10 = SPProfiles[var_10_7]
	local var_10_11 = var_10_5 and "store_can_be_wielded_by_all" or var_10_10.character_name
	local var_10_12 = ""

	if var_10_3 == "weapon_skin" then
		var_10_12 = Localize(var_10_0.matching_item_key)
	elseif var_10_3 == "cosmetic_bundle" then
		var_10_12 = Localize("dark_pact_skin")
	else
		var_10_12 = Localize(var_10_3)
	end

	local var_10_13, var_10_14, var_10_15 = UIUtils.get_ui_information_from_item(arg_10_1)
	local var_10_16 = Colors.get_color_table_with_alpha(var_10_2, 255)

	if not var_10_5 then
		arg_10_0:_setup_career_icons(var_10_4)
	end

	arg_10_0:_set_title_text(Localize(var_10_14))
	arg_10_0:_set_title_text_color(var_10_16)
	arg_10_0:_set_hero_text(Localize(var_10_11))
	arg_10_0:_set_sub_title_text(var_10_12)
	arg_10_0:_set_description_text(Localize(var_10_15))
	arg_10_0:_set_item_icon(var_10_13)
end

function StoreWindowItemDetails._get_hero_wield_info_by_item(arg_11_0, arg_11_1)
	local var_11_0 = arg_11_1.data.can_wield[1]

	for iter_11_0, iter_11_1 in ipairs(SPProfiles) do
		local var_11_1 = iter_11_1.careers

		for iter_11_2, iter_11_3 in ipairs(var_11_1) do
			if iter_11_3.name == var_11_0 then
				local var_11_2 = iter_11_1.display_name
				local var_11_3 = FindProfileIndex(var_11_2)
				local var_11_4 = iter_11_3.sort_order

				return var_11_2, var_11_3, var_11_0, var_11_4
			end
		end
	end
end

function StoreWindowItemDetails._setup_career_icons(arg_12_0, arg_12_1)
	local var_12_0 = "career_icons"
	local var_12_1 = var_0_4(var_12_0)
	local var_12_2 = {}

	if arg_12_1 then
		local var_12_3 = #arg_12_1
		local var_12_4 = 60
		local var_12_5 = -(var_12_4 * var_12_3 / 2 + var_12_4 / 2)

		for iter_12_0 = 1, var_12_3 do
			local var_12_6 = arg_12_1[iter_12_0]
			local var_12_7 = CareerSettings[var_12_6]
			local var_12_8 = var_12_7.display_name

			var_12_5 = var_12_5 + var_12_4

			local var_12_9 = UIWidget.init(var_12_1)

			var_12_9.offset[1] = var_12_5

			local var_12_10 = var_12_9.content.tooltip

			var_12_10.title = Localize(var_12_8)
			var_12_10.description = Localize("menu_store_product_wieldable_tooltip_desc")
			var_12_9.content.icon = var_12_7.store_tag_icon or "store_tag_icon_" .. var_12_6
			var_12_2[iter_12_0] = var_12_9
		end
	end

	arg_12_0._career_icon_widgets = var_12_2
end

function StoreWindowItemDetails._set_item_icon(arg_13_0, arg_13_1)
	arg_13_0._widgets_by_name.item_icon.content.texture_id = arg_13_1
end

function StoreWindowItemDetails._set_title_text_color(arg_14_0, arg_14_1)
	arg_14_0._widgets_by_name.title_text.style.text.text_color = arg_14_1
end

function StoreWindowItemDetails._set_title_text(arg_15_0, arg_15_1)
	local var_15_0 = arg_15_0._widgets_by_name.title_text

	var_15_0.content.text = arg_15_1

	local var_15_1 = var_15_0.scenegraph_id
	local var_15_2 = var_0_2[var_15_1].size
	local var_15_3 = arg_15_0._ui_top_renderer
	local var_15_4 = var_15_0.style.text
	local var_15_5 = UIUtils.get_text_height(var_15_3, var_15_2, var_15_4, arg_15_1)
	local var_15_6 = arg_15_0._ui_scenegraph

	var_15_6[var_15_1].size[2] = var_15_5
	var_15_6.description_text.size[2] = 250 - var_15_5
end

function StoreWindowItemDetails._set_hero_text(arg_16_0, arg_16_1)
	arg_16_0._widgets_by_name.hero_text.content.text = arg_16_1
end

function StoreWindowItemDetails._set_sub_title_text(arg_17_0, arg_17_1)
	local var_17_0 = arg_17_0._widgets_by_name.sub_title_text

	var_17_0.content.text = arg_17_1

	local var_17_1 = arg_17_0._ui_top_renderer
	local var_17_2 = var_17_0.style.text
	local var_17_3 = UIUtils.get_text_width(var_17_1, var_17_2, arg_17_1)
	local var_17_4 = var_17_0.scenegraph_id

	arg_17_0._ui_scenegraph[var_17_4].size[1] = var_17_3 + 20
end

function StoreWindowItemDetails._set_description_text(arg_18_0, arg_18_1)
	arg_18_0._widgets_by_name.description_text.content.text = arg_18_1
end

function StoreWindowItemDetails._is_button_pressed(arg_19_0, arg_19_1)
	local var_19_0 = arg_19_1.content
	local var_19_1 = var_19_0.button_hotspot or var_19_0.button_text

	if var_19_1.on_release then
		var_19_1.on_release = false

		return true
	end
end

function StoreWindowItemDetails._is_stepper_button_pressed(arg_20_0, arg_20_1)
	local var_20_0 = arg_20_1.content
	local var_20_1 = var_20_0.button_hotspot_left
	local var_20_2 = var_20_0.button_hotspot_right

	if var_20_1.on_release then
		var_20_1.on_release = false

		return true, -1
	elseif var_20_2.on_release then
		var_20_2.on_release = false

		return true, 1
	end
end

function StoreWindowItemDetails._is_button_hover_enter(arg_21_0, arg_21_1)
	return arg_21_1.content.button_hotspot.on_hover_enter
end

function StoreWindowItemDetails._is_button_hover_exit(arg_22_0, arg_22_1)
	return arg_22_1.content.button_hotspot.on_hover_exit
end

function StoreWindowItemDetails._is_button_selected(arg_23_0, arg_23_1)
	return arg_23_1.content.button_hotspot.is_selected
end

function StoreWindowItemDetails._handle_input(arg_24_0, arg_24_1, arg_24_2)
	local var_24_0 = arg_24_0._parent
	local var_24_1 = arg_24_0._widgets_by_name
	local var_24_2 = arg_24_0._parent:window_input_service()
end

function StoreWindowItemDetails._draw(arg_25_0, arg_25_1)
	local var_25_0 = arg_25_0._ui_top_renderer
	local var_25_1 = arg_25_0._ui_scenegraph
	local var_25_2 = arg_25_0._parent:window_input_service()

	UIRenderer.begin_pass(var_25_0, var_25_1, var_25_2, arg_25_1, nil, arg_25_0._render_settings)

	for iter_25_0, iter_25_1 in ipairs(arg_25_0._widgets) do
		UIRenderer.draw_widget(var_25_0, iter_25_1)
	end

	local var_25_3 = arg_25_0._career_icon_widgets

	if var_25_3 then
		for iter_25_2, iter_25_3 in ipairs(var_25_3) do
			UIRenderer.draw_widget(var_25_0, iter_25_3)
		end
	end

	UIRenderer.end_pass(var_25_0)
end

function StoreWindowItemDetails._play_sound(arg_26_0, arg_26_1)
	arg_26_0._parent:play_sound(arg_26_1)
end

function StoreWindowItemDetails._handle_gamepad_activity(arg_27_0)
	local var_27_0 = Managers.input:is_device_active("gamepad")
	local var_27_1 = arg_27_0._gamepad_active_last_frame == nil

	if var_27_0 then
		if not arg_27_0._gamepad_active_last_frame or var_27_1 then
			arg_27_0._gamepad_active_last_frame = true
		end
	elseif arg_27_0._gamepad_active_last_frame or var_27_1 then
		arg_27_0._gamepad_active_last_frame = false
	end
end
