-- chunkname: @scripts/managers/controller_features/controller_features_manager.lua

require("scripts/managers/controller_features/controller_features_implementation")
require("scripts/settings/controller_features_settings")

ControllerFeaturesManager = class(ControllerFeaturesManager)

function ControllerFeaturesManager.init(arg_1_0, arg_1_1)
	if rawget(_G, "ControllerFeaturesImplementation") then
		arg_1_0._impl = ControllerFeaturesImplementation:new(arg_1_1)
	end
end

function ControllerFeaturesManager.add_effect(arg_2_0, arg_2_1, arg_2_2, arg_2_3)
	if arg_2_0._impl then
		return arg_2_0._impl:add_effect(arg_2_1, arg_2_2, arg_2_3)
	end
end

function ControllerFeaturesManager.stop_effect(arg_3_0, arg_3_1)
	if arg_3_0._impl then
		arg_3_0._impl:stop_effect(arg_3_1)
	end
end

function ControllerFeaturesManager.update(arg_4_0, arg_4_1, arg_4_2)
	if arg_4_0._impl then
		arg_4_0._impl:update(arg_4_1, arg_4_2)
	end
end

function ControllerFeaturesManager.destroy(arg_5_0)
	if arg_5_0._impl then
		arg_5_0._impl:destroy()
	end

	arg_5_0._impl = nil
end
