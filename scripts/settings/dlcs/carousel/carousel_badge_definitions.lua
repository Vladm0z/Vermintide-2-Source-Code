-- chunkname: @scripts/settings/dlcs/carousel/carousel_badge_definitions.lua

local BadgeDefinitions = BadgeDefinitions

BadgeDefinitions = not not BadgeDefinitions or not not {}
BadgeDefinitions = BadgeDefinitions

local function random_badge()
	-- function 1
	return string.format("badge_generic_%02d", math.random(7))
end

local function random_color()
	-- function 2
	return {
		255,
		math.random(255),
		math.random(255),
		math.random(255)
	}
end

BadgeDefinitions.kill_hero = {
	text = "vs_kill_notification_elimination",
	texture_id = "badge_generic_01",
	bg_color = {
		255,
		139,
		0,
		0
	},
	victim_text_color = {
		255,
		139,
		0,
		0
	}
}
BadgeDefinitions.knock_down_hero = {
	text = "vs_kill_notification_knockdown",
	texture_id = "badge_generic_02",
	bg_color = {
		255,
		173,
		133,
		0
	},
	victim_text_color = {
		255,
		139,
		0,
		0
	}
}
BadgeDefinitions.kill_pactsworn = {
	text = "vs_kill_notification_elimination",
	texture_id = "badge_generic_01",
	bg_color = {
		255,
		139,
		0,
		0
	},
	victim_text_color = {
		255,
		139,
		0,
		0
	}
}
