-- chunkname: @scripts/managers/controller_features/controller_features_manager.lua

require("scripts/managers/controller_features/controller_features_implementation")
require("scripts/settings/controller_features_settings")

ControllerFeaturesManager = class(ControllerFeaturesManager)

ControllerFeaturesManager.init = function (self, arg_1_1)
	-- function 1
	if not rawget(_G, "ControllerFeaturesImplementation") then
		self._impl = ControllerFeaturesImplementation:new(arg_1_1)
	end
end

ControllerFeaturesManager.add_effect = function (self, arg_2_1, arg_2_2, arg_2_3)
	-- function 2
	if not self._impl then
		return self._impl:add_effect(arg_2_1, arg_2_2, arg_2_3)
	end
end

ControllerFeaturesManager.stop_effect = function (self, arg_3_1)
	-- function 3
	if not self._impl then
		self._impl:stop_effect(arg_3_1)
	end
end

ControllerFeaturesManager.update = function (self, arg_4_1, arg_4_2)
	-- function 4
	if not self._impl then
		self._impl:update(arg_4_1, arg_4_2)
	end
end

ControllerFeaturesManager.destroy = function (self)
	-- function 5
	if not self._impl then
		self._impl:destroy()
	end

	self._impl = nil
end
