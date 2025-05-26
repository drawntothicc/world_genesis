/obj/machinery/vending/gato
	name = "The Fizzler™"
	desc = "Your one shop stop for all sorts of caffeinated comfort, the Fizzler!"
	icon = 'GainStation13/icons/obj/vending.dmi'
	icon_state = "cola_black"
	product_slogans = "Gyatt Fizz?;It's called aura son.;The fizz with the rizz!"
	vend_reply = "Thanks for sticking your gyatt out for the Fizzler!;Have a great skibiday!"
	products = list(
	            /obj/item/reagent_containers/food/drinks/soda_cans/cola = 10,
	            /obj/item/reagent_containers/food/drinks/soda_cans/dr_gibb = 10,
				/obj/item/reagent_containers/food/drinks/soda_cans/starkist = 10,
				/obj/item/reagent_containers/food/drinks/soda_cans/space_up = 10,
				/obj/item/reagent_containers/food/drinks/soda_cans/pwr_game = 10,
				/obj/item/reagent_containers/food/drinks/bigbottle/starkist = 6,
				/obj/item/reagent_containers/food/drinks/bigbottle/cola = 6,
				/obj/item/reagent_containers/food/drinks/bigbottle/spaceup = 6,
				/obj/item/reagent_containers/food/drinks/bigbottle/fizz = 3,
				)
	contraband = list(
				/obj/item/organ/ears/cat = 2,
				)
	premium = list(
				/obj/item/reagent_containers/food/drinks/soda_cans/air = 20,
				/obj/item/reagent_containers/food/drinks/soda_cans/fizzwiz = 5,
				/obj/item/reagent_containers/food/drinks/soda_cans/soothseltz = 8,
				)

	refill_canister = /obj/item/vending_refill/mealdor

/obj/item/vending_refill/mealdor
	machine_name = "Meal Vendor Refill"
	icon = 'GainStation13/icons/obj/vending_restock.dmi'
	icon_state = "refill_mealdor"

/obj/machinery/vending
	/// Are the products inside free?
	var/free = FALSE
