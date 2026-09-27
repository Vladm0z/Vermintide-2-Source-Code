-- chunkname: @scripts/ui/views/level_end/states/end_view_state_summary_vs.lua

require("scripts/ui/views/level_end/states/end_view_state_summary")

EndViewStateSummaryVS = class(EndViewStateSummaryVS, EndViewStateSummary)
EndViewStateSummaryVS.NAME = "EndViewStateSummaryVS"

EndViewStateSummaryVS.on_enter = function (self, arg_1_1)
	-- function 1
	self.super.on_enter(self, arg_1_1)
end

EndViewStateSummaryVS._get_definitions = function (arg_2_0)
	-- function 2
	return local_require("scripts/ui/views/level_end/states/definitions/end_view_state_summary_deus_definitions")
end
