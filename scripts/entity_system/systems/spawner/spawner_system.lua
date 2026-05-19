-- chunkname: @scripts/entity_system/systems/spawner/spawner_system.lua

require("scripts/hub_elements/ai_spawner")

local function var_0_0(...)
	if script_data.debug_hordes then
		printf(...)
	end
end

SpawnerSystem = class(SpawnerSystem, ExtensionSystemBase)

local var_0_1 = {
	"AISpawner"
}
local var_0_2 = script_data

function SpawnerSystem.init(arg_2_0, arg_2_1, arg_2_2)
	SpawnerSystem.super.init(arg_2_0, arg_2_1, arg_2_2, var_0_1)

	arg_2_0._spawn_list = {}
	arg_2_0._active_spawners = {}
	arg_2_0._enabled_spawners = {}
	arg_2_0._disabled_spawners = {}
	arg_2_0._num_hidden_spawners = 0
	arg_2_0._id_lookup = {}
	arg_2_0._raw_id_lookup = {}
	arg_2_0._hidden_spawners = {}
	arg_2_0._disabled_hidden_spawners = {}
	arg_2_0._spawner_broadphase_id = {}

	Managers.state.event:register(arg_2_0, "spawn_horde", "spawn_horde")

	arg_2_0.hidden_spawners_broadphase = Broadphase(40, 512)
	arg_2_0._use_alt_horde_spawning = Managers.mechanism:setting("use_alt_horde_spawning")
	arg_2_0._breed_limits = {}
end

local var_0_3 = {
	"skaven_slave",
	"skaven_clan_rat",
	"skaven_slave",
	"skaven_clan_rat",
	"skaven_slave",
	"skaven_clan_rat",
	"skaven_slave",
	"skaven_clan_rat",
	"skaven_slave",
	"skaven_clan_rat"
}

function SpawnerSystem.update_test_all_spawners(arg_3_0, arg_3_1)
	local var_3_0 = arg_3_0._enabled_spawners
	local var_3_1 = arg_3_0._test_data.index
	local var_3_2 = 0
	local var_3_3 = 2

	while var_3_1 <= #var_3_0 and arg_3_0.tests_running < 6 and var_3_2 < 10 do
		local var_3_4 = var_3_0[var_3_1]
		local var_3_5 = {
			template = "spawn_test",
			size = 10,
			id = Managers.state.entity:system("ai_group_system"):generate_group_id(),
			spawner_unit = var_3_4,
			group_data = {
				spawner_unit = var_3_4
			}
		}
		local var_3_6 = Unit.local_position(var_3_4, 0)

		QuickDrawerStay:sphere(var_3_6, 0.66, Color(60, 200, 0))
		Debug.world_sticky_text(var_3_6, var_3_5.id, "green")
		print("START TEST for ", var_3_5.id)
		arg_3_0:spawn_horde(var_3_4, var_0_3, var_3_3, var_3_5)

		var_3_1 = var_3_1 + 1
		var_3_2 = var_3_2 + 1
		arg_3_0.tests_running = arg_3_0.tests_running + 1
	end

	if var_3_1 > #var_3_0 then
		print("All spawners tested")

		arg_3_0._test_data = nil
	else
		arg_3_0._test_data.index = var_3_1
	end
end

function SpawnerSystem.test_all_spawners(arg_4_0)
	arg_4_0.tests_running = 0

	print("")
	print(string.format("Starting spawner test. Found %d spawners.", #arg_4_0._enabled_spawners))

	arg_4_0._test_data = {
		index = 1
	}
end

function SpawnerSystem.running_spawners(arg_5_0)
	return arg_5_0._active_spawners
end

function SpawnerSystem.enabled_spawners(arg_6_0)
	return arg_6_0._enabled_spawners
end

function SpawnerSystem.hidden_spawners_lookup(arg_7_0)
	return arg_7_0._hidden_spawners
end

function SpawnerSystem.register_enabled_spawner(arg_8_0, arg_8_1, arg_8_2, arg_8_3)
	arg_8_0._enabled_spawners[#arg_8_0._enabled_spawners + 1] = arg_8_1

	if arg_8_2 then
		local var_8_0 = arg_8_0._id_lookup[arg_8_2]

		if not var_8_0 then
			var_8_0 = {}
			arg_8_0._id_lookup[arg_8_2] = var_8_0
		end

		var_8_0[#var_8_0 + 1] = arg_8_1
	end

	if arg_8_3 then
		arg_8_0:_add_broadphase(arg_8_1)
	end
end

function SpawnerSystem.hibernate_spawner(arg_9_0, arg_9_1, arg_9_2)
	local var_9_0 = arg_9_0._enabled_spawners
	local var_9_1 = #var_9_0
	local var_9_2 = arg_9_0._disabled_spawners
	local var_9_3 = var_9_2[arg_9_1]
	local var_9_4 = arg_9_0._hidden_spawners
	local var_9_5 = var_9_4[arg_9_1]
	local var_9_6 = arg_9_0._disabled_hidden_spawners
	local var_9_7 = var_9_6[arg_9_1]

	if arg_9_2 then
		if not var_9_3 then
			arg_9_0:_hibernate_spawner(var_9_1, var_9_0, var_9_2, arg_9_1)
		end

		if var_9_5 and not var_9_7 then
			arg_9_0:_hibernate_hidden_spawner(var_9_4, var_9_6, arg_9_1)
			arg_9_0:_remove_broadphase(arg_9_1)
		end
	else
		if var_9_3 then
			arg_9_0:_awaken_spawner(var_9_0, var_9_2, arg_9_1)
		end

		if var_9_7 then
			arg_9_0:_awaken_hidden_spawner(var_9_4, var_9_6, arg_9_1)
			arg_9_0:_add_broadphase(arg_9_1)
		end
	end
end

function SpawnerSystem._hibernate_spawner(arg_10_0, arg_10_1, arg_10_2, arg_10_3, arg_10_4)
	for iter_10_0 = 1, arg_10_1 do
		if arg_10_2[iter_10_0] == arg_10_4 then
			table.swap_delete(arg_10_2, iter_10_0)

			arg_10_3[arg_10_4] = true

			break
		end
	end
end

function SpawnerSystem._hibernate_hidden_spawner(arg_11_0, arg_11_1, arg_11_2, arg_11_3)
	arg_11_1[arg_11_3] = nil
	arg_11_2[arg_11_3] = true
end

function SpawnerSystem._awaken_spawner(arg_12_0, arg_12_1, arg_12_2, arg_12_3)
	arg_12_2[arg_12_3] = nil
	arg_12_1[#arg_12_1 + 1] = arg_12_3
end

function SpawnerSystem._awaken_hidden_spawner(arg_13_0, arg_13_1, arg_13_2, arg_13_3)
	arg_13_2[arg_13_3] = nil
	arg_13_1[arg_13_3] = true
end

function SpawnerSystem._add_broadphase(arg_14_0, arg_14_1)
	local var_14_0 = Unit.local_position(arg_14_1, 0)
	local var_14_1 = Broadphase.add(arg_14_0.hidden_spawners_broadphase, arg_14_1, var_14_0, 1)

	arg_14_0._hidden_spawners[arg_14_1] = true
	arg_14_0._spawner_broadphase_id[arg_14_1] = var_14_1
	arg_14_0._num_hidden_spawners = arg_14_0._num_hidden_spawners + 1
end

function SpawnerSystem._remove_broadphase(arg_15_0, arg_15_1)
	local var_15_0 = arg_15_0._spawner_broadphase_id[arg_15_1]

	Broadphase.remove(arg_15_0.hidden_spawners_broadphase, var_15_0)

	arg_15_0._spawner_broadphase_id[arg_15_1] = nil
	arg_15_0._num_hidden_spawners = arg_15_0._num_hidden_spawners - 1
end

function SpawnerSystem.register_raw_spawner(arg_16_0, arg_16_1, arg_16_2)
	if arg_16_2 then
		local var_16_0 = arg_16_0._raw_id_lookup[arg_16_2]

		if not var_16_0 then
			var_16_0 = {}
			arg_16_0._raw_id_lookup[arg_16_2] = var_16_0
		end

		var_16_0[#var_16_0 + 1] = arg_16_1
	end
end

local var_0_4 = {}
local var_0_5 = {}
local var_0_6 = {}

function SpawnerSystem.spawn_horde(arg_17_0, arg_17_1, arg_17_2, arg_17_3, arg_17_4, arg_17_5)
	local var_17_0 = ScriptUnit.extension(arg_17_1, "spawner_system")

	arg_17_0._active_spawners[arg_17_1] = var_17_0

	var_17_0:on_activate(arg_17_2, arg_17_3, arg_17_4, arg_17_5)

	return (var_17_0:spawn_rate())
end

local function var_0_7(arg_18_0, arg_18_1, arg_18_2, arg_18_3)
	local var_18_0 = 1

	for iter_18_0 = arg_18_1, arg_18_2 do
		arg_18_3[var_18_0] = arg_18_0[iter_18_0]
		var_18_0 = var_18_0 + 1
	end
end

function SpawnerSystem.set_breed_event_horde_spawn_limit(arg_19_0, arg_19_1, arg_19_2)
	arg_19_0._breed_limits[arg_19_1] = arg_19_2
end

local var_0_8 = {}
local var_0_9 = {}
local var_0_10 = 1

for iter_0_0, iter_0_1 in pairs(Breeds) do
	var_0_9[var_0_10] = iter_0_0
	var_0_10 = var_0_10 + 1
end

table.sort(var_0_9, function(arg_20_0, arg_20_1)
	return Breeds[arg_20_0].exchange_order < Breeds[arg_20_1].exchange_order
end)
table.dump(var_0_9)

function SpawnerSystem._try_spawn_breed(arg_21_0, arg_21_1, arg_21_2, arg_21_3, arg_21_4, arg_21_5, arg_21_6, arg_21_7)
	local var_21_0 = arg_21_2[arg_21_1]

	if var_21_0 then
		local var_21_1 = arg_21_4[arg_21_1]

		if var_21_1 then
			local var_21_2 = math.min(arg_21_5 + var_21_0 - var_21_1.max_active_enemies, var_21_0)
			local var_21_3 = var_21_1.exchange_ratio

			if var_21_3 < var_21_2 then
				local var_21_4 = math.floor(var_21_2 / var_21_3)

				var_21_0 = var_21_0 - var_21_4 * var_21_3

				local var_21_5 = var_21_1.spawn_breed

				if type(var_21_5) == "table" then
					local var_21_6 = #var_21_5

					for iter_21_0 = 1, var_21_4 do
						local var_21_7 = var_21_5[Math.random(1, var_21_6)]

						arg_21_2[var_21_7] = (arg_21_2[var_21_7] or 0) + 1
					end

					for iter_21_1 = 1, var_21_6 do
						arg_21_5 = arg_21_5 + arg_21_0:_try_spawn_breed(var_21_5[iter_21_1], arg_21_2, arg_21_3, arg_21_4, arg_21_5, arg_21_6, arg_21_7)
					end
				else
					arg_21_2[var_21_5] = (arg_21_2[var_21_5] or 0) + var_21_4
					arg_21_5 = arg_21_5 + arg_21_0:_try_spawn_breed(var_21_5, arg_21_2, arg_21_3, arg_21_4, arg_21_5, arg_21_6, arg_21_7)
				end
			end
		end

		local var_21_8 = #arg_21_3 + 1

		arg_21_5 = arg_21_5 + var_21_0

		if arg_21_7 then
			arg_21_7.size = arg_21_7.size + var_21_0
		end

		local var_21_9 = var_21_8 + var_21_0 - 1

		for iter_21_2 = var_21_8, var_21_9 do
			arg_21_3[iter_21_2] = arg_21_1
		end
	end

	return arg_21_5
end

function SpawnerSystem._fill_spawners(arg_22_0, arg_22_1, arg_22_2, arg_22_3, arg_22_4, arg_22_5, arg_22_6, arg_22_7, arg_22_8)
	local var_22_0 = #arg_22_1

	if var_22_0 <= 0 then
		return var_22_0
	end

	local var_22_1 = #arg_22_2

	table.shuffle(arg_22_2)

	if arg_22_3 then
		if arg_22_6 then
			local var_22_2 = POSITION_LOOKUP[arg_22_7]

			while arg_22_3 < #arg_22_2 do
				local var_22_3 = 1
				local var_22_4 = 0

				for iter_22_0 = 1, #arg_22_2 do
					local var_22_5 = Vector3.distance_squared(var_22_2, Unit.local_position(arg_22_2[iter_22_0], 0))

					if var_22_4 < var_22_5 then
						var_22_4 = var_22_5
						var_22_3 = iter_22_0
					end
				end

				table.swap_delete(arg_22_2, var_22_3)
			end
		else
			for iter_22_1 = arg_22_3 + 1, var_22_1 do
				arg_22_2[iter_22_1] = nil
			end
		end

		var_22_1 = #arg_22_2
	end

	local var_22_6 = 1

	for iter_22_2 = 1, var_22_1 do
		local var_22_7 = math.floor(var_22_0 / (var_22_1 - iter_22_2 + 1))

		var_22_0 = var_22_0 - var_22_7

		local var_22_8 = arg_22_2[iter_22_2]
		local var_22_9 = ScriptUnit.extension(var_22_8, "spawner_system")

		arg_22_0._active_spawners[var_22_8] = var_22_9

		table.clear_array(var_0_6, #var_0_6)
		var_0_7(arg_22_1, var_22_6, var_22_6 + var_22_7 - 1, var_0_6)
		var_22_9:on_activate(var_0_6, arg_22_4, arg_22_5, arg_22_8)

		var_22_6 = var_22_6 + var_22_7
	end

	return #arg_22_1
end

local var_0_11 = {
	skaven_clan_rat = true,
	skaven_slave = true
}

function SpawnerSystem.spawn_horde_from_terror_event_ids(arg_23_0, arg_23_1, arg_23_2, arg_23_3, arg_23_4, arg_23_5, arg_23_6, arg_23_7, arg_23_8, arg_23_9)
	local var_23_0 = ConflictUtils
	local var_23_1 = arg_23_2.must_use_hidden_spawners
	local var_23_2
	local var_23_3
	local var_23_4
	local var_23_5 = math.random()

	if arg_23_1 and #arg_23_1 > 0 then
		var_23_2 = {}
		var_23_3 = {}

		for iter_23_0, iter_23_1 in ipairs(arg_23_1) do
			local var_23_6 = arg_23_0._id_lookup[iter_23_1]

			if var_23_6 then
				for iter_23_2 = 1, #var_23_6 do
					local var_23_7 = var_23_6[iter_23_2]

					if not arg_23_0._disabled_spawners[var_23_7] then
						if Unit.get_data(var_23_7, "hidden") then
							var_23_3[#var_23_3 + 1] = var_23_7
						end

						var_23_2[#var_23_2 + 1] = var_23_7
					end
				end
			else
				fassert("No horde spawners found with terror_id %d ", iter_23_1)

				return
			end
		end

		if #var_23_2 == 0 then
			return
		end

		var_23_4 = arg_23_0._use_alt_horde_spawning ~= true
	else
		local var_23_8 = Managers.state.side:get_side_from_name("heroes").PLAYER_POSITIONS

		if arg_23_5 then
			var_23_2, var_23_3 = var_23_0.filter_horde_spawners_strictly(var_23_8, arg_23_0._enabled_spawners, arg_23_0._hidden_spawners, 10, 35)
		else
			var_23_2, var_23_3 = var_23_0.filter_horde_spawners(var_23_8, arg_23_0._enabled_spawners, arg_23_0._hidden_spawners, 10, 35)
		end

		if var_23_1 and #var_23_3 == 0 then
			local var_23_9 = var_23_8[1]

			if var_23_9 then
				local var_23_10 = var_23_0.get_random_hidden_spawner(var_23_9, 40)

				if var_23_10 then
					var_23_3 = {
						var_23_10
					}
				end
			end

			if #var_23_3 == 0 then
				print("Can't find any hidden spawners for this breed")

				return
			end
		end

		if not next(var_23_2) then
			return
		end
	end

	if #var_23_2 == 0 then
		return
	end

	local var_23_11 = Managers.state.difficulty.difficulty
	local var_23_12 = arg_23_2.difficulty_breeds
	local var_23_13 = var_23_12 and var_23_12[var_23_11] or arg_23_2.breeds
	local var_23_14 = var_0_4

	table.clear_array(var_23_14, #var_23_14)

	local var_23_15 = var_0_5

	table.clear_array(var_23_15, #var_23_15)

	for iter_23_3 = 1, #var_23_13, 2 do
		local var_23_16 = var_23_13[iter_23_3]
		local var_23_17 = var_23_13[iter_23_3 + 1]
		local var_23_18

		if type(var_23_17) == "table" then
			var_23_18 = Math.random(var_23_17[1], var_23_17[2])
		else
			var_23_18 = var_23_17
		end

		if var_0_2.big_hordes then
			var_23_18 = math.round(var_23_18 * (tonumber(var_0_2.big_hordes) or 1))
		end

		var_0_8[var_23_16] = var_23_18
	end

	local var_23_19 = var_0_9
	local var_23_20 = arg_23_0._breed_limits
	local var_23_21 = #var_23_19
	local var_23_22 = Managers.state.performance:num_active_enemies()

	for iter_23_4 = 1, var_23_21 do
		local var_23_23 = var_23_19[iter_23_4]

		if var_23_4 or var_0_11[var_23_23] then
			arg_23_0:_try_spawn_breed(var_23_23, var_0_8, var_23_14, var_23_20, var_23_22, arg_23_6, arg_23_4)
		else
			arg_23_0:_try_spawn_breed(var_23_23, var_0_8, var_23_15, var_23_20, var_23_22, arg_23_6, arg_23_4)
		end
	end

	table.clear(var_0_8)
	table.shuffle(var_23_14)

	local var_23_24 = 0
	local var_23_25 = 0
	local var_23_26 = arg_23_0:_fill_spawners(var_23_14, var_23_2, arg_23_3, arg_23_6, arg_23_4, arg_23_7, arg_23_8, arg_23_9)

	if not var_23_4 and var_23_1 then
		local var_23_27 = arg_23_0:_fill_spawners(var_23_15, var_23_3, arg_23_3, arg_23_6, arg_23_4, arg_23_7, arg_23_8, arg_23_9)

		if var_23_27 > 0 then
			return "success", var_23_26 + var_23_27
		end
	end

	if var_23_26 > 0 then
		return "success", var_23_26
	end
end

function SpawnerSystem.change_spawner_id(arg_24_0, arg_24_1, arg_24_2, arg_24_3)
	if arg_24_1 then
		local var_24_0 = Unit.get_data(arg_24_1, "terror_event_id")

		if var_24_0 ~= "" and var_24_0 == arg_24_3 then
			return
		end

		local var_24_1 = arg_24_0._id_lookup[var_24_0]

		if var_24_1 then
			local var_24_2 = #var_24_1

			for iter_24_0 = 1, var_24_2 do
				if var_24_1[iter_24_0] == arg_24_1 then
					var_24_1[iter_24_0] = var_24_1[var_24_2]
					var_24_1[var_24_2] = nil

					break
				end
			end
		end

		local var_24_3 = arg_24_0._id_lookup[arg_24_3]

		if not var_24_3 then
			var_24_3 = {}
			arg_24_0._id_lookup[arg_24_3] = var_24_3
		end

		var_24_3[#var_24_3 + 1] = arg_24_1

		Unit.set_data(arg_24_1, "terror_event_id", arg_24_3)

		return
	end

	local var_24_4 = arg_24_0._id_lookup[arg_24_2]
	local var_24_5 = arg_24_0._id_lookup[arg_24_3]

	if not var_24_5 then
		var_24_5 = {}
		arg_24_0._id_lookup[arg_24_3] = var_24_5
	end

	if var_24_4 then
		local var_24_6 = #var_24_4
		local var_24_7 = #var_24_5

		for iter_24_1 = 1, var_24_6 do
			var_24_5[var_24_7 + iter_24_1] = var_24_4[iter_24_1]

			Unit.set_data(var_24_4[iter_24_1], "terror_event_id", arg_24_3)

			var_24_4[iter_24_1] = nil
		end
	else
		print("Can't find spawners called: ", arg_24_2, " so cannot rename any")
	end
end

function SpawnerSystem.get_raw_spawner_unit(arg_25_0, arg_25_1)
	local var_25_0 = arg_25_0._raw_id_lookup[arg_25_1] or arg_25_0._id_lookup[arg_25_1]

	if var_25_0 then
		local var_25_1 = var_25_0[math.random(1, #var_25_0)]
		local var_25_2 = Unit.get_data(var_25_1, "idle_animation")

		return var_25_1, var_25_2
	end
end

function SpawnerSystem.get_raw_spawner_units(arg_26_0, arg_26_1)
	return arg_26_0._raw_id_lookup[arg_26_1] or arg_26_0._id_lookup[arg_26_1]
end

function SpawnerSystem.deactivate_spawner(arg_27_0, arg_27_1)
	arg_27_0._active_spawners[arg_27_1] = nil
end

function SpawnerSystem.debug_show_spawners(arg_28_0, arg_28_1, arg_28_2)
	local var_28_0 = 70
	local var_28_1 = Vector3(0, 0, var_28_0)
	local var_28_2 = Color(255, 0, 200, 0)

	for iter_28_0, iter_28_1 in pairs(arg_28_2) do
		local var_28_3 = Unit.local_position(iter_28_0, 0)

		QuickDrawer:line(var_28_3, var_28_3 + var_28_1, var_28_2)

		local var_28_4 = 7 * (arg_28_1 % 10)

		QuickDrawer:sphere(var_28_3 + Vector3(0, 0, var_28_4), 0.5, var_28_2)
		QuickDrawer:sphere(var_28_3 + Vector3(0, 0, (var_28_4 + 10) % var_28_0), 0.5, var_28_2)
		QuickDrawer:sphere(var_28_3 + Vector3(0, 0, (var_28_4 + 20) % var_28_0), 0.5, var_28_2)
	end
end

function SpawnerSystem.set_spawn_list(arg_29_0, arg_29_1)
	arg_29_0._spawn_list = arg_29_1
end

function SpawnerSystem.pop_pawn_list(arg_30_0)
	local var_30_0 = arg_30_0._spawn_list
	local var_30_1 = #var_30_0

	if var_30_1 <= 0 then
		return
	end

	local var_30_2 = var_30_0[var_30_1]

	var_30_0[var_30_1] = nil

	return var_30_2
end

local var_0_12 = {}
local var_0_13 = {}

function SpawnerSystem.update(arg_31_0, arg_31_1, arg_31_2, arg_31_3)
	for iter_31_0, iter_31_1 in pairs(arg_31_0._active_spawners) do
		iter_31_1:update(iter_31_0, var_0_12, arg_31_3, arg_31_1, arg_31_2)
	end
end

function SpawnerSystem.show_hidden_spawners(arg_32_0, arg_32_1)
	local var_32_0 = Unit.local_position
	local var_32_1 = Managers.state.side:get_side_from_name("heroes").PLAYER_POSITIONS[1]
	local var_32_2 = Managers.free_flight

	if var_32_2:active("global") then
		var_32_1 = var_32_2:camera_position_rotation()
	end

	local var_32_3 = math.sin(arg_32_1 * 10)
	local var_32_4 = Color(192 + 64 * var_32_3, 192 + 64 * var_32_3, 0)
	local var_32_5 = Color(192 + 64 * var_32_3, 0, 0)
	local var_32_6 = 0
	local var_32_7 = 0
	local var_32_8 = 40

	if var_32_1 then
		local var_32_9 = Managers.state.entity:system("ai_system"):nav_world()

		var_32_6 = Broadphase.query(arg_32_0.hidden_spawners_broadphase, var_32_1, var_32_8, var_0_13)

		local var_32_10 = math.sin(arg_32_1 * 5) * 0.33
		local var_32_11 = Vector3(var_32_10, var_32_10, 0)
		local var_32_12 = Vector3(var_32_10, var_32_10, 30)

		for iter_32_0 = 1, var_32_6 do
			local var_32_13 = var_0_13[iter_32_0]
			local var_32_14 = var_32_0(var_32_13, 0)

			if GwNavQueries.triangle_from_position(var_32_9, var_32_14, 0.5, 0.5) then
				QuickDrawer:line(var_32_14 + var_32_11, var_32_14 + var_32_12, var_32_4)
				QuickDrawer:sphere(var_32_14, 0.15, var_32_4)
			else
				QuickDrawer:line(var_32_14 + var_32_11, var_32_14 + var_32_12, var_32_5)
				QuickDrawer:sphere(var_32_14, 0.15, var_32_4)

				var_32_7 = var_32_7 + 1
			end
		end
	end

	if var_32_7 == 0 then
		Debug.text("This level has %d hidden spawners. (%d within %d meters)", arg_32_0._num_hidden_spawners, var_32_6, var_32_8)

		if var_32_1 then
			QuickDrawer:circle(var_32_1 + Vector3(0, 0, 20), var_32_8, Vector3.up(), var_32_4)
		end
	else
		Debug.text("This level has %d hidden spawners. (%d within %d meters, %d are not on nav-mesh)", arg_32_0._num_hidden_spawners, var_32_6, var_32_8, var_32_7)

		if var_32_1 then
			QuickDrawer:circle(var_32_1 + Vector3(0, 0, 20), var_32_8, Vector3.up(), var_32_5)
		end
	end
end
