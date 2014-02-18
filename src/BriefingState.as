package  
{
	/**
	 * ...
	 * @author Elliot
	 */
	import org.flixel.*;
	public class BriefingState extends FlxState
	{
		private var holeSprite:FlxSprite;
			
		private var pressedBegin:Boolean = false;
		
		private var kid1:FlxSprite;
		private var player:FlxSprite;
		
		private var blackScreen:FlxSprite;
		private var laterScreen:FlxSprite;
		
		private var pressX:FlxText;
		
		[Embed(source = "../images/holeo448x346.png")] private var holeImage:Class;
		[Embed(source = "../images/HeyKidBoth.png")] private var kidImage:Class;
		[Embed(source = "../images/Player.png")] private var playerImage:Class;
		[Embed(source = "../images/laterthatday.png")] private var laterImage:Class;
		
		
		[Embed(source = "../sounds/heykid.mp3")] private var heyKidSound:Class;
		[Embed(source = "../sounds/ifyouturn.mp3")] private var kidPhraseSound:Class;
		[Embed(source = "../sounds/whistle.mp3")] private var whistleSound:Class;
		[Embed(source = "../sounds/okay.mp3")] private var okaySound:Class;
		
		override public function create():void
		{
			FlxG.bgColor = 0xff000000;
			
			holeSprite = new FlxSprite(0, 0);
			holeSprite.loadGraphic(holeImage);
			holeSprite.origin.x = 448;
			holeSprite.origin.y = 346;
			
			kid1 = new FlxSprite(0, 0);
			kid1.loadGraphic(kidImage, true, false, 640, 480);
			kid1.addAnimation("idle", [0]);
			kid1.addAnimation("talk", [0, 1], 4);
			kid1.play("talk");
			
			player = new FlxSprite( -231, 0);
			player.loadGraphic(playerImage);
			
			blackScreen = new FlxSprite(0, 0);
			blackScreen.makeGraphic(640, 480, 0xff000000);
			blackScreen.alpha = 0;
			
			laterScreen = new FlxSprite(0, 0);
			laterScreen.loadGraphic(laterImage);
			laterScreen.visible = false;
			
			pressX = new FlxText(0, FlxG.stage.stageHeight * 0.9, FlxG.stage.stageWidth, "press x to continue");
			pressX.size = 16;
			pressX.alignment = "center";
			
			add(kid1);
			add(player);
			add(holeSprite);
			add(pressX);
			add(blackScreen);
			add(laterScreen);
			
			FlxG.play(heyKidSound);
		}
		
		override public function update():void
		{
			if (FlxG.keys.X)
				pressedBegin = true;
			if (pressedBegin)
				updateCinema();
			super.update();
		}
		
		private var sceneTime:Number = 0;
		
		
		private var keyTimes:Vector.<Number> = new <Number>[0, 1, 2, 6, 7, 8, 9 ];
		private var keyPlayed:Vector.<Boolean> = new <Boolean>[false, false, false, false, false];
		
		private function updateCinema():void
		{
			sceneTime += FlxG.elapsed;
			if (sceneTime >= keyTimes[0] && sceneTime < keyTimes[1])
			{
				pressX.visible = false;
				holeSprite.scale.x = sinInterpolate(1, 10, calcPercent(sceneTime, keyTimes[0], keyTimes[1]));
				holeSprite.scale.y = sinInterpolate(1, 10, calcPercent(sceneTime, keyTimes[0], keyTimes[1]));
			}
			
			if (sceneTime >= keyTimes[1] && sceneTime < keyTimes[2])
			{
				if (!keyPlayed[1])
				{
					keyPlayed[1] = true;
					FlxG.play(whistleSound);
					
				}
				
				player.x = sinInterpolate( -231, 0, calcPercent(sceneTime, keyTimes[1], keyTimes[2]));
				
			}
			
			if (sceneTime >= keyTimes[2] && sceneTime < keyTimes[3])
			{
				if (!keyPlayed[2])
				{
					keyPlayed[2] = true;
					FlxG.play(kidPhraseSound);
				}
			}
			
			if (sceneTime >= keyTimes[2] && sceneTime < keyTimes[3])
			{
				if (!keyPlayed[2])
				{
					keyPlayed[2] = true;
					FlxG.play(kidPhraseSound);
				}
			}
			
			if (sceneTime >= keyTimes[3] && sceneTime < keyTimes[4])
			{
				if (!keyPlayed[3])
				{
					keyPlayed[3] = true;
					FlxG.play(okaySound);
				}
				
				blackScreen.alpha = sinInterpolate(0, 1, calcPercent(sceneTime, keyTimes[3], keyTimes[4]));
			}
			if (sceneTime >= keyTimes[4] && sceneTime < keyTimes[5])
			{
				laterScreen.visible = true;
			}
			
			if (sceneTime >= keyTimes[6])
			{
				FlxG.switchState(new PlayState());
			}
		}
		
		private function calcPercent(t:Number, begin:Number, end:Number):Number
		{
			return (t - begin) / (end - begin);
		}
		
		private function sinInterpolate(begin:Number, end:Number, t:Number):Number
		{
			return (end - begin) * ( -0.5 * Math.cos(Math.PI * t) + 0.5) + begin;
		}
		
	}

}