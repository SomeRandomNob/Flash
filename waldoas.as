package  {
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	
	public class waldoas extends MovieClip{

		public function waldoas() {
			var i:Number;
			var w:waldita = new waldita;
			w.x = Math.random() * 550;
			w.y = Math.random() * 400;
			addChild(w);
			
			w.addEventListener(MouseEvent.CLICK, gameLoop);
			function gameLoop(e:Event)
			{
				trace("You found it!");
			}
			for (i = 0; i < 1000; i++)
			{
				var wd:waldor = new waldor;
				wd.x = Math.random() * 550;
				wd.y = Math.random() * 400;
				addChild(wd);
				trace(i);
				addChild(w);
			}
			
			
		}

	}
	
}
