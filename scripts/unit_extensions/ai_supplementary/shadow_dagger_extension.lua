-- chunkname: @scripts/unit_extensions/ai_supplementary/shadow_dagger_extension.lua

ShadowDaggerExtension = class(ShadowDaggerExtension)

local var_0_0 = 10

ShadowDaggerExtension.init = function (arg_1_0, arg_1_1, arg_1_2, arg_1_3)
	arg_1_0._projectile_locomotion_extension = ScriptUnit.extension(arg_1_2, "projectile_locomotion_system")
end

ShadowDaggerExtension.destroy = function (arg_2_0)
	return
end

ShadowDaggerExtension.on_remove_extension = function (arg_3_0, arg_3_1, arg_3_2)
	return
end

ShadowDaggerExtension.update = function (arg_4_0, arg_4_1, arg_4_2, arg_4_3, arg_4_4, arg_4_5)
	if arg_4_0._done then
		return
	end

	local var_4_0 = arg_4_0._projectile_locomotion_extension.time_lived

	if not Unit.alive(arg_4_1) then
		arg_4_0._done = true
	elseif var_4_0 > var_0_0 then
		Managers.state.unit_spawner:mark_for_deletion(arg_4_1)

		arg_4_0._done = true
	end
end
