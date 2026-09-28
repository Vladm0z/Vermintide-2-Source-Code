-- chunkname: @scripts/entity_system/systems/cutscene/cutscene_system_testify.lua

local CutsceneSystemTestify = {
	skip_cutscene = function (cutscene_system)
		-- function 1
		cutscene_system:skip_pressed()
	end,
	wait_for_cutscene_to_finish = function (cutscene_system)
		-- function 2
		local cutscene_finished = cutscene_system:has_intro_cutscene_finished_playing()

		if not cutscene_finished then
			return Testify.RETRY
		end
	end
}

return CutsceneSystemTestify
