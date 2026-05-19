-- chunkname: @scripts/utils/keystroke_helper.lua

KeystrokeHelper = KeystrokeHelper or {}

function KeystrokeHelper.num_utf8chars(arg_1_0)
	local var_1_0 = #arg_1_0
	local var_1_1 = 1
	local var_1_2 = 0
	local var_1_3

	while var_1_1 <= var_1_0 do
		local var_1_4

		var_1_4, var_1_1 = Utf8.location(arg_1_0, var_1_1)
		var_1_2 = var_1_2 + 1
	end

	return var_1_2
end

local var_0_0 = {}

function KeystrokeHelper.parse_strokes(arg_2_0, arg_2_1, arg_2_2, arg_2_3, arg_2_4)
	table.clear(var_0_0)

	local var_2_0 = KeystrokeHelper._build_utf8_table(arg_2_0, var_0_0)

	for iter_2_0, iter_2_1 in ipairs(arg_2_3) do
		if type(iter_2_1) == "string" then
			if arg_2_4 then
				if arg_2_4 > #var_2_0 then
					arg_2_1, arg_2_2 = KeystrokeHelper._add_character(var_2_0, iter_2_1, arg_2_1, arg_2_2)
				end
			else
				arg_2_1, arg_2_2 = KeystrokeHelper._add_character(var_2_0, iter_2_1, arg_2_1, arg_2_2)
			end
		elseif iter_2_1 == Keyboard.ENTER then
			break
		elseif KeystrokeHelper[iter_2_1] then
			arg_2_1, arg_2_2 = KeystrokeHelper[iter_2_1](var_2_0, arg_2_1, arg_2_2, arg_2_4)
		end
	end

	return table.concat(var_2_0), arg_2_1, arg_2_2
end

function KeystrokeHelper._build_utf8_table(arg_3_0, arg_3_1)
	local var_3_0 = arg_3_1 or {}
	local var_3_1 = 1
	local var_3_2 = 1
	local var_3_3 = #arg_3_0

	while var_3_2 <= var_3_3 do
		local var_3_4, var_3_5 = Utf8.location(arg_3_0, var_3_2)

		var_3_0[var_3_1] = string.sub(arg_3_0, var_3_2, var_3_5 - 1)
		var_3_1 = var_3_1 + 1
		var_3_2 = var_3_5
	end

	return var_3_0
end

function KeystrokeHelper._add_character(arg_4_0, arg_4_1, arg_4_2, arg_4_3)
	if arg_4_3 == "insert" then
		table.insert(arg_4_0, arg_4_2, arg_4_1)
	else
		arg_4_0[arg_4_2] = arg_4_1
	end

	return arg_4_2 + 1, arg_4_3
end

KeystrokeHelper[Keyboard.LEFT] = function(arg_5_0, arg_5_1, arg_5_2)
	return math.max(arg_5_1 - 1, 1), arg_5_2
end
KeystrokeHelper[Keyboard.RIGHT] = function(arg_6_0, arg_6_1, arg_6_2)
	return math.min(arg_6_1 + 1, #arg_6_0 + 1), arg_6_2
end
KeystrokeHelper[Keyboard.UP] = nil
KeystrokeHelper[Keyboard.DOWN] = nil
KeystrokeHelper[Keyboard.INSERT] = function(arg_7_0, arg_7_1, arg_7_2)
	return arg_7_1, arg_7_2 == "insert" and "overwrite" or "insert"
end
KeystrokeHelper[Keyboard.HOME] = function(arg_8_0, arg_8_1, arg_8_2)
	return 1, arg_8_2
end
KeystrokeHelper[Keyboard.END] = function(arg_9_0, arg_9_1, arg_9_2)
	return #arg_9_0 + 1, arg_9_2
end
KeystrokeHelper[Keyboard.BACKSPACE] = function(arg_10_0, arg_10_1, arg_10_2)
	local var_10_0 = arg_10_1 - 1

	if var_10_0 < 1 then
		return arg_10_1, arg_10_2
	end

	table.remove(arg_10_0, var_10_0)

	return var_10_0, arg_10_2
end
KeystrokeHelper[Keyboard.TAB] = nil
KeystrokeHelper[Keyboard.PAGE_UP] = nil
KeystrokeHelper[Keyboard.PAGE_DOWN] = nil
KeystrokeHelper[Keyboard.ESCAPE] = nil
KeystrokeHelper[Keyboard.DELETE] = function(arg_11_0, arg_11_1, arg_11_2)
	if arg_11_0[arg_11_1] then
		table.remove(arg_11_0, arg_11_1)
	end

	return arg_11_1, arg_11_2
end

local var_0_1 = {}

KeystrokeHelper[Keyboard.F9] = function(arg_12_0, arg_12_1, arg_12_2, arg_12_3)
	local var_12_0 = Clipboard.get() or ""

	if not Utf8.valid(var_12_0) then
		var_12_0 = string.gsub(var_12_0, "[^ -~]+", "")
	end

	table.clear(var_0_1)
	KeystrokeHelper._build_utf8_table(var_12_0, var_0_1)

	local var_12_1 = #var_0_1

	if arg_12_3 then
		var_12_1 = math.min(var_12_1, arg_12_3 - #arg_12_0)
	end

	for iter_12_0 = 1, var_12_1 do
		arg_12_0[#arg_12_0 + 1] = var_0_1[iter_12_0]
	end

	return arg_12_1 + var_12_1, arg_12_2
end
