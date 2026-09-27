-- chunkname: @foundation/scripts/util/application_parameter.lua

require("foundation/scripts/util/table")

local script_data = script_data

script_data = script_data or {}
script_data = script_data

local Development = Development

Development = Development or {}
Development = Development
Development.application_parameter = {}

Development.init_application_parameters = function (arg_1_0, arg_1_1)
	-- function 1
	print("Development.init_application_parameters")

	Development.application_parameter = {}

	local application_parameter = Development.application_parameter

	local function fn(...)
		-- function 2
		print(string.format(...))
	end

	local function fn_2(self)
		-- function 3
		return self:sub(1, 1)
	end

	local function fn_3(arg_4_0)
		-- function 4
		return fn_2(arg_4_0) == "-"
	end

	local function fn_4(self)
		-- function 5
		return self:sub(2)
	end

	local count = #arg_1_0
	local num = 1

	local function fn_5()
		-- function 6
		return count >= num
	end

	local function fn_6()
		-- function 7
		return count >= num + 1
	end

	local function fn_7()
		-- function 8
		num = num + 1
	end

	local function fn_8()
		-- function 9
		return arg_1_0[num]
	end

	local function fn_9()
		-- function 10
		return arg_1_0[num + 1]
	end

	local function fn_10()
		-- function 11
		assert(fn_6())

		return fn_3(fn_9())
	end

	local function fn_11(arg_12_0, arg_12_1)
		-- function 12
		local var_12_0 = application_parameter[arg_12_0]
		local flag = type(var_12_0) ~= "table" or not var_12_0 or {
			var_12_0
		}

		fn("[parse_application_parameters] multiple defintions of '%s' using [%s]. old value [%s]", arg_12_0, table.tostring(flag), table.tostring(arg_12_1))
	end

	local function fn_12(arg_13_0)
		-- function 13
		local var_13_0 = application_parameter[arg_13_0]

		if not var_13_0 then
			return nil
		end

		local tbl = {}

		if type(var_13_0) == "table" then
			for i = 1, #var_13_0 do
				tbl[i] = var_13_0[i]
			end
		else
			tbl[1] = var_13_0
		end

		return tbl
	end

	local num_2 = 0

	while not fn_5() do
		local var_1_16 = fn_8()

		if not fn_3(var_1_16) then
			fn_7()
		else
			local var_1_17 = fn_4(var_1_16)

			num_2 = math.max(num_2, #var_1_17)

			if not application_parameter[var_1_17] then
				local var_1_18 = fn_12(var_1_17)

				fn_11(var_1_17, var_1_18)

				application_parameter[var_1_17] = nil
			end

			local var_1_19

			if not fn_6() then
				var_1_19 = fn_10()

				if not var_1_19 then
					-- Nothing
				end
			end

			var_1_19 = not fn_6()

			::label_1_0::

			if not var_1_19 then
				application_parameter[var_1_17] = true

				fn_7()
			else
				while not (not fn_6() and fn_10()) do
					fn_7()

					local var_1_20 = fn_8()
					local var_1_21 = application_parameter[var_1_17]

					if var_1_20 == "true" then
						var_1_20 = true
					end

					if var_1_20 == "false" then
						var_1_20 = false
					end

					if not var_1_21 then
						application_parameter[var_1_17] = var_1_20
					elseif type(application_parameter[var_1_17]) == "table" then
						local var_1_22 = application_parameter[var_1_17]

						var_1_22[#var_1_22 + 1] = var_1_20
					else
						application_parameter[var_1_17] = {
							var_1_21,
							var_1_20
						}
					end
				end
			end
		end
	end

	local flag = application_parameter["eac-untrusted"] ~= nil or application_parameter.eac_untrusted ~= nil

	rawset(_G, "MODDED_REALM", flag)

	if not (DEDICATED_SERVER or BUILD == "release") then
		if not application_parameter["use-clean-settings"] then
			local tbl = {
				build_identifier = script_data.build_identifier
			}
			local settings = script_data.settings

			settings = settings or {}
			tbl.settings = settings
			script_data = tbl
		end

		for k, v in pairs(application_parameter) do
			if type(k) == "string" then
				local gsub = string.gsub(k, "-", "_")

				script_data[gsub] = v
			else
				script_data[k] = v
			end
		end
	end

	if not arg_1_1 then
		print("-----------------------------------------------------------------")
		print("--                   Application parameters                    --")

		for k_2, v_2 in pairs(application_parameter) do
			if type(v_2) == "table" then
				local format = string.format("%%-%ds = {", num_2)
				local format_2 = string.format(format, k_2)

				for i4 = 1, #v_2 do
					format_2 = format_2 .. " " .. tostring(v_2[i4])
				end

				local str = format_2 .. " }"

				print(str)
			else
				local format_3 = string.format("%%-%ds = %%s", num_2)

				fn(format_3, k_2, tostring(v_2))
			end
		end

		print("-----------------------------------------------------------------")
	end
end
