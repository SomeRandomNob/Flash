package 
{
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.events.KeyboardEvent;
	import flash.media.Sound; 
	public class brickBreaker extends MovieClip
	{

		public function brickBreaker()
		{
			//variables
			var p:pad = new pad  ;//this is the paddle
			p.y = 585;
			p.width = 80;
			p.height = 12;
			addChild(p);

			var wsh:Sound = new woosh();

			var bArray:Array = new Array  ;
			var num:Number = 0;

			var t:TextField = new TextField  ;//adds score to screen
			t.x = 360;
			t.y = 100;
			var tf:TextFormat = new TextFormat  ;
			t.text = String(lives);//the variable lives will be printed to screen
			tf.color = 0xFFFFFF;
			t.setTextFormat(tf);
			addChild(t);

			var b:ball = new ball  ;
			b.height = 24;
			b.width = 24;
			addChild(b);

			var lives:Number = 4;//keeps track of lives, start one number above amount of lives you want

			var spdx:Number = 8;
			var spdy:Number = 8;

			for (var i:Number = 0; i < 3; i++)//change the 3 depending on how many rows of blocks you want
			{
				for (var j:Number = 0; j < 7; j++)//change the 7 for amount of collums
				{
					var br:block = new block  ;
					bArray.push(br);
					addChild(br);

					bArray[num].x = j * 55 + 10;//10 is the distance between the first block and side of stage
					bArray[num].y = i * 25 + 5;//25 is distance between the blocks, block is 20 high so 5 apart
					num++;
				}
			}
			function resetBall()
			{//sets the ball back to the paddle
				b.x = p.x;
				b.y = p.y - 5;
			}
			resetBall();

			addEventListener(Event.ENTER_FRAME,gameLoop);
			function gameLoop(e:Event)
			{
				p.x = mouseX;//this line moves the paddle to the mouses x coord if its onscreen
				if (p.x < 40) p.x = 40;
				if (p.x > 360) p.x = 360;
				b.x +=  spdx;
				b.y +=  spdy;
				for (var i:Number = 0; i < num; i++)
				{
					if (b.hitTestObject(bArray[i]))
					{                    //bArray[i].x + (bArray[i].width / 2)
						spdx = 5 * (b.x - (bArray[i].x + 25)) / 25;//angle code for brick, make sure its before code that moves it off screen
						bArray[i].x +=  500;//moves brick off screen
						spdy *=  -1;
						wsh.play();
						break;
					}
				}
				if (p.hitTestObject(b))//hitbox for paddle
				{
					spdy *=  -1;
					spdx  = 5 * (b.x - p.x) / 40; //angle on paddle
					b.y  -=  6
				}
				if (b.y <= 12)
				{
					spdy *=  -1;
				}
				if (b.y >= 600)
				{
					resetBall();//runs the resetBall function
					lives -= 1;
				}
				if (((spdx < 0) && b.x < 12))
				{
					spdx *=  -1;
				}
				if (b.x >= 388 && spdx > 0)
				{
					spdx *=  -1;
				}
				t.text = String(lives);//refreshes lives
			}

		}
	}
}