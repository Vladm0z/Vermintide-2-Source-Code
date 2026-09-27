-- chunkname: @scripts/settings/dlcs/shovel/shovel_equipment_settings.lua

local shovel = DLCSettings.shovel

shovel.item_master_list_file_names = {
	"scripts/settings/dlcs/shovel/item_master_list_shovel"
}
shovel.weapon_skins_file_names = {
	"scripts/settings/dlcs/shovel/weapon_skins_shovel"
}
shovel.cosmetics_files = {
	"scripts/settings/dlcs/shovel/cosmetics_shovel"
}
shovel.weapon_template_file_names = {
	"scripts/settings/equipment/weapon_templates/bw_necromancer_career_skill",
	"scripts/settings/equipment/weapon_templates/bw_necromancer_career_utility",
	"scripts/settings/equipment/weapon_templates/staff_scythe",
	"scripts/settings/equipment/weapon_templates/staff_necromancy",
	"scripts/settings/equipment/weapon_templates/staff_death"
}
shovel.default_items = {
	bw_ghost_scythe = {
		inventory_icon = "icon_wpn_bw_ghost_scythe_01",
		description = "description_default_bw_ghost_scythe",
		display_name = "bw_ghost_scythe_blacksmith_name"
	},
	bw_necromancy_staff = {
		inventory_icon = "icon_wpn_bw_necromancy_staff_01",
		description = "description_default_bw_necromancy_staff",
		display_name = "bw_necromancy_staff_blacksmith_name"
	}
}
shovel.damage_profile_template_files_names = {
	"scripts/settings/equipment/damage_profile_templates_dlc_shovel"
}
shovel.action_template_file_names = {
	"scripts/settings/dlcs/shovel/action_soul_drain",
	"scripts/settings/dlcs/shovel/action_detonate",
	"scripts/settings/dlcs/shovel/action_damage_target",
	"scripts/settings/dlcs/shovel/action_chained_projectile",
	"scripts/settings/dlcs/shovel/action_career_bw_necromancer_targetting",
	"scripts/settings/dlcs/shovel/action_career_bw_necromancer_wave",
	"scripts/settings/dlcs/shovel/action_career_bw_necromancer_single_target",
	"scripts/settings/dlcs/shovel/action_career_bw_necromancer_raise_dead",
	"scripts/settings/dlcs/shovel/action_career_bw_necromancer_raise_dead_targeting",
	"scripts/settings/dlcs/shovel/action_career_bw_necromancer_area",
	"scripts/settings/dlcs/shovel/action_career_bw_necromancer_command_attack",
	"scripts/settings/dlcs/shovel/action_career_bw_necromancer_command_vent",
	"scripts/settings/dlcs/shovel/action_career_bw_necromancer_command_stand",
	"scripts/settings/dlcs/shovel/action_career_bw_necromancer_command_stand_targeting"
}
shovel.action_classes_lookup = {
	detonate = "ActionDetonate",
	damage_target = "ActionDamageTarget",
	soul_drain = "ActionSoulDrain",
	career_bw_necromancer_targetting = "ActionCareerBWNecromancerTargetting",
	career_bw_necromancer_raise_dead_targeting = "ActionCareerBWNecromancerRaiseDeadTargeting",
	career_bw_necromancer_command_stand_targeting = "ActionCareerBwNecromancerCommandStandTargeting",
	career_bw_necromancer_single_target = "ActionCareerBWNecromancerSingleTarget",
	career_bw_necromancer_raise_dead = "ActionCareerBWNecromancerRaiseDead",
	career_bw_necromancer_command_attack = "ActionCareerBWNecromancerCommandAttack",
	career_bw_necromancer_command_vent = "ActionCareerBWNecromancerCommandVent",
	chained_projectile = "ActionChainedProjectile",
	career_bw_necromancer_command_stand = "ActionCareerBwNecromancerCommandStand",
	career_bw_necromancer_area = "ActionCareerBWNecromancerArea",
	career_bw_necromancer_wave = "ActionCareerBWNecromancerWave"
}
shovel.inventory_package_list = {
	"resource_packages/careers/bw_necromancer",
	"units/beings/player/bright_wizard_necromancer/first_person_base/chr_first_person_mesh",
	"units/beings/player/bright_wizard_necromancer/third_person_base/chr_third_person_mesh",
	"units/beings/player/bright_wizard_necromancer_skin_01/first_person_base/chr_first_person_mesh",
	"units/beings/player/bright_wizard_necromancer_skin_01/third_person_base/chr_third_person_mesh",
	"units/beings/player/bright_wizard_necromancer_skin_01/skins/variant_a/chr_bright_wizard_necromancer_skin_01_a",
	"units/beings/player/bright_wizard_necromancer_skin_02/first_person_base/chr_first_person_mesh",
	"units/beings/player/bright_wizard_necromancer_skin_02/third_person_base/chr_third_person_mesh",
	"units/beings/player/bright_wizard_necromancer/skins/white/chr_bright_wizard_necromancer_white",
	"units/beings/player/bright_wizard_necromancer/headpiece/bw_n_fatshark_hat_01",
	"units/beings/player/bright_wizard_necromancer/headpiece/bw_n_hat_01",
	"units/beings/player/bright_wizard_necromancer/headpiece/bw_n_hat_02",
	"units/beings/player/bright_wizard_necromancer/headpiece/bw_n_hat_03",
	"units/beings/player/bright_wizard_necromancer/headpiece/bw_n_hat_04",
	"units/weapons/player/wpn_bw_ghost_scythe_01/wpn_bw_ghost_scythe_01",
	"units/weapons/player/wpn_bw_ghost_scythe_01/wpn_bw_ghost_scythe_01_3p",
	"units/weapons/player/wpn_bw_ghost_scythe_01/wpn_bw_ghost_scythe_01_fire",
	"units/weapons/player/wpn_bw_ghost_scythe_01/wpn_bw_ghost_scythe_01_fire_3p",
	"units/weapons/player/wpn_bw_ghost_scythe_01/wpn_bw_ghost_scythe_01_runed_01",
	"units/weapons/player/wpn_bw_ghost_scythe_01/wpn_bw_ghost_scythe_01_runed_01_3p",
	"units/weapons/player/wpn_bw_ghost_scythe_01/wpn_bw_ghost_scythe_01_runed_01_fire",
	"units/weapons/player/wpn_bw_ghost_scythe_01/wpn_bw_ghost_scythe_01_runed_01_fire_3p",
	"units/weapons/player/wpn_bw_ghost_scythe_02/wpn_bw_ghost_scythe_02",
	"units/weapons/player/wpn_bw_ghost_scythe_02/wpn_bw_ghost_scythe_02_3p",
	"units/weapons/player/wpn_bw_ghost_scythe_02/wpn_bw_ghost_scythe_02_fire",
	"units/weapons/player/wpn_bw_ghost_scythe_02/wpn_bw_ghost_scythe_02_fire_3p",
	"units/weapons/player/wpn_bw_ghost_scythe_02/wpn_bw_ghost_scythe_02_runed_01",
	"units/weapons/player/wpn_bw_ghost_scythe_02/wpn_bw_ghost_scythe_02_runed_01_3p",
	"units/weapons/player/wpn_bw_ghost_scythe_02/wpn_bw_ghost_scythe_02_runed_01_fire",
	"units/weapons/player/wpn_bw_ghost_scythe_02/wpn_bw_ghost_scythe_02_runed_01_fire_3p",
	"units/weapons/player/wpn_bw_ghost_scythe_02/wpn_bw_ghost_scythe_02_magic_01",
	"units/weapons/player/wpn_bw_ghost_scythe_02/wpn_bw_ghost_scythe_02_magic_01_3p",
	"units/weapons/player/wpn_bw_ghost_scythe_02/wpn_bw_ghost_scythe_02_magic_01_fire",
	"units/weapons/player/wpn_bw_ghost_scythe_02/wpn_bw_ghost_scythe_02_magic_01_fire_3p",
	"units/weapons/player/wpn_bw_necromancy_staff_01/wpn_bw_necromancy_staff_01",
	"units/weapons/player/wpn_bw_necromancy_staff_01/wpn_bw_necromancy_staff_01_3p",
	"units/weapons/player/wpn_bw_necromancy_staff_01/wpn_bw_necromancy_staff_01_runed_01",
	"units/weapons/player/wpn_bw_necromancy_staff_01/wpn_bw_necromancy_staff_01_runed_01_3p",
	"units/weapons/player/wpn_bw_necromancy_staff_02/wpn_bw_necromancy_staff_02",
	"units/weapons/player/wpn_bw_necromancy_staff_02/wpn_bw_necromancy_staff_02_3p",
	"units/weapons/player/wpn_bw_necromancy_staff_02/wpn_bw_necromancy_staff_02_runed_01",
	"units/weapons/player/wpn_bw_necromancy_staff_02/wpn_bw_necromancy_staff_02_runed_01_3p",
	"units/weapons/player/wpn_bw_necromancy_staff_02/wpn_bw_necromancy_staff_02_magic_01",
	"units/weapons/player/wpn_bw_necromancy_staff_02/wpn_bw_necromancy_staff_02_magic_01_3p",
	"units/weapons/player/wpn_bw_necromancy_staff_01/wpn_bw_necromancy_staff_projectile_02",
	"units/weapons/player/wpn_bw_necromancy_staff_01/wpn_bw_necromancy_staff_projectile_02_3p",
	"units/weapons/player/wpn_bw_necromancy_staff_01/wpn_bw_necromancy_staff_projectile_03",
	"units/weapons/player/wpn_bw_necromancer_ability/wpn_bw_necromancer_ability",
	"units/weapons/player/wpn_bw_necromancer_ability/wpn_bw_necromancer_ability_3p",
	"units/weapons/player/wpn_necromancy_skull/wpn_necromancy_skull",
	"units/weapons/player/wpn_necromancy_skull/wpn_necromancy_skull_3p",
	"units/weapons/player/wpn_necromancy_skull/wpn_necromancy_skull_3ps",
	"units/beings/player/bright_wizard_necromancer/talents/trapped_soul_skull"
}
shovel.projectile_units = {
	necrostaff_skull = {
		projectile_unit_name = "units/weapons/player/wpn_necromancy_skull/wpn_necromancy_skull_3ps"
	},
	necromancer_curse_spirit = {
		projectile_unit_name = "units/weapons/player/wpn_bw_necromancy_staff_01/wpn_bw_necromancy_staff_projectile_03"
	}
}
shovel.projectiles = {
	skull = {
		impact_type = "sphere_sweep",
		static_impact_type = "sphere_sweep",
		fire_from_muzzle = false,
		radius = 0.2,
		trajectory_template_name = "throw_trajectory",
		muzzle_name = "fx_01",
		indexed = true,
		forced_hitzone = "torso",
		gravity_settings = "drake_pistols",
		projectile_unit_template_name = "sticky_projectile_unit",
		projectile_units_template = "necrostaff_skull",
		unit_life_time = math.huge,
		anim_blend_settings = {
			link_node = "a_effects_plane",
			forward_offset = 0,
			blend_time = 0.35,
			use_anim_rotation = false,
			blend_func = function (arg_1_0)
				-- function 1
				local flag

				flag = not (arg_1_0 < 0.5) or not 0 or math.easeOutCubic((arg_1_0 - 0.5) * 2)

				return flag
			end
		},
		external_events = {
			detonate = function (self)
				-- function 2
				if self._life_time <= 0 then
					return
				end

				self._life_time = 0

				if not self.is_husk then
					local charge_data = self.charge_data
					local charged_aoe

					if not self.is_charged then
						charged_aoe = charge_data.charged_aoe

						if not charged_aoe then
							-- Nothing
						end
					end

					charged_aoe = charge_data.aoe

					::label_2_0::

					if not charged_aoe then
						local var_2_2 = POSITION_LOOKUP[self._projectile_unit]

						self:do_aoe(charged_aoe, var_2_2, true)
					end
				end
			end
		}
	}
}
shovel.explosion_templates = {
	sienna_necromancer_passive_explosion = {
		explosion = {
			use_attacker_power_level = true,
			radius = 3.5,
			sound_event_name = "Play_enemy_combat_warpfire_backpack_explode",
			max_damage_radius = 2.5,
			no_prop_damage = true,
			no_friendly_fire = true,
			alert_enemies_radius = 15,
			alert_enemies = true,
			damage_profile = "sienna_necromancer_blood_explosion",
			effect_name = "fx/wpnfx_skull_explosion_big_3p",
			server_hit_func = function (arg_3_0, arg_3_1, arg_3_2, arg_3_3, arg_3_4)
				-- function 3
				if not ALIVE[arg_3_0] then
					return
				end
			end
		}
	},
	skull_detonation = {
		explosion = {
			use_attacker_power_level = true,
			radius_min = 1.5,
			sound_event_name = "weapon_sienna_necro_staff_projectile_explode",
			radius_max = 1.5,
			attacker_power_level_offset = 0.25,
			max_damage_radius_min = 1.5,
			alert_enemies_radius = 10,
			damage_profile_glance = "skull_detonation",
			max_damage_radius_max = 1.5,
			alert_enemies = true,
			damage_profile = "skull_detonation",
			effect_name = "fx/wpnfx_skull_explosion_3p"
		}
	},
	skull_detonation_charged = {
		explosion = {
			use_attacker_power_level = true,
			radius_min = 3,
			sound_event_name = "Play_mutator_enemy_split_small",
			radius_max = 3,
			attacker_power_level_offset = 0.2,
			max_damage_radius_min = 3,
			alert_enemies_radius = 10,
			damage_profile_glance = "skull_detonation_charged",
			max_damage_radius_max = 3,
			alert_enemies = true,
			damage_profile = "skull_detonation_charged",
			effect_name = "fx/wpnfx_skull_explosion_big_3p"
		}
	},
	sienna_necromancer_ability_6_3_stagger = {
		explosion = {
			use_attacker_power_level = true,
			radius = 3,
			alert_enemies_radius = 15,
			alert_enemies = true,
			damage_profile = "sienna_necromancer_ability_6_3_stagger",
			attack_template = "drakegun"
		}
	},
	sienna_necromancer_ability_stagger = {
		explosion = {
			use_attacker_power_level = true,
			radius = 3,
			alert_enemies_radius = 15,
			alert_enemies = true,
			damage_profile = "ability_push",
			no_friendly_fire = true,
			attack_template = "drakegun"
		}
	},
	sienna_necromancer_ability_stagger_improved = {
		explosion = {
			use_attacker_power_level = true,
			radius = 3,
			alert_enemies_radius = 15,
			alert_enemies = true,
			damage_profile = "ability_push",
			no_friendly_fire = true,
			dot_template_name = "sienna_necromancer_4_3_dot",
			attack_template = "drakegun"
		}
	},
	sienna_necromancer_spawn_skeleton_stagger = {
		explosion = {
			no_prop_damage = true,
			radius = 1.5,
			no_friendly_fire = true,
			damage_profile = "necromancer_ability_spawn_stagger",
			power_level = 5,
			attack_template = "necromancer_ability_spawn_stagger",
			max_damage_radius = math.huge
		}
	}
}
shovel.attack_template_files_names = {
	"scripts/settings/equipment/attack_templates_dlc_shovel"
}
