-- chunkname: @scripts/unit_extensions/generic/ladder_extension.lua

LadderExtension = class(LadderExtension)

function LadderExtension.init(arg_1_0, arg_1_1, arg_1_2, arg_1_3)
	arg_1_0._world = arg_1_1.world
	arg_1_0._unit = arg_1_2
	arg_1_0._is_server = Managers.state.network.is_server
	arg_1_0._seed_x = Math.random()
	arg_1_0._seed_y = Math.random()
	arg_1_0._node = Unit.get_data(arg_1_2, "ladder_shake_node") or 0
	arg_1_0._enable_shake = not Unit.get_data(arg_1_2, "disable_shake")
	arg_1_0._start_position = Vector3Box(Unit.world_position(arg_1_0._unit, arg_1_0._node))
	arg_1_0._top_position = Vector3Box(Unit.world_position(arg_1_2, Unit.node(arg_1_2, "node_top")))
	arg_1_0._bottom_position = Vector3Box(Unit.world_position(arg_1_2, Unit.node(arg_1_2, "node_bottom")))

	if arg_1_0._is_server then
		Managers.state.bot_nav_transition:register_ladder(arg_1_2)
	end
end

function LadderExtension.ladder_extents(arg_2_0)
	return arg_2_0._bottom_position:unbox(), arg_2_0._top_position:unbox()
end

LadderExtension.perlin_shake = {
	persistance = 1,
	magnitude = 0.1,
	frequency_multiplier = 4,
	duration = 1,
	min_value = 0,
	octaves = 6
}

local function var_0_0(arg_3_0, arg_3_1)
	local var_3_0, var_3_1 = Math.next_random(arg_3_0 * arg_3_1)
	local var_3_2, var_3_3 = Math.next_random(var_3_0)

	return var_3_3 * 2 - 1
end

local function var_0_1(arg_4_0, arg_4_1)
	return var_0_0(arg_4_0, arg_4_1) / 2 + var_0_0(arg_4_0 - 1, arg_4_1) / 4 + var_0_0(arg_4_0 + 1, arg_4_1) / 4
end

local function var_0_2(arg_5_0, arg_5_1)
	local var_5_0 = math.floor(arg_5_0)
	local var_5_1 = arg_5_0 - var_5_0
	local var_5_2 = var_0_1(var_5_0, arg_5_1)
	local var_5_3 = var_0_1(var_5_0 + 1, arg_5_1)

	return math.lerp(var_5_2, var_5_3, var_5_1)
end

local function var_0_3(arg_6_0, arg_6_1, arg_6_2, arg_6_3)
	local var_6_0 = 0
	local var_6_1 = 0

	for iter_6_0 = 0, arg_6_2 do
		local var_6_2 = 2^iter_6_0
		local var_6_3 = arg_6_1^iter_6_0

		var_6_0 = var_6_0 + var_0_2(arg_6_0 * var_6_2, arg_6_3) * var_6_3
		var_6_1 = var_6_1 + var_6_3
	end

	return var_6_0 / var_6_1
end

function LadderExtension.update_enabled(arg_7_0, arg_7_1, arg_7_2, arg_7_3, arg_7_4, arg_7_5)
	if arg_7_0._shaking then
		local var_7_0 = arg_7_5 - arg_7_0._shaking
		local var_7_1 = arg_7_0.perlin_shake
		local var_7_2 = var_7_1.duration

		if var_7_0 < var_7_2 then
			if arg_7_0._enable_shake then
				local var_7_3 = var_0_3(var_7_0 * var_7_1.frequency_multiplier, var_7_1.persistance, var_7_1.octaves, arg_7_0._seed_x)
				local var_7_4 = var_0_3(var_7_0 * var_7_1.frequency_multiplier, var_7_1.persistance, var_7_1.octaves, arg_7_0._seed_y)
				local var_7_5 = var_7_1.magnitude * math.lerp(1, 0, var_7_0 / var_7_2)^2

				Unit.set_local_position(arg_7_0._unit, arg_7_0._node, arg_7_0._start_position:unbox() + Vector3(var_7_3 * var_7_5, var_7_4 * var_7_5, 0))
			end
		else
			Managers.state.entity:system("ladder_system"):disable_update_function("LadderExtension", "update", arg_7_0._unit)

			arg_7_0.update = nil
			arg_7_0._shaking = false
		end
	end
end

function LadderExtension.is_shaking(arg_8_0)
	return arg_8_0._shaking and true or false
end

function LadderExtension.shake(arg_9_0)
	if not arg_9_0._shaking then
		arg_9_0._shaking = Managers.time:time("game")

		if arg_9_0._is_server then
			local var_9_0 = LevelHelper:current_level(arg_9_0._world)
			local var_9_1 = Level.unit_index(var_9_0, arg_9_0._unit)

			Managers.state.network.network_transmit:send_rpc_clients("rpc_ladder_shake", var_9_1)
		end

		Managers.state.entity:system("ladder_system"):enable_update_function("LadderExtension", "update", arg_9_0._unit, arg_9_0)

		arg_9_0.update = arg_9_0.update_enabled
	end
end

function LadderExtension.destroy(arg_10_0)
	if arg_10_0._is_server then
		Managers.state.bot_nav_transition:unregister_ladder(arg_10_0._unit)
	end
end
