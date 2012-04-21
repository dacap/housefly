package
{
	import org.flixel.*;

	public class Player extends FlxSprite
	{
		[Embed(source = "../assets/fly.png")] private var GfxFly:Class;
		
		private var _curLevel:Level;

		public function Player():void
		{
		    loadGraphic(GfxFly, true, true, 14, 14);
			
			addAnimation("fly", [0, 1], 30, true);
			play("fly", true);
		}
		
		public function set curLevel(level:Level):void
		{
			_curLevel = level;
			_curLevel.initPlayerPosition(this);
			_curLevel.setupCameraForPlayer(this);
		}

		override public function update():void
		{
			if (FlxG.keys.LEFT)  {
				facing = LEFT;

				if (velocity.x > 0)
					acceleration.x = -256;
				else
					acceleration.x = -128;
			}
			else if (FlxG.keys.RIGHT) {
				facing = RIGHT;

				if (velocity.x < 0)
					acceleration.x = +256;
				else
					acceleration.x = +128;
			}
			else {
				// Slow down
				velocity.x /= 1 + FlxG.elapsed;
				acceleration.x = 0;
			}

			if (FlxG.keys.UP)  {
				if (velocity.y > 0)
					acceleration.y = -256;
				else
					acceleration.y = -128;
			}
			else if (FlxG.keys.DOWN) {
				if (velocity.y < 0)
					acceleration.y = +256;
				else
					acceleration.y = +128;
			}
			else {
				velocity.y /= 1 + FlxG.elapsed;
				acceleration.y = 0;
			}

			// Call base impl.
			super.update();
			
			// Limit position inside the level bounds.
			_curLevel.controlInteractionsWithPlayer(this);
		}
	}
}
