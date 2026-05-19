-- chunkname: @scripts/unit_extensions/generic/generic_status_extension.lua

GenericStatusExtension = class(GenericStatusExtension)

local var_0_0 = DamageDataIndex
local var_0_1 = 3
local var_0_2 = -3
local var_0_3 = 2
local var_0_4 = 2
local var_0_5 = 60
local var_0_6 = 2
local var_0_7 = {
	blocked_slam = true,
	ogre_shove = true,
	blocked_berzerker = true,
	chaos_cleave = true,
	blocked_sv_sweep_2 = true,
	blocked_sv_cleave = true,
	complete = true,
	blocked_running = true,
	blocked_charge = true,
	blocked_attack_2 = true,
	sv_shove = true,
	sv_push = true,
	blocked_sv_sweep = true,
	shield_blocked_slam = true,
	chaos_spawn_combo = true,
	blocked_headbutt = true,
	blocked_attack = true,
	blocked_ranged = true,
	blocked_attack_3 = true
}

function GenericStatusExtension.init(arg_1_0, arg_1_1, arg_1_2, arg_1_3)
	arg_1_0.world = arg_1_1.world
	arg_1_0.profile_id = arg_1_3.profile_id

	fassert(arg_1_0.profile_id)

	arg_1_0.unit = arg_1_2
	arg_1_0.pacing_intensity = 0
	arg_1_0.pacing_intensity_decay_delay = 0
	arg_1_0.move_speed_multiplier = 1
	arg_1_0.move_speed_multiplier_timer = 1
	arg_1_0.invisible = {}
	arg_1_0.crouching = false
	arg_1_0.blocking = false
	arg_1_0.override_blocking = nil
	arg_1_0.charge_blocking = false
	arg_1_0.catapulted = false
	arg_1_0.catapulted_direction = nil
	arg_1_0.pounced_down = false
	arg_1_0.on_ladder = false
	arg_1_0.is_ledge_hanging = false
	arg_1_0.left_ladder_timer = 0
	arg_1_0.aim_unit = nil
	arg_1_0.revived = false
	arg_1_0.dead = false
	arg_1_0.pulled_up = false
	arg_1_0.overpowered = false
	arg_1_0.overpowered_template = nil
	arg_1_0.overpowered_attacking_unit = nil
	arg_1_0._has_blocked = false
	arg_1_0.my_dodge_cd = 0
	arg_1_0.my_dodge_jump_override_t = 0
	arg_1_0.dodge_cooldown = 0
	arg_1_0.dodge_cooldown_delay = 0
	arg_1_0.is_aiming = false
	arg_1_0.dodge_count = 2
	arg_1_0.combo_target_count = 0
	arg_1_0.fatigue = 0
	arg_1_0.last_fatigue_gain_time = 0
	arg_1_0.show_fatigue_gui = false
	arg_1_0.max_fatigue_points = 100
	arg_1_0.next_hanging_damage_time = 0
	arg_1_0.block_broken = false
	arg_1_0.gutter_runner_leaping = false
	arg_1_0.block_broken_at_t = -math.huge
	arg_1_0.stagger_immune = false
	arg_1_0.pushed = false
	arg_1_0.pushed_at_t = -math.huge
	arg_1_0.push_cooldown = false
	arg_1_0.push_cooldown_timer = false
	arg_1_0.timed_block = nil
	arg_1_0.shield_block = nil
	arg_1_0.charged = false
	arg_1_0.charged_at_t = -math.huge
	arg_1_0.interrupt_cooldown = false
	arg_1_0.interrupt_cooldown_timer = nil
	arg_1_0.inside_transport_unit = nil
	arg_1_0.using_transport = false
	arg_1_0.dodge_position = Vector3Box(0, 0, 0)
	arg_1_0.overcharge_exploding = false
	arg_1_0.fall_height = nil
	arg_1_0.under_ratling_gunner_attack = nil
	arg_1_0.last_catapulted_time = 0
	arg_1_0.grabbed_by_tentacle = false
	arg_1_0.grabbed_by_tentacle_status = nil
	arg_1_0.grabbed_by_chaos_spawn = false
	arg_1_0.grabbed_by_chaos_spawn_status = nil
	arg_1_0.in_vortex = false
	arg_1_0.in_vortex_unit = nil
	arg_1_0.near_vortex = false
	arg_1_0.near_vortex_unit = nil
	arg_1_0.in_liquid = false
	arg_1_0.in_liquid_unit = nil
	arg_1_0.in_hanging_cage_unit = nil
	arg_1_0.in_hanging_cage_state = nil
	arg_1_0.in_hanging_cage_animations = nil
	arg_1_0.wounds = arg_1_3.wounds

	if arg_1_0.wounds == -1 then
		arg_1_0.wounds = math.huge
	end

	arg_1_0._base_max_wounds = arg_1_0.wounds
	arg_1_0._num_times_grabbed_by_pack_master = 0
	arg_1_0._hit_by_globadier_poison_instances = {}
	arg_1_0._num_times_knocked_down = 0
	arg_1_0.is_server = Managers.player.is_server
	arg_1_0.update_funcs = {}

	arg_1_0:set_spawn_grace_time(5)

	if arg_1_3.respawn_unit then
		arg_1_0.ready_for_assisted_respawn = true
		arg_1_0.assisted_respawn_flavour_unit = arg_1_3.respawn_unit
	else
		arg_1_0.ready_for_assisted_respawn = false
	end

	arg_1_0.assisted_respawning = false
	arg_1_0.player = arg_1_3.player
	arg_1_0.is_bot = arg_1_0.player.bot_player
	arg_1_0.in_end_zone = false
	arg_1_0.is_husk = arg_1_0.player.remote

	if arg_1_0.is_server then
		arg_1_0.conflict_director = Managers.state.conflict
	end

	arg_1_0._intoxication_level = 0
	arg_1_0.noclip = {}
	arg_1_0._incapacitated_outline_ids = {}
	arg_1_0._assisted_respawn_outline_id = -1
	arg_1_0._invisible_outline_id = -1
end

function GenericStatusExtension.extensions_ready(arg_2_0)
	local var_2_0 = arg_2_0.unit

	arg_2_0.health_extension = ScriptUnit.extension(var_2_0, "health_system")
	arg_2_0.buff_extension = ScriptUnit.extension(var_2_0, "buff_system")
	arg_2_0.inventory_extension = ScriptUnit.extension(var_2_0, "inventory_system")
	arg_2_0.career_extension = ScriptUnit.extension(var_2_0, "career_system")
	arg_2_0.locomotion_extension = ScriptUnit.extension(var_2_0, "locomotion_system")

	if ScriptUnit.has_extension(var_2_0, "first_person_system") and not arg_2_0.locomotion_extension.is_bot then
		arg_2_0.first_person_extension = ScriptUnit.extension(var_2_0, "first_person_system")
		arg_2_0.low_health_playing_id, arg_2_0.low_health_source_id = arg_2_0.first_person_extension:play_hud_sound_event("hud_low_health")
	end

	Managers.state.event:register(arg_2_0, "on_player_joined_party", "_on_player_joined_party")
end

function GenericStatusExtension.destroy(arg_3_0)
	local var_3_0 = arg_3_0.first_person_extension

	if var_3_0 then
		var_3_0:play_hud_sound_event("stop_hud_low_health")
	end

	local var_3_1 = Managers.state.event

	if var_3_1 then
		var_3_1:unregister("on_player_joined_party", arg_3_0)
	end
end

function GenericStatusExtension.add_damage_intensity(arg_4_0, arg_4_1, arg_4_2)
	arg_4_0.pacing_intensity = math.clamp(arg_4_0.pacing_intensity + arg_4_1 * CurrentIntensitySettings.intensity_add_per_percent_dmg_taken * 100, 0, 100)
	arg_4_0.pacing_intensity_decay_delay = CurrentIntensitySettings.decay_delay
end

function GenericStatusExtension.add_pacing_intensity(arg_5_0, arg_5_1)
	arg_5_0.pacing_intensity = math.clamp(arg_5_0.pacing_intensity + arg_5_1, 0, 100)
	arg_5_0.pacing_intensity_decay_delay = CurrentIntensitySettings.decay_delay
end

function GenericStatusExtension.add_combo_target_count(arg_6_0, arg_6_1)
	arg_6_0.combo_target_count = math.clamp(arg_6_0.combo_target_count + arg_6_1, 0, 5)
end

function GenericStatusExtension.add_pacing_intensity_by_difficulty(arg_7_0, arg_7_1)
	local var_7_0 = arg_7_1[Managers.state.difficulty:get_difficulty()]

	if not var_7_0 then
		return
	end

	arg_7_0.pacing_intensity = math.clamp(arg_7_0.pacing_intensity + var_7_0, 0, 100)
	arg_7_0.pacing_intensity_decay_delay = CurrentIntensitySettings.decay_delay
end

function GenericStatusExtension.add_intoxication_level(arg_8_0, arg_8_1)
	arg_8_0._intoxication_level = math.clamp(arg_8_0._intoxication_level + arg_8_1, var_0_2, var_0_1)
end

function GenericStatusExtension.invert_intoxication_level(arg_9_0)
	arg_9_0._intoxication_level = arg_9_0._intoxication_level * -1
end

function GenericStatusExtension.intoxication_level(arg_10_0)
	return arg_10_0._intoxication_level
end

local var_0_8 = {
	temporary_health_degen = true,
	overcharge = true,
	wounded_dot = true,
	knockdown_bleed = true,
	heal = true,
	health_degen = true
}

function GenericStatusExtension.update(arg_11_0, arg_11_1, arg_11_2, arg_11_3, arg_11_4, arg_11_5)
	local var_11_0 = arg_11_0.health_extension
	local var_11_1, var_11_2 = var_11_0:recent_damages()

	if arg_11_0.is_server then
		local var_11_3 = var_0_0.STRIDE

		for iter_11_0 = 1, var_11_2 / var_11_3 do
			local var_11_4 = (iter_11_0 - 1) * var_11_3
			local var_11_5 = var_11_1[var_11_4 + var_0_0.DAMAGE_TYPE]

			if not var_0_8[var_11_5] then
				local var_11_6 = var_11_1[var_11_4 + var_0_0.DAMAGE_AMOUNT]
				local var_11_7 = var_11_0:get_max_health()

				arg_11_0:add_damage_intensity(var_11_6 / var_11_7, var_11_5)
			end
		end

		local var_11_8 = arg_11_0.conflict_director.pacing:ignore_pacing_intensity_decay_delay()

		if (arg_11_0.pacing_intensity_decay_delay <= 0 or var_11_8) and not arg_11_0.conflict_director:intensity_decay_frozen() then
			arg_11_0.pacing_intensity = math.clamp(arg_11_0.pacing_intensity - CurrentIntensitySettings.decay_per_second * arg_11_3, 0, CurrentIntensitySettings.max_intensity)
		end

		arg_11_0.pacing_intensity_decay_delay = arg_11_0.pacing_intensity_decay_delay - arg_11_3
	end

	if arg_11_0.move_speed_multiplier_timer < 1 then
		local var_11_9 = arg_11_3 * PlayerUnitStatusSettings.move_speed_reduction_on_hit_recover_time

		arg_11_0.move_speed_multiplier_timer = arg_11_0.move_speed_multiplier_timer + var_11_9
	end

	local var_11_10 = true

	if var_11_2 > 0 then
		local var_11_11 = false

		for iter_11_1 = 1, var_11_2 / var_0_0.STRIDE do
			local var_11_12 = var_11_1[(iter_11_1 - 1) * var_0_0.STRIDE + var_0_0.DAMAGE_TYPE]

			if PlayerUnitMovementSettings.slowing_damage_types[var_11_12] then
				var_11_11 = true

				if arg_11_0.buff_extension:has_buff_perk("no_moveslow_on_hit") then
					var_11_11 = false
				end

				break
			end

			if not var_0_8[var_11_12] then
				var_11_10 = false
			end
		end

		if var_11_11 then
			arg_11_0.move_speed_multiplier = arg_11_0:current_move_speed_multiplier() * 0.5
			arg_11_0.move_speed_multiplier = math.max(0.2, arg_11_0.move_speed_multiplier)
			arg_11_0.move_speed_multiplier_timer = 0
		end
	end

	local var_11_13 = arg_11_0.player

	if script_data.debug_fatigue then
		local var_11_14 = SPProfiles[var_11_13:profile_index()]

		Debug.text("(%s) Fatigue: %s, Max: %s", var_11_13:name() == "anonymous" and var_11_14 and var_11_14.display_name or var_11_13:name(), arg_11_0.fatigue, PlayerUnitStatusSettings.MAX_FATIGUE)
	end

	if not var_11_13.remote then
		local var_11_15 = arg_11_0.max_fatigue_points
		local var_11_16 = arg_11_0:_get_current_max_fatigue_points() or var_11_15
		local var_11_17 = (arg_11_0.block_broken_degen_delay or arg_11_0.push_degen_delay or PlayerUnitStatusSettings.FATIGUE_DEGEN_DELAY) / arg_11_0.buff_extension:apply_buffs_to_value(1, "fatigue_regen")

		if var_11_15 ~= var_11_16 then
			local var_11_18 = var_11_16 == 0 and 0 or var_11_15 / var_11_16 * arg_11_0.fatigue

			arg_11_0:set_fatigue_points(var_11_18, "force_set")
		end

		if not var_11_10 and var_11_2 > 0 and arg_11_0.fatigue >= 50 then
			if arg_11_0.action_stun_push then
				arg_11_0.action_stun_push = false
			else
				arg_11_0:remove_fatigue_points(100 / var_11_16)
			end
		end

		if arg_11_5 >= arg_11_0.last_fatigue_gain_time + var_11_17 then
			arg_11_0.action_stun_push = false
			arg_11_0.show_fatigue_gui = false

			local var_11_19 = var_11_16 == 0 and 0 or PlayerUnitStatusSettings.FATIGUE_POINTS_DEGEN_AMOUNT / var_11_16 * PlayerUnitStatusSettings.MAX_FATIGUE
			local var_11_20 = arg_11_0.buff_extension:apply_buffs_to_value(var_11_19, "fatigue_regen")

			if var_11_19 < var_11_20 then
				arg_11_0.has_bonus_fatigue_active = true
			elseif not arg_11_0.bonus_fatigue_active_timer then
				arg_11_0.has_bonus_fatigue_active = false
			end

			arg_11_0:remove_fatigue_points(var_11_20 * arg_11_3)

			arg_11_0.block_broken_degen_delay = nil
			arg_11_0.push_degen_delay = nil
		end

		if arg_11_0.dodge_cooldown > 0 and arg_11_0.dodge_cooldown_delay and arg_11_5 > arg_11_0.dodge_cooldown_delay then
			arg_11_0.dodge_cooldown = 0
		end

		arg_11_0.max_fatigue_points = var_11_16

		local var_11_21 = arg_11_0.bonus_fatigue_active_timer

		if var_11_21 and var_11_21 <= arg_11_5 then
			arg_11_0.has_bonus_fatigue_active = false
			arg_11_0.bonus_fatigue_active_timer = nil
		end

		if arg_11_0.push_cooldown then
			if not arg_11_0.push_cooldown_timer then
				arg_11_0.push_cooldown_timer = arg_11_5 + 1.5
			elseif arg_11_5 > arg_11_0.push_cooldown_timer then
				arg_11_0.push_cooldown_timer = false
				arg_11_0.pushed = false
				arg_11_0.push_cooldown = false
			end
		end

		if arg_11_0.interrupt_cooldown then
			if not arg_11_0.interrupt_cooldown_timer then
				arg_11_0.interrupt_cooldown_timer = arg_11_5 + 0.5
			elseif arg_11_5 > arg_11_0.interrupt_cooldown_timer then
				arg_11_0.interrupt_cooldown = false
				arg_11_0.interrupt_cooldown_timer = nil
			end
		end

		if arg_11_0.first_person_extension and arg_11_0.low_health_playing_id then
			local var_11_22 = arg_11_0.health_extension:current_health_percent() * 100
			local var_11_23 = Managers.world:wwise_world(arg_11_0.world)

			WwiseWorld.set_source_parameter(var_11_23, arg_11_0.low_health_source_id, "health_status", var_11_22)
		end

		if arg_11_0.shielded and not var_11_0:has_assist_shield() and var_11_0:previous_shield_end_reason() then
			arg_11_0:set_shielded(false)
		end
	end

	if arg_11_0.pack_master_status then
		if arg_11_0.pack_master_status == "pack_master_hanging" then
			if arg_11_0.is_server then
				if arg_11_5 > arg_11_0.next_hanging_damage_time then
					local var_11_24 = PlayerUnitStatusSettings.hanging_by_pack_master

					DamageUtils.add_damage_network(arg_11_1, arg_11_1, var_11_24.damage_amount, var_11_24.hit_zone_name, var_11_24.damage_type, nil, Vector3.up(), "skaven_pack_master", nil, arg_11_1, nil, nil, nil, nil, nil, nil, nil, nil, 1)

					arg_11_0.next_hanging_damage_time = arg_11_5 + 1
				end

				if arg_11_0.dead then
					StatusUtils.set_grabbed_by_pack_master_network("pack_master_dropping", arg_11_1, true, nil)
				end
			end
		elseif arg_11_0.pack_master_status == "pack_master_dropping" then
			if arg_11_0.release_falling_time and arg_11_5 > arg_11_0.release_falling_time then
				ScriptUnit.extension(arg_11_1, "locomotion_system"):set_disabled(false, nil, nil, true)

				if arg_11_0.is_server then
					StatusUtils.set_grabbed_by_pack_master_network("pack_master_released", arg_11_1, false, nil)
				end

				arg_11_0.release_falling_time = nil
			end
		elseif arg_11_0.pack_master_status == "pack_master_unhooked" then
			if arg_11_0.release_unhook_time and arg_11_5 > arg_11_0.release_unhook_time then
				ScriptUnit.extension(arg_11_1, "locomotion_system"):set_disabled(false, nil, nil, true)

				if arg_11_0.is_server then
					StatusUtils.set_grabbed_by_pack_master_network("pack_master_released", arg_11_1, false, nil)
				end

				arg_11_0.release_unhook_time = nil
			end
		elseif arg_11_0.pack_master_status == "pack_master_released" then
			arg_11_0.pack_master_status = nil
		elseif arg_11_0.pack_master_status == "pack_master_dragging" then
			if arg_11_0.is_server and (not arg_11_0.pack_master_grabber or not Unit.alive(arg_11_0.pack_master_grabber)) then
				StatusUtils.set_grabbed_by_pack_master_network("pack_master_unhooked", arg_11_1, false, nil)
			end
		elseif arg_11_0.pack_master_status == "pack_master_hoisting" and arg_11_0.is_server and (not arg_11_0.pack_master_grabber or not Unit.alive(arg_11_0.pack_master_grabber)) then
			StatusUtils.set_grabbed_by_pack_master_network("pack_master_unhooked", arg_11_1, false, nil)
		end
	end

	for iter_11_2, iter_11_3 in pairs(arg_11_0.update_funcs) do
		iter_11_3(arg_11_0, arg_11_5, arg_11_3)
	end
end

function GenericStatusExtension.set_spawn_grace_time(arg_12_0, arg_12_1)
	arg_12_0.spawn_grace_time = Managers.time:time("game") + arg_12_1
	arg_12_0.spawn_grace = true
	arg_12_0.update_funcs.spawn_grace_time = GenericStatusExtension.update_spawn_grace_time
end

function GenericStatusExtension.update_spawn_grace_time(arg_13_0, arg_13_1)
	if arg_13_1 > arg_13_0.spawn_grace_time then
		arg_13_0.spawn_grace = false
		arg_13_0.update_funcs.spawn_grace_time = nil
	end
end

function GenericStatusExtension.fall_distance(arg_14_0)
	if arg_14_0.fall_height then
		if arg_14_0.ignore_next_fall_damage then
			arg_14_0.fall_height = POSITION_LOOKUP[arg_14_0.unit].z

			return 0
		end

		local var_14_0 = POSITION_LOOKUP[arg_14_0.unit].z

		return arg_14_0.fall_height - var_14_0
	end

	return 0
end

function GenericStatusExtension.set_ignore_next_fall_damage(arg_15_0, arg_15_1)
	arg_15_0.ignore_next_fall_damage = arg_15_1
end

function GenericStatusExtension.update_falling(arg_16_0, arg_16_1)
	if arg_16_0.locomotion_extension:is_on_ground() and not arg_16_0.on_ladder then
		local var_16_0 = PlayerUnitMovementSettings.get_movement_settings_table(arg_16_0.unit)
		local var_16_1 = var_16_0.fall.heights.MIN_FALL_DAMAGE_HEIGHT
		local var_16_2 = var_16_0.fall.heights.HARD_LANDING_FALL_HEIGHT
		local var_16_3 = arg_16_0.locomotion_extension:get_script_driven_gravity_scale()
		local var_16_4 = math.abs(arg_16_0:fall_distance() * var_16_3)
		local var_16_5 = "landed"

		if var_16_1 < var_16_4 then
			local var_16_6 = math.abs(var_16_4)

			if not global_is_inside_inn and not arg_16_0.inside_transport_unit and not arg_16_0.ignore_next_fall_damage and not arg_16_0.is_bot then
				local var_16_7 = math.clamp(var_16_6 * 4, 0, 255)
				local var_16_8 = Managers.state.network
				local var_16_9 = Managers.state.unit_storage:go_id(arg_16_0.unit)

				var_16_8.network_transmit:send_rpc_server("rpc_take_falling_damage", var_16_9, var_16_7)
			end

			var_16_5 = "landed_soft"

			if var_16_2 <= var_16_6 then
				var_16_5 = "landed_hard"
			end
		end

		if arg_16_0.first_person_extension then
			arg_16_0.first_person_extension:play_camera_effect_sequence(var_16_5, arg_16_1)
		end

		arg_16_0.ignore_next_fall_damage = false
		arg_16_0.update_funcs.falling = nil
		arg_16_0.fall_height = nil
	end
end

function GenericStatusExtension._get_current_max_fatigue_points(arg_17_0)
	local var_17_0 = arg_17_0.inventory_extension
	local var_17_1 = var_17_0:get_wielded_slot_name()
	local var_17_2 = var_17_0:get_slot_data(var_17_1)

	if var_17_2 then
		local var_17_3 = var_17_0:get_item_template(var_17_2).max_fatigue_points

		var_17_3 = var_17_3 and math.clamp(arg_17_0.buff_extension:apply_buffs_to_value(var_17_3, "max_fatigue"), 1, 100)

		return var_17_3
	end
end

function GenericStatusExtension.get_max_fatigue_points(arg_18_0)
	return arg_18_0:_get_current_max_fatigue_points()
end

function GenericStatusExtension.can_block(arg_19_0, arg_19_1, arg_19_2)
	local var_19_0 = arg_19_0.unit
	local var_19_1 = arg_19_0.player
	local var_19_2 = arg_19_0.inventory_extension:equipment()
	local var_19_3 = Managers.state.network
	local var_19_4 = var_19_2.wielded.template or var_19_2.wielded.temporary_template
	local var_19_5 = WeaponUtils.get_weapon_template(var_19_4)

	if not var_19_4 then
		return false
	end

	local var_19_6 = var_19_3:game()
	local var_19_7 = var_19_3:unit_game_object_id(var_19_0)

	if not var_19_6 or not var_19_7 then
		return false
	end

	if var_19_1 then
		local var_19_8 = GameSession.game_object_field(var_19_6, var_19_7, "aim_direction")
		local var_19_9 = Vector3.flat(var_19_8)
		local var_19_10 = POSITION_LOOKUP[var_19_0]
		local var_19_11 = POSITION_LOOKUP[arg_19_1] or Unit.world_position(arg_19_1, 0)
		local var_19_12 = Vector3.normalize(var_19_11 - var_19_10)
		local var_19_13 = Vector3.flat(var_19_12)
		local var_19_14 = arg_19_0.buff_extension
		local var_19_15 = var_19_14:apply_buffs_to_value(var_19_5.block_angle or 90, "block_angle")
		local var_19_16 = var_19_14:apply_buffs_to_value(var_19_5.outer_block_angle or 360, "block_angle")
		local var_19_17 = math.clamp(var_19_15, 0, 360)
		local var_19_18 = math.clamp(var_19_16, 0, 360)
		local var_19_19 = math.rad(var_19_17 * 0.5)
		local var_19_20 = math.rad(var_19_18 * 0.5)
		local var_19_21 = Vector3.dot(var_19_13, var_19_9)
		local var_19_22 = math.acos(var_19_21)
		local var_19_23 = var_19_22 <= var_19_19
		local var_19_24 = var_19_19 < var_19_22 and var_19_22 <= var_19_20

		if not var_19_23 and not var_19_24 then
			return false
		end

		if script_data.debug_draw_block_arcs then
			if var_19_23 and not var_19_24 then
				arg_19_0._debug_draw_color = Colors.get_table("lime")
			elseif not var_19_23 and var_19_24 then
				arg_19_0._debug_draw_color = Colors.get_table("dark_orange")
			else
				arg_19_0._debug_draw_color = Colors.get_table("red")
			end
		end

		local var_19_25 = var_19_24 and (var_19_5.outer_block_fatigue_point_multiplier or 2) or var_19_5.block_fatigue_point_multiplier or 1
		local var_19_26 = var_19_23 and not var_19_24

		arg_19_2 = arg_19_2 or Vector3.cross(var_19_13, var_19_9).z < 0 and "left" or "right"

		return true, var_19_25, var_19_26, arg_19_2
	end

	return false
end

function GenericStatusExtension.blocked_attack(arg_20_0, arg_20_1, arg_20_2, arg_20_3, arg_20_4, arg_20_5)
	local var_20_0 = arg_20_0.unit
	local var_20_1 = arg_20_0.inventory_extension:equipment()
	local var_20_2

	arg_20_0:set_has_blocked(true)

	local var_20_3 = arg_20_0.player

	if var_20_3 then
		local var_20_4 = arg_20_0.buff_extension
		local var_20_5 = "power_up_deus_block_procs_parry_exotic"
		local var_20_6 = var_20_4:has_buff_type(var_20_5)
		local var_20_7 = false
		local var_20_8 = Managers.time:time("game")

		if arg_20_0.timed_block and (var_20_8 < arg_20_0.timed_block or var_20_6) then
			var_20_4:trigger_procs("on_timed_block", arg_20_2)

			var_20_7 = true
		end

		if not var_20_3.remote then
			local var_20_9 = ScriptUnit.extension(var_20_0, "first_person_system")
			local var_20_10 = var_20_9:get_first_person_unit()

			if var_20_3.local_player and Managers.state.controller_features then
				Managers.state.controller_features:add_effect("rumble", {
					rumble_effect = "block"
				})
			end

			var_20_2 = var_20_1.right_hand_wielded_unit or var_20_1.left_hand_wielded_unit

			local var_20_11 = var_20_1.wielded.template or var_20_1.wielded.temporary_template
			local var_20_12 = WeaponUtils.get_weapon_template(var_20_11)

			if var_20_7 then
				var_20_9:play_hud_sound_event("Play_player_parry_success", nil, false)
			end

			arg_20_0:add_fatigue_points(arg_20_1, arg_20_2, var_20_2, arg_20_3, var_20_7)

			local var_20_13 = "parry_hit_reaction"

			if arg_20_4 then
				if PlayerUnitStatusSettings.fatigue_point_costs[arg_20_1] <= 2 and (arg_20_5 == "left" or arg_20_5 == "right") then
					var_20_13 = "parry_deflect_" .. arg_20_5
				end

				local var_20_14 = var_20_12 and var_20_12.sound_event_block_within_arc or "Play_player_block_ark_success"

				var_20_9:play_hud_sound_event(var_20_14, nil, false)
			else
				local var_20_15 = Managers.world:wwise_world(arg_20_0.world)
				local var_20_16 = POSITION_LOOKUP[arg_20_2]

				if var_20_16 then
					local var_20_17 = var_20_9:current_position()
					local var_20_18 = Vector3.normalize(var_20_16 - var_20_17)

					WwiseWorld.trigger_event(var_20_15, "Play_player_combat_out_of_arc_block", var_20_17 + var_20_18)
				end
			end

			Unit.animation_event(var_20_10, var_20_13)
			QuestSettings.handle_bastard_block(var_20_0, arg_20_2, true)
		else
			var_20_2 = var_20_1.right_hand_wielded_unit_3p or var_20_1.left_hand_wielded_unit_3p

			QuestSettings.handle_bastard_block(var_20_0, arg_20_2, true)
			Unit.animation_event(var_20_0, "parry_hit_reaction")
		end

		Managers.state.entity:system("play_go_tutorial_system"):register_block()
		Managers.state.achievement:trigger_event("player_blocked_attack", var_20_3, arg_20_2)
	end

	if var_20_2 then
		local var_20_19 = POSITION_LOOKUP[var_20_2]
		local var_20_20 = Unit.world_rotation(var_20_2, 0)
		local var_20_21 = var_20_19 + Quaternion.up(var_20_20) * Math.random() * 0.5 + Quaternion.right(var_20_20) * 0.1

		World.create_particles(arg_20_0.world, "fx/wpnfx_sword_spark_parry", var_20_21)
	end
end

function GenericStatusExtension.set_shielded(arg_21_0, arg_21_1)
	local var_21_0 = arg_21_0.unit

	if arg_21_0.player.local_player then
		local var_21_1 = ScriptUnit.extension(var_21_0, "first_person_system")

		if arg_21_1 then
			var_21_1:play_hud_sound_event("hud_player_buff_shield_activate")
			var_21_1:create_screen_particles("fx/screenspace_shield_healed")
		else
			local var_21_2 = arg_21_0.health_extension:previous_shield_end_reason()

			if var_21_2 == "blocked_damage" then
				var_21_1:play_hud_sound_event("hud_player_buff_shield_down")
			elseif var_21_2 == "timed_out" then
				var_21_1:play_hud_sound_event("hud_player_buff_shield_deactivate")
			end
		end
	end

	arg_21_0.shielded = arg_21_1
end

local var_0_9 = {
	career_passive = true,
	health_regen = true,
	heal_from_proc = true,
	career_skill = true
}
local var_0_10 = {
	bandage_temp_health = true,
	buff_shared_medpack_temp_health = true,
	healing_draught_temp_health = true,
	buff_shared_medpack = true,
	bandage = true,
	bandage_trinket = true,
	healing_draught = true
}

function GenericStatusExtension.healed(arg_22_0, arg_22_1)
	local var_22_0 = arg_22_0.unit

	if arg_22_0.player.local_player then
		if not var_0_9[arg_22_1] then
			local var_22_1 = ScriptUnit.extension(var_22_0, "first_person_system"):get_first_person_unit()

			Unit.flow_event(var_22_1, "sfx_heal")
		end

		local var_22_2 = HealingMoods[arg_22_1]

		if var_22_2 then
			Managers.state.camera:set_mood(var_22_2, arg_22_0, true)
		end
	elseif var_0_10[arg_22_1] then
		ScriptWorld.create_particles_linked(arg_22_0.world, "fx/chr_player_fak_healed", var_22_0, 0, "destroy")
	end
end

function GenericStatusExtension.fatigued(arg_23_0)
	local var_23_0 = PlayerUnitStatusSettings.MAX_FATIGUE
	local var_23_1 = arg_23_0.max_fatigue_points

	if arg_23_0.buff_extension:has_buff_perk("no_push_fatigue_cost") then
		return false
	end

	return var_23_1 == 0 and true or arg_23_0.fatigue > var_23_0 - var_23_0 / var_23_1
end

function GenericStatusExtension.add_fatigue_points(arg_24_0, arg_24_1, arg_24_2, arg_24_3, arg_24_4, arg_24_5)
	local var_24_0 = arg_24_0.buff_extension

	if Development.parameter("disable_fatigue_system") then
		return
	end

	local var_24_1 = arg_24_0.player

	if var_24_1 and var_24_1.remote then
		Crashify.print_exception("[GenericStatusExtension]", "Tried adding fatigue points to a remote player.")

		return
	end

	local var_24_2 = PlayerUnitStatusSettings.fatigue_point_costs[arg_24_1]
	local var_24_3 = Managers.time:time("game")
	local var_24_4 = PlayerUnitStatusSettings.MAX_FATIGUE
	local var_24_5 = var_24_2 * (var_24_4 / arg_24_0.max_fatigue_points) * (arg_24_4 or 1)

	if arg_24_5 then
		var_24_5 = var_24_0:apply_buffs_to_value(var_24_5, "timed_block_cost")
	end

	if var_24_2 and arg_24_4 and var_24_2 < 2 and arg_24_4 < 1 and var_24_0:has_buff_perk("in_arc_block_cost_reduction") then
		var_24_5 = 0
	end

	if arg_24_3 then
		var_24_5 = var_24_0:apply_buffs_to_value(var_24_5, "block_cost")

		if var_24_0:has_buff_perk("overcharged_block") then
			local var_24_6 = ScriptUnit.has_extension(arg_24_0.unit, "overcharge_system")

			if var_24_6 and var_24_6:above_overcharge_threshold() then
				var_24_5 = var_24_5 * 0.5

				var_24_6:remove_charge(var_24_2)
			end
		end
	end

	local var_24_7 = math.clamp(arg_24_0.fatigue + var_24_5, 0, var_24_4)

	arg_24_0:set_fatigue_points(var_24_7, arg_24_1)

	if arg_24_3 then
		var_24_0:trigger_procs("on_block", arg_24_2, arg_24_1, arg_24_3)
	end

	if var_24_4 <= var_24_7 and var_0_7[arg_24_1] then
		arg_24_0:set_block_broken(true, var_24_3, arg_24_2)
	end

	if var_24_5 > 0 then
		arg_24_0.last_fatigue_gain_time = var_24_3
		arg_24_0.show_fatigue_gui = true
	end

	if arg_24_1 == "action_stun_push" then
		arg_24_0.action_stun_push = true
	end

	local var_24_8 = arg_24_0.first_person_extension

	if var_24_2 > PlayerUnitStatusSettings.fatigue_points_to_play_heavy_block_sfx and var_24_8 then
		var_24_8:play_hud_sound_event("Play_player_combat_heavy_block_sweetner", nil, false)
	end
end

function GenericStatusExtension.set_fatigue_points(arg_25_0, arg_25_1, arg_25_2, arg_25_3)
	local var_25_0 = arg_25_0.fatigue

	arg_25_3 = not (not arg_25_3 and (var_25_0 < arg_25_1 or var_25_0 ~= arg_25_1 and (var_25_0 == 100 or arg_25_1 == 0)))
	arg_25_0.fatigue = arg_25_1

	if arg_25_0.is_server then
		local var_25_1 = PlayerUnitStatusSettings.fatigue_point_costs[arg_25_2]
		local var_25_2 = PlayerUnitStatusSettings.MAX_FATIGUE

		if var_25_1 >= PlayerUnitStatusSettings.fatigue_points_to_trigger_vo and var_25_2 <= arg_25_1 then
			local var_25_3 = ScriptUnit.extension(arg_25_0.unit, "dialogue_system").context.player_profile

			SurroundingAwareSystem.add_event(arg_25_0.unit, "block_broken_by_heavy_hit", DialogueSettings.grabbed_broadcast_range, "profile_name", var_25_3)
		end
	end

	if not arg_25_3 then
		local var_25_4 = Managers.state.unit_storage:go_id(arg_25_0.unit)
		local var_25_5 = NetworkLookup.fatigue_types[arg_25_2]

		if arg_25_0.is_server then
			Managers.state.network.network_transmit:send_rpc_clients("rpc_set_fatigue_points", var_25_4, arg_25_1, var_25_5)
		else
			Managers.state.network.network_transmit:send_rpc_server("rpc_set_fatigue_points", var_25_4, arg_25_1, var_25_5)
		end
	end
end

function GenericStatusExtension.remove_fatigue_points(arg_26_0, arg_26_1)
	local var_26_0 = math.max(arg_26_0.fatigue - arg_26_1, 0)

	arg_26_0:set_fatigue_points(var_26_0, "force_set")
end

function GenericStatusExtension.remove_all_fatigue(arg_27_0)
	arg_27_0:remove_fatigue_points(math.huge)
end

function GenericStatusExtension.get_dodge_item_data(arg_28_0)
	local var_28_0 = arg_28_0.inventory_extension
	local var_28_1 = var_28_0:get_wielded_slot_name()
	local var_28_2 = var_28_0:get_slot_data(var_28_1)
	local var_28_3

	if var_28_2 then
		var_28_3 = var_28_0:get_item_template(var_28_2).dodge_count
	end

	arg_28_0.dodge_count = var_28_3 or 2
end

function GenericStatusExtension.add_dodge_cooldown(arg_29_0)
	if arg_29_0.buff_extension:has_buff_perk("infinite_dodge") then
		arg_29_0.dodge_cooldown = 0

		return
	end

	arg_29_0:get_dodge_item_data()

	arg_29_0.dodge_cooldown = math.min(arg_29_0.dodge_cooldown + 1, 3 + arg_29_0.dodge_count)
	arg_29_0.dodge_cooldown_delay = nil
end

function GenericStatusExtension.start_dodge_cooldown(arg_30_0, arg_30_1)
	arg_30_0.dodge_cooldown_delay = arg_30_1 + 0.5
end

function GenericStatusExtension.get_dodge_cooldown(arg_31_0)
	if arg_31_0.buff_extension:has_buff_type("passive_career_we_2") then
		return 1
	end

	return 0.4 + 0.6 * (1 - math.max(arg_31_0.dodge_cooldown - arg_31_0.dodge_count, 0) / 3)
end

function GenericStatusExtension.current_fatigue(arg_32_0)
	return arg_32_0.fatigue
end

function GenericStatusExtension.current_fatigue_points(arg_33_0)
	local var_33_0 = PlayerUnitStatusSettings.MAX_FATIGUE
	local var_33_1 = arg_33_0.max_fatigue_points

	return var_33_1 == 0 and 0 or math.ceil(arg_33_0.fatigue / (var_33_0 / var_33_1)), var_33_1
end

function GenericStatusExtension.set_stagger_immune(arg_34_0, arg_34_1)
	arg_34_0.stagger_immune = arg_34_1
end

function GenericStatusExtension.set_pushed(arg_35_0, arg_35_1, arg_35_2)
	if arg_35_1 and (arg_35_0.push_cooldown or arg_35_0.stagger_immune) then
		return
	elseif arg_35_1 then
		arg_35_0.pushed = arg_35_1
		arg_35_0.push_cooldown = true
		arg_35_0.pushed_at_t = arg_35_2
	else
		arg_35_0.pushed = arg_35_1
	end
end

function GenericStatusExtension.set_charged(arg_36_0, arg_36_1, arg_36_2)
	arg_36_0.charged = arg_36_1
end

function GenericStatusExtension.set_pushed_no_cooldown(arg_37_0, arg_37_1, arg_37_2)
	if arg_37_1 and arg_37_0.stagger_immune then
		return
	end

	arg_37_0.pushed = arg_37_1

	if arg_37_1 then
		arg_37_0.pushed_at_t = arg_37_2
	end
end

function GenericStatusExtension.set_hit_react_type(arg_38_0, arg_38_1)
	arg_38_0._hit_react_type = arg_38_1
end

function GenericStatusExtension.hitreact_interrupt(arg_39_0)
	if arg_39_0.interrupt_cooldown then
		return false
	else
		arg_39_0.interrupt_cooldown = true

		return true
	end
end

function GenericStatusExtension.is_pushed(arg_40_0)
	return arg_40_0.pushed and not arg_40_0.overcharge_exploding
end

function GenericStatusExtension.is_charged(arg_41_0)
	return arg_41_0.charged
end

function GenericStatusExtension.hit_react_type(arg_42_0)
	return arg_42_0._hit_react_type or "light"
end

function GenericStatusExtension.set_block_broken(arg_43_0, arg_43_1, arg_43_2, arg_43_3)
	if arg_43_0.block_broken == arg_43_1 then
		return
	end

	arg_43_0.block_broken = arg_43_1

	if arg_43_1 then
		arg_43_0.block_broken_degen_delay = 2
		arg_43_0.block_broken_at_t = arg_43_2

		arg_43_0.buff_extension:trigger_procs("on_block_broken")
		Managers.state.achievement:trigger_event("register_block_broken", arg_43_0.unit, arg_43_3)
	end

	local var_43_0 = arg_43_0.player

	if var_43_0 and not var_43_0.remote then
		local var_43_1 = Managers.state.unit_storage:go_id(arg_43_0.unit)
		local var_43_2 = Managers.state.unit_storage:go_id(arg_43_3) or 0

		if arg_43_0.is_server then
			Managers.state.network.network_transmit:send_rpc_clients("rpc_status_change_bool", NetworkLookup.statuses.block_broken, arg_43_1, var_43_1, var_43_2)
		else
			Managers.state.network.network_transmit:send_rpc_server("rpc_status_change_bool", NetworkLookup.statuses.block_broken, arg_43_1, var_43_1, var_43_2)
		end
	end
end

function GenericStatusExtension.set_gutter_runner_leaping(arg_44_0, arg_44_1)
	if arg_44_0.gutter_runner_leaping == arg_44_1 then
		return
	end

	arg_44_0.gutter_runner_leaping = arg_44_1

	local var_44_0 = arg_44_0.player

	if var_44_0 and not var_44_0.remote then
		local var_44_1 = Managers.state.unit_storage:go_id(arg_44_0.unit)

		if arg_44_0.is_server then
			Managers.state.network.network_transmit:send_rpc_clients("rpc_status_change_bool", NetworkLookup.statuses.gutter_runner_leaping, arg_44_1, var_44_1, 0)
		else
			Managers.state.network.network_transmit:send_rpc_server("rpc_status_change_bool", NetworkLookup.statuses.gutter_runner_leaping, arg_44_1, var_44_1, 0)
		end
	end
end

function GenericStatusExtension.set_reviving(arg_45_0, arg_45_1, arg_45_2)
	if arg_45_0.reviving == arg_45_1 then
		return
	end

	arg_45_0.reviving = arg_45_1

	local var_45_0 = arg_45_0.player

	if not Managers.state.network or not Managers.state.network:game() then
		return
	end

	if var_45_0 and not var_45_0.remote then
		local var_45_1 = Managers.state.unit_storage:go_id(arg_45_0.unit)
		local var_45_2 = Managers.state.unit_storage:go_id(arg_45_2) or 0

		if arg_45_0.is_server then
			Managers.state.network.network_transmit:send_rpc_clients("rpc_status_change_bool", NetworkLookup.statuses.reviving, arg_45_1, var_45_1, var_45_2)
		else
			Managers.state.network.network_transmit:send_rpc_server("rpc_status_change_bool", NetworkLookup.statuses.reviving, arg_45_1, var_45_1, var_45_2)
		end
	end
end

function GenericStatusExtension.set_has_pushed(arg_46_0, arg_46_1)
	if not arg_46_0.buff_extension:has_buff_perk("slayer_stamina") then
		arg_46_0.push_degen_delay = arg_46_1 or 1.5
	end
end

function GenericStatusExtension.set_has_blocked(arg_47_0, arg_47_1)
	arg_47_0._has_blocked = arg_47_1
end

function GenericStatusExtension.set_pounced_down(arg_48_0, arg_48_1, arg_48_2)
	arg_48_1 = arg_48_1 and arg_48_2 ~= nil and Unit.alive(arg_48_2)

	if arg_48_1 == arg_48_0.pounced_down then
		return
	end

	local var_48_0 = arg_48_0.unit
	local var_48_1 = ScriptUnit.extension(var_48_0, "locomotion_system")

	arg_48_0.pounced_down = arg_48_1

	if arg_48_1 then
		arg_48_0.pouncer_unit = arg_48_2

		local var_48_2 = Quaternion.flat_no_roll(Unit.local_rotation(arg_48_2, 0))
		local var_48_3 = Quaternion.multiply(Quaternion.axis_angle(Vector3.up(), math.pi), var_48_2)

		Unit.set_local_rotation(var_48_0, 0, var_48_3)

		if not arg_48_0.is_husk then
			var_48_1:set_wanted_velocity(Vector3.zero())
		end

		var_48_1:set_disabled(true, LocomotionUtils.update_local_animation_driven_movement_with_parent, arg_48_2)
	else
		var_48_1:set_disabled(false, LocomotionUtils.update_local_animation_driven_movement_with_parent)

		arg_48_0.pouncer_unit = nil
	end

	arg_48_0:set_outline_incapacitated(not arg_48_0:is_dead() and arg_48_0:is_disabled(), arg_48_2, arg_48_0.pounced_down)

	if arg_48_1 then
		SurroundingAwareSystem.add_event(var_48_0, "pounced_down", DialogueSettings.pounced_down_broadcast_range, "target", var_48_0, "target_name", ScriptUnit.extension(var_48_0, "dialogue_system").context.player_profile)

		local var_48_4 = ScriptUnit.extension_input(var_48_0, "dialogue_system")
		local var_48_5 = FrameTable.alloc_table()

		var_48_5.distance = DialogueSettings.pounced_down_broadcast_range
		var_48_5.target = var_48_0
		var_48_5.target_name = ScriptUnit.extension(var_48_0, "dialogue_system").context.player_profile

		var_48_4:trigger_dialogue_event("pounced_down", var_48_5)
		Managers.music:trigger_event("enemy_gutter_runner_pounced_stinger")
	end

	if arg_48_0.is_server then
		local var_48_6 = Managers.state.unit_storage:go_id(arg_48_0.unit)
		local var_48_7 = Managers.state.unit_storage:go_id(arg_48_2) or NetworkConstants.invalid_game_object_id

		Managers.state.network.network_transmit:send_rpc_clients("rpc_status_change_bool", NetworkLookup.statuses.pounced_down, arg_48_1, var_48_6, var_48_7)
	end

	if arg_48_1 then
		ScriptUnit.extension(var_48_0, "buff_system"):trigger_procs("on_player_disabled", "assassin_pounced", arg_48_2)
		Managers.state.event:trigger("on_player_disabled", "assassin_pounced", var_48_0, arg_48_2)
		Managers.state.achievement:trigger_event("register_player_disabled", var_48_0)

		if arg_48_0.is_server then
			arg_48_0.update_funcs.pounced_down = GenericStatusExtension.update_pounced_down
		end
	else
		arg_48_0.update_funcs.pounced_down = nil
	end

	if arg_48_0.is_server and arg_48_2 then
		local var_48_8 = Managers.player:unit_owner(arg_48_2)
		local var_48_9 = Unit.get_data(arg_48_2, "breed")

		if arg_48_1 and var_48_8 then
			StatisticsUtil.register_disable(var_48_8, Managers.player:statistics_db(), var_48_9.name)

			local var_48_10 = Managers.state.entity:system("versus_horde_ability_system")

			if var_48_10 then
				var_48_10:server_ability_recharge_boost(var_48_8.peer_id, "gutter_runner_pinned")
			end
		end
	end
end

function GenericStatusExtension.update_pounced_down(arg_49_0)
	assert(arg_49_0.is_server, "[GenericStatusExtension] 'update_pounced_down' is meant to only be called on the server")

	if not HEALTH_ALIVE[arg_49_0.pouncer_unit] then
		arg_49_0:set_pounced_down(false, nil)
	end
end

function GenericStatusExtension.set_crouching(arg_50_0, arg_50_1)
	arg_50_0.crouching = arg_50_1

	arg_50_0:set_slowed(arg_50_1)

	local var_50_0 = arg_50_0.player

	if var_50_0 and not var_50_0.remote then
		local var_50_1 = Managers.state.unit_storage:go_id(arg_50_0.unit)

		if arg_50_0.is_server then
			Managers.state.network.network_transmit:send_rpc_clients("rpc_status_change_bool", NetworkLookup.statuses.crouching, arg_50_1, var_50_1, 0)
		else
			Managers.state.network.network_transmit:send_rpc_server("rpc_status_change_bool", NetworkLookup.statuses.crouching, arg_50_1, var_50_1, 0)
		end
	end
end

function GenericStatusExtension.crouch_toggle(arg_51_0)
	return not arg_51_0.crouching
end

local var_0_11 = {}

function GenericStatusExtension.set_knocked_down(arg_52_0, arg_52_1)
	arg_52_0.knocked_down = arg_52_1

	local var_52_0 = arg_52_0.unit
	local var_52_1 = arg_52_0.health_extension or ScriptUnit.extension(var_52_0, "health_system")
	local var_52_2 = arg_52_0.buff_extension or ScriptUnit.extension(var_52_0, "buff_system")
	local var_52_3 = arg_52_0.player
	local var_52_4 = arg_52_0.is_server

	arg_52_0:set_outline_incapacitated(not arg_52_0:is_dead() and arg_52_0:is_disabled())

	if arg_52_1 then
		local var_52_5 = "knocked_down"
		local var_52_6 = arg_52_0._num_times_knocked_down

		if var_52_6 >= var_0_6 then
			var_52_5 = "knocked_down_multiple_times"
		end

		arg_52_0._num_times_knocked_down = var_52_6 + 1

		SurroundingAwareSystem.add_event(var_52_0, var_52_5, DialogueSettings.knocked_down_broadcast_range, "target", var_52_0, "target_name", ScriptUnit.extension(var_52_0, "dialogue_system").context.player_profile)

		local var_52_7 = ScriptUnit.extension_input(var_52_0, "dialogue_system")
		local var_52_8 = FrameTable.alloc_table()

		var_52_8.distance = 0
		var_52_8.height_distance = 0
		var_52_8.target_name = ScriptUnit.extension(var_52_0, "dialogue_system").context.player_profile

		var_52_7:trigger_dialogue_event("knocked_down", var_52_8)

		local var_52_9 = POSITION_LOOKUP[var_52_0]
		local var_52_10 = {}
		local var_52_11 = AiUtils.broadphase_query(var_52_9, DialogueSettings.knocked_down_broadcast_range, var_52_10)

		for iter_52_0 = 1, var_52_11 do
			local var_52_12 = var_52_10[iter_52_0]
			local var_52_13 = ScriptUnit.has_extension(var_52_12, "dialogue_system")

			if var_52_13 then
				var_52_13.input:trigger_dialogue_event("knocked_down", var_52_8)
			end
		end

		if var_52_4 and not arg_52_0.knocked_down_bleed_id then
			arg_52_0.knocked_down_bleed_id = var_52_2:add_buff("knockdown_bleed")
		end

		if var_52_3.local_player then
			Managers.state.camera:set_mood("knocked_down", arg_52_0, true)
		end

		var_52_2:trigger_procs("on_knocked_down")

		local var_52_14 = Managers.player:local_player()
		local var_52_15 = var_52_14 and var_52_14.player_unit

		if var_52_15 then
			local var_52_16 = ScriptUnit.has_extension(var_52_15, "buff_system")

			if var_52_16 then
				var_52_16:trigger_procs("on_ally_knocked_down", var_52_0)
			end
		end

		if arg_52_0._intoxication_level < 0 then
			arg_52_0._intoxication_level = -1
		end

		StatisticsUtil.register_knockdown(var_52_0, var_52_1, Managers.player:statistics_db(), var_52_4)

		local var_52_17 = Managers.mechanism:current_mechanism_name() == "versus"
		local var_52_18 = var_52_1:recent_damages()[3]
		local var_52_19 = Managers.state.side

		if var_52_17 and var_52_19:versus_is_dark_pact(var_52_15) then
			local var_52_20 = Managers.player:owner(var_52_18)

			if var_52_20 and var_52_20.peer_id == Network.peer_id() then
				local var_52_21 = Managers.world:wwise_world(arg_52_0.world)

				WwiseWorld.trigger_event(var_52_21, "versus_hud_skaven_down_hero_stinger_1p")
				WwiseWorld.trigger_event(var_52_21, "versus_hud_skaven_down_hero_stinger_3p")
			else
				local var_52_22 = Managers.world:wwise_world(arg_52_0.world)

				WwiseWorld.trigger_event(var_52_22, "versus_hud_skaven_down_hero_stinger_3p")
			end
		end
	else
		var_52_1:reset()

		if var_52_4 and arg_52_0.knocked_down_bleed_id then
			var_52_2:remove_buff(arg_52_0.knocked_down_bleed_id)

			arg_52_0.knocked_down_bleed_id = nil
		end

		if var_52_3.local_player then
			Managers.state.camera:set_mood("knocked_down", arg_52_0, false)
		end
	end

	if arg_52_1 then
		if var_52_4 then
			arg_52_0:add_pacing_intensity(CurrentIntensitySettings.intensity_add_knockdown)
		end

		local var_52_23, var_52_24 = var_52_1:recent_damages()

		pack_index[var_0_0.STRIDE](var_0_11, 1, unpack_index[var_0_0.STRIDE](var_52_23, 1))

		if var_52_3 then
			local var_52_25 = var_0_11[var_0_0.DAMAGE_TYPE]
			local var_52_26 = POSITION_LOOKUP[var_52_0]

			Managers.telemetry_events:player_knocked_down(var_52_3, var_52_25, var_52_26)
		end

		Managers.state.achievement:trigger_event("player_knocked_down", var_52_3)
	end

	Managers.music:check_last_man_standing_music_state()
end

function GenericStatusExtension.set_ready_for_assisted_respawn(arg_53_0, arg_53_1, arg_53_2)
	arg_53_0.ready_for_assisted_respawn = arg_53_1
	arg_53_0.assisted_respawn_flavour_unit = arg_53_2

	local var_53_0 = arg_53_0.unit
	local var_53_1 = ScriptUnit.has_extension(var_53_0, "outline_system")

	if not var_53_1 then
		return
	end

	local var_53_2 = arg_53_0.player

	if arg_53_1 then
		if var_53_2 and var_53_2.local_player then
			arg_53_0._assisted_respawn_outline_id = var_53_1:add_outline(OutlineSettings.templates.ready_for_assisted_respawn)
		else
			arg_53_0._assisted_respawn_outline_id = var_53_1:add_outline(OutlineSettings.templates.ready_for_assisted_respawn_husk)
		end
	else
		var_53_1:remove_outline(arg_53_0._assisted_respawn_outline_id)

		arg_53_0._assisted_respawn_outline_id = nil
	end
end

function GenericStatusExtension.set_assisted_respawning(arg_54_0, arg_54_1, arg_54_2)
	arg_54_0.assisted_respawning = arg_54_1
	arg_54_0.assisted_respawn_helper_unit = arg_54_2
end

function GenericStatusExtension.is_assisted_respawning(arg_55_0)
	return arg_55_0.assisted_respawning
end

function GenericStatusExtension.get_assisted_respawn_helper_unit(arg_56_0)
	return arg_56_0.assisted_respawn_helper_unit
end

function GenericStatusExtension.set_respawned(arg_57_0, arg_57_1)
	if arg_57_1 then
		arg_57_0:set_ready_for_assisted_respawn(false)
		Managers.music:check_last_man_standing_music_state()
	end
end

function GenericStatusExtension.set_dead(arg_58_0, arg_58_1)
	local var_58_0 = arg_58_0.player

	if arg_58_1 and ScriptUnit.has_extension(arg_58_0.unit, "outline_system") then
		ScriptUnit.extension(arg_58_0.unit, "outline_system"):add_outline(OutlineSettings.templates.dead)
	end

	if arg_58_1 and var_58_0 and not var_58_0.remote then
		local var_58_1 = arg_58_0.inventory_extension
		local var_58_2 = arg_58_0.career_extension

		CharacterStateHelper.stop_weapon_actions(var_58_1, "dead")
		CharacterStateHelper.stop_career_abilities(var_58_2, "dead")
	end

	Managers.state.achievement:trigger_event("player_dead", var_58_0)

	arg_58_0.dead = arg_58_1
end

function GenericStatusExtension.set_blocking(arg_59_0, arg_59_1)
	arg_59_0.blocking = arg_59_1

	local var_59_0 = arg_59_0.inventory_extension
	local var_59_1 = var_59_0:get_wielded_slot_name()
	local var_59_2 = var_59_0:get_slot_data(var_59_1)

	if var_59_2 then
		arg_59_0.shield_block = var_59_0:get_item_template(var_59_2).shield_block or false
	end

	if arg_59_1 then
		arg_59_0.raise_block_time = Managers.time:time("game")
	end
end

function GenericStatusExtension.set_override_blocking(arg_60_0, arg_60_1, arg_60_2)
	arg_60_0.override_blocking = arg_60_1

	if arg_60_2 then
		local var_60_0 = Managers.state.network
		local var_60_1 = var_60_0:game()
		local var_60_2 = var_60_0:unit_game_object_id(arg_60_0.unit)

		if var_60_2 and var_60_1 then
			var_60_0.network_transmit:send_rpc_server("rpc_set_override_blocking", var_60_2, arg_60_1 or false)
		end
	end
end

function GenericStatusExtension.set_charge_blocking(arg_61_0, arg_61_1)
	arg_61_0.charge_blocking = arg_61_1
end

function GenericStatusExtension.set_stagger_immmune(arg_62_0, arg_62_1)
	arg_62_0.stagger_immune = arg_62_1
end

function GenericStatusExtension.set_slowed(arg_63_0, arg_63_1)
	arg_63_0.is_slowed = arg_63_1
end

function GenericStatusExtension.set_wounded(arg_64_0, arg_64_1, arg_64_2, arg_64_3)
	if arg_64_1 then
		if not arg_64_0.buff_extension:has_buff_perk("infinite_wounds") then
			arg_64_0.wounds = arg_64_0.wounds - 1
		end
	elseif arg_64_2 == "healed" then
		arg_64_0.wounds = arg_64_0:get_max_wounds()
	end

	if arg_64_0.player.local_player and not Managers.state.game_mode:has_activated_mutator("instant_death") then
		local var_64_0 = Managers.state.camera
		local var_64_1 = arg_64_0:is_wounded()
		local var_64_2 = arg_64_0:wounded_and_on_last_wound()

		var_64_0:set_mood("bleeding_out", arg_64_0, var_64_1)
		var_64_0:set_mood("wounded", arg_64_0, var_64_2)
	end
end

function GenericStatusExtension.set_pulled_up(arg_65_0, arg_65_1, arg_65_2)
	if arg_65_0.is_ledge_hanging then
		arg_65_0.pulled_up = arg_65_1

		if arg_65_1 and ALIVE[arg_65_2] then
			local var_65_0 = ScriptUnit.extension_input(arg_65_0.unit, "dialogue_system")
			local var_65_1 = FrameTable.alloc_table()

			var_65_1.reviver = arg_65_2
			var_65_1.reviver_name = ScriptUnit.extension(arg_65_2, "dialogue_system").context.player_profile

			var_65_0:trigger_dialogue_event("revive_completed", var_65_1)
		end
	elseif not arg_65_1 then
		arg_65_0.pulled_up = arg_65_1
	end
end

function GenericStatusExtension.set_revived(arg_66_0, arg_66_1, arg_66_2)
	arg_66_0.revived = arg_66_1

	local var_66_0 = arg_66_0.unit

	if arg_66_1 then
		if ALIVE[arg_66_2] then
			local var_66_1 = ScriptUnit.extension_input(var_66_0, "dialogue_system")
			local var_66_2 = FrameTable.alloc_table()

			var_66_2.reviver = arg_66_2
			var_66_2.reviver_name = ScriptUnit.extension(arg_66_2, "dialogue_system").context.player_profile

			var_66_1:trigger_dialogue_event("revive_completed", var_66_2)
			ScriptUnit.extension(arg_66_2, "buff_system"):trigger_procs("on_revived_ally", var_66_0)
		end

		ScriptUnit.extension(var_66_0, "buff_system"):trigger_procs("on_revived", arg_66_2)
	end
end

function GenericStatusExtension.set_zooming(arg_67_0, arg_67_1, arg_67_2)
	arg_67_0.zooming = arg_67_1

	arg_67_0:set_slowed(arg_67_1)

	local var_67_0 = arg_67_0.player.camera_follow_unit

	if arg_67_1 then
		if Unit.alive(var_67_0) then
			arg_67_2 = arg_67_2 or "zoom_in"

			if Development.parameter("third_person_mode") then
				arg_67_2 = arg_67_2 .. "_third_person"
			end

			Unit.set_data(var_67_0, "camera", "settings_node", arg_67_2)

			arg_67_0.zoom_mode = arg_67_2
		end
	else
		if Unit.alive(var_67_0) then
			if Development.parameter("third_person_mode") then
				Unit.set_data(var_67_0, "camera", "settings_node", "over_shoulder")
			else
				Unit.set_data(var_67_0, "camera", "settings_node", "first_person_node")
			end
		end

		arg_67_0.zoom_mode = nil
	end
end

local var_0_12 = {
	"zoom_in",
	"increased_zoom_in"
}

function GenericStatusExtension.switch_variable_zoom(arg_68_0, arg_68_1)
	local var_68_0 = arg_68_0.player.camera_follow_unit

	if Unit.alive(var_68_0) then
		arg_68_1 = arg_68_1 or var_0_12

		local var_68_1 = 1

		for iter_68_0, iter_68_1 in ipairs(arg_68_1) do
			if iter_68_1 == arg_68_0.zoom_mode then
				var_68_1 = iter_68_0 % #arg_68_1 + 1

				break
			end
		end

		local var_68_2 = arg_68_1[var_68_1]

		Unit.set_data(var_68_0, "camera", "settings_node", var_68_2)

		arg_68_0.zoom_mode = var_68_2
	end
end

function GenericStatusExtension.set_grabbed_by_tentacle(arg_69_0, arg_69_1, arg_69_2)
	arg_69_0.grabbed_by_tentacle = arg_69_1
	arg_69_0.grabbed_by_tentacle_unit = arg_69_2
	arg_69_0.grabbed_by_tentacle_status = arg_69_1 and "grabbed" or nil
end

function GenericStatusExtension.set_grabbed_by_tentacle_status(arg_70_0, arg_70_1)
	arg_70_0.grabbed_by_tentacle_status = arg_70_1
end

function GenericStatusExtension.set_grabbed_by_chaos_spawn(arg_71_0, arg_71_1, arg_71_2)
	arg_71_0.grabbed_by_chaos_spawn = arg_71_1

	if arg_71_1 then
		arg_71_0.grabbed_by_chaos_spawn_status = "grabbed"
		arg_71_0.grabbed_by_chaos_spawn_status_count = 1
		arg_71_0.grabbed_by_chaos_spawn_unit = arg_71_2
	else
		arg_71_0.grabbed_by_chaos_spawn_status = nil
		arg_71_0.grabbed_by_chaos_spawn_status_count = nil
	end
end

function GenericStatusExtension.set_grabbed_by_chaos_spawn_status(arg_72_0, arg_72_1)
	if arg_72_0.grabbed_by_chaos_spawn_status_count then
		arg_72_0.grabbed_by_chaos_spawn_status = arg_72_1
		arg_72_0.grabbed_by_chaos_spawn_status_count = arg_72_0.grabbed_by_chaos_spawn_status_count + 1
	end
end

function GenericStatusExtension.set_in_vortex(arg_73_0, arg_73_1, arg_73_2)
	arg_73_0.in_vortex = arg_73_1
	arg_73_0.in_vortex_unit = arg_73_1 and arg_73_2 or nil

	arg_73_0:set_outline_incapacitated(not arg_73_0:is_dead() and arg_73_0:is_disabled())
end

function GenericStatusExtension.set_near_vortex(arg_74_0, arg_74_1, arg_74_2)
	arg_74_0.near_vortex = arg_74_1
	arg_74_0.near_vortex_unit = arg_74_1 and arg_74_2 or nil
end

function GenericStatusExtension.set_in_liquid(arg_75_0, arg_75_1, arg_75_2)
	arg_75_0.in_liquid = arg_75_1
	arg_75_0.in_liquid_unit = arg_75_1 and arg_75_2 or nil
end

function GenericStatusExtension.set_catapulted(arg_76_0, arg_76_1, arg_76_2)
	local var_76_0 = arg_76_0.unit

	if arg_76_1 then
		if not arg_76_0:is_disabled() then
			arg_76_0.catapulted = true
			arg_76_0.last_catapulted_time = Managers.time:time("game")

			if not arg_76_0.is_husk then
				arg_76_0.catapulted_velocity = Vector3Box(arg_76_2)

				local var_76_1 = ScriptUnit.extension(var_76_0, "first_person_system")
				local var_76_2 = Vector3.dot(Quaternion.forward(var_76_1:current_rotation()), arg_76_2)
				local var_76_3
				local var_76_4
				local var_76_5

				if var_76_2 > 0 then
					var_76_3 = Vector3.normalize(arg_76_2)
					var_76_5 = "forward"
				else
					var_76_3 = Vector3.normalize(-arg_76_2)
					var_76_5 = "backward"
				end

				arg_76_0.catapulted_direction = var_76_5

				local var_76_6 = Quaternion.look(var_76_3, Vector3.up())

				var_76_1:force_look_rotation(var_76_6)
			end
		end
	else
		arg_76_0.catapulted = false
		arg_76_0.catapulted_direction = nil
		arg_76_0.catapulted_velocity = nil
	end

	local var_76_7 = arg_76_0.player

	if var_76_7 and not var_76_7.remote and Managers.state.network:game() then
		local var_76_8 = Managers.state.unit_storage:go_id(var_76_0)

		if arg_76_0.is_server then
			Managers.state.network.network_transmit:send_rpc_clients("rpc_set_catapulted", var_76_8, arg_76_1, arg_76_2 or Vector3.zero())
		else
			Managers.state.network.network_transmit:send_rpc_server("rpc_set_catapulted", var_76_8, arg_76_1, arg_76_2 or Vector3.zero())
		end
	end
end

function GenericStatusExtension.leap_start(arg_77_0, arg_77_1)
	ScriptUnit.has_extension(arg_77_1, "buff_system"):trigger_procs("on_leap_start")
end

function GenericStatusExtension.leap_finished(arg_78_0, arg_78_1)
	ScriptUnit.has_extension(arg_78_1, "buff_system"):trigger_procs("on_leap_finished")
end

function GenericStatusExtension.set_inside_transport_unit(arg_79_0, arg_79_1)
	arg_79_0.inside_transport_unit = arg_79_1
end

function GenericStatusExtension.set_using_transport(arg_80_0, arg_80_1)
	arg_80_0.using_transport = arg_80_1
end

function GenericStatusExtension.set_overcharge_exploding(arg_81_0, arg_81_1)
	arg_81_0.overcharge_exploding = arg_81_1
end

function GenericStatusExtension.set_left_ladder(arg_82_0, arg_82_1)
	arg_82_0.left_ladder_timer = arg_82_1 + PlayerUnitMovementSettings.get_movement_settings_table(arg_82_0.unit).ladder.leave_ladder_reattach_time
end

function GenericStatusExtension.set_is_on_ladder(arg_83_0, arg_83_1, arg_83_2)
	arg_83_0.on_ladder = arg_83_1
	arg_83_0.current_ladder_unit = arg_83_2
end

function GenericStatusExtension.set_is_ledge_hanging(arg_84_0, arg_84_1, arg_84_2)
	arg_84_0.is_ledge_hanging = arg_84_1
	arg_84_0.current_ledge_hanging_unit = arg_84_2

	local var_84_0 = arg_84_0.unit

	if not arg_84_1 then
		arg_84_0.pulled_up = false
	end

	local var_84_1 = ScriptUnit.has_extension(var_84_0, "buff_system")

	if arg_84_1 and var_84_1 then
		var_84_1:trigger_procs("on_ledge_hang_start")
	end

	arg_84_0:set_outline_incapacitated(not arg_84_0:is_dead() and arg_84_0:is_disabled())

	if arg_84_1 then
		SurroundingAwareSystem.add_event(var_84_0, "ledge_hanging", DialogueSettings.grabbed_broadcast_range, "target", var_84_0, "target_name", ScriptUnit.extension(var_84_0, "dialogue_system").context.player_profile)

		local var_84_2 = ScriptUnit.extension_input(var_84_0, "dialogue_system")
		local var_84_3 = FrameTable.alloc_table()

		var_84_3.target_name = ScriptUnit.extension(var_84_0, "dialogue_system").context.player_profile

		var_84_2:trigger_dialogue_event("ledge_hanging", var_84_3)
		Managers.state.achievement:trigger_event("register_player_disabled", var_84_0)
	end
end

function GenericStatusExtension.set_in_hanging_cage(arg_85_0, arg_85_1, arg_85_2, arg_85_3, arg_85_4)
	if arg_85_1 then
		arg_85_0.in_hanging_cage_unit = arg_85_2 or arg_85_0.in_hanging_cage_unit
		arg_85_0.in_hanging_cage_state = arg_85_3 or arg_85_0.in_hanging_cage_state
		arg_85_0.in_hanging_cage_animations = arg_85_4 or arg_85_0.in_hanging_cage_animations
	else
		arg_85_0.in_hanging_cage_unit = nil
		arg_85_0.in_hanging_cage_state = nil
		arg_85_0.in_hanging_cage_animations = nil
	end

	arg_85_0.in_hanging_cage = arg_85_1
end

function GenericStatusExtension.set_outline_incapacitated(arg_86_0, arg_86_1, arg_86_2, arg_86_3)
	local var_86_0 = arg_86_0.unit
	local var_86_1 = arg_86_0.player

	if not var_86_1 then
		return
	end

	local var_86_2 = ScriptUnit.has_extension(var_86_0, "outline_system")

	if not var_86_2 then
		return
	end

	if arg_86_1 then
		if not var_86_1.local_player and not arg_86_0._incapacitated_outline_ids.target_id then
			arg_86_0._incapacitated_outline_ids.target_id = var_86_2:add_outline(OutlineSettings.templates.incapacitated)
		end
	else
		local var_86_3 = arg_86_0._incapacitated_outline_ids

		var_86_2:remove_outline(var_86_3.target_id)

		var_86_3.target_id = nil
	end

	local var_86_4 = ScriptUnit.has_extension(arg_86_2, "outline_system")

	if var_86_4 then
		arg_86_3 = var_86_4 and arg_86_3

		local var_86_5 = arg_86_0._incapacitated_outline_ids
		local var_86_6 = var_86_5.disabler_id

		if arg_86_3 then
			if not var_86_6 then
				var_86_5.disabler_id = var_86_4:add_outline(OutlineSettings.templates.incapacitated)
			end
		elseif var_86_6 then
			var_86_4:remove_outline(var_86_6)

			var_86_5.disabler_id = nil
		end
	end
end

function GenericStatusExtension._set_packmaster_unhooked(arg_87_0, arg_87_1, arg_87_2)
	local var_87_0 = Managers.time:time("game")

	if arg_87_0.release_unhook_time then
		-- block empty
	elseif arg_87_0.dead then
		if arg_87_2 == "pack_master_dragging" or arg_87_2 == "pack_master_pulling" then
			arg_87_0.release_unhook_time = var_87_0 + PlayerUnitStatusSettings.hanging_by_pack_master.release_dragging_time_dead
		else
			arg_87_0.release_unhook_time = var_87_0 + PlayerUnitStatusSettings.hanging_by_pack_master.release_unhook_time_dead
		end
	elseif arg_87_0.knocked_down then
		arg_87_0.release_unhook_time = var_87_0 + PlayerUnitStatusSettings.hanging_by_pack_master.release_unhook_time_ko
	else
		arg_87_0.release_unhook_time = var_87_0 + PlayerUnitStatusSettings.hanging_by_pack_master.release_unhook_time
	end

	if not arg_87_0.is_husk then
		arg_87_1:set_wanted_velocity(Vector3.zero())
		arg_87_1:move_to_non_intersecting_position()
	end

	arg_87_0.pack_master_status = "pack_master_unhooked"
	arg_87_0.pack_master_grabber = nil
	arg_87_0.pack_master_player = nil
end

function GenericStatusExtension.set_pack_master(arg_88_0, arg_88_1, arg_88_2, arg_88_3)
	if arg_88_0.is_server then
		local var_88_0 = arg_88_0.pack_master_grabber

		if arg_88_3 and arg_88_3 ~= var_88_0 and ALIVE[var_88_0] then
			local var_88_1 = false
			local var_88_2 = true

			return var_88_1, var_88_2, var_88_0
		end
	end

	local var_88_3 = arg_88_0.unit

	arg_88_0.pack_master_grabber = arg_88_2 and arg_88_3 or nil
	arg_88_0.pack_master_player = Managers.player:owner(arg_88_0.pack_master_grabber)

	local var_88_4 = arg_88_0.pack_master_status

	arg_88_0.pack_master_status = arg_88_1

	if arg_88_2 then
		ScriptUnit.extension(var_88_3, "buff_system"):trigger_procs("on_player_disabled", "pack_master_grab", arg_88_3)
		Managers.state.event:trigger("on_player_disabled", "pack_master_grab", var_88_3, arg_88_3)
		Managers.state.achievement:trigger_event("register_player_disabled", var_88_3)
	end

	local var_88_5 = ScriptUnit.extension(var_88_3, "locomotion_system")
	local var_88_6 = arg_88_2 and arg_88_1 ~= "pack_master_hanging"
	local var_88_7 = Managers.player
	local var_88_8 = var_88_7:unit_owner(arg_88_3)

	if var_88_7:local_player() ~= var_88_8 then
		arg_88_0:set_outline_incapacitated(not arg_88_0:is_dead() and arg_88_0:is_disabled(), arg_88_3, var_88_6)
	end

	if arg_88_1 == "pack_master_pulling" then
		if not arg_88_2 then
			arg_88_0:_set_packmaster_unhooked(var_88_5, arg_88_1)

			return true
		end

		local var_88_9 = ALIVE[arg_88_3] and Unit.get_data(arg_88_3, "breed")

		if not var_88_4 and var_88_9 and var_88_9.is_player and var_88_8 and arg_88_0.is_server then
			StatisticsUtil.register_disable(var_88_8, Managers.player:statistics_db(), var_88_9.name)

			local var_88_10 = Managers.state.entity:system("versus_horde_ability_system")

			if var_88_10 then
				var_88_10:server_ability_recharge_boost(var_88_8.peer_id, "pack_master_grab")
			end
		end

		arg_88_0.release_unhook_time = nil

		local var_88_11 = Unit.local_rotation(arg_88_3, 0)
		local var_88_12 = Quaternion.forward(var_88_11)
		local var_88_13 = Quaternion.look(var_88_12, Vector3.up())

		Unit.set_local_rotation(var_88_3, 0, var_88_13)

		if not arg_88_0.is_husk then
			var_88_5:set_wanted_velocity(Vector3.zero())
		end

		local var_88_14 = SPProfiles[arg_88_0.profile_id].unit_name
		local var_88_15 = "attack_grab_" .. var_88_14

		Unit.animation_event(arg_88_3, var_88_15)

		local var_88_16 = "grabbed"
		local var_88_17 = arg_88_0._num_times_grabbed_by_pack_master

		if var_88_17 >= var_0_3 then
			var_88_16 = "grabbed_multiple_times"
		end

		arg_88_0._num_times_grabbed_by_pack_master = var_88_17 + 1

		SurroundingAwareSystem.add_event(var_88_3, var_88_16, DialogueSettings.grabbed_broadcast_range, "target", var_88_3, "target_name", ScriptUnit.extension(var_88_3, "dialogue_system").context.player_profile, "enemy_tag", "skaven_pack_master")
		Managers.music:trigger_event("enemy_pack_master_grabbed_stinger")
	elseif arg_88_1 == "pack_master_dragging" then
		if not arg_88_2 then
			arg_88_0:_set_packmaster_unhooked(var_88_5, arg_88_1)

			return true
		end

		if var_88_4 == "pack_master_pulling" then
			var_88_5:set_disabled(false, nil, nil, true)
		end
	elseif arg_88_1 == "pack_master_unhooked" then
		if var_88_4 ~= "pack_master_unhooked" then
			arg_88_0:_set_packmaster_unhooked(var_88_5, arg_88_1)
		end

		var_88_5:set_disabled(false, nil, nil, true)
	elseif arg_88_1 == "pack_master_hoisting" then
		if not arg_88_2 then
			arg_88_0:_set_packmaster_unhooked(var_88_5, arg_88_1)

			return true
		end

		if not arg_88_0.is_husk then
			var_88_5:set_wanted_velocity(Vector3.zero())
		end

		local function var_88_18()
			if not ALIVE[var_88_3] then
				return
			end

			local var_89_0 = ALIVE[arg_88_3] and Unit.get_data(arg_88_3, "breed")

			if var_89_0 and var_89_0.is_player then
				local var_89_1 = World.get_data(arg_88_0.world, "physics_world")
				local var_89_2 = PactswornUtils.get_hoist_position(var_89_1, var_88_3, arg_88_3)

				var_88_5:teleport_to(var_89_2, nil)
			end
		end

		Managers.state.entity:system("ai_navigation_system"):add_safe_navigation_callback(var_88_18)

		local var_88_19 = Vector3.normalize(POSITION_LOOKUP[var_88_3] - POSITION_LOOKUP[arg_88_3])

		Vector3.set_z(var_88_19, 0)
		Unit.set_local_rotation(var_88_3, 0, Quaternion.look(var_88_19, Vector3.up()))
		var_88_5:set_disabled(true, LocomotionUtils.update_local_animation_driven_movement_plus_mover)
	elseif arg_88_1 == "pack_master_hanging" then
		var_88_5:set_disabled(true, LocomotionUtils.update_local_animation_driven_movement_plus_mover)

		if arg_88_0.is_server then
			local var_88_20 = Managers.state.entity:system("versus_horde_ability_system")

			if var_88_20 and var_88_8 then
				var_88_20:server_ability_recharge_boost(var_88_8.peer_id, "pack_master_hoist")
			end

			if Managers.player:owner(arg_88_3) then
				ScriptUnit.extension_input(arg_88_3, "dialogue_system"):trigger_dialogue_event("vs_packmaster_hoisted_player")
			end
		end
	elseif arg_88_1 == "pack_master_dropping" then
		local var_88_21 = Managers.time:time("game")

		var_88_5:set_disabled(false, nil, nil, true)

		if arg_88_0.release_falling_time then
			-- block empty
		elseif arg_88_0.dead then
			arg_88_0.release_falling_time = var_88_21 + PlayerUnitStatusSettings.hanging_by_pack_master.release_falling_time_dead
		elseif arg_88_0.knocked_down then
			arg_88_0.release_falling_time = var_88_21 + PlayerUnitStatusSettings.hanging_by_pack_master.release_falling_time_ko
		else
			var_88_5:set_disabled(false, nil, nil, true)

			arg_88_0.release_falling_time = var_88_21 + PlayerUnitStatusSettings.hanging_by_pack_master.release_falling_time
		end
	elseif arg_88_1 == "pack_master_released" then
		SurroundingAwareSystem.add_event(var_88_3, "un_grabbed", DialogueSettings.grabbed_broadcast_range, "target", var_88_3, "target_name", ScriptUnit.extension(var_88_3, "dialogue_system").context.player_profile)

		if not Managers.state.network.is_server then
			var_88_5:set_disabled(false, nil, nil, true)
		end
	end

	return true
end

function GenericStatusExtension.query_pack_master_player(arg_90_0)
	return arg_90_0.pack_master_player
end

function GenericStatusExtension.hit_by_globadier_poison(arg_91_0, arg_91_1)
	local var_91_0 = Managers.time:time("game")
	local var_91_1 = arg_91_0._hit_by_globadier_poison_instances
	local var_91_2 = 0

	for iter_91_0, iter_91_1 in pairs(var_91_1) do
		if var_91_0 > iter_91_1.t then
			var_91_1[iter_91_0] = nil
		elseif not iter_91_1.claimed then
			var_91_2 = var_91_2 + 1
		end
	end

	local var_91_3 = "hit_by_goo"

	if var_91_1[arg_91_1] then
		var_91_1[arg_91_1].t = var_91_0 + var_0_5
	else
		var_91_1[arg_91_1] = {
			t = var_91_0 + var_0_5
		}
		var_91_2 = var_91_2 + 1
	end

	if var_91_2 > var_0_4 then
		var_91_3 = "hit_by_goo_multiple_times"

		for iter_91_2, iter_91_3 in pairs(var_91_1) do
			iter_91_3.claimed = true
		end
	end

	local var_91_4 = arg_91_0.unit

	SurroundingAwareSystem.add_event(var_91_4, var_91_3, DialogueSettings.globadier_poisoned_broadcast_range, "target", var_91_4, "target_name", ScriptUnit.extension(var_91_4, "dialogue_system").context.player_profile)
end

function GenericStatusExtension.set_grabbed_by_corruptor(arg_92_0, arg_92_1, arg_92_2, arg_92_3)
	local var_92_0 = arg_92_0.unit

	arg_92_0.corruptor_grabbed = arg_92_2 and arg_92_3 or nil
	arg_92_0.grabbed_by_corruptor = arg_92_2
	arg_92_0.corruptor_unit = arg_92_3
	arg_92_0.corruptor_status = arg_92_1

	arg_92_0:set_outline_incapacitated(not arg_92_0:is_dead() and arg_92_0:is_disabled(), arg_92_3, arg_92_2)

	local var_92_1 = ScriptUnit.extension(var_92_0, "locomotion_system")

	if arg_92_1 == "chaos_corruptor_grabbed" then
		if not arg_92_0.is_husk then
			var_92_1:set_wanted_velocity(Vector3.zero())
		end

		SurroundingAwareSystem.add_event(var_92_0, "grabbed", DialogueSettings.grabbed_broadcast_range, "target", var_92_0, "target_name", ScriptUnit.extension(var_92_0, "dialogue_system").context.player_profile, "enemy_tag", "chaos_corruptor_sorcerer")
		Managers.music:trigger_event("enemy_pack_master_grabbed_stinger")
	elseif arg_92_1 == "chaos_corruptor_released" and not arg_92_0.is_husk then
		var_92_1:set_wanted_velocity(Vector3.zero())
		var_92_1:move_to_non_intersecting_position()
	end

	if arg_92_2 then
		ScriptUnit.extension(var_92_0, "buff_system"):trigger_procs("on_player_disabled", "corruptor_grab", arg_92_0.corruptor_unit)
		Managers.state.event:trigger("on_player_disabled", "corruptor_grab", var_92_0, arg_92_0.corruptor_unit)
		Managers.state.achievement:trigger_event("register_player_disabled", var_92_0)
	end
end

function GenericStatusExtension.get_pacing_intensity(arg_93_0)
	return arg_93_0.pacing_intensity
end

function GenericStatusExtension.get_combo_target_count(arg_94_0)
	return arg_94_0.combo_target_count
end

function GenericStatusExtension.is_pounced_down(arg_95_0)
	return arg_95_0.pounced_down, arg_95_0.pouncer_unit
end

function GenericStatusExtension.get_pouncer_unit(arg_96_0)
	return arg_96_0.pouncer_unit
end

function GenericStatusExtension.is_knocked_down(arg_97_0)
	return arg_97_0.knocked_down
end

function GenericStatusExtension.set_knocked_down_bleed_buff_paused(arg_98_0, arg_98_1)
	local var_98_0 = arg_98_0.unit
	local var_98_1 = arg_98_0.buff_extension or ScriptUnit.extension(var_98_0, "buff_system")

	if arg_98_0.knocked_down_bleed_id and arg_98_1 then
		var_98_1:remove_buff(arg_98_0.knocked_down_bleed_id)

		arg_98_0.knocked_down_bleed_id = nil
	elseif arg_98_0.knocked_down and not arg_98_1 and not arg_98_0.knocked_down_bleed_id then
		arg_98_0.knocked_down_bleed_id = var_98_1:add_buff("knockdown_bleed")
	end

	return arg_98_0.knocked_down_bleed_id
end

function GenericStatusExtension.is_ready_for_assisted_respawn(arg_99_0)
	return arg_99_0.ready_for_assisted_respawn
end

function GenericStatusExtension.disabled_vo_reason(arg_100_0)
	local var_100_0

	if arg_100_0:is_dead() then
		var_100_0 = "dead"
	elseif arg_100_0:is_pounced_down() then
		var_100_0 = "pounced_down"
	elseif arg_100_0:is_grabbed_by_pack_master() or arg_100_0:is_hanging_from_hook() then
		var_100_0 = "grabbed"
	elseif arg_100_0:get_is_ledge_hanging() then
		var_100_0 = "ledge_hanging"
	elseif arg_100_0:is_knocked_down() or arg_100_0:is_ready_for_assisted_respawn() then
		var_100_0 = "knocked_down"
	end

	return var_100_0
end

function GenericStatusExtension.set_has_bonus_fatigue_active(arg_101_0)
	arg_101_0.has_bonus_fatigue_active = true
	arg_101_0.bonus_fatigue_active_timer = Managers.time:time("game") + 1.5

	local var_101_0 = arg_101_0.first_person_extension

	if var_101_0 then
		var_101_0:play_hud_sound_event("hud_player_buff_regen_stamina")
	end
end

function GenericStatusExtension.get_disabler_unit(arg_102_0)
	local var_102_0 = arg_102_0.grabbed_by_tentacle_unit or arg_102_0.pouncer_unit or arg_102_0.grabbed_by_chaos_spawn_unit or arg_102_0.pack_master_grabber or arg_102_0.corruptor_unit

	if Unit.alive(var_102_0) then
		return var_102_0
	end
end

function GenericStatusExtension.is_disabled_by_pact_sworn(arg_103_0)
	return arg_103_0:is_hanging_from_hook() or arg_103_0:is_grabbed_by_tentacle() or arg_103_0:is_grabbed_by_chaos_spawn() or arg_103_0:is_in_vortex() or arg_103_0:is_grabbed_by_corruptor() or arg_103_0:is_pounced_down() or arg_103_0:is_grabbed_by_pack_master()
end

function GenericStatusExtension.is_disabled(arg_104_0)
	return arg_104_0:is_dead() or arg_104_0:is_knocked_down() or arg_104_0:get_is_ledge_hanging() or arg_104_0:is_hanging_from_hook() or arg_104_0:is_ready_for_assisted_respawn() or arg_104_0:is_grabbed_by_tentacle() or arg_104_0:is_grabbed_by_chaos_spawn() or arg_104_0:is_in_vortex() or arg_104_0:is_grabbed_by_corruptor() or arg_104_0:is_overpowered() or arg_104_0:is_pounced_down() or arg_104_0:is_grabbed_by_pack_master()
end

function GenericStatusExtension.disabled_by_other(arg_105_0, arg_105_1)
	return arg_105_0:is_dead() or arg_105_0:is_knocked_down() or arg_105_0:get_is_ledge_hanging() or arg_105_0:is_hanging_from_hook() or arg_105_0:is_ready_for_assisted_respawn() or arg_105_0:is_grabbed_by_tentacle() or arg_105_0:is_grabbed_by_chaos_spawn() or arg_105_0:is_in_vortex() or arg_105_0:is_grabbed_by_corruptor() or arg_105_0:is_overpowered() or arg_105_0:is_pounced_down() and arg_105_0:get_pouncer_unit() ~= arg_105_1 or arg_105_0:is_grabbed_by_pack_master() and arg_105_0:get_pack_master_grabber() ~= arg_105_1
end

function GenericStatusExtension.is_disabled_non_temporarily(arg_106_0)
	return arg_106_0:is_dead() or arg_106_0:is_pounced_down() or arg_106_0:is_knocked_down() or arg_106_0:is_grabbed_by_pack_master() or arg_106_0:get_is_ledge_hanging() or arg_106_0:is_hanging_from_hook() or arg_106_0:is_ready_for_assisted_respawn() or arg_106_0:is_grabbed_by_tentacle() or arg_106_0:is_grabbed_by_corruptor() or arg_106_0:is_overpowered()
end

function GenericStatusExtension.is_valid_vortex_target(arg_107_0)
	return not arg_107_0:is_dead() and not arg_107_0:is_pounced_down() and not arg_107_0:is_knocked_down() and not arg_107_0:is_grabbed_by_pack_master() and not arg_107_0:get_is_ledge_hanging() and not arg_107_0:is_hanging_from_hook() and not arg_107_0:is_ready_for_assisted_respawn() and not arg_107_0:is_grabbed_by_tentacle() and not arg_107_0:is_grabbed_by_chaos_spawn() and not arg_107_0:is_in_end_zone()
end

function GenericStatusExtension.is_valid_corruptor_target(arg_108_0)
	return not arg_108_0:is_dead() and not arg_108_0:is_pounced_down() and not arg_108_0:is_knocked_down() and not arg_108_0:is_grabbed_by_pack_master() and not arg_108_0:get_is_ledge_hanging() and not arg_108_0:is_hanging_from_hook() and not arg_108_0:is_ready_for_assisted_respawn() and not arg_108_0:is_grabbed_by_tentacle() and not arg_108_0:is_grabbed_by_chaos_spawn() and not arg_108_0:is_in_end_zone()
end

function GenericStatusExtension.is_ogre_target(arg_109_0)
	return not arg_109_0:is_dead() and not arg_109_0:is_pounced_down() and not arg_109_0:is_grabbed_by_pack_master() and not arg_109_0:is_hanging_from_hook() and not arg_109_0:is_using_transport() and not arg_109_0:is_grabbed_by_tentacle() and not arg_109_0:is_grabbed_by_chaos_spawn()
end

function GenericStatusExtension.is_chaos_spawn_target(arg_110_0)
	return not arg_110_0:is_dead() and not arg_110_0:is_knocked_down() and not arg_110_0:is_pounced_down() and not arg_110_0:is_grabbed_by_pack_master() and not arg_110_0:is_hanging_from_hook() and not arg_110_0:is_using_transport() and not arg_110_0:is_grabbed_by_tentacle() and not arg_110_0:is_grabbed_by_chaos_spawn()
end

function GenericStatusExtension.is_lord_target(arg_111_0)
	return not arg_111_0:is_dead() and not arg_111_0:is_knocked_down() and not arg_111_0:is_pounced_down() and not arg_111_0:is_grabbed_by_pack_master() and not arg_111_0:is_hanging_from_hook() and not arg_111_0:is_using_transport() and not arg_111_0:is_grabbed_by_tentacle() and not arg_111_0:is_grabbed_by_chaos_spawn()
end

function GenericStatusExtension.is_available_for_career_revive(arg_112_0)
	return arg_112_0:is_knocked_down() and not arg_112_0:is_pounced_down() and not arg_112_0:is_grabbed_by_pack_master() and not arg_112_0:is_hanging_from_hook() and not arg_112_0:is_grabbed_by_tentacle() and not arg_112_0:is_grabbed_by_chaos_spawn()
end

function GenericStatusExtension.is_grabbed_by_tentacle(arg_113_0)
	return arg_113_0.grabbed_by_tentacle
end

function GenericStatusExtension.is_grabbed_by_corruptor(arg_114_0)
	return arg_114_0.grabbed_by_corruptor
end

function GenericStatusExtension.is_grabbed_by_chaos_spawn(arg_115_0)
	return arg_115_0.grabbed_by_chaos_spawn
end

function GenericStatusExtension.is_in_liquid(arg_116_0)
	return arg_116_0.in_liquid
end

function GenericStatusExtension.is_dead(arg_117_0)
	return arg_117_0.dead
end

function GenericStatusExtension.is_crouching(arg_118_0)
	return arg_118_0.crouching
end

function GenericStatusExtension.is_blocking(arg_119_0)
	return arg_119_0.override_blocking == nil and arg_119_0.blocking or arg_119_0.override_blocking, arg_119_0.shield_block
end

function GenericStatusExtension.is_wounded(arg_120_0)
	return arg_120_0.wounds < arg_120_0:get_max_wounds()
end

function GenericStatusExtension.wounded_and_on_last_wound(arg_121_0)
	return arg_121_0.wounds == 1 and arg_121_0:get_max_wounds() > 1
end

function GenericStatusExtension.is_permanent_heal(arg_122_0, arg_122_1)
	local var_122_0 = ScriptUnit.has_extension(arg_122_0.unit, "buff_system")

	if var_122_0 then
		if var_122_0:has_buff_perk("disable_permanent_heal") then
			return false
		end

		if var_122_0:has_buff_perk("temp_to_permanent_health") then
			return true
		end
	end

	return arg_122_1 == "healing_draught" or arg_122_1 == "bandage" or arg_122_1 == "bandage_trinket" or arg_122_1 == "buff_shared_medpack" or arg_122_1 == "career_passive" or arg_122_1 == "health_regen" or arg_122_1 == "debug" or arg_122_1 == "health_conversion"
end

function GenericStatusExtension.heal_can_remove_wounded(arg_123_0, arg_123_1)
	return arg_123_1 == "healing_draught" or arg_123_1 == "bandage" or arg_123_1 == "bandage_trinket" or arg_123_1 == "buff_shared_medpack" or arg_123_1 == "debug" or arg_123_1 == "healing_draught_temp_health" or arg_123_1 == "bandage_temp_health" or arg_123_1 == "buff_shared_medpack_temp_health"
end

function GenericStatusExtension.is_revived(arg_124_0)
	return arg_124_0.revived
end

function GenericStatusExtension.is_reviving(arg_125_0)
	return arg_125_0.reviving
end

function GenericStatusExtension.is_pulled_up(arg_126_0)
	return arg_126_0.pulled_up
end

function GenericStatusExtension.is_zooming(arg_127_0)
	return arg_127_0.zooming
end

function GenericStatusExtension.num_wounds_remaining(arg_128_0)
	return arg_128_0.wounds
end

function GenericStatusExtension.has_wounds_remaining(arg_129_0)
	return arg_129_0.wounds > 1
end

function GenericStatusExtension.has_recently_left_ladder(arg_130_0, arg_130_1)
	return arg_130_1 < arg_130_0.left_ladder_timer
end

function GenericStatusExtension.get_is_on_ladder(arg_131_0)
	return arg_131_0.on_ladder, arg_131_0.current_ladder_unit
end

function GenericStatusExtension.get_is_ledge_hanging(arg_132_0)
	return arg_132_0.is_ledge_hanging, arg_132_0.current_ledge_hanging_unit
end

function GenericStatusExtension.is_catapulted(arg_133_0)
	return arg_133_0.catapulted, arg_133_0.catapulted_direction
end

function GenericStatusExtension.is_in_vortex(arg_134_0)
	return arg_134_0.in_vortex
end

function GenericStatusExtension.is_block_broken(arg_135_0)
	return arg_135_0.block_broken
end

function GenericStatusExtension.is_gutter_runner_leaping(arg_136_0)
	return arg_136_0.gutter_runner_leaping
end

function GenericStatusExtension.get_inside_transport_unit(arg_137_0)
	return arg_137_0.inside_transport_unit
end

function GenericStatusExtension.is_using_transport(arg_138_0)
	return arg_138_0.using_transport
end

function GenericStatusExtension.is_overcharge_exploding(arg_139_0)
	return arg_139_0.overcharge_exploding
end

function GenericStatusExtension.is_grabbed_by_pack_master(arg_140_0)
	return arg_140_0.pack_master_grabber ~= nil and Unit.alive(arg_140_0.pack_master_grabber)
end

function GenericStatusExtension.is_hanging_from_hook(arg_141_0)
	return arg_141_0.pack_master_status == "pack_master_hanging"
end

function GenericStatusExtension.is_dropping_from_hook(arg_142_0)
	return arg_142_0.pack_master_status == "pack_master_dropping"
end

function GenericStatusExtension.get_pack_master_grabber(arg_143_0)
	return arg_143_0.pack_master_grabber
end

function GenericStatusExtension.has_blocked(arg_144_0)
	return arg_144_0._has_blocked
end

function GenericStatusExtension.reset_move_speed_multiplier(arg_145_0)
	arg_145_0.move_speed_multiplier = 1
	arg_145_0.move_speed_multiplier_timer = 1
end

function GenericStatusExtension.current_move_speed_multiplier(arg_146_0)
	local var_146_0 = math.smoothstep(arg_146_0.move_speed_multiplier_timer, 0, 1)

	return math.lerp(arg_146_0.move_speed_multiplier, 1, var_146_0)
end

function GenericStatusExtension.set_invisible(arg_147_0, arg_147_1, arg_147_2, arg_147_3)
	assert(not not arg_147_3 ~= not not arg_147_0.is_husk, "Setting invisibility is only allowed locally.")

	if not arg_147_0.is_husk then
		local var_147_0 = arg_147_0:is_invisible()

		arg_147_0.invisible[arg_147_3] = arg_147_1 or nil

		if var_147_0 == arg_147_0:is_invisible() then
			return false
		end
	else
		arg_147_0.invisible.network_sync = arg_147_1 or nil
	end

	local var_147_1 = arg_147_0.unit
	local var_147_2
	local var_147_3 = not arg_147_2
	local var_147_4 = Managers.player:local_player()
	local var_147_5 = Managers.state.side
	local var_147_6 = var_147_5.side_by_unit[var_147_1]
	local var_147_7 = var_147_4 and Managers.party:get_party_from_player_id(var_147_4:network_id(), var_147_4:local_player_id())
	local var_147_8 = var_147_7 and var_147_5.side_by_party[var_147_7]
	local var_147_9 = var_147_5:is_enemy_by_side(var_147_8, var_147_6)
	local var_147_10 = var_147_9 and PlayerUnitStatusSettings.invisibility.enemy_fade or PlayerUnitStatusSettings.invisibility.friendly_fade

	if arg_147_1 then
		var_147_2 = "lua_enabled_invisibility"

		if var_147_3 then
			Managers.state.entity:system("fade_system"):set_min_fade(var_147_1, var_147_10)
		end

		if var_147_9 then
			arg_147_0._invisible_outline_id = ScriptUnit.extension(arg_147_0.unit, "outline_system"):add_outline(OutlineSettings.templates.invisible)
		end

		if not DEDICATED_SERVER then
			arg_147_0.update_funcs.invisible = GenericStatusExtension.update_invisibility
		end
	else
		var_147_2 = "lua_disabled_invisibility"

		if var_147_3 then
			Managers.state.entity:system("fade_system"):set_min_fade(var_147_1, 0)
		end

		if var_147_9 then
			ScriptUnit.extension(arg_147_0.unit, "outline_system"):remove_outline(arg_147_0._invisible_outline_id)

			arg_147_0._invisible_outline_id = -1
		end

		if not DEDICATED_SERVER then
			arg_147_0.update_funcs.invisible = nil
		end
	end

	if var_147_3 then
		Unit.flow_event(var_147_1, var_147_2)
	else
		local var_147_11 = arg_147_0.first_person_extension

		if var_147_11 then
			local var_147_12 = var_147_11:get_first_person_unit()
			local var_147_13 = var_147_11:get_first_person_mesh_unit()

			Unit.flow_event(var_147_12, var_147_2)
			Unit.flow_event(var_147_13, var_147_2)
		end
	end

	local var_147_14 = arg_147_0.buff_extension

	if arg_147_1 then
		var_147_14:trigger_procs("on_invisible")
	else
		var_147_14:trigger_procs("on_visible")
	end

	if not arg_147_0.is_husk then
		local var_147_15 = Managers.state.network

		if var_147_15 and var_147_15:game() then
			local var_147_16 = Managers.state.unit_storage:go_id(var_147_1)

			if arg_147_0.is_server then
				var_147_15.network_transmit:send_rpc_clients("rpc_status_change_bool", NetworkLookup.statuses.invisible, arg_147_1, var_147_16, 0)
			else
				var_147_15.network_transmit:send_rpc_server("rpc_status_change_bool", NetworkLookup.statuses.invisible, arg_147_1, var_147_16, 0)
			end
		end
	end
end

function GenericStatusExtension.update_invisibility(arg_148_0, arg_148_1, arg_148_2)
	local var_148_0 = Managers.player:local_player()
	local var_148_1 = arg_148_0.unit
	local var_148_2 = Managers.state.side
	local var_148_3 = var_148_2.side_by_unit[var_148_1]
	local var_148_4 = var_148_0 and Managers.party:get_party_from_player_id(var_148_0:network_id(), var_148_0:local_player_id())
	local var_148_5 = var_148_4 and var_148_2.side_by_party[var_148_4]

	if var_148_2:is_enemy_by_side(var_148_5, var_148_3) then
		local var_148_6 = PlayerUnitStatusSettings.invisibility.enemy_fade
		local var_148_7 = PlayerUnitStatusSettings.invisibility.disabled_enemy_fade_min
		local var_148_8 = PlayerUnitStatusSettings.invisibility.disabled_enemy_fade_max
		local var_148_9 = arg_148_0._invis_fade_value
		local var_148_10 = var_148_6

		if arg_148_0:is_disabled() then
			local var_148_11 = PlayerUnitStatusSettings.invisibility.intensity

			var_148_10 = math.clamp((arg_148_0._invis_fade_value or 1) + (math.random(0, 1) * 2 - 1) * arg_148_2 * var_148_11, var_148_7, var_148_8)
		end

		if var_148_10 ~= var_148_9 then
			arg_148_0._invis_fade_value = var_148_10

			Managers.state.entity:system("fade_system"):set_min_fade(var_148_1, var_148_10)
		end
	end
end

function GenericStatusExtension.set_move_through_ai(arg_149_0, arg_149_1)
	arg_149_0.move_through_ai = arg_149_1

	arg_149_0:set_noclip(arg_149_1, "move_through_ai")
end

function GenericStatusExtension.has_noclip(arg_150_0)
	return not table.is_empty(arg_150_0.noclip)
end

function GenericStatusExtension.set_noclip(arg_151_0, arg_151_1, arg_151_2)
	local var_151_0 = arg_151_0:has_noclip()

	arg_151_0.noclip[arg_151_2] = arg_151_1 or nil

	if var_151_0 == arg_151_0:has_noclip() then
		return
	end

	if not arg_151_0.is_husk then
		arg_151_0.locomotion_extension:set_mover_filter_property("enemy_noclip", arg_151_1)
	end
end

function GenericStatusExtension.is_invisible(arg_152_0)
	return not table.is_empty(arg_152_0.invisible)
end

function GenericStatusExtension.set_inspecting(arg_153_0, arg_153_1)
	arg_153_0.inspecting = arg_153_1
end

function GenericStatusExtension.is_inspecting(arg_154_0)
	return arg_154_0.inspecting
end

function GenericStatusExtension.set_overpowered(arg_155_0, arg_155_1, arg_155_2, arg_155_3)
	arg_155_0.overpowered = arg_155_1
	arg_155_0.overpowered_template = arg_155_2
	arg_155_0.overpowered_attacking_unit = arg_155_3

	arg_155_0:set_outline_incapacitated(not arg_155_0:is_dead() and arg_155_0:is_disabled())
end

function GenericStatusExtension.is_overpowered(arg_156_0)
	return arg_156_0.overpowered
end

function GenericStatusExtension.is_overpowered_by_attacker(arg_157_0)
	return arg_157_0.overpowered_attacking_unit ~= arg_157_0.unit
end

function GenericStatusExtension.can_dodge(arg_158_0, arg_158_1)
	local var_158_0 = arg_158_0.buff_extension:has_buff_perk("root")

	return arg_158_1 > arg_158_0.my_dodge_cd and not var_158_0
end

function GenericStatusExtension.set_dodge_cd(arg_159_0, arg_159_1, arg_159_2)
	arg_159_0.my_dodge_cd = arg_159_1 + arg_159_2
end

function GenericStatusExtension.can_override_dodge_with_jump(arg_160_0, arg_160_1)
	return arg_160_1 < arg_160_0.my_dodge_jump_override_t
end

function GenericStatusExtension.set_dodge_jump_override_t(arg_161_0, arg_161_1, arg_161_2)
	arg_161_0.my_dodge_jump_override_t = arg_161_1 + arg_161_2
end

function GenericStatusExtension.dodge_locked(arg_162_0)
	return arg_162_0.dodge_is_locked
end

function GenericStatusExtension.set_dodge_locked(arg_163_0, arg_163_1)
	arg_163_0.dodge_is_locked = arg_163_1
end

function GenericStatusExtension.set_is_dodging(arg_164_0, arg_164_1)
	arg_164_0.is_dodging = arg_164_1

	if arg_164_1 then
		arg_164_0.dodge_position:store(Unit.world_position(arg_164_0.unit, 0))
	end

	if not arg_164_0.is_husk then
		local var_164_0 = Managers.state.unit_storage:go_id(arg_164_0.unit)

		if arg_164_0.is_server then
			Managers.state.network.network_transmit:send_rpc_clients("rpc_status_change_bool", NetworkLookup.statuses.dodging, arg_164_1, var_164_0, 0)
		else
			Managers.state.network.network_transmit:send_rpc_server("rpc_status_change_bool", NetworkLookup.statuses.dodging, arg_164_1, var_164_0, 0)
		end
	end
end

function GenericStatusExtension.get_is_dodging(arg_165_0)
	return arg_165_0.is_dodging and arg_165_0.dodge_cooldown <= arg_165_0.dodge_count
end

function GenericStatusExtension.get_dodge_position(arg_166_0)
	return arg_166_0.dodge_position:unbox()
end

function GenericStatusExtension.get_is_slowed(arg_167_0)
	return arg_167_0.is_slowed
end

function GenericStatusExtension.set_falling_height(arg_168_0, arg_168_1, arg_168_2)
	fassert(not arg_168_0.is_husk, "Trying to set falling height on non-owned unit")

	if ALIVE[arg_168_0.unit] then
		arg_168_0.fall_height = arg_168_2 or arg_168_0.fall_height and not arg_168_1 and arg_168_0.fall_height > POSITION_LOOKUP[arg_168_0.unit].z and arg_168_0.fall_height or POSITION_LOOKUP[arg_168_0.unit].z
		arg_168_0.update_funcs.falling = GenericStatusExtension.update_falling
	end
end

function GenericStatusExtension.max_wounds_network_safe(arg_169_0)
	local var_169_0 = arg_169_0:get_max_wounds()

	if var_169_0 == math.huge then
		var_169_0 = -1
	end

	return var_169_0
end

function GenericStatusExtension.hot_join_sync(arg_170_0, arg_170_1)
	if Managers.state.unit_spawner:is_marked_for_deletion(arg_170_0.unit) then
		return
	end

	local var_170_0 = NetworkLookup.statuses
	local var_170_1 = Managers.state.network
	local var_170_2 = var_170_1:unit_game_object_id(arg_170_0.unit)
	local var_170_3 = PEER_ID_TO_CHANNEL[arg_170_1]
	local var_170_4 = arg_170_0.ready_for_assisted_respawn and var_170_1:unit_game_object_id(arg_170_0.assisted_respawn_flavour_unit) or 0

	RPC.rpc_hot_join_sync_health_status(var_170_3, var_170_2, arg_170_0:max_wounds_network_safe(), arg_170_0.ready_for_assisted_respawn, var_170_4)

	if arg_170_0.pack_master_status then
		local var_170_5 = Managers.time:time("game")
		local var_170_6 = Unit.alive(arg_170_0.pack_master_grabber)
		local var_170_7 = var_170_1:unit_game_object_id(arg_170_0.pack_master_grabber) or NetworkConstants.invalid_game_object_id
		local var_170_8 = var_170_0[arg_170_0.pack_master_status]

		if arg_170_0.pack_master_status == "pack_master_dropping" then
			local var_170_9 = math.clamp(var_170_5 - arg_170_0.release_falling_time, 0, 7)

			RPC.rpc_hooked_sync(var_170_3, var_170_8, var_170_2, var_170_9)
		elseif arg_170_0.pack_master_status == "pack_master_unhooked" then
			local var_170_10 = math.clamp(var_170_5 - arg_170_0.release_unhook_time, 0, 7)

			RPC.rpc_hooked_sync(var_170_3, var_170_8, var_170_2, var_170_10)
		end

		RPC.rpc_status_change_bool(var_170_3, var_170_8, var_170_6, var_170_2, var_170_7)
	end

	local var_170_11 = arg_170_0.is_ledge_hanging and var_170_1:unit_game_object_id(arg_170_0.current_ledge_hanging_unit) or 0
	local var_170_12 = arg_170_0.pounced_down and var_170_1:unit_game_object_id(arg_170_0.pouncer_unit) or 0
	local var_170_13 = arg_170_0.on_ladder and var_170_1:unit_game_object_id(arg_170_0.current_ladder_unit) or 0

	RPC.rpc_status_change_bool(var_170_3, var_170_0.pounced_down, arg_170_0.pounced_down, var_170_2, var_170_12)
	RPC.rpc_status_change_bool(var_170_3, var_170_0.pushed, arg_170_0.pushed, var_170_2, 0)
	RPC.rpc_status_change_bool(var_170_3, var_170_0.charged, arg_170_0.charged, var_170_2, 0)
	RPC.rpc_status_change_bool(var_170_3, var_170_0.dead, arg_170_0.dead, var_170_2, 0)

	local var_170_14 = var_170_1:unit_game_object_id(arg_170_0.grabbed_by_tentacle_unit) or NetworkConstants.invalid_game_object_id

	RPC.rpc_status_change_bool(var_170_3, var_170_0.grabbed_by_tentacle, arg_170_0.grabbed_by_tentacle, var_170_2, var_170_14)

	if arg_170_0.grabbed_by_tentacle_status and arg_170_0.grabbed_by_tentacle_status ~= "grabbed" then
		local var_170_15 = NetworkLookup.grabbed_by_tentacle[arg_170_0.grabbed_by_tentacle_status]

		RPC.rpc_status_change_int(var_170_3, var_170_0.grabbed_by_tentacle, var_170_15, var_170_2)
	end

	local var_170_16 = var_170_1:unit_game_object_id(arg_170_0.grabbed_by_chaos_spawn_unit) or NetworkConstants.invalid_game_object_id

	RPC.rpc_status_change_bool(var_170_3, var_170_0.grabbed_by_chaos_spawn, arg_170_0.grabbed_by_chaos_spawn, var_170_2, var_170_16)

	if arg_170_0.grabbed_by_chaos_spawn_status and arg_170_0.grabbed_by_chaos_spawn_status ~= "grabbed" then
		local var_170_17 = NetworkLookup.grabbed_by_chaos_spawn[arg_170_0.grabbed_by_chaos_spawn_status]

		RPC.rpc_status_change_int(var_170_3, var_170_0.grabbed_by_chaos_spawn, var_170_17, var_170_2)
	end

	local var_170_18 = arg_170_0.overpowered and var_170_1:unit_game_object_id(arg_170_0.overpowered_attacking_unit) or NetworkConstants.invalid_game_object_id
	local var_170_19 = arg_170_0.overpowered and NetworkLookup.overpowered_templates[arg_170_0.overpowered_template] or 0

	RPC.rpc_status_change_int_and_unit(var_170_3, var_170_0.overpowered, var_170_19, var_170_2, var_170_18)

	if arg_170_0.knocked_down then
		local var_170_20 = var_170_0.knocked_down

		RPC.rpc_status_change_bool(var_170_3, var_170_20, true, var_170_2, 0)
	end

	local var_170_21 = arg_170_0.in_vortex and var_170_1:unit_game_object_id(arg_170_0.in_vortex_unit) or NetworkConstants.invalid_game_object_id

	RPC.rpc_status_change_bool(var_170_3, var_170_0.in_vortex, arg_170_0.in_vortex, var_170_2, var_170_21)
	RPC.rpc_status_change_bool(var_170_3, var_170_0.crouching, arg_170_0.crouching, var_170_2, 0)
	RPC.rpc_status_change_bool(var_170_3, var_170_0.pulled_up, arg_170_0.pulled_up, var_170_2, 0)
	RPC.rpc_status_change_bool(var_170_3, var_170_0.ladder_climbing, arg_170_0.on_ladder, var_170_2, var_170_13)
	RPC.rpc_status_change_bool(var_170_3, var_170_0.ledge_hanging, arg_170_0.is_ledge_hanging, var_170_2, var_170_11)
	RPC.rpc_status_change_bool(var_170_3, var_170_0.in_end_zone, arg_170_0.in_end_zone, var_170_2, 0)
end

function GenericStatusExtension.set_in_end_zone(arg_171_0, arg_171_1, arg_171_2)
	if arg_171_0.is_server and arg_171_0.in_end_zone ~= arg_171_1 then
		local var_171_0 = Managers.state.unit_storage:go_id(arg_171_0.unit)
		local var_171_1, var_171_2 = Managers.state.network:game_object_or_level_id(arg_171_2)

		var_171_1 = var_171_1 or NetworkConstants.invalid_game_object_id

		Managers.state.network.network_transmit:send_rpc_clients("rpc_status_change_bool", NetworkLookup.statuses.in_end_zone, arg_171_1, var_171_0, var_171_1)
	end

	arg_171_0.in_end_zone = arg_171_1

	if arg_171_0.player.local_player and arg_171_0._current_end_zone_state ~= arg_171_1 then
		local var_171_3 = true

		if arg_171_2 then
			var_171_3 = not Unit.get_data(arg_171_2, "effects_disabled")
		end

		Wwise.set_state("inside_waystone", arg_171_1 and var_171_3 and "true" or "false")

		arg_171_0._current_end_zone_state = arg_171_1
	end
end

function GenericStatusExtension.set_is_aiming(arg_172_0, arg_172_1)
	arg_172_0.is_aiming = arg_172_1
end

function GenericStatusExtension.get_is_aiming(arg_173_0)
	return arg_173_0.is_aiming
end

function GenericStatusExtension.is_in_end_zone(arg_174_0)
	return arg_174_0.in_end_zone
end

function GenericStatusExtension.is_staggered(arg_175_0)
	return false
end

function GenericStatusExtension.breed_action(arg_176_0)
	return arg_176_0._current_action
end

function GenericStatusExtension.should_climb(arg_177_0)
	return false
end

function GenericStatusExtension.get_max_wounds(arg_178_0)
	local var_178_0 = arg_178_0._base_max_wounds

	return arg_178_0.buff_extension:apply_buffs_to_value(var_178_0, "extra_wounds")
end

function GenericStatusExtension._on_player_joined_party(arg_179_0, arg_179_1, arg_179_2, arg_179_3, arg_179_4, arg_179_5)
	if not arg_179_0.is_server then
		return
	end

	if arg_179_0:is_invisible() then
		local var_179_0 = NetworkLookup.statuses
		local var_179_1 = Managers.state.network

		if var_179_1:game() then
			local var_179_2 = var_179_1:unit_game_object_id(arg_179_0.unit)
			local var_179_3 = PEER_ID_TO_CHANNEL[arg_179_1]

			if var_179_2 then
				RPC.rpc_status_change_bool(var_179_3, var_179_0.invisible, true, var_179_2, 0)
			end
		end
	end
end
