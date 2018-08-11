///STATIC BUFFS\\\
//These change the nature of the affected item when initialized.

//Reduces item weight class by one and damage by 2 to a minimum of zero
/datum/mutator/buff/lightweight
    name = "Compact Frame"
    desc = "A compact carbon-fiber frame makes this item lighter, but slightly reduces melee damage."
    frequency = MUTATOR_FREQUENCY_COMMON
    reveal_prob = MUTATOR_REVEAL_USUALLY
    var/weight_reduction = 1
    var/force_penalty = 2

//Not valid for anything that's already tiny
/datum/mutator/buff/lightweight/IsValid(parent)
    var/obj/item/I = parent
    return istype(parent) && (parent.w_class >= (WEIGHT_CLASS_TINY + weight_reduction))

/datum/mutator/buff/lightweight/Init(parent)
    var/obj/item/I = parent
    I.w_class = max(I.w_class - weight_reduction, WEIGHT_CLASS_TINY)
    I.force = max(I.force - force_penalty, 0)

//Rare upgraded weight reduction with more size reduction and no force penalty
/datum/mutator/buff/lightweight/ultralight
    name = "Hyperspatial Frame"
    desc = "This item uses bluespace folding technology to shrink far smaller than previously thought possible."
    frequency = MUTATOR_FREQUENCY_RARE
    weight_reduction = 2
    force_penalty = 0

//Increases item melee damage by 8
/datum/mutator/buff/robust
    name = "Weighted Frame"
    desc = "This item has been modified to be unusually robust in melee combat."
    frequency = MUTATOR_FREQUENCY_COMMON
    reveal_prob = MUTATOR_REVEAL_USUALLY
    subtype_blacklist = list(/obj/item/twohanded/dualsaber, /obj/item/melee/transforming/energy/sword)
    var/force_increase = 8

/datum/mutator/buff/robust/Init(parent)
    var/obj/item/I = parent
    I.force = min(I.force + force_increase, I.force * 2)

//Rare upgraded melee damage buff 
/datum/mutator/buff/robust/super
    name = "Graviton Frame"
    desc = "This item manipulates gravity to become far more effective in melee combat."
    frequency = MUTATOR_FREQUENCY_RARE
    force_increase = 14

//Double internal cell capacity
/datum/mutator/buff/super_cell
    name = "Advanced Battery"
    desc = "This item's internal power cell has been upgraded to twice its normal capacity."
    frequency = MUTATOR_FREQUENCY_COMMON
    reveal_prob = MUTATOR_REVEAL_USUALLY
    var/power_multiplier = 2

//Not valid for anything that doesn't have a power cell
/datum/mutator/buff/super_cell/IsValid(parent)
    var/obj/item/I = parent
    return istype(parent) && parent.get_cell()

/datum/mutator/buff/super_cell/Init(parent)
    var/obj/item/I = parent
    var/obj/item/stock_parts/cell/I_cell = parent.get_cell()
    if(I_cell)
        I_cell.maxcharge *= power_multiplier
        I_cell.charge = I_cell.maxcharge

//Quintuple internal cell capacity
/datum/mutator/buff/super_cell/ultra
    name = "Bluespace Battery"
    desc = "The wonders of bluespace tech have quintupled the size of this item's internal power cell."
    power_multiplier = 5
