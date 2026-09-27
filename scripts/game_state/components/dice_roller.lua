-- chunkname: @scripts/game_state/components/dice_roller.lua

local tbl = {
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
local tbl_2 = {
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
local tbl_3 = {
	"wood",
	"metal",
	"gold",
	"warpstone"
}
local tbl_4 = {
	gold = 3,
	metal = 4,
	warpstone = 1,
	wood = 5
}
local tbl_5 = {
	gold = "units/props/dice_bowl/dice_tier_04",
	metal = "units/props/dice_bowl/dice_tier_02",
	warpstone = "units/props/dice_bowl/dice_tier_05",
	wood = "units/props/dice_bowl/dice_tier_01"
}
local tbl_6 = {
	gold = 1.36,
	metal = 1.34,
	warpstone = 1.18,
	wood = 1.18
}
local num = 0.03

DiceRoller = class(DiceRoller)

DiceRoller.init = function (self, arg_1_1, arg_1_2, arg_1_3, arg_1_4)
	-- function 1
	self.world = arg_1_1
	self.simulation_world = Managers.world:create_world("dice_simulation", nil, nil, nil, Application.DISABLE_APEX_CLOTH, Application.DISABLE_RENDERING, Application.DISABLE_SOUND)

	local var_1_0
	local var_1_1
	local var_1_2
	local var_1_3
	local var_1_4
	local flag = false
	local spawn_level = ScriptWorld.spawn_level(self.simulation_world, "levels/dicegame/world", var_1_0, var_1_1, var_1_2, var_1_3, var_1_4, flag)

	World.set_flow_callback_object(self.simulation_world, self)
	Level.spawn_background(spawn_level)

	self.dice_units = {}
	self.old_dice_units = {}
	self.dice_keeper = arg_1_2
	self.dice_types = {}
	self.dice_results = {}
	self.rewards = arg_1_3

	local get_dice = arg_1_2:get_dice()

	self.dice_data = table.clone(get_dice)

	local units = World.units(arg_1_1)
	local count = #units
	local var_1_10

	for i = 1, count do
		local var_1_11 = units[i]

		if not Unit.get_data(var_1_11, "bowl_type") then
			var_1_10 = Unit.local_position(var_1_11, 0)

			break
		end
	end

	self.dice_offset = Vector3Box(var_1_10)

	Managers.state.event:register(self, "flow_callback_die_collision", "flow_callback_die_collision")

	self.wwise_world = Managers.world:wwise_world(arg_1_1)
	self.index = 1
	self.timer = 0

	self:_request_from_backend(arg_1_4)

	self._glow_dice = {}
end

DiceRoller.destroy = function (self)
	-- function 2
	if not self.post_cleanup_done then
		self:cleanup_post_roll()
	end
end

DiceRoller._request_from_backend = function (self, arg_3_1)
	-- function 3
	local get_difficulty = Managers.state.difficulty:get_difficulty()
	local get_dice = self.dice_keeper:get_dice()
	local get_level_start = self.rewards:get_level_start()
	local get_level_end = self.rewards:get_level_end(true)
	local dlc_name = LevelHelper:current_level_settings().dlc_name

	Managers.backend:get_interface("items"):generate_item_server_loot(get_dice, get_difficulty, get_level_start, get_level_end, arg_3_1, dlc_name)
end

DiceRoller.poll_for_backend_result = function (self)
	-- function 4
	if not self._got_backend_result then
		return true
	end

	local check_for_loot, var_4_1, var_4_2, var_4_3 = Managers.backend:get_interface("items"):check_for_loot()

	if not check_for_loot then
		self._successes = check_for_loot
		self._reward_backend_id = var_4_2
		self._win_list = var_4_1
		self._got_backend_result = true
		self._level_rewards = var_4_3

		return true
	end

	return false
end

DiceRoller.dice = function (self)
	-- function 5
	return self.dice_keeper:get_dice()
end

DiceRoller.successes = function (self)
	-- function 6
	fassert(self._got_backend_result, "Trying to roll dice before response from backend")

	return self._successes
end

DiceRoller.reward_backend_id = function (self)
	-- function 7
	fassert(self._got_backend_result, "Trying to roll dice before response from backend")

	return self._reward_backend_id
end

DiceRoller.num_successes = function (self)
	-- function 8
	fassert(self._got_backend_result, "Trying to roll dice before response from backend")

	local num = 1

	for k, v in pairs(self._successes) do
		num = num + v
	end

	return num
end

DiceRoller.level_up_rewards = function (self)
	-- function 9
	fassert(self._got_backend_result, "Trying get level up rewards before response from backend")

	return self._level_rewards
end

DiceRoller.win_list = function (self)
	-- function 10
	fassert(self._got_backend_result, "Trying to roll dice before response from backend")

	return self._win_list
end

DiceRoller.reward_item_key = function (self)
	-- function 11
	fassert(self._got_backend_result, "Trying to roll dice before response from backend")

	local num_successes = self:num_successes()

	return self._win_list[num_successes]
end

DiceRoller.flow_callback_die_collision = function (self, arg_12_1)
	-- function 12
	local touched_unit = arg_12_1.touched_unit
	local touching_unit = arg_12_1.touching_unit
	local impulse_force = arg_12_1.impulse_force

	if Vector3.length(impulse_force) > 0.1 then
		if not self._dice_simulation_units[touching_unit] then
			self._sound_events[#self._sound_events] = "hud_dice_game_dice_collision"
		else
			self._sound_events[#self._sound_events] = "hud_dice_game_dice_collision_bucket"
		end
	end
end

DiceRoller.is_rolling = function (self)
	-- function 13
	return self.rolling
end

DiceRoller.is_completed = function (self)
	-- function 14
	return self.rolling_finished
end

DiceRoller.has_rerolls = function (self)
	-- function 15
	return self.needs_rerolls
end

local tbl_7 = {
	normal = "lvl1"
}

local function fn(arg_16_0, arg_16_1)
	-- function 16
	local num_meshes = Unit.num_meshes(arg_16_0)

	for i = 0, num_meshes - 1 do
		local mesh = Unit.mesh(arg_16_0, i)
		local num_materials = Mesh.num_materials(mesh)
		local material = Mesh.material(mesh, "m_dice")

		Material.set_vector3(material, "emissive", arg_16_1)
	end
end

DiceRoller._add_to_glow_list = function (self, arg_17_1)
	-- function 17
	self._glow_dice[#self._glow_dice + 1] = {
		time = 0,
		unit = arg_17_1
	}

	WwiseWorld.trigger_event(self.wwise_world, "hud_dice_game_glow")
end

DiceRoller._update_glow = function (self, arg_18_1)
	-- function 18
	local var_18_0 = Vector3(0.615, 0.208, 0.055)
	local num = 0.2

	for k, v in pairs(self._glow_dice) do
		v.time = v.time + arg_18_1

		local min = math.min(1, v.time * num)
		local num_2 = var_18_0 / math.sirp(0, 1, min)

		fn(v.unit, num_2)
	end
end

DiceRoller._create_success_table = function (self, arg_19_1)
	-- function 19
	local tbl = {}
	local remaining_dice = self.remaining_dice

	remaining_dice = remaining_dice or table.clone(self.dice_data)
	self.remaining_dice = remaining_dice

	for i, v in ipairs(tbl_3) do
		local var_19_2 = self.remaining_dice[v]
		local var_19_3 = arg_19_1[v]
		local num = 0

		for k = 1, var_19_2 do
			local flag = num < var_19_3
			local tbl_2 = {
				dice_type = v,
				success = flag
			}

			tbl[#tbl + 1] = tbl_2
			num = not flag and num + 1 and num
		end
	end

	table.shuffle(tbl)

	self._success_table = tbl
end

DiceRoller.roll_dices = function (self)
	-- function 20
	fassert(self._got_backend_result, "Trying to roll dice before response from backend")

	local world = self.world
	local _dice_simulation_settings = self._dice_simulation_settings
	local tbl = {}
	local count = #_dice_simulation_settings
	local var_20_4 = Vector3(num, num, num)

	for i = 1, count do
		local var_20_5 = _dice_simulation_settings[i]
		local dice_type = var_20_5.dice_type
		local str = tbl_5[dice_type] .. "_no_physics"
		local num_2 = var_20_5.initial_position:unbox() * num
		local unbox = var_20_5.initial_rotation:unbox()
		local spawn_unit = World.spawn_unit(world, str, num_2, unbox)

		Unit.set_local_scale(spawn_unit, 0, var_20_4)

		tbl[spawn_unit] = var_20_5
	end

	local trigger_event = WwiseWorld.trigger_event(self.wwise_world, "hud_dice_game_roll_many")

	self.rolling = true
	self.roll_time = 0
	self.dice_units = tbl

	table.clear(self.dice_results)

	return #_dice_simulation_settings
end

DiceRoller.simulate_dice_rolls = function (self, arg_21_1)
	-- function 21
	fassert(self._got_backend_result, "Trying to roll dice before response from backend")

	if not self._success_table then
		self:_create_success_table(arg_21_1)
	end

	local clone = table.clone(self._success_table)
	local simulation_world = self.simulation_world
	local count = #clone

	self._sound_events = {}
	self._dice_simulation_units = {}

	local tbl_2 = {}

	for i = 1, count do
		local flag = false
		local num = Vector3(16, 0, 0) + Vector3(math.random() / 20, math.random() / 20, 0.07) * 100

		for j = 1, #tbl_2 do
			repeat
				if Vector3.length(num - tbl_2[j]) < 2 then
					flag = false
					num = num + Vector3(math.random(-1, 1) / 20, math.random(-1, 1) / 20, 0) * 50
				else
					flag = true
				end
			until not flag
		end

		tbl_2[i] = num
	end

	for k = 1, count do
		local var_21_6 = clone[k]
		local dice_type = var_21_6.dice_type
		local success = var_21_6.success
		local var_21_9 = tbl[math.random(1, 6)]
		local var_21_10 = Vector3(unpack(var_21_9.up))
		local rot = var_21_9.rot
		local axis_angle = Quaternion.axis_angle(var_21_10, rot)
		local var_21_13 = tbl_5[dice_type]
		local spawn_unit = World.spawn_unit(simulation_world, var_21_13, tbl_2[k], axis_angle)

		self._dice_simulation_units[spawn_unit] = true

		local actor = Unit.actor(spawn_unit, 0)

		Unit.set_unit_visibility(spawn_unit, false)
		Actor.wake_up(actor)
		Actor.set_velocity(actor, Vector3(-0.25, -0.5, -0.07) * 65)

		local random

		if not success then
			random = math.random(tbl_4[dice_type], 6)

			if not random then
				-- Nothing
			end
		end

		random = math.random(1, tbl_4[dice_type] - 1)

		::label_21_0::

		clone[k] = {
			dice_result = 0,
			unit = spawn_unit,
			dice_type = dice_type,
			initial_position = Vector3Box(tbl_2[k]),
			initial_rotation = QuaternionBox(axis_angle),
			wanted_dice_result = random,
			success = success,
			positions = {},
			rotations = {}
		}
	end

	local run_simulation = self:run_simulation(clone)

	if not run_simulation then
		self:calculate_results(clone)
		self:alter_rotations(clone)

		self._dice_simulation_settings = clone
	end

	local count_2 = #clone

	for l = 1, count_2 do
		local var_21_19 = clone[l]

		World.destroy_unit(simulation_world, var_21_19.unit)

		var_21_19.unit = nil
	end

	return run_simulation
end

DiceRoller.run_simulation = function (self, arg_22_1)
	-- function 22
	fassert(self._got_backend_result, "Trying to roll dice before response from backend")

	local simulation_world = self.simulation_world
	local flag = false
	local flag_2 = false
	local num = 0
	local count = #arg_22_1

	while not flag do
		local temp_count, var_22_6, var_22_7 = Script.temp_count()

		World.update_scene(simulation_world, 0.03333333333333333)

		local num_2 = 0
		local flag_3 = false

		self._sound_events[#self._sound_events + 1] = false

		for i = 1, count do
			local var_22_10 = arg_22_1[i]
			local unit = var_22_10.unit
			local actor = Unit.actor(unit, 0)
			local velocity = Actor.velocity(actor)
			local num_3 = #var_22_10.positions + 1

			var_22_10.positions[num_3] = Vector3Box(Unit.local_position(unit, 0))
			var_22_10.rotations[num_3] = QuaternionBox(Unit.local_rotation(unit, 0))

			if Vector3.length(velocity) < 0.001 then
				num_2 = num_2 + 1

				if self:get_dice_result(unit, var_22_10.dice_type) == 0 then
					flag_3 = true
				end

				if not var_22_10.completed_index then
					var_22_10.completed_index = num_3
				end
			end
		end

		if num_2 == count then
			flag = true
			flag_2 = true
		end

		num = num + 1

		if num == 200 or not flag or not flag_3 then
			print("dice game broke, rerunning")

			flag = true
			flag_2 = false
		end

		Script.set_temp_count(temp_count, var_22_6, var_22_7)
	end

	return flag_2
end

DiceRoller.calculate_results = function (self, arg_23_1)
	-- function 23
	local count = #arg_23_1

	for i = 1, count do
		local var_23_1 = arg_23_1[i]
		local unit = var_23_1.unit

		var_23_1.dice_result = self:get_dice_result(unit, var_23_1.dice_type)
	end
end

DiceRoller.get_dice_result = function (arg_24_0, arg_24_1, arg_24_2)
	-- function 24
	local world_pose = Unit.world_pose(arg_24_1, 0)
	local up = Matrix4x4.up(world_pose)
	local forward = Matrix4x4.forward(world_pose)
	local right = Matrix4x4.right(world_pose)
	local num = -right
	local num_2 = -up
	local num_3 = -forward
	local max = math.max(up.z, forward.z, right.z, num_2.z, num.z, num_3.z)
	local var_24_8

	if up.z == max then
		var_24_8 = 1
	elseif forward.z == max then
		var_24_8 = 2
	elseif right.z == max then
		var_24_8 = 4
	elseif num_2.z == max then
		var_24_8 = 6
	elseif num.z == max then
		var_24_8 = 3
	elseif num_3.z == max then
		var_24_8 = 5
	end

	if Unit.world_position(arg_24_1, 0).z >= tbl_6[arg_24_2] then
		var_24_8 = 0
	end

	return var_24_8
end

DiceRoller.alter_rotations = function (arg_25_0, arg_25_1)
	-- function 25
	local count = #arg_25_1

	for i = 1, count do
		repeat
			local var_25_1 = arg_25_1[i]
			local wanted_dice_result = var_25_1.wanted_dice_result
			local dice_result = var_25_1.dice_result
			local unbox = var_25_1.initial_rotation:unbox()

			if dice_result == 0 then
				break
			end

			local var_25_5 = tbl_2[dice_result][wanted_dice_result]
			local var_25_6 = tbl[var_25_5]
			local var_25_7 = Vector3(unpack(var_25_6.up))
			local rot = var_25_6.rot
			local axis_angle = Quaternion.axis_angle(var_25_7, rot)

			var_25_1.initial_rotation:store(Quaternion.multiply(unbox, axis_angle))

			local rotations = var_25_1.rotations
			local count_2 = #rotations

			for j = 1, count_2 do
				local unbox_2 = rotations[j]:unbox()
				local multiply = Quaternion.multiply(unbox_2, axis_angle)

				rotations[j] = QuaternionBox(multiply)
			end
		until true
	end
end

DiceRoller.get_dice_results = function (self)
	-- function 26
	return self.num_successes
end

DiceRoller.update = function (self, arg_27_1)
	-- function 27
	if not self.rolling then
		return
	end

	local num_2 = self.roll_time + arg_27_1
	local dice_units = self.dice_units
	local num_3 = 0
	local unbox = self.dice_offset:unbox()

	for k, v in pairs(dice_units) do
		local positions = v.positions
		local rotations = v.rotations
		local count = #positions
		local num_4 = num_2 / (count * 0.016666666666666666)
		local min = math.min(num_4 * count, count)
		local max = math.max(math.floor(min), 1)
		local min_2 = math.min(math.max(math.ceil(min), 1), count)
		local num_5 = min - max
		local num_6 = (positions[max]:unbox() - unbox) * num + unbox
		local num_7 = (positions[min_2]:unbox() - unbox) * num + unbox
		local lerp = Vector3.lerp(num_6, num_7, num_5)
		local unbox_2 = rotations[max]:unbox()
		local unbox_3 = rotations[min_2]:unbox()
		local lerp_2 = Quaternion.lerp(unbox_2, unbox_3, num_5)

		Unit.set_local_position(k, 0, lerp)
		Unit.set_local_rotation(k, 0, lerp_2)

		if not ((not (max >= v.completed_index) or not v.success) and v.highlighted) then
			self:_add_to_glow_list(k)

			v.highlighted = true
		end

		local var_27_18 = self._sound_events[max]

		if not var_27_18 then
			WwiseWorld.trigger_event(self.wwise_world, var_27_18)

			self._sound_events[max] = false
		end

		if min == count then
			num_3 = num_3 + 1
		end
	end

	self:_update_glow(arg_27_1)

	if num_3 == table.size(dice_units) then
		if not self.grace_time then
			self.grace_time = 0
		elseif self.grace_time >= 1.5 then
			self.rolling = false
			self.rolling_finished = self:cleanup_post_roll()
			self.grace_time = nil
		else
			self.grace_time = self.grace_time + arg_27_1
		end
	end

	self.roll_time = num_2
end

DiceRoller.cleanup_post_roll = function (self)
	-- function 28
	local dice_units = self.dice_units
	local tbl = {}
	local num = 0

	self.needs_rerolls = false

	for k, v in pairs(dice_units) do
		tbl[#tbl + 1] = k

		if v.dice_result ~= 0 then
			self.remaining_dice[v.dice_type] = self.remaining_dice[v.dice_type] - 1
			num = num + 1
		else
			local successes = self.remaining_dice[v.dice_type].successes

			successes = successes or 0

			local var_28_4 = self.remaining_dice[v.dice_type]
			local num_2

			if not v.success then
				num_2 = successes + 1

				if not num_2 then
					-- Nothing
				end
			end

			num_2 = successes

			::label_28_0::

			var_28_4.successes = num_2
			self.needs_rerolls = true
		end
	end

	local count = #tbl

	if not self.needs_rerolls then
		for k_2 = 1, count do
			local var_28_7 = tbl[k_2]

			self.dice_units[var_28_7] = nil

			World.destroy_unit(self.world, var_28_7)
		end
	end

	Managers.world:destroy_world(self.simulation_world)

	self.post_cleanup_done = true

	return num == count
end

if not Development.parameter("dice_chance_simulation") then
	local tbl_8 = {
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
	local tbl_9 = {
		0.3333333333333333,
		0.5,
		0.6666666666666666,
		1
	}
	local tbl_10 = {}
	local num_2 = 20

	for i = 1, #tbl_8 do
		local var_0_13 = tbl_8[i]
		local tbl_11 = {}

		for j = 1, num_2 do
			local num_3 = 0

			for k = 1, 4 do
				local var_0_16 = var_0_13[k]
				local var_0_17 = tbl_9[k]

				for l = 1, var_0_16 do
					if var_0_17 > math.random() then
						num_3 = num_3 + 1
					end
				end
			end

			if not tbl_11[num_3] then
				tbl_11[num_3] = 0
			end

			tbl_11[num_3] = tbl_11[num_3] + 1
		end

		for i4 = 0, 7 do
			if not tbl_11[i4] then
				tbl_11[i4] = math.round_with_precision(tbl_11[i4] / num_2 * 100, 3) .. "%"
			end
		end

		print("-----")
		table.dump(tbl_11)
	end
end
