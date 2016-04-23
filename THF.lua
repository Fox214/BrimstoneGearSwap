include('organizer-lib.lua')
-------------------------------------------------------------------------------------------------------------------
-- Setup functions for this job.  Generally should not be modified.
-------------------------------------------------------------------------------------------------------------------

--[[
    Custom commands:

    gs c cycle treasuremode (set on ctrl-= by default): Cycles through the available treasure hunter modes.
    
    Treasure hunter modes:
        None - Will never equip TH gear
        Tag - Will equip TH gear sufficient for initial contact with a mob (either melee, ranged hit, or Aeolian Edge AOE)
        SATA - Will equip TH gear sufficient for initial contact with a mob, and when using SATA
        Fulltime - Will keep TH gear equipped fulltime

--]]

-- Initialization function for this job file.
function get_sets()
    mote_include_version = 2
    
    -- Load and initialize the include file.
    include('Mote-Include.lua')
end

-- Setup vars that are user-independent.  state.Buff vars initialized here will automatically be tracked.
function job_setup()
	state.WeaponMode = M{['description']='Weapon Mode', 'Dagger', 'Sword', 'Club', 'H2H', 'Staff', 'Polearm', 'Scythe'}
	state.SubMode = M{['description']='Sub Mode', 'DW', 'Shield', 'TH'}
	state.RWeaponMode = M{['description']='RWeapon Mode', 'Stats', 'Bow', 'Xbow', 'Boomerrang'}
 	state.Stance = M{['description']='Stance', 'Off', 'None', 'Offensive', 'Defensive'}

	set_combat_form()
	pick_tp_weapon()

    state.Buff['Sneak Attack'] = buffactive['sneak attack'] or false
    state.Buff['Trick Attack'] = buffactive['trick attack'] or false
    state.Buff['Feint'] = buffactive['feint'] or false
    
    include('Mote-TreasureHunter')

    -- For th_action_check():
    -- JA IDs for actions that always have TH: Provoke, Animated Flourish
    info.default_ja_ids = S{35, 204}
    -- Unblinkable JA IDs for actions that always have TH: Quick/Box/Stutter Step, Desperate/Violent Flourish
    info.default_u_ja_ids = S{201, 202, 203, 205, 207}
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

    -- gear.default.weaponskill_neck = "Asperity Necklace"
    -- gear.AugQuiahuiz = {name="Quiahuiz Trousers", augments={'Haste+2','"Snapshot"+2','STR+8'}}

    -- Additional local binds
    -- send_command('bind ^` input /ja "Flee" <me>')
    send_command('bind ^= gs c cycle treasuremode')
    send_command('bind !- gs c cycle targetmode')

    select_default_macro_book()
end

-- Called when this job file is unloaded (eg: job change)
function user_unload()
    send_command('unbind ^`')
    send_command('unbind !-')
end

-- Define sets and vars used by this job file.
function init_gear_sets()   
	organizer_items = {
		new1="",
		new2="",
		new5="",
		new6="",
		echos="Echo Drops",
		shihei="Shihei",
		orb="Macrocosmic Orb"
	}

	sets.idle = {
        head="Herculean Helm",neck="Twilight Torque",ear1="Brutal Earring",ear2="Suppanomimi",
        body="Herculean Vest",hands="Herculean Gloves",ring1="Patricius Ring",ring2="Vengeful Ring",
        back="Atheling Mantle",waist="Sarissapho. Belt",legs="Iuitl Tights",feet="Skd. Jambeaux +1"}

	-- Idle sets (default idle set not needed since the other three are defined, but leaving for testing purposes)
	sets.idle.Town = set_combine(sets.idle, {})
  
	sets.idle.Field = set_combine(sets.idle, {})

	sets.idle.Weak = set_combine(sets.idle, {})
	
	-- Resting sets
	sets.resting = set_combine(sets.idle, {})

	-- Normal melee group
    sets.engaged = {
        head="Whirlpool Mask",neck="Maskirova Torque",ear1="Dudgeon Earring",ear2="Heartseeker Earring",
        body="Herculean Vest",hands="Herculean Gloves",ring1="Hetairoi Ring",ring2="Aife's Ring",
        back="Canny Cape",waist="Sarissapho. Belt",legs="Manibozho Brais",feet="Herculean Boots"}
 	sets.engaged.Club = {}
	sets.engaged.Dagger = {}
	sets.engaged.H2H = {}
	sets.engaged.Sword = {}

	-- Basic Mode definitions
	sets.Mode = {}
	sets.Mode.Acc = set_combine(sets.engaged, {
			head="Whirlpool Mask",neck="Iqabi Necklace",ear1="Zennaroi Earring",ear2="Digni. Earring",
			body="Herculean Vest",hands="Buremte Gloves",ring1="Patricius Ring",ring2="Ulthalam's Ring",
			back="Grounded Mantle",waist="Olseni Belt",legs="Feast Hose",feet="Herculean Boots"})
	sets.Mode.Att= set_combine(sets.engaged, {
			head="Herculean Helm",neck="Sanctity Necklace",ear1="Bladeborn Earring",ear2="Dudgeon Earring",
			body="Herculean Vest",hands="Raid. Armlets +2",ring1="Overbearing Ring",ring2="Cho'j Band",
			back="Phalangite Mantle",legs="Manibozho Brais",feet="Herculean Boots"})
	-- Crit then DEX
	sets.Mode.Crit = set_combine(sets.engaged, {
			head="Uk'uxkaj Cap",neck="Love Torque",
			body="Plunderer's Vest",hands="Buremte Gloves",ring1="Hetairoi Ring",
			back="Canny Cape",legs="Raider's Culottes +2",feet="Herculean Boots"})
	sets.Mode.DA = set_combine(sets.engaged, {
			head="Raid. Bonnet +2",neck="Asperity Necklace",ear1="Bladeborn Earring",ear2="Steelflash Earring",
			body="Raider's Vest +2",hands="Herculean Gloves",ring1="Hetairoi Ring",
			back="Canny Cape",waist="Sarissapho. Belt",legs="Limbo Trousers",feet="Herculean Boots"})
	-- DW then haste
	sets.Mode.Haste = set_combine(sets.engaged, {
			head="Thurandaut Chapeau",ear1="Dudgeon Earring",ear2="Heartseeker Earring",
			body="Mextli Harness",hands="Herculean Gloves",
			back="Canny Cape",waist="Twilight Belt",legs="Kaabnax Trousers",feet="Herculean Boots"})
	sets.Mode.Skill = set_combine(sets.engaged, {ear1="Terminus Earring",ear2="Liminus Earring",ring2="Prouesse Ring"})
	sets.Mode.sTP = set_combine(sets.engaged, {
			neck="Asperity Necklace",ear1="Bladeborn Earring",ear2="Digni. Earring",
			body="Herculean Vest",ring1="Rajas Ring",ring2="K'ayres Ring",
			back="Laic Mantle",waist="Olseni Belt",legs="Iuitl Tights"})
	sets.Mode.STR = set_combine(sets.engaged, {
			head="Lilitu Headpiece",neck="Lacono Neck. +1",
			body="Herculean Vest",hands="Herculean Gloves",ring1="Aife's Ring",ring2="Apate Ring",
			back="Buquwik Cape",waist="Wanion Belt",legs="Herculean Trousers",feet="Herculean Boots"})

	--Initialize Main Weapons
	sets.engaged.DW = set_combine(sets.engaged, {})
	sets.engaged.Shield = set_combine(sets.engaged, {})
	sets.engaged.TH = set_combine(sets.engaged, {})
	sets.engaged.DW.Dagger = set_combine(sets.engaged, {main="Odium",sub="Izhiikoh"})
	sets.engaged.Shield.Dagger = set_combine(sets.engaged, {main="Odium",sub="Viking Shield"})
	sets.engaged.TH.Dagger = set_combine(sets.engaged,  {main="Odium",sub="Thief's Knife"})
	--Add in appropriate Ranged weapons
	sets.ranged = {}
	sets.ranged.Stats = {ranged="",ammo="Amar Cluster"}
	sets.ranged.Bow = {ranged="Killer Shortbow",ammo="Fang Arrow"}
	sets.ranged.Xbow = {ranged="Tsoa. Crossbow",ammo="Bloody Bolt"}
	sets.ranged.Boomerrang = {ranged="Aliyat Chakram",ammo=""}
	--Finalize the sets
	sets.engaged.DW.Dagger.Boomerrang = set_combine(sets.engaged.DW.Dagger, sets.ranged.Boomerrang)
	sets.engaged.DW.Dagger.Bow = set_combine(sets.engaged.DW.Dagger, sets.ranged.Bow)
	sets.engaged.DW.Dagger.Xbow = set_combine(sets.engaged.DW.Dagger, sets.ranged.Xbow)
	sets.engaged.DW.Dagger.Stats = set_combine(sets.engaged.DW.Dagger, sets.ranged.Stats)
	sets.engaged.Shield.Dagger.Boomerrang = set_combine(sets.engaged.Shield.Dagger, sets.ranged.Boomerrang)
	sets.engaged.Shield.Dagger.Bow = set_combine(sets.engaged.Shield.Dagger, sets.ranged.Bow)
	sets.engaged.Shield.Dagger.Xbow = set_combine(sets.engaged.Shield.Dagger, sets.ranged.Xbow)
	sets.engaged.Shield.Dagger.Stats = set_combine(sets.engaged.Shield.Dagger, sets.ranged.Stats)
	sets.engaged.TH.Dagger.Boomerrang = set_combine(sets.engaged.TH.Dagger, sets.ranged.Boomerrang)
	sets.engaged.TH.Dagger.Bow = set_combine(sets.engaged.TH.Dagger, sets.ranged.Bow)
	sets.engaged.TH.Dagger.Xbow = set_combine(sets.engaged.TH.Dagger, sets.ranged.Xbow)
	sets.engaged.TH.Dagger.Stats = set_combine(sets.engaged.TH.Dagger, sets.ranged.Stats)
	sets.engaged.DW.Dagger.Acc = set_combine(sets.engaged.DW.Dagger, sets.Mode.Acc)
	sets.engaged.DW.Dagger.Att = set_combine(sets.engaged.DW.Dagger, sets.Mode.Att)
	sets.engaged.DW.Dagger.Crit = set_combine(sets.engaged.DW.Dagger, sets.Mode.Crit)
	sets.engaged.DW.Dagger.DA = set_combine(sets.engaged.DW.Dagger, sets.Mode.DA)
	sets.engaged.DW.Dagger.Haste = set_combine(sets.engaged.DW.Dagger, sets.Mode.Haste)
	sets.engaged.DW.Dagger.Skill = set_combine(sets.engaged.DW.Dagger, {neck="Maskirova Torque",
        body="Raider's Vest +2",ring2="Aife's Ring"})
	sets.engaged.DW.Dagger.sTP = set_combine(sets.engaged.DW.Dagger, sets.Mode.sTP)
	sets.engaged.DW.Dagger.STR = set_combine(sets.engaged.DW.Dagger, sets.Mode.STR)
	sets.engaged.Shield.Dagger.Acc = set_combine(sets.engaged.Shield.Dagger, sets.Mode.Acc)
	sets.engaged.Shield.Dagger.Att = set_combine(sets.engaged.Shield.Dagger, sets.Mode.Att)
	sets.engaged.Shield.Dagger.Crit = set_combine(sets.engaged.Shield.Dagger, sets.Mode.Crit)
	sets.engaged.Shield.Dagger.DA = set_combine(sets.engaged.Shield.Dagger, sets.Mode.DA)
	sets.engaged.Shield.Dagger.Haste = set_combine(sets.engaged.Shield.Dagger, sets.Mode.Haste)
	sets.engaged.Shield.Dagger.Skill = set_combine(sets.engaged.Shield.Dagger, {neck="Love Torque",
        body="Raider's Vest +2",ring2="Aife's Ring"})
	sets.engaged.Shield.Dagger.sTP = set_combine(sets.engaged.Shield.Dagger, sets.Mode.sTP)
	sets.engaged.Shield.Dagger.STR = set_combine(sets.engaged.Shield.Dagger, sets.Mode.STR)
	sets.engaged.TH.Dagger.Acc = set_combine(sets.engaged.TH.Dagger, sets.Mode.Acc)
	sets.engaged.TH.Dagger.Att = set_combine(sets.engaged.TH.Dagger, sets.Mode.Att)
	sets.engaged.TH.Dagger.Crit = set_combine(sets.engaged.TH.Dagger, sets.Mode.Crit)
	sets.engaged.TH.Dagger.DA = set_combine(sets.engaged.TH.Dagger, sets.Mode.DA)
	sets.engaged.TH.Dagger.Haste = set_combine(sets.engaged.TH.Dagger, sets.Mode.Haste)
	sets.engaged.TH.Dagger.Skill = set_combine(sets.engaged.TH.Dagger, {neck="Love Torque",
        body="Raider's Vest +2",ring2="Aife's Ring"})
	sets.engaged.TH.Dagger.sTP = set_combine(sets.engaged.TH.Dagger, sets.Mode.sTP)
	sets.engaged.TH.Dagger.STR = set_combine(sets.engaged.TH.Dagger, sets.Mode.STR)
	
	sets.engaged.DW.Sword = set_combine(sets.engaged, {main="Apaisante",sub="Izhiikoh"})
	sets.engaged.Shield.Sword = set_combine(sets.engaged, {main="Apaisante",sub="Viking Shield"})
	sets.engaged.TH.Sword = set_combine(sets.engaged, {main="Apaisante",sub="Thief's Knife"})
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
	sets.engaged.Shield.Club.Skill = set_combine(sets.engaged.Shield.Club, sets.Mode.Skill)
	sets.engaged.Shield.Club.Skill.Bow = set_combine(sets.engaged.Shield.Club.Skill.Bow, sets.ranged.Bow)
	sets.engaged.TH.Club = set_combine(sets.engaged, {main="Warp Cudgel",sub="Thief's Knife"})
	sets.engaged.TH.Club.Acc = set_combine(sets.engaged.TH.Club, sets.Mode.Acc)
	sets.engaged.DW.H2H = set_combine(sets.engaged, {main="",sub=""})
	sets.engaged.DW.H2H.Acc = set_combine(sets.engaged.Club, sets.Mode.Acc)
	sets.engaged.DW.Staff = set_combine(sets.engaged, {main="Chatoyant Staff",sub="Pole Grip"})
	sets.engaged.DW.Staff.Acc = set_combine(sets.engaged.Staff, sets.Mode.Acc, {})
	sets.engaged.Shield.Staff = set_combine(sets.engaged, {main="Chatoyant Staff",sub="Pole Grip"})
	sets.engaged.Shield.Staff.Acc = set_combine(sets.engaged.Staff, sets.Mode.Acc, {})
	sets.engaged.TH.Staff = set_combine(sets.engaged, {main="Chatoyant Staff",sub="Pole Grip"})
	sets.engaged.TH.Staff.Acc = set_combine(sets.engaged.Staff, sets.Mode.Acc, {})
	sets.engaged.DW.Polearm = set_combine(sets.engaged, {main="Pitchfork",sub="Pole Grip"})
	sets.engaged.DW.Polearm.Acc = set_combine(sets.engaged.Polearm, sets.Mode.Acc)
	sets.engaged.Shield.Polearm = set_combine(sets.engaged, {main="Pitchfork",sub="Pole Grip"})
	sets.engaged.Shield.Polearm.Acc = set_combine(sets.engaged.Polearm, sets.Mode.Acc)
	sets.engaged.TH.Polearm = set_combine(sets.engaged, {main="Pitchfork",sub="Pole Grip"})
	sets.engaged.TH.Polearm.Acc = set_combine(sets.engaged.Polearm, sets.Mode.Acc)
	sets.engaged.DW.Scythe = set_combine(sets.engaged, {main="Ark Scythe",sub="Pole Grip"})
	sets.engaged.DW.Scythe.Acc = set_combine(sets.engaged.Scythe, sets.Mode.Acc)
	sets.engaged.Shield.Scythe = set_combine(sets.engaged, {main="Ark Scythe",sub="Pole Grip"})
	sets.engaged.Shield.Scythe.Acc = set_combine(sets.engaged.Scythe, sets.Mode.Acc)
	sets.engaged.TH.Scythe = set_combine(sets.engaged, {main="Ark Scythe",sub="Pole Grip"})
	sets.engaged.TH.Scythe.Acc = set_combine(sets.engaged.Scythe, sets.Mode.Acc)

    --------------------------------------
    -- Special sets (required by rules)
    --------------------------------------

    sets.TreasureHunter = {head="Herculean Helm",hands="Plun. Armlets", waist="Chaac Belt", feet="Raid. Poulaines +2"}
    sets.ExtraRegen = {}
    sets.Kiting = {feet="Skd. Jambeaux +1"}

	-- SA then DEX
    sets.buff['Sneak Attack'] = {
        head="Lilitu Headpiece",neck="Asperity Necklace",ear1="Dudgeon Earring",ear2="Heartseeker Earring",
        body="Plunderer's Vest",hands="Raid. Armlets +2",ring1="Rajas Ring",ring2="Apate Ring",
        back="Canny Cape",waist="Wanion Belt",legs="Manibozho Brais",feet="Herculean Boots"}

	-- TA then AGI
    sets.buff['Trick Attack'] = {
        head="Herculean Helm",neck="Asperity Necklace",ear1="Dudgeon Earring",ear2="Heartseeker Earring",
        body="Plunderer's Vest",hands="Rog. Armlets +1",ring1="Rajas Ring",ring2="Apate Ring",
        back="Canny Cape",waist="Chaac Belt",legs="Herculean Trousers",feet="Herculean Boots"}

    -- Actions we want to use to tag TH.
    sets.precast.Step = sets.TreasureHunter
    sets.precast.Flourish1 = sets.TreasureHunter
    sets.precast.JA.Provoke = sets.TreasureHunter


    --------------------------------------
    -- Precast sets
    --------------------------------------

    -- Precast sets to enhance JAs
    sets.precast.JA['Collaborator'] = {head="Raid. Bonnet +2"}
    sets.precast.JA['Accomplice'] = {head="Raid. Bonnet +2"}
    sets.precast.JA['Flee'] = {feet="Rog. Poulaines +1"}
    sets.precast.JA['Hide'] = {body="Rogue's Vest"}
    sets.precast.JA['Conspirator'] = {body="Raider's Vest +2"} 
    sets.precast.JA['Steal'] = {head="Assassin's Bonnet +2",hands="Rog. Armlets +1",waist="Key Ring Belt",legs="Pillager's Culottes +1",feet="Rog. Poulaines +1"}
    sets.precast.JA['Despoil'] = {legs="Raid. Culottes +2",feet="Raid. Poulaines +2"}
    sets.precast.JA['Perfect Dodge'] = {hands="Plun. Armlets"}
    sets.precast.JA['Feint'] = {legs="Plun. Culottes"} 

    sets.precast.JA['Sneak Attack'] = sets.buff['Sneak Attack']
    sets.precast.JA['Trick Attack'] = sets.buff['Trick Attack']


    -- Waltz set (chr and vit)
    sets.precast.Waltz = {
        head="Uk'uxkaj Cap",
        body="Herculean Vest",hands="Buremte Gloves",
        legs="Iuitl Tights",feet="Thurandaut Boots"}

    -- Don't need any special gear for Healing Waltz.
    sets.precast.Waltz['Healing Waltz'] = {}


    -- Fast cast sets for spells
    sets.precast.FC = {head="Herculean Helm",hands="Thaumas Gloves",ring1="Prolix Ring",legs="Limbo Trousers"}

    sets.precast.FC.Utsusemi = set_combine(sets.precast.FC, {neck="Magoraga Beads"})

	sets.precast['Elemental Magic'] = set_combine(sets.TreasureHunter, {ear1="Friomisi Earring",ear2="Crematio Earring",
		ring1="Patricius Ring",ring2="Perception Ring",
		back="Toro Cape",legs="Iuitl Tights"})

    -- Ranged snapshot gear
    sets.precast.RA = {head="Optical Hat",neck="Iqabi Necklace",hands="Iuitl Wristbands",legs="Nahtirah Trousers",feet="Wurrukatte Boots"}


    -- Weaponskill sets

    -- Default set for any weaponskill that isn't any more specifically defined
    sets.precast.WS = set_combine(sets.Mode.STR, {neck="Fotia Gorget",waist="Fotia Belt"})
    sets.precast.WS.Acc = set_combine(sets.precast.WS, {})

    -- Specific weaponskill sets.  Uses the base set if an appropriate WSMod version isn't found.
	-- Earth, DEX 100%
	sets.precast.WS['Wasp Sting'] = set_combine(sets.precast.WS, {neck="Soil Gorget",waist="Soil Belt"})

	-- Wind, DEX 40% INT 40%
	sets.precast.WS['Gust Slash'] = set_combine(sets.precast.WS, {legs="Limbo Trousers",feet="Herculean Boots"})

	-- Water, CHR 100%
	sets.precast.WS['Shadowstitch'] = set_combine(sets.precast.WS, {})

 	-- Earth, DEX 100%
	sets.precast.WS['Viper Bite'] = set_combine(sets.precast.WS, {neck="Soil Gorget",waist="Soil Belt"})
 
 	-- Wind/Thunder, DEX 40% INT 40%
	sets.precast.WS['Cyclone'] = set_combine(sets.precast.WS, {legs="Limbo Trousers",feet="Herculean Boots"})
 
  	-- none, MND 100%
	sets.precast.WS['Energy Steal'] = set_combine(sets.precast.WS, {})
 
  	-- none, MND 100%
	sets.precast.WS['Energy Drain'] = set_combine(sets.precast.WS, {})

	-- Wind/Earth, DEX 40% CHR 40%
    sets.precast.WS['Dancing Edge'] = set_combine(sets.precast.WS, {})
    sets.precast.WS['Dancing Edge'].Acc = set_combine(sets.precast.WS['Dancing Edge'], {})
    sets.precast.WS['Dancing Edge'].Mod = set_combine(sets.precast.WS['Dancing Edge'], {waist=gear.ElementalBelt})
    sets.precast.WS['Dancing Edge'].SA = set_combine(sets.precast.WS['Dancing Edge'].Mod, {})
    sets.precast.WS['Dancing Edge'].TA = set_combine(sets.precast.WS['Dancing Edge'].Mod, {})
    sets.precast.WS['Dancing Edge'].SATA = set_combine(sets.precast.WS['Dancing Edge'].Mod, {})
	
	-- Wind/Thunder, DEX 40% AGI 40%
    sets.precast.WS["Shark Bite"] = set_combine(sets.precast.WS, {})
    sets.precast.WS['Shark Bite'].Acc = set_combine(sets.precast.WS['Shark Bite'], {})
    sets.precast.WS['Shark Bite'].SA = set_combine(sets.precast.WS['Shark Bite'].Mod, {
        body="Pillager's Vest +1",legs="Pillager's Culottes +1"})
    sets.precast.WS['Shark Bite'].TA = set_combine(sets.precast.WS['Shark Bite'].Mod, {
        body="Pillager's Vest +1",legs="Pillager's Culottes +1"})
    sets.precast.WS['Shark Bite'].SATA = set_combine(sets.precast.WS['Shark Bite'].Mod, {
        body="Pillager's Vest +1",legs="Pillager's Culottes +1"})

	-- Light/Dark/Earth, DEX 50%
    sets.precast.WS['Evisceration'] = set_combine(sets.precast.WS, sets.Mode.Crit, {})
    sets.precast.WS['Evisceration'].Acc = set_combine(sets.precast.WS['Evisceration'], {})
    sets.precast.WS['Evisceration'].SA = set_combine(sets.precast.WS['Evisceration'].Mod, {})
    sets.precast.WS['Evisceration'].TA = set_combine(sets.precast.WS['Evisceration'].Mod, {})
    sets.precast.WS['Evisceration'].SATA = set_combine(sets.precast.WS['Evisceration'].Mod, {})

	-- Wind/Thunder/Earth, DEX 40% AGI 40%
    sets.precast.WS['Aeolian Edge'] = set_combine(sets.precast.WS, {
        head="Wayfarer Circlet",ear1="Friomisi Earring",ear2="Crematio Earring",
        body="Wayfarer Robe",hands="Pillager's Armlets +1",
        back="Toro Cape",legs="Limbo Trousers",feet="Herculean Boots"})
    sets.precast.WS['Aeolian Edge'].TH = set_combine(sets.precast.WS['Aeolian Edge'], sets.TreasureHunter)

	-- Wind/Thunder/Earth, AGI 73%
	sets.precast.WS['Exenterator'] = set_combine(sets.precast.WS, {})
    sets.precast.WS['Exenterator'].Acc = set_combine(sets.precast.WS['Exenterator'], {})
    sets.precast.WS['Exenterator'].Mod = set_combine(sets.precast.WS['Exenterator'], {waist=gear.ElementalBelt})
    sets.precast.WS['Exenterator'].SA = set_combine(sets.precast.WS['Exenterator'].Mod, {})
    sets.precast.WS['Exenterator'].TA = set_combine(sets.precast.WS['Exenterator'].Mod, {})
    sets.precast.WS['Exenterator'].SATA = set_combine(sets.precast.WS['Exenterator'].Mod, {})

	-- Ice/Water/Dark, DEX 80%
    sets.precast.WS["Rudra's Storm"] = set_combine(sets.precast.WS, {})
    sets.precast.WS["Rudra's Storm"].Acc = set_combine(sets.precast.WS["Rudra's Storm"], {})
    sets.precast.WS["Rudra's Storm"].SA = set_combine(sets.precast.WS["Rudra's Storm"].Mod, {
        body="Pillager's Vest +1",legs="Pillager's Culottes +1"})
    sets.precast.WS["Rudra's Storm"].TA = set_combine(sets.precast.WS["Rudra's Storm"].Mod, {
        body="Pillager's Vest +1",legs="Pillager's Culottes +1"})
    sets.precast.WS["Rudra's Storm"].SATA = set_combine(sets.precast.WS["Rudra's Storm"].Mod, {
        body="Pillager's Vest +1",legs="Pillager's Culottes +1"})

	-- Light/Fire/Dark, DEX 60%
    sets.precast.WS['Mandalic Stab'] = set_combine(sets.precast.WS, {})
    sets.precast.WS['Mandalic Stab'].Acc = set_combine(sets.precast.WS['Mandalic Stab'], {})
    sets.precast.WS['Mandalic Stab'].SA = set_combine(sets.precast.WS['Mandalic Stab'].Mod, {
        body="Pillager's Vest +1",legs="Pillager's Culottes +1"})
    sets.precast.WS['Mandalic Stab'].TA = set_combine(sets.precast.WS['Mandalic Stab'].Mod, {
        body="Pillager's Vest +1",legs="Pillager's Culottes +1"})
    sets.precast.WS['Mandalic Stab'].SATA = set_combine(sets.precast.WS['Mandalic Stab'].Mod, {
        body="Pillager's Vest +1",legs="Pillager's Culottes +1"})

	--------------------------------------
    -- Midcast sets
    --------------------------------------

    sets.midcast.FastRecast = {
        head="Herculean Helm",
        body="Pillager's Vest +1",hands="Pillager's Armlets +1",
        back="Canny Cape",legs="Kaabnax Trousers"}
	
	sets.midcast['Elemental Magic'] = set_combine(sets.TreasureHunter, {ear1="Friomisi Earring",ear2="Crematio Earring",
		neck="Melic Torque",ring1="Patricius Ring",ring2="Diamond Ring",
		back="Toro Cape",legs="Iuitl Tights"})

    -- Specific spells
    sets.midcast.Utsusemi = {
        head="Whirlpool Mask",
        body="Pillager's Vest +1",hands="Pillager's Armlets +1",
        back="Canny Cape",legs="Kaabnax Trousers"}

    -- Ranged gear
    sets.midcast.RA = {
        head="Optical Hat",neck="Iqabi Necklace",ear2="Volley Earring",
        body="Herculean Vest",hands="Herculean Gloves",ring1="Behemoth Ring",ring2="Scorpion Ring +1",
        waist="Flax Sash",legs="Nahtirah Trousers",feet="Herculean Boots"}

    sets.midcast.RA.Acc = set_combine(sets.midcast.RA, {})

	-- Defense sets

    sets.defense.Evasion = {
        head="Lilitu Headpiece",ear1="Ethereal Earring",ear2="Assuage Earring",
        body="Herculean Vest",hands="Herculean Gloves",ring1="Vengeful Ring",
        back="Canny Cape",legs="Herculean Trousers",feet="Herculean Boots"}

    sets.defense.PDT = {
        head="Uk'uxkaj Cap",neck="Twilight Torque",
        body="Iuitl Vest",hands="Umuthi Gloves",ring1="Patricius Ring",
        legs="Iuitl Tights",feet="Thurandaut Boots"}

    sets.defense.MDT = {
        head="Uk'uxkaj Cap",neck="Twilight Torque",
        body="Herculean Vest",hands="Herculean Gloves",ring1="Vengeful Ring",
        waist="Flax Sash",legs="Feast Hose",feet="Herculean Boots"}

 	-- Melee sets for in Adoulin, which has an extra 2% Haste from Ionis.
	sets.engaged.Adoulin = set_combine(sets.engaged, {})
	sets.engaged.Assault = set_combine(sets.engaged, {ring2="Ulthalam's Ring"}) 
end


-------------------------------------------------------------------------------------------------------------------
-- Job-specific hooks for standard casting events.
-------------------------------------------------------------------------------------------------------------------

-- Run after the general precast() is done.
function job_post_precast(spell, action, spellMap, eventArgs)
    if spell.english == 'Aeolian Edge' and state.TreasureMode.value ~= 'None' then
        equip(sets.TreasureHunter)
    elseif spell.english=='Sneak Attack' or spell.english=='Trick Attack' or spell.type == 'WeaponSkill' then
        if state.TreasureMode.value == 'SATA' or state.TreasureMode.value == 'Fulltime' then
            equip(sets.TreasureHunter)
        end
    end
end

-- Run after the general midcast() set is constructed.
function job_post_midcast(spell, action, spellMap, eventArgs)
    if state.TreasureMode.value ~= 'None' and spell.action_type == 'Ranged Attack' then
        equip(sets.TreasureHunter)
    end
end

-- Set eventArgs.handled to true if we don't want any automatic gear equipping to be done.
function job_aftercast(spell, action, spellMap, eventArgs)
    -- Weaponskills wipe SATA/Feint.  Turn those state vars off before default gearing is attempted.
    if spell.type == 'WeaponSkill' and not spell.interrupted then
        state.Buff['Sneak Attack'] = false
        state.Buff['Trick Attack'] = false
        state.Buff['Feint'] = false
    end
end

-- Called after the default aftercast handling is complete.
function job_post_aftercast(spell, action, spellMap, eventArgs)
    -- If Feint is active, put that gear set on on top of regular gear.
    -- This includes overlaying SATA gear.
    check_buff('Feint', eventArgs)
end

-------------------------------------------------------------------------------------------------------------------
-- Job-specific hooks for non-casting events.
-------------------------------------------------------------------------------------------------------------------

-- Called when a player gains or loses a buff.
-- buff == buff gained or lost
-- gain == true if the buff was gained, false if it was lost.
function job_buff_change(buff, gain)
    if state.Buff[buff] ~= nil then
        if not midaction() then
            handle_equipping_gear(player.status)
        end
    end
end


-------------------------------------------------------------------------------------------------------------------
-- User code that supplements standard library decisions.
-------------------------------------------------------------------------------------------------------------------

function get_custom_wsmode(spell, spellMap, defaut_wsmode)
    local wsmode

    if state.Buff['Sneak Attack'] then
        wsmode = 'SA'
    end
    if state.Buff['Trick Attack'] then
        wsmode = (wsmode or '') .. 'TA'
    end

    return wsmode
end


-- Called any time we attempt to handle automatic gear equips (ie: engaged or idle gear).
function job_handle_equipping_gear(playerStatus, eventArgs)
    -- Check that ranged slot is locked, if necessary
    -- check_range_lock()

    -- Check for SATA when equipping gear.  If either is active, equip
    -- that gear specifically, and block equipping default gear.
    check_buff('Sneak Attack', eventArgs)
    check_buff('Trick Attack', eventArgs)
	
	check_tp_lock()
	set_combat_form()
	pick_tp_weapon()
end


function customize_idle_set(idleSet)
    if player.hpp < 80 then
        idleSet = set_combine(idleSet, sets.ExtraRegen)
    end

    return idleSet
end


function customize_melee_set(meleeSet)
    if state.TreasureMode.value == 'Fulltime' then
        meleeSet = set_combine(meleeSet, sets.TreasureHunter)
    end

    return meleeSet
end


-- Called by the 'update' self-command.
function job_update(cmdParams, eventArgs)
    th_update(cmdParams, eventArgs)
	-- classes.CustomMeleeGroups:clear()
	-- if areas.Adoulin:contains(world.area) and buffactive.ionis then
			-- classes.CustomMeleeGroups:append('Adoulin')
	-- end
	-- if areas.Assault:contains(world.area) then
			-- classes.CustomMeleeGroups:append('Assault')
	-- end
	pick_tp_weapon()
end

-- Function to display the current relevant user state when doing an update.
-- Return true if display was handled, and you don't want the default info shown.
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
    
    if state.Kiting.value == true then
        msg = msg .. ', Kiting'
    end

    if state.PCTargetMode.value ~= 'default' then
        msg = msg .. ', Target PC: '..state.PCTargetMode.value
    end

    if state.SelectNPCTargets.value == true then
        msg = msg .. ', Target NPCs'
    end
    
    msg = msg .. ', TH: ' .. state.TreasureMode.value

    add_to_chat(122, msg)
	if stateField == 'Weapon Mode' then
		if newValue ~= 'Normal' then
			state.CombatWeapon:set(newValue)
		else
			state.CombatWeapon:reset()
		end
	end
	if stateField == 'Sub Mode' then
		if newValue ~= 'Normal' then
			state.CombatForm:set(newValue)
		else
			state.CombatForm:reset()
		end
	end

    eventArgs.handled = true
end

-------------------------------------------------------------------------------------------------------------------
-- Utility functions specific to this job.
-------------------------------------------------------------------------------------------------------------------

-- State buff checks that will equip buff gear and mark the event as handled.
function check_buff(buff_name, eventArgs)
    if state.Buff[buff_name] then
        equip(sets.buff[buff_name] or {})
        if state.TreasureMode.value == 'SATA' or state.TreasureMode.value == 'Fulltime' then
            equip(sets.TreasureHunter)
        end
        eventArgs.handled = true
    end
end


-- Check for various actions that we've specified in user code as being used with TH gear.
-- This will only ever be called if TreasureMode is not 'None'.
-- Category and Param are as specified in the action event packet.
function th_action_check(category, param)
    if category == 2 or -- any ranged attack
        --category == 4 or -- any magic action
        (category == 3 and param == 30) or -- Aeolian Edge
        (category == 6 and info.default_ja_ids:contains(param)) or -- Provoke, Animated Flourish
        (category == 14 and info.default_u_ja_ids:contains(param)) -- Quick/Box/Stutter Step, Desperate/Violent Flourish
        then return true
    end
end


-- Function to lock the ranged slot if we have a ranged weapon equipped.
function check_range_lock()
    if player.equipment.range ~= 'empty' then
        disable('range', 'ammo')
    else
        enable('range', 'ammo')
    end
end

-- Select default macro book on initial load or subjob change.
function select_default_macro_book()
	-- Default macro set/book
	if player.sub_job == 'DNC' then
		set_macro_page(3, 4)
		send_command('exec thfdnc.txt')
	elseif player.sub_job == 'WAR' then
		set_macro_page(2, 4)
	elseif player.sub_job == 'NIN' then
		set_macro_page(1, 4)
	else
		set_macro_page(1, 4)
	end
	send_command('exec thf.txt')
end
