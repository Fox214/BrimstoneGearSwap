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
    indi_timer = ''
    indi_duration = 180
	state.WeaponMode = M{['description']='Weapon Mode', 'Staff', 'Club'}
  	state.Stance = M{['description']='Stance', 'Off', 'None', 'Offensive', 'Defensive'}
	state.holdtp = M{['description']='holdtp', 'false', 'true'}
	pick_tp_weapon()
end

-------------------------------------------------------------------------------------------------------------------
-- User setup functions for this job.  Recommend that these be overridden in a sidecar file.
-------------------------------------------------------------------------------------------------------------------

-- Setup vars that are user-dependent.  Can override this function in a sidecar file.
function user_setup()
	state.OffenseMode:options('Normal', 'Acc', 'Att', 'Crit', 'DA', 'Haste', 'Skill', 'sTP', 'STR')
    state.CastingMode:options('Normal', 'INT', 'MAB', 'Macc', 'MDmg', 'Skill', 'Proc')
	state.IdleMode:options('Normal', 'PDT', 'Capacity')
 	state.WeaponMode:set('Club')
	state.Stance:set('None')
	state.holdtp:set('false')

    gear.macc_staff = { name="Grioavolr", augments={'Enh. Mag. eff. dur. +2','MND+3','Mag. Acc.+25','"Mag.Atk.Bns."+11',}}

	pick_tp_weapon()
 
    select_default_macro_book()
end

-- Define sets and vars used by this job file.
function init_gear_sets()
	-- extra stuff
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
		new10="",
		new11="",
		new12="",
		new13="",
		new14="",
		new15="",
		new16="",
		new17="",
		new18="",
		new19="",
		echos="Echo Drops",
		-- shihei="Shihei",
		food="Pear Crepe",
		orb="Macrocosmic Orb"
	}	
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
    sets.idle = {ranged="Dunna",
        head="Befouled Crown",neck="Twilight Torque",ear1="Psystorm Earring",ear2="Lifestorm Earring",
        body="Amalric Doublet",hands="Bagua Mitaines",ring1="Strendu Ring",ring2="Renaye Ring",
        back="Kumbira Cape",waist="Siegel Sash",legs="Merlinic Shalwar",feet="Geomancy Sandals"}
	sets.idle.PDT = set_combine(sets.idle, {})
	sets.idle.Capacity = set_combine(sets.idle, {back="Mecisto. Mantle"})


   -- .Pet sets are for when Luopan is present.
    sets.idle.Pet = set_combine(sets.idle, {main="Solstice",sub="Genbu's Shield",range="Dunna",
        head="Azimuth Hood",neck="Twilight Torque",
        body="Amalric Doublet",hands="Geomancy Mitaines",ring2="Renaye Ring",
        back="Lifestream Cape",feet="Geomancy Sandals"})

    -- .Indi sets are for when an Indi-spell is active.
    sets.idle.Indi = set_combine(sets.idle, {legs="Bagua Pants"})
    sets.idle.Pet.Indi = set_combine(sets.idle.Pet, {legs="Bagua Pants"})

    -- Resting sets
    sets.resting = set_combine(sets.idle, {main="Chatoyant Staff"})

    -- Normal melee group
    sets.engaged = {ranged="Dunna",
        head="Befouled Crown",neck="Iqabi Necklace",ear1="Zennaroi Earring",ear2="Ethereal Earring",
        body="Amalric Doublet",hands="Telchine Gloves",ring1="Apate Ring",ring2="Patricius Ring",
        back="Kumbira Cape",waist="Olseni Belt",legs="Miasmic Pants",feet="Battlecast Gaiters"}
		
	-- Sets with weapons defined.
	sets.engaged.Club = {}
	sets.engaged.Staff = {}

	-- Basic Mode definitions
	sets.Mode = {}
	sets.Mode.Acc = set_combine(sets.engaged, {head="Mor. Coronal +1",neck="Iqabi Necklace",ear1="Zennaroi Earring",ear2="Digni. Earring",
		waist="Olseni Belt",legs="Miasmic Pants"})
	sets.Mode.Att= set_combine(sets.engaged, {neck="Sanctity Necklace",ear1="Bladeborn Earring",ear2="Dudgeon Earring",ring1="Overbearing Ring"})
	sets.Mode.Crit = set_combine(sets.engaged, {ring1="Hetairoi Ring"})
	sets.Mode.DA = set_combine(sets.engaged, {ring1="Hetairoi Ring"})
	sets.Mode.Haste = set_combine(sets.engaged, {})
	sets.Mode.Skill = set_combine(sets.engaged, {ear1="Terminus Earring",ear2="Liminus Earring",ring2="Prouesse Ring"})
	sets.Mode.sTP = set_combine(sets.engaged, {ear2="Digni. Earring",waist="Olseni Belt",feet="Battlecast Gaiters"})
	sets.Mode.STR = set_combine(sets.engaged, {
		head="Buremte Hat",neck="Lacono Neck. +1",
		body="Shango Robe",hands="Yaoyotl Gloves",ring1="Apate Ring",ring2="Rajas Ring",
		back="Buquwik Cape",legs="Miasmic Pants",feet="Battlecast Gaiters"})
			
	sets.engaged.Club = set_combine(sets.engaged, {main="Solstice",sub="Genbu's Shield"})
	sets.engaged.Club.Acc = set_combine(sets.engaged.Club, sets.Mode.Acc)
	sets.engaged.Club.Att = set_combine(sets.engaged.Club, sets.Mode.Att)
	sets.engaged.Club.Crit = set_combine(sets.engaged.Club, sets.Mode.Crit)
	sets.engaged.Club.DA = set_combine(sets.engaged.Club, sets.Mode.DA)
	sets.engaged.Club.Haste = set_combine(sets.engaged.Club, sets.Mode.Haste)
	sets.engaged.Club.Skill = set_combine(sets.engaged.Club, sets.Mode.Skill, {})
	sets.engaged.Club.sTP = set_combine(sets.engaged.Club, sets.Mode.sTP)
	sets.engaged.Club.STR = set_combine(sets.engaged.Club, sets.Mode.STR)

	sets.engaged.Staff = set_combine(sets.engaged, {main="Grioavolr", sub="Niobid Strap"})
	sets.engaged.Staff.Acc = set_combine(sets.engaged.Staff, sets.Mode.Acc)
	sets.engaged.Staff.Att = set_combine(sets.engaged.Staff, sets.Mode.Att)
	sets.engaged.Staff.Crit = set_combine(sets.engaged.Staff, sets.Mode.Crit)
	sets.engaged.Staff.DA = set_combine(sets.engaged.Staff, sets.Mode.DA)
	sets.engaged.Staff.Haste = set_combine(sets.engaged.Staff, sets.Mode.Haste)
	sets.engaged.Staff.Skill = set_combine(sets.engaged.Staff, sets.Mode.Skill, {})
	sets.engaged.Staff.sTP = set_combine(sets.engaged.Staff, sets.Mode.sTP)
	sets.engaged.Staff.STR = set_combine(sets.engaged.Staff, sets.Mode.STR)

    -- Weaponskill sets
    -- Default set for any weaponskill that isn't any more specifically defined
	sets.precast.WS = set_combine(sets.Mode.STR, {neck="Fotia Gorget",waist="Fotia Belt"})    
	
	-- none, INT 50% MND 50%
	sets.precast.WS['Spirit Taker'] = set_combine(sets.precast.WS, {})
 
    -- Specific weaponskill sets.  Uses the base set if an appropriate WSMod version isn't found.
	-- thunder, STR 40% MND 40%
    sets.precast.WS['Seraph Strike'] = set_combine(sets.precast.WS, {})
	
	-- none
    sets.precast.WS['Starlight'] = {ear2="Moonshade Earring"}

	-- none
    sets.precast.WS['Moonlight'] = {ear2="Moonshade Earring"}

	-- wind/thunder, STR 100%
    sets.precast.WS['True Strike'] = set_combine(sets.precast.WS, {})
    
	-- Water/Ice, STR 50% MND 50%
	sets.precast.WS['Flash Nova'] = {
        neck="Eddy Necklace",ear1="Friomisi Earring",ear2="Crematio Earring",
        body="Hagondes Coat",hands="Yaoyotl Gloves",ring2="Strendu Ring",
        back="Toro Cape",legs="Hagondes Pants +1",feet="Hagondes Sabots"}


    --------------------------------------
    -- Precast sets
    --------------------------------------

    -- Precast sets to enhance JAs
    sets.precast.JA.Bolster = {body="Bagua Tunic"}
    sets.precast.JA['Life cycle'] = {body="Geomancy Tunic"}
    sets.precast.JA['Full Circle'] = {head="Azimuth Hood",hands="Bagua Mitaines"}

    -- Fast cast sets for spells

    sets.precast.FC = {
        head="Vanya Hood",
        body="Shango Robe",
        back="Lifestream Cape",waist="Channeler's Stone",legs="Geomancy Pants"}

    sets.precast.FC.Cure = set_combine(sets.precast.FC, {main="Tamaxchi",sub="Genbu's Shield",back="Pahtli Cape"})

    sets.precast.FC['Elemental Magic'] = set_combine(sets.precast.FC, {ear1="Barkaro. Earring",hands="Bagua Mitaines"})

    --------------------------------------
    -- Midcast sets
    --------------------------------------
    sets.midcast['Elemental Magic'] = { main=gear.macc_staff,sub="Niobid Strap",ammo="Pemphredo Tathlum",
        head="Merlinic Hood",neck="Sanctity Necklace",ear1="Crematio Earring",ear2="Friomisi Earring",
        body="Amalric Doublet",hands="Amalric Gages",ring1="Strendu Ring",ring2="Perception Ring",
        back="Izdubar Mantle",waist="Yamabuki-no-Obi",legs="Merlinic Shalwar",feet="Merlinic Crackows"}

    sets.midcast['Elemental Magic'].INT = set_combine(sets.midcast['Elemental Magic'], 
	   {main=gear.macc_staff,sub="Niobid Strap",ammo="Pemphredo Tathlum",
        head="Merlinic Hood",neck="Imbodla Necklace",ear2="Psystorm Earring",
        body="Amalric Doublet",hands="Amalric Gages",ring1="Diamond Ring",
        back="Toro Cape",waist="Wanion Belt",legs="Merlinic Shalwar",feet="Merlinic Crackows"})

    sets.midcast['Elemental Magic'].MAB = set_combine(sets.midcast['Elemental Magic'], 
	   {main=gear.macc_staff,sub="Niobid Strap",ammo="Pemphredo Tathlum",
        head="Merlinic Hood",neck="Eddy Necklace",ear1="Crematio Earring",ear2="Friomisi Earring",
        body="Amalric Doublet",hands="Amalric Gages",ring1="Strendu Ring",
        back="Izdubar Mantle",waist="Yamabuki-no-Obi",legs="Merlinic Shalwar",feet="Merlinic Crackows"})
  
	sets.midcast['Elemental Magic'].Macc = set_combine(sets.midcast['Elemental Magic'], 
	   {main=gear.macc_staff,sub="Niobid Strap",ammo="Pemphredo Tathlum",
        head="Merlinic Hood",neck="Sanctity Necklace",ear1="Barkaro. Earring",ear2="Digni. Earring",
        body="Amalric Doublet",hands="Telchine Gloves",ring1="Strendu Ring",ring2="Perception Ring",
        back="Izdubar Mantle",waist="Luminary Sash",legs="Merlinic Shalwar",feet="Merlinic Crackows"})
   
    sets.midcast['Elemental Magic'].MDmg = set_combine(sets.midcast['Elemental Magic'], 
	   {main=gear.macc_staff,
        head="Buremte Hat",ear1="Crematio Earring",
        hands="Otomi Gloves",
        legs="Merlinic Shalwar"})
 
    sets.midcast['Elemental Magic'].Skill = set_combine(sets.midcast['Elemental Magic'], 
	   {head="Geomancy Galero",neck="Melic Torque",
		body="Azimuth Coat",
        hands="Amalric Gages",feet="Rubeus Boots"})

    sets.midcast['Enfeebling Magic'] = set_combine(sets.midcast['Elemental Magic'].Macc, {
        head="Befouled Crown",
        body="Shango Robe",hands="Azimuth Gloves",ring1="Globidonta Ring",
        back="Lifestream Cape",waist="Rumination Sash",feet="Bagua Sandals"})

    sets.midcast['Dark Magic'] = set_combine(sets.midcast['Elemental Magic'].Macc, {
        body="Geomancy Tunic",ring1="Strendu Ring",ring2="Diamond Ring",
        waist="Rumination Sash",legs="Azimuth Tights"})

    sets.midcast.Drain = set_combine(sets.midcast['Dark Magic'],{head="Bagua Galero",ring2="Excelsis Ring",waist="Fucho-no-obi",feet="Merlinic Crackows"})
    
    sets.midcast.Aspir = sets.midcast.Drain
		
	sets.midcast['Enhancing Magic'] = {head="Befouled Crown",neck="Melic Torque"}
	sets.midcast['Enhancing Magic']['Refresh'] = set_combine(sets.midcast['Enhancing Magic'],{
		back="Grapevine Cape"})
	
    -- Base fast recast for spells
    sets.midcast.FastRecast = {
        head="Zelus Tiara",
        legs="Hagondes Pants +1",feet="Hagondes Sabots"}

    sets.midcast.Geomancy = {range="Dunna",
		head="Azimuth Hood",neck="Melic Torque",ear2="Liminus Earring",
		body="Bagua Tunic",hands="Geomancy Mitaines",ring2="Renaye Ring",
		back="Lifestream Cape"}
    sets.midcast.Geomancy.Indi = set_combine(sets.midcast.Geomancy,{main="Solstice",back="Lifestream Cape",legs="Bagua Pants",feet="Azimuth Gaiters"})

	-- healing skill
    sets.midcast.StatusRemoval = {neck="Nesanica Torque",ring1="Ephedra Ring"}

	-- Cure %+ > healing skill > MND
    sets.midcast.Cure = set_combine(sets.midcast.StatusRemoval, {main="Tamaxchi",sub="Genbu's Shield",
        head="Vanya Hood",neck="Phalaina Locket",
		body="Heka's Kalasiris",hands="Telchine Gloves",
		waist="Rumination Sash",legs="Tethyan Trews +3"})
    
    sets.midcast.Curaga = sets.midcast.Cure

    sets.midcast.Protectra = {}

    sets.midcast.Shellra = {}

    -- Defense sets

    sets.defense.PDT = {
        head="Hagondes Hat",neck="Wiglen Gorget",
        body="Hagondes Coat",hands="Geomancy Mitaines",
        back="Umbra Cape",legs="Hagondes Pants +1",feet="Battlecast Gaiters"}

    sets.defense.MDT = {
        neck="Wiglen Gorget",
        body="Vanir Cotehardie",hands="Yaoyotl Gloves",ring1="Vengeful Ring",
        back="Umbra Cape",feet="Merlinic Crackows"}

    sets.Kiting = {feet="Geomancy Sandals"}

    sets.latent_refresh = {waist="Fucho-no-obi"}
 
end

-------------------------------------------------------------------------------------------------------------------
-- Job-specific hooks for standard casting events.
-------------------------------------------------------------------------------------------------------------------

function job_aftercast(spell, action, spellMap, eventArgs)
    if not spell.interrupted then
        if spell.english:startswith('Indi') then
            if not classes.CustomIdleGroups:contains('Indi') then
                classes.CustomIdleGroups:append('Indi')
            end
            send_command('@timers d "'..indi_timer..'"')
            indi_timer = spell.english
            send_command('@timers c "'..indi_timer..'" '..indi_duration..' down spells/00136.png')
        elseif spell.english == 'Sleep' or spell.english == 'Sleepga' then
            send_command('@timers c "'..spell.english..' ['..spell.target.name..']" 60 down spells/00220.png')
        elseif spell.english == 'Sleep II' or spell.english == 'Sleepga II' then
            send_command('@timers c "'..spell.english..' ['..spell.target.name..']" 90 down spells/00220.png')
        end
    elseif not player.indi then
        classes.CustomIdleGroups:clear()
    end
end


-------------------------------------------------------------------------------------------------------------------
-- Job-specific hooks for non-casting events.
-------------------------------------------------------------------------------------------------------------------

-- Called when a player gains or loses a buff.
-- buff == buff gained or lost
-- gain == true if the buff was gained, false if it was lost.
function job_buff_change(buff, gain)
    if player.indi and not classes.CustomIdleGroups:contains('Indi')then
        classes.CustomIdleGroups:append('Indi')
        handle_equipping_gear(player.status)
    elseif classes.CustomIdleGroups:contains('Indi') and not player.indi then
        classes.CustomIdleGroups:clear()
        handle_equipping_gear(player.status)
    end
end

function job_handle_equipping_gear(status, eventArgs)
	-- add_to_chat(122,'handle equiping gear')
	check_tp_lock()
	pick_tp_weapon()
end

function job_state_change(stateField, newValue, oldValue)
    if stateField == 'Offense Mode' then
        if newValue == 'Normal' then
            disable('main','sub','range')
        else
            enable('main','sub','range')
        end
    end
end

-------------------------------------------------------------------------------------------------------------------
-- User code that supplements standard library decisions.
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
	check_ws_dist()
end

function job_post_precast(spell, action, spellMap, eventArgs)

end

function job_post_midcast(spell, action, spellMap, eventArgs)
	if spell.skill == 'Elemental Magic' then
	-- add_to_chat(122,' elemental magic ')
        if is_magic_element_today(spell) then
			-- add_to_chat(122,' Element Day ')
            equip(sets.Day[spell.element])
        end
        if is_magic_element_weather(spell) then
			-- add_to_chat(122,' Element Weather ')
            equip(sets.Weather[spell.element])
        end
	end 
end

function job_get_spell_map(spell, default_spell_map)
    if spell.action_type == 'Magic' then
        if spell.skill == 'Enfeebling Magic' then
            if spell.type == 'WhiteMagic' then
                return 'MndEnfeebles'
            else
                return 'IntEnfeebles'
            end
        elseif spell.skill == 'Geomancy' then
            if spell.english:startswith('Indi') then
                return 'Indi'
            end
        end
    end
end

function customize_idle_set(idleSet)
	if buffactive['reive mark'] then
		idleSet = set_combine(idleSet, sets.Reive )
	end
    if player.mpp < 51 then
        idleSet = set_combine(idleSet, sets.latent_refresh)
    end
	-- add_to_chat(122,'cust idle')
    if pet.isvalid then
		-- add_to_chat(122,'pet valid')
        idleSet = set_combine(idleSet, sets.idle.Pet)
		if buffactive['indi'] then
			add_to_chat(122,'PET Indi')
			idleSet = set_combine(idleSet, sets.idle.Pet.Indi)
		end
    end
    return idleSet
end

-- Called by the 'update' self-command.
function job_update(cmdParams, eventArgs)
    classes.CustomIdleGroups:clear()
    if player.indi then
        classes.CustomIdleGroups:append('Indi')
    end
end

-- Function to display the current relevant user state when doing an update.
function display_current_job_state(eventArgs)
    display_current_caster_state()
    eventArgs.handled = true
end

-------------------------------------------------------------------------------------------------------------------
-- Utility functions specific to this job.
-------------------------------------------------------------------------------------------------------------------

-- Select default macro book on initial load or subjob change.
function select_default_macro_book()
    set_macro_page(3, 20)
	send_command('exec geo.txt')
end

function get_combat_form()
	set_combat_form()
end
