-- chunkname: @scripts/ui/views/level_end/states/end_view_state_summary_vs.lua

require("scripts/ui/views/level_end/states/end_view_state_summary")

EndViewStateSummaryVS = class(EndViewStateSummaryVS, EndViewStateSummary)
EndViewStateSummaryVS.NAME = "EndViewStateSummaryVS"

function EndViewStateSummaryVS.on_enter(arg_1_0, arg_1_1)
	arg_1_0.super.on_enter(arg_1_0, arg_1_1)
end

function EndViewStateSummaryVS._get_definitions(arg_2_0)
	return local_require("scripts/ui/views/level_end/states/definitions/end_view_state_summary_deus_definitions")
end
