-- chunkname: @scripts/managers/backend_playfab/benchmark_backend/backend_interface_quests_benchmark.lua

BackendInterfaceQuestsBenchmark = class(BackendInterfaceQuestsBenchmark)

BackendInterfaceQuestsBenchmark.init = function (self, backend_mirror)
	-- function 1
	return
end

BackendInterfaceQuestsBenchmark._refresh = function (self)
	-- function 2
	return
end

BackendInterfaceQuestsBenchmark.ready = function (self)
	-- function 3
	return true
end

BackendInterfaceQuestsBenchmark.make_dirty = function (self)
	-- function 4
	return
end

BackendInterfaceQuestsBenchmark.update = function (self, dt)
	-- function 5
	return
end

BackendInterfaceQuestsBenchmark.get_quests_cb = function (self, result)
	-- function 6
	return
end

BackendInterfaceQuestsBenchmark.delete = function (self)
	-- function 7
	return
end

BackendInterfaceQuestsBenchmark.get_quests = function (self)
	-- function 8
	return {}
end

BackendInterfaceQuestsBenchmark.get_daily_quest_update_time = function (self)
	-- function 9
	return 0
end

BackendInterfaceQuestsBenchmark.get_time_left_on_event_quest = function (self, key)
	-- function 10
	return 0
end

BackendInterfaceQuestsBenchmark.can_refresh_daily_quest = function (self)
	-- function 11
	return false
end

BackendInterfaceQuestsBenchmark.refresh_daily_quest = function (self, key)
	-- function 12
	return 1
end

BackendInterfaceQuestsBenchmark.refresh_quest_cb = function (self, id, key, result)
	-- function 13
	return
end

BackendInterfaceQuestsBenchmark.is_quest_refreshed = function (self, id)
	-- function 14
	return true
end

BackendInterfaceQuestsBenchmark.can_claim_quest_rewards = function (self, key)
	-- function 15
	return false
end

BackendInterfaceQuestsBenchmark.claim_quest_rewards = function (self, key)
	-- function 16
	return 1
end

BackendInterfaceQuestsBenchmark.quest_rewards_request_cb = function (self, data, result)
	-- function 17
	return
end

BackendInterfaceQuestsBenchmark.get_quest_key = function (self, quest_id)
	-- function 18
	return nil
end

BackendInterfaceQuestsBenchmark.quest_rewards_generated = function (self, id)
	-- function 19
	return false
end

BackendInterfaceQuestsBenchmark.get_quest_rewards = function (self, id)
	-- function 20
	return {}
end
