package
{
	import flash.text.ime.CompositionAttributeRange;
	import org.flixel.*;

	public class LevBedsidetable extends LevelCloseLook
	{
		[Embed(source = "../assets/lev_bedsidetable_fg.png")] private var GfxFg:Class;
		[Embed(source = "../assets/lev_bedsidetable_glass.png")] private var GfxGlass:Class;
		[Embed(source = "../assets/lev_bedsidetable_pill.png")] private var GfxPill:Class;

		private var _fg:FlxSprite;
		private var _glass:FlxSprite;
		private var _pill:FlxSprite;

		public function LevBedsidetable():void
		{
			super(Levels.BEDSIDETABLE);

			_fg = new FlxSprite(0, 0, GfxFg);
			add(_fg);

			_glass = new FlxSprite(94, 122);
			_glass.loadGraphic(GfxGlass, true, false, 52, 17);
			_glass.addAnimation("move", [0, 1, 2], 3, true);
			_glass.play("move");
			add(_glass);

			_pill = new FlxSprite(135, 186);
			_pill.loadGraphic(GfxPill, true, false, 35, 12);
			_pill.addAnimation("clean", [0], 1, true);
			_pill.addAnimation("dirty", [1], 1, true);
			_pill.play("clean");
			add(_pill);

			setFgSprite(_fg);
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

			if (player.hasWeight && _pill.overlaps(playerSprite)) {
				_pill.play("dirty");
				player.dropGift();
				(FlxG.state as PlayState).getMainLevel().dropGift();
			}

			super.controlInteractionsWithPlayer(player);
		}

	}
}
