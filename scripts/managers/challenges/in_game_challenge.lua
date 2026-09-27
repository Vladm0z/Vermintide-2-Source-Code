-- chunkname: @scripts/managers/challenges/in_game_challenge.lua

InGameChallenge = class(InGameChallenge)

local InGameChallengeStatus = InGameChallengeStatus

InGameChallengeStatus = InGameChallengeStatus or CreateStrictEnumTable("Uninitialized", "InProgress", "Paused", "Finished")
InGameChallengeStatus = InGameChallengeStatus

local InGameChallengeResult = InGameChallengeResult

InGameChallengeResult = InGameChallengeResult or CreateStrictEnumTable("Uninitialized", "Completed", "Canceled")
InGameChallengeResult = InGameChallengeResult

InGameChallenge.init = function (self, arg_1_1, arg_1_2, arg_1_3, arg_1_4, arg_1_5, arg_1_6, arg_1_7, arg_1_8, arg_1_9)
	-- function 1
	self._challenge_template_name = arg_1_1
	self._challenge_template = InGameChallengeTemplates[arg_1_1]
	self._is_repeatable = arg_1_2
	self._category = arg_1_3
	self._reward_name = arg_1_4
	self._reward = MechanismOverrides.get(InGameChallengeRewards[arg_1_4])
	self._owner_unique_id = arg_1_5
	self._is_server = arg_1_6
	self._unique_id = arg_1_8
	self._auto_resume = arg_1_9
	self._required_progress = arg_1_7 or self._challenge_template.default_target
	self._events_registered = false
	self._callback_table = nil

	self:reset(false)
end

InGameChallenge.reset = function (self, arg_2_1)
	-- function 2
	self:_unregister_events()

	self._needs_sync = true
	self._marked_for_cleanup = false
	self._challenge_data = {}
	self._progress = 0
	self._status = InGameChallengeStatus.Uninitialized
	self._result = InGameChallengeResult.Uninitialized

	if not arg_2_1 then
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

InGameChallenge.set_paused = function (self, arg_6_1)
	-- function 6
	if not arg_6_1 then
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

InGameChallenge.belongs_to = function (self, arg_22_1)
	-- function 22
	return self._owner_unique_id == arg_22_1
end

InGameChallenge._register_events = function (self)
	-- function 23
	if not self._is_server then
		return
	end

	local event = Managers.state.event

	if not (not event and self._events_registered) then
		self._events_registered = true

		local events = self._challenge_template.events

		if not events then
			local tbl = {}

			for k, v in pairs(events) do
				tbl[k] = function (arg_24_0, ...)
					-- function 24
					local time = Managers.time:time("main")
					local var_24_1 = v(time, self._challenge_data, ...)

					var_24_1 = var_24_1 or 0

					if var_24_1 ~= 0 then
						self._progress = math.clamp(self._progress + var_24_1, 0, self._required_progress)

						self:_on_progress_updated()
					end
				end

				event:register(tbl, k, k)
			end

			self._callback_table = tbl
		end
	end
end

InGameChallenge._unregister_events = function (self)
	-- function 25
	if not self._is_server then
		return
	end

	if not self._events_registered then
		local event = Managers.state.event

		if not event then
			local _callback_table = self._callback_table

			if not _callback_table then
				for k, v in pairs(_callback_table) do
					event:unregister(k, _callback_table)
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

InGameChallenge._complete = function (self, arg_27_1)
	-- function 27
	if not (self._result ~= InGameChallengeResult.Uninitialized or self._status == InGameChallengeStatus.Uninitialized) then
		self._status = InGameChallengeStatus.Finished
		self._result = arg_27_1

		if arg_27_1 == InGameChallengeResult.Completed then
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

	local _reward = self._reward

	if not _reward then
		local var_28_1 = InGameChallengeRewardTargets[_reward.target](self._owner_unique_id)

		InGameChallengeRewardTypes[_reward.type](_reward, var_28_1, self._owner_unique_id)
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

InGameChallenge.needs_sync = function (self, arg_31_1)
	-- function 31
	local _needs_sync = self._needs_sync

	if not arg_31_1 then
		self._needs_sync = false
	end

	return _needs_sync
end

InGameChallenge.client_update = function (self, arg_32_1, arg_32_2, arg_32_3)
	-- function 32
	self._progress = arg_32_1
	self._status = InGameChallengeStatus[arg_32_2]
	self._result = InGameChallengeResult[arg_32_3]
end
