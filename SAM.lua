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
    state.Buff.Sengikori = buffactive.Sengikori or false
    state.Buff['Meikyo Shisui'] = buffactive['Meikyo Shisui'] or false
	state.WeaponMode = M{['description']='Weapon Mode', 'GreatKatana', 'Polearm', 'Sword'}
	state.RWeaponMode = M{['description']='RWeapon Mode', 'Stats', 'Bow'}
	state.Stance = M{['description']='Stance', 'Off', 'None', 'Offensive', 'Defensive'}
	state.holdtp = M{['description']='holdtp', 'false', 'true'}
	
	set_combat_form()
	pick_tp_weapon()
end

-------------------------------------------------------------------------------------------------------------------
-- User setup functions for this job.  Recommend that these be overridden in a sidecar file.
-------------------------------------------------------------------------------------------------------------------

-- Setup vars that are user-dependent.
function user_setup()
	state.OffenseMode:options('Normal', 'Acc', 'Att', 'Crit', 'DA', 'Haste', 'Skill', 'sTP', 'STR')
	state.WeaponskillMode:options('Normal', 'Acc', 'Mod')
	state.DefenseMode:options('None', 'Physical', 'Magical')
	state.PhysicalDefenseMode:options('PDT', 'Evasion')
	state.MagicalDefenseMode:options('MDT')
	state.WeaponMode:set('GreatKatana')
	state.Stance:set('Offensive')
	state.RWeaponMode:set('Stats') 
	state.holdtp:set('false')
	
	pick_tp_weapon()

    -- Additional local binds
    send_command('bind ^` input /ja "Hasso" <me>')
    send_command('bind !` input /ja "Seigan" <me>')

    select_default_macro_book()
end


-- Called when this job file is unloaded (eg: job change)
function user_unload()
    send_command('unbind ^`')
    send_command('unbind !-')
end


-- Define sets and vars used by this job file.
function init_gear_sets()
    --------------------------------------
    -- Start defining the sets
    --------------------------------------
	organizer_items = {
		new1="Sailfi Belt +1",
		new2="Cacoethic Ring +1",
		new3="",
		new4="",
		new5="",
		new6="Smertrios's Mantle",
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
		new31="",
		new32="",
		new33="",
		new34="",
		new35="",
		echos="Echo Drops",
		shihei="Shihei",
		orb="Macrocosmic Orb"
	}
    -- Sets to return to when not performing an action.
	-- Idle sets
	sets.idle = {head="Twilight Helm",neck="Twilight Torque",ear1="Etiolation Earring",ear2="Infused Earring",
			body="Twilight Mail",hands="Umuthi Gloves",ring1="Defending Ring",ring2="Vengeful Ring",
			back="Solemnity Cape",waist="Flax Sash",legs="Hiza. Hizayoroi +1",feet="Danzo Sune-Ate"}

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
    -- Delay 450 GK, 25 Save TP => 65 Store TP for a 5-hit (25 Store TP in gear)
    sets.engaged = {
        head="Valorous Mask",neck="Ganesha's Mala",ear1="Bladeborn Earring",ear2="Steelflash Earring",
        body="Valorous Mail",hands="Valorous Mitts",ring1="Patricius Ring",ring2="Hetairoi Ring",
        back="Takaha Mantle",waist="Sarissapho. Belt",legs="Hiza. Hizayoroi +1",feet="Valorous Greaves"}
   
	sets.engaged.Polearm = {}
	sets.engaged.GreatKatana = {}
			
	-- Basic Mode definitions
	sets.Mode = {}
	sets.Mode.Acc = set_combine(sets.engaged, {
			head="Hizamaru Somen +1",neck="Iqabi Necklace",ear1="Zennaroi Earring",ear2="Digni. Earring",
			body="Valorous Mail",hands="Flam. Manopolas +1",ring1="Patricius Ring",ring2="Ulthalam's Ring",
			back="Ground. Mantle +1",waist="Olseni Belt",legs="Hiza. Hizayoroi +1",feet="Valorous Greaves"})
	sets.Mode.Att = set_combine(sets.engaged, {
			head="Hizamaru Somen +1",neck="Sanctity Necklace",ear1="Bladeborn Earring",ear2="Dudgeon Earring",
			body="Phorcys Korazin",hands="Valorous Mitts",ring1="Overbearing Ring",ring2="Cho'j Band",
			back="Phalangite Mantle",waist="Eschan Stone",legs="Miki. Cuisses",feet="Valorous Greaves"})
	sets.Mode.Crit = set_combine(sets.engaged, {head="Valorous Mask",hands="Flam. Manopolas +1",ring2="Hetairoi Ring",
			legs="Jokushu Haidate",feet="Thereoid Greaves"})
	sets.Mode.DA = set_combine(sets.engaged, {
			head="Flam. Zucchetto +1",neck="Ganesha's Mala",ear1="Bladeborn Earring",ear2="Steelflash Earring",
			body="Valorous Mail",hands="Phorcys Mitts",ring2="Hetairoi Ring",
			back="Atheling Mantle",waist="Sarissapho. Belt",legs="Valor. Hose",feet="Flam. Gambieras +1"})
	sets.Mode.Haste = set_combine(sets.engaged, {
			head="Gavialis Helm",
			body="Porthos Byrnie",hands="Umuthi Gloves",
			back="Ground. Mantle +1",legs="Jokushu Haidate",feet="Loyalist Sabatons"})
	sets.Mode.Skill = set_combine(sets.engaged, {ear1="Terminus Earring",ear2="Liminus Earring",ring2="Prouesse Ring"})
	sets.Mode.sTP = set_combine(sets.engaged, {
			head="Valorous Mask",neck="Asperity Necklace",ear1="Tripudio Earring",ear2="Digni. Earring",
			body="Unkai Domaru +2",hands="Otronif Gloves +1",ring1="Rajas Ring",ring2="K'ayres Ring",
			back="Takaha Mantle",waist="Yemaya Belt",legs="Unkai Haidate +2",feet="Valorous Greaves"})
	sets.Mode.STR = set_combine(sets.engaged, {
			head="Flam. Zucchetto +1",neck="Lacono Neck. +1",
			body="Flamma Korazin +1",hands="Flam. Manopolas +1",ring1="Rajas Ring",ring2="Apate Ring",
			back="Buquwik Cape",waist="Wanion Belt",legs="Valor. Hose",feet="Flam. Gambieras +1"})
			
	--Initialize Main Weapons
	-- sets.engaged.GreatKatana = set_combine(sets.engaged, {main="Umaru",sub="Bloodrain Strap"})
	sets.engaged.GreatKatana = set_combine(sets.engaged, {main="Ichigohitofuri",sub="Bloodrain Strap"})
	sets.engaged.Polearm = set_combine(sets.engaged, {main="Pitchfork", sub="Bloodrain Strap"})
	sets.engaged.Sword = set_combine(sets.engaged, {main="Tanmogayi +1", sub="Deliverance"})
	--Add in appropriate Ranged weapons
	sets.ranged = {}
	sets.ranged.Stats = {range="",ammo="Ginsen"}
	sets.ranged.Bow = {range="Killer Shortbow",ammo="Horn Arrow"}
	
	sets.engaged.GreatKatana.Stats = set_combine(sets.engaged.GreatKatana, sets.ranged.Stats)
	sets.engaged.GreatKatana.Bow = set_combine(sets.engaged.GreatKatana, sets.ranged.Bow)

	sets.engaged.GreatKatana.Acc = set_combine(sets.engaged.GreatKatana, sets.Mode.Acc)
	sets.engaged.GreatKatana.Att = set_combine(sets.engaged.GreatKatana, sets.Mode.Att)
	sets.engaged.GreatKatana.Crit = set_combine(sets.engaged.GreatKatana, sets.Mode.Crit)
	sets.engaged.GreatKatana.DA = set_combine(sets.engaged.GreatKatana, sets.Mode.DA)
	sets.engaged.GreatKatana.Haste = set_combine(sets.engaged.GreatKatana, sets.Mode.Haste)
	sets.engaged.GreatKatana.Skill = set_combine(sets.engaged.GreatKatana, sets.Mode.Skill, {})
	sets.engaged.GreatKatana.sTP = set_combine(sets.engaged.GreatKatana, sets.Mode.sTP)
	sets.engaged.GreatKatana.STR = set_combine(sets.engaged.GreatKatana, sets.Mode.STR)

	sets.engaged.Polearm.Stats = set_combine(sets.engaged.Polearm, sets.ranged.Stats)
	sets.engaged.Polearm.Bow = set_combine(sets.engaged.Polearm, sets.ranged.Bow)

	sets.engaged.Polearm.Acc = set_combine(sets.engaged.Polearm, sets.Mode.Acc)
	sets.engaged.Polearm.Att = set_combine(sets.engaged.Polearm, sets.Mode.Att)
	sets.engaged.Polearm.Crit = set_combine(sets.engaged.Polearm, sets.Mode.Crit)
	sets.engaged.Polearm.DA = set_combine(sets.engaged.Polearm, sets.Mode.DA)
	sets.engaged.Polearm.Haste = set_combine(sets.engaged.Polearm, sets.Mode.Haste)
	sets.engaged.Polearm.Skill = set_combine(sets.engaged.Polearm, {
			neck="Maskirova Torque",ear1="Tripudio Earring",
			ring2="Portus Ring"})
	sets.engaged.Polearm.sTP = set_combine(sets.engaged.Polearm, sets.Mode.sTP)
	sets.engaged.Polearm.STR = set_combine(sets.engaged.Polearm, sets.Mode.STR)
	
	sets.engaged.Sword.Stats = set_combine(sets.engaged.Sword, sets.ranged.Stats)
	sets.engaged.Sword.Bow = set_combine(sets.engaged.Sword, sets.ranged.Bow)

	sets.engaged.Sword.Acc = set_combine(sets.engaged.Sword, sets.Mode.Acc)
	sets.engaged.Sword.Att = set_combine(sets.engaged.Sword, sets.Mode.Att)
	sets.engaged.Sword.Crit = set_combine(sets.engaged.Sword, sets.Mode.Crit)
	sets.engaged.Sword.DA = set_combine(sets.engaged.Sword, sets.Mode.DA)
	sets.engaged.Sword.Haste = set_combine(sets.engaged.Sword, sets.Mode.Haste)
	sets.engaged.Sword.Skill = set_combine(sets.engaged.Sword, {})
	sets.engaged.Sword.sTP = set_combine(sets.engaged.Sword, sets.Mode.sTP)
	sets.engaged.Sword.STR = set_combine(sets.engaged.Sword, sets.Mode.STR)

 	-- Default set for any weaponskill that isn't any more specifically defined
	sets.WSDayBonus = {head="Gavialis Helm"} 

	-- Specific weaponskill sets.  Uses the base set if an appropriate WSMod version isn't found.
	sets.precast.WS = set_combine(sets.Mode.STR, {neck="Fotia Gorget",ear2="Ishvara Earring",body="Phorcys Korazin",back="Smertrios's Mantle",waist="Fotia Belt",legs="Hiza. Hizayoroi +1"})
    sets.precast.WS.Acc = set_combine(sets.precast.WS, {back="Letalis Mantle"})

    -- Specific weaponskill sets.  Uses the base set if an appropriate WSMod version isn't found.
 	-- Light/Earth, STR 60%
	sets.precast.WS['Tachi: Enpi'] = set_combine(sets.precast.WS, {neck="Light Gorget",body="Phorcys Korazin",waist="Light Belt"})
 	
	-- Ice, STR 60%
	sets.precast.WS['Tachi: Hobaku'] = set_combine(sets.precast.WS, {neck="Snow Gorget",body="Phorcys Korazin",waist="Snow Belt"})
 
  	-- Light/Thunder, STR 60%
	sets.precast.WS['Tachi: Goten'] = set_combine(sets.precast.WS, {neck="Light Gorget",body="Phorcys Korazin",waist="Light Belt"})
  	
	-- Fire, STR 75%
	sets.precast.WS['Tachi: Kagero'] = set_combine(sets.precast.WS, {})
	
	-- Earth/Wind, STR 30%
	sets.precast.WS['Tachi: Jinpu'] = set_combine(sets.precast.WS, {})
 
   	-- Water/Thunder, STR 50% MND 30%
	sets.precast.WS['Tachi: Koki'] = set_combine(sets.precast.WS, {neck="Thunder Gorget",body="Phorcys Korazin",waist="Thunder Belt"})
 
	-- Ice/Wind,, STR 75%
    sets.precast.WS['Tachi: Yukikaze'] = set_combine(sets.precast.WS, {})

	-- Water/Ice, STR 75%
    sets.precast.WS['Tachi: Gekko'] = set_combine(sets.precast.WS, {neck="Snow Gorget",body="Phorcys Korazin",waist="Snow Belt"})

	-- Fire/Light/Dark, STR 75%
    sets.precast.WS['Tachi: Kasha'] = set_combine(sets.precast.WS, {neck="Light Gorget",body="Phorcys Korazin",waist="Light Belt"})

	-- Dark/Earth, STR 40% CHR 60%
    sets.precast.WS['Tachi: Ageha'] = set_combine(sets.precast.WS, {neck="Soil Gorget",waist="Soil Belt"})
    
	-- Wind/Thunder/Dark, STR 73%
    sets.precast.WS['Tachi: Shoha'] = set_combine(sets.precast.WS, {})
    sets.precast.WS['Tachi: Shoha'].Acc = set_combine(sets.precast.WS.Acc, {neck="Thunder Gorget"})
    sets.precast.WS['Tachi: Shoha'].Mod = set_combine(sets.precast.WS['Tachi: Shoha'], {waist="Thunder Belt"})

	-- Light/Water/Ice, STR 80%
	sets.precast.WS['Tachi: Fudo'] = set_combine(sets.precast.WS, {neck="Light Gorget",body="Phorcys Korazin",waist="Light Belt"})
    sets.precast.WS['Tachi: Fudo'].Acc = set_combine(sets.precast.WS.Acc, {neck="Snow Gorget"})
    sets.precast.WS['Tachi: Fudo'].Mod = set_combine(sets.precast.WS['Tachi: Fudo'], {waist="Snow Belt"})

	-- Ice/Earth/Dark, STR 50%
    sets.precast.WS['Tachi: Rana'] = set_combine(sets.precast.WS, {neck="Snow Gorget",ear1="Bladeborn Earring",ear2="Steelflash Earring",})
    sets.precast.WS['Tachi: Rana'].Acc = set_combine(sets.precast.WS.Acc, {neck="Snow Gorget",ear1="Bladeborn Earring",ear2="Steelflash Earring",})
    sets.precast.WS['Tachi: Rana'].Mod = set_combine(sets.precast.WS['Tachi: Rana'], {waist="Snow Belt"})

 	-- Light, STR 30% DEX 30%
	sets.precast.WS['Double Thrust'] = set_combine(sets.precast.WS, {neck="Light Gorget",body="Phorcys Korazin",waist="Light Belt"})
		
	-- Light/Thunder, STR 40% INT 40%
	sets.precast.WS['Thunder Thrust'] = set_combine(sets.precast.WS, {neck="Light Gorget",body="Phorcys Korazin",waist="Light Belt"})

	-- Light/Thunder, STR 40% INT 40% 
	sets.precast.WS['Raiden Thrust'] = set_combine(sets.precast.WS, {neck="Light Gorget",body="Phorcys Korazin",waist="Light Belt"})

	-- Thunder, STR 100%
	sets.precast.WS['Leg Sweep'] = set_combine(sets.precast.WS, {body="Phorcys Korazin"})

	-- Darkness, STR 20% DEX 20% 
	sets.precast.WS['Penta Thrust'] = set_combine(sets.precast.WS, {neck="Shadow Gorget",body="Phorcys Korazin",waist="Shadow Belt"})

	-- Light/Water, STR 50% AGI 50% 
	sets.precast.WS['Vorpal Thrust'] = set_combine(sets.precast.WS, {neck="Light Gorget",body="Phorcys Korazin",waist="Light Belt"})

	-- Dark/Earth/Ice, STR 100% -->
	sets.precast.WS['Impulse Drive'] = set_combine(sets.precast.WS, {body="Phorcys Korazin"})

	-- Light/Earth, STR 40% DEX 40%-->
	sets.precast.WS['Sonic Thrust'] = set_combine(sets.precast.WS, {neck="Light Gorget",body="Phorcys Korazin",waist="Light Belt"})

	-- Dark/Earth/Light, STR 85% -->
	sets.precast.WS['Stardiver'] = set_combine(sets.precast.WS, {neck="Light Gorget",body="Phorcys Korazin",back="Atheling Mantle",waist="Light Belt"})


    -- Precast Sets
    -- Precast sets to enhance JAs
    sets.precast.JA.Meditate = {head="Myochin Kabuto",hands="Sakonji Kote",back="Takaha Mantle"}
    sets.precast.JA['Warding Circle'] = {head="Myochin Kabuto"}
    sets.precast.JA['Blade Bash'] = {hands="Sakonji Kote"}

    -- Waltz set (chr and vit)
    sets.precast.Waltz = {
        head="Hizamaru Somen +1",
        body="Hiza. Haramaki +1",hands="Buremte Gloves",ring1="Spiral Ring",
        back="Iximulew Cape",legs="Hiza. Hizayoroi +1",feet="Hiza. Sune-Ate +1"}
        
    -- Don't need any special gear for Healing Waltz.
    sets.precast.Waltz['Healing Waltz'] = {}

	-- Fast cast sets for spells
	sets.precast.FC = {neck="Baetyl Pendant",ear1="Etiolation Earring",hands="Leyline Gloves",legs="Limbo Trousers"}

    -- Snapshot for ranged
    sets.precast.RA = {waist="Yemaya Belt"}

    -- Midcast Sets
    -- sets.midcast.FastRecast = {}

	-- Racc, Ratt, AGI
    sets.midcast.RA = {
        neck="Iqabi Necklace",ear1="Terminus Earring",ear2="Infused Earring",
        -- ring1="Behemoth Ring",ring2="Scorpion Ring +1",
        ring1="Behemoth Ring",ring2="Prouesse Ring",
        waist="Eschan Stone"}
     
    -- Defense sets
    sets.defense.Evasion = {
        head="Hizamaru Somen +1",neck="Twilight Torque",ear1="Infused Earring",ear2="Assuage Earring",
        body="Hiza. Haramaki +1",hands="Hizamaru Kote +1",ring2="Paguroidea Ring",
        back="Shadow Mantle",waist="Flume Belt",legs="Hiza. Hizayoroi +1",feet="Hiza. Sune-Ate +1"}

	sets.defense.PDT = {
        head="Valorous Mask",neck="Twilight Torque",ear1="Bladeborn Earring",ear2="Steelflash Earring",
        body="Valorous Mail",hands="Otronif Gloves +1",ring1="Defending Ring",ring2="Patricius Ring",
        back="Solemnity Cape",waist="Flume Belt",legs="Valor. Hose",feet="Amm Greaves"}

    sets.defense.MDT = {
        head="Valorous Mask",neck="Twilight Torque",ear1="Etiolation Earring",
        body="Savas Jawshan",hands="Otronif Gloves +1",ring1="Defending Ring",ring2="Vengeful Ring",
        back="Solemnity Cape",waist="Flume Belt",legs="Valor. Hose",feet="Amm Greaves"}

	sets.debuffed = set_combine(sets.defense.Evasion,sets.defense.PDT,sets.defense.MDT)
	
    sets.Kiting = {feet="Danzo Sune-ate"}

    sets.defense.Reraise = {head="Twilight Helm",body="Twilight Mail"}

	sets.buff.Hasso = {legs="Unkai Haidate +2"}
	sets.buff.Seigan = {legs="Unkai Kabuto +2"}
    sets.buff.Sekkanoki = {hands="Unkai Kote +2"}
    sets.buff.Sengikori = {feet="Unkai Sune-ate +2"}
    sets.buff['Meikyo Shisui'] = {feet="Sakonji Sune-ate"}
	sets.Assault = {ring2="Ulthalam's Ring"}
end


-------------------------------------------------------------------------------------------------------------------
-- Job-specific hooks for standard casting events.
-------------------------------------------------------------------------------------------------------------------

-- Set eventArgs.handled to true if we don't want any automatic target handling to be done.
function job_pretarget(spell, action, spellMap, eventArgs)
    if spell.type == 'WeaponSkill' then
        -- Change any GK weaponskills to polearm weaponskill if we're using a polearm.
        if player.equipment.main=='Quint Spear' or player.equipment.main=='Quint Spear' then
            if spell.english:startswith("Tachi:") then
                send_command('@input /ws "Penta Thrust" '..spell.target.raw)
                eventArgs.cancel = true
            end
        end
    end
end

-- Run after the default precast() is done.
-- eventArgs is the same one used in job_precast, in case information needs to be persisted.
function job_post_precast(spell, action, spellMap, eventArgs)
    if spell.type:lower() == 'weaponskill' then
        if state.Buff.Sengikori then
            equip(sets.buff.Sengikori)
        end
        if state.Buff['Meikyo Shisui'] then
            equip(sets.buff['Meikyo Shisui'])
        end
    end
	if spell.type == 'WeaponSkill' then
        if is_sc_element_today(spell) then
			-- add_to_chat(122,' WS Day ')
            equip(sets.WSDayBonus)
        end
	end 
end


-- Run after the default midcast() is done.
-- eventArgs is the same one used in job_midcast, in case information needs to be persisted.
function job_post_midcast(spell, action, spellMap, eventArgs)
    -- Effectively lock these items in place.
    if state.HybridMode.value == 'Reraise' or
        (state.DefenseMode.value == 'Physical' and state.PhysicalDefenseMode.value == 'Reraise') then
        equip(sets.defense.Reraise)
    end
end


function job_buff_change(buff, gain)
	handle_debuffs()
	handle_sam_ja()
	if player.sub_job == 'WAR' then
		handle_war_ja()
	end
end
-------------------------------------------------------------------------------------------------------------------
-- User code that supplements standard library decisions.
-------------------------------------------------------------------------------------------------------------------

-- Called by the 'update' self-command, for common needs.
-- Set eventArgs.handled to true if we don't want automatic equipping of gear.
function job_update(cmdParams, eventArgs)
	classes.CustomMeleeGroups:clear()
	if areas.Adoulin:contains(world.area) and buffactive.ionis then
		classes.CustomMeleeGroups:append('Adoulin')
	end
	pick_tp_weapon()
end

-- Modify the default melee set after it was constructed.
function customize_melee_set(meleeSet)
	if areas.Assault:contains(world.area) then
		meleeSet = set_combine(meleeSet, sets.Assault)
	end

    return meleeSet
end

-- Modify the default idle set after it was constructed.
function customize_idle_set(idleSet)
	-- add_to_chat(122,'customize idle set')
    if not buffactive["Reraise"] then
		idleSet = set_combine(idleSet, sets.defense.Reraise)
	end
    return idleSet
end

-- Set eventArgs.handled to true if we don't want the automatic display to be run.
function display_current_job_state(eventArgs)

end

function job_handle_equipping_gear(status, eventArgs)
	-- add_to_chat(122,'handle equiping gear')
	check_tp_lock()
	set_combat_form()
	pick_tp_weapon()
	handle_twilight()
end

-------------------------------------------------------------------------------------------------------------------
-- Utility functions specific to this job.
-------------------------------------------------------------------------------------------------------------------

-- Select default macro book on initial load or subjob change.
function select_default_macro_book()
	-- Default macro set/book
	if player.sub_job == 'WAR' then
		set_macro_page(1, 9)
	elseif player.sub_job == 'DNC' then
		set_macro_page(2, 9)
	elseif player.sub_job == 'THF' then
		set_macro_page(3, 9)
	elseif player.sub_job == 'NIN' then
		set_macro_page(4, 9)
	else
		set_macro_page(1, 9)
	end
	send_command('exec sam.txt')
end

function job_self_command(cmdParams, eventArgs)

end
