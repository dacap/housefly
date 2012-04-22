package
{
	import flash.text.ime.CompositionAttributeRange;
	import org.flixel.*;

	public class LevGlass extends Level
	{
		[Embed(source = "../assets/lev_glass_fg.png")] private var GfxFg:Class;
		[Embed(source = "../assets/lev_glass_bg.png")] private var GfxBg:Class;

		private var _fg:FlxSprite;
		private var _bg1:FlxSprite;
		private var _bg2:FlxSprite;

		public function LevGlass():void
		{
			super(Levels.GLASS);

			_bg1 = new FlxSprite(0, 0, GfxBg);
			_bg1.scrollFactor.x = 0.2;
			_bg1.scrollFactor.y = 0.95;
			_bg1.velocity.x = -4;
			add(_bg1);

			_bg2 = new FlxSprite(_bg1.width, 0, GfxBg);
			_bg2.scrollFactor.x = 0.2;
			_bg2.scrollFactor.y = 0.95;
			_bg2.velocity.x = -4;
			add(_bg2);

			_fg = new FlxSprite(0, 0, GfxFg);
			add(_fg);

			setFgSprite(_fg);
		}

		override public function update():void
		{
			super.update();

			// Control infinite scroll of bg1 & bg2 (the cloud).
			if (_bg1.x + _bg1.width < 0) { _bg1.x = _bg2.x + _bg2.width; }
			if (_bg2.x + _bg2.width < 0) { _bg2.x = _bg1.x + _bg1.width; }
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
				case Levels.NONE:
					playerSprite.x = _fg.width - playerSprite.width - 100;
					playerSprite.y = FlxG.height/2;
					playerSprite.velocity.x = 128;
					playerSprite.velocity.y = -16;
					break;

				case Levels.MAIN:
					oldRect = (fromLevel as LevMain).levGlassEntry;
					playerSprite.x = 16 + (_fg.width - 32) * Math.max(0, Math.min((oldX - oldRect.x), oldRect.width))  / oldRect.width;
					playerSprite.y = 16 + (_fg.height - 32) * Math.max(0, Math.min((oldY - oldRect.y), oldRect.height)) / oldRect.height;
					break;
			}
		}

		override public function controlInteractionsWithPlayer(player:Player):void
		{
			var playerSprite:FlxSprite = player.getSprite();

			// When the fly hits the glass.
			if (playerSprite.x > _fg.width - 60) {
				playerSprite.velocity.x = -64 + 16*Math.random();
				playerSprite.velocity.y += -8 + 16*Math.random();
				playerSprite.acceleration.x = -4 + 8*Math.random();
				playerSprite.acceleration.y += -8 + 16 * Math.random();

				FlxG.camera.shake(0.01, 0.2);
			}

			// The fly is going to MAIN level.
			if (playerSprite.x < 0 || playerSprite.y < 0 || playerSprite.y + playerSprite.height >= _fg.height) {
				switchLevel(Levels.MAIN);
				return;
			}

			super.controlInteractionsWithPlayer(player);
		}

	}
}
