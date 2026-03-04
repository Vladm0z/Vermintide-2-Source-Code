-- chunkname: @scripts/settings/dlcs/geheimnisnacht_2021/geheimnisnacht_2021_altar_extension.lua

Geheimnisnacht2021AltarExtension = class(Geheimnisnacht2021AltarExtension)

local var_0_0 = "fx/halloween_event_ambient"
local var_0_1 = "fx/halloween_event_final_explosion"
local var_0_2 = "units/decals/decal_halloween_2021"
local var_0_3 = 3
local var_0_4 = math.degrees_to_radians(78.5)
local var_0_5 = {
	-0.04,
	-0.1
}
local var_0_6 = 0
local var_0_7 = 1
local var_0_8 = 2
local var_0_9 = 3
local var_0_10 = "to_interactable"
local var_0_11 = "to_destructible"
local var_0_12 = "hit_start"
local var_0_13 = "hit_end"
local var_0_14 = GameSession.set_game_object_field
local var_0_15 = GameSession.game_object_field

Geheimnisnacht2021AltarExtension.init = function (arg_1_0, arg_1_1, arg_1_2, arg_1_3)
	arg_1_0._unit = arg_1_2
	arg_1_0._is_server = Managers.state.network.is_server
	arg_1_0.world = arg_1_1.world
	arg_1_0._state = arg_1_3.state or var_0_6
	arg_1_0._audio_system = Managers.state.entity:system("audio_system")
	arg_1_0._unit_spawner = Managers.state.unit_spawner

	arg_1_0:_init_state()
end

Geheimnisnacht2021AltarExtension.destroy = function (arg_2_0)
	arg_2_0:unregister_events()
end

Geheimnisnacht2021AltarExtension.assign_cultist_group_id = function (arg_3_0, arg_3_1)
	arg_3_0._cultist_group_id = arg_3_1
end

Geheimnisnacht2021AltarExtension.get_current_state = function (arg_4_0)
	return arg_4_0._state
end

Geheimnisnacht2021AltarExtension.can_interact = function (arg_5_0)
	return arg_5_0._state == var_0_8
end

Geheimnisnacht2021AltarExtension.on_interact = function (arg_6_0, arg_6_1, arg_6_2)
	if not arg_6_1 then
		Unit.animation_event(arg_6_0._unit, var_0_13)
	end

	if arg_6_1 and arg_6_2 then
		arg_6_0:change_state(var_0_9)
	end
end

Geheimnisnacht2021AltarExtension.on_interact_start = function (arg_7_0, arg_7_1)
	if not arg_7_1 then
		Unit.animation_event(arg_7_0._unit, var_0_12)
	end
end

Geheimnisnacht2021AltarExtension.update = function (arg_8_0, arg_8_1, arg_8_2, arg_8_3, arg_8_4, arg_8_5)
	local var_8_0 = Managers.state.network:game()
	local var_8_1 = arg_8_0._go_id or Managers.state.unit_storage:go_id(arg_8_1)

	if var_8_0 and var_8_1 then
		if arg_8_0._is_server then
			var_0_14(var_8_0, var_8_1, "state", arg_8_0._state)
		else
			local var_8_2 = var_0_15(var_8_0, var_8_1, "state")

			arg_8_0:change_state(var_8_2)
		end

		arg_8_0._go_id = var_8_1
	end

	if not arg_8_0._check_time then
		arg_8_0._check_time = 0
	end

	if not arg_8_0._hero_close and arg_8_5 > arg_8_0._check_time then
		local var_8_3 = FrameTable.alloc_table()
		local var_8_4 = Managers.state.entity:system("proximity_system").player_units_broadphase

		Broadphase.query(var_8_4, POSITION_LOOKUP[arg_8_1], 35, var_8_3)

		for iter_8_0, iter_8_1 in pairs(var_8_3) do
			local var_8_5 = Managers.player:owner(iter_8_1)

			if not (var_8_5 and not var_8_5:is_player_controlled()) then
				arg_8_0:play_relevant_faction_sound()
				arg_8_0:set_ritual_sound(true)

				arg_8_0._hero_close = true

				if not arg_8_0.nurglings_spawned and arg_8_0._is_server then
					arg_8_0:spawn_nurglings()
				end
			end
		end

		arg_8_0._check_time = arg_8_5 + 1
	end
end

Geheimnisnacht2021AltarExtension.die = function (arg_9_0)
	if arg_9_0._is_server then
		local var_9_0 = Unit.node(arg_9_0._unit, "j_skull_anim")
		local var_9_1 = Unit.world_position(arg_9_0._unit, var_9_0)

		Managers.state.entity:system("pickup_system"):buff_spawn_pickup("geheimnisnacht_2021_side_objective", var_9_1, true)
	end

	Managers.state.achievement:trigger_event("altar_destroyed")
	Unit.flow_event(arg_9_0._unit, "lua_dead")
	World.create_particles(arg_9_0.world, var_0_1, POSITION_LOOKUP[arg_9_0._unit] + Vector3.up())

	if arg_9_0._ambient_vfx then
		World.destroy_particles(arg_9_0.world, arg_9_0._ambient_vfx)

		arg_9_0._ambient_vfx = nil
	end

	arg_9_0:set_ritual_sound(false)
	arg_9_0:unregister_events()
end

Geheimnisnacht2021AltarExtension.register_events = function (arg_10_0)
	local var_10_0 = Managers.state.event

	if var_10_0 then
		arg_10_0._registered_events = true

		var_10_0:register(arg_10_0, "geheimnisnacht_2021_altar_cultists_killed", "on_cultists_killed")
		var_10_0:register(arg_10_0, "geheimnisnacht_2021_altar_cultists_aggroed", "on_cultists_aggroed")

		if arg_10_0._is_server then
			var_10_0:register(arg_10_0, "nurgling_killed", "nurglings_flee")
		end
	end
end

Geheimnisnacht2021AltarExtension.unregister_events = function (arg_11_0)
	local var_11_0 = Managers.state.event

	if var_11_0 and arg_11_0._registered_events then
		arg_11_0._registered_events = nil

		var_11_0:unregister("geheimnisnacht_2021_altar_cultists_killed", arg_11_0)
		var_11_0:unregister("geheimnisnacht_2021_altar_cultists_aggroed", arg_11_0)

		if arg_11_0._is_server then
			var_11_0:unregister("nurgling_killed", arg_11_0)
		end
	end
end

Geheimnisnacht2021AltarExtension.on_cultists_killed = function (arg_12_0, arg_12_1)
	if arg_12_1 == arg_12_0._cultist_group_id then
		arg_12_0:change_state(var_0_8)
		arg_12_0:stop_relevant_faction_sound()
	end
end

Geheimnisnacht2021AltarExtension.on_cultists_aggroed = function (arg_13_0, arg_13_1)
	if arg_13_1 == arg_13_0._cultist_group_id then
		arg_13_0:stop_relevant_faction_sound()
		arg_13_0:change_state(var_0_7)
		arg_13_0:nurglings_flee()
	end
end

Geheimnisnacht2021AltarExtension.stop_relevant_faction_sound = function (arg_14_0)
	local var_14_0 = arg_14_0._faction

	if var_14_0 then
		local var_14_1 = arg_14_0._audio_system
		local var_14_2 = arg_14_0._unit

		if not ALIVE[var_14_2] then
			return
		end

		if var_14_0 == "chaos" then
			var_14_1:play_audio_unit_event("enemy_marauder_halloween_ritual_loop_stop", var_14_2)
		else
			var_14_1:play_audio_unit_event("enemy_skaven_halloween_ritual_loop_stop", var_14_2)
		end
	end
end

Geheimnisnacht2021AltarExtension.play_relevant_faction_sound = function (arg_15_0)
	local var_15_0 = arg_15_0._faction

	if var_15_0 then
		local var_15_1 = arg_15_0._unit

		if not ALIVE[var_15_1] then
			return
		end

		local var_15_2 = arg_15_0._audio_system

		if var_15_0 == "chaos" then
			var_15_2:play_audio_unit_event("enemy_marauder_halloween_ritual_loop", var_15_1)
		else
			var_15_2:play_audio_unit_event("enemy_skaven_halloween_ritual_loop", var_15_1)
		end
	end
end

Geheimnisnacht2021AltarExtension.set_ritual_sound = function (arg_16_0, arg_16_1)
	local var_16_0 = arg_16_0._audio_system
	local var_16_1 = arg_16_0._unit

	if arg_16_1 then
		var_16_0:play_audio_unit_event("halloween_event_ritual_loop", var_16_1)
	else
		var_16_0:play_audio_unit_event("halloween_event_ritual_loop_stop", var_16_1)
	end
end

Geheimnisnacht2021AltarExtension.setup_faction = function (arg_17_0, arg_17_1)
	if arg_17_1 then
		arg_17_0._faction = arg_17_1
	end
end

Geheimnisnacht2021AltarExtension.change_state = function (arg_18_0, arg_18_1)
	local var_18_0 = arg_18_0._state

	if var_18_0 < arg_18_1 then
		for iter_18_0 = var_18_0 + 1, arg_18_1 do
			arg_18_0:_increment_state(iter_18_0)
		end

		arg_18_0._state = arg_18_1
	end
end

Geheimnisnacht2021AltarExtension._init_state = function (arg_19_0)
	local var_19_0 = arg_19_0.world
	local var_19_1 = arg_19_0._unit

	arg_19_0._health_extension = ScriptUnit.extension(var_19_1, "health_system")
	arg_19_0._health_extension.is_invincible = true

	if arg_19_0._state == var_0_6 then
		arg_19_0:register_events()
	end

	if arg_19_0._state ~= var_0_9 then
		local var_19_2 = Unit.world_position(var_19_1, 0)
		local var_19_3 = Unit.world_rotation(var_19_1, 0)

		arg_19_0._ambient_vfx = World.create_particles(var_19_0, var_0_0, var_19_2, var_19_3)

		World.link_particles(var_19_0, arg_19_0._ambient_vfx, var_19_1, 0, Matrix4x4.identity(), "stop")

		if var_0_2 then
			arg_19_0._decal_unit = arg_19_0._unit_spawner:spawn_local_unit(var_0_2)

			Unit.set_local_position(arg_19_0._decal_unit, 0, var_19_2 + Vector3(var_0_5[1], var_0_5[2], 0))
			Unit.set_local_rotation(arg_19_0._decal_unit, 0, Quaternion.multiply(var_19_3, Quaternion(Vector3.up(), var_0_4)))
			Unit.set_local_scale(arg_19_0._decal_unit, 0, Vector3(var_0_3, var_0_3, 2))
		end
	end
end

Geheimnisnacht2021AltarExtension._increment_state = function (arg_20_0, arg_20_1)
	if arg_20_1 == var_0_7 then
		arg_20_0:_mark_aggroed()
	elseif arg_20_1 == var_0_8 then
		arg_20_0:_mark_interactable()
	elseif arg_20_1 == var_0_9 then
		arg_20_0:_mark_destructible()
	end
end

Geheimnisnacht2021AltarExtension._mark_aggroed = function (arg_21_0)
	Unit.animation_event(arg_21_0._unit, var_0_10)
end

Geheimnisnacht2021AltarExtension._mark_interactable = function (arg_22_0)
	arg_22_0:unregister_events()
	Unit.animation_event(arg_22_0._unit, var_0_11)
end

Geheimnisnacht2021AltarExtension._mark_destructible = function (arg_23_0)
	if arg_23_0._decal_unit then
		Unit.flow_event(arg_23_0._decal_unit, "despawn")

		arg_23_0._decal_unit = nil
	end

	arg_23_0:die()
end

Geheimnisnacht2021AltarExtension.nurglings_flee = function (arg_24_0)
	local var_24_0 = Managers.state.entity:system("ai_group_system"):get_ai_group(arg_24_0.nurgling_group_id)

	if var_24_0 then
		AIGroupTemplates.critter_nurglings.wake_up_group(var_24_0)
	end
end

Geheimnisnacht2021AltarExtension.spawn_nurglings = function (arg_25_0)
	if arg_25_0.nurglings_spawned then
		return
	end

	local var_25_0 = arg_25_0._unit
	local var_25_1 = Unit.local_position(var_25_0, 0)
	local var_25_2 = Vector3Box(var_25_1)

	arg_25_0.nurgling_group_id = Managers.state.entity:system("ai_group_system"):generate_group_id()

	local var_25_3 = {
		spawned_func = function (arg_26_0, arg_26_1, arg_26_2)
			local var_26_0 = BLACKBOARDS[arg_26_0]

			ScriptUnit.extension(arg_26_0, "ai_system"):set_perception("perception_regular", "pick_no_targets")

			if var_26_0 then
				var_26_0.altar_pos = var_25_2
				var_26_0.is_fleeing = false
				var_26_0.nurgling_spawned_by_altar = true
			end
		end
	}
	local var_25_4 = 15
	local var_25_5 = 20
	local var_25_6 = math.random(var_25_4, var_25_5)
	local var_25_7 = 1
	local var_25_8 = 1
	local var_25_9 = 15
	local var_25_10 = {
		template = "critter_nurglings",
		id = arg_25_0.nurgling_group_id,
		size = var_25_6
	}
	local var_25_11 = Quaternion.identity()
	local var_25_12 = "critter_nurgling"
	local var_25_13 = "event"
	local var_25_14 = "event"
	local var_25_15
	local var_25_16 = Breeds[var_25_12]
	local var_25_17 = Managers.state.conflict
	local var_25_18 = Managers.state.entity:system("ai_system"):nav_world()

	for iter_25_0 = 1, var_25_6 do
		local var_25_19 = ConflictUtils.get_spawn_pos_on_circle(var_25_18, var_25_1, var_25_7, var_25_8, var_25_9)

		if var_25_19 then
			var_25_17:spawn_queued_unit(var_25_16, Vector3Box(var_25_19), QuaternionBox(var_25_11), var_25_13, var_25_15, var_25_14, var_25_3, var_25_10)
		end
	end

	arg_25_0.nurglings_spawned = true
end
