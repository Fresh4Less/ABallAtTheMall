package
{
	/**
	 * ...
	 * @author Elliot Hatch
	 */
	import adobe.utils.CustomActions;
	import flash.display.Sprite;
	import mx.core.FlexSprite;
	import org.flixel.*;
	import org.flixel.plugin.photonstorm.FlxPowerTools;
	
	public class PlayState extends FlxState
	{
		private var gameMode:int = 0;
		//game modes
		private var MODE_COIN:int = 0;
		private var MODE_TURN:int = 1;
		private var MODE_RECEIVE:int = 2;
		
		private var dispenserOffsetX:Number = 100;
		private var cameraPan02Y:Number = 200;
		
		private var cameraPan01Timer:FlxTimer;
		private var cameraPan01:Boolean = false;
		private var cameraPan02Timer:FlxTimer;
		private var cameraPan02:Boolean = false;
		private var cameraPan02Primed:Boolean = false;
		
		private var dispenseAnimation:Boolean = false;
		private var dispenseAnimationTime:Number = 0;
		
		private var mallBackgroundSprite:FlxSprite;
		
		private var cursor:FlxSprite;
		private var openHandCollider:FlxSprite;
		
		private var handSprite:FlxSprite;
		private var handCoinSprite:FlxSprite;
		private var handTurnSprite:FlxSprite;
		private var handReceivingSprite:FlxSprite;
		private var cursorDotSprite:FlxSprite;
		
		private var gravity:Number = 600;
		
		private var coin:FlxSprite;
		private var coinFeed:FlxSprite;
		private var coinCover:FlxSprite;
		
		private var momHandSprite:FlxSprite;
		private var turnInstructionsSprite:FlxSprite;
		
		private var coinIsHeld:Boolean = false;
		private var handleIsHeld:Boolean = false;
		
		private var dispenserCollider:FlxSprite;
		private var dispenserHandle:FlxSprite;
		private var dispenserSprite:FlxSprite;
		private var flapSprite:FlxSprite;
		private var flapUnderSprite:FlxSprite;
		private var lastMouseXY:FlxPoint;
		
		private var totalTheta:Number = 0;
		private var goalTheta:Number = 360;
		private var snapbackThetaMax:Number = 45;
		private var snapbackThetaMin:Number = 0;
		private var currentSnap:Number = 0;
		private var snapAmount:Number = 10;
		private var averageTurnSpeed:Number = 0;
		private var turnSpeeds:Vector.<Number>;
		private var turnSpeedsIndex:int = 0;
		
		private var speedometerXY:FlxPoint = new FlxPoint(110, 100);
		private var speedometerWH:FlxPoint = new FlxPoint(80, 300);
		private var speedometerBar:FlxSprite;
		private var speedometerMax:Number = 30;
		private var speedometerVelocity:Number = 0;
		private var speedometerMaxVelocity:Number = 0.05;
		private var speedometerAcceleration:Number = 0.01;
		
		private var speedarrowSprite:FlxSprite;
		
		private var sevenSprite:FlxSprite;
		
		private var slowDownText:FlxSprite;
		private var slowDownTextScale:Number = 1;
		private var slowDownTextRate:Number = 1.5;
		private var slowDownTextCount:Number = 0;
		private var slowDownTextScaleMax:Number = 1.5;
		
		private var slowDownSoundCount:Number = 0;
		
		private var candyCount:int = 7;
		private var candyCountVariance:int = 0;
		private var candyGroup:FlxGroup;
		
		private var cursorTrail:FlxEmitter;
		
		private var blackCover:FlxSprite;
		private var finScreen:FlxSprite;
		
		private var beatClips:Vector.<FlxSound>;
		private var beatCount:int = 0;
		
		[Embed(source = "../images/vending machine barex2.png")] private var dispenserImage:Class;
		[Embed(source = "../images/Handlex2.png")] private var handleImage:Class; //194x50
		[Embed(source = "../images/flapx2.png")] private var flapImage:Class;
		[Embed(source = "../images/flapUnderSidex2.png")] private var flapUnderImage:Class;
		[Embed(source = "../images/Quarterx2.png")] private var coinImage:Class;
		[Embed(source = "../images/MouseDot.png")] private var cursorDotImage:Class;
		[Embed(source = "../images/CoinCover.png")] private var coinCoverImage:Class;
		[Embed(source = "../images/hand.png")] private var handImage:Class;
		[Embed(source = "../images/handQuarter.png")] private var handCoinImage:Class;
		[Embed(source = "../images/HandOnHandleComplete.png")] private var handOnHandleImage:Class;
		[Embed(source = "../images/momshand.png")] private var momHandImage:Class;
		[Embed(source = "../images/M&m1.png")] private var candy1Image:Class;
		[Embed(source = "../images/M&m2.png")] private var candy2Image:Class;
		[Embed(source = "../images/M&m3.png")] private var candy3Image:Class;
		[Embed(source = "../images/M&m4.png")] private var candy4Image:Class;
		[Embed(source = "../images/speedometer.png")] private var speedometerImage:Class;
		[Embed(source = "../images/speedarrow.png")] private var speedarrowImage:Class;
		[Embed(source = "../images/SlowDownText.png")] private var SlowDownImage:Class;
		[Embed(source = "../images/handOpenForNummies.png")] private var handReceivingImage:Class;
		[Embed(source = "../images/SEVEN.png")] private var sevenImage:Class;
		[Embed(source = "../images/fin.png")] private var finImage:Class;
		
		[Embed(source="../images/MallBackground.png")] private var mallBackgroundImage:Class;
		[Embed(source="../images/Spinny.png")] private var turnInstructionsImage:Class;
		
		[Embed(source="../sounds/MallSounds.mp3")] private var mallBgSounds:Class;
		[Embed(source = "../sounds/slowdown.mp3")] private var slowDownSound:Class;
		[Embed(source = "../sounds/sqeak.mp3")] private var hingeSqueakSound:Class;
		[Embed(source="../sounds/partyhorn.mp3")] private var partyHornSound:Class;
		[Embed(source = "../sounds/oh0615s.mp3")] private var sadSound:Class;
		
		[Embed(source = "../sounds/100.mp3")] private var beats1Sound:Class;
		[Embed(source = "../sounds/120.mp3")] private var beats2Sound:Class;
		[Embed(source = "../sounds/200.mp3")] private var beats3Sound:Class;
		[Embed(source = "../sounds/300.mp3")] private var beats4Sound:Class;
		[Embed(source = "../sounds/600.mp3")] private var beats5Sound:Class;
		[Embed(source = "../sounds/800.mp3")] private var beats6Sound:Class;
		[Embed(source = "../sounds/finale.mp3")] private var finaleSound:Class;
		
		[Embed(source = "../sounds/click.mp3")] private var clickSound:Class;
		[Embed(source = "../sounds/candydrop.mp3")] private var candyDropSound:Class;
		
		override public function create():void
		{
			super.create();
			FlxG.bgColor = 0xffffffff;
			
			turnSpeeds = new Vector.<Number>();
			for (var i1:int = 0; i1 < 8; i1++)
			{
				turnSpeeds.push(0);
			}
			
			candyTimes = new Vector.<Number>();
			candyPosition = new Vector.<FlxPoint>();
			
			coin = new FlxSprite(220, 250);
			coin.loadGraphic(coinImage);
			//coin.makeGraphic(40, 40, 0xffaaaaaa);
			
			coinFeed = new FlxSprite(FlxG.width / 2 - 48 / 2 + dispenserOffsetX, 120);
			coinFeed.makeGraphic(48, 48, 0xdddddddd);
			
			coinCover = new FlxSprite(FlxG.width / 2 - 178 / 2 + dispenserOffsetX, 136);
			coinCover.loadGraphic(coinCoverImage); //178x59
			
			mallBackgroundSprite = new FlxSprite(0, 0);
			mallBackgroundSprite.loadGraphic(mallBackgroundImage);
			mallBackgroundSprite.origin.x = 0;
			mallBackgroundSprite.origin.y = 0;
			mallBackgroundSprite.scale.x = 1.5;
			mallBackgroundSprite.scale.y = 1.5;
			
			momHandSprite = new FlxSprite(0, 250);
			momHandSprite.loadGraphic(momHandImage);
			
			//coinInsertedSprite = new FlxSprite(FlxG.width / 2 - 38 / 2, 140)
			
			dispenserCollider = new FlxSprite(FlxG.width / 2 - 194 / 2 + dispenserOffsetX, 480 / 2 - 194 / 2);
			dispenserCollider.makeGraphic(194, 194, 0xffeeffee);
			
			dispenserHandle = new FlxSprite(FlxG.width / 2 - 194 / 2 + dispenserOffsetX, 480 / 2 - 50 / 2);
			//dispenserHandle.makeGraphic(100, 30, 0xff333333);
			dispenserHandle.loadGraphic(handleImage); //194x50
			
			dispenserSprite = new FlxSprite(FlxG.width / 2 - 568 / 2 - 5 + dispenserOffsetX, 60);
			dispenserSprite.loadGraphic(dispenserImage); //568x1076
			dispenserSprite.offset.y = 1076 - 480;
			
			flapSprite = new FlxSprite(FlxG.width / 2 - 124 / 2 + 4 + dispenserOffsetX, 480 - 100);
			flapSprite.loadGraphic(flapImage); //124x124
			flapSprite.origin.y = 0;
			
			flapUnderSprite = new FlxSprite(flapSprite.x, flapSprite.y - 124);
			flapUnderSprite.loadGraphic(flapUnderImage); //124x124
			flapUnderSprite.origin.y = 124;
			flapUnderSprite.visible = false;
			flapUnderSprite.scale.y = 0;
			
			handSprite = new FlxSprite(0, 0);
			handSprite.loadGraphic(handImage); //200x526
			handSprite.offset.x = 80;
			handSprite.offset.y = 120;
			//handSprite.makeGraphic(10, 10, 0xff000000);
			handCoinSprite = new FlxSprite(0, 0);
			handCoinSprite.loadGraphic(handCoinImage); //183x438
			handCoinSprite.offset.x = 30;
			handCoinSprite.offset.y = 90;
			//handCoinSprite.makeGraphic(10, 10, 0xffffaaaa);
			handCoinSprite.visible = false;
			handTurnSprite = new FlxSprite(dispenserHandle.x + dispenserHandle.width / 2 - 200 / 2 + 3, dispenserHandle.y + dispenserHandle.height / 2 - 144 / 2 - 12);
			handTurnSprite.loadGraphic(handOnHandleImage); //201x144
			handTurnSprite.origin.x = dispenserHandle.width / 2;
			handTurnSprite.origin.y = 60 + 25;
			
			//handTurnSprite.origin.y = dispenserHandle.height / 2 + 13;
			//handTurnSprite.makeGraphic(10, 10, 0xffaaaaff);
			//handTurnSprite.loadGraphic(handCoinImage);
			handTurnSprite.visible = false;
			
			handReceivingSprite = new FlxSprite(0, 0);
			handReceivingSprite.loadGraphic(handReceivingImage);
			//handReceivingSprite.makeGraphic(30, 30, 0xffffffaa);
			handReceivingSprite.visible = false;
			
			openHandCollider = new FlxSprite(0, 0);
			openHandCollider.makeGraphic(160, 200, 0xff000000);
			openHandCollider.alpha = 0.5
			
			cursorDotSprite = new FlxSprite(0, 0);
			cursorDotSprite.loadGraphic(cursorDotImage);
			cursorDotSprite.alpha = 0.1;
			cursorDotSprite.visible = false;
			
			cursorTrail = new FlxEmitter(0, 0, 8);
			cursorTrail.setXSpeed(0, 0);
			cursorTrail.setYSpeed(0, 0);
			cursorTrail.setRotation(0, 0);
			
			for (var i:int = 0; i < cursorTrail.maxSize; i++)
			{
				var cursorTrailParticle:CursorTrailParticle = new CursorTrailParticle(0.2, 0.1);
				cursorTrailParticle.loadGraphic(cursorDotImage);
				cursorTrail.add(cursorTrailParticle);
				cursorTrailParticle.kill();
			}
			
			cursor = handSprite;
			
			cameraPan01Timer = new FlxTimer();
			cameraPan02Timer = new FlxTimer();
			
			speedometerBar = new FlxSprite(speedometerXY.x, speedometerXY.y);
			speedometerBar.loadGraphic(speedometerImage);
			//speedometerBar.makeGraphic(speedometerWH.x, speedometerWH.y, 0xffffffff);
			//speedometerBar.setOriginToCorner();
			//speedometerBar.origin.y = speedometerWH.y;
			//speedometerBar.color = 0xaaffaa;
			//speedometerBar.scale.y = 0;
			speedometerWH.y = speedometerBar.height - 90;
			
			speedarrowSprite = new FlxSprite(speedometerXY.x + speedometerBar.width - 20, speedometerXY.y + speedometerWH.y);
			speedarrowSprite.loadGraphic(speedarrowImage);
			speedarrowSprite.visible = false;
			
			slowDownText = new FlxSprite(dispenserOffsetX + 320 - 206, 50);
			slowDownText.loadGraphic(SlowDownImage);
			//slowDownText = new FlxText(400, 200, 500, "SLOW DOWN");
			//slowDownText.size = 32;
			//slowDownText.outline = 0xff000000;
			//slowDownText.color = 0xffffffff;
			slowDownText.visible = false;
			
			sevenSprite = new FlxSprite(candyTargetX, candyTargetY);
			sevenSprite.loadGraphic(sevenImage);
			sevenSprite.scale.x = 0;
			sevenSprite.scale.y = 0;
			sevenSprite.visible = false;
			
			blackCover = new FlxSprite(0, 0);
			blackCover.makeGraphic(FlxG.worldBounds.right, FlxG.worldBounds.bottom, 0xff000000);
			blackCover.alpha = 0;
			
			finScreen = new FlxSprite(100, 200);
			finScreen.loadGraphic(finImage);
			finScreen.visible = false;
			
			var handleCenter:FlxPoint = new FlxPoint(dispenserHandle.x + dispenserHandle.width / 2.0,
														dispenserHandle.y + dispenserHandle.health / 2.0);
			turnInstructionsSprite = new FlxSprite(handleCenter.x - 194 / 2, handleCenter.y - 194 / 2);
			turnInstructionsSprite.loadGraphic(turnInstructionsImage);
			turnInstructionsSprite.alpha = 0;
			
			candyGroup = new FlxGroup();
			
			add(mallBackgroundSprite);
			
			add(dispenserSprite);
			add(flapSprite);
			add(flapUnderSprite);
			//add(coinFeed);
			//add(dispenserCollider);
			add(momHandSprite);
			add(coin);
			add(coinCover);
			add(dispenserHandle);
						
			add(handSprite);
			add(handCoinSprite);
			add(handTurnSprite);
			add(handReceivingSprite);
			add(cursorTrail);
			add(cursorDotSprite);
			//add(openHandCollider);
			add(candyGroup);
			add(sevenSprite);
			add(turnInstructionsSprite);
			add(speedometerBar);
			add(speedarrowSprite);
			add(slowDownText);
			add(blackCover);
			add(finScreen);
			
			var beatClip1:FlxSound = new FlxSound();
			beatClip1.loadEmbedded(beats1Sound, true);
			var beatClip2:FlxSound = new FlxSound();
			beatClip2.loadEmbedded(beats2Sound, true);
			var beatClip3:FlxSound = new FlxSound();
			beatClip3.loadEmbedded(beats3Sound, true);
			var beatClip4:FlxSound = new FlxSound();
			beatClip4.loadEmbedded(beats4Sound, true);
			var beatClip5:FlxSound = new FlxSound();
			beatClip5.loadEmbedded(beats5Sound, true);
			var beatClip6:FlxSound = new FlxSound();
			beatClip6.loadEmbedded(beats6Sound, true);
			
			beatClips = new Vector.<FlxSound>();
			beatClips.push(beatClip1);
			beatClips.push(beatClip2);
			beatClips.push(beatClip3);
			beatClips.push(beatClip4);
			beatClips.push(beatClip5);
			beatClips.push(beatClip6);
			
			FlxG.playMusic(mallBgSounds);
		}
		
		override public function update():void
		{
			if (!dispenseAnimation)
			{
			cursor.x = FlxG.mouse.x;
			cursor.y = FlxG.mouse.y;
			openHandCollider.x = FlxG.mouse.x - openHandCollider.width / 2;
			openHandCollider.y = FlxG.mouse.y - openHandCollider.height / 2;
			}
			if (cursorDotSprite.visible)
			{
				cursorTrail.x = cursor.x + cursor.width / 2;
				cursorTrail.y = cursor.y + cursor.height / 2;
				cursorTrail.emitParticle();
				
			}
			
			switch (gameMode)
			{
				case MODE_COIN: 
				{
					updateModeCoin();
					break;
				}
				case MODE_TURN: 
				{
					updateModeTurn();
					break;
				}
				
				case MODE_RECEIVE: 
				{
					if(!dispenseAnimation)
						updateModeReceive();
					else
						playDispenseAnimation();
					break;
				}
			}
			
			updateDispenserTurn();
			
			updateSpeedometer();
			
			super.update();
			
			updateCinematics();
			lastMouseXY = FlxG.mouse.getWorldPosition();
		}
		
		private function updateSpeedometer():void
		{
			if (gameMode == MODE_TURN)
			{
				slowDownTextCount += FlxG.elapsed;
				//slowdown sound: .836 seconds
				
				if (turnSpeedsIndex == 0)
				{
					var turnSpeedSum:Number = 0;
					for (var i:int = 0; i < turnSpeeds.length; i++)
					{
						turnSpeedSum += turnSpeeds[i];
					}
					
					averageTurnSpeed = turnSpeedSum / turnSpeeds.length;
				}
				var currentPercent:Number = (speedometerXY.y + speedometerBar.height - 40 - speedarrowSprite.y) / speedometerWH.y;
				var targetPercent:Number = Math.max(Math.min(averageTurnSpeed, speedometerMax) / speedometerMax, 0);
				var deltaPercent:Number = targetPercent - currentPercent;
				var newPercent:Number = currentPercent;
				if (deltaPercent < 0)
				{
					speedometerVelocity -= speedometerAcceleration;
					speedometerVelocity = Math.max(speedometerVelocity, -speedometerMaxVelocity);
				}
				else
				{
					speedometerVelocity += speedometerAcceleration;
					speedometerVelocity = Math.min(speedometerVelocity, speedometerMaxVelocity);
				}
				newPercent = currentPercent + (speedometerVelocity * Math.sqrt(Math.abs(deltaPercent)));
				
				newPercent = Math.max(newPercent, 0);
				newPercent = Math.min(newPercent, 1);
				speedarrowSprite.y = speedometerXY.y + speedometerBar.height - 40 - speedometerWH.y * newPercent;
				/*var redAmount:Number = 0;
				var greenAmount:Number = 0;
				greenAmount = Math.min(255, 255 * (2 - (newPercent * 2)));
				redAmount = Math.min(255, 255 * (newPercent * 2));
				speedometerBar.color = FlxU.makeColor(redAmount, greenAmount, 0);
				*/
				if (newPercent > 0.5)
				{
					if (!slowDownText.visible)
					{
						slowDownText.visible = true;
						slowDownTextCount = 0;
						slowDownSoundCount = 0;
					}
					slowDownTextScale = (slowDownTextScaleMax - 1) * (-0.5 * Math.cos(Math.PI * slowDownTextCount * slowDownTextRate) + 0.5) + 1;
					slowDownText.scale.x = slowDownTextScale;
					slowDownText.scale.y = slowDownTextScale;
					slowDownText.color =  FlxU.makeColorFromHSB(int(slowDownTextCount * 360) % 360, 1, 1);
					
					if (slowDownSoundCount < int(slowDownTextCount / 0.836) + 1)
					{
					slowDownSoundCount = int(slowDownTextCount / 0.836) + 1;
					FlxG.play(slowDownSound, 1.0, false);
					}
				}
				else
				{
					slowDownText.visible = false;
				}
			}
			else
			{
					slowDownText.visible = false;
					speedometerBar.visible = false;
					speedarrowSprite.visible = false;
			}
		}
		
		private function updateCinematics():void
		{
			if (cameraPan01)
			{
				FlxG.camera.x = -dispenserOffsetX * ( -0.5 * Math.cos(Math.PI * cameraPan01Timer.progress) + 0.5);
				momHandSprite.x = ( -momHandSprite.width - 0) * ( -0.5 * Math.cos(Math.PI * cameraPan01Timer.progress) + 0.5);
				
				if (cameraPan01Timer.finished)
				{
					cameraPan01 = false;
					FlxG.camera.x = -dispenserOffsetX;
					momHandSprite.x = -momHandSprite.width;
				}
			}
			if (cameraPan02)
			{
				cameraPan02Primed = false;
				FlxG.camera.y = -cameraPan02Y * (-0.5 * Math.cos(Math.PI * cameraPan02Timer.progress) + 0.5);
				if (cameraPan02Timer.finished)
				{
					
					cameraPan02 = false;
					FlxG.camera.y = -cameraPan02Y;
				}
			}
		}
		
		private function updateModeCoin():void
		{
			if (FlxG.mouse.justPressed() && coin.overlaps(openHandCollider))
			{
				coinIsHeld = true;
				
				remove(coin);
				cursor.visible = false;
				cursor = handCoinSprite;
				cursor.visible = true;
				
				cameraPan01 = true;
				cameraPan01Timer.start(1.0);
			}
			if (FlxG.mouse.justPressed() && coinIsHeld && cursor.overlaps(coinFeed))
			{
				cursor.visible = false;
				cursor = handSprite;
				cursor.visible = true;
				gameMode = MODE_TURN;
				coinIsHeld = false;
				add(coin);
				coin.x = FlxG.width / 2 - 48 / 2 + dispenserOffsetX;
				coin.y = 140;
				coin.origin.y += 480 / 2 - 140;
			}
		}
		
		private function updateModeTurn():void
		{
		
		}
		
		private function updateModeReceive():void
		{
			if (cameraPan02Primed && handleIsHeld == false)
			{
				cameraPan02Timer.start(1.0);
				cameraPan02 = true;
			}
			if (!handleIsHeld)
			{
				if (openHandCollider.overlaps(flapSprite))
				{
					if (cursor != handReceivingSprite)
					{
						cursor.visible = false;
						cursor = handReceivingSprite;
						cursor.visible = true;
					}
					if (!dispenseAnimation && FlxG.mouse.justPressed())
					{
						FlxG.play(hingeSqueakSound);
						cursor.visible = false;
						cursor = handReceivingSprite;
						cursor.visible = true;
						
						dispenseAnimation = true;
						dispenseAnimationTime = 0;
						dispenseCursorBeginX = cursor.x;
						dispenseCursorBeginY = cursor.y;
						candyCount += int(Math.random() * candyCountVariance);
						for (var i:int = 0; i < candyCount; i++)
						{
							var candy:FlxSprite = new FlxSprite(candyBeginX, candyBeginY);
							var candyImageRand:Number = Math.random();
							if(candyImageRand <= 0.25)
								candy.loadGraphic(candy1Image);
							else if (candyImageRand > 0.25 && candyImageRand <= 0.5)
								candy.loadGraphic(candy2Image);
							else if (candyImageRand > 0.5 && candyImageRand <= 0.75)
								candy.loadGraphic(candy3Image);
							else
								candy.loadGraphic(candy4Image);
							var candyColorRand:Number = Math.random();
							if (candyColorRand <= 1 / 6)
								candy.color = 0x1eb227;
							else if (candyColorRand > 1 / 6 && candyColorRand <= 2 / 6)
								candy.color = 0xfe501a;
							else if (candyColorRand > 2 / 6 && candyColorRand <= 3 / 6)
								candy.color = 0x0268de;
							else if (candyColorRand > 3 / 6 && candyColorRand <= 4 / 6)
								candy.color = 0xf6d806;
							else if (candyColorRand > 4 / 6 && candyColorRand <= 5 / 6)
								candy.color = 0xf0202a;
							else
								candy.color = 0x441e16;
								
							//candy.color = FlxU.makeColorFromHSB(Math.random() * 360, 1, 1);
							candy.kill();
							var candyPos:FlxPoint = new FlxPoint(candyTargetX + (Math.random() - 0.5) * candySpreadX,
																	candyTargetY + (Math.random() - 0.5) * candySpreadY);
							candyPosition.push(candyPos);
							var timeOffset:Number = 0;
							if (i < candyCount - 1)
								timeOffset = Math.random() * candyDropTimeSpread;
							else //the last always falls out a bit later
								timeOffset = candyDropTimeSpread * 5;
							candyTimes.push((((candyDropDuration - candyDropTimeSpread) / candyCount) * i) + timeOffset);
							candyGroup.add(candy);
						}
					}
				}
				else
				{
					if (cursor != handSprite)
					{
						cursor.visible = false;
						cursor = handSprite;
						cursor.visible = true;
					}
				}
			}
		}
		
		private var dispenseCursorBeginX:Number = 0;
		private var dispenseCursorBeginY:Number = 0;
		private var dispenseCursorTargetX:Number = 385;
		private var dispenseCursorTargetY:Number = 470;
		private var currentCandyCount:int = 0;
		private var candyDropDuration:Number = 2;
		private var candyDropTimeSpread:Number = 0.3;
		private var candyBeginX:Number = 460;
		private var candyBeginY:Number = 410;
		private var candyTargetX:Number = 460;
		private var candyTargetY:Number = 540;
		private var candySpreadX:Number = 70;
		private var candySpreadY:Number = 70;
		private var candyTimes:Vector.<Number>;
		private var candyPosition:Vector.<FlxPoint>;
		private var hasPartyBegun:Boolean = false;
		
		private var sevenBeginPoint:FlxPoint = new FlxPoint(485 - 250 / 2, 470);
		private var sevenEndPoint:FlxPoint = new FlxPoint(485 - 250 / 2, 270);
		
		private var isgameEnding:Boolean = false;
		
		private function playDispenseAnimation():void
		{
			dispenseAnimationTime += FlxG.elapsed;
			if (dispenseAnimationTime <= 0.5)
			{
				flapSprite.scale.y = 1 - dispenseAnimationTime * 2;
			}
			if (dispenseAnimationTime > 0.5 && dispenseAnimationTime < 1)
			{
				flapSprite.visible = false;
				flapUnderSprite.visible = true;
				flapUnderSprite.scale.y = (dispenseAnimationTime - 0.5 ) * 2;
			}
			
			if (dispenseAnimationTime < 1)
			{
				cursor.x = sinInterpolate(dispenseCursorBeginX, dispenseCursorTargetX, dispenseAnimationTime);
				cursor.y = sinInterpolate(dispenseCursorBeginY, dispenseCursorTargetY, dispenseAnimationTime);
			}
			while (currentCandyCount < candyCount && dispenseAnimationTime > candyTimes[currentCandyCount] + 1)
			{
				(candyGroup.members[currentCandyCount] as FlxSprite).revive();
				currentCandyCount++;
				FlxG.play(candyDropSound);
			}
			var beginPartyTime:Number = candyTimes[candyTimes.length - 1] + 3;
			if (dispenseAnimationTime > beginPartyTime  && dispenseAnimationTime < beginPartyTime + 1)
			{
				if (!hasPartyBegun)
				{
					hasPartyBegun = true;
					sevenSprite.visible = true;
					FlxG.play(partyHornSound);
					FlxG.music.stop();
				}
				sevenSprite.x = sinInterpolate(sevenBeginPoint.x, sevenEndPoint.x, dispenseAnimationTime - beginPartyTime);
				sevenSprite.y = sinInterpolate(sevenBeginPoint.y, sevenEndPoint.y, dispenseAnimationTime - beginPartyTime);
				
				sevenSprite.scale.x = sinInterpolate(0, .5, dispenseAnimationTime - beginPartyTime);
				sevenSprite.scale.y = sinInterpolate(0, .5, dispenseAnimationTime - beginPartyTime);
			}
			
			if (dispenseAnimationTime > beginPartyTime + 3  && dispenseAnimationTime < beginPartyTime + 4)
			{
				sevenSprite.scale.x = sinInterpolate(0, .5, dispenseAnimationTime - beginPartyTime + 4);
				sevenSprite.scale.y = sinInterpolate(0, .5, dispenseAnimationTime - beginPartyTime + 4);
				
			}
			
			if (dispenseAnimationTime > beginPartyTime  && dispenseAnimationTime < beginPartyTime + 4)
			{
				sevenSprite.color =  FlxU.makeColorFromHSB(int(dispenseAnimationTime * 360) % 360, 1, 1);
			}
			
			if (dispenseAnimationTime > beginPartyTime + 3  && dispenseAnimationTime < beginPartyTime + 4)
			{
				blackCover.alpha = dispenseAnimationTime - (beginPartyTime + 3);
			}
			
			if (dispenseAnimationTime > beginPartyTime + 3.5  && dispenseAnimationTime < beginPartyTime + 4)
			{
				if (!isgameEnding)
				{
					isgameEnding = true;
					FlxG.play(sadSound);
				}
			}
			
			if (dispenseAnimationTime > beginPartyTime + 4)
			{
				finScreen.visible = true;
			}
			
			//update candy positions
			var candyFallTime:Number = 0.5;
			for (var i:int; i < currentCandyCount; i++)
			{
				var candy:FlxSprite = (candyGroup.members[i] as FlxSprite);
				var movePercent:Number = (dispenseAnimationTime - 1 - candyTimes[i]) / candyFallTime;
				movePercent = Math.min(1, movePercent);
				candy.y = (candyBeginY - candyPosition[i].y) * ( -1 / 2 * (movePercent + 2) * (movePercent - 1)) + candyPosition[i].y;
				candy.x = candyBeginX + (candyPosition[i].x - candyBeginX) * movePercent;
				//candy.y = candyBeginY + (candyPosition[i].y - candyBeginY) * movePercent;
			}
			/*
			if (dispenseAnimationTime >= 1 && dispenseAnimationTime < 1 + candyDropDuration)
			{
				
			}
			*/
		}
		
		private function sinInterpolate(begin:Number, end:Number, t:Number):Number
		{
			return (end - begin) * ( -0.5 * Math.cos(Math.PI * t) + 0.5) + begin;
		}
		
		private function updateDispenserTurn():void
		{
			turnInstructionsSprite.angle += 30 * FlxG.elapsed;
			if (FlxG.mouse.justPressed() && dispenserCollider.overlapsPoint(FlxG.mouse.getWorldPosition()))
			{
				handleIsHeld = true;
				cursor.visible = false;
				cursor = cursorDotSprite;
				cursor.visible = true;
				handTurnSprite.visible = true;
				if (gameMode == MODE_TURN)
				{
					beatClips[beatCount].play();
					speedometerBar.visible = true;
					speedarrowSprite.visible = true;
					FlxG.music.volume = 0.25;
					if (totalTheta < 90)
					{
					turnInstructionsSprite.alpha = 0.5;
					turnInstructionsSprite.angle = 0;
					}
				}
			}
			if (!FlxG.mouse.pressed() || !dispenserCollider.overlapsPoint(FlxG.mouse.getWorldPosition()))
			{
				if (handleIsHeld)
				{
					cursor.visible = false;
					if (coinIsHeld)
						cursor = handCoinSprite;
					else
						cursor = handSprite;
					cursor.visible = true;
					handTurnSprite.visible = false;
					beatClips[beatCount].stop();
					
					speedometerBar.visible = false;
					speedarrowSprite.visible = false;
					FlxG.music.volume = 1;
					turnInstructionsSprite.alpha = 0;
				}
				handleIsHeld = false;
			}
			if (handleIsHeld)
			{
				var mouseDelta:FlxPoint = new FlxPoint(FlxG.mouse.x - lastMouseXY.x, FlxG.mouse.y - lastMouseXY.y);
				var handleCenter:FlxPoint = new FlxPoint(dispenserHandle.x + dispenserHandle.width / 2.0, dispenserHandle.y + dispenserHandle.health / 2.0);
				var lastMouseTranslated:FlxPoint = new FlxPoint(lastMouseXY.x - handleCenter.x, lastMouseXY.y - handleCenter.y);
				var mouseTranslated:FlxPoint = new FlxPoint(FlxG.mouse.x - handleCenter.x, FlxG.mouse.y - handleCenter.y);
				var thetaInitial:Number = Math.atan2(lastMouseTranslated.y, lastMouseTranslated.x);
				var thetaFinal:Number = Math.atan2(mouseTranslated.y, mouseTranslated.x);
				var deltaTheta:Number = thetaFinal - thetaInitial;
				while (deltaTheta > Math.PI)
				{
					deltaTheta -= Math.PI * 2;
				}
				while (deltaTheta < -Math.PI)
				{
					deltaTheta += Math.PI * 2;
				}
				
				deltaTheta = deltaTheta * 180.0 / Math.PI;
				
				var newTheta:Number = totalTheta + deltaTheta;
				if (gameMode == MODE_TURN && int(newTheta / snapAmount) < currentSnap)
				{
					deltaTheta = 0;
					totalTheta = currentSnap * snapAmount;
				}
				else if (gameMode == MODE_TURN && int(totalTheta / snapAmount) < int(newTheta * snapAmount))
				{
					var oldSnap:int = currentSnap;
					currentSnap = int(newTheta / snapAmount);
					if (oldSnap < currentSnap && currentSnap % 2 == 0)
					{
						FlxG.play(clickSound);
					}
						if (newTheta > beatCount * goalTheta / 5)
						{
							beatClips[beatCount].stop();
							if (beatCount < 5)
							{
								beatCount++;
								beatClips[beatCount].play();
							}
						}
				}
				totalTheta += deltaTheta;
				if(deltaTheta > 0)
					turnInstructionsSprite.alpha = Math.max(0, turnInstructionsSprite.alpha - deltaTheta / 360 * 10);
				if (totalTheta < 0)
					totalTheta = 0;
				
				if (gameMode == MODE_TURN && totalTheta >= goalTheta)
				{
					gameMode = MODE_RECEIVE;
					totalTheta = 0;
					cameraPan02Primed = true;
					FlxG.play(finaleSound);
				}
				if ((gameMode == MODE_COIN || gameMode == MODE_RECEIVE) && totalTheta > snapbackThetaMax)
				{
					totalTheta = snapbackThetaMax;
				}
				
				
				
				//cursor.x = dispenserHandle.x + dispenserHandle.width / 2;
				//cursor.y = dispenserHandle.y + dispenserHandle.height / 2;
				//cursor.angle = dispenserHandle.angle;
				handTurnSprite.angle = dispenserHandle.angle;
				
				//145x120
				//56x24
				//r = 61
				//43 x 43
				if (gameMode == MODE_TURN)
				{
					
					turnSpeeds[turnSpeedsIndex] = deltaTheta / FlxG.elapsed;
					turnSpeedsIndex++;
					if (turnSpeedsIndex >= turnSpeeds.length)
						turnSpeedsIndex = 0;
				}
			}
			else if ((gameMode == MODE_COIN || gameMode == MODE_RECEIVE) && totalTheta > 0)
			{
				totalTheta -= 10;
				if (totalTheta < 0)
					totalTheta = 0;
			}
			else
			{
				if (gameMode == MODE_TURN)
				{
					
					turnSpeeds[turnSpeedsIndex] = 0;
					turnSpeedsIndex++;
					if (turnSpeedsIndex >= turnSpeeds.length)
						turnSpeedsIndex = 0;
				}
			}
			dispenserHandle.angle = totalTheta;
			if (gameMode == MODE_TURN)
			{
				coin.angle = totalTheta;
				if (coin.angle > 20)
					remove(coin);
			}
		}
		
		/*
		   private function pointCollidesWithHandle(point:FlxPoint):Boolean
		   {
		   if (dispenserCollider.overlapsPoint(point))
		   {
		   //check rotated rect
		   var angleRad = dispenserHandle.angle * Math.PI / 180.0;
		   var x1 = dispenserHandle.x;
		   var y1 = dispenserHandle.y;
		   var w1 = dispenserHandle.width;
		   var h1 = dispenserHandle.height;
		   var centerX = x1 + w1 / 2.0;
		   var centerY = y1 + h1 / 2.0;
		   //corners
		   //origin = centerX, centerY
		   var bl:FlxPoint = calcRotatedPoint(x1, y1 + h1, centerX, centerY, angleRad);
		   var br:FlxPoint = calcRotatedPoint(x1 + w1, y1 + h1, centerX, centerY, angleRad);
		   var tl:FlxPoint = calcRotatedPoint(x1, y1, centerX, centerY, angleRad);
		   var tr:FlxPoint = calcRotatedPoint(x1 + w1, y1, centerX, centerY, angleRad);
		
		   while(bl.x > br.x)
		   {
		   var tempPoint:FlxPoint = new FlxPoint(bl.x, bl.y);
		   bl = br;
		   br = tr;
		   tr = tl;
		   tl = tempPoint;
		   }
		
		
		   var mTop:Number = (tr.y - tl.y) / (tr.x - tl.x);
		   var mLeft:Number = (bl.x - tl.x) / (bl.y - tl.y);
		   var mBottom:Number = (br.y - bl.y) / (br.x - bl.x);
		   var mRight:Number = (br.x - tr.x) / (br.y - tr.y);
		
		   if (point.y < mBottom * (point.x - bl.x) + bl.y && point.y > mTop * (point.x - tl.x) + tl.y &&
		   point.x > mLeft * (point.y - bl.y) + bl.x && point.x < mRight * (point.y - br.y) + br.x)
		   return true;
		
		   }
		   return false;
		   }
		 */
		private function swapPoints(p1:FlxPoint, p2:FlxPoint):void
		{
			var temp:FlxPoint = new FlxPoint(p1.x, p1.y);
			p1 = p2;
			p2 = temp;
		}
		
		private function swapNumbers(n1:Number, n2:Number):void
		{
			var temp:Number = n1;
			n1 = n2;
			n2 = temp;
		}
		
		//theta = radians
		private function calcRotatedPoint(x1:Number, y1:Number, centerX:Number, centerY:Number, theta:Number):FlxPoint
		{
			return calcRotatedPoint2(new FlxPoint(x1, y1), new FlxPoint(centerX, centerY), theta);
		}
		
		private function calcRotatedPoint2(point:FlxPoint, center:FlxPoint, theta:Number):FlxPoint
		{
			var x1:Number = point.x - center.x;
			var y1:Number = point.y - center.y;
			
			var x2:Number = x1 * Math.cos(theta) - y1 * Math.sin(theta);
			var y2:Number = x1 * Math.sin(theta) + y1 * Math.cos(theta);
			
			return new FlxPoint(x2 + center.x, y2 + center.y);
		}
	}

}