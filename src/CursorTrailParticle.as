package  
{
	/**
	 * ...
	 * @author Elliot
	 */
	import org.flixel.FlxParticle;
	import org.flixel.FlxG;
	public class CursorTrailParticle extends FlxParticle
	{
		public var m_fadeTime:Number;
		private var m_fadeTimeRemaining:Number;
		public var m_startAlpha:Number;
		public function CursorTrailParticle(fadeTime:Number, startAlpha:Number) 
		{
			m_fadeTime = fadeTime;
			m_fadeTimeRemaining = fadeTime;
			m_startAlpha = startAlpha;
			alpha = startAlpha;
			super();
			
		}
		
		override public function update():void
		{
			m_fadeTimeRemaining -= FlxG.elapsed;
			if (m_fadeTimeRemaining < 0)
				this.kill();
			this.alpha = m_startAlpha * (m_fadeTimeRemaining / m_fadeTime);
			super.update();
		}
		
		override public function reset(X:Number, Y:Number):void
		{
			super.reset(X,Y);
			m_fadeTimeRemaining = m_fadeTime;
			alpha = m_startAlpha;
		}
		
	}

}