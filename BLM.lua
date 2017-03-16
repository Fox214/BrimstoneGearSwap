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
	state.WeaponMode = M{['description']='Weapon Mode', 'Staff', 'Club', 'Scythe'}
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
    state.CastingMode:options('Normal', 'Death', 'INT', 'MAB', 'MB', 'Macc', 'Mcrit', 'MDmg', 'Skill', 'Proc')
	state.IdleMode:options('Normal', 'PDT', 'Capacity', 'Death')
 	state.WeaponMode:set('Staff')
	state.Stance:set('None')
	state.holdtp:set('false')
   
    -- state.MagicBurst = M(false, 'Magic Burst')

    lowTierNukes = S{'Stone', 'Water', 'Aero', 'Fire', 'Blizzard', 'Thunder',
        'Stone II', 'Water II', 'Aero II', 'Fire II', 'Blizzard II', 'Thunder II',
        'Stone III', 'Water III', 'Aero III', 'Fire III', 'Blizzard III', 'Thunder III',
        'Stonega', 'Waterga', 'Aeroga', 'Firaga', 'Blizzaga', 'Thundaga',
        'Stonega II', 'Waterga II', 'Aeroga II', 'Firaga II', 'Blizzaga II', 'Thundaga II'}

    gear.macc_staff = { name="Grioavolr", augments={'Magic burst dmg.+3%','INT+6','Mag. Acc.+24','"Mag.Atk.Bns."+22',}}
    
    -- Additional local binds
    send_command('bind ^` input /ma Stun <t>')
    -- send_command('bind @` gs c activate MagicBurst')
	pick_tp_weapon()
 
    select_default_macro_book()
end

-- Called when this job file is unloaded (eg: job change)
function user_unload()
    send_command('unbind ^`')
    send_command('unbind @`')
end


-- Define sets and vars used by this job file.
function init_gear_sets()
	organizer_items = {
		new1="Cacoethic Ring +1",
		new2="",
		new3="",
		new4="",
		new5="",
		new6="",
		new7="",
		new8="",
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
    sets.idle = {ammo="Pemphredo Tathlum",
        head="Befouled Crown",neck="Twilight Torque",ear1="Moonshade Earring",ear2="Ethereal Earring",
        body="Jhakri Robe +1",hands="Amalric Gages",ring1="Defending Ring",ring2="Renaye Ring",
        back="Solemnity Cape",waist="Siegel Sash",legs="Merlinic Shalwar",feet="Hippomenes Socks"}
	sets.idle.Capacity = set_combine(sets.idle, {back="Mecisto. Mantle"})
	sets.idle.Death = {main="Lathi",sub="Niobid Strap",ammo="Ghastly Tathlum +1",
		head="Pixie Hairpin +1",neck="Sanctity Necklace",ear1="Etiolation Earring",ear2="Evans Earring"}

    -- Resting sets
    sets.resting = set_combine(sets.idle, {main="Chatoyant Staff"})

    -- Normal melee group
    sets.engaged = { ammo="Amar Cluster",
        head="Jhakri Coronal +1",neck="Asperity Necklace",ear1="Bladeborn Earring",ear2="Steelflash Earring",
        body="Jhakri Robe +1",hands="Jhakri Cuffs +1",ring1="Patricius Ring",ring2="Apate Ring",
        back="Kumbira Cape",waist="Siegel Sash",legs="Miasmic Pants",feet="Jhakri Pigaches +1"}
		
	-- Sets with weapons defined.
	sets.engaged.Club = {}
	sets.engaged.Staff = {}

	-- Basic Mode definitions
	sets.Mode = {}
	sets.Mode.Acc = set_combine(sets.engaged, {ammo="Amar Cluster",
		head="Jhakri Coronal +1",neck="Iqabi Necklace",ear1="Zennaroi Earring",ear2="Digni. Earring",
		body="Jhakri Robe +1",hands="Jhakri Cuffs +1",
		waist="Olseni Belt",legs="Jhakri Slops +1",feet="Jhakri Pigaches +1"})
	sets.Mode.Att= set_combine(sets.engaged, {
		head="Jhakri Coronal +1",neck="Sanctity Necklace",ear1="Bladeborn Earring",ear2="Dudgeon Earring",
		body="Jhakri Robe +1",hands="Jhakri Cuffs +1",ring1="Overbearing Ring",
		waist="Eschan Stone",legs="Jhakri Slops +1",feet="Jhakri Pigaches +1"})
	sets.Mode.Crit = set_combine(sets.engaged, {ring2="Hetairoi Ring"})
	sets.Mode.DA = set_combine(sets.engaged, {ring2="Hetairoi Ring"})
	sets.Mode.Haste = set_combine(sets.engaged, {feet="Battlecast Gaiters"})
	sets.Mode.Skill = set_combine(sets.engaged, {})
	sets.Mode.sTP = set_combine(sets.engaged, {ear2="Digni. Earring",waist="Olseni Belt",legs="Jhakri Slops +1",feet="Battlecast Gaiters"})
	sets.Mode.STR = set_combine(sets.engaged, {ammo="Amar Cluster",
		head="Jhakri Coronal +1",neck="Lacono Neck. +1",
		body="Jhakri Robe +1",hands="Jhakri Cuffs +1",ring1="Rajas Ring",ring2="Apate Ring",
		back="Buquwik Cape",legs="Jhakri Slops +1",feet="Jhakri Pigaches +1"})
			
	sets.engaged.Club = set_combine(sets.engaged, {main="Bolelabunga",sub="Genmei Shield"})
	sets.engaged.Club.Acc = set_combine(sets.engaged.Club, sets.Mode.Acc)
	sets.engaged.Club.Att = set_combine(sets.engaged.Club, sets.Mode.Att)
	sets.engaged.Club.Crit = set_combine(sets.engaged.Club, sets.Mode.Crit)
	sets.engaged.Club.DA = set_combine(sets.engaged.Club, sets.Mode.DA)
	sets.engaged.Club.Haste = set_combine(sets.engaged.Club, sets.Mode.Haste)
	sets.engaged.Club.Skill = set_combine(sets.engaged.Club, sets.Mode.Skill, {})
	sets.engaged.Club.sTP = set_combine(sets.engaged.Club, sets.Mode.sTP)
	sets.engaged.Club.STR = set_combine(sets.engaged.Club, sets.Mode.STR)

	sets.engaged.Staff = set_combine(sets.engaged, {main="Lathi", sub="Niobid Strap"})
	sets.engaged.Staff.Acc = set_combine(sets.engaged.Staff, sets.Mode.Acc)
	sets.engaged.Staff.Att = set_combine(sets.engaged.Staff, sets.Mode.Att)
	sets.engaged.Staff.Crit = set_combine(sets.engaged.Staff, sets.Mode.Crit)
	sets.engaged.Staff.DA = set_combine(sets.engaged.Staff, sets.Mode.DA)
	sets.engaged.Staff.Haste = set_combine(sets.engaged.Staff, sets.Mode.Haste)
	sets.engaged.Staff.Skill = set_combine(sets.engaged.Staff, sets.Mode.Skill, {})
	sets.engaged.Staff.sTP = set_combine(sets.engaged.Staff, sets.Mode.sTP)
	sets.engaged.Staff.STR = set_combine(sets.engaged.Staff, sets.Mode.STR)
	
	sets.engaged.Scythe = set_combine(sets.engaged, {main="Ark Scythe", sub="Mephitis Grip"})
	sets.engaged.Scythe.Acc = set_combine(sets.engaged.Scythe, sets.Mode.Acc)
	sets.engaged.Scythe.Att = set_combine(sets.engaged.Scythe, sets.Mode.Att)
	sets.engaged.Scythe.Crit = set_combine(sets.engaged.Scythe, sets.Mode.Crit)
	sets.engaged.Scythe.DA = set_combine(sets.engaged.Scythe, sets.Mode.DA)
	sets.engaged.Scythe.Haste = set_combine(sets.engaged.Scythe, sets.Mode.Haste)
	sets.engaged.Scythe.Skill = set_combine(sets.engaged.Scythe, sets.Mode.Skill, {})
	sets.engaged.Scythe.sTP = set_combine(sets.engaged.Scythe, sets.Mode.sTP)
	sets.engaged.Scythe.STR = set_combine(sets.engaged.Scythe, sets.Mode.STR)

    -- Weaponskill sets
    -- Default set for any weaponskill that isn't any more specifically defined
	sets.precast.WS = set_combine(sets.Mode.STR, {neck="Fotia Gorget",ear2="Ishvara Earring",hands="Jhakri Cuffs +1",waist="Fotia Belt"})
    
	-- none, INT 50% MND 50%
	sets.precast.WS['Spirit Taker'] = set_combine(sets.precast.WS, {head="Befouled Crown",body="Supay Weskit"})
    
	-- Water/Ice/Thunder/Wind, INT 80%
	sets.precast.WS['Vidohunir'] = set_combine(sets.precast.WS, {
        ear1="Friomisi Earring",
        ring2="Diamond Ring",
        back="Toro Cape",legs="Hagondes Pants +1",feet="Merlinic Crackows"})
		
	-- self target, 20% mp recovered at 1k tp
	sets.precast.WS['Myrkr'] = set_combine(sets.precast.WS, {})	
		
    ---- Precast Sets ----
    
    -- Precast sets to enhance JAs
    sets.precast.JA['Mana Wall'] = {feet="Goetia Sabots +2"}
    sets.precast.JA['Elemental Seal'] = {}

    sets.precast.JA.Manafont = {body="Src. Coat +2"}
    
    -- equip to maximize HP (for Tarus) and minimize MP loss before using convert
    sets.precast.JA.Convert = {}


    -- Fast cast sets for spells

    sets.precast.FC = { 
		head="Vanya Hood",neck="Baetyl Pendant",ear1="Etiolation Earring",
        body="Shango Robe",
		back="Perimede Cape",waist="Channeler's Stone",legs="Psycloth Lappas",feet="Merlinic Crackows"}

    sets.precast.FC['Enhancing Magic'] = set_combine(sets.precast.FC, {neck="Incanter's Torque",waist="Siegel Sash"})

    sets.precast.FC['Elemental Magic'] = set_combine(sets.precast.FC, {head="Goetia Petasos +2",ear1="Barkaro. Earring"})

    sets.precast.FC.Cure = set_combine(sets.precast.FC, {body="Heka's Kalasiris", back="Pahtli Cape"})
    
    sets.precast.FC.Curaga = sets.precast.FC.Cure
	
	sets.precast.FC.Death = set_combine(sets.idle.Death,{})

    ---- Midcast Sets ----
	-- This is equiped first during casting, haste or recast- time can be used but gets overwritten by other midcast sets
    -- sets.midcast.FastRecast = {body="Goetia Coat +2",feet="Tutyr Sabots"}

	-- healing skill
    sets.midcast.StatusRemoval = {neck="Incanter's Torque",ring1="Ephedra Ring"}

	-- Cure %+ > healing skill > MND
    sets.midcast.Cure = set_combine(sets.midcast.StatusRemoval, {main="Tamaxchi",sub="Genmei Shield",
        head="Vanya Hood",neck="Phalaina Locket",
        body="Heka's Kalasiris",hands="Telchine Gloves",
        back="Solemnity Cape",legs="Tethyan Trews +3"})

    sets.midcast.Curaga = sets.midcast.Cure
	
	sets.midcast.Regen = {main="Bolelabunga",sub="Genmei Shield",ear1="Pratik Earring",body="Telchine Chas.",feet="Telchine Pigaches"}
    
	sets.midcast['Enhancing Magic'] = {
        head="Befouled Crown",neck="Incanter's Torque",ear1="Andoaa Earring",
        body="Telchine Chas.",hands="Telchine Gloves",
		back="Perimede Cape",feet="Rubeus Boots"}
	sets.midcast['Enhancing Magic']['Refresh'] = set_combine(sets.midcast['Enhancing Magic'],{
		back="Grapevine Cape"})

    sets.midcast.Stoneskin = set_combine(sets.midcast['Enhancing Magic'], {waist="Siegel Sash"})

	sets.midcast.Death = set_combine(sets.idle.Death,{})
	-- Elemental Magic sets
	sets.midcast['Elemental Magic'] = {main="Lathi",sub="Niobid Strap",ammo="Pemphredo Tathlum",
        head="Merlinic Hood",neck="Sanctity Necklace",ear1="Barkaro. Earring",ear2="Friomisi Earring",
        body="Merlinic Jubbah",hands="Amalric Gages",ring1="Strendu Ring",ring2="Perception Ring",
        back="Taranus's Cape",waist="Eschan Stone",legs="Merlinic Shalwar",feet="Merlinic Crackows"}

	sets.midcast['Elemental Magic'].Death = sets.midcast.Death
		
    sets.midcast['Elemental Magic'].INT = set_combine(sets.midcast['Elemental Magic'], 
	   {main="Lathi",sub="Thrace Strap",ammo="Pemphredo Tathlum",
        head="Befouled Crown",neck="Imbodla Necklace",ear1="Barkaro. Earring",ear2="Psystorm Earring",
        body="Merlinic Jubbah",hands="Yaoyotl Gloves",ring1="Diamond Ring",
        back="Taranus's Cape",waist="Channeler's Stone",legs="Hagondes Pants +1",feet="Merlinic Crackows"})

    sets.midcast['Elemental Magic'].MAB = set_combine(sets.midcast['Elemental Magic'], 
	   {main="Lathi",sub="Niobid Strap",ammo="Pemphredo Tathlum",
        head="Merlinic Hood",neck="Baetyl Pendant",ear1="Barkaro. Earring",ear2="Friomisi Earring",
        body="Merlinic Jubbah",hands="Helios Gloves",ring1="Strendu Ring",
        back="Taranus's Cape",waist="Eschan Stone",legs="Hagondes Pants +1",feet="Merlinic Crackows"})
  
    sets.midcast['Elemental Magic'].MB = set_combine(sets.midcast['Elemental Magic'], {main=gear.macc_staff,
		hands="Amalric Gages",back="Taranus's Cape",feet="Jhakri Pigaches +1"})
  
	sets.midcast['Elemental Magic'].Macc = set_combine(sets.midcast['Elemental Magic'], 
	   {main=gear.macc_staff,sub="Niobid Strap",ammo="Pemphredo Tathlum",
        head="Merlinic Hood",neck="Sanctity Necklace",ear1="Barkaro. Earring",ear2="Digni. Earring",
        body="Merlinic Jubbah",hands="Jhakri Cuffs +1",ring1="Strendu Ring",ring2="Perception Ring",
        back="Taranus's Cape",waist="Luminary Sash",legs="Merlinic Shalwar",feet="Merlinic Crackows"})
	
	sets.midcast['Elemental Magic'].Mcrit = set_combine(sets.midcast['Elemental Magic'], 
	   {body="Count's Garb",hands="Goetia Gloves +2"})
   
    sets.midcast['Elemental Magic'].MDmg = set_combine(sets.midcast['Elemental Magic'], 
	   {main="Lathi",sub="Thrace Strap",ammo="Ghastly Tathlum +1",
        head="Buremte Hat",ear1="Crematio Earring",
        body="Supay Weskit",hands="Otomi Gloves",
        back="Taranus's Cape",legs="Hagondes Pants +1",feet="Umbani Boots"})
 
    sets.midcast['Elemental Magic'].Skill = set_combine(sets.midcast['Elemental Magic'], 
	   {head="Goetia Petasos +2",neck="Incanter's Torque",
        body="Src. Coat +2",hands="Wzd. Gloves +1",
        back="Bane Cape",feet="Rubeus Boots"})

    -- Minimal damage gear for procs.
    sets.midcast['Elemental Magic'].Proc = {main="Chatoyant Staff", sub="Mephitis Grip",
        neck="Twilight Torque"}

    sets.midcast['Enfeebling Magic'] = set_combine(sets.midcast['Elemental Magic'].Macc, {main="Lathi",sub="Mephitis Grip",
        head="Befouled Crown",neck="Incanter's Torque",
        body="Shango Robe",ring1="Globidonta Ring",
        waist="Rumination Sash",legs="Psycloth Lappas",feet="Uk'uxkaj Boots"})
        
    sets.midcast.ElementalEnfeeble = sets.midcast['Enfeebling Magic']

    sets.midcast['Dark Magic'] = set_combine(sets.midcast['Elemental Magic'].Macc, {
        body="Shango Robe",neck="Incanter's Torque",hands="Src. Gloves +2",
        back="Bane Cape",feet="Goetia Sabots +2"})

    sets.midcast.Drain = set_combine(sets.midcast['Dark Magic'],{head="Merlinic Hood",ring2="Excelsis Ring",waist="Fucho-no-obi",feet="Merlinic Crackows"})
    
    sets.midcast.Aspir = sets.midcast.Drain
	sets.midcast.Aspir.Death = {main="Lathi",sub="Niobid Strap",ammo="Ghastly Tathlum +1"}

    sets.midcast.Stun = set_combine(sets.midcast['Dark Magic'],{})

    sets.midcast.BardSong = set_combine(sets.midcast['Elemental Magic'].Macc, {hands="Vanya Cuffs",neck="Incanter's Torque",
        back="Kumbira Cape"})
		
    -- Defense sets

    sets.defense.PDT = {
        head="Hagondes Hat",neck="Twilight Torque",
        body="Merlinic Jubbah",hands="Hagondes Cuffs",ring1="Defending Ring",ring2="Patricius Ring",
        back="Solemnity Cape",legs="Hagondes Pants +1",feet="Battlecast Gaiters"}

    sets.defense.MDT = {
        head="Vanya Hood",neck="Twilight Torque",ear1="Etiolation Earring",
        body="Merlinic Jubbah",hands="Yaoyotl Gloves",ring1="Defending Ring",ring2="Vengeful Ring",
        back="Solemnity Cape",waist="Flax Sash",legs="Hagondes Pants +1",feet="Merlinic Crackows"}

	sets.debuffed = set_combine(sets.defense.Evasion,sets.defense.PDT,sets.defense.MDT)
		
    sets.Kiting = {ring1="Vengeful Ring"}

    sets.latent_refresh = {sub="Oneiros Grip",waist="Fucho-no-obi"}

    -- Buff sets: Gear that needs to be worn to actively enhance a current player buff.
    sets.buff['Mana Wall'] = {back="Taranus's Cape",feet="Goetia Sabots +2"}
    -- sets.magic_burst = {hands="Amalric Gages",back="Taranus's Cape"}
	sets.RecoverMP = {body="Spae. Coat +1"}
	sets.Reive = {neck="Arciela's Grace +1"}
end

-------------------------------------------------------------------------------------------------------------------
-- Job-specific hooks for standard casting events.
-------------------------------------------------------------------------------------------------------------------

-- Set eventArgs.handled to true if we don't want any automatic gear equipping to be done.
-- Set eventArgs.useMidcastGear to true if we want midcast gear equipped on precast.
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

function job_post_precast(spell, action, spellMap, eventArgs)

end

-- Set eventArgs.handled to true if we don't want any automatic gear equipping to be done.
function job_midcast(spell, action, spellMap, eventArgs)

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
    if spell.skill == 'Elemental Magic' and default_spell_map ~= 'ElementalEnfeeble' then
        if player.mpp <= 21 then 
			equip(sets.RecoverMP) 
		end
    end
    -- if spell.skill == 'Elemental Magic' and state.MagicBurst.value then
        -- equip(sets.magic_burst)
    -- end
end

function job_aftercast(spell, action, spellMap, eventArgs)
    -- Lock feet after using Mana Wall.
    if not spell.interrupted then
        if spell.english == 'Mana Wall' then
            enable('feet')
            equip(sets.buff['Mana Wall'])
            disable('feet')
        -- elseif spell.skill == 'Elemental Magic' then
            -- state.MagicBurst:reset()
        end
    end
end

-------------------------------------------------------------------------------------------------------------------
-- Job-specific hooks for non-casting events.
-------------------------------------------------------------------------------------------------------------------

-- Called when a player gains or loses a buff.
-- buff == buff gained or lost
-- gain == true if the buff was gained, false if it was lost.
function job_buff_change(buff, gain)
    -- Unlock feet when Mana Wall buff is lost.
	handle_debuffs()
    if buff == "Mana Wall" and not gain then
        enable('feet')
        handle_equipping_gear(player.status)
    end
end

function job_handle_equipping_gear(status, eventArgs)
	-- add_to_chat(122,'handle equiping gear')
	check_tp_lock()
	pick_tp_weapon()
end

-- Handle notifications of general user state change.
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
-- Called by the 'update' self-command.
function job_update(cmdParams, eventArgs)
	pick_tp_weapon()
end

-- Custom spell mapping.
function job_get_spell_map(spell, default_spell_map)
    if spell.skill == 'Elemental Magic' and default_spell_map ~= 'ElementalEnfeeble' then
        --[[ No real need to differentiate with current gear.
        if lowTierNukes:contains(spell.english) then
            return 'LowTierNuke'
        else
            return 'HighTierNuke'
        end
        --]]
    end
end

-- Modify the default idle set after it was constructed.
function customize_idle_set(idleSet)
	if buffactive['reive mark'] then
		idleSet = set_combine(idleSet, sets.Reive )
	end
    if player.mpp < 51 then
        idleSet = set_combine(idleSet, sets.latent_refresh)
    end
    if state.CastingMode.value == 'Death' then
		idleSet = sets.idle.Death
	end
    return idleSet
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
    set_macro_page(1, 11)
	send_command('exec blm.txt')
end

