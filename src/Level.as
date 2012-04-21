package
{
	import org.flixel.*;

	public class Level extends FlxGroup
	{
		private var _fg:FlxSprite;

		public function Level():void
		{
		}

		protected function setFgSprite(fg:FlxSprite):void
		{
			_fg = fg;
		}

		public function setupCameraForPlayer(sprite:FlxSprite):void
		{
			FlxG.camera.setBounds(0, 0, _fg.width, _fg.height, true);
			FlxG.camera.follow(sprite, FlxCamera.STYLE_PLATFORMER);
		}
		
		public function limitRect(rc:FlxRect):FlxPoint
		{
			return new FlxPoint(Math.max(0, Math.min(rc.x, _fg.width - rc.width)),
								Math.max(0, Math.min(rc.y, _fg.height - rc.height)));
		}

		public function initPlayerPosition(player:Player):void
		{
			// Do nothing
		}

		public function controlInteractionsWithPlayer(player:Player):void
		{
			// Limit player position to the fg sprite bounds.
			var pt:FlxPoint = limitRect(new FlxRect(player.x, player.y, player.width, player.height));
			player.x = pt.x;
			player.y = pt.y;
		}

	}
}
