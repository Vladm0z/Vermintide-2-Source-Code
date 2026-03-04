-- chunkname: @scripts/unit_extensions/weapons/actions/action_sweep.lua

ActionSweep = class(ActionSweep, ActionBase)

local var_0_0 = {
	"damage_profile",
	"impact_sound_event",
	"no_damage_impact_sound_event",
	"slide_armour_hit",
	"hit_mass_count",
	"hit_effect",
	"use_precision_sweep",
	"invert_attack_direction",
	"additional_critical_strike_chance",
	"hit_stop_anim"
}
local var_0_1 = #var_0_0
local var_0_2 = Unit.alive
local var_0_3 = Unit.get_data
local var_0_4 = Unit.world_position
local var_0_5 = Unit.world_rotation
local var_0_6 = Unit.local_rotation
local var_0_7 = Unit.flow_event
local var_0_8 = Unit.set_flow_variable
local var_0_9 = Unit.node
local var_0_10 = Unit.has_node
local var_0_11 = Unit.actor
local var_0_12 = Unit.animation_event
local var_0_13 = Unit.has_animation_event
local var_0_14 = Unit.has_animation_state_machine
local var_0_15 = Actor.node
local var_0_16 = math.degrees_to_radians(120)
local var_0_17 = math.degrees_to_radians(115.55)
local var_0_18 = 1
local var_0_19 = 2
local var_0_20 = 5

local function var_0_21(arg_1_0, arg_1_1)
	local var_1_0 = #arg_1_1

	for iter_1_0 = 1, var_1_0 do
		local var_1_1 = arg_1_1[iter_1_0]
		local var_1_2 = arg_1_1[math.min(iter_1_0 + 1, var_1_0)]

		if var_1_1 == var_1_2 or iter_1_0 == 1 and arg_1_0 <= var_1_1[var_0_18] then
			local var_1_3 = Vector3(var_1_1[var_0_19], var_1_1[var_0_19 + 1], var_1_1[var_0_19 + 2])
			local var_1_4 = Quaternion.from_elements(var_1_1[var_0_20], var_1_1[var_0_20 + 1], var_1_1[var_0_20 + 2], var_1_1[var_0_20 + 3])

			return Matrix4x4.from_quaternion_position(var_1_4, var_1_3)
		elseif arg_1_0 >= var_1_1[var_0_18] and arg_1_0 <= var_1_2[var_0_18] then
			local var_1_5 = math.max(var_1_2[var_0_18] - var_1_1[var_0_18], 0.0001)
			local var_1_6 = (arg_1_0 - var_1_1[var_0_18]) / var_1_5
			local var_1_7 = Vector3(var_1_1[var_0_19], var_1_1[var_0_19 + 1], var_1_1[var_0_19 + 2])
			local var_1_8 = Quaternion.from_elements(var_1_1[var_0_20], var_1_1[var_0_20 + 1], var_1_1[var_0_20 + 2], var_1_1[var_0_20 + 3])
			local var_1_9 = Vector3(var_1_2[var_0_19], var_1_2[var_0_19 + 1], var_1_2[var_0_19 + 2])
			local var_1_10 = Quaternion.from_elements(var_1_2[var_0_20], var_1_2[var_0_20 + 1], var_1_2[var_0_20 + 2], var_1_2[var_0_20 + 3])
			local var_1_11 = Vector3.lerp(var_1_7, var_1_9, var_1_6)
			local var_1_12 = Quaternion.lerp(var_1_8, var_1_10, var_1_6)

			return Matrix4x4.from_quaternion_position(var_1_12, var_1_11)
		end
	end

	return nil, nil
end

local function var_0_22(arg_2_0)
	if arg_2_0 then
		return "baked_sweep_" .. arg_2_0
	else
		return "baked_sweep"
	end
end

ActionSweep.init = function (arg_3_0, arg_3_1, arg_3_2, arg_3_3, arg_3_4, arg_3_5, arg_3_6, arg_3_7, arg_3_8)
	ActionSweep.super.init(arg_3_0, arg_3_1, arg_3_2, arg_3_3, arg_3_4, arg_3_5, arg_3_6, arg_3_7, arg_3_8)

	arg_3_0.stored_half_extents = Vector3Box()
	arg_3_0._stored_position = Vector3Box()
	arg_3_0._stored_rotation = QuaternionBox()

	local var_3_0, var_3_1 = Unit.box(arg_3_5)

	arg_3_0.stored_half_extents:store(var_3_1)

	arg_3_0._hit_units = {}
	arg_3_0._overridable_settings = {}
	arg_3_0._could_damage_last_update = false
	arg_3_0._has_played_rumble_effect = false
	arg_3_0._status_extension = ScriptUnit.extension(arg_3_4, "status_system")
	arg_3_0._weapon_extension = ScriptUnit.extension(arg_3_7, "weapon_system")
	arg_3_0._stored_attack_data = {}
	arg_3_0._dt = 0
end

ActionSweep.check_precision_target = function (arg_4_0, arg_4_1, arg_4_2, arg_4_3, arg_4_4, arg_4_5)
	local var_4_0 = arg_4_0._precision_target_unit

	if not HEALTH_ALIVE[var_4_0] then
		return nil
	end

	local var_4_1 = ScriptUnit.extension(arg_4_1, "first_person_system")

	var_4_1:disable_rig_movement()

	local var_4_2 = var_4_1:current_position()
	local var_4_3 = var_4_1:current_rotation()
	local var_4_4 = Quaternion.forward(var_4_3)
	local var_4_5 = "j_spine"
	local var_4_6 = var_0_10(var_4_0, "j_spine") and var_0_4(var_4_0, var_0_9(var_4_0, var_4_5)) or var_0_4(var_4_0, 0)
	local var_4_7 = false
	local var_4_8 = var_4_6 - var_4_2
	local var_4_9 = Vector3.length(var_4_8)
	local var_4_10 = Vector3.normalize(var_4_8)

	if Vector3.dot(var_4_10, var_4_4) < 0.9 or arg_4_3 < var_4_9 then
		var_4_7 = false
	elseif HEALTH_ALIVE[var_4_0] then
		var_4_7 = true
	end

	return var_4_7 and var_4_0 or nil
end

ActionSweep.client_owner_start_action = function (arg_5_0, arg_5_1, arg_5_2, arg_5_3, arg_5_4, arg_5_5)
	ActionSweep.super.client_owner_start_action(arg_5_0, arg_5_1, arg_5_2, arg_5_3, arg_5_4, arg_5_5)

	arg_5_0._has_played_rumble_effect = false
	arg_5_0._current_action = arg_5_1
	arg_5_0._action_time_started = arg_5_2
	arg_5_0._has_hit_environment = false
	arg_5_0._has_hit_precision_target = true
	arg_5_0._precision_target_unit = nil
	arg_5_0._number_of_hit_enemies = 0
	arg_5_0._this_attack_killed_enemy = false
	arg_5_0._amount_of_mass_hit = 0
	arg_5_0._number_of_potential_hit_results = 0
	arg_5_0._hit_mass_of_potential_hit_results = 0
	arg_5_0._network_manager = Managers.state.network
	arg_5_0._last_potential_hit_result_has_result = false
	arg_5_0._last_potential_hit_result = {}
	arg_5_0.has_been_within_damage_window = false

	local var_5_0 = arg_5_0.owner_unit
	local var_5_1 = ScriptUnit.extension(var_5_0, "buff_system")
	local var_5_2 = ScriptUnit.has_extension(var_5_0, "hud_system")

	arg_5_0._owner_buff_extension = var_5_1
	arg_5_0._owner_hud_extension = var_5_2

	local var_5_3 = ActionUtils.get_action_time_scale(var_5_0, arg_5_1)

	arg_5_0._anim_time_scale = var_5_3
	arg_5_0._time_to_hit = arg_5_2 + (arg_5_1.hit_time or 0) / var_5_3

	local var_5_4
	local var_5_5 = arg_5_1.weapon_mode_key
	local var_5_6 = arg_5_1.weapon_mode_overrides

	if var_5_5 then
		var_5_4 = var_5_6[arg_5_0._weapon_extension:get_custom_data(var_5_5)]
	end

	arg_5_0:_populate_sweep_action_data(arg_5_1, var_5_4)

	local var_5_7 = arg_5_5 and arg_5_5.action_hand
	local var_5_8 = arg_5_0:_get_damage_profile_name(var_5_7, arg_5_1)

	arg_5_0._action_hand = var_5_7
	arg_5_0._baked_sweep_data = arg_5_1[var_0_22(arg_5_0._action_hand)]
	arg_5_0._baked_data_dt_recip = arg_5_0._baked_sweep_data and 1 / #arg_5_0._baked_sweep_data or 1
	arg_5_0._damage_profile_id = NetworkLookup.damage_profiles[var_5_8]

	local var_5_9 = DamageProfileTemplates[var_5_8]

	arg_5_0._damage_profile = var_5_9
	arg_5_0._has_starting_melee_boost = nil
	arg_5_0._starting_melee_boost_curve_multiplier = nil

	local var_5_10, var_5_11 = arg_5_0:_get_power_boost()
	local var_5_12 = ActionUtils.is_critical_strike(var_5_0, arg_5_1, arg_5_2, var_5_4) or var_5_10
	local var_5_13 = Managers.state.difficulty:get_difficulty()
	local var_5_14 = ActionUtils.scale_power_levels(arg_5_4, "cleave", var_5_0, var_5_13)
	local var_5_15 = var_5_1:apply_buffs_to_value(var_5_14, "power_level_melee")
	local var_5_16 = var_5_1:apply_buffs_to_value(var_5_15, "power_level_melee_cleave")

	arg_5_0._power_level = arg_5_4

	local var_5_17, var_5_18 = ActionUtils.get_max_targets(var_5_9, var_5_16)
	local var_5_19 = var_5_1:apply_buffs_to_value(var_5_17 or 1, "increased_max_targets")
	local var_5_20 = var_5_1:apply_buffs_to_value(var_5_18 or 1, "increased_max_targets")

	if var_5_1:has_buff_perk("potion_armor_penetration") then
		var_5_20 = var_5_20 * 2
	end

	arg_5_0._max_targets_attack = var_5_19
	arg_5_0._max_targets_impact = var_5_20
	arg_5_0._max_targets = var_5_20 < var_5_19 and var_5_19 or var_5_20
	arg_5_0._down_offset = arg_5_1.sweep_z_offset or 0.1
	arg_5_0._auto_aim_reset = false

	if not Managers.player:owner(arg_5_0.owner_unit).bot_player and var_5_9.charge_value == "heavy_attack" then
		Managers.state.controller_features:add_effect("rumble", {
			rumble_effect = "light_swing"
		})
	end

	local var_5_21 = arg_5_0.first_person_unit

	if global_is_inside_inn then
		arg_5_0._down_offset = 0
	end

	arg_5_0._attack_aborted = false
	arg_5_0._send_delayed_hit_rpc = false

	table.clear(arg_5_0._hit_units)
	var_5_1:trigger_procs("on_sweep")

	arg_5_0._unlimited_cleave = not not arg_5_1.unlimited_cleave

	if not arg_5_0._unlimited_cleave and var_5_12 then
		arg_5_0._unlimited_cleave = var_5_1:has_buff_perk("crit_unlimited_cleave")
	end

	local var_5_22 = ScriptUnit.extension(var_5_0, "first_person_system")

	arg_5_0:_handle_critical_strike(var_5_12, var_5_1, var_5_2, var_5_22, "on_critical_sweep", "Play_player_combat_crit_swing_2D")

	arg_5_0._is_critical_strike = var_5_12
	arg_5_0._started_damage_window = false

	var_0_7(var_5_21, "sfx_swing_started")

	if arg_5_0._overridable_settings.use_precision_sweep then
		var_5_22:disable_rig_movement()

		local var_5_23 = World.get_data(arg_5_0.world, "physics_world")
		local var_5_24 = var_5_22:current_position()
		local var_5_25 = var_5_22:current_rotation()
		local var_5_26 = Quaternion.forward(var_5_25)
		local var_5_27 = "filter_melee_sweep"
		local var_5_28 = PhysicsWorld.immediate_raycast(var_5_23, var_5_24, var_5_26, arg_5_1.dedicated_target_range, "all", "collision_filter", var_5_27)

		if var_5_28 then
			local var_5_29 = Managers.state.side.side_by_unit[var_5_0].enemy_units_lookup
			local var_5_30 = #var_5_28

			for iter_5_0 = 1, var_5_30 do
				local var_5_31 = var_5_28[iter_5_0][4]
				local var_5_32 = Actor.unit(var_5_31)
				local var_5_33 = var_0_3(var_5_32, "breed")
				local var_5_34 = not var_5_29[var_5_32]

				if var_5_33 and not var_5_34 then
					local var_5_35 = var_0_15(var_5_31)

					if var_5_33.hit_zones_lookup[var_5_35].name ~= "afro" and HEALTH_ALIVE[var_5_32] then
						arg_5_0._precision_target_unit = var_5_32
						arg_5_0._has_hit_precision_target = false

						break
					end
				end
			end
		end

		if not arg_5_0._precision_target_unit and ScriptUnit.has_extension(var_5_0, "smart_targeting_system") then
			local var_5_36 = ScriptUnit.extension(var_5_0, "smart_targeting_system"):get_targeting_data().unit

			if HEALTH_ALIVE[var_5_36] then
				arg_5_0._precision_target_unit = var_5_36
				arg_5_0._has_hit_precision_target = false
			end
		end
	end

	local var_5_37 = arg_5_0.weapon_unit
	local var_5_38 = arg_5_0:_weapon_sweep_rotation(arg_5_1, var_5_37)
	local var_5_39 = Quaternion.up(var_5_38) * (arg_5_1.weapon_up_offset_mod or 0)
	local var_5_40 = POSITION_LOOKUP[var_5_37]
	local var_5_41 = Vector3(var_5_40.x, var_5_40.y, var_5_40.z - arg_5_0._down_offset) + var_5_39

	arg_5_0._stored_position:store(var_5_41)
	arg_5_0._stored_rotation:store(var_5_38)

	arg_5_0._could_damage_last_update = false

	if arg_5_1.lookup_data.sub_action_name == "assassinate" then
		local var_5_42 = var_5_1:get_non_stacking_buff("assassinate")

		var_5_1:remove_buff(var_5_42.id)
	end
end

local var_0_23 = {}

if PhysicsWorld.stop_reusing_sweep_tables then
	PhysicsWorld.stop_reusing_sweep_tables()
end

ActionSweep.client_owner_post_update = function (arg_6_0, arg_6_1, arg_6_2, arg_6_3, arg_6_4, arg_6_5)
	local var_6_0 = arg_6_0.owner_unit
	local var_6_1 = arg_6_0._current_action

	arg_6_0.current_time_in_action = arg_6_5
	arg_6_0._dt = arg_6_1

	local var_6_2 = false

	if (var_6_2 or arg_6_0._attack_aborted) and var_6_1.reset_aim_on_attack and not arg_6_0._auto_aim_reset then
		ScriptUnit.extension(var_6_0, "first_person_system"):reset_aim_assist_multiplier()

		arg_6_0._auto_aim_reset = true
	end

	local var_6_3 = arg_6_5 - 2 * arg_6_1
	local var_6_4 = arg_6_0:_update_sweep(arg_6_1, arg_6_2, var_6_1, var_6_3)

	arg_6_0._started_damage_window = arg_6_0._started_damage_window or var_6_4

	if arg_6_0._is_critical_strike then
		local var_6_5 = arg_6_0._owner_hud_extension

		if var_6_5 and var_6_5.show_critical_indication and not var_6_4 and arg_6_0._started_damage_window then
			var_6_5.show_critical_indication = false
		end
	end
end

ActionSweep._update_sweep = function (arg_7_0, arg_7_1, arg_7_2, arg_7_3, arg_7_4)
	local var_7_0

	if arg_7_0._baked_sweep_data then
		var_7_0 = arg_7_0:_update_sweep_baked(arg_7_1, arg_7_2, arg_7_3, arg_7_4)
	else
		var_7_0 = arg_7_0:_update_sweep_runtime(arg_7_1, arg_7_2, arg_7_3, arg_7_4)
	end

	if arg_7_0._send_delayed_hit_rpc and arg_7_2 >= arg_7_0._time_to_hit then
		local var_7_1 = arg_7_0._stored_attack_data

		arg_7_0:_send_attack_hit(arg_7_2, var_7_1.damage_source_id, var_7_1.attacker_unit_id, var_7_1.hit_unit_id, var_7_1.hit_zone_id, var_7_1.hit_position:unbox(), var_7_1.attack_direction:unbox(), var_7_1.damage_profile_id, unpack(var_7_1.optional_parameters))

		arg_7_0._send_delayed_hit_rpc = false
	end

	return var_7_0
end

ActionSweep._update_sweep_baked = function (arg_8_0, arg_8_1, arg_8_2, arg_8_3, arg_8_4)
	local var_8_0
	local var_8_1 = arg_8_3.damage_window_start / arg_8_0._anim_time_scale

	if arg_8_4 + arg_8_1 >= var_8_1 - 0.03333333333333333 then
		local var_8_2 = arg_8_0.owner_unit
		local var_8_3 = arg_8_0.weapon_unit
		local var_8_4 = arg_8_0.physics_world
		local var_8_5 = arg_8_0._baked_sweep_data
		local var_8_6 = false
		local var_8_7 = 0
		local var_8_8 = 0.016666666666666666
		local var_8_9 = ScriptUnit.extension(var_8_2, "first_person_system"):get_first_person_unit()
		local var_8_10 = Unit.world_pose(var_8_9, 0)

		while not var_8_6 and not arg_8_0._attack_aborted and var_8_7 < arg_8_1 do
			local var_8_11 = math.min(var_8_8, arg_8_1 - var_8_7)

			var_8_7 = math.min(var_8_7 + var_8_8, arg_8_1)

			local var_8_12 = (arg_8_4 + var_8_7) * arg_8_0._anim_time_scale
			local var_8_13 = var_0_21(var_8_12, var_8_5)
			local var_8_14 = Matrix4x4.multiply(var_8_13, var_8_10)
			local var_8_15 = Matrix4x4.translation(var_8_14)
			local var_8_16 = Matrix4x4.rotation(var_8_14)

			var_8_0 = arg_8_0:_is_within_damage_window(arg_8_4 + var_8_7, arg_8_3, var_8_2)
			var_8_6 = arg_8_0:_do_overlap(var_8_11, arg_8_2, var_8_3, var_8_2, arg_8_3, var_8_4, var_8_0, var_8_15, var_8_16)
		end
	end

	return var_8_0
end

ActionSweep._update_sweep_runtime = function (arg_9_0, arg_9_1, arg_9_2, arg_9_3, arg_9_4)
	local var_9_0 = arg_9_0.owner_unit
	local var_9_1 = arg_9_0.weapon_unit
	local var_9_2 = arg_9_0.physics_world
	local var_9_3 = arg_9_3.forced_interpolation or 0.016666666666666666
	local var_9_4 = 0
	local var_9_5 = arg_9_0._stored_position:unbox()
	local var_9_6 = arg_9_0._stored_rotation:unbox()
	local var_9_7 = POSITION_LOOKUP[var_9_1]
	local var_9_8 = arg_9_0:_weapon_sweep_rotation(arg_9_3, var_9_1)
	local var_9_9 = false
	local var_9_10

	while not var_9_9 and not arg_9_0._attack_aborted and var_9_4 < arg_9_1 do
		local var_9_11 = math.min(var_9_3, arg_9_1 - var_9_4)

		var_9_4 = math.min(var_9_4 + var_9_3, arg_9_1)

		local var_9_12 = var_9_4 / arg_9_1
		local var_9_13 = Vector3.lerp(var_9_5, var_9_7, var_9_12)
		local var_9_14 = Quaternion.lerp(var_9_6, var_9_8, var_9_12)

		var_9_10 = arg_9_0:_is_within_damage_window(arg_9_4 + var_9_4, arg_9_3, var_9_0)
		var_9_9 = arg_9_0:_do_overlap(var_9_11, arg_9_2, var_9_1, var_9_0, arg_9_3, var_9_2, var_9_10, var_9_13, var_9_14)
	end

	return var_9_10
end

ActionSweep._get_power_boost = function (arg_10_0)
	local var_10_0 = arg_10_0._has_starting_melee_boost
	local var_10_1 = arg_10_0._starting_melee_boost_curve_multiplier

	if not var_10_0 then
		local var_10_2 = arg_10_0.owner_unit
		local var_10_3 = arg_10_0._damage_profile
		local var_10_4 = var_10_3 and var_10_3.melee_boost_override

		var_10_0, var_10_1 = ActionUtils.get_melee_boost(var_10_2, var_10_4)
		arg_10_0._has_starting_melee_boost, arg_10_0._starting_melee_boost_curve_multiplier = var_10_0, var_10_1
	end

	return var_10_0, var_10_1
end

ActionSweep._is_within_damage_window = function (arg_11_0, arg_11_1, arg_11_2, arg_11_3)
	local var_11_0 = arg_11_2.damage_window_start
	local var_11_1 = arg_11_2.damage_window_end

	if not var_11_0 and not var_11_1 then
		return false
	end

	local var_11_2 = arg_11_0._anim_time_scale
	local var_11_3 = var_11_0 / var_11_2

	var_11_1 = var_11_1 or arg_11_2.total_time or math.huge

	local var_11_4 = var_11_1 / var_11_2
	local var_11_5 = var_11_3 < arg_11_1
	local var_11_6 = arg_11_1 < var_11_4

	return var_11_5 and var_11_6
end

ActionSweep._get_target_hit_mass = function (arg_12_0, arg_12_1, arg_12_2, arg_12_3, arg_12_4, arg_12_5, arg_12_6)
	local var_12_0 = arg_12_2 and (arg_12_4.hit_mass_counts_block and (arg_12_4.hit_mass_counts_block[arg_12_1] or arg_12_4.hit_mass_counts_block[2]) or arg_12_4.hit_mass_count_block) or arg_12_4.hit_mass_counts and (arg_12_4.hit_mass_counts[arg_12_1] or arg_12_4.hit_mass_counts[2]) or arg_12_4.hit_mass_count or 1
	local var_12_1 = arg_12_0._overridable_settings.hit_mass_count

	if arg_12_0._unlimited_cleave then
		var_12_0 = 0

		return var_12_0
	elseif var_12_1 and var_12_1[arg_12_4.name] then
		var_12_0 = var_12_0 * (var_12_1[arg_12_4.name] or 1)
	end

	local var_12_2 = arg_12_0._network_manager:game()

	if not arg_12_4.is_player then
		local var_12_3 = GameSession.game_object_field(var_12_2, arg_12_5, "bt_action_name")

		if NetworkLookup.bt_action_names[var_12_3] == "stagger" then
			var_12_0 = var_12_0 * 0.75
		end
	end

	local var_12_4 = ScriptUnit.has_extension(arg_12_6, "buff_system")

	if var_12_4 then
		var_12_0 = var_12_4:apply_buffs_to_value(var_12_0, "hit_mass_amount")
	end

	return (arg_12_0._owner_buff_extension:apply_buffs_to_value(var_12_0, "hit_mass_reduction"))
end

ActionSweep._calculate_hit_mass = function (arg_13_0, arg_13_1, arg_13_2, arg_13_3, arg_13_4, arg_13_5, arg_13_6, arg_13_7)
	local var_13_0 = false
	local var_13_1 = false

	if HEALTH_ALIVE[arg_13_7] then
		var_13_0 = arg_13_0._amount_of_mass_hit <= arg_13_0._max_targets_attack
		var_13_1 = arg_13_0._amount_of_mass_hit <= arg_13_0._max_targets_impact

		local var_13_2 = arg_13_0:_get_target_hit_mass(arg_13_1, arg_13_3, arg_13_4, arg_13_5, arg_13_6, arg_13_7)

		arg_13_0._amount_of_mass_hit = arg_13_0._amount_of_mass_hit + var_13_2
		arg_13_0._number_of_hit_enemies = arg_13_0._number_of_hit_enemies + 1
		arg_13_2 = arg_13_0._number_of_hit_enemies
	else
		arg_13_3 = false
	end

	return math.ceil(arg_13_2), arg_13_3, var_13_0, var_13_1
end

ActionSweep._calculate_hit_mass_level_object = function (arg_14_0, arg_14_1, arg_14_2, arg_14_3)
	if HEALTH_ALIVE[arg_14_1] then
		local var_14_0 = var_0_3(arg_14_1, "hit_mass")

		if arg_14_0._unlimited_cleave then
			var_14_0 = 0
		end

		arg_14_0._amount_of_mass_hit = arg_14_0._amount_of_mass_hit + var_14_0
		arg_14_0._number_of_hit_enemies = arg_14_0._number_of_hit_enemies + 1
	end
end

ActionSweep._calculate_attack_direction = function (arg_15_0, arg_15_1, arg_15_2)
	local var_15_0 = arg_15_1.attack_direction or "forward"
	local var_15_1 = Quaternion[var_15_0](arg_15_2)

	return arg_15_0._overridable_settings.invert_attack_direction and -var_15_1 or var_15_1
end

ActionSweep._check_backstab = function (arg_16_0, arg_16_1, arg_16_2, arg_16_3, arg_16_4, arg_16_5)
	local var_16_0 = 1

	if arg_16_1 and HEALTH_ALIVE[arg_16_2] then
		local var_16_1 = POSITION_LOOKUP[arg_16_3]
		local var_16_2 = var_0_4(arg_16_2, 0)
		local var_16_3 = Vector3.normalize(var_16_2 - var_16_1)
		local var_16_4 = Quaternion.forward(var_0_6(arg_16_2, 0))
		local var_16_5 = Vector3.dot(var_16_4, var_16_3)

		if var_16_5 >= 0.55 and var_16_5 <= 1 or arg_16_4 and arg_16_4:has_buff_perk("guaranteed_backstab") then
			var_16_0 = arg_16_4:apply_buffs_to_value(var_16_0, "backstab_multiplier")

			if script_data.debug_legendary_traits then
				var_16_0 = 1.5
			end

			if var_16_0 > 1 then
				arg_16_5:play_hud_sound_event("hud_player_buff_backstab")

				local var_16_6 = Managers.state.side.side_by_unit[arg_16_3].PLAYER_AND_BOT_UNITS

				for iter_16_0 = 1, #var_16_6 do
					local var_16_7 = var_16_6[iter_16_0]
					local var_16_8 = ScriptUnit.has_extension(var_16_7, "buff_system")

					if var_16_8 then
						var_16_8:trigger_procs("on_backstab", arg_16_2)
					end
				end
			end
		end
	end

	return var_16_0
end

ActionSweep._send_attack_hit = function (arg_17_0, arg_17_1, arg_17_2, arg_17_3, arg_17_4, arg_17_5, arg_17_6, arg_17_7, arg_17_8, ...)
	if arg_17_1 < arg_17_0._time_to_hit then
		local var_17_0 = Vector3Box(arg_17_6)
		local var_17_1 = Vector3Box(arg_17_7)

		table.clear(arg_17_0._stored_attack_data)

		arg_17_0._stored_attack_data.damage_source_id = arg_17_2
		arg_17_0._stored_attack_data.attacker_unit_id = arg_17_3
		arg_17_0._stored_attack_data.hit_unit_id = arg_17_4
		arg_17_0._stored_attack_data.hit_zone_id = arg_17_5
		arg_17_0._stored_attack_data.hit_position = var_17_0
		arg_17_0._stored_attack_data.attack_direction = var_17_1
		arg_17_0._stored_attack_data.damage_profile_id = arg_17_8
		arg_17_0._stored_attack_data.optional_parameters = {
			...
		}
		arg_17_0._send_delayed_hit_rpc = true
	else
		arg_17_0.weapon_system:send_rpc_attack_hit(arg_17_2, arg_17_3, arg_17_4, arg_17_5, arg_17_6, arg_17_7, arg_17_8, ...)

		local var_17_2 = arg_17_0._current_action.impact_explosion_template

		if var_17_2 then
			local var_17_3 = arg_17_0._network_manager:game_object_or_level_unit(arg_17_4)
			local var_17_4 = Unit.has_node(var_17_3, "c_spine") and Unit.node(var_17_3, "c_spine")
			local var_17_5 = var_17_4 and Unit.world_position(var_17_3, var_17_4) or arg_17_6
			local var_17_6 = arg_17_0.world
			local var_17_7 = arg_17_0.owner_unit
			local var_17_8 = arg_17_0._stored_rotation:unbox()
			local var_17_9 = 1
			local var_17_10 = arg_17_0.item_name
			local var_17_11 = arg_17_0._power_level
			local var_17_12 = arg_17_0.is_server
			local var_17_13 = false
			local var_17_14 = false
			local var_17_15 = arg_17_0.weapon_unit
			local var_17_16 = Managers.state.network
			local var_17_17 = var_17_16.network_transmit
			local var_17_18 = ExplosionUtils.get_template(var_17_2)
			local var_17_19 = var_17_16:unit_game_object_id(var_17_7)
			local var_17_20 = NetworkLookup.explosion_templates[var_17_2]

			if var_17_12 then
				var_17_17:send_rpc_clients("rpc_create_explosion", var_17_19, false, var_17_5, var_17_8, var_17_20, var_17_9, arg_17_2, var_17_11, var_17_14, var_17_19)
			else
				var_17_17:send_rpc_server("rpc_create_explosion", var_17_19, false, var_17_5, var_17_8, var_17_20, var_17_9, arg_17_2, var_17_11, var_17_14, var_17_19)
			end

			DamageUtils.create_explosion(var_17_6, var_17_7, var_17_5, var_17_8, var_17_18, var_17_9, var_17_10, var_17_12, var_17_13, var_17_15, var_17_11, var_17_14)
		end
	end
end

function _revalidate_actor_and_get_unit(arg_18_0)
	return Script.type_name(arg_18_0) == "Actor" and Actor.unit(arg_18_0) or nil
end

ActionSweep._do_overlap = function (arg_19_0, arg_19_1, arg_19_2, arg_19_3, arg_19_4, arg_19_5, arg_19_6, arg_19_7, arg_19_8, arg_19_9)
	if arg_19_0._attack_aborted then
		return
	end

	local var_19_0 = Quaternion.up(arg_19_9)
	local var_19_1 = false
	local var_19_2 = arg_19_0._network_manager
	local var_19_3 = arg_19_0.weapon_system
	local var_19_4 = Quaternion.up(arg_19_9) * (arg_19_5.weapon_up_offset_mod or 0)

	if not arg_19_7 and not arg_19_0._could_damage_last_update then
		local var_19_5 = arg_19_8
		local var_19_6 = Vector3(var_19_5.x, var_19_5.y, var_19_5.z - arg_19_0._down_offset) + var_19_4

		arg_19_0._stored_position:store(var_19_6)
		arg_19_0._stored_rotation:store(arg_19_9)

		return
	end

	local var_19_7 = not arg_19_7 and arg_19_0._could_damage_last_update

	arg_19_0._could_damage_last_update = arg_19_7
	arg_19_0.has_been_within_damage_window = arg_19_0.has_been_within_damage_window or arg_19_7

	local var_19_8 = arg_19_0._stored_position:unbox()
	local var_19_9 = arg_19_0._stored_rotation:unbox()
	local var_19_10 = Quaternion.up(var_19_9)
	local var_19_11 = arg_19_8
	local var_19_12 = Vector3(var_19_11.x, var_19_11.y, var_19_11.z - arg_19_0._down_offset) + var_19_4
	local var_19_13 = arg_19_9

	arg_19_0._stored_position:store(var_19_12)
	arg_19_0._stored_rotation:store(var_19_13)

	local var_19_14 = arg_19_0.stored_half_extents:unbox()
	local var_19_15 = var_19_14.z
	local var_19_16 = arg_19_5.range_mod and arg_19_5.range_mod * SweepRangeMod or SweepRangeMod
	local var_19_17 = arg_19_5.width_mod and arg_19_5.width_mod * SweepWidthMod or 20 * SweepWidthMod
	local var_19_18 = arg_19_5.height_mod and arg_19_5.height_mod * SweepHeigthMod or 4 * SweepHeigthMod
	local var_19_19 = arg_19_5.range_mod_add or 0

	if global_is_inside_inn then
		var_19_16 = 0.65 * var_19_16
		var_19_17 = var_19_17 / 4
	end

	local var_19_20 = var_19_15 * var_19_16 + var_19_19 / 2

	var_19_14.x = var_19_14.x * var_19_17
	var_19_14.y = var_19_14.y * var_19_18
	var_19_14.z = var_19_20

	local var_19_21 = arg_19_9
	local var_19_22 = var_19_8 + var_19_10 * var_19_20
	local var_19_23 = var_19_8 + var_19_0 * var_19_20 * 2 - Quaternion.up(var_19_9) * var_19_20
	local var_19_24 = 5
	local var_19_25 = 20
	local var_19_26 = 5
	local var_19_27 = arg_19_0:_calculate_attack_direction(arg_19_5, var_19_21)
	local var_19_28 = Managers.player:owner(arg_19_4)
	local var_19_29 = Vector3(var_19_14.x, var_19_14.y, 0.0001)
	local var_19_30 = Managers.state.difficulty:get_difficulty_rank()
	local var_19_31 = "filter_melee_sweep"

	if PhysicsWorld.start_reusing_sweep_tables then
		PhysicsWorld.start_reusing_sweep_tables()
	end

	local var_19_32 = PhysicsWorld.linear_obb_sweep(arg_19_6, var_19_8, var_19_8 + var_19_10 * var_19_20 * 2, var_19_29, var_19_9, var_19_24, "collision_filter", var_19_31, "report_initial_overlap")
	local var_19_33 = PhysicsWorld.linear_obb_sweep(arg_19_6, var_19_22, var_19_23, var_19_14, var_19_9, var_19_25, "collision_filter", var_19_31, "report_initial_overlap")
	local var_19_34 = PhysicsWorld.linear_obb_sweep(arg_19_6, var_19_8 + var_19_0 * var_19_20, var_19_12 + var_19_0 * var_19_20, var_19_14, var_19_13, var_19_26, "collision_filter", var_19_31, "report_initial_overlap")
	local var_19_35 = 0
	local var_19_36 = 0
	local var_19_37 = 0

	if var_19_32 then
		var_19_35 = #var_19_32

		for iter_19_0 = 1, var_19_35 do
			var_0_23[iter_19_0] = var_19_32[iter_19_0]
		end
	end

	if var_19_33 then
		for iter_19_1 = 1, #var_19_33 do
			local var_19_38 = var_19_33[iter_19_1]
			local var_19_39 = var_19_38.actor
			local var_19_40

			for iter_19_2 = 1, var_19_35 do
				if var_0_23[iter_19_2].actor == var_19_39 then
					var_19_40 = true

					break
				end
			end

			if not var_19_40 then
				var_19_36 = var_19_36 + 1
				var_0_23[var_19_35 + var_19_36] = var_19_38
			end
		end
	end

	if var_19_34 then
		for iter_19_3 = 1, #var_19_34 do
			local var_19_41 = var_19_34[iter_19_3]
			local var_19_42 = var_19_41.actor
			local var_19_43

			for iter_19_4 = 1, var_19_35 + var_19_36 do
				if var_0_23[iter_19_4].actor == var_19_42 then
					var_19_43 = true

					break
				end
			end

			if not var_19_43 then
				var_19_37 = var_19_37 + 1
				var_0_23[var_19_35 + var_19_36 + var_19_37] = var_19_41
			end
		end
	end

	for iter_19_5 = var_19_35 + var_19_36 + var_19_37 + 1, #var_0_23 do
		var_0_23[iter_19_5] = nil
	end

	local var_19_44 = ScriptUnit.extension(arg_19_4, "first_person_system")
	local var_19_45 = ScriptUnit.has_extension(arg_19_4, "sound_effect_system")
	local var_19_46 = arg_19_0._damage_profile
	local var_19_47 = arg_19_0._hit_units
	local var_19_48 = false
	local var_19_49 = var_19_12 + var_19_0 * (var_19_20 * 2)
	local var_19_50

	if arg_19_0._overridable_settings.use_precision_sweep and arg_19_0._precision_target_unit then
		local var_19_51 = arg_19_0:check_precision_target(arg_19_4, var_19_28, arg_19_5.dedicated_target_range, true, var_19_49)

		if arg_19_0._precision_target_unit ~= var_19_51 then
			var_19_50 = true
			arg_19_0._precision_target_unit = nil
		end
	end

	local var_19_52 = var_19_35 + var_19_36 + var_19_37

	if var_19_7 and arg_19_0._last_potential_hit_result_has_result then
		local var_19_53 = 0
		local var_19_54 = 1

		for iter_19_6 = 1, #arg_19_0._last_potential_hit_result do
			if not arg_19_0._last_potential_hit_result[iter_19_6].already_hit then
				local var_19_55 = {}

				if arg_19_0._last_potential_hit_result[iter_19_6].actor:unbox() then
					var_19_55.actor = arg_19_0._last_potential_hit_result[iter_19_6].actor:unbox()
					var_19_55.position = arg_19_0._last_potential_hit_result[iter_19_6].hit_position:unbox()
					var_19_55.normal = arg_19_0._last_potential_hit_result[iter_19_6].hit_normal:unbox()

					table.insert(var_0_23, var_19_54, var_19_55)

					var_19_47[arg_19_0._last_potential_hit_result[iter_19_6].hit_unit] = nil
					var_19_54 = var_19_54 + 1
					var_19_53 = var_19_53 + 1
				end
			end
		end

		var_19_52 = var_19_52 + var_19_53
	end

	local var_19_56 = Managers.state.side.side_by_unit[arg_19_4].enemy_units_lookup
	local var_19_57 = arg_19_0._this_attack_killed_enemy
	local var_19_58, var_19_59 = var_19_44:camera_position_rotation()

	for iter_19_7 = 1, var_19_52 do
		local var_19_60 = arg_19_0._last_potential_hit_result_has_result
		local var_19_61 = arg_19_0._has_hit_precision_target
		local var_19_62 = var_19_60 and (var_19_61 or var_19_50)
		local var_19_63 = var_0_23[iter_19_7]
		local var_19_64 = var_19_63.actor
		local var_19_65 = _revalidate_actor_and_get_unit(var_19_64)
		local var_19_66 = var_19_63.position
		local var_19_67 = var_19_63.normal
		local var_19_68 = false

		if var_19_62 then
			local var_19_69 = #arg_19_0._last_potential_hit_result

			if var_19_50 then
				var_19_68 = true
				var_19_50 = false
			elseif arg_19_0._last_potential_hit_result[var_19_69].hit_mass_budget then
				var_19_68 = true
			end

			if var_19_68 then
				local var_19_70 = arg_19_0._last_potential_hit_result[var_19_69].actor:unbox()

				if var_19_70 then
					local var_19_71 = var_19_70
					local var_19_72 = _revalidate_actor_and_get_unit(var_19_71)

					if var_0_2(var_19_72) then
						var_19_64 = var_19_71
						var_19_65 = var_19_72
						var_19_66 = arg_19_0._last_potential_hit_result[var_19_69].hit_position:unbox()
						var_19_67 = arg_19_0._last_potential_hit_result[var_19_69].hit_normal:unbox()
						var_19_63.actor = var_19_64
						var_19_63.position = var_19_66
						var_19_63.normal = var_19_67
						var_19_47[arg_19_0._last_potential_hit_result[var_19_69].hit_unit] = nil
						arg_19_0._last_potential_hit_result[var_19_69].already_hit = true
					end
				end
			end

			arg_19_0._last_potential_hit_result_has_result = false
		end

		local var_19_73 = false

		if var_0_2(var_19_65) and Vector3.is_valid(var_19_66) then
			fassert(Vector3.is_valid(var_19_66), "The hit position is not valid! Actor: %s, Unit: %s", var_19_64, var_19_65)
			assert(var_19_65, "hit_unit is nil.")

			local var_19_74, var_19_75 = ActionUtils.redirect_shield_hit(var_19_65, var_19_64)
			local var_19_76 = AiUtils.unit_breed(var_19_74)
			local var_19_77 = false
			local var_19_78 = var_19_44:is_within_custom_view(var_19_66, var_19_58, var_19_59, var_0_16, var_0_17)
			local var_19_79 = var_19_76 ~= nil
			local var_19_80 = var_19_76 and var_19_76.is_hero
			local var_19_81

			var_19_81 = var_19_76 and var_19_76.is_ai

			local var_19_82 = var_19_74 == arg_19_4
			local var_19_83 = not var_19_56[var_19_74]
			local var_19_84 = false
			local var_19_85 = false

			if var_19_76 and var_19_76.can_dodge then
				var_19_77 = AiUtils.attack_is_dodged(var_19_74)
			end

			if var_19_79 and not var_19_83 and not var_19_82 and var_19_78 and (var_19_62 or arg_19_0._hit_units[var_19_74] == nil) then
				var_19_47[var_19_74] = true

				local var_19_86 = arg_19_0._status_extension

				var_19_84 = var_19_77 or not arg_19_0._unlimited_cleave and AiUtils.attack_is_shield_blocked(var_19_74, arg_19_4) and not arg_19_5.ignore_armour_hit and not var_19_86:is_invisible()

				if var_19_80 then
					var_19_85 = ScriptUnit.extension(var_19_74, "status_system"):is_blocking()
				end

				local var_19_87 = false
				local var_19_88 = false
				local var_19_89 = var_19_2:unit_game_object_id(var_19_74)
				local var_19_90 = 1
				local var_19_91

				if arg_19_0._overridable_settings.use_precision_sweep and arg_19_0._precision_target_unit ~= nil and not arg_19_0._has_hit_precision_target and not var_19_7 then
					if var_19_74 == arg_19_0._precision_target_unit then
						arg_19_0._has_hit_precision_target = true
						var_19_90, var_19_84, var_19_87, var_19_88 = arg_19_0:_calculate_hit_mass(var_19_30, var_19_90, var_19_84, arg_19_5, var_19_76, var_19_89, var_19_74)
						var_19_91 = var_19_46.default_target
					elseif HEALTH_ALIVE[var_19_74] then
						local var_19_92 = arg_19_0:_get_target_hit_mass(var_19_30, var_19_84, arg_19_5, var_19_76, var_19_89, var_19_74)
						local var_19_93 = arg_19_0._number_of_potential_hit_results + 1
						local var_19_94 = {}

						arg_19_0._last_potential_hit_result_has_result = true
						var_19_94.hit_unit = var_19_74
						var_19_94.actor = ActorBox(var_19_75)
						var_19_94.hit_position = Vector3Box(var_19_66)
						var_19_94.hit_normal = Vector3Box(var_19_67)
						var_19_94.hit_mass_budget = arg_19_0._max_targets - (arg_19_0._amount_of_mass_hit + var_19_92) >= 0
						arg_19_0._last_potential_hit_result[var_19_93] = var_19_94
						arg_19_0._number_of_potential_hit_results = var_19_93
					end
				elseif arg_19_0._amount_of_mass_hit < arg_19_0._max_targets or var_19_62 then
					if not var_19_83 then
						var_19_90, var_19_84, var_19_87, var_19_88 = arg_19_0:_calculate_hit_mass(var_19_30, var_19_90, var_19_84, arg_19_5, var_19_76, var_19_89, var_19_74)
					end

					local var_19_95 = var_19_46.targets

					var_19_91 = var_19_95 and var_19_95[var_19_90] or var_19_46.default_target
				end

				if var_19_91 then
					local var_19_96 = arg_19_0._owner_buff_extension
					local var_19_97 = arg_19_0._damage_profile_id
					local var_19_98

					if var_19_76 then
						local var_19_99 = var_0_15(var_19_75)

						var_19_98 = var_19_76.hit_zones_lookup[var_19_99].name

						if var_19_98 == "afro" then
							var_19_98 = "torso"
						end

						var_19_73 = HEALTH_ALIVE[var_19_74] and (var_19_76.armor_category == 2 or var_19_76.stagger_armor_category == 2) or var_19_76.armor_category == 3
					else
						var_19_98 = "torso"
					end

					local var_19_100 = not arg_19_0._unlimited_cleave and (arg_19_0._number_of_hit_enemies >= arg_19_0._max_targets or arg_19_0._amount_of_mass_hit >= arg_19_0._max_targets or var_19_73 and not arg_19_0._overridable_settings.slide_armour_hit and not arg_19_5.ignore_armour_hit)

					if var_19_84 then
						var_19_100 = not arg_19_0._unlimited_cleave and (arg_19_0._amount_of_mass_hit + 3 >= arg_19_0._max_targets or var_19_73 and not arg_19_0._overridable_settings.slide_armour_hit and not arg_19_5.ignore_armour_hit)
					end

					if var_19_45 and HEALTH_ALIVE[var_19_74] then
						var_19_45:add_hit()
					end

					local var_19_101 = arg_19_0.item_name
					local var_19_102 = NetworkLookup.damage_sources[var_19_101]
					local var_19_103 = var_19_2:unit_game_object_id(arg_19_4)
					local var_19_104 = NetworkLookup.hit_zones[var_19_98]
					local var_19_105 = arg_19_0.is_server
					local var_19_106 = arg_19_0:_check_backstab(var_19_76, var_19_74, arg_19_4, var_19_96, var_19_44)
					local var_19_107 = var_19_84 or var_19_85

					if var_19_76 and not var_19_77 then
						local var_19_108, var_19_109 = arg_19_0:_get_power_boost()
						local var_19_110 = arg_19_0._power_level
						local var_19_111 = arg_19_0._is_critical_strike or var_19_108
						local var_19_112 = arg_19_0:_play_character_impact(var_19_105, arg_19_4, var_19_74, var_19_76, var_19_66, var_19_98, arg_19_5, var_19_46, var_19_90, var_19_110, var_19_27, var_19_107, var_19_109, var_19_111, var_19_106)

						var_19_57 = var_19_57 or var_19_112
					end

					local var_19_113 = var_19_76.armor_category

					arg_19_0:_play_hit_animations(arg_19_4, arg_19_5, var_19_100, var_19_98, var_19_113, var_19_107, var_19_57)

					if var_19_77 then
						var_19_100 = false
					end

					if Managers.state.controller_features and arg_19_0.owner.local_player and not arg_19_0._has_played_rumble_effect then
						if var_19_73 then
							Managers.state.controller_features:add_effect("rumble", {
								rumble_effect = "hit_armor"
							})
						else
							local var_19_114 = arg_19_5.hit_rumble_effect or "hit_character"

							Managers.state.controller_features:add_effect("rumble", {
								rumble_effect = var_19_114
							})
						end

						if var_19_100 then
							arg_19_0._has_played_rumble_effect = true
						end
					end

					local var_19_115, var_19_116 = arg_19_0:_get_power_boost()
					local var_19_117 = arg_19_0._power_level
					local var_19_118 = arg_19_0._is_critical_strike or var_19_115
					local var_19_119 = var_19_46.charge_value
					local var_19_120 = false
					local var_19_121 = "no_buff"

					if var_19_84 or var_19_85 then
						if var_19_119 == "heavy_attack" and var_19_96:has_buff_perk("shield_break") or var_19_96:has_buff_perk("potion_armor_penetration") then
							var_19_120 = true
						end

						local var_19_122 = not var_19_76.unbreakable_shield and (var_19_46.shield_break or var_19_120)

						DamageUtils.handle_hit_indication(arg_19_4, var_19_74, 0, var_19_98, false, not var_19_122, var_19_122)
					else
						local var_19_123 = true
						local var_19_124 = arg_19_0._number_of_hit_enemies
						local var_19_125 = DamageUtils.get_item_buff_type(arg_19_0.item_name)

						var_19_121 = DamageUtils.buff_on_attack(arg_19_4, var_19_74, var_19_119, var_19_118, var_19_98, var_19_124, var_19_123, var_19_125, nil, var_19_101)

						local var_19_126 = NetworkLookup.attack_templates[var_19_91.attack_template]

						var_19_3:rpc_weapon_blood(nil, var_19_103, var_19_126)

						local var_19_127 = Vector3(var_19_63.position.x, var_19_63.position.y, var_19_63.position.z + arg_19_0._down_offset)

						Managers.state.blood:add_enemy_blood(var_19_127, var_19_74)
					end

					if var_19_121 ~= "killing_blow" then
						arg_19_0:_send_attack_hit(arg_19_2, var_19_102, var_19_103, var_19_89, var_19_104, var_19_66, var_19_27, var_19_97, "power_level", var_19_117, "hit_target_index", var_19_90, "blocking", var_19_84 or var_19_85, "shield_break_procced", var_19_120, "boost_curve_multiplier", var_19_116, "is_critical_strike", var_19_118, "can_damage", var_19_87, "can_stagger", var_19_88, "backstab_multiplier", var_19_106, "first_hit", arg_19_0._number_of_hit_enemies == 1)

						if not var_19_107 and not arg_19_0.is_server then
							local var_19_128 = NetworkLookup.attack_templates[var_19_91.attack_template]

							var_19_2.network_transmit:send_rpc_server("rpc_weapon_blood", var_19_103, var_19_128)
						end

						var_0_7(arg_19_0.first_person_unit, "sfx_swing_hit")

						if arg_19_5.add_fatigue_on_hit then
							arg_19_0:_handle_fatigue(var_19_96, arg_19_0._status_extension, arg_19_5, false)
						end
					else
						var_19_44:play_hud_sound_event("Play_hud_matchmaking_countdown")
					end

					if arg_19_5.knockback_data then
						local var_19_129 = ScriptUnit.has_extension(var_19_74, "status_system")

						if var_19_129 and not var_19_129:is_knocked_down() then
							arg_19_0:_push_target(arg_19_4, var_19_74, arg_19_5.knockback_data, var_19_107, var_19_80)
						end
					end

					if var_19_100 then
						break
					end
				end
			elseif not var_19_79 and var_19_78 then
				if ScriptUnit.has_extension(var_19_74, "ai_inventory_item_system") then
					if not arg_19_0._hit_units[var_19_74] then
						var_0_7(var_19_74, "break_shield")

						arg_19_0._hit_units[var_19_74] = true
					end

					if Managers.state.controller_features and arg_19_0.owner.local_player and not arg_19_0._has_played_rumble_effect then
						Managers.state.controller_features:add_effect("rumble", {
							rumble_effect = "hit_shield"
						})

						arg_19_0._has_played_rumble_effect = true
					end
				elseif var_19_47[var_19_74] == nil and ScriptUnit.has_extension(var_19_74, "health_system") then
					local var_19_130, var_19_131 = Managers.state.network:game_object_or_level_id(var_19_74)

					if var_19_131 then
						arg_19_0:hit_level_object(var_19_47, var_19_74, arg_19_4, arg_19_5, var_19_66, var_19_27, var_19_130)
						arg_19_0:_play_environmental_effect(arg_19_9, arg_19_5, var_19_74, var_19_66, var_19_67, var_19_75)

						var_19_1 = true
					else
						arg_19_0._hit_units[var_19_74] = var_19_74

						local var_19_132 = math.ceil(arg_19_0._amount_of_mass_hit + 1)
						local var_19_133 = arg_19_0.item_name
						local var_19_134 = NetworkLookup.damage_sources[var_19_133]
						local var_19_135 = var_19_2:unit_game_object_id(arg_19_4)
						local var_19_136 = var_19_2:unit_game_object_id(var_19_74)
						local var_19_137 = NetworkLookup.hit_zones.full
						local var_19_138 = arg_19_0._damage_profile_id
						local var_19_139, var_19_140 = arg_19_0:_get_power_boost()
						local var_19_141 = arg_19_0._power_level
						local var_19_142 = arg_19_0._is_critical_strike or var_19_139

						if var_0_3(var_19_74, "allow_melee_damage") ~= false then
							arg_19_0:_send_attack_hit(arg_19_2, var_19_134, var_19_135, var_19_136, var_19_137, var_19_66, var_19_27, var_19_138, "power_level", var_19_141, "hit_target_index", var_19_132, "blocking", var_19_84, "boost_curve_multiplier", var_19_140, "is_critical_strike", var_19_142)

							local var_19_143 = not var_0_3(var_19_74, "weapon_hit_through")

							arg_19_0:_play_hit_animations(arg_19_4, arg_19_5, var_19_143)
							arg_19_0:_play_environmental_effect(arg_19_9, arg_19_5, var_19_74, var_19_66, var_19_67, var_19_75)

							var_19_1 = true
						end
					end
				elseif var_19_47[var_19_74] == nil then
					if global_is_inside_inn then
						local var_19_144 = true

						arg_19_0:_play_hit_animations(arg_19_4, arg_19_5, var_19_144)
					end

					var_19_48 = iter_19_7
					var_19_1 = true
				end
			end

			if var_19_84 or var_19_85 then
				arg_19_0._amount_of_mass_hit = arg_19_0._amount_of_mass_hit + 3
			end
		end
	end

	arg_19_0._this_attack_killed_enemy = var_19_57

	if var_19_48 and not arg_19_0._has_hit_environment and var_19_35 + var_19_36 > 0 then
		arg_19_0._has_hit_environment = true

		local var_19_145 = var_0_23[var_19_48]
		local var_19_146 = var_19_145.actor
		local var_19_147 = _revalidate_actor_and_get_unit(var_19_146)

		if var_0_2(var_19_147) and arg_19_3 ~= var_19_147 then
			local var_19_148 = var_19_145.position
			local var_19_149 = var_19_145.normal
			local var_19_150 = var_19_27

			arg_19_0:_play_environmental_effect(arg_19_9, arg_19_5, var_19_147, var_19_148, var_19_149, var_19_146)

			if Managers.state.controller_features and global_is_inside_inn and arg_19_0.owner.local_player and not arg_19_0._has_played_rumble_effect then
				Managers.state.controller_features:add_effect("rumble", {
					rumble_effect = "hit_environment"
				})

				arg_19_0._has_played_rumble_effect = true
			end

			if var_19_147 and var_0_2(var_19_147) and var_19_146 then
				var_0_8(var_19_147, "hit_actor", var_19_146)
				var_0_8(var_19_147, "hit_direction", var_19_150)
				var_0_8(var_19_147, "hit_position", var_19_148)
				var_0_7(var_19_147, "lua_simple_damage")
			end
		end
	end

	if var_19_7 then
		arg_19_0._attack_aborted = true
	end

	if Managers.state.controller_features and global_is_inside_inn and var_19_1 and arg_19_0.owner.local_player and not arg_19_0._has_played_rumble_effect then
		Managers.state.controller_features:add_effect("rumble", {
			rumble_effect = "hit_environment"
		})

		arg_19_0._has_played_rumble_effect = true
	end

	if PhysicsWorld.stop_reusing_sweep_tables then
		PhysicsWorld.stop_reusing_sweep_tables()
	end
end

ActionSweep._push_target = function (arg_20_0, arg_20_1, arg_20_2, arg_20_3, arg_20_4, arg_20_5)
	local var_20_0 = arg_20_3.catapult
	local var_20_1 = arg_20_3.catapult_players

	if var_20_0 then
		if var_20_1 and arg_20_5 then
			local var_20_2 = arg_20_3.player_catapult_speed
			local var_20_3 = arg_20_3.player_catapult_speed_z

			if arg_20_4 then
				var_20_2 = arg_20_3.player_catapult_speed_blocked
				var_20_3 = arg_20_3.player_catapult_speed_blocked_z
			end

			local var_20_4 = POSITION_LOOKUP[arg_20_1]
			local var_20_5 = POSITION_LOOKUP[arg_20_2] - var_20_4
			local var_20_6 = var_20_2 * Vector3.normalize(var_20_5)

			if var_20_3 then
				Vector3.set_z(var_20_6, var_20_3)
			end

			if var_20_1 then
				StatusUtils.set_catapulted_network(arg_20_2, true, var_20_6)
			end
		end
	else
		local var_20_7 = arg_20_3.player_knockback_speed

		if arg_20_4 then
			var_20_7 = arg_20_3.player_knockback_speed_blocked
		end

		local var_20_8 = POSITION_LOOKUP[arg_20_1]
		local var_20_9 = POSITION_LOOKUP[arg_20_2] - var_20_8
		local var_20_10 = var_20_7 * Vector3.normalize(var_20_9)

		ScriptUnit.extension(arg_20_2, "locomotion_system"):add_external_velocity(var_20_10)
	end
end

ActionSweep._play_environmental_effect = function (arg_21_0, arg_21_1, arg_21_2, arg_21_3, arg_21_4, arg_21_5, arg_21_6)
	local var_21_0 = Quaternion.forward(arg_21_1)
	local var_21_1 = Quaternion.right(arg_21_1)
	local var_21_2 = Quaternion.up(arg_21_1)
	local var_21_3 = arg_21_0.world
	local var_21_4 = arg_21_2.impact_axis and arg_21_2.impact_axis:unbox() or Vector3.forward()
	local var_21_5 = arg_21_0._overridable_settings.hit_effect
	local var_21_6 = var_21_1 * var_21_4.x + var_21_0 * var_21_4.y + var_21_2 * var_21_4.z
	local var_21_7 = Quaternion.look(var_21_6, -var_21_1)
	local var_21_8 = arg_21_0.owner_unit
	local var_21_9 = Managers.player:owner(var_21_8).bot_player

	EffectHelper.play_surface_material_effects(var_21_5, var_21_3, arg_21_3, arg_21_4, var_21_7, arg_21_5, nil, var_21_9, nil, arg_21_6)

	if Managers.state.network:game() then
		EffectHelper.remote_play_surface_material_effects(var_21_5, var_21_3, arg_21_3, arg_21_4, var_21_7, arg_21_5, arg_21_0.is_server, arg_21_6)
	end
end

local var_0_24 = {
	javelin_stab_hit = "stab_hit",
	slashing_hit = "slashing_hit",
	stab_hit = "stab_hit",
	slashing_dagger_hit = "slashing_hit",
	Play_weapon_fire_torch_flesh_hit = "burning_hit",
	axe_boss_1h_hit = "axe_boss_1h_hit",
	hammer_2h_hit = "blunt_hit",
	axe_2h_hit = "slashing_hit",
	crowbill_stab_hit = "stab_hit",
	axe_1h_hit = "slashing_hit",
	blunt_hit = "blunt_hit"
}

ActionSweep._play_character_impact = function (arg_22_0, arg_22_1, arg_22_2, arg_22_3, arg_22_4, arg_22_5, arg_22_6, arg_22_7, arg_22_8, arg_22_9, arg_22_10, arg_22_11, arg_22_12, arg_22_13, arg_22_14, arg_22_15)
	local var_22_0 = Managers.player:owner(arg_22_2).bot_player
	local var_22_1 = arg_22_0.world
	local var_22_2 = arg_22_0.owner_unit
	local var_22_3 = arg_22_8.targets and arg_22_8.targets[arg_22_9] or arg_22_8.default_target
	local var_22_4 = var_22_3.attack_template
	local var_22_5 = DamageUtils.get_attack_template(var_22_4)
	local var_22_6 = 0
	local var_22_7 = false

	if var_22_3 then
		local var_22_8 = arg_22_0.item_name
		local var_22_9 = BoostCurves[var_22_3.boost_curve_type]

		var_22_6, var_22_7 = DamageUtils.calculate_damage(DamageOutput, arg_22_3, arg_22_2, arg_22_6, arg_22_10, var_22_9, arg_22_13, arg_22_14, arg_22_8, arg_22_9, arg_22_15, var_22_8)
	end

	local var_22_10 = var_22_6 <= 0
	local var_22_11 = arg_22_4.hitzone_armor_categories
	local var_22_12 = var_22_11 and var_22_11[arg_22_6] or arg_22_4.armor_category
	local var_22_13 = var_22_10 and arg_22_7.stagger_impact_sound_event or arg_22_0._overridable_settings.impact_sound_event

	if arg_22_12 then
		if var_0_24[var_22_13] == "blunt_hit" then
			var_22_13 = arg_22_4.shield_blunt_block_sound or "blunt_hit_shield_wood"
		elseif var_0_24[var_22_13] == "slashing_hit" then
			var_22_13 = arg_22_4.shield_slashing_block_sound or "slashing_hit_shield_wood"
		elseif var_0_24[var_22_13] == "stab_hit" then
			var_22_13 = arg_22_4.shield_stab_block_sound or "stab_hit_shield_wood"
		elseif var_0_24[var_22_13] == "burning_hit" then
			var_22_13 = arg_22_4.shield_stab_block_sound or "Play_weapon_fire_torch_wood_shield_hit"
		elseif var_0_24[var_22_13] == "axe_boss_1h_hit" then
			var_22_13 = arg_22_4.boss_blocked_sound or "slashing_hit_shield_wood"
		end
	elseif var_22_12 == 2 then
		var_22_13 = var_22_10 and arg_22_0._overridable_settings.no_damage_impact_sound_event or arg_22_7.armor_impact_sound_event or arg_22_0._overridable_settings.impact_sound_event
	end

	local var_22_14 = "default"
	local var_22_15

	if arg_22_12 then
		if arg_22_4.blocking_hit_effect then
			var_22_15 = arg_22_4.blocking_hit_effect
		else
			var_22_15 = var_22_12 == 2 and "fx/hit_enemy_shield_metal" or "fx/hit_enemy_shield"
		end

		var_22_14 = "no_damage"
	elseif var_22_7 then
		var_22_15 = "fx/hit_enemy_shield_metal"
	elseif not var_22_14 or var_22_14 == "no_damage" then
		var_22_15 = arg_22_7.no_damage_impact_particle_effect
	elseif var_22_6 <= 0 and var_22_12 == 2 then
		var_22_15 = arg_22_7.armour_impact_particle_effect or "fx/hit_armored"
	elseif var_22_6 <= 0 then
		var_22_15 = arg_22_7.no_damage_impact_particle_effect
	elseif not arg_22_4.no_blood_splatter_on_damage then
		var_22_15 = arg_22_7.impact_particle_effect or BloodSettings:get_hit_effect_for_race(arg_22_4.race) or arg_22_4.hit_effect

		EffectHelper.player_critical_hit(var_22_1, arg_22_14, arg_22_2, arg_22_3, arg_22_5)
	end

	local var_22_16 = arg_22_7.additional_hit_effects

	if var_22_16 then
		for iter_22_0 = 1, #var_22_16 do
			EffectHelper.player_melee_hit_particles(var_22_1, var_22_16[iter_22_0], arg_22_5, arg_22_11, var_22_14, arg_22_3, var_22_6)
		end
	end

	if var_22_6 <= 0 then
		var_22_14 = "no_damage"
	end

	if var_22_15 then
		EffectHelper.player_melee_hit_particles(var_22_1, var_22_15, arg_22_5, arg_22_11, var_22_14, arg_22_3, var_22_6)
	end

	if (arg_22_6 == "head" or arg_22_6 == "neck") and var_22_5.headshot_sound then
		var_22_13 = var_22_5.headshot_sound
	end

	if var_22_7 then
		var_22_13 = "enemy_grudge_deflect"

		DamageUtils.handle_hit_indication(arg_22_0.owner_unit, arg_22_3, 0, arg_22_6, false, true)
	end

	local var_22_17 = var_22_5.sound_type

	if var_22_13 then
		if not var_22_17 then
			return
		end

		EffectHelper.play_melee_hit_effects(var_22_13, var_22_1, arg_22_5, var_22_17, var_22_0, arg_22_3)

		local var_22_18 = Managers.state.network
		local var_22_19 = NetworkLookup.sound_events[var_22_13]
		local var_22_20 = NetworkLookup.melee_impact_sound_types[var_22_17]
		local var_22_21 = var_22_18:unit_game_object_id(arg_22_3)

		if arg_22_1 then
			var_22_18.network_transmit:send_rpc_clients("rpc_play_melee_hit_effects", var_22_19, arg_22_5, var_22_20, var_22_21)
		else
			var_22_18.network_transmit:send_rpc_server("rpc_play_melee_hit_effects", var_22_19, arg_22_5, var_22_20, var_22_21)
		end
	else
		Application.warning("[ActionSweep] Missing sound event for sweep action in unit %q.", arg_22_0.weapon_unit)
	end

	local var_22_22 = DamageUtils.get_breed_damage_multiplier_type(arg_22_4, arg_22_6)

	if (var_22_22 == "headshot" or var_22_22 == "weakspot" and not arg_22_12) and not arg_22_7.no_headshot_sound and HEALTH_ALIVE[arg_22_3] then
		ScriptUnit.extension(var_22_2, "first_person_system"):play_hud_sound_event("Play_hud_melee_headshot", nil, false)
	end

	local var_22_23 = arg_22_7.on_hit_hud_sound_event

	if var_22_23 then
		ScriptUnit.extension(var_22_2, "first_person_system"):play_hud_sound_event(var_22_23, nil, false)
	end

	local var_22_24 = var_22_6 >= ScriptUnit.extension(arg_22_3, "health_system"):current_health()
	local var_22_25 = ScriptUnit.has_extension(arg_22_0.owner_unit, "sound_effect_system")

	if var_22_25 and var_22_24 then
		var_22_25:melee_kill()
	end

	if not arg_22_12 or arg_22_4.play_hit_reacts_when_blocking then
		DamageUtils.add_hit_reaction(arg_22_3, arg_22_4, var_22_0, arg_22_11, var_22_24)
	end

	if arg_22_12 then
		return false
	end

	return var_22_24
end

ActionSweep.hit_level_object = function (arg_23_0, arg_23_1, arg_23_2, arg_23_3, arg_23_4, arg_23_5, arg_23_6, arg_23_7, arg_23_8)
	arg_23_1[arg_23_2] = true
	arg_23_0._has_hit_environment = true

	local var_23_0 = "full"

	arg_23_0._amount_of_mass_hit = arg_23_0._amount_of_mass_hit + 1

	local var_23_1 = math.ceil(arg_23_0._amount_of_mass_hit)
	local var_23_2 = arg_23_0._damage_profile
	local var_23_3 = arg_23_0.item_name
	local var_23_4, var_23_5 = arg_23_0:_get_power_boost()
	local var_23_6 = arg_23_0._power_level
	local var_23_7 = arg_23_0._is_critical_strike or var_23_4

	DamageUtils.damage_level_unit(arg_23_2, arg_23_3, var_23_0, var_23_6, var_23_5, var_23_7, var_23_2, var_23_1, arg_23_6, var_23_3)

	local var_23_8 = arg_23_4.first_person_hit_anim

	if var_23_8 then
		local var_23_9 = ScriptUnit.extension(arg_23_3, "first_person_system"):get_first_person_unit()

		var_0_12(var_23_9, var_23_8)
	end
end

ActionSweep.finish = function (arg_24_0, arg_24_1, arg_24_2)
	local var_24_0 = arg_24_0._current_action

	if arg_24_1 == "new_interupting_action" then
		local var_24_1 = arg_24_0.current_time_in_action or 0
		local var_24_2 = arg_24_0._dt
		local var_24_3 = Managers.time:time("game")

		arg_24_0:_update_sweep(var_24_2 * 2, var_24_3, var_24_0, var_24_1 - var_24_2)
	end

	if arg_24_1 == "interacting" then
		var_0_7(arg_24_0.weapon_unit, "lua_finish_interacting")
	end

	local var_24_4 = arg_24_0.owner_unit
	local var_24_5 = var_24_0.action_aborted_flow_event

	if var_24_5 and not arg_24_0.action_aborted_flow_event_sent then
		var_0_7(arg_24_0.weapon_unit, var_24_5)
	end

	arg_24_0.action_aborted_flow_event_sent = nil

	if var_24_0.keep_block then
		local var_24_6 = arg_24_2 and arg_24_2.new_action_settings

		if not var_24_6 or not var_24_6.keep_block then
			if not LEVEL_EDITOR_TEST then
				local var_24_7 = Managers.state.unit_storage:go_id(var_24_4)

				if arg_24_0.is_server then
					Managers.state.network.network_transmit:send_rpc_clients("rpc_set_blocking", var_24_7, false)
				else
					Managers.state.network.network_transmit:send_rpc_server("rpc_set_blocking", var_24_7, false)
				end
			end

			ScriptUnit.extension(var_24_4, "status_system"):set_blocking(false)
		end
	end

	local var_24_8 = arg_24_0._owner_hud_extension

	if var_24_8 then
		var_24_8.show_critical_indication = false
	end

	local var_24_9 = ScriptUnit.extension(var_24_4, "first_person_system")

	var_24_9:enable_rig_movement()

	if arg_24_0._is_critical_strike then
		local var_24_10 = "Stop_player_combat_crit_swing_2D"

		var_24_9:play_hud_sound_event(var_24_10, nil, false)
	end
end

ActionSweep.destroy = function (arg_25_0)
	return
end

ActionSweep._play_hit_animations = function (arg_26_0, arg_26_1, arg_26_2, arg_26_3, arg_26_4, arg_26_5, arg_26_6, arg_26_7)
	local var_26_0 = arg_26_2.dual_hit_stop_anims and arg_26_0._action_hand and arg_26_2.dual_hit_stop_anims[arg_26_0._action_hand] or arg_26_0._overridable_settings.hit_stop_anim
	local var_26_1 = arg_26_3 and arg_26_7 and arg_26_2.hit_stop_kill_anim or arg_26_4 ~= "head" and arg_26_5 == 2 and arg_26_3 and arg_26_2.hit_armor_anim or arg_26_3 and arg_26_6 and arg_26_2.hit_shield_stop_anim or arg_26_3 and var_26_0 or arg_26_2.first_person_hit_anim
	local var_26_2 = arg_26_3 and arg_26_0._overridable_settings.hit_stop_anim

	arg_26_0._attack_aborted = arg_26_0._attack_aborted or arg_26_3

	if var_26_1 then
		local var_26_3 = ScriptUnit.extension(arg_26_1, "first_person_system"):get_first_person_unit()

		var_0_12(var_26_3, var_26_1)
	end

	local var_26_4 = arg_26_2.action_aborted_flow_event

	if var_26_4 and arg_26_3 then
		arg_26_0.action_aborted_flow_event_sent = true

		var_0_7(arg_26_0.weapon_unit, var_26_4)
	end

	if var_26_2 then
		CharacterStateHelper.play_animation_event(arg_26_1, var_26_2)
	end
end

ActionSweep._get_damage_profile_name = function (arg_27_0, arg_27_1, arg_27_2)
	return arg_27_1 and arg_27_2["damage_profile_" .. arg_27_1] or arg_27_0._overridable_settings.damage_profile or "default"
end

ActionSweep._populate_sweep_action_data = function (arg_28_0, arg_28_1, arg_28_2)
	local var_28_0 = arg_28_0._overridable_settings

	table.clear(arg_28_0._overridable_settings)

	for iter_28_0 = 1, var_0_1 do
		local var_28_1 = var_0_0[iter_28_0]

		var_28_0[var_28_1] = arg_28_2 and arg_28_2[var_28_1] or arg_28_1[var_28_1]
	end
end

ActionSweep._weapon_sweep_rotation = function (arg_29_0, arg_29_1, arg_29_2)
	local var_29_0 = var_0_5(arg_29_2, 0)
	local var_29_1 = arg_29_1.sweep_rotation_offset

	if var_29_1 then
		local var_29_2 = var_29_0
		local var_29_3 = Quaternion.multiply(Quaternion.axis_angle(Quaternion.up(var_29_0), var_29_1.yaw or 0), var_29_2)
		local var_29_4 = Quaternion.multiply(Quaternion.axis_angle(Quaternion.right(var_29_0), var_29_1.pitch or 0), var_29_3)

		var_29_0 = Quaternion.multiply(Quaternion.axis_angle(Quaternion.forward(var_29_0), var_29_1.roll or 0), var_29_4)
	end

	return var_29_0
end
