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
    state.Buff['Afflatus Solace'] = buffactive['Afflatus Solace'] or false
    state.Buff['Afflatus Misery'] = buffactive['Afflatus Misery'] or false
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
	state.OffenseMode:options('Normal', 'Acc', 'Att', 'Crit', 'DA', 'sTP', 'STR')
    state.CastingMode:options('Normal', 'Resistant')
    state.IdleMode:options('Normal', 'PDT', 'Capacity')
	state.WeaponMode:set('Club')
	state.Stance:set('None')
	state.holdtp:set('false')
	gear.macc_staff = { name="Grioavolr", augments={'Magic burst dmg.+3%','INT+6','Mag. Acc.+24','"Mag.Atk.Bns."+22',}}
	
	pick_tp_weapon()

    select_default_macro_book()
end

-- Define sets and vars used by this job file.
function init_gear_sets()
    --------------------------------------
    -- Start defining the sets
    --------------------------------------
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
		echos="Echo Drops",
		-- shihei="Shihei",
		orb="Macrocosmic Orb"
	}
    -- Idle sets (default idle set not needed since the other three are defined, but leaving for testing purposes)
    sets.idle = { ammo="Homiliary",
        head="Befouled Crown",neck="Twilight Torque",ear1="Moonshade Earring",ear2="Ethereal Earring",
        body="Theo. Briault +2",hands="Telchine Gloves",ring1="Defending Ring",ring2="Renaye Ring +1",
        back="Solemnity Cape",waist="Flax Sash",legs="Aya. Cosciales +2",feet="Inyan. Crackows +1"}

    -- Resting sets
    sets.resting = set_combine(sets.idle, {})

    -- Normal melee group
    sets.engaged = {
        head="Aya. Zucchetto +2",neck="Iqabi Necklace",ear1="Bladeborn Earring",ear2="Steelflash Earring",
        body="Ayanmo Corazza +2",hands="Aya. Manopolas +2",ring1="Patricius Ring",ring2="Hetairoi Ring",
        back="Pahtli Cape",waist="Olseni Belt",legs="Aya. Cosciales +2",feet="Aya. Gambieras +2"}

	-- Sets with weapons defined.
	sets.engaged.Club = {}
	sets.engaged.Staff = {}

	-- Basic Mode definitions
	sets.Mode = {}
	sets.Mode.Acc = set_combine(sets.engaged, {
        head="Aya. Zucchetto +2",ear1="Zennaroi Earring",ear2="Digni. Earring",
		body="Ayanmo Corazza +2",hands="Aya. Manopolas +2",ring1="Mars's Ring",ring2="Cacoethic Ring +1",
		waist="Olseni Belt",legs="Aya. Cosciales +2",feet="Aya. Gambieras +2"})
	sets.Mode.Att = set_combine(sets.engaged, {
        neck="Sanctity Necklace",ear1="Bladeborn Earring",ear2="Dudgeon Earring",
        ring1="Overbearing Ring",ring2="Cho'j Band",
		waist="Eschan Stone",legs="Querkening Brais",feet="Chironic Slippers"})
	sets.Mode.Crit = set_combine(sets.engaged, {ring1="Hetairoi Ring",feet="Aya. Gambieras +2"})
	sets.Mode.DA = set_combine(sets.engaged, {
        ear1="Trux Earring",ear2="Brutal Earring",
        body="Ayanmo Corazza +2",ring1="Hetairoi Ring",
        legs="Querkening Brais"})
	sets.Mode.sTP = set_combine(sets.engaged, {
        head="Aya. Zucchetto +2",ear2="Digni. Earring",waist="Yemaya Belt",feet="Battlecast Gaiters"})
	sets.Mode.STR = set_combine(sets.engaged, { ammo="Amar Cluster",
		head="Aya. Zucchetto +2",neck="Lacono Neck. +1",
		body="Ayanmo Corazza +2",hands="Aya. Manopolas +2",ring1="Rajas Ring",ring2="Apate Ring",
		back="Buquwik Cape",legs="Aya. Cosciales +2",feet="Aya. Gambieras +2"})
			
	sets.engaged.Club = set_combine(sets.engaged, {main="Izcalli",sub="Genmei Shield"})
	sets.engaged.Club.Acc = set_combine(sets.engaged.Club, sets.Mode.Acc)
	sets.engaged.Club.Att = set_combine(sets.engaged.Club, sets.Mode.Att)
	sets.engaged.Club.Crit = set_combine(sets.engaged.Club, sets.Mode.Crit)
	sets.engaged.Club.DA = set_combine(sets.engaged.Club, sets.Mode.DA)
	sets.engaged.Club.sTP = set_combine(sets.engaged.Club, sets.Mode.sTP)
	sets.engaged.Club.STR = set_combine(sets.engaged.Club, sets.Mode.STR)

	sets.engaged.Staff = set_combine(sets.engaged, {main=gear.macc_staff, sub="Enki Strap"})
	sets.engaged.Staff.Acc = set_combine(sets.engaged.Staff, sets.Mode.Acc)
	sets.engaged.Staff.Att = set_combine(sets.engaged.Staff, sets.Mode.Att)
	sets.engaged.Staff.Crit = set_combine(sets.engaged.Staff, sets.Mode.Crit)
	sets.engaged.Staff.DA = set_combine(sets.engaged.Staff, sets.Mode.DA)
	sets.engaged.Staff.sTP = set_combine(sets.engaged.Staff, sets.Mode.sTP)
	sets.engaged.Staff.STR = set_combine(sets.engaged.Staff, sets.Mode.STR)

    -- Weaponskill sets
    -- Default set for any weaponskill that isn't any more specifically defined
	sets.precast.WS = set_combine(sets.Mode.STR, {neck="Fotia Gorget",ear2="Ishvara Earring",
        ring2="Epaminondas's Ring",waist="Fotia Belt"})    
    
	-- Ice/Water, STR 50% MND 50%
    sets.precast.WS['Flash Nova'] = set_combine(sets.precast.WS, {
        ear1="Friomisi Earring",
        hands="Yaoyotl Gloves",ring1="Rajas Ring",ring2="Strendu Ring",
        back="Toro Cape",legs="Gende. Spats +1",feet="Gendewitha Galoshes"})
 
	-- none, INT 50% MND 50%
	sets.precast.WS['Spirit Taker'] = set_combine(sets.precast.WS, {})

    -- Precast Sets
    -- Fast cast sets for spells
    sets.precast.FC = {main=gear.FastcastStaff,ammo="Incantor Stone",
        head="Vanya Hood",neck="Orunmila's Torque",ear1="Etiolation Earring",
        body="Inyanga Jubbah +1",ring1="Kishar Ring",ring2="Prolix Ring",
        back="Alaunus's Cape",waist="Channeler's Stone",legs="Aya. Cosciales +2",feet="Navon Crackows"}
        
    sets.precast.FC['Enhancing Magic'] = set_combine(sets.precast.FC, {waist="Siegel Sash"})

    sets.precast.FC.Stoneskin = set_combine(sets.precast.FC['Enhancing Magic'], {head="Umuthi Hat",body="Ebers Bliaud"})

    sets.precast.FC['Healing Magic'] = set_combine(sets.precast.FC, {legs="Ebers Pantaloons"})

    sets.precast.FC.StatusRemoval = set_combine(sets.precast.FC['Healing Magic'])

    sets.precast.FC.Cure = set_combine(sets.precast.FC['Healing Magic'], {main="Queller Rod",sub="Genmei Shield",
		head="Theo. Cap +1",
        back="Pahtli Cape"})
    sets.precast.FC.Curaga = set_combine(sets.precast.FC.Cure, {})
    sets.precast.FC.CureSolace = set_combine(sets.precast.FC.Cure, {})
    -- CureMelee spell map should default back to Healing Magic.
    
    -- Precast sets to enhance JAs
    sets.precast.JA.Benediction = {body="Piety Briault +1"}

    -- Waltz set (chr and vit)
    sets.precast.Waltz = {ear2="Roundel Earring"}
    
    -- Midcast Sets
    -- sets.midcast.FastRecast = {}
    
    -- Cure sets
    sets.midcast.CureMelee = {ammo="Incantor Stone",
        head="Ebers Cap +1",neck="Phalaina Locket",ear1="Glorious Earring",ear2="Roundel Earring",
        body="Theo. Briault +2",hands="Telchine Gloves",ring1="Ephedra Ring",ring2="Lebeche Ring",
        back="Solemnity Cape",legs="Sifahir Slacks",feet="Piety Duckbills +1"}

	sets.midcast.Cure = set_combine(sets.midcast.CureMelee, {main="Queller Rod",sub="Genmei Shield"})

    sets.midcast.CureSolace =  set_combine(sets.midcast.CureMelee, {main="Queller Rod",sub="Genmei Shield",
        body="Ebers Bliaud",back="Alaunus's Cape"})

    sets.midcast.Curaga = set_combine(sets.midcast.CureMelee, {main="Queller Rod",sub="Genmei Shield"})

    sets.midcast.StatusRemoval = {
        head="Ebers Cap +1",neck="Incanter's Torque",hands="Inyan. Dastanas +1",ring1="Ephedra Ring",
		back="Mending Cape",legs="Piety Pantaln. +1"}

    sets.midcast.Cursna = set_combine(sets.midcast.StatusRemoval, {
        head="Ebers Cap +1",neck="Incanter's Torque",
        body="Ebers Bliaud",ring1="Ephedra Ring",
        back="Alaunus's Cape",legs="Theo. Pant. +1",feet="Gende. Galoshes"})

    -- 110 total Enhancing Magic Skill; caps even without Light Arts
    sets.midcast['Enhancing Magic'] = { main="Exemplar",sub="Enki Strap",
        head="Befouled Crown",neck="Incanter's Torque",ear1="Andoaa Earring",
        body="Telchine Chas.",hands="Telchine Gloves",
        back="Mending Cape",legs="Piety Pantaln. +1",feet="Telchine Pigaches"}
	sets.midcast['Enhancing Magic']['Refresh'] = set_combine(sets.midcast['Enhancing Magic'],{
		back="Grapevine Cape"})
	sets.midcast['Enhancing Magic']['Aquaveil'] = set_combine(sets.midcast['Enhancing Magic'],{
		head="Chironic Hat"})
		
    sets.midcast.Stoneskin = set_combine(sets.midcast['Enhancing Magic'],{
        neck="Orison Locket",
        waist="Siegel Sash",legs="Gende. Spats +1",feet="Gende. Galoshes"})

    sets.midcast.Auspice = {feet="Ebers Duckbills"}

    sets.midcast.BarElement = {
        head="Ebers Cap +1",
        body="Ebers Bliaud",hands="Ebers Mitts",
        back="Mending Cape",legs="Piety Pantaln. +1",feet="Ebers Duckbills"}

    sets.midcast.Regen = {main="Bolelabunga",sub="Genmei Shield",
		head="Inyanga Tiara +1",ear1="Pratik Earring",
        body="Piety Briault +1",hands="Ebers Mitts",
        legs="Theo. Pant. +1"}

    sets.midcast.Protectra = {feet="Piety Duckbills +1"}

    sets.midcast.Shellra = {legs="Piety Pantaln. +1"}

    sets.midcast['Divine Magic'] = {main=gear.macc_staff,sub="Enki Strap",ammo="Pemphredo Tathlum",
        head="Chironic Hat",neck="Jokushu Chain",ear1="Psystorm Earring",
        body="Theo. Briault +2",hands="Inyan. Dastanas +1",ring1="Globidonta Ring",ring2="Perception Ring",
        back="Alaunus's Cape",waist="Eschan Stone",legs="Theo. Pant. +1",feet="Chironic Slippers"}

    sets.midcast['Dark Magic'] = {main=gear.macc_staff, sub="Enki Strap",ammo="Pemphredo Tathlum",
        head="Inyanga Tiara +1",neck="Erra Pendant",ear1="Psystorm Earring",ear2="Lifestorm Earring",
        body="Shango Robe",hands="Inyan. Dastanas +1",ring1="Kishar Ring",ring2="Perception Ring",
        back="Perimede Cape",waist="Luminary Sash",legs="Inyanga Shalwar +1",feet="Inyan. Crackows +1"}

    -- Custom spell classes
    sets.midcast.MndEnfeebles = { main=gear.macc_staff,sub="Mephitis Grip",ammo="Pemphredo Tathlum",
        head="Befouled Crown",neck="Incanter's Torque",ear1="Psystorm Earring",ear2="Lifestorm Earring",
        body="Theo. Briault +2",hands="Inyan. Dastanas +1",ring1="Globidonta Ring",ring2="Kishar Ring",
        back="Alaunus's Cape",waist="Rumination Sash",legs="Chironic Hose",feet="Uk'uxkaj Boots"}

    sets.midcast.IntEnfeebles = set_combine(sets.midcast.MndEnfeebles, {})

    -- Defense sets
    sets.defense.PDT = {
        head="Aya. Zucchetto +2",neck="Twilight Torque",
		body="Ayanmo Corazza +2",hands="Aya. Manopolas +2",ring1="Defending Ring",ring2="Patricius Ring",
		back="Solemnity Cape",legs="Aya. Cosciales +2",feet="Battlecast Gaiters"}

    sets.defense.MDT = {
        head="Inyanga Tiara +1",neck="Twilight Torque",ear1="Etiolation Earring",ear2="Eabani Earring",
        body="Inyanga Jubbah +1",hands="Inyan. Dastanas +1",ring1="Defending Ring",ring2="Vengeful Ring",
        back="Solemnity Cape",waist="Flax Sash",legs="Inyanga Shalwar +1",feet="Inyan. Crackows +1"}
	
	sets.debuffed = set_combine(sets.defense.Evasion,sets.defense.PDT,sets.defense.MDT)
	
    sets.Kiting = {}

    sets.latent_refresh = {waist="Fucho-no-obi"}

    -- Buff sets: Gear that needs to be worn to actively enhance a current player buff.
    sets.buff['Divine Caress'] = {hands="Ebers Mitts",back="Mending Cape"}
end

-------------------------------------------------------------------------------------------------------------------
-- Job-specific hooks for standard casting events.
-------------------------------------------------------------------------------------------------------------------
-- Called when a player gains or loses a buff.
-- buff == buff gained or lost
-- gain == true if the buff was gained, false if it was lost.
function job_buff_change(buff, gain)
	handle_debuffs()
end

-- Set eventArgs.handled to true if we don't want any automatic gear equipping to be done.
-- Set eventArgs.useMidcastGear to true if we want midcast gear equipped on precast.
function job_precast(spell, action, spellMap, eventArgs)
    if spell.english == "Paralyna" and buffactive.Paralyzed then
        -- no gear swaps if we're paralyzed, to avoid blinking while trying to remove it.
        eventArgs.handled = true
    end
	if spell.skill == 'Healing Magic' then
		handle_spells(spell)
	end
	check_ws_dist(spell)
end


function job_post_midcast(spell, action, spellMap, eventArgs)
    -- Apply Divine Caress boosting items as highest priority over other gear, if applicable.
    if spellMap == 'StatusRemoval' and buffactive['Divine Caress'] then
        equip(sets.buff['Divine Caress'])
    end
end

-------------------------------------------------------------------------------------------------------------------
-- Job-specific hooks for non-casting events.
-------------------------------------------------------------------------------------------------------------------

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

function job_handle_equipping_gear(status, eventArgs)
	-- add_to_chat(122,'handle equiping gear')
	if player.status == 'Engaged' then
		check_tp_lock()
	end
	pick_tp_weapon()
end

-------------------------------------------------------------------------------------------------------------------
-- User code that supplements standard library decisions.
-------------------------------------------------------------------------------------------------------------------

-- Custom spell mapping.
function job_get_spell_map(spell, default_spell_map)
    if spell.action_type == 'Magic' then
        if (default_spell_map == 'Cure' or default_spell_map == 'Curaga') and player.status == 'Engaged' then
            return "CureMelee"
        elseif default_spell_map == 'Cure' and state.Buff['Afflatus Solace'] then
            return "CureSolace"
        elseif spell.skill == "Enfeebling Magic" then
            if spell.type == "WhiteMagic" then
                return "MndEnfeebles"
            else
                return "IntEnfeebles"
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
    return idleSet
end

-- Called by the 'update' self-command.
function job_update(cmdParams, eventArgs)
    if cmdParams[1] == 'user' and not areas.Cities:contains(world.area) then
        local needsArts = 
            player.sub_job:lower() == 'sch' and
            not buffactive['Light Arts'] and
            not buffactive['Addendum: White'] and
            not buffactive['Dark Arts'] and
            not buffactive['Addendum: Black']
            
        if not buffactive['Afflatus Solace'] and not buffactive['Afflatus Misery'] then
            if needsArts then
                send_command('@input /ja "Afflatus Solace" <me>;wait 1.2;input /ja "Light Arts" <me>')
            else
                send_command('@input /ja "Afflatus Solace" <me>')
            end
        end
    end
	pick_tp_weapon()
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
    -- Default macro set/book
    set_macro_page(1, 7)
	send_command('exec whm.txt')
end

