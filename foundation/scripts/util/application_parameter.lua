-- chunkname: @foundation/scripts/util/application_parameter.lua

require("foundation/scripts/util/table")

script_data = script_data or {}
Development = Development or {}
Development.application_parameter = {}

Development.init_application_parameters = function (arg_1_0, arg_1_1)
	print("Development.init_application_parameters")

	Development.application_parameter = {}

	local var_1_0 = Development.application_parameter

	local function var_1_1(...)
		print(string.format(...))
	end

	local function var_1_2(arg_3_0)
		return arg_3_0:sub(1, 1)
	end

	local function var_1_3(arg_4_0)
		return var_1_2(arg_4_0) == "-"
	end

	local function var_1_4(arg_5_0)
		return arg_5_0:sub(2)
	end

	local var_1_5 = #arg_1_0
	local var_1_6 = 1

	local function var_1_7()
		return var_1_5 >= var_1_6
	end

	local function var_1_8()
		return var_1_5 >= var_1_6 + 1
	end

	local function var_1_9()
		var_1_6 = var_1_6 + 1
	end

	local function var_1_10()
		return arg_1_0[var_1_6]
	end

	local function var_1_11()
		return arg_1_0[var_1_6 + 1]
	end

	local function var_1_12()
		assert(var_1_8())

		return var_1_3(var_1_11())
	end

	local function var_1_13(arg_12_0, arg_12_1)
		local var_12_0 = var_1_0[arg_12_0]
		local var_12_1 = type(var_12_0) == "table" and var_12_0 or {
			var_12_0
		}

		var_1_1("[parse_application_parameters] multiple defintions of '%s' using [%s]. old value [%s]", arg_12_0, table.tostring(var_12_1), table.tostring(arg_12_1))
	end

	local function var_1_14(arg_13_0)
		local var_13_0 = var_1_0[arg_13_0]

		if not var_13_0 then
			return nil
		end

		local var_13_1 = {}

		if type(var_13_0) == "table" then
			for iter_13_0 = 1, #var_13_0 do
				var_13_1[iter_13_0] = var_13_0[iter_13_0]
			end
		else
			var_13_1[1] = var_13_0
		end

		return var_13_1
	end

	local var_1_15 = 0

	while var_1_7() do
		local var_1_16 = var_1_10()

		if not var_1_3(var_1_16) then
			var_1_9()
		else
			local var_1_17 = var_1_4(var_1_16)

			var_1_15 = math.max(var_1_15, #var_1_17)

			if var_1_0[var_1_17] then
				local var_1_18 = var_1_14(var_1_17)

				var_1_13(var_1_17, var_1_18)

				var_1_0[var_1_17] = nil
			end

			if var_1_8() and var_1_12() or not var_1_8() then
				var_1_0[var_1_17] = true

				var_1_9()
			else
				while var_1_8() and not var_1_12() do
					var_1_9()

					local var_1_19 = var_1_10()
					local var_1_20 = var_1_0[var_1_17]

					if var_1_19 == "true" then
						var_1_19 = true
					end

					if var_1_19 == "false" then
						var_1_19 = false
					end

					if not var_1_20 then
						var_1_0[var_1_17] = var_1_19
					elseif type(var_1_0[var_1_17]) == "table" then
						local var_1_21 = var_1_0[var_1_17]

						var_1_21[#var_1_21 + 1] = var_1_19
					else
						var_1_0[var_1_17] = {
							var_1_20,
							var_1_19
						}
					end
				end
			end
		end
	end

	script_data["eac-untrusted"] = var_1_0["eac-untrusted"] ~= nil or var_1_0.eac_untrusted ~= nil

	if DEDICATED_SERVER or BUILD ~= "release" then
		if var_1_0["use-clean-settings"] then
			script_data = {
				build_identifier = script_data.build_identifier,
				settings = script_data.settings or {}
			}
		end

		for iter_1_0, iter_1_1 in pairs(var_1_0) do
			if type(iter_1_0) == "string" then
				local var_1_22 = string.gsub(iter_1_0, "-", "_")

				script_data[var_1_22] = iter_1_1
			else
				script_data[iter_1_0] = iter_1_1
			end
		end
	end

	if arg_1_1 then
		print("-----------------------------------------------------------------")
		print("--                   Application parameters                    --")

		for iter_1_2, iter_1_3 in pairs(var_1_0) do
			if type(iter_1_3) == "table" then
				local var_1_23 = string.format("%%-%ds = {", var_1_15)
				local var_1_24 = string.format(var_1_23, iter_1_2)

				for iter_1_4 = 1, #iter_1_3 do
					var_1_24 = var_1_24 .. " " .. tostring(iter_1_3[iter_1_4])
				end

				local var_1_25 = var_1_24 .. " }"

				print(var_1_25)
			else
				local var_1_26 = string.format("%%-%ds = %%s", var_1_15)

				var_1_1(var_1_26, iter_1_2, tostring(iter_1_3))
			end
		end

		print("-----------------------------------------------------------------")
	end
end
