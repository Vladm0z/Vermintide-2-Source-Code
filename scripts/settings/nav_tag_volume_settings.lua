-- chunkname: @scripts/settings/nav_tag_volume_settings.lua

require("scripts/settings/volume_settings")

NavTagVolumeStartLayer = 20
NavTagVolumeLayers = {
	"20",
	"21",
	"22",
	"23",
	"24",
	"25",
	"26",
	"27",
	"28",
	"29",
	"30",
	"31",
	"32",
	"33",
	"34",
	"35",
	"36",
	"37",
	"38",
	"39",
	"ROOF",
	"NO_SPAWN",
	"LOW_SPAWN",
	"HIGH_SPAWN",
	"NO_BOSS",
	"NO_BOTS",
	"NO_BOTS_NO_SPAWN",
	"nav_tag_volume_dummy_layer1",
	"nav_tag_volume_dummy_layer2",
	"nav_tag_volume_dummy_layer3",
	"nav_tag_volume_dummy_layer4",
	"nav_tag_volume_dummy_layer5",
	"nav_tag_volume_dummy_layer6",
	"nav_tag_volume_dummy_layer7",
	"nav_tag_volume_dummy_layer8"
}
LevelVolumesOnly = {
	HIGH_SPAWN = true,
	ROOF = true,
	NO_BOTS = true,
	NO_SPAWN = true,
	LOW_SPAWN = true,
	NO_BOSS = true,
	NO_BOTS_NO_SPAWN = true
}

local tbl = {}

for k, v in pairs(VolumeSystemSettings.nav_tag_layer_costs) do
	for k_2, v_2 in pairs(v) do
		local str = k .. "_" .. k_2

		if not tbl[str] then
			NavTagVolumeLayers[#NavTagVolumeLayers + 1] = str
			tbl[str] = true
		end
	end
end
