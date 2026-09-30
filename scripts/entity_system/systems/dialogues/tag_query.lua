-- chunkname: @scripts/entity_system/systems/dialogues/tag_query.lua

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

TagQuery.OP = TagQuery.OP
TagQuery.CombiningOP = TagQuery.CombiningOP
TagQuery.FilterOP = TagQuery.FilterOP
