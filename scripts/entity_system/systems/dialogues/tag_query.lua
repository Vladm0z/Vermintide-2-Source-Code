-- chunkname: @scripts/entity_system/systems/dialogues/tag_query.lua

local TagQuery = TagQuery

TagQuery = TagQuery or {}
TagQuery = TagQuery
TagQuery.__index = TagQuery

TagQuery.add = function (self, ...)
	-- function 1
	local var_1_0 = select("#", ...)

	fassert(var_1_0 == math.floor(var_1_0 / 2) * 2, "Uneven amount of args, number of arguments: %d", var_1_0)

	local query_context = self.query_context

	for i = 1, var_1_0, 2 do
		local var_1_2, var_1_3 = select(i, ...)

		query_context[var_1_2] = var_1_3
	end

	fassert(not self.finalized, "Tried to add query after finalized.")
end

TagQuery.get_result = function (self)
	-- function 2
	return self.completed, self.result
end

TagQuery.finalize = function (self)
	-- function 3
	self.tagquery_database:add_query(self)

	self.finalized = true
end

local TagQuery_2 = TagQuery
local OP = TagQuery.OP

OP = OP or {
	EQ = setmetatable({}, {
		__tostring = function ()
			-- function 4
			return "EQ"
		end
	}),
	LT = setmetatable({}, {
		__tostring = function ()
			-- function 5
			return "LT"
		end
	}),
	GT = setmetatable({}, {
		__tostring = function ()
			-- function 6
			return "GT"
		end
	}),
	LTEQ = setmetatable({}, {
		__tostring = function ()
			-- function 7
			return "LTEQ"
		end
	}),
	GTEQ = setmetatable({}, {
		__tostring = function ()
			-- function 8
			return "GTEQ"
		end
	}),
	SUB = setmetatable({}, {
		__tostring = function ()
			-- function 9
			return "SUB"
		end
	}),
	ADD = setmetatable({}, {
		__tostring = function ()
			-- function 10
			return "ADD"
		end
	}),
	NEQ = setmetatable({}, {
		__tostring = function ()
			-- function 11
			return "NEQ"
		end
	}),
	NOT = setmetatable({}, {
		__tostring = function ()
			-- function 12
			return "NOT"
		end
	}),
	RAND = setmetatable({}, {
		__tostring = function ()
			-- function 13
			return "RAND"
		end
	}),
	TIMEDIFF = setmetatable({}, {
		__tostring = function ()
			-- function 14
			return "TIMEDIFF"
		end
	}),
	TIMESET = setmetatable({}, {
		__tostring = function ()
			-- function 15
			return "TIMESET"
		end
	}),
	NUMSET = setmetatable({}, {
		__tostring = function ()
			-- function 16
			return "NUMSET"
		end
	})
}
TagQuery_2.OP = OP

local TagQuery_3 = TagQuery
local CombiningOP = TagQuery.CombiningOP

CombiningOP = CombiningOP or {
	AND_NEXT = setmetatable({}, {
		__tostring = function ()
			-- function 17
			return "AND_NEXT"
		end
	}),
	OR_NEXT = setmetatable({}, {
		__tostring = function ()
			-- function 18
			return "OR_NEXT"
		end
	})
}
TagQuery_3.CombiningOP = CombiningOP

local TagQuery_4 = TagQuery
local FilterOP = TagQuery.FilterOP

FilterOP = FilterOP or {
	EQ = function (arg_19_0, arg_19_1)
		-- function 19
		return arg_19_0 == arg_19_1
	end,
	NEQ = function (arg_20_0, arg_20_1)
		-- function 20
		return arg_20_0 ~= arg_20_1
	end,
	LT = function (arg_21_0, arg_21_1)
		-- function 21
		return arg_21_0 < arg_21_1
	end,
	GT = function (arg_22_0, arg_22_1)
		-- function 22
		return arg_22_1 < arg_22_0
	end,
	LTEQ = function (arg_23_0, arg_23_1)
		-- function 23
		return arg_23_0 <= arg_23_1
	end,
	GTEQ = function (arg_24_0, arg_24_1)
		-- function 24
		return arg_24_1 <= arg_24_0
	end
}
TagQuery_4.FilterOP = FilterOP
