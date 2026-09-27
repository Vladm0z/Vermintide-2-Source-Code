-- chunkname: @foundation/scripts/util/path.lua

Path = {}

Path.normalize_path = function (self)
	-- function 1
	self = self:gsub("\\", "/")
	self = self:gsub("//", "/")

	return self
end

Path.path_from_string = function (self)
	-- function 2
	self = Path.normalize_path(self)

	local tbl = {
		size = 0
	}
	local num = 0
	local count = #self
	local num_2 = 0

	while num_2 ~= nil do
		local find = self:find("/", num_2)
		local var_2_5 = self
		local sub = self.sub
		local var_2_7 = num_2
		local num_3

		if not find then
			num_3 = find - 1

			if not num_3 then
				-- Nothing
			end
		end

		num_3 = nil

		::label_2_0::

		tbl[num], num = sub(var_2_5, var_2_7, num_3), num + 1

		if not (find == nil or find ~= count) then
			break
		end

		num_2 = find + 1
	end

	tbl.size = num

	return tbl
end

Path.path_from_parts = function (...)
	-- function 3
	local var_3_0 = select("#", ...)
	local tbl = {
		size = var_3_0
	}

	for i = 1, var_3_0 do
		tbl[i] = select(i, ...)
	end

	return tbl
end

Path.copy = function (self)
	-- function 4
	local tbl = {
		size = self.size
	}

	for i = 1, self.size do
		tbl[i] = self[i]
	end

	return tbl
end

Path.change_dir_up = function (self)
	-- function 5
	assert(self.size > 0)

	self.size = self.size - 1
end

Path.add_path_part = function (self, arg_6_1)
	-- function 6
	self.size = self.size + 1
	self[self.size] = arg_6_1
end

Path.join = function (self, arg_7_1, arg_7_2)
	-- function 7
	arg_7_2 = arg_7_2 or {}
	arg_7_2.size = 0

	for i = 1, self.size do
		arg_7_2.size = arg_7_2.size + 1
		arg_7_2[arg_7_2.size] = self[i]
	end

	for j = 1, arg_7_1.size do
		arg_7_2.size = arg_7_2.size + 1
		arg_7_2[arg_7_2.size] = arg_7_1[j]
	end

	return arg_7_2
end

Path.tostring = function (self, arg_8_1)
	-- function 8
	arg_8_1 = arg_8_1 or "/"

	local str = ""

	for i = 1, self.size - 1 do
		str = str .. self[i] .. arg_8_1
	end

	return str .. self[self.size]
end

local flag = true

if not flag then
	local random = math.random()
	local path_from_string = Path.path_from_string("hej")

	assert(path_from_string.size == 1)

	local path_from_string_2 = Path.path_from_string("hej/apa")

	assert(path_from_string_2.size == 2)
	assert(path_from_string_2[path_from_string_2.size] == "apa")

	local path_from_string_3 = Path.path_from_string("hej\\apa\\")

	assert(path_from_string_3.size == 2)
	assert(path_from_string_3[path_from_string_3.size] == "apa")

	local path_from_parts = Path.path_from_parts("hej", "apa")

	assert(path_from_parts.size == 2)
	Path.change_dir_up(path_from_parts)
	assert(path_from_parts.size == 1)
	Path.add_path_part(path_from_parts, "lols")
	assert(path_from_parts.size == 2)
	assert(path_from_parts[path_from_parts.size] == "lols")

	local path_from_parts_2 = Path.path_from_parts("anders", "isn't", "best")
	local tbl = {}

	Path.join(path_from_parts, path_from_parts_2, tbl)
	assert(tbl.size == path_from_parts.size + path_from_parts_2.size)
	assert(tbl[tbl.size] == "best")

	local tostring = Path.tostring(tbl)

	assert(tostring == "hej/lols/anders/isn't/best")

	local path_from_string_4 = Path.path_from_string("C:\\trunk/lols/")

	assert(path_from_string_4.size == 3)

	local tostring_2 = Path.tostring(path_from_string_4)

	assert(tostring_2 == "C:/trunk/lols")
end
