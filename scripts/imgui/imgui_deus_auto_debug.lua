-- chunkname: @scripts/imgui/imgui_deus_auto_debug.lua

ImguiDeusAutoDebug = class(ImguiDeusAutoDebug)

local tbl = {
	"That ain't working.",
	"Have you tried restarting?",
	"Maybe furiously spamming this button will work.",
	"I'm not helpful",
	"I'm helpful",
	"I'm a notorious liar",
	"What is truth",
	"This is a helpful response",
	"It is wednesday my dudes"
}

ImguiDeusAutoDebug.init = function (self)
	-- function 1
	self._current_response = ""
end

ImguiDeusAutoDebug.update = function (arg_2_0)
	-- function 2
	return
end

ImguiDeusAutoDebug.is_persistent = function (arg_3_0)
	-- function 3
	return false
end

ImguiDeusAutoDebug.draw = function (self)
	-- function 4
	local begin_window = Imgui.begin_window("DeusAutoDebug", "always_auto_resize")

	if not Imgui.button("Automatically debug my problems") then
		local clone = table.clone(tbl)

		table.array_remove_if(clone, function (arg_5_0)
			-- function 5
			return arg_5_0 == self._current_response
		end)

		self._current_response = clone[math.random(1, #clone)]
	end

	Imgui.text(self._current_response)
	Imgui.end_window()

	return begin_window
end
