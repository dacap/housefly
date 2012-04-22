package
{
	import flash.text.ime.CompositionAttributeRange;
	import org.flixel.*;

	public class LevLitterbox extends LevelCloseLook
	{
		[Embed(source = "../assets/lev_litterbox_fg.png")] private var GfxFg:Class;

		private var _fg:FlxSprite;

		public function LevLitterbox():void
		{
			super(Levels.LITTERBOX);

			_fg = new FlxSprite(0, 0, GfxFg);
			add(_fg);

			setFgSprite(_fg);
		}

		override public function controlInteractionsWithPlayer(player:Player):void
		{
			var playerSprite:FlxSprite = player.getSprite();

			// The fly is going to MAIN level.
			if (playerSprite.x < 0 || playerSprite.y < 0) {
				switchLevel(Levels.MAIN);
				return;
			}

			super.controlInteractionsWithPlayer(player);
		}

	}
}
