-- chunkname: @scripts/ui/views/hero_view/windows/store/store_window_item_details.lua

local var_0_0 = local_require("scripts/ui/views/hero_view/windows/store/definitions/store_window_item_details_definitions")
local widgets = var_0_0.widgets
local scenegraph_definition = var_0_0.scenegraph_definition
local animation_definitions = var_0_0.animation_definitions
local create_career_icon = var_0_0.create_career_icon

StoreWindowItemDetails = class(StoreWindowItemDetails)
StoreWindowItemDetails.NAME = "StoreWindowItemDetails"

StoreWindowItemDetails.on_enter = function (self, arg_1_1, arg_1_2)
	-- function 1
	print("[HeroViewWindow] Enter Substate StoreWindowItemDetails")

	self._params = arg_1_1
	self._parent = arg_1_1.parent

	local get_renderers, var_1_1 = self._parent:get_renderers()

	self._ui_renderer = get_renderers
	self._ui_top_renderer = var_1_1
	self._render_settings = {
		snap_pixel_positions = true
	}
	self._layout_settings = arg_1_1.layout_settings
	self._animations = {}
	self._ui_animations = {}

	self:_create_ui_elements(arg_1_1, arg_1_2)
	self:_start_transition_animation("on_enter")
	self._parent:set_list_details_visibility(true)
	self._parent:set_list_details_length(680, 0.3)
	self._parent:change_generic_actions("default")
end

StoreWindowItemDetails._start_transition_animation = function (self, arg_2_1)
	-- function 2
	local tbl = {
		render_settings = self._render_settings
	}
	local _widgets_by_name = self._widgets_by_name
	local start_animation = self._ui_animator:start_animation(arg_2_1, _widgets_by_name, scenegraph_definition, tbl)

	self._animations[arg_2_1] = start_animation
end

StoreWindowItemDetails._create_ui_elements = function (self, arg_3_1, arg_3_2)
	-- function 3
	self._ui_scenegraph = UISceneGraph.init_scenegraph(scenegraph_definition)

	local tbl = {}
	local tbl_2 = {}

	for k, v in pairs(widgets) do
		local var_3_2 = UIWidget.init(v)

		tbl[#tbl + 1] = var_3_2
		tbl_2[k] = var_3_2
	end

	self._widgets = tbl
	self._widgets_by_name = tbl_2

	UIRenderer.clear_scenegraph_queue(self._ui_top_renderer)

	self._ui_animator = UIAnimator:new(self._ui_scenegraph, animation_definitions)
end

StoreWindowItemDetails.on_exit = function (self, arg_4_1)
	-- function 4
	print("[HeroViewWindow] Exit Substate StoreWindowItemDetails")

	self._ui_animator = nil
end

StoreWindowItemDetails.update = function (self, arg_5_1, arg_5_2)
	-- function 5
	self:_sync_presentation_item()
	self:_update_animations(arg_5_1)
	self:_draw(arg_5_1)
end

StoreWindowItemDetails.post_update = function (self, arg_6_1, arg_6_2)
	-- function 6
	self:_handle_input(arg_6_1, arg_6_2)
end

StoreWindowItemDetails._update_animations = function (self, arg_7_1)
	-- function 7
	local _ui_animations = self._ui_animations
	local _animations = self._animations
	local _ui_animator = self._ui_animator

	for k, v in pairs(self._ui_animations) do
		UIAnimation.update(v, arg_7_1)

		if not UIAnimation.completed(v) then
			self._ui_animations[k] = nil
		end
	end

	_ui_animator:update(arg_7_1)

	for k_2, v_2 in pairs(_animations) do
		if not _ui_animator:is_animation_completed(v_2) then
			_ui_animator:stop_animation(v_2)

			_animations[k_2] = nil
		end
	end
end

StoreWindowItemDetails._sync_presentation_item = function (self)
	-- function 8
	local selected_product = self._params.selected_product

	if selected_product ~= self._selected_product then
		local flag = not self._selected_product and self._selected_product.product_id ~= selected_product.product_id

		self._selected_product = selected_product

		if not flag then
			local type = selected_product.type

			if type == "item" then
				local item = selected_product.item

				self:_present_item(item)

				self._show_loading_overlay = true
			elseif type == "dlc" then
				local dlc_settings = selected_product.dlc_settings

				self:_present_dlc(dlc_settings)
			end
		end
	end
end

StoreWindowItemDetails._present_dlc = function (self, arg_9_1)
	-- function 9
	local name = arg_9_1.name
	local information_text = arg_9_1.information_text
	local str = "dlc1_2_dlc_level_locked_tooltip"

	self:_set_title_text(Localize(name))
	self:_set_sub_title_text(Localize(str))
	self:_set_description_text(Localize(information_text))
end

StoreWindowItemDetails._present_item = function (self, arg_10_1)
	-- function 10
	local data = arg_10_1.data
	local key = data.key
	local rarity = data.rarity
	local item_type = data.item_type
	local can_wield = data.can_wield
	local compare = table.compare(can_wield, CanWieldAllItemTemplates)
	local _get_hero_wield_info_by_item, var_10_7, var_10_8, var_10_9 = self:_get_hero_wield_info_by_item(arg_10_1)
	local var_10_10 = SPProfiles[var_10_7]
	local flag

	flag = not compare and "store_can_be_wielded_by_all" and var_10_10.character_name

	local str = ""

	if item_type == "weapon_skin" then
		str = Localize(data.matching_item_key)
	elseif item_type == "cosmetic_bundle" then
		str = Localize("dark_pact_skin")
	else
		str = Localize(item_type)
	end

	local get_ui_information_from_item, var_10_14, var_10_15 = UIUtils.get_ui_information_from_item(arg_10_1)
	local get_color_table_with_alpha = Colors.get_color_table_with_alpha(rarity, 255)

	if not compare then
		self:_setup_career_icons(can_wield)
	end

	self:_set_title_text(Localize(var_10_14))
	self:_set_title_text_color(get_color_table_with_alpha)
	self:_set_hero_text(Localize(flag))
	self:_set_sub_title_text(str)
	self:_set_description_text(Localize(var_10_15))
	self:_set_item_icon(get_ui_information_from_item)
end

StoreWindowItemDetails._get_hero_wield_info_by_item = function (arg_11_0, arg_11_1)
	-- function 11
	local var_11_0 = arg_11_1.data.can_wield[1]

	for i, v in ipairs(SPProfiles) do
		local careers = v.careers

		for i_2, v_2 in ipairs(careers) do
			if v_2.name == var_11_0 then
				local display_name = v.display_name
				local var_11_3 = FindProfileIndex(display_name)
				local sort_order = v_2.sort_order

				return display_name, var_11_3, var_11_0, sort_order
			end
		end
	end
end

StoreWindowItemDetails._setup_career_icons = function (self, arg_12_1)
	-- function 12
	local str = "career_icons"
	local var_12_1 = create_career_icon(str)
	local tbl = {}

	if not arg_12_1 then
		local count = #arg_12_1
		local num = 60
		local num_2 = -(num * count / 2 + num / 2)

		for i = 1, count do
			local var_12_6 = arg_12_1[i]
			local var_12_7 = CareerSettings[var_12_6]
			local display_name = var_12_7.display_name

			num_2 = num_2 + num

			local var_12_9 = UIWidget.init(var_12_1)

			var_12_9.offset[1] = num_2

			local tooltip = var_12_9.content.tooltip

			tooltip.title = Localize(display_name)
			tooltip.description = Localize("menu_store_product_wieldable_tooltip_desc")

			local content = var_12_9.content
			local store_tag_icon = var_12_7.store_tag_icon

			store_tag_icon = store_tag_icon or "store_tag_icon_" .. var_12_6
			content.icon = store_tag_icon
			tbl[i] = var_12_9
		end
	end

	self._career_icon_widgets = tbl
end

StoreWindowItemDetails._set_item_icon = function (arg_13_0, arg_13_1)
	-- function 13
	arg_13_0._widgets_by_name.item_icon.content.texture_id = arg_13_1 or "icons_placeholder"
end

StoreWindowItemDetails._set_title_text_color = function (arg_14_0, arg_14_1)
	-- function 14
	arg_14_0._widgets_by_name.title_text.style.text.text_color = arg_14_1
end

StoreWindowItemDetails._set_title_text = function (self, arg_15_1)
	-- function 15
	local title_text = self._widgets_by_name.title_text

	title_text.content.text = arg_15_1

	local scenegraph_id = title_text.scenegraph_id
	local size = scenegraph_definition[scenegraph_id].size
	local _ui_top_renderer = self._ui_top_renderer
	local text = title_text.style.text
	local get_text_height = UIUtils.get_text_height(_ui_top_renderer, size, text, arg_15_1)
	local _ui_scenegraph = self._ui_scenegraph

	_ui_scenegraph[scenegraph_id].size[2] = get_text_height
	_ui_scenegraph.description_text.size[2] = 250 - get_text_height
end

StoreWindowItemDetails._set_hero_text = function (arg_16_0, arg_16_1)
	-- function 16
	arg_16_0._widgets_by_name.hero_text.content.text = arg_16_1
end

StoreWindowItemDetails._set_sub_title_text = function (self, arg_17_1)
	-- function 17
	local sub_title_text = self._widgets_by_name.sub_title_text

	sub_title_text.content.text = arg_17_1

	local _ui_top_renderer = self._ui_top_renderer
	local text = sub_title_text.style.text
	local get_text_width = UIUtils.get_text_width(_ui_top_renderer, text, arg_17_1)
	local scenegraph_id = sub_title_text.scenegraph_id

	self._ui_scenegraph[scenegraph_id].size[1] = get_text_width + 20
end

StoreWindowItemDetails._set_description_text = function (arg_18_0, arg_18_1)
	-- function 18
	arg_18_0._widgets_by_name.description_text.content.text = arg_18_1
end

StoreWindowItemDetails._is_button_pressed = function (arg_19_0, arg_19_1)
	-- function 19
	local content = arg_19_1.content
	local button_hotspot = content.button_hotspot

	button_hotspot = button_hotspot or content.button_text

	if not button_hotspot.on_release then
		button_hotspot.on_release = false

		return true
	end
end

StoreWindowItemDetails._is_stepper_button_pressed = function (arg_20_0, arg_20_1)
	-- function 20
	local content = arg_20_1.content
	local button_hotspot_left = content.button_hotspot_left
	local button_hotspot_right = content.button_hotspot_right

	if not button_hotspot_left.on_release then
		button_hotspot_left.on_release = false

		return true, -1
	elseif not button_hotspot_right.on_release then
		button_hotspot_right.on_release = false

		return true, 1
	end
end

StoreWindowItemDetails._is_button_hover_enter = function (arg_21_0, arg_21_1)
	-- function 21
	return arg_21_1.content.button_hotspot.on_hover_enter
end

StoreWindowItemDetails._is_button_hover_exit = function (arg_22_0, arg_22_1)
	-- function 22
	return arg_22_1.content.button_hotspot.on_hover_exit
end

StoreWindowItemDetails._is_button_selected = function (arg_23_0, arg_23_1)
	-- function 23
	return arg_23_1.content.button_hotspot.is_selected
end

StoreWindowItemDetails._handle_input = function (self, arg_24_1, arg_24_2)
	-- function 24
	local _parent = self._parent
	local _widgets_by_name = self._widgets_by_name
	local window_input_service = self._parent:window_input_service()
end

StoreWindowItemDetails._draw = function (self, arg_25_1)
	-- function 25
	local _ui_top_renderer = self._ui_top_renderer
	local _ui_scenegraph = self._ui_scenegraph
	local window_input_service = self._parent:window_input_service()

	UIRenderer.begin_pass(_ui_top_renderer, _ui_scenegraph, window_input_service, arg_25_1, nil, self._render_settings)

	for i, v in ipairs(self._widgets) do
		UIRenderer.draw_widget(_ui_top_renderer, v)
	end

	local _career_icon_widgets = self._career_icon_widgets

	if not _career_icon_widgets then
		for i_2, v_2 in ipairs(_career_icon_widgets) do
			UIRenderer.draw_widget(_ui_top_renderer, v_2)
		end
	end

	UIRenderer.end_pass(_ui_top_renderer)
end

StoreWindowItemDetails._play_sound = function (self, arg_26_1)
	-- function 26
	self._parent:play_sound(arg_26_1)
end

StoreWindowItemDetails._handle_gamepad_activity = function (self)
	-- function 27
	local is_device_active = Managers.input:is_device_active("gamepad")
	local flag = self._gamepad_active_last_frame == nil

	if not is_device_active then
		if not self._gamepad_active_last_frame and not flag then
			self._gamepad_active_last_frame = true
		end
	elseif self._gamepad_active_last_frame or not flag then
		self._gamepad_active_last_frame = false
	end
end
