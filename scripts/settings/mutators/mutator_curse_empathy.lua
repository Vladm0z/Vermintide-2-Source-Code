-- chunkname: @scripts/settings/mutators/mutator_curse_empathy.lua

local var_0_0 = {
	temporary_health_degen = true,
	sync_health = true,
	knockdown_bleed = true,
	death_zone = true,
	volume_insta_kill = true,
	heal = true,
	inside_forbidden_tag_volume = true,
	forced = true
}
local var_0_1
local var_0_2 = "Play_curse_empathy_loop"
local var_0_3 = "Stop_curse_empathy_loop"
local var_0_4 = "fx/leash_beam_player_01"
local var_0_5 = "fx/leash_beam_01"
local var_0_6 = "cloud_1"
local var_0_7 = 5
local var_0_8 = 1
local var_0_9 = 8
local var_0_10 = 7.5
local var_0_11 = 2.5
local var_0_12 = 0.5
local var_0_13 = 50
local var_0_14 = 0
local var_0_15 = 3
local var_0_16 = "curse_empathy"

var_0_0[var_0_16] = true

local function var_0_17(arg_1_0, arg_1_1, arg_1_2, arg_1_3)
	local var_1_0 = arg_1_0.damage_buffer[arg_1_1] or {
		damage = 0,
		damaging_unit = arg_1_3
	}

	var_1_0.damage = var_1_0.damage + arg_1_2
	arg_1_0.damage_buffer[arg_1_1] = var_1_0
end

local var_0_18 = {}

local function var_0_19(arg_2_0)
	table.clear(var_0_18)

	for iter_2_0, iter_2_1 in ipairs(arg_2_0) do
		if HEALTH_ALIVE[iter_2_1] then
			table.insert(var_0_18, iter_2_1)
		end
	end

	return var_0_18
end

local function var_0_20(arg_3_0)
	table.clear(var_0_18)

	for iter_3_0, iter_3_1 in ipairs(arg_3_0) do
		if HEALTH_ALIVE[iter_3_1] and not ScriptUnit.has_extension(iter_3_1, "status_system"):is_knocked_down() then
			table.insert(var_0_18, iter_3_1)
		end
	end

	return var_0_18
end

local function var_0_21(arg_4_0, arg_4_1)
	local var_4_0 = Vector3.zero()

	if arg_4_0 == arg_4_1 then
		local var_4_1 = ScriptUnit.has_extension(arg_4_1, "first_person_system")

		if var_4_1 then
			local var_4_2 = var_4_1.first_person_unit

			var_4_0 = Unit.local_position(var_4_2, 0) - 0.5 * Vector3.up()
		end
	else
		local var_4_3 = Unit.node(arg_4_1, "j_spine")

		var_4_0 = Unit.world_position(arg_4_1, var_4_3)
	end

	return var_4_0
end

local function var_0_22(arg_5_0, arg_5_1, arg_5_2, arg_5_3, arg_5_4)
	local var_5_0 = math.pow(arg_5_3, 2)
	local var_5_1 = math.pow(arg_5_2, 2)
	local var_5_2 = Vector3.distance_squared(arg_5_0, arg_5_1)
	local var_5_3 = math.auto_lerp(var_5_0, var_5_1, arg_5_4, 0, var_5_2)

	return (math.clamp(var_5_3, 0, arg_5_4))
end

local function var_0_23(arg_6_0, arg_6_1, arg_6_2)
	local var_6_0 = arg_6_1.beam_effects
	local var_6_1 = var_6_0[arg_6_2]

	if var_6_1 then
		local var_6_2 = arg_6_0.world
		local var_6_3 = arg_6_1.wwise_world
		local var_6_4 = var_6_1.ids

		for iter_6_0, iter_6_1 in pairs(var_6_4) do
			World.destroy_particles(var_6_2, iter_6_1)
		end

		if var_6_1.damage_sound_id then
			WwiseWorld.trigger_event(var_6_3, var_0_3)

			local var_6_5
		end

		var_6_0[arg_6_2] = nil
	end
end

local function var_0_24(arg_7_0)
	local var_7_0 = Managers.state.entity:system("audio_system")
	local var_7_1 = 0
	local var_7_2 = arg_7_0.beam_effects

	for iter_7_0, iter_7_1 in pairs(var_7_2) do
		var_7_1 = math.max(iter_7_1.beam_softness, var_7_1)
	end

	local var_7_3 = math.auto_lerp(0, var_0_8, 0, var_0_14, var_7_1)
	local var_7_4 = math.clamp(var_7_3, 0, var_0_14)

	if var_0_1 then
		var_7_0:set_global_parameter(var_0_1, var_7_4)
	end
end

local function var_0_25(arg_8_0, arg_8_1, arg_8_2)
	local var_8_0 = arg_8_1.beam_effects[arg_8_2]
	local var_8_1 = var_8_0 and var_8_0.ids.player_effect_id

	if not var_8_1 then
		return
	end

	local var_8_2 = arg_8_0.world
	local var_8_3 = arg_8_1.local_player.player_unit
	local var_8_4 = var_0_21(var_8_3, arg_8_2)

	World.move_particles(var_8_2, var_8_1, var_8_4)
end

local function var_0_26(arg_9_0, arg_9_1, arg_9_2)
	local var_9_0 = arg_9_0.world
	local var_9_1 = arg_9_1.beam_start_variable_id
	local var_9_2 = arg_9_1.beam_end_variable_id
	local var_9_3 = arg_9_1.local_player.player_unit
	local var_9_4 = var_0_21(var_9_3, arg_9_2)
	local var_9_5 = var_0_21(var_9_3, var_9_3)
	local var_9_6 = arg_9_1.beam_effects[arg_9_2]
	local var_9_7 = var_9_6.ids.beam_effect_id

	World.set_particles_variable(var_9_0, var_9_7, var_9_1, var_9_4)
	World.set_particles_variable(var_9_0, var_9_7, var_9_2, var_9_5)

	local var_9_8 = var_0_22(var_9_4, var_9_5, var_0_9, var_0_10, var_0_7)

	World.set_particles_material_scalar(var_9_0, var_9_7, var_0_6, "intensity", var_9_8)

	local var_9_9 = var_9_6.beam_softness or 0

	World.set_particles_material_scalar(var_9_0, var_9_7, var_0_6, "softness", var_9_9)
end

local function var_0_27(arg_10_0, arg_10_1, arg_10_2, arg_10_3)
	local var_10_0 = arg_10_0.beam_effects[arg_10_3]

	if not var_10_0 then
		return
	end

	local var_10_1 = arg_10_0.wwise_world
	local var_10_2 = var_10_0.damage_sound_id

	var_10_0.blinking_enabled = arg_10_1

	if arg_10_1 then
		var_10_0.blink_timer = var_0_11 + arg_10_2

		if not var_10_2 then
			var_10_0.damage_sound_id = WwiseWorld.trigger_event(var_10_1, var_0_2)
		end
	else
		var_10_0.blink_timer = nil

		if var_10_2 then
			WwiseWorld.trigger_event(var_10_1, var_0_3)

			var_10_0.damage_sound_id = nil
		end
	end
end

local function var_0_28(arg_11_0, arg_11_1, arg_11_2)
	for iter_11_0, iter_11_1 in pairs(arg_11_0.beam_effects) do
		local var_11_0 = iter_11_1.blink_timer

		if var_11_0 and var_11_0 <= arg_11_2 then
			local var_11_1 = false

			var_0_27(arg_11_0, var_11_1, arg_11_2, iter_11_0)
		end

		local var_11_2 = iter_11_1.blinking_enabled and 1 or -1
		local var_11_3 = iter_11_1.beam_softness + var_0_15 * var_11_2 * arg_11_1

		iter_11_1.beam_softness = math.clamp(var_11_3, 0, var_0_8)
	end
end

local function var_0_29(arg_12_0, arg_12_1, arg_12_2, arg_12_3)
	for iter_12_0, iter_12_1 in pairs(arg_12_2) do
		local var_12_0 = HEALTH_ALIVE[iter_12_0]
		local var_12_1 = var_12_0 and ScriptUnit.extension(iter_12_0, "status_system")
		local var_12_2 = var_12_1 and var_12_1:is_knocked_down()

		if not var_12_0 or var_12_2 or arg_12_3 == 1 then
			var_0_23(arg_12_0, arg_12_1, iter_12_0)
		end
	end
end

local function var_0_30(arg_13_0, arg_13_1, arg_13_2)
	if not arg_13_1[arg_13_2] then
		local var_13_0 = World.create_particles(arg_13_0, var_0_5, Vector3.zero(), Quaternion.identity())
		local var_13_1 = World.create_particles(arg_13_0, var_0_4, Vector3.zero(), Quaternion.identity())

		arg_13_1[arg_13_2] = {
			blinking_enabled = false,
			beam_softness = 0,
			ids = {
				beam_effect_id = var_13_0,
				player_effect_id = var_13_1
			}
		}
	end
end

local function var_0_31(arg_14_0, arg_14_1, arg_14_2, arg_14_3)
	local var_14_0 = not arg_14_0:owner(arg_14_1).bot_player
	local var_14_1 = not var_0_0[arg_14_3]
	local var_14_2 = arg_14_2 > 0
	local var_14_3 = ScriptUnit.extension(arg_14_1, "status_system"):is_knocked_down()

	return var_14_0 and var_14_1 and var_14_2 and not var_14_3
end

return {
	description = "curse_empathy_desc",
	display_name = "curse_empathy_name",
	icon = "deus_curse_slaanesh_01",
	server_start_function = function(arg_15_0, arg_15_1)
		arg_15_1.damage_buffer = {}
		arg_15_1.player_units_in_range = {}
	end,
	modify_player_base_damage = function(arg_16_0, arg_16_1, arg_16_2, arg_16_3, arg_16_4, arg_16_5)
		local var_16_0 = arg_16_1.player_units_in_range[arg_16_2]

		if not var_16_0 or not var_0_31(Managers.player, arg_16_2, arg_16_4, arg_16_5) then
			return arg_16_4
		end

		local var_16_1 = arg_16_4 * var_0_12
		local var_16_2 = (arg_16_4 - var_16_1) / table.size(var_16_0)
		local var_16_3 = math.min(var_16_2, var_0_13)

		for iter_16_0, iter_16_1 in pairs(arg_16_1.player_units_in_range[arg_16_2]) do
			if ALIVE[iter_16_0] and iter_16_0 ~= arg_16_2 then
				var_0_17(arg_16_1, iter_16_0, var_16_3, arg_16_3)
			end
		end

		return var_16_1
	end,
	server_update_function = function(arg_17_0, arg_17_1, arg_17_2, arg_17_3)
		arg_17_1.template.update_players_in_range(arg_17_1)
		arg_17_1.template.process_damage_buffer(arg_17_1)
	end,
	update_players_in_range = function(arg_18_0)
		local var_18_0 = var_0_19(arg_18_0.hero_side.PLAYER_UNITS)

		for iter_18_0, iter_18_1 in ipairs(var_18_0) do
			for iter_18_2, iter_18_3 in ipairs(var_18_0) do
				if iter_18_1 ~= iter_18_3 then
					arg_18_0.player_units_in_range[iter_18_1] = arg_18_0.player_units_in_range[iter_18_1] or {}

					local var_18_1 = POSITION_LOOKUP[iter_18_1]
					local var_18_2 = POSITION_LOOKUP[iter_18_3]
					local var_18_3 = Vector3.distance_squared(var_18_2, var_18_1)
					local var_18_4 = math.pow(var_0_9, 2)
					local var_18_5 = ScriptUnit.extension(iter_18_1, "status_system"):is_knocked_down()
					local var_18_6 = ScriptUnit.extension(iter_18_3, "status_system"):is_knocked_down()
					local var_18_7 = var_18_5 or var_18_6

					if var_18_3 < var_18_4 and not var_18_7 then
						arg_18_0.player_units_in_range[iter_18_1][iter_18_3] = true
					else
						arg_18_0.player_units_in_range[iter_18_1][iter_18_3] = nil
					end
				end
			end
		end

		for iter_18_4, iter_18_5 in pairs(arg_18_0.player_units_in_range) do
			if not ALIVE[iter_18_4] then
				table.clear(arg_18_0.player_units_in_range[iter_18_4])
			else
				for iter_18_6, iter_18_7 in pairs(iter_18_5) do
					if not ALIVE[iter_18_6] then
						iter_18_5[iter_18_6] = nil
					end
				end
			end
		end
	end,
	process_damage_buffer = function(arg_19_0)
		for iter_19_0, iter_19_1 in pairs(arg_19_0.damage_buffer) do
			if ALIVE[iter_19_0] then
				local var_19_0 = iter_19_1.damaging_unit

				if Unit.alive(var_19_0) then
					local var_19_1 = "full"
					local var_19_2 = Vector3.up()
					local var_19_3 = Vector3.up()

					DamageUtils.add_damage_network(iter_19_0, var_19_0, iter_19_1.damage, var_19_1, var_0_16, var_19_2, var_19_3, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, 1)
				end
			end

			arg_19_0.damage_buffer[iter_19_0] = nil
		end
	end,
	client_player_hit_function = function(arg_20_0, arg_20_1, arg_20_2, arg_20_3, arg_20_4)
		if arg_20_4[2] == var_0_16 then
			local var_20_0 = Managers.time:time("game")
			local var_20_1 = true

			var_0_27(arg_20_1, var_20_1, var_20_0, arg_20_3)

			local var_20_2 = ScriptUnit.extension_input(arg_20_2, "dialogue_system")
			local var_20_3 = FrameTable.alloc_table()

			var_20_2:trigger_networked_dialogue_event("curse_damage_taken", var_20_3)
		end
	end,
	client_start_function = function(arg_21_0, arg_21_1)
		local var_21_0 = arg_21_0.world
		local var_21_1 = Managers.player
		local var_21_2

		arg_21_1.wwise_world, var_21_2 = Managers.world:wwise_world(var_21_0), Managers.state.side:get_side_from_name("heroes")
		arg_21_1.local_player = var_21_1:local_player()
		arg_21_1.beam_start_variable_id = World.find_particles_variable(var_21_0, var_0_5, "start")
		arg_21_1.beam_end_variable_id = World.find_particles_variable(var_21_0, var_0_5, "end")
		arg_21_1.center_effect_id = nil
		arg_21_1.center_sound = nil
		arg_21_1.beam_effects = {}
		arg_21_1.hero_side = var_21_2
	end,
	client_update_function = function(arg_22_0, arg_22_1, arg_22_2, arg_22_3)
		local var_22_0 = arg_22_1.local_player.player_unit

		if not ALIVE[var_22_0] then
			return
		end

		local var_22_1 = arg_22_1.beam_effects
		local var_22_2 = var_0_20(arg_22_1.hero_side.PLAYER_UNITS)

		if #var_22_2 > 1 then
			local var_22_3 = arg_22_0.world

			var_0_24(arg_22_1)
			var_0_28(arg_22_1, arg_22_2, arg_22_3)

			for iter_22_0, iter_22_1 in ipairs(var_22_2) do
				var_0_30(var_22_3, var_22_1, iter_22_1)
				var_0_25(arg_22_0, arg_22_1, iter_22_1)

				local var_22_4 = ScriptUnit.extension(iter_22_1, "status_system"):is_knocked_down()
				local var_22_5 = ScriptUnit.extension(var_22_0, "status_system"):is_knocked_down()

				if var_22_0 ~= iter_22_1 and not var_22_4 and not var_22_5 then
					local var_22_6 = POSITION_LOOKUP[iter_22_1]
					local var_22_7 = POSITION_LOOKUP[var_22_0]

					if Vector3.distance_squared(var_22_7, var_22_6) < math.pow(var_0_9, 2) then
						var_0_26(arg_22_0, arg_22_1, iter_22_1)
					else
						var_0_23(arg_22_0, arg_22_1, iter_22_1)
					end
				end
			end
		end

		var_0_29(arg_22_0, arg_22_1, var_22_1, #var_22_2)
	end,
	client_stop_function = function(arg_23_0, arg_23_1)
		local var_23_0 = arg_23_1.beam_effects

		for iter_23_0, iter_23_1 in pairs(var_23_0) do
			var_0_23(arg_23_0, arg_23_1, iter_23_0)
		end
	end
}
