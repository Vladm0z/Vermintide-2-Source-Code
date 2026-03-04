-- chunkname: @scripts/imgui/imgui_weapon_editor.lua

rawset(_G, "DamageProfileTemplates_orig", nil)
rawset(_G, "BoostCurves_orig", nil)
rawset(_G, "PowerLevelTemplates_orig", nil)
rawset(_G, "AttackTemplates_orig", nil)
rawset(_G, "Weapons_orig", nil)

local var_0_0 = type

local function var_0_1(arg_1_0)
	return setmetatable({}, {
		__mode = "kv",
		__index = function(arg_2_0, arg_2_1)
			local var_2_0 = var_0_0(arg_2_1)

			if var_2_0 == "function" then
				return nil
			end

			if var_2_0 ~= "table" then
				return arg_2_1
			end

			local var_2_1 = {}

			for iter_2_0, iter_2_1 in pairs(arg_2_1) do
				var_2_1[iter_2_0] = arg_2_0[iter_2_1]
			end

			arg_2_0[var_2_0] = var_2_1

			return var_2_1
		end
	})[arg_1_0]
end

local function var_0_2(arg_3_0, arg_3_1, arg_3_2)
	if arg_3_0 == arg_3_1 then
		return nil, arg_3_2
	end

	local var_3_0 = var_0_0(arg_3_0)

	if var_3_0 == "function" then
		return nil, arg_3_2
	end

	if var_3_0 ~= "table" or var_0_0(arg_3_1) ~= "table" then
		return arg_3_0, true
	end

	local var_3_1 = {}
	local var_3_2 = false

	for iter_3_0, iter_3_1 in pairs(arg_3_0) do
		var_3_1[iter_3_0], var_3_2 = var_0_2(iter_3_1, arg_3_1[iter_3_0], var_3_2)
	end

	if not var_3_2 then
		var_3_1 = nil
	end

	return var_3_1, arg_3_2 or var_3_2
end

local function var_0_3(arg_4_0)
	local var_4_0 = {}

	arg_4_0(function(arg_5_0)
		var_4_0[#var_4_0 + 1] = arg_5_0
	end)

	return var_4_0
end

ImguiWeaponEditor = class(ImguiWeaponEditor)

function ImguiWeaponEditor.init(arg_6_0)
	arg_6_0._persistent = false
	arg_6_0._tabs = {
		BoostCurves = BoostCurves,
		DamageProfileTemplates = DamageProfileTemplates,
		PowerLevelTemplates = PowerLevelTemplates,
		AttackTemplates = AttackTemplates,
		Weapons = Weapons,
		TerrorEventBlueprints = TerrorEventBlueprints
	}
	arg_6_0._table_metadata = setmetatable({}, {
		__mode = "k",
		__index = function(arg_7_0, arg_7_1)
			local var_7_0 = table.keys(arg_7_1)

			table.sort(var_7_0)

			local var_7_1 = {
				new_value = "",
				new_key = "",
				keys = var_7_0
			}

			arg_7_0[arg_7_1] = var_7_1

			return var_7_1
		end
	})

	arg_6_0:checkpoint()
end

function ImguiWeaponEditor._defered_init(arg_8_0)
	if arg_8_0._defered_init_done then
		return
	end

	local var_8_0 = {}

	for iter_8_0 = 1, #NetworkLookup.anims do
		var_8_0[iter_8_0] = NetworkLookup.anims[iter_8_0]
	end

	table.sort(var_8_0)

	arg_8_0._lut_lut = {
		anim_end_event = var_8_0,
		anim_event = var_8_0,
		attack_template = table.keys(AttackTemplates),
		boost_curve_type = table.keys(BoostCurves),
		buff_name = {
			"planted_charging_decrease_movement",
			"planted_decrease_movement",
			"planted_fast_decrease_movement"
		},
		buff_type = NetworkLookup.buff_weapon_types,
		crosshair_style = {
			"dot",
			"default",
			"arrows",
			"circle",
			"shotgun",
			"projectile"
		},
		damage_profile = table.keys(AttackTemplates),
		damage_type = NetworkLookup.damage_types,
		display_unit = var_0_3(function(arg_9_0)
			for iter_9_0, iter_9_1 in pairs(WeaponSkins.skins) do
				if iter_9_1.data and iter_9_1.data.display_unit then
					arg_9_0(iter_9_1.data.display_unit)
				end
			end
		end),
		first_person_hit_anim = var_8_0,
		hit_effect = table.keys(MaterialEffectMappings),
		hit_stop_anim = var_8_0,
		kind = {
			"career_aim",
			"career_dummy",
			"career_true_flight_aim",
			"charge",
			"dummy",
			"melee_start",
			"wield",
			"bounty_hunter_handgun",
			"handgun",
			"interaction",
			"self_interaction",
			"push_stagger",
			"sweep",
			"block",
			"throw",
			"staff",
			"bow",
			"true_flight_bow",
			"true_flight_bow_aim",
			"crossbow",
			"cancel",
			"buff",
			"bullet_spray",
			"aim",
			"reload",
			"shotgun",
			"shield_slam",
			"charged_projectile",
			"beam",
			"geiser_targeting",
			"geiser",
			"instant_wield",
			"throw_grimoire",
			"healing_draught",
			"flamethrower",
			"career_dr_three",
			"career_bw_one",
			"career_we_three",
			"career_we_three_piercing",
			"career_wh_two"
		},
		sound_type = NetworkLookup.melee_impact_sound_types,
		stagger_angle = {
			"down",
			"smiter",
			"stab",
			"pull"
		},
		wield_anim = var_8_0
	}
	arg_8_0._defered_init_done = true
end

function ImguiWeaponEditor.checkpoint(arg_10_0)
	arg_10_0._tabs0 = {
		BoostCurves = var_0_1(BoostCurves),
		DamageProfileTemplates = var_0_1(DamageProfileTemplates),
		PowerLevelTemplates = var_0_1(PowerLevelTemplates),
		AttackTemplates = var_0_1(AttackTemplates),
		Weapons = var_0_1(Weapons)
	}
end

function ImguiWeaponEditor.is_persistent(arg_11_0)
	return arg_11_0._persistent
end

function ImguiWeaponEditor.update(arg_12_0)
	arg_12_0:_defered_init()
end

function ImguiWeaponEditor.edit_table(arg_13_0, arg_13_1)
	local var_13_0 = arg_13_0._table_metadata[arg_13_1]

	for iter_13_0 = 1, #var_13_0.keys do
		local var_13_1 = var_13_0.keys[iter_13_0]
		local var_13_2 = arg_13_1[var_13_1]
		local var_13_3 = var_0_0(var_13_2)

		if var_13_3 == "table" then
			if Imgui.tree_node(var_13_1, false) then
				var_13_0.new_key = Imgui.input_text("Key", var_13_0.new_key)
				var_13_0.new_value = Imgui.input_text("Value", var_13_0.new_value)

				if Imgui.small_button("Add field") then
					local var_13_4
					local var_13_5

					var_13_5, var_13_0.error = arg_13_0:exec("local t = ... return " .. var_13_0.new_value, var_13_2)

					if var_13_5 ~= nil then
						rawset(var_13_2, var_13_0.new_key, var_13_5)

						var_13_0.keys[#var_13_0.keys + 1] = var_13_0.new_key
						var_13_0.new_key, var_13_0.new_value = "", ""
					end
				end

				if var_13_0.error then
					Imgui.text_colored(var_13_0.error, 255, 100, 100, 255)
				end

				Imgui.separator()
				arg_13_0:edit_table(var_13_2)
				Imgui.tree_pop()
			end
		elseif var_13_3 == "boolean" then
			arg_13_1[var_13_1] = Imgui.checkbox(var_13_1, var_13_2)
		elseif var_13_3 == "number" then
			arg_13_1[var_13_1] = Imgui.input_float(var_13_1, var_13_2)
		elseif var_13_3 == "string" then
			local var_13_6 = arg_13_0._lut_lut[var_13_1]
			local var_13_7

			if var_13_6 then
				var_13_7 = table.find(var_13_6, var_13_2)
			end

			if var_13_7 then
				arg_13_1[var_13_1] = var_13_6[Imgui.combo(var_13_1, var_13_7, var_13_6)]
			else
				arg_13_1[var_13_1] = Imgui.input_text(var_13_1, var_13_2)
			end
		end
	end
end

function ImguiWeaponEditor._apply_to_existing_items(arg_14_0)
	for iter_14_0, iter_14_1 in pairs(Managers.backend:get_interface("items")._modified_templates) do
		printf("[ImguiWeaponEditor] Updating %s (%s)", iter_14_0, iter_14_1.name)
		table.merge(iter_14_1, WeaponUtils.get_weapon_template(iter_14_1.name))
	end
end

function ImguiWeaponEditor.draw(arg_15_0, arg_15_1)
	local var_15_0 = Imgui.begin_window("Weapon Editor", "menu_bar")

	arg_15_0._persistent = Imgui.checkbox("Persistent window", arg_15_0._persistent)

	if Imgui.begin_menu_bar() then
		if Imgui.menu_item("Load") then
			Managers.chat:add_local_system_message(1, "Stripped", true)
		end

		if Imgui.menu_item("Save") then
			Managers.chat:add_local_system_message(1, "Stripped", true)
		end

		if Imgui.menu_item("Refresh items") then
			arg_15_0:_apply_to_existing_items()
		end

		Imgui.end_menu_bar()
	end

	Imgui.separator()
	Imgui.begin_child_window("Editor", 0, 0, true)
	arg_15_0:edit_table(arg_15_0._tabs)
	Imgui.end_child_window()
	Imgui.end_window()

	return var_15_0
end
