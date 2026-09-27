-- chunkname: @scripts/settings/equipment/weapon_templates/vs_ratling_gunner_gun.lua

local str = "dark_pact_action_one"
local str_2 = "dark_pact_action_one_release"
local str_3 = "dark_pact_action_one_hold"
local str_4 = "dark_pact_action_two"
local str_5 = "dark_pact_reload"
local num = 1
local num_2 = 0.2
local num_3 = 15
local num_4 = 20
local num_5 = 3
local num_6 = 120
local num_7 = 4
local num_8 = 2.1666666666666665 / num
local num_9 = 1 / num
local num_10 = (num_4 - num_3) / num_5

local function fn(arg_1_0, arg_1_1, arg_1_2)
	-- function 1
	if not ScriptUnit.extension(arg_1_0, "status_system"):is_climbing() then
		return false
	end

	if not ScriptUnit.extension(arg_1_0, "ghost_mode_system"):is_in_ghost_mode() then
		return false
	end

	return not arg_1_2 and arg_1_2:ammo_count() > 0
end

local function fn_2(arg_2_0, arg_2_1, arg_2_2)
	-- function 2
	if not ScriptUnit.extension(arg_2_0, "status_system"):is_climbing() then
		return false
	end

	return not arg_2_2 and arg_2_2:can_reload()
end

local function fn_3(arg_3_0, arg_3_1)
	-- function 3
	local ammo_count = ScriptUnit.extension(arg_3_1, "ammo_system"):ammo_count()

	Managers.state.event:trigger("on_dark_pact_ammo_changed", arg_3_0, ammo_count)
end

local tbl = {
	actions = {
		[str] = {
			default = {
				charge_sound_stop_event = "Stop_player_engineer_engine_loop",
				charge_sound_name = "Play_player_engineer_engine_charge",
				kind = "minigun_spin",
				reload_when_out_of_ammo = true,
				windup_max = 1,
				disallow_ghost_mode = true,
				initial_windup = 0,
				windup_start_on_zero = true,
				charge_sound_husk_name = "Play_player_engineer_engine_charge_husk",
				weapon_action_hand = "left",
				anim_event = "attack_shoot_start",
				charge_sound_husk_stop_event = "Stop_player_engineer_engine_loop_husk",
				anim_time_scale = num_8,
				enter_function = function (arg_4_0, arg_4_1, arg_4_2, arg_4_3)
					-- function 4
					arg_4_1:clear_input_buffer()
					arg_4_1:reset_release_input()
					arg_4_3:change_synced_state("winding")
				end,
				finish_function = function (arg_5_0, arg_5_1, arg_5_2)
					-- function 5
					if arg_5_1 ~= "new_interupting_action" then
						arg_5_2:change_synced_state(nil)
					end
				end,
				total_time = num * num_8,
				hold_input = str_3,
				buff_data = {
					{
						start_time = 0,
						external_multiplier = 0.35,
						buff_name = "planted_fast_decrease_movement",
						end_time = math.huge
					}
				},
				allowed_chain_actions = {
					{
						sub_action = "fire",
						auto_chain = true,
						start_time = num * num_8,
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
				condition_func = fn,
				windup_speed = num_9
			},
			fire = {
				looping_anim = true,
				rps_loss_per_second = 1.5,
				kind = "minigun",
				weapon_action_hand = "left",
				spread_template_override = "vs_ratling_gunner_gun_shooting",
				disallow_ghost_mode = true,
				hit_effect = "bullet_impact",
				critical_hit_effect = "bullet_critical_impact",
				dont_shoot_near_wall = true,
				ammo_usage = 1,
				near_wall_anim = "",
				power_level = 100,
				shot_count = 1,
				hold_input = str_3,
				chain_condition_func = fn,
				enter_function = function (arg_6_0, arg_6_1, arg_6_2, arg_6_3)
					-- function 6
					arg_6_1:reset_release_input()
					arg_6_1:clear_input_buffer()
					arg_6_3:change_synced_state("firing")
				end,
				finish_function = function (arg_7_0, arg_7_1, arg_7_2)
					-- function 7
					arg_7_2:change_synced_state(nil)
				end,
				initial_rounds_per_second = num_3,
				max_rps = num_4,
				rps_gain_per_shot = num_10,
				total_time = math.huge,
				buff_data = {
					{
						start_time = 0,
						external_multiplier = 0.4,
						buff_name = "planted_fast_decrease_movement",
						end_time = math.huge
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
				lightweight_projectile_info = {
					collision_filter = "filter_enemy_player_afro_ray_projectile",
					template_name = "ratling_gunner_vs"
				}
			}
		},
		[str_5] = {
			default = {
				anim_end_event = "cooldown_ready",
				weapon_action_hand = "either",
				kind = "dummy",
				crosshair_style = "dot",
				anim_event = "wind_up_start",
				condition_func = fn_2,
				chain_condition_func = fn_2,
				enter_function = function (arg_8_0, arg_8_1, arg_8_2, arg_8_3)
					-- function 8
					arg_8_3:change_synced_state("reloading")

					local wwise_world = Managers.world:wwise_world(arg_8_3.world)

					WwiseWorld.trigger_event(wwise_world, "Play_player_ratling_gunner_weapon_reload")
				end,
				finish_function = function (arg_9_0, arg_9_1, arg_9_2)
					-- function 9
					arg_9_2:change_synced_state(nil)

					local wwise_world = Managers.world:wwise_world(arg_9_2.world)

					WwiseWorld.trigger_event(wwise_world, "Stop_player_ratling_gunner_weapon_reload")

					if arg_9_1 == "action_complete" then
						ScriptUnit.extension(arg_9_2.unit, "ammo_system"):add_ammo()
						fn_3(arg_9_0, arg_9_2.unit)
					end
				end,
				total_time = num_7,
				buff_data = {
					{
						start_time = 0,
						external_multiplier = 0.6,
						buff_name = "planted_fast_decrease_movement",
						end_time = math.huge
					}
				},
				allowed_chain_actions = {
					{
						sub_action = "default",
						start_time = 0,
						input = str_4,
						action = str_4
					}
				}
			}
		},
		[str_4] = {
			default = {
				weapon_action_hand = "left",
				kind = "dummy",
				total_time = 0,
				allowed_chain_actions = {},
				enter_function = function (arg_10_0, arg_10_1)
					-- function 10
					arg_10_1:clear_input_buffer()

					return arg_10_1:reset_release_input()
				end
			}
		},
		action_wield = ActionTemplates.wield
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
tbl.crosshair_style = "default"
tbl.default_spread_template = "vs_ratling_gunner_gun"
tbl.buffs = {
	change_dodge_distance = {
		external_optional_multiplier = 1.2
	},
	change_dodge_speed = {
		external_optional_multiplier = 1.2
	}
}
tbl.custom_data = {
	windup = 0,
	reload_progress = 0,
	windup_loss_per_second = num_2
}

tbl.update = function (self, arg_11_1, arg_11_2)
	-- function 11
	local num = self:get_custom_data("windup") - self:get_custom_data("windup_loss_per_second") * arg_11_1

	self:set_custom_data("windup", num)
end

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

local function fn_4(self, arg_12_1, arg_12_2)
	-- function 12
	local str = "fire"
	local ability_id = self:ability_id(str)
	local get_activated_ability_data = self:get_activated_ability_data(ability_id)
	local extension = ScriptUnit.extension(arg_12_1, "weapon_system")

	get_activated_ability_data.priming_progress = arg_12_2 or extension:get_custom_data("windup")
end

tbl.synced_states = {
	winding = {
		clear_data_on_enter = true,
		enter = function (arg_13_0, arg_13_1, arg_13_2, arg_13_3, arg_13_4, arg_13_5)
			-- function 13
			local wwise_world = Managers.world:wwise_world(arg_13_5)

			if not arg_13_4 then
				WwiseWorld.trigger_event(wwise_world, "Play_player_ratling_gunner_weapon_ready", arg_13_2)
			end
		end,
		update = function (arg_14_0, arg_14_1, arg_14_2, arg_14_3, arg_14_4, arg_14_5, arg_14_6)
			-- function 14
			if not arg_14_4 then
				return
			end

			local extension = ScriptUnit.extension(arg_14_1, "career_system")
			local str = "fire"
			local ability_id = extension:ability_id(str)

			extension:get_activated_ability_data(ability_id).priming_progress = ScriptUnit.extension(arg_14_2, "weapon_system"):get_custom_data("windup")

			fn_4(extension, arg_14_2)
		end,
		leave = function (arg_15_0, arg_15_1, arg_15_2, arg_15_3, arg_15_4, arg_15_5, arg_15_6, arg_15_7)
			-- function 15
			local wwise_world = Managers.world:wwise_world(arg_15_5)

			if not arg_15_4 then
				WwiseWorld.trigger_event(wwise_world, "Stop_player_ratling_gunner_weapon_ready", arg_15_2)

				if not arg_15_7 then
					local extension = ScriptUnit.extension(arg_15_1, "career_system")

					fn_4(extension, arg_15_2, 0)
				end
			end

			if not (arg_15_7 or arg_15_6 == "firing") then
				if not arg_15_4 then
					local extension_2 = ScriptUnit.extension(arg_15_1, "first_person_system")

					CharacterStateHelper.play_animation_event_first_person(extension_2, "attack_finished")
					CharacterStateHelper.play_animation_event_first_person(extension_2, "barrel_spin_finished")
				end

				Unit.animation_event(arg_15_1, "no_anim_upperbody")
				Unit.animation_event(arg_15_1, "to_combat")
				Unit.animation_event(arg_15_1, "idle")
			end
		end
	},
	firing = {
		enter = function (arg_16_0, arg_16_1, arg_16_2, arg_16_3, arg_16_4, arg_16_5)
			-- function 16
			arg_16_3.shoot_time = 0

			local flag = true
			local num = 0
			local make_unit_auto_source, var_16_3 = WwiseUtils.make_unit_auto_source(arg_16_5, arg_16_2, num)

			if not arg_16_4 then
				Managers.state.vce:trigger_vce(arg_16_1, var_16_3, "Play_player_enemy_vce_ratling_gunner_shoot_start", flag, make_unit_auto_source)
				WwiseWorld.trigger_event(var_16_3, "Play_player_ratling_gunner_shooting_loop", flag, make_unit_auto_source)
			else
				Managers.state.vce:trigger_vce(arg_16_1, var_16_3, "Play_player_enemy_vce_ratling_gunner_shoot_start_husk", flag, make_unit_auto_source)
				WwiseWorld.trigger_event(var_16_3, "Play_ratling_gunner_shooting_loop", flag, make_unit_auto_source)
			end

			WwiseWorld.set_source_parameter(var_16_3, make_unit_auto_source, "ratling_gun_shooting_loop_parameter", 0)

			arg_16_3.shoot_sound_source_id = make_unit_auto_source
		end,
		update = function (arg_17_0, arg_17_1, arg_17_2, arg_17_3, arg_17_4, arg_17_5, arg_17_6)
			-- function 17
			if not arg_17_4 then
				fn_3(arg_17_1, arg_17_2)
			end

			if arg_17_3.shoot_time > num_5 then
				return
			end

			arg_17_3.shoot_time = arg_17_3.shoot_time + arg_17_6

			local shoot_sound_source_id = arg_17_3.shoot_sound_source_id
			local num = arg_17_3.shoot_time / num_5
			local wwise_world = Managers.world:wwise_world(arg_17_5)

			WwiseWorld.set_source_parameter(wwise_world, shoot_sound_source_id, "ratling_gun_shooting_loop_parameter", num)
		end,
		leave = function (arg_18_0, arg_18_1, arg_18_2, arg_18_3, arg_18_4, arg_18_5, arg_18_6, arg_18_7)
			-- function 18
			if not arg_18_7 then
				if not arg_18_4 then
					local extension = ScriptUnit.extension(arg_18_1, "first_person_system")

					CharacterStateHelper.play_animation_event_first_person(extension, "attack_finished")
					fn_3(arg_18_1, arg_18_2)
				end

				Unit.animation_event(arg_18_1, "no_anim_upperbody")
				Unit.animation_event(arg_18_1, "to_combat")
			end

			local wwise_world = Managers.world:wwise_world(arg_18_5)

			if not arg_18_4 then
				WwiseWorld.trigger_event(wwise_world, "Stop_player_ratling_gunner_shooting_loop", arg_18_2)
			else
				WwiseWorld.trigger_event(wwise_world, "Stop_ratling_gunner_shooting_loop", arg_18_2)
			end

			arg_18_3.shoot_sound_source_id = nil
			arg_18_3.shoot_time = nil
		end
	},
	reloading = {
		enter = function (arg_19_0, arg_19_1, arg_19_2, arg_19_3, arg_19_4, arg_19_5)
			-- function 19
			if not arg_19_4 then
				arg_19_3.time_in_reload = 0
			end

			local owner = Managers.player:owner(arg_19_1)

			if owner.remote or not owner.bot_player then
				local wwise_world = Managers.world:wwise_world(arg_19_5)

				WwiseWorld.trigger_event(wwise_world, "Play_player_ratling_gunner_weapon_reload_husk", arg_19_2)
			end
		end,
		update = function (arg_20_0, arg_20_1, arg_20_2, arg_20_3, arg_20_4, arg_20_5, arg_20_6)
			-- function 20
			if not arg_20_4 then
				return
			end

			arg_20_3.time_in_reload = arg_20_3.time_in_reload + arg_20_6

			local num = arg_20_3.time_in_reload / num_7

			ScriptUnit.extension(arg_20_2, "weapon_system"):set_custom_data("reload_progress", num)
		end,
		leave = function (arg_21_0, arg_21_1, arg_21_2, arg_21_3, arg_21_4, arg_21_5, arg_21_6, arg_21_7)
			-- function 21
			if not arg_21_7 then
				if not arg_21_4 then
					ScriptUnit.extension(arg_21_2, "weapon_system"):set_custom_data("reload_progress", 0)
				end

				local owner = Managers.player:owner(arg_21_1)

				if owner.remote or not owner.bot_player then
					Unit.animation_event(arg_21_1, "no_anim_upperbody")
					Unit.animation_event(arg_21_1, "to_combat")
					Unit.animation_event(arg_21_1, "idle")

					local wwise_world = Managers.world:wwise_world(arg_21_5)

					WwiseWorld.trigger_event(wwise_world, "Stop_player_ratling_gunner_weapon_reload_husk", arg_21_2)
				end
			end
		end
	}
}
tbl.left_hand_attachment_node_linking = AttachmentNodeLinking.vs_ratling_gunner_gun.left
tbl.ammo_data = {
	ammo_immediately_available = true,
	play_reload_anim_on_wield_reload = true,
	ammo_hand = "left",
	infinite_ammo = true,
	reload_time = 0,
	ammo_per_reload = num_6,
	starting_reserve_ammo = num_6,
	ammo_per_clip = num_6,
	max_ammo = num_6
}

return {
	vs_ratling_gunner_gun = tbl
}
