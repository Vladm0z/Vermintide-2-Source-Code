-- chunkname: @scripts/managers/input/play_recording_input_device.lua

PlayRecordingInputDevice = {}

function PlayRecordingInputDevice.name()
	return "PlayRecordingInputDevice"
end

function PlayRecordingInputDevice.category()
	return "recording"
end

function PlayRecordingInputDevice.active()
	return true
end
