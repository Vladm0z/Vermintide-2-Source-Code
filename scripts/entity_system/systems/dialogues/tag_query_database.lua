-- chunkname: @scripts/entity_system/systems/dialogues/tag_query_database.lua

require("scripts/entity_system/systems/dialogues/tag_query")

TagQueryDatabase = class(TagQueryDatabase)

TagQueryDatabase.init = function (self)
	-- function 1
	self.database = RuleDatabase.initialize()
	self.rule_id_mapping = {}
	self.rules_n = 0
	self.contexts_by_object = {}
	self.queries = {}
end

TagQueryDatabase.destroy = function (self)
	-- function 2
	RuleDatabase.destroy(self.database)

	self.database = nil
	self.rule_id_mapping = nil
	self.contexts_by_object = nil
	self.queries = nil
end

TagQueryDatabase.add_object_context = function (self, arg_3_1, arg_3_2, arg_3_3)
	-- function 3
	local var_3_0 = self.contexts_by_object[arg_3_1]

	var_3_0 = var_3_0 or {}
	self.contexts_by_object[arg_3_1] = var_3_0
	var_3_0[arg_3_2] = arg_3_3
end

TagQueryDatabase.get_object_context = function (self, arg_4_1)
	-- function 4
	return self.contexts_by_object[arg_4_1]
end

TagQueryDatabase.remove_object = function (arg_5_0, arg_5_1)
	-- function 5
	arg_5_0.contexts_by_object[arg_5_1] = nil
end

TagQueryDatabase.set_global_context = function (self, arg_6_1)
	-- function 6
	self.global_context = arg_6_1
end

TagQueryDatabase.create_query = function (arg_7_0)
	-- function 7
	return setmetatable({
		query_context = {},
		tagquery_database = arg_7_0
	}, TagQuery)
end

TagQueryDatabase.add_query = function (arg_8_0, arg_8_1)
	-- function 8
	arg_8_0.queries[#arg_8_0.queries + 1] = arg_8_1
end

TagQueryDatabase.finalize_rules = function (self)
	-- function 9
	RuleDatabase.sort_rules(self.database)
end

RuleDatabase.initialize_static_values()

local tbl = {
	EQ = RuleDatabase.OPERATOR_EQUAL,
	LT = RuleDatabase.OPERATOR_LT,
	GT = RuleDatabase.OPERATOR_GT,
	NOT = RuleDatabase.OPERATOR_NOT,
	LTEQ = RuleDatabase.OPERATOR_LTEQ,
	GTEQ = RuleDatabase.OPERATOR_GTEQ,
	NEQ = RuleDatabase.OPERATOR_NOT_EQUAL,
	RAND = RuleDatabase.OPERATOR_RAND
}
local mirror_array_inplace = table.mirror_array_inplace({
	"global_context",
	"query_context",
	"user_context",
	"user_memory",
	"faction_memory"
})

TagQueryDatabase.define_rule = function (self, arg_10_1)
	-- function 10
	local name = arg_10_1.name
	local tbl = {}

	for i = 1, #arg_10_1.criterias do
		local var_10_2 = arg_10_1.criterias[i]

		self:parse_criteria(var_10_2, arg_10_1.criterias, tbl, arg_10_1)
	end

	local count = #tbl

	arg_10_1.n_criterias = count

	local fassert = fassert
	local RULE_MAX_NUM_CRITERIA = RuleDatabase.RULE_MAX_NUM_CRITERIA

	RULE_MAX_NUM_CRITERIA = RULE_MAX_NUM_CRITERIA or 8

	fassert(count <= RULE_MAX_NUM_CRITERIA, "Too many criteria in dialogue %s", name)

	local probability = arg_10_1.probability

	probability = probability or 1

	self:_optimize_rule_definition(arg_10_1)

	local add_rule = RuleDatabase.add_rule(self.database, name, count, tbl, probability)

	self.rule_id_mapping[add_rule] = arg_10_1
	self.rule_id_mapping[arg_10_1.name] = add_rule
	self.rules_n = self.rules_n + 1
end

local set = table.set({
	"name",
	"n_criterias",
	"response",
	"on_done"
})

TagQueryDatabase._optimize_rule_definition = function (arg_11_0, arg_11_1)
	-- function 11
	for k, v in pairs(arg_11_1) do
		if not set[k] then
			arg_11_1[k] = nil
		end
	end
end

local mirror_array_inplace_2 = table.mirror_array_inplace({
	"context_name",
	"criteria_key",
	"operator"
})
local copy_array = table.copy_array(mirror_array_inplace_2)

table.mirror_array_inplace(table.append(copy_array, {
	"value",
	"combining_operator"
}))

local copy_array_2 = table.copy_array(mirror_array_inplace_2)

table.mirror_array_inplace(table.append(copy_array_2, {
	"operator",
	"value",
	"combining_operator"
}))

local function fn(self, arg_12_1)
	-- function 12
	local var_12_0

	if not (self[mirror_array_inplace_2.operator] == "TIMEDIFF") then
		return self[copy_array_2[arg_12_1]]
	else
		return self[copy_array[arg_12_1]]
	end
end

local mirror_array_inplace_3 = table.mirror_array_inplace({
	"context_name",
	"criteria_key",
	"operator_index",
	"value",
	"has_time_diff",
	"combining_operator_id",
	"combining_operator_group_id"
})

local function fn_2(self)
	-- function 13
	for i = #self, 1, -1 do
		local var_13_0 = self[i][mirror_array_inplace_3.combining_operator_group_id]

		if var_13_0 ~= 0 then
			return var_13_0
		end
	end
end

local tbl_2 = {
	AND_NEXT = RuleDatabase.COMBINING_OPERATOR_AND,
	OR_NEXT = RuleDatabase.COMBINING_OPERATOR_OR
}

local function fn_3(arg_14_0, arg_14_1, arg_14_2, arg_14_3, arg_14_4)
	-- function 14
	local var_14_0 = arg_14_3[#arg_14_3]
	local num = 0
	local var_14_2 = tbl_2[arg_14_1]

	if not var_14_2 then
		fassert(not arg_14_1, "[DialogueSystem] Unknown operator '%s' found in rule '%s'", arg_14_1, arg_14_4.name)

		local flag = not arg_14_2 and fn(arg_14_2, "combining_operator")

		if not (not flag and flag ~= "AND_NEXT") then
			var_14_2 = tbl_2.OR_NEXT
			num = var_14_0[mirror_array_inplace_3.combining_operator_group_id]
		else
			var_14_2 = tbl_2.AND_NEXT
		end
	elseif not (arg_14_1 == (not arg_14_2 and fn(arg_14_2, "combining_operator"))) then
		num = var_14_0[mirror_array_inplace_3.combining_operator_group_id]
	elseif var_14_2 ~= tbl_2.AND_NEXT then
		local var_14_4 = fn_2(arg_14_3)

		var_14_4 = var_14_4 or 0
		num = var_14_4 + 1
	end

	return var_14_2, num
end

TagQueryDatabase.parse_criteria = function (arg_15_0, arg_15_1, arg_15_2, arg_15_3, arg_15_4)
	-- function 15
	local var_15_0 = arg_15_1[mirror_array_inplace_2.context_name]
	local var_15_1 = arg_15_1[mirror_array_inplace_2.criteria_key]
	local var_15_2 = arg_15_1[mirror_array_inplace_2.operator]
	local var_15_3 = fn(arg_15_1, "value")
	local var_15_4 = fn(arg_15_1, "combining_operator")
	local flag = var_15_2 == "TIMEDIFF"

	if not flag then
		var_15_2 = fn(arg_15_1, "operator")

		fassert(tbl[var_15_2], "No operator besides TIMEDIFF in rule %q", arg_15_4.name)
	end

	local var_15_6 = tbl[var_15_2]

	fassert(var_15_6, "No such rule operator named %q in rule %q", tostring(var_15_2), arg_15_4.name)
	fassert(mirror_array_inplace[var_15_0], "No such context name %q", var_15_0)

	local var_15_7 = type(var_15_3)

	fassert(var_15_7 == "boolean" or var_15_7 == "string" or var_15_7 == "number", "Unsupported type %s in rule %s", var_15_7, arg_15_4.name)

	if var_15_7 == "boolean" then
		var_15_3 = not var_15_3 and 1 and 0
	end

	local var_15_8 = arg_15_2[#arg_15_3]
	local var_15_9, var_15_10 = fn_3(arg_15_1, var_15_4, var_15_8, arg_15_3, arg_15_4)

	arg_15_3[#arg_15_3 + 1] = {
		[mirror_array_inplace_3.context_name] = var_15_0,
		[mirror_array_inplace_3.criteria_key] = var_15_1,
		[mirror_array_inplace_3.operator_index] = var_15_6,
		[mirror_array_inplace_3.value] = var_15_3,
		[mirror_array_inplace_3.has_time_diff] = flag,
		[mirror_array_inplace_3.combining_operator_id] = var_15_9,
		[mirror_array_inplace_3.combining_operator_group_id] = var_15_10
	}
end

local tbl_3 = {}

local function fn_4(arg_16_0, arg_16_1)
	-- function 16
	return tbl_3[arg_16_0] > tbl_3[arg_16_1]
end

local tbl_4 = {
	[0] = 0
}

TagQueryDatabase.iterate_queries = function (self, arg_17_1, arg_17_2)
	-- function 17
	table.clear(tbl_3)

	local num = 0

	for i = 1, #self.queries do
		local iterate_query = self:iterate_query(arg_17_2)

		if not iterate_query.result then
			num = num + 1
			tbl_4[num] = iterate_query
			tbl_3[iterate_query] = math.random(1, iterate_query.validated_rule.n_criterias)
		end
	end

	for j = num + 1, tbl_4[0] do
		tbl_4[j] = nil
	end

	tbl_4[0] = num

	table.sort(tbl_4, fn_4)

	for k = 1, num do
		arg_17_1[k] = tbl_4[k]
	end

	return num
end

local tbl_5 = {}

TagQueryDatabase.iterate_query = function (self, arg_18_1)
	-- function 18
	local remove = table.remove(self.queries, 1)

	if not remove then
		return
	end

	local query_context = remove.query_context
	local source = query_context.source
	local var_18_3 = self.contexts_by_object[source]

	if var_18_3 == nil then
		return remove
	end

	local tbl = {}
	local global_context = self.global_context

	global_context = global_context or tbl_5
	tbl[1] = global_context
	tbl[2] = query_context or tbl_5

	local user_context = var_18_3.user_context

	user_context = user_context or tbl_5
	tbl[3] = user_context

	local user_memory = var_18_3.user_memory

	user_memory = user_memory or tbl_5
	tbl[4] = user_memory

	local faction_memory = var_18_3.faction_memory

	faction_memory = faction_memory or tbl_5
	tbl[5] = faction_memory

	local iterate_query = RuleDatabase.iterate_query(self.database, tbl, arg_18_1)

	if not iterate_query then
		local var_18_10 = self.rule_id_mapping[iterate_query]

		remove.validated_rule = var_18_10
		remove.result = var_18_10.response
	end

	return remove
end

TagQueryDatabase.has_queries = function (self)
	-- function 19
	return not table.is_empty(self.queries)
end

TagQueryDatabase._debug_print_query = function (arg_20_0, arg_20_1, arg_20_2, arg_20_3)
	-- function 20
	local tbl = {}

	table.insert(tbl, "--------------- STARTING NEW QUERY ---------------")
	table.insert(tbl, "Query context:")

	for k, v in pairs(arg_20_1.query_context) do
		table.insert(tbl, string.format("\t%-15s: %-15s", k, tostring(v)))
	end

	table.insert(tbl, "User contexts:")

	for k_2, v_2 in pairs(arg_20_2) do
		table.insert(tbl, "\t" .. k_2)

		if type(v_2) == "table" then
			for k_3, v_3 in pairs(v_2) do
				table.insert(tbl, string.format("\t\t%-15s : %-15s", k_3, tostring(v_3)))
			end
		end
	end

	table.insert(tbl, "Global context:")

	if not arg_20_3 then
		for k_4, v_4 in pairs(arg_20_3) do
			table.insert(tbl, string.format("\t%-15s : %-15s", k_4, tostring(v_4)))
		end
	end

	table.insert(tbl, "--------------- END OF QUERY CONTEXTS ---------------")
	print(table.concat(tbl, "\n"))
end

local tbl_6 = {}

TagQueryDatabase.debug_test_query = function (self, arg_21_1, arg_21_2, arg_21_3, arg_21_4, arg_21_5)
	-- function 21
	print("--------------- TESTING FOLLOWING QUERY ---------------")
	print(arg_21_1, arg_21_2, arg_21_3, arg_21_4, arg_21_5)
	table.dump(arg_21_3.query_context)

	local create_query = self:create_query()
	local player_unit = Managers.player:local_player().player_unit

	create_query:add("concept", arg_21_1, "source", player_unit, "source_name", arg_21_2)
	create_query:finalize()

	local var_21_2 = self.queries[#self.queries]

	if not var_21_2 then
		print("FAILED TO CREATE NEW QUERY ", var_21_2)

		return
	end

	local query_context = var_21_2.query_context
	local source = query_context.source
	local clone = table.clone(self.contexts_by_object[source])

	for k, v in pairs(arg_21_3.query_context) do
		print(string.format("\t%-15s: %-15s", k, tostring(v)))

		query_context[k] = v
	end

	for k_2, v_2 in pairs(arg_21_4) do
		for k_3, v_3 in pairs(v_2) do
			print(string.format("\t\t%-15s : %-15s", k_3, tostring(v_3)))

			clone[k_2][k_3] = v_3
		end
	end

	if not arg_21_5 then
		for k_4, v_4 in pairs(arg_21_5) do
			print(string.format("\t%-15s : %-15s", k_4, tostring(v_4)))

			self.global_context[k_4] = v_4
		end
	end

	local tbl = {}
	local global_context = self.global_context

	global_context = global_context or tbl_6
	tbl[1] = global_context
	tbl[2] = query_context or tbl_6

	local user_context = clone.user_context

	user_context = user_context or tbl_6
	tbl[3] = user_context

	local user_memory = clone.user_memory

	user_memory = user_memory or tbl_6
	tbl[4] = user_memory

	local faction_memory = clone.faction_memory

	faction_memory = faction_memory or tbl_6
	tbl[5] = faction_memory

	local time = Managers.time:time("game")
	local iterate_query = RuleDatabase.iterate_query(self.database, tbl, time)

	if not iterate_query then
		local var_21_13 = self.rule_id_mapping[iterate_query]

		var_21_2.validated_rule = var_21_13
		var_21_2.result = var_21_13.response

		print("Following rule succeeded:", var_21_2.result)
	else
		print("Failed testing query")
	end

	print("--------------- END OF TEST QUERY---------------")
end
