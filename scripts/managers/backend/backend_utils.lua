-- chunkname: @scripts/managers/backend/backend_utils.lua

require("scripts/managers/backend_playfab/backend_manager_playfab")

BackendUtils = {}

local var_0_0 = {
	melee = "icons_placeholder_melee_01",
	ranged = "icons_placeholder_ranged_01",
	hat = "icons_placeholder_hat_01",
	trinket = "icons_placeholder_trinket_01"
}

BackendUtils.get_loadout_item_id = function (arg_1_0, arg_1_1, arg_1_2)
	local var_1_0 = Managers.backend:get_loadout_interface_by_slot(arg_1_1)

	if var_1_0 then
		return var_1_0:get_loadout_item_id(arg_1_0, arg_1_1, arg_1_2)
	end
end

BackendUtils.set_loadout_item = function (arg_2_0, arg_2_1, arg_2_2)
	local var_2_0 = Managers.backend:get_loadout_interface_by_slot(arg_2_2)

	if var_2_0 then
		var_2_0:set_loadout_item(arg_2_0, arg_2_1, arg_2_2)
	end
end

BackendUtils.get_loadout_item = function (arg_3_0, arg_3_1, arg_3_2)
	local var_3_0 = Managers.backend:get_interface("items")
	local var_3_1 = BackendUtils.get_loadout_item_id(arg_3_0, arg_3_1, arg_3_2)

	if not var_3_1 and CosmeticUtils.is_cosmetic_slot(arg_3_1) then
		local var_3_2 = PROFILES_BY_CAREER_NAMES[arg_3_0]
		local var_3_3 = CareerSettings[arg_3_0]

		if var_3_3.required_dlc and Managers.unlock:is_dlc_unlocked(var_3_3.required_dlc) then
			Crashify.print_exception("BackendUtils", "Failed to find loadout item in slot %q for career %q", arg_3_1, arg_3_0)
		end

		return
	end

	return var_3_0:get_item_from_id(var_3_1)
end

BackendUtils.try_set_loadout_item = function (arg_4_0, arg_4_1, arg_4_2)
	local var_4_0 = Managers.backend:get_interface("items"):get_item_from_key(arg_4_2)

	if var_4_0 then
		local var_4_1 = var_4_0.backend_id

		BackendUtils.set_loadout_item(var_4_1, arg_4_0, arg_4_1)
	elseif CosmeticUtils.is_cosmetic_slot(arg_4_1) then
		Crashify.print_exception("BackendUtils", "Failed to set loadout item %q in slot %q for career %q", arg_4_2, arg_4_1, arg_4_0)
	end

	return var_4_0
end

BackendUtils.get_item_from_masterlist = function (arg_5_0)
	local var_5_0 = Managers.backend:get_interface("items"):get_item_masterlist_data(arg_5_0)

	if var_5_0 then
		local var_5_1 = table.clone(var_5_0)

		var_5_1.backend_id = arg_5_0

		return var_5_1
	end
end

BackendUtils.get_hero_power_level_from_level = function (arg_6_0)
	local var_6_0 = PowerLevelFromLevelSettings
	local var_6_1 = ExperienceSettings.get_experience(arg_6_0)
	local var_6_2 = ExperienceSettings.get_level(var_6_1)

	return var_6_0.power_level_per_level * var_6_2
end

BackendUtils.get_hero_power_level = function (arg_7_0)
	local var_7_0 = PowerLevelFromLevelSettings
	local var_7_1 = ExperienceSettings.get_experience(arg_7_0)
	local var_7_2 = ExperienceSettings.get_level(var_7_1)

	return var_7_0.power_level_per_level * var_7_2 + var_7_0.starting_power_level
end

BackendUtils.get_average_item_power_level = function (arg_8_0)
	local var_8_0 = Managers.backend:get_interface("items")
	local var_8_1 = InventorySettings.equipment_slots
	local var_8_2 = 5
	local var_8_3 = 0

	for iter_8_0, iter_8_1 in pairs(var_8_1) do
		local var_8_4 = iter_8_1.name
		local var_8_5 = BackendUtils.get_loadout_item(arg_8_0, var_8_4)

		if var_8_5 then
			local var_8_6 = var_8_5.backend_id
			local var_8_7 = var_8_0:get_item_power_level(var_8_6)

			if var_8_7 then
				var_8_3 = var_8_3 + var_8_7
			end
		end
	end

	return var_8_3 / var_8_2
end

BackendUtils.get_total_power_level = function (arg_9_0, arg_9_1, arg_9_2)
	if script_data.power_level_override then
		return script_data.power_level_override
	end

	local var_9_0 = Managers.state.game_mode

	if var_9_0:has_activated_mutator("whiterun") then
		return MIN_POWER_LEVEL_CAP
	end

	local var_9_1 = arg_9_2 or var_9_0:game_mode_key()
	local var_9_2 = GameModeSettings[var_9_1]

	if var_9_2 and var_9_2.power_level_override then
		return var_9_2.power_level_override
	end

	return Managers.backend:get_total_power_level(arg_9_0, arg_9_1, var_9_1)
end

BackendUtils.get_item_template = function (arg_10_0, arg_10_1)
	local var_10_0 = Managers.backend:get_interface("items")
	local var_10_1 = arg_10_0.backend_id or arg_10_1

	return (var_10_0:get_item_template(arg_10_0, var_10_1))
end

BackendUtils.get_item_units = function (arg_11_0, arg_11_1, arg_11_2, arg_11_3)
	local var_11_0 = arg_11_0.left_hand_unit
	local var_11_1 = arg_11_0.right_hand_unit
	local var_11_2 = arg_11_0.ammo_unit
	local var_11_3 = arg_11_0.ammo_unit_3p
	local var_11_4 = arg_11_0.is_ammo_weapon
	local var_11_5 = arg_11_0.projectile_units_template
	local var_11_6 = arg_11_0.pickup_template_name
	local var_11_7 = arg_11_0.link_pickup_template_name
	local var_11_8 = arg_11_0.unit
	local var_11_9 = arg_11_0.material
	local var_11_10 = arg_11_0.hud_icon
	local var_11_11 = arg_11_0.backend_id or arg_11_1
	local var_11_12
	local var_11_13

	if arg_11_3 then
		var_11_0 = arg_11_0.left_hand_unit_override and arg_11_0.left_hand_unit_override[arg_11_3] or var_11_0
		var_11_1 = arg_11_0.right_hand_unit_override and arg_11_0.right_hand_unit_override[arg_11_3] or var_11_1
	end

	if var_11_11 or arg_11_2 then
		arg_11_2 = arg_11_2 or Managers.backend:get_interface("items"):get_skin(var_11_11)

		if arg_11_2 then
			local var_11_14 = WeaponSkins.skins[arg_11_2]

			var_11_0 = var_11_14.left_hand_unit
			var_11_1 = var_11_14.right_hand_unit
			var_11_2 = var_11_14.ammo_unit
			var_11_3 = var_11_14.ammo_unit_3p
			var_11_5 = var_11_14.projectile_units_template
			var_11_6 = var_11_14.pickup_template_name
			var_11_7 = var_11_14.link_pickup_template_name
			var_11_10 = var_11_14.hud_icon
			var_11_12 = arg_11_2
			var_11_13 = var_11_14.material_settings_name

			if arg_11_3 then
				var_11_0 = var_11_14.left_hand_unit_override and var_11_14.left_hand_unit_override[arg_11_3] or var_11_0
				var_11_1 = var_11_14.right_hand_unit_override and var_11_14.right_hand_unit_override[arg_11_3] or var_11_1
			end
		end
	end

	if arg_11_0.item_units_to_replace or var_11_0 or var_11_1 or var_11_8 or var_11_9 or var_11_10 then
		return {
			left_hand_unit = var_11_0,
			right_hand_unit = var_11_1,
			ammo_unit = var_11_2,
			ammo_unit_3p = var_11_3,
			projectile_units_template = var_11_5,
			pickup_template_name = var_11_6,
			link_pickup_template_name = var_11_7,
			is_ammo_weapon = var_11_4,
			unit = var_11_8,
			material = var_11_9,
			icon = var_11_10,
			skin = var_11_12,
			material_settings_name = var_11_13
		}
	end

	if arg_11_0.item_type ~= "chips" then
		fassert(false, "no left hand or right hand unit defined for : " .. (arg_11_0.backend_id or arg_11_0.display_name))
	end
end

BackendUtils.format_profile_hash = function (arg_12_0, arg_12_1, arg_12_2, arg_12_3)
	if not arg_12_0 then
		return "n/a"
	end

	local var_12_0 = ""

	for iter_12_0 = 1, arg_12_1, arg_12_2 do
		local var_12_1 = string.sub(arg_12_0, iter_12_0, iter_12_0 + arg_12_2 - 1)

		if var_12_0 == "" then
			var_12_0 = var_12_1
		else
			var_12_0 = string.format("%s%s%s", var_12_0, arg_12_3, var_12_1)
		end
	end

	return var_12_0
end

BackendUtils.has_loot_chest = function ()
	local var_13_0 = Managers.backend:get_interface("items")
	local var_13_1 = "slot_type == " .. ItemType.LOOT_CHEST

	return #var_13_0:get_filtered_items(var_13_1) > 0
end

local var_0_1 = {
	"dr_ranger",
	"dr_slayer",
	"dr_ironbreaker",
	"dr_engineer",
	"we_waywatcher",
	"we_shade",
	"we_maidenguard",
	"es_huntsman",
	"es_mercenary",
	"es_knight",
	"es_questingknight",
	"bw_adept",
	"bw_scholar",
	"bw_unchained",
	"wh_captain",
	"wh_bountyhunter",
	"wh_zealot",
	"we_thornsister",
	"wh_priest",
	"bw_necromancer"
}

BackendUtils.calculate_weave_score = function (arg_14_0, arg_14_1, arg_14_2)
	local var_14_0 = table.find(var_0_1, arg_14_2)

	return (math.floor((arg_14_0 * 100000 + arg_14_1) * 100 + var_14_0 - 2147483648))
end

BackendUtils.convert_weave_score = function (arg_15_0)
	local var_15_0 = arg_15_0 + 2147483648
	local var_15_1 = math.round((var_15_0 / 100 - math.floor(var_15_0 / 100)) * 100)
	local var_15_2 = var_0_1[var_15_1]
	local var_15_3 = math.floor(var_15_0 / 100)
	local var_15_4 = math.round((var_15_3 / 100000 - math.floor(var_15_3 / 100000)) * 100000)

	return math.floor(var_15_3 / 100000), var_15_4, var_15_2
end

BackendUtils.commit_load_time_data = function (arg_16_0)
	Managers.backend:get_interface("common"):commit_load_time_data(arg_16_0)
end

local var_0_2 = {
	SM = {
		"shillings_01",
		small = "shillings_small",
		[25] = "shillings_04",
		[10] = "shillings_03",
		[100] = "shillings_06",
		[5] = "shillings_02",
		[50] = "shillings_05",
		medium = "shillings_medium",
		large = "shillings_large"
	},
	VS = {
		small = "versus_currency_small",
		[25] = "versus_currency_02",
		[5] = "versus_currency_01",
		medium = "versus_currency_medium",
		large = "versus_currency_large",
		[50] = "versus_currency_03"
	}
}

CURRENCY_DESC_LOOKUP = {
	SM = "achv_menu_curreny_reward_claimed",
	ES = "achv_menu_es_currency_reward_claimed ",
	VS = "achv_menu_vs_currency_reward_claimed"
}

BackendUtils.get_fake_currency_item = function (arg_17_0, arg_17_1)
	local var_17_0 = var_0_2[arg_17_0]

	fassert(var_17_0, "Unsupported currency code '%s'", arg_17_0)

	local var_17_1 = var_17_0[arg_17_1]
	local var_17_2 = CURRENCY_DESC_LOOKUP[arg_17_0]

	if not var_17_1 then
		if arg_17_1 >= 1 and arg_17_1 < 50 then
			var_17_1 = var_0_2[arg_17_0].small
		elseif arg_17_1 >= 50 and arg_17_1 < 100 then
			var_17_1 = var_0_2[arg_17_0].medium
		else
			var_17_1 = var_0_2[arg_17_0].large
		end
	end

	local var_17_3 = Currencies[var_17_1]

	return table.clone(var_17_3), var_17_1, var_17_2
end

BackendUtils.best_aquired_power_level = function ()
	local var_18_0 = Managers.backend:get_interface("items"):sum_best_power_levels()
	local var_18_1 = ExperienceSettings.get_highest_character_level()

	return PowerLevelFromLevelSettings.starting_power_level + PowerLevelFromLevelSettings.power_level_per_level * var_18_1 + var_18_0 / 5
end
