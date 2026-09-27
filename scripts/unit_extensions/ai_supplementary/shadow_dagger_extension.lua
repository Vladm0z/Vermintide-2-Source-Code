-- chunkname: @scripts/unit_extensions/ai_supplementary/shadow_dagger_extension.lua

ShadowDaggerExtension = class(ShadowDaggerExtension)

local num = 10

ShadowDaggerExtension.init = function (self, arg_1_1, arg_1_2, arg_1_3)
	-- function 1
	self._projectile_locomotion_extension = ScriptUnit.extension(arg_1_2, "projectile_locomotion_system")
end

ShadowDaggerExtension.destroy = function (arg_2_0)
	-- function 2
	return
end

ShadowDaggerExtension.on_remove_extension = function (arg_3_0, arg_3_1, arg_3_2)
	-- function 3
	return
end

ShadowDaggerExtension.update = function (self, arg_4_1, arg_4_2, arg_4_3, arg_4_4, arg_4_5)
	-- function 4
	if not self._done then
		return
	end

	local time_lived = self._projectile_locomotion_extension.time_lived

	if not Unit.alive(arg_4_1) then
		self._done = true
	elseif time_lived > num then
		Managers.state.unit_spawner:mark_for_deletion(arg_4_1)

		self._done = true
	end
end
