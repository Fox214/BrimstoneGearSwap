include('organizer-lib.lua')
-------------------------------------------------------------------------------------------------------------------
-- Setup functions for this job.  Generally should not be modified.
-------------------------------------------------------------------------------------------------------------------

--[[
        Custom commands:

        Shorthand versions for each strategem type that uses the version appropriate for
        the current Arts.

                                        Light Arts              Dark Arts

        gs c scholar light              Light Arts/Addendum
        gs c scholar dark                                       Dark Arts/Addendum
        gs c scholar cost               Penury                  Parsimony
        gs c scholar speed              Celerity                Alacrity
        gs c scholar aoe                Accession               Manifestation
        gs c scholar power              Rapture                 Ebullience
        gs c scholar duration           Perpetuance
        gs c scholar accuracy           Altruism                Focalization
        gs c scholar enmity             Tranquility             Equanimity
        gs c scholar skillchain                                 Immanence
        gs c scholar addendum           Addendum: White         Addendum: Black
--]]



-- Initialization function for this job file.
function get_sets()
    mote_include_version = 2

    -- Load and initialize the include file.
    include('Mote-Include.lua')
end

-- Setup vars that are user-independent.  state.Buff vars initialized here will automatically be tracked.
function job_setup()
    info.addendumNukes = S{"Stone IV", "Water IV", "Aero IV", "Fire IV", "Blizzard IV", "Thunder IV",
        "Stone V", "Water V", "Aero V", "Fire V", "Blizzard V", "Thunder V"}

    state.Buff['Sublimation: Activated'] = buffactive['Sublimation: Activated'] or false
    update_active_strategems()
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
    state.CastingMode:options('Normal', 'INT', 'MAB', 'Macc', 'MDmg', 'Skill')
	state.IdleMode:options('Normal', 'PDT', 'Capacity')
	state.WeaponMode:set('Staff')
	state.Stance:set('None')
	state.holdtp:set('false')

    info.low_nukes = S{"Stone", "Water", "Aero", "Fire", "Blizzard", "Thunder"}
    info.mid_nukes = S{"Stone II", "Water II", "Aero II", "Fire II", "Blizzard II", "Thunder II",
                       "Stone III", "Water III", "Aero III", "Fire III", "Blizzard III", "Thunder III",
                       "Stone IV", "Water IV", "Aero IV", "Fire IV", "Blizzard IV", "Thunder IV",}
    info.high_nukes = S{"Stone V", "Water V", "Aero V", "Fire V", "Blizzard V", "Thunder V"}

    gear.macc_staff = { name="Grioavolr", augments={'Magic burst mdg.+3%','INT+6','Mag. Acc.+24','"Mag.Atk.Bns."+22',}}

    send_command('bind ^` input /ma Stun <t>')
	pick_tp_weapon()
    select_default_macro_book()
end

function user_unload()
    send_command('unbind ^`')
end


-- Define sets and vars used by this job file.
function init_gear_sets()
    --------------------------------------
    -- Start defining the sets
    --------------------------------------
	-- extra stuff
	-- need helix set
	organizer_items = {
		new1="Psycloth Lappas",
		new2="Infused Earring",
		new3="Eschan Stone",
		new4="Jokushu Chain",
		new5="Jhakri Cuffs +1",
		new6="Jhakri Coronal +1",
		new7="Jhakri Slops +1",
		new8="Jhakri Robe +1",
		new9="Jhakri Pigaches +1",
		new10="",
		new11="",
		new12="",
		new13="",
		new13="",
		new14="",
		new15="",
		new16="",
		new17="",
		new18="",
		new19="",
		new20="",
		new21="",
		new22="",
		food="Pear Crepe",
		echos="Echo Drops",
		-- shihei="Shihei",
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

    -- Idle sets (default idle set not needed since the other three are defined, but leaving for testing purposes)
    sets.idle = {ammo="Homiliary",
        head="Befouled Crown",neck="Twilight Torque",ear1="Ethereal Earring",ear2="Moonshade Earring",
        body="Amalric Doublet",hands="Amalric Gages",ring1="Vengeful Ring",ring2="Renaye Ring",
        back="Solemnity Cape",waist="Flax Sash",legs="Merlinic Shalwar",feet="Merlinic Crackows"}
	sets.idle.Capacity = set_combine(sets.idle, {back="Mecisto. Mantle"})
	sets.idle.Field = set_combine(sets.idle, {})
	
    sets.idle.Field.Stun = set_combine(sets.idle, {ammo="Incantor Stone",
        ear1="Psystorm Earring",ear2="Lifestorm Earring",
        feet="Acad. Loafers"})

    -- Resting sets
    sets.resting = set_combine(sets.idle, {})

    -- Engaged sets

    -- Variations for TP weapon and (optional) offense/defense modes.  Code will fall back on previous
    -- sets if more refined versions aren't defined.
    -- If you create a set with both offense and defense modes, the offense mode should be first.
    -- EG: sets.engaged.Club.Accuracy.Evasion

    -- Normal melee group
    sets.engaged = { ammo="Homiliary",
        head="Befouled Crown",neck="Sanctity Necklace",ear1="Bladeborn Earring",ear2="Steelflash Earring",
        body="Amalric Doublet",hands="Chironic Gloves",ring1="Patricius Ring",ring2="Apate Ring",
        legs="Miasmic Pants",feet="Battlecast Gaiters"}

	-- Sets with weapons defined.
	sets.engaged.Club = {}
	sets.engaged.Staff = {}

	-- Basic Mode definitions
	sets.Mode = {}
	sets.Mode.Acc = set_combine(sets.engaged, {ammo="Amar Cluster",neck="Iqabi Necklace",ear1="Zennaroi Earring",ear2="Digni. Earring",
		hands="Chironic Gloves",
		waist="Olseni Belt",legs="Miasmic Pants",feet="Battlecast Gaiters"})
	sets.Mode.Att= set_combine(sets.engaged, {neck="Sanctity Necklace",ear1="Bladeborn Earring",ear2="Dudgeon Earring",
		hands="Chironic Gloves",ring1="Overbearing Ring",feet="Chironic Slippers"})
	sets.Mode.Crit = set_combine(sets.engaged, {ring2="Hetairoi Ring"})
	sets.Mode.DA = set_combine(sets.engaged, {ring2="Hetairoi Ring"})
	sets.Mode.Haste = set_combine(sets.engaged, {feet="Battlecast Gaiters"})
	sets.Mode.Skill = set_combine(sets.engaged, {})
	sets.Mode.sTP = set_combine(sets.engaged, {ear2="Digni. Earring",waist="Olseni Belt",feet="Battlecast Gaiters"})
	sets.Mode.STR = set_combine(sets.engaged, { ammo="Amar Cluster",
		head="Buremte Hat",neck="Lacono Neck. +1",
		body="Shango Robe",hands="Vanya Cuffs",ring1="Rajas Ring",ring2="Apate Ring",
		back="Buquwik Cape",legs="Miasmic Pants",feet="Battlecast Gaiters"})
			
	sets.engaged.Club = set_combine(sets.engaged, {main="Bolelabunga",sub="Genmei Shield"})
	sets.engaged.Club.Acc = set_combine(sets.engaged.Club, sets.Mode.Acc)
	sets.engaged.Club.Att = set_combine(sets.engaged.Club, sets.Mode.Att)
	sets.engaged.Club.Crit = set_combine(sets.engaged.Club, sets.Mode.Crit)
	sets.engaged.Club.DA = set_combine(sets.engaged.Club, sets.Mode.DA)
	sets.engaged.Club.Haste = set_combine(sets.engaged.Club, sets.Mode.Haste)
	sets.engaged.Club.Skill = set_combine(sets.engaged.Club, sets.Mode.Skill, {})
	sets.engaged.Club.sTP = set_combine(sets.engaged.Club, sets.Mode.sTP)
	sets.engaged.Club.STR = set_combine(sets.engaged.Club, sets.Mode.STR)

	sets.engaged.Staff = set_combine(sets.engaged, {main="Akademos", sub="Mephitis Grip"})
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
    
	-- Dark/Earth/Light, MND 80%
    sets.precast.WS['Omniscience'] = set_combine(sets.precast.WS, {})
 
	-- none, INT 50% MND 50%
	sets.precast.WS['Spirit Taker'] = set_combine(sets.precast.WS, {})

    -- Precast Sets

    -- Precast sets to enhance JAs

    sets.precast.JA['Tabula Rasa'] = {legs="Pedagogy Pants"}

    -- Fast cast sets for spells

    sets.precast.FC = {ammo="Incantor Stone",
        head="Vanya Hood",neck="Baetyl Pendant",
        body="Shango Robe",
        back="Perimede Cape",waist="Channeler's Stone",legs="Orvail Pants +1",feet="Acad. Loafers"}

    sets.precast.FC['Enhancing Magic'] = set_combine(sets.precast.FC, {waist="Siegel Sash"})

    sets.precast.FC['Elemental Magic'] = set_combine(sets.precast.FC, {ear1="Barkaro. Earring"})

    sets.precast.FC.Cure = set_combine(sets.precast.FC, {body="Heka's Kalasiris",back="Pahtli Cape"})

    sets.precast.FC.Curaga = sets.precast.FC.Cure

    sets.precast.FC.Impact = set_combine(sets.precast.FC['Elemental Magic'], {head=empty,body="Twilight Cloak"})


    -- Midcast Sets
    -- sets.midcast.FastRecast = {feet="Tutyr Sabots"}

	-- healing skill
    sets.midcast.StatusRemoval = {neck="Nesanica Torque",ring1="Ephedra Ring",feet="Peda. Loafers"}

    sets.midcast.Cursna = set_combine(sets.midcast.StatusRemoval, {
        ring1="Ephedra Ring",
        feet="Gende. Galoshes"})
	
	-- Cure %+ > healing skill > MND
    sets.midcast.Cure = set_combine(sets.midcast.StatusRemoval, {main="Tamaxchi",sub="Genmei Shield",ammo="Incantor Stone",
        head="Vanya Hood",neck="Phalaina Locket",ear1="Lifestorm Earring",
        body="Heka's Kalasiris",hands="Telchine Gloves",
        back="Solemnity Cape",legs="Chironic Hose"})

    sets.midcast.CureWithLightWeather = set_combine(sets.midcast.Cure, {ammo="Incantor Stone",
        ear1="Lifestorm Earring",
        body="Heka's Kalasiris",
        back="Twilight Cape",waist="Hachirin-no-Obi"})

    sets.midcast.Curaga = sets.midcast.Cure

    sets.midcast.Regen = {main="Bolelabunga",head="Arbatel Bonnet",ear1="Pratik Earring",back="Lugh's Cape"}

    sets.midcast['Enhancing Magic'] = {ammo="Savant's Treatise",
        head="Befouled Crown",neck="Melic Torque",
        body="Argute Gown +2",hands="Chironic Gloves",
        back="Perimede Cape",feet="Rubeus Boots"}
	sets.midcast['Enhancing Magic']['Refresh'] = set_combine(sets.midcast['Enhancing Magic'],{
		back="Grapevine Cape"})
	sets.midcast['Enhancing Magic']['Aquaveil'] = set_combine(sets.midcast['Enhancing Magic'],{
		head="Chironic Hat"})

    sets.midcast.Stoneskin = set_combine(sets.midcast['Enhancing Magic'], {waist="Siegel Sash"})

    sets.midcast.Storm = set_combine(sets.midcast['Enhancing Magic'], {feet="Peda. Loafers"})

    sets.midcast.Protect = {}
    sets.midcast.Protectra = sets.midcast.Protect

    sets.midcast.Shell = {}
    sets.midcast.Shellra = sets.midcast.Shell

    -- Elemental Magic sets are default for handling low-tier nukes.
    sets.midcast['Elemental Magic'] = {main="Akademos",sub="Niobid Strap",ammo="Pemphredo Tathlum",
        head="Merlinic Hood",neck="Sanctity Necklace",ear1="Barkaro. Earring",ear2="Friomisi Earring",
        body="Merlinic Jubbah",hands="Amalric Gages",ring1="Strendu Ring",ring2="Perception Ring",
        back="Lugh's Cape",waist="Yamabuki-no-Obi",legs="Merlinic Shalwar",feet="Merlinic Crackows"}

    sets.midcast['Elemental Magic'].INT = set_combine(sets.midcast['Elemental Magic'], {main="Akademos",sub="Thrace Strap",ammo="Pemphredo Tathlum",
        head="Befouled Crown",neck="Imbodla Necklace",ear1="Psystorm Earring",
        body="Merlinic Jubbah",hands="Amalric Gages",ring1="Diamond Ring",
        back="Lugh's Cape",waist="Channeler's Stone",legs="Merlinic Shalwar",feet="Merlinic Crackows"})
    
	sets.midcast['Elemental Magic'].MAB = set_combine(sets.midcast['Elemental Magic'], {main="Akademos",sub="Niobid Strap",ammo="Pemphredo Tathlum",
        head="Merlinic Hood",neck="Baetyl Pendant",ear1="Barkaro. Earring",ear2="Friomisi Earring",
        body="Merlinic Jubbah",hands="Amalric Gages",ring1="Strendu Ring",
        back="Lugh's Cape",waist="Yamabuki-no-Obi",legs="Merlinic Shalwar",feet="Merlinic Crackows"})
    
	sets.midcast['Elemental Magic'].Macc = set_combine(sets.midcast['Elemental Magic'], {main=gear.macc_staff,sub="Niobid Strap",ammo="Pemphredo Tathlum",
        head="Merlinic Hood",neck="Sanctity Necklace",ear1="Barkaro. Earring",ear2="Digni. Earring",
        body="Merlinic Jubbah",hands="Chironic Gloves",ring1="Strendu Ring",ring2="Perception Ring",
        back="Lugh's Cape",waist="Luminary Sash",legs="Merlinic Shalwar",feet="Merlinic Crackows"})
    
	sets.midcast['Elemental Magic'].MDmg = set_combine(sets.midcast['Elemental Magic'], {main="Akademos",sub="Thrace Strap",ammo="Ghastly Tathlum +1",
        head="Buremte Hat",ear2="Crematio Earring",
        hands="Otomi Gloves",
        back="Lugh's Cape",legs="Merlinic Shalwar"})
    
	sets.midcast['Elemental Magic'].Skill = set_combine(sets.midcast['Elemental Magic'], { ammo="Savant's Treatise",
        head="Argute M.board",neck="Melic Torque",
        body="Academic's Gown",hands="Amalric Gages",
        back="Bookworm's Cape",legs="Pedagogy Pants",feet="Arbatel Loafers"})

    -- Custom refinements for certain nuke tiers
    -- sets.midcast['Elemental Magic'].HighTierNuke = set_combine(sets.midcast['Elemental Magic'], {})

    sets.midcast.Impact = set_combine(sets.midcast['Elemental Magic'].Macc, {ammo="Pemphredo Tathlum",
        head=empty,neck="Eddy Necklace",
        body="Twilight Cloak",hands="Amalric Gages",
        back="Toro Cape",waist="Luminary Sash",legs="Merlinic Shalwar",feet="Merlinic Crackows"})

    sets.midcast.Helix = set_combine(sets.midcast['Elemental Magic'].MDmg, {back="Bookworm's Cape"})

	-- Custom spell classes 
    sets.midcast.MndEnfeebles = set_combine(sets.midcast['Elemental Magic'].Macc, {main="Akademos",sub="Mephitis Grip", ammo="Savant's Treatise",
        head="Befouled Crown",neck="Imbodla Necklace",
        body="Academic's Gown",ring1="Globidonta Ring",
        legs="Chironic Hose",feet="Uk'uxkaj Boots"})

    sets.midcast.IntEnfeebles = set_combine(sets.midcast.MndEnfeebles, {})

    sets.midcast.ElementalEnfeeble = sets.midcast.IntEnfeebles

    sets.midcast['Dark Magic'] = set_combine(sets.midcast['Elemental Magic'].Macc, {
        body="Academic's Gown",
        back="Bookworm's Cape",legs="Pedagogy Pants"})

    sets.midcast.Kaustra = set_combine(sets.midcast['Dark Magic'], {ammo="Pemphredo Tathlum",
        head="Merlinic Hood",neck="Eddy Necklace",ear1="Barkaro. Earring",ear2="Friomisi Earring",
        body="Merlinic Jubbah",hands="Amalric Gages",ring1="Strendu Ring",
        back="Bookworm's Cape",waist="Wanion Belt",legs="Merlinic Shalwar",feet="Merlinic Crackows"})

    sets.midcast.Drain = set_combine(sets.midcast['Dark Magic'],{head="Merlinic Hood",ring2="Excelsis Ring",waist="Fucho-no-obi",feet="Merlinic Crackows"})

    sets.midcast.Aspir = sets.midcast.Drain

    sets.midcast.Stun = {ammo="Incantor Stone",
        neck="Sanctity Necklace",ear1="Psystorm Earring",ear2="Lifestorm Earring",
        back="Kumbira Cape",legs="Pedagogy Pants",feet="Acad. Loafers"}

    sets.midcast.Stun.Resistant = set_combine(sets.midcast.Stun, {})

    sets.midcast['Divine Magic'] = set_combine(sets.midcast['Elemental Magic'].Macc, {
        feet="Chironic Slippers"})
	
    -- Defense sets
    sets.defense.PDT = {
        neck="Twilight Torque",
        body="Merlinic Jubbah",hands="Hagondes Cuffs",ring1="Patricius Ring",
        back="Solemnity Cape",legs="Hagondes Pants +1",feet="Battlecast Gaiters"}

    sets.defense.MDT = {
        head="Vanya Hood",neck="Twilight Torque",
        body="Merlinic Jubbah",hands="Yaoyotl Gloves",ring2="Vengeful Ring",
        back="Solemnity Cape",waist="Flax Sash",legs="Hagondes Pants +1",feet="Merlinic Crackows"}
	
	sets.debuffed = set_combine(sets.defense.Evasion,sets.defense.PDT,sets.defense.MDT)
	
    sets.Kiting = {}

    sets.latent_refresh = {sub="Oneiros Grip",waist="Fucho-no-obi"}

    -- Buff sets: Gear that needs to be worn to actively enhance a current player buff.
    sets.buff['Ebullience'] = {head="Arbatel Bonnet"}
    sets.buff['Rapture'] = {head="Arbatel Bonnet"}
    sets.buff['Perpetuance'] = {hands="Arbatel Bracers +1"}
    sets.buff['Immanence'] = {hands="Arbatel Bracers +1"}
    sets.buff['Penury'] = {legs="Arbatel Pants"}
    sets.buff['Parsimony'] = {legs="Arbatel Pants"}
    sets.buff['Celerity'] = {feet="Peda. Loafers"}
    sets.buff['Alacrity'] = {feet="Peda. Loafers"}

    sets.buff['Klimaform'] = {feet="Arbatel Loafers"}

    sets.buff.FullSublimation = {head="Acad. Mortarboard",ear1="Savant's Earring",body="Argute Gown +2"}
    sets.buff.PDTSublimation = set_combine(sets.buff.FullSublimation,{})

    --sets.buff['Sandstorm'] = {feet="Desert Boots"}
end

-------------------------------------------------------------------------------------------------------------------
-- Job-specific hooks for standard casting events.
-------------------------------------------------------------------------------------------------------------------
function filtered_action(spell) 
    if find_degrade_table(spell) then
        degrade_spell(spell,find_degrade_table(spell))
    end
end

function job_pretarget(spell, action, spellMap, eventArgs)
	-- add_to_chat(1, 'pretarget Casting '..spell.name)
	if midaction() or pet_midaction() then
        cancel_spell()
        return
	end
end

function job_precast(spell, action, spellMap, eventArgs)
	if midaction() or pet_midaction() then
        cancel_spell()
        return
	end
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

-- Run after the general midcast() is done.
function job_post_midcast(spell, action, spellMap, eventArgs)
	if spell.skill == 'Elemental Magic' then
		if spell.skill == 'Elemental Magic' then
			-- add_to_chat(122,' elemental magic ')
			if spell.name:match('helix') then
				-- add_to_chat(122,' casting helix, post midcast ')
				equip(sets.midcast.Helix)
			end
			if is_magic_element_today(spell) then
				-- add_to_chat(122,' Element Day ')
				equip(sets.Day[spell.element])
			end
			if is_magic_element_weather(spell) then
				-- add_to_chat(122,' Element Weather ')
				equip(sets.Weather[spell.element])
			end
		end 
		if spell.action_type == 'Magic' then
			apply_grimoire_bonuses(spell, action, spellMap, eventArgs)
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
	handle_debuffs()
    if buff == "Sublimation: Activated" then
        handle_equipping_gear(player.status)
    end
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

-- Custom spell mapping.
function job_get_spell_map(spell, default_spell_map)
    if spell.action_type == 'Magic' then
        if default_spell_map == 'Cure' or default_spell_map == 'Curaga' then
            if world.weather_element == 'Light' then
                return 'CureWithLightWeather'
            end
        elseif spell.skill == 'Enfeebling Magic' then
            if spell.type == 'WhiteMagic' then
                return 'MndEnfeebles'
            else
                return 'IntEnfeebles'
            end
        elseif spell.skill == 'Elemental Magic' then
            if info.low_nukes:contains(spell.english) then
                return 'LowTierNuke'
            elseif info.mid_nukes:contains(spell.english) then
                return 'MidTierNuke'
            elseif info.high_nukes:contains(spell.english) then
                return 'HighTierNuke'
            end
        end
    end
end

function customize_idle_set(idleSet)
	-- add_to_chat(122,'idleset'..state.IdleMode.value)
    if state.Buff['Sublimation: Activated'] then
        if state.IdleMode.value == 'PDT' then
            idleSet = set_combine(idleSet, sets.buff.PDTSublimation)
        else
            idleSet = set_combine(idleSet, sets.buff.FullSublimation)
        end
    end
	if buffactive['reive mark'] then
		idleSet = set_combine(idleSet, sets.Reive )
	end
    if player.mpp < 51 then
        idleSet = set_combine(idleSet, sets.latent_refresh)
    end
	if state.IdleMode.value == 'Capacity' then
		idleSet = set_combine(idleSet, sets.idle.Capacity)
	end
    return idleSet
end

-- Called by the 'update' self-command.
function job_update(cmdParams, eventArgs)
    if cmdParams[1] == 'user' and not (buffactive['light arts']      or buffactive['dark arts'] or
                       buffactive['addendum: white'] or buffactive['addendum: black']) then
        if state.IdleMode.value == 'Stun' then
            send_command('@input /ja "Dark Arts" <me>')
        else
            send_command('@input /ja "Light Arts" <me>')
        end
    end

    update_active_strategems()
    update_sublimation()
	classes.CustomMeleeGroups:clear()
	if areas.Adoulin:contains(world.area) and buffactive.ionis then
			classes.CustomMeleeGroups:append('Adoulin')
	end
	if areas.Assault:contains(world.area) then
			classes.CustomMeleeGroups:append('Assault')
	end
	pick_tp_weapon()
end

function job_handle_equipping_gear(status, eventArgs)
	-- add_to_chat(122,'handle equiping gear')
	check_tp_lock()
	pick_tp_weapon()
end

-- Function to display the current relevant user state when doing an update.
-- Return true if display was handled, and you don't want the default info shown.
function display_current_job_state(eventArgs)
    display_current_caster_state()
    eventArgs.handled = true
end

-------------------------------------------------------------------------------------------------------------------
-- User code that supplements self-commands.
-------------------------------------------------------------------------------------------------------------------

-- Called for direct player commands.
function job_self_command(cmdParams, eventArgs)
    if cmdParams[1]:lower() == 'scholar' then
        handle_strategems(cmdParams)
        eventArgs.handled = true
    end
end

-------------------------------------------------------------------------------------------------------------------
-- Utility functions specific to this job.
-------------------------------------------------------------------------------------------------------------------

-- Reset the state vars tracking strategems.
function update_active_strategems()
    state.Buff['Ebullience'] = buffactive['Ebullience'] or false
    state.Buff['Rapture'] = buffactive['Rapture'] or false
    state.Buff['Perpetuance'] = buffactive['Perpetuance'] or false
    state.Buff['Immanence'] = buffactive['Immanence'] or false
    state.Buff['Penury'] = buffactive['Penury'] or false
    state.Buff['Parsimony'] = buffactive['Parsimony'] or false
    state.Buff['Celerity'] = buffactive['Celerity'] or false
    state.Buff['Alacrity'] = buffactive['Alacrity'] or false

    state.Buff['Klimaform'] = buffactive['Klimaform'] or false
end

function update_sublimation()
    state.Buff['Sublimation: Activated'] = buffactive['Sublimation: Activated'] or false
end

-- Equip sets appropriate to the active buffs, relative to the spell being cast.
function apply_grimoire_bonuses(spell, action, spellMap)
    if state.Buff.Perpetuance and spell.type =='WhiteMagic' and spell.skill == 'Enhancing Magic' then
        equip(sets.buff['Perpetuance'])
    end
    if state.Buff.Rapture and (spellMap == 'Cure' or spellMap == 'Curaga') then
        equip(sets.buff['Rapture'])
    end
    if spell.skill == 'Elemental Magic' and spellMap ~= 'ElementalEnfeeble' then
        if state.Buff.Ebullience and spell.english ~= 'Impact' then
            equip(sets.buff['Ebullience'])
        end
        if state.Buff.Immanence then
            equip(sets.buff['Immanence'])
        end
        if state.Buff.Klimaform and spell.element == world.weather_element then
            equip(sets.buff['Klimaform'])
        end
    end

    if state.Buff.Penury then equip(sets.buff['Penury']) end
    if state.Buff.Parsimony then equip(sets.buff['Parsimony']) end
    if state.Buff.Celerity then equip(sets.buff['Celerity']) end
    if state.Buff.Alacrity then equip(sets.buff['Alacrity']) end
end

-- General handling of strategems in an Arts-agnostic way.
-- Format: gs c scholar <strategem>
function handle_strategems(cmdParams)
    -- cmdParams[1] == 'scholar'
    -- cmdParams[2] == strategem to use

    if not cmdParams[2] then
        add_to_chat(123,'Error: No strategem command given.')
        return
    end
    local strategem = cmdParams[2]:lower()

    if strategem == 'light' then
        if buffactive['light arts'] then
            send_command('input /ja "Addendum: White" <me>')
        elseif buffactive['addendum: white'] then
            add_to_chat(122,'Error: Addendum: White is already active.')
        else
            send_command('input /ja "Light Arts" <me>')
        end
    elseif strategem == 'dark' then
        if buffactive['dark arts'] then
            send_command('input /ja "Addendum: Black" <me>')
        elseif buffactive['addendum: black'] then
            add_to_chat(122,'Error: Addendum: Black is already active.')
        else
            send_command('input /ja "Dark Arts" <me>')
        end
    elseif buffactive['light arts'] or buffactive['addendum: white'] then
        if strategem == 'cost' then
            send_command('input /ja Penury <me>')
        elseif strategem == 'speed' then
            send_command('input /ja Celerity <me>')
        elseif strategem == 'aoe' then
            send_command('input /ja Accession <me>')
        elseif strategem == 'power' then
            send_command('input /ja Rapture <me>')
        elseif strategem == 'duration' then
            send_command('input /ja Perpetuance <me>')
        elseif strategem == 'accuracy' then
            send_command('input /ja Altruism <me>')
        elseif strategem == 'enmity' then
            send_command('input /ja Tranquility <me>')
        elseif strategem == 'skillchain' then
            add_to_chat(122,'Error: Light Arts does not have a skillchain strategem.')
        elseif strategem == 'addendum' then
            send_command('input /ja "Addendum: White" <me>')
        else
            add_to_chat(123,'Error: Unknown strategem ['..strategem..']')
        end
    elseif buffactive['dark arts']  or buffactive['addendum: black'] then
        if strategem == 'cost' then
            send_command('input /ja Parsimony <me>')
        elseif strategem == 'speed' then
            send_command('input /ja Alacrity <me>')
        elseif strategem == 'aoe' then
            send_command('input /ja Manifestation <me>')
        elseif strategem == 'power' then
            send_command('input /ja Ebullience <me>')
        elseif strategem == 'duration' then
            add_to_chat(122,'Error: Dark Arts does not have a duration strategem.')
        elseif strategem == 'accuracy' then
            send_command('input /ja Focalization <me>')
        elseif strategem == 'enmity' then
            send_command('input /ja Equanimity <me>')
        elseif strategem == 'skillchain' then
            send_command('input /ja Immanence <me>')
        elseif strategem == 'addendum' then
            send_command('input /ja "Addendum: Black" <me>')
        else
            add_to_chat(123,'Error: Unknown strategem ['..strategem..']')
        end
    else
        add_to_chat(123,'No arts has been activated yet.')
    end
end


-- Gets the current number of available strategems based on the recast remaining
-- and the level of the sch.
function get_current_strategem_count()
    -- returns recast in seconds.
    local allRecasts = windower.ffxi.get_ability_recasts()
    local stratsRecast = allRecasts[231]

    local maxStrategems = (player.main_job_level + 10) / 20

    local fullRechargeTime = 4*60

    local currentCharges = math.floor(maxStrategems - maxStrategems * stratsRecast / fullRechargeTime)

    return currentCharges
end

-- Select default macro book on initial load or subjob change.
function select_default_macro_book()
	-- Default macro set/book
	if player.sub_job == 'DNC' then
		set_macro_page(1, 6)
	elseif player.sub_job == 'WAR' then
		set_macro_page(1, 6)
	elseif player.sub_job == 'NIN' then
		set_macro_page(1, 6)
	else
		set_macro_page(1, 6)
	end
	send_command('exec sch.txt')
end
