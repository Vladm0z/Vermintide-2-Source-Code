-- chunkname: @scripts/settings/dlcs/woods/action_career_we_thornsister_target_stagger.lua

ActionCareerWEThornsisterTargetStagger = class(ActionCareerWEThornsisterTargetStagger, ActionBase)

local str = "units/decals/decal_arrow_kerillian"

ActionCareerWEThornsisterTargetStagger.init = function (self, arg_1_1, arg_1_2, arg_1_3, arg_1_4, arg_1_5, arg_1_6, arg_1_7, arg_1_8)
	-- function 1
	ActionCareerWEThornsisterTargetStagger.super.init(self, arg_1_1, arg_1_2, arg_1_3, arg_1_4, arg_1_5, arg_1_6, arg_1_7, arg_1_8)

	self._first_person_extension = ScriptUnit.has_extension(arg_1_4, "first_person_system")
	self._decal_unit = nil
	self._unit_spawner = Managers.state.unit_spawner
end

ActionCareerWEThornsisterTargetStagger.client_owner_start_action = function (self, arg_2_1, arg_2_2, arg_2_3, arg_2_4, arg_2_5)
	-- function 2
	arg_2_5 = arg_2_5 or {}

	ActionCareerWEThornsisterTargetStagger.super.client_owner_start_action(self, arg_2_1, arg_2_2, arg_2_3, arg_2_4, arg_2_5)

	self._is_flat_dir = arg_2_1.is_flat_direction

	if not self.is_bot then
		self._decal_unit = self._unit_spawner:spawn_local_unit(str)
	end
end

ActionCareerWEThornsisterTargetStagger.client_owner_post_update = function (self, arg_3_1, arg_3_2, arg_3_3, arg_3_4, arg_3_5)
	-- function 3
	if not self._decal_unit then
		local local_position = Unit.local_position(self.owner_unit, 0)
		local _get_direction = self:_get_direction(true)
		local look = Quaternion.look(_get_direction, Vector3.up())

		Unit.set_local_position(self._decal_unit, 0, local_position)
		Unit.set_local_rotation(self._decal_unit, 0, look)
	end
end

ActionCareerWEThornsisterTargetStagger.finish = function (self, arg_4_1)
	-- function 4
	if not self._decal_unit then
		self._unit_spawner:mark_for_deletion(self._decal_unit)

		self._decal_unit = nil
	end

	if arg_4_1 == "new_interupting_action" then
		local _get_direction = self:_get_direction()

		return {
			direction = Vector3Box(_get_direction)
		}
	end
end

ActionCareerWEThornsisterTargetStagger._get_direction = function (self, arg_5_1)
	-- function 5
	local current_rotation = self._first_person_extension:current_rotation()
	local forward = Quaternion.forward(current_rotation)

	if self._is_flat_dir or not arg_5_1 then
		forward = Vector3.flat(forward)
	end

	return forward
end
