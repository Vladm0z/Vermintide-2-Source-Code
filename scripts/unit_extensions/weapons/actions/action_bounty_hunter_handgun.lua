-- chunkname: @scripts/unit_extensions/weapons/actions/action_bounty_hunter_handgun.lua

ActionBountyHunterHandgun = class(ActionBountyHunterHandgun, ActionBase)

function ActionBountyHunterHandgun.init(arg_1_0, arg_1_1, arg_1_2, arg_1_3, arg_1_4, arg_1_5, arg_1_6, arg_1_7, arg_1_8)
	ActionBountyHunterHandgun.super.init(arg_1_0, arg_1_1, arg_1_2, arg_1_3, arg_1_4, arg_1_5, arg_1_6, arg_1_7, arg_1_8)
end

function ActionBountyHunterHandgun.client_owner_start_action(arg_2_0, arg_2_1, arg_2_2, arg_2_3, arg_2_4, arg_2_5)
	ActionBountyHunterHandgun.super.client_owner_start_action(arg_2_0, arg_2_1, arg_2_2, arg_2_3, arg_2_4, arg_2_5)

	local var_2_0 = arg_2_0.weapon_unit
	local var_2_1 = arg_2_0.owner_unit
	local var_2_2 = ActionUtils.is_critical_strike(var_2_1, arg_2_1, arg_2_2)
	local var_2_3 = ScriptUnit.extension(var_2_1, "buff_system")

	arg_2_0.current_action = arg_2_1
	arg_2_0.power_level = arg_2_4
	arg_2_0.owner_buff_extension = var_2_3
	arg_2_0.upper_shoot_function = arg_2_5 and (arg_2_5.upper_barrel == "railgun" and arg_2_0._railgun_shoot or arg_2_0._shotgun_shoot) or arg_2_0._railgun_shoot
	arg_2_0.lower_shoot_function = arg_2_5 and (arg_2_5.lower_barrel == "railgun" and arg_2_0._railgun_shoot or arg_2_0._shotgun_shoot) or arg_2_0._shotgun_shoot

	Unit.set_flow_variable(var_2_0, "upper_is_railgun", arg_2_5.upper_barrel == "railgun")
	Unit.set_flow_variable(var_2_0, "lower_is_railgun", arg_2_5.lower_barrel == "railgun")

	if not Managers.player:owner(arg_2_0.owner_unit).bot_player then
		Managers.state.controller_features:add_effect("rumble", {
			rumble_effect = "light_swing"
		})
	end

	if ScriptUnit.has_extension(var_2_0, "spread_system") then
		arg_2_0.spread_extension = ScriptUnit.extension(var_2_0, "spread_system")
	end

	local var_2_4 = arg_2_1.damage_profile or "default"

	arg_2_0.damage_profile_id = NetworkLookup.damage_profiles[var_2_4]
	arg_2_0.damage_profile = DamageProfileTemplates[var_2_4]

	local var_2_5 = arg_2_1.damage_profile_aoe or "default"

	arg_2_0.damage_profile_aoe_id = NetworkLookup.damage_profiles[var_2_5]
	arg_2_0.damage_profile_aoe = DamageProfileTemplates[var_2_5]
	arg_2_0.upper_shot_done = nil
	arg_2_0.lower_shot_done = nil
	arg_2_0.aoe_done = nil
	arg_2_0.time_to_shoot_upper = arg_2_2 + arg_2_1.fire_time_upper
	arg_2_0.time_to_shoot_lower = arg_2_2 + arg_2_1.fire_time_lower
	arg_2_0.time_to_aoe = arg_2_2 + arg_2_1.aoe_time
	arg_2_0.hit_units = {}
	arg_2_0.shield_users_blocking = {}

	local var_2_6 = ScriptUnit.has_extension(var_2_1, "hud_system")

	arg_2_0:_handle_critical_strike(var_2_2, var_2_3, var_2_6, nil, "on_critical_shot", nil)

	arg_2_0.is_critical_strike = var_2_2

	if arg_2_1.block then
		ScriptUnit.extension(var_2_1, "status_system"):set_blocking(true)
	end
end

function ActionBountyHunterHandgun.client_owner_post_update(arg_3_0, arg_3_1, arg_3_2, arg_3_3, arg_3_4, arg_3_5)
	if not arg_3_0.upper_shot_done and arg_3_2 >= arg_3_0.time_to_shoot_upper then
		arg_3_0.upper_shoot_function(arg_3_0)

		arg_3_0.upper_shot_done = true
	end

	if not arg_3_0.lower_shot_done and arg_3_2 >= arg_3_0.time_to_shoot_lower then
		arg_3_0.lower_shoot_function(arg_3_0)

		arg_3_0.lower_shot_done = true
	end

	if not arg_3_0.aoe_done and arg_3_2 >= arg_3_0.time_to_aoe then
		arg_3_0:_do_aoe()

		arg_3_0.aoe_done = true
	end
end

function ActionBountyHunterHandgun._railgun_shoot(arg_4_0)
	local var_4_0 = arg_4_0.owner_unit
	local var_4_1 = arg_4_0.current_action
	local var_4_2 = true

	if not Managers.player:owner(arg_4_0.owner_unit).bot_player then
		Managers.state.controller_features:add_effect("rumble", {
			rumble_effect = "handgun_fire"
		})
	end

	local var_4_3 = ScriptUnit.extension(var_4_0, "first_person_system")
	local var_4_4, var_4_5 = var_4_3:get_projectile_start_position_rotation()
	local var_4_6 = arg_4_0.spread_extension
	local var_4_7 = var_4_1.railgun_spread_template

	if var_4_6 then
		if var_4_7 then
			var_4_6:override_spread_template(var_4_7)
		end

		var_4_5 = var_4_6:get_randomised_spread(var_4_5)

		if var_4_2 then
			var_4_6:set_shooting()
		end
	end

	local var_4_8 = ActionUtils.pitch_from_rotation(var_4_5)
	local var_4_9 = var_4_1.speed
	local var_4_10 = Vector3.normalize(Vector3.flat(Quaternion.forward(var_4_5)))
	local var_4_11 = var_4_1.lookup_data

	ActionUtils.spawn_player_projectile(var_4_0, var_4_4, var_4_5, 0, var_4_8, var_4_10, var_4_9, arg_4_0.item_name, var_4_11.item_template_name, var_4_11.action_name, var_4_11.sub_action_name, arg_4_0.is_critical_strike, arg_4_0.power_level)
	var_4_3:reset_aim_assist_multiplier()
end

function ActionBountyHunterHandgun._shotgun_shoot(arg_5_0)
	local var_5_0 = arg_5_0.world
	local var_5_1 = arg_5_0.owner_unit
	local var_5_2 = arg_5_0.current_action
	local var_5_3 = arg_5_0.spread_extension
	local var_5_4 = arg_5_0.is_server
	local var_5_5 = var_5_2.shotgun_spread_template

	if var_5_5 then
		arg_5_0.spread_extension:override_spread_template(var_5_5)
	end

	local var_5_6, var_5_7 = ScriptUnit.extension(var_5_1, "first_person_system"):get_projectile_start_position_rotation()
	local var_5_8 = var_5_2.shot_count or 1
	local var_5_9 = ScriptUnit.extension(var_5_1, "buff_system")
	local var_5_10 = 0

	if var_5_9:has_buff_type("victor_bounty_blast_streak_buff") then
		var_5_8 = var_5_8 + var_5_9:num_buff_type("victor_bounty_blast_streak_buff")
	end

	if not Managers.player:owner(var_5_1).bot_player then
		Managers.state.controller_features:add_effect("rumble", {
			rumble_effect = "handgun_fire"
		})
	end

	local var_5_11 = World.get_data(var_5_0, "physics_world")
	local var_5_12 = true
	local var_5_13 = arg_5_0.weapon_unit

	for iter_5_0 = 1, var_5_8 do
		local var_5_14 = var_5_7

		if var_5_3 then
			var_5_14 = var_5_3:get_target_style_spread(iter_5_0, var_5_8, var_5_7)
		end

		local var_5_15 = Quaternion.forward(var_5_14)
		local var_5_16 = PhysicsWorld.immediate_raycast_actors(var_5_11, var_5_6, var_5_15, var_5_2.range, "static_collision_filter", "filter_player_ray_projectile_static_only", "dynamic_collision_filter", "filter_player_ray_projectile_ai_only", "dynamic_collision_filter", "filter_player_ray_projectile_hitbox_only")

		if var_5_16 then
			local var_5_17 = DamageUtils.process_projectile_hit(var_5_0, arg_5_0.item_name, var_5_1, var_5_4, var_5_16, var_5_2, var_5_15, var_5_12, nil, arg_5_0.shield_users_blocking, arg_5_0.is_critical_strike, arg_5_0.power_level)

			if var_5_17.buffs_checked then
				var_5_12 = var_5_12 and false
			end

			if var_5_17.blocked_by_unit then
				arg_5_0.shield_users_blocking[var_5_17.blocked_by_unit] = true
			end
		end

		local var_5_18 = var_5_16 and var_5_16[#var_5_16][1] or var_5_6 + var_5_15 * var_5_2.range

		Unit.set_flow_variable(var_5_13, "hit_position", var_5_18)
		Unit.set_flow_variable(var_5_13, "trail_life", Vector3.length(var_5_18 - var_5_6) * 0.1)
		Unit.flow_event(var_5_13, "lua_bullet_trail")
		Unit.flow_event(var_5_13, "lua_bullet_trail_set")
	end

	local var_5_19 = not arg_5_0.extra_buff_shot

	if var_5_3 and var_5_19 then
		var_5_3:set_shooting()
	end

	if var_5_2.alert_sound_range_fire then
		Managers.state.entity:system("ai_system"):alert_enemies_within_range(var_5_1, POSITION_LOOKUP[var_5_1], var_5_2.alert_sound_range_fire)
	end
end

function ActionBountyHunterHandgun._do_aoe(arg_6_0)
	local var_6_0 = arg_6_0.world
	local var_6_1 = arg_6_0.owner_unit
	local var_6_2 = arg_6_0.current_action
	local var_6_3 = Managers.state.network
	local var_6_4 = World.get_data(var_6_0, "physics_world")
	local var_6_5 = var_6_3:unit_game_object_id(var_6_1)
	local var_6_6 = Quaternion.forward(Unit.local_rotation(var_6_1, 0))
	local var_6_7 = POSITION_LOOKUP[var_6_1] + var_6_6 * 0.5
	local var_6_8 = var_6_2.aoe_radius
	local var_6_9 = "filter_melee_sweep"
	local var_6_10, var_6_11 = PhysicsWorld.immediate_overlap(var_6_4, "shape", "sphere", "position", var_6_7, "size", var_6_8, "types", "dynamics", "collision_filter", var_6_9)
	local var_6_12 = arg_6_0.hit_units

	for iter_6_0 = 1, var_6_11 do
		repeat
			local var_6_13 = var_6_10[iter_6_0]
			local var_6_14 = Actor.unit(var_6_13)
			local var_6_15 = AiUtils.unit_breed(var_6_14)

			if var_6_15 and not var_6_12[var_6_14] and not var_6_15.is_player then
				var_6_12[var_6_14] = true

				local var_6_16 = Actor.node(var_6_13)
				local var_6_17 = Unit.world_position(var_6_14, var_6_16)
				local var_6_18 = Vector3.normalize(var_6_17 - var_6_7)
				local var_6_19 = var_6_15.hit_zones_lookup[var_6_16].name
				local var_6_20 = NetworkLookup.hit_zones[var_6_19]
				local var_6_21 = var_6_3:unit_game_object_id(var_6_14)
				local var_6_22 = arg_6_0.power_level
				local var_6_23 = arg_6_0.damage_profile_aoe_id
				local var_6_24 = AiUtils.attack_is_shield_blocked(var_6_14, var_6_1)
				local var_6_25 = arg_6_0.item_name
				local var_6_26 = NetworkLookup.damage_sources[var_6_25]
				local var_6_27 = arg_6_0.weapon_system
				local var_6_28 = 1
				local var_6_29 = arg_6_0.is_critical_strike
				local var_6_30 = false
				local var_6_31 = true
				local var_6_32

				var_6_27:send_rpc_attack_hit(var_6_26, var_6_5, var_6_21, var_6_20, var_6_17, var_6_18, var_6_23, "power_level", var_6_22, "hit_target_index", var_6_32, "blocking", var_6_24, "shield_break_procced", false, "boost_curve_multiplier", var_6_28, "is_critical_strike", var_6_29, "can_damage", var_6_30, "can_stagger", var_6_31)
			end
		until true
	end
end

function ActionBountyHunterHandgun.finish(arg_7_0, arg_7_1)
	local var_7_0 = arg_7_0.current_action
	local var_7_1 = arg_7_0.owner_unit

	if arg_7_1 ~= "new_interupting_action" then
		ScriptUnit.extension(var_7_1, "status_system"):set_zooming(false)
	end

	if var_7_0.block then
		ScriptUnit.extension(var_7_1, "status_system"):set_blocking(false)
	end

	local var_7_2 = ScriptUnit.has_extension(var_7_1, "hud_system")

	if var_7_2 then
		var_7_2.show_critical_indication = false
	end
end
