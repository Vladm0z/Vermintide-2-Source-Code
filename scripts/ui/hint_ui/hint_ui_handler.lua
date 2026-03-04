-- chunkname: @scripts/ui/hint_ui/hint_ui_handler.lua

require("scripts/ui/hint_ui/hint_templates")
require("scripts/ui/hint_ui/hint_ui_versus_how_to_play")

HintUIHandler = class(HintUIHandler)

local function var_0_0()
	print("HintUIHandler - save done")
end

local function var_0_1(arg_2_0)
	local var_2_0 = SaveData
	local var_2_1 = var_2_0.viewed_hints or {}

	var_2_1[arg_2_0] = true
	var_2_0.viewed_hints = var_2_1

	Managers.save:auto_save(SaveFileName, SaveData, var_0_0)
end

HintUIHandler.init = function (arg_3_0, arg_3_1)
	arg_3_0._context = arg_3_1
	arg_3_0._hints = {}
	arg_3_0._n_hints = 0
	arg_3_0._hints_ids = 0
	arg_3_0._active_hint_lookup = {}
	arg_3_0._unseen_hints = {}

	arg_3_0:parse_unseen_hints()
	Managers.state.event:register(arg_3_0, "ui_show_hint", "ui_show_hint")
end

HintUIHandler.destroy = function (arg_4_0)
	Managers.state.event:unregister("ui_show_popup", arg_4_0)

	for iter_4_0 = 1, arg_4_0._n_hints do
		local var_4_0 = arg_4_0._hints[iter_4_0]

		if var_4_0 then
			var_4_0:destroy()

			arg_4_0._hints[iter_4_0] = nil
		end
	end
end

HintUIHandler.update = function (arg_5_0, arg_5_1, arg_5_2)
	arg_5_0:_handle_condition_hints(arg_5_1, arg_5_2)

	local var_5_0 = arg_5_0._hints[arg_5_0._n_hints]

	if not var_5_0 then
		return
	end

	var_5_0:update(arg_5_1, arg_5_2)

	if var_5_0:exit_done() then
		local var_5_1 = var_5_0:get_hint_name()
		local var_5_2 = arg_5_0:get_unseen_hint_index(var_5_1)

		var_5_0:delete()

		arg_5_0._hints[arg_5_0._n_hints] = nil
		arg_5_0._n_hints = arg_5_0._n_hints - 1

		var_0_1(var_5_1)
		table.swap_delete(arg_5_0._unseen_hints, var_5_2)

		arg_5_0._active_hint_lookup[var_5_1] = false
	end
end

HintUIHandler.queue_hint = function (arg_6_0, arg_6_1)
	local var_6_0 = arg_6_0._n_hints
	local var_6_1 = arg_6_0._hints
	local var_6_2 = var_6_0 + 1

	arg_6_0._n_hints = var_6_2
	arg_6_0._hints_ids = arg_6_0._hints_ids + 1

	local var_6_3 = tostring(arg_6_0._hints_ids)

	arg_6_1.hint_id = var_6_3

	if var_6_2 > 1 and var_6_1[var_6_2 - 1]:is_hint_showing() then
		table.insert(var_6_1, 1, arg_6_1)

		arg_6_0._hints = var_6_1

		return var_6_3
	end

	var_6_1[var_6_2] = arg_6_1
	arg_6_0._hints = var_6_1

	return var_6_3
end

HintUIHandler.ui_show_hint = function (arg_7_0, arg_7_1)
	local var_7_0 = HintTemplates[arg_7_1]

	if not var_7_0 then
		printf("[HintUIHandler]No HintTemplate settings found for hint %q", arg_7_1)

		return
	end

	if not var_7_0.data.duration then
		printf("[HintUIHandler]No duration defined for hint %q, A duration must be set in the HintTemplates data", arg_7_1)

		return
	end

	arg_7_0:new_hint(arg_7_1, var_7_0)
end

HintUIHandler.new_hint = function (arg_8_0, arg_8_1, arg_8_2)
	local var_8_0 = arg_8_2.data
	local var_8_1 = rawget(_G, var_8_0.class_name):new(arg_8_0._context, arg_8_1, arg_8_2)

	arg_8_0._active_hint_lookup[arg_8_1] = true

	arg_8_0:queue_hint(var_8_1)
end

HintUIHandler._handle_condition_hints = function (arg_9_0, arg_9_1, arg_9_2)
	for iter_9_0 = 1, #arg_9_0._unseen_hints do
		local var_9_0 = arg_9_0._unseen_hints[iter_9_0]

		if not arg_9_0._active_hint_lookup[var_9_0] then
			local var_9_1 = HintTemplates[var_9_0]
			local var_9_2 = var_9_1.data

			if var_9_1.condition_function(var_9_2, arg_9_1, arg_9_2) then
				arg_9_0:new_hint(var_9_0, var_9_1)
			end
		end
	end
end

HintUIHandler.is_hint_active = function (arg_10_0)
	return arg_10_0._hints[arg_10_0._n_hints] and true or false
end

HintUIHandler.parse_unseen_hints = function (arg_11_0)
	table.clear(arg_11_0._unseen_hints)

	for iter_11_0, iter_11_1 in pairs(HintTemplates) do
		if (not SaveData.viewed_hints or not SaveData.viewed_hints[iter_11_0]) and iter_11_1.condition_function then
			arg_11_0._unseen_hints[#arg_11_0._unseen_hints + 1] = iter_11_0
		end
	end
end

HintUIHandler.get_unseen_hint_index = function (arg_12_0, arg_12_1)
	for iter_12_0 = 1, #arg_12_0._unseen_hints do
		if arg_12_1 == arg_12_0._unseen_hints[iter_12_0] then
			return iter_12_0
		end
	end
end
