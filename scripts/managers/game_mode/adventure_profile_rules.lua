-- chunkname: @scripts/managers/game_mode/adventure_profile_rules.lua

AdventureProfileRules = class(AdventureProfileRules)

function AdventureProfileRules.init(arg_1_0, arg_1_1, arg_1_2)
	arg_1_0._profile_synchronizer = arg_1_1
	arg_1_0._network_server = arg_1_2
end

function AdventureProfileRules._profile_career_exists(arg_2_0, arg_2_1, arg_2_2)
	local var_2_0 = SPProfiles[arg_2_1]
	local var_2_1 = var_2_0 and var_2_0.careers

	return (var_2_1 and var_2_1[arg_2_2]) ~= nil
end

function AdventureProfileRules._profile_career_unlocked(arg_3_0, arg_3_1, arg_3_2)
	local var_3_0 = SPProfiles[arg_3_1]
	local var_3_1 = var_3_0 and var_3_0.careers
	local var_3_2 = var_3_1 and var_3_1[arg_3_2]

	return var_3_2 and var_3_2:is_unlocked_function(var_3_0.display_name, ExperienceSettings.max_level)
end

function AdventureProfileRules.handle_profile_delegation_for_joining_player(arg_4_0, arg_4_1, arg_4_2)
	local var_4_0 = arg_4_0._profile_synchronizer
	local var_4_1
	local var_4_2
	local var_4_3, var_4_4 = var_4_0:profile_by_peer(arg_4_1, arg_4_2)
	local var_4_5 = Managers.mechanism:reserved_party_id_by_peer(arg_4_1)

	if not var_4_3 then
		local var_4_6, var_4_7 = arg_4_0._network_server:peer_wanted_profile(arg_4_1, arg_4_2)
		local var_4_8 = var_4_0:get_profile_index_reservation(var_4_5, var_4_6)

		if not var_4_8 or var_4_8 == arg_4_1 then
			var_4_1, var_4_2 = var_4_6, var_4_7
		else
			var_4_1, var_4_2 = var_4_0:get_first_free_profile(var_4_5)
		end
	end

	if var_4_1 then
		local var_4_9 = SPProfiles[var_4_1]

		if not var_4_9 or var_4_9.affiliation ~= "heroes" then
			var_4_1, var_4_2 = var_4_0:get_first_free_profile(var_4_5)
		end

		if var_4_2 then
			if not arg_4_0:_profile_career_exists(var_4_1, var_4_2) then
				print("Career " .. var_4_2 .. " does not exist, switching to career index 1")

				var_4_2 = 1
			end

			if Network.peer_id() == arg_4_1 and not arg_4_0:_profile_career_unlocked(var_4_1, var_4_2) then
				print("Missing career: " .. var_4_2 .. " unlock requirements, switching to career index 1")

				var_4_2 = 1
			end

			local var_4_10 = false
			local var_4_11 = Managers.mechanism:try_reserve_profile_for_peer_by_mechanism(arg_4_1, var_4_1, var_4_2, false)

			fassert(var_4_11, "this should always succeed since we checked everything before")
			var_4_0:assign_full_profile(arg_4_1, arg_4_2, var_4_1, var_4_2, var_4_10)
		else
			local var_4_12 = Managers.party:get_player_status(arg_4_1, arg_4_2)

			var_4_12.profile_index = var_4_3
			var_4_12.career_index = var_4_4
		end
	end
end
