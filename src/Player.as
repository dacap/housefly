package
{
	import org.flixel.*;

	public class Player extends FlxGroup
	{
		[Embed(source = "../assets/fly.png")] private var GfxFly:Class;
		[Embed(source = "../assets/fly_on_gift.png")] private var GfxOnGift:Class;
		[Embed(source = "../assets/fly_weight.png")] private var GfxWeight:Class;
		[Embed(source = "../assets/fly.mp3")] private var SndFly:Class;

		public static const CLOSE_LOOK:int = 0;
		public static const FAR_LOOK:int = 1;

		private static const STATE_FLYING:int = 0;
		private static const STATE_ONGIFT:int = 1;

		private var _state:int = STATE_FLYING;
		private var _curLook:int;
		private var _sprite:FlxSprite;
		private var _flySprite:FlxSprite;
		private var _flyOnGift:FlxSprite;
		private var _flyPixel:FlxSprite;
		private var _flyWeight:FlxSprite;
		private var _flySound:FlxSound;
		private var _curLevel:Level;
		private var _rect:FlxRect;
		private var _velFactor:Number;
		private var _withWeight:Boolean = false;
		private var _lockStandOnGift:Boolean = false;

		public function Player():void
		{
			_flySound = new FlxSound();
			_flySound.loadEmbedded(SndFly, true, false);
			_flySound.volume = 0.5;
			
			_flySprite = new FlxSprite();
			_flySprite.loadGraphic(GfxFly, true, true, 14, 14);
			_flySprite.addAnimation("fly", [0, 1], 30, true);
			_flySprite.play("fly", true);
			_flySprite.maxVelocity.make(256, 256);

			_flyOnGift = new FlxSprite(252, 183);
			_flyOnGift.loadGraphic(GfxOnGift, true, true, 15, 15);
			_flyOnGift.addAnimation("ani", [0, 0, 1, 2, 1, 2, 1, 2, 1, 2, 1, 0, 0], 5, true);

			_flyPixel = new FlxSprite();
			_flyPixel.makeGraphic(2, 2, 0xff000000);
			_flyPixel.maxVelocity.make(256, 256);

			_flyWeight = new FlxSprite(3, 10, GfxWeight);

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
					_flySound.play();
					_velFactor = 1;

					_flySprite.velocity.x = _flyPixel.velocity.x * 4;
					_flySprite.velocity.y = _flyPixel.velocity.y * 4;
					_flySprite.acceleration.x = _flyPixel.acceleration.x * 4;
					_flySprite.acceleration.y = _flyPixel.acceleration.y * 4;

					add(_sprite = _flySprite);
					if (_withWeight) {
						add(_flyWeight);
					}
					else {
						remove(_flyWeight);
					}
					remove(_flyPixel);
					break;

				case Player.FAR_LOOK:
					_flySound.stop();
					_velFactor = 0.5;

					_flyPixel.velocity.x = _flySprite.velocity.x / 4;
					_flyPixel.velocity.y = _flySprite.velocity.y / 4;
					_flyPixel.acceleration.x = _flySprite.acceleration.x / 4;
					_flyPixel.acceleration.y = _flySprite.acceleration.y / 4;

					remove(_flySprite);
					remove(_flyWeight);
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
			if (FlxG.keys.LEFT && _state == STATE_FLYING)  {
				_flySprite.facing = FlxObject.LEFT;

				if (_sprite.velocity.x > 0)
					_sprite.acceleration.x = -256*_velFactor;
				else
					_sprite.acceleration.x = -128*_velFactor;
			}
			else if (FlxG.keys.RIGHT && _state == STATE_FLYING) {
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

			if (FlxG.keys.UP && _state == STATE_FLYING)  {
				if (_sprite.velocity.y > 0)
					_sprite.acceleration.y = -256*_velFactor;
				else
					_sprite.acceleration.y = -128*_velFactor;
			}
			else if (FlxG.keys.DOWN && _state == STATE_FLYING) {
				if (_sprite.velocity.y < 0)
					_sprite.acceleration.y = +256*_velFactor;
				else
					_sprite.acceleration.y = +128*_velFactor;
			}
			else {
				_sprite.velocity.y /= 1 + FlxG.elapsed/_velFactor;
				_sprite.acceleration.y = 0;
			}

			// Update the position of the "weight" that we are carrying
			if (_withWeight) {
				_flyWeight.x = _flySprite.x + (_flySprite.facing == FlxObject.RIGHT ? 3: 6);
				_flyWeight.y = _flySprite.y + 10;
			}

			// Call base impl.
			super.update();

			// Limit position inside the level bounds.
			_curLevel.controlInteractionsWithPlayer(this);
		}

		public function standOnGift():void
		{
			if (_lockStandOnGift)
				return;

			_state = STATE_ONGIFT;

			remove(_flySprite);

			_flyOnGift.addAnimationCallback(controlOnGiftAnimation);
			_flyOnGift.play("ani");
			add(_flyOnGift);
		}

		private function controlOnGiftAnimation(ani:String, frame:int, index:int):void
		{
			if (frame >= 12)
			{
				_lockStandOnGift = true; // The fly cannot stand two times

				// Restore "flying" state
				_state = STATE_FLYING;
				_flySprite.x = 255;
				_flySprite.y = 182;
				remove(_flyOnGift);
				add(_flySprite);

				_withWeight = true;      // Now we are carrying a little of sh!t
				add(_flyWeight);
			}
		}

		public function get hasWeight():Boolean
		{
			return _withWeight;
		}

		public function dropGift():void
		{
			_withWeight = false;
			remove(_flyWeight);
		}

	}
}
