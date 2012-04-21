package
{
	import org.flixel.*;

	public class Player extends FlxGroup
	{
		[Embed(source = "../assets/fly.png")] private var GfxFly:Class;

		public static const CLOSE_LOOK:int = 0;
		public static const FAR_LOOK:int = 1;

		private var _curLook:int;
		private var _sprite:FlxSprite;
		private var _flySprite:FlxSprite;
		private var _flyPixel:FlxSprite;
		private var _curLevel:Level;
		private var _rect:FlxRect;
		private var _velFactor:Number;

		public function Player():void
		{
			_flySprite = new FlxSprite();
		    _flySprite.loadGraphic(GfxFly, true, true, 14, 14);
			_flySprite.addAnimation("fly", [0, 1], 30, true);
			_flySprite.play("fly", true);
			_flySprite.maxVelocity.make(256, 256);

			_flyPixel = new FlxSprite();
			_flyPixel.makeGraphic(2, 2, 0xff000000);
			_flyPixel.maxVelocity.make(256, 256);

			_rect = new FlxRect();

			setLook(Player.CLOSE_LOOK);
		}

		public function get bounds():FlxRect
		{
			return _rect.make(_sprite.x, _sprite.y, _sprite.width, _sprite.height);
		}

		public function setLook(look:int):void
		{
			_curLook = look;

			switch (look) {

				case Player.CLOSE_LOOK:
					_velFactor = 1;

					_flySprite.velocity.x = _flyPixel.velocity.x * 4;
					_flySprite.velocity.y = _flyPixel.velocity.y * 4;
					_flySprite.acceleration.x = _flyPixel.acceleration.x * 4;
					_flySprite.acceleration.y = _flyPixel.acceleration.y * 4;

					add(_sprite = _flySprite);
					remove(_flyPixel);
					break;

				case Player.FAR_LOOK:
					_velFactor = 0.5;

					_flyPixel.velocity.x = _flySprite.velocity.x / 4;
					_flyPixel.velocity.y = _flySprite.velocity.y / 4;
					_flyPixel.acceleration.x = _flySprite.acceleration.x / 4;
					_flyPixel.acceleration.y = _flySprite.acceleration.y / 4;

					remove(_flySprite);
					add(_sprite = _flyPixel);
					break;
			}
		}

		public function getSprite():FlxSprite
		{
			return _sprite;
		}

		public function setCurrentLevel(level:Level):void
		{
			var fromLevel:Level = _curLevel;

			_curLevel = level;
			_curLevel.initPlayerPosition(this, fromLevel);
			_curLevel.setupCameraForPlayer(this);
		}

		override public function update():void
		{
			if (FlxG.keys.LEFT)  {
				_flySprite.facing = FlxObject.LEFT;

				if (_sprite.velocity.x > 0)
					_sprite.acceleration.x = -256*_velFactor;
				else
					_sprite.acceleration.x = -128*_velFactor;
			}
			else if (FlxG.keys.RIGHT) {
				_flySprite.facing = FlxObject.RIGHT;

				if (_sprite.velocity.x < 0)
					_sprite.acceleration.x = +256*_velFactor;
				else
					_sprite.acceleration.x = +128*_velFactor;
			}
			else {
				// Slow down
				_sprite.velocity.x /= 1 + FlxG.elapsed/_velFactor;
				_sprite.acceleration.x = 0;
			}

			if (FlxG.keys.UP)  {
				if (_sprite.velocity.y > 0)
					_sprite.acceleration.y = -256*_velFactor;
				else
					_sprite.acceleration.y = -128*_velFactor;
			}
			else if (FlxG.keys.DOWN) {
				if (_sprite.velocity.y < 0)
					_sprite.acceleration.y = +256*_velFactor;
				else
					_sprite.acceleration.y = +128*_velFactor;
			}
			else {
				_sprite.velocity.y /= 1 + FlxG.elapsed/_velFactor;
				_sprite.acceleration.y = 0;
			}

			// Call base impl.
			super.update();

			// Limit position inside the level bounds.
			_curLevel.controlInteractionsWithPlayer(this);
		}

	}
}
