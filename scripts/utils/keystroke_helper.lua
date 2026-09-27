-- chunkname: @scripts/utils/keystroke_helper.lua

local KeystrokeHelper = KeystrokeHelper

KeystrokeHelper = KeystrokeHelper or {}
KeystrokeHelper = KeystrokeHelper

KeystrokeHelper.num_utf8chars = function (arg_1_0)
	-- function 1
	local count = #arg_1_0
	local num = 1
	local num_2 = 0
	local var_1_3

	while num <= count do
		local location

		location, num = Utf8.location(arg_1_0, num)
		num_2 = num_2 + 1
	end

	return num_2
end

local tbl = {}

KeystrokeHelper.parse_strokes = function (arg_2_0, arg_2_1, arg_2_2, arg_2_3, arg_2_4)
	-- function 2
	table.clear(tbl)

	local _build_utf8_table = KeystrokeHelper._build_utf8_table(arg_2_0, tbl)

	for i, v in ipairs(arg_2_3) do
		if type(v) == "string" then
			if not arg_2_4 then
				if arg_2_4 > #_build_utf8_table then
					arg_2_1, arg_2_2 = KeystrokeHelper._add_character(_build_utf8_table, v, arg_2_1, arg_2_2)
				end
			else
				arg_2_1, arg_2_2 = KeystrokeHelper._add_character(_build_utf8_table, v, arg_2_1, arg_2_2)
			end
		elseif v == Keyboard.ENTER then
			break
		elseif not KeystrokeHelper[v] then
			arg_2_1, arg_2_2 = KeystrokeHelper[v](_build_utf8_table, arg_2_1, arg_2_2, arg_2_4)
		end
	end

	return table.concat(_build_utf8_table), arg_2_1, arg_2_2
end

KeystrokeHelper._build_utf8_table = function (arg_3_0, arg_3_1)
	-- function 3
	local flag = arg_3_1 or {}
	local num = 1
	local num_2 = 1
	local count = #arg_3_0

	while num_2 <= count do
		local location, var_3_5 = Utf8.location(arg_3_0, num_2)

		flag[num] = string.sub(arg_3_0, num_2, var_3_5 - 1)
		num = num + 1
		num_2 = var_3_5
	end

	return flag
end

KeystrokeHelper._add_character = function (self, arg_4_1, arg_4_2, arg_4_3)
	-- function 4
	if arg_4_3 == "insert" then
		table.insert(self, arg_4_2, arg_4_1)
	else
		self[arg_4_2] = arg_4_1
	end

	return arg_4_2 + 1, arg_4_3
end

KeystrokeHelper[Keyboard.LEFT] = function (arg_5_0, arg_5_1, arg_5_2)
	-- function 5
	return math.max(arg_5_1 - 1, 1), arg_5_2
end
KeystrokeHelper[Keyboard.RIGHT] = function (arg_6_0, arg_6_1, arg_6_2)
	-- function 6
	return math.min(arg_6_1 + 1, #arg_6_0 + 1), arg_6_2
end
KeystrokeHelper[Keyboard.UP] = nil
KeystrokeHelper[Keyboard.DOWN] = nil
KeystrokeHelper[Keyboard.INSERT] = function (arg_7_0, arg_7_1, arg_7_2)
	-- function 7
	local var_7_0 = arg_7_1
	local flag

	flag = arg_7_2 ~= "insert" or not "overwrite" or "insert"

	return var_7_0, flag
end
KeystrokeHelper[Keyboard.HOME] = function (arg_8_0, arg_8_1, arg_8_2)
	-- function 8
	return 1, arg_8_2
end
KeystrokeHelper[Keyboard.END] = function (arg_9_0, arg_9_1, arg_9_2)
	-- function 9
	return #arg_9_0 + 1, arg_9_2
end
KeystrokeHelper[Keyboard.BACKSPACE] = function (arg_10_0, arg_10_1, arg_10_2)
	-- function 10
	local num = arg_10_1 - 1

	if num < 1 then
		return arg_10_1, arg_10_2
	end

	table.remove(arg_10_0, num)

	return num, arg_10_2
end
KeystrokeHelper[Keyboard.TAB] = nil
KeystrokeHelper[Keyboard.PAGE_UP] = nil
KeystrokeHelper[Keyboard.PAGE_DOWN] = nil
KeystrokeHelper[Keyboard.ESCAPE] = nil
KeystrokeHelper[Keyboard.DELETE] = function (self, arg_11_1, arg_11_2)
	-- function 11
	if not self[arg_11_1] then
		table.remove(self, arg_11_1)
	end

	return arg_11_1, arg_11_2
end

local tbl_2 = {}

KeystrokeHelper[Keyboard.F9] = function (self, arg_12_1, arg_12_2, arg_12_3)
	-- function 12
	local get = Clipboard.get()

	get = get or ""

	if not Utf8.valid(get) then
		get = string.gsub(get, "[^ -~]+", "")
	end

	table.clear(tbl_2)
	KeystrokeHelper._build_utf8_table(get, tbl_2)

	local count = #tbl_2

	if not arg_12_3 then
		count = math.min(count, arg_12_3 - #self)
	end

	for i = 1, count do
		self[#self + 1] = tbl_2[i]
	end

	return arg_12_1 + count, arg_12_2
end
