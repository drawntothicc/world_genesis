/obj/machinery/door
	var/fatness_to_check = 0

	var/check_fatness = FALSE
	var/check_fatness_below = FALSE

/obj/machinery/door/proc/change_fatness_to_check(mob/user)
	var/fatness_type = input(usr,
		"What level of fatness do you wish to alert above/under at?",
		src, "None") as null|anything in list(
		"None", "Fat", "Fatter", "Very Fat", "Obese", "Morbidly Obese", "Extremely Obese", "Barely Mobile", "Immobile", "Blob")
	if(!fatness_type)
		return	FALSE

	var/fatness_amount = 0
	switch(fatness_type)
		if("Fat")
			fatness_amount = FATNESS_LEVEL_1
		if("Fatter")
			fatness_amount = FATNESS_LEVEL_2
		if("Very Fat")
			fatness_amount = FATNESS_LEVEL_3
		if("Obese")
			fatness_amount = FATNESS_LEVEL_4
		if("Morbidly Obese")
			fatness_amount = FATNESS_LEVEL_5
		if("Extremely Obese")
			fatness_amount = FATNESS_LEVEL_6
		if("Barely Mobile")
			fatness_amount = FATNESS_LEVEL_7
		if("Immobile")
			fatness_amount = FATNESS_LEVEL_8
		if("Blob")
			fatness_amount = FATNESS_LEVEL_9

	fatness_to_check = fatness_amount
	return TRUE
