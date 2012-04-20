package
{
	import org.flixel.*;

	[SWF(width="640", height="480", backgroundColor="#000000")]
	[Frame(factoryClass="Preloader")]

	public class Game extends FlxGame
	{
		public function Game()
		{
			super(320, 240, MenuState, 2);
		}
	}
}
