package
{
	import org.flixel.*;

	public class PlayState extends FlxState
	{
		private var _level:Level;
		private var _levGlass:LevGlass;
		private var _levMain:LevMain;
		private var _levCat:LevCat;
		private var _player:Player;
		private var _title:FlxText;
		private var _author:FlxText;
		private var _time:Number;

		override public function create():void
		{
			super.create();
			
			_time = 0.0;

			//_levGlass = new LevGlass();
			//_level = _levGlass;
			_levMain = new LevMain();
			_level = _levMain;

			_player = new Player();
			_player.setCurrentLevel(_level);
			
			add(_level);
			add(_player);

			_title = new FlxText(FlxG.width / 2 - 100, FlxG.height - 34, 200, "Housefly");
			_title.color = 0xff000000
			_title.alignment = "center";
			_title.scrollFactor.x = _title.scrollFactor.y = 0.0;
			_title.alpha = 0;
			add(_title);

			_author = new FlxText(FlxG.width / 2 - 100, FlxG.height - 20, 200, "by David Capello");
			_author.color = 0xff000000
			_author.alignment = "center";
			_author.scrollFactor.x = _author.scrollFactor.y = 0.0;
			_author.alpha = 0;
			add(_author);
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

			// _author timeline.
			if (_time >= 3.0 && _time < 4.0) {
				_author.alpha = _time-3.0;
			}
			else if (_time >= 4.0 && _time < 5.0) {
				_author.alpha = 1;
			}
			else if (_time >= 5.0 && _time < 6.0) {
				_author.alpha = 1.0 - (_time-5.0);
			}
			else if (_time >= 5.0) {
				remove(_author);
			}

			super.update();
		}
		
		public function getLevel():Level
		{
			return _level;
		}
		
		public function switchLevel(levelNum:int):void
		{
			remove(_level);

			switch (levelNum) {

				case Levels.GLASS:
					if (_levGlass == null) _levGlass = new LevGlass();
					_level = _levGlass;
					break;

				case Levels.MAIN:
					if (_levMain == null) _levMain = new LevMain();
					_level = _levMain;
					break;
					
				case Levels.CAT:
					if (_levCat == null) _levCat = new LevCat();
					_level = _levCat;
					break;
			}

			add(_level);
			_player.setCurrentLevel(_level);
		}

	}
}
