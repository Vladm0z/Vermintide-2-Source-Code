-- chunkname: @scripts/managers/save/save_manager.win32.lua

require("scripts/managers/save/script_save_token")

SaveManager = class(SaveManager)

SaveManager.init = function (self, arg_1_1)
	-- function 1
	if (arg_1_1 or not rawget(_G, "Steam")) and not Cloud.enabled() then
		fassert(rawget(_G, "Steam"), "Steam is required for cloud saves")

		self._impl = Cloud
	else
		self._impl = SaveSystem
	end
end

SaveManager.auto_save = function (self, arg_2_1, arg_2_2, arg_2_3, arg_2_4)
	-- function 2
	local SaveSystem

	if not arg_2_4 then
		SaveSystem = SaveSystem

		if not SaveSystem then
			-- Nothing
		end
	end

	SaveSystem = self._impl

	::label_2_0::

	local auto_save = SaveSystem.auto_save(arg_2_1, arg_2_2)
	local var_2_2 = ScriptSaveToken:new(SaveSystem, auto_save)

	Managers.token:register_token(var_2_2, arg_2_3)

	return var_2_2
end

SaveManager.auto_load = function (self, arg_3_1, arg_3_2, arg_3_3)
	-- function 3
	local SaveSystem

	if not arg_3_3 then
		SaveSystem = SaveSystem

		if not SaveSystem then
			-- Nothing
		end
	end

	SaveSystem = self._impl

	::label_3_0::

	local auto_load = SaveSystem.auto_load(arg_3_1)
	local var_3_2 = ScriptSaveToken:new(SaveSystem, auto_load)

	Managers.token:register_token(var_3_2, arg_3_2)

	return var_3_2
end
