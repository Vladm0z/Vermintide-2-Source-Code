-- chunkname: @scripts/imgui/imgui_weapon_debug.lua

ImguiWeaponDebug = class(ImguiWeaponDebug)

local var_0_0 = true
local var_0_1 = 5
local var_0_2 = "arial"
local var_0_3 = "materials/fonts/" .. var_0_2

local function var_0_4(arg_1_0, arg_1_1, arg_1_2, arg_1_3, arg_1_4)
	local var_1_0 = Vector3(0, 2, 0)
	local var_1_1 = arg_1_2 * 0.07
	local var_1_2 = Vector3(var_1_1, -var_1_1, 0) + var_1_0

	Gui.text(arg_1_0, arg_1_1, var_0_3, arg_1_2, var_0_2, arg_1_3 + var_1_2, Color(255, 0, 0, 0))
	Gui.text(arg_1_0, arg_1_1, var_0_3, arg_1_2, var_0_2, arg_1_3 + var_1_0, arg_1_4)
end

function ImguiWeaponDebug.init(arg_2_0)
	arg_2_0._draw_hit_box = false
	arg_2_0._draw_chain_action_data = true
	arg_2_0._display_current_action = true
	arg_2_0._action_list = {}
	arg_2_0._sub_action_list = {}
	arg_2_0._selected_action = 1
	arg_2_0._selected_sub_action = 1
	arg_2_0._unit_names = {}
	arg_2_0._units = {}
	arg_2_0._selected_unit = -1
	arg_2_0._weapon_extensions = {}
	arg_2_0._selected_weapon_extenstion_name = ""
	arg_2_0._current_unit = nil
	arg_2_0._weapon_unit_left = nil
	arg_2_0._weapon_unit_right = nil
	arg_2_0._current_weapon_extension = nil
	arg_2_0._current_inventory_extension = nil
	arg_2_0._previous_wield_slot = ""
	arg_2_0._current_actions = nil
	arg_2_0._damage_power_level = 200
	arg_2_0._damage_hit_zone_id = 1
	arg_2_0._damage_difficulty_id = 1
	arg_2_0._hit_zone_names = {
		"head",
		"neck",
		"torso",
		"left_arm",
		"right_arm",
		"left_leg",
		"right_leg",
		"full"
	}
	arg_2_0._difficulties = table.clone(Difficulties)
	arg_2_0._breed_table = {
		Chaos = CHAOS,
		Skaven = SKAVEN,
		Beastmen = BEASTMEN,
		Elites = ELITES,
		VS = PlayerBreeds
	}
	arg_2_0._combat_critical = false
	arg_2_0._combat_power_boost = false
	arg_2_0._combat_use_current_power_level = true
	arg_2_0._combat_pop_settings = false
	arg_2_0._combat_backstab_multiplier = 1
	arg_2_0._combat_stagger_level = 0
	arg_2_0._combat_hit_actions = {}
	arg_2_0._combat_push_actions = {}
	arg_2_0._combat_current_weapon = nil
	arg_2_0._combat_current_weapon_name = nil
	arg_2_0._attack_armor_modifiers = {}
	arg_2_0._armor_modifiers_charge_value = {}

	arg_2_0:_refresh_unit_list()
end

function ImguiWeaponDebug.update(arg_3_0)
	if var_0_0 then
		arg_3_0:init()

		var_0_0 = false
	end

	local var_3_0 = false

	if arg_3_0._current_inventory_extension then
		local var_3_1 = arg_3_0._current_inventory_extension:get_wielded_slot_name()

		if arg_3_0._previous_wield_slot ~= var_3_1 then
			arg_3_0._previous_wield_slot = var_3_1
			var_3_0 = true
		end
	end

	if arg_3_0._current_unit and not Unit.alive(arg_3_0._current_unit) or arg_3_0._weapon_unit_left and not Unit.alive(arg_3_0._weapon_unit_left) or arg_3_0._weapon_unit_right and not Unit.alive(arg_3_0._weapon_unit_right) or arg_3_0._weapon_unit_left == nil and arg_3_0._weapon_unit_right == nil or var_3_0 then
		arg_3_0._current_unit = nil
		arg_3_0._current_weapon_extension = nil

		arg_3_0:_refresh_unit_list()
	end

	local var_3_2 = arg_3_0._current_unit
	local var_3_3 = arg_3_0:_get_current_weapon()

	if var_3_2 and var_3_3 and arg_3_0._current_actions then
		local var_3_4 = arg_3_0:_get_current_action()

		if var_3_4 then
			local var_3_5 = arg_3_0._display_current_action and var_3_3.weapon_system.t - var_3_3.action_time_started or 0

			if arg_3_0._draw_chain_action_data and var_3_4 then
				arg_3_0:debug_draw_chain_data(var_3_5, var_3_4, var_3_2, var_3_3)
			end
		end
	end
end

function ImguiWeaponDebug.is_persistent(arg_4_0)
	return arg_4_0._draw_chain_action_data or arg_4_0._draw_hit_box
end

function ImguiWeaponDebug.draw(arg_5_0)
	local var_5_0 = Imgui.begin_window("Weapon Debug", "menu_bar")

	if Imgui.begin_menu_bar() then
		if Imgui.begin_menu("Run Test") then
			if Imgui.menu_item("Verify Crit Damage") then
				arg_5_0:_verify_crits()
			end

			if Imgui.menu_item("Dump Weapon Performace") then
				arg_5_0:_dump_weapon_performance()
			end

			if Imgui.menu_item("Check Missing or Unused Actions") then
				arg_5_0:_check_missing_unused_actions()
			end

			Imgui.end_menu()
		end

		Imgui.end_menu_bar()
	end

	local var_5_1 = Imgui.combo("Unit", arg_5_0._selected_unit, arg_5_0._unit_names)

	if var_5_1 ~= arg_5_0._selected_unit then
		arg_5_0._selected_unit = var_5_1

		arg_5_0:_initialize_unit(arg_5_0._units[var_5_1])
	end

	Imgui.same_line()

	if Imgui.button("Refresh") then
		arg_5_0:_refresh_unit_list()
	end

	if script_data and script_data.debug_weapons ~= nil then
		script_data.debug_weapons = Imgui.checkbox("Draw Hit Box", script_data.debug_weapons)

		Imgui.same_line()
	end

	arg_5_0._draw_chain_action_data = Imgui.checkbox("Draw Action Chain", arg_5_0._draw_chain_action_data)

	Imgui.same_line()

	arg_5_0._display_current_action = Imgui.checkbox("Use Current Action", arg_5_0._display_current_action)

	if not arg_5_0._display_current_action then
		arg_5_0._selected_action = Imgui.combo("Action", arg_5_0._selected_action, arg_5_0._action_list)

		local var_5_2 = arg_5_0._selected_action > 0 and arg_5_0._action_list[arg_5_0._selected_action]
		local var_5_3 = var_5_2 and arg_5_0._sub_action_list[var_5_2] or {}

		arg_5_0._selected_sub_action = Imgui.combo("Sub Action", arg_5_0._selected_sub_action, var_5_3)
	end

	local var_5_4 = true

	for iter_5_0, iter_5_1 in pairs(arg_5_0._weapon_extensions) do
		if not var_5_4 then
			Imgui.same_line()
		end

		if iter_5_0 == "any" then
			iter_5_1 = nil
		end

		if Imgui.radio_button(iter_5_0, iter_5_1 == arg_5_0._current_weapon_extension) then
			arg_5_0._current_weapon_extension = iter_5_1
			arg_5_0._selected_weapon_extenstion_name = iter_5_0
		end

		var_5_4 = false
	end

	arg_5_0:_draw_basic_info()
	arg_5_0:_draw_damage_info()
	Imgui.end_window()

	return var_5_0
end

function ImguiWeaponDebug._refresh_unit_list(arg_6_0)
	arg_6_0._unit_names = {}
	arg_6_0._units = {}
	arg_6_0._selected_unit = -1

	table.insert(arg_6_0._unit_names, "none")
	table.insert(arg_6_0._units, false)

	local var_6_0 = Managers.player

	if var_6_0 then
		local var_6_1 = var_6_0:human_and_bot_players()

		for iter_6_0, iter_6_1 in pairs(var_6_1) do
			if iter_6_1 then
				local var_6_2 = iter_6_1:profile_display_name()

				table.insert(arg_6_0._unit_names, var_6_2)
				table.insert(arg_6_0._units, iter_6_1.player_unit)

				if iter_6_1.local_player then
					arg_6_0._selected_unit = #arg_6_0._unit_names

					arg_6_0:_initialize_unit(iter_6_1.player_unit)
				end
			end
		end
	end
end

function ImguiWeaponDebug._initialize_unit(arg_7_0, arg_7_1)
	arg_7_0._current_unit = arg_7_1
	arg_7_0._weapon_unit_left = nil
	arg_7_0._weapon_unit_right = nil
	arg_7_0._weapon_extensions = {}
	arg_7_0._current_weapon_extension = nil
	arg_7_0._current_inventory_extension = nil
	arg_7_0._selected_weapon_extenstion_name = "any"
	arg_7_0._action_list = {}
	arg_7_0._sub_action_list = {}
	arg_7_0._current_actions = {}
	arg_7_0._combat_hit_actions = {}
	arg_7_0._combat_push_actions = {}
	arg_7_0._combat_current_weapon = nil
	arg_7_0._combat_current_weapon_name = nil
	arg_7_0._attack_armor_modifiers = {}
	arg_7_0._armor_modifiers_charge_value = {}

	if arg_7_1 then
		local var_7_0 = ScriptUnit.has_extension(arg_7_1, "inventory_system")

		arg_7_0._current_inventory_extension = var_7_0

		local var_7_1, var_7_2 = var_7_0:get_all_weapon_unit()

		arg_7_0._weapon_unit_left = var_7_1
		arg_7_0._weapon_unit_right = var_7_2

		local var_7_3 = Unit.alive(var_7_1) and ScriptUnit.extension(var_7_1, "weapon_system")
		local var_7_4 = Unit.alive(var_7_2) and ScriptUnit.extension(var_7_2, "weapon_system")

		arg_7_0._weapon_extensions.left = var_7_3
		arg_7_0._weapon_extensions.right = var_7_4
		arg_7_0._weapon_extensions.any = var_7_3

		local var_7_5 = var_7_3 or var_7_4

		if var_7_5 then
			local var_7_6 = ItemMasterList[var_7_5.item_name]
			local var_7_7 = WeaponUtils.get_weapon_template(var_7_6.template) or WeaponUtils.get_weapon_template(var_7_6.temporary_template)
			local var_7_8 = {
				0,
				0,
				0,
				0,
				0,
				0
			}
			local var_7_9 = 0
			local var_7_10 = {}

			if var_7_7 then
				local var_7_11 = var_7_7.actions

				arg_7_0._current_actions = var_7_11
				arg_7_0._combat_current_weapon = var_7_6
				arg_7_0._combat_current_weapon_name = var_7_5.item_name

				for iter_7_0, iter_7_1 in pairs(var_7_11) do
					table.insert(arg_7_0._action_list, iter_7_0)

					if not arg_7_0._sub_action_list[iter_7_0] then
						arg_7_0._sub_action_list[iter_7_0] = {}
					end

					local var_7_12 = arg_7_0._sub_action_list[iter_7_0]

					for iter_7_2, iter_7_3 in pairs(iter_7_1) do
						table.insert(var_7_12, iter_7_2)

						local var_7_13, var_7_14 = arg_7_0:_get_damage_profile_for_action(iter_7_3)

						if var_7_13 or var_7_14 then
							arg_7_0._combat_hit_actions[iter_7_2] = iter_7_3

							if var_7_13 then
								local var_7_15 = iter_7_2 .. "_L"
								local var_7_16 = var_7_10[var_7_15] or {
									count = 0,
									values = {}
								}
								local var_7_17 = ActionUtils.get_damage_profile_performance_scores(var_7_13)

								for iter_7_4 = 1, #var_7_17 do
									var_7_8[iter_7_4] = (var_7_8[iter_7_4] or 0) + var_7_17[iter_7_4]
									var_7_16.values[iter_7_4] = (var_7_16.values[iter_7_4] or 0) + var_7_17[iter_7_4]
								end

								var_7_9 = var_7_9 + 1
								var_7_16.count = var_7_16.count + 1
								var_7_10[var_7_15] = var_7_16
							end

							if var_7_14 then
								local var_7_18 = iter_7_2 .. "_R"
								local var_7_19 = var_7_10[var_7_18] or {
									count = 0,
									values = {}
								}
								local var_7_20 = ActionUtils.get_damage_profile_performance_scores(var_7_14)

								for iter_7_5 = 1, #var_7_20 do
									var_7_8[iter_7_5] = (var_7_8[iter_7_5] or 0) + var_7_20[iter_7_5]
									var_7_19.values[iter_7_5] = (var_7_19.values[iter_7_5] or 0) + var_7_20[iter_7_5]
								end

								var_7_9 = var_7_9 + 1
								var_7_19.count = var_7_19.count + 1
								var_7_10[var_7_18] = var_7_19
							end
						end

						local var_7_21, var_7_22 = ActionUtils.get_push_damage_profile(iter_7_3)

						if var_7_21 or var_7_22 then
							arg_7_0._combat_push_actions[iter_7_2] = {
								inner = var_7_21,
								outer = var_7_22
							}
						end
					end

					table.sort(var_7_12)
				end
			end

			table.sort(arg_7_0._action_list)

			for iter_7_6 = 1, #var_7_8 do
				var_7_8[iter_7_6] = var_7_9 == 0 and 0 or var_7_8[iter_7_6] / var_7_9
			end

			arg_7_0._attack_armor_modifiers = var_7_8

			for iter_7_7, iter_7_8 in pairs(var_7_10) do
				for iter_7_9 = 1, #iter_7_8.values do
					iter_7_8.values[iter_7_9] = iter_7_8.count == 0 and 0 or iter_7_8.values[iter_7_9] / iter_7_8.count
				end

				arg_7_0._armor_modifiers_charge_value[iter_7_7] = iter_7_8.values
			end
		end
	end
end

function ImguiWeaponDebug._draw_basic_info(arg_8_0)
	local var_8_0 = arg_8_0._combat_current_weapon
	local var_8_1 = arg_8_0._combat_current_weapon_name or "-"

	if var_8_0 then
		Imgui.separator()

		if Imgui.tree_node("Basic Information") then
			Imgui.text(string.format("Item Name:     %s", var_8_1))
			Imgui.text(string.format("Template Name: %s", var_8_0.template))
			Imgui.text(string.format("Left Hand:     %s", var_8_0.left_hand_unit))
			Imgui.text(string.format("Right Hand:    %s", var_8_0.right_hand_unit))
			Imgui.separator()
			Imgui.columns(3, true)
			Imgui.text("Damage Profiles")
			Imgui.next_column()
			Imgui.text("left")
			Imgui.next_column()
			Imgui.text("right")
			Imgui.next_column()
			Imgui.separator()

			local var_8_2 = arg_8_0._combat_hit_actions

			for iter_8_0, iter_8_1 in pairs(var_8_2) do
				local var_8_3 = iter_8_1 and iter_8_1.weapon_action_hand
				local var_8_4, var_8_5 = ActionUtils.get_damage_profile_name(iter_8_1, var_8_3)

				Imgui.text(iter_8_0)
				Imgui.next_column()
				Imgui.text(tostring(var_8_4))
				Imgui.next_column()
				Imgui.text(tostring(var_8_5))
				Imgui.next_column()
			end

			Imgui.separator()
			Imgui.columns(7, true)
			Imgui.text("category\\armor type")

			for iter_8_2 = 1, 6 do
				Imgui.next_column()
				Imgui.text(tostring(iter_8_2))
			end

			Imgui.separator()

			for iter_8_3, iter_8_4 in pairs(arg_8_0._armor_modifiers_charge_value) do
				Imgui.next_column()
				Imgui.text(iter_8_3)

				for iter_8_5 = 1, 6 do
					Imgui.next_column()
					Imgui.text(string.format("%.2f", iter_8_4[iter_8_5] or 0))
				end
			end

			Imgui.next_column()
			Imgui.text("total average")

			for iter_8_6 = 1, 6 do
				Imgui.next_column()
				Imgui.text(string.format("%.2f", arg_8_0._attack_armor_modifiers[iter_8_6] or 0))
			end

			Imgui.columns(1)
			Imgui.tree_pop()
		end
	end
end

function ImguiWeaponDebug._draw_damage_info(arg_9_0)
	Imgui.separator()
	Imgui.text("Damage Information")

	arg_9_0._combat_pop_settings = Imgui.checkbox("Pop Combat Settings", arg_9_0._combat_pop_settings)

	if arg_9_0._combat_pop_settings then
		Imgui.begin_window("Combat Settings (Weapon Debug)")
		arg_9_0:_update_combat_settings()
		Imgui.end_window()
	else
		arg_9_0:_update_combat_settings()
	end

	local var_9_0 = arg_9_0._difficulties[arg_9_0._damage_difficulty_id]
	local var_9_1 = arg_9_0._hit_zone_names[arg_9_0._damage_hit_zone_id]

	for iter_9_0, iter_9_1 in pairs(arg_9_0._breed_table) do
		if var_9_0 and var_9_1 and Imgui.tree_node(iter_9_0) then
			Imgui.separator()
			arg_9_0:_draw_faction_combat_info(iter_9_1, var_9_0, var_9_1, arg_9_0._damage_power_level, arg_9_0._combat_stagger_level, arg_9_0._combat_critical, arg_9_0._combat_backstab_multiplier, arg_9_0._combat_power_boost)
			Imgui.tree_pop()
		end
	end
end

function ImguiWeaponDebug._update_combat_settings(arg_10_0)
	arg_10_0._combat_use_current_power_level = Imgui.checkbox("Use Current Power Level", arg_10_0._combat_use_current_power_level)

	if arg_10_0._combat_use_current_power_level then
		local var_10_0 = arg_10_0._current_unit
		local var_10_1 = var_10_0 and Unit.alive(var_10_0) and ScriptUnit.extension(var_10_0, "career_system")

		arg_10_0._damage_power_level = var_10_1 and var_10_1:get_career_power_level() or var_0_1
	end

	arg_10_0._damage_power_level = math.max(Imgui.input_float("Power Level", arg_10_0._damage_power_level), var_0_1)
	arg_10_0._damage_difficulty_id = Imgui.combo("Difficulty", arg_10_0._damage_difficulty_id, arg_10_0._difficulties)
	arg_10_0._damage_hit_zone_id = Imgui.combo("Hit Zone", arg_10_0._damage_hit_zone_id, arg_10_0._hit_zone_names)
	arg_10_0._combat_backstab_multiplier = Imgui.slider_float("Backstab Mult", arg_10_0._combat_backstab_multiplier, 1, 2)
	arg_10_0._combat_stagger_level = math.floor(Imgui.slider_float("Stagger Level", arg_10_0._combat_stagger_level, 0, 3))
	arg_10_0._combat_critical = Imgui.checkbox("Critical", arg_10_0._combat_critical)

	Imgui.same_line()

	arg_10_0._combat_power_boost = Imgui.checkbox("Power Boost", arg_10_0._combat_power_boost)

	for iter_10_0, iter_10_1 in pairs(POWER_LEVEL_DIFF_RATIO) do
		local var_10_2 = arg_10_0._difficulties[arg_10_0._damage_difficulty_id]
		local var_10_3 = ActionUtils.scale_power_levels(arg_10_0._damage_power_level, iter_10_0, arg_10_0._current_unit, var_10_2)

		Imgui.text(string.format("Scaled - %-8s: %s", iter_10_0, var_10_3))
	end
end

function ImguiWeaponDebug._draw_faction_combat_info(arg_11_0, arg_11_1, arg_11_2, arg_11_3, arg_11_4, arg_11_5, arg_11_6, arg_11_7, arg_11_8)
	local var_11_0 = 1
	local var_11_1 = 8
	local var_11_2 = string.format("%7s%6s", "%2d", "")
	local var_11_3 = arg_11_0._combat_hit_actions
	local var_11_4 = arg_11_0._combat_push_actions
	local var_11_5 = {}
	local var_11_6 = {}

	for iter_11_0, iter_11_1 in pairs(arg_11_1) do
		Imgui.separator()

		local var_11_7 = Breeds[iter_11_0] or PlayerBreeds[iter_11_0]
		local var_11_8, var_11_9, var_11_10, var_11_11 = ActionUtils.get_target_armor(arg_11_3, var_11_7, 1)
		local var_11_12 = string.format("Breed: %s (Armor: %d / Primary Armor: %d)", iter_11_0, var_11_8 or 0, var_11_10 or 0)

		if Imgui.tree_node(var_11_12) then
			local var_11_13 = arg_11_0:get_breed_health(arg_11_2, var_11_7)
			local var_11_14, var_11_15, var_11_16 = arg_11_0:get_breed_stagger(arg_11_2, var_11_7)

			Imgui.text(string.format("Health: %.2f", var_11_13))
			Imgui.text(string.format("Stagger Thresholds: %.2f / %.2f / %.2f", var_11_14, var_11_15, var_11_16))
			Imgui.separator()
			Imgui.columns(9, true)
			Imgui.text("Hit Index")

			for iter_11_2 = var_11_0, var_11_1 do
				Imgui.next_column()
				Imgui.text(iter_11_2)
			end

			Imgui.separator()

			for iter_11_3, iter_11_4 in pairs(var_11_3) do
				table.clear(var_11_5)
				table.clear(var_11_6)

				for iter_11_5 = var_11_0, var_11_1 do
					local var_11_17 = arg_11_0:get_damage(iter_11_4, arg_11_4, arg_11_2, arg_11_3, var_11_7, iter_11_5, arg_11_5, arg_11_6, arg_11_7, arg_11_8)
					local var_11_18 = var_11_17 > 0 and math.ceil(var_11_13 / var_11_17) or 0

					table.insert(var_11_5, var_11_17)
					table.insert(var_11_6, var_11_18)
				end

				Imgui.next_column()
				Imgui.text(iter_11_3)

				for iter_11_6 = 1, #var_11_5 do
					Imgui.next_column()
					Imgui.text(string.format("%6.2f - %-3d", var_11_5[iter_11_6], var_11_6[iter_11_6]))
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

			for iter_11_7, iter_11_8 in pairs(var_11_4) do
				Imgui.next_column()
				Imgui.text(iter_11_7 .. " Inner")

				local var_11_19 = DamageProfileTemplates[iter_11_8.inner]
				local var_11_20, var_11_21, var_11_22, var_11_23, var_11_24 = arg_11_0:get_ai_stagger(var_11_19, arg_11_4, arg_11_2, arg_11_3, var_11_7, 1, arg_11_6, arg_11_8)

				Imgui.next_column()
				Imgui.text(string.format("%.2f", var_11_20))
				Imgui.next_column()
				Imgui.text(string.format("%.2f", var_11_21))
				Imgui.next_column()
				Imgui.text(string.format("%.2f", var_11_22))
				Imgui.next_column()
				Imgui.text(string.format("%.2f", var_11_23))
				Imgui.next_column()
				Imgui.text(string.format("%.2f", var_11_24))

				local var_11_25 = DamageProfileTemplates[iter_11_8.inner]
				local var_11_26, var_11_27, var_11_28, var_11_29, var_11_30 = arg_11_0:get_ai_stagger(var_11_25, arg_11_4, arg_11_2, arg_11_3, var_11_7, 1, arg_11_6, arg_11_8)

				Imgui.next_column()
				Imgui.text(iter_11_7 .. " Outer")
				Imgui.next_column()
				Imgui.text(string.format("%.2f", var_11_26))
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

function ImguiWeaponDebug._get_current_weapon(arg_12_0)
	if not arg_12_0._display_current_action then
		for iter_12_0, iter_12_1 in pairs(arg_12_0._weapon_extensions) do
			if iter_12_1 then
				return iter_12_1
			end
		end
	end

	if arg_12_0._current_weapon_extension then
		return arg_12_0._current_weapon_extension
	else
		for iter_12_2, iter_12_3 in pairs(arg_12_0._weapon_extensions) do
			if iter_12_3 and iter_12_3.current_action_settings then
				return iter_12_3
			end
		end
	end

	return nil
end

function ImguiWeaponDebug._get_current_action(arg_13_0)
	if not arg_13_0._display_current_action then
		local var_13_0 = arg_13_0._selected_action >= 0 and arg_13_0._action_list[arg_13_0._selected_action]
		local var_13_1 = var_13_0 and arg_13_0._sub_action_list[var_13_0] or {}
		local var_13_2 = arg_13_0._selected_sub_action >= 0 and var_13_1[arg_13_0._selected_sub_action]
		local var_13_3 = var_13_0 and arg_13_0._current_actions[var_13_0]

		return var_13_3 and var_13_3[var_13_2]
	end

	if arg_13_0._current_weapon_extension then
		return arg_13_0._current_weapon_extension.current_action_settings
	else
		for iter_13_0, iter_13_1 in pairs(arg_13_0._weapon_extensions) do
			if iter_13_1 and iter_13_1.current_action_settings then
				return iter_13_1.current_action_settings
			end
		end
	end

	return nil
end

function ImguiWeaponDebug.debug_draw_chain_data(arg_14_0, arg_14_1, arg_14_2, arg_14_3, arg_14_4)
	local var_14_0 = Debug.gui
	local var_14_1 = 150
	local var_14_2 = 20
	local var_14_3 = var_14_2 + 5
	local var_14_4 = 5
	local var_14_5 = var_14_1 * var_14_4
	local var_14_6 = var_14_3 * 7 + 20
	local var_14_7 = 150
	local var_14_8 = 0.25
	local var_14_9 = RESOLUTION_LOOKUP.res_w
	local var_14_10 = RESOLUTION_LOOKUP.res_h
	local var_14_11 = var_14_9 / 2 - (var_14_5 - var_14_7) / 2
	local var_14_12 = var_14_10 * 0.25 + var_14_6 / 2
	local var_14_13 = 12
	local var_14_14 = 16
	local var_14_15 = Color(255, 255, 255, 255)
	local var_14_16 = ActionUtils.get_action_time_scale(arg_14_3, arg_14_2)
	local var_14_17 = arg_14_2.total_time / ActionUtils.get_action_time_scale(arg_14_3, arg_14_2)
	local var_14_18 = arg_14_4:get_scaled_min_hold_time(arg_14_2)
	local var_14_19 = math.min(var_14_17, var_14_4)
	local var_14_20 = math.min(arg_14_1, var_14_19)
	local var_14_21 = Colors.get_color_with_alpha("black", 150)
	local var_14_22 = Vector3(var_14_11 - var_14_7, var_14_12 - var_14_6, 0)
	local var_14_23 = Vector3(var_14_5 + var_14_7, var_14_6, 0)

	Gui.rect(var_14_0, var_14_22, var_14_23, var_14_21)
	ScriptGUI.hud_line(var_14_0, Vector3(var_14_11, var_14_12, 1), Vector3(var_14_11, var_14_12 - var_14_6, 1), 3, 2, Color(255, 255, 255, 255))

	local var_14_24 = var_14_11 + var_14_18 * var_14_1

	ScriptGUI.hud_line(var_14_0, Vector3(var_14_24, var_14_12, 0.5), Vector3(var_14_24, var_14_12 - var_14_6, 0.5), 3, 2, Color(255, 255, 0, 0))
	var_0_4(var_14_0, string.format("%.2f", var_14_18), var_14_13, Vector3(var_14_24 + 5, var_14_12, 0.5), Color(255, 255, 0, 0))

	local var_14_25 = var_14_11 + var_14_4 * var_14_1

	ScriptGUI.hud_line(var_14_0, Vector3(var_14_25, var_14_12, 0.5), Vector3(var_14_25, var_14_12 - var_14_6, 0.5), 3, 2, Color(255, 255, 255, 255))

	local var_14_26 = var_14_11 + var_14_19 * var_14_1

	ScriptGUI.hud_line(var_14_0, Vector3(var_14_26, var_14_12, 1), Vector3(var_14_26, var_14_12 - var_14_6, 1), 3, 2, Color(255, 255, 0, 0))
	var_0_4(var_14_0, string.format("%.2f", var_14_17), var_14_13, Vector3(var_14_26 + 5, var_14_12, 0.5), Color(255, 255, 0, 0))

	if arg_14_2.damage_window_start and arg_14_2.damage_window_end then
		local var_14_27 = arg_14_2.damage_window_start / var_14_16
		local var_14_28 = (arg_14_2.damage_window_end or arg_14_2.total_time or math.huge) / var_14_16
		local var_14_29 = var_14_11 + var_14_27 * var_14_1
		local var_14_30 = (var_14_28 - var_14_27) * var_14_1

		Gui.rect(var_14_0, Vector3(var_14_29, var_14_12 - var_14_6, 0), Vector3(var_14_30, var_14_6, 0), Color(128, 255, 0, 0))
	end

	local var_14_31 = math.floor(var_14_19 / var_14_8)

	for iter_14_0 = 0, var_14_31 do
		local var_14_32 = var_14_11 + iter_14_0 * var_14_8 * var_14_1

		ScriptGUI.hud_line(var_14_0, Vector3(var_14_32, var_14_12, 0.1), Vector3(var_14_32, var_14_12 - var_14_6, 0.1), 3, 2, Color(50, 255, 255, 255))
		var_0_4(var_14_0, string.format("%.2f", iter_14_0 * var_14_8), var_14_13, Vector3(var_14_32, var_14_12 - var_14_6, 0.1), var_14_15)
	end

	local var_14_33 = arg_14_2.lookup_data

	if var_14_33 then
		var_0_4(var_14_0, var_14_33.action_name, var_14_13, Vector3(var_14_11 - var_14_7, var_14_12 + 20, 0.1), var_14_15)
		var_0_4(var_14_0, var_14_33.sub_action_name, var_14_13, Vector3(var_14_11 - var_14_7, var_14_12 + 5, 0.1), var_14_15)
	end

	local var_14_34 = arg_14_2.damage_profile
	local var_14_35 = var_14_34 and DamageProfileTemplates[var_14_34]

	if var_14_35 then
		local var_14_36 = var_14_11 + var_14_5 + 10
		local var_14_37 = var_14_12 - 15
		local var_14_38 = 15
		local var_14_39 = var_14_35.default_target
		local var_14_40 = var_14_39 and var_14_39.boost_curve_type

		var_0_4(var_14_0, string.format("[damage profile] %s", var_14_34), var_14_13, Vector3(var_14_36, var_14_37, 0.1), var_14_15)

		if var_14_39 then
			var_0_4(var_14_0, string.format("[default] %s", tostring(var_14_40)), var_14_13, Vector3(var_14_36, var_14_37 - var_14_38, 0.1), var_14_15)
		end

		local var_14_41 = var_14_35.targets

		for iter_14_1 = 1, #var_14_41 do
			local var_14_42 = var_14_41[iter_14_1]
			local var_14_43 = var_14_42 and var_14_42.boost_curve_type

			var_0_4(var_14_0, string.format("[%d] %s", iter_14_1, tostring(var_14_43)), var_14_13, Vector3(var_14_36, var_14_37 - var_14_38 * (iter_14_1 + 1), 0.1), var_14_15)
		end
	end

	local var_14_44 = arg_14_2.allowed_chain_actions

	for iter_14_2 = 1, #var_14_44 do
		local var_14_45 = var_14_44[iter_14_2]
		local var_14_46 = tostring(var_14_45.action) .. "/" .. tostring(var_14_45.sub_action)
		local var_14_47 = var_14_45.auto_chain and "auto_chain" or tostring(var_14_45.input)

		if var_14_45.hold_allowed then
			var_14_47 = var_14_47 .. "(hold)"
		end

		local var_14_48 = var_14_45.start_time / var_14_16
		local var_14_49 = var_14_45.end_time and var_14_45.end_time / var_14_16 or math.huge
		local var_14_50 = var_14_20 < var_14_48 and Colors.get("orange") or var_14_49 <= var_14_20 and Colors.get("red") or Colors.get("green")
		local var_14_51 = iter_14_2
		local var_14_52 = var_14_11 + var_14_48 * var_14_1
		local var_14_53 = var_14_12 - var_14_51 * var_14_3
		local var_14_54 = Vector3(var_14_52, var_14_53, 0.1)
		local var_14_55 = (math.min(var_14_49, var_14_4) - var_14_48) * var_14_1
		local var_14_56 = Vector3(var_14_55, var_14_2, 0)

		Gui.rect(var_14_0, var_14_54, var_14_56, var_14_50)

		local var_14_57 = var_14_46 .. string.format(" [%.2f - %.2f]", var_14_48, var_14_49)

		var_0_4(var_14_0, var_14_57, var_14_14, var_14_54, var_14_15)

		local var_14_58 = Vector3(var_14_11 - var_14_7, var_14_53, 0.1)

		var_0_4(var_14_0, var_14_47, var_14_14, var_14_58, var_14_15)
	end

	local var_14_59 = var_14_11 + var_14_20 * var_14_1
	local var_14_60 = var_14_12 + 10
	local var_14_61 = var_14_59
	local var_14_62 = var_14_60 - var_14_6 - 20

	ScriptGUI.hud_line(var_14_0, Vector3(var_14_59, var_14_60, 1), Vector3(var_14_61, var_14_62, 1), 3, 2, Color(255, 255, 255, 255))
	var_0_4(var_14_0, string.format("%.2f", arg_14_1), var_14_14, Vector3(var_14_59 + 5, var_14_60, 1), var_14_15)
end

function ImguiWeaponDebug.get_breed_health(arg_15_0, arg_15_1, arg_15_2)
	local var_15_0 = 0
	local var_15_1 = DifficultySettings[arg_15_1]

	if var_15_1 and arg_15_2 then
		local var_15_2 = arg_15_2.max_health
		local var_15_3 = var_15_1.rank

		var_15_0 = var_15_2 and var_15_2[var_15_3] or 0
	end

	return var_15_0
end

function ImguiWeaponDebug.get_breed_stagger(arg_16_0, arg_16_1, arg_16_2)
	local var_16_0 = 0
	local var_16_1 = 0
	local var_16_2 = 0
	local var_16_3 = false
	local var_16_4 = DifficultySettings[arg_16_1]

	if var_16_4 and arg_16_2 then
		local var_16_5 = var_16_4.rank
		local var_16_6 = arg_16_2.diff_stagger_resist and arg_16_2.diff_stagger_resist[var_16_5] or arg_16_2.stagger_resistance or 2

		var_16_0 = var_16_3 and 0 or arg_16_2.stagger_threshold_light and arg_16_2.stagger_threshold_light * var_16_6 or 0.25 * var_16_6
		var_16_1 = arg_16_2.stagger_threshold_medium and arg_16_2.stagger_threshold_medium * var_16_6 or 1 * var_16_6
		var_16_2 = arg_16_2.stagger_threshold_heavy and arg_16_2.stagger_threshold_heavy * var_16_6 or 2.5 * var_16_6
	end

	return var_16_0, var_16_1, var_16_2
end

function ImguiWeaponDebug.get_damage(arg_17_0, arg_17_1, arg_17_2, arg_17_3, arg_17_4, arg_17_5, arg_17_6, arg_17_7, arg_17_8, arg_17_9, arg_17_10)
	local var_17_0 = arg_17_0._current_unit
	local var_17_1 = arg_17_0._combat_current_weapon

	if var_17_1 and var_17_0 and arg_17_1 and arg_17_5 then
		local var_17_2 = arg_17_1.weapon_action_hand

		if var_17_2 == "both" and arg_17_0._selected_weapon_extenstion_name ~= "any" then
			var_17_2 = arg_17_0._selected_weapon_extenstion_name
		end

		local var_17_3, var_17_4 = ActionUtils.get_damage_profile_name(arg_17_1, var_17_2)
		local var_17_5 = var_17_3 and DamageProfileTemplates[var_17_3]
		local var_17_6 = var_17_4 and DamageProfileTemplates[var_17_4]
		local var_17_7 = DifficultySettings[arg_17_3]

		if var_17_7 then
			local var_17_8 = 0
			local var_17_9 = 0

			if var_17_5 then
				var_17_8 = arg_17_0:_calculate_damage(var_17_0, var_17_1, var_17_5, var_17_7, arg_17_2, arg_17_3, arg_17_4, arg_17_5, arg_17_6, arg_17_7, arg_17_8, arg_17_9, arg_17_10)
			end

			if var_17_6 then
				var_17_9 = arg_17_0:_calculate_damage(var_17_0, var_17_1, var_17_6, var_17_7, arg_17_2, arg_17_3, arg_17_4, arg_17_5, arg_17_6, arg_17_7, arg_17_8, arg_17_9, arg_17_10)
			end

			return var_17_8 + var_17_9
		end
	end

	return 0
end

function ImguiWeaponDebug.get_ai_stagger(arg_18_0, arg_18_1, arg_18_2, arg_18_3, arg_18_4, arg_18_5, arg_18_6, arg_18_7, arg_18_8)
	local var_18_0 = arg_18_0._current_unit
	local var_18_1 = arg_18_0._combat_current_weapon

	if var_18_1 and var_18_0 and arg_18_1 and arg_18_5 then
		return arg_18_0:_calculate_ai_stagger(var_18_0, var_18_1, arg_18_1, arg_18_2, arg_18_3, arg_18_4, arg_18_5, arg_18_6, arg_18_7, arg_18_8)
	end

	return 0, 0, 0, 0, 0
end

function ImguiWeaponDebug._calculate_damage(arg_19_0, arg_19_1, arg_19_2, arg_19_3, arg_19_4, arg_19_5, arg_19_6, arg_19_7, arg_19_8, arg_19_9, arg_19_10, arg_19_11, arg_19_12, arg_19_13)
	local var_19_0 = arg_19_2.name
	local var_19_1
	local var_19_2 = 0

	if arg_19_3.no_stagger_damage_reduction_ranged then
		local var_19_3 = 1

		arg_19_10 = math.max(var_19_3, arg_19_10)
	end

	local var_19_4 = DamageUtils.custom_calculate_damage(arg_19_1, var_19_0, arg_19_5, arg_19_3, arg_19_9, var_19_2, arg_19_11, arg_19_12, arg_19_13, var_19_1, arg_19_8, arg_19_7, arg_19_10, arg_19_6)

	return (DamageUtils.networkify_damage(var_19_4))
end

function ImguiWeaponDebug._calculate_ai_stagger(arg_20_0, arg_20_1, arg_20_2, arg_20_3, arg_20_4, arg_20_5, arg_20_6, arg_20_7, arg_20_8, arg_20_9, arg_20_10)
	local var_20_0 = false
	local var_20_1 = arg_20_2.name
	local var_20_2 = 0
	local var_20_3, var_20_4, var_20_5, var_20_6, var_20_7 = DamageUtils.calculate_stagger_player_tooltip(arg_20_7, arg_20_1, arg_20_6, arg_20_4, arg_20_9, arg_20_3, arg_20_8, var_20_0, var_20_1, arg_20_5, arg_20_10, var_20_2)

	return var_20_3, var_20_4, var_20_5, var_20_6, var_20_7
end

function ImguiWeaponDebug._get_damage_profile_for_action(arg_21_0, arg_21_1)
	if arg_21_1 then
		local var_21_0 = arg_21_1.weapon_action_hand

		if var_21_0 == "both" and arg_21_0._selected_weapon_extenstion_name ~= "any" then
			var_21_0 = arg_21_0._selected_weapon_extenstion_name
		end

		return ActionUtils.get_damage_profile_name(arg_21_1, var_21_0)
	end

	return nil, nil
end

function ImguiWeaponDebug._verify_crits(arg_22_0)
	print("STARTING TEST: verify_crits")

	local var_22_0 = arg_22_0._current_unit
	local var_22_1 = ItemMasterList.we_1h_axe
	local var_22_2 = "normal"
	local var_22_3 = DifficultySettings[var_22_2]
	local var_22_4 = 300
	local var_22_5 = 1
	local var_22_6 = 0
	local var_22_7
	local var_22_8 = 1
	local var_22_9 = table.mirror_array_inplace({
		"tutorial_longbow_charged"
	})
	local var_22_10 = table.mirror_array_inplace({
		"chaos_raider",
		"chaos_raider_tutorial",
		"chaos_dummy_sorcerer",
		"chaos_dummy_exalted_sorcerer_drachenfels",
		"skaven_stormfiend",
		"skaven_stormfiend_demo",
		"skaven_stormfiend_boss"
	})
	local var_22_11 = {
		"head",
		"torso"
	}

	for iter_22_0, iter_22_1 in pairs(DamageProfileTemplates) do
		if not string.ends_with(iter_22_0, "_no_damage") and not var_22_9[iter_22_0] then
			for iter_22_2, iter_22_3 in pairs(arg_22_0._breed_table) do
				for iter_22_4, iter_22_5 in pairs(iter_22_3) do
					if not var_22_10[iter_22_4] then
						local var_22_12 = Breeds[iter_22_4]
						local var_22_13 = var_22_11[1]
						local var_22_14 = false
						local var_22_15 = false
						local var_22_16 = arg_22_0:_calculate_damage(var_22_0, var_22_1, iter_22_1, var_22_3, var_22_4, var_22_2, var_22_13, var_22_12, var_22_5, var_22_6, var_22_14, var_22_7, var_22_15)
						local var_22_17 = true
						local var_22_18 = false
						local var_22_19 = arg_22_0:_calculate_damage(var_22_0, var_22_1, iter_22_1, var_22_3, var_22_4, var_22_2, var_22_13, var_22_12, var_22_5, var_22_6, var_22_17, var_22_7, var_22_18)
						local var_22_20 = false
						local var_22_21 = true
						local var_22_22 = arg_22_0:_calculate_damage(var_22_0, var_22_1, iter_22_1, var_22_3, var_22_4, var_22_2, var_22_13, var_22_12, var_22_5, var_22_6, var_22_20, var_22_7, var_22_21)
						local var_22_23 = true
						local var_22_24 = true
						local var_22_25 = arg_22_0:_calculate_damage(var_22_0, var_22_1, iter_22_1, var_22_3, var_22_4, var_22_2, var_22_13, var_22_12, var_22_5, var_22_6, var_22_23, var_22_7, var_22_24)
						local var_22_26 = var_22_11[2]
						local var_22_27 = false
						local var_22_28 = false
						local var_22_29 = arg_22_0:_calculate_damage(var_22_0, var_22_1, iter_22_1, var_22_3, var_22_4, var_22_2, var_22_26, var_22_12, var_22_5, var_22_6, var_22_27, var_22_7, var_22_28)
						local var_22_30 = true
						local var_22_31 = false
						local var_22_32 = arg_22_0:_calculate_damage(var_22_0, var_22_1, iter_22_1, var_22_3, var_22_4, var_22_2, var_22_26, var_22_12, var_22_5, var_22_6, var_22_30, var_22_7, var_22_31)
						local var_22_33 = false
						local var_22_34 = true
						local var_22_35 = arg_22_0:_calculate_damage(var_22_0, var_22_1, iter_22_1, var_22_3, var_22_4, var_22_2, var_22_26, var_22_12, var_22_5, var_22_6, var_22_33, var_22_7, var_22_34)
						local var_22_36 = true
						local var_22_37 = true
						local var_22_38 = arg_22_0:_calculate_damage(var_22_0, var_22_1, iter_22_1, var_22_3, var_22_4, var_22_2, var_22_26, var_22_12, var_22_5, var_22_6, var_22_36, var_22_7, var_22_37)
						local var_22_39, var_22_40, var_22_41, var_22_42 = ActionUtils.get_target_armor(var_22_26, var_22_12, var_22_8)

						var_22_39 = var_22_39 or 0
						var_22_41 = var_22_41 or 0

						if var_22_19 < var_22_16 then
							print(string.format("%s / %s (%s)(%d/%d) Crit dealt less damage - normal %.2f, crit %.2f", iter_22_0, iter_22_4, var_22_26, var_22_39, var_22_41, var_22_16, var_22_19))
						end

						if var_22_22 < var_22_16 then
							print(string.format("%s / %s (%s)(%d/%d) Power boosted attack dealt less damage - normal %.2f, power boosted %.2f", iter_22_0, iter_22_4, var_22_26, var_22_39, var_22_41, var_22_16, var_22_22))
						end

						if var_22_25 < var_22_22 then
							print(string.format("%s / %s (%s)(%d/%d) Power boosted crit attack dealt less damage - power booster %.2f, power boosted crit %.2f", iter_22_0, iter_22_4, var_22_26, var_22_39, var_22_41, var_22_22, var_22_25))
						end

						if var_22_16 < var_22_29 then
							print(string.format("%s / %s (%s)(%d/%d) More dmg on torso than head - NORMAL torso %.2f, head %.2f", iter_22_0, iter_22_4, var_22_26, var_22_39, var_22_41, var_22_29, var_22_16))
						end

						if var_22_19 < var_22_32 then
							print(string.format("%s / %s (%s)(%d/%d) More dmg on torso than head - CRIT torso %.2f, head %.2f", iter_22_0, iter_22_4, var_22_26, var_22_39, var_22_41, var_22_32, var_22_19))
						end

						if var_22_22 < var_22_35 then
							print(string.format("%s / %s (%s)(%d/%d) More dmg on torso than head - POWER torso %.2f, head %.2f", iter_22_0, iter_22_4, var_22_26, var_22_39, var_22_41, var_22_35, var_22_22))
						end

						if var_22_25 < var_22_38 then
							print(string.format("%s / %s (%s)(%d/%d) More dmg on torso than head - POWER CRIT torso %.2f, head %.2f", iter_22_0, iter_22_4, var_22_26, var_22_39, var_22_41, var_22_38, var_22_25))
						end
					end
				end
			end
		end
	end

	print("Done!")
end

function ImguiWeaponDebug._dump_weapon_performance(arg_23_0)
	for iter_23_0 in pairs(Weapons) do
		print(iter_23_0)

		local var_23_0 = WeaponUtils.get_weapon_template(iter_23_0)
		local var_23_1 = WeaponUtils.get_used_actions(var_23_0)

		for iter_23_1, iter_23_2 in pairs(var_23_1) do
			local var_23_2 = var_23_0.actions[iter_23_1]

			for iter_23_3, iter_23_4 in pairs(iter_23_2) do
				local var_23_3 = ActionUtils.get_damage_profile_performance_scores(nil)
				local var_23_4, var_23_5 = arg_23_0:_get_damage_profile_for_action(var_23_2[iter_23_3])

				if var_23_5 then
					local var_23_6 = ActionUtils.get_damage_profile_performance_scores(var_23_5)

					for iter_23_5 = 1, #var_23_3 do
						var_23_3[iter_23_5] = var_23_3[iter_23_5] + var_23_6[iter_23_5]
					end
				end

				if var_23_4 then
					local var_23_7 = ActionUtils.get_damage_profile_performance_scores(var_23_4)

					for iter_23_6 = 1, #var_23_3 do
						var_23_3[iter_23_6] = var_23_3[iter_23_6] + var_23_7[iter_23_6]
					end
				end

				local var_23_8 = ""

				for iter_23_7 = 1, #var_23_3 do
					var_23_8 = var_23_8 .. string.format("[%i] %.3f ", iter_23_7, var_23_3[iter_23_7])
				end

				print(string.format("%s.%s - %s", iter_23_1, iter_23_3, var_23_8))
			end
		end
	end
end

function ImguiWeaponDebug._check_missing_unused_actions(arg_24_0)
	local var_24_0 = {
		weapon_reload = {
			auto_reload_on_empty = true
		},
		action_two = {
			give_item = true
		}
	}

	print("CHECKING FOR MISSING OR UNUSED ACTIONS")

	for iter_24_0 in pairs(Weapons) do
		local var_24_1 = WeaponUtils.get_weapon_template(weapon_name)
		local var_24_2, var_24_3 = WeaponUtils.get_used_actions(var_24_1)

		for iter_24_1, iter_24_2 in pairs(var_24_3) do
			for iter_24_3, iter_24_4 in pairs(iter_24_2) do
				print(string.format("Missing referenced action [%s.%s] in template [%s]", iter_24_1, iter_24_3, iter_24_0))
			end
		end

		for iter_24_5, iter_24_6 in pairs(var_24_1.actions) do
			local var_24_4 = var_24_2[iter_24_5]

			if not var_24_4 then
				print(string.format("Unused action [%s] in template [%s]", iter_24_5, iter_24_0))
			else
				for iter_24_7, iter_24_8 in pairs(iter_24_6) do
					if (not var_24_0[iter_24_5] or not var_24_0[iter_24_5][iter_24_7]) and not var_24_4[iter_24_7] then
						print(string.format("Unused sub-action [%s.%s] in template [%s]", iter_24_5, iter_24_7, iter_24_0))
					end
				end
			end
		end
	end

	print("DONE")
end
