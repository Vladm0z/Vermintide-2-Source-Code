-- chunkname: @scripts/managers/backend_playfab/benchmark_backend/backend_interface_loot_benchmark.lua

BackendInterfaceLootBenchmark = class(BackendInterfaceLootBenchmark)

BackendInterfaceLootBenchmark.init = function (self, backend_mirror)
	-- function 1
	return
end

BackendInterfaceLootBenchmark.ready = function (self)
	-- function 2
	return true
end

BackendInterfaceLootBenchmark.update = function (self, dt)
	-- function 3
	return
end

BackendInterfaceLootBenchmark.open_loot_chest = function (self, hero_name, backend_id)
	-- function 4
	return 1
end

BackendInterfaceLootBenchmark.loot_chest_rewards_request_cb = function (self, data, result)
	-- function 5
	return
end

BackendInterfaceLootBenchmark.generate_end_of_level_loot = function (self, game_won, quick_play_bonus, difficulty, level_key, hero_name, start_experience, end_experience, loot_profile_name, deed_item_name, deed_backend_id, game_mode_key, game_time, end_of_level_rewards_arguments)
	-- function 6
	return 1
end

BackendInterfaceLootBenchmark.end_of_level_loot_request_cb = function (self, data, result)
	-- function 7
	return
end

BackendInterfaceLootBenchmark.achievement_rewards_claimed = function (self, achievement_id)
	-- function 8
	return nil
end

BackendInterfaceLootBenchmark.get_achievement_rewards = function (self, achievement_id)
	-- function 9
	return nil
end

BackendInterfaceLootBenchmark.can_claim_achievement_rewards = function (self, achievement_id)
	-- function 10
	return false
end

BackendInterfaceLootBenchmark.claim_achievement_rewards = function (self, achievement_id)
	-- function 11
	return 1
end

BackendInterfaceLootBenchmark.achievement_rewards_request_cb = function (self, data, result)
	-- function 12
	return
end

BackendInterfaceLootBenchmark.is_loot_generated = function (self, id)
	-- function 13
	return false
end

BackendInterfaceLootBenchmark.get_loot = function (self, id)
	-- function 14
	return nil
end
