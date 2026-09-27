-- chunkname: @scripts/ui/reward_popup/reward_popup_ui.lua

local var_0_0 = local_require("scripts/ui/reward_popup/reward_popup_ui_definitions")
local scenegraph_definition = var_0_0.scenegraph_definition
local animations = var_0_0.animations
local item_list_padding = var_0_0.item_list_padding

RewardPopupUI = class(RewardPopupUI)

local num = 10
local num_2 = 2.5
local str = "rewards_popups"

local function fn(self)
	-- function 1
	local get = self:get("toggle_menu", true)

	if not get then
		get = self:get("back", true)

		if not get then
			get = self:get("skip_pressed", true)
			get = get or self:get("left_press")
		end
	end

	return get
end

RewardPopupUI.init = function (self, arg_2_1)
	-- function 2
	self._ui_top_renderer = arg_2_1.ui_top_renderer
	self._input_manager = arg_2_1.input_manager

	local world = arg_2_1.world

	world = world or arg_2_1.ui_renderer.world
	self.world = world
	self._wwise_world = arg_2_1.wwise_world or arg_2_1.world_manager:wwise_world(self.world)
	self._render_settings = {
		snap_pixel_positions = true
	}
	self._skip_blur = false

	self:create_ui_elements()
	self:_setup_input()
end

RewardPopupUI.create_ui_elements = function (self)
	-- function 3
	self._ui_scenegraph = UISceneGraph.init_scenegraph(scenegraph_definition)

	local widget_definitions = var_0_0.widget_definitions

	self.background_top_widget = UIWidget.init(widget_definitions.background_top)
	self.background_center_widget = UIWidget.init(widget_definitions.background_center)
	self.background_bottom_widget = UIWidget.init(widget_definitions.background_bottom)
	self.background_bottom_glow_widget = UIWidget.init(widget_definitions.background_bottom_glow)
	self.background_top_glow_widget = UIWidget.init(widget_definitions.background_top_glow)
	self.screen_background_widget = UIWidget.init(widget_definitions.screen_background)
	self.deus_background_top_widget = UIWidget.init(widget_definitions.deus_background_top)
	self.deus_background_bottom_widget = UIWidget.init(widget_definitions.deus_background_bottom)
	self.deus_background_top_glow_widget = UIWidget.init(widget_definitions.deus_background_top_glow)
	self.deus_background_bottom_glow_widget = UIWidget.init(widget_definitions.deus_background_bottom_glow)
	self.claim_button_widget = UIWidget.init(widget_definitions.claim_button)
	self._ui_animator = UIAnimator:new(self._ui_scenegraph, animations)
	self._animations = {}
	self._is_visible = true
	self._speed_up_popup = false
	self._done_reset_speed_up_popup = false
end

RewardPopupUI.set_input_manager = function (self, arg_4_1)
	-- function 4
	self._input_manager = arg_4_1

	self:_setup_input()
end

RewardPopupUI.destroy = function (self)
	-- function 5
	self:_release_input()

	self._ui_animator = nil

	self:set_visible(false)

	if not self._fullscreen_effect_enabled then
		self:set_fullscreen_effect_enable_state(false)
	end
end

RewardPopupUI.set_visible = function (self, arg_6_1)
	-- function 6
	self._is_visible = arg_6_1
end

RewardPopupUI.update = function (self, arg_7_1, arg_7_2)
	-- function 7
	if not self.input_acquired and not self:is_presentation_complete() then
		self:_release_input()
	end

	if not (not self._is_visible and self._draw_widgets) then
		return
	end

	if not (self._speed_up_popup or self._handling_claim_button) then
		local get_service = self._input_manager:get_service(str)

		if not fn(get_service) then
			self._speed_up_popup = true
		end
	else
		local _animation_presentation_data = self._animation_presentation_data

		if not _animation_presentation_data then
			if not _animation_presentation_data.end_animation_key then
				arg_7_1 = arg_7_1 * num_2
			else
				arg_7_1 = arg_7_1 * num
			end
		end
	end

	self:_update_presentation_animation(arg_7_1)
	self:_update_animations(arg_7_1)

	local _animation_params = self._animation_params

	if not _animation_params then
		local blur_progress = _animation_params.blur_progress

		blur_progress = blur_progress or 1

		self:set_fullscreen_effect_enable_state(true, blur_progress)
	end

	self:draw(arg_7_1)
end

RewardPopupUI._update_animations = function (self, arg_8_1)
	-- function 8
	local _animations = self._animations
	local _ui_animator = self._ui_animator

	_ui_animator:update(arg_8_1)

	local flag = false

	for k, v in pairs(_animations) do
		if not _ui_animator:is_animation_completed(v) then
			_ui_animator:stop_animation(v)

			_animations[k] = nil
		end

		flag = true
	end

	return flag
end

RewardPopupUI.draw = function (self, arg_9_1)
	-- function 9
	local _ui_top_renderer = self._ui_top_renderer
	local _ui_scenegraph = self._ui_scenegraph
	local get_service = self._input_manager:get_service(str)
	local _render_settings = self._render_settings

	UIRenderer.begin_pass(_ui_top_renderer, _ui_scenegraph, get_service, arg_9_1, nil, _render_settings)
	UIRenderer.draw_widget(_ui_top_renderer, self.background_top_widget)
	UIRenderer.draw_widget(_ui_top_renderer, self.background_center_widget)
	UIRenderer.draw_widget(_ui_top_renderer, self.background_bottom_widget)
	UIRenderer.draw_widget(_ui_top_renderer, self.background_bottom_glow_widget)
	UIRenderer.draw_widget(_ui_top_renderer, self.background_top_glow_widget)
	UIRenderer.draw_widget(_ui_top_renderer, self.screen_background_widget)
	UIRenderer.draw_widget(_ui_top_renderer, self.deus_background_top_widget)
	UIRenderer.draw_widget(_ui_top_renderer, self.deus_background_bottom_widget)
	UIRenderer.draw_widget(_ui_top_renderer, self.deus_background_bottom_glow_widget)
	UIRenderer.draw_widget(_ui_top_renderer, self.deus_background_top_glow_widget)

	local _animation_presentation_data = self._animation_presentation_data

	if not (not _animation_presentation_data and _animation_presentation_data.complete) then
		local var_9_5 = _animation_presentation_data.entries[_animation_presentation_data.entry_play_index]

		if not var_9_5 then
			local widgets_data = var_9_5.widgets_data

			for i, v in ipairs(widgets_data) do
				_render_settings.alpha_multiplier = v.alpha_multiplier

				local widget = v.widget

				UIRenderer.draw_widget(_ui_top_renderer, widget)

				_render_settings.alpha_multiplier = nil
			end
		end

		if not IS_WINDOWS and not _animation_presentation_data.claim_button then
			local claim_button_widget = self.claim_button_widget

			UIWidgetUtils.animate_default_button(claim_button_widget, arg_9_1)

			_render_settings.alpha_multiplier = claim_button_widget.content.alpha_multiplier

			UIRenderer.draw_widget(_ui_top_renderer, claim_button_widget)
		end
	end

	UIRenderer.end_pass(_ui_top_renderer)

	if not self._handling_claim_button and not self._menu_input_description and not self._input_manager:is_device_active("gamepad") then
		self._menu_input_description:set_input_description(nil)
		self._menu_input_description:draw(_ui_top_renderer, arg_9_1)
	end
end

RewardPopupUI.display_presentation = function (self, arg_10_1, arg_10_2)
	-- function 10
	self._draw_widgets = true
	self._ui_animator = UIAnimator:new(self._ui_scenegraph, animations)
	self._animations = {}
	self._animation_presentation_data = self:_setup_presentation(arg_10_1)

	self:set_visible(true)

	self._presentation_complete = false
	self._speed_up_popup = false
	self._done_reset_speed_up_popup = false
	self._reward_complete_cb = arg_10_2

	if not arg_10_1.keep_input then
		self:_acquire_input()
	end
end

RewardPopupUI.is_presentation_active = function (self)
	-- function 11
	return self._animation_presentation_data ~= nil
end

RewardPopupUI.is_presentation_complete = function (self)
	-- function 12
	return self._presentation_complete
end

RewardPopupUI.on_presentation_complete = function (self)
	-- function 13
	self._presentation_complete = true
	self._draw_widgets = false

	self:set_visible(false)
	self:set_fullscreen_effect_enable_state(false)

	self._animation_presentation_data = nil

	if not self._reward_complete_cb then
		self._reward_complete_cb()

		self._reward_complete_cb = nil
	end
end

RewardPopupUI.start_presentation_animation = function (self, arg_14_1, arg_14_2)
	-- function 14
	local tbl = {
		wwise_world = self._wwise_world
	}

	arg_14_2 = arg_14_2 or {
		background_top = self.background_top_widget,
		background_center = self.background_center_widget,
		background_bottom = self.background_bottom_widget,
		background_bottom_glow = self.background_bottom_glow_widget,
		background_top_glow = self.background_top_glow_widget,
		claim_button = self.claim_button_widget,
		deus_background_top = self.deus_background_top_widget,
		deus_background_bottom = self.deus_background_bottom_widget,
		deus_background_bottom_glow = self.deus_background_bottom_glow_widget,
		deus_background_top_glow = self.deus_background_top_glow_widget
	}

	local start_animation = self._ui_animator:start_animation(arg_14_1, arg_14_2, scenegraph_definition, tbl)
	local str = arg_14_1 .. start_animation

	self._animations[str] = start_animation
	self._animation_params = tbl

	return str
end

local function fn_2(self, arg_15_1, arg_15_2)
	-- function 15
	local offset = self.offset

	offset[1] = arg_15_1
	offset[2] = arg_15_2
end

RewardPopupUI._hacky_get_tooltip_size = function (self, arg_16_1)
	-- function 16
	local _ui_top_renderer = self._ui_top_renderer
	local _render_settings = self._render_settings
	local alpha_multiplier = _render_settings.alpha_multiplier

	_render_settings.alpha_multiplier = 0

	UIRenderer.begin_pass(_ui_top_renderer, self._ui_scenegraph, FAKE_INPUT_SERVICE, 0, nil, _render_settings)
	UIRenderer.draw_widget(_ui_top_renderer, arg_16_1)
	UIRenderer.end_pass(_ui_top_renderer)

	_render_settings.alpha_multiplier = alpha_multiplier

	return arg_16_1.style.item.item_presentation_height
end

RewardPopupUI._setup_entry_widget = function (self, arg_17_1, arg_17_2)
	-- function 17
	local widget_definitions = var_0_0.widget_definitions
	local value = arg_17_1.value
	local widget_type

	if not arg_17_1.widget_type and not widget_definitions[arg_17_1.widget_type] then
		widget_type = arg_17_1.widget_type

		if not widget_type then
			-- Nothing
		end
	end

	widget_type = "item"

	::label_17_0::

	local ignore_height = arg_17_1.ignore_height
	local var_17_4 = UIWidget.init(widget_definitions[widget_type])
	local scenegraph_id = var_17_4.scenegraph_id
	local size = scenegraph_definition[scenegraph_id].size
	local size_2 = self._ui_scenegraph[scenegraph_id].size
	local num = 0

	if not (widget_type == "title" or widget_type ~= "level") then
		var_17_4.content.text = value

		local text = var_17_4.style.text

		size_2[2] = UIUtils.get_text_height(self._ui_top_renderer, size, text, value)
		num = size_2[2]
	elseif widget_type == "description" then
		var_17_4.content.title_text = value[1]
		var_17_4.content.text = value[2]

		local text_2 = var_17_4.style.text
		local title_text = var_17_4.style.title_text
		local _ui_top_renderer = self._ui_top_renderer

		size_2[2] = UIUtils.get_text_height(_ui_top_renderer, size, text_2, value[1]) + UIUtils.get_text_height(_ui_top_renderer, size, title_text, value[2])
		num = size_2[2]
	elseif not (widget_type == "texture" or widget_type ~= "icon") then
		var_17_4.content.texture_id = value

		local texture_id = var_17_4.style.texture_id
		local size_3 = UIAtlasHelper.get_atlas_settings_by_texture_name(value).size
		local texture_size = texture_id.texture_size

		texture_size[1] = size_3[1]
		texture_size[2] = size_3[2]
		texture_id.offset[3] = arg_17_2

		if not var_17_4.style.frame then
			var_17_4.style.frame.offset[3] = arg_17_2 + 1
		end

		num = texture_size[2] / 2
	elseif not (widget_type == "weapon_skin" or widget_type == "skin" or widget_type ~= "keep_decoration_painting") then
		local data = value.data
		local rarity = value.rarity

		rarity = rarity or data.rarity

		local content = var_17_4.content
		local icon = value.icon

		icon = icon or data.inventory_icon
		content.texture_id = icon
		var_17_4.content.rarity_texture = UISettings.item_rarity_textures[rarity]
		num = 0
	elseif widget_type == "career" then
		local var_17_20 = CareerSettings[value]
		local str = "small_" .. var_17_20.portrait_image

		var_17_4.content.texture_id = str
	elseif not (widget_type == "item" or widget_type ~= "frame") then
		local backend_id = value.backend_id
		local get_item_from_id = Managers.backend:get_interface("items"):get_item_from_id(backend_id)
		local rarity_2 = get_item_from_id.rarity

		if not rarity_2 then
			if not get_item_from_id.data then
				rarity_2 = get_item_from_id.data.rarity

				if not rarity_2 then
					-- Nothing
				end
			end

			rarity_2 = "plentiful"
		end

		::label_17_1::

		local get_ui_information_from_item = UIUtils.get_ui_information_from_item(get_item_from_id)

		var_17_4.content.texture_id = get_ui_information_from_item
		var_17_4.content.rarity_texture = UISettings.item_rarity_textures[rarity_2]
		num = 0
	elseif widget_type == "item_list" then
		local content_2 = var_17_4.content
		local style = var_17_4.style
		local count = #value
		local item_list_max_columns = var_0_0.item_list_max_columns
		local num_2 = math.ceil(count / item_list_max_columns) - 1

		content_2.cursor_x = 1
		content_2.cursor_y = 1
		content_2.rows = num_2 + 1
		content_2.cols = math.min(item_list_max_columns, count)
		content_2.item_count = count

		for i = 1, count do
			local str_2 = "rarity" .. i
			local str_3 = "icon" .. i
			local str_4 = "frame" .. i
			local str_5 = "illusion" .. i
			local str_6 = "tooltip" .. i
			local str_7 = "item" .. i
			local num_3 = 80 + item_list_padding
			local num_4 = num_3 * ((i - 1) % item_list_max_columns)
			local num_5 = num_3 * (num_2 - math.floor((i - 1) / item_list_max_columns))

			if i > num_2 * item_list_max_columns then
				num_4 = num_4 + num_3 * 0.5 * (-count % item_list_max_columns)
			end

			fn_2(style[str_2], num_4, num_5)
			fn_2(style[str_3], num_4, num_5)
			fn_2(style[str_4], num_4, num_5)
			fn_2(style[str_5], num_4, num_5)
			fn_2(style[str_6], num_4, num_5)

			if i == 1 then
				fn_2(style.cursor, num_4, num_5)
			end

			local var_17_40 = value[i]
			local data_2 = var_17_40.data
			local rarity_3 = var_17_40.rarity

			if not rarity_3 then
				if not data_2 then
					rarity_3 = data_2.rarity

					if not rarity_3 then
						-- Nothing
					end
				end

				rarity_3 = "plentiful"
			end

			::label_17_2::

			local get_ui_information_from_item_2 = UIUtils.get_ui_information_from_item(var_17_40)

			get_ui_information_from_item_2 = get_ui_information_from_item_2 or "icons_placeholder"
			content_2[str_3] = get_ui_information_from_item_2

			local var_17_44 = UISettings.item_rarity_textures[rarity_3]

			var_17_44 = var_17_44 or "icons_placeholder"
			content_2[str_2] = var_17_44
			content_2[str_7] = var_17_40
			content_2[str_5] = not data_2 and data_2.item_type == "weapon_skin"
		end

		for j = count + 1, var_0_0.item_list_max_rows * item_list_max_columns do
			content_2["item_" .. j] = nil
		end

		num = 210 + (80 + item_list_padding) * num_2
	elseif widget_type == "deus_item" then
		local backend_id_2 = value.backend_id
		local get_item_from_id_2 = Managers.backend:get_interface("items"):get_item_from_id(backend_id_2)
		local rarity_4 = get_item_from_id_2.rarity

		if not rarity_4 then
			if not get_item_from_id_2.data then
				rarity_4 = get_item_from_id_2.data.rarity

				if not rarity_4 then
					-- Nothing
				end
			end

			rarity_4 = "plentiful"
		end

		::label_17_3::

		local get_ui_information_from_item_3, var_17_49, var_17_50 = UIUtils.get_ui_information_from_item(get_item_from_id_2)

		var_17_4.content.texture_id = get_ui_information_from_item_3
		var_17_4.content.rarity_texture = UISettings.item_rarity_textures[rarity_4]
		num = 0
	elseif widget_type == "deus_icon" then
		local local_player = Managers.player:local_player()
		local profile_index = local_player:profile_index()
		local career_index = local_player:career_index()

		var_17_4.content.icon = DeusPowerUpUtils.get_power_up_icon(value, profile_index, career_index)
		num = 0
	elseif not (widget_type == "deus_item_tooltip" or widget_type ~= "item_tooltip") then
		local backend_id_3 = value.backend_id
		local get_item_from_id_3 = Managers.backend:get_interface("items"):get_item_from_id(backend_id_3)

		var_17_4.content.item = get_item_from_id_3
		var_17_4.style.item.draw_end_passes = true
		num = self:_hacky_get_tooltip_size(var_17_4) - 20
	elseif widget_type == "deus_power_up" then
		local var_17_56 = DeusPowerUps[value.rarity][value.name]
		local local_player_2 = Managers.player:local_player()
		local profile_index_2 = local_player_2:profile_index()
		local career_index_2 = local_player_2:career_index()
		local rarity_5 = var_17_56.rarity
		local var_17_61 = RaritySettings[rarity_5]
		local content_3 = var_17_4.content

		content_3.title_text = DeusPowerUpUtils.get_power_up_name_text(var_17_56.name, var_17_56.talent_index, var_17_56.talent_tier, profile_index_2, career_index_2)
		content_3.rarity_text = Localize(var_17_61.display_name)
		var_17_4.style.icon_frame.color = var_17_61.frame_color
		var_17_4.style.icon_glow.color = var_17_61.color
		content_3.description_text = DeusPowerUpUtils.get_power_up_description(var_17_56, profile_index_2, career_index_2)
		content_3.icon = DeusPowerUpUtils.get_power_up_icon(var_17_56, profile_index_2, career_index_2)

		local style_2 = var_17_4.style
		local get_table = Colors.get_table(rarity_5)

		style_2.rarity_text.text_color = get_table

		local var_17_65 = DeusPowerUpSetLookup[var_17_56.rarity]

		var_17_65 = not var_17_65 and DeusPowerUpSetLookup[var_17_56.rarity][var_17_56.name]

		local flag = false

		if not var_17_65 then
			local var_17_67 = var_17_65[1]
			local num_6 = 0
			local pieces = var_17_67.pieces
			local get_deus_run_controller = Managers.mechanism:game_mechanism():get_deus_run_controller()

			for i_2, v in ipairs(pieces) do
				local name = v.name
				local rarity_6 = v.rarity
				local get_own_peer_id = get_deus_run_controller:get_own_peer_id()

				if not get_deus_run_controller:has_power_up_by_name(get_own_peer_id, name, rarity_6) then
					num_6 = num_6 + 1
				end
			end

			flag = true

			local num_required_pieces = var_17_67.num_required_pieces

			num_required_pieces = num_required_pieces or #pieces
			var_17_4.content.set_progression = Localize("set_bonus_boons") .. " " .. string.format(Localize("set_counter_boons"), num_6, num_required_pieces)

			if #pieces == num_6 then
				style_2.set_progression.text_color = style_2.set_progression.progression_colors.complete
			end
		end

		var_17_4.content.is_part_of_set = flag
		num = 160
	elseif widget_type == "loot_chest" then
		local inventory_icon = ItemMasterList[value].inventory_icon

		var_17_4.content.texture_id = inventory_icon
		num = 0
	end

	local var_17_76 = var_17_4
	local flag_2

	flag_2 = not ignore_height and 0 and num

	return var_17_76, flag_2
end

RewardPopupUI._setup_presentation = function (self, arg_18_1)
	-- function 18
	local count = #arg_18_1
	local tbl = {}
	local tbl_2 = {
		end_animation = "close",
		start_animation = "open",
		started = false,
		animations_played = 0,
		entry_play_index = 1,
		amount = count,
		entries = tbl
	}
	local animation_data = arg_18_1.animation_data

	animation_data = animation_data or {}

	for k, v in pairs(animation_data) do
		tbl_2[k] = v
	end

	local animation_wait_time = animation_data.animation_wait_time

	animation_wait_time = animation_wait_time or not tbl_2.claim_button or 0 or 2

	local num = 20
	local num_2 = 80

	self._skip_blur = arg_18_1.skip_blur

	local bg_alpha = arg_18_1.bg_alpha

	bg_alpha = bg_alpha or 100
	self._bg_alpha = bg_alpha

	for k_2 = 1, #arg_18_1 do
		local var_18_8 = arg_18_1[k_2]
		local tbl_3 = {}
		local tbl_4 = {
			enter_animation = "entry_enter",
			exit_animation = "entry_exit",
			index = k_2,
			widgets_data = tbl_3,
			animation_wait_time = animation_wait_time
		}
		local num_3 = 0

		for l = 1, #var_18_8 do
			local var_18_12 = var_18_8[l]
			local _setup_entry_widget, var_18_14 = self:_setup_entry_widget(var_18_12, l)

			tbl_3[l] = {
				alpha_multiplier = 0,
				widget = _setup_entry_widget,
				height = var_18_14,
				value = var_18_12.value,
				widget_type = var_18_12.widget_type
			}

			if num_3 < var_18_14 then
				num_3 = var_18_14
			end
		end

		tbl_4.highest_height = num_3
		tbl[k_2] = tbl_4

		if num_2 < num_3 then
			num_2 = num_3
		end
	end

	scenegraph_definition.background_center.size[2] = num_2 + num

	local background = self._ui_scenegraph.background
	local offset = arg_18_1.offset

	offset = offset or {
		0,
		0,
		1
	}
	background.local_position = offset

	return tbl_2
end

RewardPopupUI._align_entry_widgets = function (self, arg_19_1)
	-- function 19
	local _ui_scenegraph = self._ui_scenegraph
	local widgets_data = arg_19_1.widgets_data

	for i = 1, #widgets_data do
		_ui_scenegraph[widgets_data[i].widget.scenegraph_id].local_position[2] = 0
	end
end

RewardPopupUI._play_animation = function (self, arg_20_1, arg_20_2, arg_20_3)
	-- function 20
	local str = arg_20_2 .. "_key"
	local var_20_1 = arg_20_1[str]

	if not var_20_1 then
		arg_20_1[str] = self:start_presentation_animation(arg_20_1[arg_20_2], arg_20_3)

		return true
	elseif not self._animations[var_20_1] then
		return true
	end
end

RewardPopupUI._update_presentation_animation = function (self, arg_21_1)
	-- function 21
	local _animation_presentation_data = self._animation_presentation_data

	if not _animation_presentation_data and not _animation_presentation_data.complete then
		return
	end

	if not self:_play_animation(_animation_presentation_data, "start_animation") then
		return
	end

	local entry_play_index = _animation_presentation_data.entry_play_index
	local entries = _animation_presentation_data.entries
	local var_21_3 = entries[entry_play_index]

	if not var_21_3.aligned then
		self:_align_entry_widgets(var_21_3)

		var_21_3.aligned = true
	end

	if not self:_play_animation(var_21_3, "enter_animation", var_21_3.widgets_data) then
		return
	end

	if not _animation_presentation_data.claim_button then
		self._handling_claim_button = true

		if not var_21_3.claimed then
			return self:_handle_input(var_21_3)
		end

		self._handling_claim_button = false
	end

	if not self._done_reset_speed_up_popup then
		self._done_reset_speed_up_popup = true
		self._speed_up_popup = false
	end

	local animation_wait_time = var_21_3.animation_wait_time

	if not animation_wait_time then
		local num = animation_wait_time - arg_21_1

		if num > 0 then
			var_21_3.animation_wait_time = num
		else
			var_21_3.animation_wait_time = nil
		end

		return
	end

	if not self:_play_animation(var_21_3, "exit_animation", var_21_3.widgets_data) then
		return
	elseif entry_play_index < #entries then
		_animation_presentation_data.entry_play_index = entry_play_index + 1

		return
	end

	if not self:_play_animation(_animation_presentation_data, "end_animation") then
		return
	end

	_animation_presentation_data.complete = true

	self:on_presentation_complete()
end

RewardPopupUI._handle_input = function (self, arg_22_1)
	-- function 22
	local input_service = self:input_service()
	local claimed = arg_22_1.claimed

	if not claimed then
		claimed = input_service:get("skip_pressed", true)

		if not claimed then
			claimed = input_service:get("confirm_press", true)
			claimed = claimed or UIUtils.is_button_pressed(self.claim_button_widget)
		end
	end

	arg_22_1.claimed = claimed

	local find_by_key = table.find_by_key(arg_22_1.widgets_data, "widget_type", "item_list")

	if not find_by_key then
		return
	end

	local widget = arg_22_1.widgets_data[find_by_key].widget
	local content = widget.content
	local flag = false
	local cursor_x = content.cursor_x
	local cursor_y = content.cursor_y
	local item_list_max_columns = var_0_0.item_list_max_columns
	local rows = content.rows
	local num = content.item_count % item_list_max_columns

	if num == 0 then
		num = item_list_max_columns
	end

	if not (cursor_y < rows) or not input_service:get("move_down") then
		cursor_y = cursor_y + 1
		flag = true

		if cursor_y == rows then
			cursor_x = math.clamp(cursor_x - math.floor(0.5 * (item_list_max_columns - num)), 1, num)
		end
	elseif not (cursor_y > 1) or not input_service:get("move_up") then
		if cursor_y == rows then
			cursor_x = cursor_x + math.floor(0.5 * (item_list_max_columns - num))
		end

		cursor_y = cursor_y - 1
		flag = true
	end

	if not (cursor_x > 1) or not input_service:get("move_left") then
		cursor_x = cursor_x - 1
		flag = true
	elseif not (cursor_x < (cursor_y ~= rows or not num or item_list_max_columns)) or not input_service:get("move_right") then
		cursor_x = cursor_x + 1
		flag = true
	end

	if not flag then
		content.cursor_x = cursor_x
		content.cursor_y = cursor_y

		local num_2 = 1 + (cursor_x - 1) + (cursor_y - 1) * item_list_max_columns

		content.selected_i = num_2

		local offset = widget.style["icon" .. num_2].offset

		fn_2(widget.style.cursor, offset[1], offset[2])
	elseif not input_service:get("right_stick_press") then
		if not content.selected_i then
			content.selected_i = nil
		else
			content.selected_i = 1 + (cursor_x - 1) + (cursor_y - 1) * item_list_max_columns
		end
	end

	return true
end

RewardPopupUI.set_fullscreen_effect_enable_state = function (self, arg_23_1, arg_23_2)
	-- function 23
	if not self._skip_blur then
		return
	end

	local world = self.world
	local get_data = World.get_data(world, "shading_environment")

	arg_23_2 = arg_23_2 or not arg_23_1 or 1 or 0

	if not get_data then
		local set_scalar = ShadingEnvironment.set_scalar
		local var_23_3 = get_data
		local str = "fullscreen_blur_enabled"
		local flag

		flag = not arg_23_1 and 1 and 0

		set_scalar(var_23_3, str, flag)

		local set_scalar_2 = ShadingEnvironment.set_scalar
		local var_23_7 = get_data
		local str_2 = "fullscreen_blur_amount"
		local num

		if not arg_23_1 then
			num = arg_23_2 * 0.75

			if not num then
				-- Nothing
			end
		end

		num = 0

		::label_23_0::

		set_scalar_2(var_23_7, str_2, num)
		ShadingEnvironment.apply(get_data)

		self.screen_background_widget.style.rect.color[1] = self._bg_alpha * arg_23_2
	end

	self._fullscreen_effect_enabled = arg_23_1
end

RewardPopupUI._setup_input = function (self)
	-- function 24
	local _input_manager = self._input_manager

	if not (not _input_manager and self._input_set_up) then
		_input_manager:create_input_service(str, "IngameMenuKeymaps", "IngameMenuFilters")
		_input_manager:map_device_to_service(str, "keyboard")
		_input_manager:map_device_to_service(str, "mouse")
		_input_manager:map_device_to_service(str, "gamepad")

		self._input_set_up = true
	end
end

RewardPopupUI._acquire_input = function (self)
	-- function 25
	if not self.input_acquired then
		local _input_manager = self._input_manager

		if not _input_manager and not self._input_set_up then
			_input_manager:capture_input(ALL_INPUT_METHODS, 1, str, "RewardPopupUI")

			if not self._animation_presentation_data.claim_button then
				ShowCursorStack.show("RewardPopupUI")

				self._cursor_shown = true

				local get_service = _input_manager:get_service(str)

				self._menu_input_description = MenuInputDescriptionUI:new(nil, self._ui_top_renderer, get_service, 5, 900, var_0_0.generic_input_actions.default)

				self._menu_input_description:set_input_description(nil)
			end
		end

		self.input_acquired = true
	end
end

RewardPopupUI._release_input = function (self)
	-- function 26
	if not self.input_acquired then
		local _input_manager = self._input_manager

		if not _input_manager and not self._input_set_up then
			_input_manager:release_input(ALL_INPUT_METHODS, 1, str, "RewardPopupUI")

			self._menu_input_description = nil
		end

		self.input_acquired = false
	end

	if not self._cursor_shown then
		ShowCursorStack.hide("RewardPopupUI")

		self._cursor_shown = false
	end
end

RewardPopupUI.input_service = function (self)
	-- function 27
	if not self._input_set_up and not self.input_acquired then
		return self._input_manager:get_service(str)
	else
		return FAKE_INPUT_SERVICE
	end
end
