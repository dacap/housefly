package  
{
	import org.flixel.*;

	public class Utils 
	{
		public static function moveSpriteOutside(sprite:FlxSprite, rect:FlxRect):void
		{
			var dx1:int = Math.abs(rect.x - (sprite.x + sprite.width / 2));
			var dx2:int = Math.abs((rect.x + rect.width) - (sprite.x + sprite.width / 2));
			var dy1:int = Math.abs(rect.y - (sprite.y + sprite.height / 2));
			var dy2:int = Math.abs((rect.y + rect.height) - (sprite.y + sprite.height / 2));

			if (dx1 < dx2 && dx1 < dy1 && dx1 < dy2) {
				sprite.x = rect.x - sprite.width;
			}
			else if (dx2 < dx1 && dx2 < dy1 && dx2 < dy2) {
				sprite.x = rect.x + rect.width;
			}
			else if (dy1 < dx1 && dy1 < dx2 && dy1 < dy2) {
				sprite.y = rect.y - sprite.height;
			}
			else {
				sprite.y = rect.y + rect.height;
			}
		}
	}

}