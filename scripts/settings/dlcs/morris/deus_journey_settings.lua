-- chunkname: @scripts/settings/dlcs/morris/deus_journey_settings.lua

AvailableJourneyOrder = {
	"journey_ruin",
	"journey_cave",
	"journey_ice",
	"journey_citadel"
}
DeusJourneyCycleGods = DeusJourneyCycleGods
DeusJourneySettings = DeusJourneySettings
DeusJourneySettings.default = table.clone(DeusJourneySettings.journey_ruin)
DeusJourneySettings.default.default = true
