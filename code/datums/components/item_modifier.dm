/datum/component/item_modifier
    var/list/datum/mutator/active_mutators

/datum/component/item_modifier/Initialize()
    if(!isatom(parent))
        return COMPONENT_INCOMPATIBLE
    
    active_mutators = list()

    //Register mutator events
    RegisterSignal(parent, COMSIG_ITEM_ATTACK_SELF, .proc/UsedInHand)
    RegisterSignal(parent, COMSIG_ITEM_PRE_ATTACK, .proc/PreMeleeAttack) //Works on melee weapons ONLY
    RegisterSignal(parent, COMSIG_ITEM_AFTERATTACK, .proc/AfterAttack)

    //Environmental
    RegisterSignal(parent, COMSIG_ATOM_EMP_ACT, .proc/EmpAct)
    RegisterSignal(parent, COMSIG_ATOM_FIRE_ACT, .proc/FireAct)

    //Gun specific
    RegisterSignal(parent, COMSIG_GUN_CAN_FIRE, .proc/GunCanFire)

///SIGNAL HANDLERS\\\
/datum/component/item_modifier/proc/UsedInHand(mob/user)
    for(var/datum/mutator/M in active_mutators)
        if(!M.UsedInHand(parent, user))
            . = COMPONENT_NO_INTERACT

/datum/component/item_modifier/proc/PreMeleeAttack(atom/target, mob/user, params)
    for(var/datum/mutator/M in active_mutators)
        if(!M.PreMeleeAttack(parent, target, user, params))
            . = COMPONENT_NO_ATTACK

/datum/component/item_modifier/proc/AfterAttack(atom/target, mob/user, params)
    for(var/datum/mutator/M in active_mutators)
        M.AfterAttack(parent, target, user, params)

    //If there's actually ammo in the thing, register the callback for when it hits
    if(istype(parent, obj/item/gun))
        if(parent.chambered && parent.chambered.BB)
            RegisterSignal(parent.chambered.BB, COMSIG_PROJECTILE_HIT, .proc/ProjectileImpact)

/datum/component/item_modifier/proc/EmpAct(severity)
    for(var/datum/mutator/M in active_mutators)
        M.EmpAct(parent, severity)

/datum/component/item_modifier/proc/FireAct(temperature, volume)
    for(var/datum/mutator/M in active_mutators)
        M.FireAct(parent, temperature, volume)

/datum/component/item_modifier/proc/GunCanFire(mob/living/user)
    for(var/datum/mutator/M in active_mutators)
        if(!M.GunCanFire(parent, user)) //Mutators can add additional preconditions for firing
            . = COMPONENT_NO_FIRE

/datum/component/item_modifier/proc/ProjectileImpact(atom/target, blocked)
    for(var/datum/mutator/M in active_mutators)
        if(!M.ProjectileImpact(parent, target, blocked)) //Mutators can completely override the effect of a projectile
            . = COMPONENT_PROJECTILE_NO_EFFECT

///Mutator Creation\\\
/datum/component/item_modifier/proc/AddMutator(datum/mutator/new_mutator)
    active_mutators += new_mutator
    new_mutator.Init(parent)
    




