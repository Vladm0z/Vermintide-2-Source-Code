-- chunkname: @scripts/settings/dlcs/woods/thornsister_wall_extension.lua

ThornSisterWallExtension = class(ThornSisterWallExtension)

local var_0_0 = 1

function ThornSisterWallExtension.init(arg_1_0, arg_1_1, arg_1_2, arg_1_3)
	arg_1_0._is_server = Managers.state.network.is_server
	arg_1_0._unit = arg_1_2
	arg_1_0._life_time = arg_1_3.life_time
	arg_1_0._owner_peer = arg_1_3.owner
	arg_1_0._owner_unit = arg_1_3.owner_unit
	arg_1_0._despawn_sound_event = arg_1_3.despawn_sound_event
	arg_1_0.wall_index = arg_1_3.wall_index
	arg_1_0.group_spawn_index = arg_1_3.group_spawn_index
	arg_1_0._despawning = false
	arg_1_0._initialized = false
	arg_1_0.world = arg_1_1.world
	arg_1_0._area_damage_extension = ScriptUnit.extension(arg_1_0._unit, "area_damage_system")

	local var_1_0 = ScriptUnit.has_extension(arg_1_0._owner_unit, "talent_system")

	if var_1_0 and var_1_0:has_talent("kerillian_thorn_sister_debuff_wall") then
		arg_1_0._is_explosive_wall = true

		local var_1_1 = ScriptUnit.has_extension(arg_1_0._owner_unit, "career_system")

		arg_1_0._owner_career_power_level = var_1_1 and var_1_1:get_career_power_level() or 100
	end

	local var_1_2 = Managers.state.side
	local var_1_3 = (var_1_2.side_by_unit[arg_1_0._owner_unit] or Managers.state.side:get_side_from_name("heroes")).side_id

	var_1_2:add_unit_to_side(arg_1_2, var_1_3)

	if Managers.mechanism:current_mechanism_name() == "versus" then
		local var_1_4 = 1.25
		local var_1_5, var_1_6 = Unit.box(arg_1_2, false)

		arg_1_0._player_boss_trample_radius = (var_1_6[1] > var_1_6[2] and var_1_6[1] or var_1_6[2]) * var_1_4
	end
end

function ThornSisterWallExtension.game_object_initialized(arg_2_0)
	Managers.state.event:trigger("sister_wall_spawned", arg_2_0._unit)
end

function ThornSisterWallExtension.update(arg_3_0, arg_3_1, arg_3_2, arg_3_3, arg_3_4, arg_3_5)
	if not arg_3_0._initialized then
		local var_3_0 = arg_3_0._life_time

		arg_3_0._despawn_t = arg_3_5 + var_3_0
		arg_3_0._despawn_anim_start_t = arg_3_5 + math.max(var_3_0 - var_0_0, 0)
		arg_3_0._initialized = true

		arg_3_0:trigger_area_damage()
	end

	arg_3_0:_update_local_player_pactsworn_collision()
	arg_3_0:_check_player_boss_trample()

	if not arg_3_0._despawning and arg_3_5 >= arg_3_0._despawn_anim_start_t then
		arg_3_0:despawn()
	end

	if arg_3_0._is_server and arg_3_5 >= arg_3_0._despawn_t then
		Managers.state.side:remove_unit_from_side(arg_3_0._unit)
		Managers.state.unit_spawner:mark_for_deletion(arg_3_0._unit)
	end
end

function ThornSisterWallExtension.trigger_area_damage(arg_4_0)
	arg_4_0._area_damage_extension:enable_area_damage(true)

	if arg_4_0._is_server then
		local var_4_0 = Managers.state.network
		local var_4_1 = var_4_0:unit_game_object_id(arg_4_0._unit)

		var_4_0.network_transmit:send_rpc_clients("rpc_thorn_bush_trigger_area_damage", var_4_1)
	end
end

local var_0_1 = {}

function ThornSisterWallExtension._despawn_single(arg_5_0, arg_5_1, arg_5_2)
	if arg_5_0._despawning then
		return
	end

	Managers.state.entity:system("death_system"):kill_unit(arg_5_0._unit, var_0_1)

	if arg_5_0._versus_blocker_unit then
		World.destroy_unit(arg_5_0.world, arg_5_0._versus_blocker_unit)

		arg_5_0._versus_blocker_unit = nil
	end

	if arg_5_0._is_server then
		arg_5_0._area_damage_extension:enable_area_damage(false)
	end

	Unit.flow_event(arg_5_0._unit, "despawn")

	arg_5_0._despawning = true

	if arg_5_0._is_server and arg_5_0._despawn_sound_event and not arg_5_1 then
		arg_5_0:_trigger_despawn_sound(arg_5_2)
	end

	arg_5_0._despawn_t = math.min(arg_5_0._despawn_t or math.huge, Managers.time:time("game") + var_0_0)
end

function ThornSisterWallExtension._trigger_despawn_sound(arg_6_0, arg_6_1)
	local var_6_0 = arg_6_0._owner_unit
	local var_6_1 = POSITION_LOOKUP[arg_6_0._unit]

	if arg_6_1 then
		local var_6_2 = 1
		local var_6_3 = Managers.state.entity:get_entities("ThornSisterWallExtension")

		if var_6_3 then
			local var_6_4 = arg_6_0.wall_index

			for iter_6_0, iter_6_1 in pairs(var_6_3) do
				if iter_6_0 ~= arg_6_0._unit and iter_6_1.wall_index == var_6_4 and iter_6_1._owner_unit == var_6_0 then
					var_6_1 = var_6_1 + POSITION_LOOKUP[arg_6_0._unit]
					var_6_2 = var_6_2 + 1
				end
			end
		end

		var_6_1 = var_6_1 / var_6_2
	end

	Managers.state.entity:system("audio_system"):play_audio_position_event(arg_6_0._despawn_sound_event, var_6_1)
end

function ThornSisterWallExtension.despawn(arg_7_0, arg_7_1)
	local var_7_0 = arg_7_0._owner_unit
	local var_7_1 = false
	local var_7_2 = not arg_7_1

	arg_7_0:_despawn_single(var_7_1, var_7_2)

	if arg_7_1 then
		return
	end

	local var_7_3 = Managers.state.entity:get_entities("ThornSisterWallExtension")

	if var_7_3 then
		local var_7_4 = true
		local var_7_5
		local var_7_6 = arg_7_0.wall_index

		for iter_7_0, iter_7_1 in pairs(var_7_3) do
			if iter_7_0 ~= arg_7_0._unit and iter_7_1.wall_index == var_7_6 and iter_7_1._owner_unit == var_7_0 then
				iter_7_1:_despawn_single(var_7_4, var_7_5)
			end
		end
	end
end

function ThornSisterWallExtension.die(arg_8_0)
	if not arg_8_0._despawning then
		arg_8_0:despawn()

		arg_8_0._despawn_t = Managers.time:time("game") + var_0_0
	end
end

function ThornSisterWallExtension.owner(arg_9_0)
	return arg_9_0._owner_unit
end

function ThornSisterWallExtension._update_local_player_pactsworn_collision(arg_10_0)
	if not (Managers.mechanism:current_mechanism_name() == "versus") then
		return
	end

	local var_10_0 = Managers.player:local_player()
	local var_10_1 = var_10_0 and var_10_0.player_unit

	if not var_10_1 then
		return
	end

	local var_10_2 = ScriptUnit.has_extension(var_10_1, "ghost_mode_system")

	if not var_10_2 then
		return
	end

	if arg_10_0._despawning then
		return
	end

	local var_10_3 = var_10_2:is_in_ghost_mode()
	local var_10_4 = arg_10_0._local_player_in_ghost_mode ~= var_10_3

	arg_10_0._local_player_in_ghost_mode = var_10_3

	if var_10_4 then
		if var_10_3 then
			if arg_10_0._versus_blocker_unit then
				World.destroy_unit(arg_10_0.world, arg_10_0._versus_blocker_unit)

				arg_10_0._versus_blocker_unit = nil
			end
		else
			local var_10_5 = arg_10_0._unit
			local var_10_6 = Unit.local_position(var_10_5, 0)
			local var_10_7 = Unit.local_rotation(var_10_5, 0)

			arg_10_0._versus_blocker_unit = World.spawn_unit(arg_10_0.world, "units/beings/player/way_watcher_thornsister/abilities/ww_thornsister_thorn_wall_01", var_10_6, var_10_7)

			Unit.set_unit_visibility(arg_10_0._versus_blocker_unit, false)

			local var_10_8 = Unit.actor(arg_10_0._versus_blocker_unit, "c_simple")

			Actor.set_collision_filter(var_10_8, "filter_mover_blocker_pactsworn")
		end
	end
end

function ThornSisterWallExtension._check_player_boss_trample(arg_11_0)
	local var_11_0 = arg_11_0._player_boss_trample_radius

	if not var_11_0 or arg_11_0._despawning then
		return
	end

	local var_11_1 = Unit.local_position(arg_11_0._unit, 0)
	local var_11_2 = Managers.state.side.side_by_unit[arg_11_0._unit].ENEMY_PLAYER_AND_BOT_UNITS

	for iter_11_0, iter_11_1 in pairs(var_11_2) do
		if Unit.get_data(iter_11_1, "breed").boss then
			local var_11_3 = ScriptUnit.extension(iter_11_1, "ghost_mode_system")

			if var_11_3 and not var_11_3:is_in_ghost_mode() then
				local var_11_4 = Unit.mover(iter_11_1)

				if var_11_4 then
					local var_11_5 = Mover.radius(var_11_4)
					local var_11_6 = POSITION_LOOKUP[iter_11_1]
					local var_11_7 = var_11_5 + var_11_0

					if Vector3.distance_squared(var_11_1, var_11_6) < var_11_7 * var_11_7 then
						local var_11_8 = true

						arg_11_0:despawn(var_11_8)

						break
					end
				end
			end
		end
	end
end

function ThornSisterWallExtension.move_prop(arg_12_0, arg_12_1)
	local var_12_0 = Matrix4x4.translation(arg_12_1)
	local var_12_1 = Matrix4x4.rotation(arg_12_1)

	Unit.set_local_position(arg_12_0._unit, 0, var_12_0)
	Unit.set_local_rotation(arg_12_0._unit, 0, var_12_1)

	if arg_12_0._versus_blocker_unit then
		Unit.set_local_position(arg_12_0._versus_blocker_unit, 0, var_12_0)
		Unit.set_local_rotation(arg_12_0._versus_blocker_unit, 0, var_12_1)
	end
end
