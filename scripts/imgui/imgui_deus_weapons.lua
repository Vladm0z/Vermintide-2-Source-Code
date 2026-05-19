-- chunkname: @scripts/imgui/imgui_deus_weapons.lua

ImguiDeusWeapons = class(ImguiDeusWeapons)

local var_0_0 = {
	"plentiful",
	"common",
	"rare",
	"exotic",
	"unique"
}
local var_0_1 = {
	"normal",
	"hard",
	"harder",
	"hardest",
	"cataclysm"
}

local function var_0_2(arg_1_0, arg_1_1, arg_1_2, arg_1_3, arg_1_4, arg_1_5, arg_1_6)
	arg_1_1 = Imgui.combo("Select weapon group", arg_1_1, arg_1_0)
	arg_1_3 = Imgui.combo("Select rarity", arg_1_3, arg_1_2)
	arg_1_5 = Imgui.combo("Select difficulty (affects powerlevel)", arg_1_5, arg_1_4)
	arg_1_6 = Imgui.slider_float("Run progress (affects powerlevel)", arg_1_6, 0, 0.999)

	return arg_1_1, arg_1_3, arg_1_5, arg_1_6
end

local function var_0_3(arg_2_0, arg_2_1, arg_2_2)
	local var_2_0 = Managers.backend:get_interface("deus")

	var_2_0:grant_deus_weapon(arg_2_0)
	var_2_0:refresh_deus_weapons_in_items_backend()

	local var_2_1 = arg_2_0.backend_id
	local var_2_2 = arg_2_0.data.slot_type
	local var_2_3
	local var_2_4 = InventorySettings.slots_by_slot_index

	for iter_2_0, iter_2_1 in pairs(var_2_4) do
		if var_2_2 == iter_2_1.type then
			var_2_3 = iter_2_1.name
		end
	end

	BackendUtils.set_loadout_item(var_2_1, arg_2_1, var_2_3)
	arg_2_2:create_equipment_in_slot(var_2_3, var_2_1)
end

local function var_0_4(arg_3_0)
	local var_3_0, var_3_1, var_3_2, var_3_3 = UIUtils.get_ui_information_from_item(arg_3_0)
	local var_3_4 = Colors.get_table(arg_3_0.rarity)

	Imgui.text_colored(" === " .. Localize(var_3_1) .. " === ", var_3_4[2], var_3_4[3], var_3_4[4], var_3_4[1])
	Imgui.spacing()
	Imgui.text("type: " .. Localize(arg_3_0.data.item_type))
	Imgui.text("slot: " .. arg_3_0.data.slot_type)
	Imgui.text("rarity: " .. arg_3_0.rarity)
	Imgui.text("power_level: " .. arg_3_0.power_level)

	if arg_3_0.traits then
		Imgui.text("traits:")

		for iter_3_0, iter_3_1 in ipairs(arg_3_0.traits) do
			Imgui.text("  - " .. iter_3_1)
		end
	end

	if arg_3_0.properties then
		Imgui.text("props:")

		for iter_3_2, iter_3_3 in pairs(arg_3_0.properties) do
			Imgui.text("  - " .. iter_3_2 .. ": " .. iter_3_3)
		end
	end

	if arg_3_0.skin then
		Imgui.text("skin: " .. arg_3_0.skin)
	end
end

local function var_0_5(arg_4_0, arg_4_1, arg_4_2)
	for iter_4_0, iter_4_1 in ipairs(arg_4_0) do
		if not arg_4_2[iter_4_1] then
			arg_4_2[iter_4_1] = 0.75
		end

		if arg_4_1 == "unique" then
			arg_4_2[iter_4_1] = 1
		else
			local var_4_0 = Imgui.slider_float("Set Property " .. iter_4_1 .. " power", arg_4_2[iter_4_1], 0, 1)

			arg_4_2[iter_4_1] = math.round_with_precision(var_4_0, 3)
		end
	end

	return arg_4_2
end

local function var_0_6(arg_5_0, arg_5_1, arg_5_2, arg_5_3, arg_5_4, arg_5_5)
	local var_5_0 = arg_5_0:get_weapon_pool()
	local var_5_1, var_5_2 = arg_5_0:get_slot_chances()
	local var_5_3 = math.random_seed()
	local var_5_4 = DeusWeaponGeneration.generate_weapon(arg_5_4, arg_5_3, arg_5_2, var_5_3, var_5_0, var_5_1, var_5_2)

	arg_5_0:remove_weapon_from_pool(arg_5_2, var_5_4.deus_item_key)
	var_0_3(var_5_4, arg_5_5, arg_5_1)
end

function ImguiDeusWeapons.init(arg_6_0)
	arg_6_0._next_weapon_time = 0
end

function ImguiDeusWeapons.update(arg_7_0)
	local var_7_0 = Managers.player:local_human_player()

	if not var_7_0 then
		return
	end

	local var_7_1 = Managers.mechanism:game_mechanism()
	local var_7_2 = var_7_1 and var_7_1.get_deus_run_controller and var_7_1:get_deus_run_controller()

	if not var_7_2 then
		return
	end

	local var_7_3 = var_7_0:profile_index()
	local var_7_4 = var_7_0:career_index()

	if not var_7_4 then
		return
	end

	if arg_7_0._career_index ~= var_7_4 or arg_7_0._profile_index ~= var_7_3 then
		local var_7_5 = SPProfiles[var_7_3].careers[var_7_4].name

		arg_7_0._available_weapon_groups = {}

		for iter_7_0, iter_7_1 in pairs(DeusWeaponGroups) do
			local var_7_6 = DeusWeaponGroups[iter_7_0]

			if var_7_6 and table.contains(var_7_6.can_wield, var_7_5) then
				arg_7_0._available_weapon_groups[#arg_7_0._available_weapon_groups + 1] = iter_7_0
			end
		end

		arg_7_0._career_index = var_7_4
		arg_7_0._profile_index = var_7_3
		arg_7_0._career_name = var_7_5

		arg_7_0:_reset_base_weapon_selection_data()
	end

	if arg_7_0._equip_random_weapon then
		local var_7_7 = Managers.time:time("game")

		if var_7_7 > arg_7_0._next_weapon_time then
			local var_7_8 = arg_7_0:_get_inventory_extension()

			if var_7_8 and not var_7_8:resyncing_loadout() then
				var_0_6(var_7_2, var_7_8, var_0_0[arg_7_0._selected_rarity_index or 1], arg_7_0._run_progress or 0, var_0_1[arg_7_0._difficulty_index or 1], arg_7_0._career_name)
			end

			arg_7_0._next_weapon_time = var_7_7 + 2
		end
	end
end

function ImguiDeusWeapons.on_round_end(arg_8_0, ...)
	arg_8_0._equip_random_weapon = false
end

function ImguiDeusWeapons.on_venture_end(arg_9_0, ...)
	arg_9_0._equip_random_weapon = false
end

function ImguiDeusWeapons.is_persistent(arg_10_0)
	return false
end

function ImguiDeusWeapons.draw(arg_11_0, arg_11_1)
	if not Managers.state or not Managers.state.game_mode or Managers.state.game_mode:game_mode_key() ~= "deus" then
		local var_11_0 = Imgui.begin_window("DeusWeapons", "always_auto_resize")

		Imgui.text("This UI only works when playing a deus level.")
		Imgui.end_window()

		return var_11_0
	end

	local var_11_1 = Imgui.begin_window("DeusWeapons", "always_auto_resize")

	Imgui.spacing()
	Imgui.text("Select Weapon Group:")

	arg_11_0._selected_weapon_group_index, arg_11_0._selected_rarity_index, arg_11_0._difficulty_index, arg_11_0._run_progress = var_0_2(arg_11_0._available_weapon_groups, arg_11_0._selected_weapon_group_index, var_0_0, arg_11_0._selected_rarity_index, var_0_1, arg_11_0._difficulty_index, arg_11_0._run_progress)

	local var_11_2 = DeusWeaponGroups[arg_11_0._available_weapon_groups[arg_11_0._selected_weapon_group_index]]
	local var_11_3 = var_0_1[arg_11_0._difficulty_index]
	local var_11_4 = var_0_0[arg_11_0._selected_rarity_index]
	local var_11_5 = var_11_2.items_per_rarity[var_11_4]
	local var_11_6 = var_11_5 and #var_11_5 > 0 and var_11_5 or {
		var_11_2.default
	}

	Imgui.spacing()
	Imgui.text("Select Item From Group:")

	arg_11_0._selected_item_key_index = Imgui.combo("Select item key", arg_11_0._selected_item_key_index, var_11_6)

	local var_11_7 = var_11_6[arg_11_0._selected_item_key_index]

	if arg_11_0._prev_item_key ~= var_11_7 or arg_11_0._prev_difficulty_index ~= arg_11_0._difficulty_index or arg_11_0._prev_rarity ~= var_11_4 or arg_11_0._prev_run_progress ~= arg_11_0._run_progress then
		arg_11_0:_reset_weapon_setting_data(var_11_7, var_11_3, arg_11_0._run_progress, var_11_4)

		arg_11_0._prev_item_key = var_11_7
		arg_11_0._prev_difficulty_index = arg_11_0._difficulty_index
		arg_11_0._prev_rarity = var_11_4
		arg_11_0._prev_run_progress = arg_11_0._run_progress
	end

	local var_11_8 = arg_11_0._available_archetypes and #arg_11_0._available_archetypes > 0
	local var_11_9 = arg_11_0._available_property_combinations and #arg_11_0._available_property_combinations > 0
	local var_11_10 = arg_11_0._available_trait_combinations and #arg_11_0._available_trait_combinations > 0
	local var_11_11 = arg_11_0._available_skins and #arg_11_0._available_skins > 0

	if var_11_8 or var_11_9 or var_11_10 or var_11_11 then
		Imgui.spacing()
		Imgui.text("Select Properties, Traits and/or Skins:")
	end

	if var_11_8 then
		arg_11_0._selected_archetype_index = Imgui.combo("Select archetype", arg_11_0._selected_archetype_index, arg_11_0._available_archetypes)

		local var_11_12 = DeusWeaponArchetypes[arg_11_0._available_archetypes[arg_11_0._selected_archetype_index]]

		arg_11_0._properties = var_11_12.properties
		arg_11_0._traits = var_11_12.traits
	end

	if var_11_9 then
		arg_11_0._selected_property_index = Imgui.combo("Select property combination", arg_11_0._selected_property_index, arg_11_0._available_property_combinations_string)

		if arg_11_0._prev_selected_property_index ~= arg_11_0._selected_property_index then
			arg_11_0._properties = {}
		end

		arg_11_0._prev_selected_property_index = arg_11_0._selected_property_index

		local var_11_13 = arg_11_0._available_property_combinations[arg_11_0._selected_property_index]

		arg_11_0._properties = var_0_5(var_11_13, var_11_4, arg_11_0._properties)
	end

	if var_11_10 then
		arg_11_0._selected_trait_index = Imgui.combo("Select trait", arg_11_0._selected_trait_index, arg_11_0._available_trait_combinations_string)
		arg_11_0._traits = arg_11_0._available_trait_combinations[arg_11_0._selected_trait_index]
	end

	if var_11_11 then
		arg_11_0._selected_skin_index = Imgui.combo("Select skin", arg_11_0._selected_skin_index, arg_11_0._available_skins)
		arg_11_0._skin = arg_11_0._available_skins[arg_11_0._selected_skin_index]
	end

	Imgui.spacing()

	local var_11_14 = not arg_11_0._weapon or arg_11_0._weapon.deus_item_key ~= var_11_7

	for iter_11_0, iter_11_1 in pairs(arg_11_0._properties) do
		var_11_14 = var_11_14 or arg_11_0._weapon.properties[iter_11_0] ~= arg_11_0._properties[iter_11_0]
	end

	var_11_14 = var_11_14 or not table.compare(arg_11_0._weapon.traits, arg_11_0._traits)
	var_11_14 = var_11_14 or arg_11_0._weapon.skin ~= arg_11_0._skin
	var_11_14 = var_11_14 or arg_11_0._weapon.rarity ~= var_11_4
	var_11_14 = var_11_14 or arg_11_0._weapon.power_level ~= arg_11_0._powerlevel

	if var_11_14 then
		arg_11_0._weapon = DeusWeaponGeneration.create_weapon(var_11_7, arg_11_0._properties and table.clone(arg_11_0._properties), arg_11_0._traits and table.clone(arg_11_0._traits), arg_11_0._skin, arg_11_0._powerlevel, var_11_4)
	end

	if arg_11_0._weapon then
		Imgui.text("Weapon:")
		var_0_4(arg_11_0._weapon)
	end

	Imgui.spacing()

	if arg_11_0._weapon and Imgui.button("Equip") then
		local var_11_15 = arg_11_0:_get_inventory_extension()

		if var_11_15 and not var_11_15:resyncing_loadout() then
			var_0_3(arg_11_0._weapon, arg_11_0._career_name, var_11_15)

			local var_11_16 = Managers.mechanism:game_mechanism():get_deus_run_controller()
			local var_11_17 = arg_11_0._weapon.data.slot_type
			local var_11_18
			local var_11_19 = InventorySettings.slots_by_slot_index

			for iter_11_2, iter_11_3 in pairs(var_11_19) do
				if var_11_17 == iter_11_3.type then
					var_11_18 = iter_11_3.name
				end
			end

			var_11_16:save_loadout(arg_11_0._weapon, var_11_18)
		end
	end

	Imgui.spacing()
	Imgui.spacing()
	Imgui.spacing()
	Imgui.spacing()

	arg_11_0._equip_random_weapon = Imgui.checkbox("equip random weapons automatically", arg_11_0._equip_random_weapon or false)

	Imgui.end_window()

	return var_11_1
end

function ImguiDeusWeapons._reset_base_weapon_selection_data(arg_12_0)
	arg_12_0._selected_weapon_group_index = 1
	arg_12_0._selected_rarity_index = 1
	arg_12_0._selected_item_key_index = 1
	arg_12_0._difficulty_index = 1
	arg_12_0._run_progress = 0
	arg_12_0._weapon = nil
end

function ImguiDeusWeapons._reset_weapon_setting_data(arg_13_0, arg_13_1, arg_13_2, arg_13_3, arg_13_4)
	arg_13_0._powerlevel, arg_13_0._available_archetypes, arg_13_0._available_property_combinations, arg_13_0._available_trait_combinations, arg_13_0._available_skins = DeusWeaponGeneration.get_possibilities_for_item_key(arg_13_1, arg_13_2, arg_13_3, arg_13_4)
	arg_13_0._run_progress = arg_13_3
	arg_13_0._available_property_combinations_string = {}

	if arg_13_0._available_property_combinations then
		for iter_13_0, iter_13_1 in ipairs(arg_13_0._available_property_combinations) do
			arg_13_0._available_property_combinations_string[#arg_13_0._available_property_combinations_string + 1] = table.concat(iter_13_1, ", ")
		end
	end

	arg_13_0._available_trait_combinations_string = {}

	if arg_13_0._available_trait_combinations then
		for iter_13_2, iter_13_3 in ipairs(arg_13_0._available_trait_combinations) do
			arg_13_0._available_trait_combinations_string[#arg_13_0._available_trait_combinations_string + 1] = table.concat(iter_13_3, ", ")
		end
	end

	arg_13_0._selected_archetype_index = 1
	arg_13_0._selected_property_index = 1
	arg_13_0._selected_trait_index = 1
	arg_13_0._selected_skin_index = 1
	arg_13_0._properties = {}
	arg_13_0._traits = {}
	arg_13_0._skin = nil
end

function ImguiDeusWeapons._get_inventory_extension(arg_14_0)
	local var_14_0 = Managers.player:local_player()

	if not var_14_0 then
		return
	end

	local var_14_1 = var_14_0.player_unit

	if not var_14_1 then
		return
	end

	return (ScriptUnit.extension(var_14_1, "inventory_system"))
end
