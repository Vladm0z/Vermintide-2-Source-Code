-- chunkname: @scripts/managers/performance_title/performance_title_manager.lua

require("scripts/managers/performance_title/performance_title_templates")

PerformanceTitleManager = class(PerformanceTitleManager)

local tbl = {
	"rpc_sync_performance_titles"
}
local str = "0"

local function fn(arg_1_0)
	-- function 1
	local uint_16 = NetworkConstants.uint_16
	local min = uint_16.min
	local max = uint_16.max

	return math.clamp(arg_1_0, min, max)
end

PerformanceTitleManager.init = function (self, arg_2_1, arg_2_2, arg_2_3)
	-- function 2
	self._network_transmit = arg_2_1
	self._statistics_db = arg_2_2
	self._is_server = arg_2_3
	self._assigned_titles = {}
end

PerformanceTitleManager.register_rpcs = function (self, arg_3_1)
	-- function 3
	arg_3_1:register(self, unpack(tbl))

	self._network_event_delegate = arg_3_1
end

PerformanceTitleManager.unregister_rpcs = function (self)
	-- function 4
	self._network_event_delegate:unregister(self)

	self._network_event_delegate = nil
end

PerformanceTitleManager.destroy = function (self)
	-- function 5
	self._statistics_db = nil
	self._network_transmit = nil
end

PerformanceTitleManager.assigned_titles = function (self)
	-- function 6
	return self._assigned_titles
end

PerformanceTitleManager._evaluate_player_titles = function (self, arg_7_1, arg_7_2)
	-- function 7
	local _statistics_db = self._statistics_db
	local stats_id = arg_7_1:stats_id()
	local titles = PerformanceTitles.titles
	local templates = PerformanceTitles.templates
	local flag = false

	for k, v in pairs(titles) do
		local evaluate, var_7_6 = templates[v.evaluation_template].evaluate(_statistics_db, stats_id, v)

		if not evaluate then
			arg_7_2[k] = var_7_6
			flag = true
		end
	end

	return flag
end

PerformanceTitleManager._get_title_list_from_player_titles = function (arg_8_0, arg_8_1)
	-- function 8
	local tbl = {}

	for k, v in pairs(arg_8_1) do
		for k_2, v_2 in pairs(v) do
			if not table.contains(tbl, k_2) then
				tbl[#tbl + 1] = k_2
			end
		end
	end

	return tbl
end

PerformanceTitleManager._find_individually_achieved_title = function (arg_9_0, arg_9_1, arg_9_2)
	-- function 9
	local var_9_0
	local num = 0

	for k, v in pairs(arg_9_1) do
		if not v[arg_9_2] then
			num = num + 1
			var_9_0 = k
		end
	end

	if num ~= 1 then
		var_9_0 = nil
	end

	return var_9_0
end

PerformanceTitleManager._assign_title = function (arg_10_0, arg_10_1, arg_10_2, arg_10_3, arg_10_4)
	-- function 10
	local var_10_0 = arg_10_2[arg_10_3][arg_10_4]
	local network_id = arg_10_3:network_id()
	local local_player_id = arg_10_3:local_player_id()

	arg_10_1[#arg_10_1 + 1] = {
		peer_id = network_id,
		local_player_id = local_player_id,
		title = arg_10_4,
		amount = var_10_0
	}
end

PerformanceTitleManager._remove_title_from_player_titles = function (arg_11_0, arg_11_1, arg_11_2)
	-- function 11
	for k, v in pairs(arg_11_1) do
		v[arg_11_2] = nil
	end
end

PerformanceTitleManager._assign_individual_titles = function (self, arg_12_1, arg_12_2)
	-- function 12
	local _get_title_list_from_player_titles = self:_get_title_list_from_player_titles(arg_12_1)
	local num = 1

	while _get_title_list_from_player_titles[num] ~= nil do
		local var_12_2 = _get_title_list_from_player_titles[num]
		local _find_individually_achieved_title = self:_find_individually_achieved_title(arg_12_1, var_12_2)

		if not _find_individually_achieved_title then
			self:_assign_title(arg_12_2, arg_12_1, _find_individually_achieved_title, var_12_2)

			arg_12_1[_find_individually_achieved_title] = nil

			self:_remove_title_from_player_titles(arg_12_1, var_12_2)

			num = 1
		else
			num = num + 1
		end
	end
end

PerformanceTitleManager._assign_compared_titles = function (self, arg_13_1, arg_13_2)
	-- function 13
	local _get_title_list_from_player_titles = self:_get_title_list_from_player_titles(arg_13_1)
	local titles = PerformanceTitles.titles
	local templates = PerformanceTitles.templates

	for i, v in ipairs(_get_title_list_from_player_titles) do
		local num = 0
		local var_13_4
		local var_13_5 = templates[titles[v].evaluation_template]

		for k, v_2 in pairs(arg_13_1) do
			local var_13_6 = v_2[v]

			if not var_13_6 and not var_13_5.compare(var_13_6, num) then
				num = var_13_6
				var_13_4 = k
			end
		end

		if not var_13_4 then
			self:_assign_title(arg_13_2, arg_13_1, var_13_4, v)

			arg_13_1[var_13_4] = nil
		end
	end
end

PerformanceTitleManager._sync_assigned_titles = function (self, arg_14_1)
	-- function 14
	local tbl = {}
	local tbl_2 = {}
	local tbl_3 = {}
	local tbl_4 = {}

	for i = 1, 4 do
		local var_14_4 = arg_14_1[i]

		if not var_14_4 then
			tbl[i] = var_14_4.peer_id
			tbl_2[i] = var_14_4.local_player_id
			tbl_3[i] = NetworkLookup.performance_titles[var_14_4.title]
			tbl_4[i] = fn(var_14_4.amount)
		else
			tbl[i] = str
			tbl_2[i] = 0
			tbl_3[i] = NetworkLookup.performance_titles["n/a"]
			tbl_4[i] = 0
		end
	end

	self._network_transmit:send_rpc_clients("rpc_sync_performance_titles", tbl, tbl_2, tbl_3, tbl_4)
end

PerformanceTitleManager.evaluate_titles = function (self, arg_15_1)
	-- function 15
	fassert(self._is_server, "Should only be server calling this")

	local tbl = {}

	for k, v in pairs(arg_15_1) do
		local tbl_2 = {}

		if not self:_evaluate_player_titles(v, tbl_2) then
			tbl[v] = tbl_2
		end
	end

	local tbl_3 = {}

	self:_assign_individual_titles(tbl, tbl_3)

	if table.size(tbl) > 0 then
		self:_assign_compared_titles(tbl, tbl_3)
	end

	self._assigned_titles = tbl_3

	self:_sync_assigned_titles(tbl_3)
end

PerformanceTitleManager._translate_title_assignment = function (arg_16_0, arg_16_1, arg_16_2, arg_16_3, arg_16_4)
	-- function 16
	if arg_16_1 == str then
		return nil
	end

	return {
		peer_id = arg_16_1,
		local_player_id = arg_16_2,
		title = NetworkLookup.performance_titles[arg_16_3],
		amount = arg_16_4
	}
end

PerformanceTitleManager.rpc_sync_performance_titles = function (self, arg_17_1, arg_17_2, arg_17_3, arg_17_4, arg_17_5)
	-- function 17
	local tbl = {}

	for i = 1, 4 do
		local var_17_1 = arg_17_2[i]

		if var_17_1 ~= str then
			local var_17_2 = arg_17_3[i]
			local var_17_3 = NetworkLookup.performance_titles[arg_17_4[i]]
			local var_17_4 = arg_17_5[i]

			tbl[#tbl + 1] = {
				peer_id = var_17_1,
				local_player_id = var_17_2,
				title = var_17_3,
				amount = var_17_4
			}
		end
	end

	self._assigned_titles = tbl
end
