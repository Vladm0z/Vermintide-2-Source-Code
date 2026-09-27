-- chunkname: @scripts/entity_system/systems/dialogues/dialogue_state_handler.lua

local num = 10

DialogueStateHandler = class(DialogueStateHandler)
DialogueStateHandler.debug = true

local function fn(...)
	-- function 1
	if not DialogueStateHandler.debug then
		print("[DialogueStateHandler] " .. string.format(...))
	end
end

DialogueStateHandler.init = function (self, arg_2_1)
	-- function 2
	self._world = arg_2_1
	self._playing_dialogues = {}
	self._current_index = 1
end

DialogueStateHandler.add_playing_dialogue = function (arg_3_0, arg_3_1, arg_3_2, arg_3_3, arg_3_4)
	-- function 3
	arg_3_0._playing_dialogues[#arg_3_0._playing_dialogues + 1] = {
		identifier = arg_3_1,
		event_id = arg_3_2,
		start_time = arg_3_3,
		expected_end = arg_3_3 + arg_3_4
	}
end

local tbl = {}

DialogueStateHandler.update = function (self, arg_4_1)
	-- function 4
	if not table.is_empty(self._playing_dialogues) then
		return
	end

	table.clear(tbl)

	local num_2 = 0
	local _current_index = self._current_index
	local current_level = LevelHelper:current_level(self._world)

	repeat
		local var_4_3 = self._playing_dialogues[self._current_index]

		if arg_4_1 > var_4_3.expected_end then
			Level.set_flow_variable(current_level, "dialogue_identifier", var_4_3.identifier)
			Level.trigger_event(current_level, "dialogue_ended")

			tbl[#tbl + 1] = self._current_index

			fn("Triggering %s after %.2fs", var_4_3.identifier, arg_4_1 - var_4_3.start_time)
		end

		self._current_index = math.index_wrapper(self._current_index + 1, #self._playing_dialogues)
		num_2 = num_2 + 1
	until not (self._current_index == _current_index or not (num_2 >= num))

	if not table.is_empty(tbl) then
		table.sort(tbl)

		for i = #tbl, 1, -1 do
			local var_4_4 = tbl[i]

			table.remove(self._playing_dialogues, var_4_4)
		end
	end
end
