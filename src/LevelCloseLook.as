package
{
	import flash.text.ime.CompositionAttributeRange;
	import org.flixel.*;

	public class LevelCloseLook extends Level
	{
		public function LevelCloseLook(num:int):void
		{
			super(num);
		}

		override public function initPlayerPosition(player:Player, fromLevel:Level):void
		{
			var oldRect:FlxRect;
			var oldX:Number = player.getSprite().x;
			var oldY:Number = player.getSprite().y;

			super.initPlayerPosition(player, fromLevel);

			player.setLook(Player.CLOSE_LOOK);
			var playerSprite:FlxSprite = player.getSprite();

			if (fromLevel && fromLevel.num == Levels.MAIN) {
				oldRect = Levels.ENTRY_RECT[num];
				playerSprite.x = 16 + (fgSprite.width - 32) * Math.max(0, Math.min((oldX - oldRect.x), oldRect.width))  / oldRect.width;
				playerSprite.y = 16 + (fgSprite.height - 32) * Math.max(0, Math.min((oldY - oldRect.y), oldRect.height)) / oldRect.height;
			}
			else {
				// Do nothing (subclasses should handle this case).
			}
		}

	}
}
