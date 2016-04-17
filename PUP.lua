include('organizer-lib.lua')
-------------------------------------------------------------------------------------------------------------------
-- Setup functions for this job.  Generally should not be modified.
-------------------------------------------------------------------------------------------------------------------

-- Initialization function for this job file.
function get_sets()
    mote_include_version = 2

    -- Load and initialize the include file.
    include('Mote-Include.lua')
end


-- Setup vars that are user-independent.  state.Buff vars initialized here will automatically be tracked.
function job_setup()
    -- List of pet weaponskills to check for
    petWeaponskills = S{"Slapstick", "Knockout", "Magic Mortar",
        "Chimera Ripper", "String Clipper",  "Cannibal Blade", "Bone Crusher", "String Shredder",
        "Arcuballista", "Daze", "Armor Piercer", "Armor Shatterer"}
    
    -- Map automaton heads to combat roles
    petModes = {
        ['Harlequin Head'] = 'Melee',
        ['Sharpshot Head'] = 'Ranged',
        ['Valoredge Head'] = 'Tank',
        ['Stormwaker Head'] = 'Magic',
        ['Soulsoother Head'] = 'Heal',
        ['Spiritreaver Head'] = 'Nuke'
        }

    -- Subset of modes that use magic
    magicPetModes = S{'Nuke','Heal','Magic'}
    
    -- Var to track the current pet mode.
    state.PetMode = M{['description']='Pet Mode', 'None', 'Melee', 'Ranged', 'Tank', 'Magic', 'Heal', 'Nuke'}
	state.WeaponMode = M{['description']='Weapon Mode', 'H2H'}
	state.Stance = M{['description']='Stance', 'Off', 'None', 'Offensive', 'Defensive'}
 
	get_combat_form()
	pick_tp_weapon()
end

-------------------------------------------------------------------------------------------------------------------
-- User setup functions for this job.  Recommend that these be overridden in a sidecar file.
-------------------------------------------------------------------------------------------------------------------

-- Setup vars that are user-dependent.  Can override this function in a sidecar file.
function user_setup()
	state.OffenseMode:options('Normal', 'Acc', 'Att', 'Crit', 'DA', 'Haste', 'Skill', 'sTP', 'STR')
	state.WeaponskillMode:options('Normal', 'Acc', 'Mod')
	state.DefenseMode:options('None', 'Physical', 'Magical')
	state.PhysicalDefenseMode:options('PDT', 'Evasion')
	state.MagicalDefenseMode:options('MDT')
	state.WeaponMode:set('H2H')
	state.Stance:set('Offensive')
	flag.sekka = true
	flag.med = true
	flag.berserk = true
	flag.defender = true
	flag.aggressor = true
	flag.warcry = true
	flag.thirdeye = true

	pick_tp_weapon()

    -- Default maneuvers 1, 2, 3 and 4 for each pet mode.
    defaultManeuvers = {
        ['Melee'] = {'Fire Maneuver', 'Thunder Maneuver', 'Wind Maneuver', 'Light Maneuver'},
        ['Ranged'] = {'Wind Maneuver', 'Fire Maneuver', 'Thunder Maneuver', 'Light Maneuver'},
        ['Tank'] = {'Earth Maneuver', 'Dark Maneuver', 'Light Maneuver', 'Wind Maneuver'},
        ['Magic'] = {'Ice Maneuver', 'Light Maneuver', 'Dark Maneuver', 'Earth Maneuver'},
        ['Heal'] = {'Light Maneuver', 'Dark Maneuver', 'Water Maneuver', 'Earth Maneuver'},
        ['Nuke'] = {'Ice Maneuver', 'Dark Maneuver', 'Light Maneuver', 'Earth Maneuver'}
    }

    update_pet_mode()
    select_default_macro_book()
end


-- Define sets used by this job file.
function init_gear_sets()
	organizer_items = {
		echos="Echo Drops",
		food="Squid Sushi",
		test="Pup. Testimony",
		med1="Hi-Potion +3",
		med2="Elixer Vitae",
		med3="Icarus Wing",
		shihei="Shihei",
		orb="Macrocosmic Orb"
	}
	-- Idle sets

    sets.idle = {range="Turbo Animator",ammo="Automaton Oil",
        head="Pup. Taj",neck="Chivalrous Chain",ear1="Sapphire Earring",ear2="Reraise Earring",
        body="Pup. Tobe",hands="Pup. Dastanas",ring1="Rajas Ring",ring2="Ulthalam's Ring",
        back="Pantin Cape",waist="Swift Belt",legs="Pup. Churidars",feet="Pup. Babouches"}

    sets.idle.Town = set_combine(sets.idle, {main="Tinhaspa"})
     
	-- Set for idle while pet is out (eg: pet regen gear)
    sets.idle.Pet = sets.idle

    -- Idle sets to wear while pet is engaged
    sets.idle.Pet.Engaged = {
        head="Foire Taj",neck="Wiglen Gorget",ear1="Bladeborn Earring",ear2="Cirque Earring",
        body="Foire Tobe",hands="Regimen Mittens",ring1="Sheltered Ring",ring2="Paguroidea Ring",
        back="Dispersal Mantle",waist="Hurch'lan Sash",legs="Foire Churidars",feet="Foire Babouches"}

    sets.idle.Pet.Engaged.Ranged = set_combine(sets.idle.Pet.Engaged, {hands="Cirque Guanti +2",legs="Cirque Pantaloni +2"})

    sets.idle.Pet.Engaged.Nuke = set_combine(sets.idle.Pet.Engaged, {legs="Cirque Pantaloni +2",feet="Cirque Scarpe +2"})

    sets.idle.Pet.Engaged.Magic = set_combine(sets.idle.Pet.Engaged, {legs="Cirque Pantaloni +2",feet="Cirque Scarpe +2"})

	-- Resting sets
    sets.resting = {head="Pitre Taj",neck="Wiglen Gorget",
        ring1="Sheltered Ring",ring2="Paguroidea Ring"}

	-- Normal melee group
    sets.engaged = {range="Turbo Animator",ammo="Automaton Oil",
        head="Optical Hat",neck="Chivalrous Chain",ear1="Sapphire Earring",ear2="Reraise Earring",
        body="Pup. Tobe",hands="Pup. Dastanas",ring1="Rajas Ring",ring2="Ulthalam's Ring",
        back="Pantin Cape",waist="Swift Belt",legs="Pantin Churidars",feet="Pup. Babouches"}
	sets.engaged.H2H = {}
	sets.engaged.Staff = {}
	sets.engaged.Club = {}

	-- Basic Mode definitions
	sets.Mode = {}
	sets.Mode.Acc = set_combine(sets.engaged, {
		head="Optical Hat",legs="Pantin Churidars"})
	sets.Mode.Att= set_combine(sets.engaged, {})
	sets.Mode.Crit = set_combine(sets.engaged, {})
	sets.Mode.DA = set_combine(sets.engaged, {})
	sets.Mode.Haste = set_combine(sets.engaged, {})
	sets.Mode.Skill = set_combine(sets.engaged, {ear1="Terminus Earring",ear2="Liminus Earring",ring2="Prouesse Ring"})
	sets.Mode.sTP = set_combine(sets.engaged, {})
	sets.Mode.STR = set_combine(sets.engaged, {
		head="Maat's Cap",neck="Chivalrous Chain",legs="Pantin Churidars"})

	sets.engaged.H2H = set_combine(sets.engaged, {main="Bone Patas"})
	sets.engaged.H2H.Acc = set_combine(sets.engaged.H2H, sets.Mode.Acc)
	sets.engaged.H2H.Att = set_combine(sets.engaged.H2H, sets.Mode.Att)
	sets.engaged.H2H.Crit = set_combine(sets.engaged.H2H, sets.Mode.Crit)
	sets.engaged.H2H.DA = set_combine(sets.engaged.H2H, sets.Mode.DA)
	sets.engaged.H2H.Haste = set_combine(sets.engaged.H2H, sets.Mode.Haste)
	sets.engaged.H2H.Skill = set_combine(sets.engaged.H2H, { 
			head="Brisk Mask",neck="Faith Torque",ear1="Kemas Earring",
			ring2="Portus Ring",
			back="Belenos' Mantle"})
	sets.engaged.H2H.sTP = set_combine(sets.engaged.H2H, sets.Mode.sTP)
	sets.engaged.H2H.STR = set_combine(sets.engaged.H2H, sets.Mode.STR)
	sets.engaged.Staff = set_combine(sets.engaged, {main="Eminent Staff",sub="Pole Grip"})
	sets.engaged.Staff.Acc = set_combine(sets.engaged.H2H, sets.Mode.Acc)
	sets.engaged.Staff.Skill = set_combine(sets.engaged.H2H, sets.Mode.Skill)
	sets.engaged.Club = set_combine(sets.engaged, {main="Warp Cudgel"})
	sets.engaged.Club.Acc = set_combine(sets.engaged.H2H, sets.Mode.Acc)
	sets.engaged.Club.Skill = set_combine(sets.engaged.H2H, sets.Mode.Skill)

   
    -- Precast Sets

    -- Fast cast sets for spells
    sets.precast.FC = {head="Haruspex Hat",ear2="Loquacious Earring",hands="Thaumas Gloves"}

    sets.precast.FC.Utsusemi = set_combine(sets.precast.FC, {neck="Magoraga Beads"})

    
    -- Precast sets to enhance JAs
    sets.precast.JA['Tactical Switch'] = {feet="Cirque Scarpe +2"}
    
    sets.precast.JA['Repair'] = {feet="Foire Babouches"}

    sets.precast.JA.Maneuver = {neck="Buffoon's Collar",body="Cirque Farsetto +2",hands="Foire Dastanas",back="Dispersal Mantle"}



    -- Waltz set (chr and vit)
    sets.precast.Waltz = {
        head="Whirlpool Mask",ear1="Roundel Earring",
        body="Otronif Harness +1",hands="Otronif Gloves",ring1="Spiral Ring",
        back="Iximulew Cape",legs="Nahtirah Trousers",feet="Thurandaut Boots +1"}
        
    -- Don't need any special gear for Healing Waltz.
    sets.precast.Waltz['Healing Waltz'] = {}

       
    -- Weaponskill sets
    -- Default set for any weaponskill that isn't any more specifically defined
    sets.precast.WS = {
        head="Whirlpool Mask",neck="Asperity Necklace",ear1="Bladeborn Earring",ear2="Steelflash Earring",
        body="Manibozho Jerkin",hands="Otronif Gloves",ring1="Rajas Ring",ring2="Epona's Ring",
        back="Dispersal Mantle",waist="Windbuffet Belt",legs="Manibozho Brais",feet="Manibozho Boots"}

    -- Specific weaponskill sets.  Uses the base set if an appropriate WSMod version isn't found.
    sets.precast.WS['Stringing Pummel'] = set_combine(sets.precast.WS, {neck="Rancor Collar",ear1="Brutal Earring",ear2="Moonshade Earring",
        ring1="Spiral Ring",waist="Soil Belt"})
    sets.precast.WS['Stringing Pummel'].Mod = set_combine(sets.precast.WS['Stringing Pummel'], {legs="Nahtirah Trousers"})

    sets.precast.WS['Victory Smite'] = set_combine(sets.precast.WS, {neck="Rancor Collar",ear1="Brutal Earring",ear2="Moonshade Earring",
        waist="Thunder Belt"})

    sets.precast.WS['Shijin Spiral'] = set_combine(sets.precast.WS, {neck="Light Gorget",waist="Light Belt"})

    
    -- Midcast Sets

    sets.midcast.FastRecast = {
        head="Haruspex Hat",ear2="Loquacious Earring",
        body="Otronif Harness +1",hands="Regimen Mittens",
        legs="Manibozho Brais",feet="Otronif Boots +1"}
        

    -- Midcast sets for pet actions
    sets.midcast.Pet.Cure = {legs="Pup. Churidars"}

    sets.midcast.Pet['Elemental Magic'] = {feet="Pitre Babouches"}

    sets.midcast.Pet.WeaponSkill = {head="Cirque Cappello +2", hands="Cirque Guanti +2", legs="Cirque Pantaloni +2"}

    
    -- Sets to return to when not performing an action.
    
    

 

    -- Defense sets

    sets.defense.Evasion = {
        head="Whirlpool Mask",neck="Twilight Torque",
        body="Otronif Harness +1",hands="Otronif Gloves",ring1="Defending Ring",ring2="Beeline Ring",
        back="Ik Cape",waist="Hurch'lan Sash",legs="Nahtirah Trousers",feet="Otronif Boots +1"}

    sets.defense.PDT = {
        head="Whirlpool Mask",neck="Twilight Torque",
        body="Otronif Harness +1",hands="Otronif Gloves",ring1="Defending Ring",ring2=gear.DarkRing.physical,
        back="Shadow Mantle",waist="Hurch'lan Sash",legs="Nahtirah Trousers",feet="Otronif Boots +1"}

    sets.defense.MDT = {
        head="Whirlpool Mask",neck="Twilight Torque",
        body="Otronif Harness +1",hands="Otronif Gloves",ring1="Defending Ring",ring2="Shadow Ring",
        back="Tuilha Cape",waist="Hurch'lan Sash",legs="Nahtirah Trousers",feet="Otronif Boots +1"}

    sets.Kiting = {feet="Hermes' Sandals"}
end


-------------------------------------------------------------------------------------------------------------------
-- Job-specific hooks for standard casting events.
-------------------------------------------------------------------------------------------------------------------

-- Called when pet is about to perform an action
function job_pet_midcast(spell, action, spellMap, eventArgs)
    if petWeaponskills:contains(spell.english) then
        classes.CustomClass = "Weaponskill"
    end
end


-------------------------------------------------------------------------------------------------------------------
-- Job-specific hooks for non-casting events.
-------------------------------------------------------------------------------------------------------------------

-- Called when a player gains or loses a buff.
-- buff == buff gained or lost
-- gain == true if the buff was gained, false if it was lost.
function job_buff_change(buff, gain)
    if buff == 'Wind Maneuver' then
        handle_equipping_gear(player.status)
    end
end

-- Called when a player gains or loses a pet.
-- pet == pet gained or lost
-- gain == true if the pet was gained, false if it was lost.
function job_pet_change(pet, gain)
    update_pet_mode()
end

-- Called when the pet's status changes.
function job_pet_status_change(newStatus, oldStatus)
    if newStatus == 'Engaged' then
        display_pet_status()
    end
end


-------------------------------------------------------------------------------------------------------------------
-- User code that supplements standard library decisions.
-------------------------------------------------------------------------------------------------------------------

-- Called by the 'update' self-command, for common needs.
-- Set eventArgs.handled to true if we don't want automatic equipping of gear.
function job_update(cmdParams, eventArgs)
    update_pet_mode()
end


-- Set eventArgs.handled to true if we don't want the automatic display to be run.
function display_current_job_state(eventArgs)
    display_pet_status()
end


-------------------------------------------------------------------------------------------------------------------
-- User self-commands.
-------------------------------------------------------------------------------------------------------------------

-- Called for custom player commands.
function job_self_command(cmdParams, eventArgs)
    if cmdParams[1] == 'maneuver' then
        if pet.isvalid then
            local man = defaultManeuvers[state.PetMode.value]
            if man and tonumber(cmdParams[2]) then
                man = man[tonumber(cmdParams[2])]
            end

            if man then
                send_command('input /pet "'..man..'" <me>')
            end
        else
            add_to_chat(123,'No valid pet.')
        end
    end
end


-------------------------------------------------------------------------------------------------------------------
-- Utility functions specific to this job.
-------------------------------------------------------------------------------------------------------------------

-- Get the pet mode value based on the equipped head of the automaton.
-- Returns nil if pet is not valid.
function get_pet_mode()
    if pet.isvalid then
        return petModes[pet.head] or 'None'
    else
        return 'None'
    end
end

-- Update state.PetMode, as well as functions that use it for set determination.
function update_pet_mode()
    state.PetMode:set(get_pet_mode())
    update_custom_groups()
end

-- Update custom groups based on the current pet.
function update_custom_groups()
    classes.CustomIdleGroups:clear()
    if pet.isvalid then
        classes.CustomIdleGroups:append(state.PetMode.value)
    end
end

-- Display current pet status.
function display_pet_status()
    if pet.isvalid then
        local petInfoString = pet.name..' ['..pet.head..']: '..tostring(pet.status)..'  TP='..tostring(pet.tp)..'  HP%='..tostring(pet.hpp)
        
        if magicPetModes:contains(state.PetMode.value) then
            petInfoString = petInfoString..'  MP%='..tostring(pet.mpp)
        end
        
        add_to_chat(122,petInfoString)
    end
end

-- Select default macro book on initial load or subjob change.
function select_default_macro_book()
    -- Default macro set/book
    if player.sub_job == 'DNC' then
        set_macro_page(2, 20)
    elseif player.sub_job == 'NIN' then
        set_macro_page(2, 20)
    elseif player.sub_job == 'THF' then
        set_macro_page(2, 20)
    else
        set_macro_page(2, 20)
    end
end

function get_combat_form()
	set_combat_form()
end

function pick_tp_weapon()
	-- add_to_chat(122,' pick tp weapon '..state.WeaponMode.value)
	set_combat_weapon()
	-- add_to_chat(123, 'combat weapon set to '..state.CombatWeapon.value)
end

