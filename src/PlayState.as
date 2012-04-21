package
{
	import org.flixel.*;

	public class PlayState extends FlxState
	{
		private var _level:Level;
		private var _player:Player;
		private var _title:FlxText;
		private var _time:Number;

		override public function create():void
		{
			super.create();
			
			_time = 0.0;

			_level = new LevGlass();
			_player = new Player();
			_player.curLevel = _level;
			
			add(_level);
			add(_player);

			_title = new FlxText(FlxG.width/2 - 100, FlxG.height - 32, 200, "housefly");
			_title.alignment = "center";
			_title.scrollFactor.x = _title.scrollFactor.y = 0.0;
			_title.alpha = 0;
			add(_title);
		}
		
		override public function update():void
		{
			_time += FlxG.elapsed;
			
			// _title timeline.
			if (_time >= 2.0 && _time < 3.0) {
				_title.alpha = _time-2.0;
			}
			else if (_time >= 3.0 && _time < 5.0) {
				_title.alpha = 1;
			}
			else if (_time >= 5.0 && _time < 6.0) {
				_title.alpha = 1.0 - (_time-5.0);
			}
			else if (_time >= 5.0) {
				remove(_title);
			}

			super.update();
		}
	}
}
