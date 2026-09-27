-- chunkname: @scripts/ui/views/deus_menu/deus_cursed_chest_view.lua

require("scripts/utils/hash_utils")

local var_0_0 = local_require("scripts/ui/views/deus_menu/deus_cursed_chest_view_definitions")
local num = 1
local num_2 = 40
local num_3 = 0
local num_4 = 1
local num_5 = 12
local num_6 = 2.5
local tbl = {
	close_ui = "hud_morris_weapon_chest_close",
	button_hover = "hud_morris_hover",
	power_up_unlocked = "hud_morris_cursed_chest_activate_powerup",
	open_ui = "hud_morris_cursed_chest_open"
}

DeusCursedChestView = class(DeusCursedChestView)

DeusCursedChestView.init = function (self, arg_1_1)
	-- function 1
	self.ui_renderer = arg_1_1.ui_renderer
	self.ingame_ui = arg_1_1.ingame_ui
	self.input_manager = arg_1_1.input_manager
	self.render_settings = {
		alpha_multiplier = 1,
		snap_pixel_positions = true
	}
	self._wwise_world = arg_1_1.wwise_world

	local str = "deus_cursed_chest_view"
	local input_manager = arg_1_1.input_manager

	self._input_manager = input_manager
	self._input_service_name = str
	self.ingame_ui = arg_1_1.ingame_ui

	input_manager:create_input_service(str, "IngameMenuKeymaps", "IngameMenuFilters")
	input_manager:map_device_to_service(str, "keyboard")
	input_manager:map_device_to_service(str, "mouse")
	input_manager:map_device_to_service(str, "gamepad")
end

DeusCursedChestView.destroy = function (arg_2_0)
	-- function 2
	return
end

DeusCursedChestView.on_enter = function (self, arg_3_1)
	-- function 3
	self._interactable = not arg_3_1 and arg_3_1.interactable_unit
	self._deus_run_controller = Managers.mechanism:game_mechanism():get_deus_run_controller()
	self._circle_speed_modifier = num_4
	self._circle_max_speed_modifier = num_4
	self._power_up_data = Unit.get_data(self._interactable, "power_ups")

	if not self._power_up_data then
		local world_position = Unit.world_position(self._interactable, 0)
		local fnv32_hash = HashUtils.fnv32_hash(world_position.x .. "_" .. world_position.y .. "_" .. world_position.z)
		local generate_random_power_ups = self._deus_run_controller:generate_random_power_ups(DeusPowerUpSettings.cursed_chest_choice_amount, DeusPowerUpAvailabilityTypes.cursed_chest, fnv32_hash)

		self._power_up_data = {}

		for i, v in ipairs(generate_random_power_ups) do
			self._power_up_data[i] = {
				selected = false,
				power_up = v
			}
		end

		Unit.set_data(self._interactable, "power_ups", self._power_up_data)
	end

	self:_acquire_input()
	self:create_ui_elements()
	self:_play_sound(tbl.open_ui)
end

DeusCursedChestView.create_ui_elements = function (self)
	-- function 4
	self.ui_scenegraph = UISceneGraph.init_scenegraph(var_0_0.scenegraph_definition)

	local tbl = {}
	local tbl_2 = {}

	for k, v in pairs(var_0_0.background_widgets) do
		if not v then
			local var_4_2 = UIWidget.init(v)

			tbl[#tbl + 1] = var_4_2
			tbl_2[k] = var_4_2
		end
	end

	local get_own_peer_id = self._deus_run_controller:get_own_peer_id()
	local get_player_profile, var_4_5 = self._deus_run_controller:get_player_profile(get_own_peer_id, num)
	local DeusPowerUpTemplates = DeusPowerUpTemplates
	local tbl_3 = {}
	local count = #self._power_up_data

	for k_2 = 1, count do
		local power_up = self._power_up_data[k_2].power_up
		local rectangular_icon = DeusPowerUpTemplates[power_up.name].rectangular_icon
		local size = var_0_0.scenegraph_definition.power_up_root.size
		local create_power_up_shop_item = var_0_0.create_power_up_shop_item("power_up_root", size, false, rectangular_icon)
		local var_4_13 = UIWidget.init(create_power_up_shop_item)
		local num_4 = k_2 - 1
		local num_5 = count - 1
		local rad = math.rad(num_4 / num_5 * 180)
		local num_6 = ((size[2] + num_3) * count + size[2]) / 2

		var_4_13.offset = {
			num_2 * math.sin(rad),
			num_6 - (num_3 + size[2]) * k_2,
			0
		}

		local var_4_18
		local num_7 = 0

		self:_init_power_up_widget(var_4_13, power_up, nil, num_7, var_4_18, get_player_profile, var_4_5)

		self._power_up_data[k_2].widget = var_4_13
		tbl[#tbl + 1] = var_4_13
		tbl_3[#tbl_3 + 1] = var_4_13
		tbl_2["power_up_item_" .. k_2] = var_4_13
	end

	self._widgets = tbl
	self._power_up_widgets = tbl_3
	self._widgets_by_name = tbl_2

	UIRenderer.clear_scenegraph_queue(self.ui_renderer)
end

DeusCursedChestView.post_update_on_enter = function (arg_5_0)
	-- function 5
	return
end

DeusCursedChestView.on_exit = function (self)
	-- function 6
	self._power_up_data = nil
	self._interactable = nil

	self:_release_input()
end

DeusCursedChestView.post_update_on_exit = function (arg_7_0)
	-- function 7
	return
end

DeusCursedChestView._init_power_up_widget = function (self, arg_8_1, arg_8_2, arg_8_3, arg_8_4, arg_8_5, arg_8_6, arg_8_7)
	-- function 8
	local var_8_0 = DeusPowerUps[arg_8_2.rarity][arg_8_2.name]
	local rarity = var_8_0.rarity
	local content = arg_8_1.content

	content.title_text = DeusPowerUpUtils.get_power_up_name_text(var_8_0.name, var_8_0.talent_index, var_8_0.talent_tier, arg_8_6, arg_8_7)
	content.rarity_text = Localize(RaritySettings[rarity].display_name)
	content.sub_text = DeusPowerUpUtils.get_power_up_description(var_8_0, arg_8_6, arg_8_7)
	content.has_discount = arg_8_3
	content.icon = DeusPowerUpUtils.get_power_up_icon(var_8_0, arg_8_6, arg_8_7)
	content.max_value_text = nil
	content.current_value_text = nil

	local style = arg_8_1.style
	local var_8_4 = DeusPowerUpSetLookup[arg_8_2.rarity]

	var_8_4 = not var_8_4 and DeusPowerUpSetLookup[arg_8_2.rarity][arg_8_2.name]

	local flag = false

	if not var_8_4 then
		local var_8_6 = var_8_4[1]
		local num = 0
		local pieces = var_8_6.pieces

		for i, v in ipairs(pieces) do
			local name = v.name
			local rarity_2 = v.rarity
			local get_own_peer_id = self._deus_run_controller:get_own_peer_id()

			if not self._deus_run_controller:has_power_up_by_name(get_own_peer_id, name, rarity_2) then
				num = num + 1
			end
		end

		flag = true

		local num_required_pieces = var_8_6.num_required_pieces

		num_required_pieces = num_required_pieces or #pieces
		content.set_progression = string.format(Localize("set_counter_boons"), num, num_required_pieces)

		if #pieces == num then
			style.set_progression.text_color = arg_8_1.style.set_progression.progression_colors.complete
		end
	end

	content.is_part_of_set = flag

	local get_table = Colors.get_table(rarity)

	style.rarity_text.text_color = get_table
	style.price_icon.color[1] = 0
	style.price_text.text_color[1] = 0
	style.price_text_shadow.text_color[1] = 0
	style.price_text_disabled.text_color[1] = 0

	local num_2 = 22

	style.current_value_title_text.offset[2] = style.current_value_title_text.offset[2] + num_2
	style.current_value_title_text_shadow.offset[2] = style.current_value_title_text_shadow.offset[2] + num_2
	style.current_value_text.offset[2] = style.current_value_text.offset[2] + num_2
	style.current_value_text_shadow.offset[2] = style.current_value_text_shadow.offset[2] + num_2
	style.max_value_title_text.offset[2] = style.max_value_title_text.offset[2] + num_2
	style.max_value_title_text_shadow.offset[2] = style.max_value_title_text_shadow.offset[2] + num_2
	style.max_value_text.offset[2] = style.max_value_text.offset[2] + num_2
	style.max_value_text_shadow.offset[2] = style.max_value_text_shadow.offset[2] + num_2
end

DeusCursedChestView.draw = function (self, arg_9_1)
	-- function 9
	for i, v in ipairs(self._power_up_widgets) do
		self:_animate_power_up_widget(arg_9_1, v)
	end

	local _widgets_by_name = self._widgets_by_name

	UIWidgetUtils.animate_default_button(_widgets_by_name.exit_button, arg_9_1)

	local ui_renderer = self.ui_renderer
	local ui_scenegraph = self.ui_scenegraph
	local input_service = self:input_service()
	local render_settings = self.render_settings

	UIRenderer.begin_pass(ui_renderer, ui_scenegraph, input_service, arg_9_1, nil, render_settings)

	local snap_pixel_positions = render_settings.snap_pixel_positions
	local _widgets = self._widgets

	for k = 1, #_widgets do
		local var_9_7 = _widgets[k]

		if var_9_7.snap_pixel_positions ~= nil then
			render_settings.snap_pixel_positions = var_9_7.snap_pixel_positions
		end

		UIRenderer.draw_widget(ui_renderer, var_9_7)

		render_settings.snap_pixel_positions = snap_pixel_positions
	end

	UIRenderer.end_pass(ui_renderer)
end

DeusCursedChestView._get_selected_power_up_count = function (self)
	-- function 10
	local num = 0

	for i, v in ipairs(self._power_up_data) do
		if not v.selected then
			num = num + 1
		end
	end

	return num
end

DeusCursedChestView.update = function (self, arg_11_1, arg_11_2)
	-- function 11
	local get_own_peer_id = self._deus_run_controller:get_own_peer_id()
	local cursed_chest_max_picks = DeusPowerUpSettings.cursed_chest_max_picks
	local _get_selected_power_up_count = self:_get_selected_power_up_count()
	local flag = cursed_chest_max_picks <= _get_selected_power_up_count

	for i, v in ipairs(self._power_up_data) do
		local widget = v.widget
		local power_up = v.power_up
		local reached_max_power_ups = self._deus_run_controller:reached_max_power_ups(get_own_peer_id, power_up.name)
		local content = widget.content

		if not v.selected then
			content.is_bought = true
			content.button_hotspot.disable_button = true
			_get_selected_power_up_count = _get_selected_power_up_count + 1
		elseif flag or not reached_max_power_ups then
			content.button_hotspot.disable_button = true
		else
			content.is_bought = false
			content.button_hotspot.disable_button = false
		end
	end

	self:_handle_input(arg_11_1)
	self:_update_background_animations(arg_11_1)
	self:draw(arg_11_1)
end

DeusCursedChestView._on_button_pressed = function (self, arg_12_1)
	-- function 12
	local power_up = arg_12_1.power_up

	arg_12_1.selected = true

	Unit.set_data(self._interactable, "power_ups", self._power_up_data)
	self._deus_run_controller:add_power_ups({
		power_up
	}, num, true)

	self._circle_max_speed_modifier = num_5

	self:_play_sound(tbl.power_up_unlocked)

	local has_extension = ScriptUnit.has_extension(self._interactable, "deus_cursed_chest_system")

	if not has_extension then
		has_extension:on_reward_collected(power_up)
	end

	self:_close()
end

DeusCursedChestView._handle_input = function (self, arg_13_1)
	-- function 13
	for i, v in ipairs(self._power_up_data) do
		local widget = v.widget

		if not self:_is_button_pressed(widget) then
			Managers.state.entity:system("animation_system"):add_safe_animation_callback(function ()
				-- function 14
				self:_on_button_pressed(v)
			end)
		end

		self:_update_button_hover_sound(widget)
	end

	local _widgets_by_name = self._widgets_by_name
	local get_service = self._input_manager:get_service(self._input_service_name)
	local exit_button = _widgets_by_name.exit_button

	if self:_is_button_pressed(exit_button) or get_service:get("toggle_menu", true) or not get_service:get("back", true) then
		self:_close()
	end

	self:_update_button_hover_sound(exit_button)
end

DeusCursedChestView.disable_toggle_menu = function (arg_15_0)
	-- function 15
	return true
end

DeusCursedChestView.input_service = function (self)
	-- function 16
	return self._input_manager:get_service(self._input_service_name)
end

DeusCursedChestView._close = function (self)
	-- function 17
	self:_play_sound(tbl.close_ui)
	self.ingame_ui:handle_transition("exit_menu")
end

DeusCursedChestView._acquire_input = function (self, arg_18_1)
	-- function 18
	self:_release_input(true)

	local _input_manager = self._input_manager
	local _input_service_name = self._input_service_name

	_input_manager:capture_input({
		"keyboard",
		"gamepad",
		"mouse"
	}, 1, _input_service_name, "DeusCursedChestView")
	_input_manager:block_device_except_service(_input_service_name, "keyboard")
	_input_manager:block_device_except_service(_input_service_name, "mouse")
	_input_manager:block_device_except_service(_input_service_name, "gamepad")

	if not arg_18_1 then
		ShowCursorStack.show("DeusCursedChestView")
		_input_manager:enable_gamepad_cursor()
	end
end

DeusCursedChestView._release_input = function (self, arg_19_1)
	-- function 19
	local _input_manager = self._input_manager

	_input_manager:release_input({
		"keyboard",
		"gamepad",
		"mouse"
	}, 1, self._input_service_name, "DeusCursedChestView")

	if not arg_19_1 then
		ShowCursorStack.hide("DeusCursedChestView")
		_input_manager:disable_gamepad_cursor()
	end
end

DeusCursedChestView._is_button_pressed = function (arg_20_0, arg_20_1)
	-- function 20
	local button_hotspot = arg_20_1.content.button_hotspot

	if not button_hotspot.on_release then
		button_hotspot.on_release = false

		return true
	end
end

DeusCursedChestView._is_button_hovered = function (arg_21_0, arg_21_1)
	-- function 21
	if not arg_21_1.content.button_hotspot.on_hover_enter then
		return true
	end
end

DeusCursedChestView._update_button_hover_sound = function (self, arg_22_1)
	-- function 22
	if not self:_is_button_hovered(arg_22_1) then
		self:_play_sound(tbl.button_hover)
	end
end

DeusCursedChestView._animate_power_up_widget = function (arg_23_0, arg_23_1, arg_23_2)
	-- function 23
	local content = arg_23_2.content
	local style = arg_23_2.style
	local hotspot = content.hotspot

	hotspot = hotspot or content.button_hotspot

	local is_hover = hotspot.is_hover
	local is_bought = content.is_bought
	local is_selected = hotspot.is_selected
	local hover_progress = hotspot.hover_progress

	hover_progress = hover_progress or 0

	local highlight_progress = hotspot.highlight_progress

	highlight_progress = highlight_progress or 0

	local selection_progress = hotspot.selection_progress

	selection_progress = selection_progress or 0

	local num = 15

	if not is_bought then
		is_hover = false
	end

	if not is_hover then
		hover_progress = math.min(hover_progress + arg_23_1 * num, 1)
	else
		hover_progress = math.max(hover_progress - arg_23_1 * num, 0)
	end

	if not is_bought then
		highlight_progress = math.min(highlight_progress + arg_23_1 * num, 1)
	else
		highlight_progress = math.max(highlight_progress - arg_23_1 * num, 0)
	end

	if not is_selected then
		selection_progress = math.min(selection_progress + arg_23_1 * num, 1)
	else
		selection_progress = math.max(selection_progress - arg_23_1 * num, 0)
	end

	if not content.bought_glow_style_ids then
		for i, v in ipairs(content.bought_glow_style_ids) do
			style[v].color[1] = 255 * highlight_progress
		end
	end

	style.hover.color[1] = 255 * hover_progress
	style.icon_hover_frame.color[1] = 255 * hover_progress

	local value_progress = hotspot.value_progress

	value_progress = value_progress or 0

	local max = math.max(value_progress - arg_23_1 * num, 0)

	if not style.icon_equipped_frame then
		style.icon_equipped_frame.color[1] = 255 * max
	end

	hotspot.value_progress = max
	hotspot.hover_progress = hover_progress
	hotspot.highlight_progress = highlight_progress
	hotspot.selection_progress = selection_progress
end

DeusCursedChestView._play_sound = function (self, arg_24_1)
	-- function 24
	WwiseWorld.trigger_event(self._wwise_world, arg_24_1)
end

DeusCursedChestView._update_background_animations = function (self, arg_25_1)
	-- function 25
	local _widgets_by_name = self._widgets_by_name
	local _circle_speed_modifier = self._circle_speed_modifier
	local _circle_max_speed_modifier = self._circle_max_speed_modifier

	if not math.value_inside_range(_circle_speed_modifier, _circle_max_speed_modifier - 0.2, _circle_max_speed_modifier + 0.2) then
		self._circle_max_speed_modifier = num_4
	end

	local lerp = math.lerp(_circle_speed_modifier, _circle_max_speed_modifier, num_6 * arg_25_1)

	for i = 1, 3 do
		local var_25_4 = _widgets_by_name["background_wheel_0" .. i]
		local angle = var_25_4.style.texture_id.angle
		local num = 0
		local var_25_7
		local flag

		flag = (i ~= 1 or not 0.2 or i ~= 2) and (not -0.1 or 0.05)

		local num_2 = angle + arg_25_1 * flag * lerp

		var_25_4.style.texture_id.angle = num_2
	end

	self._circle_speed_modifier = lerp
end
