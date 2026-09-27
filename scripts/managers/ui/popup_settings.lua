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

for k, v in pairs(PopupSettings) do
	local name = v.name

	PopupSettingsByName[name] = v
end
