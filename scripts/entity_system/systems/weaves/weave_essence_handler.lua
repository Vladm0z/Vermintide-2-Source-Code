-- chunkname: @scripts/entity_system/systems/weaves/weave_essence_handler.lua

WeaveEssenceHandler = class(WeaveEssenceHandler)

function WeaveEssenceHandler.init(arg_1_0, arg_1_1)
	arg_1_0._world = arg_1_1
	arg_1_0._spawn_essence_units = true
	arg_1_0._essence_unit_names = {
		"units/fx/essence_unit",
		"units/fx/essence_unit"
	}
	arg_1_0._essence_sound_events = {
		"Play_hud_wind_collect_essence",
		"Play_hud_wind_collect_essence_chunk"
	}
	arg_1_0._essence_unit_data = {}

	for iter_1_0 = 1, 20 do
		arg_1_0._essence_unit_data[iter_1_0] = {}
	end

	arg_1_0._essence_life_time = 3
end

function WeaveEssenceHandler.on_objectives_activated(arg_2_0, arg_2_1)
	if not table.is_empty(arg_2_1) then
		Managers.state.entity:system("audio_system"):play_2d_audio_event("Play_hud_wind_objective_start")
	end
end

function WeaveEssenceHandler.update(arg_3_0, arg_3_1, arg_3_2)
	arg_3_0:_collect_dropped_essence(arg_3_1)
end

function WeaveEssenceHandler.destroy_all_essence(arg_4_0)
	local var_4_0 = arg_4_0._essence_unit_data

	for iter_4_0 = 1, #var_4_0 do
		local var_4_1 = var_4_0[iter_4_0]
		local var_4_2 = var_4_1.unit

		if Unit.alive(var_4_2) then
			Managers.state.unit_spawner:mark_for_deletion(var_4_2)
			table.clear(var_4_1)
		end
	end
end

function WeaveEssenceHandler.on_ai_killed(arg_5_0, arg_5_1, arg_5_2, arg_5_3, arg_5_4)
	if not arg_5_3 or not arg_5_3.despawned then
		local var_5_0 = POSITION_LOOKUP[arg_5_1]

		arg_5_0:spawn_essence_unit(var_5_0 + Vector3(0, 0, 0.2))
	end
end

function WeaveEssenceHandler.spawn_essence_unit(arg_6_0, arg_6_1, arg_6_2)
	local var_6_0 = arg_6_0._essence_unit_data
	local var_6_1

	for iter_6_0 = 1, #var_6_0 do
		local var_6_2 = var_6_0[iter_6_0].unit

		if not Unit.alive(var_6_2) then
			var_6_1 = iter_6_0

			break
		end
	end

	if not arg_6_0._spawn_essence_units or not var_6_1 then
		return
	end

	local var_6_3 = arg_6_0._essence_unit_names[arg_6_2 or 1]
	local var_6_4

	var_6_4.unit, var_6_4 = Managers.state.unit_spawner:spawn_local_unit(var_6_3, arg_6_1, Quaternion.identity()), arg_6_0._essence_unit_data[var_6_1]
	var_6_4.life_time = arg_6_0._essence_life_time
	var_6_4.spawn_pos = Vector3Box(arg_6_1)
	var_6_4.right_vector_multiplier = 1 - math.random() * 2
	var_6_4.forward_vector_multiplier = 1 - math.random() * 2
	var_6_4.sound_event = arg_6_0._essence_sound_events[arg_6_2 or 1]
end

function WeaveEssenceHandler._collect_dropped_essence(arg_7_0, arg_7_1)
	local var_7_0 = Managers.player:local_player()

	if not var_7_0 or not var_7_0.player_unit then
		return
	end

	local var_7_1 = var_7_0.player_unit
	local var_7_2 = Managers.state.unit_spawner
	local var_7_3 = POSITION_LOOKUP[var_7_1] + Vector3(0, 0, 0.5)
	local var_7_4 = Vector3.up()
	local var_7_5 = Vector3.right()
	local var_7_6 = Vector3.forward()
	local var_7_7 = 0
	local var_7_8 = 0.8
	local var_7_9 = arg_7_0._essence_unit_data
	local var_7_10 = Unit.alive

	for iter_7_0 = 1, #var_7_9 do
		local var_7_11 = var_7_9[iter_7_0]
		local var_7_12 = var_7_11.unit

		if var_7_10(var_7_12) then
			local var_7_13 = POSITION_LOOKUP[var_7_12]
			local var_7_14 = Vector3.distance(var_7_13, var_7_3)
			local var_7_15 = var_7_11.life_time - arg_7_1

			if var_7_15 <= 0 or var_7_14 <= 1 then
				var_7_2:mark_for_deletion(var_7_12)

				if var_7_11.sound_event then
					local var_7_16 = Managers.world:wwise_world(arg_7_0._world)

					WwiseWorld.trigger_event(var_7_16, var_7_11.sound_event)
				end

				table.clear(var_7_11)
			else
				if var_7_15 <= var_7_8 then
					local var_7_17 = var_7_13 + Vector3.normalize(var_7_3 - var_7_13) * arg_7_1 * math.max(30, var_7_14 / (var_7_8 / 2))

					Unit.set_local_position(var_7_12, 0, var_7_17)
				elseif var_7_15 >= var_7_8 + var_7_7 then
					local var_7_18 = (var_7_15 - var_7_8 - var_7_7) / (arg_7_0._essence_life_time - var_7_8 - var_7_7)
					local var_7_19 = 1 - math.easeInCubic(var_7_18)
					local var_7_20 = var_7_11.spawn_pos:unbox()
					local var_7_21 = var_7_4 * 2 * var_7_19
					local var_7_22 = var_7_5 * var_7_11.right_vector_multiplier * (1 - var_7_18)
					local var_7_23 = var_7_6 * var_7_11.forward_vector_multiplier * (1 - var_7_18)
					local var_7_24 = var_7_20 + (var_7_21 + var_7_22 + var_7_23)

					Unit.set_local_position(var_7_12, 0, var_7_24)
				end

				var_7_11.life_time = var_7_15
			end
		end
	end
end
