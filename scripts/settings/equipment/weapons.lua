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
Weapons = Weapons or {}

local var_0_0 = dofile("scripts/settings/equipment/honduras_weapon_templates")

for iter_0_0, iter_0_1 in pairs(DLCSettings) do
	if iter_0_1.weapon_template_file_names then
		table.append(var_0_0, iter_0_1.weapon_template_file_names)
	end
end

for iter_0_2 = 1, #var_0_0 do
	local var_0_1 = var_0_0[iter_0_2]
	local var_0_2 = dofile(var_0_1)

	if var_0_2 then
		for iter_0_3, iter_0_4 in pairs(var_0_2) do
			local var_0_3 = iter_0_4.actions
			local var_0_4 = {}

			iter_0_4.required_projectile_unit_templates = var_0_4

			for iter_0_5, iter_0_6 in pairs(var_0_3) do
				for iter_0_7, iter_0_8 in pairs(iter_0_6) do
					local var_0_5 = iter_0_8.projectile_info

					if var_0_5 then
						local var_0_6 = var_0_5.projectile_units_template

						if var_0_6 then
							var_0_4[var_0_6] = var_0_5.use_weapon_skin == true
						end
					end
				end
			end

			Weapons[iter_0_3] = iter_0_4
		end
	end
end

table.clear(var_0_0)

DAMAGE_TYPES_AOE = {
	warpfire_face = true,
	vomit_face = true,
	vomit_ground = true,
	poison = true,
	plague_face = true,
	warpfire_ground = true
}

local function var_0_7(arg_1_0, arg_1_1, arg_1_2)
	return arg_1_2 > math.abs(arg_1_0 - arg_1_1)
end

local var_0_8 = {}

local function var_0_9(arg_2_0, arg_2_1, arg_2_2, arg_2_3, arg_2_4, arg_2_5)
	if ScriptUnit.has_extension(arg_2_1, "buff_system") then
		table.clear(var_0_8)

		var_0_8.attacker_unit = arg_2_2
		var_0_8.damage_source = arg_2_3
		var_0_8.power_level = arg_2_4
		var_0_8.source_attacker_unit = arg_2_5

		ScriptUnit.extension(arg_2_1, "buff_system"):add_buff(arg_2_0, var_0_8)
	end
end

local function var_0_10(arg_3_0, arg_3_1, arg_3_2, arg_3_3, arg_3_4, arg_3_5)
	if ScriptUnit.has_extension(arg_3_1, "buff_system") then
		table.clear(var_0_8)

		var_0_8.attacker_unit = arg_3_2
		var_0_8.damage_source = arg_3_3
		var_0_8.power_level = arg_3_4
		var_0_8.source_attacker_unit = arg_3_5

		Managers.state.entity:system("buff_system"):add_buff_synced(arg_3_1, arg_3_0, BuffSyncType.All, var_0_8)

		if arg_3_5 then
			local var_3_0 = AiUtils.unit_breed(arg_3_1)

			if var_3_0 and not var_3_0.is_hero then
				AiUtils.alert_unit_of_enemy(arg_3_1, arg_3_5)
			end
		end
	end
end

Dots = {
	poison_dot = function(arg_4_0, arg_4_1, arg_4_2, arg_4_3, arg_4_4, arg_4_5, arg_4_6, arg_4_7, arg_4_8, arg_4_9, arg_4_10)
		local var_4_0

		if arg_4_1 then
			var_4_0 = arg_4_1.targets[arg_4_2] or arg_4_1.default_target
			arg_4_0 = arg_4_0 or var_4_0.dot_template_name or arg_4_1.dot_template_name
		end

		if not arg_4_0 then
			return false
		end

		local var_4_1 = true
		local var_4_2 = AiUtils.unit_breed(arg_4_4)
		local var_4_3 = Unit.get_data(arg_4_4, "armor")
		local var_4_4 = ActionUtils.get_target_armor(arg_4_6, var_4_2, var_4_3)

		if var_4_0 and var_4_4 == 2 then
			local var_4_5 = BoostCurves[var_4_0.boost_curve_type]

			if DamageUtils.calculate_damage(DamageOutput, arg_4_4, arg_4_5, arg_4_6, arg_4_3, var_4_5, arg_4_8, arg_4_9, arg_4_1, arg_4_2, false, arg_4_7) <= 0 then
				var_4_1 = false
			end
		end

		if var_4_1 then
			var_0_9(arg_4_0, arg_4_4, arg_4_5, arg_4_7, arg_4_3, arg_4_10)
		end

		return var_4_1
	end,
	burning_dot = function(arg_5_0, arg_5_1, arg_5_2, arg_5_3, arg_5_4, arg_5_5, arg_5_6, arg_5_7, arg_5_8, arg_5_9, arg_5_10)
		if arg_5_1 then
			arg_5_0 = arg_5_0 or (arg_5_1.targets[arg_5_2] or arg_5_1.default_target).dot_template_name or arg_5_1.dot_template_name
		end

		if not arg_5_0 then
			return false
		end

		local var_5_0 = AiUtils.unit_breed(arg_5_4)

		if var_5_0 and not var_5_0.is_hero then
			local var_5_1 = ScriptUnit.has_extension(arg_5_5, "talent_system") or ScriptUnit.has_extension(arg_5_10, "talent_system")

			arg_5_0 = var_5_1 and var_5_1:has_talent("sienna_adept_infinite_burn") and InfiniteBurnDotLookup[arg_5_0] or arg_5_0

			local var_5_2 = ScriptUnit.has_extension(arg_5_5, "buff_system")

			if var_5_2 then
				var_5_2:trigger_procs("on_enemy_ignited", arg_5_0, arg_5_1, arg_5_2, arg_5_4, arg_5_6, arg_5_7, arg_5_9)
			end
		end

		var_0_10(arg_5_0, arg_5_4, arg_5_5, arg_5_7, arg_5_3, arg_5_10)

		return true
	end,
	slow_debuff = function(arg_6_0, arg_6_1, arg_6_2, arg_6_3, arg_6_4, arg_6_5, arg_6_6, arg_6_7, arg_6_8, arg_6_9, arg_6_10)
		if arg_6_1 then
			arg_6_0 = arg_6_0 or (arg_6_1.targets[arg_6_2] or arg_6_1.default_target).dot_template_name or arg_6_1.dot_template_name
		end

		if not arg_6_0 then
			return false
		end

		var_0_9(arg_6_0, arg_6_4, arg_6_5, arg_6_7, arg_6_3, arg_6_10)

		return true
	end
}
DotTypeLookup = DotTypeLookup or {
	aoe_poison_dot = "poison_dot",
	vs_ratling_gunner_slow = "burning_dot",
	burning_dot_fire_grenade = "burning_dot",
	weapon_bleed_dot_maidenguard = "poison_dot",
	weapon_bleed_dot_whc = "poison_dot",
	burning_dot_1tick = "burning_dot",
	arrow_poison_dot = "poison_dot",
	beam_burning_dot = "burning_dot",
	weapon_bleed_dot_dagger = "poison_dot",
	burning_dot_3tick = "burning_dot",
	burning_dot_unchained_push = "burning_dot",
	burning_flamethrower_dot = "burning_dot",
	death_staff_dot = "burning_dot",
	burning_dot = "burning_dot",
	burning_dot_1tick_vs = "burning_dot",
	sienna_necromancer_4_3_dot = "burning_dot",
	chaos_zombie_explosion = "poison_dot"
}

DLCUtils.merge("dot_type_lookup", DotTypeLookup)

local var_0_11 = {
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

for iter_0_9, iter_0_10 in pairs(ItemMasterList) do
	local var_0_12 = iter_0_10.slot_type

	if var_0_12 == "melee" or var_0_12 == "ranged" or var_0_12 == "grenade" or var_0_12 == "healthkit" or var_0_12 == "potion" then
		local var_0_13 = iter_0_10.template or iter_0_10.temporary_template

		fassert(rawget(Weapons, var_0_13), "Weapon template [\"%s\"] does not exist!", var_0_13)

		local var_0_14 = iter_0_10.can_wield

		for iter_0_11 = 1, #var_0_14 do
			local var_0_15 = var_0_14[iter_0_11]
			local var_0_16 = CareerSettings[var_0_15].profile_name
			local var_0_17 = CareerActionNames[var_0_16]

			if var_0_11[var_0_16] and not var_0_11[var_0_16][var_0_13] then
				var_0_11[var_0_16][var_0_13] = true

				local var_0_18 = rawget(Weapons, var_0_13).actions

				for iter_0_12 = 1, #var_0_17 do
					local var_0_19 = var_0_17[iter_0_12]

					var_0_18[var_0_19] = ActionTemplates[var_0_19]
				end
			end
		end
	end
end

local var_0_20 = MeleeBuffTypes or {
	MELEE_1H = true,
	MELEE_2H = true
}
local var_0_21 = RangedBuffTypes or {
	RANGED_ABILITY = true,
	RANGED = true
}
local var_0_22 = 1.919366
local var_0_23 = 0.6
local var_0_24 = 0.65

for iter_0_13, iter_0_14 in pairs(Weapons) do
	iter_0_14.name = iter_0_13
	iter_0_14.crosshair_style = iter_0_14.crosshair_style or "dot"

	local var_0_25 = iter_0_14.attack_meta_data
	local var_0_26 = var_0_25 and var_0_25.tap_attack
	local var_0_27 = var_0_25 and var_0_25.hold_attack
	local var_0_28 = var_0_26 and var_0_26.max_range == nil
	local var_0_29 = var_0_27 and var_0_27.max_range == nil

	if var_0_21[iter_0_14.buff_type] and var_0_25 then
		var_0_25.effective_against = var_0_25.effective_against or 0
		var_0_25.effective_against_charged = var_0_25.effective_against_charged or 0
		var_0_25.effective_against_combined = bit.bor(var_0_25.effective_against, var_0_25.effective_against_charged)
	end

	if var_0_20[iter_0_14.buff_type] then
		fassert(var_0_25, "Missing attack metadata for weapon %s", iter_0_13)
		fassert(var_0_26, "Missing tap_attack metadata for weapon %s", iter_0_13)
		fassert(var_0_27, "Missing hold_attack metadata for weapon %s", iter_0_13)
		fassert(var_0_26.arc, "Missing arc parameter in tap_attack metadata for weapon %s", iter_0_13)
		fassert(var_0_27.arc, "Missing arc parameter in hold_attack metadata for weapon %s", iter_0_13)
	end

	local var_0_30 = iter_0_14.actions

	for iter_0_15, iter_0_16 in pairs(var_0_30) do
		for iter_0_17, iter_0_18 in pairs(iter_0_16) do
			iter_0_18.lookup_data = {
				item_template_name = iter_0_13,
				action_name = iter_0_15,
				sub_action_name = iter_0_17
			}

			local var_0_31 = iter_0_18.kind
			local var_0_32 = ActionAssertFuncs[var_0_31]

			if var_0_32 then
				var_0_32(iter_0_13, iter_0_15, iter_0_17, iter_0_18)
			end

			if iter_0_15 == "action_one" then
				local var_0_33 = iter_0_18.range_mod or 1

				if var_0_28 and string.find(iter_0_17, "light_attack") then
					local var_0_34 = var_0_26.max_range or math.huge
					local var_0_35 = var_0_23 + var_0_22 * var_0_33

					var_0_26.max_range = math.min(var_0_34, var_0_35)
				elseif var_0_29 and string.find(iter_0_17, "heavy_attack") then
					local var_0_36 = var_0_27.max_range or math.huge
					local var_0_37 = var_0_24 + var_0_22 * var_0_33

					var_0_27.max_range = math.min(var_0_36, var_0_37)
				end
			end

			local var_0_38 = iter_0_18.impact_data

			if var_0_38 then
				local var_0_39 = var_0_38.pickup_settings

				if var_0_39 then
					local var_0_40 = var_0_39.link_hit_zones

					if var_0_40 then
						for iter_0_19 = 1, #var_0_40 do
							var_0_40[var_0_40[iter_0_19]] = true
						end
					end
				end
			end
		end
	end
end
