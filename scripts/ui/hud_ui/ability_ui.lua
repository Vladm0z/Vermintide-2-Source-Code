-- chunkname: @scripts/ui/hud_ui/ability_ui.lua

local var_0_0 = local_require("scripts/ui/hud_ui/ability_ui_definitions")
local scenegraph_definition = var_0_0.scenegraph_definition

AbilityUI = class(AbilityUI)

AbilityUI.init = function (self, arg_1_1, arg_1_2)
	-- function 1
	self._ui_renderer = arg_1_2.ui_renderer
	self._input_manager = arg_1_2.input_manager
	self._player = arg_1_2.player
	self._render_settings = {
		snap_pixel_positions = true
	}

	self:_create_ui_elements()

	self._is_spectator = false
	self._spectated_player = nil
	self._spectated_player_unit = nil
	self._hide_effects = false
	self._ability_charge_widgets = {}

	local event = Managers.state.event

	event:register(self, "input_changed", "event_input_changed")
	event:register(self, "on_spectator_target_changed", "on_spectator_target_changed")
end

AbilityUI._create_ui_elements = function (self)
	-- function 2
	self._ui_scenegraph = UISceneGraph.init_scenegraph(scenegraph_definition)
	self._widgets, self._widgets_by_name = UIUtils.create_widgets(var_0_0.widget_definitions)

	UIRenderer.clear_scenegraph_queue(self._ui_renderer)
	self:event_input_changed()
end

AbilityUI._get_player_unit = function (self)
	-- function 3
	if not self._is_spectator then
		return self._spectated_player, self._spectated_player_unit
	end

	local _player = self._player

	return _player, _player.player_unit
end

AbilityUI._update_ability_widget = function (self, arg_4_1, arg_4_2)
	-- function 4
	local _get_player_unit, var_4_1 = self:_get_player_unit()

	if not var_4_1 then
		return false
	end

	local _hide_effects = self._hide_effects
	local extension = ScriptUnit.extension(var_4_1, "career_system")
	local career_name = extension:career_name()

	if self._career_name ~= career_name then
		local profile_index = extension:profile_index()
		local career_index = extension:career_index()

		_hide_effects = CareerUtils.get_ability_data(profile_index, career_index, 1).hide_ability_ui_effects
		self._hide_effects = _hide_effects
		self._career_name = career_name
		self._ability_cooldowns = nil

		table.clear(self._ability_charge_widgets)
	end

	local var_4_7 = UISettings.ability_ui_data[career_name]

	var_4_7 = var_4_7 or UISettings.ability_ui_data.default

	local ability = self._widgets_by_name.ability
	local content = ability.content
	local style = ability.style

	content.ability_effect.texture_id = var_4_7.ability_effect
	content.ability_effect_top.texture_id = var_4_7.ability_effect_top
	content.ability_bar_highlight = var_4_7.ability_bar_highlight

	local can_use_activated_ability = extension:can_use_activated_ability()
	local get_extra_ability_uses, var_4_13 = extension:get_extra_ability_uses()
	local flag = get_extra_ability_uses > 0

	if not flag then
		content.ability_effect.texture_id = var_4_7.ability_effect_thorn
		content.ability_effect_top.texture_id = var_4_7.ability_effect_top_thorn
	else
		content.ability_effect.texture_id = var_4_7.ability_effect
		content.ability_effect_top.texture_id = var_4_7.ability_effect_top
	end

	if not flag then
		local num = 220 + 35 * (0.5 + 0.5 * math.sin(arg_4_2 * 5))

		style.ability_effect_right.color[1] = num
		style.ability_effect_top_right.color[1] = num
		style.ability_effect_left.color[1] = num
		style.ability_effect_top_left.color[1] = num
	end

	if not can_use_activated_ability then
		content.can_use = true
		content.on_cooldown = extension:current_ability_cooldown() > 0

		local num_2 = 0.5 + 0.5 * math.sin(arg_4_2 * 5)
		local min = math.min(style.ability_effect_left.color[1] + arg_4_1 * 200, 255)

		if not _hide_effects then
			min = 0
			num_2 = 0.5
		end

		local num_3 = 100 + num_2 * 155

		style.ability_effect_right.color[1] = min
		style.ability_effect_top_right.color[1] = min
		style.ability_effect_left.color[1] = min
		style.ability_effect_top_left.color[1] = min
		style.ability_bar_highlight.color[1] = num_3

		return true
	elseif not content.can_use then
		content.can_use = false
		content.on_cooldown = true
		style.ability_effect_right.color[1] = 0
		style.ability_effect_top_right.color[1] = 0
		style.ability_effect_left.color[1] = 0
		style.ability_effect_top_left.color[1] = 0
		style.ability_bar_highlight.color[1] = 0

		return true
	end
end

AbilityUI.destroy = function (self)
	-- function 5
	local event = Managers.state.event

	event:unregister("input_changed", self)
	event:unregister("on_spectator_target_changed", self)
	UIUtils.destroy_widgets(self._ui_renderer, self._widgets)
	print("[AbilityUI] - Destroy")
end

AbilityUI.set_visible = function (self, arg_6_1)
	-- function 6
	self._is_visible = arg_6_1

	self:_set_elements_visible(arg_6_1)
end

AbilityUI._set_elements_visible = function (self, arg_7_1)
	-- function 7
	local _ui_renderer = self._ui_renderer

	for k, v in pairs(self._widgets) do
		UIRenderer.set_element_visible(_ui_renderer, v.element, arg_7_1)
	end

	self._are_elements_visible = arg_7_1
	self._dirty = true
end

AbilityUI._smudge = function (self)
	-- function 8
	UIUtils.mark_dirty(self._widgets)

	if not (not self._ability_charge_widgets and table.is_empty(self._ability_charge_widgets)) then
		UIUtils.mark_dirty(self._ability_charge_widgets)
	end

	self._dirty = true
end

AbilityUI._handle_gamepad = function (self)
	-- function 9
	local is_device_active = Managers.input:is_device_active("gamepad")
	local flag = (UISettings.use_gamepad_hud_layout ~= "auto" or not is_device_active) and UISettings.use_gamepad_hud_layout == "always" or not IS_CONSOLE

	if flag ~= self._are_elements_visible then
		self:_set_elements_visible(flag)

		return flag
	end

	return flag
end

local tbl = {
	root_scenegraph_id = "ability_root",
	is_child = true,
	registry_key = "player_status"
}

AbilityUI.update = function (self, arg_10_1, arg_10_2)
	-- function 10
	if not self._is_visible then
		return
	end

	if not self:_handle_gamepad() then
		return
	end

	local flag = false

	if not HudCustomizer.run(self._ui_renderer, self._ui_scenegraph, tbl) then
		flag = true
	end

	if not RESOLUTION_LOOKUP.modified then
		flag = true
	end

	if not self:_update_ability_widget(arg_10_1, arg_10_2) then
		flag = true
	end

	if not self:_update_ability_charges_widgets(arg_10_1, arg_10_2) then
		flag = true
	end

	if not flag then
		self:_smudge()
	end

	self:_update_numeric_ui_ability_cooldown()
	self:draw(arg_10_1, arg_10_2)
end

AbilityUI.draw = function (self, arg_11_1, arg_11_2)
	-- function 11
	if not (not self._is_visible and self._dirty) then
		return
	end

	local _ui_renderer = self._ui_renderer

	UIRenderer.begin_pass(_ui_renderer, self._ui_scenegraph, FAKE_INPUT_SERVICE, arg_11_1, nil, self._render_settings)
	UIRenderer.draw_all_widgets(_ui_renderer, self._widgets)

	if not (not self._ability_charge_widgets and table.is_empty(self._ability_charge_widgets) or not (self._ability_cooldowns > 1)) then
		UIRenderer.draw_all_widgets(_ui_renderer, self._ability_charge_widgets)
	end

	UIRenderer.end_pass(_ui_renderer)

	self._dirty = false
end

AbilityUI.set_alpha = function (self, arg_12_1)
	-- function 12
	self._render_settings.alpha_multiplier = arg_12_1

	self:_smudge()
end

AbilityUI._get_input_texture_data = function (self, arg_13_1)
	-- function 13
	local _input_manager = self._input_manager
	local get_service = _input_manager:get_service("Player")
	local is_device_active = _input_manager:is_device_active("gamepad")

	return UISettings.get_gamepad_input_texture_data(get_service, arg_13_1, is_device_active)
end

AbilityUI.event_input_changed = function (self)
	-- function 14
	local is_device_active = Managers.input:is_device_active("gamepad")
	local count = #InventorySettings.slots
	local flag

	flag = not is_device_active and "ability" and "action_career"

	local ability = self._widgets_by_name.ability
	local _get_input_texture_data, var_14_5 = self:_get_input_texture_data(flag)

	if not (not var_14_5 and Utf8.length(var_14_5)) then
		local num = 0
	end

	if not var_14_5 then
		local _ui_renderer = self._ui_renderer
		local num_2 = 40
		local input_text = ability.style.input_text

		var_14_5 = UIRenderer.crop_text_width(_ui_renderer, var_14_5, num_2, input_text)
	end

	ability.content.input_text = var_14_5 or ""
	ability.content.input_action = flag

	self:_smudge()
end

AbilityUI.on_spectator_target_changed = function (self, arg_15_1)
	-- function 15
	self._spectated_player_unit = arg_15_1
	self._spectated_player = Managers.player:owner(arg_15_1)
	self._is_spectator = true

	local flag = Managers.state.side:get_side_from_player_unique_id(self._spectated_player:unique_id()):name() == "heroes"

	self:set_visible(flag)
end

AbilityUI._update_numeric_ui_ability_cooldown = function (self)
	-- function 16
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

	local current_ability_cooldown, var_16_6 = extension:current_ability_cooldown()

	ability.content.ability_cooldown = UIUtils.format_time(current_ability_cooldown)

	self:_smudge()
end

AbilityUI._update_ability_charges_widgets = function (self, arg_17_1, arg_17_2)
	-- function 17
	local flag = false
	local _get_player_unit, var_17_2 = self:_get_player_unit()

	if not var_17_2 then
		return flag
	end

	local extension = ScriptUnit.extension(var_17_2, "career_system")
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
					local var_17_7 = UIWidget.init(create_ability_charges_widget)

					self._ability_charge_widgets[#self._ability_charge_widgets + 1] = var_17_7
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
				local var_17_11 = UIWidget.init(create_ability_charges_widget_2)

				self._ability_charge_widgets[#self._ability_charge_widgets + 1] = var_17_11
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
