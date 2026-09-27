-- chunkname: @scripts/ui/views/hero_view/windows/hero_window_gotwf_overview.lua

require("scripts/ui/reward_popup/reward_popup_ui")

local var_0_0 = local_require("scripts/ui/views/hero_view/windows/definitions/hero_window_gotwf_overview_definitions")
local scenegraph_definition = var_0_0.scenegraph_definition
local widgets = var_0_0.widgets
local lock_widgets = var_0_0.lock_widgets
local bottom_widgets = var_0_0.bottom_widgets
local background_widgets = var_0_0.background_widgets
local viewport_widgets = var_0_0.viewport_widgets
local create_item_definition_func = var_0_0.create_item_definition_func
local create_simple_item = var_0_0.create_simple_item
local create_claim_button = var_0_0.create_claim_button
local animation_definitions = var_0_0.animation_definitions
local gotwf_item_size = var_0_0.gotwf_item_size
local icon_scale = var_0_0.icon_scale
local generic_input_actions = var_0_0.generic_input_actions
local str = "gui/1080p/single_textures/generic/transparent_placeholder_texture"
local num = 7
local tbl = {
	260 * icon_scale,
	220 * icon_scale
}
local tbl_2 = {
	common = "store_thumbnail_bg_common",
	promo = "store_thumbnail_bg_promo",
	plentiful = "store_thumbnail_bg_plentiful",
	rare = "store_thumbnail_bg_rare",
	exotic = "store_thumbnail_bg_exotic",
	magic = "store_thumbnail_bg_magic",
	unique = "store_thumbnail_bg_unique"
}

HeroWindowGotwfOverview = class(HeroWindowGotwfOverview)
HeroWindowGotwfOverview.NAME = "HeroWindowGotwfOverview"

HeroWindowGotwfOverview.on_enter = function (self, arg_1_1, arg_1_2)
	-- function 1
	print("[HeroViewWindow] Enter Substate HeroWindowGotwfOverview")

	local ingame_ui_context = arg_1_1.ingame_ui_context

	self._params = arg_1_1
	self._parent = arg_1_1.parent
	self._ui_renderer = ingame_ui_context.ui_renderer
	self._ui_top_renderer = ingame_ui_context.ui_top_renderer
	self._wwise_world = arg_1_1.wwise_world
	self._render_settings = {
		snap_pixel_positions = false
	}
	self._gamepad_was_active = false
	self._steps = 0
	self._hold_left_timer = 0
	self._hold_right_timer = 0
	self._ready = false
	self._loaded_package_names = {}
	self._cloned_materials_by_reference = {}
	self._animations = {}
	self._ui_animations = {}
	self._ui_animations_callbacks = {}

	self:_reset_current_item()
	self:_init_scenegraph()
	self:_create_background_ui_elements()
	self:_sync_backend_gotwf()

	local flag = true

	self._parent:change_generic_actions(generic_input_actions.default, flag)
	self:_play_sound("Play_amb_gotwf_loop")
end

HeroWindowGotwfOverview._reset_current_item = function (arg_2_0)
	-- function 2
	arg_2_0._params.selected_item = nil
	arg_2_0._params.selected_item_index = nil
	arg_2_0._params.selected_item_claimed = nil
	arg_2_0._params.selected_item_already_owned = nil
end

HeroWindowGotwfOverview._sync_backend_gotwf = function (self)
	-- function 3
	self._synced = false

	Managers.backend:get_interface("peddler"):refresh_login_rewards(callback(self, "gotwf_data_cb"))
end

HeroWindowGotwfOverview.gotwf_data_cb = function (self, arg_4_1)
	-- function 4
	self._login_rewards = arg_4_1

	if arg_4_1.event_type ~= "calendar" then
		self._popup_id = Managers.popup:queue_popup(Localize("event_gotfw_available_soon"), Localize("event_gotfw_name"), "go_back", Localize("menu_ok"))

		return
	end

	self._synced = true
end

HeroWindowGotwfOverview._start_transition_animation = function (self, arg_5_1)
	-- function 5
	local tbl = {
		parent = self._parent,
		render_settings = self._render_settings,
		num_items = self._login_rewards.total_rewards
	}
	local _widgets_by_name = self._widgets_by_name
	local start_animation = self._ui_animator:start_animation(arg_5_1, _widgets_by_name, scenegraph_definition, tbl)

	self._animations[arg_5_1] = start_animation
end

HeroWindowGotwfOverview._start_item_rotation_animation = function (self, arg_6_1, arg_6_2)
	-- function 6
	local tbl = {
		parent = self._parent,
		render_settings = self._render_settings,
		item_widget = arg_6_1,
		reward_index = arg_6_2
	}
	local str = "item_rotation"
	local _widgets_by_name = self._widgets_by_name
	local start_animation = self._ui_animator:start_animation(str, _widgets_by_name, scenegraph_definition, tbl)

	self._animations[str] = start_animation

	self._parent:block_input()

	self._ui_animations_callbacks[str] = function ()
		-- function 7
		self._parent:unblock_input()
	end
end

HeroWindowGotwfOverview._init_scenegraph = function (self)
	-- function 8
	self._ui_scenegraph = UISceneGraph.init_scenegraph(scenegraph_definition)
end

HeroWindowGotwfOverview._create_background_ui_elements = function (self, arg_9_1)
	-- function 9
	local tbl = {}
	local tbl_2 = {}

	for k, v in pairs(background_widgets) do
		local var_9_2 = UIWidget.init(v)

		tbl_2[k] = var_9_2
		tbl[#tbl + 1] = var_9_2
	end

	self._background_widgets = tbl
	self._widgets_by_name = tbl_2
end

HeroWindowGotwfOverview._create_ui_elements = function (self, arg_10_1)
	-- function 10
	local tbl = {}
	local tbl_2 = {}
	local tbl_3 = {}
	local tbl_4 = {}
	local tbl_5 = {}
	local tbl_6 = {}
	local tbl_7 = {}
	local tbl_8 = {}

	self._item_texture_widgets = {}

	for k, v in pairs(widgets) do
		local var_10_8 = UIWidget.init(v)

		tbl[#tbl + 1] = var_10_8
		tbl_8[k] = var_10_8
	end

	for k_2, v_2 in pairs(bottom_widgets) do
		local var_10_9 = UIWidget.init(v_2)

		tbl_5[#tbl_5 + 1] = var_10_9
		tbl_8[k_2] = var_10_9
	end

	for k_3, v_3 in pairs(viewport_widgets) do
		local var_10_10 = UIWidget.init(v_3)

		tbl_6[#tbl_6 + 1] = var_10_10
		tbl_8[k_3] = var_10_10
	end

	for k_4, v_4 in pairs(lock_widgets) do
		local var_10_11 = UIWidget.init(v_4)

		tbl_2[#tbl_2 + 1] = var_10_11
		tbl_8[k_4] = var_10_11
	end

	local total_rewards = self._login_rewards.total_rewards

	for i8 = 1, total_rewards do
		local _create_reward_widget = self:_create_reward_widget(i8)
		local _create_claim_button_widget = self:_create_claim_button_widget(i8)

		tbl_4[#tbl_4 + 1] = _create_reward_widget
		tbl_7[#tbl_7 + 1] = _create_claim_button_widget
		tbl_8["claim_button_" .. i8] = _create_claim_button_widget
	end

	self._widgets = tbl
	self._lock_widgets = tbl_2
	self._bottom_widgets = tbl_5
	self._item_widgets = tbl_4
	self._widgets_by_name = tbl_8
	self._claim_button_widgets = tbl_7
	self._viewport_widgets = tbl_6

	self:_select_current_reward()
	self:_calculate_duration()
	self:_update_claim_button_visibility()
	self:_reset_current_item()
	self:_create_scrollbar()
	self:_create_ui_animator()
	self:_create_reward_popup()
	UIRenderer.clear_scenegraph_queue(self._ui_renderer)
end

HeroWindowGotwfOverview._create_reward_popup = function (self)
	-- function 11
	local tbl = {
		wwise_world = self._wwise_world,
		ui_renderer = self._ui_renderer,
		ui_top_renderer = self._ui_top_renderer,
		input_manager = Managers.input
	}

	self._reward_popup = RewardPopupUI:new(tbl)
end

HeroWindowGotwfOverview._create_ui_animator = function (self)
	-- function 12
	self._ui_animator = UIAnimator:new(self._ui_scenegraph, animation_definitions)
end

HeroWindowGotwfOverview._create_scrollbar = function (self)
	-- function 13
	local num_2 = (#self._item_widgets - num) * gotwf_item_size[1]

	self._scrollbar_ui = ScrollbarUI:new(self._ui_scenegraph, "gotwf_item_anchor", "scrollbar_area", num_2, false, nil, true)
end

HeroWindowGotwfOverview._select_current_reward = function (self)
	-- function 14
	local count = #self._login_rewards.rewards
	local content = self._item_widgets[count].content
	local reward_order = content.reward_order
	local var_14_3 = reward_order[#reward_order]

	content["hotspot_" .. var_14_3].is_selected = true
end

HeroWindowGotwfOverview._calculate_duration = function (self)
	-- function 15
	local _login_rewards = self._login_rewards
	local start_time = _login_rewards.start_time
	local total_rewards = _login_rewards.total_rewards
	local num = _login_rewards.start_time + 86400000 * (total_rewards - 1)
	local date = os.date("%x", start_time * 0.001)
	local date_2 = os.date("%x", num * 0.001)

	self._widgets_by_name.gotwf_description.content.text = date .. " - " .. date_2
end

HeroWindowGotwfOverview._create_claim_button_widget = function (self, arg_16_1)
	-- function 16
	local count = #self._login_rewards.rewards
	local var_16_1 = create_claim_button()
	local var_16_2 = UIWidget.init(var_16_1)

	var_16_2.offset[1] = (arg_16_1 - 1) * gotwf_item_size[1]
	var_16_2.content.reward_offset = arg_16_1 - count

	return var_16_2
end

HeroWindowGotwfOverview._create_reward_widget = function (self, arg_17_1)
	-- function 17
	local start_time = self._login_rewards.start_time
	local rewards = self._login_rewards.rewards
	local count = #rewards
	local num_allowed_old_segments_to_claim = self._login_rewards.num_allowed_old_segments_to_claim
	local max = math.max(count - num_allowed_old_segments_to_claim, 1)
	local flag = self._login_rewards.claimed_rewards[arg_17_1] > 0
	local var_17_6 = rewards[arg_17_1]
	local date = os.date("%x", start_time * 0.001 + 86400 * (arg_17_1 - 1))
	local flag_2 = true
	local var_17_9 = arg_17_1
	local flag_3 = arg_17_1 == count
	local flag_4 = var_17_6 == nil or not flag
	local flag_5 = arg_17_1 < max
	local flag_6 = not not flag or not not flag_5 or arg_17_1 <= count
	local var_17_14 = create_item_definition_func("gotwf_item_anchor", tbl, flag_2, var_17_9, flag_3, date, flag, not flag_4 and not flag, flag_5, flag_6, var_17_6)
	local var_17_15 = UIWidget.init(var_17_14)

	if not var_17_6 and not flag then
		self:_populate_item_widget(var_17_15, arg_17_1, var_17_6)
	end

	return var_17_15
end

HeroWindowGotwfOverview._update_claim_button_visibility = function (self)
	-- function 18
	local count = #self._login_rewards.rewards
	local claimed_rewards = self._login_rewards.claimed_rewards
	local num = count - self._login_rewards.num_allowed_old_segments_to_claim

	for i = 1, #self._claim_button_widgets do
		local var_18_3 = self._claim_button_widgets[i]
		local num_2 = count + var_18_3.content.reward_offset

		if not (count < num_2 or num_2 < num or not (claimed_rewards[num_2] > 0)) then
			var_18_3.content.visible = false
			var_18_3.content.button_hotspot.disable_button = true
		end
	end
end

HeroWindowGotwfOverview._animate_list_entries = function (self, arg_19_1)
	-- function 19
	local _parent = self._parent
	local _list_widgets = self._list_widgets
	local is_device_active = Managers.input:is_device_active("mouse")
	local flag = true

	for i, v in ipairs(self._item_widgets) do
		local flag_2 = not (i > self._steps) or i <= num + self._steps
		local content = v.content
		local style = v.style
		local num_rewards = content.num_rewards

		for k = 1, num_rewards do
			local var_19_8 = content["button_hotspot_" .. k]

			var_19_8 = var_19_8 or content["hotspot_" .. k]

			if not var_19_8.on_hover_enter then
				self:_play_sound("Play_hud_store_button_hover")

				var_19_8.on_hover_enter = false
			end
		end

		local _current_item_index = self._current_item_index

		_current_item_index = _current_item_index or 0
		content.is_gamepad_selected = i ~= _current_item_index or not is_device_active

		self:_animate_item_product(v, arg_19_1, flag_2)
	end
end

HeroWindowGotwfOverview._animate_item_product = function (self, arg_20_1, arg_20_2, arg_20_3)
	-- function 20
	if not self._animations.item_rotation then
		return
	end

	local content = arg_20_1.content
	local style = arg_20_1.style
	local num_rewards = content.num_rewards
	local flag = false

	for i = num_rewards, 1, -1 do
		local var_20_4 = content.reward_order[i]
		local var_20_5 = content["button_hotspot_" .. var_20_4]

		var_20_5 = var_20_5 or content["hotspot_" .. var_20_4]

		local on_hover_enter = var_20_5.on_hover_enter
		local is_hover = var_20_5.is_hover

		if (arg_20_3 == nil or not arg_20_3) and not flag then
			is_hover = false
			on_hover_enter = false
		end

		local is_selected = var_20_5.is_selected

		if not is_selected then
			is_selected = content.is_gamepad_selected
			is_selected = not is_selected and i == num_rewards
		end

		if var_20_5.was_selected or not is_selected then
			var_20_5.was_selected = true
		end

		flag = is_hover or flag

		local is_clicked

		if not is_selected then
			is_clicked = var_20_5.is_clicked

			if not is_clicked then
				-- Nothing
			end

			if var_20_5.is_clicked ~= 0 then
				-- Nothing
			end
		end

		is_clicked = false

		goto label_20_1

		::label_20_0::

		is_clicked = true

		::label_20_1::

		local input_progress = var_20_5.input_progress

		input_progress = input_progress or 0

		local hover_progress = var_20_5.hover_progress

		hover_progress = hover_progress or 0

		local pulse_progress = var_20_5.pulse_progress

		pulse_progress = pulse_progress or 1

		local selection_progress = var_20_5.selection_progress

		selection_progress = selection_progress or 0

		local flag_2

		flag_2 = is_hover or not is_selected or 14 or 3

		local num = 3
		local num_2 = 20

		if not is_clicked then
			input_progress = math.min(input_progress + arg_20_2 * num_2, 1)
		else
			input_progress = math.max(input_progress - arg_20_2 * num_2, 0)
		end

		local easeOutCubic = math.easeOutCubic(input_progress)
		local easeInCubic = math.easeInCubic(input_progress)

		if not on_hover_enter then
			pulse_progress = 0
		end

		local min = math.min(pulse_progress + arg_20_2 * num, 1)
		local easeOutCubic_2 = math.easeOutCubic(min)
		local easeInCubic_2 = math.easeInCubic(min)

		if not is_hover then
			hover_progress = math.min(hover_progress + arg_20_2 * flag_2, 1)
		else
			hover_progress = math.max(hover_progress - arg_20_2 * flag_2, 0)
		end

		local easeOutCubic_3 = math.easeOutCubic(hover_progress)
		local easeInCubic_3 = math.easeInCubic(hover_progress)

		if not is_selected then
			selection_progress = math.min(selection_progress + arg_20_2 * flag_2, 1)
		else
			selection_progress = math.max(selection_progress - arg_20_2 * flag_2, 0)
		end

		local easeOutCubic_4 = math.easeOutCubic(selection_progress)
		local easeInCubic_4 = math.easeInCubic(selection_progress)
		local max = math.max(hover_progress, selection_progress)
		local max_2 = math.max(easeOutCubic_4, easeOutCubic_3)
		local max_3 = math.max(easeInCubic_3, easeInCubic_4)
		local num_3 = 255 * max

		style["hover_frame_" .. var_20_4].color[1] = num_3

		local var_20_30 = style["overlay_" .. var_20_4]

		if not var_20_30 then
			local num_4 = 80 - 80 * max

			var_20_30.color[1] = num_4
		end

		local num_5 = 255 - 255 * min

		style["pulse_frame_" .. var_20_4].color[1] = num_5
		var_20_5.pulse_progress = min
		var_20_5.hover_progress = hover_progress
		var_20_5.input_progress = input_progress
		var_20_5.selection_progress = selection_progress
	end
end

HeroWindowGotwfOverview._populate_painting_data = function (self, arg_21_1, arg_21_2, arg_21_3, arg_21_4)
	-- function 21
	local item_id = arg_21_3.item_id
	local var_21_1 = Paintings[item_id]

	if not (not var_21_1 and item_id ~= "hidden") then
		return
	end

	local gui = self._ui_top_renderer.gui
	local content = arg_21_1.content
	local style = arg_21_1.style
	local var_21_5
	local str = "keep_painting_" .. item_id
	local flag = string.find(item_id, "_none") ~= nil

	if not flag then
		var_21_5 = "resource_packages/keep_paintings/" .. str
	end

	local _reference_id = self._reference_id

	_reference_id = _reference_id or 0
	self._reference_id = _reference_id + 1

	local str_2 = item_id .. "_" .. self._reference_id .. "_" .. arg_21_4
	local str_3 = "keep_painting_" .. item_id
	local str_4 = "template_store_diffuse_masked"

	self:_create_material_instance(gui, str_3, str_4, str_2)

	local function fn()
		-- function 22
		local str_2 = "units/gameplay/keep_paintings/materials/" .. str .. "/" .. str .. "_df"

		self:_set_material_diffuse(gui, str_3, str_2)

		local num = 150 * icon_scale
		local num_2 = 0.125

		if var_21_1.orientation == "horizontal" then
			content["painting_" .. arg_21_4] = {
				texture_id = str_3,
				uvs = {
					{
						0,
						num_2
					},
					{
						1,
						1 - num_2
					}
				}
			}
			style["painting_" .. arg_21_4].offset[2] = 20
			style["painting_" .. arg_21_4].texture_size = {
				num,
				num * (1 - 2 * num_2)
			}
			style["painting_frame_" .. arg_21_4].area_size = {
				num,
				num * (1 - 2 * num_2)
			}
			style["painting_frame_" .. arg_21_4].offset[2] = 20
		else
			content["painting_" .. arg_21_4] = {
				texture_id = str_3,
				uvs = {
					{
						num_2,
						0
					},
					{
						1 - num_2,
						1
					}
				}
			}
			style["painting_" .. arg_21_4].offset[2] = 10
			style["painting_" .. arg_21_4].texture_size = {
				num * (1 - 2 * num_2),
				num
			}
			style["painting_frame_" .. arg_21_4].area_size = {
				num * (1 - 2 * num_2),
				num
			}
			style["painting_frame_" .. arg_21_4].offset[2] = 10
		end

		content.disable_loading_icon = true
	end

	if not flag then
		fn()
	else
		self:_load_texture_package(var_21_5, str_2, fn)
	end
end

HeroWindowGotwfOverview._populate_item_widget = function (self, arg_23_1, arg_23_2, arg_23_3)
	-- function 23
	local _get_reward_item_from_bundle = self:_get_reward_item_from_bundle(arg_23_3)

	if not _get_reward_item_from_bundle then
		if _get_reward_item_from_bundle.reward_type == "keep_decoration_painting" then
			self:_populate_painting_data(arg_23_1, arg_23_2, _get_reward_item_from_bundle, 1)
		else
			self:_populate_item_data(arg_23_1, arg_23_2, _get_reward_item_from_bundle, 1)
		end
	else
		for i = #arg_23_3, 1, -1 do
			local var_23_1 = arg_23_3[i]

			if var_23_1.reward_type == "keep_decoration_painting" then
				self:_populate_painting_data(arg_23_1, arg_23_2, var_23_1, i)
			else
				self:_populate_item_data(arg_23_1, arg_23_2, var_23_1, i)
			end
		end
	end
end

HeroWindowGotwfOverview._populate_item_data = function (self, arg_24_1, arg_24_2, arg_24_3, arg_24_4)
	-- function 24
	local item_rarity_textures = UISettings.item_rarity_textures
	local item_type_store_icons = UISettings.item_type_store_icons
	local item_id = arg_24_3.item_id
	local reward_type = arg_24_3.reward_type
	local var_24_4

	if reward_type == "chips" then
		var_24_4 = Currencies[item_id]
	elseif reward_type == "currency" then
		var_24_4, item_id = BackendUtils.get_fake_currency_item(arg_24_3.currency_code, arg_24_3.amount)
	else
		var_24_4 = ItemMasterList[item_id]
	end

	if not var_24_4 then
		return
	end

	local rarity = var_24_4.rarity

	rarity = rarity or "default"

	local item_type = var_24_4.item_type
	local content = arg_24_1.content
	local style = arg_24_1.style
	local masked = style["icon_" .. arg_24_4].masked

	content["item_" .. arg_24_4] = var_24_4

	local var_24_10 = tbl_2[rarity]

	content["background_" .. arg_24_4] = var_24_10

	local var_24_11 = style["overlay_" .. arg_24_4].offset[3]
	local var_24_12 = style["icon_" .. arg_24_4].offset[3]

	style["icon_" .. arg_24_4].offset[3] = var_24_11
	style["overlay_" .. arg_24_4].offset[3] = var_24_12

	local var_24_13 = item_type_store_icons[item_type]

	if not rarity and not var_24_13 then
		local str = "type_tag_icon_" .. arg_24_4
		local var_24_15 = var_24_13
		local str_2 = "_"
		local flag

		flag = rarity ~= "plentiful" or not "common" or rarity
		content[str] = var_24_15 .. str_2 .. flag
	else
		content["type_tag_icon_" .. arg_24_4] = var_24_13
	end

	local gui = self._ui_top_renderer.gui
	local _reference_id = self._reference_id

	_reference_id = _reference_id or 0
	self._reference_id = _reference_id + 1

	local str_3 = item_id .. "_" .. self._reference_id .. "_" .. arg_24_4

	if item_type == "chips" then
		item_id = "shillings_medium"
	elseif item_type == "versus_currency_name" then
		item_id = "versus_currency_small"
	elseif item_type == "loot_chest" then
		item_id = "loot_chest_generic"
	end

	local store_icon_override_key = var_24_4.store_icon_override_key
	local str_4 = "store_item_icon_" .. (store_icon_override_key or item_id)
	local str_5 = "resource_packages/store/item_icons/" .. str_4

	if item_type == "frame" then
		content.disable_loading_icon = true

		local str_6 = "gotwf_item_anchor"
		local temporary_template = var_24_4.temporary_template

		temporary_template = temporary_template or "default"

		local num = 1
		local num_2 = 20
		local tbl_3 = {
			10 + (arg_24_2 - 1) * (tbl[1] + num_2),
			20,
			0
		}
		local flag_2 = true
		local flag_3 = true
		local create_base_portrait_frame = UIWidgets.create_base_portrait_frame(str_6, temporary_template, num, tbl_3, flag_2, flag_3)

		self._item_texture_widgets[#self._item_texture_widgets + 1] = UIWidget.init(create_base_portrait_frame)

		local material = Gui.material(self._ui_top_renderer.gui, "portrait_frame_gotwf_01_child")

		if not material then
			Material.set_scalar(material, "masked", 1)
		end
	elseif not Application.can_get("package", str_5) then
		content["reference_name_" .. arg_24_4] = str_3
		content["icon_" .. arg_24_4] = nil

		local str_7

		if not masked then
			str_7 = str_4 .. "_masked"

			if not str_7 then
				-- Nothing
			end
		end

		str_7 = str_4

		do
			local flag_4
		end

		::label_24_0::

		flag_4 = not masked and "template_store_diffuse_masked" and "template_store_diffuse"

		self:_create_material_instance(gui, str_7, flag_4, str_3)

		local function fn()
			-- function 25
			local str = "gui/1080p/single_textures/store_item_icons/" .. str_4 .. "/" .. str_4

			self:_set_material_diffuse(gui, str_7, str)

			content["icon_" .. arg_24_4] = str_7
		end

		self:_load_texture_package(str_5, str_3, fn)
	else
		Application.warning("Icon package not accessable for product_id: (%s) and texture_name: (%s)", item_id, str_4)
	end
end

HeroWindowGotwfOverview._create_material_instance = function (arg_26_0, arg_26_1, arg_26_2, arg_26_3, arg_26_4)
	-- function 26
	arg_26_0._cloned_materials_by_reference[arg_26_4] = arg_26_2

	return Gui.clone_material_from_template(arg_26_1, arg_26_2, arg_26_3)
end

HeroWindowGotwfOverview._set_material_diffuse = function (arg_27_0, arg_27_1, arg_27_2, arg_27_3)
	-- function 27
	local material = Gui.material(arg_27_1, arg_27_2)

	if not material then
		Material.set_texture(material, "diffuse_map", arg_27_3)
	end
end

HeroWindowGotwfOverview._load_texture_package = function (arg_28_0, arg_28_1, arg_28_2, arg_28_3)
	-- function 28
	local flag = true
	local flag_2 = false

	Managers.package:load(arg_28_1, arg_28_2, arg_28_3, flag, flag_2)

	arg_28_0._loaded_package_names[arg_28_2] = arg_28_1
end

HeroWindowGotwfOverview._is_unique_reference_to_material = function (self, arg_29_1)
	-- function 29
	local _cloned_materials_by_reference = self._cloned_materials_by_reference
	local var_29_1 = _cloned_materials_by_reference[arg_29_1]

	fassert(var_29_1, "[HeroWindowGotwfOverview] - Could not find a used material for reference name: (%s)", arg_29_1)

	for k, v in pairs(_cloned_materials_by_reference) do
		if not (var_29_1 ~= v or arg_29_1 == k) then
			return false
		end
	end

	return true
end

HeroWindowGotwfOverview._unload_texture_by_reference = function (self, arg_30_1)
	-- function 30
	local _loaded_package_names = self._loaded_package_names
	local _cloned_materials_by_reference = self._cloned_materials_by_reference
	local var_30_2 = _loaded_package_names[arg_30_1]

	fassert(var_30_2, "[HeroWindowGotwfOverview] - Could not find a package to unload for reference name: (%s)", arg_30_1)
	Managers.package:unload(var_30_2, arg_30_1)

	_loaded_package_names[arg_30_1] = nil

	if not self:_is_unique_reference_to_material(arg_30_1) then
		local var_30_3 = _cloned_materials_by_reference[arg_30_1]
		local gui = self._ui_top_renderer.gui

		self:_set_material_diffuse(gui, var_30_3, str)
	end

	_cloned_materials_by_reference[arg_30_1] = nil
end

HeroWindowGotwfOverview._play_sound = function (self, arg_31_1)
	-- function 31
	self._parent:play_sound(arg_31_1)
end

HeroWindowGotwfOverview.on_exit = function (self, arg_32_1)
	-- function 32
	print("[HeroViewWindow] Exit Substate HeroWindowGotwfOverview")

	self._ui_animator = nil

	local _loaded_package_names = self._loaded_package_names

	for k, v in pairs(_loaded_package_names) do
		self:_unload_texture_by_reference(k)
	end

	if not self._reward_popup then
		self._reward_popup:destroy()

		self._reward_popup = nil
	end

	self:_play_sound("Stop_amb_gotwf_loop")
end

HeroWindowGotwfOverview.update = function (self, arg_33_1, arg_33_2)
	-- function 33
	if not self._ready then
		self:_handle_reward_popup(arg_33_1, arg_33_2)
		self:_update_animations(arg_33_1)
		self:_draw(arg_33_1, arg_33_2)
	else
		self:_check_ready()
	end

	self:_handle_popup()
	self:_draw_background(arg_33_1, arg_33_2)
end

HeroWindowGotwfOverview._handle_reward_popup = function (self, arg_34_1, arg_34_2)
	-- function 34
	self._reward_popup:update(arg_34_1)
end

HeroWindowGotwfOverview._check_ready = function (self)
	-- function 35
	if not (self._params.loading_package or self._synced) then
		return
	end

	self._ready = true

	self:_create_ui_elements(self._params)
	self:_start_transition_animation("on_enter")
end

HeroWindowGotwfOverview._handle_popup = function (self)
	-- function 36
	local _popup_id = self._popup_id

	if not _popup_id then
		return
	end

	if not Managers.popup:query_result(_popup_id) then
		self._parent:set_layout_by_name("featured")
	end
end

HeroWindowGotwfOverview._claim_daily_reward = function (self, arg_37_1)
	-- function 37
	if not (self._login_rewards.num_allowed_old_segments_to_claim < math.abs(arg_37_1) or not (arg_37_1 > 0)) then
		return
	end

	local get_interface = Managers.backend:get_interface("peddler")
	local num = #self._login_rewards.rewards + (arg_37_1 or 0)

	if self._login_rewards.claimed_rewards[num] > 0 then
		return
	end

	get_interface:claim_login_rewards(callback(self, "_claim_reward_result_cb", num), arg_37_1)

	self._force_index = #self._login_rewards.rewards + (arg_37_1 or 0)
	self._awaiting_result = true

	self._parent:block_input()
	self:_play_sound("Play_hud_gotwf_claim")
end

HeroWindowGotwfOverview._claim_reward_result_cb = function (self, arg_38_1, arg_38_2)
	-- function 38
	if not self._ui_animator then
		return
	end

	if arg_38_2.event_type ~= "calendar" then
		self._awaiting_result = false

		self._parent:unblock_input()
		Managers.ui:handle_transition("close_active", {
			fade_out_speed = 1,
			use_fade = true,
			fade_in_speed = 1
		})

		return
	end

	self._login_rewards = arg_38_2

	local var_38_0 = self._login_rewards.rewards[arg_38_1]
	local count

	if not var_38_0 then
		count = #var_38_0

		if not count then
			-- Nothing
		end
	end

	count = 0

	::label_38_0::

	if count == 0 then
		self._awaiting_result = false

		self._parent:unblock_input()

		return
	end

	self._replacement_presentation_data = self:_gather_replacement_presentation_data(arg_38_1)
	self._item_widgets[arg_38_1].content.visible = false

	self:_update_claim_button_visibility()
	self:_reset_current_item()
	self:_start_transition_animation("hide_item_list")
	self:_start_transition_animation("lock_open")

	self._ui_animations_callbacks.lock_open = callback(self, "_start_transition_animation", "lock_close")
	self._ui_animations_callbacks.lock_close = callback(self, "_start_transition_animation", "reveal")

	self._ui_animations_callbacks.reveal = function ()
		-- function 39
		self:_update_daily_rewards(arg_38_1)
		self:_start_transition_animation("show_item_list")
		self:_trigger_replacement_rewards()
	end

	Managers.backend:commit()
	self:_play_sound("Play_hud_gotwf_animation_start")
end

HeroWindowGotwfOverview._trigger_replacement_rewards = function (self)
	-- function 40
	if not self._replacement_presentation_data then
		return
	end

	self._reward_popup:display_presentation(self._replacement_presentation_data)

	self._replacement_presentation_data = nil
end

local tbl_3 = {}

HeroWindowGotwfOverview._gather_replacement_presentation_data = function (self, arg_41_1)
	-- function 41
	if self._login_rewards.claimed_rewards[arg_41_1] < 2 then
		return
	end

	table.clear(tbl_3)

	local var_41_0 = self._login_rewards.currency_added[1]

	if not var_41_0 then
		return
	end

	local get_fake_currency_item = BackendUtils.get_fake_currency_item
	local code = var_41_0.code

	code = code or "SM"

	local var_41_3, var_41_4, var_41_5 = get_fake_currency_item(code, var_41_0.amount)
	local tbl = {
		data = var_41_3
	}
	local tbl_2 = {}
	local get_ui_information_from_item, var_41_9, var_41_10 = UIUtils.get_ui_information_from_item(tbl)

	tbl_2[1] = Localize(var_41_9)
	tbl_2[2] = string.format(Localize(var_41_5), var_41_0.amount)

	local tbl_4 = {}

	tbl_4[#tbl_4 + 1] = {
		widget_type = "description",
		value = tbl_2
	}
	tbl_4[#tbl_4 + 1] = {
		widget_type = "icon",
		value = tbl.data.icon
	}
	tbl_3[#tbl_3 + 1] = tbl_4
	tbl_3.bg_alpha = 200
	tbl_3.offset = {
		0,
		190,
		1
	}

	return tbl_3
end

HeroWindowGotwfOverview._update_daily_rewards = function (self, arg_42_1)
	-- function 42
	local _create_reward_widget = self:_create_reward_widget(arg_42_1)

	self._item_widgets[arg_42_1] = _create_reward_widget

	self:_select_current_reward(self._current_item_index)
	self:_update_selected_reward(_create_reward_widget)
	self:_update_claim_button_visibility()

	self._awaiting_result = false

	self._parent:unblock_input()
end

HeroWindowGotwfOverview._update_selected_reward = function (self, arg_43_1)
	-- function 43
	local _login_rewards = self._login_rewards
	local rewards = _login_rewards.rewards
	local claimed_rewards = _login_rewards.claimed_rewards
	local content = arg_43_1.content
	local reward_order = content.reward_order
	local var_43_5 = reward_order[#reward_order]

	content["hotspot_" .. var_43_5].is_selected = true

	local var_43_6 = rewards[self._current_item_index]
	local _get_reward_item_from_bundle = self:_get_reward_item_from_bundle(var_43_6)

	_get_reward_item_from_bundle = _get_reward_item_from_bundle or var_43_6[math.min(var_43_5, #var_43_6)]

	local var_43_8 = claimed_rewards[self._current_item_index]
	local flag = var_43_8 > 0
	local flag_2 = var_43_8 > 1

	self._params.selected_item = not flag and _get_reward_item_from_bundle
	self._params.selected_item_index = not flag and self._current_item_index
	self._params.selected_item_claimed = flag
	self._params.selected_item_already_owned = flag_2
	self._current_item_index = self._current_item_index
end

HeroWindowGotwfOverview.post_update = function (self, arg_44_1, arg_44_2)
	-- function 44
	if not self._ready then
		self:_animate_list_entries(arg_44_1, arg_44_2)
		self:_animate_buttons(arg_44_1, arg_44_2)
		self:_handle_arrow_visibility(arg_44_1, arg_44_2)
		self:_handle_input(arg_44_1, arg_44_2)
		self:_handle_input_descriptions(arg_44_1, arg_44_2)
	end
end

HeroWindowGotwfOverview._animate_buttons = function (self, arg_45_1, arg_45_2)
	-- function 45
	local _claim_button_widgets = self._claim_button_widgets

	for k, v in pairs(_claim_button_widgets) do
		self:_animate_button(v, arg_45_1, arg_45_2)
	end
end

HeroWindowGotwfOverview._animate_button = function (arg_46_0, arg_46_1, arg_46_2)
	-- function 46
	local content = arg_46_1.content
	local style = arg_46_1.style
	local button_hotspot = content.button_hotspot
	local is_hover = button_hotspot.is_hover
	local is_selected = button_hotspot.is_selected
	local is_clicked = button_hotspot.is_clicked

	is_clicked = not is_clicked and button_hotspot.is_clicked == 0

	local input_progress = button_hotspot.input_progress

	input_progress = input_progress or 0

	local hover_progress = button_hotspot.hover_progress

	hover_progress = hover_progress or 0

	local selection_progress = button_hotspot.selection_progress

	selection_progress = selection_progress or 0

	local num = 8
	local num_2 = 20

	if not is_clicked then
		input_progress = math.min(input_progress + arg_46_2 * num_2, 1)
	else
		input_progress = math.max(input_progress - arg_46_2 * num_2, 0)
	end

	if not is_hover then
		hover_progress = math.min(hover_progress + arg_46_2 * num, 1)
	else
		hover_progress = math.max(hover_progress - arg_46_2 * num, 0)
	end

	if not is_selected then
		selection_progress = math.min(selection_progress + arg_46_2 * num, 1)
	else
		selection_progress = math.max(selection_progress - arg_46_2 * num, 0)
	end

	local max = math.max(hover_progress, selection_progress)

	style.clicked_rect.color[1] = 100 * input_progress

	local num_3 = 255 * hover_progress

	style.hover_glow.color[1] = num_3

	local title_text_disabled = style.title_text_disabled
	local default_text_color = title_text_disabled.default_text_color
	local text_color = title_text_disabled.text_color

	text_color[2] = default_text_color[2] * 0.4
	text_color[3] = default_text_color[3] * 0.4
	text_color[4] = default_text_color[4] * 0.4
	button_hotspot.hover_progress = hover_progress
	button_hotspot.input_progress = input_progress
	button_hotspot.selection_progress = selection_progress

	local title_text = style.title_text
	local text_color_2 = title_text.text_color
	local default_text_color_2 = title_text.default_text_color
	local select_text_color = title_text.select_text_color

	Colors.lerp_color_tables(default_text_color_2, select_text_color, max, text_color_2)
end

HeroWindowGotwfOverview._handle_arrow_visibility = function (self, arg_47_1, arg_47_2)
	-- function 47
	if not self._ui_animations.move then
		self._scrollbar_ui:force_update_progress()

		return
	end

	local content = self._widgets_by_name.arrow_left.content
	local content_2 = self._widgets_by_name.arrow_right.content
	local total_rewards = self._login_rewards.total_rewards

	if total_rewards <= num then
		content.visible = false
		content.hotspot = {}
		content_2.visible = false
		content_2.hotspot = {}
	elseif self._steps > 0 then
		content.visible = true

		if self._steps < total_rewards - num then
			content_2.visible = true
		else
			content_2.visible = false
			content_2.hotspot = {}
		end
	elseif self._steps == 0 then
		content.visible = false
		content.hotspot = {}
		content_2.visible = true
	end
end

HeroWindowGotwfOverview._update_animations = function (self, arg_48_1)
	-- function 48
	local _ui_animations = self._ui_animations
	local _animations = self._animations
	local _ui_animator = self._ui_animator

	for k, v in pairs(self._ui_animations) do
		UIAnimation.update(v, arg_48_1)

		if not UIAnimation.completed(v) then
			self._ui_animations[k] = nil
		end
	end

	_ui_animator:update(arg_48_1)

	for k_2, v_2 in pairs(_animations) do
		if not _ui_animator:is_animation_completed(v_2) then
			_ui_animator:stop_animation(v_2)

			_animations[k_2] = nil

			local var_48_3 = self._ui_animations_callbacks[k_2]

			if not var_48_3 then
				var_48_3()
			end
		end
	end

	if not self._ui_animations.move then
		self._scrollbar_ui:force_update_progress()
	else
		local abs = math.abs(self._ui_scenegraph.gotwf_item_anchor.local_position[1])

		self._steps = math.ceil(abs / gotwf_item_size[1])
	end
end

HeroWindowGotwfOverview._handle_input = function (self, arg_49_1, arg_49_2)
	-- function 49
	local _parent = self._parent
	local _widgets_by_name = self._widgets_by_name
	local is_device_active = Managers.input:is_device_active("gamepad")
	local is_device_active_2 = Managers.input:is_device_active("mouse")
	local window_input_service = self._parent:window_input_service()
	local local_position = self._ui_scenegraph.gotwf_item_anchor.local_position
	local total_rewards = self._login_rewards.total_rewards
	local count = #self._login_rewards.rewards
	local max = math.max(total_rewards - num, 0)
	local _current_item_index = self._current_item_index
	local _steps = self._steps
	local _params = self._params
	local flag = false
	local claimed_rewards = self._login_rewards.claimed_rewards

	if not self._current_item_index then
		self._current_item_index = count
		self._steps = math.clamp(self._current_item_index + 3 - num, 0, max)
		flag = true
	elseif not self._force_index then
		self._current_item_index = self._force_index
		self._steps = math.clamp(self._current_item_index + 3 - num, 0, max)
		flag = true
		self._force_index = nil
	end

	local var_49_14 = claimed_rewards[self._current_item_index]

	if not (not is_device_active and self._gamepad_was_active) then
		self._steps = math.clamp(self._current_item_index + 3 - num, 0, max)

		local _current_item_index_2 = self._current_item_index

		_current_item_index_2 = _current_item_index_2 or self._steps + 1
		self._current_item_index = _current_item_index_2
		flag = true

		if not is_device_active then
			for i = 1, table.size(self._claim_button_widgets) do
				self._claim_button_widgets[i].content.gamepad_selected = i == self._current_item_index
			end

			local content = self._item_widgets[self._current_item_index].content
			local reward_order = content.reward_order
			local var_49_18 = reward_order[#reward_order]

			content["hotspot_" .. var_49_18].is_selected = not (var_49_14 > 0) or true
		else
			for i_2, v in ipairs(self._item_widgets) do
				local content_2 = v.content
				local num_rewards = content_2.num_rewards

				for l = 1, num_rewards do
					content_2["hotspot_" .. l].is_selected = false
				end
			end
		end

		self._scrollbar_ui:disable_input(true)
	elseif is_device_active or not self._gamepad_was_active then
		self._scrollbar_ui:disable_input(false)
	end

	if not (self._awaiting_result or flag) then
		local num_2 = 0
		local num_3 = 0

		if not window_input_service:get("move_left_hold") then
			num_2 = self._hold_left_timer + arg_49_1
			num_3 = 0
		elseif not window_input_service:get("move_right_hold") then
			num_3 = self._hold_right_timer + arg_49_1
			num_2 = 0
		else
			num_3 = 0
			num_2 = 0
		end

		if not is_device_active_2 then
			if not (window_input_service:get("move_left") or not (num_2 > 0.5)) then
				if num_2 > 0.5 then
					num_2 = 0.4
				end

				self._current_item_index = math.clamp(self._current_item_index - 1, 1, total_rewards)
				self._steps = math.clamp(self._current_item_index + 3 - num, 0, max)
			elseif not ((window_input_service:get("move_right") or num_3 > 0.5) and not (total_rewards > self._current_item_index)) then
				if num_3 > 0.5 then
					num_3 = 0.4
				end

				self._current_item_index = math.clamp(self._current_item_index + 1, 1, total_rewards)
				self._steps = math.clamp(self._current_item_index + 3 - num, 0, max)
			end

			if not window_input_service:get("confirm_press") then
				local num_4 = self._current_item_index - count

				self:_claim_daily_reward(num_4)
			elseif not window_input_service:get("special_1_press") then
				local var_49_24 = self._item_widgets[self._current_item_index]
				local content_3 = var_49_24.content
				local num_rewards_2 = content_3.num_rewards

				if num_rewards_2 > 1 then
					_current_item_index = nil

					local var_49_27 = content_3.reward_order[1]

					for i4 = 1, num_rewards_2 do
						content_3["hotspot_" .. i4].is_selected = false
					end

					self:_start_item_rotation_animation(var_49_24, var_49_27)
					self:_play_sound("Play_hud_gotwf_click_claimed")
				end
			end
		elseif not UIUtils.is_button_pressed(_widgets_by_name.arrow_right, "hotspot") then
			self._steps = math.clamp(self._steps + 1, 0, total_rewards - num)
		elseif not UIUtils.is_button_pressed(_widgets_by_name.arrow_left, "hotspot") then
			self._steps = math.clamp(self._steps - 1, 0, total_rewards - num)
		else
			for i_3, v_2 in ipairs(self._item_widgets) do
				local content_4 = v_2.content
				local num_rewards_3 = content_4.num_rewards

				for i7 = num_rewards_3, 1, -1 do
					local var_49_30 = content_4.reward_order[i7]

					if not UIUtils.is_button_pressed(v_2, "hotspot_" .. var_49_30) then
						self._current_item_index = i_3

						local content_5 = v_2.content
						local reward_order_2 = content_5.reward_order

						if not content_5.owned then
							local find = table.find(reward_order_2, var_49_30)

							if not (not (num_rewards_3 > 1) or not (find < num_rewards_3)) then
								self:_start_item_rotation_animation(v_2, var_49_30)

								_current_item_index = nil

								local num_rewards_4 = content_5.num_rewards

								for i8 = 1, num_rewards_4 do
									content_5["hotspot_" .. i8].is_selected = false
								end
							end
						end

						break
					end
				end
			end

			for k, v_3 in pairs(self._claim_button_widgets) do
				if not UIUtils.is_button_pressed(v_3) then
					local reward_offset = v_3.content.reward_offset

					self:_claim_daily_reward(reward_offset)

					return
				end
			end
		end

		self._hold_right_timer = num_3
		self._hold_left_timer = num_2
	end

	if self._current_item_index ~= _current_item_index then
		if not _current_item_index then
			local content_6 = self._item_widgets[_current_item_index].content
			local num_rewards_5 = content_6.num_rewards

			for i11 = 1, num_rewards_5 do
				content_6["hotspot_" .. i11].is_selected = false
			end

			self._claim_button_widgets[_current_item_index].content.gamepad_selected = false
		end

		local var_49_38 = self._login_rewards.claimed_rewards[self._current_item_index]
		local flag_2 = var_49_38 > 0
		local flag_3 = var_49_38 > 1

		self._claim_button_widgets[self._current_item_index].content.gamepad_selected = true

		local content_7 = self._item_widgets[self._current_item_index].content
		local reward_order_3 = content_7.reward_order
		local num_rewards_6 = content_7.num_rewards
		local min = math.min(num_rewards_6, reward_order_3[#reward_order_3])

		content_7["hotspot_" .. min].is_selected = flag_2

		if not content_7.owned then
			self:_play_sound("Play_hud_gotwf_click_claimed")
		else
			self:_play_sound("Play_hud_gotwf_click_unclaimed")
		end

		local var_49_45 = self._login_rewards.rewards[self._current_item_index]
		local flag_4 = not var_49_45 and var_49_45[min] and self:_get_reward_item_from_bundle(var_49_45)

		self._params.selected_item = not flag_2 and flag_4
		self._params.selected_item_index = not flag_2 and self._current_item_index
		self._params.selected_item_claimed = flag_2
		self._params.selected_item_already_owned = flag_3

		if not flag_2 then
			self:_start_transition_animation("reveal_instant")
		else
			self:_start_transition_animation("hide_instant")
		end
	end

	if _steps ~= self._steps or not flag then
		self._ui_animations.move = UIAnimation.init(UIAnimation.function_by_time, local_position, 1, local_position[1], -self._steps * gotwf_item_size[1], 0.5, math.easeOutCubic)
	end

	self._gamepad_was_active = is_device_active
end

HeroWindowGotwfOverview._get_reward_item_from_bundle = function (arg_50_0, arg_50_1)
	-- function 50
	if not arg_50_1 then
		return
	end

	local var_50_0 = arg_50_1[1]

	if var_50_0.reward_type == "bundle" then
		local item_id = var_50_0.item_id
		local BundledItems = ItemMasterList[item_id].bundle.BundledItems
		local local_player = Managers.player:local_player()
		local profile_index = local_player:profile_index()
		local career_index = local_player:career_index()
		local name = SPProfiles[profile_index].careers[career_index].name
		local num = 1

		for i = 1, #BundledItems do
			local var_50_8 = BundledItems[i]
			local var_50_9 = rawget(ItemMasterList, var_50_8)

			var_50_9 = var_50_9 or {}

			if not table.contains(var_50_9.can_wield, name) then
				num = i

				break
			end
		end

		return {
			reward_type = "bundle_item",
			item_id = BundledItems[num],
			bundle_item_id = var_50_0.item_id
		}
	end
end

HeroWindowGotwfOverview._handle_input_descriptions = function (self, arg_51_1, arg_51_2)
	-- function 51
	local flag = true
	local count = #self._login_rewards.rewards
	local num = self._current_item_index - count
	local var_51_3 = self._login_rewards.rewards[self._current_item_index]
	local count_2

	if not var_51_3 then
		count_2 = #var_51_3

		if not count_2 then
			-- Nothing
		end
	end

	count_2 = 1

	::label_51_0::

	local flag_2 = self._login_rewards.claimed_rewards[self._current_item_index] > 0
	local num_allowed_old_segments_to_claim = self._login_rewards.num_allowed_old_segments_to_claim

	if not flag_2 then
		if count_2 > 1 then
			self._parent:change_generic_actions(generic_input_actions.multiple_rewards, flag)
		else
			self._parent:change_generic_actions(generic_input_actions.default, flag)
		end
	elseif not (not (num >= -num_allowed_old_segments_to_claim) or not (num <= 0)) then
		self._parent:change_generic_actions(generic_input_actions.claim_available, flag)
	else
		self._parent:change_generic_actions(generic_input_actions.default, flag)
	end
end

HeroWindowGotwfOverview._draw = function (self, arg_52_1, arg_52_2)
	-- function 52
	local _parent = self._parent
	local get_layout_renderer = self._parent:get_layout_renderer()
	local _ui_renderer = self._ui_renderer
	local _ui_top_renderer = self._ui_top_renderer
	local _ui_scenegraph = self._ui_scenegraph
	local window_input_service = self._parent:window_input_service()
	local _render_settings = self._render_settings
	local count = #self._item_widgets
	local claimed_rewards = self._login_rewards.claimed_rewards
	local alpha_multiplier = _render_settings.alpha_multiplier

	UIRenderer.begin_pass(_ui_top_renderer, _ui_scenegraph, window_input_service, arg_52_1, nil, _render_settings)

	for i, v in ipairs(self._widgets) do
		_render_settings.snap_pixel_positions = false

		local alpha_multiplier_2 = v.alpha_multiplier

		alpha_multiplier_2 = alpha_multiplier_2 or alpha_multiplier
		_render_settings.alpha_multiplier = alpha_multiplier_2

		UIRenderer.draw_widget(_ui_top_renderer, v)
	end

	if claimed_rewards[self._current_item_index] > 0 or not self._awaiting_result then
		for i_2, v_2 in ipairs(self._lock_widgets) do
			_render_settings.snap_pixel_positions = false

			local alpha_multiplier_3 = v_2.alpha_multiplier

			alpha_multiplier_3 = alpha_multiplier_3 or alpha_multiplier
			_render_settings.alpha_multiplier = alpha_multiplier_3

			UIRenderer.draw_widget(_ui_top_renderer, v_2)
		end
	end

	for i_3, v_3 in ipairs(self._item_texture_widgets) do
		_render_settings.snap_pixel_positions = false

		local alpha_multiplier_4 = v_3.alpha_multiplier

		alpha_multiplier_4 = alpha_multiplier_4 or alpha_multiplier
		_render_settings.alpha_multiplier = alpha_multiplier_4

		UIRenderer.draw_widget(_ui_top_renderer, v_3)
	end

	local abs = math.abs(self._ui_scenegraph.gotwf_item_anchor.local_position[1])
	local ceil = math.ceil(abs / gotwf_item_size[1])

	for i_4, v_4 in ipairs(self._item_widgets) do
		if not (not (i_4 > ceil - 1) or not (i_4 <= num + ceil + 1)) then
			_render_settings.snap_pixel_positions = false

			local alpha_multiplier_5 = v_4.alpha_multiplier

			alpha_multiplier_5 = alpha_multiplier_5 or alpha_multiplier
			_render_settings.alpha_multiplier = alpha_multiplier_5

			UIRenderer.draw_widget(_ui_top_renderer, v_4)
		end
	end

	local abs_2 = math.abs(self._ui_scenegraph.gotwf_item_anchor.local_position[1])
	local ceil_2 = math.ceil(abs_2 / gotwf_item_size[1])

	for i_5, v_5 in ipairs(self._claim_button_widgets) do
		if not (not (i_5 > ceil_2 - 1) or not (i_5 <= num + ceil_2 + 1)) then
			_render_settings.snap_pixel_positions = false

			local alpha_multiplier_6 = v_5.alpha_multiplier

			alpha_multiplier_6 = alpha_multiplier_6 or alpha_multiplier
			_render_settings.alpha_multiplier = alpha_multiplier_6

			UIRenderer.draw_widget(_ui_top_renderer, v_5)
		end
	end

	UIRenderer.end_pass(_ui_top_renderer)

	local alpha_multiplier_7 = _render_settings.alpha_multiplier

	UIRenderer.begin_pass(_ui_renderer, _ui_scenegraph, window_input_service, arg_52_1, nil, _render_settings)

	for i_6, v_6 in ipairs(self._bottom_widgets) do
		_render_settings.snap_pixel_positions = false

		local alpha_multiplier_8 = v_6.alpha_multiplier

		alpha_multiplier_8 = alpha_multiplier_8 or alpha_multiplier_7
		_render_settings.alpha_multiplier = alpha_multiplier_8

		UIRenderer.draw_widget(_ui_renderer, v_6)
	end

	UIRenderer.end_pass(_ui_renderer)

	if not get_layout_renderer then
		UIRenderer.begin_pass(get_layout_renderer, _ui_scenegraph, window_input_service, arg_52_1, nil, self._render_settings)

		for i_7, v_7 in ipairs(self._viewport_widgets) do
			UIRenderer.draw_widget(get_layout_renderer, v_7)
		end

		UIRenderer.end_pass(get_layout_renderer)
	end

	_render_settings.alpha_multiplier = alpha_multiplier_7

	self._scrollbar_ui:update(arg_52_1, arg_52_2, _ui_top_renderer, window_input_service, _render_settings)
end

HeroWindowGotwfOverview._draw_background = function (self, arg_53_1, arg_53_2)
	-- function 53
	local _parent = self._parent
	local _ui_top_renderer = self._ui_top_renderer
	local _ui_scenegraph = self._ui_scenegraph
	local window_input_service = self._parent:window_input_service()
	local _render_settings = self._render_settings
	local alpha_multiplier = _render_settings.alpha_multiplier

	_render_settings.alpha_multiplier = 1

	UIRenderer.begin_pass(_ui_top_renderer, _ui_scenegraph, window_input_service, arg_53_1, nil, _render_settings)

	for i, v in ipairs(self._background_widgets) do
		_render_settings.alpha_multiplier = 1

		UIRenderer.draw_widget(_ui_top_renderer, v)
	end

	UIRenderer.end_pass(_ui_top_renderer)

	_render_settings.alpha_multiplier = alpha_multiplier
end
