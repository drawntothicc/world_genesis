/datum/crafting_recipe/gainiumdancefloor
	name = "gainium dance floor"
	result = /obj/item/stack/tile/mineral/gainium/dance
	reqs = list(/obj/item/stack/cable_coil = 3, /obj/item/stack/tile/mineral/gainium = 1)
	subcategory = CAT_MISCELLANEOUS
	category = CAT_MISCELLANEOUS

/datum/crafting_recipe/nutribot
	name = "Nutribot"
	reqs = list(/obj/item/stack/sheet/cardboard = 1,
				/obj/item/stack/sheet/mineral/gainium = 1,
				/obj/item/bodypart/r_arm/robot = 1,
				/obj/item/assembly/prox_sensor = 1)
	result = /mob/living/simple_animal/bot/nutribot
	category = CAT_ROBOT
