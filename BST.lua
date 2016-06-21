include('organizer-lib.lua')
-- NOTE: I do not play bst, so this will not be maintained for 'active' use. 
-- It is added to the repository to allow people to have a baseline to build from,
-- and make sure it is up-to-date with the library API.

-- Credit to Quetzalcoatl.Falkirk for most of the original work.

--[[
    Custom commands:
    
    Ctrl-F8 : Cycle through available pet food options.
    Alt-F8 : Cycle through correlation modes for pet attacks.
]]

-------------------------------------------------------------------------------------------------------------------
-- Setup functions for this job.  Generally should not be modified.
-------------------------------------------------------------------------------------------------------------------

-- Initialization function for this job file.
function get_sets()
    mote_include_version = 2
    
    -- Load and initialize the include file.
    include('Mote-Include.lua')
end

function job_setup()
	state.WeaponMode = M{['description']='Weapon Mode', 'Axe', 'Scythe', 'Sword', 'Staff', 'Club', 'Dagger'}
	state.SubMode = M{['description']='Sub Mode', 'DW', 'Shield', 'Grip' }
	state.Stance = M{['description']='Stance', 'Off', 'None', 'Offensive', 'Defensive'}
	state.holdtp = M{['description']='holdtp', 'true', 'false'}
	state.loyalty = M{['description']='loyalty', 'true', 'false'}
	--Call Beast items
	call_beast_items = {
		CrabFamiliar="Fish Broth",
		SlipperySilas="Wormy Broth",
		HareFamiliar="Carrot Broth",
		SheepFamiliar="Herbal Broth",
		FlowerpotBill="Humus",
		TigerFamiliar="Meat Broth",
		FlytrapFamiliar="Grasshopper Broth",
		LizardFamiliar="Carrion Broth",
		MayflyFamiliar="Bug Broth",
		EftFamiliar="Mole Broth",
		BeetleFamiliar="Tree Sap",
		AntlionFamiliar="Antica Broth",
		MiteFamiliar="Blood Broth",
		KeenearedSteffi="Famous Carrot Broth",
		LullabyMelodia="Singing Herbal Broth",
		FlowerpotBen="Rich Humus",
		SaberSiravarde="Warm Meat Broth",
		FunguarFamiliar="Seedbed Soil",
		ShellbusterOrob="Quadav Bug Broth",
		ColdbloodComo="Cold Carrion Broth",
		CourierCarrie="Fish Oil Broth",
		Homunculus="Alchemist Water=",
		VoraciousAudrey="Noisy Grasshopper Broth",
		AmbusherAllie="Lively Mole Broth",
		PanzerGalahad="Scarlet Sap",
		LifedrinkerLars="Clear Blood Broth",
		ChopsueyChucky="Fragrant Antica Broth",
		AmigoSabotender="Sun Water",
		NurseryNazuna="Dancing Herbal Broth",
		CraftyClyvonne="Cunning Brain Broth",
		PrestoJulio="Chirping Grasshopper Broth",
		SwiftSieghard="Mellow Bird Broth",
		MailbusterCetas="Goblin Bug Broth",
		AudaciousAnna="Bubbling Carrion Broth",
		TurbidToloi="Auroral Broth",
		LuckyLulush="Lucky Carrot Broth",
		DipperYuly="Wool Grease",
		FlowerpotMerle="Vermihumus",
		DapperMac="Briny Broth",
		DiscreetLouise="Deepbed Soil",
		FatsoFargann="Curdled Plasma",
		FaithfulFalcorr="Lucky Broth",
		BugeyedBroncha="Savage Mole Broth",
		BloodclawShasra="Razor Brain Broth",
		GorefangHobs="Burning Carrion Broth",
		GooeyGerard="Cloudy Wheat Broth",
		CrudeRaphie="Shadowy Broth",
		DroopyDortwin="Swirling Broth",
		SunburstMalfik="Shimmering Broth",
		WarlikePatrick="Livid Broth",
		ScissorlegXerin="Spicy Broth",
		RhymingShizuna="Lyrical Broth",
		AttentiveIbuki="Salubrious Broth",
		AmiableRoche="Airy Broth",
		HeraldHenry="Translucent Broth",
		BrainyWaluis="Crumbly Soil",
		HeadbreakerKen="Blackwater Broth",
		RedolentCandi="Electrified Broth",
		CaringKiyomaro="Fizzy Broth",
		HurlerPercival="Pale Sap",
		BlackbeardRandy="Meaty Broth",
		GenerousArthur="Dire Broth",
		ThreestarLynn="Muddy Broth",
		BraveHeroGlenn="Wispy Broth",
		SharpwitHermes="Saline Broth",
		FleetReinhard="Rapid Broth",
		VivaciousVickie="Tant. Broth",
		AlluringHoney="Bug-Ridden Broth",
		BouncingBertha="Bubbly Broth",
		SwoopingZhivago="Windy Greens"
	}
 
	set_combat_form()
	pick_tp_weapon()

    state.RewardMode = M{['description']='Reward Mode', 'Theta', 'Eta', 'Zeta', 'Epsilon', 'Delta', 'Gamma', 'Beta', 'Alpha'}
    RewardFood = {name="Pet Food Theta"}
	-- cntl F8
    send_command('bind ^f8 gs c cycle RewardMode')

    -- Set up Monster Correlation Modes and keybind Alt-F8
    state.CorrelationMode = M{['description']='Correlation Mode', 'Neutral','Favorable'}
    send_command('bind !f8 gs c cycle CorrelationMode')
    
    ready_moves_to_check = S{'Sic','Whirl Claws','Dust Cloud','Foot Kick','Sheep Song','Sheep Charge','Lamb Chop',
		'Rage','Head Butt','Scream','Dream Flower','Wild Oats','Leaf Dagger','Claw Cyclone','Razor Fang',
		'Roar','Gloeosuccus','Palsy Pollen','Soporific','Cursed Sphere','Venom','Geist Wall','Toxic Spit',
		'Numbing Noise','Nimble Snap','Cyclotail','Spoil','Rhino Guard','Rhino Attack','Power Attack',
		'Hi-Freq Field','Sandpit','Sandblast','Venom Spray','Mandibular Bite','Metallic Body','Bubble Shower',
		'Bubble Curtain','Scissor Guard','Big Scissors','Grapple','Spinning Top','Double Claw','Filamented Hold',
		'Frog Kick','Queasyshroom','Silence Gas','Numbshroom','Spore','Dark Spore','Shakeshroom','Blockhead',
		'Secretion','Fireball','Tail Blow','Plague Breath','Brain Crush','Infrasonics','??? Needles',
		'Needleshot','Chaotic Eye','Blaster','Scythe Tail','Ripper Fang','Chomp Rush','Intimidate','Recoil Dive',
		'Water Wall','Snow Cloud','Wild Carrot','Sudden Lunge','Spiral Spin','Noisome Powder','Wing Slap',
		'Beak Lunge','Suction','Drainkiss','Acid Mist','TP Drainkiss','Back Heel','Jettatura','Choke Breath',
		'Fantod','Charged Whisker','Purulent Ooze','Corrosive Ooze','Tortoise Stomp','Harden Shell','Aqua Breath',
		'Sensilla Blades','Tegmina Buffet','Molting Plumage','Swooping Frenzy','Pentapeck','Sweeping Gouge',
		'Zealous Snort','Somersault ','Tickling Tendrils','Stink Bomb','Nectarous Deluge','Nepenthic Plunge',
        'Pecking Flurry','Pestilent Plume','Foul Waters','Spider Web','Sickle Slash','Frogkick','Ripper Fang',
		'Scythe Tail','Chomp Rush'
	}

	include('Mote-TreasureHunter')	
end

-------------------------------------------------------------------------------------------------------------------
-- User setup functions for this job.  Recommend that these be overridden in a sidecar file.
-------------------------------------------------------------------------------------------------------------------

function user_setup()
    state.OffenseMode:options('Normal', 'Acc')
    state.WeaponskillMode:options('Normal', 'Acc')
    state.IdleMode:options('Normal', 'Refresh', 'Reraise')
    state.PhysicalDefenseMode:options('PDT', 'Killer')
	state.OffenseMode:options('Normal', 'Acc', 'Att', 'Crit', 'DA', 'Haste', 'Skill', 'sTP', 'STR')
	state.WeaponskillMode:options('Normal', 'Acc', 'Mod')
	state.DefenseMode:options('None', 'Physical', 'Magical')
	state.PhysicalDefenseMode:options('PDT', 'Evasion', 'Reraise')
	state.MagicalDefenseMode:options('MDT', 'Reraise')
	state.WeaponMode:set('Axe')
	state.Stance:set('Offensive')
	state.SubMode:set('DW')
	state.holdtp:set('false')
	state.loyalty:set('true')
	gear.Broth = {name=""}
	gear.Offhand = {name=""}
	flag.sekka = true
	flag.med = true
	flag.berserk = true
	flag.defender = true
	flag.aggressor = true
	flag.warcry = true
	flag.thirdeye = true

	pick_tp_weapon()
	select_offhand()
	select_default_macro_book()
	send_command('bind ^= gs c cycle treasuremode')
end


-- Called when this job file is unloaded (eg: job change)
function user_unload()
    -- Unbinds the Reward and Correlation hotkeys.
    send_command('unbind ^f8')
    send_command('unbind !f8')
end

-- Define sets and vars used by this job file.
function init_gear_sets()
	-- add_to_chat(122,'init gear sets')
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
		food0="Akamochi",
		food1="Pet Food Alpha",
		food2="Pet Food Beta",
		food3="Pet Fd. Gamma",
		food4="Pet Food Delta",
		food5="Pet Fd. Epsilon",
		food6="Pet Food Zeta",
		food7="Pet Food Eta",
		food8="Pet Food Theta",
		call_beast_items,
		echos="Echo Drops",
		shihei="Shihei",
		orb="Macrocosmic Orb"
	}
	
	-- Idle sets
	sets.idle = {ammo="Demonry Core",
			head="Twilight Helm",neck="Twilight Torque",ear1="Ethereal Earring",ear2="Moonshade Earring",
			body="Twilight Mail",hands="Umuthi Gloves",ring1="Patricius Ring",ring2="Renaye Ring",
			back="Pastoralist's Mantle",waist="Incarnation Sash",legs="Ferine Quijotes +2",feet="Skd. Jambeaux +1"}

	-- Idle sets (default idle set not needed since the other three are defined, but leaving for testing purposes)
	sets.idle.Town = set_combine(sets.idle, {})
	sets.idle.Field = set_combine(sets.idle, {})
	sets.idle.Weak = set_combine(sets.idle, {})
    sets.idle.Pet = set_combine(sets.idle, {})
	
    sets.idle.Pet.Offensive = set_combine(sets.idle.Pet, {ammo="Demonry Core",
        head="Emicho Coronet",neck="Ferine Necklace",ear1="Ethereal Earring",ear2="Moonshade Earring",
        body="Emicho Haubert",hands="Regimen Mittens",ring1="Patricius Ring",ring2="Angel's Ring",
        back="Pastoralist's Mantle",waist="Incarnation Sash",legs="Emicho Hose",feet="Emicho Gambieras"})
    
	sets.idle.Pet.Defensive = set_combine(sets.idle.Pet.Offensive, {
		head="Anwig Salade",
		body="Emicho Haubert",hands="Ankusa Gloves +1",
		legs="Ferine Quijotes +2",feet="Ankusa Gaiters +1"})

	-- Resting sets
	sets.resting = set_combine(sets.idle, {})

	-- Engaged sets
	-- Variations for TP weapon and (optional) offense/defense modes.  Code will fall back on previous
	-- sets if more refined versions aren't defined.
	-- If you create a set with both offense and defense modes, the offense mode should be first.
	-- EG: sets.engaged.Dagger.Accuracy.Evasion

	-- Normal melee group
	sets.engaged = {ammo="Demonry Core",
			head="Valorous Mask",neck="Ferine Necklace",ear1="Bladeborn Earring",ear2="Steelflash Earring",
			body="Emicho Haubert",hands="Emicho Gauntlets",ring1="Patricius Ring",ring2="Hetairoi Ring",
			back="Pastoralist's Mantle",waist="Hurch'lan Sash",legs="Emicho Hose",feet="Valorous Greaves"}
	sets.engaged.Axe = {}
	sets.engaged.Scythe = {}
	sets.engaged.Sword = {}
	sets.engaged.Staff = {}
	sets.engaged.Club = {}
	sets.engaged.Dagger = {}
    sets.engaged.Killer = set_combine(sets.engaged, {body="Ferine Gausape +2"})
			
	-- Basic Mode definitions
	sets.Mode = {}
	sets.Mode.Acc = set_combine(sets.engaged, {
			head="Gavialis Helm",neck="Iqabi Necklace",ear1="Zennaroi Earring",ear2="Digni. Earring",
			body="Miki. Breastplate",hands="Valorous Mitts",ring1="Patricius Ring",ring2="Ulthalam's Ring",
			back="Grounded Mantle",waist="Olseni Belt",legs="Emicho Hose",feet="Valorous Greaves"})
	sets.Mode.Att= set_combine(sets.engaged, {
			head="Valorous Mask",neck="Sanctity Necklace",ear1="Bladeborn Earring",ear2="Dudgeon Earring",
			body="Rheic Korazin +3",hands="Valorous Mitts",ring1="Overbearing Ring",ring2="Cho'j Band",
			back="Phalangite Mantle",waist="Zoran's Belt",legs="Valor. Hose",feet="Valorous Greaves"})
	sets.Mode.Crit = set_combine(sets.engaged, {
			hands="Nukumi Manoplas",ring1="Hetairoi Ring"})
	sets.Mode.DA = set_combine(sets.engaged, {
			head="Otomi Helm",neck="Asperity Necklace",ear1="Bladeborn Earring",ear2="Steelflash Earring",
			body="Porthos Byrnie",ring1="Hetairoi Ring",
			back="Atheling Mantle",waist="Sarissapho. Belt",legs="Xaddi Cuisses",feet="Ferine Ocreae +2"})
	sets.Mode.Haste = set_combine(sets.engaged, {
			head="Emicho Coronet",ear1="Heartseeker Earring",ear2="Dudgeon Earring",
			body="Porthos Byrnie",hands="Regimen Mittens",
			back="Grounded Mantle",waist="Hurch'lan Sash",legs="Ferine Quijotes +2",feet="Ejekamal Boots"})
	sets.Mode.Skill = set_combine(sets.engaged, {ear1="Terminus Earring",ear2="Liminus Earring",ring2="Prouesse Ring"})
	sets.Mode.sTP = set_combine(sets.engaged, {
			head="Yaoyotl Helm",neck="Asperity Necklace",ear1="Tripudio Earring",ear2="Digni. Earring",
			ring1="Rajas Ring",ring2="K'ayres Ring",
			back="Laic Mantle",waist="Yemaya Belt",legs="Phorcys Dirs",feet="Valorous Greaves"})
	sets.Mode.STR = set_combine(sets.engaged, { ammo="Amar Cluster",
			head="Valorous Mask",neck="Lacono Neck. +1",
			body="Savas Jawshan",hands="Valorous Mitts",ring1="Rajas Ring",ring2="Apate Ring",
			back="Buquwik Cape",waist="Wanion Belt",legs="Valor. Hose",feet="Ejekamal Boots"})
			
	--Initialize Main Weapons
	sets.engaged.DW = set_combine(sets.engaged, {})
	sets.engaged.Shield = set_combine(sets.engaged, {})
	sets.engaged.Grip = set_combine(sets.engaged, {})
	-- sets.engaged.DW.Axe = set_combine(sets.engaged, {main="Kumbhakarna",sub=gear.Offhand})
	sets.engaged.DW.Axe = set_combine(sets.engaged, {main="Skullrender",sub=gear.Offhand})
	sets.engaged.Shield.Axe = set_combine(sets.engaged, {main="Kumbhakarna",sub="Viking Shield"})
	sets.engaged.DW.Club = set_combine(sets.engaged, {main="Warp Cudgel",sub=gear.Offhand})
	sets.engaged.Shield.Club = set_combine(sets.engaged, {main="Warp Cudgel",sub="Viking Shield"})
	sets.engaged.DW.Dagger = set_combine(sets.engaged, {main="Odium",sub="Kumbhakarna"})
	sets.engaged.Shield.Dagger = set_combine(sets.engaged, {main="Odium",sub="Viking Shield"})
	sets.engaged.Grip.Scythe = set_combine(sets.engaged, {main="Ark Scythe", sub="Pole Grip"})
	sets.engaged.Grip.Staff = set_combine(sets.engaged, {main="Chatoyant Staff", sub="Pole Grip"})
	sets.engaged.DW.Sword = set_combine(sets.engaged, {main="Apaisante",sub=gear.Offhand})
	sets.engaged.Shield.Sword = set_combine(sets.engaged, {main="Apaisante",sub="Viking Shield"})
	
	sets.engaged.Grip.Scythe.Acc = set_combine(sets.engaged.Grip.Scythe, sets.Mode.Acc)
	sets.engaged.Grip.Scythe.Att = set_combine(sets.engaged.Grip.Scythe, sets.Mode.Att)
	sets.engaged.Grip.Scythe.Crit = set_combine(sets.engaged.Grip.Scythe, sets.Mode.Crit)
	sets.engaged.Grip.Scythe.DA = set_combine(sets.engaged.Grip.Scythe, sets.Mode.DA)
	sets.engaged.Grip.Scythe.Haste = set_combine(sets.engaged.Grip.Scythe, sets.Mode.Haste)
	sets.engaged.Grip.Scythe.Skill = set_combine(sets.engaged.Grip.Scythe, {})
	sets.engaged.Grip.Scythe.sTP = set_combine(sets.engaged.Grip.Scythe, sets.Mode.sTP)
	sets.engaged.Grip.Scythe.STR = set_combine(sets.engaged.Grip.Scythe, sets.Mode.STR)
	
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

	sets.engaged.Grip.Staff.Acc = set_combine(sets.engaged.Grip.Staff, sets.Mode.Acc)
    --------------------------------------
    -- Precast sets
    --------------------------------------
	-- Weaponskill sets
	-- Default set for any weaponskill that isn't any more specifically defined
	sets.WSDayBonus = {head="Gavialis Helm"} 
	sets.precast.WS = set_combine(sets.Mode.STR, {neck="Fotia Gorget",body="Rheic Korazin +3",waist="Fotia Belt"})
	sets.precast.WS.Acc = set_combine(sets.precast.WS, {})
   
	-- Thunder/Wind, STR 60%
	sets.precast.WS['Raging Axe'] = set_combine(sets.precast.WS, {})
	
	-- Ice/Water, STR 100%
	sets.precast.WS['Smash Axe'] = set_combine(sets.precast.WS, {})
	
	-- Wind, STR 100%
	sets.precast.WS['Gale Axe'] = set_combine(sets.precast.WS, {})
	
	-- Earth/Thunder, STR 60%
	sets.precast.WS['Avalanche Axe'] = set_combine(sets.precast.WS, {neck="Soil Gorget",body="Rheic Korazin +3",waist="Soil Belt"})
	
	-- Earth/Thunder/Fire, STR 60%
	sets.precast.WS['Spinning Axe'] = set_combine(sets.precast.WS, {neck="Soil Gorget",body="Rheic Korazin +3",waist="Soil Belt"})
	
	-- Earth, STR 50%
	sets.precast.WS['Rampage'] = set_combine(sets.precast.WS, {neck="Soil Gorget",body="Rheic Korazin +3",waist="Soil Belt"})
	
	-- Earth/Thunder, STR 50% VIT 50%
	sets.precast.WS['Calamity'] = set_combine(sets.precast.WS, {neck="Soil Gorget",body="Rheic Korazin +3",waist="Soil Belt"})

	-- Earth/Thunder, STR 50% 
	sets.precast.WS['Mistral Axe'] = set_combine(sets.precast.WS, {neck="Soil Gorget",body="Rheic Korazin +3",waist="Soil Belt"})
	
	-- Fire/light/water, STR 50%
	sets.precast.WS['Decimation'] = set_combine(sets.precast.WS, {})
	
	-- Earth/Wind, DEX 100%
	sets.precast.WS['Bora Axe'] = set_combine(sets.precast.WS, {})
	
	-- Earth/Wind, STR 73%
	sets.precast.WS['Ruinator'] = set_combine(sets.precast.WS, {})
	
	-- Dark/Wind/Thunder, STR 40% MND 40%
	sets.precast.WS['Cloudsplitter'] = set_combine(sets.precast.WS, {})

    sets.precast.JA['Killer Instinct'] = {head="Ankusa Helm"}
    sets.precast.JA['Feral Howl'] = {body="Ankusa Jackcoat"}
    sets.precast.JA['Bestial Loyalty'] = {main="Skullrender",ammo=gear.Broth,hands="Ankusa Gloves +1"}
    sets.precast.JA['Call Beast'] = sets.precast.JA['Bestial Loyalty']
    sets.precast.JA['Familiar'] = {legs="Ankusa Trousers +1"}
    sets.precast.JA['Tame'] = {ear1="Tamer's Earring",legs="Stout Kecks"}
    sets.precast.JA['Spur'] = {feet="Ferine Ocreae +2"}

	-- reward gear then MND
    sets.precast.JA['Reward'] = {ammo=RewardFood,
        head="Khimaira Bonnet",ear1="Lifestorm Earring",ear2="Pratik Earring",
        body="Tot. Jackcoat +1",ring1="Diamond Ring",ring2="Perception Ring",
        back="Pastoralist's Mantle",legs="Ankusa Trousers +1",feet="Ankusa Gaiters +1"}

    sets.precast.JA['Charm'] = {
        head="Ankusa Helm",neck="Ferine Necklace",
        body="Totemic Jackcoat",hands="Ankusa Gloves +1",
        back="Laic Mantle",legs="Ankusa Trousers +1",feet="Ankusa Gaiters +1"}

    -- CURING WALTZ
    sets.precast.Waltz = {
        head="Gavialis Helm",neck="Ferine Necklace",
        hands="Emicho Gauntlets",ring1="Valseur's Ring",
        back="Laic Mantle",legs="Emicho Hose",feet="Scamp's Sollerets"}

    -- HEALING WALTZ
    sets.precast.Waltz['Healing Waltz'] = {}

    -- STEPS
    sets.precast.Step = set_combine(sets.Mode.Acc, {})

    -- VIOLENT FLOURISH
    sets.precast.Flourish1 = {}
    sets.precast.Flourish1['Violent Flourish'] = {body="Ankusa Jackcoat",legs="Iuitl Tights"}

    sets.precast.FC = {neck="Baetyl Pendant",legs="Limbo Trousers"}
    sets.precast.FC.Utsusemi = set_combine(sets.precast.FC, {neck="Magoraga Beads"})

    --------------------------------------
    -- Midcast sets
    --------------------------------------
    
    sets.midcast.FastRecast = {}

    sets.midcast.Utsusemi = sets.midcast.FastRecast

    -- PET SIC & READY MOVES
    sets.midcast.Pet.WS = set_combine(sets.idle.Pet.Offensive, {
        ear2="Sabong Earring",
        hands="Nukumi Manoplas",
        waist="Incarnation Sash"})

    sets.midcast.Pet.WS.Unleash = set_combine(sets.midcast.Pet.WS, {hands="Scorpion Mittens"})

    sets.midcast.Pet.Neutral = {}
    sets.midcast.Pet.Favorable = {head="Ferine Cabasset +2"}
	
	sets.midcast.Pet.ReadyRecast = {sub="Charmer's Merlin",legs="Desultor Tassets"}

    -- DEFENSE SETS
    sets.defense.PDT = {
        neck="Twilight Torque",
        body="Miki. Breastplate",hands="Umuthi Gloves",
        legs="Valorous Hose",feet="Ejekamal Boots"}

    sets.defense.Killer = set_combine(sets.defense.PDT, {body="Ferine Gausape +2"})
	
	sets.defense.Reraise = {head="Twilight Helm", body="Twilight Mail"}

    sets.defense.MDT = set_combine(sets.defense.PDT, {
        neck="Twilight Torque",
        body="Savas Jawshan",ring1="Vengeful Ring",
		feet="Ejekamal Boots"})

	sets.defense.Evasion = {ear2="Assuage Earring",feet="Ankusa Gaiters +1"}	
	
    sets.Kiting = {ammo="Demonry Core",
        neck="Twilight Torque",
        ring1="Vengeful Ring",
        waist="Hurch'lan Sash",legs="Iuitl Tights",feet="Skd. Jambeaux +1"}

    --------------------------------------
    -- Custom buff sets
    --------------------------------------

    sets.buff['Killer Instinct'] = {body="Ferine Gausape +2"}

    sets.TreasureHunter = {waist="Chaac Belt"}
end


-------------------------------------------------------------------------------------------------------------------
-- Job-specific hooks for standard casting events.
-------------------------------------------------------------------------------------------------------------------

function job_precast(spell, action, spellMap, eventArgs)
    -- Define class for Sic and Ready moves.
	-- add_to_chat(122,'job precast')
    if ready_moves_to_check:contains(spell.english) and pet.status == 'Engaged' then
        classes.CustomClass = "WS"
		equip(sets.midcast.Pet.ReadyRecast)
    end
	check_ws_dist(spell)
end

function job_post_precast(spell, action, spellMap, eventArgs)
    -- If Killer Instinct is active during WS, equip Ferine Gausape +2.
    if spell.type:lower() == 'weaponskill' and buffactive['Killer Instinct'] then
        equip(sets.buff['Killer Instinct'])
    end
	if spell.type == 'WeaponSkill' then
        if is_sc_element_today(spell) then
			-- add_to_chat(122,' WS Day ')
            equip(sets.WSDayBonus)
        end
	end 
end

function job_pet_post_midcast(spell, action, spellMap, eventArgs)
    -- Equip monster correlation gear, as appropriate
    equip(sets.midcast.Pet[state.CorrelationMode.value])
end

-------------------------------------------------------------------------------------------------------------------
-- Job-specific hooks for non-casting events.
-------------------------------------------------------------------------------------------------------------------

function job_buff_change(buff, gain)
    if buff == 'Killer Instinct' then
        handle_equipping_gear(player.status)
    end
	if player.sub_job == 'SAM' then
		handle_sam_ja()
	end
	if player.sub_job == 'WAR' then
		handle_war_ja()
	end
end

-- Called when the pet's status changes.
function job_pet_status_change(newStatus, oldStatus)
	if player.status == "Idle" then
		-- add_to_chat(122,'idle midcast')
		equip(customize_idle_set())
	end
end

-- Handle notifications of general user state change.
function job_state_change(stateField, newValue, oldValue)
	-- add_to_chat(122,"changing state  "..stateField)
    if stateField == 'Reward Mode' then
		if newValue == 'Epsilon' or newValue == 'Gamma' then
			RewardFood.name = "Pet Fd. " .. newValue
		else
			RewardFood.name = "Pet Food " .. newValue
		end
    elseif stateField == 'Weapon Mode' then
		if newValue ~= 'Normal' then
			state.CombatWeapon:set(newValue)
		else
			state.CombatWeapon:reset()
		end
	elseif stateField == 'Sub Mode' then
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
function job_self_command(cmdParams, eventArgs)
	-- add_to_chat(122,'self command')
	handle_flags(cmdParams, eventArgs)
    if cmdParams[1]:lower() == 'callbeast' then
        handle_callbeast(cmdParams)
        eventArgs.handled = true
    end
end

function get_custom_wsmode(spell, spellMap, defaut_wsmode)
    
end

-- Called by the 'update' self-command, for common needs.
-- Set eventArgs.handled to true if we don't want automatic equipping of gear.
function job_update(cmdParams, eventArgs)
	-- add_to_chat(122,'job update')
	select_offhand()
	pick_tp_weapon()
end


-- Set eventArgs.handled to true if we don't want the automatic display to be run.
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

    msg = msg .. ', Reward: '..state.RewardMode.value..', Correlation: '..state.CorrelationMode.value

    add_to_chat(122, msg)

    eventArgs.handled = true
end


-------------------------------------------------------------------------------------------------------------------
-- Utility functions specific to this job.
-------------------------------------------------------------------------------------------------------------------

function job_handle_equipping_gear(status, eventArgs)
	-- add_to_chat(122,'handle equiping gear')
	check_tp_lock()
	set_combat_form()
	pick_tp_weapon()
	select_offhand()
	handle_twilight()
end

function select_offhand()
	if state.Stance.value == 'Defensive' then
		-- add_to_chat(122,'bigD')
		gear.Offhand.name = "Astolfo"
	else 
		-- add_to_chat(122,'notD')
		gear.Offhand.name = "Arktoi"
	end
	-- add_to_chat(123,'shuld use'..gear.Offhand.name)
end

function customize_idle_set(idleSet)
	-- add_to_chat(122,'cust idle')
    if pet.isvalid then
		-- add_to_chat(122,'pet valid')
        if pet.status == 'Engaged' then
			-- add_to_chat(122,'pet engaged')
			if state.Stance.value == 'Defensive' then
				-- add_to_chat(122,'petD')
				idleSet = set_combine(idleSet, sets.idle.Pet.Defensive)
			else
				-- add_to_chat(122,'petOffense')
				idleSet = set_combine(idleSet, sets.idle.Pet.Offensive)
			end
        end
    end
  
    return idleSet
end

function handle_callbeast(cmdParams)
	-- add_to_chat(1,'Loyalty '..state.loyalty.value)
 	if not cmdParams[2] then
        add_to_chat(123,'Error: No Pet command given.')
        return
    end
    local petcall = cmdParams[2]
	-- add_to_chat(2,'petcall '..petcall)
	if call_beast_items[petcall] ~= nil then
		gear.Broth.name = call_beast_items[petcall]
		-- add_to_chat(3,'broth '..gear.Broth.name)
		if state.loyalty.value == 'true' then
			send_command('input /ja "Bestial Loyalty" <me>')
			add_to_chat(2,'Loyalty on, type //loyalty to turn off and consume jugs')
		else
			send_command('input /ja "Call Beast" <me>')
		end
	else
		add_to_chat(123,'Unknown Pet:'..petcall)
	end
end

-- Select default macro book on initial load or subjob change.
function select_default_macro_book()
	-- Default macro set/book
	if player.sub_job == 'DNC' then
		set_macro_page(1, 15)
	elseif player.sub_job == 'WAR' then
		set_macro_page(2, 15)
	elseif player.sub_job == 'NIN' then
		set_macro_page(1, 15)
	else
		set_macro_page(1, 15)
	end
	send_command('exec bst.txt')
end

