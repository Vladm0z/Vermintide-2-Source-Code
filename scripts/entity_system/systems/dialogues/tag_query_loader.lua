-- chunkname: @scripts/entity_system/systems/dialogues/tag_query_loader.lua

local var_0_0
local var_0_1

if not rawget(_G, "RuleDatabase") then
	RuleDatabase.initialize_static_values()

	var_0_0 = {
		GT = "GT",
		LT = "LT",
		NEQ = "NEQ",
		LTEQ = "LTEQ",
		GTEQ = "GTEQ",
		TIMEDIFF = "TIMEDIFF",
		EQ = "EQ",
		NOT = "NOT",
		TIMESET = TagQuery.OP.TIMESET,
		ADD = TagQuery.OP.ADD,
		SUB = TagQuery.OP.SUB,
		NUMSET = TagQuery.OP.NUMSET
	}
	var_0_1 = {
		AND_NEXT = "AND_NEXT",
		OR_NEXT = "OR_NEXT"
	}
else
	var_0_0 = TagQuery.OP
	var_0_1 = TagQuery.CombiningOP
end

local function fn(arg_1_0, ...)
	-- function 1
	if not script_data.dialogue_debug_queries then
		print(string.format("[TagQueryLoader] " .. arg_1_0, ...))
	end
end

TagQueryLoader = class(TagQueryLoader)

TagQueryLoader.init = function (self, arg_2_1, arg_2_2)
	-- function 2
	self.loaded_files = {}
	self.file_environment = {
		OP = var_0_0,
		CombiningOP = var_0_1,
		math = math,
		define_rule = function (arg_3_0)
			-- function 3
			arg_2_1:define_rule(arg_3_0)
		end,
		add_dialogues = function (arg_4_0)
			-- function 4
			for k, v in pairs(arg_4_0) do
				local category = v.category

				category = category or "default"
				v.category = category
				arg_2_2[k] = v
			end
		end
	}
	self.tagquery_database = arg_2_1
end

function tag_query_errorfunc(arg_5_0)
	-- function 5
	return arg_5_0 .. "\n" .. debug.traceback()
end

TagQueryLoader.load_file = function (self, arg_6_1)
	-- function 6
	local var_6_0 = require(arg_6_1)

	self:_trigger_file_function(arg_6_1, var_6_0)
end

TagQueryLoader._trigger_file_function = function (self, arg_7_1, arg_7_2)
	-- function 7
	setfenv(arg_7_2, self.file_environment)

	local rules_n = self.tagquery_database.rules_n

	arg_7_2()

	local num = self.tagquery_database.rules_n - rules_n

	fn("Loaded file %s. Read %d rules.", arg_7_1, num)
end

TagQueryLoader.unload_files = function (self)
	-- function 8
	for i, v in ipairs(self.loaded_files) do
		if not package.loaded[v] then
			local load_order = package.load_order
			local count = #load_order
			local var_8_2

			for k = count, 1, -1 do
				if load_order[k] == v then
					var_8_2 = true
					package.loaded[v] = nil

					table.remove(load_order, k)

					break
				end
			end

			fassert(var_8_2)
			fn("TagQueryLoader: Unloaded file: " .. tostring(v))
		else
			fn("TagQueryLoader: Could not unload file: " .. tostring(v))
		end
	end

	self.file_environment = nil
	self.loaded_files = nil
	self.tagquery_database = nil
end

TagQueryLoader.load_auto_load_files = function (self, arg_9_1)
	-- function 9
	local auto_load_files = DialogueSettings.auto_load_files

	for i, v in ipairs(auto_load_files) do
		local var_9_1 = DialogueSettings.cached_auto_load_files[v]

		if not var_9_1 then
			self:_trigger_file_function(v, var_9_1)
		end

		local var_9_2 = DialogueSettings.cached_auto_load_files[v .. "_markers"]

		if not var_9_2 then
			for k, v_2 in pairs(var_9_2) do
				fassert(not arg_9_1[k], "[DialogueSystem] There is already a marker called %s registered", k)

				arg_9_1[k] = v_2
			end
		end
	end
end
