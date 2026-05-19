-- chunkname: @scripts/managers/input/network_input_device.lua

NetworkInputDevice = {}

function NetworkInputDevice.name()
	return "NetworkInputDevice"
end

function NetworkInputDevice.category()
	return "network"
end

function NetworkInputDevice.active()
	return true
end
