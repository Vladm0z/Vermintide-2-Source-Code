-- chunkname: @scripts/settings/dlcs/shovel/shovel_common_settings.lua

local var_0_0 = DLCSettings.shovel

var_0_0.career_setting_files = {
	"scripts/settings/dlcs/shovel/career_settings_shovel"
}
var_0_0.player_breeds = {
	"scripts/settings/dlcs/shovel/player_breeds_shovel"
}
var_0_0.career_ability_settings = {
	"scripts/settings/dlcs/shovel/career_ability_settings_shovel"
}
var_0_0.action_template_files = {
	"scripts/settings/dlcs/shovel/action_templates_shovel"
}
var_0_0.talent_settings = {
	"scripts/settings/dlcs/shovel/talent_settings_shovel"
}
var_0_0.profile_files = {
	"scripts/settings/dlcs/shovel/shovel_profiles"
}
var_0_0.material_effect_mappings_file_names = {
	"scripts/settings/material_effect_mappings_shovel"
}
var_0_0.statistics_definitions = {
	"scripts/managers/backend/statistics_definitions_shovel"
}
var_0_0.statistics_lookup = {
	"shovel_skeleton_attack_big",
	"shovel_skeleton_defend",
	"shovel_staff_balefire",
	"shovel_skeleton_balefire",
	"shovel_fast_staff_attack"
}
var_0_0.anim_lookup = {
	"to_ghost_scythe",
	"to_quarter_staff",
	"to_quarter_staff_wield",
	"to_quarter_staff_auto",
	"ability_test",
	"ability_test_left",
	"ability_test_right",
	"ability_shield_bash",
	"ability_test_charge",
	"ability_test_charge_finish",
	"necro_ability_start",
	"necro_ability_cancel",
	"necro_ability_cast",
	"inspect_snap_left",
	"inspect_snap_right",
	"inspect_snap_both",
	"inspect_clap",
	"attack_detonate_one",
	"attack_detonate_one_02",
	"attack_detonate_all",
	"idle_disabled",
	"idle_enabled",
	"special_action_02",
	"blood_start",
	"blood_loop",
	"blood_exit",
	"soul_rip_start",
	"soul_rip_loop",
	"soul_rip_attack",
	"soul_rip_pop",
	"soul_rip_exit",
	"chain_attack",
	"chain_attack_02",
	"pet_control_equip",
	"pet_control_cancel",
	"pet_control_target",
	"pet_control_target_command",
	"pet_control_target_command_return",
	"pet_control_sacrifice",
	"to_necro_command_item",
	"career_select_spawn",
	"career_select_spawn_02"
}
var_0_0.husk_lookup = {
	"units/beings/npcs/necromancer_skeleton/chr_npc_necromancer_skeleton",
	"units/weapons/player/wpn_bw_necromancy_staff_01/wpn_bw_necromancy_staff_projectile_02_3p",
	"units/weapons/player/wpn_necromancy_skull/wpn_necromancy_skull_3p",
	"units/weapons/player/wpn_necromancy_skull/wpn_necromancy_skull_3ps",
	"units/props/skulls/deus_skull/deus_skull_01",
	"units/beings/player/bright_wizard_necromancer/talents/ripped_soul",
	"units/beings/player/bright_wizard_necromancer/talents/trapped_soul_skull",
	"units/weapons/player/wpn_bw_necromancy_staff_01/wpn_bw_necromancy_staff_projectile_03"
}
var_0_0.effects = {
	"fx/chr_chaos_warrior_cleave_impact_ground",
	"fx/magic_wind_heavens_lightning_strike_01",
	"fx/wpnfx_skull_explosion_3p",
	"fx/wpnfx_skull_explosion_big_3p",
	"fx/wpnfx_skull_staff_impact",
	"fx/wpnfx_staff_death/rip_channel",
	"fx/wpnfx_staff_death/rip_soul",
	"fx/wpnfx_staff_death/rip_burst",
	"fx/wpnfx_staff_death/rip_temp_directional",
	"fx/wpnfx_staff_death/curse_spirit",
	"fx/wpnfx_staff_death/curse_spirit_first",
	"fx/wpnfx_staff_death/curse_spirit_impact",
	"fx/necromancer_wave_round",
	"fx/player_overcharge_explosion_necromancer",
	"fx/necromancer_skeleton_sacrifice",
	"fx/necromancer_cursed_explosion_blood",
	"fx/necromancer_cursed_explosion_blue"
}
var_0_0._tracked_weapon_kill_stats = {}
var_0_0.unlock_settings = {
	shovel = {
		id = "2585630",
		class = "UnlockDlc",
		requires_restart = true
	},
	shovel_upgrade = {
		id = "2585640",
		class = "UnlockDlc",
		requires_restart = true
	}
}
var_0_0.unlock_settings_xb1 = {
	shovel = {
		id = "35315039-4B53-3034-C05A-465731382100",
		backend_reward_id = "shovel",
		class = "UnlockDlc",
		requires_restart = true
	},
	shovel_upgrade = {
		id = "35315039-4B53-3034-C05A-465731382100",
		backend_reward_id = "shovel_upgrade",
		class = "UnlockDlc"
	}
}
var_0_0.unlock_settings_ps4 = {
	CUSA13595_00 = {
		shovel = {
			product_label = "V2USNECROMANCER0",
			backend_reward_id = "shovel",
			class = "UnlockDlc",
			requires_restart = true,
			id = "17308f2304a046debd6d22e8054b501a"
		},
		shovel_upgrade = {
			id = "17308f2304a046debd6d22e8054b501a",
			product_label = "V2USNECROMANCER0",
			class = "UnlockDlc",
			backend_reward_id = "shovel_upgrade"
		}
	},
	CUSA13645_00 = {
		shovel = {
			product_label = "V2EUNECROMANCER0",
			backend_reward_id = "shovel",
			class = "UnlockDlc",
			requires_restart = true,
			id = "fee4879df76040f2adfca4629c58225f"
		},
		shovel_upgrade = {
			id = "fee4879df76040f2adfca4629c58225f",
			product_label = "V2EUNECROMANCER0",
			class = "UnlockDlc",
			backend_reward_id = "shovel_upgrade"
		}
	}
}
var_0_0.store_layout = {
	structure = {
		cosmetics = {
			sienna = {
				necromancer = {
					necromancer_weapon_skins = "item_details"
				}
			}
		}
	},
	pages = {
		necromancer = {
			sound_event_enter = "Play_hud_store_category_button",
			layout = "category",
			display_name = "bw_necromancer",
			item_filter = "can_wield_bw_necromancer",
			sort_order = 4,
			category_button_texture = "store_category_icon_sienna_necromancer",
			global_shader_flag_overrides = {
				NECROMANCER_CAREER_REMAP = true
			}
		},
		necromancer_weapon_skins = {
			sound_event_enter = "Play_hud_store_category_button",
			layout = "item_list",
			display_name = "menu_store_category_title_weapon_illusions",
			type = "item",
			item_filter = "item_type == weapon_skin",
			sort_order = 3,
			category_button_texture = "store_category_icon_weapons",
			global_shader_flag_overrides = {
				NECROMANCER_CAREER_REMAP = true
			}
		}
	}
}
var_0_0.network_damage_types = {
	"cursed_blood_spread"
}
var_0_0.bt_enter_hooks = {
	disable_perception = function (arg_1_0, arg_1_1, arg_1_2)
		arg_1_1.disable_perception_data = arg_1_1.override_target_selection_name
		arg_1_1.override_target_selection_name = "perception_no_seeing"
	end,
	necromancer_trigger_explode = function (arg_2_0, arg_2_1, arg_2_2)
		if not arg_2_1.explosion_triggered then
			arg_2_1.explosion_triggered = true

			AiUtils.kill_unit(arg_2_0)
		end
	end,
	start_stand_ground = function (arg_3_0, arg_3_1, arg_3_2)
		arg_3_1.goal_destination = Vector3Box(arg_3_1.stand_ground_position:unbox())

		arg_3_1.navigation_extension:set_enabled(true)
	end,
	start_follow_commander = function (arg_4_0, arg_4_1, arg_4_2)
		if arg_4_1.commander_extension then
			arg_4_1.commander_extension:register_follow_node_update(arg_4_0)
			arg_4_1.navigation_extension:set_enabled(true)
		end
	end,
	start_command_attack = function (arg_5_0, arg_5_1, arg_5_2)
		arg_5_1.new_command_attack = nil
		arg_5_1.undergoing_command_attack = true
	end
}
var_0_0.projectile_templates = {
	"necromancer_trapped_soul"
}
var_0_0.bt_leave_hooks = {
	enable_perception = function (arg_6_0, arg_6_1, arg_6_2)
		arg_6_1.override_target_selection_name = arg_6_1.disable_perception_data
		arg_6_1.disable_perception_data = nil
	end,
	start_disabled_resume_timer = function (arg_7_0, arg_7_1, arg_7_2)
		arg_7_1.disabled_resume_time = arg_7_2 + 0.5
	end,
	command_attack_done = function (arg_8_0, arg_8_1, arg_8_2)
		arg_8_1.undergoing_command_attack = false
	end,
	remove_charge_target = function (arg_9_0, arg_9_1, arg_9_2)
		if arg_9_1.anim_cb_charge_impact_finished or arg_9_1.commander_target ~= arg_9_1.charge_target then
			arg_9_1.stick_to_enemy_t = arg_9_2 + 5
			arg_9_1.charge_target = nil
		end
	end,
	stop_follow_commander = function (arg_10_0, arg_10_1, arg_10_2)
		if arg_10_1.commander_extension then
			arg_10_1.commander_extension:unregister_follow_node_update(arg_10_0)
		end
	end
}
var_0_0.progression_unlocks = {
	bw_necromancer = {
		description = "end_screen_career_unlocked",
		profile = "bright_wizard",
		value = "bw_necromancer",
		title = "bw_necromancer",
		level_requirement = 0,
		unlock_type = "career"
	}
}
var_0_0.systems = {
	"scripts/entity_system/systems/ai/ai_commander_system"
}
var_0_0.entity_extensions = {
	"scripts/unit_extensions/ai_commander/ai_commander_extension"
}
