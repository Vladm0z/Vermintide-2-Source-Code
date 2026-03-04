-- chunkname: @scripts/settings/mutators/mutator_curse_shadow_daggers.lua

local var_0_0 = {
	COOLDOWN = "COOLDOWN",
	ACTIVE = "ACTIVE",
	READY = "READY"
}

script_data.shadow_daggers_debug = true

local var_0_1 = 5
local var_0_2 = printf

local function var_0_3(...)
	local var_1_0 = sprintf(...)

	var_0_2("[MutatorCurseShadowDaggers] %s", var_1_0)
end

local function var_0_4(...)
	if script_data.shadow_daggers_debug then
		local var_2_0 = sprintf(...)

		var_0_2("[MutatorCurseShadowDaggers] %s", var_2_0)
	end
end

local var_0_5 = class(Storm)

var_0_5.init = function (arg_3_0, arg_3_1, arg_3_2, arg_3_3, arg_3_4)
	arg_3_0._logging_prefix = arg_3_4

	var_0_4("-%s- init", arg_3_4)

	arg_3_0._unit_name = arg_3_1
	arg_3_0._max_cooldown = arg_3_3
	arg_3_0._min_cooldown = arg_3_2
	arg_3_0._active_storm_data = nil
	arg_3_0._state = var_0_0.COOLDOWN
	arg_3_0._cooldown_end_t = Math.random_range(arg_3_2, arg_3_3)
end

var_0_5.destroy = function (arg_4_0)
	var_0_4("-%s- destroy", arg_4_0._logging_prefix)

	if arg_4_0._active_storm_data then
		arg_4_0:_clear_active_storm()
	end
end

var_0_5.update = function (arg_5_0, arg_5_1, arg_5_2)
	if arg_5_0._state == var_0_0.COOLDOWN then
		if arg_5_2 > arg_5_0._cooldown_end_t then
			arg_5_0._state = var_0_0.READY

			var_0_4("-%s- new state %s", arg_5_0._logging_prefix, arg_5_0._state)
		end
	elseif arg_5_0._state == var_0_0.READY then
		-- Nothing
	elseif arg_5_0._state == var_0_0.ACTIVE then
		local var_5_0 = arg_5_0._active_storm_data.unit

		if var_5_0 then
			if not Unit.alive(var_5_0) then
				local var_5_1 = arg_5_0._min_cooldown
				local var_5_2 = arg_5_0._max_cooldown

				arg_5_0._cooldown_end_t = Math.random_range(var_5_1, var_5_2)
				arg_5_0._state = var_0_0.COOLDOWN

				var_0_4("-%s- new state %s", arg_5_0._logging_prefix, arg_5_0._state)
				arg_5_0:_clear_active_storm()
			else
				arg_5_0._active_storm_data.latest_position = Unit.local_position(var_5_0, 0)
			end
		end
	else
		ferror("unknown state %d", arg_5_0._state or "nil")
	end
end

var_0_5.spawn = function (arg_6_0, arg_6_1)
	fassert(arg_6_0._state == var_0_0.READY, "prepare_spawn can only be called when the state of the storm is READY")
	var_0_4("-%s- spawn", arg_6_0._logging_prefix)

	if arg_6_0._active_storm_data then
		arg_6_0:_clear_active_storm()
	end

	local var_6_0 = arg_6_0._unit_name
	local var_6_1 = Matrix4x4.from_quaternion_position(Quaternion.identity(), arg_6_1)
	local var_6_2 = {
		shadow_dagger_spawner_system = {
			limitted_spawner = true
		}
	}
	local var_6_3 = Managers.state.unit_spawner:spawn_network_unit(var_6_0, "shadow_dagger_spawner", var_6_2, var_6_1)

	arg_6_0._active_storm_data = {
		unit = var_6_3,
		starting_position = Vector3Box(arg_6_1)
	}
	arg_6_0._state = var_0_0.ACTIVE

	var_0_4("-%s- new state %s", arg_6_0._logging_prefix, arg_6_0._state)
end

var_0_5.get_state = function (arg_7_0)
	return arg_7_0._state
end

var_0_5.get_position = function (arg_8_0)
	local var_8_0 = arg_8_0._active_storm_data

	if not var_8_0 then
		return nil
	end

	return var_8_0.starting_position:unbox()
end

var_0_5.get_unit = function (arg_9_0)
	local var_9_0 = arg_9_0._active_storm_data

	return var_9_0 and var_9_0.unit
end

var_0_5._clear_active_storm = function (arg_10_0)
	local var_10_0 = arg_10_0._active_storm_data.unit

	if var_10_0 and Unit.alive(var_10_0) then
		Managers.state.unit_spawner:mark_for_deletion(var_10_0)
	end

	arg_10_0._active_storm_data = nil
end

local var_0_6 = 3
local var_0_7 = "units/props/blk/blk_curse_shadow_dagger_spawner_01"
local var_0_8 = 10
local var_0_9 = 10
local var_0_10 = 10
local var_0_11 = 30
local var_0_12 = 10

return {
	description = "curse_shadow_daggers_desc",
	display_name = "curse_shadow_daggers_name",
	icon = "deus_curse_khorne_01",
	packages = {
		"resource_packages/mutators/mutator_curse_shadow_daggers"
	},
	server_start_function = function (arg_11_0, arg_11_1)
		local var_11_0 = {}

		for iter_11_0 = 1, var_0_6 do
			var_11_0[#var_11_0 + 1] = var_0_5:new(var_0_7, var_0_8, var_0_9, iter_11_0)
		end

		arg_11_1.storms = var_11_0
		arg_11_1.next_bleed_time = 0
	end,
	server_players_left_safe_zone = function (arg_12_0, arg_12_1)
		arg_12_1.started = true
	end,
	server_pre_update_function = function (arg_13_0, arg_13_1, arg_13_2, arg_13_3)
		if Managers.state.unit_spawner.game_session == nil or global_is_inside_inn then
			return
		end

		if not arg_13_1.started then
			return
		end

		local var_13_0 = arg_13_1.storms

		for iter_13_0 = 1, #var_13_0 do
			var_13_0[iter_13_0]:update(arg_13_2, arg_13_3)
		end

		if arg_13_1.next_spawn_t and arg_13_3 < arg_13_1.next_spawn_t then
			return
		end

		for iter_13_1 = 1, #var_13_0 do
			local var_13_1 = var_13_0[iter_13_1]

			if var_13_1:get_state() == var_0_0.READY then
				local var_13_2 = PlayerUtils.get_random_alive_hero()

				if var_13_2 then
					local var_13_3 = POSITION_LOOKUP[var_13_2]
					local var_13_4 = {}
					local var_13_5 = Managers.state.side:get_side_from_name("heroes").PLAYER_AND_BOT_UNITS

					for iter_13_2 = 1, #var_13_5 do
						local var_13_6 = var_13_5[iter_13_2]

						var_13_4[#var_13_4 + 1] = POSITION_LOOKUP[var_13_6]
					end

					for iter_13_3 = 1, #var_13_0 do
						local var_13_7 = var_13_0[iter_13_3]

						var_13_4[#var_13_4 + 1] = var_13_7:get_position()
					end

					local var_13_8 = Managers.state.entity:system("ai_system"):nav_world()
					local var_13_9 = {}

					ConflictUtils.find_positions_around_position(var_13_3, var_13_9, var_13_8, var_0_10, var_0_11, 1, var_13_4, var_0_12)

					local var_13_10 = var_13_9[1]

					if var_13_10 then
						var_13_1:spawn(var_13_10)

						arg_13_1.next_spawn_t = arg_13_3 + var_0_1
					end
				end

				return
			end
		end
	end,
	server_player_hit_function = function (arg_14_0, arg_14_1, arg_14_2, arg_14_3, arg_14_4)
		return
	end
}
