/datum/material/gainium
	name = "gainium"
	sheet_type = /obj/item/stack/sheet/mineral/gainium
	color = list(340/255, 150/255, 50/255,0, 0,0,0,0, 0,0,0,0, 0,0,0,1, 0,0,0,0)
	strength_modifier = 1.5
	categories = list(MAT_CATEGORY_ORE = TRUE, MAT_CATEGORY_RIGID = TRUE, MAT_CATEGORY_BASE_RECIPES = TRUE)
	beauty_modifier = 0.05
	armor_modifiers = list(MELEE = 1.1, BULLET = 1.1, LASER = 1.15, ENERGY = 1.15, BOMB = 1, BIO = 1, RAD = 1, FIRE = 0.7, ACID = 1.1) // Same armor as gold.

/datum/material/gainium/on_applied_obj(obj/source, amount, material_flags)
	. = ..()
	if(!(material_flags & MATERIAL_AFFECT_STATISTICS))
		return

	var/obj/source_obj = source
	source_obj.damtype = FAT

/datum/material/gainium/on_removed_obj(obj/source, material_flags)
	if(!(material_flags & MATERIAL_AFFECT_STATISTICS))
		return ..()

	var/obj/source_obj = source
	source_obj.damtype = initial(source_obj.damtype)
	return ..()


/turf/closed/mineral/gainium //GS13
	mineralType = /obj/item/stack/ore/gainium
	scan_state = "rock_Gainium"

/obj/item/stack/ore/gainium //GS13
	name = "gainium ore"
	icon = 'GainStation13/icons/obj/mining.dmi'
	icon_state = "gainium ore"
	item_state = "gainium ore"
	singular_name = "gainium ore chunk"
	points = 40
	custom_materials = list(/datum/material/gainium=MINERAL_MATERIAL_AMOUNT)
	refined_type = /obj/item/stack/sheet/mineral/gainium
	mine_experience = 20

/obj/item/stack/sheet/mineral/gainium
	name = "gainium"
	icon = 'GainStation13/icons/obj/stack_objects.dmi'
	icon_state = "sheet-gainium"
	item_state = "sheet-gainium"
	singular_name = "gainium sheet"
	sheettype = "gainium"
	novariants = TRUE
	grind_results = list(/datum/reagent/consumable/lipoifier = 2)
	point_value = 40
	custom_materials = list(/datum/material/gainium=MINERAL_MATERIAL_AMOUNT)
	merge_type = /obj/item/stack/sheet/mineral/gainium
	material_type = /datum/material/gainium
	walltype = /turf/closed/wall/mineral/gainium

GLOBAL_LIST_INIT(gainium_recipes, list ( \
	new/datum/stack_recipe("gainium tile", /obj/item/stack/tile/mineral/gainium, 1, 4, 20), \
	new/datum/stack_recipe("gainium Ingots", /obj/item/ingot/gainium, time = 30), \
	new/datum/stack_recipe("Fatty statue", /obj/structure/statue/gainium/fatty, 5, one_per_turf = 1, on_floor = 1),\
	new/datum/stack_recipe("gainium doors", /obj/structure/mineral_door/gainium, 5, one_per_turf = 1, on_floor = 1),\
	))

/obj/item/stack/sheet/mineral/gainium/get_main_recipes()
	. = ..()
	. += GLOB.gainium_recipes

/obj/item/stack/sheet/mineral/gainium/attack(mob/living/carbon/M, mob/living/carbon/user) //WG13 Edible Gainium
	to_chat(user, "<span class='notice'>You crunch down on the gainium shard. It tastes like rock candy!</span>")
	playsound(user, 'sound/items/eatfood.ogg', 60, 1)
	qdel(src)


/obj/item/stack/tile/mineral/gainium  //GS13
	name = "gainium tile"
	singular_name = "gainium floor tile"
	desc = "A tile made out of gainium. Bwoomph."
	icon = 'GainStation13/icons/obj/tiles.dmi'
	icon_state = "tile_gainium"
	turf_type = /turf/open/floor/mineral/gainium
	mineralType = "gainium"

/obj/item/stack/tile/mineral/gainium/hide  //GS13 - disguised variant
	name = "Floor tile"
	singular_name = "gainium floor tile"
	desc = "A tile totally made out of steel."
	icon_state = "tile"
	turf_type = /turf/open/floor/mineral/gainium/hide

/obj/item/stack/tile/mineral/gainium/strong  //GS13 - strong variant
	name = "Infused gainium tile"
	singular_name = "Infused gainium floor tile"
	desc = "A tile made out of stronger variant of gainium. Bwuurp."
	icon_state = "tile_gainium_strong"
	turf_type = /turf/open/floor/mineral/gainium/strong

/obj/item/stack/tile/mineral/gainium/dance  //GS13 - glamourous variant!
	name = "gainium dance floor"
	singular_name = "gainium dance floor tile"
	desc = "A dance floor made out of gainium, for a party both you and your waistline will never forget!."
	icon_state = "tile_gainium_dance"
	turf_type = /turf/open/floor/mineral/gainium/dance


/turf/open/floor/mineral/gainium
	name = "gainium floor"
	icon = 'GainStation13/icons/turf/floors.dmi'
	icon_state = "gainium"
	floor_tile = /obj/item/stack/tile/mineral/gainium
	icons = list("gainium","gainium_dam")
	var/last_event = 0
	var/active = null
	///How much fatness is added to the user upon crossing?
	var/fat_to_add = 25

/turf/open/floor/mineral/gainium/Entered(mob/living/carbon/M)
	if(!istype(M, /mob/living/carbon))
		return FALSE
	else
		M.adjust_fatness(fat_to_add, FATTENING_TYPE_ITEM)

// gainium floor, disguised version - GS13

/turf/open/floor/mineral/gainium/hide
	name = "Steel floor"
	icon_state = "gainium_hide"
	floor_tile = /obj/item/stack/tile/mineral/gainium/hide
	icons = list("gainium_hide","gainium_dam")

// gainium floor, powerful version - GS13

/turf/open/floor/mineral/gainium/strong
	name = "Infused gainium floor"
	icon_state = "gainium_strong"
	floor_tile = /obj/item/stack/tile/mineral/gainium/strong
	icons = list("gainium_strong","gainium_dam")
	fat_to_add = 100

// gainium dance floor, groovy! - GS13

/turf/open/floor/mineral/gainium/dance
	name = "gainium dance floor"
	icon_state = "gainium_dance"
	floor_tile = /obj/item/stack/tile/mineral/gainium/dance
	icons = list("gainium_dance","gainium_dam")


/obj/structure/statue/gainium
	icon = 'GainStation13/icons/obj/statue.dmi'
	max_integrity = 400
	custom_materials = list(/datum/material/gainium=MINERAL_MATERIAL_AMOUNT*5)

/obj/structure/statue/gainium/fatty
	name = "Fatty statue"
	desc = "A statue of a well-rounded fatso."
	icon_state = "fatty"
	var/active = null
	var/last_event = 0

/obj/structure/statue/gainium/fatty/proc/beckon()
	if(!active)
		if(world.time > last_event+15)
			active = 1
			for(var/mob/living/carbon/human/M in orange(3,src))
				to_chat(M, "<span class='warning'>You feel the statue calling to you, urging you to touch it...</span>")
			last_event = world.time
			active = null
			return
	return

/obj/structure/statue/gainium/fatty/proc/statue_fatten(mob/living/carbon/M)
	if(!M.adjust_fatness(20, FATTENING_TYPE_ITEM))
		to_chat(M, "<span class='warning'>Nothing happens.</span>")
		return

	if(M.fatness < FATNESS_LEVEL_2)
		to_chat(M, "<span class='warning'>The moment your hand meets the statue, you feel a little warmer...</span>")
	else if(M.fatness < FATNESS_LEVEL_4)
		to_chat(M, "<span class='warning'>Upon each poke of the statue, you feel yourself get a little heavier.</span>")
	else if(M.fatness < FATNESS_LEVEL_6)
		to_chat(M, "<span class='warning'>With each touch you keep getting fatter... But the fatter you grow, the more enticed you feel to poke the statue.</span>")
	else if(M.fatness < FATNESS_LEVEL_7)
		to_chat(M, "<span class='warning'>The world around you blur slightly as you focus on prodding the statue, your waistline widening further...</span>")
	else if(M.fatness < FATNESS_LEVEL_8)
		to_chat(M, "<span class='warning'>A whispering voice gently compliments your massive body, your own mind begging to touch the statue.</span>")
	else
		to_chat(M, "<span class='warning'>You can barely reach the statue past your floor-covering stomach! And yet, it still calls to you...</span>")

/obj/structure/statue/gainium/fatty/Bumped(atom/movable/AM)
	beckon()
	..()

/obj/structure/statue/gainium/fatty/Crossed(var/mob/AM)
	.=..()
	if(!.)
		if(istype(AM))
			beckon()

/obj/structure/statue/gainium/fatty/Moved(atom/movable/AM)
	beckon()
	..()

/obj/structure/statue/gainium/fatty/attackby(obj/item/W, mob/living/carbon/M, params)
	statue_fatten(M)

/obj/structure/statue/gainium/fatty/attack_hand(mob/living/carbon/M)
	statue_fatten(M)

/obj/structure/statue/gainium/fatty/attack_paw(mob/living/carbon/M)
	statue_fatten(M)


/turf/closed/wall/mineral/gainium //GS13
	name = "gainium wall"
	desc = "A wall with gainium plating. Burp."
	icon = 'GainStation13/icons/turf/gainium_wall.dmi'
	icon_state = "gainium"
	sheet_type = /obj/item/stack/sheet/mineral/gainium
	canSmoothWith = list(/turf/closed/wall/mineral/gainium, /obj/structure/falsewall/gainium)

/turf/closed/wall/mineral/gainium/proc/fatten()
	if(!active)
		if(world.time > last_event+15)
			active = 1
			for(var/mob/living/carbon/human/M in orange(3,src))
				M.adjust_fatness(30, FATTENING_TYPE_ITEM)
			last_event = world.time
			active = null
			return
	return

/turf/closed/wall/mineral/gainium/Bumped(atom/movable/AM)
	fatten()
	..()

/turf/closed/wall/mineral/gainium/attackby(obj/item/W, mob/user, params)
	fatten()
	return ..()

/turf/closed/wall/mineral/gainium/attack_hand(mob/user)
	fatten()
	. = ..()

/obj/structure/falsewall/gainium            //GS13
	name = "gainium wall"
	desc = "A wall with gainium plating. Burp."
	icon = 'GainStation13/icons/turf/gainium_wall.dmi'
	icon_state = "gainium"
	mineral = /obj/item/stack/sheet/mineral/gainium
	walltype = /turf/closed/wall/mineral/gainium
	canSmoothWith = list(/obj/structure/falsewall/gainium, /turf/closed/wall/mineral/gainium)
	var/active = null
	var/last_event = 0

/obj/structure/falsewall/gainium/proc/fatten()
	if(!active)
		if(world.time > last_event+15)
			active = 1
			for(var/mob/living/carbon/human/M in orange(3,src))
				M.adjust_fatness(30, FATTENING_TYPE_ITEM)
			last_event = world.time
			active = null
			return
	return

/obj/structure/falsewall/gainium/Bumped(atom/movable/AM)
	fatten()
	..()

/obj/structure/falsewall/gainium/attackby(obj/item/W, mob/user, params)
	fatten()
	return ..()

/obj/structure/falsewall/gainium/attack_hand(mob/user)
	fatten()
	. = ..()

/obj/item/ingot/gainium
	custom_materials = list(/datum/material/gainium=1500)
