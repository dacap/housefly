package
{
	import org.flixel.FlxRect;

	public class Levels
	{
		public static const MAIN:int = 0;
		public static const GLASS:int = 1;
		public static const CAT:int = 2;
		public static const LITTERBOX:int = 3;
		public static const BEDSIDETABLE:int = 4;
		public static const HUMANHEAD:int = 5;
		public static const VENTCOVER:int = 6;

		public static const FIRST_ENTRY:int = GLASS;
		public static const LAST_ENTRY:int = VENTCOVER;

		public static const ENTRY_RECT:Array = [
			null,
			new FlxRect(273, 34, 47, 108),
			new FlxRect(93, 210, 34, 26),
			new FlxRect(245, 201, 72, 39),
			new FlxRect(100, 134, 51, 34),
			new FlxRect(50, 129, 34, 24),
			new FlxRect(22, 18, 47, 42)
		];
	}
}