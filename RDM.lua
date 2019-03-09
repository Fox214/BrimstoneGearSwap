include('organizer-lib.lua')
-------------------------------------------------------------------------------------------------------------------
-- Setup functions for this job.  Generally should not be modified.
-------------------------------------------------------------------------------------------------------------------
--test this
-- Initialization function for this job file.
function get_sets()
    mote_include_version = 2

    -- Load and initialize the include file.
    include('Mote-Include.lua')
end


-- Setup vars that are user-independent.  state.Buff vars initialized here will automatically be tracked.
function job_setup()
    state.Buff.Saboteur = buffactive.saboteur or false
	state.WeaponMode = M{['description']='Weapon Mode', 'Sword', 'Dagger', 'Staff', 'Club'}
  	state.Stance = M{['description']='Stance', 'Off', 'None', 'Offensive', 'Defensive'}
	state.holdtp = M{['description']='holdtp', 'false', 'true'}
end

-------------------------------------------------------------------------------------------------------------------
-- User setup functions for this job.  Recommend that these be overridden in a sidecar file.
-------------------------------------------------------------------------------------------------------------------

-- Setup vars that are user-dependent.  Can override this function in a sidecar file.
function user_setup()
	state.OffenseMode:options('Normal', 'Acc', 'Att', 'Crit', 'DA', 'sTP', 'STR')
    state.CastingMode:options('Normal', 'INT', 'MAB', 'MB', 'Macc', 'Mcrit', 'MDmg', 'Skill')
    state.IdleMode:options('Normal', 'PDT', 'MDT')
 	state.WeaponMode:set('Sword')
	state.Stance:set('None')
	state.holdtp:set('false')

    gear.macc_staff = { name="Grioavolr", augments={'Magic burst dmg.+3%','INT+6','Mag. Acc.+24','"Mag.Atk.Bns."+22',}}

    pick_tp_weapon()
    
    select_default_macro_book()
end


-- Define sets and vars used by this job file.
function init_gear_sets()
	organizer_items = {
		new1="",
		new2="",
		new3="",
		new4="",
		new5="",
		new6="",
		new7="",
		new8="",
   		new9="",
		food="Pear Crepe",
		echos="Echo Drops",
		-- shihei="Shihei",
		orb="Macrocosmic Orb"
	}

    --------------------------------------
    -- Start defining the sets
    --------------------------------------
	sets.Day = {}
	sets.Day.Fire = {waist='Hachirin-no-Obi',back='Twilight Cape',ring2='Zodiac Ring'}
	sets.Day.Earth = {waist='Hachirin-no-Obi',back='Twilight Cape',ring2='Zodiac Ring'}
	sets.Day.Water = {waist='Hachirin-no-Obi',back='Twilight Cape',ring2='Zodiac Ring'}
	sets.Day.Wind = {waist='Hachirin-no-Obi',back='Twilight Cape',ring2='Zodiac Ring'}
	sets.Day.Ice = {waist='Hachirin-no-Obi',back='Twilight Cape',ring2='Zodiac Ring'}
	sets.Day.Thunder = {waist='Hachirin-no-Obi',back='Twilight Cape',ring2='Zodiac Ring'}
	sets.Day.Light = {waist='Hachirin-no-Obi',back='Twilight Cape',ring2='Zodiac Ring'}
	sets.Day.Dark = {waist='Hachirin-no-Obi',back='Twilight Cape',ring2='Zodiac Ring'}
	sets.Weather = {}
	sets.Weather.Fire = {waist='Hachirin-no-Obi',back='Twilight Cape'}
	sets.Weather.Earth = {waist='Hachirin-no-Obi',back='Twilight Cape'}
	sets.Weather.Water = {waist='Hachirin-no-Obi',back='Twilight Cape'}
	sets.Weather.Wind = {waist='Hachirin-no-Obi',back='Twilight Cape'}
	sets.Weather.Ice = {waist='Hachirin-no-Obi',back='Twilight Cape'}
	sets.Weather.Thunder = {waist='Hachirin-no-Obi',back='Twilight Cape'}
	sets.Weather.Light = {waist='Hachirin-no-Obi',back='Twilight Cape'}
	sets.Weather.Dark = {waist='Hachirin-no-Obi',back='Twilight Cape'}
 
    -- Normal refresh idle set
    sets.idle = {ammo="Homiliary",
        head="Viti. Chapeau +1",neck="Twilight Torque",ear1="Moonshade Earring",ear2="Ethereal Earring",
        body="Jhakri Robe +2",hands="Telchine Gloves",ring1="Defending Ring",ring2="Renaye Ring +1",
        back="Solemnity Cape",waist="Siegel Sash",legs="Carmine Cuisses +1",feet="Aya. Gambieras +2"}

    -- Resting sets
    sets.resting = set_combine(sets.idle, {main="Chatoyant Staff"})

    -- Normal melee group
    sets.engaged = { ammo="Ginsen",
        head="Aya. Zucchetto +2",neck="Asperity Necklace",ear1="Sherida Earring",ear2="Brutal Earring",
        body="Ayanmo Corazza +2",hands="Aya. Manopolas +2",ring1="Patricius Ring",ring2="Apate Ring",
        back="Ground. Mantle +1",waist="Sailfi Belt +1",legs="Carmine Cuisses +1",feet="Aya. Gambieras +2"}
		
	-- Sets with weapons defined.
	sets.engaged.Club = {}
	sets.engaged.Staff = {}
	sets.engaged.Sword = {}
	sets.engaged.Dagger = {}

	-- Basic Mode definitions
	sets.Mode = {}
	sets.Mode.Acc = set_combine(sets.engaged, {
        head="Aya. Zucchetto +2",
		body="Ayanmo Corazza +2",hands="Aya. Manopolas +2",ring1="Mars's Ring",ring2="Cacoethic Ring +1",
        legs="Carmine Cuisses +1",feet="Aya. Gambieras +2"})
	sets.Mode.Att= set_combine(sets.engaged, {
        head="Jhakri Coronal +2",neck="Anu Torque",
        body="Jhakri Robe +2",hands="Jhakri Cuffs +2",ring1="Overbearing Ring",ring2="Cho'j Band",
        waist="Sulla Belt",legs="Jhakri Slops +2",feet="Jhakri Pigaches +2"})
	sets.Mode.Crit = set_combine(sets.engaged, {feet="Aya. Gambieras +2"})
	sets.Mode.DA = set_combine(sets.engaged, {ear1="Sherida Earring",ear2="Brutal Earring",
        body="Ayanmo Corazza +2",legs="Zoar Subligar"})
	sets.Mode.sTP = set_combine(sets.engaged, {
        head="Aya. Zucchetto +2",neck="Anu Torque",ear1="Sherida Earring",ear2="Digni. Earring",
        legs="Jhakri Slops +2"})
	sets.Mode.STR = set_combine(sets.engaged, { ammo="Amar Cluster",
		head="Jhakri Coronal +2",neck="Lacono Neck. +1",ear1="Sherida Earring",
		body="Jhakri Robe +2",hands="Jhakri Cuffs +2",ring1="Rajas Ring",ring2="Apate Ring",
		back="Buquwik Cape",legs="Jhakri Slops +2",feet="Jhakri Pigaches +2"})
			
	sets.engaged.Sword = set_combine(sets.engaged, {main="Colada",sub="Genmei Shield"})
	sets.engaged.Sword.Acc = set_combine(sets.engaged.Sword, sets.Mode.Acc)
	sets.engaged.Sword.Att = set_combine(sets.engaged.Sword, sets.Mode.Att)
	sets.engaged.Sword.Crit = set_combine(sets.engaged.Sword, sets.Mode.Crit)
	sets.engaged.Sword.DA = set_combine(sets.engaged.Sword, sets.Mode.DA)
	sets.engaged.Sword.sTP = set_combine(sets.engaged.Sword, sets.Mode.sTP)
	sets.engaged.Sword.STR = set_combine(sets.engaged.Sword, sets.Mode.STR)
	
	sets.engaged.Club = set_combine(sets.engaged, {main="Bolelabunga",sub="Genmei Shield"})
	sets.engaged.Club.Acc = set_combine(sets.engaged.Club, sets.Mode.Acc)
	sets.engaged.Club.Att = set_combine(sets.engaged.Club, sets.Mode.Att)
	sets.engaged.Club.Crit = set_combine(sets.engaged.Club, sets.Mode.Crit)
	sets.engaged.Club.DA = set_combine(sets.engaged.Club, sets.Mode.DA)
	sets.engaged.Club.sTP = set_combine(sets.engaged.Club, sets.Mode.sTP)
	sets.engaged.Club.STR = set_combine(sets.engaged.Club, sets.Mode.STR)

	sets.engaged.Staff = set_combine(sets.engaged, {main=gear.macc_staff,sub="Niobid Strap"})
	sets.engaged.Staff.Acc = set_combine(sets.engaged.Staff, sets.Mode.Acc)
	sets.engaged.Staff.Att = set_combine(sets.engaged.Staff, sets.Mode.Att)
	sets.engaged.Staff.Crit = set_combine(sets.engaged.Staff, sets.Mode.Crit)
	sets.engaged.Staff.DA = set_combine(sets.engaged.Staff, sets.Mode.DA)
	sets.engaged.Staff.sTP = set_combine(sets.engaged.Staff, sets.Mode.sTP)
	sets.engaged.Staff.STR = set_combine(sets.engaged.Staff, sets.Mode.STR)

    -- Weaponskill sets
    -- Default set for any weaponskill that isn't any more specifically defined
	sets.precast.WS = set_combine(sets.Mode.STR, {neck="Fotia Gorget",ear2="Ishvara Earring",
        hands="Jhakri Cuffs +2",ring2="Epaminondas's Ring",waist="Fotia Belt"})    
    
	-- dark?, STR 30% MND 50% - use MAB
    sets.precast.WS['Sanguine Blade'] = set_combine(sets.precast.WS, {ammo="Witchstone",
        head="Jhakri Coronal +2",neck="Eddy Necklace",ear1="Friomisi Earring",
        ring1="Strendu Ring",
        back="Toro Cape"})

	-- Dark/Earth, MND 73%
	sets.precast.WS['Requiescat'] = set_combine(sets.precast.WS, {})

	-- none, INT 50% MND 50%
	sets.precast.WS['Spirit Taker'] = set_combine(sets.precast.WS, {})
   
    -- Precast sets to enhance JAs
    sets.precast.JA['Chainspell'] = {}

    -- Waltz set (chr and vit)
    sets.precast.Waltz = {
        head="Jhakri Coronal +2",ear1="Roundel Earring",
        body="Atrophy Tabard +1",hands="Jhakri Cuffs +2",
        back="Refraction Cape"}
        
    -- Don't need any special gear for Healing Waltz.
    sets.precast.Waltz['Healing Waltz'] = {}
    
    -- 80% Fast Cast (including trait) for all spells, plus 5% quick cast
    -- No other FC sets necessary.
    sets.precast.FC = {
        head="Atrophy Chapeau +1",neck="Orunmila's Torque",ear2="Loquacious Earring",
        body="Shango Robe",ring1="Kishar Ring",ring2="Prolix Ring",
        back="Swith Cape +1",waist="Witful Belt",legs="Aya. Cosciales +2",feet="Merlinic Crackows"}

    sets.precast.FC.Impact = set_combine(sets.precast.FC, {head=empty,body="Twilight Cloak"})
    
    -- Midcast Sets
    -- sets.midcast.FastRecast = {}

    sets.midcast.Cure = {main="Tamaxchi",sub="Genmei Shield",
        neck="Phalaina Locket",ear1="Roundel Earring",ear2="Loquacious Earring",
        body="Heka's Kalasiris",hands="Telchine Gloves",ring1="Ephedra Ring",ring2="Lebeche Ring",
        back="Swith Cape +1",waist="Witful Belt",legs="Gyve Trousers"}
        
    sets.midcast.Curaga = set_combine(sets.midcast.Cure, {})
    sets.midcast.CureSelf = set_combine(sets.midcast.Cure, {})
	
    sets.midcast.Regen = {main="Bolelabunga",ear1="Pratik Earring",body="Telchine Chas.",
		feet="Telchine Pigaches"}

    sets.midcast['Enhancing Magic'] = { main="Exemplar",
        head="Atrophy Chapeau +1",
        body="Telchine Chas.",hands="Atrophy Gloves +1",ring1="Prolix Ring",
        back="Sucellos's Cape",waist="Olympus Sash",legs="Atrophy Tights",feet="Leth. Houseaux +1"}

    sets.midcast.Refresh = {legs="Leth. Fuseau +1"}

    sets.midcast.Stoneskin = {waist="Siegel Sash"}

	-- Elemental Magic sets
	sets.midcast['Elemental Magic'] = {main=gear.macc_staff,sub="Enki Strap",ammo="Pemphredo Tathlum",
        head="Merlinic Hood",neck="Sanctity Necklace",ear1="Crematio Earring",ear2="Friomisi Earring",
        body="Merlinic Jubbah",hands="Jhakri Cuffs +2",ring1="Strendu Ring",ring2="Perception Ring",
        back="Sucellos's Cape",waist="Eschan Stone",legs="Merlinic Shalwar",feet="Merlinic Crackows"}

    sets.midcast['Elemental Magic'].INT = set_combine(sets.midcast['Elemental Magic'], 
	   {main=gear.macc_staff,sub="Enki Strap",ammo="Pemphredo Tathlum",
        head="Befouled Crown",neck="Imbodla Necklace",ear1="Strophadic Earring",ear2="Psystorm Earring",
        body="Jhakri Robe +2",hands="Jhakri Cuffs +2",ring1="Diamond Ring",
        back="Sucellos's Cape",waist="Channeler's Stone",legs="Jhakri Slops +2",feet="Jhakri Pigaches +2"})

    sets.midcast['Elemental Magic'].MAB = set_combine(sets.midcast['Elemental Magic'], 
	   {main=gear.macc_staff,sub="Niobid Strap",ammo="Pemphredo Tathlum",
        head="Merlinic Hood",neck="Baetyl Pendant",ear1="Crematio Earring",ear2="Friomisi Earring",
        body="Merlinic Jubbah",hands="Jhakri Cuffs +2",ring1="Strendu Ring",
        back="Sucellos's Cape",waist="Eschan Stone",legs="Hagondes Pants +1",feet="Merlinic Crackows"})
  
    sets.midcast['Elemental Magic'].MB = set_combine(sets.midcast['Elemental Magic'], {main=gear.macc_staff,
		neck="Mizu. Kubikazari",hands="Amalric Gages",back="Izdubar Mantle",feet="Jhakri Pigaches +2"})
  
	sets.midcast['Elemental Magic'].Macc = set_combine(sets.midcast['Elemental Magic'], 
	   {main=gear.macc_staff,sub="Enki Strap",ammo="Pemphredo Tathlum",
        head="Merlinic Hood",neck="Erra Pendant",ear1="Crematio Earring",ear2="Digni. Earring",
        body="Jhakri Robe +2",hands="Jhakri Cuffs +2",ring1="Kishar Ring",ring2="Perception Ring",
        back="Sucellos's Cape",waist="Luminary Sash",legs="Merlinic Shalwar",feet="Jhakri Pigaches +2"})
	
	sets.midcast['Elemental Magic'].Mcrit = set_combine(sets.midcast['Elemental Magic'], 
	   {body="Count's Garb",hands="Helios Gloves"})
   
    sets.midcast['Elemental Magic'].MDmg = set_combine(sets.midcast['Elemental Magic'], 
	   {main=gear.macc_staff,sub="Thrace Strap",ammo="Ghastly Tathlum +1",
        head="Buremte Hat",ear1="Crematio Earring",
        back="Sucellos's Cape",waist="Sekhmet Corset",legs="Hagondes Pants +1"})
 
    sets.midcast['Elemental Magic'].Skill = set_combine(sets.midcast['Elemental Magic'], 
	   {main="Exemplar",
        neck="Incanter's Torque",ear1="Strophadic Earring",feet="Navon Crackows"})
	
    sets.midcast['Enfeebling Magic'] = set_combine(sets.midcast['Elemental Magic'].Macc,  {main="Lehbrailg +2",sub="Mephitis Grip",
        head="Viti. Chapeau +1",neck="Weike Torque",ear1="Lifestorm Earring",ear2="Psystorm Earring",
        body="Lethargy Sayon +1",hands="Yaoyotl Gloves",ring1="Kishar Ring",ring2="Sangoma Ring",
        back="Sucellos's Cape"})

    sets.midcast['Dia III'] = set_combine(sets.midcast['Enfeebling Magic'], {head="Viti. Chapeau +1"})

    sets.midcast['Slow II'] = set_combine(sets.midcast['Enfeebling Magic'], {head="Viti. Chapeau +1"})
        
    sets.midcast.Impact = set_combine(sets.midcast['Elemental Magic'], {head=empty,body="Twilight Cloak"})

    sets.midcast['Dark Magic'] = set_combine(sets.midcast['Elemental Magic'].Macc, {main="Lehbrailg +2",sub="Mephitis Grip",
        head="Atrophy Chapeau +1",neck="Erra Pendant",ear1="Lifestorm Earring",ear2="Psystorm Earring",
        body="Vanir Cotehardie",ring1="Prolix Ring",ring2="Sangoma Ring",
        back="Refraction Cape"})

    --sets.midcast.Stun = set_combine(sets.midcast['Dark Magic'], {})

    sets.midcast.Drain = set_combine(sets.midcast['Dark Magic'], {ring1="Excelsis Ring", waist="Fucho-no-Obi"})

    sets.midcast.Aspir = set_combine(sets.midcast.Drain, {})

    -- Sets for special buff conditions on spells.
    sets.midcast.EnhancingDuration = {body="Telchine Chas.",hands="Atrophy Gloves +1",back="Sucellos's Cape",feet="Leth. Houseaux +1"}
        
    sets.buff.ComposureOther = {head="Estoqueur's Chappel +2",
        body="Lethargy Sayon +1",hands="Estoqueur's Gantherots +2",
        legs="Leth. Fuseau +1",feet="Leth. Houseaux +1"}

    sets.buff.Saboteur = {hands="Estoqueur's Gantherots +2"}

    -- Defense sets
    sets.defense.PDT = {
        head="Aya. Zucchetto +2",neck="Twilight Torque",ear2="Loquacious Earring",
        body="Ayanmo Corazza +2",hands="Aya. Manopolas +2",ring1="Defending Ring",
        back="Shadow Mantle",legs="Aya. Cosciales +2",feet="Aya. Gambieras +2"}

    sets.defense.MDT = {
        head="Aya. Zucchetto +2",neck="Twilight Torque",ear1="Etiolation Earring",ear2="Eabani Earring",
        body="Ayanmo Corazza +2",hands="Aya. Manopolas +2",ring1="Defending Ring",ring2="Shadow Ring",
        back="Reiki Cloak",legs="Aya. Cosciales +2",feet="Aya. Gambieras +2"}
		
	sets.debuffed = set_combine(sets.defense.Evasion,sets.defense.PDT,sets.defense.MDT)

    sets.Kiting = {legs="Carmine Cuisses +1"}

    sets.latent_refresh = {waist="Fucho-no-obi"}

end

-------------------------------------------------------------------------------------------------------------------
-- Job-specific hooks for standard casting events.
-------------------------------------------------------------------------------------------------------------------
function job_precast(spell, action, spellMap, eventArgs)
    if spellMap == 'Cure' or spellMap == 'Curaga' then
        handle_spells(spell)
    elseif spell.skill == 'Elemental Magic' then
		-- add_to_chat(1, 'Casting '..spell.name)
        handle_spells(spell)
        if state.CastingMode.value == 'Proc' then
            classes.CustomClass = 'Proc'
        end
    elseif spell.skill == 'Dark Magic' then
		handle_spells(spell)
    end
	check_ws_dist(spell)
end

-- Run after the default midcast() is done.
-- eventArgs is the same one used in job_midcast, in case information needs to be persisted.
function job_post_midcast(spell, action, spellMap, eventArgs)
    if spell.skill == 'Enfeebling Magic' and state.Buff.Saboteur then
        equip(sets.buff.Saboteur)
    elseif spell.skill == 'Enhancing Magic' then
        equip(sets.midcast.EnhancingDuration)
        if buffactive.composure and spell.target.type == 'PLAYER' then
            equip(sets.buff.ComposureOther)
        end
    elseif spellMap == 'Cure' and spell.target.type == 'SELF' then
        equip(sets.midcast.CureSelf)
    end
end

-------------------------------------------------------------------------------------------------------------------
-- Job-specific hooks for non-casting events.
-------------------------------------------------------------------------------------------------------------------
function job_handle_equipping_gear(status, eventArgs)
	-- add_to_chat(122,'handle equiping gear')
	check_tp_lock()
	pick_tp_weapon()
end

-- Handle notifications of general user state change.
function job_state_change(stateField, newValue, oldValue)
    if stateField == 'Offense Mode' then
        if newValue == 'None' then
            enable('main','sub','range')
        else
            disable('main','sub','range')
        end
    end
end

-------------------------------------------------------------------------------------------------------------------
-- User code that supplements standard library decisions.
-------------------------------------------------------------------------------------------------------------------

-- Modify the default idle set after it was constructed.
function customize_idle_set(idleSet)
    if player.mpp < 51 then
        idleSet = set_combine(idleSet, sets.latent_refresh)
    end
    
    return idleSet
end

-- Set eventArgs.handled to true if we don't want the automatic display to be run.
function display_current_job_state(eventArgs)
    display_current_caster_state()
    eventArgs.handled = true
end

-------------------------------------------------------------------------------------------------------------------
-- Utility functions specific to this job.
-------------------------------------------------------------------------------------------------------------------

-- Select default macro book on initial load or subjob change.
function select_default_macro_book()
    -- Default macro set/book
    if player.sub_job == 'DNC' then
        set_macro_page(2, 12)
    elseif player.sub_job == 'NIN' then
        set_macro_page(3, 12)
    elseif player.sub_job == 'THF' then
        set_macro_page(4, 12)
    else
        set_macro_page(1, 12)
    end
end

