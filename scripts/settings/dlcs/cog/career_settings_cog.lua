-- chunkname: @scripts/settings/dlcs/cog/career_settings_cog.lua

CareerActionNames.dwarf_ranger[#CareerActionNames.dwarf_ranger + 1] = "action_career_dr_4"

setmetatable(PlayerBreeds.hero_dr_engineer, {
	__newindex = function(arg_1_0, arg_1_1, arg_1_2)
		if type(arg_1_1) == "number" then
			error("HON-32308. Trying to modify read only table.")
		end

		rawset(arg_1_0, arg_1_1, arg_1_2)
	end
})

CareerSettings.dr_engineer = {
	profile_name = "dwarf_ranger",
	display_name = "dr_engineer",
	sound_character = "dwarf_engineer",
	package_name = "resource_packages/careers/dr_engineer",
	name = "dr_engineer",
	preview_idle_animation = "career_idle_04",
	preview_animation = "career_select_04",
	icon = "icons_placeholder",
	base_skin = "skin_dr_engineer",
	picking_image = "medium_unit_frame_portrait_bardin_engineer",
	preview_wield_slot = "ranged",
	playfab_name = "dr_4",
	category_image = "icons_placeholder",
	should_reload_career_weapon = true,
	portrait_image_picking = "picking_portrait_bardin_engineer",
	talent_tree_index = 4,
	description = "bardin_4_desc",
	portrait_image = "unit_frame_portrait_bardin_engineer",
	portrait_thumbnail = "portrait_bardin_engineer_thumbnail",
	sort_order = 4,
	required_dlc = "cog",
	breed = PlayerBreeds.hero_dr_engineer,
	item_types = {},
	activated_ability = ActivatedAbilitySettings.dr_4,
	passive_ability = PassiveAbilitySettings.dr_4,
	attributes = {
		base_critical_strike_chance = 0.05,
		max_hp = 125
	},
	video = {
		material_name = "dr_engineer",
		resource = "video/career_videos/bardin/dr_engineer"
	},
	preview_items = {
		{
			item_name = "bardin_engineer_career_skill_weapon_preview"
		},
		{
			item_name = "engineer_hat_0000"
		}
	},
	is_unlocked_function = function(arg_2_0, arg_2_1, arg_2_2)
		local var_2_0, var_2_1 = arg_2_0:override_available_for_mechanism()

		if not var_2_0 then
			return var_2_0, var_2_1
		end

		local var_2_2
		local var_2_3, var_2_4, var_2_5 = arg_2_0:is_dlc_unlocked()
		local var_2_6 = var_2_5
		local var_2_7 = var_2_4

		if not var_2_3 then
			return false, var_2_7, var_2_6
		end

		return true, var_2_7, var_2_6
	end,
	is_dlc_unlocked = function(arg_3_0)
		if Managers.unlock:is_dlc_unlocked("cog") then
			return true, nil, "cog"
		else
			return false, "dlc_not_owned", "cog"
		end
	end,
	override_available_for_mechanism = function(arg_4_0)
		local var_4_0 = Managers.mechanism:mechanism_setting_for_title("override_career_availability")
		local var_4_1 = arg_4_0.display_name

		if var_4_0 and var_4_0[var_4_1] == false then
			return false, "disabled_for_mechanism"
		end

		return true
	end,
	animation_variables = {
		is_engineer = 1
	},
	talent_packages = function(arg_5_0, arg_5_1, arg_5_2, arg_5_3)
		local var_5_0 = 1

		for iter_5_0, iter_5_1 in ipairs(arg_5_0) do
			local var_5_1 = TalentUtils.get_talent_by_id("dwarf_ranger", iter_5_1)

			if var_5_1 and var_5_1.talent_career_weapon_index then
				var_5_0 = var_5_1.talent_career_weapon_index
			end
		end

		local var_5_2 = ActivatedAbilitySettings.dr_4[1].weapon_names_by_index[var_5_0]
		local var_5_3 = ItemMasterList[var_5_2]
		local var_5_4 = WeaponUtils.get_weapon_template(var_5_3.template)
		local var_5_5 = "dr_engineer"
		local var_5_6 = WeaponUtils.get_weapon_packages(var_5_4, var_5_3, arg_5_2, var_5_5)

		for iter_5_2 = 1, #var_5_6 do
			arg_5_1[var_5_6[iter_5_2]] = false
		end
	end,
	item_slot_types_by_slot_name = {
		slot_melee = {
			"melee"
		},
		slot_ranged = {
			"ranged"
		},
		slot_necklace = {
			"necklace"
		},
		slot_ring = {
			"ring"
		},
		slot_trinket_1 = {
			"trinket"
		},
		slot_hat = {
			"hat"
		},
		slot_skin = {
			"skin"
		},
		slot_frame = {
			"frame"
		},
		slot_pose = {
			"weapon_pose"
		}
	},
	loadout_equipment_slots = {
		"melee",
		"ranged",
		"necklace",
		"ring",
		"trinket",
		"weapon_pose"
	},
	additional_item_slots = {
		slot_grenade = 2
	}
}
OverchargeData = OverchargeData or {}
OverchargeData.dr_engineer = {
	overcharge_threshold = 10,
	overcharge_warning_critical_sound_event = "drakegun_overcharge_warning_critical",
	time_until_overcharge_decreases = 0.25,
	overcharge_warning_low_sound_event = "drakegun_overcharge_warning_low",
	overcharge_value_decrease_rate = 1.3,
	overcharge_warning_high_sound_event = "drakegun_overcharge_warning_high",
	explosion_template = "overcharge_explosion_dwarf",
	overcharge_warning_med_sound_event = "drakegun_overcharge_warning_med",
	hit_overcharge_threshold_sound = "ui_special_attack_ready"
}
PlayerUnitStatusSettings = PlayerUnitStatusSettings or {}
PlayerUnitStatusSettings.overcharge_values = table.merge(PlayerUnitStatusSettings.overcharge_values or {}, {
	cog_hammer_charge_light = 3,
	cog_hammer_heavy_1_burn = 10,
	cog_hammer_heavy_1_explosion = 40
})
CareerNameAchievementMapping.dr_engineer = "engineer"
