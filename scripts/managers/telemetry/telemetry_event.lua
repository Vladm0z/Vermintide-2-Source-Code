-- chunkname: @scripts/managers/telemetry/telemetry_event.lua

TelemetryEvent = class(TelemetryEvent)
TelemetryEvent.NAME = "TelemetryEvent"

local var_0_0 = Script.type_name

TelemetryEvent.init = function (arg_1_0, arg_1_1, arg_1_2, arg_1_3, arg_1_4)
	fassert(var_0_0(arg_1_1) == "table", "'source' needs to be table")
	fassert(var_0_0(arg_1_2) == "table" or arg_1_2 == nil, "'subject' needs to be a table or nil")
	fassert(var_0_0(arg_1_3) == "string", "'type' needs to be a string")
	fassert(var_0_0(arg_1_4) == "table" or arg_1_4 == nil, "'session' needs to be a table or nil")

	arg_1_0._event = {
		specversion = "1.2",
		source = arg_1_1,
		subject = arg_1_2,
		type = arg_1_3,
		session = arg_1_4
	}
end

TelemetryEvent.set_revision = function (arg_2_0, arg_2_1)
	fassert(var_0_0(arg_2_1) == "number" or arg_2_1 == nil, "'revision' needs to be a number or nil")

	arg_2_0._event.revision = arg_2_1
end

TelemetryEvent.set_data = function (arg_3_0, arg_3_1)
	assert(var_0_0(arg_3_1) == "table" or arg_3_1 == nil, "'data' needs to be a table or nil")

	arg_3_0._event.data = arg_3_1
end

TelemetryEvent.raw = function (arg_4_0)
	return arg_4_0._event
end

TelemetryEvent.__tostring = function (arg_5_0)
	return table.tostring(arg_5_0._event, math.huge)
end
