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
			
			if (_bg1.x + _bg1.width < 0) { _bg1.x = _bg2.x + _bg2.width; }
			if (_bg2.x + _bg2.width < 0) { _bg2.x = _bg1.x + _bg1.width; }
		}

		override public function initPlayerPosition(player:Player):void
		{
			super.initPlayerPosition(player);

			player.x = _fg.width - player.width - 100;
			player.y = FlxG.height/2;
			player.velocity.x = 64;
			player.velocity.y = -16;
		}
		
		override public function controlInteractionsWithPlayer(player:Player):void
		{
			// When the fly hits the glass.
			if (player.x > _fg.width - 60) {
				player.velocity.x = -64 + 16*Math.random();
				player.velocity.y = -8 + 16*Math.random();
				player.acceleration.x = -4 + 8*Math.random();
				player.acceleration.y = -4 + 8*Math.random();
			}
			
			if (player.x < 128) {
				FlxG.camera.zoom = 1.8 + (0.2 * (player.x / 128));
			}
			else {
				FlxG.camera.zoom = 2.0;
			}

			super.controlInteractionsWithPlayer(player);
		}

	}
}
