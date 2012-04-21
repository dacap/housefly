package
{
	import org.flixel.*;

	public class Level extends FlxGroup
	{
		private var _num:int;
		private var _fg:FlxSprite;
		/*private var _lockReentry:Boolean = false;
		private var _switched:Boolean = false;*/

		public function Level(num:int):void
		{
			super();
			_num = num;
		}

		public function get num():int
		{
			return _num;
		}

		protected function setFgSprite(fg:FlxSprite):void
		{
			_fg = fg;
		}

		public function get fgSprite():FlxSprite
		{
			return _fg;
		}

		public function setupCameraForPlayer(player:Player):void
		{
			FlxG.camera.setBounds(0, 0, _fg.width, _fg.height, true);
			FlxG.camera.follow(player.getSprite(), FlxCamera.STYLE_PLATFORMER);
		}

		public function limitRect(rc:FlxRect):FlxPoint
		{
			return new FlxPoint(Math.max(0, Math.min(rc.x, _fg.width - rc.width)),
								Math.max(0, Math.min(rc.y, _fg.height - rc.height)));
		}

		public function initPlayerPosition(player:Player, fromLevel:Level):void
		{
			//_lockReentry = true;
		}

		public function controlInteractionsWithPlayer(player:Player):void
		{
			var spr:FlxSprite = player.getSprite();

			// Limit player position to the fg sprite bounds.
			if (spr.x < 0) {
				spr.x = 1;
				if (spr.velocity.x < 0) {
					spr.velocity.x = -spr.velocity.x;
				}
			}
			if (spr.y < 0) {
				spr.y = 1;
				if (spr.velocity.y < 0) {
					spr.velocity.y = -spr.velocity.y;
				}
			}
			if (spr.x + spr.width > _fg.width) {
				spr.x = _fg.width - spr.width - 1;
				if (spr.velocity.x > 0) {
					spr.velocity.x = -spr.velocity.x;
				}
			}
			if (spr.y + spr.height > _fg.height) {
				spr.y = _fg.height - spr.height - 1;
				if (spr.velocity.y > 0) {
					spr.velocity.y = -spr.velocity.y;
				}
			}
//			var pt:FlxPoint = limitRect(new FlxRect(spr.x, spr.y, spr.width, spr.height));
//			spr.x = pt.x;
//			spr.y = pt.y;
/*
			if (!_switched) {
				_lockReentry = false;
			}
			_switched = false;*/
		}

		protected function switchLevel(levelNum:int):void
		{
			/*if (!_lockReentry) {
				_lockReentry = false;*/
				(FlxG.state as PlayState).switchLevel(levelNum);
			/*}
			_switched = true;*/
		}

	}
}
