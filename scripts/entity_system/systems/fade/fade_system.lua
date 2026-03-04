-- chunkname: @scripts/entity_system/systems/fade/fade_system.lua

FadeSystem = class(FadeSystem, ExtensionSystemBase)
FadeSystem.system_extensions = {
	"PlayerUnitFadeExtension",
	"AIUnitFadeExtension"
}

local var_0_0 = Unit.alive
local var_0_1 = ScriptUnit.extension

function FadeSystem.init(arg_1_0, arg_1_1, arg_1_2)
	local var_1_0 = FadeSystem.system_extensions

	FadeSystem.super.init(arg_1_0, arg_1_1, arg_1_2, var_1_0)

	arg_1_0.fade_system = EngineOptimizedExtensions.fade_init_system()
end

function FadeSystem.destroy(arg_2_0)
	EngineOptimizedExtensions.fade_destroy_system(arg_2_0.fade_system)
end

function FadeSystem.on_add_extension(arg_3_0, arg_3_1, arg_3_2, arg_3_3, arg_3_4)
	EngineOptimizedExtensions.fade_on_add_extension(arg_3_0.fade_system, arg_3_2)
	ScriptUnit.set_extension(arg_3_2, arg_3_0.name, {})

	return {}
end

function FadeSystem.set_min_fade(arg_4_0, arg_4_1, arg_4_2)
	EngineOptimizedExtensions.fade_set_min_fade(arg_4_0.fade_system, arg_4_1, arg_4_2)
end

function FadeSystem.new_linked_units(arg_5_0, arg_5_1, arg_5_2)
	EngineOptimizedExtensions.fade_new_linked_units(arg_5_0.fade_system, arg_5_1, arg_5_2)
end

function FadeSystem.on_remove_extension(arg_6_0, arg_6_1, arg_6_2)
	EngineOptimizedExtensions.fade_on_remove_extension(arg_6_0.fade_system, arg_6_1)
	ScriptUnit.remove_extension(arg_6_1, arg_6_0.name)
end

function FadeSystem.on_freeze_extension(arg_7_0, arg_7_1, arg_7_2)
	EngineOptimizedExtensions.fade_on_remove_extension(arg_7_0.fade_system, arg_7_1)
end

function FadeSystem.freeze(arg_8_0, arg_8_1, arg_8_2, arg_8_3)
	EngineOptimizedExtensions.fade_on_remove_extension(arg_8_0.fade_system, arg_8_1)
end

function FadeSystem.unfreeze(arg_9_0, arg_9_1)
	EngineOptimizedExtensions.fade_on_add_extension(arg_9_0.fade_system, arg_9_1)
end

function FadeSystem.local_player_created(arg_10_0, arg_10_1)
	arg_10_0.player = arg_10_1
end

function FadeSystem.update(arg_11_0, arg_11_1, arg_11_2)
	if not arg_11_0.player then
		return
	end

	local var_11_0 = arg_11_0.player
	local var_11_1 = var_11_0:local_player_id()
	local var_11_2 = var_11_0.viewport_name
	local var_11_3
	local var_11_4 = Managers.free_flight

	if var_11_4:active(var_11_1) then
		var_11_3 = var_11_4:camera_position_rotation(var_11_1)
	else
		var_11_3 = Managers.state.camera:camera_position(var_11_2)
	end

	EngineOptimizedExtensions.fade_update(arg_11_0.fade_system, var_11_3)
end
