-- chunkname: @scripts/ui/hud_ui/pet_ui.lua

require("scripts/unit_extensions/ai_commander/ai_commander_extension")

local var_0_0 = local_require("scripts/ui/hud_ui/pet_ui_definitions")
local SKULL_TEXTURES = var_0_0.SKULL_TEXTURES
local SKULL_GLOW_TEXTURES = var_0_0.SKULL_GLOW_TEXTURES
local RETAINED_MODE_ENABLED = var_0_0.RETAINED_MODE_ENABLED

PetUI = class(PetUI)

PetUI.init = function (self, arg_1_1, arg_1_2)
	-- function 1
	self._parent = arg_1_1
	self._ui_renderer = arg_1_2.ui_renderer
	self._render_settings = {
		snap_pixel_positions = true
	}
	self._global_pet_counter = 0
	self._last_amount_pets = 0
	self._last_resolution = {}

	self:_create_ui_elements()
end

PetUI.destroy = function (self, arg_2_1, arg_2_2)
	-- function 2
	for k, v in pairs(self._pet_widget_by_unit) do
		local marker_id = v.content.marker_id

		if not marker_id then
			Managers.state.event:trigger("remove_world_marker", marker_id)
		end
	end

	if not RETAINED_MODE_ENABLED then
		self:_destroy_all_widgets()
	end
end

PetUI._destroy_all_widgets = function (self)
	-- function 3
	for k, v in pairs(self._pet_widget_list) do
		UIWidget.destroy(self._ui_renderer, v)
	end

	UIWidget.destroy(self._ui_renderer, self._container_widget)
end

PetUI._create_ui_elements = function (self)
	-- function 4
	UIRenderer.clear_scenegraph_queue(self._ui_renderer)

	self._ui_scenegraph = UISceneGraph.init_scenegraph(var_0_0.scenegraph_definition)
	self._ui_animator = UIAnimator:new(self._ui_scenegraph, var_0_0.animation_definitions)
	self._pet_widget_by_unit = {}
	self._pet_widget_list = {}
	self._pet_widget_animation_ids = {}
	self._pet_attack_status = {}
	self._container_widget = UIWidget.init(var_0_0.container_widget_definition)

	local gui = self._ui_renderer.gui
	local gui_retained = self._ui_renderer.gui_retained

	self._container_widget.content.materials = {
		Gui.material(gui, "necromancer_command_coin_follow"),
		Gui.material(gui, "necromancer_command_coin_attack"),
		Gui.material(gui, "necromancer_command_coin_defend"),
		Gui.material(gui, "necromancer_command_coin")
	}
	self._container_widget.content.retained_materials = {
		Gui.material(gui_retained, "necromancer_command_coin_follow"),
		Gui.material(gui_retained, "necromancer_command_coin_attack"),
		Gui.material(gui_retained, "necromancer_command_coin_defend"),
		Gui.material(gui_retained, "necromancer_command_coin")
	}
	self._dirty = true
end

PetUI.set_visible = function (self, arg_5_1)
	-- function 5
	self._is_visible = arg_5_1

	self:_set_elements_visible(arg_5_1)
end

PetUI._set_elements_visible = function (self, arg_6_1)
	-- function 6
	local _ui_renderer = self._ui_renderer

	UIRenderer.set_element_visible(_ui_renderer, self._container_widget.element, arg_6_1)

	for i, v in ipairs(self._pet_widget_list) do
		UIRenderer.set_element_visible(_ui_renderer, v.element)
	end

	self._retained_elements_visible = arg_6_1

	self:_set_all_dirty()
end

PetUI._set_widget_dirty = function (self, arg_7_1)
	-- function 7
	arg_7_1.element.dirty = true
	self._dirty = true
end

PetUI._set_all_dirty = function (self)
	-- function 8
	UIUtils.mark_dirty(self._pet_widget_list)
	self:_set_widget_dirty(self._container_widget)
end

PetUI._create_pet_widget = function (self, arg_9_1)
	-- function 9
	local num = #self._pet_widget_list + 1
	local var_9_1 = UIWidget.init(var_0_0.pet_widget_definition)
	local content = var_9_1.content
	local random = math.random(num, #SKULL_TEXTURES)

	SKULL_TEXTURES[random], SKULL_TEXTURES[num] = SKULL_TEXTURES[num], SKULL_TEXTURES[random]
	SKULL_GLOW_TEXTURES[random], SKULL_GLOW_TEXTURES[num] = SKULL_GLOW_TEXTURES[num], SKULL_GLOW_TEXTURES[random]

	local content_2 = var_9_1.content
	local var_9_5 = SKULL_TEXTURES[num]

	var_9_5 = var_9_5 or SKULL_TEXTURES[1]
	content_2.icon = var_9_5

	local content_3 = var_9_1.content
	local var_9_7 = SKULL_GLOW_TEXTURES[num]

	var_9_7 = var_9_7 or SKULL_GLOW_TEXTURES[1]
	content_3.icon_glow = var_9_7
	self._pet_widget_by_unit[arg_9_1] = var_9_1
	content.unit = arg_9_1
	self._global_pet_counter = self._global_pet_counter + 1
	content.order_index = self._global_pet_counter
	self._pet_widget_list[num] = var_9_1

	local start_animation = self._ui_animator:start_animation("spawn_skeleton", var_9_1, var_0_0.scenegraph_definition)

	self._pet_widget_animation_ids[var_9_1] = start_animation

	return var_9_1
end

local function fn(arg_10_0, arg_10_1)
	-- function 10
	local get_service = Managers.input:get_service(arg_10_0)
	local flag = not get_service and get_service:get_keymapping(arg_10_1)
	local flag_2 = not flag and flag[1]
	local flag_3 = not flag and flag[2]
	local var_10_4

	if flag_3 ~= UNASSIGNED_KEY then
		if flag_2 == "keyboard" then
			var_10_4 = Keyboard.button_name(flag_3)
		elseif flag_2 == "mouse" then
			var_10_4 = Mouse.button_name(flag_3)
		elseif flag_2 == "gamepad" then
			var_10_4 = Pad1.button_name(flag_3)
		end
	end

	return var_10_4 or "???"
end

PetUI._pet_ui_available = function (self, arg_11_1)
	-- function 11
	local _ui_available = self._ui_available
	local flag = not arg_11_1 and arg_11_1:career_name()

	if not CareerSettings[flag].show_pet_ui then
		if not RETAINED_MODE_ENABLED and not _ui_available then
			self:destroy()
		end

		table.clear(self._pet_widget_by_unit)
		table.clear(self._pet_widget_list)

		self._ui_available = false
	else
		if not (not RETAINED_MODE_ENABLED and _ui_available) then
			self:_set_all_dirty()
		end

		self._ui_available = true
	end

	return self._ui_available
end

local tbl = {}

PetUI._update_animations = function (self, arg_12_1)
	-- function 12
	table.clear(tbl)

	local _ui_animator = self._ui_animator

	_ui_animator:update(arg_12_1)

	local _change_command_state_anim = self._change_command_state_anim

	if not _change_command_state_anim then
		if not _ui_animator:is_animation_completed(_change_command_state_anim) then
			self:_set_widget_dirty(self._container_widget)
		else
			self._change_command_state_anim = nil
		end
	end

	for k, v in pairs(self._pet_widget_animation_ids) do
		if not _ui_animator:is_animation_completed(v) then
			self:_set_widget_dirty(k)
		else
			tbl[#tbl + 1] = k
		end
	end

	for k_2 = 1, #tbl do
		local var_12_2 = tbl[k_2]

		self._pet_widget_animation_ids[var_12_2] = nil
	end
end

local function fn_2(self, arg_13_1)
	-- function 13
	return self.content.order_index < arg_13_1.content.order_index
end

PetUI._update_pet_container = function (self, arg_14_1, arg_14_2, arg_14_3)
	-- function 14
	local player_unit = arg_14_3.player_unit
	local has_extension = ScriptUnit.has_extension(player_unit, "ai_commander_system")
	local get_controlled_units = has_extension:get_controlled_units()
	local var_14_3 = next(get_controlled_units)
	local command_state

	if not var_14_3 then
		command_state = has_extension:command_state(var_14_3)

		if not command_state then
			-- Nothing
		end
	end

	command_state = CommandStates.Following

	::label_14_0::

	local _container_widget = self._container_widget

	if command_state == self._last_command_state or not self._ui_animator:is_animation_completed(self._change_command_state_anim) then
		self._change_command_state_anim = self._ui_animator:start_animation("change_command_state", _container_widget, var_0_0.scenegraph_definition, command_state)
		self._last_command_state = command_state
	end

	if not _container_widget.content.initialized then
		_container_widget.content.initialized = true
		_container_widget.content.help_text = string.format("{#color(255,168,0)}[%s]{#reset()} to attack", Utf8.upper(fn("Player", "action_one"))) .. string.format("\n{#color(255,168,0)}[%s]{#reset()} to hold a position", Utf8.upper(fn("Player", "action_two_hold"))) .. string.format("\n{#color(255,168,0)}[%s]{#reset()} to dark pact", Utf8.upper(fn("Player", "weapon_reload")))
	end

	local has_extension_2 = ScriptUnit.has_extension(player_unit, "buff_system")
	local show_glow = _container_widget.content.show_glow

	_container_widget.content.show_glow = not not has_extension_2:get_buff_type("sienna_necromancer_6_3_available_charge")

	if show_glow ~= _container_widget.content.show_glow then
		self:_set_widget_dirty(_container_widget)
	end

	local _pet_widget_by_unit = self._pet_widget_by_unit
	local _pet_widget_list = self._pet_widget_list
	local _pet_attack_status = self._pet_attack_status
	local has_extension_3 = ScriptUnit.has_extension(player_unit, "inventory_system")
	local flag = not has_extension_3 and has_extension_3:get_wielded_slot_item_template()
	local flag_2 = not flag and not not flag.is_command_utility_weapon
	local flag_3 = false

	for k in pairs(get_controlled_units) do
		if not has_extension:pet_ui_data(k) and not HEALTH_ALIVE[k] then
			if not _pet_widget_by_unit[k] then
				local _create_pet_widget = self:_create_pet_widget(k)

				flag_3 = true

				self:add_pet_nameplate(k, _create_pet_widget)
			end

			local has_extension_4 = ScriptUnit.has_extension(k, "buff_system")
			local flag_4 = not has_extension_4 and has_extension_4:has_buff_type("skeleton_command_attack_boost")
			local var_14_18 = _pet_widget_by_unit[k]

			if not (not flag_4 and _pet_attack_status[k]) then
				local start_animation = self._ui_animator:start_animation("fade_in_skull_glow", var_14_18, var_0_0.scenegraph_definition)

				self._pet_widget_animation_ids[var_14_18] = start_animation
			elseif flag_4 or not _pet_attack_status[k] then
				local start_animation_2 = self._ui_animator:start_animation("fade_out_skull_glow", var_14_18, var_0_0.scenegraph_definition)

				self._pet_widget_animation_ids[var_14_18] = start_animation_2
			end

			_pet_attack_status[k] = flag_4
		end
	end

	if not Application.user_setting("numeric_ui") then
		local get_controlled_units_count = has_extension:get_controlled_units_count()
		local _last_amount_pets = self._last_amount_pets

		_last_amount_pets = _last_amount_pets or 0

		if _last_amount_pets ~= get_controlled_units_count then
			_container_widget.content.pet_amount_text = get_controlled_units_count
			_container_widget.content.pet_amount_text_shadow = get_controlled_units_count
			self._last_amount_pets = get_controlled_units_count

			self:_set_widget_dirty(_container_widget)
		end
	end

	local hovered_friendly_unit, var_14_24 = has_extension:hovered_friendly_unit()
	local flag_5 = hovered_friendly_unit or var_14_24

	for j = #_pet_widget_list, 1, -1 do
		local var_14_26 = _pet_widget_list[j]
		local unit = var_14_26.content.unit

		if not (not has_extension and self:_update_pet_widget(var_14_26, has_extension, flag_2, flag_5)) then
			_pet_widget_by_unit[unit] = nil

			local marker_id = var_14_26.content.marker_id

			if not marker_id then
				Managers.state.event:trigger("remove_world_marker", marker_id)

				var_14_26.content.marker_id = false
				var_14_26.content.marker_widget = nil
			end

			if not RETAINED_MODE_ENABLED then
				UIWidget.destroy(self._ui_renderer, var_14_26)
			end

			table.remove(_pet_widget_list, j)

			flag_3 = true
		end
	end

	if not flag_3 then
		table.sort(self._pet_widget_list, fn_2)

		local count = #self._pet_widget_list

		for k_2, v in pairs(self._pet_widget_list) do
			var_0_0.reposition_widget(v, k_2, count)
			self:_set_widget_dirty(v)
		end
	end
end

PetUI.add_pet_nameplate = function (self, arg_15_1, arg_15_2)
	-- function 15
	if not self._show_nameplates then
		Managers.state.event:trigger("add_world_marker_unit", "pet_nameplate", arg_15_1, function (arg_16_0, arg_16_1)
			-- function 16
			if arg_15_2.content.marker_id ~= false then
				arg_15_2.content.marker_id = arg_16_0
				arg_15_2.content.marker_widget = arg_16_1
				arg_16_1.content.text = "Skeleton"
			end
		end)
	end
end

PetUI.update = function (self, arg_17_1, arg_17_2, arg_17_3)
	-- function 17
	if not self._is_visible then
		return
	end

	if not self:_pet_ui_available(arg_17_3) then
		return
	end

	self:_update_animations(arg_17_1, arg_17_2, arg_17_3)
	self:_update_pet_container(arg_17_1, arg_17_2, arg_17_3)
	self:_handle_resolution_modified()
	self:_handle_gamepad_activity()
	self:_draw(arg_17_1, arg_17_2)
end

PetUI._handle_gamepad_activity = function (self)
	-- function 18
	local is_device_active = Managers.input:is_device_active("gamepad")
	local flag = self._gamepad_active_last_frame == nil

	if not is_device_active then
		if not self._gamepad_active_last_frame and not flag then
			self._gamepad_active_last_frame = true
			self._ui_scenegraph.container.local_position[1] = 435
			self._ui_scenegraph.container.local_position[2] = 10

			self:_set_all_dirty()
		end
	elseif self._gamepad_active_last_frame or not flag then
		self._gamepad_active_last_frame = false
		self._ui_scenegraph.container.local_position[1] = 460
		self._ui_scenegraph.container.local_position[2] = 0

		self:_set_all_dirty()
	end
end

PetUI._handle_resolution_modified = function (self)
	-- function 19
	local res_w = RESOLUTION_LOOKUP.res_w
	local res_h = RESOLUTION_LOOKUP.res_h

	if not (self._last_resolution.res_w ~= res_w or self._last_resolution.res_h == res_h) then
		self:_set_all_dirty()

		self._last_resolution.res_w = res_w
		self._last_resolution.res_h = res_h
	end
end

PetUI.resolution_modified = function (self)
	-- function 20
	self:_set_all_dirty()
end

PetUI._draw = function (self, arg_21_1, arg_21_2)
	-- function 21
	if self._dirty or not RETAINED_MODE_ENABLED then
		return
	end

	local _ui_renderer = self._ui_renderer

	UIRenderer.begin_pass(_ui_renderer, self._ui_scenegraph, FAKE_INPUT_SERVICE, arg_21_1, nil, self._render_settings)
	UIRenderer.draw_widget(_ui_renderer, self._container_widget)
	UIRenderer.draw_all_widgets(_ui_renderer, self._pet_widget_list)
	UIRenderer.end_pass(_ui_renderer)

	self._dirty = false
end

PetUI._update_pet_widget = function (self, arg_22_1, arg_22_2, arg_22_3, arg_22_4)
	-- function 22
	local content = arg_22_1.content
	local unit = content.unit
	local pet_ui_data, var_22_3, var_22_4 = arg_22_2:pet_ui_data(unit)

	if not pet_ui_data then
		return false
	end

	local marker_widget = content.marker_widget

	if not marker_widget then
		marker_widget.content.visible = arg_22_3

		if pet_ui_data.pet_ui_type == "health" then
			marker_widget.content.progress = var_22_3 / var_22_4
		end
	end

	local is_highlighted = content.is_highlighted

	content.is_highlighted = not arg_22_3 and unit == arg_22_4

	if is_highlighted ~= content.is_highlighted then
		self:_set_widget_dirty(arg_22_1)
	end

	return true
end
