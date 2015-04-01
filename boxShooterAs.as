package 
{
	import flash.events.MouseEvent;
	import flash.display.MovieClip;
	import flash.events.Event;
	public class boxShooterAs extends MovieClip
	{

		public function boxShooterAs()
		{

			var bA:Array = new Array  ;
			var fire:Boolean = false;
			var num:Number = 0;

			addEventListener(Event.ENTER_FRAME,gameLoop);
			function gameLoop(e:Event)
			{
				shootStuff();
				moveShit();
			}
			stage.addEventListener(MouseEvent.CLICK,clickFun);
			function clickFun(e:MouseEvent)
			{
				fire = true;
			}
			function shootStuff()
			{
				if (fire == true)
				{
					var b:box = new box  ;
					bA.push(b);
					addChild(bA[num]);
					bA[num].x = 20;
					bA[num].y = Math.random() * 400;
					fire = false;
					num++;
				}
			}
			function moveShit()
			{
				for (var i:Number = 0; i < num; i++)
				{
					bA[i].x +=  5;
					if (bA[i].x > 540) {
						removeChild(bA[i]);
						bA.shift();
						num--;
						
					}
					
				}
				
			}
		}

	}

}