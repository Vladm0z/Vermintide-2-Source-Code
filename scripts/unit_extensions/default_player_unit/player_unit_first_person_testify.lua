-- chunkname: @scripts/unit_extensions/default_player_unit/player_unit_first_person_testify.lua

return {
	set_player_unit_not_visible = function (arg_1_0)
		arg_1_0:hide_weapons("hide_weapons_snippet", true)
		Unit.set_unit_visibility(arg_1_0.first_person_attachment_unit, false)
	end
}
