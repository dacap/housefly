package
{
	import flash.text.ime.CompositionAttributeRange;
	import org.flixel.*;

	public class LevMain extends Level
	{
		[Embed(source = "../assets/lev_main_fg.png")] private var GfxFg:Class;

		private var _fg:FlxSprite;
		
		private var _levGlassEntry:FlxRect;

		public function LevMain():void
		{
			super(Levels.MAIN);

			_fg = new FlxSprite(0, 0, GfxFg);
			add(_fg);
			
			_levGlassEntry = new FlxRect(_fg.width - 32, _fg.height / 2 - 64, 32, 128);

			setFgSprite(_fg);
		}
		
		override public function update():void 
		{
			super.update();
		}

		override public function initPlayerPosition(player:Player, fromLevel:int):void
		{
			super.initPlayerPosition(player, fromLevel);

			player.setLook(Player.FAR_LOOK);

			switch (fromLevel) {
				case Levels.GLASS:
					player.getSprite().x = _levGlassEntry.x - 1;
					player.getSprite().y = _levGlassEntry.y + _levGlassEntry.height/2;
					break;
			}

			FlxG.camera.zoom = 2.0;
		}
		
		override public function controlInteractionsWithPlayer(player:Player):void
		{
			var playerPos:FlxPoint = new FlxPoint(player.getSprite().x, player.getSprite().y);
			
			var dist:Number = FlxU.getDistance(playerPos,
											   new FlxPoint(_levGlassEntry.x + _levGlassEntry.width,
															_levGlassEntry.y + _levGlassEntry.height/2));
			if (_levGlassEntry.overlaps(player.bounds)) {
				switchLevel(Levels.GLASS);
			}
			else if (dist < _levGlassEntry.width*2) {
				FlxG.camera.zoom = 2.0 + 0.5 * (1 - (dist / (_levGlassEntry.width*2)));
			}
			else {
				FlxG.camera.zoom = 2.0;
			}

			super.controlInteractionsWithPlayer(player);
		}

	}
}
