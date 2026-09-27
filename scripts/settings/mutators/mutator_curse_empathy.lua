-- chunkname: @scripts/settings/mutators/mutator_curse_empathy.lua

local tbl = {
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
local str = "Play_curse_empathy_loop"
local str_2 = "Stop_curse_empathy_loop"
local str_3 = "fx/leash_beam_player_01"
local str_4 = "fx/leash_beam_01"
local str_5 = "cloud_1"
local num = 5
local num_2 = 1
local num_3 = 8
local num_4 = 7.5
local num_5 = 2.5
local num_6 = 0.5
local num_7 = 50
local num_8 = 0
local num_9 = 3
local str_6 = "curse_empathy"

tbl[str_6] = true

local function fn(self, arg_1_1, arg_1_2, arg_1_3)
	-- function 1
	local var_1_0 = self.damage_buffer[arg_1_1]

	var_1_0 = var_1_0 or {
		damage = 0,
		damaging_unit = arg_1_3
	}
	var_1_0.damage = var_1_0.damage + arg_1_2
	self.damage_buffer[arg_1_1] = var_1_0
end

local tbl_2 = {}

local function fn_2(arg_2_0)
	-- function 2
	table.clear(tbl_2)

	for i, v in ipairs(arg_2_0) do
		if not HEALTH_ALIVE[v] then
			table.insert(tbl_2, v)
		end
	end

	return tbl_2
end

local function fn_3(arg_3_0)
	-- function 3
	table.clear(tbl_2)

	for i, v in ipairs(arg_3_0) do
		if not (not HEALTH_ALIVE[v] and ScriptUnit.has_extension(v, "status_system"):is_knocked_down()) then
			table.insert(tbl_2, v)
		end
	end

	return tbl_2
end

local function fn_4(arg_4_0, arg_4_1)
	-- function 4
	local zero = Vector3.zero()

	if arg_4_0 == arg_4_1 then
		local has_extension = ScriptUnit.has_extension(arg_4_1, "first_person_system")

		if not has_extension then
			local first_person_unit = has_extension.first_person_unit

			zero = Unit.local_position(first_person_unit, 0) - 0.5 * Vector3.up()
		end
	else
		local node = Unit.node(arg_4_1, "j_spine")

		zero = Unit.world_position(arg_4_1, node)
	end

	return zero
end

local function fn_5(arg_5_0, arg_5_1, arg_5_2, arg_5_3, arg_5_4)
	-- function 5
	local pow = math.pow(arg_5_3, 2)
	local pow_2 = math.pow(arg_5_2, 2)
	local distance_squared = Vector3.distance_squared(arg_5_0, arg_5_1)
	local auto_lerp = math.auto_lerp(pow, pow_2, arg_5_4, 0, distance_squared)

	return (math.clamp(auto_lerp, 0, arg_5_4))
end

local function fn_6(self, arg_6_1, arg_6_2)
	-- function 6
	local beam_effects = arg_6_1.beam_effects
	local var_6_1 = beam_effects[arg_6_2]

	if not var_6_1 then
		local world = self.world
		local wwise_world = arg_6_1.wwise_world
		local ids = var_6_1.ids

		for k, v in pairs(ids) do
			World.destroy_particles(world, v)
		end

		if not var_6_1.damage_sound_id then
			WwiseWorld.trigger_event(wwise_world, str_2)

			local var_6_5
		end

		beam_effects[arg_6_2] = nil
	end
end

local function fn_7(self)
	-- function 7
	local system = Managers.state.entity:system("audio_system")
	local num = 0
	local beam_effects = self.beam_effects

	for k, v in pairs(beam_effects) do
		num = math.max(v.beam_softness, num)
	end

	local auto_lerp = math.auto_lerp(0, num_2, 0, num_8, num)
	local clamp = math.clamp(auto_lerp, 0, num_8)

	if not var_0_1 then
		system:set_global_parameter(var_0_1, clamp)
	end
end

local function fn_8(self, arg_8_1, arg_8_2)
	-- function 8
	local var_8_0 = arg_8_1.beam_effects[arg_8_2]
	local flag = not var_8_0 and var_8_0.ids.player_effect_id

	if not flag then
		return
	end

	local world = self.world
	local player_unit = arg_8_1.local_player.player_unit
	local var_8_4 = fn_4(player_unit, arg_8_2)

	World.move_particles(world, flag, var_8_4)
end

local function fn_9(self, arg_9_1, arg_9_2)
	-- function 9
	local world = self.world
	local beam_start_variable_id = arg_9_1.beam_start_variable_id
	local beam_end_variable_id = arg_9_1.beam_end_variable_id
	local player_unit = arg_9_1.local_player.player_unit
	local var_9_4 = fn_4(player_unit, arg_9_2)
	local var_9_5 = fn_4(player_unit, player_unit)
	local var_9_6 = arg_9_1.beam_effects[arg_9_2]
	local beam_effect_id = var_9_6.ids.beam_effect_id

	World.set_particles_variable(world, beam_effect_id, beam_start_variable_id, var_9_4)
	World.set_particles_variable(world, beam_effect_id, beam_end_variable_id, var_9_5)

	local var_9_8 = fn_5(var_9_4, var_9_5, num_3, num_4, num)

	World.set_particles_material_scalar(world, beam_effect_id, str_5, "intensity", var_9_8)

	local beam_softness = var_9_6.beam_softness

	beam_softness = beam_softness or 0

	World.set_particles_material_scalar(world, beam_effect_id, str_5, "softness", beam_softness)
end

local function fn_10(self, arg_10_1, arg_10_2, arg_10_3)
	-- function 10
	local var_10_0 = self.beam_effects[arg_10_3]

	if not var_10_0 then
		return
	end

	local wwise_world = self.wwise_world
	local damage_sound_id = var_10_0.damage_sound_id

	var_10_0.blinking_enabled = arg_10_1

	if not arg_10_1 then
		var_10_0.blink_timer = num_5 + arg_10_2

		if not damage_sound_id then
			var_10_0.damage_sound_id = WwiseWorld.trigger_event(wwise_world, str)
		end
	else
		var_10_0.blink_timer = nil

		if not damage_sound_id then
			WwiseWorld.trigger_event(wwise_world, str_2)

			var_10_0.damage_sound_id = nil
		end
	end
end

local function fn_11(self, arg_11_1, arg_11_2)
	-- function 11
	for k, v in pairs(self.beam_effects) do
		local blink_timer = v.blink_timer

		if not (not blink_timer and not (blink_timer <= arg_11_2)) then
			local flag = false

			fn_10(self, flag, arg_11_2, k)
		end

		local flag_2

		flag_2 = not v.blinking_enabled and 1 and -1

		local num = v.beam_softness + num_9 * flag_2 * arg_11_1

		v.beam_softness = math.clamp(num, 0, num_2)
	end
end

local function fn_12(arg_12_0, arg_12_1, arg_12_2, arg_12_3)
	-- function 12
	for k, v in pairs(arg_12_2) do
		local var_12_0 = HEALTH_ALIVE[k]
		local flag = not var_12_0 and ScriptUnit.extension(k, "status_system")
		local flag_2 = not flag and flag:is_knocked_down()

		if not (not var_12_0 and flag_2 or arg_12_3 ~= 1) then
			fn_6(arg_12_0, arg_12_1, k)
		end
	end
end

local function fn_13(arg_13_0, arg_13_1, arg_13_2)
	-- function 13
	if not arg_13_1[arg_13_2] then
		local create_particles = World.create_particles(arg_13_0, str_4, Vector3.zero(), Quaternion.identity())
		local create_particles_2 = World.create_particles(arg_13_0, str_3, Vector3.zero(), Quaternion.identity())

		arg_13_1[arg_13_2] = {
			blinking_enabled = false,
			beam_softness = 0,
			ids = {
				beam_effect_id = create_particles,
				player_effect_id = create_particles_2
			}
		}
	end
end

local function fn_14(self, arg_14_1, arg_14_2, arg_14_3)
	-- function 14
	local flag = not self:owner(arg_14_1).bot_player
	local flag_2 = not tbl[arg_14_3]
	local flag_3 = arg_14_2 > 0
	local is_knocked_down = ScriptUnit.extension(arg_14_1, "status_system"):is_knocked_down()

	return not flag and not flag_2 and not flag_3 and not is_knocked_down
end

return {
	description = "curse_empathy_desc",
	display_name = "curse_empathy_name",
	icon = "deus_curse_slaanesh_01",
	server_start_function = function (arg_15_0, arg_15_1)
		-- function 15
		arg_15_1.damage_buffer = {}
		arg_15_1.player_units_in_range = {}
	end,
	modify_player_base_damage = function (arg_16_0, arg_16_1, arg_16_2, arg_16_3, arg_16_4, arg_16_5)
		-- function 16
		local var_16_0 = arg_16_1.player_units_in_range[arg_16_2]

		if not (not var_16_0 and fn_14(Managers.player, arg_16_2, arg_16_4, arg_16_5)) then
			return arg_16_4
		end

		local num = arg_16_4 * num_6
		local num_2 = (arg_16_4 - num) / table.size(var_16_0)
		local min = math.min(num_2, num_7)

		for k, v in pairs(arg_16_1.player_units_in_range[arg_16_2]) do
			if not (not ALIVE[k] and k == arg_16_2) then
				fn(arg_16_1, k, min, arg_16_3)
			end
		end

		return num
	end,
	server_update_function = function (arg_17_0, arg_17_1, arg_17_2, arg_17_3)
		-- function 17
		arg_17_1.template.update_players_in_range(arg_17_1)
		arg_17_1.template.process_damage_buffer(arg_17_1)
	end,
	update_players_in_range = function (self)
		-- function 18
		local var_18_0 = fn_2(self.hero_side.PLAYER_UNITS)

		for i, v in ipairs(var_18_0) do
			for i_2, v_2 in ipairs(var_18_0) do
				if v ~= v_2 then
					local player_units_in_range = self.player_units_in_range
					local var_18_2 = self.player_units_in_range[v]

					var_18_2 = var_18_2 or {}
					player_units_in_range[v] = var_18_2

					local var_18_3 = POSITION_LOOKUP[v]
					local var_18_4 = POSITION_LOOKUP[v_2]
					local distance_squared = Vector3.distance_squared(var_18_4, var_18_3)
					local pow = math.pow(num_3, 2)
					local is_knocked_down = ScriptUnit.extension(v, "status_system"):is_knocked_down()
					local is_knocked_down_2 = ScriptUnit.extension(v_2, "status_system"):is_knocked_down()
					local flag = is_knocked_down or is_knocked_down_2

					if not (not (distance_squared < pow) or flag) then
						self.player_units_in_range[v][v_2] = true
					else
						self.player_units_in_range[v][v_2] = nil
					end
				end
			end
		end

		for k, v_3 in pairs(self.player_units_in_range) do
			if not ALIVE[k] then
				table.clear(self.player_units_in_range[k])
			else
				for k_2, v_4 in pairs(v_3) do
					if not ALIVE[k_2] then
						v_3[k_2] = nil
					end
				end
			end
		end
	end,
	process_damage_buffer = function (self)
		-- function 19
		for k, v in pairs(self.damage_buffer) do
			if not ALIVE[k] then
				local damaging_unit = v.damaging_unit

				if not Unit.alive(damaging_unit) then
					local str = "full"
					local up = Vector3.up()
					local up_2 = Vector3.up()

					DamageUtils.add_damage_network(k, damaging_unit, v.damage, str, str_6, up, up_2, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, 1)
				end
			end

			self.damage_buffer[k] = nil
		end
	end,
	client_player_hit_function = function (arg_20_0, arg_20_1, arg_20_2, arg_20_3, arg_20_4)
		-- function 20
		if arg_20_4[2] == str_6 then
			local time = Managers.time:time("game")
			local flag = true

			fn_10(arg_20_1, flag, time, arg_20_3)

			local extension_input = ScriptUnit.extension_input(arg_20_2, "dialogue_system")
			local alloc_table = FrameTable.alloc_table()

			extension_input:trigger_networked_dialogue_event("curse_damage_taken", alloc_table)
		end
	end,
	client_start_function = function (self, arg_21_1)
		-- function 21
		local world = self.world
		local player = Managers.player
		local get_side_from_name

		arg_21_1.wwise_world, get_side_from_name = Managers.world:wwise_world(world), Managers.state.side:get_side_from_name("heroes")
		arg_21_1.local_player = player:local_player()
		arg_21_1.beam_start_variable_id = World.find_particles_variable(world, str_4, "start")
		arg_21_1.beam_end_variable_id = World.find_particles_variable(world, str_4, "end")
		arg_21_1.center_effect_id = nil
		arg_21_1.center_sound = nil
		arg_21_1.beam_effects = {}
		arg_21_1.hero_side = get_side_from_name
	end,
	client_update_function = function (self, arg_22_1, arg_22_2, arg_22_3)
		-- function 22
		local player_unit = arg_22_1.local_player.player_unit

		if not ALIVE[player_unit] then
			return
		end

		local beam_effects = arg_22_1.beam_effects
		local var_22_2 = fn_3(arg_22_1.hero_side.PLAYER_UNITS)

		if #var_22_2 > 1 then
			local world = self.world

			fn_7(arg_22_1)
			fn_11(arg_22_1, arg_22_2, arg_22_3)

			for i, v in ipairs(var_22_2) do
				fn_13(world, beam_effects, v)
				fn_8(self, arg_22_1, v)

				local is_knocked_down = ScriptUnit.extension(v, "status_system"):is_knocked_down()
				local is_knocked_down_2 = ScriptUnit.extension(player_unit, "status_system"):is_knocked_down()

				if not (player_unit == v or is_knocked_down or is_knocked_down_2) then
					local var_22_6 = POSITION_LOOKUP[v]
					local var_22_7 = POSITION_LOOKUP[player_unit]

					if Vector3.distance_squared(var_22_7, var_22_6) < math.pow(num_3, 2) then
						fn_9(self, arg_22_1, v)
					else
						fn_6(self, arg_22_1, v)
					end
				end
			end
		end

		fn_12(self, arg_22_1, beam_effects, #var_22_2)
	end,
	client_stop_function = function (arg_23_0, arg_23_1)
		-- function 23
		local beam_effects = arg_23_1.beam_effects

		for k, v in pairs(beam_effects) do
			fn_6(arg_23_0, arg_23_1, k)
		end
	end
}
