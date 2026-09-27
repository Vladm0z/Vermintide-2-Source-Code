-- chunkname: @scripts/managers/backend/backend_utils.lua

require("scripts/managers/backend_playfab/backend_manager_playfab")

BackendUtils = {}

local tbl = {
	melee = "icons_placeholder_melee_01",
	ranged = "icons_placeholder_ranged_01",
	hat = "icons_placeholder_hat_01",
	trinket = "icons_placeholder_trinket_01"
}

BackendUtils.get_loadout_item_id = function (arg_1_0, arg_1_1, arg_1_2)
	-- function 1
	local get_loadout_interface_by_slot = Managers.backend:get_loadout_interface_by_slot(arg_1_1)

	if not get_loadout_interface_by_slot then
		return get_loadout_interface_by_slot:get_loadout_item_id(arg_1_0, arg_1_1, arg_1_2)
	end
end

BackendUtils.set_loadout_item = function (arg_2_0, arg_2_1, arg_2_2)
	-- function 2
	local get_loadout_interface_by_slot = Managers.backend:get_loadout_interface_by_slot(arg_2_2)

	if not get_loadout_interface_by_slot then
		get_loadout_interface_by_slot:set_loadout_item(arg_2_0, arg_2_1, arg_2_2)
	end
end

BackendUtils.get_loadout_item = function (arg_3_0, arg_3_1, arg_3_2)
	-- function 3
	local get_interface = Managers.backend:get_interface("items")
	local get_loadout_item_id = BackendUtils.get_loadout_item_id(arg_3_0, arg_3_1, arg_3_2)

	if get_loadout_item_id or not CosmeticUtils.is_cosmetic_slot(arg_3_1) then
		local var_3_2 = PROFILES_BY_CAREER_NAMES[arg_3_0]
		local var_3_3 = CareerSettings[arg_3_0]

		if not var_3_3.required_dlc and not Managers.unlock:is_dlc_unlocked(var_3_3.required_dlc) then
			Crashify.print_exception("BackendUtils", "Failed to find loadout item in slot %q for career %q", arg_3_1, arg_3_0)
		end

		return
	end

	return get_interface:get_item_from_id(get_loadout_item_id)
end

BackendUtils.try_set_loadout_item = function (arg_4_0, arg_4_1, arg_4_2)
	-- function 4
	local get_item_from_key = Managers.backend:get_interface("items"):get_item_from_key(arg_4_2)

	if not get_item_from_key then
		local backend_id = get_item_from_key.backend_id

		BackendUtils.set_loadout_item(backend_id, arg_4_0, arg_4_1)
	elseif not CosmeticUtils.is_cosmetic_slot(arg_4_1) then
		Crashify.print_exception("BackendUtils", "Failed to set loadout item %q in slot %q for career %q", arg_4_2, arg_4_1, arg_4_0)
	end

	return get_item_from_key
end

BackendUtils.get_item_from_masterlist = function (arg_5_0)
	-- function 5
	local get_item_masterlist_data = Managers.backend:get_interface("items"):get_item_masterlist_data(arg_5_0)

	if not get_item_masterlist_data then
		local clone = table.clone(get_item_masterlist_data)

		clone.backend_id = arg_5_0

		return clone
	end
end

BackendUtils.get_hero_power_level_from_level = function (arg_6_0)
	-- function 6
	local PowerLevelFromLevelSettings = PowerLevelFromLevelSettings
	local get_experience = ExperienceSettings.get_experience(arg_6_0)
	local get_level = ExperienceSettings.get_level(get_experience)

	return PowerLevelFromLevelSettings.power_level_per_level * get_level
end

BackendUtils.get_hero_power_level = function (arg_7_0)
	-- function 7
	local PowerLevelFromLevelSettings = PowerLevelFromLevelSettings
	local get_experience = ExperienceSettings.get_experience(arg_7_0)
	local get_level = ExperienceSettings.get_level(get_experience)

	return PowerLevelFromLevelSettings.power_level_per_level * get_level + PowerLevelFromLevelSettings.starting_power_level
end

BackendUtils.get_average_item_power_level = function (arg_8_0)
	-- function 8
	local get_interface = Managers.backend:get_interface("items")
	local equipment_slots = InventorySettings.equipment_slots
	local num = 5
	local num_2 = 0

	for k, v in pairs(equipment_slots) do
		local name = v.name
		local get_loadout_item = BackendUtils.get_loadout_item(arg_8_0, name)

		if not get_loadout_item then
			local backend_id = get_loadout_item.backend_id
			local get_item_power_level = get_interface:get_item_power_level(backend_id)

			if not get_item_power_level then
				num_2 = num_2 + get_item_power_level
			end
		end
	end

	return num_2 / num
end

BackendUtils.get_total_power_level = function (arg_9_0, arg_9_1, arg_9_2)
	-- function 9
	if not script_data.power_level_override then
		return script_data.power_level_override
	end

	local game_mode = Managers.state.game_mode

	if not game_mode:has_activated_mutator("whiterun") then
		return MIN_POWER_LEVEL_CAP
	end

	local flag = arg_9_2 or game_mode:game_mode_key()
	local var_9_2 = GameModeSettings[flag]

	if not var_9_2 and not var_9_2.power_level_override then
		return var_9_2.power_level_override
	end

	return Managers.backend:get_total_power_level(arg_9_0, arg_9_1, flag)
end

BackendUtils.get_item_template = function (self, arg_10_1)
	-- function 10
	local get_interface = Managers.backend:get_interface("items")
	local backend_id = self.backend_id

	backend_id = backend_id or arg_10_1

	return (get_interface:get_item_template(self, backend_id))
end

BackendUtils.get_item_units = function (self, arg_11_1, arg_11_2, arg_11_3)
	-- function 11
	local left_hand_unit = self.left_hand_unit
	local right_hand_unit = self.right_hand_unit
	local ammo_unit = self.ammo_unit
	local ammo_unit_3p = self.ammo_unit_3p
	local is_ammo_weapon = self.is_ammo_weapon
	local projectile_units_template = self.projectile_units_template
	local pickup_template_name = self.pickup_template_name
	local link_pickup_template_name = self.link_pickup_template_name
	local unit = self.unit
	local material = self.material
	local hud_icon = self.hud_icon
	local backend_id = self.backend_id

	backend_id = backend_id or arg_11_1

	local var_11_12
	local var_11_13

	if not arg_11_3 then
		left_hand_unit = not self.left_hand_unit_override and self.left_hand_unit_override[arg_11_3] and left_hand_unit
		right_hand_unit = not self.right_hand_unit_override and self.right_hand_unit_override[arg_11_3] and right_hand_unit
	end

	if backend_id or not arg_11_2 then
		arg_11_2 = arg_11_2 or Managers.backend:get_interface("items"):get_skin(backend_id)

		if not arg_11_2 then
			local var_11_14 = WeaponSkins.skins[arg_11_2]

			left_hand_unit = var_11_14.left_hand_unit
			right_hand_unit = var_11_14.right_hand_unit
			ammo_unit = var_11_14.ammo_unit
			ammo_unit_3p = var_11_14.ammo_unit_3p
			projectile_units_template = var_11_14.projectile_units_template
			pickup_template_name = var_11_14.pickup_template_name
			link_pickup_template_name = var_11_14.link_pickup_template_name
			hud_icon = var_11_14.hud_icon
			var_11_12 = arg_11_2
			var_11_13 = var_11_14.material_settings_name

			if not arg_11_3 then
				left_hand_unit = not var_11_14.left_hand_unit_override and var_11_14.left_hand_unit_override[arg_11_3] and left_hand_unit
				right_hand_unit = not var_11_14.right_hand_unit_override and var_11_14.right_hand_unit_override[arg_11_3] and right_hand_unit
			end
		end
	end

	if self.item_units_to_replace or left_hand_unit or right_hand_unit or unit or material or not hud_icon then
		return {
			left_hand_unit = left_hand_unit,
			right_hand_unit = right_hand_unit,
			ammo_unit = ammo_unit,
			ammo_unit_3p = ammo_unit_3p,
			projectile_units_template = projectile_units_template,
			pickup_template_name = pickup_template_name,
			link_pickup_template_name = link_pickup_template_name,
			is_ammo_weapon = is_ammo_weapon,
			unit = unit,
			material = material,
			icon = hud_icon,
			skin = var_11_12,
			material_settings_name = var_11_13
		}
	end

	if self.item_type ~= "chips" then
		local fassert = fassert
		local flag = false
		local str = "no left hand or right hand unit defined for : "
		local backend_id_2 = self.backend_id

		backend_id_2 = backend_id_2 or self.display_name

		fassert(flag, str .. backend_id_2)
	end
end

BackendUtils.format_profile_hash = function (arg_12_0, arg_12_1, arg_12_2, arg_12_3)
	-- function 12
	if not arg_12_0 then
		return "n/a"
	end

	local str = ""

	for i = 1, arg_12_1, arg_12_2 do
		local sub = string.sub(arg_12_0, i, i + arg_12_2 - 1)

		if str == "" then
			str = sub
		else
			str = string.format("%s%s%s", str, arg_12_3, sub)
		end
	end

	return str
end

BackendUtils.has_loot_chest = function ()
	-- function 13
	local get_interface = Managers.backend:get_interface("items")
	local str = "slot_type == " .. ItemType.LOOT_CHEST

	return #get_interface:get_filtered_items(str) > 0
end

local tbl_2 = {
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
	-- function 14
	local find = table.find(tbl_2, arg_14_2)

	return (math.floor((arg_14_0 * 100000 + arg_14_1) * 100 + find - 2147483648))
end

BackendUtils.convert_weave_score = function (arg_15_0)
	-- function 15
	local num = arg_15_0 + 2147483648
	local round = math.round((num / 100 - math.floor(num / 100)) * 100)
	local var_15_2 = tbl_2[round]
	local floor = math.floor(num / 100)
	local round_2 = math.round((floor / 100000 - math.floor(floor / 100000)) * 100000)

	return math.floor(floor / 100000), round_2, var_15_2
end

BackendUtils.commit_load_time_data = function (arg_16_0)
	-- function 16
	Managers.backend:get_interface("common"):commit_load_time_data(arg_16_0)
end

local tbl_3 = {
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
	-- function 17
	local var_17_0 = tbl_3[arg_17_0]

	fassert(var_17_0, "Unsupported currency code '%s'", arg_17_0)

	local var_17_1 = var_17_0[arg_17_1]
	local var_17_2 = CURRENCY_DESC_LOOKUP[arg_17_0]

	if not var_17_1 then
		if not (not (arg_17_1 >= 1) or not (arg_17_1 < 50)) then
			var_17_1 = tbl_3[arg_17_0].small
		elseif not (not (arg_17_1 >= 50) or not (arg_17_1 < 100)) then
			var_17_1 = tbl_3[arg_17_0].medium
		else
			var_17_1 = tbl_3[arg_17_0].large
		end
	end

	local var_17_3 = Currencies[var_17_1]

	return table.clone(var_17_3), var_17_1, var_17_2
end

BackendUtils.best_aquired_power_level = function ()
	-- function 18
	local sum_best_power_levels = Managers.backend:get_interface("items"):sum_best_power_levels()
	local get_highest_character_level = ExperienceSettings.get_highest_character_level()

	return PowerLevelFromLevelSettings.starting_power_level + PowerLevelFromLevelSettings.power_level_per_level * get_highest_character_level + sum_best_power_levels / 5
end
