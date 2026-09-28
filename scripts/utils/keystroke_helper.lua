-- chunkname: @scripts/utils/keystroke_helper.lua

local KeystrokeHelper = KeystrokeHelper

KeystrokeHelper = not not KeystrokeHelper or not not {}
KeystrokeHelper = KeystrokeHelper

KeystrokeHelper.num_utf8chars = function (text)
	-- function 1
	local length = #text
	local index = 1
	local num_chars = 0
	local _

	while index <= length do
		_, index = Utf8.location(text, index)
		num_chars = num_chars + 1
	end

	return num_chars
end

local _reusable_text_table = {}

KeystrokeHelper.parse_strokes = function (text, index, mode, keystrokes, optional_text_length_cap)
	-- function 2
	table.clear(_reusable_text_table)

	local text_table = KeystrokeHelper._build_utf8_table(text, _reusable_text_table)

	for _, stroke in ipairs(keystrokes) do
		if type(stroke) == "string" then
			if optional_text_length_cap then
				if optional_text_length_cap > #text_table then
					index, mode = KeystrokeHelper._add_character(text_table, stroke, index, mode)
				end
			else
				index, mode = KeystrokeHelper._add_character(text_table, stroke, index, mode)
			end
		elseif stroke == Keyboard.ENTER then
			break
		elseif KeystrokeHelper[stroke] then
			index, mode = KeystrokeHelper[stroke](text_table, index, mode, optional_text_length_cap)
		end
	end

	return table.concat(text_table), index, mode
end

KeystrokeHelper._build_utf8_table = function (text, external_table)
	-- function 3
	local text_table = not not external_table or not not {}
	local character_index = 1
	local index = 1
	local length = #text

	while index <= length do
		local _, end_index = Utf8.location(text, index)

		text_table[character_index] = string.sub(text, index, end_index - 1)
		character_index = character_index + 1
		index = end_index
	end

	return text_table
end

KeystrokeHelper._add_character = function (text_table, text, index, mode)
	-- function 4
	if mode == "insert" then
		table.insert(text_table, index, text)
	else
		text_table[index] = text
	end

	return index + 1, mode
end

KeystrokeHelper[Keyboard.LEFT] = function (text_table, index, mode)
	-- function 5
	return math.max(index - 1, 1), mode
end
KeystrokeHelper[Keyboard.RIGHT] = function (text_table, index, mode)
	-- function 6
	return math.min(index + 1, #text_table + 1), mode
end
KeystrokeHelper[Keyboard.UP] = nil
KeystrokeHelper[Keyboard.DOWN] = nil
KeystrokeHelper[Keyboard.INSERT] = function (text_table, index, mode)
	-- function 7
	local var_7_0 = index
	local flag

	flag = (mode ~= "insert" or not "overwrite") and not not "insert"

	return var_7_0, flag
end
KeystrokeHelper[Keyboard.HOME] = function (text_table, index, mode)
	-- function 8
	return 1, mode
end
KeystrokeHelper[Keyboard.END] = function (text_table, index, mode)
	-- function 9
	return #text_table + 1, mode
end
KeystrokeHelper[Keyboard.BACKSPACE] = function (text_table, index, mode)
	-- function 10
	local backspace_index = index - 1

	if backspace_index < 1 then
		return index, mode
	end

	table.remove(text_table, backspace_index)

	return backspace_index, mode
end
KeystrokeHelper[Keyboard.TAB] = nil
KeystrokeHelper[Keyboard.PAGE_UP] = nil
KeystrokeHelper[Keyboard.PAGE_DOWN] = nil
KeystrokeHelper[Keyboard.ESCAPE] = nil
KeystrokeHelper[Keyboard.DELETE] = function (text_table, index, mode)
	-- function 11
	if text_table[index] then
		table.remove(text_table, index)
	end

	return index, mode
end

local clipboard_table = {}

KeystrokeHelper[Keyboard.F9] = function (text_table, index, mode, max_length)
	-- function 12
	local get = Clipboard.get()

	if not get then
		-- Nothing
	end

	get = ""

	local clipboard = get

	::label_12_0::

	if not Utf8.valid(clipboard) then
		clipboard = string.gsub(clipboard, "[^ -~]+", "")
	end

	table.clear(clipboard_table)
	KeystrokeHelper._build_utf8_table(clipboard, clipboard_table)

	local n = #clipboard_table

	if max_length then
		n = math.min(n, max_length - #text_table)
	end

	for i = 1, n do
		text_table[#text_table + 1] = clipboard_table[i]
	end

	return index + n, mode
end
