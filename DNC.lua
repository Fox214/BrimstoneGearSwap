include('organizer-lib.lua')
-------------------------------------------------------------------------------------------------------------------
-- Setup functions for this job.  Generally should not be modified.
-------------------------------------------------------------------------------------------------------------------

--[[
    Custom commands:
    
    gs c step
        Uses the currently configured step on the target, with either <t> or <stnpc> depending on setting.

    gs c step t
        Uses the currently configured step on the target, but forces use of <t>.
    
    
    Configuration commands:
    
    gs c cycle mainstep
        Cycles through the available steps to use as the primary step when using one of the above commands.
        
    gs c cycle altstep
        Cycles through the available steps to use for alternating with the configured main step.
        
    gs c toggle usealtstep
        Toggles whether or not to use an alternate step.
        
    gs c toggle selectsteptarget
        Toggles whether or not to use <stnpc> (as opposed to <t>) when using a step.
--]]


-- Initialization function for this job file.
function get_sets()
    mote_include_version = 2
    
    -- Load and initialize the include file.
    include('Mote-Include.lua')
end


-- Setup vars that are user-independent.  state.Buff vars initialized here will automatically be tracked.
function job_setup()
    state.Buff['Climactic Flourish'] = buffactive['climactic flourish'] or false

    state.MainStep = M{['description']='Main Step', 'Box Step', 'Quickstep', 'Feather Step', 'Stutter Step'}
    state.AltStep = M{['description']='Alt Step', 'Quickstep', 'Feather Step', 'Stutter Step', 'Box Step'}
    state.UseAltStep = M(false, 'Use Alt Step')
    state.SelectStepTarget = M(false, 'Select Step Target')
    state.IgnoreTargetting = M(false, 'Ignore Targetting')

    state.CurrentStep = M{['description']='Current Step', 'Main', 'Alt'}
    state.SkillchainPending = M(false, 'Skillchain Pending')

	state.WeaponMode = M{['description']='Weapon Mode', 'Dagger', 'Sword', 'Club', 'H2H'}
 	state.SubMode = M{['description']='Sub Mode', 'DW', 'Shield'}
	state.RWeaponMode = M{['description']='RWeapon Mode', 'Stats', 'Boomerrang'}
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
    state.RangedMode:options('Normal', 'Acc')
    state.WeaponskillMode:options('Normal', 'Acc', 'Mod')
	state.WeaponMode:set('Dagger')
	state.SubMode:set('DW')
	state.RWeaponMode:set('Boomerrang') 
	state.DefenseMode:options('None', 'Physical', 'Magical')
	state.PhysicalDefenseMode:options('PDT', 'Evasion')
	state.MagicalDefenseMode:options('MDT')
	state.Stance:set('None')

    gear.default.weaponskill_neck = "Asperity Necklace"
    gear.default.weaponskill_waist = "Caudata Belt"

    -- Additional local binds
    send_command('bind ^= gs c cycle mainstep')
    send_command('bind != gs c cycle altstep')
    send_command('bind ^- gs c toggle selectsteptarget')
    send_command('bind !- gs c toggle usealtstep')
    send_command('bind ^` input /ja "Chocobo Jig" <me>')
    send_command('bind !` input /ja "Chocobo Jig II" <me>')

    select_default_macro_book()
end


-- Called when this job file is unloaded (eg: job change)
function user_unload()
    send_command('unbind ^`')
    send_command('unbind !`')
    send_command('unbind ^=')
    send_command('unbind !=')
    send_command('unbind ^-')
    send_command('unbind !-')
end


-- Define sets and vars used by this job file.
function init_gear_sets()
	organizer_items = {
		echos="Echo Drops",
		food="Squid Sushi",
		test="Dnc. Testimony",
		med1="Hi-Potion +3",
		med2="Elixer Vitae",
		med3="Icarus Wing",
		shihei="Shihei",
		orb="Macrocosmic Orb"
	}
	sets.idle = {
        head="Uk'uxkaj Cap",neck="Love Torque",ear1="Brutal Earring",ear2="Suppanomimi",
        body="Iuitl Vest",hands="Buremte Gloves",ring1="Sheltered Ring",ring2="Paguroidea Ring",
        back="Atheling Mantle",waist="Twilight Belt",legs="Iuitl Tights",feet="Fajin Boots"}

	-- Idle sets (default idle set not needed since the other three are defined, but leaving for testing purposes)
	sets.idle.Town = set_combine(sets.idle, {})
  
	sets.idle.Field = set_combine(sets.idle, {})

	sets.idle.Weak = set_combine(sets.idle, {})
	
	-- Resting sets
	sets.resting = set_combine(sets.idle, {})

	-- Normal melee group
    sets.engaged = { 
        head="Optical Hat",neck="Chivalrous Chain",ear1="Moldavite Earring",ear2="Reraise Earring",
        body="Dancer's Casaque",hands="Dancer's Bangles",ring1="Rajas Ring",ring2="Ulthalam's Ring",
        back="Etoile Cape",waist="Swift Belt",legs="Dancer's Tights",feet="Dancer's Shoes"}
 	sets.engaged.Club = {}
	sets.engaged.Dagger = {}
	sets.engaged.H2H = {}
	sets.engaged.Sword = {}

	-- Basic Mode definitions
	sets.Mode = {}
	sets.Mode.Acc = set_combine(sets.engaged, {
			head="Optical Hat",neck="Iqabi Necklace",ear1="Steelflash Earring",ear2="Heartseeker Earring",
			body="Mextli Harness",hands="Buremte Gloves",ring1="Patricius Ring",ring2="Ulthalam's Ring",
			back="Etoile Cape",waist="Hurch'lan Sash",legs="Dancer's Tights"})
	sets.Mode.Att= set_combine(sets.engaged, {
			head="Whirlpool Mask",neck="Asperity Necklace",ear1="Bladeborn Earring",ear2="Dudgeon Earring",
			hands="Raid. Armlets +2",ring1="Excelsis Ring",ring2="Cho'j Band",
			back="Atheling Mantle",legs="Manibozho Brais",feet="Thaumas Nails"})
	-- Crit then DEX
	sets.Mode.Crit = set_combine(sets.engaged, {
			head="Uk'uxkaj Cap",neck="Love Torque",
			body="Plunderer's Vest",hands="Buremte Gloves",ring1="Rajas Ring",
			legs="Raider's Culottes +2",feet="Thaumas Nails"})
	sets.Mode.DA = set_combine(sets.engaged, {
			head="Raid. Bonnet +2",neck="Asperity Necklace",ear1="Bladeborn Earring",ear2="Steelflash Earring",
			body="Raider's Vest +2",hands="Raider's Armlets +2",
			back="Canny Cape",waist="Twilight Belt",legs="Raider's Culottes +2",feet="Thaumas Nails"})
	-- DW then haste
	sets.Mode.Haste = set_combine(sets.engaged, {
			head="Thurandaut Chapeau",ear1="Dudgeon Earring",ear2="Heartseeker Earring",
			body="Mextli Harness",hands="Umuthi Gloves",
			waist="Twilight Belt",legs="Kaabnax Trousers",feet="Thurandaut Boots"})
	sets.Mode.Skill = set_combine(sets.engaged, {ear1="Terminus Earring",ear2="Liminus Earring",ring2="Prouesse Ring"})
	sets.Mode.sTP = set_combine(sets.engaged, {
			neck="Asperity Necklace",ear1="Bladeborn Earring",ear2="Steelflash Earring",
			body="Iuitl Vest",ring1="Rajas Ring",ring2="K'ayres Ring",
			legs="Iuitl Tights"})
	sets.Mode.STR = set_combine(sets.engaged, {
			head="Maat's Cap",
			body="Plunderer's Vest",hands="Buremte Gloves",ring1="Rajas Ring",ring2="Aife's Ring",
			back="Amemet Mantle +1",waist="Wanion Belt",legs="Nahtirah Trousers",feet="Thurandaut Boots"})

	--Initialize Main Weapons
	sets.engaged.DW = set_combine(sets.engaged, {})
	sets.engaged.Shield = set_combine(sets.engaged, {})
	sets.engaged.DW.Dagger = set_combine(sets.engaged, {main="Behemoth Knife",sub="Cermet Knife"})
	sets.engaged.Shield.Dagger = set_combine(sets.engaged, {main="Cermet Kukri",sub="Viking Shield"})
	--Add in appropriate Ranged weapons
	sets.ranged = {}
	sets.ranged.Stats = {ranged="",ammo="Potestas Bomblet"}
	sets.ranged.Boomerrang = {ranged="War Hoop",ammo=""}
	--Finalize the sets
	sets.engaged.DW.Dagger.Boomerrang = set_combine(sets.engaged.DW.Dagger, sets.ranged.Boomerrang)
	sets.engaged.DW.Dagger.Stats = set_combine(sets.engaged.DW.Dagger, sets.ranged.Stats)
	sets.engaged.Shield.Dagger.Boomerrang = set_combine(sets.engaged.Shield.Dagger, sets.ranged.Boomerrang)
	sets.engaged.Shield.Dagger.Stats = set_combine(sets.engaged.Shield.Dagger, sets.ranged.Stats)
	sets.engaged.DW.Dagger.Acc = set_combine(sets.engaged.DW.Dagger, sets.Mode.Acc)
	sets.engaged.DW.Dagger.Att = set_combine(sets.engaged.DW.Dagger, sets.Mode.Att)
	sets.engaged.DW.Dagger.Crit = set_combine(sets.engaged.DW.Dagger, sets.Mode.Crit)
	sets.engaged.DW.Dagger.DA = set_combine(sets.engaged.DW.Dagger, sets.Mode.DA)
	sets.engaged.DW.Dagger.Haste = set_combine(sets.engaged.DW.Dagger, sets.Mode.Haste)
	sets.engaged.DW.Dagger.Skill = set_combine(sets.engaged.DW.Dagger, {neck="Love Torque",
        ring2="Aife's Ring"})
	sets.engaged.DW.Dagger.sTP = set_combine(sets.engaged.DW.Dagger, sets.Mode.sTP)
	sets.engaged.DW.Dagger.STR = set_combine(sets.engaged.DW.Dagger, sets.Mode.STR)
	sets.engaged.Shield.Dagger.Acc = set_combine(sets.engaged.Shield.Dagger, sets.Mode.Acc)
	sets.engaged.Shield.Dagger.Att = set_combine(sets.engaged.Shield.Dagger, sets.Mode.Att)
	sets.engaged.Shield.Dagger.Crit = set_combine(sets.engaged.Shield.Dagger, sets.Mode.Crit)
	sets.engaged.Shield.Dagger.DA = set_combine(sets.engaged.Shield.Dagger, sets.Mode.DA)
	sets.engaged.Shield.Dagger.Haste = set_combine(sets.engaged.Shield.Dagger, sets.Mode.Haste)
	sets.engaged.Shield.Dagger.Skill = set_combine(sets.engaged.Shield.Dagger, {neck="Love Torque",
        ring2="Aife's Ring"})
	sets.engaged.Shield.Dagger.sTP = set_combine(sets.engaged.Shield.Dagger, sets.Mode.sTP)
	sets.engaged.Shield.Dagger.STR = set_combine(sets.engaged.Shield.Dagger, sets.Mode.STR)
	
	sets.engaged.DW.Sword = set_combine(sets.engaged, {main="Apaisante",sub="Izhiikoh"})
	sets.engaged.Shield.Sword = set_combine(sets.engaged, {main="Apaisante",sub="Viking Shield"})
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
	sets.engaged.DW.Club = set_combine(sets.engaged, {main="Warp Cudgel",sub="Thief's Knife"})
	sets.engaged.DW.Club.Acc = set_combine(sets.engaged.DW.Club, sets.Mode.Acc)
	sets.engaged.Shield.Club = set_combine(sets.engaged, {main="Warp Cudgel",sub="Viking Shield"})
	sets.engaged.Shield.Club.Acc = set_combine(sets.engaged.Shield.Club, sets.Mode.Acc)
	sets.engaged.H2H = set_combine(sets.engaged, {main="",sub=""})
	sets.engaged.H2H.Acc = set_combine(sets.engaged.Club, sets.Mode.Acc)

    -- Weaponskill sets

    -- Default set for any weaponskill that isn't any more specifically defined
    sets.precast.WS = set_combine(sets.Mode.STR, {})
    sets.precast.WS.Acc = set_combine(sets.precast.WS, { back="Letalis Mantle"})

    -- Specific weaponskill sets.  Uses the base set if an appropriate WSMod version isn't found.
	-- Earth, DEX 100%
	sets.precast.WS['Wasp Sting'] = set_combine(sets.precast.WS, {neck="Soil Gorget",waist="Soil Belt"})

	-- Wind, DEX 40% INT 40%
	sets.precast.WS['Gust Slash'] = set_combine(sets.precast.WS, {neck="Breeze Gorget",waist="Breeze Belt"})

	-- Water, CHR 100%
	sets.precast.WS['Shadowstitch'] = set_combine(sets.precast.WS, {neck="Aqua Gorget",waist="Aqua Belt"})

 	-- Earth, DEX 100%
	sets.precast.WS['Viper Bite'] = set_combine(sets.precast.WS, {neck="Soil Gorget",waist="Soil Belt"})
 
 	-- Wind/Thunder, DEX 40% INT 40%
	sets.precast.WS['Cyclone'] = set_combine(sets.precast.WS, {neck="Breeze Gorget",waist="Breeze Belt"})
 
  	-- none, MND 100%
	sets.precast.WS['Energy Steal'] = set_combine(sets.precast.WS, {})
 
  	-- none, MND 100%
	sets.precast.WS['Energy Drain'] = set_combine(sets.precast.WS, {})

	-- Wind/Earth, DEX 40% CHR 40%
    sets.precast.WS['Dancing Edge'] = set_combine(sets.precast.WS, {neck="Breeze Gorget",back="Etoile Cape",waist="Breeze Belt"})
	
	-- Wind/Thunder, DEX 40% AGI 40%
    sets.precast.WS["Shark Bite"] = set_combine(sets.precast.WS, {neck="Breeze Gorget",waist="Breeze Belt"})
 
	-- Light/Dark/Earth, DEX 50%
    sets.precast.WS['Evisceration'] = set_combine(sets.precast.WS, sets.Mode.Crit, {neck="Light Gorget",back="Etoile Cape",waist="Light Belt"})

	-- Wind/Thunder/Earth, DEX 40% AGI 40%
    sets.precast.WS['Aeolian Edge'] = set_combine(sets.precast.WS, {
        head="Wayfarer Circlet",neck="Breeze Gorget",ear1="Friomisi Earring",ear2="Moonshade Earring",
        body="Wayfarer Robe",hands="Pillager's Armlets +1",ring1="Acumen Ring",ring2="Demon's Ring",
        back="Toro Cape",waist="Breeze Belt",legs="Shneddick Tights +1",feet="Wayfarer Clogs"})

	-- Wind/Thunder/Earth, AGI 73%
	sets.precast.WS['Exenterator'] = set_combine(sets.precast.WS, {neck="Breeze Gorget",waist="Breeze Belt"})

	-- Ice/Water/Dark, DEX 80%
    sets.precast.WS["Rudra's Storm"] = set_combine(sets.precast.WS, {neck="Aqua Gorget",waist="Aqua Belt"})

	-- Light/Fire/Dark, DEX 60%
    sets.precast.WS['Mandalic Stab'] = set_combine(sets.precast.WS, {neck="Light Gorget",waist="Light Belt"})

    -- Precast sets to enhance JAs

    sets.precast.JA['No Foot Rise'] = {body="Horos Casaque"}

    sets.precast.JA['Trance'] = {head="Horos Tiara"}
    

    -- Waltz set (chr and vit)
    sets.precast.Waltz = {ammo="Sonia's Plectrum",
        head="Maat's Cap",ear1="Roundel Earring",
        body="Dancer's Casaque",hands="Buremte Gloves",ring1="Asklepian Ring",
        back="Toetapper Mantle",waist="Caudata Belt",legs="Nahtirah Trousers",feet="Maxixi Toe Shoes"}
        
    -- Don't need any special gear for Healing Waltz.
    sets.precast.Waltz['Healing Waltz'] = {}
    
    sets.precast.Samba = {head="Dancer's Tiara"}

    sets.precast.Jig = {legs="Horos Tights", feet="Dancer's Shoes"}

    sets.precast.Step = {hands="Dancer's Bangles",waist="Chaac Belt"}
    sets.precast.Step['Feather Step'] = {feet="Charis Shoes +2"}

    sets.precast.Flourish1 = {}
    sets.precast.Flourish1['Violent Flourish'] = {ear1="Psystorm Earring",ear2="Lifestorm Earring",
        body="Horos Casaque",hands="Buremte Gloves",ring2="Sangoma Ring",
        waist="Chaac Belt",legs="Iuitl Tights",feet="Iuitl Gaiters +1"} -- magic accuracy
    sets.precast.Flourish1['Desperate Flourish'] = {ammo="Charis Feather",
        head="Whirlpool Mask",neck="Ej Necklace",
        body="Horos Casaque",hands="Buremte Gloves",ring1="Beeline Ring",
        back="Toetapper Mantle",waist="Hurch'lan Sash",legs="Kaabnax Trousers",feet="Iuitl Gaiters +1"} -- acc gear

    sets.precast.Flourish2 = {}
    sets.precast.Flourish2['Reverse Flourish'] = {hands="Charis Bangles +2"}

    sets.precast.Flourish3 = {}
    sets.precast.Flourish3['Striking Flourish'] = {body="Charis Casaque +2"}
    sets.precast.Flourish3['Climactic Flourish'] = {head="Charis Tiara +2"}

    -- Fast cast sets for spells
    
    sets.precast.FC = {ammo="Impatiens",head="Haruspex Hat",ear2="Loquacious Earring",hands="Thaumas Gloves",ring1="Prolix Ring"}

    sets.precast.FC.Utsusemi = set_combine(sets.precast.FC, {neck="Magoraga Beads"})

       
    sets.precast.Skillchain = {hands="Charis Bangles +2"}
    
    
    -- Midcast Sets
    
    sets.midcast.FastRecast = {
        head="Felistris Mask",ear2="Loquacious Earring",
        body="Iuitl Vest",hands="Iuitl Wristbands",
        legs="Kaabnax Trousers",feet="Iuitl Gaiters +1"}
        
    -- Specific spells
    sets.midcast.Utsusemi = {
        head="Felistris Mask",neck="Ej Necklace",ear2="Loquacious Earring",
        body="Iuitl Vest",hands="Iuitl Wristbands",ring1="Beeline Ring",
        back="Toetapper Mantle",legs="Kaabnax Trousers",feet="Iuitl Gaiters +1"}

    
    -- Sets to return to when not performing an action.
    
     -- Defense sets

    sets.defense.Evasion = {
        head="Felistris Mask",neck="Ej Necklace",
        body="Qaaxo Harness",hands="Iuitl Wristbands",ring1="Beeline Ring",ring2=gear.DarkRing.physical,
        back="Toetapper Mantle",waist="Flume Belt",legs="Kaabnax Trousers",feet="Iuitl Gaiters +1"}

    sets.defense.PDT = {ammo="Iron Gobbet",
        head="Felistris Mask",neck="Twilight Torque",
        body="Qaaxo Harness",hands="Iuitl Wristbands",ring1="Defending Ring",ring2=gear.DarkRing.physical,
        back="Shadow Mantle",waist="Flume Belt",legs="Nahtirah Trousers",feet="Iuitl Gaiters +1"}

    sets.defense.MDT = {ammo="Demonry Stone",
        head="Wayfarer Circlet",neck="Twilight Torque",
        body="Qaaxo Harness",hands="Wayfarer Cuffs",ring1="Defending Ring",ring2="Shadow Ring",
        back="Engulfer Cape",waist="Flume Belt",legs="Wayfarer Slops",feet="Wayfarer Clogs"}

    sets.Kiting = {feet="Skadi's Jambeaux +1"}

    -- Buff sets: Gear that needs to be worn to actively enhance a current player buff.
    sets.buff['Saber Dance'] = {legs="Horos Tights"}
    sets.buff['Climactic Flourish'] = {head="Charis Tiara +2"}
end


-------------------------------------------------------------------------------------------------------------------
-- Job-specific hooks for standard casting events.
-------------------------------------------------------------------------------------------------------------------

-- Set eventArgs.handled to true if we don't want any automatic gear equipping to be done.
-- Set eventArgs.useMidcastGear to true if we want midcast gear equipped on precast.
function job_precast(spell, action, spellMap, eventArgs)
    --auto_presto(spell)
end


function job_post_precast(spell, action, spellMap, eventArgs)
    if spell.type == "WeaponSkill" then
        if state.Buff['Climactic Flourish'] then
            equip(sets.buff['Climactic Flourish'])
        end
        if state.SkillchainPending.value == true then
            equip(sets.precast.Skillchain)
        end
    end
end


-- Return true if we handled the aftercast work.  Otherwise it will fall back
-- to the general aftercast() code in Mote-Include.
function job_aftercast(spell, action, spellMap, eventArgs)
    if not spell.interrupted then
        if spell.english == "Wild Flourish" then
            state.SkillchainPending:set()
            send_command('wait 5;gs c unset SkillchainPending')
        elseif spell.type:lower() == "weaponskill" then
            state.SkillchainPending:toggle()
            send_command('wait 6;gs c unset SkillchainPending')
        end
    end
end


function job_handle_equipping_gear(status, eventArgs)
	-- add_to_chat(122,'handle equiping gear')
	check_tp_lock()
	set_combat_form()
	pick_tp_weapon()
end

-------------------------------------------------------------------------------------------------------------------
-- Job-specific hooks for non-casting events.
-------------------------------------------------------------------------------------------------------------------

-- Called when a player gains or loses a buff.
-- buff == buff gained or lost
-- gain == true if the buff was gained, false if it was lost.
function job_buff_change(buff,gain)
    -- If we gain or lose any haste buffs, adjust which gear set we target.
    if S{'haste','march','embrava','haste samba'}:contains(buff:lower()) then
        determine_haste_group()
        handle_equipping_gear(player.status)
    elseif buff == 'Saber Dance' or buff == 'Climactic Flourish' then
        handle_equipping_gear(player.status)
    end
end


function job_status_change(new_status, old_status)
    if new_status == 'Engaged' then
        determine_haste_group()
    end
end


-------------------------------------------------------------------------------------------------------------------
-- User code that supplements standard library decisions.
-------------------------------------------------------------------------------------------------------------------

-- Called by the default 'update' self-command.
function job_update(cmdParams, eventArgs)
    determine_haste_group()
end


function customize_idle_set(idleSet)
    if player.hpp < 80 and not areas.Cities:contains(world.area) then
        idleSet = set_combine(idleSet, sets.ExtraRegen)
    end
    
    return idleSet
end

function customize_melee_set(meleeSet)
    if state.DefenseMode.value ~= 'None' then
        if buffactive['saber dance'] then
            meleeSet = set_combine(meleeSet, sets.buff['Saber Dance'])
        end
        if state.Buff['Climactic Flourish'] then
            meleeSet = set_combine(meleeSet, sets.buff['Climactic Flourish'])
        end
    end
    
    return meleeSet
end

-- Handle auto-targetting based on local setup.
function job_auto_change_target(spell, action, spellMap, eventArgs)
    if spell.type == 'Step' then
        if state.IgnoreTargetting.value == true then
            state.IgnoreTargetting:reset()
            eventArgs.handled = true
        end
        
        eventArgs.SelectNPCTargets = state.SelectStepTarget.value
    end
end


-- Function to display the current relevant user state when doing an update.
-- Set eventArgs.handled to true if display was handled, and you don't want the default info shown.
function display_current_job_state(eventArgs)
    local msg = 'Melee'
    
    if state.CombatForm.has_value then
        msg = msg .. ' (' .. state.CombatForm.value .. ')'
    end
    
    msg = msg .. ': '
    
    msg = msg .. state.OffenseMode.value
    if state.HybridMode.value ~= 'Normal' then
        msg = msg .. '/' .. state.HybridMode.value
    end
    msg = msg .. ', WS: ' .. state.WeaponskillMode.value
    
    if state.DefenseMode.value ~= 'None' then
        msg = msg .. ', ' .. 'Defense: ' .. state.DefenseMode.value .. ' (' .. state[state.DefenseMode.value .. 'DefenseMode'].value .. ')'
    end
    
    if state.Kiting.value then
        msg = msg .. ', Kiting'
    end

    msg = msg .. ', ['..state.MainStep.current

    if state.UseAltStep.value == true then
        msg = msg .. '/'..state.AltStep.current
    end
    
    msg = msg .. ']'

    if state.SelectStepTarget.value == true then
        steps = steps..' (Targetted)'
    end

    add_to_chat(122, msg)

    eventArgs.handled = true
end


-------------------------------------------------------------------------------------------------------------------
-- User self-commands.
-------------------------------------------------------------------------------------------------------------------

-- Called for custom player commands.
function job_self_command(cmdParams, eventArgs)
    if cmdParams[1] == 'step' then
        if cmdParams[2] == 't' then
            state.IgnoreTargetting:set()
        end

        local doStep = ''
        if state.UseAltStep.value == true then
            doStep = state[state.CurrentStep.current..'Step'].current
            state.CurrentStep:cycle()
        else
            doStep = state.MainStep.current
        end        
        
        send_command('@input /ja "'..doStep..'" <t>')
    end
end

-------------------------------------------------------------------------------------------------------------------
-- Utility functions specific to this job.
-------------------------------------------------------------------------------------------------------------------

function determine_haste_group()
    -- We have three groups of DW in gear: Charis body, Charis neck + DW earrings, and Patentia Sash.

    -- For high haste, we want to be able to drop one of the 10% groups (body, preferably).
    -- High haste buffs:
    -- 2x Marches + Haste
    -- 2x Marches + Haste Samba
    -- 1x March + Haste + Haste Samba
    -- Embrava + any other haste buff
    
    -- For max haste, we probably need to consider dropping all DW gear.
    -- Max haste buffs:
    -- Embrava + Haste/March + Haste Samba
    -- 2x March + Haste + Haste Samba

    classes.CustomMeleeGroups:clear()
    
    if buffactive.embrava and (buffactive.haste or buffactive.march) and buffactive['haste samba'] then
        classes.CustomMeleeGroups:append('MaxHaste')
    elseif buffactive.march == 2 and buffactive.haste and buffactive['haste samba'] then
        classes.CustomMeleeGroups:append('MaxHaste')
    elseif buffactive.embrava and (buffactive.haste or buffactive.march or buffactive['haste samba']) then
        classes.CustomMeleeGroups:append('HighHaste')
    elseif buffactive.march == 1 and buffactive.haste and buffactive['haste samba'] then
        classes.CustomMeleeGroups:append('HighHaste')
    elseif buffactive.march == 2 and (buffactive.haste or buffactive['haste samba']) then
        classes.CustomMeleeGroups:append('HighHaste')
    end
end


-- Automatically use Presto for steps when it's available and we have less than 3 finishing moves
function auto_presto(spell)
    if spell.type == 'Step' then
        local allRecasts = windower.ffxi.get_ability_recasts()
        local prestoCooldown = allRecasts[236]
        local under3FMs = not buffactive['Finishing Move 3'] and not buffactive['Finishing Move 4'] and not buffactive['Finishing Move 5']
        
        if player.main_job_level >= 77 and prestoCooldown < 1 and under3FMs then
            cast_delay(1.1)
            send_command('@input /ja "Presto" <me>')
        end
    end
end


-- Select default macro book on initial load or subjob change.
function select_default_macro_book()
    -- Default macro set/book
    if player.sub_job == 'WAR' then
        set_macro_page(1, 20)
    elseif player.sub_job == 'NIN' then
        set_macro_page(1, 20)
    elseif player.sub_job == 'SAM' then
        set_macro_page(1, 20)
    else
        set_macro_page(1, 20)
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

