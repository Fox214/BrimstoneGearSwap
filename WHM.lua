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
	state.OffenseMode:options('Normal', 'Acc', 'Att', 'Crit', 'DA', 'Haste', 'Skill', 'sTP', 'STR')
    state.CastingMode:options('Normal', 'Resistant')
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
    --------------------------------------
    -- Start defining the sets
    --------------------------------------
	-- extra stuff
	organizer_items = {
		new1="Chironic Hose",
		new2="Chironic Slippers",
		new3="Perception Ring",
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
		echos="Echo Drops",
		-- shihei="Shihei",
		orb="Macrocosmic Orb"
	}
    -- Idle sets (default idle set not needed since the other three are defined, but leaving for testing purposes)
    sets.idle = { ammo="Homiliary",
        head="Befouled Crown",neck="Twilight Torque",ear1="Ethereal Earring",ear2="Moonshade Earring",
        body="Piety Briault +1",hands="Chironic Gloves",ring1="Sheltered Ring",ring2="Renaye Ring",
        back="Kumbira Cape",waist="Witful Belt",legs="Miasmic Pants",feet="Manabyss Pigaches"}
	sets.idle.Capacity = set_combine(sets.idle, {back="Mecisto. Mantle"})

    -- Resting sets
    sets.resting = set_combine(sets.idle, {})

    -- Normal melee group
    sets.engaged = {
        head="",neck="Iqabi Necklace",ear1="Bladeborn Earring",ear2="Steelflash Earring",
        body="Respite Cloak",hands="Chironic Gloves",ring1="Hetairoi Ring",ring2="Patricius Ring",
        back="Pahtli Cape",waist="Olseni Belt",legs="Miasmic Pants",feet="Battlecast Gaiters"}

	-- Sets with weapons defined.
	sets.engaged.Club = {}
	sets.engaged.Staff = {}

	-- Basic Mode definitions
	sets.Mode = {}
	sets.Mode.Acc = set_combine(sets.engaged, {head="Chironic Hat",ear1="Zennaroi Earring",ear2="Digni. Earring",
		hands="Chironic Gloves",waist="Olseni Belt",feet="Battlecast Gaiters"})
	sets.Mode.Att = set_combine(sets.engaged, {neck="Sanctity Necklace",ear1="Bladeborn Earring",ear2="Dudgeon Earring",ring1="Overbearing Ring"})
	sets.Mode.Crit = set_combine(sets.engaged, {ring1="Hetairoi Ring"})
	sets.Mode.DA = set_combine(sets.engaged, {ring1="Hetairoi Ring"})
	sets.Mode.Haste = set_combine(sets.engaged, {legs="Miasmic Pants",feet="Battlecast Gaiters"})
	sets.Mode.Skill = set_combine(sets.engaged, {ear1="Terminus Earring",ear2="Liminus Earring",ring2="Prouesse Ring"})
	sets.Mode.sTP = set_combine(sets.engaged, {ear2="Digni. Earring",waist="Olseni Belt",feet="Battlecast Gaiters"})
	sets.Mode.STR = set_combine(sets.engaged, { ammo="Amar Cluster",
		head="Befouled Crown",neck="Lacono Neck. +1",
		body="Shango Robe",hands="Hlr. Mitts +1",ring1="Apate Ring",ring2="Rajas Ring",
		back="Buquwik Cape",feet="Battlecast Gaiters"})
			
	sets.engaged.Club = set_combine(sets.engaged, {main="Queller Rod",sub="Genbu's Shield"})
	sets.engaged.Club.Acc = set_combine(sets.engaged.Club, sets.Mode.Acc)
	sets.engaged.Club.Att = set_combine(sets.engaged.Club, sets.Mode.Att)
	sets.engaged.Club.Crit = set_combine(sets.engaged.Club, sets.Mode.Crit)
	sets.engaged.Club.DA = set_combine(sets.engaged.Club, sets.Mode.DA)
	sets.engaged.Club.Haste = set_combine(sets.engaged.Club, sets.Mode.Haste)
	sets.engaged.Club.Skill = set_combine(sets.engaged.Club, sets.Mode.Skill, {})
	sets.engaged.Club.sTP = set_combine(sets.engaged.Club, sets.Mode.sTP)
	sets.engaged.Club.STR = set_combine(sets.engaged.Club, sets.Mode.STR)

	sets.engaged.Staff = set_combine(sets.engaged, {main=gear.macc_staff, sub="Mephitis Grip"})
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
    
	-- Ice/Water, STR 50% MND 50%
    sets.precast.WS['Flash Nova'] = set_combine(sets.precast.WS, {
        head="Nahtirah Hat",neck="Stoicheion Medal",ear1="Friomisi Earring",ear2="Hecate's Earring",
        body="Vanir Cotehardie",hands="Yaoyotl Gloves",ring1="Rajas Ring",ring2="Strendu Ring",
        back="Toro Cape",waist="Thunder Belt",legs="Gendewitha Spats",feet="Gendewitha Galoshes"})
 
	-- none, INT 50% MND 50%
	sets.precast.WS['Spirit Taker'] = set_combine(sets.precast.WS, {})

 
    -- Precast Sets

    -- Fast cast sets for spells
    sets.precast.FC = {main=gear.FastcastStaff,ammo="Incantor Stone",
        head="Vanya Hood",neck="Orison Locket",ear2="Loquacious Earring",
        body="Shango Robe",hands="Gendewitha Gages",ring1="Prolix Ring",
        back="Swith Cape +1",waist="Channeler's Stone",legs="Orvail Pants +1"}
        
    sets.precast.FC['Enhancing Magic'] = set_combine(sets.precast.FC, {ear2="Liminus Earring",waist="Siegel Sash"})

    sets.precast.FC.Stoneskin = set_combine(sets.precast.FC['Enhancing Magic'], {head="Umuthi Hat",body="Orison Bliaud +2"})

    sets.precast.FC['Healing Magic'] = set_combine(sets.precast.FC, {ear2="Liminus Earring",legs="Orsn. Pantaln. +2"})

    sets.precast.FC.StatusRemoval = sets.precast.FC['Healing Magic']

    sets.precast.FC.Cure = set_combine(sets.precast.FC['Healing Magic'], {main="Queller Rod",sub="Genbu's Shield",ammo="Impatiens"})
    sets.precast.FC.Curaga = sets.precast.FC.Cure
    sets.precast.FC.CureSolace = sets.precast.FC.Cure
    -- CureMelee spell map should default back to Healing Magic.
    
    -- Precast sets to enhance JAs
    sets.precast.JA.Benediction = {body="Piety Briault +1"}

    -- Waltz set (chr and vit)
    sets.precast.Waltz = {
        head="Nahtirah Hat",ear1="Roundel Earring",
        body="Vanir Cotehardie",hands="Yaoyotl Gloves",
        back="Kumbira Cape",legs="Gendewitha Spats",feet="Gende. Galoshes"}
    
    
     -- Midcast Sets
    
    sets.midcast.FastRecast = {
        head="Nahtirah Hat",ear2="Loquacious Earring",
        body="Shango Robe",ring1="Prolix Ring",
        back="Swith Cape +1",waist="Goading Belt",legs="Gendewitha Spats",feet="Gende. Galoshes"}
    
    -- Cure sets
    gear.default.obi_waist = "Goading Belt"
    gear.default.obi_back = "Mending Cape"

    sets.midcast.CureMelee = {ammo="Incantor Stone",
        head="Theophany Cap",neck="Phalaina Locket",ear1="Glorious Earring",ear2="Orison Earring",
        body="Heka's Kalasiris",hands="Telchine Gloves",ring1="Prolix Ring",ring2="Sirona's Ring",
        back="Pahtli Cape",waist=gear.ElementalObi,legs="Orsn. Pantaln. +2",feet="Rubeus Boots"}

	sets.midcast.Cure = set_combine(sets.midcast.CureMelee, {main="Queller Rod",sub="Genbu's Shield"})

    sets.midcast.CureSolace =  set_combine(sets.midcast.CureMelee, {main="Queller Rod",sub="Genbu's Shield",
        body="Orison Bliaud +2"})

    sets.midcast.Curaga = set_combine(sets.midcast.CureMelee, {main="Queller Rod",sub="Genbu's Shield"})

    sets.midcast.StatusRemoval = {
        head="Orison Cap +2",neck="Nesanica Torque",ring1="Ephedra Ring",legs="Orsn. Pantaln. +2"}

    sets.midcast.Cursna = set_combine(sets.midcast.StatusRemoval, {
        head="Orison Cap +2",neck="Nesanica Torque",ear2="Liminus Earring",
        body="Orison Bliaud +2",hands="Hlr. Mitts +1",ring1="Ephedra Ring",ring2="Sirona's Ring",
        back="Mending Cape",waist="Goading Belt",legs="Mdk. Shalwar +1",feet="Gende. Galoshes"})


    -- 110 total Enhancing Magic Skill; caps even without Light Arts
    sets.midcast['Enhancing Magic'] = {
        head="Befouled Crown",neck="Melic Torque",ear2="Liminus Earring",
        body="Orison Bliaud +2",hands="Chironic Gloves",
        back="Mending Cape",waist="Olympus Sash",legs="Piety Pantaloons",feet="Orsn. Duckbills +2"}
	sets.midcast['Enhancing Magic']['Refresh'] = set_combine(sets.midcast['Enhancing Magic'],{
		back="Grapevine Cape"})
	sets.midcast['Enhancing Magic']['Aquaveil'] = set_combine(sets.midcast['Enhancing Magic'],{
		head="Chironic Hat"})
		
    sets.midcast.Stoneskin = {
        head="Nahtirah Hat",neck="Orison Locket",ear2="Loquacious Earring",
        body="Vanir Cotehardie",
        back="Swith Cape +1",waist="Siegel Sash",legs="Gendewitha Spats",feet="Gende. Galoshes"}

    sets.midcast.Auspice = {feet="Orsn. Duckbills +2"}

    sets.midcast.BarElement = {
        head="Orison Cap +2",
        body="Orison Bliaud +2",hands="Orison Mitts +2",
        back="Mending Cape",waist="Olympus Sash",legs="Piety Pantaloons",feet="Orison Duckbills +2"}

    sets.midcast.Regen = {main="Bolelabunga",sub="Genbu's Shield",
        body="Piety Briault +1",hands="Orison Mitts +2",
        legs="Theophany Pantaloons"}

    sets.midcast.Protectra = {ring1="Sheltered Ring",feet="Piety Duckbills +1"}

    sets.midcast.Shellra = {ring1="Sheltered Ring",legs="Piety Pantaloons"}


    sets.midcast['Divine Magic'] = {main=gear.macc_staff,sub="Mephitis Grip",ammo="Pemphredo Tathlum",
        head="Chironic Hat",neck="Sanctity Necklace",ear1="Psystorm Earring",ear2="Liminus Earring",
        body="Vanir Cotehardie",hands="Chironic Gloves",ring1="Globidonta Ring",
        back="Izdubar Mantle",waist="Yamabuki-no-Obi",legs="Miasmic Pants",feet="Rubeus Boots"}

    sets.midcast['Dark Magic'] = {main=gear.macc_staff, sub="Mephitis Grip",ammo="Pemphredo Tathlum",
        head="Chironic Hat",neck="Sanctity Necklace",ear1="Psystorm Earring",ear2="Lifestorm Earring",
        body="Shango Robe",hands="Chironic Gloves",ring1="Strendu Ring",ring2="Sangoma Ring",
        back="Kumbira Cape",waist="Luminary Sash",legs="Miasmic Pants",feet="Bokwus Boots"}

    -- Custom spell classes
    sets.midcast.MndEnfeebles = { main=gear.macc_staff,sub="Mephitis Grip",ammo="Pemphredo Tathlum",
        head="Befouled Crown",neck="Imbodla Necklace",ear1="Psystorm Earring",ear2="Lifestorm Earring",
        body="Shango Robe",hands="Chironic Gloves",ring1="Globidonta Ring",ring2="Strendu Ring",
        back="Kumbira Cape",waist="Rumination Sash",legs="Miasmic Pants",feet="Rubeus Boots"}

    sets.midcast.IntEnfeebles = set_combine(sets.midcast.MndEnfeebles, {})

    -- Defense sets
    sets.defense.PDT = {
        neck="Twilight Torque",ring1="Patricius Ring",feet="Battlecast Gaiters"}

    sets.defense.MDT = {
        head="",neck="Twilight Torque",
        body="Respite Cloak",hands="Yaoyotl Gloves",ring1="Vengeful Ring",
        waist="Flax Sash",legs="Gendewitha Spats",feet="Manabyss Pigaches"}

    sets.Kiting = {feet="Herald's Gaiters"}

    sets.latent_refresh = {waist="Fucho-no-obi"}

    -- Buff sets: Gear that needs to be worn to actively enhance a current player buff.
    sets.buff['Divine Caress'] = {hands="Orison Mitts +2",back="Mending Cape"}
end

-------------------------------------------------------------------------------------------------------------------
-- Job-specific hooks for standard casting events.
-------------------------------------------------------------------------------------------------------------------

-- Set eventArgs.handled to true if we don't want any automatic gear equipping to be done.
-- Set eventArgs.useMidcastGear to true if we want midcast gear equipped on precast.
function job_precast(spell, action, spellMap, eventArgs)
    if spell.english == "Paralyna" and buffactive.Paralyzed then
        -- no gear swaps if we're paralyzed, to avoid blinking while trying to remove it.
        eventArgs.handled = true
    end
    
    if spell.skill == 'Healing Magic' then
        gear.default.obi_back = "Mending Cape"
    else
        gear.default.obi_back = "Toro Cape"
    end
	if spell.type == 'WeaponSkill' and spell.target.distance > 5.1 then
		cancel_spell()
		add_to_chat(123, 'WeaponSkill Canceled: [Out of Range]')
	end
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

