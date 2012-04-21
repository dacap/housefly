package
{
	import flash.text.ime.CompositionAttributeRange;
	import org.flixel.*;

	public class LevCat extends Level
	{
		[Embed(source = "../assets/lev_cat_fg.png")] private var GfxFg:Class;
		[Embed(source = "../assets/lev_cat_right_ear.png")] private var GfxRightEar:Class;

		private var _fg:FlxSprite;
		private var _rightEar:FlxSprite;

		public function LevCat():void
		{
			super(Levels.CAT);

			_fg = new FlxSprite(0, 0, GfxFg);
			add(_fg);

			_rightEar = new FlxSprite(91, 95);
			_rightEar.loadGraphic(GfxRightEar, true, false, 99, 90);
			_rightEar.play("movement");
			add(_rightEar);

			setFgSprite(_fg);
		}

		override public function update():void
		{
			super.update();
		}

		override public function initPlayerPosition(player:Player, fromLevel:Level):void
		{
			var oldRect:FlxRect;
			var oldX:Number = player.getSprite().x;
			var oldY:Number = player.getSprite().y;

			super.initPlayerPosition(player, fromLevel);

			player.setLook(Player.CLOSE_LOOK);
			var playerSprite:FlxSprite = player.getSprite();

			switch (fromLevel ? fromLevel.num: Levels.NONE) {
				case Levels.MAIN:
					oldRect = (fromLevel as LevMain).levCatEntry
					playerSprite.x = _fg.width * (oldX - oldRect.x) / oldRect.width;
					playerSprite.y = _fg.height * (oldY - oldRect.y) / oldRect.height;
					break;
			}
		}

		override public function controlInteractionsWithPlayer(player:Player):void
		{
			var playerSprite:FlxSprite = player.getSprite();

			// The fly is going to MAIN level.
			if (playerSprite.x < 0 || playerSprite.y < 0 ||
				playerSprite.x + playerSprite.width >= _fg.width) {

				switchLevel(Levels.MAIN);
			}
			else
				super.controlInteractionsWithPlayer(player);
		}

	}
}
