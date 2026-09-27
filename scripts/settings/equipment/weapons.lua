-- chunkname: @scripts/settings/equipment/weapons.lua

require("scripts/settings/attachment_node_linking")
require("scripts/unit_extensions/generic/interactions")
require("scripts/settings/profiles/career_settings")
require("scripts/helpers/weapon_utils")
dofile("scripts/settings/explosion_templates")
dofile("scripts/settings/equipment/hit_mass_counts")
require("scripts/settings/equipment/attack_templates")
require("scripts/settings/equipment/power_level_settings")
require("scripts/settings/equipment/power_level_templates")
require("scripts/settings/equipment/damage_profile_templates")
require("scripts/utils/action_assert_funcs")
dofile("scripts/settings/equipment/projectiles")
dofile("scripts/settings/equipment/light_weight_projectiles")
require("scripts/settings/action_templates")

DamageTypes = {
	STAGGER = 4,
	DAMAGE = 5,
	SPEED = 3,
	CLEAVE = 2,
	ARMOR_PIERCING = 1
}

local Weapons = Weapons

Weapons = Weapons or {}
Weapons = Weapons

local var_0_1 = dofile("scripts/settings/equipment/honduras_weapon_templates")

for k, v in pairs(DLCSettings) do
	if not v.weapon_template_file_names then
		table.append(var_0_1, v.weapon_template_file_names)
	end
end

for k_2 = 1, #var_0_1 do
	local var_0_2 = var_0_1[k_2]
	local var_0_3 = dofile(var_0_2)

	if not var_0_3 then
		for k_3, v_2 in pairs(var_0_3) do
			local actions = v_2.actions
			local tbl = {}

			v_2.required_projectile_unit_templates = tbl

			for k_4, v_3 in pairs(actions) do
				for k_5, v_4 in pairs(v_3) do
					local projectile_info = v_4.projectile_info

					if not projectile_info then
						local projectile_units_template = projectile_info.projectile_units_template

						if not projectile_units_template then
							tbl[projectile_units_template] = projectile_info.use_weapon_skin == true
						end
					end
				end
			end

			Weapons[k_3] = v_2
		end
	end
end

table.clear(var_0_1)

DAMAGE_TYPES_AOE = {
	warpfire_face = true,
	vomit_face = true,
	vomit_ground = true,
	poison = true,
	plague_face = true,
	warpfire_ground = true
}

local function fn(arg_1_0, arg_1_1, arg_1_2)
	-- function 1
	return arg_1_2 > math.abs(arg_1_0 - arg_1_1)
end

local tbl_2 = {}

local function fn_2(arg_2_0, arg_2_1, arg_2_2, arg_2_3, arg_2_4, arg_2_5)
	-- function 2
	if not ScriptUnit.has_extension(arg_2_1, "buff_system") then
		table.clear(tbl_2)

		tbl_2.attacker_unit = arg_2_2
		tbl_2.damage_source = arg_2_3
		tbl_2.power_level = arg_2_4
		tbl_2.source_attacker_unit = arg_2_5

		ScriptUnit.extension(arg_2_1, "buff_system"):add_buff(arg_2_0, tbl_2)
	end
end

local function fn_3(arg_3_0, arg_3_1, arg_3_2, arg_3_3, arg_3_4, arg_3_5)
	-- function 3
	if not ScriptUnit.has_extension(arg_3_1, "buff_system") then
		table.clear(tbl_2)

		tbl_2.attacker_unit = arg_3_2
		tbl_2.damage_source = arg_3_3
		tbl_2.power_level = arg_3_4
		tbl_2.source_attacker_unit = arg_3_5

		Managers.state.entity:system("buff_system"):add_buff_synced(arg_3_1, arg_3_0, BuffSyncType.All, tbl_2)

		if not arg_3_5 then
			local unit_breed = AiUtils.unit_breed(arg_3_1)

			if not (not unit_breed and unit_breed.is_hero) then
				AiUtils.alert_unit_of_enemy(arg_3_1, arg_3_5)
			end
		end
	end
end

Dots = {
	poison_dot = function (arg_4_0, arg_4_1, arg_4_2, arg_4_3, arg_4_4, arg_4_5, arg_4_6, arg_4_7, arg_4_8, arg_4_9, arg_4_10)
		-- function 4
		local var_4_0

		if not arg_4_1 then
			var_4_0 = arg_4_1.targets[arg_4_2] or arg_4_1.default_target
			arg_4_0 = arg_4_0 or var_4_0.dot_template_name or arg_4_1.dot_template_name
		end

		if not arg_4_0 then
			return false
		end

		local flag = true
		local unit_breed = AiUtils.unit_breed(arg_4_4)
		local get_data = Unit.get_data(arg_4_4, "armor")
		local get_target_armor = ActionUtils.get_target_armor(arg_4_6, unit_breed, get_data)

		if not (not var_4_0 and get_target_armor ~= 2) then
			local var_4_5 = BoostCurves[var_4_0.boost_curve_type]

			if DamageUtils.calculate_damage(DamageOutput, arg_4_4, arg_4_5, arg_4_6, arg_4_3, var_4_5, arg_4_8, arg_4_9, arg_4_1, arg_4_2, false, arg_4_7) <= 0 then
				flag = false
			end
		end

		if not flag then
			fn_2(arg_4_0, arg_4_4, arg_4_5, arg_4_7, arg_4_3, arg_4_10)
		end

		return flag
	end,
	burning_dot = function (arg_5_0, arg_5_1, arg_5_2, arg_5_3, arg_5_4, arg_5_5, arg_5_6, arg_5_7, arg_5_8, arg_5_9, arg_5_10)
		-- function 5
		if not (not arg_5_1 and arg_5_0) then
			local var_5_0 = arg_5_1.targets[arg_5_2]

			var_5_0 = var_5_0 or arg_5_1.default_target
			arg_5_0 = var_5_0.dot_template_name or arg_5_1.dot_template_name
		end

		if not arg_5_0 then
			return false
		end

		local unit_breed = AiUtils.unit_breed(arg_5_4)

		if not (not unit_breed and unit_breed.is_hero) then
			local has_extension = ScriptUnit.has_extension(arg_5_5, "talent_system")

			has_extension = has_extension or ScriptUnit.has_extension(arg_5_10, "talent_system")
			arg_5_0 = not has_extension and not has_extension:has_talent("sienna_adept_infinite_burn") and InfiniteBurnDotLookup[arg_5_0] and arg_5_0

			local has_extension_2 = ScriptUnit.has_extension(arg_5_5, "buff_system")

			if not has_extension_2 then
				has_extension_2:trigger_procs("on_enemy_ignited", arg_5_0, arg_5_1, arg_5_2, arg_5_4, arg_5_6, arg_5_7, arg_5_9)
			end
		end

		fn_3(arg_5_0, arg_5_4, arg_5_5, arg_5_7, arg_5_3, arg_5_10)

		return true
	end,
	slow_debuff = function (arg_6_0, arg_6_1, arg_6_2, arg_6_3, arg_6_4, arg_6_5, arg_6_6, arg_6_7, arg_6_8, arg_6_9, arg_6_10)
		-- function 6
		if not (not arg_6_1 and arg_6_0) then
			local var_6_0 = arg_6_1.targets[arg_6_2]

			var_6_0 = var_6_0 or arg_6_1.default_target
			arg_6_0 = var_6_0.dot_template_name or arg_6_1.dot_template_name
		end

		if not arg_6_0 then
			return false
		end

		fn_2(arg_6_0, arg_6_4, arg_6_5, arg_6_7, arg_6_3, arg_6_10)

		return true
	end
}

local DotTypeLookup = DotTypeLookup

DotTypeLookup = DotTypeLookup or {
	weapon_bleed_dot_dagger = "poison_dot",
	burning_dot_fire_grenade = "burning_dot",
	burning_dot_3tick = "burning_dot",
	weapon_bleed_dot_maidenguard = "poison_dot",
	burning_dot_2tick_slow_unstackable = "burning_dot",
	burning_dot_2tick = "burning_dot",
	arrow_poison_dot = "poison_dot",
	beam_burning_dot = "burning_dot",
	weapon_bleed_dot_whc = "poison_dot",
	burning_dot_1tick = "burning_dot",
	burning_flamethrower_dot = "burning_dot",
	burning_dot_unchained_push = "burning_dot",
	aoe_poison_dot = "poison_dot",
	death_staff_dot = "burning_dot",
	burning_dot_scythe_special = "burning_dot",
	vs_ratling_gunner_slow = "burning_dot",
	burning_dot = "burning_dot",
	burning_dot_1tick_vs = "burning_dot",
	sienna_necromancer_4_3_dot = "burning_dot",
	chaos_zombie_explosion = "poison_dot"
}
DotTypeLookup = DotTypeLookup

DLCUtils.merge("dot_type_lookup", DotTypeLookup)

local tbl_3 = {
	bright_wizard = {},
	dwarf_ranger = {},
	empire_soldier = {},
	witch_hunter = {},
	wood_elf = {},
	vs_poison_wind_globadier = {},
	vs_packmaster = {},
	vs_gutter_runner = {},
	vs_ratling_gunner = {},
	vs_warpfire_thrower = {},
	vs_chaos_troll = {},
	vs_rat_ogre = {}
}

for k_6, v_5 in pairs(ItemMasterList) do
	local slot_type = v_5.slot_type

	if not (slot_type == "melee" or slot_type == "ranged" or slot_type == "grenade" or slot_type == "healthkit" or slot_type ~= "potion") then
		local template = v_5.template

		template = template or v_5.temporary_template

		fassert(rawget(Weapons, template), "Weapon template [\"%s\"] does not exist!", template)

		local can_wield = v_5.can_wield

		for i11 = 1, #can_wield do
			local var_0_17 = can_wield[i11]
			local profile_name = CareerSettings[var_0_17].profile_name
			local var_0_19 = CareerActionNames[profile_name]

			if not (not tbl_3[profile_name] and tbl_3[profile_name][template]) then
				tbl_3[profile_name][template] = true

				local actions_2 = rawget(Weapons, template).actions

				for i12 = 1, #var_0_19 do
					local var_0_21 = var_0_19[i12]

					actions_2[var_0_21] = ActionTemplates[var_0_21]
				end
			end
		end
	end
end

local MeleeBuffTypes = MeleeBuffTypes

MeleeBuffTypes = MeleeBuffTypes or {
	MELEE_1H = true,
	MELEE_2H = true
}

local RangedBuffTypes = RangedBuffTypes

RangedBuffTypes = RangedBuffTypes or {
	RANGED_ABILITY = true,
	RANGED = true
}

local num = 1.919366
local num_2 = 0.6
local num_3 = 0.65

for k_7, v_6 in pairs(Weapons) do
	v_6.name = k_7

	local crosshair_style = v_6.crosshair_style

	crosshair_style = crosshair_style or "dot"
	v_6.crosshair_style = crosshair_style

	local attack_meta_data = v_6.attack_meta_data
	local flag = not attack_meta_data and attack_meta_data.tap_attack
	local flag_2 = not attack_meta_data and attack_meta_data.hold_attack
	local flag_3 = not flag and flag.max_range == nil
	local flag_4 = not flag_2 and flag_2.max_range == nil

	if not RangedBuffTypes[v_6.buff_type] and not attack_meta_data then
		local effective_against = attack_meta_data.effective_against

		effective_against = effective_against or 0
		attack_meta_data.effective_against = effective_against

		local effective_against_charged = attack_meta_data.effective_against_charged

		effective_against_charged = effective_against_charged or 0
		attack_meta_data.effective_against_charged = effective_against_charged
		attack_meta_data.effective_against_combined = bit.bor(attack_meta_data.effective_against, attack_meta_data.effective_against_charged)
	end

	if not MeleeBuffTypes[v_6.buff_type] then
		fassert(attack_meta_data, "Missing attack metadata for weapon %s", k_7)
		fassert(flag, "Missing tap_attack metadata for weapon %s", k_7)
		fassert(flag_2, "Missing hold_attack metadata for weapon %s", k_7)
		fassert(flag.arc, "Missing arc parameter in tap_attack metadata for weapon %s", k_7)
		fassert(flag_2.arc, "Missing arc parameter in hold_attack metadata for weapon %s", k_7)
	end

	local actions_3 = v_6.actions

	for k_8, v_7 in pairs(actions_3) do
		for k_9, v_8 in pairs(v_7) do
			v_8.lookup_data = {
				item_template_name = k_7,
				action_name = k_8,
				sub_action_name = k_9
			}

			local kind = v_8.kind
			local var_0_37 = ActionAssertFuncs[kind]

			if not var_0_37 then
				var_0_37(k_7, k_8, k_9, v_8)
			end

			if k_8 == "action_one" then
				local range_mod = v_8.range_mod

				range_mod = range_mod or 1

				if not flag_3 and not string.find(k_9, "light_attack") then
					local max_range = flag.max_range

					max_range = max_range or math.huge

					local num_4 = num_2 + num * range_mod

					flag.max_range = math.min(max_range, num_4)
				elseif not flag_4 and not string.find(k_9, "heavy_attack") then
					local max_range_2 = flag_2.max_range

					max_range_2 = max_range_2 or math.huge

					local num_5 = num_3 + num * range_mod

					flag_2.max_range = math.min(max_range_2, num_5)
				end
			end

			local impact_data = v_8.impact_data

			if not impact_data then
				local pickup_settings = impact_data.pickup_settings

				if not pickup_settings then
					local link_hit_zones = pickup_settings.link_hit_zones

					if not link_hit_zones then
						for i19 = 1, #link_hit_zones do
							link_hit_zones[link_hit_zones[i19]] = true
						end
					end
				end
			end
		end
	end
end
