package
{
	import org.flixel.*;

	public class PlayState extends FlxState
	{
		private var _level:Level;
		private var _levGlass:LevGlass;
		private var _levMain:LevMain;
		private var _player:Player;
		private var _title:FlxText;
		private var _time:Number;

		override public function create():void
		{
			super.create();
			
			_time = 0.0;

			_levGlass = new LevGlass();
			_level = _levGlass;

			_player = new Player();
			_player.setCurrentLevel(_level);
			
			add(_level);
			add(_player);

			_title = new FlxText(FlxG.width / 2 - 100, FlxG.height - 32, 200, "housefly");
			_title.color = 0xff000000
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
		
		public function switchLevel(levelNum:int):void
		{
			remove(_level);

			switch (levelNum) {

				case Levels.GLASS:
					_level = _levGlass;
					break;

				case Levels.MAIN:
					if (_levMain == null) {
						_levMain = new LevMain();
					}
					_level = _levMain;
					break;
			}

			add(_level);
			_player.setCurrentLevel(_level);
		}

	}
}
