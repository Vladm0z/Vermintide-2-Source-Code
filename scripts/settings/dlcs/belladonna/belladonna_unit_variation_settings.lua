-- chunkname: @scripts/settings/dlcs/belladonna/belladonna_unit_variation_settings.lua

local belladonna = DLCSettings.belladonna

belladonna.unit_variation_settings = {
	beastmen_common = {
		materials_enabled_from_start = {
			"skin_tint",
			"horn_tint",
			"cloth_tint"
		},
		material_variations = {
			skin_tint = {
				min = 0,
				max = 31,
				materials = {
					"mtr_skin",
					"mtr_head",
					"mtr_fur"
				},
				variables = {
					"tint_color_variation"
				}
			},
			horn_tint = {
				min = 0,
				max = 31,
				materials = {
					"mtr_horns"
				},
				variables = {
					"tint_color_variation"
				}
			},
			cloth_tint = {
				min = 0,
				max = 31,
				materials = {
					"mtr_outfit"
				},
				variables = {
					"tint_color_variation"
				}
			}
		}
	}
}
belladonna.unit_variation_settings.beastmen_common_tattoo = table.create_copy(belladonna.unit_variation_settings.beastmen_common_tattoo, belladonna.unit_variation_settings.beastmen_common)
belladonna.unit_variation_settings.beastmen_common_tattoo.material_variations.tattoo = {
	min = 0,
	max = 3,
	materials = {
		"mtr_skin"
	},
	variables = {
		"tattoo_style"
	}
}
belladonna.unit_variation_settings.beastmen_common_tattoo.material_variations.tattoo_head = {
	min = 0,
	max = 3,
	materials = {
		"mtr_head"
	},
	variables = {
		"tattoo_style"
	}
}
belladonna.unit_variation_settings.beastmen_common_tattoo.material_variations.tattoo_tint = {
	min = 0,
	max = 31,
	materials = {
		"mtr_skin",
		"mtr_head"
	},
	variables = {
		"tattoo_color_variation"
	}
}
belladonna.unit_variation_settings.beastmen_common_tattoo.materials_enabled_from_start = {
	"skin_tint",
	"horn_tint",
	"cloth_tint",
	"tattoo",
	"tattoo_head",
	"tattoo_tint"
}
belladonna.unit_variation_settings.beastmen_gor = table.create_copy(belladonna.unit_variation_settings.beastmen_gor, belladonna.unit_variation_settings.beastmen_common_tattoo)
belladonna.unit_variation_settings.beastmen_gor.material_variations.tattoo_tint.min = 0
belladonna.unit_variation_settings.beastmen_gor.material_variations.tattoo_tint.max = 15
belladonna.unit_variation_settings.beastmen_ungor = table.create_copy(belladonna.unit_variation_settings.beastmen_ungor, belladonna.unit_variation_settings.beastmen_common)
belladonna.unit_variation_settings.beastmen_ungor.material_variations.skin_tint.materials = {
	"mtr_skin",
	"mtr_fur",
	"mtr_head_00",
	"mtr_head_01",
	"mtr_head_02",
	"mtr_head_03"
}
belladonna.unit_variation_settings.beastmen_ungor.material_variations.skin_tint.min = 0
belladonna.unit_variation_settings.beastmen_ungor.material_variations.skin_tint.max = 15
belladonna.unit_variation_settings.beastmen_ungor.material_variations.cloth_tint.min = 0
belladonna.unit_variation_settings.beastmen_ungor.material_variations.cloth_tint.max = 15
belladonna.unit_variation_settings.beastmen_ungor_archer = table.create_copy(belladonna.unit_variation_settings.beastmen_ungor_archer, belladonna.unit_variation_settings.beastmen_ungor)
belladonna.unit_variation_settings.beastmen_ungor_archer.material_variations.skin_tint.min = 16
belladonna.unit_variation_settings.beastmen_ungor_archer.material_variations.skin_tint.max = 31
belladonna.unit_variation_settings.beastmen_ungor_archer.material_variations.cloth_tint.min = 16
belladonna.unit_variation_settings.beastmen_ungor_archer.material_variations.cloth_tint.max = 31
belladonna.unit_variation_settings.beastmen_ungor_archer.material_variations.tattoo = {
	min = 0,
	max = 3,
	materials = {
		"mtr_skin"
	},
	variables = {
		"tattoo_style"
	}
}
belladonna.unit_variation_settings.beastmen_ungor_archer.material_variations.tattoo_tint = {
	min = 16,
	max = 31,
	materials = {
		"mtr_skin"
	},
	variables = {
		"tattoo_color_variation"
	}
}
belladonna.unit_variation_settings.beastmen_ungor_archer.materials_enabled_from_start = {
	"skin_tint",
	"horn_tint",
	"cloth_tint",
	"tattoo",
	"tattoo_tint"
}
belladonna.unit_variation_settings.beastmen_bestigor = table.create_copy(belladonna.unit_variation_settings.beastmen_bestigor, belladonna.unit_variation_settings.beastmen_common_tattoo)
belladonna.unit_variation_settings.beastmen_bestigor.material_variations.cloth_tint_set_1 = {
	min = 2,
	max = 2,
	materials = {
		"mtr_outfit"
	},
	variables = {
		"tint_color_set_1"
	}
}
belladonna.unit_variation_settings.beastmen_bestigor.material_variations.fur_tint_set_1 = {
	min = 13,
	max = 13,
	materials = {
		"mtr_fur"
	},
	variables = {
		"tint_color_set_1"
	}
}
belladonna.unit_variation_settings.beastmen_bestigor.material_variations.skin_tint_set_2 = {
	min = 12,
	max = 12,
	materials = {
		"mtr_skin",
		"mtr_head"
	},
	variables = {
		"tint_color_set_2"
	}
}
belladonna.unit_variation_settings.beastmen_bestigor.material_variations.tattoo_table = {
	min = 4,
	max = 4,
	materials = {
		"mtr_skin",
		"mtr_head"
	},
	variables = {
		"tattoo_color_set"
	}
}
belladonna.unit_variation_settings.beastmen_bestigor.materials_enabled_from_start = {
	"skin_tint",
	"horn_tint",
	"cloth_tint",
	"tattoo",
	"tattoo_head",
	"tattoo_tint",
	"tattoo_table",
	"cloth_tint_set_1",
	"fur_tint_set_1",
	"skin_tint_set_2"
}
belladonna.unit_variation_settings.beastmen_standard_bearer = table.create_copy(belladonna.unit_variation_settings.beastmen_standard_bearer, belladonna.unit_variation_settings.beastmen_bestigor)
belladonna.unit_variation_settings.beastmen_standard_bearer.material_variations.cloth_tint_set_1.min = 3
belladonna.unit_variation_settings.beastmen_standard_bearer.material_variations.cloth_tint_set_1.max = 3
belladonna.unit_variation_settings.beastmen_standard_bearer.material_variations.fur_tint_set_1.min = 7
belladonna.unit_variation_settings.beastmen_standard_bearer.material_variations.fur_tint_set_1.max = 7
belladonna.unit_variation_settings.beastmen_standard_bearer.material_variations.skin_tint_set_2.min = 6
belladonna.unit_variation_settings.beastmen_standard_bearer.material_variations.skin_tint_set_2.max = 6
