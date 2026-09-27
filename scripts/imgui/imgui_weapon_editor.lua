-- chunkname: @scripts/imgui/imgui_weapon_editor.lua

rawset(_G, "DamageProfileTemplates_orig", nil)
rawset(_G, "BoostCurves_orig", nil)
rawset(_G, "PowerLevelTemplates_orig", nil)
rawset(_G, "AttackTemplates_orig", nil)
rawset(_G, "Weapons_orig", nil)

local type = type

local function fn(arg_1_0)
	-- function 1
	return setmetatable({}, {
		__mode = "kv",
		__index = function (self, arg_2_1)
			-- function 2
			local var_2_0 = type(arg_2_1)

			if var_2_0 == "function" then
				return nil
			end

			if var_2_0 ~= "table" then
				return arg_2_1
			end

			local tbl = {}

			for k, v in pairs(arg_2_1) do
				tbl[k] = self[v]
			end

			self[var_2_0] = tbl

			return tbl
		end
	})[arg_1_0]
end

local function fn_2(arg_3_0, arg_3_1, arg_3_2)
	-- function 3
	if arg_3_0 == arg_3_1 then
		return nil, arg_3_2
	end

	local var_3_0 = type(arg_3_0)

	if var_3_0 == "function" then
		return nil, arg_3_2
	end

	if not (var_3_0 ~= "table" or type(arg_3_1) == "table") then
		return arg_3_0, true
	end

	local tbl = {}
	local flag = false

	for k, v in pairs(arg_3_0) do
		tbl[k], flag = fn_2(v, arg_3_1[k], flag)
	end

	if not flag then
		tbl = nil
	end

	return tbl, arg_3_2 or flag
end

local function fn_3(arg_4_0)
	-- function 4
	local tbl = {}

	arg_4_0(function (arg_5_0)
		-- function 5
		tbl[#tbl + 1] = arg_5_0
	end)

	return tbl
end

ImguiWeaponEditor = class(ImguiWeaponEditor)

ImguiWeaponEditor.init = function (self)
	-- function 6
	self._persistent = false
	self._tabs = {
		BoostCurves = BoostCurves,
		DamageProfileTemplates = DamageProfileTemplates,
		PowerLevelTemplates = PowerLevelTemplates,
		AttackTemplates = AttackTemplates,
		Weapons = Weapons,
		TerrorEventBlueprints = TerrorEventBlueprints
	}
	self._table_metadata = setmetatable({}, {
		__mode = "k",
		__index = function (self, arg_7_1)
			-- function 7
			local keys = table.keys(arg_7_1)

			table.sort(keys)

			local tbl = {
				new_value = "",
				new_key = "",
				keys = keys
			}

			self[arg_7_1] = tbl

			return tbl
		end
	})

	self:checkpoint()
end

ImguiWeaponEditor._defered_init = function (self)
	-- function 8
	if not self._defered_init_done then
		return
	end

	local tbl = {}

	for i = 1, #NetworkLookup.anims do
		tbl[i] = NetworkLookup.anims[i]
	end

	table.sort(tbl)

	self._lut_lut = {
		anim_end_event = tbl,
		anim_event = tbl,
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
		display_unit = fn_3(function (arg_9_0)
			-- function 9
			for k, v in pairs(WeaponSkins.skins) do
				if not v.data and not v.data.display_unit then
					arg_9_0(v.data.display_unit)
				end
			end
		end),
		first_person_hit_anim = tbl,
		hit_effect = table.keys(MaterialEffectMappings),
		hit_stop_anim = tbl,
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
		wield_anim = tbl
	}
	self._defered_init_done = true
end

ImguiWeaponEditor.checkpoint = function (self)
	-- function 10
	self._tabs0 = {
		BoostCurves = fn(BoostCurves),
		DamageProfileTemplates = fn(DamageProfileTemplates),
		PowerLevelTemplates = fn(PowerLevelTemplates),
		AttackTemplates = fn(AttackTemplates),
		Weapons = fn(Weapons)
	}
end

ImguiWeaponEditor.is_persistent = function (self)
	-- function 11
	return self._persistent
end

ImguiWeaponEditor.update = function (self)
	-- function 12
	self:_defered_init()
end

ImguiWeaponEditor.edit_table = function (self, arg_13_1)
	-- function 13
	local var_13_0 = self._table_metadata[arg_13_1]

	for i = 1, #var_13_0.keys do
		local var_13_1 = var_13_0.keys[i]
		local var_13_2 = arg_13_1[var_13_1]
		local var_13_3 = type(var_13_2)

		if var_13_3 == "table" then
			if not Imgui.tree_node(var_13_1, false) then
				var_13_0.new_key = Imgui.input_text("Key", var_13_0.new_key)
				var_13_0.new_value = Imgui.input_text("Value", var_13_0.new_value)

				if not Imgui.small_button("Add field") then
					local var_13_4
					local exec

					exec, var_13_0.error = self:exec("local t = ... return " .. var_13_0.new_value, var_13_2)

					if exec ~= nil then
						rawset(var_13_2, var_13_0.new_key, exec)

						var_13_0.keys[#var_13_0.keys + 1] = var_13_0.new_key
						var_13_0.new_key, var_13_0.new_value = "", ""
					end
				end

				if not var_13_0.error then
					Imgui.text_colored(var_13_0.error, 255, 100, 100, 255)
				end

				Imgui.separator()
				self:edit_table(var_13_2)
				Imgui.tree_pop()
			end
		elseif var_13_3 == "boolean" then
			arg_13_1[var_13_1] = Imgui.checkbox(var_13_1, var_13_2)
		elseif var_13_3 == "number" then
			arg_13_1[var_13_1] = Imgui.input_float(var_13_1, var_13_2)
		elseif var_13_3 == "string" then
			local var_13_6 = self._lut_lut[var_13_1]
			local var_13_7

			if not var_13_6 then
				var_13_7 = table.find(var_13_6, var_13_2)
			end

			if not var_13_7 then
				arg_13_1[var_13_1] = var_13_6[Imgui.combo(var_13_1, var_13_7, var_13_6)]
			else
				arg_13_1[var_13_1] = Imgui.input_text(var_13_1, var_13_2)
			end
		end
	end
end

ImguiWeaponEditor._apply_to_existing_items = function (arg_14_0)
	-- function 14
	for k, v in pairs(Managers.backend:get_interface("items")._modified_templates) do
		printf("[ImguiWeaponEditor] Updating %s (%s)", k, v.name)
		table.merge(v, WeaponUtils.get_weapon_template(v.name))
	end
end

ImguiWeaponEditor.draw = function (self, arg_15_1)
	-- function 15
	local begin_window = Imgui.begin_window("Weapon Editor", "menu_bar")

	self._persistent = Imgui.checkbox("Persistent window", self._persistent)

	if not Imgui.begin_menu_bar() then
		if not Imgui.menu_item("Load") then
			Managers.chat:add_local_system_message(1, "Stripped", true)
		end

		if not Imgui.menu_item("Save") then
			Managers.chat:add_local_system_message(1, "Stripped", true)
		end

		if not Imgui.menu_item("Refresh items") then
			self:_apply_to_existing_items()
		end

		Imgui.end_menu_bar()
	end

	Imgui.separator()
	Imgui.begin_child_window("Editor", 0, 0, true)
	self:edit_table(self._tabs)
	Imgui.end_child_window()
	Imgui.end_window()

	return begin_window
end
