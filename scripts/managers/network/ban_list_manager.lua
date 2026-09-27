-- chunkname: @scripts/managers/network/ban_list_manager.lua

BanListManager = class(BanListManager)

local str = "ban_list"

BanListManager.init = function (self)
	-- function 1
	self._bans = {}

	self:_load_bans()
end

BanListManager.ban = function (arg_2_0, arg_2_1, arg_2_2, arg_2_3)
	-- function 2
	arg_2_0._bans[arg_2_1] = {
		name = arg_2_2,
		ban_end = arg_2_3
	}
end

BanListManager.unban = function (arg_3_0, arg_3_1)
	-- function 3
	arg_3_0._bans[arg_3_1] = nil
end

BanListManager.save = function (self, arg_4_1)
	-- function 4
	local function fn(arg_5_0)
		-- function 5
		self:_save_done_callback(arg_5_0, arg_4_1)
	end

	local flag = true

	Managers.save:auto_save(str, self._bans, fn, flag)
end

local function fn(self)
	-- function 6
	local ban_end = self.ban_end
	local time = os.time()

	return ban_end == nil or time < ban_end
end

BanListManager.is_banned = function (self, arg_7_1)
	-- function 7
	local var_7_0 = self._bans[arg_7_1]

	if var_7_0 == nil then
		return false
	end

	return fn(var_7_0)
end

BanListManager.ban_list = function (self)
	-- function 8
	local tbl = {}

	local function fn(self, arg_9_1, arg_9_2)
		-- function 9
		local name = self[arg_9_1].name
		local name_2 = self[arg_9_2].name

		if name ~= name_2 then
			return name < name_2
		end

		return arg_9_1 < arg_9_2
	end

	for iter_8_0, iter_8_1 in table.sorted(self._bans, fn) do
		tbl[#tbl + 1] = {
			name = iter_8_1.name,
			peer_id = iter_8_0,
			ban_end = iter_8_1.ban_end
		}
	end

	return tbl
end

BanListManager.banned_peers = function (self)
	-- function 10
	local tbl = {}

	for k, v in pairs(self._bans) do
		tbl[#tbl + 1] = k
	end

	return tbl
end

BanListManager._load_bans = function (arg_11_0)
	-- function 11
	local function fn(arg_12_0)
		-- function 12
		arg_11_0:_load_done_callback(arg_12_0)
	end

	local flag = true

	Managers.save:auto_load(str, fn, flag)
end

BanListManager._load_done_callback = function (self, arg_13_1)
	-- function 13
	if arg_13_1.error ~= nil then
		print(string.format("Failed to load the ban list (%s). It will be empty.", arg_13_1.error))

		return
	end

	table.merge(self._bans, arg_13_1.data)
	self:_remove_old_bans()
end

BanListManager._save_done_callback = function (arg_14_0, arg_14_1, arg_14_2)
	-- function 14
	if arg_14_1.error ~= nil then
		print(string.format("Failed to save the ban list (%s).", arg_14_1.error))
		arg_14_2(arg_14_1.error)

		return
	end

	arg_14_2()
end

BanListManager._remove_old_bans = function (self)
	-- function 15
	local tbl = {}

	for k, v in pairs(self._bans) do
		if not fn(v) then
			tbl[k] = v
		end
	end

	self._bans = tbl
end
