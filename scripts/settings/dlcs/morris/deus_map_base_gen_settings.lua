-- chunkname: @scripts/settings/dlcs/morris/deus_map_base_gen_settings.lua

DEUS_BASE_MAP_GEN_SETTINGS = not not DEUS_BASE_MAP_GEN_SETTINGS
DEUS_BASE_MAP_GEN_SETTINGS.journey_cave = table.clone(DEUS_BASE_MAP_GEN_SETTINGS.default)
DEUS_BASE_MAP_GEN_SETTINGS.journey_ice = table.clone(DEUS_BASE_MAP_GEN_SETTINGS.default)
DEUS_BASE_MAP_GEN_SETTINGS.journey_citadel = table.clone(DEUS_BASE_MAP_GEN_SETTINGS.default)
DEUS_BASE_MAP_GEN_SETTINGS.journey_citadel.MAX_STRAIGHT_LINE = 2
DEUS_BASE_MAP_GEN_SETTINGS.journey_citadel.MIN_NODES = 9
DEUS_BASE_MAP_GEN_SETTINGS.journey_citadel.FINAL_NODE_VALIDATIONS = {
	"end_with_arena",
	"only_one_signature_level_required_before_final_level",
	"check_minimum_nodes"
}

for name, settings in pairs(DEUS_BASE_MAP_GEN_SETTINGS) do
	settings.name = name
end
