-- chunkname: @scripts/unit_extensions/weapons/actions/action_push_stagger.lua

ActionPushStagger = class(ActionPushStagger, ActionBase)

function ActionPushStagger.init(arg_1_0, arg_1_1, arg_1_2, arg_1_3, arg_1_4, arg_1_5, arg_1_6, arg_1_7, arg_1_8)
	ActionPushStagger.super.init(arg_1_0, arg_1_1, arg_1_2, arg_1_3, arg_1_4, arg_1_5, arg_1_6, arg_1_7, arg_1_8)

	if ScriptUnit.has_extension(arg_1_7, "ammo_system") then
		arg_1_0.ammo_extension = ScriptUnit.extension(arg_1_7, "ammo_system")
	end

	arg_1_0._status_extension = ScriptUnit.extension(arg_1_4, "status_system")
	arg_1_0.owner_unit_first_person = arg_1_6
	arg_1_0.has_played_rumble_effect = false
	arg_1_0.hit_units = {}
	arg_1_0.push_units = {}
	arg_1_0.waiting_for_callback = false
	arg_1_0._player_direction = Vector3Box()
end

function ActionPushStagger.client_owner_start_action(arg_2_0, arg_2_1, arg_2_2, arg_2_3, arg_2_4, arg_2_5)
	ActionPushStagger.super.client_owner_start_action(arg_2_0, arg_2_1, arg_2_2, arg_2_3, arg_2_4, arg_2_5)

	arg_2_0.current_action = arg_2_1

	local var_2_0 = arg_2_0.owner_unit
	local var_2_1 = ScriptUnit.extension(var_2_0, "buff_system")
	local var_2_2 = ScriptUnit.extension(var_2_0, "career_system")
	local var_2_3 = arg_2_0._status_extension

	arg_2_0.owner_buff_extension = var_2_1
	arg_2_0.owner_career_extension = var_2_2

	local var_2_4, var_2_5 = var_2_2:has_melee_boost()
	local var_2_6 = ActionUtils.is_critical_strike(var_2_0, arg_2_1, arg_2_2)

	arg_2_0.melee_boost_curve_multiplier = var_2_5
	arg_2_0.power_level = arg_2_4
	arg_2_0.has_played_rumble_effect = false

	for iter_2_0, iter_2_1 in pairs(arg_2_0.hit_units) do
		arg_2_0.hit_units[iter_2_0] = nil
	end

	for iter_2_2, iter_2_3 in pairs(arg_2_0.push_units) do
		arg_2_0.push_units[iter_2_2] = nil
	end

	arg_2_0.bot_player = Managers.player:owner(var_2_0).bot_player

	if not arg_2_0.bot_player then
		Managers.state.controller_features:add_effect("rumble", {
			rumble_effect = "light_swing"
		})
	end

	local var_2_7 = arg_2_5 and arg_2_5.action_hand
	local var_2_8 = var_2_7 and arg_2_1["damage_profile_inner_" .. var_2_7] or arg_2_1.damage_profile_inner or "default"

	arg_2_0.damage_profile_inner_id = NetworkLookup.damage_profiles[var_2_8]
	arg_2_0.damage_profile_inner = DamageProfileTemplates[var_2_8]

	local var_2_9 = var_2_7 and arg_2_1["damage_profile_outer_" .. var_2_7] or arg_2_1.damage_profile_outer or "default"

	arg_2_0.damage_profile_outer_id = NetworkLookup.damage_profiles[var_2_9]
	arg_2_0.damage_profile_outer = DamageProfileTemplates[var_2_9]

	arg_2_0:_handle_fatigue(var_2_1, var_2_3, arg_2_1, true)

	arg_2_0.block_end_time = arg_2_2 + 0.5

	local var_2_10 = ScriptUnit.has_extension(var_2_0, "hud_system")
	local var_2_11 = ScriptUnit.extension(var_2_0, "first_person_system")

	arg_2_0:_handle_critical_strike(var_2_6, var_2_1, var_2_10, var_2_11, "on_critical_sweep", "Play_player_combat_crit_swing_2D")

	arg_2_0._is_critical_strike = var_2_6

	if not LEVEL_EDITOR_TEST then
		local var_2_12 = Managers.state.unit_storage:go_id(var_2_0)

		if arg_2_0.is_server then
			Managers.state.network.network_transmit:send_rpc_clients("rpc_set_blocking", var_2_12, true)
		else
			Managers.state.network.network_transmit:send_rpc_server("rpc_set_blocking", var_2_12, true)
		end
	end

	var_2_3:set_blocking(true)
	var_2_1:trigger_procs("on_push_used")
	Unit.animation_event(arg_2_0.owner_unit_first_person, "hitreaction_defend_reset")
end

local var_0_0 = {
	has_gotten_callback = false,
	overlap_units = {}
}

local function var_0_1(arg_3_0)
	var_0_0.has_gotten_callback = true

	local var_3_0 = var_0_0.overlap_units

	for iter_3_0, iter_3_1 in pairs(arg_3_0) do
		var_0_0.num_hits = var_0_0.num_hits + 1

		if var_3_0[var_0_0.num_hits] == nil then
			var_3_0[var_0_0.num_hits] = ActorBox()
		end

		var_3_0[var_0_0.num_hits]:store(iter_3_1)
	end
end

function ActionPushStagger.client_owner_post_update(arg_4_0, arg_4_1, arg_4_2, arg_4_3, arg_4_4)
	local var_4_0 = arg_4_0.current_action
	local var_4_1 = arg_4_0.owner_unit
	local var_4_2 = arg_4_0.weapon_system

	if arg_4_0.block_end_time and arg_4_2 > arg_4_0.block_end_time then
		if not LEVEL_EDITOR_TEST then
			local var_4_3 = Managers.state.unit_storage:go_id(var_4_1)

			if arg_4_0.is_server then
				Managers.state.network.network_transmit:send_rpc_clients("rpc_set_blocking", var_4_3, false)
			else
				Managers.state.network.network_transmit:send_rpc_server("rpc_set_blocking", var_4_3, false)
			end
		end

		local var_4_4 = arg_4_0._status_extension

		var_4_4:set_blocking(false)
		var_4_4:set_has_blocked(false)
	end

	if not var_0_0.has_gotten_callback and arg_4_4 then
		arg_4_0.waiting_for_callback = true
		var_0_0.num_hits = 0

		local var_4_5 = World.get_data(arg_4_3, "physics_world")
		local var_4_6 = POSITION_LOOKUP[var_4_1]
		local var_4_7 = arg_4_0.owner_buff_extension:apply_buffs_to_value(2.5, "push_range")
		local var_4_8 = math.max(var_4_0.push_radius, var_4_7)
		local var_4_9 = "filter_melee_push"

		PhysicsWorld.overlap(var_4_5, var_0_1, "shape", "sphere", "position", var_4_6, "size", var_4_8, "types", "dynamics", "collision_filter", var_4_9)

		local var_4_10 = arg_4_0.owner_unit_first_person
		local var_4_11 = Unit.world_rotation(var_4_10, 0)
		local var_4_12 = Vector3.normalize(Quaternion.forward(var_4_11))

		arg_4_0._player_direction:store(var_4_12)
	elseif arg_4_0.waiting_for_callback and var_0_0.has_gotten_callback then
		arg_4_0.waiting_for_callback = false
		var_0_0.has_gotten_callback = false

		local var_4_13 = Managers.state.network
		local var_4_14 = var_4_13:unit_game_object_id(var_4_1)
		local var_4_15 = var_0_0.overlap_units
		local var_4_16 = arg_4_0.hit_units
		local var_4_17 = arg_4_0.push_units
		local var_4_18 = var_0_0.num_hits
		local var_4_19 = false
		local var_4_20 = arg_4_0._player_direction:unbox()
		local var_4_21 = Vector3.flat(var_4_20)
		local var_4_22 = arg_4_0.owner_buff_extension
		local var_4_23 = math.rad(var_4_22:apply_buffs_to_value(var_4_0.push_angle or 90, "block_angle") * 0.5)
		local var_4_24 = math.rad(var_4_22:apply_buffs_to_value(var_4_0.outer_push_angle or 0, "block_angle") * 0.5)
		local var_4_25 = 0

		for iter_4_0 = 1, var_4_18 do
			repeat
				local var_4_26 = var_4_15[iter_4_0]:unbox()

				if var_4_26 == nil then
					break
				end

				local var_4_27 = Actor.unit(var_4_26)

				if var_4_16[var_4_27] == nil and HEALTH_ALIVE[var_4_27] then
					var_4_16[var_4_27] = true

					if not DamageUtils.is_enemy(var_4_1, var_4_27) then
						break
					end

					local var_4_28 = Unit.get_data(var_4_27, "breed")

					if not var_4_28 then
						return
					end

					local var_4_29 = Actor.node(var_4_26)
					local var_4_30 = var_4_28.hit_zones_lookup[var_4_29].name
					local var_4_31 = Vector3.normalize(POSITION_LOOKUP[var_4_27] - POSITION_LOOKUP[var_4_1])
					local var_4_32 = Vector3.flat(var_4_31)
					local var_4_33 = Vector3.dot(var_4_32, var_4_21)
					local var_4_34 = math.acos(var_4_33)
					local var_4_35 = var_4_34 <= var_4_23
					local var_4_36 = var_4_23 < var_4_34 and var_4_34 <= var_4_24

					if not var_4_35 and not var_4_36 then
						break
					end

					var_4_25 = var_4_25 + 1
					var_4_17[var_4_27] = {
						hit_actor = var_4_26,
						hit_zone_name = var_4_30,
						inner_push = var_4_35,
						outer_push = var_4_36,
						node = var_4_29,
						attack_direction = var_4_31,
						target_index = var_4_25
					}
				end
			until true
		end

		if var_4_25 == 0 then
			return
		end

		for iter_4_1, iter_4_2 in pairs(var_4_17) do
			repeat
				if not Unit.alive(iter_4_1) then
					break
				end

				if iter_4_2.inner_push and not iter_4_2.outer_push then
					local var_4_37 = "Play_player_push_ark_success"

					ScriptUnit.extension(var_4_1, "first_person_system"):play_hud_sound_event(var_4_37, nil, false)
				end

				local var_4_38 = var_4_13:unit_game_object_id(iter_4_1)
				local var_4_39 = NetworkLookup.hit_zones[iter_4_2.hit_zone_name]
				local var_4_40 = arg_4_0.power_level
				local var_4_41 = iter_4_2.inner_push and arg_4_0.damage_profile_inner_id or arg_4_0.damage_profile_outer_id
				local var_4_42 = (iter_4_2.inner_push and arg_4_0.damage_profile_inner or arg_4_0.damage_profile_outer).default_target
				local var_4_43 = Unit.world_position(iter_4_1, iter_4_2.node)
				local var_4_44 = var_4_0.impact_particle_effect or "fx/impact_block_push"
				local var_4_45 = POSITION_LOOKUP[iter_4_1] or Unit.world_position(iter_4_1, 0)
				local var_4_46 = POSITION_LOOKUP[var_4_1] or Unit.world_position(var_4_1, 0)
				local var_4_47 = Vector3.normalize(var_4_45 - var_4_46)

				if var_4_44 then
					EffectHelper.player_melee_hit_particles(arg_4_3, var_4_44, var_4_43, var_4_47, nil, iter_4_1)
				end

				local var_4_48 = var_4_0.stagger_impact_sound_event or "blunt_hit"

				if var_4_48 then
					local var_4_49 = DamageUtils.get_attack_template(var_4_42.attack_template)
					local var_4_50 = var_4_49 and var_4_49.sound_type or "stun_heavy"
					local var_4_51 = arg_4_0.bot_player

					EffectHelper.play_melee_hit_effects(var_4_48, arg_4_3, var_4_43, var_4_50, var_4_51, iter_4_1)

					local var_4_52 = NetworkLookup.sound_events[var_4_48]
					local var_4_53 = NetworkLookup.melee_impact_sound_types[var_4_50]

					var_4_43 = Vector3(math.clamp(var_4_43.x, -600, 600), math.clamp(var_4_43.y, -600, 600), math.clamp(var_4_43.z, -600, 600))

					if arg_4_0.is_server then
						var_4_13.network_transmit:send_rpc_clients("rpc_play_melee_hit_effects", var_4_52, var_4_43, var_4_53, var_4_38)
					else
						var_4_13.network_transmit:send_rpc_server("rpc_play_melee_hit_effects", var_4_52, var_4_43, var_4_53, var_4_38)
					end
				else
					Application.warning("[ActionPushStagger] Missing sound event for push action in unit %q.", arg_4_0.weapon_unit)
				end

				local var_4_54 = AiUtils.attack_is_shield_blocked(iter_4_1, var_4_1)
				local var_4_55 = arg_4_0.item_name
				local var_4_56 = NetworkLookup.damage_sources[var_4_55]
				local var_4_57 = arg_4_0._is_critical_strike
				local var_4_58 = iter_4_2.target_index or nil

				var_4_2:send_rpc_attack_hit(var_4_56, var_4_14, var_4_38, var_4_39, var_4_43, var_4_47, var_4_41, "power_level", var_4_40, "hit_target_index", var_4_58, "blocking", var_4_54, "shield_break_procced", false, "boost_curve_multiplier", arg_4_0.melee_boost_curve_multiplier, "is_critical_strike", var_4_57, "can_damage", false, "can_stagger", true, "total_hits", var_4_25)

				if Managers.state.controller_features and arg_4_0.owner.local_player and not arg_4_0.has_played_rumble_effect then
					Managers.state.controller_features:add_effect("rumble", {
						rumble_effect = "push_hit"
					})

					arg_4_0.has_played_rumble_effect = true
				end

				Managers.state.entity:system("play_go_tutorial_system"):register_push(iter_4_1)
				var_4_22:trigger_procs("on_push", iter_4_1, var_4_55)

				local var_4_59 = Managers.player
				local var_4_60 = var_4_59:owner(arg_4_0.owner_unit)

				if not LEVEL_EDITOR_TEST and not var_4_59.is_server then
					local var_4_61 = var_4_60:network_id()
					local var_4_62 = var_4_60:local_player_id()
					local var_4_63 = NetworkLookup.proc_events.on_push

					Managers.state.network.network_transmit:send_rpc_server("rpc_proc_event", var_4_61, var_4_62, var_4_63)
				end

				var_4_19 = true
			until true
		end

		if var_4_19 and not arg_4_0.bot_player then
			Managers.state.controller_features:add_effect("rumble", {
				rumble_effect = "hit_character_light"
			})
		end
	end
end

function ActionPushStagger.finish(arg_5_0, arg_5_1)
	local var_5_0 = ScriptUnit.has_extension(arg_5_0.owner_unit, "hud_system")

	if var_5_0 then
		var_5_0.show_critical_indication = false
	end

	arg_5_0.waiting_for_callback = false
	var_0_0.has_gotten_callback = false

	local var_5_1 = arg_5_0.ammo_extension
	local var_5_2 = arg_5_0.current_action
	local var_5_3 = arg_5_0.owner_unit

	if arg_5_1 ~= "new_interupting_action" then
		local var_5_4 = var_5_2.reload_when_out_of_ammo_condition_func
		local var_5_5 = not var_5_4 and true or var_5_4(var_5_3, arg_5_1)

		if var_5_1 and var_5_2.reload_when_out_of_ammo and var_5_5 and var_5_1:ammo_count() == 0 and var_5_1:can_reload() then
			local var_5_6 = true

			var_5_1:start_reload(var_5_6)
		end
	end

	if not LEVEL_EDITOR_TEST then
		local var_5_7 = Managers.state.unit_storage:go_id(var_5_3)

		if arg_5_0.is_server then
			Managers.state.network.network_transmit:send_rpc_clients("rpc_set_blocking", var_5_7, false)
		else
			Managers.state.network.network_transmit:send_rpc_server("rpc_set_blocking", var_5_7, false)
		end
	end

	local var_5_8 = arg_5_0._status_extension

	var_5_8:set_blocking(false)
	var_5_8:set_has_blocked(false)
end
