-- chunkname: @scripts/unit_extensions/outline/outline_extension.lua

require("scripts/settings/outline_settings")

OutlineExtension = class(OutlineExtension)

function OutlineExtension.init(arg_1_0, arg_1_1, arg_1_2)
	arg_1_0._unique_id = 0
	arg_1_0._default_settings = nil
	arg_1_0._unit = arg_1_2
	arg_1_0.outlined = false
	arg_1_0.reapply = false
	arg_1_0.flag = nil
	arg_1_0.apply_method = nil
	arg_1_0.outline_color = nil
	arg_1_0.distance = nil
	arg_1_0.method = nil
	arg_1_0.outline_settings = {}
	arg_1_0._outline_system = arg_1_1
end

function OutlineExtension.add_outline(arg_2_0, arg_2_1)
	local var_2_0 = arg_2_0._unique_id
	local var_2_1 = table.clone(arg_2_1)

	arg_2_0._unique_id = arg_2_0._unique_id + 1

	if var_2_0 == 0 then
		arg_2_0._default_settings = var_2_1
	end

	var_2_1._unique_id = var_2_0
	var_2_1.priority = var_2_1.priority or 0

	local var_2_2 = arg_2_0.outline_settings
	local var_2_3 = #var_2_2
	local var_2_4 = var_2_3 + 1
	local var_2_5 = var_2_1.priority

	for iter_2_0 = 1, var_2_3 do
		if var_2_5 >= var_2_2[iter_2_0][1].priority then
			var_2_4 = iter_2_0

			break
		end
	end

	if var_2_2[var_2_4] then
		local var_2_6 = var_2_2[var_2_4]

		table.insert(var_2_6, 1, var_2_1)
	else
		var_2_2[var_2_4] = {
			var_2_1
		}
	end

	if var_2_4 == 1 then
		arg_2_0:_refresh_current_outline()
	end

	return var_2_0
end

function OutlineExtension.remove_outline(arg_3_0, arg_3_1)
	if not arg_3_1 or arg_3_1 < 0 then
		return
	end

	local var_3_0 = arg_3_0.outline_settings

	for iter_3_0 = 1, #var_3_0 do
		local var_3_1 = var_3_0[iter_3_0]

		for iter_3_1 = 1, #var_3_1 do
			if var_3_1[iter_3_1]._unique_id == arg_3_1 then
				table.remove(var_3_1, iter_3_1)

				if #var_3_1 == 0 then
					table.remove(var_3_0, iter_3_0)
				end

				if iter_3_0 == 1 and iter_3_1 == 1 then
					arg_3_0:_refresh_current_outline()
				end

				return
			end
		end
	end
end

function OutlineExtension.update_outline(arg_4_0, arg_4_1, arg_4_2)
	if not arg_4_2 or arg_4_2 < 0 then
		return
	end

	local var_4_0 = arg_4_0.outline_settings

	for iter_4_0 = 1, #var_4_0 do
		local var_4_1 = var_4_0[iter_4_0]

		for iter_4_1 = 1, #var_4_1 do
			local var_4_2 = var_4_1[iter_4_1]

			if var_4_2._unique_id == arg_4_2 then
				table.merge(var_4_2, arg_4_1)

				arg_4_1._unique_id = arg_4_2

				if iter_4_0 == 1 and iter_4_1 == 1 then
					arg_4_0:_refresh_current_outline()
				end
			end
		end
	end
end

function OutlineExtension.reapply_outline(arg_5_0)
	arg_5_0.reapply = true

	arg_5_0._outline_system:mark_outline_dirty(arg_5_0._unit)
end

function OutlineExtension._refresh_current_outline(arg_6_0, arg_6_1)
	local var_6_0 = arg_6_0._default_settings
	local var_6_1 = arg_6_0.outline_settings[1][1]
	local var_6_2 = not var_6_1.outline_color or arg_6_0.outline_color ~= var_6_1.outline_color

	arg_6_0.outline_color = var_6_1.outline_color and var_6_1.outline_color or var_6_0.outline_color
	arg_6_0.distance = var_6_1.distance and var_6_1.distance or var_6_0.distance
	arg_6_0.method = var_6_1.method and var_6_1.method or var_6_0.method
	arg_6_0.prev_flag = arg_6_0.flag
	arg_6_0.flag = var_6_1.flag and var_6_1.flag or var_6_0.flag
	arg_6_0.reapply = arg_6_1 or arg_6_0.outlined and var_6_2

	if arg_6_0.reapply or var_6_2 then
		arg_6_0._outline_system:mark_outline_dirty(arg_6_0._unit)
	end
end

function OutlineExtension.on_freeze(arg_7_0)
	arg_7_0.method = "never"

	table.clear(arg_7_0.outline_settings)

	arg_7_0.outline_settings[1] = {
		arg_7_0._default_settings
	}
end

function OutlineExtension.on_unfreeze(arg_8_0)
	arg_8_0:_refresh_current_outline()
end

function OutlineExtension.swap_delete_outline(arg_9_0, arg_9_1, arg_9_2)
	local var_9_0 = arg_9_0.outline_settings
	local var_9_1
	local var_9_2
	local var_9_3
	local var_9_4

	for iter_9_0 = 1, #var_9_0 do
		local var_9_5 = var_9_0[iter_9_0]

		for iter_9_1 = 1, #var_9_5 do
			if var_9_5[iter_9_1]._unique_id == arg_9_1 then
				var_9_3 = iter_9_0
				var_9_4 = iter_9_1
			end

			if var_9_5[iter_9_1]._unique_id == arg_9_2 then
				var_9_1 = iter_9_0
				var_9_2 = iter_9_1
			end
		end
	end

	local var_9_6 = var_9_0[var_9_3][var_9_4]

	var_9_6._unique_id = arg_9_2
	var_9_0[var_9_1][var_9_2] = var_9_6

	table.remove(var_9_0[var_9_3], var_9_4)

	if #var_9_0[var_9_3] == 0 then
		table.remove(var_9_0, var_9_3)
	end

	arg_9_0._default_settings = var_9_6

	arg_9_0:update_outline(var_9_6, arg_9_2)
end
