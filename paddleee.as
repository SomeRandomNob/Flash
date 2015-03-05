package  {
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.events.KeyboardEvent;
	public class paddleee extends MovieClip{

		public function paddleee() {
			var p:padd = new padd;
			p.x = 500;
			p.y = 25;
			p.width = 10;
			p.height = 50;
			addChild(p);
			var dir1:String = "stop"; //sets default speed of paddles to stopped
		
			addEventListener(Event.ENTER_FRAME, ballBounce);//moving the ball around
			function ballBounce(e:Event) {
				if (dir1=="up"   && p.y > 25) p.y -= 8;//moves paddle (r1) up if direction is up
				if (dir1=="down" && p.y < 375) p.y += 8;
		}
		stage.addEventListener(KeyboardEvent.KEY_DOWN, downkey);
			function downkey(e:KeyboardEvent):void {//when certain keycode is down, change dir to match the direction.
				if (e.keyCode==38) dir1="up";  //'^'
				if (e.keyCode==40) dir1="down";//'v'
		}	stage.addEventListener(KeyboardEvent.KEY_UP, upkey);
			function upkey(e:KeyboardEvent):void {
				if (e.keyCode == 38 || e.keyCode == 40) dir1="stop";//when you're not holding any keys, stay in place
			}
	}
	
}
}