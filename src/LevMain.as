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

		private var _levGlassEntry:FlxRect;
		private var _levCatEntry:FlxRect;

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

			_levGlassEntry = new FlxRect(273, 34, 47, 108);
			_levCatEntry = new FlxRect(93, 210, 34, 26);

			setFgSprite(_fg);
		}

		public function get levGlassEntry():FlxRect
		{
			return _levGlassEntry;
		}

		public function get levCatEntry():FlxRect
		{
			return _levCatEntry;
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

			switch (fromLevel ? fromLevel.num: Levels.NONE) {
				case Levels.NONE:
					// Only for testing, because the main level is not the first level.
					playerSprite.x = FlxG.width/2;
					playerSprite.y = FlxG.height/2;
					break;

				case Levels.GLASS:
					playerSprite.x = _levGlassEntry.x + _levGlassEntry.width * (oldX - oldRect.x) / oldRect.width;
					playerSprite.y = _levGlassEntry.y + _levGlassEntry.height * (oldY - oldRect.y) / oldRect.height;
					Utils.moveSpriteOutside(player.getSprite(), _levGlassEntry);
					break;

				case Levels.CAT:
					playerSprite.x = _levCatEntry.x + _levCatEntry.width * (oldX - oldRect.x) / oldRect.width;
					playerSprite.y = _levCatEntry.y + _levCatEntry.height * (oldY - oldRect.y) / oldRect.height;
					Utils.moveSpriteOutside(playerSprite, _levCatEntry);
					break;
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

			// Enter to "glass" level
			var dist:Number = FlxU.getDistance(new FlxPoint(playerSprite.x, playerSprite.y),
											   new FlxPoint(_levGlassEntry.x + _levGlassEntry.width/2,
															_levGlassEntry.y + _levGlassEntry.height/2));
			if (_levGlassEntry.overlaps(player.bounds)) {
				switchLevel(Levels.GLASS);
				return;
			}
			else if (dist < _levGlassEntry.width*2) {
				//FlxG.camera.zoom = 2.0 + 0.5 * (1 - (dist / (_levGlassEntry.width*2)));
			}
			else {
				//FlxG.camera.zoom = 2.0;
			}

			// Enter to "cat" level (only if the cat wasn't awakened)
			if (!_catAwakened)
			{
				dist = FlxU.getDistance(new FlxPoint(playerSprite.x, playerSprite.y),
										new FlxPoint(_levCatEntry.x + _levCatEntry.width/2,
													 _levCatEntry.y + _levCatEntry.height/2));
				if (_levCatEntry.overlaps(player.bounds)) {
					switchLevel(Levels.CAT);
					return;
				}
				else if (dist < _levCatEntry.height*2) {
					//FlxG.camera.zoom = 2.0 + 0.5 * (1 - (dist / (_levCatEntry.height * 2)));
				}
				else {
					//FlxG.camera.zoom = 2.0;
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
