package
{
	import org.flixel.*;

	public class HumanFighter extends FlxSprite
	{
		[Embed(source = "../assets/human_fight.png")] private var GfxHumanFight:Class;
		[Embed(source = "../assets/human_fight_open_window.png")] private var GfxOpenWindow:Class;
		[Embed(source = "../assets/slipper.mp3")] private var SndSlipper:Class;
		[Embed(source = "../assets/hit2.mp3")] private var SndHit2:Class;

		private var _sprite:FlxSprite;
		private var _time:Number = 0;
		private var _hitTime:Number = 0;
		private var _windowOpened:Boolean = false;
		private var _openingWindow:Boolean = false;

		public function HumanFighter():void
		{
			loadGfxHumanFight();
			addAnimationCallback(controlAnis);
			addAnimation("stand", [0], 1, true);
			addAnimation("walk", [0, 1], 8, true);
			addAnimation("hit", [2, 3], 8, false);
			play("stand", true);
		}

		override public function update():void
		{
			var player:Player = (FlxG.state as PlayState).player;

			if (!_openingWindow) {
				if (player.getSprite().x < x) {
					velocity.x = -64;
					play("walk");
				}
				else if (player.getSprite().x > x+width/2) {
					velocity.x = +64;
					play("walk");
				}
				else if ((_time - _hitTime) > 0.2) {
					if (player.getSprite().y > 40) {
						velocity.x = 0;
						play("hit");
						_hitTime = _time;
						FlxG.play(SndSlipper, 1.0, false, true);
					}
					else {
						velocity.x = 0;
						play("stand");
					}
				}

				if (x < 86) {
					x = 86;
					velocity.x = 0;
					play("stand");
				}
				else if (x > 220) {
					x = 220;
					velocity.x = 0;
					play("stand");

					if (!_windowOpened) {
						_windowOpened = true;
						_openingWindow = true;

						// Open the window
						loadGraphic(GfxOpenWindow, true, false, 109, 132);
						addAnimation("openwindow", [0, 1, 2, 2], 6, false);
						play("openwindow");

						(FlxG.state as PlayState).mainLevel.openWindow();
					}
				}
			}

			super.update();

			_time += FlxG.elapsed;
		}

		private function loadGfxHumanFight():void
		{
			loadGraphic(GfxHumanFight, true, false, 61, 132);
		}

		private function controlAnis(ani:String, frame:int, index:int):void
		{
			if (ani == "openwindow" && frame >= 3) {
				_openingWindow = false;
				loadGfxHumanFight();
				play("stand", true);
			}
			else if (ani == "hit" && frame == 1) {
				var player:Player = (FlxG.state as PlayState).player;
				if (player.getSprite().x > x-20 &&
					player.getSprite().y > y-10 &&
					player.getSprite().x < x+width &&
					player.getSprite().y < y+height) {
					player.getSprite().velocity.y = -400;
					player.getSprite().velocity.x = -400;

					FlxG.play(SndHit2, 1.0, false, true);
					FlxG.camera.shake(0.01, 0.2);
				}
			}
		}

	}
}
