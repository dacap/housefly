package
{
	import flash.text.ime.CompositionAttributeRange;
	import org.flixel.*;

	public class LevCat extends LevelCloseLook
	{
		[Embed(source = "../assets/lev_cat_fg.png")] private var GfxFg:Class;
		[Embed(source = "../assets/lev_cat_right_ear.png")] private var GfxRightEar:Class;
		[Embed(source = "../assets/lev_cat_left_ear.png")] private var GfxLeftEar:Class;
		[Embed(source = "../assets/lev_cat_eyes.png")] private var GfxEyes:Class;

		private static const ELAPSED_TIME_TO_LISTEN:Number = 2;

		private var _fg:FlxSprite;
		private var _rightEar:FlxSprite;
		private var _leftEar:FlxSprite;
		private var _eyes:FlxSprite;
		private var _leftNoiseElapsed:Number = 0;
		private var _rightNoiseElapsed:Number = 0;

		public function LevCat():void
		{
			super(Levels.CAT);

			_fg = new FlxSprite(0, 0, GfxFg);
			add(_fg);
			setFgSprite(_fg);

			_rightEar = new FlxSprite(91, 95);
			_rightEar.loadGraphic(GfxRightEar, true, false, 99, 90);
			_rightEar.addAnimation("quiet", [0], 1, false);
			_rightEar.addAnimation("movement", [1, 0, 0, 0, 0, 1, 0, 0], 10, false);
			_rightEar.addAnimation("listen", [1], 1, false);
			_rightEar.play("quiet");
			add(_rightEar);

			_leftEar = new FlxSprite(242, 109);
			_leftEar.loadGraphic(GfxLeftEar, true, false, 65, 67);
			_leftEar.addAnimation("quiet", [0], 1, false);
			_leftEar.addAnimation("movement", [1, 0, 0, 0, 0, 1, 0, 1, 0, 0], 10, false);
			_leftEar.addAnimation("listen", [1], 1, false);
			_leftEar.play("quiet");
			add(_leftEar);

			_eyes = new FlxSprite(158, 190);
			_eyes.loadGraphic(GfxEyes, true, false, 105, 18);
			_eyes.addAnimation("movement", [0, 1, 0, 1, 0, 1, 2, 1, 2, 2], 4, false);
			_eyes.addAnimationCallback(eyesCallback);
		}

		private function eyesCallback(anim:String, frame:uint, index:uint):void
		{
			if (frame >= 9) {
				// Go back to main level (and start the cat animation). From now this level
				// will be completelly destroyed and cannot be accessed again.
				switchLevel(Levels.MAIN);
			}
		}

		override public function update():void
		{
			super.update();

			if (_rightNoiseElapsed >= ELAPSED_TIME_TO_LISTEN &&
				_leftNoiseElapsed >= ELAPSED_TIME_TO_LISTEN) {
				// Start the cat animation when the player goes back
				// to the main level (or the cat eyes animation ends).
				(FlxG.state as PlayState).getMainLevel().startCatAniOnEnter();

				// Show eyes
				_eyes.play("movement");
				add(_eyes);
			}
		}

		override public function controlInteractionsWithPlayer(player:Player):void
		{
			var playerSprite:FlxSprite = player.getSprite();

			// The fly is going to MAIN level.
			if (playerSprite.x < 0 || playerSprite.y < 0 ||
				playerSprite.x + playerSprite.width >= _fg.width) {

				switchLevel(Levels.MAIN);
				return;
			}

			// When the fly is in the right ear
			if (playerSprite.overlaps(_rightEar)) {
				_rightNoiseElapsed += FlxG.elapsed;
				if (_rightNoiseElapsed >= ELAPSED_TIME_TO_LISTEN)
					_rightEar.play("listen");
				else
					_rightEar.play("movement");
			}
			else if (_rightNoiseElapsed < ELAPSED_TIME_TO_LISTEN) {
				_rightEar.play("quiet");
			}

			if (playerSprite.overlaps(_leftEar)) {
				_leftNoiseElapsed += FlxG.elapsed;
				if (_leftNoiseElapsed >= ELAPSED_TIME_TO_LISTEN)
					_leftEar.play("listen");
				else
					_leftEar.play("movement");
			}
			else if (_leftNoiseElapsed < ELAPSED_TIME_TO_LISTEN) {
				_leftEar.play("quiet");
			}

			super.controlInteractionsWithPlayer(player);
		}

	}
}
