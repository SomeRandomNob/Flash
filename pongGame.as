package 
{
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.events.KeyboardEvent;

	public class pongGame extends MovieClip
	{

		public function pongGame()
		{
			var t:TextField = new TextField  ;//adds score to screen
			t.x = 250;
			t.y = 5;
			var tf:TextFormat = new TextFormat  ;
			t.text = String(sc1);
			t.textColor = 0xFFFFFF;
			t.setTextFormat(tf);
			addChild(t);

			var t2:TextField = new TextField  ;//adds score to screen
			t2.x = 290;
			t2.y = 5;
			var tf2:TextFormat = new TextFormat  ;
			t2.text = String(sc2);
			t2.textColor = 0xFFFFFF;
			t2.setTextFormat(tf2);
			addChild(t2);
			
			var l:line = new line; //adds the mid line
			l.x = 275;
			l.y = 200;
			l.rotation = 90;
			addChild(l);

			var r1:recs = new recs();//adds the rectangle to the screen
			r1.y = 200;
			r1.x = 20;
			r1.width = 24;
			r1.height = 125;
			addChild(r1);

			var r2:recs = new recs();//adds the rectangle to the screen
			r2.y = 200;
			r2.x = 530;
			r2.width = 24;
			r2.height = 125;
			addChild(r2);

			var b:ball = new ball();//constructs ball
			b.height = 30;
			b.width = 30;
			addChild(b);
			
			var sc1:int = 0;//sc1 will be p1 score
			var sc2:int = 0;//sc2 will be p2 score
			
			var dir1:String = "stop"; //sets default speed of paddles to stopped
			var dir2:String = "stop";

			var spdx:Number;
			var spdy:Number;
			
			function resetBall(){//sets the ball back to 
				b.x = 275;
				b.y = 200;
			}
			function newSpeed(side){//true is left side, false is right
				spdx = 10;
				spdy = Math.random() * 12;
				if (side) {
					spdx *= -1;
					spdy *= -1;
				}
			}
			newSpeed();//sets the initial speed
			resetBall();//sets the ball at mid point

			addEventListener(Event.ENTER_FRAME, ballBounce);//moving the ball around
			function ballBounce(e:Event) {
				if (dir1=="up"   && r2.y > 64) r2.y -= 8;//moves paddle (r1) up if direction is up
				if (dir1=="down" && r2.y <336) r2.y += 8;
				if (dir2=="up"   && r1.y > 64) r1.y -= 8;//moves paddle (r2) up if direction is up
				if (dir2=="down" && r1.y <336) r1.y += 8;
				trace(r1.y);
				b.x += spdx; //makes ball travel at current spdx value
				b.y += spdy;
				if (b.x >= 535){ //550 - radius of ball
					spdx *=  -1;//reverses the direction its traveling on x axis
					resetBall();
					sc1 +=  1;//add one score to p1
					newSpeed(false);
			}	if (b.y >= 385 || b.y <= 15) spdy *=  -1;//400 - radius of ball || radius of ball
				if (b.x <= 15)	{
					resetBall();
					sc2 +=  1;
					newSpeed(true);
			}	if (r1.hitTestObject(b)){//checks if ball hit r1's hitbox
					spdx *=  -1.05;//reverses the speed and increases it everytime it bounces back
					spdy = 5 * (b.y - r1.y) / 25; //b.y - r1.y gets the vertical distance between the ball and the paddle, then maths it and changes the spdy accordingly
					b.x +=  12;//if ball glitches too close to the rec, bounce it away
			}	if (r2.hitTestObject(b)){//checks if ball hit r2's hitbox
					spdx *=  -1.05;
					spdy = 5 * (b.y - r2.y) / 25;
					b.x -=  12;
			}	t.text = String(sc1);//refresh the score on screen
				t2.text = String(sc2);
				if (b.x <= 10) resetBall();
				if (b.x >= 540) resetBall();
		}	stage.addEventListener(KeyboardEvent.KEY_DOWN, downkey);
			function downkey(e:KeyboardEvent):void {//when certain keycode is down, change dir to match the direction.
				if (e.keyCode==38) dir1="up";  //'^'
				if (e.keyCode==40) dir1="down";//'v'
				if (e.keyCode==83) dir2="down";//'S'
				if (e.keyCode==87) dir2="up";  //'W'
		}	stage.addEventListener(KeyboardEvent.KEY_UP, upkey);
			function upkey(e:KeyboardEvent):void {
				if (e.keyCode == 38 || e.keyCode == 40) dir1="stop";//when you're not holding any keys, stay in place
				if (e.keyCode == 87 || e.keyCode == 83) dir2="stop";
			}
		}

	}
}