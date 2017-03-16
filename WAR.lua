include('organizer-lib.lua')
-------------------------------------------------------------------------------------------------------------------
-- Initialization function that defines sets and variables to be used.
-------------------------------------------------------------------------------------------------------------------
 
-- IMPORTANT: Make sure to also get the Mote-Include.lua file (and its supplementary files) to go with this.
 
-- Initialization function for this job file.
function get_sets()
    mote_include_version = 2
     
    -- Load and initialize the include file.
    include('Mote-Include.lua')
end
 
-- Setup vars that are user-independent.
function job_setup()
	state.WeaponMode = M{['description']='Weapon Mode', 'GreatAxe', 'Axe', 'GreatSword', 'Scythe', 'Sword', 'Staff', 'Polearm', 'Club', 'Dagger', 'H2H', 'Katana', 'GreatKatana'}
	state.SubMode = M{['description']='Sub Mode', 'DW', 'Shield', 'Grip'}
	state.RWeaponMode = M{['description']='RWeapon Mode', 'Stats', 'Bow', 'Xbow', 'Boomerrang'}
	state.Stance = M{['description']='Stance', 'Off', 'None', 'Offensive', 'Defensive'}
 
	set_combat_form()
	pick_tp_weapon()
end
 
-- Setup vars that are user-dependent.  Can override this function in a sidecar file.
function user_setup()
	-- add_to_chat(122,'user setup')
	-- Options: Override default values
	state.OffenseMode:options('Normal', 'Acc', 'Att', 'Crit', 'DA', 'Haste', 'Skill', 'sTP', 'STR')
	state.WeaponskillMode:options('Normal', 'Acc', 'Mod')
	state.DefenseMode:options('None', 'Physical', 'Magical')
	state.PhysicalDefenseMode:options('PDT', 'Evasion', 'Reraise')
	state.MagicalDefenseMode:options('MDT', 'Reraise')
	state.WeaponMode:set('GreatAxe')
	state.Stance:set('Offensive')
	state.SubMode:set('Grip')
	state.RWeaponMode:set('Stats') 

	pick_tp_weapon()
	select_default_macro_book()
end
 
-- Called when this job file is unloaded (eg: job change)
function file_unload()
    if binds_on_unload then
        binds_on_unload()
    end
 
    send_command('unbind ^`')
    send_command('unbind !-')
end
 
 
-- Define sets and vars used by this job file.
function init_gear_sets()
	-- add_to_chat(122,'init gear sets')
	--------------------------------------
	-- Start defining the sets
	--------------------------------------
	-- Sets to return to when not performing an action.
    organizer_items = {
		new1="",
		new2="",
		new3="",
		new4="",
		new5="",
		new6="",
		new7="Cichol's Mantle",
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
		new36="",
		new37="",
		new38="",
		new39="",
		new40="",
		new41="",
		new42="",
		new43="",
		new44="",
		new45="",
		new46="",
		new47="",
		new48="",
		new49="",
		new50="",
		new51="",
		echos="Echo Drops",
		shihei="Shihei",
		orb="Macrocosmic Orb"
	}

	-- Idle sets
	sets.idle = {head="Twilight Helm",neck="Twilight Torque",ear1="Etiolation Earring",ear2="Infused Earring",
			body="Twilight Mail",hands="Sulev. Gauntlets +1",ring1="Defending Ring",ring2="Patricius Ring",
			back="Solemnity Cape",waist="Flax Sash",legs="Sulevi. Cuisses +1",feet="Sulev. Leggings +1"}

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
			head="Valorous Mask",neck="Asperity Necklace",ear1="Bladeborn Earring",ear2="Steelflash Earring",
			body="Valorous Mail",hands="Emicho Gauntlets",ring1="Patricius Ring",ring2="Hetairoi Ring",
			back="Mauler's Mantle",waist="Sarissapho. Belt",legs="Sulevi. Cuisses +1",feet="Flam. Gambieras +1"}
	sets.engaged.GreatAxe = {}
	sets.engaged.Axe = {}
	sets.engaged.GreatSword = {}
	sets.engaged.Scythe = {}
	sets.engaged.Sword = {}
	sets.engaged.Staff = {}
	sets.engaged.Polearm = {}
	sets.engaged.Club = {}
	sets.engaged.Dagger = {}
	sets.engaged.H2H = {}
	sets.engaged.Katana = {}
	sets.engaged.GreatKatana = {}
			
	-- Basic Mode definitions
	sets.Mode = {}
	sets.Mode.Acc = set_combine(sets.engaged, {
			head="Flam. Zucchetto +1",neck="Iqabi Necklace",ear1="Zennaroi Earring",ear2="Digni. Earring",
			body="Pumm. Lorica +1",hands="Emicho Gauntlets",ring1="Patricius Ring",ring2="Cacoethic Ring +1",
			back="Ground. Mantle +1",waist="Olseni Belt",legs="Flamma Dirs +1",feet="Valorous Greaves"})
	sets.Mode.Att= set_combine(sets.engaged, {
			head="Sulevia's Mask +1",neck="Sanctity Necklace",ear1="Bladeborn Earring",ear2="Dudgeon Earring",
			body="Phorcys Korazin",hands="Sulev. Gauntlets +1",ring1="Overbearing Ring",ring2="Cho'j Band",
			back="Phalangite Mantle",waist="Eschan Stone",legs="Emicho Hose",feet="Sulev. Leggings +1"})
	sets.Mode.Crit = set_combine(sets.engaged, {
			head="Valorous Mask",hands="Flam. Manopolas +1",ring2="Hetairoi Ring",legs="Jokushu Haidate",feet="Thereoid Greaves"})
	sets.Mode.DA = set_combine(sets.engaged, {
			head="Flam. Zucchetto +1",neck="Asperity Necklace",ear1="Bladeborn Earring",ear2="Steelflash Earring",
			body="Valorous Mail",hands="Sulev. Gauntlets +1",ring2="Hetairoi Ring",
			back="Cichol's Mantle",waist="Sarissapho. Belt",legs="Rvg. Cuisses +2",feet="Flam. Gambieras +1"})
	sets.Mode.Haste = set_combine(sets.engaged, {
			head="Otomi Helm",ear1="Heartseeker Earring",ear2="Dudgeon Earring",
			body="Porthos Byrnie",hands="Emicho Gauntlets",
			waist="Sailfi Belt +1",legs="Jokushu Haidate",feet="Loyalist Sabatons"})
	sets.Mode.Skill = set_combine(sets.engaged, {})
	sets.Mode.sTP = set_combine(sets.engaged, {
			head="Valorous Mask",neck="Asperity Necklace",ear1="Tripudio Earring",ear2="Digni. Earring",
			body="Rvg. Lorica +2",hands="Emicho Gauntlets",ring1="Rajas Ring",ring2="K'ayres Ring",
			back="Laic Mantle",waist="Olseni Belt",legs="Flamma Dirs +1",feet="Valorous Greaves"})
	sets.Mode.STR = set_combine(sets.engaged, {
			head="Flam. Zucchetto +1",neck="Lacono Neck. +1",
			body="Pumm. Lorica +1",hands="Sulev. Gauntlets +1",ring1="Rajas Ring",ring2="Apate Ring",
			back="Buquwik Cape",waist="Wanion Belt",legs="Valor. Hose",feet="Flam. Gambieras +1"})
			
	--Initialize Main Weapons
	sets.engaged.DW = set_combine(sets.engaged, {})
	sets.engaged.Shield = set_combine(sets.engaged, {})
	sets.engaged.Grip = set_combine(sets.engaged, {})
	sets.engaged.DW.Axe = set_combine(sets.engaged, {main="Kumbhakarna",sub="Hatxiik"})
	sets.engaged.Shield.Axe = set_combine(sets.engaged, {main="Kumbhakarna",sub="Deliverance"})
	sets.engaged.DW.Club = set_combine(sets.engaged, {main="Loxotic Mace",sub="Kumbhakarna"})
	-- sets.engaged.Shield.Club = set_combine(sets.engaged, {main="Warp Cudgel",sub="Deliverance"})
	sets.engaged.Shield.Club = set_combine(sets.engaged, {main="Loxotic Mace",sub="Deliverance"})
	sets.engaged.DW.Dagger = set_combine(sets.engaged, {main="Odium",sub="Kumbhakarna"})
	sets.engaged.Shield.Dagger = set_combine(sets.engaged, {main="Odium",sub="Deliverance"})
	sets.engaged.Grip.GreatAxe = set_combine(sets.engaged, {main="Aganoshe",sub="Pole Grip"})
	sets.engaged.Grip.GreatKatana = set_combine(sets.engaged, {main="Hardwood Katana",sub="Pole Grip"})
	sets.engaged.Grip.GreatSword = set_combine(sets.engaged, {main="Zulfiqar",sub="Pole Grip"})
	sets.engaged.Grip.H2H = set_combine(sets.engaged, {main=empty,sub=empty})
	sets.engaged.DW.Katana = set_combine(sets.engaged, {main="Trainee Burin",sub="Kumbhakarna"})
	sets.engaged.Shield.Katana = set_combine(sets.engaged, {main="Trainee Burin",sub="Deliverance"})
	sets.engaged.Grip.Polearm = set_combine(sets.engaged, {main="Pitchfork +1", sub="Pole Grip"})
	sets.engaged.Grip.Scythe = set_combine(sets.engaged, {main="Ark Scythe", sub="Pole Grip"})
	sets.engaged.Grip.Staff = set_combine(sets.engaged, {main="Chatoyant Staff", sub="Pole Grip"})
	sets.engaged.DW.Sword = set_combine(sets.engaged, {main="Tanmogayi +1",sub="Kumbhakarna"})
	sets.engaged.Shield.Sword = set_combine(sets.engaged, {main="Tanmogayi +1",sub="Deliverance"})
	--Add in appropriate Ranged weapons
	sets.ranged = {}
	sets.ranged.Stats = {range="",ammo="Seeth. Bomblet +1"}
	sets.ranged.Xbow = {range="Tsoa. Crossbow",ammo="Bloody Bolt"}
	sets.ranged.Boomerrang = {range="Antitail +1",ammo=""}
	
	sets.engaged.DW.Axe.Xbow = set_combine(sets.engaged.DW.Axe, sets.ranged.Xbow)
	sets.engaged.DW.Axe.Stats = set_combine(sets.engaged.DW.Axe, sets.ranged.Stats)
	sets.engaged.Shield.Axe.Xbow = set_combine(sets.engaged.Shield.Axe, sets.ranged.Xbow)
	sets.engaged.Shield.Axe.Stats = set_combine(sets.engaged.Shield.Axe, sets.ranged.Stats)
	sets.engaged.DW.Club.Xbow = set_combine(sets.engaged.DW.Club, sets.ranged.Xbow)
	sets.engaged.DW.Club.Stats = set_combine(sets.engaged.DW.Club, sets.ranged.Stats)
	sets.engaged.Shield.Club.Xbow = set_combine(sets.engaged.Shield.Club, sets.ranged.Xbow)
	sets.engaged.Shield.Club.Stats = set_combine(sets.engaged.Shield.Club, sets.ranged.Stats)
	sets.engaged.DW.Dagger.Xbow = set_combine(sets.engaged.DW.Dagger, sets.ranged.Xbow)
	sets.engaged.DW.Dagger.Stats = set_combine(sets.engaged.DW.Dagger, sets.ranged.Stats)
	sets.engaged.Shield.Dagger.Xbow = set_combine(sets.engaged.Shield.Dagger, sets.ranged.Xbow)
	sets.engaged.Shield.Dagger.Stats = set_combine(sets.engaged.Shield.Dagger, sets.ranged.Stats)
	sets.engaged.DW.Katana.Xbow = set_combine(sets.engaged.DW.Katana, sets.ranged.Xbow)
	sets.engaged.DW.Katana.Stats = set_combine(sets.engaged.DW.Katana, sets.ranged.Stats)
	sets.engaged.Shield.Katana.Xbow = set_combine(sets.engaged.Shield.Katana, sets.ranged.Xbow)
	sets.engaged.Shield.Katana.Stats = set_combine(sets.engaged.Shield.Katana, sets.ranged.Stats)
	sets.engaged.DW.Sword.Xbow = set_combine(sets.engaged.DW.Sword, sets.ranged.Xbow)
	sets.engaged.DW.Sword.Stats = set_combine(sets.engaged.DW.Sword, sets.ranged.Stats)
	sets.engaged.Shield.Sword.Xbow = set_combine(sets.engaged.Shield.Sword, sets.ranged.Xbow)
	sets.engaged.Shield.Sword.Stats = set_combine(sets.engaged.Shield.Sword, sets.ranged.Stats)

	sets.engaged.Grip.GreatAxe.Xbow = set_combine(sets.engaged.Grip.GreatAxe, sets.ranged.Xbow)
	sets.engaged.Grip.GreatAxe.Stats = set_combine(sets.engaged.Grip.GreatAxe, sets.ranged.Stats)
	sets.engaged.Grip.GreatSword.Xbow = set_combine(sets.engaged.Grip.GreatSword, sets.ranged.Xbow)
	sets.engaged.Grip.GreatSword.Stats = set_combine(sets.engaged.Grip.GreatSword, sets.ranged.Stats)
	sets.engaged.Grip.GreatKatana.Xbow = set_combine(sets.engaged.Grip.GreatKatana, sets.ranged.Xbow)
	sets.engaged.Grip.GreatKatana.Stats = set_combine(sets.engaged.Grip.GreatKatana, sets.ranged.Stats)
	sets.engaged.Grip.H2H.Xbow = set_combine(sets.engaged.Grip.H2H, sets.ranged.Xbow)
	sets.engaged.Grip.H2H.Stats = set_combine(sets.engaged.Grip.H2H, sets.ranged.Stats)
	sets.engaged.Grip.Scythe.Xbow = set_combine(sets.engaged.Grip.Scythe, sets.ranged.Xbow)
	sets.engaged.Grip.Scythe.Stats = set_combine(sets.engaged.Grip.Scythe, sets.ranged.Stats)
	sets.engaged.Grip.Polearm.Xbow = set_combine(sets.engaged.Grip.Polearm, sets.ranged.Xbow)
	sets.engaged.Grip.Polearm.Stats = set_combine(sets.engaged.Grip.Polearm, sets.ranged.Stats)
	sets.engaged.Grip.Staff.Xbow = set_combine(sets.engaged.Grip.Staff, sets.ranged.Xbow)
	sets.engaged.Grip.Staff.Stats = set_combine(sets.engaged.Grip.Staff, sets.ranged.Stats)
	
	sets.engaged.Grip.GreatAxe.Acc = set_combine(sets.engaged.Grip.GreatAxe, sets.Mode.Acc)
	sets.engaged.Grip.GreatAxe.Att = set_combine(sets.engaged.Grip.GreatAxe, sets.Mode.Att)
	sets.engaged.Grip.GreatAxe.Crit = set_combine(sets.engaged.Grip.GreatAxe, sets.Mode.Crit)
	sets.engaged.Grip.GreatAxe.DA = set_combine(sets.engaged.Grip.GreatAxe, sets.Mode.DA)
	sets.engaged.Grip.GreatAxe.Haste = set_combine(sets.engaged.Grip.GreatAxe, sets.Mode.Haste)
	sets.engaged.Grip.GreatAxe.Skill = set_combine(sets.engaged.Grip.GreatAxe, {ring1="Moepapa Ring"})
	sets.engaged.Grip.GreatAxe.sTP = set_combine(sets.engaged.Grip.GreatAxe, sets.Mode.sTP)
	sets.engaged.Grip.GreatAxe.STR = set_combine(sets.engaged.Grip.GreatAxe, sets.Mode.STR)

	sets.engaged.Grip.GreatSword.Acc = set_combine(sets.engaged.Grip.GreatSword, sets.Mode.Acc)
	sets.engaged.Grip.GreatSword.Att = set_combine(sets.engaged.Grip.GreatSword, sets.Mode.Att)
	sets.engaged.Grip.GreatSword.Crit = set_combine(sets.engaged.Grip.GreatSword, sets.Mode.Crit)
	sets.engaged.Grip.GreatSword.DA = set_combine(sets.engaged.Grip.GreatSword, sets.Mode.DA)
	sets.engaged.Grip.GreatSword.Haste = set_combine(sets.engaged.Grip.GreatSword, sets.Mode.Haste)
	sets.engaged.Grip.GreatSword.Skill = set_combine(sets.engaged.Grip.GreatSword, {})
	sets.engaged.Grip.GreatSword.sTP = set_combine(sets.engaged.Grip.GreatSword, sets.Mode.sTP)
	sets.engaged.Grip.GreatSword.STR = set_combine(sets.engaged.Grip.GreatSword, sets.Mode.STR)
	
	sets.engaged.Grip.Scythe.Acc = set_combine(sets.engaged.Grip.Scythe, sets.Mode.Acc)
	sets.engaged.Grip.Scythe.Att = set_combine(sets.engaged.Grip.Scythe, sets.Mode.Att)
	sets.engaged.Grip.Scythe.Crit = set_combine(sets.engaged.Grip.Scythe, sets.Mode.Crit)
	sets.engaged.Grip.Scythe.DA = set_combine(sets.engaged.Grip.Scythe, sets.Mode.DA)
	sets.engaged.Grip.Scythe.Haste = set_combine(sets.engaged.Grip.Scythe, sets.Mode.Haste)
	sets.engaged.Grip.Scythe.Skill = set_combine(sets.engaged.Grip.Scythe, {})
	sets.engaged.Grip.Scythe.sTP = set_combine(sets.engaged.Grip.Scythe, sets.Mode.sTP)
	sets.engaged.Grip.Scythe.STR = set_combine(sets.engaged.Grip.Scythe, sets.Mode.STR)

	sets.engaged.Grip.GreatKatana.Acc = set_combine(sets.engaged.Grip.GreatAxe, sets.Mode.Acc)
	sets.engaged.Grip.H2H.Acc = set_combine(sets.engaged.Grip.GreatAxe, sets.Mode.Acc)
	
	sets.engaged.DW.Axe.Acc = set_combine(sets.engaged.DW.Axe, sets.Mode.Acc)
	sets.engaged.DW.Axe.Att = set_combine(sets.engaged.DW.Axe, sets.Mode.Att)
	sets.engaged.DW.Axe.Crit = set_combine(sets.engaged.DW.Axe, sets.Mode.Crit)
	sets.engaged.DW.Axe.DA = set_combine(sets.engaged.DW.Axe, sets.Mode.DA)
	sets.engaged.DW.Axe.Haste = set_combine(sets.engaged.DW.Axe, sets.Mode.Haste)
	sets.engaged.DW.Axe.Skill = set_combine(sets.engaged.DW.Axe, {})
	sets.engaged.DW.Axe.sTP = set_combine(sets.engaged.DW.Axe, sets.Mode.sTP)
	sets.engaged.DW.Axe.STR = set_combine(sets.engaged.DW.Axe, sets.Mode.STR)
	sets.engaged.Shield.Axe.Acc = set_combine(sets.engaged.Shield.Axe, sets.Mode.Acc)
	sets.engaged.Shield.Axe.Att = set_combine(sets.engaged.Shield.Axe, sets.Mode.Att)
	sets.engaged.Shield.Axe.Crit = set_combine(sets.engaged.Shield.Axe, sets.Mode.Crit)
	sets.engaged.Shield.Axe.DA = set_combine(sets.engaged.Shield.Axe, sets.Mode.DA)
	sets.engaged.Shield.Axe.Haste = set_combine(sets.engaged.Shield.Axe, sets.Mode.Haste)
	sets.engaged.Shield.Axe.Skill = set_combine(sets.engaged.Shield.Axe, {})
	sets.engaged.Shield.Axe.sTP = set_combine(sets.engaged.Shield.Axe, sets.Mode.sTP)
	sets.engaged.Shield.Axe.STR = set_combine(sets.engaged.Shield.Axe, sets.Mode.STR)
	
	sets.engaged.DW.Club.Acc = set_combine(sets.engaged.DW.Club, sets.Mode.Acc)
	sets.engaged.DW.Club.Att = set_combine(sets.engaged.DW.Club, sets.Mode.Att)
	sets.engaged.DW.Club.Crit = set_combine(sets.engaged.DW.Club, sets.Mode.Crit)
	sets.engaged.DW.Club.DA = set_combine(sets.engaged.DW.Club, sets.Mode.DA)
	sets.engaged.DW.Club.Haste = set_combine(sets.engaged.DW.Club, sets.Mode.Haste)
	sets.engaged.DW.Club.Skill = set_combine(sets.engaged.DW.Club, {})
	sets.engaged.DW.Club.sTP = set_combine(sets.engaged.DW.Club, sets.Mode.sTP)
	sets.engaged.DW.Club.STR = set_combine(sets.engaged.DW.Club, sets.Mode.STR)
	sets.engaged.Shield.Club.Acc = set_combine(sets.engaged.Shield.Club, sets.Mode.Acc)
	sets.engaged.Shield.Club.Att = set_combine(sets.engaged.Shield.Club, sets.Mode.Att)
	sets.engaged.Shield.Club.Crit = set_combine(sets.engaged.Shield.Club, sets.Mode.Crit)
	sets.engaged.Shield.Club.DA = set_combine(sets.engaged.Shield.Club, sets.Mode.DA)
	sets.engaged.Shield.Club.Haste = set_combine(sets.engaged.Shield.Club, sets.Mode.Haste)
	sets.engaged.Shield.Club.Skill = set_combine(sets.engaged.Shield.Club, {})
	sets.engaged.Shield.Club.sTP = set_combine(sets.engaged.Shield.Club, sets.Mode.sTP)
	sets.engaged.Shield.Club.STR = set_combine(sets.engaged.Shield.Club, sets.Mode.STR)

	sets.engaged.DW.Dagger.Acc = set_combine(sets.engaged.DW.Dagger, sets.Mode.Acc)
	sets.engaged.DW.Dagger.Att = set_combine(sets.engaged.DW.Dagger, sets.Mode.Att)
	sets.engaged.DW.Dagger.Crit = set_combine(sets.engaged.DW.Dagger, sets.Mode.Crit)
	sets.engaged.DW.Dagger.DA = set_combine(sets.engaged.DW.Dagger, sets.Mode.DA)
	sets.engaged.DW.Dagger.Haste = set_combine(sets.engaged.DW.Dagger, sets.Mode.Haste)
	sets.engaged.DW.Dagger.Skill = set_combine(sets.engaged.DW.Dagger, {neck="Maskirova Torque"})
	sets.engaged.DW.Dagger.sTP = set_combine(sets.engaged.DW.Dagger, sets.Mode.sTP)
	sets.engaged.DW.Dagger.STR = set_combine(sets.engaged.DW.Dagger, sets.Mode.STR)
	sets.engaged.Shield.Dagger.Acc = set_combine(sets.engaged.Shield.Dagger, sets.Mode.Acc)
	sets.engaged.Shield.Dagger.Att = set_combine(sets.engaged.Shield.Dagger, sets.Mode.Att)
	sets.engaged.Shield.Dagger.Crit = set_combine(sets.engaged.Shield.Dagger, sets.Mode.Crit)
	sets.engaged.Shield.Dagger.DA = set_combine(sets.engaged.Shield.Dagger, sets.Mode.DA)
	sets.engaged.Shield.Dagger.Haste = set_combine(sets.engaged.Shield.Dagger, sets.Mode.Haste)
	sets.engaged.Shield.Dagger.Skill = set_combine(sets.engaged.Shield.Dagger, {neck="Maskirova Torque"})
	sets.engaged.Shield.Dagger.sTP = set_combine(sets.engaged.Shield.Dagger, sets.Mode.sTP)
	sets.engaged.Shield.Dagger.STR = set_combine(sets.engaged.Shield.Dagger, sets.Mode.STR)

	sets.engaged.DW.Katana.Acc = set_combine(sets.engaged.DW.Katana, sets.Mode.Acc)
	sets.engaged.DW.Katana.Att = set_combine(sets.engaged.DW.Katana, sets.Mode.Att)
	sets.engaged.DW.Katana.Crit = set_combine(sets.engaged.DW.Katana, sets.Mode.Crit)
	sets.engaged.DW.Katana.DA = set_combine(sets.engaged.DW.Katana, sets.Mode.DA)
	sets.engaged.DW.Katana.Haste = set_combine(sets.engaged.DW.Katana, sets.Mode.Haste)
	sets.engaged.DW.Katana.Skill = set_combine(sets.engaged.DW.Katana, {})
	sets.engaged.DW.Katana.sTP = set_combine(sets.engaged.DW.Katana, sets.Mode.sTP)
	sets.engaged.DW.Katana.STR = set_combine(sets.engaged.DW.Katana, sets.Mode.STR)
	sets.engaged.Shield.Katana.Acc = set_combine(sets.engaged.Shield.Katana, sets.Mode.Acc)
	sets.engaged.Shield.Katana.Att = set_combine(sets.engaged.Shield.Katana, sets.Mode.Att)
	sets.engaged.Shield.Katana.Crit = set_combine(sets.engaged.Shield.Katana, sets.Mode.Crit)
	sets.engaged.Shield.Katana.DA = set_combine(sets.engaged.Shield.Katana, sets.Mode.DA)
	sets.engaged.Shield.Katana.Haste = set_combine(sets.engaged.Shield.Katana, sets.Mode.Haste)
	sets.engaged.Shield.Katana.Skill = set_combine(sets.engaged.Shield.Katana, {})
	sets.engaged.Shield.Katana.sTP = set_combine(sets.engaged.Shield.Katana, sets.Mode.sTP)
	sets.engaged.Shield.Katana.STR = set_combine(sets.engaged.Shield.Katana, sets.Mode.STR)

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

	sets.engaged.Grip.Polearm.Acc = set_combine(sets.engaged.Grip.Polearm, sets.Mode.Acc)
	sets.engaged.Grip.Polearm.Att = set_combine(sets.engaged.Grip.Polearm, sets.Mode.Att)
	sets.engaged.Grip.Polearm.Crit = set_combine(sets.engaged.Grip.Polearm, sets.Mode.Crit)
	sets.engaged.Grip.Polearm.DA = set_combine(sets.engaged.Grip.Polearm, sets.Mode.DA)
	sets.engaged.Grip.Polearm.Haste = set_combine(sets.engaged.Grip.Polearm, sets.Mode.Haste)
	sets.engaged.Grip.Polearm.Skill = set_combine(sets.engaged.Grip.Polearm, {
			neck="Maskirova Torque",ear1="Tripudio Earring"})
	sets.engaged.Grip.Polearm.sTP = set_combine(sets.engaged.Grip.Polearm, sets.Mode.sTP)
	sets.engaged.Grip.Polearm.STR = set_combine(sets.engaged.Grip.Polearm, sets.Mode.STR)

	sets.engaged.Grip.Staff.Acc = set_combine(sets.engaged.Grip.Staff, sets.Mode.Acc)
			
	-- Precast Sets
	-- Precast sets to enhance JAs
    sets.precast.JA.Berserk = {body="Pumm. Lorica +1",back="Cichol's Mantle",feet="Agoge Calligae +1"}
    sets.precast.JA['Aggressor'] = {head="Pummeler's Mask",body="Agoge Lorica +1"}
    sets.precast.JA['Mighty Strikes'] = {hands="Agoge Mufflers +1"}
    sets.precast.JA['Blood Rage'] = {body="Rvg. Lorica +2"}
    sets.precast.JA['Warcry'] = {head="Agoge Mask +1"}
    sets.precast.JA['Restraint'] = {head="Rvg. Mufflers +2"}
    sets.precast.JA['Retaliation'] = {head="Rvg. Calligae +2"}
    sets.precast.JA['Tomahawk'] = {ammo="Thr. Tomahawk",feet="Agoge Calligae +1"}
    
    -- Sets to apply to any actions of spell.type
	
	-- Waltz set (chr and vit)
	sets.precast.Waltz = {
			head="Skormoth Mask",
			body="Savas Jawshan",hands="Buremte Gloves",
			back="Laic Mantle",legs="Emicho Hose",feet="Sulev. Leggings +1"}
		   
	-- Don't need any special gear for Healing Waltz.
	sets.precast.Waltz['Healing Waltz'] = {}
   
	-- Fast cast sets for spells
	sets.precast.FC = {neck="Baetyl Pendant",ear1="Etiolation Earring",
		body="Odyss. Chestplate",hands="Leyline Gloves",legs="Limbo Trousers"}

	-- Midcast Sets
	-- sets.midcast.FastRecast = {}     

	-- Ranged gear
    sets.midcast.RA = {
        neck="Iqabi Necklace",
        ring1="Behemoth Ring",ring2="Cacoethic Ring +1",
        waist="Eschan Stone"}

		   
	-- Weaponskill sets
	-- Default set for any weaponskill that isn't any more specifically defined
	sets.WSDayBonus = {head="Gavialis Helm"} 
	sets.precast.WS = set_combine(sets.Mode.STR, {neck="Fotia Gorget",ear2="Ishvara Earring",body="Phorcys Korazin",hands="Odyssean Gauntlets",waist="Fotia Belt",feet="Sulev. Leggings +1"})
	sets.precast.WS.Acc = set_combine(sets.precast.WS, {})
   
	-- Specific weaponskill sets.  Uses the base set if an appropriate WSMod version isn't found.
	-- Thunder, STR 60% VIT 60%
	sets.precast.WS['Shield Break'] = set_combine(sets.precast.WS, {})

	-- Earth, STR 60% 
	sets.precast.WS['Iron Tempest'] = set_combine(sets.precast.WS, {})

	-- Earth/Water, STR 60% 
	sets.precast.WS['Sturmwind'] = set_combine(sets.precast.WS, {})

	-- Thunder, STR 60% VIT 60%
	sets.precast.WS['Armor Break'] = set_combine(sets.precast.WS, {})

	-- Dark, STR 100%
	sets.precast.WS['Keen Edge'] = set_combine(sets.precast.WS, {})

	-- Thunder, STR 60% VIT 60%
	sets.precast.WS['Weapon Break'] = set_combine(sets.precast.WS, {})

	-- Ice/Water, STR 50% 
	sets.precast.WS['Raging Rush'] = set_combine(sets.precast.WS, {})
	
	-- Ice/Water, STR 50% VIT 50%
	sets.precast.WS['Full Break'] = set_combine(sets.precast.WS, {})
	
	-- Ice/Water/Wind, STR 60% VIT 60%
	sets.precast.WS['Steel Cyclone'] = set_combine(sets.precast.WS, {})
	
	-- Earth/Thunder/Wind, STR 60%
	sets.precast.WS['Fell Cleave'] = set_combine(sets.precast.WS, {})
	
	-- Fire/Light/Dark, STR 60%
	sets.precast.WS['Upheaval'] = set_combine(sets.precast.WS, {})
	
	-- Wind/Thunder/Light, STR 80%
	sets.precast.WS['Ukko\'s Fury'] = set_combine(sets.precast.WS, {})
	
	-- Earth/Thunder/Wind, STR 50%
	sets.precast.WS['King\'s Justice'] = set_combine(sets.precast.WS, {})
	
	-- Thunder/Wind, STR 60%
	sets.precast.WS['Raging Axe'] = set_combine(sets.precast.WS, {})
	
	-- Ice/Water, STR 100%
	sets.precast.WS['Smash Axe'] = set_combine(sets.precast.WS, {})
	
	-- Wind, STR 100%
	sets.precast.WS['Gale Axe'] = set_combine(sets.precast.WS, {})
	
	-- Earth/Thunder, STR 60%
	sets.precast.WS['Avalanche Axe'] = set_combine(sets.precast.WS, {})
	
	-- Earth/Thunder/Fire, STR 60%
	sets.precast.WS['Spinning Axe'] = set_combine(sets.precast.WS, {})
	
	-- Earth, STR 50%
	sets.precast.WS['Rampage'] = set_combine(sets.precast.WS, {})
	
	-- Earth/Thunder, STR 50% VIT 50%
	sets.precast.WS['Calamity'] = set_combine(sets.precast.WS, {})

	-- Earth/Thunder, STR 50% 
	sets.precast.WS['Mistral Axe'] = set_combine(sets.precast.WS, {})
	
	-- Fire/light/water, STR 50%
	sets.precast.WS['Decimation'] = set_combine(sets.precast.WS, {})
	
	-- Earth/Wind, DEX 100%
	sets.precast.WS['Bora Axe'] = set_combine(sets.precast.WS, {})
	
	-- Earth/Wind, STR 73%
	sets.precast.WS['Ruinator'] = set_combine(sets.precast.WS, {})
	
	-- Dark/Wind/Thunder, STR 40% MND 40%
	sets.precast.WS['Cloudsplitter'] = set_combine(sets.precast.WS, {})
	
	-- Earth/Wind/Thunder, STR 73%
	sets.precast.WS['Resolution'] = set_combine(sets.precast.WS, {})

	-- Light, STR 30% DEX 30%
	sets.precast.WS['Double Thrust'] = set_combine(sets.precast.WS, {})
		
	-- Light/Thunder, STR 40% INT 40%
	sets.precast.WS['Thunder Thrust'] = set_combine(sets.precast.WS, {})

	-- Light/Thunder, STR 40% INT 40% 
	sets.precast.WS['Raiden Thrust'] = set_combine(sets.precast.WS, {})

	-- Thunder, STR 100%
	sets.precast.WS['Leg Sweep'] = set_combine(sets.precast.WS, {})

	-- Darkness, STR 20% DEX 20% 
	sets.precast.WS['Penta Thrust'] = set_combine(sets.precast.WS, {})

	-- Light/Water, STR 50% AGI 50% 
	sets.precast.WS['Vorpal Thrust'] = set_combine(sets.precast.WS, {})

	-- Dark/Earth/Ice, STR 100% -->
	sets.precast.WS['Impulse Drive'] = set_combine(sets.precast.WS, {})

	-- Light/Earth, STR 40% DEX 40%-->
	sets.precast.WS['Sonic Thrust'] = set_combine(sets.precast.WS, {})

	-- Dark/Earth/Light, STR 85% -->
	sets.precast.WS['Stardiver'] = set_combine(sets.precast.WS, {})

	-- Defense sets
	sets.defense = {}
	
	sets.defense.Reraise = {head="Twilight Helm", body="Twilight Mail"}

	sets.defense.Evasion = {
		head="Valorous Mask",ear1="Infused Earring",ear2="Assuage Earring",
		body="Pumm. Lorica +1",hands="Umuthi Gloves",ring2="Vengeful Ring",
		legs="Valor. Hose",feet="Valorous Greaves"}

	sets.defense.PDT = {
		head="Sulevia's Mask +1",neck="Homeric Gorget",
		body="Sulevia's Plate. +1",hands="Sulev. Gauntlets +1",ring1="Defending Ring",ring2="Patricius Ring",
		back="Solemnity Cape",legs="Sulevi. Cuisses +1",feet="Sulev. Leggings +1"}

	sets.defense.MDT = {
		head="Sulevia's Mask +1",neck="Twilight Torque",ear1="Etiolation Earring",
		body="Sulevia's Plate. +1",hands="Sulev. Gauntlets +1",ring1="Defending Ring",ring2="Vengeful Ring",
		back="Solemnity Cape",waist="Flax Sash",legs="Sulevi. Cuisses +1",feet="Sulev. Leggings +1"}
	
	sets.debuffed = set_combine(sets.defense.Evasion,sets.defense.PDT,sets.defense.MDT)

	sets.Kiting = {}

	-- Melee sets for in Adoulin, which has an extra 2% Haste from Ionis.
	sets.engaged.Adoulin = set_combine(sets.engaged, {})
	sets.Assault = {ring2="Ulthalam's Ring"}
end
 
-------------------------------------------------------------------------------------------------------------------
-- Job-specific hooks that are called to process player actions at specific points in time.
-------------------------------------------------------------------------------------------------------------------
 
-- Set eventArgs.handled to true if we don't want any automatic target handling to be done.
function job_pretarget(spell, action, spellMap, eventArgs)
	-- add_to_chat(120,'stance is '..state.Stance.value)
end
 
-- Set eventArgs.handled to true if we don't want any automatic gear equipping to be done.
-- Set eventArgs.useMidcastGear to true if we want midcast gear equipped on precast.
function job_precast(spell, action, spellMap, eventArgs)
	-- add_to_chat(120,'job precast')
	if spell.type == 'WeaponSkill' and spell.target.distance > 5.1 then
		cancel_spell()
		add_to_chat(123, 'WeaponSkill Canceled: [Out of Range]')
	end
end
 
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
 
-- Set eventArgs.handled to true if we don't want any automatic gear equipping to be done.
function job_midcast(spell, action, spellMap, eventArgs)

end
 
-- Run after the default midcast() is done.
-- eventArgs is the same one used in job_midcast, in case information needs to be persisted.
function job_post_midcast(spell, action, spellMap, eventArgs)
   
end
 
-- Runs when a pet initiates an action.
-- Set eventArgs.handled to true if we don't want any automatic gear equipping to be done.
function job_pet_midcast(spell, action, spellMap, eventArgs)
	-- add_to_chat(122,'pet midcast')
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
end
 
-- Run after the default pet midcast() is done.
-- eventArgs is the same one used in job_pet_midcast, in case information needs to be persisted.
function job_pet_post_midcast(spell, action, spellMap, eventArgs)
    -- add_to_chat(122,'pet post midcast')   
end
 
-- Set eventArgs.handled to true if we don't want any automatic gear equipping to be done.
function job_aftercast(spell, action, spellMap, eventArgs)
	--add_to_chat(122,'aftercast')
end
 
-- Run after the default aftercast() is done.
-- eventArgs is the same one used in job_aftercast, in case information needs to be persisted.
function job_post_aftercast(spell, action, spellMap, eventArgs)
	-- add_to_chat(122,'post aftercast')
end
 
-- Set eventArgs.handled to true if we don't want any automatic gear equipping to be done.
function job_pet_aftercast(spell, action, spellMap, eventArgs)
	-- add_to_chat(122,'pet aftercast')
end
 
-- Run after the default pet aftercast() is done.
-- eventArgs is the same one used in job_pet_aftercast, in case information needs to be persisted.
function job_pet_post_aftercast(spell, action, spellMap, eventArgs)
	-- add_to_chat(122,'post pet aftercast')
end
 
-------------------------------------------------------------------------------------------------------------------
-- Customization hooks for idle and melee sets, after they've been automatically constructed.
-------------------------------------------------------------------------------------------------------------------
 
-- Called before the Include starts constructing melee/idle/resting sets.
-- Can customize state or custom melee class values at this point.
-- Set eventArgs.handled to true if we don't want any automatic gear equipping to be done.
function job_handle_equipping_gear(status, eventArgs)
	-- add_to_chat(122,'handle equiping gear')
	check_tp_lock()
	set_combat_form()
	pick_tp_weapon()
	handle_twilight()
end
 
-- Return a customized weaponskill mode to use for weaponskill sets.
-- Don't return anything if you're not overriding the default value.
function get_custom_wsmode(spell, action, spellMap)
	-- add_to_chat(122,'get custom wsmode')
end
 
-- Modify the default idle set after it was constructed.
function customize_idle_set(idleSet)
	-- add_to_chat(122,'customize idle set')
    if not buffactive["Reraise"] then
		idleSet = set_combine(idleSet, sets.defense.Reraise)
	end
    return idleSet
end
 
-- Modify the default melee set after it was constructed.
function customize_melee_set(meleeSet)
	if areas.Assault:contains(world.area) then
		meleeSet = set_combine(meleeSet, sets.Assault)
	end

    return meleeSet
end
 
-------------------------------------------------------------------------------------------------------------------
-- General hooks for other events.
-------------------------------------------------------------------------------------------------------------------
 
-- Called when the player's status changes.
function job_status_change(newStatus, oldStatus, eventArgs)
	-- add_to_chat(122,'job_status_change')
end
 
-- Called when the player's pet's status changes.
function job_pet_status_change(newStatus, oldStatus, eventArgs)
 
end
 
-- Called when a player gains or loses a buff.
-- buff == buff gained or lost
-- gain == true if the buff was gained, false if it was lost.
function job_buff_change(buff, gain)
	handle_debuffs()
	handle_war_ja()
	if player.sub_job == 'SAM' then
		handle_sam_ja()
	end
end
 
-------------------------------------------------------------------------------------------------------------------
-- User code that supplements self-commands.
-------------------------------------------------------------------------------------------------------------------
 
-- Called for custom player commands.
function job_self_command(cmdParams, eventArgs)
 
end
 
-- Called by the 'update' self-command, for common needs.
-- Set eventArgs.handled to true if we don't want automatic equipping of gear.
function job_update(cmdParams, eventArgs)
	classes.CustomMeleeGroups:clear()
	if areas.Adoulin:contains(world.area) and buffactive.ionis then
			classes.CustomMeleeGroups:append('Adoulin')
	end
	if areas.Assault:contains(world.area) then
			classes.CustomMeleeGroups:append('Assault')
	end
	pick_tp_weapon()
end
 
-- Job-specific toggles.
function job_toggle(field)
 
end
 
-- Request job-specific mode lists.
-- Return the list, and the current value for the requested field.
function job_get_mode_list(field)
 
end
 
-- Set job-specific mode values.
-- Return true if we recognize and set the requested field.
function job_set_mode(field, val)
 
end
 
-- Handle auto-targetting based on local setup.
function job_auto_change_target(spell, action, spellMap, eventArgs)
 
end
 
-- Set eventArgs.handled to true if we don't want the automatic display to be run.
function display_current_job_state(eventArgs)
 
end
 
-------------------------------------------------------------------------------------------------------------------
-- Utility functions specific to this job.
-------------------------------------------------------------------------------------------------------------------

function determine_groups()
	-- add_to_chat(122,' determine groups')
	-- classes.CustomMeleeGroups:clear()
end

-- Select default macro book on initial load or subjob change.
function select_default_macro_book()
	-- Default macro set/book
	if player.sub_job == 'NIN' then
		set_macro_page(1, 8)
	elseif player.sub_job == 'SAM' then
		set_macro_page(1, 8)
	elseif player.sub_job == 'DNC' then
		set_macro_page(3, 8)
	else
		set_macro_page(1, 8)
	end
	send_command('exec war.txt')
end
