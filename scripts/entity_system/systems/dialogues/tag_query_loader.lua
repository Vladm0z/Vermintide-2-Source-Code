-- chunkname: @scripts/entity_system/systems/dialogues/tag_query_loader.lua

local var_0_0
local var_0_1

if rawget(_G, "RuleDatabase") then
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

local function var_0_2(arg_1_0, ...)
	if script_data.dialogue_debug_queries then
		print(string.format("[TagQueryLoader] " .. arg_1_0, ...))
	end
end

TagQueryLoader = class(TagQueryLoader)

function TagQueryLoader.init(arg_2_0, arg_2_1, arg_2_2)
	arg_2_0.loaded_files = {}
	arg_2_0.file_environment = {
		OP = var_0_0,
		CombiningOP = var_0_1,
		math = math,
		define_rule = function(arg_3_0)
			arg_2_1:define_rule(arg_3_0)
		end,
		add_dialogues = function(arg_4_0)
			for iter_4_0, iter_4_1 in pairs(arg_4_0) do
				iter_4_1.category = iter_4_1.category or "default"
				arg_2_2[iter_4_0] = iter_4_1
			end
		end
	}
	arg_2_0.tagquery_database = arg_2_1
end

function tag_query_errorfunc(arg_5_0)
	return arg_5_0 .. "\n" .. debug.traceback()
end

function TagQueryLoader.load_file(arg_6_0, arg_6_1)
	local var_6_0 = require(arg_6_1)

	arg_6_0:_trigger_file_function(arg_6_1, var_6_0)
end

function TagQueryLoader._trigger_file_function(arg_7_0, arg_7_1, arg_7_2)
	setfenv(arg_7_2, arg_7_0.file_environment)

	local var_7_0 = arg_7_0.tagquery_database.rules_n

	arg_7_2()

	local var_7_1 = arg_7_0.tagquery_database.rules_n - var_7_0

	var_0_2("Loaded file %s. Read %d rules.", arg_7_1, var_7_1)
end

function TagQueryLoader.unload_files(arg_8_0)
	for iter_8_0, iter_8_1 in ipairs(arg_8_0.loaded_files) do
		if package.loaded[iter_8_1] then
			local var_8_0 = package.load_order
			local var_8_1 = #var_8_0
			local var_8_2

			for iter_8_2 = var_8_1, 1, -1 do
				if var_8_0[iter_8_2] == iter_8_1 then
					var_8_2 = true
					package.loaded[iter_8_1] = nil

					table.remove(var_8_0, iter_8_2)

					break
				end
			end

			fassert(var_8_2)
			var_0_2("TagQueryLoader: Unloaded file: " .. tostring(iter_8_1))
		else
			var_0_2("TagQueryLoader: Could not unload file: " .. tostring(iter_8_1))
		end
	end

	arg_8_0.file_environment = nil
	arg_8_0.loaded_files = nil
	arg_8_0.tagquery_database = nil
end

function TagQueryLoader.load_auto_load_files(arg_9_0, arg_9_1)
	local var_9_0 = DialogueSettings.auto_load_files

	for iter_9_0, iter_9_1 in ipairs(var_9_0) do
		local var_9_1 = DialogueSettings.cached_auto_load_files[iter_9_1]

		if var_9_1 then
			arg_9_0:_trigger_file_function(iter_9_1, var_9_1)
		end

		local var_9_2 = DialogueSettings.cached_auto_load_files[iter_9_1 .. "_markers"]

		if var_9_2 then
			for iter_9_2, iter_9_3 in pairs(var_9_2) do
				fassert(not arg_9_1[iter_9_2], "[DialogueSystem] There is already a marker called %s registered", iter_9_2)

				arg_9_1[iter_9_2] = iter_9_3
			end
		end
	end
end
