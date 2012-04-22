package
{
	import flash.text.ime.CompositionAttributeRange;
	import org.flixel.*;

	public class LevVentcover extends LevelCloseLook
	{
		[Embed(source = "../assets/lev_ventcover_fg.png")] private var GfxFg:Class;
		[Embed(source = "../assets/lev_ventcover_cover.png")] private var GfxCover:Class;
		[Embed(source = "../assets/lev_ventcover_screw.png")] private var GfxScrew:Class;

		private var _fg:FlxSprite;
		private var _cover:FlxSprite;
		private var _screw:FlxSprite;
		private var _screwHits:int = 0;
		private var _screwCanHit:Boolean = true;
		private var _screwHitTime:Number = 0;
		private var _time:Number = 0;

		public function LevVentcover():void
		{
			super(Levels.VENTCOVER);

			_fg = new FlxSprite(0, 0, GfxFg);
			add(_fg);

			_cover = new FlxSprite(123, 97, GfxCover);
			_cover.origin.make(11, 9);
			_cover.angle = 45;
			add(_cover);

			_screw = new FlxSprite(126, 99, GfxScrew);
			add(_screw);

			setFgSprite(_fg);
		}

		override public function update():void
		{
			super.update();

			_time += FlxG.elapsed;

			if (_cover.acceleration.y == 0) {
				_cover.angle = 45 + 4 * Math.sin(2 * Math.PI * (_time % 2));
			}

			if (_screwHits < 3 && !_screwCanHit && (_time - _screwHitTime) > 1) {
				_screwCanHit = true;
				_screw.visible = true;
			}

			if (_cover.y > _fg.height) {
				(FlxG.state as PlayState).mainLevel.dropVentCoverToHuman();
				switchLevel(Levels.MAIN);
			}
		}

		override public function draw():void
		{
			if (!_screwCanHit) {
				_screw.visible = !_screw.visible;
			}

			super.draw();
		}

		override public function controlInteractionsWithPlayer(player:Player):void
		{
			var playerSprite:FlxSprite = player.getSprite();

			// The fly is going to MAIN level.
			if (playerSprite.x < 0 || playerSprite.y < 0 ||
				playerSprite.x + playerSprite.width >= _fg.width ||
				playerSprite.y + playerSprite.height >= _fg.height) {
				switchLevel(Levels.MAIN);
				return;
			}

			if (_screwCanHit && _screw.overlaps(playerSprite)) {
				_screw.x--;
				_screw.y--;
				_screwHits++;
				_screwCanHit = false;
				_screwHitTime = _time;

				playerSprite.velocity.x = (64 + 32*Math.random()) * (Math.random()>0.5?1:-1);
				playerSprite.velocity.y = (64 + 32*Math.random()) * (Math.random()>0.5?1:-1);
				playerSprite.acceleration.x = 0;
				playerSprite.acceleration.y = 0;

				FlxG.camera.shake(0.01, 0.2);

				if (_screwHits == 3) {
					_screw.acceleration.y = 300;
					_cover.acceleration.y = 200;
					_cover.angularAcceleration = _cover.angle;
				}
			}

			super.controlInteractionsWithPlayer(player);
		}

	}
}
