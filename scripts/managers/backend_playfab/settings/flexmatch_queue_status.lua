-- chunkname: @scripts/managers/backend_playfab/settings/flexmatch_queue_status.lua

local FlexmatchQueueStatus = {
	Searching = "SEARCHING",
	Cancelled = "CANCELLED",
	Failed = "FAILED",
	Queued = "QUEUED",
	Completed = "COMPLETED",
	TimedOut = "TIMED_OUT",
	Succeeded = "SUCCEEDED",
	RequiredAcceptance = "REQUIRES_ACCEPTANCE"
}

return FlexmatchQueueStatus
