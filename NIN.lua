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
    state.Buff.Migawari = buffactive.migawari or false
    state.Buff.Doom = buffactive.doom or false
    state.Buff.Yonin = buffactive.Yonin or false
    state.Buff.Innin = buffactive.Innin or false
    state.Buff.Futae = buffactive.Futae or false
	state.Stance = M{['description']='Stance', 'Off', 'None', 'Offensive', 'Defensive'}
 
    -- determine_haste_group()

	state.WeaponMode = M{['description']='Weapon Mode', 'Katana', 'Dagger', 'Club', 'Sword', 'GreatKatana', 'Scythe', 'Polearm', 'Staff' }
	state.RWeaponMode = M{['description']='RWeapon Mode', 'Stats', 'Bow', 'Gun', 'Boomerrang', 'Shuriken'}
 
	set_combat_form()
	pick_tp_weapon()
end

-------------------------------------------------------------------------------------------------------------------
-- User setup functions for this job.  Recommend that these be overridden in a sidecar file.
-------------------------------------------------------------------------------------------------------------------

-- Setup vars that are user-dependent.  Can override this function in a sidecar file.
function user_setup()
	state.OffenseMode:options('Normal', 'Acc', 'Att', 'Crit', 'DA', 'Haste', 'Skill', 'sTP', 'STR')
    state.WeaponskillMode:options('Normal', 'Acc', 'Mod')
    state.CastingMode:options('Normal', 'Resistant')
	state.DefenseMode:options('None', 'Physical', 'Magical')
	state.PhysicalDefenseMode:options('PDT', 'Evasion')
	state.MagicalDefenseMode:options('MDT')
	state.WeaponMode:set('Katana')
	state.RWeaponMode:set('Boomerrang') 
	state.Stance:set('None')
	
    gear.MovementFeet = {name="Danzo Sune-ate"}
    gear.DayFeet = "Danzo Sune-ate"
    gear.NightFeet = "Nin. Kyahan +1"
	gear.NinAmmo = {name="Amar Cluster"}
	gear.NinRanged = {name=""}
	gear.StatsAmmo = "Amar Cluster"
	gear.MaccAmmo = "Pemphredo Tathlum"
	gear.empty = ""
	gear.BowAmmo = "Fang Arrow"
	gear.BowRanged = "Killer Shortbow"
	gear.GunAmmo = "Bronze Bullet"
	gear.GunRanged = "Shark Gun"
	gear.BoomerrangRanged = "Aliyat Chakram"
	gear.Shuriken = "Manji Shuriken"
    
    select_movement_feet()
	select_ammo_type('melee')
    select_default_macro_book()
	
	-- send_command('bind ^` gs c cycle WeaponMode')
	-- send_command('bind !` gs c cycle SubMode')
end

-- Define sets and vars used by this job file.
function init_gear_sets()
	-- extra stuff
	organizer_items = {
		new1="Herculean Gloves",
		new2="Herculean Helm",
		new3="Herculean Boots",
		new4="Phalangite Mantle",
		new5="Perception Ring",
		new6="Herculean Vest",
		StatsAmmo="Amar Cluster",
		MaccAmmo="Pemphredo Tathlum",
		BowAmmo="Fang Arrow",
		BowRanged="Killer Shortbow",
		GunAmmo="Bronze Bullet",
		GunRanged="Shark Gun",
		BoomerrangRanged="Aliyat Chakram",
		Shuriken="Manji Shuriken",
		echos="Echo Drops",
		Chonofuda="Chonofuda",
		Furusumi="Furusumi",
		Hiraishin="Hiraishin",
		Inoshishinofuda="Inoshishinofuda",
		Jinko="Jinko",
		Jusatsu="Jusatsu",
		Kabenro="Kabenro",
		Kaginawa="Kaginawa",
		KawahoriOgi="Kawahori-Ogi",
		Kodoku="Kodoku",
		Makibishi="Makibishi",
		MizuDeppo="Mizu-Deppo",
		Mokujin="Mokujin",
		Ryuno="Ryuno",
		SairuiRan="Sairui-Ran",
		SanjakuTenugui="Sanjaku-Tenugui",
		Shihei="Shihei",
		Shikanofuda="Shikanofuda",
		ShinobiTabi="Shinobi-Tabi",
		Soshi="Soshi",
		Tsurara="Tsurara",
		Uchitake="Uchitake",
		orb="Macrocosmic Orb"
	}

	-- Idle sets
    sets.idle = {
        head="Gavialis Helm",neck="Twilight Torque",ear1="Dudgeon Earring",ear2="Heartseeker Earring",
        body="Hachi. Chainmail",hands="Otronif Gloves +1",ring1="Vengeful Ring",ring2="Patricius Ring",
        back="Grounded Mantle",waist="Flax Sash",legs="Herculean Trousers",feet=gear.MovementFeet}

	-- Idle sets (default idle set not needed since the other three are defined, but leaving for testing purposes)
	sets.idle.Town = set_combine(sets.idle, {})
   
	sets.idle.Field = set_combine(sets.idle, {})

	sets.idle.Weak = set_combine(sets.idle, {})

	-- Resting sets
	sets.resting = set_combine(sets.idle, {})

	-- Engaged sets
	-- Variations for TP weapon and (optional) offense/defense modes.  Code will fall back on previous
	-- sets if more refined versions aren't defined.
	-- If you create a set with both offense and defense modes, the offense mode should be first.
	-- EG: sets.engaged.Dagger.Accuracy.Evasion

	-- Normal melee group
    sets.engaged = {
        head="Iga Zukin +2",neck="Sanctity Necklace",ear1="Brutal Earring",ear2="Suppanomimi",
        body="Hachi. Chainmail",hands="Count's Cuffs",ring1="Hetairoi Ring",ring2="Apate Ring",
        back="Atheling Mantle",waist="Sarissapho. Belt",legs="Mochizuki Hakama",feet="Scamp's Sollerets"}
 	sets.engaged.Katana = {}
	sets.engaged.Dagger = {}
	sets.engaged.Club = {}
	sets.engaged.Sword = {}
	sets.engaged.GreatKatana = {}
	sets.engaged.Scythe = {}
	sets.engaged.Polearm = {}
	sets.engaged.Staff = {}

	-- Basic Mode definitions
	sets.Mode = {}
	sets.Mode.Acc = set_combine(sets.engaged, {
			head="Whirlpool Mask",neck="Iqabi Necklace",ear1="Zennaroi Earring",ear2="Digni. Earring",
			body="Iga Ningi +2",hands="Buremte Gloves",ring1="Patricius Ring",ring2="Ulthalam's Ring",
			back="Grounded Mantle",waist="Olseni Belt",legs="Feast Hose",feet="Scamp's Sollerets"})
	sets.Mode.Att= set_combine(sets.engaged, {
			head="Lilitu Headpiece",neck="Sanctity Necklace",ear1="Bladeborn Earring",ear2="Dudgeon Earring",
			body="Iga Ningi +2",hands="Count's Cuffs",ring1="Overbearing Ring",ring2="Cho'j Band",
			back="Atheling Mantle",legs="Manibozho Brais",feet="Otronif Boots"})
	-- Crit then dex
	sets.Mode.Crit = set_combine(sets.engaged, {
			head="Uk'uxkaj Cap",neck="Iga Erimaki",
			back="Iga Ningi +2",hands="Count's Cuffs",ring1="Hetairoi Ring",
			back="Laic Mantle",waist="Chaac Belt",legs="Byakko's Haidate",feet="Otronif Boots"})
	sets.Mode.DA = set_combine(sets.engaged, {
			head="Iga Zukin +2",neck="Asperity Necklace",ear1="Bladeborn Earring",ear2="Steelflash Earring",
			body="Iga Ningi +2",hands="Iga Tekko +2",ring1="Hetairoi Ring",
			back="Atheling Mantle",waist="Sarissapho. Belt",legs="Quiahuiz Trousers",feet="Iga Kyahan +2"})
	-- DW then haste
	sets.Mode.Haste = set_combine(sets.engaged, {
			head="Iga Zukin +2",ear1="Dudgeon Earring",ear2="Heartseeker Earring",
			body="Hachi. Chainmail",hands="Iga Tekko +2",
			back="Grounded Mantle",waist="Twilight Belt",legs="Mochizuki Hakama",feet="Iga Kyahan +2"})
	sets.Mode.Skill = set_combine(sets.engaged, {ear1="Terminus Earring",ear2="Liminus Earring",ring2="Prouesse Ring"})
	-- sTP then subtle blow
	sets.Mode.sTP = set_combine(sets.engaged, {
			head="Whirlpool Mask",neck="Asperity Necklace",ear1="Tripudio Earring",ear2="Digni. Earring",
			body="Hachi. Chainmail",hands="Otronif Gloves +1",ring1="Rajas Ring",ring2="K'ayres Ring",
			waist="Olseni Belt",feet="Otronif Boots"})
	sets.Mode.STR = set_combine(sets.engaged, {
			head="Lilitu Headpiece",neck="Lacono Neck. +1",
			body="Otronif Harness",hands="Mochizuki Tekko",ring1="Rajas Ring",ring2="Apate Ring",
			back="Buquwik Cape",legs="Herculean Trousers",feet="Scamp's Sollerets"})

	--Initialize Main Weapons
	sets.engaged.Stats = set_combine(sets.engaged, {})
	sets.engaged.Boomerrang = set_combine(sets.engaged, {})
	sets.engaged.Shuriken = set_combine(sets.engaged, {})
	-- sets.engaged.KatanaOld = set_combine(sets.engaged, {main="Kannagi", sub="Raimitsukane"})
	sets.engaged.Katana = set_combine(sets.engaged, {main="Kanaria", sub="Achiuchikapu"})
	--Add in appropriate Ranged weapons
	sets.ranged = {}
	sets.ranged.Stats = {ranged=gear.NinRanged,ammo=gear.NinAmmo}
	sets.ranged.Boomerrang = {ranged=gear.NinRanged,ammo=gear.NinAmmo}
	sets.ranged.Shuriken = {ranged=gear.NinRanged,ammo=gear.NinAmmo}
	sets.ranged.Bow = {ranged=gear.NinRanged,ammo=gear.NinAmmo}
	sets.ranged.Gun = {ranged=gear.NinRanged,ammo=gear.NinAmmo}
	sets.engaged.Katana.Bow = set_combine(sets.engaged.Katana, sets.ranged.Bow)
	sets.engaged.Katana.Gun = set_combine(sets.engaged.Katana, sets.ranged.Gun)

	sets.engaged.Katana.Stats = set_combine(sets.engaged.Katana, sets.ranged.Stats)
	sets.engaged.Katana.Boomerrang = set_combine(sets.engaged.Katana, sets.ranged.Boomerrang)
	sets.engaged.Katana.Shuriken = set_combine(sets.engaged.Katana, sets.ranged.Shuriken)
	--Finalize the sets
	sets.engaged.Katana.Acc = set_combine(sets.engaged.Katana, sets.Mode.Acc)
	sets.engaged.Katana.Att = set_combine(sets.engaged.Katana, sets.Mode.Att)
	sets.engaged.Katana.Crit = set_combine(sets.engaged.Katana, sets.Mode.Crit)
	sets.engaged.Katana.DA = set_combine(sets.engaged.Katana, sets.Mode.DA)
	sets.engaged.Katana.Haste = set_combine(sets.engaged.Katana, sets.Mode.Haste)
	sets.engaged.Katana.Skill = set_combine(sets.engaged.Katana, sets.Mode.Skill, {
		head="Kanja Hachimaki",neck="Hope Torque",
		body="Mextli Harness",
		legs="Iga Hakama +2"})
	sets.engaged.Katana.sTP = set_combine(sets.engaged.Katana, sets.Mode.sTP)
	sets.engaged.Katana.STR = set_combine(sets.engaged.Katana, sets.Mode.STR)
	--Other weapons (should inherit most recent ranged, no need to explicitly set)
	sets.engaged.Staff = set_combine(sets.engaged, {main="Chatoyant Staff",sub="Pole Grip"})
	sets.engaged.Staff.Acc = set_combine(sets.engaged.Staff, sets.Mode.Acc, {})
	sets.engaged.Dagger = set_combine(sets.engaged, {main="Odium"})
	sets.engaged.Dagger.Acc = set_combine(sets.engaged.Dagger, sets.Mode.Acc)
	sets.engaged.Club = set_combine(sets.engaged, {main="Warp Cudgel"})
	sets.engaged.Club.Acc = set_combine(sets.engaged.Club, sets.Mode.Acc)
	sets.engaged.Sword = set_combine(sets.engaged, {main="Apaisante"})
	sets.engaged.Sword.Acc = set_combine(sets.engaged.Sword, sets.Mode.Acc)
	sets.engaged.Polearm = set_combine(sets.engaged, {main="Pitchfork",sub="Pole Grip"})
	sets.engaged.Polearm.Acc = set_combine(sets.engaged.Polearm, sets.Mode.Acc)
	sets.engaged.Scythe = set_combine(sets.engaged, {main="Ark Scythe",sub="Pole Grip"})
	sets.engaged.Scythe.Acc = set_combine(sets.engaged.Scythe, sets.Mode.Acc)
	sets.engaged.GreatKatana = set_combine(sets.engaged, {main="Hardwood Katana",sub="Pole Grip"})
	sets.engaged.GreatKatana.Bow = set_combine(sets.engaged.GreatKatana, sets.ranged.Bow)
	sets.engaged.GreatKatana.Gun = set_combine(sets.engaged.GreatKatana, sets.ranged.Gun)
	sets.engaged.GreatKatana.Stats = set_combine(sets.engaged.GreatKatana, sets.ranged.Stats)
	sets.engaged.GreatKatana.Boomerrang = set_combine(sets.engaged.GreatKatana, sets.ranged.Boomerrang)
	sets.engaged.GreatKatana.Shuriken = set_combine(sets.engaged.GreatKatana, sets.ranged.Shuriken)
	sets.engaged.GreatKatana.Acc = set_combine(sets.engaged.GreatKatana, sets.Mode.Acc)
	sets.engaged.GreatKatana.Skill = set_combine(sets.engaged.GreatKatana, sets.Mode.Skill)
	sets.engaged.GreatKatana.Skill.Bow = set_combine(sets.engaged.GreatKatana, sets.Mode.Skill, sets.ranged.Bow)
	sets.engaged.GreatKatana.Skill.Gun = set_combine(sets.engaged.GreatKatana, sets.Mode.Skill, sets.ranged.Gun)
	sets.engaged.GreatKatana.Skill.Boomerrang = set_combine(sets.engaged.GreatKatana, sets.Mode.Skill, sets.ranged.Boomerrang)

	-- Precast sets
    sets.precast.JA['Mijin Gakure'] = {legs="Mochizuki Hakama"}
    sets.precast.JA['Futae'] = {legs="Iga Tekko +2"}
    sets.precast.JA['Sange'] = {legs="Mochizuki Chainmail"}

    -- Waltz set (chr and vit)
    sets.precast.Waltz = {
        body="Hachi. Chainmail",hands="Buremte Gloves",
        legs="Nahtirah Trousers",feet="Scamp's Sollerets"}
        
    -- Don't need any special gear for Healing Waltz.
    sets.precast.Waltz['Healing Waltz'] = {}

    -- Set for acc on steps, since Yonin drops acc a fair bit
    sets.precast.Step = set_combine(sets.Mode.Acc, {
        head="Whirlpool Mask",
        body="Otronif Harness",hands="Buremte Gloves",ring1="Patricius Ring",
        back="Yokaze Mantle",waist="Chaac Belt",legs="Manibozho Brais",feet="Otronif Boots"})

    sets.precast.Flourish1 = {waist="Chaac Belt"}

    -- Fast cast sets for spells
    sets.precast.FC = {}
    sets.precast.FC.Utsusemi = set_combine(sets.precast.FC, {neck="Magoraga Beads",body="Mochizuki Chainmail"})

    -- Snapshot for ranged
    sets.precast.RA = {ear1="Terminus Earring",ring2="Prouesse Ring",legs="Nahtirah Trousers"}
       
    -- Weaponskill sets
    -- Default set for any weaponskill that isn't any more specifically defined
	-- Specific weaponskill sets.  Uses the base set if an appropriate WSMod version isn't found.
	sets.precast.WS = set_combine(sets.Mode.STR, {neck="Fotia Gorget",waist="Fotia Belt"})    
	sets.WSDayBonus = {head="Gavialis Helm"} 
	sets.precast.WS.Acc = set_combine(sets.precast.WS, {})

    -- Specific weaponskill sets.  Uses the base set if an appropriate WSMod version isn't found.
	-- Light, STR 60% DEX 60%
	sets.precast.WS['Blade: Rin'] = set_combine(sets.precast.WS, sets.Mode.Crit, {neck="Light Gorget",waist="Light Belt"})

 	-- Earth, STR 20% DEX 60%
	sets.precast.WS['Blade: Retsu'] = set_combine(sets.precast.WS, {neck="Soil Gorget",waist="Soil Belt"})
	
	-- Water, STR 30% INT 30%
	sets.precast.WS['Blade: Teki'] = set_combine(sets.precast.WS, {})
	
	-- Ice/Wind, STR 40% INT 40%
	sets.precast.WS['Blade: To'] = set_combine(sets.precast.WS, {})
	
	-- Light/Thunder, STR 30% INT 30%
	sets.precast.WS['Blade: Chi'] = set_combine(sets.precast.WS, {neck="Light Gorget",waist="Light Belt"})

 	-- Darkness, STR 40% INT 40%
	sets.precast.WS['Blade: Ei'] = set_combine(sets.precast.WS, {})
	
	-- Wind/Thunder, STR 30% DEX 30%
	sets.precast.WS['Blade: Jin'] = set_combine(sets.precast.WS, sets.Mode.Crit, {})
	
	-- Earth/Darkness, STR 30% INT 30%
	sets.precast.WS['Blade: Ten'] = set_combine(sets.precast.WS, {neck="Soil Gorget",waist="Soil Belt"})

	-- Earth/Darkness/Light, STR 30% INT 30%
	sets.precast.WS['Blade: Ku'] = set_combine(sets.precast.WS, {neck="Light Gorget",waist="Light Belt"})
	
	-- Earth/Water, DEX 40% INT 40%
	sets.precast.WS['Blade: Yu'] = set_combine(sets.precast.WS, {neck="Soil Gorget",waist="Soil Belt"})

	-- Fire/Light/Thunder, DEX 73%
    sets.precast.WS['Blade: Shun'] = set_combine(sets.precast.WS, {neck="Light Gorget",waist="Light Belt"})

	-- Water/Earth/Ice/Dark, AGI 80%
	sets.precast.WS['Blade: Hi'] = set_combine(sets.precast.WS, sets.Mode.Crit, 
        {hands="Hachiya Tekko",legs="Nahtirah Trousers"})

 	-- Wind/Thunder/Dark, STR 60% INT 60%
	sets.precast.WS['Blade: Kamu'] = set_combine(sets.precast.WS, {})

	-- Wind/Thunder/Earth, DEX 40% INT 40%
    sets.precast.WS['Aeolian Edge'] = {
        ear1="Friomisi Earring",ear2="Moonshade Earring",
        back="Toro Cape",waist="Thunder Belt"}

	-- Dark/Water, STR 40% MND 40% 
	sets.precast.WS['Sunburst'] = set_combine(sets.precast.WS, {})
		
	-- Midcast sets
    sets.midcast.FastRecast = {
        body="Hachi. Chainmail",hands="Mochizuki Tekko",
        legs="Hachiya Hakama"}
        
	-- skill > acc > INT 
    sets.midcast.NinjutsuDebuff = {ranged=gear.NinRanged,ammo=gear.NinAmmo,
        head="Hachiya Hatsuburi",neck="Sanctity Necklace",ear1="Lifestorm Earring",ear2="Psystorm Earring",
        hands="Mochizuki Tekko",ring1="Diamond Ring",
        back="Yokaze Mantle",waist="Koga Sarashi",legs="Denali Kecks",feet="Hachiya Kyahan"}

	-- special > skill > mab > INT > acc
    sets.midcast.ElementalNinjutsu = set_combine(sets.midcast.NinjutsuDebuff, {
        head="Koga Hatsuburi",neck="Sanctity Necklace",ear1="Friomisi Earring",ear2="Crematio Earring",
        body="Otronif Harness",hands="Iga Tekko +2",ring1="Diamond Ring",
        back="Toro Cape",waist=gear.ElementalObi,legs="Nahtirah Trousers",feet="Nin. Kyahan +1"})

	-- acc 
    sets.midcast.ElementalNinjutsu.Resistant = set_combine(sets.midcast.NinjutsuDebuff, {ear1="Lifestorm Earring",ear2="Psystorm Earring",
        back="Yokaze Mantle"})

    sets.midcast.NinjutsuBuff = {head="Hachiya Hatsuburi",ear2="Liminus Earring",back="Yokaze Mantle"}
    sets.midcast.Utsusemi = set_combine(sets.midcast.NinjutsuBuff, {feet="Iga Kyahan +2"})

	-- Racc, Ratt, AGI
    sets.midcast.RA = {
        head="Optical Hat",neck="Iqabi Necklace",ear1="Terminus Earring",
        -- body="Koga Chainmail",hands="Nin. Tekko +1",ring1="Behemoth Ring",ring2="Scorpion Ring +1",
        body="Koga Chainmail",hands="Nin. Tekko +1",ring1="Behemoth Ring",ring2="Prouesse Ring",
        back="Yokaze Mantle",waist="Flax Sash",legs="Feast Hose",feet="Otronif Boots"}
    -- Hachiya Hakama/Thurandaut Tights +1

    -- Defense sets
    sets.defense.Evasion = {
        head="Gavialis Helm",neck="Iga Erimaki",ear1="Ethereal Earring",ear2="Assuage Earring",
        body="Otronif Harness",hands="Otronif Gloves +1",ring1="Vengeful Ring",ring2="Alert Ring",
        back="Yokaze Mantle",legs="Nahtirah Trousers",feet="Otronif Boots"}

    sets.defense.PDT = { 
        neck="Twilight Torque",
        body="Otronif Harness",hands="Otronif Gloves +1",ring1="Patricius Ring",
        legs="Nahtirah Trousers",feet="Otronif Boots"}

    sets.defense.MDT = { 
        head="Whirlpool Mask",neck="Twilight Torque",
        body="Otronif Harness",hands="Otronif Gloves +1",ring1="Vengeful Ring",
        waist="Flax Sash",legs="Nahtirah Trousers",feet="Otronif Boots"}

    sets.Kiting = {feet=gear.MovementFeet}

    --------------------------------------
    -- Custom buff sets
    --------------------------------------

    sets.buff.Migawari = {body="Iga Ningi +2"}
    sets.buff.Doom = {} -- "Saida Ring"
    sets.buff.Yonin = {legs="Iga Hakama +2"}
    sets.buff.Innin = {head="Iga Zukin +2"}
	
	-- Melee sets for in Adoulin, which has an extra 2% Haste from Ionis.
	sets.engaged.Adoulin = set_combine(sets.engaged, {})
	sets.engaged.Assault = set_combine(sets.engaged, {ring2="Ulthalam's Ring"}) 
end

-------------------------------------------------------------------------------------------------------------------
-- Job-specific hooks for standard casting events.
-------------------------------------------------------------------------------------------------------------------
-- Run after the default precast() is done.
-- eventArgs is the same one used in job_precast, in case information needs to be persisted.
function job_post_precast(spell, action, spellMap, eventArgs)
	if spell.type == 'WeaponSkill' then
        if is_sc_element_today(spell) then
			-- add_to_chat(122,' WS Day ')
            equip(sets.WSDayBonus)
        end
	end 
end

-- Run after the general midcast() is done.
-- eventArgs is the same one used in job_midcast, in case information needs to be persisted.
function job_post_midcast(spell, action, spellMap, eventArgs)
    if state.Buff.Doom then
        equip(sets.buff.Doom)
    end
end


-- Set eventArgs.handled to true if we don't want any automatic gear equipping to be done.
function job_aftercast(spell, action, spellMap, eventArgs)
    if not spell.interrupted and spell.english == "Migawari: Ichi" then
        state.Buff.Migawari = true
    end
end

-------------------------------------------------------------------------------------------------------------------
-- Job-specific hooks for non-casting events.
-------------------------------------------------------------------------------------------------------------------

-- Called when a player gains or loses a buff.
-- buff == buff gained or lost
-- gain == true if the buff was gained, false if it was lost.
function job_buff_change(buff, gain)
    -- If we gain or lose any haste buffs, adjust which gear set we target.
    if S{'haste','march','embrava','haste samba'}:contains(buff:lower()) then
        -- determine_haste_group()
        handle_equipping_gear(player.status)
    elseif state.Buff[buff] ~= nil then
        handle_equipping_gear(player.status)
    end
end

function job_status_change(new_status, old_status)
    if new_status == 'Idle' then
        select_movement_feet()
    end
end

-- Handle notifications of user state values being changed.
function job_state_change(stateField, newValue, oldValue)
	-- add_to_chat(121,' job state change ')
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
end

-------------------------------------------------------------------------------------------------------------------
-- User code that supplements standard library decisions.
-------------------------------------------------------------------------------------------------------------------

-- Get custom spell maps
function job_get_spell_map(spell, default_spell_map)
    if spell.skill == "Ninjutsu" then
        if not default_spell_map then
            if spell.target.type == 'SELF' then
                return 'NinjutsuBuff'
            else
				select_ammo_type('macc')
                return 'NinjutsuDebuff'
            end
        end
    end
end

-- Modify the default idle set after it was constructed.
function customize_idle_set(idleSet)
    if state.Buff.Migawari then
        idleSet = set_combine(idleSet, sets.buff.Migawari)
    end
    if state.Buff.Doom then
        idleSet = set_combine(idleSet, sets.buff.Doom)
    end
    return idleSet
end


-- Modify the default melee set after it was constructed.
function customize_melee_set(meleeSet)
    if state.Buff.Migawari then
        meleeSet = set_combine(meleeSet, sets.buff.Migawari)
    end
    if state.Buff.Doom then
        meleeSet = set_combine(meleeSet, sets.buff.Doom)
    end
    return meleeSet
end

-- Called by the default 'update' self-command.
function job_update(cmdParams, eventArgs)
	classes.CustomMeleeGroups:clear()
	if areas.Adoulin:contains(world.area) and buffactive.ionis then
			classes.CustomMeleeGroups:append('Adoulin')
	end
	if areas.Assault:contains(world.area) then
			classes.CustomMeleeGroups:append('Assault')
	end
	pick_tp_weapon()
    select_movement_feet()
	select_ammo_type('melee')
end

-------------------------------------------------------------------------------------------------------------------
-- Utility functions specific to this job.
-------------------------------------------------------------------------------------------------------------------

function job_handle_equipping_gear(status, eventArgs)
	-- add_to_chat(122,'handle equiping gear')
	check_tp_lock()
	set_combat_form()
	pick_tp_weapon()
	select_ammo_type('melee')
end

function select_movement_feet()
    if world.time >= 17*60 or world.time < 7*60 then
        gear.MovementFeet.name = gear.NightFeet
    else
        gear.MovementFeet.name = gear.DayFeet
    end
end

function select_ammo_type(t)
	-- add_to_chat(121,' select ammo type '..state.RWeaponMode.value)
	-- add_to_chat(121,' ammo name '..gear.NinAmmo.name)
	-- add_to_chat(121,' ranged name '..gear.NinRanged.name)
	if state.RWeaponMode.value == "Stats" then
		if t == 'macc' then
			-- add_to_chat(121,' select ammo type '..t)
			gear.NinAmmo.name = gear.MaccAmmo
		else 
			-- add_to_chat(121,' select ammo type '..t)
			gear.NinAmmo.name = gear.StatsAmmo
		end
		gear.NinRanged.name = gear.empty
	elseif state.RWeaponMode.value == "Bow" then
		gear.NinAmmo.name = gear.BowAmmo
		gear.NinRanged.name = gear.BowRanged
	elseif state.RWeaponMode.value == "Gun" then
		gear.NinAmmo.name = gear.GunAmmo
		gear.NinRanged.name = gear.GunRanged
	elseif state.RWeaponMode.value == "Boomerrang" then
		gear.NinAmmo.name = gear.empty
		gear.NinRanged.name = gear.BoomerrangRanged
	elseif state.RWeaponMode.value == "Shuriken" then
		gear.NinAmmo.name = gear.Shuriken
		gear.NinRanged.name = gear.empty
	else
		gear.NinAmmo.name = gear.StatsAmmo
		gear.NinRanged.name = gear.empty
	end
end


-- Select default macro book on initial load or subjob change.
function select_default_macro_book()
	-- Default macro set/book
	if player.sub_job == 'DNC' then
		set_macro_page(3, 2)
	elseif player.sub_job == 'THF' then
		set_macro_page(5, 2)
	else
		set_macro_page(1, 2)
	end
	send_command('exec nin.txt')
end

