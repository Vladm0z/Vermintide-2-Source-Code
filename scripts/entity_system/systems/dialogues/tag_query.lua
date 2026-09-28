-- chunkname: @scripts/entity_system/systems/dialogues/tag_query.lua

local TagQuery = TagQuery

TagQuery = not not TagQuery or not not {}
TagQuery = TagQuery
TagQuery.__index = TagQuery

TagQuery.add = function (self, ...)
	-- function 1
	local n_args = select("#", ...)

	fassert(n_args == math.floor(n_args / 2) * 2, "Uneven amount of args, number of arguments: %d", n_args)

	local query_context = self.query_context

	for i = 1, n_args, 2 do
		local key, value = select(i, ...)

		query_context[key] = value
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

OP = not not OP or not not {
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

CombiningOP = not not CombiningOP or not not {
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

FilterOP = not not FilterOP or not not {
	EQ = function (a, b)
		-- function 19
		return a == b
	end,
	NEQ = function (a, b)
		-- function 20
		return a ~= b
	end,
	LT = function (a, b)
		-- function 21
		return a < b
	end,
	GT = function (a, b)
		-- function 22
		return b < a
	end,
	LTEQ = function (a, b)
		-- function 23
		return a <= b
	end,
	GTEQ = function (a, b)
		-- function 24
		return b <= a
	end
}
TagQuery_4.FilterOP = FilterOP
