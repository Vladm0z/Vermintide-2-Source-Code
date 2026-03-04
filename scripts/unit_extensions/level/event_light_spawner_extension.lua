-- chunkname: @scripts/unit_extensions/level/event_light_spawner_extension.lua

EventLightSpawnerExtension = class(EventLightSpawnerExtension)

local var_0_0 = 1

function EventLightSpawnerExtension.init(arg_1_0, arg_1_1, arg_1_2, arg_1_3)
	arg_1_0.world = arg_1_1.world
	arg_1_0.unit = arg_1_2
	arg_1_0.is_server = Managers.player.is_server
	arg_1_0.unit_spawner = Managers.state.unit_spawner
	arg_1_0._units = {}
	arg_1_0._spawn_pool = {}
	arg_1_0._spawn_pool_timer = 0
	arg_1_0._spawn_pool_spawn_index = 1
	arg_1_0._spawn_pool_add_index = 1
	arg_1_0._num_raycasts = 0
	arg_1_0._speed = arg_1_3.speed or Unit.get_data(arg_1_2, "speed") or 1
	arg_1_0._respawn_timer = arg_1_3.respawn_timer or Unit.get_data(arg_1_2, "respawn_timer") or 10
	arg_1_0._first_spawn_delay = arg_1_3.first_spawn_delay or Unit.get_data(arg_1_2, "first_spawn_delay") or 0
	arg_1_0._unit_to_spawn = arg_1_3.unit_to_spawn or Unit.get_data(arg_1_2, "unit_to_spawn")
	arg_1_0._light_intensity = Unit.get_data(arg_1_2, "light_intensity") or 1
	arg_1_0._active = false

	Unit.set_unit_visibility(arg_1_0.unit, false)

	if arg_1_0.is_server then
		for iter_1_0 = 1, 4 do
			local var_1_0 = {
				speed = arg_1_0._speed,
				id = iter_1_0,
				respawn_time = arg_1_0._respawn_timer - arg_1_0._first_spawn_delay
			}

			arg_1_0._units[iter_1_0] = var_1_0
		end
	end
end

function EventLightSpawnerExtension.update(arg_2_0, arg_2_1, arg_2_2, arg_2_3, arg_2_4, arg_2_5)
	if not arg_2_0.is_server then
		return
	end

	local var_2_0 = Unit.get_data(arg_2_1, "active")

	if not arg_2_0._active and var_2_0 then
		arg_2_0:_activate()
	elseif arg_2_0._active and not var_2_0 then
		arg_2_0:_deactivate()
	end

	if arg_2_0._active then
		local var_2_1 = arg_2_0._units
		local var_2_2 = Managers.state.side:get_side_from_name("heroes").PLAYER_AND_BOT_UNITS

		for iter_2_0, iter_2_1 in pairs(var_2_2) do
			local var_2_3 = var_2_1[iter_2_0]

			if not var_2_3.unit then
				var_2_3.respawn_time = var_2_3.respawn_time + arg_2_3

				local var_2_4 = var_2_3.chase_target

				if var_2_3.respawn_time >= arg_2_0._respawn_timer and var_2_4 and Unit.alive(var_2_4) then
					arg_2_0:_add_to_spawn_pool(var_2_3.id)

					var_2_3.respawn_time = 0
				end
			end
		end

		arg_2_0:_update_spawn_pool(arg_2_3)
		arg_2_0:_update_units(arg_2_4, arg_2_3)
	end
end

function EventLightSpawnerExtension._update_units(arg_3_0, arg_3_1, arg_3_2)
	local var_3_0 = arg_3_0._units

	for iter_3_0, iter_3_1 in pairs(var_3_0) do
		local var_3_1 = iter_3_1 and iter_3_1.unit
		local var_3_2 = iter_3_1.chase_target

		if not var_3_2 then
			arg_3_0:_sync_light_units()
		end

		if var_3_2 and Unit.alive(var_3_2) and var_3_1 and Unit.alive(var_3_1) then
			local var_3_3 = Unit.local_position(var_3_1, 0)
			local var_3_4 = var_3_2 and POSITION_LOOKUP[var_3_2] + Vector3.up()
			local var_3_5 = World.physics_world(arg_3_1.world)
			local var_3_6 = var_3_4 - var_3_3

			var_3_6 = Vector3.length(var_3_6) == 0 and Vector3.down() or Vector3.normalize(var_3_6)

			local var_3_7 = 1

			PhysicsWorld.prepare_actors_for_raycast(var_3_5, var_3_3, var_3_6, 0.1)

			local var_3_8 = PhysicsWorld.immediate_raycast(var_3_5, var_3_3, var_3_6, var_3_7, "all", "collision_filter", "filter_player_hit_box_and_static_check")

			if var_3_8 then
				local var_3_9 = #var_3_8

				for iter_3_2 = 1, var_3_9 do
					local var_3_10 = var_3_8[iter_3_2][4]
					local var_3_11 = Actor.unit(var_3_10)

					if not AiUtils.unit_breed(var_3_11) and iter_3_2 == var_3_9 then
						arg_3_0:_explode_spirit(var_3_1)

						iter_3_1.unit = nil
					elseif var_3_11 == var_3_2 then
						local var_3_12 = DamageProfileTemplates.warpfire_thrower_explosion
						local var_3_13 = 100
						local var_3_14 = var_3_3 - var_3_4
						local var_3_15 = Vector3.normalize(var_3_14)
						local var_3_16 = Managers.player:owner(var_3_2)

						if var_3_16 and var_3_16:is_player_controlled() then
							DamageUtils.add_damage_network_player(var_3_12, nil, var_3_13, var_3_2, var_3_1, "full", var_3_4, var_3_15, "undefined", nil, 0, false, nil, false, 0, 1)
						end

						arg_3_0:_explode_spirit(var_3_1)

						iter_3_1.unit = nil
					end
				end
			end
		end
	end

	for iter_3_3, iter_3_4 in pairs(var_3_0) do
		local var_3_17 = iter_3_4.unit

		if var_3_17 then
			local var_3_18 = Unit.local_position(var_3_17, 0)
			local var_3_19 = iter_3_4.chase_target

			if Unit.alive(var_3_19) then
				local var_3_20 = var_3_19 and POSITION_LOOKUP[var_3_19]
				local var_3_21 = Managers.player:owner(var_3_19)
				local var_3_22 = var_3_21 and var_3_21:is_player_controlled()

				if var_3_20 and var_3_22 then
					local var_3_23 = var_3_20 + Vector3(0, 0, 1) - var_3_18
					local var_3_24 = var_3_18 + Vector3.normalize(var_3_23) * (arg_3_2 * iter_3_4.speed)

					Unit.set_local_position(var_3_17, 0, var_3_24)
				elseif var_3_20 and not var_3_22 then
					local var_3_25 = var_3_20 + Vector3(0, 0, 1) - var_3_18
					local var_3_26 = Vector3.length(var_3_25)
					local var_3_27 = var_3_26 < 3 and math.max(0, var_3_26 - 2) or 1
					local var_3_28 = var_3_18 + Vector3.normalize(var_3_25) * (arg_3_2 * iter_3_4.speed) * var_3_27

					Unit.set_local_position(var_3_17, 0, var_3_28)
				end
			else
				iter_3_4.chase_target = nil

				arg_3_0:_explode_spirit(iter_3_4.unit)

				iter_3_4.unit = nil
			end
		end
	end
end

function EventLightSpawnerExtension._update_spawn_pool(arg_4_0, arg_4_1)
	local var_4_0 = arg_4_0._spawn_pool

	if var_4_0[arg_4_0._spawn_pool_spawn_index] then
		arg_4_0._spawn_pool_timer = arg_4_0._spawn_pool_timer + arg_4_1

		if arg_4_0._spawn_pool_timer > 1 then
			arg_4_0._spawn_pool_timer = arg_4_0._spawn_pool_timer - 1

			local var_4_1 = arg_4_0.unit_spawner:spawn_network_unit(arg_4_0._unit_to_spawn, "position_synched_light_unit", nil, Unit.local_position(arg_4_0.unit, 0))

			Managers.state.entity:system("audio_system"):play_audio_unit_event("Play_bastion_sorcerer_boss_magic_ball_spawn", var_4_1)

			local var_4_2 = var_4_0[arg_4_0._spawn_pool_spawn_index]

			arg_4_0._units[var_4_2].unit = var_4_1
			var_4_0[arg_4_0._spawn_pool_spawn_index] = nil
			arg_4_0._spawn_pool_spawn_index = arg_4_0._spawn_pool_spawn_index + 1
		end
	end
end

function EventLightSpawnerExtension._add_to_spawn_pool(arg_5_0, arg_5_1)
	arg_5_0._spawn_pool[arg_5_0._spawn_pool_add_index] = arg_5_1
	arg_5_0._spawn_pool_add_index = arg_5_0._spawn_pool_add_index + 1
end

function EventLightSpawnerExtension._activate(arg_6_0)
	arg_6_0._active = true

	local var_6_0 = Managers.state.side:get_side_from_name("heroes").PLAYER_AND_BOT_UNITS

	for iter_6_0, iter_6_1 in pairs(var_6_0) do
		arg_6_0._units[iter_6_0].chase_target = iter_6_1
	end
end

function EventLightSpawnerExtension._deactivate(arg_7_0)
	arg_7_0._active = false

	local var_7_0 = arg_7_0._units

	for iter_7_0 = 1, #var_7_0 do
		local var_7_1 = var_7_0[iter_7_0].unit

		if var_7_1 then
			arg_7_0:_explode_spirit(var_7_1)

			var_7_0[iter_7_0].chase_target = nil
			var_7_0[iter_7_0].unit = nil
		end
	end
end

function EventLightSpawnerExtension._explode_spirit(arg_8_0, arg_8_1)
	local var_8_0 = Unit.local_position(arg_8_1, 0)
	local var_8_1 = Unit.world_rotation(arg_8_1, 0)

	Managers.state.entity:system("area_damage_system"):create_explosion(arg_8_1, var_8_0, var_8_1, "bastion_light_spirit", 1, "undefined", 0, false)
	Managers.state.entity:system("audio_system"):play_audio_unit_event("Play_bastion_sorcerer_boss_magic_ball_explode", arg_8_1)
	Managers.state.unit_spawner:mark_for_deletion(arg_8_1)
end

function EventLightSpawnerExtension._sync_light_units(arg_9_0)
	if not arg_9_0.is_server then
		return
	end

	local var_9_0 = arg_9_0._units
	local var_9_1 = Managers.state.side:get_side_from_name("heroes").PLAYER_AND_BOT_UNITS

	for iter_9_0, iter_9_1 in ipairs(var_9_0) do
		if not iter_9_1.chase_target or not Unit.alive(iter_9_1.chase_target) then
			iter_9_1.chase_target = nil
		end
	end

	for iter_9_2, iter_9_3 in pairs(var_9_1) do
		local var_9_2
		local var_9_3

		for iter_9_4, iter_9_5 in ipairs(var_9_0) do
			if iter_9_5.chase_target then
				if iter_9_5.chase_target == iter_9_3 then
					var_9_3 = true

					break
				end
			else
				var_9_2 = var_9_2 or iter_9_5
			end
		end

		if not var_9_3 and var_9_2 then
			arg_9_0:_add_to_spawn_pool(var_9_2.id)

			var_9_2.chase_target = iter_9_3

			break
		end
	end
end
