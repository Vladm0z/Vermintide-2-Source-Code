-- chunkname: @scripts/ui/views/ingame_hud.lua

require("foundation/scripts/util/local_require")
require("scripts/ui/hud_ui/hud_customizer")
local_require("scripts/ui/hud_ui/component_list_definitions/hud_component_list_adventure")
require("scripts/ui/ui_animator")
require("scripts/ui/ui_cleanui")
DLCUtils.dofile("hud_component_list_path")

IngameHud = class(IngameHud)

IngameHud.init = function (self, arg_1_1, arg_1_2)
	-- function 1
	self._parent = arg_1_1
	self._peer_id = Network.peer_id()
	self._player = Managers.player:local_player()
	self._ingame_ui_context = arg_1_2

	self:_setup_components()
end

IngameHud._setup_components = function (self)
	-- function 2
	self._currently_visible_components = {}
	self._current_group_name = nil

	local _ingame_ui_context = self._ingame_ui_context
	local mechanism_setting = Managers.mechanism:mechanism_setting("tobii_available")

	if not rawget(_G, "Tobii") and not mechanism_setting then
		_ingame_ui_context.cleanui = UICleanUI.create(self._peer_id)
		self._clean_ui = _ingame_ui_context.cleanui
		self._clean_ui.hud = self

		local get_is_connected = Tobii.get_is_connected()
		local user_setting = Application.user_setting("tobii_eyetracking")

		user_setting = not user_setting and Application.user_setting("tobii_clean_ui")

		self:enable_clean_ui(not get_is_connected and user_setting)
	else
		self._clean_ui = nil
	end

	local hud_component_list_path = Managers.state.game_mode:settings().hud_component_list_path
	local _setup_component_definitions = self:_setup_component_definitions(hud_component_list_path)

	self._definitions = _setup_component_definitions
	self._components_hud_scale_lookup = _setup_component_definitions.components_hud_scale_lookup

	self:_compile_component_list(_ingame_ui_context, _setup_component_definitions.components)
	Managers.state.event:register(self, "player_party_changed", "event_player_party_changed")
end

IngameHud.reset_components = function (self)
	-- function 3
	self:destroy()
	self:_setup_components()
end

IngameHud.event_player_party_changed = function (self, arg_4_1, arg_4_2, arg_4_3, arg_4_4)
	-- function 4
	if not arg_4_2 then
		return
	end

	self:reset_components()
end

IngameHud._setup_component_definitions = function (arg_5_0, arg_5_1)
	-- function 5
	local var_5_0 = local_require(arg_5_1)
	local clone = table.clone(var_5_0.components)
	local visibility_groups = var_5_0.visibility_groups
	local tbl = {}

	for i, v in ipairs(visibility_groups) do
		tbl[v.name] = v
	end

	for k, v_2 in pairs(DLCSettings) do
		local ingame_hud_components = v_2.ingame_hud_components

		if not ingame_hud_components then
			for k_2, v_3 in pairs(ingame_hud_components) do
				local class_name = v_3.class_name
				local flag = true

				for i6 = 1, #clone do
					if clone[i6].class_name == class_name then
						flag = false
					end
				end

				if not flag then
					clone[#clone + 1] = table.clone(v_3)
				end
			end
		end
	end

	local function fn(self, arg_6_1)
		-- function 6
		local use_hud_scale = arg_6_1.use_hud_scale

		use_hud_scale = not use_hud_scale and not self.use_hud_scale

		return use_hud_scale
	end

	table.sort(clone, fn)

	local tbl_2 = {}
	local tbl_3 = {}

	for i_2, v_4 in ipairs(clone) do
		local class_name_2 = v_4.class_name

		tbl_2[class_name_2] = v_4

		if not v_4.use_hud_scale then
			tbl_3[class_name_2] = true
		end
	end

	for i_3, v_5 in ipairs(clone) do
		local class_name_3 = v_5.class_name
		local visibility_groups_2 = v_5.visibility_groups

		for i_4, v_6 in ipairs(visibility_groups_2) do
			local var_5_13 = tbl[v_6]

			if not var_5_13 then
				fassert(var_5_13, "Could not find the visibility group: (%s) for component: (%s)", v_6, class_name_3)

				local validation_function = var_5_13.validation_function

				fassert(validation_function, "Could not find any validation_function for visibility group: (%s)", v_6)

				if not var_5_13.visible_components then
					var_5_13.visible_components = {}
				end

				var_5_13.visible_components[class_name_3] = true
			end
		end

		local filename = v_5.filename

		require(filename)
	end

	return {
		components = clone,
		components_lookup = tbl_2,
		components_hud_scale_lookup = tbl_3,
		visibility_groups = visibility_groups,
		visibility_groups_lookup = tbl
	}
end

IngameHud._compile_component_list = function (self, arg_7_1, arg_7_2)
	-- function 7
	local tbl = {}
	local tbl_2 = {}
	local tbl_3 = {}
	local tbl_4 = {}

	for i = 1, #arg_7_2 do
		local var_7_4 = arg_7_2[i]
		local class_name = var_7_4.class_name

		fassert(tbl[class_name] == nil, "Duplicate entries of component (%s)", class_name)

		tbl[class_name] = var_7_4

		self:_add_component(tbl, tbl_2, tbl_3, tbl_4, class_name)
	end

	self._component_list = tbl
	self._components = tbl_2
	self._components_array = tbl_3
	self._components_array_id_lookup = tbl_4
end

IngameHud._add_component = function (self, arg_8_1, arg_8_2, arg_8_3, arg_8_4, arg_8_5)
	-- function 8
	local var_8_0 = arg_8_1[arg_8_5]

	fassert(var_8_0, "No definition found for component (%s)", arg_8_5)

	if arg_8_2[arg_8_5] ~= nil then
		table.dump(arg_8_2, "Hud components:")
	end

	fassert(arg_8_2[arg_8_5] == nil, "Component (%s) is already added", arg_8_5)

	local _ingame_ui_context = self._ingame_ui_context
	local validation_function = var_8_0.validation_function

	if not validation_function and not validation_function(_ingame_ui_context, _ingame_ui_context.is_in_inn) then
		local var_8_3 = rawget(_G, arg_8_5):new(self, _ingame_ui_context)

		var_8_3.name = arg_8_5
		arg_8_2[arg_8_5] = var_8_3

		local num = #arg_8_3 + 1

		arg_8_3[num] = var_8_3
		arg_8_4[var_8_3] = num
	end
end

IngameHud._remove_component = function (self, arg_9_1, arg_9_2, arg_9_3, arg_9_4, arg_9_5)
	-- function 9
	local var_9_0 = arg_9_2[arg_9_5]

	if not var_9_0 then
		local var_9_1 = arg_9_1[arg_9_5]

		fassert(var_9_1.validation_function, "Component does not exist and doesn't have a validation_function, how did this happen?")

		local _ingame_ui_context = self._ingame_ui_context
		local validation_function = var_9_1.validation_function(_ingame_ui_context, _ingame_ui_context.is_in_inn)

		fassert(validation_function == false, "Validation functions returned true but component does not exist, somethings weird.")

		return
	end

	self._currently_visible_components[var_9_0.name] = nil

	local var_9_4 = arg_9_4[var_9_0]
	local count = #arg_9_3
	local var_9_6 = arg_9_3[count]

	arg_9_3[var_9_4] = var_9_6
	arg_9_4[var_9_6] = var_9_4

	if not var_9_0.destroy then
		var_9_0:destroy()
	end

	arg_9_2[arg_9_5] = nil
	arg_9_3[count] = nil
	arg_9_4[var_9_0] = nil
end

IngameHud.remove_components = function (self, arg_10_1)
	-- function 10
	local _component_list = self._component_list
	local _components = self._components
	local _components_array = self._components_array
	local _components_array_id_lookup = self._components_array_id_lookup
	local count = #arg_10_1

	for i = 1, count do
		local var_10_5 = arg_10_1[i]

		self:_remove_component(_component_list, _components, _components_array, _components_array_id_lookup, var_10_5)
	end
end

IngameHud.component = function (self, arg_11_1)
	-- function 11
	return self._components[arg_11_1]
end

IngameHud._update_components_post_visibility = function (self)
	-- function 12
	if not self._update_post_visibility then
		local var_12_0 = self._definitions.visibility_groups_lookup[self._current_group_name]
		local _components_array = self._components_array
		local visible_components = var_12_0.visible_components

		for i = 1, #_components_array do
			local var_12_3 = _components_array[i]
			local name = var_12_3.name
			local var_12_5

			if not visible_components then
				var_12_5 = visible_components[name]

				if not var_12_5 then
					-- Nothing
				end
			end

			var_12_5 = false

			::label_12_0::

			if not var_12_3.post_visibility_changed then
				var_12_3:post_visibility_changed(var_12_5)
			end
		end

		self._update_post_visibility = false
	end
end

IngameHud._update_components_visibility = function (self)
	-- function 13
	local visibility_groups = self._definitions.visibility_groups
	local count = #visibility_groups
	local debug_hud_visibility_group = script_data.debug_hud_visibility_group
	local flag = not debug_hud_visibility_group and debug_hud_visibility_group ~= "none"

	for i = 1, count do
		local var_13_4 = visibility_groups[i]
		local name = var_13_4.name
		local validation_function = var_13_4.validation_function
		local flag_2 = false

		if not flag then
			flag_2 = name == debug_hud_visibility_group
		else
			flag_2 = validation_function(self)
		end

		if not flag_2 then
			if name ~= self._current_group_name then
				local _components_array = self._components_array
				local _currently_visible_components = self._currently_visible_components
				local visible_components = var_13_4.visible_components

				for j = 1, #_components_array do
					local var_13_11 = _components_array[j]
					local name_2 = var_13_11.name
					local var_13_13

					if not visible_components then
						var_13_13 = visible_components[name_2]

						if not var_13_13 then
							-- Nothing
						end
					end

					var_13_13 = false

					::label_13_0::

					if not var_13_11.set_visible then
						var_13_11:set_visible(var_13_13)
					end

					_currently_visible_components[name_2] = var_13_13
				end

				self._current_group_name = name
				self._update_post_visibility = true
			end

			break
		end
	end

	if not flag then
		local text = Debug.text
		local str = "HUD visibility group: "
		local tostring = tostring
		local _current_group_name = self._current_group_name

		_current_group_name = _current_group_name or "none"

		text(str .. tostring(_current_group_name))
	end
end

IngameHud.get_hud_component = function (self, arg_14_1)
	-- function 14
	return self._components[arg_14_1]
end

IngameHud._update_hud_scale = function (self)
	-- function 15
	if not self._resolution_modified then
		self._resolution_modified = RESOLUTION_LOOKUP.modified
	end

	if not self._scale_modified then
		local num = UISettings.hud_scale * 0.01

		self._scale_modified = self._hud_scale_multiplier ~= num
		self._hud_scale_multiplier = num
	end
end

IngameHud._apply_hud_scale = function (self)
	-- function 16
	self:_update_hud_scale()

	local _scale_modified = self._scale_modified
	local _resolution_modified = self._resolution_modified
	local flag = _scale_modified or _resolution_modified
	local _hud_scale_multiplier = self._hud_scale_multiplier

	UPDATE_RESOLUTION_LOOKUP(flag, _hud_scale_multiplier)
end

IngameHud._abort_hud_scale = function (self)
	-- function 17
	local _scale_modified = self._scale_modified
	local _resolution_modified = self._resolution_modified
	local flag = _scale_modified or _resolution_modified

	UPDATE_RESOLUTION_LOOKUP(flag)
end

IngameHud.update = function (self, arg_18_1, arg_18_2)
	-- function 18
	self:_reset_hud_frame_variables()
	self:_update_components_visibility()

	local _player = self._player
	local _currently_visible_components = self._currently_visible_components
	local _components_array = self._components_array
	local use_custom_hud_scale = UISettings.use_custom_hud_scale
	local flag = false
	local modified = RESOLUTION_LOOKUP.modified

	for i = 1, #_components_array do
		local var_18_6 = _components_array[i]
		local name = var_18_6.name

		if not use_custom_hud_scale and flag or not self._components_hud_scale_lookup[name] then
			flag = true

			self:_apply_hud_scale()
		end

		if not modified and not var_18_6.resolution_modified then
			var_18_6:resolution_modified()
		end

		if not var_18_6.update and not _currently_visible_components[name] then
			var_18_6:update(arg_18_1, arg_18_2, _player)
		end
	end

	self:_update_clean_ui(arg_18_1, arg_18_2)

	if not flag then
		self:_abort_hud_scale()
	end

	HudCustomizer.reset_button(self._ingame_ui_context.ui_renderer)
end

IngameHud.post_update = function (self, arg_19_1, arg_19_2)
	-- function 19
	self:_reset_hud_frame_variables()
	self:_update_components_post_visibility()

	local _player = self._player
	local _currently_visible_components = self._currently_visible_components
	local _components_array = self._components_array
	local use_custom_hud_scale = UISettings.use_custom_hud_scale
	local flag = false

	for i = 1, #_components_array do
		local var_19_5 = _components_array[i]
		local name = var_19_5.name

		if not use_custom_hud_scale and flag or not self._components_hud_scale_lookup[name] then
			flag = true

			self:_apply_hud_scale()
		end

		if not var_19_5.post_update and not _currently_visible_components[name] then
			var_19_5:post_update(arg_19_1, arg_19_2, _player)
		end
	end

	if not flag then
		self:_abort_hud_scale()
	end

	self._scale_modified = false
	self._resolution_modified = false
end

IngameHud.destroy = function (self)
	-- function 20
	Managers.state.event:unregister("player_party_changed", self)

	local _components_array = self._components_array

	for i, v in ipairs(_components_array) do
		if not v.destroy then
			v:destroy()
		end
	end

	self._components = nil
	self._components_array = nil
end

IngameHud.parent = function (self)
	-- function 21
	return self._parent
end

IngameHud.input_service = function (arg_22_0)
	-- function 22
	return false
end

local function fn(self)
	-- function 23
	local flag = not self and self.player_unit

	if not ALIVE[flag] then
		return true
	end

	return ScriptUnit.extension(flag, "status_system"):is_ready_for_assisted_respawn()
end

IngameHud.is_in_inn = function (self)
	-- function 24
	return self._ingame_ui_context.is_in_inn
end

IngameHud._reset_hud_frame_variables = function (self)
	-- function 25
	self._crosshair_position_x = false
	self._crosshair_position_y = false
	self._is_own_player_dead = fn(self._player)
end

IngameHud.is_own_player_dead = function (self)
	-- function 26
	return self._is_own_player_dead
end

IngameHud.get_crosshair_position = function (self)
	-- function 27
	if not (not self._crosshair_position_x and self._crosshair_position_y) then
		local inv_scale = RESOLUTION_LOOKUP.inv_scale
		local num = RESOLUTION_LOOKUP.res_w * 0.5 * inv_scale
		local num_2 = RESOLUTION_LOOKUP.res_h * 0.5 * inv_scale
		local _player = self._player
		local flag = not _player and _player.player_unit

		if not ALIVE[flag] then
			local has_extension = ScriptUnit.has_extension(flag, "eyetracking_system")

			if not has_extension and not has_extension:get_is_feature_enabled("tobii_extended_view") then
				local get_forward_rayhit = has_extension:get_forward_rayhit()

				if not get_forward_rayhit then
					local viewport_name = _player.viewport_name
					local viewport_world_name = _player.viewport_world_name
					local world = Managers.world:world(viewport_world_name)
					local viewport = ScriptWorld.viewport(world, viewport_name)
					local camera = ScriptViewport.camera(viewport)
					local world_to_screen = Camera.world_to_screen(camera, get_forward_rayhit)

					num = world_to_screen.x * inv_scale
					num_2 = world_to_screen.y * inv_scale
				end
			end
		end

		self._crosshair_position_x = num
		self._crosshair_position_y = num_2
	end

	return self._crosshair_position_x, self._crosshair_position_y
end

IngameHud.enable_clean_ui = function (self, arg_28_1)
	-- function 28
	self._tobii_clean_ui_is_enabled = arg_28_1
end

IngameHud._update_clean_ui = function (self, arg_29_1, arg_29_2)
	-- function 29
	if not self._clean_ui then
		return
	end

	local _had_tobii = self._had_tobii

	_had_tobii = _had_tobii or false

	local var_29_1 = rawget(_G, "Tobii")

	var_29_1 = not var_29_1 and Tobii.get_is_connected()

	if _had_tobii ~= var_29_1 then
		UICleanUI.update(self._clean_ui, arg_29_1)
	end

	self._had_tobii = var_29_1

	if not var_29_1 then
		return
	end

	if self._tobii_clean_ui_was_enabled ~= self._tobii_clean_ui_is_enabled then
		UICleanUI.update(self._clean_ui, arg_29_1)
	end

	self._tobii_clean_ui_was_enabled = self._tobii_clean_ui_is_enabled

	if not self._tobii_clean_ui_is_enabled then
		return
	end

	UICleanUI.update(self._clean_ui, arg_29_1)
end
