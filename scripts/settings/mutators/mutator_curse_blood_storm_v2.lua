-- chunkname: @scripts/settings/mutators/mutator_curse_blood_storm_v2.lua

local var_0_0 = {
	harder = 60,
	hard = 45,
	normal = 30,
	hardest = 80,
	cataclysm = 100,
	cataclysm_3 = 130,
	cataclysm_2 = 110,
	easy = 20
}
local var_0_1 = {
	COOLDOWN = "COOLDOWN",
	ACTIVE = "ACTIVE",
	READY = "READY"
}

script_data.blood_storm_debug = true

local var_0_2 = printf

local function var_0_3(...)
	local var_1_0 = sprintf(...)

	var_0_2("[MutatorCurseBloodStorm] %s", var_1_0)
end

local function var_0_4(...)
	if script_data.blood_storm_debug then
		local var_2_0 = sprintf(...)

		var_0_2("[MutatorCurseBloodStorm] %s", var_2_0)
	end
end

local var_0_5 = class(Storm)

var_0_5.init = function (arg_3_0, arg_3_1, arg_3_2, arg_3_3, arg_3_4, arg_3_5, arg_3_6)
	arg_3_0._logging_prefix = arg_3_6

	var_0_4("-%s- init", arg_3_6)

	arg_3_0._vortex_template_name = arg_3_1
	arg_3_0._inner_decal_unit_name = arg_3_2
	arg_3_0._outer_decal_unit_name = arg_3_3
	arg_3_0._max_cooldown = arg_3_5
	arg_3_0._min_cooldown = arg_3_4
	arg_3_0._active_storm_data = nil
	arg_3_0._state = var_0_1.COOLDOWN
	arg_3_0._cooldown_end_t = Math.random_range(arg_3_4, arg_3_5)
end

var_0_5.destroy = function (arg_4_0)
	var_0_4("-%s- destroy", arg_4_0._logging_prefix)

	if arg_4_0._active_storm_data then
		arg_4_0:_clear_active_storm()
	end
end

var_0_5.update = function (arg_5_0, arg_5_1, arg_5_2)
	if arg_5_0._state == var_0_1.COOLDOWN then
		if arg_5_2 > arg_5_0._cooldown_end_t then
			arg_5_0._state = var_0_1.READY

			var_0_4("-%s- new state %s", arg_5_0._logging_prefix, arg_5_0._state)
		end
	elseif arg_5_0._state == var_0_1.READY then
		-- Nothing
	elseif arg_5_0._state == var_0_1.ACTIVE then
		local var_5_0 = arg_5_0._active_storm_data.summoned_vortex_unit

		if var_5_0 then
			if not Unit.alive(var_5_0) then
				local var_5_1 = arg_5_0._min_cooldown
				local var_5_2 = arg_5_0._max_cooldown

				arg_5_0._cooldown_end_t = Math.random_range(var_5_1, var_5_2)
				arg_5_0._state = var_0_1.COOLDOWN

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
	fassert(arg_6_0._state == var_0_1.READY, "prepare_spawn can only be called when the state of the storm is READY")
	var_0_4("-%s- spawn", arg_6_0._logging_prefix)

	if arg_6_0._active_storm_data then
		arg_6_0:_clear_active_storm()
	end

	local var_6_0 = arg_6_0._vortex_template_name
	local var_6_1 = VortexTemplates[var_6_0]
	local var_6_2 = 2
	local var_6_3 = math.min(var_6_2 / var_6_1.full_inner_radius, 1)
	local var_6_4 = arg_6_0._inner_decal_unit_name
	local var_6_5

	if var_6_4 then
		local var_6_6 = Matrix4x4.from_quaternion_position(Quaternion.identity(), arg_6_1)
		local var_6_7 = math.max(var_6_1.min_inner_radius, var_6_3 * var_6_1.full_inner_radius)

		Matrix4x4.set_scale(var_6_6, Vector3(var_6_7, var_6_7, var_6_7))

		var_6_5 = Managers.state.unit_spawner:spawn_network_unit(var_6_4, "network_synched_dummy_unit", nil, var_6_6)
	end

	local var_6_8 = arg_6_0._outer_decal_unit_name
	local var_6_9

	if var_6_8 then
		local var_6_10 = Matrix4x4.from_quaternion_position(Quaternion.identity(), arg_6_1)
		local var_6_11 = math.max(var_6_1.min_outer_radius, var_6_3 * var_6_1.full_outer_radius)

		Matrix4x4.set_scale(var_6_10, Vector3(var_6_11, var_6_11, var_6_11))

		var_6_9 = Managers.state.unit_spawner:spawn_network_unit(var_6_8, "network_synched_dummy_unit", nil, var_6_10)
	end

	local var_6_12 = arg_6_0
	local var_6_13 = {
		prepare_func = function (arg_7_0, arg_7_1)
			arg_7_1.ai_supplementary_system = {
				vortex_template_name = var_6_0,
				inner_decal_unit = var_6_5,
				outer_decal_unit = var_6_9
			}
		end,
		spawned_func = function (arg_8_0, arg_8_1, arg_8_2)
			var_6_12._active_storm_data.summoned_vortex_unit = arg_8_0
			var_6_12._active_storm_data.vortex_extension = ScriptUnit.has_extension(arg_8_0, "ai_supplementary_system")
		end
	}
	local var_6_14 = arg_6_1
	local var_6_15 = var_6_1.breed_name
	local var_6_16 = Breeds[var_6_15]
	local var_6_17 = "vortex"
	local var_6_18 = Managers.state.conflict:spawn_queued_unit(var_6_16, Vector3Box(var_6_14), QuaternionBox(Quaternion.identity()), var_6_17, nil, nil, var_6_13)

	arg_6_0._active_storm_data = {
		queue_id = var_6_18,
		starting_position = Vector3Box(arg_6_1)
	}
	arg_6_0._state = var_0_1.ACTIVE

	var_0_4("-%s- new state %s", arg_6_0._logging_prefix, arg_6_0._state)
end

var_0_5.get_state = function (arg_9_0)
	return arg_9_0._state
end

var_0_5.get_position = function (arg_10_0)
	local var_10_0 = arg_10_0._active_storm_data

	if not var_10_0 then
		return nil
	end

	local var_10_1 = var_10_0.summoned_vortex_unit

	if not var_10_1 then
		return nil
	end

	if not Unit.alive(var_10_1) then
		return nil
	end

	local var_10_2 = var_10_0.latest_position

	if not var_10_2 then
		return var_10_0.starting_position:unbox()
	else
		return var_10_2
	end
end

var_0_5.get_vortex_unit = function (arg_11_0)
	local var_11_0 = arg_11_0._active_storm_data

	return var_11_0 and var_11_0.summoned_vortex_unit
end

var_0_5.get_vortex_extension = function (arg_12_0)
	local var_12_0 = arg_12_0._active_storm_data

	return var_12_0 and var_12_0.vortex_extension
end

var_0_5._clear_active_storm = function (arg_13_0)
	local var_13_0 = arg_13_0._active_storm_data

	if not var_13_0.summoned_vortex_unit then
		local var_13_1 = var_13_0.queue_id

		if var_13_1 then
			Managers.state.conflict:remove_queued_unit(var_13_1)
		end
	end

	arg_13_0._active_storm_data = nil
end

local var_0_6 = 0.2
local var_0_7 = "curse_blood_storm_dot"
local var_0_8 = "curse_blood_storm_dot_bots"
local var_0_9 = 3
local var_0_10 = "blood_storm"
local var_0_11 = "units/decals/deus_decal_bloodstorm_inner"
local var_0_12 = "units/decals/deus_decal_bloodstorm_outer"
local var_0_13 = 15
local var_0_14 = 20
local var_0_15 = 10
local var_0_16 = 30
local var_0_17 = 10

return {
	description = "curse_blood_storm_desc",
	display_name = "curse_blood_storm_name",
	icon = "deus_curse_khorne_01",
	packages = {
		"resource_packages/mutators/mutator_curse_blood_storm"
	},
	server_start_function = function (arg_14_0, arg_14_1)
		local var_14_0 = {}

		for iter_14_0 = 1, var_0_9 do
			var_14_0[#var_14_0 + 1] = var_0_5:new(var_0_10, var_0_11, var_0_12, var_0_13, var_0_14, iter_14_0)
		end

		arg_14_1.storms = var_14_0
		arg_14_1.next_bleed_time = 0
	end,
	server_pre_update_function = function (arg_15_0, arg_15_1, arg_15_2, arg_15_3)
		if Managers.state.unit_spawner.game_session == nil or global_is_inside_inn then
			return
		end

		local var_15_0 = false

		if arg_15_3 > arg_15_1.next_bleed_time then
			var_15_0 = true
			arg_15_1.next_bleed_time = arg_15_3 + var_0_6
		end

		local var_15_1 = arg_15_1.storms

		for iter_15_0 = 1, #var_15_1 do
			var_15_1[iter_15_0]:update(arg_15_2, arg_15_3)
		end

		for iter_15_1 = 1, #var_15_1 do
			local var_15_2 = var_15_1[iter_15_1]
			local var_15_3 = var_15_2:get_state()

			if var_15_3 == var_0_1.READY then
				local var_15_4 = PlayerUtils.get_random_alive_hero()

				if var_15_4 then
					local var_15_5 = POSITION_LOOKUP[var_15_4]
					local var_15_6 = {}
					local var_15_7 = Managers.state.side:get_side_from_name("heroes").PLAYER_AND_BOT_UNITS

					for iter_15_2 = 1, #var_15_7 do
						local var_15_8 = var_15_7[iter_15_2]

						var_15_6[#var_15_6 + 1] = POSITION_LOOKUP[var_15_8]
					end

					for iter_15_3 = 1, #var_15_1 do
						local var_15_9 = var_15_1[iter_15_3]

						var_15_6[#var_15_6 + 1] = var_15_9:get_position()
					end

					local var_15_10 = Managers.state.entity:system("ai_system"):nav_world()
					local var_15_11 = {}

					ConflictUtils.find_positions_around_position(var_15_5, var_15_11, var_15_10, var_0_15, var_0_16, 1, var_15_6, var_0_17)

					local var_15_12 = var_15_11[1]

					if var_15_12 then
						var_15_2:spawn(var_15_12)
					end
				end
			elseif var_15_3 == var_0_1.ACTIVE and var_15_0 then
				local var_15_13 = var_15_2:get_vortex_extension()
				local var_15_14 = var_15_2:get_vortex_unit()

				if var_15_13 then
					local var_15_15 = Managers.player:players()

					for iter_15_4, iter_15_5 in pairs(var_15_15) do
						local var_15_16 = iter_15_5.player_unit

						if ALIVE[var_15_16] then
							local var_15_17 = POSITION_LOOKUP[var_15_16]

							if var_15_13:is_position_inside(var_15_17) then
								local var_15_18 = Managers.state.entity:system("buff_system")
								local var_15_19 = Managers.state.difficulty:get_difficulty()
								local var_15_20 = var_0_0[var_15_19]
								local var_15_21 = iter_15_5.bot_player and var_0_8 or var_0_7

								var_15_18:add_buff(var_15_16, var_15_21, var_15_14, false, var_15_20)
							end
						end
					end
				end
			end
		end
	end,
	server_player_hit_function = function (arg_16_0, arg_16_1, arg_16_2, arg_16_3, arg_16_4)
		if arg_16_4[2] == "blood_storm" then
			local var_16_0 = ScriptUnit.extension_input(arg_16_2, "dialogue_system")
			local var_16_1 = FrameTable.alloc_table()

			var_16_0:trigger_dialogue_event("curse_damage_taken", var_16_1)
		end
	end
}
