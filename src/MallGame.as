package  
{
	/**
	 * ...
	 * @author Elliot Hatch
	 */
	import org.flixel.*
	[SWF(width = "640", height = "480", backgroundColor = "#00000000")]
	[Frame(factoryClass="Preloader")]
	
	public class MallGame extends FlxGame
	{
	
		public function MallGame() 
		{
			super(740, 680, StartMenuState);
		}
		
	}

}