package
{
	import org.flixel.*;

	public class WinState extends FlxState
	{
		[Embed(source = "../assets/fly.png")] private var GfxFly:Class;
		[Embed(source = "../assets/lev_glass_bg.png")] private var GfxBg:Class;

		private var _fly:FlxSprite;
		private var _bg1:FlxSprite;
		private var _bg2:FlxSprite;
		private var _text:FlxText;
		private var _time:Number = 0;

		override public function create():void
		{
			super.create();

			_bg1 = new FlxSprite(0, 0, GfxBg);
			_bg1.scrollFactor.x = 0.2;
			_bg1.scrollFactor.y = 0.95;
			_bg1.velocity.x = -64;
			add(_bg1);

			_bg2 = new FlxSprite(_bg1.width, 0, GfxBg);
			_bg2.scrollFactor.x = 0.2;
			_bg2.scrollFactor.y = 0.95;
			_bg2.velocity.x = -64;
			add(_bg2);

			_fly = new FlxSprite();
			_fly.loadGraphic(GfxFly, true, true, 14, 14);
			_fly.addAnimation("fly", [0, 1], 30, true);
			_fly.play("fly", true);
			_fly.x = 32;
			_fly.y = FlxG.height/2 - _fly.height/2;
			add(_fly);

			_text = new FlxText(FlxG.width / 2 - 100, FlxG.height - 20, 200, "Congratulations!!");
			_text.color = 0xff000000;
			_text.alignment = "center";
			_text.scrollFactor.x = _text.scrollFactor.y = 0.0;
			add(_text);
		}

		override public function update():void
		{
			super.update();

			_time += FlxG.elapsed;
			_fly.y = FlxG.height/2 - _fly.height/2 + 8*Math.sin(Math.PI * _time);

			// Control infinite scroll of bg1 & bg2 (the cloud).
			if (_bg1.x + _bg1.width < 0) { _bg1.x = _bg2.x + _bg2.width; }
			if (_bg2.x + _bg2.width < 0) { _bg2.x = _bg1.x + _bg1.width; }
		}

	}
}
