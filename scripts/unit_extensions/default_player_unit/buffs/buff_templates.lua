-- chunkname: @scripts/unit_extensions/default_player_unit/buffs/buff_templates.lua

require("scripts/utils/strict_table")
require("scripts/settings/player_unit_damage_settings")
require("scripts/settings/equipment/weapons")

local var_0_0 = require("scripts/unit_extensions/default_player_unit/buffs/settings/buff_perk_names")

MeleeBuffTypes = {}
MeleeBuffTypes.MELEE_1H = true
MeleeBuffTypes.MELEE_2H = true
RangedBuffTypes = {}
RangedBuffTypes.RANGED = true
RangedBuffTypes.RANGED_ABILITY = true
AttackTypes = table.enum("light_attack", "heavy_attack", "action_push", "projectile", "instant_projectile", "heavy_instant_projectile", "grenade")
MeleeAttackTypes = {
	[AttackTypes.light_attack] = true,
	[AttackTypes.heavy_attack] = true
}
RangedAttackTypes = {
	[AttackTypes.projectile] = true,
	[AttackTypes.instant_projectile] = true,
	[AttackTypes.heavy_instant_projectile] = true,
	[AttackTypes.grenade] = true
}
StatBuffApplicationMethods = {
	reduced_spread_hit = "stacking_multiplier",
	max_fatigue = "stacking_bonus",
	gromril_cooldown = "stacking_bonus",
	explosion_damage = "stacking_multiplier",
	headshot_multiplier = "stacking_multiplier",
	attack_speed_drakefire = "stacking_multiplier",
	increased_drone_count = "stacking_bonus",
	increased_weapon_damage_ranged_to_wounded = "stacking_multiplier",
	increased_max_targets = "stacking_bonus",
	increased_damage_to_balefire = "stacking_multiplier",
	increased_balefire_dot_duration = "stacking_multiplier",
	power_level_large = "stacking_multiplier",
	critical_strike_chance_heavy = "stacking_bonus",
	critical_strike_chance_melee = "stacking_bonus",
	protection_gutter_runner = "stacking_multiplier",
	vent_speed = "stacking_multiplier",
	attack_speed_melee = "stacking_multiplier",
	total_ammo = "stacking_multiplier",
	damage_taken_elites = "stacking_multiplier",
	coop_stamina = "proc",
	damage_taken_kd = "stacking_multiplier",
	max_damage_taken = "min",
	not_consume_potion = "proc",
	reduced_overcharge = "stacking_multiplier",
	damage_taken_to_overcharge = "stacking_multiplier",
	critical_strike_effectiveness = "stacking_multiplier",
	reduced_overcharge_from_passive = "stacking_multiplier",
	faster_revive = "stacking_multiplier",
	damage_taken = "stacking_multiplier_multiplicative",
	grenade_extra_shot = "stacking_bonus",
	block_cost = "stacking_multiplier",
	applied_stagger_distance = "stacking_multiplier",
	timed_block_cost = "stacking_multiplier",
	push_range = "stacking_bonus",
	clip_size = "stacking_multiplier",
	power_level_armoured = "stacking_multiplier",
	critical_strike_chance_ranged = "stacking_bonus",
	protection_poison_wind = "stacking_multiplier",
	debuff_armoured = "stacking_bonus",
	throw_speed_increase = "stacking_multiplier",
	hit_mass_amount = "stacking_multiplier",
	hit_force = "stacking_multiplier",
	health_curse = "stacking_bonus",
	attack_intensity_decay = "stacking_multiplier",
	reload_speed = "stacking_multiplier",
	stun_duration = "stacking_multiplier",
	cooldown_regen = "stacking_multiplier",
	extra_wounds = "stacking_bonus",
	life_essence = "stacking_multiplier",
	max_controlled_pets = "stacking_bonus_and_multiplier",
	power_level_chaos = "stacking_multiplier",
	dummy_stagger = "stacking_bonus",
	ammo_used_multiplier = "stacking_multiplier",
	power_level_critical_strike = "stacking_multiplier",
	increased_weapon_damage_melee = "stacking_multiplier",
	power_level = "stacking_multiplier",
	max_damage_taken_from_boss_or_elite = "min",
	push_power = "stacking_multiplier",
	power_level_ranged = "stacking_multiplier",
	unbalanced_damage_taken = "stacking_bonus",
	increased_weapon_damage_ranged = "stacking_multiplier",
	protection_aoe = "stacking_multiplier",
	max_health_kd = "stacking_multiplier",
	grenade_radius = "stacking_multiplier",
	overcharge_regen = "stacking_multiplier",
	grimoire_max_health = "stacking_multiplier",
	overcharge_damage_immunity = "proc",
	power_level_impact = "stacking_multiplier",
	curse_protection = "stacking_multiplier",
	increased_weapon_damage = "stacking_multiplier",
	outer_block_angle = "stacking_multiplier",
	damage_dealt = "stacking_multiplier",
	increased_weapon_damage_poisoned_or_bleeding = "stacking_multiplier",
	deus_coins_greed = "stacking_multiplier",
	power_level_super_armour = "stacking_multiplier",
	protection_ratling_gunner = "stacking_multiplier",
	faster_respawn = "stacking_multiplier",
	movement_speed = "stacking_multiplier",
	shield_break_proc = "proc",
	full_charge_boost = "stacking_multiplier",
	pet_life_time = "stacking_multiplier",
	attack_intensity_threshold = "stacking_multiplier",
	power_level_frenzy = "stacking_multiplier",
	stagger_distance = "stacking_multiplier",
	max_health_alive = "stacking_multiplier",
	headshot_damage = "stacking_multiplier",
	vent_damage = "stacking_multiplier",
	counter_push_power = "stacking_multiplier",
	not_consume_grenade = "proc",
	fatigue_regen = "stacking_multiplier",
	grenade_throw_range = "stacking_multiplier",
	block_angle = "stacking_multiplier",
	increase_luck = "stacking_multiplier",
	power_level_melee_cleave = "stacking_multiplier",
	max_health = "stacking_multiplier",
	projectile_bounces = "stacking_bonus",
	extra_shot = "stacking_bonus",
	heal_self_on_heal_other = "proc",
	stagger_resistance = "stacking_multiplier",
	damage_taken_ranged = "stacking_multiplier",
	unbalanced_damage_dealt = "stacking_multiplier",
	hit_mass_reduction = "stacking_multiplier",
	critical_strike_chance = "stacking_bonus",
	max_overcharge = "stacking_multiplier",
	reduced_non_burn_damage = "stacking_multiplier",
	activated_cooldown = "stacking_multiplier",
	increased_weapon_damage_heavy_attack = "stacking_multiplier",
	no_push_fatigue_cost = "proc",
	reduced_spread = "stacking_multiplier",
	reduced_spread_moving = "stacking_multiplier",
	increased_burn_dot_damage = "stacking_multiplier",
	non_headshot_damage = "stacking_multiplier",
	flat_power_level = "stacking_bonus",
	reduced_spread_shot = "stacking_multiplier",
	explosion_radius = "stacking_multiplier",
	healing_received = "stacking_multiplier",
	protection_skaven = "stacking_multiplier",
	power_level_melee = "stacking_multiplier",
	potion_duration = "stacking_multiplier",
	protection_chaos = "stacking_multiplier",
	reduced_ranged_charge_time = "stacking_multiplier",
	impact_vulnerability = "stacking_multiplier",
	extra_ability_charges = "stacking_bonus",
	attack_intensity_reset = "stacking_multiplier",
	power_level_unarmoured = "stacking_multiplier",
	attack_speed = "stacking_multiplier",
	increased_move_speed_while_aiming = "stacking_multiplier",
	protection_pack_master = "stacking_multiplier",
	headshot_vulnerability = "stacking_multiplier",
	not_consume_medpack = "proc",
	increased_weapon_damage_melee_2h = "stacking_multiplier",
	damage_taken_melee = "stacking_multiplier",
	backstab_multiplier = "stacking_bonus",
	first_melee_hit_damage = "stacking_multiplier",
	increased_weapon_damage_melee_1h = "stacking_multiplier",
	ranged_additional_penetrations = "stacking_bonus",
	power_level_skaven = "stacking_multiplier",
	damage_taken_burning_enemy = "stacking_multiplier",
	shielding_player_by_assist = "proc",
	power_level_ranged_drakefire = "stacking_multiplier"
}
WeaponSpecificStatBuffs = {}

local function var_0_1(arg_1_0, arg_1_1, arg_1_2, arg_1_3)
	StatBuffApplicationMethods[arg_1_1] = arg_1_2
	WeaponSpecificStatBuffs[arg_1_0] = WeaponSpecificStatBuffs[arg_1_0] or {}
	WeaponSpecificStatBuffs[arg_1_0][arg_1_3] = arg_1_1
end

for iter_0_0, iter_0_1 in pairs(Weapons) do
	local var_0_2 = iter_0_1.weapon_type

	if var_0_2 and not WeaponSpecificStatBuffs[var_0_2] then
		local var_0_3 = "increased_weapon_damage_" .. var_0_2

		var_0_1(var_0_2, var_0_3, "stacking_multiplier", "damage")
	end
end

ProcEvents = {
	"on_hit",
	"on_melee_hit",
	"on_ranged_hit",
	"on_hit_by_ranged",
	"on_hit_by_other",
	"on_kill",
	"on_kill_elite_special",
	"on_boss_killed",
	"on_special_killed",
	"on_elite_killed",
	"on_pingable_target_killed",
	"on_block_broken",
	"on_knocked_down",
	"on_ledge_hang_start",
	"on_player_disabled",
	"on_ally_knocked_down",
	"on_revived",
	"on_revived_ally",
	"on_healed",
	"on_healed_ally",
	"on_healed_consumeable",
	"on_assisted",
	"on_assisted_ally",
	"on_push",
	"on_damage_taken",
	"on_consumable_picked_up",
	"on_reload",
	"on_ammo_used",
	"on_overcharge_used",
	"on_overcharge_lost",
	"on_unwield",
	"on_critical_hit",
	"on_last_ammo_used",
	"on_ammo_clip_used",
	"on_gained_ammo_from_no_ammo",
	"on_player_damage_dealt",
	"on_stagger",
	"on_charge_ability_hit",
	"on_charge_ability_hit_blast",
	"on_bardin_consumable_picked_up_any_player",
	"on_dodge",
	"on_dodge_finished",
	"on_leap_start",
	"on_leap_finished",
	"on_pinged",
	"on_start_action",
	"on_full_charge_action",
	"on_enemy_ignited",
	"on_auto_headshot",
	"on_potion_consumed",
	"on_ability_activated",
	"on_dot_damage_dealt",
	"on_grenade_exploded",
	"on_barrel_exploded",
	"on_inventory_post_apply_buffs",
	"on_visible",
	"on_invisible",
	"on_body_pushed",
	"on_controlled_unit_added",
	"on_controlled_unit_removed",
	"on_controlled_unit_death",
	"on_boon_granted",
	"on_mutator_skull_picked_up",
	"on_death",
	"on_damage_dealt",
	"on_block",
	"on_push_used",
	"on_backstab",
	"on_sweep",
	"on_critical_sweep",
	"on_critical_shot",
	"on_critical_action",
	"on_non_critical_action",
	"on_spell_used",
	"on_grenade_use",
	"on_full_charge",
	"on_charge_finished",
	"on_ability_recharged",
	"on_ability_cooldown_started",
	"on_extra_ability_consumed",
	"on_crouch",
	"on_timed_block",
	"on_wield",
	"on_gromril_armour_removed",
	"on_broke_shield",
	"on_pet_spawned",
	"cursed_chest_running",
	"stagger_calculation_started",
	"stagger_calculation_ended",
	"damage_calculation_started",
	"damage_calculation_ended",
	"on_staggered",
	"minion_attack_used"
}

local function var_0_4(...)
	local var_2_0 = select("#", ...)
	local var_2_1 = Script.new_map(var_2_0)

	for iter_2_0 = 1, var_2_0 do
		var_2_1[select(iter_2_0, ...)] = iter_2_0
	end

	return var_2_1
end

ProcEventParams = {
	on_player_damage_dealt = var_0_4("attacked_unit", "damage_amount", "hit_zone_name", "no_crit_headshot_damage", "is_critical_strike", "buff_attack_type", "target_index", "damage_source", "first_hit", "PROC_MODIFIABLE"),
	on_damage_dealt = var_0_4("attacked_unit", "attacker_unit", "damage_amount", "hit_zone_name", "no_crit_headshot_damage", "is_critical_strike", "buff_attack_type", "target_index", "damage_source", "damage_type", "first_hit", "PROC_MODIFIABLE"),
	on_critical_hit = var_0_4("hit_unit", "attack_type", "hit_zone_name", "target_number", "buff_type"),
	on_ranged_hit = var_0_4("hit_unit", "attack_type", "hit_zone_name", "target_number", "buff_type", "is_critical", "unmodified"),
	on_ranged_hit = var_0_4("attaker_unit", "attack_type", "hit_zone_name", "target_number", "buff_type", "is_critical", "unmodified"),
	on_hit = var_0_4("hit_unit", "attack_type", "hit_zone_name", "target_number", "buff_type", "is_critical", "unmodified"),
	on_staggered = var_0_4("target_unit", "damage_profile", "attacker_unit", "stagger_type", "stagger_duration", "stagger_value", "buff_type", "target_index")
}

local var_0_5 = {}

local function var_0_6(arg_3_0)
	local var_3_0 = Managers.player:owner(arg_3_0)

	return var_3_0 and not var_3_0.remote
end

local function var_0_7()
	return Managers.player.is_server
end

local function var_0_8(arg_5_0)
	local var_5_0 = Managers.player:owner(arg_5_0)

	return var_5_0 and var_5_0.bot_player
end

ProcFunctions = {
	heal = function(arg_6_0, arg_6_1, arg_6_2)
		if ALIVE[arg_6_0] and Managers.player.is_server then
			local var_6_0 = arg_6_1.bonus

			DamageUtils.heal_network(arg_6_0, arg_6_0, var_6_0, "heal_from_proc")
		end
	end,
	damage_attacker = function(arg_7_0, arg_7_1, arg_7_2)
		if ALIVE[arg_7_0] and Managers.player.is_server then
			local var_7_0 = arg_7_1.bonus

			DamageUtils.add_damage_network(arg_7_0, arg_7_0, var_7_0, "full", "buff", nil, Vector3(1, 0, 0), "buff", nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, 1)
		end
	end,
	metal_mutator_stacks_on_hit = function(arg_8_0, arg_8_1, arg_8_2)
		if ALIVE[arg_8_0] and Managers.player.is_server then
			local var_8_0 = (arg_8_1.current_stacks or 0) + 1

			if var_8_0 == arg_8_1.template.num_stacks then
				local var_8_1 = arg_8_1.bonus
				local var_8_2 = arg_8_2[1]
				local var_8_3 = AiUtils.unit_breed(var_8_2)
				local var_8_4 = arg_8_1.template.breeds

				if table.contains(var_8_4, var_8_3.name) then
					DamageUtils.add_damage_network(var_8_2, arg_8_0, var_8_1, "full", "metal_mutator", nil, Vector3(1, 0, 0), "buff", nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, 1)
				end

				var_8_0 = 0
			end

			arg_8_1.current_stacks = var_8_0
		end
	end,
	heal_party = function(arg_9_0, arg_9_1, arg_9_2)
		if ALIVE[arg_9_0] and Managers.player.is_server then
			local var_9_0 = arg_9_1.bonus
			local var_9_1 = Managers.state.side.side_by_unit[arg_9_0].PLAYER_AND_BOT_UNITS

			for iter_9_0 = 1, #var_9_1 do
				DamageUtils.heal_network(var_9_1[iter_9_0], arg_9_0, var_9_0, "heal_from_proc")
			end
		end
	end,
	heal_other_players_percent_at_range = function(arg_10_0, arg_10_1, arg_10_2)
		local var_10_0 = arg_10_2[1]
		local var_10_1 = POSITION_LOOKUP[var_10_0]
		local var_10_2 = arg_10_1.range
		local var_10_3 = var_10_2 * var_10_2

		if ALIVE[arg_10_0] and Managers.player.is_server then
			local var_10_4 = Managers.state.side.side_by_unit[arg_10_0].PLAYER_AND_BOT_UNITS

			for iter_10_0 = 1, #var_10_4 do
				local var_10_5 = var_10_4[iter_10_0]

				if var_10_5 ~= arg_10_0 and Unit.alive(var_10_5) then
					local var_10_6 = POSITION_LOOKUP[var_10_5]

					if var_10_3 > Vector3.distance_squared(var_10_1, var_10_6) then
						local var_10_7 = ScriptUnit.extension(var_10_5, "health_system"):get_max_health() * arg_10_1.multiplier
						local var_10_8 = "buff_shared_medpack"

						DamageUtils.heal_network(var_10_5, arg_10_0, var_10_7, var_10_8)
					end
				end
			end
		end
	end,
	heal_assisted_and_self_on_assist = function(arg_11_0, arg_11_1, arg_11_2)
		local var_11_0 = arg_11_2[1]

		if ALIVE[arg_11_0] and Managers.player.is_server then
			local var_11_1 = arg_11_1.bonus

			DamageUtils.heal_network(arg_11_0, arg_11_0, var_11_1, "heal_from_proc")

			if Unit.alive(var_11_0) then
				DamageUtils.heal_network(var_11_0, arg_11_0, var_11_1, "heal_from_proc")
			end
		end
	end,
	buff_defence_on_revived_target = function(arg_12_0, arg_12_1, arg_12_2)
		local var_12_0 = arg_12_2[1]

		if not ALIVE[arg_12_0] or not ALIVE[var_12_0] or not Managers.player.is_server then
			return
		end

		local var_12_1 = Managers.state.entity:system("buff_system")
		local var_12_2 = arg_12_1.template.buff_to_add

		if type(var_12_2) == "table" then
			for iter_12_0 = 1, #var_12_2 do
				local var_12_3 = var_12_2[iter_12_0]

				var_12_1:add_buff(var_12_0, var_12_3, arg_12_0, false)
			end
		else
			var_12_1:add_buff(var_12_0, var_12_2, arg_12_0, false)
		end
	end,
	heal_percentage_of_enemy_hp_on_melee_kill = function(arg_13_0, arg_13_1, arg_13_2)
		if not Managers.state.network.is_server then
			return
		end

		if ALIVE[arg_13_0] then
			local var_13_0 = arg_13_2[1]

			if not var_13_0 then
				return
			end

			local var_13_1 = var_13_0[DamageDataIndex.ATTACK_TYPE]

			if var_13_1 and (var_13_1 == "light_attack" or var_13_1 == "heavy_attack") then
				local var_13_2 = arg_13_2[2]

				if var_13_2 and not var_13_2.is_hero then
					local var_13_3 = var_13_2.bloodlust_health or 0

					DamageUtils.heal_network(arg_13_0, arg_13_0, var_13_3, "heal_from_proc")
				end
			end
		end
	end,
	heal_finesse_damage_on_melee = function(arg_14_0, arg_14_1, arg_14_2)
		if not Managers.state.network.is_server then
			return
		end

		local var_14_0 = arg_14_1.bonus
		local var_14_1 = arg_14_1.has_procced
		local var_14_2 = arg_14_2[1]
		local var_14_3 = arg_14_2[3]
		local var_14_4 = arg_14_2[4]
		local var_14_5 = arg_14_2[2]
		local var_14_6 = arg_14_2[6]
		local var_14_7 = AiUtils.unit_breed(var_14_2)

		if var_14_4 == 1 then
			arg_14_1.has_procced = false
			var_14_1 = false
		end

		if ALIVE[arg_14_0] and var_14_7 and (var_14_5 == "light_attack" or var_14_5 == "heavy_attack") and not var_14_1 then
			if var_14_6 then
				DamageUtils.heal_network(arg_14_0, arg_14_0, var_14_0, "heal_from_proc")

				arg_14_1.has_procced = true

				if var_14_3 == "head" or var_14_3 == "neck" or var_14_3 == "weakspot" then
					DamageUtils.heal_network(arg_14_0, arg_14_0, var_14_0, "heal_from_proc")

					arg_14_1.has_procced = true
				end
			elseif var_14_3 == "head" or var_14_3 == "neck" or var_14_3 == "weakspot" then
				DamageUtils.heal_network(arg_14_0, arg_14_0, var_14_0, "heal_from_proc")

				arg_14_1.has_procced = true
			else
				DamageUtils.heal_network(arg_14_0, arg_14_0, var_14_0 / 4, "heal_from_proc")

				arg_14_1.has_procced = true
			end
		end
	end,
	heal_stagger_targets_on_melee = function(arg_15_0, arg_15_1, arg_15_2)
		if not Managers.state.network.is_server then
			return
		end

		if ALIVE[arg_15_0] then
			local var_15_0 = arg_15_2[1]
			local var_15_1 = arg_15_2[2]
			local var_15_2 = var_15_1.charge_value
			local var_15_3 = arg_15_2[6]
			local var_15_4 = arg_15_2[4]
			local var_15_5 = arg_15_2[8]
			local var_15_6 = AiUtils.unit_breed(var_15_0)
			local var_15_7 = arg_15_1.multiplier
			local var_15_8 = var_15_1.is_push
			local var_15_9 = (var_15_4 or var_15_3) * var_15_7

			if var_15_8 then
				var_15_9 = 0.6
			end

			if var_15_5 and var_15_5 < 5 and var_15_6 and not var_15_6.is_hero and (var_15_2 == "light_attack" or var_15_2 == "heavy_attack" or var_15_2 == "action_push") then
				DamageUtils.heal_network(arg_15_0, arg_15_0, var_15_9, "heal_from_proc")
			end
		end
	end,
	heal_damage_targets_on_melee = function(arg_16_0, arg_16_1, arg_16_2, arg_16_3, arg_16_4)
		if not Managers.state.network.is_server then
			return
		end

		if not ALIVE[arg_16_0] then
			return
		end

		local var_16_0 = arg_16_2[arg_16_4.buff_attack_type]

		if not var_16_0 or var_16_0 ~= "light_attack" and var_16_0 ~= "heavy_attack" then
			return
		end

		local var_16_1 = arg_16_2[arg_16_4.attacked_unit]

		if not AiUtils.unit_breed(var_16_1) then
			return
		end

		if arg_16_2[arg_16_4.damage_amount] > 0 then
			local var_16_2 = arg_16_1.template.max_targets
			local var_16_3 = arg_16_2[arg_16_4.target_index]

			if var_16_3 and var_16_3 <= var_16_2 then
				local var_16_4 = 1

				if var_16_3 == 1 then
					-- block empty
				end

				DamageUtils.heal_network(arg_16_0, arg_16_0, var_16_4, "heal_from_proc")
			end
		end
	end,
	thp_linesman_func = function(arg_17_0, arg_17_1, arg_17_2, arg_17_3, arg_17_4)
		if not Managers.state.network.is_server then
			return
		end

		if ALIVE[arg_17_0] then
			local var_17_0 = arg_17_2[arg_17_4.buff_attack_type]

			if not var_17_0 or var_17_0 ~= "light_attack" and var_17_0 ~= "heavy_attack" then
				return
			end

			local var_17_1 = arg_17_2[arg_17_4.attacked_unit]

			if not AiUtils.unit_breed(var_17_1) then
				return
			end

			if arg_17_2[arg_17_4.damage_amount] > 0 then
				local var_17_2 = arg_17_1.template
				local var_17_3 = var_17_2.base_value
				local var_17_4 = arg_17_2[arg_17_4.target_index]

				if var_17_4 then
					local var_17_5 = var_17_2.target_dropoff
					local var_17_6 = var_17_2.max_targets

					if var_17_5 < var_17_4 then
						var_17_3 = var_17_3 / var_17_2.dropoff_divisor
					end

					if var_17_4 <= var_17_6 then
						local var_17_7 = var_17_3

						if script_data.show_player_health then
							print(string.format("Linesman THP: Target %s gives %s THP", var_17_4, var_17_7))
						end

						DamageUtils.heal_network(arg_17_0, arg_17_0, var_17_7, "heal_from_proc")
					end
				end
			end
		end
	end,
	thp_ninjafencer_func = function(arg_18_0, arg_18_1, arg_18_2)
		if not Managers.state.network.is_server then
			return
		end

		local var_18_0 = arg_18_1.bonus
		local var_18_1 = arg_18_2[1]
		local var_18_2 = arg_18_2[2]
		local var_18_3 = arg_18_2[3]
		local var_18_4 = arg_18_2[4]
		local var_18_5 = arg_18_2[6]
		local var_18_6 = AiUtils.unit_breed(var_18_1)

		if ALIVE[arg_18_0] and var_18_6 and (var_18_2 == "light_attack" or var_18_2 == "heavy_attack") and var_18_4 == 1 then
			local var_18_7 = var_18_3 == "head" or var_18_3 == "neck" or var_18_3 == "weakspot"

			if var_18_5 then
				DamageUtils.heal_network(arg_18_0, arg_18_0, var_18_0, "heal_from_proc")

				arg_18_1.has_procced = true

				if var_18_7 then
					DamageUtils.heal_network(arg_18_0, arg_18_0, var_18_0, "heal_from_proc")

					arg_18_1.has_procced = true
				end
			elseif var_18_7 then
				DamageUtils.heal_network(arg_18_0, arg_18_0, var_18_0, "heal_from_proc")

				arg_18_1.has_procced = true
			else
				DamageUtils.heal_network(arg_18_0, arg_18_0, var_18_0 / 4, "heal_from_proc")

				arg_18_1.has_procced = true
			end
		end
	end,
	thp_smiter_func = function(arg_19_0, arg_19_1, arg_19_2, arg_19_3, arg_19_4)
		if not Managers.state.network.is_server then
			return
		end

		if ALIVE[arg_19_0] then
			local var_19_0 = arg_19_2[1]

			if not var_19_0 then
				return
			end

			local var_19_1 = var_19_0[DamageDataIndex.ATTACK_TYPE]

			if var_19_1 and (var_19_1 == "light_attack" or var_19_1 == "heavy_attack") then
				local var_19_2 = arg_19_2[2]

				if var_19_2 and not var_19_2.is_hero then
					local var_19_3 = var_19_2.bloodlust_health or 0

					if script_data.show_player_health then
						print(string.format("Smiter THP: %s gives %s", var_19_2.name, var_19_3))
					end

					DamageUtils.heal_network(arg_19_0, arg_19_0, var_19_3, "heal_from_proc")
				end
			end
		end
	end,
	thp_tank_stagger_func = function(arg_20_0, arg_20_1, arg_20_2)
		if not Managers.state.network.is_server then
			return
		end

		if ALIVE[arg_20_0] then
			local var_20_0 = arg_20_1.template
			local var_20_1 = arg_20_2[1]
			local var_20_2 = arg_20_2[2]
			local var_20_3 = var_20_2.charge_value
			local var_20_4 = arg_20_2[4]
			local var_20_5 = arg_20_2[6]
			local var_20_6 = AiUtils.unit_breed(var_20_1)
			local var_20_7 = arg_20_2[8]
			local var_20_8 = arg_20_1.template.base_value

			if var_20_2.is_push then
				var_20_8 = var_20_8 * arg_20_1.template.push_modifier
			end

			local var_20_9 = var_20_0.max_targets
			local var_20_10 = math.min(math.max(var_20_4, var_20_5), 3)
			local var_20_11 = ({
				0.25,
				1,
				2
			})[var_20_10] or 1
			local var_20_12 = var_20_8 * var_20_11

			if var_20_7 and var_20_7 <= var_20_9 and var_20_6 and not var_20_6.is_hero and (var_20_3 == "light_attack" or var_20_3 == "heavy_attack" or var_20_3 == "action_push") then
				if script_data.show_player_health then
					print(string.format("Tank THP: %s * %s = %s (Target %s/%s)", var_20_8, var_20_11, var_20_12, var_20_7, var_20_9))
				end

				DamageUtils.heal_network(arg_20_0, arg_20_0, var_20_12, "heal_from_proc")
			end
		end
	end,
	thp_tank_kill_func = function(arg_21_0, arg_21_1, arg_21_2)
		if not Managers.state.network.is_server then
			return
		end

		if ALIVE[arg_21_0] then
			local var_21_0 = arg_21_2[1]

			if not var_21_0 then
				return
			end

			local var_21_1 = var_21_0[DamageDataIndex.ATTACK_TYPE]

			if var_21_1 and (var_21_1 == "light_attack" or var_21_1 == "heavy_attack") then
				local var_21_2 = arg_21_2[2]

				if var_21_2 and not var_21_2.is_hero then
					local var_21_3 = arg_21_1.template.base_value
					local var_21_4 = var_21_0[16]
					local var_21_5 = arg_21_1.template.max_targets
					local var_21_6 = var_21_3

					if var_21_4 and var_21_4 <= var_21_5 then
						if script_data.show_player_health then
							print(string.format("Tank THP: Kill gives %s (Target %s/%s)", var_21_6, var_21_4, var_21_5))
						end

						DamageUtils.heal_network(arg_21_0, arg_21_0, var_21_6, "heal_from_proc")
					end
				end
			end
		end
	end,
	heal_finesse_damage_on_ranged = function(arg_22_0, arg_22_1, arg_22_2)
		if not Managers.state.network.is_server then
			return
		end

		local var_22_0 = arg_22_1.bonus
		local var_22_1 = arg_22_1.has_procced
		local var_22_2 = arg_22_2[1]
		local var_22_3 = arg_22_2[3]
		local var_22_4 = arg_22_2[4]
		local var_22_5 = arg_22_2[5]
		local var_22_6 = arg_22_2[6]
		local var_22_7 = AiUtils.unit_breed(var_22_2)

		if var_22_4 == 1 then
			arg_22_1.has_procced = false
			var_22_1 = false
		end

		if ALIVE[arg_22_0] and var_22_7 and var_22_5 == "RANGED" and not var_22_1 then
			if var_22_3 == "head" or var_22_3 == "neck" or var_22_3 == "weakspot" then
				arg_22_1.has_procced = true

				DamageUtils.heal_network(arg_22_0, arg_22_0, var_22_0, "heal_from_proc")
			end

			if var_22_6 then
				DamageUtils.heal_network(arg_22_0, arg_22_0, var_22_0, "heal_from_proc")

				arg_22_1.has_procced = true
			end
		end
	end,
	on_hit_debuff_enemy_defence = function(arg_23_0, arg_23_1, arg_23_2)
		local var_23_0 = arg_23_2[1]

		if ALIVE[arg_23_0] and ALIVE[var_23_0] and Managers.player.is_server then
			ScriptUnit.extension(var_23_0, "buff_system"):add_buff("defence_debuff_enemies")
		end
	end,
	unbalance_debuff_on_stagger = function(arg_24_0, arg_24_1, arg_24_2)
		local var_24_0 = arg_24_2[1]

		if ALIVE[arg_24_0] and Unit.alive(var_24_0) and Managers.player.is_server then
			local var_24_1 = ScriptUnit.extension(var_24_0, "buff_system")

			if var_24_1 then
				var_24_1:add_buff("tank_unbalance_buff")
			end
		end
	end,
	kills_stack_fiery_push = function(arg_25_0, arg_25_1, arg_25_2)
		if ALIVE[arg_25_0] then
			ScriptUnit.extension(arg_25_0, "buff_system"):add_buff("bw_kill_stacks")
		end
	end,
	add_stacking_damage_from_melee_headshot = function(arg_26_0, arg_26_1, arg_26_2)
		local var_26_0 = arg_26_2[3]
		local var_26_1 = arg_26_2[2]

		if Unit.alive(arg_26_0) and var_26_0 == "head" and (var_26_1 == "light_attack" or var_26_1 == "heavy_attack") then
			local var_26_2 = ScriptUnit.extension(arg_26_0, "buff_system")
			local var_26_3 = arg_26_1.template
			local var_26_4 = var_26_3.inherited_multiplier
			local var_26_5 = var_26_3.inherited_duration

			table.clear(var_0_5)

			var_0_5.external_optional_multiplier = var_26_4
			var_0_5.external_optional_duration = var_26_5

			var_26_2:add_buff("stacking_melee_damage", var_0_5)
		end
	end,
	heal_on_melee_headshot = function(arg_27_0, arg_27_1, arg_27_2)
		local var_27_0 = arg_27_2[3]
		local var_27_1 = arg_27_2[2]

		if ALIVE[arg_27_0] and var_27_0 == "head" and (var_27_1 == "light_attack" or var_27_1 == "heavy_attack") then
			local var_27_2 = arg_27_1.template.bonus

			DamageUtils.heal_network(arg_27_0, arg_27_0, var_27_2, "heal_from_proc")
		end
	end,
	heal_on_ranged_headshot = function(arg_28_0, arg_28_1, arg_28_2)
		local var_28_0 = arg_28_2[3]
		local var_28_1 = arg_28_2[2]

		if ALIVE[arg_28_0] and var_28_0 == "head" and (var_28_1 == "projectile" or var_28_1 == "instant_projectile" or var_28_1 == "heavy_instant_projectile") then
			local var_28_2 = arg_28_1.template.bonus

			DamageUtils.heal_network(arg_28_0, arg_28_0, var_28_2, "heal_from_proc")
		end
	end,
	heal_on_crit = function(arg_29_0, arg_29_1, arg_29_2)
		if Unit.alive(arg_29_0) then
			local var_29_0 = arg_29_1.template.bonus

			DamageUtils.heal_network(arg_29_0, arg_29_0, var_29_0, "heal_from_proc")
		end
	end,
	add_buff_on_ranged_critical_hit = function(arg_30_0, arg_30_1, arg_30_2)
		if Unit.alive(arg_30_0) then
			local var_30_0 = arg_30_2[5]

			if arg_30_2[6] and var_30_0 ~= "MELEE_1H" and var_30_0 ~= "MELEE_2H" then
				local var_30_1 = ScriptUnit.extension(arg_30_0, "buff_system")
				local var_30_2 = arg_30_1.template.buff_to_add
				local var_30_3 = Managers.state.network
				local var_30_4 = var_30_3.network_transmit
				local var_30_5 = var_30_3:unit_game_object_id(arg_30_0)
				local var_30_6 = NetworkLookup.buff_templates[var_30_2]

				if var_0_7() then
					var_30_1:add_buff(var_30_2, {
						attacker_unit = arg_30_0
					})
					var_30_4:send_rpc_clients("rpc_add_buff", var_30_5, var_30_6, var_30_5, 0, false)
				else
					var_30_4:send_rpc_server("rpc_add_buff", var_30_5, var_30_6, var_30_5, 0, true)
				end
			end
		end
	end,
	apply_burn_to_enemies = function(arg_31_0, arg_31_1, arg_31_2)
		local var_31_0 = arg_31_2[1]

		if Unit.alive(arg_31_0) and Unit.alive(var_31_0) then
			local var_31_1 = ScriptUnit.extension(var_31_0, "buff_system")

			table.clear(var_0_5)

			var_0_5.attacker_unit = arg_31_0

			var_31_1:add_buff("flaming_shield_burning_dot", var_0_5)
		end
	end,
	regen_stamina_on_charged_attacks = function(arg_32_0, arg_32_1, arg_32_2)
		if arg_32_2[2] ~= "heavy_attack" then
			return
		end

		if ALIVE[arg_32_0] then
			ScriptUnit.extension(arg_32_0, "buff_system"):add_buff("stamina_regen", var_0_5)
		end
	end,
	add_buff_on_charged_attack_hit = function(arg_33_0, arg_33_1, arg_33_2)
		if not Managers.state.network.is_server then
			return
		end

		local var_33_0 = arg_33_2[2]
		local var_33_1 = arg_33_1.template
		local var_33_2 = var_33_1.buff_to_add
		local var_33_3 = var_33_1.server_controlled

		if var_33_0 ~= "heavy_attack" then
			return
		end

		if Unit.alive(arg_33_0) and var_33_2 then
			Managers.state.entity:system("buff_system"):add_buff(arg_33_0, var_33_2, arg_33_0, var_33_3)
		end
	end,
	sienna_unchained_regen_stamina_on_charged_attacks = function(arg_34_0, arg_34_1, arg_34_2)
		if arg_34_2[2] ~= "heavy_attack" then
			return
		end

		if ALIVE[arg_34_0] then
			ScriptUnit.extension(arg_34_0, "buff_system"):add_buff("sienna_unchained_stamina_regen", var_0_5)
		end
	end,
	markus_mercenary_regen_stamina_on_charged_attacks = function(arg_35_0, arg_35_1, arg_35_2)
		if arg_35_2[2] ~= "heavy_attack" then
			return
		end

		if ALIVE[arg_35_0] then
			ScriptUnit.extension(arg_35_0, "buff_system"):add_buff("markus_mercenary_stamina_regen_buff", var_0_5)
		end
	end,
	markus_knight_regen_stamina_on_charged_attacks = function(arg_36_0, arg_36_1, arg_36_2)
		if arg_36_2[2] ~= "heavy_attack" then
			return
		end

		if ALIVE[arg_36_0] then
			ScriptUnit.extension(arg_36_0, "buff_system"):add_buff("markus_knight_stamina_regen_buff", var_0_5)
		end
	end,
	bardin_ironbreaker_gromril_stagger = function(arg_37_0, arg_37_1, arg_37_2)
		if not Managers.state.network.is_server then
			return
		end

		if Unit.alive(arg_37_0) then
			local var_37_0 = arg_37_1.template.explosion_template
			local var_37_1 = Managers.world:world(LevelHelper.INGAME_WORLD_NAME)

			if not var_37_1 then
				return
			end

			local var_37_2 = POSITION_LOOKUP[arg_37_0]
			local var_37_3 = Quaternion.identity()
			local var_37_4 = Managers.player:owner(arg_37_0)
			local var_37_5 = var_37_4 and var_37_4.bot_player and true or false
			local var_37_6 = ScriptUnit.has_extension(arg_37_0, "career_system"):get_career_power_level()

			DamageUtils.create_explosion(var_37_1, arg_37_0, var_37_2, var_37_3, var_37_0, 1, "career_ability", true, var_37_5, arg_37_0, var_37_6, false)
		end
	end,
	bardin_ironbreaker_gromril_trigger_rising_anger = function(arg_38_0, arg_38_1, arg_38_2)
		if ALIVE[arg_38_0] then
			arg_38_1.buff_ids = arg_38_1.buff_ids or {}

			local var_38_0 = ScriptUnit.extension(arg_38_0, "buff_system")
			local var_38_1 = #arg_38_1.buff_ids

			for iter_38_0 = 1, var_38_1 do
				var_38_0:remove_buff(arg_38_1.buff_ids[iter_38_0])
			end

			table.clear(arg_38_1.buff_ids)

			local var_38_2 = arg_38_1.template

			for iter_38_1 = 1, var_38_1 do
				local var_38_3 = var_38_2.buff_on_pop

				var_38_0:add_buff(var_38_3)
			end

			arg_38_1._next_update_t = Managers.time:time("game") + 0.5
		end
	end,
	bardin_slayer_push_on_dodge = function(arg_39_0, arg_39_1, arg_39_2)
		if Unit.alive(arg_39_0) and ScriptUnit.has_extension(arg_39_0, "status_system"):get_dodge_cooldown() >= 1 then
			local var_39_0 = ScriptUnit.has_extension(arg_39_0, "first_person_system")
			local var_39_1 = ScriptUnit.has_extension(arg_39_0, "career_system")
			local var_39_2 = arg_39_2[1]:unbox()
			local var_39_3 = arg_39_1.template.explosion_template
			local var_39_4 = POSITION_LOOKUP[arg_39_0]
			local var_39_5 = var_39_0:current_rotation()
			local var_39_6 = var_39_1:get_career_power_level()
			local var_39_7 = 2
			local var_39_8 = Quaternion.look(Vector3.flat(Quaternion.forward(var_39_5)), Vector3.up())
			local var_39_9 = Quaternion.rotate(var_39_8, var_39_2)
			local var_39_10 = var_39_4 + Vector3.normalize(var_39_9) * var_39_7

			Managers.state.entity:system("area_damage_system"):create_explosion(arg_39_0, var_39_10, var_39_5, var_39_3, 1, "career_ability", var_39_6, false)
		end
	end,
	bardin_ironbreaker_regen_stamina_on_block_broken = function(arg_40_0, arg_40_1, arg_40_2)
		if Unit.alive(arg_40_0) and arg_40_1.template.proc_chance >= math.random() then
			ScriptUnit.has_extension(arg_40_0, "status_system"):remove_all_fatigue()
		end
	end,
	bardin_ironbreaker_regen_stamina_on_charged_attacks = function(arg_41_0, arg_41_1, arg_41_2)
		if arg_41_2[2] ~= "heavy_attack" then
			return
		end

		if Unit.alive(arg_41_0) then
			ScriptUnit.extension(arg_41_0, "buff_system"):add_buff("bardin_ironbreaker_regen_stamina_on_charged_attacks_buff", var_0_5)
		end
	end,
	bardin_ironbreaker_cooldown_reduction_on_kill_while_full_stamina = function(arg_42_0, arg_42_1, arg_42_2)
		if not ALIVE[arg_42_0] then
			return
		end

		local var_42_0 = ScriptUnit.has_extension(arg_42_0, "status_system")

		if var_42_0 and var_42_0:fatigued() then
			return
		end

		local var_42_1 = arg_42_2[1]

		if not var_42_1 then
			return
		end

		local var_42_2 = var_42_1[DamageDataIndex.ATTACK_TYPE]

		if not var_42_2 or var_42_2 ~= "light_attack" and var_42_2 ~= "heavy_attack" then
			return
		end

		local var_42_3 = arg_42_1.template.cooldown_reduction

		ScriptUnit.has_extension(arg_42_0, "career_system"):reduce_activated_ability_cooldown_percent(var_42_3)
	end,
	maidenguard_add_power_buff_on_block = function(arg_43_0, arg_43_1, arg_43_2)
		local var_43_0 = arg_43_1.template

		if ALIVE[arg_43_0] then
			local var_43_1 = var_43_0.buff_to_add
			local var_43_2 = Managers.state.entity:system("buff_system")

			if not arg_43_1.buff_list then
				arg_43_1.buff_list = {}
			end

			local var_43_3 = var_43_0.amount_to_add

			for iter_43_0 = 1, var_43_3 do
				local var_43_4 = #arg_43_1.buff_list

				if var_43_4 < var_43_0.max_sub_buff_stacks then
					arg_43_1.buff_list[var_43_4 + 1] = var_43_2:add_buff_synced(arg_43_0, var_43_1, BuffSyncType.LocalAndServer)
				end
			end
		end
	end,
	remove_buff_on_action = function(arg_44_0, arg_44_1, arg_44_2)
		if ALIVE[arg_44_0] then
			local var_44_0 = arg_44_2[1].kind

			if not var_44_0 or var_44_0 ~= "flamethrower" and var_44_0 ~= "charged_projectile" and var_44_0 ~= "bullet_spray" and var_44_0 ~= "charge" then
				return
			end

			local var_44_1 = arg_44_1.template.buff_ids

			if not var_44_1 or #var_44_1 < 1 then
				return
			end

			ScriptUnit.extension(arg_44_0, "buff_system"):remove_buff(var_44_1[#var_44_1])
			table.remove(var_44_1, #var_44_1)
		end
	end,
	increased_melee_damage = function(arg_45_0, arg_45_1, arg_45_2)
		if ALIVE[arg_45_0] then
			local var_45_0 = ScriptUnit.extension(arg_45_0, "buff_system")
			local var_45_1 = arg_45_1.template
			local var_45_2 = var_45_1.inherited_multiplier
			local var_45_3 = var_45_1.inherited_duration

			table.clear(var_0_5)

			var_0_5.external_optional_multiplier = var_45_2
			var_0_5.external_optional_duration = var_45_3

			var_45_0:add_buff("increased_melee_damage_from_proc", var_0_5)
		end
	end,
	add_gromril_delay = function(arg_46_0, arg_46_1, arg_46_2)
		if not ALIVE[arg_46_0] then
			return
		end

		if var_0_6(arg_46_0) or var_0_7() then
			local var_46_0 = "bardin_ironbreaker_gromril_delay"

			if ScriptUnit.extension(arg_46_0, "talent_system"):has_talent("bardin_ironbreaker_max_gromril_delay", "dwarf_ranger", true) then
				var_46_0 = "bardin_ironbreaker_gromril_delay_short"
			end

			ScriptUnit.extension(arg_46_0, "buff_system"):add_buff(var_46_0)
		end
	end,
	reduce_ally_damage_taken_on_revived_ally = function(arg_47_0, arg_47_1, arg_47_2)
		local var_47_0 = arg_47_2[1]

		if ALIVE[arg_47_0] and ALIVE[var_47_0] then
			ScriptUnit.extension(var_47_0, "buff_system"):add_buff("bardin_ironbreaker_reduce_damage_taken_on_revive")
		end
	end,
	victor_zealot_gain_invulnerability = function(arg_48_0, arg_48_1, arg_48_2)
		local var_48_0 = ScriptUnit.extension(arg_48_0, "status_system")

		if ALIVE[arg_48_0] and not var_48_0:is_knocked_down() then
			local var_48_1 = ScriptUnit.extension(arg_48_0, "health_system")
			local var_48_2 = ScriptUnit.extension(arg_48_0, "buff_system")

			if var_48_2:has_buff_perk("invulnerable") or var_48_2:has_buff_perk("ignore_death") then
				return false
			end

			local var_48_3 = arg_48_2[2] >= var_48_1:current_health()
			local var_48_4 = arg_48_1.template.buff_to_add

			if var_48_3 then
				var_48_2:add_buff(var_48_4)

				return true
			end
		end
	end,
	sienna_unchained_vent_overheat_on_low_health = function(arg_49_0, arg_49_1, arg_49_2)
		local var_49_0 = ScriptUnit.extension(arg_49_0, "status_system")

		if ALIVE[arg_49_0] and not var_49_0:is_knocked_down() then
			local var_49_1 = ScriptUnit.extension(arg_49_0, "health_system")
			local var_49_2 = arg_49_2[2]
			local var_49_3 = (var_49_1:current_health() - var_49_2) / var_49_1:get_max_health()
			local var_49_4 = var_49_1:current_health_percent()
			local var_49_5 = arg_49_1.template
			local var_49_6 = var_49_5.threshold

			if var_49_3 <= var_49_6 and var_49_6 < var_49_4 then
				local var_49_7 = ScriptUnit.extension(arg_49_0, "overcharge_system")
				local var_49_8 = ScriptUnit.extension(arg_49_0, "buff_system")
				local var_49_9 = var_49_5.buff_to_add

				var_49_7:reset()
				var_49_8:add_buff(var_49_9)

				return true
			end
		end
	end,
	add_increased_ranged_damage = function(arg_50_0, arg_50_1, arg_50_2)
		if Unit.alive(arg_50_0) then
			ScriptUnit.extension(arg_50_0, "buff_system"):add_buff("passive_career_wh_2_proc")
		end
	end,
	ww_melee_kills_stack_ranged_damage = function(arg_51_0, arg_51_1, arg_51_2)
		if ALIVE[arg_51_0] then
			ScriptUnit.extension(arg_51_0, "buff_system"):add_buff("ww_increased_ranged_damage_from_proc")
		end
	end,
	wh_stack_kills_to_be_uninterruptible = function(arg_52_0, arg_52_1, arg_52_2)
		if ALIVE[arg_52_0] then
			ScriptUnit.extension(arg_52_0, "buff_system"):add_buff("wh_kill_stack_from_proc")
		end
	end,
	ww_melee_attacks_apply_damage_taken = function(arg_53_0, arg_53_1, arg_53_2)
		local var_53_0 = arg_53_2[1]

		if ALIVE[arg_53_0] and ALIVE[var_53_0] then
			ScriptUnit.extension(var_53_0, "buff_system"):add_buff("ww_applied_damage_taken")
		end
	end,
	es_legshots_cripple = function(arg_54_0, arg_54_1, arg_54_2)
		local var_54_0 = arg_54_2[1]
		local var_54_1 = arg_54_2[2]
		local var_54_2 = arg_54_2[3]

		if ALIVE[arg_54_0] and ALIVE[var_54_0] and (var_54_1 == "instant_projectile" or var_54_1 == "projectile" or var_54_1 == "heavy_instant_projectile") and (var_54_2 == "left_leg" or var_54_2 == "right_leg") then
			ScriptUnit.extension(var_54_0, "buff_system"):add_buff("es_movement_speed_debuff")
		end
	end,
	ranged_crits_increase_dmg_vs_armour_type = function(arg_55_0, arg_55_1, arg_55_2)
		local var_55_0 = arg_55_2[1]
		local var_55_1 = arg_55_2[2]
		local var_55_2
		local var_55_3 = AiUtils.unit_breed(var_55_0)
		local var_55_4 = Unit.get_data(var_55_0, "armor")
		local var_55_5 = ActionUtils.get_target_armor(var_55_2, var_55_3, var_55_4)

		if var_55_1 and (var_55_1 == "projectile" or var_55_1 == "instant_projectile" or var_55_1 == "aoe" or var_55_1 == "heavy_instant_projectile") and ALIVE[arg_55_0] then
			local var_55_6 = ScriptUnit.extension(arg_55_0, "buff_system")

			if var_55_5 == 1 then
				var_55_6:add_buff("ranged_power_vs_unarmored")
			elseif var_55_5 == 2 then
				var_55_6:add_buff("ranged_power_vs_armored")
			elseif var_55_5 == 3 then
				var_55_6:add_buff("ranged_power_vs_large")
			elseif var_55_5 == 5 then
				var_55_6:add_buff("ranged_power_vs_frenzy")
			end
		end
	end,
	debuff_defence_on_crit = function(arg_56_0, arg_56_1, arg_56_2)
		local var_56_0 = arg_56_2[1]

		if ALIVE[arg_56_0] and ALIVE[var_56_0] then
			ScriptUnit.extension(var_56_0, "buff_system"):add_buff("defence_debuff")
		end
	end,
	victor_witchhunter_debuff_defence_on_crit = function(arg_57_0, arg_57_1, arg_57_2)
		local var_57_0 = arg_57_2[1]

		if ALIVE[arg_57_0] and ALIVE[var_57_0] then
			ScriptUnit.extension(var_57_0, "buff_system"):add_buff("defence_debuff_enemies")
		end
	end,
	victor_witchhunter_activated_ability_refund_cooldown_on_enemies_hit = function(arg_58_0, arg_58_1, arg_58_2)
		if ALIVE[arg_58_0] then
			local var_58_0 = arg_58_2[4]
			local var_58_1 = arg_58_2[2]
			local var_58_2 = arg_58_1.template
			local var_58_3 = var_58_2.required_targets

			if var_58_0 == 1 then
				arg_58_1.can_trigger = true
			end

			if var_58_1 == "ability" and var_58_3 <= var_58_0 and arg_58_1.can_trigger then
				local var_58_4 = ScriptUnit.has_extension(arg_58_0, "career_system")
				local var_58_5 = var_58_2.cooldown_reduction

				var_58_4:reduce_activated_ability_cooldown_percent(var_58_5)

				arg_58_1.can_trigger = false
			end
		end
	end,
	victor_witchhunter_activated_ability_increased_duration_on_enemies_hit = function(arg_59_0, arg_59_1, arg_59_2)
		if ALIVE[arg_59_0] then
			local var_59_0 = arg_59_2[4]
			local var_59_1 = arg_59_2[2]
			local var_59_2 = arg_59_1.template
			local var_59_3 = var_59_2.required_targets

			if var_59_0 == 1 then
				arg_59_1.can_trigger = true
			end

			if var_59_1 ~= "ability" then
				return
			end

			local var_59_4

			if var_59_3 <= var_59_0 and arg_59_1.can_trigger then
				var_59_4 = var_59_2.long_buff
			else
				var_59_4 = var_59_2.short_buff
			end

			local var_59_5 = FrameTable.alloc_table()
			local var_59_6 = Managers.state.entity:system("proximity_system").player_units_broadphase
			local var_59_7 = POSITION_LOOKUP[arg_59_0]
			local var_59_8 = 10
			local var_59_9 = Managers.state.entity:system("buff_system")

			Broadphase.query(var_59_6, var_59_7, var_59_8, var_59_5)

			local var_59_10 = Managers.state.side

			for iter_59_0, iter_59_1 in pairs(var_59_5) do
				if Unit.alive(iter_59_1) and not var_59_10:is_enemy(arg_59_0, iter_59_1) then
					local var_59_11 = ScriptUnit.extension(iter_59_1, "buff_system")
					local var_59_12 = var_59_11:get_non_stacking_buff(var_59_2.short_buff)

					if var_59_4 == var_59_2.long_buff and var_59_12 then
						var_59_11:remove_buff(var_59_12.id)
					end

					var_59_9:add_buff(iter_59_1, var_59_4, arg_59_0)
				end
			end
		end
	end,
	sienna_unchained_activated_ability_power_on_enemies_hit = function(arg_60_0, arg_60_1, arg_60_2)
		if Managers.state.network.is_server and ALIVE[arg_60_0] then
			local var_60_0 = arg_60_2[2]

			if var_60_0 and var_60_0 == "ability" then
				local var_60_1 = arg_60_1.template
				local var_60_2 = Managers.state.entity:system("buff_system")
				local var_60_3 = var_60_1.buff_to_add

				var_60_2:add_buff(arg_60_0, var_60_3, arg_60_0, false)
			end
		end
	end,
	sienna_adept_add_damage_reduction_buff_on_ignited_enemy = function(arg_61_0, arg_61_1, arg_61_2)
		if ALIVE[arg_61_0] then
			local var_61_0 = arg_61_1.template
			local var_61_1 = var_61_0.require_alive_enemy
			local var_61_2 = arg_61_2[4]

			if var_61_1 and not HEALTH_ALIVE[var_61_2] then
				return
			end

			local var_61_3 = Managers.state.entity:system("buff_system")
			local var_61_4 = var_61_0.buff_to_add

			var_61_3:add_buff(arg_61_0, var_61_4, arg_61_0, false)
		end
	end,
	sienna_adept_add_attack_speed_buff_on_enemies_hit = function(arg_62_0, arg_62_1, arg_62_2)
		if ALIVE[arg_62_0] then
			local var_62_0 = arg_62_2[4]
			local var_62_1 = arg_62_1.template
			local var_62_2 = var_62_1.required_targets

			if var_62_0 == 1 then
				arg_62_1.can_trigger = true
			end

			if var_62_0 and var_62_2 <= var_62_0 and arg_62_1.can_trigger then
				local var_62_3 = ScriptUnit.has_extension(arg_62_0, "buff_system")
				local var_62_4 = var_62_1.buff_to_add

				var_62_3:add_buff(var_62_4)

				arg_62_1.can_trigger = false
			end
		end
	end,
	sienna_scholar_refund_activated_ability_cooldown = function(arg_63_0, arg_63_1, arg_63_2)
		if ALIVE[arg_63_0] then
			local var_63_0 = arg_63_2[4]
			local var_63_1 = arg_63_2[5]
			local var_63_2 = arg_63_2[6]

			if var_63_0 <= 1 and var_63_1 == "RANGED_ABILITY" and var_63_2 then
				ScriptUnit.extension(arg_63_0, "career_system"):reduce_activated_ability_cooldown_percent(1)
			end
		end
	end,
	kerillian_shade_debuff_defence_on_crit = function(arg_64_0, arg_64_1, arg_64_2)
		local var_64_0 = arg_64_2[1]

		if ALIVE[arg_64_0] and ALIVE[var_64_0] then
			ScriptUnit.extension(var_64_0, "buff_system"):add_buff("defence_debuff_enemies")
		end
	end,
	kerillian_shade_stealth_on_backstab_kill = function(arg_65_0, arg_65_1, arg_65_2)
		local var_65_0 = Managers.player:owner(arg_65_0)
		local var_65_1 = var_65_0.player_unit
		local var_65_2 = var_65_0.local_player
		local var_65_3 = var_65_0.bot_player
		local var_65_4 = arg_65_2[1][DamageDataIndex.BACKSTAB_MULTIPLIER]

		if ALIVE[arg_65_0] and var_65_4 and var_65_4 > 1 then
			local var_65_5 = ScriptUnit.extension(var_65_1, "buff_system")

			if var_65_5:has_buff_type("kerillian_shade_activated_ability_short_blocker") then
				return
			end

			local var_65_6 = {
				"kerillian_shade_activated_ability_short",
				"kerillian_shade_activated_ability_short_blocker"
			}

			if var_65_2 or var_0_7 and var_65_3 then
				local var_65_7 = Managers.state.network
				local var_65_8 = var_65_7.network_transmit

				for iter_65_0 = 1, #var_65_6 do
					local var_65_9 = var_65_6[iter_65_0]
					local var_65_10 = var_65_7:unit_game_object_id(var_65_1)
					local var_65_11 = NetworkLookup.buff_templates[var_65_9]

					if var_0_7() then
						var_65_5:add_buff(var_65_9, {
							attacker_unit = var_65_1
						})
						var_65_8:send_rpc_clients("rpc_add_buff", var_65_10, var_65_11, var_65_10, 0, false)
					else
						var_65_8:send_rpc_server("rpc_add_buff", var_65_10, var_65_11, var_65_10, 0, true)
					end
				end
			end
		end
	end,
	kerillian_shade_cooldown_regen_on_backstab_kill = function(arg_66_0, arg_66_1, arg_66_2)
		local var_66_0 = Managers.player:owner(arg_66_0)
		local var_66_1 = var_66_0.player_unit
		local var_66_2 = var_66_0.local_player
		local var_66_3 = var_66_0.bot_player
		local var_66_4 = arg_66_2[1][DamageDataIndex.BACKSTAB_MULTIPLIER]

		if ALIVE[arg_66_0] and var_66_4 and var_66_4 > 1 then
			local var_66_5 = ScriptUnit.extension(var_66_1, "buff_system")
			local var_66_6 = arg_66_1.template.buff_to_add

			if var_66_2 or var_0_7 and var_66_3 then
				var_66_5:add_buff(var_66_6)
			end
		end
	end,
	kerillian_shade_buff_on_charged_backstab = function(arg_67_0, arg_67_1, arg_67_2)
		local var_67_0 = arg_67_2[1]

		if ALIVE[arg_67_0] and ALIVE[var_67_0] then
			local var_67_1 = POSITION_LOOKUP[arg_67_0]
			local var_67_2 = POSITION_LOOKUP[var_67_0]
			local var_67_3 = Vector3.normalize(var_67_2 - var_67_1)
			local var_67_4 = Quaternion.forward(Unit.local_rotation(var_67_0, 0))
			local var_67_5 = Vector3.dot(var_67_4, var_67_3)
			local var_67_6 = var_67_5 >= 0.55 and var_67_5 <= 1
			local var_67_7 = arg_67_2[2]
			local var_67_8 = ScriptUnit.extension(arg_67_0, "buff_system")
			local var_67_9 = arg_67_1.template.buff_to_add

			if var_67_6 and var_67_7 == "heavy_attack" then
				if not var_67_8:has_buff_type("kerillian_shade_passive_improved_crit_blocker") then
					var_67_8:add_buff(var_67_9)
					var_67_8:add_buff("kerillian_shade_passive_improved_crit_blocker")
				end
			else
				local var_67_10 = var_67_8:num_buff_stacks(var_67_9)

				for iter_67_0 = 1, var_67_10 do
					local var_67_11 = var_67_8:get_buff_type(var_67_9)

					if not var_67_11 then
						break
					end

					var_67_8:remove_buff(var_67_11.id)
				end
			end
		end
	end,
	kerillian_waywatcher_restore_ammo_on_career_skill_special_kill = function(arg_68_0, arg_68_1, arg_68_2)
		local var_68_0 = arg_68_2[1]
		local var_68_1 = var_68_0[DamageDataIndex.ATTACKER]
		local var_68_2 = var_68_0[DamageDataIndex.DAMAGE_SOURCE_NAME]
		local var_68_3 = arg_68_2[2]
		local var_68_4

		if var_68_3 then
			var_68_4 = var_68_3.elite or var_68_3.special
		end

		if ALIVE[arg_68_0] and var_68_4 and arg_68_0 == var_68_1 and var_68_2 == "kerillian_waywatcher_career_skill_weapon" then
			local var_68_5 = arg_68_1.template
			local var_68_6 = "slot_ranged"
			local var_68_7 = ScriptUnit.extension(arg_68_0, "inventory_system"):get_slot_data(var_68_6)
			local var_68_8 = var_68_7.right_unit_1p
			local var_68_9 = var_68_7.left_unit_1p
			local var_68_10 = ScriptUnit.has_extension(var_68_8, "ammo_system")
			local var_68_11 = ScriptUnit.has_extension(var_68_9, "ammo_system")
			local var_68_12 = var_68_10 or var_68_11
			local var_68_13 = var_68_5.ammo_bonus_fraction

			if var_68_12 then
				local var_68_14 = math.max(math.round(var_68_12:max_ammo() * var_68_13), 1)

				var_68_12:add_ammo_to_reserve(var_68_14)
			end

			local var_68_15 = ScriptUnit.has_extension(arg_68_0, "energy_system")

			if var_68_15 then
				local var_68_16 = var_68_13 * var_68_15:get_max()

				var_68_15:add_energy(var_68_16)
			end
		end
	end,
	restore_ammo_on_special_kill = function(arg_69_0, arg_69_1, arg_69_2)
		local var_69_0 = arg_69_2[1][DamageDataIndex.ATTACKER]

		if ALIVE[arg_69_0] and arg_69_0 == var_69_0 then
			local var_69_1 = arg_69_1.template
			local var_69_2 = "slot_ranged"
			local var_69_3 = ScriptUnit.extension(arg_69_0, "inventory_system"):get_slot_data(var_69_2)
			local var_69_4 = var_69_3.right_unit_1p
			local var_69_5 = var_69_3.left_unit_1p
			local var_69_6 = ScriptUnit.has_extension(var_69_4, "ammo_system")
			local var_69_7 = ScriptUnit.has_extension(var_69_5, "ammo_system")
			local var_69_8 = var_69_6 or var_69_7

			if var_69_8 then
				local var_69_9 = var_69_1.ammo_bonus_fraction
				local var_69_10 = math.max(math.round(var_69_8:max_ammo() * var_69_9), 1)

				var_69_8:add_ammo_to_reserve(var_69_10)
			end
		end
	end,
	buff_defence_on_heal = function(arg_70_0, arg_70_1, arg_70_2)
		local var_70_0 = arg_70_2[1]
		local var_70_1 = arg_70_2[3]

		if arg_70_0 == var_70_0 and (var_70_1 == "healing_draught" or var_70_1 == "bandage") then
			ScriptUnit.extension(arg_70_0, "buff_system"):add_buff("trait_necklace_damage_taken_reduction_buff")
		end
	end,
	buff_defence_on_damage_taken = function(arg_71_0, arg_71_1, arg_71_2)
		if ALIVE[arg_71_0] then
			local var_71_0 = arg_71_2[1]
			local var_71_1 = arg_71_2[2]
			local var_71_2 = arg_71_2[3]
			local var_71_3 = Managers.state.entity:system("buff_system")
			local var_71_4 = "trait_necklace_damage_taken_reduction_buff"
			local var_71_5 = false

			if var_71_0 ~= arg_71_0 and var_71_1 > 0 and var_71_2 ~= "overcharge" then
				var_71_3:add_buff(arg_71_0, var_71_4, arg_71_0, var_71_5)
			end
		end
	end,
	add_buff_on_enemy_damage_taken = function(arg_72_0, arg_72_1, arg_72_2)
		if Unit.alive(arg_72_0) then
			local var_72_0 = arg_72_2[1]
			local var_72_1 = arg_72_2[2]
			local var_72_2 = arg_72_2[3]
			local var_72_3 = Managers.state.entity:system("buff_system")
			local var_72_4 = arg_72_1.template.buff_to_add
			local var_72_5 = false

			if not (Managers.state.side.side_by_unit[arg_72_0] == Managers.state.side.side_by_unit[var_72_0]) and var_72_0 ~= arg_72_0 and var_72_1 > 0 and var_72_2 ~= "overcharge" then
				var_72_3:add_buff(arg_72_0, var_72_4, arg_72_0, var_72_5)
			end
		end
	end,
	restore_stamina_on_enemy_damage_taken = function(arg_73_0, arg_73_1, arg_73_2)
		if ALIVE[arg_73_0] then
			local var_73_0 = arg_73_2[1]
			local var_73_1 = arg_73_2[2]
			local var_73_2 = arg_73_2[3]
			local var_73_3 = ScriptUnit.has_extension(arg_73_0, "status_system")

			if not (Managers.state.side.side_by_unit[arg_73_0] == Managers.state.side.side_by_unit[var_73_0]) and var_73_0 ~= arg_73_0 and var_73_1 > 0 and var_73_2 ~= "overcharge" then
				var_73_3:remove_all_fatigue()
			end
		end
	end,
	bardin_ranger_scavenge_proc = function(arg_74_0, arg_74_1, arg_74_2)
		if not Managers.state.network.is_server then
			return
		end

		local var_74_0 = Vector3(0, 0.25, 0)
		local var_74_1 = Vector3(0, -0.25, 0)

		if ALIVE[arg_74_0] then
			local var_74_2 = arg_74_1.template.drop_chance
			local var_74_3 = ScriptUnit.extension(arg_74_0, "talent_system")

			if math.random(1, 100) < var_74_2 * 100 then
				local var_74_4 = POSITION_LOOKUP[arg_74_0] + Vector3.up() * 0.1
				local var_74_5 = true
				local var_74_6 = Managers.state.entity:system("pickup_system")

				if var_74_3:has_talent("bardin_ranger_passive_spawn_healing_draught") then
					if math.random(1, 4) > 1 then
						var_74_6:buff_spawn_pickup("ammo_ranger", var_74_4, var_74_5)
					else
						var_74_6:buff_spawn_pickup("frag_grenade_t1", var_74_4, var_74_5)
						var_74_6:buff_spawn_pickup("ammo_ranger", var_74_4, var_74_5)
					end
				elseif var_74_3:has_talent("bardin_ranger_passive_spawn_potions_or_bombs") then
					if TalentUtils.get_talent_attribute("bardin_ranger_passive_spawn_potions_or_bombs", "spawn_chance") >= math.random() then
						local var_74_7 = math.random(1, 5)

						if var_74_7 >= 1 and var_74_7 <= 3 then
							local var_74_8 = Managers.state.game_mode:game_mode_key()
							local var_74_9 = BardinScavengerCustomPotions[var_74_8]

							if var_74_9 then
								local var_74_10 = math.random(1, #var_74_9)

								var_74_6:buff_spawn_pickup(var_74_9[var_74_10], var_74_4, var_74_5)
							elseif var_74_7 == 1 then
								var_74_6:buff_spawn_pickup("damage_boost_potion", var_74_4, var_74_5)
							elseif var_74_7 == 2 then
								var_74_6:buff_spawn_pickup("speed_boost_potion", var_74_4, var_74_5)
							elseif var_74_7 == 3 then
								var_74_6:buff_spawn_pickup("cooldown_reduction_potion", var_74_4, var_74_5)
							end
						elseif var_74_7 == 4 then
							var_74_6:buff_spawn_pickup("frag_grenade_t1", var_74_4, var_74_5)
						elseif var_74_7 == 5 then
							var_74_6:buff_spawn_pickup("fire_grenade_t1", var_74_4, var_74_5)
						end
					else
						var_74_6:buff_spawn_pickup("ammo_ranger", var_74_4, var_74_5)
					end
				elseif var_74_3:has_talent("bardin_ranger_passive_improved_ammo") then
					var_74_6:buff_spawn_pickup("ammo_ranger_improved", var_74_4, var_74_5)
				elseif var_74_3:has_talent("bardin_ranger_passive_ale") then
					local var_74_11 = math.random(1, 4)

					if var_74_11 == 1 or var_74_11 == 2 then
						var_74_6:buff_spawn_pickup("bardin_survival_ale", var_74_4 + var_74_0, var_74_5)
						var_74_6:buff_spawn_pickup("ammo_ranger", var_74_4 + var_74_1, var_74_5)
					else
						var_74_6:buff_spawn_pickup("ammo_ranger", var_74_4, var_74_5)
					end
				else
					var_74_6:buff_spawn_pickup("ammo_ranger", var_74_4, var_74_5)
				end
			end
		end
	end,
	bardin_ranger_add_power_on_no_ammo_proc = function(arg_75_0, arg_75_1, arg_75_2)
		if not Managers.state.network.is_server then
			return
		end

		local var_75_0 = Managers.state.entity:system("buff_system")
		local var_75_1 = ScriptUnit.extension(arg_75_0, "buff_system")
		local var_75_2 = arg_75_1.template.buff_to_add
		local var_75_3 = var_75_1:get_non_stacking_buff(var_75_2)
		local var_75_4 = true

		if not var_75_3 then
			local var_75_5 = var_75_0:add_buff(arg_75_0, var_75_2, arg_75_0, var_75_4)

			var_75_1:get_non_stacking_buff(var_75_2).server_buff_id = var_75_5
		end
	end,
	bardin_ranger_remove_power_on_no_ammo_proc = function(arg_76_0, arg_76_1, arg_76_2)
		if not Managers.state.network.is_server then
			return
		end

		local var_76_0 = Managers.state.entity:system("buff_system")
		local var_76_1 = ScriptUnit.extension(arg_76_0, "buff_system")
		local var_76_2 = arg_76_1.template.buff_to_remove
		local var_76_3 = var_76_1:get_non_stacking_buff(var_76_2)

		if var_76_3 and var_76_3.server_buff_id then
			var_76_0:remove_server_controlled_buff(arg_76_0, var_76_3.server_buff_id)
		end
	end,
	victor_bountyhunter_add_power_on_no_ammo_proc = function(arg_77_0, arg_77_1, arg_77_2)
		if not Managers.state.network.is_server then
			return
		end

		local var_77_0 = Managers.state.entity:system("buff_system")
		local var_77_1 = ScriptUnit.extension(arg_77_0, "buff_system")
		local var_77_2 = arg_77_1.template.buff_to_add
		local var_77_3 = var_77_1:get_stacking_buff(var_77_2)
		local var_77_4 = true

		if not var_77_3 then
			local var_77_5 = var_77_0:add_buff(arg_77_0, var_77_2, arg_77_0, var_77_4)

			var_77_1:get_stacking_buff(var_77_2).server_buff_id = var_77_5
		end
	end,
	victor_bountyhunter_remove_power_on_no_ammo_proc = function(arg_78_0, arg_78_1, arg_78_2)
		if not Managers.state.network.is_server then
			return
		end

		local var_78_0 = Managers.state.entity:system("buff_system")
		local var_78_1 = ScriptUnit.extension(arg_78_0, "buff_system")
		local var_78_2 = arg_78_1.template.buff_to_remove
		local var_78_3 = var_78_1:get_stacking_buff(var_78_2)

		if var_78_3 and var_78_3.server_buff_id then
			var_78_0:remove_server_controlled_buff(arg_78_0, var_78_3.server_buff_id)
		end
	end,
	debuff_defence_grenade_hit = function(arg_79_0, arg_79_1, arg_79_2)
		local var_79_0 = arg_79_2[1]
		local var_79_1 = arg_79_2[2]
		local var_79_2 = Unit.get_data(var_79_0, "breed")

		if var_79_1 == "grenade" and var_79_2 then
			ScriptUnit.extension(var_79_0, "buff_system"):add_buff("trait_trinket_grenade_damage_taken_buff")
		end
	end,
	activate_buff_on_disabler = function(arg_80_0, arg_80_1, arg_80_2)
		local var_80_0 = arg_80_1.template
		local var_80_1 = ScriptUnit.extension(arg_80_0, "status_system")
		local var_80_2 = var_80_1:is_disabled()
		local var_80_3 = var_80_0.buff_to_add

		if var_80_2 then
			local var_80_4 = var_80_1:get_disabler_unit()

			if var_80_4 == arg_80_2[1] and Unit.alive(var_80_4) then
				local var_80_5 = var_80_4 and Unit.get_data(var_80_4, "breed")

				if not var_80_5 or not var_80_5.boss then
					ScriptUnit.extension(var_80_4, "buff_system"):add_buff(var_80_3)
				end
			end
		end
	end,
	add_buff_to_all_players = function(arg_81_0, arg_81_1, arg_81_2)
		local var_81_0 = Managers.state.entity:system("buff_system")
		local var_81_1 = arg_81_1.template.buff_to_add
		local var_81_2 = Managers.state.side.side_by_unit[arg_81_0].PLAYER_AND_BOT_UNITS
		local var_81_3 = #var_81_2

		for iter_81_0 = 1, var_81_3 do
			local var_81_4 = var_81_2[iter_81_0]

			if Unit.alive(var_81_4) then
				var_81_0:add_buff(var_81_4, var_81_1, var_81_4, false)
			end
		end
	end,
	life_mutator_remove_regen = function(arg_82_0, arg_82_1, arg_82_2)
		if not Managers.state.network.is_server then
			return
		end

		if ALIVE[arg_82_0] then
			local var_82_0 = ScriptUnit.extension(arg_82_0, "buff_system")
			local var_82_1 = arg_82_1.health_regeneration_stack_ids

			if #var_82_1 > 0 then
				local var_82_2 = table.remove(var_82_1, 1)

				var_82_0:remove_buff(var_82_2)
			end
		end
	end,
	add_buff_on_stacks_on_hit = function(arg_83_0, arg_83_1, arg_83_2)
		if not Managers.state.network.is_server then
			return
		end

		local var_83_0 = arg_83_1.template
		local var_83_1 = Managers.state.entity:system("buff_system")
		local var_83_2 = arg_83_2[4]
		local var_83_3 = var_83_0.buff_to_add
		local var_83_4 = var_83_0.buff_on_stacks

		if not ScriptUnit.extension(arg_83_0, "buff_system"):has_buff_type(var_83_3) and var_83_2 < 2 then
			if not arg_83_1.stack then
				arg_83_1.stack = 1
			else
				arg_83_1.stack = arg_83_1.stack + 1
			end

			if arg_83_1.stack and var_83_4 <= arg_83_1.stack then
				arg_83_1.added_buff_id = var_83_1:add_buff(arg_83_0, var_83_3, arg_83_0, true)
				arg_83_1.stack = 0
			end
		elseif arg_83_1.added_buff_id and var_83_2 < 2 then
			var_83_1:remove_server_controlled_buff(arg_83_0, arg_83_1.added_buff_id)
		end
	end,
	add_buff_on_stacks_on_event = function(arg_84_0, arg_84_1, arg_84_2)
		if not Managers.state.network.is_server then
			return
		end

		local var_84_0 = arg_84_1.template
		local var_84_1 = Managers.state.entity:system("buff_system")
		local var_84_2 = var_84_0.buff_to_add
		local var_84_3 = var_84_0.buff_on_stacks

		if not ScriptUnit.extension(arg_84_0, "buff_system"):has_buff_type(var_84_2) then
			if not arg_84_1.stack then
				arg_84_1.stack = 1
			else
				arg_84_1.stack = arg_84_1.stack + 1
			end

			if arg_84_1.stack and var_84_3 <= arg_84_1.stack then
				arg_84_1.added_buff_id = var_84_1:add_buff(arg_84_0, var_84_2, arg_84_0, true)
				arg_84_1.stack = 0
			end
		elseif arg_84_1.added_buff_id then
			var_84_1:remove_server_controlled_buff(arg_84_0, arg_84_1.added_buff_id)
		end
	end,
	buff_consecutive_shots_damage = function(arg_85_0, arg_85_1, arg_85_2)
		local var_85_0 = arg_85_2[1]
		local var_85_1 = arg_85_2[2]
		local var_85_2 = arg_85_2[4]
		local var_85_3 = ScriptUnit.has_extension(var_85_0, "buff_system")
		local var_85_4 = ScriptUnit.has_extension(arg_85_0, "buff_system")

		if var_85_1 and (var_85_1 == "projectile" or var_85_1 == "instant_projectile" or var_85_1 == "aoe" or var_85_1 == "heavy_instant_projectile") then
			if var_85_3:has_buff_type("consecutive_shot_debuff") and var_85_2 == 1 then
				var_85_4:add_buff("consecutive_shot_buff")
			end

			var_85_3:add_buff("consecutive_shot_debuff")
		end
	end,
	block_increase_enemy_damage_taken = function(arg_86_0, arg_86_1, arg_86_2)
		local var_86_0 = arg_86_2[1]

		if ALIVE[var_86_0] then
			Managers.state.entity:system("buff_system"):add_buff_synced(var_86_0, "defence_debuff_enemies", BuffSyncType.All)
		end
	end,
	add_buff = function(arg_87_0, arg_87_1, arg_87_2)
		if ALIVE[arg_87_0] then
			local var_87_0 = arg_87_1.template.buff_to_add
			local var_87_1 = ScriptUnit.extension(arg_87_0, "buff_system")
			local var_87_2 = Managers.state.network
			local var_87_3 = var_87_2.network_transmit
			local var_87_4 = var_87_2:unit_game_object_id(arg_87_0)
			local var_87_5 = NetworkLookup.buff_templates[var_87_0]

			if var_0_7() then
				var_87_1:add_buff(var_87_0, {
					attacker_unit = arg_87_0
				})
				var_87_3:send_rpc_clients("rpc_add_buff", var_87_4, var_87_5, var_87_4, 0, false)
			else
				var_87_3:send_rpc_server("rpc_add_buff", var_87_4, var_87_5, var_87_4, 0, true)
			end
		end
	end,
	victor_witchhunter_ping_enemy_attack_speed = function(arg_88_0, arg_88_1, arg_88_2)
		if not ALIVE[arg_88_0] then
			return
		end

		if not arg_88_2[3] then
			return
		end

		local var_88_0 = arg_88_2[1]

		if not Managers.state.side:is_enemy(var_88_0, arg_88_0) then
			return
		end

		local var_88_1 = arg_88_1.template.buff_to_add

		table.clear(var_0_5)

		var_0_5.attacker_unit = arg_88_0

		local var_88_2 = Managers.player:owner(arg_88_0)

		Managers.state.entity:system("buff_system"):add_buff_synced(arg_88_0, var_88_1, BuffSyncType.Client, var_0_5, var_88_2.peer_id)
	end,
	add_buff_on_first_target_hit = function(arg_89_0, arg_89_1, arg_89_2)
		if ALIVE[arg_89_0] then
			if arg_89_2[4] > 1 then
				return
			end

			local var_89_0 = arg_89_1.template
			local var_89_1 = var_89_0.valid_attack_types
			local var_89_2 = arg_89_2[2]

			if var_89_1 and not var_89_1[var_89_2] then
				return
			end

			local var_89_3 = var_89_0.client_side
			local var_89_4 = var_89_0.buff_to_add
			local var_89_5 = ScriptUnit.extension(arg_89_0, "buff_system")

			if var_89_0.block_buff and var_89_5:has_buff_type(var_89_0.block_buff) then
				return
			end

			local var_89_6 = Managers.state.network
			local var_89_7 = var_89_6.network_transmit
			local var_89_8 = var_89_6:unit_game_object_id(arg_89_0)
			local var_89_9 = NetworkLookup.buff_templates[var_89_4]

			if var_89_3 then
				var_89_5:add_buff(var_89_4, {
					attacker_unit = arg_89_0
				})
			elseif var_0_7() then
				var_89_5:add_buff(var_89_4, {
					attacker_unit = arg_89_0
				})
				var_89_7:send_rpc_clients("rpc_add_buff", var_89_8, var_89_9, var_89_8, 0, false)
			else
				var_89_7:send_rpc_server("rpc_add_buff", var_89_8, var_89_9, var_89_8, 0, true)
			end
		end
	end,
	add_buff_on_first_target_hit_headshot = function(arg_90_0, arg_90_1, arg_90_2)
		if ALIVE[arg_90_0] then
			local var_90_0 = arg_90_2[5]

			if not var_90_0 or var_90_0 == "n/a" or var_90_0 ~= "RANGED" then
				return
			end

			if arg_90_2[3] ~= "head" then
				return
			end

			if arg_90_2[4] < 2 then
				local var_90_1 = arg_90_1.template.buff_to_add
				local var_90_2 = ScriptUnit.extension(arg_90_0, "buff_system")
				local var_90_3 = Managers.state.network
				local var_90_4 = var_90_3.network_transmit
				local var_90_5 = var_90_3:unit_game_object_id(arg_90_0)
				local var_90_6 = NetworkLookup.buff_templates[var_90_1]

				if var_0_7() then
					var_90_2:add_buff(var_90_1, {
						attacker_unit = arg_90_0
					})
					var_90_4:send_rpc_clients("rpc_add_buff", var_90_5, var_90_6, var_90_5, 0, false)
				else
					var_90_4:send_rpc_server("rpc_add_buff", var_90_5, var_90_6, var_90_5, 0, true)
				end
			end
		end
	end,
	add_buff_on_unmodified_headshot = function(arg_91_0, arg_91_1, arg_91_2)
		if ALIVE[arg_91_0] then
			local var_91_0 = arg_91_2[5]
			local var_91_1 = arg_91_2[2]
			local var_91_2 = arg_91_2[7]

			if not var_91_0 or var_91_0 == "n/a" or var_91_0 ~= "RANGED" then
				return
			end

			if var_91_1 ~= "instant_projectile" and var_91_1 ~= "projectile" and var_91_1 ~= "heavy_instant_projectile" or not var_91_2 then
				return
			end

			if arg_91_2[3] ~= "head" then
				return
			end

			if arg_91_2[4] < 2 then
				arg_91_1.marked_for_add = true
			end
		end
	end,
	add_delayed_buff_on_ranged_hit = function(arg_92_0, arg_92_1, arg_92_2)
		if ALIVE[arg_92_0] then
			local var_92_0 = arg_92_2[5]
			local var_92_1 = arg_92_2[2]
			local var_92_2 = arg_92_2[7]

			if not var_92_0 or var_92_0 == "n/a" or var_92_0 ~= "RANGED" then
				return
			end

			if var_92_1 ~= "instant_projectile" and var_92_1 ~= "projectile" and var_92_1 ~= "heavy_instant_projectile" or not var_92_2 then
				return
			end

			if arg_92_2[4] < 2 then
				arg_92_1.marked_for_add = true
			end
		end
	end,
	add_buff_local = function(arg_93_0, arg_93_1, arg_93_2)
		BuffFunctionTemplates.functions.add_buff_local(arg_93_0, arg_93_1, arg_93_2)
	end,
	add_buff_on_first_target_hit_range = function(arg_94_0, arg_94_1, arg_94_2)
		if ALIVE[arg_94_0] then
			local var_94_0 = arg_94_2[5]
			local var_94_1 = arg_94_2[2]

			if not var_94_0 or var_94_0 == "n/a" or var_94_0 ~= "RANGED" then
				return
			end

			if var_94_1 ~= "instant_projectile" and var_94_1 ~= "projectile" and var_94_1 ~= "heavy_instant_projectile" then
				return
			end

			if arg_94_2[4] < 2 then
				local var_94_2 = arg_94_1.template.buff_to_add
				local var_94_3 = ScriptUnit.extension(arg_94_0, "buff_system")
				local var_94_4 = Managers.state.network
				local var_94_5 = var_94_4.network_transmit
				local var_94_6 = var_94_4:unit_game_object_id(arg_94_0)
				local var_94_7 = NetworkLookup.buff_templates[var_94_2]

				if var_0_7() then
					var_94_3:add_buff(var_94_2, {
						attacker_unit = arg_94_0
					})
					var_94_5:send_rpc_clients("rpc_add_buff", var_94_6, var_94_7, var_94_6, 0, false)
				else
					var_94_5:send_rpc_server("rpc_add_buff", var_94_6, var_94_7, var_94_6, 0, true)
				end
			end
		end
	end,
	add_buff_stack_on_melee_critical_hit = function(arg_95_0, arg_95_1, arg_95_2)
		if ALIVE[arg_95_0] then
			local var_95_0 = arg_95_2[4]
			local var_95_1 = arg_95_2[5]
			local var_95_2 = arg_95_2[6]

			if var_95_0 < 2 and var_95_2 and (var_95_1 == "MELEE_1H" or var_95_1 == "MELEE_2H") then
				local var_95_3 = arg_95_1.template
				local var_95_4 = var_95_3.buff_to_add
				local var_95_5 = ScriptUnit.extension(arg_95_0, "buff_system")
				local var_95_6 = var_95_3.max_sub_buff_stacks

				if var_95_3.reference_buff then
					local var_95_7 = var_95_3.reference_buff
					local var_95_8 = var_95_5:get_non_stacking_buff(var_95_7)

					var_95_6 = var_95_8.template.max_sub_buff_stacks

					if not var_95_8.buff_list then
						var_95_8.buff_list = {}
					end

					if var_95_6 > #var_95_8.buff_list then
						table.insert(var_95_8.buff_list, var_95_5:add_buff(var_95_4))
					end
				else
					if not arg_95_1.buff_list then
						arg_95_1.buff_list = {}
					end

					if var_95_6 > #arg_95_1.buff_list then
						table.insert(arg_95_1.buff_list, var_95_5:add_buff(var_95_4))
					end
				end
			end
		end
	end,
	set_noclip = function(arg_96_0, arg_96_1, arg_96_2)
		if ALIVE[arg_96_0] then
			local var_96_0 = ScriptUnit.extension(arg_96_0, "status_system")
			local var_96_1 = arg_96_1.template
			local var_96_2 = var_96_1.set_status
			local var_96_3 = var_96_1.status_identifier

			var_96_0:set_noclip(var_96_2, var_96_3)
		end
	end,
	add_buff_on_elite_or_special_kill = function(arg_97_0, arg_97_1, arg_97_2)
		if Unit.alive(arg_97_0) then
			local var_97_0 = arg_97_2[2]

			if var_97_0.special or var_97_0.elite then
				local var_97_1 = arg_97_1.template.buff_to_add
				local var_97_2 = ScriptUnit.extension(arg_97_0, "buff_system")
				local var_97_3 = Managers.state.network
				local var_97_4 = var_97_3.network_transmit
				local var_97_5 = var_97_3:unit_game_object_id(arg_97_0)
				local var_97_6 = NetworkLookup.buff_templates[var_97_1]

				if var_0_7() then
					var_97_2:add_buff(var_97_1, {
						attacker_unit = arg_97_0
					})
					var_97_4:send_rpc_clients("rpc_add_buff", var_97_5, var_97_6, var_97_5, 0, false)
				else
					var_97_4:send_rpc_server("rpc_add_buff", var_97_5, var_97_6, var_97_5, 0, true)
				end
			end
		end
	end,
	add_buff_on_special_kill = function(arg_98_0, arg_98_1, arg_98_2)
		if Unit.alive(arg_98_0) and arg_98_2[2].special then
			local var_98_0 = arg_98_1.template.buff_to_add
			local var_98_1 = ScriptUnit.extension(arg_98_0, "buff_system")
			local var_98_2 = Managers.state.network
			local var_98_3 = var_98_2.network_transmit
			local var_98_4 = var_98_2:unit_game_object_id(arg_98_0)
			local var_98_5 = NetworkLookup.buff_templates[var_98_0]

			if var_0_7() then
				var_98_1:add_buff(var_98_0, {
					attacker_unit = arg_98_0
				})
				var_98_3:send_rpc_clients("rpc_add_buff", var_98_4, var_98_5, var_98_4, 0, false)
			else
				var_98_3:send_rpc_server("rpc_add_buff", var_98_4, var_98_5, var_98_4, 0, true)
			end
		end
	end,
	add_buff_stack_on_special_kill = function(arg_99_0, arg_99_1, arg_99_2)
		if ALIVE[arg_99_0] then
			local var_99_0 = arg_99_2[2]

			if var_99_0.special or var_99_0.elite then
				local var_99_1 = arg_99_1.template
				local var_99_2 = var_99_1.buff_to_add
				local var_99_3 = ScriptUnit.extension(arg_99_0, "buff_system")
				local var_99_4 = var_99_1.max_sub_buff_stacks

				if not arg_99_1.buff_list then
					arg_99_1.buff_list = {}
				end

				if var_99_4 > #arg_99_1.buff_list then
					arg_99_1.buff_list[#arg_99_1.buff_list + 1] = var_99_3:add_buff(var_99_2, {
						attacker_unit = arg_99_0
					})
				end
			end
		end
	end,
	remove_ref_buff_stack = function(arg_100_0, arg_100_1, arg_100_2)
		local var_100_0 = arg_100_2[1]
		local var_100_1 = arg_100_2[3]
		local var_100_2 = Managers.state.side.side_by_unit[arg_100_0]
		local var_100_3 = Managers.state.side.side_by_unit[var_100_0]

		if var_100_3 and var_100_2 and var_100_2 == var_100_3 then
			return
		elseif ALIVE[arg_100_0] and var_100_1 ~= "temporary_health_degen" then
			local var_100_4 = arg_100_1.template
			local var_100_5 = ScriptUnit.extension(arg_100_0, "buff_system")
			local var_100_6 = var_100_4.reference_buff
			local var_100_7 = var_100_5:get_non_stacking_buff(var_100_6)

			if var_100_7.buff_list then
				local var_100_8 = table.remove(var_100_7.buff_list)

				var_100_5:remove_buff(var_100_8)
			end
		end
	end,
	add_buff_on_headshot = function(arg_101_0, arg_101_1, arg_101_2)
		if Unit.alive(arg_101_0) then
			local var_101_0 = arg_101_2[3]

			if var_101_0 and (var_101_0 == "head" or var_101_0 == "neck") then
				local var_101_1 = arg_101_1.template
				local var_101_2 = arg_101_2[2]
				local var_101_3 = var_101_1.allowed_attacks

				if var_101_3 and not var_101_3[var_101_2] then
					return
				end

				local var_101_4 = var_101_1.buff_to_add
				local var_101_5 = ScriptUnit.extension(arg_101_0, "buff_system")
				local var_101_6 = Managers.state.network
				local var_101_7 = var_101_6.network_transmit
				local var_101_8 = var_101_6:unit_game_object_id(arg_101_0)
				local var_101_9 = NetworkLookup.buff_templates[var_101_4]

				if var_0_7() then
					var_101_5:add_buff(var_101_4, {
						attacker_unit = arg_101_0
					})
					var_101_7:send_rpc_clients("rpc_add_buff", var_101_8, var_101_9, var_101_8, 0, false)
				else
					var_101_7:send_rpc_server("rpc_add_buff", var_101_8, var_101_9, var_101_8, 0, true)
				end
			end
		end
	end,
	sienna_unchained_add_buff_on_vent_damage = function(arg_102_0, arg_102_1, arg_102_2)
		if ALIVE[arg_102_0] then
			local var_102_0 = arg_102_2[3]

			if var_102_0 and var_102_0 == "overcharge" then
				local var_102_1 = arg_102_1.template.buffs_to_add

				for iter_102_0 = 1, #var_102_1 do
					local var_102_2 = var_102_1[iter_102_0]
					local var_102_3 = ScriptUnit.extension(arg_102_0, "buff_system")
					local var_102_4 = Managers.state.network
					local var_102_5 = var_102_4.network_transmit
					local var_102_6 = var_102_4:unit_game_object_id(arg_102_0)
					local var_102_7 = NetworkLookup.buff_templates[var_102_2]

					if var_0_7() then
						var_102_3:add_buff(var_102_2, {
							attacker_unit = arg_102_0
						})
						var_102_5:send_rpc_clients("rpc_add_buff", var_102_6, var_102_7, var_102_6, 0, false)
					else
						var_102_5:send_rpc_server("rpc_add_buff", var_102_6, var_102_7, var_102_6, 0, true)
					end
				end
			end
		end
	end,
	sienna_on_kill_explosion = function(arg_103_0, arg_103_1, arg_103_2)
		if not Managers.state.network.is_server then
			return
		end

		local var_103_0 = arg_103_2[3]

		if ALIVE[arg_103_0] then
			local var_103_1 = ScriptUnit.has_extension(var_103_0, "buff_system")

			if arg_103_1.template.proc_chance >= math.random() and (var_103_1 and var_103_1:has_buff_perk(var_0_0.burning) or var_103_1:has_buff_perk(var_0_0.burning_balefire) or var_103_1:has_buff_perk(var_0_0.burning_elven_magic)) then
				local var_103_2 = ScriptUnit.has_extension(arg_103_0, "career_system")
				local var_103_3 = Managers.state.entity:system("area_damage_system")
				local var_103_4 = POSITION_LOOKUP[var_103_0]
				local var_103_5 = "buff"
				local var_103_6 = "sienna_unchained_burning_enemies_explosion"
				local var_103_7 = Quaternion.identity()
				local var_103_8 = var_103_2:get_career_power_level()
				local var_103_9 = 1
				local var_103_10 = false

				var_103_3:create_explosion(arg_103_0, var_103_4, var_103_7, var_103_6, var_103_9, var_103_5, var_103_8, var_103_10)
			end
		end
	end,
	sienna_burn_push_on_charged_attacks = function(arg_104_0, arg_104_1, arg_104_2)
		if arg_104_2[2] ~= "heavy_attack" then
			return
		end

		if ALIVE[arg_104_0] then
			local var_104_0 = ScriptUnit.extension(arg_104_0, "buff_system")
			local var_104_1 = arg_104_1.template.buff_to_add

			var_104_0:add_buff(var_104_1)
		end
	end,
	sienna_burn_push_on_charged_attacks_remove = function(arg_105_0, arg_105_1, arg_105_2)
		if not var_0_6(arg_105_0) then
			return
		end

		if ALIVE[arg_105_0] then
			ScriptUnit.extension(arg_105_0, "buff_system"):remove_buff(arg_105_1.id)
		end
	end,
	add_buff_on_ranged_headshot = function(arg_106_0, arg_106_1, arg_106_2)
		if ALIVE[arg_106_0] then
			local var_106_0 = arg_106_2[3]
			local var_106_1 = arg_106_2[2] == "light_attack" or arg_106_2[2] == "heavy_attack"

			if var_106_0 and (var_106_0 == "head" or var_106_0 == "neck") and not var_106_1 then
				local var_106_2 = arg_106_1.template.buff_to_add
				local var_106_3 = ScriptUnit.extension(arg_106_0, "buff_system")
				local var_106_4 = Managers.state.network
				local var_106_5 = var_106_4.network_transmit
				local var_106_6 = var_106_4:unit_game_object_id(arg_106_0)
				local var_106_7 = NetworkLookup.buff_templates[var_106_2]

				if var_0_7() then
					var_106_3:add_buff(var_106_2, {
						attacker_unit = arg_106_0
					})
					var_106_5:send_rpc_clients("rpc_add_buff", var_106_6, var_106_7, var_106_6, 0, false)
				else
					var_106_5:send_rpc_server("rpc_add_buff", var_106_6, var_106_7, var_106_6, 0, true)
				end
			end
		end
	end,
	bardin_ranger_add_reload_speed_buff = function(arg_107_0, arg_107_1, arg_107_2)
		if Unit.alive(arg_107_0) then
			local var_107_0 = ScriptUnit.has_extension(arg_107_0, "buff_system")
			local var_107_1 = arg_107_1.template
			local var_107_2 = var_107_1.buff_to_add
			local var_107_3 = arg_107_2[5]

			if var_107_3 ~= "MELEE_1H" and var_107_3 ~= "MELEE_2H" and arg_107_2[4] >= var_107_1.target_number then
				var_107_0:add_buff(var_107_2)
			end
		end
	end,
	remove_non_stacking_buff = function(arg_108_0, arg_108_1, arg_108_2)
		if ALIVE[arg_108_0] then
			local var_108_0 = ScriptUnit.extension(arg_108_0, "buff_system")
			local var_108_1 = arg_108_1.template.buff_to_remove
			local var_108_2 = var_108_0:get_non_stacking_buff(var_108_1)

			if var_108_2 then
				var_108_0:remove_buff(var_108_2.id)
			end
		end
	end,
	add_bardin_slayer_passive_buff = function(arg_109_0, arg_109_1, arg_109_2)
		if not Managers.state.network.is_server then
			return
		end

		local var_109_0 = Managers.state.entity:system("buff_system")

		if Unit.alive(arg_109_0) then
			local var_109_1 = "bardin_slayer_passive_stacking_damage_buff"
			local var_109_2 = ScriptUnit.extension(arg_109_0, "talent_system")
			local var_109_3 = ScriptUnit.extension(arg_109_0, "buff_system")

			if var_109_2:has_talent("bardin_slayer_passive_increased_max_stacks", "dwarf_ranger", true) then
				var_109_1 = "bardin_slayer_passive_increased_max_stacks"
			end

			var_109_0:add_buff(arg_109_0, var_109_1, arg_109_0, false)

			if var_109_2:has_talent("bardin_slayer_passive_movement_speed", "dwarf_ranger", true) then
				var_109_0:add_buff(arg_109_0, "bardin_slayer_passive_movement_speed", arg_109_0, false)
			end

			if var_109_2:has_talent("bardin_slayer_passive_cooldown_reduction_on_max_stacks", "dwarf_ranger", true) and var_109_3:num_buff_type(var_109_1) == arg_109_1.template.max_stacks then
				var_109_0:add_buff(arg_109_0, "bardin_slayer_passive_cooldown_reduction_on_max_stacks", arg_109_0, false)
			end
		end
	end,
	bardin_slayer_self_revive_on_kill = function(arg_110_0, arg_110_1, arg_110_2)
		if ALIVE[arg_110_0] then
			local var_110_0 = arg_110_1.template

			if not var_110_0.kill_count then
				var_110_0.kill_count = 0
			end

			var_110_0.kill_count = var_110_0.kill_count + 1

			if var_110_0.kill_requirement <= var_110_0.kill_count then
				ScriptUnit.extension(arg_110_0, "buff_system"):remove_buff(arg_110_1.id)
			end
		end
	end,
	remove_fatigue = function(arg_111_0, arg_111_1, arg_111_2)
		if ALIVE[arg_111_0] then
			local var_111_0 = arg_111_1.bonus

			ScriptUnit.extension(arg_111_0, "status_system"):remove_fatigue_points(var_111_0)
		end
	end,
	increase_attack_speed = function(arg_112_0, arg_112_1, arg_112_2)
		if ALIVE[arg_112_0] then
			local var_112_0 = ScriptUnit.extension(arg_112_0, "buff_system")
			local var_112_1 = arg_112_1.template
			local var_112_2 = var_112_1.inherited_multiplier
			local var_112_3 = var_112_1.inherited_duration

			table.clear(var_0_5)

			var_0_5.external_optional_multiplier = var_112_2
			var_0_5.external_optional_duration = var_112_3

			var_112_0:add_buff("increased_attack_speed", var_0_5)
		end
	end,
	increase_critical_hit_chance = function(arg_113_0, arg_113_1, arg_113_2)
		if ALIVE[arg_113_0] then
			local var_113_0 = ScriptUnit.extension(arg_113_0, "buff_system")
			local var_113_1 = arg_113_1.template
			local var_113_2 = var_113_1.inherited_bonus
			local var_113_3 = var_113_1.inherited_duration

			table.clear(var_0_5)

			var_0_5.external_optional_bonus = var_113_2
			var_0_5.external_optional_duration = var_113_3

			var_113_0:add_buff("increased_critical_hit_chance", var_0_5)
		end
	end,
	remove_overcharge = function(arg_114_0, arg_114_1, arg_114_2)
		if not var_0_6(arg_114_0) then
			return
		end

		if Unit.alive(arg_114_0) then
			local var_114_0 = arg_114_1.bonus

			ScriptUnit.extension(arg_114_0, "overcharge_system"):remove_charge(var_114_0)
		end
	end,
	shade_activated_ability_on_hit = function(arg_115_0, arg_115_1, arg_115_2)
		if ALIVE[arg_115_0] then
			local var_115_0 = arg_115_2[1]

			if ActionUtils.is_backstab(arg_115_0, var_115_0) then
				local var_115_1 = ScriptUnit.has_extension(arg_115_0, "first_person_system")

				if var_115_1 then
					var_115_1:play_hud_sound_event("Play_career_ability_shade_backstab")
				end
			end

			local var_115_2 = ScriptUnit.extension(arg_115_0, "talent_system")

			if arg_115_1.template.can_restealth_on_remove and var_115_2:has_talent("kerillian_shade_activated_ability_restealth") then
				local var_115_3 = ScriptUnit.has_extension(arg_115_0, "first_person_system")

				if var_115_3 then
					var_115_3:play_hud_sound_event("Play_career_ability_kerillian_shade_enter")
					var_115_3:animation_event("shade_stealth_ability")
				end
			end

			if arg_115_1.triggering_action_start_t then
				local var_115_4 = ScriptUnit.extension(arg_115_0, "inventory_system"):get_weapon_unit()
				local var_115_5 = ScriptUnit.extension(var_115_4, "weapon_system")

				if var_115_5:has_current_action() and var_115_5:get_current_action().action_start_t == arg_115_1.triggering_action_start_t then
					return
				end
			end

			ScriptUnit.extension(arg_115_0, "buff_system"):remove_buff(arg_115_1.id)
		end
	end,
	kerillian_shade_cheat_death_damage_taken = function(arg_116_0, arg_116_1, arg_116_2)
		if not var_0_7() then
			return
		end

		if ALIVE[arg_116_0] then
			local var_116_0 = arg_116_1.template.buff_to_add
			local var_116_1 = Managers.state.entity:system("buff_system")

			var_116_1:add_buff(arg_116_0, "kerillian_shade_activated_ability_cheat_death_blocker", arg_116_0, false)
			var_116_1:add_buff(arg_116_0, var_116_0, arg_116_0, false)
			var_116_1:remove_buff_synced(arg_116_0, arg_116_1.id)
		end
	end,
	shade_combo_stealth_on_hit = function(arg_117_0, arg_117_1, arg_117_2)
		if ALIVE[arg_117_0] then
			local var_117_0 = ScriptUnit.extension(arg_117_0, "buff_system")

			if not var_117_0:has_buff_type("kerillian_shade_ult_invis_combo_blocker") then
				var_117_0:add_buff("kerillian_shade_ult_invis_combo_window")
			end
		end
	end,
	shade_combo_stealth_extend_on_kill = function(arg_118_0, arg_118_1, arg_118_2)
		if ALIVE[arg_118_0] then
			local var_118_0 = ScriptUnit.extension(arg_118_0, "buff_system"):get_buff_type("kerillian_shade_ult_invis")

			if var_118_0 then
				local var_118_1 = arg_118_1.template.extend_time
				local var_118_2 = Managers.time:time("game")

				var_118_0.duration, var_118_0.start_time = var_118_1 + var_118_0.start_time - var_118_2 + var_118_0.duration, var_118_2
				arg_118_1.killed_target = true
			end
		end
	end,
	shade_short_stealth_on_hit = function(arg_119_0, arg_119_1, arg_119_2)
		if ALIVE[arg_119_0] then
			ScriptUnit.extension(arg_119_0, "buff_system"):remove_buff(arg_119_1.id)
		end
	end,
	shade_backstab_ammo_gain = function(arg_120_0, arg_120_1, arg_120_2)
		local var_120_0 = ScriptUnit.has_extension(arg_120_0, "buff_system")

		if var_120_0 and not var_120_0:has_buff_type("kerillian_shade_backstabs_replenishes_ammunition_cooldown") then
			if ALIVE[arg_120_0] then
				local var_120_1 = "slot_ranged"
				local var_120_2 = arg_120_1.bonus
				local var_120_3 = ScriptUnit.extension(arg_120_0, "inventory_system"):get_slot_data(var_120_1)
				local var_120_4 = var_120_3.right_unit_1p
				local var_120_5 = var_120_3.left_unit_1p
				local var_120_6 = ScriptUnit.has_extension(var_120_4, "ammo_system")
				local var_120_7 = ScriptUnit.has_extension(var_120_5, "ammo_system")
				local var_120_8 = var_120_6 or var_120_7

				if var_120_8 then
					var_120_8:add_ammo_to_reserve(var_120_2)
				end
			end

			var_120_0:add_buff("kerillian_shade_backstabs_replenishes_ammunition_cooldown")
		end
	end,
	end_huntsman_stealth = function(arg_121_0, arg_121_1, arg_121_2)
		if ALIVE[arg_121_0] and var_0_6(arg_121_0) then
			ScriptUnit.extension(arg_121_0, "status_system"):set_invisible(false, nil, "huntsman_ability")

			local var_121_0 = ScriptUnit.extension(arg_121_0, "first_person_system")

			var_121_0:play_hud_sound_event("Play_career_ability_markus_huntsman_exit", nil, true)
			var_121_0:play_remote_hud_sound_event("Stop_career_ability_markus_huntsman_loop_husk")

			if not var_0_8(arg_121_0) then
				Managers.state.camera:set_mood("skill_huntsman_stealth", "skill_huntsman_stealth", false)
				Managers.state.camera:set_mood("skill_huntsman_surge", "skill_huntsman_surge", true)
				var_121_0:play_hud_sound_event("Stop_career_ability_markus_huntsman_loop")
			end
		end

		return true
	end,
	end_huntsman_activated_ability = function(arg_122_0, arg_122_1, arg_122_2)
		if ALIVE[arg_122_0] then
			local var_122_0 = ScriptUnit.extension(arg_122_0, "buff_system")
			local var_122_1 = var_122_0:get_non_stacking_buff("markus_huntsman_activated_ability")

			if var_122_1 then
				var_122_0:remove_buff(var_122_1.id)
			end
		end
	end,
	increased_movement_speed = function(arg_123_0, arg_123_1, arg_123_2)
		if ALIVE[arg_123_0] then
			local var_123_0 = ScriptUnit.extension(arg_123_0, "buff_system")
			local var_123_1 = arg_123_1.template
			local var_123_2 = var_123_1.inherited_multiplier
			local var_123_3 = var_123_1.inherited_duration

			table.clear(var_0_5)

			var_0_5.external_optional_multiplier = var_123_2
			var_0_5.external_optional_duration = var_123_3

			var_123_0:add_buff("increased_movement_speed_from_proc", var_0_5)
		end
	end,
	ammo_gain = function(arg_124_0, arg_124_1, arg_124_2)
		if ALIVE[arg_124_0] then
			local var_124_0 = "slot_ranged"
			local var_124_1 = arg_124_1.bonus
			local var_124_2 = ScriptUnit.extension(arg_124_0, "inventory_system"):get_slot_data(var_124_0)
			local var_124_3 = var_124_2.right_unit_1p
			local var_124_4 = var_124_2.left_unit_1p
			local var_124_5 = ScriptUnit.has_extension(var_124_3, "ammo_system")
			local var_124_6 = ScriptUnit.has_extension(var_124_4, "ammo_system")
			local var_124_7 = var_124_5 or var_124_6

			if var_124_7 then
				var_124_7:add_ammo_to_reserve(var_124_1)
			end
		end
	end,
	ammo_fraction_gain = function(arg_125_0, arg_125_1, arg_125_2)
		local var_125_0 = Managers.player:owner(arg_125_0)

		if var_125_0 and var_125_0.remote then
			return
		end

		if Unit.alive(arg_125_0) then
			local var_125_1 = arg_125_1.template
			local var_125_2 = "slot_ranged"
			local var_125_3 = ScriptUnit.extension(arg_125_0, "inventory_system"):get_slot_data(var_125_2)
			local var_125_4 = var_125_3.right_unit_1p
			local var_125_5 = var_125_3.left_unit_1p
			local var_125_6 = ScriptUnit.has_extension(var_125_4, "ammo_system")
			local var_125_7 = ScriptUnit.has_extension(var_125_5, "ammo_system")
			local var_125_8 = var_125_6 or var_125_7
			local var_125_9 = var_125_1.ammo_bonus_fraction
			local var_125_10 = math.max(math.round(var_125_8:max_ammo() * var_125_9), 1)

			if var_125_8 then
				var_125_8:add_ammo_to_reserve(var_125_10)
			end
		end
	end,
	add_buff_on_out_of_ammo = function(arg_126_0, arg_126_1, arg_126_2)
		if Unit.alive(arg_126_0) then
			local var_126_0 = ScriptUnit.extension(arg_126_0, "buff_system")
			local var_126_1 = arg_126_1.template.buffs_to_add

			for iter_126_0 = 1, #var_126_1 do
				local var_126_2 = var_126_1[iter_126_0]
				local var_126_3 = Managers.state.network
				local var_126_4 = var_126_3.network_transmit
				local var_126_5 = var_126_3:unit_game_object_id(arg_126_0)
				local var_126_6 = NetworkLookup.buff_templates[var_126_2]

				if var_0_7() then
					var_126_0:add_buff(var_126_2, {
						attacker_unit = arg_126_0
					})
					var_126_4:send_rpc_clients("rpc_add_buff", var_126_5, var_126_6, var_126_5, 0, false)
				else
					var_126_4:send_rpc_server("rpc_add_buff", var_126_5, var_126_6, var_126_5, 0, true)
				end
			end
		end
	end,
	victor_bounty_hunter_reload_on_kill = function(arg_127_0, arg_127_1, arg_127_2)
		if not var_0_6(arg_127_0) then
			return
		end

		if ALIVE[arg_127_0] then
			local var_127_0 = arg_127_2[1][DamageDataIndex.DAMAGE_SOURCE_NAME]
			local var_127_1 = "slot_melee"
			local var_127_2 = ScriptUnit.extension(arg_127_0, "inventory_system"):get_slot_data(var_127_1)

			if not var_127_2 then
				return
			end

			if var_127_0 ~= var_127_2.item_data.name then
				return
			end

			local var_127_3 = "slot_ranged"
			local var_127_4 = ScriptUnit.extension(arg_127_0, "inventory_system"):get_slot_data(var_127_3)
			local var_127_5 = var_127_4.right_unit_1p
			local var_127_6 = var_127_4.left_unit_1p
			local var_127_7 = ScriptUnit.has_extension(var_127_5, "ammo_system")
			local var_127_8 = ScriptUnit.has_extension(var_127_6, "ammo_system")
			local var_127_9 = var_127_7 or var_127_8

			if var_127_9:remaining_ammo() >= 1 and var_127_9 and not var_127_9:clip_full() then
				var_127_9._ammo_immediately_available = true

				var_127_9:add_ammo(1)

				var_127_9._ammo_immediately_available = false

				var_127_9:remove_ammo(1)
			end
		end
	end,
	victor_bounty_hunter_ammo_regen = function(arg_128_0, arg_128_1, arg_128_2)
		if not var_0_6(arg_128_0) then
			return
		end

		if ALIVE[arg_128_0] then
			local var_128_0 = "slot_ranged"
			local var_128_1 = ScriptUnit.extension(arg_128_0, "inventory_system"):get_slot_data(var_128_0)
			local var_128_2 = var_128_1.right_unit_1p
			local var_128_3 = var_128_1.left_unit_1p
			local var_128_4 = ScriptUnit.has_extension(var_128_2, "ammo_system")
			local var_128_5 = ScriptUnit.has_extension(var_128_3, "ammo_system")
			local var_128_6 = var_128_4 or var_128_5

			if var_128_6 and not var_128_6:clip_full() then
				var_128_6._ammo_immediately_available = true

				var_128_6:add_ammo(1)

				var_128_6._ammo_immediately_available = false
			else
				var_128_6:add_ammo(1)
			end
		end
	end,
	victor_bounty_blast_streak_activation = function(arg_129_0, arg_129_1, arg_129_2)
		if not var_0_6(arg_129_0) then
			return
		end

		if ALIVE[arg_129_0] then
			if arg_129_2[1][DamageDataIndex.DAMAGE_SOURCE_NAME] ~= "victor_bountyhunter_career_skill_weapon" then
				return
			end

			local var_129_0 = arg_129_1.template.buff_to_add
			local var_129_1 = ScriptUnit.extension(arg_129_0, "buff_system")
			local var_129_2 = Managers.state.network
			local var_129_3 = var_129_2.network_transmit
			local var_129_4 = NetworkLookup.buff_templates[var_129_0]
			local var_129_5 = var_129_2:unit_game_object_id(arg_129_0)

			if var_0_7() then
				var_129_1:add_buff(var_129_0, {
					attacker_unit = arg_129_0
				})
				var_129_3:send_rpc_clients("rpc_add_buff", var_129_5, var_129_4, var_129_5, 0, false)
			else
				var_129_3:send_rpc_server("rpc_add_buff", var_129_5, var_129_4, var_129_5, 0, true)
			end
		end
	end,
	victor_bounty_blast_streak_buff = function(arg_130_0, arg_130_1, arg_130_2)
		if not var_0_6(arg_130_0) then
			return
		end

		if ALIVE[arg_130_0] then
			if arg_130_2[5] ~= "RANGED_ABILITY" then
				return
			end

			ScriptUnit.extension(arg_130_0, "buff_system"):remove_buff(arg_130_1.id)
		end
	end,
	victor_bountyhunter_blessed_combat = function(arg_131_0, arg_131_1, arg_131_2)
		if not var_0_7() then
			return
		end

		if not ALIVE[arg_131_0] then
			return
		end

		local var_131_0 = arg_131_2[2]

		if not var_131_0 then
			return
		end

		local var_131_1 = arg_131_1.template
		local var_131_2 = ""
		local var_131_3 = false
		local var_131_4 = false

		if var_131_0 == "projectile" or var_131_0 == "instant_projectile" or var_131_0 == "heavy_instant_projectile" then
			local var_131_5 = Managers.time:time("game")

			if not arg_131_1.t then
				arg_131_1.t = 0
			end

			if arg_131_1.t == var_131_5 then
				return false
			end

			arg_131_1.t = var_131_5
			var_131_4 = true
			var_131_2 = var_131_1.melee_buff
		elseif var_131_0 == "light_attack" or var_131_0 == "heavy_attack" then
			if arg_131_2[4] > 1 then
				return false
			end

			var_131_3 = true
			var_131_2 = var_131_1.ranged_buff
		end

		local var_131_6 = ScriptUnit.extension(arg_131_0, "buff_system")
		local var_131_7 = Managers.state.entity:system("buff_system")

		if var_131_4 then
			if #var_131_1.melee_buff_ids < 6 then
				table.insert(var_131_1.melee_buff_ids, var_131_7:add_buff(arg_131_0, var_131_2, arg_131_0, true))
			end

			if var_131_6:has_buff_type(var_131_1.ranged_buff) then
				var_131_7:remove_server_controlled_buff(arg_131_0, var_131_1.ranged_buff_ids[#var_131_1.ranged_buff_ids])
				table.remove(var_131_1.ranged_buff_ids, #var_131_1.ranged_buff_ids)
			else
				table.clear(var_131_1.ranged_buff_ids)
			end
		end

		if var_131_3 then
			if #var_131_1.ranged_buff_ids < 6 then
				table.insert(var_131_1.ranged_buff_ids, var_131_7:add_buff(arg_131_0, var_131_2, arg_131_0, true))
			end

			if var_131_6:has_buff_type(var_131_1.melee_buff) then
				var_131_7:remove_server_controlled_buff(arg_131_0, var_131_1.melee_buff_ids[#var_131_1.melee_buff_ids])
				table.remove(var_131_1.melee_buff_ids, #var_131_1.melee_buff_ids)
			else
				table.clear(var_131_1.melee_buff_ids)
			end
		end
	end,
	add_team_buff_on_ranged_critical_hit = function(arg_132_0, arg_132_1, arg_132_2)
		if Unit.alive(arg_132_0) then
			local var_132_0 = arg_132_2[5]

			if arg_132_2[6] and not MeleeBuffTypes[var_132_0] then
				local var_132_1 = Managers.state.side.side_by_unit[arg_132_0].PLAYER_AND_BOT_UNITS
				local var_132_2 = #var_132_1
				local var_132_3 = 40
				local var_132_4 = arg_132_1.template
				local var_132_5 = Managers.state.network
				local var_132_6 = var_132_5.network_transmit
				local var_132_7 = var_132_5:unit_game_object_id(arg_132_0)
				local var_132_8 = POSITION_LOOKUP[arg_132_0]
				local var_132_9 = var_132_3 * var_132_3

				for iter_132_0 = 1, var_132_2 do
					local var_132_10 = var_132_1[iter_132_0]
					local var_132_11 = POSITION_LOOKUP[var_132_10]

					if var_132_9 > Vector3.distance_squared(var_132_8, var_132_11) then
						local var_132_12 = var_132_4.buff_to_add
						local var_132_13 = var_132_5:unit_game_object_id(var_132_10)
						local var_132_14 = ScriptUnit.extension(var_132_10, "buff_system")
						local var_132_15 = NetworkLookup.buff_templates[var_132_12]

						if var_0_7() then
							var_132_14:add_buff(var_132_12)
							var_132_6:send_rpc_clients("rpc_add_buff", var_132_13, var_132_15, var_132_7, 0, false)
						else
							var_132_6:send_rpc_server("rpc_add_buff", var_132_13, var_132_15, var_132_7, 0, true)
						end
					end
				end
			end
		end
	end,
	victor_bounty_hunter_ammo_fraction_gain_out_of_ammo = function(arg_133_0, arg_133_1, arg_133_2)
		if not var_0_6(arg_133_0) then
			return
		end

		if ALIVE[arg_133_0] and arg_133_2[2].elite then
			local var_133_0 = arg_133_1.template
			local var_133_1 = "slot_ranged"
			local var_133_2 = ScriptUnit.extension(arg_133_0, "inventory_system"):get_slot_data(var_133_1)
			local var_133_3 = var_133_2.right_unit_1p
			local var_133_4 = var_133_2.left_unit_1p
			local var_133_5 = ScriptUnit.has_extension(var_133_3, "ammo_system")
			local var_133_6 = ScriptUnit.has_extension(var_133_4, "ammo_system")
			local var_133_7 = var_133_5 or var_133_6
			local var_133_8 = var_133_7:remaining_ammo()
			local var_133_9 = var_133_7:ammo_count()

			if var_133_8 < 1 and var_133_9 < 1 then
				local var_133_10 = var_133_0.ammo_bonus_fraction
				local var_133_11 = math.max(math.round(var_133_7:max_ammo() * var_133_10), 1)

				if var_133_7 then
					var_133_7:add_ammo_to_reserve(var_133_11)
				end
			end
		end
	end,
	ammo_fraction_gain_on_crit_trait = function(arg_134_0, arg_134_1, arg_134_2)
		local var_134_0 = Managers.player:owner(arg_134_0)

		if var_134_0 and var_134_0.remote then
			return
		end

		if Unit.alive(arg_134_0) then
			local var_134_1 = arg_134_1.template
			local var_134_2 = "slot_ranged"
			local var_134_3 = ScriptUnit.extension(arg_134_0, "inventory_system"):get_slot_data(var_134_2)
			local var_134_4 = arg_134_2[4]
			local var_134_5 = arg_134_2[2]
			local var_134_6 = var_134_3.right_unit_1p
			local var_134_7 = var_134_3.left_unit_1p
			local var_134_8 = GearUtils.get_ammo_extension(var_134_6, var_134_7)
			local var_134_9 = var_134_1.ammo_bonus_fraction

			if var_134_8 and (var_134_5 == "instant_projectile" or var_134_5 == "projectile" or var_134_5 == "heavy_instant_projectile") then
				local var_134_10 = math.max(math.round(var_134_8:max_ammo() * var_134_9), 1)

				if var_134_4 == 1 then
					arg_134_1.has_procced = false
				end

				if not arg_134_1.has_procced then
					var_134_8:add_ammo_to_reserve(var_134_10)

					arg_134_1.has_procced = true
				end
			end
		end
	end,
	ammo_gain_when_low = function(arg_135_0, arg_135_1, arg_135_2)
		local var_135_0 = Managers.player:owner(arg_135_0)

		if var_135_0 and var_135_0.remote then
			return
		end

		if Unit.alive(arg_135_0) then
			local var_135_1 = arg_135_1.template
			local var_135_2 = "slot_ranged"
			local var_135_3 = ScriptUnit.extension(arg_135_0, "inventory_system"):get_slot_data(var_135_2)
			local var_135_4 = var_135_3.right_unit_1p
			local var_135_5 = var_135_3.left_unit_1p
			local var_135_6 = ScriptUnit.has_extension(var_135_4, "ammo_system")
			local var_135_7 = ScriptUnit.has_extension(var_135_5, "ammo_system")
			local var_135_8 = var_135_6 or var_135_7
			local var_135_9 = var_135_8:total_ammo_fraction() < var_135_1.activation_ammo
			local var_135_10 = var_135_1.ammo_bonus_fraction
			local var_135_11 = math.max(math.round(var_135_8:max_ammo() * var_135_10), 1)

			if var_135_8 and var_135_9 then
				var_135_8:add_ammo_to_reserve(var_135_11)
			end
		end
	end,
	markus_huntsman_passive_proc = function(arg_136_0, arg_136_1, arg_136_2)
		local var_136_0 = arg_136_2[2]
		local var_136_1 = arg_136_2[3]

		if ALIVE[arg_136_0] and var_136_1 == "head" and (var_136_0 == "instant_projectile" or var_136_0 == "projectile" or var_136_0 == "heavy_instant_projectile") then
			local var_136_2 = "slot_ranged"
			local var_136_3 = arg_136_1.bonus
			local var_136_4 = ScriptUnit.extension(arg_136_0, "buff_system")

			if ScriptUnit.extension(arg_136_0, "talent_system"):has_talent("markus_huntsman_passive_crit_buff_on_headshot", "empire_soldier", true) then
				var_136_4:add_buff("markus_huntsman_passive_crit_buff")
				var_136_4:add_buff("markus_huntsman_passive_crit_buff_removal")
			end

			local var_136_5 = ScriptUnit.extension(arg_136_0, "inventory_system"):get_slot_data(var_136_2)
			local var_136_6 = var_136_5.right_unit_1p
			local var_136_7 = var_136_5.left_unit_1p
			local var_136_8 = GearUtils.get_ammo_extension(var_136_6, var_136_7)

			if var_136_8 then
				var_136_8:add_ammo_to_reserve(var_136_3)
			end
		end
	end,
	markus_huntsman_free_shot = function(arg_137_0, arg_137_1, arg_137_2)
		if not var_0_6(arg_137_0) then
			return
		end

		if ALIVE[arg_137_0] then
			local var_137_0 = "slot_ranged"
			local var_137_1 = ScriptUnit.extension(arg_137_0, "inventory_system"):get_slot_data(var_137_0)
			local var_137_2 = var_137_1.right_unit_1p
			local var_137_3 = var_137_1.left_unit_1p
			local var_137_4 = ScriptUnit.has_extension(var_137_2, "ammo_system")
			local var_137_5 = ScriptUnit.has_extension(var_137_3, "ammo_system")
			local var_137_6 = var_137_4 or var_137_5

			if var_137_6 and not var_137_6:clip_full() then
				var_137_6._ammo_immediately_available = true

				var_137_6:add_ammo(1)

				var_137_6._ammo_immediately_available = false
			end

			ScriptUnit.extension(arg_137_0, "buff_system"):remove_buff(arg_137_1.id)
		end
	end,
	markus_huntsman_ult_on_death = function(arg_138_0, arg_138_1, arg_138_2)
		if ALIVE[arg_138_0] then
			local var_138_0 = ScriptUnit.extension(arg_138_0, "health_system")
			local var_138_1 = arg_138_2[2]

			if var_138_0:current_health() - var_138_1 < 0 then
				if Managers.player.is_server then
					DamageUtils.heal_network(arg_138_0, arg_138_0, 30, "heal_from_proc")
					DamageUtils.add_damage_network(arg_138_0, arg_138_0, var_138_0:current_health() - 1, "torso", "buff", nil, Vector3(0, 0, 0), nil, nil, arg_138_0, nil, nil, nil, nil, nil, nil, nil, nil, 1)
				end

				local var_138_2 = ScriptUnit.has_extension(arg_138_0, "career_system")

				var_138_2:start_activated_ability_cooldown()
				var_138_2:set_activated_ability_cooldown_paused()
				var_138_2:force_trigger_active_ability()

				local var_138_3 = ScriptUnit.extension(arg_138_0, "buff_system")
				local var_138_4 = arg_138_1.template.buff_to_add
				local var_138_5 = Managers.state.network
				local var_138_6 = var_138_5.network_transmit
				local var_138_7 = NetworkLookup.buff_templates[var_138_4]
				local var_138_8 = var_138_5:unit_game_object_id(arg_138_0)

				if var_0_7() then
					var_138_3:add_buff(var_138_4, {
						attacker_unit = arg_138_0
					})
					var_138_6:send_rpc_clients("rpc_add_buff", var_138_8, var_138_7, var_138_8, 0, false)
				else
					var_138_6:send_rpc_server("rpc_add_buff", var_138_8, var_138_7, var_138_8, 0, true)
				end

				var_138_3:remove_buff(arg_138_1.id)
			end
		end
	end,
	markus_huntsman_debuff_defence = function(arg_139_0, arg_139_1, arg_139_2)
		local var_139_0 = arg_139_2[1]

		if ALIVE[arg_139_0] and ALIVE[var_139_0] then
			local var_139_1 = ScriptUnit.extension(var_139_0, "buff_system")
			local var_139_2 = arg_139_1.template.buff_to_add

			var_139_1:add_buff(var_139_2)
		end
	end,
	markus_huntsman_passive_on_melee_kills = function(arg_140_0, arg_140_1, arg_140_2)
		if not ALIVE[arg_140_0] then
			return
		end

		local var_140_0 = arg_140_2[1]

		if not var_140_0 then
			return
		end

		local var_140_1 = var_140_0[DamageDataIndex.ATTACK_TYPE]

		if not var_140_1 or var_140_1 ~= "light_attack" and var_140_1 ~= "heavy_attack" then
			return
		end

		local var_140_2 = ScriptUnit.extension(arg_140_0, "buff_system")
		local var_140_3 = arg_140_1.template
		local var_140_4 = var_140_3.counter_buff_to_add
		local var_140_5 = var_140_3.buff_to_add
		local var_140_6 = var_140_2:num_buff_type(var_140_4)
		local var_140_7 = var_140_3.max_sub_buff_stacks - 1

		if var_140_7 <= var_140_6 then
			if var_140_3.reference_buff then
				local var_140_8 = var_140_3.reference_buff
				local var_140_9 = var_140_2:get_non_stacking_buff(var_140_8)

				var_140_7 = var_140_9.template.max_sub_buff_stacks

				if not var_140_9.buff_list then
					var_140_9.buff_list = {}
				end

				if var_140_7 > #var_140_9.buff_list then
					table.insert(var_140_9.buff_list, var_140_2:add_buff(var_140_5))
				end
			else
				if not arg_140_1.buff_list then
					arg_140_1.buff_list = {}
				end

				if var_140_7 > #arg_140_1.buff_list then
					table.insert(arg_140_1.buff_list, var_140_2:add_buff(var_140_5))
				end
			end
		end

		var_140_2:add_buff(var_140_4)
	end,
	remove_buff_stack = function(arg_141_0, arg_141_1, arg_141_2)
		if Unit.alive(arg_141_0) then
			local var_141_0 = ScriptUnit.has_extension(arg_141_0, "buff_system")

			if var_141_0 then
				local var_141_1 = arg_141_1.template
				local var_141_2 = var_141_1.remove_buff_stack_data

				for iter_141_0 = 1, #var_141_2 do
					local var_141_3 = var_141_2[iter_141_0]
					local var_141_4 = var_141_3.buff_to_remove
					local var_141_5 = var_141_3.num_stacks or 1

					if var_141_3.server_controlled then
						fassert(var_141_4 == var_141_1.buff_to_add, "Trying to remove different type of server controlled buff, only same types are allowed right now.")

						local var_141_6 = Managers.state.entity:system("buff_system")
						local var_141_7 = arg_141_1.server_buff_ids

						var_141_5 = var_141_7 and math.min(#var_141_7, var_141_5) or 0

						for iter_141_1 = 1, var_141_5 do
							local var_141_8 = table.remove(var_141_7)

							var_141_6:remove_server_controlled_buff(arg_141_0, var_141_8)
						end
					else
						for iter_141_2 = 1, var_141_5 do
							local var_141_9 = var_141_0:get_buff_type(var_141_4)

							if not var_141_9 then
								break
							end

							var_141_0:remove_buff(var_141_9.id)
						end
					end

					if var_141_3.reset_update_timer then
						arg_141_1._next_update_t = Managers.time:time("game") + (var_141_1.update_frequency or 0)
					end
				end
			end
		end
	end,
	markus_huntsman_increase_reload_speed = function(arg_142_0, arg_142_1, arg_142_2)
		local var_142_0 = arg_142_2[2]
		local var_142_1 = arg_142_2[3]
		local var_142_2 = ScriptUnit.extension(arg_142_0, "buff_system")

		if ALIVE[arg_142_0] and var_142_1 == "head" and (var_142_0 == "instant_projectile" or var_142_0 == "projectile" or var_142_0 == "heavy_instant_projectile") then
			var_142_2:add_buff("markus_huntsman_headshots_increase_reload_speed_buff")
		end
	end,
	replenish_ammo_on_headshot_ranged = function(arg_143_0, arg_143_1, arg_143_2)
		local var_143_0 = arg_143_2[2]
		local var_143_1 = arg_143_2[3]

		if ALIVE[arg_143_0] and var_143_1 == "head" and (var_143_0 == "instant_projectile" or var_143_0 == "projectile" or var_143_0 == "heavy_instant_projectile") then
			local var_143_2 = arg_143_2[5]

			if var_143_2 and var_143_2 == "RANGED_ABILITY" then
				return
			end

			local var_143_3 = "slot_ranged"
			local var_143_4 = arg_143_1.bonus
			local var_143_5 = ScriptUnit.extension(arg_143_0, "inventory_system"):get_slot_data(var_143_3)
			local var_143_6 = var_143_5.right_unit_1p
			local var_143_7 = var_143_5.left_unit_1p
			local var_143_8 = GearUtils.get_ammo_extension(var_143_6, var_143_7)

			if var_143_8 then
				var_143_8:add_ammo_to_reserve(var_143_4)
			end
		end
	end,
	reset_tranquility = function(arg_144_0, arg_144_1, arg_144_2)
		local var_144_0 = arg_144_2[1]
		local var_144_1 = arg_144_2[2]
		local var_144_2 = true

		if var_144_1 and var_144_1 == 0 then
			var_144_2 = false
		end

		if ALIVE[arg_144_0] and var_144_0 ~= arg_144_0 and var_144_2 then
			local var_144_3 = ScriptUnit.extension(arg_144_0, "buff_system")
			local var_144_4 = var_144_3:get_non_stacking_buff("tranquility")

			if var_144_4 then
				var_144_3:remove_buff(var_144_4.id)
			end

			local var_144_5 = "sienna_adept_passive"
			local var_144_6 = ScriptUnit.has_extension(arg_144_0, "talent_system")

			if var_144_6 and var_144_6:has_talent("sienna_adept_passive_cooldown") then
				var_144_5 = "sienna_adept_passive_cooldown"
			end

			var_144_3:add_buff(var_144_5)
		end
	end,
	maidenguard_remove_on_block_speed_buff = function(arg_145_0, arg_145_1, arg_145_2, arg_145_3, arg_145_4)
		if ALIVE[arg_145_0] then
			local var_145_0 = arg_145_2[arg_145_4.target_number]
			local var_145_1 = arg_145_1.template
			local var_145_2 = ScriptUnit.extension(arg_145_0, "buff_system")
			local var_145_3 = Managers.state.entity:system("buff_system")
			local var_145_4 = var_145_1.reference_buffs

			for iter_145_0 = 1, #var_145_4 do
				local var_145_5 = var_145_2:get_non_stacking_buff(var_145_4[iter_145_0])

				if var_145_5 and var_145_5.buff_list and var_145_0 and var_145_0 == 1 then
					local var_145_6 = table.remove(var_145_5.buff_list, #var_145_5.buff_list)

					if var_145_6 then
						var_145_3:remove_buff_synced(arg_145_0, var_145_6)
					end
				end
			end
		end
	end,
	maidenguard_footwork_buff = function(arg_146_0, arg_146_1, arg_146_2)
		if ALIVE[arg_146_0] then
			local var_146_0 = ScriptUnit.has_extension(arg_146_0, "status_system")
			local var_146_1 = ScriptUnit.has_extension(arg_146_0, "buff_system")
			local var_146_2 = arg_146_1.template

			if var_146_0.blocking then
				local var_146_3 = var_146_2.dodge_buffs_to_add

				for iter_146_0 = 1, #var_146_3 do
					local var_146_4 = var_146_3[iter_146_0]

					var_146_1:add_buff(var_146_4)
				end
			else
				local var_146_5 = var_146_2.attack_buff_to_add
				local var_146_6 = Managers.state.network
				local var_146_7 = var_146_6.network_transmit
				local var_146_8 = var_146_6:unit_game_object_id(arg_146_0)
				local var_146_9 = NetworkLookup.buff_templates[var_146_5]

				if var_146_8 then
					if var_0_7() then
						var_146_1:add_buff(var_146_5, {
							attacker_unit = arg_146_0
						})
					else
						var_146_7:send_rpc_server("rpc_add_buff", var_146_8, var_146_9, var_146_8, 0, true)
					end
				end
			end
		end
	end,
	maidenguard_footwork_on_dodge_end = function(arg_147_0, arg_147_1, arg_147_2)
		if ALIVE[arg_147_0] then
			local var_147_0 = ScriptUnit.extension(arg_147_0, "buff_system")

			if arg_147_1 then
				var_147_0:remove_buff(arg_147_1.id)
			end
		end
	end,
	maidenguard_reset_unharmed_buff = function(arg_148_0, arg_148_1, arg_148_2)
		local var_148_0 = arg_148_2[1]
		local var_148_1 = arg_148_2[2]
		local var_148_2 = true

		if var_148_1 and var_148_1 == 0 then
			var_148_2 = false
		end

		if ALIVE[arg_148_0] and var_148_0 ~= arg_148_0 and var_148_2 then
			local var_148_3 = ScriptUnit.has_extension(arg_148_0, "buff_system")
			local var_148_4 = "kerillian_maidenguard_power_level_on_unharmed_cooldown"
			local var_148_5 = Managers.state.network
			local var_148_6 = var_148_5.network_transmit
			local var_148_7 = var_148_5:unit_game_object_id(arg_148_0)
			local var_148_8 = NetworkLookup.buff_templates[var_148_4]

			if var_0_7() then
				var_148_3:add_buff(var_148_4, {
					attacker_unit = arg_148_0
				})
			else
				var_148_6:send_rpc_server("rpc_add_buff", var_148_7, var_148_8, var_148_7, 0, true)
			end

			return true
		end
	end,
	buff_on_stagger_enemy = function(arg_149_0, arg_149_1, arg_149_2)
		local var_149_0 = arg_149_1.template
		local var_149_1 = ScriptUnit.extension(arg_149_0, "buff_system")
		local var_149_2 = arg_149_2[1]
		local var_149_3 = Unit.get_data(var_149_2, "breed")
		local var_149_4 = var_149_0.buff_to_add
		local var_149_5 = var_149_0.enemy_type or nil
		local var_149_6 = false

		if var_149_3 and var_149_5 then
			for iter_149_0 = 1, #var_149_5 do
				if var_149_3[var_149_5[iter_149_0]] then
					var_149_6 = true
				end
			end
		elseif var_149_3 then
			var_149_6 = true
		end

		if var_149_6 then
			local var_149_7 = Managers.state.network
			local var_149_8 = var_149_7.network_transmit
			local var_149_9 = var_149_7:unit_game_object_id(arg_149_0)
			local var_149_10 = NetworkLookup.buff_templates[var_149_4]

			if var_0_7() then
				var_149_1:add_buff(var_149_4, {
					attacker_unit = arg_149_0
				})
				var_149_8:send_rpc_clients("rpc_add_buff", var_149_9, var_149_10, var_149_9, 0, false)
			else
				var_149_8:send_rpc_server("rpc_add_buff", var_149_9, var_149_10, var_149_9, 0, true)
			end
		end
	end,
	buff_on_blocked_attack = function(arg_150_0, arg_150_1, arg_150_2)
		local var_150_0 = arg_150_1.template
		local var_150_1 = ScriptUnit.extension(arg_150_0, "buff_system")
		local var_150_2 = var_150_0.buff_to_add

		var_150_1:add_buff(var_150_2)
	end,
	gain_markus_mercenary_passive_proc = function(arg_151_0, arg_151_1, arg_151_2)
		if not Managers.state.network.is_server then
			return
		end

		local var_151_0 = arg_151_1.template
		local var_151_1 = arg_151_2[4]
		local var_151_2 = arg_151_2[2]
		local var_151_3 = var_151_0.buff_to_add
		local var_151_4 = Managers.state.entity:system("buff_system")
		local var_151_5 = true

		if ALIVE[arg_151_0] and var_151_1 and var_151_1 >= var_151_0.targets and (var_151_2 == "light_attack" or var_151_2 == "heavy_attack") then
			local var_151_6 = ScriptUnit.extension(arg_151_0, "talent_system")

			if var_151_6:has_talent("markus_mercenary_passive_improved", "empire_soldier", true) then
				if var_151_1 >= 4 then
					var_151_4:add_buff(arg_151_0, "markus_mercenary_passive_improved", arg_151_0, false)
				else
					var_151_5 = false
				end
			elseif var_151_6:has_talent("markus_mercenary_passive_group_proc", "empire_soldier", true) then
				local var_151_7 = Managers.state.side.side_by_unit[arg_151_0].PLAYER_AND_BOT_UNITS
				local var_151_8 = #var_151_7

				for iter_151_0 = 1, var_151_8 do
					local var_151_9 = var_151_7[iter_151_0]

					if HEALTH_ALIVE[var_151_9] then
						var_151_4:add_buff(var_151_9, var_151_3, arg_151_0, false)
					end
				end
			elseif var_151_6:has_talent("markus_mercenary_passive_power_level_on_proc", "empire_soldier", true) then
				var_151_4:add_buff(arg_151_0, "markus_mercenary_passive_power_level", arg_151_0, false)
				var_151_4:add_buff(arg_151_0, var_151_3, arg_151_0, false)
			else
				var_151_4:add_buff(arg_151_0, var_151_3, arg_151_0, false)
			end

			if var_151_6:has_talent("markus_mercenary_passive_defence_on_proc", "empire_soldier", true) and var_151_5 then
				var_151_4:add_buff(arg_151_0, "markus_mercenary_passive_defence", arg_151_0, false)
			end
		end
	end,
	reduce_activated_ability_cooldown = function(arg_152_0, arg_152_1, arg_152_2)
		if ALIVE[arg_152_0] then
			local var_152_0 = arg_152_2[2]
			local var_152_1 = arg_152_2[4]
			local var_152_2 = ScriptUnit.extension(arg_152_0, "career_system")

			if not var_152_0 or var_152_0 == "heavy_attack" or var_152_0 == "light_attack" then
				var_152_2:reduce_activated_ability_cooldown(arg_152_1.bonus)
			elseif var_152_1 and var_152_1 == 1 then
				var_152_2:reduce_activated_ability_cooldown(arg_152_1.bonus)
			end
		end
	end,
	victor_bountyhunter_reduce_activated_ability_cooldown_ignore_paused_on_kill = function(arg_153_0, arg_153_1, arg_153_2)
		if ALIVE[arg_153_0] then
			local var_153_0 = arg_153_2[1][DamageDataIndex.DAMAGE_SOURCE_NAME]
			local var_153_1 = ScriptUnit.extension(arg_153_0, "career_system")

			if var_153_1 and var_153_0 ~= "victor_bountyhunter_career_skill_weapon" then
				local var_153_2 = true

				var_153_1:reduce_activated_ability_cooldown_percent(arg_153_1.multiplier, nil, var_153_2)
			end
		end
	end,
	victor_bountyhunter_reduce_activated_ability_cooldown_on_passive_crit = function(arg_154_0, arg_154_1, arg_154_2)
		if ALIVE[arg_154_0] then
			local var_154_0 = Managers.time:time("game")

			if not arg_154_1.cooldown or var_154_0 > arg_154_1.cooldown then
				local var_154_1 = arg_154_2[2]

				if var_154_1 ~= "light_attack" and var_154_1 ~= "heavy_attack" then
					local var_154_2 = ScriptUnit.extension(arg_154_0, "career_system")

					if var_154_2 then
						local var_154_3 = arg_154_1.template.cooldown

						var_154_2:reduce_activated_ability_cooldown_percent(arg_154_1.multiplier, nil)

						arg_154_1.cooldown = var_154_0 + var_154_3
					end
				end
			end
		end
	end,
	victor_bounty_hunter_reduce_activated_ability_cooldown_railgun = function(arg_155_0, arg_155_1, arg_155_2)
		if ALIVE[arg_155_0] then
			local var_155_0 = arg_155_2[3]
			local var_155_1 = arg_155_2[4]
			local var_155_2 = arg_155_2[5]

			if var_155_1 and var_155_1 <= 1 then
				arg_155_1.can_trigger = true
			end

			if arg_155_1.can_trigger and var_155_2 == "RANGED_ABILITY" and (var_155_0 == "head" or var_155_0 == "neck") then
				local var_155_3 = ScriptUnit.extension(arg_155_0, "buff_system")
				local var_155_4 = arg_155_1.template.buff_to_add

				var_155_3:add_buff(var_155_4)

				arg_155_1.can_trigger = false
			end
		end
	end,
	kerillian_waywatcher_reduce_activated_ability_cooldown = function(arg_156_0, arg_156_1, arg_156_2)
		if ALIVE[arg_156_0] then
			local var_156_0 = arg_156_2[3]
			local var_156_1 = arg_156_2[4]
			local var_156_2 = arg_156_2[5]

			if var_156_1 and var_156_1 <= 1 then
				arg_156_1.can_trigger = true
			end

			if arg_156_1.can_trigger and var_156_2 == "RANGED_ABILITY" and (var_156_0 == "head" or var_156_0 == "neck") then
				ScriptUnit.extension(arg_156_0, "career_system"):reduce_activated_ability_cooldown_percent(arg_156_1.multiplier)

				arg_156_1.can_trigger = false
			end
		end
	end,
	kerillian_waywatcher_add_extra_shot_buff_on_melee_kill = function(arg_157_0, arg_157_1, arg_157_2)
		if not ALIVE[arg_157_0] then
			return
		end

		local var_157_0 = arg_157_2[1]

		if not var_157_0 then
			return
		end

		local var_157_1 = var_157_0[DamageDataIndex.ATTACK_TYPE]

		if not var_157_1 or var_157_1 ~= "light_attack" and var_157_1 ~= "heavy_attack" then
			return
		end

		local var_157_2 = arg_157_1.template.buff_to_add

		ScriptUnit.extension(arg_157_0, "buff_system"):add_buff(var_157_2, {
			attacker_unit = arg_157_0
		})
	end,
	kerillian_waywatcher_consume_extra_shot_buff = function(arg_158_0, arg_158_1, arg_158_2, arg_158_3, arg_158_4)
		return true
	end,
	reduce_activated_ability_cooldown_boss_hit = function(arg_159_0, arg_159_1, arg_159_2)
		local var_159_0 = arg_159_2[1]
		local var_159_1 = arg_159_2[2]

		if ALIVE[arg_159_0] then
			local var_159_2 = Unit.get_data(var_159_0, "breed")

			if var_159_1 <= 1 then
				arg_159_1.can_trigger = true
			end

			if var_159_2 and var_159_2.boss and arg_159_1.can_trigger then
				ScriptUnit.extension(arg_159_0, "career_system"):reduce_activated_ability_cooldown(arg_159_1.bonus)

				arg_159_1.can_trigger = false
			end
		end
	end,
	reduce_activated_ability_cooldown_with_internal_cooldown_on_crit = function(arg_160_0, arg_160_1, arg_160_2)
		local var_160_0 = arg_160_2[2]
		local var_160_1 = arg_160_2[5]
		local var_160_2

		if RangedBuffTypes[var_160_1] then
			var_160_2 = var_160_0 == "projectile" or var_160_0 == "instant_projectile" or var_160_0 == "aoe" or var_160_0 == "heavy_instant_projectile"
		else
			var_160_2 = var_160_0 == "light_attack" or var_160_0 == "heavy_attack"
		end

		if var_160_2 and ALIVE[arg_160_0] then
			local var_160_3 = ScriptUnit.extension(arg_160_0, "buff_system")
			local var_160_4 = arg_160_1.template.buff_to_add

			if not var_160_3:has_buff_type(var_160_4) then
				local var_160_5 = ScriptUnit.extension(arg_160_0, "career_system")

				var_160_3:add_buff(var_160_4)
				var_160_5:reduce_activated_ability_cooldown_percent(arg_160_1.bonus)
			end
		end
	end,
	reduce_activated_ability_cooldown_on_damage_taken = function(arg_161_0, arg_161_1, arg_161_2)
		local var_161_0 = arg_161_2[1]
		local var_161_1 = arg_161_2[2]

		if ALIVE[arg_161_0] and var_161_0 ~= arg_161_0 then
			local var_161_2 = ScriptUnit.extension(arg_161_0, "career_system")
			local var_161_3 = arg_161_1.bonus * var_161_1

			var_161_2:reduce_activated_ability_cooldown(var_161_3)
		end
	end,
	sienna_adept_reduce_activated_ability_cooldown_on_burning_enemy_killed = function(arg_162_0, arg_162_1, arg_162_2)
		local var_162_0 = arg_162_2[3]

		if ALIVE[var_162_0] then
			local var_162_1 = ScriptUnit.has_extension(var_162_0, "buff_system")

			if var_162_1 and var_162_1:has_buff_perk(var_0_0.burning) or var_162_1:has_buff_perk(var_0_0.burning_balefire) or var_162_1:has_buff_perk(var_0_0.burning_elven_magic) then
				local var_162_2 = Managers.time:time("game")
				local var_162_3 = arg_162_1.cooldown_timer

				if not var_162_3 or var_162_3 <= var_162_2 then
					local var_162_4 = arg_162_1.template
					local var_162_5 = var_162_4.internal_cooldown
					local var_162_6 = var_162_4.cooldown_reduction

					ScriptUnit.extension(arg_162_0, "career_system"):reduce_activated_ability_cooldown_percent(var_162_6)

					arg_162_1.cooldown_timer = var_162_2 + var_162_5
				end
			end
		end
	end,
	remove_victor_bountyhunter_passive_crit_buff = function(arg_163_0, arg_163_1, arg_163_2)
		local var_163_0 = arg_163_2[1]
		local var_163_1 = var_163_0 == "sweep" or var_163_0 == "push_stagger" or var_163_0 == "shield_slam"

		if ALIVE[arg_163_0] then
			local var_163_2 = ScriptUnit.extension(arg_163_0, "buff_system")
			local var_163_3 = var_163_2:get_non_stacking_buff("victor_bountyhunter_passive_crit_buff")

			if var_163_3 and not var_163_1 then
				var_163_2:remove_buff(var_163_3.id)

				if ScriptUnit.extension(arg_163_0, "talent_system"):has_talent("victor_bountyhunter_passive_reduced_cooldown", "witch_hunter", true) then
					var_163_2:add_buff("victor_bountyhunter_passive_reduced_cooldown")
				else
					var_163_2:add_buff("victor_bountyhunter_passive_crit_cooldown")
				end
			end
		end
	end,
	remove_markus_huntsman_passive_crit_buff = function(arg_164_0, arg_164_1, arg_164_2)
		if ALIVE[arg_164_0] then
			local var_164_0 = ScriptUnit.extension(arg_164_0, "buff_system")
			local var_164_1 = var_164_0:get_non_stacking_buff("markus_huntsman_passive_crit_buff")

			if var_164_1 then
				var_164_0:remove_buff(var_164_1.id)
			end
		end
	end,
	mark_for_delayed_deletion = function(arg_165_0, arg_165_1, arg_165_2)
		if ALIVE[arg_165_0] then
			arg_165_1.marked_for_deletion = true
		end
	end,
	gain_uninterruptible = function(arg_166_0, arg_166_1, arg_166_2)
		if ALIVE[arg_166_0] then
			ScriptUnit.extension(arg_166_0, "buff_system"):add_buff("uninterruptible")
		end
	end,
	gain_bardin_slayer_uninterruptible_on_block_broken_buff = function(arg_167_0, arg_167_1, arg_167_2)
		if ALIVE[arg_167_0] then
			ScriptUnit.extension(arg_167_0, "buff_system"):add_buff("bardin_slayer_uninterruptible_on_block_broken_buff")
		end
	end,
	bardin_slayer_add_buff_on_leap_start = function(arg_168_0, arg_168_1, arg_168_2)
		local var_168_0 = Managers.state.entity:system("buff_system")
		local var_168_1 = arg_168_1.template.buff_to_add

		if ALIVE[arg_168_0] and Managers.player.is_server then
			arg_168_1.server_buff_id = var_168_0:add_buff(arg_168_0, var_168_1, arg_168_0, true)
		end
	end,
	bardin_slayer_remove_buff_on_leap_finished = function(arg_169_0, arg_169_1, arg_169_2)
		local var_169_0 = Managers.state.entity:system("buff_system")
		local var_169_1 = ScriptUnit.has_extension(arg_169_0, "buff_system")
		local var_169_2 = arg_169_1.template.parent_buff

		if ALIVE[arg_169_0] and Managers.player.is_server then
			local var_169_3 = var_169_1:get_non_stacking_buff(var_169_2)

			if var_169_3 then
				local var_169_4 = var_169_3.server_buff_id

				if var_169_4 then
					var_169_0:remove_server_controlled_buff(arg_169_0, var_169_4)
				end
			end
		end
	end,
	gain_markus_knight_uninterruptible_on_block_broken_buff = function(arg_170_0, arg_170_1, arg_170_2)
		if ALIVE[arg_170_0] then
			ScriptUnit.extension(arg_170_0, "buff_system"):add_buff("markus_knight_uninterruptible_on_block_broken_buff")
		end
	end,
	markus_knight_guard_damage_taken = function(arg_171_0, arg_171_1, arg_171_2)
		if not Managers.state.network.is_server then
			return
		end

		if ALIVE[arg_171_0] then
			local var_171_0 = arg_171_2[2]

			if arg_171_2[3] == "temporary_health_degen" then
				return
			end

			local var_171_1 = arg_171_1.attacker_unit
			local var_171_2 = AiUtils.unit_breed(var_171_1)
			local var_171_3 = {
				hardest = "blocked_attack",
				normal = "blocked_attack",
				hard = "blocked_attack",
				harder = "blocked_attack",
				cataclysm = "blocked_attack",
				easy = "blocked_attack",
				versus_base = "blocked_attack",
				cataclysm_3 = "blocked_attack",
				cataclysm_2 = "blocked_attack"
			}

			if var_171_2 and var_171_2.name == "hero_es_knight" and not DamageUtils.check_block(arg_171_0, var_171_1, var_171_3, "front") then
				DamageUtils.add_damage_network(var_171_1, var_171_1, var_171_0, "full", "forced", nil, Vector3(1, 0, 0), "buff", nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, 1)
			end
		end
	end,
	markus_knight_reduce_cooldown_on_stagger = function(arg_172_0, arg_172_1, arg_172_2)
		local var_172_0 = arg_172_1.template
		local var_172_1 = arg_172_2[1]
		local var_172_2 = Unit.get_data(var_172_1, "breed")
		local var_172_3 = var_172_0.enemy_type or nil
		local var_172_4 = false

		if var_172_2 and var_172_3 then
			for iter_172_0 = 1, #var_172_3 do
				if var_172_2[var_172_3[iter_172_0]] then
					var_172_4 = true

					break
				end
			end
		elseif var_172_2 then
			var_172_4 = true
		end

		if var_172_4 then
			local var_172_5 = Managers.state.side.side_by_unit[arg_172_0].PLAYER_AND_BOT_UNITS
			local var_172_6 = #var_172_5
			local var_172_7 = 40
			local var_172_8 = Managers.state.network
			local var_172_9 = var_172_8.network_transmit
			local var_172_10 = var_172_8:unit_game_object_id(arg_172_0)
			local var_172_11 = POSITION_LOOKUP[arg_172_0]
			local var_172_12 = var_172_7 * var_172_7

			for iter_172_1 = 1, var_172_6 do
				local var_172_13 = var_172_5[iter_172_1]
				local var_172_14 = POSITION_LOOKUP[var_172_13]

				if var_172_12 > Vector3.distance_squared(var_172_11, var_172_14) then
					local var_172_15 = var_172_0.buff_to_add
					local var_172_16 = var_172_8:unit_game_object_id(var_172_13)
					local var_172_17 = ScriptUnit.extension(var_172_13, "buff_system")
					local var_172_18 = NetworkLookup.buff_templates[var_172_15]

					if var_0_7() then
						var_172_17:add_buff(var_172_15)
						var_172_9:send_rpc_clients("rpc_add_buff", var_172_16, var_172_18, var_172_10, 0, false)
					else
						var_172_9:send_rpc_server("rpc_add_buff", var_172_16, var_172_18, var_172_10, 0, true)
					end
				end
			end
		end
	end,
	gain_kerillian_maidenguard_uninterruptible_on_block_broken_buff = function(arg_173_0, arg_173_1, arg_173_2)
		if ALIVE[arg_173_0] then
			ScriptUnit.extension(arg_173_0, "buff_system"):add_buff("kerillian_maidenguard_uninterruptible_on_block_broken_buff")
		end
	end,
	victor_bountyhunter_activate_passive_on_melee_kill = function(arg_174_0, arg_174_1, arg_174_2)
		if not ALIVE[arg_174_0] then
			return
		end

		local var_174_0 = arg_174_2[1]

		if not var_174_0 then
			return
		end

		local var_174_1 = var_174_0[DamageDataIndex.ATTACK_TYPE]

		if not var_174_1 or var_174_1 ~= "light_attack" and var_174_1 ~= "heavy_attack" then
			return
		end

		local var_174_2 = ScriptUnit.extension(arg_174_0, "buff_system")
		local var_174_3 = var_174_2:get_non_stacking_buff("victor_bountyhunter_passive_crit_cooldown")

		if ScriptUnit.extension(arg_174_0, "talent_system"):has_talent("victor_bountyhunter_passive_reduced_cooldown", "witch_hunter", true) then
			var_174_3 = var_174_2:get_non_stacking_buff("victor_bountyhunter_passive_reduced_cooldown")
		end

		if var_174_3 then
			var_174_3.duration = 0
		end
	end,
	on_kill_add_remove = function(arg_175_0, arg_175_1, arg_175_2)
		if not ALIVE[arg_175_0] then
			return
		end

		local var_175_0 = arg_175_2[1]

		if not var_175_0 then
			return
		end

		local var_175_1 = arg_175_1.template.on_kill_add_remove_data

		if not var_175_1 then
			return
		end

		local var_175_2 = var_175_1.weapon_type

		if var_175_2 then
			local var_175_3 = var_175_0[DamageDataIndex.ATTACK_TYPE]

			if var_175_2 == "melee" then
				if not var_175_3 or var_175_3 ~= "light_attack" and var_175_3 ~= "heavy_attack" then
					return
				end
			elseif var_175_2 == "ranged" and (not var_175_3 or var_175_3 ~= "instant_projectile" and var_175_3 ~= "projectile" or var_175_3 == "heavy_instant_projectile") then
				return
			end
		end

		local var_175_4 = ScriptUnit.has_extension(arg_175_0, "buff_system")

		if var_175_4 then
			local var_175_5 = var_175_1.requirements

			if var_175_5 then
				local var_175_6 = var_175_5.buffs_exist

				if var_175_6 then
					for iter_175_0 = 1, #var_175_6 do
						if not var_175_4:has_buff_type(var_175_6[iter_175_0]) then
							return
						end
					end
				end

				local var_175_7 = var_175_5.buffs_not_exist

				if var_175_7 then
					for iter_175_1 = 1, #var_175_7 do
						if var_175_4:has_buff_type(var_175_7[iter_175_1]) then
							return
						end
					end
				end
			end

			local var_175_8 = var_175_1.buffs_to_add

			if var_175_8 then
				for iter_175_2 = 1, #var_175_8 do
					var_175_4:add_buff(var_175_8[iter_175_2])
				end
			end

			local var_175_9 = var_175_1.buffs_to_remove

			if var_175_9 then
				for iter_175_3 = 1, #var_175_9 do
					local var_175_10 = var_175_4:get_non_stacking_buff(var_175_9[iter_175_3])

					if var_175_10 then
						var_175_4:remove_buff(var_175_10.id)
					end
				end
			end
		end
	end,
	event_hud_sfx = function(arg_176_0, arg_176_1, arg_176_2)
		local var_176_0 = ScriptUnit.extension(arg_176_0, "first_person_system")

		if var_176_0 then
			local var_176_1 = arg_176_1.template.sound_to_play

			var_176_0:play_hud_sound_event(var_176_1, nil, false)
		end
	end,
	ignore_death_func = function(arg_177_0, arg_177_1, arg_177_2)
		if not var_0_7() then
			return
		end

		if not ALIVE[arg_177_0] then
			return
		end

		local var_177_0 = ScriptUnit.extension(arg_177_0, "buff_system")

		if var_177_0:has_buff_perk("invulnerable") then
			return
		end

		local var_177_1 = arg_177_1.template
		local var_177_2 = ScriptUnit.has_extension(arg_177_0, "health_system")
		local var_177_3 = var_177_1.health_threshold
		local var_177_4 = var_177_2:current_health()
		local var_177_5 = var_177_2:get_max_health()
		local var_177_6 = arg_177_2[2]

		if var_177_6 <= 0 then
			return
		end

		local var_177_7 = (var_177_4 - var_177_6) / var_177_5

		if var_177_7 <= 0 and var_177_0:has_buff_perk("ignore_death") then
			return
		end

		local var_177_8 = arg_177_2[3]

		if var_177_7 < var_177_3 and var_177_8 ~= "life_tap" then
			local var_177_9 = var_177_1.condition_func
			local var_177_10 = Managers.player:owner(arg_177_0)

			if var_177_9 and not var_177_9(var_177_10, arg_177_1, arg_177_2) then
				return
			end

			local var_177_11 = var_177_4 - var_177_6 > 1 and var_177_6 or var_177_4 - 1

			DamageUtils.add_damage_network(arg_177_0, arg_177_0, var_177_11, "torso", "life_tap", nil, Vector3(0, 0, 0), "life_tap", nil, arg_177_0, nil, nil, nil, nil, nil, nil, nil, nil, 1)

			local var_177_12 = var_177_1.buffs_to_add
			local var_177_13 = Managers.state.entity:system("buff_system")

			for iter_177_0 = 1, #var_177_12 do
				local var_177_14 = var_177_12[iter_177_0]

				var_177_13:add_buff(arg_177_0, var_177_14, arg_177_0, false)
			end
		end
	end,
	apply_dot_on_hit = function(arg_178_0, arg_178_1, arg_178_2)
		if not Managers.state.network.is_server then
			return
		end

		local var_178_0
		local var_178_1
		local var_178_2 = ScriptUnit.has_extension(arg_178_0, "career_system")
		local var_178_3 = var_178_2 and var_178_2:get_career_power_level() or DefaultPowerLevel
		local var_178_4 = arg_178_2[1]
		local var_178_5
		local var_178_6 = "buff"
		local var_178_7
		local var_178_8 = false
		local var_178_9
		local var_178_10 = arg_178_1.source_attacker_unit or arg_178_0
		local var_178_11 = FrameTable.alloc_table()

		var_178_11.dot_template_name = arg_178_1.template.dot_template_name

		DamageUtils.apply_dot(var_178_0, var_178_1, var_178_3, var_178_4, arg_178_0, var_178_5, var_178_6, var_178_7, var_178_8, var_178_9, var_178_10, var_178_11)
	end,
	dummy_function = function(arg_179_0, arg_179_1, arg_179_2)
		return true
	end,
	add_buff_synced = function(arg_180_0, arg_180_1, arg_180_2)
		BuffFunctionTemplates.functions.add_buff_synced(arg_180_0, arg_180_1, arg_180_2)
	end,
	remove_buff_synced = function(arg_181_0, arg_181_1, arg_181_2)
		BuffFunctionTemplates.functions.remove_buff_synced(arg_181_0, arg_181_1, arg_181_2)
	end,
	add_kill_timer = function(arg_182_0, arg_182_1, arg_182_2)
		if not Managers.state.network.is_server then
			return
		end

		ScriptUnit.has_extension(arg_182_0, "buff_system"):add_buff("enemy_kill_timer_buff")
	end
}
StackingBuffFunctions = {
	add_remove_buffs = function(arg_183_0, arg_183_1, arg_183_2, arg_183_3)
		if ALIVE[arg_183_0] then
			local var_183_0 = arg_183_1.max_stack_data

			if var_183_0 then
				local var_183_1 = ScriptUnit.extension(arg_183_0, "buff_system")
				local var_183_2 = var_183_0.buffs_to_add

				if var_183_2 then
					for iter_183_0 = 1, #var_183_2 do
						var_183_1:add_buff(var_183_2[iter_183_0])
					end
				end

				if arg_183_3 then
					local var_183_3 = var_183_0.overflow_buffs_to_add

					if var_183_3 then
						for iter_183_1 = 1, #var_183_3 do
							var_183_1:add_buff(var_183_3[iter_183_1])
						end
					end
				end

				local var_183_4 = var_183_0.talent_buffs

				if var_183_4 then
					local var_183_5 = ScriptUnit.has_extension(arg_183_0, "talent_system")

					if var_183_5 then
						for iter_183_2, iter_183_3 in pairs(var_183_4) do
							local var_183_6 = iter_183_3.buffs_to_add
							local var_183_7 = iter_183_3.buffs_to_add_if_missing
							local var_183_8 = var_183_5:has_talent(iter_183_2)

							if var_183_8 and var_183_6 then
								for iter_183_4 = 1, #var_183_6 do
									local var_183_9 = var_183_6[iter_183_4]

									if not var_183_9.only_if_overflow or arg_183_3 then
										local var_183_10 = var_183_9.name

										if iter_183_3.rpc_sync then
											Managers.state.entity:system("buff_system"):add_buff(arg_183_0, var_183_10, arg_183_0, false)
										else
											var_183_1:add_buff(var_183_10)
										end
									end
								end
							elseif not var_183_8 and var_183_7 then
								for iter_183_5 = 1, #var_183_7 do
									local var_183_11 = var_183_7[iter_183_5]

									if not var_183_11.only_if_overflow or arg_183_3 then
										local var_183_12 = var_183_11.name

										if iter_183_3.rpc_sync then
											Managers.state.entity:system("buff_system"):add_buff(arg_183_0, var_183_12, arg_183_0, false)
										else
											var_183_1:add_buff(var_183_12)
										end
									end
								end
							end
						end
					end
				end

				local var_183_13 = var_183_0.buffs_to_remove

				if var_183_13 then
					for iter_183_6 = 1, #var_183_13 do
						local var_183_14 = var_183_1:get_non_stacking_buff(var_183_13[iter_183_6])

						if var_183_14 then
							var_183_1:remove_buff(var_183_14.id)
						end
					end
				end
			end
		end

		return false
	end,
	reapply_buff = function(arg_184_0, arg_184_1, arg_184_2, arg_184_3)
		if ALIVE[arg_184_0] then
			local var_184_0 = ScriptUnit.extension(arg_184_0, "buff_system")
			local var_184_1 = var_184_0:get_stacking_buff(arg_184_1.name)

			if var_184_1 then
				local var_184_2 = -math.huge
				local var_184_3
				local var_184_4 = Managers.time:time("game")

				for iter_184_0 = 1, #var_184_1 do
					local var_184_5 = var_184_1[iter_184_0]
					local var_184_6 = var_184_4 - var_184_5.start_time

					if var_184_2 < var_184_6 then
						var_184_3 = var_184_5
						var_184_2 = var_184_6
					end
				end

				var_184_0:remove_buff(var_184_3.id)
			end
		end

		return true
	end,
	reapply_infinite_burn = function(arg_185_0, arg_185_1, arg_185_2, arg_185_3)
		if ALIVE[arg_185_0] then
			local var_185_0 = ScriptUnit.extension(arg_185_0, "buff_system")
			local var_185_1 = var_185_0:get_stacking_buff(arg_185_1.name)
			local var_185_2

			if var_185_1 then
				local var_185_3 = -math.huge
				local var_185_4 = Managers.time:time("game")

				for iter_185_0 = 1, #var_185_1 do
					local var_185_5 = var_185_1[iter_185_0]
					local var_185_6 = var_185_4 - var_185_5.start_time

					if var_185_3 < var_185_6 then
						var_185_2 = var_185_5
						var_185_3 = var_185_6
					end
				end
			end

			if var_185_2 then
				if not Unit.alive(var_185_2.source_attacker_unit or var_185_2.attacker_unit) then
					var_185_0:remove_buff(var_185_2.id)

					return true
				end

				local var_185_7 = var_185_2.power_level or DefaultPowerLevel
				local var_185_8 = arg_185_2.power_level or DefaultPowerLevel

				if not (var_185_2.template == arg_185_1 and var_185_8 <= var_185_7) then
					local var_185_9 = "full"
					local var_185_10 = DamageUtils.calculate_dot_buff_damage(arg_185_0, var_185_2.source_attacker_unit or var_185_2.attacker_unit, var_185_9, var_185_2.damage_source, var_185_2.power_level, var_185_2.template.damage_profile)
					local var_185_11 = DamageUtils.calculate_dot_buff_damage(arg_185_0, arg_185_2.source_attacker_unit or arg_185_2.attacker_unit, var_185_9, arg_185_2.damage_source, arg_185_2.power_level, arg_185_1.damage_profile)

					if var_185_10 / var_185_2.template.time_between_dot_damages < var_185_11 / arg_185_1.time_between_dot_damages then
						var_185_0:remove_buff(var_185_2.id)

						return true
					end
				end

				return false
			end
		end

		return true
	end,
	add_buff_synced = function(arg_186_0, arg_186_1, arg_186_2, arg_186_3)
		local var_186_0 = FrameTable.alloc_table()

		var_186_0.template = arg_186_1

		BuffFunctionTemplates.functions.add_buff_synced(arg_186_0, var_186_0, arg_186_2)
	end,
	remove_buff_synced = function(arg_187_0, arg_187_1, arg_187_2, arg_187_3)
		local var_187_0 = FrameTable.alloc_table()

		var_187_0.template = arg_187_1

		BuffFunctionTemplates.functions.remove_buff_synced(arg_187_0, var_187_0, arg_187_2)
	end,
	reduce_cooldown_percent = function(arg_188_0, arg_188_1, arg_188_2, arg_188_3)
		local var_188_0 = FrameTable.alloc_table()

		var_188_0.template = arg_188_1

		BuffFunctionTemplates.functions.reduce_cooldown_percent(arg_188_0, var_188_0, arg_188_2)
	end
}
PotionSpreadTrinketTemplates = {
	damage_boost_potion = {
		tier1 = "damage_boost_potion_weak",
		tier3 = "damage_boost_potion",
		tier2 = "damage_boost_potion_medium"
	},
	speed_boost_potion = {
		tier1 = "speed_boost_potion_weak",
		tier3 = "speed_boost_potion",
		tier2 = "speed_boost_potion_medium"
	},
	invulnerability_potion = {
		tier1 = "invulnerability_potion_weak",
		tier3 = "invulnerability_potion",
		tier2 = "invulnerability_potion_medium"
	}
}
TrinketSpreadDistance = 10

local var_0_9 = 30

BuffTemplates = {
	end_zone_invincibility = {
		buffs = {
			{
				duration = 1,
				name = "end_zone_invincibility",
				max_stacks = 1,
				refresh_durations = true,
				perks = {
					var_0_0.invulnerable,
					var_0_0.no_ranged_knockback
				}
			}
		}
	},
	twitch_damage_boost = {
		buffs = {
			{
				duration = 60,
				name = "twitch_armor_penetration_buff",
				refresh_durations = true,
				max_stacks = 1,
				icon = "potion_buff_01",
				perks = {
					var_0_0.potion_armor_penetration
				}
			}
		}
	},
	twitch_speed_boost = {
		buffs = {
			{
				apply_buff_func = "apply_movement_buff",
				multiplier = 1.5,
				name = "twitch_movement_buff",
				icon = "potion_buff_02",
				refresh_durations = true,
				remove_buff_func = "remove_movement_buff",
				max_stacks = 1,
				duration = 60,
				path_to_movement_setting_to_modify = {
					"move_speed"
				}
			},
			{
				multiplier = 0.5,
				name = "twitch_attack_speed_buff",
				stat_buff = "attack_speed",
				refresh_durations = true,
				max_stacks = 1,
				duration = 60
			}
		}
	},
	twitch_cooldown_reduction_boost = {
		buffs = {
			{
				name = "twitch_cooldown_reduction_buff",
				multiplier = 5,
				stat_buff = "cooldown_regen",
				duration = 60,
				max_stacks = 1,
				icon = "potion_buff_03",
				refresh_durations = true
			}
		}
	},
	twitch_no_overcharge_no_ammo_reloads = {
		buffs = {
			{
				max_stacks = 1,
				icon = "victor_bountyhunter_passive_infinite_ammo",
				duration = 60,
				name = "twitch_no_overcharge_no_ammo_reloads"
			}
		}
	},
	twitch_health_regen = {
		buffs = {
			{
				update_func = "health_regen_all_update",
				heal_type = "health_regen",
				name = "twitch_health_regen",
				icon = "bardin_ranger_activated_ability_heal",
				time_between_heal = 2,
				max_stacks = 1,
				apply_buff_func = "health_regen_all_start",
				heal = 1,
				duration = 60
			}
		}
	},
	twitch_health_degen = {
		buffs = {
			{
				duration = 60,
				name = "twitch_health_degen",
				damage = 1,
				icon = "bardin_slayer_crit_chance",
				apply_buff_func = "health_degen_start",
				time_between_damage = 3,
				damage_type = "health_degen",
				max_stacks = 1,
				update_func = "health_degen_update"
			}
		}
	},
	twitch_grimoire_health_debuff = {
		buffs = {
			{
				duration = 60,
				name = "twitch_grimoire_health_debuff",
				debuff = true,
				max_stacks = 1,
				icon = "buff_icon_grimoire_health_debuff",
				perks = {
					var_0_0.twitch_grimoire
				}
			}
		}
	},
	twitch_power_boost_dismember = {
		buffs = {
			{
				name = "twitch_power_boost_dismember",
				multiplier = 0.25,
				stat_buff = "power_level",
				duration = 60,
				max_stacks = 1,
				icon = "markus_huntsman_activated_ability",
				perks = {
					var_0_0.bloody_mess
				}
			}
		}
	},
	heavy_attack_shield_break = {
		buffs = {
			{
				name = "heavy_attack_shield_break",
				perks = {
					var_0_0.shield_break
				}
			}
		}
	},
	temporary_health_degen = {
		buffs = {
			{
				name = "temporary health degen",
				damage = 10,
				damage_type = "temporary_health_degen",
				max_stacks = 1,
				update_func = "temporary_health_degen_update",
				apply_buff_func = "temporary_health_degen_start",
				time_between_damage = 3
			}
		}
	},
	knockdown_bleed = {
		buffs = {
			{
				name = "knockdown bleed",
				damage = 10,
				damage_type = "knockdown_bleed",
				max_stacks = 1,
				update_func = "knock_down_bleed_update",
				apply_buff_func = "knock_down_bleed_start",
				time_between_damage = 3
			}
		}
	},
	blightreaper_curse = {
		buffs = {
			{
				max_stacks = 1,
				name = "blightreaper_curse",
				apply_buff_func = "convert_permanent_to_temporary_health",
				perks = {
					var_0_0.disable_permanent_heal
				}
			}
		}
	},
	damage_boost_potion = {
		activation_effect = "fx/screenspace_potion_01",
		deactivation_sound = "hud_gameplay_stance_deactivate",
		activation_sound = "hud_gameplay_stance_smiter_activate",
		buffs = {
			{
				duration = 10,
				name = "potion_armor_penetration_buff",
				refresh_durations = true,
				max_stacks = 1,
				icon = "potion_buff_01",
				perks = {
					var_0_0.potion_armor_penetration
				}
			}
		}
	},
	speed_boost_potion = {
		activation_effect = "fx/screenspace_potion_02",
		deactivation_sound = "hud_gameplay_stance_deactivate",
		activation_sound = "hud_gameplay_stance_ninjafencer_activate",
		buffs = {
			{
				apply_buff_func = "apply_movement_buff",
				multiplier = 1.5,
				name = "potion_movement_buff",
				icon = "potion_buff_02",
				refresh_durations = true,
				remove_buff_func = "remove_movement_buff",
				max_stacks = 1,
				duration = 10,
				path_to_movement_setting_to_modify = {
					"move_speed"
				}
			},
			{
				multiplier = 0.5,
				name = "potion_attack_speed_buff",
				stat_buff = "attack_speed",
				refresh_durations = true,
				max_stacks = 1,
				duration = 10
			}
		}
	},
	cooldown_reduction_potion = {
		activation_effect = "fx/screenspace_potion_02",
		deactivation_sound = "hud_gameplay_stance_deactivate",
		activation_sound = "hud_gameplay_stance_ninjafencer_activate",
		buffs = {
			{
				name = "potion_cooldown_reduction_buff",
				multiplier = 10,
				stat_buff = "cooldown_regen",
				duration = 10,
				max_stacks = 1,
				icon = "potion_buff_03",
				refresh_durations = true
			}
		}
	},
	invulnerability_potion = {
		activation_effect = "fx/screenspace_potion_03",
		deactivation_sound = "hud_gameplay_stance_deactivate",
		activation_sound = "hud_gameplay_stance_tank_activate",
		buffs = {
			{
				duration = 10,
				name = "invulnerability_potion",
				max_stacks = 1,
				refresh_durations = true,
				perks = {
					var_0_0.invulnerable
				}
			}
		}
	},
	damage_boost_potion_increased = {
		activation_effect = "fx/screenspace_potion_01",
		deactivation_sound = "hud_gameplay_stance_deactivate",
		activation_sound = "hud_gameplay_stance_smiter_activate",
		buffs = {
			{
				duration = 15,
				name = "potion_armor_penetration_buff",
				refresh_durations = true,
				max_stacks = 1,
				icon = "potion_buff_01",
				perks = {
					var_0_0.potion_armor_penetration
				}
			}
		}
	},
	speed_boost_potion_increased = {
		activation_effect = "fx/screenspace_potion_02",
		deactivation_sound = "hud_gameplay_stance_deactivate",
		activation_sound = "hud_gameplay_stance_ninjafencer_activate",
		buffs = {
			{
				apply_buff_func = "apply_movement_buff",
				multiplier = 1.5,
				name = "potion_movement_buff",
				icon = "potion_buff_02",
				refresh_durations = true,
				remove_buff_func = "remove_movement_buff",
				max_stacks = 1,
				duration = 15,
				path_to_movement_setting_to_modify = {
					"move_speed"
				}
			},
			{
				multiplier = 0.5,
				name = "potion_attack_speed_buff",
				stat_buff = "attack_speed",
				refresh_durations = true,
				max_stacks = 1,
				duration = 15
			}
		}
	},
	cooldown_reduction_potion_increased = {
		activation_effect = "fx/screenspace_potion_02",
		deactivation_sound = "hud_gameplay_stance_deactivate",
		activation_sound = "hud_gameplay_stance_ninjafencer_activate",
		buffs = {
			{
				name = "potion_cooldown_reduction_buff",
				multiplier = 15,
				stat_buff = "cooldown_regen",
				duration = 15,
				max_stacks = 1,
				icon = "potion_buff_03",
				refresh_durations = true
			}
		}
	},
	invulnerability_potion_increased = {
		activation_effect = "fx/screenspace_potion_03",
		deactivation_sound = "hud_gameplay_stance_deactivate",
		activation_sound = "hud_gameplay_stance_tank_activate",
		buffs = {
			{
				duration = 15,
				name = "invulnerability_potion_increased",
				max_stacks = 1,
				refresh_durations = true,
				perks = {
					var_0_0.invulnerable
				}
			}
		}
	},
	damage_boost_potion_reduced = {
		activation_effect = "fx/screenspace_potion_01",
		deactivation_sound = "hud_gameplay_stance_deactivate",
		activation_sound = "hud_gameplay_stance_smiter_activate",
		buffs = {
			{
				duration = 5,
				name = "potion_armor_penetration_buff",
				refresh_durations = true,
				max_stacks = 1,
				icon = "potion_buff_01",
				perks = {
					var_0_0.potion_armor_penetration
				}
			}
		}
	},
	speed_boost_potion_reduced = {
		activation_effect = "fx/screenspace_potion_02",
		deactivation_sound = "hud_gameplay_stance_deactivate",
		activation_sound = "hud_gameplay_stance_ninjafencer_activate",
		buffs = {
			{
				apply_buff_func = "apply_movement_buff",
				multiplier = 1.5,
				name = "potion_movement_buff",
				icon = "potion_buff_02",
				refresh_durations = true,
				remove_buff_func = "remove_movement_buff",
				max_stacks = 1,
				duration = 5,
				path_to_movement_setting_to_modify = {
					"move_speed"
				}
			},
			{
				multiplier = 0.5,
				name = "potion_attack_speed_buff",
				stat_buff = "attack_speed",
				refresh_durations = true,
				max_stacks = 1,
				duration = 5
			}
		}
	},
	cooldown_reduction_potion_reduced = {
		activation_effect = "fx/screenspace_potion_02",
		deactivation_sound = "hud_gameplay_stance_deactivate",
		activation_sound = "hud_gameplay_stance_ninjafencer_activate",
		buffs = {
			{
				name = "potion_cooldown_reduction_buff",
				multiplier = 10,
				stat_buff = "cooldown_regen",
				duration = 5,
				max_stacks = 1,
				icon = "potion_buff_03",
				refresh_durations = true
			}
		}
	},
	invulnerability_potion_reduced = {
		activation_effect = "fx/screenspace_potion_03",
		deactivation_sound = "hud_gameplay_stance_deactivate",
		activation_sound = "hud_gameplay_stance_tank_activate",
		buffs = {
			{
				duration = 5,
				name = "invulnerability_potion_reduced",
				max_stacks = 1,
				refresh_durations = true,
				perks = {
					var_0_0.invulnerable
				}
			}
		}
	},
	grimoire_health_debuff = {
		activation_sound = "hud_info_state_grimoire_pickup",
		buffs = {
			{
				name = "grimoire_health_debuff",
				icon = "buff_icon_grimoire_health_debuff",
				debuff = true,
				perks = {
					var_0_0.skaven_grimoire
				}
			}
		}
	},
	overcharged = {
		buffs = {
			{
				multiplier = -0.15,
				name = "attack speed buff",
				stat_buff = "attack_speed"
			}
		}
	},
	overcharged_no_attack_penalty = {
		buffs = {}
	},
	overcharged_critical = {
		buffs = {
			{
				remove_buff_name = "planted_return_to_normal_movement",
				name = "increase speed",
				lerp_time = 0.2,
				multiplier = 0.85,
				update_func = "update_action_lerp_movement_buff",
				remove_buff_func = "remove_action_lerp_movement_buff",
				apply_buff_func = "apply_action_lerp_movement_buff",
				path_to_movement_setting_to_modify = {
					"move_speed"
				}
			},
			{
				name = "change dodge speed",
				multiplier = 0.85,
				remove_buff_func = "remove_movement_buff",
				apply_buff_func = "apply_movement_buff",
				path_to_movement_setting_to_modify = {
					"dodging",
					"speed_modifier"
				}
			},
			{
				multiplier = -0.25,
				name = "attack speed buff",
				stat_buff = "attack_speed"
			}
		}
	},
	overcharged_critical_no_attack_penalty = {
		buffs = {}
	},
	change_dodge_speed = {
		buffs = {
			{
				name = "change dodge speed",
				multiplier = 1,
				remove_buff_func = "remove_movement_buff",
				apply_buff_func = "apply_movement_buff",
				path_to_movement_setting_to_modify = {
					"dodging",
					"speed_modifier"
				}
			}
		}
	},
	change_dodge_distance = {
		buffs = {
			{
				name = "change dodge distance",
				multiplier = 1,
				remove_buff_func = "remove_movement_buff",
				apply_buff_func = "apply_movement_buff",
				path_to_movement_setting_to_modify = {
					"dodging",
					"distance_modifier"
				}
			}
		}
	},
	statue_decrease_movement = {
		description = "description_melee_weapon_ammo_on_killing_blow_tier1",
		apply_on = "wield",
		display_name = "melee_weapon_ammo_on_killing_blow_tier1",
		icon = "trait_icons_scavenger",
		description_values = {
			"multiplier"
		},
		buffs = {
			{
				remove_buff_name = "planted_return_to_normal_movement",
				name = "decrease_speed",
				lerp_time = 0.2,
				multiplier = 0.75,
				update_func = "update_action_lerp_movement_buff",
				remove_buff_func = "remove_action_lerp_movement_buff",
				apply_buff_func = "apply_action_lerp_movement_buff",
				path_to_movement_setting_to_modify = {
					"move_speed"
				}
			},
			{
				remove_buff_name = "planted_return_to_normal_crouch_movement",
				name = "decrease_crouch_speed",
				lerp_time = 0.2,
				multiplier = 0.75,
				update_func = "update_charging_action_lerp_movement_buff",
				remove_buff_func = "remove_action_lerp_movement_buff",
				apply_buff_func = "apply_action_lerp_movement_buff",
				path_to_movement_setting_to_modify = {
					"crouch_move_speed"
				}
			},
			{
				remove_buff_name = "planted_return_to_normal_walk_movement",
				name = "decrease_walk_speed",
				lerp_time = 0.2,
				multiplier = 0.75,
				update_func = "update_charging_action_lerp_movement_buff",
				remove_buff_func = "remove_action_lerp_movement_buff",
				apply_buff_func = "apply_action_lerp_movement_buff",
				path_to_movement_setting_to_modify = {
					"walk_move_speed"
				}
			}
		}
	},
	sack_decrease_movement = {
		description = "description_melee_weapon_ammo_on_killing_blow_tier1",
		apply_on = "wield",
		display_name = "melee_weapon_ammo_on_killing_blow_tier1",
		icon = "trait_icons_scavenger",
		description_values = {
			"multiplier"
		},
		buffs = {
			{
				remove_buff_name = "planted_return_to_normal_movement",
				name = "decrease_speed",
				lerp_time = 0.2,
				multiplier = 0.7,
				update_func = "update_action_lerp_movement_buff",
				remove_buff_func = "remove_action_lerp_movement_buff",
				apply_buff_func = "apply_action_lerp_movement_buff",
				path_to_movement_setting_to_modify = {
					"move_speed"
				}
			},
			{
				remove_buff_name = "planted_return_to_normal_crouch_movement",
				name = "decrease_crouch_speed",
				lerp_time = 0.2,
				multiplier = 0.7,
				update_func = "update_charging_action_lerp_movement_buff",
				remove_buff_func = "remove_action_lerp_movement_buff",
				apply_buff_func = "apply_action_lerp_movement_buff",
				path_to_movement_setting_to_modify = {
					"crouch_move_speed"
				}
			},
			{
				remove_buff_name = "planted_return_to_normal_walk_movement",
				name = "decrease_walk_speed",
				lerp_time = 0.2,
				multiplier = 0.7,
				update_func = "update_charging_action_lerp_movement_buff",
				remove_buff_func = "remove_action_lerp_movement_buff",
				apply_buff_func = "apply_action_lerp_movement_buff",
				path_to_movement_setting_to_modify = {
					"walk_move_speed"
				}
			}
		}
	},
	planted_decrease_movement = {
		buffs = {
			{
				remove_buff_name = "planted_return_to_normal_movement",
				name = "decrease_speed",
				lerp_time = 0.2,
				multiplier = 0.75,
				update_func = "update_action_lerp_movement_buff",
				remove_buff_func = "remove_action_lerp_movement_buff",
				apply_buff_func = "apply_action_lerp_movement_buff",
				path_to_movement_setting_to_modify = {
					"move_speed"
				}
			},
			{
				remove_buff_name = "planted_return_to_normal_crouch_movement",
				name = "decrease_crouch_speed",
				lerp_time = 1,
				multiplier = 0.75,
				update_func = "update_charging_action_lerp_movement_buff",
				remove_buff_func = "remove_action_lerp_movement_buff",
				apply_buff_func = "apply_action_lerp_movement_buff",
				path_to_movement_setting_to_modify = {
					"crouch_move_speed"
				}
			},
			{
				remove_buff_name = "planted_return_to_normal_walk_movement",
				name = "decrease_walk_speed",
				lerp_time = 1,
				multiplier = 0.75,
				update_func = "update_charging_action_lerp_movement_buff",
				remove_buff_func = "remove_action_lerp_movement_buff",
				apply_buff_func = "apply_action_lerp_movement_buff",
				path_to_movement_setting_to_modify = {
					"walk_move_speed"
				}
			}
		}
	},
	planted_charging_decrease_movement = {
		buffs = {
			{
				remove_buff_name = "planted_return_to_normal_movement",
				name = "decrease_speed",
				lerp_time = 1,
				multiplier = 0.75,
				update_func = "update_charging_action_lerp_movement_buff",
				remove_buff_func = "remove_action_lerp_movement_buff",
				apply_buff_func = "apply_action_lerp_movement_buff",
				path_to_movement_setting_to_modify = {
					"move_speed"
				}
			},
			{
				remove_buff_name = "planted_return_to_normal_crouch_movement",
				name = "decrease_crouch_speed",
				lerp_time = 1,
				multiplier = 0.75,
				update_func = "update_charging_action_lerp_movement_buff",
				remove_buff_func = "remove_action_lerp_movement_buff",
				apply_buff_func = "apply_action_lerp_movement_buff",
				path_to_movement_setting_to_modify = {
					"crouch_move_speed"
				}
			},
			{
				remove_buff_name = "planted_return_to_normal_walk_movement",
				name = "decrease_walk_speed",
				lerp_time = 1,
				multiplier = 0.75,
				update_func = "update_charging_action_lerp_movement_buff",
				remove_buff_func = "remove_action_lerp_movement_buff",
				apply_buff_func = "apply_action_lerp_movement_buff",
				path_to_movement_setting_to_modify = {
					"walk_move_speed"
				}
			}
		}
	},
	planted_casting_long_decrease_movement = {
		buffs = {
			{
				remove_buff_name = "planted_return_to_normal_movement",
				name = "decrease_speed",
				lerp_time = 2,
				multiplier = 0.75,
				update_func = "update_action_lerp_movement_buff",
				remove_buff_func = "remove_action_lerp_movement_buff",
				apply_buff_func = "apply_action_lerp_movement_buff",
				path_to_movement_setting_to_modify = {
					"move_speed"
				}
			},
			{
				remove_buff_name = "planted_return_to_normal_crouch_movement",
				name = "decrease_crouch_speed",
				lerp_time = 2,
				multiplier = 0.75,
				update_func = "update_action_lerp_movement_buff",
				remove_buff_func = "remove_action_lerp_movement_buff",
				apply_buff_func = "apply_action_lerp_movement_buff",
				path_to_movement_setting_to_modify = {
					"crouch_move_speed"
				}
			},
			{
				remove_buff_name = "planted_return_to_normal_walk_movement",
				name = "decrease_walk_speed",
				lerp_time = 2,
				multiplier = 0.75,
				update_func = "update_action_lerp_movement_buff",
				remove_buff_func = "remove_action_lerp_movement_buff",
				apply_buff_func = "apply_action_lerp_movement_buff",
				path_to_movement_setting_to_modify = {
					"walk_move_speed"
				}
			}
		}
	},
	planted_fast_decrease_movement = {
		buffs = {
			{
				remove_buff_name = "planted_return_to_normal_movement",
				name = "decrease_speed",
				lerp_time = 0.01,
				multiplier = 1,
				update_func = "update_action_lerp_movement_buff",
				remove_buff_func = "remove_action_lerp_movement_buff",
				apply_buff_func = "apply_action_lerp_movement_buff",
				path_to_movement_setting_to_modify = {
					"move_speed"
				}
			},
			{
				remove_buff_name = "planted_return_to_normal_crouch_movement",
				name = "decrease_crouch_speed",
				lerp_time = 0.01,
				multiplier = 1,
				update_func = "update_action_lerp_movement_buff",
				remove_buff_func = "remove_action_lerp_movement_buff",
				apply_buff_func = "apply_action_lerp_movement_buff",
				path_to_movement_setting_to_modify = {
					"crouch_move_speed"
				}
			},
			{
				remove_buff_name = "planted_return_to_normal_walk_movement",
				name = "decrease_walk_speed",
				lerp_time = 0.01,
				multiplier = 1,
				update_func = "update_action_lerp_movement_buff",
				remove_buff_func = "remove_action_lerp_movement_buff",
				apply_buff_func = "apply_action_lerp_movement_buff",
				path_to_movement_setting_to_modify = {
					"walk_move_speed"
				}
			}
		}
	},
	planted_return_to_normal_movement = {
		buffs = {
			{
				update_func = "update_action_lerp_remove_movement_buff",
				name = "increase speed return",
				lerp_time = 0.2,
				duration = 1,
				apply_buff_func = "apply_action_lerp_remove_movement_buff",
				path_to_movement_setting_to_modify = {
					"move_speed"
				}
			}
		}
	},
	planted_return_to_normal_crouch_movement = {
		buffs = {
			{
				update_func = "update_action_lerp_remove_movement_buff",
				name = "increase speed return",
				lerp_time = 0.2,
				duration = 1,
				apply_buff_func = "apply_action_lerp_remove_movement_buff",
				path_to_movement_setting_to_modify = {
					"crouch_move_speed"
				}
			}
		}
	},
	planted_return_to_normal_walk_movement = {
		buffs = {
			{
				update_func = "update_action_lerp_remove_movement_buff",
				name = "increase speed return",
				lerp_time = 0.2,
				duration = 1,
				apply_buff_func = "apply_action_lerp_remove_movement_buff",
				path_to_movement_setting_to_modify = {
					"walk_move_speed"
				}
			}
		}
	},
	planted_decrease_rotation_speed = {
		buffs = {
			{
				remove_buff_name = "planted_return_to_normal_rotation",
				name = "decrease_rotation_speed",
				lerp_time = 0.2,
				multiplier = 0.75,
				update_func = "update_action_lerp_movement_buff",
				remove_buff_func = "remove_action_lerp_movement_buff",
				apply_buff_func = "apply_action_lerp_movement_buff",
				path_to_movement_setting_to_modify = {
					"look_input_sensitivity"
				}
			}
		}
	},
	planted_return_to_normal_rotation = {
		buffs = {
			{
				update_func = "update_action_lerp_remove_movement_buff",
				name = "decrease_rotation_speed_return",
				lerp_time = 0.2,
				duration = 1,
				apply_buff_func = "apply_action_lerp_remove_movement_buff",
				path_to_movement_setting_to_modify = {
					"look_input_sensitivity"
				}
			}
		}
	},
	set_rotation_limit = {
		buffs = {
			{
				name = "set_rotation_limit",
				remove_buff_func = "remove_rotation_limit_buff",
				apply_buff_func = "apply_rotation_limit_buff",
				bonus = 1,
				max_stacks = math.huge,
				path_to_movement_setting_to_modify = {
					"look_input_limit"
				}
			}
		}
	},
	planted_rotation_limit_multiplier = {
		buffs = {
			{
				remove_buff_name = "planted_return_to_normal_rotation_limit_multiplier",
				name = "planted_rotation_limit_multiplier",
				lerp_time = 0.4,
				multiplier = 0.75,
				update_func = "update_action_lerp_movement_buff",
				remove_buff_func = "remove_action_lerp_movement_buff",
				apply_buff_func = "apply_action_lerp_movement_buff",
				path_to_movement_setting_to_modify = {
					"look_input_limit_multiplier"
				}
			}
		}
	},
	planted_return_to_normal_rotation_limit_multiplier = {
		buffs = {
			{
				update_func = "update_action_lerp_remove_movement_buff",
				name = "planted_return_to_normal_rotation_limit_multiplier",
				lerp_time = 0.4,
				duration = 1.5,
				apply_buff_func = "apply_action_lerp_remove_movement_buff",
				path_to_movement_setting_to_modify = {
					"look_input_limit_multiplier"
				}
			}
		}
	},
	arrow_poison_dot = {
		buffs = {
			{
				duration = 3,
				name = "arrow poison dot",
				time_between_dot_damages = 0.6,
				damage_profile = "poison_direct",
				update_func = "apply_dot_damage",
				apply_buff_func = "start_dot_damage",
				update_start_delay = 0.6,
				perks = {
					var_0_0.poisoned
				}
			}
		}
	},
	aoe_poison_dot = {
		buffs = {
			{
				duration = 3,
				name = "aoe poison dot",
				time_between_dot_damages = 0.75,
				damage_profile = "poison",
				update_func = "apply_dot_damage",
				apply_buff_func = "start_dot_damage",
				update_start_delay = 0.75,
				perks = {
					var_0_0.poisoned
				}
			}
		}
	},
	weapon_bleed_dot_dagger = {
		buffs = {
			{
				duration = 2,
				name = "weapon bleed dot dagger",
				max_stacks = 1,
				refresh_durations = true,
				apply_buff_func = "start_dot_damage",
				update_start_delay = 0.75,
				time_between_dot_damages = 0.75,
				hit_zone = "neck",
				damage_profile = "bleed",
				update_func = "apply_dot_damage",
				perks = {
					var_0_0.bleeding
				}
			}
		}
	},
	weapon_bleed_dot_whc = {
		buffs = {
			{
				duration = 2,
				name = "weapon bleed dot whc",
				max_stacks = 3,
				refresh_durations = true,
				apply_buff_func = "start_dot_damage",
				update_start_delay = 0.75,
				time_between_dot_damages = 0.75,
				hit_zone = "neck",
				damage_profile = "bleed",
				update_func = "apply_dot_damage",
				perks = {
					var_0_0.bleeding
				}
			}
		}
	},
	weapon_bleed_dot_maidenguard = {
		buffs = {
			{
				duration = 4,
				name = "weapon bleed dot maidenguard",
				max_stacks = 1,
				refresh_durations = true,
				apply_buff_func = "start_dot_damage",
				update_start_delay = 0.25,
				time_between_dot_damages = 0.25,
				hit_zone = "neck",
				damage_profile = "bleed_maidenguard",
				update_func = "apply_dot_damage",
				perks = {
					var_0_0.bleeding
				}
			}
		}
	},
	bardin_survival_ale_buff = {
		buffs = {
			{
				name = "ale_defence",
				multiplier = -0.04,
				stat_buff = "damage_taken",
				duration = 300,
				max_stacks = 3,
				icon = "buff_icon_mutator_icon_drunk",
				refresh_durations = true
			},
			{
				multiplier = 0.03,
				name = "ale_attack_speed",
				stat_buff = "attack_speed",
				refresh_durations = true,
				max_stacks = 3,
				duration = 300
			}
		}
	},
	kerillian_shade_ability_dot = {
		buffs = {
			{
				duration = 10,
				name = "kerillian_shade_ability_dot",
				time_between_dot_damages = 1,
				damage_profile = "poison",
				update_func = "apply_dot_damage",
				apply_buff_func = "start_dot_damage",
				update_start_delay = 1,
				perks = {
					var_0_0.poisoned
				}
			},
			{
				multiplier = 0.5,
				name = "kerillian_shade_ability_debuff",
				stat_buff = "damage_taken",
				refresh_durations = true,
				max_stacks = 1,
				duration = 10
			}
		}
	},
	burning_dot = {
		buffs = {
			{
				duration = 3,
				name = "burning_dot",
				apply_buff_func = "start_dot_damage",
				update_start_delay = 0.75,
				time_between_dot_damages = 0.75,
				damage_type = "burninating",
				damage_profile = "burning_dot",
				update_func = "apply_dot_damage",
				perks = {
					var_0_0.burning
				}
			}
		}
	},
	beam_burning_dot = {
		buffs = {
			{
				duration = 3,
				name = "beam_burning_dot",
				apply_buff_func = "start_dot_damage",
				update_start_delay = 1,
				time_between_dot_damages = 1,
				damage_type = "burninating",
				damage_profile = "beam_burning_dot",
				update_func = "apply_dot_damage",
				perks = {
					var_0_0.burning
				}
			}
		}
	},
	burning_flamethrower_dot = {
		buffs = {
			{
				duration = 1.5,
				name = "burning_flamethrower_dot",
				max_stacks = 1,
				refresh_durations = true,
				apply_buff_func = "start_dot_damage",
				update_start_delay = 0.65,
				time_between_dot_damages = 0.65,
				damage_type = "burninating",
				damage_profile = "flamethrower_burning_dot",
				update_func = "apply_dot_damage",
				perks = {
					var_0_0.burning
				}
			}
		}
	},
	sienna_adept_ability_trail = {
		buffs = {
			{
				leave_linger_time = 0.25,
				name = "sienna_adept_ability_trail",
				max_stacks = 1,
				on_max_stacks_overflow_func = "reapply_buff",
				apply_buff_func = "start_dot_damage",
				update_start_delay = 0.25,
				time_between_dot_damages = 0.25,
				damage_type = "burninating",
				damage_profile = "burning_dot",
				update_func = "apply_dot_damage",
				perks = {
					var_0_0.burning
				}
			}
		}
	},
	burning_dot_fire_grenade = {
		buffs = {
			{
				duration = 6,
				name = "burning_dot_fire_grenade",
				apply_buff_func = "start_dot_damage",
				update_start_delay = 1,
				time_between_dot_damages = 1,
				damage_type = "burninating",
				damage_profile = "burning_dot_firegrenade",
				update_func = "apply_dot_damage",
				perks = {
					var_0_0.burning
				},
				max_stacks_func = function(arg_189_0, arg_189_1)
					local var_189_0 = AiUtils.unit_breed(arg_189_0)

					if var_189_0 and var_189_0.is_player and Managers.mechanism:current_mechanism_name() == "versus" then
						return 1
					end

					return math.huge
				end,
				refresh_durations_func = function(arg_190_0, arg_190_1)
					local var_190_0 = AiUtils.unit_breed(arg_190_0)

					if var_190_0 and var_190_0.is_player and Managers.mechanism:current_mechanism_name() == "versus" then
						return true
					end

					return false
				end,
				duration_modifier_func = function(arg_191_0, arg_191_1, arg_191_2, arg_191_3, arg_191_4)
					if not (Managers.mechanism:current_mechanism_name() == "versus") then
						return arg_191_2
					end

					local var_191_0 = AiUtils.unit_breed(arg_191_0)

					if var_191_0 and var_191_0.is_player then
						return 2
					end

					return arg_191_2
				end
			}
		}
	},
	burning_dot_1tick = {
		buffs = {
			{
				duration = 2,
				name = "burning_dot_1tick",
				apply_buff_func = "start_dot_damage",
				update_start_delay = 1.5,
				time_between_dot_damages = 1.5,
				damage_type = "burninating",
				damage_profile = "burning_dot",
				update_func = "apply_dot_damage",
				perks = {
					var_0_0.burning
				}
			}
		}
	},
	burning_dot_1tick_vs = {
		buffs = {
			{
				duration = 4,
				name = "burning_dot_1tick_vs",
				apply_buff_func = "start_dot_damage",
				update_start_delay = 0.75,
				time_between_dot_damages = 0.75,
				damage_type = "burninating",
				damage_profile = "burning_dot",
				update_func = "apply_dot_damage",
				perks = {
					var_0_0.burning
				}
			}
		}
	},
	burning_dot_unchained_push = {
		buffs = {
			{
				duration = 6,
				name = "burning_dot_unchained_push",
				max_stacks = 1,
				refresh_durations = true,
				apply_buff_func = "start_dot_damage",
				update_start_delay = 2,
				time_between_dot_damages = 2,
				damage_type = "burninating",
				damage_profile = "burning_dot",
				update_func = "apply_dot_damage",
				perks = {
					var_0_0.burning
				}
			}
		}
	},
	burning_dot_unchained_pulse = {
		buffs = {
			{
				duration = 2,
				name = "burning_dot_unchained_pulse",
				max_stacks = 1,
				refresh_durations = true,
				apply_buff_func = "start_dot_damage",
				update_start_delay = 2,
				time_between_dot_damages = 2,
				damage_type = "burninating",
				damage_profile = "burning_dot",
				update_func = "apply_dot_damage",
				perks = {
					var_0_0.burning
				}
			}
		}
	},
	burning_dot_3tick = {
		buffs = {
			{
				duration = 3,
				name = "burning_dot_3tick",
				apply_buff_func = "start_dot_damage",
				update_start_delay = 1,
				time_between_dot_damages = 1,
				damage_type = "burninating",
				damage_profile = "burning_dot",
				update_func = "apply_dot_damage",
				perks = {
					var_0_0.burning
				}
			}
		}
	},
	super_jump = {
		buffs = {
			{
				duration = 20,
				name = "speed buff",
				multiplier = 1.7,
				remove_buff_func = "remove_movement_buff",
				apply_buff_func = "apply_movement_buff",
				path_to_movement_setting_to_modify = {
					"move_speed"
				}
			},
			{
				duration = 10,
				name = "jump buff",
				multiplier = 1.2,
				remove_buff_func = "remove_movement_buff",
				apply_buff_func = "apply_movement_buff",
				bonus = 5,
				path_to_movement_setting_to_modify = {
					"jump",
					"initial_vertical_speed"
				}
			}
		}
	},
	damage_volume_generic_dot = {
		buffs = {
			{
				update_func = "update_volume_dot_damage",
				name = "damage_volume_generic_dot",
				apply_buff_func = "apply_volume_dot_damage",
				damage_type = "volume_generic_dot"
			}
		}
	},
	catacombs_corpse_pit = {
		buffs = {
			{
				slowdown_buff_name = "corpse_pit_slowdown",
				name = "catacombs_corpse_pit",
				update_func = "update_catacombs_corpse_pit",
				apply_buff_func = "apply_catacombs_corpse_pit",
				refresh_durations = true,
				remove_buff_func = "remove_catacombs_corpse_pit",
				fatigue_type = "vomit_ground",
				time_between_ticks = 2,
				debuff = true,
				max_stacks = 1,
				icon = "convocation_debuff"
			}
		}
	},
	cemetery_plague_floor = {
		buffs = {
			{
				slowdown_buff_name = "cemetery_floor_plague_slowdown",
				name = "plague_floor",
				debuff = true,
				update_func = "update_moving_through_plague",
				fatigue_type = "plague_ground",
				remove_buff_func = "remove_moving_through_plague",
				apply_buff_func = "apply_moving_through_plague",
				refresh_durations = true,
				time_between_dot_damages = 0.75,
				damage_type = "plague_ground",
				max_stacks = 1,
				icon = "troll_vomit_debuff",
				difficulty_damage = {
					easy = {
						1,
						1,
						0,
						0.5,
						1
					},
					normal = {
						1,
						1,
						0,
						1,
						1
					},
					hard = {
						1,
						1,
						0,
						1,
						1
					},
					harder = {
						1,
						1,
						0,
						2,
						1
					},
					hardest = {
						1,
						1,
						0,
						4,
						1
					},
					cataclysm = {
						1,
						1,
						0,
						1,
						1
					},
					cataclysm_2 = {
						1,
						1,
						0,
						2,
						1
					},
					cataclysm_3 = {
						1,
						1,
						0,
						4,
						1
					},
					versus_base = {
						1,
						1,
						0,
						4,
						1
					}
				}
			}
		}
	},
	movement_volume_generic_slowdown = {
		buffs = {
			{
				remove_buff_func = "remove_volume_movement_buff",
				name = "movement_volume_generic_slowdown",
				apply_buff_func = "apply_volume_movement_buff"
			}
		}
	},
	regrowth = {
		buffs = {
			{
				name = "regrowth",
				buff_func = "heal_finesse_damage_on_melee",
				event = "on_hit",
				bonus = 2,
				perks = {
					var_0_0.ninja_healing
				}
			}
		}
	},
	vanguard = {
		buffs = {
			{
				name = "vanguard",
				multiplier = 0.25,
				buff_func = "heal_stagger_targets_on_melee",
				event = "on_stagger",
				perks = {
					var_0_0.tank_healing
				}
			}
		}
	},
	reaper = {
		buffs = {
			{
				max_targets = 5,
				name = "reaper",
				buff_func = "heal_damage_targets_on_melee",
				event = "on_player_damage_dealt",
				bonus = 0.75,
				perks = {
					var_0_0.linesman_healing
				}
			}
		}
	},
	conqueror = {
		buffs = {
			{
				name = "conqueror",
				multiplier = 0.2,
				range = 10,
				buff_func = "heal_other_players_percent_at_range",
				event = "on_healed_consumeable"
			}
		}
	},
	dummy_stagger = {
		buffs = {
			{
				refresh_durations = true,
				name = "dummy_stagger",
				stat_buff = "dummy_stagger",
				max_stacks = 2,
				duration = 1,
				bonus = 1
			}
		}
	},
	linesman_unbalance = {
		buffs = {
			{
				max_display_multiplier = 0.6,
				name = "linesman_unbalance",
				max_stacks = 1,
				display_multiplier = 0.4,
				perks = {
					var_0_0.linesman_stagger_damage
				}
			}
		}
	},
	smiter_unbalance = {
		buffs = {
			{
				max_display_multiplier = 0.4,
				name = "smiter_unbalance",
				display_multiplier = 0.2,
				perks = {
					var_0_0.smiter_stagger_damage
				}
			}
		}
	},
	finesse_unbalance = {
		buffs = {
			{
				max_display_multiplier = 0.4,
				name = "finesse_unbalance",
				display_multiplier = 0.2,
				perks = {
					var_0_0.finesse_stagger_damage
				}
			}
		}
	},
	tank_unbalance = {
		buffs = {
			{
				max_display_multiplier = 0.4,
				name = "tank_unbalance",
				buff_func = "unbalance_debuff_on_stagger",
				event = "on_stagger",
				display_multiplier = 0.2
			}
		}
	},
	tank_unbalance_buff = {
		buffs = {
			{
				refresh_durations = true,
				name = "tank_unbalance_buff",
				stat_buff = "unbalanced_damage_taken",
				max_stacks = 1,
				duration = 2,
				bonus = 0.1
			}
		}
	},
	power_level_unbalance = {
		buffs = {
			{
				max_stacks = 1,
				name = "power_level_unbalance",
				stat_buff = "power_level",
				multiplier = 0.075
			}
		}
	},
	thp_linesman = {
		buffs = {
			{
				description = "thp_linesman_desc",
				name = "thp_linesman",
				display_name = "thp_linesman_name",
				base_value = 1,
				event = "on_player_damage_dealt",
				buff_func = "thp_linesman_func",
				dropoff_divisor = 2,
				max_targets = 10,
				target_dropoff = 5,
				description_values = {},
				perks = {
					var_0_0.linesman_healing
				}
			}
		}
	},
	thp_ninjafencer = {
		buffs = {
			{
				description = "thp_ninjafencer_desc",
				name = "thp_ninjafencer",
				buff_func = "thp_ninjafencer_func",
				event = "on_hit",
				display_name = "thp_ninjafencer_name",
				bonus = 2,
				description_values = {
					{
						value = 0.5
					},
					{
						value = 2
					},
					{
						value = 4
					}
				},
				perks = {
					var_0_0.ninja_healing
				}
			}
		}
	},
	thp_smiter = {
		buffs = {
			{
				description = "thp_smiter_desc",
				name = "thp_smiter",
				buff_func = "thp_smiter_func",
				event = "on_kill",
				display_name = "thp_smiter_name",
				description_values = {},
				perks = {
					var_0_0.smiter_healing
				}
			}
		}
	},
	thp_tank = {
		buffs = {
			{
				description = "thp_tank_desc",
				name = "thp_tank",
				display_name = "thp_tank_name",
				base_value = 1,
				event = "on_stagger",
				buff_func = "thp_tank_stagger_func",
				max_targets = 5,
				push_modifier = 0.5,
				description_values = {
					{
						value = 2
					},
					{
						value = 0.25
					}
				},
				perks = {
					var_0_0.tank_healing
				}
			},
			{
				base_value = 0.25,
				name = "thp_tank_kill",
				buff_func = "thp_tank_kill_func",
				event = "on_kill",
				max_targets = 5,
				perks = {
					var_0_0.tank_healing
				}
			}
		}
	},
	defence_debuff_enemies = {
		buffs = {
			{
				name = "defence_debuff_enemies",
				multiplier = 0.2,
				stat_buff = "damage_taken",
				refresh_durations = true,
				max_stacks = 1,
				duration = 15
			}
		}
	},
	attack_speed_from_proc = {
		buffs = {
			{
				max_stacks = 1,
				name = "attack_speed_from_proc",
				stat_buff = "attack_speed",
				refresh_durations = true
			}
		}
	},
	fatigue_regen_from_proc = {
		buffs = {
			{
				max_stacks = 1,
				name = "fatigue_regen_from_proc",
				stat_buff = "fatigue_regen",
				refresh_durations = true
			}
		}
	},
	increased_melee_damage_from_proc = {
		buffs = {
			{
				max_stacks = 1,
				name = "increased_melee_damage_from_proc",
				stat_buff = "increased_weapon_damage_melee",
				refresh_durations = true
			}
		}
	},
	damage_taken_from_proc = {
		buffs = {
			{
				max_stacks = 1,
				name = "damage_taken_from_proc",
				stat_buff = "damage_taken",
				refresh_durations = true
			}
		}
	},
	enemy_kill_timer = {
		buffs = {
			{
				event = "on_staggered",
				name = "enemy_kill_timer",
				max_stacks = 1,
				buff_func = "add_kill_timer"
			}
		}
	},
	enemy_kill_timer_buff = {
		buffs = {
			{
				fuse_time = 1,
				name = "enemy_kill_timer_buff",
				update_func = "update_kill_timer",
				max_stacks = 1
			}
		}
	},
	mutator_player_dot = {
		buffs = {
			{
				name = "mutator player dot",
				time_between_dot_damages = 10,
				damage_profile = "mutator_player_dot",
				update_func = "apply_dot_damage",
				apply_buff_func = "start_dot_damage",
				update_start_delay = 10
			}
		}
	},
	damage_taken_powerful_elites = {
		buffs = {
			{
				multiplier = 1,
				name = "damage_taken_from_powerful_elites",
				stat_buff = "damage_taken_elites"
			}
		}
	},
	mutator_life_damage_on_hit = {
		buffs = {
			{
				event = "on_hit",
				name = "mutator_life_damage_on_hit",
				bonus = 1,
				buff_func = "damage_attacker"
			}
		}
	},
	mutator_life_health_regeneration = {
		buffs = {
			{
				name = "mutator_life_health_regeneration",
				buff_func = "life_mutator_remove_regen",
				event = "on_damage_taken",
				update_func = "mutator_life_health_regeneration_update",
				apply_buff_func = "mutator_life_health_regeneration_start"
			}
		}
	},
	mutator_life_health_regeneration_stacks = {
		buffs = {
			{
				heal = 1,
				name = "mutator_life_health_regeneration_stacks",
				heal_type = "health_regen",
				time_between_heal = 1,
				update_func = "health_regen_update",
				apply_buff_func = "health_regen_start"
			}
		}
	},
	mutator_life_thorns_poison = {
		buffs = {
			{
				slowdown_buff_name = "cemetery_floor_plague_slowdown",
				name = "mutator_life_thorns_poison",
				refresh_durations = true,
				remove_buff_func = "remove_mutator_life_thorns_poison",
				apply_buff_func = "apply_mutator_life_thorns_poison",
				time_between_dot_damages = 0.01,
				debuff = true,
				max_stacks = 1,
				update_func = "update_mutator_life_thorns_poison",
				difficulty_damage = {
					harder = 6,
					hard = 4,
					normal = 2,
					hardest = 8,
					cataclysm = 12,
					cataclysm_3 = 20,
					cataclysm_2 = 16,
					easy = 2
				}
			}
		}
	},
	mutator_fire_mutator_bomb = {
		buffs = {
			{
				update_func = "update_fire_mutator_bomb",
				name = "mutator_fire_mutator_bomb",
				icon = "buff_icon_mutator_ticking_bomb",
				max_stacks = 1,
				remove_buff_func = "remove_fire_mutator_bomb",
				apply_buff_func = "apply_fire_mutator_bomb"
			}
		}
	},
	mutator_fire_player_dot = {
		buffs = {
			{
				sound_event = "Play_winds_fire_gameplay_fire_damage_player",
				name = "mutator_fire_player_dot",
				time_between_dot_damages = 1,
				update_func = "apply_dot_damage",
				damage_profile = "mutator_player_dot",
				icon = "buff_icon_mutator_ticking_bomb",
				apply_buff_func = "start_dot_damage",
				update_start_delay = 1
			}
		}
	},
	mutator_fire_enemy_dot = {
		activation_sound = "Play_enemy_on_fire_loop",
		buffs = {
			{
				name = "mutator_fire_enemy_dot",
				time_between_dot_damages = 1,
				damage_profile = "mutator_player_dot",
				update_func = "apply_dot_damage",
				apply_buff_func = "start_dot_damage",
				update_start_delay = 1,
				perks = {
					var_0_0.burning
				}
			}
		}
	},
	mutator_metal_blade_dance = {
		buffs = {
			{
				activation_effect = "fx/screenspace_potion_01",
				name = "mutator_metal_blade_dance",
				remove_buff_func = "remove_blade_dance",
				duration = 16,
				icon = "teammate_consumable_icon_defence",
				refresh_durations = true,
				apply_buff_func = "start_blade_dance",
				max_stacks = 1,
				update_func = "update_blade_dance"
			}
		}
	},
	mutator_light_debuff = {
		buffs = {
			{
				name = "mutator_light_debuff",
				icon = "buff_icon_mutator_icon_slayer_curse",
				debuff = true,
				perks = {
					var_0_0.mutator_curse
				}
			},
			{
				multiplier = 0.015,
				name = "death_attack_speed_buff",
				stat_buff = "attack_speed"
			}
		}
	},
	mutator_light_cleansing_curse_buff = {
		buffs = {
			{
				screenspace_effect_name = "fx/screenspace_light_beacon_01",
				name = "mutator_light_cleansing_curse_buff",
				refresh_durations = true,
				duration = 1,
				apply_buff_func = "apply_screenspace_effect"
			}
		}
	},
	mutator_beasts_totem_buff = {
		buffs = {
			{
				wind_mutator = true,
				name = "mutator_beasts_totem_buff",
				stat_buff = "damage_taken",
				refresh_durations = true,
				remove_buff_func = "remove_beasts_totem_buff",
				apply_buff_func = "apply_beasts_totem_buff",
				max_stacks = 1,
				icon = "buff_icon_mutator_ticking_bomb",
				reapply_buff_func = "apply_beasts_totem_buff"
			}
		}
	},
	metal_mutator_gromril_armour = {
		buffs = {
			{
				max_stacks = 10,
				name = "metal_mutator_gromril_armour",
				remove_buff_func = "remove_metal_mutator_gromril_armour",
				icon = "teammate_consumable_icon_defence"
			}
		}
	},
	metal_mutator_damage_boost = {
		activation_effect = "fx/screenspace_potion_01",
		deactivation_sound = "hud_gameplay_stance_deactivate",
		activation_sound = "hud_gameplay_stance_smiter_activate",
		buffs = {
			{
				icon = "icon_wpn_emp_mace_04_t3",
				name = "armor penetration",
				stat_buff = "increased_weapon_damage",
				refresh_durations = true,
				max_stacks = 1,
				duration = 8,
				perks = {
					var_0_0.potion_armor_penetration
				}
			},
			{
				multiplier = 0.5,
				name = "metal_mutator_unbalanced_damage_dealt",
				stat_buff = "unbalanced_damage_dealt",
				max_stacks = 1,
				duration = 8
			}
		}
	},
	mutator_death_attack_speed_player_buff = {
		buffs = {
			{
				activation_effect = "fx/screenspace_potion_03",
				multiplier = 0.25,
				stat_buff = "attack_speed",
				name = "death_attack_speed_buff",
				icon = "buff_icon_mutator_icon_slayer_curse"
			},
			{
				name = "increased_damage",
				multiplier = 0.25,
				stat_buff = "increased_weapon_damage",
				max_stacks = 1,
				icon = "mutator_death_attack_speed_player_buff"
			}
		}
	},
	mutator_shadow_damage_reduction = {
		buffs = {
			{
				wind_mutator = true,
				name = "mutator_shadow_damage_reduction",
				stat_buff = "damage_taken"
			}
		}
	},
	mutator_metal_killing_blow = {
		buffs = {
			{
				num_stacks = 15,
				name = "mutator_metal_killing_blow",
				buff_func = "metal_mutator_stacks_on_hit",
				event = "on_hit",
				bonus = 100,
				breeds = {
					"skaven_slave",
					"skaven_clan_rat",
					"skaven_clan_rat_with_shield",
					"skaven_plague_monk",
					"skaven_pack_master",
					"skaven_gutter_runner",
					"skaven_storm_vermin",
					"skaven_storm_vermin_with_shield",
					"skaven_poison_wind_globadier",
					"chaos_fanatic",
					"chaos_marauder",
					"chaos_marauder_with_shield",
					"chaos_raider",
					"chaos_berzerker",
					"chaos_corruptor_sorcerer",
					"chaos_vortex_sorcerer"
				}
			}
		}
	},
	trinket_reduce_activated_ability_cooldown = {
		description = "trinket_reduce_activated_ability_cooldown_description",
		display_name = "trinket_reduce_activated_ability_cooldown",
		unique_id = "trinket_ability_cooldown",
		icon = "trait_icon_mastercrafted",
		description_values = {
			"multiplier"
		},
		buffs = {
			{
				multiplier = -0.5,
				name = "trinket_reduce_activated_ability_cooldown",
				stat_buff = "activated_cooldown"
			}
		}
	},
	trinket_not_consume_medpack_tier1 = {
		description = "trinket_not_consume_medpack_tier1_description",
		display_name = "trinket_not_consume_medpack_tier1",
		unique_id = "trinket_not_consume_medpack",
		icon = "trinket_not_consume_medpack_tier1",
		description_values = {
			"proc_chance"
		},
		buffs = {
			{
				proc_chance = 0.1,
				name = "not_consume_medpack",
				stat_buff = "not_consume_medpack"
			}
		}
	},
	trinket_not_consume_medpack_tier2 = {
		description = "trinket_not_consume_medpack_tier2_description",
		display_name = "trinket_not_consume_medpack_tier2",
		unique_id = "trinket_not_consume_medpack",
		icon = "trinket_not_consume_medpack_tier2",
		description_values = {
			"proc_chance"
		},
		buffs = {
			{
				proc_chance = 0.15,
				name = "not_consume_medpack",
				stat_buff = "not_consume_medpack"
			}
		}
	},
	trinket_not_consume_medpack_tier3 = {
		description = "trinket_not_consume_medpack_tier3_description",
		display_name = "trinket_not_consume_medpack_tier3",
		unique_id = "trinket_not_consume_medpack",
		icon = "trinket_not_consume_medpack_tier3",
		description_values = {
			"proc_chance"
		},
		buffs = {
			{
				proc_chance = 0.2,
				name = "not_consume_medpack",
				stat_buff = "not_consume_medpack"
			}
		}
	},
	trinket_not_consume_potion_tier1 = {
		description = "trinket_not_consume_potion_tier1_description",
		display_name = "trinket_not_consume_potion_tier1",
		unique_id = "trinket_not_consume_potion",
		icon = "trinket_not_consume_potion_tier1",
		description_values = {
			"proc_chance"
		},
		buffs = {
			{
				proc_chance = 0.15,
				name = "not_consume_potion",
				stat_buff = "not_consume_potion"
			}
		}
	},
	trinket_not_consume_potion_tier2 = {
		description = "trinket_not_consume_potion_tier2_description",
		display_name = "trinket_not_consume_potion_tier2",
		unique_id = "trinket_not_consume_potion",
		icon = "trinket_not_consume_potion_tier2",
		description_values = {
			"proc_chance"
		},
		buffs = {
			{
				proc_chance = 0.2,
				name = "not_consume_potion",
				stat_buff = "not_consume_potion"
			}
		}
	},
	trinket_not_consume_potion_tier3 = {
		description = "trinket_not_consume_potion_tier3_description",
		display_name = "trinket_not_consume_potion_tier3",
		unique_id = "trinket_not_consume_potion",
		icon = "trinket_not_consume_potion_tier3",
		description_values = {
			"proc_chance"
		},
		buffs = {
			{
				proc_chance = 0.25,
				name = "not_consume_potion",
				stat_buff = "not_consume_potion"
			}
		}
	},
	trinket_not_consume_grenade_tier1 = {
		description = "trinket_not_consume_grenade_tier1_description",
		display_name = "trinket_not_consume_grenade_tier1",
		unique_id = "trinket_not_consume_grenade",
		icon = "trinket_not_consume_grenade_tier1",
		description_values = {
			"proc_chance"
		},
		buffs = {
			{
				proc_chance = 0.15,
				name = "not_consume_grenade",
				stat_buff = "not_consume_grenade"
			}
		}
	},
	trinket_not_consume_grenade_tier2 = {
		description = "trinket_not_consume_grenade_tier2_description",
		display_name = "trinket_not_consume_grenade_tier2",
		unique_id = "trinket_not_consume_grenade",
		icon = "trinket_not_consume_grenade_tier2",
		description_values = {
			"proc_chance"
		},
		buffs = {
			{
				proc_chance = 0.2,
				name = "not_consume_grenade",
				stat_buff = "not_consume_grenade"
			}
		}
	},
	trinket_not_consume_grenade_tier3 = {
		description = "trinket_not_consume_grenade_tier3_description",
		display_name = "trinket_not_consume_grenade_tier3",
		unique_id = "trinket_not_consume_grenade",
		icon = "trinket_not_consume_grenade_tier3",
		description_values = {
			"proc_chance"
		},
		buffs = {
			{
				proc_chance = 0.25,
				name = "not_consume_grenade",
				stat_buff = "not_consume_grenade"
			}
		}
	},
	trinket_no_interruption_revive = {
		description = "trinket_no_interruption_revive_description",
		display_name = "trinket_no_interruption_revive",
		unique_id = "trinket_no_interruption_revive",
		icon = "trinket_no_interruption_revive_tier1",
		buffs = {
			{
				name = "no_interruption_revive"
			}
		}
	},
	trinket_no_interruption_bandage = {
		description = "trinket_no_interruption_bandage_description",
		display_name = "trinket_no_interruption_bandage",
		unique_id = "trinket_no_interruption_bandage",
		icon = "trinket_no_interruption_bandage_tier1",
		buffs = {
			{
				name = "no_interruption_bandage"
			}
		}
	},
	trinket_protection_poison_wind_tier1 = {
		description = "trinket_protection_poison_wind_tier1_description",
		display_name = "trinket_protection_poison_wind_tier1",
		unique_id = "trinket_protection_poison_wind",
		icon = "trinket_protection_poison_wind_tier1",
		description_values = {
			"multiplier"
		},
		buffs = {
			{
				multiplier = -0.2,
				name = "protection_poison_wind",
				stat_buff = "protection_poison_wind"
			}
		}
	},
	trinket_protection_poison_wind_tier2 = {
		description = "trinket_protection_poison_wind_tier2_description",
		display_name = "trinket_protection_poison_wind_tier2",
		unique_id = "trinket_protection_poison_wind",
		icon = "trinket_protection_poison_wind_tier2",
		description_values = {
			"multiplier"
		},
		buffs = {
			{
				multiplier = -0.4,
				name = "protection_poison_wind",
				stat_buff = "protection_poison_wind"
			}
		}
	},
	trinket_protection_poison_wind_tier3 = {
		description = "trinket_protection_poison_wind_tier3_description",
		display_name = "trinket_protection_poison_wind_tier3",
		unique_id = "trinket_protection_poison_wind",
		icon = "trinket_protection_poison_wind_tier3",
		description_values = {
			"multiplier"
		},
		buffs = {
			{
				multiplier = -0.6,
				name = "protection_poison_wind",
				stat_buff = "protection_poison_wind"
			}
		}
	},
	trinket_protection_gutter_runner_tier1 = {
		description = "trinket_protection_gutter_runner_tier1_description",
		display_name = "trinket_protection_gutter_runner_tier1",
		unique_id = "trinket_protection_gutter_runner",
		icon = "trinket_protection_gutter_runner_tier1",
		description_values = {
			"multiplier"
		},
		buffs = {
			{
				multiplier = -0.2,
				name = "protection_gutter_runner",
				stat_buff = "protection_gutter_runner"
			}
		}
	},
	trinket_protection_gutter_runner_tier2 = {
		description = "trinket_protection_gutter_runner_tier2_description",
		display_name = "trinket_protection_gutter_runner_tier2",
		unique_id = "trinket_protection_gutter_runner",
		icon = "trinket_protection_gutter_runner_tier2",
		description_values = {
			"multiplier"
		},
		buffs = {
			{
				multiplier = -0.4,
				name = "protection_gutter_runner",
				stat_buff = "protection_gutter_runner"
			}
		}
	},
	trinket_protection_gutter_runner_tier3 = {
		description = "trinket_protection_gutter_runner_tier3_description",
		display_name = "trinket_protection_gutter_runner_tier3",
		unique_id = "trinket_protection_gutter_runner",
		icon = "trinket_protection_gutter_runner_tier3",
		description_values = {
			"multiplier"
		},
		buffs = {
			{
				multiplier = -0.6,
				name = "protection_gutter_runner",
				stat_buff = "protection_gutter_runner"
			}
		}
	},
	trinket_protection_ratling_gunner_tier1 = {
		description = "trinket_protection_ratling_gunner_tier1_description",
		display_name = "trinket_protection_ratling_gunner_tier1",
		unique_id = "trinket_protection_ratling_gunner",
		icon = "trinket_protection_ratling_gunner_tier1",
		description_values = {
			"multiplier"
		},
		buffs = {
			{
				multiplier = -0.2,
				name = "protection_ratling_gunner",
				stat_buff = "protection_ratling_gunner"
			}
		}
	},
	trinket_protection_ratling_gunner_tier2 = {
		description = "trinket_protection_ratling_gunner_tier2_description",
		display_name = "trinket_protection_ratling_gunner_tier2",
		unique_id = "trinket_protection_ratling_gunner",
		icon = "trinket_protection_ratling_gunner_tier2",
		description_values = {
			"multiplier"
		},
		buffs = {
			{
				multiplier = -0.4,
				name = "protection_ratling_gunner",
				stat_buff = "protection_ratling_gunner"
			}
		}
	},
	trinket_protection_ratling_gunner_tier3 = {
		description = "trinket_protection_ratling_gunner_tier3_description",
		display_name = "trinket_protection_ratling_gunner_tier3",
		unique_id = "trinket_protection_ratling_gunner",
		icon = "trinket_protection_ratling_gunner_tier3",
		description_values = {
			"multiplier"
		},
		buffs = {
			{
				multiplier = -0.6,
				name = "protection_ratling_gunner",
				stat_buff = "protection_ratling_gunner"
			}
		}
	},
	trinket_protection_pack_master_tier1 = {
		description = "trinket_protection_pack_master_tier1_description",
		display_name = "trinket_protection_pack_master_tier1",
		unique_id = "trinket_protection_pack_master",
		icon = "trinket_protection_pack_master_tier1",
		description_values = {
			"multiplier"
		},
		buffs = {
			{
				multiplier = -0.2,
				name = "protection_pack_master",
				stat_buff = "protection_pack_master"
			}
		}
	},
	trinket_protection_pack_master_tier2 = {
		description = "trinket_protection_pack_master_tier2_description",
		display_name = "trinket_protection_pack_master_tier2",
		unique_id = "trinket_protection_pack_master",
		icon = "trinket_protection_pack_master_tier2",
		description_values = {
			"multiplier"
		},
		buffs = {
			{
				multiplier = -0.4,
				name = "protection_pack_master",
				stat_buff = "protection_pack_master"
			}
		}
	},
	trinket_protection_pack_master_tier3 = {
		description = "trinket_protection_pack_master_tier3_description",
		display_name = "trinket_protection_pack_master_tier3",
		unique_id = "trinket_protection_pack_master",
		icon = "trinket_protection_pack_master_tier3",
		description_values = {
			"multiplier"
		},
		buffs = {
			{
				multiplier = -0.6,
				name = "protection_pack_master",
				stat_buff = "protection_pack_master"
			}
		}
	},
	trinket_potion_spread_area_tier1 = {
		description = "trinket_potion_spread_area_tier1_description",
		display_name = "trinket_potion_spread_area_tier1",
		unique_id = "trinket_potion_spread_area",
		icon = "trinket_potion_spread_area_tier1",
		description_values = {
			"distance"
		},
		buffs = {
			{
				name = "potion_spread_area_tier1",
				distance = TrinketSpreadDistance
			}
		}
	},
	trinket_potion_spread_area_tier2 = {
		description = "trinket_potion_spread_area_tier2_description",
		display_name = "trinket_potion_spread_area_tier2",
		unique_id = "trinket_potion_spread_area",
		icon = "trinket_potion_spread_area_tier2",
		description_values = {
			"distance"
		},
		buffs = {
			{
				name = "potion_spread_area_tier2",
				distance = TrinketSpreadDistance
			}
		}
	},
	trinket_potion_spread_area_tier3 = {
		description = "trinket_potion_spread_area_tier3_description",
		display_name = "trinket_potion_spread_area_tier3",
		unique_id = "trinket_potion_spread_area",
		icon = "trinket_potion_spread_area_tier3",
		description_values = {
			"distance"
		},
		buffs = {
			{
				name = "potion_spread_area_tier3",
				distance = TrinketSpreadDistance
			}
		}
	},
	trinket_faster_revive_promo = {
		description = "trinket_faster_revive_tier1_description",
		display_name = "trinket_faster_revive_tier1",
		unique_id = "trinket_faster_revive",
		icon = "trinket_faster_revive_tier1",
		description_values = {
			"multiplier"
		},
		buffs = {
			{
				multiplier = -0.15,
				name = "faster_revive",
				stat_buff = "faster_revive"
			}
		}
	},
	trinket_faster_revive_tier1 = {
		description = "trinket_faster_revive_tier1_description",
		display_name = "trinket_faster_revive_tier1",
		unique_id = "trinket_faster_revive",
		icon = "trinket_faster_revive_tier1",
		description_values = {
			"multiplier"
		},
		buffs = {
			{
				multiplier = -0.3,
				name = "faster_revive",
				stat_buff = "faster_revive"
			}
		}
	},
	trinket_faster_revive_tier2 = {
		description = "trinket_faster_revive_tier2_description",
		display_name = "trinket_faster_revive_tier2",
		unique_id = "trinket_faster_revive",
		icon = "trinket_faster_revive_tier2",
		description_values = {
			"multiplier"
		},
		buffs = {
			{
				multiplier = -0.4,
				name = "faster_revive",
				stat_buff = "faster_revive"
			}
		}
	},
	trinket_faster_revive_tier3 = {
		description = "trinket_faster_revive_tier3_description",
		display_name = "trinket_faster_revive_tier3",
		unique_id = "trinket_faster_revive",
		icon = "trinket_faster_revive_tier3",
		description_values = {
			"multiplier"
		},
		buffs = {
			{
				multiplier = -0.5,
				name = "faster_revive",
				stat_buff = "faster_revive"
			}
		}
	},
	trinket_increase_luck_promo = {
		description = "trinket_increase_luck_tier1_description",
		display_name = "trinket_increase_luck_tier1",
		unique_id = "trinket_increase_luck",
		icon = "trinket_increase_luck_tier1",
		description_values = {
			"multiplier"
		},
		buffs = {
			{
				multiplier = 0.1,
				name = "increase_luck",
				stat_buff = "increase_luck"
			}
		}
	},
	trinket_increase_luck_tier1 = {
		description = "trinket_increase_luck_tier1_description",
		display_name = "trinket_increase_luck_tier1",
		unique_id = "trinket_increase_luck",
		icon = "trinket_increase_luck_tier1",
		description_values = {
			"multiplier"
		},
		buffs = {
			{
				multiplier = 0.25,
				name = "increase_luck",
				stat_buff = "increase_luck"
			}
		}
	},
	trinket_increase_luck_tier2 = {
		description = "trinket_increase_luck_tier2_description",
		display_name = "trinket_increase_luck_tier2",
		unique_id = "trinket_increase_luck",
		icon = "trinket_increase_luck_tier2",
		description_values = {
			"multiplier"
		},
		buffs = {
			{
				multiplier = 0.5,
				name = "increase_luck",
				stat_buff = "increase_luck"
			}
		}
	},
	trinket_increase_luck_tier3 = {
		description = "trinket_increase_luck_tier3_description",
		display_name = "trinket_increase_luck_tier3",
		unique_id = "trinket_increase_luck",
		icon = "trinket_increase_luck_tier3",
		description_values = {
			"multiplier"
		},
		buffs = {
			{
				multiplier = 1,
				name = "increase_luck",
				stat_buff = "increase_luck"
			}
		}
	},
	trinket_hp_increase_kd_tier1 = {
		description = "trinket_hp_increase_kd_tier1_description",
		display_name = "trinket_hp_increase_kd_tier1",
		unique_id = "trinket_hp_increase_kd",
		icon = "trinket_hp_increase_kd_tier1",
		description_values = {
			"multiplier"
		},
		buffs = {
			{
				multiplier = -0.2,
				name = "hp_increase_kd",
				stat_buff = "damage_taken_kd"
			}
		}
	},
	trinket_hp_increase_kd_tier2 = {
		description = "trinket_hp_increase_kd_tier2_description",
		display_name = "trinket_hp_increase_kd_tier2",
		unique_id = "trinket_hp_increase_kd",
		icon = "trinket_hp_increase_kd_tier2",
		description_values = {
			"multiplier"
		},
		buffs = {
			{
				multiplier = -0.3,
				name = "hp_increase_kd",
				stat_buff = "damage_taken_kd"
			}
		}
	},
	trinket_hp_increase_kd_tier3 = {
		description = "trinket_hp_increase_kd_tier3_description",
		display_name = "trinket_hp_increase_kd_tier3",
		unique_id = "trinket_hp_increase_kd",
		icon = "trinket_hp_increase_kd_tier3",
		description_values = {
			"multiplier"
		},
		buffs = {
			{
				multiplier = -0.4,
				name = "hp_increase_kd",
				stat_buff = "damage_taken_kd"
			}
		}
	},
	trinket_increased_movement_speed_tier1 = {
		description = "trinket_increased_movement_speed_tier1_description",
		display_name = "trinket_increased_movement_speed_tier1",
		unique_id = "trinket_increased_movement_speed",
		icon = "trinket_increased_movement_speed_tier1",
		description_values = {
			"multiplier"
		},
		buffs = {
			{
				name = "movement_speed",
				multiplier = 1.02,
				remove_buff_func = "remove_movement_buff",
				apply_buff_func = "apply_movement_buff",
				path_to_movement_setting_to_modify = {
					"move_speed"
				}
			}
		}
	},
	trinket_increased_movement_speed_tier2 = {
		description = "trinket_increased_movement_speed_tier2_description",
		display_name = "trinket_increased_movement_speed_tier2",
		unique_id = "trinket_increased_movement_speed",
		icon = "trinket_increased_movement_speed_tier2",
		description_values = {
			"multiplier"
		},
		buffs = {
			{
				name = "movement_speed",
				multiplier = 1.04,
				remove_buff_func = "remove_movement_buff",
				apply_buff_func = "apply_movement_buff",
				path_to_movement_setting_to_modify = {
					"move_speed"
				}
			}
		}
	},
	trinket_increased_movement_speed_tier3 = {
		description = "trinket_increased_movement_speed_tier3_description",
		display_name = "trinket_increased_movement_speed_tier3",
		unique_id = "trinket_increased_movement_speed",
		icon = "trinket_increased_movement_speed_tier3",
		description_values = {
			"multiplier"
		},
		buffs = {
			{
				name = "movement_speed",
				multiplier = 1.06,
				remove_buff_func = "remove_movement_buff",
				apply_buff_func = "apply_movement_buff",
				path_to_movement_setting_to_modify = {
					"move_speed"
				}
			}
		}
	},
	trinket_reduce_grimoire_penalty = {
		description = "trinket_reduce_grimoire_penalty_description",
		display_name = "trinket_reduce_grimoire_penalty",
		unique_id = "trinket_reduce_grimoire_penalty",
		icon = "trinket_reduce_grimoire_penalty_tier1",
		description_values = {
			"multiplier"
		},
		buffs = {
			{
				multiplier = -0.33,
				name = "curse_protection",
				stat_buff = "curse_protection"
			}
		}
	},
	trinket_grenade_radius_tier1 = {
		description = "trinket_grenade_radius_tier1_description",
		display_name = "trinket_grenade_radius_tier1",
		unique_id = "trinket_grenade_radius",
		icon = "trinket_grenade_radius_tier1",
		description_values = {
			"multiplier"
		},
		buffs = {
			{
				multiplier = 0.4,
				name = "grenade_radius",
				stat_buff = "grenade_radius"
			}
		}
	},
	trinket_grenade_radius_tier2 = {
		description = "trinket_grenade_radius_tier2_description",
		display_name = "trinket_grenade_radius_tier2",
		unique_id = "trinket_grenade_radius",
		icon = "trinket_grenade_radius_tier2",
		description_values = {
			"multiplier"
		},
		buffs = {
			{
				multiplier = 0.5,
				name = "grenade_radius",
				stat_buff = "grenade_radius"
			}
		}
	},
	trinket_grenade_radius_tier3 = {
		description = "trinket_grenade_radius_tier3_description",
		display_name = "trinket_grenade_radius_tier3",
		unique_id = "trinket_grenade_radius",
		icon = "trinket_grenade_radius_tier3",
		description_values = {
			"multiplier"
		},
		buffs = {
			{
				multiplier = 0.6,
				name = "grenade_radius",
				stat_buff = "grenade_radius"
			}
		}
	},
	trinket_faster_respawn_tier1 = {
		description = "trinket_faster_respawn_tier1_description",
		display_name = "trinket_faster_respawn_tier1",
		unique_id = "trinket_faster_respawn",
		icon = "trinket_faster_respawn_tier1",
		description_values = {
			"multiplier"
		},
		buffs = {
			{
				multiplier = -0.25,
				name = "faster_respawn",
				stat_buff = "faster_respawn"
			}
		}
	},
	trinket_faster_respawn_tier2 = {
		description = "trinket_faster_respawn_tier2_description",
		display_name = "trinket_faster_respawn_tier2",
		unique_id = "trinket_faster_respawn",
		icon = "trinket_faster_respawn_tier2",
		description_values = {
			"multiplier"
		},
		buffs = {
			{
				multiplier = -0.5,
				name = "faster_respawn",
				stat_buff = "faster_respawn"
			}
		}
	},
	trinket_shared_damage = {
		description = "trinket_shared_damage_description",
		display_name = "trinket_shared_damage",
		unique_id = "trinket_shared_damage",
		icon = "trinket_shared_damage_tier3",
		buffs = {
			{
				name = "shared_health_pool"
			}
		}
	},
	trinket_increase_luck_halloween = {
		description = "trinket_increase_luck_tier1_description",
		display_name = "trinket_increase_luck_tier1",
		unique_id = "trinket_increase_luck",
		icon = "trinket_increase_luck_halloween",
		description_values = {
			"multiplier"
		},
		buffs = {
			{
				multiplier = 0.91,
				name = "increase_luck",
				stat_buff = "increase_luck"
			}
		}
	},
	warpfire_thrower_ground_base = {
		buffs = {
			{
				refresh_durations = true,
				name = "stormfiend_warpfire_ground",
				remove_buff_func = "remove_moving_through_warpfire",
				apply_buff_func = "apply_moving_through_warpfire",
				time_between_dot_damages = 0.75,
				damage_type = "warpfire_ground",
				max_stacks = 1,
				update_func = "update_moving_through_warpfire",
				difficulty_damage = {
					easy = {
						1,
						1,
						0,
						5.5,
						1
					},
					normal = {
						1,
						1,
						0,
						6.5,
						1
					},
					hard = {
						1,
						1,
						0,
						7.5,
						1
					},
					harder = {
						1,
						1,
						0,
						8.5,
						1
					},
					hardest = {
						1,
						1,
						0,
						9.5,
						1
					},
					cataclysm = {
						1,
						1,
						0,
						7,
						1
					},
					cataclysm_2 = {
						1,
						1,
						0,
						8,
						1
					},
					cataclysm_3 = {
						1,
						1,
						0,
						9,
						1
					},
					versus_base = {
						1,
						1,
						0,
						6.5,
						1
					}
				},
				perks = {
					var_0_0.burning_warpfire
				}
			}
		}
	},
	warpfire_thrower_face_base = {
		buffs = {
			{
				slowdown_buff_name = "warpfire_thrower_fire_slowdown",
				name = "warpfire_thrower_base",
				debuff = true,
				update_func = "update_warpfirethrower_in_face",
				fatigue_type = "warpfire_ground",
				remove_buff_func = "remove_warpfirethrower_in_face",
				apply_buff_func = "apply_warpfirethrower_in_face",
				push_speed = 15,
				duration = 0.3,
				time_between_dot_damages = 0.75,
				damage_type = "warpfire_ground",
				max_stacks = 1,
				icon = "troll_vomit_debuff",
				difficulty_damage = {
					easy = {
						3,
						1,
						0,
						6.5,
						1
					},
					normal = {
						3,
						1,
						0,
						6.5,
						2
					},
					hard = {
						4,
						2,
						0,
						7.5,
						2
					},
					harder = {
						5,
						3,
						0,
						8.5,
						4
					},
					hardest = {
						7.5,
						4,
						0,
						9.5,
						5
					},
					cataclysm = {
						4,
						2,
						0,
						7,
						3
					},
					cataclysm_2 = {
						5,
						3,
						0,
						8,
						3
					},
					cataclysm_3 = {
						7.5,
						4,
						0,
						9,
						4
					},
					versus_base = {
						3,
						3,
						3,
						3,
						3
					}
				},
				perks = {
					var_0_0.burning_warpfire
				}
			}
		}
	},
	warpfire_thrower_face_base_mutator = {
		buffs = {
			{
				slowdown_buff_name = "warpfire_thrower_fire_slowdown",
				name = "warpfire_thrower_base",
				debuff = true,
				update_func = "update_warpfirethrower_in_face",
				fatigue_type = "warpfire_ground",
				remove_buff_func = "remove_warpfirethrower_in_face",
				apply_buff_func = "apply_warpfirethrower_in_face",
				push_speed = 30,
				duration = 0.3,
				time_between_dot_damages = 0.75,
				damage_type = "warpfire_ground",
				max_stacks = 1,
				icon = "troll_vomit_debuff",
				difficulty_damage = {
					easy = {
						2,
						1,
						0,
						5.5,
						1
					},
					normal = {
						10,
						1,
						0,
						6.5,
						1
					},
					hard = {
						12,
						2,
						0,
						7.5,
						2
					},
					harder = {
						15,
						3,
						0,
						8.5,
						3
					},
					hardest = {
						20,
						4,
						0,
						9.5,
						4
					},
					cataclysm = {
						12,
						2,
						0,
						7,
						2
					},
					cataclysm_2 = {
						15,
						3,
						0,
						8,
						3
					},
					cataclysm_3 = {
						20,
						4,
						0,
						9,
						4
					},
					versus_base = {
						3,
						3,
						3,
						3,
						3
					}
				},
				perks = {
					var_0_0.burning_warpfire
				}
			}
		}
	},
	warpfire_thrower_fire_slowdown = {
		buffs = {
			{
				update_func = "update_action_lerp_movement_buff",
				multiplier = 0.5,
				name = "decrease_speed_bile_troll",
				refresh_durations = true,
				remove_buff_func = "remove_action_lerp_movement_buff",
				apply_buff_func = "apply_action_lerp_movement_buff",
				remove_buff_name = "planted_return_to_normal_movement",
				lerp_time = 0.1,
				max_stacks = 1,
				duration = 1,
				path_to_movement_setting_to_modify = {
					"move_speed"
				}
			},
			{
				update_func = "update_charging_action_lerp_movement_buff",
				multiplier = 0.5,
				name = "decrease_crouch_speed_bile_troll",
				refresh_durations = true,
				remove_buff_func = "remove_action_lerp_movement_buff",
				apply_buff_func = "apply_action_lerp_movement_buff",
				remove_buff_name = "planted_return_to_normal_crouch_movement",
				lerp_time = 0.1,
				max_stacks = 1,
				duration = 1,
				path_to_movement_setting_to_modify = {
					"crouch_move_speed"
				}
			},
			{
				update_func = "update_charging_action_lerp_movement_buff",
				multiplier = 0.5,
				name = "decrease_walk_speed_bile_troll",
				refresh_durations = true,
				remove_buff_func = "remove_action_lerp_movement_buff",
				apply_buff_func = "apply_action_lerp_movement_buff",
				remove_buff_name = "planted_return_to_normal_walk_movement",
				lerp_time = 0.1,
				max_stacks = 1,
				duration = 1,
				path_to_movement_setting_to_modify = {
					"walk_move_speed"
				}
			},
			{
				name = "decrease_jump_speed_bile_troll",
				multiplier = 0.6,
				duration = 1,
				max_stacks = 1,
				remove_buff_func = "remove_movement_buff",
				apply_buff_func = "apply_movement_buff",
				refresh_durations = true,
				path_to_movement_setting_to_modify = {
					"jump",
					"initial_vertical_speed"
				}
			},
			{
				name = "decrease_dodge_speed_bile_troll",
				multiplier = 0.8,
				duration = 1,
				max_stacks = 1,
				remove_buff_func = "remove_movement_buff",
				apply_buff_func = "apply_movement_buff",
				refresh_durations = true,
				path_to_movement_setting_to_modify = {
					"dodging",
					"speed_modifier"
				}
			},
			{
				name = "decrease_dodge_distance_bile_troll",
				multiplier = 0.8,
				duration = 1,
				max_stacks = 1,
				remove_buff_func = "remove_movement_buff",
				apply_buff_func = "apply_movement_buff",
				refresh_durations = true,
				path_to_movement_setting_to_modify = {
					"dodging",
					"distance_modifier"
				}
			}
		}
	},
	plague_wave_ground_base = {
		buffs = {
			{
				fatigue_type = "vomit_ground",
				name = "troll_bile_ground",
				icon = "troll_vomit_debuff",
				refresh_durations = true,
				remove_buff_func = "remove_moving_through_vomit",
				apply_buff_func = "apply_moving_through_vomit",
				time_between_dot_damages = 0.75,
				damage_type = "vomit_ground",
				max_stacks = 1,
				update_func = "update_moving_through_vomit",
				difficulty_damage = {
					easy = {
						1,
						1,
						0,
						0.5,
						1
					},
					normal = {
						1,
						1,
						0,
						1,
						1
					},
					hard = {
						1,
						1,
						0,
						1,
						1
					},
					harder = {
						1,
						1,
						0,
						2,
						1
					},
					hardest = {
						1,
						1,
						0,
						4,
						1
					},
					cataclysm = {
						1,
						1,
						0,
						1,
						1
					},
					cataclysm_2 = {
						1,
						1,
						0,
						2,
						1
					},
					cataclysm_3 = {
						1,
						1,
						0,
						4,
						1
					},
					versus_base = {
						1,
						1,
						0,
						1,
						1
					}
				}
			}
		}
	},
	plague_wave_ground_slowdown = {
		buffs = {
			{
				update_func = "update_action_lerp_movement_buff",
				multiplier = 0.5,
				name = "decrease_speed_plague_wave",
				refresh_durations = true,
				remove_buff_func = "remove_action_lerp_movement_buff",
				apply_buff_func = "apply_action_lerp_movement_buff",
				remove_buff_name = "planted_return_to_normal_movement",
				lerp_time = 0.1,
				max_stacks = 1,
				duration = 1,
				path_to_movement_setting_to_modify = {
					"move_speed"
				}
			},
			{
				update_func = "update_charging_action_lerp_movement_buff",
				multiplier = 0.5,
				name = "decrease_crouch_speed_plague_wavel",
				refresh_durations = true,
				remove_buff_func = "remove_action_lerp_movement_buff",
				apply_buff_func = "apply_action_lerp_movement_buff",
				remove_buff_name = "planted_return_to_normal_crouch_movement",
				lerp_time = 0.1,
				max_stacks = 1,
				duration = 1,
				path_to_movement_setting_to_modify = {
					"crouch_move_speed"
				}
			},
			{
				update_func = "update_charging_action_lerp_movement_buff",
				multiplier = 0.5,
				name = "decrease_walk_speed_plague_wave",
				refresh_durations = true,
				remove_buff_func = "remove_action_lerp_movement_buff",
				apply_buff_func = "apply_action_lerp_movement_buff",
				remove_buff_name = "planted_return_to_normal_walk_movement",
				lerp_time = 0.1,
				max_stacks = 1,
				duration = 1,
				path_to_movement_setting_to_modify = {
					"walk_move_speed"
				}
			},
			{
				name = "decrease_jump_speed_plague_wave",
				multiplier = 0.6,
				duration = 1,
				max_stacks = 1,
				remove_buff_func = "remove_movement_buff",
				apply_buff_func = "apply_movement_buff",
				refresh_durations = true,
				path_to_movement_setting_to_modify = {
					"jump",
					"initial_vertical_speed"
				}
			},
			{
				name = "decrease_dodge_speed_plague_wave",
				multiplier = 0.8,
				duration = 1,
				max_stacks = 1,
				remove_buff_func = "remove_movement_buff",
				apply_buff_func = "apply_movement_buff",
				refresh_durations = true,
				path_to_movement_setting_to_modify = {
					"dodging",
					"speed_modifier"
				}
			},
			{
				name = "decrease_dodge_distance_plague_wave",
				multiplier = 0.8,
				duration = 1,
				max_stacks = 1,
				remove_buff_func = "remove_movement_buff",
				apply_buff_func = "apply_movement_buff",
				refresh_durations = true,
				path_to_movement_setting_to_modify = {
					"dodging",
					"distance_modifier"
				}
			}
		}
	},
	bile_troll_vomit_ground_base = {
		buffs = {
			{
				slowdown_buff_name = "bile_troll_vomit_ground_slowdown",
				name = "troll_bile_ground",
				debuff = true,
				update_func = "update_moving_through_vomit",
				fatigue_type = "vomit_ground",
				remove_buff_func = "remove_moving_through_vomit",
				apply_buff_func = "apply_moving_through_vomit",
				refresh_durations = true,
				time_between_dot_damages = 0.75,
				damage_type = "vomit_ground",
				max_stacks = 1,
				icon = "troll_vomit_debuff",
				difficulty_damage = {
					easy = {
						1,
						1,
						0,
						0.5,
						1
					},
					normal = {
						1,
						1,
						0,
						1,
						1
					},
					hard = {
						1,
						1,
						0,
						1,
						1
					},
					harder = {
						1,
						1,
						0,
						2,
						1
					},
					hardest = {
						1,
						1,
						0,
						4,
						1
					},
					cataclysm = {
						1,
						1,
						0,
						4,
						1
					},
					cataclysm_2 = {
						1,
						1,
						0,
						4,
						1
					},
					cataclysm_3 = {
						1,
						1,
						0,
						4,
						1
					},
					versus_base = {
						1,
						1,
						0,
						1,
						1
					}
				}
			}
		}
	},
	bile_troll_vomit_ground_downed = {
		buffs = {
			{
				slowdown_buff_name = "lesser_bile_troll_vomit_ground_slowdown",
				name = "troll_bile_ground",
				debuff = true,
				update_func = "update_moving_through_vomit",
				fatigue_type = "vomit_ground",
				remove_buff_func = "remove_moving_through_vomit",
				apply_buff_func = "apply_moving_through_vomit",
				refresh_durations = true,
				time_between_dot_damages = 0.75,
				damage_type = "vomit_ground",
				max_stacks = 1,
				icon = "troll_vomit_debuff",
				difficulty_damage = {
					easy = {
						1,
						1,
						0,
						0.5,
						1
					},
					normal = {
						1,
						1,
						0,
						1,
						1
					},
					hard = {
						1,
						1,
						0,
						1,
						1
					},
					harder = {
						1,
						1,
						0,
						2,
						1
					},
					hardest = {
						1,
						1,
						0,
						4,
						1
					},
					cataclysm = {
						1,
						1,
						0,
						4,
						1
					},
					cataclysm_2 = {
						1,
						1,
						0,
						4,
						1
					},
					cataclysm_3 = {
						1,
						1,
						0,
						4,
						1
					},
					versus_base = {
						1,
						1,
						0,
						1,
						1
					}
				}
			}
		}
	},
	corpse_pit_slowdown = {
		buffs = {
			{
				update_func = "update_action_lerp_movement_buff",
				multiplier = 0.5,
				name = "decrease_speed_corpse_pit",
				refresh_durations = true,
				remove_buff_func = "remove_action_lerp_movement_buff",
				apply_buff_func = "apply_action_lerp_movement_buff",
				remove_buff_name = "planted_return_to_normal_movement",
				lerp_time = 0.1,
				max_stacks = 1,
				duration = 2,
				path_to_movement_setting_to_modify = {
					"move_speed"
				}
			},
			{
				update_func = "update_charging_action_lerp_movement_buff",
				multiplier = 0.5,
				name = "decrease_crouch_speed_corpse_pit",
				refresh_durations = true,
				remove_buff_func = "remove_action_lerp_movement_buff",
				apply_buff_func = "apply_action_lerp_movement_buff",
				remove_buff_name = "planted_return_to_normal_crouch_movement",
				lerp_time = 0.1,
				max_stacks = 1,
				duration = 2,
				path_to_movement_setting_to_modify = {
					"crouch_move_speed"
				}
			},
			{
				update_func = "update_charging_action_lerp_movement_buff",
				multiplier = 0.5,
				name = "decrease_walk_speed_corpse_pit",
				refresh_durations = true,
				remove_buff_func = "remove_action_lerp_movement_buff",
				apply_buff_func = "apply_action_lerp_movement_buff",
				remove_buff_name = "planted_return_to_normal_walk_movement",
				lerp_time = 0.1,
				max_stacks = 1,
				duration = 2,
				path_to_movement_setting_to_modify = {
					"walk_move_speed"
				}
			},
			{
				name = "decrease_jump_speed_corpse_pit",
				multiplier = 0.5,
				duration = 2,
				max_stacks = 1,
				remove_buff_func = "remove_movement_buff",
				apply_buff_func = "apply_movement_buff",
				refresh_durations = true,
				path_to_movement_setting_to_modify = {
					"jump",
					"initial_vertical_speed"
				}
			},
			{
				name = "decrease_dodge_speed_corpse_pit",
				multiplier = 0.6,
				duration = 2,
				max_stacks = 1,
				remove_buff_func = "remove_movement_buff",
				apply_buff_func = "apply_movement_buff",
				refresh_durations = true,
				path_to_movement_setting_to_modify = {
					"dodging",
					"speed_modifier"
				}
			},
			{
				name = "decrease_dodge_distance_corpse_pit",
				multiplier = 0.6,
				duration = 2,
				max_stacks = 1,
				remove_buff_func = "remove_movement_buff",
				apply_buff_func = "apply_movement_buff",
				refresh_durations = true,
				path_to_movement_setting_to_modify = {
					"dodging",
					"distance_modifier"
				}
			}
		}
	},
	mutator_life_poison = {
		buffs = {
			{
				max_stacks = 1,
				name = "mutator_life_poison",
				apply_buff_func = "apply_mutator_life_poison_buff",
				refresh_durations = true
			},
			{
				name = "decrease_speed_mutator_life_poison",
				multiplier = 0.5,
				lerp_time = 0.1,
				max_stacks = 1,
				remove_buff_func = "remove_movement_buff",
				apply_buff_func = "apply_movement_buff",
				refresh_durations = true,
				path_to_movement_setting_to_modify = {
					"move_speed"
				}
			},
			{
				apply_buff_func = "apply_action_lerp_movement_buff",
				multiplier = 0.5,
				name = "decrease_crouch_speed_mutator_life_poison",
				refresh_durations = true,
				remove_buff_func = "remove_action_lerp_movement_buff",
				remove_buff_name = "planted_return_to_normal_crouch_movement",
				lerp_time = 0.1,
				max_stacks = 1,
				update_func = "update_charging_action_lerp_movement_buff",
				path_to_movement_setting_to_modify = {
					"crouch_move_speed"
				}
			},
			{
				apply_buff_func = "apply_action_lerp_movement_buff",
				multiplier = 0.5,
				name = "decrease_walk_speed_mutator_life_poison",
				refresh_durations = true,
				remove_buff_func = "remove_action_lerp_movement_buff",
				remove_buff_name = "planted_return_to_normal_walk_movement",
				lerp_time = 0.1,
				max_stacks = 1,
				update_func = "update_charging_action_lerp_movement_buff",
				path_to_movement_setting_to_modify = {
					"walk_move_speed"
				}
			},
			{
				name = "decrease_jump_speed_mutator_life_poison",
				multiplier = 0.5,
				refresh_durations = true,
				max_stacks = 1,
				remove_buff_func = "remove_movement_buff",
				apply_buff_func = "apply_movement_buff",
				path_to_movement_setting_to_modify = {
					"jump",
					"initial_vertical_speed"
				}
			},
			{
				name = "decrease_dodge_speed_mutator_life_poison",
				multiplier = 0.6,
				refresh_durations = true,
				max_stacks = 1,
				remove_buff_func = "remove_movement_buff",
				apply_buff_func = "apply_movement_buff",
				path_to_movement_setting_to_modify = {
					"dodging",
					"speed_modifier"
				}
			},
			{
				name = "decrease_dodge_distance_mutator_life_poison",
				multiplier = 0.6,
				refresh_durations = true,
				max_stacks = 1,
				remove_buff_func = "remove_movement_buff",
				apply_buff_func = "apply_movement_buff",
				path_to_movement_setting_to_modify = {
					"dodging",
					"distance_modifier"
				}
			}
		}
	},
	cemetery_floor_plague_slowdown = {
		buffs = {
			{
				update_func = "update_action_lerp_movement_buff",
				multiplier = 0.75,
				name = "decrease_speed_cemetery_floor",
				refresh_durations = true,
				remove_buff_func = "remove_action_lerp_movement_buff",
				apply_buff_func = "apply_action_lerp_movement_buff",
				remove_buff_name = "planted_return_to_normal_movement",
				lerp_time = 0.1,
				max_stacks = 1,
				duration = 2,
				path_to_movement_setting_to_modify = {
					"move_speed"
				}
			},
			{
				update_func = "update_charging_action_lerp_movement_buff",
				multiplier = 0.75,
				name = "decrease_crouch_speed_cemetery_floor",
				refresh_durations = true,
				remove_buff_func = "remove_action_lerp_movement_buff",
				apply_buff_func = "apply_action_lerp_movement_buff",
				remove_buff_name = "planted_return_to_normal_crouch_movement",
				lerp_time = 0.1,
				max_stacks = 1,
				duration = 2,
				path_to_movement_setting_to_modify = {
					"crouch_move_speed"
				}
			},
			{
				update_func = "update_charging_action_lerp_movement_buff",
				multiplier = 0.75,
				name = "decrease_walk_speed_cemetery_floor",
				refresh_durations = true,
				remove_buff_func = "remove_action_lerp_movement_buff",
				apply_buff_func = "apply_action_lerp_movement_buff",
				remove_buff_name = "planted_return_to_normal_walk_movement",
				lerp_time = 0.1,
				max_stacks = 1,
				duration = 2,
				path_to_movement_setting_to_modify = {
					"walk_move_speed"
				}
			},
			{
				name = "decrease_jump_speed_cemetery_floor",
				multiplier = 0.75,
				duration = 2,
				max_stacks = 1,
				remove_buff_func = "remove_movement_buff",
				apply_buff_func = "apply_movement_buff",
				refresh_durations = true,
				path_to_movement_setting_to_modify = {
					"jump",
					"initial_vertical_speed"
				}
			},
			{
				name = "decrease_dodge_speed_cemetery_floor",
				multiplier = 0.8,
				duration = 2,
				max_stacks = 1,
				remove_buff_func = "remove_movement_buff",
				apply_buff_func = "apply_movement_buff",
				refresh_durations = true,
				path_to_movement_setting_to_modify = {
					"dodging",
					"speed_modifier"
				}
			},
			{
				name = "decrease_dodge_distance_cemetery_floor",
				multiplier = 0.8,
				duration = 2,
				max_stacks = 1,
				remove_buff_func = "remove_movement_buff",
				apply_buff_func = "apply_movement_buff",
				refresh_durations = true,
				path_to_movement_setting_to_modify = {
					"dodging",
					"distance_modifier"
				}
			}
		}
	},
	bile_troll_vomit_ground_slowdown = {
		buffs = {
			{
				update_func = "update_action_lerp_movement_buff",
				multiplier = 0.75,
				name = "decrease_speed_bile_troll",
				refresh_durations = true,
				remove_buff_func = "remove_action_lerp_movement_buff",
				apply_buff_func = "apply_action_lerp_movement_buff",
				remove_buff_name = "planted_return_to_normal_movement",
				lerp_time = 0.1,
				max_stacks = 1,
				duration = 1,
				path_to_movement_setting_to_modify = {
					"move_speed"
				}
			},
			{
				update_func = "update_charging_action_lerp_movement_buff",
				multiplier = 0.75,
				name = "decrease_crouch_speed_bile_troll",
				refresh_durations = true,
				remove_buff_func = "remove_action_lerp_movement_buff",
				apply_buff_func = "apply_action_lerp_movement_buff",
				remove_buff_name = "planted_return_to_normal_crouch_movement",
				lerp_time = 0.1,
				max_stacks = 1,
				duration = 1,
				path_to_movement_setting_to_modify = {
					"crouch_move_speed"
				}
			},
			{
				update_func = "update_charging_action_lerp_movement_buff",
				multiplier = 0.75,
				name = "decrease_walk_speed_bile_troll",
				refresh_durations = true,
				remove_buff_func = "remove_action_lerp_movement_buff",
				apply_buff_func = "apply_action_lerp_movement_buff",
				remove_buff_name = "planted_return_to_normal_walk_movement",
				lerp_time = 0.1,
				max_stacks = 1,
				duration = 1,
				path_to_movement_setting_to_modify = {
					"walk_move_speed"
				}
			},
			{
				name = "decrease_jump_speed_bile_troll",
				multiplier = 0.75,
				duration = 1,
				max_stacks = 1,
				remove_buff_func = "remove_movement_buff",
				apply_buff_func = "apply_movement_buff",
				refresh_durations = true,
				path_to_movement_setting_to_modify = {
					"jump",
					"initial_vertical_speed"
				}
			},
			{
				name = "decrease_dodge_speed_bile_troll",
				multiplier = 0.8,
				duration = 1,
				max_stacks = 1,
				remove_buff_func = "remove_movement_buff",
				apply_buff_func = "apply_movement_buff",
				refresh_durations = true,
				path_to_movement_setting_to_modify = {
					"dodging",
					"speed_modifier"
				}
			},
			{
				name = "decrease_dodge_distance_bile_troll",
				multiplier = 0.8,
				duration = 1,
				max_stacks = 1,
				remove_buff_func = "remove_movement_buff",
				apply_buff_func = "apply_movement_buff",
				refresh_durations = true,
				path_to_movement_setting_to_modify = {
					"dodging",
					"distance_modifier"
				}
			}
		}
	},
	lesser_bile_troll_vomit_ground_slowdown = {
		buffs = {
			{
				update_func = "update_action_lerp_movement_buff",
				multiplier = 0.95,
				name = "decrease_speed_bile_troll",
				refresh_durations = true,
				remove_buff_func = "remove_action_lerp_movement_buff",
				apply_buff_func = "apply_action_lerp_movement_buff",
				remove_buff_name = "planted_return_to_normal_movement",
				lerp_time = 0.1,
				max_stacks = 1,
				duration = 1,
				path_to_movement_setting_to_modify = {
					"move_speed"
				}
			},
			{
				update_func = "update_charging_action_lerp_movement_buff",
				multiplier = 0.95,
				name = "decrease_crouch_speed_bile_troll",
				refresh_durations = true,
				remove_buff_func = "remove_action_lerp_movement_buff",
				apply_buff_func = "apply_action_lerp_movement_buff",
				remove_buff_name = "planted_return_to_normal_crouch_movement",
				lerp_time = 0.1,
				max_stacks = 1,
				duration = 1,
				path_to_movement_setting_to_modify = {
					"crouch_move_speed"
				}
			},
			{
				update_func = "update_charging_action_lerp_movement_buff",
				multiplier = 0.95,
				name = "decrease_walk_speed_bile_troll",
				refresh_durations = true,
				remove_buff_func = "remove_action_lerp_movement_buff",
				apply_buff_func = "apply_action_lerp_movement_buff",
				remove_buff_name = "planted_return_to_normal_walk_movement",
				lerp_time = 0.1,
				max_stacks = 1,
				duration = 1,
				path_to_movement_setting_to_modify = {
					"walk_move_speed"
				}
			},
			{
				name = "decrease_jump_speed_bile_troll",
				multiplier = 0.95,
				duration = 1,
				max_stacks = 1,
				remove_buff_func = "remove_movement_buff",
				apply_buff_func = "apply_movement_buff",
				refresh_durations = true,
				path_to_movement_setting_to_modify = {
					"jump",
					"initial_vertical_speed"
				}
			}
		}
	},
	plague_wave_face_base = {
		buffs = {
			{
				slowdown_buff_name = "plague_wave_face_slowdown",
				name = "plague_wave_face",
				icon = "troll_vomit_debuff",
				apply_buff_func = "apply_plague_wave_in_face",
				remove_buff_func = "remove_plague_wave_in_face",
				fatigue_type = "vomit_face",
				duration = 2,
				refresh_durations = true,
				time_between_dot_damages = 0.65,
				damage_type = "plague_face",
				max_stacks = 1,
				update_func = "update_vomit_in_face",
				push_speed = 6,
				difficulty_damage = {
					easy = {
						1,
						1,
						0,
						0.5,
						1
					},
					normal = {
						1,
						1,
						0,
						2,
						1
					},
					hard = {
						1,
						1,
						0,
						3,
						1
					},
					harder = {
						1,
						1,
						0,
						4,
						1
					},
					hardest = {
						1,
						1,
						0,
						6,
						1
					},
					cataclysm = {
						1,
						1,
						0,
						6,
						1
					},
					cataclysm_2 = {
						1,
						1,
						0,
						8,
						1
					},
					cataclysm_3 = {
						1,
						1,
						0,
						10,
						1
					},
					versus_base = {
						1,
						1,
						0,
						2,
						1
					}
				}
			},
			{
				name = "decrease_jump_speed",
				multiplier = 0.7,
				duration = 2,
				remove_buff_func = "remove_movement_buff",
				apply_buff_func = "apply_movement_buff",
				path_to_movement_setting_to_modify = {
					"jump",
					"initial_vertical_speed"
				}
			},
			{
				name = "decrease_dodge_speed",
				multiplier = 0.7,
				duration = 2,
				remove_buff_func = "remove_movement_buff",
				apply_buff_func = "apply_movement_buff",
				path_to_movement_setting_to_modify = {
					"dodging",
					"speed_modifier"
				}
			},
			{
				name = "decrease_dodge_distance",
				multiplier = 0.7,
				duration = 2,
				remove_buff_func = "remove_movement_buff",
				apply_buff_func = "apply_movement_buff",
				path_to_movement_setting_to_modify = {
					"dodging",
					"distance_modifier"
				}
			}
		}
	},
	vermintide_face_base = {
		buffs = {
			{
				fatigue_type = "vomit_face",
				name = "plague_wave_face",
				icon = "troll_vomit_debuff",
				duration = 3.5,
				remove_buff_func = "remove_vermintide_in_face",
				apply_buff_func = "apply_vermintide_in_face",
				refresh_durations = true,
				time_between_dot_damages = 0.65,
				damage_type = "plague_face",
				max_stacks = 1,
				update_func = "update_vermintide_in_face",
				push_speed = 15,
				difficulty_damage = {
					easy = {
						1,
						1,
						0,
						0.5,
						1
					},
					normal = {
						1,
						1,
						0,
						1,
						1
					},
					hard = {
						1,
						1,
						0,
						1,
						1
					},
					harder = {
						1,
						1,
						0,
						2,
						1
					},
					hardest = {
						1,
						1,
						0,
						4,
						1
					},
					cataclysm = {
						1,
						1,
						0,
						1,
						1
					},
					cataclysm_2 = {
						1,
						1,
						0,
						2,
						1
					},
					cataclysm_3 = {
						1,
						1,
						0,
						4,
						1
					},
					versus_base = {
						1,
						1,
						0,
						1,
						1
					}
				}
			},
			{
				name = "decrease_jump_speed",
				multiplier = 0.7,
				duration = 3.5,
				remove_buff_func = "remove_movement_buff",
				apply_buff_func = "apply_movement_buff",
				path_to_movement_setting_to_modify = {
					"jump",
					"initial_vertical_speed"
				}
			},
			{
				name = "decrease_dodge_speed",
				multiplier = 0.7,
				duration = 3.5,
				remove_buff_func = "remove_movement_buff",
				apply_buff_func = "apply_movement_buff",
				path_to_movement_setting_to_modify = {
					"dodging",
					"speed_modifier"
				}
			},
			{
				name = "decrease_dodge_distance",
				multiplier = 0.7,
				duration = 3.5,
				remove_buff_func = "remove_movement_buff",
				apply_buff_func = "apply_movement_buff",
				path_to_movement_setting_to_modify = {
					"dodging",
					"distance_modifier"
				}
			}
		}
	},
	bile_troll_vomit_face_base = {
		buffs = {
			{
				slowdown_buff_name = "bile_troll_vomit_face_slowdown",
				name = "troll_bile_face",
				debuff = true,
				update_func = "update_vomit_in_face",
				fatigue_type = "vomit_face",
				remove_buff_func = "remove_vomit_in_face",
				apply_buff_func = "apply_vomit_in_face",
				duration = 5,
				time_between_dot_damages = 0.65,
				refresh_durations = true,
				damage_type = "vomit_face",
				max_stacks = 1,
				icon = "troll_vomit_debuff",
				push_speed = 6,
				difficulty_damage = {
					easy = {
						1,
						1,
						0,
						0.5,
						1
					},
					normal = {
						1,
						1,
						0,
						1,
						1
					},
					hard = {
						1,
						1,
						0,
						1,
						1
					},
					harder = {
						1,
						1,
						0,
						2,
						1
					},
					hardest = {
						1,
						1,
						0,
						4,
						1
					},
					cataclysm = {
						1,
						1,
						0,
						4,
						1
					},
					cataclysm_2 = {
						1,
						1,
						0,
						4,
						1
					},
					cataclysm_3 = {
						1,
						1,
						0,
						4,
						1
					},
					versus_base = {
						1,
						1,
						0,
						1,
						1
					}
				}
			},
			{
				name = "decrease_jump_speed",
				multiplier = 0.3,
				duration = 7,
				remove_buff_func = "remove_movement_buff",
				apply_buff_func = "apply_movement_buff",
				path_to_movement_setting_to_modify = {
					"jump",
					"initial_vertical_speed"
				}
			},
			{
				name = "decrease_dodge_speed",
				multiplier = 0.3,
				duration = 7,
				remove_buff_func = "remove_movement_buff",
				apply_buff_func = "apply_movement_buff",
				path_to_movement_setting_to_modify = {
					"dodging",
					"speed_modifier"
				}
			},
			{
				name = "decrease_dodge_distance",
				multiplier = 0.3,
				duration = 7,
				remove_buff_func = "remove_movement_buff",
				apply_buff_func = "apply_movement_buff",
				path_to_movement_setting_to_modify = {
					"dodging",
					"distance_modifier"
				}
			}
		}
	},
	bile_troll_vomit_face_slowdown = {
		buffs = {
			{
				update_func = "update_action_lerp_movement_buff",
				multiplier = 0.3,
				name = "decrease_speed",
				refresh_durations = true,
				remove_buff_func = "remove_action_lerp_movement_buff",
				apply_buff_func = "apply_action_lerp_movement_buff",
				remove_buff_name = "planted_return_to_normal_movement",
				lerp_time = 0.1,
				max_stacks = 1,
				duration = 0.5,
				path_to_movement_setting_to_modify = {
					"move_speed"
				}
			},
			{
				update_func = "update_charging_action_lerp_movement_buff",
				multiplier = 0.3,
				name = "decrease_crouch_speed",
				refresh_durations = true,
				remove_buff_func = "remove_action_lerp_movement_buff",
				apply_buff_func = "apply_action_lerp_movement_buff",
				remove_buff_name = "planted_return_to_normal_crouch_movement",
				lerp_time = 0.1,
				max_stacks = 1,
				duration = 0.5,
				path_to_movement_setting_to_modify = {
					"crouch_move_speed"
				}
			},
			{
				update_func = "update_charging_action_lerp_movement_buff",
				multiplier = 0.3,
				name = "decrease_walk_speed",
				refresh_durations = true,
				remove_buff_func = "remove_action_lerp_movement_buff",
				apply_buff_func = "apply_action_lerp_movement_buff",
				remove_buff_name = "planted_return_to_normal_walk_movement",
				lerp_time = 0.1,
				max_stacks = 1,
				duration = 0.5,
				path_to_movement_setting_to_modify = {
					"walk_move_speed"
				}
			}
		}
	},
	plague_wave_face_slowdown = {
		buffs = {
			{
				update_func = "update_action_lerp_movement_buff",
				multiplier = 0.8,
				name = "decrease_speed",
				refresh_durations = true,
				remove_buff_func = "remove_action_lerp_movement_buff",
				apply_buff_func = "apply_action_lerp_movement_buff",
				remove_buff_name = "planted_return_to_normal_movement",
				lerp_time = 0.1,
				max_stacks = 1,
				duration = 0.5,
				path_to_movement_setting_to_modify = {
					"move_speed"
				}
			},
			{
				update_func = "update_charging_action_lerp_movement_buff",
				multiplier = 0.8,
				name = "decrease_crouch_speed",
				refresh_durations = true,
				remove_buff_func = "remove_action_lerp_movement_buff",
				apply_buff_func = "apply_action_lerp_movement_buff",
				remove_buff_name = "planted_return_to_normal_crouch_movement",
				lerp_time = 0.1,
				max_stacks = 1,
				duration = 0.5,
				path_to_movement_setting_to_modify = {
					"crouch_move_speed"
				}
			},
			{
				update_func = "update_charging_action_lerp_movement_buff",
				multiplier = 0.8,
				name = "decrease_walk_speed",
				refresh_durations = true,
				remove_buff_func = "remove_action_lerp_movement_buff",
				apply_buff_func = "apply_action_lerp_movement_buff",
				remove_buff_name = "planted_return_to_normal_walk_movement",
				lerp_time = 0.1,
				max_stacks = 1,
				duration = 0.5,
				path_to_movement_setting_to_modify = {
					"walk_move_speed"
				}
			}
		}
	},
	vortex_base = {
		buffs = {
			{
				slowdown_buff_name = "vortex_slowdown",
				name = "vortex",
				icon = "troll_vomit_debuff",
				apply_buff_func = "apply_vortex",
				duration = 2,
				remove_buff_func = "remove_vortex",
				fatigue_type = "vomit_face",
				refresh_durations = true,
				time_between_dot_damages = 0.65,
				damage_type = "vomit_face",
				max_stacks = 1,
				update_func = "update_vortex",
				difficulty_damage = {
					easy = {
						1,
						1,
						0,
						2,
						1
					},
					normal = {
						1,
						1,
						0,
						3,
						1
					},
					hard = {
						1,
						1,
						0,
						5,
						1
					},
					harder = {
						1,
						1,
						0,
						8,
						1
					},
					hardest = {
						1,
						1,
						0,
						16,
						1
					},
					cataclysm = {
						1,
						1,
						0,
						16,
						1
					},
					cataclysm_2 = {
						1,
						1,
						0,
						16,
						1
					},
					cataclysm_3 = {
						1,
						1,
						0,
						16,
						1
					},
					versus_base = {
						1,
						1,
						0,
						3,
						1
					}
				}
			},
			{
				name = "decrease_jump_speed",
				multiplier = 0.8,
				duration = 1,
				remove_buff_func = "remove_movement_buff",
				apply_buff_func = "apply_movement_buff",
				path_to_movement_setting_to_modify = {
					"jump",
					"initial_vertical_speed"
				}
			},
			{
				name = "decrease_dodge_speed",
				multiplier = 0.8,
				duration = 1,
				remove_buff_func = "remove_movement_buff",
				apply_buff_func = "apply_movement_buff",
				path_to_movement_setting_to_modify = {
					"dodging",
					"speed_modifier"
				}
			},
			{
				name = "decrease_dodge_distance",
				multiplier = 0.8,
				duration = 1,
				remove_buff_func = "remove_movement_buff",
				apply_buff_func = "apply_movement_buff",
				path_to_movement_setting_to_modify = {
					"dodging",
					"distance_modifier"
				}
			}
		}
	},
	vortex_slowdown = {
		buffs = {
			{
				update_func = "update_action_lerp_movement_buff",
				multiplier = 0.9,
				name = "decrease_speed",
				refresh_durations = true,
				remove_buff_func = "remove_action_lerp_movement_buff",
				apply_buff_func = "apply_action_lerp_movement_buff",
				remove_buff_name = "planted_return_to_normal_movement",
				lerp_time = 0.1,
				max_stacks = 1,
				duration = 0.5,
				path_to_movement_setting_to_modify = {
					"move_speed"
				}
			},
			{
				update_func = "update_charging_action_lerp_movement_buff",
				multiplier = 0.9,
				name = "decrease_crouch_speed",
				refresh_durations = true,
				remove_buff_func = "remove_action_lerp_movement_buff",
				apply_buff_func = "apply_action_lerp_movement_buff",
				remove_buff_name = "planted_return_to_normal_crouch_movement",
				lerp_time = 0.1,
				max_stacks = 1,
				duration = 0.5,
				path_to_movement_setting_to_modify = {
					"crouch_move_speed"
				}
			},
			{
				update_func = "update_charging_action_lerp_movement_buff",
				multiplier = 0.9,
				name = "decrease_walk_speed",
				refresh_durations = true,
				remove_buff_func = "remove_action_lerp_movement_buff",
				apply_buff_func = "apply_action_lerp_movement_buff",
				remove_buff_name = "planted_return_to_normal_walk_movement",
				lerp_time = 0.1,
				max_stacks = 1,
				duration = 0.5,
				path_to_movement_setting_to_modify = {
					"walk_move_speed"
				}
			}
		}
	},
	stormfiend_warpfire_ground_base = {
		buffs = {
			{
				slowdown_buff_name = "bile_troll_vomit_ground_slowdown",
				name = "stormfiend_warpfire_ground",
				refresh_durations = true,
				remove_buff_func = "remove_moving_through_warpfire",
				apply_buff_func = "apply_moving_through_warpfire",
				time_between_dot_damages = 0.5,
				damage_type = "warpfire_ground",
				max_stacks = 1,
				update_func = "update_moving_through_warpfire",
				difficulty_damage = {
					easy = {
						1,
						1,
						0,
						1.5,
						1
					},
					normal = {
						2,
						2,
						0,
						2.5,
						3
					},
					hard = {
						4,
						3,
						0,
						2.5,
						4
					},
					harder = {
						6,
						5,
						0,
						4.5,
						5
					},
					hardest = {
						8,
						8,
						0,
						8.5,
						6
					},
					cataclysm = {
						4,
						3,
						0,
						8.5,
						4
					},
					cataclysm_2 = {
						6,
						5,
						0,
						8.5,
						5
					},
					cataclysm_3 = {
						8,
						8,
						0,
						8.5,
						6
					},
					versus_base = {
						2,
						2,
						0,
						2.5,
						3
					}
				},
				perks = {
					var_0_0.burning_warpfire
				}
			}
		}
	},
	stormfiend_warpfire_face_base = {
		buffs = {
			{
				name = "stormfiend_warpfire_face",
				update_func = "update_warpfire_in_face",
				refresh_durations = true,
				remove_buff_func = "remove_warpfire_in_face",
				apply_buff_func = "apply_warpfire_in_face",
				time_between_dot_damages = 0.65,
				damage_type = "warpfire_face",
				max_stacks = 1,
				duration = 3,
				push_speed = 10,
				difficulty_damage = {
					easy = {
						1,
						1,
						0,
						2,
						1
					},
					normal = {
						3,
						2,
						0,
						1.5,
						2
					},
					hard = {
						4,
						2,
						0,
						2,
						2
					},
					harder = {
						5,
						3,
						0,
						3,
						3
					},
					hardest = {
						6,
						4,
						0,
						5,
						4
					},
					cataclysm = {
						4,
						2,
						0,
						5,
						2
					},
					cataclysm_2 = {
						5,
						3,
						0,
						5,
						3
					},
					cataclysm_3 = {
						6,
						4,
						0,
						5,
						1
					},
					versus_base = {
						3,
						2,
						0,
						1.5,
						2
					}
				},
				perks = {
					var_0_0.burning_warpfire
				}
			}
		}
	},
	increase_damage_recieved_while_burning = {
		buffs = {
			{
				multiplier = 0.5,
				name = "increase_damage_recieved_while_burning",
				stat_buff = "damage_taken",
				max_stacks = 1,
				refresh_durations = true
			}
		}
	},
	chaos_zombie_explosion = {
		buffs = {
			{
				refresh_durations = false,
				name = "chaos_zombie_explosion",
				stat_buff = "damage_taken",
				update_func = "update_chaos_zombie_explosion_in_face",
				multiplier = 0.1,
				remove_buff_func = "remove_chaos_zombie_explosion_in_face",
				apply_buff_func = "apply_chaos_zombie_explosion_in_face",
				fatigue_type = "vomit_face",
				damage_type = "vomit_face",
				max_stacks = 5,
				duration = 5
			}
		}
	},
	ring_attackspeed_0001_buff = {
		buffs = {
			{
				description = "Attack Speed",
				multiplier = 0.03,
				stat_buff = "attack_speed",
				apply_on = "equip",
				name = "ring_attackspeed_0001_buff"
			}
		}
	},
	ring_attackspeed_0002_buff = {
		buffs = {
			{
				description = "Attack Speed",
				multiplier = 0.05,
				stat_buff = "attack_speed",
				apply_on = "equip",
				name = "ring_attackspeed_0002_buff"
			}
		}
	},
	ring_attackspeed_0003_buff = {
		buffs = {
			{
				description = "Attack Speed",
				multiplier = 0.07,
				stat_buff = "attack_speed",
				apply_on = "equip",
				name = "ring_attackspeed_0003_buff"
			}
		}
	},
	necklace_stamina_0001_buff = {
		buffs = {
			{
				description = "Stamina",
				name = "necklace_stamina_0001_buff",
				stat_buff = "max_fatigue",
				apply_on = "equip",
				bonus = 1
			}
		}
	},
	necklace_stamina_0002_buff = {
		buffs = {
			{
				description = "Stamina",
				name = "necklace_stamina_0002_buff",
				stat_buff = "max_fatigue",
				apply_on = "equip",
				bonus = 2
			}
		}
	},
	necklace_stamina_0003_buff = {
		buffs = {
			{
				description = "Stamina",
				name = "necklace_stamina_0003_buff",
				stat_buff = "max_fatigue",
				apply_on = "equip",
				bonus = 4
			}
		}
	},
	necklace_health_0001_buff = {
		buffs = {
			{
				description = "Health",
				multiplier = 0.1,
				stat_buff = "max_health",
				apply_on = "equip",
				name = "necklace_health_0001_buff"
			}
		}
	},
	necklace_health_0002_buff = {
		buffs = {
			{
				description = "Health",
				multiplier = 0.15,
				stat_buff = "max_health",
				apply_on = "equip",
				name = "necklace_health_0002_buff"
			}
		}
	},
	necklace_health_0003_buff = {
		buffs = {
			{
				description = "Health",
				multiplier = 0.25,
				stat_buff = "max_health",
				apply_on = "equip",
				name = "necklace_health_0003_buff"
			}
		}
	},
	weapon_trait_uninterruptible = {
		buffs = {
			{
				name = "weapon_trait_uninterruptible",
				perks = {
					var_0_0.uninterruptible
				}
			}
		}
	},
	weapon_trait_riposte = {
		buffs = {
			{
				name = "weapon_trait_riposte",
				perks = {
					var_0_0.uninterruptible
				}
			}
		}
	},
	weapon_trait_backstab = {
		buffs = {
			{
				multiplier = 0.5,
				name = "weapon_trait_backstab",
				stat_buff = "backstab_multiplier"
			}
		}
	},
	weapon_trait_bloodlust = {
		buffs = {
			{
				event = "on_kill",
				name = "weapon_trait_bloodlust",
				bonus = 1,
				buff_func = "heal"
			}
		}
	},
	weapon_trait_improved_push = {
		buffs = {
			{
				name = "push_increase"
			}
		}
	},
	weapon_trait_scavenge = {
		buffs = {
			{
				event = "on_hit",
				name = "weapon_trait_scavenge_trigger",
				bonus = 1,
				buff_func = "replenish_ammo_on_headshot_ranged"
			},
			{
				multiplier = -0.5,
				name = "weapon_trait_scavenge_buff",
				stat_buff = "total_ammo"
			}
		}
	},
	twitch_mutator_buff_splitting_enemies = {
		buffs = {
			{
				icon = "mutator_icon_splitting_enemies",
				duration = 30,
				name = "twitch_mutator_buff_splitting_enemies",
				duration_modifier_func = function(arg_192_0, arg_192_1, arg_192_2)
					return arg_192_2 * TwitchSettings.mutator_duration_multiplier
				end
			}
		}
	},
	twitch_mutator_buff_leash = {
		buffs = {
			{
				icon = "mutator_icon_leash",
				duration = 30,
				name = "twitch_mutator_buff_leash",
				duration_modifier_func = function(arg_193_0, arg_193_1, arg_193_2)
					return arg_193_2 * TwitchSettings.mutator_duration_multiplier
				end
			}
		}
	},
	twitch_mutator_buff_slayers_curse = {
		buffs = {
			{
				icon = "mutator_icon_slayer_curse",
				duration = 30,
				name = "twitch_mutator_buff_slayers_curse",
				duration_modifier_func = function(arg_194_0, arg_194_1, arg_194_2)
					return arg_194_2 * TwitchSettings.mutator_duration_multiplier
				end
			}
		}
	},
	twitch_mutator_buff_shared_health_pool = {
		buffs = {
			{
				icon = "icon_deed_normal_01",
				duration = 30,
				name = "twitch_mutator_buff_shared_health_pool",
				duration_modifier_func = function(arg_195_0, arg_195_1, arg_195_2)
					return arg_195_2 * TwitchSettings.mutator_duration_multiplier
				end
			}
		}
	},
	twitch_mutator_buff_bloodlust = {
		buffs = {
			{
				icon = "bardin_slayer_activated_ability",
				duration = 30,
				name = "twitch_mutator_buff_bloodlust",
				duration_modifier_func = function(arg_196_0, arg_196_1, arg_196_2)
					return arg_196_2 * TwitchSettings.mutator_duration_multiplier
				end
			}
		}
	},
	twitch_mutator_buff_ticking_bomb = {
		buffs = {
			{
				icon = "mutator_icon_ticking_bomb",
				duration = 30,
				name = "twitch_mutator_buff_ticking_bomb",
				duration_modifier_func = function(arg_197_0, arg_197_1, arg_197_2)
					return arg_197_2 * TwitchSettings.mutator_duration_multiplier
				end
			}
		}
	},
	twitch_mutator_buff_lightning_strike = {
		buffs = {
			{
				icon = "mutator_icon_heavens_lightning",
				duration = 33,
				name = "twitch_mutator_buff_lightning_strike",
				duration_modifier_func = function(arg_198_0, arg_198_1, arg_198_2)
					return arg_198_2 * TwitchSettings.mutator_duration_multiplier
				end
			}
		}
	},
	twitch_mutator_buff_chasing_spirits = {
		buffs = {
			{
				icon = "mutator_icon_death_spirits",
				duration = 25,
				name = "twitch_mutator_buff_chasing_spirits",
				duration_modifier_func = function(arg_199_0, arg_199_1, arg_199_2)
					return arg_199_2 * TwitchSettings.mutator_duration_multiplier
				end
			}
		}
	},
	twitch_mutator_buff_flames = {
		buffs = {
			{
				icon = "mutator_icon_fire_burn",
				duration = 30,
				name = "twitch_mutator_buff_flames",
				duration_modifier_func = function(arg_200_0, arg_200_1, arg_200_2)
					return arg_200_2 * TwitchSettings.mutator_duration_multiplier
				end
			}
		}
	},
	bloodlust = {
		buffs = {
			{
				icon = "bardin_slayer_activated_ability",
				name = "bardin_slayer_frenzy",
				stat_buff = "attack_speed",
				multiplier = 0.15,
				max_stacks = 3,
				duration = 6,
				refresh_durations = true
			},
			{
				remove_buff_func = "remove_movement_buff",
				name = "bardin_slayer_frenzy_movement",
				multiplier = 1.2,
				max_stacks = 3,
				duration = 6,
				apply_buff_func = "apply_movement_buff",
				refresh_durations = true,
				path_to_movement_setting_to_modify = {
					"move_speed"
				}
			}
		}
	},
	bloodlust_debuff = {
		buffs = {
			{
				name = "bloodlust_debuff",
				time_between_dot_damages = 1,
				icon = "troll_vomit_debuff",
				damage_profile = "bloodlust_debuff",
				update_func = "apply_dot_damage",
				apply_buff_func = "start_dot_damage",
				update_start_delay = 1
			}
		}
	},
	twitch_vote_buff_root = {
		buffs = {
			{
				icon = "troll_vomit_debuff",
				multiplier = 0.001,
				update_func = "update_action_lerp_movement_buff",
				name = "twitch_vote_buff_root",
				remove_buff_func = "remove_action_lerp_movement_buff",
				apply_buff_func = "apply_action_lerp_movement_buff",
				remove_buff_name = "planted_return_to_normal_movement",
				lerp_time = 0.1,
				duration = 10,
				path_to_movement_setting_to_modify = {
					"move_speed"
				},
				perks = {
					var_0_0.root
				}
			}
		}
	},
	twitch_vote_buff_fatigue_loss = {
		buffs = {
			{
				name = "twitch_vote_buff_fatigue_loss",
				multiplier = -1,
				stat_buff = "fatigue_regen",
				duration = 15,
				max_stacks = 1,
				refresh_durations = true,
				icon = "troll_vomit_debuff"
			}
		}
	},
	twitch_vote_buff_hemmoraghe = {
		buffs = {
			{
				update_func = "update_speed_scaled_dot_buff",
				name = "twitch_vote_buff_hemmoraghe",
				damage = 3,
				icon = "troll_vomit_debuff",
				remove_buff_func = "remove_speed_scaled_dot_buff",
				apply_buff_func = "apply_speed_scaled_dot_buff",
				damage_frequency = 0.25,
				damage_type = "bleed",
				duration = 15
			}
		}
	},
	twitch_vote_buff_invisibility = {
		buffs = {
			{
				update_func = "update_twitch_invisibility_buff",
				name = "twitch_vote_buff_invisibility",
				duration = 20,
				icon = "kerillian_shade_passive_improved",
				remove_buff_func = "remove_twitch_invisibility_buff",
				apply_buff_func = "apply_twitch_invisibility_buff"
			}
		}
	},
	twitch_vote_buff_critical_strikes = {
		buffs = {
			{
				refresh_durations = true,
				name = "twitch_vote_buff_critical_strikes",
				icon = "victor_bountyhunter_passive",
				max_stacks = 1,
				duration = 20,
				perks = {
					var_0_0.guaranteed_crit
				}
			}
		}
	},
	twitch_vote_buff_infinite_bombs = {
		buffs = {
			{
				update_func = "update_twitch_infinite_bombs",
				name = "twitch_vote_buff_invisibility",
				duration = 10,
				icon = "bardin_ranger_increased_melee_damage_on_no_ammo",
				remove_buff_func = "remove_twitch_infinite_bombs",
				apply_buff_func = "apply_twitch_infinite_bombs"
			}
		}
	},
	twitch_vote_buff_invincibility = {
		activation_effect = "fx/screenspace_potion_03",
		deactivation_sound = "hud_gameplay_stance_deactivate",
		activation_sound = "hud_gameplay_stance_tank_activate",
		buffs = {
			{
				icon = "victor_zealot_passive_invulnerability",
				name = "twitch_vote_buff_invincibility",
				duration = 10,
				max_stacks = 1,
				remove_buff_func = "remove_twitch_invincibility",
				apply_buff_func = "apply_twitch_invincibility"
			}
		}
	},
	twitch_vote_buff_pulsating_waves = {
		buffs = {
			{
				update_func = "update_twitch_pulsating_waves",
				name = "twitch_vote_buff_pulsating_waves",
				icon = "markus_mercenary_increased_damage_on_enemy_proximity",
				duration = 15,
				apply_buff_func = "apply_twitch_pulsating_waves"
			}
		}
	},
	troll_chief_downed = {
		buffs = {
			{
				heal_percent = 0.005,
				name = "troll_chief_downed_regen",
				heal_type = "health_regen",
				update_func = "health_regen_update",
				apply_buff_func = "health_regen_start",
				time_between_heal = {
					1,
					1,
					1,
					0.5,
					0.25,
					0.25,
					0.25
				},
				particles = {
					{
						orphaned_policy = "stop",
						first_person = false,
						third_person = true,
						effect = "fx/chr_chaos_troll_chief_healing",
						continuous = true,
						destroy_policy = "stop"
					}
				}
			}
		}
	},
	troll_chief_phase_one_damage_reduction = {
		buffs = {
			{
				total_multiplier = -0.6,
				name = "troll_chief_downed",
				stat_buff = "damage_taken",
				multiplier = 0
			}
		}
	},
	troll_chief_barrel_exploded = {
		buffs = {
			{
				name = "troll_chief_barrel_exploded",
				multiplier = 0,
				stat_buff = "healing_received",
				total_part_of_chunk = 0.5,
				max_stacks = math.huge
			}
		}
	},
	troll_chief_on_downed_wounded = {
		buffs = {
			{
				name = "troll_chief_on_downed_wounded",
				multiplier = 0.35,
				stat_buff = "damage_dealt",
				remove_buff_func = "remove_stagger_immunity",
				refresh_durations = true,
				apply_buff_func = "make_stagger_immune",
				activation_sound = "enemy_grudge_raging",
				max_stacks = 1,
				activation_sound_3p = true,
				duration = var_0_9,
				particles = {
					{
						orphaned_policy = "stop",
						first_person = false,
						third_person = true,
						effect = "fx/cw_khorne_boss_large",
						continuous = true,
						destroy_policy = "stop"
					}
				}
			},
			{
				name = "troll_chief_on_leave_downed_damage_reduction",
				stat_buff = "damage_taken",
				multiplier = -0.75,
				max_stacks = 1,
				refresh_durations = true,
				duration = var_0_9
			}
		}
	},
	troll_chief_healing_immune = {
		buffs = {
			{
				name = "troll_chief_healing_immune",
				perks = {
					var_0_0.healing_immune
				}
			}
		}
	},
	sorcerer_tether_buff_invulnerability = {
		buffs = {
			{
				name = "sorcerer_tether_buff_invulnerability",
				multiplier = 0,
				stat_buff = "damage_taken",
				event = "on_hit_by_other",
				remove_buff_func = "sorcerer_tether_buff_remove_visuals",
				apply_buff_func = "sorcerer_tether_buff_apply_visuals",
				update_func = "sorcerer_tether_buff_invulnerability_update",
				perks = {
					var_0_0.invulnerable
				},
				max_stacks = math.huge
			}
		}
	}
}

require("scripts/unit_extensions/default_player_unit/buffs/talent_buff_templates")
require("scripts/unit_extensions/default_player_unit/buffs/buff_utils")
require("scripts/managers/talents/talent_settings")
require("scripts/settings/equipment/weapon_properties")
require("scripts/settings/equipment/weapon_traits")
require("scripts/settings/equipment/weave_properties")
require("scripts/settings/equipment/weave_traits")
table.merge_recursive(BuffTemplates, OldTalentBuffTemplates)

for iter_0_2, iter_0_3 in pairs(TalentBuffTemplates) do
	table.merge_recursive(BuffTemplates, iter_0_3)
end

table.merge_recursive(BuffTemplates, WeaponProperties.buff_templates)
table.merge_recursive(BuffTemplates, WeaponTraits.buff_templates)
table.merge_recursive(BuffTemplates, WeaveProperties.buff_templates)
table.merge_recursive(BuffTemplates, WeaveTraits.buff_templates)
DLCUtils.merge("buff_templates", BuffTemplates)
DLCUtils.merge("proc_functions", ProcFunctions)
DLCUtils.merge("stacking_buff_functions", StackingBuffFunctions)
DLCUtils.map_list("add_sub_buffs_to_core_buffs", function(arg_201_0)
	local var_201_0 = BuffTemplates[arg_201_0.buff_name].buffs

	var_201_0[#var_201_0 + 1] = arg_201_0.sub_buff_to_add
end)
BuffUtils.generate_balefire_burn_variants(BuffTemplates)
BuffUtils.generate_infinite_burn_variants(BuffTemplates)

local var_0_10 = {
	proc_chance = true
}

for iter_0_4, iter_0_5 in pairs(BuffTemplates) do
	if iter_0_5 then
		local var_0_11 = iter_0_5.description_values

		if var_0_11 then
			for iter_0_6 = 1, #var_0_11 do
				local var_0_12 = iter_0_5.buffs[1]
				local var_0_13 = var_0_11[iter_0_6]
				local var_0_14 = var_0_12[var_0_13]
				local var_0_15 = string.find(iter_0_4, "melee_weapon_")
				local var_0_16 = string.find(iter_0_4, "ranged_weapon_")

				if var_0_10[var_0_13] and (var_0_15 or var_0_16) then
					var_0_11[iter_0_6] = var_0_13
				elseif var_0_14 then
					if var_0_13 == "multiplier" or var_0_13 == "proc_chance" then
						if var_0_13 == "multiplier" and not var_0_12.stat_buff then
							var_0_14 = var_0_14 - 1
						end

						var_0_14 = math.abs(var_0_14 * 100)
					elseif var_0_13 == "bonus" and var_0_14 < 0 then
						var_0_14 = var_0_14 * -1
					end

					var_0_11[iter_0_6] = var_0_14
				else
					local var_0_17 = var_0_12.proc

					fassert(var_0_17, "There is no buff value by name: %s on buff: %s", var_0_13, iter_0_4)

					local var_0_18 = BuffTemplates[var_0_17].buffs[1][var_0_13]

					fassert(var_0_18, "There is no buff value by name: %s on buff %s for proc buff: %s.", var_0_13, iter_0_4, var_0_17)

					var_0_11[iter_0_6] = var_0_18
				end
			end
		end
	end
end
