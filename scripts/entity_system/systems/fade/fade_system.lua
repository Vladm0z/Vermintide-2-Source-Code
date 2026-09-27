-- chunkname: @scripts/entity_system/systems/fade/fade_system.lua

FadeSystem = class(FadeSystem, ExtensionSystemBase)
FadeSystem.system_extensions = {
	"PlayerUnitFadeExtension",
	"AIUnitFadeExtension"
}

local alive = Unit.alive
local extension = ScriptUnit.extension

FadeSystem.init = function (self, arg_1_1, arg_1_2)
	-- function 1
	local system_extensions = FadeSystem.system_extensions

	FadeSystem.super.init(self, arg_1_1, arg_1_2, system_extensions)

	self.fade_system = EngineOptimizedExtensions.fade_init_system()
end

FadeSystem.destroy = function (self)
	-- function 2
	EngineOptimizedExtensions.fade_destroy_system(self.fade_system)
end

FadeSystem.on_add_extension = function (self, arg_3_1, arg_3_2, arg_3_3, arg_3_4)
	-- function 3
	EngineOptimizedExtensions.fade_on_add_extension(self.fade_system, arg_3_2)
	ScriptUnit.set_extension(arg_3_2, self.name, {})

	return {}
end

FadeSystem.set_min_fade = function (self, arg_4_1, arg_4_2)
	-- function 4
	EngineOptimizedExtensions.fade_set_min_fade(self.fade_system, arg_4_1, arg_4_2)
end

FadeSystem.new_linked_units = function (self, arg_5_1, arg_5_2)
	-- function 5
	EngineOptimizedExtensions.fade_new_linked_units(self.fade_system, arg_5_1, arg_5_2)
end

FadeSystem.on_remove_extension = function (self, arg_6_1, arg_6_2)
	-- function 6
	EngineOptimizedExtensions.fade_on_remove_extension(self.fade_system, arg_6_1)
	ScriptUnit.remove_extension(arg_6_1, self.name)
end

FadeSystem.on_freeze_extension = function (self, arg_7_1, arg_7_2)
	-- function 7
	EngineOptimizedExtensions.fade_on_remove_extension(self.fade_system, arg_7_1)
end

FadeSystem.freeze = function (self, arg_8_1, arg_8_2, arg_8_3)
	-- function 8
	EngineOptimizedExtensions.fade_on_remove_extension(self.fade_system, arg_8_1)
end

FadeSystem.unfreeze = function (self, arg_9_1)
	-- function 9
	EngineOptimizedExtensions.fade_on_add_extension(self.fade_system, arg_9_1)
end

FadeSystem.local_player_created = function (self, arg_10_1)
	-- function 10
	self.player = arg_10_1
end

FadeSystem.update = function (self, arg_11_1, arg_11_2)
	-- function 11
	if not self.player then
		return
	end

	local player = self.player
	local local_player_id = player:local_player_id()
	local viewport_name = player.viewport_name
	local var_11_3
	local free_flight = Managers.free_flight

	if not free_flight:active(local_player_id) then
		var_11_3 = free_flight:camera_position_rotation(local_player_id)
	else
		var_11_3 = Managers.state.camera:camera_position(viewport_name)
	end

	EngineOptimizedExtensions.fade_update(self.fade_system, var_11_3)
end
