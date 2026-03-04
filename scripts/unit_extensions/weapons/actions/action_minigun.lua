-- chunkname: @scripts/unit_extensions/weapons/actions/action_minigun.lua

ActionMinigun = class(ActionMinigun, ActionRangedBase)

local var_0_0 = require("scripts/unit_extensions/default_player_unit/buffs/settings/buff_perk_names")
local var_0_1 = 1
local var_0_2 = 1.2
local var_0_3 = 3
local var_0_4 = 2
local var_0_5 = 6
local var_0_6 = 3
local var_0_7 = 10
local var_0_8 = Unit.set_flow_variable
local var_0_9 = Unit.flow_event

function ActionMinigun.init(arg_1_0, arg_1_1, arg_1_2, arg_1_3, arg_1_4, arg_1_5, arg_1_6, arg_1_7, arg_1_8)
	ActionMinigun.super.init(arg_1_0, arg_1_1, arg_1_2, arg_1_3, arg_1_4, arg_1_5, arg_1_6, arg_1_7, arg_1_8)

	arg_1_0.career_extension = ScriptUnit.extension(arg_1_4, "career_system")
	arg_1_0.buff_extension = ScriptUnit.extension(arg_1_4, "buff_system")
	arg_1_0.weapon_extension = ScriptUnit.extension(arg_1_7, "weapon_system")
	arg_1_0.ai_bot_group_system = Managers.state.entity:system("ai_bot_group_system")
	arg_1_0._attack_speed_anim_var_3p = Unit.animation_find_variable(arg_1_4, "attack_speed")
	arg_1_0._time_to_shoot = 0
	arg_1_0._last_avoidance_t = 0
	arg_1_0._free_ammo_t = 0
	arg_1_0._ranged_attack = true
	arg_1_0._num_extra_shots = 0
end

function ActionMinigun.client_owner_start_action(arg_2_0, arg_2_1, arg_2_2, arg_2_3, arg_2_4, arg_2_5)
	local var_2_0 = arg_2_0._time_to_shoot

	ActionMinigun.super.client_owner_start_action(arg_2_0, arg_2_1, arg_2_2, arg_2_3, arg_2_4)

	arg_2_0._visual_heat_generation = arg_2_1.visual_heat_generation or 0
	arg_2_0._base_anim_speed = arg_2_1.base_anim_speed or 1
	arg_2_0._shot_cost = arg_2_1.ammo_usage
	arg_2_0._calculated_attack_speed = false
	arg_2_0._initial_rounds_per_second = arg_2_1.initial_rounds_per_second
	arg_2_0._max_rps = arg_2_1.max_rps
	arg_2_0._rps_loss_per_second = arg_2_1.rps_loss_per_second
	arg_2_0._rps_gain_per_shot = arg_2_1.rps_gain_per_shot
	arg_2_0._projectiles_per_shot = arg_2_1.shot_count
	arg_2_0._use_ability_as_ammo = arg_2_1.use_ability_as_ammo
	arg_2_0._check_near_wall = arg_2_1.dont_shoot_near_wall
	arg_2_0._near_wall = false

	local var_2_1 = math.clamp(arg_2_0.weapon_extension:get_custom_data("windup"), 0, 1)

	arg_2_0._current_rps = math.lerp(arg_2_0._initial_rounds_per_second, arg_2_0._max_rps, var_2_1)
	arg_2_0._attack_speed_mod = 1
	arg_2_0._ammo_expended = 0
	arg_2_0.extra_buff_shot = false

	arg_2_0:_update_attack_speed(arg_2_2)

	arg_2_0._time_to_shoot = math.max(var_2_0, arg_2_2 - 1 / arg_2_0._current_rps)
	arg_2_0._first_shot = true

	local var_2_2 = arg_2_1.fire_loop_start

	if var_2_2 then
		arg_2_0.first_person_extension:play_hud_sound_event(var_2_2)
	end

	arg_2_0:_play_vo()
end

function ActionMinigun._update_attack_speed(arg_3_0, arg_3_1)
	if not arg_3_0._calculated_attack_speed then
		arg_3_0._attack_speed_mod = ActionUtils.get_action_time_scale(arg_3_0.owner_unit, arg_3_0.current_action)

		arg_3_0:_update_animation_speed(arg_3_0._current_rps * arg_3_0._attack_speed_mod)

		arg_3_0._calculated_attack_speed = true
	end
end

function ActionMinigun._waiting_to_shoot(arg_4_0, arg_4_1, arg_4_2)
	arg_4_0:_update_animation_speed(arg_4_0._current_rps)

	if arg_4_0._check_near_wall then
		arg_4_0:_update_near_wall()
	end

	if arg_4_0._near_wall then
		arg_4_0._time_to_shoot = arg_4_2 - 1 / arg_4_0._current_rps
	elseif not arg_4_0._near_wall and arg_4_2 >= arg_4_0._time_to_shoot then
		arg_4_0:_shoot(arg_4_1, arg_4_2)
	end
end

function ActionMinigun.get_projectile_start_position_rotation(arg_5_0)
	local var_5_0 = Unit.node(arg_5_0.weapon_unit, "a_barrel")
	local var_5_1 = Unit.world_rotation(arg_5_0.weapon_unit, var_5_0)
	local var_5_2 = Quaternion.forward(var_5_1)
	local var_5_3 = Quaternion.right(var_5_1)
	local var_5_4 = Unit.world_position(arg_5_0.weapon_unit, var_5_0) + var_5_2 * 0.4 + var_5_3 * 0.1
	local var_5_5, var_5_6 = arg_5_0.first_person_extension:camera_position_rotation()
	local var_5_7 = World.physics_world(arg_5_0.world)
	local var_5_8 = Quaternion.forward(var_5_6)
	local var_5_9 = Managers.state.side.side_by_unit[arg_5_0.owner_unit]
	local var_5_10 = WeaponHelper:look_at_enemy_or_static_position(var_5_7, var_5_5, var_5_8, var_5_9, 0.15, 100)
	local var_5_11, var_5_12 = Vector3.direction_length(var_5_10 - var_5_4)

	if var_5_12 < 2 then
		var_5_4 = var_5_5
		var_5_11 = Vector3.normalize(var_5_10 - var_5_4)
	end

	local var_5_13 = Quaternion.look(var_5_11)

	return var_5_4, var_5_13
end

function ActionMinigun._shoot(arg_6_0, arg_6_1, arg_6_2)
	arg_6_0:_update_attack_speed(arg_6_2)
	arg_6_0:_update_bot_avoidance(arg_6_2)

	local var_6_0

	if arg_6_0._use_ability_as_ammo then
		local var_6_1, var_6_2 = arg_6_0.career_extension:current_ability_cooldown(1)

		var_6_0 = (var_6_2 - var_6_1) / arg_6_0:_buffed_shot_cost()
	else
		var_6_0 = arg_6_0.ammo_extension:ammo_count()
	end

	local var_6_3 = arg_6_0._current_rps * arg_6_0._attack_speed_mod
	local var_6_4 = math.min(var_6_3 * (arg_6_2 - arg_6_0._time_to_shoot), var_6_0)
	local var_6_5 = math.floor(var_6_4)

	if var_6_5 > 0 then
		local var_6_6 = true
		local var_6_7 = arg_6_0._projectiles_per_shot
		local var_6_8 = arg_6_0:_update_extra_shots(arg_6_0.buff_extension, 0, var_6_6) or 0

		if var_6_8 > 0 then
			arg_6_0.extra_buff_shot = true
			arg_6_0._num_extra_shots = var_6_8
			var_6_7 = var_6_7 + var_6_8
		end

		arg_6_0._current_rps = math.clamp(arg_6_0._current_rps + arg_6_0._rps_gain_per_shot * var_6_5, arg_6_0._initial_rounds_per_second, arg_6_0._max_rps)
		arg_6_0._time_last_fired = arg_6_2
		arg_6_0._time_to_shoot = arg_6_2 - (var_6_4 - var_6_5) / var_6_3
		arg_6_0._num_projectiles_per_shot = var_6_5 * var_6_7
		arg_6_0._state = "start_shooting"
		arg_6_0._calculated_attack_speed = false
	end

	arg_6_0._first_shot = false
end

function ActionMinigun._shooting(arg_7_0, arg_7_1, arg_7_2)
	local var_7_0 = arg_7_0._num_projectiles_per_shot
	local var_7_1 = arg_7_0._num_projectiles_spawned
	local var_7_2 = var_7_0 - var_7_1

	if not arg_7_2 then
		var_7_2 = math.min(var_7_2, var_0_6)
	end

	arg_7_0._num_projectiles_spawned = arg_7_0:shoot(var_7_2, var_7_1, var_7_0)

	if var_7_0 - arg_7_0._num_projectiles_spawned <= 0 then
		arg_7_0:_staggered_shot_done(arg_7_1)
	end
end

function ActionMinigun._staggered_shot_done(arg_8_0, arg_8_1)
	local var_8_0 = arg_8_0.current_action
	local var_8_1 = arg_8_0.first_person_extension

	if var_8_0.apply_recoil then
		var_8_1:apply_recoil()
	end

	if var_8_0.recoil_settings then
		var_8_1:play_camera_recoil(var_8_0.recoil_settings, arg_8_1)
	end

	var_0_9(arg_8_0.weapon_unit, "lua_finish_shooting")

	if arg_8_0:_has_ammo() then
		arg_8_0._state = "waiting_to_shoot"
	else
		arg_8_0._state = "finished_shooting"
	end
end

function ActionMinigun._finished_shooting(arg_9_0, arg_9_1)
	arg_9_0.weapon_extension:stop_action("action_complete")
end

function ActionMinigun.finish(arg_10_0, arg_10_1)
	if arg_10_0._near_wall then
		arg_10_0.first_person_extension:animation_set_variable("disable_shooting", 0)
		CharacterStateHelper.play_animation_event_first_person(arg_10_0.first_person_extension, "near_wall_updated")
	end

	ActionMinigun.super.finish(arg_10_0, arg_10_1)

	local var_10_0 = arg_10_0._initial_rounds_per_second
	local var_10_1 = arg_10_0._max_rps - var_10_0
	local var_10_2 = math.clamp((arg_10_0._current_rps - var_10_0) / var_10_1, 0, 1)

	arg_10_0.weapon_extension:set_custom_data("windup", var_10_2)
end

function ActionMinigun.proc_extra_shot(arg_11_0, arg_11_1)
	return false
end

function ActionMinigun.gen_num_shots(arg_12_0)
	return 1, 1
end

function ActionMinigun.apply_shot_cost(arg_13_0, arg_13_1)
	if not arg_13_0._use_ability_as_ammo then
		return ActionMinigun.super.apply_shot_cost(arg_13_0, arg_13_1)
	end

	arg_13_0:_fake_activate_ability(arg_13_1)

	local var_13_0 = arg_13_0:_should_consume_ammo(arg_13_1)
	local var_13_1 = arg_13_0.buff_extension

	if var_13_1 and var_13_1:has_buff_perk(var_0_0.free_ability_engineer) then
		var_13_0 = false
	end

	if var_13_0 then
		local var_13_2 = arg_13_0._num_projectiles_per_shot

		if arg_13_0.extra_buff_shot then
			var_13_2 = math.max(var_13_2 - arg_13_0._num_extra_shots, 1)
		end

		arg_13_0.career_extension:reduce_activated_ability_cooldown(-arg_13_0:_buffed_shot_cost() * var_13_2)

		arg_13_0.extra_buff_shot = false
		arg_13_0._num_extra_shots = 0
	end
end

function ActionMinigun._should_consume_ammo(arg_14_0, arg_14_1)
	return arg_14_1 > arg_14_0._free_ammo_t
end

function ActionMinigun._has_ammo(arg_15_0)
	if arg_15_0._use_ability_as_ammo then
		local var_15_0, var_15_1 = arg_15_0.career_extension:current_ability_cooldown(1)

		return var_15_1 - var_15_0 >= arg_15_0:_buffed_shot_cost()
	else
		return arg_15_0.ammo_extension:ammo_count() > 0
	end
end

function ActionMinigun._play_vo(arg_16_0)
	local var_16_0 = arg_16_0.owner_unit
	local var_16_1 = ScriptUnit.extension_input(var_16_0, "dialogue_system")
	local var_16_2 = FrameTable.alloc_table()

	var_16_1:trigger_networked_dialogue_event("activate_ability", var_16_2)
end

function ActionMinigun._play_vfx(arg_17_0)
	return
end

function ActionMinigun._update_animation_speed(arg_18_0, arg_18_1)
	local var_18_0 = arg_18_0._base_anim_speed * arg_18_1
	local var_18_1 = math.clamp(var_18_0, NetworkConstants.animation_variable_float.min, NetworkConstants.animation_variable_float.max)

	arg_18_0.first_person_extension:animation_set_variable("attack_speed", var_18_1)

	if arg_18_0._attack_speed_anim_var_3p then
		Managers.state.network:anim_set_variable_float(arg_18_0.owner_unit, "attack_speed", var_18_1)
	end
end

function ActionMinigun._update_bot_avoidance(arg_19_0, arg_19_1)
	if not arg_19_0.is_bot and arg_19_1 > arg_19_0._last_avoidance_t + var_0_1 then
		arg_19_0._last_avoidance_t = arg_19_1

		local var_19_0, var_19_1 = arg_19_0:get_projectile_start_position_rotation()
		local var_19_2, var_19_3, var_19_4 = AiUtils.calculate_oobb(var_0_5, var_19_0, var_19_1, var_0_4, var_0_3)

		if arg_19_0.is_server then
			arg_19_0.ai_bot_group_system:queue_aoe_threat(var_19_2, "oobb", var_19_4, var_19_3, var_0_2, "Minigun")
		else
			Managers.state.network.network_transmit:send_rpc_server("rpc_bot_create_threat_oobb", var_19_2, var_19_3, var_19_4, var_0_2)
		end
	end
end

function ActionMinigun._fake_activate_ability(arg_20_0, arg_20_1)
	local var_20_0 = arg_20_0.buff_extension

	if var_20_0 then
		local var_20_1 = 1
		local var_20_2 = false

		arg_20_0._ammo_expended = arg_20_0._ammo_expended + arg_20_0:_buffed_shot_cost() * arg_20_0._num_projectiles_per_shot

		if var_20_0:has_buff_perk(var_0_0.free_ability) then
			arg_20_0._free_ammo_t = arg_20_1 + var_0_7
			var_20_2 = true
		elseif arg_20_0._ammo_expended > arg_20_0.career_extension:get_max_ability_cooldown() / 2 then
			arg_20_0._ammo_expended = 0
			var_20_2 = true
		end

		if var_20_2 then
			var_20_0:trigger_procs("on_ability_activated", arg_20_0.owner_unit, var_20_1)
			var_20_0:trigger_procs("on_ability_cooldown_started")

			local var_20_3 = Managers.state.network
			local var_20_4 = var_20_3:unit_game_object_id(arg_20_0.owner_unit)

			if var_20_3:game() then
				if arg_20_0.is_server then
					var_20_3.network_transmit:send_rpc_clients("rpc_ability_activated", var_20_4, var_20_1)
				else
					var_20_3.network_transmit:send_rpc_server("rpc_ability_activated", var_20_4, var_20_1)
				end
			end
		end
	end
end

function ActionMinigun._update_near_wall(arg_21_0)
	local var_21_0 = arg_21_0.first_person_extension
	local var_21_1 = var_21_0:current_position()
	local var_21_2 = var_21_0:current_rotation()
	local var_21_3 = "filter_in_line_of_sight_no_players_no_enemies"
	local var_21_4 = 1.35
	local var_21_5 = Quaternion.forward(var_21_2)
	local var_21_6 = World.physics_world(arg_21_0.world)
	local var_21_7, var_21_8, var_21_9 = PhysicsWorld.raycast(var_21_6, var_21_1, var_21_5, var_21_4, "all", "types", "both", "closest", "collision_filter", var_21_3)
	local var_21_10 = var_21_9 and var_21_9 <= var_21_4

	if var_21_10 ~= arg_21_0._near_wall then
		arg_21_0._near_wall = var_21_10

		var_21_0:animation_set_variable("disable_shooting", var_21_10 and 1 or 0)
		CharacterStateHelper.play_animation_event_first_person(var_21_0, "near_wall_updated")
	end
end

function ActionMinigun._buffed_shot_cost(arg_22_0)
	local var_22_0 = arg_22_0.buff_extension

	if var_22_0 then
		return (var_22_0:apply_buffs_to_value(arg_22_0._shot_cost, "ammo_used_multiplier"))
	end

	return arg_22_0._shot_cost
end
