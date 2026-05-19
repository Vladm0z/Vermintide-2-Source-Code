-- chunkname: @scripts/entity_system/systems/dialogues/dialogue_state_handler.lua

local var_0_0 = 10

DialogueStateHandler = class(DialogueStateHandler)
DialogueStateHandler.debug = true

local function var_0_1(...)
	if DialogueStateHandler.debug then
		print("[DialogueStateHandler] " .. string.format(...))
	end
end

function DialogueStateHandler.init(arg_2_0, arg_2_1)
	arg_2_0._world = arg_2_1
	arg_2_0._playing_dialogues = {}
	arg_2_0._current_index = 1
end

function DialogueStateHandler.add_playing_dialogue(arg_3_0, arg_3_1, arg_3_2, arg_3_3, arg_3_4)
	arg_3_0._playing_dialogues[#arg_3_0._playing_dialogues + 1] = {
		identifier = arg_3_1,
		event_id = arg_3_2,
		start_time = arg_3_3,
		expected_end = arg_3_3 + arg_3_4
	}
end

local var_0_2 = {}

function DialogueStateHandler.update(arg_4_0, arg_4_1)
	if table.is_empty(arg_4_0._playing_dialogues) then
		return
	end

	table.clear(var_0_2)

	local var_4_0 = 0
	local var_4_1 = arg_4_0._current_index
	local var_4_2 = LevelHelper:current_level(arg_4_0._world)

	repeat
		local var_4_3 = arg_4_0._playing_dialogues[arg_4_0._current_index]

		if arg_4_1 > var_4_3.expected_end then
			Level.set_flow_variable(var_4_2, "dialogue_identifier", var_4_3.identifier)
			Level.trigger_event(var_4_2, "dialogue_ended")

			var_0_2[#var_0_2 + 1] = arg_4_0._current_index

			var_0_1("Triggering %s after %.2fs", var_4_3.identifier, arg_4_1 - var_4_3.start_time)
		end

		arg_4_0._current_index = math.index_wrapper(arg_4_0._current_index + 1, #arg_4_0._playing_dialogues)
		var_4_0 = var_4_0 + 1
	until arg_4_0._current_index == var_4_1 or var_4_0 >= var_0_0

	if not table.is_empty(var_0_2) then
		table.sort(var_0_2)

		for iter_4_0 = #var_0_2, 1, -1 do
			local var_4_4 = var_0_2[iter_4_0]

			table.remove(arg_4_0._playing_dialogues, var_4_4)
		end
	end
end
