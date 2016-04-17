include('organizer-lib.lua')
-------------------------------------------------------------------------------------------------------------------
-- Setup functions for this job.  Generally should not be modified.
-------------------------------------------------------------------------------------------------------------------

--[[
    gs c toggle LuzafRing -- Toggles use of Luzaf Ring on and off
    
    Offense mode is melee or ranged.  Used ranged offense mode if you are engaged
    for ranged weaponskills, but not actually meleeing.
    
    Weaponskill mode, if set to 'Normal', is handled separately for melee and ranged weaponskills.
--]]


-- Initialization function for this job file.
function get_sets()
    mote_include_version = 2
    
    -- Load and initialize the include file.
    include('Mote-Include.lua')
end

-- Setup vars that are user-independent.  state.Buff vars initialized here will automatically be tracked.
function job_setup()
    -- Whether to use Luzaf's Ring
    state.LuzafRing = M(false, "Luzaf's Ring")
    -- Whether a warning has been given for low ammo
    state.warned = M(false)
	state.WeaponMode = M{['description']='Weapon Mode', 'Dagger', 'Sword', 'Staff'}
	state.SubMode = M{['description']='Sub Mode', 'DW', 'Shield', 'Grip'}
	state.RWeaponMode = M{['description']='RWeapon Mode', 'Gun'}
	state.Stance = M{['description']='Stance', 'Off', 'None', 'Offensive', 'Defensive'}
 
	get_combat_form()
	pick_tp_weapon()

    define_roll_values()
end

-------------------------------------------------------------------------------------------------------------------
-- User setup functions for this job.  Recommend that these be overridden in a sidecar file.
-------------------------------------------------------------------------------------------------------------------

-- Setup vars that are user-dependent.  Can override this function in a sidecar file.
function user_setup()
	state.OffenseMode:options('Normal', 'Acc', 'Att', 'Crit', 'DA', 'Haste', 'Skill', 'sTP', 'STR')
	state.DefenseMode:options('None', 'Physical', 'Magical')
	state.PhysicalDefenseMode:options('PDT', 'Evasion')
	state.MagicalDefenseMode:options('MDT')
	state.CastingMode:options('Normal', 'Resistant')
	state.WeaponMode:set('Dagger')
	state.Stance:set('Offensive')
	state.SubMode:set('DW')
	state.RWeaponMode:set('Gun') 
	state.RangedMode:options('Normal', 'Acc')
	state.WeaponskillMode:options('Normal', 'Acc')

    gear.RAbullet = "Steel Bullet"
    gear.WSbullet = "Steel Bullet"
    gear.MAbullet = "Steel Bullet"
    gear.QDbullet = "Steel Bullet"
    options.ammo_warning_limit = 15

    -- Additional local binds
    send_command('bind ^` input /ja "Double-up" <me>')
    send_command('bind !` input /ja "Bolter\'s Roll" <me>')

    select_default_macro_book()
end


-- Called when this job file is unloaded (eg: job change)
function user_unload()
    send_command('unbind ^`')
    send_command('unbind !`')
end

-- Define sets and vars used by this job file.
function init_gear_sets()
	organizer_items = {
		echos="Echo Drops",
		food="Squid Sushi",
		test="Cor. Testimony",
		fcard="Fire Card",
		ecard="Earth Card",
		tcard="Thunder Card",
		icard="Ice Card",
		lcard="Light Card",
		dcard="Dark Card",
		wcard="Wind Card",
		trcard="Trump Card",
		wacard="Water Card",
		shihei="Shihei",
		orb="Macrocosmic Orb"
	}
    -- Sets to return to when not performing an action.
    -- Idle sets
    sets.idle = {ammo=gear.RAbullet,
			head="Corsair's Tricorne",neck="Wiglen Gorget",ear1="Moldavite Earring",ear2="Reraise Earring",
			body="Corsair's Frac",hands="Corsair's Gants",ring1="Rajas Ring",ring2="Ulthalam's Ring",
			back="Amemet Mantle +1",waist="Flume Belt",legs="Corsair's Culottes",feet="Corsair's Bottes"}

	-- Idle sets (default idle set not needed since the other three are defined, but leaving for testing purposes)
	sets.idle.Town = set_combine(sets.idle, {})
	sets.idle.Field = set_combine(sets.idle, {})
	sets.idle.Weak = set_combine(sets.idle, {})

	-- Resting sets
	sets.resting = set_combine(sets.idle, {})

	-- Engaged sets
	-- Variations for TP weapon and (optional) offense/defense modes.  Code will fall back on previous
	-- sets if more refined versions aren't defined.
	-- If you create a set with both offense and defense modes, the offense mode should be first.
	-- EG: sets.engaged.Dagger.Accuracy.Evasion

	-- Normal melee group
	sets.engaged = {
			head="Optical Hat",neck="Wiglen Gorget",ear1="Moldavite Earring",ear2="Reraise Earring",
			body="Corsair's Frac",hands="Corsair's Gants",ring1="Rajas Ring",ring2="Ulthalam's Ring",
			back="Amemet Mantle +1",waist="Swift Belt",legs="Corsair's Culottes",feet="Corsair's Bottes"}
	sets.engaged.Sword = {}
	sets.engaged.Staff = {}
	sets.engaged.Club = {}
	sets.engaged.Dagger = {}
			
	-- Basic Mode definitions
	sets.Mode = {}
	sets.Mode.Acc = set_combine(sets.engaged, {head="Optical Hat"})
	sets.Mode.Att= set_combine(sets.engaged, {})
	sets.Mode.Crit = set_combine(sets.engaged, {})
	sets.Mode.DA = set_combine(sets.engaged, {})
	sets.Mode.Haste = set_combine(sets.engaged, {})
	sets.Mode.Skill = set_combine(sets.engaged, {ear1="Terminus Earring",ear2="Liminus Earring",ring2="Prouesse Ring"})
	sets.Mode.sTP = set_combine(sets.engaged, {})
	sets.Mode.STR = set_combine(sets.engaged, {head="Maat's Cap"})
			
	--Initialize Main Weapons
	sets.engaged.DW = set_combine(sets.engaged, {})
	sets.engaged.Shield = set_combine(sets.engaged, {})
	sets.engaged.Grip = set_combine(sets.engaged, {})
	sets.engaged.DW.Sword = set_combine(sets.engaged, {main="Kumbhakarna",sub="Hatxiik"})
	sets.engaged.Shield.Sword = set_combine(sets.engaged, {main="Kumbhakarna",sub="Viking Shield"})
	sets.engaged.DW.Club = set_combine(sets.engaged, {main="Warp Cudgel",sub="Kumbhakarna"})
	sets.engaged.Shield.Club = set_combine(sets.engaged, {main="Warp Cudgel",sub="Viking Shield"})
	sets.engaged.DW.Dagger = set_combine(sets.engaged, {main="Archer's Knife",sub="Kumbhakarna"})
	sets.engaged.Shield.Dagger = set_combine(sets.engaged, {main="Archer's Knife",sub="Viking Shield"})
	sets.engaged.Grip.Staff = set_combine(sets.engaged, {main="Chatoyant Staff", sub="Pole Grip"})
	--Add in appropriate Ranged weapons
	sets.ranged = {}
	sets.ranged.Gun = {ranged="Hexagun",ammo="Steel Bullet"}
	
	sets.engaged.DW.Sword.Gun = set_combine(sets.engaged.DW.Sword, sets.ranged.Gun)
	sets.engaged.Shield.Sword.Gun = set_combine(sets.engaged.Shield.Sword, sets.ranged.Gun)
	sets.engaged.DW.Club.Gun = set_combine(sets.engaged.DW.Club, sets.ranged.Gun)
	sets.engaged.Shield.Club.Gun = set_combine(sets.engaged.Shield.Club, sets.ranged.Gun)
	sets.engaged.DW.Dagger.Gun = set_combine(sets.engaged.DW.Dagger, sets.ranged.Gun)
	sets.engaged.Shield.Dagger.Gun = set_combine(sets.engaged.Shield.Dagger, sets.ranged.Gun)
	
	sets.engaged.DW.Sword.Acc = set_combine(sets.engaged.DW.Sword, sets.Mode.Acc)
	sets.engaged.DW.Sword.Att = set_combine(sets.engaged.DW.Sword, sets.Mode.Att)
	sets.engaged.DW.Sword.Crit = set_combine(sets.engaged.DW.Sword, sets.Mode.Crit)
	sets.engaged.DW.Sword.DA = set_combine(sets.engaged.DW.Sword, sets.Mode.DA)
	sets.engaged.DW.Sword.Haste = set_combine(sets.engaged.DW.Sword, sets.Mode.Haste)
	sets.engaged.DW.Sword.Skill = set_combine(sets.engaged.DW.Sword, {})
	sets.engaged.DW.Sword.sTP = set_combine(sets.engaged.DW.Sword, sets.Mode.sTP)
	sets.engaged.DW.Sword.STR = set_combine(sets.engaged.DW.Sword, sets.Mode.STR)
	sets.engaged.Shield.Sword.Acc = set_combine(sets.engaged.Shield.Sword, sets.Mode.Acc)
	sets.engaged.Shield.Sword.Att = set_combine(sets.engaged.Shield.Sword, sets.Mode.Att)
	sets.engaged.Shield.Sword.Crit = set_combine(sets.engaged.Shield.Sword, sets.Mode.Crit)
	sets.engaged.Shield.Sword.DA = set_combine(sets.engaged.Shield.Sword, sets.Mode.DA)
	sets.engaged.Shield.Sword.Haste = set_combine(sets.engaged.Shield.Sword, sets.Mode.Haste)
	sets.engaged.Shield.Sword.Skill = set_combine(sets.engaged.Shield.Sword, {})
	sets.engaged.Shield.Sword.sTP = set_combine(sets.engaged.Shield.Sword, sets.Mode.sTP)
	sets.engaged.Shield.Sword.STR = set_combine(sets.engaged.Shield.Sword, sets.Mode.STR)
	
	sets.engaged.DW.Club.Acc = set_combine(sets.engaged.DW.Club, sets.Mode.Acc)
	sets.engaged.DW.Club.Att = set_combine(sets.engaged.DW.Club, sets.Mode.Att)
	sets.engaged.DW.Club.Crit = set_combine(sets.engaged.DW.Club, sets.Mode.Crit)
	sets.engaged.DW.Club.DA = set_combine(sets.engaged.DW.Club, sets.Mode.DA)
	sets.engaged.DW.Club.Haste = set_combine(sets.engaged.DW.Club, sets.Mode.Haste)
	sets.engaged.DW.Club.Skill = set_combine(sets.engaged.DW.Club, {})
	sets.engaged.DW.Club.sTP = set_combine(sets.engaged.DW.Club, sets.Mode.sTP)
	sets.engaged.DW.Club.STR = set_combine(sets.engaged.DW.Club, sets.Mode.STR)
	sets.engaged.Shield.Club.Acc = set_combine(sets.engaged.Shield.Club, sets.Mode.Acc)
	sets.engaged.Shield.Club.Att = set_combine(sets.engaged.Shield.Club, sets.Mode.Att)
	sets.engaged.Shield.Club.Crit = set_combine(sets.engaged.Shield.Club, sets.Mode.Crit)
	sets.engaged.Shield.Club.DA = set_combine(sets.engaged.Shield.Club, sets.Mode.DA)
	sets.engaged.Shield.Club.Haste = set_combine(sets.engaged.Shield.Club, sets.Mode.Haste)
	sets.engaged.Shield.Club.Skill = set_combine(sets.engaged.Shield.Club, {})
	sets.engaged.Shield.Club.sTP = set_combine(sets.engaged.Shield.Club, sets.Mode.sTP)
	sets.engaged.Shield.Club.STR = set_combine(sets.engaged.Shield.Club, sets.Mode.STR)

	sets.engaged.DW.Dagger.Acc = set_combine(sets.engaged.DW.Dagger, sets.Mode.Acc)
	sets.engaged.DW.Dagger.Att = set_combine(sets.engaged.DW.Dagger, sets.Mode.Att)
	sets.engaged.DW.Dagger.Crit = set_combine(sets.engaged.DW.Dagger, sets.Mode.Crit)
	sets.engaged.DW.Dagger.DA = set_combine(sets.engaged.DW.Dagger, sets.Mode.DA)
	sets.engaged.DW.Dagger.Haste = set_combine(sets.engaged.DW.Dagger, sets.Mode.Haste)
	sets.engaged.DW.Dagger.Skill = set_combine(sets.engaged.DW.Dagger, {})
	sets.engaged.DW.Dagger.sTP = set_combine(sets.engaged.DW.Dagger, sets.Mode.sTP)
	sets.engaged.DW.Dagger.STR = set_combine(sets.engaged.DW.Dagger, sets.Mode.STR)
	sets.engaged.Shield.Dagger.Acc = set_combine(sets.engaged.Shield.Dagger, sets.Mode.Acc)
	sets.engaged.Shield.Dagger.Att = set_combine(sets.engaged.Shield.Dagger, sets.Mode.Att)
	sets.engaged.Shield.Dagger.Crit = set_combine(sets.engaged.Shield.Dagger, sets.Mode.Crit)
	sets.engaged.Shield.Dagger.DA = set_combine(sets.engaged.Shield.Dagger, sets.Mode.DA)
	sets.engaged.Shield.Dagger.Haste = set_combine(sets.engaged.Shield.Dagger, sets.Mode.Haste)
	sets.engaged.Shield.Dagger.Skill = set_combine(sets.engaged.Shield.Dagger, {})
	sets.engaged.Shield.Dagger.sTP = set_combine(sets.engaged.Shield.Dagger, sets.Mode.sTP)
	sets.engaged.Shield.Dagger.STR = set_combine(sets.engaged.Shield.Dagger, sets.Mode.STR)

	sets.engaged.Grip.Staff.Acc = set_combine(sets.engaged.Grip.Staff, sets.Mode.Acc)
			
	-- Weaponskill sets
	-- Default set for any weaponskill that isn't any more specifically defined
	sets.precast.WS = {}
	sets.WSDayBonus = {} 

	-- Specific weaponskill sets.  Uses the base set if an appropriate WSMod version isn't found.
	sets.precast.WS = set_combine(sets.Mode.STR, {})
	sets.precast.WS.Acc = set_combine(sets.precast.WS, {})
 
	-- Light/Dark/Earth, DEX 50%
    sets.precast.WS['Evisceration'] = set_combine(sets.precast.WS, sets.Mode.Crit, {neck="Light Gorget",waist="Light Belt"})
 
	-- Wind/Thunder/Earth, DEX 40% AGI 40%
    sets.precast.WS['Aeolian Edge'] = set_combine(sets.precast.WS, {
        head="Wayfarer Circlet",neck="Breeze Gorget",ear1="Friomisi Earring",ear2="Moonshade Earring",
        body="Wayfarer Robe",ring1="Acumen Ring",ring2="Demon's Ring",
        back="Toro Cape",waist="Breeze Belt",legs="Shneddick Tights +1",feet="Wayfarer Clogs"})
 
	-- Wind/Thunder/Earth, AGI 73%
	sets.precast.WS['Exenterator'] = set_combine(sets.precast.WS, {neck="Breeze Gorget",waist="Breeze Belt"})
 
	-- Dark/Earth, MND 73%
	sets.precast.WS['Rquiescat'] = set_combine(sets.precast.WS, {})

    sets.precast.WS['Last Stand'] = {ammo=gear.WSbullet,
        head="Whirlpool Mask",neck=gear.ElementalGorget,ear1="Clearview Earring",ear2="Moonshade Earring",
        body="Laksamana's Frac",hands="Iuitl Wristbands",ring1="Rajas Ring",ring2="Stormsoul Ring",
        back="Terebellum Mantle",waist=gear.ElementalBelt,legs="Nahtirah Trousers",feet="Iuitl Gaiters +1"}

    sets.precast.WS['Last Stand'].Acc = {ammo=gear.WSbullet,
        head="Laksamana's Hat",neck=gear.ElementalGorget,ear1="Clearview Earring",ear2="Moonshade Earring",
        body="Laksamana's Frac",hands="Buremte Gloves",ring1="Hajduk Ring",ring2="Stormsoul Ring",
        back="Libeccio Mantle",waist=gear.ElementalBelt,legs="Thurandaut Tights +1",feet="Laksamana's Bottes"}


    sets.precast.WS['Wildfire'] = {ammo=gear.MAbullet,
        head="Wayfarer Circlet",neck="Stoicheion Medal",ear1="Friomisi Earring",ear2="Hecate's Earring",
        body="Manibozho Jerkin",hands="Iuitl Wristbands",ring1="Stormsoul Ring",ring2="Demon's Ring",
        back="Toro Cape",waist=gear.ElementalBelt,legs="Iuitl Tights",feet="Iuitl Gaiters +1"}

    sets.precast.WS['Wildfire'].Brew = {ammo=gear.MAbullet,
        head="Wayfarer Circlet",neck="Stoicheion Medal",ear1="Friomisi Earring",ear2="Hecate's Earring",
        body="Manibozho Jerkin",hands="Iuitl Wristbands",ring1="Stormsoul Ring",ring2="Demon's Ring",
        back="Toro Cape",waist=gear.ElementalBelt,legs="Iuitl Tights",feet="Iuitl Gaiters +1"}
    
    sets.precast.WS['Leaden Salute'] = sets.precast.WS['Wildfire']

	-- Water/Light/Wind, AGI 70%
	sets.precast.WS['Slug Shot'] = set_combine(sets.precast.WS, {neck="Breeze Gorget",waist="Breeze Belt"})
    
    -- Precast Sets

    -- Precast sets to enhance JAs
    
    sets.precast.JA['Triple Shot'] = {body="Navarch's Frac +2"}
    sets.precast.JA['Snake Eye'] = {legs="Lanun Culottes"}
    sets.precast.JA['Wild Card'] = {feet="Lanun Bottes"}
    sets.precast.JA['Random Deal'] = {body="Lanun Frac"}

    
    sets.precast.CorsairRoll = {head="Lanun Tricorne",hands="Navarch's Gants +2"}
    
    sets.precast.CorsairRoll["Caster's Roll"] = set_combine(sets.precast.CorsairRoll, {legs="Navarch's Culottes +2"})
    sets.precast.CorsairRoll["Courser's Roll"] = set_combine(sets.precast.CorsairRoll, {feet="Navarch's Bottes +2"})
    sets.precast.CorsairRoll["Blitzer's Roll"] = set_combine(sets.precast.CorsairRoll, {head="Navarch's Tricorne +2"})
    sets.precast.CorsairRoll["Tactician's Roll"] = set_combine(sets.precast.CorsairRoll, {body="Navarch's Frac +2"})
    sets.precast.CorsairRoll["Allies' Roll"] = set_combine(sets.precast.CorsairRoll, {hands="Navarch's Gants +2"})
    
    sets.precast.LuzafRing = {ring2="Luzaf's Ring"}
    sets.precast.FoldDoubleBust = {hands="Lanun Gants"}
    
    sets.precast.CorsairShot = {head="Corsair's Tricorne",ear1="Moldavite Earring"}
    

    -- Waltz set (chr and vit)
    sets.precast.Waltz = {
        head="Whirlpool Mask",
        body="Iuitl Vest",hands="Iuitl Wristbands",
        legs="Nahtirah Trousers",feet="Iuitl Gaiters +1"}
        
    -- Don't need any special gear for Healing Waltz.
    sets.precast.Waltz['Healing Waltz'] = {}

    -- Fast cast sets for spells
    
    sets.precast.FC = {head="Haruspex Hat",ear2="Loquacious Earring",hands="Thaumas Gloves",ring1="Prolix Ring"}

    sets.precast.FC.Utsusemi = set_combine(sets.precast.FC, {neck="Magoraga Beads"})


    sets.precast.RA = {ammo=gear.RAbullet,
        head="Optical Hat",
        body="Laksamana's Frac",hands="Lanun Gants",
        back="Navarch's Mantle",waist="Commodore Belt",legs="Nahtirah Trousers",feet="Wurrukatte Boots"}
    
    -- Midcast Sets
    sets.midcast.FastRecast = {
        head="Whirlpool Mask",
        body="Iuitl Vest",hands="Iuitl Wristbands",
        legs="Manibozho Brais",feet="Iuitl Gaiters +1"}
        
    -- Specific spells
    sets.midcast.Utsusemi = sets.midcast.FastRecast

    sets.midcast.CorsairShot = {ammo=gear.QDbullet,
        head="Blood Mask",neck="Stoicheion Medal",ear1="Friomisi Earring",ear2="Hecate's Earring",
        body="Lanun Frac",hands="Schutzen Mittens",ring1="Hajduk Ring",ring2="Demon's Ring",
        back="Toro Cape",waist="Aquiline Belt",legs="Iuitl Tights",feet="Lanun Bottes"}

    sets.midcast.CorsairShot.Acc = {ammo=gear.QDbullet,
        head="Laksamana's Hat",neck="Stoicheion Medal",ear1="Lifestorm Earring",ear2="Psystorm Earring",
        body="Lanun Frac",hands="Schutzen Mittens",ring1="Stormsoul Ring",ring2="Sangoma Ring",
        back="Navarch's Mantle",waist="Aquiline Belt",legs="Iuitl Tights",feet="Iuitl Gaiters +1"}

    sets.midcast.CorsairShot['Light Shot'] = {ammo=gear.QDbullet,
        head="Laksamana's Hat",neck="Stoicheion Medal",ear1="Lifestorm Earring",ear2="Psystorm Earring",
        body="Lanun Frac",hands="Schutzen Mittens",ring1="Stormsoul Ring",ring2="Sangoma Ring",
        back="Navarch's Mantle",waist="Aquiline Belt",legs="Iuitl Tights",feet="Iuitl Gaiters +1"}

    sets.midcast.CorsairShot['Dark Shot'] = sets.midcast.CorsairShot['Light Shot']


    -- Ranged gear
    sets.midcast.RA = {ammo=gear.RAbullet,
        head="Optical Hat",neck="Iqabi Necklace",ear1="Clearview Earring",ear2="Volley Earring",
        body="Corsair's Frac",hands="Iuitl Wristbands",ring1="Behemoth Ring",ring2="Scorpion Ring +1",
        back="Terebellum Mantle",waist="Commodore Belt",legs="Nahtirah Trousers",feet="Iuitl Gaiters +1"}

    sets.midcast.RA.Acc = {ammo=gear.RAbullet,
        head="Optical Hat",neck="Iqabi Necklace",ear1="Clearview Earring",ear2="Volley Earring",
        body="Corsair's Frac",hands="Iuitl Wristbands",ring1="Behemoth Ring",ring2="Scorpion Ring +1",
        back="Terebellum Mantle",waist="Commodore Belt",legs="Nahtirah Trousers",feet="Iuitl Gaiters +1"}
    
    -- Defense sets
    sets.defense.PDT = {
        head="Whirlpool Mask",neck="Twilight Torque",ear1="Clearview Earring",ear2="Volley Earring",
        body="Iuitl Vest",hands="Iuitl Wristbands",ring1="Defending Ring",ring2=gear.DarkRing.physical,
        back="Shadow Mantle",waist="Flume Belt",legs="Nahtirah Trousers",feet="Iuitl Gaiters +1"}

    sets.defense.MDT = {
        head="Whirlpool Mask",neck="Twilight Torque",ear1="Clearview Earring",ear2="Volley Earring",
        body="Iuitl Vest",hands="Iuitl Wristbands",ring1="Defending Ring",ring2="Shadow Ring",
        back="Engulfer Cape",waist="Flume Belt",legs="Nahtirah Trousers",feet="Iuitl Gaiters +1"}
    

    sets.Kiting = {feet="Skadi's Jambeaux +1"}
end

-------------------------------------------------------------------------------------------------------------------
-- Job-specific hooks for standard casting events.
-------------------------------------------------------------------------------------------------------------------

-- Set eventArgs.handled to true if we don't want any automatic gear equipping to be done.
-- Set eventArgs.useMidcastGear to true if we want midcast gear equipped on precast.
function job_precast(spell, action, spellMap, eventArgs)
    -- Check that proper ammo is available if we're using ranged attacks or similar.
    if spell.action_type == 'Ranged Attack' or spell.type == 'WeaponSkill' or spell.type == 'CorsairShot' then
        do_bullet_checks(spell, spellMap, eventArgs)
    end

    -- gear sets
    if (spell.type == 'CorsairRoll' or spell.english == "Double-Up") and state.LuzafRing.value then
        equip(sets.precast.LuzafRing)
    elseif spell.type == 'CorsairShot' and state.CastingMode.value == 'Resistant' then
        classes.CustomClass = 'Acc'
    elseif spell.english == 'Fold' and buffactive['Bust'] == 2 then
        if sets.precast.FoldDoubleBust then
            equip(sets.precast.FoldDoubleBust)
            eventArgs.handled = true
        end
    end
end


-- Set eventArgs.handled to true if we don't want any automatic gear equipping to be done.
function job_aftercast(spell, action, spellMap, eventArgs)
    if spell.type == 'CorsairRoll' and not spell.interrupted then
        display_roll_info(spell)
    end
end

-------------------------------------------------------------------------------------------------------------------
-- User code that supplements standard library decisions.
-------------------------------------------------------------------------------------------------------------------

-- Return a customized weaponskill mode to use for weaponskill sets.
-- Don't return anything if you're not overriding the default value.
function get_custom_wsmode(spell, spellMap, default_wsmode)
    if buffactive['Transcendancy'] then
        return 'Brew'
    end
end


-- Called by the 'update' self-command, for common needs.
-- Set eventArgs.handled to true if we don't want automatic equipping of gear.
function job_update(cmdParams, eventArgs)
    if newStatus == 'Engaged' and player.equipment.main == 'Chatoyant Staff' then
        state.OffenseMode:set('Ranged')
    end
end


-- Set eventArgs.handled to true if we don't want the automatic display to be run.
function display_current_job_state(eventArgs)
    local msg = ''
    
    msg = msg .. 'Off.: '..state.OffenseMode.current
    msg = msg .. ', Rng.: '..state.RangedMode.current
    msg = msg .. ', WS.: '..state.WeaponskillMode.current
    msg = msg .. ', QD.: '..state.CastingMode.current

    if state.DefenseMode.value ~= 'None' then
        local defMode = state[state.DefenseMode.value ..'DefenseMode'].current
        msg = msg .. ', Defense: '..state.DefenseMode.value..' '..defMode
    end
    
    if state.Kiting.value then
        msg = msg .. ', Kiting'
    end
    
    if state.PCTargetMode.value ~= 'default' then
        msg = msg .. ', Target PC: '..state.PCTargetMode.value
    end

    if state.SelectNPCTargets.value then
        msg = msg .. ', Target NPCs'
    end

    msg = msg .. ', Roll Size: ' .. ((state.LuzafRing.value and 'Large') or 'Small')
    
    add_to_chat(122, msg)

    eventArgs.handled = true
end


-------------------------------------------------------------------------------------------------------------------
-- Utility functions specific to this job.
-------------------------------------------------------------------------------------------------------------------

function define_roll_values()
    rolls = {
        ["Corsair's Roll"]   = {lucky=5, unlucky=9, bonus="Experience Points"},
        ["Ninja Roll"]       = {lucky=4, unlucky=8, bonus="Evasion"},
        ["Hunter's Roll"]    = {lucky=4, unlucky=8, bonus="Accuracy"},
        ["Chaos Roll"]       = {lucky=4, unlucky=8, bonus="Attack"},
        ["Magus's Roll"]     = {lucky=2, unlucky=6, bonus="Magic Defense"},
        ["Healer's Roll"]    = {lucky=3, unlucky=7, bonus="Cure Potency Received"},
        ["Puppet Roll"]      = {lucky=4, unlucky=8, bonus="Pet Magic Accuracy/Attack"},
        ["Choral Roll"]      = {lucky=2, unlucky=6, bonus="Spell Interruption Rate"},
        ["Monk's Roll"]      = {lucky=3, unlucky=7, bonus="Subtle Blow"},
        ["Beast Roll"]       = {lucky=4, unlucky=8, bonus="Pet Attack"},
        ["Samurai Roll"]     = {lucky=2, unlucky=6, bonus="Store TP"},
        ["Evoker's Roll"]    = {lucky=5, unlucky=9, bonus="Refresh"},
        ["Rogue's Roll"]     = {lucky=5, unlucky=9, bonus="Critical Hit Rate"},
        ["Warlock's Roll"]   = {lucky=4, unlucky=8, bonus="Magic Accuracy"},
        ["Fighter's Roll"]   = {lucky=5, unlucky=9, bonus="Double Attack Rate"},
        ["Drachen Roll"]     = {lucky=3, unlucky=7, bonus="Pet Accuracy"},
        ["Gallant's Roll"]   = {lucky=3, unlucky=7, bonus="Defense"},
        ["Wizard's Roll"]    = {lucky=5, unlucky=9, bonus="Magic Attack"},
        ["Dancer's Roll"]    = {lucky=3, unlucky=7, bonus="Regen"},
        ["Scholar's Roll"]   = {lucky=2, unlucky=6, bonus="Conserve MP"},
        ["Bolter's Roll"]    = {lucky=3, unlucky=9, bonus="Movement Speed"},
        ["Caster's Roll"]    = {lucky=2, unlucky=7, bonus="Fast Cast"},
        ["Courser's Roll"]   = {lucky=3, unlucky=9, bonus="Snapshot"},
        ["Blitzer's Roll"]   = {lucky=4, unlucky=9, bonus="Attack Delay"},
        ["Tactician's Roll"] = {lucky=5, unlucky=8, bonus="Regain"},
        ["Allies's Roll"]    = {lucky=3, unlucky=10, bonus="Skillchain Damage"},
        ["Miser's Roll"]     = {lucky=5, unlucky=7, bonus="Save TP"},
        ["Companion's Roll"] = {lucky=2, unlucky=10, bonus="Pet Regain and Regen"},
        ["Avenger's Roll"]   = {lucky=4, unlucky=8, bonus="Counter Rate"},
    }
end

function display_roll_info(spell)
    rollinfo = rolls[spell.english]
    local rollsize = (state.LuzafRing.value and 'Large') or 'Small'

    if rollinfo then
        add_to_chat(104, spell.english..' provides a bonus to '..rollinfo.bonus..'.  Roll size: '..rollsize)
        add_to_chat(104, 'Lucky roll is '..tostring(rollinfo.lucky)..', Unlucky roll is '..tostring(rollinfo.unlucky)..'.')
    end
end


-- Determine whether we have sufficient ammo for the action being attempted.
function do_bullet_checks(spell, spellMap, eventArgs)
    local bullet_name
    local bullet_min_count = 1
    
    if spell.type == 'WeaponSkill' then
        if spell.skill == "Marksmanship" then
            if spell.element == 'None' then
                -- physical weaponskills
                bullet_name = gear.WSbullet
            else
                -- magical weaponskills
                bullet_name = gear.MAbullet
            end
        else
            -- Ignore non-ranged weaponskills
            return
        end
    elseif spell.type == 'CorsairShot' then
        bullet_name = gear.QDbullet
    elseif spell.action_type == 'Ranged Attack' then
        bullet_name = gear.RAbullet
        if buffactive['Triple Shot'] then
            bullet_min_count = 3
        end
    end
    
    local available_bullets = player.inventory[bullet_name] or player.wardrobe[bullet_name]
    
    -- If no ammo is available, give appropriate warning and end.
    if not available_bullets then
        if spell.type == 'CorsairShot' and player.equipment.ammo ~= 'empty' then
            add_to_chat(104, 'No Quick Draw ammo left.  Using what\'s currently equipped ('..player.equipment.ammo..').')
            return
        elseif spell.type == 'WeaponSkill' and player.equipment.ammo == gear.RAbullet then
            add_to_chat(104, 'No weaponskill ammo left.  Using what\'s currently equipped (standard ranged bullets: '..player.equipment.ammo..').')
            return
        else
            add_to_chat(104, 'No ammo ('..tostring(bullet_name)..') available for that action.')
            eventArgs.cancel = true
            return
        end
    end
    
    -- Don't allow shooting or weaponskilling with ammo reserved for quick draw.
    if spell.type ~= 'CorsairShot' and bullet_name == gear.QDbullet and available_bullets.count <= bullet_min_count then
        add_to_chat(104, 'No ammo will be left for Quick Draw.  Cancelling.')
        eventArgs.cancel = true
        return
    end
    
    -- Low ammo warning.
    if spell.type ~= 'CorsairShot' and state.warned.value == false
        and available_bullets.count > 1 and available_bullets.count <= options.ammo_warning_limit then
        local msg = '*****  LOW AMMO WARNING: '..bullet_name..' *****'
        --local border = string.repeat("*", #msg)
        local border = ""
        for i = 1, #msg do
            border = border .. "*"
        end
        
        add_to_chat(104, border)
        add_to_chat(104, msg)
        add_to_chat(104, border)

        state.warned:set()
    elseif available_bullets.count > options.ammo_warning_limit and state.warned then
        state.warned:reset()
    end
end

-- Select default macro book on initial load or subjob change.
function select_default_macro_book()
    set_macro_page(1, 18)
end

function get_combat_form()
	set_combat_form()
end

function pick_tp_weapon()
	-- add_to_chat(122,' pick tp weapon '..state.WeaponMode.value)
	set_combat_weapon()
	set_ranged_weapon()
	-- add_to_chat(123, 'combat weapon set to '..state.CombatWeapon.value)
end