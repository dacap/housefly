package
{
	import org.flixel.*;

	public class PlayState extends FlxState
	{
		[Embed(source = "../assets/theme.mp3")] private var SndTheme:Class;
		
		private var _level:Level;
		private var _levMain:LevMain = new LevMain();
		private var _levGlass:LevGlass = new LevGlass();
		private var _levCat:LevCat = new LevCat();
		private var _levLitterbox:LevLitterbox = new LevLitterbox();
		private var _levBedsidetable:LevBedsidetable = new LevBedsidetable();
		private var _levHumanhead:LevHumanhead = new LevHumanhead();
		private var _levVentcover:LevVentcover = new LevVentcover();
		private var _theme:FlxSound = new FlxSound();

		private var _player:Player;
		private var _title:FlxText;
		private var _author:FlxText;
		private var _time:Number = 0;

		override public function create():void
		{
			super.create();
			
			_theme.loadEmbedded(SndTheme, true, false);
			_theme.play();

			_level = _levGlass;
			//_level = _levMain;
			//_levMain.startCatAni();
			//_level = _levVentcover;
			//_levMain.dropVentCoverToHuman();
			//_levMain.wakeupHuman();

			_player = new Player();
			_player.setCurrentLevel(_level);

			add(_level);
			add(_player);

			_title = new FlxText(FlxG.width / 2 - 100, FlxG.height - 34, 200, "Housefly");
			_title.color = 0xff000000;
			_title.alignment = "center";
			_title.scrollFactor.x = _title.scrollFactor.y = 0.0;
			_title.alpha = 0;
			add(_title);

			_author = new FlxText(FlxG.width / 2 - 100, FlxG.height - 20, 200, "by David Capello");
			_author.color = 0xff000000;
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

		public function get player():Player { return _player; }
		public function get mainLevel():LevMain { return _levMain; }
		public function get litterboxLevel():LevLitterbox { return _levLitterbox; }
		public function get bedsidetableLevel():LevBedsidetable { return _levBedsidetable; }

		public function switchLevel(levelNum:int):void
		{
			remove(_level);
			
			if (levelNum == Levels.MAIN) {
				_theme.volume = 1.0;
			}
			else {
				_theme.volume = 0.4;
			}

			switch (levelNum) {
				case Levels.MAIN: _level = _levMain; break;
				case Levels.GLASS: _level = _levGlass; break;
				case Levels.CAT: _level = _levCat; break;
				case Levels.LITTERBOX: _level = _levLitterbox; break;
				case Levels.BEDSIDETABLE: _level = _levBedsidetable; break;
				case Levels.HUMANHEAD: _level = _levHumanhead; break;
				case Levels.VENTCOVER: _level = _levVentcover; break;
			}

			add(_level);
			_player.setCurrentLevel(_level);
		}
		
	}
}
