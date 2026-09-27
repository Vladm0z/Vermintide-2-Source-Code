-- chunkname: @scripts/managers/save/save_data_common.lua

function ensure_user_id_in_save_data(self)
	-- function 1
	if self.machine_id == nil then
		local function fn(arg_2_0)
			-- function 2
			return string.rep("0", 16 - #arg_2_0) .. arg_2_0
		end

		local function fn_2()
			-- function 3
			return fn(Application.make_hash(Math.random(2147483647), Math.random(2147483647), Math.random(2147483647), Math.random(2147483647)))
		end

		local tbl = {}
		local var_1_3 = fn_2()
		local var_1_4 = fn_2()

		self.machine_id = string.sub(var_1_3, 1, 8) .. "-" .. string.sub(var_1_3, 9, 12) .. "-4" .. string.sub(var_1_3, 13, 15) .. "-8" .. string.sub(var_1_4, 1, 3) .. "-" .. string.sub(var_1_4, 5, 16)
	end
end

function populate_crashify(self)
	-- function 4
	local str = "0"

	if self.machine_id ~= nil then
		str = self.machine_id
	end

	Crashify.print_property("machine_id", str)
end
