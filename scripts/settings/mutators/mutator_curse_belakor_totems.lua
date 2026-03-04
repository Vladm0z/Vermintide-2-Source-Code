-- chunkname: @scripts/settings/mutators/mutator_curse_belakor_totems.lua

local var_0_0 = {
	COOLDOWN = "COOLDOWN",
	ACTIVE = "ACTIVE",
	READY = "READY"
}

script_data.belakor_totems_debug = true

local var_0_1 = 0.5
local var_0_2 = printf

local function var_0_3(...)
	local var_1_0 = sprintf(...)

	var_0_2("[MutatorCurseBelakorTotems] %s", var_1_0)
end

local function var_0_4(...)
	if script_data.belakor_totems_debug then
		local var_2_0 = sprintf(...)

		var_0_2("[MutatorCurseBelakorTotems] %s", var_2_0)
	end
end

local var_0_5 = 0
local var_0_6 = 25
local var_0_7 = 35
local var_0_8 = 10
local var_0_9 = 15
local var_0_10 = 10
local var_0_11 = 5
local var_0_12 = class(Totem)

var_0_12.init = function (arg_3_0, arg_3_1)
	arg_3_0._logging_prefix = arg_3_1

	var_0_4("-%s- init", arg_3_1)

	arg_3_0._active_totem_data = nil
	arg_3_0._state = var_0_0.COOLDOWN
end

var_0_12.destroy = function (arg_4_0)
	var_0_4("-%s- destroy", arg_4_0._logging_prefix)

	if arg_4_0._active_totem_data then
		arg_4_0:_clear_active_totem()
	end
end

var_0_12.update = function (arg_5_0, arg_5_1, arg_5_2)
	if arg_5_0._state == var_0_0.COOLDOWN then
		if not arg_5_0._cooldown_end_t then
			arg_5_0._cooldown_end_t = arg_5_2 + Math.random_range(var_0_6, var_0_7)
			arg_5_0._state = var_0_0.READY
		elseif arg_5_2 > arg_5_0._cooldown_end_t then
			arg_5_0._state = var_0_0.READY

			var_0_4("-%s- new state %s", arg_5_0._logging_prefix, arg_5_0._state)
		end
	elseif arg_5_0._state == var_0_0.READY then
		-- Nothing
	elseif arg_5_0._state == var_0_0.ACTIVE then
		local var_5_0 = arg_5_0._active_totem_data.unit

		if var_5_0 then
			if arg_5_0._active_totem_data.totem_ext:is_despawned() then
				local var_5_1 = BLACKBOARDS[var_5_0]

				Managers.state.conflict:destroy_unit(var_5_0, var_5_1, "far_off_despawn")
			end

			if not Unit.alive(var_5_0) then
				if arg_5_0._active_totem_data.totem_ext:is_despawned() then
					arg_5_0._cooldown_end_t = arg_5_2 + var_0_5
				else
					arg_5_0._cooldown_end_t = arg_5_2 + Math.random_range(var_0_6, var_0_7)
				end

				arg_5_0._state = var_0_0.COOLDOWN

				var_0_4("-%s- new state %s", arg_5_0._logging_prefix, arg_5_0._state)
				arg_5_0:_clear_active_totem()
			else
				arg_5_0._active_totem_data.latest_position = Unit.local_position(var_5_0, 0)
			end
		end
	else
		ferror("unknown state %d", arg_5_0._state or "nil")
	end
end

var_0_12.spawn = function (arg_6_0, arg_6_1)
	fassert(arg_6_0._state == var_0_0.READY, "prepare_spawn can only be called when the state of the totem is READY")
	var_0_4("-%s- spawn", arg_6_0._logging_prefix)

	if arg_6_0._active_totem_data then
		arg_6_0:_clear_active_totem()
	end

	local var_6_0 = {
		prepare_func = function (arg_7_0, arg_7_1)
			local var_7_0 = false

			arg_7_0.modify_extension_init_data(arg_7_0, var_7_0, arg_7_1)
		end
	}
	local var_6_1 = arg_6_0

	var_6_0.spawned_func = function (arg_8_0, arg_8_1, arg_8_2)
		var_6_1._active_totem_data.unit = arg_8_0
		var_6_1._active_totem_data.queue_id = nil
		var_6_1._active_totem_data.totem_ext = ScriptUnit.has_extension(arg_8_0, "deus_belakor_totem_system")
	end

	local var_6_2 = Quaternion.identity()
	local var_6_3 = Managers.state.conflict:spawn_queued_unit(Breeds.shadow_totem, Vector3Box(arg_6_1), QuaternionBox(var_6_2), "mutator", "spawn_idle", "terror_event", var_6_0)

	arg_6_0._active_totem_data = {
		queue_id = var_6_3,
		starting_position = Vector3Box(arg_6_1)
	}
	arg_6_0._state = var_0_0.ACTIVE

	var_0_4("-%s- new state %s", arg_6_0._logging_prefix, arg_6_0._state)
end

var_0_12.get_state = function (arg_9_0)
	return arg_9_0._state
end

var_0_12.get_position = function (arg_10_0)
	local var_10_0 = arg_10_0._active_totem_data

	if not var_10_0 then
		return nil
	end

	return var_10_0.starting_position:unbox()
end

var_0_12.get_unit = function (arg_11_0)
	local var_11_0 = arg_11_0._active_totem_data

	return var_11_0 and var_11_0.unit
end

var_0_12._clear_active_totem = function (arg_12_0)
	local var_12_0 = arg_12_0._active_totem_data.queue_id

	if var_12_0 then
		Managers.state.conflict:remove_queued_unit(var_12_0)
	end

	arg_12_0._active_totem_data = nil
end

local var_0_13 = 1

return {
	description = "curse_belakor_totems_desc",
	display_name = "curse_belakor_totems_name",
	icon = "deus_curse_belakor_01",
	packages = {
		"resource_packages/mutators/mutator_curse_belakor_totems"
	},
	server_start_function = function (arg_13_0, arg_13_1)
		local var_13_0 = {}

		for iter_13_0 = 1, var_0_13 do
			var_13_0[#var_13_0 + 1] = var_0_12:new(iter_13_0)
		end

		arg_13_1.totems = var_13_0
		arg_13_1.conflict_director = Managers.state.conflict
	end,
	server_players_left_safe_zone = function (arg_14_0, arg_14_1)
		arg_14_1.started = true
	end,
	server_pre_update_function = function (arg_15_0, arg_15_1, arg_15_2, arg_15_3)
		if Managers.state.unit_spawner.game_session == nil or global_is_inside_inn then
			return
		end

		if not arg_15_1.started then
			return
		end

		local var_15_0 = arg_15_1.totems

		for iter_15_0 = 1, #var_15_0 do
			var_15_0[iter_15_0]:update(arg_15_2, arg_15_3)
		end

		local var_15_1 = arg_15_1.conflict_director

		if var_15_1.pacing:horde_population() < 1 and var_15_1.pacing:get_state() ~= "pacing_frozen" then
			return
		end

		for iter_15_1 = 1, #var_15_0 do
			local var_15_2 = var_15_0[iter_15_1]

			if var_15_2:get_state() == var_0_0.READY then
				local var_15_3 = Managers.state.conflict.main_path_info
				local var_15_4 = var_15_3.ahead_unit

				if ALIVE[var_15_4] then
					local var_15_5 = var_15_3.ahead_travel_dist
					local var_15_6 = MainPathUtils.point_on_mainpath(nil, var_15_5 + var_0_11)
					local var_15_7 = POSITION_LOOKUP[var_15_4]
					local var_15_8 = var_15_7 + Vector3.normalize(var_15_6 - var_15_7) * var_0_11
					local var_15_9 = {}
					local var_15_10 = Managers.state.side:get_side_from_name("heroes").PLAYER_AND_BOT_UNITS

					for iter_15_2 = 1, #var_15_10 do
						local var_15_11 = var_15_10[iter_15_2]

						var_15_9[#var_15_9 + 1] = POSITION_LOOKUP[var_15_11]
					end

					for iter_15_3 = 1, #var_15_0 do
						local var_15_12 = var_15_0[iter_15_3]

						var_15_9[#var_15_9 + 1] = var_15_12:get_position()
					end

					local var_15_13 = Managers.state.entity:system("ai_system"):nav_world()
					local var_15_14 = {}

					ConflictUtils.find_positions_around_position(var_15_8, var_15_14, var_15_13, var_0_8, var_0_9, 1, var_15_9, var_0_10)

					local var_15_15 = var_15_14[1]

					if var_15_15 then
						local var_15_16 = Managers.state.bot_nav_transition:traverse_logic()

						if GwNavQueries.raycango(var_15_13, var_15_8, var_15_15, var_15_16) then
							var_15_2:spawn(var_15_15)
						end
					end
				end

				return
			end
		end
	end,
	server_player_hit_function = function (arg_16_0, arg_16_1, arg_16_2, arg_16_3, arg_16_4)
		return
	end
}
