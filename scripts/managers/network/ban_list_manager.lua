-- chunkname: @scripts/managers/network/ban_list_manager.lua

BanListManager = class(BanListManager)

local var_0_0 = "ban_list"

function BanListManager.init(arg_1_0)
	arg_1_0._bans = {}

	arg_1_0:_load_bans()
end

function BanListManager.ban(arg_2_0, arg_2_1, arg_2_2, arg_2_3)
	arg_2_0._bans[arg_2_1] = {
		name = arg_2_2,
		ban_end = arg_2_3
	}
end

function BanListManager.unban(arg_3_0, arg_3_1)
	arg_3_0._bans[arg_3_1] = nil
end

function BanListManager.save(arg_4_0, arg_4_1)
	local function var_4_0(arg_5_0)
		arg_4_0:_save_done_callback(arg_5_0, arg_4_1)
	end

	local var_4_1 = true

	Managers.save:auto_save(var_0_0, arg_4_0._bans, var_4_0, var_4_1)
end

local function var_0_1(arg_6_0)
	local var_6_0 = arg_6_0.ban_end
	local var_6_1 = os.time()

	return var_6_0 == nil or var_6_1 < var_6_0
end

function BanListManager.is_banned(arg_7_0, arg_7_1)
	local var_7_0 = arg_7_0._bans[arg_7_1]

	if var_7_0 == nil then
		return false
	end

	return var_0_1(var_7_0)
end

function BanListManager.ban_list(arg_8_0)
	local var_8_0 = {}

	local function var_8_1(arg_9_0, arg_9_1, arg_9_2)
		local var_9_0 = arg_9_0[arg_9_1].name
		local var_9_1 = arg_9_0[arg_9_2].name

		if var_9_0 ~= var_9_1 then
			return var_9_0 < var_9_1
		end

		return arg_9_1 < arg_9_2
	end

	for iter_8_0, iter_8_1 in table.sorted(arg_8_0._bans, var_8_1) do
		var_8_0[#var_8_0 + 1] = {
			name = iter_8_1.name,
			peer_id = iter_8_0,
			ban_end = iter_8_1.ban_end
		}
	end

	return var_8_0
end

function BanListManager.banned_peers(arg_10_0)
	local var_10_0 = {}

	for iter_10_0, iter_10_1 in pairs(arg_10_0._bans) do
		var_10_0[#var_10_0 + 1] = iter_10_0
	end

	return var_10_0
end

function BanListManager._load_bans(arg_11_0)
	local function var_11_0(arg_12_0)
		arg_11_0:_load_done_callback(arg_12_0)
	end

	local var_11_1 = true

	Managers.save:auto_load(var_0_0, var_11_0, var_11_1)
end

function BanListManager._load_done_callback(arg_13_0, arg_13_1)
	if arg_13_1.error ~= nil then
		print(string.format("Failed to load the ban list (%s). It will be empty.", arg_13_1.error))

		return
	end

	table.merge(arg_13_0._bans, arg_13_1.data)
	arg_13_0:_remove_old_bans()
end

function BanListManager._save_done_callback(arg_14_0, arg_14_1, arg_14_2)
	if arg_14_1.error ~= nil then
		print(string.format("Failed to save the ban list (%s).", arg_14_1.error))
		arg_14_2(arg_14_1.error)

		return
	end

	arg_14_2()
end

function BanListManager._remove_old_bans(arg_15_0)
	local var_15_0 = {}

	for iter_15_0, iter_15_1 in pairs(arg_15_0._bans) do
		if var_0_1(iter_15_1) then
			var_15_0[iter_15_0] = iter_15_1
		end
	end

	arg_15_0._bans = var_15_0
end
