-- chunkname: @scripts/managers/challenges/in_game_challenge.lua

InGameChallenge = class(InGameChallenge)
InGameChallengeStatus = InGameChallengeStatus
InGameChallengeResult = InGameChallengeResult

InGameChallenge.init = function (self, challenge_template, is_repeatable, category, reward, owner_unique_id, is_server, custom_amount, unique_id, auto_resume)
	-- function 1
	self._challenge_template_name = challenge_template
	self._challenge_template = InGameChallengeTemplates[challenge_template]
	self._is_repeatable = is_repeatable
	self._category = category
	self._reward_name = reward
	self._reward = MechanismOverrides.get(InGameChallengeRewards[reward])
	self._owner_unique_id = owner_unique_id
	self._is_server = is_server
	self._unique_id = unique_id
	self._auto_resume = auto_resume
	self._required_progress = custom_amount or self._challenge_template.default_target
	self._events_registered = false
	self._callback_table = nil

	self:reset(false)
end

InGameChallenge.reset = function (self, start_challenge)
	-- function 2
	self:_unregister_events()

	self._needs_sync = true
	self._marked_for_cleanup = false
	self._challenge_data = {}
	self._progress = 0
	self._status = InGameChallengeStatus.Uninitialized
	self._result = InGameChallengeResult.Uninitialized

	if start_challenge then
		self:start()
	end
end

InGameChallenge.on_round_start = function (self)
	-- function 3
	if self._status == InGameChallengeStatus.InProgress then
		self:_register_events()
	end
end

InGameChallenge.on_round_end = function (self)
	-- function 4
	self:_unregister_events()
end

InGameChallenge.start = function (self)
	-- function 5
	if self._status == InGameChallengeStatus.Uninitialized then
		self._status = InGameChallengeStatus.InProgress

		self:_register_events()

		self._needs_sync = true
	end
end

InGameChallenge.set_paused = function (self, paused)
	-- function 6
	if paused then
		if self._status == InGameChallengeStatus.InProgress then
			self._status = InGameChallengeStatus.Paused

			self:_unregister_events()

			self._needs_sync = true
			self.paused_t = Managers.time:time("main")
		end
	elseif self._status == InGameChallengeStatus.Paused then
		self._status = InGameChallengeStatus.InProgress

		self:_register_events()

		self._needs_sync = true
		self.paused_t = nil
	end
end

InGameChallenge.cancel = function (self)
	-- function 7
	self:_complete(InGameChallengeResult.Canceled)
end

InGameChallenge.get_category = function (self)
	-- function 8
	return self._category
end

InGameChallenge.get_owner_unique_id = function (self)
	-- function 9
	return self._owner_unique_id
end

InGameChallenge.get_challenge = function (self)
	-- function 10
	return self._challenge_template
end

InGameChallenge.get_reward = function (self)
	-- function 11
	return self._reward
end

InGameChallenge.is_active = function (self)
	-- function 12
	return self._status == InGameChallengeStatus.InProgress or self._status == InGameChallengeStatus.Finished
end

InGameChallenge.has_ended = function (self)
	-- function 13
	return self._status == InGameChallengeStatus.Finished
end

InGameChallenge.is_repeatable = function (self)
	-- function 14
	return self._is_repeatable
end

InGameChallenge.auto_resume = function (self)
	-- function 15
	return self._auto_resume
end

InGameChallenge.get_progress = function (self)
	-- function 16
	return self._progress, self._required_progress
end

InGameChallenge.get_unique_id = function (self)
	-- function 17
	return self._unique_id
end

InGameChallenge.get_status = function (self)
	-- function 18
	return self._status
end

InGameChallenge.get_result = function (self)
	-- function 19
	return self._result
end

InGameChallenge.get_challenge_name = function (self)
	-- function 20
	return self._challenge_template_name
end

InGameChallenge.get_reward_name = function (self)
	-- function 21
	return self._reward_name
end

InGameChallenge.belongs_to = function (self, player_unique_id)
	-- function 22
	return self._owner_unique_id == player_unique_id
end

InGameChallenge._register_events = function (self)
	-- function 23
	if not self._is_server then
		return
	end

	local event_manager = Managers.state.event

	if event_manager and not self._events_registered then
		self._events_registered = true

		local events_to_register = self._challenge_template.events

		if events_to_register then
			local callback_table = {}

			for event_name, event_function in pairs(events_to_register) do
				callback_table[event_name] = function (_, ...)
					-- function 24
					local t = Managers.time:time("main")
					local progress_by = event_function(t, self._challenge_data, ...)

					if progress_by ~= 0 then
						self._progress = math.clamp(self._progress + progress_by, 0, self._required_progress)

						self:_on_progress_updated()
					end
				end

				event_manager:register(callback_table, event_name, event_name)
			end

			self._callback_table = callback_table
		end
	end
end

InGameChallenge._unregister_events = function (self)
	-- function 25
	if not self._is_server then
		return
	end

	if self._events_registered then
		local event_manager = Managers.state.event

		if event_manager then
			local callback_table = self._callback_table

			if callback_table then
				for event_name, _ in pairs(callback_table) do
					event_manager:unregister(event_name, callback_table)
				end
			end
		end

		self._callback_table = nil
		self._events_registered = false
	end
end

InGameChallenge._on_progress_updated = function (self)
	-- function 26
	self._needs_sync = true

	if self._progress >= self._required_progress then
		self:_complete(InGameChallengeResult.Completed)
	end
end

InGameChallenge._complete = function (self, result)
	-- function 27
	if self._result == InGameChallengeResult.Uninitialized and self._status ~= InGameChallengeStatus.Uninitialized then
		self._status = InGameChallengeStatus.Finished
		self._result = result

		if result == InGameChallengeResult.Completed then
			self:_award_reward()
		end

		self:_unregister_events()

		self._needs_sync = true
	end
end

InGameChallenge._award_reward = function (self)
	-- function 28
	if not self._is_server then
		return
	end

	local reward = self._reward

	if reward then
		local targets = InGameChallengeRewardTargets[reward.target](self._owner_unique_id)

		InGameChallengeRewardTypes[reward.type](reward, targets, self._owner_unique_id)
	end
end

InGameChallenge.mark_for_cleanup = function (self)
	-- function 29
	self._marked_for_cleanup = true
end

InGameChallenge.pending_cleanup = function (self)
	-- function 30
	return self._marked_for_cleanup
end

InGameChallenge.needs_sync = function (self, consume)
	-- function 31
	local sync = self._needs_sync

	if consume then
		self._needs_sync = false
	end

	return sync
end

InGameChallenge.client_update = function (self, progress, status_id, result_id)
	-- function 32
	self._progress = progress
	self._status = InGameChallengeStatus[status_id]
	self._result = InGameChallengeResult[result_id]
end
