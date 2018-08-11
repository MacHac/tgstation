//General Debuffs
//Debuffs that can be applied to any item equally

///EMP-RELATED DEBUFFS\\\
//EMPs are really good for screwing up experimental tech

//If this device is hit by an EMP, it stops working for a while.
/datum/mutator/debuff/emp_fail
    name = "Fragile Power Core"
    desc = "This item appears to have an improperly-shielded power core.  It will deactivate briefly if hit with any sort of EMP."
    frequency = MUTATOR_FREQUENCY_COMMON
    reveal_prob = MUTATOR_REVEAL_SOMETIMES
    var/working = TRUE //Is this device working?
    var/reboot = TRUE //Does this device eventually reboot?
    var/reboot_delay = 100 //How long does this device take to reboot?

/datum/mutator/debuff/emp_fail/EmpAct(parent, severity)
    working = FALSE
    parent.visible_message("<span class='danger'>The [parent] sparks and fizzes, then falls dark.</span>")
    if(reboot)
        addtimer(CALLBACK(src, .proc/BringOnline), reboot_delay)
        reboot_delay += 30

/datum/mutator/debuff/emp_fail/proc/BringOnline()
    if(!working)
        working = TRUE
        parent.visible_message("<span class='notice'>The [parent] chimes briefly.</span>")

/datum/mutator/debuff/emp_fail/GunCanFire(parent, mob/living/user)
    if(!working)
        parent.visible_message("<span class='warning'>The [parent] emits a low buzz.</span>")
    return working

/datum/mutator/debuff/emp_fail/UsedInHand(parent, mob/user)
    if(!working)
        parent.visible_message("<span class='warning'>The [parent] emits a low buzz.</span>")
    return working

//Rare severe version of fragile core: One hit from an EMP will disable it permanently.
/datum/mutator/debuff/emp_fail/severe
    name = "Very Fragile Power Core"
    desc = "This item appears to have an unshielded power core.  It will deactivate permanently if hit with any sort of EMP."
    frequency = MUTATOR_FREQUENCY_RARE
    reveal_prob = MUTATOR_REVEAL_ALWAYS
    reboot = FALSE

//Highly unstable
/datum/mutator/debuff/emp_explode
    name = "Strained Power Core"
    desc = "This device's power core is pushed to its limits.  It has a chance to explode shortly after being EMPed."
    frequency = MUTATOR_FREQUENCY_COMMON
    reveal_prob = MUTATOR_REVEAL_ALWAYS
    var/detonation_frequency = 10
    var/detonation_delay = 60

/datum/mutator/debuff/emp_explode/EmpAct(parent, severity)
    if(prob(detonation_frequency))
        parent.visible_message("<span class='danger'>The [parent] sparks and fizzes violently!  It's going to blow!</span>")
        addtimer(CALLBACK(src, .proc/Detonate), detonation_delay)

/datum/mutator/debuff/emp_explode/proc/Detonate()
    explosion(parent, -1, -1, 2, 3) //Same strength as PDA explosion (not lethal, but a KO if you get caught holding it)

//Rare severe version of strained core with 100% detonation chance
/datum/mutator/debuff/emp_explode/severe
    name = "Overloaded Power Core"
    desc = "This device's power core is on the brink of exploding.  A single EMP will push it over the edge."
    frequency = MUTATOR_FREQUENCY_RARE
    reveal_prob = MUTATOR_REVEAL_ALWAYS
    detonation_frequency = 100

///RADIATION\\\
/datum/mutator/debuff/radioactive
    name = "Radioactive Emissions"
    desc = "This device is known to release small amounts of radiation when used.  Avoid prolonged exposure."
    frequency = MUTATOR_FREQUENCY_COMMON
    reveal_prob = MUTATOR_REVEAL_SOMETIMES
    var/rads = 50

//The detective can track you down with a geiger counter
/datum/mutator/debuff/radioactive/proc/Irradiate(item)
    radiation_pulse(get_turf(item), rads)
    if(prob(25) || rads > 100)
        item.visible_message("<span class='warning'>The air around [item] ")

/datum/mutator/debuff/radioactive/UsedInHand(parent, mob/user)
    Irradiate(parent)
    return TRUE

/datum/mutator/debuff/radioactive/AfterAttack(parent, atom/target, mob/user, params)
    Irradiate(parent)
    return TRUE

/datum/mutator/debuff/radioactive/severe
    name = "Thermonuclear Core"
    desc = "This device releases large amounts of lethal radiation when used.  Don protective equipment before use."
    frequency = MUTATOR_FREQUENCY_RARE
    reveal_prob = MUTATOR_REVEAL_ALWAYS
    rads = 800 //Hope you found a radsuit.

//Yellow gloves bypass this completely.
/datum/mutator/debuff/shocking
    name = "Exposed Wires"
    desc = "This device is incomplete and covered in exposed wires, liable to shock its user."
    frequency = MUTATOR_FREQUENCY_COMMON
    reveal_prob = MUTATOR_REVEAL_USUALLY
    var/shock_chance = 25 //Common enough to be a factor, but allow emergency unprotected use

/datum/mutator/debuff/shocking/proc/Shock(parent, mob/user)
    if(prob(shock_chance))
        user.visible_message("<span class='danger'>The [parent] sparks violently!</span>", 
                            "<span class='userdanger'>The [parent] sparks and shocks you!</span>",
                            "<span class='warning'>You hear crackling.</span>")
        var/obj/item/stock_parts/cell/cell = parent.get_cell()
        if(cell && istype(cell))
            electrocute_mob(user, cell, parent)
            return
        electrocute_mob(user, get_area(user), parent) //Just use the local APC as a power source

/datum/mutator/debuff/shocking/UsedInHand(parent, mob/user)
    Shock(parent, user)
    return TRUE

/datum/mutator/debuff/shocking/AfterAttack(parent, atom/target, mob/user, params)
    Shock(parent, user)
    return TRUE

/datum/mutator/debuff/shocking/always
    name = "Conductive Casing"
    desc = "This device has a conductive metal casing, and will shock anyone who tries to use it without insulated gloves."
    requency = MUTATOR_FREQUENCY_RARE
    var/shock_chance = 100
