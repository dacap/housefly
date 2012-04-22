package
{
	import flash.text.ime.CompositionAttributeRange;
	import org.flixel.*;

	public class LevLitterbox extends LevelCloseLook
	{
		[Embed(source = "../assets/lev_litterbox_fg.png")] private var GfxFg:Class;
		[Embed(source = "../assets/lev_litterbox_gift.png")] private var GfxGift:Class;

		private var _fg:FlxSprite;
		private var _gift:FlxSprite;
		private var _giftOnLitter:Boolean = false;

		public function LevLitterbox():void
		{
			super(Levels.LITTERBOX);

			_fg = new FlxSprite(0, 0, GfxFg);
			add(_fg);

			_gift = new FlxSprite(245, 196, GfxGift);

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

			// Touch the "gift"
			if (_giftOnLitter && _gift.overlaps(playerSprite)) {
				player.standOnGift();
			}

			super.controlInteractionsWithPlayer(player);
		}

		public function addTheGift():void
		{
			_giftOnLitter = true;
			add(_gift);
		}

	}
}
