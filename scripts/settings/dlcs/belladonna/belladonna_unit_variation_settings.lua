-- chunkname: @scripts/settings/dlcs/belladonna/belladonna_unit_variation_settings.lua

local var_0_0 = DLCSettings.belladonna

var_0_0.unit_variation_settings = {
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
var_0_0.unit_variation_settings.beastmen_common_tattoo = table.create_copy(var_0_0.unit_variation_settings.beastmen_common_tattoo, var_0_0.unit_variation_settings.beastmen_common)
var_0_0.unit_variation_settings.beastmen_common_tattoo.material_variations.tattoo = {
	min = 0,
	max = 3,
	materials = {
		"mtr_skin"
	},
	variables = {
		"tattoo_style"
	}
}
var_0_0.unit_variation_settings.beastmen_common_tattoo.material_variations.tattoo_head = {
	min = 0,
	max = 3,
	materials = {
		"mtr_head"
	},
	variables = {
		"tattoo_style"
	}
}
var_0_0.unit_variation_settings.beastmen_common_tattoo.material_variations.tattoo_tint = {
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
var_0_0.unit_variation_settings.beastmen_common_tattoo.materials_enabled_from_start = {
	"skin_tint",
	"horn_tint",
	"cloth_tint",
	"tattoo",
	"tattoo_head",
	"tattoo_tint"
}
var_0_0.unit_variation_settings.beastmen_gor = table.create_copy(var_0_0.unit_variation_settings.beastmen_gor, var_0_0.unit_variation_settings.beastmen_common_tattoo)
var_0_0.unit_variation_settings.beastmen_gor.material_variations.tattoo_tint.min = 0
var_0_0.unit_variation_settings.beastmen_gor.material_variations.tattoo_tint.max = 15
var_0_0.unit_variation_settings.beastmen_ungor = table.create_copy(var_0_0.unit_variation_settings.beastmen_ungor, var_0_0.unit_variation_settings.beastmen_common)
var_0_0.unit_variation_settings.beastmen_ungor.material_variations.skin_tint.materials = {
	"mtr_skin",
	"mtr_fur",
	"mtr_head_00",
	"mtr_head_01",
	"mtr_head_02",
	"mtr_head_03"
}
var_0_0.unit_variation_settings.beastmen_ungor.material_variations.skin_tint.min = 0
var_0_0.unit_variation_settings.beastmen_ungor.material_variations.skin_tint.max = 15
var_0_0.unit_variation_settings.beastmen_ungor.material_variations.cloth_tint.min = 0
var_0_0.unit_variation_settings.beastmen_ungor.material_variations.cloth_tint.max = 15
var_0_0.unit_variation_settings.beastmen_ungor_archer = table.create_copy(var_0_0.unit_variation_settings.beastmen_ungor_archer, var_0_0.unit_variation_settings.beastmen_ungor)
var_0_0.unit_variation_settings.beastmen_ungor_archer.material_variations.skin_tint.min = 16
var_0_0.unit_variation_settings.beastmen_ungor_archer.material_variations.skin_tint.max = 31
var_0_0.unit_variation_settings.beastmen_ungor_archer.material_variations.cloth_tint.min = 16
var_0_0.unit_variation_settings.beastmen_ungor_archer.material_variations.cloth_tint.max = 31
var_0_0.unit_variation_settings.beastmen_ungor_archer.material_variations.tattoo = {
	min = 0,
	max = 3,
	materials = {
		"mtr_skin"
	},
	variables = {
		"tattoo_style"
	}
}
var_0_0.unit_variation_settings.beastmen_ungor_archer.material_variations.tattoo_tint = {
	min = 16,
	max = 31,
	materials = {
		"mtr_skin"
	},
	variables = {
		"tattoo_color_variation"
	}
}
var_0_0.unit_variation_settings.beastmen_ungor_archer.materials_enabled_from_start = {
	"skin_tint",
	"horn_tint",
	"cloth_tint",
	"tattoo",
	"tattoo_tint"
}
var_0_0.unit_variation_settings.beastmen_bestigor = table.create_copy(var_0_0.unit_variation_settings.beastmen_bestigor, var_0_0.unit_variation_settings.beastmen_common_tattoo)
var_0_0.unit_variation_settings.beastmen_bestigor.material_variations.cloth_tint_set_1 = {
	min = 2,
	max = 2,
	materials = {
		"mtr_outfit"
	},
	variables = {
		"tint_color_set_1"
	}
}
var_0_0.unit_variation_settings.beastmen_bestigor.material_variations.fur_tint_set_1 = {
	min = 13,
	max = 13,
	materials = {
		"mtr_fur"
	},
	variables = {
		"tint_color_set_1"
	}
}
var_0_0.unit_variation_settings.beastmen_bestigor.material_variations.skin_tint_set_2 = {
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
var_0_0.unit_variation_settings.beastmen_bestigor.material_variations.tattoo_table = {
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
var_0_0.unit_variation_settings.beastmen_bestigor.materials_enabled_from_start = {
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
var_0_0.unit_variation_settings.beastmen_standard_bearer = table.create_copy(var_0_0.unit_variation_settings.beastmen_standard_bearer, var_0_0.unit_variation_settings.beastmen_bestigor)
var_0_0.unit_variation_settings.beastmen_standard_bearer.material_variations.cloth_tint_set_1.min = 3
var_0_0.unit_variation_settings.beastmen_standard_bearer.material_variations.cloth_tint_set_1.max = 3
var_0_0.unit_variation_settings.beastmen_standard_bearer.material_variations.fur_tint_set_1.min = 7
var_0_0.unit_variation_settings.beastmen_standard_bearer.material_variations.fur_tint_set_1.max = 7
var_0_0.unit_variation_settings.beastmen_standard_bearer.material_variations.skin_tint_set_2.min = 6
var_0_0.unit_variation_settings.beastmen_standard_bearer.material_variations.skin_tint_set_2.max = 6
