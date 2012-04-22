package
{
	import flash.text.ime.CompositionAttributeRange;
	import org.flixel.*;

	public class LevMain extends Level
	{
		[Embed(source = "../assets/lev_main_fg.png")] private var GfxFg:Class;
		[Embed(source = "../assets/lev_main_sunlight.png")] private var GfxSunlight:Class;
		[Embed(source = "../assets/lev_main_ventcover.png")] private var GfxVentCover:Class;
		[Embed(source = "../assets/lev_main_cat.png")] private var GfxCat:Class;
		[Embed(source = "../assets/lev_main_fan.png")] private var GfxFan:Class;
		[Embed(source = "../assets/lev_main_litter.png")] private var GfxLitter:Class;
		[Embed(source = "../assets/lev_main_pill.png")] private var GfxPill:Class;
		[Embed(source = "../assets/lev_main_window.png")] private var GfxWindow:Class;
		[Embed(source = "../assets/lev_main_empty_bed.png")] private var GfxEmptyBed:Class;
		[Embed(source = "../assets/lev_main_used_glass.png")] private var GfxUsedGlass:Class;
		[Embed(source = "../assets/lev_main_opened_bathroom_door.png")] private var GfxOpenedBathroomDoor:Class;
		[Embed(source = "../assets/after_a_while.png")] private var GfxAfterAWhile:Class;

		private var _fg:FlxSprite;
		private var _sunlight:FlxSprite;
		private var _ventcover:FlxSprite;
		private var _cat:FlxSprite;
		private var _catAnimation:CatAnimation;
		private var _fan:FlxSprite;
		private var _litter:FlxSprite;
		private var _pill:FlxSprite;
		private var _window:FlxSprite;
		private var _emptyBed:FlxSprite;
		private var _humanFighter:HumanFighter;
		private var _humanAnimation:HumanAnimation;
		private var _usedGlass:FlxSprite;
		private var _openedBathroomDoor:FlxSprite;
		private var _afterAWhile:FlxSprite;

		private var _time:Number = 0;
		private var _fanIsOn:Boolean = true;
		private var _catAwakened:Boolean = false;
		private var _giftDropped:Boolean = false;
		private var _lockHumanHeadLevel:Boolean = false;
		private var _lockBedside:Boolean = false;
		private var _ventcoverOnWall:Boolean = true;
		private var _disableAllEntries:Boolean = false;
		private var _fighting:Boolean = false;
		private var _windowIsOpened:Boolean = false;
		private var _winRect:FlxRect = new FlxRect(302, 81, 18, 75);
		private var _afterAWhileTime:Number = 0;

		public function LevMain():void
		{
			super(Levels.MAIN);

			_fg = new FlxSprite(0, 0, GfxFg);
			add(_fg);

			_emptyBed = new FlxSprite(7, 122, GfxEmptyBed);
			_emptyBed.visible = false;
			add(_emptyBed);

			_ventcover = new FlxSprite(37, 32, GfxVentCover);
			_ventcover.origin.make(0, 0);
			add(_ventcover);

			_litter = new FlxSprite(260, 214);
			_litter.loadGraphic(GfxLitter, true, false, 35, 25);
			_litter.addAnimation("clean", [0], 1, true);
			_litter.addAnimation("dirty", [1], 1, true);
			_litter.play("clean");
			add(_litter);

			_cat = new FlxSprite(89, 196);
			_cat.loadGraphic(GfxCat, true, true, 54, 42);
			_cat.addAnimation("sleeping", [0], 1, true);
			_cat.addAnimation("gotolitterbox", [0], 1, false);
			_cat.play("sleeping");
			add(_cat);

			_fan = new FlxSprite(117, 1);
			_fan.loadGraphic(GfxFan, true, false, 86, 38);
			_fan.addAnimation("movement", [0, 1, 2], 12, true);
			_fan.addAnimation("off", [1], 1, true);
			_fan.play("movement");
			add(_fan);

			_pill = new FlxSprite(118, 155, GfxPill);
			add(_pill);

			_window = new FlxSprite(299, 51);
			_window.loadGraphic(GfxWindow, true, false, 21, 108);
			_window.addAnimation("closed", [0], 1, true);
			_window.addAnimation("opening", [0, 1, 2, 2], 6, false);
			_window.addAnimation("opened", [2], 1, true);
			_window.play("closed");
			add(_window);

			_sunlight = new FlxSprite(0, 0, GfxSunlight);
			add(_sunlight);

			_usedGlass = new FlxSprite(102, 138, GfxUsedGlass);
			_openedBathroomDoor = new FlxSprite(201, 68, GfxOpenedBathroomDoor);

			setFgSprite(_fg);
		}

		override public function update():void
		{
			super.update();

			_time += FlxG.elapsed;

			if (_ventcoverOnWall) {
				_ventcover.angle = 45 + 4 * Math.sin(2 * Math.PI * (_time % 2));
			}
			else if (_ventcover.y > 140) {
				_ventcover.y = 140;
				_ventcover.angularAcceleration = 0;
				_ventcover.angularVelocity = 0;
				_ventcover.acceleration.make(0, 0);
				_ventcover.velocity.make(0, 0);
			}

			if (_afterAWhile != null && (_time - _afterAWhileTime) > 1) {
				remove(_afterAWhile);
				_afterAWhile = null;
			}
		}

		override public function initPlayerPosition(player:Player, fromLevel:Level):void
		{
			var oldRect:FlxRect = (fromLevel ? new FlxRect(0, 0, fromLevel.fgSprite.width, fromLevel.fgSprite.height): null);
			var oldX:Number = player.getSprite().x;
			var oldY:Number = player.getSprite().y;

			super.initPlayerPosition(player, fromLevel);

			player.setLook(Player.FAR_LOOK);
			var playerSprite:FlxSprite = player.getSprite();

			if (fromLevel) {
				var entryRect:FlxRect = Levels.ENTRY_RECT[fromLevel.num];
				playerSprite.x = entryRect.x + entryRect.width * (oldX - oldRect.x) / oldRect.width;
				playerSprite.y = entryRect.y + entryRect.height * (oldY - oldRect.y) / oldRect.height;
				Utils.moveSpriteOutside(player.getSprite(), entryRect);

				if (fromLevel.num == Levels.CAT) {
					if (_catAwakened) {
						startCatAni();
					}
				}
			}
			else {
				// Only for testing, because the main level is not the first level.
				playerSprite.x = FlxG.width/2;
				playerSprite.y = FlxG.height/2;
			}

			FlxG.camera.zoom = 2.0;
		}

		override public function controlInteractionsWithPlayer(player:Player):void
		{
			var playerSprite:FlxSprite = player.getSprite();

			// Fan turbulence
			if (_fanIsOn) {
				if (playerSprite.x < _fg.width - 100) {
					if (playerSprite.y < 80) {
						var f:Number = 1 - (playerSprite.y / 80);
						playerSprite.velocity.x += 8 - 8 * ((1-f) + f*Math.random());
						playerSprite.velocity.y += 4 * ((1-f) + f*Math.random());
					}
				}
			}

			// When the player is fighting
			if (_fighting) {
				if (playerSprite.y > 90 && playerSprite.x < 200) {
					playerSprite.y = 90;
					if (playerSprite.velocity.y > 0) {
						playerSprite.velocity.y = -playerSprite.velocity.y;
					}
				}

				// If the player win
				if (_windowIsOpened && _winRect.overlaps(player.bounds)) {
					FlxG.switchState(new WinState());
				}
			}

			// Enter to some sublevel...
			for (var num:int = Levels.FIRST_ENTRY; num <= Levels.LAST_ENTRY; ++num) {
				if (Levels.ENTRY_RECT[num].overlaps(player.bounds)) {
					var preconditions:Boolean = (!_disableAllEntries);

					switch (num) {
						case Levels.VENTCOVER:
							// If the fan is on, we cannot access to "ventcover" level.
							if (_fanIsOn)
								preconditions = false;
							break;
						case Levels.CAT:
							// We cannot enter to the "cat" area if the cat was awakened.
							if (_catAwakened)
								preconditions = false;
							break;
						case Levels.BEDSIDETABLE:
							if (_lockBedside)
								preconditions = false;
							break;
						case Levels.HUMANHEAD:
							if (_lockHumanHeadLevel)
								preconditions = false;
							break;
					}

					if (preconditions) {
						switchLevel(num);
						return;
					}
				}
			}

			super.controlInteractionsWithPlayer(player);
		}

		public function startCatAniOnEnter():void
		{
			_catAwakened = true;
		}

		private function startCatAni():void
		{
			remove(_cat);
			_catAnimation = new CatAnimation();
			_catAnimation.x = 90;
			_catAnimation.y = 170;
			add(_catAnimation);
		}

		public function addTheGift():void
		{
			_litter.play("dirty");
		}

		public function dropGift():void
		{
			_giftDropped = true;
		}

		public function wakeupHuman():void
		{
			_lockHumanHeadLevel = true;
			_lockBedside = true;

			remove(_sunlight); // quick & dirty fix
			remove(_pill);

			_humanAnimation = new HumanAnimation();
			_humanAnimation.x = 34;
			_humanAnimation.y = 125;
			add(_humanAnimation);

			add(_sunlight); // quick & dirty fix
		}

		public function gotoBathroom():void
		{
			remove(_humanAnimation);

			add(_usedGlass);
			add(_openedBathroomDoor);

			_afterAWhile = new FlxSprite(0, 0, GfxAfterAWhile);
			_afterAWhileTime = _time;
			add(_afterAWhile);

			_fanIsOn = false;
			_fan.play("off");
		}

		public function dropVentCoverToHuman():void
		{
			_disableAllEntries = true;
			_fighting = true;
			_ventcover.y += 32;
			_ventcover.angularAcceleration = 10;
			_ventcover.acceleration.y = 200;
			_ventcoverOnWall = false;
			//_ventcover.followPath(new FlxPath([new FlxPoint()]));
			//remove(_ventcover);
			_emptyBed.visible = true;

			_humanFighter = new HumanFighter();
			_humanFighter.x = 103;
			_humanFighter.y = 73;
			add(_humanFighter);

			// TODO play animation
		}

		public function openWindow():void
		{
			_window.addAnimationCallback(controlOpenWindow);
			_window.play("opening");
		}

		private function controlOpenWindow(ani:String, frame:int, index:int):void
		{
			if (ani == "opening" && frame >= 3) {
				_windowIsOpened = true;
				_window.play("opened");
			}
		}

	}
}
