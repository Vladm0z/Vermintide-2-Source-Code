-- chunkname: @scripts/managers/telemetry/telemetry_event.lua

TelemetryEvent = class(TelemetryEvent)
TelemetryEvent.NAME = "TelemetryEvent"

local type_name = Script.type_name

TelemetryEvent.init = function (self, arg_1_1, arg_1_2, arg_1_3, arg_1_4)
	-- function 1
	fassert(type_name(arg_1_1) == "table", "'source' needs to be table")
	fassert(type_name(arg_1_2) == "table" or arg_1_2 == nil, "'subject' needs to be a table or nil")
	fassert(type_name(arg_1_3) == "string", "'type' needs to be a string")
	fassert(type_name(arg_1_4) == "table" or arg_1_4 == nil, "'session' needs to be a table or nil")

	self._event = {
		specversion = "1.2",
		source = arg_1_1,
		subject = arg_1_2,
		type = arg_1_3,
		session = arg_1_4
	}
end

TelemetryEvent.set_revision = function (arg_2_0, arg_2_1)
	-- function 2
	fassert(type_name(arg_2_1) == "number" or arg_2_1 == nil, "'revision' needs to be a number or nil")

	arg_2_0._event.revision = arg_2_1
end

TelemetryEvent.set_data = function (arg_3_0, arg_3_1)
	-- function 3
	assert(type_name(arg_3_1) == "table" or arg_3_1 == nil, "'data' needs to be a table or nil")

	arg_3_0._event.data = arg_3_1
end

TelemetryEvent.raw = function (self)
	-- function 4
	return self._event
end

TelemetryEvent.__tostring = function (self)
	-- function 5
	return table.tostring(self._event, math.huge)
end
