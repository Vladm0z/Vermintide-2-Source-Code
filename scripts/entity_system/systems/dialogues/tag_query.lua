-- chunkname: @scripts/entity_system/systems/dialogues/tag_query.lua

TagQuery = TagQuery or {}
TagQuery.__index = TagQuery

function TagQuery.add(arg_1_0, ...)
	local var_1_0 = select("#", ...)

	fassert(var_1_0 == math.floor(var_1_0 / 2) * 2, "Uneven amount of args, number of arguments: %d", var_1_0)

	local var_1_1 = arg_1_0.query_context

	for iter_1_0 = 1, var_1_0, 2 do
		local var_1_2, var_1_3 = select(iter_1_0, ...)

		var_1_1[var_1_2] = var_1_3
	end

	fassert(not arg_1_0.finalized, "Tried to add query after finalized.")
end

function TagQuery.get_result(arg_2_0)
	return arg_2_0.completed, arg_2_0.result
end

function TagQuery.finalize(arg_3_0)
	arg_3_0.tagquery_database:add_query(arg_3_0)

	arg_3_0.finalized = true
end

TagQuery.OP = TagQuery.OP or {
	EQ = setmetatable({}, {
		__tostring = function()
			return "EQ"
		end
	}),
	LT = setmetatable({}, {
		__tostring = function()
			return "LT"
		end
	}),
	GT = setmetatable({}, {
		__tostring = function()
			return "GT"
		end
	}),
	LTEQ = setmetatable({}, {
		__tostring = function()
			return "LTEQ"
		end
	}),
	GTEQ = setmetatable({}, {
		__tostring = function()
			return "GTEQ"
		end
	}),
	SUB = setmetatable({}, {
		__tostring = function()
			return "SUB"
		end
	}),
	ADD = setmetatable({}, {
		__tostring = function()
			return "ADD"
		end
	}),
	NEQ = setmetatable({}, {
		__tostring = function()
			return "NEQ"
		end
	}),
	NOT = setmetatable({}, {
		__tostring = function()
			return "NOT"
		end
	}),
	RAND = setmetatable({}, {
		__tostring = function()
			return "RAND"
		end
	}),
	TIMEDIFF = setmetatable({}, {
		__tostring = function()
			return "TIMEDIFF"
		end
	}),
	TIMESET = setmetatable({}, {
		__tostring = function()
			return "TIMESET"
		end
	}),
	NUMSET = setmetatable({}, {
		__tostring = function()
			return "NUMSET"
		end
	})
}
TagQuery.CombiningOP = TagQuery.CombiningOP or {
	AND_NEXT = setmetatable({}, {
		__tostring = function()
			return "AND_NEXT"
		end
	}),
	OR_NEXT = setmetatable({}, {
		__tostring = function()
			return "OR_NEXT"
		end
	})
}
TagQuery.FilterOP = TagQuery.FilterOP or {
	EQ = function(arg_19_0, arg_19_1)
		return arg_19_0 == arg_19_1
	end,
	NEQ = function(arg_20_0, arg_20_1)
		return arg_20_0 ~= arg_20_1
	end,
	LT = function(arg_21_0, arg_21_1)
		return arg_21_0 < arg_21_1
	end,
	GT = function(arg_22_0, arg_22_1)
		return arg_22_1 < arg_22_0
	end,
	LTEQ = function(arg_23_0, arg_23_1)
		return arg_23_0 <= arg_23_1
	end,
	GTEQ = function(arg_24_0, arg_24_1)
		return arg_24_1 <= arg_24_0
	end
}
