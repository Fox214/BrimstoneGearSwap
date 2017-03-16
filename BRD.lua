include('organizer-lib.lua')
-------------------------------------------------------------------------------------------------------------------
-- Setup functions for this job. Generally should not be modified.
-------------------------------------------------------------------------------------------------------------------
--[[
	Custom commands:
	ExtraSongsMode may take one of three values: None, Dummy, FullLength
	You can set these via the standard 'set' and 'cycle' self-commands. EG:
	gs c cycle ExtraSongsMode
	gs c set ExtraSongsMode Dummy
	The Dummy state will equip the bonus song instrument and ensure non-duration gear is equipped.
	The FullLength state will simply equip the bonus song instrument on top of standard gear.
	Simple macro to cast a dummy Daurdabla song:
	/console gs c set ExtraSongsMode Dummy
	/ma "Shining Fantasia" <me>
	To use a Terpander rather than Daurdabla, set the info.ExtraSongInstrument variable to
	'Terpander', and info.ExtraSongs to 1.
--]]
-- Initialization function for this job file.
function get_sets()
	mote_include_version = 2
	-- Load and initialize the include file.
	include('Mote-Include.lua')
end
-- Setup vars that are user-independent. state.Buff vars initialized here will automatically be tracked.
function job_setup()
	state.ExtraSongsMode = M{['description']='Extra Songs', 'None', 'Dummy', 'FullLength'}
	state.Buff['Pianissimo'] = buffactive['pianissimo'] or false
	state.WeaponMode = M{['description']='Weapon Mode', 'Staff', 'Dagger'}
  	state.Stance = M{['description']='Stance', 'Off', 'None', 'Offensive', 'Defensive'}
	state.holdtp = M{['description']='holdtp', 'false', 'true'}
	pick_tp_weapon()

	-- For tracking current recast timers via the Timers plugin.
	custom_timers = {}
end
-------------------------------------------------------------------------------------------------------------------
-- User setup functions for this job. Recommend that these be overridden in a sidecar file.
-------------------------------------------------------------------------------------------------------------------
-- Setup vars that are user-dependent. Can override this function in a sidecar file.
function user_setup()
	state.OffenseMode:options('Normal', 'Acc', 'Att', 'Crit', 'DA', 'Haste', 'Skill', 'sTP', 'STR')
	state.CastingMode:options('Normal', 'Resistant')
	state.IdleMode:options('Normal', 'Capacity')
	state.DefenseMode:options('None', 'Physical', 'Magical')
	state.PhysicalDefenseMode:options('PDT', 'Evasion')
	state.MagicalDefenseMode:options('MDT')
	state.Stance:set('None')
	state.WeaponMode:set('Staff')
	state.holdtp:set('false')
	
	pick_tp_weapon()
	-- Adjust this if using the Terpander (new +song instrument)
	info.ExtraSongInstrument = 'Terpander'
	-- How many extra songs we can keep from Daurdabla/Terpander
	info.ExtraSongs = 1
	
    gear.macc_staff = { name="Grioavolr", augments={'Magic burst dmg.+3%','INT+6','Mag. Acc.+24','"Mag.Atk.Bns."+22',}}
	
	-- Set this to false if you don't want to use custom timers.
	state.UseCustomTimers = M(false, 'Use Custom Timers')
	-- Additional local binds
	send_command('bind ^` gs c cycle ExtraSongsMode')
	send_command('bind !` input /ma "Chocobo Mazurka" <me>')
	select_default_macro_book()
end

-- Called when this job file is unloaded (eg: job change)
function user_unload()
	send_command('unbind ^`')
	send_command('unbind !`')
end

-- Define sets and vars used by this job file.
function init_gear_sets()
	info.ExtraSongInstrument = 'Terpander'
	--------------------------------------
	-- Start defining the sets
	--------------------------------------
	-- extra stuff
	organizer_items = {
		new1="Cacoethic Ring +1",
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
		new20="",
		new21="",
		new22="",
		new23="",
		new24="",
		new25="",
		new26="",
		new27="",
		new28="",
		new29="",
		new30="",
		echos="Echo Drops",
		shihei="Shihei",
		orb="Macrocosmic Orb"
	}
	-- Sets to return to when not performing an action.
	-- Idle sets (default idle set not needed since the other three are defined, but leaving for testing purposes)
	sets.idle = {range="Terpander",
		head="",neck="Twilight Torque",ear1="Ethereal Earring",ear2="Moonshade Earring",
		body="Respite Cloak",hands="Inyan. Dastanas +1",ring1="Defending Ring",ring2="Renaye Ring",
		back="Solemnity Cape",waist="Flax Sash",legs="Inyanga Shalwar +1",feet="Fili Cothurnes +1"}

	-- Idle sets (default idle set not needed since the other three are defined, but leaving for testing purposes)
	sets.idle.Town = set_combine(sets.idle, {})
	sets.idle.Field = set_combine(sets.idle, {})
	sets.idle.Weak = set_combine(sets.idle, {})
	sets.idle.Capacity = set_combine(sets.idle, {back="Mecisto. Mantle"})

	-- Resting sets
	sets.resting = set_combine(sets.idle, {})

	-- Engaged sets
	-- Variations for TP weapon and (optional) offense/defense modes. Code will fall back on previous
	-- sets if more refined versions aren't defined.
	-- If you create a set with both offense and defense modes, the offense mode should be first.
	-- EG: sets.engaged.Dagger.Accuracy.Evasion
	-- Basic set for if no TP weapon is defined.
	sets.engaged = {
		head="Chironic Hat",neck="Sanctity Necklace",ear1="Bladeborn Earring",ear2="Steelflash Earring",
		body="Bihu Jstcorps +1",hands="Aya. Manopolas +1",ring1="Patricius Ring",ring2="Hetairoi Ring",
		back="Atheling Mantle",waist="Olseni Belt",legs="Jokushu Haidate",feet="Aya. Gambieras +1"}
	-- Sets with weapons defined.
	sets.engaged.Dagger = {}
	sets.engaged.Staff = {}

	-- Basic Mode definitions
	sets.Mode = {}
	sets.Mode.Acc = set_combine(sets.engaged, {
		head="Chironic Hat",neck="Iqabi Necklace",ear1="Zennaroi Earring",ear2="Digni. Earring",
		hands="Chironic Gloves",ring1="Patricius Ring",
		back="Ground. Mantle +1",waist="Olseni Belt",legs="Miasmic Pants",feet="Aya. Gambieras +1"})
	sets.Mode.Att= set_combine(sets.engaged, {neck="Sanctity Necklace",ear1="Bladeborn Earring",ear2="Dudgeon Earring",
		hands="Chironic Gloves",ring1="Overbearing Ring",
		back="Phalangite Mantle",waist="Eschan Stone",feet="Chironic Slippers"})
	sets.Mode.Crit = set_combine(sets.engaged, {ring2="Hetairoi Ring",legs="Jokushu Haidate",feet="Aya. Gambieras +1"})
	sets.Mode.DA = set_combine(sets.engaged, {ring2="Hetairoi Ring",waist="Sarissapho. Belt"})
	sets.Mode.Haste = set_combine(sets.engaged, {head="Umuthi Hat",hands="Leyline Gloves",
		back="Ground. Mantle +1",waist="Sailfi Belt +1",legs="Jokushu Haidate",feet="Battlecast Gaiters"})
	sets.Mode.Skill = set_combine(sets.engaged, {})
	sets.Mode.sTP = set_combine(sets.engaged, {ear2="Digni. Earring",ring1="Rajas Ring",ring2="Apate Ring",waist="Yemaya Belt"})
	sets.Mode.STR = set_combine(sets.engaged, {
		head="Buremte Hat",neck="Lacono Neck. +1",
		body="Bihu Jstcorps +1",hands="Aya. Manopolas +1",ring1="Rajas Ring",ring2="Apate Ring",
		back="Buquwik Cape",legs="Jokushu Haidate",feet="Aya. Gambieras +1"})
			
	sets.engaged.Dagger = set_combine(sets.engaged, {main="Skinflayer", sub="Genmei Shield"})
	sets.engaged.Dagger.Acc = set_combine(sets.engaged.Dagger, sets.Mode.Acc)
	sets.engaged.Dagger.Att = set_combine(sets.engaged.Dagger, sets.Mode.Att)
	sets.engaged.Dagger.Crit = set_combine(sets.engaged.Dagger, sets.Mode.Crit)
	sets.engaged.Dagger.DA = set_combine(sets.engaged.Dagger, sets.Mode.DA)
	sets.engaged.Dagger.Haste = set_combine(sets.engaged.Dagger, sets.Mode.Haste)
	sets.engaged.Dagger.Skill = set_combine(sets.engaged.Dagger, sets.Mode.Skill, {neck="Maskirova Torque"})
	sets.engaged.Dagger.sTP = set_combine(sets.engaged.Dagger, sets.Mode.sTP)
	sets.engaged.Dagger.STR = set_combine(sets.engaged.Dagger, sets.Mode.STR)

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
	sets.precast.WS = set_combine(sets.Mode.STR, {neck="Fotia Gorget",ear2="Ishvara Earring",waist="Fotia Belt"})
	
	-- Specific weaponskill sets.  Uses the base set if an appropriate WSMod version isn't found.
	sets.precast.WS['Evisceration'] = set_combine(sets.precast.WS,{
		neck="Asperity Necklace",ear1="Bladeborn Earring",ear2="Steelflash Earring",
		body="Bihu Jstcorps +1",ring1="Rajas Ring",ring2="K'ayres Ring",
		back="Atheling Mantle",legs="Gendewitha Spats"})

	sets.precast.WS['Exenterator'] = set_combine(sets.precast.WS,{
		neck="Asperity Necklace",ear1="Bladeborn Earring",ear2="Steelflash Earring",
		body="Bihu Jstcorps +1",ring1="Rajas Ring",ring2="K'ayres Ring",
		back="Atheling Mantle",legs="Gendewitha Spats"})

	-- Wind/Thunder/Water/Ice, DEX 30% CHR 70%
	sets.precast.WS['Mordant Rime'] = set_combine(sets.precast.WS,{
		ear1="Bladeborn Earring",ear2="Steelflash Earring",
		body="Bihu Jstcorps +1",ring1="Rajas Ring",ring2="K'ayres Ring",
		back="Atheling Mantle",legs="Gendewitha Spats"})

	-- none, INT 50% MND 50%
	sets.precast.WS['Spirit Taker'] = set_combine(sets.precast.WS, {})
	
	-- Precast Sets
	-- Fast cast sets for spells
	sets.precast.FC = {
		head="Vanya Hood",neck="Baetyl Pendant",ear1="Etiolation Earring",
		body="Inyanga Jubbah +1",hands="Leyline Gloves",
		back="Intarabus's Cape",waist="Channeler's Stone",legs="Limbo Trousers"}

	sets.precast.FC.Cure = set_combine(sets.precast.FC, {body="Heka's Kalasiris",back="Pahtli Cape"})

	sets.precast.FC.Stoneskin = set_combine(sets.precast.FC, {head="Umuthi Hat",body="Artsieq Jubbah"})

	sets.precast.FC['Enhancing Magic'] = set_combine(sets.precast.FC, {waist="Siegel Sash"})

	sets.precast.FC.BardSong = set_combine(sets.precast.FC, {range="Linos",
		head="Fili Calot +1",neck="Aoidos' Matinee",ear1="Aoidos' Earring",
		hands="Schellenband",
		back="Swith Cape",waist="Witful Belt",legs="Gendewitha Spats",feet="Bihu Slippers"})
	sets.precast.FC.Daurdabla = set_combine(sets.precast.FC.BardSong, {range=info.ExtraSongInstrument})
	-- Precast sets to enhance JAs
	sets.precast.JA.Nightingale = {feet="Bihu Slippers"}
	sets.precast.JA.Troubadour = {body="Bihu Jstcorps +1"}
	sets.precast.JA['Soul Voice'] = {legs="Bihu Cannions"}
	-- Midcast Sets
	-- General set for recast times.
	-- sets.midcast.FastRecast = {}
	
	-- Build this in order generic to specific > CHR, Macc, Skill
	sets.CHR = {main="Chatoyant Staff",
		head="Inyanga Tiara +1",ear1="Aoidos' Earring",
		body="Inyanga Jubbah +1",hands="Inyan. Dastanas +1",
		back="Intarabus's Cape",waist="Luminary Sash",legs="Inyanga Shalwar +1",feet="Inyan. Crackows +1"}
	sets.Macc = set_combine(sets.CHR, {main=gear.macc_staff,sub="Mephitis Grip",
		head="Inyanga Tiara +1",neck="Sanctity Necklace",
		body="Inyanga Jubbah +1",hands="Inyan. Dastanas +1",ring1="Strendu Ring",ring2="Perception Ring",
		back="Intarabus's Cape",waist="Luminary Sash",legs="Inyanga Shalwar +1",feet="Inyan. Crackows +1"})
	sets.Singing = set_combine(sets.Macc, { 
		head="Marduk's Tiara",neck="Incanter's Torque",
		body="Fili Hongreline +1",hands="Inyan. Dastanas +1",ring2="Renaye Ring",
		back="Kumbira Cape",legs="Fili Rhingrave +1"})
	sets.String = set_combine(sets.Singing, {
		head="Brioso Roundlet",neck="Incanter's Torque",ear2="Musical Earring",
		hands="Inyan. Dastanas +1",feet="Bihu Slippers"}) 
	sets.Wind = set_combine(sets.Singing, {
		neck="Incanter's Torque",ear2="Musical Earring",
		body="Fili Hongreline +1",hands="Inyan. Dastanas +1",ring1="Nereid Ring",
		back="Rhapsode's Cape",legs="Mdk. Shalwar +1",feet="Brioso Slippers +1"}) 

	-- Waltz set (chr and vit)
	sets.precast.Waltz = set_combine(sets.CHR, {})
		
	-- For song buffs (duration and AF3 set bonus)
	sets.midcast.SongEffect = {main="Legato Dagger",sub="Genmei Shield",range="Linos",
		head="Fili Calot +1",neck="Aoidos' Matinee",
		body="Fili Hongreline +1",hands="Fili Manchettes +1",
		legs="Inyanga Shalwar +1",feet="Brioso Slippers +1"}

	-- Gear to enhance certain classes of songs. No instruments added here since Gjallarhorn is being used.
	sets.midcast.Ballad = {range="Linos",legs="Fili Rhingrave +1"}
	sets.midcast.Carol = {range="Linos",head="Fili Calot +1",
		body="Fili Hongreline +1",hands="Fili Manchettes +1",
		legs="Fili Rhingrave +1",feet="Fili Cothurnes +1"}
	sets.midcast.Elegy = set_combine(sets.Wind, {range="Linos"})
	sets.midcast.Etude = {range="Linos"}
	sets.midcast.Lullaby = set_combine(sets.Wind,{range="Linos",hands="Brioso Cuffs +1"})
	sets.midcast.Madrigal = {range="Linos",head="Fili Calot +1",back="Intarabus's Cape"}
	sets.midcast.Mambo = {range="Linos"}
	sets.midcast.March = {range="Linos",hands="Fili Manchettes +1"}
	sets.midcast.Mazurka = {range="Linos"}
	sets.midcast.Minne = {range="Linos"}
	sets.midcast.Minuet = {range="Linos",body="Fili Hongreline +1"}
	sets.midcast.Paeon = {range="Linos",head="Brioso Roundlet"}
	sets.midcast.Prelude = {range="Linos",head="Fili Calot +1",back="Intarabus's Cape"}
	sets.midcast.Requiem = set_combine(sets.Wind,{range="Linos"})
	sets.midcast.Threnody = set_combine(sets.Wind,{range="Linos"}) 
	sets.midcast["Sentinel's Scherzo"] = {range="Linos",feet="Fili Cothurnes +1"}
	sets.midcast['Magic Finale'] = set_combine(sets.Wind,{range="Linos",legs="Fili Rhingrave +1"})

	-- Song-specific recast reduction
	sets.midcast.SongRecast = {
		legs="Fili Rhingrave +1"}
	--sets.midcast.Daurdabla = set_combine(sets.midcast.FastRecast, sets.midcast.SongRecast, {range=info.ExtraSongInstrument})
	-- Cast spell with normal gear, except using Daurdabla instead
	sets.midcast.Daurdabla = {range=info.ExtraSongInstrument}
	-- Dummy song with Daurdabla; minimize duration to make it easy to overwrite.
	sets.midcast.DaurdablaDummy = set_combine(sets.idle, {main=gear.macc_staff,sub="Mephitis Grip",range=info.ExtraSongInstrument})
	-- Other general spells and classes.
	-- healing skill
    sets.midcast.StatusRemoval = {neck="Incanter's Torque",ring1="Ephedra Ring",hands="Inyan. Dastanas +1",feet="Gendewitha Galoshes"}

	-- Cure %+ > healing skill > MND
	sets.midcast.Cure = set_combine(sets.midcast.StatusRemoval, {main="Chatoyant Staff",sub='Mephitis Grip',
		head="Vanya Hood",neck="Phalaina Locket",
		body="Heka's Kalasiris",hands="Telchine Gloves",ring1="Ephedra Ring",
		back="Solemnity Cape",legs="Chironic Hose",feet="Gendewitha Galoshes"})
		
	sets.midcast.Curaga = sets.midcast.Cure

	sets.midcast.Regen = {main="Bolelabunga",sub="Genmei Shield",
		head="Inyanga Tiara +1",ear1="Pratik Earring",
		body="Telchine Chas.",feet="Telchine Pigaches"}
	
	sets.midcast['Enhancing Magic'] = {
        head="Umuthi Hat",neck="Incanter's Torque",ear1="Andoaa Earring",
        body="Telchine Chas.",hands="Inyan. Dastanas +1",
        back="Perimede Cape",feet="Rubeus Boots"}
	sets.midcast['Enhancing Magic']['Refresh'] = set_combine(sets.midcast['Enhancing Magic'],{
		back="Grapevine Cape"})
	sets.midcast['Enhancing Magic']['Aquaveil'] = set_combine(sets.midcast['Enhancing Magic'],{
		head="Chironic Hat"})
	sets.midcast.Stoneskin = set_combine(sets.midcast['Enhancing Magic'],{
		legs="Gendewitha Spats",feet="Gende. Galoshes"})
		
	sets.midcast.Cursna = set_combine(sets.midcast.StatusRemoval, {
		ring1="Ephedra Ring",feet="Gende. Galoshes"})
	-- Defense sets
	sets.defense.PDT = {
		neck="Twilight Torque",ring1="Defending Ring",ring2="Patricius Ring",
		body="Bihu Jstcorps +1",hands="Aya. Manopolas +1",
		back="Solemnity Cape",legs="Bihu Cannions",feet="Battlecast Gaiters"}
	sets.defense.MDT = {
		head="Inyanga Tiara +1",neck="Twilight Torque",ear1="Etiolation Earring",
		body="Inyanga Jubbah +1",hands="Inyan. Dastanas +1",ring1="Defending Ring",ring2="Vengeful Ring",
		back="Solemnity Cape",waist="Flax Sash",legs="Inyanga Shalwar +1",feet="Inyan. Crackows +1"}
	sets.debuffed = set_combine(sets.defense.Evasion,sets.defense.PDT,sets.defense.MDT)
	sets.Kiting = {feet="Fili Cothurnes +1"}
	sets.latent_refresh = {sub="Oneiros Grip",waist="Fucho-no-obi"}
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
	if spell.type == 'BardSong' then
		if state.ExtraSongsMode.value ~= 'None' then
			-- add_to_chat(120,'disable range '..state.ExtraSongsMode.value)
			equip(sets.precast.Daurdabla)
			-- disable('range')
		end
		-- Auto-Pianissimo
		if ((spell.target.type == 'PLAYER' and not spell.target.charmed) or (spell.target.type == 'NPC' and spell.target.in_party)) and
			not state.Buff['Pianissimo'] then
			local spell_recasts = windower.ffxi.get_spell_recasts()
			if spell_recasts[spell.recast_id] < 2 then
				send_command('@input /ja "Pianissimo" <me>; wait 1.5; input /ma "'..spell.name..'" '..spell.target.name)
				eventArgs.cancel = true
				return
			end
		end
	end
	check_ws_dist(spell)
end

-- Set eventArgs.handled to true if we don't want any automatic gear equipping to be done.
function job_midcast(spell, action, spellMap, eventArgs)
	-- add_to_chat(121,'midcast ')
	if state.ExtraSongsMode.value ~= 'None' then
		-- add_to_chat(120,'NOQUIP '..state.ExtraSongsMode.value)
		eventArgs.handled = true
	end
	if spell.action_type == 'Magic' then
		if spell.type == 'BardSong' then
			-- layer general gear on first, then let default handler add song-specific gear.
			local generalClass = get_song_class(spell)
			if generalClass and sets.midcast[generalClass] then
				equip(sets.midcast[generalClass])
			end
		end
	end
end

function job_post_midcast(spell, action, spellMap, eventArgs)
	-- add_to_chat(122,'post midcast ')
	if spell.type == 'BardSong' then
		if state.ExtraSongsMode.value == 'FullLength' then
			equip(sets.midcast.Daurdabla)
		end
		-- add_to_chat(123,'ENable range'..state.ExtraSongsMode.value)
		state.ExtraSongsMode:reset()
		-- enable('range')
	end
end
-- Set eventArgs.handled to true if we don't want automatic gear equipping to be done.
function job_aftercast(spell, action, spellMap, eventArgs)
	if spell.type == 'BardSong' and not spell.interrupted then
		if spell.target and spell.target.type == 'SELF' then
			adjust_timers(spell, spellMap)
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
-- Job-specific hooks for non-casting events.
-------------------------------------------------------------------------------------------------------------------
-- Handle notifications of general user state change.
function job_state_change(stateField, newValue, oldValue)
	if stateField == 'Offense Mode' then
		if newValue == 'Normal' then
			disable('main','sub','ammo')
		else
			enable('main','sub','ammo')
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
-- Modify the default idle set after it was constructed.
function customize_idle_set(idleSet)
	if buffactive['reive mark'] then
		idleSet = set_combine(idleSet, sets.Reive )
	end
	if player.mpp < 51 then
		idleSet = set_combine(idleSet, sets.latent_refresh)
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
-- Determine the custom class to use for the given song.
function get_song_class(spell)
	-- Can't use spell.targets:contains() because this is being pulled from resources
	if set.contains(spell.targets, 'Enemy') then
		-- old debuff code here
	elseif state.ExtraSongsMode.value == 'Dummy' then
		return 'DaurdablaDummy'
	else
		return 'SongEffect'
	end
end

-- Function to create custom buff-remaining timers with the Timers plugin,
-- keeping only the actual valid songs rather than spamming the default
-- buff remaining timers.
function adjust_timers(spell, spellMap)
	if state.UseCustomTimers.value == false then
		return
	end
	local current_time = os.time()
	-- custom_timers contains a table of song names, with the os time when they
	-- will expire.
	-- Eliminate songs that have already expired from our local list.
	local temp_timer_list = {}
	for song_name,expires in pairs(custom_timers) do
		if expires < current_time then
			temp_timer_list[song_name] = true
		end
	end
	for song_name,expires in pairs(temp_timer_list) do
		custom_timers[song_name] = nil
	end
	local dur = calculate_duration(spell.name, spellMap)
	if custom_timers[spell.name] then
		-- Songs always overwrite themselves now, unless the new song has
		-- less duration than the old one (ie: old one was NT version, new
		-- one has less duration than what's remaining).
		-- If new song will outlast the one in our list, replace it.
		if custom_timers[spell.name] < (current_time + dur) then
			send_command('timers delete "'..spell.name..'"')
			custom_timers[spell.name] = current_time + dur
			send_command('timers create "'..spell.name..'" '..dur..' down')
		end
	else
		-- Figure out how many songs we can maintain.
		local maxsongs = 2
		if player.equipment.range == info.ExtraSongInstrument then
			maxsongs = maxsongs + info.ExtraSongs
		end
		if buffactive['Clarion Call'] then
			maxsongs = maxsongs + 1
		end
		-- If we have more songs active than is currently apparent, we can still overwrite
		-- them while they're active, even if not using appropriate gear bonuses (ie: Daur).
		if maxsongs < table.length(custom_timers) then
			maxsongs = table.length(custom_timers)
		end
		-- Create or update new song timers.
		if table.length(custom_timers) < maxsongs then
			custom_timers[spell.name] = current_time + dur
			send_command('timers create "'..spell.name..'" '..dur..' down')
		else
		local rep,repsong
			for song_name,expires in pairs(custom_timers) do
				if current_time + dur > expires then
					if not rep or rep > expires then
						rep = expires
						repsong = song_name
					end
				end
			end
			if repsong then
				custom_timers[repsong] = nil
				send_command('timers delete "'..repsong..'"')
				custom_timers[spell.name] = current_time + dur
				send_command('timers create "'..spell.name..'" '..dur..' down')
			end
		end
	end
end

-- Function to calculate the duration of a song based on the equipment used to cast it.
-- Called from adjust_timers(), which is only called on aftercast().
function calculate_duration(spellName, spellMap)
	local mult = 1
	if player.equipment.range == 'Daurdabla' then mult = mult + 0.3 end -- change to 0.25 with 90 Daur
	if player.equipment.range == "Gjallarhorn" then mult = mult + 0.4 end -- change to 0.3 with 95 Gjall
	if player.equipment.main == "Carnwenhan" then mult = mult + 0.1 end -- 0.1 for 75, 0.4 for 95, 0.5 for 99/119
	if player.equipment.main == "Legato Dagger" then mult = mult + 0.05 end
	if player.equipment.sub == "Legato Dagger" then mult = mult + 0.05 end
	if player.equipment.neck == "Aoidos' Matinee" then mult = mult + 0.1 end
	if player.equipment.body == "Fili Hongreline +1" then mult = mult + 0.1 end
	if player.equipment.legs == "Mdk. Shalwar +1" then mult = mult + 0.1 end
	if player.equipment.feet == "Brioso Slippers +1" then mult = mult + 0.1 end
	if player.equipment.feet == "Brioso Slippers +1 +1" then mult = mult + 0.11 end
	if spellMap == 'Paeon' and player.equipment.head == "Brioso Roundlet" then mult = mult + 0.1 end
	if spellMap == 'Paeon' and player.equipment.head == "Brioso Roundlet +1" then mult = mult + 0.1 end
	if spellMap == 'Madrigal' and player.equipment.head == "Fili Calot +1" then mult = mult + 0.1 end
	if spellMap == 'Minuet' and player.equipment.body == "Fili Hongreline +1" then mult = mult + 0.1 end
	if spellMap == 'March' and player.equipment.hands == 'Fili Manchettes +1' then mult = mult + 0.1 end
	if spellMap == 'Ballad' and player.equipment.legs == "Fili Rhingrave +1" then mult = mult + 0.1 end
	if spellName == "Sentinel's Scherzo" and player.equipment.feet == "Fili Cothurnes +1" then mult = mult + 0.1 end
	if buffactive.Troubadour then
		mult = mult*2
	end
	if spellName == "Sentinel's Scherzo" then
		if buffactive['Soul Voice'] then
			mult = mult*2
		elseif buffactive['Marcato'] then
			mult = mult*1.5
		end
	end
	local totalDuration = math.floor(mult*120)
	return totalDuration
end

-- Function to reset timers.
function reset_timers()
	for i,v in pairs(custom_timers) do
		send_command('timers delete "'..i..'"')
	end
	custom_timers = {}
end

-- Select default macro book on initial load or subjob change.
function select_default_macro_book()
	set_macro_page(1, 5)
	send_command('exec brd.txt')
end

windower.raw_register_event('zone change',reset_timers)
windower.raw_register_event('logout',reset_timers)

function customize_idle_set(idleSet)
    if state.IdleMode.value == 'Capacity' then
        idleSet = set_combine(idleSet, sets.idle.Capacity)
    end
    
    return idleSet
end