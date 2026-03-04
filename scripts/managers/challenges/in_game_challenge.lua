-- chunkname: @scripts/managers/challenges/in_game_challenge.lua

InGameChallenge = class(InGameChallenge)
InGameChallengeStatus = InGameChallengeStatus or CreateStrictEnumTable("Uninitialized", "InProgress", "Paused", "Finished")
InGameChallengeResult = InGameChallengeResult or CreateStrictEnumTable("Uninitialized", "Completed", "Canceled")

InGameChallenge.init = function (arg_1_0, arg_1_1, arg_1_2, arg_1_3, arg_1_4, arg_1_5, arg_1_6, arg_1_7, arg_1_8, arg_1_9)
	arg_1_0._challenge_template_name = arg_1_1
	arg_1_0._challenge_template = InGameChallengeTemplates[arg_1_1]
	arg_1_0._is_repeatable = arg_1_2
	arg_1_0._category = arg_1_3
	arg_1_0._reward_name = arg_1_4
	arg_1_0._reward = MechanismOverrides.get(InGameChallengeRewards[arg_1_4])
	arg_1_0._owner_unique_id = arg_1_5
	arg_1_0._is_server = arg_1_6
	arg_1_0._unique_id = arg_1_8
	arg_1_0._auto_resume = arg_1_9
	arg_1_0._required_progress = arg_1_7 or arg_1_0._challenge_template.default_target
	arg_1_0._events_registered = false
	arg_1_0._callback_table = nil

	arg_1_0:reset(false)
end

InGameChallenge.reset = function (arg_2_0, arg_2_1)
	arg_2_0:_unregister_events()

	arg_2_0._needs_sync = true
	arg_2_0._marked_for_cleanup = false
	arg_2_0._challenge_data = {}
	arg_2_0._progress = 0
	arg_2_0._status = InGameChallengeStatus.Uninitialized
	arg_2_0._result = InGameChallengeResult.Uninitialized

	if arg_2_1 then
		arg_2_0:start()
	end
end

InGameChallenge.on_round_start = function (arg_3_0)
	if arg_3_0._status == InGameChallengeStatus.InProgress then
		arg_3_0:_register_events()
	end
end

InGameChallenge.on_round_end = function (arg_4_0)
	arg_4_0:_unregister_events()
end

InGameChallenge.start = function (arg_5_0)
	if arg_5_0._status == InGameChallengeStatus.Uninitialized then
		arg_5_0._status = InGameChallengeStatus.InProgress

		arg_5_0:_register_events()

		arg_5_0._needs_sync = true
	end
end

InGameChallenge.set_paused = function (arg_6_0, arg_6_1)
	if arg_6_1 then
		if arg_6_0._status == InGameChallengeStatus.InProgress then
			arg_6_0._status = InGameChallengeStatus.Paused

			arg_6_0:_unregister_events()

			arg_6_0._needs_sync = true
			arg_6_0.paused_t = Managers.time:time("main")
		end
	elseif arg_6_0._status == InGameChallengeStatus.Paused then
		arg_6_0._status = InGameChallengeStatus.InProgress

		arg_6_0:_register_events()

		arg_6_0._needs_sync = true
		arg_6_0.paused_t = nil
	end
end

InGameChallenge.cancel = function (arg_7_0)
	arg_7_0:_complete(InGameChallengeResult.Canceled)
end

InGameChallenge.get_category = function (arg_8_0)
	return arg_8_0._category
end

InGameChallenge.get_owner_unique_id = function (arg_9_0)
	return arg_9_0._owner_unique_id
end

InGameChallenge.get_challenge = function (arg_10_0)
	return arg_10_0._challenge_template
end

InGameChallenge.get_reward = function (arg_11_0)
	return arg_11_0._reward
end

InGameChallenge.is_active = function (arg_12_0)
	return arg_12_0._status == InGameChallengeStatus.InProgress or arg_12_0._status == InGameChallengeStatus.Finished
end

InGameChallenge.has_ended = function (arg_13_0)
	return arg_13_0._status == InGameChallengeStatus.Finished
end

InGameChallenge.is_repeatable = function (arg_14_0)
	return arg_14_0._is_repeatable
end

InGameChallenge.auto_resume = function (arg_15_0)
	return arg_15_0._auto_resume
end

InGameChallenge.get_progress = function (arg_16_0)
	return arg_16_0._progress, arg_16_0._required_progress
end

InGameChallenge.get_unique_id = function (arg_17_0)
	return arg_17_0._unique_id
end

InGameChallenge.get_status = function (arg_18_0)
	return arg_18_0._status
end

InGameChallenge.get_result = function (arg_19_0)
	return arg_19_0._result
end

InGameChallenge.get_challenge_name = function (arg_20_0)
	return arg_20_0._challenge_template_name
end

InGameChallenge.get_reward_name = function (arg_21_0)
	return arg_21_0._reward_name
end

InGameChallenge.belongs_to = function (arg_22_0, arg_22_1)
	return arg_22_0._owner_unique_id == arg_22_1
end

InGameChallenge._register_events = function (arg_23_0)
	if not arg_23_0._is_server then
		return
	end

	local var_23_0 = Managers.state.event

	if var_23_0 and not arg_23_0._events_registered then
		arg_23_0._events_registered = true

		local var_23_1 = arg_23_0._challenge_template.events

		if var_23_1 then
			local var_23_2 = {}

			for iter_23_0, iter_23_1 in pairs(var_23_1) do
				var_23_2[iter_23_0] = function (arg_24_0, ...)
					local var_24_0 = Managers.time:time("main")
					local var_24_1 = iter_23_1(var_24_0, arg_23_0._challenge_data, ...) or 0

					if var_24_1 ~= 0 then
						arg_23_0._progress = math.clamp(arg_23_0._progress + var_24_1, 0, arg_23_0._required_progress)

						arg_23_0:_on_progress_updated()
					end
				end

				var_23_0:register(var_23_2, iter_23_0, iter_23_0)
			end

			arg_23_0._callback_table = var_23_2
		end
	end
end

InGameChallenge._unregister_events = function (arg_25_0)
	if not arg_25_0._is_server then
		return
	end

	if arg_25_0._events_registered then
		local var_25_0 = Managers.state.event

		if var_25_0 then
			local var_25_1 = arg_25_0._callback_table

			if var_25_1 then
				for iter_25_0, iter_25_1 in pairs(var_25_1) do
					var_25_0:unregister(iter_25_0, var_25_1)
				end
			end
		end

		arg_25_0._callback_table = nil
		arg_25_0._events_registered = false
	end
end

InGameChallenge._on_progress_updated = function (arg_26_0)
	arg_26_0._needs_sync = true

	if arg_26_0._progress >= arg_26_0._required_progress then
		arg_26_0:_complete(InGameChallengeResult.Completed)
	end
end

InGameChallenge._complete = function (arg_27_0, arg_27_1)
	if arg_27_0._result == InGameChallengeResult.Uninitialized and arg_27_0._status ~= InGameChallengeStatus.Uninitialized then
		arg_27_0._status = InGameChallengeStatus.Finished
		arg_27_0._result = arg_27_1

		if arg_27_1 == InGameChallengeResult.Completed then
			arg_27_0:_award_reward()
		end

		arg_27_0:_unregister_events()

		arg_27_0._needs_sync = true
	end
end

InGameChallenge._award_reward = function (arg_28_0)
	if not arg_28_0._is_server then
		return
	end

	local var_28_0 = arg_28_0._reward

	if var_28_0 then
		local var_28_1 = InGameChallengeRewardTargets[var_28_0.target](arg_28_0._owner_unique_id)

		InGameChallengeRewardTypes[var_28_0.type](var_28_0, var_28_1, arg_28_0._owner_unique_id)
	end
end

InGameChallenge.mark_for_cleanup = function (arg_29_0)
	arg_29_0._marked_for_cleanup = true
end

InGameChallenge.pending_cleanup = function (arg_30_0)
	return arg_30_0._marked_for_cleanup
end

InGameChallenge.needs_sync = function (arg_31_0, arg_31_1)
	local var_31_0 = arg_31_0._needs_sync

	if arg_31_1 then
		arg_31_0._needs_sync = false
	end

	return var_31_0
end

InGameChallenge.client_update = function (arg_32_0, arg_32_1, arg_32_2, arg_32_3)
	arg_32_0._progress = arg_32_1
	arg_32_0._status = InGameChallengeStatus[arg_32_2]
	arg_32_0._result = InGameChallengeResult[arg_32_3]
end
