-- chunkname: @scripts/imgui/imgui_weapon_debug.lua

ImguiWeaponDebug = class(ImguiWeaponDebug)

local flag = true
local num = 5
local str = "arial"
local str_2 = "materials/fonts/" .. str

local function fn(arg_1_0, arg_1_1, arg_1_2, arg_1_3, arg_1_4)
	-- function 1
	local var_1_0 = Vector3(0, 2, 0)
	local num = arg_1_2 * 0.07
	local num_2 = Vector3(num, -num, 0) + var_1_0

	Gui.text(arg_1_0, arg_1_1, str_2, arg_1_2, str, arg_1_3 + num_2, Color(255, 0, 0, 0))
	Gui.text(arg_1_0, arg_1_1, str_2, arg_1_2, str, arg_1_3 + var_1_0, arg_1_4)
end

ImguiWeaponDebug.init = function (self)
	-- function 2
	self._draw_hit_box = false
	self._draw_chain_action_data = true
	self._display_current_action = true
	self._action_list = {}
	self._sub_action_list = {}
	self._selected_action = 1
	self._selected_sub_action = 1
	self._unit_names = {}
	self._units = {}
	self._selected_unit = -1
	self._weapon_extensions = {}
	self._selected_weapon_extenstion_name = ""
	self._current_unit = nil
	self._weapon_unit_left = nil
	self._weapon_unit_right = nil
	self._current_weapon_extension = nil
	self._current_inventory_extension = nil
	self._previous_wield_slot = ""
	self._current_actions = nil
	self._damage_power_level = 200
	self._damage_hit_zone_id = 1
	self._damage_difficulty_id = 1
	self._hit_zone_names = {
		"head",
		"neck",
		"torso",
		"left_arm",
		"right_arm",
		"left_leg",
		"right_leg",
		"full"
	}
	self._difficulties = table.clone(Difficulties)
	self._breed_table = {
		Chaos = CHAOS,
		Skaven = SKAVEN,
		Beastmen = BEASTMEN,
		Elites = ELITES,
		VS = PlayerBreeds
	}
	self._combat_critical = false
	self._combat_power_boost = false
	self._combat_use_current_power_level = true
	self._combat_pop_settings = false
	self._combat_backstab_multiplier = 1
	self._combat_stagger_level = 0
	self._combat_hit_actions = {}
	self._combat_push_actions = {}
	self._combat_current_weapon = nil
	self._combat_current_weapon_name = nil
	self._attack_armor_modifiers = {}
	self._armor_modifiers_charge_value = {}

	self:_refresh_unit_list()
end

ImguiWeaponDebug.update = function (self)
	-- function 3
	if not flag then
		self:init()

		flag = false
	end

	local flag_2 = false

	if not self._current_inventory_extension then
		local get_wielded_slot_name = self._current_inventory_extension:get_wielded_slot_name()

		if self._previous_wield_slot ~= get_wielded_slot_name then
			self._previous_wield_slot = get_wielded_slot_name
			flag_2 = true
		end
	end

	if not self._current_unit and Unit.alive(self._current_unit) and not self._weapon_unit_left or Unit.alive(self._weapon_unit_left) and (not self._weapon_unit_right and Unit.alive(self._weapon_unit_right) and self._weapon_unit_left ~= nil or self._weapon_unit_right ~= nil and not flag_2) then
		self._current_unit = nil
		self._current_weapon_extension = nil

		self:_refresh_unit_list()
	end

	local _current_unit = self._current_unit
	local _get_current_weapon = self:_get_current_weapon()

	if not _current_unit and not _get_current_weapon and not self._current_actions then
		local _get_current_action = self:_get_current_action()

		if not _get_current_action then
			local num

			if not self._display_current_action then
				num = _get_current_weapon.weapon_system.t - _get_current_weapon.action_time_started

				if not num then
					-- Nothing
				end
			end

			num = 0

			::label_3_0::

			if not self._draw_chain_action_data and not _get_current_action then
				self:debug_draw_chain_data(num, _get_current_action, _current_unit, _get_current_weapon)
			end
		end
	end
end

ImguiWeaponDebug.is_persistent = function (self)
	-- function 4
	local _draw_chain_action_data = self._draw_chain_action_data

	_draw_chain_action_data = _draw_chain_action_data or self._draw_hit_box

	return _draw_chain_action_data
end

ImguiWeaponDebug.draw = function (self)
	-- function 5
	local begin_window = Imgui.begin_window("Weapon Debug", "menu_bar")

	if not Imgui.begin_menu_bar() then
		if not Imgui.begin_menu("Run Test") then
			if not Imgui.menu_item("Verify Crit Damage") then
				self:_verify_crits()
			end

			if not Imgui.menu_item("Dump Weapon Performace") then
				self:_dump_weapon_performance()
			end

			if not Imgui.menu_item("Check Missing or Unused Actions") then
				self:_check_missing_unused_actions()
			end

			Imgui.end_menu()
		end

		Imgui.end_menu_bar()
	end

	local combo = Imgui.combo("Unit", self._selected_unit, self._unit_names)

	if combo ~= self._selected_unit then
		self._selected_unit = combo

		self:_initialize_unit(self._units[combo])
	end

	Imgui.same_line()

	if not Imgui.button("Refresh") then
		self:_refresh_unit_list()
	end

	if not (not script_data and script_data.debug_weapons == nil) then
		script_data.debug_weapons = Imgui.checkbox("Draw Hit Box", script_data.debug_weapons)

		Imgui.same_line()
	end

	self._draw_chain_action_data = Imgui.checkbox("Draw Action Chain", self._draw_chain_action_data)

	Imgui.same_line()

	self._display_current_action = Imgui.checkbox("Use Current Action", self._display_current_action)

	if not self._display_current_action then
		self._selected_action = Imgui.combo("Action", self._selected_action, self._action_list)

		local flag = not (self._selected_action > 0) or self._action_list[self._selected_action]
		local var_5_3

		if not flag then
			var_5_3 = self._sub_action_list[flag]

			if not var_5_3 then
				-- Nothing
			end
		end

		var_5_3 = {}

		::label_5_0::

		self._selected_sub_action = Imgui.combo("Sub Action", self._selected_sub_action, var_5_3)
	end

	local flag_2 = true

	for k, v in pairs(self._weapon_extensions) do
		if not flag_2 then
			Imgui.same_line()
		end

		if k == "any" then
			v = nil
		end

		if not Imgui.radio_button(k, v == self._current_weapon_extension) then
			self._current_weapon_extension = v
			self._selected_weapon_extenstion_name = k
		end

		flag_2 = false
	end

	self:_draw_basic_info()
	self:_draw_damage_info()
	Imgui.end_window()

	return begin_window
end

ImguiWeaponDebug._refresh_unit_list = function (self)
	-- function 6
	self._unit_names = {}
	self._units = {}
	self._selected_unit = -1

	table.insert(self._unit_names, "none")
	table.insert(self._units, false)

	local player = Managers.player

	if not player then
		local human_and_bot_players = player:human_and_bot_players()

		for k, v in pairs(human_and_bot_players) do
			if not v then
				local profile_display_name = v:profile_display_name()

				table.insert(self._unit_names, profile_display_name)
				table.insert(self._units, v.player_unit)

				if not v.local_player then
					self._selected_unit = #self._unit_names

					self:_initialize_unit(v.player_unit)
				end
			end
		end
	end
end

ImguiWeaponDebug._initialize_unit = function (self, arg_7_1)
	-- function 7
	self._current_unit = arg_7_1
	self._weapon_unit_left = nil
	self._weapon_unit_right = nil
	self._weapon_extensions = {}
	self._current_weapon_extension = nil
	self._current_inventory_extension = nil
	self._selected_weapon_extenstion_name = "any"
	self._action_list = {}
	self._sub_action_list = {}
	self._current_actions = {}
	self._combat_hit_actions = {}
	self._combat_push_actions = {}
	self._combat_current_weapon = nil
	self._combat_current_weapon_name = nil
	self._attack_armor_modifiers = {}
	self._armor_modifiers_charge_value = {}

	if not arg_7_1 then
		local has_extension = ScriptUnit.has_extension(arg_7_1, "inventory_system")

		self._current_inventory_extension = has_extension

		local get_all_weapon_unit, var_7_2 = has_extension:get_all_weapon_unit()

		self._weapon_unit_left = get_all_weapon_unit
		self._weapon_unit_right = var_7_2

		local alive = Unit.alive(get_all_weapon_unit)

		alive = not alive and ScriptUnit.extension(get_all_weapon_unit, "weapon_system")

		local alive_2 = Unit.alive(var_7_2)

		alive_2 = not alive_2 and ScriptUnit.extension(var_7_2, "weapon_system")
		self._weapon_extensions.left = alive
		self._weapon_extensions.right = alive_2
		self._weapon_extensions.any = alive

		local flag = alive or alive_2

		if not flag then
			local var_7_6 = ItemMasterList[flag.item_name]
			local get_weapon_template = WeaponUtils.get_weapon_template(var_7_6.template)

			get_weapon_template = get_weapon_template or WeaponUtils.get_weapon_template(var_7_6.temporary_template)

			local tbl = {
				0,
				0,
				0,
				0,
				0,
				0
			}
			local num = 0
			local tbl_2 = {}

			if not get_weapon_template then
				local actions = get_weapon_template.actions

				self._current_actions = actions
				self._combat_current_weapon = var_7_6
				self._combat_current_weapon_name = flag.item_name

				for k, v in pairs(actions) do
					table.insert(self._action_list, k)

					if not self._sub_action_list[k] then
						self._sub_action_list[k] = {}
					end

					local var_7_12 = self._sub_action_list[k]

					for k_2, v_2 in pairs(v) do
						table.insert(var_7_12, k_2)

						local _get_damage_profile_for_action, var_7_14 = self:_get_damage_profile_for_action(v_2)

						if _get_damage_profile_for_action or not var_7_14 then
							self._combat_hit_actions[k_2] = v_2

							if not _get_damage_profile_for_action then
								local str = k_2 .. "_L"
								local var_7_16 = tbl_2[str]

								var_7_16 = var_7_16 or {
									count = 0,
									values = {}
								}

								local get_damage_profile_performance_scores = ActionUtils.get_damage_profile_performance_scores(_get_damage_profile_for_action)

								for i4 = 1, #get_damage_profile_performance_scores do
									local var_7_18 = tbl[i4]

									var_7_18 = var_7_18 or 0
									tbl[i4] = var_7_18 + get_damage_profile_performance_scores[i4]

									local values = var_7_16.values
									local var_7_20 = var_7_16.values[i4]

									var_7_20 = var_7_20 or 0
									values[i4] = var_7_20 + get_damage_profile_performance_scores[i4]
								end

								num = num + 1
								var_7_16.count = var_7_16.count + 1
								tbl_2[str] = var_7_16
							end

							if not var_7_14 then
								local str_2 = k_2 .. "_R"
								local var_7_22 = tbl_2[str_2]

								var_7_22 = var_7_22 or {
									count = 0,
									values = {}
								}

								local get_damage_profile_performance_scores_2 = ActionUtils.get_damage_profile_performance_scores(var_7_14)

								for i5 = 1, #get_damage_profile_performance_scores_2 do
									local var_7_24 = tbl[i5]

									var_7_24 = var_7_24 or 0
									tbl[i5] = var_7_24 + get_damage_profile_performance_scores_2[i5]

									local values_2 = var_7_22.values
									local var_7_26 = var_7_22.values[i5]

									var_7_26 = var_7_26 or 0
									values_2[i5] = var_7_26 + get_damage_profile_performance_scores_2[i5]
								end

								num = num + 1
								var_7_22.count = var_7_22.count + 1
								tbl_2[str_2] = var_7_22
							end
						end

						local get_push_damage_profile, var_7_28 = ActionUtils.get_push_damage_profile(v_2)

						if get_push_damage_profile or not var_7_28 then
							self._combat_push_actions[k_2] = {
								inner = get_push_damage_profile,
								outer = var_7_28
							}
						end
					end

					table.sort(var_7_12)
				end
			end

			table.sort(self._action_list)

			for i6 = 1, #tbl do
				local flag_2

				flag_2 = num ~= 0 or not 0 or tbl[i6] / num
				tbl[i6] = flag_2
			end

			self._attack_armor_modifiers = tbl

			for k_3, v_3 in pairs(tbl_2) do
				for i9 = 1, #v_3.values do
					local values_3 = v_3.values
					local flag_3

					flag_3 = v_3.count ~= 0 or not 0 or v_3.values[i9] / v_3.count
					values_3[i9] = flag_3
				end

				self._armor_modifiers_charge_value[k_3] = v_3.values
			end
		end
	end
end

ImguiWeaponDebug._draw_basic_info = function (self)
	-- function 8
	local _combat_current_weapon = self._combat_current_weapon
	local _combat_current_weapon_name = self._combat_current_weapon_name

	_combat_current_weapon_name = _combat_current_weapon_name or "-"

	if not _combat_current_weapon then
		Imgui.separator()

		if not Imgui.tree_node("Basic Information") then
			Imgui.text(string.format("Item Name:     %s", _combat_current_weapon_name))
			Imgui.text(string.format("Template Name: %s", _combat_current_weapon.template))
			Imgui.text(string.format("Left Hand:     %s", _combat_current_weapon.left_hand_unit))
			Imgui.text(string.format("Right Hand:    %s", _combat_current_weapon.right_hand_unit))
			Imgui.separator()
			Imgui.columns(3, true)
			Imgui.text("Damage Profiles")
			Imgui.next_column()
			Imgui.text("left")
			Imgui.next_column()
			Imgui.text("right")
			Imgui.next_column()
			Imgui.separator()

			local _combat_hit_actions = self._combat_hit_actions

			for k, v in pairs(_combat_hit_actions) do
				local flag = not v and v.weapon_action_hand
				local get_damage_profile_name, var_8_5 = ActionUtils.get_damage_profile_name(v, flag)

				Imgui.text(k)
				Imgui.next_column()
				Imgui.text(tostring(get_damage_profile_name))
				Imgui.next_column()
				Imgui.text(tostring(var_8_5))
				Imgui.next_column()
			end

			Imgui.separator()
			Imgui.columns(7, true)
			Imgui.text("category\\armor type")

			for k_2 = 1, 6 do
				Imgui.next_column()
				Imgui.text(tostring(k_2))
			end

			Imgui.separator()

			for k_3, v_2 in pairs(self._armor_modifiers_charge_value) do
				Imgui.next_column()
				Imgui.text(k_3)

				for i5 = 1, 6 do
					Imgui.next_column()

					local text = Imgui.text
					local format = string.format
					local str = "%.2f"
					local var_8_9 = v_2[i5]

					var_8_9 = var_8_9 or 0

					text(format(str, var_8_9))
				end
			end

			Imgui.next_column()
			Imgui.text("total average")

			for i6 = 1, 6 do
				Imgui.next_column()

				local text_2 = Imgui.text
				local format_2 = string.format
				local str_2 = "%.2f"
				local var_8_13 = self._attack_armor_modifiers[i6]

				var_8_13 = var_8_13 or 0

				text_2(format_2(str_2, var_8_13))
			end

			Imgui.columns(1)
			Imgui.tree_pop()
		end
	end
end

ImguiWeaponDebug._draw_damage_info = function (self)
	-- function 9
	Imgui.separator()
	Imgui.text("Damage Information")

	self._combat_pop_settings = Imgui.checkbox("Pop Combat Settings", self._combat_pop_settings)

	if not self._combat_pop_settings then
		Imgui.begin_window("Combat Settings (Weapon Debug)")
		self:_update_combat_settings()
		Imgui.end_window()
	else
		self:_update_combat_settings()
	end

	local var_9_0 = self._difficulties[self._damage_difficulty_id]
	local var_9_1 = self._hit_zone_names[self._damage_hit_zone_id]

	for k, v in pairs(self._breed_table) do
		if not var_9_0 and not var_9_1 and not Imgui.tree_node(k) then
			Imgui.separator()
			self:_draw_faction_combat_info(v, var_9_0, var_9_1, self._damage_power_level, self._combat_stagger_level, self._combat_critical, self._combat_backstab_multiplier, self._combat_power_boost)
			Imgui.tree_pop()
		end
	end
end

ImguiWeaponDebug._update_combat_settings = function (self)
	-- function 10
	self._combat_use_current_power_level = Imgui.checkbox("Use Current Power Level", self._combat_use_current_power_level)

	if not self._combat_use_current_power_level then
		local _current_unit = self._current_unit

		if not _current_unit then
			-- Nothing
		end

		::label_10_0::

		local alive = Unit.alive(_current_unit)

		alive = not alive and ScriptUnit.extension(_current_unit, "career_system")

		do
			local get_career_power_level
		end

		::label_10_1::

		if not alive then
			get_career_power_level = alive:get_career_power_level()

			if not get_career_power_level then
				-- Nothing
			end
		end

		get_career_power_level = num

		::label_10_2::

		self._damage_power_level = get_career_power_level
	end

	self._damage_power_level = math.max(Imgui.input_float("Power Level", self._damage_power_level), num)
	self._damage_difficulty_id = Imgui.combo("Difficulty", self._damage_difficulty_id, self._difficulties)
	self._damage_hit_zone_id = Imgui.combo("Hit Zone", self._damage_hit_zone_id, self._hit_zone_names)
	self._combat_backstab_multiplier = Imgui.slider_float("Backstab Mult", self._combat_backstab_multiplier, 1, 2)
	self._combat_stagger_level = math.floor(Imgui.slider_float("Stagger Level", self._combat_stagger_level, 0, 3))
	self._combat_critical = Imgui.checkbox("Critical", self._combat_critical)

	Imgui.same_line()

	self._combat_power_boost = Imgui.checkbox("Power Boost", self._combat_power_boost)

	for k, v in pairs(POWER_LEVEL_DIFF_RATIO) do
		local var_10_3 = self._difficulties[self._damage_difficulty_id]
		local scale_power_levels = ActionUtils.scale_power_levels(self._damage_power_level, k, self._current_unit, var_10_3)

		Imgui.text(string.format("Scaled - %-8s: %s", k, scale_power_levels))
	end
end

ImguiWeaponDebug._draw_faction_combat_info = function (self, arg_11_1, arg_11_2, arg_11_3, arg_11_4, arg_11_5, arg_11_6, arg_11_7, arg_11_8)
	-- function 11
	local num = 1
	local num_2 = 8
	local format = string.format("%7s%6s", "%2d", "")
	local _combat_hit_actions = self._combat_hit_actions
	local _combat_push_actions = self._combat_push_actions
	local tbl = {}
	local tbl_2 = {}

	for k, v in pairs(arg_11_1) do
		Imgui.separator()

		local var_11_7 = Breeds[k]

		var_11_7 = var_11_7 or PlayerBreeds[k]

		local get_target_armor, var_11_9, var_11_10, var_11_11 = ActionUtils.get_target_armor(arg_11_3, var_11_7, 1)
		local format_2 = string.format("Breed: %s (Armor: %d / Primary Armor: %d)", k, get_target_armor or 0, var_11_10 or 0)

		if not Imgui.tree_node(format_2) then
			local get_breed_health = self:get_breed_health(arg_11_2, var_11_7)
			local get_breed_stagger, var_11_15, var_11_16 = self:get_breed_stagger(arg_11_2, var_11_7)

			Imgui.text(string.format("Health: %.2f", get_breed_health))
			Imgui.text(string.format("Stagger Thresholds: %.2f / %.2f / %.2f", get_breed_stagger, var_11_15, var_11_16))
			Imgui.separator()
			Imgui.columns(9, true)
			Imgui.text("Hit Index")

			for k_2 = num, num_2 do
				Imgui.next_column()
				Imgui.text(k_2)
			end

			Imgui.separator()

			for k_3, v_2 in pairs(_combat_hit_actions) do
				table.clear(tbl)
				table.clear(tbl_2)

				for i5 = num, num_2 do
					local get_damage = self:get_damage(v_2, arg_11_4, arg_11_2, arg_11_3, var_11_7, i5, arg_11_5, arg_11_6, arg_11_7, arg_11_8)
					local ceil

					if get_damage > 0 then
						ceil = math.ceil(get_breed_health / get_damage)

						if not ceil then
							-- Nothing
						end
					end

					ceil = 0

					::label_11_0::

					table.insert(tbl, get_damage)
					table.insert(tbl_2, ceil)
				end

				Imgui.next_column()
				Imgui.text(k_3)

				for i6 = 1, #tbl do
					Imgui.next_column()
					Imgui.text(string.format("%6.2f - %-3d", tbl[i6], tbl_2[i6]))
				end
			end

			Imgui.columns(1)
			Imgui.dummy(10, 10)
			Imgui.separator()
			Imgui.columns(6, true)
			Imgui.text("Name")
			Imgui.next_column()
			Imgui.text("Type")
			Imgui.next_column()
			Imgui.text("Duration")
			Imgui.next_column()
			Imgui.text("Distance")
			Imgui.next_column()
			Imgui.text("Value")
			Imgui.next_column()
			Imgui.text("Strength")
			Imgui.separator()

			for k_4, v_3 in pairs(_combat_push_actions) do
				Imgui.next_column()
				Imgui.text(k_4 .. " Inner")

				local var_11_19 = DamageProfileTemplates[v_3.inner]
				local get_ai_stagger, var_11_21, var_11_22, var_11_23, var_11_24 = self:get_ai_stagger(var_11_19, arg_11_4, arg_11_2, arg_11_3, var_11_7, 1, arg_11_6, arg_11_8)

				Imgui.next_column()
				Imgui.text(string.format("%.2f", get_ai_stagger))
				Imgui.next_column()
				Imgui.text(string.format("%.2f", var_11_21))
				Imgui.next_column()
				Imgui.text(string.format("%.2f", var_11_22))
				Imgui.next_column()
				Imgui.text(string.format("%.2f", var_11_23))
				Imgui.next_column()
				Imgui.text(string.format("%.2f", var_11_24))

				local var_11_25 = DamageProfileTemplates[v_3.inner]
				local get_ai_stagger_2, var_11_27, var_11_28, var_11_29, var_11_30 = self:get_ai_stagger(var_11_25, arg_11_4, arg_11_2, arg_11_3, var_11_7, 1, arg_11_6, arg_11_8)

				Imgui.next_column()
				Imgui.text(k_4 .. " Outer")
				Imgui.next_column()
				Imgui.text(string.format("%.2f", get_ai_stagger_2))
				Imgui.next_column()
				Imgui.text(string.format("%.2f", var_11_27))
				Imgui.next_column()
				Imgui.text(string.format("%.2f", var_11_28))
				Imgui.next_column()
				Imgui.text(string.format("%.2f", var_11_29))
				Imgui.next_column()
				Imgui.text(string.format("%.2f", var_11_30))
			end

			Imgui.columns(1)
			Imgui.tree_pop()
		end
	end
end

ImguiWeaponDebug._get_current_weapon = function (self)
	-- function 12
	if not self._display_current_action then
		for k, v in pairs(self._weapon_extensions) do
			if not v then
				return v
			end
		end
	end

	if not self._current_weapon_extension then
		return self._current_weapon_extension
	else
		for k_2, v_2 in pairs(self._weapon_extensions) do
			if not v_2 and not v_2.current_action_settings then
				return v_2
			end
		end
	end

	return nil
end

ImguiWeaponDebug._get_current_action = function (self)
	-- function 13
	if not self._display_current_action then
		local flag = not (self._selected_action >= 0) or self._action_list[self._selected_action]
		local var_13_1

		if not flag then
			var_13_1 = self._sub_action_list[flag]

			if not var_13_1 then
				-- Nothing
			end
		end

		var_13_1 = {}

		::label_13_0::

		local flag_2 = not (self._selected_sub_action >= 0) or var_13_1[self._selected_sub_action]
		local flag_3 = not flag and self._current_actions[flag]

		return not flag_3 and flag_3[flag_2]
	end

	if not self._current_weapon_extension then
		return self._current_weapon_extension.current_action_settings
	else
		for k, v in pairs(self._weapon_extensions) do
			if not v and not v.current_action_settings then
				return v.current_action_settings
			end
		end
	end

	return nil
end

ImguiWeaponDebug.debug_draw_chain_data = function (arg_14_0, arg_14_1, arg_14_2, arg_14_3, arg_14_4)
	-- function 14
	local gui = Debug.gui
	local num = 150
	local num_2 = 20
	local num_3 = num_2 + 5
	local num_4 = 5
	local num_5 = num * num_4
	local num_6 = num_3 * 7 + 20
	local num_7 = 150
	local num_8 = 0.25
	local res_w = RESOLUTION_LOOKUP.res_w
	local res_h = RESOLUTION_LOOKUP.res_h
	local num_9 = res_w / 2 - (num_5 - num_7) / 2
	local num_10 = res_h * 0.25 + num_6 / 2
	local num_11 = 12
	local num_12 = 16
	local var_14_15 = Color(255, 255, 255, 255)
	local get_action_time_scale = ActionUtils.get_action_time_scale(arg_14_3, arg_14_2)
	local num_13 = arg_14_2.total_time / ActionUtils.get_action_time_scale(arg_14_3, arg_14_2)
	local get_scaled_min_hold_time = arg_14_4:get_scaled_min_hold_time(arg_14_2)
	local min = math.min(num_13, num_4)
	local min_2 = math.min(arg_14_1, min)
	local get_color_with_alpha = Colors.get_color_with_alpha("black", 150)
	local var_14_22 = Vector3(num_9 - num_7, num_10 - num_6, 0)
	local var_14_23 = Vector3(num_5 + num_7, num_6, 0)

	Gui.rect(gui, var_14_22, var_14_23, get_color_with_alpha)
	ScriptGUI.hud_line(gui, Vector3(num_9, num_10, 1), Vector3(num_9, num_10 - num_6, 1), 3, 2, Color(255, 255, 255, 255))

	local num_14 = num_9 + get_scaled_min_hold_time * num

	ScriptGUI.hud_line(gui, Vector3(num_14, num_10, 0.5), Vector3(num_14, num_10 - num_6, 0.5), 3, 2, Color(255, 255, 0, 0))
	fn(gui, string.format("%.2f", get_scaled_min_hold_time), num_11, Vector3(num_14 + 5, num_10, 0.5), Color(255, 255, 0, 0))

	local num_15 = num_9 + num_4 * num

	ScriptGUI.hud_line(gui, Vector3(num_15, num_10, 0.5), Vector3(num_15, num_10 - num_6, 0.5), 3, 2, Color(255, 255, 255, 255))

	local num_16 = num_9 + min * num

	ScriptGUI.hud_line(gui, Vector3(num_16, num_10, 1), Vector3(num_16, num_10 - num_6, 1), 3, 2, Color(255, 255, 0, 0))
	fn(gui, string.format("%.2f", num_13), num_11, Vector3(num_16 + 5, num_10, 0.5), Color(255, 255, 0, 0))

	if not arg_14_2.damage_window_start and not arg_14_2.damage_window_end then
		local num_17 = arg_14_2.damage_window_start / get_action_time_scale
		local damage_window_end = arg_14_2.damage_window_end

		if not damage_window_end then
			damage_window_end = arg_14_2.total_time
			damage_window_end = damage_window_end or math.huge
		end

		local num_18 = damage_window_end / get_action_time_scale
		local num_19 = num_9 + num_17 * num
		local num_20 = (num_18 - num_17) * num

		Gui.rect(gui, Vector3(num_19, num_10 - num_6, 0), Vector3(num_20, num_6, 0), Color(128, 255, 0, 0))
	end

	local floor = math.floor(min / num_8)

	for i = 0, floor do
		local num_21 = num_9 + i * num_8 * num

		ScriptGUI.hud_line(gui, Vector3(num_21, num_10, 0.1), Vector3(num_21, num_10 - num_6, 0.1), 3, 2, Color(50, 255, 255, 255))
		fn(gui, string.format("%.2f", i * num_8), num_11, Vector3(num_21, num_10 - num_6, 0.1), var_14_15)
	end

	local lookup_data = arg_14_2.lookup_data

	if not lookup_data then
		fn(gui, lookup_data.action_name, num_11, Vector3(num_9 - num_7, num_10 + 20, 0.1), var_14_15)
		fn(gui, lookup_data.sub_action_name, num_11, Vector3(num_9 - num_7, num_10 + 5, 0.1), var_14_15)
	end

	local damage_profile = arg_14_2.damage_profile
	local flag = not damage_profile and DamageProfileTemplates[damage_profile]

	if not flag then
		local num_22 = num_9 + num_5 + 10
		local num_23 = num_10 - 15
		local num_24 = 15
		local default_target = flag.default_target
		local flag_2 = not default_target and default_target.boost_curve_type

		fn(gui, string.format("[damage profile] %s", damage_profile), num_11, Vector3(num_22, num_23, 0.1), var_14_15)

		if not default_target then
			fn(gui, string.format("[default] %s", tostring(flag_2)), num_11, Vector3(num_22, num_23 - num_24, 0.1), var_14_15)
		end

		local targets = flag.targets

		for j = 1, #targets do
			local var_14_43 = targets[j]
			local flag_3 = not var_14_43 and var_14_43.boost_curve_type

			fn(gui, string.format("[%d] %s", j, tostring(flag_3)), num_11, Vector3(num_22, num_23 - num_24 * (j + 1), 0.1), var_14_15)
		end
	end

	local allowed_chain_actions = arg_14_2.allowed_chain_actions

	for k = 1, #allowed_chain_actions do
		local var_14_46 = allowed_chain_actions[k]
		local str = tostring(var_14_46.action) .. "/" .. tostring(var_14_46.sub_action)
		local flag_4

		flag_4 = not var_14_46.auto_chain and "auto_chain" and tostring(var_14_46.input)

		if not var_14_46.hold_allowed then
			flag_4 = flag_4 .. "(hold)"
		end

		local num_25 = var_14_46.start_time / get_action_time_scale
		local num_26

		if not var_14_46.end_time then
			num_26 = var_14_46.end_time / get_action_time_scale

			if not num_26 then
				-- Nothing
			end
		end

		num_26 = math.huge

		do
			local get
		end

		::label_14_0::

		if min_2 < num_25 then
			get = Colors.get("orange")

			if not get then
				-- Nothing
			end
		end

		if num_26 <= min_2 then
			get = Colors.get("red")

			if not get then
				-- Nothing
			end
		end

		get = Colors.get("green")

		::label_14_1::

		local var_14_52 = k
		local num_27 = num_9 + num_25 * num
		local num_28 = num_10 - var_14_52 * num_3
		local var_14_55 = Vector3(num_27, num_28, 0.1)
		local num_29 = (math.min(num_26, num_4) - num_25) * num
		local var_14_57 = Vector3(num_29, num_2, 0)

		Gui.rect(gui, var_14_55, var_14_57, get)

		local str_2 = str .. string.format(" [%.2f - %.2f]", num_25, num_26)

		fn(gui, str_2, num_12, var_14_55, var_14_15)

		local var_14_59 = Vector3(num_9 - num_7, num_28, 0.1)

		fn(gui, flag_4, num_12, var_14_59, var_14_15)
	end

	local num_30 = num_9 + min_2 * num
	local num_31 = num_10 + 10
	local var_14_62 = num_30
	local num_32 = num_31 - num_6 - 20

	ScriptGUI.hud_line(gui, Vector3(num_30, num_31, 1), Vector3(var_14_62, num_32, 1), 3, 2, Color(255, 255, 255, 255))
	fn(gui, string.format("%.2f", arg_14_1), num_12, Vector3(num_30 + 5, num_31, 1), var_14_15)
end

ImguiWeaponDebug.get_breed_health = function (arg_15_0, arg_15_1, arg_15_2)
	-- function 15
	local num = 0
	local var_15_1 = DifficultySettings[arg_15_1]

	if not var_15_1 and not arg_15_2 then
		local max_health = arg_15_2.max_health
		local rank = var_15_1.rank

		num = not max_health and max_health[rank] and 0
	end

	return num
end

ImguiWeaponDebug.get_breed_stagger = function (arg_16_0, arg_16_1, arg_16_2)
	-- function 16
	local num = 0
	local num_2 = 0
	local num_3 = 0
	local flag = false
	local var_16_4 = DifficultySettings[arg_16_1]

	if not var_16_4 and not arg_16_2 then
		local rank = var_16_4.rank
		local var_16_6

		if not arg_16_2.diff_stagger_resist then
			var_16_6 = arg_16_2.diff_stagger_resist[rank]

			if not var_16_6 then
				-- Nothing
			end
		end

		var_16_6 = arg_16_2.stagger_resistance
		var_16_6 = var_16_6 or 2

		::label_16_0::

		num = not flag and 0 and not arg_16_2.stagger_threshold_light or arg_16_2.stagger_threshold_light * var_16_6 and 0.25 * var_16_6
		num_2 = not arg_16_2.stagger_threshold_medium and arg_16_2.stagger_threshold_medium * var_16_6 and 1 * var_16_6
		num_3 = not arg_16_2.stagger_threshold_heavy and arg_16_2.stagger_threshold_heavy * var_16_6 and 2.5 * var_16_6
	end

	return num, num_2, num_3
end

ImguiWeaponDebug.get_damage = function (self, arg_17_1, arg_17_2, arg_17_3, arg_17_4, arg_17_5, arg_17_6, arg_17_7, arg_17_8, arg_17_9, arg_17_10)
	-- function 17
	local _current_unit = self._current_unit
	local _combat_current_weapon = self._combat_current_weapon

	if not _combat_current_weapon and not _current_unit and not arg_17_1 and not arg_17_5 then
		local weapon_action_hand = arg_17_1.weapon_action_hand

		if not (weapon_action_hand ~= "both" or self._selected_weapon_extenstion_name == "any") then
			weapon_action_hand = self._selected_weapon_extenstion_name
		end

		local get_damage_profile_name, var_17_4 = ActionUtils.get_damage_profile_name(arg_17_1, weapon_action_hand)
		local flag = not get_damage_profile_name and DamageProfileTemplates[get_damage_profile_name]
		local flag_2 = not var_17_4 and DamageProfileTemplates[var_17_4]
		local var_17_7 = DifficultySettings[arg_17_3]

		if not var_17_7 then
			local num = 0
			local num_2 = 0

			if not flag then
				num = self:_calculate_damage(_current_unit, _combat_current_weapon, flag, var_17_7, arg_17_2, arg_17_3, arg_17_4, arg_17_5, arg_17_6, arg_17_7, arg_17_8, arg_17_9, arg_17_10)
			end

			if not flag_2 then
				num_2 = self:_calculate_damage(_current_unit, _combat_current_weapon, flag_2, var_17_7, arg_17_2, arg_17_3, arg_17_4, arg_17_5, arg_17_6, arg_17_7, arg_17_8, arg_17_9, arg_17_10)
			end

			return num + num_2
		end
	end

	return 0
end

ImguiWeaponDebug.get_ai_stagger = function (self, arg_18_1, arg_18_2, arg_18_3, arg_18_4, arg_18_5, arg_18_6, arg_18_7, arg_18_8)
	-- function 18
	local _current_unit = self._current_unit
	local _combat_current_weapon = self._combat_current_weapon

	if not _combat_current_weapon and not _current_unit and not arg_18_1 and not arg_18_5 then
		return self:_calculate_ai_stagger(_current_unit, _combat_current_weapon, arg_18_1, arg_18_2, arg_18_3, arg_18_4, arg_18_5, arg_18_6, arg_18_7, arg_18_8)
	end

	return 0, 0, 0, 0, 0
end

ImguiWeaponDebug._calculate_damage = function (arg_19_0, arg_19_1, arg_19_2, arg_19_3, arg_19_4, arg_19_5, arg_19_6, arg_19_7, arg_19_8, arg_19_9, arg_19_10, arg_19_11, arg_19_12, arg_19_13)
	-- function 19
	local name = arg_19_2.name
	local var_19_1
	local num = 0

	if not arg_19_3.no_stagger_damage_reduction_ranged then
		local num_2 = 1

		arg_19_10 = math.max(num_2, arg_19_10)
	end

	local custom_calculate_damage = DamageUtils.custom_calculate_damage(arg_19_1, name, arg_19_5, arg_19_3, arg_19_9, num, arg_19_11, arg_19_12, arg_19_13, var_19_1, arg_19_8, arg_19_7, arg_19_10, arg_19_6)

	return (DamageUtils.networkify_damage(custom_calculate_damage))
end

ImguiWeaponDebug._calculate_ai_stagger = function (arg_20_0, arg_20_1, arg_20_2, arg_20_3, arg_20_4, arg_20_5, arg_20_6, arg_20_7, arg_20_8, arg_20_9, arg_20_10)
	-- function 20
	local flag = false
	local name = arg_20_2.name
	local num = 0
	local calculate_stagger_player_tooltip, var_20_4, var_20_5, var_20_6, var_20_7 = DamageUtils.calculate_stagger_player_tooltip(arg_20_7, arg_20_1, arg_20_6, arg_20_4, arg_20_9, arg_20_3, arg_20_8, flag, name, arg_20_5, arg_20_10, num)

	return calculate_stagger_player_tooltip, var_20_4, var_20_5, var_20_6, var_20_7
end

ImguiWeaponDebug._get_damage_profile_for_action = function (self, arg_21_1)
	-- function 21
	if not arg_21_1 then
		local weapon_action_hand = arg_21_1.weapon_action_hand

		if not (weapon_action_hand ~= "both" or self._selected_weapon_extenstion_name == "any") then
			weapon_action_hand = self._selected_weapon_extenstion_name
		end

		return ActionUtils.get_damage_profile_name(arg_21_1, weapon_action_hand)
	end

	return nil, nil
end

ImguiWeaponDebug._verify_crits = function (self)
	-- function 22
	print("STARTING TEST: verify_crits")

	local _current_unit = self._current_unit
	local we_1h_axe = ItemMasterList.we_1h_axe
	local str = "normal"
	local var_22_3 = DifficultySettings[str]
	local num = 300
	local num_2 = 1
	local num_3 = 0
	local var_22_7
	local num_4 = 1
	local mirror_array_inplace = table.mirror_array_inplace({
		"tutorial_longbow_charged"
	})
	local mirror_array_inplace_2 = table.mirror_array_inplace({
		"chaos_raider",
		"chaos_raider_tutorial",
		"chaos_dummy_sorcerer",
		"chaos_dummy_exalted_sorcerer_drachenfels",
		"skaven_stormfiend",
		"skaven_stormfiend_demo",
		"skaven_stormfiend_boss"
	})
	local tbl = {
		"head",
		"torso"
	}

	for k, v in pairs(DamageProfileTemplates) do
		if not (not not string.ends_with(k, "_no_damage") or not mirror_array_inplace[k]) then
			for k_2, v_2 in pairs(self._breed_table) do
				for k_3, v_3 in pairs(v_2) do
					if not mirror_array_inplace_2[k_3] then
						local var_22_12 = Breeds[k_3]
						local var_22_13 = tbl[1]
						local flag = false
						local flag_2 = false
						local _calculate_damage = self:_calculate_damage(_current_unit, we_1h_axe, v, var_22_3, num, str, var_22_13, var_22_12, num_2, num_3, flag, var_22_7, flag_2)
						local flag_3 = true
						local flag_4 = false
						local _calculate_damage_2 = self:_calculate_damage(_current_unit, we_1h_axe, v, var_22_3, num, str, var_22_13, var_22_12, num_2, num_3, flag_3, var_22_7, flag_4)
						local flag_5 = false
						local flag_6 = true
						local _calculate_damage_3 = self:_calculate_damage(_current_unit, we_1h_axe, v, var_22_3, num, str, var_22_13, var_22_12, num_2, num_3, flag_5, var_22_7, flag_6)
						local flag_7 = true
						local flag_8 = true
						local _calculate_damage_4 = self:_calculate_damage(_current_unit, we_1h_axe, v, var_22_3, num, str, var_22_13, var_22_12, num_2, num_3, flag_7, var_22_7, flag_8)
						local var_22_26 = tbl[2]
						local flag_9 = false
						local flag_10 = false
						local _calculate_damage_5 = self:_calculate_damage(_current_unit, we_1h_axe, v, var_22_3, num, str, var_22_26, var_22_12, num_2, num_3, flag_9, var_22_7, flag_10)
						local flag_11 = true
						local flag_12 = false
						local _calculate_damage_6 = self:_calculate_damage(_current_unit, we_1h_axe, v, var_22_3, num, str, var_22_26, var_22_12, num_2, num_3, flag_11, var_22_7, flag_12)
						local flag_13 = false
						local flag_14 = true
						local _calculate_damage_7 = self:_calculate_damage(_current_unit, we_1h_axe, v, var_22_3, num, str, var_22_26, var_22_12, num_2, num_3, flag_13, var_22_7, flag_14)
						local flag_15 = true
						local flag_16 = true
						local _calculate_damage_8 = self:_calculate_damage(_current_unit, we_1h_axe, v, var_22_3, num, str, var_22_26, var_22_12, num_2, num_3, flag_15, var_22_7, flag_16)
						local get_target_armor, var_22_40, var_22_41, var_22_42 = ActionUtils.get_target_armor(var_22_26, var_22_12, num_4)

						get_target_armor = get_target_armor or 0
						var_22_41 = var_22_41 or 0

						if _calculate_damage_2 < _calculate_damage then
							print(string.format("%s / %s (%s)(%d/%d) Crit dealt less damage - normal %.2f, crit %.2f", k, k_3, var_22_26, get_target_armor, var_22_41, _calculate_damage, _calculate_damage_2))
						end

						if _calculate_damage_3 < _calculate_damage then
							print(string.format("%s / %s (%s)(%d/%d) Power boosted attack dealt less damage - normal %.2f, power boosted %.2f", k, k_3, var_22_26, get_target_armor, var_22_41, _calculate_damage, _calculate_damage_3))
						end

						if _calculate_damage_4 < _calculate_damage_3 then
							print(string.format("%s / %s (%s)(%d/%d) Power boosted crit attack dealt less damage - power booster %.2f, power boosted crit %.2f", k, k_3, var_22_26, get_target_armor, var_22_41, _calculate_damage_3, _calculate_damage_4))
						end

						if _calculate_damage < _calculate_damage_5 then
							print(string.format("%s / %s (%s)(%d/%d) More dmg on torso than head - NORMAL torso %.2f, head %.2f", k, k_3, var_22_26, get_target_armor, var_22_41, _calculate_damage_5, _calculate_damage))
						end

						if _calculate_damage_2 < _calculate_damage_6 then
							print(string.format("%s / %s (%s)(%d/%d) More dmg on torso than head - CRIT torso %.2f, head %.2f", k, k_3, var_22_26, get_target_armor, var_22_41, _calculate_damage_6, _calculate_damage_2))
						end

						if _calculate_damage_3 < _calculate_damage_7 then
							print(string.format("%s / %s (%s)(%d/%d) More dmg on torso than head - POWER torso %.2f, head %.2f", k, k_3, var_22_26, get_target_armor, var_22_41, _calculate_damage_7, _calculate_damage_3))
						end

						if _calculate_damage_4 < _calculate_damage_8 then
							print(string.format("%s / %s (%s)(%d/%d) More dmg on torso than head - POWER CRIT torso %.2f, head %.2f", k, k_3, var_22_26, get_target_armor, var_22_41, _calculate_damage_8, _calculate_damage_4))
						end
					end
				end
			end
		end
	end

	print("Done!")
end

ImguiWeaponDebug._dump_weapon_performance = function (self)
	-- function 23
	for k in pairs(Weapons) do
		print(k)

		local get_weapon_template = WeaponUtils.get_weapon_template(k)
		local get_used_actions = WeaponUtils.get_used_actions(get_weapon_template)

		for k_2, v in pairs(get_used_actions) do
			local var_23_2 = get_weapon_template.actions[k_2]

			for k_3, v_2 in pairs(v) do
				local get_damage_profile_performance_scores = ActionUtils.get_damage_profile_performance_scores(nil)
				local _get_damage_profile_for_action, var_23_5 = self:_get_damage_profile_for_action(var_23_2[k_3])

				if not var_23_5 then
					local get_damage_profile_performance_scores_2 = ActionUtils.get_damage_profile_performance_scores(var_23_5)

					for i5 = 1, #get_damage_profile_performance_scores do
						get_damage_profile_performance_scores[i5] = get_damage_profile_performance_scores[i5] + get_damage_profile_performance_scores_2[i5]
					end
				end

				if not _get_damage_profile_for_action then
					local get_damage_profile_performance_scores_3 = ActionUtils.get_damage_profile_performance_scores(_get_damage_profile_for_action)

					for i6 = 1, #get_damage_profile_performance_scores do
						get_damage_profile_performance_scores[i6] = get_damage_profile_performance_scores[i6] + get_damage_profile_performance_scores_3[i6]
					end
				end

				local str = ""

				for i7 = 1, #get_damage_profile_performance_scores do
					str = str .. string.format("[%i] %.3f ", i7, get_damage_profile_performance_scores[i7])
				end

				print(string.format("%s.%s - %s", k_2, k_3, str))
			end
		end
	end
end

ImguiWeaponDebug._check_missing_unused_actions = function (arg_24_0)
	-- function 24
	local tbl = {
		weapon_reload = {
			auto_reload_on_empty = true
		},
		action_two = {
			give_item = true
		}
	}

	print("CHECKING FOR MISSING OR UNUSED ACTIONS")

	for k in pairs(Weapons) do
		local get_weapon_template = WeaponUtils.get_weapon_template(weapon_name)
		local get_used_actions, var_24_3 = WeaponUtils.get_used_actions(get_weapon_template)

		for k_2, v in pairs(var_24_3) do
			for k_3, v_2 in pairs(v) do
				print(string.format("Missing referenced action [%s.%s] in template [%s]", k_2, k_3, k))
			end
		end

		for k_4, v_3 in pairs(get_weapon_template.actions) do
			local var_24_4 = get_used_actions[k_4]

			if not var_24_4 then
				print(string.format("Unused action [%s] in template [%s]", k_4, k))
			else
				for k_5, v_4 in pairs(v_3) do
					if not (not tbl[k_4] and tbl[k_4][k_5] and var_24_4[k_5]) then
						print(string.format("Unused sub-action [%s.%s] in template [%s]", k_4, k_5, k))
					end
				end
			end
		end
	end

	print("DONE")
end
