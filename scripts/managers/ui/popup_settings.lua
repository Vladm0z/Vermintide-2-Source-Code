-- chunkname: @scripts/managers/ui/popup_settings.lua

PopupSettings = {
	{
		singleton = true,
		name = "profile_picker",
		class = "PopupProfilePicker",
		file = "scripts/ui/views/popup_profile_picker"
	}
}
PopupSettingsByName = {}

for iter_0_0, iter_0_1 in pairs(PopupSettings) do
	local var_0_0 = iter_0_1.name

	PopupSettingsByName[var_0_0] = iter_0_1
end
