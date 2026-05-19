-- chunkname: @scripts/entity_system/systems/cutscene/cutscene_system_testify.lua

return {
	skip_cutscene = function(arg_1_0)
		arg_1_0:skip_pressed()
	end,
	wait_for_cutscene_to_finish = function(arg_2_0)
		if not arg_2_0:has_intro_cutscene_finished_playing() then
			return Testify.RETRY
		end
	end
}
