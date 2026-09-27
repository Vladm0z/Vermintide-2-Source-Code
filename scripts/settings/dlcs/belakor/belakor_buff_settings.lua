-- chunkname: @scripts/settings/dlcs/belakor/belakor_buff_settings.lua

require("scripts/settings/dlcs/belakor/belakor_balancing")

local scripts_unit_extensions_default_player_unit_buffs_settings_buff_perk_names = require("scripts/unit_extensions/default_player_unit/buffs/settings/buff_perk_names")
local belakor = DLCSettings.belakor

local function fn()
	-- function 1
	return Managers.state.network.is_server
end

local function fn_2(arg_2_0, arg_2_1)
	-- function 2
	local ENEMY_PLAYER_AND_BOT_POSITIONS = arg_2_1.side.ENEMY_PLAYER_AND_BOT_POSITIONS

	for i = 1, #ENEMY_PLAYER_AND_BOT_POSITIONS do
		if Vector3.distance_squared(arg_2_0, ENEMY_PLAYER_AND_BOT_POSITIONS[i]) < arg_2_1.min_dist_sqr then
			return false
		end
	end

	return true
end

local tbl = {
	IDLE = 1,
	COOLDOWN = 5,
	FINDING_TELEPORT_POSITION = 2,
	TELEPORTING = 3,
	LANDING = 4
}

belakor.buff_function_templates = {
	update_belakor_grey_wings_teleport_trigger = function (arg_3_0, arg_3_1, arg_3_2)
		-- function 3
		if not fn() then
			return
		end

		local var_3_0 = BLACKBOARDS[arg_3_0]
		local target_unit = var_3_0.target_unit
		local parent_buff_shared_table = arg_3_1.parent_buff_shared_table

		if not target_unit then
			return
		end

		if var_3_0.move_state == "stagger" then
			parent_buff_shared_table.teleport = true

			return
		end

		local var_3_3 = POSITION_LOOKUP[arg_3_0]
		local var_3_4 = POSITION_LOOKUP[target_unit]

		if Vector3.length(var_3_4 - var_3_3) > arg_3_1.template.max_distance_to_trigger_teleport_from_combo_attack then
			return
		end

		local combo_attack_data = var_3_0.combo_attack_data

		if not ((var_3_0.move_state ~= "attacking" or not combo_attack_data or combo_attack_data.current_attack_name == "attack_wild_flailing" or combo_attack_data.current_attack_name == "attack_heavy") and combo_attack_data.aborted) then
			parent_buff_shared_table.teleport = true
		end
	end,
	apply_belakor_grey_wings = function (arg_4_0, arg_4_1, arg_4_2)
		-- function 4
		if not fn() then
			return
		end

		local parent_buff_shared_table = arg_4_1.parent_buff_shared_table

		parent_buff_shared_table.teleport_state = tbl.IDLE

		local teleport_available_buff = arg_4_1.template.teleport_available_buff

		parent_buff_shared_table.teleport_available_buff_id = ScriptUnit.has_extension(arg_4_0, "buff_system"):add_buff(teleport_available_buff)
		parent_buff_shared_table.blackboard = BLACKBOARDS[arg_4_0]
		parent_buff_shared_table.side = Managers.state.side.side_by_unit[arg_4_0]
		parent_buff_shared_table.health_extension = ScriptUnit.extension(arg_4_0, "health_system")
	end,
	update_belakor_grey_wings = function (arg_5_0, arg_5_1, arg_5_2)
		-- function 5
		if not fn() then
			return
		end

		local time = Managers.time:time("game")
		local has_extension = ScriptUnit.has_extension(arg_5_0, "buff_system")
		local parent_buff_shared_table = arg_5_1.parent_buff_shared_table
		local blackboard = parent_buff_shared_table.blackboard
		local template = arg_5_1.template

		if not (not parent_buff_shared_table.teleport and parent_buff_shared_table.teleport_state ~= tbl.IDLE) then
			parent_buff_shared_table.teleport_state = tbl.FINDING_TELEPORT_POSITION
			parent_buff_shared_table.teleport = false
			blackboard.umbral_leap = true
			blackboard.in_vortex = true

			local var_5_5 = POSITION_LOOKUP[arg_5_0]
			local teleport_effect = template.teleport_effect

			if not teleport_effect then
				local var_5_7 = NetworkLookup.effects[teleport_effect]
				local num = 0
				local identity = Quaternion.identity()

				Managers.state.network:rpc_play_particle_effect(nil, var_5_7, NetworkConstants.invalid_game_object_id, num, var_5_5, identity, false)
			end
		end

		if parent_buff_shared_table.teleport_state == tbl.COOLDOWN then
			if not parent_buff_shared_table.teleport_cooldown_t then
				parent_buff_shared_table.teleport_cooldown_t = time + template.teleport_cooldown
			end

			if not parent_buff_shared_table.teleport_available_buff_id then
				has_extension:remove_buff(parent_buff_shared_table.teleport_available_buff_id)

				parent_buff_shared_table.teleport_available_buff_id = nil
			end

			parent_buff_shared_table.teleport = false

			if time > parent_buff_shared_table.teleport_cooldown_t then
				local teleport_available_buff = arg_5_1.template.teleport_available_buff

				parent_buff_shared_table.teleport_available_buff_id = has_extension:add_buff(teleport_available_buff)
				parent_buff_shared_table.teleport_state = tbl.IDLE
			end
		end

		if parent_buff_shared_table.teleport_state == tbl.FINDING_TELEPORT_POSITION then
			local function fn_3()
				-- function 6
				if not (not ALIVE[arg_5_0] and parent_buff_shared_table.teleport_state == tbl.FINDING_TELEPORT_POSITION) then
					return
				end

				local var_6_0 = POSITION_LOOKUP[arg_5_0]
				local flag = true
				local target_unit = blackboard.target_unit

				if not target_unit then
					local var_6_3 = POSITION_LOOKUP[arg_5_0]
					local var_6_4 = POSITION_LOOKUP[target_unit]

					if Vector3.length(var_6_4 - var_6_3) > template.min_distance_to_trigger_gap_closer_teleport then
						flag = false
					end
				end

				local var_6_5
				local var_6_6
				local var_6_7
				local var_6_8
				local find_valid_pos_attempts = template.find_valid_pos_attempts
				local side = parent_buff_shared_table.side

				if not flag then
					var_6_6 = template.min_teleport_distance
					var_6_7 = template.max_teleport_distance
					var_6_8 = template.min_dist_from_players
				else
					var_6_6 = template.min_teleport_distance_gap_closer
					var_6_7 = template.max_teleport_distance_gap_closer
					var_6_8 = template.min_dist_from_players_gap_closer
				end

				local tbl_2 = {
					side = side,
					min_dist_sqr = var_6_8 * var_6_8
				}
				local get_spawn_pos_on_circle_with_func_range = ConflictUtils.get_spawn_pos_on_circle_with_func_range(blackboard.nav_world, var_6_0, var_6_6, var_6_7, find_valid_pos_attempts, fn_2, tbl_2, 8, 8)

				if not get_spawn_pos_on_circle_with_func_range then
					parent_buff_shared_table.teleport_t = time + template.teleport_delay
					parent_buff_shared_table.teleport_position = Vector3Box(get_spawn_pos_on_circle_with_func_range)
					parent_buff_shared_table.teleport_origin_position = Vector3Box(var_6_0)
					parent_buff_shared_table.target_unit = blackboard.target_unit
					parent_buff_shared_table.teleport_state = tbl.TELEPORTING
				end
			end

			Managers.state.entity:system("ai_navigation_system"):add_safe_navigation_callback(fn_3)
		end

		if not ((parent_buff_shared_table.teleport_state ~= tbl.TELEPORTING or not ALIVE[arg_5_0]) and not (time > parent_buff_shared_table.teleport_t)) then
			local function fn_4()
				-- function 7
				local var_7_0 = POSITION_LOOKUP[arg_5_0]
				local unbox = parent_buff_shared_table.teleport_position:unbox()
				local teleport_effect = template.teleport_effect

				if not teleport_effect then
					local var_7_3 = NetworkLookup.effects[teleport_effect]
					local num = 0
					local identity = Quaternion.identity()

					Managers.state.network:rpc_play_particle_effect(nil, var_7_3, NetworkConstants.invalid_game_object_id, num, var_7_0, identity, false)
				end

				local teleport_effect_trail = template.teleport_effect_trail

				if not teleport_effect_trail then
					local network = Managers.state.network
					local num_2 = 0
					local normalize = Vector3.normalize(var_7_0 - unbox)
					local look = Quaternion.look(normalize, Vector3.up())
					local var_7_11 = NetworkLookup.effects[teleport_effect_trail]

					network:rpc_play_particle_effect(nil, var_7_11, NetworkConstants.invalid_game_object_id, num_2, var_7_0, look, false)
				end

				blackboard.umbral_leap_destination = Vector3Box(unbox)
				parent_buff_shared_table.teleport_state = tbl.COOLDOWN
			end

			Managers.state.entity:system("ai_navigation_system"):add_safe_navigation_callback(fn_4)
		end
	end,
	remove_belakor_grey_wings = function (arg_8_0, arg_8_1, arg_8_2)
		-- function 8
		if not fn() then
			return
		end
	end,
	apply_belakor_homing_skull_drain_stamina = function (arg_9_0, arg_9_1, arg_9_2)
		-- function 9
		local fatigue_type = arg_9_1.template.fatigue_type
		local has_extension = ScriptUnit.has_extension(arg_9_0, "status_system")

		if not has_extension then
			has_extension:add_fatigue_points(fatigue_type)
		end
	end,
	belakor_cultists_apply_eye_glow = function (arg_10_0, arg_10_1, arg_10_2)
		-- function 10
		if not ALIVE[arg_10_0] then
			arg_10_1.material_res_id = Unit.get_material_resource_id(arg_10_0, "mtr_eyes")

			Unit.set_material(arg_10_0, "mtr_eyes", "units/beings/enemies/mtr_eyes_belakor_cultist")
		end
	end,
	belakor_cultists_remove_eye_glow = function (arg_11_0, arg_11_1, arg_11_2)
		-- function 11
		if not ALIVE[arg_11_0] and not arg_11_1.material_res_id then
			Unit.set_material_from_id(arg_11_0, "mtr_eyes", arg_11_1.material_res_id)
		end
	end,
	apply_one_from_list = function (arg_12_0, arg_12_1, arg_12_2)
		-- function 12
		if not fn() then
			local buff_list = arg_12_1.template.buff_list
			local var_12_1 = buff_list[math.random(1, #buff_list)]
			local system = Managers.state.entity:system("buff_system")
			local var_12_3 = system
			local add_buff = system.add_buff
			local var_12_5 = arg_12_0
			local var_12_6 = var_12_1
			local attacker_unit = arg_12_1.attacker_unit

			attacker_unit = attacker_unit or arg_12_0

			add_buff(var_12_3, var_12_5, var_12_6, attacker_unit, false)
		end
	end,
	apply_homing_skull_achieve = function (arg_13_0, arg_13_1, arg_13_2)
		-- function 13
		Managers.state.achievement:trigger_event("register_skull_hit", arg_13_0)
	end
}
belakor.proc_functions = {
	belakor_crystal_drop = function (arg_14_0, arg_14_1, arg_14_2)
		-- function 14
		if not fn() then
			local var_14_0 = arg_14_2[1]
			local num = Unit.world_position(var_14_0, 0) + Vector3(0, 0, 1.5)

			BelakorBalancing.spawn_crystal_func(num)
		end

		return true
	end,
	belakor_shadow_lieutenant_drop_crystal = function (arg_15_0, arg_15_1, arg_15_2)
		-- function 15
		if not fn() then
			local var_15_0 = arg_15_2[1]
			local node = Unit.node(var_15_0, "c_spine")
			local world_position = Unit.world_position(var_15_0, node)
			local system = Managers.state.entity:system("pickup_system")
			local flag = true
			local identity = Quaternion.identity()
			local str = "dropped"
			local var_15_7 = Vector3(6 * math.random() - 3, 6 * math.random() - 3, 3)
			local str_2 = "belakor_crystal"
			local str_3 = "belakor_crystal_throw"

			system:spawn_pickup(str_2, world_position, identity, flag, str, var_15_7, str_3)

			local world = Managers.world:world("level_world")
			local find_dialogue_unit = LevelHelper:find_dialogue_unit(world, "ferry_lady")

			if not (not find_dialogue_unit and ScriptUnit.has_extension(find_dialogue_unit, "dialogue_system")) then
				local extension_input = ScriptUnit.extension_input(find_dialogue_unit, "dialogue_system")
				local alloc_table = FrameTable.alloc_table()
				local get_current_level_keys = Managers.level_transition_handler:get_current_level_keys()
				local var_15_15
				local flag_2

				flag_2 = get_current_level_keys == "arena_belakor" or not "shadow_curse_crystal_dropped" or "shadow_curse_vortex_crystal"

				extension_input:trigger_dialogue_event(flag_2, alloc_table)
			end
		end

		return true
	end,
	on_grey_wings_damage_taken = function (arg_16_0, arg_16_1, arg_16_2)
		-- function 16
		if not fn() then
			return
		end

		local var_16_0 = BLACKBOARDS[arg_16_0]
		local var_16_1 = arg_16_2[1]

		if var_16_0.target_unit ~= var_16_1 then
			return
		end

		local valid_damage_types = arg_16_1.template.valid_damage_types
		local var_16_3 = arg_16_2[3]

		if not (not valid_damage_types and valid_damage_types[var_16_3]) then
			return
		end

		arg_16_1.parent_buff_shared_table.teleport = true
	end
}
belakor.explosion_templates = {
	homing_skull_explosion = {
		explosion = {
			alert_enemies = false,
			radius = 1,
			always_stagger_ai = true,
			allow_friendly_fire_override = true,
			buff_to_apply = "belakor_homing_skull_debuff",
			max_damage_radius_min = 0.5,
			attack_template = "drakegun",
			max_damage_radius_max = 1,
			sound_event_name = "Play_curse_shadow_dagger_projectile_impact",
			damage_profile = "homing_skull_explosion",
			power_level = 500,
			effect_name = "fx/belakor/blk_curse_skulls_explosion_fx",
			immune_breeds = {
				chaos_zombie = true,
				skaven_grey_seer = true,
				skaven_stormfiend = true
			}
		}
	},
	homing_skull_impact = {
		server_hit_func = function (arg_17_0, arg_17_1, arg_17_2, arg_17_3, arg_17_4, arg_17_5)
			-- function 17
			local local_position = Unit.local_position(arg_17_0, 0)
			local world = Managers.world:world("level_world")

			arg_17_5 = ExplosionUtils.get_template("homing_skull_explosion")

			DamageUtils.create_explosion(world, arg_17_0, local_position, Quaternion.identity(), arg_17_5, 1, arg_17_1, true, false, arg_17_2, false)

			local game_object_or_level_id = Managers.state.network:game_object_or_level_id(arg_17_0)
			local var_17_3 = NetworkLookup.explosion_templates[arg_17_5.name]
			local var_17_4 = NetworkLookup.damage_sources[arg_17_1]

			Managers.state.network.network_transmit:send_rpc_clients("rpc_create_explosion", game_object_or_level_id, false, local_position, Quaternion.identity(), var_17_3, 1, var_17_4, 0, false, game_object_or_level_id)
			AiUtils.kill_unit(arg_17_0, nil, nil, "undefined", nil)
		end
	},
	tiny_explosive_barrel = {
		explosion = {
			radius = 6,
			dot_template_name = "burning_dot_1tick",
			max_damage_radius = 1.75,
			alert_enemies = true,
			alert_enemies_radius = 10,
			allow_friendly_fire_override = true,
			attack_template = "drakegun",
			sound_event_name = "boon_cluster_barrel_explosion",
			damage_profile = "explosive_barrel",
			effect_name = "fx/wpnfx_barrel_explosion",
			difficulty_power_level = {
				easy = {
					power_level_glance = 100,
					power_level = 200
				},
				normal = {
					power_level_glance = 200,
					power_level = 400
				},
				hard = {
					power_level_glance = 300,
					power_level = 600
				},
				harder = {
					power_level_glance = 400,
					power_level = 800
				},
				hardest = {
					power_level_glance = 500,
					power_level = 1000
				},
				cataclysm = {
					power_level_glance = 550,
					power_level = 1100
				},
				cataclysm_2 = {
					power_level_glance = 575,
					power_level = 1150
				},
				cataclysm_3 = {
					power_level_glance = 600,
					power_level = 1200
				},
				versus_base = {
					power_level_glance = 300,
					power_level = 600
				}
			}
		}
	},
	belakor_arena_finish = {
		explosion = {
			no_aggro = true,
			radius = 300,
			player_push_speed = 5,
			alert_enemies = false,
			damage_profile = "belakor_arena_finish",
			power_level = 1000,
			level_unit_damage = true,
			collision_filter = "filter_simple_explosion_overlap"
		}
	}
}

local tbl_2 = {
	light_blunt_linesman = true,
	light_slashing_tank = true,
	drakegun = true,
	heavy_blunt_smiter = true,
	slashing_smiter_uppercut = true,
	piercing = true,
	light_slashing_linesman = true,
	heavy_slashing_smiter_uppercut = true,
	blunt = true,
	light_blunt_fencer = true,
	heavy_blunt_linesman = true,
	blunt_tank_uppercut = true,
	heavy_blunt_tank = true,
	light_stab_fencer = true,
	arrow = true,
	heavy_stab_fencer = true,
	shot_sniper = true,
	shot_machinegun = true,
	bolt_sniper = true,
	blunt_linesman = true,
	blunt_tank = true,
	shot_repeating_handgun = true,
	light_slashing_fencer = true,
	projectile = true,
	slashing_fencer = true,
	heavy_slashing_fencer = true,
	drakegun_shot = true,
	heavy_stab_smiter = true,
	arrow_sniper = true,
	heavy_slashing_tank = true,
	arrow_carbine = true,
	heavy_slashing_smiter = true,
	light_slashing_linesman_hs = true,
	arrow_machinegun = true,
	shot_shotgun = true,
	slashing_smiter = true,
	bolt_carbine = true,
	bolt_machinegun = true,
	stab_smiter = true,
	throwing_axe = true,
	heavy_blunt_fencer = true,
	stab_fencer = true,
	light_blunt_tank = true,
	slashing_linesman = true,
	blunt_fencer = true,
	light_slashing_smiter = true,
	slashing = true,
	light_blunt_smiter = true,
	blunt_smiter = true,
	shot_carbine = true,
	slashing_tank = true,
	cutting = true,
	heavy_slashing_linesman = true,
	burning_stab_fencer = true,
	light_stab_smiter = true
}

belakor.buff_templates = {
	orb_test_01 = {
		buffs = {
			{
				event = "on_kill",
				name = "orb_test_01",
				buff_func = "spawn_orb",
				orb_settings = {
					orb_name = "test_orb_01"
				}
			}
		}
	},
	orb_test_buff_01 = {
		activation_effect = "fx/screenspace_potion_02",
		buffs = {
			{
				name = "orb_test_buff_01",
				multiplier = 0.5,
				stat_buff = "attack_speed",
				duration = 2,
				max_stacks = 10,
				icon = "potion_buff_02",
				refresh_durations = true
			}
		}
	},
	belakor_shadow_lieutenant = {
		buffs = {
			{
				multiplier = 1.75,
				name = "belakor_shadow_lieutenant",
				stat_buff = "max_health",
				remove_buff_func = "remove_max_health_buff_for_ai",
				apply_buff_func = "apply_max_health_buff_for_ai",
				perks = {
					"anti_oneshot"
				}
			},
			{
				name = "belakor_shadow_lieutenant_material_objective_unit",
				buff_func = "remove_objective_unit",
				event = "on_death",
				remove_buff_func = "remove_objective_unit",
				apply_buff_func = "apply_objective_unit"
			},
			{
				event = "on_death",
				name = "belakor_shadow_lieutenant_drop_crystal",
				buff_func = "belakor_shadow_lieutenant_drop_crystal"
			}
		}
	},
	belakor_crystal_spawn_on_death = {
		buffs = {
			{
				event = "on_death",
				name = "belakor_crystal_spawn_on_death",
				buff_func = "belakor_crystal_drop",
				crystal_count = BelakorBalancing.totem_crystal_count
			}
		}
	},
	belakor_grey_wings = {
		create_parent_buff_shared_table = true,
		buffs = {
			{
				event = "on_damage_taken",
				name = "belakor_grey_wings",
				buff_func = "on_grey_wings_damage_taken",
				valid_damage_types = tbl_2
			},
			{
				min_dist_from_players_gap_closer = 3,
				name = "belakor_grey_wings_teleport_logic",
				min_distance_to_trigger_gap_closer_teleport = 10,
				teleport_effect = "fx/blk_grey_wings_teleport_01",
				remove_buff_func = "remove_belakor_grey_wings",
				teleport_effect_trail = "fx/blk_grey_wings_teleport_direction_01",
				min_teleport_distance_gap_closer = 3,
				teleport_delay = 0.5,
				teleport_cooldown = 1,
				teleport_available_buff = "belakor_grey_wings_teleport_available",
				max_teleport_distance_gap_closer = 6,
				apply_buff_func = "apply_belakor_grey_wings",
				max_teleport_distance = 13,
				min_teleport_distance = 7,
				find_valid_pos_attempts = 5,
				update_func = "update_belakor_grey_wings",
				min_dist_from_players = 5
			},
			{
				update_func = "update_belakor_grey_wings_teleport_trigger",
				name = "belakor_grey_wings_on_combo",
				max_distance_to_trigger_teleport_from_combo_attack = 5
			},
			{
				multiplier = 1,
				name = "belakor_grey_wings_health",
				stat_buff = "max_health",
				remove_buff_func = "remove_max_health_buff_for_ai",
				apply_buff_func = "apply_max_health_buff_for_ai"
			}
		}
	},
	belakor_grey_wings_teleport_available = {
		buffs = {
			{
				name = "belakor_grey_wings_teleport_available",
				perks = {
					scripts_unit_extensions_default_player_unit_buffs_settings_buff_perk_names.invulnerable_ranged
				}
			},
			{
				remove_buff_func = "remove_attach_particle",
				name = "belakor_grey_wings_particle",
				apply_buff_func = "apply_attach_particle",
				particle_fx = "fx/blk_grey_wings_01"
			}
		}
	},
	belakor_homing_skull_debuff = {
		buffs = {
			{
				name = "belakor_homing_skull_debuff",
				apply_buff_func = "apply_one_from_list",
				buff_list = {
					"belakor_homing_skull_debuff_delayed_stun_effect"
				}
			}
		}
	},
	belakor_homing_skull_debuff_delayed_stun = {
		buffs = {
			{
				buff_to_add = "belakor_homing_skull_debuff_delayed_stun_effect",
				name = "belakor_homing_skull_debuff_delayed_stun",
				is_cooldown = true,
				icon = "deus_curse_slaanesh_01",
				continuous_effect = "fx/screenspace_darkness_flash",
				remove_buff_func = "add_buff",
				priority_buff = true,
				debuff = true,
				max_stacks = 1,
				duration = 3
			}
		}
	},
	belakor_homing_skull_debuff_delayed_stun_effect = {
		deactivation_sound = "stop_curse_belakor_shadow_skulls_player_disabled",
		activation_sound = "play_curse_belakor_shadow_skulls_player_disabled_start",
		buffs = {
			{
				priority_buff = true,
				name = "belakor_homing_skull_debuff_delayed_stun_effect",
				debuff = true,
				icon = "deus_curse_belakor_02",
				apply_buff_func = "apply_homing_skull_achieve",
				continuous_effect = "fx/screenspace_darkness_flash",
				max_stacks = 1,
				duration = 2.5,
				perks = {
					scripts_unit_extensions_default_player_unit_buffs_settings_buff_perk_names.overpowered
				}
			},
			{
				particle_fx = "fx/skull_trap",
				name = "belakor_homing_skull_debuff_particle",
				offset_rotation_y = 90,
				duration = 2.5,
				remove_buff_func = "remove_attach_particle",
				apply_buff_func = "apply_attach_particle"
			}
		}
	},
	belakor_homing_skull_debuff_delayed_banish = {
		buffs = {
			{
				icon = "twitch_icon_vanishing_act",
				name = "belakor_homing_skull_debuff_delayed_banish",
				continuous_effect = "fx/screenspace_inside_plague_vortex",
				max_stacks = 1,
				duration = 5,
				priority_buff = true,
				debuff = true,
				perks = {
					scripts_unit_extensions_default_player_unit_buffs_settings_buff_perk_names.invulnerable
				}
			},
			{
				max_stacks = 1,
				name = "belakor_homing_skull_debuff_delayed_banish_stun",
				duration = 5,
				perks = {
					scripts_unit_extensions_default_player_unit_buffs_settings_buff_perk_names.overpowered
				}
			}
		}
	},
	belakor_cultists_buff = {
		buffs = {
			{
				multiplier = 0.25,
				name = "belakor_cultists_buff_damage",
				stat_buff = "damage_dealt"
			},
			{
				multiplier = 1.25,
				name = "belakor_cultists_buff_health",
				stat_buff = "max_health"
			},
			{
				remove_buff_func = "ai_update_max_health",
				name = "belakor_cultists_buff_health_update",
				apply_buff_func = "ai_update_max_health"
			},
			{
				remove_buff_func = "belakor_cultists_remove_eye_glow",
				name = "belakor_cultists_buff_eye_glow",
				apply_buff_func = "belakor_cultists_apply_eye_glow"
			},
			{
				multiplier = 1.1,
				name = "belakor_cultists_buff_stagger",
				stat_buff = "stagger_resistance"
			},
			{
				multiplier = 0.9,
				name = "belakor_cultists_buff_hit_mass",
				stat_buff = "hit_mass_amount"
			}
		}
	}
}
