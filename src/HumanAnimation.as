package
{
	import org.flixel.*;

	public class HumanAnimation extends FlxSprite
	{
		[Embed(source = "../assets/human_ani.png")] private var GfxHumanAni:Class;

		private var _sprite:FlxSprite;
		private var _frameIndex:int = 0;

		public function HumanAnimation():void
		{
			loadGraphic(GfxHumanAni, true, false, 112, 39);
			addAnimationCallback(controlAnis);
			addAnimation("ani", [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20, 20, 20, 21, 21, 21, 21], 6, false);
			play("ani");
		}

		private function controlAnis(ani:String, frame:int, index:int):void
		{
			_frameIndex++;

			if (_frameIndex == 27) {
				(FlxG.state as PlayState).mainLevel.gotoBathroom();
			}
		}

	}
}
