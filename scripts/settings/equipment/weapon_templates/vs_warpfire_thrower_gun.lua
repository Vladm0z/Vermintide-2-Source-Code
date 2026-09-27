-- chunkname: @scripts/settings/equipment/weapon_templates/vs_warpfire_thrower_gun.lua

local str = "dark_pact_action_one"
local str_2 = "dark_pact_action_one_release"
local str_3 = "dark_pact_action_one_hold"
local str_4 = "dark_pact_action_two"
local str_5 = "dark_pact_reload"
local str_6 = "dark_pact_reload_hold"
local num = 2
local num_2 = 0.9
local num_3 = 0.1

local function fn(arg_1_0, arg_1_1)
	-- function 1
	if not ScriptUnit.extension(arg_1_0, "status_system"):is_climbing() then
		return false
	end

	if not ScriptUnit.extension(arg_1_0, "ghost_mode_system"):is_in_ghost_mode() then
		return false
	end

	return true
end

local tbl = {
	actions = {
		[str] = {
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
					-- function 2
					return arg_2_1 == "new_interupting_action" or arg_2_1 ~= "action_complete"
				end,
				hold_input = str_3,
				fire_time = num_3,
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
						start_time = num_3,
						action = str
					},
					{
						sub_action = "default",
						start_time = 0,
						hold_allowed = true,
						input = str_5,
						action = str_5
					}
				},
				enter_function = function (arg_3_0, arg_3_1, arg_3_2, arg_3_3)
					-- function 3
					arg_3_1:clear_input_buffer()
					arg_3_1:reset_release_input()
					arg_3_3:change_synced_state("priming")
				end,
				finish_function = function (arg_4_0, arg_4_1, arg_4_2)
					-- function 4
					arg_4_2:change_synced_state(nil)
				end,
				condition_func = function (arg_5_0, arg_5_1)
					-- function 5
					if not fn(arg_5_0, arg_5_1) then
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
					-- function 6
					return arg_6_1 == "new_interupting_action" or arg_6_1 ~= "action_complete"
				end,
				hold_input = str_3,
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
						input = str_5,
						action = str_5
					}
				},
				enter_function = function (arg_7_0, arg_7_1, arg_7_2, arg_7_3)
					-- function 7
					arg_7_1:clear_input_buffer()
					arg_7_1:reset_release_input()
					arg_7_3:change_synced_state("shooting")
				end,
				finish_function = function (arg_8_0, arg_8_1, arg_8_2)
					-- function 8
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
		[str_5] = {
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
					-- function 9
					return arg_9_1 == "new_interupting_action" or arg_9_1 ~= "action_complete"
				end,
				hold_input = str_6,
				total_time = math.huge,
				buff_data = {
					{
						start_time = 0,
						external_multiplier = 0.8,
						buff_name = "planted_fast_decrease_movement"
					}
				},
				enter_function = function (arg_10_0, arg_10_1, arg_10_2, arg_10_3)
					-- function 10
					arg_10_1:reset_release_input()
					arg_10_1:clear_input_buffer()
					arg_10_3:change_synced_state("cooling_down")
				end,
				finish_function = function (arg_11_0, arg_11_1, arg_11_2)
					-- function 11
					if arg_11_1 ~= "new_interupting_action" then
						arg_11_2:change_synced_state(nil)
					end
				end,
				allowed_chain_actions = {},
				condition_func = function (arg_12_0, arg_12_1)
					-- function 12
					return ScriptUnit.extension(arg_12_0, "overcharge_system"):get_overcharge_value() > 0
				end,
				chain_condition_func = function (arg_13_0, arg_13_1)
					-- function 13
					return ScriptUnit.extension(arg_13_0, "overcharge_system"):get_overcharge_value() > 0
				end
			}
		},
		action_inspect = ActionTemplates.action_inspect,
		action_wield = ActionTemplates.wield
	}
}

local function fn_2(arg_14_0, arg_14_1, arg_14_2, arg_14_3)
	-- function 14
	local current_action = arg_14_2.current_action
	local muzzle_node = arg_14_2.muzzle_node
	local world_position = Unit.world_position(arg_14_1, muzzle_node)
	local world_rotation = Unit.world_rotation(arg_14_1, muzzle_node)
	local flamethrower_effect = arg_14_2.flamethrower_effect
	local flamethrower_effect_name = arg_14_2.flamethrower_effect_name
	local physics_world = World.physics_world(arg_14_3)
	local str = "filter_in_line_of_sight_no_players_no_enemies"
	local num = current_action.attack_range * 2
	local game = Managers.state.network:game()
	local go_id = Managers.state.unit_storage:go_id(arg_14_0)
	local game_object_field = GameSession.game_object_field(game, go_id, "aim_direction")
	local raycast, var_14_13, var_14_14 = PhysicsWorld.raycast(physics_world, world_position, game_object_field, num, "all", "types", "both", "closest", "collision_filter", str)

	var_14_14 = var_14_14 or num

	local forward = Quaternion.forward(world_rotation)
	local find_particles_variable = World.find_particles_variable(arg_14_3, flamethrower_effect_name, "firepoint_1")

	World.set_particles_variable(arg_14_3, flamethrower_effect, find_particles_variable, world_position - Vector3.up())

	local num_2 = world_position + forward * var_14_14 - Vector3.up()
	local find_particles_variable_2 = World.find_particles_variable(arg_14_3, flamethrower_effect_name, "firepoint_2")

	World.set_particles_variable(arg_14_3, flamethrower_effect, find_particles_variable_2, num_2)

	local find_particles_variable_3 = World.find_particles_variable(arg_14_3, flamethrower_effect_name, "firelife_1")
	local num_3 = var_14_14 / 4
	local particle_life_time = arg_14_2.particle_life_time
	local unbox

	if not particle_life_time then
		unbox = particle_life_time:unbox()

		if not unbox then
			-- Nothing
		end
	end

	unbox = Vector3(1, 0, 0)

	::label_14_0::

	unbox.x = num_3

	World.set_particles_variable(arg_14_3, flamethrower_effect, find_particles_variable_3, unbox)
end

tbl.synced_states = {
	priming = {
		enter = function (arg_15_0, arg_15_1, arg_15_2, arg_15_3, arg_15_4, arg_15_5)
			-- function 15
			local num = 0

			if not arg_15_4 then
				Managers.state.vce:trigger_vce_unit(arg_15_1, arg_15_5, "player_enemy_vce_warpfire_shoot_start_sequence", arg_15_2, num)
			else
				Managers.state.vce:trigger_vce_unit(arg_15_1, arg_15_5, "husk_vce_warpfire_shoot_start_sequence", arg_15_2, num)
			end
		end,
		leave = function (arg_16_0, arg_16_1, arg_16_2, arg_16_3, arg_16_4, arg_16_5, arg_16_6, arg_16_7)
			-- function 16
			if (arg_16_6 == "shooting" or not arg_16_1) and not arg_16_4 then
				-- Nothing
			end
		end
	},
	shooting = {
		enter = function (arg_17_0, arg_17_1, arg_17_2, arg_17_3, arg_17_4, arg_17_5)
			-- function 17
			local fire = tbl.actions.dark_pact_action_one.fire
			local fx_node = fire.fx_node
			local node = Unit.node(arg_17_2, fx_node)
			local world_position = Unit.world_position(arg_17_2, node)
			local world_rotation = Unit.world_rotation(arg_17_2, node)
			local particle_effect_flames = fire.particle_effect_flames
			local create_particles = World.create_particles(arg_17_5, particle_effect_flames, world_position, world_rotation)

			World.link_particles(arg_17_5, create_particles, arg_17_2, node, Matrix4x4.identity(), "destroy")

			if not fire.fire_sound_event then
				local num = 0

				if not arg_17_4 then
					WwiseUtils.trigger_unit_event(arg_17_5, "player_enemy_warpfire_thrower_shoot_end", arg_17_2, num)
					WwiseUtils.trigger_unit_event(arg_17_5, "player_enemy_warpfire_thrower_shoot_start", arg_17_2, num)
				else
					WwiseUtils.trigger_unit_event(arg_17_5, "husk_warpfire_thrower_shoot_end", arg_17_2, num)
					WwiseUtils.trigger_unit_event(arg_17_5, "husk_warpfire_thrower_shoot_start", arg_17_2, num)
				end
			end

			if not (not arg_17_4 and Managers.player:owner(arg_17_1).bot_player or arg_17_3.rumble_effect_id) then
				arg_17_3.rumble_effect_id = Managers.state.controller_features:add_effect("persistent_rumble", {
					rumble_effect = "reload_start"
				})
			end

			arg_17_3.flamethrower_effect_name = particle_effect_flames
			arg_17_3.flamethrower_effect = create_particles
			arg_17_3.muzzle_node = node
			arg_17_3.weapon_unit = arg_17_2
			arg_17_3.current_action = fire
			arg_17_3.particle_life_time = Vector3Box(1, 0, 0)

			if not arg_17_4 then
				arg_17_3.first_person_extension = ScriptUnit.extension(arg_17_1, "first_person_system")
			end
		end,
		update = function (arg_18_0, arg_18_1, arg_18_2, arg_18_3, arg_18_4, arg_18_5, arg_18_6)
			-- function 18
			fn_2(arg_18_1, arg_18_2, arg_18_3, arg_18_5)
		end,
		leave = function (arg_19_0, arg_19_1, arg_19_2, arg_19_3, arg_19_4, arg_19_5, arg_19_6, arg_19_7)
			-- function 19
			if not arg_19_4 and not arg_19_3.rumble_effect_id then
				Managers.state.controller_features:stop_effect(arg_19_3.rumble_effect_id)

				arg_19_3.rumble_effect_id = nil
			end

			if arg_19_7 or not arg_19_3.flamethrower_effect then
				World.stop_spawning_particles(arg_19_5, arg_19_3.flamethrower_effect)
			end

			local num = 0

			if not Unit.alive(arg_19_2) then
				if not arg_19_4 then
					WwiseUtils.trigger_unit_event(arg_19_5, "player_enemy_warpfire_thrower_shoot_end", arg_19_2, num)
				else
					WwiseUtils.trigger_unit_event(arg_19_5, "husk_warpfire_thrower_shoot_end", arg_19_2, num)
				end
			end

			if not arg_19_7 then
				if not arg_19_4 then
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
			-- function 20
			if not arg_20_4 and not arg_20_3.rumble_effect_id then
				Managers.state.controller_features:stop_effect(arg_20_3.rumble_effect_id)

				arg_20_3.rumble_effect_id = nil
			end

			local fire = tbl.actions.dark_pact_action_one.fire
			local num = 0

			if not arg_20_4 then
				WwiseUtils.trigger_unit_event(arg_20_5, fire.stop_sound_event, arg_20_1, num)
			else
				WwiseUtils.trigger_unit_event(arg_20_5, fire.husk_stop_sound_event, arg_20_1, num)
			end

			Unit.flow_event(arg_20_2, "wind_up_start")

			if not Unit.alive(arg_20_1) then
				if not arg_20_4 then
					arg_20_3.first_person_extension = ScriptUnit.extension(arg_20_1, "first_person_system")

					arg_20_3.first_person_extension:play_hud_sound_event(fire.cooling_sound_event)
				end

				arg_20_3.overcharge_extension, arg_20_3.prev_overcharge = ScriptUnit.extension(arg_20_1, "overcharge_system"), math.huge
			end
		end,
		update = function (arg_21_0, arg_21_1, arg_21_2, arg_21_3, arg_21_4, arg_21_5, arg_21_6, arg_21_7)
			-- function 21
			local get_overcharge_value = arg_21_3.overcharge_extension:get_overcharge_value()

			if not (get_overcharge_value <= 0) or arg_21_3.prev_overcharge == 0 or not arg_21_4 then
				arg_21_7:change_synced_state(nil)
			else
				arg_21_3.prev_overcharge = get_overcharge_value
			end
		end,
		leave = function (arg_22_0, arg_22_1, arg_22_2, arg_22_3, arg_22_4, arg_22_5, arg_22_6, arg_22_7)
			-- function 22
			if not Unit.alive(arg_22_1) then
				if not arg_22_4 then
					CharacterStateHelper.play_animation_event_first_person(arg_22_3.first_person_extension, "cooldown_ready")
					CharacterStateHelper.play_animation_event(arg_22_1, "cooldown_ready")
				else
					CharacterStateHelper.play_animation_event(arg_22_1, "cooldown_ready")
				end
			end

			if not arg_22_4 then
				WwiseUtils.trigger_unit_event(arg_22_5, "player_enemy_warpfire_steam_after_flame_stop", arg_22_2, 0)
				Unit.flow_event(arg_22_2, "cooldown_ready")
			else
				Unit.flow_event(arg_22_2, "cooldown_ready")
			end
		end
	}
}
tbl.left_hand_unit = "units/weapons/player/dark_pact/wpn_skaven_warpfiregun/wpn_skaven_warpfiregun"
tbl.right_hand_attachment_node_linking = nil
tbl.left_hand_attachment_node_linking = AttachmentNodeLinking.vs_warpfire_thrower_gun.left
tbl.display_unit = "units/weapons/weapon_display/display_1h_axes"
tbl.wield_anim = "idle"
tbl.buff_type = "RANGED"
tbl.weapon_type = "FIRE_STAFF"
tbl.max_fatigue_points = 6
tbl.dodge_count = 6
tbl.block_angle = 90
tbl.outer_block_angle = 360
tbl.block_fatigue_point_multiplier = 0.5
tbl.outer_block_fatigue_point_multiplier = 2
tbl.sound_event_block_within_arc = "weapon_foley_blunt_1h_block_wood"
tbl.crosshair_style = "shotgun"
tbl.default_spread_template = "vs_warpfire_thrower_gun"
tbl.buffs = {
	change_dodge_distance = {
		external_optional_multiplier = 1.2
	},
	change_dodge_speed = {
		external_optional_multiplier = 1.2
	}
}
tbl.overcharge_data = {
	max_value = 100,
	overcharge_threshold = 25,
	overcharge_value_decrease_rate = 10,
	time_until_overcharge_decreases = 0.1
}
tbl.attack_meta_data = {
	tap_attack = {
		arc = 0
	},
	hold_attack = {
		arc = 0
	}
}
tbl.aim_assist_settings = {
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
tbl.weapon_diagram = {
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
tbl.tooltip_keywords = {
	"weapon_keyword_high_damage",
	"weapon_keyword_armour_piercing",
	"weapon_keyword_shield_breaking"
}
tbl.tooltip_compare = {
	light = {
		sub_action_name = "light_attack_left",
		action_name = str
	}
}
tbl.tooltip_detail = {
	light = {
		sub_action_name = "default",
		action_name = str
	}
}
tbl.wwise_dep_right_hand = {
	"wwise/one_handed_axes"
}

return {
	vs_warpfire_thrower_gun = tbl
}
