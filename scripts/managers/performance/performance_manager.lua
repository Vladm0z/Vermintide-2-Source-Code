-- chunkname: @scripts/managers/performance/performance_manager.lua

PerformanceManager = class(PerformanceManager)

function PerformanceManager.init(arg_1_0, arg_1_1, arg_1_2, arg_1_3)
	arg_1_0._gui = arg_1_1
	arg_1_0._is_server = arg_1_2
	arg_1_0._tracked_ai_breeds = {
		chaos_raider = true,
		skaven_plague_monk = true,
		skaven_storm_vermin_with_shield = true,
		beastmen_bestigor = true,
		chaos_berzerker = true,
		skaven_clan_rat_with_shield = true,
		chaos_bulwark = true,
		chaos_marauder_with_shield = true,
		chaos_fanatic = true,
		skaven_slave = true,
		skaven_clan_rat = true,
		beastmen_ungor = true,
		chaos_warrior = true,
		beastmen_ungor_archer = true,
		skaven_storm_vermin_commander = true,
		skaven_storm_vermin = true,
		beastmen_gor = true,
		chaos_marauder = true
	}
	arg_1_0._num_ai_spawned = 0
	arg_1_0._num_ai_active = 0
	arg_1_0._num_event_ai_spawned = 0
	arg_1_0._num_event_ai_active = 0
	arg_1_0._num_ai_string = "SPAWNED: %3i   ACTIVE: %3i   EVENT SPAWNED: %3i   EVENT SPAWNED ACTIVE: %3i"
	arg_1_0._settings = {
		critical = {
			font = "materials/fonts/arial",
			distance_from_top = 60,
			size = 36,
			material = "arial",
			color = ColorBox(255, 255, 0, 0),
			color_to = ColorBox(255, 255, 255, 0),
			position = Vector3Box()
		},
		normal = {
			font = "materials/fonts/arial",
			distance_from_top = 30,
			size = 26,
			material = "arial",
			color = ColorBox(255, 0, 255, 0),
			position = Vector3Box()
		}
	}

	if not DEDICATED_SERVER then
		local var_1_0, var_1_1 = Gui.resolution()

		for iter_1_0, iter_1_1 in pairs(arg_1_0._settings) do
			local var_1_2, var_1_3 = Gui.text_extents(arg_1_1, arg_1_0._num_ai_string, iter_1_1.font, iter_1_1.size, iter_1_1.material)
			local var_1_4 = math.floor((var_1_0 + var_1_2.x - var_1_3.x) * 0.5)
			local var_1_5 = var_1_1 - iter_1_1.distance_from_top
			local var_1_6 = 999

			iter_1_1.position:store(var_1_4, var_1_5, var_1_6)
		end
	end

	arg_1_0._events = {
		ai_unit_activated = "event_ai_unit_activated",
		ai_unit_despawned = "event_ai_unit_despawned",
		ai_unit_deactivated = "event_ai_unit_deactivated",
		ai_unit_spawned = "event_ai_unit_spawned"
	}

	local var_1_7 = Managers.state.event

	for iter_1_2, iter_1_3 in pairs(arg_1_0._events) do
		var_1_7:register(arg_1_0, iter_1_2, iter_1_3)
	end

	local var_1_8 = LevelSettings[arg_1_3]
	local var_1_9 = var_1_8 and var_1_8.performance

	arg_1_0._allowed_active = var_1_9 and var_1_9.allowed_active or 40
	arg_1_0._allowed_spawned = var_1_9 and var_1_9.allowed_spawned or 75
	arg_1_0._activated_per_breed = {}

	for iter_1_4, iter_1_5 in pairs(Breeds) do
		arg_1_0._activated_per_breed[iter_1_4] = 0
	end
end

function PerformanceManager.update(arg_2_0, arg_2_1, arg_2_2)
	return
end

function PerformanceManager.event_ai_unit_spawned(arg_3_0, arg_3_1, arg_3_2, arg_3_3, arg_3_4)
	if not arg_3_0._tracked_ai_breeds[arg_3_2] then
		return
	end

	if arg_3_3 ~= Managers.state.conflict.default_enemy_side_id then
		return
	end

	arg_3_0._num_ai_spawned = arg_3_0._num_ai_spawned + 1

	if arg_3_4 then
		arg_3_0._num_event_ai_spawned = arg_3_0._num_event_ai_spawned + 1
	end
end

function PerformanceManager.event_ai_unit_activated(arg_4_0, arg_4_1, arg_4_2, arg_4_3)
	arg_4_0._activated_per_breed[arg_4_2] = arg_4_0._activated_per_breed[arg_4_2] + 1

	if not arg_4_0._tracked_ai_breeds[arg_4_2] then
		return
	end

	arg_4_0._num_ai_active = arg_4_0._num_ai_active + 1

	if arg_4_3 then
		arg_4_0._num_event_ai_active = arg_4_0._num_event_ai_active + 1
	end
end

function PerformanceManager.event_ai_unit_deactivated(arg_5_0, arg_5_1, arg_5_2, arg_5_3)
	arg_5_0._activated_per_breed[arg_5_2] = arg_5_0._activated_per_breed[arg_5_2] - 1

	if not arg_5_0._tracked_ai_breeds[arg_5_2] then
		return
	end

	arg_5_0._num_ai_active = arg_5_0._num_ai_active - 1

	if arg_5_3 then
		arg_5_0._num_event_ai_active = arg_5_0._num_event_ai_active - 1
	end
end

function PerformanceManager.event_ai_unit_despawned(arg_6_0, arg_6_1, arg_6_2, arg_6_3, arg_6_4)
	if not arg_6_0._tracked_ai_breeds[arg_6_2] then
		return
	end

	if arg_6_3 ~= Managers.state.conflict.default_enemy_side_id then
		return
	end

	arg_6_0._num_ai_spawned = arg_6_0._num_ai_spawned - 1

	if arg_6_4 then
		arg_6_0._num_event_ai_spawned = arg_6_0._num_event_ai_spawned - 1
	end
end

function PerformanceManager.num_active_enemies(arg_7_0)
	return arg_7_0._num_ai_active
end

function PerformanceManager.num_active_enemies_of_breed(arg_8_0, arg_8_1)
	return arg_8_0._activated_per_breed[arg_8_1]
end

function PerformanceManager.activated_per_breed(arg_9_0)
	return arg_9_0._activated_per_breed
end

function PerformanceManager.destroy(arg_10_0)
	local var_10_0 = Managers.state.event

	for iter_10_0, iter_10_1 in pairs(arg_10_0._events) do
		var_10_0:unregister(iter_10_0, arg_10_0)
	end
end
