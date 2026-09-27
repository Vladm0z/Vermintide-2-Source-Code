-- chunkname: @scripts/ui/hud_ui/gamepad_ability_ui.lua

local var_0_0 = local_require("scripts/ui/hud_ui/gamepad_ability_ui_definitions")
local scenegraph_definition = var_0_0.scenegraph_definition
local create_ability_charges_widget = var_0_0.create_ability_charges_widget

GamePadAbilityUI = class(GamePadAbilityUI)

GamePadAbilityUI.init = function (self, arg_1_1, arg_1_2)
	-- function 1
	self._parent = arg_1_1
	self._ui_renderer = arg_1_2.ui_renderer
	self.ingame_ui = arg_1_2.ingame_ui
	self._input_manager = arg_1_2.input_manager
	self._player = arg_1_2.player
	self._render_settings = {
		snap_pixel_positions = true
	}

	self:_create_ui_elements()

	self._ability_charge_widgets = {}

	Managers.state.event:register(self, "input_changed", "event_input_changed")
end

GamePadAbilityUI._create_ui_elements = function (self)
	-- function 2
	self._ui_scenegraph = UISceneGraph.init_scenegraph(scenegraph_definition)
	self._widgets, self._widgets_by_name = UIUtils.create_widgets(var_0_0.widget_definitions)

	UIRenderer.clear_scenegraph_queue(self._ui_renderer)
	self:event_input_changed()
end

GamePadAbilityUI._setup_activated_ability = function (self)
	-- function 3
	local player_unit = self._player.player_unit

	if not player_unit then
		return
	end

	local extension = ScriptUnit.extension(player_unit, "career_system")
	local get_activated_ability_data = extension:get_activated_ability_data()
	local career_index = extension:career_index()

	if not (not get_activated_ability_data and career_index) then
		return
	end

	self._career_index = career_index
	self._initialized = true
end

GamePadAbilityUI._sync_ability_cooldown = function (self)
	-- function 4
	local player_unit = self._player.player_unit

	if not player_unit then
		return
	end

	local extension = ScriptUnit.extension(player_unit, "career_system")
	local current_ability_cooldown, var_4_3 = extension:current_ability_cooldown()
	local career_index = extension:career_index()

	if self._career_index ~= career_index then
		self._initialized = false

		return
	end

	self._ability_usable = extension:can_use_activated_ability()

	if not current_ability_cooldown then
		local num = current_ability_cooldown / var_4_3

		if not (num ~= self._current_cooldown_fraction) then
			self:_set_ability_cooldown_state(num, not self._current_cooldown_fraction)
		end
	end
end

GamePadAbilityUI._update_thornsister_passive = function (self)
	-- function 5
	local player_unit = self._player.player_unit

	if not player_unit then
		return
	end

	local extension = ScriptUnit.extension(player_unit, "career_system")
	local _widgets_by_name = self._widgets_by_name
	local thornsister_passive = _widgets_by_name.thornsister_passive
	local content = thornsister_passive.content
	local get_extra_ability_uses, var_5_6 = extension:get_extra_ability_uses()
	local flag = get_extra_ability_uses > 0

	if content.is_active ~= flag then
		content.is_active = flag

		self:_set_widget_dirty(thornsister_passive)

		local ability = _widgets_by_name.ability

		ability.content.hide_effect = flag

		self:_set_widget_dirty(ability)

		return true
	end
end

GamePadAbilityUI._set_ability_activated = function (self, arg_6_1)
	-- function 6
	local ability = self._widgets_by_name.ability
	local content = ability.content
	local style = ability.style

	ability.content.activated = arg_6_1
	self._ability_activated = arg_6_1
end

GamePadAbilityUI._set_ability_cooldown_state = function (self, arg_7_1, arg_7_2)
	-- function 7
	self._current_cooldown_fraction = arg_7_1

	local flag = arg_7_1 ~= 0
	local _ability_usable = self._ability_usable
	local ability = self._widgets_by_name.ability

	if not (not ability.content.on_cooldown and flag or _ability_usable) then
		local style = ability.style

		style.input_text.text_color[1] = 0
		style.input_text_shadow.text_color[1] = 0
	end

	ability.content.on_cooldown = flag
	ability.content.usable = _ability_usable

	self:_set_widget_dirty(ability)
	self:set_dirty()
end

GamePadAbilityUI.destroy = function (self)
	-- function 8
	Managers.state.event:unregister("input_changed", self)
	self:set_visible(false)
	print("[GamePadAbilityUI] - Destroy")
end

GamePadAbilityUI.set_visible = function (self, arg_9_1)
	-- function 9
	self._is_visible = arg_9_1

	self:_set_elements_visible(arg_9_1)
end

GamePadAbilityUI._set_elements_visible = function (self, arg_10_1)
	-- function 10
	local _ui_renderer = self._ui_renderer

	for i, v in ipairs(self._widgets) do
		UIRenderer.set_element_visible(_ui_renderer, v.element, arg_10_1)
	end

	self._retained_elements_visible = arg_10_1

	self:set_dirty()
end

GamePadAbilityUI._handle_gamepad_activity = function (self)
	-- function 11
	local is_device_active = Managers.input:is_device_active("gamepad")
	local get_most_recent_device = Managers.input:get_most_recent_device()
	local flag = self.gamepad_active_last_frame == nil or not is_device_active or get_most_recent_device ~= self._most_recent_device

	if not is_device_active then
		if not self.gamepad_active_last_frame and not flag then
			self.gamepad_active_last_frame = true

			self:event_input_changed()
		end
	elseif self.gamepad_active_last_frame or not flag then
		self.gamepad_active_last_frame = false

		self:event_input_changed()
	end

	self._most_recent_device = get_most_recent_device
end

GamePadAbilityUI._handle_gamepad = function (self)
	-- function 12
	local _handle_active_ability = self:_handle_active_ability()
	local is_device_active = Managers.input:is_device_active("gamepad")

	is_device_active = is_device_active or IS_XB1

	if not is_device_active and UISettings.use_gamepad_hud_layout ~= "never" and UISettings.use_gamepad_hud_layout == "always" and not _handle_active_ability then
		if not self._retained_elements_visible then
			self:_set_elements_visible(false)
		end

		return false
	else
		if not self._retained_elements_visible then
			self:_set_elements_visible(true)
			self:event_input_changed()
		end

		return true
	end
end

GamePadAbilityUI.update = function (self, arg_13_1, arg_13_2)
	-- function 13
	if not self:_handle_gamepad() then
		return
	end

	self:_handle_gamepad_activity()

	if not self._initialized then
		self:_setup_activated_ability()
	else
		local flag = false

		if not self:_update_thornsister_passive() then
			flag = true
		end

		if self._current_cooldown_fraction == 0 or not self._ability_usable then
			flag = self:_update_ability_animations(arg_13_1, arg_13_2)
		end

		if not self:_update_ability_charges_widgets(arg_13_1, arg_13_2) then
			flag = true
		end

		if not flag then
			self:set_dirty()
		end

		self:_sync_ability_cooldown()
		self:_handle_resolution_modified()
		self:_update_muneric_ui_ability_cooldown()
		self:draw(arg_13_1)
	end
end

GamePadAbilityUI._handle_active_ability = function (arg_14_0)
	-- function 14
	local local_player = Managers.player:local_player()

	if not local_player then
		return false
	end

	local player_unit = local_player.player_unit

	if not Unit.alive(player_unit) then
		return false
	end

	local extension = ScriptUnit.extension(player_unit, "inventory_system")

	return not extension and extension:get_wielded_slot_name() == "slot_career_skill_weapon"
end

GamePadAbilityUI._handle_resolution_modified = function (self)
	-- function 15
	if not RESOLUTION_LOOKUP.modified then
		UIUtils.mark_dirty(self._widgets)

		if not table.is_empty(self._ability_charge_widgets) then
			UIUtils.mark_dirty(self._ability_charge_widgets)
		end

		self:set_dirty()
	end
end

GamePadAbilityUI.draw = function (self, arg_16_1)
	-- function 16
	if not self._is_visible then
		return
	end

	if not self._dirty then
		return
	end

	local _ui_renderer = self._ui_renderer
	local _ui_scenegraph = self._ui_scenegraph
	local _render_settings = self._render_settings

	UIRenderer.begin_pass(_ui_renderer, _ui_scenegraph, FAKE_INPUT_SERVICE, arg_16_1, nil, self._render_settings)

	for i, v in ipairs(self._widgets) do
		UIRenderer.draw_widget(_ui_renderer, v)
	end

	if not (not self._ability_charge_widgets and table.is_empty(self._ability_charge_widgets) or not (self._ability_cooldowns > 1)) then
		UIRenderer.draw_all_widgets(_ui_renderer, self._ability_charge_widgets)
	end

	UIRenderer.end_pass(_ui_renderer)

	self._dirty = false
end

GamePadAbilityUI.set_dirty = function (self)
	-- function 17
	self._dirty = true
end

GamePadAbilityUI._set_widget_dirty = function (arg_18_0, arg_18_1)
	-- function 18
	arg_18_1.element.dirty = true
end

GamePadAbilityUI.event_input_changed = function (self)
	-- function 19
	local count = #InventorySettings.slots
	local flag

	flag = not self._input_manager:is_device_active("gamepad") and "ability" and "action_career"

	local ability = self._widgets_by_name.ability

	self:_set_input(ability, flag)
	self:_set_widget_dirty(ability)
	self:set_dirty()
end

GamePadAbilityUI._set_input = function (self, arg_20_1, arg_20_2)
	-- function 20
	local _get_input_texture_data, var_20_1, var_20_2 = self:_get_input_texture_data(arg_20_2)

	if not (not var_20_1 and Utf8.length(var_20_1)) then
		local num = 0
	end

	local num_2 = 40
	local style = arg_20_1.style
	local content = arg_20_1.content
	local input_text = style.input_text
	local _ui_renderer = self._ui_renderer

	content.input_action = arg_20_2

	local is_device_active = Managers.input:is_device_active("gamepad")

	if not _get_input_texture_data and not is_device_active then
		content.activate_ability_id = _get_input_texture_data.texture
		content.input_text = ""

		local texture_size = style.activate_ability.texture_size
		local size = _get_input_texture_data.size

		texture_size[1] = size[1]
		texture_size[2] = size[2]
	elseif not var_20_1 then
		content.input_text = UIRenderer.crop_text_width(_ui_renderer, var_20_1, num_2, input_text)
		content.activate_ability_id = nil
	end
end

GamePadAbilityUI._get_input_texture_data = function (self, arg_21_1)
	-- function 21
	local _input_manager = self._input_manager
	local get_service = _input_manager:get_service("Player")
	local is_device_active = _input_manager:is_device_active("gamepad")
	local PLATFORM = PLATFORM

	if not (not IS_XB1 and not GameSettingsDevelopment.allow_keyboard_mouse and is_device_active) then
		PLATFORM = "win32"
	elseif not IS_WINDOWS and not is_device_active then
		PLATFORM = "xb1"
	end

	local get_keymapping = get_service:get_keymapping(arg_21_1, PLATFORM)
	local var_21_5 = get_keymapping[1]
	local var_21_6 = get_keymapping[2]
	local var_21_7 = get_keymapping[3]
	local var_21_8

	if var_21_7 == "held" then
		var_21_8 = "matchmaking_prefix_hold"
	end

	if var_21_6 ~= UNASSIGNED_KEY then
		if var_21_5 == "keyboard" then
			if type(var_21_6) == "number" then
				local var_21_9
				local button_locale_name = Keyboard.button_locale_name(var_21_6)

				button_locale_name = button_locale_name or Keyboard.button_name(var_21_6)

				return var_21_9, button_locale_name, var_21_8
			else
				return nil, Localize(var_21_6), var_21_8
			end
		elseif var_21_5 == "mouse" then
			return ButtonTextureByName(var_21_5 .. "_" .. var_21_6, PLATFORM), Mouse.button_name(var_21_6), var_21_8
		elseif var_21_5 == "gamepad" then
			local button_name = Pad1.button_name(var_21_6)

			return ButtonTextureByName(button_name, PLATFORM), button_name, var_21_8
		end
	end

	return nil, ""
end

GamePadAbilityUI._update_ability_animations = function (self, arg_22_1, arg_22_2)
	-- function 22
	if not self._is_visible then
		return false
	end

	local ability = self._widgets_by_name.ability
	local style = ability.style
	local num = 0.5 + 0.5 * math.sin(arg_22_2 * 5)

	style.input_text.text_color[1] = 100 + num * 155
	style.input_text_shadow.text_color[1] = 100 + num * 155

	self:_set_widget_dirty(ability)

	return true
end

GamePadAbilityUI.set_alpha = function (self, arg_23_1)
	-- function 23
	for k, v in pairs(self._widgets) do
		self:_set_widget_dirty(v)
	end

	self._render_settings.alpha_multiplier = arg_23_1

	self:set_dirty()
end

GamePadAbilityUI._update_muneric_ui_ability_cooldown = function (self)
	-- function 24
	local local_player = Managers.player:local_player()

	if not local_player then
		return
	end

	local player_unit = local_player.player_unit

	if not ALIVE[player_unit] then
		return
	end

	local ability = self._widgets_by_name.ability

	if not ability then
		return
	end

	local extension = ScriptUnit.extension(player_unit, "career_system")
	local can_use_activated_ability = extension:can_use_activated_ability(1)

	ability.content.can_use_ability = can_use_activated_ability

	if not can_use_activated_ability then
		return
	end

	local current_ability_cooldown, var_24_6 = extension:current_ability_cooldown()

	ability.content.ability_cooldown = UIUtils.format_time(current_ability_cooldown)

	self:_set_widget_dirty(ability)
end

GamePadAbilityUI._update_ability_charges_widgets = function (self, arg_25_1, arg_25_2)
	-- function 25
	local flag = false
	local player_unit = self._player.player_unit

	if not player_unit then
		return flag
	end

	local extension = ScriptUnit.extension(player_unit, "career_system")
	local get_number_of_ability_cooldowns = extension:get_number_of_ability_cooldowns()

	if self._ability_cooldowns ~= get_number_of_ability_cooldowns then
		if not self._ability_cooldowns then
			for i = 1, get_number_of_ability_cooldowns do
				if not self._ability_charge_widgets[i] then
					local tbl = {
						0,
						(i - 1) * 22,
						1
					}
					local create_ability_charges_widget = UIWidgets.create_ability_charges_widget("ability_charges", nil, tbl)
					local var_25_6 = UIWidget.init(create_ability_charges_widget)

					self._ability_charge_widgets[#self._ability_charge_widgets + 1] = var_25_6
				end
			end
		elseif not (not self._ability_cooldowns and not (get_number_of_ability_cooldowns < self._ability_cooldowns)) then
			self._ability_charge_widgets[#self._ability_charge_widgets] = nil
		elseif not (not self._ability_cooldowns and not (get_number_of_ability_cooldowns > self._ability_cooldowns)) then
			local num = get_number_of_ability_cooldowns - self._ability_cooldowns

			for j = 1, num do
				local tbl_2 = {
					0,
					(self._ability_cooldowns + (j - 1)) * 22,
					1
				}
				local create_ability_charges_widget_2 = UIWidgets.create_ability_charges_widget("ability_charges", nil, tbl_2)
				local var_25_10 = UIWidget.init(create_ability_charges_widget_2)

				self._ability_charge_widgets[#self._ability_charge_widgets + 1] = var_25_10
			end
		end

		self._ability_cooldowns = get_number_of_ability_cooldowns
		flag = true
	end

	local num_charges_ready = extension:num_charges_ready()

	if self._charges_ready ~= num_charges_ready then
		for k = self._ability_cooldowns, 1, -1 do
			self._ability_charge_widgets[k].content.ready = num_charges_ready == 0 or k <= num_charges_ready
		end

		self._charges_ready = num_charges_ready
		flag = true
	end

	return flag
end
