package  
{
	/**
	 * ...
	 * @author Elliot
	 */
	import org.flixel.*;
	public class StartMenuState extends FlxState
	{
		private var pressX:FlxText;
		
		[Embed(source = "../images/title.png")] private var titleImage:Class;
		
		[Embed(source = "../sounds/piano.mp3")] private var pianoMusic:Class;
		
		
		override public function create():void
		{
			var title:FlxSprite = new FlxSprite(0, 0);
			title.loadGraphic(titleImage);
			
			
			pressX = new FlxText(0, FlxG.stage.stageHeight * 0.9, FlxG.stage.stageWidth, "press x to start");
			pressX.size = 16;
			pressX.alignment = "center";
			
			FlxG.play(pianoMusic, 1);
			
			add(title);
			add(pressX);
		}
		override public function update():void
		{
			if(FlxG.keys.X)
				FlxG.switchState(new BriefingState);
		}
	}

}