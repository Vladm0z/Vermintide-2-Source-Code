-- chunkname: @scripts/managers/save/save_data_common.lua

function ensure_user_id_in_save_data(arg_1_0)
	if arg_1_0.machine_id == nil then
		local function var_1_0(arg_2_0)
			return string.rep("0", 16 - #arg_2_0) .. arg_2_0
		end

		local function var_1_1()
			return var_1_0(Application.make_hash(Math.random(2147483647), Math.random(2147483647), Math.random(2147483647), Math.random(2147483647)))
		end

		local var_1_2 = {}
		local var_1_3 = var_1_1()
		local var_1_4 = var_1_1()

		arg_1_0.machine_id = string.sub(var_1_3, 1, 8) .. "-" .. string.sub(var_1_3, 9, 12) .. "-4" .. string.sub(var_1_3, 13, 15) .. "-8" .. string.sub(var_1_4, 1, 3) .. "-" .. string.sub(var_1_4, 5, 16)
	end
end

function populate_crashify(arg_4_0)
	local var_4_0 = "0"

	if arg_4_0.machine_id ~= nil then
		var_4_0 = arg_4_0.machine_id
	end

	Crashify.print_property("machine_id", var_4_0)
end
