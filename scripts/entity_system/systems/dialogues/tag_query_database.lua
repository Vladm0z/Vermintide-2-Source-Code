-- chunkname: @scripts/entity_system/systems/dialogues/tag_query_database.lua

require("scripts/entity_system/systems/dialogues/tag_query")

TagQueryDatabase = class(TagQueryDatabase)

TagQueryDatabase.init = function (arg_1_0)
	arg_1_0.database = RuleDatabase.initialize()
	arg_1_0.rule_id_mapping = {}
	arg_1_0.rules_n = 0
	arg_1_0.contexts_by_object = {}
	arg_1_0.queries = {}
end

TagQueryDatabase.destroy = function (arg_2_0)
	RuleDatabase.destroy(arg_2_0.database)

	arg_2_0.database = nil
	arg_2_0.rule_id_mapping = nil
	arg_2_0.contexts_by_object = nil
	arg_2_0.queries = nil
end

TagQueryDatabase.add_object_context = function (arg_3_0, arg_3_1, arg_3_2, arg_3_3)
	local var_3_0 = arg_3_0.contexts_by_object[arg_3_1] or {}

	arg_3_0.contexts_by_object[arg_3_1] = var_3_0
	var_3_0[arg_3_2] = arg_3_3
end

TagQueryDatabase.get_object_context = function (arg_4_0, arg_4_1)
	return arg_4_0.contexts_by_object[arg_4_1]
end

TagQueryDatabase.remove_object = function (arg_5_0, arg_5_1)
	arg_5_0.contexts_by_object[arg_5_1] = nil
end

TagQueryDatabase.set_global_context = function (arg_6_0, arg_6_1)
	arg_6_0.global_context = arg_6_1
end

TagQueryDatabase.create_query = function (arg_7_0)
	return setmetatable({
		query_context = {},
		tagquery_database = arg_7_0
	}, TagQuery)
end

TagQueryDatabase.add_query = function (arg_8_0, arg_8_1)
	arg_8_0.queries[#arg_8_0.queries + 1] = arg_8_1
end

TagQueryDatabase.finalize_rules = function (arg_9_0)
	RuleDatabase.sort_rules(arg_9_0.database)
end

RuleDatabase.initialize_static_values()

local var_0_0 = {
	EQ = RuleDatabase.OPERATOR_EQUAL,
	LT = RuleDatabase.OPERATOR_LT,
	GT = RuleDatabase.OPERATOR_GT,
	NOT = RuleDatabase.OPERATOR_NOT,
	LTEQ = RuleDatabase.OPERATOR_LTEQ,
	GTEQ = RuleDatabase.OPERATOR_GTEQ,
	NEQ = RuleDatabase.OPERATOR_NOT_EQUAL,
	RAND = RuleDatabase.OPERATOR_RAND
}
local var_0_1 = table.mirror_array_inplace({
	"global_context",
	"query_context",
	"user_context",
	"user_memory",
	"faction_memory"
})

TagQueryDatabase.define_rule = function (arg_10_0, arg_10_1)
	local var_10_0 = arg_10_1.name
	local var_10_1 = {}

	for iter_10_0 = 1, #arg_10_1.criterias do
		local var_10_2 = arg_10_1.criterias[iter_10_0]

		arg_10_0:parse_criteria(var_10_2, arg_10_1.criterias, var_10_1, arg_10_1)
	end

	local var_10_3 = #var_10_1

	arg_10_1.n_criterias = var_10_3

	fassert(var_10_3 <= (RuleDatabase.RULE_MAX_NUM_CRITERIA or 8), "Too many criteria in dialogue %s", var_10_0)

	local var_10_4 = arg_10_1.probability or 1

	arg_10_0:_optimize_rule_definition(arg_10_1)

	local var_10_5 = RuleDatabase.add_rule(arg_10_0.database, var_10_0, var_10_3, var_10_1, var_10_4)

	arg_10_0.rule_id_mapping[var_10_5] = arg_10_1
	arg_10_0.rule_id_mapping[arg_10_1.name] = var_10_5
	arg_10_0.rules_n = arg_10_0.rules_n + 1
end

local var_0_2 = table.set({
	"name",
	"n_criterias",
	"response",
	"on_done"
})

TagQueryDatabase._optimize_rule_definition = function (arg_11_0, arg_11_1)
	for iter_11_0, iter_11_1 in pairs(arg_11_1) do
		if not var_0_2[iter_11_0] then
			arg_11_1[iter_11_0] = nil
		end
	end
end

local var_0_3 = table.mirror_array_inplace({
	"context_name",
	"criteria_key",
	"operator"
})
local var_0_4 = table.copy_array(var_0_3)

table.mirror_array_inplace(table.append(var_0_4, {
	"value",
	"combining_operator"
}))

local var_0_5 = table.copy_array(var_0_3)

table.mirror_array_inplace(table.append(var_0_5, {
	"operator",
	"value",
	"combining_operator"
}))

local function var_0_6(arg_12_0, arg_12_1)
	local var_12_0

	if arg_12_0[var_0_3.operator] == "TIMEDIFF" then
		return arg_12_0[var_0_5[arg_12_1]]
	else
		return arg_12_0[var_0_4[arg_12_1]]
	end
end

local var_0_7 = table.mirror_array_inplace({
	"context_name",
	"criteria_key",
	"operator_index",
	"value",
	"has_time_diff",
	"combining_operator_id",
	"combining_operator_group_id"
})

local function var_0_8(arg_13_0)
	for iter_13_0 = #arg_13_0, 1, -1 do
		local var_13_0 = arg_13_0[iter_13_0][var_0_7.combining_operator_group_id]

		if var_13_0 ~= 0 then
			return var_13_0
		end
	end
end

local var_0_9 = {
	AND_NEXT = RuleDatabase.COMBINING_OPERATOR_AND,
	OR_NEXT = RuleDatabase.COMBINING_OPERATOR_OR
}

local function var_0_10(arg_14_0, arg_14_1, arg_14_2, arg_14_3, arg_14_4)
	local var_14_0 = arg_14_3[#arg_14_3]
	local var_14_1 = 0
	local var_14_2 = var_0_9[arg_14_1]

	if not var_14_2 then
		fassert(not arg_14_1, "[DialogueSystem] Unknown operator '%s' found in rule '%s'", arg_14_1, arg_14_4.name)

		local var_14_3 = arg_14_2 and var_0_6(arg_14_2, "combining_operator")

		if var_14_3 and var_14_3 ~= "AND_NEXT" then
			var_14_2 = var_0_9.OR_NEXT
			var_14_1 = var_14_0[var_0_7.combining_operator_group_id]
		else
			var_14_2 = var_0_9.AND_NEXT
		end
	elseif arg_14_1 == (arg_14_2 and var_0_6(arg_14_2, "combining_operator")) then
		var_14_1 = var_14_0[var_0_7.combining_operator_group_id]
	elseif var_14_2 ~= var_0_9.AND_NEXT then
		var_14_1 = (var_0_8(arg_14_3) or 0) + 1
	end

	return var_14_2, var_14_1
end

TagQueryDatabase.parse_criteria = function (arg_15_0, arg_15_1, arg_15_2, arg_15_3, arg_15_4)
	local var_15_0 = arg_15_1[var_0_3.context_name]
	local var_15_1 = arg_15_1[var_0_3.criteria_key]
	local var_15_2 = arg_15_1[var_0_3.operator]
	local var_15_3 = var_0_6(arg_15_1, "value")
	local var_15_4 = var_0_6(arg_15_1, "combining_operator")
	local var_15_5 = var_15_2 == "TIMEDIFF"

	if var_15_5 then
		var_15_2 = var_0_6(arg_15_1, "operator")

		fassert(var_0_0[var_15_2], "No operator besides TIMEDIFF in rule %q", arg_15_4.name)
	end

	local var_15_6 = var_0_0[var_15_2]

	fassert(var_15_6, "No such rule operator named %q in rule %q", tostring(var_15_2), arg_15_4.name)
	fassert(var_0_1[var_15_0], "No such context name %q", var_15_0)

	local var_15_7 = type(var_15_3)

	fassert(var_15_7 == "boolean" or var_15_7 == "string" or var_15_7 == "number", "Unsupported type %s in rule %s", var_15_7, arg_15_4.name)

	if var_15_7 == "boolean" then
		var_15_3 = var_15_3 and 1 or 0
	end

	local var_15_8 = arg_15_2[#arg_15_3]
	local var_15_9, var_15_10 = var_0_10(arg_15_1, var_15_4, var_15_8, arg_15_3, arg_15_4)

	arg_15_3[#arg_15_3 + 1] = {
		[var_0_7.context_name] = var_15_0,
		[var_0_7.criteria_key] = var_15_1,
		[var_0_7.operator_index] = var_15_6,
		[var_0_7.value] = var_15_3,
		[var_0_7.has_time_diff] = var_15_5,
		[var_0_7.combining_operator_id] = var_15_9,
		[var_0_7.combining_operator_group_id] = var_15_10
	}
end

local var_0_11 = {}

local function var_0_12(arg_16_0, arg_16_1)
	return var_0_11[arg_16_0] > var_0_11[arg_16_1]
end

local var_0_13 = {
	[0] = 0
}

TagQueryDatabase.iterate_queries = function (arg_17_0, arg_17_1, arg_17_2)
	table.clear(var_0_11)

	local var_17_0 = 0

	for iter_17_0 = 1, #arg_17_0.queries do
		local var_17_1 = arg_17_0:iterate_query(arg_17_2)

		if var_17_1.result then
			var_17_0 = var_17_0 + 1
			var_0_13[var_17_0] = var_17_1
			var_0_11[var_17_1] = math.random(1, var_17_1.validated_rule.n_criterias)
		end
	end

	for iter_17_1 = var_17_0 + 1, var_0_13[0] do
		var_0_13[iter_17_1] = nil
	end

	var_0_13[0] = var_17_0

	table.sort(var_0_13, var_0_12)

	for iter_17_2 = 1, var_17_0 do
		arg_17_1[iter_17_2] = var_0_13[iter_17_2]
	end

	return var_17_0
end

local var_0_14 = {}

TagQueryDatabase.iterate_query = function (arg_18_0, arg_18_1)
	local var_18_0 = table.remove(arg_18_0.queries, 1)

	if not var_18_0 then
		return
	end

	local var_18_1 = var_18_0.query_context
	local var_18_2 = var_18_1.source
	local var_18_3 = arg_18_0.contexts_by_object[var_18_2]

	if var_18_3 == nil then
		return var_18_0
	end

	local var_18_4 = {
		arg_18_0.global_context or var_0_14,
		var_18_1 or var_0_14,
		var_18_3.user_context or var_0_14,
		var_18_3.user_memory or var_0_14,
		var_18_3.faction_memory or var_0_14
	}
	local var_18_5 = RuleDatabase.iterate_query(arg_18_0.database, var_18_4, arg_18_1)

	if var_18_5 then
		local var_18_6 = arg_18_0.rule_id_mapping[var_18_5]

		var_18_0.validated_rule = var_18_6
		var_18_0.result = var_18_6.response
	end

	return var_18_0
end

TagQueryDatabase.has_queries = function (arg_19_0)
	return not table.is_empty(arg_19_0.queries)
end

TagQueryDatabase._debug_print_query = function (arg_20_0, arg_20_1, arg_20_2, arg_20_3)
	local var_20_0 = {}

	table.insert(var_20_0, "--------------- STARTING NEW QUERY ---------------")
	table.insert(var_20_0, "Query context:")

	for iter_20_0, iter_20_1 in pairs(arg_20_1.query_context) do
		table.insert(var_20_0, string.format("\t%-15s: %-15s", iter_20_0, tostring(iter_20_1)))
	end

	table.insert(var_20_0, "User contexts:")

	for iter_20_2, iter_20_3 in pairs(arg_20_2) do
		table.insert(var_20_0, "\t" .. iter_20_2)

		if type(iter_20_3) == "table" then
			for iter_20_4, iter_20_5 in pairs(iter_20_3) do
				table.insert(var_20_0, string.format("\t\t%-15s : %-15s", iter_20_4, tostring(iter_20_5)))
			end
		end
	end

	table.insert(var_20_0, "Global context:")

	if arg_20_3 then
		for iter_20_6, iter_20_7 in pairs(arg_20_3) do
			table.insert(var_20_0, string.format("\t%-15s : %-15s", iter_20_6, tostring(iter_20_7)))
		end
	end

	table.insert(var_20_0, "--------------- END OF QUERY CONTEXTS ---------------")
	print(table.concat(var_20_0, "\n"))
end

local var_0_15 = {}

TagQueryDatabase.debug_test_query = function (arg_21_0, arg_21_1, arg_21_2, arg_21_3, arg_21_4, arg_21_5)
	print("--------------- TESTING FOLLOWING QUERY ---------------")
	print(arg_21_1, arg_21_2, arg_21_3, arg_21_4, arg_21_5)
	table.dump(arg_21_3.query_context)

	local var_21_0 = arg_21_0:create_query()
	local var_21_1 = Managers.player:local_player().player_unit

	var_21_0:add("concept", arg_21_1, "source", var_21_1, "source_name", arg_21_2)
	var_21_0:finalize()

	local var_21_2 = arg_21_0.queries[#arg_21_0.queries]

	if not var_21_2 then
		print("FAILED TO CREATE NEW QUERY ", var_21_2)

		return
	end

	local var_21_3 = var_21_2.query_context
	local var_21_4 = var_21_3.source
	local var_21_5 = table.clone(arg_21_0.contexts_by_object[var_21_4])

	for iter_21_0, iter_21_1 in pairs(arg_21_3.query_context) do
		print(string.format("\t%-15s: %-15s", iter_21_0, tostring(iter_21_1)))

		var_21_3[iter_21_0] = iter_21_1
	end

	for iter_21_2, iter_21_3 in pairs(arg_21_4) do
		for iter_21_4, iter_21_5 in pairs(iter_21_3) do
			print(string.format("\t\t%-15s : %-15s", iter_21_4, tostring(iter_21_5)))

			var_21_5[iter_21_2][iter_21_4] = iter_21_5
		end
	end

	if arg_21_5 then
		for iter_21_6, iter_21_7 in pairs(arg_21_5) do
			print(string.format("\t%-15s : %-15s", iter_21_6, tostring(iter_21_7)))

			arg_21_0.global_context[iter_21_6] = iter_21_7
		end
	end

	local var_21_6 = {
		arg_21_0.global_context or var_0_15,
		var_21_3 or var_0_15,
		var_21_5.user_context or var_0_15,
		var_21_5.user_memory or var_0_15,
		var_21_5.faction_memory or var_0_15
	}
	local var_21_7 = Managers.time:time("game")
	local var_21_8 = RuleDatabase.iterate_query(arg_21_0.database, var_21_6, var_21_7)

	if var_21_8 then
		local var_21_9 = arg_21_0.rule_id_mapping[var_21_8]

		var_21_2.validated_rule = var_21_9
		var_21_2.result = var_21_9.response

		print("Following rule succeeded:", var_21_2.result)
	else
		print("Failed testing query")
	end

	print("--------------- END OF TEST QUERY---------------")
end
