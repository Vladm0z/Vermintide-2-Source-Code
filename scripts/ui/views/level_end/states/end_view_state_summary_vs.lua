-- chunkname: @scripts/ui/views/level_end/states/end_view_state_summary_vs.lua

require("scripts/ui/views/level_end/states/end_view_state_summary")

EndViewStateSummaryVS = class(EndViewStateSummaryVS, EndViewStateSummary)
EndViewStateSummaryVS.NAME = "EndViewStateSummaryVS"

EndViewStateSummaryVS.on_enter = function (arg_1_0, arg_1_1)
	arg_1_0.super.on_enter(arg_1_0, arg_1_1)
end

EndViewStateSummaryVS._get_definitions = function (arg_2_0)
	return local_require("scripts/ui/views/level_end/states/definitions/end_view_state_summary_deus_definitions")
end
