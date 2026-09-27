-- chunkname: @scripts/managers/game_mode/adventure_profile_rules.lua

AdventureProfileRules = class(AdventureProfileRules)

AdventureProfileRules.init = function (self, arg_1_1, arg_1_2)
	-- function 1
	self._profile_synchronizer = arg_1_1
	self._network_server = arg_1_2
end

AdventureProfileRules._profile_career_exists = function (arg_2_0, arg_2_1, arg_2_2)
	-- function 2
	local var_2_0 = SPProfiles[arg_2_1]
	local flag = not var_2_0 and var_2_0.careers

	return (not flag and flag[arg_2_2]) ~= nil
end

AdventureProfileRules._profile_career_unlocked = function (arg_3_0, arg_3_1, arg_3_2)
	-- function 3
	local var_3_0 = SPProfiles[arg_3_1]
	local flag = not var_3_0 and var_3_0.careers
	local flag_2 = not flag and flag[arg_3_2]

	return not flag_2 and flag_2:is_unlocked_function(var_3_0.display_name, ExperienceSettings.max_level)
end

AdventureProfileRules.handle_profile_delegation_for_joining_player = function (self, arg_4_1, arg_4_2)
	-- function 4
	local _profile_synchronizer = self._profile_synchronizer
	local var_4_1
	local var_4_2
	local profile_by_peer, var_4_4 = _profile_synchronizer:profile_by_peer(arg_4_1, arg_4_2)
	local reserved_party_id_by_peer = Managers.mechanism:reserved_party_id_by_peer(arg_4_1)

	if not profile_by_peer then
		local peer_wanted_profile, var_4_7 = self._network_server:peer_wanted_profile(arg_4_1, arg_4_2)
		local get_profile_index_reservation = _profile_synchronizer:get_profile_index_reservation(reserved_party_id_by_peer, peer_wanted_profile)

		if not (not get_profile_index_reservation and get_profile_index_reservation ~= arg_4_1) then
			var_4_1, var_4_2 = peer_wanted_profile, var_4_7
		else
			var_4_1, var_4_2 = _profile_synchronizer:get_first_free_profile(reserved_party_id_by_peer)
		end
	end

	if not var_4_1 then
		local var_4_9 = SPProfiles[var_4_1]

		if not (not var_4_9 and var_4_9.affiliation == "heroes") then
			var_4_1, var_4_2 = _profile_synchronizer:get_first_free_profile(reserved_party_id_by_peer)
		end

		if not var_4_2 then
			if not self:_profile_career_exists(var_4_1, var_4_2) then
				print("Career " .. var_4_2 .. " does not exist, switching to career index 1")

				var_4_2 = 1
			end

			if not (Network.peer_id() ~= arg_4_1 or self:_profile_career_unlocked(var_4_1, var_4_2)) then
				print("Missing career: " .. var_4_2 .. " unlock requirements, switching to career index 1")

				var_4_2 = 1
			end

			local flag = false
			local try_reserve_profile_for_peer_by_mechanism = Managers.mechanism:try_reserve_profile_for_peer_by_mechanism(arg_4_1, var_4_1, var_4_2, false)

			fassert(try_reserve_profile_for_peer_by_mechanism, "this should always succeed since we checked everything before")
			_profile_synchronizer:assign_full_profile(arg_4_1, arg_4_2, var_4_1, var_4_2, flag)
		else
			local get_player_status = Managers.party:get_player_status(arg_4_1, arg_4_2)

			get_player_status.profile_index = profile_by_peer
			get_player_status.career_index = var_4_4
		end
	end
end
