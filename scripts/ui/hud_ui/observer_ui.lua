-- chunkname: @scripts/ui/hud_ui/observer_ui.lua

local var_0_0 = local_require("scripts/ui/hud_ui/observer_ui_definitions")
local flag = true
local num = 0
local num_2 = 10

ObserverUI = class(ObserverUI)

ObserverUI.init = function (self, arg_1_1, arg_1_2)
	-- function 1
	self._parent = arg_1_1
	self.ui_renderer = arg_1_2.ui_renderer
	self.ingame_ui = arg_1_2.ingame_ui
	self.input_manager = arg_1_2.input_manager
	self.profile_synchronizer = arg_1_2.profile_synchronizer
	self.player_manager = arg_1_2.player_manager
	self.peer_id = arg_1_2.peer_id
	self.local_player = Managers.player:local_player()
	self.player_shielded = false
	self._is_visible = false

	self:create_ui_elements()
end

ObserverUI.create_ui_elements = function (self)
	-- function 2
	self.ui_scenegraph = UISceneGraph.init_scenegraph(var_0_0.scenegraph_definition)
	self.divider_widget = UIWidget.init(var_0_0.widget_definitions.divider)
	self.player_name_widget = UIWidget.init(var_0_0.widget_definitions.player_name)
	self.hero_name_widget = UIWidget.init(var_0_0.widget_definitions.hero_name)
	self.hp_bar_widget = UIWidget.init(var_0_0.widget_definitions.hp_bar)
	self.player_name_widget.style.text.localize = false
	flag = false

	self:set_visible(false)
	self:draw()
end

ObserverUI.get_player_camera_extension = function (self)
	-- function 3
	local peer_id = self.peer_id
	local camera_follow_unit = self.player_manager:player_from_peer_id(peer_id).camera_follow_unit

	if not camera_follow_unit and not ScriptUnit.has_extension(camera_follow_unit, "camera_system") then
		return ScriptUnit.extension(camera_follow_unit, "camera_system")
	end
end

ObserverUI.handle_observer_player_changed = function (self)
	-- function 4
	if not self:get_player_camera_extension() then
		return
	end

	local peer_id = self.peer_id
	local player_from_peer_id = self.player_manager:player_from_peer_id(peer_id)
	local observed_unit = player_from_peer_id:observed_unit()

	if not ALIVE[observed_unit] then
		observed_unit = player_from_peer_id.player_unit
	end

	if not Unit.alive(observed_unit) then
		local _observed_unit = self._observed_unit

		if _observed_unit ~= observed_unit then
			self:_set_observed_unit(_observed_unit)
		end
	else
		self:stop_draw_observer_ui()
	end
end

ObserverUI._set_observed_unit = function (self, arg_5_1)
	-- function 5
	local SPProfiles = SPProfiles
	local profile_synchronizer = self.profile_synchronizer
	local players = Managers.player:players()
	local flag = false
	local str = ""
	local owner = Managers.player:owner(arg_5_1)
	local str_2 = ""

	if not owner then
		flag = owner:is_player_controlled()
		str = owner:name()

		local local_player_id = owner:local_player_id()
		local profile_by_peer = profile_synchronizer:profile_by_peer(owner.peer_id, local_player_id)

		str_2 = not SPProfiles[profile_by_peer] and SPProfiles[profile_by_peer].display_name
	end

	self.player_name_widget.content.text = not flag and str and str .. " (BOT)"
	self.hero_name_widget.content.text = str_2
	self._observed_unit = arg_5_1
	self._skip_bar_animation = true
	self.player_name_widget.element.dirty = true
	self.hero_name_widget.element.dirty = true
	self._dirty = true
end

ObserverUI.stop_draw_observer_ui = function (self)
	-- function 6
	self._observed_unit = nil
	self.divider_widget.element.dirty = true
	self.player_name_widget.element.dirty = true
	self.hero_name_widget.element.dirty = true
	self.hp_bar_widget.element.dirty = true
	self._dirty = true
end

ObserverUI.update = function (self, arg_7_1, arg_7_2)
	-- function 7
	if not flag then
		self:create_ui_elements()
	end

	if not self._is_visible then
		return
	end

	self:handle_observer_player_changed()

	if not self._observed_unit then
		self:_update_follow_unit_health_bar(self._observed_unit)
		self:update_health_animations(arg_7_1)

		self._skip_bar_animation = nil
	end

	self:draw(arg_7_1)
end

ObserverUI.draw = function (self, arg_8_1)
	-- function 8
	local ui_renderer = self.ui_renderer
	local ui_scenegraph = self.ui_scenegraph
	local get_service = self.input_manager:get_service("Player")

	UIRenderer.begin_pass(ui_renderer, ui_scenegraph, get_service, arg_8_1)

	if not self._dirty then
		UIRenderer.draw_widget(ui_renderer, self.divider_widget)
		UIRenderer.draw_widget(ui_renderer, self.player_name_widget)
		UIRenderer.draw_widget(ui_renderer, self.hero_name_widget)

		self._dirty = false
	end

	UIRenderer.draw_widget(ui_renderer, self.hp_bar_widget)
	UIRenderer.end_pass(ui_renderer)
end

ObserverUI.destroy = function (arg_9_0)
	-- function 9
	return
end

ObserverUI.set_visible = function (self, arg_10_1)
	-- function 10
	if self._is_visible ~= arg_10_1 then
		local divider_widget = self.divider_widget

		UIRenderer.set_element_visible(self.ui_renderer, divider_widget.element, arg_10_1)

		divider_widget.content.visible = arg_10_1
		divider_widget.element.dirty = true

		local player_name_widget = self.player_name_widget

		UIRenderer.set_element_visible(self.ui_renderer, player_name_widget.element, arg_10_1)

		divider_widget.content.visible = arg_10_1
		player_name_widget.element.dirty = true

		local hero_name_widget = self.hero_name_widget

		UIRenderer.set_element_visible(self.ui_renderer, hero_name_widget.element, arg_10_1)

		divider_widget.content.visible = arg_10_1
		hero_name_widget.element.dirty = true

		local hp_bar_widget = self.hp_bar_widget

		UIRenderer.set_element_visible(self.ui_renderer, hp_bar_widget.element, arg_10_1)

		divider_widget.content.visible = arg_10_1
		hp_bar_widget.element.dirty = true
		self._dirty = true
		self._is_visible = arg_10_1
	end
end

ObserverUI.is_visible = function (self)
	-- function 11
	return self._is_visible
end

ObserverUI._update_follow_unit_health_bar = function (self, arg_12_1)
	-- function 12
	local profile_synchronizer = self.profile_synchronizer
	local owner = Managers.player:owner(arg_12_1)
	local var_12_2
	local var_12_3
	local var_12_4
	local var_12_5
	local var_12_6
	local num_3 = 0
	local num_4 = 1
	local flag = false
	local hp_bar_widget = self.hp_bar_widget
	local content = hp_bar_widget.content
	local style = hp_bar_widget.style

	if not owner then
		local extension = ScriptUnit.extension(arg_12_1, "health_system")
		local extension_2 = ScriptUnit.extension(arg_12_1, "status_system")

		var_12_2 = extension:current_health_percent()

		local get_max_health = extension:get_max_health()
		local has_assist_shield, var_12_17 = extension:has_assist_shield()

		if not has_assist_shield then
			num_3 = var_12_17 / get_max_health

			if not self.player_shielded then
				local hp_bar_highlight = style.hp_bar_highlight

				hp_bar_highlight.color[1] = 255
				hp_bar_highlight.color[2] = 140
				hp_bar_highlight.color[3] = 180
				hp_bar_highlight.color[4] = 255
				hp_bar_widget.element.dirty = true
				self._dirty = true
				self.player_shielded = true
			end
		elseif not self.player_shielded then
			local hp_bar_highlight_2 = style.hp_bar_highlight

			hp_bar_highlight_2.color[1] = 0
			hp_bar_highlight_2.color[2] = 0
			hp_bar_highlight_2.color[3] = 0
			hp_bar_highlight_2.color[4] = 0
			hp_bar_widget.element.dirty = true
			self._dirty = true
			self.player_shielded = false
		end

		var_12_5 = extension_2:is_wounded()
		var_12_3 = not extension_2:is_knocked_down() and var_12_2 > 0
		var_12_6 = extension_2:is_ready_for_assisted_respawn()

		local extension_3 = ScriptUnit.extension(arg_12_1, "buff_system")
		local num_buff_perk = extension_3:num_buff_perk("skaven_grimoire")
		local apply_buffs_to_value = extension_3:apply_buffs_to_value(PlayerUnitDamageSettings.GRIMOIRE_HEALTH_DEBUFF, "curse_protection")
		local num_buff_perk_2 = extension_3:num_buff_perk("twitch_grimoire")
		local apply_buffs_to_value_2 = extension_3:apply_buffs_to_value(PlayerUnitDamageSettings.GRIMOIRE_HEALTH_DEBUFF, "curse_protection")
		local num_buff_perk_3 = extension_3:num_buff_perk("slayer_curse")
		local apply_buffs_to_value_3 = extension_3:apply_buffs_to_value(PlayerUnitDamageSettings.SLAYER_CURSE_HEALTH_DEBUFF, "curse_protection")
		local get_difficulty = Managers.state.difficulty:get_difficulty()
		local num_buff_perk_4 = extension_3:num_buff_perk("mutator_curse")
		local apply_buffs_to_value_4 = extension_3:apply_buffs_to_value(WindSettings.light.curse_settings.value[get_difficulty], "curse_protection")
		local apply_buffs_to_value_5 = extension_3:apply_buffs_to_value(0, "health_curse")
		local apply_buffs_to_value_6 = extension_3:apply_buffs_to_value(apply_buffs_to_value_5, "curse_protection")

		num_4 = 1 + num_buff_perk * apply_buffs_to_value + num_buff_perk_2 * apply_buffs_to_value_2 + num_buff_perk_3 * apply_buffs_to_value_3 + num_buff_perk_4 * apply_buffs_to_value_4 + apply_buffs_to_value_6
	else
		var_12_2 = 0
		var_12_3 = false
	end

	content.hp_bar.draw_health_bar = not var_12_6

	local flag_2 = var_12_2 <= 0
	local var_12_33 = num
	local flag_3 = (flag_2 or var_12_3 or not (var_12_2 < UISettings.unit_frames.low_health_threshold)) and nil
	local on_player_health_changed = self:on_player_health_changed("my_player", hp_bar_widget, var_12_2 * num_4)
	local on_num_grimoires_changed = self:on_num_grimoires_changed("my_player_grimoires", hp_bar_widget, 1 - num_4)

	flag = flag or on_player_health_changed or on_num_grimoires_changed

	local bar_value = hp_bar_widget.content.hp_bar.bar_value
	local bar_value_2 = hp_bar_widget.content.hp_bar_grimoire_debuff.bar_value

	content.hp_bar_shield.bar_value_position = bar_value
	content.hp_bar_shield.bar_value_offset = bar_value_2
	content.hp_bar_shield.bar_value_size = num_3

	local hp_bar_max_health_divider = content.hp_bar_max_health_divider

	hp_bar_max_health_divider.active = false

	local hp_bar_grimoire_icon = content.hp_bar_grimoire_icon

	hp_bar_grimoire_icon.active = false

	if num_4 < 1 then
		hp_bar_max_health_divider.active = true

		local var_12_41 = var_0_0.scenegraph_definition.hp_bar_grimoire_debuff_fill.size[1]
		local num_5 = content.hp_bar_grimoire_debuff.bar_value * var_12_41
		local hp_bar_grimoire_icon_2 = hp_bar_widget.style.hp_bar_grimoire_icon

		hp_bar_grimoire_icon.active = true

		local var_12_44 = hp_bar_grimoire_icon_2.offset[1]
		local num_6 = -num_5 / 2

		if var_12_44 ~= num_6 then
			hp_bar_grimoire_icon_2.offset[1] = num_6
			flag = true
			hp_bar_widget.style.hp_bar_max_health_divider.offset[1] = -num_5
		end
	end

	if not owner then
		local local_player_id = owner:local_player_id()

		if not profile_synchronizer:profile_by_peer(owner.peer_id, local_player_id) then
			if var_12_3 or not flag_2 then
				var_12_33 = num
			else
				var_12_33 = num_2
			end

			content.hp_bar.low_health = flag_3
			content.hp_bar.is_knocked_down = var_12_3
			content.hp_bar.is_wounded = var_12_5
			style.hp_bar_divider.texture_amount = var_12_33
		end
	end

	local modified = RESOLUTION_LOOKUP.modified

	if flag or not modified then
		hp_bar_widget.element.dirty = true
		self._dirty = true
	end
end

ObserverUI.on_player_health_changed = function (self, arg_13_1, arg_13_2, arg_13_3)
	-- function 13
	if not self.bar_animations_data then
		self.bar_animations_data = {}
	end

	local unit_frames = UISettings.unit_frames
	local var_13_1 = self.bar_animations_data[arg_13_1]

	var_13_1 = var_13_1 or {
		low_health_animation = UIAnimation.init(UIAnimation.pulse_animation, arg_13_2.style.hp_bar.color, 1, unit_frames.low_health_animation_alpha_from, unit_frames.low_health_animation_alpha_to, unit_frames.low_health_animation_time)
	}
	self.bar_animations_data[arg_13_1] = var_13_1

	local current_health = var_13_1.current_health

	var_13_1.current_health = arg_13_3

	if not (not (arg_13_3 <= 1) or arg_13_3 == current_health) then
		local is_knocked_down = arg_13_2.content.hp_bar.is_knocked_down
		local bar_value = arg_13_2.content.hp_bar.bar_value
		local health_bar_lerp_time = UISettings.unit_frames.health_bar_lerp_time
		local var_13_6

		if bar_value < arg_13_3 then
			var_13_6 = (arg_13_3 - bar_value) * health_bar_lerp_time
		else
			var_13_6 = (bar_value - arg_13_3) * health_bar_lerp_time
		end

		local flag

		flag = not ((is_knocked_down or not (arg_13_3 < (current_health or 1))) and false) and 0 and var_13_1.animate_highlight
		var_13_1.animate_highlight = flag
		var_13_1.animate = true
		var_13_1.new_health = arg_13_3
		var_13_1.previous_health = bar_value
		var_13_1.time = 0

		local flag_2

		flag_2 = not self._skip_bar_animation and 0 and var_13_6
		var_13_1.total_time = flag_2
		var_13_1.widget = arg_13_2
		var_13_1.bar = arg_13_2.content.hp_bar

		return true
	end
end

ObserverUI.on_num_grimoires_changed = function (self, arg_14_1, arg_14_2, arg_14_3)
	-- function 14
	if not self.bar_animations_data then
		self.bar_animations_data = {}
	end

	local unit_frames = UISettings.unit_frames
	local var_14_1 = self.bar_animations_data[arg_14_1]

	var_14_1 = var_14_1 or {}

	if arg_14_3 ~= var_14_1.current_health_debuff then
		local bar_value = arg_14_2.content.hp_bar_grimoire_debuff.bar_value
		local health_bar_lerp_time = UISettings.unit_frames.health_bar_lerp_time
		local var_14_4

		if bar_value < arg_14_3 then
			var_14_4 = (arg_14_3 - bar_value) * health_bar_lerp_time
		else
			var_14_4 = (bar_value - arg_14_3) * health_bar_lerp_time
		end

		var_14_1.animate = true
		var_14_1.new_health = arg_14_3
		var_14_1.previous_health = bar_value
		var_14_1.time = 0

		local flag

		flag = not self._skip_bar_animation and 0 and var_14_4
		var_14_1.total_time = flag
		var_14_1.widget = arg_14_2
		var_14_1.bar = arg_14_2.content.hp_bar_grimoire_debuff
	end

	var_14_1.current_health_debuff = arg_14_3
	self.bar_animations_data[arg_14_1] = var_14_1
end

ObserverUI.update_health_animations = function (self, arg_15_1)
	-- function 15
	local bar_animations_data = self.bar_animations_data

	if not bar_animations_data then
		for k, v in pairs(bar_animations_data) do
			local widget = v.widget
			local bar = v.bar

			if not bar.low_health then
				UIAnimation.update(v.low_health_animation, arg_15_1)
			end

			if not (not v.animate_highlight and self.player_shielded) then
				v.animate_highlight = self:update_damage_highlight(widget, v.animate_highlight, arg_15_1)
			end

			if not v.animate then
				local time = v.time
				local total_time = v.total_time
				local new_health = v.new_health
				local previous_health = v.previous_health
				local update_player_bar_animation = self:update_player_bar_animation(widget, bar, time, total_time, previous_health, new_health, arg_15_1)

				if not update_player_bar_animation then
					v.time = update_player_bar_animation
				else
					v.animate = nil
				end
			end
		end
	end
end

ObserverUI.update_player_bar_animation = function (self, arg_16_1, arg_16_2, arg_16_3, arg_16_4, arg_16_5, arg_16_6, arg_16_7)
	-- function 16
	arg_16_3 = arg_16_3 + arg_16_7

	if arg_16_4 > 0 then
		local style = arg_16_1.style
		local min = math.min(arg_16_3 / arg_16_4, 1)
		local catmullrom = math.catmullrom(min, -14, 0, 0, 0)
		local num = 7
		local num_2 = (min * (num - 1) + 1) / num
		local var_16_5

		if arg_16_5 < arg_16_6 then
			var_16_5 = arg_16_5 + (arg_16_6 - arg_16_5) * num_2
		else
			var_16_5 = arg_16_5 - (arg_16_5 - arg_16_6) * num_2
		end

		arg_16_2.bar_value = var_16_5
		arg_16_1.element.dirty = true
		self._dirty = true

		return not (min < 1) or not arg_16_3 or nil
	end

	arg_16_2.bar_value = arg_16_6

	return nil
end

ObserverUI.update_damage_highlight = function (self, arg_17_1, arg_17_2, arg_17_3)
	-- function 17
	local flag

	flag = not self._skip_bar_animation and 0 and 0.2
	arg_17_2 = arg_17_2 + arg_17_3

	if flag > 0 then
		local style = arg_17_1.style
		local min = math.min(arg_17_2 / flag, 1)
		local num = 255 * math.catmullrom(min, -8, 0, 0, -8)

		style.hp_bar_highlight.color[1] = num
		arg_17_1.element.dirty = true
		self._dirty = true

		return not (min < 1) or not arg_17_2 or nil
	end

	return nil
end
