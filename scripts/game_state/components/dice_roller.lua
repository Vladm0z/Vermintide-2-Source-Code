-- chunkname: @scripts/game_state/components/dice_roller.lua

local var_0_0 = {
	{
		rot = 0,
		up = {
			0,
			1,
			0
		}
	},
	{
		up = {
			1,
			0,
			0
		},
		rot = math.pi / 2
	},
	{
		up = {
			0,
			1,
			0
		},
		rot = math.pi / 2
	},
	{
		up = {
			0,
			1,
			0
		},
		rot = -math.pi / 2
	},
	{
		up = {
			1,
			0,
			0
		},
		rot = -math.pi / 2
	},
	{
		up = {
			0,
			1,
			0
		},
		rot = math.pi
	},
	{
		up = {
			0,
			0,
			1
		},
		rot = math.pi / 2
	},
	{
		up = {
			0,
			0,
			1
		},
		rot = -math.pi / 2
	},
	{
		up = {
			0,
			0,
			1
		},
		rot = math.pi
	}
}
local var_0_1 = {
	{
		1,
		2,
		3,
		4,
		5,
		6
	},
	{
		5,
		1,
		8,
		7,
		9,
		2
	},
	{
		4,
		7,
		1,
		9,
		8,
		3
	},
	{
		3,
		8,
		9,
		1,
		7,
		4
	},
	{
		2,
		9,
		7,
		8,
		1,
		5
	},
	{
		6,
		5,
		4,
		3,
		2,
		1
	}
}
local var_0_2 = {
	"wood",
	"metal",
	"gold",
	"warpstone"
}
local var_0_3 = {
	gold = 3,
	metal = 4,
	warpstone = 1,
	wood = 5
}
local var_0_4 = {
	gold = "units/props/dice_bowl/dice_tier_04",
	metal = "units/props/dice_bowl/dice_tier_02",
	warpstone = "units/props/dice_bowl/dice_tier_05",
	wood = "units/props/dice_bowl/dice_tier_01"
}
local var_0_5 = {
	gold = 1.36,
	metal = 1.34,
	warpstone = 1.18,
	wood = 1.18
}
local var_0_6 = 0.03

DiceRoller = class(DiceRoller)

function DiceRoller.init(arg_1_0, arg_1_1, arg_1_2, arg_1_3, arg_1_4)
	arg_1_0.world = arg_1_1
	arg_1_0.simulation_world = Managers.world:create_world("dice_simulation", nil, nil, nil, Application.DISABLE_APEX_CLOTH, Application.DISABLE_RENDERING, Application.DISABLE_SOUND)

	local var_1_0
	local var_1_1
	local var_1_2
	local var_1_3
	local var_1_4
	local var_1_5 = false
	local var_1_6 = ScriptWorld.spawn_level(arg_1_0.simulation_world, "levels/dicegame/world", var_1_0, var_1_1, var_1_2, var_1_3, var_1_4, var_1_5)

	World.set_flow_callback_object(arg_1_0.simulation_world, arg_1_0)
	Level.spawn_background(var_1_6)

	arg_1_0.dice_units = {}
	arg_1_0.old_dice_units = {}
	arg_1_0.dice_keeper = arg_1_2
	arg_1_0.dice_types = {}
	arg_1_0.dice_results = {}
	arg_1_0.rewards = arg_1_3

	local var_1_7 = arg_1_2:get_dice()

	arg_1_0.dice_data = table.clone(var_1_7)

	local var_1_8 = World.units(arg_1_1)
	local var_1_9 = #var_1_8
	local var_1_10

	for iter_1_0 = 1, var_1_9 do
		local var_1_11 = var_1_8[iter_1_0]

		if Unit.get_data(var_1_11, "bowl_type") then
			var_1_10 = Unit.local_position(var_1_11, 0)

			break
		end
	end

	arg_1_0.dice_offset = Vector3Box(var_1_10)

	Managers.state.event:register(arg_1_0, "flow_callback_die_collision", "flow_callback_die_collision")

	arg_1_0.wwise_world = Managers.world:wwise_world(arg_1_1)
	arg_1_0.index = 1
	arg_1_0.timer = 0

	arg_1_0:_request_from_backend(arg_1_4)

	arg_1_0._glow_dice = {}
end

function DiceRoller.destroy(arg_2_0)
	if not arg_2_0.post_cleanup_done then
		arg_2_0:cleanup_post_roll()
	end
end

function DiceRoller._request_from_backend(arg_3_0, arg_3_1)
	local var_3_0 = Managers.state.difficulty:get_difficulty()
	local var_3_1 = arg_3_0.dice_keeper:get_dice()
	local var_3_2 = arg_3_0.rewards:get_level_start()
	local var_3_3 = arg_3_0.rewards:get_level_end(true)
	local var_3_4 = LevelHelper:current_level_settings().dlc_name

	Managers.backend:get_interface("items"):generate_item_server_loot(var_3_1, var_3_0, var_3_2, var_3_3, arg_3_1, var_3_4)
end

function DiceRoller.poll_for_backend_result(arg_4_0)
	if arg_4_0._got_backend_result then
		return true
	end

	local var_4_0, var_4_1, var_4_2, var_4_3 = Managers.backend:get_interface("items"):check_for_loot()

	if var_4_0 then
		arg_4_0._successes = var_4_0
		arg_4_0._reward_backend_id = var_4_2
		arg_4_0._win_list = var_4_1
		arg_4_0._got_backend_result = true
		arg_4_0._level_rewards = var_4_3

		return true
	end

	return false
end

function DiceRoller.dice(arg_5_0)
	return arg_5_0.dice_keeper:get_dice()
end

function DiceRoller.successes(arg_6_0)
	fassert(arg_6_0._got_backend_result, "Trying to roll dice before response from backend")

	return arg_6_0._successes
end

function DiceRoller.reward_backend_id(arg_7_0)
	fassert(arg_7_0._got_backend_result, "Trying to roll dice before response from backend")

	return arg_7_0._reward_backend_id
end

function DiceRoller.num_successes(arg_8_0)
	fassert(arg_8_0._got_backend_result, "Trying to roll dice before response from backend")

	local var_8_0 = 1

	for iter_8_0, iter_8_1 in pairs(arg_8_0._successes) do
		var_8_0 = var_8_0 + iter_8_1
	end

	return var_8_0
end

function DiceRoller.level_up_rewards(arg_9_0)
	fassert(arg_9_0._got_backend_result, "Trying get level up rewards before response from backend")

	return arg_9_0._level_rewards
end

function DiceRoller.win_list(arg_10_0)
	fassert(arg_10_0._got_backend_result, "Trying to roll dice before response from backend")

	return arg_10_0._win_list
end

function DiceRoller.reward_item_key(arg_11_0)
	fassert(arg_11_0._got_backend_result, "Trying to roll dice before response from backend")

	local var_11_0 = arg_11_0:num_successes()

	return arg_11_0._win_list[var_11_0]
end

function DiceRoller.flow_callback_die_collision(arg_12_0, arg_12_1)
	local var_12_0 = arg_12_1.touched_unit
	local var_12_1 = arg_12_1.touching_unit
	local var_12_2 = arg_12_1.impulse_force

	if Vector3.length(var_12_2) > 0.1 then
		if arg_12_0._dice_simulation_units[var_12_1] then
			arg_12_0._sound_events[#arg_12_0._sound_events] = "hud_dice_game_dice_collision"
		else
			arg_12_0._sound_events[#arg_12_0._sound_events] = "hud_dice_game_dice_collision_bucket"
		end
	end
end

function DiceRoller.is_rolling(arg_13_0)
	return arg_13_0.rolling
end

function DiceRoller.is_completed(arg_14_0)
	return arg_14_0.rolling_finished
end

function DiceRoller.has_rerolls(arg_15_0)
	return arg_15_0.needs_rerolls
end

local var_0_7 = {
	normal = "lvl1"
}

local function var_0_8(arg_16_0, arg_16_1)
	local var_16_0 = Unit.num_meshes(arg_16_0)

	for iter_16_0 = 0, var_16_0 - 1 do
		local var_16_1 = Unit.mesh(arg_16_0, iter_16_0)
		local var_16_2 = Mesh.num_materials(var_16_1)
		local var_16_3 = Mesh.material(var_16_1, "m_dice")

		Material.set_vector3(var_16_3, "emissive", arg_16_1)
	end
end

function DiceRoller._add_to_glow_list(arg_17_0, arg_17_1)
	arg_17_0._glow_dice[#arg_17_0._glow_dice + 1] = {
		time = 0,
		unit = arg_17_1
	}

	WwiseWorld.trigger_event(arg_17_0.wwise_world, "hud_dice_game_glow")
end

function DiceRoller._update_glow(arg_18_0, arg_18_1)
	local var_18_0 = Vector3(0.615, 0.208, 0.055)
	local var_18_1 = 0.2

	for iter_18_0, iter_18_1 in pairs(arg_18_0._glow_dice) do
		iter_18_1.time = iter_18_1.time + arg_18_1

		local var_18_2 = math.min(1, iter_18_1.time * var_18_1)
		local var_18_3 = var_18_0 / math.sirp(0, 1, var_18_2)

		var_0_8(iter_18_1.unit, var_18_3)
	end
end

function DiceRoller._create_success_table(arg_19_0, arg_19_1)
	local var_19_0 = {}

	arg_19_0.remaining_dice = arg_19_0.remaining_dice or table.clone(arg_19_0.dice_data)

	for iter_19_0, iter_19_1 in ipairs(var_0_2) do
		local var_19_1 = arg_19_0.remaining_dice[iter_19_1]
		local var_19_2 = arg_19_1[iter_19_1]
		local var_19_3 = 0

		for iter_19_2 = 1, var_19_1 do
			local var_19_4 = var_19_3 < var_19_2
			local var_19_5 = {
				dice_type = iter_19_1,
				success = var_19_4
			}

			var_19_0[#var_19_0 + 1] = var_19_5
			var_19_3 = var_19_4 and var_19_3 + 1 or var_19_3
		end
	end

	table.shuffle(var_19_0)

	arg_19_0._success_table = var_19_0
end

function DiceRoller.roll_dices(arg_20_0)
	fassert(arg_20_0._got_backend_result, "Trying to roll dice before response from backend")

	local var_20_0 = arg_20_0.world
	local var_20_1 = arg_20_0._dice_simulation_settings
	local var_20_2 = {}
	local var_20_3 = #var_20_1
	local var_20_4 = Vector3(var_0_6, var_0_6, var_0_6)

	for iter_20_0 = 1, var_20_3 do
		local var_20_5 = var_20_1[iter_20_0]
		local var_20_6 = var_20_5.dice_type
		local var_20_7 = var_0_4[var_20_6] .. "_no_physics"
		local var_20_8 = var_20_5.initial_position:unbox() * var_0_6
		local var_20_9 = var_20_5.initial_rotation:unbox()
		local var_20_10 = World.spawn_unit(var_20_0, var_20_7, var_20_8, var_20_9)

		Unit.set_local_scale(var_20_10, 0, var_20_4)

		var_20_2[var_20_10] = var_20_5
	end

	local var_20_11 = WwiseWorld.trigger_event(arg_20_0.wwise_world, "hud_dice_game_roll_many")

	arg_20_0.rolling = true
	arg_20_0.roll_time = 0
	arg_20_0.dice_units = var_20_2

	table.clear(arg_20_0.dice_results)

	return #var_20_1
end

function DiceRoller.simulate_dice_rolls(arg_21_0, arg_21_1)
	fassert(arg_21_0._got_backend_result, "Trying to roll dice before response from backend")

	if not arg_21_0._success_table then
		arg_21_0:_create_success_table(arg_21_1)
	end

	local var_21_0 = table.clone(arg_21_0._success_table)
	local var_21_1 = arg_21_0.simulation_world
	local var_21_2 = #var_21_0

	arg_21_0._sound_events = {}
	arg_21_0._dice_simulation_units = {}

	local var_21_3 = {}

	for iter_21_0 = 1, var_21_2 do
		local var_21_4 = false
		local var_21_5 = Vector3(16, 0, 0) + Vector3(math.random() / 20, math.random() / 20, 0.07) * 100

		for iter_21_1 = 1, #var_21_3 do
			repeat
				if Vector3.length(var_21_5 - var_21_3[iter_21_1]) < 2 then
					var_21_4 = false
					var_21_5 = var_21_5 + Vector3(math.random(-1, 1) / 20, math.random(-1, 1) / 20, 0) * 50
				else
					var_21_4 = true
				end
			until var_21_4
		end

		var_21_3[iter_21_0] = var_21_5
	end

	for iter_21_2 = 1, var_21_2 do
		local var_21_6 = var_21_0[iter_21_2]
		local var_21_7 = var_21_6.dice_type
		local var_21_8 = var_21_6.success
		local var_21_9 = var_0_0[math.random(1, 6)]
		local var_21_10 = Vector3(unpack(var_21_9.up))
		local var_21_11 = var_21_9.rot
		local var_21_12 = Quaternion.axis_angle(var_21_10, var_21_11)
		local var_21_13 = var_0_4[var_21_7]
		local var_21_14 = World.spawn_unit(var_21_1, var_21_13, var_21_3[iter_21_2], var_21_12)

		arg_21_0._dice_simulation_units[var_21_14] = true

		local var_21_15 = Unit.actor(var_21_14, 0)

		Unit.set_unit_visibility(var_21_14, false)
		Actor.wake_up(var_21_15)
		Actor.set_velocity(var_21_15, Vector3(-0.25, -0.5, -0.07) * 65)

		local var_21_16 = var_21_8 and math.random(var_0_3[var_21_7], 6) or math.random(1, var_0_3[var_21_7] - 1)

		var_21_0[iter_21_2] = {
			dice_result = 0,
			unit = var_21_14,
			dice_type = var_21_7,
			initial_position = Vector3Box(var_21_3[iter_21_2]),
			initial_rotation = QuaternionBox(var_21_12),
			wanted_dice_result = var_21_16,
			success = var_21_8,
			positions = {},
			rotations = {}
		}
	end

	local var_21_17 = arg_21_0:run_simulation(var_21_0)

	if var_21_17 then
		arg_21_0:calculate_results(var_21_0)
		arg_21_0:alter_rotations(var_21_0)

		arg_21_0._dice_simulation_settings = var_21_0
	end

	local var_21_18 = #var_21_0

	for iter_21_3 = 1, var_21_18 do
		local var_21_19 = var_21_0[iter_21_3]

		World.destroy_unit(var_21_1, var_21_19.unit)

		var_21_19.unit = nil
	end

	return var_21_17
end

function DiceRoller.run_simulation(arg_22_0, arg_22_1)
	fassert(arg_22_0._got_backend_result, "Trying to roll dice before response from backend")

	local var_22_0 = arg_22_0.simulation_world
	local var_22_1 = false
	local var_22_2 = false
	local var_22_3 = 0
	local var_22_4 = #arg_22_1

	while not var_22_1 do
		local var_22_5, var_22_6, var_22_7 = Script.temp_count()

		World.update_scene(var_22_0, 0.03333333333333333)

		local var_22_8 = 0
		local var_22_9 = false

		arg_22_0._sound_events[#arg_22_0._sound_events + 1] = false

		for iter_22_0 = 1, var_22_4 do
			local var_22_10 = arg_22_1[iter_22_0]
			local var_22_11 = var_22_10.unit
			local var_22_12 = Unit.actor(var_22_11, 0)
			local var_22_13 = Actor.velocity(var_22_12)
			local var_22_14 = #var_22_10.positions + 1

			var_22_10.positions[var_22_14] = Vector3Box(Unit.local_position(var_22_11, 0))
			var_22_10.rotations[var_22_14] = QuaternionBox(Unit.local_rotation(var_22_11, 0))

			if Vector3.length(var_22_13) < 0.001 then
				var_22_8 = var_22_8 + 1

				if arg_22_0:get_dice_result(var_22_11, var_22_10.dice_type) == 0 then
					var_22_9 = true
				end

				if not var_22_10.completed_index then
					var_22_10.completed_index = var_22_14
				end
			end
		end

		if var_22_8 == var_22_4 then
			var_22_1 = true
			var_22_2 = true
		end

		var_22_3 = var_22_3 + 1

		if var_22_3 == 200 or var_22_1 and var_22_9 then
			print("dice game broke, rerunning")

			var_22_1 = true
			var_22_2 = false
		end

		Script.set_temp_count(var_22_5, var_22_6, var_22_7)
	end

	return var_22_2
end

function DiceRoller.calculate_results(arg_23_0, arg_23_1)
	local var_23_0 = #arg_23_1

	for iter_23_0 = 1, var_23_0 do
		local var_23_1 = arg_23_1[iter_23_0]
		local var_23_2 = var_23_1.unit

		var_23_1.dice_result = arg_23_0:get_dice_result(var_23_2, var_23_1.dice_type)
	end
end

function DiceRoller.get_dice_result(arg_24_0, arg_24_1, arg_24_2)
	local var_24_0 = Unit.world_pose(arg_24_1, 0)
	local var_24_1 = Matrix4x4.up(var_24_0)
	local var_24_2 = Matrix4x4.forward(var_24_0)
	local var_24_3 = Matrix4x4.right(var_24_0)
	local var_24_4 = -var_24_3
	local var_24_5 = -var_24_1
	local var_24_6 = -var_24_2
	local var_24_7 = math.max(var_24_1.z, var_24_2.z, var_24_3.z, var_24_5.z, var_24_4.z, var_24_6.z)
	local var_24_8

	if var_24_1.z == var_24_7 then
		var_24_8 = 1
	elseif var_24_2.z == var_24_7 then
		var_24_8 = 2
	elseif var_24_3.z == var_24_7 then
		var_24_8 = 4
	elseif var_24_5.z == var_24_7 then
		var_24_8 = 6
	elseif var_24_4.z == var_24_7 then
		var_24_8 = 3
	elseif var_24_6.z == var_24_7 then
		var_24_8 = 5
	end

	if Unit.world_position(arg_24_1, 0).z >= var_0_5[arg_24_2] then
		var_24_8 = 0
	end

	return var_24_8
end

function DiceRoller.alter_rotations(arg_25_0, arg_25_1)
	local var_25_0 = #arg_25_1

	for iter_25_0 = 1, var_25_0 do
		repeat
			local var_25_1 = arg_25_1[iter_25_0]
			local var_25_2 = var_25_1.wanted_dice_result
			local var_25_3 = var_25_1.dice_result
			local var_25_4 = var_25_1.initial_rotation:unbox()

			if var_25_3 == 0 then
				break
			end

			local var_25_5 = var_0_1[var_25_3][var_25_2]
			local var_25_6 = var_0_0[var_25_5]
			local var_25_7 = Vector3(unpack(var_25_6.up))
			local var_25_8 = var_25_6.rot
			local var_25_9 = Quaternion.axis_angle(var_25_7, var_25_8)

			var_25_1.initial_rotation:store(Quaternion.multiply(var_25_4, var_25_9))

			local var_25_10 = var_25_1.rotations
			local var_25_11 = #var_25_10

			for iter_25_1 = 1, var_25_11 do
				local var_25_12 = var_25_10[iter_25_1]:unbox()
				local var_25_13 = Quaternion.multiply(var_25_12, var_25_9)

				var_25_10[iter_25_1] = QuaternionBox(var_25_13)
			end
		until true
	end
end

function DiceRoller.get_dice_results(arg_26_0)
	return arg_26_0.num_successes
end

function DiceRoller.update(arg_27_0, arg_27_1)
	if not arg_27_0.rolling then
		return
	end

	local var_27_0 = arg_27_0.roll_time + arg_27_1
	local var_27_1 = arg_27_0.dice_units
	local var_27_2 = 0
	local var_27_3 = arg_27_0.dice_offset:unbox()

	for iter_27_0, iter_27_1 in pairs(var_27_1) do
		local var_27_4 = iter_27_1.positions
		local var_27_5 = iter_27_1.rotations
		local var_27_6 = #var_27_4
		local var_27_7 = var_27_0 / (var_27_6 * 0.016666666666666666)
		local var_27_8 = math.min(var_27_7 * var_27_6, var_27_6)
		local var_27_9 = math.max(math.floor(var_27_8), 1)
		local var_27_10 = math.min(math.max(math.ceil(var_27_8), 1), var_27_6)
		local var_27_11 = var_27_8 - var_27_9
		local var_27_12 = (var_27_4[var_27_9]:unbox() - var_27_3) * var_0_6 + var_27_3
		local var_27_13 = (var_27_4[var_27_10]:unbox() - var_27_3) * var_0_6 + var_27_3
		local var_27_14 = Vector3.lerp(var_27_12, var_27_13, var_27_11)
		local var_27_15 = var_27_5[var_27_9]:unbox()
		local var_27_16 = var_27_5[var_27_10]:unbox()
		local var_27_17 = Quaternion.lerp(var_27_15, var_27_16, var_27_11)

		Unit.set_local_position(iter_27_0, 0, var_27_14)
		Unit.set_local_rotation(iter_27_0, 0, var_27_17)

		if var_27_9 >= iter_27_1.completed_index and iter_27_1.success and not iter_27_1.highlighted then
			arg_27_0:_add_to_glow_list(iter_27_0)

			iter_27_1.highlighted = true
		end

		local var_27_18 = arg_27_0._sound_events[var_27_9]

		if var_27_18 then
			WwiseWorld.trigger_event(arg_27_0.wwise_world, var_27_18)

			arg_27_0._sound_events[var_27_9] = false
		end

		if var_27_8 == var_27_6 then
			var_27_2 = var_27_2 + 1
		end
	end

	arg_27_0:_update_glow(arg_27_1)

	if var_27_2 == table.size(var_27_1) then
		if not arg_27_0.grace_time then
			arg_27_0.grace_time = 0
		elseif arg_27_0.grace_time >= 1.5 then
			arg_27_0.rolling = false
			arg_27_0.rolling_finished = arg_27_0:cleanup_post_roll()
			arg_27_0.grace_time = nil
		else
			arg_27_0.grace_time = arg_27_0.grace_time + arg_27_1
		end
	end

	arg_27_0.roll_time = var_27_0
end

function DiceRoller.cleanup_post_roll(arg_28_0)
	local var_28_0 = arg_28_0.dice_units
	local var_28_1 = {}
	local var_28_2 = 0

	arg_28_0.needs_rerolls = false

	for iter_28_0, iter_28_1 in pairs(var_28_0) do
		var_28_1[#var_28_1 + 1] = iter_28_0

		if iter_28_1.dice_result ~= 0 then
			arg_28_0.remaining_dice[iter_28_1.dice_type] = arg_28_0.remaining_dice[iter_28_1.dice_type] - 1
			var_28_2 = var_28_2 + 1
		else
			local var_28_3 = arg_28_0.remaining_dice[iter_28_1.dice_type].successes or 0

			arg_28_0.remaining_dice[iter_28_1.dice_type].successes = iter_28_1.success and var_28_3 + 1 or var_28_3
			arg_28_0.needs_rerolls = true
		end
	end

	local var_28_4 = #var_28_1

	if arg_28_0.needs_rerolls then
		for iter_28_2 = 1, var_28_4 do
			local var_28_5 = var_28_1[iter_28_2]

			arg_28_0.dice_units[var_28_5] = nil

			World.destroy_unit(arg_28_0.world, var_28_5)
		end
	end

	Managers.world:destroy_world(arg_28_0.simulation_world)

	arg_28_0.post_cleanup_done = true

	return var_28_2 == var_28_4
end

if Development.parameter("dice_chance_simulation") then
	local var_0_9 = {
		{
			7,
			0,
			0,
			0
		},
		{
			6,
			0,
			1,
			0
		},
		{
			6,
			1,
			0,
			0
		},
		{
			6,
			0,
			0,
			1
		},
		{
			5,
			0,
			2,
			0
		},
		{
			5,
			2,
			0,
			0
		},
		{
			5,
			0,
			0,
			2
		},
		{
			5,
			1,
			1,
			0
		},
		{
			5,
			0,
			1,
			1
		},
		{
			5,
			1,
			0,
			1
		},
		{
			4,
			0,
			3,
			0
		},
		{
			4,
			1,
			2,
			0
		},
		{
			4,
			0,
			2,
			1
		},
		{
			4,
			2,
			1,
			0
		},
		{
			4,
			0,
			1,
			2
		},
		{
			4,
			1,
			1,
			1
		},
		{
			4,
			1,
			0,
			2
		},
		{
			4,
			2,
			0,
			1
		},
		{
			3,
			1,
			3,
			0
		},
		{
			3,
			0,
			3,
			1
		},
		{
			3,
			2,
			2,
			0
		},
		{
			3,
			0,
			2,
			2
		},
		{
			3,
			1,
			2,
			1
		},
		{
			3,
			2,
			1,
			1
		},
		{
			3,
			1,
			1,
			2
		},
		{
			3,
			2,
			0,
			2
		},
		{
			2,
			2,
			3,
			0
		},
		{
			2,
			0,
			3,
			2
		},
		{
			2,
			1,
			3,
			1
		},
		{
			2,
			2,
			2,
			1
		},
		{
			2,
			1,
			2,
			2
		},
		{
			2,
			2,
			1,
			2
		},
		{
			1,
			2,
			3,
			1
		},
		{
			1,
			1,
			3,
			2
		},
		{
			1,
			2,
			2,
			2
		},
		{
			0,
			2,
			3,
			2
		}
	}
	local var_0_10 = {
		0.3333333333333333,
		0.5,
		0.6666666666666666,
		1
	}
	local var_0_11 = {}
	local var_0_12 = 20

	for iter_0_0 = 1, #var_0_9 do
		local var_0_13 = var_0_9[iter_0_0]
		local var_0_14 = {}

		for iter_0_1 = 1, var_0_12 do
			local var_0_15 = 0

			for iter_0_2 = 1, 4 do
				local var_0_16 = var_0_13[iter_0_2]
				local var_0_17 = var_0_10[iter_0_2]

				for iter_0_3 = 1, var_0_16 do
					if var_0_17 > math.random() then
						var_0_15 = var_0_15 + 1
					end
				end
			end

			if not var_0_14[var_0_15] then
				var_0_14[var_0_15] = 0
			end

			var_0_14[var_0_15] = var_0_14[var_0_15] + 1
		end

		for iter_0_4 = 0, 7 do
			if var_0_14[iter_0_4] then
				var_0_14[iter_0_4] = math.round_with_precision(var_0_14[iter_0_4] / var_0_12 * 100, 3) .. "%"
			end
		end

		print("-----")
		table.dump(var_0_14)
	end
end
