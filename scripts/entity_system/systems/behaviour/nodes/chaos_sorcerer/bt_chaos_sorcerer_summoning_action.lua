-- chunkname: @scripts/entity_system/systems/behaviour/nodes/chaos_sorcerer/bt_chaos_sorcerer_summoning_action.lua

require("scripts/entity_system/systems/behaviour/nodes/bt_node")

BTChaosSorcererSummoningAction = class(BTChaosSorcererSummoningAction, BTNode)

BTChaosSorcererSummoningAction.init = function (arg_1_0, ...)
	-- function 1
	BTChaosSorcererSummoningAction.super.init(arg_1_0, ...)
end

BTChaosSorcererSummoningAction.name = "BTChaosSorcererSummoningAction"

BTChaosSorcererSummoningAction.enter = function (self, arg_2_1, arg_2_2, arg_2_3)
	-- function 2
	local action_data = self._tree_node.action_data

	arg_2_2.action = action_data
	arg_2_2.attack_finished = false

	local vortex_data = arg_2_2.vortex_data

	if not action_data.vortex_template_name then
		vortex_data.vortex_template = VortexTemplates[action_data.vortex_template_name]
	end

	local target_unit = arg_2_2.target_unit
	local var_2_3

	if not target_unit then
		var_2_3 = Vector3Box(POSITION_LOOKUP[target_unit])

		if not var_2_3 then
			-- Nothing
		end
	end

	var_2_3 = Vector3Box()

	::label_2_0::

	arg_2_2.target_position = var_2_3

	local spell_count = arg_2_2.spell_count

	spell_count = spell_count or 0
	arg_2_2.spell_count = spell_count

	if not action_data.is_spawner then
		arg_2_2.locomotion_extension:set_wanted_velocity(Vector3.zero())
		arg_2_2.navigation_extension:set_enabled(false)

		local attack_anim = action_data.attack_anim

		if not attack_anim then
			Managers.state.network:anim_event(arg_2_1, attack_anim)
		end

		local init_func_name = action_data.init_func_name

		if not init_func_name then
			self[init_func_name](self, arg_2_1, arg_2_2, arg_2_3)
		end

		arg_2_2.move_state = "attacking"
		arg_2_2.summon_target_unit = target_unit
		arg_2_2.summoning = true
	end

	if not arg_2_2.breed.summon_sound_event then
		self:trigger_summon_sound(arg_2_1, arg_2_2, arg_2_3)
	end
end

BTChaosSorcererSummoningAction.trigger_summon_sound = function (arg_3_0, arg_3_1, arg_3_2, arg_3_3)
	-- function 3
	local breed = arg_3_2.breed
	local network = Managers.state.network
	local summon_sound_event = breed.summon_sound_event
	local no_summon_sound_for_target = breed.no_summon_sound_for_target
	local player = Managers.player
	local target_unit = arg_3_2.target_unit
	local unit_owner = player:unit_owner(target_unit)
	local has_extension_input = ScriptUnit.has_extension_input(arg_3_1, "dialogue_system")
	local system = Managers.state.entity:system("audio_system")
	local game_object_id = NetworkUnit.game_object_id(arg_3_1)
	local var_3_10 = NetworkLookup.sound_events[summon_sound_event]

	if not no_summon_sound_for_target then
		if not unit_owner.local_player then
			has_extension_input:play_voice(summon_sound_event, true)
		end

		network.network_transmit:send_rpc_clients_except("rpc_server_audio_unit_dialogue_event", unit_owner.peer_id, var_3_10, game_object_id, 0)
	else
		has_extension_input:play_voice(summon_sound_event, true)
		network.network_transmit:send_rpc_clients("rpc_server_audio_unit_dialogue_event", var_3_10, game_object_id, 0)
	end
end

BTChaosSorcererSummoningAction.leave = function (self, arg_4_1, arg_4_2, arg_4_3, arg_4_4, arg_4_5)
	-- function 4
	local action = arg_4_2.action

	if not action.is_spawner then
		arg_4_2.navigation_extension:set_enabled(true)

		local cleanup_func_name = action.cleanup_func_name

		if not cleanup_func_name then
			self[cleanup_func_name](self, arg_4_1, arg_4_2, arg_4_3)
		end
	end

	arg_4_2.action = nil
	arg_4_2.attack_finished = false
	arg_4_2.summoning = nil
	arg_4_2.summoning_unit = nil
	arg_4_2.summon_target_unit = nil
	arg_4_2.ready_to_summon = false
	arg_4_2.summoning_finished = nil

	QuickDrawerStay:reset()
end

BTChaosSorcererSummoningAction.run = function (self, arg_5_1, arg_5_2, arg_5_3, arg_5_4)
	-- function 5
	local action = arg_5_2.action
	local summon_target_unit = arg_5_2.summon_target_unit

	if not Unit.alive(summon_target_unit) then
		local has_extension = ScriptUnit.has_extension(summon_target_unit, "status_system")

		if not (not has_extension and has_extension:is_invisible() or has_extension:get_is_dodging() or action.use_first_position) then
			arg_5_2.target_position:store(POSITION_LOOKUP[summon_target_unit])
		end

		if not arg_5_2.face_target_while_summoning then
			local rotation_towards_unit_flat = LocomotionUtils.rotation_towards_unit_flat(arg_5_1, summon_target_unit)

			arg_5_2.locomotion_extension:set_wanted_rotation(rotation_towards_unit_flat)
		end
	end

	if not action.ignore_attack_finished then
		if not arg_5_2.attack_finished then
			arg_5_2.ready_to_summon = false

			return "done"
		elseif not arg_5_2.summoning_finished then
			local unbox = arg_5_2.target_position:unbox()
			local var_5_5 = self[action.spawn_func_name](self, arg_5_1, arg_5_2, arg_5_3, arg_5_4, unbox, arg_5_2.current_spell)

			arg_5_2.spell_count = arg_5_2.spell_count + 1
			arg_5_2.summoning_finished = nil

			if not var_5_5 then
				return "done"
			end
		end
	end

	local update_func_name = action.update_func_name

	if not update_func_name and not self[update_func_name](self, arg_5_1, arg_5_2, arg_5_3, arg_5_4) then
		arg_5_2.summoning_finished = nil

		return "done"
	end

	return "running"
end

BTChaosSorcererSummoningAction.spawn_exalted_spell = function (arg_6_0, arg_6_1, arg_6_2, arg_6_3, arg_6_4, arg_6_5)
	-- function 6
	local current_spell = arg_6_2.current_spell

	current_spell.spawn_function(arg_6_0, arg_6_2, arg_6_3, arg_6_4, arg_6_5, current_spell)
end

local num = 0.25

BTChaosSorcererSummoningAction._start_vortex_summoning = function (arg_7_0, arg_7_1, arg_7_2, arg_7_3)
	-- function 7
	local world = arg_7_2.world
	local action = arg_7_2.action
	local vortex_data = arg_7_2.vortex_data
	local vortex_template = vortex_data.vortex_template
	local unbox = vortex_data.vortex_spawn_pos:unbox()
	local max_height = vortex_template.max_height
	local vortex_spawn_radius = vortex_data.vortex_spawn_radius
	local min = math.min(vortex_spawn_radius / vortex_template.full_inner_radius, 1)

	if not Managers.player.is_server then
		local inner_decal_unit_name = action.inner_decal_unit_name

		if not inner_decal_unit_name then
			local from_quaternion_position = Matrix4x4.from_quaternion_position(Quaternion.identity(), unbox)
			local max = math.max(vortex_template.min_inner_radius, min * vortex_template.full_inner_radius)

			Matrix4x4.set_scale(from_quaternion_position, Vector3(max, max, max))

			vortex_data.inner_decal_unit = Managers.state.unit_spawner:spawn_network_unit(inner_decal_unit_name, "network_synched_dummy_unit", nil, from_quaternion_position)
		end

		local outer_decal_unit_name = action.outer_decal_unit_name

		if not outer_decal_unit_name then
			local from_quaternion_position_2 = Matrix4x4.from_quaternion_position(Quaternion.identity(), unbox)
			local max_2 = math.max(vortex_template.min_outer_radius, min * vortex_template.full_outer_radius)

			Matrix4x4.set_scale(from_quaternion_position_2, Vector3(max_2, max_2, max_2))

			vortex_data.outer_decal_unit = Managers.state.unit_spawner:spawn_network_unit(outer_decal_unit_name, "network_synched_dummy_unit", nil, from_quaternion_position_2)
		end
	end

	vortex_data.next_missile_cast_t = arg_7_3
	vortex_data.num_dummy_missiles = 0

	local physics_world = vortex_data.physics_world
	local num_2 = unbox + Vector3.up() * num
	local immediate_raycast, var_7_17, var_7_18, var_7_19, var_7_20 = PhysicsWorld.immediate_raycast(physics_world, num_2, Vector3.up(), max_height - num, "closest", "collision_filter", "filter_ai_mover")
	local num_3

	if not immediate_raycast then
		num_3 = num + var_7_18

		if not num_3 then
			-- Nothing
		end
	end

	num_3 = max_height

	::label_7_0::

	vortex_data.max_height = num_3

	local var_7_22 = POSITION_LOOKUP[arg_7_1]
	local num_4 = Vector3.distance(var_7_22, unbox) * action.extra_time_per_distance

	vortex_data.summoning_done_t = arg_7_3 + action.summoning_time + num_4
	vortex_data.extra_time = num_4

	if not arg_7_2.breed.boss then
		local target_unit = arg_7_2.target_unit

		Managers.state.entity:system("ai_bot_group_system"):ranged_attack_started(arg_7_1, target_unit, "chaos_vortex")
	end
end

BTChaosSorcererSummoningAction._clean_up_vortex_summoning = function (arg_8_0, arg_8_1, arg_8_2, arg_8_3)
	-- function 8
	local vortex_data = arg_8_2.vortex_data
	local unit_spawner = Managers.state.unit_spawner
	local inner_decal_unit = vortex_data.inner_decal_unit

	if not Unit.alive(inner_decal_unit) then
		unit_spawner:mark_for_deletion(inner_decal_unit)
	end

	local outer_decal_unit = vortex_data.outer_decal_unit

	if not Unit.alive(outer_decal_unit) then
		unit_spawner:mark_for_deletion(outer_decal_unit)
	end

	vortex_data.inner_decal_unit = nil
	vortex_data.outer_decal_unit = nil
	vortex_data.num_dummy_missiles = 0

	if not arg_8_2.breed.boss then
		local target_unit = arg_8_2.target_unit

		Managers.state.entity:system("ai_bot_group_system"):ranged_attack_ended(arg_8_1, target_unit, "chaos_vortex")
	end
end

BTChaosSorcererSummoningAction._update_vortex_summoning = function (self, arg_9_1, arg_9_2, arg_9_3, arg_9_4)
	-- function 9
	local vortex_data = arg_9_2.vortex_data
	local unbox = vortex_data.vortex_spawn_pos:unbox()
	local look_at_position_flat = LocomotionUtils.look_at_position_flat(arg_9_1, unbox)

	arg_9_2.locomotion_extension:set_wanted_rotation(look_at_position_flat)

	if not arg_9_2.attack_finished then
		return
	end

	local action = arg_9_2.action

	if not (not (vortex_data.num_dummy_missiles < action.num_missiles) or not (arg_9_3 > vortex_data.next_missile_cast_t)) then
		local num = unbox - POSITION_LOOKUP[arg_9_1]
		local normalize = Vector3.normalize(num)
		local node = Unit.node(arg_9_1, "j_lefthand")
		local world_position = Unit.world_position(arg_9_1, node)

		self:_launch_vortex_dummy_missile(arg_9_1, action, vortex_data, world_position, unbox, normalize)

		vortex_data.next_missile_cast_t = vortex_data.next_missile_cast_t + action.missile_cast_interval
	end

	if arg_9_3 > vortex_data.summoning_done_t then
		arg_9_2.summoning_finished = true
	end
end

BTChaosSorcererSummoningAction._launch_vortex_dummy_missile = function (arg_10_0, arg_10_1, arg_10_2, arg_10_3, arg_10_4, arg_10_5, arg_10_6)
	-- function 10
	local missile_launch_angle = arg_10_2.missile_launch_angle
	local missile_speed = arg_10_2.missile_speed
	local num_2 = arg_10_2.missile_life_time + arg_10_3.extra_time
	local str = "sorcerer_vortex_dummy_missile"
	local max = math.max(arg_10_3.max_height / 2, num + 0.5)
	local num_3 = num + (max - num) * math.random()

	arg_10_5 = arg_10_5 + Vector3.up() * num_3

	local tbl = {
		projectile_locomotion_system = {
			trajectory_template_name = "throw_trajectory",
			gravity_settings = "default",
			angle = missile_launch_angle,
			initial_position = arg_10_4,
			height_offset = num_3,
			life_time = num_2,
			owner_unit = arg_10_1,
			position_target = arg_10_5,
			speed = missile_speed,
			target_vector = arg_10_6,
			true_flight_template_name = str
		},
		projectile_system = {
			impact_template_name = "direct_impact",
			explosion_template_name = "chaos_vortex_dummy_missile",
			owner_unit = arg_10_1
		}
	}
	local look = Quaternion.look(arg_10_6)
	local missile_effect_unit_name = arg_10_2.missile_effect_unit_name
	local spawn_network_unit, var_10_10 = Managers.state.unit_spawner:spawn_network_unit(missile_effect_unit_name, "ai_true_flight_projectile_unit_without_raycast", tbl, arg_10_4, look)

	arg_10_3.num_dummy_missiles = arg_10_3.num_dummy_missiles + 1

	return spawn_network_unit, var_10_10
end

BTChaosSorcererSummoningAction._spawn_boss_vortex = function (self, arg_11_1, arg_11_2, arg_11_3, arg_11_4, arg_11_5)
	-- function 11
	local action = arg_11_2.action
	local vortex_template_name = action.vortex_template_name
	local var_11_2 = VortexTemplates[vortex_template_name]
	local boss_vortex_data = arg_11_2.boss_vortex_data
	local num = 6
	local var_11_5 = POSITION_LOOKUP[arg_11_1]

	boss_vortex_data.vortex_spawn_pos:store(var_11_5)

	boss_vortex_data.vortex_spawn_radius = num

	local min = math.min(num / var_11_2.full_inner_radius, 1)
	local inner_decal_unit_name = action.inner_decal_unit_name

	if not inner_decal_unit_name then
		local from_quaternion_position = Matrix4x4.from_quaternion_position(Quaternion.identity(), var_11_5)
		local max = math.max(var_11_2.min_inner_radius, min * var_11_2.full_inner_radius)

		Matrix4x4.set_scale(from_quaternion_position, Vector3(max, max, max))

		boss_vortex_data.inner_decal_unit = Managers.state.unit_spawner:spawn_network_unit(inner_decal_unit_name, "network_synched_dummy_unit", nil, from_quaternion_position)
	end

	local outer_decal_unit_name = action.outer_decal_unit_name

	if not outer_decal_unit_name then
		local from_quaternion_position_2 = Matrix4x4.from_quaternion_position(Quaternion.identity(), var_11_5)
		local max_2 = math.max(var_11_2.min_outer_radius, min * var_11_2.full_outer_radius)

		Matrix4x4.set_scale(from_quaternion_position_2, Vector3(max_2, max_2, max_2))

		boss_vortex_data.outer_decal_unit = Managers.state.unit_spawner:spawn_network_unit(outer_decal_unit_name, "network_synched_dummy_unit", nil, from_quaternion_position_2)
	end

	self:_spawn_vortex(arg_11_1, arg_11_2, arg_11_3, arg_11_4, arg_11_5, boss_vortex_data)
end

BTChaosSorcererSummoningAction._spawn_vortex = function (arg_12_0, arg_12_1, arg_12_2, arg_12_3, arg_12_4, arg_12_5, arg_12_6)
	-- function 12
	arg_12_6 = arg_12_6 or arg_12_2.vortex_data

	local action = arg_12_2.action
	local unbox = arg_12_6.vortex_spawn_pos:unbox()
	local vortex_template_name = arg_12_2.breed.vortex_template_name

	vortex_template_name = vortex_template_name or action.vortex_template_name

	local breed_name = VortexTemplates[vortex_template_name].breed_name
	local var_12_4 = Breeds[breed_name]
	local vortex_units = arg_12_6.vortex_units
	local queued_vortex = arg_12_6.queued_vortex
	local str = "vortex"
	local link_decal_units_to_vortex = action.link_decal_units_to_vortex
	local inner_decal_unit = arg_12_6.inner_decal_unit
	local outer_decal_unit = arg_12_6.outer_decal_unit
	local tbl = {
		prepare_func = function (arg_13_0, arg_13_1)
			-- function 13
			local tbl = {}
			local var_13_1 = vortex_template_name

			var_13_1 = var_13_1 or "standard"
			tbl.vortex_template_name = var_13_1

			local var_13_2 = link_decal_units_to_vortex

			var_13_2 = not var_13_2 and inner_decal_unit
			tbl.inner_decal_unit = var_13_2

			local var_13_3 = link_decal_units_to_vortex

			var_13_3 = not var_13_3 and outer_decal_unit
			tbl.outer_decal_unit = var_13_3
			tbl.owner_unit = arg_12_1
			arg_13_1.ai_supplementary_system = tbl
		end,
		spawned_func = function (arg_14_0, arg_14_1, arg_14_2)
			-- function 14
			local spawn_queue_index = arg_14_2.spawn_queue_index

			queued_vortex[spawn_queue_index] = nil
			vortex_units[#vortex_units + 1] = arg_14_0
			BLACKBOARDS[arg_14_0].master_unit = arg_12_1

			Managers.state.entity:system("surrounding_aware_system"):add_system_event(arg_14_0, "enemy_attack", DialogueSettings.see_vortex_distance, "attack_tag", "chaos_vortex_spawned")
		end
	}
	local spawn_queued_unit = Managers.state.conflict:spawn_queued_unit(var_12_4, Vector3Box(unbox), QuaternionBox(Quaternion.identity()), str, nil, nil, tbl)

	arg_12_6.queued_vortex[spawn_queued_unit] = {
		inner_decal_unit = not link_decal_units_to_vortex and inner_decal_unit,
		outer_decal_unit = not link_decal_units_to_vortex and outer_decal_unit
	}

	if not link_decal_units_to_vortex then
		arg_12_6.inner_decal_unit = nil
		arg_12_6.outer_decal_unit = nil
	end

	arg_12_2.attack_finished = true

	return true
end

BTChaosSorcererSummoningAction.spawn_portal = function (arg_15_0, arg_15_1, arg_15_2, arg_15_3, arg_15_4, arg_15_5, arg_15_6)
	-- function 15
	arg_15_6 = arg_15_6 or arg_15_2.portal_data

	local unbox = arg_15_6.portal_spawn_pos:unbox()
	local unbox_2 = arg_15_6.portal_spawn_rot:unbox()
	local portal_spawn_type = arg_15_6.portal_spawn_type
	local chaos_tentacle = Breeds.chaos_tentacle
	local inside_wall_spawn_distance = chaos_tentacle.inside_wall_spawn_distance
	local var_15_5

	if not inside_wall_spawn_distance then
		local forward = Quaternion.forward(unbox_2)

		var_15_5 = unbox - forward * inside_wall_spawn_distance

		QuickDrawerStay:line(var_15_5, var_15_5 + forward * 5, Colors.get("light_green"))
		QuickDrawerStay:sphere(var_15_5, 0.1, Colors.get("light_green"))
	end

	local tentacle_template_name = arg_15_2.action.tentacle_template_name

	tentacle_template_name = tentacle_template_name or "portal"

	local tbl = {
		prepare_func = function (arg_16_0, arg_16_1)
			-- function 16
			arg_16_1.ai_supplementary_system = {
				tentacle_template_name = tentacle_template_name
			}
		end,
		spawned_func = function (arg_17_0, arg_17_1, arg_17_2)
			-- function 17
			arg_17_2.sorcerer_blackboard.portal_unit = arg_17_0
		end,
		sorcerer_blackboard = arg_15_2
	}
	local str = "portal"

	if portal_spawn_type == "wall" then
		Managers.state.conflict:spawn_queued_unit(chaos_tentacle, Vector3Box(var_15_5), QuaternionBox(unbox_2), str, nil, nil, tbl)
	elseif portal_spawn_type == "floor" then
		Managers.state.conflict:spawn_queued_unit(chaos_tentacle, Vector3Box(var_15_5), QuaternionBox(unbox_2), str, nil, nil, tbl)
	end

	arg_15_2.portal_search_active = false
	arg_15_2.ready_to_summon = false

	return true
end

BTChaosSorcererSummoningAction.boss_sorcerer_spawn_tentacle_in_arena = function (arg_18_0, arg_18_1, arg_18_2, arg_18_3)
	-- function 18
	local chaos_tentacle = Breeds.chaos_tentacle
	local sorcerer_boss_wall = Managers.state.conflict.level_analysis.generic_ai_node_units.sorcerer_boss_wall
	local var_18_2 = sorcerer_boss_wall[math.random(1, #sorcerer_boss_wall)]
	local local_position = Unit.local_position(var_18_2, 0)
	local local_rotation = Unit.local_rotation(var_18_2, 0)
	local forward = Quaternion.forward(local_rotation)
	local inside_wall_spawn_distance = chaos_tentacle.inside_wall_spawn_distance
	local str = "portal"
	local num = local_position - forward * inside_wall_spawn_distance
	local tbl = {
		spawned_func = function (arg_19_0, arg_19_1, arg_19_2)
			-- function 19
			arg_18_2.tentacle_portal_units[arg_19_0] = true
			BLACKBOARDS[arg_19_0].boss_master_unit = arg_18_1
			arg_18_2.num_portals_alive = arg_18_2.num_portals_alive + 1
			arg_18_2.portal_unit = arg_19_0
		end
	}

	Managers.state.conflict:spawn_queued_unit(chaos_tentacle, Vector3Box(num), QuaternionBox(local_rotation), str, nil, nil, tbl)
end

BTChaosSorcererSummoningAction.init_boss_sorcerer_tentacle = function (arg_20_0, arg_20_1, arg_20_2, arg_20_3)
	-- function 20
	arg_20_2.summon_plague_wave_timer = arg_20_3 + 0.5
end

BTChaosSorcererSummoningAction.init_summon_plague_wave = function (arg_21_0, arg_21_1, arg_21_2, arg_21_3)
	-- function 21
	arg_21_2.summon_plague_wave_timer = arg_21_3 + 0.1

	if not arg_21_2.breed.boss then
		local target_unit = arg_21_2.target_unit

		Managers.state.entity:system("ai_bot_group_system"):ranged_attack_started(arg_21_1, target_unit, "plague_wave")
	end
end

BTChaosSorcererSummoningAction.init_summon_vermintide = function (arg_22_0, arg_22_1, arg_22_2, arg_22_3)
	-- function 22
	arg_22_2.summon_plague_wave_timer = arg_22_3 + 0.1
	arg_22_2.damage_wave_template_name = "vermintide"
end

BTChaosSorcererSummoningAction.update_summon_plague_wave = function (arg_23_0, arg_23_1, arg_23_2, arg_23_3, arg_23_4)
	-- function 23
	if arg_23_3 > arg_23_2.summon_plague_wave_timer then
		if not arg_23_2.summoning_unit then
			local templates = DamageWaveTemplates.templates
			local damage_wave_template_name = arg_23_2.damage_wave_template_name

			damage_wave_template_name = damage_wave_template_name or "plague_wave"

			local fx_unit = templates[damage_wave_template_name].fx_unit
			local tbl = {}
			local tbl_2 = {}
			local damage_wave_template_name_2 = arg_23_2.damage_wave_template_name

			damage_wave_template_name_2 = damage_wave_template_name_2 or "plague_wave"
			tbl_2.damage_wave_template_name = damage_wave_template_name_2
			tbl_2.source_unit = arg_23_1
			tbl.area_damage_system = tbl_2

			local var_23_6 = POSITION_LOOKUP[arg_23_1]
			local local_rotation = Unit.local_rotation(arg_23_1, 0)
			local spawn_network_unit = Managers.state.unit_spawner:spawn_network_unit(fx_unit, "damage_wave_unit", tbl, var_23_6, local_rotation)

			arg_23_2.summoning_unit = spawn_network_unit
			arg_23_2.damage_wave_extension = ScriptUnit.extension(spawn_network_unit, "area_damage_system")
		elseif not arg_23_2.summoning_unit then
			local summoning_unit = arg_23_2.summoning_unit
			local go_id = Managers.state.unit_storage:go_id(summoning_unit)
			local damage_wave_extension = arg_23_2.damage_wave_extension
			local source_unit = damage_wave_extension.source_unit
			local local_rotation_2 = Unit.local_rotation(source_unit, 0)

			Unit.set_local_rotation(summoning_unit, 0, local_rotation_2)

			local var_23_14 = POSITION_LOOKUP[summoning_unit]
			local num = POSITION_LOOKUP[source_unit] + Quaternion.forward(local_rotation_2) * 2
			local min = math.min(arg_23_4 * 2, 1)
			local lerp = Vector3.lerp(var_23_14, num, min)
			local triangle_from_position, var_23_19, var_23_20, var_23_21, var_23_22 = GwNavQueries.triangle_from_position(arg_23_2.nav_world, lerp, 1.5, 1.5)

			if not triangle_from_position then
				lerp = Vector3(lerp.x, lerp.y, var_23_19)
			end

			Unit.set_local_position(summoning_unit, 0, lerp)
			GameSession.set_game_object_field(damage_wave_extension.game, go_id, "rotation", local_rotation_2)
			GameSession.set_game_object_field(damage_wave_extension.game, go_id, "position", lerp)
		end
	end
end

BTChaosSorcererSummoningAction.spawn_plague_wave = function (arg_24_0, arg_24_1, arg_24_2, arg_24_3, arg_24_4, arg_24_5)
	-- function 24
	local plague_wave_data = arg_24_2.plague_wave_data
	local unbox = plague_wave_data.target_starting_pos:unbox()
	local var_24_2 = POSITION_LOOKUP[arg_24_1]
	local look = Quaternion.look(arg_24_5 - var_24_2)
	local target_dist = plague_wave_data.target_dist
	local nav_world = arg_24_2.nav_world
	local pos_on_mesh = LocomotionUtils.pos_on_mesh(nav_world, var_24_2, 1, 1)
	local pos_on_mesh_2 = LocomotionUtils.pos_on_mesh(nav_world, arg_24_5, 1, 1)
	local damage_wave_extension = arg_24_2.damage_wave_extension

	if not pos_on_mesh_2 then
		local inside_position_from_outside_position = GwNavQueries.inside_position_from_outside_position(nav_world, arg_24_5, 6, 6, 4, 0.5)

		if not inside_position_from_outside_position then
			pos_on_mesh_2 = inside_position_from_outside_position
		else
			arg_24_2.ready_to_summon = false

			damage_wave_extension:abort()

			return false
		end
	end

	if not pos_on_mesh then
		local inside_position_from_outside_position_2 = GwNavQueries.inside_position_from_outside_position(nav_world, var_24_2, 6, 6, 4, 0.5)

		if not inside_position_from_outside_position_2 then
			pos_on_mesh = inside_position_from_outside_position_2
		else
			arg_24_2.ready_to_summon = false

			damage_wave_extension:abort()

			return false
		end
	end

	local raycango = GwNavQueries.raycango(nav_world, pos_on_mesh, pos_on_mesh_2)
	local var_24_12

	if not raycango then
		var_24_12 = pos_on_mesh_2
	else
		local flag = false
		local num = 5
		local num_2 = unbox - arg_24_5
		local normalize = Vector3.normalize(num_2)
		local distance = Vector3.distance(arg_24_5, unbox)
		local num_3 = 2.5

		for i = 1, num do
			local num_4 = arg_24_5 + normalize * (num_3 * i)

			if not GwNavQueries.raycango(nav_world, pos_on_mesh, num_4) then
				flag = true
				var_24_12 = num_4

				local look_2 = Quaternion.look(num_4 - var_24_2)

				break
			end
		end

		if not flag then
			arg_24_2.ready_to_summon = false

			damage_wave_extension:abort()

			return false
		end
	end

	local action = arg_24_2.action

	if Vector3.distance_squared(var_24_12, arg_24_5) > action.max_wave_to_target_dist^2 then
		arg_24_2.ready_to_summon = false

		damage_wave_extension:abort()

		return false
	end

	damage_wave_extension:launch_wave(arg_24_2.summon_target_unit, var_24_12)

	return true
end

BTChaosSorcererSummoningAction.spawn_plague_wave_from_spawner = function (arg_25_0, arg_25_1, arg_25_2, arg_25_3, arg_25_4, arg_25_5)
	-- function 25
	local var_25_0 = POSITION_LOOKUP[arg_25_1]
	local nav_world = arg_25_2.nav_world
	local target_unit = arg_25_2.target_unit
	local pos_on_mesh = LocomotionUtils.pos_on_mesh(nav_world, var_25_0)

	if not pos_on_mesh then
		return false
	end

	local num = arg_25_5 - pos_on_mesh
	local look = Quaternion.look(num, Vector3.up())
	local str = "units/beings/enemies/chaos_sorcerer_fx/chr_chaos_sorcerer_fx"
	local tbl = {
		area_damage_system = {
			damage_wave_template_name = "plague_wave",
			source_unit = arg_25_1
		}
	}
	local spawn_network_unit = Managers.state.unit_spawner:spawn_network_unit(str, "damage_wave_unit", tbl, pos_on_mesh, look)

	ScriptUnit.extension(spawn_network_unit, "area_damage_system"):launch_wave(target_unit)

	arg_25_2.attack_finished = true

	return true
end

BTChaosSorcererSummoningAction.spawn_plague_waves_in_patterns = function (arg_26_0, arg_26_1, arg_26_2, arg_26_3, arg_26_4, arg_26_5)
	-- function 26
	local nav_world = arg_26_2.nav_world
	local action = arg_26_2.action
	local var_26_2
	local var_26_3

	if not action.spawner_set_id then
		var_26_2 = arg_26_2.spawners[action.spawner_set_id]
	else
		var_26_2 = {
			arg_26_1
		}
	end

	local flag = action.pattern_repetitions or 1
	local range = action.range

	range = range or 20

	for i = 1, flag do
		for j = 1, #var_26_2 do
			local var_26_6 = var_26_2[j]
			local local_position = Unit.local_position(var_26_6, 0)
			local pos_on_mesh = LocomotionUtils.pos_on_mesh(nav_world, local_position)

			if not pos_on_mesh then
				return false
			end

			local var_26_9
			local var_26_10

			if not action.spawn_rot_func then
				var_26_9 = action.spawn_rot_func(arg_26_1, arg_26_2, var_26_6, i)
			else
				var_26_9 = Unit.local_rotation(var_26_6, 0)
			end

			local forward = Quaternion.forward(var_26_9)
			local num = pos_on_mesh + forward * range

			if not action.goal_pos_func then
				num = action.goal_pos_func(arg_26_1, arg_26_2, var_26_6, i, pos_on_mesh, num, forward)
			end

			if not num then
				local str = "units/beings/enemies/chaos_sorcerer_fx/chr_chaos_sorcerer_fx"
				local tbl = {
					area_damage_system = {
						damage_wave_template_name = action.damage_wave_template,
						source_unit = arg_26_1
					}
				}
				local spawn_network_unit = Managers.state.unit_spawner:spawn_network_unit(str, "damage_wave_unit", tbl, pos_on_mesh, var_26_9)
				local extension = ScriptUnit.extension(spawn_network_unit, "area_damage_system")

				if not action.damage_wave_update_func then
					extension:set_update_func(action.damage_wave_update_func, action.damage_wave_init_func, arg_26_3)
				end

				local var_26_17

				extension:launch_wave(var_26_17, num)

				arg_26_2.attack_finished = true
			end
		end
	end

	return true
end

BTChaosSorcererSummoningAction.init_summon_plague_wave_sequence = function (arg_27_0, arg_27_1, arg_27_2, arg_27_3)
	-- function 27
	arg_27_2.summon_plague_wave_timer = arg_27_3 + 0.5
	arg_27_2.next_wave_time = 0
	arg_27_2.wave_counter = 0

	local sequence_init_func = arg_27_2.action.sequence_init_func

	if not sequence_init_func then
		sequence_init_func(arg_27_1, arg_27_2)
	end
end

BTChaosSorcererSummoningAction.update_sequenced_plague_wave_spawning = function (self, arg_28_1, arg_28_2, arg_28_3, arg_28_4)
	-- function 28
	local action = arg_28_2.action
	local var_28_1

	if arg_28_3 > arg_28_2.next_wave_time then
		arg_28_2.next_wave_time = arg_28_3 + action.duration_between_waves

		local var_28_2 = self[action.spawn_func_name](self, arg_28_1, arg_28_2, arg_28_3, arg_28_4, var_28_1)

		arg_28_2.wave_counter = arg_28_2.wave_counter + 1

		if arg_28_2.wave_counter > action.num_waves then
			return true
		end
	end
end

BTChaosSorcererSummoningAction.clean_up_plague_wave = function (arg_29_0, arg_29_1, arg_29_2, arg_29_3)
	-- function 29
	local target_unit = arg_29_2.target_unit

	Managers.state.entity:system("ai_bot_group_system"):ranged_attack_ended(arg_29_1, target_unit, "plague_wave")
end

local flag = false

BTChaosSorcererSummoningAction.init_boss_rings = function (arg_30_0, arg_30_1, arg_30_2, arg_30_3)
	-- function 30
	arg_30_2.summoning_finished = true
end

BTChaosSorcererSummoningAction.spawn_boss_rings = function (arg_31_0, arg_31_1, arg_31_2, arg_31_3)
	-- function 31
	local action = arg_31_2.action
	local extension = ScriptUnit.extension(arg_31_1, "dialogue_system")
	local wwise_world = Managers.world:wwise_world(arg_31_2.world)

	arg_31_2.audio_source_id = WwiseWorld.make_manual_source(wwise_world, arg_31_1, extension.voice_node)

	local start_ability_sound_event = action.start_ability_sound_event

	if not start_ability_sound_event then
		Managers.state.entity:system("audio_system"):_play_event_with_source(wwise_world, start_ability_sound_event, arg_31_2.audio_source_id)

		arg_31_2.summoning_start_event_playing = true
	end

	return true
end

BTChaosSorcererSummoningAction.update_boss_rings = function (arg_32_0, arg_32_1, arg_32_2, arg_32_3, arg_32_4)
	-- function 32
	local world = arg_32_2.world
	local action = arg_32_2.action
	local ring_sequence = action.ring_sequence
	local flag_2 = true
	local tbl = {
		Color(255, 0, 0),
		Color(255, 0, 0)
	}
	local num = 0.5

	for i, v in ipairs(ring_sequence) do
		if not v.done then
			local delay_time = v.delay_time

			if not delay_time then
				delay_time = v.delay + arg_32_3
				delay_time = delay_time or arg_32_3
			end

			v.delay_time = delay_time

			if not (not (arg_32_3 >= v.delay_time) or v.damage_effect_time) then
				if not (not flag and not (v.delay > 0)) then
					QuickDrawerStay:reset()
				end

				local premination = v.premination
				local ring_info = action.ring_info
				local unbox = Vector3Box.unbox(arg_32_2.ring_center_position)
				local position = v.position
				local max_radius = ring_info[position].max_radius
				local min_radius = ring_info[position].min_radius
				local flag_3

				flag_3 = (premination ~= "short" or not 1 or premination ~= "medium") and (not 2 or premination ~= "long" or not 3 or 0.75)

				local premonition_effect_name_short

				if premination == "short" then
					premonition_effect_name_short = ring_info[position].premonition_effect_name_short

					if not premonition_effect_name_short then
						-- Nothing
					end
				end

				if premination == "medium" then
					premonition_effect_name_short = ring_info[position].premonition_effect_name_medium

					if not premonition_effect_name_short then
						-- Nothing
					end
				end

				premonition_effect_name_short = premination ~= "long" or ring_info[position].premonition_effect_name_long

				::label_32_0::

				if not premonition_effect_name_short then
					Managers.state.network:rpc_play_particle_effect_no_rotation(nil, NetworkLookup.effects[premonition_effect_name_short], NetworkConstants.invalid_game_object_id, 0, unbox, false)
				end

				local var_32_15 = Vector3(max_radius, 0, 0)
				local var_32_16 = Vector3(min_radius, 0, 0)

				if not flag then
					for k = 1, 360 do
						var_32_15 = Quaternion.rotate(Quaternion.from_euler_angles_xyz(0, 0, 1), var_32_15)
						var_32_16 = Quaternion.rotate(Quaternion.from_euler_angles_xyz(0, 0, 1), var_32_16)

						QuickDrawerStay:line(unbox + var_32_15 + Vector3.up() * 0.6, unbox + var_32_16 + Vector3.up() * 0.1, tbl[i % 2 + 1])
					end
				end

				fassert(premination, "No or invalid premonition type")

				v.damage_effect_time = arg_32_3 + flag_3
				v.bot_avoid_time = v.damage_effect_time - num
			elseif not (not v.bot_avoid_time and not (arg_32_3 >= v.bot_avoid_time)) then
				v.bot_avoid_time = nil

				local position_2 = v.position
				local ring_info_2 = action.ring_info
				local unbox_2 = arg_32_2.ring_center_position:unbox()
				local min_radius_2 = ring_info_2[position_2].min_radius
				local max_radius_2 = ring_info_2[position_2].max_radius
				local var_32_22 = Vector3(min_radius_2, max_radius_2, 1)

				Managers.state.entity:system("ai_bot_group_system"):aoe_threat_created(unbox_2, "cylinder", var_32_22, Quaternion.identity(), num, "Chaos Sorcerer")
			elseif not (not v.damage_effect_time and not (arg_32_3 >= v.damage_effect_time) or v.premonition_time) then
				local ring_info_3 = action.ring_info
				local position_3 = v.position
				local unbox_3 = Vector3Box.unbox(arg_32_2.ring_center_position)
				local damage_effect_name = ring_info_3[position_3].damage_effect_name

				if not damage_effect_name then
					Managers.state.network:rpc_play_particle_effect_no_rotation(nil, NetworkLookup.effects[damage_effect_name], NetworkConstants.invalid_game_object_id, 0, unbox_3, false)
				end

				v.premonition_time = arg_32_3
			elseif not (not v.premonition_time and not (arg_32_3 >= v.premonition_time)) then
				local position_4 = v.position
				local ring_info_4 = action.ring_info
				local unbox_4 = Vector3Box.unbox(arg_32_2.ring_center_position)
				local min_radius_3 = ring_info_4[position_4].min_radius
				local max_radius_3 = ring_info_4[position_4].max_radius
				local system = Managers.state.entity:system("audio_system")

				system:play_audio_position_event(action.damage_sound_event, unbox_4)

				if not arg_32_2.summoning_start_event_playing then
					arg_32_2.summoning_start_event_playing = nil

					local wwise_world = Managers.world:wwise_world(arg_32_2.world)

					system:_play_event_with_source(wwise_world, action.end_ability_sound_event, arg_32_2.audio_source_id)
					WwiseWorld.destroy_manual_source(wwise_world, arg_32_2.audio_source_id)
				end

				local tbl_2 = {}
				local PLAYER_AND_BOT_UNITS = Managers.state.side:get_side_from_name("heroes").PLAYER_AND_BOT_UNITS
				local catapult_strength = v.catapult_strength

				AiUtils.broadphase_query(unbox_4, max_radius_3, tbl_2)

				local num_2 = min_radius_3 * min_radius_3
				local num_3 = max_radius_3 * max_radius_3

				for i_2, v_2 in ipairs(tbl_2) do
					local var_32_39 = POSITION_LOOKUP[v_2]

					if not (not (num_2 < Vector3.distance_squared(var_32_39, unbox_4)) or v_2 == arg_32_1) then
						local damage_profile_name = action.damage_profile_name
						local var_32_41 = DamageProfileTemplates[damage_profile_name]
						local get_difficulty = Managers.state.difficulty:get_difficulty()
						local var_32_43 = action.power_level[get_difficulty]
						local var_32_44
						local var_32_45
						local var_32_46
						local var_32_47
						local var_32_48
						local var_32_49
						local var_32_50
						local var_32_51 = arg_32_1

						DamageUtils.add_damage_network_player(var_32_41, nil, var_32_43, v_2, arg_32_1, "torso", POSITION_LOOKUP[v_2], Vector3.up(), "undefined", var_32_44, var_32_45, var_32_46, var_32_47, var_32_48, var_32_49, var_32_50, var_32_51)
					end
				end

				for i_3, v_3 in ipairs(PLAYER_AND_BOT_UNITS) do
					local var_32_52 = POSITION_LOOKUP[v_3]
					local distance_squared = Vector3.distance_squared(var_32_52, unbox_4)
					local num_4

					if v.catapult_direction == "in" then
						num_4 = unbox_4 - var_32_52

						if not num_4 then
							-- Nothing
						end
					end

					num_4 = var_32_52 - unbox_4

					::label_32_1::

					local normalize = Vector3.normalize(num_4)

					if not (not (distance_squared < num_3) or not (num_2 < distance_squared)) then
						local damage_profile_name_2 = action.damage_profile_name
						local var_32_57 = DamageProfileTemplates[damage_profile_name_2]
						local get_difficulty_2 = Managers.state.difficulty:get_difficulty()
						local owner = Managers.player:owner(v_3)
						local flag_4

						flag_4 = not (not owner and not owner:is_player_controlled()) and 0 and action.power_level[get_difficulty_2]

						DamageUtils.add_damage_network_player(var_32_57, nil, flag_4, v_3, arg_32_1, "torso", POSITION_LOOKUP[v_3], Vector3.up(), "undefined")

						if not catapult_strength then
							StatusUtils.set_catapulted_network(v_3, true, (normalize + Vector3.up()) * catapult_strength)
						end

						arg_32_2.hit_by_eruptions = true
					end
				end

				v.done = true
			else
				flag_2 = false

				break
			end

			if not v.done then
				flag_2 = false
			end
		end
	end

	if not flag_2 then
		return true
	end
end

BTChaosSorcererSummoningAction.clean_up_boss_rings = function (arg_33_0, arg_33_1, arg_33_2, arg_33_3)
	-- function 33
	for i, v in ipairs(arg_33_2.action.ring_sequence) do
		v.delay_time = nil
		v.premonition_time = nil
		v.damage_effect_time = nil
		v.done = nil
	end

	if not arg_33_2.summoning_start_event_playing then
		arg_33_2.summoning_start_event_playing = nil

		local system = Managers.state.entity:system("audio_system")
		local wwise_world = Managers.world:wwise_world(arg_33_2.world)

		system:_play_event_with_source(wwise_world, arg_33_2.action.end_ability_sound_event, arg_33_2.audio_source_id)
		WwiseWorld.destroy_manual_source(wwise_world, arg_33_2.audio_source_id)
	end
end
