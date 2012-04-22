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

		private var _fg:FlxSprite;
		private var _sunlight:FlxSprite;
		private var _ventcover:FlxSprite;
		private var _cat:FlxSprite;
		private var _fan:FlxSprite;
		private var _fanIsOn:Boolean;

		private var _catAwakened:Boolean = false;

		public function LevMain():void
		{
			super(Levels.MAIN);

			_fg = new FlxSprite(0, 0, GfxFg);
			add(_fg);

			_sunlight = new FlxSprite(0, 0, GfxSunlight);
			add(_sunlight);

			_ventcover = new FlxSprite(33, 30);
			_ventcover.loadGraphic(GfxVentCover, true, false, 24, 24);
			_ventcover.addAnimation("movement", [0, 1, 2, 1], 4, true);
			_ventcover.play("movement", true);
			add(_ventcover);

			_cat = new FlxSprite(89, 196);
			_cat.loadGraphic(GfxCat, true, true, 54, 42);
			_cat.addAnimation("sleeping", [0], 1, true);
			_cat.addAnimation("gotolitterbox", [0], 1, false);
			_cat.play("sleeping");
			add(_cat);

			_fan = new FlxSprite(117, 1);
			_fan.loadGraphic(GfxFan, true, false, 86, 38);
			_fan.addAnimation("movement", [0, 1, 2], 12, true);
			_fan.play("movement");
			_fanIsOn = true;
			add(_fan);

			setFgSprite(_fg);
		}

		override public function update():void
		{
			super.update();
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

			for (var num:int = Levels.FIRST_ENTRY; num <= Levels.LAST_ENTRY; ++num) {
				// We cannot enter to the "cat" area if the cat was awakened.
				if (num == Levels.CAT) {
					if (_catAwakened)
						continue;
				}

				if (Levels.ENTRY_RECT[num].overlaps(player.bounds)) {
					switchLevel(num);
					return;
				}
			}

			super.controlInteractionsWithPlayer(player);
		}

		public function startCatAni():void
		{
			_catAwakened = true;
			_cat.play("gotolitterbox");
		}

	}
}
