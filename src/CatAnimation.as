package
{
	import org.flixel.*;

	public class CatAnimation extends FlxSprite
	{
		[Embed(source = "../assets/cat_ani.png")] private var GfxCatAni:Class;

		private var _sprite:FlxSprite;
		private var _frameIndex:int = 0;

		public function CatAnimation():void
		{
			loadGraphic(GfxCatAni, true, false, 229, 69);
			addAnimationCallback(controlAnis);
			addAnimation("gotolitterbox", [0, 1, 2, 3, 4, 4, 5, 6, 7, 8, 9, 10, 10, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20, 20, 20, 20, 21], 8, false);
			play("gotolitterbox");
		}

		private function controlAnis(ani:String, frame:int, index:int):void
		{
			_frameIndex++;

			if (_frameIndex == 23) {
				// Add cat's crap to the litter box.
				(FlxG.state as PlayState).mainLevel.addTheGift();
				(FlxG.state as PlayState).litterboxLevel.addTheGift();
			}
			else if (_frameIndex == 25) {
				visible = false;
			}
		}

	}
}
