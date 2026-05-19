-- chunkname: @scripts/network/lobby_members.lua

LobbyMembers = class(LobbyMembers)

function LobbyMembers.init(arg_1_0, arg_1_1)
	arg_1_0.lobby = arg_1_1
	arg_1_0.members_joined = {}
	arg_1_0.members_left = {}

	local var_1_0, var_1_1 = arg_1_1:members()

	var_1_1 = var_1_1 or #var_1_0
	arg_1_0._member_buffer = var_1_0
	arg_1_0.member_count = var_1_1

	local var_1_2 = {}

	for iter_1_0 = 1, var_1_1 do
		local var_1_3 = var_1_0[iter_1_0]

		var_1_2[var_1_3] = true
		arg_1_0.members_joined[iter_1_0] = var_1_3
	end

	arg_1_0.members = var_1_2
	arg_1_0._members_changed = true

	if IS_CONSOLE and not Managers.account:offline_mode() then
		arg_1_0.lobby:update_user_names()
	end
end

function LobbyMembers.clear(arg_2_0)
	return
end

function LobbyMembers.update(arg_3_0)
	local var_3_0 = arg_3_0.members_joined
	local var_3_1 = arg_3_0.members_left

	table.clear(var_3_0)
	table.clear(var_3_1)

	local var_3_2 = arg_3_0._member_buffer

	table.clear(var_3_2)

	local var_3_3, var_3_4 = arg_3_0.lobby:members(var_3_2)

	if not var_3_4 then
		arg_3_0._member_buffer = var_3_3
		var_3_4 = #var_3_3
	end

	arg_3_0.member_count = var_3_4

	local var_3_5 = arg_3_0.members

	for iter_3_0 = 1, var_3_4 do
		local var_3_6 = var_3_3[iter_3_0]

		if var_3_5[var_3_6] == nil then
			var_3_0[#var_3_0 + 1] = var_3_6

			printf("[LobbyMembers] Member joined %s", tostring(var_3_6))

			if IS_CONSOLE then
				local var_3_7 = Managers.account

				if IS_XB1 then
					var_3_7:query_bandwidth()

					arg_3_0._members_changed = true
				end

				if not var_3_7:offline_mode() then
					arg_3_0.lobby:update_user_names()
				end
			end
		end

		var_3_5[var_3_6] = false
	end

	for iter_3_1, iter_3_2 in pairs(var_3_5) do
		if iter_3_2 == false then
			var_3_5[iter_3_1] = true
		else
			printf("[LobbyMembers] Member left %s", tostring(iter_3_1))

			var_3_1[#var_3_1 + 1] = iter_3_1
			var_3_5[iter_3_1] = nil

			if IS_XB1 then
				if table.size(var_3_5) <= 1 then
					Managers.account:reset_bandwidth_query()
				end

				arg_3_0._members_changed = true
			end
		end
	end
end

function LobbyMembers.get_members_left(arg_4_0)
	return arg_4_0.members_left
end

function LobbyMembers.get_members_joined(arg_5_0)
	return arg_5_0.members_joined
end

function LobbyMembers.get_members(arg_6_0)
	return arg_6_0._member_buffer
end

function LobbyMembers.get_member_count(arg_7_0)
	return arg_7_0.member_count
end

function LobbyMembers.members_map(arg_8_0)
	return arg_8_0.members
end

if IS_XB1 then
	function LobbyMembers.check_members_changed(arg_9_0)
		local var_9_0 = arg_9_0._members_changed

		arg_9_0._members_changed = nil

		return var_9_0
	end
end
