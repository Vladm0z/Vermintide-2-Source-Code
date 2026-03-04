-- chunkname: @scripts/settings/equipment/weapon_templates/vs_warpfire_thrower_gun.lua

local var_0_0 = "dark_pact_action_one"
local var_0_1 = "dark_pact_action_one_release"
local var_0_2 = "dark_pact_action_one_hold"
local var_0_3 = "dark_pact_action_two"
local var_0_4 = "dark_pact_reload"
local var_0_5 = "dark_pact_reload_hold"
local var_0_6 = 2
local var_0_7 = 0.9
local var_0_8 = 0.1

local function var_0_9(arg_1_0, arg_1_1)
	if ScriptUnit.extension(arg_1_0, "status_system"):is_climbing() then
		return false
	end

	if ScriptUnit.extension(arg_1_0, "ghost_mode_system"):is_in_ghost_mode() then
		return false
	end

	return true
end

local var_0_10 = {
	actions = {
		[var_0_0] = {
			default = {
				disallow_ghost_mode = true,
				weapon_action_hand = "left",
				anim_end_event = "attack_finished",
				kind = "dummy",
				aim_assist_ramp_multiplier = 0.4,
				aim_assist_ramp_decay_delay = 0.3,
				anim_time_scale = 1,
				minimum_hold_time = 0.1,
				aim_assist_max_ramp_multiplier = 0.8,
				anim_event = "attack_shoot_start",
				anim_end_event_condition_func = function (arg_2_0, arg_2_1)
					return arg_2_1 ~= "new_interupting_action" and arg_2_1 ~= "action_complete"
				end,
				hold_input = var_0_2,
				fire_time = var_0_8,
				total_time = math.huge,
				buff_data = {
					{
						start_time = 0,
						external_multiplier = 0.75,
						buff_name = "planted_fast_decrease_movement"
					}
				},
				allowed_chain_actions = {
					{
						sub_action = "fire",
						auto_chain = true,
						start_time = var_0_8,
						action = var_0_0
					},
					{
						sub_action = "default",
						start_time = 0,
						hold_allowed = true,
						input = var_0_4,
						action = var_0_4
					}
				},
				enter_function = function (arg_3_0, arg_3_1, arg_3_2, arg_3_3)
					arg_3_1:clear_input_buffer()
					arg_3_1:reset_release_input()
					arg_3_3:change_synced_state("priming")
				end,
				finish_function = function (arg_4_0, arg_4_1, arg_4_2)
					arg_4_2:change_synced_state(nil)
				end,
				condition_func = function (arg_5_0, arg_5_1)
					if not var_0_9(arg_5_0, arg_5_1) then
						return false
					end

					return ScriptUnit.extension(arg_5_0, "overcharge_system"):get_overcharge_value() <= 0
				end
			},
			fire = {
				husk_fire_sound_event = "husk_warpfire_thrower_shoot_start",
				shoot_warpfire_max_flame_time = 5,
				overcharge_interval = 0.5,
				anim_end_event = "wind_up_start",
				kind = "warpfire_thrower",
				using_blob = true,
				damage_profile = "flamethrower_spray",
				close_attack_range = 7,
				husk_stop_sound_event = "husk_warpfire_thrower_shoot_end",
				buff_name_far = "vs_warpfire_thrower_long_distance_damage",
				no_headshot_sound = true,
				shoot_warpfire_close_attack_cooldown = 0.2,
				damage_interval = 0.25,
				fire_sound_event = "player_enemy_warpfire_thrower_shoot_start",
				anim_time_scale = 4,
				weapon_action_hand = "left",
				fire_sound_on_husk = true,
				particle_effect_flames = "fx/chr_warp_fire_flamethrower_01_1p_versus",
				disallow_ghost_mode = true,
				fire_time = 0,
				particle_effect_cooling = "fx/wpnfx_warpfire_gun_cooldown_1p",
				shoot_warpfire_minimum_forced_cooldown = 0.6,
				stop_sound_event = "player_enemy_warpfire_thrower_shoot_end",
				cooling_sound_event = "player_enemy_warpfire_steam_after_flame_start",
				aim_assist_max_ramp_multiplier = 0.8,
				aim_assist_ramp_decay_delay = 0.3,
				aim_assist_ramp_multiplier = 0.4,
				anim_event = "attack_shoot_start",
				fx_node = "p_fx",
				shoot_warpfire_attack_range = 10,
				is_spell = false,
				shoot_warpfire_close_attack_hit_radius = 1.5,
				particle_effect_flames_3p = "fx/chr_warp_fire_flamethrower_01",
				hit_effect = "fx/wpnfx_flamethrower_hit_01",
				shoot_warpfire_close_attack_dot = 0.9,
				overcharge_type = "vs_warpfire_thrower_normal",
				attack_range = 10,
				shoot_warpfire_close_attack_range = 7,
				buff_name_close = "vs_warpfire_thrower_short_distance_damage",
				particle_effect_impact = "fx/wpnfx_flamethrower_hit_01",
				anim_end_event_condition_func = function (arg_6_0, arg_6_1)
					return arg_6_1 ~= "new_interupting_action" and arg_6_1 ~= "action_complete"
				end,
				hold_input = var_0_2,
				total_time = math.huge,
				buff_data = {
					{
						start_time = 0,
						external_multiplier = 0.25,
						buff_name = "planted_decrease_movement"
					}
				},
				allowed_chain_actions = {
					{
						sub_action = "default",
						start_time = 0,
						input = var_0_4,
						action = var_0_4
					}
				},
				enter_function = function (arg_7_0, arg_7_1, arg_7_2, arg_7_3)
					arg_7_1:clear_input_buffer()
					arg_7_1:reset_release_input()
					arg_7_3:change_synced_state("shooting")
				end,
				finish_function = function (arg_8_0, arg_8_1, arg_8_2)
					if arg_8_1 ~= "new_interupting_action" then
						if arg_8_1 == "dead" then
							arg_8_2:change_synced_state(nil)
						else
							arg_8_2:change_synced_state("cooling_down")
						end
					end
				end
			}
		},
		[var_0_4] = {
			default = {
				charge_sound_stop_event = "stop_player_combat_weapon_staff_cooldown",
				disallow_ghost_mode = true,
				weapon_action_hand = "left",
				crosshair_style = "dot",
				kind = "charge",
				charge_sound_parameter_name = "drakegun_charge_fire",
				charge_effect_material_variable_name = "intensity",
				charge_sound_name = "player_enemy_warpfire_steam_after_flame_start",
				do_not_validate_with_hold = true,
				charge_effect_material_name = "Fire",
				uninterruptible = true,
				particle_effect_cooling = "fx/wpnfx_warpfire_gun_cooldown_1p",
				minimum_hold_time = 0.5,
				vent_overcharge = true,
				anim_end_event = "attack_finished",
				charge_sound_switch = "projectile_charge_sound",
				charge_time = 3,
				anim_event = "wind_up_start",
				anim_end_event_condition_func = function (arg_9_0, arg_9_1)
					return arg_9_1 ~= "new_interupting_action" and arg_9_1 ~= "action_complete"
				end,
				hold_input = var_0_5,
				total_time = math.huge,
				buff_data = {
					{
						start_time = 0,
						external_multiplier = 0.8,
						buff_name = "planted_fast_decrease_movement"
					}
				},
				enter_function = function (arg_10_0, arg_10_1, arg_10_2, arg_10_3)
					arg_10_1:reset_release_input()
					arg_10_1:clear_input_buffer()
					arg_10_3:change_synced_state("cooling_down")
				end,
				finish_function = function (arg_11_0, arg_11_1, arg_11_2)
					if arg_11_1 ~= "new_interupting_action" then
						arg_11_2:change_synced_state(nil)
					end
				end,
				allowed_chain_actions = {},
				condition_func = function (arg_12_0, arg_12_1)
					return ScriptUnit.extension(arg_12_0, "overcharge_system"):get_overcharge_value() > 0
				end,
				chain_condition_func = function (arg_13_0, arg_13_1)
					return ScriptUnit.extension(arg_13_0, "overcharge_system"):get_overcharge_value() > 0
				end
			}
		},
		action_inspect = ActionTemplates.action_inspect,
		action_wield = ActionTemplates.wield
	}
}

local function var_0_11(arg_14_0, arg_14_1, arg_14_2, arg_14_3)
	local var_14_0 = arg_14_2.current_action
	local var_14_1 = arg_14_2.muzzle_node
	local var_14_2 = Unit.world_position(arg_14_1, var_14_1)
	local var_14_3 = Unit.world_rotation(arg_14_1, var_14_1)
	local var_14_4 = arg_14_2.flamethrower_effect
	local var_14_5 = arg_14_2.flamethrower_effect_name
	local var_14_6 = World.physics_world(arg_14_3)
	local var_14_7 = "filter_in_line_of_sight_no_players_no_enemies"
	local var_14_8 = var_14_0.attack_range * 2
	local var_14_9 = Managers.state.network:game()
	local var_14_10 = Managers.state.unit_storage:go_id(arg_14_0)
	local var_14_11 = GameSession.game_object_field(var_14_9, var_14_10, "aim_direction")
	local var_14_12, var_14_13, var_14_14 = PhysicsWorld.raycast(var_14_6, var_14_2, var_14_11, var_14_8, "all", "types", "both", "closest", "collision_filter", var_14_7)

	var_14_14 = var_14_14 or var_14_8

	local var_14_15 = Quaternion.forward(var_14_3)
	local var_14_16 = World.find_particles_variable(arg_14_3, var_14_5, "firepoint_1")

	World.set_particles_variable(arg_14_3, var_14_4, var_14_16, var_14_2 - Vector3.up())

	local var_14_17 = var_14_2 + var_14_15 * var_14_14 - Vector3.up()
	local var_14_18 = World.find_particles_variable(arg_14_3, var_14_5, "firepoint_2")

	World.set_particles_variable(arg_14_3, var_14_4, var_14_18, var_14_17)

	local var_14_19 = World.find_particles_variable(arg_14_3, var_14_5, "firelife_1")
	local var_14_20 = var_14_14 / 4
	local var_14_21 = arg_14_2.particle_life_time
	local var_14_22 = var_14_21 and var_14_21:unbox() or Vector3(1, 0, 0)

	var_14_22.x = var_14_20

	World.set_particles_variable(arg_14_3, var_14_4, var_14_19, var_14_22)
end

var_0_10.synced_states = {
	priming = {
		enter = function (arg_15_0, arg_15_1, arg_15_2, arg_15_3, arg_15_4, arg_15_5)
			local var_15_0 = 0

			if arg_15_4 then
				Managers.state.vce:trigger_vce_unit(arg_15_1, arg_15_5, "player_enemy_vce_warpfire_shoot_start_sequence", arg_15_2, var_15_0)
			else
				Managers.state.vce:trigger_vce_unit(arg_15_1, arg_15_5, "husk_vce_warpfire_shoot_start_sequence", arg_15_2, var_15_0)
			end
		end,
		leave = function (arg_16_0, arg_16_1, arg_16_2, arg_16_3, arg_16_4, arg_16_5, arg_16_6, arg_16_7)
			if arg_16_6 ~= "shooting" and arg_16_1 and arg_16_4 then
				-- Nothing
			end
		end
	},
	shooting = {
		enter = function (arg_17_0, arg_17_1, arg_17_2, arg_17_3, arg_17_4, arg_17_5)
			local var_17_0 = var_0_10.actions.dark_pact_action_one.fire
			local var_17_1 = var_17_0.fx_node
			local var_17_2 = Unit.node(arg_17_2, var_17_1)
			local var_17_3 = Unit.world_position(arg_17_2, var_17_2)
			local var_17_4 = Unit.world_rotation(arg_17_2, var_17_2)
			local var_17_5 = var_17_0.particle_effect_flames
			local var_17_6 = World.create_particles(arg_17_5, var_17_5, var_17_3, var_17_4)

			World.link_particles(arg_17_5, var_17_6, arg_17_2, var_17_2, Matrix4x4.identity(), "destroy")

			if var_17_0.fire_sound_event then
				local var_17_7 = 0

				if arg_17_4 then
					WwiseUtils.trigger_unit_event(arg_17_5, "player_enemy_warpfire_thrower_shoot_end", arg_17_2, var_17_7)
					WwiseUtils.trigger_unit_event(arg_17_5, "player_enemy_warpfire_thrower_shoot_start", arg_17_2, var_17_7)
				else
					WwiseUtils.trigger_unit_event(arg_17_5, "husk_warpfire_thrower_shoot_end", arg_17_2, var_17_7)
					WwiseUtils.trigger_unit_event(arg_17_5, "husk_warpfire_thrower_shoot_start", arg_17_2, var_17_7)
				end
			end

			if arg_17_4 and not Managers.player:owner(arg_17_1).bot_player and not arg_17_3.rumble_effect_id then
				arg_17_3.rumble_effect_id = Managers.state.controller_features:add_effect("persistent_rumble", {
					rumble_effect = "reload_start"
				})
			end

			arg_17_3.flamethrower_effect_name = var_17_5
			arg_17_3.flamethrower_effect = var_17_6
			arg_17_3.muzzle_node = var_17_2
			arg_17_3.weapon_unit = arg_17_2
			arg_17_3.current_action = var_17_0
			arg_17_3.particle_life_time = Vector3Box(1, 0, 0)

			if arg_17_4 then
				arg_17_3.first_person_extension = ScriptUnit.extension(arg_17_1, "first_person_system")
			end
		end,
		update = function (arg_18_0, arg_18_1, arg_18_2, arg_18_3, arg_18_4, arg_18_5, arg_18_6)
			var_0_11(arg_18_1, arg_18_2, arg_18_3, arg_18_5)
		end,
		leave = function (arg_19_0, arg_19_1, arg_19_2, arg_19_3, arg_19_4, arg_19_5, arg_19_6, arg_19_7)
			if arg_19_4 and arg_19_3.rumble_effect_id then
				Managers.state.controller_features:stop_effect(arg_19_3.rumble_effect_id)

				arg_19_3.rumble_effect_id = nil
			end

			if not arg_19_7 and arg_19_3.flamethrower_effect then
				World.stop_spawning_particles(arg_19_5, arg_19_3.flamethrower_effect)
			end

			local var_19_0 = 0

			if Unit.alive(arg_19_2) then
				if arg_19_4 then
					WwiseUtils.trigger_unit_event(arg_19_5, "player_enemy_warpfire_thrower_shoot_end", arg_19_2, var_19_0)
				else
					WwiseUtils.trigger_unit_event(arg_19_5, "husk_warpfire_thrower_shoot_end", arg_19_2, var_19_0)
				end
			end

			if not arg_19_7 then
				if arg_19_4 then
					CharacterStateHelper.play_animation_event(arg_19_1, "wind_up_start")
					CharacterStateHelper.play_animation_event_first_person(arg_19_3.first_person_extension, "wind_up_start")
				else
					CharacterStateHelper.play_animation_event(arg_19_1, "wind_up_start")
				end
			end
		end
	},
	cooling_down = {
		enter = function (arg_20_0, arg_20_1, arg_20_2, arg_20_3, arg_20_4, arg_20_5)
			if arg_20_4 and arg_20_3.rumble_effect_id then
				Managers.state.controller_features:stop_effect(arg_20_3.rumble_effect_id)

				arg_20_3.rumble_effect_id = nil
			end

			local var_20_0 = var_0_10.actions.dark_pact_action_one.fire
			local var_20_1 = 0

			if arg_20_4 then
				WwiseUtils.trigger_unit_event(arg_20_5, var_20_0.stop_sound_event, arg_20_1, var_20_1)
			else
				WwiseUtils.trigger_unit_event(arg_20_5, var_20_0.husk_stop_sound_event, arg_20_1, var_20_1)
			end

			Unit.flow_event(arg_20_2, "wind_up_start")

			if Unit.alive(arg_20_1) then
				if arg_20_4 then
					arg_20_3.first_person_extension = ScriptUnit.extension(arg_20_1, "first_person_system")

					arg_20_3.first_person_extension:play_hud_sound_event(var_20_0.cooling_sound_event)
				end

				arg_20_3.overcharge_extension, arg_20_3.prev_overcharge = ScriptUnit.extension(arg_20_1, "overcharge_system"), math.huge
			end
		end,
		update = function (arg_21_0, arg_21_1, arg_21_2, arg_21_3, arg_21_4, arg_21_5, arg_21_6, arg_21_7)
			local var_21_0 = arg_21_3.overcharge_extension:get_overcharge_value()

			if var_21_0 <= 0 and arg_21_3.prev_overcharge ~= 0 and arg_21_4 then
				arg_21_7:change_synced_state(nil)
			else
				arg_21_3.prev_overcharge = var_21_0
			end
		end,
		leave = function (arg_22_0, arg_22_1, arg_22_2, arg_22_3, arg_22_4, arg_22_5, arg_22_6, arg_22_7)
			if Unit.alive(arg_22_1) then
				if arg_22_4 then
					CharacterStateHelper.play_animation_event_first_person(arg_22_3.first_person_extension, "cooldown_ready")
					CharacterStateHelper.play_animation_event(arg_22_1, "cooldown_ready")
				else
					CharacterStateHelper.play_animation_event(arg_22_1, "cooldown_ready")
				end
			end

			if arg_22_4 then
				WwiseUtils.trigger_unit_event(arg_22_5, "player_enemy_warpfire_steam_after_flame_stop", arg_22_2, 0)
				Unit.flow_event(arg_22_2, "cooldown_ready")
			else
				Unit.flow_event(arg_22_2, "cooldown_ready")
			end
		end
	}
}
var_0_10.left_hand_unit = "units/weapons/player/dark_pact/wpn_skaven_warpfiregun/wpn_skaven_warpfiregun"
var_0_10.right_hand_attachment_node_linking = nil
var_0_10.left_hand_attachment_node_linking = AttachmentNodeLinking.vs_warpfire_thrower_gun.left
var_0_10.display_unit = "units/weapons/weapon_display/display_1h_axes"
var_0_10.wield_anim = "idle"
var_0_10.buff_type = "RANGED"
var_0_10.weapon_type = "FIRE_STAFF"
var_0_10.max_fatigue_points = 6
var_0_10.dodge_count = 6
var_0_10.block_angle = 90
var_0_10.outer_block_angle = 360
var_0_10.block_fatigue_point_multiplier = 0.5
var_0_10.outer_block_fatigue_point_multiplier = 2
var_0_10.sound_event_block_within_arc = "weapon_foley_blunt_1h_block_wood"
var_0_10.crosshair_style = "shotgun"
var_0_10.default_spread_template = "vs_warpfire_thrower_gun"
var_0_10.buffs = {
	change_dodge_distance = {
		external_optional_multiplier = 1.2
	},
	change_dodge_speed = {
		external_optional_multiplier = 1.2
	}
}
var_0_10.overcharge_data = {
	max_value = 100,
	overcharge_threshold = 25,
	overcharge_value_decrease_rate = 10,
	time_until_overcharge_decreases = 0.1
}
var_0_10.attack_meta_data = {
	tap_attack = {
		arc = 0
	},
	hold_attack = {
		arc = 0
	}
}
var_0_10.aim_assist_settings = {
	max_range = 5,
	no_aim_input_multiplier = 0,
	vertical_only = true,
	base_multiplier = 0,
	effective_max_range = 4,
	breed_scalars = {
		skaven_storm_vermin = 1,
		skaven_clan_rat = 0.5,
		skaven_slave = 0.5
	}
}
var_0_10.weapon_diagram = {
	light_attack = {
		[DamageTypes.ARMOR_PIERCING] = 4,
		[DamageTypes.CLEAVE] = 1,
		[DamageTypes.SPEED] = 3,
		[DamageTypes.STAGGER] = 2,
		[DamageTypes.DAMAGE] = 5
	},
	heavy_attack = {
		[DamageTypes.ARMOR_PIERCING] = 5,
		[DamageTypes.CLEAVE] = 0,
		[DamageTypes.SPEED] = 3,
		[DamageTypes.STAGGER] = 2,
		[DamageTypes.DAMAGE] = 4
	}
}
var_0_10.tooltip_keywords = {
	"weapon_keyword_high_damage",
	"weapon_keyword_armour_piercing",
	"weapon_keyword_shield_breaking"
}
var_0_10.tooltip_compare = {
	light = {
		sub_action_name = "light_attack_left",
		action_name = var_0_0
	}
}
var_0_10.tooltip_detail = {
	light = {
		sub_action_name = "default",
		action_name = var_0_0
	}
}
var_0_10.wwise_dep_right_hand = {
	"wwise/one_handed_axes"
}

return {
	vs_warpfire_thrower_gun = var_0_10
}
