package
{
	import flash.text.ime.CompositionAttributeRange;
	import org.flixel.*;

	public class LevHumanhead extends LevelCloseLook
	{
		[Embed(source = "../assets/lev_humanhead_fg.png")] private var GfxFg:Class;
		[Embed(source = "../assets/lev_humanhead_eyes.png")] private var GfxEyes:Class;
		[Embed(source = "../assets/lev_humanhead_mouth.png")] private var GfxMouth:Class;

		private var _fg:FlxSprite;
		private var _eyes:FlxSprite;
		private var _mouth:FlxSprite;
		private var _annoyingRect:FlxRect = new FlxRect(223, 165, 59, 64);
		private var _annoyingTime:Number = 0;

		public function LevHumanhead():void
		{
			super(Levels.HUMANHEAD);

			_fg = new FlxSprite(0, 0, GfxFg);
			add(_fg);

			_eyes = new FlxSprite(322, 209);
			_eyes.loadGraphic(GfxEyes, true, false, 74, 51);
			_eyes.addAnimation("quiet", [0], 1, false);
			_eyes.addAnimation("movement", [0, 1, 0, 1, 0, 1, 2, 1, 2, 2, 1, 2, 2, 2], 3, false);
			_eyes.play("quiet");
			add(_eyes);

			_mouth = new FlxSprite(314, 265);
			_mouth.loadGraphic(GfxMouth, true, false, 29, 26);
			_mouth.addAnimation("quiet", [0], 1, false);
			_mouth.addAnimation("movement",[0, 0, 1, 0, 1, 0, 0, 1, 2, 2, 0, 1, 2, 2], 2, false);
			_mouth.play("quiet");
			add(_mouth);

			setFgSprite(_fg);
		}

		override public function update():void
		{
			super.update();

			if (_annoyingTime > 2.0) {
				(FlxG.state as PlayState).bedsidetableLevel.takePill();
				(FlxG.state as PlayState).mainLevel.wakeupHuman();
				switchLevel(Levels.MAIN);
			}
		}
		
		override public function initPlayerPosition(player:Player, fromLevel:Level):void 
		{
			super.initPlayerPosition(player, fromLevel);
			
			_annoyingTime = 0;
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

			if (_annoyingRect.overlaps(player.bounds)) {
				_eyes.play("movement");
				_mouth.play("movement");

				if ((FlxG.state as PlayState).bedsidetableLevel.pillIsContaminated) {
					_annoyingTime += FlxG.elapsed;
				}
			}
			else {
				_eyes.play("quiet");
				_mouth.play("quiet");
			}

			super.controlInteractionsWithPlayer(player);
		}

	}
}
