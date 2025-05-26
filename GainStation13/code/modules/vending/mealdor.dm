/obj/machinery/vending/mealdor
	name = "SnackTron™"
	desc = "The flagship vending product for World Genesis. When you need a snack we've got your back!"
	icon = 'GainStation13/icons/obj/vending.dmi'
	icon_state = "mealdor"
	product_slogans = "You've encountered SnackTron! How fortunate for your hunger and/or thirst!;We've got your back when it comes to snacks!;What time is it? Snack time!"
	vend_reply = "SnackTron hopes you enjoy your selection!"
	free = TRUE
	products = list(

				/obj/item/reagent_containers/food/snacks/fries = 4,
				/obj/item/reagent_containers/food/snacks/donut = 10,
				/obj/item/reagent_containers/food/snacks/burrito = 8,
	            /obj/item/reagent_containers/food/snacks/pizza/margherita = 4,
	            /obj/item/reagent_containers/food/snacks/butterdog = 5,
	            /obj/item/reagent_containers/food/snacks/burger/plain = 5,
	            /obj/item/reagent_containers/food/snacks/pie/plump_pie = 4,
				/obj/item/reagent_containers/food/snacks/store/cake/cheese = 2,
				/obj/item/reagent_containers/food/snacks/store/cake/pumpkinspice = 2,
				/obj/item/reagent_containers/food/snacks/store/cake/pound_cake = 2,
				/obj/item/reagent_containers/food/snacks/cakeslice/bsvc = 3,
				/obj/item/reagent_containers/food/snacks/cakeslice/bscc = 3,
	            /obj/item/reagent_containers/food/drinks/bottle/orangejuice = 10,
	            /obj/item/reagent_containers/food/drinks/bottle/pineapplejuice = 10,
	            /obj/item/reagent_containers/food/drinks/bottle/strawberryjuice = 10,
	            /obj/item/reagent_containers/food/snacks/dough = 10
				)
	contraband = list(
				/obj/item/clothing/head/chefhat = 5,
				/obj/item/reagent_containers/food/snacks/cookie = 10,
				/obj/item/reagent_containers/food/snacks/salad/fruit = 15,
				/obj/item/reagent_containers/food/snacks/blueberry_gum = 5
				)
	premium = list(
				/obj/item/reagent_containers/food/drinks/soda_cans/air = 3,
				/obj/item/reagent_containers/food/snacks/donut/chaos = 3,
				/obj/item/clothing/mask/cowmask/gag = 2,
				/obj/item/clothing/mask/pig/gag = 2
				)

	refill_canister = /obj/item/vending_refill/mealdor
