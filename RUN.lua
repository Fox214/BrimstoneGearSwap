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


-- Setup vars that are user-independent.
function job_setup()
    -- Table of entries
    rune_timers = T{}
    -- entry = rune, index, expires
    
    if player.main_job_level >= 65 then
        max_runes = 3
    elseif player.main_job_level >= 35 then
        max_runes = 2
    elseif player.main_job_level >= 5 then
        max_runes = 1
    else
        max_runes = 0
    end
	state.WeaponMode = M{['description']='Weapon Mode', 'GreatSword', 'Sword', 'GreatAxe', 'Axe', 'Club'}
	state.SubMode = M{['description']='Sub Mode', 'DW', 'Shield', 'Grip'}
	state.Stance = M{['description']='Stance', 'Off', 'None', 'Offensive', 'Defensive'}
 
	set_combat_form()
	pick_tp_weapon()
end

-------------------------------------------------------------------------------------------------------------------
-- User setup functions for this job.  Recommend that these be overridden in a sidecar file.
-------------------------------------------------------------------------------------------------------------------

function user_setup()
	state.OffenseMode:options('Normal', 'Acc', 'Att', 'Crit', 'DA', 'Haste', 'Skill', 'sTP', 'STR')
	state.WeaponskillMode:options('Normal', 'Acc', 'Mod')
	state.DefenseMode:options('None', 'Physical', 'Magical')
	state.PhysicalDefenseMode:options('PDT', 'Evasion', 'Reraise')
	state.MagicalDefenseMode:options('MDT', 'Reraise')
	state.WeaponMode:set('GreatSword')
	state.Stance:set('None')
	state.SubMode:set('Grip')
	flag.sekka = true
	flag.med = true
	flag.berserk = true
	flag.defender = true
	flag.aggressor = true
	flag.warcry = true
	flag.thirdeye = true

	pick_tp_weapon()
	select_default_macro_book()
end


function init_gear_sets()
   	-- extra stuff
	organizer_items = {
		new1="Herculean Trousers",
		new2="Izdubar Mantle",
		new3="Apate Ring",
		new4="Sanctity Necklace",
		new5="Amar Cluster",
		new6="Zulfiqar",
		new7="Pemphredo Tathlum",
		new8="Carmine Cuisses",
		new9="Ginsen",
		new10="Assuage Earring",
		new11="Bidenhander",
		new12="Hetairoi Ring",
		new13="Laic Mantle",
		new14="Sarissapho. Belt",
		new15="Miasmic Pants",
		new16="Limbo Trousers",
		new17="Lilitu Headpiece",
		new18="Combuster",
		new19="Herculean Gloves",
		new20="Herculean Helm",
		new21="Herculean Boots",
		new22="Perception Ring",
		new23="Herculean Vest",
		new24="Phalangite Mantle",
		new25="",
		new26="",
		new27="",
		echos="Echo Drops",
		-- shihei="Shihei",
		orb="Macrocosmic Orb"
	}	
	-- Idle sets
	sets.idle = { ammo="Homiliary",
		head="",neck="Twilight Torque",ear1="Ethereal Earring",ear2="Moonshade Earring",
		body="Respite Cloak",hands="Buremte Gloves",ring1="Vengeful Ring",ring2="Renaye Ring",
		back="Evasionist's Cape",waist="Flax Sash",legs="Carmine Cuisses",feet="Skd. Jambeaux +1"}
			
	-- Idle sets (default idle set not needed since the other three are defined, but leaving for testing purposes)
	sets.idle.Town = set_combine(sets.idle, {})
 	sets.idle.Field = set_combine(sets.idle, {})
	sets.idle.Weak = set_combine(sets.idle, {})
    sets.idle.Refresh = set_combine(sets.idle, {body="Runeist Coat", waist="Fucho-no-obi"})
           
	-- Resting sets
	sets.resting = set_combine(sets.idle, {})

	-- Engaged sets
	-- Variations for TP weapon and (optional) offense/defense modes.  Code will fall back on previous
	-- sets if more refined versions aren't defined.
	-- If you create a set with both offense and defense modes, the offense mode should be first.
	-- EG: sets.engaged.Dagger.Accuracy.Evasion

	-- Normal melee group
	sets.engaged = {ammo="Potestas Bomblet",
			head="Whirlpool Mask",neck="Asperity Necklace",ear1="Ethereal Earring",ear2="Brutal Earring",
			body="Iuitl Vest",hands="Buremte Gloves",ring1="Rajas Ring",ring2="Moepapa Annulet",
			back="Atheling Mantle",waist="Twilight Belt",legs="Feast Hose",feet="Runeist Bottes"}
	sets.engaged.GreatAxe = {}
	sets.engaged.Axe = {}
	sets.engaged.GreatSword = {}
	sets.engaged.Sword = {}
	sets.engaged.Club = {}
			
	-- Basic Mode definitions
	sets.Mode = {}
	sets.Mode.Acc = set_combine(sets.engaged, { ammo="Honed Tathlum",
			head="Whirlpool Mask",neck="Iqabi Necklace",ear1="Zennaroi Earring",ear2="Digni. Earring",
			body="Iuitl Vest",hands="Buremte Gloves",ring1="Patricius Ring",ring2="Ulthalam's Ring",
			back="Grounded Mantle",waist="Olseni Belt",legs="Feast Hose",feet="Skd. Jambeaux +1"})
	sets.Mode.Att= set_combine(sets.engaged, {ammo="Potestas Bomblet",
			head="Whirlpool Mask",neck="Asperity Necklace",ear1="Bladeborn Earring",ear2="Dudgeon Earring",
			ring1="Overbearing Ring",ring2="Cho'j Band",
			back="Atheling Mantle",legs="Manibozho Brais",feet="Thaumas Nails"})
	sets.Mode.Crit = set_combine(sets.engaged, {})
	sets.Mode.DA = set_combine(sets.engaged, {
			neck="Asperity Necklace",ear1="Bladeborn Earring",ear2="Steelflash Earring",
			legs="Quiahuiz Trousers",feet="Thaumas Nails"})
	sets.Mode.Haste = set_combine(sets.engaged, {
			head="Ejekamal Mask",ear1="Heartseeker Earring",ear2="Dudgeon Earring",
			body="Iuitl Vest",hands="Umuthi Gloves",
			back="Grounded Mantle",waist="Twilight Belt",legs="Quiahuiz Trousers",feet="Runeist Bottes"})
	sets.Mode.Skill = set_combine(sets.engaged, {ear1="Terminus Earring",ear2="Liminus Earring",ring2="Prouesse Ring"})
	sets.Mode.sTP = set_combine(sets.engaged, {
			head="Whirlpool Mask",neck="Asperity Necklace",ear1="Tripudio Earring",ear2="Digni. Earring",
			body="Iuitl Vest",hands="Umuthi Gloves",ring1="Rajas Ring",ring2="K'ayres Ring",
			legs="Iuitl Tights"})
	sets.Mode.STR = set_combine(sets.engaged, {ammo="Amar Cluster",
			head="Whirlpool Mask",neck="Lacono Neck. +1",
			body="Iuitl Vest",hands="Umuthi Gloves",ring1="Rajas Ring",ring2="Aife's Ring",
			back="Buquwik Cape",waist="Wanion Belt",legs="Nahtirah Trousers",feet="Runeist Bottes"})
			
	--Initialize Main Weapons
	sets.engaged.DW = set_combine(sets.engaged, {})
	sets.engaged.Shield = set_combine(sets.engaged, {})
	sets.engaged.Grip = set_combine(sets.engaged, {})
	sets.engaged.DW.Axe = set_combine(sets.engaged, {main="Kumbhakarna",sub="Hatxiik"})
	sets.engaged.Shield.Axe = set_combine(sets.engaged, {main="Kumbhakarna",sub="Viking Shield"})
	sets.engaged.DW.Club = set_combine(sets.engaged, {main="Warp Cudgel",sub="Kumbhakarna"})
	sets.engaged.Shield.Club = set_combine(sets.engaged, {main="Warp Cudgel",sub="Viking Shield"})
	sets.engaged.Grip.GreatAxe = set_combine(sets.engaged, {main="Elephas Axe",sub="Tzacab Grip"})
	sets.engaged.Grip.GreatSword = set_combine(sets.engaged, {main="Macbain",sub="Tzacab Grip"})
	sets.engaged.DW.Sword = set_combine(sets.engaged, {main="Usonmunku",sub="Kumbhakarna"})
	sets.engaged.Shield.Sword = set_combine(sets.engaged, {main="Usonmunku",sub="Viking Shield"})
	
	sets.engaged.Grip.GreatAxe.Acc = set_combine(sets.engaged.Grip.GreatAxe, sets.Mode.Acc)
	sets.engaged.Grip.GreatAxe.Att = set_combine(sets.engaged.Grip.GreatAxe, sets.Mode.Att)
	sets.engaged.Grip.GreatAxe.Crit = set_combine(sets.engaged.Grip.GreatAxe, sets.Mode.Crit)
	sets.engaged.Grip.GreatAxe.DA = set_combine(sets.engaged.Grip.GreatAxe, sets.Mode.DA)
	sets.engaged.Grip.GreatAxe.Haste = set_combine(sets.engaged.Grip.GreatAxe, sets.Mode.Haste)
	sets.engaged.Grip.GreatAxe.Skill = set_combine(sets.engaged.Grip.GreatAxe, {})
	sets.engaged.Grip.GreatAxe.sTP = set_combine(sets.engaged.Grip.GreatAxe, sets.Mode.sTP)
	sets.engaged.Grip.GreatAxe.STR = set_combine(sets.engaged.Grip.GreatAxe, sets.Mode.STR)

	sets.engaged.Grip.GreatSword.Acc = set_combine(sets.engaged.Grip.GreatSword, sets.Mode.Acc)
	sets.engaged.Grip.GreatSword.Att = set_combine(sets.engaged.Grip.GreatSword, sets.Mode.Att)
	sets.engaged.Grip.GreatSword.Crit = set_combine(sets.engaged.Grip.GreatSword, sets.Mode.Crit)
	sets.engaged.Grip.GreatSword.DA = set_combine(sets.engaged.Grip.GreatSword, sets.Mode.DA)
	sets.engaged.Grip.GreatSword.Haste = set_combine(sets.engaged.Grip.GreatSword, sets.Mode.Haste)
	sets.engaged.Grip.GreatSword.Skill = set_combine(sets.engaged.Grip.GreatSword, {ear1="Terminus Earring",ear2="Liminus Earring",ring2="Prouesse Ring"})
	sets.engaged.Grip.GreatSword.sTP = set_combine(sets.engaged.Grip.GreatSword, sets.Mode.sTP)
	sets.engaged.Grip.GreatSword.STR = set_combine(sets.engaged.Grip.GreatSword, sets.Mode.STR)
	
	sets.engaged.DW.Axe.Acc = set_combine(sets.engaged.DW.Axe, sets.Mode.Acc)
	sets.engaged.DW.Axe.Att = set_combine(sets.engaged.DW.Axe, sets.Mode.Att)
	sets.engaged.DW.Axe.Crit = set_combine(sets.engaged.DW.Axe, sets.Mode.Crit)
	sets.engaged.DW.Axe.DA = set_combine(sets.engaged.DW.Axe, sets.Mode.DA)
	sets.engaged.DW.Axe.Haste = set_combine(sets.engaged.DW.Axe, sets.Mode.Haste)
	sets.engaged.DW.Axe.Skill = set_combine(sets.engaged.DW.Axe, {})
	sets.engaged.DW.Axe.sTP = set_combine(sets.engaged.DW.Axe, sets.Mode.sTP)
	sets.engaged.DW.Axe.STR = set_combine(sets.engaged.DW.Axe, sets.Mode.STR)
	sets.engaged.Shield.Axe.Acc = set_combine(sets.engaged.Shield.Axe, sets.Mode.Acc)
	sets.engaged.Shield.Axe.Att = set_combine(sets.engaged.Shield.Axe, sets.Mode.Att)
	sets.engaged.Shield.Axe.Crit = set_combine(sets.engaged.Shield.Axe, sets.Mode.Crit)
	sets.engaged.Shield.Axe.DA = set_combine(sets.engaged.Shield.Axe, sets.Mode.DA)
	sets.engaged.Shield.Axe.Haste = set_combine(sets.engaged.Shield.Axe, sets.Mode.Haste)
	sets.engaged.Shield.Axe.Skill = set_combine(sets.engaged.Shield.Axe, {})
	sets.engaged.Shield.Axe.sTP = set_combine(sets.engaged.Shield.Axe, sets.Mode.sTP)
	sets.engaged.Shield.Axe.STR = set_combine(sets.engaged.Shield.Axe, sets.Mode.STR)
	
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

    sets.engaged.repulse = {back="Repulse Mantle"}

    sets.enmity = {hands="Futhark Gloves +1",waist="Warwolf Belt"}

	--------------------------------------
	-- Precast sets
	--------------------------------------
	-- Weaponskill sets
	-- Default set for any weaponskill that isn't any more specifically defined
	sets.precast.WS = set_combine(sets.Mode.STR, {neck="Fotia Gorget",waist="Fotia Belt"})    
	sets.WSDayBonus = {} 

	-- Specific weaponskill sets.  Uses the base set if an appropriate WSMod version isn't found.
	sets.precast.WS = set_combine(sets.Mode.STR, {})
	sets.precast.WS.Acc = set_combine(sets.precast.WS, {})
 	-- Earth, STR 100%
	sets.precast.WS['Hard Slash'] = set_combine(sets.precast.WS, {neck="Soil Gorget",waist="Soil Belt"})
	
	-- Light, STR 60% VIT 60%
	sets.precast.WS['Power Slash'] = set_combine(sets.precast.WS, {neck="Light Gorget",waist="Light Belt"})
	
	-- Ice, STR 40% INT 40%
	sets.precast.WS['Frostbite'] = set_combine(sets.precast.WS, {neck="Snow Gorget",waist="Snow Belt"})
	
	-- Ice/Wind, STR 40% INT 40%
	sets.precast.WS['Freezebite'] = set_combine(sets.precast.WS, {neck="Snow Gorget",waist="Snow Belt"})
	
	-- Water, STR 30% MND 30%
	sets.precast.WS['Shockwaver'] = set_combine(sets.precast.WS, {neck="Aqua Gorget",waist="Aqua Belt"})
	
	-- Earth, STR 80% 
	sets.precast.WS['Crescent Moon'] = set_combine(sets.precast.WS, {neck="Soil Gorget",waist="Soil Belt"})
	
	-- Earth/Thunder, STR 40% AGI 40%
	sets.precast.WS['Sickle Moon'] = set_combine(sets.precast.WS, {neck="Soil Gorget",waist="Soil Belt"})
	
	-- Wind/Thunder, STR 30% INT 30%
	sets.precast.WS['Spinning Slash'] = set_combine(sets.precast.WS, {neck="Breeze Gorget",waist="Breeze Belt"})
	
	-- Wind/Thunder/Ice/Water, STR 50% INT 50%
	sets.precast.WS['Ground Strike'] = set_combine(sets.precast.WS, {neck="Breeze Gorget",waist="Breeze Belt"})
	
	-- Wind/Thunder/Ice, VIT 80%
	sets.precast.WS['Herculean Slash'] = set_combine(sets.precast.WS, {neck="Breeze Gorget",waist="Breeze Belt"})

	-- Wind/Thunder/Earth, STR 73%
    sets.precast.WS['Resolution'] = set_combine(sets.precast.WS,{
            head="Whirlpool Mask", neck="Breeze Gorget", ear1="Bladeborn Earring", ear2="Steelflash Earring",
            hands="Futhark Mitons +1", ring1="Epona's Ring", ring2="Rajas Ring",
            waist="Breeze Belt", legs="Quiahuiz Trousers", feet="Qaaxo Leggings"})
    sets.precast.WS['Resolution'].Acc = set_combine(sets.precast.WS['Resolution'], 
        {ammo="Honed Tathlum", hands="Umuthi Gloves", back="Evasionist's Cape", legs="Manibozho Brais"})
		
    -- Wind/Thunder/Fire/Light, DEX 80%
    sets.precast.WS['Dimidiation'] = set_combine(sets.precast.WS, {ammo="Amar Cluster",
            head="Felistris Mask", neck="Breeze Gorget", ear1="Bladeborn Earring", ear2="Steelflash Earring",
            hands="Futhark Mitons +1", ring1="Epona's Ring", ring2="Rajas Ring",
            back="Atheling Mantle", waist="Windbuffet Belt", legs="Manibozho Brais", feet="Qaaxo Leggings"})
    sets.precast.WS['Dimidiation'].Acc = set_combine(sets.precast.WS['Dimidiation'], 
        {ammo="Honed Tathlum", head="Whirlpool Mask", hands="Buremte Gloves", back="Evasionist's Cape", waist="Thunder Belt"})

	-- Precast sets to enhance JAs
    sets.precast.JA['Vallation'] = {body="Runeist Coat", legs="Futhark trousers +1"}
    sets.precast.JA['Valiance'] = sets.precast.JA['Vallation']
    sets.precast.JA['Pflug'] = {feet="Runeist Bottes"}
    sets.precast.JA['Battuta'] = {head="Futhark Bandeau +1"}
    sets.precast.JA['Liement'] = {body="Futhark Coat +1"}
    sets.precast.JA['Lunge'] = {head="Thaumas Hat", neck="Eddy Necklace", ear1="Novio Earring", ear2="Friomisi Earring",
            body="Vanir Cotehardie",ring2="Omega Ring",
            back="Evasionist's Cape", waist="Yamabuki-no-obi", legs="Iuitl Tights", feet="Qaaxo Leggings"}
    sets.precast.JA['Swipe'] = sets.precast.JA['Lunge']
    sets.precast.JA['Gambit'] = {hands="Runeist Mitons"}
    sets.precast.JA['Rayke'] = {feet="Futhark Bottes +1"}
    sets.precast.JA['Elemental Sforzo'] = {body="Futhark Coat 1"}
    sets.precast.JA['Swordplay'] = {hands="Futhark Mitons +1"}
    sets.precast.JA['Embolden'] = {}
    sets.precast.JA['Vivacious Pulse'] = {}
    sets.precast.JA['One For All'] = {}
    sets.precast.JA['Provoke'] = sets.enmity


	-- Fast cast sets for spells
    sets.precast.FC = {
            head="Runeist Bandeau",
            hands="Thaumas gloves", ring2="Prolix Ring",
            legs="Orvail Pants +1"}
    sets.precast.FC['Enhancing Magic'] = set_combine(sets.precast.FC, {neck="Melic Torque",ear2="Liminus Earring",waist="Siegel Sash", legs="Futhark Trousers +1"})
    sets.precast.FC['Divine Magic'] = set_combine(sets.precast.FC, {neck="Eddy Necklace",ear2="Liminus Earring"})
    sets.precast.FC['Utsusemi: Ichi'] = set_combine(sets.precast.FC, {neck='Magoraga beads'})
    sets.precast.FC['Utsusemi: Ni'] = set_combine(sets.precast.FC['Utsusemi: Ichi'], {})

	--------------------------------------
	-- Midcast sets
	--------------------------------------
	
	sets.midcast.FastRecast = {}     
    sets.midcast['Enhancing Magic'] = {neck="Melic Torque",ear2="Liminus Earring",hands="Runeist Mitons"}
    sets.midcast['Divine Magic'] = {ear2="Liminus Earring",waist="Yamabuki-no-Obi",legs="Runeist Trousers"}
    sets.midcast['Regen'] = {head="Runeist Bandeau", legs="Futhark Trousers +1"}
    sets.midcast['Stoneskin'] = {waist="Siegel Sash"}
    sets.midcast.Cure = {neck="Phalaina Locket",hands="Buremte Gloves", feet="Futhark Boots +1"}
	
	--Defense
	sets.defense.PDT = {head="Ejekamal Mask",neck="Twilight Torque",
		body="Iuitl Vest",hands="Umuthi Gloves"}

	sets.defense.MDT = {head="Ejekamal Mask",neck="Twilight Torque",
		body="Iuitl Vest",hands="Umuthi Gloves"}
	
	sets.defense.Evasion = {head="Whirlpool Mask",ear1="Ethereal Earring",
		body="Iuitl Vest",ring1="Alert Ring"}

	sets.Kiting = {feet="Skd. Jambeaux +1"}
end

------------------------------------------------------------------
-- Action events
------------------------------------------------------------------

-- Run after the default midcast() is done.
-- eventArgs is the same one used in job_midcast, in case information needs to be persisted.
function job_post_midcast(spell, action, spellMap, eventArgs)
    if spell.english == 'Lunge' or spell.english == 'Swipe' then
        local obi = get_obi(get_rune_obi_element())
        if obi then
            equip({waist=obi})
        end
    end
end


function job_aftercast(spell)
    if not spell.interrupted then
        if spell.type == 'Rune' then
            update_timers(spell)
        elseif spell.name == "Lunge" or spell.name == "Gambit" or spell.name == 'Rayke' then
            reset_timers()
        elseif spell.name == "Swipe" then
            send_command(trim(1))
        end
    end
end


-------------------------------------------------------------------------------------------------------------------
-- Customization hooks for idle and melee sets, after they've been automatically constructed.
-------------------------------------------------------------------------------------------------------------------

-------------------------------------------------------------------------------------------------------------------
-- General hooks for other events.
-------------------------------------------------------------------------------------------------------------------

-------------------------------------------------------------------------------------------------------------------
-- User code that supplements self-commands.
-------------------------------------------------------------------------------------------------------------------
-- Called for custom player commands.
function job_self_command(cmdParams, eventArgs)
 	handle_flags(cmdParams, eventArgs)
end
 
-- Called by the 'update' self-command, for common needs.
-- Set eventArgs.handled to true if we don't want automatic equipping of gear.
function job_update(cmdParams, eventArgs)
	classes.CustomMeleeGroups:clear()
	if areas.Adoulin:contains(world.area) and buffactive.ionis then
			classes.CustomMeleeGroups:append('Adoulin')
	end
	if areas.Assault:contains(world.area) then
			classes.CustomMeleeGroups:append('Assault')
	end
	pick_tp_weapon()
end
-------------------------------------------------------------------------------------------------------------------
-- Utility functions specific to this job.
-------------------------------------------------------------------------------------------------------------------

function determine_groups()
	-- add_to_chat(122,' determine groups')
	classes.CustomMeleeGroups:clear()
end

function get_rune_obi_element()
    weather_rune = buffactive[elements.rune_of[world.weather_element] or '']
    day_rune = buffactive[elements.rune_of[world.day_element] or '']
    
    local found_rune_element
    
    if weather_rune and day_rune then
        if weather_rune > day_rune then
            found_rune_element = world.weather_element
        else
            found_rune_element = world.day_element
        end
    elseif weather_rune then
        found_rune_element = world.weather_element
    elseif day_rune then
        found_rune_element = world.day_element
    end
    
    return found_rune_element
end

function get_obi(element)
    if element and elements.obi_of[element] then
        return (player.inventory[elements.obi_of[element]] or player.wardrobe[elements.obi_of[element]]) and elements.obi_of[element]
    end
end


------------------------------------------------------------------
-- Timer manipulation
------------------------------------------------------------------

-- Add a new run to the custom timers, and update index values for existing timers.
function update_timers(spell)
    local expires_time = os.time() + 300
    local entry_index = rune_count(spell.name) + 1

    local entry = {rune=spell.name, index=entry_index, expires=expires_time}

    rune_timers:append(entry)
    local cmd_queue = create_timer(entry).. ';wait 0.05;'
    
    cmd_queue = cmd_queue .. trim()

    add_to_chat(123,'cmd_queue='..cmd_queue)

    send_command(cmd_queue)
end

-- Get the command string to create a custom timer for the provided entry.
function create_timer(entry)
    local timer_name = '"Rune: ' .. entry.rune .. '-' .. tostring(entry.index) .. '"'
    local duration = entry.expires - os.time()
    return 'timers c ' .. timer_name .. ' ' .. tostring(duration) .. ' down'
end

-- Get the command string to delete a custom timer for the provided entry.
function delete_timer(entry)
    local timer_name = '"Rune: ' .. entry.rune .. '-' .. tostring(entry.index) .. '"'
    return 'timers d ' .. timer_name .. ''
end

-- Reset all timers
function reset_timers()
    local cmd_queue = ''
    for index,entry in pairs(rune_timers) do
        cmd_queue = cmd_queue .. delete_timer(entry) .. ';wait 0.05;'
    end
    rune_timers:clear()
    send_command(cmd_queue)
end

-- Get a count of the number of runes of a given type
function rune_count(rune)
    local count = 0
    local current_time = os.time()
    for _,entry in pairs(rune_timers) do
        if entry.rune == rune and entry.expires > current_time then
            count = count + 1
        end
    end
    return count
end

-- Remove the oldest rune(s) from the table, until we're below the max_runes limit.
-- If given a value n, remove n runes from the table.
function trim(n)
    local cmd_queue = ''

    local to_remove = n or (rune_timers:length() - max_runes)

    while to_remove > 0 and rune_timers:length() > 0 do
        local oldest
        for index,entry in pairs(rune_timers) do
            if oldest == nil or entry.expires < rune_timers[oldest].expires then
                oldest = index
            end
        end
        
        cmd_queue = cmd_queue .. prune(rune_timers[oldest].rune)
        to_remove = to_remove - 1
    end
    
    return cmd_queue
end

-- Drop the index of all runes of a given type.
-- If the index drops to 0, it is removed from the table.
function prune(rune)
    local cmd_queue = ''
    
    for index,entry in pairs(rune_timers) do
        if entry.rune == rune then
            cmd_queue = cmd_queue .. delete_timer(entry) .. ';wait 0.05;'
            entry.index = entry.index - 1
        end
    end

    for index,entry in pairs(rune_timers) do
        if entry.rune == rune then
            if entry.index == 0 then
                rune_timers[index] = nil
            else
                cmd_queue = cmd_queue .. create_timer(entry) .. ';wait 0.05;'
            end
        end
    end
    
    return cmd_queue
end


------------------------------------------------------------------
-- Reset events
------------------------------------------------------------------

windower.raw_register_event('zone change',reset_timers)
windower.raw_register_event('logout',reset_timers)
windower.raw_register_event('status change',function(new, old)
    if gearswap.res.statuses[new].english == 'Dead' then
        reset_timers()
    end
end)

function job_handle_equipping_gear(status, eventArgs)
	-- add_to_chat(122,'handle equiping gear')
	check_tp_lock()
	set_combat_form()
	pick_tp_weapon()
end

function select_default_macro_book()
    set_macro_page(1, 19)
	send_command('exec run.txt')
end

function job_buff_change(buff, gain)
	determine_groups()
	if player.sub_job == 'SAM' then
		handle_sam_ja()
	end
	if player.sub_job == 'WAR' then
		handle_war_ja()
	end
end

function customize_idle_set(idleSet)
	if buffactive['reive mark'] then
		idleSet = set_combine(idleSet, sets.Reive )
	end
    if player.mpp < 51 then
        idleSet = set_combine(idleSet, sets.latent_refresh)
    end
    return idleSet
end