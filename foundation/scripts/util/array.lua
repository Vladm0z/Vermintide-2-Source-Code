-- chunkname: @foundation/scripts/util/array.lua

local function array_new()
	-- function 1
	return {
		{},
		0
	}
end

local function array_data(a)
	-- function 2
	return a[1], a[2]
end

local function array(a)
	-- function 3
	return a[1]
end

local function array_n(a)
	-- function 4
	return a[2]
end

local function array_copy(a)
	-- function 5
	local at, an = array_data(a)
	local t = {}
	local b = {
		t,
		an
	}

	for i = 1, an do
		t[i] = at[i]
	end

	return b
end

local function array_resize(a, new_n)
	-- function 6
	local t, n = a[1], a[2]

	while n < new_n do
		n = n + 1
		t[n] = nil
	end

	while new_n < n do
		t[n] = nil
		n = n - 1
	end

	a[2] = new_n
end

local function array_resize_grow_only(a, new_n)
	-- function 7
	local t, n = a[1], a[2]

	a[2] = new_n

	while n < new_n do
		n = n + 1
		t[n] = nil
	end
end

local function array_set_size(a, new_n)
	-- function 8
	a[2] = new_n
end

local function array_set_empty(a)
	-- function 9
	array_set_size(a, 0)
end

local function array_empty(a)
	-- function 10
	return a[2] == 0
end

local function array_pop_index(a, index)
	-- function 11
	local t, n = a[1], a[2]

	t[index] = t[n]
	t[n] = nil
	a[2] = n - 1
end

local function array_pop_index_ordered(a, index)
	-- function 12
	local t, n = a[1], a[2]

	for i = index, n - 1 do
		t[i] = t[i + 1]
	end

	t[n] = nil
	a[2] = n - 1
end

local function array_item_index(a, item)
	-- function 13
	local t, n = a[1], a[2]
	local found_i

	for i = 1, n do
		if t[i] == item then
			found_i = i

			break
		end
	end

	return found_i
end

local function array_pop_item(a, item)
	-- function 14
	local found_i = array_item_index(a, item)

	if not found_i then
		return nil
	end

	array_pop_index(a, found_i)

	return found_i
end

local function array_pop_index_value(a, index)
	-- function 15
	local t, n = a[1], a[2]
	local return_value = t[index]

	t[index] = t[n]
	t[n] = nil
	a[2] = n - 1

	return return_value, index
end

local function array_pop_item_value(a, item)
	-- function 16
	local found_i = array_item_index(a, item)

	if not found_i then
		return
	end

	return array_pop_index_value(a, found_i)
end

local function array_pop_index_ordered_value(a, index)
	-- function 17
	local t, n = a[1], a[2]
	local return_value = t[index]

	for i = index, n - 1 do
		t[i] = t[i + 1]
	end

	t[n] = nil
	a[2] = n - 1

	return return_value, index
end

local function array_pop_item_ordered(a, item)
	-- function 18
	local found_i = array_item_index(a, item)

	if not found_i then
		return nil
	end

	array_pop_index_ordered(a, found_i)

	return found_i
end

local function array_pop_item_value_ordered(a, item)
	-- function 19
	local found_i = array_item_index(a, item)

	if not found_i then
		return
	end

	return array_pop_index_ordered_value(a, found_i)
end

local function array_pop_back(a)
	-- function 20
	local t, n = a[1], a[2]

	assert(n > 0)

	local v = t[n]

	t[n] = nil
	a[2] = n - 1

	return v, n
end

local function array_erase_back(a)
	-- function 21
	local t, n = a[1], a[2]

	assert(n > 0)

	t[n] = nil
	a[2] = n - 1
end

local function array_push_back(a, item, ...)
	-- function 22
	local t, n = a[1], a[2] + 1

	t[n] = item
	a[2] = n
end

local function array_push_back2(a, item1, item2, ...)
	-- function 23
	local t, n = a[1], a[2]

	t[n + 1] = item1
	t[n + 2] = item2
	a[2] = n + 2
end

local function array_push_back3(a, item1, item2, item3, ...)
	-- function 24
	local t, n = a[1], a[2]

	t[n + 1] = item1
	t[n + 2] = item2
	t[n + 3] = item3
	a[2] = n + 3
end

local function array_push_back4(a, item1, item2, item3, item4, ...)
	-- function 25
	local t, n = a[1], a[2]

	t[n + 1] = item1
	t[n + 2] = item2
	t[n + 3] = item3
	t[n + 4] = item4
	a[2] = n + 4
end

local function array_push_back5(a, item1, item2, item3, item4, item5, ...)
	-- function 26
	local t, n = a[1], a[2]

	t[n + 1] = item1
	t[n + 2] = item2
	t[n + 3] = item3
	t[n + 4] = item4
	t[n + 5] = item5
	a[2] = n + 5
end

local function array_push_back6(a, item1, item2, item3, item4, item5, item6, ...)
	-- function 27
	local t, n = a[1], a[2]

	t[n + 1] = item1
	t[n + 2] = item2
	t[n + 3] = item3
	t[n + 4] = item4
	t[n + 5] = item5
	t[n + 6] = item6
	a[2] = n + 6
end

local function array_push_back7(a, item1, item2, item3, item4, item5, item6, item7, ...)
	-- function 28
	local t, n = a[1], a[2]

	t[n + 1] = item1
	t[n + 2] = item2
	t[n + 3] = item3
	t[n + 4] = item4
	t[n + 5] = item5
	t[n + 6] = item6
	t[n + 7] = item7
	a[2] = n + 7
end

local function array_push_back8(a, item1, item2, item3, item4, item5, item6, item7, item8, ...)
	-- function 29
	local t, n = a[1], a[2]

	t[n + 1] = item1
	t[n + 2] = item2
	t[n + 3] = item3
	t[n + 4] = item4
	t[n + 5] = item5
	t[n + 6] = item6
	t[n + 7] = item7
	t[n + 8] = item8
	a[2] = n + 8
end

local function array_push_back9(a, item1, item2, item3, item4, item5, item6, item7, item8, item9, ...)
	-- function 30
	local t, n = a[1], a[2]

	t[n + 1] = item1
	t[n + 2] = item2
	t[n + 3] = item3
	t[n + 4] = item4
	t[n + 5] = item5
	t[n + 6] = item6
	t[n + 7] = item7
	t[n + 8] = item8
	t[n + 9] = item9
	a[2] = n + 9
end

local function array_push_back10(a, item1, item2, item3, item4, item5, item6, item7, item8, item9, item10, ...)
	-- function 31
	local t, n = a[1], a[2]

	t[n + 1] = item1
	t[n + 2] = item2
	t[n + 3] = item3
	t[n + 4] = item4
	t[n + 5] = item5
	t[n + 6] = item6
	t[n + 7] = item7
	t[n + 8] = item8
	t[n + 9] = item9
	t[n + 10] = item10
	a[2] = n + 10
end

local function array_push_back11(a, item1, item2, item3, item4, item5, item6, item7, item8, item9, item10, item11, ...)
	-- function 32
	local t, n = a[1], a[2]

	t[n + 1] = item1
	t[n + 2] = item2
	t[n + 3] = item3
	t[n + 4] = item4
	t[n + 5] = item5
	t[n + 6] = item6
	t[n + 7] = item7
	t[n + 8] = item8
	t[n + 9] = item9
	t[n + 10] = item10
	t[n + 11] = item11
	a[2] = n + 11
end

local function array_push_back12(a, item1, item2, item3, item4, item5, item6, item7, item8, item9, item10, item11, item12, ...)
	-- function 33
	local t, n = a[1], a[2]

	t[n + 1] = item1
	t[n + 2] = item2
	t[n + 3] = item3
	t[n + 4] = item4
	t[n + 5] = item5
	t[n + 6] = item6
	t[n + 7] = item7
	t[n + 8] = item8
	t[n + 9] = item9
	t[n + 10] = item10
	t[n + 11] = item11
	t[n + 12] = item12
	a[2] = n + 12
end

local function array_push_back13(a, item1, item2, item3, item4, item5, item6, item7, item8, item9, item10, item11, item12, item13, ...)
	-- function 34
	local t, n = a[1], a[2]

	t[n + 1] = item1
	t[n + 2] = item2
	t[n + 3] = item3
	t[n + 4] = item4
	t[n + 5] = item5
	t[n + 6] = item6
	t[n + 7] = item7
	t[n + 8] = item8
	t[n + 9] = item9
	t[n + 10] = item10
	t[n + 11] = item11
	t[n + 12] = item12
	t[n + 13] = item13
	a[2] = n + 13
end

local function array_push_back14(a, item1, item2, item3, item4, item5, item6, item7, item8, item9, item10, item11, item12, item13, item14, ...)
	-- function 35
	local t, n = a[1], a[2]

	t[n + 1] = item1
	t[n + 2] = item2
	t[n + 3] = item3
	t[n + 4] = item4
	t[n + 5] = item5
	t[n + 6] = item6
	t[n + 7] = item7
	t[n + 8] = item8
	t[n + 9] = item9
	t[n + 10] = item10
	t[n + 11] = item11
	t[n + 12] = item12
	t[n + 13] = item13
	t[n + 14] = item14
	a[2] = n + 14
end

local function array_push_back15(a, item1, item2, item3, item4, item5, item6, item7, item8, item9, item10, item11, item12, item13, item14, item15, ...)
	-- function 36
	local t, n = a[1], a[2]

	t[n + 1] = item1
	t[n + 2] = item2
	t[n + 3] = item3
	t[n + 4] = item4
	t[n + 5] = item5
	t[n + 6] = item6
	t[n + 7] = item7
	t[n + 8] = item8
	t[n + 9] = item9
	t[n + 10] = item10
	t[n + 11] = item11
	t[n + 12] = item12
	t[n + 13] = item13
	t[n + 14] = item14
	t[n + 15] = item15
	a[2] = n + 15
end

local function array_push_back16(a, item1, item2, item3, item4, item5, item6, item7, item8, item9, item10, item11, item12, item13, item14, item15, item16, ...)
	-- function 37
	local t, n = a[1], a[2]

	t[n + 1] = item1
	t[n + 2] = item2
	t[n + 3] = item3
	t[n + 4] = item4
	t[n + 5] = item5
	t[n + 6] = item6
	t[n + 7] = item7
	t[n + 8] = item8
	t[n + 9] = item9
	t[n + 10] = item10
	t[n + 11] = item11
	t[n + 12] = item12
	t[n + 13] = item13
	t[n + 14] = item14
	t[n + 15] = item15
	t[n + 16] = item16
	a[2] = n + 16
end

local array_push_back_table_lut = {
	function (a, t)
		-- function 38
		local at, n = a[1], a[2]

		at[n + 1] = t[1]
		a[2] = n + 1
	end,
	function (a, t)
		-- function 39
		local at, n = a[1], a[2]

		at[n + 1] = t[1]
		at[n + 2] = t[2]
		a[2] = n + 2
	end,
	function (a, t)
		-- function 40
		local at, n = a[1], a[2]

		at[n + 1] = t[1]
		at[n + 2] = t[2]
		at[n + 3] = t[3]
		a[2] = n + 3
	end,
	function (a, t)
		-- function 41
		local at, n = a[1], a[2]

		at[n + 1] = t[1]
		at[n + 2] = t[2]
		at[n + 3] = t[3]
		at[n + 4] = t[4]
		a[2] = n + 4
	end,
	function (a, t)
		-- function 42
		local at, n = a[1], a[2]

		at[n + 1] = t[1]
		at[n + 2] = t[2]
		at[n + 3] = t[3]
		at[n + 4] = t[4]
		at[n + 5] = t[5]
		a[2] = n + 5
	end,
	function (a, t)
		-- function 43
		local at, n = a[1], a[2]

		at[n + 1] = t[1]
		at[n + 2] = t[2]
		at[n + 3] = t[3]
		at[n + 4] = t[4]
		at[n + 5] = t[5]
		at[n + 6] = t[6]
		a[2] = n + 6
	end,
	function (a, t)
		-- function 44
		local at, n = a[1], a[2]

		at[n + 1] = t[1]
		at[n + 2] = t[2]
		at[n + 3] = t[3]
		at[n + 4] = t[4]
		at[n + 5] = t[5]
		at[n + 6] = t[6]
		at[n + 7] = t[7]
		a[2] = n + 7
	end,
	function (a, t)
		-- function 45
		local at, n = a[1], a[2]

		at[n + 1] = t[1]
		at[n + 2] = t[2]
		at[n + 3] = t[3]
		at[n + 4] = t[4]
		at[n + 5] = t[5]
		at[n + 6] = t[6]
		at[n + 7] = t[7]
		at[n + 8] = t[8]
		a[2] = n + 8
	end
}

local function array_push_back_table(array, in_table, table_count)
	-- function 46
	local push_back_function = array_push_back_table_lut[table_count]

	if push_back_function then
		f(array, in_table)
	else
		for i = 1, table_count do
			array_push_back(array, in_table[i])
		end
	end
end

local function array_back(a)
	-- function 47
	return a[1][a[2]]
end

local function array_front(a)
	-- function 48
	return a[1][1]
end

local function array_filter(a, filter_func)
	-- function 49
	local t, n = a[1], a[2]
	local i = 1

	while i <= n do
		if not filter_func(t[i]) then
			t[i] = t[n]
			t[n] = nil
			n = n - 1
		else
			i = i + 1
		end
	end

	local num_filtered_items = a[2] - n

	a[2] = n

	return num_filtered_items
end

local function array_insert_at(a, v, insert_index)
	-- function 50
	local at, n = a[1], a[2]

	for i = n, insert_index, -1 do
		at[i + 1] = at[i]
	end

	at[insert_index] = v
	a[2] = n + 1
end

local function comp_default(a, b)
	-- function 51
	return a < b
end

local function array_insert_sorted(a, value, comp_function)
	-- function 52
	comp_function = not not comp_function or not not comp_default

	local at, n = a[1], a[2]

	for i = 1, n do
		if comp_function(value, at[i]) then
			array_insert_at(a, value, i)

			return i
		end
	end

	n = n + 1
	at[n] = value
	a[2] = n

	return n
end

local floor = math.floor

local function array_binary_insert(a, value, comp_function)
	-- function 53
	comp_function = not not comp_function or not not comp_default

	local at, n = a[1], a[2]
	local iStart, iEnd, iMid, iState = 1, n, 1, 0

	while iStart <= iEnd do
		iMid = floor((iStart + iEnd) / 2)

		if comp_function(value, at[iMid]) then
			iEnd, iState = iMid - 1, 0
		else
			iStart, iState = iMid + 1, 1
		end
	end

	local insert_index = iMid + iState

	array_insert_at(a, value, insert_index)

	return insert_index
end

local a = {
	new = array_new,
	items = array,
	num_items = array_n,
	data = array_data,
	item_index = array_item_index,
	empty = array_empty,
	resize = array_resize,
	resize_grow_only = array_resize_grow_only,
	set_size = array_set_size,
	set_empty = array_set_empty,
	pop_index = array_pop_index,
	pop_index_value = array_pop_index_value,
	pop_item = array_pop_item,
	pop_item_value = array_pop_item_value,
	pop_index_ordered = array_pop_index_ordered,
	pop_item_ordered = array_pop_item_ordered,
	pop_item_value_ordered = array_pop_item_value_ordered,
	pop_back = array_pop_back,
	erase_back = array_erase_back,
	push_back = array_push_back,
	push_back2 = array_push_back2,
	push_back3 = array_push_back3,
	push_back4 = array_push_back4,
	push_back5 = array_push_back5,
	push_back6 = array_push_back6,
	push_back7 = array_push_back7,
	push_back8 = array_push_back8,
	push_back9 = array_push_back9,
	push_back10 = array_push_back10,
	push_back11 = array_push_back11,
	push_back12 = array_push_back12,
	push_back13 = array_push_back13,
	push_back14 = array_push_back14,
	push_back15 = array_push_back15,
	push_back16 = array_push_back16,
	push_back_table = array_push_back_table,
	insert_at = array_insert_at,
	insert_sorted = array_insert_sorted,
	binary_insert = array_binary_insert,
	front = array_front,
	back = array_back,
	filter = array_filter
}

pdArray = a

return a
