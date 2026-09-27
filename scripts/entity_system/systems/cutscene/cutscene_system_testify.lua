-- chunkname: @scripts/entity_system/systems/cutscene/cutscene_system_testify.lua

return {
	skip_cutscene = function (self)
		-- function 1
		self:skip_pressed()
	end,
	wait_for_cutscene_to_finish = function (self)
		-- function 2
		if not self:has_intro_cutscene_finished_playing() then
			return Testify.RETRY
		end
	end
}
